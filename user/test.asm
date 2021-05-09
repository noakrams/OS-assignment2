
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
       e:	90a7a523          	sw	a0,-1782(a5) # 1914 <flag>
    printf("handle -> signum: %d\n", signum);
      12:	00001517          	auipc	a0,0x1
      16:	37650513          	addi	a0,a0,886 # 1388 <csem_free+0x38>
      1a:	00001097          	auipc	ra,0x1
      1e:	0a0080e7          	jalr	160(ra) # 10ba <printf>
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
      38:	8ea7a023          	sw	a0,-1824(a5) # 1914 <flag>
    printf("handle2 -> signum: %d\n", signum);
      3c:	00001517          	auipc	a0,0x1
      40:	36450513          	addi	a0,a0,868 # 13a0 <csem_free+0x50>
      44:	00001097          	auipc	ra,0x1
      48:	076080e7          	jalr	118(ra) # 10ba <printf>
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
      64:	8aa7aa23          	sw	a0,-1868(a5) # 1914 <flag>
    printf("in handle3, flag = %d\n", flag);
      68:	85aa                	mv	a1,a0
      6a:	00001517          	auipc	a0,0x1
      6e:	34e50513          	addi	a0,a0,846 # 13b8 <csem_free+0x68>
      72:	00001097          	auipc	ra,0x1
      76:	048080e7          	jalr	72(ra) # 10ba <printf>
    printf("handle3 -> signum: %d\n", signum);
      7a:	85a6                	mv	a1,s1
      7c:	00001517          	auipc	a0,0x1
      80:	35450513          	addi	a0,a0,852 # 13d0 <csem_free+0x80>
      84:	00001097          	auipc	ra,0x1
      88:	036080e7          	jalr	54(ra) # 10ba <printf>
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
      a4:	86f72823          	sw	a5,-1936(a4) # 1910 <wait_sig>
    printf("Received sigtest\n");
      a8:	00001517          	auipc	a0,0x1
      ac:	34050513          	addi	a0,a0,832 # 13e8 <csem_free+0x98>
      b0:	00001097          	auipc	ra,0x1
      b4:	00a080e7          	jalr	10(ra) # 10ba <printf>
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
      cc:	33858593          	addi	a1,a1,824 # 1400 <csem_free+0xb0>
      d0:	4509                	li	a0,2
      d2:	00001097          	auipc	ra,0x1
      d6:	fba080e7          	jalr	-70(ra) # 108c <fprintf>
  int x = kthread_id();
      da:	00001097          	auipc	ra,0x1
      de:	cee080e7          	jalr	-786(ra) # dc8 <kthread_id>
      e2:	862a                	mv	a2,a0
  fprintf(2, "thread_id is: %d\n", x);
      e4:	00001597          	auipc	a1,0x1
      e8:	33c58593          	addi	a1,a1,828 # 1420 <csem_free+0xd0>
      ec:	4509                	li	a0,2
      ee:	00001097          	auipc	ra,0x1
      f2:	f9e080e7          	jalr	-98(ra) # 108c <fprintf>
  fprintf(2, "finished kthread_id test\n");
      f6:	00001597          	auipc	a1,0x1
      fa:	34258593          	addi	a1,a1,834 # 1438 <csem_free+0xe8>
      fe:	4509                	li	a0,2
     100:	00001097          	auipc	ra,0x1
     104:	f8c080e7          	jalr	-116(ra) # 108c <fprintf>
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
     11e:	bc6080e7          	jalr	-1082(ra) # ce0 <fork>
  if(cpid == 0){
     122:	e111                	bnez	a0,126 <sigkillTest+0x16>
    while(1);
     124:	a001                	j	124 <sigkillTest+0x14>
     126:	84aa                	mv	s1,a0
    sleep(50);
     128:	03200513          	li	a0,50
     12c:	00001097          	auipc	ra,0x1
     130:	c4c080e7          	jalr	-948(ra) # d78 <sleep>
    kill(cpid, SIGKILL);
     134:	45a5                	li	a1,9
     136:	8526                	mv	a0,s1
     138:	00001097          	auipc	ra,0x1
     13c:	be0080e7          	jalr	-1056(ra) # d18 <kill>
  printf("sigkillTest OK\n");
     140:	00001517          	auipc	a0,0x1
     144:	31850513          	addi	a0,a0,792 # 1458 <csem_free+0x108>
     148:	00001097          	auipc	ra,0x1
     14c:	f72080e7          	jalr	-142(ra) # 10ba <printf>
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
     168:	b7c080e7          	jalr	-1156(ra) # ce0 <fork>
  if(cpid == 0){
     16c:	e111                	bnez	a0,170 <killwdiffSignum+0x16>
    while(1);
     16e:	a001                	j	16e <killwdiffSignum+0x14>
     170:	84aa                	mv	s1,a0
    sleep(50);
     172:	03200513          	li	a0,50
     176:	00001097          	auipc	ra,0x1
     17a:	c02080e7          	jalr	-1022(ra) # d78 <sleep>
    kill(cpid, 15);
     17e:	45bd                	li	a1,15
     180:	8526                	mv	a0,s1
     182:	00001097          	auipc	ra,0x1
     186:	b96080e7          	jalr	-1130(ra) # d18 <kill>
  printf("kill with another signum test OK\n");
     18a:	00001517          	auipc	a0,0x1
     18e:	2de50513          	addi	a0,a0,734 # 1468 <csem_free+0x118>
     192:	00001097          	auipc	ra,0x1
     196:	f28080e7          	jalr	-216(ra) # 10ba <printf>
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
     1ba:	fc2080e7          	jalr	-62(ra) # 1178 <malloc>
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
     1d4:	fa8080e7          	jalr	-88(ra) # 1178 <malloc>
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
     1ee:	f8e080e7          	jalr	-114(ra) # 1178 <malloc>
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
     20e:	b86080e7          	jalr	-1146(ra) # d90 <sigaction>
  sigaction(2, act2, 0);
     212:	4601                	li	a2,0
     214:	85ca                	mv	a1,s2
     216:	4509                	li	a0,2
     218:	00001097          	auipc	ra,0x1
     21c:	b78080e7          	jalr	-1160(ra) # d90 <sigaction>
  int ret3 = sigaction(7, act3, 0);
     220:	4601                	li	a2,0
     222:	85a6                	mv	a1,s1
     224:	451d                	li	a0,7
     226:	00001097          	auipc	ra,0x1
     22a:	b6a080e7          	jalr	-1174(ra) # d90 <sigaction>
     22e:	85aa                	mv	a1,a0
  printf("ret3 = %d\n", ret3);
     230:	00001517          	auipc	a0,0x1
     234:	26050513          	addi	a0,a0,608 # 1490 <csem_free+0x140>
     238:	00001097          	auipc	ra,0x1
     23c:	e82080e7          	jalr	-382(ra) # 10ba <printf>
   printf("The address of the function handle3 is =%p\n",handle3);
     240:	85d2                	mv	a1,s4
     242:	00001517          	auipc	a0,0x1
     246:	25e50513          	addi	a0,a0,606 # 14a0 <csem_free+0x150>
     24a:	00001097          	auipc	ra,0x1
     24e:	e70080e7          	jalr	-400(ra) # 10ba <printf>
  int cpid = fork();
     252:	00001097          	auipc	ra,0x1
     256:	a8e080e7          	jalr	-1394(ra) # ce0 <fork>
  if(cpid == 0){
     25a:	e505                	bnez	a0,282 <testSigactionHandler1+0xde>
      if(flag == 7){
     25c:	00001997          	auipc	s3,0x1
     260:	6b898993          	addi	s3,s3,1720 # 1914 <flag>
     264:	449d                	li	s1,7
        printf("successfully recieved signal\n");
     266:	00001917          	auipc	s2,0x1
     26a:	26a90913          	addi	s2,s2,618 # 14d0 <csem_free+0x180>
      if(flag == 7){
     26e:	0009a783          	lw	a5,0(s3)
     272:	00979063          	bne	a5,s1,272 <testSigactionHandler1+0xce>
        printf("successfully recieved signal\n");
     276:	854a                	mv	a0,s2
     278:	00001097          	auipc	ra,0x1
     27c:	e42080e7          	jalr	-446(ra) # 10ba <printf>
     280:	b7fd                	j	26e <testSigactionHandler1+0xca>
     282:	84aa                	mv	s1,a0
    sleep(100);
     284:	06400513          	li	a0,100
     288:	00001097          	auipc	ra,0x1
     28c:	af0080e7          	jalr	-1296(ra) # d78 <sleep>
    printf( "sending signal %d\n" , 7);
     290:	459d                	li	a1,7
     292:	00001517          	auipc	a0,0x1
     296:	25e50513          	addi	a0,a0,606 # 14f0 <csem_free+0x1a0>
     29a:	00001097          	auipc	ra,0x1
     29e:	e20080e7          	jalr	-480(ra) # 10ba <printf>
    kill(cpid, 7);
     2a2:	459d                	li	a1,7
     2a4:	8526                	mv	a0,s1
     2a6:	00001097          	auipc	ra,0x1
     2aa:	a72080e7          	jalr	-1422(ra) # d18 <kill>
    sleep(100);
     2ae:	06400513          	li	a0,100
     2b2:	00001097          	auipc	ra,0x1
     2b6:	ac6080e7          	jalr	-1338(ra) # d78 <sleep>
    kill(cpid, SIGKILL);
     2ba:	45a5                	li	a1,9
     2bc:	8526                	mv	a0,s1
     2be:	00001097          	auipc	ra,0x1
     2c2:	a5a080e7          	jalr	-1446(ra) # d18 <kill>
  wait(0);
     2c6:	4501                	li	a0,0
     2c8:	00001097          	auipc	ra,0x1
     2cc:	a28080e7          	jalr	-1496(ra) # cf0 <wait>
  printf("custom sig test OK\n");
     2d0:	00001517          	auipc	a0,0x1
     2d4:	23850513          	addi	a0,a0,568 # 1508 <csem_free+0x1b8>
     2d8:	00001097          	auipc	ra,0x1
     2dc:	de2080e7          	jalr	-542(ra) # 10ba <printf>
  flag = 0;
     2e0:	00001797          	auipc	a5,0x1
     2e4:	6207aa23          	sw	zero,1588(a5) # 1914 <flag>
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
     306:	9de080e7          	jalr	-1570(ra) # ce0 <fork>
  if(cpid == 0){
     30a:	e519                	bnez	a0,318 <testContStopCont+0x20>
      sleep(10);
     30c:	4529                	li	a0,10
     30e:	00001097          	auipc	ra,0x1
     312:	a6a080e7          	jalr	-1430(ra) # d78 <sleep>
    while(1){
     316:	bfdd                	j	30c <testContStopCont+0x14>
     318:	84aa                	mv	s1,a0
    sleep(20);
     31a:	4551                	li	a0,20
     31c:	00001097          	auipc	ra,0x1
     320:	a5c080e7          	jalr	-1444(ra) # d78 <sleep>
    printf("sending cont\n");
     324:	00001517          	auipc	a0,0x1
     328:	1fc50513          	addi	a0,a0,508 # 1520 <csem_free+0x1d0>
     32c:	00001097          	auipc	ra,0x1
     330:	d8e080e7          	jalr	-626(ra) # 10ba <printf>
    kill(cpid, SIGCONT);
     334:	45cd                	li	a1,19
     336:	8526                	mv	a0,s1
     338:	00001097          	auipc	ra,0x1
     33c:	9e0080e7          	jalr	-1568(ra) # d18 <kill>
    sleep(20);
     340:	4551                	li	a0,20
     342:	00001097          	auipc	ra,0x1
     346:	a36080e7          	jalr	-1482(ra) # d78 <sleep>
    printf("sending stop\n");
     34a:	00001517          	auipc	a0,0x1
     34e:	1e650513          	addi	a0,a0,486 # 1530 <csem_free+0x1e0>
     352:	00001097          	auipc	ra,0x1
     356:	d68080e7          	jalr	-664(ra) # 10ba <printf>
    kill(cpid, SIGSTOP);
     35a:	45c5                	li	a1,17
     35c:	8526                	mv	a0,s1
     35e:	00001097          	auipc	ra,0x1
     362:	9ba080e7          	jalr	-1606(ra) # d18 <kill>
    sleep(20);
     366:	4551                	li	a0,20
     368:	00001097          	auipc	ra,0x1
     36c:	a10080e7          	jalr	-1520(ra) # d78 <sleep>
    printf("sending cont\n");
     370:	00001517          	auipc	a0,0x1
     374:	1b050513          	addi	a0,a0,432 # 1520 <csem_free+0x1d0>
     378:	00001097          	auipc	ra,0x1
     37c:	d42080e7          	jalr	-702(ra) # 10ba <printf>
    kill(cpid, SIGCONT);
     380:	45cd                	li	a1,19
     382:	8526                	mv	a0,s1
     384:	00001097          	auipc	ra,0x1
     388:	994080e7          	jalr	-1644(ra) # d18 <kill>
    sleep(20);
     38c:	4551                	li	a0,20
     38e:	00001097          	auipc	ra,0x1
     392:	9ea080e7          	jalr	-1558(ra) # d78 <sleep>
    printf("killing\n");
     396:	00001517          	auipc	a0,0x1
     39a:	1aa50513          	addi	a0,a0,426 # 1540 <csem_free+0x1f0>
     39e:	00001097          	auipc	ra,0x1
     3a2:	d1c080e7          	jalr	-740(ra) # 10ba <printf>
    kill(cpid, SIGKILL);
     3a6:	45a5                	li	a1,9
     3a8:	8526                	mv	a0,s1
     3aa:	00001097          	auipc	ra,0x1
     3ae:	96e080e7          	jalr	-1682(ra) # d18 <kill>
  wait(0);
     3b2:	4501                	li	a0,0
     3b4:	00001097          	auipc	ra,0x1
     3b8:	93c080e7          	jalr	-1732(ra) # cf0 <wait>
  printf("testContStopCont OK\n");
     3bc:	00001517          	auipc	a0,0x1
     3c0:	19450513          	addi	a0,a0,404 # 1550 <csem_free+0x200>
     3c4:	00001097          	auipc	ra,0x1
     3c8:	cf6080e7          	jalr	-778(ra) # 10ba <printf>
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
     3e4:	900080e7          	jalr	-1792(ra) # ce0 <fork>
  if(cpid == 0){
     3e8:	e519                	bnez	a0,3f6 <testStopCont+0x20>
      sleep(10);
     3ea:	4529                	li	a0,10
     3ec:	00001097          	auipc	ra,0x1
     3f0:	98c080e7          	jalr	-1652(ra) # d78 <sleep>
    while(1){
     3f4:	bfdd                	j	3ea <testStopCont+0x14>
     3f6:	84aa                	mv	s1,a0
    sleep(20);
     3f8:	4551                	li	a0,20
     3fa:	00001097          	auipc	ra,0x1
     3fe:	97e080e7          	jalr	-1666(ra) # d78 <sleep>
    printf("send stop\n");
     402:	00001517          	auipc	a0,0x1
     406:	16650513          	addi	a0,a0,358 # 1568 <csem_free+0x218>
     40a:	00001097          	auipc	ra,0x1
     40e:	cb0080e7          	jalr	-848(ra) # 10ba <printf>
    kill(cpid, SIGSTOP);
     412:	45c5                	li	a1,17
     414:	8526                	mv	a0,s1
     416:	00001097          	auipc	ra,0x1
     41a:	902080e7          	jalr	-1790(ra) # d18 <kill>
    sleep(20);
     41e:	4551                	li	a0,20
     420:	00001097          	auipc	ra,0x1
     424:	958080e7          	jalr	-1704(ra) # d78 <sleep>
    printf("send cont\n");
     428:	00001517          	auipc	a0,0x1
     42c:	15050513          	addi	a0,a0,336 # 1578 <csem_free+0x228>
     430:	00001097          	auipc	ra,0x1
     434:	c8a080e7          	jalr	-886(ra) # 10ba <printf>
    kill(cpid, SIGCONT);
     438:	45cd                	li	a1,19
     43a:	8526                	mv	a0,s1
     43c:	00001097          	auipc	ra,0x1
     440:	8dc080e7          	jalr	-1828(ra) # d18 <kill>
    sleep(20);
     444:	4551                	li	a0,20
     446:	00001097          	auipc	ra,0x1
     44a:	932080e7          	jalr	-1742(ra) # d78 <sleep>
    printf("now to the killing\n");
     44e:	00001517          	auipc	a0,0x1
     452:	13a50513          	addi	a0,a0,314 # 1588 <csem_free+0x238>
     456:	00001097          	auipc	ra,0x1
     45a:	c64080e7          	jalr	-924(ra) # 10ba <printf>
    kill(cpid, SIGKILL);
     45e:	45a5                	li	a1,9
     460:	8526                	mv	a0,s1
     462:	00001097          	auipc	ra,0x1
     466:	8b6080e7          	jalr	-1866(ra) # d18 <kill>
  wait(0);
     46a:	4501                	li	a0,0
     46c:	00001097          	auipc	ra,0x1
     470:	884080e7          	jalr	-1916(ra) # cf0 <wait>
  printf("testStopCont OK\n");
     474:	00001517          	auipc	a0,0x1
     478:	12c50513          	addi	a0,a0,300 # 15a0 <csem_free+0x250>
     47c:	00001097          	auipc	ra,0x1
     480:	c3e080e7          	jalr	-962(ra) # 10ba <printf>
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
     4a2:	cda080e7          	jalr	-806(ra) # 1178 <malloc>
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
     4b8:	8dc080e7          	jalr	-1828(ra) # d90 <sigaction>
  int cpid = fork();
     4bc:	00001097          	auipc	ra,0x1
     4c0:	824080e7          	jalr	-2012(ra) # ce0 <fork>
  if(cpid == 0){
     4c4:	e505                	bnez	a0,4ec <testSigactionIGN+0x5e>
      if(flag == 5){
     4c6:	00001997          	auipc	s3,0x1
     4ca:	44e98993          	addi	s3,s3,1102 # 1914 <flag>
     4ce:	4495                	li	s1,5
        printf( "If you see me, that's not good\n");
     4d0:	00001917          	auipc	s2,0x1
     4d4:	0e890913          	addi	s2,s2,232 # 15b8 <csem_free+0x268>
      if(flag == 5){
     4d8:	0009a783          	lw	a5,0(s3)
     4dc:	00979063          	bne	a5,s1,4dc <testSigactionIGN+0x4e>
        printf( "If you see me, that's not good\n");
     4e0:	854a                	mv	a0,s2
     4e2:	00001097          	auipc	ra,0x1
     4e6:	bd8080e7          	jalr	-1064(ra) # 10ba <printf>
     4ea:	b7fd                	j	4d8 <testSigactionIGN+0x4a>
     4ec:	84aa                	mv	s1,a0
    sleep(10);
     4ee:	4529                	li	a0,10
     4f0:	00001097          	auipc	ra,0x1
     4f4:	888080e7          	jalr	-1912(ra) # d78 <sleep>
    printf( "send sigaction eith SIG_IGN\n");
     4f8:	00001517          	auipc	a0,0x1
     4fc:	0e050513          	addi	a0,a0,224 # 15d8 <csem_free+0x288>
     500:	00001097          	auipc	ra,0x1
     504:	bba080e7          	jalr	-1094(ra) # 10ba <printf>
    kill(cpid, 5);
     508:	4595                	li	a1,5
     50a:	8526                	mv	a0,s1
     50c:	00001097          	auipc	ra,0x1
     510:	80c080e7          	jalr	-2036(ra) # d18 <kill>
    sleep(10);
     514:	4529                	li	a0,10
     516:	00001097          	auipc	ra,0x1
     51a:	862080e7          	jalr	-1950(ra) # d78 <sleep>
    kill(cpid, SIGKILL);
     51e:	45a5                	li	a1,9
     520:	8526                	mv	a0,s1
     522:	00000097          	auipc	ra,0x0
     526:	7f6080e7          	jalr	2038(ra) # d18 <kill>
  wait(0);
     52a:	4501                	li	a0,0
     52c:	00000097          	auipc	ra,0x0
     530:	7c4080e7          	jalr	1988(ra) # cf0 <wait>
  printf("testSigactionIGN test OK\n");
     534:	00001517          	auipc	a0,0x1
     538:	0c450513          	addi	a0,a0,196 # 15f8 <csem_free+0x2a8>
     53c:	00001097          	auipc	ra,0x1
     540:	b7e080e7          	jalr	-1154(ra) # 10ba <printf>
  flag = 0;
     544:	00001797          	auipc	a5,0x1
     548:	3c07a823          	sw	zero,976(a5) # 1914 <flag>
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
     56e:	81e080e7          	jalr	-2018(ra) # d88 <sigprocmask>
  struct sigaction* act = malloc(sizeof(struct sigaction *));
     572:	4521                	li	a0,8
     574:	00001097          	auipc	ra,0x1
     578:	c04080e7          	jalr	-1020(ra) # 1178 <malloc>
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
     592:	bea080e7          	jalr	-1046(ra) # 1178 <malloc>
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
     5ac:	bd0080e7          	jalr	-1072(ra) # 1178 <malloc>
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
     5c6:	00000097          	auipc	ra,0x0
     5ca:	7ca080e7          	jalr	1994(ra) # d90 <sigaction>
  sigaction(2, act2, 0);
     5ce:	4601                	li	a2,0
     5d0:	85ca                	mv	a1,s2
     5d2:	4509                	li	a0,2
     5d4:	00000097          	auipc	ra,0x0
     5d8:	7bc080e7          	jalr	1980(ra) # d90 <sigaction>
  sigaction(7, act3, 0);
     5dc:	4601                	li	a2,0
     5de:	85a6                	mv	a1,s1
     5e0:	451d                	li	a0,7
     5e2:	00000097          	auipc	ra,0x0
     5e6:	7ae080e7          	jalr	1966(ra) # d90 <sigaction>
  int cpid = fork();
     5ea:	00000097          	auipc	ra,0x0
     5ee:	6f6080e7          	jalr	1782(ra) # ce0 <fork>
  if(cpid == 0){
     5f2:	e921                	bnez	a0,642 <testSigmAsk+0xe8>
      if(flag == 7){
     5f4:	00001717          	auipc	a4,0x1
     5f8:	32072703          	lw	a4,800(a4) # 1914 <flag>
     5fc:	479d                	li	a5,7
     5fe:	00f71063          	bne	a4,a5,5fe <testSigmAsk+0xa4>
        printf("Recieved flag\n");
     602:	00001517          	auipc	a0,0x1
     606:	01650513          	addi	a0,a0,22 # 1618 <csem_free+0x2c8>
     60a:	00001097          	auipc	ra,0x1
     60e:	ab0080e7          	jalr	-1360(ra) # 10ba <printf>
  wait(0);
     612:	4501                	li	a0,0
     614:	00000097          	auipc	ra,0x0
     618:	6dc080e7          	jalr	1756(ra) # cf0 <wait>
  printf( "sig mask test OK\n");
     61c:	00001517          	auipc	a0,0x1
     620:	02c50513          	addi	a0,a0,44 # 1648 <csem_free+0x2f8>
     624:	00001097          	auipc	ra,0x1
     628:	a96080e7          	jalr	-1386(ra) # 10ba <printf>
  flag = 0;
     62c:	00001797          	auipc	a5,0x1
     630:	2e07a423          	sw	zero,744(a5) # 1914 <flag>
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
     646:	00000097          	auipc	ra,0x0
     64a:	732080e7          	jalr	1842(ra) # d78 <sleep>
    printf("sending sigaction with handler\n");
     64e:	00001517          	auipc	a0,0x1
     652:	fda50513          	addi	a0,a0,-38 # 1628 <csem_free+0x2d8>
     656:	00001097          	auipc	ra,0x1
     65a:	a64080e7          	jalr	-1436(ra) # 10ba <printf>
    kill(cpid, 7);
     65e:	459d                	li	a1,7
     660:	8526                	mv	a0,s1
     662:	00000097          	auipc	ra,0x0
     666:	6b6080e7          	jalr	1718(ra) # d18 <kill>
    sleep(10);
     66a:	4529                	li	a0,10
     66c:	00000097          	auipc	ra,0x0
     670:	70c080e7          	jalr	1804(ra) # d78 <sleep>
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
     696:	00000097          	auipc	ra,0x0
     69a:	6f2080e7          	jalr	1778(ra) # d88 <sigprocmask>
    sigaction(testsig, &act, &old);
     69e:	fb840613          	addi	a2,s0,-72
     6a2:	fc840593          	addi	a1,s0,-56
     6a6:	453d                	li	a0,15
     6a8:	00000097          	auipc	ra,0x0
     6ac:	6e8080e7          	jalr	1768(ra) # d90 <sigaction>
    if((pid = fork()) == 0){
     6b0:	00000097          	auipc	ra,0x0
     6b4:	630080e7          	jalr	1584(ra) # ce0 <fork>
     6b8:	fca42e23          	sw	a0,-36(s0)
     6bc:	c90d                	beqz	a0,6ee <signal_test+0x78>
    kill(pid, testsig);
     6be:	45bd                	li	a1,15
     6c0:	00000097          	auipc	ra,0x0
     6c4:	658080e7          	jalr	1624(ra) # d18 <kill>
    wait(&pid);
     6c8:	fdc40513          	addi	a0,s0,-36
     6cc:	00000097          	auipc	ra,0x0
     6d0:	624080e7          	jalr	1572(ra) # cf0 <wait>
    printf("Finished testing signals\n");
     6d4:	00001517          	auipc	a0,0x1
     6d8:	f8c50513          	addi	a0,a0,-116 # 1660 <csem_free+0x310>
     6dc:	00001097          	auipc	ra,0x1
     6e0:	9de080e7          	jalr	-1570(ra) # 10ba <printf>
}
     6e4:	60a6                	ld	ra,72(sp)
     6e6:	6406                	ld	s0,64(sp)
     6e8:	74e2                	ld	s1,56(sp)
     6ea:	6161                	addi	sp,sp,80
     6ec:	8082                	ret
        while(!wait_sig)
     6ee:	00001797          	auipc	a5,0x1
     6f2:	2227a783          	lw	a5,546(a5) # 1910 <wait_sig>
     6f6:	ef81                	bnez	a5,70e <signal_test+0x98>
     6f8:	00001497          	auipc	s1,0x1
     6fc:	21848493          	addi	s1,s1,536 # 1910 <wait_sig>
            sleep(1);
     700:	4505                	li	a0,1
     702:	00000097          	auipc	ra,0x0
     706:	676080e7          	jalr	1654(ra) # d78 <sleep>
        while(!wait_sig)
     70a:	409c                	lw	a5,0(s1)
     70c:	dbf5                	beqz	a5,700 <signal_test+0x8a>
        exit(0);
     70e:	4501                	li	a0,0
     710:	00000097          	auipc	ra,0x0
     714:	5d8080e7          	jalr	1496(ra) # ce8 <exit>

0000000000000718 <bsem_test>:
void bsem_test(){
     718:	7179                	addi	sp,sp,-48
     71a:	f406                	sd	ra,40(sp)
     71c:	f022                	sd	s0,32(sp)
     71e:	ec26                	sd	s1,24(sp)
     720:	1800                	addi	s0,sp,48
    int bid = bsem_alloc();
     722:	00000097          	auipc	ra,0x0
     726:	696080e7          	jalr	1686(ra) # db8 <bsem_alloc>
     72a:	84aa                	mv	s1,a0
    bsem_down(bid);
     72c:	00000097          	auipc	ra,0x0
     730:	674080e7          	jalr	1652(ra) # da0 <bsem_down>
    printf("1. Parent downing semaphore, pid number = %d\n" , getpid());
     734:	00000097          	auipc	ra,0x0
     738:	634080e7          	jalr	1588(ra) # d68 <getpid>
     73c:	85aa                	mv	a1,a0
     73e:	00001517          	auipc	a0,0x1
     742:	f4250513          	addi	a0,a0,-190 # 1680 <csem_free+0x330>
     746:	00001097          	auipc	ra,0x1
     74a:	974080e7          	jalr	-1676(ra) # 10ba <printf>
    if((pid = fork()) == 0){
     74e:	00000097          	auipc	ra,0x0
     752:	592080e7          	jalr	1426(ra) # ce0 <fork>
     756:	fca42e23          	sw	a0,-36(s0)
     75a:	c125                	beqz	a0,7ba <bsem_test+0xa2>
    sleep(5);
     75c:	4515                	li	a0,5
     75e:	00000097          	auipc	ra,0x0
     762:	61a080e7          	jalr	1562(ra) # d78 <sleep>
    printf("3. Let the child wait on the semaphore...\n");
     766:	00001517          	auipc	a0,0x1
     76a:	f9250513          	addi	a0,a0,-110 # 16f8 <csem_free+0x3a8>
     76e:	00001097          	auipc	ra,0x1
     772:	94c080e7          	jalr	-1716(ra) # 10ba <printf>
    sleep(10);
     776:	4529                	li	a0,10
     778:	00000097          	auipc	ra,0x0
     77c:	600080e7          	jalr	1536(ra) # d78 <sleep>
    bsem_up(bid);
     780:	8526                	mv	a0,s1
     782:	00000097          	auipc	ra,0x0
     786:	626080e7          	jalr	1574(ra) # da8 <bsem_up>
    bsem_free(bid);
     78a:	8526                	mv	a0,s1
     78c:	00000097          	auipc	ra,0x0
     790:	624080e7          	jalr	1572(ra) # db0 <bsem_free>
    wait(&pid);
     794:	fdc40513          	addi	a0,s0,-36
     798:	00000097          	auipc	ra,0x0
     79c:	558080e7          	jalr	1368(ra) # cf0 <wait>
    printf("Finished bsem test, make sure that the order of the prints is alright. Meaning (1...2...3...4)\n");
     7a0:	00001517          	auipc	a0,0x1
     7a4:	f8850513          	addi	a0,a0,-120 # 1728 <csem_free+0x3d8>
     7a8:	00001097          	auipc	ra,0x1
     7ac:	912080e7          	jalr	-1774(ra) # 10ba <printf>
}
     7b0:	70a2                	ld	ra,40(sp)
     7b2:	7402                	ld	s0,32(sp)
     7b4:	64e2                	ld	s1,24(sp)
     7b6:	6145                	addi	sp,sp,48
     7b8:	8082                	ret
        printf("2. Child downing semaphore, pid number = %d\n" , getpid());
     7ba:	00000097          	auipc	ra,0x0
     7be:	5ae080e7          	jalr	1454(ra) # d68 <getpid>
     7c2:	85aa                	mv	a1,a0
     7c4:	00001517          	auipc	a0,0x1
     7c8:	eec50513          	addi	a0,a0,-276 # 16b0 <csem_free+0x360>
     7cc:	00001097          	auipc	ra,0x1
     7d0:	8ee080e7          	jalr	-1810(ra) # 10ba <printf>
        bsem_down(bid);
     7d4:	8526                	mv	a0,s1
     7d6:	00000097          	auipc	ra,0x0
     7da:	5ca080e7          	jalr	1482(ra) # da0 <bsem_down>
        printf("4. Child woke up\n");
     7de:	00001517          	auipc	a0,0x1
     7e2:	f0250513          	addi	a0,a0,-254 # 16e0 <csem_free+0x390>
     7e6:	00001097          	auipc	ra,0x1
     7ea:	8d4080e7          	jalr	-1836(ra) # 10ba <printf>
        exit(0);
     7ee:	4501                	li	a0,0
     7f0:	00000097          	auipc	ra,0x0
     7f4:	4f8080e7          	jalr	1272(ra) # ce8 <exit>

00000000000007f8 <thread_kthread_create>:

void thread_kthread_create(){
     7f8:	1101                	addi	sp,sp,-32
     7fa:	ec06                	sd	ra,24(sp)
     7fc:	e822                	sd	s0,16(sp)
     7fe:	e426                	sd	s1,8(sp)
     800:	1000                	addi	s0,sp,32
  fprintf(2, "\nstarting kthread_create test\n");
     802:	00001597          	auipc	a1,0x1
     806:	f8658593          	addi	a1,a1,-122 # 1788 <csem_free+0x438>
     80a:	4509                	li	a0,2
     80c:	00001097          	auipc	ra,0x1
     810:	880080e7          	jalr	-1920(ra) # 108c <fprintf>

  fprintf(2, "curr thread id is: %d\n", kthread_id());
     814:	00000097          	auipc	ra,0x0
     818:	5b4080e7          	jalr	1460(ra) # dc8 <kthread_id>
     81c:	862a                	mv	a2,a0
     81e:	00001597          	auipc	a1,0x1
     822:	f8a58593          	addi	a1,a1,-118 # 17a8 <csem_free+0x458>
     826:	4509                	li	a0,2
     828:	00001097          	auipc	ra,0x1
     82c:	864080e7          	jalr	-1948(ra) # 108c <fprintf>
  void* stack = malloc(MAX_STACK_SIZE);
     830:	6505                	lui	a0,0x1
     832:	fa050513          	addi	a0,a0,-96 # fa0 <vprintf+0xf2>
     836:	00001097          	auipc	ra,0x1
     83a:	942080e7          	jalr	-1726(ra) # 1178 <malloc>
     83e:	84aa                	mv	s1,a0
  fprintf(2, "the new thread id is: %d\n", kthread_create(thread_kthread_id,stack));
     840:	85aa                	mv	a1,a0
     842:	00000517          	auipc	a0,0x0
     846:	87e50513          	addi	a0,a0,-1922 # c0 <thread_kthread_id>
     84a:	00000097          	auipc	ra,0x0
     84e:	576080e7          	jalr	1398(ra) # dc0 <kthread_create>
     852:	862a                	mv	a2,a0
     854:	00001597          	auipc	a1,0x1
     858:	f6c58593          	addi	a1,a1,-148 # 17c0 <csem_free+0x470>
     85c:	4509                	li	a0,2
     85e:	00001097          	auipc	ra,0x1
     862:	82e080e7          	jalr	-2002(ra) # 108c <fprintf>
  free(stack);
     866:	8526                	mv	a0,s1
     868:	00001097          	auipc	ra,0x1
     86c:	888080e7          	jalr	-1912(ra) # 10f0 <free>

  fprintf(2, "finished kthread_create test\n");
     870:	00001597          	auipc	a1,0x1
     874:	f7058593          	addi	a1,a1,-144 # 17e0 <csem_free+0x490>
     878:	4509                	li	a0,2
     87a:	00001097          	auipc	ra,0x1
     87e:	812080e7          	jalr	-2030(ra) # 108c <fprintf>
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
     89a:	f6a58593          	addi	a1,a1,-150 # 1800 <csem_free+0x4b0>
     89e:	4509                	li	a0,2
     8a0:	00000097          	auipc	ra,0x0
     8a4:	7ec080e7          	jalr	2028(ra) # 108c <fprintf>

  fprintf(2, "curr thread id is: %d\n", kthread_id());
     8a8:	00000097          	auipc	ra,0x0
     8ac:	520080e7          	jalr	1312(ra) # dc8 <kthread_id>
     8b0:	862a                	mv	a2,a0
     8b2:	00001597          	auipc	a1,0x1
     8b6:	ef658593          	addi	a1,a1,-266 # 17a8 <csem_free+0x458>
     8ba:	4509                	li	a0,2
     8bc:	00000097          	auipc	ra,0x0
     8c0:	7d0080e7          	jalr	2000(ra) # 108c <fprintf>
  void* stack = malloc(MAX_STACK_SIZE);
     8c4:	6505                	lui	a0,0x1
     8c6:	fa050513          	addi	a0,a0,-96 # fa0 <vprintf+0xf2>
     8ca:	00001097          	auipc	ra,0x1
     8ce:	8ae080e7          	jalr	-1874(ra) # 1178 <malloc>
     8d2:	84aa                	mv	s1,a0
  fprintf(2, "the new thread id is: %d\n", kthread_create(thread_kthread_id,stack));
     8d4:	85aa                	mv	a1,a0
     8d6:	fffff517          	auipc	a0,0xfffff
     8da:	7ea50513          	addi	a0,a0,2026 # c0 <thread_kthread_id>
     8de:	00000097          	auipc	ra,0x0
     8e2:	4e2080e7          	jalr	1250(ra) # dc0 <kthread_create>
     8e6:	862a                	mv	a2,a0
     8e8:	00001597          	auipc	a1,0x1
     8ec:	ed858593          	addi	a1,a1,-296 # 17c0 <csem_free+0x470>
     8f0:	4509                	li	a0,2
     8f2:	00000097          	auipc	ra,0x0
     8f6:	79a080e7          	jalr	1946(ra) # 108c <fprintf>
  free(stack);
     8fa:	8526                	mv	a0,s1
     8fc:	00000097          	auipc	ra,0x0
     900:	7f4080e7          	jalr	2036(ra) # 10f0 <free>
  int x= 10;
     904:	47a9                	li	a5,10
     906:	fcf42e23          	sw	a5,-36(s0)
  wait(&x);
     90a:	fdc40513          	addi	a0,s0,-36
     90e:	00000097          	auipc	ra,0x0
     912:	3e2080e7          	jalr	994(ra) # cf0 <wait>

  fprintf(2, "finished kthread_create_with_wait test\n");
     916:	00001597          	auipc	a1,0x1
     91a:	f1a58593          	addi	a1,a1,-230 # 1830 <csem_free+0x4e0>
     91e:	4509                	li	a0,2
     920:	00000097          	auipc	ra,0x0
     924:	76c080e7          	jalr	1900(ra) # 108c <fprintf>
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
     940:	00001097          	auipc	ra,0x1
     944:	9b2080e7          	jalr	-1614(ra) # 12f2 <csem_alloc>
    if(retval==-1)
     948:	57fd                	li	a5,-1
     94a:	08f50763          	beq	a0,a5,9d8 <Csem_test+0xa6>
    {
		printf("failed csem alloc");
		exit(-1);
	}
    csem_down(&csem);
     94e:	fe040513          	addi	a0,s0,-32
     952:	00001097          	auipc	ra,0x1
     956:	90c080e7          	jalr	-1780(ra) # 125e <csem_down>
    printf("1. Parent downing semaphore\n");
     95a:	00001517          	auipc	a0,0x1
     95e:	f1650513          	addi	a0,a0,-234 # 1870 <csem_free+0x520>
     962:	00000097          	auipc	ra,0x0
     966:	758080e7          	jalr	1880(ra) # 10ba <printf>
    if((pid = fork()) == 0){
     96a:	00000097          	auipc	ra,0x0
     96e:	376080e7          	jalr	886(ra) # ce0 <fork>
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
     97e:	3fe080e7          	jalr	1022(ra) # d78 <sleep>
    printf("3. Let the child wait on the semaphore...\n");
     982:	00001517          	auipc	a0,0x1
     986:	d7650513          	addi	a0,a0,-650 # 16f8 <csem_free+0x3a8>
     98a:	00000097          	auipc	ra,0x0
     98e:	730080e7          	jalr	1840(ra) # 10ba <printf>
    sleep(10);
     992:	4529                	li	a0,10
     994:	00000097          	auipc	ra,0x0
     998:	3e4080e7          	jalr	996(ra) # d78 <sleep>
    csem_up(&csem);
     99c:	fe040513          	addi	a0,s0,-32
     9a0:	00001097          	auipc	ra,0x1
     9a4:	90c080e7          	jalr	-1780(ra) # 12ac <csem_up>

    csem_free(&csem);
     9a8:	fe040513          	addi	a0,s0,-32
     9ac:	00001097          	auipc	ra,0x1
     9b0:	9a4080e7          	jalr	-1628(ra) # 1350 <csem_free>
    wait(&pid);
     9b4:	fdc40513          	addi	a0,s0,-36
     9b8:	00000097          	auipc	ra,0x0
     9bc:	338080e7          	jalr	824(ra) # cf0 <wait>

    printf("Finished bsem test, make sure that the order of the prints is alright. Meaning (1...2...3...4)\n");
     9c0:	00001517          	auipc	a0,0x1
     9c4:	d6850513          	addi	a0,a0,-664 # 1728 <csem_free+0x3d8>
     9c8:	00000097          	auipc	ra,0x0
     9cc:	6f2080e7          	jalr	1778(ra) # 10ba <printf>
}
     9d0:	70a2                	ld	ra,40(sp)
     9d2:	7402                	ld	s0,32(sp)
     9d4:	6145                	addi	sp,sp,48
     9d6:	8082                	ret
		printf("failed csem alloc");
     9d8:	00001517          	auipc	a0,0x1
     9dc:	e8050513          	addi	a0,a0,-384 # 1858 <csem_free+0x508>
     9e0:	00000097          	auipc	ra,0x0
     9e4:	6da080e7          	jalr	1754(ra) # 10ba <printf>
		exit(-1);
     9e8:	557d                	li	a0,-1
     9ea:	00000097          	auipc	ra,0x0
     9ee:	2fe080e7          	jalr	766(ra) # ce8 <exit>
        printf("2. Child downing semaphore\n");
     9f2:	00001517          	auipc	a0,0x1
     9f6:	e9e50513          	addi	a0,a0,-354 # 1890 <csem_free+0x540>
     9fa:	00000097          	auipc	ra,0x0
     9fe:	6c0080e7          	jalr	1728(ra) # 10ba <printf>
        csem_down(&csem);
     a02:	fe040513          	addi	a0,s0,-32
     a06:	00001097          	auipc	ra,0x1
     a0a:	858080e7          	jalr	-1960(ra) # 125e <csem_down>
        printf("4. Child woke up\n");
     a0e:	00001517          	auipc	a0,0x1
     a12:	cd250513          	addi	a0,a0,-814 # 16e0 <csem_free+0x390>
     a16:	00000097          	auipc	ra,0x0
     a1a:	6a4080e7          	jalr	1700(ra) # 10ba <printf>
        exit(0);
     a1e:	4501                	li	a0,0
     a20:	00000097          	auipc	ra,0x0
     a24:	2c8080e7          	jalr	712(ra) # ce8 <exit>

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
     a34:	e8050513          	addi	a0,a0,-384 # 18b0 <csem_free+0x560>
     a38:	00000097          	auipc	ra,0x0
     a3c:	682080e7          	jalr	1666(ra) # 10ba <printf>
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
     a64:	e7850513          	addi	a0,a0,-392 # 18d8 <csem_free+0x588>
     a68:	00000097          	auipc	ra,0x0
     a6c:	652080e7          	jalr	1618(ra) # 10ba <printf>
  exit(0);
     a70:	4501                	li	a0,0
     a72:	00000097          	auipc	ra,0x0
     a76:	276080e7          	jalr	630(ra) # ce8 <exit>

0000000000000a7a <strcpy>:
#include "user/user.h"


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
     b68:	19c080e7          	jalr	412(ra) # d00 <read>
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
     bba:	172080e7          	jalr	370(ra) # d28 <open>
  if(fd < 0)
     bbe:	02054563          	bltz	a0,be8 <stat+0x42>
     bc2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     bc4:	85ca                	mv	a1,s2
     bc6:	00000097          	auipc	ra,0x0
     bca:	17a080e7          	jalr	378(ra) # d40 <fstat>
     bce:	892a                	mv	s2,a0
  close(fd);
     bd0:	8526                	mv	a0,s1
     bd2:	00000097          	auipc	ra,0x0
     bd6:	13e080e7          	jalr	318(ra) # d10 <close>
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

0000000000000ce0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     ce0:	4885                	li	a7,1
 ecall
     ce2:	00000073          	ecall
 ret
     ce6:	8082                	ret

0000000000000ce8 <exit>:
.global exit
exit:
 li a7, SYS_exit
     ce8:	4889                	li	a7,2
 ecall
     cea:	00000073          	ecall
 ret
     cee:	8082                	ret

0000000000000cf0 <wait>:
.global wait
wait:
 li a7, SYS_wait
     cf0:	488d                	li	a7,3
 ecall
     cf2:	00000073          	ecall
 ret
     cf6:	8082                	ret

0000000000000cf8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     cf8:	4891                	li	a7,4
 ecall
     cfa:	00000073          	ecall
 ret
     cfe:	8082                	ret

0000000000000d00 <read>:
.global read
read:
 li a7, SYS_read
     d00:	4895                	li	a7,5
 ecall
     d02:	00000073          	ecall
 ret
     d06:	8082                	ret

0000000000000d08 <write>:
.global write
write:
 li a7, SYS_write
     d08:	48c1                	li	a7,16
 ecall
     d0a:	00000073          	ecall
 ret
     d0e:	8082                	ret

0000000000000d10 <close>:
.global close
close:
 li a7, SYS_close
     d10:	48d5                	li	a7,21
 ecall
     d12:	00000073          	ecall
 ret
     d16:	8082                	ret

0000000000000d18 <kill>:
.global kill
kill:
 li a7, SYS_kill
     d18:	4899                	li	a7,6
 ecall
     d1a:	00000073          	ecall
 ret
     d1e:	8082                	ret

0000000000000d20 <exec>:
.global exec
exec:
 li a7, SYS_exec
     d20:	489d                	li	a7,7
 ecall
     d22:	00000073          	ecall
 ret
     d26:	8082                	ret

0000000000000d28 <open>:
.global open
open:
 li a7, SYS_open
     d28:	48bd                	li	a7,15
 ecall
     d2a:	00000073          	ecall
 ret
     d2e:	8082                	ret

0000000000000d30 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     d30:	48c5                	li	a7,17
 ecall
     d32:	00000073          	ecall
 ret
     d36:	8082                	ret

0000000000000d38 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     d38:	48c9                	li	a7,18
 ecall
     d3a:	00000073          	ecall
 ret
     d3e:	8082                	ret

0000000000000d40 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     d40:	48a1                	li	a7,8
 ecall
     d42:	00000073          	ecall
 ret
     d46:	8082                	ret

0000000000000d48 <link>:
.global link
link:
 li a7, SYS_link
     d48:	48cd                	li	a7,19
 ecall
     d4a:	00000073          	ecall
 ret
     d4e:	8082                	ret

0000000000000d50 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     d50:	48d1                	li	a7,20
 ecall
     d52:	00000073          	ecall
 ret
     d56:	8082                	ret

0000000000000d58 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     d58:	48a5                	li	a7,9
 ecall
     d5a:	00000073          	ecall
 ret
     d5e:	8082                	ret

0000000000000d60 <dup>:
.global dup
dup:
 li a7, SYS_dup
     d60:	48a9                	li	a7,10
 ecall
     d62:	00000073          	ecall
 ret
     d66:	8082                	ret

0000000000000d68 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     d68:	48ad                	li	a7,11
 ecall
     d6a:	00000073          	ecall
 ret
     d6e:	8082                	ret

0000000000000d70 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     d70:	48b1                	li	a7,12
 ecall
     d72:	00000073          	ecall
 ret
     d76:	8082                	ret

0000000000000d78 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     d78:	48b5                	li	a7,13
 ecall
     d7a:	00000073          	ecall
 ret
     d7e:	8082                	ret

0000000000000d80 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     d80:	48b9                	li	a7,14
 ecall
     d82:	00000073          	ecall
 ret
     d86:	8082                	ret

0000000000000d88 <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
     d88:	48d9                	li	a7,22
 ecall
     d8a:	00000073          	ecall
 ret
     d8e:	8082                	ret

0000000000000d90 <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
     d90:	48dd                	li	a7,23
 ecall
     d92:	00000073          	ecall
 ret
     d96:	8082                	ret

0000000000000d98 <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
     d98:	48e1                	li	a7,24
 ecall
     d9a:	00000073          	ecall
 ret
     d9e:	8082                	ret

0000000000000da0 <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
     da0:	48ed                	li	a7,27
 ecall
     da2:	00000073          	ecall
 ret
     da6:	8082                	ret

0000000000000da8 <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
     da8:	48f1                	li	a7,28
 ecall
     daa:	00000073          	ecall
 ret
     dae:	8082                	ret

0000000000000db0 <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
     db0:	48e9                	li	a7,26
 ecall
     db2:	00000073          	ecall
 ret
     db6:	8082                	ret

0000000000000db8 <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
     db8:	48e5                	li	a7,25
 ecall
     dba:	00000073          	ecall
 ret
     dbe:	8082                	ret

0000000000000dc0 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
     dc0:	48f5                	li	a7,29
 ecall
     dc2:	00000073          	ecall
 ret
     dc6:	8082                	ret

0000000000000dc8 <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
     dc8:	48f9                	li	a7,30
 ecall
     dca:	00000073          	ecall
 ret
     dce:	8082                	ret

0000000000000dd0 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
     dd0:	48fd                	li	a7,31
 ecall
     dd2:	00000073          	ecall
 ret
     dd6:	8082                	ret

0000000000000dd8 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
     dd8:	02000893          	li	a7,32
 ecall
     ddc:	00000073          	ecall
 ret
     de0:	8082                	ret

0000000000000de2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     de2:	1101                	addi	sp,sp,-32
     de4:	ec06                	sd	ra,24(sp)
     de6:	e822                	sd	s0,16(sp)
     de8:	1000                	addi	s0,sp,32
     dea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     dee:	4605                	li	a2,1
     df0:	fef40593          	addi	a1,s0,-17
     df4:	00000097          	auipc	ra,0x0
     df8:	f14080e7          	jalr	-236(ra) # d08 <write>
}
     dfc:	60e2                	ld	ra,24(sp)
     dfe:	6442                	ld	s0,16(sp)
     e00:	6105                	addi	sp,sp,32
     e02:	8082                	ret

0000000000000e04 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e04:	7139                	addi	sp,sp,-64
     e06:	fc06                	sd	ra,56(sp)
     e08:	f822                	sd	s0,48(sp)
     e0a:	f426                	sd	s1,40(sp)
     e0c:	f04a                	sd	s2,32(sp)
     e0e:	ec4e                	sd	s3,24(sp)
     e10:	0080                	addi	s0,sp,64
     e12:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     e14:	c299                	beqz	a3,e1a <printint+0x16>
     e16:	0805c863          	bltz	a1,ea6 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     e1a:	2581                	sext.w	a1,a1
  neg = 0;
     e1c:	4881                	li	a7,0
     e1e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     e22:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     e24:	2601                	sext.w	a2,a2
     e26:	00001517          	auipc	a0,0x1
     e2a:	ad250513          	addi	a0,a0,-1326 # 18f8 <digits>
     e2e:	883a                	mv	a6,a4
     e30:	2705                	addiw	a4,a4,1
     e32:	02c5f7bb          	remuw	a5,a1,a2
     e36:	1782                	slli	a5,a5,0x20
     e38:	9381                	srli	a5,a5,0x20
     e3a:	97aa                	add	a5,a5,a0
     e3c:	0007c783          	lbu	a5,0(a5)
     e40:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     e44:	0005879b          	sext.w	a5,a1
     e48:	02c5d5bb          	divuw	a1,a1,a2
     e4c:	0685                	addi	a3,a3,1
     e4e:	fec7f0e3          	bgeu	a5,a2,e2e <printint+0x2a>
  if(neg)
     e52:	00088b63          	beqz	a7,e68 <printint+0x64>
    buf[i++] = '-';
     e56:	fd040793          	addi	a5,s0,-48
     e5a:	973e                	add	a4,a4,a5
     e5c:	02d00793          	li	a5,45
     e60:	fef70823          	sb	a5,-16(a4)
     e64:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     e68:	02e05863          	blez	a4,e98 <printint+0x94>
     e6c:	fc040793          	addi	a5,s0,-64
     e70:	00e78933          	add	s2,a5,a4
     e74:	fff78993          	addi	s3,a5,-1
     e78:	99ba                	add	s3,s3,a4
     e7a:	377d                	addiw	a4,a4,-1
     e7c:	1702                	slli	a4,a4,0x20
     e7e:	9301                	srli	a4,a4,0x20
     e80:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     e84:	fff94583          	lbu	a1,-1(s2)
     e88:	8526                	mv	a0,s1
     e8a:	00000097          	auipc	ra,0x0
     e8e:	f58080e7          	jalr	-168(ra) # de2 <putc>
  while(--i >= 0)
     e92:	197d                	addi	s2,s2,-1
     e94:	ff3918e3          	bne	s2,s3,e84 <printint+0x80>
}
     e98:	70e2                	ld	ra,56(sp)
     e9a:	7442                	ld	s0,48(sp)
     e9c:	74a2                	ld	s1,40(sp)
     e9e:	7902                	ld	s2,32(sp)
     ea0:	69e2                	ld	s3,24(sp)
     ea2:	6121                	addi	sp,sp,64
     ea4:	8082                	ret
    x = -xx;
     ea6:	40b005bb          	negw	a1,a1
    neg = 1;
     eaa:	4885                	li	a7,1
    x = -xx;
     eac:	bf8d                	j	e1e <printint+0x1a>

0000000000000eae <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     eae:	7119                	addi	sp,sp,-128
     eb0:	fc86                	sd	ra,120(sp)
     eb2:	f8a2                	sd	s0,112(sp)
     eb4:	f4a6                	sd	s1,104(sp)
     eb6:	f0ca                	sd	s2,96(sp)
     eb8:	ecce                	sd	s3,88(sp)
     eba:	e8d2                	sd	s4,80(sp)
     ebc:	e4d6                	sd	s5,72(sp)
     ebe:	e0da                	sd	s6,64(sp)
     ec0:	fc5e                	sd	s7,56(sp)
     ec2:	f862                	sd	s8,48(sp)
     ec4:	f466                	sd	s9,40(sp)
     ec6:	f06a                	sd	s10,32(sp)
     ec8:	ec6e                	sd	s11,24(sp)
     eca:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     ecc:	0005c903          	lbu	s2,0(a1)
     ed0:	18090f63          	beqz	s2,106e <vprintf+0x1c0>
     ed4:	8aaa                	mv	s5,a0
     ed6:	8b32                	mv	s6,a2
     ed8:	00158493          	addi	s1,a1,1
  state = 0;
     edc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ede:	02500a13          	li	s4,37
      if(c == 'd'){
     ee2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     ee6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     eea:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     eee:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     ef2:	00001b97          	auipc	s7,0x1
     ef6:	a06b8b93          	addi	s7,s7,-1530 # 18f8 <digits>
     efa:	a839                	j	f18 <vprintf+0x6a>
        putc(fd, c);
     efc:	85ca                	mv	a1,s2
     efe:	8556                	mv	a0,s5
     f00:	00000097          	auipc	ra,0x0
     f04:	ee2080e7          	jalr	-286(ra) # de2 <putc>
     f08:	a019                	j	f0e <vprintf+0x60>
    } else if(state == '%'){
     f0a:	01498f63          	beq	s3,s4,f28 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     f0e:	0485                	addi	s1,s1,1
     f10:	fff4c903          	lbu	s2,-1(s1)
     f14:	14090d63          	beqz	s2,106e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
     f18:	0009079b          	sext.w	a5,s2
    if(state == 0){
     f1c:	fe0997e3          	bnez	s3,f0a <vprintf+0x5c>
      if(c == '%'){
     f20:	fd479ee3          	bne	a5,s4,efc <vprintf+0x4e>
        state = '%';
     f24:	89be                	mv	s3,a5
     f26:	b7e5                	j	f0e <vprintf+0x60>
      if(c == 'd'){
     f28:	05878063          	beq	a5,s8,f68 <vprintf+0xba>
      } else if(c == 'l') {
     f2c:	05978c63          	beq	a5,s9,f84 <vprintf+0xd6>
      } else if(c == 'x') {
     f30:	07a78863          	beq	a5,s10,fa0 <vprintf+0xf2>
      } else if(c == 'p') {
     f34:	09b78463          	beq	a5,s11,fbc <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     f38:	07300713          	li	a4,115
     f3c:	0ce78663          	beq	a5,a4,1008 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     f40:	06300713          	li	a4,99
     f44:	0ee78e63          	beq	a5,a4,1040 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     f48:	11478863          	beq	a5,s4,1058 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     f4c:	85d2                	mv	a1,s4
     f4e:	8556                	mv	a0,s5
     f50:	00000097          	auipc	ra,0x0
     f54:	e92080e7          	jalr	-366(ra) # de2 <putc>
        putc(fd, c);
     f58:	85ca                	mv	a1,s2
     f5a:	8556                	mv	a0,s5
     f5c:	00000097          	auipc	ra,0x0
     f60:	e86080e7          	jalr	-378(ra) # de2 <putc>
      }
      state = 0;
     f64:	4981                	li	s3,0
     f66:	b765                	j	f0e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
     f68:	008b0913          	addi	s2,s6,8
     f6c:	4685                	li	a3,1
     f6e:	4629                	li	a2,10
     f70:	000b2583          	lw	a1,0(s6)
     f74:	8556                	mv	a0,s5
     f76:	00000097          	auipc	ra,0x0
     f7a:	e8e080e7          	jalr	-370(ra) # e04 <printint>
     f7e:	8b4a                	mv	s6,s2
      state = 0;
     f80:	4981                	li	s3,0
     f82:	b771                	j	f0e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f84:	008b0913          	addi	s2,s6,8
     f88:	4681                	li	a3,0
     f8a:	4629                	li	a2,10
     f8c:	000b2583          	lw	a1,0(s6)
     f90:	8556                	mv	a0,s5
     f92:	00000097          	auipc	ra,0x0
     f96:	e72080e7          	jalr	-398(ra) # e04 <printint>
     f9a:	8b4a                	mv	s6,s2
      state = 0;
     f9c:	4981                	li	s3,0
     f9e:	bf85                	j	f0e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     fa0:	008b0913          	addi	s2,s6,8
     fa4:	4681                	li	a3,0
     fa6:	4641                	li	a2,16
     fa8:	000b2583          	lw	a1,0(s6)
     fac:	8556                	mv	a0,s5
     fae:	00000097          	auipc	ra,0x0
     fb2:	e56080e7          	jalr	-426(ra) # e04 <printint>
     fb6:	8b4a                	mv	s6,s2
      state = 0;
     fb8:	4981                	li	s3,0
     fba:	bf91                	j	f0e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     fbc:	008b0793          	addi	a5,s6,8
     fc0:	f8f43423          	sd	a5,-120(s0)
     fc4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     fc8:	03000593          	li	a1,48
     fcc:	8556                	mv	a0,s5
     fce:	00000097          	auipc	ra,0x0
     fd2:	e14080e7          	jalr	-492(ra) # de2 <putc>
  putc(fd, 'x');
     fd6:	85ea                	mv	a1,s10
     fd8:	8556                	mv	a0,s5
     fda:	00000097          	auipc	ra,0x0
     fde:	e08080e7          	jalr	-504(ra) # de2 <putc>
     fe2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fe4:	03c9d793          	srli	a5,s3,0x3c
     fe8:	97de                	add	a5,a5,s7
     fea:	0007c583          	lbu	a1,0(a5)
     fee:	8556                	mv	a0,s5
     ff0:	00000097          	auipc	ra,0x0
     ff4:	df2080e7          	jalr	-526(ra) # de2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     ff8:	0992                	slli	s3,s3,0x4
     ffa:	397d                	addiw	s2,s2,-1
     ffc:	fe0914e3          	bnez	s2,fe4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    1000:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1004:	4981                	li	s3,0
    1006:	b721                	j	f0e <vprintf+0x60>
        s = va_arg(ap, char*);
    1008:	008b0993          	addi	s3,s6,8
    100c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    1010:	02090163          	beqz	s2,1032 <vprintf+0x184>
        while(*s != 0){
    1014:	00094583          	lbu	a1,0(s2)
    1018:	c9a1                	beqz	a1,1068 <vprintf+0x1ba>
          putc(fd, *s);
    101a:	8556                	mv	a0,s5
    101c:	00000097          	auipc	ra,0x0
    1020:	dc6080e7          	jalr	-570(ra) # de2 <putc>
          s++;
    1024:	0905                	addi	s2,s2,1
        while(*s != 0){
    1026:	00094583          	lbu	a1,0(s2)
    102a:	f9e5                	bnez	a1,101a <vprintf+0x16c>
        s = va_arg(ap, char*);
    102c:	8b4e                	mv	s6,s3
      state = 0;
    102e:	4981                	li	s3,0
    1030:	bdf9                	j	f0e <vprintf+0x60>
          s = "(null)";
    1032:	00001917          	auipc	s2,0x1
    1036:	8be90913          	addi	s2,s2,-1858 # 18f0 <csem_free+0x5a0>
        while(*s != 0){
    103a:	02800593          	li	a1,40
    103e:	bff1                	j	101a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    1040:	008b0913          	addi	s2,s6,8
    1044:	000b4583          	lbu	a1,0(s6)
    1048:	8556                	mv	a0,s5
    104a:	00000097          	auipc	ra,0x0
    104e:	d98080e7          	jalr	-616(ra) # de2 <putc>
    1052:	8b4a                	mv	s6,s2
      state = 0;
    1054:	4981                	li	s3,0
    1056:	bd65                	j	f0e <vprintf+0x60>
        putc(fd, c);
    1058:	85d2                	mv	a1,s4
    105a:	8556                	mv	a0,s5
    105c:	00000097          	auipc	ra,0x0
    1060:	d86080e7          	jalr	-634(ra) # de2 <putc>
      state = 0;
    1064:	4981                	li	s3,0
    1066:	b565                	j	f0e <vprintf+0x60>
        s = va_arg(ap, char*);
    1068:	8b4e                	mv	s6,s3
      state = 0;
    106a:	4981                	li	s3,0
    106c:	b54d                	j	f0e <vprintf+0x60>
    }
  }
}
    106e:	70e6                	ld	ra,120(sp)
    1070:	7446                	ld	s0,112(sp)
    1072:	74a6                	ld	s1,104(sp)
    1074:	7906                	ld	s2,96(sp)
    1076:	69e6                	ld	s3,88(sp)
    1078:	6a46                	ld	s4,80(sp)
    107a:	6aa6                	ld	s5,72(sp)
    107c:	6b06                	ld	s6,64(sp)
    107e:	7be2                	ld	s7,56(sp)
    1080:	7c42                	ld	s8,48(sp)
    1082:	7ca2                	ld	s9,40(sp)
    1084:	7d02                	ld	s10,32(sp)
    1086:	6de2                	ld	s11,24(sp)
    1088:	6109                	addi	sp,sp,128
    108a:	8082                	ret

000000000000108c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    108c:	715d                	addi	sp,sp,-80
    108e:	ec06                	sd	ra,24(sp)
    1090:	e822                	sd	s0,16(sp)
    1092:	1000                	addi	s0,sp,32
    1094:	e010                	sd	a2,0(s0)
    1096:	e414                	sd	a3,8(s0)
    1098:	e818                	sd	a4,16(s0)
    109a:	ec1c                	sd	a5,24(s0)
    109c:	03043023          	sd	a6,32(s0)
    10a0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    10a4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    10a8:	8622                	mv	a2,s0
    10aa:	00000097          	auipc	ra,0x0
    10ae:	e04080e7          	jalr	-508(ra) # eae <vprintf>
}
    10b2:	60e2                	ld	ra,24(sp)
    10b4:	6442                	ld	s0,16(sp)
    10b6:	6161                	addi	sp,sp,80
    10b8:	8082                	ret

00000000000010ba <printf>:

void
printf(const char *fmt, ...)
{
    10ba:	711d                	addi	sp,sp,-96
    10bc:	ec06                	sd	ra,24(sp)
    10be:	e822                	sd	s0,16(sp)
    10c0:	1000                	addi	s0,sp,32
    10c2:	e40c                	sd	a1,8(s0)
    10c4:	e810                	sd	a2,16(s0)
    10c6:	ec14                	sd	a3,24(s0)
    10c8:	f018                	sd	a4,32(s0)
    10ca:	f41c                	sd	a5,40(s0)
    10cc:	03043823          	sd	a6,48(s0)
    10d0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10d4:	00840613          	addi	a2,s0,8
    10d8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10dc:	85aa                	mv	a1,a0
    10de:	4505                	li	a0,1
    10e0:	00000097          	auipc	ra,0x0
    10e4:	dce080e7          	jalr	-562(ra) # eae <vprintf>
}
    10e8:	60e2                	ld	ra,24(sp)
    10ea:	6442                	ld	s0,16(sp)
    10ec:	6125                	addi	sp,sp,96
    10ee:	8082                	ret

00000000000010f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10f0:	1141                	addi	sp,sp,-16
    10f2:	e422                	sd	s0,8(sp)
    10f4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10f6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10fa:	00001797          	auipc	a5,0x1
    10fe:	81e7b783          	ld	a5,-2018(a5) # 1918 <freep>
    1102:	a805                	j	1132 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1104:	4618                	lw	a4,8(a2)
    1106:	9db9                	addw	a1,a1,a4
    1108:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    110c:	6398                	ld	a4,0(a5)
    110e:	6318                	ld	a4,0(a4)
    1110:	fee53823          	sd	a4,-16(a0)
    1114:	a091                	j	1158 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1116:	ff852703          	lw	a4,-8(a0)
    111a:	9e39                	addw	a2,a2,a4
    111c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    111e:	ff053703          	ld	a4,-16(a0)
    1122:	e398                	sd	a4,0(a5)
    1124:	a099                	j	116a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1126:	6398                	ld	a4,0(a5)
    1128:	00e7e463          	bltu	a5,a4,1130 <free+0x40>
    112c:	00e6ea63          	bltu	a3,a4,1140 <free+0x50>
{
    1130:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1132:	fed7fae3          	bgeu	a5,a3,1126 <free+0x36>
    1136:	6398                	ld	a4,0(a5)
    1138:	00e6e463          	bltu	a3,a4,1140 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    113c:	fee7eae3          	bltu	a5,a4,1130 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1140:	ff852583          	lw	a1,-8(a0)
    1144:	6390                	ld	a2,0(a5)
    1146:	02059813          	slli	a6,a1,0x20
    114a:	01c85713          	srli	a4,a6,0x1c
    114e:	9736                	add	a4,a4,a3
    1150:	fae60ae3          	beq	a2,a4,1104 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1154:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1158:	4790                	lw	a2,8(a5)
    115a:	02061593          	slli	a1,a2,0x20
    115e:	01c5d713          	srli	a4,a1,0x1c
    1162:	973e                	add	a4,a4,a5
    1164:	fae689e3          	beq	a3,a4,1116 <free+0x26>
  } else
    p->s.ptr = bp;
    1168:	e394                	sd	a3,0(a5)
  freep = p;
    116a:	00000717          	auipc	a4,0x0
    116e:	7af73723          	sd	a5,1966(a4) # 1918 <freep>
}
    1172:	6422                	ld	s0,8(sp)
    1174:	0141                	addi	sp,sp,16
    1176:	8082                	ret

0000000000001178 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1178:	7139                	addi	sp,sp,-64
    117a:	fc06                	sd	ra,56(sp)
    117c:	f822                	sd	s0,48(sp)
    117e:	f426                	sd	s1,40(sp)
    1180:	f04a                	sd	s2,32(sp)
    1182:	ec4e                	sd	s3,24(sp)
    1184:	e852                	sd	s4,16(sp)
    1186:	e456                	sd	s5,8(sp)
    1188:	e05a                	sd	s6,0(sp)
    118a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    118c:	02051493          	slli	s1,a0,0x20
    1190:	9081                	srli	s1,s1,0x20
    1192:	04bd                	addi	s1,s1,15
    1194:	8091                	srli	s1,s1,0x4
    1196:	0014899b          	addiw	s3,s1,1
    119a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    119c:	00000517          	auipc	a0,0x0
    11a0:	77c53503          	ld	a0,1916(a0) # 1918 <freep>
    11a4:	c515                	beqz	a0,11d0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11a8:	4798                	lw	a4,8(a5)
    11aa:	02977f63          	bgeu	a4,s1,11e8 <malloc+0x70>
    11ae:	8a4e                	mv	s4,s3
    11b0:	0009871b          	sext.w	a4,s3
    11b4:	6685                	lui	a3,0x1
    11b6:	00d77363          	bgeu	a4,a3,11bc <malloc+0x44>
    11ba:	6a05                	lui	s4,0x1
    11bc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    11c0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    11c4:	00000917          	auipc	s2,0x0
    11c8:	75490913          	addi	s2,s2,1876 # 1918 <freep>
  if(p == (char*)-1)
    11cc:	5afd                	li	s5,-1
    11ce:	a895                	j	1242 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    11d0:	00000797          	auipc	a5,0x0
    11d4:	75078793          	addi	a5,a5,1872 # 1920 <base>
    11d8:	00000717          	auipc	a4,0x0
    11dc:	74f73023          	sd	a5,1856(a4) # 1918 <freep>
    11e0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11e2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    11e6:	b7e1                	j	11ae <malloc+0x36>
      if(p->s.size == nunits)
    11e8:	02e48c63          	beq	s1,a4,1220 <malloc+0xa8>
        p->s.size -= nunits;
    11ec:	4137073b          	subw	a4,a4,s3
    11f0:	c798                	sw	a4,8(a5)
        p += p->s.size;
    11f2:	02071693          	slli	a3,a4,0x20
    11f6:	01c6d713          	srli	a4,a3,0x1c
    11fa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    11fc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1200:	00000717          	auipc	a4,0x0
    1204:	70a73c23          	sd	a0,1816(a4) # 1918 <freep>
      return (void*)(p + 1);
    1208:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    120c:	70e2                	ld	ra,56(sp)
    120e:	7442                	ld	s0,48(sp)
    1210:	74a2                	ld	s1,40(sp)
    1212:	7902                	ld	s2,32(sp)
    1214:	69e2                	ld	s3,24(sp)
    1216:	6a42                	ld	s4,16(sp)
    1218:	6aa2                	ld	s5,8(sp)
    121a:	6b02                	ld	s6,0(sp)
    121c:	6121                	addi	sp,sp,64
    121e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1220:	6398                	ld	a4,0(a5)
    1222:	e118                	sd	a4,0(a0)
    1224:	bff1                	j	1200 <malloc+0x88>
  hp->s.size = nu;
    1226:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    122a:	0541                	addi	a0,a0,16
    122c:	00000097          	auipc	ra,0x0
    1230:	ec4080e7          	jalr	-316(ra) # 10f0 <free>
  return freep;
    1234:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1238:	d971                	beqz	a0,120c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    123a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    123c:	4798                	lw	a4,8(a5)
    123e:	fa9775e3          	bgeu	a4,s1,11e8 <malloc+0x70>
    if(p == freep)
    1242:	00093703          	ld	a4,0(s2)
    1246:	853e                	mv	a0,a5
    1248:	fef719e3          	bne	a4,a5,123a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    124c:	8552                	mv	a0,s4
    124e:	00000097          	auipc	ra,0x0
    1252:	b22080e7          	jalr	-1246(ra) # d70 <sbrk>
  if(p == (char*)-1)
    1256:	fd5518e3          	bne	a0,s5,1226 <malloc+0xae>
        return 0;
    125a:	4501                	li	a0,0
    125c:	bf45                	j	120c <malloc+0x94>

000000000000125e <csem_down>:
#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"


void csem_down(struct counting_semaphore *sem) {
    125e:	1101                	addi	sp,sp,-32
    1260:	ec06                	sd	ra,24(sp)
    1262:	e822                	sd	s0,16(sp)
    1264:	e426                	sd	s1,8(sp)
    1266:	1000                	addi	s0,sp,32
    1268:	84aa                	mv	s1,a0
    bsem_down(sem->bsem2);
    126a:	4148                	lw	a0,4(a0)
    126c:	00000097          	auipc	ra,0x0
    1270:	b34080e7          	jalr	-1228(ra) # da0 <bsem_down>
    bsem_down(sem->bsem1);
    1274:	4088                	lw	a0,0(s1)
    1276:	00000097          	auipc	ra,0x0
    127a:	b2a080e7          	jalr	-1238(ra) # da0 <bsem_down>
    sem->count -= 1;
    127e:	449c                	lw	a5,8(s1)
    1280:	37fd                	addiw	a5,a5,-1
    1282:	0007871b          	sext.w	a4,a5
    1286:	c49c                	sw	a5,8(s1)
    if (sem->count > 0)
    1288:	00e04c63          	bgtz	a4,12a0 <csem_down+0x42>
    	bsem_up(sem->bsem2);
    bsem_up(sem->bsem1);
    128c:	4088                	lw	a0,0(s1)
    128e:	00000097          	auipc	ra,0x0
    1292:	b1a080e7          	jalr	-1254(ra) # da8 <bsem_up>
}
    1296:	60e2                	ld	ra,24(sp)
    1298:	6442                	ld	s0,16(sp)
    129a:	64a2                	ld	s1,8(sp)
    129c:	6105                	addi	sp,sp,32
    129e:	8082                	ret
    	bsem_up(sem->bsem2);
    12a0:	40c8                	lw	a0,4(s1)
    12a2:	00000097          	auipc	ra,0x0
    12a6:	b06080e7          	jalr	-1274(ra) # da8 <bsem_up>
    12aa:	b7cd                	j	128c <csem_down+0x2e>

00000000000012ac <csem_up>:


void csem_up(struct counting_semaphore *sem) {
    12ac:	1101                	addi	sp,sp,-32
    12ae:	ec06                	sd	ra,24(sp)
    12b0:	e822                	sd	s0,16(sp)
    12b2:	e426                	sd	s1,8(sp)
    12b4:	1000                	addi	s0,sp,32
    12b6:	84aa                	mv	s1,a0
	bsem_down(sem->bsem1);
    12b8:	4108                	lw	a0,0(a0)
    12ba:	00000097          	auipc	ra,0x0
    12be:	ae6080e7          	jalr	-1306(ra) # da0 <bsem_down>
	sem->count += 1;
    12c2:	449c                	lw	a5,8(s1)
    12c4:	2785                	addiw	a5,a5,1
    12c6:	0007871b          	sext.w	a4,a5
    12ca:	c49c                	sw	a5,8(s1)
	if (sem->count == 1)
    12cc:	4785                	li	a5,1
    12ce:	00f70c63          	beq	a4,a5,12e6 <csem_up+0x3a>
		bsem_up(sem->bsem2);
	bsem_up(sem->bsem1);
    12d2:	4088                	lw	a0,0(s1)
    12d4:	00000097          	auipc	ra,0x0
    12d8:	ad4080e7          	jalr	-1324(ra) # da8 <bsem_up>
}
    12dc:	60e2                	ld	ra,24(sp)
    12de:	6442                	ld	s0,16(sp)
    12e0:	64a2                	ld	s1,8(sp)
    12e2:	6105                	addi	sp,sp,32
    12e4:	8082                	ret
		bsem_up(sem->bsem2);
    12e6:	40c8                	lw	a0,4(s1)
    12e8:	00000097          	auipc	ra,0x0
    12ec:	ac0080e7          	jalr	-1344(ra) # da8 <bsem_up>
    12f0:	b7cd                	j	12d2 <csem_up+0x26>

00000000000012f2 <csem_alloc>:


int csem_alloc(struct counting_semaphore *sem, int count) {
    12f2:	7179                	addi	sp,sp,-48
    12f4:	f406                	sd	ra,40(sp)
    12f6:	f022                	sd	s0,32(sp)
    12f8:	ec26                	sd	s1,24(sp)
    12fa:	e84a                	sd	s2,16(sp)
    12fc:	e44e                	sd	s3,8(sp)
    12fe:	1800                	addi	s0,sp,48
    1300:	892a                	mv	s2,a0
    1302:	89ae                	mv	s3,a1
    int bsem1 = bsem_alloc();
    1304:	00000097          	auipc	ra,0x0
    1308:	ab4080e7          	jalr	-1356(ra) # db8 <bsem_alloc>
    130c:	84aa                	mv	s1,a0
    int bsem2 = bsem_alloc();
    130e:	00000097          	auipc	ra,0x0
    1312:	aaa080e7          	jalr	-1366(ra) # db8 <bsem_alloc>
    if (bsem1 == -1 || bsem2 == -1)
    1316:	57fd                	li	a5,-1
    1318:	00f48d63          	beq	s1,a5,1332 <csem_alloc+0x40>
    131c:	02f50863          	beq	a0,a5,134c <csem_alloc+0x5a>
        return -1; 
    sem->bsem1 = bsem1;
    1320:	00992023          	sw	s1,0(s2)
    sem->bsem2 = bsem2;
    1324:	00a92223          	sw	a0,4(s2)
    if (count == 0)
    1328:	00098d63          	beqz	s3,1342 <csem_alloc+0x50>
        // Binary semaphore first value = min(1, count)
        bsem_down(sem->bsem2); 
    sem->count = count;
    132c:	01392423          	sw	s3,8(s2)
    return 0;
    1330:	4481                	li	s1,0
}
    1332:	8526                	mv	a0,s1
    1334:	70a2                	ld	ra,40(sp)
    1336:	7402                	ld	s0,32(sp)
    1338:	64e2                	ld	s1,24(sp)
    133a:	6942                	ld	s2,16(sp)
    133c:	69a2                	ld	s3,8(sp)
    133e:	6145                	addi	sp,sp,48
    1340:	8082                	ret
        bsem_down(sem->bsem2); 
    1342:	00000097          	auipc	ra,0x0
    1346:	a5e080e7          	jalr	-1442(ra) # da0 <bsem_down>
    134a:	b7cd                	j	132c <csem_alloc+0x3a>
        return -1; 
    134c:	84aa                	mv	s1,a0
    134e:	b7d5                	j	1332 <csem_alloc+0x40>

0000000000001350 <csem_free>:


void csem_free(struct counting_semaphore *sem) {
    1350:	1101                	addi	sp,sp,-32
    1352:	ec06                	sd	ra,24(sp)
    1354:	e822                	sd	s0,16(sp)
    1356:	e426                	sd	s1,8(sp)
    1358:	1000                	addi	s0,sp,32
    135a:	84aa                	mv	s1,a0
    bsem_free(sem->bsem1);
    135c:	4108                	lw	a0,0(a0)
    135e:	00000097          	auipc	ra,0x0
    1362:	a52080e7          	jalr	-1454(ra) # db0 <bsem_free>
    bsem_free(sem->bsem2);
    1366:	40c8                	lw	a0,4(s1)
    1368:	00000097          	auipc	ra,0x0
    136c:	a48080e7          	jalr	-1464(ra) # db0 <bsem_free>
    free(sem);
    1370:	8526                	mv	a0,s1
    1372:	00000097          	auipc	ra,0x0
    1376:	d7e080e7          	jalr	-642(ra) # 10f0 <free>
}
    137a:	60e2                	ld	ra,24(sp)
    137c:	6442                	ld	s0,16(sp)
    137e:	64a2                	ld	s1,8(sp)
    1380:	6105                	addi	sp,sp,32
    1382:	8082                	ret
