#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "sigaction.h"


struct cpu cpus[NCPU];

struct proc proc[NPROC];

struct proc *initproc;

int nextpid = 1;
int nexttid = 1;

struct spinlock pid_lock;
struct spinlock tid_lock;
struct spinlock join_thread;

struct spinlock chanel;

extern void forkret(void);
extern void handling_signals();

void start_ret();
void end_ret();

static void freeproc(struct proc *p);
static void freethread(struct thread *t);

extern char trampoline[]; // trampoline.S

// helps ensure that wakeups of wait()ing
// parents are not lost. helps obey the
// memory model when using p->parent.
// must be acquired before any p->lock.
struct spinlock wait_lock;


// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
  }
}

// initialize the proc table at boot time.
void
procinit(void)
{
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
  initlock(&wait_lock, "wait_lock");
  for(p = proc; p < &proc[NPROC]; p++) {
      initlock(&p->lock, "proc");
      p->threads->kstack = KSTACK((int) (p - proc)); // Initialize the first thread of each process
  }
}

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
  int id = r_tp();
  return id;
}

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
  int id = cpuid();
  struct cpu *c = &cpus[id];
  return c;
}

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
  push_off();
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
  pop_off();
  return p;
}

// Return the current struct thread *, or zero if none.
struct thread*
mythread(void) {
  push_off();
  struct cpu *c = mycpu();
  struct thread *t = c->thread;
  pop_off();
  return t;
}

int
allocpid() {
  int pid;
  
  acquire(&pid_lock);
  pid = nextpid;
  nextpid = nextpid + 1;
  release(&pid_lock);

  return pid;
}

int
alloctid() {
  int tid;
  
  acquire(&tid_lock);
  tid = nexttid;
  nexttid = nexttid + 1;
  release(&tid_lock);

  return tid;
}

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel,
// and return with p->lock held.
// If there are no free procs, or a memory allocation fails, return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->state == UNUSED) {
      goto found;
    } else {
      release(&p->lock);
    }
  }
  return 0;

found:
  p->pid = allocpid();
  p->state = USED;
  p->pendingSignals = 0;
  p->signalMask = 0;
  p->stopped = 0;
  p->signal_mask_backup = 0;
  p->ignore_signals = 0;

  // set default handler for all the signals
  for(int i = 0; i<32 ; i++)
    p->signalHandlers[i] = SIG_DFL;

  // set default values for signal
  memset(p->signalHandlers, SIG_DFL, sizeof(p->signalHandlers));
  memset(p->maskHandlers, 0, sizeof(p->maskHandlers));

  // set the main thread
  p->main_thread = p->threads;
  p->main_thread->tid = alloctid();
  p->main_thread->state = USED;
  p->main_thread->proc_parent = p;

  // Allocate a trapframe page.
  if((p->main_thread->trapframe = (struct trapframe *)kalloc()) == 0){
    freeproc(p);
    freethread(p->main_thread);
    release(&p->lock);
    return 0;
  }

  // Allocate a backup trapframe page.
  // if((p->UserTrapFrameBackup = (struct trapframe *)kalloc()) == 0){
  //   freeproc(p);
  //   release(&p->lock);
  //   return 0;
  // }

  // An empty user page table.
  p->pagetable = proc_pagetable(p);
  if(p->pagetable == 0){
    freeproc(p);
    freethread(p->main_thread);
    release(&p->lock);
    return 0;
  }

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->main_thread->context, 0, sizeof(p->main_thread->context));
  p->main_thread->context.ra = (uint64)forkret;
  p->main_thread->context.sp = p->main_thread->kstack + PGSIZE;
  return p;
}

// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
  if(p->pagetable)
    proc_freepagetable(p->pagetable, p->sz);
  if(p->threads->trapframe)
    kfree((void*)p->threads->trapframe);
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
}

// free a thread structure and the data hanging from it,
// including user pages.
// t->lock must be held.
static void
freethread(struct thread *t)
{
  if(t->kstack && t!=t->proc_parent->threads)
    kfree((void*)t->kstack);
  t->trapframe = 0;
  t->tid = 0;
  t->thread_parent = 0;
  t->proc_parent = 0;
  t->name[0] = 0;
  t->chan = 0;
  t->killed = 0;
  t->xstate = 0;
  t->state = UNUSED;
}

// Create a user page table for a given process,
// with no user memory, but with trampoline pages.
pagetable_t
proc_pagetable(struct proc *p)
{
  pagetable_t pagetable;

  // An empty page table.
  pagetable = uvmcreate();
  if(pagetable == 0)
    return 0;

  // map the trampoline code (for system call return)
  // at the highest user virtual address.
  // only the supervisor uses it, on the way
  // to/from user space, so not PTE_U.
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
              (uint64)trampoline, PTE_R | PTE_X) < 0){
    uvmfree(pagetable, 0);
    return 0;
  }

  // map the trapframe just below TRAMPOLINE, for trampoline.S.
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
              (uint64)(p->main_thread->trapframe), PTE_R | PTE_W) < 0){
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
  }

  return pagetable;
}

// Free a process's page table, and free the
// physical memory it refers to.
void
proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
  uvmfree(pagetable, sz);
}

// a user program that calls exec("/init")
// od -t xC initcode
uchar initcode[] = {
  0x17, 0x05, 0x00, 0x00, 0x13, 0x05, 0x45, 0x02,
  0x97, 0x05, 0x00, 0x00, 0x93, 0x85, 0x35, 0x02,
  0x93, 0x08, 0x70, 0x00, 0x73, 0x00, 0x00, 0x00,
  0x93, 0x08, 0x20, 0x00, 0x73, 0x00, 0x00, 0x00,
  0xef, 0xf0, 0x9f, 0xff, 0x2f, 0x69, 0x6e, 0x69,
  0x74, 0x00, 0x00, 0x24, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00
};

// Set up first user process.
void
userinit(void)
{
  struct proc *p;

  p = allocproc();
  initproc = p;
  
  // allocate one user page and copy init's instructions
  // and data into it.
  uvminit(p->pagetable, initcode, sizeof(initcode));
  p->sz = PGSIZE;

  // memset(p->trapframe, 0, sizeof(*p->trapframe)); ??
  // prepare for the very first "return" from kernel to user.
  p->main_thread->trapframe->epc = 0;      // user program counter
  p->main_thread->trapframe->sp = PGSIZE;  // user stack pointer

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  //ass2
  p->pendingSignals = 0;
  p->signalMask = 0;
  for (int i = 0; i < 32; i++) {
    p->signalHandlers[i] = SIG_DFL;
  }
  p->ignore_signals = 0;
  p->stopped = 0;

  //p->state = RUNNABLE;        //check if neccessery
  p->main_thread->state = RUNNABLE;

  release(&p->lock);
}

// Grow or shrink user memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *p = myproc();

  sz = p->sz;
  if(n > 0){
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
      return -1;
    }
  } else if(n < 0){
    sz = uvmdealloc(p->pagetable, sz, sz + n);
  }
  p->sz = sz;
  return 0;
}

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();
  struct thread *t = mythread();

  printf("debug: starting fork, tid %d, pid %d\n\n", t->tid, p->pid);
  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    freeproc(np);
    freethread(np->main_thread);
    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;
  np->signalMask = p->signalMask; //inherit signal mask from parent
  for (int i = 0; i<32; i++) //inherit signal handlers from parent
    np->signalHandlers[i] = p->signalHandlers[i]; 

  // copy saved user registers (from current thread to main thread
  // of the new process). 
  *(np->main_thread->trapframe) = *(t->trapframe);

  // Cause fork to return 0 in the child.
  np->main_thread->trapframe->a0 = 0;

  // increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    if(p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->cwd = idup(p->cwd);

  safestrcpy(np->name, p->name, sizeof(p->name));

  pid = np->pid;

  release(&np->lock);

  acquire(&wait_lock);
  np->parent = p;
  release(&wait_lock);

  acquire(&np->lock);

  // ass2
  np->pendingSignals = 0;
  np->signalMask = p->signalMask;
  np->ignore_signals = 0;
  np->stopped = 0;
  
  np->main_thread->state = RUNNABLE;
  release(&np->lock);

  return pid;
}

// Pass p's abandoned children to init.
// Caller must hold wait_lock.
void
reparent(struct proc *p)
{
  struct proc *pp;

  for(pp = proc; pp < &proc[NPROC]; pp++){
    if(pp->parent == p){
      pp->parent = initproc;
      wakeup(initproc);
    }
  }
}

// Pass t's abandoned children to init.
// Caller must hold wait_lock.
void
Treparent(struct thread *t)
{
  struct thread *tt;
  struct proc *p = t->proc_parent;

  for(tt = p->threads; tt < &p->threads[NTHREAD]; tt++){
    printf("Treparent tid number: %d\n",tt->tid);
    if(tt->thread_parent == t && t!=p->main_thread){
      printf("found a children\n");
      tt->thread_parent = p->main_thread;
      wakeup(p->main_thread);
    }
      //change the main thread if neccessery
    else if (tt->thread_parent == t){
      p->main_thread = tt;
      printf("found a children\n");
    }
  }
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait().
void
exit(int status)
{
  struct proc *p = myproc();
  if(p == initproc)
    panic("init exiting");

  // Close all open files.
  for(int fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd]){
      struct file *f = p->ofile[fd];
      fileclose(f);
      p->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(p->cwd);
  end_op();
  p->cwd = 0;

  acquire(&wait_lock);

  // Give any children to init.
  reparent(p);

  // Parent might be sleeping in wait().
  wakeup(p->parent);
  
  acquire(&p->lock);

  p->xstate = status;
  p->state = ZOMBIE;

    // kill all the threads
  struct thread *t;
  for(t=p->threads; t < &p->threads[NTHREAD]; t++){
    t->state = ZOMBIE;
  }

  release(&wait_lock);
  // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(uint64 addr)
{
  //printf("debug: starting wait function\n");
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();

  acquire(&wait_lock);

  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(np = proc; np < &proc[NPROC]; np++){
      if(np->parent == p){
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if(np->state == ZOMBIE){
          // Found one.
          pid = np->pid;
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
                                  sizeof(np->xstate)) < 0) {
            release(&np->lock);
            release(&wait_lock);
            return -1;
          }
          freeproc(np);
          freethread(np->main_thread);
          release(&np->lock);
          release(&wait_lock);
          return pid;
        }
        release(&np->lock);
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || p->killed){
      release(&wait_lock);
      return -1;
    }
    
    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
  }
}

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void
scheduler(void)
{
  //printf("debug: starting scheduler\n");

  struct proc *p;
  struct thread *t;
  struct cpu *c = mycpu();
  c->proc = 0;
  c->thread = 0;
  for(;;){

    // Avoid deadlock by ensuring that devices can interrupt.
    intr_on();

    for(p = proc; p < &proc[NPROC]; p++) {
      acquire(&p->lock);
      for (t = p->threads; t < &p->threads[NTHREAD]; t++){
        if(t->state == RUNNABLE) {
          // Switch to chosen process.  It is the process's job
          // to release its lock and then reacquire it
          // before jumping back to us.
          t->state = RUNNING;
          c->thread = t;
          c->proc = p;
          //printf("debug: scheduler find runnable thread %d\nproc %d\ncontext value is %d\n\n", t->tid, p->pid, &t->context);
          swtch(&c->context, &t->context);
          //printf("debug: after swtch\n");
          // Process is done running for now.
          // It should have changed its p->state before coming back.
          c->proc = 0;
          c->thread = 0;
        }
      }
       release(&p->lock);
    }
  }
}

// Switch to scheduler.  Must hold only p->lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  //printf("debug: starting sched function\n");
  int intena;
  struct thread *t = mythread();
  if(!holding(&t->proc_parent->lock))
    panic("sched p->lock");
  if(mycpu()->noff != 1){
    panic("sched locks");
  }
  if(t->state == RUNNING)
    panic("sched running");
  if(intr_get())
    panic("sched interruptible");

  //printf("debug: inside sched function\n");
  intena = mycpu()->intena;
  swtch(&t->context, &mycpu()->context);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  //printf("debug: starting yield function\n");
  struct thread *t = mythread();
  acquire(&t->proc_parent->lock);
  t->state = RUNNABLE;
  sched();
  release(&t->proc_parent->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
  printf("debug: starting forkret function\npid %d\ntid %d\n\n", myproc()->pid, mythread()->tid);
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);

  if (first) {
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }
  printf("debug: finishing forkret\n");

  usertrapret();

}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  //printf("debug: lock:%s starting sleep function\n", lk->name);
  struct thread *t = mythread();
  
  // Must acquire p->lock in order to
  // change p->state and then call sched.
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&t->proc_parent->lock);  //DOC: sleeplock1
  release(lk);

  // Go to sleep.
  t->chan = chan;
  t->state = SLEEPING;

  sched();
  //printf("debug: lock:%s finish to sleep\n", lk->name);

  // Tidy up.
  t->chan = 0;

  // Reacquire original lock.
  release(&t->proc_parent->lock);
  acquire(lk);
  //printf("debug: exit from sleep function\n");
}

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
  //printf("debug: starting wakeup\n");
  struct proc *p;
  struct thread *t;

  for(p = proc; p < &proc[NPROC]; p++) {
    if(p != myproc()){
      acquire(&p->lock);
      for (t = p->threads; t < &p->threads[NTHREAD]; t++){
        if (t != mythread()){
          if(t->state == SLEEPING && t->chan == chan) {
            t->state = RUNNABLE;
          }
        }
      }
      release(&p->lock);
    }
  }
  //printf("debug: finishing wakeup\n");

}

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid, int signum)
{
  //printf("debug: starting kill function\n");
  struct proc *p;

  if(signum >= SIGNALS_SIZE || signum < 0) return -1;

  for(p = proc; p < &proc[NPROC]; p++){
    acquire(&p->lock);
    if(p->pid == pid){
      //2.2.1
      if(signum == SIGKILL){
        p->killed = 1; 
        if(p->state == SLEEPING){ //-----------------> Was in the previous version, according to the forum now it's redundant
          // Wake process from sleep().
          p->state = RUNNABLE;
        }
      }
      p->pendingSignals |= (1 << signum);

      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }
  return -1;
}

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
  struct proc *p = myproc();
  if(user_dst){
    return copyout(p->pagetable, dst, src, len);
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
  struct proc *p = myproc();
  if(user_src){
    return copyin(p->pagetable, dst, src, len);
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    printf("%d %s %s", p->pid, state, p->name);
    printf("\n");
  }
}

uint
sigprocmask(uint sigmask){

  struct proc* p = myproc ();
  uint oldMask = p->signalMask;
  p->signalMask = sigmask;
  return oldMask;
}

int
sigaction(int signum, const struct sigaction *act, struct sigaction *oldact){

  // printf ("signum is: %d\nact adress is: %d\noldact address is: %d\n", signum,act,oldact);
  // Check that signum in the correct range

  if (signum < 0 || signum >= 32)
    return -1;

  if (signum == SIGSTOP || signum == SIGKILL)
      return -1;

  struct proc* p = myproc ();
  acquire(&p->lock);

  if (oldact){

    struct sigaction oldSig;
    oldSig.sa_handler = p->signalHandlers[signum];
    oldSig.sigmask = p->maskHandlers[signum];

    if (copyout(p->pagetable, (uint64) oldact, (char*)&oldSig.sa_handler, sizeof(8)) < 0)
      return -1;

    if (copyout(p->pagetable, (uint64) oldact+8, (char*)&oldSig.sigmask, sizeof(uint)) < 0)
      return -1;  
  }
  if (act){
    struct sigaction newSig;
    if(copyin(p->pagetable,(char*)&newSig, (uint64)act, sizeof(struct sigaction))<0)
      return -1;

    if(newSig.sigmask <0)
      return -1;

    p->signalHandlers[signum] = newSig.sa_handler;

    p->maskHandlers[signum] = newSig.sigmask;
  }
  release(&p->lock);
  return 0;
}


void
sigret (void){
  struct proc* p = myproc();
  struct thread* t = mythread();
  printf("sig ret\n");
  *t->trapframe = t->UserTrapFrameBackup;
  // memmove(p->trapframe, p->UserTrapFrameBackup, sizeof(struct trapframe));
  // if(copyin(p->pagetable,(char*)p->trapframe, (uint64)p->UserTrapFrameBackup, sizeof(struct trapframe)) < 0)
  // printf("fopyin doesnt work\n");
  p->signalMask = p->signal_mask_backup;
  p->ignore_signals = 0;
}

void usersignal(struct thread *t, int signum){

  struct proc *p = t->proc_parent;
  // Extract sigmask from sigaction, and backup the old signal mask
  p->signal_mask_backup = p->signalMask;
  p->signalMask = p->maskHandlers[signum];

  // indicate that the process is at "signal handling" by turn on a flag
  p->ignore_signals = 1;

  // copy the current process trapframe, to the trapframe backup 
  memmove(&t->UserTrapFrameBackup, t->trapframe, sizeof(struct trapframe));

  // Extract handler from signalHandlers, and updated saved user pc to point to signal handler
  t->trapframe->epc = (uint64)p->signalHandlers[signum];

  // Calculate the size of sig_ret
  uint sigret_size = end_ret - start_ret;

  // Reduce stack pointer by size of function sigret and copy out function to user stack
  t->trapframe->sp -= sigret_size;
  copyout(p->pagetable, t->trapframe->sp, (char *)&start_ret, sigret_size);

  // parameter = signum
  t->trapframe->a0 = signum;

  // update return address so that after handler finishes it will jump to sigret  
  t->trapframe->ra = t->trapframe->sp;

}

void stopSignal(struct proc *p){

  p->stopped = 1;

}

void contSignal(struct proc *p){

  p->stopped = 0;

}


void handling_signals(){
  struct proc *p = myproc();

  // ass2
  
  // If first process or all signals are ignored -> return
  if((p == 0) || (p->signalMask == 0xffffffff) || p->ignore_signals) return;

  // Check if stopped and has a pending SIGCONT signal, if none are received, it will yield the CPU.
  if(p->stopped && !(p->signalMask & (1 << SIGSTOP))) {
    int cont_pend;
    while(1){   
      // acquire(&p->lock);
      cont_pend = p->pendingSignals & (1 << SIGCONT);
      if(cont_pend){
        p->stopped = 0;
        // Turn off the sigcont signal bit
        p->pendingSignals ^= (1 << SIGCONT);
        // release(&p->lock);
        break;
      }
      else{
        // release(&p->lock);
        yield();
      }
    }
  }

  for(int sig = 0 ; sig < SIGNALS_SIZE ; sig++){
    uint pandSigs = p->pendingSignals;
    uint sigMask = p->signalMask;
    // check if panding for the i'th signal and it's not blocked.
    if( (pandSigs & (1 << sig)) && !(sigMask & (1 << sig)) ){
      /* If default -> default actions for SIGSTOP, SIGCONT and SIGKILL
         For all other signals the default should be the SIGKILL behavior */
      if(p->signalHandlers[sig] == (void*)SIG_DFL){
        switch(sig)
        {
          case SIGSTOP:
            stopSignal(p);
            break;
          case SIGCONT:
            contSignal(p);
            break;
          default:
            kill(p->pid, SIGKILL);
            break;
        }
        //turning bit of pending singal off
        p->pendingSignals ^= (1 << sig); 
      }
      else if (p->signalHandlers[sig] != (void*)SIG_IGN){
        usersignal(mythread(), sig);
        p->pendingSignals ^= (1 << sig); //turning bit off
      }
    }
  }
}

// First all bsems initialized to -1 represent that they are not allocated.

int bsems[MAX_BSEM] = {[0 ... MAX_BSEM-1] = -1};

// Alloc bsem and make it a 1.

int bsem_alloc(){
  acquire(&pid_lock);
  for (int i = 0; i < MAX_BSEM; i++) {
	  if (bsems[i] == -1) {
	  	bsems[i] = 1;
      release(&pid_lock);
	  	return i;
	  } 
	}
  release(&pid_lock);
  return -1;
}

// Free bsem make it -1 again.

void bsem_free(int i){
  acquire(&pid_lock);
  bsems[i] = -1;
  release(&pid_lock);
}

/* While so that only one thread will continue. 
   sleep on chanel of kind spinlock, with lock pid_lock */

void bsem_down(int i){
  acquire(&pid_lock);
  while(bsems[i] == 0){
    sleep(&chanel, &pid_lock);
  }
  bsems[i] = 0;
  release(&pid_lock);
}

// Turn bsems[i] on and wake up thread that is sleeping on chanel and waiting for bsems[i].

void bsem_up(int i){
  acquire(&pid_lock);
  bsems[i] = 1;
  wakeup(&chanel);
  release(&pid_lock);
}

/*                       //
// Part 3.2 system calls //
//                       */

static struct thread*
allocthread(void ( *start_func)(), void *stack)
{

  struct thread *t;
  struct thread *curr_thread = mythread();
  struct proc *p = curr_thread->proc_parent;

  acquire(&p->lock);
  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
    if(t->state == UNUSED || t->state == ZOMBIE) {
      goto found;
    }
  }
  release(&p->lock);
  return 0;

  found:  

  t->tid = alloctid();
  t->state = USED;
  t->proc_parent = p;
  t->thread_parent = curr_thread;

  release(&p->lock);

    // Allocate a stack
  if((t->kstack = (uint64) kalloc()) == 0){
    freethread(t);
    release(&p->lock);
    return 0;
  }

    // Allocate a trapframe page.
  t->trapframe = p->threads->trapframe + (sizeof(struct trapframe) * (int)(t-p->threads));
  memmove ((void *) t->trapframe, (void*) curr_thread->trapframe, sizeof(struct trapframe));
  
  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&t->context, 0, sizeof(t->context));
  t->context.ra = (uint64)forkret;
  t->context.sp = t->kstack + PGSIZE;

  t->trapframe->epc = (uint64) start_func;
  t->trapframe->sp = (uint64) stack + MAX_STACK_SIZE; 

  return t;
}

int
kthread_create (void ( *start_func)(), void *stack ){
  struct thread *t = allocthread (start_func, stack);
  t->state = RUNNABLE;
  if(t == 0)
    return -1;
  return t->tid;
}

int
kthread_id(){
  return mythread()->tid;
}

void
kthread_exit(int status){
  struct thread *t = mythread();
  printf("inside exit for tid: %d\n", t->tid);
  struct proc *p = t->proc_parent;

  acquire(&wait_lock);

  Treparent (t);

    // Parent might be sleeping in wait().
  if(t->thread_parent)
    wakeup(t->thread_parent);

  t->xstate = status;
  t->state = ZOMBIE;
  printf("update status for tid: %d\n", t->tid);
    // Check if this is the last thread of the process
  struct thread * tt;
  acquire(&p->lock);
  for (tt = p->threads; tt < &p->threads[NTHREAD]; tt++){
      if(tt->state == USED || tt->state == SLEEPING || tt->state == RUNNABLE || tt->state == RUNNING){
        goto found;
      }
  }
    //not found an active thread, should terminate the process
  release(&p->lock);
  release(&wait_lock);
  exit(0);
  panic("zombie exit");

  found:
  release(&wait_lock);

    // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");
}

int
kthread_join (int thread_id, int *status){
  struct thread *t = mythread();
  struct proc *p = t->proc_parent;

    // Check if there's a thread with the thread_id
  struct thread * tt;
  acquire(&p->lock);
  for (tt = p->threads; tt < &p->threads[NTHREAD]; tt++){
    if(tt->tid == thread_id){
      goto found;
    } else {
    }
  }

    // Means didn't find a thread of the process with this ID
  release(&p->lock);
  return -1;

  found:
  release(&p->lock);

    // Cheak if this thread is already unused
  if (tt->state == UNUSED || ZOMBIE){
    return 0;
  }
  
  sleeping:
  sleep (t, &join_thread);
  if (tt->state == UNUSED || ZOMBIE){
    *status = tt->xstate; 
    return 0;
  }
  goto sleeping;

}