
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
   e:	16a7ad23          	sw	a0,378(a5) # 1184 <flag>
    printf("handle -> signum: %d\n", signum);
  12:	00001517          	auipc	a0,0x1
  16:	e3e50513          	addi	a0,a0,-450 # e50 <malloc+0xe8>
  1a:	00001097          	auipc	ra,0x1
  1e:	c90080e7          	jalr	-880(ra) # caa <printf>
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
  38:	14a7a823          	sw	a0,336(a5) # 1184 <flag>
    printf("handle2 -> signum: %d\n", signum);
  3c:	00001517          	auipc	a0,0x1
  40:	e2c50513          	addi	a0,a0,-468 # e68 <malloc+0x100>
  44:	00001097          	auipc	ra,0x1
  48:	c66080e7          	jalr	-922(ra) # caa <printf>
}
  4c:	60a2                	ld	ra,8(sp)
  4e:	6402                	ld	s0,0(sp)
  50:	0141                	addi	sp,sp,16
  52:	8082                	ret

0000000000000054 <handle3>:

void handle3(int signum){
  54:	1101                	addi	sp,sp,-32
  56:	ec06                	sd	ra,24(sp)
  58:	e822                	sd	s0,16(sp)
  5a:	e426                	sd	s1,8(sp)
  5c:	1000                	addi	s0,sp,32
  5e:	84aa                	mv	s1,a0
    flag = signum;
  60:	00001797          	auipc	a5,0x1
  64:	12a7a223          	sw	a0,292(a5) # 1184 <flag>
    printf("in handle3, flag = %d\n", flag);
  68:	85aa                	mv	a1,a0
  6a:	00001517          	auipc	a0,0x1
  6e:	e1650513          	addi	a0,a0,-490 # e80 <malloc+0x118>
  72:	00001097          	auipc	ra,0x1
  76:	c38080e7          	jalr	-968(ra) # caa <printf>
    printf("handle3 -> signum: %d\n", signum);
  7a:	85a6                	mv	a1,s1
  7c:	00001517          	auipc	a0,0x1
  80:	e1c50513          	addi	a0,a0,-484 # e98 <malloc+0x130>
  84:	00001097          	auipc	ra,0x1
  88:	c26080e7          	jalr	-986(ra) # caa <printf>
}
  8c:	60e2                	ld	ra,24(sp)
  8e:	6442                	ld	s0,16(sp)
  90:	64a2                	ld	s1,8(sp)
  92:	6105                	addi	sp,sp,32
  94:	8082                	ret

0000000000000096 <test_handler>:

int wait_sig = 0;

void test_handler(int signum){
  96:	1141                	addi	sp,sp,-16
  98:	e406                	sd	ra,8(sp)
  9a:	e022                	sd	s0,0(sp)
  9c:	0800                	addi	s0,sp,16
    wait_sig = 1;
  9e:	4785                	li	a5,1
  a0:	00001717          	auipc	a4,0x1
  a4:	0ef72023          	sw	a5,224(a4) # 1180 <wait_sig>
    printf("Received sigtest\n");
  a8:	00001517          	auipc	a0,0x1
  ac:	e0850513          	addi	a0,a0,-504 # eb0 <malloc+0x148>
  b0:	00001097          	auipc	ra,0x1
  b4:	bfa080e7          	jalr	-1030(ra) # caa <printf>
}
  b8:	60a2                	ld	ra,8(sp)
  ba:	6402                	ld	s0,0(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <test_sigkill>:


void test_sigkill(void){
  c0:	1101                	addi	sp,sp,-32
  c2:	ec06                	sd	ra,24(sp)
  c4:	e822                	sd	s0,16(sp)
  c6:	e426                	sd	s1,8(sp)
  c8:	1000                	addi	s0,sp,32
  
  printf("test sigkill start\n");
  ca:	00001517          	auipc	a0,0x1
  ce:	dfe50513          	addi	a0,a0,-514 # ec8 <malloc+0x160>
  d2:	00001097          	auipc	ra,0x1
  d6:	bd8080e7          	jalr	-1064(ra) # caa <printf>
  int cpid = fork();
  da:	00001097          	auipc	ra,0x1
  de:	838080e7          	jalr	-1992(ra) # 912 <fork>
  if(cpid == 0){
  e2:	e111                	bnez	a0,e6 <test_sigkill+0x26>
    while(1);
  e4:	a001                	j	e4 <test_sigkill+0x24>
  e6:	84aa                	mv	s1,a0
  }
  else{
    sleep(5);
  e8:	4515                	li	a0,5
  ea:	00001097          	auipc	ra,0x1
  ee:	8c0080e7          	jalr	-1856(ra) # 9aa <sleep>
    kill(cpid, SIGKILL);
  f2:	45a5                	li	a1,9
  f4:	8526                	mv	a0,s1
  f6:	00001097          	auipc	ra,0x1
  fa:	854080e7          	jalr	-1964(ra) # 94a <kill>
  }
  printf("test_sigkill OK\n");
  fe:	00001517          	auipc	a0,0x1
 102:	de250513          	addi	a0,a0,-542 # ee0 <malloc+0x178>
 106:	00001097          	auipc	ra,0x1
 10a:	ba4080e7          	jalr	-1116(ra) # caa <printf>

}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6105                	addi	sp,sp,32
 116:	8082                	ret

0000000000000118 <test_sigkill_othersig>:

void test_sigkill_othersig(void){
 118:	1101                	addi	sp,sp,-32
 11a:	ec06                	sd	ra,24(sp)
 11c:	e822                	sd	s0,16(sp)
 11e:	e426                	sd	s1,8(sp)
 120:	1000                	addi	s0,sp,32
  
  printf("kill other sig test start\n");
 122:	00001517          	auipc	a0,0x1
 126:	dd650513          	addi	a0,a0,-554 # ef8 <malloc+0x190>
 12a:	00001097          	auipc	ra,0x1
 12e:	b80080e7          	jalr	-1152(ra) # caa <printf>
  int cpid = fork();
 132:	00000097          	auipc	ra,0x0
 136:	7e0080e7          	jalr	2016(ra) # 912 <fork>
  if(cpid == 0){
 13a:	e111                	bnez	a0,13e <test_sigkill_othersig+0x26>
    while(1);
 13c:	a001                	j	13c <test_sigkill_othersig+0x24>
 13e:	84aa                	mv	s1,a0
  }
  else{
    sleep(100);
 140:	06400513          	li	a0,100
 144:	00001097          	auipc	ra,0x1
 148:	866080e7          	jalr	-1946(ra) # 9aa <sleep>
    kill(cpid, 15);
 14c:	45bd                	li	a1,15
 14e:	8526                	mv	a0,s1
 150:	00000097          	auipc	ra,0x0
 154:	7fa080e7          	jalr	2042(ra) # 94a <kill>
  }
  printf("kill other sig test OK\n");
 158:	00001517          	auipc	a0,0x1
 15c:	dc050513          	addi	a0,a0,-576 # f18 <malloc+0x1b0>
 160:	00001097          	auipc	ra,0x1
 164:	b4a080e7          	jalr	-1206(ra) # caa <printf>

}
 168:	60e2                	ld	ra,24(sp)
 16a:	6442                	ld	s0,16(sp)
 16c:	64a2                	ld	s1,8(sp)
 16e:	6105                	addi	sp,sp,32
 170:	8082                	ret

0000000000000172 <test_custom_signal>:


void test_custom_signal(void){
 172:	7179                	addi	sp,sp,-48
 174:	f406                	sd	ra,40(sp)
 176:	f022                	sd	s0,32(sp)
 178:	ec26                	sd	s1,24(sp)
 17a:	e84a                	sd	s2,16(sp)
 17c:	e44e                	sd	s3,8(sp)
 17e:	e052                	sd	s4,0(sp)
 180:	1800                	addi	s0,sp,48
  
  printf("custon signal test start\n");
 182:	00001517          	auipc	a0,0x1
 186:	dae50513          	addi	a0,a0,-594 # f30 <malloc+0x1c8>
 18a:	00001097          	auipc	ra,0x1
 18e:	b20080e7          	jalr	-1248(ra) # caa <printf>
  struct sigaction* act = malloc(sizeof(struct sigaction *));
 192:	4521                	li	a0,8
 194:	00001097          	auipc	ra,0x1
 198:	bd4080e7          	jalr	-1068(ra) # d68 <malloc>
 19c:	89aa                	mv	s3,a0
  act->sa_handler = handle;
 19e:	00000797          	auipc	a5,0x0
 1a2:	e6278793          	addi	a5,a5,-414 # 0 <handle>
 1a6:	e11c                	sd	a5,0(a0)
  act->sigmask = 0;
 1a8:	00052423          	sw	zero,8(a0)

  struct sigaction* act2 = malloc(sizeof(struct sigaction *));
 1ac:	4521                	li	a0,8
 1ae:	00001097          	auipc	ra,0x1
 1b2:	bba080e7          	jalr	-1094(ra) # d68 <malloc>
 1b6:	892a                	mv	s2,a0
  act2->sa_handler = handle2;
 1b8:	00000797          	auipc	a5,0x0
 1bc:	e7278793          	addi	a5,a5,-398 # 2a <handle2>
 1c0:	e11c                	sd	a5,0(a0)
  act2->sigmask = 0;
 1c2:	00052423          	sw	zero,8(a0)

  struct sigaction* act3 = malloc(sizeof(struct sigaction *));
 1c6:	4521                	li	a0,8
 1c8:	00001097          	auipc	ra,0x1
 1cc:	ba0080e7          	jalr	-1120(ra) # d68 <malloc>
 1d0:	84aa                	mv	s1,a0
  act3->sa_handler = handle3;
 1d2:	00000a17          	auipc	s4,0x0
 1d6:	e82a0a13          	addi	s4,s4,-382 # 54 <handle3>
 1da:	01453023          	sd	s4,0(a0)
  act3->sigmask = 0;
 1de:	00052423          	sw	zero,8(a0)

  sigaction(5, act, 0);
 1e2:	4601                	li	a2,0
 1e4:	85ce                	mv	a1,s3
 1e6:	4515                	li	a0,5
 1e8:	00000097          	auipc	ra,0x0
 1ec:	7da080e7          	jalr	2010(ra) # 9c2 <sigaction>
  sigaction(2, act2, 0);
 1f0:	4601                	li	a2,0
 1f2:	85ca                	mv	a1,s2
 1f4:	4509                	li	a0,2
 1f6:	00000097          	auipc	ra,0x0
 1fa:	7cc080e7          	jalr	1996(ra) # 9c2 <sigaction>
  int ret3 = sigaction(7, act3, 0);
 1fe:	4601                	li	a2,0
 200:	85a6                	mv	a1,s1
 202:	451d                	li	a0,7
 204:	00000097          	auipc	ra,0x0
 208:	7be080e7          	jalr	1982(ra) # 9c2 <sigaction>
 20c:	85aa                	mv	a1,a0
  printf("ret3 = %d\n", ret3);
 20e:	00001517          	auipc	a0,0x1
 212:	d4250513          	addi	a0,a0,-702 # f50 <malloc+0x1e8>
 216:	00001097          	auipc	ra,0x1
 21a:	a94080e7          	jalr	-1388(ra) # caa <printf>
   printf("The address of the function handle3 is =%p\n",handle3);
 21e:	85d2                	mv	a1,s4
 220:	00001517          	auipc	a0,0x1
 224:	d4050513          	addi	a0,a0,-704 # f60 <malloc+0x1f8>
 228:	00001097          	auipc	ra,0x1
 22c:	a82080e7          	jalr	-1406(ra) # caa <printf>

  int cpid = fork();
 230:	00000097          	auipc	ra,0x0
 234:	6e2080e7          	jalr	1762(ra) # 912 <fork>
  if(cpid == 0){
 238:	e505                	bnez	a0,260 <test_custom_signal+0xee>
    while(1){
      if(flag == 7){
 23a:	00001997          	auipc	s3,0x1
 23e:	f4a98993          	addi	s3,s3,-182 # 1184 <flag>
 242:	449d                	li	s1,7
        printf("successfully recieved signal\n");
 244:	00001917          	auipc	s2,0x1
 248:	d4c90913          	addi	s2,s2,-692 # f90 <malloc+0x228>
      if(flag == 7){
 24c:	0009a783          	lw	a5,0(s3)
 250:	00979063          	bne	a5,s1,250 <test_custom_signal+0xde>
        printf("successfully recieved signal\n");
 254:	854a                	mv	a0,s2
 256:	00001097          	auipc	ra,0x1
 25a:	a54080e7          	jalr	-1452(ra) # caa <printf>
 25e:	b7fd                	j	24c <test_custom_signal+0xda>
 260:	84aa                	mv	s1,a0
      }
    }
  }
  else{
    sleep(100);
 262:	06400513          	li	a0,100
 266:	00000097          	auipc	ra,0x0
 26a:	744080e7          	jalr	1860(ra) # 9aa <sleep>
    printf( "sending signal %d\n" , 7);
 26e:	459d                	li	a1,7
 270:	00001517          	auipc	a0,0x1
 274:	d4050513          	addi	a0,a0,-704 # fb0 <malloc+0x248>
 278:	00001097          	auipc	ra,0x1
 27c:	a32080e7          	jalr	-1486(ra) # caa <printf>
    kill(cpid, 7);
 280:	459d                	li	a1,7
 282:	8526                	mv	a0,s1
 284:	00000097          	auipc	ra,0x0
 288:	6c6080e7          	jalr	1734(ra) # 94a <kill>
    sleep(100);
 28c:	06400513          	li	a0,100
 290:	00000097          	auipc	ra,0x0
 294:	71a080e7          	jalr	1818(ra) # 9aa <sleep>
    kill(cpid, SIGKILL);
 298:	45a5                	li	a1,9
 29a:	8526                	mv	a0,s1
 29c:	00000097          	auipc	ra,0x0
 2a0:	6ae080e7          	jalr	1710(ra) # 94a <kill>
  }
  wait(0);
 2a4:	4501                	li	a0,0
 2a6:	00000097          	auipc	ra,0x0
 2aa:	67c080e7          	jalr	1660(ra) # 922 <wait>
  printf("custom sig test OK\n");
 2ae:	00001517          	auipc	a0,0x1
 2b2:	d1a50513          	addi	a0,a0,-742 # fc8 <malloc+0x260>
 2b6:	00001097          	auipc	ra,0x1
 2ba:	9f4080e7          	jalr	-1548(ra) # caa <printf>
  flag = 0;
 2be:	00001797          	auipc	a5,0x1
 2c2:	ec07a323          	sw	zero,-314(a5) # 1184 <flag>
}
 2c6:	70a2                	ld	ra,40(sp)
 2c8:	7402                	ld	s0,32(sp)
 2ca:	64e2                	ld	s1,24(sp)
 2cc:	6942                	ld	s2,16(sp)
 2ce:	69a2                	ld	s3,8(sp)
 2d0:	6a02                	ld	s4,0(sp)
 2d2:	6145                	addi	sp,sp,48
 2d4:	8082                	ret

00000000000002d6 <test_stop_cont>:

void test_stop_cont(void){
 2d6:	1101                	addi	sp,sp,-32
 2d8:	ec06                	sd	ra,24(sp)
 2da:	e822                	sd	s0,16(sp)
 2dc:	e426                	sd	s1,8(sp)
 2de:	1000                	addi	s0,sp,32

  printf("stop cont test start\n");
 2e0:	00001517          	auipc	a0,0x1
 2e4:	d0050513          	addi	a0,a0,-768 # fe0 <malloc+0x278>
 2e8:	00001097          	auipc	ra,0x1
 2ec:	9c2080e7          	jalr	-1598(ra) # caa <printf>

  int cpid = fork();
 2f0:	00000097          	auipc	ra,0x0
 2f4:	622080e7          	jalr	1570(ra) # 912 <fork>
  if(cpid == 0){
 2f8:	e105                	bnez	a0,318 <test_stop_cont+0x42>
    while(1){
      printf("in while\n");
 2fa:	00001497          	auipc	s1,0x1
 2fe:	cfe48493          	addi	s1,s1,-770 # ff8 <malloc+0x290>
 302:	8526                	mv	a0,s1
 304:	00001097          	auipc	ra,0x1
 308:	9a6080e7          	jalr	-1626(ra) # caa <printf>
      sleep(10);
 30c:	4529                	li	a0,10
 30e:	00000097          	auipc	ra,0x0
 312:	69c080e7          	jalr	1692(ra) # 9aa <sleep>
    while(1){
 316:	b7f5                	j	302 <test_stop_cont+0x2c>
 318:	84aa                	mv	s1,a0
    }
  }
  else{
    sleep(5);
 31a:	4515                	li	a0,5
 31c:	00000097          	auipc	ra,0x0
 320:	68e080e7          	jalr	1678(ra) # 9aa <sleep>
    printf("sending stop\n");
 324:	00001517          	auipc	a0,0x1
 328:	ce450513          	addi	a0,a0,-796 # 1008 <malloc+0x2a0>
 32c:	00001097          	auipc	ra,0x1
 330:	97e080e7          	jalr	-1666(ra) # caa <printf>
    kill(cpid, SIGSTOP);
 334:	45c5                	li	a1,17
 336:	8526                	mv	a0,s1
 338:	00000097          	auipc	ra,0x0
 33c:	612080e7          	jalr	1554(ra) # 94a <kill>

    sleep(5);
 340:	4515                	li	a0,5
 342:	00000097          	auipc	ra,0x0
 346:	668080e7          	jalr	1640(ra) # 9aa <sleep>
    printf("sending cont\n");
 34a:	00001517          	auipc	a0,0x1
 34e:	cce50513          	addi	a0,a0,-818 # 1018 <malloc+0x2b0>
 352:	00001097          	auipc	ra,0x1
 356:	958080e7          	jalr	-1704(ra) # caa <printf>
    kill(cpid, SIGCONT);
 35a:	45cd                	li	a1,19
 35c:	8526                	mv	a0,s1
 35e:	00000097          	auipc	ra,0x0
 362:	5ec080e7          	jalr	1516(ra) # 94a <kill>

    sleep(10);
 366:	4529                	li	a0,10
 368:	00000097          	auipc	ra,0x0
 36c:	642080e7          	jalr	1602(ra) # 9aa <sleep>
    printf("killing\n");
 370:	00001517          	auipc	a0,0x1
 374:	cb850513          	addi	a0,a0,-840 # 1028 <malloc+0x2c0>
 378:	00001097          	auipc	ra,0x1
 37c:	932080e7          	jalr	-1742(ra) # caa <printf>
    kill(cpid, SIGKILL);
 380:	45a5                	li	a1,9
 382:	8526                	mv	a0,s1
 384:	00000097          	auipc	ra,0x0
 388:	5c6080e7          	jalr	1478(ra) # 94a <kill>
  }
  wait(0);
 38c:	4501                	li	a0,0
 38e:	00000097          	auipc	ra,0x0
 392:	594080e7          	jalr	1428(ra) # 922 <wait>
  printf("stop cont test OK\n");
 396:	00001517          	auipc	a0,0x1
 39a:	ca250513          	addi	a0,a0,-862 # 1038 <malloc+0x2d0>
 39e:	00001097          	auipc	ra,0x1
 3a2:	90c080e7          	jalr	-1780(ra) # caa <printf>
}
 3a6:	60e2                	ld	ra,24(sp)
 3a8:	6442                	ld	s0,16(sp)
 3aa:	64a2                	ld	s1,8(sp)
 3ac:	6105                	addi	sp,sp,32
 3ae:	8082                	ret

00000000000003b0 <test_sig_ign>:


void test_sig_ign(void){
 3b0:	7179                	addi	sp,sp,-48
 3b2:	f406                	sd	ra,40(sp)
 3b4:	f022                	sd	s0,32(sp)
 3b6:	ec26                	sd	s1,24(sp)
 3b8:	e84a                	sd	s2,16(sp)
 3ba:	e44e                	sd	s3,8(sp)
 3bc:	1800                	addi	s0,sp,48
  printf( "sig ign test start\n");
 3be:	00001517          	auipc	a0,0x1
 3c2:	c9250513          	addi	a0,a0,-878 # 1050 <malloc+0x2e8>
 3c6:	00001097          	auipc	ra,0x1
 3ca:	8e4080e7          	jalr	-1820(ra) # caa <printf>
  struct sigaction* act = malloc(sizeof(struct sigaction));
 3ce:	4541                	li	a0,16
 3d0:	00001097          	auipc	ra,0x1
 3d4:	998080e7          	jalr	-1640(ra) # d68 <malloc>
 3d8:	85aa                	mv	a1,a0
  act->sa_handler = (void *)SIG_IGN;
 3da:	4785                	li	a5,1
 3dc:	e11c                	sd	a5,0(a0)
  act->sigmask = 0;
 3de:	00052423          	sw	zero,8(a0)

  sigaction(5, act, 0);
 3e2:	4601                	li	a2,0
 3e4:	4515                	li	a0,5
 3e6:	00000097          	auipc	ra,0x0
 3ea:	5dc080e7          	jalr	1500(ra) # 9c2 <sigaction>

  int cpid = fork();
 3ee:	00000097          	auipc	ra,0x0
 3f2:	524080e7          	jalr	1316(ra) # 912 <fork>
  if(cpid == 0){
 3f6:	e505                	bnez	a0,41e <test_sig_ign+0x6e>
    while(1){
      if(flag == 5){
 3f8:	00001997          	auipc	s3,0x1
 3fc:	d8c98993          	addi	s3,s3,-628 # 1184 <flag>
 400:	4495                	li	s1,5
        printf( "If you see me, that's not good\n");
 402:	00001917          	auipc	s2,0x1
 406:	c6690913          	addi	s2,s2,-922 # 1068 <malloc+0x300>
      if(flag == 5){
 40a:	0009a783          	lw	a5,0(s3)
 40e:	00979063          	bne	a5,s1,40e <test_sig_ign+0x5e>
        printf( "If you see me, that's not good\n");
 412:	854a                	mv	a0,s2
 414:	00001097          	auipc	ra,0x1
 418:	896080e7          	jalr	-1898(ra) # caa <printf>
 41c:	b7fd                	j	40a <test_sig_ign+0x5a>
 41e:	84aa                	mv	s1,a0
      }
    }
  }
  else{
    sleep(10);
 420:	4529                	li	a0,10
 422:	00000097          	auipc	ra,0x0
 426:	588080e7          	jalr	1416(ra) # 9aa <sleep>
    printf( "sending signal\n");
 42a:	00001517          	auipc	a0,0x1
 42e:	c5e50513          	addi	a0,a0,-930 # 1088 <malloc+0x320>
 432:	00001097          	auipc	ra,0x1
 436:	878080e7          	jalr	-1928(ra) # caa <printf>
    kill(cpid, 5);
 43a:	4595                	li	a1,5
 43c:	8526                	mv	a0,s1
 43e:	00000097          	auipc	ra,0x0
 442:	50c080e7          	jalr	1292(ra) # 94a <kill>
    sleep(10);
 446:	4529                	li	a0,10
 448:	00000097          	auipc	ra,0x0
 44c:	562080e7          	jalr	1378(ra) # 9aa <sleep>
    kill(cpid, SIGKILL);
 450:	45a5                	li	a1,9
 452:	8526                	mv	a0,s1
 454:	00000097          	auipc	ra,0x0
 458:	4f6080e7          	jalr	1270(ra) # 94a <kill>
  }
  wait(0);
 45c:	4501                	li	a0,0
 45e:	00000097          	auipc	ra,0x0
 462:	4c4080e7          	jalr	1220(ra) # 922 <wait>
  printf("sig ign test OK\n");
 466:	00001517          	auipc	a0,0x1
 46a:	c3250513          	addi	a0,a0,-974 # 1098 <malloc+0x330>
 46e:	00001097          	auipc	ra,0x1
 472:	83c080e7          	jalr	-1988(ra) # caa <printf>
  flag = 0;
 476:	00001797          	auipc	a5,0x1
 47a:	d007a723          	sw	zero,-754(a5) # 1184 <flag>
}
 47e:	70a2                	ld	ra,40(sp)
 480:	7402                	ld	s0,32(sp)
 482:	64e2                	ld	s1,24(sp)
 484:	6942                	ld	s2,16(sp)
 486:	69a2                	ld	s3,8(sp)
 488:	6145                	addi	sp,sp,48
 48a:	8082                	ret

000000000000048c <test_sigmask>:


void test_sigmask(void){
 48c:	7179                	addi	sp,sp,-48
 48e:	f406                	sd	ra,40(sp)
 490:	f022                	sd	s0,32(sp)
 492:	ec26                	sd	s1,24(sp)
 494:	e84a                	sd	s2,16(sp)
 496:	e44e                	sd	s3,8(sp)
 498:	1800                	addi	s0,sp,48
  printf("sig mask test start\n");
 49a:	00001517          	auipc	a0,0x1
 49e:	c1650513          	addi	a0,a0,-1002 # 10b0 <malloc+0x348>
 4a2:	00001097          	auipc	ra,0x1
 4a6:	808080e7          	jalr	-2040(ra) # caa <printf>
  uint mask = 1 << 3;
  sigprocmask(mask);
 4aa:	4521                	li	a0,8
 4ac:	00000097          	auipc	ra,0x0
 4b0:	50e080e7          	jalr	1294(ra) # 9ba <sigprocmask>

  struct sigaction* act = malloc(sizeof(struct sigaction *));
 4b4:	4521                	li	a0,8
 4b6:	00001097          	auipc	ra,0x1
 4ba:	8b2080e7          	jalr	-1870(ra) # d68 <malloc>
 4be:	89aa                	mv	s3,a0
  act->sa_handler = handle;
 4c0:	00000797          	auipc	a5,0x0
 4c4:	b4078793          	addi	a5,a5,-1216 # 0 <handle>
 4c8:	e11c                	sd	a5,0(a0)
  act->sigmask = 0;
 4ca:	00052423          	sw	zero,8(a0)

  struct sigaction* act2 = malloc(sizeof(struct sigaction *));
 4ce:	4521                	li	a0,8
 4d0:	00001097          	auipc	ra,0x1
 4d4:	898080e7          	jalr	-1896(ra) # d68 <malloc>
 4d8:	892a                	mv	s2,a0
  act2->sa_handler = handle2;
 4da:	00000797          	auipc	a5,0x0
 4de:	b5078793          	addi	a5,a5,-1200 # 2a <handle2>
 4e2:	e11c                	sd	a5,0(a0)
  act2->sigmask = 0;
 4e4:	00052423          	sw	zero,8(a0)

  struct sigaction* act3 = malloc(sizeof(struct sigaction *));
 4e8:	4521                	li	a0,8
 4ea:	00001097          	auipc	ra,0x1
 4ee:	87e080e7          	jalr	-1922(ra) # d68 <malloc>
 4f2:	84aa                	mv	s1,a0
  act3->sa_handler = handle3;
 4f4:	00000797          	auipc	a5,0x0
 4f8:	b6078793          	addi	a5,a5,-1184 # 54 <handle3>
 4fc:	e11c                	sd	a5,0(a0)
  act3->sigmask = 0;
 4fe:	00052423          	sw	zero,8(a0)

  sigaction(5, act, 0);
 502:	4601                	li	a2,0
 504:	85ce                	mv	a1,s3
 506:	4515                	li	a0,5
 508:	00000097          	auipc	ra,0x0
 50c:	4ba080e7          	jalr	1210(ra) # 9c2 <sigaction>
  sigaction(2, act2, 0);
 510:	4601                	li	a2,0
 512:	85ca                	mv	a1,s2
 514:	4509                	li	a0,2
 516:	00000097          	auipc	ra,0x0
 51a:	4ac080e7          	jalr	1196(ra) # 9c2 <sigaction>
  sigaction(7, act3, 0);
 51e:	4601                	li	a2,0
 520:	85a6                	mv	a1,s1
 522:	451d                	li	a0,7
 524:	00000097          	auipc	ra,0x0
 528:	49e080e7          	jalr	1182(ra) # 9c2 <sigaction>

  int cpid = fork();
 52c:	00000097          	auipc	ra,0x0
 530:	3e6080e7          	jalr	998(ra) # 912 <fork>
  if(cpid == 0){
 534:	e921                	bnez	a0,584 <test_sigmask+0xf8>
    while(1){
      if(flag == 7){
 536:	00001717          	auipc	a4,0x1
 53a:	c4e72703          	lw	a4,-946(a4) # 1184 <flag>
 53e:	479d                	li	a5,7
 540:	00f71063          	bne	a4,a5,540 <test_sigmask+0xb4>
        printf("successfully recieved signal\n");
 544:	00001517          	auipc	a0,0x1
 548:	a4c50513          	addi	a0,a0,-1460 # f90 <malloc+0x228>
 54c:	00000097          	auipc	ra,0x0
 550:	75e080e7          	jalr	1886(ra) # caa <printf>
    kill(cpid, 7);
    sleep(10);
    printf("after handler flag = %d\n" , flag);
    //kill(cpid, 9);
  }
  wait(0);
 554:	4501                	li	a0,0
 556:	00000097          	auipc	ra,0x0
 55a:	3cc080e7          	jalr	972(ra) # 922 <wait>
  printf( "sig mask test OK\n");
 55e:	00001517          	auipc	a0,0x1
 562:	b8a50513          	addi	a0,a0,-1142 # 10e8 <malloc+0x380>
 566:	00000097          	auipc	ra,0x0
 56a:	744080e7          	jalr	1860(ra) # caa <printf>
  flag = 0;
 56e:	00001797          	auipc	a5,0x1
 572:	c007ab23          	sw	zero,-1002(a5) # 1184 <flag>
}
 576:	70a2                	ld	ra,40(sp)
 578:	7402                	ld	s0,32(sp)
 57a:	64e2                	ld	s1,24(sp)
 57c:	6942                	ld	s2,16(sp)
 57e:	69a2                	ld	s3,8(sp)
 580:	6145                	addi	sp,sp,48
 582:	8082                	ret
 584:	84aa                	mv	s1,a0
    sleep(10);
 586:	4529                	li	a0,10
 588:	00000097          	auipc	ra,0x0
 58c:	422080e7          	jalr	1058(ra) # 9aa <sleep>
    printf("sending signal\n");
 590:	00001517          	auipc	a0,0x1
 594:	af850513          	addi	a0,a0,-1288 # 1088 <malloc+0x320>
 598:	00000097          	auipc	ra,0x0
 59c:	712080e7          	jalr	1810(ra) # caa <printf>
    kill(cpid, 7);
 5a0:	459d                	li	a1,7
 5a2:	8526                	mv	a0,s1
 5a4:	00000097          	auipc	ra,0x0
 5a8:	3a6080e7          	jalr	934(ra) # 94a <kill>
    sleep(10);
 5ac:	4529                	li	a0,10
 5ae:	00000097          	auipc	ra,0x0
 5b2:	3fc080e7          	jalr	1020(ra) # 9aa <sleep>
    printf("after handler flag = %d\n" , flag);
 5b6:	00001597          	auipc	a1,0x1
 5ba:	bce5a583          	lw	a1,-1074(a1) # 1184 <flag>
 5be:	00001517          	auipc	a0,0x1
 5c2:	b0a50513          	addi	a0,a0,-1270 # 10c8 <malloc+0x360>
 5c6:	00000097          	auipc	ra,0x0
 5ca:	6e4080e7          	jalr	1764(ra) # caa <printf>
 5ce:	b759                	j	554 <test_sigmask+0xc8>

00000000000005d0 <signal_test>:

void signal_test(){
 5d0:	715d                	addi	sp,sp,-80
 5d2:	e486                	sd	ra,72(sp)
 5d4:	e0a2                	sd	s0,64(sp)
 5d6:	fc26                	sd	s1,56(sp)
 5d8:	0880                	addi	s0,sp,80
    int pid;
    int testsig;
    testsig=15;
    struct sigaction act = {test_handler, (uint)(1 << 29)};
 5da:	00000797          	auipc	a5,0x0
 5de:	abc78793          	addi	a5,a5,-1348 # 96 <test_handler>
 5e2:	fcf43423          	sd	a5,-56(s0)
 5e6:	200007b7          	lui	a5,0x20000
 5ea:	fcf42823          	sw	a5,-48(s0)
    struct sigaction old;

    sigprocmask(0);
 5ee:	4501                	li	a0,0
 5f0:	00000097          	auipc	ra,0x0
 5f4:	3ca080e7          	jalr	970(ra) # 9ba <sigprocmask>
    sigaction(testsig, &act, &old);
 5f8:	fb840613          	addi	a2,s0,-72
 5fc:	fc840593          	addi	a1,s0,-56
 600:	453d                	li	a0,15
 602:	00000097          	auipc	ra,0x0
 606:	3c0080e7          	jalr	960(ra) # 9c2 <sigaction>
    if((pid = fork()) == 0){
 60a:	00000097          	auipc	ra,0x0
 60e:	308080e7          	jalr	776(ra) # 912 <fork>
 612:	fca42e23          	sw	a0,-36(s0)
 616:	c90d                	beqz	a0,648 <signal_test+0x78>
        while(!wait_sig)
            sleep(1);
        exit(0);
    }
    kill(pid, testsig);
 618:	45bd                	li	a1,15
 61a:	00000097          	auipc	ra,0x0
 61e:	330080e7          	jalr	816(ra) # 94a <kill>
    wait(&pid);
 622:	fdc40513          	addi	a0,s0,-36
 626:	00000097          	auipc	ra,0x0
 62a:	2fc080e7          	jalr	764(ra) # 922 <wait>
    printf("Finished testing signals\n");
 62e:	00001517          	auipc	a0,0x1
 632:	ad250513          	addi	a0,a0,-1326 # 1100 <malloc+0x398>
 636:	00000097          	auipc	ra,0x0
 63a:	674080e7          	jalr	1652(ra) # caa <printf>
}
 63e:	60a6                	ld	ra,72(sp)
 640:	6406                	ld	s0,64(sp)
 642:	74e2                	ld	s1,56(sp)
 644:	6161                	addi	sp,sp,80
 646:	8082                	ret
        while(!wait_sig)
 648:	00001797          	auipc	a5,0x1
 64c:	b387a783          	lw	a5,-1224(a5) # 1180 <wait_sig>
 650:	ef81                	bnez	a5,668 <signal_test+0x98>
 652:	00001497          	auipc	s1,0x1
 656:	b2e48493          	addi	s1,s1,-1234 # 1180 <wait_sig>
            sleep(1);
 65a:	4505                	li	a0,1
 65c:	00000097          	auipc	ra,0x0
 660:	34e080e7          	jalr	846(ra) # 9aa <sleep>
        while(!wait_sig)
 664:	409c                	lw	a5,0(s1)
 666:	dbf5                	beqz	a5,65a <signal_test+0x8a>
        exit(0);
 668:	4501                	li	a0,0
 66a:	00000097          	auipc	ra,0x0
 66e:	2b0080e7          	jalr	688(ra) # 91a <exit>

0000000000000672 <main>:


//ASS2 TASK2
int
main(int argc, char **argv)
{
 672:	1141                	addi	sp,sp,-16
 674:	e406                	sd	ra,8(sp)
 676:	e022                	sd	s0,0(sp)
 678:	0800                	addi	s0,sp,16
  printf( "starting testing signals and friends\n");
 67a:	00001517          	auipc	a0,0x1
 67e:	aa650513          	addi	a0,a0,-1370 # 1120 <malloc+0x3b8>
 682:	00000097          	auipc	ra,0x0
 686:	628080e7          	jalr	1576(ra) # caa <printf>
//  test_sigkill_othersig();
//  test_custom_signal();
//  test_stop_cont();
//  test_sig_ign();
//  test_sigmask();
   signal_test();
 68a:	00000097          	auipc	ra,0x0
 68e:	f46080e7          	jalr	-186(ra) # 5d0 <signal_test>
  
  printf("ALL TESTS PASSED\n");
 692:	00001517          	auipc	a0,0x1
 696:	ab650513          	addi	a0,a0,-1354 # 1148 <malloc+0x3e0>
 69a:	00000097          	auipc	ra,0x0
 69e:	610080e7          	jalr	1552(ra) # caa <printf>
  exit(0);
 6a2:	4501                	li	a0,0
 6a4:	00000097          	auipc	ra,0x0
 6a8:	276080e7          	jalr	630(ra) # 91a <exit>

00000000000006ac <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 6ac:	1141                	addi	sp,sp,-16
 6ae:	e422                	sd	s0,8(sp)
 6b0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 6b2:	87aa                	mv	a5,a0
 6b4:	0585                	addi	a1,a1,1
 6b6:	0785                	addi	a5,a5,1
 6b8:	fff5c703          	lbu	a4,-1(a1)
 6bc:	fee78fa3          	sb	a4,-1(a5)
 6c0:	fb75                	bnez	a4,6b4 <strcpy+0x8>
    ;
  return os;
}
 6c2:	6422                	ld	s0,8(sp)
 6c4:	0141                	addi	sp,sp,16
 6c6:	8082                	ret

00000000000006c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 6c8:	1141                	addi	sp,sp,-16
 6ca:	e422                	sd	s0,8(sp)
 6cc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 6ce:	00054783          	lbu	a5,0(a0)
 6d2:	cb91                	beqz	a5,6e6 <strcmp+0x1e>
 6d4:	0005c703          	lbu	a4,0(a1)
 6d8:	00f71763          	bne	a4,a5,6e6 <strcmp+0x1e>
    p++, q++;
 6dc:	0505                	addi	a0,a0,1
 6de:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 6e0:	00054783          	lbu	a5,0(a0)
 6e4:	fbe5                	bnez	a5,6d4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 6e6:	0005c503          	lbu	a0,0(a1)
}
 6ea:	40a7853b          	subw	a0,a5,a0
 6ee:	6422                	ld	s0,8(sp)
 6f0:	0141                	addi	sp,sp,16
 6f2:	8082                	ret

00000000000006f4 <strlen>:

uint
strlen(const char *s)
{
 6f4:	1141                	addi	sp,sp,-16
 6f6:	e422                	sd	s0,8(sp)
 6f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 6fa:	00054783          	lbu	a5,0(a0)
 6fe:	cf91                	beqz	a5,71a <strlen+0x26>
 700:	0505                	addi	a0,a0,1
 702:	87aa                	mv	a5,a0
 704:	4685                	li	a3,1
 706:	9e89                	subw	a3,a3,a0
 708:	00f6853b          	addw	a0,a3,a5
 70c:	0785                	addi	a5,a5,1
 70e:	fff7c703          	lbu	a4,-1(a5)
 712:	fb7d                	bnez	a4,708 <strlen+0x14>
    ;
  return n;
}
 714:	6422                	ld	s0,8(sp)
 716:	0141                	addi	sp,sp,16
 718:	8082                	ret
  for(n = 0; s[n]; n++)
 71a:	4501                	li	a0,0
 71c:	bfe5                	j	714 <strlen+0x20>

000000000000071e <memset>:

void*
memset(void *dst, int c, uint n)
{
 71e:	1141                	addi	sp,sp,-16
 720:	e422                	sd	s0,8(sp)
 722:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 724:	ca19                	beqz	a2,73a <memset+0x1c>
 726:	87aa                	mv	a5,a0
 728:	1602                	slli	a2,a2,0x20
 72a:	9201                	srli	a2,a2,0x20
 72c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 730:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 734:	0785                	addi	a5,a5,1
 736:	fee79de3          	bne	a5,a4,730 <memset+0x12>
  }
  return dst;
}
 73a:	6422                	ld	s0,8(sp)
 73c:	0141                	addi	sp,sp,16
 73e:	8082                	ret

0000000000000740 <strchr>:

char*
strchr(const char *s, char c)
{
 740:	1141                	addi	sp,sp,-16
 742:	e422                	sd	s0,8(sp)
 744:	0800                	addi	s0,sp,16
  for(; *s; s++)
 746:	00054783          	lbu	a5,0(a0)
 74a:	cb99                	beqz	a5,760 <strchr+0x20>
    if(*s == c)
 74c:	00f58763          	beq	a1,a5,75a <strchr+0x1a>
  for(; *s; s++)
 750:	0505                	addi	a0,a0,1
 752:	00054783          	lbu	a5,0(a0)
 756:	fbfd                	bnez	a5,74c <strchr+0xc>
      return (char*)s;
  return 0;
 758:	4501                	li	a0,0
}
 75a:	6422                	ld	s0,8(sp)
 75c:	0141                	addi	sp,sp,16
 75e:	8082                	ret
  return 0;
 760:	4501                	li	a0,0
 762:	bfe5                	j	75a <strchr+0x1a>

0000000000000764 <gets>:

char*
gets(char *buf, int max)
{
 764:	711d                	addi	sp,sp,-96
 766:	ec86                	sd	ra,88(sp)
 768:	e8a2                	sd	s0,80(sp)
 76a:	e4a6                	sd	s1,72(sp)
 76c:	e0ca                	sd	s2,64(sp)
 76e:	fc4e                	sd	s3,56(sp)
 770:	f852                	sd	s4,48(sp)
 772:	f456                	sd	s5,40(sp)
 774:	f05a                	sd	s6,32(sp)
 776:	ec5e                	sd	s7,24(sp)
 778:	1080                	addi	s0,sp,96
 77a:	8baa                	mv	s7,a0
 77c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 77e:	892a                	mv	s2,a0
 780:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 782:	4aa9                	li	s5,10
 784:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 786:	89a6                	mv	s3,s1
 788:	2485                	addiw	s1,s1,1
 78a:	0344d863          	bge	s1,s4,7ba <gets+0x56>
    cc = read(0, &c, 1);
 78e:	4605                	li	a2,1
 790:	faf40593          	addi	a1,s0,-81
 794:	4501                	li	a0,0
 796:	00000097          	auipc	ra,0x0
 79a:	19c080e7          	jalr	412(ra) # 932 <read>
    if(cc < 1)
 79e:	00a05e63          	blez	a0,7ba <gets+0x56>
    buf[i++] = c;
 7a2:	faf44783          	lbu	a5,-81(s0)
 7a6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 7aa:	01578763          	beq	a5,s5,7b8 <gets+0x54>
 7ae:	0905                	addi	s2,s2,1
 7b0:	fd679be3          	bne	a5,s6,786 <gets+0x22>
  for(i=0; i+1 < max; ){
 7b4:	89a6                	mv	s3,s1
 7b6:	a011                	j	7ba <gets+0x56>
 7b8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 7ba:	99de                	add	s3,s3,s7
 7bc:	00098023          	sb	zero,0(s3)
  return buf;
}
 7c0:	855e                	mv	a0,s7
 7c2:	60e6                	ld	ra,88(sp)
 7c4:	6446                	ld	s0,80(sp)
 7c6:	64a6                	ld	s1,72(sp)
 7c8:	6906                	ld	s2,64(sp)
 7ca:	79e2                	ld	s3,56(sp)
 7cc:	7a42                	ld	s4,48(sp)
 7ce:	7aa2                	ld	s5,40(sp)
 7d0:	7b02                	ld	s6,32(sp)
 7d2:	6be2                	ld	s7,24(sp)
 7d4:	6125                	addi	sp,sp,96
 7d6:	8082                	ret

00000000000007d8 <stat>:

int
stat(const char *n, struct stat *st)
{
 7d8:	1101                	addi	sp,sp,-32
 7da:	ec06                	sd	ra,24(sp)
 7dc:	e822                	sd	s0,16(sp)
 7de:	e426                	sd	s1,8(sp)
 7e0:	e04a                	sd	s2,0(sp)
 7e2:	1000                	addi	s0,sp,32
 7e4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7e6:	4581                	li	a1,0
 7e8:	00000097          	auipc	ra,0x0
 7ec:	172080e7          	jalr	370(ra) # 95a <open>
  if(fd < 0)
 7f0:	02054563          	bltz	a0,81a <stat+0x42>
 7f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 7f6:	85ca                	mv	a1,s2
 7f8:	00000097          	auipc	ra,0x0
 7fc:	17a080e7          	jalr	378(ra) # 972 <fstat>
 800:	892a                	mv	s2,a0
  close(fd);
 802:	8526                	mv	a0,s1
 804:	00000097          	auipc	ra,0x0
 808:	13e080e7          	jalr	318(ra) # 942 <close>
  return r;
}
 80c:	854a                	mv	a0,s2
 80e:	60e2                	ld	ra,24(sp)
 810:	6442                	ld	s0,16(sp)
 812:	64a2                	ld	s1,8(sp)
 814:	6902                	ld	s2,0(sp)
 816:	6105                	addi	sp,sp,32
 818:	8082                	ret
    return -1;
 81a:	597d                	li	s2,-1
 81c:	bfc5                	j	80c <stat+0x34>

000000000000081e <atoi>:

int
atoi(const char *s)
{
 81e:	1141                	addi	sp,sp,-16
 820:	e422                	sd	s0,8(sp)
 822:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 824:	00054603          	lbu	a2,0(a0)
 828:	fd06079b          	addiw	a5,a2,-48
 82c:	0ff7f793          	andi	a5,a5,255
 830:	4725                	li	a4,9
 832:	02f76963          	bltu	a4,a5,864 <atoi+0x46>
 836:	86aa                	mv	a3,a0
  n = 0;
 838:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 83a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 83c:	0685                	addi	a3,a3,1
 83e:	0025179b          	slliw	a5,a0,0x2
 842:	9fa9                	addw	a5,a5,a0
 844:	0017979b          	slliw	a5,a5,0x1
 848:	9fb1                	addw	a5,a5,a2
 84a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 84e:	0006c603          	lbu	a2,0(a3)
 852:	fd06071b          	addiw	a4,a2,-48
 856:	0ff77713          	andi	a4,a4,255
 85a:	fee5f1e3          	bgeu	a1,a4,83c <atoi+0x1e>
  return n;
}
 85e:	6422                	ld	s0,8(sp)
 860:	0141                	addi	sp,sp,16
 862:	8082                	ret
  n = 0;
 864:	4501                	li	a0,0
 866:	bfe5                	j	85e <atoi+0x40>

0000000000000868 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 868:	1141                	addi	sp,sp,-16
 86a:	e422                	sd	s0,8(sp)
 86c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 86e:	02b57463          	bgeu	a0,a1,896 <memmove+0x2e>
    while(n-- > 0)
 872:	00c05f63          	blez	a2,890 <memmove+0x28>
 876:	1602                	slli	a2,a2,0x20
 878:	9201                	srli	a2,a2,0x20
 87a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 87e:	872a                	mv	a4,a0
      *dst++ = *src++;
 880:	0585                	addi	a1,a1,1
 882:	0705                	addi	a4,a4,1
 884:	fff5c683          	lbu	a3,-1(a1)
 888:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 88c:	fee79ae3          	bne	a5,a4,880 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 890:	6422                	ld	s0,8(sp)
 892:	0141                	addi	sp,sp,16
 894:	8082                	ret
    dst += n;
 896:	00c50733          	add	a4,a0,a2
    src += n;
 89a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 89c:	fec05ae3          	blez	a2,890 <memmove+0x28>
 8a0:	fff6079b          	addiw	a5,a2,-1
 8a4:	1782                	slli	a5,a5,0x20
 8a6:	9381                	srli	a5,a5,0x20
 8a8:	fff7c793          	not	a5,a5
 8ac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 8ae:	15fd                	addi	a1,a1,-1
 8b0:	177d                	addi	a4,a4,-1
 8b2:	0005c683          	lbu	a3,0(a1)
 8b6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 8ba:	fee79ae3          	bne	a5,a4,8ae <memmove+0x46>
 8be:	bfc9                	j	890 <memmove+0x28>

00000000000008c0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 8c0:	1141                	addi	sp,sp,-16
 8c2:	e422                	sd	s0,8(sp)
 8c4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 8c6:	ca05                	beqz	a2,8f6 <memcmp+0x36>
 8c8:	fff6069b          	addiw	a3,a2,-1
 8cc:	1682                	slli	a3,a3,0x20
 8ce:	9281                	srli	a3,a3,0x20
 8d0:	0685                	addi	a3,a3,1
 8d2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 8d4:	00054783          	lbu	a5,0(a0)
 8d8:	0005c703          	lbu	a4,0(a1)
 8dc:	00e79863          	bne	a5,a4,8ec <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 8e0:	0505                	addi	a0,a0,1
    p2++;
 8e2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 8e4:	fed518e3          	bne	a0,a3,8d4 <memcmp+0x14>
  }
  return 0;
 8e8:	4501                	li	a0,0
 8ea:	a019                	j	8f0 <memcmp+0x30>
      return *p1 - *p2;
 8ec:	40e7853b          	subw	a0,a5,a4
}
 8f0:	6422                	ld	s0,8(sp)
 8f2:	0141                	addi	sp,sp,16
 8f4:	8082                	ret
  return 0;
 8f6:	4501                	li	a0,0
 8f8:	bfe5                	j	8f0 <memcmp+0x30>

00000000000008fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 8fa:	1141                	addi	sp,sp,-16
 8fc:	e406                	sd	ra,8(sp)
 8fe:	e022                	sd	s0,0(sp)
 900:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 902:	00000097          	auipc	ra,0x0
 906:	f66080e7          	jalr	-154(ra) # 868 <memmove>
}
 90a:	60a2                	ld	ra,8(sp)
 90c:	6402                	ld	s0,0(sp)
 90e:	0141                	addi	sp,sp,16
 910:	8082                	ret

0000000000000912 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 912:	4885                	li	a7,1
 ecall
 914:	00000073          	ecall
 ret
 918:	8082                	ret

000000000000091a <exit>:
.global exit
exit:
 li a7, SYS_exit
 91a:	4889                	li	a7,2
 ecall
 91c:	00000073          	ecall
 ret
 920:	8082                	ret

0000000000000922 <wait>:
.global wait
wait:
 li a7, SYS_wait
 922:	488d                	li	a7,3
 ecall
 924:	00000073          	ecall
 ret
 928:	8082                	ret

000000000000092a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 92a:	4891                	li	a7,4
 ecall
 92c:	00000073          	ecall
 ret
 930:	8082                	ret

0000000000000932 <read>:
.global read
read:
 li a7, SYS_read
 932:	4895                	li	a7,5
 ecall
 934:	00000073          	ecall
 ret
 938:	8082                	ret

000000000000093a <write>:
.global write
write:
 li a7, SYS_write
 93a:	48c1                	li	a7,16
 ecall
 93c:	00000073          	ecall
 ret
 940:	8082                	ret

0000000000000942 <close>:
.global close
close:
 li a7, SYS_close
 942:	48d5                	li	a7,21
 ecall
 944:	00000073          	ecall
 ret
 948:	8082                	ret

000000000000094a <kill>:
.global kill
kill:
 li a7, SYS_kill
 94a:	4899                	li	a7,6
 ecall
 94c:	00000073          	ecall
 ret
 950:	8082                	ret

0000000000000952 <exec>:
.global exec
exec:
 li a7, SYS_exec
 952:	489d                	li	a7,7
 ecall
 954:	00000073          	ecall
 ret
 958:	8082                	ret

000000000000095a <open>:
.global open
open:
 li a7, SYS_open
 95a:	48bd                	li	a7,15
 ecall
 95c:	00000073          	ecall
 ret
 960:	8082                	ret

0000000000000962 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 962:	48c5                	li	a7,17
 ecall
 964:	00000073          	ecall
 ret
 968:	8082                	ret

000000000000096a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 96a:	48c9                	li	a7,18
 ecall
 96c:	00000073          	ecall
 ret
 970:	8082                	ret

0000000000000972 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 972:	48a1                	li	a7,8
 ecall
 974:	00000073          	ecall
 ret
 978:	8082                	ret

000000000000097a <link>:
.global link
link:
 li a7, SYS_link
 97a:	48cd                	li	a7,19
 ecall
 97c:	00000073          	ecall
 ret
 980:	8082                	ret

0000000000000982 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 982:	48d1                	li	a7,20
 ecall
 984:	00000073          	ecall
 ret
 988:	8082                	ret

000000000000098a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 98a:	48a5                	li	a7,9
 ecall
 98c:	00000073          	ecall
 ret
 990:	8082                	ret

0000000000000992 <dup>:
.global dup
dup:
 li a7, SYS_dup
 992:	48a9                	li	a7,10
 ecall
 994:	00000073          	ecall
 ret
 998:	8082                	ret

000000000000099a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 99a:	48ad                	li	a7,11
 ecall
 99c:	00000073          	ecall
 ret
 9a0:	8082                	ret

00000000000009a2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 9a2:	48b1                	li	a7,12
 ecall
 9a4:	00000073          	ecall
 ret
 9a8:	8082                	ret

00000000000009aa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 9aa:	48b5                	li	a7,13
 ecall
 9ac:	00000073          	ecall
 ret
 9b0:	8082                	ret

00000000000009b2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 9b2:	48b9                	li	a7,14
 ecall
 9b4:	00000073          	ecall
 ret
 9b8:	8082                	ret

00000000000009ba <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 9ba:	48d9                	li	a7,22
 ecall
 9bc:	00000073          	ecall
 ret
 9c0:	8082                	ret

00000000000009c2 <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 9c2:	48dd                	li	a7,23
 ecall
 9c4:	00000073          	ecall
 ret
 9c8:	8082                	ret

00000000000009ca <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 9ca:	48e1                	li	a7,24
 ecall
 9cc:	00000073          	ecall
 ret
 9d0:	8082                	ret

00000000000009d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 9d2:	1101                	addi	sp,sp,-32
 9d4:	ec06                	sd	ra,24(sp)
 9d6:	e822                	sd	s0,16(sp)
 9d8:	1000                	addi	s0,sp,32
 9da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 9de:	4605                	li	a2,1
 9e0:	fef40593          	addi	a1,s0,-17
 9e4:	00000097          	auipc	ra,0x0
 9e8:	f56080e7          	jalr	-170(ra) # 93a <write>
}
 9ec:	60e2                	ld	ra,24(sp)
 9ee:	6442                	ld	s0,16(sp)
 9f0:	6105                	addi	sp,sp,32
 9f2:	8082                	ret

00000000000009f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 9f4:	7139                	addi	sp,sp,-64
 9f6:	fc06                	sd	ra,56(sp)
 9f8:	f822                	sd	s0,48(sp)
 9fa:	f426                	sd	s1,40(sp)
 9fc:	f04a                	sd	s2,32(sp)
 9fe:	ec4e                	sd	s3,24(sp)
 a00:	0080                	addi	s0,sp,64
 a02:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a04:	c299                	beqz	a3,a0a <printint+0x16>
 a06:	0805c863          	bltz	a1,a96 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 a0a:	2581                	sext.w	a1,a1
  neg = 0;
 a0c:	4881                	li	a7,0
 a0e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 a12:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 a14:	2601                	sext.w	a2,a2
 a16:	00000517          	auipc	a0,0x0
 a1a:	75250513          	addi	a0,a0,1874 # 1168 <digits>
 a1e:	883a                	mv	a6,a4
 a20:	2705                	addiw	a4,a4,1
 a22:	02c5f7bb          	remuw	a5,a1,a2
 a26:	1782                	slli	a5,a5,0x20
 a28:	9381                	srli	a5,a5,0x20
 a2a:	97aa                	add	a5,a5,a0
 a2c:	0007c783          	lbu	a5,0(a5)
 a30:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 a34:	0005879b          	sext.w	a5,a1
 a38:	02c5d5bb          	divuw	a1,a1,a2
 a3c:	0685                	addi	a3,a3,1
 a3e:	fec7f0e3          	bgeu	a5,a2,a1e <printint+0x2a>
  if(neg)
 a42:	00088b63          	beqz	a7,a58 <printint+0x64>
    buf[i++] = '-';
 a46:	fd040793          	addi	a5,s0,-48
 a4a:	973e                	add	a4,a4,a5
 a4c:	02d00793          	li	a5,45
 a50:	fef70823          	sb	a5,-16(a4)
 a54:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 a58:	02e05863          	blez	a4,a88 <printint+0x94>
 a5c:	fc040793          	addi	a5,s0,-64
 a60:	00e78933          	add	s2,a5,a4
 a64:	fff78993          	addi	s3,a5,-1
 a68:	99ba                	add	s3,s3,a4
 a6a:	377d                	addiw	a4,a4,-1
 a6c:	1702                	slli	a4,a4,0x20
 a6e:	9301                	srli	a4,a4,0x20
 a70:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 a74:	fff94583          	lbu	a1,-1(s2)
 a78:	8526                	mv	a0,s1
 a7a:	00000097          	auipc	ra,0x0
 a7e:	f58080e7          	jalr	-168(ra) # 9d2 <putc>
  while(--i >= 0)
 a82:	197d                	addi	s2,s2,-1
 a84:	ff3918e3          	bne	s2,s3,a74 <printint+0x80>
}
 a88:	70e2                	ld	ra,56(sp)
 a8a:	7442                	ld	s0,48(sp)
 a8c:	74a2                	ld	s1,40(sp)
 a8e:	7902                	ld	s2,32(sp)
 a90:	69e2                	ld	s3,24(sp)
 a92:	6121                	addi	sp,sp,64
 a94:	8082                	ret
    x = -xx;
 a96:	40b005bb          	negw	a1,a1
    neg = 1;
 a9a:	4885                	li	a7,1
    x = -xx;
 a9c:	bf8d                	j	a0e <printint+0x1a>

0000000000000a9e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 a9e:	7119                	addi	sp,sp,-128
 aa0:	fc86                	sd	ra,120(sp)
 aa2:	f8a2                	sd	s0,112(sp)
 aa4:	f4a6                	sd	s1,104(sp)
 aa6:	f0ca                	sd	s2,96(sp)
 aa8:	ecce                	sd	s3,88(sp)
 aaa:	e8d2                	sd	s4,80(sp)
 aac:	e4d6                	sd	s5,72(sp)
 aae:	e0da                	sd	s6,64(sp)
 ab0:	fc5e                	sd	s7,56(sp)
 ab2:	f862                	sd	s8,48(sp)
 ab4:	f466                	sd	s9,40(sp)
 ab6:	f06a                	sd	s10,32(sp)
 ab8:	ec6e                	sd	s11,24(sp)
 aba:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 abc:	0005c903          	lbu	s2,0(a1)
 ac0:	18090f63          	beqz	s2,c5e <vprintf+0x1c0>
 ac4:	8aaa                	mv	s5,a0
 ac6:	8b32                	mv	s6,a2
 ac8:	00158493          	addi	s1,a1,1
  state = 0;
 acc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 ace:	02500a13          	li	s4,37
      if(c == 'd'){
 ad2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 ad6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 ada:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 ade:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 ae2:	00000b97          	auipc	s7,0x0
 ae6:	686b8b93          	addi	s7,s7,1670 # 1168 <digits>
 aea:	a839                	j	b08 <vprintf+0x6a>
        putc(fd, c);
 aec:	85ca                	mv	a1,s2
 aee:	8556                	mv	a0,s5
 af0:	00000097          	auipc	ra,0x0
 af4:	ee2080e7          	jalr	-286(ra) # 9d2 <putc>
 af8:	a019                	j	afe <vprintf+0x60>
    } else if(state == '%'){
 afa:	01498f63          	beq	s3,s4,b18 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 afe:	0485                	addi	s1,s1,1
 b00:	fff4c903          	lbu	s2,-1(s1)
 b04:	14090d63          	beqz	s2,c5e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 b08:	0009079b          	sext.w	a5,s2
    if(state == 0){
 b0c:	fe0997e3          	bnez	s3,afa <vprintf+0x5c>
      if(c == '%'){
 b10:	fd479ee3          	bne	a5,s4,aec <vprintf+0x4e>
        state = '%';
 b14:	89be                	mv	s3,a5
 b16:	b7e5                	j	afe <vprintf+0x60>
      if(c == 'd'){
 b18:	05878063          	beq	a5,s8,b58 <vprintf+0xba>
      } else if(c == 'l') {
 b1c:	05978c63          	beq	a5,s9,b74 <vprintf+0xd6>
      } else if(c == 'x') {
 b20:	07a78863          	beq	a5,s10,b90 <vprintf+0xf2>
      } else if(c == 'p') {
 b24:	09b78463          	beq	a5,s11,bac <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 b28:	07300713          	li	a4,115
 b2c:	0ce78663          	beq	a5,a4,bf8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b30:	06300713          	li	a4,99
 b34:	0ee78e63          	beq	a5,a4,c30 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 b38:	11478863          	beq	a5,s4,c48 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b3c:	85d2                	mv	a1,s4
 b3e:	8556                	mv	a0,s5
 b40:	00000097          	auipc	ra,0x0
 b44:	e92080e7          	jalr	-366(ra) # 9d2 <putc>
        putc(fd, c);
 b48:	85ca                	mv	a1,s2
 b4a:	8556                	mv	a0,s5
 b4c:	00000097          	auipc	ra,0x0
 b50:	e86080e7          	jalr	-378(ra) # 9d2 <putc>
      }
      state = 0;
 b54:	4981                	li	s3,0
 b56:	b765                	j	afe <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 b58:	008b0913          	addi	s2,s6,8
 b5c:	4685                	li	a3,1
 b5e:	4629                	li	a2,10
 b60:	000b2583          	lw	a1,0(s6)
 b64:	8556                	mv	a0,s5
 b66:	00000097          	auipc	ra,0x0
 b6a:	e8e080e7          	jalr	-370(ra) # 9f4 <printint>
 b6e:	8b4a                	mv	s6,s2
      state = 0;
 b70:	4981                	li	s3,0
 b72:	b771                	j	afe <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b74:	008b0913          	addi	s2,s6,8
 b78:	4681                	li	a3,0
 b7a:	4629                	li	a2,10
 b7c:	000b2583          	lw	a1,0(s6)
 b80:	8556                	mv	a0,s5
 b82:	00000097          	auipc	ra,0x0
 b86:	e72080e7          	jalr	-398(ra) # 9f4 <printint>
 b8a:	8b4a                	mv	s6,s2
      state = 0;
 b8c:	4981                	li	s3,0
 b8e:	bf85                	j	afe <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 b90:	008b0913          	addi	s2,s6,8
 b94:	4681                	li	a3,0
 b96:	4641                	li	a2,16
 b98:	000b2583          	lw	a1,0(s6)
 b9c:	8556                	mv	a0,s5
 b9e:	00000097          	auipc	ra,0x0
 ba2:	e56080e7          	jalr	-426(ra) # 9f4 <printint>
 ba6:	8b4a                	mv	s6,s2
      state = 0;
 ba8:	4981                	li	s3,0
 baa:	bf91                	j	afe <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 bac:	008b0793          	addi	a5,s6,8
 bb0:	f8f43423          	sd	a5,-120(s0)
 bb4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 bb8:	03000593          	li	a1,48
 bbc:	8556                	mv	a0,s5
 bbe:	00000097          	auipc	ra,0x0
 bc2:	e14080e7          	jalr	-492(ra) # 9d2 <putc>
  putc(fd, 'x');
 bc6:	85ea                	mv	a1,s10
 bc8:	8556                	mv	a0,s5
 bca:	00000097          	auipc	ra,0x0
 bce:	e08080e7          	jalr	-504(ra) # 9d2 <putc>
 bd2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 bd4:	03c9d793          	srli	a5,s3,0x3c
 bd8:	97de                	add	a5,a5,s7
 bda:	0007c583          	lbu	a1,0(a5)
 bde:	8556                	mv	a0,s5
 be0:	00000097          	auipc	ra,0x0
 be4:	df2080e7          	jalr	-526(ra) # 9d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 be8:	0992                	slli	s3,s3,0x4
 bea:	397d                	addiw	s2,s2,-1
 bec:	fe0914e3          	bnez	s2,bd4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 bf0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 bf4:	4981                	li	s3,0
 bf6:	b721                	j	afe <vprintf+0x60>
        s = va_arg(ap, char*);
 bf8:	008b0993          	addi	s3,s6,8
 bfc:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 c00:	02090163          	beqz	s2,c22 <vprintf+0x184>
        while(*s != 0){
 c04:	00094583          	lbu	a1,0(s2)
 c08:	c9a1                	beqz	a1,c58 <vprintf+0x1ba>
          putc(fd, *s);
 c0a:	8556                	mv	a0,s5
 c0c:	00000097          	auipc	ra,0x0
 c10:	dc6080e7          	jalr	-570(ra) # 9d2 <putc>
          s++;
 c14:	0905                	addi	s2,s2,1
        while(*s != 0){
 c16:	00094583          	lbu	a1,0(s2)
 c1a:	f9e5                	bnez	a1,c0a <vprintf+0x16c>
        s = va_arg(ap, char*);
 c1c:	8b4e                	mv	s6,s3
      state = 0;
 c1e:	4981                	li	s3,0
 c20:	bdf9                	j	afe <vprintf+0x60>
          s = "(null)";
 c22:	00000917          	auipc	s2,0x0
 c26:	53e90913          	addi	s2,s2,1342 # 1160 <malloc+0x3f8>
        while(*s != 0){
 c2a:	02800593          	li	a1,40
 c2e:	bff1                	j	c0a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 c30:	008b0913          	addi	s2,s6,8
 c34:	000b4583          	lbu	a1,0(s6)
 c38:	8556                	mv	a0,s5
 c3a:	00000097          	auipc	ra,0x0
 c3e:	d98080e7          	jalr	-616(ra) # 9d2 <putc>
 c42:	8b4a                	mv	s6,s2
      state = 0;
 c44:	4981                	li	s3,0
 c46:	bd65                	j	afe <vprintf+0x60>
        putc(fd, c);
 c48:	85d2                	mv	a1,s4
 c4a:	8556                	mv	a0,s5
 c4c:	00000097          	auipc	ra,0x0
 c50:	d86080e7          	jalr	-634(ra) # 9d2 <putc>
      state = 0;
 c54:	4981                	li	s3,0
 c56:	b565                	j	afe <vprintf+0x60>
        s = va_arg(ap, char*);
 c58:	8b4e                	mv	s6,s3
      state = 0;
 c5a:	4981                	li	s3,0
 c5c:	b54d                	j	afe <vprintf+0x60>
    }
  }
}
 c5e:	70e6                	ld	ra,120(sp)
 c60:	7446                	ld	s0,112(sp)
 c62:	74a6                	ld	s1,104(sp)
 c64:	7906                	ld	s2,96(sp)
 c66:	69e6                	ld	s3,88(sp)
 c68:	6a46                	ld	s4,80(sp)
 c6a:	6aa6                	ld	s5,72(sp)
 c6c:	6b06                	ld	s6,64(sp)
 c6e:	7be2                	ld	s7,56(sp)
 c70:	7c42                	ld	s8,48(sp)
 c72:	7ca2                	ld	s9,40(sp)
 c74:	7d02                	ld	s10,32(sp)
 c76:	6de2                	ld	s11,24(sp)
 c78:	6109                	addi	sp,sp,128
 c7a:	8082                	ret

0000000000000c7c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c7c:	715d                	addi	sp,sp,-80
 c7e:	ec06                	sd	ra,24(sp)
 c80:	e822                	sd	s0,16(sp)
 c82:	1000                	addi	s0,sp,32
 c84:	e010                	sd	a2,0(s0)
 c86:	e414                	sd	a3,8(s0)
 c88:	e818                	sd	a4,16(s0)
 c8a:	ec1c                	sd	a5,24(s0)
 c8c:	03043023          	sd	a6,32(s0)
 c90:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c94:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c98:	8622                	mv	a2,s0
 c9a:	00000097          	auipc	ra,0x0
 c9e:	e04080e7          	jalr	-508(ra) # a9e <vprintf>
}
 ca2:	60e2                	ld	ra,24(sp)
 ca4:	6442                	ld	s0,16(sp)
 ca6:	6161                	addi	sp,sp,80
 ca8:	8082                	ret

0000000000000caa <printf>:

void
printf(const char *fmt, ...)
{
 caa:	711d                	addi	sp,sp,-96
 cac:	ec06                	sd	ra,24(sp)
 cae:	e822                	sd	s0,16(sp)
 cb0:	1000                	addi	s0,sp,32
 cb2:	e40c                	sd	a1,8(s0)
 cb4:	e810                	sd	a2,16(s0)
 cb6:	ec14                	sd	a3,24(s0)
 cb8:	f018                	sd	a4,32(s0)
 cba:	f41c                	sd	a5,40(s0)
 cbc:	03043823          	sd	a6,48(s0)
 cc0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 cc4:	00840613          	addi	a2,s0,8
 cc8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ccc:	85aa                	mv	a1,a0
 cce:	4505                	li	a0,1
 cd0:	00000097          	auipc	ra,0x0
 cd4:	dce080e7          	jalr	-562(ra) # a9e <vprintf>
}
 cd8:	60e2                	ld	ra,24(sp)
 cda:	6442                	ld	s0,16(sp)
 cdc:	6125                	addi	sp,sp,96
 cde:	8082                	ret

0000000000000ce0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ce0:	1141                	addi	sp,sp,-16
 ce2:	e422                	sd	s0,8(sp)
 ce4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ce6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cea:	00000797          	auipc	a5,0x0
 cee:	49e7b783          	ld	a5,1182(a5) # 1188 <freep>
 cf2:	a805                	j	d22 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 cf4:	4618                	lw	a4,8(a2)
 cf6:	9db9                	addw	a1,a1,a4
 cf8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 cfc:	6398                	ld	a4,0(a5)
 cfe:	6318                	ld	a4,0(a4)
 d00:	fee53823          	sd	a4,-16(a0)
 d04:	a091                	j	d48 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 d06:	ff852703          	lw	a4,-8(a0)
 d0a:	9e39                	addw	a2,a2,a4
 d0c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 d0e:	ff053703          	ld	a4,-16(a0)
 d12:	e398                	sd	a4,0(a5)
 d14:	a099                	j	d5a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d16:	6398                	ld	a4,0(a5)
 d18:	00e7e463          	bltu	a5,a4,d20 <free+0x40>
 d1c:	00e6ea63          	bltu	a3,a4,d30 <free+0x50>
{
 d20:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d22:	fed7fae3          	bgeu	a5,a3,d16 <free+0x36>
 d26:	6398                	ld	a4,0(a5)
 d28:	00e6e463          	bltu	a3,a4,d30 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d2c:	fee7eae3          	bltu	a5,a4,d20 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 d30:	ff852583          	lw	a1,-8(a0)
 d34:	6390                	ld	a2,0(a5)
 d36:	02059813          	slli	a6,a1,0x20
 d3a:	01c85713          	srli	a4,a6,0x1c
 d3e:	9736                	add	a4,a4,a3
 d40:	fae60ae3          	beq	a2,a4,cf4 <free+0x14>
    bp->s.ptr = p->s.ptr;
 d44:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d48:	4790                	lw	a2,8(a5)
 d4a:	02061593          	slli	a1,a2,0x20
 d4e:	01c5d713          	srli	a4,a1,0x1c
 d52:	973e                	add	a4,a4,a5
 d54:	fae689e3          	beq	a3,a4,d06 <free+0x26>
  } else
    p->s.ptr = bp;
 d58:	e394                	sd	a3,0(a5)
  freep = p;
 d5a:	00000717          	auipc	a4,0x0
 d5e:	42f73723          	sd	a5,1070(a4) # 1188 <freep>
}
 d62:	6422                	ld	s0,8(sp)
 d64:	0141                	addi	sp,sp,16
 d66:	8082                	ret

0000000000000d68 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d68:	7139                	addi	sp,sp,-64
 d6a:	fc06                	sd	ra,56(sp)
 d6c:	f822                	sd	s0,48(sp)
 d6e:	f426                	sd	s1,40(sp)
 d70:	f04a                	sd	s2,32(sp)
 d72:	ec4e                	sd	s3,24(sp)
 d74:	e852                	sd	s4,16(sp)
 d76:	e456                	sd	s5,8(sp)
 d78:	e05a                	sd	s6,0(sp)
 d7a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d7c:	02051493          	slli	s1,a0,0x20
 d80:	9081                	srli	s1,s1,0x20
 d82:	04bd                	addi	s1,s1,15
 d84:	8091                	srli	s1,s1,0x4
 d86:	0014899b          	addiw	s3,s1,1
 d8a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 d8c:	00000517          	auipc	a0,0x0
 d90:	3fc53503          	ld	a0,1020(a0) # 1188 <freep>
 d94:	c515                	beqz	a0,dc0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d96:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d98:	4798                	lw	a4,8(a5)
 d9a:	02977f63          	bgeu	a4,s1,dd8 <malloc+0x70>
 d9e:	8a4e                	mv	s4,s3
 da0:	0009871b          	sext.w	a4,s3
 da4:	6685                	lui	a3,0x1
 da6:	00d77363          	bgeu	a4,a3,dac <malloc+0x44>
 daa:	6a05                	lui	s4,0x1
 dac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 db0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 db4:	00000917          	auipc	s2,0x0
 db8:	3d490913          	addi	s2,s2,980 # 1188 <freep>
  if(p == (char*)-1)
 dbc:	5afd                	li	s5,-1
 dbe:	a895                	j	e32 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 dc0:	00000797          	auipc	a5,0x0
 dc4:	3d078793          	addi	a5,a5,976 # 1190 <base>
 dc8:	00000717          	auipc	a4,0x0
 dcc:	3cf73023          	sd	a5,960(a4) # 1188 <freep>
 dd0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 dd2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 dd6:	b7e1                	j	d9e <malloc+0x36>
      if(p->s.size == nunits)
 dd8:	02e48c63          	beq	s1,a4,e10 <malloc+0xa8>
        p->s.size -= nunits;
 ddc:	4137073b          	subw	a4,a4,s3
 de0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 de2:	02071693          	slli	a3,a4,0x20
 de6:	01c6d713          	srli	a4,a3,0x1c
 dea:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 dec:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 df0:	00000717          	auipc	a4,0x0
 df4:	38a73c23          	sd	a0,920(a4) # 1188 <freep>
      return (void*)(p + 1);
 df8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 dfc:	70e2                	ld	ra,56(sp)
 dfe:	7442                	ld	s0,48(sp)
 e00:	74a2                	ld	s1,40(sp)
 e02:	7902                	ld	s2,32(sp)
 e04:	69e2                	ld	s3,24(sp)
 e06:	6a42                	ld	s4,16(sp)
 e08:	6aa2                	ld	s5,8(sp)
 e0a:	6b02                	ld	s6,0(sp)
 e0c:	6121                	addi	sp,sp,64
 e0e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 e10:	6398                	ld	a4,0(a5)
 e12:	e118                	sd	a4,0(a0)
 e14:	bff1                	j	df0 <malloc+0x88>
  hp->s.size = nu;
 e16:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 e1a:	0541                	addi	a0,a0,16
 e1c:	00000097          	auipc	ra,0x0
 e20:	ec4080e7          	jalr	-316(ra) # ce0 <free>
  return freep;
 e24:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 e28:	d971                	beqz	a0,dfc <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e2a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 e2c:	4798                	lw	a4,8(a5)
 e2e:	fa9775e3          	bgeu	a4,s1,dd8 <malloc+0x70>
    if(p == freep)
 e32:	00093703          	ld	a4,0(s2)
 e36:	853e                	mv	a0,a5
 e38:	fef719e3          	bne	a4,a5,e2a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 e3c:	8552                	mv	a0,s4
 e3e:	00000097          	auipc	ra,0x0
 e42:	b64080e7          	jalr	-1180(ra) # 9a2 <sbrk>
  if(p == (char*)-1)
 e46:	fd5518e3          	bne	a0,s5,e16 <malloc+0xae>
        return 0;
 e4a:	4501                	li	a0,0
 e4c:	bf45                	j	dfc <malloc+0x94>
