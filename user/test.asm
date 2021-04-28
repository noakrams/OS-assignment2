
user/_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <handle>:
#define SIGSTOP 17
#define SIGCONT 19

int flag;

void handle(int signum){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	85aa                	mv	a1,a0
    flag = signum;
   a:	00001797          	auipc	a5,0x1
   e:	f8a7a323          	sw	a0,-122(a5) # f90 <flag>
    printf("handle -> signum: %d\n", signum);
  12:	00001517          	auipc	a0,0x1
  16:	cde50513          	addi	a0,a0,-802 # cf0 <malloc+0xea>
  1a:	00001097          	auipc	ra,0x1
  1e:	b2e080e7          	jalr	-1234(ra) # b48 <printf>
}
  22:	60a2                	ld	ra,8(sp)
  24:	6402                	ld	s0,0(sp)
  26:	0141                	addi	sp,sp,16
  28:	8082                	ret

000000000000002a <handle2>:

void handle2(int signum){
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
  32:	85aa                	mv	a1,a0
    flag = signum;
  34:	00001797          	auipc	a5,0x1
  38:	f4a7ae23          	sw	a0,-164(a5) # f90 <flag>
    printf("handle2 -> signum: %d\n", signum);
  3c:	00001517          	auipc	a0,0x1
  40:	ccc50513          	addi	a0,a0,-820 # d08 <malloc+0x102>
  44:	00001097          	auipc	ra,0x1
  48:	b04080e7          	jalr	-1276(ra) # b48 <printf>
}
  4c:	60a2                	ld	ra,8(sp)
  4e:	6402                	ld	s0,0(sp)
  50:	0141                	addi	sp,sp,16
  52:	8082                	ret

0000000000000054 <handle3>:

void handle3(int signum){
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	85aa                	mv	a1,a0
    flag = signum;
  5e:	00001797          	auipc	a5,0x1
  62:	f2a7a923          	sw	a0,-206(a5) # f90 <flag>
    printf("handle3 -> signum: %d\n", signum);
  66:	00001517          	auipc	a0,0x1
  6a:	cba50513          	addi	a0,a0,-838 # d20 <malloc+0x11a>
  6e:	00001097          	auipc	ra,0x1
  72:	ada080e7          	jalr	-1318(ra) # b48 <printf>
}
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <test_sigkill>:


void test_sigkill(void){
  7e:	1101                	addi	sp,sp,-32
  80:	ec06                	sd	ra,24(sp)
  82:	e822                	sd	s0,16(sp)
  84:	e426                	sd	s1,8(sp)
  86:	1000                	addi	s0,sp,32
  
  printf("test sigkill start\n");
  88:	00001517          	auipc	a0,0x1
  8c:	cb050513          	addi	a0,a0,-848 # d38 <malloc+0x132>
  90:	00001097          	auipc	ra,0x1
  94:	ab8080e7          	jalr	-1352(ra) # b48 <printf>
  int cpid = fork();
  98:	00000097          	auipc	ra,0x0
  9c:	718080e7          	jalr	1816(ra) # 7b0 <fork>
  if(cpid == 0){
  a0:	e111                	bnez	a0,a4 <test_sigkill+0x26>
    while(1);
  a2:	a001                	j	a2 <test_sigkill+0x24>
  a4:	84aa                	mv	s1,a0
  }
  else{
    sleep(5);
  a6:	4515                	li	a0,5
  a8:	00000097          	auipc	ra,0x0
  ac:	7a0080e7          	jalr	1952(ra) # 848 <sleep>
    kill(cpid, SIGKILL);
  b0:	45a5                	li	a1,9
  b2:	8526                	mv	a0,s1
  b4:	00000097          	auipc	ra,0x0
  b8:	734080e7          	jalr	1844(ra) # 7e8 <kill>
  }
  printf("test_sigkill OK\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	c9450513          	addi	a0,a0,-876 # d50 <malloc+0x14a>
  c4:	00001097          	auipc	ra,0x1
  c8:	a84080e7          	jalr	-1404(ra) # b48 <printf>

}
  cc:	60e2                	ld	ra,24(sp)
  ce:	6442                	ld	s0,16(sp)
  d0:	64a2                	ld	s1,8(sp)
  d2:	6105                	addi	sp,sp,32
  d4:	8082                	ret

00000000000000d6 <test_sigkill_othersig>:

void test_sigkill_othersig(void){
  d6:	1101                	addi	sp,sp,-32
  d8:	ec06                	sd	ra,24(sp)
  da:	e822                	sd	s0,16(sp)
  dc:	e426                	sd	s1,8(sp)
  de:	1000                	addi	s0,sp,32
  
  printf("kill other sig test start\n");
  e0:	00001517          	auipc	a0,0x1
  e4:	c8850513          	addi	a0,a0,-888 # d68 <malloc+0x162>
  e8:	00001097          	auipc	ra,0x1
  ec:	a60080e7          	jalr	-1440(ra) # b48 <printf>
  int cpid = fork();
  f0:	00000097          	auipc	ra,0x0
  f4:	6c0080e7          	jalr	1728(ra) # 7b0 <fork>
  if(cpid == 0){
  f8:	e111                	bnez	a0,fc <test_sigkill_othersig+0x26>
    while(1);
  fa:	a001                	j	fa <test_sigkill_othersig+0x24>
  fc:	84aa                	mv	s1,a0
  }
  else{
    sleep(100);
  fe:	06400513          	li	a0,100
 102:	00000097          	auipc	ra,0x0
 106:	746080e7          	jalr	1862(ra) # 848 <sleep>
    kill(cpid, 15);
 10a:	45bd                	li	a1,15
 10c:	8526                	mv	a0,s1
 10e:	00000097          	auipc	ra,0x0
 112:	6da080e7          	jalr	1754(ra) # 7e8 <kill>
  }
  printf("kill other sig test OK\n");
 116:	00001517          	auipc	a0,0x1
 11a:	c7250513          	addi	a0,a0,-910 # d88 <malloc+0x182>
 11e:	00001097          	auipc	ra,0x1
 122:	a2a080e7          	jalr	-1494(ra) # b48 <printf>

}
 126:	60e2                	ld	ra,24(sp)
 128:	6442                	ld	s0,16(sp)
 12a:	64a2                	ld	s1,8(sp)
 12c:	6105                	addi	sp,sp,32
 12e:	8082                	ret

0000000000000130 <test_custom_signal>:


void test_custom_signal(void){
 130:	7179                	addi	sp,sp,-48
 132:	f406                	sd	ra,40(sp)
 134:	f022                	sd	s0,32(sp)
 136:	ec26                	sd	s1,24(sp)
 138:	e84a                	sd	s2,16(sp)
 13a:	e44e                	sd	s3,8(sp)
 13c:	e052                	sd	s4,0(sp)
 13e:	1800                	addi	s0,sp,48
  
  printf("custon signal test start\n");
 140:	00001517          	auipc	a0,0x1
 144:	c6050513          	addi	a0,a0,-928 # da0 <malloc+0x19a>
 148:	00001097          	auipc	ra,0x1
 14c:	a00080e7          	jalr	-1536(ra) # b48 <printf>
  struct sigaction* act = malloc(sizeof(struct sigaction *));
 150:	4521                	li	a0,8
 152:	00001097          	auipc	ra,0x1
 156:	ab4080e7          	jalr	-1356(ra) # c06 <malloc>
 15a:	89aa                	mv	s3,a0
  act->sa_handler = handle;
 15c:	00000797          	auipc	a5,0x0
 160:	ea478793          	addi	a5,a5,-348 # 0 <handle>
 164:	e11c                	sd	a5,0(a0)
  act->sigmask = 0;
 166:	00052423          	sw	zero,8(a0)

  struct sigaction* act2 = malloc(sizeof(struct sigaction *));
 16a:	4521                	li	a0,8
 16c:	00001097          	auipc	ra,0x1
 170:	a9a080e7          	jalr	-1382(ra) # c06 <malloc>
 174:	892a                	mv	s2,a0
  act2->sa_handler = handle2;
 176:	00000797          	auipc	a5,0x0
 17a:	eb478793          	addi	a5,a5,-332 # 2a <handle2>
 17e:	e11c                	sd	a5,0(a0)
  act2->sigmask = 0;
 180:	00052423          	sw	zero,8(a0)

  struct sigaction* act3 = malloc(sizeof(struct sigaction *));
 184:	4521                	li	a0,8
 186:	00001097          	auipc	ra,0x1
 18a:	a80080e7          	jalr	-1408(ra) # c06 <malloc>
 18e:	84aa                	mv	s1,a0
  act3->sa_handler = handle3;
 190:	00000a17          	auipc	s4,0x0
 194:	ec4a0a13          	addi	s4,s4,-316 # 54 <handle3>
 198:	01453023          	sd	s4,0(a0)
  act3->sigmask = 0;
 19c:	00052423          	sw	zero,8(a0)

  sigaction(5, act, 0);
 1a0:	4601                	li	a2,0
 1a2:	85ce                	mv	a1,s3
 1a4:	4515                	li	a0,5
 1a6:	00000097          	auipc	ra,0x0
 1aa:	6ba080e7          	jalr	1722(ra) # 860 <sigaction>
  sigaction(2, act2, 0);
 1ae:	4601                	li	a2,0
 1b0:	85ca                	mv	a1,s2
 1b2:	4509                	li	a0,2
 1b4:	00000097          	auipc	ra,0x0
 1b8:	6ac080e7          	jalr	1708(ra) # 860 <sigaction>
  int ret3 = sigaction(7, act3, 0);
 1bc:	4601                	li	a2,0
 1be:	85a6                	mv	a1,s1
 1c0:	451d                	li	a0,7
 1c2:	00000097          	auipc	ra,0x0
 1c6:	69e080e7          	jalr	1694(ra) # 860 <sigaction>
 1ca:	85aa                	mv	a1,a0
  printf("ret3 = %d\n", ret3);
 1cc:	00001517          	auipc	a0,0x1
 1d0:	bf450513          	addi	a0,a0,-1036 # dc0 <malloc+0x1ba>
 1d4:	00001097          	auipc	ra,0x1
 1d8:	974080e7          	jalr	-1676(ra) # b48 <printf>
   printf("The address of the function handle3 is =%p\n",handle3);
 1dc:	85d2                	mv	a1,s4
 1de:	00001517          	auipc	a0,0x1
 1e2:	bf250513          	addi	a0,a0,-1038 # dd0 <malloc+0x1ca>
 1e6:	00001097          	auipc	ra,0x1
 1ea:	962080e7          	jalr	-1694(ra) # b48 <printf>

  int cpid = fork();
 1ee:	00000097          	auipc	ra,0x0
 1f2:	5c2080e7          	jalr	1474(ra) # 7b0 <fork>
  if(cpid == 0){
 1f6:	c525                	beqz	a0,25e <test_custom_signal+0x12e>
 1f8:	84aa                	mv	s1,a0
      }
    }
  }
  else{
    int sigNum = 7;
    sleep(10);
 1fa:	4529                	li	a0,10
 1fc:	00000097          	auipc	ra,0x0
 200:	64c080e7          	jalr	1612(ra) # 848 <sleep>
    printf( "sending signal %d\n" , sigNum);
 204:	459d                	li	a1,7
 206:	00001517          	auipc	a0,0x1
 20a:	c1a50513          	addi	a0,a0,-998 # e20 <malloc+0x21a>
 20e:	00001097          	auipc	ra,0x1
 212:	93a080e7          	jalr	-1734(ra) # b48 <printf>
    kill(cpid, sigNum);
 216:	459d                	li	a1,7
 218:	8526                	mv	a0,s1
 21a:	00000097          	auipc	ra,0x0
 21e:	5ce080e7          	jalr	1486(ra) # 7e8 <kill>
    sleep(10);
 222:	4529                	li	a0,10
 224:	00000097          	auipc	ra,0x0
 228:	624080e7          	jalr	1572(ra) # 848 <sleep>
    //kill(cpid, SIGKILL);
  }
  wait(0);
 22c:	4501                	li	a0,0
 22e:	00000097          	auipc	ra,0x0
 232:	592080e7          	jalr	1426(ra) # 7c0 <wait>
  printf("custom sig test OK\n");
 236:	00001517          	auipc	a0,0x1
 23a:	c0250513          	addi	a0,a0,-1022 # e38 <malloc+0x232>
 23e:	00001097          	auipc	ra,0x1
 242:	90a080e7          	jalr	-1782(ra) # b48 <printf>
  flag = 0;
 246:	00001797          	auipc	a5,0x1
 24a:	d407a523          	sw	zero,-694(a5) # f90 <flag>
}
 24e:	70a2                	ld	ra,40(sp)
 250:	7402                	ld	s0,32(sp)
 252:	64e2                	ld	s1,24(sp)
 254:	6942                	ld	s2,16(sp)
 256:	69a2                	ld	s3,8(sp)
 258:	6a02                	ld	s4,0(sp)
 25a:	6145                	addi	sp,sp,48
 25c:	8082                	ret
      if(flag == 7){
 25e:	00001717          	auipc	a4,0x1
 262:	d3272703          	lw	a4,-718(a4) # f90 <flag>
 266:	479d                	li	a5,7
 268:	00f71063          	bne	a4,a5,268 <test_custom_signal+0x138>
        printf("successfully recieved signal\n");
 26c:	00001517          	auipc	a0,0x1
 270:	b9450513          	addi	a0,a0,-1132 # e00 <malloc+0x1fa>
 274:	00001097          	auipc	ra,0x1
 278:	8d4080e7          	jalr	-1836(ra) # b48 <printf>
        exit(0);
 27c:	4501                	li	a0,0
 27e:	00000097          	auipc	ra,0x0
 282:	53a080e7          	jalr	1338(ra) # 7b8 <exit>

0000000000000286 <test_stop_cont>:

void test_stop_cont(void){
 286:	1101                	addi	sp,sp,-32
 288:	ec06                	sd	ra,24(sp)
 28a:	e822                	sd	s0,16(sp)
 28c:	e426                	sd	s1,8(sp)
 28e:	1000                	addi	s0,sp,32

  printf("stop cont test start\n");
 290:	00001517          	auipc	a0,0x1
 294:	bc050513          	addi	a0,a0,-1088 # e50 <malloc+0x24a>
 298:	00001097          	auipc	ra,0x1
 29c:	8b0080e7          	jalr	-1872(ra) # b48 <printf>

  int cpid = fork();
 2a0:	00000097          	auipc	ra,0x0
 2a4:	510080e7          	jalr	1296(ra) # 7b0 <fork>
  if(cpid == 0){
 2a8:	e105                	bnez	a0,2c8 <test_stop_cont+0x42>
    while(1){
      printf("in while\n");
 2aa:	00001497          	auipc	s1,0x1
 2ae:	bbe48493          	addi	s1,s1,-1090 # e68 <malloc+0x262>
 2b2:	8526                	mv	a0,s1
 2b4:	00001097          	auipc	ra,0x1
 2b8:	894080e7          	jalr	-1900(ra) # b48 <printf>
      sleep(10);
 2bc:	4529                	li	a0,10
 2be:	00000097          	auipc	ra,0x0
 2c2:	58a080e7          	jalr	1418(ra) # 848 <sleep>
    while(1){
 2c6:	b7f5                	j	2b2 <test_stop_cont+0x2c>
 2c8:	84aa                	mv	s1,a0
    }
  }
  else{
    sleep(100);
 2ca:	06400513          	li	a0,100
 2ce:	00000097          	auipc	ra,0x0
 2d2:	57a080e7          	jalr	1402(ra) # 848 <sleep>
    printf("sending stop\n");
 2d6:	00001517          	auipc	a0,0x1
 2da:	ba250513          	addi	a0,a0,-1118 # e78 <malloc+0x272>
 2de:	00001097          	auipc	ra,0x1
 2e2:	86a080e7          	jalr	-1942(ra) # b48 <printf>
    kill(cpid, SIGSTOP);
 2e6:	45c5                	li	a1,17
 2e8:	8526                	mv	a0,s1
 2ea:	00000097          	auipc	ra,0x0
 2ee:	4fe080e7          	jalr	1278(ra) # 7e8 <kill>

    sleep(100);
 2f2:	06400513          	li	a0,100
 2f6:	00000097          	auipc	ra,0x0
 2fa:	552080e7          	jalr	1362(ra) # 848 <sleep>
    printf("sending cont\n");
 2fe:	00001517          	auipc	a0,0x1
 302:	b8a50513          	addi	a0,a0,-1142 # e88 <malloc+0x282>
 306:	00001097          	auipc	ra,0x1
 30a:	842080e7          	jalr	-1982(ra) # b48 <printf>
    kill(cpid, SIGCONT);
 30e:	45cd                	li	a1,19
 310:	8526                	mv	a0,s1
 312:	00000097          	auipc	ra,0x0
 316:	4d6080e7          	jalr	1238(ra) # 7e8 <kill>

    sleep(300);
 31a:	12c00513          	li	a0,300
 31e:	00000097          	auipc	ra,0x0
 322:	52a080e7          	jalr	1322(ra) # 848 <sleep>
    printf("killing\n");
 326:	00001517          	auipc	a0,0x1
 32a:	b7250513          	addi	a0,a0,-1166 # e98 <malloc+0x292>
 32e:	00001097          	auipc	ra,0x1
 332:	81a080e7          	jalr	-2022(ra) # b48 <printf>
    kill(cpid, SIGKILL);
 336:	45a5                	li	a1,9
 338:	8526                	mv	a0,s1
 33a:	00000097          	auipc	ra,0x0
 33e:	4ae080e7          	jalr	1198(ra) # 7e8 <kill>
  }
  wait(0);
 342:	4501                	li	a0,0
 344:	00000097          	auipc	ra,0x0
 348:	47c080e7          	jalr	1148(ra) # 7c0 <wait>
  printf("stop cont test OK\n");
 34c:	00001517          	auipc	a0,0x1
 350:	b5c50513          	addi	a0,a0,-1188 # ea8 <malloc+0x2a2>
 354:	00000097          	auipc	ra,0x0
 358:	7f4080e7          	jalr	2036(ra) # b48 <printf>
}
 35c:	60e2                	ld	ra,24(sp)
 35e:	6442                	ld	s0,16(sp)
 360:	64a2                	ld	s1,8(sp)
 362:	6105                	addi	sp,sp,32
 364:	8082                	ret

0000000000000366 <test_sig_ign>:


void test_sig_ign(void){
 366:	7179                	addi	sp,sp,-48
 368:	f406                	sd	ra,40(sp)
 36a:	f022                	sd	s0,32(sp)
 36c:	ec26                	sd	s1,24(sp)
 36e:	e84a                	sd	s2,16(sp)
 370:	e44e                	sd	s3,8(sp)
 372:	1800                	addi	s0,sp,48
  printf( "sig ign test start\n");
 374:	00001517          	auipc	a0,0x1
 378:	b4c50513          	addi	a0,a0,-1204 # ec0 <malloc+0x2ba>
 37c:	00000097          	auipc	ra,0x0
 380:	7cc080e7          	jalr	1996(ra) # b48 <printf>
  struct sigaction* act = malloc(sizeof(struct sigaction));
 384:	4541                	li	a0,16
 386:	00001097          	auipc	ra,0x1
 38a:	880080e7          	jalr	-1920(ra) # c06 <malloc>
 38e:	85aa                	mv	a1,a0
  act->sa_handler = (void *)SIG_IGN;
 390:	4785                	li	a5,1
 392:	e11c                	sd	a5,0(a0)
  act->sigmask = 0;
 394:	00052423          	sw	zero,8(a0)

  sigaction(5, act, 0);
 398:	4601                	li	a2,0
 39a:	4515                	li	a0,5
 39c:	00000097          	auipc	ra,0x0
 3a0:	4c4080e7          	jalr	1220(ra) # 860 <sigaction>

  int cpid = fork();
 3a4:	00000097          	auipc	ra,0x0
 3a8:	40c080e7          	jalr	1036(ra) # 7b0 <fork>
  if(cpid == 0){
 3ac:	e505                	bnez	a0,3d4 <test_sig_ign+0x6e>
    while(1){
      if(flag == 5){
 3ae:	00001997          	auipc	s3,0x1
 3b2:	be298993          	addi	s3,s3,-1054 # f90 <flag>
 3b6:	4495                	li	s1,5
        printf( "successfully recieved signal\n");
 3b8:	00001917          	auipc	s2,0x1
 3bc:	a4890913          	addi	s2,s2,-1464 # e00 <malloc+0x1fa>
      if(flag == 5){
 3c0:	0009a783          	lw	a5,0(s3)
 3c4:	00979063          	bne	a5,s1,3c4 <test_sig_ign+0x5e>
        printf( "successfully recieved signal\n");
 3c8:	854a                	mv	a0,s2
 3ca:	00000097          	auipc	ra,0x0
 3ce:	77e080e7          	jalr	1918(ra) # b48 <printf>
 3d2:	b7fd                	j	3c0 <test_sig_ign+0x5a>
 3d4:	84aa                	mv	s1,a0
      }
    }
  }
  else{
    sleep(100);
 3d6:	06400513          	li	a0,100
 3da:	00000097          	auipc	ra,0x0
 3de:	46e080e7          	jalr	1134(ra) # 848 <sleep>
    printf( "sending signal\n");
 3e2:	00001517          	auipc	a0,0x1
 3e6:	af650513          	addi	a0,a0,-1290 # ed8 <malloc+0x2d2>
 3ea:	00000097          	auipc	ra,0x0
 3ee:	75e080e7          	jalr	1886(ra) # b48 <printf>
    kill(cpid, 5);
 3f2:	4595                	li	a1,5
 3f4:	8526                	mv	a0,s1
 3f6:	00000097          	auipc	ra,0x0
 3fa:	3f2080e7          	jalr	1010(ra) # 7e8 <kill>
    sleep(100);
 3fe:	06400513          	li	a0,100
 402:	00000097          	auipc	ra,0x0
 406:	446080e7          	jalr	1094(ra) # 848 <sleep>
    kill(cpid, 9);
 40a:	45a5                	li	a1,9
 40c:	8526                	mv	a0,s1
 40e:	00000097          	auipc	ra,0x0
 412:	3da080e7          	jalr	986(ra) # 7e8 <kill>
  }
  wait(0);
 416:	4501                	li	a0,0
 418:	00000097          	auipc	ra,0x0
 41c:	3a8080e7          	jalr	936(ra) # 7c0 <wait>
  printf("sig ign test OK\n");
 420:	00001517          	auipc	a0,0x1
 424:	ac850513          	addi	a0,a0,-1336 # ee8 <malloc+0x2e2>
 428:	00000097          	auipc	ra,0x0
 42c:	720080e7          	jalr	1824(ra) # b48 <printf>
  flag = 0;
 430:	00001797          	auipc	a5,0x1
 434:	b607a023          	sw	zero,-1184(a5) # f90 <flag>
}
 438:	70a2                	ld	ra,40(sp)
 43a:	7402                	ld	s0,32(sp)
 43c:	64e2                	ld	s1,24(sp)
 43e:	6942                	ld	s2,16(sp)
 440:	69a2                	ld	s3,8(sp)
 442:	6145                	addi	sp,sp,48
 444:	8082                	ret

0000000000000446 <test_sigmask>:


void test_sigmask(void){
 446:	7179                	addi	sp,sp,-48
 448:	f406                	sd	ra,40(sp)
 44a:	f022                	sd	s0,32(sp)
 44c:	ec26                	sd	s1,24(sp)
 44e:	e84a                	sd	s2,16(sp)
 450:	e44e                	sd	s3,8(sp)
 452:	1800                	addi	s0,sp,48
  printf("sig mask test start\n");
 454:	00001517          	auipc	a0,0x1
 458:	aac50513          	addi	a0,a0,-1364 # f00 <malloc+0x2fa>
 45c:	00000097          	auipc	ra,0x0
 460:	6ec080e7          	jalr	1772(ra) # b48 <printf>
  uint mask = 1 << 3;
  sigprocmask(mask);
 464:	4521                	li	a0,8
 466:	00000097          	auipc	ra,0x0
 46a:	3f2080e7          	jalr	1010(ra) # 858 <sigprocmask>

  int cpid = fork();
 46e:	00000097          	auipc	ra,0x0
 472:	342080e7          	jalr	834(ra) # 7b0 <fork>
  if(cpid == 0){
 476:	e505                	bnez	a0,49e <test_sigmask+0x58>
    while(1){
      if(flag == 5){
 478:	00001997          	auipc	s3,0x1
 47c:	b1898993          	addi	s3,s3,-1256 # f90 <flag>
 480:	4495                	li	s1,5
        printf("successfully recieved signal\n");
 482:	00001917          	auipc	s2,0x1
 486:	97e90913          	addi	s2,s2,-1666 # e00 <malloc+0x1fa>
      if(flag == 5){
 48a:	0009a783          	lw	a5,0(s3)
 48e:	00979063          	bne	a5,s1,48e <test_sigmask+0x48>
        printf("successfully recieved signal\n");
 492:	854a                	mv	a0,s2
 494:	00000097          	auipc	ra,0x0
 498:	6b4080e7          	jalr	1716(ra) # b48 <printf>
 49c:	b7fd                	j	48a <test_sigmask+0x44>
 49e:	84aa                	mv	s1,a0
      }
    }
  }
  else{
    sleep(100);
 4a0:	06400513          	li	a0,100
 4a4:	00000097          	auipc	ra,0x0
 4a8:	3a4080e7          	jalr	932(ra) # 848 <sleep>
    printf("sending signal\n");
 4ac:	00001517          	auipc	a0,0x1
 4b0:	a2c50513          	addi	a0,a0,-1492 # ed8 <malloc+0x2d2>
 4b4:	00000097          	auipc	ra,0x0
 4b8:	694080e7          	jalr	1684(ra) # b48 <printf>
    kill(cpid, 5);
 4bc:	4595                	li	a1,5
 4be:	8526                	mv	a0,s1
 4c0:	00000097          	auipc	ra,0x0
 4c4:	328080e7          	jalr	808(ra) # 7e8 <kill>
    sleep(100);
 4c8:	06400513          	li	a0,100
 4cc:	00000097          	auipc	ra,0x0
 4d0:	37c080e7          	jalr	892(ra) # 848 <sleep>
    kill(cpid, 9);
 4d4:	45a5                	li	a1,9
 4d6:	8526                	mv	a0,s1
 4d8:	00000097          	auipc	ra,0x0
 4dc:	310080e7          	jalr	784(ra) # 7e8 <kill>
  }
  wait(0);
 4e0:	4501                	li	a0,0
 4e2:	00000097          	auipc	ra,0x0
 4e6:	2de080e7          	jalr	734(ra) # 7c0 <wait>
  printf( "sig mask test OK\n");
 4ea:	00001517          	auipc	a0,0x1
 4ee:	a2e50513          	addi	a0,a0,-1490 # f18 <malloc+0x312>
 4f2:	00000097          	auipc	ra,0x0
 4f6:	656080e7          	jalr	1622(ra) # b48 <printf>
  flag = 0;
 4fa:	00001797          	auipc	a5,0x1
 4fe:	a807ab23          	sw	zero,-1386(a5) # f90 <flag>
}
 502:	70a2                	ld	ra,40(sp)
 504:	7402                	ld	s0,32(sp)
 506:	64e2                	ld	s1,24(sp)
 508:	6942                	ld	s2,16(sp)
 50a:	69a2                	ld	s3,8(sp)
 50c:	6145                	addi	sp,sp,48
 50e:	8082                	ret

0000000000000510 <main>:


//ASS2 TASK2
int
main(int argc, char **argv)
{
 510:	1141                	addi	sp,sp,-16
 512:	e406                	sd	ra,8(sp)
 514:	e022                	sd	s0,0(sp)
 516:	0800                	addi	s0,sp,16
  printf( "starting testing signals and friends\n");
 518:	00001517          	auipc	a0,0x1
 51c:	a1850513          	addi	a0,a0,-1512 # f30 <malloc+0x32a>
 520:	00000097          	auipc	ra,0x0
 524:	628080e7          	jalr	1576(ra) # b48 <printf>
  
//  test_sigkill();
//  test_sigkill_othersig();
  test_custom_signal();
 528:	00000097          	auipc	ra,0x0
 52c:	c08080e7          	jalr	-1016(ra) # 130 <test_custom_signal>
//  test_stop_cont();
//  test_sig_ign();
//  test_sigmask();
  
  printf("ALL TESTS PASSED\n");
 530:	00001517          	auipc	a0,0x1
 534:	a2850513          	addi	a0,a0,-1496 # f58 <malloc+0x352>
 538:	00000097          	auipc	ra,0x0
 53c:	610080e7          	jalr	1552(ra) # b48 <printf>
  exit(0);
 540:	4501                	li	a0,0
 542:	00000097          	auipc	ra,0x0
 546:	276080e7          	jalr	630(ra) # 7b8 <exit>

000000000000054a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 54a:	1141                	addi	sp,sp,-16
 54c:	e422                	sd	s0,8(sp)
 54e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 550:	87aa                	mv	a5,a0
 552:	0585                	addi	a1,a1,1
 554:	0785                	addi	a5,a5,1
 556:	fff5c703          	lbu	a4,-1(a1)
 55a:	fee78fa3          	sb	a4,-1(a5)
 55e:	fb75                	bnez	a4,552 <strcpy+0x8>
    ;
  return os;
}
 560:	6422                	ld	s0,8(sp)
 562:	0141                	addi	sp,sp,16
 564:	8082                	ret

0000000000000566 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 566:	1141                	addi	sp,sp,-16
 568:	e422                	sd	s0,8(sp)
 56a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 56c:	00054783          	lbu	a5,0(a0)
 570:	cb91                	beqz	a5,584 <strcmp+0x1e>
 572:	0005c703          	lbu	a4,0(a1)
 576:	00f71763          	bne	a4,a5,584 <strcmp+0x1e>
    p++, q++;
 57a:	0505                	addi	a0,a0,1
 57c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 57e:	00054783          	lbu	a5,0(a0)
 582:	fbe5                	bnez	a5,572 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 584:	0005c503          	lbu	a0,0(a1)
}
 588:	40a7853b          	subw	a0,a5,a0
 58c:	6422                	ld	s0,8(sp)
 58e:	0141                	addi	sp,sp,16
 590:	8082                	ret

0000000000000592 <strlen>:

uint
strlen(const char *s)
{
 592:	1141                	addi	sp,sp,-16
 594:	e422                	sd	s0,8(sp)
 596:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 598:	00054783          	lbu	a5,0(a0)
 59c:	cf91                	beqz	a5,5b8 <strlen+0x26>
 59e:	0505                	addi	a0,a0,1
 5a0:	87aa                	mv	a5,a0
 5a2:	4685                	li	a3,1
 5a4:	9e89                	subw	a3,a3,a0
 5a6:	00f6853b          	addw	a0,a3,a5
 5aa:	0785                	addi	a5,a5,1
 5ac:	fff7c703          	lbu	a4,-1(a5)
 5b0:	fb7d                	bnez	a4,5a6 <strlen+0x14>
    ;
  return n;
}
 5b2:	6422                	ld	s0,8(sp)
 5b4:	0141                	addi	sp,sp,16
 5b6:	8082                	ret
  for(n = 0; s[n]; n++)
 5b8:	4501                	li	a0,0
 5ba:	bfe5                	j	5b2 <strlen+0x20>

00000000000005bc <memset>:

void*
memset(void *dst, int c, uint n)
{
 5bc:	1141                	addi	sp,sp,-16
 5be:	e422                	sd	s0,8(sp)
 5c0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5c2:	ca19                	beqz	a2,5d8 <memset+0x1c>
 5c4:	87aa                	mv	a5,a0
 5c6:	1602                	slli	a2,a2,0x20
 5c8:	9201                	srli	a2,a2,0x20
 5ca:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5ce:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5d2:	0785                	addi	a5,a5,1
 5d4:	fee79de3          	bne	a5,a4,5ce <memset+0x12>
  }
  return dst;
}
 5d8:	6422                	ld	s0,8(sp)
 5da:	0141                	addi	sp,sp,16
 5dc:	8082                	ret

00000000000005de <strchr>:

char*
strchr(const char *s, char c)
{
 5de:	1141                	addi	sp,sp,-16
 5e0:	e422                	sd	s0,8(sp)
 5e2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 5e4:	00054783          	lbu	a5,0(a0)
 5e8:	cb99                	beqz	a5,5fe <strchr+0x20>
    if(*s == c)
 5ea:	00f58763          	beq	a1,a5,5f8 <strchr+0x1a>
  for(; *s; s++)
 5ee:	0505                	addi	a0,a0,1
 5f0:	00054783          	lbu	a5,0(a0)
 5f4:	fbfd                	bnez	a5,5ea <strchr+0xc>
      return (char*)s;
  return 0;
 5f6:	4501                	li	a0,0
}
 5f8:	6422                	ld	s0,8(sp)
 5fa:	0141                	addi	sp,sp,16
 5fc:	8082                	ret
  return 0;
 5fe:	4501                	li	a0,0
 600:	bfe5                	j	5f8 <strchr+0x1a>

0000000000000602 <gets>:

char*
gets(char *buf, int max)
{
 602:	711d                	addi	sp,sp,-96
 604:	ec86                	sd	ra,88(sp)
 606:	e8a2                	sd	s0,80(sp)
 608:	e4a6                	sd	s1,72(sp)
 60a:	e0ca                	sd	s2,64(sp)
 60c:	fc4e                	sd	s3,56(sp)
 60e:	f852                	sd	s4,48(sp)
 610:	f456                	sd	s5,40(sp)
 612:	f05a                	sd	s6,32(sp)
 614:	ec5e                	sd	s7,24(sp)
 616:	1080                	addi	s0,sp,96
 618:	8baa                	mv	s7,a0
 61a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 61c:	892a                	mv	s2,a0
 61e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 620:	4aa9                	li	s5,10
 622:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 624:	89a6                	mv	s3,s1
 626:	2485                	addiw	s1,s1,1
 628:	0344d863          	bge	s1,s4,658 <gets+0x56>
    cc = read(0, &c, 1);
 62c:	4605                	li	a2,1
 62e:	faf40593          	addi	a1,s0,-81
 632:	4501                	li	a0,0
 634:	00000097          	auipc	ra,0x0
 638:	19c080e7          	jalr	412(ra) # 7d0 <read>
    if(cc < 1)
 63c:	00a05e63          	blez	a0,658 <gets+0x56>
    buf[i++] = c;
 640:	faf44783          	lbu	a5,-81(s0)
 644:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 648:	01578763          	beq	a5,s5,656 <gets+0x54>
 64c:	0905                	addi	s2,s2,1
 64e:	fd679be3          	bne	a5,s6,624 <gets+0x22>
  for(i=0; i+1 < max; ){
 652:	89a6                	mv	s3,s1
 654:	a011                	j	658 <gets+0x56>
 656:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 658:	99de                	add	s3,s3,s7
 65a:	00098023          	sb	zero,0(s3)
  return buf;
}
 65e:	855e                	mv	a0,s7
 660:	60e6                	ld	ra,88(sp)
 662:	6446                	ld	s0,80(sp)
 664:	64a6                	ld	s1,72(sp)
 666:	6906                	ld	s2,64(sp)
 668:	79e2                	ld	s3,56(sp)
 66a:	7a42                	ld	s4,48(sp)
 66c:	7aa2                	ld	s5,40(sp)
 66e:	7b02                	ld	s6,32(sp)
 670:	6be2                	ld	s7,24(sp)
 672:	6125                	addi	sp,sp,96
 674:	8082                	ret

0000000000000676 <stat>:

int
stat(const char *n, struct stat *st)
{
 676:	1101                	addi	sp,sp,-32
 678:	ec06                	sd	ra,24(sp)
 67a:	e822                	sd	s0,16(sp)
 67c:	e426                	sd	s1,8(sp)
 67e:	e04a                	sd	s2,0(sp)
 680:	1000                	addi	s0,sp,32
 682:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 684:	4581                	li	a1,0
 686:	00000097          	auipc	ra,0x0
 68a:	172080e7          	jalr	370(ra) # 7f8 <open>
  if(fd < 0)
 68e:	02054563          	bltz	a0,6b8 <stat+0x42>
 692:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 694:	85ca                	mv	a1,s2
 696:	00000097          	auipc	ra,0x0
 69a:	17a080e7          	jalr	378(ra) # 810 <fstat>
 69e:	892a                	mv	s2,a0
  close(fd);
 6a0:	8526                	mv	a0,s1
 6a2:	00000097          	auipc	ra,0x0
 6a6:	13e080e7          	jalr	318(ra) # 7e0 <close>
  return r;
}
 6aa:	854a                	mv	a0,s2
 6ac:	60e2                	ld	ra,24(sp)
 6ae:	6442                	ld	s0,16(sp)
 6b0:	64a2                	ld	s1,8(sp)
 6b2:	6902                	ld	s2,0(sp)
 6b4:	6105                	addi	sp,sp,32
 6b6:	8082                	ret
    return -1;
 6b8:	597d                	li	s2,-1
 6ba:	bfc5                	j	6aa <stat+0x34>

00000000000006bc <atoi>:

int
atoi(const char *s)
{
 6bc:	1141                	addi	sp,sp,-16
 6be:	e422                	sd	s0,8(sp)
 6c0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6c2:	00054603          	lbu	a2,0(a0)
 6c6:	fd06079b          	addiw	a5,a2,-48
 6ca:	0ff7f793          	andi	a5,a5,255
 6ce:	4725                	li	a4,9
 6d0:	02f76963          	bltu	a4,a5,702 <atoi+0x46>
 6d4:	86aa                	mv	a3,a0
  n = 0;
 6d6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 6d8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 6da:	0685                	addi	a3,a3,1
 6dc:	0025179b          	slliw	a5,a0,0x2
 6e0:	9fa9                	addw	a5,a5,a0
 6e2:	0017979b          	slliw	a5,a5,0x1
 6e6:	9fb1                	addw	a5,a5,a2
 6e8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6ec:	0006c603          	lbu	a2,0(a3)
 6f0:	fd06071b          	addiw	a4,a2,-48
 6f4:	0ff77713          	andi	a4,a4,255
 6f8:	fee5f1e3          	bgeu	a1,a4,6da <atoi+0x1e>
  return n;
}
 6fc:	6422                	ld	s0,8(sp)
 6fe:	0141                	addi	sp,sp,16
 700:	8082                	ret
  n = 0;
 702:	4501                	li	a0,0
 704:	bfe5                	j	6fc <atoi+0x40>

0000000000000706 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 706:	1141                	addi	sp,sp,-16
 708:	e422                	sd	s0,8(sp)
 70a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 70c:	02b57463          	bgeu	a0,a1,734 <memmove+0x2e>
    while(n-- > 0)
 710:	00c05f63          	blez	a2,72e <memmove+0x28>
 714:	1602                	slli	a2,a2,0x20
 716:	9201                	srli	a2,a2,0x20
 718:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 71c:	872a                	mv	a4,a0
      *dst++ = *src++;
 71e:	0585                	addi	a1,a1,1
 720:	0705                	addi	a4,a4,1
 722:	fff5c683          	lbu	a3,-1(a1)
 726:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 72a:	fee79ae3          	bne	a5,a4,71e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 72e:	6422                	ld	s0,8(sp)
 730:	0141                	addi	sp,sp,16
 732:	8082                	ret
    dst += n;
 734:	00c50733          	add	a4,a0,a2
    src += n;
 738:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 73a:	fec05ae3          	blez	a2,72e <memmove+0x28>
 73e:	fff6079b          	addiw	a5,a2,-1
 742:	1782                	slli	a5,a5,0x20
 744:	9381                	srli	a5,a5,0x20
 746:	fff7c793          	not	a5,a5
 74a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 74c:	15fd                	addi	a1,a1,-1
 74e:	177d                	addi	a4,a4,-1
 750:	0005c683          	lbu	a3,0(a1)
 754:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 758:	fee79ae3          	bne	a5,a4,74c <memmove+0x46>
 75c:	bfc9                	j	72e <memmove+0x28>

000000000000075e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 75e:	1141                	addi	sp,sp,-16
 760:	e422                	sd	s0,8(sp)
 762:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 764:	ca05                	beqz	a2,794 <memcmp+0x36>
 766:	fff6069b          	addiw	a3,a2,-1
 76a:	1682                	slli	a3,a3,0x20
 76c:	9281                	srli	a3,a3,0x20
 76e:	0685                	addi	a3,a3,1
 770:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 772:	00054783          	lbu	a5,0(a0)
 776:	0005c703          	lbu	a4,0(a1)
 77a:	00e79863          	bne	a5,a4,78a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 77e:	0505                	addi	a0,a0,1
    p2++;
 780:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 782:	fed518e3          	bne	a0,a3,772 <memcmp+0x14>
  }
  return 0;
 786:	4501                	li	a0,0
 788:	a019                	j	78e <memcmp+0x30>
      return *p1 - *p2;
 78a:	40e7853b          	subw	a0,a5,a4
}
 78e:	6422                	ld	s0,8(sp)
 790:	0141                	addi	sp,sp,16
 792:	8082                	ret
  return 0;
 794:	4501                	li	a0,0
 796:	bfe5                	j	78e <memcmp+0x30>

0000000000000798 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 798:	1141                	addi	sp,sp,-16
 79a:	e406                	sd	ra,8(sp)
 79c:	e022                	sd	s0,0(sp)
 79e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 7a0:	00000097          	auipc	ra,0x0
 7a4:	f66080e7          	jalr	-154(ra) # 706 <memmove>
}
 7a8:	60a2                	ld	ra,8(sp)
 7aa:	6402                	ld	s0,0(sp)
 7ac:	0141                	addi	sp,sp,16
 7ae:	8082                	ret

00000000000007b0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7b0:	4885                	li	a7,1
 ecall
 7b2:	00000073          	ecall
 ret
 7b6:	8082                	ret

00000000000007b8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 7b8:	4889                	li	a7,2
 ecall
 7ba:	00000073          	ecall
 ret
 7be:	8082                	ret

00000000000007c0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 7c0:	488d                	li	a7,3
 ecall
 7c2:	00000073          	ecall
 ret
 7c6:	8082                	ret

00000000000007c8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7c8:	4891                	li	a7,4
 ecall
 7ca:	00000073          	ecall
 ret
 7ce:	8082                	ret

00000000000007d0 <read>:
.global read
read:
 li a7, SYS_read
 7d0:	4895                	li	a7,5
 ecall
 7d2:	00000073          	ecall
 ret
 7d6:	8082                	ret

00000000000007d8 <write>:
.global write
write:
 li a7, SYS_write
 7d8:	48c1                	li	a7,16
 ecall
 7da:	00000073          	ecall
 ret
 7de:	8082                	ret

00000000000007e0 <close>:
.global close
close:
 li a7, SYS_close
 7e0:	48d5                	li	a7,21
 ecall
 7e2:	00000073          	ecall
 ret
 7e6:	8082                	ret

00000000000007e8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 7e8:	4899                	li	a7,6
 ecall
 7ea:	00000073          	ecall
 ret
 7ee:	8082                	ret

00000000000007f0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 7f0:	489d                	li	a7,7
 ecall
 7f2:	00000073          	ecall
 ret
 7f6:	8082                	ret

00000000000007f8 <open>:
.global open
open:
 li a7, SYS_open
 7f8:	48bd                	li	a7,15
 ecall
 7fa:	00000073          	ecall
 ret
 7fe:	8082                	ret

0000000000000800 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 800:	48c5                	li	a7,17
 ecall
 802:	00000073          	ecall
 ret
 806:	8082                	ret

0000000000000808 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 808:	48c9                	li	a7,18
 ecall
 80a:	00000073          	ecall
 ret
 80e:	8082                	ret

0000000000000810 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 810:	48a1                	li	a7,8
 ecall
 812:	00000073          	ecall
 ret
 816:	8082                	ret

0000000000000818 <link>:
.global link
link:
 li a7, SYS_link
 818:	48cd                	li	a7,19
 ecall
 81a:	00000073          	ecall
 ret
 81e:	8082                	ret

0000000000000820 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 820:	48d1                	li	a7,20
 ecall
 822:	00000073          	ecall
 ret
 826:	8082                	ret

0000000000000828 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 828:	48a5                	li	a7,9
 ecall
 82a:	00000073          	ecall
 ret
 82e:	8082                	ret

0000000000000830 <dup>:
.global dup
dup:
 li a7, SYS_dup
 830:	48a9                	li	a7,10
 ecall
 832:	00000073          	ecall
 ret
 836:	8082                	ret

0000000000000838 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 838:	48ad                	li	a7,11
 ecall
 83a:	00000073          	ecall
 ret
 83e:	8082                	ret

0000000000000840 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 840:	48b1                	li	a7,12
 ecall
 842:	00000073          	ecall
 ret
 846:	8082                	ret

0000000000000848 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 848:	48b5                	li	a7,13
 ecall
 84a:	00000073          	ecall
 ret
 84e:	8082                	ret

0000000000000850 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 850:	48b9                	li	a7,14
 ecall
 852:	00000073          	ecall
 ret
 856:	8082                	ret

0000000000000858 <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 858:	48d9                	li	a7,22
 ecall
 85a:	00000073          	ecall
 ret
 85e:	8082                	ret

0000000000000860 <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 860:	48dd                	li	a7,23
 ecall
 862:	00000073          	ecall
 ret
 866:	8082                	ret

0000000000000868 <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 868:	48e1                	li	a7,24
 ecall
 86a:	00000073          	ecall
 ret
 86e:	8082                	ret

0000000000000870 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 870:	1101                	addi	sp,sp,-32
 872:	ec06                	sd	ra,24(sp)
 874:	e822                	sd	s0,16(sp)
 876:	1000                	addi	s0,sp,32
 878:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 87c:	4605                	li	a2,1
 87e:	fef40593          	addi	a1,s0,-17
 882:	00000097          	auipc	ra,0x0
 886:	f56080e7          	jalr	-170(ra) # 7d8 <write>
}
 88a:	60e2                	ld	ra,24(sp)
 88c:	6442                	ld	s0,16(sp)
 88e:	6105                	addi	sp,sp,32
 890:	8082                	ret

0000000000000892 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 892:	7139                	addi	sp,sp,-64
 894:	fc06                	sd	ra,56(sp)
 896:	f822                	sd	s0,48(sp)
 898:	f426                	sd	s1,40(sp)
 89a:	f04a                	sd	s2,32(sp)
 89c:	ec4e                	sd	s3,24(sp)
 89e:	0080                	addi	s0,sp,64
 8a0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 8a2:	c299                	beqz	a3,8a8 <printint+0x16>
 8a4:	0805c863          	bltz	a1,934 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 8a8:	2581                	sext.w	a1,a1
  neg = 0;
 8aa:	4881                	li	a7,0
 8ac:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 8b0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 8b2:	2601                	sext.w	a2,a2
 8b4:	00000517          	auipc	a0,0x0
 8b8:	6c450513          	addi	a0,a0,1732 # f78 <digits>
 8bc:	883a                	mv	a6,a4
 8be:	2705                	addiw	a4,a4,1
 8c0:	02c5f7bb          	remuw	a5,a1,a2
 8c4:	1782                	slli	a5,a5,0x20
 8c6:	9381                	srli	a5,a5,0x20
 8c8:	97aa                	add	a5,a5,a0
 8ca:	0007c783          	lbu	a5,0(a5)
 8ce:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 8d2:	0005879b          	sext.w	a5,a1
 8d6:	02c5d5bb          	divuw	a1,a1,a2
 8da:	0685                	addi	a3,a3,1
 8dc:	fec7f0e3          	bgeu	a5,a2,8bc <printint+0x2a>
  if(neg)
 8e0:	00088b63          	beqz	a7,8f6 <printint+0x64>
    buf[i++] = '-';
 8e4:	fd040793          	addi	a5,s0,-48
 8e8:	973e                	add	a4,a4,a5
 8ea:	02d00793          	li	a5,45
 8ee:	fef70823          	sb	a5,-16(a4)
 8f2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 8f6:	02e05863          	blez	a4,926 <printint+0x94>
 8fa:	fc040793          	addi	a5,s0,-64
 8fe:	00e78933          	add	s2,a5,a4
 902:	fff78993          	addi	s3,a5,-1
 906:	99ba                	add	s3,s3,a4
 908:	377d                	addiw	a4,a4,-1
 90a:	1702                	slli	a4,a4,0x20
 90c:	9301                	srli	a4,a4,0x20
 90e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 912:	fff94583          	lbu	a1,-1(s2)
 916:	8526                	mv	a0,s1
 918:	00000097          	auipc	ra,0x0
 91c:	f58080e7          	jalr	-168(ra) # 870 <putc>
  while(--i >= 0)
 920:	197d                	addi	s2,s2,-1
 922:	ff3918e3          	bne	s2,s3,912 <printint+0x80>
}
 926:	70e2                	ld	ra,56(sp)
 928:	7442                	ld	s0,48(sp)
 92a:	74a2                	ld	s1,40(sp)
 92c:	7902                	ld	s2,32(sp)
 92e:	69e2                	ld	s3,24(sp)
 930:	6121                	addi	sp,sp,64
 932:	8082                	ret
    x = -xx;
 934:	40b005bb          	negw	a1,a1
    neg = 1;
 938:	4885                	li	a7,1
    x = -xx;
 93a:	bf8d                	j	8ac <printint+0x1a>

000000000000093c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 93c:	7119                	addi	sp,sp,-128
 93e:	fc86                	sd	ra,120(sp)
 940:	f8a2                	sd	s0,112(sp)
 942:	f4a6                	sd	s1,104(sp)
 944:	f0ca                	sd	s2,96(sp)
 946:	ecce                	sd	s3,88(sp)
 948:	e8d2                	sd	s4,80(sp)
 94a:	e4d6                	sd	s5,72(sp)
 94c:	e0da                	sd	s6,64(sp)
 94e:	fc5e                	sd	s7,56(sp)
 950:	f862                	sd	s8,48(sp)
 952:	f466                	sd	s9,40(sp)
 954:	f06a                	sd	s10,32(sp)
 956:	ec6e                	sd	s11,24(sp)
 958:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 95a:	0005c903          	lbu	s2,0(a1)
 95e:	18090f63          	beqz	s2,afc <vprintf+0x1c0>
 962:	8aaa                	mv	s5,a0
 964:	8b32                	mv	s6,a2
 966:	00158493          	addi	s1,a1,1
  state = 0;
 96a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 96c:	02500a13          	li	s4,37
      if(c == 'd'){
 970:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 974:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 978:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 97c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 980:	00000b97          	auipc	s7,0x0
 984:	5f8b8b93          	addi	s7,s7,1528 # f78 <digits>
 988:	a839                	j	9a6 <vprintf+0x6a>
        putc(fd, c);
 98a:	85ca                	mv	a1,s2
 98c:	8556                	mv	a0,s5
 98e:	00000097          	auipc	ra,0x0
 992:	ee2080e7          	jalr	-286(ra) # 870 <putc>
 996:	a019                	j	99c <vprintf+0x60>
    } else if(state == '%'){
 998:	01498f63          	beq	s3,s4,9b6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 99c:	0485                	addi	s1,s1,1
 99e:	fff4c903          	lbu	s2,-1(s1)
 9a2:	14090d63          	beqz	s2,afc <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 9a6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 9aa:	fe0997e3          	bnez	s3,998 <vprintf+0x5c>
      if(c == '%'){
 9ae:	fd479ee3          	bne	a5,s4,98a <vprintf+0x4e>
        state = '%';
 9b2:	89be                	mv	s3,a5
 9b4:	b7e5                	j	99c <vprintf+0x60>
      if(c == 'd'){
 9b6:	05878063          	beq	a5,s8,9f6 <vprintf+0xba>
      } else if(c == 'l') {
 9ba:	05978c63          	beq	a5,s9,a12 <vprintf+0xd6>
      } else if(c == 'x') {
 9be:	07a78863          	beq	a5,s10,a2e <vprintf+0xf2>
      } else if(c == 'p') {
 9c2:	09b78463          	beq	a5,s11,a4a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 9c6:	07300713          	li	a4,115
 9ca:	0ce78663          	beq	a5,a4,a96 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9ce:	06300713          	li	a4,99
 9d2:	0ee78e63          	beq	a5,a4,ace <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 9d6:	11478863          	beq	a5,s4,ae6 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9da:	85d2                	mv	a1,s4
 9dc:	8556                	mv	a0,s5
 9de:	00000097          	auipc	ra,0x0
 9e2:	e92080e7          	jalr	-366(ra) # 870 <putc>
        putc(fd, c);
 9e6:	85ca                	mv	a1,s2
 9e8:	8556                	mv	a0,s5
 9ea:	00000097          	auipc	ra,0x0
 9ee:	e86080e7          	jalr	-378(ra) # 870 <putc>
      }
      state = 0;
 9f2:	4981                	li	s3,0
 9f4:	b765                	j	99c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 9f6:	008b0913          	addi	s2,s6,8
 9fa:	4685                	li	a3,1
 9fc:	4629                	li	a2,10
 9fe:	000b2583          	lw	a1,0(s6)
 a02:	8556                	mv	a0,s5
 a04:	00000097          	auipc	ra,0x0
 a08:	e8e080e7          	jalr	-370(ra) # 892 <printint>
 a0c:	8b4a                	mv	s6,s2
      state = 0;
 a0e:	4981                	li	s3,0
 a10:	b771                	j	99c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a12:	008b0913          	addi	s2,s6,8
 a16:	4681                	li	a3,0
 a18:	4629                	li	a2,10
 a1a:	000b2583          	lw	a1,0(s6)
 a1e:	8556                	mv	a0,s5
 a20:	00000097          	auipc	ra,0x0
 a24:	e72080e7          	jalr	-398(ra) # 892 <printint>
 a28:	8b4a                	mv	s6,s2
      state = 0;
 a2a:	4981                	li	s3,0
 a2c:	bf85                	j	99c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 a2e:	008b0913          	addi	s2,s6,8
 a32:	4681                	li	a3,0
 a34:	4641                	li	a2,16
 a36:	000b2583          	lw	a1,0(s6)
 a3a:	8556                	mv	a0,s5
 a3c:	00000097          	auipc	ra,0x0
 a40:	e56080e7          	jalr	-426(ra) # 892 <printint>
 a44:	8b4a                	mv	s6,s2
      state = 0;
 a46:	4981                	li	s3,0
 a48:	bf91                	j	99c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 a4a:	008b0793          	addi	a5,s6,8
 a4e:	f8f43423          	sd	a5,-120(s0)
 a52:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 a56:	03000593          	li	a1,48
 a5a:	8556                	mv	a0,s5
 a5c:	00000097          	auipc	ra,0x0
 a60:	e14080e7          	jalr	-492(ra) # 870 <putc>
  putc(fd, 'x');
 a64:	85ea                	mv	a1,s10
 a66:	8556                	mv	a0,s5
 a68:	00000097          	auipc	ra,0x0
 a6c:	e08080e7          	jalr	-504(ra) # 870 <putc>
 a70:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a72:	03c9d793          	srli	a5,s3,0x3c
 a76:	97de                	add	a5,a5,s7
 a78:	0007c583          	lbu	a1,0(a5)
 a7c:	8556                	mv	a0,s5
 a7e:	00000097          	auipc	ra,0x0
 a82:	df2080e7          	jalr	-526(ra) # 870 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a86:	0992                	slli	s3,s3,0x4
 a88:	397d                	addiw	s2,s2,-1
 a8a:	fe0914e3          	bnez	s2,a72 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 a8e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 a92:	4981                	li	s3,0
 a94:	b721                	j	99c <vprintf+0x60>
        s = va_arg(ap, char*);
 a96:	008b0993          	addi	s3,s6,8
 a9a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 a9e:	02090163          	beqz	s2,ac0 <vprintf+0x184>
        while(*s != 0){
 aa2:	00094583          	lbu	a1,0(s2)
 aa6:	c9a1                	beqz	a1,af6 <vprintf+0x1ba>
          putc(fd, *s);
 aa8:	8556                	mv	a0,s5
 aaa:	00000097          	auipc	ra,0x0
 aae:	dc6080e7          	jalr	-570(ra) # 870 <putc>
          s++;
 ab2:	0905                	addi	s2,s2,1
        while(*s != 0){
 ab4:	00094583          	lbu	a1,0(s2)
 ab8:	f9e5                	bnez	a1,aa8 <vprintf+0x16c>
        s = va_arg(ap, char*);
 aba:	8b4e                	mv	s6,s3
      state = 0;
 abc:	4981                	li	s3,0
 abe:	bdf9                	j	99c <vprintf+0x60>
          s = "(null)";
 ac0:	00000917          	auipc	s2,0x0
 ac4:	4b090913          	addi	s2,s2,1200 # f70 <malloc+0x36a>
        while(*s != 0){
 ac8:	02800593          	li	a1,40
 acc:	bff1                	j	aa8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 ace:	008b0913          	addi	s2,s6,8
 ad2:	000b4583          	lbu	a1,0(s6)
 ad6:	8556                	mv	a0,s5
 ad8:	00000097          	auipc	ra,0x0
 adc:	d98080e7          	jalr	-616(ra) # 870 <putc>
 ae0:	8b4a                	mv	s6,s2
      state = 0;
 ae2:	4981                	li	s3,0
 ae4:	bd65                	j	99c <vprintf+0x60>
        putc(fd, c);
 ae6:	85d2                	mv	a1,s4
 ae8:	8556                	mv	a0,s5
 aea:	00000097          	auipc	ra,0x0
 aee:	d86080e7          	jalr	-634(ra) # 870 <putc>
      state = 0;
 af2:	4981                	li	s3,0
 af4:	b565                	j	99c <vprintf+0x60>
        s = va_arg(ap, char*);
 af6:	8b4e                	mv	s6,s3
      state = 0;
 af8:	4981                	li	s3,0
 afa:	b54d                	j	99c <vprintf+0x60>
    }
  }
}
 afc:	70e6                	ld	ra,120(sp)
 afe:	7446                	ld	s0,112(sp)
 b00:	74a6                	ld	s1,104(sp)
 b02:	7906                	ld	s2,96(sp)
 b04:	69e6                	ld	s3,88(sp)
 b06:	6a46                	ld	s4,80(sp)
 b08:	6aa6                	ld	s5,72(sp)
 b0a:	6b06                	ld	s6,64(sp)
 b0c:	7be2                	ld	s7,56(sp)
 b0e:	7c42                	ld	s8,48(sp)
 b10:	7ca2                	ld	s9,40(sp)
 b12:	7d02                	ld	s10,32(sp)
 b14:	6de2                	ld	s11,24(sp)
 b16:	6109                	addi	sp,sp,128
 b18:	8082                	ret

0000000000000b1a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b1a:	715d                	addi	sp,sp,-80
 b1c:	ec06                	sd	ra,24(sp)
 b1e:	e822                	sd	s0,16(sp)
 b20:	1000                	addi	s0,sp,32
 b22:	e010                	sd	a2,0(s0)
 b24:	e414                	sd	a3,8(s0)
 b26:	e818                	sd	a4,16(s0)
 b28:	ec1c                	sd	a5,24(s0)
 b2a:	03043023          	sd	a6,32(s0)
 b2e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b32:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b36:	8622                	mv	a2,s0
 b38:	00000097          	auipc	ra,0x0
 b3c:	e04080e7          	jalr	-508(ra) # 93c <vprintf>
}
 b40:	60e2                	ld	ra,24(sp)
 b42:	6442                	ld	s0,16(sp)
 b44:	6161                	addi	sp,sp,80
 b46:	8082                	ret

0000000000000b48 <printf>:

void
printf(const char *fmt, ...)
{
 b48:	711d                	addi	sp,sp,-96
 b4a:	ec06                	sd	ra,24(sp)
 b4c:	e822                	sd	s0,16(sp)
 b4e:	1000                	addi	s0,sp,32
 b50:	e40c                	sd	a1,8(s0)
 b52:	e810                	sd	a2,16(s0)
 b54:	ec14                	sd	a3,24(s0)
 b56:	f018                	sd	a4,32(s0)
 b58:	f41c                	sd	a5,40(s0)
 b5a:	03043823          	sd	a6,48(s0)
 b5e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b62:	00840613          	addi	a2,s0,8
 b66:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b6a:	85aa                	mv	a1,a0
 b6c:	4505                	li	a0,1
 b6e:	00000097          	auipc	ra,0x0
 b72:	dce080e7          	jalr	-562(ra) # 93c <vprintf>
}
 b76:	60e2                	ld	ra,24(sp)
 b78:	6442                	ld	s0,16(sp)
 b7a:	6125                	addi	sp,sp,96
 b7c:	8082                	ret

0000000000000b7e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b7e:	1141                	addi	sp,sp,-16
 b80:	e422                	sd	s0,8(sp)
 b82:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b84:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b88:	00000797          	auipc	a5,0x0
 b8c:	4107b783          	ld	a5,1040(a5) # f98 <freep>
 b90:	a805                	j	bc0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b92:	4618                	lw	a4,8(a2)
 b94:	9db9                	addw	a1,a1,a4
 b96:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b9a:	6398                	ld	a4,0(a5)
 b9c:	6318                	ld	a4,0(a4)
 b9e:	fee53823          	sd	a4,-16(a0)
 ba2:	a091                	j	be6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ba4:	ff852703          	lw	a4,-8(a0)
 ba8:	9e39                	addw	a2,a2,a4
 baa:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 bac:	ff053703          	ld	a4,-16(a0)
 bb0:	e398                	sd	a4,0(a5)
 bb2:	a099                	j	bf8 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bb4:	6398                	ld	a4,0(a5)
 bb6:	00e7e463          	bltu	a5,a4,bbe <free+0x40>
 bba:	00e6ea63          	bltu	a3,a4,bce <free+0x50>
{
 bbe:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bc0:	fed7fae3          	bgeu	a5,a3,bb4 <free+0x36>
 bc4:	6398                	ld	a4,0(a5)
 bc6:	00e6e463          	bltu	a3,a4,bce <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bca:	fee7eae3          	bltu	a5,a4,bbe <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 bce:	ff852583          	lw	a1,-8(a0)
 bd2:	6390                	ld	a2,0(a5)
 bd4:	02059813          	slli	a6,a1,0x20
 bd8:	01c85713          	srli	a4,a6,0x1c
 bdc:	9736                	add	a4,a4,a3
 bde:	fae60ae3          	beq	a2,a4,b92 <free+0x14>
    bp->s.ptr = p->s.ptr;
 be2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 be6:	4790                	lw	a2,8(a5)
 be8:	02061593          	slli	a1,a2,0x20
 bec:	01c5d713          	srli	a4,a1,0x1c
 bf0:	973e                	add	a4,a4,a5
 bf2:	fae689e3          	beq	a3,a4,ba4 <free+0x26>
  } else
    p->s.ptr = bp;
 bf6:	e394                	sd	a3,0(a5)
  freep = p;
 bf8:	00000717          	auipc	a4,0x0
 bfc:	3af73023          	sd	a5,928(a4) # f98 <freep>
}
 c00:	6422                	ld	s0,8(sp)
 c02:	0141                	addi	sp,sp,16
 c04:	8082                	ret

0000000000000c06 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c06:	7139                	addi	sp,sp,-64
 c08:	fc06                	sd	ra,56(sp)
 c0a:	f822                	sd	s0,48(sp)
 c0c:	f426                	sd	s1,40(sp)
 c0e:	f04a                	sd	s2,32(sp)
 c10:	ec4e                	sd	s3,24(sp)
 c12:	e852                	sd	s4,16(sp)
 c14:	e456                	sd	s5,8(sp)
 c16:	e05a                	sd	s6,0(sp)
 c18:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c1a:	02051493          	slli	s1,a0,0x20
 c1e:	9081                	srli	s1,s1,0x20
 c20:	04bd                	addi	s1,s1,15
 c22:	8091                	srli	s1,s1,0x4
 c24:	0014899b          	addiw	s3,s1,1
 c28:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 c2a:	00000517          	auipc	a0,0x0
 c2e:	36e53503          	ld	a0,878(a0) # f98 <freep>
 c32:	c515                	beqz	a0,c5e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c34:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c36:	4798                	lw	a4,8(a5)
 c38:	02977f63          	bgeu	a4,s1,c76 <malloc+0x70>
 c3c:	8a4e                	mv	s4,s3
 c3e:	0009871b          	sext.w	a4,s3
 c42:	6685                	lui	a3,0x1
 c44:	00d77363          	bgeu	a4,a3,c4a <malloc+0x44>
 c48:	6a05                	lui	s4,0x1
 c4a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c4e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c52:	00000917          	auipc	s2,0x0
 c56:	34690913          	addi	s2,s2,838 # f98 <freep>
  if(p == (char*)-1)
 c5a:	5afd                	li	s5,-1
 c5c:	a895                	j	cd0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 c5e:	00000797          	auipc	a5,0x0
 c62:	34278793          	addi	a5,a5,834 # fa0 <base>
 c66:	00000717          	auipc	a4,0x0
 c6a:	32f73923          	sd	a5,818(a4) # f98 <freep>
 c6e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c70:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c74:	b7e1                	j	c3c <malloc+0x36>
      if(p->s.size == nunits)
 c76:	02e48c63          	beq	s1,a4,cae <malloc+0xa8>
        p->s.size -= nunits;
 c7a:	4137073b          	subw	a4,a4,s3
 c7e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c80:	02071693          	slli	a3,a4,0x20
 c84:	01c6d713          	srli	a4,a3,0x1c
 c88:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c8a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c8e:	00000717          	auipc	a4,0x0
 c92:	30a73523          	sd	a0,778(a4) # f98 <freep>
      return (void*)(p + 1);
 c96:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 c9a:	70e2                	ld	ra,56(sp)
 c9c:	7442                	ld	s0,48(sp)
 c9e:	74a2                	ld	s1,40(sp)
 ca0:	7902                	ld	s2,32(sp)
 ca2:	69e2                	ld	s3,24(sp)
 ca4:	6a42                	ld	s4,16(sp)
 ca6:	6aa2                	ld	s5,8(sp)
 ca8:	6b02                	ld	s6,0(sp)
 caa:	6121                	addi	sp,sp,64
 cac:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 cae:	6398                	ld	a4,0(a5)
 cb0:	e118                	sd	a4,0(a0)
 cb2:	bff1                	j	c8e <malloc+0x88>
  hp->s.size = nu;
 cb4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cb8:	0541                	addi	a0,a0,16
 cba:	00000097          	auipc	ra,0x0
 cbe:	ec4080e7          	jalr	-316(ra) # b7e <free>
  return freep;
 cc2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 cc6:	d971                	beqz	a0,c9a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cc8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cca:	4798                	lw	a4,8(a5)
 ccc:	fa9775e3          	bgeu	a4,s1,c76 <malloc+0x70>
    if(p == freep)
 cd0:	00093703          	ld	a4,0(s2)
 cd4:	853e                	mv	a0,a5
 cd6:	fef719e3          	bne	a4,a5,cc8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 cda:	8552                	mv	a0,s4
 cdc:	00000097          	auipc	ra,0x0
 ce0:	b64080e7          	jalr	-1180(ra) # 840 <sbrk>
  if(p == (char*)-1)
 ce4:	fd5518e3          	bne	a0,s5,cb4 <malloc+0xae>
        return 0;
 ce8:	4501                	li	a0,0
 cea:	bf45                	j	c9a <malloc+0x94>
