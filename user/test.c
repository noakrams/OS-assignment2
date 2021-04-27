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
    printf("signum: %d\n", signum);
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

  sigaction(5, act, 0);

  int cpid = fork();
  if(cpid == 0){
    while(1){
      if(flag == 5){
        printf("successfully recieved signal\n");
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
    sleep(100);
    printf("sending stop\n");
    kill(cpid, SIGSTOP);

    sleep(100);
    printf("sending cont\n");
    kill(cpid, SIGCONT);

    sleep(300);
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
        printf( "successfully recieved signal\n");
      }
    }
  }
  else{
    sleep(100);
    printf( "sending signal\n");
    kill(cpid, 5);
    sleep(100);
    kill(cpid, 9);
  }
  wait(0);
  printf("sig ign test OK\n");
  flag = 0;
}


void test_sigmask(void){
  printf("sig mask test start\n");
  uint mask = 1 << 3;
  sigprocmask(mask);

  int cpid = fork();
  if(cpid == 0){
    while(1){
      if(flag == 5){
        printf("successfully recieved signal\n");
      }
    }
  }
  else{
    sleep(100);
    printf("sending signal\n");
    kill(cpid, 5);
    sleep(100);
    kill(cpid, 9);
  }
  wait(0);
  printf( "sig mask test OK\n");
  flag = 0;
}


//ASS2 TASK2
int
main(int argc, char **argv)
{
  printf( "starting testing signals and friends\n");
  
//  test_sigkill();
//  test_sigkill_othersig();
  test_custom_signal();
//  test_stop_cont();
//  test_sig_ign();
//  test_sigmask();
  
  printf("ALL TESTS PASSED\n");
  exit(0);
}
 