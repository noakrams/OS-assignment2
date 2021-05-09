
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test_handler1>:
char buf[BUFSZ];


int wait_sig = 0;

void test_handler1(int signum){
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
    wait_sig = 1;
       8:	4785                	li	a5,1
       a:	00009717          	auipc	a4,0x9
       e:	8af72723          	sw	a5,-1874(a4) # 88b8 <wait_sig>
    printf("Received sigtest\n");
      12:	00006517          	auipc	a0,0x6
      16:	36e50513          	addi	a0,a0,878 # 6380 <csem_free+0x26c>
      1a:	00006097          	auipc	ra,0x6
      1e:	e64080e7          	jalr	-412(ra) # 5e7e <printf>
}
      22:	60a2                	ld	ra,8(sp)
      24:	6402                	ld	s0,0(sp)
      26:	0141                	addi	sp,sp,16
      28:	8082                	ret

000000000000002a <test_handler2>:

void test_handler2(int signum){
      2a:	1141                	addi	sp,sp,-16
      2c:	e406                	sd	ra,8(sp)
      2e:	e022                	sd	s0,0(sp)
      30:	0800                	addi	s0,sp,16
    wait_sig = 1;
      32:	4785                	li	a5,1
      34:	00009717          	auipc	a4,0x9
      38:	88f72223          	sw	a5,-1916(a4) # 88b8 <wait_sig>
    printf("Received sigtest\n");
      3c:	00006517          	auipc	a0,0x6
      40:	34450513          	addi	a0,a0,836 # 6380 <csem_free+0x26c>
      44:	00006097          	auipc	ra,0x6
      48:	e3a080e7          	jalr	-454(ra) # 5e7e <printf>
}
      4c:	60a2                	ld	ra,8(sp)
      4e:	6402                	ld	s0,0(sp)
      50:	0141                	addi	sp,sp,16
      52:	8082                	ret

0000000000000054 <test_handler>:

void test_handler(int signum){
      54:	1141                	addi	sp,sp,-16
      56:	e406                	sd	ra,8(sp)
      58:	e022                	sd	s0,0(sp)
      5a:	0800                	addi	s0,sp,16
    wait_sig = 1;
      5c:	4785                	li	a5,1
      5e:	00009717          	auipc	a4,0x9
      62:	84f72d23          	sw	a5,-1958(a4) # 88b8 <wait_sig>
    printf("Received sigtest\n");
      66:	00006517          	auipc	a0,0x6
      6a:	31a50513          	addi	a0,a0,794 # 6380 <csem_free+0x26c>
      6e:	00006097          	auipc	ra,0x6
      72:	e10080e7          	jalr	-496(ra) # 5e7e <printf>
}
      76:	60a2                	ld	ra,8(sp)
      78:	6402                	ld	s0,0(sp)
      7a:	0141                	addi	sp,sp,16
      7c:	8082                	ret

000000000000007e <test_thread>:

void test_thread(){
      7e:	1141                	addi	sp,sp,-16
      80:	e406                	sd	ra,8(sp)
      82:	e022                	sd	s0,0(sp)
      84:	0800                	addi	s0,sp,16
    printf("Thread is now running\n");
      86:	00006517          	auipc	a0,0x6
      8a:	31250513          	addi	a0,a0,786 # 6398 <csem_free+0x284>
      8e:	00006097          	auipc	ra,0x6
      92:	df0080e7          	jalr	-528(ra) # 5e7e <printf>
    kthread_exit(0);
      96:	4501                	li	a0,0
      98:	00006097          	auipc	ra,0x6
      9c:	afc080e7          	jalr	-1284(ra) # 5b94 <kthread_exit>
}
      a0:	60a2                	ld	ra,8(sp)
      a2:	6402                	ld	s0,0(sp)
      a4:	0141                	addi	sp,sp,16
      a6:	8082                	ret

00000000000000a8 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      a8:	0000a797          	auipc	a5,0xa
      ac:	92878793          	addi	a5,a5,-1752 # 99d0 <uninit>
      b0:	0000c697          	auipc	a3,0xc
      b4:	03068693          	addi	a3,a3,48 # c0e0 <buf>
    if(uninit[i] != '\0'){
      b8:	0007c703          	lbu	a4,0(a5)
      bc:	e709                	bnez	a4,c6 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      be:	0785                	addi	a5,a5,1
      c0:	fed79ce3          	bne	a5,a3,b8 <bsstest+0x10>
      c4:	8082                	ret
{
      c6:	1141                	addi	sp,sp,-16
      c8:	e406                	sd	ra,8(sp)
      ca:	e022                	sd	s0,0(sp)
      cc:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      ce:	85aa                	mv	a1,a0
      d0:	00006517          	auipc	a0,0x6
      d4:	2e050513          	addi	a0,a0,736 # 63b0 <csem_free+0x29c>
      d8:	00006097          	auipc	ra,0x6
      dc:	da6080e7          	jalr	-602(ra) # 5e7e <printf>
      exit(1);
      e0:	4505                	li	a0,1
      e2:	00006097          	auipc	ra,0x6
      e6:	9ca080e7          	jalr	-1590(ra) # 5aac <exit>

00000000000000ea <signal_test>:
void signal_test(char *s){
      ea:	7159                	addi	sp,sp,-112
      ec:	f486                	sd	ra,104(sp)
      ee:	f0a2                	sd	s0,96(sp)
      f0:	eca6                	sd	s1,88(sp)
      f2:	1880                	addi	s0,sp,112
    struct sigaction act1 = {test_handler1, (uint)(1 << 29)};
      f4:	00000797          	auipc	a5,0x0
      f8:	f0c78793          	addi	a5,a5,-244 # 0 <test_handler1>
      fc:	fcf43423          	sd	a5,-56(s0)
     100:	200007b7          	lui	a5,0x20000
     104:	fcf42823          	sw	a5,-48(s0)
    struct sigaction act2 = {test_handler2, (uint)(1 << 29)};
     108:	00000717          	auipc	a4,0x0
     10c:	f2270713          	addi	a4,a4,-222 # 2a <test_handler2>
     110:	fae43c23          	sd	a4,-72(s0)
     114:	fcf42023          	sw	a5,-64(s0)
    struct sigaction act = {test_handler, (uint)(1 << 29)};
     118:	00000717          	auipc	a4,0x0
     11c:	f3c70713          	addi	a4,a4,-196 # 54 <test_handler>
     120:	fae43423          	sd	a4,-88(s0)
     124:	faf42823          	sw	a5,-80(s0)
    sigprocmask(0);
     128:	4501                	li	a0,0
     12a:	00006097          	auipc	ra,0x6
     12e:	a22080e7          	jalr	-1502(ra) # 5b4c <sigprocmask>
    sigaction(7, &act1, &old);
     132:	f9840613          	addi	a2,s0,-104
     136:	fc840593          	addi	a1,s0,-56
     13a:	451d                	li	a0,7
     13c:	00006097          	auipc	ra,0x6
     140:	a18080e7          	jalr	-1512(ra) # 5b54 <sigaction>
    sigaction(5, &act2, &old);
     144:	f9840613          	addi	a2,s0,-104
     148:	fb840593          	addi	a1,s0,-72
     14c:	4515                	li	a0,5
     14e:	00006097          	auipc	ra,0x6
     152:	a06080e7          	jalr	-1530(ra) # 5b54 <sigaction>
    sigaction(testsig, &act, &old);
     156:	f9840613          	addi	a2,s0,-104
     15a:	fa840593          	addi	a1,s0,-88
     15e:	453d                	li	a0,15
     160:	00006097          	auipc	ra,0x6
     164:	9f4080e7          	jalr	-1548(ra) # 5b54 <sigaction>
    if((pid = fork()) == 0){
     168:	00006097          	auipc	ra,0x6
     16c:	93c080e7          	jalr	-1732(ra) # 5aa4 <fork>
     170:	fca42e23          	sw	a0,-36(s0)
     174:	c135                	beqz	a0,1d8 <signal_test+0xee>
    printf("Father pid = %d    ,    child pid = %d\n", getpid(), pid);
     176:	00006097          	auipc	ra,0x6
     17a:	9b6080e7          	jalr	-1610(ra) # 5b2c <getpid>
     17e:	85aa                	mv	a1,a0
     180:	fdc42603          	lw	a2,-36(s0)
     184:	00006517          	auipc	a0,0x6
     188:	25c50513          	addi	a0,a0,604 # 63e0 <csem_free+0x2cc>
     18c:	00006097          	auipc	ra,0x6
     190:	cf2080e7          	jalr	-782(ra) # 5e7e <printf>
    kill(pid, testsig);
     194:	45bd                	li	a1,15
     196:	fdc42503          	lw	a0,-36(s0)
     19a:	00006097          	auipc	ra,0x6
     19e:	942080e7          	jalr	-1726(ra) # 5adc <kill>
    printf("signal_test - before wait\n");
     1a2:	00006517          	auipc	a0,0x6
     1a6:	26650513          	addi	a0,a0,614 # 6408 <csem_free+0x2f4>
     1aa:	00006097          	auipc	ra,0x6
     1ae:	cd4080e7          	jalr	-812(ra) # 5e7e <printf>
    wait(&pid);
     1b2:	fdc40513          	addi	a0,s0,-36
     1b6:	00006097          	auipc	ra,0x6
     1ba:	8fe080e7          	jalr	-1794(ra) # 5ab4 <wait>
    printf("Finished testing signals\n");
     1be:	00006517          	auipc	a0,0x6
     1c2:	26a50513          	addi	a0,a0,618 # 6428 <csem_free+0x314>
     1c6:	00006097          	auipc	ra,0x6
     1ca:	cb8080e7          	jalr	-840(ra) # 5e7e <printf>
}
     1ce:	70a6                	ld	ra,104(sp)
     1d0:	7406                	ld	s0,96(sp)
     1d2:	64e6                	ld	s1,88(sp)
     1d4:	6165                	addi	sp,sp,112
     1d6:	8082                	ret
        while(!wait_sig)
     1d8:	00008797          	auipc	a5,0x8
     1dc:	6e07a783          	lw	a5,1760(a5) # 88b8 <wait_sig>
     1e0:	ef81                	bnez	a5,1f8 <signal_test+0x10e>
     1e2:	00008497          	auipc	s1,0x8
     1e6:	6d648493          	addi	s1,s1,1750 # 88b8 <wait_sig>
            sleep(1);
     1ea:	4505                	li	a0,1
     1ec:	00006097          	auipc	ra,0x6
     1f0:	950080e7          	jalr	-1712(ra) # 5b3c <sleep>
        while(!wait_sig)
     1f4:	409c                	lw	a5,0(s1)
     1f6:	dbf5                	beqz	a5,1ea <signal_test+0x100>
        printf("Got out of while\n");
     1f8:	00006517          	auipc	a0,0x6
     1fc:	1d050513          	addi	a0,a0,464 # 63c8 <csem_free+0x2b4>
     200:	00006097          	auipc	ra,0x6
     204:	c7e080e7          	jalr	-898(ra) # 5e7e <printf>
        exit(0);
     208:	4501                	li	a0,0
     20a:	00006097          	auipc	ra,0x6
     20e:	8a2080e7          	jalr	-1886(ra) # 5aac <exit>

0000000000000212 <exitwait>:
{
     212:	7139                	addi	sp,sp,-64
     214:	fc06                	sd	ra,56(sp)
     216:	f822                	sd	s0,48(sp)
     218:	f426                	sd	s1,40(sp)
     21a:	f04a                	sd	s2,32(sp)
     21c:	ec4e                	sd	s3,24(sp)
     21e:	e852                	sd	s4,16(sp)
     220:	0080                	addi	s0,sp,64
     222:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
     224:	4901                	li	s2,0
     226:	06400993          	li	s3,100
    pid = fork();
     22a:	00006097          	auipc	ra,0x6
     22e:	87a080e7          	jalr	-1926(ra) # 5aa4 <fork>
     232:	84aa                	mv	s1,a0
    if(pid < 0){
     234:	02054a63          	bltz	a0,268 <exitwait+0x56>
    if(pid){
     238:	c151                	beqz	a0,2bc <exitwait+0xaa>
      if(wait(&xstate) != pid){
     23a:	fcc40513          	addi	a0,s0,-52
     23e:	00006097          	auipc	ra,0x6
     242:	876080e7          	jalr	-1930(ra) # 5ab4 <wait>
     246:	02951f63          	bne	a0,s1,284 <exitwait+0x72>
      if(i != xstate) {
     24a:	fcc42783          	lw	a5,-52(s0)
     24e:	05279963          	bne	a5,s2,2a0 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
     252:	2905                	addiw	s2,s2,1
     254:	fd391be3          	bne	s2,s3,22a <exitwait+0x18>
}
     258:	70e2                	ld	ra,56(sp)
     25a:	7442                	ld	s0,48(sp)
     25c:	74a2                	ld	s1,40(sp)
     25e:	7902                	ld	s2,32(sp)
     260:	69e2                	ld	s3,24(sp)
     262:	6a42                	ld	s4,16(sp)
     264:	6121                	addi	sp,sp,64
     266:	8082                	ret
      printf("%s: fork failed\n", s);
     268:	85d2                	mv	a1,s4
     26a:	00006517          	auipc	a0,0x6
     26e:	1de50513          	addi	a0,a0,478 # 6448 <csem_free+0x334>
     272:	00006097          	auipc	ra,0x6
     276:	c0c080e7          	jalr	-1012(ra) # 5e7e <printf>
      exit(1);
     27a:	4505                	li	a0,1
     27c:	00006097          	auipc	ra,0x6
     280:	830080e7          	jalr	-2000(ra) # 5aac <exit>
        printf("%s: wait wrong pid\n", s);
     284:	85d2                	mv	a1,s4
     286:	00006517          	auipc	a0,0x6
     28a:	1da50513          	addi	a0,a0,474 # 6460 <csem_free+0x34c>
     28e:	00006097          	auipc	ra,0x6
     292:	bf0080e7          	jalr	-1040(ra) # 5e7e <printf>
        exit(1);
     296:	4505                	li	a0,1
     298:	00006097          	auipc	ra,0x6
     29c:	814080e7          	jalr	-2028(ra) # 5aac <exit>
        printf("%s: wait wrong exit status\n", s);
     2a0:	85d2                	mv	a1,s4
     2a2:	00006517          	auipc	a0,0x6
     2a6:	1d650513          	addi	a0,a0,470 # 6478 <csem_free+0x364>
     2aa:	00006097          	auipc	ra,0x6
     2ae:	bd4080e7          	jalr	-1068(ra) # 5e7e <printf>
        exit(1);
     2b2:	4505                	li	a0,1
     2b4:	00005097          	auipc	ra,0x5
     2b8:	7f8080e7          	jalr	2040(ra) # 5aac <exit>
      exit(i);
     2bc:	854a                	mv	a0,s2
     2be:	00005097          	auipc	ra,0x5
     2c2:	7ee080e7          	jalr	2030(ra) # 5aac <exit>

00000000000002c6 <reparent>:
{
     2c6:	7179                	addi	sp,sp,-48
     2c8:	f406                	sd	ra,40(sp)
     2ca:	f022                	sd	s0,32(sp)
     2cc:	ec26                	sd	s1,24(sp)
     2ce:	e84a                	sd	s2,16(sp)
     2d0:	e44e                	sd	s3,8(sp)
     2d2:	e052                	sd	s4,0(sp)
     2d4:	1800                	addi	s0,sp,48
     2d6:	89aa                	mv	s3,a0
  int master_pid = getpid();
     2d8:	00006097          	auipc	ra,0x6
     2dc:	854080e7          	jalr	-1964(ra) # 5b2c <getpid>
     2e0:	8a2a                	mv	s4,a0
     2e2:	0c800913          	li	s2,200
    int pid = fork();
     2e6:	00005097          	auipc	ra,0x5
     2ea:	7be080e7          	jalr	1982(ra) # 5aa4 <fork>
     2ee:	84aa                	mv	s1,a0
    if(pid < 0){
     2f0:	02054263          	bltz	a0,314 <reparent+0x4e>
    if(pid){
     2f4:	cd21                	beqz	a0,34c <reparent+0x86>
      if(wait(0) != pid){
     2f6:	4501                	li	a0,0
     2f8:	00005097          	auipc	ra,0x5
     2fc:	7bc080e7          	jalr	1980(ra) # 5ab4 <wait>
     300:	02951863          	bne	a0,s1,330 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
     304:	397d                	addiw	s2,s2,-1
     306:	fe0910e3          	bnez	s2,2e6 <reparent+0x20>
  exit(0);
     30a:	4501                	li	a0,0
     30c:	00005097          	auipc	ra,0x5
     310:	7a0080e7          	jalr	1952(ra) # 5aac <exit>
      printf("%s: fork failed\n", s);
     314:	85ce                	mv	a1,s3
     316:	00006517          	auipc	a0,0x6
     31a:	13250513          	addi	a0,a0,306 # 6448 <csem_free+0x334>
     31e:	00006097          	auipc	ra,0x6
     322:	b60080e7          	jalr	-1184(ra) # 5e7e <printf>
      exit(1);
     326:	4505                	li	a0,1
     328:	00005097          	auipc	ra,0x5
     32c:	784080e7          	jalr	1924(ra) # 5aac <exit>
        printf("%s: wait wrong pid\n", s);
     330:	85ce                	mv	a1,s3
     332:	00006517          	auipc	a0,0x6
     336:	12e50513          	addi	a0,a0,302 # 6460 <csem_free+0x34c>
     33a:	00006097          	auipc	ra,0x6
     33e:	b44080e7          	jalr	-1212(ra) # 5e7e <printf>
        exit(1);
     342:	4505                	li	a0,1
     344:	00005097          	auipc	ra,0x5
     348:	768080e7          	jalr	1896(ra) # 5aac <exit>
      int pid2 = fork();
     34c:	00005097          	auipc	ra,0x5
     350:	758080e7          	jalr	1880(ra) # 5aa4 <fork>
      if(pid2 < 0){
     354:	00054763          	bltz	a0,362 <reparent+0x9c>
      exit(0);
     358:	4501                	li	a0,0
     35a:	00005097          	auipc	ra,0x5
     35e:	752080e7          	jalr	1874(ra) # 5aac <exit>
        kill(master_pid, SIGKILL);
     362:	45a5                	li	a1,9
     364:	8552                	mv	a0,s4
     366:	00005097          	auipc	ra,0x5
     36a:	776080e7          	jalr	1910(ra) # 5adc <kill>
        exit(1);
     36e:	4505                	li	a0,1
     370:	00005097          	auipc	ra,0x5
     374:	73c080e7          	jalr	1852(ra) # 5aac <exit>

0000000000000378 <twochildren>:
{
     378:	1101                	addi	sp,sp,-32
     37a:	ec06                	sd	ra,24(sp)
     37c:	e822                	sd	s0,16(sp)
     37e:	e426                	sd	s1,8(sp)
     380:	e04a                	sd	s2,0(sp)
     382:	1000                	addi	s0,sp,32
     384:	892a                	mv	s2,a0
     386:	3e800493          	li	s1,1000
    int pid1 = fork();
     38a:	00005097          	auipc	ra,0x5
     38e:	71a080e7          	jalr	1818(ra) # 5aa4 <fork>
    if(pid1 < 0){
     392:	02054c63          	bltz	a0,3ca <twochildren+0x52>
    if(pid1 == 0){
     396:	c921                	beqz	a0,3e6 <twochildren+0x6e>
      int pid2 = fork();
     398:	00005097          	auipc	ra,0x5
     39c:	70c080e7          	jalr	1804(ra) # 5aa4 <fork>
      if(pid2 < 0){
     3a0:	04054763          	bltz	a0,3ee <twochildren+0x76>
      if(pid2 == 0){
     3a4:	c13d                	beqz	a0,40a <twochildren+0x92>
        wait(0);
     3a6:	4501                	li	a0,0
     3a8:	00005097          	auipc	ra,0x5
     3ac:	70c080e7          	jalr	1804(ra) # 5ab4 <wait>
        wait(0);
     3b0:	4501                	li	a0,0
     3b2:	00005097          	auipc	ra,0x5
     3b6:	702080e7          	jalr	1794(ra) # 5ab4 <wait>
  for(int i = 0; i < 1000; i++){
     3ba:	34fd                	addiw	s1,s1,-1
     3bc:	f4f9                	bnez	s1,38a <twochildren+0x12>
}
     3be:	60e2                	ld	ra,24(sp)
     3c0:	6442                	ld	s0,16(sp)
     3c2:	64a2                	ld	s1,8(sp)
     3c4:	6902                	ld	s2,0(sp)
     3c6:	6105                	addi	sp,sp,32
     3c8:	8082                	ret
      printf("%s: fork failed\n", s);
     3ca:	85ca                	mv	a1,s2
     3cc:	00006517          	auipc	a0,0x6
     3d0:	07c50513          	addi	a0,a0,124 # 6448 <csem_free+0x334>
     3d4:	00006097          	auipc	ra,0x6
     3d8:	aaa080e7          	jalr	-1366(ra) # 5e7e <printf>
      exit(1);
     3dc:	4505                	li	a0,1
     3de:	00005097          	auipc	ra,0x5
     3e2:	6ce080e7          	jalr	1742(ra) # 5aac <exit>
      exit(0);
     3e6:	00005097          	auipc	ra,0x5
     3ea:	6c6080e7          	jalr	1734(ra) # 5aac <exit>
        printf("%s: fork failed\n", s);
     3ee:	85ca                	mv	a1,s2
     3f0:	00006517          	auipc	a0,0x6
     3f4:	05850513          	addi	a0,a0,88 # 6448 <csem_free+0x334>
     3f8:	00006097          	auipc	ra,0x6
     3fc:	a86080e7          	jalr	-1402(ra) # 5e7e <printf>
        exit(1);
     400:	4505                	li	a0,1
     402:	00005097          	auipc	ra,0x5
     406:	6aa080e7          	jalr	1706(ra) # 5aac <exit>
        exit(0);
     40a:	00005097          	auipc	ra,0x5
     40e:	6a2080e7          	jalr	1698(ra) # 5aac <exit>

0000000000000412 <forkfork>:
{
     412:	7179                	addi	sp,sp,-48
     414:	f406                	sd	ra,40(sp)
     416:	f022                	sd	s0,32(sp)
     418:	ec26                	sd	s1,24(sp)
     41a:	1800                	addi	s0,sp,48
     41c:	84aa                	mv	s1,a0
    int pid = fork();
     41e:	00005097          	auipc	ra,0x5
     422:	686080e7          	jalr	1670(ra) # 5aa4 <fork>
    if(pid < 0){
     426:	04054163          	bltz	a0,468 <forkfork+0x56>
    if(pid == 0){
     42a:	cd29                	beqz	a0,484 <forkfork+0x72>
    int pid = fork();
     42c:	00005097          	auipc	ra,0x5
     430:	678080e7          	jalr	1656(ra) # 5aa4 <fork>
    if(pid < 0){
     434:	02054a63          	bltz	a0,468 <forkfork+0x56>
    if(pid == 0){
     438:	c531                	beqz	a0,484 <forkfork+0x72>
    wait(&xstatus);
     43a:	fdc40513          	addi	a0,s0,-36
     43e:	00005097          	auipc	ra,0x5
     442:	676080e7          	jalr	1654(ra) # 5ab4 <wait>
    if(xstatus != 0) {
     446:	fdc42783          	lw	a5,-36(s0)
     44a:	ebbd                	bnez	a5,4c0 <forkfork+0xae>
    wait(&xstatus);
     44c:	fdc40513          	addi	a0,s0,-36
     450:	00005097          	auipc	ra,0x5
     454:	664080e7          	jalr	1636(ra) # 5ab4 <wait>
    if(xstatus != 0) {
     458:	fdc42783          	lw	a5,-36(s0)
     45c:	e3b5                	bnez	a5,4c0 <forkfork+0xae>
}
     45e:	70a2                	ld	ra,40(sp)
     460:	7402                	ld	s0,32(sp)
     462:	64e2                	ld	s1,24(sp)
     464:	6145                	addi	sp,sp,48
     466:	8082                	ret
      printf("%s: fork failed", s);
     468:	85a6                	mv	a1,s1
     46a:	00006517          	auipc	a0,0x6
     46e:	02e50513          	addi	a0,a0,46 # 6498 <csem_free+0x384>
     472:	00006097          	auipc	ra,0x6
     476:	a0c080e7          	jalr	-1524(ra) # 5e7e <printf>
      exit(1);
     47a:	4505                	li	a0,1
     47c:	00005097          	auipc	ra,0x5
     480:	630080e7          	jalr	1584(ra) # 5aac <exit>
{
     484:	0c800493          	li	s1,200
        int pid1 = fork();
     488:	00005097          	auipc	ra,0x5
     48c:	61c080e7          	jalr	1564(ra) # 5aa4 <fork>
        if(pid1 < 0){
     490:	00054f63          	bltz	a0,4ae <forkfork+0x9c>
        if(pid1 == 0){
     494:	c115                	beqz	a0,4b8 <forkfork+0xa6>
        wait(0);
     496:	4501                	li	a0,0
     498:	00005097          	auipc	ra,0x5
     49c:	61c080e7          	jalr	1564(ra) # 5ab4 <wait>
      for(int j = 0; j < 200; j++){
     4a0:	34fd                	addiw	s1,s1,-1
     4a2:	f0fd                	bnez	s1,488 <forkfork+0x76>
      exit(0);
     4a4:	4501                	li	a0,0
     4a6:	00005097          	auipc	ra,0x5
     4aa:	606080e7          	jalr	1542(ra) # 5aac <exit>
          exit(1);
     4ae:	4505                	li	a0,1
     4b0:	00005097          	auipc	ra,0x5
     4b4:	5fc080e7          	jalr	1532(ra) # 5aac <exit>
          exit(0);
     4b8:	00005097          	auipc	ra,0x5
     4bc:	5f4080e7          	jalr	1524(ra) # 5aac <exit>
      printf("%s: fork in child failed", s);
     4c0:	85a6                	mv	a1,s1
     4c2:	00006517          	auipc	a0,0x6
     4c6:	fe650513          	addi	a0,a0,-26 # 64a8 <csem_free+0x394>
     4ca:	00006097          	auipc	ra,0x6
     4ce:	9b4080e7          	jalr	-1612(ra) # 5e7e <printf>
      exit(1);
     4d2:	4505                	li	a0,1
     4d4:	00005097          	auipc	ra,0x5
     4d8:	5d8080e7          	jalr	1496(ra) # 5aac <exit>

00000000000004dc <forktest>:
{
     4dc:	7179                	addi	sp,sp,-48
     4de:	f406                	sd	ra,40(sp)
     4e0:	f022                	sd	s0,32(sp)
     4e2:	ec26                	sd	s1,24(sp)
     4e4:	e84a                	sd	s2,16(sp)
     4e6:	e44e                	sd	s3,8(sp)
     4e8:	1800                	addi	s0,sp,48
     4ea:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
     4ec:	4481                	li	s1,0
     4ee:	3e800913          	li	s2,1000
    pid = fork();
     4f2:	00005097          	auipc	ra,0x5
     4f6:	5b2080e7          	jalr	1458(ra) # 5aa4 <fork>
    if(pid < 0)
     4fa:	02054863          	bltz	a0,52a <forktest+0x4e>
    if(pid == 0)
     4fe:	c115                	beqz	a0,522 <forktest+0x46>
  for(n=0; n<N; n++){
     500:	2485                	addiw	s1,s1,1
     502:	ff2498e3          	bne	s1,s2,4f2 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
     506:	85ce                	mv	a1,s3
     508:	00006517          	auipc	a0,0x6
     50c:	fd850513          	addi	a0,a0,-40 # 64e0 <csem_free+0x3cc>
     510:	00006097          	auipc	ra,0x6
     514:	96e080e7          	jalr	-1682(ra) # 5e7e <printf>
    exit(1);
     518:	4505                	li	a0,1
     51a:	00005097          	auipc	ra,0x5
     51e:	592080e7          	jalr	1426(ra) # 5aac <exit>
      exit(0);
     522:	00005097          	auipc	ra,0x5
     526:	58a080e7          	jalr	1418(ra) # 5aac <exit>
  if (n == 0) {
     52a:	cc9d                	beqz	s1,568 <forktest+0x8c>
  if(n == N){
     52c:	3e800793          	li	a5,1000
     530:	fcf48be3          	beq	s1,a5,506 <forktest+0x2a>
  for(; n > 0; n--){
     534:	00905b63          	blez	s1,54a <forktest+0x6e>
    if(wait(0) < 0){
     538:	4501                	li	a0,0
     53a:	00005097          	auipc	ra,0x5
     53e:	57a080e7          	jalr	1402(ra) # 5ab4 <wait>
     542:	04054163          	bltz	a0,584 <forktest+0xa8>
  for(; n > 0; n--){
     546:	34fd                	addiw	s1,s1,-1
     548:	f8e5                	bnez	s1,538 <forktest+0x5c>
  if(wait(0) != -1){
     54a:	4501                	li	a0,0
     54c:	00005097          	auipc	ra,0x5
     550:	568080e7          	jalr	1384(ra) # 5ab4 <wait>
     554:	57fd                	li	a5,-1
     556:	04f51563          	bne	a0,a5,5a0 <forktest+0xc4>
}
     55a:	70a2                	ld	ra,40(sp)
     55c:	7402                	ld	s0,32(sp)
     55e:	64e2                	ld	s1,24(sp)
     560:	6942                	ld	s2,16(sp)
     562:	69a2                	ld	s3,8(sp)
     564:	6145                	addi	sp,sp,48
     566:	8082                	ret
    printf("%s: no fork at all!\n", s);
     568:	85ce                	mv	a1,s3
     56a:	00006517          	auipc	a0,0x6
     56e:	f5e50513          	addi	a0,a0,-162 # 64c8 <csem_free+0x3b4>
     572:	00006097          	auipc	ra,0x6
     576:	90c080e7          	jalr	-1780(ra) # 5e7e <printf>
    exit(1);
     57a:	4505                	li	a0,1
     57c:	00005097          	auipc	ra,0x5
     580:	530080e7          	jalr	1328(ra) # 5aac <exit>
      printf("%s: wait stopped early\n", s);
     584:	85ce                	mv	a1,s3
     586:	00006517          	auipc	a0,0x6
     58a:	f8250513          	addi	a0,a0,-126 # 6508 <csem_free+0x3f4>
     58e:	00006097          	auipc	ra,0x6
     592:	8f0080e7          	jalr	-1808(ra) # 5e7e <printf>
      exit(1);
     596:	4505                	li	a0,1
     598:	00005097          	auipc	ra,0x5
     59c:	514080e7          	jalr	1300(ra) # 5aac <exit>
    printf("%s: wait got too many\n", s);
     5a0:	85ce                	mv	a1,s3
     5a2:	00006517          	auipc	a0,0x6
     5a6:	f7e50513          	addi	a0,a0,-130 # 6520 <csem_free+0x40c>
     5aa:	00006097          	auipc	ra,0x6
     5ae:	8d4080e7          	jalr	-1836(ra) # 5e7e <printf>
    exit(1);
     5b2:	4505                	li	a0,1
     5b4:	00005097          	auipc	ra,0x5
     5b8:	4f8080e7          	jalr	1272(ra) # 5aac <exit>

00000000000005bc <bsem_test>:
void bsem_test(char *s){
     5bc:	7179                	addi	sp,sp,-48
     5be:	f406                	sd	ra,40(sp)
     5c0:	f022                	sd	s0,32(sp)
     5c2:	ec26                	sd	s1,24(sp)
     5c4:	1800                	addi	s0,sp,48
    int bid = bsem_alloc();
     5c6:	00005097          	auipc	ra,0x5
     5ca:	5b6080e7          	jalr	1462(ra) # 5b7c <bsem_alloc>
     5ce:	84aa                	mv	s1,a0
    bsem_down(bid);
     5d0:	00005097          	auipc	ra,0x5
     5d4:	594080e7          	jalr	1428(ra) # 5b64 <bsem_down>
    printf("1. Parent downing semaphore\n");
     5d8:	00006517          	auipc	a0,0x6
     5dc:	f6050513          	addi	a0,a0,-160 # 6538 <csem_free+0x424>
     5e0:	00006097          	auipc	ra,0x6
     5e4:	89e080e7          	jalr	-1890(ra) # 5e7e <printf>
    if((pid = fork()) == 0){
     5e8:	00005097          	auipc	ra,0x5
     5ec:	4bc080e7          	jalr	1212(ra) # 5aa4 <fork>
     5f0:	fca42e23          	sw	a0,-36(s0)
     5f4:	c125                	beqz	a0,654 <bsem_test+0x98>
    sleep(5);
     5f6:	4515                	li	a0,5
     5f8:	00005097          	auipc	ra,0x5
     5fc:	544080e7          	jalr	1348(ra) # 5b3c <sleep>
    printf("3. Let the child wait on the semaphore...\n");
     600:	00006517          	auipc	a0,0x6
     604:	f9050513          	addi	a0,a0,-112 # 6590 <csem_free+0x47c>
     608:	00006097          	auipc	ra,0x6
     60c:	876080e7          	jalr	-1930(ra) # 5e7e <printf>
    sleep(10);
     610:	4529                	li	a0,10
     612:	00005097          	auipc	ra,0x5
     616:	52a080e7          	jalr	1322(ra) # 5b3c <sleep>
    bsem_up(bid);
     61a:	8526                	mv	a0,s1
     61c:	00005097          	auipc	ra,0x5
     620:	550080e7          	jalr	1360(ra) # 5b6c <bsem_up>
    bsem_free(bid);
     624:	8526                	mv	a0,s1
     626:	00005097          	auipc	ra,0x5
     62a:	54e080e7          	jalr	1358(ra) # 5b74 <bsem_free>
    wait(&pid);
     62e:	fdc40513          	addi	a0,s0,-36
     632:	00005097          	auipc	ra,0x5
     636:	482080e7          	jalr	1154(ra) # 5ab4 <wait>
    printf("Finished bsem test, make sure that the order of the prints is alright. Meaning (1...2...3...4)\n");
     63a:	00006517          	auipc	a0,0x6
     63e:	f8650513          	addi	a0,a0,-122 # 65c0 <csem_free+0x4ac>
     642:	00006097          	auipc	ra,0x6
     646:	83c080e7          	jalr	-1988(ra) # 5e7e <printf>
}
     64a:	70a2                	ld	ra,40(sp)
     64c:	7402                	ld	s0,32(sp)
     64e:	64e2                	ld	s1,24(sp)
     650:	6145                	addi	sp,sp,48
     652:	8082                	ret
        printf("2. Child downing semaphore\n");
     654:	00006517          	auipc	a0,0x6
     658:	f0450513          	addi	a0,a0,-252 # 6558 <csem_free+0x444>
     65c:	00006097          	auipc	ra,0x6
     660:	822080e7          	jalr	-2014(ra) # 5e7e <printf>
        bsem_down(bid);
     664:	8526                	mv	a0,s1
     666:	00005097          	auipc	ra,0x5
     66a:	4fe080e7          	jalr	1278(ra) # 5b64 <bsem_down>
        printf("4. Child woke up\n");
     66e:	00006517          	auipc	a0,0x6
     672:	f0a50513          	addi	a0,a0,-246 # 6578 <csem_free+0x464>
     676:	00006097          	auipc	ra,0x6
     67a:	808080e7          	jalr	-2040(ra) # 5e7e <printf>
        exit(0);
     67e:	4501                	li	a0,0
     680:	00005097          	auipc	ra,0x5
     684:	42c080e7          	jalr	1068(ra) # 5aac <exit>

0000000000000688 <Csem_test>:
void Csem_test(char *s){
     688:	7179                	addi	sp,sp,-48
     68a:	f406                	sd	ra,40(sp)
     68c:	f022                	sd	s0,32(sp)
     68e:	1800                	addi	s0,sp,48
    retval = csem_alloc(&csem,1);
     690:	4585                	li	a1,1
     692:	fe040513          	addi	a0,s0,-32
     696:	00006097          	auipc	ra,0x6
     69a:	a20080e7          	jalr	-1504(ra) # 60b6 <csem_alloc>
    if(retval==-1)
     69e:	57fd                	li	a5,-1
     6a0:	08f50763          	beq	a0,a5,72e <Csem_test+0xa6>
    csem_down(&csem);
     6a4:	fe040513          	addi	a0,s0,-32
     6a8:	00006097          	auipc	ra,0x6
     6ac:	97a080e7          	jalr	-1670(ra) # 6022 <csem_down>
    printf("1. Parent downing semaphore\n");
     6b0:	00006517          	auipc	a0,0x6
     6b4:	e8850513          	addi	a0,a0,-376 # 6538 <csem_free+0x424>
     6b8:	00005097          	auipc	ra,0x5
     6bc:	7c6080e7          	jalr	1990(ra) # 5e7e <printf>
    if((pid = fork()) == 0){
     6c0:	00005097          	auipc	ra,0x5
     6c4:	3e4080e7          	jalr	996(ra) # 5aa4 <fork>
     6c8:	fca42e23          	sw	a0,-36(s0)
     6cc:	cd35                	beqz	a0,748 <Csem_test+0xc0>
    sleep(5);
     6ce:	4515                	li	a0,5
     6d0:	00005097          	auipc	ra,0x5
     6d4:	46c080e7          	jalr	1132(ra) # 5b3c <sleep>
    printf("3. Let the child wait on the semaphore...\n");
     6d8:	00006517          	auipc	a0,0x6
     6dc:	eb850513          	addi	a0,a0,-328 # 6590 <csem_free+0x47c>
     6e0:	00005097          	auipc	ra,0x5
     6e4:	79e080e7          	jalr	1950(ra) # 5e7e <printf>
    sleep(10);
     6e8:	4529                	li	a0,10
     6ea:	00005097          	auipc	ra,0x5
     6ee:	452080e7          	jalr	1106(ra) # 5b3c <sleep>
    csem_up(&csem);
     6f2:	fe040513          	addi	a0,s0,-32
     6f6:	00006097          	auipc	ra,0x6
     6fa:	97a080e7          	jalr	-1670(ra) # 6070 <csem_up>
    csem_free(&csem);
     6fe:	fe040513          	addi	a0,s0,-32
     702:	00006097          	auipc	ra,0x6
     706:	a12080e7          	jalr	-1518(ra) # 6114 <csem_free>
    wait(&pid);
     70a:	fdc40513          	addi	a0,s0,-36
     70e:	00005097          	auipc	ra,0x5
     712:	3a6080e7          	jalr	934(ra) # 5ab4 <wait>
    printf("Finished bsem test, make sure that the order of the prints is alright. Meaning (1...2...3...4)\n");
     716:	00006517          	auipc	a0,0x6
     71a:	eaa50513          	addi	a0,a0,-342 # 65c0 <csem_free+0x4ac>
     71e:	00005097          	auipc	ra,0x5
     722:	760080e7          	jalr	1888(ra) # 5e7e <printf>
}
     726:	70a2                	ld	ra,40(sp)
     728:	7402                	ld	s0,32(sp)
     72a:	6145                	addi	sp,sp,48
     72c:	8082                	ret
		printf("failed csem alloc");
     72e:	00006517          	auipc	a0,0x6
     732:	ef250513          	addi	a0,a0,-270 # 6620 <csem_free+0x50c>
     736:	00005097          	auipc	ra,0x5
     73a:	748080e7          	jalr	1864(ra) # 5e7e <printf>
		exit(-1);
     73e:	557d                	li	a0,-1
     740:	00005097          	auipc	ra,0x5
     744:	36c080e7          	jalr	876(ra) # 5aac <exit>
        printf("2. Child downing semaphore\n");
     748:	00006517          	auipc	a0,0x6
     74c:	e1050513          	addi	a0,a0,-496 # 6558 <csem_free+0x444>
     750:	00005097          	auipc	ra,0x5
     754:	72e080e7          	jalr	1838(ra) # 5e7e <printf>
        csem_down(&csem);
     758:	fe040513          	addi	a0,s0,-32
     75c:	00006097          	auipc	ra,0x6
     760:	8c6080e7          	jalr	-1850(ra) # 6022 <csem_down>
        printf("4. Child woke up\n");
     764:	00006517          	auipc	a0,0x6
     768:	e1450513          	addi	a0,a0,-492 # 6578 <csem_free+0x464>
     76c:	00005097          	auipc	ra,0x5
     770:	712080e7          	jalr	1810(ra) # 5e7e <printf>
        exit(0);
     774:	4501                	li	a0,0
     776:	00005097          	auipc	ra,0x5
     77a:	336080e7          	jalr	822(ra) # 5aac <exit>

000000000000077e <copyinstr1>:
{
     77e:	1141                	addi	sp,sp,-16
     780:	e406                	sd	ra,8(sp)
     782:	e022                	sd	s0,0(sp)
     784:	0800                	addi	s0,sp,16
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
     786:	20100593          	li	a1,513
     78a:	4505                	li	a0,1
     78c:	057e                	slli	a0,a0,0x1f
     78e:	00005097          	auipc	ra,0x5
     792:	35e080e7          	jalr	862(ra) # 5aec <open>
    if(fd >= 0){
     796:	02055063          	bgez	a0,7b6 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
     79a:	20100593          	li	a1,513
     79e:	557d                	li	a0,-1
     7a0:	00005097          	auipc	ra,0x5
     7a4:	34c080e7          	jalr	844(ra) # 5aec <open>
    uint64 addr = addrs[ai];
     7a8:	55fd                	li	a1,-1
    if(fd >= 0){
     7aa:	00055863          	bgez	a0,7ba <copyinstr1+0x3c>
}
     7ae:	60a2                	ld	ra,8(sp)
     7b0:	6402                	ld	s0,0(sp)
     7b2:	0141                	addi	sp,sp,16
     7b4:	8082                	ret
    uint64 addr = addrs[ai];
     7b6:	4585                	li	a1,1
     7b8:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
     7ba:	862a                	mv	a2,a0
     7bc:	00006517          	auipc	a0,0x6
     7c0:	e7c50513          	addi	a0,a0,-388 # 6638 <csem_free+0x524>
     7c4:	00005097          	auipc	ra,0x5
     7c8:	6ba080e7          	jalr	1722(ra) # 5e7e <printf>
      exit(1);
     7cc:	4505                	li	a0,1
     7ce:	00005097          	auipc	ra,0x5
     7d2:	2de080e7          	jalr	734(ra) # 5aac <exit>

00000000000007d6 <opentest>:
{
     7d6:	1101                	addi	sp,sp,-32
     7d8:	ec06                	sd	ra,24(sp)
     7da:	e822                	sd	s0,16(sp)
     7dc:	e426                	sd	s1,8(sp)
     7de:	1000                	addi	s0,sp,32
     7e0:	84aa                	mv	s1,a0
  fd = open("echo", 0);
     7e2:	4581                	li	a1,0
     7e4:	00006517          	auipc	a0,0x6
     7e8:	e7450513          	addi	a0,a0,-396 # 6658 <csem_free+0x544>
     7ec:	00005097          	auipc	ra,0x5
     7f0:	300080e7          	jalr	768(ra) # 5aec <open>
  if(fd < 0){
     7f4:	02054663          	bltz	a0,820 <opentest+0x4a>
  close(fd);
     7f8:	00005097          	auipc	ra,0x5
     7fc:	2dc080e7          	jalr	732(ra) # 5ad4 <close>
  fd = open("doesnotexist", 0);
     800:	4581                	li	a1,0
     802:	00006517          	auipc	a0,0x6
     806:	e7650513          	addi	a0,a0,-394 # 6678 <csem_free+0x564>
     80a:	00005097          	auipc	ra,0x5
     80e:	2e2080e7          	jalr	738(ra) # 5aec <open>
  if(fd >= 0){
     812:	02055563          	bgez	a0,83c <opentest+0x66>
}
     816:	60e2                	ld	ra,24(sp)
     818:	6442                	ld	s0,16(sp)
     81a:	64a2                	ld	s1,8(sp)
     81c:	6105                	addi	sp,sp,32
     81e:	8082                	ret
    printf("%s: open echo failed!\n", s);
     820:	85a6                	mv	a1,s1
     822:	00006517          	auipc	a0,0x6
     826:	e3e50513          	addi	a0,a0,-450 # 6660 <csem_free+0x54c>
     82a:	00005097          	auipc	ra,0x5
     82e:	654080e7          	jalr	1620(ra) # 5e7e <printf>
    exit(1);
     832:	4505                	li	a0,1
     834:	00005097          	auipc	ra,0x5
     838:	278080e7          	jalr	632(ra) # 5aac <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     83c:	85a6                	mv	a1,s1
     83e:	00006517          	auipc	a0,0x6
     842:	e4a50513          	addi	a0,a0,-438 # 6688 <csem_free+0x574>
     846:	00005097          	auipc	ra,0x5
     84a:	638080e7          	jalr	1592(ra) # 5e7e <printf>
    exit(1);
     84e:	4505                	li	a0,1
     850:	00005097          	auipc	ra,0x5
     854:	25c080e7          	jalr	604(ra) # 5aac <exit>

0000000000000858 <truncate2>:
{
     858:	7179                	addi	sp,sp,-48
     85a:	f406                	sd	ra,40(sp)
     85c:	f022                	sd	s0,32(sp)
     85e:	ec26                	sd	s1,24(sp)
     860:	e84a                	sd	s2,16(sp)
     862:	e44e                	sd	s3,8(sp)
     864:	1800                	addi	s0,sp,48
     866:	89aa                	mv	s3,a0
  unlink("truncfile");
     868:	00006517          	auipc	a0,0x6
     86c:	e4850513          	addi	a0,a0,-440 # 66b0 <csem_free+0x59c>
     870:	00005097          	auipc	ra,0x5
     874:	28c080e7          	jalr	652(ra) # 5afc <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     878:	60100593          	li	a1,1537
     87c:	00006517          	auipc	a0,0x6
     880:	e3450513          	addi	a0,a0,-460 # 66b0 <csem_free+0x59c>
     884:	00005097          	auipc	ra,0x5
     888:	268080e7          	jalr	616(ra) # 5aec <open>
     88c:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     88e:	4611                	li	a2,4
     890:	00006597          	auipc	a1,0x6
     894:	e3058593          	addi	a1,a1,-464 # 66c0 <csem_free+0x5ac>
     898:	00005097          	auipc	ra,0x5
     89c:	234080e7          	jalr	564(ra) # 5acc <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     8a0:	40100593          	li	a1,1025
     8a4:	00006517          	auipc	a0,0x6
     8a8:	e0c50513          	addi	a0,a0,-500 # 66b0 <csem_free+0x59c>
     8ac:	00005097          	auipc	ra,0x5
     8b0:	240080e7          	jalr	576(ra) # 5aec <open>
     8b4:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     8b6:	4605                	li	a2,1
     8b8:	00006597          	auipc	a1,0x6
     8bc:	e1058593          	addi	a1,a1,-496 # 66c8 <csem_free+0x5b4>
     8c0:	8526                	mv	a0,s1
     8c2:	00005097          	auipc	ra,0x5
     8c6:	20a080e7          	jalr	522(ra) # 5acc <write>
  if(n != -1){
     8ca:	57fd                	li	a5,-1
     8cc:	02f51b63          	bne	a0,a5,902 <truncate2+0xaa>
  unlink("truncfile");
     8d0:	00006517          	auipc	a0,0x6
     8d4:	de050513          	addi	a0,a0,-544 # 66b0 <csem_free+0x59c>
     8d8:	00005097          	auipc	ra,0x5
     8dc:	224080e7          	jalr	548(ra) # 5afc <unlink>
  close(fd1);
     8e0:	8526                	mv	a0,s1
     8e2:	00005097          	auipc	ra,0x5
     8e6:	1f2080e7          	jalr	498(ra) # 5ad4 <close>
  close(fd2);
     8ea:	854a                	mv	a0,s2
     8ec:	00005097          	auipc	ra,0x5
     8f0:	1e8080e7          	jalr	488(ra) # 5ad4 <close>
}
     8f4:	70a2                	ld	ra,40(sp)
     8f6:	7402                	ld	s0,32(sp)
     8f8:	64e2                	ld	s1,24(sp)
     8fa:	6942                	ld	s2,16(sp)
     8fc:	69a2                	ld	s3,8(sp)
     8fe:	6145                	addi	sp,sp,48
     900:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     902:	862a                	mv	a2,a0
     904:	85ce                	mv	a1,s3
     906:	00006517          	auipc	a0,0x6
     90a:	dca50513          	addi	a0,a0,-566 # 66d0 <csem_free+0x5bc>
     90e:	00005097          	auipc	ra,0x5
     912:	570080e7          	jalr	1392(ra) # 5e7e <printf>
    exit(1);
     916:	4505                	li	a0,1
     918:	00005097          	auipc	ra,0x5
     91c:	194080e7          	jalr	404(ra) # 5aac <exit>

0000000000000920 <forkforkfork>:
{
     920:	1101                	addi	sp,sp,-32
     922:	ec06                	sd	ra,24(sp)
     924:	e822                	sd	s0,16(sp)
     926:	e426                	sd	s1,8(sp)
     928:	1000                	addi	s0,sp,32
     92a:	84aa                	mv	s1,a0
  unlink("stopforking");
     92c:	00006517          	auipc	a0,0x6
     930:	dcc50513          	addi	a0,a0,-564 # 66f8 <csem_free+0x5e4>
     934:	00005097          	auipc	ra,0x5
     938:	1c8080e7          	jalr	456(ra) # 5afc <unlink>
  int pid = fork();
     93c:	00005097          	auipc	ra,0x5
     940:	168080e7          	jalr	360(ra) # 5aa4 <fork>
  if(pid < 0){
     944:	04054563          	bltz	a0,98e <forkforkfork+0x6e>
  if(pid == 0){
     948:	c12d                	beqz	a0,9aa <forkforkfork+0x8a>
  sleep(20); // two seconds
     94a:	4551                	li	a0,20
     94c:	00005097          	auipc	ra,0x5
     950:	1f0080e7          	jalr	496(ra) # 5b3c <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
     954:	20200593          	li	a1,514
     958:	00006517          	auipc	a0,0x6
     95c:	da050513          	addi	a0,a0,-608 # 66f8 <csem_free+0x5e4>
     960:	00005097          	auipc	ra,0x5
     964:	18c080e7          	jalr	396(ra) # 5aec <open>
     968:	00005097          	auipc	ra,0x5
     96c:	16c080e7          	jalr	364(ra) # 5ad4 <close>
  wait(0);
     970:	4501                	li	a0,0
     972:	00005097          	auipc	ra,0x5
     976:	142080e7          	jalr	322(ra) # 5ab4 <wait>
  sleep(10); // one second
     97a:	4529                	li	a0,10
     97c:	00005097          	auipc	ra,0x5
     980:	1c0080e7          	jalr	448(ra) # 5b3c <sleep>
}
     984:	60e2                	ld	ra,24(sp)
     986:	6442                	ld	s0,16(sp)
     988:	64a2                	ld	s1,8(sp)
     98a:	6105                	addi	sp,sp,32
     98c:	8082                	ret
    printf("%s: fork failed", s);
     98e:	85a6                	mv	a1,s1
     990:	00006517          	auipc	a0,0x6
     994:	b0850513          	addi	a0,a0,-1272 # 6498 <csem_free+0x384>
     998:	00005097          	auipc	ra,0x5
     99c:	4e6080e7          	jalr	1254(ra) # 5e7e <printf>
    exit(1);
     9a0:	4505                	li	a0,1
     9a2:	00005097          	auipc	ra,0x5
     9a6:	10a080e7          	jalr	266(ra) # 5aac <exit>
      int fd = open("stopforking", 0);
     9aa:	00006497          	auipc	s1,0x6
     9ae:	d4e48493          	addi	s1,s1,-690 # 66f8 <csem_free+0x5e4>
     9b2:	4581                	li	a1,0
     9b4:	8526                	mv	a0,s1
     9b6:	00005097          	auipc	ra,0x5
     9ba:	136080e7          	jalr	310(ra) # 5aec <open>
      if(fd >= 0){
     9be:	02055463          	bgez	a0,9e6 <forkforkfork+0xc6>
      if(fork() < 0){
     9c2:	00005097          	auipc	ra,0x5
     9c6:	0e2080e7          	jalr	226(ra) # 5aa4 <fork>
     9ca:	fe0554e3          	bgez	a0,9b2 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
     9ce:	20200593          	li	a1,514
     9d2:	8526                	mv	a0,s1
     9d4:	00005097          	auipc	ra,0x5
     9d8:	118080e7          	jalr	280(ra) # 5aec <open>
     9dc:	00005097          	auipc	ra,0x5
     9e0:	0f8080e7          	jalr	248(ra) # 5ad4 <close>
     9e4:	b7f9                	j	9b2 <forkforkfork+0x92>
        exit(0);
     9e6:	4501                	li	a0,0
     9e8:	00005097          	auipc	ra,0x5
     9ec:	0c4080e7          	jalr	196(ra) # 5aac <exit>

00000000000009f0 <bigwrite>:
{
     9f0:	715d                	addi	sp,sp,-80
     9f2:	e486                	sd	ra,72(sp)
     9f4:	e0a2                	sd	s0,64(sp)
     9f6:	fc26                	sd	s1,56(sp)
     9f8:	f84a                	sd	s2,48(sp)
     9fa:	f44e                	sd	s3,40(sp)
     9fc:	f052                	sd	s4,32(sp)
     9fe:	ec56                	sd	s5,24(sp)
     a00:	e85a                	sd	s6,16(sp)
     a02:	e45e                	sd	s7,8(sp)
     a04:	0880                	addi	s0,sp,80
     a06:	8baa                	mv	s7,a0
  unlink("bigwrite");
     a08:	00006517          	auipc	a0,0x6
     a0c:	8b850513          	addi	a0,a0,-1864 # 62c0 <csem_free+0x1ac>
     a10:	00005097          	auipc	ra,0x5
     a14:	0ec080e7          	jalr	236(ra) # 5afc <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     a18:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     a1c:	00006a97          	auipc	s5,0x6
     a20:	8a4a8a93          	addi	s5,s5,-1884 # 62c0 <csem_free+0x1ac>
      int cc = write(fd, buf, sz);
     a24:	0000ba17          	auipc	s4,0xb
     a28:	6bca0a13          	addi	s4,s4,1724 # c0e0 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     a2c:	6b0d                	lui	s6,0x3
     a2e:	1c9b0b13          	addi	s6,s6,457 # 31c9 <fourfiles+0x4d>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     a32:	20200593          	li	a1,514
     a36:	8556                	mv	a0,s5
     a38:	00005097          	auipc	ra,0x5
     a3c:	0b4080e7          	jalr	180(ra) # 5aec <open>
     a40:	892a                	mv	s2,a0
    if(fd < 0){
     a42:	04054d63          	bltz	a0,a9c <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     a46:	8626                	mv	a2,s1
     a48:	85d2                	mv	a1,s4
     a4a:	00005097          	auipc	ra,0x5
     a4e:	082080e7          	jalr	130(ra) # 5acc <write>
     a52:	89aa                	mv	s3,a0
      if(cc != sz){
     a54:	06a49463          	bne	s1,a0,abc <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     a58:	8626                	mv	a2,s1
     a5a:	85d2                	mv	a1,s4
     a5c:	854a                	mv	a0,s2
     a5e:	00005097          	auipc	ra,0x5
     a62:	06e080e7          	jalr	110(ra) # 5acc <write>
      if(cc != sz){
     a66:	04951963          	bne	a0,s1,ab8 <bigwrite+0xc8>
    close(fd);
     a6a:	854a                	mv	a0,s2
     a6c:	00005097          	auipc	ra,0x5
     a70:	068080e7          	jalr	104(ra) # 5ad4 <close>
    unlink("bigwrite");
     a74:	8556                	mv	a0,s5
     a76:	00005097          	auipc	ra,0x5
     a7a:	086080e7          	jalr	134(ra) # 5afc <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     a7e:	1d74849b          	addiw	s1,s1,471
     a82:	fb6498e3          	bne	s1,s6,a32 <bigwrite+0x42>
}
     a86:	60a6                	ld	ra,72(sp)
     a88:	6406                	ld	s0,64(sp)
     a8a:	74e2                	ld	s1,56(sp)
     a8c:	7942                	ld	s2,48(sp)
     a8e:	79a2                	ld	s3,40(sp)
     a90:	7a02                	ld	s4,32(sp)
     a92:	6ae2                	ld	s5,24(sp)
     a94:	6b42                	ld	s6,16(sp)
     a96:	6ba2                	ld	s7,8(sp)
     a98:	6161                	addi	sp,sp,80
     a9a:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     a9c:	85de                	mv	a1,s7
     a9e:	00006517          	auipc	a0,0x6
     aa2:	c6a50513          	addi	a0,a0,-918 # 6708 <csem_free+0x5f4>
     aa6:	00005097          	auipc	ra,0x5
     aaa:	3d8080e7          	jalr	984(ra) # 5e7e <printf>
      exit(1);
     aae:	4505                	li	a0,1
     ab0:	00005097          	auipc	ra,0x5
     ab4:	ffc080e7          	jalr	-4(ra) # 5aac <exit>
     ab8:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     aba:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     abc:	86ce                	mv	a3,s3
     abe:	8626                	mv	a2,s1
     ac0:	85de                	mv	a1,s7
     ac2:	00006517          	auipc	a0,0x6
     ac6:	c6650513          	addi	a0,a0,-922 # 6728 <csem_free+0x614>
     aca:	00005097          	auipc	ra,0x5
     ace:	3b4080e7          	jalr	948(ra) # 5e7e <printf>
        exit(1);
     ad2:	4505                	li	a0,1
     ad4:	00005097          	auipc	ra,0x5
     ad8:	fd8080e7          	jalr	-40(ra) # 5aac <exit>

0000000000000adc <copyin>:
{
     adc:	715d                	addi	sp,sp,-80
     ade:	e486                	sd	ra,72(sp)
     ae0:	e0a2                	sd	s0,64(sp)
     ae2:	fc26                	sd	s1,56(sp)
     ae4:	f84a                	sd	s2,48(sp)
     ae6:	f44e                	sd	s3,40(sp)
     ae8:	f052                	sd	s4,32(sp)
     aea:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     aec:	4785                	li	a5,1
     aee:	07fe                	slli	a5,a5,0x1f
     af0:	fcf43023          	sd	a5,-64(s0)
     af4:	57fd                	li	a5,-1
     af6:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     afa:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     afe:	00006a17          	auipc	s4,0x6
     b02:	c42a0a13          	addi	s4,s4,-958 # 6740 <csem_free+0x62c>
    uint64 addr = addrs[ai];
     b06:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     b0a:	20100593          	li	a1,513
     b0e:	8552                	mv	a0,s4
     b10:	00005097          	auipc	ra,0x5
     b14:	fdc080e7          	jalr	-36(ra) # 5aec <open>
     b18:	84aa                	mv	s1,a0
    if(fd < 0){
     b1a:	08054863          	bltz	a0,baa <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     b1e:	6609                	lui	a2,0x2
     b20:	85ce                	mv	a1,s3
     b22:	00005097          	auipc	ra,0x5
     b26:	faa080e7          	jalr	-86(ra) # 5acc <write>
    if(n >= 0){
     b2a:	08055d63          	bgez	a0,bc4 <copyin+0xe8>
    close(fd);
     b2e:	8526                	mv	a0,s1
     b30:	00005097          	auipc	ra,0x5
     b34:	fa4080e7          	jalr	-92(ra) # 5ad4 <close>
    unlink("copyin1");
     b38:	8552                	mv	a0,s4
     b3a:	00005097          	auipc	ra,0x5
     b3e:	fc2080e7          	jalr	-62(ra) # 5afc <unlink>
    n = write(1, (char*)addr, 8192);
     b42:	6609                	lui	a2,0x2
     b44:	85ce                	mv	a1,s3
     b46:	4505                	li	a0,1
     b48:	00005097          	auipc	ra,0x5
     b4c:	f84080e7          	jalr	-124(ra) # 5acc <write>
    if(n > 0){
     b50:	08a04963          	bgtz	a0,be2 <copyin+0x106>
    if(pipe(fds) < 0){
     b54:	fb840513          	addi	a0,s0,-72
     b58:	00005097          	auipc	ra,0x5
     b5c:	f64080e7          	jalr	-156(ra) # 5abc <pipe>
     b60:	0a054063          	bltz	a0,c00 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     b64:	6609                	lui	a2,0x2
     b66:	85ce                	mv	a1,s3
     b68:	fbc42503          	lw	a0,-68(s0)
     b6c:	00005097          	auipc	ra,0x5
     b70:	f60080e7          	jalr	-160(ra) # 5acc <write>
    if(n > 0){
     b74:	0aa04363          	bgtz	a0,c1a <copyin+0x13e>
    close(fds[0]);
     b78:	fb842503          	lw	a0,-72(s0)
     b7c:	00005097          	auipc	ra,0x5
     b80:	f58080e7          	jalr	-168(ra) # 5ad4 <close>
    close(fds[1]);
     b84:	fbc42503          	lw	a0,-68(s0)
     b88:	00005097          	auipc	ra,0x5
     b8c:	f4c080e7          	jalr	-180(ra) # 5ad4 <close>
  for(int ai = 0; ai < 2; ai++){
     b90:	0921                	addi	s2,s2,8
     b92:	fd040793          	addi	a5,s0,-48
     b96:	f6f918e3          	bne	s2,a5,b06 <copyin+0x2a>
}
     b9a:	60a6                	ld	ra,72(sp)
     b9c:	6406                	ld	s0,64(sp)
     b9e:	74e2                	ld	s1,56(sp)
     ba0:	7942                	ld	s2,48(sp)
     ba2:	79a2                	ld	s3,40(sp)
     ba4:	7a02                	ld	s4,32(sp)
     ba6:	6161                	addi	sp,sp,80
     ba8:	8082                	ret
      printf("open(copyin1) failed\n");
     baa:	00006517          	auipc	a0,0x6
     bae:	b9e50513          	addi	a0,a0,-1122 # 6748 <csem_free+0x634>
     bb2:	00005097          	auipc	ra,0x5
     bb6:	2cc080e7          	jalr	716(ra) # 5e7e <printf>
      exit(1);
     bba:	4505                	li	a0,1
     bbc:	00005097          	auipc	ra,0x5
     bc0:	ef0080e7          	jalr	-272(ra) # 5aac <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     bc4:	862a                	mv	a2,a0
     bc6:	85ce                	mv	a1,s3
     bc8:	00006517          	auipc	a0,0x6
     bcc:	b9850513          	addi	a0,a0,-1128 # 6760 <csem_free+0x64c>
     bd0:	00005097          	auipc	ra,0x5
     bd4:	2ae080e7          	jalr	686(ra) # 5e7e <printf>
      exit(1);
     bd8:	4505                	li	a0,1
     bda:	00005097          	auipc	ra,0x5
     bde:	ed2080e7          	jalr	-302(ra) # 5aac <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     be2:	862a                	mv	a2,a0
     be4:	85ce                	mv	a1,s3
     be6:	00006517          	auipc	a0,0x6
     bea:	baa50513          	addi	a0,a0,-1110 # 6790 <csem_free+0x67c>
     bee:	00005097          	auipc	ra,0x5
     bf2:	290080e7          	jalr	656(ra) # 5e7e <printf>
      exit(1);
     bf6:	4505                	li	a0,1
     bf8:	00005097          	auipc	ra,0x5
     bfc:	eb4080e7          	jalr	-332(ra) # 5aac <exit>
      printf("pipe() failed\n");
     c00:	00006517          	auipc	a0,0x6
     c04:	bc050513          	addi	a0,a0,-1088 # 67c0 <csem_free+0x6ac>
     c08:	00005097          	auipc	ra,0x5
     c0c:	276080e7          	jalr	630(ra) # 5e7e <printf>
      exit(1);
     c10:	4505                	li	a0,1
     c12:	00005097          	auipc	ra,0x5
     c16:	e9a080e7          	jalr	-358(ra) # 5aac <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     c1a:	862a                	mv	a2,a0
     c1c:	85ce                	mv	a1,s3
     c1e:	00006517          	auipc	a0,0x6
     c22:	bb250513          	addi	a0,a0,-1102 # 67d0 <csem_free+0x6bc>
     c26:	00005097          	auipc	ra,0x5
     c2a:	258080e7          	jalr	600(ra) # 5e7e <printf>
      exit(1);
     c2e:	4505                	li	a0,1
     c30:	00005097          	auipc	ra,0x5
     c34:	e7c080e7          	jalr	-388(ra) # 5aac <exit>

0000000000000c38 <copyout>:
{
     c38:	711d                	addi	sp,sp,-96
     c3a:	ec86                	sd	ra,88(sp)
     c3c:	e8a2                	sd	s0,80(sp)
     c3e:	e4a6                	sd	s1,72(sp)
     c40:	e0ca                	sd	s2,64(sp)
     c42:	fc4e                	sd	s3,56(sp)
     c44:	f852                	sd	s4,48(sp)
     c46:	f456                	sd	s5,40(sp)
     c48:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     c4a:	4785                	li	a5,1
     c4c:	07fe                	slli	a5,a5,0x1f
     c4e:	faf43823          	sd	a5,-80(s0)
     c52:	57fd                	li	a5,-1
     c54:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     c58:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     c5c:	00006a17          	auipc	s4,0x6
     c60:	ba4a0a13          	addi	s4,s4,-1116 # 6800 <csem_free+0x6ec>
    n = write(fds[1], "x", 1);
     c64:	00006a97          	auipc	s5,0x6
     c68:	a64a8a93          	addi	s5,s5,-1436 # 66c8 <csem_free+0x5b4>
    uint64 addr = addrs[ai];
     c6c:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     c70:	4581                	li	a1,0
     c72:	8552                	mv	a0,s4
     c74:	00005097          	auipc	ra,0x5
     c78:	e78080e7          	jalr	-392(ra) # 5aec <open>
     c7c:	84aa                	mv	s1,a0
    if(fd < 0){
     c7e:	08054663          	bltz	a0,d0a <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     c82:	6609                	lui	a2,0x2
     c84:	85ce                	mv	a1,s3
     c86:	00005097          	auipc	ra,0x5
     c8a:	e3e080e7          	jalr	-450(ra) # 5ac4 <read>
    if(n > 0){
     c8e:	08a04b63          	bgtz	a0,d24 <copyout+0xec>
    close(fd);
     c92:	8526                	mv	a0,s1
     c94:	00005097          	auipc	ra,0x5
     c98:	e40080e7          	jalr	-448(ra) # 5ad4 <close>
    if(pipe(fds) < 0){
     c9c:	fa840513          	addi	a0,s0,-88
     ca0:	00005097          	auipc	ra,0x5
     ca4:	e1c080e7          	jalr	-484(ra) # 5abc <pipe>
     ca8:	08054d63          	bltz	a0,d42 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     cac:	4605                	li	a2,1
     cae:	85d6                	mv	a1,s5
     cb0:	fac42503          	lw	a0,-84(s0)
     cb4:	00005097          	auipc	ra,0x5
     cb8:	e18080e7          	jalr	-488(ra) # 5acc <write>
    if(n != 1){
     cbc:	4785                	li	a5,1
     cbe:	08f51f63          	bne	a0,a5,d5c <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     cc2:	6609                	lui	a2,0x2
     cc4:	85ce                	mv	a1,s3
     cc6:	fa842503          	lw	a0,-88(s0)
     cca:	00005097          	auipc	ra,0x5
     cce:	dfa080e7          	jalr	-518(ra) # 5ac4 <read>
    if(n > 0){
     cd2:	0aa04263          	bgtz	a0,d76 <copyout+0x13e>
    close(fds[0]);
     cd6:	fa842503          	lw	a0,-88(s0)
     cda:	00005097          	auipc	ra,0x5
     cde:	dfa080e7          	jalr	-518(ra) # 5ad4 <close>
    close(fds[1]);
     ce2:	fac42503          	lw	a0,-84(s0)
     ce6:	00005097          	auipc	ra,0x5
     cea:	dee080e7          	jalr	-530(ra) # 5ad4 <close>
  for(int ai = 0; ai < 2; ai++){
     cee:	0921                	addi	s2,s2,8
     cf0:	fc040793          	addi	a5,s0,-64
     cf4:	f6f91ce3          	bne	s2,a5,c6c <copyout+0x34>
}
     cf8:	60e6                	ld	ra,88(sp)
     cfa:	6446                	ld	s0,80(sp)
     cfc:	64a6                	ld	s1,72(sp)
     cfe:	6906                	ld	s2,64(sp)
     d00:	79e2                	ld	s3,56(sp)
     d02:	7a42                	ld	s4,48(sp)
     d04:	7aa2                	ld	s5,40(sp)
     d06:	6125                	addi	sp,sp,96
     d08:	8082                	ret
      printf("open(README) failed\n");
     d0a:	00006517          	auipc	a0,0x6
     d0e:	afe50513          	addi	a0,a0,-1282 # 6808 <csem_free+0x6f4>
     d12:	00005097          	auipc	ra,0x5
     d16:	16c080e7          	jalr	364(ra) # 5e7e <printf>
      exit(1);
     d1a:	4505                	li	a0,1
     d1c:	00005097          	auipc	ra,0x5
     d20:	d90080e7          	jalr	-624(ra) # 5aac <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     d24:	862a                	mv	a2,a0
     d26:	85ce                	mv	a1,s3
     d28:	00006517          	auipc	a0,0x6
     d2c:	af850513          	addi	a0,a0,-1288 # 6820 <csem_free+0x70c>
     d30:	00005097          	auipc	ra,0x5
     d34:	14e080e7          	jalr	334(ra) # 5e7e <printf>
      exit(1);
     d38:	4505                	li	a0,1
     d3a:	00005097          	auipc	ra,0x5
     d3e:	d72080e7          	jalr	-654(ra) # 5aac <exit>
      printf("pipe() failed\n");
     d42:	00006517          	auipc	a0,0x6
     d46:	a7e50513          	addi	a0,a0,-1410 # 67c0 <csem_free+0x6ac>
     d4a:	00005097          	auipc	ra,0x5
     d4e:	134080e7          	jalr	308(ra) # 5e7e <printf>
      exit(1);
     d52:	4505                	li	a0,1
     d54:	00005097          	auipc	ra,0x5
     d58:	d58080e7          	jalr	-680(ra) # 5aac <exit>
      printf("pipe write failed\n");
     d5c:	00006517          	auipc	a0,0x6
     d60:	af450513          	addi	a0,a0,-1292 # 6850 <csem_free+0x73c>
     d64:	00005097          	auipc	ra,0x5
     d68:	11a080e7          	jalr	282(ra) # 5e7e <printf>
      exit(1);
     d6c:	4505                	li	a0,1
     d6e:	00005097          	auipc	ra,0x5
     d72:	d3e080e7          	jalr	-706(ra) # 5aac <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     d76:	862a                	mv	a2,a0
     d78:	85ce                	mv	a1,s3
     d7a:	00006517          	auipc	a0,0x6
     d7e:	aee50513          	addi	a0,a0,-1298 # 6868 <csem_free+0x754>
     d82:	00005097          	auipc	ra,0x5
     d86:	0fc080e7          	jalr	252(ra) # 5e7e <printf>
      exit(1);
     d8a:	4505                	li	a0,1
     d8c:	00005097          	auipc	ra,0x5
     d90:	d20080e7          	jalr	-736(ra) # 5aac <exit>

0000000000000d94 <truncate1>:
{
     d94:	711d                	addi	sp,sp,-96
     d96:	ec86                	sd	ra,88(sp)
     d98:	e8a2                	sd	s0,80(sp)
     d9a:	e4a6                	sd	s1,72(sp)
     d9c:	e0ca                	sd	s2,64(sp)
     d9e:	fc4e                	sd	s3,56(sp)
     da0:	f852                	sd	s4,48(sp)
     da2:	f456                	sd	s5,40(sp)
     da4:	1080                	addi	s0,sp,96
     da6:	8aaa                	mv	s5,a0
  unlink("truncfile");
     da8:	00006517          	auipc	a0,0x6
     dac:	90850513          	addi	a0,a0,-1784 # 66b0 <csem_free+0x59c>
     db0:	00005097          	auipc	ra,0x5
     db4:	d4c080e7          	jalr	-692(ra) # 5afc <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     db8:	60100593          	li	a1,1537
     dbc:	00006517          	auipc	a0,0x6
     dc0:	8f450513          	addi	a0,a0,-1804 # 66b0 <csem_free+0x59c>
     dc4:	00005097          	auipc	ra,0x5
     dc8:	d28080e7          	jalr	-728(ra) # 5aec <open>
     dcc:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     dce:	4611                	li	a2,4
     dd0:	00006597          	auipc	a1,0x6
     dd4:	8f058593          	addi	a1,a1,-1808 # 66c0 <csem_free+0x5ac>
     dd8:	00005097          	auipc	ra,0x5
     ddc:	cf4080e7          	jalr	-780(ra) # 5acc <write>
  close(fd1);
     de0:	8526                	mv	a0,s1
     de2:	00005097          	auipc	ra,0x5
     de6:	cf2080e7          	jalr	-782(ra) # 5ad4 <close>
  int fd2 = open("truncfile", O_RDONLY);
     dea:	4581                	li	a1,0
     dec:	00006517          	auipc	a0,0x6
     df0:	8c450513          	addi	a0,a0,-1852 # 66b0 <csem_free+0x59c>
     df4:	00005097          	auipc	ra,0x5
     df8:	cf8080e7          	jalr	-776(ra) # 5aec <open>
     dfc:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     dfe:	02000613          	li	a2,32
     e02:	fa040593          	addi	a1,s0,-96
     e06:	00005097          	auipc	ra,0x5
     e0a:	cbe080e7          	jalr	-834(ra) # 5ac4 <read>
  if(n != 4){
     e0e:	4791                	li	a5,4
     e10:	0cf51e63          	bne	a0,a5,eec <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     e14:	40100593          	li	a1,1025
     e18:	00006517          	auipc	a0,0x6
     e1c:	89850513          	addi	a0,a0,-1896 # 66b0 <csem_free+0x59c>
     e20:	00005097          	auipc	ra,0x5
     e24:	ccc080e7          	jalr	-820(ra) # 5aec <open>
     e28:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     e2a:	4581                	li	a1,0
     e2c:	00006517          	auipc	a0,0x6
     e30:	88450513          	addi	a0,a0,-1916 # 66b0 <csem_free+0x59c>
     e34:	00005097          	auipc	ra,0x5
     e38:	cb8080e7          	jalr	-840(ra) # 5aec <open>
     e3c:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     e3e:	02000613          	li	a2,32
     e42:	fa040593          	addi	a1,s0,-96
     e46:	00005097          	auipc	ra,0x5
     e4a:	c7e080e7          	jalr	-898(ra) # 5ac4 <read>
     e4e:	8a2a                	mv	s4,a0
  if(n != 0){
     e50:	ed4d                	bnez	a0,f0a <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     e52:	02000613          	li	a2,32
     e56:	fa040593          	addi	a1,s0,-96
     e5a:	8526                	mv	a0,s1
     e5c:	00005097          	auipc	ra,0x5
     e60:	c68080e7          	jalr	-920(ra) # 5ac4 <read>
     e64:	8a2a                	mv	s4,a0
  if(n != 0){
     e66:	e971                	bnez	a0,f3a <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     e68:	4619                	li	a2,6
     e6a:	00006597          	auipc	a1,0x6
     e6e:	a8e58593          	addi	a1,a1,-1394 # 68f8 <csem_free+0x7e4>
     e72:	854e                	mv	a0,s3
     e74:	00005097          	auipc	ra,0x5
     e78:	c58080e7          	jalr	-936(ra) # 5acc <write>
  n = read(fd3, buf, sizeof(buf));
     e7c:	02000613          	li	a2,32
     e80:	fa040593          	addi	a1,s0,-96
     e84:	854a                	mv	a0,s2
     e86:	00005097          	auipc	ra,0x5
     e8a:	c3e080e7          	jalr	-962(ra) # 5ac4 <read>
  if(n != 6){
     e8e:	4799                	li	a5,6
     e90:	0cf51d63          	bne	a0,a5,f6a <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     e94:	02000613          	li	a2,32
     e98:	fa040593          	addi	a1,s0,-96
     e9c:	8526                	mv	a0,s1
     e9e:	00005097          	auipc	ra,0x5
     ea2:	c26080e7          	jalr	-986(ra) # 5ac4 <read>
  if(n != 2){
     ea6:	4789                	li	a5,2
     ea8:	0ef51063          	bne	a0,a5,f88 <truncate1+0x1f4>
  unlink("truncfile");
     eac:	00006517          	auipc	a0,0x6
     eb0:	80450513          	addi	a0,a0,-2044 # 66b0 <csem_free+0x59c>
     eb4:	00005097          	auipc	ra,0x5
     eb8:	c48080e7          	jalr	-952(ra) # 5afc <unlink>
  close(fd1);
     ebc:	854e                	mv	a0,s3
     ebe:	00005097          	auipc	ra,0x5
     ec2:	c16080e7          	jalr	-1002(ra) # 5ad4 <close>
  close(fd2);
     ec6:	8526                	mv	a0,s1
     ec8:	00005097          	auipc	ra,0x5
     ecc:	c0c080e7          	jalr	-1012(ra) # 5ad4 <close>
  close(fd3);
     ed0:	854a                	mv	a0,s2
     ed2:	00005097          	auipc	ra,0x5
     ed6:	c02080e7          	jalr	-1022(ra) # 5ad4 <close>
}
     eda:	60e6                	ld	ra,88(sp)
     edc:	6446                	ld	s0,80(sp)
     ede:	64a6                	ld	s1,72(sp)
     ee0:	6906                	ld	s2,64(sp)
     ee2:	79e2                	ld	s3,56(sp)
     ee4:	7a42                	ld	s4,48(sp)
     ee6:	7aa2                	ld	s5,40(sp)
     ee8:	6125                	addi	sp,sp,96
     eea:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     eec:	862a                	mv	a2,a0
     eee:	85d6                	mv	a1,s5
     ef0:	00006517          	auipc	a0,0x6
     ef4:	9a850513          	addi	a0,a0,-1624 # 6898 <csem_free+0x784>
     ef8:	00005097          	auipc	ra,0x5
     efc:	f86080e7          	jalr	-122(ra) # 5e7e <printf>
    exit(1);
     f00:	4505                	li	a0,1
     f02:	00005097          	auipc	ra,0x5
     f06:	baa080e7          	jalr	-1110(ra) # 5aac <exit>
    printf("aaa fd3=%d\n", fd3);
     f0a:	85ca                	mv	a1,s2
     f0c:	00006517          	auipc	a0,0x6
     f10:	9ac50513          	addi	a0,a0,-1620 # 68b8 <csem_free+0x7a4>
     f14:	00005097          	auipc	ra,0x5
     f18:	f6a080e7          	jalr	-150(ra) # 5e7e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     f1c:	8652                	mv	a2,s4
     f1e:	85d6                	mv	a1,s5
     f20:	00006517          	auipc	a0,0x6
     f24:	9a850513          	addi	a0,a0,-1624 # 68c8 <csem_free+0x7b4>
     f28:	00005097          	auipc	ra,0x5
     f2c:	f56080e7          	jalr	-170(ra) # 5e7e <printf>
    exit(1);
     f30:	4505                	li	a0,1
     f32:	00005097          	auipc	ra,0x5
     f36:	b7a080e7          	jalr	-1158(ra) # 5aac <exit>
    printf("bbb fd2=%d\n", fd2);
     f3a:	85a6                	mv	a1,s1
     f3c:	00006517          	auipc	a0,0x6
     f40:	9ac50513          	addi	a0,a0,-1620 # 68e8 <csem_free+0x7d4>
     f44:	00005097          	auipc	ra,0x5
     f48:	f3a080e7          	jalr	-198(ra) # 5e7e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     f4c:	8652                	mv	a2,s4
     f4e:	85d6                	mv	a1,s5
     f50:	00006517          	auipc	a0,0x6
     f54:	97850513          	addi	a0,a0,-1672 # 68c8 <csem_free+0x7b4>
     f58:	00005097          	auipc	ra,0x5
     f5c:	f26080e7          	jalr	-218(ra) # 5e7e <printf>
    exit(1);
     f60:	4505                	li	a0,1
     f62:	00005097          	auipc	ra,0x5
     f66:	b4a080e7          	jalr	-1206(ra) # 5aac <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     f6a:	862a                	mv	a2,a0
     f6c:	85d6                	mv	a1,s5
     f6e:	00006517          	auipc	a0,0x6
     f72:	99250513          	addi	a0,a0,-1646 # 6900 <csem_free+0x7ec>
     f76:	00005097          	auipc	ra,0x5
     f7a:	f08080e7          	jalr	-248(ra) # 5e7e <printf>
    exit(1);
     f7e:	4505                	li	a0,1
     f80:	00005097          	auipc	ra,0x5
     f84:	b2c080e7          	jalr	-1236(ra) # 5aac <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     f88:	862a                	mv	a2,a0
     f8a:	85d6                	mv	a1,s5
     f8c:	00006517          	auipc	a0,0x6
     f90:	99450513          	addi	a0,a0,-1644 # 6920 <csem_free+0x80c>
     f94:	00005097          	auipc	ra,0x5
     f98:	eea080e7          	jalr	-278(ra) # 5e7e <printf>
    exit(1);
     f9c:	4505                	li	a0,1
     f9e:	00005097          	auipc	ra,0x5
     fa2:	b0e080e7          	jalr	-1266(ra) # 5aac <exit>

0000000000000fa6 <pipe1>:
{
     fa6:	711d                	addi	sp,sp,-96
     fa8:	ec86                	sd	ra,88(sp)
     faa:	e8a2                	sd	s0,80(sp)
     fac:	e4a6                	sd	s1,72(sp)
     fae:	e0ca                	sd	s2,64(sp)
     fb0:	fc4e                	sd	s3,56(sp)
     fb2:	f852                	sd	s4,48(sp)
     fb4:	f456                	sd	s5,40(sp)
     fb6:	f05a                	sd	s6,32(sp)
     fb8:	ec5e                	sd	s7,24(sp)
     fba:	1080                	addi	s0,sp,96
     fbc:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
     fbe:	fa840513          	addi	a0,s0,-88
     fc2:	00005097          	auipc	ra,0x5
     fc6:	afa080e7          	jalr	-1286(ra) # 5abc <pipe>
     fca:	ed25                	bnez	a0,1042 <pipe1+0x9c>
     fcc:	84aa                	mv	s1,a0
  pid = fork();
     fce:	00005097          	auipc	ra,0x5
     fd2:	ad6080e7          	jalr	-1322(ra) # 5aa4 <fork>
     fd6:	8a2a                	mv	s4,a0
  if(pid == 0){
     fd8:	c159                	beqz	a0,105e <pipe1+0xb8>
  } else if(pid > 0){
     fda:	16a05e63          	blez	a0,1156 <pipe1+0x1b0>
    close(fds[1]);
     fde:	fac42503          	lw	a0,-84(s0)
     fe2:	00005097          	auipc	ra,0x5
     fe6:	af2080e7          	jalr	-1294(ra) # 5ad4 <close>
    total = 0;
     fea:	8a26                	mv	s4,s1
    cc = 1;
     fec:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
     fee:	0000ba97          	auipc	s5,0xb
     ff2:	0f2a8a93          	addi	s5,s5,242 # c0e0 <buf>
      if(cc > sizeof(buf))
     ff6:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
     ff8:	864e                	mv	a2,s3
     ffa:	85d6                	mv	a1,s5
     ffc:	fa842503          	lw	a0,-88(s0)
    1000:	00005097          	auipc	ra,0x5
    1004:	ac4080e7          	jalr	-1340(ra) # 5ac4 <read>
    1008:	10a05263          	blez	a0,110c <pipe1+0x166>
      for(i = 0; i < n; i++){
    100c:	0000b717          	auipc	a4,0xb
    1010:	0d470713          	addi	a4,a4,212 # c0e0 <buf>
    1014:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1018:	00074683          	lbu	a3,0(a4)
    101c:	0ff4f793          	andi	a5,s1,255
    1020:	2485                	addiw	s1,s1,1
    1022:	0cf69163          	bne	a3,a5,10e4 <pipe1+0x13e>
      for(i = 0; i < n; i++){
    1026:	0705                	addi	a4,a4,1
    1028:	fec498e3          	bne	s1,a2,1018 <pipe1+0x72>
      total += n;
    102c:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    1030:	0019979b          	slliw	a5,s3,0x1
    1034:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    1038:	013b7363          	bgeu	s6,s3,103e <pipe1+0x98>
        cc = sizeof(buf);
    103c:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    103e:	84b2                	mv	s1,a2
    1040:	bf65                	j	ff8 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    1042:	85ca                	mv	a1,s2
    1044:	00006517          	auipc	a0,0x6
    1048:	8fc50513          	addi	a0,a0,-1796 # 6940 <csem_free+0x82c>
    104c:	00005097          	auipc	ra,0x5
    1050:	e32080e7          	jalr	-462(ra) # 5e7e <printf>
    exit(1);
    1054:	4505                	li	a0,1
    1056:	00005097          	auipc	ra,0x5
    105a:	a56080e7          	jalr	-1450(ra) # 5aac <exit>
    close(fds[0]);
    105e:	fa842503          	lw	a0,-88(s0)
    1062:	00005097          	auipc	ra,0x5
    1066:	a72080e7          	jalr	-1422(ra) # 5ad4 <close>
    for(n = 0; n < N; n++){
    106a:	0000bb17          	auipc	s6,0xb
    106e:	076b0b13          	addi	s6,s6,118 # c0e0 <buf>
    1072:	416004bb          	negw	s1,s6
    1076:	0ff4f493          	andi	s1,s1,255
    107a:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    107e:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1080:	6a85                	lui	s5,0x1
    1082:	42da8a93          	addi	s5,s5,1069 # 142d <unlinkread+0x111>
{
    1086:	87da                	mv	a5,s6
        buf[i] = seq++;
    1088:	0097873b          	addw	a4,a5,s1
    108c:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1090:	0785                	addi	a5,a5,1
    1092:	fef99be3          	bne	s3,a5,1088 <pipe1+0xe2>
        buf[i] = seq++;
    1096:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    109a:	40900613          	li	a2,1033
    109e:	85de                	mv	a1,s7
    10a0:	fac42503          	lw	a0,-84(s0)
    10a4:	00005097          	auipc	ra,0x5
    10a8:	a28080e7          	jalr	-1496(ra) # 5acc <write>
    10ac:	40900793          	li	a5,1033
    10b0:	00f51c63          	bne	a0,a5,10c8 <pipe1+0x122>
    for(n = 0; n < N; n++){
    10b4:	24a5                	addiw	s1,s1,9
    10b6:	0ff4f493          	andi	s1,s1,255
    10ba:	fd5a16e3          	bne	s4,s5,1086 <pipe1+0xe0>
    exit(0);
    10be:	4501                	li	a0,0
    10c0:	00005097          	auipc	ra,0x5
    10c4:	9ec080e7          	jalr	-1556(ra) # 5aac <exit>
        printf("%s: pipe1 oops 1\n", s);
    10c8:	85ca                	mv	a1,s2
    10ca:	00006517          	auipc	a0,0x6
    10ce:	88e50513          	addi	a0,a0,-1906 # 6958 <csem_free+0x844>
    10d2:	00005097          	auipc	ra,0x5
    10d6:	dac080e7          	jalr	-596(ra) # 5e7e <printf>
        exit(1);
    10da:	4505                	li	a0,1
    10dc:	00005097          	auipc	ra,0x5
    10e0:	9d0080e7          	jalr	-1584(ra) # 5aac <exit>
          printf("%s: pipe1 oops 2\n", s);
    10e4:	85ca                	mv	a1,s2
    10e6:	00006517          	auipc	a0,0x6
    10ea:	88a50513          	addi	a0,a0,-1910 # 6970 <csem_free+0x85c>
    10ee:	00005097          	auipc	ra,0x5
    10f2:	d90080e7          	jalr	-624(ra) # 5e7e <printf>
}
    10f6:	60e6                	ld	ra,88(sp)
    10f8:	6446                	ld	s0,80(sp)
    10fa:	64a6                	ld	s1,72(sp)
    10fc:	6906                	ld	s2,64(sp)
    10fe:	79e2                	ld	s3,56(sp)
    1100:	7a42                	ld	s4,48(sp)
    1102:	7aa2                	ld	s5,40(sp)
    1104:	7b02                	ld	s6,32(sp)
    1106:	6be2                	ld	s7,24(sp)
    1108:	6125                	addi	sp,sp,96
    110a:	8082                	ret
    if(total != N * SZ){
    110c:	6785                	lui	a5,0x1
    110e:	42d78793          	addi	a5,a5,1069 # 142d <unlinkread+0x111>
    1112:	02fa0063          	beq	s4,a5,1132 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1116:	85d2                	mv	a1,s4
    1118:	00006517          	auipc	a0,0x6
    111c:	87050513          	addi	a0,a0,-1936 # 6988 <csem_free+0x874>
    1120:	00005097          	auipc	ra,0x5
    1124:	d5e080e7          	jalr	-674(ra) # 5e7e <printf>
      exit(1);
    1128:	4505                	li	a0,1
    112a:	00005097          	auipc	ra,0x5
    112e:	982080e7          	jalr	-1662(ra) # 5aac <exit>
    close(fds[0]);
    1132:	fa842503          	lw	a0,-88(s0)
    1136:	00005097          	auipc	ra,0x5
    113a:	99e080e7          	jalr	-1634(ra) # 5ad4 <close>
    wait(&xstatus);
    113e:	fa440513          	addi	a0,s0,-92
    1142:	00005097          	auipc	ra,0x5
    1146:	972080e7          	jalr	-1678(ra) # 5ab4 <wait>
    exit(xstatus);
    114a:	fa442503          	lw	a0,-92(s0)
    114e:	00005097          	auipc	ra,0x5
    1152:	95e080e7          	jalr	-1698(ra) # 5aac <exit>
    printf("%s: fork() failed\n", s);
    1156:	85ca                	mv	a1,s2
    1158:	00006517          	auipc	a0,0x6
    115c:	85050513          	addi	a0,a0,-1968 # 69a8 <csem_free+0x894>
    1160:	00005097          	auipc	ra,0x5
    1164:	d1e080e7          	jalr	-738(ra) # 5e7e <printf>
    exit(1);
    1168:	4505                	li	a0,1
    116a:	00005097          	auipc	ra,0x5
    116e:	942080e7          	jalr	-1726(ra) # 5aac <exit>

0000000000001172 <preempt>:
{
    1172:	7139                	addi	sp,sp,-64
    1174:	fc06                	sd	ra,56(sp)
    1176:	f822                	sd	s0,48(sp)
    1178:	f426                	sd	s1,40(sp)
    117a:	f04a                	sd	s2,32(sp)
    117c:	ec4e                	sd	s3,24(sp)
    117e:	e852                	sd	s4,16(sp)
    1180:	0080                	addi	s0,sp,64
    1182:	892a                	mv	s2,a0
  pid1 = fork();
    1184:	00005097          	auipc	ra,0x5
    1188:	920080e7          	jalr	-1760(ra) # 5aa4 <fork>
  if(pid1 < 0) {
    118c:	00054563          	bltz	a0,1196 <preempt+0x24>
    1190:	84aa                	mv	s1,a0
  if(pid1 == 0)
    1192:	e105                	bnez	a0,11b2 <preempt+0x40>
    for(;;)
    1194:	a001                	j	1194 <preempt+0x22>
    printf("%s: fork failed", s);
    1196:	85ca                	mv	a1,s2
    1198:	00005517          	auipc	a0,0x5
    119c:	30050513          	addi	a0,a0,768 # 6498 <csem_free+0x384>
    11a0:	00005097          	auipc	ra,0x5
    11a4:	cde080e7          	jalr	-802(ra) # 5e7e <printf>
    exit(1);
    11a8:	4505                	li	a0,1
    11aa:	00005097          	auipc	ra,0x5
    11ae:	902080e7          	jalr	-1790(ra) # 5aac <exit>
  pid2 = fork();
    11b2:	00005097          	auipc	ra,0x5
    11b6:	8f2080e7          	jalr	-1806(ra) # 5aa4 <fork>
    11ba:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    11bc:	00054463          	bltz	a0,11c4 <preempt+0x52>
  if(pid2 == 0)
    11c0:	e105                	bnez	a0,11e0 <preempt+0x6e>
    for(;;)
    11c2:	a001                	j	11c2 <preempt+0x50>
    printf("%s: fork failed\n", s);
    11c4:	85ca                	mv	a1,s2
    11c6:	00005517          	auipc	a0,0x5
    11ca:	28250513          	addi	a0,a0,642 # 6448 <csem_free+0x334>
    11ce:	00005097          	auipc	ra,0x5
    11d2:	cb0080e7          	jalr	-848(ra) # 5e7e <printf>
    exit(1);
    11d6:	4505                	li	a0,1
    11d8:	00005097          	auipc	ra,0x5
    11dc:	8d4080e7          	jalr	-1836(ra) # 5aac <exit>
  pipe(pfds);
    11e0:	fc840513          	addi	a0,s0,-56
    11e4:	00005097          	auipc	ra,0x5
    11e8:	8d8080e7          	jalr	-1832(ra) # 5abc <pipe>
  pid3 = fork();
    11ec:	00005097          	auipc	ra,0x5
    11f0:	8b8080e7          	jalr	-1864(ra) # 5aa4 <fork>
    11f4:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    11f6:	02054e63          	bltz	a0,1232 <preempt+0xc0>
  if(pid3 == 0){
    11fa:	e525                	bnez	a0,1262 <preempt+0xf0>
    close(pfds[0]);
    11fc:	fc842503          	lw	a0,-56(s0)
    1200:	00005097          	auipc	ra,0x5
    1204:	8d4080e7          	jalr	-1836(ra) # 5ad4 <close>
    if(write(pfds[1], "x", 1) != 1)
    1208:	4605                	li	a2,1
    120a:	00005597          	auipc	a1,0x5
    120e:	4be58593          	addi	a1,a1,1214 # 66c8 <csem_free+0x5b4>
    1212:	fcc42503          	lw	a0,-52(s0)
    1216:	00005097          	auipc	ra,0x5
    121a:	8b6080e7          	jalr	-1866(ra) # 5acc <write>
    121e:	4785                	li	a5,1
    1220:	02f51763          	bne	a0,a5,124e <preempt+0xdc>
    close(pfds[1]);
    1224:	fcc42503          	lw	a0,-52(s0)
    1228:	00005097          	auipc	ra,0x5
    122c:	8ac080e7          	jalr	-1876(ra) # 5ad4 <close>
    for(;;)
    1230:	a001                	j	1230 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    1232:	85ca                	mv	a1,s2
    1234:	00005517          	auipc	a0,0x5
    1238:	21450513          	addi	a0,a0,532 # 6448 <csem_free+0x334>
    123c:	00005097          	auipc	ra,0x5
    1240:	c42080e7          	jalr	-958(ra) # 5e7e <printf>
     exit(1);
    1244:	4505                	li	a0,1
    1246:	00005097          	auipc	ra,0x5
    124a:	866080e7          	jalr	-1946(ra) # 5aac <exit>
      printf("%s: preempt write error", s);
    124e:	85ca                	mv	a1,s2
    1250:	00005517          	auipc	a0,0x5
    1254:	77050513          	addi	a0,a0,1904 # 69c0 <csem_free+0x8ac>
    1258:	00005097          	auipc	ra,0x5
    125c:	c26080e7          	jalr	-986(ra) # 5e7e <printf>
    1260:	b7d1                	j	1224 <preempt+0xb2>
  close(pfds[1]);
    1262:	fcc42503          	lw	a0,-52(s0)
    1266:	00005097          	auipc	ra,0x5
    126a:	86e080e7          	jalr	-1938(ra) # 5ad4 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    126e:	660d                	lui	a2,0x3
    1270:	0000b597          	auipc	a1,0xb
    1274:	e7058593          	addi	a1,a1,-400 # c0e0 <buf>
    1278:	fc842503          	lw	a0,-56(s0)
    127c:	00005097          	auipc	ra,0x5
    1280:	848080e7          	jalr	-1976(ra) # 5ac4 <read>
    1284:	4785                	li	a5,1
    1286:	02f50363          	beq	a0,a5,12ac <preempt+0x13a>
    printf("%s: preempt read error", s);
    128a:	85ca                	mv	a1,s2
    128c:	00005517          	auipc	a0,0x5
    1290:	74c50513          	addi	a0,a0,1868 # 69d8 <csem_free+0x8c4>
    1294:	00005097          	auipc	ra,0x5
    1298:	bea080e7          	jalr	-1046(ra) # 5e7e <printf>
}
    129c:	70e2                	ld	ra,56(sp)
    129e:	7442                	ld	s0,48(sp)
    12a0:	74a2                	ld	s1,40(sp)
    12a2:	7902                	ld	s2,32(sp)
    12a4:	69e2                	ld	s3,24(sp)
    12a6:	6a42                	ld	s4,16(sp)
    12a8:	6121                	addi	sp,sp,64
    12aa:	8082                	ret
  close(pfds[0]);
    12ac:	fc842503          	lw	a0,-56(s0)
    12b0:	00005097          	auipc	ra,0x5
    12b4:	824080e7          	jalr	-2012(ra) # 5ad4 <close>
  printf("kill... ");
    12b8:	00005517          	auipc	a0,0x5
    12bc:	73850513          	addi	a0,a0,1848 # 69f0 <csem_free+0x8dc>
    12c0:	00005097          	auipc	ra,0x5
    12c4:	bbe080e7          	jalr	-1090(ra) # 5e7e <printf>
  kill(pid1, SIGKILL);
    12c8:	45a5                	li	a1,9
    12ca:	8526                	mv	a0,s1
    12cc:	00005097          	auipc	ra,0x5
    12d0:	810080e7          	jalr	-2032(ra) # 5adc <kill>
  kill(pid2, SIGKILL);
    12d4:	45a5                	li	a1,9
    12d6:	854e                	mv	a0,s3
    12d8:	00005097          	auipc	ra,0x5
    12dc:	804080e7          	jalr	-2044(ra) # 5adc <kill>
  kill(pid3, SIGKILL);
    12e0:	45a5                	li	a1,9
    12e2:	8552                	mv	a0,s4
    12e4:	00004097          	auipc	ra,0x4
    12e8:	7f8080e7          	jalr	2040(ra) # 5adc <kill>
  printf("wait... ");
    12ec:	00005517          	auipc	a0,0x5
    12f0:	71450513          	addi	a0,a0,1812 # 6a00 <csem_free+0x8ec>
    12f4:	00005097          	auipc	ra,0x5
    12f8:	b8a080e7          	jalr	-1142(ra) # 5e7e <printf>
  wait(0);
    12fc:	4501                	li	a0,0
    12fe:	00004097          	auipc	ra,0x4
    1302:	7b6080e7          	jalr	1974(ra) # 5ab4 <wait>
  wait(0);
    1306:	4501                	li	a0,0
    1308:	00004097          	auipc	ra,0x4
    130c:	7ac080e7          	jalr	1964(ra) # 5ab4 <wait>
  wait(0);
    1310:	4501                	li	a0,0
    1312:	00004097          	auipc	ra,0x4
    1316:	7a2080e7          	jalr	1954(ra) # 5ab4 <wait>
    131a:	b749                	j	129c <preempt+0x12a>

000000000000131c <unlinkread>:
{
    131c:	7179                	addi	sp,sp,-48
    131e:	f406                	sd	ra,40(sp)
    1320:	f022                	sd	s0,32(sp)
    1322:	ec26                	sd	s1,24(sp)
    1324:	e84a                	sd	s2,16(sp)
    1326:	e44e                	sd	s3,8(sp)
    1328:	1800                	addi	s0,sp,48
    132a:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
    132c:	20200593          	li	a1,514
    1330:	00005517          	auipc	a0,0x5
    1334:	f4050513          	addi	a0,a0,-192 # 6270 <csem_free+0x15c>
    1338:	00004097          	auipc	ra,0x4
    133c:	7b4080e7          	jalr	1972(ra) # 5aec <open>
  if(fd < 0){
    1340:	0e054563          	bltz	a0,142a <unlinkread+0x10e>
    1344:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
    1346:	4615                	li	a2,5
    1348:	00005597          	auipc	a1,0x5
    134c:	6e858593          	addi	a1,a1,1768 # 6a30 <csem_free+0x91c>
    1350:	00004097          	auipc	ra,0x4
    1354:	77c080e7          	jalr	1916(ra) # 5acc <write>
  close(fd);
    1358:	8526                	mv	a0,s1
    135a:	00004097          	auipc	ra,0x4
    135e:	77a080e7          	jalr	1914(ra) # 5ad4 <close>
  fd = open("unlinkread", O_RDWR);
    1362:	4589                	li	a1,2
    1364:	00005517          	auipc	a0,0x5
    1368:	f0c50513          	addi	a0,a0,-244 # 6270 <csem_free+0x15c>
    136c:	00004097          	auipc	ra,0x4
    1370:	780080e7          	jalr	1920(ra) # 5aec <open>
    1374:	84aa                	mv	s1,a0
  if(fd < 0){
    1376:	0c054863          	bltz	a0,1446 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
    137a:	00005517          	auipc	a0,0x5
    137e:	ef650513          	addi	a0,a0,-266 # 6270 <csem_free+0x15c>
    1382:	00004097          	auipc	ra,0x4
    1386:	77a080e7          	jalr	1914(ra) # 5afc <unlink>
    138a:	ed61                	bnez	a0,1462 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    138c:	20200593          	li	a1,514
    1390:	00005517          	auipc	a0,0x5
    1394:	ee050513          	addi	a0,a0,-288 # 6270 <csem_free+0x15c>
    1398:	00004097          	auipc	ra,0x4
    139c:	754080e7          	jalr	1876(ra) # 5aec <open>
    13a0:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
    13a2:	460d                	li	a2,3
    13a4:	00005597          	auipc	a1,0x5
    13a8:	6d458593          	addi	a1,a1,1748 # 6a78 <csem_free+0x964>
    13ac:	00004097          	auipc	ra,0x4
    13b0:	720080e7          	jalr	1824(ra) # 5acc <write>
  close(fd1);
    13b4:	854a                	mv	a0,s2
    13b6:	00004097          	auipc	ra,0x4
    13ba:	71e080e7          	jalr	1822(ra) # 5ad4 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
    13be:	660d                	lui	a2,0x3
    13c0:	0000b597          	auipc	a1,0xb
    13c4:	d2058593          	addi	a1,a1,-736 # c0e0 <buf>
    13c8:	8526                	mv	a0,s1
    13ca:	00004097          	auipc	ra,0x4
    13ce:	6fa080e7          	jalr	1786(ra) # 5ac4 <read>
    13d2:	4795                	li	a5,5
    13d4:	0af51563          	bne	a0,a5,147e <unlinkread+0x162>
  if(buf[0] != 'h'){
    13d8:	0000b717          	auipc	a4,0xb
    13dc:	d0874703          	lbu	a4,-760(a4) # c0e0 <buf>
    13e0:	06800793          	li	a5,104
    13e4:	0af71b63          	bne	a4,a5,149a <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
    13e8:	4629                	li	a2,10
    13ea:	0000b597          	auipc	a1,0xb
    13ee:	cf658593          	addi	a1,a1,-778 # c0e0 <buf>
    13f2:	8526                	mv	a0,s1
    13f4:	00004097          	auipc	ra,0x4
    13f8:	6d8080e7          	jalr	1752(ra) # 5acc <write>
    13fc:	47a9                	li	a5,10
    13fe:	0af51c63          	bne	a0,a5,14b6 <unlinkread+0x19a>
  close(fd);
    1402:	8526                	mv	a0,s1
    1404:	00004097          	auipc	ra,0x4
    1408:	6d0080e7          	jalr	1744(ra) # 5ad4 <close>
  unlink("unlinkread");
    140c:	00005517          	auipc	a0,0x5
    1410:	e6450513          	addi	a0,a0,-412 # 6270 <csem_free+0x15c>
    1414:	00004097          	auipc	ra,0x4
    1418:	6e8080e7          	jalr	1768(ra) # 5afc <unlink>
}
    141c:	70a2                	ld	ra,40(sp)
    141e:	7402                	ld	s0,32(sp)
    1420:	64e2                	ld	s1,24(sp)
    1422:	6942                	ld	s2,16(sp)
    1424:	69a2                	ld	s3,8(sp)
    1426:	6145                	addi	sp,sp,48
    1428:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
    142a:	85ce                	mv	a1,s3
    142c:	00005517          	auipc	a0,0x5
    1430:	5e450513          	addi	a0,a0,1508 # 6a10 <csem_free+0x8fc>
    1434:	00005097          	auipc	ra,0x5
    1438:	a4a080e7          	jalr	-1462(ra) # 5e7e <printf>
    exit(1);
    143c:	4505                	li	a0,1
    143e:	00004097          	auipc	ra,0x4
    1442:	66e080e7          	jalr	1646(ra) # 5aac <exit>
    printf("%s: open unlinkread failed\n", s);
    1446:	85ce                	mv	a1,s3
    1448:	00005517          	auipc	a0,0x5
    144c:	5f050513          	addi	a0,a0,1520 # 6a38 <csem_free+0x924>
    1450:	00005097          	auipc	ra,0x5
    1454:	a2e080e7          	jalr	-1490(ra) # 5e7e <printf>
    exit(1);
    1458:	4505                	li	a0,1
    145a:	00004097          	auipc	ra,0x4
    145e:	652080e7          	jalr	1618(ra) # 5aac <exit>
    printf("%s: unlink unlinkread failed\n", s);
    1462:	85ce                	mv	a1,s3
    1464:	00005517          	auipc	a0,0x5
    1468:	5f450513          	addi	a0,a0,1524 # 6a58 <csem_free+0x944>
    146c:	00005097          	auipc	ra,0x5
    1470:	a12080e7          	jalr	-1518(ra) # 5e7e <printf>
    exit(1);
    1474:	4505                	li	a0,1
    1476:	00004097          	auipc	ra,0x4
    147a:	636080e7          	jalr	1590(ra) # 5aac <exit>
    printf("%s: unlinkread read failed", s);
    147e:	85ce                	mv	a1,s3
    1480:	00005517          	auipc	a0,0x5
    1484:	60050513          	addi	a0,a0,1536 # 6a80 <csem_free+0x96c>
    1488:	00005097          	auipc	ra,0x5
    148c:	9f6080e7          	jalr	-1546(ra) # 5e7e <printf>
    exit(1);
    1490:	4505                	li	a0,1
    1492:	00004097          	auipc	ra,0x4
    1496:	61a080e7          	jalr	1562(ra) # 5aac <exit>
    printf("%s: unlinkread wrong data\n", s);
    149a:	85ce                	mv	a1,s3
    149c:	00005517          	auipc	a0,0x5
    14a0:	60450513          	addi	a0,a0,1540 # 6aa0 <csem_free+0x98c>
    14a4:	00005097          	auipc	ra,0x5
    14a8:	9da080e7          	jalr	-1574(ra) # 5e7e <printf>
    exit(1);
    14ac:	4505                	li	a0,1
    14ae:	00004097          	auipc	ra,0x4
    14b2:	5fe080e7          	jalr	1534(ra) # 5aac <exit>
    printf("%s: unlinkread write failed\n", s);
    14b6:	85ce                	mv	a1,s3
    14b8:	00005517          	auipc	a0,0x5
    14bc:	60850513          	addi	a0,a0,1544 # 6ac0 <csem_free+0x9ac>
    14c0:	00005097          	auipc	ra,0x5
    14c4:	9be080e7          	jalr	-1602(ra) # 5e7e <printf>
    exit(1);
    14c8:	4505                	li	a0,1
    14ca:	00004097          	auipc	ra,0x4
    14ce:	5e2080e7          	jalr	1506(ra) # 5aac <exit>

00000000000014d2 <linktest>:
{
    14d2:	1101                	addi	sp,sp,-32
    14d4:	ec06                	sd	ra,24(sp)
    14d6:	e822                	sd	s0,16(sp)
    14d8:	e426                	sd	s1,8(sp)
    14da:	e04a                	sd	s2,0(sp)
    14dc:	1000                	addi	s0,sp,32
    14de:	892a                	mv	s2,a0
  unlink("lf1");
    14e0:	00005517          	auipc	a0,0x5
    14e4:	60050513          	addi	a0,a0,1536 # 6ae0 <csem_free+0x9cc>
    14e8:	00004097          	auipc	ra,0x4
    14ec:	614080e7          	jalr	1556(ra) # 5afc <unlink>
  unlink("lf2");
    14f0:	00005517          	auipc	a0,0x5
    14f4:	5f850513          	addi	a0,a0,1528 # 6ae8 <csem_free+0x9d4>
    14f8:	00004097          	auipc	ra,0x4
    14fc:	604080e7          	jalr	1540(ra) # 5afc <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    1500:	20200593          	li	a1,514
    1504:	00005517          	auipc	a0,0x5
    1508:	5dc50513          	addi	a0,a0,1500 # 6ae0 <csem_free+0x9cc>
    150c:	00004097          	auipc	ra,0x4
    1510:	5e0080e7          	jalr	1504(ra) # 5aec <open>
  if(fd < 0){
    1514:	10054763          	bltz	a0,1622 <linktest+0x150>
    1518:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
    151a:	4615                	li	a2,5
    151c:	00005597          	auipc	a1,0x5
    1520:	51458593          	addi	a1,a1,1300 # 6a30 <csem_free+0x91c>
    1524:	00004097          	auipc	ra,0x4
    1528:	5a8080e7          	jalr	1448(ra) # 5acc <write>
    152c:	4795                	li	a5,5
    152e:	10f51863          	bne	a0,a5,163e <linktest+0x16c>
  close(fd);
    1532:	8526                	mv	a0,s1
    1534:	00004097          	auipc	ra,0x4
    1538:	5a0080e7          	jalr	1440(ra) # 5ad4 <close>
  if(link("lf1", "lf2") < 0){
    153c:	00005597          	auipc	a1,0x5
    1540:	5ac58593          	addi	a1,a1,1452 # 6ae8 <csem_free+0x9d4>
    1544:	00005517          	auipc	a0,0x5
    1548:	59c50513          	addi	a0,a0,1436 # 6ae0 <csem_free+0x9cc>
    154c:	00004097          	auipc	ra,0x4
    1550:	5c0080e7          	jalr	1472(ra) # 5b0c <link>
    1554:	10054363          	bltz	a0,165a <linktest+0x188>
  unlink("lf1");
    1558:	00005517          	auipc	a0,0x5
    155c:	58850513          	addi	a0,a0,1416 # 6ae0 <csem_free+0x9cc>
    1560:	00004097          	auipc	ra,0x4
    1564:	59c080e7          	jalr	1436(ra) # 5afc <unlink>
  if(open("lf1", 0) >= 0){
    1568:	4581                	li	a1,0
    156a:	00005517          	auipc	a0,0x5
    156e:	57650513          	addi	a0,a0,1398 # 6ae0 <csem_free+0x9cc>
    1572:	00004097          	auipc	ra,0x4
    1576:	57a080e7          	jalr	1402(ra) # 5aec <open>
    157a:	0e055e63          	bgez	a0,1676 <linktest+0x1a4>
  fd = open("lf2", 0);
    157e:	4581                	li	a1,0
    1580:	00005517          	auipc	a0,0x5
    1584:	56850513          	addi	a0,a0,1384 # 6ae8 <csem_free+0x9d4>
    1588:	00004097          	auipc	ra,0x4
    158c:	564080e7          	jalr	1380(ra) # 5aec <open>
    1590:	84aa                	mv	s1,a0
  if(fd < 0){
    1592:	10054063          	bltz	a0,1692 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
    1596:	660d                	lui	a2,0x3
    1598:	0000b597          	auipc	a1,0xb
    159c:	b4858593          	addi	a1,a1,-1208 # c0e0 <buf>
    15a0:	00004097          	auipc	ra,0x4
    15a4:	524080e7          	jalr	1316(ra) # 5ac4 <read>
    15a8:	4795                	li	a5,5
    15aa:	10f51263          	bne	a0,a5,16ae <linktest+0x1dc>
  close(fd);
    15ae:	8526                	mv	a0,s1
    15b0:	00004097          	auipc	ra,0x4
    15b4:	524080e7          	jalr	1316(ra) # 5ad4 <close>
  if(link("lf2", "lf2") >= 0){
    15b8:	00005597          	auipc	a1,0x5
    15bc:	53058593          	addi	a1,a1,1328 # 6ae8 <csem_free+0x9d4>
    15c0:	852e                	mv	a0,a1
    15c2:	00004097          	auipc	ra,0x4
    15c6:	54a080e7          	jalr	1354(ra) # 5b0c <link>
    15ca:	10055063          	bgez	a0,16ca <linktest+0x1f8>
  unlink("lf2");
    15ce:	00005517          	auipc	a0,0x5
    15d2:	51a50513          	addi	a0,a0,1306 # 6ae8 <csem_free+0x9d4>
    15d6:	00004097          	auipc	ra,0x4
    15da:	526080e7          	jalr	1318(ra) # 5afc <unlink>
  if(link("lf2", "lf1") >= 0){
    15de:	00005597          	auipc	a1,0x5
    15e2:	50258593          	addi	a1,a1,1282 # 6ae0 <csem_free+0x9cc>
    15e6:	00005517          	auipc	a0,0x5
    15ea:	50250513          	addi	a0,a0,1282 # 6ae8 <csem_free+0x9d4>
    15ee:	00004097          	auipc	ra,0x4
    15f2:	51e080e7          	jalr	1310(ra) # 5b0c <link>
    15f6:	0e055863          	bgez	a0,16e6 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    15fa:	00005597          	auipc	a1,0x5
    15fe:	4e658593          	addi	a1,a1,1254 # 6ae0 <csem_free+0x9cc>
    1602:	00005517          	auipc	a0,0x5
    1606:	5ee50513          	addi	a0,a0,1518 # 6bf0 <csem_free+0xadc>
    160a:	00004097          	auipc	ra,0x4
    160e:	502080e7          	jalr	1282(ra) # 5b0c <link>
    1612:	0e055863          	bgez	a0,1702 <linktest+0x230>
}
    1616:	60e2                	ld	ra,24(sp)
    1618:	6442                	ld	s0,16(sp)
    161a:	64a2                	ld	s1,8(sp)
    161c:	6902                	ld	s2,0(sp)
    161e:	6105                	addi	sp,sp,32
    1620:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1622:	85ca                	mv	a1,s2
    1624:	00005517          	auipc	a0,0x5
    1628:	4cc50513          	addi	a0,a0,1228 # 6af0 <csem_free+0x9dc>
    162c:	00005097          	auipc	ra,0x5
    1630:	852080e7          	jalr	-1966(ra) # 5e7e <printf>
    exit(1);
    1634:	4505                	li	a0,1
    1636:	00004097          	auipc	ra,0x4
    163a:	476080e7          	jalr	1142(ra) # 5aac <exit>
    printf("%s: write lf1 failed\n", s);
    163e:	85ca                	mv	a1,s2
    1640:	00005517          	auipc	a0,0x5
    1644:	4c850513          	addi	a0,a0,1224 # 6b08 <csem_free+0x9f4>
    1648:	00005097          	auipc	ra,0x5
    164c:	836080e7          	jalr	-1994(ra) # 5e7e <printf>
    exit(1);
    1650:	4505                	li	a0,1
    1652:	00004097          	auipc	ra,0x4
    1656:	45a080e7          	jalr	1114(ra) # 5aac <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    165a:	85ca                	mv	a1,s2
    165c:	00005517          	auipc	a0,0x5
    1660:	4c450513          	addi	a0,a0,1220 # 6b20 <csem_free+0xa0c>
    1664:	00005097          	auipc	ra,0x5
    1668:	81a080e7          	jalr	-2022(ra) # 5e7e <printf>
    exit(1);
    166c:	4505                	li	a0,1
    166e:	00004097          	auipc	ra,0x4
    1672:	43e080e7          	jalr	1086(ra) # 5aac <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    1676:	85ca                	mv	a1,s2
    1678:	00005517          	auipc	a0,0x5
    167c:	4c850513          	addi	a0,a0,1224 # 6b40 <csem_free+0xa2c>
    1680:	00004097          	auipc	ra,0x4
    1684:	7fe080e7          	jalr	2046(ra) # 5e7e <printf>
    exit(1);
    1688:	4505                	li	a0,1
    168a:	00004097          	auipc	ra,0x4
    168e:	422080e7          	jalr	1058(ra) # 5aac <exit>
    printf("%s: open lf2 failed\n", s);
    1692:	85ca                	mv	a1,s2
    1694:	00005517          	auipc	a0,0x5
    1698:	4dc50513          	addi	a0,a0,1244 # 6b70 <csem_free+0xa5c>
    169c:	00004097          	auipc	ra,0x4
    16a0:	7e2080e7          	jalr	2018(ra) # 5e7e <printf>
    exit(1);
    16a4:	4505                	li	a0,1
    16a6:	00004097          	auipc	ra,0x4
    16aa:	406080e7          	jalr	1030(ra) # 5aac <exit>
    printf("%s: read lf2 failed\n", s);
    16ae:	85ca                	mv	a1,s2
    16b0:	00005517          	auipc	a0,0x5
    16b4:	4d850513          	addi	a0,a0,1240 # 6b88 <csem_free+0xa74>
    16b8:	00004097          	auipc	ra,0x4
    16bc:	7c6080e7          	jalr	1990(ra) # 5e7e <printf>
    exit(1);
    16c0:	4505                	li	a0,1
    16c2:	00004097          	auipc	ra,0x4
    16c6:	3ea080e7          	jalr	1002(ra) # 5aac <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    16ca:	85ca                	mv	a1,s2
    16cc:	00005517          	auipc	a0,0x5
    16d0:	4d450513          	addi	a0,a0,1236 # 6ba0 <csem_free+0xa8c>
    16d4:	00004097          	auipc	ra,0x4
    16d8:	7aa080e7          	jalr	1962(ra) # 5e7e <printf>
    exit(1);
    16dc:	4505                	li	a0,1
    16de:	00004097          	auipc	ra,0x4
    16e2:	3ce080e7          	jalr	974(ra) # 5aac <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
    16e6:	85ca                	mv	a1,s2
    16e8:	00005517          	auipc	a0,0x5
    16ec:	4e050513          	addi	a0,a0,1248 # 6bc8 <csem_free+0xab4>
    16f0:	00004097          	auipc	ra,0x4
    16f4:	78e080e7          	jalr	1934(ra) # 5e7e <printf>
    exit(1);
    16f8:	4505                	li	a0,1
    16fa:	00004097          	auipc	ra,0x4
    16fe:	3b2080e7          	jalr	946(ra) # 5aac <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1702:	85ca                	mv	a1,s2
    1704:	00005517          	auipc	a0,0x5
    1708:	4f450513          	addi	a0,a0,1268 # 6bf8 <csem_free+0xae4>
    170c:	00004097          	auipc	ra,0x4
    1710:	772080e7          	jalr	1906(ra) # 5e7e <printf>
    exit(1);
    1714:	4505                	li	a0,1
    1716:	00004097          	auipc	ra,0x4
    171a:	396080e7          	jalr	918(ra) # 5aac <exit>

000000000000171e <validatetest>:
{
    171e:	7139                	addi	sp,sp,-64
    1720:	fc06                	sd	ra,56(sp)
    1722:	f822                	sd	s0,48(sp)
    1724:	f426                	sd	s1,40(sp)
    1726:	f04a                	sd	s2,32(sp)
    1728:	ec4e                	sd	s3,24(sp)
    172a:	e852                	sd	s4,16(sp)
    172c:	e456                	sd	s5,8(sp)
    172e:	e05a                	sd	s6,0(sp)
    1730:	0080                	addi	s0,sp,64
    1732:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1734:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    1736:	00005997          	auipc	s3,0x5
    173a:	4e298993          	addi	s3,s3,1250 # 6c18 <csem_free+0xb04>
    173e:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1740:	6a85                	lui	s5,0x1
    1742:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1746:	85a6                	mv	a1,s1
    1748:	854e                	mv	a0,s3
    174a:	00004097          	auipc	ra,0x4
    174e:	3c2080e7          	jalr	962(ra) # 5b0c <link>
    1752:	01251f63          	bne	a0,s2,1770 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1756:	94d6                	add	s1,s1,s5
    1758:	ff4497e3          	bne	s1,s4,1746 <validatetest+0x28>
}
    175c:	70e2                	ld	ra,56(sp)
    175e:	7442                	ld	s0,48(sp)
    1760:	74a2                	ld	s1,40(sp)
    1762:	7902                	ld	s2,32(sp)
    1764:	69e2                	ld	s3,24(sp)
    1766:	6a42                	ld	s4,16(sp)
    1768:	6aa2                	ld	s5,8(sp)
    176a:	6b02                	ld	s6,0(sp)
    176c:	6121                	addi	sp,sp,64
    176e:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1770:	85da                	mv	a1,s6
    1772:	00005517          	auipc	a0,0x5
    1776:	4b650513          	addi	a0,a0,1206 # 6c28 <csem_free+0xb14>
    177a:	00004097          	auipc	ra,0x4
    177e:	704080e7          	jalr	1796(ra) # 5e7e <printf>
      exit(1);
    1782:	4505                	li	a0,1
    1784:	00004097          	auipc	ra,0x4
    1788:	328080e7          	jalr	808(ra) # 5aac <exit>

000000000000178c <copyinstr2>:
{
    178c:	7155                	addi	sp,sp,-208
    178e:	e586                	sd	ra,200(sp)
    1790:	e1a2                	sd	s0,192(sp)
    1792:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1794:	f6840793          	addi	a5,s0,-152
    1798:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    179c:	07800713          	li	a4,120
    17a0:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    17a4:	0785                	addi	a5,a5,1
    17a6:	fed79de3          	bne	a5,a3,17a0 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    17aa:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    17ae:	f6840513          	addi	a0,s0,-152
    17b2:	00004097          	auipc	ra,0x4
    17b6:	34a080e7          	jalr	842(ra) # 5afc <unlink>
  if(ret != -1){
    17ba:	57fd                	li	a5,-1
    17bc:	0ef51063          	bne	a0,a5,189c <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    17c0:	20100593          	li	a1,513
    17c4:	f6840513          	addi	a0,s0,-152
    17c8:	00004097          	auipc	ra,0x4
    17cc:	324080e7          	jalr	804(ra) # 5aec <open>
  if(fd != -1){
    17d0:	57fd                	li	a5,-1
    17d2:	0ef51563          	bne	a0,a5,18bc <copyinstr2+0x130>
  ret = link(b, b);
    17d6:	f6840593          	addi	a1,s0,-152
    17da:	852e                	mv	a0,a1
    17dc:	00004097          	auipc	ra,0x4
    17e0:	330080e7          	jalr	816(ra) # 5b0c <link>
  if(ret != -1){
    17e4:	57fd                	li	a5,-1
    17e6:	0ef51b63          	bne	a0,a5,18dc <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    17ea:	00006797          	auipc	a5,0x6
    17ee:	21678793          	addi	a5,a5,534 # 7a00 <csem_free+0x18ec>
    17f2:	f4f43c23          	sd	a5,-168(s0)
    17f6:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    17fa:	f5840593          	addi	a1,s0,-168
    17fe:	f6840513          	addi	a0,s0,-152
    1802:	00004097          	auipc	ra,0x4
    1806:	2e2080e7          	jalr	738(ra) # 5ae4 <exec>
  if(ret != -1){
    180a:	57fd                	li	a5,-1
    180c:	0ef51963          	bne	a0,a5,18fe <copyinstr2+0x172>
  int pid = fork();
    1810:	00004097          	auipc	ra,0x4
    1814:	294080e7          	jalr	660(ra) # 5aa4 <fork>
  if(pid < 0){
    1818:	10054363          	bltz	a0,191e <copyinstr2+0x192>
  if(pid == 0){
    181c:	12051463          	bnez	a0,1944 <copyinstr2+0x1b8>
    1820:	00007797          	auipc	a5,0x7
    1824:	1a878793          	addi	a5,a5,424 # 89c8 <big.0>
    1828:	00008697          	auipc	a3,0x8
    182c:	1a068693          	addi	a3,a3,416 # 99c8 <__global_pointer$+0x920>
      big[i] = 'x';
    1830:	07800713          	li	a4,120
    1834:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1838:	0785                	addi	a5,a5,1
    183a:	fed79de3          	bne	a5,a3,1834 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    183e:	00008797          	auipc	a5,0x8
    1842:	18078523          	sb	zero,394(a5) # 99c8 <__global_pointer$+0x920>
    char *args2[] = { big, big, big, 0 };
    1846:	00007797          	auipc	a5,0x7
    184a:	d8278793          	addi	a5,a5,-638 # 85c8 <csem_free+0x24b4>
    184e:	6390                	ld	a2,0(a5)
    1850:	6794                	ld	a3,8(a5)
    1852:	6b98                	ld	a4,16(a5)
    1854:	6f9c                	ld	a5,24(a5)
    1856:	f2c43823          	sd	a2,-208(s0)
    185a:	f2d43c23          	sd	a3,-200(s0)
    185e:	f4e43023          	sd	a4,-192(s0)
    1862:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1866:	f3040593          	addi	a1,s0,-208
    186a:	00005517          	auipc	a0,0x5
    186e:	dee50513          	addi	a0,a0,-530 # 6658 <csem_free+0x544>
    1872:	00004097          	auipc	ra,0x4
    1876:	272080e7          	jalr	626(ra) # 5ae4 <exec>
    if(ret != -1){
    187a:	57fd                	li	a5,-1
    187c:	0af50e63          	beq	a0,a5,1938 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1880:	55fd                	li	a1,-1
    1882:	00005517          	auipc	a0,0x5
    1886:	44e50513          	addi	a0,a0,1102 # 6cd0 <csem_free+0xbbc>
    188a:	00004097          	auipc	ra,0x4
    188e:	5f4080e7          	jalr	1524(ra) # 5e7e <printf>
      exit(1);
    1892:	4505                	li	a0,1
    1894:	00004097          	auipc	ra,0x4
    1898:	218080e7          	jalr	536(ra) # 5aac <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    189c:	862a                	mv	a2,a0
    189e:	f6840593          	addi	a1,s0,-152
    18a2:	00005517          	auipc	a0,0x5
    18a6:	3a650513          	addi	a0,a0,934 # 6c48 <csem_free+0xb34>
    18aa:	00004097          	auipc	ra,0x4
    18ae:	5d4080e7          	jalr	1492(ra) # 5e7e <printf>
    exit(1);
    18b2:	4505                	li	a0,1
    18b4:	00004097          	auipc	ra,0x4
    18b8:	1f8080e7          	jalr	504(ra) # 5aac <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    18bc:	862a                	mv	a2,a0
    18be:	f6840593          	addi	a1,s0,-152
    18c2:	00005517          	auipc	a0,0x5
    18c6:	3a650513          	addi	a0,a0,934 # 6c68 <csem_free+0xb54>
    18ca:	00004097          	auipc	ra,0x4
    18ce:	5b4080e7          	jalr	1460(ra) # 5e7e <printf>
    exit(1);
    18d2:	4505                	li	a0,1
    18d4:	00004097          	auipc	ra,0x4
    18d8:	1d8080e7          	jalr	472(ra) # 5aac <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    18dc:	86aa                	mv	a3,a0
    18de:	f6840613          	addi	a2,s0,-152
    18e2:	85b2                	mv	a1,a2
    18e4:	00005517          	auipc	a0,0x5
    18e8:	3a450513          	addi	a0,a0,932 # 6c88 <csem_free+0xb74>
    18ec:	00004097          	auipc	ra,0x4
    18f0:	592080e7          	jalr	1426(ra) # 5e7e <printf>
    exit(1);
    18f4:	4505                	li	a0,1
    18f6:	00004097          	auipc	ra,0x4
    18fa:	1b6080e7          	jalr	438(ra) # 5aac <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    18fe:	567d                	li	a2,-1
    1900:	f6840593          	addi	a1,s0,-152
    1904:	00005517          	auipc	a0,0x5
    1908:	3ac50513          	addi	a0,a0,940 # 6cb0 <csem_free+0xb9c>
    190c:	00004097          	auipc	ra,0x4
    1910:	572080e7          	jalr	1394(ra) # 5e7e <printf>
    exit(1);
    1914:	4505                	li	a0,1
    1916:	00004097          	auipc	ra,0x4
    191a:	196080e7          	jalr	406(ra) # 5aac <exit>
    printf("fork failed\n");
    191e:	00005517          	auipc	a0,0x5
    1922:	5ba50513          	addi	a0,a0,1466 # 6ed8 <csem_free+0xdc4>
    1926:	00004097          	auipc	ra,0x4
    192a:	558080e7          	jalr	1368(ra) # 5e7e <printf>
    exit(1);
    192e:	4505                	li	a0,1
    1930:	00004097          	auipc	ra,0x4
    1934:	17c080e7          	jalr	380(ra) # 5aac <exit>
    exit(747); // OK
    1938:	2eb00513          	li	a0,747
    193c:	00004097          	auipc	ra,0x4
    1940:	170080e7          	jalr	368(ra) # 5aac <exit>
  int st = 0;
    1944:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1948:	f5440513          	addi	a0,s0,-172
    194c:	00004097          	auipc	ra,0x4
    1950:	168080e7          	jalr	360(ra) # 5ab4 <wait>
  if(st != 747){
    1954:	f5442703          	lw	a4,-172(s0)
    1958:	2eb00793          	li	a5,747
    195c:	00f71663          	bne	a4,a5,1968 <copyinstr2+0x1dc>
}
    1960:	60ae                	ld	ra,200(sp)
    1962:	640e                	ld	s0,192(sp)
    1964:	6169                	addi	sp,sp,208
    1966:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1968:	00005517          	auipc	a0,0x5
    196c:	39050513          	addi	a0,a0,912 # 6cf8 <csem_free+0xbe4>
    1970:	00004097          	auipc	ra,0x4
    1974:	50e080e7          	jalr	1294(ra) # 5e7e <printf>
    exit(1);
    1978:	4505                	li	a0,1
    197a:	00004097          	auipc	ra,0x4
    197e:	132080e7          	jalr	306(ra) # 5aac <exit>

0000000000001982 <exectest>:
{
    1982:	715d                	addi	sp,sp,-80
    1984:	e486                	sd	ra,72(sp)
    1986:	e0a2                	sd	s0,64(sp)
    1988:	fc26                	sd	s1,56(sp)
    198a:	f84a                	sd	s2,48(sp)
    198c:	0880                	addi	s0,sp,80
    198e:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1990:	00005797          	auipc	a5,0x5
    1994:	cc878793          	addi	a5,a5,-824 # 6658 <csem_free+0x544>
    1998:	fcf43023          	sd	a5,-64(s0)
    199c:	00005797          	auipc	a5,0x5
    19a0:	38c78793          	addi	a5,a5,908 # 6d28 <csem_free+0xc14>
    19a4:	fcf43423          	sd	a5,-56(s0)
    19a8:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    19ac:	00005517          	auipc	a0,0x5
    19b0:	38450513          	addi	a0,a0,900 # 6d30 <csem_free+0xc1c>
    19b4:	00004097          	auipc	ra,0x4
    19b8:	148080e7          	jalr	328(ra) # 5afc <unlink>
  pid = fork();
    19bc:	00004097          	auipc	ra,0x4
    19c0:	0e8080e7          	jalr	232(ra) # 5aa4 <fork>
  if(pid < 0) {
    19c4:	04054663          	bltz	a0,1a10 <exectest+0x8e>
    19c8:	84aa                	mv	s1,a0
  if(pid == 0) {
    19ca:	e959                	bnez	a0,1a60 <exectest+0xde>
    close(1);
    19cc:	4505                	li	a0,1
    19ce:	00004097          	auipc	ra,0x4
    19d2:	106080e7          	jalr	262(ra) # 5ad4 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    19d6:	20100593          	li	a1,513
    19da:	00005517          	auipc	a0,0x5
    19de:	35650513          	addi	a0,a0,854 # 6d30 <csem_free+0xc1c>
    19e2:	00004097          	auipc	ra,0x4
    19e6:	10a080e7          	jalr	266(ra) # 5aec <open>
    if(fd < 0) {
    19ea:	04054163          	bltz	a0,1a2c <exectest+0xaa>
    if(fd != 1) {
    19ee:	4785                	li	a5,1
    19f0:	04f50c63          	beq	a0,a5,1a48 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    19f4:	85ca                	mv	a1,s2
    19f6:	00005517          	auipc	a0,0x5
    19fa:	35a50513          	addi	a0,a0,858 # 6d50 <csem_free+0xc3c>
    19fe:	00004097          	auipc	ra,0x4
    1a02:	480080e7          	jalr	1152(ra) # 5e7e <printf>
      exit(1);
    1a06:	4505                	li	a0,1
    1a08:	00004097          	auipc	ra,0x4
    1a0c:	0a4080e7          	jalr	164(ra) # 5aac <exit>
     printf("%s: fork failed\n", s);
    1a10:	85ca                	mv	a1,s2
    1a12:	00005517          	auipc	a0,0x5
    1a16:	a3650513          	addi	a0,a0,-1482 # 6448 <csem_free+0x334>
    1a1a:	00004097          	auipc	ra,0x4
    1a1e:	464080e7          	jalr	1124(ra) # 5e7e <printf>
     exit(1);
    1a22:	4505                	li	a0,1
    1a24:	00004097          	auipc	ra,0x4
    1a28:	088080e7          	jalr	136(ra) # 5aac <exit>
      printf("%s: create failed\n", s);
    1a2c:	85ca                	mv	a1,s2
    1a2e:	00005517          	auipc	a0,0x5
    1a32:	30a50513          	addi	a0,a0,778 # 6d38 <csem_free+0xc24>
    1a36:	00004097          	auipc	ra,0x4
    1a3a:	448080e7          	jalr	1096(ra) # 5e7e <printf>
      exit(1);
    1a3e:	4505                	li	a0,1
    1a40:	00004097          	auipc	ra,0x4
    1a44:	06c080e7          	jalr	108(ra) # 5aac <exit>
    if(exec("echo", echoargv) < 0){
    1a48:	fc040593          	addi	a1,s0,-64
    1a4c:	00005517          	auipc	a0,0x5
    1a50:	c0c50513          	addi	a0,a0,-1012 # 6658 <csem_free+0x544>
    1a54:	00004097          	auipc	ra,0x4
    1a58:	090080e7          	jalr	144(ra) # 5ae4 <exec>
    1a5c:	02054163          	bltz	a0,1a7e <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1a60:	fdc40513          	addi	a0,s0,-36
    1a64:	00004097          	auipc	ra,0x4
    1a68:	050080e7          	jalr	80(ra) # 5ab4 <wait>
    1a6c:	02951763          	bne	a0,s1,1a9a <exectest+0x118>
  if(xstatus != 0)
    1a70:	fdc42503          	lw	a0,-36(s0)
    1a74:	cd0d                	beqz	a0,1aae <exectest+0x12c>
    exit(xstatus);
    1a76:	00004097          	auipc	ra,0x4
    1a7a:	036080e7          	jalr	54(ra) # 5aac <exit>
      printf("%s: exec echo failed\n", s);
    1a7e:	85ca                	mv	a1,s2
    1a80:	00005517          	auipc	a0,0x5
    1a84:	2e050513          	addi	a0,a0,736 # 6d60 <csem_free+0xc4c>
    1a88:	00004097          	auipc	ra,0x4
    1a8c:	3f6080e7          	jalr	1014(ra) # 5e7e <printf>
      exit(1);
    1a90:	4505                	li	a0,1
    1a92:	00004097          	auipc	ra,0x4
    1a96:	01a080e7          	jalr	26(ra) # 5aac <exit>
    printf("%s: wait failed!\n", s);
    1a9a:	85ca                	mv	a1,s2
    1a9c:	00005517          	auipc	a0,0x5
    1aa0:	2dc50513          	addi	a0,a0,732 # 6d78 <csem_free+0xc64>
    1aa4:	00004097          	auipc	ra,0x4
    1aa8:	3da080e7          	jalr	986(ra) # 5e7e <printf>
    1aac:	b7d1                	j	1a70 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1aae:	4581                	li	a1,0
    1ab0:	00005517          	auipc	a0,0x5
    1ab4:	28050513          	addi	a0,a0,640 # 6d30 <csem_free+0xc1c>
    1ab8:	00004097          	auipc	ra,0x4
    1abc:	034080e7          	jalr	52(ra) # 5aec <open>
  if(fd < 0) {
    1ac0:	02054a63          	bltz	a0,1af4 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1ac4:	4609                	li	a2,2
    1ac6:	fb840593          	addi	a1,s0,-72
    1aca:	00004097          	auipc	ra,0x4
    1ace:	ffa080e7          	jalr	-6(ra) # 5ac4 <read>
    1ad2:	4789                	li	a5,2
    1ad4:	02f50e63          	beq	a0,a5,1b10 <exectest+0x18e>
    printf("%s: read failed\n", s);
    1ad8:	85ca                	mv	a1,s2
    1ada:	00005517          	auipc	a0,0x5
    1ade:	2ce50513          	addi	a0,a0,718 # 6da8 <csem_free+0xc94>
    1ae2:	00004097          	auipc	ra,0x4
    1ae6:	39c080e7          	jalr	924(ra) # 5e7e <printf>
    exit(1);
    1aea:	4505                	li	a0,1
    1aec:	00004097          	auipc	ra,0x4
    1af0:	fc0080e7          	jalr	-64(ra) # 5aac <exit>
    printf("%s: open failed\n", s);
    1af4:	85ca                	mv	a1,s2
    1af6:	00005517          	auipc	a0,0x5
    1afa:	29a50513          	addi	a0,a0,666 # 6d90 <csem_free+0xc7c>
    1afe:	00004097          	auipc	ra,0x4
    1b02:	380080e7          	jalr	896(ra) # 5e7e <printf>
    exit(1);
    1b06:	4505                	li	a0,1
    1b08:	00004097          	auipc	ra,0x4
    1b0c:	fa4080e7          	jalr	-92(ra) # 5aac <exit>
  unlink("echo-ok");
    1b10:	00005517          	auipc	a0,0x5
    1b14:	22050513          	addi	a0,a0,544 # 6d30 <csem_free+0xc1c>
    1b18:	00004097          	auipc	ra,0x4
    1b1c:	fe4080e7          	jalr	-28(ra) # 5afc <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1b20:	fb844703          	lbu	a4,-72(s0)
    1b24:	04f00793          	li	a5,79
    1b28:	00f71863          	bne	a4,a5,1b38 <exectest+0x1b6>
    1b2c:	fb944703          	lbu	a4,-71(s0)
    1b30:	04b00793          	li	a5,75
    1b34:	02f70063          	beq	a4,a5,1b54 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1b38:	85ca                	mv	a1,s2
    1b3a:	00005517          	auipc	a0,0x5
    1b3e:	28650513          	addi	a0,a0,646 # 6dc0 <csem_free+0xcac>
    1b42:	00004097          	auipc	ra,0x4
    1b46:	33c080e7          	jalr	828(ra) # 5e7e <printf>
    exit(1);
    1b4a:	4505                	li	a0,1
    1b4c:	00004097          	auipc	ra,0x4
    1b50:	f60080e7          	jalr	-160(ra) # 5aac <exit>
    exit(0);
    1b54:	4501                	li	a0,0
    1b56:	00004097          	auipc	ra,0x4
    1b5a:	f56080e7          	jalr	-170(ra) # 5aac <exit>

0000000000001b5e <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(char *s)
{
    1b5e:	7179                	addi	sp,sp,-48
    1b60:	f406                	sd	ra,40(sp)
    1b62:	f022                	sd	s0,32(sp)
    1b64:	ec26                	sd	s1,24(sp)
    1b66:	1800                	addi	s0,sp,48
    1b68:	84aa                	mv	s1,a0
  int pid, fd, xstatus;

  unlink("bigarg-ok");
    1b6a:	00005517          	auipc	a0,0x5
    1b6e:	26e50513          	addi	a0,a0,622 # 6dd8 <csem_free+0xcc4>
    1b72:	00004097          	auipc	ra,0x4
    1b76:	f8a080e7          	jalr	-118(ra) # 5afc <unlink>
  pid = fork();
    1b7a:	00004097          	auipc	ra,0x4
    1b7e:	f2a080e7          	jalr	-214(ra) # 5aa4 <fork>
  if(pid == 0){
    1b82:	c121                	beqz	a0,1bc2 <bigargtest+0x64>
    args[MAXARG-1] = 0;
    exec("echo", args);
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit(0);
  } else if(pid < 0){
    1b84:	0a054063          	bltz	a0,1c24 <bigargtest+0xc6>
    printf("%s: bigargtest: fork failed\n", s);
    exit(1);
  }
  
  wait(&xstatus);
    1b88:	fdc40513          	addi	a0,s0,-36
    1b8c:	00004097          	auipc	ra,0x4
    1b90:	f28080e7          	jalr	-216(ra) # 5ab4 <wait>
  if(xstatus != 0)
    1b94:	fdc42503          	lw	a0,-36(s0)
    1b98:	e545                	bnez	a0,1c40 <bigargtest+0xe2>
    exit(xstatus);
  fd = open("bigarg-ok", 0);
    1b9a:	4581                	li	a1,0
    1b9c:	00005517          	auipc	a0,0x5
    1ba0:	23c50513          	addi	a0,a0,572 # 6dd8 <csem_free+0xcc4>
    1ba4:	00004097          	auipc	ra,0x4
    1ba8:	f48080e7          	jalr	-184(ra) # 5aec <open>
  if(fd < 0){
    1bac:	08054e63          	bltz	a0,1c48 <bigargtest+0xea>
    printf("%s: bigarg test failed!\n", s);
    exit(1);
  }
  close(fd);
    1bb0:	00004097          	auipc	ra,0x4
    1bb4:	f24080e7          	jalr	-220(ra) # 5ad4 <close>
}
    1bb8:	70a2                	ld	ra,40(sp)
    1bba:	7402                	ld	s0,32(sp)
    1bbc:	64e2                	ld	s1,24(sp)
    1bbe:	6145                	addi	sp,sp,48
    1bc0:	8082                	ret
    1bc2:	00007797          	auipc	a5,0x7
    1bc6:	d0678793          	addi	a5,a5,-762 # 88c8 <args.1>
    1bca:	00007697          	auipc	a3,0x7
    1bce:	df668693          	addi	a3,a3,-522 # 89c0 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    1bd2:	00005717          	auipc	a4,0x5
    1bd6:	21670713          	addi	a4,a4,534 # 6de8 <csem_free+0xcd4>
    1bda:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    1bdc:	07a1                	addi	a5,a5,8
    1bde:	fed79ee3          	bne	a5,a3,1bda <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    1be2:	00007597          	auipc	a1,0x7
    1be6:	ce658593          	addi	a1,a1,-794 # 88c8 <args.1>
    1bea:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    1bee:	00005517          	auipc	a0,0x5
    1bf2:	a6a50513          	addi	a0,a0,-1430 # 6658 <csem_free+0x544>
    1bf6:	00004097          	auipc	ra,0x4
    1bfa:	eee080e7          	jalr	-274(ra) # 5ae4 <exec>
    fd = open("bigarg-ok", O_CREATE);
    1bfe:	20000593          	li	a1,512
    1c02:	00005517          	auipc	a0,0x5
    1c06:	1d650513          	addi	a0,a0,470 # 6dd8 <csem_free+0xcc4>
    1c0a:	00004097          	auipc	ra,0x4
    1c0e:	ee2080e7          	jalr	-286(ra) # 5aec <open>
    close(fd);
    1c12:	00004097          	auipc	ra,0x4
    1c16:	ec2080e7          	jalr	-318(ra) # 5ad4 <close>
    exit(0);
    1c1a:	4501                	li	a0,0
    1c1c:	00004097          	auipc	ra,0x4
    1c20:	e90080e7          	jalr	-368(ra) # 5aac <exit>
    printf("%s: bigargtest: fork failed\n", s);
    1c24:	85a6                	mv	a1,s1
    1c26:	00005517          	auipc	a0,0x5
    1c2a:	2a250513          	addi	a0,a0,674 # 6ec8 <csem_free+0xdb4>
    1c2e:	00004097          	auipc	ra,0x4
    1c32:	250080e7          	jalr	592(ra) # 5e7e <printf>
    exit(1);
    1c36:	4505                	li	a0,1
    1c38:	00004097          	auipc	ra,0x4
    1c3c:	e74080e7          	jalr	-396(ra) # 5aac <exit>
    exit(xstatus);
    1c40:	00004097          	auipc	ra,0x4
    1c44:	e6c080e7          	jalr	-404(ra) # 5aac <exit>
    printf("%s: bigarg test failed!\n", s);
    1c48:	85a6                	mv	a1,s1
    1c4a:	00005517          	auipc	a0,0x5
    1c4e:	29e50513          	addi	a0,a0,670 # 6ee8 <csem_free+0xdd4>
    1c52:	00004097          	auipc	ra,0x4
    1c56:	22c080e7          	jalr	556(ra) # 5e7e <printf>
    exit(1);
    1c5a:	4505                	li	a0,1
    1c5c:	00004097          	auipc	ra,0x4
    1c60:	e50080e7          	jalr	-432(ra) # 5aac <exit>

0000000000001c64 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1c64:	7179                	addi	sp,sp,-48
    1c66:	f406                	sd	ra,40(sp)
    1c68:	f022                	sd	s0,32(sp)
    1c6a:	ec26                	sd	s1,24(sp)
    1c6c:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1c6e:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1c72:	00007497          	auipc	s1,0x7
    1c76:	c364b483          	ld	s1,-970(s1) # 88a8 <__SDATA_BEGIN__>
    1c7a:	fd840593          	addi	a1,s0,-40
    1c7e:	8526                	mv	a0,s1
    1c80:	00004097          	auipc	ra,0x4
    1c84:	e64080e7          	jalr	-412(ra) # 5ae4 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1c88:	8526                	mv	a0,s1
    1c8a:	00004097          	auipc	ra,0x4
    1c8e:	e32080e7          	jalr	-462(ra) # 5abc <pipe>

  exit(0);
    1c92:	4501                	li	a0,0
    1c94:	00004097          	auipc	ra,0x4
    1c98:	e18080e7          	jalr	-488(ra) # 5aac <exit>

0000000000001c9c <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1c9c:	7139                	addi	sp,sp,-64
    1c9e:	fc06                	sd	ra,56(sp)
    1ca0:	f822                	sd	s0,48(sp)
    1ca2:	f426                	sd	s1,40(sp)
    1ca4:	f04a                	sd	s2,32(sp)
    1ca6:	ec4e                	sd	s3,24(sp)
    1ca8:	0080                	addi	s0,sp,64
    1caa:	64b1                	lui	s1,0xc
    1cac:	35048493          	addi	s1,s1,848 # c350 <buf+0x270>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1cb0:	597d                	li	s2,-1
    1cb2:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1cb6:	00005997          	auipc	s3,0x5
    1cba:	9a298993          	addi	s3,s3,-1630 # 6658 <csem_free+0x544>
    argv[0] = (char*)0xffffffff;
    1cbe:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1cc2:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1cc6:	fc040593          	addi	a1,s0,-64
    1cca:	854e                	mv	a0,s3
    1ccc:	00004097          	auipc	ra,0x4
    1cd0:	e18080e7          	jalr	-488(ra) # 5ae4 <exec>
  for(int i = 0; i < 50000; i++){
    1cd4:	34fd                	addiw	s1,s1,-1
    1cd6:	f4e5                	bnez	s1,1cbe <badarg+0x22>
  }
  
  exit(0);
    1cd8:	4501                	li	a0,0
    1cda:	00004097          	auipc	ra,0x4
    1cde:	dd2080e7          	jalr	-558(ra) # 5aac <exit>

0000000000001ce2 <copyinstr3>:
{
    1ce2:	7179                	addi	sp,sp,-48
    1ce4:	f406                	sd	ra,40(sp)
    1ce6:	f022                	sd	s0,32(sp)
    1ce8:	ec26                	sd	s1,24(sp)
    1cea:	1800                	addi	s0,sp,48
  sbrk(8192);
    1cec:	6509                	lui	a0,0x2
    1cee:	00004097          	auipc	ra,0x4
    1cf2:	e46080e7          	jalr	-442(ra) # 5b34 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1cf6:	4501                	li	a0,0
    1cf8:	00004097          	auipc	ra,0x4
    1cfc:	e3c080e7          	jalr	-452(ra) # 5b34 <sbrk>
  if((top % PGSIZE) != 0){
    1d00:	03451793          	slli	a5,a0,0x34
    1d04:	e3c9                	bnez	a5,1d86 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    1d06:	4501                	li	a0,0
    1d08:	00004097          	auipc	ra,0x4
    1d0c:	e2c080e7          	jalr	-468(ra) # 5b34 <sbrk>
  if(top % PGSIZE){
    1d10:	03451793          	slli	a5,a0,0x34
    1d14:	e3d9                	bnez	a5,1d9a <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    1d16:	fff50493          	addi	s1,a0,-1 # 1fff <sbrkarg+0x77>
  *b = 'x';
    1d1a:	07800793          	li	a5,120
    1d1e:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1d22:	8526                	mv	a0,s1
    1d24:	00004097          	auipc	ra,0x4
    1d28:	dd8080e7          	jalr	-552(ra) # 5afc <unlink>
  if(ret != -1){
    1d2c:	57fd                	li	a5,-1
    1d2e:	08f51363          	bne	a0,a5,1db4 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    1d32:	20100593          	li	a1,513
    1d36:	8526                	mv	a0,s1
    1d38:	00004097          	auipc	ra,0x4
    1d3c:	db4080e7          	jalr	-588(ra) # 5aec <open>
  if(fd != -1){
    1d40:	57fd                	li	a5,-1
    1d42:	08f51863          	bne	a0,a5,1dd2 <copyinstr3+0xf0>
  ret = link(b, b);
    1d46:	85a6                	mv	a1,s1
    1d48:	8526                	mv	a0,s1
    1d4a:	00004097          	auipc	ra,0x4
    1d4e:	dc2080e7          	jalr	-574(ra) # 5b0c <link>
  if(ret != -1){
    1d52:	57fd                	li	a5,-1
    1d54:	08f51e63          	bne	a0,a5,1df0 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    1d58:	00006797          	auipc	a5,0x6
    1d5c:	ca878793          	addi	a5,a5,-856 # 7a00 <csem_free+0x18ec>
    1d60:	fcf43823          	sd	a5,-48(s0)
    1d64:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1d68:	fd040593          	addi	a1,s0,-48
    1d6c:	8526                	mv	a0,s1
    1d6e:	00004097          	auipc	ra,0x4
    1d72:	d76080e7          	jalr	-650(ra) # 5ae4 <exec>
  if(ret != -1){
    1d76:	57fd                	li	a5,-1
    1d78:	08f51c63          	bne	a0,a5,1e10 <copyinstr3+0x12e>
}
    1d7c:	70a2                	ld	ra,40(sp)
    1d7e:	7402                	ld	s0,32(sp)
    1d80:	64e2                	ld	s1,24(sp)
    1d82:	6145                	addi	sp,sp,48
    1d84:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1d86:	0347d513          	srli	a0,a5,0x34
    1d8a:	6785                	lui	a5,0x1
    1d8c:	40a7853b          	subw	a0,a5,a0
    1d90:	00004097          	auipc	ra,0x4
    1d94:	da4080e7          	jalr	-604(ra) # 5b34 <sbrk>
    1d98:	b7bd                	j	1d06 <copyinstr3+0x24>
    printf("oops\n");
    1d9a:	00005517          	auipc	a0,0x5
    1d9e:	16e50513          	addi	a0,a0,366 # 6f08 <csem_free+0xdf4>
    1da2:	00004097          	auipc	ra,0x4
    1da6:	0dc080e7          	jalr	220(ra) # 5e7e <printf>
    exit(1);
    1daa:	4505                	li	a0,1
    1dac:	00004097          	auipc	ra,0x4
    1db0:	d00080e7          	jalr	-768(ra) # 5aac <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1db4:	862a                	mv	a2,a0
    1db6:	85a6                	mv	a1,s1
    1db8:	00005517          	auipc	a0,0x5
    1dbc:	e9050513          	addi	a0,a0,-368 # 6c48 <csem_free+0xb34>
    1dc0:	00004097          	auipc	ra,0x4
    1dc4:	0be080e7          	jalr	190(ra) # 5e7e <printf>
    exit(1);
    1dc8:	4505                	li	a0,1
    1dca:	00004097          	auipc	ra,0x4
    1dce:	ce2080e7          	jalr	-798(ra) # 5aac <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1dd2:	862a                	mv	a2,a0
    1dd4:	85a6                	mv	a1,s1
    1dd6:	00005517          	auipc	a0,0x5
    1dda:	e9250513          	addi	a0,a0,-366 # 6c68 <csem_free+0xb54>
    1dde:	00004097          	auipc	ra,0x4
    1de2:	0a0080e7          	jalr	160(ra) # 5e7e <printf>
    exit(1);
    1de6:	4505                	li	a0,1
    1de8:	00004097          	auipc	ra,0x4
    1dec:	cc4080e7          	jalr	-828(ra) # 5aac <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1df0:	86aa                	mv	a3,a0
    1df2:	8626                	mv	a2,s1
    1df4:	85a6                	mv	a1,s1
    1df6:	00005517          	auipc	a0,0x5
    1dfa:	e9250513          	addi	a0,a0,-366 # 6c88 <csem_free+0xb74>
    1dfe:	00004097          	auipc	ra,0x4
    1e02:	080080e7          	jalr	128(ra) # 5e7e <printf>
    exit(1);
    1e06:	4505                	li	a0,1
    1e08:	00004097          	auipc	ra,0x4
    1e0c:	ca4080e7          	jalr	-860(ra) # 5aac <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1e10:	567d                	li	a2,-1
    1e12:	85a6                	mv	a1,s1
    1e14:	00005517          	auipc	a0,0x5
    1e18:	e9c50513          	addi	a0,a0,-356 # 6cb0 <csem_free+0xb9c>
    1e1c:	00004097          	auipc	ra,0x4
    1e20:	062080e7          	jalr	98(ra) # 5e7e <printf>
    exit(1);
    1e24:	4505                	li	a0,1
    1e26:	00004097          	auipc	ra,0x4
    1e2a:	c86080e7          	jalr	-890(ra) # 5aac <exit>

0000000000001e2e <rwsbrk>:
{
    1e2e:	1101                	addi	sp,sp,-32
    1e30:	ec06                	sd	ra,24(sp)
    1e32:	e822                	sd	s0,16(sp)
    1e34:	e426                	sd	s1,8(sp)
    1e36:	e04a                	sd	s2,0(sp)
    1e38:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    1e3a:	6509                	lui	a0,0x2
    1e3c:	00004097          	auipc	ra,0x4
    1e40:	cf8080e7          	jalr	-776(ra) # 5b34 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    1e44:	57fd                	li	a5,-1
    1e46:	06f50363          	beq	a0,a5,1eac <rwsbrk+0x7e>
    1e4a:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    1e4c:	7579                	lui	a0,0xffffe
    1e4e:	00004097          	auipc	ra,0x4
    1e52:	ce6080e7          	jalr	-794(ra) # 5b34 <sbrk>
    1e56:	57fd                	li	a5,-1
    1e58:	06f50763          	beq	a0,a5,1ec6 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    1e5c:	20100593          	li	a1,513
    1e60:	00004517          	auipc	a0,0x4
    1e64:	37850513          	addi	a0,a0,888 # 61d8 <csem_free+0xc4>
    1e68:	00004097          	auipc	ra,0x4
    1e6c:	c84080e7          	jalr	-892(ra) # 5aec <open>
    1e70:	892a                	mv	s2,a0
  if(fd < 0){
    1e72:	06054763          	bltz	a0,1ee0 <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    1e76:	6505                	lui	a0,0x1
    1e78:	94aa                	add	s1,s1,a0
    1e7a:	40000613          	li	a2,1024
    1e7e:	85a6                	mv	a1,s1
    1e80:	854a                	mv	a0,s2
    1e82:	00004097          	auipc	ra,0x4
    1e86:	c4a080e7          	jalr	-950(ra) # 5acc <write>
    1e8a:	862a                	mv	a2,a0
  if(n >= 0){
    1e8c:	06054763          	bltz	a0,1efa <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    1e90:	85a6                	mv	a1,s1
    1e92:	00005517          	auipc	a0,0x5
    1e96:	0ce50513          	addi	a0,a0,206 # 6f60 <csem_free+0xe4c>
    1e9a:	00004097          	auipc	ra,0x4
    1e9e:	fe4080e7          	jalr	-28(ra) # 5e7e <printf>
    exit(1);
    1ea2:	4505                	li	a0,1
    1ea4:	00004097          	auipc	ra,0x4
    1ea8:	c08080e7          	jalr	-1016(ra) # 5aac <exit>
    printf("sbrk(rwsbrk) failed\n");
    1eac:	00005517          	auipc	a0,0x5
    1eb0:	06450513          	addi	a0,a0,100 # 6f10 <csem_free+0xdfc>
    1eb4:	00004097          	auipc	ra,0x4
    1eb8:	fca080e7          	jalr	-54(ra) # 5e7e <printf>
    exit(1);
    1ebc:	4505                	li	a0,1
    1ebe:	00004097          	auipc	ra,0x4
    1ec2:	bee080e7          	jalr	-1042(ra) # 5aac <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    1ec6:	00005517          	auipc	a0,0x5
    1eca:	06250513          	addi	a0,a0,98 # 6f28 <csem_free+0xe14>
    1ece:	00004097          	auipc	ra,0x4
    1ed2:	fb0080e7          	jalr	-80(ra) # 5e7e <printf>
    exit(1);
    1ed6:	4505                	li	a0,1
    1ed8:	00004097          	auipc	ra,0x4
    1edc:	bd4080e7          	jalr	-1068(ra) # 5aac <exit>
    printf("open(rwsbrk) failed\n");
    1ee0:	00005517          	auipc	a0,0x5
    1ee4:	06850513          	addi	a0,a0,104 # 6f48 <csem_free+0xe34>
    1ee8:	00004097          	auipc	ra,0x4
    1eec:	f96080e7          	jalr	-106(ra) # 5e7e <printf>
    exit(1);
    1ef0:	4505                	li	a0,1
    1ef2:	00004097          	auipc	ra,0x4
    1ef6:	bba080e7          	jalr	-1094(ra) # 5aac <exit>
  close(fd);
    1efa:	854a                	mv	a0,s2
    1efc:	00004097          	auipc	ra,0x4
    1f00:	bd8080e7          	jalr	-1064(ra) # 5ad4 <close>
  unlink("rwsbrk");
    1f04:	00004517          	auipc	a0,0x4
    1f08:	2d450513          	addi	a0,a0,724 # 61d8 <csem_free+0xc4>
    1f0c:	00004097          	auipc	ra,0x4
    1f10:	bf0080e7          	jalr	-1040(ra) # 5afc <unlink>
  fd = open("README", O_RDONLY);
    1f14:	4581                	li	a1,0
    1f16:	00005517          	auipc	a0,0x5
    1f1a:	8ea50513          	addi	a0,a0,-1814 # 6800 <csem_free+0x6ec>
    1f1e:	00004097          	auipc	ra,0x4
    1f22:	bce080e7          	jalr	-1074(ra) # 5aec <open>
    1f26:	892a                	mv	s2,a0
  if(fd < 0){
    1f28:	02054963          	bltz	a0,1f5a <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    1f2c:	4629                	li	a2,10
    1f2e:	85a6                	mv	a1,s1
    1f30:	00004097          	auipc	ra,0x4
    1f34:	b94080e7          	jalr	-1132(ra) # 5ac4 <read>
    1f38:	862a                	mv	a2,a0
  if(n >= 0){
    1f3a:	02054d63          	bltz	a0,1f74 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    1f3e:	85a6                	mv	a1,s1
    1f40:	00005517          	auipc	a0,0x5
    1f44:	05050513          	addi	a0,a0,80 # 6f90 <csem_free+0xe7c>
    1f48:	00004097          	auipc	ra,0x4
    1f4c:	f36080e7          	jalr	-202(ra) # 5e7e <printf>
    exit(1);
    1f50:	4505                	li	a0,1
    1f52:	00004097          	auipc	ra,0x4
    1f56:	b5a080e7          	jalr	-1190(ra) # 5aac <exit>
    printf("open(rwsbrk) failed\n");
    1f5a:	00005517          	auipc	a0,0x5
    1f5e:	fee50513          	addi	a0,a0,-18 # 6f48 <csem_free+0xe34>
    1f62:	00004097          	auipc	ra,0x4
    1f66:	f1c080e7          	jalr	-228(ra) # 5e7e <printf>
    exit(1);
    1f6a:	4505                	li	a0,1
    1f6c:	00004097          	auipc	ra,0x4
    1f70:	b40080e7          	jalr	-1216(ra) # 5aac <exit>
  close(fd);
    1f74:	854a                	mv	a0,s2
    1f76:	00004097          	auipc	ra,0x4
    1f7a:	b5e080e7          	jalr	-1186(ra) # 5ad4 <close>
  exit(0);
    1f7e:	4501                	li	a0,0
    1f80:	00004097          	auipc	ra,0x4
    1f84:	b2c080e7          	jalr	-1236(ra) # 5aac <exit>

0000000000001f88 <sbrkarg>:
{
    1f88:	7179                	addi	sp,sp,-48
    1f8a:	f406                	sd	ra,40(sp)
    1f8c:	f022                	sd	s0,32(sp)
    1f8e:	ec26                	sd	s1,24(sp)
    1f90:	e84a                	sd	s2,16(sp)
    1f92:	e44e                	sd	s3,8(sp)
    1f94:	1800                	addi	s0,sp,48
    1f96:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    1f98:	6505                	lui	a0,0x1
    1f9a:	00004097          	auipc	ra,0x4
    1f9e:	b9a080e7          	jalr	-1126(ra) # 5b34 <sbrk>
    1fa2:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    1fa4:	20100593          	li	a1,513
    1fa8:	00005517          	auipc	a0,0x5
    1fac:	01050513          	addi	a0,a0,16 # 6fb8 <csem_free+0xea4>
    1fb0:	00004097          	auipc	ra,0x4
    1fb4:	b3c080e7          	jalr	-1220(ra) # 5aec <open>
    1fb8:	84aa                	mv	s1,a0
  unlink("sbrk");
    1fba:	00005517          	auipc	a0,0x5
    1fbe:	ffe50513          	addi	a0,a0,-2 # 6fb8 <csem_free+0xea4>
    1fc2:	00004097          	auipc	ra,0x4
    1fc6:	b3a080e7          	jalr	-1222(ra) # 5afc <unlink>
  if(fd < 0)  {
    1fca:	0404c163          	bltz	s1,200c <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    1fce:	6605                	lui	a2,0x1
    1fd0:	85ca                	mv	a1,s2
    1fd2:	8526                	mv	a0,s1
    1fd4:	00004097          	auipc	ra,0x4
    1fd8:	af8080e7          	jalr	-1288(ra) # 5acc <write>
    1fdc:	04054663          	bltz	a0,2028 <sbrkarg+0xa0>
  close(fd);
    1fe0:	8526                	mv	a0,s1
    1fe2:	00004097          	auipc	ra,0x4
    1fe6:	af2080e7          	jalr	-1294(ra) # 5ad4 <close>
  a = sbrk(PGSIZE);
    1fea:	6505                	lui	a0,0x1
    1fec:	00004097          	auipc	ra,0x4
    1ff0:	b48080e7          	jalr	-1208(ra) # 5b34 <sbrk>
  if(pipe((int *) a) != 0){
    1ff4:	00004097          	auipc	ra,0x4
    1ff8:	ac8080e7          	jalr	-1336(ra) # 5abc <pipe>
    1ffc:	e521                	bnez	a0,2044 <sbrkarg+0xbc>
}
    1ffe:	70a2                	ld	ra,40(sp)
    2000:	7402                	ld	s0,32(sp)
    2002:	64e2                	ld	s1,24(sp)
    2004:	6942                	ld	s2,16(sp)
    2006:	69a2                	ld	s3,8(sp)
    2008:	6145                	addi	sp,sp,48
    200a:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    200c:	85ce                	mv	a1,s3
    200e:	00005517          	auipc	a0,0x5
    2012:	fb250513          	addi	a0,a0,-78 # 6fc0 <csem_free+0xeac>
    2016:	00004097          	auipc	ra,0x4
    201a:	e68080e7          	jalr	-408(ra) # 5e7e <printf>
    exit(1);
    201e:	4505                	li	a0,1
    2020:	00004097          	auipc	ra,0x4
    2024:	a8c080e7          	jalr	-1396(ra) # 5aac <exit>
    printf("%s: write sbrk failed\n", s);
    2028:	85ce                	mv	a1,s3
    202a:	00005517          	auipc	a0,0x5
    202e:	fae50513          	addi	a0,a0,-82 # 6fd8 <csem_free+0xec4>
    2032:	00004097          	auipc	ra,0x4
    2036:	e4c080e7          	jalr	-436(ra) # 5e7e <printf>
    exit(1);
    203a:	4505                	li	a0,1
    203c:	00004097          	auipc	ra,0x4
    2040:	a70080e7          	jalr	-1424(ra) # 5aac <exit>
    printf("%s: pipe() failed\n", s);
    2044:	85ce                	mv	a1,s3
    2046:	00005517          	auipc	a0,0x5
    204a:	8fa50513          	addi	a0,a0,-1798 # 6940 <csem_free+0x82c>
    204e:	00004097          	auipc	ra,0x4
    2052:	e30080e7          	jalr	-464(ra) # 5e7e <printf>
    exit(1);
    2056:	4505                	li	a0,1
    2058:	00004097          	auipc	ra,0x4
    205c:	a54080e7          	jalr	-1452(ra) # 5aac <exit>

0000000000002060 <argptest>:
{
    2060:	1101                	addi	sp,sp,-32
    2062:	ec06                	sd	ra,24(sp)
    2064:	e822                	sd	s0,16(sp)
    2066:	e426                	sd	s1,8(sp)
    2068:	e04a                	sd	s2,0(sp)
    206a:	1000                	addi	s0,sp,32
    206c:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    206e:	4581                	li	a1,0
    2070:	00005517          	auipc	a0,0x5
    2074:	f8050513          	addi	a0,a0,-128 # 6ff0 <csem_free+0xedc>
    2078:	00004097          	auipc	ra,0x4
    207c:	a74080e7          	jalr	-1420(ra) # 5aec <open>
  if (fd < 0) {
    2080:	02054b63          	bltz	a0,20b6 <argptest+0x56>
    2084:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2086:	4501                	li	a0,0
    2088:	00004097          	auipc	ra,0x4
    208c:	aac080e7          	jalr	-1364(ra) # 5b34 <sbrk>
    2090:	567d                	li	a2,-1
    2092:	fff50593          	addi	a1,a0,-1
    2096:	8526                	mv	a0,s1
    2098:	00004097          	auipc	ra,0x4
    209c:	a2c080e7          	jalr	-1492(ra) # 5ac4 <read>
  close(fd);
    20a0:	8526                	mv	a0,s1
    20a2:	00004097          	auipc	ra,0x4
    20a6:	a32080e7          	jalr	-1486(ra) # 5ad4 <close>
}
    20aa:	60e2                	ld	ra,24(sp)
    20ac:	6442                	ld	s0,16(sp)
    20ae:	64a2                	ld	s1,8(sp)
    20b0:	6902                	ld	s2,0(sp)
    20b2:	6105                	addi	sp,sp,32
    20b4:	8082                	ret
    printf("%s: open failed\n", s);
    20b6:	85ca                	mv	a1,s2
    20b8:	00005517          	auipc	a0,0x5
    20bc:	cd850513          	addi	a0,a0,-808 # 6d90 <csem_free+0xc7c>
    20c0:	00004097          	auipc	ra,0x4
    20c4:	dbe080e7          	jalr	-578(ra) # 5e7e <printf>
    exit(1);
    20c8:	4505                	li	a0,1
    20ca:	00004097          	auipc	ra,0x4
    20ce:	9e2080e7          	jalr	-1566(ra) # 5aac <exit>

00000000000020d2 <openiputtest>:
{
    20d2:	7179                	addi	sp,sp,-48
    20d4:	f406                	sd	ra,40(sp)
    20d6:	f022                	sd	s0,32(sp)
    20d8:	ec26                	sd	s1,24(sp)
    20da:	1800                	addi	s0,sp,48
    20dc:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    20de:	00005517          	auipc	a0,0x5
    20e2:	f1a50513          	addi	a0,a0,-230 # 6ff8 <csem_free+0xee4>
    20e6:	00004097          	auipc	ra,0x4
    20ea:	a2e080e7          	jalr	-1490(ra) # 5b14 <mkdir>
    20ee:	04054263          	bltz	a0,2132 <openiputtest+0x60>
  pid = fork();
    20f2:	00004097          	auipc	ra,0x4
    20f6:	9b2080e7          	jalr	-1614(ra) # 5aa4 <fork>
  if(pid < 0){
    20fa:	04054a63          	bltz	a0,214e <openiputtest+0x7c>
  if(pid == 0){
    20fe:	e93d                	bnez	a0,2174 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    2100:	4589                	li	a1,2
    2102:	00005517          	auipc	a0,0x5
    2106:	ef650513          	addi	a0,a0,-266 # 6ff8 <csem_free+0xee4>
    210a:	00004097          	auipc	ra,0x4
    210e:	9e2080e7          	jalr	-1566(ra) # 5aec <open>
    if(fd >= 0){
    2112:	04054c63          	bltz	a0,216a <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    2116:	85a6                	mv	a1,s1
    2118:	00005517          	auipc	a0,0x5
    211c:	f0050513          	addi	a0,a0,-256 # 7018 <csem_free+0xf04>
    2120:	00004097          	auipc	ra,0x4
    2124:	d5e080e7          	jalr	-674(ra) # 5e7e <printf>
      exit(1);
    2128:	4505                	li	a0,1
    212a:	00004097          	auipc	ra,0x4
    212e:	982080e7          	jalr	-1662(ra) # 5aac <exit>
    printf("%s: mkdir oidir failed\n", s);
    2132:	85a6                	mv	a1,s1
    2134:	00005517          	auipc	a0,0x5
    2138:	ecc50513          	addi	a0,a0,-308 # 7000 <csem_free+0xeec>
    213c:	00004097          	auipc	ra,0x4
    2140:	d42080e7          	jalr	-702(ra) # 5e7e <printf>
    exit(1);
    2144:	4505                	li	a0,1
    2146:	00004097          	auipc	ra,0x4
    214a:	966080e7          	jalr	-1690(ra) # 5aac <exit>
    printf("%s: fork failed\n", s);
    214e:	85a6                	mv	a1,s1
    2150:	00004517          	auipc	a0,0x4
    2154:	2f850513          	addi	a0,a0,760 # 6448 <csem_free+0x334>
    2158:	00004097          	auipc	ra,0x4
    215c:	d26080e7          	jalr	-730(ra) # 5e7e <printf>
    exit(1);
    2160:	4505                	li	a0,1
    2162:	00004097          	auipc	ra,0x4
    2166:	94a080e7          	jalr	-1718(ra) # 5aac <exit>
    exit(0);
    216a:	4501                	li	a0,0
    216c:	00004097          	auipc	ra,0x4
    2170:	940080e7          	jalr	-1728(ra) # 5aac <exit>
  sleep(1);
    2174:	4505                	li	a0,1
    2176:	00004097          	auipc	ra,0x4
    217a:	9c6080e7          	jalr	-1594(ra) # 5b3c <sleep>
  if(unlink("oidir") != 0){
    217e:	00005517          	auipc	a0,0x5
    2182:	e7a50513          	addi	a0,a0,-390 # 6ff8 <csem_free+0xee4>
    2186:	00004097          	auipc	ra,0x4
    218a:	976080e7          	jalr	-1674(ra) # 5afc <unlink>
    218e:	cd19                	beqz	a0,21ac <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    2190:	85a6                	mv	a1,s1
    2192:	00005517          	auipc	a0,0x5
    2196:	eae50513          	addi	a0,a0,-338 # 7040 <csem_free+0xf2c>
    219a:	00004097          	auipc	ra,0x4
    219e:	ce4080e7          	jalr	-796(ra) # 5e7e <printf>
    exit(1);
    21a2:	4505                	li	a0,1
    21a4:	00004097          	auipc	ra,0x4
    21a8:	908080e7          	jalr	-1784(ra) # 5aac <exit>
  wait(&xstatus);
    21ac:	fdc40513          	addi	a0,s0,-36
    21b0:	00004097          	auipc	ra,0x4
    21b4:	904080e7          	jalr	-1788(ra) # 5ab4 <wait>
  exit(xstatus);
    21b8:	fdc42503          	lw	a0,-36(s0)
    21bc:	00004097          	auipc	ra,0x4
    21c0:	8f0080e7          	jalr	-1808(ra) # 5aac <exit>

00000000000021c4 <fourteen>:
{
    21c4:	1101                	addi	sp,sp,-32
    21c6:	ec06                	sd	ra,24(sp)
    21c8:	e822                	sd	s0,16(sp)
    21ca:	e426                	sd	s1,8(sp)
    21cc:	1000                	addi	s0,sp,32
    21ce:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    21d0:	00005517          	auipc	a0,0x5
    21d4:	05850513          	addi	a0,a0,88 # 7228 <csem_free+0x1114>
    21d8:	00004097          	auipc	ra,0x4
    21dc:	93c080e7          	jalr	-1732(ra) # 5b14 <mkdir>
    21e0:	e165                	bnez	a0,22c0 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    21e2:	00005517          	auipc	a0,0x5
    21e6:	e9e50513          	addi	a0,a0,-354 # 7080 <csem_free+0xf6c>
    21ea:	00004097          	auipc	ra,0x4
    21ee:	92a080e7          	jalr	-1750(ra) # 5b14 <mkdir>
    21f2:	e56d                	bnez	a0,22dc <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    21f4:	20000593          	li	a1,512
    21f8:	00005517          	auipc	a0,0x5
    21fc:	ee050513          	addi	a0,a0,-288 # 70d8 <csem_free+0xfc4>
    2200:	00004097          	auipc	ra,0x4
    2204:	8ec080e7          	jalr	-1812(ra) # 5aec <open>
  if(fd < 0){
    2208:	0e054863          	bltz	a0,22f8 <fourteen+0x134>
  close(fd);
    220c:	00004097          	auipc	ra,0x4
    2210:	8c8080e7          	jalr	-1848(ra) # 5ad4 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2214:	4581                	li	a1,0
    2216:	00005517          	auipc	a0,0x5
    221a:	f3a50513          	addi	a0,a0,-198 # 7150 <csem_free+0x103c>
    221e:	00004097          	auipc	ra,0x4
    2222:	8ce080e7          	jalr	-1842(ra) # 5aec <open>
  if(fd < 0){
    2226:	0e054763          	bltz	a0,2314 <fourteen+0x150>
  close(fd);
    222a:	00004097          	auipc	ra,0x4
    222e:	8aa080e7          	jalr	-1878(ra) # 5ad4 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2232:	00005517          	auipc	a0,0x5
    2236:	f8e50513          	addi	a0,a0,-114 # 71c0 <csem_free+0x10ac>
    223a:	00004097          	auipc	ra,0x4
    223e:	8da080e7          	jalr	-1830(ra) # 5b14 <mkdir>
    2242:	c57d                	beqz	a0,2330 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2244:	00005517          	auipc	a0,0x5
    2248:	fd450513          	addi	a0,a0,-44 # 7218 <csem_free+0x1104>
    224c:	00004097          	auipc	ra,0x4
    2250:	8c8080e7          	jalr	-1848(ra) # 5b14 <mkdir>
    2254:	cd65                	beqz	a0,234c <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2256:	00005517          	auipc	a0,0x5
    225a:	fc250513          	addi	a0,a0,-62 # 7218 <csem_free+0x1104>
    225e:	00004097          	auipc	ra,0x4
    2262:	89e080e7          	jalr	-1890(ra) # 5afc <unlink>
  unlink("12345678901234/12345678901234");
    2266:	00005517          	auipc	a0,0x5
    226a:	f5a50513          	addi	a0,a0,-166 # 71c0 <csem_free+0x10ac>
    226e:	00004097          	auipc	ra,0x4
    2272:	88e080e7          	jalr	-1906(ra) # 5afc <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2276:	00005517          	auipc	a0,0x5
    227a:	eda50513          	addi	a0,a0,-294 # 7150 <csem_free+0x103c>
    227e:	00004097          	auipc	ra,0x4
    2282:	87e080e7          	jalr	-1922(ra) # 5afc <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2286:	00005517          	auipc	a0,0x5
    228a:	e5250513          	addi	a0,a0,-430 # 70d8 <csem_free+0xfc4>
    228e:	00004097          	auipc	ra,0x4
    2292:	86e080e7          	jalr	-1938(ra) # 5afc <unlink>
  unlink("12345678901234/123456789012345");
    2296:	00005517          	auipc	a0,0x5
    229a:	dea50513          	addi	a0,a0,-534 # 7080 <csem_free+0xf6c>
    229e:	00004097          	auipc	ra,0x4
    22a2:	85e080e7          	jalr	-1954(ra) # 5afc <unlink>
  unlink("12345678901234");
    22a6:	00005517          	auipc	a0,0x5
    22aa:	f8250513          	addi	a0,a0,-126 # 7228 <csem_free+0x1114>
    22ae:	00004097          	auipc	ra,0x4
    22b2:	84e080e7          	jalr	-1970(ra) # 5afc <unlink>
}
    22b6:	60e2                	ld	ra,24(sp)
    22b8:	6442                	ld	s0,16(sp)
    22ba:	64a2                	ld	s1,8(sp)
    22bc:	6105                	addi	sp,sp,32
    22be:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    22c0:	85a6                	mv	a1,s1
    22c2:	00005517          	auipc	a0,0x5
    22c6:	d9650513          	addi	a0,a0,-618 # 7058 <csem_free+0xf44>
    22ca:	00004097          	auipc	ra,0x4
    22ce:	bb4080e7          	jalr	-1100(ra) # 5e7e <printf>
    exit(1);
    22d2:	4505                	li	a0,1
    22d4:	00003097          	auipc	ra,0x3
    22d8:	7d8080e7          	jalr	2008(ra) # 5aac <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    22dc:	85a6                	mv	a1,s1
    22de:	00005517          	auipc	a0,0x5
    22e2:	dc250513          	addi	a0,a0,-574 # 70a0 <csem_free+0xf8c>
    22e6:	00004097          	auipc	ra,0x4
    22ea:	b98080e7          	jalr	-1128(ra) # 5e7e <printf>
    exit(1);
    22ee:	4505                	li	a0,1
    22f0:	00003097          	auipc	ra,0x3
    22f4:	7bc080e7          	jalr	1980(ra) # 5aac <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    22f8:	85a6                	mv	a1,s1
    22fa:	00005517          	auipc	a0,0x5
    22fe:	e0e50513          	addi	a0,a0,-498 # 7108 <csem_free+0xff4>
    2302:	00004097          	auipc	ra,0x4
    2306:	b7c080e7          	jalr	-1156(ra) # 5e7e <printf>
    exit(1);
    230a:	4505                	li	a0,1
    230c:	00003097          	auipc	ra,0x3
    2310:	7a0080e7          	jalr	1952(ra) # 5aac <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2314:	85a6                	mv	a1,s1
    2316:	00005517          	auipc	a0,0x5
    231a:	e6a50513          	addi	a0,a0,-406 # 7180 <csem_free+0x106c>
    231e:	00004097          	auipc	ra,0x4
    2322:	b60080e7          	jalr	-1184(ra) # 5e7e <printf>
    exit(1);
    2326:	4505                	li	a0,1
    2328:	00003097          	auipc	ra,0x3
    232c:	784080e7          	jalr	1924(ra) # 5aac <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2330:	85a6                	mv	a1,s1
    2332:	00005517          	auipc	a0,0x5
    2336:	eae50513          	addi	a0,a0,-338 # 71e0 <csem_free+0x10cc>
    233a:	00004097          	auipc	ra,0x4
    233e:	b44080e7          	jalr	-1212(ra) # 5e7e <printf>
    exit(1);
    2342:	4505                	li	a0,1
    2344:	00003097          	auipc	ra,0x3
    2348:	768080e7          	jalr	1896(ra) # 5aac <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    234c:	85a6                	mv	a1,s1
    234e:	00005517          	auipc	a0,0x5
    2352:	eea50513          	addi	a0,a0,-278 # 7238 <csem_free+0x1124>
    2356:	00004097          	auipc	ra,0x4
    235a:	b28080e7          	jalr	-1240(ra) # 5e7e <printf>
    exit(1);
    235e:	4505                	li	a0,1
    2360:	00003097          	auipc	ra,0x3
    2364:	74c080e7          	jalr	1868(ra) # 5aac <exit>

0000000000002368 <iputtest>:
{
    2368:	1101                	addi	sp,sp,-32
    236a:	ec06                	sd	ra,24(sp)
    236c:	e822                	sd	s0,16(sp)
    236e:	e426                	sd	s1,8(sp)
    2370:	1000                	addi	s0,sp,32
    2372:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2374:	00005517          	auipc	a0,0x5
    2378:	efc50513          	addi	a0,a0,-260 # 7270 <csem_free+0x115c>
    237c:	00003097          	auipc	ra,0x3
    2380:	798080e7          	jalr	1944(ra) # 5b14 <mkdir>
    2384:	04054563          	bltz	a0,23ce <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2388:	00005517          	auipc	a0,0x5
    238c:	ee850513          	addi	a0,a0,-280 # 7270 <csem_free+0x115c>
    2390:	00003097          	auipc	ra,0x3
    2394:	78c080e7          	jalr	1932(ra) # 5b1c <chdir>
    2398:	04054963          	bltz	a0,23ea <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    239c:	00005517          	auipc	a0,0x5
    23a0:	f1450513          	addi	a0,a0,-236 # 72b0 <csem_free+0x119c>
    23a4:	00003097          	auipc	ra,0x3
    23a8:	758080e7          	jalr	1880(ra) # 5afc <unlink>
    23ac:	04054d63          	bltz	a0,2406 <iputtest+0x9e>
  if(chdir("/") < 0){
    23b0:	00005517          	auipc	a0,0x5
    23b4:	f3050513          	addi	a0,a0,-208 # 72e0 <csem_free+0x11cc>
    23b8:	00003097          	auipc	ra,0x3
    23bc:	764080e7          	jalr	1892(ra) # 5b1c <chdir>
    23c0:	06054163          	bltz	a0,2422 <iputtest+0xba>
}
    23c4:	60e2                	ld	ra,24(sp)
    23c6:	6442                	ld	s0,16(sp)
    23c8:	64a2                	ld	s1,8(sp)
    23ca:	6105                	addi	sp,sp,32
    23cc:	8082                	ret
    printf("%s: mkdir failed\n", s);
    23ce:	85a6                	mv	a1,s1
    23d0:	00005517          	auipc	a0,0x5
    23d4:	ea850513          	addi	a0,a0,-344 # 7278 <csem_free+0x1164>
    23d8:	00004097          	auipc	ra,0x4
    23dc:	aa6080e7          	jalr	-1370(ra) # 5e7e <printf>
    exit(1);
    23e0:	4505                	li	a0,1
    23e2:	00003097          	auipc	ra,0x3
    23e6:	6ca080e7          	jalr	1738(ra) # 5aac <exit>
    printf("%s: chdir iputdir failed\n", s);
    23ea:	85a6                	mv	a1,s1
    23ec:	00005517          	auipc	a0,0x5
    23f0:	ea450513          	addi	a0,a0,-348 # 7290 <csem_free+0x117c>
    23f4:	00004097          	auipc	ra,0x4
    23f8:	a8a080e7          	jalr	-1398(ra) # 5e7e <printf>
    exit(1);
    23fc:	4505                	li	a0,1
    23fe:	00003097          	auipc	ra,0x3
    2402:	6ae080e7          	jalr	1710(ra) # 5aac <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2406:	85a6                	mv	a1,s1
    2408:	00005517          	auipc	a0,0x5
    240c:	eb850513          	addi	a0,a0,-328 # 72c0 <csem_free+0x11ac>
    2410:	00004097          	auipc	ra,0x4
    2414:	a6e080e7          	jalr	-1426(ra) # 5e7e <printf>
    exit(1);
    2418:	4505                	li	a0,1
    241a:	00003097          	auipc	ra,0x3
    241e:	692080e7          	jalr	1682(ra) # 5aac <exit>
    printf("%s: chdir / failed\n", s);
    2422:	85a6                	mv	a1,s1
    2424:	00005517          	auipc	a0,0x5
    2428:	ec450513          	addi	a0,a0,-316 # 72e8 <csem_free+0x11d4>
    242c:	00004097          	auipc	ra,0x4
    2430:	a52080e7          	jalr	-1454(ra) # 5e7e <printf>
    exit(1);
    2434:	4505                	li	a0,1
    2436:	00003097          	auipc	ra,0x3
    243a:	676080e7          	jalr	1654(ra) # 5aac <exit>

000000000000243e <exitiputtest>:
{
    243e:	7179                	addi	sp,sp,-48
    2440:	f406                	sd	ra,40(sp)
    2442:	f022                	sd	s0,32(sp)
    2444:	ec26                	sd	s1,24(sp)
    2446:	1800                	addi	s0,sp,48
    2448:	84aa                	mv	s1,a0
  pid = fork();
    244a:	00003097          	auipc	ra,0x3
    244e:	65a080e7          	jalr	1626(ra) # 5aa4 <fork>
  if(pid < 0){
    2452:	04054663          	bltz	a0,249e <exitiputtest+0x60>
  if(pid == 0){
    2456:	ed45                	bnez	a0,250e <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2458:	00005517          	auipc	a0,0x5
    245c:	e1850513          	addi	a0,a0,-488 # 7270 <csem_free+0x115c>
    2460:	00003097          	auipc	ra,0x3
    2464:	6b4080e7          	jalr	1716(ra) # 5b14 <mkdir>
    2468:	04054963          	bltz	a0,24ba <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    246c:	00005517          	auipc	a0,0x5
    2470:	e0450513          	addi	a0,a0,-508 # 7270 <csem_free+0x115c>
    2474:	00003097          	auipc	ra,0x3
    2478:	6a8080e7          	jalr	1704(ra) # 5b1c <chdir>
    247c:	04054d63          	bltz	a0,24d6 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2480:	00005517          	auipc	a0,0x5
    2484:	e3050513          	addi	a0,a0,-464 # 72b0 <csem_free+0x119c>
    2488:	00003097          	auipc	ra,0x3
    248c:	674080e7          	jalr	1652(ra) # 5afc <unlink>
    2490:	06054163          	bltz	a0,24f2 <exitiputtest+0xb4>
    exit(0);
    2494:	4501                	li	a0,0
    2496:	00003097          	auipc	ra,0x3
    249a:	616080e7          	jalr	1558(ra) # 5aac <exit>
    printf("%s: fork failed\n", s);
    249e:	85a6                	mv	a1,s1
    24a0:	00004517          	auipc	a0,0x4
    24a4:	fa850513          	addi	a0,a0,-88 # 6448 <csem_free+0x334>
    24a8:	00004097          	auipc	ra,0x4
    24ac:	9d6080e7          	jalr	-1578(ra) # 5e7e <printf>
    exit(1);
    24b0:	4505                	li	a0,1
    24b2:	00003097          	auipc	ra,0x3
    24b6:	5fa080e7          	jalr	1530(ra) # 5aac <exit>
      printf("%s: mkdir failed\n", s);
    24ba:	85a6                	mv	a1,s1
    24bc:	00005517          	auipc	a0,0x5
    24c0:	dbc50513          	addi	a0,a0,-580 # 7278 <csem_free+0x1164>
    24c4:	00004097          	auipc	ra,0x4
    24c8:	9ba080e7          	jalr	-1606(ra) # 5e7e <printf>
      exit(1);
    24cc:	4505                	li	a0,1
    24ce:	00003097          	auipc	ra,0x3
    24d2:	5de080e7          	jalr	1502(ra) # 5aac <exit>
      printf("%s: child chdir failed\n", s);
    24d6:	85a6                	mv	a1,s1
    24d8:	00005517          	auipc	a0,0x5
    24dc:	e2850513          	addi	a0,a0,-472 # 7300 <csem_free+0x11ec>
    24e0:	00004097          	auipc	ra,0x4
    24e4:	99e080e7          	jalr	-1634(ra) # 5e7e <printf>
      exit(1);
    24e8:	4505                	li	a0,1
    24ea:	00003097          	auipc	ra,0x3
    24ee:	5c2080e7          	jalr	1474(ra) # 5aac <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    24f2:	85a6                	mv	a1,s1
    24f4:	00005517          	auipc	a0,0x5
    24f8:	dcc50513          	addi	a0,a0,-564 # 72c0 <csem_free+0x11ac>
    24fc:	00004097          	auipc	ra,0x4
    2500:	982080e7          	jalr	-1662(ra) # 5e7e <printf>
      exit(1);
    2504:	4505                	li	a0,1
    2506:	00003097          	auipc	ra,0x3
    250a:	5a6080e7          	jalr	1446(ra) # 5aac <exit>
  wait(&xstatus);
    250e:	fdc40513          	addi	a0,s0,-36
    2512:	00003097          	auipc	ra,0x3
    2516:	5a2080e7          	jalr	1442(ra) # 5ab4 <wait>
  exit(xstatus);
    251a:	fdc42503          	lw	a0,-36(s0)
    251e:	00003097          	auipc	ra,0x3
    2522:	58e080e7          	jalr	1422(ra) # 5aac <exit>

0000000000002526 <dirtest>:
{
    2526:	1101                	addi	sp,sp,-32
    2528:	ec06                	sd	ra,24(sp)
    252a:	e822                	sd	s0,16(sp)
    252c:	e426                	sd	s1,8(sp)
    252e:	1000                	addi	s0,sp,32
    2530:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2532:	00005517          	auipc	a0,0x5
    2536:	de650513          	addi	a0,a0,-538 # 7318 <csem_free+0x1204>
    253a:	00003097          	auipc	ra,0x3
    253e:	5da080e7          	jalr	1498(ra) # 5b14 <mkdir>
    2542:	04054563          	bltz	a0,258c <dirtest+0x66>
  if(chdir("dir0") < 0){
    2546:	00005517          	auipc	a0,0x5
    254a:	dd250513          	addi	a0,a0,-558 # 7318 <csem_free+0x1204>
    254e:	00003097          	auipc	ra,0x3
    2552:	5ce080e7          	jalr	1486(ra) # 5b1c <chdir>
    2556:	04054963          	bltz	a0,25a8 <dirtest+0x82>
  if(chdir("..") < 0){
    255a:	00005517          	auipc	a0,0x5
    255e:	dde50513          	addi	a0,a0,-546 # 7338 <csem_free+0x1224>
    2562:	00003097          	auipc	ra,0x3
    2566:	5ba080e7          	jalr	1466(ra) # 5b1c <chdir>
    256a:	04054d63          	bltz	a0,25c4 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    256e:	00005517          	auipc	a0,0x5
    2572:	daa50513          	addi	a0,a0,-598 # 7318 <csem_free+0x1204>
    2576:	00003097          	auipc	ra,0x3
    257a:	586080e7          	jalr	1414(ra) # 5afc <unlink>
    257e:	06054163          	bltz	a0,25e0 <dirtest+0xba>
}
    2582:	60e2                	ld	ra,24(sp)
    2584:	6442                	ld	s0,16(sp)
    2586:	64a2                	ld	s1,8(sp)
    2588:	6105                	addi	sp,sp,32
    258a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    258c:	85a6                	mv	a1,s1
    258e:	00005517          	auipc	a0,0x5
    2592:	cea50513          	addi	a0,a0,-790 # 7278 <csem_free+0x1164>
    2596:	00004097          	auipc	ra,0x4
    259a:	8e8080e7          	jalr	-1816(ra) # 5e7e <printf>
    exit(1);
    259e:	4505                	li	a0,1
    25a0:	00003097          	auipc	ra,0x3
    25a4:	50c080e7          	jalr	1292(ra) # 5aac <exit>
    printf("%s: chdir dir0 failed\n", s);
    25a8:	85a6                	mv	a1,s1
    25aa:	00005517          	auipc	a0,0x5
    25ae:	d7650513          	addi	a0,a0,-650 # 7320 <csem_free+0x120c>
    25b2:	00004097          	auipc	ra,0x4
    25b6:	8cc080e7          	jalr	-1844(ra) # 5e7e <printf>
    exit(1);
    25ba:	4505                	li	a0,1
    25bc:	00003097          	auipc	ra,0x3
    25c0:	4f0080e7          	jalr	1264(ra) # 5aac <exit>
    printf("%s: chdir .. failed\n", s);
    25c4:	85a6                	mv	a1,s1
    25c6:	00005517          	auipc	a0,0x5
    25ca:	d7a50513          	addi	a0,a0,-646 # 7340 <csem_free+0x122c>
    25ce:	00004097          	auipc	ra,0x4
    25d2:	8b0080e7          	jalr	-1872(ra) # 5e7e <printf>
    exit(1);
    25d6:	4505                	li	a0,1
    25d8:	00003097          	auipc	ra,0x3
    25dc:	4d4080e7          	jalr	1236(ra) # 5aac <exit>
    printf("%s: unlink dir0 failed\n", s);
    25e0:	85a6                	mv	a1,s1
    25e2:	00005517          	auipc	a0,0x5
    25e6:	d7650513          	addi	a0,a0,-650 # 7358 <csem_free+0x1244>
    25ea:	00004097          	auipc	ra,0x4
    25ee:	894080e7          	jalr	-1900(ra) # 5e7e <printf>
    exit(1);
    25f2:	4505                	li	a0,1
    25f4:	00003097          	auipc	ra,0x3
    25f8:	4b8080e7          	jalr	1208(ra) # 5aac <exit>

00000000000025fc <subdir>:
{
    25fc:	1101                	addi	sp,sp,-32
    25fe:	ec06                	sd	ra,24(sp)
    2600:	e822                	sd	s0,16(sp)
    2602:	e426                	sd	s1,8(sp)
    2604:	e04a                	sd	s2,0(sp)
    2606:	1000                	addi	s0,sp,32
    2608:	892a                	mv	s2,a0
  unlink("ff");
    260a:	00005517          	auipc	a0,0x5
    260e:	e9650513          	addi	a0,a0,-362 # 74a0 <csem_free+0x138c>
    2612:	00003097          	auipc	ra,0x3
    2616:	4ea080e7          	jalr	1258(ra) # 5afc <unlink>
  if(mkdir("dd") != 0){
    261a:	00005517          	auipc	a0,0x5
    261e:	d5650513          	addi	a0,a0,-682 # 7370 <csem_free+0x125c>
    2622:	00003097          	auipc	ra,0x3
    2626:	4f2080e7          	jalr	1266(ra) # 5b14 <mkdir>
    262a:	38051663          	bnez	a0,29b6 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    262e:	20200593          	li	a1,514
    2632:	00005517          	auipc	a0,0x5
    2636:	d5e50513          	addi	a0,a0,-674 # 7390 <csem_free+0x127c>
    263a:	00003097          	auipc	ra,0x3
    263e:	4b2080e7          	jalr	1202(ra) # 5aec <open>
    2642:	84aa                	mv	s1,a0
  if(fd < 0){
    2644:	38054763          	bltz	a0,29d2 <subdir+0x3d6>
  write(fd, "ff", 2);
    2648:	4609                	li	a2,2
    264a:	00005597          	auipc	a1,0x5
    264e:	e5658593          	addi	a1,a1,-426 # 74a0 <csem_free+0x138c>
    2652:	00003097          	auipc	ra,0x3
    2656:	47a080e7          	jalr	1146(ra) # 5acc <write>
  close(fd);
    265a:	8526                	mv	a0,s1
    265c:	00003097          	auipc	ra,0x3
    2660:	478080e7          	jalr	1144(ra) # 5ad4 <close>
  if(unlink("dd") >= 0){
    2664:	00005517          	auipc	a0,0x5
    2668:	d0c50513          	addi	a0,a0,-756 # 7370 <csem_free+0x125c>
    266c:	00003097          	auipc	ra,0x3
    2670:	490080e7          	jalr	1168(ra) # 5afc <unlink>
    2674:	36055d63          	bgez	a0,29ee <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    2678:	00005517          	auipc	a0,0x5
    267c:	d7050513          	addi	a0,a0,-656 # 73e8 <csem_free+0x12d4>
    2680:	00003097          	auipc	ra,0x3
    2684:	494080e7          	jalr	1172(ra) # 5b14 <mkdir>
    2688:	38051163          	bnez	a0,2a0a <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    268c:	20200593          	li	a1,514
    2690:	00005517          	auipc	a0,0x5
    2694:	d8050513          	addi	a0,a0,-640 # 7410 <csem_free+0x12fc>
    2698:	00003097          	auipc	ra,0x3
    269c:	454080e7          	jalr	1108(ra) # 5aec <open>
    26a0:	84aa                	mv	s1,a0
  if(fd < 0){
    26a2:	38054263          	bltz	a0,2a26 <subdir+0x42a>
  write(fd, "FF", 2);
    26a6:	4609                	li	a2,2
    26a8:	00005597          	auipc	a1,0x5
    26ac:	d9858593          	addi	a1,a1,-616 # 7440 <csem_free+0x132c>
    26b0:	00003097          	auipc	ra,0x3
    26b4:	41c080e7          	jalr	1052(ra) # 5acc <write>
  close(fd);
    26b8:	8526                	mv	a0,s1
    26ba:	00003097          	auipc	ra,0x3
    26be:	41a080e7          	jalr	1050(ra) # 5ad4 <close>
  fd = open("dd/dd/../ff", 0);
    26c2:	4581                	li	a1,0
    26c4:	00005517          	auipc	a0,0x5
    26c8:	d8450513          	addi	a0,a0,-636 # 7448 <csem_free+0x1334>
    26cc:	00003097          	auipc	ra,0x3
    26d0:	420080e7          	jalr	1056(ra) # 5aec <open>
    26d4:	84aa                	mv	s1,a0
  if(fd < 0){
    26d6:	36054663          	bltz	a0,2a42 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    26da:	660d                	lui	a2,0x3
    26dc:	0000a597          	auipc	a1,0xa
    26e0:	a0458593          	addi	a1,a1,-1532 # c0e0 <buf>
    26e4:	00003097          	auipc	ra,0x3
    26e8:	3e0080e7          	jalr	992(ra) # 5ac4 <read>
  if(cc != 2 || buf[0] != 'f'){
    26ec:	4789                	li	a5,2
    26ee:	36f51863          	bne	a0,a5,2a5e <subdir+0x462>
    26f2:	0000a717          	auipc	a4,0xa
    26f6:	9ee74703          	lbu	a4,-1554(a4) # c0e0 <buf>
    26fa:	06600793          	li	a5,102
    26fe:	36f71063          	bne	a4,a5,2a5e <subdir+0x462>
  close(fd);
    2702:	8526                	mv	a0,s1
    2704:	00003097          	auipc	ra,0x3
    2708:	3d0080e7          	jalr	976(ra) # 5ad4 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    270c:	00005597          	auipc	a1,0x5
    2710:	d8c58593          	addi	a1,a1,-628 # 7498 <csem_free+0x1384>
    2714:	00005517          	auipc	a0,0x5
    2718:	cfc50513          	addi	a0,a0,-772 # 7410 <csem_free+0x12fc>
    271c:	00003097          	auipc	ra,0x3
    2720:	3f0080e7          	jalr	1008(ra) # 5b0c <link>
    2724:	34051b63          	bnez	a0,2a7a <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    2728:	00005517          	auipc	a0,0x5
    272c:	ce850513          	addi	a0,a0,-792 # 7410 <csem_free+0x12fc>
    2730:	00003097          	auipc	ra,0x3
    2734:	3cc080e7          	jalr	972(ra) # 5afc <unlink>
    2738:	34051f63          	bnez	a0,2a96 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    273c:	4581                	li	a1,0
    273e:	00005517          	auipc	a0,0x5
    2742:	cd250513          	addi	a0,a0,-814 # 7410 <csem_free+0x12fc>
    2746:	00003097          	auipc	ra,0x3
    274a:	3a6080e7          	jalr	934(ra) # 5aec <open>
    274e:	36055263          	bgez	a0,2ab2 <subdir+0x4b6>
  if(chdir("dd") != 0){
    2752:	00005517          	auipc	a0,0x5
    2756:	c1e50513          	addi	a0,a0,-994 # 7370 <csem_free+0x125c>
    275a:	00003097          	auipc	ra,0x3
    275e:	3c2080e7          	jalr	962(ra) # 5b1c <chdir>
    2762:	36051663          	bnez	a0,2ace <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    2766:	00005517          	auipc	a0,0x5
    276a:	dca50513          	addi	a0,a0,-566 # 7530 <csem_free+0x141c>
    276e:	00003097          	auipc	ra,0x3
    2772:	3ae080e7          	jalr	942(ra) # 5b1c <chdir>
    2776:	36051a63          	bnez	a0,2aea <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    277a:	00005517          	auipc	a0,0x5
    277e:	de650513          	addi	a0,a0,-538 # 7560 <csem_free+0x144c>
    2782:	00003097          	auipc	ra,0x3
    2786:	39a080e7          	jalr	922(ra) # 5b1c <chdir>
    278a:	36051e63          	bnez	a0,2b06 <subdir+0x50a>
  if(chdir("./..") != 0){
    278e:	00005517          	auipc	a0,0x5
    2792:	e0250513          	addi	a0,a0,-510 # 7590 <csem_free+0x147c>
    2796:	00003097          	auipc	ra,0x3
    279a:	386080e7          	jalr	902(ra) # 5b1c <chdir>
    279e:	38051263          	bnez	a0,2b22 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    27a2:	4581                	li	a1,0
    27a4:	00005517          	auipc	a0,0x5
    27a8:	cf450513          	addi	a0,a0,-780 # 7498 <csem_free+0x1384>
    27ac:	00003097          	auipc	ra,0x3
    27b0:	340080e7          	jalr	832(ra) # 5aec <open>
    27b4:	84aa                	mv	s1,a0
  if(fd < 0){
    27b6:	38054463          	bltz	a0,2b3e <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    27ba:	660d                	lui	a2,0x3
    27bc:	0000a597          	auipc	a1,0xa
    27c0:	92458593          	addi	a1,a1,-1756 # c0e0 <buf>
    27c4:	00003097          	auipc	ra,0x3
    27c8:	300080e7          	jalr	768(ra) # 5ac4 <read>
    27cc:	4789                	li	a5,2
    27ce:	38f51663          	bne	a0,a5,2b5a <subdir+0x55e>
  close(fd);
    27d2:	8526                	mv	a0,s1
    27d4:	00003097          	auipc	ra,0x3
    27d8:	300080e7          	jalr	768(ra) # 5ad4 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    27dc:	4581                	li	a1,0
    27de:	00005517          	auipc	a0,0x5
    27e2:	c3250513          	addi	a0,a0,-974 # 7410 <csem_free+0x12fc>
    27e6:	00003097          	auipc	ra,0x3
    27ea:	306080e7          	jalr	774(ra) # 5aec <open>
    27ee:	38055463          	bgez	a0,2b76 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    27f2:	20200593          	li	a1,514
    27f6:	00005517          	auipc	a0,0x5
    27fa:	e2a50513          	addi	a0,a0,-470 # 7620 <csem_free+0x150c>
    27fe:	00003097          	auipc	ra,0x3
    2802:	2ee080e7          	jalr	750(ra) # 5aec <open>
    2806:	38055663          	bgez	a0,2b92 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    280a:	20200593          	li	a1,514
    280e:	00005517          	auipc	a0,0x5
    2812:	e4250513          	addi	a0,a0,-446 # 7650 <csem_free+0x153c>
    2816:	00003097          	auipc	ra,0x3
    281a:	2d6080e7          	jalr	726(ra) # 5aec <open>
    281e:	38055863          	bgez	a0,2bae <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    2822:	20000593          	li	a1,512
    2826:	00005517          	auipc	a0,0x5
    282a:	b4a50513          	addi	a0,a0,-1206 # 7370 <csem_free+0x125c>
    282e:	00003097          	auipc	ra,0x3
    2832:	2be080e7          	jalr	702(ra) # 5aec <open>
    2836:	38055a63          	bgez	a0,2bca <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    283a:	4589                	li	a1,2
    283c:	00005517          	auipc	a0,0x5
    2840:	b3450513          	addi	a0,a0,-1228 # 7370 <csem_free+0x125c>
    2844:	00003097          	auipc	ra,0x3
    2848:	2a8080e7          	jalr	680(ra) # 5aec <open>
    284c:	38055d63          	bgez	a0,2be6 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    2850:	4585                	li	a1,1
    2852:	00005517          	auipc	a0,0x5
    2856:	b1e50513          	addi	a0,a0,-1250 # 7370 <csem_free+0x125c>
    285a:	00003097          	auipc	ra,0x3
    285e:	292080e7          	jalr	658(ra) # 5aec <open>
    2862:	3a055063          	bgez	a0,2c02 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2866:	00005597          	auipc	a1,0x5
    286a:	e7a58593          	addi	a1,a1,-390 # 76e0 <csem_free+0x15cc>
    286e:	00005517          	auipc	a0,0x5
    2872:	db250513          	addi	a0,a0,-590 # 7620 <csem_free+0x150c>
    2876:	00003097          	auipc	ra,0x3
    287a:	296080e7          	jalr	662(ra) # 5b0c <link>
    287e:	3a050063          	beqz	a0,2c1e <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2882:	00005597          	auipc	a1,0x5
    2886:	e5e58593          	addi	a1,a1,-418 # 76e0 <csem_free+0x15cc>
    288a:	00005517          	auipc	a0,0x5
    288e:	dc650513          	addi	a0,a0,-570 # 7650 <csem_free+0x153c>
    2892:	00003097          	auipc	ra,0x3
    2896:	27a080e7          	jalr	634(ra) # 5b0c <link>
    289a:	3a050063          	beqz	a0,2c3a <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    289e:	00005597          	auipc	a1,0x5
    28a2:	bfa58593          	addi	a1,a1,-1030 # 7498 <csem_free+0x1384>
    28a6:	00005517          	auipc	a0,0x5
    28aa:	aea50513          	addi	a0,a0,-1302 # 7390 <csem_free+0x127c>
    28ae:	00003097          	auipc	ra,0x3
    28b2:	25e080e7          	jalr	606(ra) # 5b0c <link>
    28b6:	3a050063          	beqz	a0,2c56 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    28ba:	00005517          	auipc	a0,0x5
    28be:	d6650513          	addi	a0,a0,-666 # 7620 <csem_free+0x150c>
    28c2:	00003097          	auipc	ra,0x3
    28c6:	252080e7          	jalr	594(ra) # 5b14 <mkdir>
    28ca:	3a050463          	beqz	a0,2c72 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    28ce:	00005517          	auipc	a0,0x5
    28d2:	d8250513          	addi	a0,a0,-638 # 7650 <csem_free+0x153c>
    28d6:	00003097          	auipc	ra,0x3
    28da:	23e080e7          	jalr	574(ra) # 5b14 <mkdir>
    28de:	3a050863          	beqz	a0,2c8e <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    28e2:	00005517          	auipc	a0,0x5
    28e6:	bb650513          	addi	a0,a0,-1098 # 7498 <csem_free+0x1384>
    28ea:	00003097          	auipc	ra,0x3
    28ee:	22a080e7          	jalr	554(ra) # 5b14 <mkdir>
    28f2:	3a050c63          	beqz	a0,2caa <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    28f6:	00005517          	auipc	a0,0x5
    28fa:	d5a50513          	addi	a0,a0,-678 # 7650 <csem_free+0x153c>
    28fe:	00003097          	auipc	ra,0x3
    2902:	1fe080e7          	jalr	510(ra) # 5afc <unlink>
    2906:	3c050063          	beqz	a0,2cc6 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    290a:	00005517          	auipc	a0,0x5
    290e:	d1650513          	addi	a0,a0,-746 # 7620 <csem_free+0x150c>
    2912:	00003097          	auipc	ra,0x3
    2916:	1ea080e7          	jalr	490(ra) # 5afc <unlink>
    291a:	3c050463          	beqz	a0,2ce2 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    291e:	00005517          	auipc	a0,0x5
    2922:	a7250513          	addi	a0,a0,-1422 # 7390 <csem_free+0x127c>
    2926:	00003097          	auipc	ra,0x3
    292a:	1f6080e7          	jalr	502(ra) # 5b1c <chdir>
    292e:	3c050863          	beqz	a0,2cfe <subdir+0x702>
  if(chdir("dd/xx") == 0){
    2932:	00005517          	auipc	a0,0x5
    2936:	efe50513          	addi	a0,a0,-258 # 7830 <csem_free+0x171c>
    293a:	00003097          	auipc	ra,0x3
    293e:	1e2080e7          	jalr	482(ra) # 5b1c <chdir>
    2942:	3c050c63          	beqz	a0,2d1a <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    2946:	00005517          	auipc	a0,0x5
    294a:	b5250513          	addi	a0,a0,-1198 # 7498 <csem_free+0x1384>
    294e:	00003097          	auipc	ra,0x3
    2952:	1ae080e7          	jalr	430(ra) # 5afc <unlink>
    2956:	3e051063          	bnez	a0,2d36 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    295a:	00005517          	auipc	a0,0x5
    295e:	a3650513          	addi	a0,a0,-1482 # 7390 <csem_free+0x127c>
    2962:	00003097          	auipc	ra,0x3
    2966:	19a080e7          	jalr	410(ra) # 5afc <unlink>
    296a:	3e051463          	bnez	a0,2d52 <subdir+0x756>
  if(unlink("dd") == 0){
    296e:	00005517          	auipc	a0,0x5
    2972:	a0250513          	addi	a0,a0,-1534 # 7370 <csem_free+0x125c>
    2976:	00003097          	auipc	ra,0x3
    297a:	186080e7          	jalr	390(ra) # 5afc <unlink>
    297e:	3e050863          	beqz	a0,2d6e <subdir+0x772>
  if(unlink("dd/dd") < 0){
    2982:	00005517          	auipc	a0,0x5
    2986:	f1e50513          	addi	a0,a0,-226 # 78a0 <csem_free+0x178c>
    298a:	00003097          	auipc	ra,0x3
    298e:	172080e7          	jalr	370(ra) # 5afc <unlink>
    2992:	3e054c63          	bltz	a0,2d8a <subdir+0x78e>
  if(unlink("dd") < 0){
    2996:	00005517          	auipc	a0,0x5
    299a:	9da50513          	addi	a0,a0,-1574 # 7370 <csem_free+0x125c>
    299e:	00003097          	auipc	ra,0x3
    29a2:	15e080e7          	jalr	350(ra) # 5afc <unlink>
    29a6:	40054063          	bltz	a0,2da6 <subdir+0x7aa>
}
    29aa:	60e2                	ld	ra,24(sp)
    29ac:	6442                	ld	s0,16(sp)
    29ae:	64a2                	ld	s1,8(sp)
    29b0:	6902                	ld	s2,0(sp)
    29b2:	6105                	addi	sp,sp,32
    29b4:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    29b6:	85ca                	mv	a1,s2
    29b8:	00005517          	auipc	a0,0x5
    29bc:	9c050513          	addi	a0,a0,-1600 # 7378 <csem_free+0x1264>
    29c0:	00003097          	auipc	ra,0x3
    29c4:	4be080e7          	jalr	1214(ra) # 5e7e <printf>
    exit(1);
    29c8:	4505                	li	a0,1
    29ca:	00003097          	auipc	ra,0x3
    29ce:	0e2080e7          	jalr	226(ra) # 5aac <exit>
    printf("%s: create dd/ff failed\n", s);
    29d2:	85ca                	mv	a1,s2
    29d4:	00005517          	auipc	a0,0x5
    29d8:	9c450513          	addi	a0,a0,-1596 # 7398 <csem_free+0x1284>
    29dc:	00003097          	auipc	ra,0x3
    29e0:	4a2080e7          	jalr	1186(ra) # 5e7e <printf>
    exit(1);
    29e4:	4505                	li	a0,1
    29e6:	00003097          	auipc	ra,0x3
    29ea:	0c6080e7          	jalr	198(ra) # 5aac <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    29ee:	85ca                	mv	a1,s2
    29f0:	00005517          	auipc	a0,0x5
    29f4:	9c850513          	addi	a0,a0,-1592 # 73b8 <csem_free+0x12a4>
    29f8:	00003097          	auipc	ra,0x3
    29fc:	486080e7          	jalr	1158(ra) # 5e7e <printf>
    exit(1);
    2a00:	4505                	li	a0,1
    2a02:	00003097          	auipc	ra,0x3
    2a06:	0aa080e7          	jalr	170(ra) # 5aac <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    2a0a:	85ca                	mv	a1,s2
    2a0c:	00005517          	auipc	a0,0x5
    2a10:	9e450513          	addi	a0,a0,-1564 # 73f0 <csem_free+0x12dc>
    2a14:	00003097          	auipc	ra,0x3
    2a18:	46a080e7          	jalr	1130(ra) # 5e7e <printf>
    exit(1);
    2a1c:	4505                	li	a0,1
    2a1e:	00003097          	auipc	ra,0x3
    2a22:	08e080e7          	jalr	142(ra) # 5aac <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2a26:	85ca                	mv	a1,s2
    2a28:	00005517          	auipc	a0,0x5
    2a2c:	9f850513          	addi	a0,a0,-1544 # 7420 <csem_free+0x130c>
    2a30:	00003097          	auipc	ra,0x3
    2a34:	44e080e7          	jalr	1102(ra) # 5e7e <printf>
    exit(1);
    2a38:	4505                	li	a0,1
    2a3a:	00003097          	auipc	ra,0x3
    2a3e:	072080e7          	jalr	114(ra) # 5aac <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2a42:	85ca                	mv	a1,s2
    2a44:	00005517          	auipc	a0,0x5
    2a48:	a1450513          	addi	a0,a0,-1516 # 7458 <csem_free+0x1344>
    2a4c:	00003097          	auipc	ra,0x3
    2a50:	432080e7          	jalr	1074(ra) # 5e7e <printf>
    exit(1);
    2a54:	4505                	li	a0,1
    2a56:	00003097          	auipc	ra,0x3
    2a5a:	056080e7          	jalr	86(ra) # 5aac <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2a5e:	85ca                	mv	a1,s2
    2a60:	00005517          	auipc	a0,0x5
    2a64:	a1850513          	addi	a0,a0,-1512 # 7478 <csem_free+0x1364>
    2a68:	00003097          	auipc	ra,0x3
    2a6c:	416080e7          	jalr	1046(ra) # 5e7e <printf>
    exit(1);
    2a70:	4505                	li	a0,1
    2a72:	00003097          	auipc	ra,0x3
    2a76:	03a080e7          	jalr	58(ra) # 5aac <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    2a7a:	85ca                	mv	a1,s2
    2a7c:	00005517          	auipc	a0,0x5
    2a80:	a2c50513          	addi	a0,a0,-1492 # 74a8 <csem_free+0x1394>
    2a84:	00003097          	auipc	ra,0x3
    2a88:	3fa080e7          	jalr	1018(ra) # 5e7e <printf>
    exit(1);
    2a8c:	4505                	li	a0,1
    2a8e:	00003097          	auipc	ra,0x3
    2a92:	01e080e7          	jalr	30(ra) # 5aac <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2a96:	85ca                	mv	a1,s2
    2a98:	00005517          	auipc	a0,0x5
    2a9c:	a3850513          	addi	a0,a0,-1480 # 74d0 <csem_free+0x13bc>
    2aa0:	00003097          	auipc	ra,0x3
    2aa4:	3de080e7          	jalr	990(ra) # 5e7e <printf>
    exit(1);
    2aa8:	4505                	li	a0,1
    2aaa:	00003097          	auipc	ra,0x3
    2aae:	002080e7          	jalr	2(ra) # 5aac <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2ab2:	85ca                	mv	a1,s2
    2ab4:	00005517          	auipc	a0,0x5
    2ab8:	a3c50513          	addi	a0,a0,-1476 # 74f0 <csem_free+0x13dc>
    2abc:	00003097          	auipc	ra,0x3
    2ac0:	3c2080e7          	jalr	962(ra) # 5e7e <printf>
    exit(1);
    2ac4:	4505                	li	a0,1
    2ac6:	00003097          	auipc	ra,0x3
    2aca:	fe6080e7          	jalr	-26(ra) # 5aac <exit>
    printf("%s: chdir dd failed\n", s);
    2ace:	85ca                	mv	a1,s2
    2ad0:	00005517          	auipc	a0,0x5
    2ad4:	a4850513          	addi	a0,a0,-1464 # 7518 <csem_free+0x1404>
    2ad8:	00003097          	auipc	ra,0x3
    2adc:	3a6080e7          	jalr	934(ra) # 5e7e <printf>
    exit(1);
    2ae0:	4505                	li	a0,1
    2ae2:	00003097          	auipc	ra,0x3
    2ae6:	fca080e7          	jalr	-54(ra) # 5aac <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2aea:	85ca                	mv	a1,s2
    2aec:	00005517          	auipc	a0,0x5
    2af0:	a5450513          	addi	a0,a0,-1452 # 7540 <csem_free+0x142c>
    2af4:	00003097          	auipc	ra,0x3
    2af8:	38a080e7          	jalr	906(ra) # 5e7e <printf>
    exit(1);
    2afc:	4505                	li	a0,1
    2afe:	00003097          	auipc	ra,0x3
    2b02:	fae080e7          	jalr	-82(ra) # 5aac <exit>
    printf("chdir dd/../../dd failed\n", s);
    2b06:	85ca                	mv	a1,s2
    2b08:	00005517          	auipc	a0,0x5
    2b0c:	a6850513          	addi	a0,a0,-1432 # 7570 <csem_free+0x145c>
    2b10:	00003097          	auipc	ra,0x3
    2b14:	36e080e7          	jalr	878(ra) # 5e7e <printf>
    exit(1);
    2b18:	4505                	li	a0,1
    2b1a:	00003097          	auipc	ra,0x3
    2b1e:	f92080e7          	jalr	-110(ra) # 5aac <exit>
    printf("%s: chdir ./.. failed\n", s);
    2b22:	85ca                	mv	a1,s2
    2b24:	00005517          	auipc	a0,0x5
    2b28:	a7450513          	addi	a0,a0,-1420 # 7598 <csem_free+0x1484>
    2b2c:	00003097          	auipc	ra,0x3
    2b30:	352080e7          	jalr	850(ra) # 5e7e <printf>
    exit(1);
    2b34:	4505                	li	a0,1
    2b36:	00003097          	auipc	ra,0x3
    2b3a:	f76080e7          	jalr	-138(ra) # 5aac <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2b3e:	85ca                	mv	a1,s2
    2b40:	00005517          	auipc	a0,0x5
    2b44:	a7050513          	addi	a0,a0,-1424 # 75b0 <csem_free+0x149c>
    2b48:	00003097          	auipc	ra,0x3
    2b4c:	336080e7          	jalr	822(ra) # 5e7e <printf>
    exit(1);
    2b50:	4505                	li	a0,1
    2b52:	00003097          	auipc	ra,0x3
    2b56:	f5a080e7          	jalr	-166(ra) # 5aac <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2b5a:	85ca                	mv	a1,s2
    2b5c:	00005517          	auipc	a0,0x5
    2b60:	a7450513          	addi	a0,a0,-1420 # 75d0 <csem_free+0x14bc>
    2b64:	00003097          	auipc	ra,0x3
    2b68:	31a080e7          	jalr	794(ra) # 5e7e <printf>
    exit(1);
    2b6c:	4505                	li	a0,1
    2b6e:	00003097          	auipc	ra,0x3
    2b72:	f3e080e7          	jalr	-194(ra) # 5aac <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2b76:	85ca                	mv	a1,s2
    2b78:	00005517          	auipc	a0,0x5
    2b7c:	a7850513          	addi	a0,a0,-1416 # 75f0 <csem_free+0x14dc>
    2b80:	00003097          	auipc	ra,0x3
    2b84:	2fe080e7          	jalr	766(ra) # 5e7e <printf>
    exit(1);
    2b88:	4505                	li	a0,1
    2b8a:	00003097          	auipc	ra,0x3
    2b8e:	f22080e7          	jalr	-222(ra) # 5aac <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2b92:	85ca                	mv	a1,s2
    2b94:	00005517          	auipc	a0,0x5
    2b98:	a9c50513          	addi	a0,a0,-1380 # 7630 <csem_free+0x151c>
    2b9c:	00003097          	auipc	ra,0x3
    2ba0:	2e2080e7          	jalr	738(ra) # 5e7e <printf>
    exit(1);
    2ba4:	4505                	li	a0,1
    2ba6:	00003097          	auipc	ra,0x3
    2baa:	f06080e7          	jalr	-250(ra) # 5aac <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2bae:	85ca                	mv	a1,s2
    2bb0:	00005517          	auipc	a0,0x5
    2bb4:	ab050513          	addi	a0,a0,-1360 # 7660 <csem_free+0x154c>
    2bb8:	00003097          	auipc	ra,0x3
    2bbc:	2c6080e7          	jalr	710(ra) # 5e7e <printf>
    exit(1);
    2bc0:	4505                	li	a0,1
    2bc2:	00003097          	auipc	ra,0x3
    2bc6:	eea080e7          	jalr	-278(ra) # 5aac <exit>
    printf("%s: create dd succeeded!\n", s);
    2bca:	85ca                	mv	a1,s2
    2bcc:	00005517          	auipc	a0,0x5
    2bd0:	ab450513          	addi	a0,a0,-1356 # 7680 <csem_free+0x156c>
    2bd4:	00003097          	auipc	ra,0x3
    2bd8:	2aa080e7          	jalr	682(ra) # 5e7e <printf>
    exit(1);
    2bdc:	4505                	li	a0,1
    2bde:	00003097          	auipc	ra,0x3
    2be2:	ece080e7          	jalr	-306(ra) # 5aac <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    2be6:	85ca                	mv	a1,s2
    2be8:	00005517          	auipc	a0,0x5
    2bec:	ab850513          	addi	a0,a0,-1352 # 76a0 <csem_free+0x158c>
    2bf0:	00003097          	auipc	ra,0x3
    2bf4:	28e080e7          	jalr	654(ra) # 5e7e <printf>
    exit(1);
    2bf8:	4505                	li	a0,1
    2bfa:	00003097          	auipc	ra,0x3
    2bfe:	eb2080e7          	jalr	-334(ra) # 5aac <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    2c02:	85ca                	mv	a1,s2
    2c04:	00005517          	auipc	a0,0x5
    2c08:	abc50513          	addi	a0,a0,-1348 # 76c0 <csem_free+0x15ac>
    2c0c:	00003097          	auipc	ra,0x3
    2c10:	272080e7          	jalr	626(ra) # 5e7e <printf>
    exit(1);
    2c14:	4505                	li	a0,1
    2c16:	00003097          	auipc	ra,0x3
    2c1a:	e96080e7          	jalr	-362(ra) # 5aac <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    2c1e:	85ca                	mv	a1,s2
    2c20:	00005517          	auipc	a0,0x5
    2c24:	ad050513          	addi	a0,a0,-1328 # 76f0 <csem_free+0x15dc>
    2c28:	00003097          	auipc	ra,0x3
    2c2c:	256080e7          	jalr	598(ra) # 5e7e <printf>
    exit(1);
    2c30:	4505                	li	a0,1
    2c32:	00003097          	auipc	ra,0x3
    2c36:	e7a080e7          	jalr	-390(ra) # 5aac <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    2c3a:	85ca                	mv	a1,s2
    2c3c:	00005517          	auipc	a0,0x5
    2c40:	adc50513          	addi	a0,a0,-1316 # 7718 <csem_free+0x1604>
    2c44:	00003097          	auipc	ra,0x3
    2c48:	23a080e7          	jalr	570(ra) # 5e7e <printf>
    exit(1);
    2c4c:	4505                	li	a0,1
    2c4e:	00003097          	auipc	ra,0x3
    2c52:	e5e080e7          	jalr	-418(ra) # 5aac <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    2c56:	85ca                	mv	a1,s2
    2c58:	00005517          	auipc	a0,0x5
    2c5c:	ae850513          	addi	a0,a0,-1304 # 7740 <csem_free+0x162c>
    2c60:	00003097          	auipc	ra,0x3
    2c64:	21e080e7          	jalr	542(ra) # 5e7e <printf>
    exit(1);
    2c68:	4505                	li	a0,1
    2c6a:	00003097          	auipc	ra,0x3
    2c6e:	e42080e7          	jalr	-446(ra) # 5aac <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    2c72:	85ca                	mv	a1,s2
    2c74:	00005517          	auipc	a0,0x5
    2c78:	af450513          	addi	a0,a0,-1292 # 7768 <csem_free+0x1654>
    2c7c:	00003097          	auipc	ra,0x3
    2c80:	202080e7          	jalr	514(ra) # 5e7e <printf>
    exit(1);
    2c84:	4505                	li	a0,1
    2c86:	00003097          	auipc	ra,0x3
    2c8a:	e26080e7          	jalr	-474(ra) # 5aac <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    2c8e:	85ca                	mv	a1,s2
    2c90:	00005517          	auipc	a0,0x5
    2c94:	af850513          	addi	a0,a0,-1288 # 7788 <csem_free+0x1674>
    2c98:	00003097          	auipc	ra,0x3
    2c9c:	1e6080e7          	jalr	486(ra) # 5e7e <printf>
    exit(1);
    2ca0:	4505                	li	a0,1
    2ca2:	00003097          	auipc	ra,0x3
    2ca6:	e0a080e7          	jalr	-502(ra) # 5aac <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    2caa:	85ca                	mv	a1,s2
    2cac:	00005517          	auipc	a0,0x5
    2cb0:	afc50513          	addi	a0,a0,-1284 # 77a8 <csem_free+0x1694>
    2cb4:	00003097          	auipc	ra,0x3
    2cb8:	1ca080e7          	jalr	458(ra) # 5e7e <printf>
    exit(1);
    2cbc:	4505                	li	a0,1
    2cbe:	00003097          	auipc	ra,0x3
    2cc2:	dee080e7          	jalr	-530(ra) # 5aac <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    2cc6:	85ca                	mv	a1,s2
    2cc8:	00005517          	auipc	a0,0x5
    2ccc:	b0850513          	addi	a0,a0,-1272 # 77d0 <csem_free+0x16bc>
    2cd0:	00003097          	auipc	ra,0x3
    2cd4:	1ae080e7          	jalr	430(ra) # 5e7e <printf>
    exit(1);
    2cd8:	4505                	li	a0,1
    2cda:	00003097          	auipc	ra,0x3
    2cde:	dd2080e7          	jalr	-558(ra) # 5aac <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    2ce2:	85ca                	mv	a1,s2
    2ce4:	00005517          	auipc	a0,0x5
    2ce8:	b0c50513          	addi	a0,a0,-1268 # 77f0 <csem_free+0x16dc>
    2cec:	00003097          	auipc	ra,0x3
    2cf0:	192080e7          	jalr	402(ra) # 5e7e <printf>
    exit(1);
    2cf4:	4505                	li	a0,1
    2cf6:	00003097          	auipc	ra,0x3
    2cfa:	db6080e7          	jalr	-586(ra) # 5aac <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    2cfe:	85ca                	mv	a1,s2
    2d00:	00005517          	auipc	a0,0x5
    2d04:	b1050513          	addi	a0,a0,-1264 # 7810 <csem_free+0x16fc>
    2d08:	00003097          	auipc	ra,0x3
    2d0c:	176080e7          	jalr	374(ra) # 5e7e <printf>
    exit(1);
    2d10:	4505                	li	a0,1
    2d12:	00003097          	auipc	ra,0x3
    2d16:	d9a080e7          	jalr	-614(ra) # 5aac <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    2d1a:	85ca                	mv	a1,s2
    2d1c:	00005517          	auipc	a0,0x5
    2d20:	b1c50513          	addi	a0,a0,-1252 # 7838 <csem_free+0x1724>
    2d24:	00003097          	auipc	ra,0x3
    2d28:	15a080e7          	jalr	346(ra) # 5e7e <printf>
    exit(1);
    2d2c:	4505                	li	a0,1
    2d2e:	00003097          	auipc	ra,0x3
    2d32:	d7e080e7          	jalr	-642(ra) # 5aac <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2d36:	85ca                	mv	a1,s2
    2d38:	00004517          	auipc	a0,0x4
    2d3c:	79850513          	addi	a0,a0,1944 # 74d0 <csem_free+0x13bc>
    2d40:	00003097          	auipc	ra,0x3
    2d44:	13e080e7          	jalr	318(ra) # 5e7e <printf>
    exit(1);
    2d48:	4505                	li	a0,1
    2d4a:	00003097          	auipc	ra,0x3
    2d4e:	d62080e7          	jalr	-670(ra) # 5aac <exit>
    printf("%s: unlink dd/ff failed\n", s);
    2d52:	85ca                	mv	a1,s2
    2d54:	00005517          	auipc	a0,0x5
    2d58:	b0450513          	addi	a0,a0,-1276 # 7858 <csem_free+0x1744>
    2d5c:	00003097          	auipc	ra,0x3
    2d60:	122080e7          	jalr	290(ra) # 5e7e <printf>
    exit(1);
    2d64:	4505                	li	a0,1
    2d66:	00003097          	auipc	ra,0x3
    2d6a:	d46080e7          	jalr	-698(ra) # 5aac <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    2d6e:	85ca                	mv	a1,s2
    2d70:	00005517          	auipc	a0,0x5
    2d74:	b0850513          	addi	a0,a0,-1272 # 7878 <csem_free+0x1764>
    2d78:	00003097          	auipc	ra,0x3
    2d7c:	106080e7          	jalr	262(ra) # 5e7e <printf>
    exit(1);
    2d80:	4505                	li	a0,1
    2d82:	00003097          	auipc	ra,0x3
    2d86:	d2a080e7          	jalr	-726(ra) # 5aac <exit>
    printf("%s: unlink dd/dd failed\n", s);
    2d8a:	85ca                	mv	a1,s2
    2d8c:	00005517          	auipc	a0,0x5
    2d90:	b1c50513          	addi	a0,a0,-1252 # 78a8 <csem_free+0x1794>
    2d94:	00003097          	auipc	ra,0x3
    2d98:	0ea080e7          	jalr	234(ra) # 5e7e <printf>
    exit(1);
    2d9c:	4505                	li	a0,1
    2d9e:	00003097          	auipc	ra,0x3
    2da2:	d0e080e7          	jalr	-754(ra) # 5aac <exit>
    printf("%s: unlink dd failed\n", s);
    2da6:	85ca                	mv	a1,s2
    2da8:	00005517          	auipc	a0,0x5
    2dac:	b2050513          	addi	a0,a0,-1248 # 78c8 <csem_free+0x17b4>
    2db0:	00003097          	auipc	ra,0x3
    2db4:	0ce080e7          	jalr	206(ra) # 5e7e <printf>
    exit(1);
    2db8:	4505                	li	a0,1
    2dba:	00003097          	auipc	ra,0x3
    2dbe:	cf2080e7          	jalr	-782(ra) # 5aac <exit>

0000000000002dc2 <rmdot>:
{
    2dc2:	1101                	addi	sp,sp,-32
    2dc4:	ec06                	sd	ra,24(sp)
    2dc6:	e822                	sd	s0,16(sp)
    2dc8:	e426                	sd	s1,8(sp)
    2dca:	1000                	addi	s0,sp,32
    2dcc:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    2dce:	00005517          	auipc	a0,0x5
    2dd2:	b1250513          	addi	a0,a0,-1262 # 78e0 <csem_free+0x17cc>
    2dd6:	00003097          	auipc	ra,0x3
    2dda:	d3e080e7          	jalr	-706(ra) # 5b14 <mkdir>
    2dde:	e549                	bnez	a0,2e68 <rmdot+0xa6>
  if(chdir("dots") != 0){
    2de0:	00005517          	auipc	a0,0x5
    2de4:	b0050513          	addi	a0,a0,-1280 # 78e0 <csem_free+0x17cc>
    2de8:	00003097          	auipc	ra,0x3
    2dec:	d34080e7          	jalr	-716(ra) # 5b1c <chdir>
    2df0:	e951                	bnez	a0,2e84 <rmdot+0xc2>
  if(unlink(".") == 0){
    2df2:	00004517          	auipc	a0,0x4
    2df6:	dfe50513          	addi	a0,a0,-514 # 6bf0 <csem_free+0xadc>
    2dfa:	00003097          	auipc	ra,0x3
    2dfe:	d02080e7          	jalr	-766(ra) # 5afc <unlink>
    2e02:	cd59                	beqz	a0,2ea0 <rmdot+0xde>
  if(unlink("..") == 0){
    2e04:	00004517          	auipc	a0,0x4
    2e08:	53450513          	addi	a0,a0,1332 # 7338 <csem_free+0x1224>
    2e0c:	00003097          	auipc	ra,0x3
    2e10:	cf0080e7          	jalr	-784(ra) # 5afc <unlink>
    2e14:	c545                	beqz	a0,2ebc <rmdot+0xfa>
  if(chdir("/") != 0){
    2e16:	00004517          	auipc	a0,0x4
    2e1a:	4ca50513          	addi	a0,a0,1226 # 72e0 <csem_free+0x11cc>
    2e1e:	00003097          	auipc	ra,0x3
    2e22:	cfe080e7          	jalr	-770(ra) # 5b1c <chdir>
    2e26:	e94d                	bnez	a0,2ed8 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    2e28:	00005517          	auipc	a0,0x5
    2e2c:	b2050513          	addi	a0,a0,-1248 # 7948 <csem_free+0x1834>
    2e30:	00003097          	auipc	ra,0x3
    2e34:	ccc080e7          	jalr	-820(ra) # 5afc <unlink>
    2e38:	cd55                	beqz	a0,2ef4 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    2e3a:	00005517          	auipc	a0,0x5
    2e3e:	b3650513          	addi	a0,a0,-1226 # 7970 <csem_free+0x185c>
    2e42:	00003097          	auipc	ra,0x3
    2e46:	cba080e7          	jalr	-838(ra) # 5afc <unlink>
    2e4a:	c179                	beqz	a0,2f10 <rmdot+0x14e>
  if(unlink("dots") != 0){
    2e4c:	00005517          	auipc	a0,0x5
    2e50:	a9450513          	addi	a0,a0,-1388 # 78e0 <csem_free+0x17cc>
    2e54:	00003097          	auipc	ra,0x3
    2e58:	ca8080e7          	jalr	-856(ra) # 5afc <unlink>
    2e5c:	e961                	bnez	a0,2f2c <rmdot+0x16a>
}
    2e5e:	60e2                	ld	ra,24(sp)
    2e60:	6442                	ld	s0,16(sp)
    2e62:	64a2                	ld	s1,8(sp)
    2e64:	6105                	addi	sp,sp,32
    2e66:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    2e68:	85a6                	mv	a1,s1
    2e6a:	00005517          	auipc	a0,0x5
    2e6e:	a7e50513          	addi	a0,a0,-1410 # 78e8 <csem_free+0x17d4>
    2e72:	00003097          	auipc	ra,0x3
    2e76:	00c080e7          	jalr	12(ra) # 5e7e <printf>
    exit(1);
    2e7a:	4505                	li	a0,1
    2e7c:	00003097          	auipc	ra,0x3
    2e80:	c30080e7          	jalr	-976(ra) # 5aac <exit>
    printf("%s: chdir dots failed\n", s);
    2e84:	85a6                	mv	a1,s1
    2e86:	00005517          	auipc	a0,0x5
    2e8a:	a7a50513          	addi	a0,a0,-1414 # 7900 <csem_free+0x17ec>
    2e8e:	00003097          	auipc	ra,0x3
    2e92:	ff0080e7          	jalr	-16(ra) # 5e7e <printf>
    exit(1);
    2e96:	4505                	li	a0,1
    2e98:	00003097          	auipc	ra,0x3
    2e9c:	c14080e7          	jalr	-1004(ra) # 5aac <exit>
    printf("%s: rm . worked!\n", s);
    2ea0:	85a6                	mv	a1,s1
    2ea2:	00005517          	auipc	a0,0x5
    2ea6:	a7650513          	addi	a0,a0,-1418 # 7918 <csem_free+0x1804>
    2eaa:	00003097          	auipc	ra,0x3
    2eae:	fd4080e7          	jalr	-44(ra) # 5e7e <printf>
    exit(1);
    2eb2:	4505                	li	a0,1
    2eb4:	00003097          	auipc	ra,0x3
    2eb8:	bf8080e7          	jalr	-1032(ra) # 5aac <exit>
    printf("%s: rm .. worked!\n", s);
    2ebc:	85a6                	mv	a1,s1
    2ebe:	00005517          	auipc	a0,0x5
    2ec2:	a7250513          	addi	a0,a0,-1422 # 7930 <csem_free+0x181c>
    2ec6:	00003097          	auipc	ra,0x3
    2eca:	fb8080e7          	jalr	-72(ra) # 5e7e <printf>
    exit(1);
    2ece:	4505                	li	a0,1
    2ed0:	00003097          	auipc	ra,0x3
    2ed4:	bdc080e7          	jalr	-1060(ra) # 5aac <exit>
    printf("%s: chdir / failed\n", s);
    2ed8:	85a6                	mv	a1,s1
    2eda:	00004517          	auipc	a0,0x4
    2ede:	40e50513          	addi	a0,a0,1038 # 72e8 <csem_free+0x11d4>
    2ee2:	00003097          	auipc	ra,0x3
    2ee6:	f9c080e7          	jalr	-100(ra) # 5e7e <printf>
    exit(1);
    2eea:	4505                	li	a0,1
    2eec:	00003097          	auipc	ra,0x3
    2ef0:	bc0080e7          	jalr	-1088(ra) # 5aac <exit>
    printf("%s: unlink dots/. worked!\n", s);
    2ef4:	85a6                	mv	a1,s1
    2ef6:	00005517          	auipc	a0,0x5
    2efa:	a5a50513          	addi	a0,a0,-1446 # 7950 <csem_free+0x183c>
    2efe:	00003097          	auipc	ra,0x3
    2f02:	f80080e7          	jalr	-128(ra) # 5e7e <printf>
    exit(1);
    2f06:	4505                	li	a0,1
    2f08:	00003097          	auipc	ra,0x3
    2f0c:	ba4080e7          	jalr	-1116(ra) # 5aac <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    2f10:	85a6                	mv	a1,s1
    2f12:	00005517          	auipc	a0,0x5
    2f16:	a6650513          	addi	a0,a0,-1434 # 7978 <csem_free+0x1864>
    2f1a:	00003097          	auipc	ra,0x3
    2f1e:	f64080e7          	jalr	-156(ra) # 5e7e <printf>
    exit(1);
    2f22:	4505                	li	a0,1
    2f24:	00003097          	auipc	ra,0x3
    2f28:	b88080e7          	jalr	-1144(ra) # 5aac <exit>
    printf("%s: unlink dots failed!\n", s);
    2f2c:	85a6                	mv	a1,s1
    2f2e:	00005517          	auipc	a0,0x5
    2f32:	a6a50513          	addi	a0,a0,-1430 # 7998 <csem_free+0x1884>
    2f36:	00003097          	auipc	ra,0x3
    2f3a:	f48080e7          	jalr	-184(ra) # 5e7e <printf>
    exit(1);
    2f3e:	4505                	li	a0,1
    2f40:	00003097          	auipc	ra,0x3
    2f44:	b6c080e7          	jalr	-1172(ra) # 5aac <exit>

0000000000002f48 <dirfile>:
{
    2f48:	1101                	addi	sp,sp,-32
    2f4a:	ec06                	sd	ra,24(sp)
    2f4c:	e822                	sd	s0,16(sp)
    2f4e:	e426                	sd	s1,8(sp)
    2f50:	e04a                	sd	s2,0(sp)
    2f52:	1000                	addi	s0,sp,32
    2f54:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    2f56:	20000593          	li	a1,512
    2f5a:	00003517          	auipc	a0,0x3
    2f5e:	40e50513          	addi	a0,a0,1038 # 6368 <csem_free+0x254>
    2f62:	00003097          	auipc	ra,0x3
    2f66:	b8a080e7          	jalr	-1142(ra) # 5aec <open>
  if(fd < 0){
    2f6a:	0e054d63          	bltz	a0,3064 <dirfile+0x11c>
  close(fd);
    2f6e:	00003097          	auipc	ra,0x3
    2f72:	b66080e7          	jalr	-1178(ra) # 5ad4 <close>
  if(chdir("dirfile") == 0){
    2f76:	00003517          	auipc	a0,0x3
    2f7a:	3f250513          	addi	a0,a0,1010 # 6368 <csem_free+0x254>
    2f7e:	00003097          	auipc	ra,0x3
    2f82:	b9e080e7          	jalr	-1122(ra) # 5b1c <chdir>
    2f86:	cd6d                	beqz	a0,3080 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    2f88:	4581                	li	a1,0
    2f8a:	00005517          	auipc	a0,0x5
    2f8e:	a6e50513          	addi	a0,a0,-1426 # 79f8 <csem_free+0x18e4>
    2f92:	00003097          	auipc	ra,0x3
    2f96:	b5a080e7          	jalr	-1190(ra) # 5aec <open>
  if(fd >= 0){
    2f9a:	10055163          	bgez	a0,309c <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    2f9e:	20000593          	li	a1,512
    2fa2:	00005517          	auipc	a0,0x5
    2fa6:	a5650513          	addi	a0,a0,-1450 # 79f8 <csem_free+0x18e4>
    2faa:	00003097          	auipc	ra,0x3
    2fae:	b42080e7          	jalr	-1214(ra) # 5aec <open>
  if(fd >= 0){
    2fb2:	10055363          	bgez	a0,30b8 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    2fb6:	00005517          	auipc	a0,0x5
    2fba:	a4250513          	addi	a0,a0,-1470 # 79f8 <csem_free+0x18e4>
    2fbe:	00003097          	auipc	ra,0x3
    2fc2:	b56080e7          	jalr	-1194(ra) # 5b14 <mkdir>
    2fc6:	10050763          	beqz	a0,30d4 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    2fca:	00005517          	auipc	a0,0x5
    2fce:	a2e50513          	addi	a0,a0,-1490 # 79f8 <csem_free+0x18e4>
    2fd2:	00003097          	auipc	ra,0x3
    2fd6:	b2a080e7          	jalr	-1238(ra) # 5afc <unlink>
    2fda:	10050b63          	beqz	a0,30f0 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    2fde:	00005597          	auipc	a1,0x5
    2fe2:	a1a58593          	addi	a1,a1,-1510 # 79f8 <csem_free+0x18e4>
    2fe6:	00004517          	auipc	a0,0x4
    2fea:	81a50513          	addi	a0,a0,-2022 # 6800 <csem_free+0x6ec>
    2fee:	00003097          	auipc	ra,0x3
    2ff2:	b1e080e7          	jalr	-1250(ra) # 5b0c <link>
    2ff6:	10050b63          	beqz	a0,310c <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    2ffa:	00003517          	auipc	a0,0x3
    2ffe:	36e50513          	addi	a0,a0,878 # 6368 <csem_free+0x254>
    3002:	00003097          	auipc	ra,0x3
    3006:	afa080e7          	jalr	-1286(ra) # 5afc <unlink>
    300a:	10051f63          	bnez	a0,3128 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    300e:	4589                	li	a1,2
    3010:	00004517          	auipc	a0,0x4
    3014:	be050513          	addi	a0,a0,-1056 # 6bf0 <csem_free+0xadc>
    3018:	00003097          	auipc	ra,0x3
    301c:	ad4080e7          	jalr	-1324(ra) # 5aec <open>
  if(fd >= 0){
    3020:	12055263          	bgez	a0,3144 <dirfile+0x1fc>
  fd = open(".", 0);
    3024:	4581                	li	a1,0
    3026:	00004517          	auipc	a0,0x4
    302a:	bca50513          	addi	a0,a0,-1078 # 6bf0 <csem_free+0xadc>
    302e:	00003097          	auipc	ra,0x3
    3032:	abe080e7          	jalr	-1346(ra) # 5aec <open>
    3036:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3038:	4605                	li	a2,1
    303a:	00003597          	auipc	a1,0x3
    303e:	68e58593          	addi	a1,a1,1678 # 66c8 <csem_free+0x5b4>
    3042:	00003097          	auipc	ra,0x3
    3046:	a8a080e7          	jalr	-1398(ra) # 5acc <write>
    304a:	10a04b63          	bgtz	a0,3160 <dirfile+0x218>
  close(fd);
    304e:	8526                	mv	a0,s1
    3050:	00003097          	auipc	ra,0x3
    3054:	a84080e7          	jalr	-1404(ra) # 5ad4 <close>
}
    3058:	60e2                	ld	ra,24(sp)
    305a:	6442                	ld	s0,16(sp)
    305c:	64a2                	ld	s1,8(sp)
    305e:	6902                	ld	s2,0(sp)
    3060:	6105                	addi	sp,sp,32
    3062:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3064:	85ca                	mv	a1,s2
    3066:	00005517          	auipc	a0,0x5
    306a:	95250513          	addi	a0,a0,-1710 # 79b8 <csem_free+0x18a4>
    306e:	00003097          	auipc	ra,0x3
    3072:	e10080e7          	jalr	-496(ra) # 5e7e <printf>
    exit(1);
    3076:	4505                	li	a0,1
    3078:	00003097          	auipc	ra,0x3
    307c:	a34080e7          	jalr	-1484(ra) # 5aac <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3080:	85ca                	mv	a1,s2
    3082:	00005517          	auipc	a0,0x5
    3086:	95650513          	addi	a0,a0,-1706 # 79d8 <csem_free+0x18c4>
    308a:	00003097          	auipc	ra,0x3
    308e:	df4080e7          	jalr	-524(ra) # 5e7e <printf>
    exit(1);
    3092:	4505                	li	a0,1
    3094:	00003097          	auipc	ra,0x3
    3098:	a18080e7          	jalr	-1512(ra) # 5aac <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    309c:	85ca                	mv	a1,s2
    309e:	00005517          	auipc	a0,0x5
    30a2:	96a50513          	addi	a0,a0,-1686 # 7a08 <csem_free+0x18f4>
    30a6:	00003097          	auipc	ra,0x3
    30aa:	dd8080e7          	jalr	-552(ra) # 5e7e <printf>
    exit(1);
    30ae:	4505                	li	a0,1
    30b0:	00003097          	auipc	ra,0x3
    30b4:	9fc080e7          	jalr	-1540(ra) # 5aac <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    30b8:	85ca                	mv	a1,s2
    30ba:	00005517          	auipc	a0,0x5
    30be:	94e50513          	addi	a0,a0,-1714 # 7a08 <csem_free+0x18f4>
    30c2:	00003097          	auipc	ra,0x3
    30c6:	dbc080e7          	jalr	-580(ra) # 5e7e <printf>
    exit(1);
    30ca:	4505                	li	a0,1
    30cc:	00003097          	auipc	ra,0x3
    30d0:	9e0080e7          	jalr	-1568(ra) # 5aac <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    30d4:	85ca                	mv	a1,s2
    30d6:	00005517          	auipc	a0,0x5
    30da:	95a50513          	addi	a0,a0,-1702 # 7a30 <csem_free+0x191c>
    30de:	00003097          	auipc	ra,0x3
    30e2:	da0080e7          	jalr	-608(ra) # 5e7e <printf>
    exit(1);
    30e6:	4505                	li	a0,1
    30e8:	00003097          	auipc	ra,0x3
    30ec:	9c4080e7          	jalr	-1596(ra) # 5aac <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    30f0:	85ca                	mv	a1,s2
    30f2:	00005517          	auipc	a0,0x5
    30f6:	96650513          	addi	a0,a0,-1690 # 7a58 <csem_free+0x1944>
    30fa:	00003097          	auipc	ra,0x3
    30fe:	d84080e7          	jalr	-636(ra) # 5e7e <printf>
    exit(1);
    3102:	4505                	li	a0,1
    3104:	00003097          	auipc	ra,0x3
    3108:	9a8080e7          	jalr	-1624(ra) # 5aac <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    310c:	85ca                	mv	a1,s2
    310e:	00005517          	auipc	a0,0x5
    3112:	97250513          	addi	a0,a0,-1678 # 7a80 <csem_free+0x196c>
    3116:	00003097          	auipc	ra,0x3
    311a:	d68080e7          	jalr	-664(ra) # 5e7e <printf>
    exit(1);
    311e:	4505                	li	a0,1
    3120:	00003097          	auipc	ra,0x3
    3124:	98c080e7          	jalr	-1652(ra) # 5aac <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3128:	85ca                	mv	a1,s2
    312a:	00005517          	auipc	a0,0x5
    312e:	97e50513          	addi	a0,a0,-1666 # 7aa8 <csem_free+0x1994>
    3132:	00003097          	auipc	ra,0x3
    3136:	d4c080e7          	jalr	-692(ra) # 5e7e <printf>
    exit(1);
    313a:	4505                	li	a0,1
    313c:	00003097          	auipc	ra,0x3
    3140:	970080e7          	jalr	-1680(ra) # 5aac <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3144:	85ca                	mv	a1,s2
    3146:	00005517          	auipc	a0,0x5
    314a:	98250513          	addi	a0,a0,-1662 # 7ac8 <csem_free+0x19b4>
    314e:	00003097          	auipc	ra,0x3
    3152:	d30080e7          	jalr	-720(ra) # 5e7e <printf>
    exit(1);
    3156:	4505                	li	a0,1
    3158:	00003097          	auipc	ra,0x3
    315c:	954080e7          	jalr	-1708(ra) # 5aac <exit>
    printf("%s: write . succeeded!\n", s);
    3160:	85ca                	mv	a1,s2
    3162:	00005517          	auipc	a0,0x5
    3166:	98e50513          	addi	a0,a0,-1650 # 7af0 <csem_free+0x19dc>
    316a:	00003097          	auipc	ra,0x3
    316e:	d14080e7          	jalr	-748(ra) # 5e7e <printf>
    exit(1);
    3172:	4505                	li	a0,1
    3174:	00003097          	auipc	ra,0x3
    3178:	938080e7          	jalr	-1736(ra) # 5aac <exit>

000000000000317c <fourfiles>:
{
    317c:	7171                	addi	sp,sp,-176
    317e:	f506                	sd	ra,168(sp)
    3180:	f122                	sd	s0,160(sp)
    3182:	ed26                	sd	s1,152(sp)
    3184:	e94a                	sd	s2,144(sp)
    3186:	e54e                	sd	s3,136(sp)
    3188:	e152                	sd	s4,128(sp)
    318a:	fcd6                	sd	s5,120(sp)
    318c:	f8da                	sd	s6,112(sp)
    318e:	f4de                	sd	s7,104(sp)
    3190:	f0e2                	sd	s8,96(sp)
    3192:	ece6                	sd	s9,88(sp)
    3194:	e8ea                	sd	s10,80(sp)
    3196:	e4ee                	sd	s11,72(sp)
    3198:	1900                	addi	s0,sp,176
    319a:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    319e:	00003797          	auipc	a5,0x3
    31a2:	faa78793          	addi	a5,a5,-86 # 6148 <csem_free+0x34>
    31a6:	f6f43823          	sd	a5,-144(s0)
    31aa:	00003797          	auipc	a5,0x3
    31ae:	fa678793          	addi	a5,a5,-90 # 6150 <csem_free+0x3c>
    31b2:	f6f43c23          	sd	a5,-136(s0)
    31b6:	00003797          	auipc	a5,0x3
    31ba:	fa278793          	addi	a5,a5,-94 # 6158 <csem_free+0x44>
    31be:	f8f43023          	sd	a5,-128(s0)
    31c2:	00003797          	auipc	a5,0x3
    31c6:	f9e78793          	addi	a5,a5,-98 # 6160 <csem_free+0x4c>
    31ca:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    31ce:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    31d2:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    31d4:	4481                	li	s1,0
    31d6:	4a11                	li	s4,4
    fname = names[pi];
    31d8:	00093983          	ld	s3,0(s2)
    unlink(fname);
    31dc:	854e                	mv	a0,s3
    31de:	00003097          	auipc	ra,0x3
    31e2:	91e080e7          	jalr	-1762(ra) # 5afc <unlink>
    pid = fork();
    31e6:	00003097          	auipc	ra,0x3
    31ea:	8be080e7          	jalr	-1858(ra) # 5aa4 <fork>
    if(pid < 0){
    31ee:	04054463          	bltz	a0,3236 <fourfiles+0xba>
    if(pid == 0){
    31f2:	c12d                	beqz	a0,3254 <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    31f4:	2485                	addiw	s1,s1,1
    31f6:	0921                	addi	s2,s2,8
    31f8:	ff4490e3          	bne	s1,s4,31d8 <fourfiles+0x5c>
    31fc:	4491                	li	s1,4
    wait(&xstatus);
    31fe:	f6c40513          	addi	a0,s0,-148
    3202:	00003097          	auipc	ra,0x3
    3206:	8b2080e7          	jalr	-1870(ra) # 5ab4 <wait>
    if(xstatus != 0)
    320a:	f6c42b03          	lw	s6,-148(s0)
    320e:	0c0b1e63          	bnez	s6,32ea <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    3212:	34fd                	addiw	s1,s1,-1
    3214:	f4ed                	bnez	s1,31fe <fourfiles+0x82>
    3216:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    321a:	00009a17          	auipc	s4,0x9
    321e:	ec6a0a13          	addi	s4,s4,-314 # c0e0 <buf>
    3222:	00009a97          	auipc	s5,0x9
    3226:	ebfa8a93          	addi	s5,s5,-321 # c0e1 <buf+0x1>
    if(total != N*SZ){
    322a:	6d85                	lui	s11,0x1
    322c:	770d8d93          	addi	s11,s11,1904 # 1770 <validatetest+0x52>
  for(i = 0; i < NCHILD; i++){
    3230:	03400d13          	li	s10,52
    3234:	aa1d                	j	336a <fourfiles+0x1ee>
      printf("fork failed\n", s);
    3236:	f5843583          	ld	a1,-168(s0)
    323a:	00004517          	auipc	a0,0x4
    323e:	c9e50513          	addi	a0,a0,-866 # 6ed8 <csem_free+0xdc4>
    3242:	00003097          	auipc	ra,0x3
    3246:	c3c080e7          	jalr	-964(ra) # 5e7e <printf>
      exit(1);
    324a:	4505                	li	a0,1
    324c:	00003097          	auipc	ra,0x3
    3250:	860080e7          	jalr	-1952(ra) # 5aac <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3254:	20200593          	li	a1,514
    3258:	854e                	mv	a0,s3
    325a:	00003097          	auipc	ra,0x3
    325e:	892080e7          	jalr	-1902(ra) # 5aec <open>
    3262:	892a                	mv	s2,a0
      if(fd < 0){
    3264:	04054763          	bltz	a0,32b2 <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    3268:	1f400613          	li	a2,500
    326c:	0304859b          	addiw	a1,s1,48
    3270:	00009517          	auipc	a0,0x9
    3274:	e7050513          	addi	a0,a0,-400 # c0e0 <buf>
    3278:	00002097          	auipc	ra,0x2
    327c:	638080e7          	jalr	1592(ra) # 58b0 <memset>
    3280:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3282:	00009997          	auipc	s3,0x9
    3286:	e5e98993          	addi	s3,s3,-418 # c0e0 <buf>
    328a:	1f400613          	li	a2,500
    328e:	85ce                	mv	a1,s3
    3290:	854a                	mv	a0,s2
    3292:	00003097          	auipc	ra,0x3
    3296:	83a080e7          	jalr	-1990(ra) # 5acc <write>
    329a:	85aa                	mv	a1,a0
    329c:	1f400793          	li	a5,500
    32a0:	02f51863          	bne	a0,a5,32d0 <fourfiles+0x154>
      for(i = 0; i < N; i++){
    32a4:	34fd                	addiw	s1,s1,-1
    32a6:	f0f5                	bnez	s1,328a <fourfiles+0x10e>
      exit(0);
    32a8:	4501                	li	a0,0
    32aa:	00003097          	auipc	ra,0x3
    32ae:	802080e7          	jalr	-2046(ra) # 5aac <exit>
        printf("create failed\n", s);
    32b2:	f5843583          	ld	a1,-168(s0)
    32b6:	00005517          	auipc	a0,0x5
    32ba:	85250513          	addi	a0,a0,-1966 # 7b08 <csem_free+0x19f4>
    32be:	00003097          	auipc	ra,0x3
    32c2:	bc0080e7          	jalr	-1088(ra) # 5e7e <printf>
        exit(1);
    32c6:	4505                	li	a0,1
    32c8:	00002097          	auipc	ra,0x2
    32cc:	7e4080e7          	jalr	2020(ra) # 5aac <exit>
          printf("write failed %d\n", n);
    32d0:	00005517          	auipc	a0,0x5
    32d4:	84850513          	addi	a0,a0,-1976 # 7b18 <csem_free+0x1a04>
    32d8:	00003097          	auipc	ra,0x3
    32dc:	ba6080e7          	jalr	-1114(ra) # 5e7e <printf>
          exit(1);
    32e0:	4505                	li	a0,1
    32e2:	00002097          	auipc	ra,0x2
    32e6:	7ca080e7          	jalr	1994(ra) # 5aac <exit>
      exit(xstatus);
    32ea:	855a                	mv	a0,s6
    32ec:	00002097          	auipc	ra,0x2
    32f0:	7c0080e7          	jalr	1984(ra) # 5aac <exit>
          printf("wrong char\n", s);
    32f4:	f5843583          	ld	a1,-168(s0)
    32f8:	00005517          	auipc	a0,0x5
    32fc:	83850513          	addi	a0,a0,-1992 # 7b30 <csem_free+0x1a1c>
    3300:	00003097          	auipc	ra,0x3
    3304:	b7e080e7          	jalr	-1154(ra) # 5e7e <printf>
          exit(1);
    3308:	4505                	li	a0,1
    330a:	00002097          	auipc	ra,0x2
    330e:	7a2080e7          	jalr	1954(ra) # 5aac <exit>
      total += n;
    3312:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3316:	660d                	lui	a2,0x3
    3318:	85d2                	mv	a1,s4
    331a:	854e                	mv	a0,s3
    331c:	00002097          	auipc	ra,0x2
    3320:	7a8080e7          	jalr	1960(ra) # 5ac4 <read>
    3324:	02a05363          	blez	a0,334a <fourfiles+0x1ce>
    3328:	00009797          	auipc	a5,0x9
    332c:	db878793          	addi	a5,a5,-584 # c0e0 <buf>
    3330:	fff5069b          	addiw	a3,a0,-1
    3334:	1682                	slli	a3,a3,0x20
    3336:	9281                	srli	a3,a3,0x20
    3338:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    333a:	0007c703          	lbu	a4,0(a5)
    333e:	fa971be3          	bne	a4,s1,32f4 <fourfiles+0x178>
      for(j = 0; j < n; j++){
    3342:	0785                	addi	a5,a5,1
    3344:	fed79be3          	bne	a5,a3,333a <fourfiles+0x1be>
    3348:	b7e9                	j	3312 <fourfiles+0x196>
    close(fd);
    334a:	854e                	mv	a0,s3
    334c:	00002097          	auipc	ra,0x2
    3350:	788080e7          	jalr	1928(ra) # 5ad4 <close>
    if(total != N*SZ){
    3354:	03b91863          	bne	s2,s11,3384 <fourfiles+0x208>
    unlink(fname);
    3358:	8566                	mv	a0,s9
    335a:	00002097          	auipc	ra,0x2
    335e:	7a2080e7          	jalr	1954(ra) # 5afc <unlink>
  for(i = 0; i < NCHILD; i++){
    3362:	0c21                	addi	s8,s8,8
    3364:	2b85                	addiw	s7,s7,1
    3366:	03ab8d63          	beq	s7,s10,33a0 <fourfiles+0x224>
    fname = names[i];
    336a:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    336e:	4581                	li	a1,0
    3370:	8566                	mv	a0,s9
    3372:	00002097          	auipc	ra,0x2
    3376:	77a080e7          	jalr	1914(ra) # 5aec <open>
    337a:	89aa                	mv	s3,a0
    total = 0;
    337c:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    337e:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3382:	bf51                	j	3316 <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    3384:	85ca                	mv	a1,s2
    3386:	00004517          	auipc	a0,0x4
    338a:	7ba50513          	addi	a0,a0,1978 # 7b40 <csem_free+0x1a2c>
    338e:	00003097          	auipc	ra,0x3
    3392:	af0080e7          	jalr	-1296(ra) # 5e7e <printf>
      exit(1);
    3396:	4505                	li	a0,1
    3398:	00002097          	auipc	ra,0x2
    339c:	714080e7          	jalr	1812(ra) # 5aac <exit>
}
    33a0:	70aa                	ld	ra,168(sp)
    33a2:	740a                	ld	s0,160(sp)
    33a4:	64ea                	ld	s1,152(sp)
    33a6:	694a                	ld	s2,144(sp)
    33a8:	69aa                	ld	s3,136(sp)
    33aa:	6a0a                	ld	s4,128(sp)
    33ac:	7ae6                	ld	s5,120(sp)
    33ae:	7b46                	ld	s6,112(sp)
    33b0:	7ba6                	ld	s7,104(sp)
    33b2:	7c06                	ld	s8,96(sp)
    33b4:	6ce6                	ld	s9,88(sp)
    33b6:	6d46                	ld	s10,80(sp)
    33b8:	6da6                	ld	s11,72(sp)
    33ba:	614d                	addi	sp,sp,176
    33bc:	8082                	ret

00000000000033be <bigfile>:
{
    33be:	7139                	addi	sp,sp,-64
    33c0:	fc06                	sd	ra,56(sp)
    33c2:	f822                	sd	s0,48(sp)
    33c4:	f426                	sd	s1,40(sp)
    33c6:	f04a                	sd	s2,32(sp)
    33c8:	ec4e                	sd	s3,24(sp)
    33ca:	e852                	sd	s4,16(sp)
    33cc:	e456                	sd	s5,8(sp)
    33ce:	0080                	addi	s0,sp,64
    33d0:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    33d2:	00004517          	auipc	a0,0x4
    33d6:	78650513          	addi	a0,a0,1926 # 7b58 <csem_free+0x1a44>
    33da:	00002097          	auipc	ra,0x2
    33de:	722080e7          	jalr	1826(ra) # 5afc <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    33e2:	20200593          	li	a1,514
    33e6:	00004517          	auipc	a0,0x4
    33ea:	77250513          	addi	a0,a0,1906 # 7b58 <csem_free+0x1a44>
    33ee:	00002097          	auipc	ra,0x2
    33f2:	6fe080e7          	jalr	1790(ra) # 5aec <open>
    33f6:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    33f8:	4481                	li	s1,0
    memset(buf, i, SZ);
    33fa:	00009917          	auipc	s2,0x9
    33fe:	ce690913          	addi	s2,s2,-794 # c0e0 <buf>
  for(i = 0; i < N; i++){
    3402:	4a51                	li	s4,20
  if(fd < 0){
    3404:	0a054063          	bltz	a0,34a4 <bigfile+0xe6>
    memset(buf, i, SZ);
    3408:	25800613          	li	a2,600
    340c:	85a6                	mv	a1,s1
    340e:	854a                	mv	a0,s2
    3410:	00002097          	auipc	ra,0x2
    3414:	4a0080e7          	jalr	1184(ra) # 58b0 <memset>
    if(write(fd, buf, SZ) != SZ){
    3418:	25800613          	li	a2,600
    341c:	85ca                	mv	a1,s2
    341e:	854e                	mv	a0,s3
    3420:	00002097          	auipc	ra,0x2
    3424:	6ac080e7          	jalr	1708(ra) # 5acc <write>
    3428:	25800793          	li	a5,600
    342c:	08f51a63          	bne	a0,a5,34c0 <bigfile+0x102>
  for(i = 0; i < N; i++){
    3430:	2485                	addiw	s1,s1,1
    3432:	fd449be3          	bne	s1,s4,3408 <bigfile+0x4a>
  close(fd);
    3436:	854e                	mv	a0,s3
    3438:	00002097          	auipc	ra,0x2
    343c:	69c080e7          	jalr	1692(ra) # 5ad4 <close>
  fd = open("bigfile.dat", 0);
    3440:	4581                	li	a1,0
    3442:	00004517          	auipc	a0,0x4
    3446:	71650513          	addi	a0,a0,1814 # 7b58 <csem_free+0x1a44>
    344a:	00002097          	auipc	ra,0x2
    344e:	6a2080e7          	jalr	1698(ra) # 5aec <open>
    3452:	8a2a                	mv	s4,a0
  total = 0;
    3454:	4981                	li	s3,0
  for(i = 0; ; i++){
    3456:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    3458:	00009917          	auipc	s2,0x9
    345c:	c8890913          	addi	s2,s2,-888 # c0e0 <buf>
  if(fd < 0){
    3460:	06054e63          	bltz	a0,34dc <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    3464:	12c00613          	li	a2,300
    3468:	85ca                	mv	a1,s2
    346a:	8552                	mv	a0,s4
    346c:	00002097          	auipc	ra,0x2
    3470:	658080e7          	jalr	1624(ra) # 5ac4 <read>
    if(cc < 0){
    3474:	08054263          	bltz	a0,34f8 <bigfile+0x13a>
    if(cc == 0)
    3478:	c971                	beqz	a0,354c <bigfile+0x18e>
    if(cc != SZ/2){
    347a:	12c00793          	li	a5,300
    347e:	08f51b63          	bne	a0,a5,3514 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    3482:	01f4d79b          	srliw	a5,s1,0x1f
    3486:	9fa5                	addw	a5,a5,s1
    3488:	4017d79b          	sraiw	a5,a5,0x1
    348c:	00094703          	lbu	a4,0(s2)
    3490:	0af71063          	bne	a4,a5,3530 <bigfile+0x172>
    3494:	12b94703          	lbu	a4,299(s2)
    3498:	08f71c63          	bne	a4,a5,3530 <bigfile+0x172>
    total += cc;
    349c:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    34a0:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    34a2:	b7c9                	j	3464 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    34a4:	85d6                	mv	a1,s5
    34a6:	00004517          	auipc	a0,0x4
    34aa:	6c250513          	addi	a0,a0,1730 # 7b68 <csem_free+0x1a54>
    34ae:	00003097          	auipc	ra,0x3
    34b2:	9d0080e7          	jalr	-1584(ra) # 5e7e <printf>
    exit(1);
    34b6:	4505                	li	a0,1
    34b8:	00002097          	auipc	ra,0x2
    34bc:	5f4080e7          	jalr	1524(ra) # 5aac <exit>
      printf("%s: write bigfile failed\n", s);
    34c0:	85d6                	mv	a1,s5
    34c2:	00004517          	auipc	a0,0x4
    34c6:	6c650513          	addi	a0,a0,1734 # 7b88 <csem_free+0x1a74>
    34ca:	00003097          	auipc	ra,0x3
    34ce:	9b4080e7          	jalr	-1612(ra) # 5e7e <printf>
      exit(1);
    34d2:	4505                	li	a0,1
    34d4:	00002097          	auipc	ra,0x2
    34d8:	5d8080e7          	jalr	1496(ra) # 5aac <exit>
    printf("%s: cannot open bigfile\n", s);
    34dc:	85d6                	mv	a1,s5
    34de:	00004517          	auipc	a0,0x4
    34e2:	6ca50513          	addi	a0,a0,1738 # 7ba8 <csem_free+0x1a94>
    34e6:	00003097          	auipc	ra,0x3
    34ea:	998080e7          	jalr	-1640(ra) # 5e7e <printf>
    exit(1);
    34ee:	4505                	li	a0,1
    34f0:	00002097          	auipc	ra,0x2
    34f4:	5bc080e7          	jalr	1468(ra) # 5aac <exit>
      printf("%s: read bigfile failed\n", s);
    34f8:	85d6                	mv	a1,s5
    34fa:	00004517          	auipc	a0,0x4
    34fe:	6ce50513          	addi	a0,a0,1742 # 7bc8 <csem_free+0x1ab4>
    3502:	00003097          	auipc	ra,0x3
    3506:	97c080e7          	jalr	-1668(ra) # 5e7e <printf>
      exit(1);
    350a:	4505                	li	a0,1
    350c:	00002097          	auipc	ra,0x2
    3510:	5a0080e7          	jalr	1440(ra) # 5aac <exit>
      printf("%s: short read bigfile\n", s);
    3514:	85d6                	mv	a1,s5
    3516:	00004517          	auipc	a0,0x4
    351a:	6d250513          	addi	a0,a0,1746 # 7be8 <csem_free+0x1ad4>
    351e:	00003097          	auipc	ra,0x3
    3522:	960080e7          	jalr	-1696(ra) # 5e7e <printf>
      exit(1);
    3526:	4505                	li	a0,1
    3528:	00002097          	auipc	ra,0x2
    352c:	584080e7          	jalr	1412(ra) # 5aac <exit>
      printf("%s: read bigfile wrong data\n", s);
    3530:	85d6                	mv	a1,s5
    3532:	00004517          	auipc	a0,0x4
    3536:	6ce50513          	addi	a0,a0,1742 # 7c00 <csem_free+0x1aec>
    353a:	00003097          	auipc	ra,0x3
    353e:	944080e7          	jalr	-1724(ra) # 5e7e <printf>
      exit(1);
    3542:	4505                	li	a0,1
    3544:	00002097          	auipc	ra,0x2
    3548:	568080e7          	jalr	1384(ra) # 5aac <exit>
  close(fd);
    354c:	8552                	mv	a0,s4
    354e:	00002097          	auipc	ra,0x2
    3552:	586080e7          	jalr	1414(ra) # 5ad4 <close>
  if(total != N*SZ){
    3556:	678d                	lui	a5,0x3
    3558:	ee078793          	addi	a5,a5,-288 # 2ee0 <rmdot+0x11e>
    355c:	02f99363          	bne	s3,a5,3582 <bigfile+0x1c4>
  unlink("bigfile.dat");
    3560:	00004517          	auipc	a0,0x4
    3564:	5f850513          	addi	a0,a0,1528 # 7b58 <csem_free+0x1a44>
    3568:	00002097          	auipc	ra,0x2
    356c:	594080e7          	jalr	1428(ra) # 5afc <unlink>
}
    3570:	70e2                	ld	ra,56(sp)
    3572:	7442                	ld	s0,48(sp)
    3574:	74a2                	ld	s1,40(sp)
    3576:	7902                	ld	s2,32(sp)
    3578:	69e2                	ld	s3,24(sp)
    357a:	6a42                	ld	s4,16(sp)
    357c:	6aa2                	ld	s5,8(sp)
    357e:	6121                	addi	sp,sp,64
    3580:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    3582:	85d6                	mv	a1,s5
    3584:	00004517          	auipc	a0,0x4
    3588:	69c50513          	addi	a0,a0,1692 # 7c20 <csem_free+0x1b0c>
    358c:	00003097          	auipc	ra,0x3
    3590:	8f2080e7          	jalr	-1806(ra) # 5e7e <printf>
    exit(1);
    3594:	4505                	li	a0,1
    3596:	00002097          	auipc	ra,0x2
    359a:	516080e7          	jalr	1302(ra) # 5aac <exit>

000000000000359e <thread_test>:
void thread_test(char *s){
    359e:	7179                	addi	sp,sp,-48
    35a0:	f406                	sd	ra,40(sp)
    35a2:	f022                	sd	s0,32(sp)
    35a4:	ec26                	sd	s1,24(sp)
    35a6:	e84a                	sd	s2,16(sp)
    35a8:	1800                	addi	s0,sp,48
    void* stack = malloc(MAX_STACK_SIZE);
    35aa:	6505                	lui	a0,0x1
    35ac:	fa050513          	addi	a0,a0,-96 # fa0 <truncate1+0x20c>
    35b0:	00003097          	auipc	ra,0x3
    35b4:	98c080e7          	jalr	-1652(ra) # 5f3c <malloc>
    35b8:	84aa                	mv	s1,a0
    tid = kthread_create(test_thread, stack);
    35ba:	85aa                	mv	a1,a0
    35bc:	ffffd517          	auipc	a0,0xffffd
    35c0:	ac250513          	addi	a0,a0,-1342 # 7e <test_thread>
    35c4:	00002097          	auipc	ra,0x2
    35c8:	5c0080e7          	jalr	1472(ra) # 5b84 <kthread_create>
    kthread_join(tid,&status);
    35cc:	fdc40593          	addi	a1,s0,-36
    35d0:	00002097          	auipc	ra,0x2
    35d4:	5cc080e7          	jalr	1484(ra) # 5b9c <kthread_join>
    tid = kthread_id();
    35d8:	00002097          	auipc	ra,0x2
    35dc:	5b4080e7          	jalr	1460(ra) # 5b8c <kthread_id>
    35e0:	892a                	mv	s2,a0
    free(stack);
    35e2:	8526                	mv	a0,s1
    35e4:	00003097          	auipc	ra,0x3
    35e8:	8d0080e7          	jalr	-1840(ra) # 5eb4 <free>
    printf("Finished testing threads, main thread id: %d, %d\n", tid,status);
    35ec:	fdc42603          	lw	a2,-36(s0)
    35f0:	85ca                	mv	a1,s2
    35f2:	00004517          	auipc	a0,0x4
    35f6:	64e50513          	addi	a0,a0,1614 # 7c40 <csem_free+0x1b2c>
    35fa:	00003097          	auipc	ra,0x3
    35fe:	884080e7          	jalr	-1916(ra) # 5e7e <printf>
}
    3602:	70a2                	ld	ra,40(sp)
    3604:	7402                	ld	s0,32(sp)
    3606:	64e2                	ld	s1,24(sp)
    3608:	6942                	ld	s2,16(sp)
    360a:	6145                	addi	sp,sp,48
    360c:	8082                	ret

000000000000360e <truncate3>:
{
    360e:	7159                	addi	sp,sp,-112
    3610:	f486                	sd	ra,104(sp)
    3612:	f0a2                	sd	s0,96(sp)
    3614:	eca6                	sd	s1,88(sp)
    3616:	e8ca                	sd	s2,80(sp)
    3618:	e4ce                	sd	s3,72(sp)
    361a:	e0d2                	sd	s4,64(sp)
    361c:	fc56                	sd	s5,56(sp)
    361e:	1880                	addi	s0,sp,112
    3620:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    3622:	60100593          	li	a1,1537
    3626:	00003517          	auipc	a0,0x3
    362a:	08a50513          	addi	a0,a0,138 # 66b0 <csem_free+0x59c>
    362e:	00002097          	auipc	ra,0x2
    3632:	4be080e7          	jalr	1214(ra) # 5aec <open>
    3636:	00002097          	auipc	ra,0x2
    363a:	49e080e7          	jalr	1182(ra) # 5ad4 <close>
  pid = fork();
    363e:	00002097          	auipc	ra,0x2
    3642:	466080e7          	jalr	1126(ra) # 5aa4 <fork>
  if(pid < 0){
    3646:	08054063          	bltz	a0,36c6 <truncate3+0xb8>
  if(pid == 0){
    364a:	e969                	bnez	a0,371c <truncate3+0x10e>
    364c:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    3650:	00003a17          	auipc	s4,0x3
    3654:	060a0a13          	addi	s4,s4,96 # 66b0 <csem_free+0x59c>
      int n = write(fd, "1234567890", 10);
    3658:	00004a97          	auipc	s5,0x4
    365c:	620a8a93          	addi	s5,s5,1568 # 7c78 <csem_free+0x1b64>
      int fd = open("truncfile", O_WRONLY);
    3660:	4585                	li	a1,1
    3662:	8552                	mv	a0,s4
    3664:	00002097          	auipc	ra,0x2
    3668:	488080e7          	jalr	1160(ra) # 5aec <open>
    366c:	84aa                	mv	s1,a0
      if(fd < 0){
    366e:	06054a63          	bltz	a0,36e2 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    3672:	4629                	li	a2,10
    3674:	85d6                	mv	a1,s5
    3676:	00002097          	auipc	ra,0x2
    367a:	456080e7          	jalr	1110(ra) # 5acc <write>
      if(n != 10){
    367e:	47a9                	li	a5,10
    3680:	06f51f63          	bne	a0,a5,36fe <truncate3+0xf0>
      close(fd);
    3684:	8526                	mv	a0,s1
    3686:	00002097          	auipc	ra,0x2
    368a:	44e080e7          	jalr	1102(ra) # 5ad4 <close>
      fd = open("truncfile", O_RDONLY);
    368e:	4581                	li	a1,0
    3690:	8552                	mv	a0,s4
    3692:	00002097          	auipc	ra,0x2
    3696:	45a080e7          	jalr	1114(ra) # 5aec <open>
    369a:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    369c:	02000613          	li	a2,32
    36a0:	f9840593          	addi	a1,s0,-104
    36a4:	00002097          	auipc	ra,0x2
    36a8:	420080e7          	jalr	1056(ra) # 5ac4 <read>
      close(fd);
    36ac:	8526                	mv	a0,s1
    36ae:	00002097          	auipc	ra,0x2
    36b2:	426080e7          	jalr	1062(ra) # 5ad4 <close>
    for(int i = 0; i < 100; i++){
    36b6:	39fd                	addiw	s3,s3,-1
    36b8:	fa0994e3          	bnez	s3,3660 <truncate3+0x52>
    exit(0);
    36bc:	4501                	li	a0,0
    36be:	00002097          	auipc	ra,0x2
    36c2:	3ee080e7          	jalr	1006(ra) # 5aac <exit>
    printf("%s: fork failed\n", s);
    36c6:	85ca                	mv	a1,s2
    36c8:	00003517          	auipc	a0,0x3
    36cc:	d8050513          	addi	a0,a0,-640 # 6448 <csem_free+0x334>
    36d0:	00002097          	auipc	ra,0x2
    36d4:	7ae080e7          	jalr	1966(ra) # 5e7e <printf>
    exit(1);
    36d8:	4505                	li	a0,1
    36da:	00002097          	auipc	ra,0x2
    36de:	3d2080e7          	jalr	978(ra) # 5aac <exit>
        printf("%s: open failed\n", s);
    36e2:	85ca                	mv	a1,s2
    36e4:	00003517          	auipc	a0,0x3
    36e8:	6ac50513          	addi	a0,a0,1708 # 6d90 <csem_free+0xc7c>
    36ec:	00002097          	auipc	ra,0x2
    36f0:	792080e7          	jalr	1938(ra) # 5e7e <printf>
        exit(1);
    36f4:	4505                	li	a0,1
    36f6:	00002097          	auipc	ra,0x2
    36fa:	3b6080e7          	jalr	950(ra) # 5aac <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    36fe:	862a                	mv	a2,a0
    3700:	85ca                	mv	a1,s2
    3702:	00004517          	auipc	a0,0x4
    3706:	58650513          	addi	a0,a0,1414 # 7c88 <csem_free+0x1b74>
    370a:	00002097          	auipc	ra,0x2
    370e:	774080e7          	jalr	1908(ra) # 5e7e <printf>
        exit(1);
    3712:	4505                	li	a0,1
    3714:	00002097          	auipc	ra,0x2
    3718:	398080e7          	jalr	920(ra) # 5aac <exit>
    371c:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    3720:	00003a17          	auipc	s4,0x3
    3724:	f90a0a13          	addi	s4,s4,-112 # 66b0 <csem_free+0x59c>
    int n = write(fd, "xxx", 3);
    3728:	00004a97          	auipc	s5,0x4
    372c:	580a8a93          	addi	s5,s5,1408 # 7ca8 <csem_free+0x1b94>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    3730:	60100593          	li	a1,1537
    3734:	8552                	mv	a0,s4
    3736:	00002097          	auipc	ra,0x2
    373a:	3b6080e7          	jalr	950(ra) # 5aec <open>
    373e:	84aa                	mv	s1,a0
    if(fd < 0){
    3740:	04054763          	bltz	a0,378e <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    3744:	460d                	li	a2,3
    3746:	85d6                	mv	a1,s5
    3748:	00002097          	auipc	ra,0x2
    374c:	384080e7          	jalr	900(ra) # 5acc <write>
    if(n != 3){
    3750:	478d                	li	a5,3
    3752:	04f51c63          	bne	a0,a5,37aa <truncate3+0x19c>
    close(fd);
    3756:	8526                	mv	a0,s1
    3758:	00002097          	auipc	ra,0x2
    375c:	37c080e7          	jalr	892(ra) # 5ad4 <close>
  for(int i = 0; i < 150; i++){
    3760:	39fd                	addiw	s3,s3,-1
    3762:	fc0997e3          	bnez	s3,3730 <truncate3+0x122>
  wait(&xstatus);
    3766:	fbc40513          	addi	a0,s0,-68
    376a:	00002097          	auipc	ra,0x2
    376e:	34a080e7          	jalr	842(ra) # 5ab4 <wait>
  unlink("truncfile");
    3772:	00003517          	auipc	a0,0x3
    3776:	f3e50513          	addi	a0,a0,-194 # 66b0 <csem_free+0x59c>
    377a:	00002097          	auipc	ra,0x2
    377e:	382080e7          	jalr	898(ra) # 5afc <unlink>
  exit(xstatus);
    3782:	fbc42503          	lw	a0,-68(s0)
    3786:	00002097          	auipc	ra,0x2
    378a:	326080e7          	jalr	806(ra) # 5aac <exit>
      printf("%s: open failed\n", s);
    378e:	85ca                	mv	a1,s2
    3790:	00003517          	auipc	a0,0x3
    3794:	60050513          	addi	a0,a0,1536 # 6d90 <csem_free+0xc7c>
    3798:	00002097          	auipc	ra,0x2
    379c:	6e6080e7          	jalr	1766(ra) # 5e7e <printf>
      exit(1);
    37a0:	4505                	li	a0,1
    37a2:	00002097          	auipc	ra,0x2
    37a6:	30a080e7          	jalr	778(ra) # 5aac <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    37aa:	862a                	mv	a2,a0
    37ac:	85ca                	mv	a1,s2
    37ae:	00004517          	auipc	a0,0x4
    37b2:	50250513          	addi	a0,a0,1282 # 7cb0 <csem_free+0x1b9c>
    37b6:	00002097          	auipc	ra,0x2
    37ba:	6c8080e7          	jalr	1736(ra) # 5e7e <printf>
      exit(1);
    37be:	4505                	li	a0,1
    37c0:	00002097          	auipc	ra,0x2
    37c4:	2ec080e7          	jalr	748(ra) # 5aac <exit>

00000000000037c8 <writetest>:
{
    37c8:	7139                	addi	sp,sp,-64
    37ca:	fc06                	sd	ra,56(sp)
    37cc:	f822                	sd	s0,48(sp)
    37ce:	f426                	sd	s1,40(sp)
    37d0:	f04a                	sd	s2,32(sp)
    37d2:	ec4e                	sd	s3,24(sp)
    37d4:	e852                	sd	s4,16(sp)
    37d6:	e456                	sd	s5,8(sp)
    37d8:	e05a                	sd	s6,0(sp)
    37da:	0080                	addi	s0,sp,64
    37dc:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
    37de:	20200593          	li	a1,514
    37e2:	00004517          	auipc	a0,0x4
    37e6:	4ee50513          	addi	a0,a0,1262 # 7cd0 <csem_free+0x1bbc>
    37ea:	00002097          	auipc	ra,0x2
    37ee:	302080e7          	jalr	770(ra) # 5aec <open>
  if(fd < 0){
    37f2:	0a054d63          	bltz	a0,38ac <writetest+0xe4>
    37f6:	892a                	mv	s2,a0
    37f8:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
    37fa:	00004997          	auipc	s3,0x4
    37fe:	4fe98993          	addi	s3,s3,1278 # 7cf8 <csem_free+0x1be4>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
    3802:	00004a97          	auipc	s5,0x4
    3806:	52ea8a93          	addi	s5,s5,1326 # 7d30 <csem_free+0x1c1c>
  for(i = 0; i < N; i++){
    380a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
    380e:	4629                	li	a2,10
    3810:	85ce                	mv	a1,s3
    3812:	854a                	mv	a0,s2
    3814:	00002097          	auipc	ra,0x2
    3818:	2b8080e7          	jalr	696(ra) # 5acc <write>
    381c:	47a9                	li	a5,10
    381e:	0af51563          	bne	a0,a5,38c8 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
    3822:	4629                	li	a2,10
    3824:	85d6                	mv	a1,s5
    3826:	854a                	mv	a0,s2
    3828:	00002097          	auipc	ra,0x2
    382c:	2a4080e7          	jalr	676(ra) # 5acc <write>
    3830:	47a9                	li	a5,10
    3832:	0af51a63          	bne	a0,a5,38e6 <writetest+0x11e>
  for(i = 0; i < N; i++){
    3836:	2485                	addiw	s1,s1,1
    3838:	fd449be3          	bne	s1,s4,380e <writetest+0x46>
  close(fd);
    383c:	854a                	mv	a0,s2
    383e:	00002097          	auipc	ra,0x2
    3842:	296080e7          	jalr	662(ra) # 5ad4 <close>
  fd = open("small", O_RDONLY);
    3846:	4581                	li	a1,0
    3848:	00004517          	auipc	a0,0x4
    384c:	48850513          	addi	a0,a0,1160 # 7cd0 <csem_free+0x1bbc>
    3850:	00002097          	auipc	ra,0x2
    3854:	29c080e7          	jalr	668(ra) # 5aec <open>
    3858:	84aa                	mv	s1,a0
  if(fd < 0){
    385a:	0a054563          	bltz	a0,3904 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
    385e:	7d000613          	li	a2,2000
    3862:	00009597          	auipc	a1,0x9
    3866:	87e58593          	addi	a1,a1,-1922 # c0e0 <buf>
    386a:	00002097          	auipc	ra,0x2
    386e:	25a080e7          	jalr	602(ra) # 5ac4 <read>
  if(i != N*SZ*2){
    3872:	7d000793          	li	a5,2000
    3876:	0af51563          	bne	a0,a5,3920 <writetest+0x158>
  close(fd);
    387a:	8526                	mv	a0,s1
    387c:	00002097          	auipc	ra,0x2
    3880:	258080e7          	jalr	600(ra) # 5ad4 <close>
  if(unlink("small") < 0){
    3884:	00004517          	auipc	a0,0x4
    3888:	44c50513          	addi	a0,a0,1100 # 7cd0 <csem_free+0x1bbc>
    388c:	00002097          	auipc	ra,0x2
    3890:	270080e7          	jalr	624(ra) # 5afc <unlink>
    3894:	0a054463          	bltz	a0,393c <writetest+0x174>
}
    3898:	70e2                	ld	ra,56(sp)
    389a:	7442                	ld	s0,48(sp)
    389c:	74a2                	ld	s1,40(sp)
    389e:	7902                	ld	s2,32(sp)
    38a0:	69e2                	ld	s3,24(sp)
    38a2:	6a42                	ld	s4,16(sp)
    38a4:	6aa2                	ld	s5,8(sp)
    38a6:	6b02                	ld	s6,0(sp)
    38a8:	6121                	addi	sp,sp,64
    38aa:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
    38ac:	85da                	mv	a1,s6
    38ae:	00004517          	auipc	a0,0x4
    38b2:	42a50513          	addi	a0,a0,1066 # 7cd8 <csem_free+0x1bc4>
    38b6:	00002097          	auipc	ra,0x2
    38ba:	5c8080e7          	jalr	1480(ra) # 5e7e <printf>
    exit(1);
    38be:	4505                	li	a0,1
    38c0:	00002097          	auipc	ra,0x2
    38c4:	1ec080e7          	jalr	492(ra) # 5aac <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
    38c8:	8626                	mv	a2,s1
    38ca:	85da                	mv	a1,s6
    38cc:	00004517          	auipc	a0,0x4
    38d0:	43c50513          	addi	a0,a0,1084 # 7d08 <csem_free+0x1bf4>
    38d4:	00002097          	auipc	ra,0x2
    38d8:	5aa080e7          	jalr	1450(ra) # 5e7e <printf>
      exit(1);
    38dc:	4505                	li	a0,1
    38de:	00002097          	auipc	ra,0x2
    38e2:	1ce080e7          	jalr	462(ra) # 5aac <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
    38e6:	8626                	mv	a2,s1
    38e8:	85da                	mv	a1,s6
    38ea:	00004517          	auipc	a0,0x4
    38ee:	45650513          	addi	a0,a0,1110 # 7d40 <csem_free+0x1c2c>
    38f2:	00002097          	auipc	ra,0x2
    38f6:	58c080e7          	jalr	1420(ra) # 5e7e <printf>
      exit(1);
    38fa:	4505                	li	a0,1
    38fc:	00002097          	auipc	ra,0x2
    3900:	1b0080e7          	jalr	432(ra) # 5aac <exit>
    printf("%s: error: open small failed!\n", s);
    3904:	85da                	mv	a1,s6
    3906:	00004517          	auipc	a0,0x4
    390a:	46250513          	addi	a0,a0,1122 # 7d68 <csem_free+0x1c54>
    390e:	00002097          	auipc	ra,0x2
    3912:	570080e7          	jalr	1392(ra) # 5e7e <printf>
    exit(1);
    3916:	4505                	li	a0,1
    3918:	00002097          	auipc	ra,0x2
    391c:	194080e7          	jalr	404(ra) # 5aac <exit>
    printf("%s: read failed\n", s);
    3920:	85da                	mv	a1,s6
    3922:	00003517          	auipc	a0,0x3
    3926:	48650513          	addi	a0,a0,1158 # 6da8 <csem_free+0xc94>
    392a:	00002097          	auipc	ra,0x2
    392e:	554080e7          	jalr	1364(ra) # 5e7e <printf>
    exit(1);
    3932:	4505                	li	a0,1
    3934:	00002097          	auipc	ra,0x2
    3938:	178080e7          	jalr	376(ra) # 5aac <exit>
    printf("%s: unlink small failed\n", s);
    393c:	85da                	mv	a1,s6
    393e:	00004517          	auipc	a0,0x4
    3942:	44a50513          	addi	a0,a0,1098 # 7d88 <csem_free+0x1c74>
    3946:	00002097          	auipc	ra,0x2
    394a:	538080e7          	jalr	1336(ra) # 5e7e <printf>
    exit(1);
    394e:	4505                	li	a0,1
    3950:	00002097          	auipc	ra,0x2
    3954:	15c080e7          	jalr	348(ra) # 5aac <exit>

0000000000003958 <writebig>:
{
    3958:	7139                	addi	sp,sp,-64
    395a:	fc06                	sd	ra,56(sp)
    395c:	f822                	sd	s0,48(sp)
    395e:	f426                	sd	s1,40(sp)
    3960:	f04a                	sd	s2,32(sp)
    3962:	ec4e                	sd	s3,24(sp)
    3964:	e852                	sd	s4,16(sp)
    3966:	e456                	sd	s5,8(sp)
    3968:	0080                	addi	s0,sp,64
    396a:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
    396c:	20200593          	li	a1,514
    3970:	00004517          	auipc	a0,0x4
    3974:	43850513          	addi	a0,a0,1080 # 7da8 <csem_free+0x1c94>
    3978:	00002097          	auipc	ra,0x2
    397c:	174080e7          	jalr	372(ra) # 5aec <open>
    3980:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
    3982:	4481                	li	s1,0
    ((int*)buf)[0] = i;
    3984:	00008917          	auipc	s2,0x8
    3988:	75c90913          	addi	s2,s2,1884 # c0e0 <buf>
  for(i = 0; i < MAXFILE; i++){
    398c:	10c00a13          	li	s4,268
  if(fd < 0){
    3990:	06054c63          	bltz	a0,3a08 <writebig+0xb0>
    ((int*)buf)[0] = i;
    3994:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
    3998:	40000613          	li	a2,1024
    399c:	85ca                	mv	a1,s2
    399e:	854e                	mv	a0,s3
    39a0:	00002097          	auipc	ra,0x2
    39a4:	12c080e7          	jalr	300(ra) # 5acc <write>
    39a8:	40000793          	li	a5,1024
    39ac:	06f51c63          	bne	a0,a5,3a24 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
    39b0:	2485                	addiw	s1,s1,1
    39b2:	ff4491e3          	bne	s1,s4,3994 <writebig+0x3c>
  close(fd);
    39b6:	854e                	mv	a0,s3
    39b8:	00002097          	auipc	ra,0x2
    39bc:	11c080e7          	jalr	284(ra) # 5ad4 <close>
  fd = open("big", O_RDONLY);
    39c0:	4581                	li	a1,0
    39c2:	00004517          	auipc	a0,0x4
    39c6:	3e650513          	addi	a0,a0,998 # 7da8 <csem_free+0x1c94>
    39ca:	00002097          	auipc	ra,0x2
    39ce:	122080e7          	jalr	290(ra) # 5aec <open>
    39d2:	89aa                	mv	s3,a0
  n = 0;
    39d4:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
    39d6:	00008917          	auipc	s2,0x8
    39da:	70a90913          	addi	s2,s2,1802 # c0e0 <buf>
  if(fd < 0){
    39de:	06054263          	bltz	a0,3a42 <writebig+0xea>
    i = read(fd, buf, BSIZE);
    39e2:	40000613          	li	a2,1024
    39e6:	85ca                	mv	a1,s2
    39e8:	854e                	mv	a0,s3
    39ea:	00002097          	auipc	ra,0x2
    39ee:	0da080e7          	jalr	218(ra) # 5ac4 <read>
    if(i == 0){
    39f2:	c535                	beqz	a0,3a5e <writebig+0x106>
    } else if(i != BSIZE){
    39f4:	40000793          	li	a5,1024
    39f8:	0af51f63          	bne	a0,a5,3ab6 <writebig+0x15e>
    if(((int*)buf)[0] != n){
    39fc:	00092683          	lw	a3,0(s2)
    3a00:	0c969a63          	bne	a3,s1,3ad4 <writebig+0x17c>
    n++;
    3a04:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
    3a06:	bff1                	j	39e2 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
    3a08:	85d6                	mv	a1,s5
    3a0a:	00004517          	auipc	a0,0x4
    3a0e:	3a650513          	addi	a0,a0,934 # 7db0 <csem_free+0x1c9c>
    3a12:	00002097          	auipc	ra,0x2
    3a16:	46c080e7          	jalr	1132(ra) # 5e7e <printf>
    exit(1);
    3a1a:	4505                	li	a0,1
    3a1c:	00002097          	auipc	ra,0x2
    3a20:	090080e7          	jalr	144(ra) # 5aac <exit>
      printf("%s: error: write big file failed\n", s, i);
    3a24:	8626                	mv	a2,s1
    3a26:	85d6                	mv	a1,s5
    3a28:	00004517          	auipc	a0,0x4
    3a2c:	3a850513          	addi	a0,a0,936 # 7dd0 <csem_free+0x1cbc>
    3a30:	00002097          	auipc	ra,0x2
    3a34:	44e080e7          	jalr	1102(ra) # 5e7e <printf>
      exit(1);
    3a38:	4505                	li	a0,1
    3a3a:	00002097          	auipc	ra,0x2
    3a3e:	072080e7          	jalr	114(ra) # 5aac <exit>
    printf("%s: error: open big failed!\n", s);
    3a42:	85d6                	mv	a1,s5
    3a44:	00004517          	auipc	a0,0x4
    3a48:	3b450513          	addi	a0,a0,948 # 7df8 <csem_free+0x1ce4>
    3a4c:	00002097          	auipc	ra,0x2
    3a50:	432080e7          	jalr	1074(ra) # 5e7e <printf>
    exit(1);
    3a54:	4505                	li	a0,1
    3a56:	00002097          	auipc	ra,0x2
    3a5a:	056080e7          	jalr	86(ra) # 5aac <exit>
      if(n == MAXFILE - 1){
    3a5e:	10b00793          	li	a5,267
    3a62:	02f48a63          	beq	s1,a5,3a96 <writebig+0x13e>
  close(fd);
    3a66:	854e                	mv	a0,s3
    3a68:	00002097          	auipc	ra,0x2
    3a6c:	06c080e7          	jalr	108(ra) # 5ad4 <close>
  if(unlink("big") < 0){
    3a70:	00004517          	auipc	a0,0x4
    3a74:	33850513          	addi	a0,a0,824 # 7da8 <csem_free+0x1c94>
    3a78:	00002097          	auipc	ra,0x2
    3a7c:	084080e7          	jalr	132(ra) # 5afc <unlink>
    3a80:	06054963          	bltz	a0,3af2 <writebig+0x19a>
}
    3a84:	70e2                	ld	ra,56(sp)
    3a86:	7442                	ld	s0,48(sp)
    3a88:	74a2                	ld	s1,40(sp)
    3a8a:	7902                	ld	s2,32(sp)
    3a8c:	69e2                	ld	s3,24(sp)
    3a8e:	6a42                	ld	s4,16(sp)
    3a90:	6aa2                	ld	s5,8(sp)
    3a92:	6121                	addi	sp,sp,64
    3a94:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
    3a96:	10b00613          	li	a2,267
    3a9a:	85d6                	mv	a1,s5
    3a9c:	00004517          	auipc	a0,0x4
    3aa0:	37c50513          	addi	a0,a0,892 # 7e18 <csem_free+0x1d04>
    3aa4:	00002097          	auipc	ra,0x2
    3aa8:	3da080e7          	jalr	986(ra) # 5e7e <printf>
        exit(1);
    3aac:	4505                	li	a0,1
    3aae:	00002097          	auipc	ra,0x2
    3ab2:	ffe080e7          	jalr	-2(ra) # 5aac <exit>
      printf("%s: read failed %d\n", s, i);
    3ab6:	862a                	mv	a2,a0
    3ab8:	85d6                	mv	a1,s5
    3aba:	00004517          	auipc	a0,0x4
    3abe:	38650513          	addi	a0,a0,902 # 7e40 <csem_free+0x1d2c>
    3ac2:	00002097          	auipc	ra,0x2
    3ac6:	3bc080e7          	jalr	956(ra) # 5e7e <printf>
      exit(1);
    3aca:	4505                	li	a0,1
    3acc:	00002097          	auipc	ra,0x2
    3ad0:	fe0080e7          	jalr	-32(ra) # 5aac <exit>
      printf("%s: read content of block %d is %d\n", s,
    3ad4:	8626                	mv	a2,s1
    3ad6:	85d6                	mv	a1,s5
    3ad8:	00004517          	auipc	a0,0x4
    3adc:	38050513          	addi	a0,a0,896 # 7e58 <csem_free+0x1d44>
    3ae0:	00002097          	auipc	ra,0x2
    3ae4:	39e080e7          	jalr	926(ra) # 5e7e <printf>
      exit(1);
    3ae8:	4505                	li	a0,1
    3aea:	00002097          	auipc	ra,0x2
    3aee:	fc2080e7          	jalr	-62(ra) # 5aac <exit>
    printf("%s: unlink big failed\n", s);
    3af2:	85d6                	mv	a1,s5
    3af4:	00004517          	auipc	a0,0x4
    3af8:	38c50513          	addi	a0,a0,908 # 7e80 <csem_free+0x1d6c>
    3afc:	00002097          	auipc	ra,0x2
    3b00:	382080e7          	jalr	898(ra) # 5e7e <printf>
    exit(1);
    3b04:	4505                	li	a0,1
    3b06:	00002097          	auipc	ra,0x2
    3b0a:	fa6080e7          	jalr	-90(ra) # 5aac <exit>

0000000000003b0e <createtest>:
{
    3b0e:	7179                	addi	sp,sp,-48
    3b10:	f406                	sd	ra,40(sp)
    3b12:	f022                	sd	s0,32(sp)
    3b14:	ec26                	sd	s1,24(sp)
    3b16:	e84a                	sd	s2,16(sp)
    3b18:	1800                	addi	s0,sp,48
  name[0] = 'a';
    3b1a:	06100793          	li	a5,97
    3b1e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
    3b22:	fc040d23          	sb	zero,-38(s0)
    3b26:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
    3b2a:	06400913          	li	s2,100
    name[1] = '0' + i;
    3b2e:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
    3b32:	20200593          	li	a1,514
    3b36:	fd840513          	addi	a0,s0,-40
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	fb2080e7          	jalr	-78(ra) # 5aec <open>
    close(fd);
    3b42:	00002097          	auipc	ra,0x2
    3b46:	f92080e7          	jalr	-110(ra) # 5ad4 <close>
  for(i = 0; i < N; i++){
    3b4a:	2485                	addiw	s1,s1,1
    3b4c:	0ff4f493          	andi	s1,s1,255
    3b50:	fd249fe3          	bne	s1,s2,3b2e <createtest+0x20>
  name[0] = 'a';
    3b54:	06100793          	li	a5,97
    3b58:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
    3b5c:	fc040d23          	sb	zero,-38(s0)
    3b60:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
    3b64:	06400913          	li	s2,100
    name[1] = '0' + i;
    3b68:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
    3b6c:	fd840513          	addi	a0,s0,-40
    3b70:	00002097          	auipc	ra,0x2
    3b74:	f8c080e7          	jalr	-116(ra) # 5afc <unlink>
  for(i = 0; i < N; i++){
    3b78:	2485                	addiw	s1,s1,1
    3b7a:	0ff4f493          	andi	s1,s1,255
    3b7e:	ff2495e3          	bne	s1,s2,3b68 <createtest+0x5a>
}
    3b82:	70a2                	ld	ra,40(sp)
    3b84:	7402                	ld	s0,32(sp)
    3b86:	64e2                	ld	s1,24(sp)
    3b88:	6942                	ld	s2,16(sp)
    3b8a:	6145                	addi	sp,sp,48
    3b8c:	8082                	ret

0000000000003b8e <killstatus>:
{
    3b8e:	7139                	addi	sp,sp,-64
    3b90:	fc06                	sd	ra,56(sp)
    3b92:	f822                	sd	s0,48(sp)
    3b94:	f426                	sd	s1,40(sp)
    3b96:	f04a                	sd	s2,32(sp)
    3b98:	ec4e                	sd	s3,24(sp)
    3b9a:	e852                	sd	s4,16(sp)
    3b9c:	0080                	addi	s0,sp,64
    3b9e:	8a2a                	mv	s4,a0
    3ba0:	06400913          	li	s2,100
    if(xst != -1) {
    3ba4:	59fd                	li	s3,-1
    int pid1 = fork();
    3ba6:	00002097          	auipc	ra,0x2
    3baa:	efe080e7          	jalr	-258(ra) # 5aa4 <fork>
    3bae:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3bb0:	04054063          	bltz	a0,3bf0 <killstatus+0x62>
    if(pid1 == 0){
    3bb4:	cd21                	beqz	a0,3c0c <killstatus+0x7e>
    sleep(1);
    3bb6:	4505                	li	a0,1
    3bb8:	00002097          	auipc	ra,0x2
    3bbc:	f84080e7          	jalr	-124(ra) # 5b3c <sleep>
    kill(pid1, SIGKILL);
    3bc0:	45a5                	li	a1,9
    3bc2:	8526                	mv	a0,s1
    3bc4:	00002097          	auipc	ra,0x2
    3bc8:	f18080e7          	jalr	-232(ra) # 5adc <kill>
    wait(&xst);
    3bcc:	fcc40513          	addi	a0,s0,-52
    3bd0:	00002097          	auipc	ra,0x2
    3bd4:	ee4080e7          	jalr	-284(ra) # 5ab4 <wait>
    if(xst != -1) {
    3bd8:	fcc42783          	lw	a5,-52(s0)
    3bdc:	03379d63          	bne	a5,s3,3c16 <killstatus+0x88>
  for(int i = 0; i < 100; i++){
    3be0:	397d                	addiw	s2,s2,-1
    3be2:	fc0912e3          	bnez	s2,3ba6 <killstatus+0x18>
  exit(0);
    3be6:	4501                	li	a0,0
    3be8:	00002097          	auipc	ra,0x2
    3bec:	ec4080e7          	jalr	-316(ra) # 5aac <exit>
      printf("%s: fork failed\n", s);
    3bf0:	85d2                	mv	a1,s4
    3bf2:	00003517          	auipc	a0,0x3
    3bf6:	85650513          	addi	a0,a0,-1962 # 6448 <csem_free+0x334>
    3bfa:	00002097          	auipc	ra,0x2
    3bfe:	284080e7          	jalr	644(ra) # 5e7e <printf>
      exit(1);
    3c02:	4505                	li	a0,1
    3c04:	00002097          	auipc	ra,0x2
    3c08:	ea8080e7          	jalr	-344(ra) # 5aac <exit>
        getpid();
    3c0c:	00002097          	auipc	ra,0x2
    3c10:	f20080e7          	jalr	-224(ra) # 5b2c <getpid>
      while(1) {
    3c14:	bfe5                	j	3c0c <killstatus+0x7e>
       printf("%s: status should be -1\n", s);
    3c16:	85d2                	mv	a1,s4
    3c18:	00004517          	auipc	a0,0x4
    3c1c:	28050513          	addi	a0,a0,640 # 7e98 <csem_free+0x1d84>
    3c20:	00002097          	auipc	ra,0x2
    3c24:	25e080e7          	jalr	606(ra) # 5e7e <printf>
       exit(1);
    3c28:	4505                	li	a0,1
    3c2a:	00002097          	auipc	ra,0x2
    3c2e:	e82080e7          	jalr	-382(ra) # 5aac <exit>

0000000000003c32 <reparent2>:
{
    3c32:	1101                	addi	sp,sp,-32
    3c34:	ec06                	sd	ra,24(sp)
    3c36:	e822                	sd	s0,16(sp)
    3c38:	e426                	sd	s1,8(sp)
    3c3a:	1000                	addi	s0,sp,32
    3c3c:	32000493          	li	s1,800
    int pid1 = fork();
    3c40:	00002097          	auipc	ra,0x2
    3c44:	e64080e7          	jalr	-412(ra) # 5aa4 <fork>
    if(pid1 < 0){
    3c48:	00054f63          	bltz	a0,3c66 <reparent2+0x34>
    if(pid1 == 0){
    3c4c:	c915                	beqz	a0,3c80 <reparent2+0x4e>
    wait(0);
    3c4e:	4501                	li	a0,0
    3c50:	00002097          	auipc	ra,0x2
    3c54:	e64080e7          	jalr	-412(ra) # 5ab4 <wait>
  for(int i = 0; i < 800; i++){
    3c58:	34fd                	addiw	s1,s1,-1
    3c5a:	f0fd                	bnez	s1,3c40 <reparent2+0xe>
  exit(0);
    3c5c:	4501                	li	a0,0
    3c5e:	00002097          	auipc	ra,0x2
    3c62:	e4e080e7          	jalr	-434(ra) # 5aac <exit>
      printf("fork failed\n");
    3c66:	00003517          	auipc	a0,0x3
    3c6a:	27250513          	addi	a0,a0,626 # 6ed8 <csem_free+0xdc4>
    3c6e:	00002097          	auipc	ra,0x2
    3c72:	210080e7          	jalr	528(ra) # 5e7e <printf>
      exit(1);
    3c76:	4505                	li	a0,1
    3c78:	00002097          	auipc	ra,0x2
    3c7c:	e34080e7          	jalr	-460(ra) # 5aac <exit>
      fork();
    3c80:	00002097          	auipc	ra,0x2
    3c84:	e24080e7          	jalr	-476(ra) # 5aa4 <fork>
      fork();
    3c88:	00002097          	auipc	ra,0x2
    3c8c:	e1c080e7          	jalr	-484(ra) # 5aa4 <fork>
      exit(0);
    3c90:	4501                	li	a0,0
    3c92:	00002097          	auipc	ra,0x2
    3c96:	e1a080e7          	jalr	-486(ra) # 5aac <exit>

0000000000003c9a <mem>:
{
    3c9a:	7139                	addi	sp,sp,-64
    3c9c:	fc06                	sd	ra,56(sp)
    3c9e:	f822                	sd	s0,48(sp)
    3ca0:	f426                	sd	s1,40(sp)
    3ca2:	f04a                	sd	s2,32(sp)
    3ca4:	ec4e                	sd	s3,24(sp)
    3ca6:	0080                	addi	s0,sp,64
    3ca8:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3caa:	00002097          	auipc	ra,0x2
    3cae:	dfa080e7          	jalr	-518(ra) # 5aa4 <fork>
    m1 = 0;
    3cb2:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3cb4:	6909                	lui	s2,0x2
    3cb6:	71190913          	addi	s2,s2,1809 # 2711 <subdir+0x115>
  if((pid = fork()) == 0){
    3cba:	c115                	beqz	a0,3cde <mem+0x44>
    wait(&xstatus);
    3cbc:	fcc40513          	addi	a0,s0,-52
    3cc0:	00002097          	auipc	ra,0x2
    3cc4:	df4080e7          	jalr	-524(ra) # 5ab4 <wait>
    if(xstatus == -1){
    3cc8:	fcc42503          	lw	a0,-52(s0)
    3ccc:	57fd                	li	a5,-1
    3cce:	06f50363          	beq	a0,a5,3d34 <mem+0x9a>
    exit(xstatus);
    3cd2:	00002097          	auipc	ra,0x2
    3cd6:	dda080e7          	jalr	-550(ra) # 5aac <exit>
      *(char**)m2 = m1;
    3cda:	e104                	sd	s1,0(a0)
      m1 = m2;
    3cdc:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3cde:	854a                	mv	a0,s2
    3ce0:	00002097          	auipc	ra,0x2
    3ce4:	25c080e7          	jalr	604(ra) # 5f3c <malloc>
    3ce8:	f96d                	bnez	a0,3cda <mem+0x40>
    while(m1){
    3cea:	c881                	beqz	s1,3cfa <mem+0x60>
      m2 = *(char**)m1;
    3cec:	8526                	mv	a0,s1
    3cee:	6084                	ld	s1,0(s1)
      free(m1);
    3cf0:	00002097          	auipc	ra,0x2
    3cf4:	1c4080e7          	jalr	452(ra) # 5eb4 <free>
    while(m1){
    3cf8:	f8f5                	bnez	s1,3cec <mem+0x52>
    m1 = malloc(1024*20);
    3cfa:	6515                	lui	a0,0x5
    3cfc:	00002097          	auipc	ra,0x2
    3d00:	240080e7          	jalr	576(ra) # 5f3c <malloc>
    if(m1 == 0){
    3d04:	c911                	beqz	a0,3d18 <mem+0x7e>
    free(m1);
    3d06:	00002097          	auipc	ra,0x2
    3d0a:	1ae080e7          	jalr	430(ra) # 5eb4 <free>
    exit(0);
    3d0e:	4501                	li	a0,0
    3d10:	00002097          	auipc	ra,0x2
    3d14:	d9c080e7          	jalr	-612(ra) # 5aac <exit>
      printf("couldn't allocate mem?!!\n", s);
    3d18:	85ce                	mv	a1,s3
    3d1a:	00004517          	auipc	a0,0x4
    3d1e:	19e50513          	addi	a0,a0,414 # 7eb8 <csem_free+0x1da4>
    3d22:	00002097          	auipc	ra,0x2
    3d26:	15c080e7          	jalr	348(ra) # 5e7e <printf>
      exit(1);
    3d2a:	4505                	li	a0,1
    3d2c:	00002097          	auipc	ra,0x2
    3d30:	d80080e7          	jalr	-640(ra) # 5aac <exit>
      exit(0);
    3d34:	4501                	li	a0,0
    3d36:	00002097          	auipc	ra,0x2
    3d3a:	d76080e7          	jalr	-650(ra) # 5aac <exit>

0000000000003d3e <sharedfd>:
{
    3d3e:	7159                	addi	sp,sp,-112
    3d40:	f486                	sd	ra,104(sp)
    3d42:	f0a2                	sd	s0,96(sp)
    3d44:	eca6                	sd	s1,88(sp)
    3d46:	e8ca                	sd	s2,80(sp)
    3d48:	e4ce                	sd	s3,72(sp)
    3d4a:	e0d2                	sd	s4,64(sp)
    3d4c:	fc56                	sd	s5,56(sp)
    3d4e:	f85a                	sd	s6,48(sp)
    3d50:	f45e                	sd	s7,40(sp)
    3d52:	1880                	addi	s0,sp,112
    3d54:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    3d56:	00004517          	auipc	a0,0x4
    3d5a:	18250513          	addi	a0,a0,386 # 7ed8 <csem_free+0x1dc4>
    3d5e:	00002097          	auipc	ra,0x2
    3d62:	d9e080e7          	jalr	-610(ra) # 5afc <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3d66:	20200593          	li	a1,514
    3d6a:	00004517          	auipc	a0,0x4
    3d6e:	16e50513          	addi	a0,a0,366 # 7ed8 <csem_free+0x1dc4>
    3d72:	00002097          	auipc	ra,0x2
    3d76:	d7a080e7          	jalr	-646(ra) # 5aec <open>
  if(fd < 0){
    3d7a:	04054a63          	bltz	a0,3dce <sharedfd+0x90>
    3d7e:	892a                	mv	s2,a0
  pid = fork();
    3d80:	00002097          	auipc	ra,0x2
    3d84:	d24080e7          	jalr	-732(ra) # 5aa4 <fork>
    3d88:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3d8a:	06300593          	li	a1,99
    3d8e:	c119                	beqz	a0,3d94 <sharedfd+0x56>
    3d90:	07000593          	li	a1,112
    3d94:	4629                	li	a2,10
    3d96:	fa040513          	addi	a0,s0,-96
    3d9a:	00002097          	auipc	ra,0x2
    3d9e:	b16080e7          	jalr	-1258(ra) # 58b0 <memset>
    3da2:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3da6:	4629                	li	a2,10
    3da8:	fa040593          	addi	a1,s0,-96
    3dac:	854a                	mv	a0,s2
    3dae:	00002097          	auipc	ra,0x2
    3db2:	d1e080e7          	jalr	-738(ra) # 5acc <write>
    3db6:	47a9                	li	a5,10
    3db8:	02f51963          	bne	a0,a5,3dea <sharedfd+0xac>
  for(i = 0; i < N; i++){
    3dbc:	34fd                	addiw	s1,s1,-1
    3dbe:	f4e5                	bnez	s1,3da6 <sharedfd+0x68>
  if(pid == 0) {
    3dc0:	04099363          	bnez	s3,3e06 <sharedfd+0xc8>
    exit(0);
    3dc4:	4501                	li	a0,0
    3dc6:	00002097          	auipc	ra,0x2
    3dca:	ce6080e7          	jalr	-794(ra) # 5aac <exit>
    printf("%s: cannot open sharedfd for writing", s);
    3dce:	85d2                	mv	a1,s4
    3dd0:	00004517          	auipc	a0,0x4
    3dd4:	11850513          	addi	a0,a0,280 # 7ee8 <csem_free+0x1dd4>
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	0a6080e7          	jalr	166(ra) # 5e7e <printf>
    exit(1);
    3de0:	4505                	li	a0,1
    3de2:	00002097          	auipc	ra,0x2
    3de6:	cca080e7          	jalr	-822(ra) # 5aac <exit>
      printf("%s: write sharedfd failed\n", s);
    3dea:	85d2                	mv	a1,s4
    3dec:	00004517          	auipc	a0,0x4
    3df0:	12450513          	addi	a0,a0,292 # 7f10 <csem_free+0x1dfc>
    3df4:	00002097          	auipc	ra,0x2
    3df8:	08a080e7          	jalr	138(ra) # 5e7e <printf>
      exit(1);
    3dfc:	4505                	li	a0,1
    3dfe:	00002097          	auipc	ra,0x2
    3e02:	cae080e7          	jalr	-850(ra) # 5aac <exit>
    wait(&xstatus);
    3e06:	f9c40513          	addi	a0,s0,-100
    3e0a:	00002097          	auipc	ra,0x2
    3e0e:	caa080e7          	jalr	-854(ra) # 5ab4 <wait>
    if(xstatus != 0)
    3e12:	f9c42983          	lw	s3,-100(s0)
    3e16:	00098763          	beqz	s3,3e24 <sharedfd+0xe6>
      exit(xstatus);
    3e1a:	854e                	mv	a0,s3
    3e1c:	00002097          	auipc	ra,0x2
    3e20:	c90080e7          	jalr	-880(ra) # 5aac <exit>
  close(fd);
    3e24:	854a                	mv	a0,s2
    3e26:	00002097          	auipc	ra,0x2
    3e2a:	cae080e7          	jalr	-850(ra) # 5ad4 <close>
  fd = open("sharedfd", 0);
    3e2e:	4581                	li	a1,0
    3e30:	00004517          	auipc	a0,0x4
    3e34:	0a850513          	addi	a0,a0,168 # 7ed8 <csem_free+0x1dc4>
    3e38:	00002097          	auipc	ra,0x2
    3e3c:	cb4080e7          	jalr	-844(ra) # 5aec <open>
    3e40:	8baa                	mv	s7,a0
  nc = np = 0;
    3e42:	8ace                	mv	s5,s3
  if(fd < 0){
    3e44:	02054563          	bltz	a0,3e6e <sharedfd+0x130>
    3e48:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3e4c:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3e50:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3e54:	4629                	li	a2,10
    3e56:	fa040593          	addi	a1,s0,-96
    3e5a:	855e                	mv	a0,s7
    3e5c:	00002097          	auipc	ra,0x2
    3e60:	c68080e7          	jalr	-920(ra) # 5ac4 <read>
    3e64:	02a05f63          	blez	a0,3ea2 <sharedfd+0x164>
    3e68:	fa040793          	addi	a5,s0,-96
    3e6c:	a01d                	j	3e92 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    3e6e:	85d2                	mv	a1,s4
    3e70:	00004517          	auipc	a0,0x4
    3e74:	0c050513          	addi	a0,a0,192 # 7f30 <csem_free+0x1e1c>
    3e78:	00002097          	auipc	ra,0x2
    3e7c:	006080e7          	jalr	6(ra) # 5e7e <printf>
    exit(1);
    3e80:	4505                	li	a0,1
    3e82:	00002097          	auipc	ra,0x2
    3e86:	c2a080e7          	jalr	-982(ra) # 5aac <exit>
        nc++;
    3e8a:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    3e8c:	0785                	addi	a5,a5,1
    3e8e:	fd2783e3          	beq	a5,s2,3e54 <sharedfd+0x116>
      if(buf[i] == 'c')
    3e92:	0007c703          	lbu	a4,0(a5)
    3e96:	fe970ae3          	beq	a4,s1,3e8a <sharedfd+0x14c>
      if(buf[i] == 'p')
    3e9a:	ff6719e3          	bne	a4,s6,3e8c <sharedfd+0x14e>
        np++;
    3e9e:	2a85                	addiw	s5,s5,1
    3ea0:	b7f5                	j	3e8c <sharedfd+0x14e>
  close(fd);
    3ea2:	855e                	mv	a0,s7
    3ea4:	00002097          	auipc	ra,0x2
    3ea8:	c30080e7          	jalr	-976(ra) # 5ad4 <close>
  unlink("sharedfd");
    3eac:	00004517          	auipc	a0,0x4
    3eb0:	02c50513          	addi	a0,a0,44 # 7ed8 <csem_free+0x1dc4>
    3eb4:	00002097          	auipc	ra,0x2
    3eb8:	c48080e7          	jalr	-952(ra) # 5afc <unlink>
  if(nc == N*SZ && np == N*SZ){
    3ebc:	6789                	lui	a5,0x2
    3ebe:	71078793          	addi	a5,a5,1808 # 2710 <subdir+0x114>
    3ec2:	00f99763          	bne	s3,a5,3ed0 <sharedfd+0x192>
    3ec6:	6789                	lui	a5,0x2
    3ec8:	71078793          	addi	a5,a5,1808 # 2710 <subdir+0x114>
    3ecc:	02fa8063          	beq	s5,a5,3eec <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    3ed0:	85d2                	mv	a1,s4
    3ed2:	00004517          	auipc	a0,0x4
    3ed6:	08650513          	addi	a0,a0,134 # 7f58 <csem_free+0x1e44>
    3eda:	00002097          	auipc	ra,0x2
    3ede:	fa4080e7          	jalr	-92(ra) # 5e7e <printf>
    exit(1);
    3ee2:	4505                	li	a0,1
    3ee4:	00002097          	auipc	ra,0x2
    3ee8:	bc8080e7          	jalr	-1080(ra) # 5aac <exit>
    exit(0);
    3eec:	4501                	li	a0,0
    3eee:	00002097          	auipc	ra,0x2
    3ef2:	bbe080e7          	jalr	-1090(ra) # 5aac <exit>

0000000000003ef6 <createdelete>:
{
    3ef6:	7175                	addi	sp,sp,-144
    3ef8:	e506                	sd	ra,136(sp)
    3efa:	e122                	sd	s0,128(sp)
    3efc:	fca6                	sd	s1,120(sp)
    3efe:	f8ca                	sd	s2,112(sp)
    3f00:	f4ce                	sd	s3,104(sp)
    3f02:	f0d2                	sd	s4,96(sp)
    3f04:	ecd6                	sd	s5,88(sp)
    3f06:	e8da                	sd	s6,80(sp)
    3f08:	e4de                	sd	s7,72(sp)
    3f0a:	e0e2                	sd	s8,64(sp)
    3f0c:	fc66                	sd	s9,56(sp)
    3f0e:	0900                	addi	s0,sp,144
    3f10:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    3f12:	4901                	li	s2,0
    3f14:	4991                	li	s3,4
    pid = fork();
    3f16:	00002097          	auipc	ra,0x2
    3f1a:	b8e080e7          	jalr	-1138(ra) # 5aa4 <fork>
    3f1e:	84aa                	mv	s1,a0
    if(pid < 0){
    3f20:	02054f63          	bltz	a0,3f5e <createdelete+0x68>
    if(pid == 0){
    3f24:	c939                	beqz	a0,3f7a <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    3f26:	2905                	addiw	s2,s2,1
    3f28:	ff3917e3          	bne	s2,s3,3f16 <createdelete+0x20>
    3f2c:	4491                	li	s1,4
    wait(&xstatus);
    3f2e:	f7c40513          	addi	a0,s0,-132
    3f32:	00002097          	auipc	ra,0x2
    3f36:	b82080e7          	jalr	-1150(ra) # 5ab4 <wait>
    if(xstatus != 0)
    3f3a:	f7c42903          	lw	s2,-132(s0)
    3f3e:	0e091263          	bnez	s2,4022 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    3f42:	34fd                	addiw	s1,s1,-1
    3f44:	f4ed                	bnez	s1,3f2e <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    3f46:	f8040123          	sb	zero,-126(s0)
    3f4a:	03000993          	li	s3,48
    3f4e:	5a7d                	li	s4,-1
    3f50:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    3f54:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    3f56:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    3f58:	07400a93          	li	s5,116
    3f5c:	a29d                	j	40c2 <createdelete+0x1cc>
      printf("fork failed\n", s);
    3f5e:	85e6                	mv	a1,s9
    3f60:	00003517          	auipc	a0,0x3
    3f64:	f7850513          	addi	a0,a0,-136 # 6ed8 <csem_free+0xdc4>
    3f68:	00002097          	auipc	ra,0x2
    3f6c:	f16080e7          	jalr	-234(ra) # 5e7e <printf>
      exit(1);
    3f70:	4505                	li	a0,1
    3f72:	00002097          	auipc	ra,0x2
    3f76:	b3a080e7          	jalr	-1222(ra) # 5aac <exit>
      name[0] = 'p' + pi;
    3f7a:	0709091b          	addiw	s2,s2,112
    3f7e:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    3f82:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    3f86:	4951                	li	s2,20
    3f88:	a015                	j	3fac <createdelete+0xb6>
          printf("%s: create failed\n", s);
    3f8a:	85e6                	mv	a1,s9
    3f8c:	00003517          	auipc	a0,0x3
    3f90:	dac50513          	addi	a0,a0,-596 # 6d38 <csem_free+0xc24>
    3f94:	00002097          	auipc	ra,0x2
    3f98:	eea080e7          	jalr	-278(ra) # 5e7e <printf>
          exit(1);
    3f9c:	4505                	li	a0,1
    3f9e:	00002097          	auipc	ra,0x2
    3fa2:	b0e080e7          	jalr	-1266(ra) # 5aac <exit>
      for(i = 0; i < N; i++){
    3fa6:	2485                	addiw	s1,s1,1
    3fa8:	07248863          	beq	s1,s2,4018 <createdelete+0x122>
        name[1] = '0' + i;
    3fac:	0304879b          	addiw	a5,s1,48
    3fb0:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    3fb4:	20200593          	li	a1,514
    3fb8:	f8040513          	addi	a0,s0,-128
    3fbc:	00002097          	auipc	ra,0x2
    3fc0:	b30080e7          	jalr	-1232(ra) # 5aec <open>
        if(fd < 0){
    3fc4:	fc0543e3          	bltz	a0,3f8a <createdelete+0x94>
        close(fd);
    3fc8:	00002097          	auipc	ra,0x2
    3fcc:	b0c080e7          	jalr	-1268(ra) # 5ad4 <close>
        if(i > 0 && (i % 2 ) == 0){
    3fd0:	fc905be3          	blez	s1,3fa6 <createdelete+0xb0>
    3fd4:	0014f793          	andi	a5,s1,1
    3fd8:	f7f9                	bnez	a5,3fa6 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    3fda:	01f4d79b          	srliw	a5,s1,0x1f
    3fde:	9fa5                	addw	a5,a5,s1
    3fe0:	4017d79b          	sraiw	a5,a5,0x1
    3fe4:	0307879b          	addiw	a5,a5,48
    3fe8:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    3fec:	f8040513          	addi	a0,s0,-128
    3ff0:	00002097          	auipc	ra,0x2
    3ff4:	b0c080e7          	jalr	-1268(ra) # 5afc <unlink>
    3ff8:	fa0557e3          	bgez	a0,3fa6 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    3ffc:	85e6                	mv	a1,s9
    3ffe:	00003517          	auipc	a0,0x3
    4002:	04250513          	addi	a0,a0,66 # 7040 <csem_free+0xf2c>
    4006:	00002097          	auipc	ra,0x2
    400a:	e78080e7          	jalr	-392(ra) # 5e7e <printf>
            exit(1);
    400e:	4505                	li	a0,1
    4010:	00002097          	auipc	ra,0x2
    4014:	a9c080e7          	jalr	-1380(ra) # 5aac <exit>
      exit(0);
    4018:	4501                	li	a0,0
    401a:	00002097          	auipc	ra,0x2
    401e:	a92080e7          	jalr	-1390(ra) # 5aac <exit>
      exit(1);
    4022:	4505                	li	a0,1
    4024:	00002097          	auipc	ra,0x2
    4028:	a88080e7          	jalr	-1400(ra) # 5aac <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    402c:	f8040613          	addi	a2,s0,-128
    4030:	85e6                	mv	a1,s9
    4032:	00004517          	auipc	a0,0x4
    4036:	f3e50513          	addi	a0,a0,-194 # 7f70 <csem_free+0x1e5c>
    403a:	00002097          	auipc	ra,0x2
    403e:	e44080e7          	jalr	-444(ra) # 5e7e <printf>
        exit(1);
    4042:	4505                	li	a0,1
    4044:	00002097          	auipc	ra,0x2
    4048:	a68080e7          	jalr	-1432(ra) # 5aac <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    404c:	054b7163          	bgeu	s6,s4,408e <createdelete+0x198>
      if(fd >= 0)
    4050:	02055a63          	bgez	a0,4084 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    4054:	2485                	addiw	s1,s1,1
    4056:	0ff4f493          	andi	s1,s1,255
    405a:	05548c63          	beq	s1,s5,40b2 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    405e:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    4062:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    4066:	4581                	li	a1,0
    4068:	f8040513          	addi	a0,s0,-128
    406c:	00002097          	auipc	ra,0x2
    4070:	a80080e7          	jalr	-1408(ra) # 5aec <open>
      if((i == 0 || i >= N/2) && fd < 0){
    4074:	00090463          	beqz	s2,407c <createdelete+0x186>
    4078:	fd2bdae3          	bge	s7,s2,404c <createdelete+0x156>
    407c:	fa0548e3          	bltz	a0,402c <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    4080:	014b7963          	bgeu	s6,s4,4092 <createdelete+0x19c>
        close(fd);
    4084:	00002097          	auipc	ra,0x2
    4088:	a50080e7          	jalr	-1456(ra) # 5ad4 <close>
    408c:	b7e1                	j	4054 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    408e:	fc0543e3          	bltz	a0,4054 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    4092:	f8040613          	addi	a2,s0,-128
    4096:	85e6                	mv	a1,s9
    4098:	00004517          	auipc	a0,0x4
    409c:	f0050513          	addi	a0,a0,-256 # 7f98 <csem_free+0x1e84>
    40a0:	00002097          	auipc	ra,0x2
    40a4:	dde080e7          	jalr	-546(ra) # 5e7e <printf>
        exit(1);
    40a8:	4505                	li	a0,1
    40aa:	00002097          	auipc	ra,0x2
    40ae:	a02080e7          	jalr	-1534(ra) # 5aac <exit>
  for(i = 0; i < N; i++){
    40b2:	2905                	addiw	s2,s2,1
    40b4:	2a05                	addiw	s4,s4,1
    40b6:	2985                	addiw	s3,s3,1
    40b8:	0ff9f993          	andi	s3,s3,255
    40bc:	47d1                	li	a5,20
    40be:	02f90a63          	beq	s2,a5,40f2 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    40c2:	84e2                	mv	s1,s8
    40c4:	bf69                	j	405e <createdelete+0x168>
  for(i = 0; i < N; i++){
    40c6:	2905                	addiw	s2,s2,1
    40c8:	0ff97913          	andi	s2,s2,255
    40cc:	2985                	addiw	s3,s3,1
    40ce:	0ff9f993          	andi	s3,s3,255
    40d2:	03490863          	beq	s2,s4,4102 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    40d6:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    40d8:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    40dc:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    40e0:	f8040513          	addi	a0,s0,-128
    40e4:	00002097          	auipc	ra,0x2
    40e8:	a18080e7          	jalr	-1512(ra) # 5afc <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    40ec:	34fd                	addiw	s1,s1,-1
    40ee:	f4ed                	bnez	s1,40d8 <createdelete+0x1e2>
    40f0:	bfd9                	j	40c6 <createdelete+0x1d0>
    40f2:	03000993          	li	s3,48
    40f6:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    40fa:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    40fc:	08400a13          	li	s4,132
    4100:	bfd9                	j	40d6 <createdelete+0x1e0>
}
    4102:	60aa                	ld	ra,136(sp)
    4104:	640a                	ld	s0,128(sp)
    4106:	74e6                	ld	s1,120(sp)
    4108:	7946                	ld	s2,112(sp)
    410a:	79a6                	ld	s3,104(sp)
    410c:	7a06                	ld	s4,96(sp)
    410e:	6ae6                	ld	s5,88(sp)
    4110:	6b46                	ld	s6,80(sp)
    4112:	6ba6                	ld	s7,72(sp)
    4114:	6c06                	ld	s8,64(sp)
    4116:	7ce2                	ld	s9,56(sp)
    4118:	6149                	addi	sp,sp,144
    411a:	8082                	ret

000000000000411c <concreate>:
{
    411c:	7135                	addi	sp,sp,-160
    411e:	ed06                	sd	ra,152(sp)
    4120:	e922                	sd	s0,144(sp)
    4122:	e526                	sd	s1,136(sp)
    4124:	e14a                	sd	s2,128(sp)
    4126:	fcce                	sd	s3,120(sp)
    4128:	f8d2                	sd	s4,112(sp)
    412a:	f4d6                	sd	s5,104(sp)
    412c:	f0da                	sd	s6,96(sp)
    412e:	ecde                	sd	s7,88(sp)
    4130:	1100                	addi	s0,sp,160
    4132:	89aa                	mv	s3,a0
  file[0] = 'C';
    4134:	04300793          	li	a5,67
    4138:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    413c:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4140:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4142:	4b0d                	li	s6,3
    4144:	4a85                	li	s5,1
      link("C0", file);
    4146:	00004b97          	auipc	s7,0x4
    414a:	e7ab8b93          	addi	s7,s7,-390 # 7fc0 <csem_free+0x1eac>
  for(i = 0; i < N; i++){
    414e:	02800a13          	li	s4,40
    4152:	acc1                	j	4422 <concreate+0x306>
      link("C0", file);
    4154:	fa840593          	addi	a1,s0,-88
    4158:	855e                	mv	a0,s7
    415a:	00002097          	auipc	ra,0x2
    415e:	9b2080e7          	jalr	-1614(ra) # 5b0c <link>
    if(pid == 0) {
    4162:	a45d                	j	4408 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4164:	4795                	li	a5,5
    4166:	02f9693b          	remw	s2,s2,a5
    416a:	4785                	li	a5,1
    416c:	02f90b63          	beq	s2,a5,41a2 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4170:	20200593          	li	a1,514
    4174:	fa840513          	addi	a0,s0,-88
    4178:	00002097          	auipc	ra,0x2
    417c:	974080e7          	jalr	-1676(ra) # 5aec <open>
      if(fd < 0){
    4180:	26055b63          	bgez	a0,43f6 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4184:	fa840593          	addi	a1,s0,-88
    4188:	00004517          	auipc	a0,0x4
    418c:	e4050513          	addi	a0,a0,-448 # 7fc8 <csem_free+0x1eb4>
    4190:	00002097          	auipc	ra,0x2
    4194:	cee080e7          	jalr	-786(ra) # 5e7e <printf>
        exit(1);
    4198:	4505                	li	a0,1
    419a:	00002097          	auipc	ra,0x2
    419e:	912080e7          	jalr	-1774(ra) # 5aac <exit>
      link("C0", file);
    41a2:	fa840593          	addi	a1,s0,-88
    41a6:	00004517          	auipc	a0,0x4
    41aa:	e1a50513          	addi	a0,a0,-486 # 7fc0 <csem_free+0x1eac>
    41ae:	00002097          	auipc	ra,0x2
    41b2:	95e080e7          	jalr	-1698(ra) # 5b0c <link>
      exit(0);
    41b6:	4501                	li	a0,0
    41b8:	00002097          	auipc	ra,0x2
    41bc:	8f4080e7          	jalr	-1804(ra) # 5aac <exit>
        exit(1);
    41c0:	4505                	li	a0,1
    41c2:	00002097          	auipc	ra,0x2
    41c6:	8ea080e7          	jalr	-1814(ra) # 5aac <exit>
  memset(fa, 0, sizeof(fa));
    41ca:	02800613          	li	a2,40
    41ce:	4581                	li	a1,0
    41d0:	f8040513          	addi	a0,s0,-128
    41d4:	00001097          	auipc	ra,0x1
    41d8:	6dc080e7          	jalr	1756(ra) # 58b0 <memset>
  fd = open(".", 0);
    41dc:	4581                	li	a1,0
    41de:	00003517          	auipc	a0,0x3
    41e2:	a1250513          	addi	a0,a0,-1518 # 6bf0 <csem_free+0xadc>
    41e6:	00002097          	auipc	ra,0x2
    41ea:	906080e7          	jalr	-1786(ra) # 5aec <open>
    41ee:	892a                	mv	s2,a0
  n = 0;
    41f0:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    41f2:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    41f6:	02700b13          	li	s6,39
      fa[i] = 1;
    41fa:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    41fc:	4641                	li	a2,16
    41fe:	f7040593          	addi	a1,s0,-144
    4202:	854a                	mv	a0,s2
    4204:	00002097          	auipc	ra,0x2
    4208:	8c0080e7          	jalr	-1856(ra) # 5ac4 <read>
    420c:	08a05163          	blez	a0,428e <concreate+0x172>
    if(de.inum == 0)
    4210:	f7045783          	lhu	a5,-144(s0)
    4214:	d7e5                	beqz	a5,41fc <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4216:	f7244783          	lbu	a5,-142(s0)
    421a:	ff4791e3          	bne	a5,s4,41fc <concreate+0xe0>
    421e:	f7444783          	lbu	a5,-140(s0)
    4222:	ffe9                	bnez	a5,41fc <concreate+0xe0>
      i = de.name[1] - '0';
    4224:	f7344783          	lbu	a5,-141(s0)
    4228:	fd07879b          	addiw	a5,a5,-48
    422c:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4230:	00eb6f63          	bltu	s6,a4,424e <concreate+0x132>
      if(fa[i]){
    4234:	fb040793          	addi	a5,s0,-80
    4238:	97ba                	add	a5,a5,a4
    423a:	fd07c783          	lbu	a5,-48(a5)
    423e:	eb85                	bnez	a5,426e <concreate+0x152>
      fa[i] = 1;
    4240:	fb040793          	addi	a5,s0,-80
    4244:	973e                	add	a4,a4,a5
    4246:	fd770823          	sb	s7,-48(a4)
      n++;
    424a:	2a85                	addiw	s5,s5,1
    424c:	bf45                	j	41fc <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    424e:	f7240613          	addi	a2,s0,-142
    4252:	85ce                	mv	a1,s3
    4254:	00004517          	auipc	a0,0x4
    4258:	d9450513          	addi	a0,a0,-620 # 7fe8 <csem_free+0x1ed4>
    425c:	00002097          	auipc	ra,0x2
    4260:	c22080e7          	jalr	-990(ra) # 5e7e <printf>
        exit(1);
    4264:	4505                	li	a0,1
    4266:	00002097          	auipc	ra,0x2
    426a:	846080e7          	jalr	-1978(ra) # 5aac <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    426e:	f7240613          	addi	a2,s0,-142
    4272:	85ce                	mv	a1,s3
    4274:	00004517          	auipc	a0,0x4
    4278:	d9450513          	addi	a0,a0,-620 # 8008 <csem_free+0x1ef4>
    427c:	00002097          	auipc	ra,0x2
    4280:	c02080e7          	jalr	-1022(ra) # 5e7e <printf>
        exit(1);
    4284:	4505                	li	a0,1
    4286:	00002097          	auipc	ra,0x2
    428a:	826080e7          	jalr	-2010(ra) # 5aac <exit>
  close(fd);
    428e:	854a                	mv	a0,s2
    4290:	00002097          	auipc	ra,0x2
    4294:	844080e7          	jalr	-1980(ra) # 5ad4 <close>
  if(n != N){
    4298:	02800793          	li	a5,40
    429c:	00fa9763          	bne	s5,a5,42aa <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    42a0:	4a8d                	li	s5,3
    42a2:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    42a4:	02800a13          	li	s4,40
    42a8:	a8c9                	j	437a <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    42aa:	85ce                	mv	a1,s3
    42ac:	00004517          	auipc	a0,0x4
    42b0:	d8450513          	addi	a0,a0,-636 # 8030 <csem_free+0x1f1c>
    42b4:	00002097          	auipc	ra,0x2
    42b8:	bca080e7          	jalr	-1078(ra) # 5e7e <printf>
    exit(1);
    42bc:	4505                	li	a0,1
    42be:	00001097          	auipc	ra,0x1
    42c2:	7ee080e7          	jalr	2030(ra) # 5aac <exit>
      printf("%s: fork failed\n", s);
    42c6:	85ce                	mv	a1,s3
    42c8:	00002517          	auipc	a0,0x2
    42cc:	18050513          	addi	a0,a0,384 # 6448 <csem_free+0x334>
    42d0:	00002097          	auipc	ra,0x2
    42d4:	bae080e7          	jalr	-1106(ra) # 5e7e <printf>
      exit(1);
    42d8:	4505                	li	a0,1
    42da:	00001097          	auipc	ra,0x1
    42de:	7d2080e7          	jalr	2002(ra) # 5aac <exit>
      close(open(file, 0));
    42e2:	4581                	li	a1,0
    42e4:	fa840513          	addi	a0,s0,-88
    42e8:	00002097          	auipc	ra,0x2
    42ec:	804080e7          	jalr	-2044(ra) # 5aec <open>
    42f0:	00001097          	auipc	ra,0x1
    42f4:	7e4080e7          	jalr	2020(ra) # 5ad4 <close>
      close(open(file, 0));
    42f8:	4581                	li	a1,0
    42fa:	fa840513          	addi	a0,s0,-88
    42fe:	00001097          	auipc	ra,0x1
    4302:	7ee080e7          	jalr	2030(ra) # 5aec <open>
    4306:	00001097          	auipc	ra,0x1
    430a:	7ce080e7          	jalr	1998(ra) # 5ad4 <close>
      close(open(file, 0));
    430e:	4581                	li	a1,0
    4310:	fa840513          	addi	a0,s0,-88
    4314:	00001097          	auipc	ra,0x1
    4318:	7d8080e7          	jalr	2008(ra) # 5aec <open>
    431c:	00001097          	auipc	ra,0x1
    4320:	7b8080e7          	jalr	1976(ra) # 5ad4 <close>
      close(open(file, 0));
    4324:	4581                	li	a1,0
    4326:	fa840513          	addi	a0,s0,-88
    432a:	00001097          	auipc	ra,0x1
    432e:	7c2080e7          	jalr	1986(ra) # 5aec <open>
    4332:	00001097          	auipc	ra,0x1
    4336:	7a2080e7          	jalr	1954(ra) # 5ad4 <close>
      close(open(file, 0));
    433a:	4581                	li	a1,0
    433c:	fa840513          	addi	a0,s0,-88
    4340:	00001097          	auipc	ra,0x1
    4344:	7ac080e7          	jalr	1964(ra) # 5aec <open>
    4348:	00001097          	auipc	ra,0x1
    434c:	78c080e7          	jalr	1932(ra) # 5ad4 <close>
      close(open(file, 0));
    4350:	4581                	li	a1,0
    4352:	fa840513          	addi	a0,s0,-88
    4356:	00001097          	auipc	ra,0x1
    435a:	796080e7          	jalr	1942(ra) # 5aec <open>
    435e:	00001097          	auipc	ra,0x1
    4362:	776080e7          	jalr	1910(ra) # 5ad4 <close>
    if(pid == 0)
    4366:	08090363          	beqz	s2,43ec <concreate+0x2d0>
      wait(0);
    436a:	4501                	li	a0,0
    436c:	00001097          	auipc	ra,0x1
    4370:	748080e7          	jalr	1864(ra) # 5ab4 <wait>
  for(i = 0; i < N; i++){
    4374:	2485                	addiw	s1,s1,1
    4376:	0f448563          	beq	s1,s4,4460 <concreate+0x344>
    file[1] = '0' + i;
    437a:	0304879b          	addiw	a5,s1,48
    437e:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4382:	00001097          	auipc	ra,0x1
    4386:	722080e7          	jalr	1826(ra) # 5aa4 <fork>
    438a:	892a                	mv	s2,a0
    if(pid < 0){
    438c:	f2054de3          	bltz	a0,42c6 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4390:	0354e73b          	remw	a4,s1,s5
    4394:	00a767b3          	or	a5,a4,a0
    4398:	2781                	sext.w	a5,a5
    439a:	d7a1                	beqz	a5,42e2 <concreate+0x1c6>
    439c:	01671363          	bne	a4,s6,43a2 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    43a0:	f129                	bnez	a0,42e2 <concreate+0x1c6>
      unlink(file);
    43a2:	fa840513          	addi	a0,s0,-88
    43a6:	00001097          	auipc	ra,0x1
    43aa:	756080e7          	jalr	1878(ra) # 5afc <unlink>
      unlink(file);
    43ae:	fa840513          	addi	a0,s0,-88
    43b2:	00001097          	auipc	ra,0x1
    43b6:	74a080e7          	jalr	1866(ra) # 5afc <unlink>
      unlink(file);
    43ba:	fa840513          	addi	a0,s0,-88
    43be:	00001097          	auipc	ra,0x1
    43c2:	73e080e7          	jalr	1854(ra) # 5afc <unlink>
      unlink(file);
    43c6:	fa840513          	addi	a0,s0,-88
    43ca:	00001097          	auipc	ra,0x1
    43ce:	732080e7          	jalr	1842(ra) # 5afc <unlink>
      unlink(file);
    43d2:	fa840513          	addi	a0,s0,-88
    43d6:	00001097          	auipc	ra,0x1
    43da:	726080e7          	jalr	1830(ra) # 5afc <unlink>
      unlink(file);
    43de:	fa840513          	addi	a0,s0,-88
    43e2:	00001097          	auipc	ra,0x1
    43e6:	71a080e7          	jalr	1818(ra) # 5afc <unlink>
    43ea:	bfb5                	j	4366 <concreate+0x24a>
      exit(0);
    43ec:	4501                	li	a0,0
    43ee:	00001097          	auipc	ra,0x1
    43f2:	6be080e7          	jalr	1726(ra) # 5aac <exit>
      close(fd);
    43f6:	00001097          	auipc	ra,0x1
    43fa:	6de080e7          	jalr	1758(ra) # 5ad4 <close>
    if(pid == 0) {
    43fe:	bb65                	j	41b6 <concreate+0x9a>
      close(fd);
    4400:	00001097          	auipc	ra,0x1
    4404:	6d4080e7          	jalr	1748(ra) # 5ad4 <close>
      wait(&xstatus);
    4408:	f6c40513          	addi	a0,s0,-148
    440c:	00001097          	auipc	ra,0x1
    4410:	6a8080e7          	jalr	1704(ra) # 5ab4 <wait>
      if(xstatus != 0)
    4414:	f6c42483          	lw	s1,-148(s0)
    4418:	da0494e3          	bnez	s1,41c0 <concreate+0xa4>
  for(i = 0; i < N; i++){
    441c:	2905                	addiw	s2,s2,1
    441e:	db4906e3          	beq	s2,s4,41ca <concreate+0xae>
    file[1] = '0' + i;
    4422:	0309079b          	addiw	a5,s2,48
    4426:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    442a:	fa840513          	addi	a0,s0,-88
    442e:	00001097          	auipc	ra,0x1
    4432:	6ce080e7          	jalr	1742(ra) # 5afc <unlink>
    pid = fork();
    4436:	00001097          	auipc	ra,0x1
    443a:	66e080e7          	jalr	1646(ra) # 5aa4 <fork>
    if(pid && (i % 3) == 1){
    443e:	d20503e3          	beqz	a0,4164 <concreate+0x48>
    4442:	036967bb          	remw	a5,s2,s6
    4446:	d15787e3          	beq	a5,s5,4154 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    444a:	20200593          	li	a1,514
    444e:	fa840513          	addi	a0,s0,-88
    4452:	00001097          	auipc	ra,0x1
    4456:	69a080e7          	jalr	1690(ra) # 5aec <open>
      if(fd < 0){
    445a:	fa0553e3          	bgez	a0,4400 <concreate+0x2e4>
    445e:	b31d                	j	4184 <concreate+0x68>
}
    4460:	60ea                	ld	ra,152(sp)
    4462:	644a                	ld	s0,144(sp)
    4464:	64aa                	ld	s1,136(sp)
    4466:	690a                	ld	s2,128(sp)
    4468:	79e6                	ld	s3,120(sp)
    446a:	7a46                	ld	s4,112(sp)
    446c:	7aa6                	ld	s5,104(sp)
    446e:	7b06                	ld	s6,96(sp)
    4470:	6be6                	ld	s7,88(sp)
    4472:	610d                	addi	sp,sp,160
    4474:	8082                	ret

0000000000004476 <linkunlink>:
{
    4476:	711d                	addi	sp,sp,-96
    4478:	ec86                	sd	ra,88(sp)
    447a:	e8a2                	sd	s0,80(sp)
    447c:	e4a6                	sd	s1,72(sp)
    447e:	e0ca                	sd	s2,64(sp)
    4480:	fc4e                	sd	s3,56(sp)
    4482:	f852                	sd	s4,48(sp)
    4484:	f456                	sd	s5,40(sp)
    4486:	f05a                	sd	s6,32(sp)
    4488:	ec5e                	sd	s7,24(sp)
    448a:	e862                	sd	s8,16(sp)
    448c:	e466                	sd	s9,8(sp)
    448e:	1080                	addi	s0,sp,96
    4490:	84aa                	mv	s1,a0
  unlink("x");
    4492:	00002517          	auipc	a0,0x2
    4496:	23650513          	addi	a0,a0,566 # 66c8 <csem_free+0x5b4>
    449a:	00001097          	auipc	ra,0x1
    449e:	662080e7          	jalr	1634(ra) # 5afc <unlink>
  pid = fork();
    44a2:	00001097          	auipc	ra,0x1
    44a6:	602080e7          	jalr	1538(ra) # 5aa4 <fork>
  if(pid < 0){
    44aa:	02054b63          	bltz	a0,44e0 <linkunlink+0x6a>
    44ae:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    44b0:	4c85                	li	s9,1
    44b2:	e119                	bnez	a0,44b8 <linkunlink+0x42>
    44b4:	06100c93          	li	s9,97
    44b8:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    44bc:	41c659b7          	lui	s3,0x41c65
    44c0:	e6d9899b          	addiw	s3,s3,-403
    44c4:	690d                	lui	s2,0x3
    44c6:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    44ca:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    44cc:	4b05                	li	s6,1
      unlink("x");
    44ce:	00002a97          	auipc	s5,0x2
    44d2:	1faa8a93          	addi	s5,s5,506 # 66c8 <csem_free+0x5b4>
      link("cat", "x");
    44d6:	00004b97          	auipc	s7,0x4
    44da:	b92b8b93          	addi	s7,s7,-1134 # 8068 <csem_free+0x1f54>
    44de:	a825                	j	4516 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    44e0:	85a6                	mv	a1,s1
    44e2:	00002517          	auipc	a0,0x2
    44e6:	f6650513          	addi	a0,a0,-154 # 6448 <csem_free+0x334>
    44ea:	00002097          	auipc	ra,0x2
    44ee:	994080e7          	jalr	-1644(ra) # 5e7e <printf>
    exit(1);
    44f2:	4505                	li	a0,1
    44f4:	00001097          	auipc	ra,0x1
    44f8:	5b8080e7          	jalr	1464(ra) # 5aac <exit>
      close(open("x", O_RDWR | O_CREATE));
    44fc:	20200593          	li	a1,514
    4500:	8556                	mv	a0,s5
    4502:	00001097          	auipc	ra,0x1
    4506:	5ea080e7          	jalr	1514(ra) # 5aec <open>
    450a:	00001097          	auipc	ra,0x1
    450e:	5ca080e7          	jalr	1482(ra) # 5ad4 <close>
  for(i = 0; i < 100; i++){
    4512:	34fd                	addiw	s1,s1,-1
    4514:	c88d                	beqz	s1,4546 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    4516:	033c87bb          	mulw	a5,s9,s3
    451a:	012787bb          	addw	a5,a5,s2
    451e:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    4522:	0347f7bb          	remuw	a5,a5,s4
    4526:	dbf9                	beqz	a5,44fc <linkunlink+0x86>
    } else if((x % 3) == 1){
    4528:	01678863          	beq	a5,s6,4538 <linkunlink+0xc2>
      unlink("x");
    452c:	8556                	mv	a0,s5
    452e:	00001097          	auipc	ra,0x1
    4532:	5ce080e7          	jalr	1486(ra) # 5afc <unlink>
    4536:	bff1                	j	4512 <linkunlink+0x9c>
      link("cat", "x");
    4538:	85d6                	mv	a1,s5
    453a:	855e                	mv	a0,s7
    453c:	00001097          	auipc	ra,0x1
    4540:	5d0080e7          	jalr	1488(ra) # 5b0c <link>
    4544:	b7f9                	j	4512 <linkunlink+0x9c>
  if(pid)
    4546:	020c0463          	beqz	s8,456e <linkunlink+0xf8>
    wait(0);
    454a:	4501                	li	a0,0
    454c:	00001097          	auipc	ra,0x1
    4550:	568080e7          	jalr	1384(ra) # 5ab4 <wait>
}
    4554:	60e6                	ld	ra,88(sp)
    4556:	6446                	ld	s0,80(sp)
    4558:	64a6                	ld	s1,72(sp)
    455a:	6906                	ld	s2,64(sp)
    455c:	79e2                	ld	s3,56(sp)
    455e:	7a42                	ld	s4,48(sp)
    4560:	7aa2                	ld	s5,40(sp)
    4562:	7b02                	ld	s6,32(sp)
    4564:	6be2                	ld	s7,24(sp)
    4566:	6c42                	ld	s8,16(sp)
    4568:	6ca2                	ld	s9,8(sp)
    456a:	6125                	addi	sp,sp,96
    456c:	8082                	ret
    exit(0);
    456e:	4501                	li	a0,0
    4570:	00001097          	auipc	ra,0x1
    4574:	53c080e7          	jalr	1340(ra) # 5aac <exit>

0000000000004578 <bigdir>:
{
    4578:	715d                	addi	sp,sp,-80
    457a:	e486                	sd	ra,72(sp)
    457c:	e0a2                	sd	s0,64(sp)
    457e:	fc26                	sd	s1,56(sp)
    4580:	f84a                	sd	s2,48(sp)
    4582:	f44e                	sd	s3,40(sp)
    4584:	f052                	sd	s4,32(sp)
    4586:	ec56                	sd	s5,24(sp)
    4588:	e85a                	sd	s6,16(sp)
    458a:	0880                	addi	s0,sp,80
    458c:	89aa                	mv	s3,a0
  unlink("bd");
    458e:	00004517          	auipc	a0,0x4
    4592:	ae250513          	addi	a0,a0,-1310 # 8070 <csem_free+0x1f5c>
    4596:	00001097          	auipc	ra,0x1
    459a:	566080e7          	jalr	1382(ra) # 5afc <unlink>
  fd = open("bd", O_CREATE);
    459e:	20000593          	li	a1,512
    45a2:	00004517          	auipc	a0,0x4
    45a6:	ace50513          	addi	a0,a0,-1330 # 8070 <csem_free+0x1f5c>
    45aa:	00001097          	auipc	ra,0x1
    45ae:	542080e7          	jalr	1346(ra) # 5aec <open>
  if(fd < 0){
    45b2:	0c054963          	bltz	a0,4684 <bigdir+0x10c>
  close(fd);
    45b6:	00001097          	auipc	ra,0x1
    45ba:	51e080e7          	jalr	1310(ra) # 5ad4 <close>
  for(i = 0; i < N; i++){
    45be:	4901                	li	s2,0
    name[0] = 'x';
    45c0:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    45c4:	00004a17          	auipc	s4,0x4
    45c8:	aaca0a13          	addi	s4,s4,-1364 # 8070 <csem_free+0x1f5c>
  for(i = 0; i < N; i++){
    45cc:	1f400b13          	li	s6,500
    name[0] = 'x';
    45d0:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    45d4:	41f9579b          	sraiw	a5,s2,0x1f
    45d8:	01a7d71b          	srliw	a4,a5,0x1a
    45dc:	012707bb          	addw	a5,a4,s2
    45e0:	4067d69b          	sraiw	a3,a5,0x6
    45e4:	0306869b          	addiw	a3,a3,48
    45e8:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    45ec:	03f7f793          	andi	a5,a5,63
    45f0:	9f99                	subw	a5,a5,a4
    45f2:	0307879b          	addiw	a5,a5,48
    45f6:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    45fa:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    45fe:	fb040593          	addi	a1,s0,-80
    4602:	8552                	mv	a0,s4
    4604:	00001097          	auipc	ra,0x1
    4608:	508080e7          	jalr	1288(ra) # 5b0c <link>
    460c:	84aa                	mv	s1,a0
    460e:	e949                	bnez	a0,46a0 <bigdir+0x128>
  for(i = 0; i < N; i++){
    4610:	2905                	addiw	s2,s2,1
    4612:	fb691fe3          	bne	s2,s6,45d0 <bigdir+0x58>
  unlink("bd");
    4616:	00004517          	auipc	a0,0x4
    461a:	a5a50513          	addi	a0,a0,-1446 # 8070 <csem_free+0x1f5c>
    461e:	00001097          	auipc	ra,0x1
    4622:	4de080e7          	jalr	1246(ra) # 5afc <unlink>
    name[0] = 'x';
    4626:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    462a:	1f400a13          	li	s4,500
    name[0] = 'x';
    462e:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    4632:	41f4d79b          	sraiw	a5,s1,0x1f
    4636:	01a7d71b          	srliw	a4,a5,0x1a
    463a:	009707bb          	addw	a5,a4,s1
    463e:	4067d69b          	sraiw	a3,a5,0x6
    4642:	0306869b          	addiw	a3,a3,48
    4646:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    464a:	03f7f793          	andi	a5,a5,63
    464e:	9f99                	subw	a5,a5,a4
    4650:	0307879b          	addiw	a5,a5,48
    4654:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    4658:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    465c:	fb040513          	addi	a0,s0,-80
    4660:	00001097          	auipc	ra,0x1
    4664:	49c080e7          	jalr	1180(ra) # 5afc <unlink>
    4668:	ed21                	bnez	a0,46c0 <bigdir+0x148>
  for(i = 0; i < N; i++){
    466a:	2485                	addiw	s1,s1,1
    466c:	fd4491e3          	bne	s1,s4,462e <bigdir+0xb6>
}
    4670:	60a6                	ld	ra,72(sp)
    4672:	6406                	ld	s0,64(sp)
    4674:	74e2                	ld	s1,56(sp)
    4676:	7942                	ld	s2,48(sp)
    4678:	79a2                	ld	s3,40(sp)
    467a:	7a02                	ld	s4,32(sp)
    467c:	6ae2                	ld	s5,24(sp)
    467e:	6b42                	ld	s6,16(sp)
    4680:	6161                	addi	sp,sp,80
    4682:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    4684:	85ce                	mv	a1,s3
    4686:	00004517          	auipc	a0,0x4
    468a:	9f250513          	addi	a0,a0,-1550 # 8078 <csem_free+0x1f64>
    468e:	00001097          	auipc	ra,0x1
    4692:	7f0080e7          	jalr	2032(ra) # 5e7e <printf>
    exit(1);
    4696:	4505                	li	a0,1
    4698:	00001097          	auipc	ra,0x1
    469c:	414080e7          	jalr	1044(ra) # 5aac <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    46a0:	fb040613          	addi	a2,s0,-80
    46a4:	85ce                	mv	a1,s3
    46a6:	00004517          	auipc	a0,0x4
    46aa:	9f250513          	addi	a0,a0,-1550 # 8098 <csem_free+0x1f84>
    46ae:	00001097          	auipc	ra,0x1
    46b2:	7d0080e7          	jalr	2000(ra) # 5e7e <printf>
      exit(1);
    46b6:	4505                	li	a0,1
    46b8:	00001097          	auipc	ra,0x1
    46bc:	3f4080e7          	jalr	1012(ra) # 5aac <exit>
      printf("%s: bigdir unlink failed", s);
    46c0:	85ce                	mv	a1,s3
    46c2:	00004517          	auipc	a0,0x4
    46c6:	9f650513          	addi	a0,a0,-1546 # 80b8 <csem_free+0x1fa4>
    46ca:	00001097          	auipc	ra,0x1
    46ce:	7b4080e7          	jalr	1972(ra) # 5e7e <printf>
      exit(1);
    46d2:	4505                	li	a0,1
    46d4:	00001097          	auipc	ra,0x1
    46d8:	3d8080e7          	jalr	984(ra) # 5aac <exit>

00000000000046dc <manywrites>:
{
    46dc:	711d                	addi	sp,sp,-96
    46de:	ec86                	sd	ra,88(sp)
    46e0:	e8a2                	sd	s0,80(sp)
    46e2:	e4a6                	sd	s1,72(sp)
    46e4:	e0ca                	sd	s2,64(sp)
    46e6:	fc4e                	sd	s3,56(sp)
    46e8:	f852                	sd	s4,48(sp)
    46ea:	f456                	sd	s5,40(sp)
    46ec:	f05a                	sd	s6,32(sp)
    46ee:	ec5e                	sd	s7,24(sp)
    46f0:	1080                	addi	s0,sp,96
    46f2:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    46f4:	4981                	li	s3,0
    46f6:	4911                	li	s2,4
    int pid = fork();
    46f8:	00001097          	auipc	ra,0x1
    46fc:	3ac080e7          	jalr	940(ra) # 5aa4 <fork>
    4700:	84aa                	mv	s1,a0
    if(pid < 0){
    4702:	02054963          	bltz	a0,4734 <manywrites+0x58>
    if(pid == 0){
    4706:	c521                	beqz	a0,474e <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    4708:	2985                	addiw	s3,s3,1
    470a:	ff2997e3          	bne	s3,s2,46f8 <manywrites+0x1c>
    470e:	4491                	li	s1,4
    int st = 0;
    4710:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    4714:	fa840513          	addi	a0,s0,-88
    4718:	00001097          	auipc	ra,0x1
    471c:	39c080e7          	jalr	924(ra) # 5ab4 <wait>
    if(st != 0)
    4720:	fa842503          	lw	a0,-88(s0)
    4724:	ed6d                	bnez	a0,481e <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    4726:	34fd                	addiw	s1,s1,-1
    4728:	f4e5                	bnez	s1,4710 <manywrites+0x34>
  exit(0);
    472a:	4501                	li	a0,0
    472c:	00001097          	auipc	ra,0x1
    4730:	380080e7          	jalr	896(ra) # 5aac <exit>
      printf("fork failed\n");
    4734:	00002517          	auipc	a0,0x2
    4738:	7a450513          	addi	a0,a0,1956 # 6ed8 <csem_free+0xdc4>
    473c:	00001097          	auipc	ra,0x1
    4740:	742080e7          	jalr	1858(ra) # 5e7e <printf>
      exit(1);
    4744:	4505                	li	a0,1
    4746:	00001097          	auipc	ra,0x1
    474a:	366080e7          	jalr	870(ra) # 5aac <exit>
      name[0] = 'b';
    474e:	06200793          	li	a5,98
    4752:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    4756:	0619879b          	addiw	a5,s3,97
    475a:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    475e:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    4762:	fa840513          	addi	a0,s0,-88
    4766:	00001097          	auipc	ra,0x1
    476a:	396080e7          	jalr	918(ra) # 5afc <unlink>
    476e:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    4770:	00008b17          	auipc	s6,0x8
    4774:	970b0b13          	addi	s6,s6,-1680 # c0e0 <buf>
        for(int i = 0; i < ci+1; i++){
    4778:	8a26                	mv	s4,s1
    477a:	0209ce63          	bltz	s3,47b6 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    477e:	20200593          	li	a1,514
    4782:	fa840513          	addi	a0,s0,-88
    4786:	00001097          	auipc	ra,0x1
    478a:	366080e7          	jalr	870(ra) # 5aec <open>
    478e:	892a                	mv	s2,a0
          if(fd < 0){
    4790:	04054763          	bltz	a0,47de <manywrites+0x102>
          int cc = write(fd, buf, sz);
    4794:	660d                	lui	a2,0x3
    4796:	85da                	mv	a1,s6
    4798:	00001097          	auipc	ra,0x1
    479c:	334080e7          	jalr	820(ra) # 5acc <write>
          if(cc != sz){
    47a0:	678d                	lui	a5,0x3
    47a2:	04f51e63          	bne	a0,a5,47fe <manywrites+0x122>
          close(fd);
    47a6:	854a                	mv	a0,s2
    47a8:	00001097          	auipc	ra,0x1
    47ac:	32c080e7          	jalr	812(ra) # 5ad4 <close>
        for(int i = 0; i < ci+1; i++){
    47b0:	2a05                	addiw	s4,s4,1
    47b2:	fd49d6e3          	bge	s3,s4,477e <manywrites+0xa2>
        unlink(name);
    47b6:	fa840513          	addi	a0,s0,-88
    47ba:	00001097          	auipc	ra,0x1
    47be:	342080e7          	jalr	834(ra) # 5afc <unlink>
      for(int iters = 0; iters < howmany; iters++){
    47c2:	3bfd                	addiw	s7,s7,-1
    47c4:	fa0b9ae3          	bnez	s7,4778 <manywrites+0x9c>
      unlink(name);
    47c8:	fa840513          	addi	a0,s0,-88
    47cc:	00001097          	auipc	ra,0x1
    47d0:	330080e7          	jalr	816(ra) # 5afc <unlink>
      exit(0);
    47d4:	4501                	li	a0,0
    47d6:	00001097          	auipc	ra,0x1
    47da:	2d6080e7          	jalr	726(ra) # 5aac <exit>
            printf("%s: cannot create %s\n", s, name);
    47de:	fa840613          	addi	a2,s0,-88
    47e2:	85d6                	mv	a1,s5
    47e4:	00004517          	auipc	a0,0x4
    47e8:	8f450513          	addi	a0,a0,-1804 # 80d8 <csem_free+0x1fc4>
    47ec:	00001097          	auipc	ra,0x1
    47f0:	692080e7          	jalr	1682(ra) # 5e7e <printf>
            exit(1);
    47f4:	4505                	li	a0,1
    47f6:	00001097          	auipc	ra,0x1
    47fa:	2b6080e7          	jalr	694(ra) # 5aac <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    47fe:	86aa                	mv	a3,a0
    4800:	660d                	lui	a2,0x3
    4802:	85d6                	mv	a1,s5
    4804:	00002517          	auipc	a0,0x2
    4808:	f2450513          	addi	a0,a0,-220 # 6728 <csem_free+0x614>
    480c:	00001097          	auipc	ra,0x1
    4810:	672080e7          	jalr	1650(ra) # 5e7e <printf>
            exit(1);
    4814:	4505                	li	a0,1
    4816:	00001097          	auipc	ra,0x1
    481a:	296080e7          	jalr	662(ra) # 5aac <exit>
      exit(st);
    481e:	00001097          	auipc	ra,0x1
    4822:	28e080e7          	jalr	654(ra) # 5aac <exit>

0000000000004826 <iref>:
{
    4826:	7139                	addi	sp,sp,-64
    4828:	fc06                	sd	ra,56(sp)
    482a:	f822                	sd	s0,48(sp)
    482c:	f426                	sd	s1,40(sp)
    482e:	f04a                	sd	s2,32(sp)
    4830:	ec4e                	sd	s3,24(sp)
    4832:	e852                	sd	s4,16(sp)
    4834:	e456                	sd	s5,8(sp)
    4836:	e05a                	sd	s6,0(sp)
    4838:	0080                	addi	s0,sp,64
    483a:	8b2a                	mv	s6,a0
    483c:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4840:	00004a17          	auipc	s4,0x4
    4844:	8b0a0a13          	addi	s4,s4,-1872 # 80f0 <csem_free+0x1fdc>
    mkdir("");
    4848:	00003497          	auipc	s1,0x3
    484c:	dd048493          	addi	s1,s1,-560 # 7618 <csem_free+0x1504>
    link("README", "");
    4850:	00002a97          	auipc	s5,0x2
    4854:	fb0a8a93          	addi	s5,s5,-80 # 6800 <csem_free+0x6ec>
    fd = open("xx", O_CREATE);
    4858:	00003997          	auipc	s3,0x3
    485c:	1a898993          	addi	s3,s3,424 # 7a00 <csem_free+0x18ec>
    4860:	a891                	j	48b4 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    4862:	85da                	mv	a1,s6
    4864:	00004517          	auipc	a0,0x4
    4868:	89450513          	addi	a0,a0,-1900 # 80f8 <csem_free+0x1fe4>
    486c:	00001097          	auipc	ra,0x1
    4870:	612080e7          	jalr	1554(ra) # 5e7e <printf>
      exit(1);
    4874:	4505                	li	a0,1
    4876:	00001097          	auipc	ra,0x1
    487a:	236080e7          	jalr	566(ra) # 5aac <exit>
      printf("%s: chdir irefd failed\n", s);
    487e:	85da                	mv	a1,s6
    4880:	00004517          	auipc	a0,0x4
    4884:	89050513          	addi	a0,a0,-1904 # 8110 <csem_free+0x1ffc>
    4888:	00001097          	auipc	ra,0x1
    488c:	5f6080e7          	jalr	1526(ra) # 5e7e <printf>
      exit(1);
    4890:	4505                	li	a0,1
    4892:	00001097          	auipc	ra,0x1
    4896:	21a080e7          	jalr	538(ra) # 5aac <exit>
      close(fd);
    489a:	00001097          	auipc	ra,0x1
    489e:	23a080e7          	jalr	570(ra) # 5ad4 <close>
    48a2:	a889                	j	48f4 <iref+0xce>
    unlink("xx");
    48a4:	854e                	mv	a0,s3
    48a6:	00001097          	auipc	ra,0x1
    48aa:	256080e7          	jalr	598(ra) # 5afc <unlink>
  for(i = 0; i < NINODE + 1; i++){
    48ae:	397d                	addiw	s2,s2,-1
    48b0:	06090063          	beqz	s2,4910 <iref+0xea>
    if(mkdir("irefd") != 0){
    48b4:	8552                	mv	a0,s4
    48b6:	00001097          	auipc	ra,0x1
    48ba:	25e080e7          	jalr	606(ra) # 5b14 <mkdir>
    48be:	f155                	bnez	a0,4862 <iref+0x3c>
    if(chdir("irefd") != 0){
    48c0:	8552                	mv	a0,s4
    48c2:	00001097          	auipc	ra,0x1
    48c6:	25a080e7          	jalr	602(ra) # 5b1c <chdir>
    48ca:	f955                	bnez	a0,487e <iref+0x58>
    mkdir("");
    48cc:	8526                	mv	a0,s1
    48ce:	00001097          	auipc	ra,0x1
    48d2:	246080e7          	jalr	582(ra) # 5b14 <mkdir>
    link("README", "");
    48d6:	85a6                	mv	a1,s1
    48d8:	8556                	mv	a0,s5
    48da:	00001097          	auipc	ra,0x1
    48de:	232080e7          	jalr	562(ra) # 5b0c <link>
    fd = open("", O_CREATE);
    48e2:	20000593          	li	a1,512
    48e6:	8526                	mv	a0,s1
    48e8:	00001097          	auipc	ra,0x1
    48ec:	204080e7          	jalr	516(ra) # 5aec <open>
    if(fd >= 0)
    48f0:	fa0555e3          	bgez	a0,489a <iref+0x74>
    fd = open("xx", O_CREATE);
    48f4:	20000593          	li	a1,512
    48f8:	854e                	mv	a0,s3
    48fa:	00001097          	auipc	ra,0x1
    48fe:	1f2080e7          	jalr	498(ra) # 5aec <open>
    if(fd >= 0)
    4902:	fa0541e3          	bltz	a0,48a4 <iref+0x7e>
      close(fd);
    4906:	00001097          	auipc	ra,0x1
    490a:	1ce080e7          	jalr	462(ra) # 5ad4 <close>
    490e:	bf59                	j	48a4 <iref+0x7e>
    4910:	03300493          	li	s1,51
    chdir("..");
    4914:	00003997          	auipc	s3,0x3
    4918:	a2498993          	addi	s3,s3,-1500 # 7338 <csem_free+0x1224>
    unlink("irefd");
    491c:	00003917          	auipc	s2,0x3
    4920:	7d490913          	addi	s2,s2,2004 # 80f0 <csem_free+0x1fdc>
    chdir("..");
    4924:	854e                	mv	a0,s3
    4926:	00001097          	auipc	ra,0x1
    492a:	1f6080e7          	jalr	502(ra) # 5b1c <chdir>
    unlink("irefd");
    492e:	854a                	mv	a0,s2
    4930:	00001097          	auipc	ra,0x1
    4934:	1cc080e7          	jalr	460(ra) # 5afc <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4938:	34fd                	addiw	s1,s1,-1
    493a:	f4ed                	bnez	s1,4924 <iref+0xfe>
  chdir("/");
    493c:	00003517          	auipc	a0,0x3
    4940:	9a450513          	addi	a0,a0,-1628 # 72e0 <csem_free+0x11cc>
    4944:	00001097          	auipc	ra,0x1
    4948:	1d8080e7          	jalr	472(ra) # 5b1c <chdir>
}
    494c:	70e2                	ld	ra,56(sp)
    494e:	7442                	ld	s0,48(sp)
    4950:	74a2                	ld	s1,40(sp)
    4952:	7902                	ld	s2,32(sp)
    4954:	69e2                	ld	s3,24(sp)
    4956:	6a42                	ld	s4,16(sp)
    4958:	6aa2                	ld	s5,8(sp)
    495a:	6b02                	ld	s6,0(sp)
    495c:	6121                	addi	sp,sp,64
    495e:	8082                	ret

0000000000004960 <sbrkbasic>:
{
    4960:	7139                	addi	sp,sp,-64
    4962:	fc06                	sd	ra,56(sp)
    4964:	f822                	sd	s0,48(sp)
    4966:	f426                	sd	s1,40(sp)
    4968:	f04a                	sd	s2,32(sp)
    496a:	ec4e                	sd	s3,24(sp)
    496c:	e852                	sd	s4,16(sp)
    496e:	0080                	addi	s0,sp,64
    4970:	8a2a                	mv	s4,a0
  pid = fork();
    4972:	00001097          	auipc	ra,0x1
    4976:	132080e7          	jalr	306(ra) # 5aa4 <fork>
  if(pid < 0){
    497a:	02054c63          	bltz	a0,49b2 <sbrkbasic+0x52>
  if(pid == 0){
    497e:	ed21                	bnez	a0,49d6 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    4980:	40000537          	lui	a0,0x40000
    4984:	00001097          	auipc	ra,0x1
    4988:	1b0080e7          	jalr	432(ra) # 5b34 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    498c:	57fd                	li	a5,-1
    498e:	02f50f63          	beq	a0,a5,49cc <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    4992:	400007b7          	lui	a5,0x40000
    4996:	97aa                	add	a5,a5,a0
      *b = 99;
    4998:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    499c:	6705                	lui	a4,0x1
      *b = 99;
    499e:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff0f10>
    for(b = a; b < a+TOOMUCH; b += 4096){
    49a2:	953a                	add	a0,a0,a4
    49a4:	fef51de3          	bne	a0,a5,499e <sbrkbasic+0x3e>
    exit(1);
    49a8:	4505                	li	a0,1
    49aa:	00001097          	auipc	ra,0x1
    49ae:	102080e7          	jalr	258(ra) # 5aac <exit>
    printf("fork failed in sbrkbasic\n");
    49b2:	00003517          	auipc	a0,0x3
    49b6:	77650513          	addi	a0,a0,1910 # 8128 <csem_free+0x2014>
    49ba:	00001097          	auipc	ra,0x1
    49be:	4c4080e7          	jalr	1220(ra) # 5e7e <printf>
    exit(1);
    49c2:	4505                	li	a0,1
    49c4:	00001097          	auipc	ra,0x1
    49c8:	0e8080e7          	jalr	232(ra) # 5aac <exit>
      exit(0);
    49cc:	4501                	li	a0,0
    49ce:	00001097          	auipc	ra,0x1
    49d2:	0de080e7          	jalr	222(ra) # 5aac <exit>
  wait(&xstatus);
    49d6:	fcc40513          	addi	a0,s0,-52
    49da:	00001097          	auipc	ra,0x1
    49de:	0da080e7          	jalr	218(ra) # 5ab4 <wait>
  if(xstatus == 1){
    49e2:	fcc42703          	lw	a4,-52(s0)
    49e6:	4785                	li	a5,1
    49e8:	00f70d63          	beq	a4,a5,4a02 <sbrkbasic+0xa2>
  a = sbrk(0);
    49ec:	4501                	li	a0,0
    49ee:	00001097          	auipc	ra,0x1
    49f2:	146080e7          	jalr	326(ra) # 5b34 <sbrk>
    49f6:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    49f8:	4901                	li	s2,0
    49fa:	6985                	lui	s3,0x1
    49fc:	38898993          	addi	s3,s3,904 # 1388 <unlinkread+0x6c>
    4a00:	a005                	j	4a20 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    4a02:	85d2                	mv	a1,s4
    4a04:	00003517          	auipc	a0,0x3
    4a08:	74450513          	addi	a0,a0,1860 # 8148 <csem_free+0x2034>
    4a0c:	00001097          	auipc	ra,0x1
    4a10:	472080e7          	jalr	1138(ra) # 5e7e <printf>
    exit(1);
    4a14:	4505                	li	a0,1
    4a16:	00001097          	auipc	ra,0x1
    4a1a:	096080e7          	jalr	150(ra) # 5aac <exit>
    a = b + 1;
    4a1e:	84be                	mv	s1,a5
    b = sbrk(1);
    4a20:	4505                	li	a0,1
    4a22:	00001097          	auipc	ra,0x1
    4a26:	112080e7          	jalr	274(ra) # 5b34 <sbrk>
    if(b != a){
    4a2a:	04951c63          	bne	a0,s1,4a82 <sbrkbasic+0x122>
    *b = 1;
    4a2e:	4785                	li	a5,1
    4a30:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    4a34:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    4a38:	2905                	addiw	s2,s2,1
    4a3a:	ff3912e3          	bne	s2,s3,4a1e <sbrkbasic+0xbe>
  pid = fork();
    4a3e:	00001097          	auipc	ra,0x1
    4a42:	066080e7          	jalr	102(ra) # 5aa4 <fork>
    4a46:	892a                	mv	s2,a0
  if(pid < 0){
    4a48:	04054d63          	bltz	a0,4aa2 <sbrkbasic+0x142>
  c = sbrk(1);
    4a4c:	4505                	li	a0,1
    4a4e:	00001097          	auipc	ra,0x1
    4a52:	0e6080e7          	jalr	230(ra) # 5b34 <sbrk>
  c = sbrk(1);
    4a56:	4505                	li	a0,1
    4a58:	00001097          	auipc	ra,0x1
    4a5c:	0dc080e7          	jalr	220(ra) # 5b34 <sbrk>
  if(c != a + 1){
    4a60:	0489                	addi	s1,s1,2
    4a62:	04a48e63          	beq	s1,a0,4abe <sbrkbasic+0x15e>
    printf("%s: sbrk test failed post-fork\n", s);
    4a66:	85d2                	mv	a1,s4
    4a68:	00003517          	auipc	a0,0x3
    4a6c:	74050513          	addi	a0,a0,1856 # 81a8 <csem_free+0x2094>
    4a70:	00001097          	auipc	ra,0x1
    4a74:	40e080e7          	jalr	1038(ra) # 5e7e <printf>
    exit(1);
    4a78:	4505                	li	a0,1
    4a7a:	00001097          	auipc	ra,0x1
    4a7e:	032080e7          	jalr	50(ra) # 5aac <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    4a82:	86aa                	mv	a3,a0
    4a84:	8626                	mv	a2,s1
    4a86:	85ca                	mv	a1,s2
    4a88:	00003517          	auipc	a0,0x3
    4a8c:	6e050513          	addi	a0,a0,1760 # 8168 <csem_free+0x2054>
    4a90:	00001097          	auipc	ra,0x1
    4a94:	3ee080e7          	jalr	1006(ra) # 5e7e <printf>
      exit(1);
    4a98:	4505                	li	a0,1
    4a9a:	00001097          	auipc	ra,0x1
    4a9e:	012080e7          	jalr	18(ra) # 5aac <exit>
    printf("%s: sbrk test fork failed\n", s);
    4aa2:	85d2                	mv	a1,s4
    4aa4:	00003517          	auipc	a0,0x3
    4aa8:	6e450513          	addi	a0,a0,1764 # 8188 <csem_free+0x2074>
    4aac:	00001097          	auipc	ra,0x1
    4ab0:	3d2080e7          	jalr	978(ra) # 5e7e <printf>
    exit(1);
    4ab4:	4505                	li	a0,1
    4ab6:	00001097          	auipc	ra,0x1
    4aba:	ff6080e7          	jalr	-10(ra) # 5aac <exit>
  if(pid == 0)
    4abe:	00091763          	bnez	s2,4acc <sbrkbasic+0x16c>
    exit(0);
    4ac2:	4501                	li	a0,0
    4ac4:	00001097          	auipc	ra,0x1
    4ac8:	fe8080e7          	jalr	-24(ra) # 5aac <exit>
  wait(&xstatus);
    4acc:	fcc40513          	addi	a0,s0,-52
    4ad0:	00001097          	auipc	ra,0x1
    4ad4:	fe4080e7          	jalr	-28(ra) # 5ab4 <wait>
  exit(xstatus);
    4ad8:	fcc42503          	lw	a0,-52(s0)
    4adc:	00001097          	auipc	ra,0x1
    4ae0:	fd0080e7          	jalr	-48(ra) # 5aac <exit>

0000000000004ae4 <sbrkmuch>:
{
    4ae4:	7179                	addi	sp,sp,-48
    4ae6:	f406                	sd	ra,40(sp)
    4ae8:	f022                	sd	s0,32(sp)
    4aea:	ec26                	sd	s1,24(sp)
    4aec:	e84a                	sd	s2,16(sp)
    4aee:	e44e                	sd	s3,8(sp)
    4af0:	e052                	sd	s4,0(sp)
    4af2:	1800                	addi	s0,sp,48
    4af4:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    4af6:	4501                	li	a0,0
    4af8:	00001097          	auipc	ra,0x1
    4afc:	03c080e7          	jalr	60(ra) # 5b34 <sbrk>
    4b00:	892a                	mv	s2,a0
  a = sbrk(0);
    4b02:	4501                	li	a0,0
    4b04:	00001097          	auipc	ra,0x1
    4b08:	030080e7          	jalr	48(ra) # 5b34 <sbrk>
    4b0c:	84aa                	mv	s1,a0
  p = sbrk(amt);
    4b0e:	06400537          	lui	a0,0x6400
    4b12:	9d05                	subw	a0,a0,s1
    4b14:	00001097          	auipc	ra,0x1
    4b18:	020080e7          	jalr	32(ra) # 5b34 <sbrk>
  if (p != a) {
    4b1c:	0ca49863          	bne	s1,a0,4bec <sbrkmuch+0x108>
  char *eee = sbrk(0);
    4b20:	4501                	li	a0,0
    4b22:	00001097          	auipc	ra,0x1
    4b26:	012080e7          	jalr	18(ra) # 5b34 <sbrk>
    4b2a:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    4b2c:	00a4f963          	bgeu	s1,a0,4b3e <sbrkmuch+0x5a>
    *pp = 1;
    4b30:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    4b32:	6705                	lui	a4,0x1
    *pp = 1;
    4b34:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    4b38:	94ba                	add	s1,s1,a4
    4b3a:	fef4ede3          	bltu	s1,a5,4b34 <sbrkmuch+0x50>
  *lastaddr = 99;
    4b3e:	064007b7          	lui	a5,0x6400
    4b42:	06300713          	li	a4,99
    4b46:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f0f0f>
  a = sbrk(0);
    4b4a:	4501                	li	a0,0
    4b4c:	00001097          	auipc	ra,0x1
    4b50:	fe8080e7          	jalr	-24(ra) # 5b34 <sbrk>
    4b54:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    4b56:	757d                	lui	a0,0xfffff
    4b58:	00001097          	auipc	ra,0x1
    4b5c:	fdc080e7          	jalr	-36(ra) # 5b34 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    4b60:	57fd                	li	a5,-1
    4b62:	0af50363          	beq	a0,a5,4c08 <sbrkmuch+0x124>
  c = sbrk(0);
    4b66:	4501                	li	a0,0
    4b68:	00001097          	auipc	ra,0x1
    4b6c:	fcc080e7          	jalr	-52(ra) # 5b34 <sbrk>
  if(c != a - PGSIZE){
    4b70:	77fd                	lui	a5,0xfffff
    4b72:	97a6                	add	a5,a5,s1
    4b74:	0af51863          	bne	a0,a5,4c24 <sbrkmuch+0x140>
  a = sbrk(0);
    4b78:	4501                	li	a0,0
    4b7a:	00001097          	auipc	ra,0x1
    4b7e:	fba080e7          	jalr	-70(ra) # 5b34 <sbrk>
    4b82:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    4b84:	6505                	lui	a0,0x1
    4b86:	00001097          	auipc	ra,0x1
    4b8a:	fae080e7          	jalr	-82(ra) # 5b34 <sbrk>
    4b8e:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    4b90:	0aa49a63          	bne	s1,a0,4c44 <sbrkmuch+0x160>
    4b94:	4501                	li	a0,0
    4b96:	00001097          	auipc	ra,0x1
    4b9a:	f9e080e7          	jalr	-98(ra) # 5b34 <sbrk>
    4b9e:	6785                	lui	a5,0x1
    4ba0:	97a6                	add	a5,a5,s1
    4ba2:	0af51163          	bne	a0,a5,4c44 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    4ba6:	064007b7          	lui	a5,0x6400
    4baa:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f0f0f>
    4bae:	06300793          	li	a5,99
    4bb2:	0af70963          	beq	a4,a5,4c64 <sbrkmuch+0x180>
  a = sbrk(0);
    4bb6:	4501                	li	a0,0
    4bb8:	00001097          	auipc	ra,0x1
    4bbc:	f7c080e7          	jalr	-132(ra) # 5b34 <sbrk>
    4bc0:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    4bc2:	4501                	li	a0,0
    4bc4:	00001097          	auipc	ra,0x1
    4bc8:	f70080e7          	jalr	-144(ra) # 5b34 <sbrk>
    4bcc:	40a9053b          	subw	a0,s2,a0
    4bd0:	00001097          	auipc	ra,0x1
    4bd4:	f64080e7          	jalr	-156(ra) # 5b34 <sbrk>
  if(c != a){
    4bd8:	0aa49463          	bne	s1,a0,4c80 <sbrkmuch+0x19c>
}
    4bdc:	70a2                	ld	ra,40(sp)
    4bde:	7402                	ld	s0,32(sp)
    4be0:	64e2                	ld	s1,24(sp)
    4be2:	6942                	ld	s2,16(sp)
    4be4:	69a2                	ld	s3,8(sp)
    4be6:	6a02                	ld	s4,0(sp)
    4be8:	6145                	addi	sp,sp,48
    4bea:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    4bec:	85ce                	mv	a1,s3
    4bee:	00003517          	auipc	a0,0x3
    4bf2:	5da50513          	addi	a0,a0,1498 # 81c8 <csem_free+0x20b4>
    4bf6:	00001097          	auipc	ra,0x1
    4bfa:	288080e7          	jalr	648(ra) # 5e7e <printf>
    exit(1);
    4bfe:	4505                	li	a0,1
    4c00:	00001097          	auipc	ra,0x1
    4c04:	eac080e7          	jalr	-340(ra) # 5aac <exit>
    printf("%s: sbrk could not deallocate\n", s);
    4c08:	85ce                	mv	a1,s3
    4c0a:	00003517          	auipc	a0,0x3
    4c0e:	60650513          	addi	a0,a0,1542 # 8210 <csem_free+0x20fc>
    4c12:	00001097          	auipc	ra,0x1
    4c16:	26c080e7          	jalr	620(ra) # 5e7e <printf>
    exit(1);
    4c1a:	4505                	li	a0,1
    4c1c:	00001097          	auipc	ra,0x1
    4c20:	e90080e7          	jalr	-368(ra) # 5aac <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    4c24:	86aa                	mv	a3,a0
    4c26:	8626                	mv	a2,s1
    4c28:	85ce                	mv	a1,s3
    4c2a:	00003517          	auipc	a0,0x3
    4c2e:	60650513          	addi	a0,a0,1542 # 8230 <csem_free+0x211c>
    4c32:	00001097          	auipc	ra,0x1
    4c36:	24c080e7          	jalr	588(ra) # 5e7e <printf>
    exit(1);
    4c3a:	4505                	li	a0,1
    4c3c:	00001097          	auipc	ra,0x1
    4c40:	e70080e7          	jalr	-400(ra) # 5aac <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    4c44:	86d2                	mv	a3,s4
    4c46:	8626                	mv	a2,s1
    4c48:	85ce                	mv	a1,s3
    4c4a:	00003517          	auipc	a0,0x3
    4c4e:	62650513          	addi	a0,a0,1574 # 8270 <csem_free+0x215c>
    4c52:	00001097          	auipc	ra,0x1
    4c56:	22c080e7          	jalr	556(ra) # 5e7e <printf>
    exit(1);
    4c5a:	4505                	li	a0,1
    4c5c:	00001097          	auipc	ra,0x1
    4c60:	e50080e7          	jalr	-432(ra) # 5aac <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    4c64:	85ce                	mv	a1,s3
    4c66:	00003517          	auipc	a0,0x3
    4c6a:	63a50513          	addi	a0,a0,1594 # 82a0 <csem_free+0x218c>
    4c6e:	00001097          	auipc	ra,0x1
    4c72:	210080e7          	jalr	528(ra) # 5e7e <printf>
    exit(1);
    4c76:	4505                	li	a0,1
    4c78:	00001097          	auipc	ra,0x1
    4c7c:	e34080e7          	jalr	-460(ra) # 5aac <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    4c80:	86aa                	mv	a3,a0
    4c82:	8626                	mv	a2,s1
    4c84:	85ce                	mv	a1,s3
    4c86:	00003517          	auipc	a0,0x3
    4c8a:	65250513          	addi	a0,a0,1618 # 82d8 <csem_free+0x21c4>
    4c8e:	00001097          	auipc	ra,0x1
    4c92:	1f0080e7          	jalr	496(ra) # 5e7e <printf>
    exit(1);
    4c96:	4505                	li	a0,1
    4c98:	00001097          	auipc	ra,0x1
    4c9c:	e14080e7          	jalr	-492(ra) # 5aac <exit>

0000000000004ca0 <kernmem>:
{
    4ca0:	715d                	addi	sp,sp,-80
    4ca2:	e486                	sd	ra,72(sp)
    4ca4:	e0a2                	sd	s0,64(sp)
    4ca6:	fc26                	sd	s1,56(sp)
    4ca8:	f84a                	sd	s2,48(sp)
    4caa:	f44e                	sd	s3,40(sp)
    4cac:	f052                	sd	s4,32(sp)
    4cae:	ec56                	sd	s5,24(sp)
    4cb0:	0880                	addi	s0,sp,80
    4cb2:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    4cb4:	4485                	li	s1,1
    4cb6:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    4cb8:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    4cba:	69b1                	lui	s3,0xc
    4cbc:	35098993          	addi	s3,s3,848 # c350 <buf+0x270>
    4cc0:	1003d937          	lui	s2,0x1003d
    4cc4:	090e                	slli	s2,s2,0x3
    4cc6:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e390>
    pid = fork();
    4cca:	00001097          	auipc	ra,0x1
    4cce:	dda080e7          	jalr	-550(ra) # 5aa4 <fork>
    if(pid < 0){
    4cd2:	02054963          	bltz	a0,4d04 <kernmem+0x64>
    if(pid == 0){
    4cd6:	c529                	beqz	a0,4d20 <kernmem+0x80>
    wait(&xstatus);
    4cd8:	fbc40513          	addi	a0,s0,-68
    4cdc:	00001097          	auipc	ra,0x1
    4ce0:	dd8080e7          	jalr	-552(ra) # 5ab4 <wait>
    if(xstatus != -1)  // did kernel kill child?
    4ce4:	fbc42783          	lw	a5,-68(s0)
    4ce8:	05579d63          	bne	a5,s5,4d42 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    4cec:	94ce                	add	s1,s1,s3
    4cee:	fd249ee3          	bne	s1,s2,4cca <kernmem+0x2a>
}
    4cf2:	60a6                	ld	ra,72(sp)
    4cf4:	6406                	ld	s0,64(sp)
    4cf6:	74e2                	ld	s1,56(sp)
    4cf8:	7942                	ld	s2,48(sp)
    4cfa:	79a2                	ld	s3,40(sp)
    4cfc:	7a02                	ld	s4,32(sp)
    4cfe:	6ae2                	ld	s5,24(sp)
    4d00:	6161                	addi	sp,sp,80
    4d02:	8082                	ret
      printf("%s: fork failed\n", s);
    4d04:	85d2                	mv	a1,s4
    4d06:	00001517          	auipc	a0,0x1
    4d0a:	74250513          	addi	a0,a0,1858 # 6448 <csem_free+0x334>
    4d0e:	00001097          	auipc	ra,0x1
    4d12:	170080e7          	jalr	368(ra) # 5e7e <printf>
      exit(1);
    4d16:	4505                	li	a0,1
    4d18:	00001097          	auipc	ra,0x1
    4d1c:	d94080e7          	jalr	-620(ra) # 5aac <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    4d20:	0004c683          	lbu	a3,0(s1)
    4d24:	8626                	mv	a2,s1
    4d26:	85d2                	mv	a1,s4
    4d28:	00003517          	auipc	a0,0x3
    4d2c:	5d850513          	addi	a0,a0,1496 # 8300 <csem_free+0x21ec>
    4d30:	00001097          	auipc	ra,0x1
    4d34:	14e080e7          	jalr	334(ra) # 5e7e <printf>
      exit(1);
    4d38:	4505                	li	a0,1
    4d3a:	00001097          	auipc	ra,0x1
    4d3e:	d72080e7          	jalr	-654(ra) # 5aac <exit>
      exit(1);
    4d42:	4505                	li	a0,1
    4d44:	00001097          	auipc	ra,0x1
    4d48:	d68080e7          	jalr	-664(ra) # 5aac <exit>

0000000000004d4c <sbrkfail>:
{
    4d4c:	7119                	addi	sp,sp,-128
    4d4e:	fc86                	sd	ra,120(sp)
    4d50:	f8a2                	sd	s0,112(sp)
    4d52:	f4a6                	sd	s1,104(sp)
    4d54:	f0ca                	sd	s2,96(sp)
    4d56:	ecce                	sd	s3,88(sp)
    4d58:	e8d2                	sd	s4,80(sp)
    4d5a:	e4d6                	sd	s5,72(sp)
    4d5c:	0100                	addi	s0,sp,128
    4d5e:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    4d60:	fb040513          	addi	a0,s0,-80
    4d64:	00001097          	auipc	ra,0x1
    4d68:	d58080e7          	jalr	-680(ra) # 5abc <pipe>
    4d6c:	e901                	bnez	a0,4d7c <sbrkfail+0x30>
    4d6e:	f8040493          	addi	s1,s0,-128
    4d72:	fa840993          	addi	s3,s0,-88
    4d76:	8926                	mv	s2,s1
    if(pids[i] != -1)
    4d78:	5a7d                	li	s4,-1
    4d7a:	a085                	j	4dda <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4d7c:	85d6                	mv	a1,s5
    4d7e:	00002517          	auipc	a0,0x2
    4d82:	bc250513          	addi	a0,a0,-1086 # 6940 <csem_free+0x82c>
    4d86:	00001097          	auipc	ra,0x1
    4d8a:	0f8080e7          	jalr	248(ra) # 5e7e <printf>
    exit(1);
    4d8e:	4505                	li	a0,1
    4d90:	00001097          	auipc	ra,0x1
    4d94:	d1c080e7          	jalr	-740(ra) # 5aac <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4d98:	00001097          	auipc	ra,0x1
    4d9c:	d9c080e7          	jalr	-612(ra) # 5b34 <sbrk>
    4da0:	064007b7          	lui	a5,0x6400
    4da4:	40a7853b          	subw	a0,a5,a0
    4da8:	00001097          	auipc	ra,0x1
    4dac:	d8c080e7          	jalr	-628(ra) # 5b34 <sbrk>
      write(fds[1], "x", 1);
    4db0:	4605                	li	a2,1
    4db2:	00002597          	auipc	a1,0x2
    4db6:	91658593          	addi	a1,a1,-1770 # 66c8 <csem_free+0x5b4>
    4dba:	fb442503          	lw	a0,-76(s0)
    4dbe:	00001097          	auipc	ra,0x1
    4dc2:	d0e080e7          	jalr	-754(ra) # 5acc <write>
      for(;;) sleep(1000);
    4dc6:	3e800513          	li	a0,1000
    4dca:	00001097          	auipc	ra,0x1
    4dce:	d72080e7          	jalr	-654(ra) # 5b3c <sleep>
    4dd2:	bfd5                	j	4dc6 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4dd4:	0911                	addi	s2,s2,4
    4dd6:	03390563          	beq	s2,s3,4e00 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4dda:	00001097          	auipc	ra,0x1
    4dde:	cca080e7          	jalr	-822(ra) # 5aa4 <fork>
    4de2:	00a92023          	sw	a0,0(s2)
    4de6:	d94d                	beqz	a0,4d98 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4de8:	ff4506e3          	beq	a0,s4,4dd4 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4dec:	4605                	li	a2,1
    4dee:	faf40593          	addi	a1,s0,-81
    4df2:	fb042503          	lw	a0,-80(s0)
    4df6:	00001097          	auipc	ra,0x1
    4dfa:	cce080e7          	jalr	-818(ra) # 5ac4 <read>
    4dfe:	bfd9                	j	4dd4 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    4e00:	6505                	lui	a0,0x1
    4e02:	00001097          	auipc	ra,0x1
    4e06:	d32080e7          	jalr	-718(ra) # 5b34 <sbrk>
    4e0a:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4e0c:	597d                	li	s2,-1
    4e0e:	a021                	j	4e16 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4e10:	0491                	addi	s1,s1,4
    4e12:	03348063          	beq	s1,s3,4e32 <sbrkfail+0xe6>
    if(pids[i] == -1)
    4e16:	4088                	lw	a0,0(s1)
    4e18:	ff250ce3          	beq	a0,s2,4e10 <sbrkfail+0xc4>
    kill(pids[i], SIGKILL);
    4e1c:	45a5                	li	a1,9
    4e1e:	00001097          	auipc	ra,0x1
    4e22:	cbe080e7          	jalr	-834(ra) # 5adc <kill>
    wait(0);
    4e26:	4501                	li	a0,0
    4e28:	00001097          	auipc	ra,0x1
    4e2c:	c8c080e7          	jalr	-884(ra) # 5ab4 <wait>
    4e30:	b7c5                	j	4e10 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    4e32:	57fd                	li	a5,-1
    4e34:	04fa0163          	beq	s4,a5,4e76 <sbrkfail+0x12a>
  pid = fork();
    4e38:	00001097          	auipc	ra,0x1
    4e3c:	c6c080e7          	jalr	-916(ra) # 5aa4 <fork>
    4e40:	84aa                	mv	s1,a0
  if(pid < 0){
    4e42:	04054863          	bltz	a0,4e92 <sbrkfail+0x146>
  if(pid == 0){
    4e46:	c525                	beqz	a0,4eae <sbrkfail+0x162>
  wait(&xstatus);
    4e48:	fbc40513          	addi	a0,s0,-68
    4e4c:	00001097          	auipc	ra,0x1
    4e50:	c68080e7          	jalr	-920(ra) # 5ab4 <wait>
  if(xstatus != -1 && xstatus != 2)
    4e54:	fbc42783          	lw	a5,-68(s0)
    4e58:	577d                	li	a4,-1
    4e5a:	00e78563          	beq	a5,a4,4e64 <sbrkfail+0x118>
    4e5e:	4709                	li	a4,2
    4e60:	08e79d63          	bne	a5,a4,4efa <sbrkfail+0x1ae>
}
    4e64:	70e6                	ld	ra,120(sp)
    4e66:	7446                	ld	s0,112(sp)
    4e68:	74a6                	ld	s1,104(sp)
    4e6a:	7906                	ld	s2,96(sp)
    4e6c:	69e6                	ld	s3,88(sp)
    4e6e:	6a46                	ld	s4,80(sp)
    4e70:	6aa6                	ld	s5,72(sp)
    4e72:	6109                	addi	sp,sp,128
    4e74:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4e76:	85d6                	mv	a1,s5
    4e78:	00003517          	auipc	a0,0x3
    4e7c:	4a850513          	addi	a0,a0,1192 # 8320 <csem_free+0x220c>
    4e80:	00001097          	auipc	ra,0x1
    4e84:	ffe080e7          	jalr	-2(ra) # 5e7e <printf>
    exit(1);
    4e88:	4505                	li	a0,1
    4e8a:	00001097          	auipc	ra,0x1
    4e8e:	c22080e7          	jalr	-990(ra) # 5aac <exit>
    printf("%s: fork failed\n", s);
    4e92:	85d6                	mv	a1,s5
    4e94:	00001517          	auipc	a0,0x1
    4e98:	5b450513          	addi	a0,a0,1460 # 6448 <csem_free+0x334>
    4e9c:	00001097          	auipc	ra,0x1
    4ea0:	fe2080e7          	jalr	-30(ra) # 5e7e <printf>
    exit(1);
    4ea4:	4505                	li	a0,1
    4ea6:	00001097          	auipc	ra,0x1
    4eaa:	c06080e7          	jalr	-1018(ra) # 5aac <exit>
    a = sbrk(0);
    4eae:	4501                	li	a0,0
    4eb0:	00001097          	auipc	ra,0x1
    4eb4:	c84080e7          	jalr	-892(ra) # 5b34 <sbrk>
    4eb8:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4eba:	3e800537          	lui	a0,0x3e800
    4ebe:	00001097          	auipc	ra,0x1
    4ec2:	c76080e7          	jalr	-906(ra) # 5b34 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4ec6:	87ca                	mv	a5,s2
    4ec8:	3e800737          	lui	a4,0x3e800
    4ecc:	993a                	add	s2,s2,a4
    4ece:	6705                	lui	a4,0x1
      n += *(a+i);
    4ed0:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f0f10>
    4ed4:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4ed6:	97ba                	add	a5,a5,a4
    4ed8:	ff279ce3          	bne	a5,s2,4ed0 <sbrkfail+0x184>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4edc:	8626                	mv	a2,s1
    4ede:	85d6                	mv	a1,s5
    4ee0:	00003517          	auipc	a0,0x3
    4ee4:	46050513          	addi	a0,a0,1120 # 8340 <csem_free+0x222c>
    4ee8:	00001097          	auipc	ra,0x1
    4eec:	f96080e7          	jalr	-106(ra) # 5e7e <printf>
    exit(1);
    4ef0:	4505                	li	a0,1
    4ef2:	00001097          	auipc	ra,0x1
    4ef6:	bba080e7          	jalr	-1094(ra) # 5aac <exit>
    exit(1);
    4efa:	4505                	li	a0,1
    4efc:	00001097          	auipc	ra,0x1
    4f00:	bb0080e7          	jalr	-1104(ra) # 5aac <exit>

0000000000004f04 <fsfull>:
{
    4f04:	7171                	addi	sp,sp,-176
    4f06:	f506                	sd	ra,168(sp)
    4f08:	f122                	sd	s0,160(sp)
    4f0a:	ed26                	sd	s1,152(sp)
    4f0c:	e94a                	sd	s2,144(sp)
    4f0e:	e54e                	sd	s3,136(sp)
    4f10:	e152                	sd	s4,128(sp)
    4f12:	fcd6                	sd	s5,120(sp)
    4f14:	f8da                	sd	s6,112(sp)
    4f16:	f4de                	sd	s7,104(sp)
    4f18:	f0e2                	sd	s8,96(sp)
    4f1a:	ece6                	sd	s9,88(sp)
    4f1c:	e8ea                	sd	s10,80(sp)
    4f1e:	e4ee                	sd	s11,72(sp)
    4f20:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4f22:	00003517          	auipc	a0,0x3
    4f26:	44e50513          	addi	a0,a0,1102 # 8370 <csem_free+0x225c>
    4f2a:	00001097          	auipc	ra,0x1
    4f2e:	f54080e7          	jalr	-172(ra) # 5e7e <printf>
  for(nfiles = 0; ; nfiles++){
    4f32:	4481                	li	s1,0
    name[0] = 'f';
    4f34:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4f38:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4f3c:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4f40:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4f42:	00003c97          	auipc	s9,0x3
    4f46:	43ec8c93          	addi	s9,s9,1086 # 8380 <csem_free+0x226c>
    int total = 0;
    4f4a:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4f4c:	00007a17          	auipc	s4,0x7
    4f50:	194a0a13          	addi	s4,s4,404 # c0e0 <buf>
    name[0] = 'f';
    4f54:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4f58:	0384c7bb          	divw	a5,s1,s8
    4f5c:	0307879b          	addiw	a5,a5,48
    4f60:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4f64:	0384e7bb          	remw	a5,s1,s8
    4f68:	0377c7bb          	divw	a5,a5,s7
    4f6c:	0307879b          	addiw	a5,a5,48
    4f70:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4f74:	0374e7bb          	remw	a5,s1,s7
    4f78:	0367c7bb          	divw	a5,a5,s6
    4f7c:	0307879b          	addiw	a5,a5,48
    4f80:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4f84:	0364e7bb          	remw	a5,s1,s6
    4f88:	0307879b          	addiw	a5,a5,48
    4f8c:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4f90:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4f94:	f5040593          	addi	a1,s0,-176
    4f98:	8566                	mv	a0,s9
    4f9a:	00001097          	auipc	ra,0x1
    4f9e:	ee4080e7          	jalr	-284(ra) # 5e7e <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4fa2:	20200593          	li	a1,514
    4fa6:	f5040513          	addi	a0,s0,-176
    4faa:	00001097          	auipc	ra,0x1
    4fae:	b42080e7          	jalr	-1214(ra) # 5aec <open>
    4fb2:	892a                	mv	s2,a0
    if(fd < 0){
    4fb4:	0a055663          	bgez	a0,5060 <fsfull+0x15c>
      printf("open %s failed\n", name);
    4fb8:	f5040593          	addi	a1,s0,-176
    4fbc:	00003517          	auipc	a0,0x3
    4fc0:	3d450513          	addi	a0,a0,980 # 8390 <csem_free+0x227c>
    4fc4:	00001097          	auipc	ra,0x1
    4fc8:	eba080e7          	jalr	-326(ra) # 5e7e <printf>
  while(nfiles >= 0){
    4fcc:	0604c363          	bltz	s1,5032 <fsfull+0x12e>
    name[0] = 'f';
    4fd0:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4fd4:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4fd8:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4fdc:	4929                	li	s2,10
  while(nfiles >= 0){
    4fde:	5afd                	li	s5,-1
    name[0] = 'f';
    4fe0:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4fe4:	0344c7bb          	divw	a5,s1,s4
    4fe8:	0307879b          	addiw	a5,a5,48
    4fec:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4ff0:	0344e7bb          	remw	a5,s1,s4
    4ff4:	0337c7bb          	divw	a5,a5,s3
    4ff8:	0307879b          	addiw	a5,a5,48
    4ffc:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5000:	0334e7bb          	remw	a5,s1,s3
    5004:	0327c7bb          	divw	a5,a5,s2
    5008:	0307879b          	addiw	a5,a5,48
    500c:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5010:	0324e7bb          	remw	a5,s1,s2
    5014:	0307879b          	addiw	a5,a5,48
    5018:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    501c:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    5020:	f5040513          	addi	a0,s0,-176
    5024:	00001097          	auipc	ra,0x1
    5028:	ad8080e7          	jalr	-1320(ra) # 5afc <unlink>
    nfiles--;
    502c:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    502e:	fb5499e3          	bne	s1,s5,4fe0 <fsfull+0xdc>
  printf("fsfull test finished\n");
    5032:	00003517          	auipc	a0,0x3
    5036:	37e50513          	addi	a0,a0,894 # 83b0 <csem_free+0x229c>
    503a:	00001097          	auipc	ra,0x1
    503e:	e44080e7          	jalr	-444(ra) # 5e7e <printf>
}
    5042:	70aa                	ld	ra,168(sp)
    5044:	740a                	ld	s0,160(sp)
    5046:	64ea                	ld	s1,152(sp)
    5048:	694a                	ld	s2,144(sp)
    504a:	69aa                	ld	s3,136(sp)
    504c:	6a0a                	ld	s4,128(sp)
    504e:	7ae6                	ld	s5,120(sp)
    5050:	7b46                	ld	s6,112(sp)
    5052:	7ba6                	ld	s7,104(sp)
    5054:	7c06                	ld	s8,96(sp)
    5056:	6ce6                	ld	s9,88(sp)
    5058:	6d46                	ld	s10,80(sp)
    505a:	6da6                	ld	s11,72(sp)
    505c:	614d                	addi	sp,sp,176
    505e:	8082                	ret
    int total = 0;
    5060:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    5062:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    5066:	40000613          	li	a2,1024
    506a:	85d2                	mv	a1,s4
    506c:	854a                	mv	a0,s2
    506e:	00001097          	auipc	ra,0x1
    5072:	a5e080e7          	jalr	-1442(ra) # 5acc <write>
      if(cc < BSIZE)
    5076:	00aad563          	bge	s5,a0,5080 <fsfull+0x17c>
      total += cc;
    507a:	00a989bb          	addw	s3,s3,a0
    while(1){
    507e:	b7e5                	j	5066 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    5080:	85ce                	mv	a1,s3
    5082:	00003517          	auipc	a0,0x3
    5086:	31e50513          	addi	a0,a0,798 # 83a0 <csem_free+0x228c>
    508a:	00001097          	auipc	ra,0x1
    508e:	df4080e7          	jalr	-524(ra) # 5e7e <printf>
    close(fd);
    5092:	854a                	mv	a0,s2
    5094:	00001097          	auipc	ra,0x1
    5098:	a40080e7          	jalr	-1472(ra) # 5ad4 <close>
    if(total == 0)
    509c:	f20988e3          	beqz	s3,4fcc <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    50a0:	2485                	addiw	s1,s1,1
    50a2:	bd4d                	j	4f54 <fsfull+0x50>

00000000000050a4 <rand>:
{
    50a4:	1141                	addi	sp,sp,-16
    50a6:	e422                	sd	s0,8(sp)
    50a8:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    50aa:	00004717          	auipc	a4,0x4
    50ae:	80670713          	addi	a4,a4,-2042 # 88b0 <randstate>
    50b2:	6308                	ld	a0,0(a4)
    50b4:	001967b7          	lui	a5,0x196
    50b8:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x18751d>
    50bc:	02f50533          	mul	a0,a0,a5
    50c0:	3c6ef7b7          	lui	a5,0x3c6ef
    50c4:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e026f>
    50c8:	953e                	add	a0,a0,a5
    50ca:	e308                	sd	a0,0(a4)
}
    50cc:	2501                	sext.w	a0,a0
    50ce:	6422                	ld	s0,8(sp)
    50d0:	0141                	addi	sp,sp,16
    50d2:	8082                	ret

00000000000050d4 <stacktest>:
{
    50d4:	7179                	addi	sp,sp,-48
    50d6:	f406                	sd	ra,40(sp)
    50d8:	f022                	sd	s0,32(sp)
    50da:	ec26                	sd	s1,24(sp)
    50dc:	1800                	addi	s0,sp,48
    50de:	84aa                	mv	s1,a0
  pid = fork();
    50e0:	00001097          	auipc	ra,0x1
    50e4:	9c4080e7          	jalr	-1596(ra) # 5aa4 <fork>
  if(pid == 0) {
    50e8:	c115                	beqz	a0,510c <stacktest+0x38>
  } else if(pid < 0){
    50ea:	04054463          	bltz	a0,5132 <stacktest+0x5e>
  wait(&xstatus);
    50ee:	fdc40513          	addi	a0,s0,-36
    50f2:	00001097          	auipc	ra,0x1
    50f6:	9c2080e7          	jalr	-1598(ra) # 5ab4 <wait>
  if(xstatus == -1)  // kernel killed child?
    50fa:	fdc42503          	lw	a0,-36(s0)
    50fe:	57fd                	li	a5,-1
    5100:	04f50763          	beq	a0,a5,514e <stacktest+0x7a>
    exit(xstatus);
    5104:	00001097          	auipc	ra,0x1
    5108:	9a8080e7          	jalr	-1624(ra) # 5aac <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    510c:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    510e:	77fd                	lui	a5,0xfffff
    5110:	97ba                	add	a5,a5,a4
    5112:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xfffffffffffeff10>
    5116:	85a6                	mv	a1,s1
    5118:	00003517          	auipc	a0,0x3
    511c:	2b050513          	addi	a0,a0,688 # 83c8 <csem_free+0x22b4>
    5120:	00001097          	auipc	ra,0x1
    5124:	d5e080e7          	jalr	-674(ra) # 5e7e <printf>
    exit(1);
    5128:	4505                	li	a0,1
    512a:	00001097          	auipc	ra,0x1
    512e:	982080e7          	jalr	-1662(ra) # 5aac <exit>
    printf("%s: fork failed\n", s);
    5132:	85a6                	mv	a1,s1
    5134:	00001517          	auipc	a0,0x1
    5138:	31450513          	addi	a0,a0,788 # 6448 <csem_free+0x334>
    513c:	00001097          	auipc	ra,0x1
    5140:	d42080e7          	jalr	-702(ra) # 5e7e <printf>
    exit(1);
    5144:	4505                	li	a0,1
    5146:	00001097          	auipc	ra,0x1
    514a:	966080e7          	jalr	-1690(ra) # 5aac <exit>
    exit(0);
    514e:	4501                	li	a0,0
    5150:	00001097          	auipc	ra,0x1
    5154:	95c080e7          	jalr	-1700(ra) # 5aac <exit>

0000000000005158 <sbrkbugs>:
{
    5158:	1141                	addi	sp,sp,-16
    515a:	e406                	sd	ra,8(sp)
    515c:	e022                	sd	s0,0(sp)
    515e:	0800                	addi	s0,sp,16
  int pid = fork();
    5160:	00001097          	auipc	ra,0x1
    5164:	944080e7          	jalr	-1724(ra) # 5aa4 <fork>
  if(pid < 0){
    5168:	02054263          	bltz	a0,518c <sbrkbugs+0x34>
  if(pid == 0){
    516c:	ed0d                	bnez	a0,51a6 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    516e:	00001097          	auipc	ra,0x1
    5172:	9c6080e7          	jalr	-1594(ra) # 5b34 <sbrk>
    sbrk(-sz);
    5176:	40a0053b          	negw	a0,a0
    517a:	00001097          	auipc	ra,0x1
    517e:	9ba080e7          	jalr	-1606(ra) # 5b34 <sbrk>
    exit(0);
    5182:	4501                	li	a0,0
    5184:	00001097          	auipc	ra,0x1
    5188:	928080e7          	jalr	-1752(ra) # 5aac <exit>
    printf("fork failed\n");
    518c:	00002517          	auipc	a0,0x2
    5190:	d4c50513          	addi	a0,a0,-692 # 6ed8 <csem_free+0xdc4>
    5194:	00001097          	auipc	ra,0x1
    5198:	cea080e7          	jalr	-790(ra) # 5e7e <printf>
    exit(1);
    519c:	4505                	li	a0,1
    519e:	00001097          	auipc	ra,0x1
    51a2:	90e080e7          	jalr	-1778(ra) # 5aac <exit>
  wait(0);
    51a6:	4501                	li	a0,0
    51a8:	00001097          	auipc	ra,0x1
    51ac:	90c080e7          	jalr	-1780(ra) # 5ab4 <wait>
  pid = fork();
    51b0:	00001097          	auipc	ra,0x1
    51b4:	8f4080e7          	jalr	-1804(ra) # 5aa4 <fork>
  if(pid < 0){
    51b8:	02054563          	bltz	a0,51e2 <sbrkbugs+0x8a>
  if(pid == 0){
    51bc:	e121                	bnez	a0,51fc <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    51be:	00001097          	auipc	ra,0x1
    51c2:	976080e7          	jalr	-1674(ra) # 5b34 <sbrk>
    sbrk(-(sz - 3500));
    51c6:	6785                	lui	a5,0x1
    51c8:	dac7879b          	addiw	a5,a5,-596
    51cc:	40a7853b          	subw	a0,a5,a0
    51d0:	00001097          	auipc	ra,0x1
    51d4:	964080e7          	jalr	-1692(ra) # 5b34 <sbrk>
    exit(0);
    51d8:	4501                	li	a0,0
    51da:	00001097          	auipc	ra,0x1
    51de:	8d2080e7          	jalr	-1838(ra) # 5aac <exit>
    printf("fork failed\n");
    51e2:	00002517          	auipc	a0,0x2
    51e6:	cf650513          	addi	a0,a0,-778 # 6ed8 <csem_free+0xdc4>
    51ea:	00001097          	auipc	ra,0x1
    51ee:	c94080e7          	jalr	-876(ra) # 5e7e <printf>
    exit(1);
    51f2:	4505                	li	a0,1
    51f4:	00001097          	auipc	ra,0x1
    51f8:	8b8080e7          	jalr	-1864(ra) # 5aac <exit>
  wait(0);
    51fc:	4501                	li	a0,0
    51fe:	00001097          	auipc	ra,0x1
    5202:	8b6080e7          	jalr	-1866(ra) # 5ab4 <wait>
  pid = fork();
    5206:	00001097          	auipc	ra,0x1
    520a:	89e080e7          	jalr	-1890(ra) # 5aa4 <fork>
  if(pid < 0){
    520e:	02054a63          	bltz	a0,5242 <sbrkbugs+0xea>
  if(pid == 0){
    5212:	e529                	bnez	a0,525c <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    5214:	00001097          	auipc	ra,0x1
    5218:	920080e7          	jalr	-1760(ra) # 5b34 <sbrk>
    521c:	67ad                	lui	a5,0xb
    521e:	8007879b          	addiw	a5,a5,-2048
    5222:	40a7853b          	subw	a0,a5,a0
    5226:	00001097          	auipc	ra,0x1
    522a:	90e080e7          	jalr	-1778(ra) # 5b34 <sbrk>
    sbrk(-10);
    522e:	5559                	li	a0,-10
    5230:	00001097          	auipc	ra,0x1
    5234:	904080e7          	jalr	-1788(ra) # 5b34 <sbrk>
    exit(0);
    5238:	4501                	li	a0,0
    523a:	00001097          	auipc	ra,0x1
    523e:	872080e7          	jalr	-1934(ra) # 5aac <exit>
    printf("fork failed\n");
    5242:	00002517          	auipc	a0,0x2
    5246:	c9650513          	addi	a0,a0,-874 # 6ed8 <csem_free+0xdc4>
    524a:	00001097          	auipc	ra,0x1
    524e:	c34080e7          	jalr	-972(ra) # 5e7e <printf>
    exit(1);
    5252:	4505                	li	a0,1
    5254:	00001097          	auipc	ra,0x1
    5258:	858080e7          	jalr	-1960(ra) # 5aac <exit>
  wait(0);
    525c:	4501                	li	a0,0
    525e:	00001097          	auipc	ra,0x1
    5262:	856080e7          	jalr	-1962(ra) # 5ab4 <wait>
  exit(0);
    5266:	4501                	li	a0,0
    5268:	00001097          	auipc	ra,0x1
    526c:	844080e7          	jalr	-1980(ra) # 5aac <exit>

0000000000005270 <badwrite>:
{
    5270:	7179                	addi	sp,sp,-48
    5272:	f406                	sd	ra,40(sp)
    5274:	f022                	sd	s0,32(sp)
    5276:	ec26                	sd	s1,24(sp)
    5278:	e84a                	sd	s2,16(sp)
    527a:	e44e                	sd	s3,8(sp)
    527c:	e052                	sd	s4,0(sp)
    527e:	1800                	addi	s0,sp,48
  unlink("junk");
    5280:	00003517          	auipc	a0,0x3
    5284:	17050513          	addi	a0,a0,368 # 83f0 <csem_free+0x22dc>
    5288:	00001097          	auipc	ra,0x1
    528c:	874080e7          	jalr	-1932(ra) # 5afc <unlink>
    5290:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    5294:	00003997          	auipc	s3,0x3
    5298:	15c98993          	addi	s3,s3,348 # 83f0 <csem_free+0x22dc>
    write(fd, (char*)0xffffffffffL, 1);
    529c:	5a7d                	li	s4,-1
    529e:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    52a2:	20100593          	li	a1,513
    52a6:	854e                	mv	a0,s3
    52a8:	00001097          	auipc	ra,0x1
    52ac:	844080e7          	jalr	-1980(ra) # 5aec <open>
    52b0:	84aa                	mv	s1,a0
    if(fd < 0){
    52b2:	06054b63          	bltz	a0,5328 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    52b6:	4605                	li	a2,1
    52b8:	85d2                	mv	a1,s4
    52ba:	00001097          	auipc	ra,0x1
    52be:	812080e7          	jalr	-2030(ra) # 5acc <write>
    close(fd);
    52c2:	8526                	mv	a0,s1
    52c4:	00001097          	auipc	ra,0x1
    52c8:	810080e7          	jalr	-2032(ra) # 5ad4 <close>
    unlink("junk");
    52cc:	854e                	mv	a0,s3
    52ce:	00001097          	auipc	ra,0x1
    52d2:	82e080e7          	jalr	-2002(ra) # 5afc <unlink>
  for(int i = 0; i < assumed_free; i++){
    52d6:	397d                	addiw	s2,s2,-1
    52d8:	fc0915e3          	bnez	s2,52a2 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    52dc:	20100593          	li	a1,513
    52e0:	00003517          	auipc	a0,0x3
    52e4:	11050513          	addi	a0,a0,272 # 83f0 <csem_free+0x22dc>
    52e8:	00001097          	auipc	ra,0x1
    52ec:	804080e7          	jalr	-2044(ra) # 5aec <open>
    52f0:	84aa                	mv	s1,a0
  if(fd < 0){
    52f2:	04054863          	bltz	a0,5342 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    52f6:	4605                	li	a2,1
    52f8:	00001597          	auipc	a1,0x1
    52fc:	3d058593          	addi	a1,a1,976 # 66c8 <csem_free+0x5b4>
    5300:	00000097          	auipc	ra,0x0
    5304:	7cc080e7          	jalr	1996(ra) # 5acc <write>
    5308:	4785                	li	a5,1
    530a:	04f50963          	beq	a0,a5,535c <badwrite+0xec>
    printf("write failed\n");
    530e:	00003517          	auipc	a0,0x3
    5312:	10250513          	addi	a0,a0,258 # 8410 <csem_free+0x22fc>
    5316:	00001097          	auipc	ra,0x1
    531a:	b68080e7          	jalr	-1176(ra) # 5e7e <printf>
    exit(1);
    531e:	4505                	li	a0,1
    5320:	00000097          	auipc	ra,0x0
    5324:	78c080e7          	jalr	1932(ra) # 5aac <exit>
      printf("open junk failed\n");
    5328:	00003517          	auipc	a0,0x3
    532c:	0d050513          	addi	a0,a0,208 # 83f8 <csem_free+0x22e4>
    5330:	00001097          	auipc	ra,0x1
    5334:	b4e080e7          	jalr	-1202(ra) # 5e7e <printf>
      exit(1);
    5338:	4505                	li	a0,1
    533a:	00000097          	auipc	ra,0x0
    533e:	772080e7          	jalr	1906(ra) # 5aac <exit>
    printf("open junk failed\n");
    5342:	00003517          	auipc	a0,0x3
    5346:	0b650513          	addi	a0,a0,182 # 83f8 <csem_free+0x22e4>
    534a:	00001097          	auipc	ra,0x1
    534e:	b34080e7          	jalr	-1228(ra) # 5e7e <printf>
    exit(1);
    5352:	4505                	li	a0,1
    5354:	00000097          	auipc	ra,0x0
    5358:	758080e7          	jalr	1880(ra) # 5aac <exit>
  close(fd);
    535c:	8526                	mv	a0,s1
    535e:	00000097          	auipc	ra,0x0
    5362:	776080e7          	jalr	1910(ra) # 5ad4 <close>
  unlink("junk");
    5366:	00003517          	auipc	a0,0x3
    536a:	08a50513          	addi	a0,a0,138 # 83f0 <csem_free+0x22dc>
    536e:	00000097          	auipc	ra,0x0
    5372:	78e080e7          	jalr	1934(ra) # 5afc <unlink>
  exit(0);
    5376:	4501                	li	a0,0
    5378:	00000097          	auipc	ra,0x0
    537c:	734080e7          	jalr	1844(ra) # 5aac <exit>

0000000000005380 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    5380:	715d                	addi	sp,sp,-80
    5382:	e486                	sd	ra,72(sp)
    5384:	e0a2                	sd	s0,64(sp)
    5386:	fc26                	sd	s1,56(sp)
    5388:	f84a                	sd	s2,48(sp)
    538a:	f44e                	sd	s3,40(sp)
    538c:	f052                	sd	s4,32(sp)
    538e:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    5390:	4901                	li	s2,0
    5392:	49bd                	li	s3,15
    int pid = fork();
    5394:	00000097          	auipc	ra,0x0
    5398:	710080e7          	jalr	1808(ra) # 5aa4 <fork>
    539c:	84aa                	mv	s1,a0
    if(pid < 0){
    539e:	02054063          	bltz	a0,53be <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    53a2:	c91d                	beqz	a0,53d8 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    53a4:	4501                	li	a0,0
    53a6:	00000097          	auipc	ra,0x0
    53aa:	70e080e7          	jalr	1806(ra) # 5ab4 <wait>
  for(int avail = 0; avail < 15; avail++){
    53ae:	2905                	addiw	s2,s2,1
    53b0:	ff3912e3          	bne	s2,s3,5394 <execout+0x14>
    }
  }

  exit(0);
    53b4:	4501                	li	a0,0
    53b6:	00000097          	auipc	ra,0x0
    53ba:	6f6080e7          	jalr	1782(ra) # 5aac <exit>
      printf("fork failed\n");
    53be:	00002517          	auipc	a0,0x2
    53c2:	b1a50513          	addi	a0,a0,-1254 # 6ed8 <csem_free+0xdc4>
    53c6:	00001097          	auipc	ra,0x1
    53ca:	ab8080e7          	jalr	-1352(ra) # 5e7e <printf>
      exit(1);
    53ce:	4505                	li	a0,1
    53d0:	00000097          	auipc	ra,0x0
    53d4:	6dc080e7          	jalr	1756(ra) # 5aac <exit>
        if(a == 0xffffffffffffffffLL)
    53d8:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    53da:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    53dc:	6505                	lui	a0,0x1
    53de:	00000097          	auipc	ra,0x0
    53e2:	756080e7          	jalr	1878(ra) # 5b34 <sbrk>
        if(a == 0xffffffffffffffffLL)
    53e6:	01350763          	beq	a0,s3,53f4 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    53ea:	6785                	lui	a5,0x1
    53ec:	953e                	add	a0,a0,a5
    53ee:	ff450fa3          	sb	s4,-1(a0) # fff <pipe1+0x59>
      while(1){
    53f2:	b7ed                	j	53dc <execout+0x5c>
      for(int i = 0; i < avail; i++)
    53f4:	01205a63          	blez	s2,5408 <execout+0x88>
        sbrk(-4096);
    53f8:	757d                	lui	a0,0xfffff
    53fa:	00000097          	auipc	ra,0x0
    53fe:	73a080e7          	jalr	1850(ra) # 5b34 <sbrk>
      for(int i = 0; i < avail; i++)
    5402:	2485                	addiw	s1,s1,1
    5404:	ff249ae3          	bne	s1,s2,53f8 <execout+0x78>
      close(1);
    5408:	4505                	li	a0,1
    540a:	00000097          	auipc	ra,0x0
    540e:	6ca080e7          	jalr	1738(ra) # 5ad4 <close>
      char *args[] = { "echo", "x", 0 };
    5412:	00001517          	auipc	a0,0x1
    5416:	24650513          	addi	a0,a0,582 # 6658 <csem_free+0x544>
    541a:	faa43c23          	sd	a0,-72(s0)
    541e:	00001797          	auipc	a5,0x1
    5422:	2aa78793          	addi	a5,a5,682 # 66c8 <csem_free+0x5b4>
    5426:	fcf43023          	sd	a5,-64(s0)
    542a:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    542e:	fb840593          	addi	a1,s0,-72
    5432:	00000097          	auipc	ra,0x0
    5436:	6b2080e7          	jalr	1714(ra) # 5ae4 <exec>
      exit(0);
    543a:	4501                	li	a0,0
    543c:	00000097          	auipc	ra,0x0
    5440:	670080e7          	jalr	1648(ra) # 5aac <exit>

0000000000005444 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5444:	7139                	addi	sp,sp,-64
    5446:	fc06                	sd	ra,56(sp)
    5448:	f822                	sd	s0,48(sp)
    544a:	f426                	sd	s1,40(sp)
    544c:	f04a                	sd	s2,32(sp)
    544e:	ec4e                	sd	s3,24(sp)
    5450:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5452:	fc840513          	addi	a0,s0,-56
    5456:	00000097          	auipc	ra,0x0
    545a:	666080e7          	jalr	1638(ra) # 5abc <pipe>
    545e:	06054763          	bltz	a0,54cc <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5462:	00000097          	auipc	ra,0x0
    5466:	642080e7          	jalr	1602(ra) # 5aa4 <fork>

  if(pid < 0){
    546a:	06054e63          	bltz	a0,54e6 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    546e:	ed51                	bnez	a0,550a <countfree+0xc6>
    close(fds[0]);
    5470:	fc842503          	lw	a0,-56(s0)
    5474:	00000097          	auipc	ra,0x0
    5478:	660080e7          	jalr	1632(ra) # 5ad4 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    547c:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    547e:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5480:	00001997          	auipc	s3,0x1
    5484:	24898993          	addi	s3,s3,584 # 66c8 <csem_free+0x5b4>
      uint64 a = (uint64) sbrk(4096);
    5488:	6505                	lui	a0,0x1
    548a:	00000097          	auipc	ra,0x0
    548e:	6aa080e7          	jalr	1706(ra) # 5b34 <sbrk>
      if(a == 0xffffffffffffffff){
    5492:	07250763          	beq	a0,s2,5500 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    5496:	6785                	lui	a5,0x1
    5498:	953e                	add	a0,a0,a5
    549a:	fe950fa3          	sb	s1,-1(a0) # fff <pipe1+0x59>
      if(write(fds[1], "x", 1) != 1){
    549e:	8626                	mv	a2,s1
    54a0:	85ce                	mv	a1,s3
    54a2:	fcc42503          	lw	a0,-52(s0)
    54a6:	00000097          	auipc	ra,0x0
    54aa:	626080e7          	jalr	1574(ra) # 5acc <write>
    54ae:	fc950de3          	beq	a0,s1,5488 <countfree+0x44>
        printf("write() failed in countfree()\n");
    54b2:	00003517          	auipc	a0,0x3
    54b6:	fae50513          	addi	a0,a0,-82 # 8460 <csem_free+0x234c>
    54ba:	00001097          	auipc	ra,0x1
    54be:	9c4080e7          	jalr	-1596(ra) # 5e7e <printf>
        exit(1);
    54c2:	4505                	li	a0,1
    54c4:	00000097          	auipc	ra,0x0
    54c8:	5e8080e7          	jalr	1512(ra) # 5aac <exit>
    printf("pipe() failed in countfree()\n");
    54cc:	00003517          	auipc	a0,0x3
    54d0:	f5450513          	addi	a0,a0,-172 # 8420 <csem_free+0x230c>
    54d4:	00001097          	auipc	ra,0x1
    54d8:	9aa080e7          	jalr	-1622(ra) # 5e7e <printf>
    exit(1);
    54dc:	4505                	li	a0,1
    54de:	00000097          	auipc	ra,0x0
    54e2:	5ce080e7          	jalr	1486(ra) # 5aac <exit>
    printf("fork failed in countfree()\n");
    54e6:	00003517          	auipc	a0,0x3
    54ea:	f5a50513          	addi	a0,a0,-166 # 8440 <csem_free+0x232c>
    54ee:	00001097          	auipc	ra,0x1
    54f2:	990080e7          	jalr	-1648(ra) # 5e7e <printf>
    exit(1);
    54f6:	4505                	li	a0,1
    54f8:	00000097          	auipc	ra,0x0
    54fc:	5b4080e7          	jalr	1460(ra) # 5aac <exit>
      }
    }

    exit(0);
    5500:	4501                	li	a0,0
    5502:	00000097          	auipc	ra,0x0
    5506:	5aa080e7          	jalr	1450(ra) # 5aac <exit>
  }

  close(fds[1]);
    550a:	fcc42503          	lw	a0,-52(s0)
    550e:	00000097          	auipc	ra,0x0
    5512:	5c6080e7          	jalr	1478(ra) # 5ad4 <close>

  int n = 0;
    5516:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    5518:	4605                	li	a2,1
    551a:	fc740593          	addi	a1,s0,-57
    551e:	fc842503          	lw	a0,-56(s0)
    5522:	00000097          	auipc	ra,0x0
    5526:	5a2080e7          	jalr	1442(ra) # 5ac4 <read>
    if(cc < 0){
    552a:	00054563          	bltz	a0,5534 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    552e:	c105                	beqz	a0,554e <countfree+0x10a>
      break;
    n += 1;
    5530:	2485                	addiw	s1,s1,1
  while(1){
    5532:	b7dd                	j	5518 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5534:	00003517          	auipc	a0,0x3
    5538:	f4c50513          	addi	a0,a0,-180 # 8480 <csem_free+0x236c>
    553c:	00001097          	auipc	ra,0x1
    5540:	942080e7          	jalr	-1726(ra) # 5e7e <printf>
      exit(1);
    5544:	4505                	li	a0,1
    5546:	00000097          	auipc	ra,0x0
    554a:	566080e7          	jalr	1382(ra) # 5aac <exit>
  }

  close(fds[0]);
    554e:	fc842503          	lw	a0,-56(s0)
    5552:	00000097          	auipc	ra,0x0
    5556:	582080e7          	jalr	1410(ra) # 5ad4 <close>
  wait((int*)0);
    555a:	4501                	li	a0,0
    555c:	00000097          	auipc	ra,0x0
    5560:	558080e7          	jalr	1368(ra) # 5ab4 <wait>
  
  return n;
}
    5564:	8526                	mv	a0,s1
    5566:	70e2                	ld	ra,56(sp)
    5568:	7442                	ld	s0,48(sp)
    556a:	74a2                	ld	s1,40(sp)
    556c:	7902                	ld	s2,32(sp)
    556e:	69e2                	ld	s3,24(sp)
    5570:	6121                	addi	sp,sp,64
    5572:	8082                	ret

0000000000005574 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5574:	7179                	addi	sp,sp,-48
    5576:	f406                	sd	ra,40(sp)
    5578:	f022                	sd	s0,32(sp)
    557a:	ec26                	sd	s1,24(sp)
    557c:	e84a                	sd	s2,16(sp)
    557e:	1800                	addi	s0,sp,48
    5580:	84aa                	mv	s1,a0
    5582:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5584:	00003517          	auipc	a0,0x3
    5588:	f1c50513          	addi	a0,a0,-228 # 84a0 <csem_free+0x238c>
    558c:	00001097          	auipc	ra,0x1
    5590:	8f2080e7          	jalr	-1806(ra) # 5e7e <printf>
  if((pid = fork()) < 0) {
    5594:	00000097          	auipc	ra,0x0
    5598:	510080e7          	jalr	1296(ra) # 5aa4 <fork>
    559c:	02054e63          	bltz	a0,55d8 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    55a0:	c929                	beqz	a0,55f2 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    55a2:	fdc40513          	addi	a0,s0,-36
    55a6:	00000097          	auipc	ra,0x0
    55aa:	50e080e7          	jalr	1294(ra) # 5ab4 <wait>
    if(xstatus != 0) 
    55ae:	fdc42783          	lw	a5,-36(s0)
    55b2:	c7b9                	beqz	a5,5600 <run+0x8c>
      printf("FAILED\n");
    55b4:	00003517          	auipc	a0,0x3
    55b8:	f1450513          	addi	a0,a0,-236 # 84c8 <csem_free+0x23b4>
    55bc:	00001097          	auipc	ra,0x1
    55c0:	8c2080e7          	jalr	-1854(ra) # 5e7e <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    55c4:	fdc42503          	lw	a0,-36(s0)
  }
}
    55c8:	00153513          	seqz	a0,a0
    55cc:	70a2                	ld	ra,40(sp)
    55ce:	7402                	ld	s0,32(sp)
    55d0:	64e2                	ld	s1,24(sp)
    55d2:	6942                	ld	s2,16(sp)
    55d4:	6145                	addi	sp,sp,48
    55d6:	8082                	ret
    printf("runtest: fork error\n");
    55d8:	00003517          	auipc	a0,0x3
    55dc:	ed850513          	addi	a0,a0,-296 # 84b0 <csem_free+0x239c>
    55e0:	00001097          	auipc	ra,0x1
    55e4:	89e080e7          	jalr	-1890(ra) # 5e7e <printf>
    exit(1);
    55e8:	4505                	li	a0,1
    55ea:	00000097          	auipc	ra,0x0
    55ee:	4c2080e7          	jalr	1218(ra) # 5aac <exit>
    f(s);
    55f2:	854a                	mv	a0,s2
    55f4:	9482                	jalr	s1
    exit(0);
    55f6:	4501                	li	a0,0
    55f8:	00000097          	auipc	ra,0x0
    55fc:	4b4080e7          	jalr	1204(ra) # 5aac <exit>
      printf("OK\n");
    5600:	00003517          	auipc	a0,0x3
    5604:	ed050513          	addi	a0,a0,-304 # 84d0 <csem_free+0x23bc>
    5608:	00001097          	auipc	ra,0x1
    560c:	876080e7          	jalr	-1930(ra) # 5e7e <printf>
    5610:	bf55                	j	55c4 <run+0x50>

0000000000005612 <main>:

int
main(int argc, char *argv[])
{
    5612:	d2010113          	addi	sp,sp,-736
    5616:	2c113c23          	sd	ra,728(sp)
    561a:	2c813823          	sd	s0,720(sp)
    561e:	2c913423          	sd	s1,712(sp)
    5622:	2d213023          	sd	s2,704(sp)
    5626:	2b313c23          	sd	s3,696(sp)
    562a:	2b413823          	sd	s4,688(sp)
    562e:	2b513423          	sd	s5,680(sp)
    5632:	2b613023          	sd	s6,672(sp)
    5636:	1580                	addi	s0,sp,736
    5638:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    563a:	4789                	li	a5,2
    563c:	08f50763          	beq	a0,a5,56ca <main+0xb8>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5640:	4785                	li	a5,1
  char *justone = 0;
    5642:	4901                	li	s2,0
  } else if(argc > 1){
    5644:	0ca7c163          	blt	a5,a0,5706 <main+0xf4>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    5648:	00003797          	auipc	a5,0x3
    564c:	fa078793          	addi	a5,a5,-96 # 85e8 <csem_free+0x24d4>
    5650:	d2040713          	addi	a4,s0,-736
    5654:	00003817          	auipc	a6,0x3
    5658:	23480813          	addi	a6,a6,564 # 8888 <csem_free+0x2774>
    565c:	6388                	ld	a0,0(a5)
    565e:	678c                	ld	a1,8(a5)
    5660:	6b90                	ld	a2,16(a5)
    5662:	6f94                	ld	a3,24(a5)
    5664:	e308                	sd	a0,0(a4)
    5666:	e70c                	sd	a1,8(a4)
    5668:	eb10                	sd	a2,16(a4)
    566a:	ef14                	sd	a3,24(a4)
    566c:	02078793          	addi	a5,a5,32
    5670:	02070713          	addi	a4,a4,32
    5674:	ff0794e3          	bne	a5,a6,565c <main+0x4a>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    5678:	00003517          	auipc	a0,0x3
    567c:	f1050513          	addi	a0,a0,-240 # 8588 <csem_free+0x2474>
    5680:	00000097          	auipc	ra,0x0
    5684:	7fe080e7          	jalr	2046(ra) # 5e7e <printf>
  int free0 = countfree();
    5688:	00000097          	auipc	ra,0x0
    568c:	dbc080e7          	jalr	-580(ra) # 5444 <countfree>
    5690:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    5692:	d2843503          	ld	a0,-728(s0)
    5696:	d2040493          	addi	s1,s0,-736
  int fail = 0;
    569a:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    569c:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    569e:	e55d                	bnez	a0,574c <main+0x13a>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    56a0:	00000097          	auipc	ra,0x0
    56a4:	da4080e7          	jalr	-604(ra) # 5444 <countfree>
    56a8:	85aa                	mv	a1,a0
    56aa:	0f455163          	bge	a0,s4,578c <main+0x17a>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    56ae:	8652                	mv	a2,s4
    56b0:	00003517          	auipc	a0,0x3
    56b4:	e9050513          	addi	a0,a0,-368 # 8540 <csem_free+0x242c>
    56b8:	00000097          	auipc	ra,0x0
    56bc:	7c6080e7          	jalr	1990(ra) # 5e7e <printf>
    exit(1);
    56c0:	4505                	li	a0,1
    56c2:	00000097          	auipc	ra,0x0
    56c6:	3ea080e7          	jalr	1002(ra) # 5aac <exit>
    56ca:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    56cc:	00003597          	auipc	a1,0x3
    56d0:	e0c58593          	addi	a1,a1,-500 # 84d8 <csem_free+0x23c4>
    56d4:	6488                	ld	a0,8(s1)
    56d6:	00000097          	auipc	ra,0x0
    56da:	184080e7          	jalr	388(ra) # 585a <strcmp>
    56de:	10050563          	beqz	a0,57e8 <main+0x1d6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    56e2:	00003597          	auipc	a1,0x3
    56e6:	ede58593          	addi	a1,a1,-290 # 85c0 <csem_free+0x24ac>
    56ea:	6488                	ld	a0,8(s1)
    56ec:	00000097          	auipc	ra,0x0
    56f0:	16e080e7          	jalr	366(ra) # 585a <strcmp>
    56f4:	c97d                	beqz	a0,57ea <main+0x1d8>
  } else if(argc == 2 && argv[1][0] != '-'){
    56f6:	0084b903          	ld	s2,8(s1)
    56fa:	00094703          	lbu	a4,0(s2)
    56fe:	02d00793          	li	a5,45
    5702:	f4f713e3          	bne	a4,a5,5648 <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    5706:	00003517          	auipc	a0,0x3
    570a:	dda50513          	addi	a0,a0,-550 # 84e0 <csem_free+0x23cc>
    570e:	00000097          	auipc	ra,0x0
    5712:	770080e7          	jalr	1904(ra) # 5e7e <printf>
    exit(1);
    5716:	4505                	li	a0,1
    5718:	00000097          	auipc	ra,0x0
    571c:	394080e7          	jalr	916(ra) # 5aac <exit>
          exit(1);
    5720:	4505                	li	a0,1
    5722:	00000097          	auipc	ra,0x0
    5726:	38a080e7          	jalr	906(ra) # 5aac <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    572a:	40a905bb          	subw	a1,s2,a0
    572e:	855a                	mv	a0,s6
    5730:	00000097          	auipc	ra,0x0
    5734:	74e080e7          	jalr	1870(ra) # 5e7e <printf>
        if(continuous != 2)
    5738:	09498463          	beq	s3,s4,57c0 <main+0x1ae>
          exit(1);
    573c:	4505                	li	a0,1
    573e:	00000097          	auipc	ra,0x0
    5742:	36e080e7          	jalr	878(ra) # 5aac <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    5746:	04c1                	addi	s1,s1,16
    5748:	6488                	ld	a0,8(s1)
    574a:	c115                	beqz	a0,576e <main+0x15c>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    574c:	00090863          	beqz	s2,575c <main+0x14a>
    5750:	85ca                	mv	a1,s2
    5752:	00000097          	auipc	ra,0x0
    5756:	108080e7          	jalr	264(ra) # 585a <strcmp>
    575a:	f575                	bnez	a0,5746 <main+0x134>
      if(!run(t->f, t->s))
    575c:	648c                	ld	a1,8(s1)
    575e:	6088                	ld	a0,0(s1)
    5760:	00000097          	auipc	ra,0x0
    5764:	e14080e7          	jalr	-492(ra) # 5574 <run>
    5768:	fd79                	bnez	a0,5746 <main+0x134>
        fail = 1;
    576a:	89d6                	mv	s3,s5
    576c:	bfe9                	j	5746 <main+0x134>
  if(fail){
    576e:	f20989e3          	beqz	s3,56a0 <main+0x8e>
    printf("SOME TESTS FAILED\n");
    5772:	00003517          	auipc	a0,0x3
    5776:	db650513          	addi	a0,a0,-586 # 8528 <csem_free+0x2414>
    577a:	00000097          	auipc	ra,0x0
    577e:	704080e7          	jalr	1796(ra) # 5e7e <printf>
    exit(1);
    5782:	4505                	li	a0,1
    5784:	00000097          	auipc	ra,0x0
    5788:	328080e7          	jalr	808(ra) # 5aac <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    578c:	00003517          	auipc	a0,0x3
    5790:	de450513          	addi	a0,a0,-540 # 8570 <csem_free+0x245c>
    5794:	00000097          	auipc	ra,0x0
    5798:	6ea080e7          	jalr	1770(ra) # 5e7e <printf>
    exit(0);
    579c:	4501                	li	a0,0
    579e:	00000097          	auipc	ra,0x0
    57a2:	30e080e7          	jalr	782(ra) # 5aac <exit>
        printf("SOME TESTS FAILED\n");
    57a6:	8556                	mv	a0,s5
    57a8:	00000097          	auipc	ra,0x0
    57ac:	6d6080e7          	jalr	1750(ra) # 5e7e <printf>
        if(continuous != 2)
    57b0:	f74998e3          	bne	s3,s4,5720 <main+0x10e>
      int free1 = countfree();
    57b4:	00000097          	auipc	ra,0x0
    57b8:	c90080e7          	jalr	-880(ra) # 5444 <countfree>
      if(free1 < free0){
    57bc:	f72547e3          	blt	a0,s2,572a <main+0x118>
      int free0 = countfree();
    57c0:	00000097          	auipc	ra,0x0
    57c4:	c84080e7          	jalr	-892(ra) # 5444 <countfree>
    57c8:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    57ca:	d2843583          	ld	a1,-728(s0)
    57ce:	d1fd                	beqz	a1,57b4 <main+0x1a2>
    57d0:	d2040493          	addi	s1,s0,-736
        if(!run(t->f, t->s)){
    57d4:	6088                	ld	a0,0(s1)
    57d6:	00000097          	auipc	ra,0x0
    57da:	d9e080e7          	jalr	-610(ra) # 5574 <run>
    57de:	d561                	beqz	a0,57a6 <main+0x194>
      for (struct test *t = tests; t->s != 0; t++) {
    57e0:	04c1                	addi	s1,s1,16
    57e2:	648c                	ld	a1,8(s1)
    57e4:	f9e5                	bnez	a1,57d4 <main+0x1c2>
    57e6:	b7f9                	j	57b4 <main+0x1a2>
    continuous = 1;
    57e8:	4985                	li	s3,1
  } tests[] = {
    57ea:	00003797          	auipc	a5,0x3
    57ee:	dfe78793          	addi	a5,a5,-514 # 85e8 <csem_free+0x24d4>
    57f2:	d2040713          	addi	a4,s0,-736
    57f6:	00003817          	auipc	a6,0x3
    57fa:	09280813          	addi	a6,a6,146 # 8888 <csem_free+0x2774>
    57fe:	6388                	ld	a0,0(a5)
    5800:	678c                	ld	a1,8(a5)
    5802:	6b90                	ld	a2,16(a5)
    5804:	6f94                	ld	a3,24(a5)
    5806:	e308                	sd	a0,0(a4)
    5808:	e70c                	sd	a1,8(a4)
    580a:	eb10                	sd	a2,16(a4)
    580c:	ef14                	sd	a3,24(a4)
    580e:	02078793          	addi	a5,a5,32
    5812:	02070713          	addi	a4,a4,32
    5816:	ff0794e3          	bne	a5,a6,57fe <main+0x1ec>
    printf("continuous usertests starting\n");
    581a:	00003517          	auipc	a0,0x3
    581e:	d8650513          	addi	a0,a0,-634 # 85a0 <csem_free+0x248c>
    5822:	00000097          	auipc	ra,0x0
    5826:	65c080e7          	jalr	1628(ra) # 5e7e <printf>
        printf("SOME TESTS FAILED\n");
    582a:	00003a97          	auipc	s5,0x3
    582e:	cfea8a93          	addi	s5,s5,-770 # 8528 <csem_free+0x2414>
        if(continuous != 2)
    5832:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5834:	00003b17          	auipc	s6,0x3
    5838:	cd4b0b13          	addi	s6,s6,-812 # 8508 <csem_free+0x23f4>
    583c:	b751                	j	57c0 <main+0x1ae>

000000000000583e <strcpy>:
#include "user/user.h"


char*
strcpy(char *s, const char *t)
{
    583e:	1141                	addi	sp,sp,-16
    5840:	e422                	sd	s0,8(sp)
    5842:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5844:	87aa                	mv	a5,a0
    5846:	0585                	addi	a1,a1,1
    5848:	0785                	addi	a5,a5,1
    584a:	fff5c703          	lbu	a4,-1(a1)
    584e:	fee78fa3          	sb	a4,-1(a5)
    5852:	fb75                	bnez	a4,5846 <strcpy+0x8>
    ;
  return os;
}
    5854:	6422                	ld	s0,8(sp)
    5856:	0141                	addi	sp,sp,16
    5858:	8082                	ret

000000000000585a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    585a:	1141                	addi	sp,sp,-16
    585c:	e422                	sd	s0,8(sp)
    585e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5860:	00054783          	lbu	a5,0(a0)
    5864:	cb91                	beqz	a5,5878 <strcmp+0x1e>
    5866:	0005c703          	lbu	a4,0(a1)
    586a:	00f71763          	bne	a4,a5,5878 <strcmp+0x1e>
    p++, q++;
    586e:	0505                	addi	a0,a0,1
    5870:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5872:	00054783          	lbu	a5,0(a0)
    5876:	fbe5                	bnez	a5,5866 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5878:	0005c503          	lbu	a0,0(a1)
}
    587c:	40a7853b          	subw	a0,a5,a0
    5880:	6422                	ld	s0,8(sp)
    5882:	0141                	addi	sp,sp,16
    5884:	8082                	ret

0000000000005886 <strlen>:

uint
strlen(const char *s)
{
    5886:	1141                	addi	sp,sp,-16
    5888:	e422                	sd	s0,8(sp)
    588a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    588c:	00054783          	lbu	a5,0(a0)
    5890:	cf91                	beqz	a5,58ac <strlen+0x26>
    5892:	0505                	addi	a0,a0,1
    5894:	87aa                	mv	a5,a0
    5896:	4685                	li	a3,1
    5898:	9e89                	subw	a3,a3,a0
    589a:	00f6853b          	addw	a0,a3,a5
    589e:	0785                	addi	a5,a5,1
    58a0:	fff7c703          	lbu	a4,-1(a5)
    58a4:	fb7d                	bnez	a4,589a <strlen+0x14>
    ;
  return n;
}
    58a6:	6422                	ld	s0,8(sp)
    58a8:	0141                	addi	sp,sp,16
    58aa:	8082                	ret
  for(n = 0; s[n]; n++)
    58ac:	4501                	li	a0,0
    58ae:	bfe5                	j	58a6 <strlen+0x20>

00000000000058b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    58b0:	1141                	addi	sp,sp,-16
    58b2:	e422                	sd	s0,8(sp)
    58b4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    58b6:	ca19                	beqz	a2,58cc <memset+0x1c>
    58b8:	87aa                	mv	a5,a0
    58ba:	1602                	slli	a2,a2,0x20
    58bc:	9201                	srli	a2,a2,0x20
    58be:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    58c2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    58c6:	0785                	addi	a5,a5,1
    58c8:	fee79de3          	bne	a5,a4,58c2 <memset+0x12>
  }
  return dst;
}
    58cc:	6422                	ld	s0,8(sp)
    58ce:	0141                	addi	sp,sp,16
    58d0:	8082                	ret

00000000000058d2 <strchr>:

char*
strchr(const char *s, char c)
{
    58d2:	1141                	addi	sp,sp,-16
    58d4:	e422                	sd	s0,8(sp)
    58d6:	0800                	addi	s0,sp,16
  for(; *s; s++)
    58d8:	00054783          	lbu	a5,0(a0)
    58dc:	cb99                	beqz	a5,58f2 <strchr+0x20>
    if(*s == c)
    58de:	00f58763          	beq	a1,a5,58ec <strchr+0x1a>
  for(; *s; s++)
    58e2:	0505                	addi	a0,a0,1
    58e4:	00054783          	lbu	a5,0(a0)
    58e8:	fbfd                	bnez	a5,58de <strchr+0xc>
      return (char*)s;
  return 0;
    58ea:	4501                	li	a0,0
}
    58ec:	6422                	ld	s0,8(sp)
    58ee:	0141                	addi	sp,sp,16
    58f0:	8082                	ret
  return 0;
    58f2:	4501                	li	a0,0
    58f4:	bfe5                	j	58ec <strchr+0x1a>

00000000000058f6 <gets>:

char*
gets(char *buf, int max)
{
    58f6:	711d                	addi	sp,sp,-96
    58f8:	ec86                	sd	ra,88(sp)
    58fa:	e8a2                	sd	s0,80(sp)
    58fc:	e4a6                	sd	s1,72(sp)
    58fe:	e0ca                	sd	s2,64(sp)
    5900:	fc4e                	sd	s3,56(sp)
    5902:	f852                	sd	s4,48(sp)
    5904:	f456                	sd	s5,40(sp)
    5906:	f05a                	sd	s6,32(sp)
    5908:	ec5e                	sd	s7,24(sp)
    590a:	1080                	addi	s0,sp,96
    590c:	8baa                	mv	s7,a0
    590e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5910:	892a                	mv	s2,a0
    5912:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5914:	4aa9                	li	s5,10
    5916:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5918:	89a6                	mv	s3,s1
    591a:	2485                	addiw	s1,s1,1
    591c:	0344d863          	bge	s1,s4,594c <gets+0x56>
    cc = read(0, &c, 1);
    5920:	4605                	li	a2,1
    5922:	faf40593          	addi	a1,s0,-81
    5926:	4501                	li	a0,0
    5928:	00000097          	auipc	ra,0x0
    592c:	19c080e7          	jalr	412(ra) # 5ac4 <read>
    if(cc < 1)
    5930:	00a05e63          	blez	a0,594c <gets+0x56>
    buf[i++] = c;
    5934:	faf44783          	lbu	a5,-81(s0)
    5938:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    593c:	01578763          	beq	a5,s5,594a <gets+0x54>
    5940:	0905                	addi	s2,s2,1
    5942:	fd679be3          	bne	a5,s6,5918 <gets+0x22>
  for(i=0; i+1 < max; ){
    5946:	89a6                	mv	s3,s1
    5948:	a011                	j	594c <gets+0x56>
    594a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    594c:	99de                	add	s3,s3,s7
    594e:	00098023          	sb	zero,0(s3)
  return buf;
}
    5952:	855e                	mv	a0,s7
    5954:	60e6                	ld	ra,88(sp)
    5956:	6446                	ld	s0,80(sp)
    5958:	64a6                	ld	s1,72(sp)
    595a:	6906                	ld	s2,64(sp)
    595c:	79e2                	ld	s3,56(sp)
    595e:	7a42                	ld	s4,48(sp)
    5960:	7aa2                	ld	s5,40(sp)
    5962:	7b02                	ld	s6,32(sp)
    5964:	6be2                	ld	s7,24(sp)
    5966:	6125                	addi	sp,sp,96
    5968:	8082                	ret

000000000000596a <stat>:

int
stat(const char *n, struct stat *st)
{
    596a:	1101                	addi	sp,sp,-32
    596c:	ec06                	sd	ra,24(sp)
    596e:	e822                	sd	s0,16(sp)
    5970:	e426                	sd	s1,8(sp)
    5972:	e04a                	sd	s2,0(sp)
    5974:	1000                	addi	s0,sp,32
    5976:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5978:	4581                	li	a1,0
    597a:	00000097          	auipc	ra,0x0
    597e:	172080e7          	jalr	370(ra) # 5aec <open>
  if(fd < 0)
    5982:	02054563          	bltz	a0,59ac <stat+0x42>
    5986:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5988:	85ca                	mv	a1,s2
    598a:	00000097          	auipc	ra,0x0
    598e:	17a080e7          	jalr	378(ra) # 5b04 <fstat>
    5992:	892a                	mv	s2,a0
  close(fd);
    5994:	8526                	mv	a0,s1
    5996:	00000097          	auipc	ra,0x0
    599a:	13e080e7          	jalr	318(ra) # 5ad4 <close>
  return r;
}
    599e:	854a                	mv	a0,s2
    59a0:	60e2                	ld	ra,24(sp)
    59a2:	6442                	ld	s0,16(sp)
    59a4:	64a2                	ld	s1,8(sp)
    59a6:	6902                	ld	s2,0(sp)
    59a8:	6105                	addi	sp,sp,32
    59aa:	8082                	ret
    return -1;
    59ac:	597d                	li	s2,-1
    59ae:	bfc5                	j	599e <stat+0x34>

00000000000059b0 <atoi>:

int
atoi(const char *s)
{
    59b0:	1141                	addi	sp,sp,-16
    59b2:	e422                	sd	s0,8(sp)
    59b4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    59b6:	00054603          	lbu	a2,0(a0)
    59ba:	fd06079b          	addiw	a5,a2,-48
    59be:	0ff7f793          	andi	a5,a5,255
    59c2:	4725                	li	a4,9
    59c4:	02f76963          	bltu	a4,a5,59f6 <atoi+0x46>
    59c8:	86aa                	mv	a3,a0
  n = 0;
    59ca:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    59cc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    59ce:	0685                	addi	a3,a3,1
    59d0:	0025179b          	slliw	a5,a0,0x2
    59d4:	9fa9                	addw	a5,a5,a0
    59d6:	0017979b          	slliw	a5,a5,0x1
    59da:	9fb1                	addw	a5,a5,a2
    59dc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    59e0:	0006c603          	lbu	a2,0(a3)
    59e4:	fd06071b          	addiw	a4,a2,-48
    59e8:	0ff77713          	andi	a4,a4,255
    59ec:	fee5f1e3          	bgeu	a1,a4,59ce <atoi+0x1e>
  return n;
}
    59f0:	6422                	ld	s0,8(sp)
    59f2:	0141                	addi	sp,sp,16
    59f4:	8082                	ret
  n = 0;
    59f6:	4501                	li	a0,0
    59f8:	bfe5                	j	59f0 <atoi+0x40>

00000000000059fa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    59fa:	1141                	addi	sp,sp,-16
    59fc:	e422                	sd	s0,8(sp)
    59fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5a00:	02b57463          	bgeu	a0,a1,5a28 <memmove+0x2e>
    while(n-- > 0)
    5a04:	00c05f63          	blez	a2,5a22 <memmove+0x28>
    5a08:	1602                	slli	a2,a2,0x20
    5a0a:	9201                	srli	a2,a2,0x20
    5a0c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5a10:	872a                	mv	a4,a0
      *dst++ = *src++;
    5a12:	0585                	addi	a1,a1,1
    5a14:	0705                	addi	a4,a4,1
    5a16:	fff5c683          	lbu	a3,-1(a1)
    5a1a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5a1e:	fee79ae3          	bne	a5,a4,5a12 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5a22:	6422                	ld	s0,8(sp)
    5a24:	0141                	addi	sp,sp,16
    5a26:	8082                	ret
    dst += n;
    5a28:	00c50733          	add	a4,a0,a2
    src += n;
    5a2c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5a2e:	fec05ae3          	blez	a2,5a22 <memmove+0x28>
    5a32:	fff6079b          	addiw	a5,a2,-1
    5a36:	1782                	slli	a5,a5,0x20
    5a38:	9381                	srli	a5,a5,0x20
    5a3a:	fff7c793          	not	a5,a5
    5a3e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5a40:	15fd                	addi	a1,a1,-1
    5a42:	177d                	addi	a4,a4,-1
    5a44:	0005c683          	lbu	a3,0(a1)
    5a48:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5a4c:	fee79ae3          	bne	a5,a4,5a40 <memmove+0x46>
    5a50:	bfc9                	j	5a22 <memmove+0x28>

0000000000005a52 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5a52:	1141                	addi	sp,sp,-16
    5a54:	e422                	sd	s0,8(sp)
    5a56:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5a58:	ca05                	beqz	a2,5a88 <memcmp+0x36>
    5a5a:	fff6069b          	addiw	a3,a2,-1
    5a5e:	1682                	slli	a3,a3,0x20
    5a60:	9281                	srli	a3,a3,0x20
    5a62:	0685                	addi	a3,a3,1
    5a64:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5a66:	00054783          	lbu	a5,0(a0)
    5a6a:	0005c703          	lbu	a4,0(a1)
    5a6e:	00e79863          	bne	a5,a4,5a7e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5a72:	0505                	addi	a0,a0,1
    p2++;
    5a74:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5a76:	fed518e3          	bne	a0,a3,5a66 <memcmp+0x14>
  }
  return 0;
    5a7a:	4501                	li	a0,0
    5a7c:	a019                	j	5a82 <memcmp+0x30>
      return *p1 - *p2;
    5a7e:	40e7853b          	subw	a0,a5,a4
}
    5a82:	6422                	ld	s0,8(sp)
    5a84:	0141                	addi	sp,sp,16
    5a86:	8082                	ret
  return 0;
    5a88:	4501                	li	a0,0
    5a8a:	bfe5                	j	5a82 <memcmp+0x30>

0000000000005a8c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5a8c:	1141                	addi	sp,sp,-16
    5a8e:	e406                	sd	ra,8(sp)
    5a90:	e022                	sd	s0,0(sp)
    5a92:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5a94:	00000097          	auipc	ra,0x0
    5a98:	f66080e7          	jalr	-154(ra) # 59fa <memmove>
}
    5a9c:	60a2                	ld	ra,8(sp)
    5a9e:	6402                	ld	s0,0(sp)
    5aa0:	0141                	addi	sp,sp,16
    5aa2:	8082                	ret

0000000000005aa4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5aa4:	4885                	li	a7,1
 ecall
    5aa6:	00000073          	ecall
 ret
    5aaa:	8082                	ret

0000000000005aac <exit>:
.global exit
exit:
 li a7, SYS_exit
    5aac:	4889                	li	a7,2
 ecall
    5aae:	00000073          	ecall
 ret
    5ab2:	8082                	ret

0000000000005ab4 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5ab4:	488d                	li	a7,3
 ecall
    5ab6:	00000073          	ecall
 ret
    5aba:	8082                	ret

0000000000005abc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5abc:	4891                	li	a7,4
 ecall
    5abe:	00000073          	ecall
 ret
    5ac2:	8082                	ret

0000000000005ac4 <read>:
.global read
read:
 li a7, SYS_read
    5ac4:	4895                	li	a7,5
 ecall
    5ac6:	00000073          	ecall
 ret
    5aca:	8082                	ret

0000000000005acc <write>:
.global write
write:
 li a7, SYS_write
    5acc:	48c1                	li	a7,16
 ecall
    5ace:	00000073          	ecall
 ret
    5ad2:	8082                	ret

0000000000005ad4 <close>:
.global close
close:
 li a7, SYS_close
    5ad4:	48d5                	li	a7,21
 ecall
    5ad6:	00000073          	ecall
 ret
    5ada:	8082                	ret

0000000000005adc <kill>:
.global kill
kill:
 li a7, SYS_kill
    5adc:	4899                	li	a7,6
 ecall
    5ade:	00000073          	ecall
 ret
    5ae2:	8082                	ret

0000000000005ae4 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5ae4:	489d                	li	a7,7
 ecall
    5ae6:	00000073          	ecall
 ret
    5aea:	8082                	ret

0000000000005aec <open>:
.global open
open:
 li a7, SYS_open
    5aec:	48bd                	li	a7,15
 ecall
    5aee:	00000073          	ecall
 ret
    5af2:	8082                	ret

0000000000005af4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5af4:	48c5                	li	a7,17
 ecall
    5af6:	00000073          	ecall
 ret
    5afa:	8082                	ret

0000000000005afc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5afc:	48c9                	li	a7,18
 ecall
    5afe:	00000073          	ecall
 ret
    5b02:	8082                	ret

0000000000005b04 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5b04:	48a1                	li	a7,8
 ecall
    5b06:	00000073          	ecall
 ret
    5b0a:	8082                	ret

0000000000005b0c <link>:
.global link
link:
 li a7, SYS_link
    5b0c:	48cd                	li	a7,19
 ecall
    5b0e:	00000073          	ecall
 ret
    5b12:	8082                	ret

0000000000005b14 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5b14:	48d1                	li	a7,20
 ecall
    5b16:	00000073          	ecall
 ret
    5b1a:	8082                	ret

0000000000005b1c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5b1c:	48a5                	li	a7,9
 ecall
    5b1e:	00000073          	ecall
 ret
    5b22:	8082                	ret

0000000000005b24 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5b24:	48a9                	li	a7,10
 ecall
    5b26:	00000073          	ecall
 ret
    5b2a:	8082                	ret

0000000000005b2c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5b2c:	48ad                	li	a7,11
 ecall
    5b2e:	00000073          	ecall
 ret
    5b32:	8082                	ret

0000000000005b34 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5b34:	48b1                	li	a7,12
 ecall
    5b36:	00000073          	ecall
 ret
    5b3a:	8082                	ret

0000000000005b3c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5b3c:	48b5                	li	a7,13
 ecall
    5b3e:	00000073          	ecall
 ret
    5b42:	8082                	ret

0000000000005b44 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5b44:	48b9                	li	a7,14
 ecall
    5b46:	00000073          	ecall
 ret
    5b4a:	8082                	ret

0000000000005b4c <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
    5b4c:	48d9                	li	a7,22
 ecall
    5b4e:	00000073          	ecall
 ret
    5b52:	8082                	ret

0000000000005b54 <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
    5b54:	48dd                	li	a7,23
 ecall
    5b56:	00000073          	ecall
 ret
    5b5a:	8082                	ret

0000000000005b5c <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
    5b5c:	48e1                	li	a7,24
 ecall
    5b5e:	00000073          	ecall
 ret
    5b62:	8082                	ret

0000000000005b64 <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
    5b64:	48ed                	li	a7,27
 ecall
    5b66:	00000073          	ecall
 ret
    5b6a:	8082                	ret

0000000000005b6c <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
    5b6c:	48f1                	li	a7,28
 ecall
    5b6e:	00000073          	ecall
 ret
    5b72:	8082                	ret

0000000000005b74 <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
    5b74:	48e9                	li	a7,26
 ecall
    5b76:	00000073          	ecall
 ret
    5b7a:	8082                	ret

0000000000005b7c <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
    5b7c:	48e5                	li	a7,25
 ecall
    5b7e:	00000073          	ecall
 ret
    5b82:	8082                	ret

0000000000005b84 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
    5b84:	48f5                	li	a7,29
 ecall
    5b86:	00000073          	ecall
 ret
    5b8a:	8082                	ret

0000000000005b8c <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
    5b8c:	48f9                	li	a7,30
 ecall
    5b8e:	00000073          	ecall
 ret
    5b92:	8082                	ret

0000000000005b94 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
    5b94:	48fd                	li	a7,31
 ecall
    5b96:	00000073          	ecall
 ret
    5b9a:	8082                	ret

0000000000005b9c <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
    5b9c:	02000893          	li	a7,32
 ecall
    5ba0:	00000073          	ecall
 ret
    5ba4:	8082                	ret

0000000000005ba6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5ba6:	1101                	addi	sp,sp,-32
    5ba8:	ec06                	sd	ra,24(sp)
    5baa:	e822                	sd	s0,16(sp)
    5bac:	1000                	addi	s0,sp,32
    5bae:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5bb2:	4605                	li	a2,1
    5bb4:	fef40593          	addi	a1,s0,-17
    5bb8:	00000097          	auipc	ra,0x0
    5bbc:	f14080e7          	jalr	-236(ra) # 5acc <write>
}
    5bc0:	60e2                	ld	ra,24(sp)
    5bc2:	6442                	ld	s0,16(sp)
    5bc4:	6105                	addi	sp,sp,32
    5bc6:	8082                	ret

0000000000005bc8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5bc8:	7139                	addi	sp,sp,-64
    5bca:	fc06                	sd	ra,56(sp)
    5bcc:	f822                	sd	s0,48(sp)
    5bce:	f426                	sd	s1,40(sp)
    5bd0:	f04a                	sd	s2,32(sp)
    5bd2:	ec4e                	sd	s3,24(sp)
    5bd4:	0080                	addi	s0,sp,64
    5bd6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5bd8:	c299                	beqz	a3,5bde <printint+0x16>
    5bda:	0805c863          	bltz	a1,5c6a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5bde:	2581                	sext.w	a1,a1
  neg = 0;
    5be0:	4881                	li	a7,0
    5be2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5be6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5be8:	2601                	sext.w	a2,a2
    5bea:	00003517          	auipc	a0,0x3
    5bee:	ca650513          	addi	a0,a0,-858 # 8890 <digits>
    5bf2:	883a                	mv	a6,a4
    5bf4:	2705                	addiw	a4,a4,1
    5bf6:	02c5f7bb          	remuw	a5,a1,a2
    5bfa:	1782                	slli	a5,a5,0x20
    5bfc:	9381                	srli	a5,a5,0x20
    5bfe:	97aa                	add	a5,a5,a0
    5c00:	0007c783          	lbu	a5,0(a5)
    5c04:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5c08:	0005879b          	sext.w	a5,a1
    5c0c:	02c5d5bb          	divuw	a1,a1,a2
    5c10:	0685                	addi	a3,a3,1
    5c12:	fec7f0e3          	bgeu	a5,a2,5bf2 <printint+0x2a>
  if(neg)
    5c16:	00088b63          	beqz	a7,5c2c <printint+0x64>
    buf[i++] = '-';
    5c1a:	fd040793          	addi	a5,s0,-48
    5c1e:	973e                	add	a4,a4,a5
    5c20:	02d00793          	li	a5,45
    5c24:	fef70823          	sb	a5,-16(a4)
    5c28:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5c2c:	02e05863          	blez	a4,5c5c <printint+0x94>
    5c30:	fc040793          	addi	a5,s0,-64
    5c34:	00e78933          	add	s2,a5,a4
    5c38:	fff78993          	addi	s3,a5,-1
    5c3c:	99ba                	add	s3,s3,a4
    5c3e:	377d                	addiw	a4,a4,-1
    5c40:	1702                	slli	a4,a4,0x20
    5c42:	9301                	srli	a4,a4,0x20
    5c44:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5c48:	fff94583          	lbu	a1,-1(s2)
    5c4c:	8526                	mv	a0,s1
    5c4e:	00000097          	auipc	ra,0x0
    5c52:	f58080e7          	jalr	-168(ra) # 5ba6 <putc>
  while(--i >= 0)
    5c56:	197d                	addi	s2,s2,-1
    5c58:	ff3918e3          	bne	s2,s3,5c48 <printint+0x80>
}
    5c5c:	70e2                	ld	ra,56(sp)
    5c5e:	7442                	ld	s0,48(sp)
    5c60:	74a2                	ld	s1,40(sp)
    5c62:	7902                	ld	s2,32(sp)
    5c64:	69e2                	ld	s3,24(sp)
    5c66:	6121                	addi	sp,sp,64
    5c68:	8082                	ret
    x = -xx;
    5c6a:	40b005bb          	negw	a1,a1
    neg = 1;
    5c6e:	4885                	li	a7,1
    x = -xx;
    5c70:	bf8d                	j	5be2 <printint+0x1a>

0000000000005c72 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5c72:	7119                	addi	sp,sp,-128
    5c74:	fc86                	sd	ra,120(sp)
    5c76:	f8a2                	sd	s0,112(sp)
    5c78:	f4a6                	sd	s1,104(sp)
    5c7a:	f0ca                	sd	s2,96(sp)
    5c7c:	ecce                	sd	s3,88(sp)
    5c7e:	e8d2                	sd	s4,80(sp)
    5c80:	e4d6                	sd	s5,72(sp)
    5c82:	e0da                	sd	s6,64(sp)
    5c84:	fc5e                	sd	s7,56(sp)
    5c86:	f862                	sd	s8,48(sp)
    5c88:	f466                	sd	s9,40(sp)
    5c8a:	f06a                	sd	s10,32(sp)
    5c8c:	ec6e                	sd	s11,24(sp)
    5c8e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5c90:	0005c903          	lbu	s2,0(a1)
    5c94:	18090f63          	beqz	s2,5e32 <vprintf+0x1c0>
    5c98:	8aaa                	mv	s5,a0
    5c9a:	8b32                	mv	s6,a2
    5c9c:	00158493          	addi	s1,a1,1
  state = 0;
    5ca0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5ca2:	02500a13          	li	s4,37
      if(c == 'd'){
    5ca6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5caa:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5cae:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5cb2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5cb6:	00003b97          	auipc	s7,0x3
    5cba:	bdab8b93          	addi	s7,s7,-1062 # 8890 <digits>
    5cbe:	a839                	j	5cdc <vprintf+0x6a>
        putc(fd, c);
    5cc0:	85ca                	mv	a1,s2
    5cc2:	8556                	mv	a0,s5
    5cc4:	00000097          	auipc	ra,0x0
    5cc8:	ee2080e7          	jalr	-286(ra) # 5ba6 <putc>
    5ccc:	a019                	j	5cd2 <vprintf+0x60>
    } else if(state == '%'){
    5cce:	01498f63          	beq	s3,s4,5cec <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5cd2:	0485                	addi	s1,s1,1
    5cd4:	fff4c903          	lbu	s2,-1(s1)
    5cd8:	14090d63          	beqz	s2,5e32 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5cdc:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5ce0:	fe0997e3          	bnez	s3,5cce <vprintf+0x5c>
      if(c == '%'){
    5ce4:	fd479ee3          	bne	a5,s4,5cc0 <vprintf+0x4e>
        state = '%';
    5ce8:	89be                	mv	s3,a5
    5cea:	b7e5                	j	5cd2 <vprintf+0x60>
      if(c == 'd'){
    5cec:	05878063          	beq	a5,s8,5d2c <vprintf+0xba>
      } else if(c == 'l') {
    5cf0:	05978c63          	beq	a5,s9,5d48 <vprintf+0xd6>
      } else if(c == 'x') {
    5cf4:	07a78863          	beq	a5,s10,5d64 <vprintf+0xf2>
      } else if(c == 'p') {
    5cf8:	09b78463          	beq	a5,s11,5d80 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5cfc:	07300713          	li	a4,115
    5d00:	0ce78663          	beq	a5,a4,5dcc <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5d04:	06300713          	li	a4,99
    5d08:	0ee78e63          	beq	a5,a4,5e04 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5d0c:	11478863          	beq	a5,s4,5e1c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5d10:	85d2                	mv	a1,s4
    5d12:	8556                	mv	a0,s5
    5d14:	00000097          	auipc	ra,0x0
    5d18:	e92080e7          	jalr	-366(ra) # 5ba6 <putc>
        putc(fd, c);
    5d1c:	85ca                	mv	a1,s2
    5d1e:	8556                	mv	a0,s5
    5d20:	00000097          	auipc	ra,0x0
    5d24:	e86080e7          	jalr	-378(ra) # 5ba6 <putc>
      }
      state = 0;
    5d28:	4981                	li	s3,0
    5d2a:	b765                	j	5cd2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5d2c:	008b0913          	addi	s2,s6,8
    5d30:	4685                	li	a3,1
    5d32:	4629                	li	a2,10
    5d34:	000b2583          	lw	a1,0(s6)
    5d38:	8556                	mv	a0,s5
    5d3a:	00000097          	auipc	ra,0x0
    5d3e:	e8e080e7          	jalr	-370(ra) # 5bc8 <printint>
    5d42:	8b4a                	mv	s6,s2
      state = 0;
    5d44:	4981                	li	s3,0
    5d46:	b771                	j	5cd2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5d48:	008b0913          	addi	s2,s6,8
    5d4c:	4681                	li	a3,0
    5d4e:	4629                	li	a2,10
    5d50:	000b2583          	lw	a1,0(s6)
    5d54:	8556                	mv	a0,s5
    5d56:	00000097          	auipc	ra,0x0
    5d5a:	e72080e7          	jalr	-398(ra) # 5bc8 <printint>
    5d5e:	8b4a                	mv	s6,s2
      state = 0;
    5d60:	4981                	li	s3,0
    5d62:	bf85                	j	5cd2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5d64:	008b0913          	addi	s2,s6,8
    5d68:	4681                	li	a3,0
    5d6a:	4641                	li	a2,16
    5d6c:	000b2583          	lw	a1,0(s6)
    5d70:	8556                	mv	a0,s5
    5d72:	00000097          	auipc	ra,0x0
    5d76:	e56080e7          	jalr	-426(ra) # 5bc8 <printint>
    5d7a:	8b4a                	mv	s6,s2
      state = 0;
    5d7c:	4981                	li	s3,0
    5d7e:	bf91                	j	5cd2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5d80:	008b0793          	addi	a5,s6,8
    5d84:	f8f43423          	sd	a5,-120(s0)
    5d88:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5d8c:	03000593          	li	a1,48
    5d90:	8556                	mv	a0,s5
    5d92:	00000097          	auipc	ra,0x0
    5d96:	e14080e7          	jalr	-492(ra) # 5ba6 <putc>
  putc(fd, 'x');
    5d9a:	85ea                	mv	a1,s10
    5d9c:	8556                	mv	a0,s5
    5d9e:	00000097          	auipc	ra,0x0
    5da2:	e08080e7          	jalr	-504(ra) # 5ba6 <putc>
    5da6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5da8:	03c9d793          	srli	a5,s3,0x3c
    5dac:	97de                	add	a5,a5,s7
    5dae:	0007c583          	lbu	a1,0(a5)
    5db2:	8556                	mv	a0,s5
    5db4:	00000097          	auipc	ra,0x0
    5db8:	df2080e7          	jalr	-526(ra) # 5ba6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5dbc:	0992                	slli	s3,s3,0x4
    5dbe:	397d                	addiw	s2,s2,-1
    5dc0:	fe0914e3          	bnez	s2,5da8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5dc4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5dc8:	4981                	li	s3,0
    5dca:	b721                	j	5cd2 <vprintf+0x60>
        s = va_arg(ap, char*);
    5dcc:	008b0993          	addi	s3,s6,8
    5dd0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5dd4:	02090163          	beqz	s2,5df6 <vprintf+0x184>
        while(*s != 0){
    5dd8:	00094583          	lbu	a1,0(s2)
    5ddc:	c9a1                	beqz	a1,5e2c <vprintf+0x1ba>
          putc(fd, *s);
    5dde:	8556                	mv	a0,s5
    5de0:	00000097          	auipc	ra,0x0
    5de4:	dc6080e7          	jalr	-570(ra) # 5ba6 <putc>
          s++;
    5de8:	0905                	addi	s2,s2,1
        while(*s != 0){
    5dea:	00094583          	lbu	a1,0(s2)
    5dee:	f9e5                	bnez	a1,5dde <vprintf+0x16c>
        s = va_arg(ap, char*);
    5df0:	8b4e                	mv	s6,s3
      state = 0;
    5df2:	4981                	li	s3,0
    5df4:	bdf9                	j	5cd2 <vprintf+0x60>
          s = "(null)";
    5df6:	00003917          	auipc	s2,0x3
    5dfa:	a9290913          	addi	s2,s2,-1390 # 8888 <csem_free+0x2774>
        while(*s != 0){
    5dfe:	02800593          	li	a1,40
    5e02:	bff1                	j	5dde <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5e04:	008b0913          	addi	s2,s6,8
    5e08:	000b4583          	lbu	a1,0(s6)
    5e0c:	8556                	mv	a0,s5
    5e0e:	00000097          	auipc	ra,0x0
    5e12:	d98080e7          	jalr	-616(ra) # 5ba6 <putc>
    5e16:	8b4a                	mv	s6,s2
      state = 0;
    5e18:	4981                	li	s3,0
    5e1a:	bd65                	j	5cd2 <vprintf+0x60>
        putc(fd, c);
    5e1c:	85d2                	mv	a1,s4
    5e1e:	8556                	mv	a0,s5
    5e20:	00000097          	auipc	ra,0x0
    5e24:	d86080e7          	jalr	-634(ra) # 5ba6 <putc>
      state = 0;
    5e28:	4981                	li	s3,0
    5e2a:	b565                	j	5cd2 <vprintf+0x60>
        s = va_arg(ap, char*);
    5e2c:	8b4e                	mv	s6,s3
      state = 0;
    5e2e:	4981                	li	s3,0
    5e30:	b54d                	j	5cd2 <vprintf+0x60>
    }
  }
}
    5e32:	70e6                	ld	ra,120(sp)
    5e34:	7446                	ld	s0,112(sp)
    5e36:	74a6                	ld	s1,104(sp)
    5e38:	7906                	ld	s2,96(sp)
    5e3a:	69e6                	ld	s3,88(sp)
    5e3c:	6a46                	ld	s4,80(sp)
    5e3e:	6aa6                	ld	s5,72(sp)
    5e40:	6b06                	ld	s6,64(sp)
    5e42:	7be2                	ld	s7,56(sp)
    5e44:	7c42                	ld	s8,48(sp)
    5e46:	7ca2                	ld	s9,40(sp)
    5e48:	7d02                	ld	s10,32(sp)
    5e4a:	6de2                	ld	s11,24(sp)
    5e4c:	6109                	addi	sp,sp,128
    5e4e:	8082                	ret

0000000000005e50 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5e50:	715d                	addi	sp,sp,-80
    5e52:	ec06                	sd	ra,24(sp)
    5e54:	e822                	sd	s0,16(sp)
    5e56:	1000                	addi	s0,sp,32
    5e58:	e010                	sd	a2,0(s0)
    5e5a:	e414                	sd	a3,8(s0)
    5e5c:	e818                	sd	a4,16(s0)
    5e5e:	ec1c                	sd	a5,24(s0)
    5e60:	03043023          	sd	a6,32(s0)
    5e64:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5e68:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5e6c:	8622                	mv	a2,s0
    5e6e:	00000097          	auipc	ra,0x0
    5e72:	e04080e7          	jalr	-508(ra) # 5c72 <vprintf>
}
    5e76:	60e2                	ld	ra,24(sp)
    5e78:	6442                	ld	s0,16(sp)
    5e7a:	6161                	addi	sp,sp,80
    5e7c:	8082                	ret

0000000000005e7e <printf>:

void
printf(const char *fmt, ...)
{
    5e7e:	711d                	addi	sp,sp,-96
    5e80:	ec06                	sd	ra,24(sp)
    5e82:	e822                	sd	s0,16(sp)
    5e84:	1000                	addi	s0,sp,32
    5e86:	e40c                	sd	a1,8(s0)
    5e88:	e810                	sd	a2,16(s0)
    5e8a:	ec14                	sd	a3,24(s0)
    5e8c:	f018                	sd	a4,32(s0)
    5e8e:	f41c                	sd	a5,40(s0)
    5e90:	03043823          	sd	a6,48(s0)
    5e94:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5e98:	00840613          	addi	a2,s0,8
    5e9c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5ea0:	85aa                	mv	a1,a0
    5ea2:	4505                	li	a0,1
    5ea4:	00000097          	auipc	ra,0x0
    5ea8:	dce080e7          	jalr	-562(ra) # 5c72 <vprintf>
}
    5eac:	60e2                	ld	ra,24(sp)
    5eae:	6442                	ld	s0,16(sp)
    5eb0:	6125                	addi	sp,sp,96
    5eb2:	8082                	ret

0000000000005eb4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5eb4:	1141                	addi	sp,sp,-16
    5eb6:	e422                	sd	s0,8(sp)
    5eb8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5eba:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5ebe:	00003797          	auipc	a5,0x3
    5ec2:	a027b783          	ld	a5,-1534(a5) # 88c0 <freep>
    5ec6:	a805                	j	5ef6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5ec8:	4618                	lw	a4,8(a2)
    5eca:	9db9                	addw	a1,a1,a4
    5ecc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5ed0:	6398                	ld	a4,0(a5)
    5ed2:	6318                	ld	a4,0(a4)
    5ed4:	fee53823          	sd	a4,-16(a0)
    5ed8:	a091                	j	5f1c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5eda:	ff852703          	lw	a4,-8(a0)
    5ede:	9e39                	addw	a2,a2,a4
    5ee0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5ee2:	ff053703          	ld	a4,-16(a0)
    5ee6:	e398                	sd	a4,0(a5)
    5ee8:	a099                	j	5f2e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5eea:	6398                	ld	a4,0(a5)
    5eec:	00e7e463          	bltu	a5,a4,5ef4 <free+0x40>
    5ef0:	00e6ea63          	bltu	a3,a4,5f04 <free+0x50>
{
    5ef4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5ef6:	fed7fae3          	bgeu	a5,a3,5eea <free+0x36>
    5efa:	6398                	ld	a4,0(a5)
    5efc:	00e6e463          	bltu	a3,a4,5f04 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5f00:	fee7eae3          	bltu	a5,a4,5ef4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5f04:	ff852583          	lw	a1,-8(a0)
    5f08:	6390                	ld	a2,0(a5)
    5f0a:	02059813          	slli	a6,a1,0x20
    5f0e:	01c85713          	srli	a4,a6,0x1c
    5f12:	9736                	add	a4,a4,a3
    5f14:	fae60ae3          	beq	a2,a4,5ec8 <free+0x14>
    bp->s.ptr = p->s.ptr;
    5f18:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5f1c:	4790                	lw	a2,8(a5)
    5f1e:	02061593          	slli	a1,a2,0x20
    5f22:	01c5d713          	srli	a4,a1,0x1c
    5f26:	973e                	add	a4,a4,a5
    5f28:	fae689e3          	beq	a3,a4,5eda <free+0x26>
  } else
    p->s.ptr = bp;
    5f2c:	e394                	sd	a3,0(a5)
  freep = p;
    5f2e:	00003717          	auipc	a4,0x3
    5f32:	98f73923          	sd	a5,-1646(a4) # 88c0 <freep>
}
    5f36:	6422                	ld	s0,8(sp)
    5f38:	0141                	addi	sp,sp,16
    5f3a:	8082                	ret

0000000000005f3c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5f3c:	7139                	addi	sp,sp,-64
    5f3e:	fc06                	sd	ra,56(sp)
    5f40:	f822                	sd	s0,48(sp)
    5f42:	f426                	sd	s1,40(sp)
    5f44:	f04a                	sd	s2,32(sp)
    5f46:	ec4e                	sd	s3,24(sp)
    5f48:	e852                	sd	s4,16(sp)
    5f4a:	e456                	sd	s5,8(sp)
    5f4c:	e05a                	sd	s6,0(sp)
    5f4e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5f50:	02051493          	slli	s1,a0,0x20
    5f54:	9081                	srli	s1,s1,0x20
    5f56:	04bd                	addi	s1,s1,15
    5f58:	8091                	srli	s1,s1,0x4
    5f5a:	0014899b          	addiw	s3,s1,1
    5f5e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5f60:	00003517          	auipc	a0,0x3
    5f64:	96053503          	ld	a0,-1696(a0) # 88c0 <freep>
    5f68:	c515                	beqz	a0,5f94 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5f6a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5f6c:	4798                	lw	a4,8(a5)
    5f6e:	02977f63          	bgeu	a4,s1,5fac <malloc+0x70>
    5f72:	8a4e                	mv	s4,s3
    5f74:	0009871b          	sext.w	a4,s3
    5f78:	6685                	lui	a3,0x1
    5f7a:	00d77363          	bgeu	a4,a3,5f80 <malloc+0x44>
    5f7e:	6a05                	lui	s4,0x1
    5f80:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5f84:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5f88:	00003917          	auipc	s2,0x3
    5f8c:	93890913          	addi	s2,s2,-1736 # 88c0 <freep>
  if(p == (char*)-1)
    5f90:	5afd                	li	s5,-1
    5f92:	a895                	j	6006 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    5f94:	00009797          	auipc	a5,0x9
    5f98:	14c78793          	addi	a5,a5,332 # f0e0 <base>
    5f9c:	00003717          	auipc	a4,0x3
    5fa0:	92f73223          	sd	a5,-1756(a4) # 88c0 <freep>
    5fa4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5fa6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5faa:	b7e1                	j	5f72 <malloc+0x36>
      if(p->s.size == nunits)
    5fac:	02e48c63          	beq	s1,a4,5fe4 <malloc+0xa8>
        p->s.size -= nunits;
    5fb0:	4137073b          	subw	a4,a4,s3
    5fb4:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5fb6:	02071693          	slli	a3,a4,0x20
    5fba:	01c6d713          	srli	a4,a3,0x1c
    5fbe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5fc0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5fc4:	00003717          	auipc	a4,0x3
    5fc8:	8ea73e23          	sd	a0,-1796(a4) # 88c0 <freep>
      return (void*)(p + 1);
    5fcc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5fd0:	70e2                	ld	ra,56(sp)
    5fd2:	7442                	ld	s0,48(sp)
    5fd4:	74a2                	ld	s1,40(sp)
    5fd6:	7902                	ld	s2,32(sp)
    5fd8:	69e2                	ld	s3,24(sp)
    5fda:	6a42                	ld	s4,16(sp)
    5fdc:	6aa2                	ld	s5,8(sp)
    5fde:	6b02                	ld	s6,0(sp)
    5fe0:	6121                	addi	sp,sp,64
    5fe2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5fe4:	6398                	ld	a4,0(a5)
    5fe6:	e118                	sd	a4,0(a0)
    5fe8:	bff1                	j	5fc4 <malloc+0x88>
  hp->s.size = nu;
    5fea:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5fee:	0541                	addi	a0,a0,16
    5ff0:	00000097          	auipc	ra,0x0
    5ff4:	ec4080e7          	jalr	-316(ra) # 5eb4 <free>
  return freep;
    5ff8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5ffc:	d971                	beqz	a0,5fd0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5ffe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6000:	4798                	lw	a4,8(a5)
    6002:	fa9775e3          	bgeu	a4,s1,5fac <malloc+0x70>
    if(p == freep)
    6006:	00093703          	ld	a4,0(s2)
    600a:	853e                	mv	a0,a5
    600c:	fef719e3          	bne	a4,a5,5ffe <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    6010:	8552                	mv	a0,s4
    6012:	00000097          	auipc	ra,0x0
    6016:	b22080e7          	jalr	-1246(ra) # 5b34 <sbrk>
  if(p == (char*)-1)
    601a:	fd5518e3          	bne	a0,s5,5fea <malloc+0xae>
        return 0;
    601e:	4501                	li	a0,0
    6020:	bf45                	j	5fd0 <malloc+0x94>

0000000000006022 <csem_down>:
#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"


void csem_down(struct counting_semaphore *sem) {
    6022:	1101                	addi	sp,sp,-32
    6024:	ec06                	sd	ra,24(sp)
    6026:	e822                	sd	s0,16(sp)
    6028:	e426                	sd	s1,8(sp)
    602a:	1000                	addi	s0,sp,32
    602c:	84aa                	mv	s1,a0
    bsem_down(sem->bsem2);
    602e:	4148                	lw	a0,4(a0)
    6030:	00000097          	auipc	ra,0x0
    6034:	b34080e7          	jalr	-1228(ra) # 5b64 <bsem_down>
    bsem_down(sem->bsem1);
    6038:	4088                	lw	a0,0(s1)
    603a:	00000097          	auipc	ra,0x0
    603e:	b2a080e7          	jalr	-1238(ra) # 5b64 <bsem_down>
    sem->count -= 1;
    6042:	449c                	lw	a5,8(s1)
    6044:	37fd                	addiw	a5,a5,-1
    6046:	0007871b          	sext.w	a4,a5
    604a:	c49c                	sw	a5,8(s1)
    if (sem->count > 0)
    604c:	00e04c63          	bgtz	a4,6064 <csem_down+0x42>
    	bsem_up(sem->bsem2);
    bsem_up(sem->bsem1);
    6050:	4088                	lw	a0,0(s1)
    6052:	00000097          	auipc	ra,0x0
    6056:	b1a080e7          	jalr	-1254(ra) # 5b6c <bsem_up>
}
    605a:	60e2                	ld	ra,24(sp)
    605c:	6442                	ld	s0,16(sp)
    605e:	64a2                	ld	s1,8(sp)
    6060:	6105                	addi	sp,sp,32
    6062:	8082                	ret
    	bsem_up(sem->bsem2);
    6064:	40c8                	lw	a0,4(s1)
    6066:	00000097          	auipc	ra,0x0
    606a:	b06080e7          	jalr	-1274(ra) # 5b6c <bsem_up>
    606e:	b7cd                	j	6050 <csem_down+0x2e>

0000000000006070 <csem_up>:


void csem_up(struct counting_semaphore *sem) {
    6070:	1101                	addi	sp,sp,-32
    6072:	ec06                	sd	ra,24(sp)
    6074:	e822                	sd	s0,16(sp)
    6076:	e426                	sd	s1,8(sp)
    6078:	1000                	addi	s0,sp,32
    607a:	84aa                	mv	s1,a0
	bsem_down(sem->bsem1);
    607c:	4108                	lw	a0,0(a0)
    607e:	00000097          	auipc	ra,0x0
    6082:	ae6080e7          	jalr	-1306(ra) # 5b64 <bsem_down>
	sem->count += 1;
    6086:	449c                	lw	a5,8(s1)
    6088:	2785                	addiw	a5,a5,1
    608a:	0007871b          	sext.w	a4,a5
    608e:	c49c                	sw	a5,8(s1)
	if (sem->count == 1)
    6090:	4785                	li	a5,1
    6092:	00f70c63          	beq	a4,a5,60aa <csem_up+0x3a>
		bsem_up(sem->bsem2);
	bsem_up(sem->bsem1);
    6096:	4088                	lw	a0,0(s1)
    6098:	00000097          	auipc	ra,0x0
    609c:	ad4080e7          	jalr	-1324(ra) # 5b6c <bsem_up>
}
    60a0:	60e2                	ld	ra,24(sp)
    60a2:	6442                	ld	s0,16(sp)
    60a4:	64a2                	ld	s1,8(sp)
    60a6:	6105                	addi	sp,sp,32
    60a8:	8082                	ret
		bsem_up(sem->bsem2);
    60aa:	40c8                	lw	a0,4(s1)
    60ac:	00000097          	auipc	ra,0x0
    60b0:	ac0080e7          	jalr	-1344(ra) # 5b6c <bsem_up>
    60b4:	b7cd                	j	6096 <csem_up+0x26>

00000000000060b6 <csem_alloc>:


int csem_alloc(struct counting_semaphore *sem, int count) {
    60b6:	7179                	addi	sp,sp,-48
    60b8:	f406                	sd	ra,40(sp)
    60ba:	f022                	sd	s0,32(sp)
    60bc:	ec26                	sd	s1,24(sp)
    60be:	e84a                	sd	s2,16(sp)
    60c0:	e44e                	sd	s3,8(sp)
    60c2:	1800                	addi	s0,sp,48
    60c4:	892a                	mv	s2,a0
    60c6:	89ae                	mv	s3,a1
    int bsem1 = bsem_alloc();
    60c8:	00000097          	auipc	ra,0x0
    60cc:	ab4080e7          	jalr	-1356(ra) # 5b7c <bsem_alloc>
    60d0:	84aa                	mv	s1,a0
    int bsem2 = bsem_alloc();
    60d2:	00000097          	auipc	ra,0x0
    60d6:	aaa080e7          	jalr	-1366(ra) # 5b7c <bsem_alloc>
    if (bsem1 == -1 || bsem2 == -1)
    60da:	57fd                	li	a5,-1
    60dc:	00f48d63          	beq	s1,a5,60f6 <csem_alloc+0x40>
    60e0:	02f50863          	beq	a0,a5,6110 <csem_alloc+0x5a>
        return -1; 
    sem->bsem1 = bsem1;
    60e4:	00992023          	sw	s1,0(s2)
    sem->bsem2 = bsem2;
    60e8:	00a92223          	sw	a0,4(s2)
    if (count == 0)
    60ec:	00098d63          	beqz	s3,6106 <csem_alloc+0x50>
        // Binary semaphore first value = min(1, count)
        bsem_down(sem->bsem2); 
    sem->count = count;
    60f0:	01392423          	sw	s3,8(s2)
    return 0;
    60f4:	4481                	li	s1,0
}
    60f6:	8526                	mv	a0,s1
    60f8:	70a2                	ld	ra,40(sp)
    60fa:	7402                	ld	s0,32(sp)
    60fc:	64e2                	ld	s1,24(sp)
    60fe:	6942                	ld	s2,16(sp)
    6100:	69a2                	ld	s3,8(sp)
    6102:	6145                	addi	sp,sp,48
    6104:	8082                	ret
        bsem_down(sem->bsem2); 
    6106:	00000097          	auipc	ra,0x0
    610a:	a5e080e7          	jalr	-1442(ra) # 5b64 <bsem_down>
    610e:	b7cd                	j	60f0 <csem_alloc+0x3a>
        return -1; 
    6110:	84aa                	mv	s1,a0
    6112:	b7d5                	j	60f6 <csem_alloc+0x40>

0000000000006114 <csem_free>:


void csem_free(struct counting_semaphore *sem) {
    6114:	1101                	addi	sp,sp,-32
    6116:	ec06                	sd	ra,24(sp)
    6118:	e822                	sd	s0,16(sp)
    611a:	e426                	sd	s1,8(sp)
    611c:	1000                	addi	s0,sp,32
    611e:	84aa                	mv	s1,a0
    bsem_free(sem->bsem1);
    6120:	4108                	lw	a0,0(a0)
    6122:	00000097          	auipc	ra,0x0
    6126:	a52080e7          	jalr	-1454(ra) # 5b74 <bsem_free>
    bsem_free(sem->bsem2);
    612a:	40c8                	lw	a0,4(s1)
    612c:	00000097          	auipc	ra,0x0
    6130:	a48080e7          	jalr	-1464(ra) # 5b74 <bsem_free>
    free(sem);
    6134:	8526                	mv	a0,s1
    6136:	00000097          	auipc	ra,0x0
    613a:	d7e080e7          	jalr	-642(ra) # 5eb4 <free>
}
    613e:	60e2                	ld	ra,24(sp)
    6140:	6442                	ld	s0,16(sp)
    6142:	64a2                	ld	s1,8(sp)
    6144:	6105                	addi	sp,sp,32
    6146:	8082                	ret
