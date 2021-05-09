
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
       a:	00002797          	auipc	a5,0x2
       e:	90a7a123          	sw	a0,-1790(a5) # 190c <flag>
    printf("handle -> signum: %d\n", signum);
      12:	00001517          	auipc	a0,0x1
      16:	36e50513          	addi	a0,a0,878 # 1380 <malloc+0xec>
      1a:	00001097          	auipc	ra,0x1
      1e:	1bc080e7          	jalr	444(ra) # 11d6 <printf>
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
      34:	00002797          	auipc	a5,0x2
      38:	8ca7ac23          	sw	a0,-1832(a5) # 190c <flag>
    printf("handle2 -> signum: %d\n", signum);
      3c:	00001517          	auipc	a0,0x1
      40:	35c50513          	addi	a0,a0,860 # 1398 <malloc+0x104>
      44:	00001097          	auipc	ra,0x1
      48:	192080e7          	jalr	402(ra) # 11d6 <printf>
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
      60:	00002797          	auipc	a5,0x2
      64:	8aa7a623          	sw	a0,-1876(a5) # 190c <flag>
    printf("in handle3, flag = %d\n", flag);
      68:	85aa                	mv	a1,a0
      6a:	00001517          	auipc	a0,0x1
      6e:	34650513          	addi	a0,a0,838 # 13b0 <malloc+0x11c>
      72:	00001097          	auipc	ra,0x1
      76:	164080e7          	jalr	356(ra) # 11d6 <printf>
    printf("handle3 -> signum: %d\n", signum);
      7a:	85a6                	mv	a1,s1
      7c:	00001517          	auipc	a0,0x1
      80:	34c50513          	addi	a0,a0,844 # 13c8 <malloc+0x134>
      84:	00001097          	auipc	ra,0x1
      88:	152080e7          	jalr	338(ra) # 11d6 <printf>
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
      a0:	00002717          	auipc	a4,0x2
      a4:	86f72423          	sw	a5,-1944(a4) # 1908 <wait_sig>
    printf("Received sigtest\n");
      a8:	00001517          	auipc	a0,0x1
      ac:	33850513          	addi	a0,a0,824 # 13e0 <malloc+0x14c>
      b0:	00001097          	auipc	ra,0x1
      b4:	126080e7          	jalr	294(ra) # 11d6 <printf>
}
      b8:	60a2                	ld	ra,8(sp)
      ba:	6402                	ld	s0,0(sp)
      bc:	0141                	addi	sp,sp,16
      be:	8082                	ret

00000000000000c0 <thread_kthread_id>:
    wait(&pid);

    printf("Finished bsem test, make sure that the order of the prints is alright. Meaning (1...2...3...4)\n");
}

void thread_kthread_id(){
      c0:	1141                	addi	sp,sp,-16
      c2:	e406                	sd	ra,8(sp)
      c4:	e022                	sd	s0,0(sp)
      c6:	0800                	addi	s0,sp,16
  fprintf(2, "\nstarting kthread_id test\n");
      c8:	00001597          	auipc	a1,0x1
      cc:	33058593          	addi	a1,a1,816 # 13f8 <malloc+0x164>
      d0:	4509                	li	a0,2
      d2:	00001097          	auipc	ra,0x1
      d6:	0d6080e7          	jalr	214(ra) # 11a8 <fprintf>
  int x = kthread_id();
      da:	00001097          	auipc	ra,0x1
      de:	e0a080e7          	jalr	-502(ra) # ee4 <kthread_id>
      e2:	862a                	mv	a2,a0
  fprintf(2, "thread_id is: %d\n", x);
      e4:	00001597          	auipc	a1,0x1
      e8:	33458593          	addi	a1,a1,820 # 1418 <malloc+0x184>
      ec:	4509                	li	a0,2
      ee:	00001097          	auipc	ra,0x1
      f2:	0ba080e7          	jalr	186(ra) # 11a8 <fprintf>
  fprintf(2, "finished kthread_id test\n");
      f6:	00001597          	auipc	a1,0x1
      fa:	33a58593          	addi	a1,a1,826 # 1430 <malloc+0x19c>
      fe:	4509                	li	a0,2
     100:	00001097          	auipc	ra,0x1
     104:	0a8080e7          	jalr	168(ra) # 11a8 <fprintf>
}
     108:	60a2                	ld	ra,8(sp)
     10a:	6402                	ld	s0,0(sp)
     10c:	0141                	addi	sp,sp,16
     10e:	8082                	ret

0000000000000110 <sigkillTest>:
void sigkillTest(void){
     110:	1101                	addi	sp,sp,-32
     112:	ec06                	sd	ra,24(sp)
     114:	e822                	sd	s0,16(sp)
     116:	e426                	sd	s1,8(sp)
     118:	1000                	addi	s0,sp,32
  int cpid = fork();
     11a:	00001097          	auipc	ra,0x1
     11e:	ce2080e7          	jalr	-798(ra) # dfc <fork>
  if(cpid == 0){
     122:	e111                	bnez	a0,126 <sigkillTest+0x16>
    while(1);
     124:	a001                	j	124 <sigkillTest+0x14>
     126:	84aa                	mv	s1,a0
    sleep(50);
     128:	03200513          	li	a0,50
     12c:	00001097          	auipc	ra,0x1
     130:	d68080e7          	jalr	-664(ra) # e94 <sleep>
    kill(cpid, SIGKILL);
     134:	45a5                	li	a1,9
     136:	8526                	mv	a0,s1
     138:	00001097          	auipc	ra,0x1
     13c:	cfc080e7          	jalr	-772(ra) # e34 <kill>
  printf("sigkillTest OK\n");
     140:	00001517          	auipc	a0,0x1
     144:	31050513          	addi	a0,a0,784 # 1450 <malloc+0x1bc>
     148:	00001097          	auipc	ra,0x1
     14c:	08e080e7          	jalr	142(ra) # 11d6 <printf>
}
     150:	60e2                	ld	ra,24(sp)
     152:	6442                	ld	s0,16(sp)
     154:	64a2                	ld	s1,8(sp)
     156:	6105                	addi	sp,sp,32
     158:	8082                	ret

000000000000015a <killwdiffSignum>:
void killwdiffSignum(void){
     15a:	1101                	addi	sp,sp,-32
     15c:	ec06                	sd	ra,24(sp)
     15e:	e822                	sd	s0,16(sp)
     160:	e426                	sd	s1,8(sp)
     162:	1000                	addi	s0,sp,32
  int cpid = fork();
     164:	00001097          	auipc	ra,0x1
     168:	c98080e7          	jalr	-872(ra) # dfc <fork>
  if(cpid == 0){
     16c:	e111                	bnez	a0,170 <killwdiffSignum+0x16>
    while(1);
     16e:	a001                	j	16e <killwdiffSignum+0x14>
     170:	84aa                	mv	s1,a0
    sleep(50);
     172:	03200513          	li	a0,50
     176:	00001097          	auipc	ra,0x1
     17a:	d1e080e7          	jalr	-738(ra) # e94 <sleep>
    kill(cpid, 15);
     17e:	45bd                	li	a1,15
     180:	8526                	mv	a0,s1
     182:	00001097          	auipc	ra,0x1
     186:	cb2080e7          	jalr	-846(ra) # e34 <kill>
  printf("kill with another signum test OK\n");
     18a:	00001517          	auipc	a0,0x1
     18e:	2d650513          	addi	a0,a0,726 # 1460 <malloc+0x1cc>
     192:	00001097          	auipc	ra,0x1
     196:	044080e7          	jalr	68(ra) # 11d6 <printf>
}
     19a:	60e2                	ld	ra,24(sp)
     19c:	6442                	ld	s0,16(sp)
     19e:	64a2                	ld	s1,8(sp)
     1a0:	6105                	addi	sp,sp,32
     1a2:	8082                	ret

00000000000001a4 <testSigactionHandler1>:
void testSigactionHandler1(void){
     1a4:	7179                	addi	sp,sp,-48
     1a6:	f406                	sd	ra,40(sp)
     1a8:	f022                	sd	s0,32(sp)
     1aa:	ec26                	sd	s1,24(sp)
     1ac:	e84a                	sd	s2,16(sp)
     1ae:	e44e                	sd	s3,8(sp)
     1b0:	e052                	sd	s4,0(sp)
     1b2:	1800                	addi	s0,sp,48
  struct sigaction* act = malloc(sizeof(struct sigaction *));
     1b4:	4521                	li	a0,8
     1b6:	00001097          	auipc	ra,0x1
     1ba:	0de080e7          	jalr	222(ra) # 1294 <malloc>
     1be:	89aa                	mv	s3,a0
  act->sa_handler = handle;
     1c0:	00000797          	auipc	a5,0x0
     1c4:	e4078793          	addi	a5,a5,-448 # 0 <handle>
     1c8:	e11c                	sd	a5,0(a0)
  act->sigmask = 0;
     1ca:	00052423          	sw	zero,8(a0)
  struct sigaction* act2 = malloc(sizeof(struct sigaction *));
     1ce:	4521                	li	a0,8
     1d0:	00001097          	auipc	ra,0x1
     1d4:	0c4080e7          	jalr	196(ra) # 1294 <malloc>
     1d8:	892a                	mv	s2,a0
  act2->sa_handler = handle2;
     1da:	00000797          	auipc	a5,0x0
     1de:	e5078793          	addi	a5,a5,-432 # 2a <handle2>
     1e2:	e11c                	sd	a5,0(a0)
  act2->sigmask = 0;
     1e4:	00052423          	sw	zero,8(a0)
  struct sigaction* act3 = malloc(sizeof(struct sigaction *));
     1e8:	4521                	li	a0,8
     1ea:	00001097          	auipc	ra,0x1
     1ee:	0aa080e7          	jalr	170(ra) # 1294 <malloc>
     1f2:	84aa                	mv	s1,a0
  act3->sa_handler = handle3;
     1f4:	00000a17          	auipc	s4,0x0
     1f8:	e60a0a13          	addi	s4,s4,-416 # 54 <handle3>
     1fc:	01453023          	sd	s4,0(a0)
  act3->sigmask = 0;
     200:	00052423          	sw	zero,8(a0)
  sigaction(5, act, 0);
     204:	4601                	li	a2,0
     206:	85ce                	mv	a1,s3
     208:	4515                	li	a0,5
     20a:	00001097          	auipc	ra,0x1
     20e:	ca2080e7          	jalr	-862(ra) # eac <sigaction>
  sigaction(2, act2, 0);
     212:	4601                	li	a2,0
     214:	85ca                	mv	a1,s2
     216:	4509                	li	a0,2
     218:	00001097          	auipc	ra,0x1
     21c:	c94080e7          	jalr	-876(ra) # eac <sigaction>
  int ret3 = sigaction(7, act3, 0);
     220:	4601                	li	a2,0
     222:	85a6                	mv	a1,s1
     224:	451d                	li	a0,7
     226:	00001097          	auipc	ra,0x1
     22a:	c86080e7          	jalr	-890(ra) # eac <sigaction>
     22e:	85aa                	mv	a1,a0
  printf("ret3 = %d\n", ret3);
     230:	00001517          	auipc	a0,0x1
     234:	25850513          	addi	a0,a0,600 # 1488 <malloc+0x1f4>
     238:	00001097          	auipc	ra,0x1
     23c:	f9e080e7          	jalr	-98(ra) # 11d6 <printf>
   printf("The address of the function handle3 is =%p\n",handle3);
     240:	85d2                	mv	a1,s4
     242:	00001517          	auipc	a0,0x1
     246:	25650513          	addi	a0,a0,598 # 1498 <malloc+0x204>
     24a:	00001097          	auipc	ra,0x1
     24e:	f8c080e7          	jalr	-116(ra) # 11d6 <printf>
  int cpid = fork();
     252:	00001097          	auipc	ra,0x1
     256:	baa080e7          	jalr	-1110(ra) # dfc <fork>
  if(cpid == 0){
     25a:	e505                	bnez	a0,282 <testSigactionHandler1+0xde>
      if(flag == 7){
     25c:	00001997          	auipc	s3,0x1
     260:	6b098993          	addi	s3,s3,1712 # 190c <flag>
     264:	449d                	li	s1,7
        printf("successfully recieved signal\n");
     266:	00001917          	auipc	s2,0x1
     26a:	26290913          	addi	s2,s2,610 # 14c8 <malloc+0x234>
      if(flag == 7){
     26e:	0009a783          	lw	a5,0(s3)
     272:	00979063          	bne	a5,s1,272 <testSigactionHandler1+0xce>
        printf("successfully recieved signal\n");
     276:	854a                	mv	a0,s2
     278:	00001097          	auipc	ra,0x1
     27c:	f5e080e7          	jalr	-162(ra) # 11d6 <printf>
     280:	b7fd                	j	26e <testSigactionHandler1+0xca>
     282:	84aa                	mv	s1,a0
    sleep(100);
     284:	06400513          	li	a0,100
     288:	00001097          	auipc	ra,0x1
     28c:	c0c080e7          	jalr	-1012(ra) # e94 <sleep>
    printf( "sending signal %d\n" , 7);
     290:	459d                	li	a1,7
     292:	00001517          	auipc	a0,0x1
     296:	25650513          	addi	a0,a0,598 # 14e8 <malloc+0x254>
     29a:	00001097          	auipc	ra,0x1
     29e:	f3c080e7          	jalr	-196(ra) # 11d6 <printf>
    kill(cpid, 7);
     2a2:	459d                	li	a1,7
     2a4:	8526                	mv	a0,s1
     2a6:	00001097          	auipc	ra,0x1
     2aa:	b8e080e7          	jalr	-1138(ra) # e34 <kill>
    sleep(100);
     2ae:	06400513          	li	a0,100
     2b2:	00001097          	auipc	ra,0x1
     2b6:	be2080e7          	jalr	-1054(ra) # e94 <sleep>
    kill(cpid, SIGKILL);
     2ba:	45a5                	li	a1,9
     2bc:	8526                	mv	a0,s1
     2be:	00001097          	auipc	ra,0x1
     2c2:	b76080e7          	jalr	-1162(ra) # e34 <kill>
  wait(0);
     2c6:	4501                	li	a0,0
     2c8:	00001097          	auipc	ra,0x1
     2cc:	b44080e7          	jalr	-1212(ra) # e0c <wait>
  printf("custom sig test OK\n");
     2d0:	00001517          	auipc	a0,0x1
     2d4:	23050513          	addi	a0,a0,560 # 1500 <malloc+0x26c>
     2d8:	00001097          	auipc	ra,0x1
     2dc:	efe080e7          	jalr	-258(ra) # 11d6 <printf>
  flag = 0;
     2e0:	00001797          	auipc	a5,0x1
     2e4:	6207a623          	sw	zero,1580(a5) # 190c <flag>
}
     2e8:	70a2                	ld	ra,40(sp)
     2ea:	7402                	ld	s0,32(sp)
     2ec:	64e2                	ld	s1,24(sp)
     2ee:	6942                	ld	s2,16(sp)
     2f0:	69a2                	ld	s3,8(sp)
     2f2:	6a02                	ld	s4,0(sp)
     2f4:	6145                	addi	sp,sp,48
     2f6:	8082                	ret

00000000000002f8 <testContStopCont>:
void testContStopCont(void){
     2f8:	1101                	addi	sp,sp,-32
     2fa:	ec06                	sd	ra,24(sp)
     2fc:	e822                	sd	s0,16(sp)
     2fe:	e426                	sd	s1,8(sp)
     300:	1000                	addi	s0,sp,32
  int cpid = fork();
     302:	00001097          	auipc	ra,0x1
     306:	afa080e7          	jalr	-1286(ra) # dfc <fork>
  if(cpid == 0){
     30a:	e519                	bnez	a0,318 <testContStopCont+0x20>
      sleep(10);
     30c:	4529                	li	a0,10
     30e:	00001097          	auipc	ra,0x1
     312:	b86080e7          	jalr	-1146(ra) # e94 <sleep>
    while(1){
     316:	bfdd                	j	30c <testContStopCont+0x14>
     318:	84aa                	mv	s1,a0
    sleep(20);
     31a:	4551                	li	a0,20
     31c:	00001097          	auipc	ra,0x1
     320:	b78080e7          	jalr	-1160(ra) # e94 <sleep>
    printf("sending cont\n");
     324:	00001517          	auipc	a0,0x1
     328:	1f450513          	addi	a0,a0,500 # 1518 <malloc+0x284>
     32c:	00001097          	auipc	ra,0x1
     330:	eaa080e7          	jalr	-342(ra) # 11d6 <printf>
    kill(cpid, SIGCONT);
     334:	45cd                	li	a1,19
     336:	8526                	mv	a0,s1
     338:	00001097          	auipc	ra,0x1
     33c:	afc080e7          	jalr	-1284(ra) # e34 <kill>
    sleep(20);
     340:	4551                	li	a0,20
     342:	00001097          	auipc	ra,0x1
     346:	b52080e7          	jalr	-1198(ra) # e94 <sleep>
    printf("sending stop\n");
     34a:	00001517          	auipc	a0,0x1
     34e:	1de50513          	addi	a0,a0,478 # 1528 <malloc+0x294>
     352:	00001097          	auipc	ra,0x1
     356:	e84080e7          	jalr	-380(ra) # 11d6 <printf>
    kill(cpid, SIGSTOP);
     35a:	45c5                	li	a1,17
     35c:	8526                	mv	a0,s1
     35e:	00001097          	auipc	ra,0x1
     362:	ad6080e7          	jalr	-1322(ra) # e34 <kill>
    sleep(20);
     366:	4551                	li	a0,20
     368:	00001097          	auipc	ra,0x1
     36c:	b2c080e7          	jalr	-1236(ra) # e94 <sleep>
    printf("sending cont\n");
     370:	00001517          	auipc	a0,0x1
     374:	1a850513          	addi	a0,a0,424 # 1518 <malloc+0x284>
     378:	00001097          	auipc	ra,0x1
     37c:	e5e080e7          	jalr	-418(ra) # 11d6 <printf>
    kill(cpid, SIGCONT);
     380:	45cd                	li	a1,19
     382:	8526                	mv	a0,s1
     384:	00001097          	auipc	ra,0x1
     388:	ab0080e7          	jalr	-1360(ra) # e34 <kill>
    sleep(20);
     38c:	4551                	li	a0,20
     38e:	00001097          	auipc	ra,0x1
     392:	b06080e7          	jalr	-1274(ra) # e94 <sleep>
    printf("killing\n");
     396:	00001517          	auipc	a0,0x1
     39a:	1a250513          	addi	a0,a0,418 # 1538 <malloc+0x2a4>
     39e:	00001097          	auipc	ra,0x1
     3a2:	e38080e7          	jalr	-456(ra) # 11d6 <printf>
    kill(cpid, SIGKILL);
     3a6:	45a5                	li	a1,9
     3a8:	8526                	mv	a0,s1
     3aa:	00001097          	auipc	ra,0x1
     3ae:	a8a080e7          	jalr	-1398(ra) # e34 <kill>
  wait(0);
     3b2:	4501                	li	a0,0
     3b4:	00001097          	auipc	ra,0x1
     3b8:	a58080e7          	jalr	-1448(ra) # e0c <wait>
  printf("testContStopCont OK\n");
     3bc:	00001517          	auipc	a0,0x1
     3c0:	18c50513          	addi	a0,a0,396 # 1548 <malloc+0x2b4>
     3c4:	00001097          	auipc	ra,0x1
     3c8:	e12080e7          	jalr	-494(ra) # 11d6 <printf>
}
     3cc:	60e2                	ld	ra,24(sp)
     3ce:	6442                	ld	s0,16(sp)
     3d0:	64a2                	ld	s1,8(sp)
     3d2:	6105                	addi	sp,sp,32
     3d4:	8082                	ret

00000000000003d6 <testStopCont>:
void testStopCont(void){
     3d6:	1101                	addi	sp,sp,-32
     3d8:	ec06                	sd	ra,24(sp)
     3da:	e822                	sd	s0,16(sp)
     3dc:	e426                	sd	s1,8(sp)
     3de:	1000                	addi	s0,sp,32
  int cpid = fork();
     3e0:	00001097          	auipc	ra,0x1
     3e4:	a1c080e7          	jalr	-1508(ra) # dfc <fork>
  if(cpid == 0){
     3e8:	e519                	bnez	a0,3f6 <testStopCont+0x20>
      sleep(10);
     3ea:	4529                	li	a0,10
     3ec:	00001097          	auipc	ra,0x1
     3f0:	aa8080e7          	jalr	-1368(ra) # e94 <sleep>
    while(1){
     3f4:	bfdd                	j	3ea <testStopCont+0x14>
     3f6:	84aa                	mv	s1,a0
    sleep(20);
     3f8:	4551                	li	a0,20
     3fa:	00001097          	auipc	ra,0x1
     3fe:	a9a080e7          	jalr	-1382(ra) # e94 <sleep>
    printf("send stop\n");
     402:	00001517          	auipc	a0,0x1
     406:	15e50513          	addi	a0,a0,350 # 1560 <malloc+0x2cc>
     40a:	00001097          	auipc	ra,0x1
     40e:	dcc080e7          	jalr	-564(ra) # 11d6 <printf>
    kill(cpid, SIGSTOP);
     412:	45c5                	li	a1,17
     414:	8526                	mv	a0,s1
     416:	00001097          	auipc	ra,0x1
     41a:	a1e080e7          	jalr	-1506(ra) # e34 <kill>
    sleep(20);
     41e:	4551                	li	a0,20
     420:	00001097          	auipc	ra,0x1
     424:	a74080e7          	jalr	-1420(ra) # e94 <sleep>
    printf("send cont\n");
     428:	00001517          	auipc	a0,0x1
     42c:	14850513          	addi	a0,a0,328 # 1570 <malloc+0x2dc>
     430:	00001097          	auipc	ra,0x1
     434:	da6080e7          	jalr	-602(ra) # 11d6 <printf>
    kill(cpid, SIGCONT);
     438:	45cd                	li	a1,19
     43a:	8526                	mv	a0,s1
     43c:	00001097          	auipc	ra,0x1
     440:	9f8080e7          	jalr	-1544(ra) # e34 <kill>
    sleep(20);
     444:	4551                	li	a0,20
     446:	00001097          	auipc	ra,0x1
     44a:	a4e080e7          	jalr	-1458(ra) # e94 <sleep>
    printf("now to the killing\n");
     44e:	00001517          	auipc	a0,0x1
     452:	13250513          	addi	a0,a0,306 # 1580 <malloc+0x2ec>
     456:	00001097          	auipc	ra,0x1
     45a:	d80080e7          	jalr	-640(ra) # 11d6 <printf>
    kill(cpid, SIGKILL);
     45e:	45a5                	li	a1,9
     460:	8526                	mv	a0,s1
     462:	00001097          	auipc	ra,0x1
     466:	9d2080e7          	jalr	-1582(ra) # e34 <kill>
  wait(0);
     46a:	4501                	li	a0,0
     46c:	00001097          	auipc	ra,0x1
     470:	9a0080e7          	jalr	-1632(ra) # e0c <wait>
  printf("testStopCont OK\n");
     474:	00001517          	auipc	a0,0x1
     478:	12450513          	addi	a0,a0,292 # 1598 <malloc+0x304>
     47c:	00001097          	auipc	ra,0x1
     480:	d5a080e7          	jalr	-678(ra) # 11d6 <printf>
}
     484:	60e2                	ld	ra,24(sp)
     486:	6442                	ld	s0,16(sp)
     488:	64a2                	ld	s1,8(sp)
     48a:	6105                	addi	sp,sp,32
     48c:	8082                	ret

000000000000048e <testSigactionIGN>:
void testSigactionIGN(void){
     48e:	7179                	addi	sp,sp,-48
     490:	f406                	sd	ra,40(sp)
     492:	f022                	sd	s0,32(sp)
     494:	ec26                	sd	s1,24(sp)
     496:	e84a                	sd	s2,16(sp)
     498:	e44e                	sd	s3,8(sp)
     49a:	1800                	addi	s0,sp,48
  struct sigaction* act = malloc(sizeof(struct sigaction));
     49c:	4541                	li	a0,16
     49e:	00001097          	auipc	ra,0x1
     4a2:	df6080e7          	jalr	-522(ra) # 1294 <malloc>
     4a6:	85aa                	mv	a1,a0
  act->sa_handler = (void *)SIG_IGN;
     4a8:	4785                	li	a5,1
     4aa:	e11c                	sd	a5,0(a0)
  act->sigmask = 0;
     4ac:	00052423          	sw	zero,8(a0)
  sigaction(5, act, 0);
     4b0:	4601                	li	a2,0
     4b2:	4515                	li	a0,5
     4b4:	00001097          	auipc	ra,0x1
     4b8:	9f8080e7          	jalr	-1544(ra) # eac <sigaction>
  int cpid = fork();
     4bc:	00001097          	auipc	ra,0x1
     4c0:	940080e7          	jalr	-1728(ra) # dfc <fork>
  if(cpid == 0){
     4c4:	e505                	bnez	a0,4ec <testSigactionIGN+0x5e>
      if(flag == 5){
     4c6:	00001997          	auipc	s3,0x1
     4ca:	44698993          	addi	s3,s3,1094 # 190c <flag>
     4ce:	4495                	li	s1,5
        printf( "If you see me, that's not good\n");
     4d0:	00001917          	auipc	s2,0x1
     4d4:	0e090913          	addi	s2,s2,224 # 15b0 <malloc+0x31c>
      if(flag == 5){
     4d8:	0009a783          	lw	a5,0(s3)
     4dc:	00979063          	bne	a5,s1,4dc <testSigactionIGN+0x4e>
        printf( "If you see me, that's not good\n");
     4e0:	854a                	mv	a0,s2
     4e2:	00001097          	auipc	ra,0x1
     4e6:	cf4080e7          	jalr	-780(ra) # 11d6 <printf>
     4ea:	b7fd                	j	4d8 <testSigactionIGN+0x4a>
     4ec:	84aa                	mv	s1,a0
    sleep(10);
     4ee:	4529                	li	a0,10
     4f0:	00001097          	auipc	ra,0x1
     4f4:	9a4080e7          	jalr	-1628(ra) # e94 <sleep>
    printf( "send sigaction eith SIG_IGN\n");
     4f8:	00001517          	auipc	a0,0x1
     4fc:	0d850513          	addi	a0,a0,216 # 15d0 <malloc+0x33c>
     500:	00001097          	auipc	ra,0x1
     504:	cd6080e7          	jalr	-810(ra) # 11d6 <printf>
    kill(cpid, 5);
     508:	4595                	li	a1,5
     50a:	8526                	mv	a0,s1
     50c:	00001097          	auipc	ra,0x1
     510:	928080e7          	jalr	-1752(ra) # e34 <kill>
    sleep(10);
     514:	4529                	li	a0,10
     516:	00001097          	auipc	ra,0x1
     51a:	97e080e7          	jalr	-1666(ra) # e94 <sleep>
    kill(cpid, SIGKILL);
     51e:	45a5                	li	a1,9
     520:	8526                	mv	a0,s1
     522:	00001097          	auipc	ra,0x1
     526:	912080e7          	jalr	-1774(ra) # e34 <kill>
  wait(0);
     52a:	4501                	li	a0,0
     52c:	00001097          	auipc	ra,0x1
     530:	8e0080e7          	jalr	-1824(ra) # e0c <wait>
  printf("testSigactionIGN test OK\n");
     534:	00001517          	auipc	a0,0x1
     538:	0bc50513          	addi	a0,a0,188 # 15f0 <malloc+0x35c>
     53c:	00001097          	auipc	ra,0x1
     540:	c9a080e7          	jalr	-870(ra) # 11d6 <printf>
  flag = 0;
     544:	00001797          	auipc	a5,0x1
     548:	3c07a423          	sw	zero,968(a5) # 190c <flag>
}
     54c:	70a2                	ld	ra,40(sp)
     54e:	7402                	ld	s0,32(sp)
     550:	64e2                	ld	s1,24(sp)
     552:	6942                	ld	s2,16(sp)
     554:	69a2                	ld	s3,8(sp)
     556:	6145                	addi	sp,sp,48
     558:	8082                	ret

000000000000055a <testSigmAsk>:
void testSigmAsk(void){
     55a:	7179                	addi	sp,sp,-48
     55c:	f406                	sd	ra,40(sp)
     55e:	f022                	sd	s0,32(sp)
     560:	ec26                	sd	s1,24(sp)
     562:	e84a                	sd	s2,16(sp)
     564:	e44e                	sd	s3,8(sp)
     566:	1800                	addi	s0,sp,48
  sigprocmask(mask);
     568:	4521                	li	a0,8
     56a:	00001097          	auipc	ra,0x1
     56e:	93a080e7          	jalr	-1734(ra) # ea4 <sigprocmask>
  struct sigaction* act = malloc(sizeof(struct sigaction *));
     572:	4521                	li	a0,8
     574:	00001097          	auipc	ra,0x1
     578:	d20080e7          	jalr	-736(ra) # 1294 <malloc>
     57c:	89aa                	mv	s3,a0
  act->sa_handler = handle;
     57e:	00000797          	auipc	a5,0x0
     582:	a8278793          	addi	a5,a5,-1406 # 0 <handle>
     586:	e11c                	sd	a5,0(a0)
  act->sigmask = 0;
     588:	00052423          	sw	zero,8(a0)
  struct sigaction* act2 = malloc(sizeof(struct sigaction *));
     58c:	4521                	li	a0,8
     58e:	00001097          	auipc	ra,0x1
     592:	d06080e7          	jalr	-762(ra) # 1294 <malloc>
     596:	892a                	mv	s2,a0
  act2->sa_handler = handle2;
     598:	00000797          	auipc	a5,0x0
     59c:	a9278793          	addi	a5,a5,-1390 # 2a <handle2>
     5a0:	e11c                	sd	a5,0(a0)
  act2->sigmask = 0;
     5a2:	00052423          	sw	zero,8(a0)
  struct sigaction* act3 = malloc(sizeof(struct sigaction *));
     5a6:	4521                	li	a0,8
     5a8:	00001097          	auipc	ra,0x1
     5ac:	cec080e7          	jalr	-788(ra) # 1294 <malloc>
     5b0:	84aa                	mv	s1,a0
  act3->sa_handler = handle3;
     5b2:	00000797          	auipc	a5,0x0
     5b6:	aa278793          	addi	a5,a5,-1374 # 54 <handle3>
     5ba:	e11c                	sd	a5,0(a0)
  act3->sigmask = 0;
     5bc:	00052423          	sw	zero,8(a0)
  sigaction(5, act, 0);
     5c0:	4601                	li	a2,0
     5c2:	85ce                	mv	a1,s3
     5c4:	4515                	li	a0,5
     5c6:	00001097          	auipc	ra,0x1
     5ca:	8e6080e7          	jalr	-1818(ra) # eac <sigaction>
  sigaction(2, act2, 0);
     5ce:	4601                	li	a2,0
     5d0:	85ca                	mv	a1,s2
     5d2:	4509                	li	a0,2
     5d4:	00001097          	auipc	ra,0x1
     5d8:	8d8080e7          	jalr	-1832(ra) # eac <sigaction>
  sigaction(7, act3, 0);
     5dc:	4601                	li	a2,0
     5de:	85a6                	mv	a1,s1
     5e0:	451d                	li	a0,7
     5e2:	00001097          	auipc	ra,0x1
     5e6:	8ca080e7          	jalr	-1846(ra) # eac <sigaction>
  int cpid = fork();
     5ea:	00001097          	auipc	ra,0x1
     5ee:	812080e7          	jalr	-2030(ra) # dfc <fork>
  if(cpid == 0){
     5f2:	e921                	bnez	a0,642 <testSigmAsk+0xe8>
      if(flag == 7){
     5f4:	00001717          	auipc	a4,0x1
     5f8:	31872703          	lw	a4,792(a4) # 190c <flag>
     5fc:	479d                	li	a5,7
     5fe:	00f71063          	bne	a4,a5,5fe <testSigmAsk+0xa4>
        printf("Recieved flag\n");
     602:	00001517          	auipc	a0,0x1
     606:	00e50513          	addi	a0,a0,14 # 1610 <malloc+0x37c>
     60a:	00001097          	auipc	ra,0x1
     60e:	bcc080e7          	jalr	-1076(ra) # 11d6 <printf>
  wait(0);
     612:	4501                	li	a0,0
     614:	00000097          	auipc	ra,0x0
     618:	7f8080e7          	jalr	2040(ra) # e0c <wait>
  printf( "sig mask test OK\n");
     61c:	00001517          	auipc	a0,0x1
     620:	02450513          	addi	a0,a0,36 # 1640 <malloc+0x3ac>
     624:	00001097          	auipc	ra,0x1
     628:	bb2080e7          	jalr	-1102(ra) # 11d6 <printf>
  flag = 0;
     62c:	00001797          	auipc	a5,0x1
     630:	2e07a023          	sw	zero,736(a5) # 190c <flag>
}
     634:	70a2                	ld	ra,40(sp)
     636:	7402                	ld	s0,32(sp)
     638:	64e2                	ld	s1,24(sp)
     63a:	6942                	ld	s2,16(sp)
     63c:	69a2                	ld	s3,8(sp)
     63e:	6145                	addi	sp,sp,48
     640:	8082                	ret
     642:	84aa                	mv	s1,a0
    sleep(10);
     644:	4529                	li	a0,10
     646:	00001097          	auipc	ra,0x1
     64a:	84e080e7          	jalr	-1970(ra) # e94 <sleep>
    printf("sending sigaction with handler\n");
     64e:	00001517          	auipc	a0,0x1
     652:	fd250513          	addi	a0,a0,-46 # 1620 <malloc+0x38c>
     656:	00001097          	auipc	ra,0x1
     65a:	b80080e7          	jalr	-1152(ra) # 11d6 <printf>
    kill(cpid, 7);
     65e:	459d                	li	a1,7
     660:	8526                	mv	a0,s1
     662:	00000097          	auipc	ra,0x0
     666:	7d2080e7          	jalr	2002(ra) # e34 <kill>
    sleep(10);
     66a:	4529                	li	a0,10
     66c:	00001097          	auipc	ra,0x1
     670:	828080e7          	jalr	-2008(ra) # e94 <sleep>
     674:	bf79                	j	612 <testSigmAsk+0xb8>

0000000000000676 <signal_test>:
void signal_test(){
     676:	715d                	addi	sp,sp,-80
     678:	e486                	sd	ra,72(sp)
     67a:	e0a2                	sd	s0,64(sp)
     67c:	fc26                	sd	s1,56(sp)
     67e:	0880                	addi	s0,sp,80
    struct sigaction act = {test_handler, (uint)(1 << 29)};
     680:	00000797          	auipc	a5,0x0
     684:	a1678793          	addi	a5,a5,-1514 # 96 <test_handler>
     688:	fcf43423          	sd	a5,-56(s0)
     68c:	200007b7          	lui	a5,0x20000
     690:	fcf42823          	sw	a5,-48(s0)
    sigprocmask(0);
     694:	4501                	li	a0,0
     696:	00001097          	auipc	ra,0x1
     69a:	80e080e7          	jalr	-2034(ra) # ea4 <sigprocmask>
    sigaction(testsig, &act, &old);
     69e:	fb840613          	addi	a2,s0,-72
     6a2:	fc840593          	addi	a1,s0,-56
     6a6:	453d                	li	a0,15
     6a8:	00001097          	auipc	ra,0x1
     6ac:	804080e7          	jalr	-2044(ra) # eac <sigaction>
    if((pid = fork()) == 0){
     6b0:	00000097          	auipc	ra,0x0
     6b4:	74c080e7          	jalr	1868(ra) # dfc <fork>
     6b8:	fca42e23          	sw	a0,-36(s0)
     6bc:	c90d                	beqz	a0,6ee <signal_test+0x78>
    kill(pid, testsig);
     6be:	45bd                	li	a1,15
     6c0:	00000097          	auipc	ra,0x0
     6c4:	774080e7          	jalr	1908(ra) # e34 <kill>
    wait(&pid);
     6c8:	fdc40513          	addi	a0,s0,-36
     6cc:	00000097          	auipc	ra,0x0
     6d0:	740080e7          	jalr	1856(ra) # e0c <wait>
    printf("Finished testing signals\n");
     6d4:	00001517          	auipc	a0,0x1
     6d8:	f8450513          	addi	a0,a0,-124 # 1658 <malloc+0x3c4>
     6dc:	00001097          	auipc	ra,0x1
     6e0:	afa080e7          	jalr	-1286(ra) # 11d6 <printf>
}
     6e4:	60a6                	ld	ra,72(sp)
     6e6:	6406                	ld	s0,64(sp)
     6e8:	74e2                	ld	s1,56(sp)
     6ea:	6161                	addi	sp,sp,80
     6ec:	8082                	ret
        while(!wait_sig)
     6ee:	00001797          	auipc	a5,0x1
     6f2:	21a7a783          	lw	a5,538(a5) # 1908 <wait_sig>
     6f6:	ef81                	bnez	a5,70e <signal_test+0x98>
     6f8:	00001497          	auipc	s1,0x1
     6fc:	21048493          	addi	s1,s1,528 # 1908 <wait_sig>
            sleep(1);
     700:	4505                	li	a0,1
     702:	00000097          	auipc	ra,0x0
     706:	792080e7          	jalr	1938(ra) # e94 <sleep>
        while(!wait_sig)
     70a:	409c                	lw	a5,0(s1)
     70c:	dbf5                	beqz	a5,700 <signal_test+0x8a>
        exit(0);
     70e:	4501                	li	a0,0
     710:	00000097          	auipc	ra,0x0
     714:	6f4080e7          	jalr	1780(ra) # e04 <exit>

0000000000000718 <bsem_test>:
void bsem_test(){
     718:	7179                	addi	sp,sp,-48
     71a:	f406                	sd	ra,40(sp)
     71c:	f022                	sd	s0,32(sp)
     71e:	ec26                	sd	s1,24(sp)
     720:	1800                	addi	s0,sp,48
    int bid = bsem_alloc();
     722:	00000097          	auipc	ra,0x0
     726:	7b2080e7          	jalr	1970(ra) # ed4 <bsem_alloc>
     72a:	84aa                	mv	s1,a0
    bsem_down(bid);
     72c:	00000097          	auipc	ra,0x0
     730:	790080e7          	jalr	1936(ra) # ebc <bsem_down>
    printf("1. Parent downing semaphore, pid number = %d\n" , getpid());
     734:	00000097          	auipc	ra,0x0
     738:	750080e7          	jalr	1872(ra) # e84 <getpid>
     73c:	85aa                	mv	a1,a0
     73e:	00001517          	auipc	a0,0x1
     742:	f3a50513          	addi	a0,a0,-198 # 1678 <malloc+0x3e4>
     746:	00001097          	auipc	ra,0x1
     74a:	a90080e7          	jalr	-1392(ra) # 11d6 <printf>
    if((pid = fork()) == 0){
     74e:	00000097          	auipc	ra,0x0
     752:	6ae080e7          	jalr	1710(ra) # dfc <fork>
     756:	fca42e23          	sw	a0,-36(s0)
     75a:	c125                	beqz	a0,7ba <bsem_test+0xa2>
    sleep(5);
     75c:	4515                	li	a0,5
     75e:	00000097          	auipc	ra,0x0
     762:	736080e7          	jalr	1846(ra) # e94 <sleep>
    printf("3. Let the child wait on the semaphore...\n");
     766:	00001517          	auipc	a0,0x1
     76a:	f8a50513          	addi	a0,a0,-118 # 16f0 <malloc+0x45c>
     76e:	00001097          	auipc	ra,0x1
     772:	a68080e7          	jalr	-1432(ra) # 11d6 <printf>
    sleep(10);
     776:	4529                	li	a0,10
     778:	00000097          	auipc	ra,0x0
     77c:	71c080e7          	jalr	1820(ra) # e94 <sleep>
    bsem_up(bid);
     780:	8526                	mv	a0,s1
     782:	00000097          	auipc	ra,0x0
     786:	742080e7          	jalr	1858(ra) # ec4 <bsem_up>
    bsem_free(bid);
     78a:	8526                	mv	a0,s1
     78c:	00000097          	auipc	ra,0x0
     790:	740080e7          	jalr	1856(ra) # ecc <bsem_free>
    wait(&pid);
     794:	fdc40513          	addi	a0,s0,-36
     798:	00000097          	auipc	ra,0x0
     79c:	674080e7          	jalr	1652(ra) # e0c <wait>
    printf("Finished bsem test, make sure that the order of the prints is alright. Meaning (1...2...3...4)\n");
     7a0:	00001517          	auipc	a0,0x1
     7a4:	f8050513          	addi	a0,a0,-128 # 1720 <malloc+0x48c>
     7a8:	00001097          	auipc	ra,0x1
     7ac:	a2e080e7          	jalr	-1490(ra) # 11d6 <printf>
}
     7b0:	70a2                	ld	ra,40(sp)
     7b2:	7402                	ld	s0,32(sp)
     7b4:	64e2                	ld	s1,24(sp)
     7b6:	6145                	addi	sp,sp,48
     7b8:	8082                	ret
        printf("2. Child downing semaphore, pid number = %d\n" , getpid());
     7ba:	00000097          	auipc	ra,0x0
     7be:	6ca080e7          	jalr	1738(ra) # e84 <getpid>
     7c2:	85aa                	mv	a1,a0
     7c4:	00001517          	auipc	a0,0x1
     7c8:	ee450513          	addi	a0,a0,-284 # 16a8 <malloc+0x414>
     7cc:	00001097          	auipc	ra,0x1
     7d0:	a0a080e7          	jalr	-1526(ra) # 11d6 <printf>
        bsem_down(bid);
     7d4:	8526                	mv	a0,s1
     7d6:	00000097          	auipc	ra,0x0
     7da:	6e6080e7          	jalr	1766(ra) # ebc <bsem_down>
        printf("4. Child woke up\n");
     7de:	00001517          	auipc	a0,0x1
     7e2:	efa50513          	addi	a0,a0,-262 # 16d8 <malloc+0x444>
     7e6:	00001097          	auipc	ra,0x1
     7ea:	9f0080e7          	jalr	-1552(ra) # 11d6 <printf>
        exit(0);
     7ee:	4501                	li	a0,0
     7f0:	00000097          	auipc	ra,0x0
     7f4:	614080e7          	jalr	1556(ra) # e04 <exit>

00000000000007f8 <thread_kthread_create>:

void thread_kthread_create(){
     7f8:	1101                	addi	sp,sp,-32
     7fa:	ec06                	sd	ra,24(sp)
     7fc:	e822                	sd	s0,16(sp)
     7fe:	e426                	sd	s1,8(sp)
     800:	1000                	addi	s0,sp,32
  fprintf(2, "\nstarting kthread_create test\n");
     802:	00001597          	auipc	a1,0x1
     806:	f7e58593          	addi	a1,a1,-130 # 1780 <malloc+0x4ec>
     80a:	4509                	li	a0,2
     80c:	00001097          	auipc	ra,0x1
     810:	99c080e7          	jalr	-1636(ra) # 11a8 <fprintf>

  fprintf(2, "curr thread id is: %d\n", kthread_id());
     814:	00000097          	auipc	ra,0x0
     818:	6d0080e7          	jalr	1744(ra) # ee4 <kthread_id>
     81c:	862a                	mv	a2,a0
     81e:	00001597          	auipc	a1,0x1
     822:	f8258593          	addi	a1,a1,-126 # 17a0 <malloc+0x50c>
     826:	4509                	li	a0,2
     828:	00001097          	auipc	ra,0x1
     82c:	980080e7          	jalr	-1664(ra) # 11a8 <fprintf>
  void* stack = malloc(MAX_STACK_SIZE);
     830:	6505                	lui	a0,0x1
     832:	fa050513          	addi	a0,a0,-96 # fa0 <printint+0x80>
     836:	00001097          	auipc	ra,0x1
     83a:	a5e080e7          	jalr	-1442(ra) # 1294 <malloc>
     83e:	84aa                	mv	s1,a0
  fprintf(2, "the new thread id is: %d\n", kthread_create(thread_kthread_id,stack));
     840:	85aa                	mv	a1,a0
     842:	00000517          	auipc	a0,0x0
     846:	87e50513          	addi	a0,a0,-1922 # c0 <thread_kthread_id>
     84a:	00000097          	auipc	ra,0x0
     84e:	692080e7          	jalr	1682(ra) # edc <kthread_create>
     852:	862a                	mv	a2,a0
     854:	00001597          	auipc	a1,0x1
     858:	f6458593          	addi	a1,a1,-156 # 17b8 <malloc+0x524>
     85c:	4509                	li	a0,2
     85e:	00001097          	auipc	ra,0x1
     862:	94a080e7          	jalr	-1718(ra) # 11a8 <fprintf>
  free(stack);
     866:	8526                	mv	a0,s1
     868:	00001097          	auipc	ra,0x1
     86c:	9a4080e7          	jalr	-1628(ra) # 120c <free>

  fprintf(2, "finished kthread_create test\n");
     870:	00001597          	auipc	a1,0x1
     874:	f6858593          	addi	a1,a1,-152 # 17d8 <malloc+0x544>
     878:	4509                	li	a0,2
     87a:	00001097          	auipc	ra,0x1
     87e:	92e080e7          	jalr	-1746(ra) # 11a8 <fprintf>
}
     882:	60e2                	ld	ra,24(sp)
     884:	6442                	ld	s0,16(sp)
     886:	64a2                	ld	s1,8(sp)
     888:	6105                	addi	sp,sp,32
     88a:	8082                	ret

000000000000088c <thread_kthread_create_with_wait>:

void thread_kthread_create_with_wait(){
     88c:	7179                	addi	sp,sp,-48
     88e:	f406                	sd	ra,40(sp)
     890:	f022                	sd	s0,32(sp)
     892:	ec26                	sd	s1,24(sp)
     894:	1800                	addi	s0,sp,48
  fprintf(2, "\nstarting kthread_create_with_wait test\n");
     896:	00001597          	auipc	a1,0x1
     89a:	f6258593          	addi	a1,a1,-158 # 17f8 <malloc+0x564>
     89e:	4509                	li	a0,2
     8a0:	00001097          	auipc	ra,0x1
     8a4:	908080e7          	jalr	-1784(ra) # 11a8 <fprintf>

  fprintf(2, "curr thread id is: %d\n", kthread_id());
     8a8:	00000097          	auipc	ra,0x0
     8ac:	63c080e7          	jalr	1596(ra) # ee4 <kthread_id>
     8b0:	862a                	mv	a2,a0
     8b2:	00001597          	auipc	a1,0x1
     8b6:	eee58593          	addi	a1,a1,-274 # 17a0 <malloc+0x50c>
     8ba:	4509                	li	a0,2
     8bc:	00001097          	auipc	ra,0x1
     8c0:	8ec080e7          	jalr	-1812(ra) # 11a8 <fprintf>
  void* stack = malloc(MAX_STACK_SIZE);
     8c4:	6505                	lui	a0,0x1
     8c6:	fa050513          	addi	a0,a0,-96 # fa0 <printint+0x80>
     8ca:	00001097          	auipc	ra,0x1
     8ce:	9ca080e7          	jalr	-1590(ra) # 1294 <malloc>
     8d2:	84aa                	mv	s1,a0
  fprintf(2, "the new thread id is: %d\n", kthread_create(thread_kthread_id,stack));
     8d4:	85aa                	mv	a1,a0
     8d6:	fffff517          	auipc	a0,0xfffff
     8da:	7ea50513          	addi	a0,a0,2026 # c0 <thread_kthread_id>
     8de:	00000097          	auipc	ra,0x0
     8e2:	5fe080e7          	jalr	1534(ra) # edc <kthread_create>
     8e6:	862a                	mv	a2,a0
     8e8:	00001597          	auipc	a1,0x1
     8ec:	ed058593          	addi	a1,a1,-304 # 17b8 <malloc+0x524>
     8f0:	4509                	li	a0,2
     8f2:	00001097          	auipc	ra,0x1
     8f6:	8b6080e7          	jalr	-1866(ra) # 11a8 <fprintf>
  free(stack);
     8fa:	8526                	mv	a0,s1
     8fc:	00001097          	auipc	ra,0x1
     900:	910080e7          	jalr	-1776(ra) # 120c <free>
  int x= 10;
     904:	47a9                	li	a5,10
     906:	fcf42e23          	sw	a5,-36(s0)
  wait(&x);
     90a:	fdc40513          	addi	a0,s0,-36
     90e:	00000097          	auipc	ra,0x0
     912:	4fe080e7          	jalr	1278(ra) # e0c <wait>

  fprintf(2, "finished kthread_create_with_wait test\n");
     916:	00001597          	auipc	a1,0x1
     91a:	f1258593          	addi	a1,a1,-238 # 1828 <malloc+0x594>
     91e:	4509                	li	a0,2
     920:	00001097          	auipc	ra,0x1
     924:	888080e7          	jalr	-1912(ra) # 11a8 <fprintf>
}
     928:	70a2                	ld	ra,40(sp)
     92a:	7402                	ld	s0,32(sp)
     92c:	64e2                	ld	s1,24(sp)
     92e:	6145                	addi	sp,sp,48
     930:	8082                	ret

0000000000000932 <Csem_test>:



void Csem_test(){
     932:	7179                	addi	sp,sp,-48
     934:	f406                	sd	ra,40(sp)
     936:	f022                	sd	s0,32(sp)
     938:	1800                	addi	s0,sp,48
	struct counting_semaphore csem;
    int retval;
    int pid;
    
    
    retval = csem_alloc(&csem,1);
     93a:	4585                	li	a1,1
     93c:	fe040513          	addi	a0,s0,-32
     940:	00000097          	auipc	ra,0x0
     944:	434080e7          	jalr	1076(ra) # d74 <csem_alloc>
    if(retval==-1)
     948:	57fd                	li	a5,-1
     94a:	08f50763          	beq	a0,a5,9d8 <Csem_test+0xa6>
    {
		printf("failed csem alloc");
		exit(-1);
	}
    csem_down(&csem);
     94e:	fe040513          	addi	a0,s0,-32
     952:	00000097          	auipc	ra,0x0
     956:	38e080e7          	jalr	910(ra) # ce0 <csem_down>
    printf("1. Parent downing semaphore\n");
     95a:	00001517          	auipc	a0,0x1
     95e:	f0e50513          	addi	a0,a0,-242 # 1868 <malloc+0x5d4>
     962:	00001097          	auipc	ra,0x1
     966:	874080e7          	jalr	-1932(ra) # 11d6 <printf>
    if((pid = fork()) == 0){
     96a:	00000097          	auipc	ra,0x0
     96e:	492080e7          	jalr	1170(ra) # dfc <fork>
     972:	fca42e23          	sw	a0,-36(s0)
     976:	cd35                	beqz	a0,9f2 <Csem_test+0xc0>
        printf("2. Child downing semaphore\n");
        csem_down(&csem);
        printf("4. Child woke up\n");
        exit(0);
    }
    sleep(5);
     978:	4515                	li	a0,5
     97a:	00000097          	auipc	ra,0x0
     97e:	51a080e7          	jalr	1306(ra) # e94 <sleep>
    printf("3. Let the child wait on the semaphore...\n");
     982:	00001517          	auipc	a0,0x1
     986:	d6e50513          	addi	a0,a0,-658 # 16f0 <malloc+0x45c>
     98a:	00001097          	auipc	ra,0x1
     98e:	84c080e7          	jalr	-1972(ra) # 11d6 <printf>
    sleep(10);
     992:	4529                	li	a0,10
     994:	00000097          	auipc	ra,0x0
     998:	500080e7          	jalr	1280(ra) # e94 <sleep>
    csem_up(&csem);
     99c:	fe040513          	addi	a0,s0,-32
     9a0:	00000097          	auipc	ra,0x0
     9a4:	38e080e7          	jalr	910(ra) # d2e <csem_up>

    csem_free(&csem);
     9a8:	fe040513          	addi	a0,s0,-32
     9ac:	00000097          	auipc	ra,0x0
     9b0:	426080e7          	jalr	1062(ra) # dd2 <csem_free>
    wait(&pid);
     9b4:	fdc40513          	addi	a0,s0,-36
     9b8:	00000097          	auipc	ra,0x0
     9bc:	454080e7          	jalr	1108(ra) # e0c <wait>

    printf("Finished bsem test, make sure that the order of the prints is alright. Meaning (1...2...3...4)\n");
     9c0:	00001517          	auipc	a0,0x1
     9c4:	d6050513          	addi	a0,a0,-672 # 1720 <malloc+0x48c>
     9c8:	00001097          	auipc	ra,0x1
     9cc:	80e080e7          	jalr	-2034(ra) # 11d6 <printf>
}
     9d0:	70a2                	ld	ra,40(sp)
     9d2:	7402                	ld	s0,32(sp)
     9d4:	6145                	addi	sp,sp,48
     9d6:	8082                	ret
		printf("failed csem alloc");
     9d8:	00001517          	auipc	a0,0x1
     9dc:	e7850513          	addi	a0,a0,-392 # 1850 <malloc+0x5bc>
     9e0:	00000097          	auipc	ra,0x0
     9e4:	7f6080e7          	jalr	2038(ra) # 11d6 <printf>
		exit(-1);
     9e8:	557d                	li	a0,-1
     9ea:	00000097          	auipc	ra,0x0
     9ee:	41a080e7          	jalr	1050(ra) # e04 <exit>
        printf("2. Child downing semaphore\n");
     9f2:	00001517          	auipc	a0,0x1
     9f6:	e9650513          	addi	a0,a0,-362 # 1888 <malloc+0x5f4>
     9fa:	00000097          	auipc	ra,0x0
     9fe:	7dc080e7          	jalr	2012(ra) # 11d6 <printf>
        csem_down(&csem);
     a02:	fe040513          	addi	a0,s0,-32
     a06:	00000097          	auipc	ra,0x0
     a0a:	2da080e7          	jalr	730(ra) # ce0 <csem_down>
        printf("4. Child woke up\n");
     a0e:	00001517          	auipc	a0,0x1
     a12:	cca50513          	addi	a0,a0,-822 # 16d8 <malloc+0x444>
     a16:	00000097          	auipc	ra,0x0
     a1a:	7c0080e7          	jalr	1984(ra) # 11d6 <printf>
        exit(0);
     a1e:	4501                	li	a0,0
     a20:	00000097          	auipc	ra,0x0
     a24:	3e4080e7          	jalr	996(ra) # e04 <exit>

0000000000000a28 <main>:


//ASS2 TASK2
int
main(int argc, char **argv)
{
     a28:	1141                	addi	sp,sp,-16
     a2a:	e406                	sd	ra,8(sp)
     a2c:	e022                	sd	s0,0(sp)
     a2e:	0800                	addi	s0,sp,16
  printf( "starting testing signals and friends\n");
     a30:	00001517          	auipc	a0,0x1
     a34:	e7850513          	addi	a0,a0,-392 # 18a8 <malloc+0x614>
     a38:	00000097          	auipc	ra,0x0
     a3c:	79e080e7          	jalr	1950(ra) # 11d6 <printf>
//  testSigactionHandler1();
//  testContStopCont();
//  testStopCont();
//  testSigactionIGN();
//  testSigmAsk();
  signal_test();
     a40:	00000097          	auipc	ra,0x0
     a44:	c36080e7          	jalr	-970(ra) # 676 <signal_test>
  bsem_test();
     a48:	00000097          	auipc	ra,0x0
     a4c:	cd0080e7          	jalr	-816(ra) # 718 <bsem_test>
  Csem_test() ;
     a50:	00000097          	auipc	ra,0x0
     a54:	ee2080e7          	jalr	-286(ra) # 932 <Csem_test>
//  thread_kthread_id();
  thread_kthread_create();
     a58:	00000097          	auipc	ra,0x0
     a5c:	da0080e7          	jalr	-608(ra) # 7f8 <thread_kthread_create>
//thread_kthread_create_with_wait();

  printf("\nALL TESTS PASSED\n");
     a60:	00001517          	auipc	a0,0x1
     a64:	e7050513          	addi	a0,a0,-400 # 18d0 <malloc+0x63c>
     a68:	00000097          	auipc	ra,0x0
     a6c:	76e080e7          	jalr	1902(ra) # 11d6 <printf>
  exit(0);
     a70:	4501                	li	a0,0
     a72:	00000097          	auipc	ra,0x0
     a76:	392080e7          	jalr	914(ra) # e04 <exit>

0000000000000a7a <strcpy>:
#include "kernel/Csemaphore.h"


char*
strcpy(char *s, const char *t)
{
     a7a:	1141                	addi	sp,sp,-16
     a7c:	e422                	sd	s0,8(sp)
     a7e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     a80:	87aa                	mv	a5,a0
     a82:	0585                	addi	a1,a1,1
     a84:	0785                	addi	a5,a5,1
     a86:	fff5c703          	lbu	a4,-1(a1)
     a8a:	fee78fa3          	sb	a4,-1(a5)
     a8e:	fb75                	bnez	a4,a82 <strcpy+0x8>
    ;
  return os;
}
     a90:	6422                	ld	s0,8(sp)
     a92:	0141                	addi	sp,sp,16
     a94:	8082                	ret

0000000000000a96 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     a96:	1141                	addi	sp,sp,-16
     a98:	e422                	sd	s0,8(sp)
     a9a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     a9c:	00054783          	lbu	a5,0(a0)
     aa0:	cb91                	beqz	a5,ab4 <strcmp+0x1e>
     aa2:	0005c703          	lbu	a4,0(a1)
     aa6:	00f71763          	bne	a4,a5,ab4 <strcmp+0x1e>
    p++, q++;
     aaa:	0505                	addi	a0,a0,1
     aac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     aae:	00054783          	lbu	a5,0(a0)
     ab2:	fbe5                	bnez	a5,aa2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     ab4:	0005c503          	lbu	a0,0(a1)
}
     ab8:	40a7853b          	subw	a0,a5,a0
     abc:	6422                	ld	s0,8(sp)
     abe:	0141                	addi	sp,sp,16
     ac0:	8082                	ret

0000000000000ac2 <strlen>:

uint
strlen(const char *s)
{
     ac2:	1141                	addi	sp,sp,-16
     ac4:	e422                	sd	s0,8(sp)
     ac6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     ac8:	00054783          	lbu	a5,0(a0)
     acc:	cf91                	beqz	a5,ae8 <strlen+0x26>
     ace:	0505                	addi	a0,a0,1
     ad0:	87aa                	mv	a5,a0
     ad2:	4685                	li	a3,1
     ad4:	9e89                	subw	a3,a3,a0
     ad6:	00f6853b          	addw	a0,a3,a5
     ada:	0785                	addi	a5,a5,1
     adc:	fff7c703          	lbu	a4,-1(a5)
     ae0:	fb7d                	bnez	a4,ad6 <strlen+0x14>
    ;
  return n;
}
     ae2:	6422                	ld	s0,8(sp)
     ae4:	0141                	addi	sp,sp,16
     ae6:	8082                	ret
  for(n = 0; s[n]; n++)
     ae8:	4501                	li	a0,0
     aea:	bfe5                	j	ae2 <strlen+0x20>

0000000000000aec <memset>:

void*
memset(void *dst, int c, uint n)
{
     aec:	1141                	addi	sp,sp,-16
     aee:	e422                	sd	s0,8(sp)
     af0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     af2:	ca19                	beqz	a2,b08 <memset+0x1c>
     af4:	87aa                	mv	a5,a0
     af6:	1602                	slli	a2,a2,0x20
     af8:	9201                	srli	a2,a2,0x20
     afa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     afe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     b02:	0785                	addi	a5,a5,1
     b04:	fee79de3          	bne	a5,a4,afe <memset+0x12>
  }
  return dst;
}
     b08:	6422                	ld	s0,8(sp)
     b0a:	0141                	addi	sp,sp,16
     b0c:	8082                	ret

0000000000000b0e <strchr>:

char*
strchr(const char *s, char c)
{
     b0e:	1141                	addi	sp,sp,-16
     b10:	e422                	sd	s0,8(sp)
     b12:	0800                	addi	s0,sp,16
  for(; *s; s++)
     b14:	00054783          	lbu	a5,0(a0)
     b18:	cb99                	beqz	a5,b2e <strchr+0x20>
    if(*s == c)
     b1a:	00f58763          	beq	a1,a5,b28 <strchr+0x1a>
  for(; *s; s++)
     b1e:	0505                	addi	a0,a0,1
     b20:	00054783          	lbu	a5,0(a0)
     b24:	fbfd                	bnez	a5,b1a <strchr+0xc>
      return (char*)s;
  return 0;
     b26:	4501                	li	a0,0
}
     b28:	6422                	ld	s0,8(sp)
     b2a:	0141                	addi	sp,sp,16
     b2c:	8082                	ret
  return 0;
     b2e:	4501                	li	a0,0
     b30:	bfe5                	j	b28 <strchr+0x1a>

0000000000000b32 <gets>:

char*
gets(char *buf, int max)
{
     b32:	711d                	addi	sp,sp,-96
     b34:	ec86                	sd	ra,88(sp)
     b36:	e8a2                	sd	s0,80(sp)
     b38:	e4a6                	sd	s1,72(sp)
     b3a:	e0ca                	sd	s2,64(sp)
     b3c:	fc4e                	sd	s3,56(sp)
     b3e:	f852                	sd	s4,48(sp)
     b40:	f456                	sd	s5,40(sp)
     b42:	f05a                	sd	s6,32(sp)
     b44:	ec5e                	sd	s7,24(sp)
     b46:	1080                	addi	s0,sp,96
     b48:	8baa                	mv	s7,a0
     b4a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     b4c:	892a                	mv	s2,a0
     b4e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     b50:	4aa9                	li	s5,10
     b52:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     b54:	89a6                	mv	s3,s1
     b56:	2485                	addiw	s1,s1,1
     b58:	0344d863          	bge	s1,s4,b88 <gets+0x56>
    cc = read(0, &c, 1);
     b5c:	4605                	li	a2,1
     b5e:	faf40593          	addi	a1,s0,-81
     b62:	4501                	li	a0,0
     b64:	00000097          	auipc	ra,0x0
     b68:	2b8080e7          	jalr	696(ra) # e1c <read>
    if(cc < 1)
     b6c:	00a05e63          	blez	a0,b88 <gets+0x56>
    buf[i++] = c;
     b70:	faf44783          	lbu	a5,-81(s0)
     b74:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     b78:	01578763          	beq	a5,s5,b86 <gets+0x54>
     b7c:	0905                	addi	s2,s2,1
     b7e:	fd679be3          	bne	a5,s6,b54 <gets+0x22>
  for(i=0; i+1 < max; ){
     b82:	89a6                	mv	s3,s1
     b84:	a011                	j	b88 <gets+0x56>
     b86:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     b88:	99de                	add	s3,s3,s7
     b8a:	00098023          	sb	zero,0(s3)
  return buf;
}
     b8e:	855e                	mv	a0,s7
     b90:	60e6                	ld	ra,88(sp)
     b92:	6446                	ld	s0,80(sp)
     b94:	64a6                	ld	s1,72(sp)
     b96:	6906                	ld	s2,64(sp)
     b98:	79e2                	ld	s3,56(sp)
     b9a:	7a42                	ld	s4,48(sp)
     b9c:	7aa2                	ld	s5,40(sp)
     b9e:	7b02                	ld	s6,32(sp)
     ba0:	6be2                	ld	s7,24(sp)
     ba2:	6125                	addi	sp,sp,96
     ba4:	8082                	ret

0000000000000ba6 <stat>:

int
stat(const char *n, struct stat *st)
{
     ba6:	1101                	addi	sp,sp,-32
     ba8:	ec06                	sd	ra,24(sp)
     baa:	e822                	sd	s0,16(sp)
     bac:	e426                	sd	s1,8(sp)
     bae:	e04a                	sd	s2,0(sp)
     bb0:	1000                	addi	s0,sp,32
     bb2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     bb4:	4581                	li	a1,0
     bb6:	00000097          	auipc	ra,0x0
     bba:	28e080e7          	jalr	654(ra) # e44 <open>
  if(fd < 0)
     bbe:	02054563          	bltz	a0,be8 <stat+0x42>
     bc2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     bc4:	85ca                	mv	a1,s2
     bc6:	00000097          	auipc	ra,0x0
     bca:	296080e7          	jalr	662(ra) # e5c <fstat>
     bce:	892a                	mv	s2,a0
  close(fd);
     bd0:	8526                	mv	a0,s1
     bd2:	00000097          	auipc	ra,0x0
     bd6:	25a080e7          	jalr	602(ra) # e2c <close>
  return r;
}
     bda:	854a                	mv	a0,s2
     bdc:	60e2                	ld	ra,24(sp)
     bde:	6442                	ld	s0,16(sp)
     be0:	64a2                	ld	s1,8(sp)
     be2:	6902                	ld	s2,0(sp)
     be4:	6105                	addi	sp,sp,32
     be6:	8082                	ret
    return -1;
     be8:	597d                	li	s2,-1
     bea:	bfc5                	j	bda <stat+0x34>

0000000000000bec <atoi>:

int
atoi(const char *s)
{
     bec:	1141                	addi	sp,sp,-16
     bee:	e422                	sd	s0,8(sp)
     bf0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     bf2:	00054603          	lbu	a2,0(a0)
     bf6:	fd06079b          	addiw	a5,a2,-48
     bfa:	0ff7f793          	andi	a5,a5,255
     bfe:	4725                	li	a4,9
     c00:	02f76963          	bltu	a4,a5,c32 <atoi+0x46>
     c04:	86aa                	mv	a3,a0
  n = 0;
     c06:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     c08:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     c0a:	0685                	addi	a3,a3,1
     c0c:	0025179b          	slliw	a5,a0,0x2
     c10:	9fa9                	addw	a5,a5,a0
     c12:	0017979b          	slliw	a5,a5,0x1
     c16:	9fb1                	addw	a5,a5,a2
     c18:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     c1c:	0006c603          	lbu	a2,0(a3)
     c20:	fd06071b          	addiw	a4,a2,-48
     c24:	0ff77713          	andi	a4,a4,255
     c28:	fee5f1e3          	bgeu	a1,a4,c0a <atoi+0x1e>
  return n;
}
     c2c:	6422                	ld	s0,8(sp)
     c2e:	0141                	addi	sp,sp,16
     c30:	8082                	ret
  n = 0;
     c32:	4501                	li	a0,0
     c34:	bfe5                	j	c2c <atoi+0x40>

0000000000000c36 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     c36:	1141                	addi	sp,sp,-16
     c38:	e422                	sd	s0,8(sp)
     c3a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     c3c:	02b57463          	bgeu	a0,a1,c64 <memmove+0x2e>
    while(n-- > 0)
     c40:	00c05f63          	blez	a2,c5e <memmove+0x28>
     c44:	1602                	slli	a2,a2,0x20
     c46:	9201                	srli	a2,a2,0x20
     c48:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     c4c:	872a                	mv	a4,a0
      *dst++ = *src++;
     c4e:	0585                	addi	a1,a1,1
     c50:	0705                	addi	a4,a4,1
     c52:	fff5c683          	lbu	a3,-1(a1)
     c56:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     c5a:	fee79ae3          	bne	a5,a4,c4e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     c5e:	6422                	ld	s0,8(sp)
     c60:	0141                	addi	sp,sp,16
     c62:	8082                	ret
    dst += n;
     c64:	00c50733          	add	a4,a0,a2
    src += n;
     c68:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     c6a:	fec05ae3          	blez	a2,c5e <memmove+0x28>
     c6e:	fff6079b          	addiw	a5,a2,-1
     c72:	1782                	slli	a5,a5,0x20
     c74:	9381                	srli	a5,a5,0x20
     c76:	fff7c793          	not	a5,a5
     c7a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     c7c:	15fd                	addi	a1,a1,-1
     c7e:	177d                	addi	a4,a4,-1
     c80:	0005c683          	lbu	a3,0(a1)
     c84:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     c88:	fee79ae3          	bne	a5,a4,c7c <memmove+0x46>
     c8c:	bfc9                	j	c5e <memmove+0x28>

0000000000000c8e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     c8e:	1141                	addi	sp,sp,-16
     c90:	e422                	sd	s0,8(sp)
     c92:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     c94:	ca05                	beqz	a2,cc4 <memcmp+0x36>
     c96:	fff6069b          	addiw	a3,a2,-1
     c9a:	1682                	slli	a3,a3,0x20
     c9c:	9281                	srli	a3,a3,0x20
     c9e:	0685                	addi	a3,a3,1
     ca0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     ca2:	00054783          	lbu	a5,0(a0)
     ca6:	0005c703          	lbu	a4,0(a1)
     caa:	00e79863          	bne	a5,a4,cba <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     cae:	0505                	addi	a0,a0,1
    p2++;
     cb0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     cb2:	fed518e3          	bne	a0,a3,ca2 <memcmp+0x14>
  }
  return 0;
     cb6:	4501                	li	a0,0
     cb8:	a019                	j	cbe <memcmp+0x30>
      return *p1 - *p2;
     cba:	40e7853b          	subw	a0,a5,a4
}
     cbe:	6422                	ld	s0,8(sp)
     cc0:	0141                	addi	sp,sp,16
     cc2:	8082                	ret
  return 0;
     cc4:	4501                	li	a0,0
     cc6:	bfe5                	j	cbe <memcmp+0x30>

0000000000000cc8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     cc8:	1141                	addi	sp,sp,-16
     cca:	e406                	sd	ra,8(sp)
     ccc:	e022                	sd	s0,0(sp)
     cce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     cd0:	00000097          	auipc	ra,0x0
     cd4:	f66080e7          	jalr	-154(ra) # c36 <memmove>
}
     cd8:	60a2                	ld	ra,8(sp)
     cda:	6402                	ld	s0,0(sp)
     cdc:	0141                	addi	sp,sp,16
     cde:	8082                	ret

0000000000000ce0 <csem_down>:


void 
csem_down(struct counting_semaphore *sem) {
     ce0:	1101                	addi	sp,sp,-32
     ce2:	ec06                	sd	ra,24(sp)
     ce4:	e822                	sd	s0,16(sp)
     ce6:	e426                	sd	s1,8(sp)
     ce8:	1000                	addi	s0,sp,32
     cea:	84aa                	mv	s1,a0
    bsem_down(sem->bsem2);
     cec:	4148                	lw	a0,4(a0)
     cee:	00000097          	auipc	ra,0x0
     cf2:	1ce080e7          	jalr	462(ra) # ebc <bsem_down>
    bsem_down(sem->bsem1);
     cf6:	4088                	lw	a0,0(s1)
     cf8:	00000097          	auipc	ra,0x0
     cfc:	1c4080e7          	jalr	452(ra) # ebc <bsem_down>
    sem->count -= 1;
     d00:	449c                	lw	a5,8(s1)
     d02:	37fd                	addiw	a5,a5,-1
     d04:	0007871b          	sext.w	a4,a5
     d08:	c49c                	sw	a5,8(s1)
    if (sem->count > 0)
     d0a:	00e04c63          	bgtz	a4,d22 <csem_down+0x42>
    	bsem_up(sem->bsem2);
    bsem_up(sem->bsem1);
     d0e:	4088                	lw	a0,0(s1)
     d10:	00000097          	auipc	ra,0x0
     d14:	1b4080e7          	jalr	436(ra) # ec4 <bsem_up>
}
     d18:	60e2                	ld	ra,24(sp)
     d1a:	6442                	ld	s0,16(sp)
     d1c:	64a2                	ld	s1,8(sp)
     d1e:	6105                	addi	sp,sp,32
     d20:	8082                	ret
    	bsem_up(sem->bsem2);
     d22:	40c8                	lw	a0,4(s1)
     d24:	00000097          	auipc	ra,0x0
     d28:	1a0080e7          	jalr	416(ra) # ec4 <bsem_up>
     d2c:	b7cd                	j	d0e <csem_down+0x2e>

0000000000000d2e <csem_up>:


void 
csem_up(struct counting_semaphore *sem) {
     d2e:	1101                	addi	sp,sp,-32
     d30:	ec06                	sd	ra,24(sp)
     d32:	e822                	sd	s0,16(sp)
     d34:	e426                	sd	s1,8(sp)
     d36:	1000                	addi	s0,sp,32
     d38:	84aa                	mv	s1,a0
	bsem_down(sem->bsem1);
     d3a:	4108                	lw	a0,0(a0)
     d3c:	00000097          	auipc	ra,0x0
     d40:	180080e7          	jalr	384(ra) # ebc <bsem_down>
	sem->count += 1;
     d44:	449c                	lw	a5,8(s1)
     d46:	2785                	addiw	a5,a5,1
     d48:	0007871b          	sext.w	a4,a5
     d4c:	c49c                	sw	a5,8(s1)
	if (sem->count == 1)
     d4e:	4785                	li	a5,1
     d50:	00f70c63          	beq	a4,a5,d68 <csem_up+0x3a>
		bsem_up(sem->bsem2);
	bsem_up(sem->bsem1);
     d54:	4088                	lw	a0,0(s1)
     d56:	00000097          	auipc	ra,0x0
     d5a:	16e080e7          	jalr	366(ra) # ec4 <bsem_up>
}
     d5e:	60e2                	ld	ra,24(sp)
     d60:	6442                	ld	s0,16(sp)
     d62:	64a2                	ld	s1,8(sp)
     d64:	6105                	addi	sp,sp,32
     d66:	8082                	ret
		bsem_up(sem->bsem2);
     d68:	40c8                	lw	a0,4(s1)
     d6a:	00000097          	auipc	ra,0x0
     d6e:	15a080e7          	jalr	346(ra) # ec4 <bsem_up>
     d72:	b7cd                	j	d54 <csem_up+0x26>

0000000000000d74 <csem_alloc>:


int 
csem_alloc(struct counting_semaphore *sem, int count) {
     d74:	7179                	addi	sp,sp,-48
     d76:	f406                	sd	ra,40(sp)
     d78:	f022                	sd	s0,32(sp)
     d7a:	ec26                	sd	s1,24(sp)
     d7c:	e84a                	sd	s2,16(sp)
     d7e:	e44e                	sd	s3,8(sp)
     d80:	1800                	addi	s0,sp,48
     d82:	892a                	mv	s2,a0
     d84:	89ae                	mv	s3,a1
    int bsem1 = bsem_alloc();
     d86:	00000097          	auipc	ra,0x0
     d8a:	14e080e7          	jalr	334(ra) # ed4 <bsem_alloc>
     d8e:	84aa                	mv	s1,a0
    int bsem2 = bsem_alloc();
     d90:	00000097          	auipc	ra,0x0
     d94:	144080e7          	jalr	324(ra) # ed4 <bsem_alloc>
    if (bsem1 == -1 || bsem2 == -1)
     d98:	57fd                	li	a5,-1
     d9a:	00f48d63          	beq	s1,a5,db4 <csem_alloc+0x40>
     d9e:	02f50863          	beq	a0,a5,dce <csem_alloc+0x5a>
        return -1; 
    sem->bsem1 = bsem1;
     da2:	00992023          	sw	s1,0(s2)
    sem->bsem2 = bsem2;
     da6:	00a92223          	sw	a0,4(s2)
    if (count == 0)
     daa:	00098d63          	beqz	s3,dc4 <csem_alloc+0x50>
        // Binary semaphore first value = min(1, count)
        bsem_down(sem->bsem2); 
    sem->count = count;
     dae:	01392423          	sw	s3,8(s2)
    return 0;
     db2:	4481                	li	s1,0
}
     db4:	8526                	mv	a0,s1
     db6:	70a2                	ld	ra,40(sp)
     db8:	7402                	ld	s0,32(sp)
     dba:	64e2                	ld	s1,24(sp)
     dbc:	6942                	ld	s2,16(sp)
     dbe:	69a2                	ld	s3,8(sp)
     dc0:	6145                	addi	sp,sp,48
     dc2:	8082                	ret
        bsem_down(sem->bsem2); 
     dc4:	00000097          	auipc	ra,0x0
     dc8:	0f8080e7          	jalr	248(ra) # ebc <bsem_down>
     dcc:	b7cd                	j	dae <csem_alloc+0x3a>
        return -1; 
     dce:	84aa                	mv	s1,a0
     dd0:	b7d5                	j	db4 <csem_alloc+0x40>

0000000000000dd2 <csem_free>:


void 
csem_free(struct counting_semaphore *sem) {
     dd2:	1101                	addi	sp,sp,-32
     dd4:	ec06                	sd	ra,24(sp)
     dd6:	e822                	sd	s0,16(sp)
     dd8:	e426                	sd	s1,8(sp)
     dda:	1000                	addi	s0,sp,32
     ddc:	84aa                	mv	s1,a0
    bsem_free(sem->bsem1);
     dde:	4108                	lw	a0,0(a0)
     de0:	00000097          	auipc	ra,0x0
     de4:	0ec080e7          	jalr	236(ra) # ecc <bsem_free>
    bsem_free(sem->bsem2);
     de8:	40c8                	lw	a0,4(s1)
     dea:	00000097          	auipc	ra,0x0
     dee:	0e2080e7          	jalr	226(ra) # ecc <bsem_free>
    //free(sem);
}
     df2:	60e2                	ld	ra,24(sp)
     df4:	6442                	ld	s0,16(sp)
     df6:	64a2                	ld	s1,8(sp)
     df8:	6105                	addi	sp,sp,32
     dfa:	8082                	ret

0000000000000dfc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     dfc:	4885                	li	a7,1
 ecall
     dfe:	00000073          	ecall
 ret
     e02:	8082                	ret

0000000000000e04 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e04:	4889                	li	a7,2
 ecall
     e06:	00000073          	ecall
 ret
     e0a:	8082                	ret

0000000000000e0c <wait>:
.global wait
wait:
 li a7, SYS_wait
     e0c:	488d                	li	a7,3
 ecall
     e0e:	00000073          	ecall
 ret
     e12:	8082                	ret

0000000000000e14 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e14:	4891                	li	a7,4
 ecall
     e16:	00000073          	ecall
 ret
     e1a:	8082                	ret

0000000000000e1c <read>:
.global read
read:
 li a7, SYS_read
     e1c:	4895                	li	a7,5
 ecall
     e1e:	00000073          	ecall
 ret
     e22:	8082                	ret

0000000000000e24 <write>:
.global write
write:
 li a7, SYS_write
     e24:	48c1                	li	a7,16
 ecall
     e26:	00000073          	ecall
 ret
     e2a:	8082                	ret

0000000000000e2c <close>:
.global close
close:
 li a7, SYS_close
     e2c:	48d5                	li	a7,21
 ecall
     e2e:	00000073          	ecall
 ret
     e32:	8082                	ret

0000000000000e34 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e34:	4899                	li	a7,6
 ecall
     e36:	00000073          	ecall
 ret
     e3a:	8082                	ret

0000000000000e3c <exec>:
.global exec
exec:
 li a7, SYS_exec
     e3c:	489d                	li	a7,7
 ecall
     e3e:	00000073          	ecall
 ret
     e42:	8082                	ret

0000000000000e44 <open>:
.global open
open:
 li a7, SYS_open
     e44:	48bd                	li	a7,15
 ecall
     e46:	00000073          	ecall
 ret
     e4a:	8082                	ret

0000000000000e4c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e4c:	48c5                	li	a7,17
 ecall
     e4e:	00000073          	ecall
 ret
     e52:	8082                	ret

0000000000000e54 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e54:	48c9                	li	a7,18
 ecall
     e56:	00000073          	ecall
 ret
     e5a:	8082                	ret

0000000000000e5c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e5c:	48a1                	li	a7,8
 ecall
     e5e:	00000073          	ecall
 ret
     e62:	8082                	ret

0000000000000e64 <link>:
.global link
link:
 li a7, SYS_link
     e64:	48cd                	li	a7,19
 ecall
     e66:	00000073          	ecall
 ret
     e6a:	8082                	ret

0000000000000e6c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e6c:	48d1                	li	a7,20
 ecall
     e6e:	00000073          	ecall
 ret
     e72:	8082                	ret

0000000000000e74 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e74:	48a5                	li	a7,9
 ecall
     e76:	00000073          	ecall
 ret
     e7a:	8082                	ret

0000000000000e7c <dup>:
.global dup
dup:
 li a7, SYS_dup
     e7c:	48a9                	li	a7,10
 ecall
     e7e:	00000073          	ecall
 ret
     e82:	8082                	ret

0000000000000e84 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e84:	48ad                	li	a7,11
 ecall
     e86:	00000073          	ecall
 ret
     e8a:	8082                	ret

0000000000000e8c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e8c:	48b1                	li	a7,12
 ecall
     e8e:	00000073          	ecall
 ret
     e92:	8082                	ret

0000000000000e94 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e94:	48b5                	li	a7,13
 ecall
     e96:	00000073          	ecall
 ret
     e9a:	8082                	ret

0000000000000e9c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e9c:	48b9                	li	a7,14
 ecall
     e9e:	00000073          	ecall
 ret
     ea2:	8082                	ret

0000000000000ea4 <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
     ea4:	48d9                	li	a7,22
 ecall
     ea6:	00000073          	ecall
 ret
     eaa:	8082                	ret

0000000000000eac <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
     eac:	48dd                	li	a7,23
 ecall
     eae:	00000073          	ecall
 ret
     eb2:	8082                	ret

0000000000000eb4 <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
     eb4:	48e1                	li	a7,24
 ecall
     eb6:	00000073          	ecall
 ret
     eba:	8082                	ret

0000000000000ebc <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
     ebc:	48ed                	li	a7,27
 ecall
     ebe:	00000073          	ecall
 ret
     ec2:	8082                	ret

0000000000000ec4 <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
     ec4:	48f1                	li	a7,28
 ecall
     ec6:	00000073          	ecall
 ret
     eca:	8082                	ret

0000000000000ecc <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
     ecc:	48e9                	li	a7,26
 ecall
     ece:	00000073          	ecall
 ret
     ed2:	8082                	ret

0000000000000ed4 <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
     ed4:	48e5                	li	a7,25
 ecall
     ed6:	00000073          	ecall
 ret
     eda:	8082                	ret

0000000000000edc <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
     edc:	48f5                	li	a7,29
 ecall
     ede:	00000073          	ecall
 ret
     ee2:	8082                	ret

0000000000000ee4 <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
     ee4:	48f9                	li	a7,30
 ecall
     ee6:	00000073          	ecall
 ret
     eea:	8082                	ret

0000000000000eec <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
     eec:	48fd                	li	a7,31
 ecall
     eee:	00000073          	ecall
 ret
     ef2:	8082                	ret

0000000000000ef4 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
     ef4:	02000893          	li	a7,32
 ecall
     ef8:	00000073          	ecall
 ret
     efc:	8082                	ret

0000000000000efe <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     efe:	1101                	addi	sp,sp,-32
     f00:	ec06                	sd	ra,24(sp)
     f02:	e822                	sd	s0,16(sp)
     f04:	1000                	addi	s0,sp,32
     f06:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f0a:	4605                	li	a2,1
     f0c:	fef40593          	addi	a1,s0,-17
     f10:	00000097          	auipc	ra,0x0
     f14:	f14080e7          	jalr	-236(ra) # e24 <write>
}
     f18:	60e2                	ld	ra,24(sp)
     f1a:	6442                	ld	s0,16(sp)
     f1c:	6105                	addi	sp,sp,32
     f1e:	8082                	ret

0000000000000f20 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f20:	7139                	addi	sp,sp,-64
     f22:	fc06                	sd	ra,56(sp)
     f24:	f822                	sd	s0,48(sp)
     f26:	f426                	sd	s1,40(sp)
     f28:	f04a                	sd	s2,32(sp)
     f2a:	ec4e                	sd	s3,24(sp)
     f2c:	0080                	addi	s0,sp,64
     f2e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f30:	c299                	beqz	a3,f36 <printint+0x16>
     f32:	0805c863          	bltz	a1,fc2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f36:	2581                	sext.w	a1,a1
  neg = 0;
     f38:	4881                	li	a7,0
     f3a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     f3e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f40:	2601                	sext.w	a2,a2
     f42:	00001517          	auipc	a0,0x1
     f46:	9ae50513          	addi	a0,a0,-1618 # 18f0 <digits>
     f4a:	883a                	mv	a6,a4
     f4c:	2705                	addiw	a4,a4,1
     f4e:	02c5f7bb          	remuw	a5,a1,a2
     f52:	1782                	slli	a5,a5,0x20
     f54:	9381                	srli	a5,a5,0x20
     f56:	97aa                	add	a5,a5,a0
     f58:	0007c783          	lbu	a5,0(a5)
     f5c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f60:	0005879b          	sext.w	a5,a1
     f64:	02c5d5bb          	divuw	a1,a1,a2
     f68:	0685                	addi	a3,a3,1
     f6a:	fec7f0e3          	bgeu	a5,a2,f4a <printint+0x2a>
  if(neg)
     f6e:	00088b63          	beqz	a7,f84 <printint+0x64>
    buf[i++] = '-';
     f72:	fd040793          	addi	a5,s0,-48
     f76:	973e                	add	a4,a4,a5
     f78:	02d00793          	li	a5,45
     f7c:	fef70823          	sb	a5,-16(a4)
     f80:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f84:	02e05863          	blez	a4,fb4 <printint+0x94>
     f88:	fc040793          	addi	a5,s0,-64
     f8c:	00e78933          	add	s2,a5,a4
     f90:	fff78993          	addi	s3,a5,-1
     f94:	99ba                	add	s3,s3,a4
     f96:	377d                	addiw	a4,a4,-1
     f98:	1702                	slli	a4,a4,0x20
     f9a:	9301                	srli	a4,a4,0x20
     f9c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     fa0:	fff94583          	lbu	a1,-1(s2)
     fa4:	8526                	mv	a0,s1
     fa6:	00000097          	auipc	ra,0x0
     faa:	f58080e7          	jalr	-168(ra) # efe <putc>
  while(--i >= 0)
     fae:	197d                	addi	s2,s2,-1
     fb0:	ff3918e3          	bne	s2,s3,fa0 <printint+0x80>
}
     fb4:	70e2                	ld	ra,56(sp)
     fb6:	7442                	ld	s0,48(sp)
     fb8:	74a2                	ld	s1,40(sp)
     fba:	7902                	ld	s2,32(sp)
     fbc:	69e2                	ld	s3,24(sp)
     fbe:	6121                	addi	sp,sp,64
     fc0:	8082                	ret
    x = -xx;
     fc2:	40b005bb          	negw	a1,a1
    neg = 1;
     fc6:	4885                	li	a7,1
    x = -xx;
     fc8:	bf8d                	j	f3a <printint+0x1a>

0000000000000fca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     fca:	7119                	addi	sp,sp,-128
     fcc:	fc86                	sd	ra,120(sp)
     fce:	f8a2                	sd	s0,112(sp)
     fd0:	f4a6                	sd	s1,104(sp)
     fd2:	f0ca                	sd	s2,96(sp)
     fd4:	ecce                	sd	s3,88(sp)
     fd6:	e8d2                	sd	s4,80(sp)
     fd8:	e4d6                	sd	s5,72(sp)
     fda:	e0da                	sd	s6,64(sp)
     fdc:	fc5e                	sd	s7,56(sp)
     fde:	f862                	sd	s8,48(sp)
     fe0:	f466                	sd	s9,40(sp)
     fe2:	f06a                	sd	s10,32(sp)
     fe4:	ec6e                	sd	s11,24(sp)
     fe6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     fe8:	0005c903          	lbu	s2,0(a1)
     fec:	18090f63          	beqz	s2,118a <vprintf+0x1c0>
     ff0:	8aaa                	mv	s5,a0
     ff2:	8b32                	mv	s6,a2
     ff4:	00158493          	addi	s1,a1,1
  state = 0;
     ff8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ffa:	02500a13          	li	s4,37
      if(c == 'd'){
     ffe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    1002:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    1006:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    100a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    100e:	00001b97          	auipc	s7,0x1
    1012:	8e2b8b93          	addi	s7,s7,-1822 # 18f0 <digits>
    1016:	a839                	j	1034 <vprintf+0x6a>
        putc(fd, c);
    1018:	85ca                	mv	a1,s2
    101a:	8556                	mv	a0,s5
    101c:	00000097          	auipc	ra,0x0
    1020:	ee2080e7          	jalr	-286(ra) # efe <putc>
    1024:	a019                	j	102a <vprintf+0x60>
    } else if(state == '%'){
    1026:	01498f63          	beq	s3,s4,1044 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    102a:	0485                	addi	s1,s1,1
    102c:	fff4c903          	lbu	s2,-1(s1)
    1030:	14090d63          	beqz	s2,118a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    1034:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1038:	fe0997e3          	bnez	s3,1026 <vprintf+0x5c>
      if(c == '%'){
    103c:	fd479ee3          	bne	a5,s4,1018 <vprintf+0x4e>
        state = '%';
    1040:	89be                	mv	s3,a5
    1042:	b7e5                	j	102a <vprintf+0x60>
      if(c == 'd'){
    1044:	05878063          	beq	a5,s8,1084 <vprintf+0xba>
      } else if(c == 'l') {
    1048:	05978c63          	beq	a5,s9,10a0 <vprintf+0xd6>
      } else if(c == 'x') {
    104c:	07a78863          	beq	a5,s10,10bc <vprintf+0xf2>
      } else if(c == 'p') {
    1050:	09b78463          	beq	a5,s11,10d8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    1054:	07300713          	li	a4,115
    1058:	0ce78663          	beq	a5,a4,1124 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    105c:	06300713          	li	a4,99
    1060:	0ee78e63          	beq	a5,a4,115c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    1064:	11478863          	beq	a5,s4,1174 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1068:	85d2                	mv	a1,s4
    106a:	8556                	mv	a0,s5
    106c:	00000097          	auipc	ra,0x0
    1070:	e92080e7          	jalr	-366(ra) # efe <putc>
        putc(fd, c);
    1074:	85ca                	mv	a1,s2
    1076:	8556                	mv	a0,s5
    1078:	00000097          	auipc	ra,0x0
    107c:	e86080e7          	jalr	-378(ra) # efe <putc>
      }
      state = 0;
    1080:	4981                	li	s3,0
    1082:	b765                	j	102a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    1084:	008b0913          	addi	s2,s6,8
    1088:	4685                	li	a3,1
    108a:	4629                	li	a2,10
    108c:	000b2583          	lw	a1,0(s6)
    1090:	8556                	mv	a0,s5
    1092:	00000097          	auipc	ra,0x0
    1096:	e8e080e7          	jalr	-370(ra) # f20 <printint>
    109a:	8b4a                	mv	s6,s2
      state = 0;
    109c:	4981                	li	s3,0
    109e:	b771                	j	102a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    10a0:	008b0913          	addi	s2,s6,8
    10a4:	4681                	li	a3,0
    10a6:	4629                	li	a2,10
    10a8:	000b2583          	lw	a1,0(s6)
    10ac:	8556                	mv	a0,s5
    10ae:	00000097          	auipc	ra,0x0
    10b2:	e72080e7          	jalr	-398(ra) # f20 <printint>
    10b6:	8b4a                	mv	s6,s2
      state = 0;
    10b8:	4981                	li	s3,0
    10ba:	bf85                	j	102a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    10bc:	008b0913          	addi	s2,s6,8
    10c0:	4681                	li	a3,0
    10c2:	4641                	li	a2,16
    10c4:	000b2583          	lw	a1,0(s6)
    10c8:	8556                	mv	a0,s5
    10ca:	00000097          	auipc	ra,0x0
    10ce:	e56080e7          	jalr	-426(ra) # f20 <printint>
    10d2:	8b4a                	mv	s6,s2
      state = 0;
    10d4:	4981                	li	s3,0
    10d6:	bf91                	j	102a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    10d8:	008b0793          	addi	a5,s6,8
    10dc:	f8f43423          	sd	a5,-120(s0)
    10e0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    10e4:	03000593          	li	a1,48
    10e8:	8556                	mv	a0,s5
    10ea:	00000097          	auipc	ra,0x0
    10ee:	e14080e7          	jalr	-492(ra) # efe <putc>
  putc(fd, 'x');
    10f2:	85ea                	mv	a1,s10
    10f4:	8556                	mv	a0,s5
    10f6:	00000097          	auipc	ra,0x0
    10fa:	e08080e7          	jalr	-504(ra) # efe <putc>
    10fe:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1100:	03c9d793          	srli	a5,s3,0x3c
    1104:	97de                	add	a5,a5,s7
    1106:	0007c583          	lbu	a1,0(a5)
    110a:	8556                	mv	a0,s5
    110c:	00000097          	auipc	ra,0x0
    1110:	df2080e7          	jalr	-526(ra) # efe <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1114:	0992                	slli	s3,s3,0x4
    1116:	397d                	addiw	s2,s2,-1
    1118:	fe0914e3          	bnez	s2,1100 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    111c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1120:	4981                	li	s3,0
    1122:	b721                	j	102a <vprintf+0x60>
        s = va_arg(ap, char*);
    1124:	008b0993          	addi	s3,s6,8
    1128:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    112c:	02090163          	beqz	s2,114e <vprintf+0x184>
        while(*s != 0){
    1130:	00094583          	lbu	a1,0(s2)
    1134:	c9a1                	beqz	a1,1184 <vprintf+0x1ba>
          putc(fd, *s);
    1136:	8556                	mv	a0,s5
    1138:	00000097          	auipc	ra,0x0
    113c:	dc6080e7          	jalr	-570(ra) # efe <putc>
          s++;
    1140:	0905                	addi	s2,s2,1
        while(*s != 0){
    1142:	00094583          	lbu	a1,0(s2)
    1146:	f9e5                	bnez	a1,1136 <vprintf+0x16c>
        s = va_arg(ap, char*);
    1148:	8b4e                	mv	s6,s3
      state = 0;
    114a:	4981                	li	s3,0
    114c:	bdf9                	j	102a <vprintf+0x60>
          s = "(null)";
    114e:	00000917          	auipc	s2,0x0
    1152:	79a90913          	addi	s2,s2,1946 # 18e8 <malloc+0x654>
        while(*s != 0){
    1156:	02800593          	li	a1,40
    115a:	bff1                	j	1136 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    115c:	008b0913          	addi	s2,s6,8
    1160:	000b4583          	lbu	a1,0(s6)
    1164:	8556                	mv	a0,s5
    1166:	00000097          	auipc	ra,0x0
    116a:	d98080e7          	jalr	-616(ra) # efe <putc>
    116e:	8b4a                	mv	s6,s2
      state = 0;
    1170:	4981                	li	s3,0
    1172:	bd65                	j	102a <vprintf+0x60>
        putc(fd, c);
    1174:	85d2                	mv	a1,s4
    1176:	8556                	mv	a0,s5
    1178:	00000097          	auipc	ra,0x0
    117c:	d86080e7          	jalr	-634(ra) # efe <putc>
      state = 0;
    1180:	4981                	li	s3,0
    1182:	b565                	j	102a <vprintf+0x60>
        s = va_arg(ap, char*);
    1184:	8b4e                	mv	s6,s3
      state = 0;
    1186:	4981                	li	s3,0
    1188:	b54d                	j	102a <vprintf+0x60>
    }
  }
}
    118a:	70e6                	ld	ra,120(sp)
    118c:	7446                	ld	s0,112(sp)
    118e:	74a6                	ld	s1,104(sp)
    1190:	7906                	ld	s2,96(sp)
    1192:	69e6                	ld	s3,88(sp)
    1194:	6a46                	ld	s4,80(sp)
    1196:	6aa6                	ld	s5,72(sp)
    1198:	6b06                	ld	s6,64(sp)
    119a:	7be2                	ld	s7,56(sp)
    119c:	7c42                	ld	s8,48(sp)
    119e:	7ca2                	ld	s9,40(sp)
    11a0:	7d02                	ld	s10,32(sp)
    11a2:	6de2                	ld	s11,24(sp)
    11a4:	6109                	addi	sp,sp,128
    11a6:	8082                	ret

00000000000011a8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    11a8:	715d                	addi	sp,sp,-80
    11aa:	ec06                	sd	ra,24(sp)
    11ac:	e822                	sd	s0,16(sp)
    11ae:	1000                	addi	s0,sp,32
    11b0:	e010                	sd	a2,0(s0)
    11b2:	e414                	sd	a3,8(s0)
    11b4:	e818                	sd	a4,16(s0)
    11b6:	ec1c                	sd	a5,24(s0)
    11b8:	03043023          	sd	a6,32(s0)
    11bc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    11c0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    11c4:	8622                	mv	a2,s0
    11c6:	00000097          	auipc	ra,0x0
    11ca:	e04080e7          	jalr	-508(ra) # fca <vprintf>
}
    11ce:	60e2                	ld	ra,24(sp)
    11d0:	6442                	ld	s0,16(sp)
    11d2:	6161                	addi	sp,sp,80
    11d4:	8082                	ret

00000000000011d6 <printf>:

void
printf(const char *fmt, ...)
{
    11d6:	711d                	addi	sp,sp,-96
    11d8:	ec06                	sd	ra,24(sp)
    11da:	e822                	sd	s0,16(sp)
    11dc:	1000                	addi	s0,sp,32
    11de:	e40c                	sd	a1,8(s0)
    11e0:	e810                	sd	a2,16(s0)
    11e2:	ec14                	sd	a3,24(s0)
    11e4:	f018                	sd	a4,32(s0)
    11e6:	f41c                	sd	a5,40(s0)
    11e8:	03043823          	sd	a6,48(s0)
    11ec:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11f0:	00840613          	addi	a2,s0,8
    11f4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11f8:	85aa                	mv	a1,a0
    11fa:	4505                	li	a0,1
    11fc:	00000097          	auipc	ra,0x0
    1200:	dce080e7          	jalr	-562(ra) # fca <vprintf>
}
    1204:	60e2                	ld	ra,24(sp)
    1206:	6442                	ld	s0,16(sp)
    1208:	6125                	addi	sp,sp,96
    120a:	8082                	ret

000000000000120c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    120c:	1141                	addi	sp,sp,-16
    120e:	e422                	sd	s0,8(sp)
    1210:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1212:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1216:	00000797          	auipc	a5,0x0
    121a:	6fa7b783          	ld	a5,1786(a5) # 1910 <freep>
    121e:	a805                	j	124e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1220:	4618                	lw	a4,8(a2)
    1222:	9db9                	addw	a1,a1,a4
    1224:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1228:	6398                	ld	a4,0(a5)
    122a:	6318                	ld	a4,0(a4)
    122c:	fee53823          	sd	a4,-16(a0)
    1230:	a091                	j	1274 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1232:	ff852703          	lw	a4,-8(a0)
    1236:	9e39                	addw	a2,a2,a4
    1238:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    123a:	ff053703          	ld	a4,-16(a0)
    123e:	e398                	sd	a4,0(a5)
    1240:	a099                	j	1286 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1242:	6398                	ld	a4,0(a5)
    1244:	00e7e463          	bltu	a5,a4,124c <free+0x40>
    1248:	00e6ea63          	bltu	a3,a4,125c <free+0x50>
{
    124c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    124e:	fed7fae3          	bgeu	a5,a3,1242 <free+0x36>
    1252:	6398                	ld	a4,0(a5)
    1254:	00e6e463          	bltu	a3,a4,125c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1258:	fee7eae3          	bltu	a5,a4,124c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    125c:	ff852583          	lw	a1,-8(a0)
    1260:	6390                	ld	a2,0(a5)
    1262:	02059813          	slli	a6,a1,0x20
    1266:	01c85713          	srli	a4,a6,0x1c
    126a:	9736                	add	a4,a4,a3
    126c:	fae60ae3          	beq	a2,a4,1220 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1270:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1274:	4790                	lw	a2,8(a5)
    1276:	02061593          	slli	a1,a2,0x20
    127a:	01c5d713          	srli	a4,a1,0x1c
    127e:	973e                	add	a4,a4,a5
    1280:	fae689e3          	beq	a3,a4,1232 <free+0x26>
  } else
    p->s.ptr = bp;
    1284:	e394                	sd	a3,0(a5)
  freep = p;
    1286:	00000717          	auipc	a4,0x0
    128a:	68f73523          	sd	a5,1674(a4) # 1910 <freep>
}
    128e:	6422                	ld	s0,8(sp)
    1290:	0141                	addi	sp,sp,16
    1292:	8082                	ret

0000000000001294 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1294:	7139                	addi	sp,sp,-64
    1296:	fc06                	sd	ra,56(sp)
    1298:	f822                	sd	s0,48(sp)
    129a:	f426                	sd	s1,40(sp)
    129c:	f04a                	sd	s2,32(sp)
    129e:	ec4e                	sd	s3,24(sp)
    12a0:	e852                	sd	s4,16(sp)
    12a2:	e456                	sd	s5,8(sp)
    12a4:	e05a                	sd	s6,0(sp)
    12a6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12a8:	02051493          	slli	s1,a0,0x20
    12ac:	9081                	srli	s1,s1,0x20
    12ae:	04bd                	addi	s1,s1,15
    12b0:	8091                	srli	s1,s1,0x4
    12b2:	0014899b          	addiw	s3,s1,1
    12b6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    12b8:	00000517          	auipc	a0,0x0
    12bc:	65853503          	ld	a0,1624(a0) # 1910 <freep>
    12c0:	c515                	beqz	a0,12ec <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12c4:	4798                	lw	a4,8(a5)
    12c6:	02977f63          	bgeu	a4,s1,1304 <malloc+0x70>
    12ca:	8a4e                	mv	s4,s3
    12cc:	0009871b          	sext.w	a4,s3
    12d0:	6685                	lui	a3,0x1
    12d2:	00d77363          	bgeu	a4,a3,12d8 <malloc+0x44>
    12d6:	6a05                	lui	s4,0x1
    12d8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    12dc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    12e0:	00000917          	auipc	s2,0x0
    12e4:	63090913          	addi	s2,s2,1584 # 1910 <freep>
  if(p == (char*)-1)
    12e8:	5afd                	li	s5,-1
    12ea:	a895                	j	135e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    12ec:	00000797          	auipc	a5,0x0
    12f0:	62c78793          	addi	a5,a5,1580 # 1918 <base>
    12f4:	00000717          	auipc	a4,0x0
    12f8:	60f73e23          	sd	a5,1564(a4) # 1910 <freep>
    12fc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12fe:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1302:	b7e1                	j	12ca <malloc+0x36>
      if(p->s.size == nunits)
    1304:	02e48c63          	beq	s1,a4,133c <malloc+0xa8>
        p->s.size -= nunits;
    1308:	4137073b          	subw	a4,a4,s3
    130c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    130e:	02071693          	slli	a3,a4,0x20
    1312:	01c6d713          	srli	a4,a3,0x1c
    1316:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1318:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    131c:	00000717          	auipc	a4,0x0
    1320:	5ea73a23          	sd	a0,1524(a4) # 1910 <freep>
      return (void*)(p + 1);
    1324:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1328:	70e2                	ld	ra,56(sp)
    132a:	7442                	ld	s0,48(sp)
    132c:	74a2                	ld	s1,40(sp)
    132e:	7902                	ld	s2,32(sp)
    1330:	69e2                	ld	s3,24(sp)
    1332:	6a42                	ld	s4,16(sp)
    1334:	6aa2                	ld	s5,8(sp)
    1336:	6b02                	ld	s6,0(sp)
    1338:	6121                	addi	sp,sp,64
    133a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    133c:	6398                	ld	a4,0(a5)
    133e:	e118                	sd	a4,0(a0)
    1340:	bff1                	j	131c <malloc+0x88>
  hp->s.size = nu;
    1342:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1346:	0541                	addi	a0,a0,16
    1348:	00000097          	auipc	ra,0x0
    134c:	ec4080e7          	jalr	-316(ra) # 120c <free>
  return freep;
    1350:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1354:	d971                	beqz	a0,1328 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1356:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1358:	4798                	lw	a4,8(a5)
    135a:	fa9775e3          	bgeu	a4,s1,1304 <malloc+0x70>
    if(p == freep)
    135e:	00093703          	ld	a4,0(s2)
    1362:	853e                	mv	a0,a5
    1364:	fef719e3          	bne	a4,a5,1356 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    1368:	8552                	mv	a0,s4
    136a:	00000097          	auipc	ra,0x0
    136e:	b22080e7          	jalr	-1246(ra) # e8c <sbrk>
  if(p == (char*)-1)
    1372:	fd5518e3          	bne	a0,s5,1342 <malloc+0xae>
        return 0;
    1376:	4501                	li	a0,0
    1378:	bf45                	j	1328 <malloc+0x94>
