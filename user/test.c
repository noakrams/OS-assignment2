#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"
#include "kernel/syscall.h"
#include "kernel/sigaction.h"




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


void test_sigkill(void){
  
  printf("test sigkill start\n");
  int cpid = fork();
  if(cpid == 0){
    while(1);
  }
  else{
    sleep(5);
    kill(cpid, SIGKILL);
  }
  printf("test_sigkill OK\n");

}

void test_sigkill_othersig(void){
  
  printf("kill other sig test start\n");
  int cpid = fork();
  if(cpid == 0){
    while(1);
  }
  else{
    sleep(100);
    kill(cpid, 15);
  }
  printf("kill other sig test OK\n");

}


void test_custom_signal(void){
  
  printf("custon signal test start\n");
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

void test_stop_cont(void){

  printf("stop cont test start\n");

  int cpid = fork();
  if(cpid == 0){
    while(1){
      printf("in while\n");
      sleep(10);
    }
  }
  else{
    sleep(5);
    printf("sending stop\n");
    kill(cpid, SIGSTOP);

    sleep(5);
    printf("sending cont\n");
    kill(cpid, SIGCONT);

    sleep(10);
    printf("killing\n");
    kill(cpid, SIGKILL);
  }
  wait(0);
  printf("stop cont test OK\n");
}


void test_sig_ign(void){
  printf( "sig ign test start\n");
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
    printf( "sending signal\n");
    kill(cpid, 5);
    sleep(10);
    kill(cpid, SIGKILL);
  }
  wait(0);
  printf("sig ign test OK\n");
  flag = 0;
}


void test_sigmask(void){
  printf("sig mask test start\n");
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
        printf("successfully recieved signal\n");
        break;
      }
    }
  }
  else{
    sleep(10);
    printf("sending signal\n");
    kill(cpid, 7);
    sleep(10);
    printf("after handler flag = %d\n" , flag);
    //kill(cpid, 9);
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


//ASS2 TASK2
int
main(int argc, char **argv)
{
  printf( "starting testing signals and friends\n");
  
//  test_sigkill();
//  test_sigkill_othersig();
//  test_custom_signal();
//  test_stop_cont();
//  test_sig_ign();
//  test_sigmask();
   signal_test();
  
  printf("ALL TESTS PASSED\n");
  exit(0);
}
 