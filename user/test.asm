
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
       e:	8ea7ad23          	sw	a0,-1798(a5) # 1904 <flag>
    printf("handle -> signum: %d\n", signum);
      12:	00001517          	auipc	a0,0x1
      16:	36650513          	addi	a0,a0,870 # 1378 <csem_free+0x38>
      1a:	00001097          	auipc	ra,0x1
      1e:	090080e7          	jalr	144(ra) # 10aa <printf>
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
      38:	8ca7a823          	sw	a0,-1840(a5) # 1904 <flag>
    printf("handle2 -> signum: %d\n", signum);
      3c:	00001517          	auipc	a0,0x1
      40:	35450513          	addi	a0,a0,852 # 1390 <csem_free+0x50>
      44:	00001097          	auipc	ra,0x1
      48:	066080e7          	jalr	102(ra) # 10aa <printf>
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
      64:	8aa7a223          	sw	a0,-1884(a5) # 1904 <flag>
    printf("in handle3, flag = %d\n", flag);
      68:	85aa                	mv	a1,a0
      6a:	00001517          	auipc	a0,0x1
      6e:	33e50513          	addi	a0,a0,830 # 13a8 <csem_free+0x68>
      72:	00001097          	auipc	ra,0x1
      76:	038080e7          	jalr	56(ra) # 10aa <printf>
    printf("handle3 -> signum: %d\n", signum);
      7a:	85a6                	mv	a1,s1
      7c:	00001517          	auipc	a0,0x1
      80:	34450513          	addi	a0,a0,836 # 13c0 <csem_free+0x80>
      84:	00001097          	auipc	ra,0x1
      88:	026080e7          	jalr	38(ra) # 10aa <printf>
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
      a4:	86f72023          	sw	a5,-1952(a4) # 1900 <wait_sig>
    printf("Received sigtest\n");
      a8:	00001517          	auipc	a0,0x1
      ac:	33050513          	addi	a0,a0,816 # 13d8 <csem_free+0x98>
      b0:	00001097          	auipc	ra,0x1
      b4:	ffa080e7          	jalr	-6(ra) # 10aa <printf>
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
      cc:	32858593          	addi	a1,a1,808 # 13f0 <csem_free+0xb0>
      d0:	4509                	li	a0,2
      d2:	00001097          	auipc	ra,0x1
      d6:	faa080e7          	jalr	-86(ra) # 107c <fprintf>
  int x = kthread_id();
      da:	00001097          	auipc	ra,0x1
      de:	cde080e7          	jalr	-802(ra) # db8 <kthread_id>
      e2:	862a                	mv	a2,a0
  fprintf(2, "thread_id is: %d\n", x);
      e4:	00001597          	auipc	a1,0x1
      e8:	32c58593          	addi	a1,a1,812 # 1410 <csem_free+0xd0>
      ec:	4509                	li	a0,2
      ee:	00001097          	auipc	ra,0x1
      f2:	f8e080e7          	jalr	-114(ra) # 107c <fprintf>
  fprintf(2, "finished kthread_id test\n");
      f6:	00001597          	auipc	a1,0x1
      fa:	33258593          	addi	a1,a1,818 # 1428 <csem_free+0xe8>
      fe:	4509                	li	a0,2
     100:	00001097          	auipc	ra,0x1
     104:	f7c080e7          	jalr	-132(ra) # 107c <fprintf>
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
     11e:	bb6080e7          	jalr	-1098(ra) # cd0 <fork>
  if(cpid == 0){
     122:	e111                	bnez	a0,126 <sigkillTest+0x16>
    while(1);
     124:	a001                	j	124 <sigkillTest+0x14>
     126:	84aa                	mv	s1,a0
    sleep(50);
     128:	03200513          	li	a0,50
     12c:	00001097          	auipc	ra,0x1
     130:	c3c080e7          	jalr	-964(ra) # d68 <sleep>
    kill(cpid, SIGKILL);
     134:	45a5                	li	a1,9
     136:	8526                	mv	a0,s1
     138:	00001097          	auipc	ra,0x1
     13c:	bd0080e7          	jalr	-1072(ra) # d08 <kill>
  printf("sigkillTest OK\n");
     140:	00001517          	auipc	a0,0x1
     144:	30850513          	addi	a0,a0,776 # 1448 <csem_free+0x108>
     148:	00001097          	auipc	ra,0x1
     14c:	f62080e7          	jalr	-158(ra) # 10aa <printf>
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
     168:	b6c080e7          	jalr	-1172(ra) # cd0 <fork>
  if(cpid == 0){
     16c:	e111                	bnez	a0,170 <killwdiffSignum+0x16>
    while(1);
     16e:	a001                	j	16e <killwdiffSignum+0x14>
     170:	84aa                	mv	s1,a0
    sleep(50);
     172:	03200513          	li	a0,50
     176:	00001097          	auipc	ra,0x1
     17a:	bf2080e7          	jalr	-1038(ra) # d68 <sleep>
    kill(cpid, 15);
     17e:	45bd                	li	a1,15
     180:	8526                	mv	a0,s1
     182:	00001097          	auipc	ra,0x1
     186:	b86080e7          	jalr	-1146(ra) # d08 <kill>
  printf("kill with another signum test OK\n");
     18a:	00001517          	auipc	a0,0x1
     18e:	2ce50513          	addi	a0,a0,718 # 1458 <csem_free+0x118>
     192:	00001097          	auipc	ra,0x1
     196:	f18080e7          	jalr	-232(ra) # 10aa <printf>
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
     1ba:	fb2080e7          	jalr	-78(ra) # 1168 <malloc>
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
     1d4:	f98080e7          	jalr	-104(ra) # 1168 <malloc>
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
     1ee:	f7e080e7          	jalr	-130(ra) # 1168 <malloc>
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
     20e:	b76080e7          	jalr	-1162(ra) # d80 <sigaction>
  sigaction(2, act2, 0);
     212:	4601                	li	a2,0
     214:	85ca                	mv	a1,s2
     216:	4509                	li	a0,2
     218:	00001097          	auipc	ra,0x1
     21c:	b68080e7          	jalr	-1176(ra) # d80 <sigaction>
  int ret3 = sigaction(7, act3, 0);
     220:	4601                	li	a2,0
     222:	85a6                	mv	a1,s1
     224:	451d                	li	a0,7
     226:	00001097          	auipc	ra,0x1
     22a:	b5a080e7          	jalr	-1190(ra) # d80 <sigaction>
     22e:	85aa                	mv	a1,a0
  printf("ret3 = %d\n", ret3);
     230:	00001517          	auipc	a0,0x1
     234:	25050513          	addi	a0,a0,592 # 1480 <csem_free+0x140>
     238:	00001097          	auipc	ra,0x1
     23c:	e72080e7          	jalr	-398(ra) # 10aa <printf>
   printf("The address of the function handle3 is =%p\n",handle3);
     240:	85d2                	mv	a1,s4
     242:	00001517          	auipc	a0,0x1
     246:	24e50513          	addi	a0,a0,590 # 1490 <csem_free+0x150>
     24a:	00001097          	auipc	ra,0x1
     24e:	e60080e7          	jalr	-416(ra) # 10aa <printf>
  int cpid = fork();
     252:	00001097          	auipc	ra,0x1
     256:	a7e080e7          	jalr	-1410(ra) # cd0 <fork>
  if(cpid == 0){
     25a:	e505                	bnez	a0,282 <testSigactionHandler1+0xde>
      if(flag == 7){
     25c:	00001997          	auipc	s3,0x1
     260:	6a898993          	addi	s3,s3,1704 # 1904 <flag>
     264:	449d                	li	s1,7
        printf("successfully recieved signal\n");
     266:	00001917          	auipc	s2,0x1
     26a:	25a90913          	addi	s2,s2,602 # 14c0 <csem_free+0x180>
      if(flag == 7){
     26e:	0009a783          	lw	a5,0(s3)
     272:	00979063          	bne	a5,s1,272 <testSigactionHandler1+0xce>
        printf("successfully recieved signal\n");
     276:	854a                	mv	a0,s2
     278:	00001097          	auipc	ra,0x1
     27c:	e32080e7          	jalr	-462(ra) # 10aa <printf>
     280:	b7fd                	j	26e <testSigactionHandler1+0xca>
     282:	84aa                	mv	s1,a0
    sleep(100);
     284:	06400513          	li	a0,100
     288:	00001097          	auipc	ra,0x1
     28c:	ae0080e7          	jalr	-1312(ra) # d68 <sleep>
    printf( "sending signal %d\n" , 7);
     290:	459d                	li	a1,7
     292:	00001517          	auipc	a0,0x1
     296:	24e50513          	addi	a0,a0,590 # 14e0 <csem_free+0x1a0>
     29a:	00001097          	auipc	ra,0x1
     29e:	e10080e7          	jalr	-496(ra) # 10aa <printf>
    kill(cpid, 7);
     2a2:	459d                	li	a1,7
     2a4:	8526                	mv	a0,s1
     2a6:	00001097          	auipc	ra,0x1
     2aa:	a62080e7          	jalr	-1438(ra) # d08 <kill>
    sleep(100);
     2ae:	06400513          	li	a0,100
     2b2:	00001097          	auipc	ra,0x1
     2b6:	ab6080e7          	jalr	-1354(ra) # d68 <sleep>
    kill(cpid, SIGKILL);
     2ba:	45a5                	li	a1,9
     2bc:	8526                	mv	a0,s1
     2be:	00001097          	auipc	ra,0x1
     2c2:	a4a080e7          	jalr	-1462(ra) # d08 <kill>
  wait(0);
     2c6:	4501                	li	a0,0
     2c8:	00001097          	auipc	ra,0x1
     2cc:	a18080e7          	jalr	-1512(ra) # ce0 <wait>
  printf("custom sig test OK\n");
     2d0:	00001517          	auipc	a0,0x1
     2d4:	22850513          	addi	a0,a0,552 # 14f8 <csem_free+0x1b8>
     2d8:	00001097          	auipc	ra,0x1
     2dc:	dd2080e7          	jalr	-558(ra) # 10aa <printf>
  flag = 0;
     2e0:	00001797          	auipc	a5,0x1
     2e4:	6207a223          	sw	zero,1572(a5) # 1904 <flag>
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
     306:	9ce080e7          	jalr	-1586(ra) # cd0 <fork>
  if(cpid == 0){
     30a:	e519                	bnez	a0,318 <testContStopCont+0x20>
      sleep(10);
     30c:	4529                	li	a0,10
     30e:	00001097          	auipc	ra,0x1
     312:	a5a080e7          	jalr	-1446(ra) # d68 <sleep>
    while(1){
     316:	bfdd                	j	30c <testContStopCont+0x14>
     318:	84aa                	mv	s1,a0
    sleep(20);
     31a:	4551                	li	a0,20
     31c:	00001097          	auipc	ra,0x1
     320:	a4c080e7          	jalr	-1460(ra) # d68 <sleep>
    printf("sending cont\n");
     324:	00001517          	auipc	a0,0x1
     328:	1ec50513          	addi	a0,a0,492 # 1510 <csem_free+0x1d0>
     32c:	00001097          	auipc	ra,0x1
     330:	d7e080e7          	jalr	-642(ra) # 10aa <printf>
    kill(cpid, SIGCONT);
     334:	45cd                	li	a1,19
     336:	8526                	mv	a0,s1
     338:	00001097          	auipc	ra,0x1
     33c:	9d0080e7          	jalr	-1584(ra) # d08 <kill>
    sleep(20);
     340:	4551                	li	a0,20
     342:	00001097          	auipc	ra,0x1
     346:	a26080e7          	jalr	-1498(ra) # d68 <sleep>
    printf("sending stop\n");
     34a:	00001517          	auipc	a0,0x1
     34e:	1d650513          	addi	a0,a0,470 # 1520 <csem_free+0x1e0>
     352:	00001097          	auipc	ra,0x1
     356:	d58080e7          	jalr	-680(ra) # 10aa <printf>
    kill(cpid, SIGSTOP);
     35a:	45c5                	li	a1,17
     35c:	8526                	mv	a0,s1
     35e:	00001097          	auipc	ra,0x1
     362:	9aa080e7          	jalr	-1622(ra) # d08 <kill>
    sleep(20);
     366:	4551                	li	a0,20
     368:	00001097          	auipc	ra,0x1
     36c:	a00080e7          	jalr	-1536(ra) # d68 <sleep>
    printf("sending cont\n");
     370:	00001517          	auipc	a0,0x1
     374:	1a050513          	addi	a0,a0,416 # 1510 <csem_free+0x1d0>
     378:	00001097          	auipc	ra,0x1
     37c:	d32080e7          	jalr	-718(ra) # 10aa <printf>
    kill(cpid, SIGCONT);
     380:	45cd                	li	a1,19
     382:	8526                	mv	a0,s1
     384:	00001097          	auipc	ra,0x1
     388:	984080e7          	jalr	-1660(ra) # d08 <kill>
    sleep(20);
     38c:	4551                	li	a0,20
     38e:	00001097          	auipc	ra,0x1
     392:	9da080e7          	jalr	-1574(ra) # d68 <sleep>
    printf("killing\n");
     396:	00001517          	auipc	a0,0x1
     39a:	19a50513          	addi	a0,a0,410 # 1530 <csem_free+0x1f0>
     39e:	00001097          	auipc	ra,0x1
     3a2:	d0c080e7          	jalr	-756(ra) # 10aa <printf>
    kill(cpid, SIGKILL);
     3a6:	45a5                	li	a1,9
     3a8:	8526                	mv	a0,s1
     3aa:	00001097          	auipc	ra,0x1
     3ae:	95e080e7          	jalr	-1698(ra) # d08 <kill>
  wait(0);
     3b2:	4501                	li	a0,0
     3b4:	00001097          	auipc	ra,0x1
     3b8:	92c080e7          	jalr	-1748(ra) # ce0 <wait>
  printf("testContStopCont OK\n");
     3bc:	00001517          	auipc	a0,0x1
     3c0:	18450513          	addi	a0,a0,388 # 1540 <csem_free+0x200>
     3c4:	00001097          	auipc	ra,0x1
     3c8:	ce6080e7          	jalr	-794(ra) # 10aa <printf>
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
     3e4:	8f0080e7          	jalr	-1808(ra) # cd0 <fork>
  if(cpid == 0){
     3e8:	e519                	bnez	a0,3f6 <testStopCont+0x20>
      sleep(10);
     3ea:	4529                	li	a0,10
     3ec:	00001097          	auipc	ra,0x1
     3f0:	97c080e7          	jalr	-1668(ra) # d68 <sleep>
    while(1){
     3f4:	bfdd                	j	3ea <testStopCont+0x14>
     3f6:	84aa                	mv	s1,a0
    sleep(20);
     3f8:	4551                	li	a0,20
     3fa:	00001097          	auipc	ra,0x1
     3fe:	96e080e7          	jalr	-1682(ra) # d68 <sleep>
    printf("send stop\n");
     402:	00001517          	auipc	a0,0x1
     406:	15650513          	addi	a0,a0,342 # 1558 <csem_free+0x218>
     40a:	00001097          	auipc	ra,0x1
     40e:	ca0080e7          	jalr	-864(ra) # 10aa <printf>
    kill(cpid, SIGSTOP);
     412:	45c5                	li	a1,17
     414:	8526                	mv	a0,s1
     416:	00001097          	auipc	ra,0x1
     41a:	8f2080e7          	jalr	-1806(ra) # d08 <kill>
    sleep(20);
     41e:	4551                	li	a0,20
     420:	00001097          	auipc	ra,0x1
     424:	948080e7          	jalr	-1720(ra) # d68 <sleep>
    printf("send cont\n");
     428:	00001517          	auipc	a0,0x1
     42c:	14050513          	addi	a0,a0,320 # 1568 <csem_free+0x228>
     430:	00001097          	auipc	ra,0x1
     434:	c7a080e7          	jalr	-902(ra) # 10aa <printf>
    kill(cpid, SIGCONT);
     438:	45cd                	li	a1,19
     43a:	8526                	mv	a0,s1
     43c:	00001097          	auipc	ra,0x1
     440:	8cc080e7          	jalr	-1844(ra) # d08 <kill>
    sleep(20);
     444:	4551                	li	a0,20
     446:	00001097          	auipc	ra,0x1
     44a:	922080e7          	jalr	-1758(ra) # d68 <sleep>
    printf("now to the killing\n");
     44e:	00001517          	auipc	a0,0x1
     452:	12a50513          	addi	a0,a0,298 # 1578 <csem_free+0x238>
     456:	00001097          	auipc	ra,0x1
     45a:	c54080e7          	jalr	-940(ra) # 10aa <printf>
    kill(cpid, SIGKILL);
     45e:	45a5                	li	a1,9
     460:	8526                	mv	a0,s1
     462:	00001097          	auipc	ra,0x1
     466:	8a6080e7          	jalr	-1882(ra) # d08 <kill>
  wait(0);
     46a:	4501                	li	a0,0
     46c:	00001097          	auipc	ra,0x1
     470:	874080e7          	jalr	-1932(ra) # ce0 <wait>
  printf("testStopCont OK\n");
     474:	00001517          	auipc	a0,0x1
     478:	11c50513          	addi	a0,a0,284 # 1590 <csem_free+0x250>
     47c:	00001097          	auipc	ra,0x1
     480:	c2e080e7          	jalr	-978(ra) # 10aa <printf>
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
     4a2:	cca080e7          	jalr	-822(ra) # 1168 <malloc>
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
     4b8:	8cc080e7          	jalr	-1844(ra) # d80 <sigaction>
  int cpid = fork();
     4bc:	00001097          	auipc	ra,0x1
     4c0:	814080e7          	jalr	-2028(ra) # cd0 <fork>
  if(cpid == 0){
     4c4:	e505                	bnez	a0,4ec <testSigactionIGN+0x5e>
      if(flag == 5){
     4c6:	00001997          	auipc	s3,0x1
     4ca:	43e98993          	addi	s3,s3,1086 # 1904 <flag>
     4ce:	4495                	li	s1,5
        printf( "If you see me, that's not good\n");
     4d0:	00001917          	auipc	s2,0x1
     4d4:	0d890913          	addi	s2,s2,216 # 15a8 <csem_free+0x268>
      if(flag == 5){
     4d8:	0009a783          	lw	a5,0(s3)
     4dc:	00979063          	bne	a5,s1,4dc <testSigactionIGN+0x4e>
        printf( "If you see me, that's not good\n");
     4e0:	854a                	mv	a0,s2
     4e2:	00001097          	auipc	ra,0x1
     4e6:	bc8080e7          	jalr	-1080(ra) # 10aa <printf>
     4ea:	b7fd                	j	4d8 <testSigactionIGN+0x4a>
     4ec:	84aa                	mv	s1,a0
    sleep(10);
     4ee:	4529                	li	a0,10
     4f0:	00001097          	auipc	ra,0x1
     4f4:	878080e7          	jalr	-1928(ra) # d68 <sleep>
    printf( "send sigaction eith SIG_IGN\n");
     4f8:	00001517          	auipc	a0,0x1
     4fc:	0d050513          	addi	a0,a0,208 # 15c8 <csem_free+0x288>
     500:	00001097          	auipc	ra,0x1
     504:	baa080e7          	jalr	-1110(ra) # 10aa <printf>
    kill(cpid, 5);
     508:	4595                	li	a1,5
     50a:	8526                	mv	a0,s1
     50c:	00000097          	auipc	ra,0x0
     510:	7fc080e7          	jalr	2044(ra) # d08 <kill>
    sleep(10);
     514:	4529                	li	a0,10
     516:	00001097          	auipc	ra,0x1
     51a:	852080e7          	jalr	-1966(ra) # d68 <sleep>
    kill(cpid, SIGKILL);
     51e:	45a5                	li	a1,9
     520:	8526                	mv	a0,s1
     522:	00000097          	auipc	ra,0x0
     526:	7e6080e7          	jalr	2022(ra) # d08 <kill>
  wait(0);
     52a:	4501                	li	a0,0
     52c:	00000097          	auipc	ra,0x0
     530:	7b4080e7          	jalr	1972(ra) # ce0 <wait>
  printf("testSigactionIGN test OK\n");
     534:	00001517          	auipc	a0,0x1
     538:	0b450513          	addi	a0,a0,180 # 15e8 <csem_free+0x2a8>
     53c:	00001097          	auipc	ra,0x1
     540:	b6e080e7          	jalr	-1170(ra) # 10aa <printf>
  flag = 0;
     544:	00001797          	auipc	a5,0x1
     548:	3c07a023          	sw	zero,960(a5) # 1904 <flag>
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
     56e:	80e080e7          	jalr	-2034(ra) # d78 <sigprocmask>
  struct sigaction* act = malloc(sizeof(struct sigaction *));
     572:	4521                	li	a0,8
     574:	00001097          	auipc	ra,0x1
     578:	bf4080e7          	jalr	-1036(ra) # 1168 <malloc>
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
     592:	bda080e7          	jalr	-1062(ra) # 1168 <malloc>
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
     5ac:	bc0080e7          	jalr	-1088(ra) # 1168 <malloc>
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
     5ca:	7ba080e7          	jalr	1978(ra) # d80 <sigaction>
  sigaction(2, act2, 0);
     5ce:	4601                	li	a2,0
     5d0:	85ca                	mv	a1,s2
     5d2:	4509                	li	a0,2
     5d4:	00000097          	auipc	ra,0x0
     5d8:	7ac080e7          	jalr	1964(ra) # d80 <sigaction>
  sigaction(7, act3, 0);
     5dc:	4601                	li	a2,0
     5de:	85a6                	mv	a1,s1
     5e0:	451d                	li	a0,7
     5e2:	00000097          	auipc	ra,0x0
     5e6:	79e080e7          	jalr	1950(ra) # d80 <sigaction>
  int cpid = fork();
     5ea:	00000097          	auipc	ra,0x0
     5ee:	6e6080e7          	jalr	1766(ra) # cd0 <fork>
  if(cpid == 0){
     5f2:	e921                	bnez	a0,642 <testSigmAsk+0xe8>
      if(flag == 7){
     5f4:	00001717          	auipc	a4,0x1
     5f8:	31072703          	lw	a4,784(a4) # 1904 <flag>
     5fc:	479d                	li	a5,7
     5fe:	00f71063          	bne	a4,a5,5fe <testSigmAsk+0xa4>
        printf("Recieved flag\n");
     602:	00001517          	auipc	a0,0x1
     606:	00650513          	addi	a0,a0,6 # 1608 <csem_free+0x2c8>
     60a:	00001097          	auipc	ra,0x1
     60e:	aa0080e7          	jalr	-1376(ra) # 10aa <printf>
  wait(0);
     612:	4501                	li	a0,0
     614:	00000097          	auipc	ra,0x0
     618:	6cc080e7          	jalr	1740(ra) # ce0 <wait>
  printf( "sig mask test OK\n");
     61c:	00001517          	auipc	a0,0x1
     620:	01c50513          	addi	a0,a0,28 # 1638 <csem_free+0x2f8>
     624:	00001097          	auipc	ra,0x1
     628:	a86080e7          	jalr	-1402(ra) # 10aa <printf>
  flag = 0;
     62c:	00001797          	auipc	a5,0x1
     630:	2c07ac23          	sw	zero,728(a5) # 1904 <flag>
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
     64a:	722080e7          	jalr	1826(ra) # d68 <sleep>
    printf("sending sigaction with handler\n");
     64e:	00001517          	auipc	a0,0x1
     652:	fca50513          	addi	a0,a0,-54 # 1618 <csem_free+0x2d8>
     656:	00001097          	auipc	ra,0x1
     65a:	a54080e7          	jalr	-1452(ra) # 10aa <printf>
    kill(cpid, 7);
     65e:	459d                	li	a1,7
     660:	8526                	mv	a0,s1
     662:	00000097          	auipc	ra,0x0
     666:	6a6080e7          	jalr	1702(ra) # d08 <kill>
    sleep(10);
     66a:	4529                	li	a0,10
     66c:	00000097          	auipc	ra,0x0
     670:	6fc080e7          	jalr	1788(ra) # d68 <sleep>
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
     69a:	6e2080e7          	jalr	1762(ra) # d78 <sigprocmask>
    sigaction(testsig, &act, &old);
     69e:	fb840613          	addi	a2,s0,-72
     6a2:	fc840593          	addi	a1,s0,-56
     6a6:	453d                	li	a0,15
     6a8:	00000097          	auipc	ra,0x0
     6ac:	6d8080e7          	jalr	1752(ra) # d80 <sigaction>
    if((pid = fork()) == 0){
     6b0:	00000097          	auipc	ra,0x0
     6b4:	620080e7          	jalr	1568(ra) # cd0 <fork>
     6b8:	fca42e23          	sw	a0,-36(s0)
     6bc:	c90d                	beqz	a0,6ee <signal_test+0x78>
    kill(pid, testsig);
     6be:	45bd                	li	a1,15
     6c0:	00000097          	auipc	ra,0x0
     6c4:	648080e7          	jalr	1608(ra) # d08 <kill>
    wait(&pid);
     6c8:	fdc40513          	addi	a0,s0,-36
     6cc:	00000097          	auipc	ra,0x0
     6d0:	614080e7          	jalr	1556(ra) # ce0 <wait>
    printf("Finished testing signals\n");
     6d4:	00001517          	auipc	a0,0x1
     6d8:	f7c50513          	addi	a0,a0,-132 # 1650 <csem_free+0x310>
     6dc:	00001097          	auipc	ra,0x1
     6e0:	9ce080e7          	jalr	-1586(ra) # 10aa <printf>
}
     6e4:	60a6                	ld	ra,72(sp)
     6e6:	6406                	ld	s0,64(sp)
     6e8:	74e2                	ld	s1,56(sp)
     6ea:	6161                	addi	sp,sp,80
     6ec:	8082                	ret
        while(!wait_sig)
     6ee:	00001797          	auipc	a5,0x1
     6f2:	2127a783          	lw	a5,530(a5) # 1900 <wait_sig>
     6f6:	ef81                	bnez	a5,70e <signal_test+0x98>
     6f8:	00001497          	auipc	s1,0x1
     6fc:	20848493          	addi	s1,s1,520 # 1900 <wait_sig>
            sleep(1);
     700:	4505                	li	a0,1
     702:	00000097          	auipc	ra,0x0
     706:	666080e7          	jalr	1638(ra) # d68 <sleep>
        while(!wait_sig)
     70a:	409c                	lw	a5,0(s1)
     70c:	dbf5                	beqz	a5,700 <signal_test+0x8a>
        exit(0);
     70e:	4501                	li	a0,0
     710:	00000097          	auipc	ra,0x0
     714:	5c8080e7          	jalr	1480(ra) # cd8 <exit>

0000000000000718 <bsem_test>:
void bsem_test(){
     718:	7179                	addi	sp,sp,-48
     71a:	f406                	sd	ra,40(sp)
     71c:	f022                	sd	s0,32(sp)
     71e:	ec26                	sd	s1,24(sp)
     720:	1800                	addi	s0,sp,48
    int bid = bsem_alloc();
     722:	00000097          	auipc	ra,0x0
     726:	686080e7          	jalr	1670(ra) # da8 <bsem_alloc>
     72a:	84aa                	mv	s1,a0
    bsem_down(bid);
     72c:	00000097          	auipc	ra,0x0
     730:	664080e7          	jalr	1636(ra) # d90 <bsem_down>
    printf("1. Parent downing semaphore, pid number = %d\n" , getpid());
     734:	00000097          	auipc	ra,0x0
     738:	624080e7          	jalr	1572(ra) # d58 <getpid>
     73c:	85aa                	mv	a1,a0
     73e:	00001517          	auipc	a0,0x1
     742:	f3250513          	addi	a0,a0,-206 # 1670 <csem_free+0x330>
     746:	00001097          	auipc	ra,0x1
     74a:	964080e7          	jalr	-1692(ra) # 10aa <printf>
    if((pid = fork()) == 0){
     74e:	00000097          	auipc	ra,0x0
     752:	582080e7          	jalr	1410(ra) # cd0 <fork>
     756:	fca42e23          	sw	a0,-36(s0)
     75a:	c125                	beqz	a0,7ba <bsem_test+0xa2>
    sleep(5);
     75c:	4515                	li	a0,5
     75e:	00000097          	auipc	ra,0x0
     762:	60a080e7          	jalr	1546(ra) # d68 <sleep>
    printf("3. Let the child wait on the semaphore...\n");
     766:	00001517          	auipc	a0,0x1
     76a:	f8250513          	addi	a0,a0,-126 # 16e8 <csem_free+0x3a8>
     76e:	00001097          	auipc	ra,0x1
     772:	93c080e7          	jalr	-1732(ra) # 10aa <printf>
    sleep(10);
     776:	4529                	li	a0,10
     778:	00000097          	auipc	ra,0x0
     77c:	5f0080e7          	jalr	1520(ra) # d68 <sleep>
    bsem_up(bid);
     780:	8526                	mv	a0,s1
     782:	00000097          	auipc	ra,0x0
     786:	616080e7          	jalr	1558(ra) # d98 <bsem_up>
    bsem_free(bid);
     78a:	8526                	mv	a0,s1
     78c:	00000097          	auipc	ra,0x0
     790:	614080e7          	jalr	1556(ra) # da0 <bsem_free>
    wait(&pid);
     794:	fdc40513          	addi	a0,s0,-36
     798:	00000097          	auipc	ra,0x0
     79c:	548080e7          	jalr	1352(ra) # ce0 <wait>
    printf("Finished bsem test, make sure that the order of the prints is alright. Meaning (1...2...3...4)\n");
     7a0:	00001517          	auipc	a0,0x1
     7a4:	f7850513          	addi	a0,a0,-136 # 1718 <csem_free+0x3d8>
     7a8:	00001097          	auipc	ra,0x1
     7ac:	902080e7          	jalr	-1790(ra) # 10aa <printf>
}
     7b0:	70a2                	ld	ra,40(sp)
     7b2:	7402                	ld	s0,32(sp)
     7b4:	64e2                	ld	s1,24(sp)
     7b6:	6145                	addi	sp,sp,48
     7b8:	8082                	ret
        printf("2. Child downing semaphore, pid number = %d\n" , getpid());
     7ba:	00000097          	auipc	ra,0x0
     7be:	59e080e7          	jalr	1438(ra) # d58 <getpid>
     7c2:	85aa                	mv	a1,a0
     7c4:	00001517          	auipc	a0,0x1
     7c8:	edc50513          	addi	a0,a0,-292 # 16a0 <csem_free+0x360>
     7cc:	00001097          	auipc	ra,0x1
     7d0:	8de080e7          	jalr	-1826(ra) # 10aa <printf>
        bsem_down(bid);
     7d4:	8526                	mv	a0,s1
     7d6:	00000097          	auipc	ra,0x0
     7da:	5ba080e7          	jalr	1466(ra) # d90 <bsem_down>
        printf("4. Child woke up\n");
     7de:	00001517          	auipc	a0,0x1
     7e2:	ef250513          	addi	a0,a0,-270 # 16d0 <csem_free+0x390>
     7e6:	00001097          	auipc	ra,0x1
     7ea:	8c4080e7          	jalr	-1852(ra) # 10aa <printf>
        exit(0);
     7ee:	4501                	li	a0,0
     7f0:	00000097          	auipc	ra,0x0
     7f4:	4e8080e7          	jalr	1256(ra) # cd8 <exit>

00000000000007f8 <thread_kthread_create>:

void thread_kthread_create(){
     7f8:	1101                	addi	sp,sp,-32
     7fa:	ec06                	sd	ra,24(sp)
     7fc:	e822                	sd	s0,16(sp)
     7fe:	e426                	sd	s1,8(sp)
     800:	1000                	addi	s0,sp,32
  fprintf(2, "\nstarting kthread_create test\n");
     802:	00001597          	auipc	a1,0x1
     806:	f7658593          	addi	a1,a1,-138 # 1778 <csem_free+0x438>
     80a:	4509                	li	a0,2
     80c:	00001097          	auipc	ra,0x1
     810:	870080e7          	jalr	-1936(ra) # 107c <fprintf>

  fprintf(2, "curr thread id is: %d\n", kthread_id());
     814:	00000097          	auipc	ra,0x0
     818:	5a4080e7          	jalr	1444(ra) # db8 <kthread_id>
     81c:	862a                	mv	a2,a0
     81e:	00001597          	auipc	a1,0x1
     822:	f7a58593          	addi	a1,a1,-134 # 1798 <csem_free+0x458>
     826:	4509                	li	a0,2
     828:	00001097          	auipc	ra,0x1
     82c:	854080e7          	jalr	-1964(ra) # 107c <fprintf>
  void* stack = malloc(MAX_STACK_SIZE);
     830:	6505                	lui	a0,0x1
     832:	fa050513          	addi	a0,a0,-96 # fa0 <vprintf+0x102>
     836:	00001097          	auipc	ra,0x1
     83a:	932080e7          	jalr	-1742(ra) # 1168 <malloc>
     83e:	84aa                	mv	s1,a0
  fprintf(2, "the new thread id is: %d\n", kthread_create(thread_kthread_id,stack));
     840:	85aa                	mv	a1,a0
     842:	00000517          	auipc	a0,0x0
     846:	87e50513          	addi	a0,a0,-1922 # c0 <thread_kthread_id>
     84a:	00000097          	auipc	ra,0x0
     84e:	566080e7          	jalr	1382(ra) # db0 <kthread_create>
     852:	862a                	mv	a2,a0
     854:	00001597          	auipc	a1,0x1
     858:	f5c58593          	addi	a1,a1,-164 # 17b0 <csem_free+0x470>
     85c:	4509                	li	a0,2
     85e:	00001097          	auipc	ra,0x1
     862:	81e080e7          	jalr	-2018(ra) # 107c <fprintf>
  free(stack);
     866:	8526                	mv	a0,s1
     868:	00001097          	auipc	ra,0x1
     86c:	878080e7          	jalr	-1928(ra) # 10e0 <free>

  fprintf(2, "finished kthread_create test\n");
     870:	00001597          	auipc	a1,0x1
     874:	f6058593          	addi	a1,a1,-160 # 17d0 <csem_free+0x490>
     878:	4509                	li	a0,2
     87a:	00001097          	auipc	ra,0x1
     87e:	802080e7          	jalr	-2046(ra) # 107c <fprintf>
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
     89a:	f5a58593          	addi	a1,a1,-166 # 17f0 <csem_free+0x4b0>
     89e:	4509                	li	a0,2
     8a0:	00000097          	auipc	ra,0x0
     8a4:	7dc080e7          	jalr	2012(ra) # 107c <fprintf>

  fprintf(2, "curr thread id is: %d\n", kthread_id());
     8a8:	00000097          	auipc	ra,0x0
     8ac:	510080e7          	jalr	1296(ra) # db8 <kthread_id>
     8b0:	862a                	mv	a2,a0
     8b2:	00001597          	auipc	a1,0x1
     8b6:	ee658593          	addi	a1,a1,-282 # 1798 <csem_free+0x458>
     8ba:	4509                	li	a0,2
     8bc:	00000097          	auipc	ra,0x0
     8c0:	7c0080e7          	jalr	1984(ra) # 107c <fprintf>
  void* stack = malloc(MAX_STACK_SIZE);
     8c4:	6505                	lui	a0,0x1
     8c6:	fa050513          	addi	a0,a0,-96 # fa0 <vprintf+0x102>
     8ca:	00001097          	auipc	ra,0x1
     8ce:	89e080e7          	jalr	-1890(ra) # 1168 <malloc>
     8d2:	84aa                	mv	s1,a0
  fprintf(2, "the new thread id is: %d\n", kthread_create(thread_kthread_id,stack));
     8d4:	85aa                	mv	a1,a0
     8d6:	fffff517          	auipc	a0,0xfffff
     8da:	7ea50513          	addi	a0,a0,2026 # c0 <thread_kthread_id>
     8de:	00000097          	auipc	ra,0x0
     8e2:	4d2080e7          	jalr	1234(ra) # db0 <kthread_create>
     8e6:	862a                	mv	a2,a0
     8e8:	00001597          	auipc	a1,0x1
     8ec:	ec858593          	addi	a1,a1,-312 # 17b0 <csem_free+0x470>
     8f0:	4509                	li	a0,2
     8f2:	00000097          	auipc	ra,0x0
     8f6:	78a080e7          	jalr	1930(ra) # 107c <fprintf>
  free(stack);
     8fa:	8526                	mv	a0,s1
     8fc:	00000097          	auipc	ra,0x0
     900:	7e4080e7          	jalr	2020(ra) # 10e0 <free>
  int x= 10;
     904:	47a9                	li	a5,10
     906:	fcf42e23          	sw	a5,-36(s0)
  wait(&x);
     90a:	fdc40513          	addi	a0,s0,-36
     90e:	00000097          	auipc	ra,0x0
     912:	3d2080e7          	jalr	978(ra) # ce0 <wait>

  fprintf(2, "finished kthread_create_with_wait test\n");
     916:	00001597          	auipc	a1,0x1
     91a:	f0a58593          	addi	a1,a1,-246 # 1820 <csem_free+0x4e0>
     91e:	4509                	li	a0,2
     920:	00000097          	auipc	ra,0x0
     924:	75c080e7          	jalr	1884(ra) # 107c <fprintf>
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
     944:	9a2080e7          	jalr	-1630(ra) # 12e2 <csem_alloc>
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
     956:	8fc080e7          	jalr	-1796(ra) # 124e <csem_down>
    printf("1. Parent downing semaphore\n");
     95a:	00001517          	auipc	a0,0x1
     95e:	f0650513          	addi	a0,a0,-250 # 1860 <csem_free+0x520>
     962:	00000097          	auipc	ra,0x0
     966:	748080e7          	jalr	1864(ra) # 10aa <printf>
    if((pid = fork()) == 0){
     96a:	00000097          	auipc	ra,0x0
     96e:	366080e7          	jalr	870(ra) # cd0 <fork>
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
     97e:	3ee080e7          	jalr	1006(ra) # d68 <sleep>
    printf("3. Let the child wait on the semaphore...\n");
     982:	00001517          	auipc	a0,0x1
     986:	d6650513          	addi	a0,a0,-666 # 16e8 <csem_free+0x3a8>
     98a:	00000097          	auipc	ra,0x0
     98e:	720080e7          	jalr	1824(ra) # 10aa <printf>
    sleep(10);
     992:	4529                	li	a0,10
     994:	00000097          	auipc	ra,0x0
     998:	3d4080e7          	jalr	980(ra) # d68 <sleep>
    csem_up(&csem);
     99c:	fe040513          	addi	a0,s0,-32
     9a0:	00001097          	auipc	ra,0x1
     9a4:	8fc080e7          	jalr	-1796(ra) # 129c <csem_up>

    csem_free(&csem);
     9a8:	fe040513          	addi	a0,s0,-32
     9ac:	00001097          	auipc	ra,0x1
     9b0:	994080e7          	jalr	-1644(ra) # 1340 <csem_free>
    wait(&pid);
     9b4:	fdc40513          	addi	a0,s0,-36
     9b8:	00000097          	auipc	ra,0x0
     9bc:	328080e7          	jalr	808(ra) # ce0 <wait>

    printf("Finished bsem test, make sure that the order of the prints is alright. Meaning (1...2...3...4)\n");
     9c0:	00001517          	auipc	a0,0x1
     9c4:	d5850513          	addi	a0,a0,-680 # 1718 <csem_free+0x3d8>
     9c8:	00000097          	auipc	ra,0x0
     9cc:	6e2080e7          	jalr	1762(ra) # 10aa <printf>
}
     9d0:	70a2                	ld	ra,40(sp)
     9d2:	7402                	ld	s0,32(sp)
     9d4:	6145                	addi	sp,sp,48
     9d6:	8082                	ret
		printf("failed csem alloc");
     9d8:	00001517          	auipc	a0,0x1
     9dc:	e7050513          	addi	a0,a0,-400 # 1848 <csem_free+0x508>
     9e0:	00000097          	auipc	ra,0x0
     9e4:	6ca080e7          	jalr	1738(ra) # 10aa <printf>
		exit(-1);
     9e8:	557d                	li	a0,-1
     9ea:	00000097          	auipc	ra,0x0
     9ee:	2ee080e7          	jalr	750(ra) # cd8 <exit>
        printf("2. Child downing semaphore\n");
     9f2:	00001517          	auipc	a0,0x1
     9f6:	e8e50513          	addi	a0,a0,-370 # 1880 <csem_free+0x540>
     9fa:	00000097          	auipc	ra,0x0
     9fe:	6b0080e7          	jalr	1712(ra) # 10aa <printf>
        csem_down(&csem);
     a02:	fe040513          	addi	a0,s0,-32
     a06:	00001097          	auipc	ra,0x1
     a0a:	848080e7          	jalr	-1976(ra) # 124e <csem_down>
        printf("4. Child woke up\n");
     a0e:	00001517          	auipc	a0,0x1
     a12:	cc250513          	addi	a0,a0,-830 # 16d0 <csem_free+0x390>
     a16:	00000097          	auipc	ra,0x0
     a1a:	694080e7          	jalr	1684(ra) # 10aa <printf>
        exit(0);
     a1e:	4501                	li	a0,0
     a20:	00000097          	auipc	ra,0x0
     a24:	2b8080e7          	jalr	696(ra) # cd8 <exit>

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
     a34:	e7050513          	addi	a0,a0,-400 # 18a0 <csem_free+0x560>
     a38:	00000097          	auipc	ra,0x0
     a3c:	672080e7          	jalr	1650(ra) # 10aa <printf>
//  testSigactionHandler1();
//  testContStopCont();
//  testStopCont();
//  testSigactionIGN();
//  testSigmAsk();
  signal_test();
     a40:	00000097          	auipc	ra,0x0
     a44:	c36080e7          	jalr	-970(ra) # 676 <signal_test>
  // bsem_test();
  // Csem_test();
//  thread_kthread_id();
  thread_kthread_create();
     a48:	00000097          	auipc	ra,0x0
     a4c:	db0080e7          	jalr	-592(ra) # 7f8 <thread_kthread_create>
//thread_kthread_create_with_wait();

  printf("\nALL TESTS PASSED\n");
     a50:	00001517          	auipc	a0,0x1
     a54:	e7850513          	addi	a0,a0,-392 # 18c8 <csem_free+0x588>
     a58:	00000097          	auipc	ra,0x0
     a5c:	652080e7          	jalr	1618(ra) # 10aa <printf>
  exit(0);
     a60:	4501                	li	a0,0
     a62:	00000097          	auipc	ra,0x0
     a66:	276080e7          	jalr	630(ra) # cd8 <exit>

0000000000000a6a <strcpy>:
#include "user/user.h"


char*
strcpy(char *s, const char *t)
{
     a6a:	1141                	addi	sp,sp,-16
     a6c:	e422                	sd	s0,8(sp)
     a6e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     a70:	87aa                	mv	a5,a0
     a72:	0585                	addi	a1,a1,1
     a74:	0785                	addi	a5,a5,1
     a76:	fff5c703          	lbu	a4,-1(a1)
     a7a:	fee78fa3          	sb	a4,-1(a5)
     a7e:	fb75                	bnez	a4,a72 <strcpy+0x8>
    ;
  return os;
}
     a80:	6422                	ld	s0,8(sp)
     a82:	0141                	addi	sp,sp,16
     a84:	8082                	ret

0000000000000a86 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     a86:	1141                	addi	sp,sp,-16
     a88:	e422                	sd	s0,8(sp)
     a8a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     a8c:	00054783          	lbu	a5,0(a0)
     a90:	cb91                	beqz	a5,aa4 <strcmp+0x1e>
     a92:	0005c703          	lbu	a4,0(a1)
     a96:	00f71763          	bne	a4,a5,aa4 <strcmp+0x1e>
    p++, q++;
     a9a:	0505                	addi	a0,a0,1
     a9c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     a9e:	00054783          	lbu	a5,0(a0)
     aa2:	fbe5                	bnez	a5,a92 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     aa4:	0005c503          	lbu	a0,0(a1)
}
     aa8:	40a7853b          	subw	a0,a5,a0
     aac:	6422                	ld	s0,8(sp)
     aae:	0141                	addi	sp,sp,16
     ab0:	8082                	ret

0000000000000ab2 <strlen>:

uint
strlen(const char *s)
{
     ab2:	1141                	addi	sp,sp,-16
     ab4:	e422                	sd	s0,8(sp)
     ab6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     ab8:	00054783          	lbu	a5,0(a0)
     abc:	cf91                	beqz	a5,ad8 <strlen+0x26>
     abe:	0505                	addi	a0,a0,1
     ac0:	87aa                	mv	a5,a0
     ac2:	4685                	li	a3,1
     ac4:	9e89                	subw	a3,a3,a0
     ac6:	00f6853b          	addw	a0,a3,a5
     aca:	0785                	addi	a5,a5,1
     acc:	fff7c703          	lbu	a4,-1(a5)
     ad0:	fb7d                	bnez	a4,ac6 <strlen+0x14>
    ;
  return n;
}
     ad2:	6422                	ld	s0,8(sp)
     ad4:	0141                	addi	sp,sp,16
     ad6:	8082                	ret
  for(n = 0; s[n]; n++)
     ad8:	4501                	li	a0,0
     ada:	bfe5                	j	ad2 <strlen+0x20>

0000000000000adc <memset>:

void*
memset(void *dst, int c, uint n)
{
     adc:	1141                	addi	sp,sp,-16
     ade:	e422                	sd	s0,8(sp)
     ae0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     ae2:	ca19                	beqz	a2,af8 <memset+0x1c>
     ae4:	87aa                	mv	a5,a0
     ae6:	1602                	slli	a2,a2,0x20
     ae8:	9201                	srli	a2,a2,0x20
     aea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     aee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     af2:	0785                	addi	a5,a5,1
     af4:	fee79de3          	bne	a5,a4,aee <memset+0x12>
  }
  return dst;
}
     af8:	6422                	ld	s0,8(sp)
     afa:	0141                	addi	sp,sp,16
     afc:	8082                	ret

0000000000000afe <strchr>:

char*
strchr(const char *s, char c)
{
     afe:	1141                	addi	sp,sp,-16
     b00:	e422                	sd	s0,8(sp)
     b02:	0800                	addi	s0,sp,16
  for(; *s; s++)
     b04:	00054783          	lbu	a5,0(a0)
     b08:	cb99                	beqz	a5,b1e <strchr+0x20>
    if(*s == c)
     b0a:	00f58763          	beq	a1,a5,b18 <strchr+0x1a>
  for(; *s; s++)
     b0e:	0505                	addi	a0,a0,1
     b10:	00054783          	lbu	a5,0(a0)
     b14:	fbfd                	bnez	a5,b0a <strchr+0xc>
      return (char*)s;
  return 0;
     b16:	4501                	li	a0,0
}
     b18:	6422                	ld	s0,8(sp)
     b1a:	0141                	addi	sp,sp,16
     b1c:	8082                	ret
  return 0;
     b1e:	4501                	li	a0,0
     b20:	bfe5                	j	b18 <strchr+0x1a>

0000000000000b22 <gets>:

char*
gets(char *buf, int max)
{
     b22:	711d                	addi	sp,sp,-96
     b24:	ec86                	sd	ra,88(sp)
     b26:	e8a2                	sd	s0,80(sp)
     b28:	e4a6                	sd	s1,72(sp)
     b2a:	e0ca                	sd	s2,64(sp)
     b2c:	fc4e                	sd	s3,56(sp)
     b2e:	f852                	sd	s4,48(sp)
     b30:	f456                	sd	s5,40(sp)
     b32:	f05a                	sd	s6,32(sp)
     b34:	ec5e                	sd	s7,24(sp)
     b36:	1080                	addi	s0,sp,96
     b38:	8baa                	mv	s7,a0
     b3a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     b3c:	892a                	mv	s2,a0
     b3e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     b40:	4aa9                	li	s5,10
     b42:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     b44:	89a6                	mv	s3,s1
     b46:	2485                	addiw	s1,s1,1
     b48:	0344d863          	bge	s1,s4,b78 <gets+0x56>
    cc = read(0, &c, 1);
     b4c:	4605                	li	a2,1
     b4e:	faf40593          	addi	a1,s0,-81
     b52:	4501                	li	a0,0
     b54:	00000097          	auipc	ra,0x0
     b58:	19c080e7          	jalr	412(ra) # cf0 <read>
    if(cc < 1)
     b5c:	00a05e63          	blez	a0,b78 <gets+0x56>
    buf[i++] = c;
     b60:	faf44783          	lbu	a5,-81(s0)
     b64:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     b68:	01578763          	beq	a5,s5,b76 <gets+0x54>
     b6c:	0905                	addi	s2,s2,1
     b6e:	fd679be3          	bne	a5,s6,b44 <gets+0x22>
  for(i=0; i+1 < max; ){
     b72:	89a6                	mv	s3,s1
     b74:	a011                	j	b78 <gets+0x56>
     b76:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     b78:	99de                	add	s3,s3,s7
     b7a:	00098023          	sb	zero,0(s3)
  return buf;
}
     b7e:	855e                	mv	a0,s7
     b80:	60e6                	ld	ra,88(sp)
     b82:	6446                	ld	s0,80(sp)
     b84:	64a6                	ld	s1,72(sp)
     b86:	6906                	ld	s2,64(sp)
     b88:	79e2                	ld	s3,56(sp)
     b8a:	7a42                	ld	s4,48(sp)
     b8c:	7aa2                	ld	s5,40(sp)
     b8e:	7b02                	ld	s6,32(sp)
     b90:	6be2                	ld	s7,24(sp)
     b92:	6125                	addi	sp,sp,96
     b94:	8082                	ret

0000000000000b96 <stat>:

int
stat(const char *n, struct stat *st)
{
     b96:	1101                	addi	sp,sp,-32
     b98:	ec06                	sd	ra,24(sp)
     b9a:	e822                	sd	s0,16(sp)
     b9c:	e426                	sd	s1,8(sp)
     b9e:	e04a                	sd	s2,0(sp)
     ba0:	1000                	addi	s0,sp,32
     ba2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ba4:	4581                	li	a1,0
     ba6:	00000097          	auipc	ra,0x0
     baa:	172080e7          	jalr	370(ra) # d18 <open>
  if(fd < 0)
     bae:	02054563          	bltz	a0,bd8 <stat+0x42>
     bb2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     bb4:	85ca                	mv	a1,s2
     bb6:	00000097          	auipc	ra,0x0
     bba:	17a080e7          	jalr	378(ra) # d30 <fstat>
     bbe:	892a                	mv	s2,a0
  close(fd);
     bc0:	8526                	mv	a0,s1
     bc2:	00000097          	auipc	ra,0x0
     bc6:	13e080e7          	jalr	318(ra) # d00 <close>
  return r;
}
     bca:	854a                	mv	a0,s2
     bcc:	60e2                	ld	ra,24(sp)
     bce:	6442                	ld	s0,16(sp)
     bd0:	64a2                	ld	s1,8(sp)
     bd2:	6902                	ld	s2,0(sp)
     bd4:	6105                	addi	sp,sp,32
     bd6:	8082                	ret
    return -1;
     bd8:	597d                	li	s2,-1
     bda:	bfc5                	j	bca <stat+0x34>

0000000000000bdc <atoi>:

int
atoi(const char *s)
{
     bdc:	1141                	addi	sp,sp,-16
     bde:	e422                	sd	s0,8(sp)
     be0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     be2:	00054603          	lbu	a2,0(a0)
     be6:	fd06079b          	addiw	a5,a2,-48
     bea:	0ff7f793          	andi	a5,a5,255
     bee:	4725                	li	a4,9
     bf0:	02f76963          	bltu	a4,a5,c22 <atoi+0x46>
     bf4:	86aa                	mv	a3,a0
  n = 0;
     bf6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     bf8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     bfa:	0685                	addi	a3,a3,1
     bfc:	0025179b          	slliw	a5,a0,0x2
     c00:	9fa9                	addw	a5,a5,a0
     c02:	0017979b          	slliw	a5,a5,0x1
     c06:	9fb1                	addw	a5,a5,a2
     c08:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     c0c:	0006c603          	lbu	a2,0(a3)
     c10:	fd06071b          	addiw	a4,a2,-48
     c14:	0ff77713          	andi	a4,a4,255
     c18:	fee5f1e3          	bgeu	a1,a4,bfa <atoi+0x1e>
  return n;
}
     c1c:	6422                	ld	s0,8(sp)
     c1e:	0141                	addi	sp,sp,16
     c20:	8082                	ret
  n = 0;
     c22:	4501                	li	a0,0
     c24:	bfe5                	j	c1c <atoi+0x40>

0000000000000c26 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     c26:	1141                	addi	sp,sp,-16
     c28:	e422                	sd	s0,8(sp)
     c2a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     c2c:	02b57463          	bgeu	a0,a1,c54 <memmove+0x2e>
    while(n-- > 0)
     c30:	00c05f63          	blez	a2,c4e <memmove+0x28>
     c34:	1602                	slli	a2,a2,0x20
     c36:	9201                	srli	a2,a2,0x20
     c38:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     c3c:	872a                	mv	a4,a0
      *dst++ = *src++;
     c3e:	0585                	addi	a1,a1,1
     c40:	0705                	addi	a4,a4,1
     c42:	fff5c683          	lbu	a3,-1(a1)
     c46:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     c4a:	fee79ae3          	bne	a5,a4,c3e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     c4e:	6422                	ld	s0,8(sp)
     c50:	0141                	addi	sp,sp,16
     c52:	8082                	ret
    dst += n;
     c54:	00c50733          	add	a4,a0,a2
    src += n;
     c58:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     c5a:	fec05ae3          	blez	a2,c4e <memmove+0x28>
     c5e:	fff6079b          	addiw	a5,a2,-1
     c62:	1782                	slli	a5,a5,0x20
     c64:	9381                	srli	a5,a5,0x20
     c66:	fff7c793          	not	a5,a5
     c6a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     c6c:	15fd                	addi	a1,a1,-1
     c6e:	177d                	addi	a4,a4,-1
     c70:	0005c683          	lbu	a3,0(a1)
     c74:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     c78:	fee79ae3          	bne	a5,a4,c6c <memmove+0x46>
     c7c:	bfc9                	j	c4e <memmove+0x28>

0000000000000c7e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     c7e:	1141                	addi	sp,sp,-16
     c80:	e422                	sd	s0,8(sp)
     c82:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     c84:	ca05                	beqz	a2,cb4 <memcmp+0x36>
     c86:	fff6069b          	addiw	a3,a2,-1
     c8a:	1682                	slli	a3,a3,0x20
     c8c:	9281                	srli	a3,a3,0x20
     c8e:	0685                	addi	a3,a3,1
     c90:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     c92:	00054783          	lbu	a5,0(a0)
     c96:	0005c703          	lbu	a4,0(a1)
     c9a:	00e79863          	bne	a5,a4,caa <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     c9e:	0505                	addi	a0,a0,1
    p2++;
     ca0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     ca2:	fed518e3          	bne	a0,a3,c92 <memcmp+0x14>
  }
  return 0;
     ca6:	4501                	li	a0,0
     ca8:	a019                	j	cae <memcmp+0x30>
      return *p1 - *p2;
     caa:	40e7853b          	subw	a0,a5,a4
}
     cae:	6422                	ld	s0,8(sp)
     cb0:	0141                	addi	sp,sp,16
     cb2:	8082                	ret
  return 0;
     cb4:	4501                	li	a0,0
     cb6:	bfe5                	j	cae <memcmp+0x30>

0000000000000cb8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     cb8:	1141                	addi	sp,sp,-16
     cba:	e406                	sd	ra,8(sp)
     cbc:	e022                	sd	s0,0(sp)
     cbe:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     cc0:	00000097          	auipc	ra,0x0
     cc4:	f66080e7          	jalr	-154(ra) # c26 <memmove>
}
     cc8:	60a2                	ld	ra,8(sp)
     cca:	6402                	ld	s0,0(sp)
     ccc:	0141                	addi	sp,sp,16
     cce:	8082                	ret

0000000000000cd0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     cd0:	4885                	li	a7,1
 ecall
     cd2:	00000073          	ecall
 ret
     cd6:	8082                	ret

0000000000000cd8 <exit>:
.global exit
exit:
 li a7, SYS_exit
     cd8:	4889                	li	a7,2
 ecall
     cda:	00000073          	ecall
 ret
     cde:	8082                	ret

0000000000000ce0 <wait>:
.global wait
wait:
 li a7, SYS_wait
     ce0:	488d                	li	a7,3
 ecall
     ce2:	00000073          	ecall
 ret
     ce6:	8082                	ret

0000000000000ce8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     ce8:	4891                	li	a7,4
 ecall
     cea:	00000073          	ecall
 ret
     cee:	8082                	ret

0000000000000cf0 <read>:
.global read
read:
 li a7, SYS_read
     cf0:	4895                	li	a7,5
 ecall
     cf2:	00000073          	ecall
 ret
     cf6:	8082                	ret

0000000000000cf8 <write>:
.global write
write:
 li a7, SYS_write
     cf8:	48c1                	li	a7,16
 ecall
     cfa:	00000073          	ecall
 ret
     cfe:	8082                	ret

0000000000000d00 <close>:
.global close
close:
 li a7, SYS_close
     d00:	48d5                	li	a7,21
 ecall
     d02:	00000073          	ecall
 ret
     d06:	8082                	ret

0000000000000d08 <kill>:
.global kill
kill:
 li a7, SYS_kill
     d08:	4899                	li	a7,6
 ecall
     d0a:	00000073          	ecall
 ret
     d0e:	8082                	ret

0000000000000d10 <exec>:
.global exec
exec:
 li a7, SYS_exec
     d10:	489d                	li	a7,7
 ecall
     d12:	00000073          	ecall
 ret
     d16:	8082                	ret

0000000000000d18 <open>:
.global open
open:
 li a7, SYS_open
     d18:	48bd                	li	a7,15
 ecall
     d1a:	00000073          	ecall
 ret
     d1e:	8082                	ret

0000000000000d20 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     d20:	48c5                	li	a7,17
 ecall
     d22:	00000073          	ecall
 ret
     d26:	8082                	ret

0000000000000d28 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     d28:	48c9                	li	a7,18
 ecall
     d2a:	00000073          	ecall
 ret
     d2e:	8082                	ret

0000000000000d30 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     d30:	48a1                	li	a7,8
 ecall
     d32:	00000073          	ecall
 ret
     d36:	8082                	ret

0000000000000d38 <link>:
.global link
link:
 li a7, SYS_link
     d38:	48cd                	li	a7,19
 ecall
     d3a:	00000073          	ecall
 ret
     d3e:	8082                	ret

0000000000000d40 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     d40:	48d1                	li	a7,20
 ecall
     d42:	00000073          	ecall
 ret
     d46:	8082                	ret

0000000000000d48 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     d48:	48a5                	li	a7,9
 ecall
     d4a:	00000073          	ecall
 ret
     d4e:	8082                	ret

0000000000000d50 <dup>:
.global dup
dup:
 li a7, SYS_dup
     d50:	48a9                	li	a7,10
 ecall
     d52:	00000073          	ecall
 ret
     d56:	8082                	ret

0000000000000d58 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     d58:	48ad                	li	a7,11
 ecall
     d5a:	00000073          	ecall
 ret
     d5e:	8082                	ret

0000000000000d60 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     d60:	48b1                	li	a7,12
 ecall
     d62:	00000073          	ecall
 ret
     d66:	8082                	ret

0000000000000d68 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     d68:	48b5                	li	a7,13
 ecall
     d6a:	00000073          	ecall
 ret
     d6e:	8082                	ret

0000000000000d70 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     d70:	48b9                	li	a7,14
 ecall
     d72:	00000073          	ecall
 ret
     d76:	8082                	ret

0000000000000d78 <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
     d78:	48d9                	li	a7,22
 ecall
     d7a:	00000073          	ecall
 ret
     d7e:	8082                	ret

0000000000000d80 <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
     d80:	48dd                	li	a7,23
 ecall
     d82:	00000073          	ecall
 ret
     d86:	8082                	ret

0000000000000d88 <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
     d88:	48e1                	li	a7,24
 ecall
     d8a:	00000073          	ecall
 ret
     d8e:	8082                	ret

0000000000000d90 <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
     d90:	48ed                	li	a7,27
 ecall
     d92:	00000073          	ecall
 ret
     d96:	8082                	ret

0000000000000d98 <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
     d98:	48f1                	li	a7,28
 ecall
     d9a:	00000073          	ecall
 ret
     d9e:	8082                	ret

0000000000000da0 <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
     da0:	48e9                	li	a7,26
 ecall
     da2:	00000073          	ecall
 ret
     da6:	8082                	ret

0000000000000da8 <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
     da8:	48e5                	li	a7,25
 ecall
     daa:	00000073          	ecall
 ret
     dae:	8082                	ret

0000000000000db0 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
     db0:	48f5                	li	a7,29
 ecall
     db2:	00000073          	ecall
 ret
     db6:	8082                	ret

0000000000000db8 <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
     db8:	48f9                	li	a7,30
 ecall
     dba:	00000073          	ecall
 ret
     dbe:	8082                	ret

0000000000000dc0 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
     dc0:	48fd                	li	a7,31
 ecall
     dc2:	00000073          	ecall
 ret
     dc6:	8082                	ret

0000000000000dc8 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
     dc8:	02000893          	li	a7,32
 ecall
     dcc:	00000073          	ecall
 ret
     dd0:	8082                	ret

0000000000000dd2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     dd2:	1101                	addi	sp,sp,-32
     dd4:	ec06                	sd	ra,24(sp)
     dd6:	e822                	sd	s0,16(sp)
     dd8:	1000                	addi	s0,sp,32
     dda:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     dde:	4605                	li	a2,1
     de0:	fef40593          	addi	a1,s0,-17
     de4:	00000097          	auipc	ra,0x0
     de8:	f14080e7          	jalr	-236(ra) # cf8 <write>
}
     dec:	60e2                	ld	ra,24(sp)
     dee:	6442                	ld	s0,16(sp)
     df0:	6105                	addi	sp,sp,32
     df2:	8082                	ret

0000000000000df4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     df4:	7139                	addi	sp,sp,-64
     df6:	fc06                	sd	ra,56(sp)
     df8:	f822                	sd	s0,48(sp)
     dfa:	f426                	sd	s1,40(sp)
     dfc:	f04a                	sd	s2,32(sp)
     dfe:	ec4e                	sd	s3,24(sp)
     e00:	0080                	addi	s0,sp,64
     e02:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     e04:	c299                	beqz	a3,e0a <printint+0x16>
     e06:	0805c863          	bltz	a1,e96 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     e0a:	2581                	sext.w	a1,a1
  neg = 0;
     e0c:	4881                	li	a7,0
     e0e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     e12:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     e14:	2601                	sext.w	a2,a2
     e16:	00001517          	auipc	a0,0x1
     e1a:	ad250513          	addi	a0,a0,-1326 # 18e8 <digits>
     e1e:	883a                	mv	a6,a4
     e20:	2705                	addiw	a4,a4,1
     e22:	02c5f7bb          	remuw	a5,a1,a2
     e26:	1782                	slli	a5,a5,0x20
     e28:	9381                	srli	a5,a5,0x20
     e2a:	97aa                	add	a5,a5,a0
     e2c:	0007c783          	lbu	a5,0(a5)
     e30:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     e34:	0005879b          	sext.w	a5,a1
     e38:	02c5d5bb          	divuw	a1,a1,a2
     e3c:	0685                	addi	a3,a3,1
     e3e:	fec7f0e3          	bgeu	a5,a2,e1e <printint+0x2a>
  if(neg)
     e42:	00088b63          	beqz	a7,e58 <printint+0x64>
    buf[i++] = '-';
     e46:	fd040793          	addi	a5,s0,-48
     e4a:	973e                	add	a4,a4,a5
     e4c:	02d00793          	li	a5,45
     e50:	fef70823          	sb	a5,-16(a4)
     e54:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     e58:	02e05863          	blez	a4,e88 <printint+0x94>
     e5c:	fc040793          	addi	a5,s0,-64
     e60:	00e78933          	add	s2,a5,a4
     e64:	fff78993          	addi	s3,a5,-1
     e68:	99ba                	add	s3,s3,a4
     e6a:	377d                	addiw	a4,a4,-1
     e6c:	1702                	slli	a4,a4,0x20
     e6e:	9301                	srli	a4,a4,0x20
     e70:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     e74:	fff94583          	lbu	a1,-1(s2)
     e78:	8526                	mv	a0,s1
     e7a:	00000097          	auipc	ra,0x0
     e7e:	f58080e7          	jalr	-168(ra) # dd2 <putc>
  while(--i >= 0)
     e82:	197d                	addi	s2,s2,-1
     e84:	ff3918e3          	bne	s2,s3,e74 <printint+0x80>
}
     e88:	70e2                	ld	ra,56(sp)
     e8a:	7442                	ld	s0,48(sp)
     e8c:	74a2                	ld	s1,40(sp)
     e8e:	7902                	ld	s2,32(sp)
     e90:	69e2                	ld	s3,24(sp)
     e92:	6121                	addi	sp,sp,64
     e94:	8082                	ret
    x = -xx;
     e96:	40b005bb          	negw	a1,a1
    neg = 1;
     e9a:	4885                	li	a7,1
    x = -xx;
     e9c:	bf8d                	j	e0e <printint+0x1a>

0000000000000e9e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     e9e:	7119                	addi	sp,sp,-128
     ea0:	fc86                	sd	ra,120(sp)
     ea2:	f8a2                	sd	s0,112(sp)
     ea4:	f4a6                	sd	s1,104(sp)
     ea6:	f0ca                	sd	s2,96(sp)
     ea8:	ecce                	sd	s3,88(sp)
     eaa:	e8d2                	sd	s4,80(sp)
     eac:	e4d6                	sd	s5,72(sp)
     eae:	e0da                	sd	s6,64(sp)
     eb0:	fc5e                	sd	s7,56(sp)
     eb2:	f862                	sd	s8,48(sp)
     eb4:	f466                	sd	s9,40(sp)
     eb6:	f06a                	sd	s10,32(sp)
     eb8:	ec6e                	sd	s11,24(sp)
     eba:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     ebc:	0005c903          	lbu	s2,0(a1)
     ec0:	18090f63          	beqz	s2,105e <vprintf+0x1c0>
     ec4:	8aaa                	mv	s5,a0
     ec6:	8b32                	mv	s6,a2
     ec8:	00158493          	addi	s1,a1,1
  state = 0;
     ecc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ece:	02500a13          	li	s4,37
      if(c == 'd'){
     ed2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     ed6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     eda:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     ede:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     ee2:	00001b97          	auipc	s7,0x1
     ee6:	a06b8b93          	addi	s7,s7,-1530 # 18e8 <digits>
     eea:	a839                	j	f08 <vprintf+0x6a>
        putc(fd, c);
     eec:	85ca                	mv	a1,s2
     eee:	8556                	mv	a0,s5
     ef0:	00000097          	auipc	ra,0x0
     ef4:	ee2080e7          	jalr	-286(ra) # dd2 <putc>
     ef8:	a019                	j	efe <vprintf+0x60>
    } else if(state == '%'){
     efa:	01498f63          	beq	s3,s4,f18 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     efe:	0485                	addi	s1,s1,1
     f00:	fff4c903          	lbu	s2,-1(s1)
     f04:	14090d63          	beqz	s2,105e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
     f08:	0009079b          	sext.w	a5,s2
    if(state == 0){
     f0c:	fe0997e3          	bnez	s3,efa <vprintf+0x5c>
      if(c == '%'){
     f10:	fd479ee3          	bne	a5,s4,eec <vprintf+0x4e>
        state = '%';
     f14:	89be                	mv	s3,a5
     f16:	b7e5                	j	efe <vprintf+0x60>
      if(c == 'd'){
     f18:	05878063          	beq	a5,s8,f58 <vprintf+0xba>
      } else if(c == 'l') {
     f1c:	05978c63          	beq	a5,s9,f74 <vprintf+0xd6>
      } else if(c == 'x') {
     f20:	07a78863          	beq	a5,s10,f90 <vprintf+0xf2>
      } else if(c == 'p') {
     f24:	09b78463          	beq	a5,s11,fac <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     f28:	07300713          	li	a4,115
     f2c:	0ce78663          	beq	a5,a4,ff8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     f30:	06300713          	li	a4,99
     f34:	0ee78e63          	beq	a5,a4,1030 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     f38:	11478863          	beq	a5,s4,1048 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     f3c:	85d2                	mv	a1,s4
     f3e:	8556                	mv	a0,s5
     f40:	00000097          	auipc	ra,0x0
     f44:	e92080e7          	jalr	-366(ra) # dd2 <putc>
        putc(fd, c);
     f48:	85ca                	mv	a1,s2
     f4a:	8556                	mv	a0,s5
     f4c:	00000097          	auipc	ra,0x0
     f50:	e86080e7          	jalr	-378(ra) # dd2 <putc>
      }
      state = 0;
     f54:	4981                	li	s3,0
     f56:	b765                	j	efe <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
     f58:	008b0913          	addi	s2,s6,8
     f5c:	4685                	li	a3,1
     f5e:	4629                	li	a2,10
     f60:	000b2583          	lw	a1,0(s6)
     f64:	8556                	mv	a0,s5
     f66:	00000097          	auipc	ra,0x0
     f6a:	e8e080e7          	jalr	-370(ra) # df4 <printint>
     f6e:	8b4a                	mv	s6,s2
      state = 0;
     f70:	4981                	li	s3,0
     f72:	b771                	j	efe <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f74:	008b0913          	addi	s2,s6,8
     f78:	4681                	li	a3,0
     f7a:	4629                	li	a2,10
     f7c:	000b2583          	lw	a1,0(s6)
     f80:	8556                	mv	a0,s5
     f82:	00000097          	auipc	ra,0x0
     f86:	e72080e7          	jalr	-398(ra) # df4 <printint>
     f8a:	8b4a                	mv	s6,s2
      state = 0;
     f8c:	4981                	li	s3,0
     f8e:	bf85                	j	efe <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     f90:	008b0913          	addi	s2,s6,8
     f94:	4681                	li	a3,0
     f96:	4641                	li	a2,16
     f98:	000b2583          	lw	a1,0(s6)
     f9c:	8556                	mv	a0,s5
     f9e:	00000097          	auipc	ra,0x0
     fa2:	e56080e7          	jalr	-426(ra) # df4 <printint>
     fa6:	8b4a                	mv	s6,s2
      state = 0;
     fa8:	4981                	li	s3,0
     faa:	bf91                	j	efe <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     fac:	008b0793          	addi	a5,s6,8
     fb0:	f8f43423          	sd	a5,-120(s0)
     fb4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     fb8:	03000593          	li	a1,48
     fbc:	8556                	mv	a0,s5
     fbe:	00000097          	auipc	ra,0x0
     fc2:	e14080e7          	jalr	-492(ra) # dd2 <putc>
  putc(fd, 'x');
     fc6:	85ea                	mv	a1,s10
     fc8:	8556                	mv	a0,s5
     fca:	00000097          	auipc	ra,0x0
     fce:	e08080e7          	jalr	-504(ra) # dd2 <putc>
     fd2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fd4:	03c9d793          	srli	a5,s3,0x3c
     fd8:	97de                	add	a5,a5,s7
     fda:	0007c583          	lbu	a1,0(a5)
     fde:	8556                	mv	a0,s5
     fe0:	00000097          	auipc	ra,0x0
     fe4:	df2080e7          	jalr	-526(ra) # dd2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     fe8:	0992                	slli	s3,s3,0x4
     fea:	397d                	addiw	s2,s2,-1
     fec:	fe0914e3          	bnez	s2,fd4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
     ff0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     ff4:	4981                	li	s3,0
     ff6:	b721                	j	efe <vprintf+0x60>
        s = va_arg(ap, char*);
     ff8:	008b0993          	addi	s3,s6,8
     ffc:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    1000:	02090163          	beqz	s2,1022 <vprintf+0x184>
        while(*s != 0){
    1004:	00094583          	lbu	a1,0(s2)
    1008:	c9a1                	beqz	a1,1058 <vprintf+0x1ba>
          putc(fd, *s);
    100a:	8556                	mv	a0,s5
    100c:	00000097          	auipc	ra,0x0
    1010:	dc6080e7          	jalr	-570(ra) # dd2 <putc>
          s++;
    1014:	0905                	addi	s2,s2,1
        while(*s != 0){
    1016:	00094583          	lbu	a1,0(s2)
    101a:	f9e5                	bnez	a1,100a <vprintf+0x16c>
        s = va_arg(ap, char*);
    101c:	8b4e                	mv	s6,s3
      state = 0;
    101e:	4981                	li	s3,0
    1020:	bdf9                	j	efe <vprintf+0x60>
          s = "(null)";
    1022:	00001917          	auipc	s2,0x1
    1026:	8be90913          	addi	s2,s2,-1858 # 18e0 <csem_free+0x5a0>
        while(*s != 0){
    102a:	02800593          	li	a1,40
    102e:	bff1                	j	100a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    1030:	008b0913          	addi	s2,s6,8
    1034:	000b4583          	lbu	a1,0(s6)
    1038:	8556                	mv	a0,s5
    103a:	00000097          	auipc	ra,0x0
    103e:	d98080e7          	jalr	-616(ra) # dd2 <putc>
    1042:	8b4a                	mv	s6,s2
      state = 0;
    1044:	4981                	li	s3,0
    1046:	bd65                	j	efe <vprintf+0x60>
        putc(fd, c);
    1048:	85d2                	mv	a1,s4
    104a:	8556                	mv	a0,s5
    104c:	00000097          	auipc	ra,0x0
    1050:	d86080e7          	jalr	-634(ra) # dd2 <putc>
      state = 0;
    1054:	4981                	li	s3,0
    1056:	b565                	j	efe <vprintf+0x60>
        s = va_arg(ap, char*);
    1058:	8b4e                	mv	s6,s3
      state = 0;
    105a:	4981                	li	s3,0
    105c:	b54d                	j	efe <vprintf+0x60>
    }
  }
}
    105e:	70e6                	ld	ra,120(sp)
    1060:	7446                	ld	s0,112(sp)
    1062:	74a6                	ld	s1,104(sp)
    1064:	7906                	ld	s2,96(sp)
    1066:	69e6                	ld	s3,88(sp)
    1068:	6a46                	ld	s4,80(sp)
    106a:	6aa6                	ld	s5,72(sp)
    106c:	6b06                	ld	s6,64(sp)
    106e:	7be2                	ld	s7,56(sp)
    1070:	7c42                	ld	s8,48(sp)
    1072:	7ca2                	ld	s9,40(sp)
    1074:	7d02                	ld	s10,32(sp)
    1076:	6de2                	ld	s11,24(sp)
    1078:	6109                	addi	sp,sp,128
    107a:	8082                	ret

000000000000107c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    107c:	715d                	addi	sp,sp,-80
    107e:	ec06                	sd	ra,24(sp)
    1080:	e822                	sd	s0,16(sp)
    1082:	1000                	addi	s0,sp,32
    1084:	e010                	sd	a2,0(s0)
    1086:	e414                	sd	a3,8(s0)
    1088:	e818                	sd	a4,16(s0)
    108a:	ec1c                	sd	a5,24(s0)
    108c:	03043023          	sd	a6,32(s0)
    1090:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1094:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1098:	8622                	mv	a2,s0
    109a:	00000097          	auipc	ra,0x0
    109e:	e04080e7          	jalr	-508(ra) # e9e <vprintf>
}
    10a2:	60e2                	ld	ra,24(sp)
    10a4:	6442                	ld	s0,16(sp)
    10a6:	6161                	addi	sp,sp,80
    10a8:	8082                	ret

00000000000010aa <printf>:

void
printf(const char *fmt, ...)
{
    10aa:	711d                	addi	sp,sp,-96
    10ac:	ec06                	sd	ra,24(sp)
    10ae:	e822                	sd	s0,16(sp)
    10b0:	1000                	addi	s0,sp,32
    10b2:	e40c                	sd	a1,8(s0)
    10b4:	e810                	sd	a2,16(s0)
    10b6:	ec14                	sd	a3,24(s0)
    10b8:	f018                	sd	a4,32(s0)
    10ba:	f41c                	sd	a5,40(s0)
    10bc:	03043823          	sd	a6,48(s0)
    10c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10c4:	00840613          	addi	a2,s0,8
    10c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10cc:	85aa                	mv	a1,a0
    10ce:	4505                	li	a0,1
    10d0:	00000097          	auipc	ra,0x0
    10d4:	dce080e7          	jalr	-562(ra) # e9e <vprintf>
}
    10d8:	60e2                	ld	ra,24(sp)
    10da:	6442                	ld	s0,16(sp)
    10dc:	6125                	addi	sp,sp,96
    10de:	8082                	ret

00000000000010e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10e0:	1141                	addi	sp,sp,-16
    10e2:	e422                	sd	s0,8(sp)
    10e4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10e6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10ea:	00001797          	auipc	a5,0x1
    10ee:	81e7b783          	ld	a5,-2018(a5) # 1908 <freep>
    10f2:	a805                	j	1122 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    10f4:	4618                	lw	a4,8(a2)
    10f6:	9db9                	addw	a1,a1,a4
    10f8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    10fc:	6398                	ld	a4,0(a5)
    10fe:	6318                	ld	a4,0(a4)
    1100:	fee53823          	sd	a4,-16(a0)
    1104:	a091                	j	1148 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1106:	ff852703          	lw	a4,-8(a0)
    110a:	9e39                	addw	a2,a2,a4
    110c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    110e:	ff053703          	ld	a4,-16(a0)
    1112:	e398                	sd	a4,0(a5)
    1114:	a099                	j	115a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1116:	6398                	ld	a4,0(a5)
    1118:	00e7e463          	bltu	a5,a4,1120 <free+0x40>
    111c:	00e6ea63          	bltu	a3,a4,1130 <free+0x50>
{
    1120:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1122:	fed7fae3          	bgeu	a5,a3,1116 <free+0x36>
    1126:	6398                	ld	a4,0(a5)
    1128:	00e6e463          	bltu	a3,a4,1130 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    112c:	fee7eae3          	bltu	a5,a4,1120 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1130:	ff852583          	lw	a1,-8(a0)
    1134:	6390                	ld	a2,0(a5)
    1136:	02059813          	slli	a6,a1,0x20
    113a:	01c85713          	srli	a4,a6,0x1c
    113e:	9736                	add	a4,a4,a3
    1140:	fae60ae3          	beq	a2,a4,10f4 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1144:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1148:	4790                	lw	a2,8(a5)
    114a:	02061593          	slli	a1,a2,0x20
    114e:	01c5d713          	srli	a4,a1,0x1c
    1152:	973e                	add	a4,a4,a5
    1154:	fae689e3          	beq	a3,a4,1106 <free+0x26>
  } else
    p->s.ptr = bp;
    1158:	e394                	sd	a3,0(a5)
  freep = p;
    115a:	00000717          	auipc	a4,0x0
    115e:	7af73723          	sd	a5,1966(a4) # 1908 <freep>
}
    1162:	6422                	ld	s0,8(sp)
    1164:	0141                	addi	sp,sp,16
    1166:	8082                	ret

0000000000001168 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1168:	7139                	addi	sp,sp,-64
    116a:	fc06                	sd	ra,56(sp)
    116c:	f822                	sd	s0,48(sp)
    116e:	f426                	sd	s1,40(sp)
    1170:	f04a                	sd	s2,32(sp)
    1172:	ec4e                	sd	s3,24(sp)
    1174:	e852                	sd	s4,16(sp)
    1176:	e456                	sd	s5,8(sp)
    1178:	e05a                	sd	s6,0(sp)
    117a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    117c:	02051493          	slli	s1,a0,0x20
    1180:	9081                	srli	s1,s1,0x20
    1182:	04bd                	addi	s1,s1,15
    1184:	8091                	srli	s1,s1,0x4
    1186:	0014899b          	addiw	s3,s1,1
    118a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    118c:	00000517          	auipc	a0,0x0
    1190:	77c53503          	ld	a0,1916(a0) # 1908 <freep>
    1194:	c515                	beqz	a0,11c0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1196:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1198:	4798                	lw	a4,8(a5)
    119a:	02977f63          	bgeu	a4,s1,11d8 <malloc+0x70>
    119e:	8a4e                	mv	s4,s3
    11a0:	0009871b          	sext.w	a4,s3
    11a4:	6685                	lui	a3,0x1
    11a6:	00d77363          	bgeu	a4,a3,11ac <malloc+0x44>
    11aa:	6a05                	lui	s4,0x1
    11ac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    11b0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    11b4:	00000917          	auipc	s2,0x0
    11b8:	75490913          	addi	s2,s2,1876 # 1908 <freep>
  if(p == (char*)-1)
    11bc:	5afd                	li	s5,-1
    11be:	a895                	j	1232 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    11c0:	00000797          	auipc	a5,0x0
    11c4:	75078793          	addi	a5,a5,1872 # 1910 <base>
    11c8:	00000717          	auipc	a4,0x0
    11cc:	74f73023          	sd	a5,1856(a4) # 1908 <freep>
    11d0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11d2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    11d6:	b7e1                	j	119e <malloc+0x36>
      if(p->s.size == nunits)
    11d8:	02e48c63          	beq	s1,a4,1210 <malloc+0xa8>
        p->s.size -= nunits;
    11dc:	4137073b          	subw	a4,a4,s3
    11e0:	c798                	sw	a4,8(a5)
        p += p->s.size;
    11e2:	02071693          	slli	a3,a4,0x20
    11e6:	01c6d713          	srli	a4,a3,0x1c
    11ea:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    11ec:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    11f0:	00000717          	auipc	a4,0x0
    11f4:	70a73c23          	sd	a0,1816(a4) # 1908 <freep>
      return (void*)(p + 1);
    11f8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    11fc:	70e2                	ld	ra,56(sp)
    11fe:	7442                	ld	s0,48(sp)
    1200:	74a2                	ld	s1,40(sp)
    1202:	7902                	ld	s2,32(sp)
    1204:	69e2                	ld	s3,24(sp)
    1206:	6a42                	ld	s4,16(sp)
    1208:	6aa2                	ld	s5,8(sp)
    120a:	6b02                	ld	s6,0(sp)
    120c:	6121                	addi	sp,sp,64
    120e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1210:	6398                	ld	a4,0(a5)
    1212:	e118                	sd	a4,0(a0)
    1214:	bff1                	j	11f0 <malloc+0x88>
  hp->s.size = nu;
    1216:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    121a:	0541                	addi	a0,a0,16
    121c:	00000097          	auipc	ra,0x0
    1220:	ec4080e7          	jalr	-316(ra) # 10e0 <free>
  return freep;
    1224:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1228:	d971                	beqz	a0,11fc <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    122a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    122c:	4798                	lw	a4,8(a5)
    122e:	fa9775e3          	bgeu	a4,s1,11d8 <malloc+0x70>
    if(p == freep)
    1232:	00093703          	ld	a4,0(s2)
    1236:	853e                	mv	a0,a5
    1238:	fef719e3          	bne	a4,a5,122a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    123c:	8552                	mv	a0,s4
    123e:	00000097          	auipc	ra,0x0
    1242:	b22080e7          	jalr	-1246(ra) # d60 <sbrk>
  if(p == (char*)-1)
    1246:	fd5518e3          	bne	a0,s5,1216 <malloc+0xae>
        return 0;
    124a:	4501                	li	a0,0
    124c:	bf45                	j	11fc <malloc+0x94>

000000000000124e <csem_down>:
#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"


void csem_down(struct counting_semaphore *sem) {
    124e:	1101                	addi	sp,sp,-32
    1250:	ec06                	sd	ra,24(sp)
    1252:	e822                	sd	s0,16(sp)
    1254:	e426                	sd	s1,8(sp)
    1256:	1000                	addi	s0,sp,32
    1258:	84aa                	mv	s1,a0
    bsem_down(sem->bsem2);
    125a:	4148                	lw	a0,4(a0)
    125c:	00000097          	auipc	ra,0x0
    1260:	b34080e7          	jalr	-1228(ra) # d90 <bsem_down>
    bsem_down(sem->bsem1);
    1264:	4088                	lw	a0,0(s1)
    1266:	00000097          	auipc	ra,0x0
    126a:	b2a080e7          	jalr	-1238(ra) # d90 <bsem_down>
    sem->count -= 1;
    126e:	449c                	lw	a5,8(s1)
    1270:	37fd                	addiw	a5,a5,-1
    1272:	0007871b          	sext.w	a4,a5
    1276:	c49c                	sw	a5,8(s1)
    if (sem->count > 0)
    1278:	00e04c63          	bgtz	a4,1290 <csem_down+0x42>
    	bsem_up(sem->bsem2);
    bsem_up(sem->bsem1);
    127c:	4088                	lw	a0,0(s1)
    127e:	00000097          	auipc	ra,0x0
    1282:	b1a080e7          	jalr	-1254(ra) # d98 <bsem_up>
}
    1286:	60e2                	ld	ra,24(sp)
    1288:	6442                	ld	s0,16(sp)
    128a:	64a2                	ld	s1,8(sp)
    128c:	6105                	addi	sp,sp,32
    128e:	8082                	ret
    	bsem_up(sem->bsem2);
    1290:	40c8                	lw	a0,4(s1)
    1292:	00000097          	auipc	ra,0x0
    1296:	b06080e7          	jalr	-1274(ra) # d98 <bsem_up>
    129a:	b7cd                	j	127c <csem_down+0x2e>

000000000000129c <csem_up>:


void csem_up(struct counting_semaphore *sem) {
    129c:	1101                	addi	sp,sp,-32
    129e:	ec06                	sd	ra,24(sp)
    12a0:	e822                	sd	s0,16(sp)
    12a2:	e426                	sd	s1,8(sp)
    12a4:	1000                	addi	s0,sp,32
    12a6:	84aa                	mv	s1,a0
	bsem_down(sem->bsem1);
    12a8:	4108                	lw	a0,0(a0)
    12aa:	00000097          	auipc	ra,0x0
    12ae:	ae6080e7          	jalr	-1306(ra) # d90 <bsem_down>
	sem->count += 1;
    12b2:	449c                	lw	a5,8(s1)
    12b4:	2785                	addiw	a5,a5,1
    12b6:	0007871b          	sext.w	a4,a5
    12ba:	c49c                	sw	a5,8(s1)
	if (sem->count == 1)
    12bc:	4785                	li	a5,1
    12be:	00f70c63          	beq	a4,a5,12d6 <csem_up+0x3a>
		bsem_up(sem->bsem2);
	bsem_up(sem->bsem1);
    12c2:	4088                	lw	a0,0(s1)
    12c4:	00000097          	auipc	ra,0x0
    12c8:	ad4080e7          	jalr	-1324(ra) # d98 <bsem_up>
}
    12cc:	60e2                	ld	ra,24(sp)
    12ce:	6442                	ld	s0,16(sp)
    12d0:	64a2                	ld	s1,8(sp)
    12d2:	6105                	addi	sp,sp,32
    12d4:	8082                	ret
		bsem_up(sem->bsem2);
    12d6:	40c8                	lw	a0,4(s1)
    12d8:	00000097          	auipc	ra,0x0
    12dc:	ac0080e7          	jalr	-1344(ra) # d98 <bsem_up>
    12e0:	b7cd                	j	12c2 <csem_up+0x26>

00000000000012e2 <csem_alloc>:


int csem_alloc(struct counting_semaphore *sem, int count) {
    12e2:	7179                	addi	sp,sp,-48
    12e4:	f406                	sd	ra,40(sp)
    12e6:	f022                	sd	s0,32(sp)
    12e8:	ec26                	sd	s1,24(sp)
    12ea:	e84a                	sd	s2,16(sp)
    12ec:	e44e                	sd	s3,8(sp)
    12ee:	1800                	addi	s0,sp,48
    12f0:	892a                	mv	s2,a0
    12f2:	89ae                	mv	s3,a1
    int bsem1 = bsem_alloc();
    12f4:	00000097          	auipc	ra,0x0
    12f8:	ab4080e7          	jalr	-1356(ra) # da8 <bsem_alloc>
    12fc:	84aa                	mv	s1,a0
    int bsem2 = bsem_alloc();
    12fe:	00000097          	auipc	ra,0x0
    1302:	aaa080e7          	jalr	-1366(ra) # da8 <bsem_alloc>
    if (bsem1 == -1 || bsem2 == -1)
    1306:	57fd                	li	a5,-1
    1308:	00f48d63          	beq	s1,a5,1322 <csem_alloc+0x40>
    130c:	02f50863          	beq	a0,a5,133c <csem_alloc+0x5a>
        return -1; 
    sem->bsem1 = bsem1;
    1310:	00992023          	sw	s1,0(s2)
    sem->bsem2 = bsem2;
    1314:	00a92223          	sw	a0,4(s2)
    if (count == 0)
    1318:	00098d63          	beqz	s3,1332 <csem_alloc+0x50>
        // Binary semaphore first value = min(1, count)
        bsem_down(sem->bsem2); 
    sem->count = count;
    131c:	01392423          	sw	s3,8(s2)
    return 0;
    1320:	4481                	li	s1,0
}
    1322:	8526                	mv	a0,s1
    1324:	70a2                	ld	ra,40(sp)
    1326:	7402                	ld	s0,32(sp)
    1328:	64e2                	ld	s1,24(sp)
    132a:	6942                	ld	s2,16(sp)
    132c:	69a2                	ld	s3,8(sp)
    132e:	6145                	addi	sp,sp,48
    1330:	8082                	ret
        bsem_down(sem->bsem2); 
    1332:	00000097          	auipc	ra,0x0
    1336:	a5e080e7          	jalr	-1442(ra) # d90 <bsem_down>
    133a:	b7cd                	j	131c <csem_alloc+0x3a>
        return -1; 
    133c:	84aa                	mv	s1,a0
    133e:	b7d5                	j	1322 <csem_alloc+0x40>

0000000000001340 <csem_free>:


void csem_free(struct counting_semaphore *sem) {
    1340:	1101                	addi	sp,sp,-32
    1342:	ec06                	sd	ra,24(sp)
    1344:	e822                	sd	s0,16(sp)
    1346:	e426                	sd	s1,8(sp)
    1348:	1000                	addi	s0,sp,32
    134a:	84aa                	mv	s1,a0
    bsem_free(sem->bsem1);
    134c:	4108                	lw	a0,0(a0)
    134e:	00000097          	auipc	ra,0x0
    1352:	a52080e7          	jalr	-1454(ra) # da0 <bsem_free>
    bsem_free(sem->bsem2);
    1356:	40c8                	lw	a0,4(s1)
    1358:	00000097          	auipc	ra,0x0
    135c:	a48080e7          	jalr	-1464(ra) # da0 <bsem_free>
    free(sem);
    1360:	8526                	mv	a0,s1
    1362:	00000097          	auipc	ra,0x0
    1366:	d7e080e7          	jalr	-642(ra) # 10e0 <free>
}
    136a:	60e2                	ld	ra,24(sp)
    136c:	6442                	ld	s0,16(sp)
    136e:	64a2                	ld	s1,8(sp)
    1370:	6105                	addi	sp,sp,32
    1372:	8082                	ret
