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
    printf("in handle: changed flag\n");
}

void handle2(int signum){
    flag = signum;
    printf("in handle2: changed flag\n");
}

void handle3(int signum){
    flag = signum;
    printf("in handle3: changed flag\n");
}

void test_thread(){
    printf("Thread is now running\n");
    kthread_exit(0);
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
    sleep(25);
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
  printf("killwdiffSignum OK\n");

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
  sigaction(7, act3, 0);

  int cpid = fork();
  if(cpid == 0){
    while(1){
      if(flag == 7){
        printf("testSigactionHandler1 got flag ... ");
      }
    }
  }
  else{
    sleep(100);
    kill(cpid, 7);
    sleep(100);
    kill(cpid, SIGKILL);
  }
  wait(0);
  printf("testSigactionHandler1 OK\n");
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
    kill(cpid, SIGCONT);

    sleep(20);
    kill(cpid, SIGSTOP);

    sleep(20);
    kill(cpid, SIGCONT);

    sleep(20);
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
    kill(cpid, SIGSTOP);

    sleep(20);
    kill(cpid, SIGCONT);

    sleep(20);
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
        printf( "testSigactionIGN - If you see me, that's not good\n");
      }
    }
  }
  else{
    sleep(10);
    kill(cpid, 5);
    sleep(10);
    kill(cpid, SIGKILL);
  }
  wait(0);
  printf("testSigactionIGN test OK\n");
  flag = 0;
}


void testSigMask(void){
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
        printf("testSigMask -> recieved flag...     ");
        break;
      }
    }
  }
  else{
    sleep(10);
    kill(cpid, 7);
    sleep(10);
  }
  wait(0);
  printf( "testSigMask OK\n");
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


int
main(int argc, char **argv)
{
  printf("start of tests 2.5\n");
  sigkillTest();
  killwdiffSignum();
  testSigactionHandler1();
  testContStopCont();
  testStopCont();
  testSigactionIGN();
  testSigMask();
  signal_test();

  printf("\nALL TESTS PASSED\n");
  exit(0);
}
 