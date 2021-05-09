#include "kernel/sigaction.h"

#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"
#include "kernel/syscall.h"
#include "kernel/memlayout.h"
#include "kernel/riscv.h"
#include "Csemaphore.h"



#define SIG_DFL 0 /* default signal handling */
#define SIG_IGN 1 /* ignore signal */
#define SIGKILL 9
#define SIGSTOP 17
#define SIGCONT 19

int flag;

void handle(int signum){
    flag = signum;
    printf("handle -> signum: %d\n", signum);
}

void handle2(int signum){
    flag = signum;
    printf("handle2 -> signum: %d\n", signum);
}

void handle3(int signum){
    flag = signum;
    printf("in handle3, flag = %d\n", flag);
    printf("handle3 -> signum: %d\n", signum);
}

int wait_sig = 0;

void test_handler(int signum){
    wait_sig = 1;
    printf("Received sigtest\n");
}


void sigkillTest(void){
  
  int cpid = fork();
  if(cpid == 0){
    while(1);
  }
  else{
    sleep(50);
    kill(cpid, SIGKILL);
  }
  printf("sigkillTest OK\n");
}


void killwdiffSignum(void){
  
  int cpid = fork();
  if(cpid == 0){
    while(1);
  }
  else{
    sleep(50);
    kill(cpid, 15);
  }
  printf("kill with another signum test OK\n");

}


void testSigactionHandler1(void){

  struct sigaction* act = malloc(sizeof(struct sigaction *));
  act->sa_handler = handle;
  act->sigmask = 0;

  struct sigaction* act2 = malloc(sizeof(struct sigaction *));
  act2->sa_handler = handle2;
  act2->sigmask = 0;

  struct sigaction* act3 = malloc(sizeof(struct sigaction *));
  act3->sa_handler = handle3;
  act3->sigmask = 0;

  sigaction(5, act, 0);
  sigaction(2, act2, 0);
  int ret3 = sigaction(7, act3, 0);
  printf("ret3 = %d\n", ret3);
   printf("The address of the function handle3 is =%p\n",handle3);

  int cpid = fork();
  if(cpid == 0){
    while(1){
      if(flag == 7){
        printf("successfully recieved signal\n");
      }
    }
  }
  else{
    sleep(100);
    printf( "sending signal %d\n" , 7);
    kill(cpid, 7);
    sleep(100);
    kill(cpid, SIGKILL);
  }
  wait(0);
  printf("custom sig test OK\n");
  flag = 0;
}

void testContStopCont(void){


  int cpid = fork();
  if(cpid == 0){
    while(1){
      sleep(10);
    }
  }
  else{
    sleep(20);
    printf("sending cont\n");
    kill(cpid, SIGCONT);

    sleep(20);
    printf("sending stop\n");
    kill(cpid, SIGSTOP);

    sleep(20);
    printf("sending cont\n");
    kill(cpid, SIGCONT);

    sleep(20);
    printf("killing\n");
    kill(cpid, SIGKILL);
  }
  wait(0);
  printf("testContStopCont OK\n");
}

void testStopCont(void){


  int cpid = fork();
  if(cpid == 0){
    while(1){
      sleep(10);
    }
  }
  else{
    sleep(20);
    printf("send stop\n");
    kill(cpid, SIGSTOP);

    sleep(20);
    printf("send cont\n");
    kill(cpid, SIGCONT);

    sleep(20);
    printf("now to the killing\n");
    kill(cpid, SIGKILL);
  }
  wait(0);
  printf("testStopCont OK\n");
}


void testSigactionIGN(void){
  struct sigaction* act = malloc(sizeof(struct sigaction));
  act->sa_handler = (void *)SIG_IGN;
  act->sigmask = 0;

  sigaction(5, act, 0);

  int cpid = fork();
  if(cpid == 0){
    while(1){
      if(flag == 5){
        printf( "If you see me, that's not good\n");
      }
    }
  }
  else{
    sleep(10);
    printf( "send sigaction eith SIG_IGN\n");
    kill(cpid, 5);
    sleep(10);
    kill(cpid, SIGKILL);
  }
  wait(0);
  printf("testSigactionIGN test OK\n");
  flag = 0;
}


void testSigmAsk(void){
  uint mask = 1 << 3;
  sigprocmask(mask);

  struct sigaction* act = malloc(sizeof(struct sigaction *));
  act->sa_handler = handle;
  act->sigmask = 0;

  struct sigaction* act2 = malloc(sizeof(struct sigaction *));
  act2->sa_handler = handle2;
  act2->sigmask = 0;

  struct sigaction* act3 = malloc(sizeof(struct sigaction *));
  act3->sa_handler = handle3;
  act3->sigmask = 0;

  sigaction(5, act, 0);
  sigaction(2, act2, 0);
  sigaction(7, act3, 0);

  int cpid = fork();
  if(cpid == 0){
    while(1){
      if(flag == 7){
        printf("Recieved flag\n");
        break;
      }
    }
  }
  else{
    sleep(10);
    printf("sending sigaction with handler\n");
    kill(cpid, 7);
    sleep(10);
  }
  wait(0);
  printf( "sig mask test OK\n");
  flag = 0;
}

void signal_test(){
    int pid;
    int testsig;
    testsig=15;
    struct sigaction act = {test_handler, (uint)(1 << 29)};
    struct sigaction old;

    sigprocmask(0);
    sigaction(testsig, &act, &old);
    if((pid = fork()) == 0){
        while(!wait_sig)
            sleep(1);
        exit(0);
    }
    kill(pid, testsig);
    wait(&pid);
    printf("Finished testing signals\n");
}

void bsem_test(){
    int pid;
    int bid = bsem_alloc();
    bsem_down(bid);
    printf("1. Parent downing semaphore, pid number = %d\n" , getpid());
    if((pid = fork()) == 0){
        printf("2. Child downing semaphore, pid number = %d\n" , getpid());
        bsem_down(bid);
        printf("4. Child woke up\n");
        exit(0);
    }
    sleep(5);
    printf("3. Let the child wait on the semaphore...\n");
    sleep(10);
    bsem_up(bid);

    bsem_free(bid);
    wait(&pid);

    printf("Finished bsem test, make sure that the order of the prints is alright. Meaning (1...2...3...4)\n");
}

void thread_kthread_id(){
  fprintf(2, "\nstarting kthread_id test\n");
  int x = kthread_id();
  fprintf(2, "thread_id is: %d\n", x);
  fprintf(2, "finished kthread_id test\n");
}

void thread_kthread_create(){
  fprintf(2, "\nstarting kthread_create test\n");

  fprintf(2, "curr thread id is: %d\n", kthread_id());
  void* stack = malloc(MAX_STACK_SIZE);
  fprintf(2, "the new thread id is: %d\n", kthread_create(thread_kthread_id,stack));
  free(stack);

  fprintf(2, "finished kthread_create test\n");
}

void thread_kthread_create_with_wait(){
  fprintf(2, "\nstarting kthread_create_with_wait test\n");

  fprintf(2, "curr thread id is: %d\n", kthread_id());
  void* stack = malloc(MAX_STACK_SIZE);
  fprintf(2, "the new thread id is: %d\n", kthread_create(thread_kthread_id,stack));
  free(stack);
  int x= 10;
  wait(&x);

  fprintf(2, "finished kthread_create_with_wait test\n");
}



void Csem_test(){
	struct counting_semaphore csem;
    int retval;
    int pid;
    
    
    retval = csem_alloc(&csem,1);
    if(retval==-1)
    {
		printf("failed csem alloc");
		exit(-1);
	}
    csem_down(&csem);
    printf("1. Parent downing semaphore\n");
    if((pid = fork()) == 0){
        printf("2. Child downing semaphore\n");
        csem_down(&csem);
        printf("4. Child woke up\n");
        exit(0);
    }
    sleep(5);
    printf("3. Let the child wait on the semaphore...\n");
    sleep(10);
    csem_up(&csem);

    csem_free(&csem);
    wait(&pid);

    printf("Finished bsem test, make sure that the order of the prints is alright. Meaning (1...2...3...4)\n");
}



//ASS2 TASK2
int
main(int argc, char **argv)
{
  printf( "starting testing signals and friends\n");
  
//  sigkillTest();
//  killwdiffSignum();
//  testSigactionHandler1();
//  testContStopCont();
//  testStopCont();
//  testSigactionIGN();
//  testSigmAsk();
  signal_test();
  bsem_test();
  Csem_test() ;
//  thread_kthread_id();
  thread_kthread_create();
//thread_kthread_create_with_wait();

  printf("\nALL TESTS PASSED\n");
  exit(0);
}
 