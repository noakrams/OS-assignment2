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
struct spinlock pid_lock;
struct spinlock chanel;

extern void forkret(void);
extern void handling_signals();

void start_ret();
void end_ret();

static void freeproc(struct proc *p);

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
      p->kstack = KSTACK((int) (p - proc));
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

int
allocpid() {
  int pid;
  
  acquire(&pid_lock);
  pid = nextpid;
  nextpid = nextpid + 1;
  release(&pid_lock);

  return pid;
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

  // Allocate a trapframe page.
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    freeproc(p);
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
    release(&p->lock);
    return 0;
  }

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof(p->context));
  p->context.ra = (uint64)forkret;
  p->context.sp = p->kstack + PGSIZE;

  return p;
}

// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
  if(p->trapframe)
    kfree((void*)p->trapframe);
  p->trapframe = 0;
  if(p->pagetable)
    proc_freepagetable(p->pagetable, p->sz);
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->chan = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
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
              (uint64)(p->trapframe), PTE_R | PTE_W) < 0){
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
  p->trapframe->epc = 0;      // user program counter
  p->trapframe->sp = PGSIZE;  // user stack pointer

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

  p->state = RUNNABLE;

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

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;
  np->signalMask = p->signalMask; //inherit signal mask from parent
  for (int i = 0; i<32; i++) //inherit signal handlers from parent
    np->signalHandlers[i] = p->signalHandlers[i]; 

  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;

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
  
  np->state = RUNNABLE;
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
  struct proc *p;
  struct cpu *c = mycpu();
  
  c->proc = 0;
  for(;;){
    // Avoid deadlock by ensuring that devices can interrupt.
    intr_on();

    for(p = proc; p < &proc[NPROC]; p++) {
      acquire(&p->lock);
      if(p->state == RUNNABLE) {
        // Switch to chosen process.  It is the process's job
        // to release its lock and then reacquire it
        // before jumping back to us.
        p->state = RUNNING;
        c->proc = p;
        swtch(&c->context, &p->context);

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
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
  int intena;
  struct proc *p = myproc();

  if(!holding(&p->lock))
    panic("sched p->lock");
  if(mycpu()->noff != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(intr_get())
    panic("sched interruptible");

  intena = mycpu()->intena;
  swtch(&p->context, &mycpu()->context);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  struct proc *p = myproc();
  acquire(&p->lock);
  p->state = RUNNABLE;
  sched();
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
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

  usertrapret();
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  // Must acquire p->lock in order to
  // change p->state and then call sched.
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
  release(lk);

  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  release(&p->lock);
  acquire(lk);
}

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
        p->state = RUNNABLE;
      }
      release(&p->lock);
    }
  }
}

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid, int signum)
{
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
  printf("sig ret\n");
  *p->trapframe = p->UserTrapFrameBackup;
  // memmove(p->trapframe, p->UserTrapFrameBackup, sizeof(struct trapframe));
  // if(copyin(p->pagetable,(char*)p->trapframe, (uint64)p->UserTrapFrameBackup, sizeof(struct trapframe)) < 0)
  // printf("fopyin doesnt work\n");
  p->signalMask = p->signal_mask_backup;
  p->ignore_signals = 0;
}

void usersignal(struct proc *p, int signum){

  // Extract sigmask from sigaction, and backup the old signal mask
  p->signal_mask_backup = p->signalMask;
  p->signalMask = p->maskHandlers[signum];

  // indicate that the process is at "signal handling" by turn on a flag
  p->ignore_signals = 1;

  // copy the current process trapframe, to the trapframe backup 
  memmove(&p->UserTrapFrameBackup, p->trapframe, sizeof(struct trapframe));

  // Extract handler from signalHandlers, and updated saved user pc to point to signal handler
  p->trapframe->epc = (uint64)p->signalHandlers[signum];

  // Calculate the size of sig_ret
  uint sigret_size = end_ret - start_ret;

  // Reduce stack pointer by size of function sigret and copy out function to user stack
  p->trapframe->sp -= sigret_size;
  copyout(p->pagetable, p->trapframe->sp, (char *)&start_ret, sigret_size);

  // parameter = signum
  p->trapframe->a0 = signum;

  // update return address so that after handler finishes it will jump to sigret  
  p->trapframe->ra = p->trapframe->sp;

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
        usersignal(p, sig);
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
