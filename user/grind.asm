
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <__global_pointer$+0x1d324>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <__global_pointer$+0x21ae>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <__global_pointer$+0xffffffffffffd4f3>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00001517          	auipc	a0,0x1
      64:	7a050513          	addi	a0,a0,1952 # 1800 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	e8ca                	sd	s2,80(sp)
      82:	e4ce                	sd	s3,72(sp)
      84:	e0d2                	sd	s4,64(sp)
      86:	fc56                	sd	s5,56(sp)
      88:	f85a                	sd	s6,48(sp)
      8a:	1880                	addi	s0,sp,112
      8c:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	f7a080e7          	jalr	-134(ra) # 100a <sbrk>
      98:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9a:	00001517          	auipc	a0,0x1
      9e:	45e50513          	addi	a0,a0,1118 # 14f8 <malloc+0xe6>
      a2:	00001097          	auipc	ra,0x1
      a6:	f48080e7          	jalr	-184(ra) # fea <mkdir>
  if(chdir("grindir") != 0){
      aa:	00001517          	auipc	a0,0x1
      ae:	44e50513          	addi	a0,a0,1102 # 14f8 <malloc+0xe6>
      b2:	00001097          	auipc	ra,0x1
      b6:	f40080e7          	jalr	-192(ra) # ff2 <chdir>
      ba:	cd11                	beqz	a0,d6 <go+0x5e>
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	44450513          	addi	a0,a0,1092 # 1500 <malloc+0xee>
      c4:	00001097          	auipc	ra,0x1
      c8:	290080e7          	jalr	656(ra) # 1354 <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	eb4080e7          	jalr	-332(ra) # f82 <exit>
  }
  chdir("/");
      d6:	00001517          	auipc	a0,0x1
      da:	44a50513          	addi	a0,a0,1098 # 1520 <malloc+0x10e>
      de:	00001097          	auipc	ra,0x1
      e2:	f14080e7          	jalr	-236(ra) # ff2 <chdir>
  
  while(1){
    iters++;
    if((iters % 500) == 0)
      e6:	00001997          	auipc	s3,0x1
      ea:	44a98993          	addi	s3,s3,1098 # 1530 <malloc+0x11e>
      ee:	c489                	beqz	s1,f8 <go+0x80>
      f0:	00001997          	auipc	s3,0x1
      f4:	43898993          	addi	s3,s3,1080 # 1528 <malloc+0x116>
    iters++;
      f8:	4485                	li	s1,1
  int fd = -1;
      fa:	597d                	li	s2,-1
      close(fd);
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
      fc:	00001a17          	auipc	s4,0x1
     100:	714a0a13          	addi	s4,s4,1812 # 1810 <buf.0>
     104:	a825                	j	13c <go+0xc4>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     106:	20200593          	li	a1,514
     10a:	00001517          	auipc	a0,0x1
     10e:	42e50513          	addi	a0,a0,1070 # 1538 <malloc+0x126>
     112:	00001097          	auipc	ra,0x1
     116:	eb0080e7          	jalr	-336(ra) # fc2 <open>
     11a:	00001097          	auipc	ra,0x1
     11e:	e90080e7          	jalr	-368(ra) # faa <close>
    iters++;
     122:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     124:	1f400793          	li	a5,500
     128:	02f4f7b3          	remu	a5,s1,a5
     12c:	eb81                	bnez	a5,13c <go+0xc4>
      write(1, which_child?"B":"A", 1);
     12e:	4605                	li	a2,1
     130:	85ce                	mv	a1,s3
     132:	4505                	li	a0,1
     134:	00001097          	auipc	ra,0x1
     138:	e6e080e7          	jalr	-402(ra) # fa2 <write>
    int what = rand() % 23;
     13c:	00000097          	auipc	ra,0x0
     140:	f1c080e7          	jalr	-228(ra) # 58 <rand>
     144:	47dd                	li	a5,23
     146:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     14a:	4785                	li	a5,1
     14c:	faf50de3          	beq	a0,a5,106 <go+0x8e>
    } else if(what == 2){
     150:	4789                	li	a5,2
     152:	18f50563          	beq	a0,a5,2dc <go+0x264>
    } else if(what == 3){
     156:	478d                	li	a5,3
     158:	1af50163          	beq	a0,a5,2fa <go+0x282>
    } else if(what == 4){
     15c:	4791                	li	a5,4
     15e:	1af50763          	beq	a0,a5,30c <go+0x294>
    } else if(what == 5){
     162:	4795                	li	a5,5
     164:	1ef50b63          	beq	a0,a5,35a <go+0x2e2>
    } else if(what == 6){
     168:	4799                	li	a5,6
     16a:	20f50963          	beq	a0,a5,37c <go+0x304>
    } else if(what == 7){
     16e:	479d                	li	a5,7
     170:	22f50763          	beq	a0,a5,39e <go+0x326>
    } else if(what == 8){
     174:	47a1                	li	a5,8
     176:	22f50d63          	beq	a0,a5,3b0 <go+0x338>
    } else if(what == 9){
     17a:	47a5                	li	a5,9
     17c:	24f50363          	beq	a0,a5,3c2 <go+0x34a>
      mkdir("grindir/../a");
      close(open("a/../a/./a", O_CREATE|O_RDWR));
      unlink("a/a");
    } else if(what == 10){
     180:	47a9                	li	a5,10
     182:	26f50f63          	beq	a0,a5,400 <go+0x388>
      mkdir("/../b");
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
      unlink("b/b");
    } else if(what == 11){
     186:	47ad                	li	a5,11
     188:	2af50b63          	beq	a0,a5,43e <go+0x3c6>
      unlink("b");
      link("../grindir/./../a", "../b");
    } else if(what == 12){
     18c:	47b1                	li	a5,12
     18e:	2cf50d63          	beq	a0,a5,468 <go+0x3f0>
      unlink("../grindir/../a");
      link(".././b", "/grindir/../a");
    } else if(what == 13){
     192:	47b5                	li	a5,13
     194:	2ef50f63          	beq	a0,a5,492 <go+0x41a>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 14){
     198:	47b9                	li	a5,14
     19a:	32f50a63          	beq	a0,a5,4ce <go+0x456>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 15){
     19e:	47bd                	li	a5,15
     1a0:	36f50e63          	beq	a0,a5,51c <go+0x4a4>
      sbrk(6011);
    } else if(what == 16){
     1a4:	47c1                	li	a5,16
     1a6:	38f50363          	beq	a0,a5,52c <go+0x4b4>
      if(sbrk(0) > break0)
        sbrk(-(sbrk(0) - break0));
    } else if(what == 17){
     1aa:	47c5                	li	a5,17
     1ac:	3af50363          	beq	a0,a5,552 <go+0x4da>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid, SIGKILL);
      wait(0);
    } else if(what == 18){
     1b0:	47c9                	li	a5,18
     1b2:	42f50a63          	beq	a0,a5,5e6 <go+0x56e>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 19){
     1b6:	47cd                	li	a5,19
     1b8:	46f50f63          	beq	a0,a5,636 <go+0x5be>
        exit(1);
      }
      close(fds[0]);
      close(fds[1]);
      wait(0);
    } else if(what == 20){
     1bc:	47d1                	li	a5,20
     1be:	56f50063          	beq	a0,a5,71e <go+0x6a6>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 21){
     1c2:	47d5                	li	a5,21
     1c4:	5ef50e63          	beq	a0,a5,7c0 <go+0x748>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
      unlink("c");
    } else if(what == 22){
     1c8:	47d9                	li	a5,22
     1ca:	f4f51ce3          	bne	a0,a5,122 <go+0xaa>
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     1ce:	f9840513          	addi	a0,s0,-104
     1d2:	00001097          	auipc	ra,0x1
     1d6:	dc0080e7          	jalr	-576(ra) # f92 <pipe>
     1da:	6e054763          	bltz	a0,8c8 <go+0x850>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     1de:	fa040513          	addi	a0,s0,-96
     1e2:	00001097          	auipc	ra,0x1
     1e6:	db0080e7          	jalr	-592(ra) # f92 <pipe>
     1ea:	6e054d63          	bltz	a0,8e4 <go+0x86c>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     1ee:	00001097          	auipc	ra,0x1
     1f2:	d8c080e7          	jalr	-628(ra) # f7a <fork>
      if(pid1 == 0){
     1f6:	70050563          	beqz	a0,900 <go+0x888>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     1fa:	7a054d63          	bltz	a0,9b4 <go+0x93c>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     1fe:	00001097          	auipc	ra,0x1
     202:	d7c080e7          	jalr	-644(ra) # f7a <fork>
      if(pid2 == 0){
     206:	7c050563          	beqz	a0,9d0 <go+0x958>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     20a:	0a0541e3          	bltz	a0,aac <go+0xa34>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     20e:	f9842503          	lw	a0,-104(s0)
     212:	00001097          	auipc	ra,0x1
     216:	d98080e7          	jalr	-616(ra) # faa <close>
      close(aa[1]);
     21a:	f9c42503          	lw	a0,-100(s0)
     21e:	00001097          	auipc	ra,0x1
     222:	d8c080e7          	jalr	-628(ra) # faa <close>
      close(bb[1]);
     226:	fa442503          	lw	a0,-92(s0)
     22a:	00001097          	auipc	ra,0x1
     22e:	d80080e7          	jalr	-640(ra) # faa <close>
      char buf[4] = { 0, 0, 0, 0 };
     232:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     236:	4605                	li	a2,1
     238:	f9040593          	addi	a1,s0,-112
     23c:	fa042503          	lw	a0,-96(s0)
     240:	00001097          	auipc	ra,0x1
     244:	d5a080e7          	jalr	-678(ra) # f9a <read>
      read(bb[0], buf+1, 1);
     248:	4605                	li	a2,1
     24a:	f9140593          	addi	a1,s0,-111
     24e:	fa042503          	lw	a0,-96(s0)
     252:	00001097          	auipc	ra,0x1
     256:	d48080e7          	jalr	-696(ra) # f9a <read>
      read(bb[0], buf+2, 1);
     25a:	4605                	li	a2,1
     25c:	f9240593          	addi	a1,s0,-110
     260:	fa042503          	lw	a0,-96(s0)
     264:	00001097          	auipc	ra,0x1
     268:	d36080e7          	jalr	-714(ra) # f9a <read>
      close(bb[0]);
     26c:	fa042503          	lw	a0,-96(s0)
     270:	00001097          	auipc	ra,0x1
     274:	d3a080e7          	jalr	-710(ra) # faa <close>
      int st1, st2;
      wait(&st1);
     278:	f9440513          	addi	a0,s0,-108
     27c:	00001097          	auipc	ra,0x1
     280:	d0e080e7          	jalr	-754(ra) # f8a <wait>
      wait(&st2);
     284:	fa840513          	addi	a0,s0,-88
     288:	00001097          	auipc	ra,0x1
     28c:	d02080e7          	jalr	-766(ra) # f8a <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     290:	f9442783          	lw	a5,-108(s0)
     294:	fa842703          	lw	a4,-88(s0)
     298:	8fd9                	or	a5,a5,a4
     29a:	2781                	sext.w	a5,a5
     29c:	ef89                	bnez	a5,2b6 <go+0x23e>
     29e:	00001597          	auipc	a1,0x1
     2a2:	51258593          	addi	a1,a1,1298 # 17b0 <malloc+0x39e>
     2a6:	f9040513          	addi	a0,s0,-112
     2aa:	00001097          	auipc	ra,0x1
     2ae:	96a080e7          	jalr	-1686(ra) # c14 <strcmp>
     2b2:	e60508e3          	beqz	a0,122 <go+0xaa>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     2b6:	f9040693          	addi	a3,s0,-112
     2ba:	fa842603          	lw	a2,-88(s0)
     2be:	f9442583          	lw	a1,-108(s0)
     2c2:	00001517          	auipc	a0,0x1
     2c6:	4f650513          	addi	a0,a0,1270 # 17b8 <malloc+0x3a6>
     2ca:	00001097          	auipc	ra,0x1
     2ce:	08a080e7          	jalr	138(ra) # 1354 <printf>
        exit(1);
     2d2:	4505                	li	a0,1
     2d4:	00001097          	auipc	ra,0x1
     2d8:	cae080e7          	jalr	-850(ra) # f82 <exit>
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     2dc:	20200593          	li	a1,514
     2e0:	00001517          	auipc	a0,0x1
     2e4:	26850513          	addi	a0,a0,616 # 1548 <malloc+0x136>
     2e8:	00001097          	auipc	ra,0x1
     2ec:	cda080e7          	jalr	-806(ra) # fc2 <open>
     2f0:	00001097          	auipc	ra,0x1
     2f4:	cba080e7          	jalr	-838(ra) # faa <close>
     2f8:	b52d                	j	122 <go+0xaa>
      unlink("grindir/../a");
     2fa:	00001517          	auipc	a0,0x1
     2fe:	23e50513          	addi	a0,a0,574 # 1538 <malloc+0x126>
     302:	00001097          	auipc	ra,0x1
     306:	cd0080e7          	jalr	-816(ra) # fd2 <unlink>
     30a:	bd21                	j	122 <go+0xaa>
      if(chdir("grindir") != 0){
     30c:	00001517          	auipc	a0,0x1
     310:	1ec50513          	addi	a0,a0,492 # 14f8 <malloc+0xe6>
     314:	00001097          	auipc	ra,0x1
     318:	cde080e7          	jalr	-802(ra) # ff2 <chdir>
     31c:	e115                	bnez	a0,340 <go+0x2c8>
      unlink("../b");
     31e:	00001517          	auipc	a0,0x1
     322:	24250513          	addi	a0,a0,578 # 1560 <malloc+0x14e>
     326:	00001097          	auipc	ra,0x1
     32a:	cac080e7          	jalr	-852(ra) # fd2 <unlink>
      chdir("/");
     32e:	00001517          	auipc	a0,0x1
     332:	1f250513          	addi	a0,a0,498 # 1520 <malloc+0x10e>
     336:	00001097          	auipc	ra,0x1
     33a:	cbc080e7          	jalr	-836(ra) # ff2 <chdir>
     33e:	b3d5                	j	122 <go+0xaa>
        printf("grind: chdir grindir failed\n");
     340:	00001517          	auipc	a0,0x1
     344:	1c050513          	addi	a0,a0,448 # 1500 <malloc+0xee>
     348:	00001097          	auipc	ra,0x1
     34c:	00c080e7          	jalr	12(ra) # 1354 <printf>
        exit(1);
     350:	4505                	li	a0,1
     352:	00001097          	auipc	ra,0x1
     356:	c30080e7          	jalr	-976(ra) # f82 <exit>
      close(fd);
     35a:	854a                	mv	a0,s2
     35c:	00001097          	auipc	ra,0x1
     360:	c4e080e7          	jalr	-946(ra) # faa <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     364:	20200593          	li	a1,514
     368:	00001517          	auipc	a0,0x1
     36c:	20050513          	addi	a0,a0,512 # 1568 <malloc+0x156>
     370:	00001097          	auipc	ra,0x1
     374:	c52080e7          	jalr	-942(ra) # fc2 <open>
     378:	892a                	mv	s2,a0
     37a:	b365                	j	122 <go+0xaa>
      close(fd);
     37c:	854a                	mv	a0,s2
     37e:	00001097          	auipc	ra,0x1
     382:	c2c080e7          	jalr	-980(ra) # faa <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     386:	20200593          	li	a1,514
     38a:	00001517          	auipc	a0,0x1
     38e:	1ee50513          	addi	a0,a0,494 # 1578 <malloc+0x166>
     392:	00001097          	auipc	ra,0x1
     396:	c30080e7          	jalr	-976(ra) # fc2 <open>
     39a:	892a                	mv	s2,a0
     39c:	b359                	j	122 <go+0xaa>
      write(fd, buf, sizeof(buf));
     39e:	3e700613          	li	a2,999
     3a2:	85d2                	mv	a1,s4
     3a4:	854a                	mv	a0,s2
     3a6:	00001097          	auipc	ra,0x1
     3aa:	bfc080e7          	jalr	-1028(ra) # fa2 <write>
     3ae:	bb95                	j	122 <go+0xaa>
      read(fd, buf, sizeof(buf));
     3b0:	3e700613          	li	a2,999
     3b4:	85d2                	mv	a1,s4
     3b6:	854a                	mv	a0,s2
     3b8:	00001097          	auipc	ra,0x1
     3bc:	be2080e7          	jalr	-1054(ra) # f9a <read>
     3c0:	b38d                	j	122 <go+0xaa>
      mkdir("grindir/../a");
     3c2:	00001517          	auipc	a0,0x1
     3c6:	17650513          	addi	a0,a0,374 # 1538 <malloc+0x126>
     3ca:	00001097          	auipc	ra,0x1
     3ce:	c20080e7          	jalr	-992(ra) # fea <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     3d2:	20200593          	li	a1,514
     3d6:	00001517          	auipc	a0,0x1
     3da:	1ba50513          	addi	a0,a0,442 # 1590 <malloc+0x17e>
     3de:	00001097          	auipc	ra,0x1
     3e2:	be4080e7          	jalr	-1052(ra) # fc2 <open>
     3e6:	00001097          	auipc	ra,0x1
     3ea:	bc4080e7          	jalr	-1084(ra) # faa <close>
      unlink("a/a");
     3ee:	00001517          	auipc	a0,0x1
     3f2:	1b250513          	addi	a0,a0,434 # 15a0 <malloc+0x18e>
     3f6:	00001097          	auipc	ra,0x1
     3fa:	bdc080e7          	jalr	-1060(ra) # fd2 <unlink>
     3fe:	b315                	j	122 <go+0xaa>
      mkdir("/../b");
     400:	00001517          	auipc	a0,0x1
     404:	1a850513          	addi	a0,a0,424 # 15a8 <malloc+0x196>
     408:	00001097          	auipc	ra,0x1
     40c:	be2080e7          	jalr	-1054(ra) # fea <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     410:	20200593          	li	a1,514
     414:	00001517          	auipc	a0,0x1
     418:	19c50513          	addi	a0,a0,412 # 15b0 <malloc+0x19e>
     41c:	00001097          	auipc	ra,0x1
     420:	ba6080e7          	jalr	-1114(ra) # fc2 <open>
     424:	00001097          	auipc	ra,0x1
     428:	b86080e7          	jalr	-1146(ra) # faa <close>
      unlink("b/b");
     42c:	00001517          	auipc	a0,0x1
     430:	19450513          	addi	a0,a0,404 # 15c0 <malloc+0x1ae>
     434:	00001097          	auipc	ra,0x1
     438:	b9e080e7          	jalr	-1122(ra) # fd2 <unlink>
     43c:	b1dd                	j	122 <go+0xaa>
      unlink("b");
     43e:	00001517          	auipc	a0,0x1
     442:	14a50513          	addi	a0,a0,330 # 1588 <malloc+0x176>
     446:	00001097          	auipc	ra,0x1
     44a:	b8c080e7          	jalr	-1140(ra) # fd2 <unlink>
      link("../grindir/./../a", "../b");
     44e:	00001597          	auipc	a1,0x1
     452:	11258593          	addi	a1,a1,274 # 1560 <malloc+0x14e>
     456:	00001517          	auipc	a0,0x1
     45a:	17250513          	addi	a0,a0,370 # 15c8 <malloc+0x1b6>
     45e:	00001097          	auipc	ra,0x1
     462:	b84080e7          	jalr	-1148(ra) # fe2 <link>
     466:	b975                	j	122 <go+0xaa>
      unlink("../grindir/../a");
     468:	00001517          	auipc	a0,0x1
     46c:	17850513          	addi	a0,a0,376 # 15e0 <malloc+0x1ce>
     470:	00001097          	auipc	ra,0x1
     474:	b62080e7          	jalr	-1182(ra) # fd2 <unlink>
      link(".././b", "/grindir/../a");
     478:	00001597          	auipc	a1,0x1
     47c:	0f058593          	addi	a1,a1,240 # 1568 <malloc+0x156>
     480:	00001517          	auipc	a0,0x1
     484:	17050513          	addi	a0,a0,368 # 15f0 <malloc+0x1de>
     488:	00001097          	auipc	ra,0x1
     48c:	b5a080e7          	jalr	-1190(ra) # fe2 <link>
     490:	b949                	j	122 <go+0xaa>
      int pid = fork();
     492:	00001097          	auipc	ra,0x1
     496:	ae8080e7          	jalr	-1304(ra) # f7a <fork>
      if(pid == 0){
     49a:	c909                	beqz	a0,4ac <go+0x434>
      } else if(pid < 0){
     49c:	00054c63          	bltz	a0,4b4 <go+0x43c>
      wait(0);
     4a0:	4501                	li	a0,0
     4a2:	00001097          	auipc	ra,0x1
     4a6:	ae8080e7          	jalr	-1304(ra) # f8a <wait>
     4aa:	b9a5                	j	122 <go+0xaa>
        exit(0);
     4ac:	00001097          	auipc	ra,0x1
     4b0:	ad6080e7          	jalr	-1322(ra) # f82 <exit>
        printf("grind: fork failed\n");
     4b4:	00001517          	auipc	a0,0x1
     4b8:	14450513          	addi	a0,a0,324 # 15f8 <malloc+0x1e6>
     4bc:	00001097          	auipc	ra,0x1
     4c0:	e98080e7          	jalr	-360(ra) # 1354 <printf>
        exit(1);
     4c4:	4505                	li	a0,1
     4c6:	00001097          	auipc	ra,0x1
     4ca:	abc080e7          	jalr	-1348(ra) # f82 <exit>
      int pid = fork();
     4ce:	00001097          	auipc	ra,0x1
     4d2:	aac080e7          	jalr	-1364(ra) # f7a <fork>
      if(pid == 0){
     4d6:	c909                	beqz	a0,4e8 <go+0x470>
      } else if(pid < 0){
     4d8:	02054563          	bltz	a0,502 <go+0x48a>
      wait(0);
     4dc:	4501                	li	a0,0
     4de:	00001097          	auipc	ra,0x1
     4e2:	aac080e7          	jalr	-1364(ra) # f8a <wait>
     4e6:	b935                	j	122 <go+0xaa>
        fork();
     4e8:	00001097          	auipc	ra,0x1
     4ec:	a92080e7          	jalr	-1390(ra) # f7a <fork>
        fork();
     4f0:	00001097          	auipc	ra,0x1
     4f4:	a8a080e7          	jalr	-1398(ra) # f7a <fork>
        exit(0);
     4f8:	4501                	li	a0,0
     4fa:	00001097          	auipc	ra,0x1
     4fe:	a88080e7          	jalr	-1400(ra) # f82 <exit>
        printf("grind: fork failed\n");
     502:	00001517          	auipc	a0,0x1
     506:	0f650513          	addi	a0,a0,246 # 15f8 <malloc+0x1e6>
     50a:	00001097          	auipc	ra,0x1
     50e:	e4a080e7          	jalr	-438(ra) # 1354 <printf>
        exit(1);
     512:	4505                	li	a0,1
     514:	00001097          	auipc	ra,0x1
     518:	a6e080e7          	jalr	-1426(ra) # f82 <exit>
      sbrk(6011);
     51c:	6505                	lui	a0,0x1
     51e:	77b50513          	addi	a0,a0,1915 # 177b <malloc+0x369>
     522:	00001097          	auipc	ra,0x1
     526:	ae8080e7          	jalr	-1304(ra) # 100a <sbrk>
     52a:	bee5                	j	122 <go+0xaa>
      if(sbrk(0) > break0)
     52c:	4501                	li	a0,0
     52e:	00001097          	auipc	ra,0x1
     532:	adc080e7          	jalr	-1316(ra) # 100a <sbrk>
     536:	beaaf6e3          	bgeu	s5,a0,122 <go+0xaa>
        sbrk(-(sbrk(0) - break0));
     53a:	4501                	li	a0,0
     53c:	00001097          	auipc	ra,0x1
     540:	ace080e7          	jalr	-1330(ra) # 100a <sbrk>
     544:	40aa853b          	subw	a0,s5,a0
     548:	00001097          	auipc	ra,0x1
     54c:	ac2080e7          	jalr	-1342(ra) # 100a <sbrk>
     550:	bec9                	j	122 <go+0xaa>
      int pid = fork();
     552:	00001097          	auipc	ra,0x1
     556:	a28080e7          	jalr	-1496(ra) # f7a <fork>
     55a:	8b2a                	mv	s6,a0
      if(pid == 0){
     55c:	c905                	beqz	a0,58c <go+0x514>
      } else if(pid < 0){
     55e:	04054a63          	bltz	a0,5b2 <go+0x53a>
      if(chdir("../grindir/..") != 0){
     562:	00001517          	auipc	a0,0x1
     566:	0ae50513          	addi	a0,a0,174 # 1610 <malloc+0x1fe>
     56a:	00001097          	auipc	ra,0x1
     56e:	a88080e7          	jalr	-1400(ra) # ff2 <chdir>
     572:	ed29                	bnez	a0,5cc <go+0x554>
      kill(pid, SIGKILL);
     574:	45a5                	li	a1,9
     576:	855a                	mv	a0,s6
     578:	00001097          	auipc	ra,0x1
     57c:	a3a080e7          	jalr	-1478(ra) # fb2 <kill>
      wait(0);
     580:	4501                	li	a0,0
     582:	00001097          	auipc	ra,0x1
     586:	a08080e7          	jalr	-1528(ra) # f8a <wait>
     58a:	be61                	j	122 <go+0xaa>
        close(open("a", O_CREATE|O_RDWR));
     58c:	20200593          	li	a1,514
     590:	00001517          	auipc	a0,0x1
     594:	04850513          	addi	a0,a0,72 # 15d8 <malloc+0x1c6>
     598:	00001097          	auipc	ra,0x1
     59c:	a2a080e7          	jalr	-1494(ra) # fc2 <open>
     5a0:	00001097          	auipc	ra,0x1
     5a4:	a0a080e7          	jalr	-1526(ra) # faa <close>
        exit(0);
     5a8:	4501                	li	a0,0
     5aa:	00001097          	auipc	ra,0x1
     5ae:	9d8080e7          	jalr	-1576(ra) # f82 <exit>
        printf("grind: fork failed\n");
     5b2:	00001517          	auipc	a0,0x1
     5b6:	04650513          	addi	a0,a0,70 # 15f8 <malloc+0x1e6>
     5ba:	00001097          	auipc	ra,0x1
     5be:	d9a080e7          	jalr	-614(ra) # 1354 <printf>
        exit(1);
     5c2:	4505                	li	a0,1
     5c4:	00001097          	auipc	ra,0x1
     5c8:	9be080e7          	jalr	-1602(ra) # f82 <exit>
        printf("grind: chdir failed\n");
     5cc:	00001517          	auipc	a0,0x1
     5d0:	05450513          	addi	a0,a0,84 # 1620 <malloc+0x20e>
     5d4:	00001097          	auipc	ra,0x1
     5d8:	d80080e7          	jalr	-640(ra) # 1354 <printf>
        exit(1);
     5dc:	4505                	li	a0,1
     5de:	00001097          	auipc	ra,0x1
     5e2:	9a4080e7          	jalr	-1628(ra) # f82 <exit>
      int pid = fork();
     5e6:	00001097          	auipc	ra,0x1
     5ea:	994080e7          	jalr	-1644(ra) # f7a <fork>
      if(pid == 0){
     5ee:	c909                	beqz	a0,600 <go+0x588>
      } else if(pid < 0){
     5f0:	02054663          	bltz	a0,61c <go+0x5a4>
      wait(0);
     5f4:	4501                	li	a0,0
     5f6:	00001097          	auipc	ra,0x1
     5fa:	994080e7          	jalr	-1644(ra) # f8a <wait>
     5fe:	b615                	j	122 <go+0xaa>
        kill(getpid(), SIGKILL );
     600:	00001097          	auipc	ra,0x1
     604:	a02080e7          	jalr	-1534(ra) # 1002 <getpid>
     608:	45a5                	li	a1,9
     60a:	00001097          	auipc	ra,0x1
     60e:	9a8080e7          	jalr	-1624(ra) # fb2 <kill>
        exit(0);
     612:	4501                	li	a0,0
     614:	00001097          	auipc	ra,0x1
     618:	96e080e7          	jalr	-1682(ra) # f82 <exit>
        printf("grind: fork failed\n");
     61c:	00001517          	auipc	a0,0x1
     620:	fdc50513          	addi	a0,a0,-36 # 15f8 <malloc+0x1e6>
     624:	00001097          	auipc	ra,0x1
     628:	d30080e7          	jalr	-720(ra) # 1354 <printf>
        exit(1);
     62c:	4505                	li	a0,1
     62e:	00001097          	auipc	ra,0x1
     632:	954080e7          	jalr	-1708(ra) # f82 <exit>
      if(pipe(fds) < 0){
     636:	fa840513          	addi	a0,s0,-88
     63a:	00001097          	auipc	ra,0x1
     63e:	958080e7          	jalr	-1704(ra) # f92 <pipe>
     642:	02054b63          	bltz	a0,678 <go+0x600>
      int pid = fork();
     646:	00001097          	auipc	ra,0x1
     64a:	934080e7          	jalr	-1740(ra) # f7a <fork>
      if(pid == 0){
     64e:	c131                	beqz	a0,692 <go+0x61a>
      } else if(pid < 0){
     650:	0a054a63          	bltz	a0,704 <go+0x68c>
      close(fds[0]);
     654:	fa842503          	lw	a0,-88(s0)
     658:	00001097          	auipc	ra,0x1
     65c:	952080e7          	jalr	-1710(ra) # faa <close>
      close(fds[1]);
     660:	fac42503          	lw	a0,-84(s0)
     664:	00001097          	auipc	ra,0x1
     668:	946080e7          	jalr	-1722(ra) # faa <close>
      wait(0);
     66c:	4501                	li	a0,0
     66e:	00001097          	auipc	ra,0x1
     672:	91c080e7          	jalr	-1764(ra) # f8a <wait>
     676:	b475                	j	122 <go+0xaa>
        printf("grind: pipe failed\n");
     678:	00001517          	auipc	a0,0x1
     67c:	fc050513          	addi	a0,a0,-64 # 1638 <malloc+0x226>
     680:	00001097          	auipc	ra,0x1
     684:	cd4080e7          	jalr	-812(ra) # 1354 <printf>
        exit(1);
     688:	4505                	li	a0,1
     68a:	00001097          	auipc	ra,0x1
     68e:	8f8080e7          	jalr	-1800(ra) # f82 <exit>
        fork();
     692:	00001097          	auipc	ra,0x1
     696:	8e8080e7          	jalr	-1816(ra) # f7a <fork>
        fork();
     69a:	00001097          	auipc	ra,0x1
     69e:	8e0080e7          	jalr	-1824(ra) # f7a <fork>
        if(write(fds[1], "x", 1) != 1)
     6a2:	4605                	li	a2,1
     6a4:	00001597          	auipc	a1,0x1
     6a8:	fac58593          	addi	a1,a1,-84 # 1650 <malloc+0x23e>
     6ac:	fac42503          	lw	a0,-84(s0)
     6b0:	00001097          	auipc	ra,0x1
     6b4:	8f2080e7          	jalr	-1806(ra) # fa2 <write>
     6b8:	4785                	li	a5,1
     6ba:	02f51363          	bne	a0,a5,6e0 <go+0x668>
        if(read(fds[0], &c, 1) != 1)
     6be:	4605                	li	a2,1
     6c0:	fa040593          	addi	a1,s0,-96
     6c4:	fa842503          	lw	a0,-88(s0)
     6c8:	00001097          	auipc	ra,0x1
     6cc:	8d2080e7          	jalr	-1838(ra) # f9a <read>
     6d0:	4785                	li	a5,1
     6d2:	02f51063          	bne	a0,a5,6f2 <go+0x67a>
        exit(0);
     6d6:	4501                	li	a0,0
     6d8:	00001097          	auipc	ra,0x1
     6dc:	8aa080e7          	jalr	-1878(ra) # f82 <exit>
          printf("grind: pipe write failed\n");
     6e0:	00001517          	auipc	a0,0x1
     6e4:	f7850513          	addi	a0,a0,-136 # 1658 <malloc+0x246>
     6e8:	00001097          	auipc	ra,0x1
     6ec:	c6c080e7          	jalr	-916(ra) # 1354 <printf>
     6f0:	b7f9                	j	6be <go+0x646>
          printf("grind: pipe read failed\n");
     6f2:	00001517          	auipc	a0,0x1
     6f6:	f8650513          	addi	a0,a0,-122 # 1678 <malloc+0x266>
     6fa:	00001097          	auipc	ra,0x1
     6fe:	c5a080e7          	jalr	-934(ra) # 1354 <printf>
     702:	bfd1                	j	6d6 <go+0x65e>
        printf("grind: fork failed\n");
     704:	00001517          	auipc	a0,0x1
     708:	ef450513          	addi	a0,a0,-268 # 15f8 <malloc+0x1e6>
     70c:	00001097          	auipc	ra,0x1
     710:	c48080e7          	jalr	-952(ra) # 1354 <printf>
        exit(1);
     714:	4505                	li	a0,1
     716:	00001097          	auipc	ra,0x1
     71a:	86c080e7          	jalr	-1940(ra) # f82 <exit>
      int pid = fork();
     71e:	00001097          	auipc	ra,0x1
     722:	85c080e7          	jalr	-1956(ra) # f7a <fork>
      if(pid == 0){
     726:	c909                	beqz	a0,738 <go+0x6c0>
      } else if(pid < 0){
     728:	06054f63          	bltz	a0,7a6 <go+0x72e>
      wait(0);
     72c:	4501                	li	a0,0
     72e:	00001097          	auipc	ra,0x1
     732:	85c080e7          	jalr	-1956(ra) # f8a <wait>
     736:	b2f5                	j	122 <go+0xaa>
        unlink("a");
     738:	00001517          	auipc	a0,0x1
     73c:	ea050513          	addi	a0,a0,-352 # 15d8 <malloc+0x1c6>
     740:	00001097          	auipc	ra,0x1
     744:	892080e7          	jalr	-1902(ra) # fd2 <unlink>
        mkdir("a");
     748:	00001517          	auipc	a0,0x1
     74c:	e9050513          	addi	a0,a0,-368 # 15d8 <malloc+0x1c6>
     750:	00001097          	auipc	ra,0x1
     754:	89a080e7          	jalr	-1894(ra) # fea <mkdir>
        chdir("a");
     758:	00001517          	auipc	a0,0x1
     75c:	e8050513          	addi	a0,a0,-384 # 15d8 <malloc+0x1c6>
     760:	00001097          	auipc	ra,0x1
     764:	892080e7          	jalr	-1902(ra) # ff2 <chdir>
        unlink("../a");
     768:	00001517          	auipc	a0,0x1
     76c:	dd850513          	addi	a0,a0,-552 # 1540 <malloc+0x12e>
     770:	00001097          	auipc	ra,0x1
     774:	862080e7          	jalr	-1950(ra) # fd2 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     778:	20200593          	li	a1,514
     77c:	00001517          	auipc	a0,0x1
     780:	ed450513          	addi	a0,a0,-300 # 1650 <malloc+0x23e>
     784:	00001097          	auipc	ra,0x1
     788:	83e080e7          	jalr	-1986(ra) # fc2 <open>
        unlink("x");
     78c:	00001517          	auipc	a0,0x1
     790:	ec450513          	addi	a0,a0,-316 # 1650 <malloc+0x23e>
     794:	00001097          	auipc	ra,0x1
     798:	83e080e7          	jalr	-1986(ra) # fd2 <unlink>
        exit(0);
     79c:	4501                	li	a0,0
     79e:	00000097          	auipc	ra,0x0
     7a2:	7e4080e7          	jalr	2020(ra) # f82 <exit>
        printf("grind: fork failed\n");
     7a6:	00001517          	auipc	a0,0x1
     7aa:	e5250513          	addi	a0,a0,-430 # 15f8 <malloc+0x1e6>
     7ae:	00001097          	auipc	ra,0x1
     7b2:	ba6080e7          	jalr	-1114(ra) # 1354 <printf>
        exit(1);
     7b6:	4505                	li	a0,1
     7b8:	00000097          	auipc	ra,0x0
     7bc:	7ca080e7          	jalr	1994(ra) # f82 <exit>
      unlink("c");
     7c0:	00001517          	auipc	a0,0x1
     7c4:	ed850513          	addi	a0,a0,-296 # 1698 <malloc+0x286>
     7c8:	00001097          	auipc	ra,0x1
     7cc:	80a080e7          	jalr	-2038(ra) # fd2 <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     7d0:	20200593          	li	a1,514
     7d4:	00001517          	auipc	a0,0x1
     7d8:	ec450513          	addi	a0,a0,-316 # 1698 <malloc+0x286>
     7dc:	00000097          	auipc	ra,0x0
     7e0:	7e6080e7          	jalr	2022(ra) # fc2 <open>
     7e4:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     7e6:	04054f63          	bltz	a0,844 <go+0x7cc>
      if(write(fd1, "x", 1) != 1){
     7ea:	4605                	li	a2,1
     7ec:	00001597          	auipc	a1,0x1
     7f0:	e6458593          	addi	a1,a1,-412 # 1650 <malloc+0x23e>
     7f4:	00000097          	auipc	ra,0x0
     7f8:	7ae080e7          	jalr	1966(ra) # fa2 <write>
     7fc:	4785                	li	a5,1
     7fe:	06f51063          	bne	a0,a5,85e <go+0x7e6>
      if(fstat(fd1, &st) != 0){
     802:	fa840593          	addi	a1,s0,-88
     806:	855a                	mv	a0,s6
     808:	00000097          	auipc	ra,0x0
     80c:	7d2080e7          	jalr	2002(ra) # fda <fstat>
     810:	e525                	bnez	a0,878 <go+0x800>
      if(st.size != 1){
     812:	fb843583          	ld	a1,-72(s0)
     816:	4785                	li	a5,1
     818:	06f59d63          	bne	a1,a5,892 <go+0x81a>
      if(st.ino > 200){
     81c:	fac42583          	lw	a1,-84(s0)
     820:	0c800793          	li	a5,200
     824:	08b7e563          	bltu	a5,a1,8ae <go+0x836>
      close(fd1);
     828:	855a                	mv	a0,s6
     82a:	00000097          	auipc	ra,0x0
     82e:	780080e7          	jalr	1920(ra) # faa <close>
      unlink("c");
     832:	00001517          	auipc	a0,0x1
     836:	e6650513          	addi	a0,a0,-410 # 1698 <malloc+0x286>
     83a:	00000097          	auipc	ra,0x0
     83e:	798080e7          	jalr	1944(ra) # fd2 <unlink>
     842:	b0c5                	j	122 <go+0xaa>
        printf("grind: create c failed\n");
     844:	00001517          	auipc	a0,0x1
     848:	e5c50513          	addi	a0,a0,-420 # 16a0 <malloc+0x28e>
     84c:	00001097          	auipc	ra,0x1
     850:	b08080e7          	jalr	-1272(ra) # 1354 <printf>
        exit(1);
     854:	4505                	li	a0,1
     856:	00000097          	auipc	ra,0x0
     85a:	72c080e7          	jalr	1836(ra) # f82 <exit>
        printf("grind: write c failed\n");
     85e:	00001517          	auipc	a0,0x1
     862:	e5a50513          	addi	a0,a0,-422 # 16b8 <malloc+0x2a6>
     866:	00001097          	auipc	ra,0x1
     86a:	aee080e7          	jalr	-1298(ra) # 1354 <printf>
        exit(1);
     86e:	4505                	li	a0,1
     870:	00000097          	auipc	ra,0x0
     874:	712080e7          	jalr	1810(ra) # f82 <exit>
        printf("grind: fstat failed\n");
     878:	00001517          	auipc	a0,0x1
     87c:	e5850513          	addi	a0,a0,-424 # 16d0 <malloc+0x2be>
     880:	00001097          	auipc	ra,0x1
     884:	ad4080e7          	jalr	-1324(ra) # 1354 <printf>
        exit(1);
     888:	4505                	li	a0,1
     88a:	00000097          	auipc	ra,0x0
     88e:	6f8080e7          	jalr	1784(ra) # f82 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     892:	2581                	sext.w	a1,a1
     894:	00001517          	auipc	a0,0x1
     898:	e5450513          	addi	a0,a0,-428 # 16e8 <malloc+0x2d6>
     89c:	00001097          	auipc	ra,0x1
     8a0:	ab8080e7          	jalr	-1352(ra) # 1354 <printf>
        exit(1);
     8a4:	4505                	li	a0,1
     8a6:	00000097          	auipc	ra,0x0
     8aa:	6dc080e7          	jalr	1756(ra) # f82 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     8ae:	00001517          	auipc	a0,0x1
     8b2:	e6250513          	addi	a0,a0,-414 # 1710 <malloc+0x2fe>
     8b6:	00001097          	auipc	ra,0x1
     8ba:	a9e080e7          	jalr	-1378(ra) # 1354 <printf>
        exit(1);
     8be:	4505                	li	a0,1
     8c0:	00000097          	auipc	ra,0x0
     8c4:	6c2080e7          	jalr	1730(ra) # f82 <exit>
        fprintf(2, "grind: pipe failed\n");
     8c8:	00001597          	auipc	a1,0x1
     8cc:	d7058593          	addi	a1,a1,-656 # 1638 <malloc+0x226>
     8d0:	4509                	li	a0,2
     8d2:	00001097          	auipc	ra,0x1
     8d6:	a54080e7          	jalr	-1452(ra) # 1326 <fprintf>
        exit(1);
     8da:	4505                	li	a0,1
     8dc:	00000097          	auipc	ra,0x0
     8e0:	6a6080e7          	jalr	1702(ra) # f82 <exit>
        fprintf(2, "grind: pipe failed\n");
     8e4:	00001597          	auipc	a1,0x1
     8e8:	d5458593          	addi	a1,a1,-684 # 1638 <malloc+0x226>
     8ec:	4509                	li	a0,2
     8ee:	00001097          	auipc	ra,0x1
     8f2:	a38080e7          	jalr	-1480(ra) # 1326 <fprintf>
        exit(1);
     8f6:	4505                	li	a0,1
     8f8:	00000097          	auipc	ra,0x0
     8fc:	68a080e7          	jalr	1674(ra) # f82 <exit>
        close(bb[0]);
     900:	fa042503          	lw	a0,-96(s0)
     904:	00000097          	auipc	ra,0x0
     908:	6a6080e7          	jalr	1702(ra) # faa <close>
        close(bb[1]);
     90c:	fa442503          	lw	a0,-92(s0)
     910:	00000097          	auipc	ra,0x0
     914:	69a080e7          	jalr	1690(ra) # faa <close>
        close(aa[0]);
     918:	f9842503          	lw	a0,-104(s0)
     91c:	00000097          	auipc	ra,0x0
     920:	68e080e7          	jalr	1678(ra) # faa <close>
        close(1);
     924:	4505                	li	a0,1
     926:	00000097          	auipc	ra,0x0
     92a:	684080e7          	jalr	1668(ra) # faa <close>
        if(dup(aa[1]) != 1){
     92e:	f9c42503          	lw	a0,-100(s0)
     932:	00000097          	auipc	ra,0x0
     936:	6c8080e7          	jalr	1736(ra) # ffa <dup>
     93a:	4785                	li	a5,1
     93c:	02f50063          	beq	a0,a5,95c <go+0x8e4>
          fprintf(2, "grind: dup failed\n");
     940:	00001597          	auipc	a1,0x1
     944:	df858593          	addi	a1,a1,-520 # 1738 <malloc+0x326>
     948:	4509                	li	a0,2
     94a:	00001097          	auipc	ra,0x1
     94e:	9dc080e7          	jalr	-1572(ra) # 1326 <fprintf>
          exit(1);
     952:	4505                	li	a0,1
     954:	00000097          	auipc	ra,0x0
     958:	62e080e7          	jalr	1582(ra) # f82 <exit>
        close(aa[1]);
     95c:	f9c42503          	lw	a0,-100(s0)
     960:	00000097          	auipc	ra,0x0
     964:	64a080e7          	jalr	1610(ra) # faa <close>
        char *args[3] = { "echo", "hi", 0 };
     968:	00001797          	auipc	a5,0x1
     96c:	de878793          	addi	a5,a5,-536 # 1750 <malloc+0x33e>
     970:	faf43423          	sd	a5,-88(s0)
     974:	00001797          	auipc	a5,0x1
     978:	de478793          	addi	a5,a5,-540 # 1758 <malloc+0x346>
     97c:	faf43823          	sd	a5,-80(s0)
     980:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     984:	fa840593          	addi	a1,s0,-88
     988:	00001517          	auipc	a0,0x1
     98c:	dd850513          	addi	a0,a0,-552 # 1760 <malloc+0x34e>
     990:	00000097          	auipc	ra,0x0
     994:	62a080e7          	jalr	1578(ra) # fba <exec>
        fprintf(2, "grind: echo: not found\n");
     998:	00001597          	auipc	a1,0x1
     99c:	dd858593          	addi	a1,a1,-552 # 1770 <malloc+0x35e>
     9a0:	4509                	li	a0,2
     9a2:	00001097          	auipc	ra,0x1
     9a6:	984080e7          	jalr	-1660(ra) # 1326 <fprintf>
        exit(2);
     9aa:	4509                	li	a0,2
     9ac:	00000097          	auipc	ra,0x0
     9b0:	5d6080e7          	jalr	1494(ra) # f82 <exit>
        fprintf(2, "grind: fork failed\n");
     9b4:	00001597          	auipc	a1,0x1
     9b8:	c4458593          	addi	a1,a1,-956 # 15f8 <malloc+0x1e6>
     9bc:	4509                	li	a0,2
     9be:	00001097          	auipc	ra,0x1
     9c2:	968080e7          	jalr	-1688(ra) # 1326 <fprintf>
        exit(3);
     9c6:	450d                	li	a0,3
     9c8:	00000097          	auipc	ra,0x0
     9cc:	5ba080e7          	jalr	1466(ra) # f82 <exit>
        close(aa[1]);
     9d0:	f9c42503          	lw	a0,-100(s0)
     9d4:	00000097          	auipc	ra,0x0
     9d8:	5d6080e7          	jalr	1494(ra) # faa <close>
        close(bb[0]);
     9dc:	fa042503          	lw	a0,-96(s0)
     9e0:	00000097          	auipc	ra,0x0
     9e4:	5ca080e7          	jalr	1482(ra) # faa <close>
        close(0);
     9e8:	4501                	li	a0,0
     9ea:	00000097          	auipc	ra,0x0
     9ee:	5c0080e7          	jalr	1472(ra) # faa <close>
        if(dup(aa[0]) != 0){
     9f2:	f9842503          	lw	a0,-104(s0)
     9f6:	00000097          	auipc	ra,0x0
     9fa:	604080e7          	jalr	1540(ra) # ffa <dup>
     9fe:	cd19                	beqz	a0,a1c <go+0x9a4>
          fprintf(2, "grind: dup failed\n");
     a00:	00001597          	auipc	a1,0x1
     a04:	d3858593          	addi	a1,a1,-712 # 1738 <malloc+0x326>
     a08:	4509                	li	a0,2
     a0a:	00001097          	auipc	ra,0x1
     a0e:	91c080e7          	jalr	-1764(ra) # 1326 <fprintf>
          exit(4);
     a12:	4511                	li	a0,4
     a14:	00000097          	auipc	ra,0x0
     a18:	56e080e7          	jalr	1390(ra) # f82 <exit>
        close(aa[0]);
     a1c:	f9842503          	lw	a0,-104(s0)
     a20:	00000097          	auipc	ra,0x0
     a24:	58a080e7          	jalr	1418(ra) # faa <close>
        close(1);
     a28:	4505                	li	a0,1
     a2a:	00000097          	auipc	ra,0x0
     a2e:	580080e7          	jalr	1408(ra) # faa <close>
        if(dup(bb[1]) != 1){
     a32:	fa442503          	lw	a0,-92(s0)
     a36:	00000097          	auipc	ra,0x0
     a3a:	5c4080e7          	jalr	1476(ra) # ffa <dup>
     a3e:	4785                	li	a5,1
     a40:	02f50063          	beq	a0,a5,a60 <go+0x9e8>
          fprintf(2, "grind: dup failed\n");
     a44:	00001597          	auipc	a1,0x1
     a48:	cf458593          	addi	a1,a1,-780 # 1738 <malloc+0x326>
     a4c:	4509                	li	a0,2
     a4e:	00001097          	auipc	ra,0x1
     a52:	8d8080e7          	jalr	-1832(ra) # 1326 <fprintf>
          exit(5);
     a56:	4515                	li	a0,5
     a58:	00000097          	auipc	ra,0x0
     a5c:	52a080e7          	jalr	1322(ra) # f82 <exit>
        close(bb[1]);
     a60:	fa442503          	lw	a0,-92(s0)
     a64:	00000097          	auipc	ra,0x0
     a68:	546080e7          	jalr	1350(ra) # faa <close>
        char *args[2] = { "cat", 0 };
     a6c:	00001797          	auipc	a5,0x1
     a70:	d1c78793          	addi	a5,a5,-740 # 1788 <malloc+0x376>
     a74:	faf43423          	sd	a5,-88(s0)
     a78:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a7c:	fa840593          	addi	a1,s0,-88
     a80:	00001517          	auipc	a0,0x1
     a84:	d1050513          	addi	a0,a0,-752 # 1790 <malloc+0x37e>
     a88:	00000097          	auipc	ra,0x0
     a8c:	532080e7          	jalr	1330(ra) # fba <exec>
        fprintf(2, "grind: cat: not found\n");
     a90:	00001597          	auipc	a1,0x1
     a94:	d0858593          	addi	a1,a1,-760 # 1798 <malloc+0x386>
     a98:	4509                	li	a0,2
     a9a:	00001097          	auipc	ra,0x1
     a9e:	88c080e7          	jalr	-1908(ra) # 1326 <fprintf>
        exit(6);
     aa2:	4519                	li	a0,6
     aa4:	00000097          	auipc	ra,0x0
     aa8:	4de080e7          	jalr	1246(ra) # f82 <exit>
        fprintf(2, "grind: fork failed\n");
     aac:	00001597          	auipc	a1,0x1
     ab0:	b4c58593          	addi	a1,a1,-1204 # 15f8 <malloc+0x1e6>
     ab4:	4509                	li	a0,2
     ab6:	00001097          	auipc	ra,0x1
     aba:	870080e7          	jalr	-1936(ra) # 1326 <fprintf>
        exit(7);
     abe:	451d                	li	a0,7
     ac0:	00000097          	auipc	ra,0x0
     ac4:	4c2080e7          	jalr	1218(ra) # f82 <exit>

0000000000000ac8 <iter>:
  }
}

void
iter()
{
     ac8:	7179                	addi	sp,sp,-48
     aca:	f406                	sd	ra,40(sp)
     acc:	f022                	sd	s0,32(sp)
     ace:	ec26                	sd	s1,24(sp)
     ad0:	e84a                	sd	s2,16(sp)
     ad2:	1800                	addi	s0,sp,48
  unlink("a");
     ad4:	00001517          	auipc	a0,0x1
     ad8:	b0450513          	addi	a0,a0,-1276 # 15d8 <malloc+0x1c6>
     adc:	00000097          	auipc	ra,0x0
     ae0:	4f6080e7          	jalr	1270(ra) # fd2 <unlink>
  unlink("b");
     ae4:	00001517          	auipc	a0,0x1
     ae8:	aa450513          	addi	a0,a0,-1372 # 1588 <malloc+0x176>
     aec:	00000097          	auipc	ra,0x0
     af0:	4e6080e7          	jalr	1254(ra) # fd2 <unlink>
  
  int pid1 = fork();
     af4:	00000097          	auipc	ra,0x0
     af8:	486080e7          	jalr	1158(ra) # f7a <fork>
  if(pid1 < 0){
     afc:	00054e63          	bltz	a0,b18 <iter+0x50>
     b00:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     b02:	e905                	bnez	a0,b32 <iter+0x6a>
    rand_next = 31;
     b04:	47fd                	li	a5,31
     b06:	00001717          	auipc	a4,0x1
     b0a:	cef73d23          	sd	a5,-774(a4) # 1800 <rand_next>
    go(0);
     b0e:	4501                	li	a0,0
     b10:	fffff097          	auipc	ra,0xfffff
     b14:	568080e7          	jalr	1384(ra) # 78 <go>
    printf("grind: fork failed\n");
     b18:	00001517          	auipc	a0,0x1
     b1c:	ae050513          	addi	a0,a0,-1312 # 15f8 <malloc+0x1e6>
     b20:	00001097          	auipc	ra,0x1
     b24:	834080e7          	jalr	-1996(ra) # 1354 <printf>
    exit(1);
     b28:	4505                	li	a0,1
     b2a:	00000097          	auipc	ra,0x0
     b2e:	458080e7          	jalr	1112(ra) # f82 <exit>
    exit(0);
  }

  int pid2 = fork();
     b32:	00000097          	auipc	ra,0x0
     b36:	448080e7          	jalr	1096(ra) # f7a <fork>
     b3a:	892a                	mv	s2,a0
  if(pid2 < 0){
     b3c:	00054f63          	bltz	a0,b5a <iter+0x92>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     b40:	e915                	bnez	a0,b74 <iter+0xac>
    rand_next = 7177;
     b42:	6789                	lui	a5,0x2
     b44:	c0978793          	addi	a5,a5,-1015 # 1c09 <__BSS_END__+0x1>
     b48:	00001717          	auipc	a4,0x1
     b4c:	caf73c23          	sd	a5,-840(a4) # 1800 <rand_next>
    go(1);
     b50:	4505                	li	a0,1
     b52:	fffff097          	auipc	ra,0xfffff
     b56:	526080e7          	jalr	1318(ra) # 78 <go>
    printf("grind: fork failed\n");
     b5a:	00001517          	auipc	a0,0x1
     b5e:	a9e50513          	addi	a0,a0,-1378 # 15f8 <malloc+0x1e6>
     b62:	00000097          	auipc	ra,0x0
     b66:	7f2080e7          	jalr	2034(ra) # 1354 <printf>
    exit(1);
     b6a:	4505                	li	a0,1
     b6c:	00000097          	auipc	ra,0x0
     b70:	416080e7          	jalr	1046(ra) # f82 <exit>
    exit(0);
  }

  int st1 = -1;
     b74:	57fd                	li	a5,-1
     b76:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b7a:	fdc40513          	addi	a0,s0,-36
     b7e:	00000097          	auipc	ra,0x0
     b82:	40c080e7          	jalr	1036(ra) # f8a <wait>
  if(st1 != 0){
     b86:	fdc42783          	lw	a5,-36(s0)
     b8a:	ef99                	bnez	a5,ba8 <iter+0xe0>
    kill(pid1, SIGKILL);
    kill(pid2, SIGKILL);
  }
  int st2 = -1;
     b8c:	57fd                	li	a5,-1
     b8e:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b92:	fd840513          	addi	a0,s0,-40
     b96:	00000097          	auipc	ra,0x0
     b9a:	3f4080e7          	jalr	1012(ra) # f8a <wait>

  exit(0);
     b9e:	4501                	li	a0,0
     ba0:	00000097          	auipc	ra,0x0
     ba4:	3e2080e7          	jalr	994(ra) # f82 <exit>
    kill(pid1, SIGKILL);
     ba8:	45a5                	li	a1,9
     baa:	8526                	mv	a0,s1
     bac:	00000097          	auipc	ra,0x0
     bb0:	406080e7          	jalr	1030(ra) # fb2 <kill>
    kill(pid2, SIGKILL);
     bb4:	45a5                	li	a1,9
     bb6:	854a                	mv	a0,s2
     bb8:	00000097          	auipc	ra,0x0
     bbc:	3fa080e7          	jalr	1018(ra) # fb2 <kill>
     bc0:	b7f1                	j	b8c <iter+0xc4>

0000000000000bc2 <main>:
}

int
main()
{
     bc2:	1141                	addi	sp,sp,-16
     bc4:	e406                	sd	ra,8(sp)
     bc6:	e022                	sd	s0,0(sp)
     bc8:	0800                	addi	s0,sp,16
     bca:	a811                	j	bde <main+0x1c>
  while(1){
    int pid = fork();
    if(pid == 0){
      iter();
     bcc:	00000097          	auipc	ra,0x0
     bd0:	efc080e7          	jalr	-260(ra) # ac8 <iter>
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     bd4:	4551                	li	a0,20
     bd6:	00000097          	auipc	ra,0x0
     bda:	43c080e7          	jalr	1084(ra) # 1012 <sleep>
    int pid = fork();
     bde:	00000097          	auipc	ra,0x0
     be2:	39c080e7          	jalr	924(ra) # f7a <fork>
    if(pid == 0){
     be6:	d17d                	beqz	a0,bcc <main+0xa>
    if(pid > 0){
     be8:	fea056e3          	blez	a0,bd4 <main+0x12>
      wait(0);
     bec:	4501                	li	a0,0
     bee:	00000097          	auipc	ra,0x0
     bf2:	39c080e7          	jalr	924(ra) # f8a <wait>
     bf6:	bff9                	j	bd4 <main+0x12>

0000000000000bf8 <strcpy>:
#include "kernel/Csemaphore.h"


char*
strcpy(char *s, const char *t)
{
     bf8:	1141                	addi	sp,sp,-16
     bfa:	e422                	sd	s0,8(sp)
     bfc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     bfe:	87aa                	mv	a5,a0
     c00:	0585                	addi	a1,a1,1
     c02:	0785                	addi	a5,a5,1
     c04:	fff5c703          	lbu	a4,-1(a1)
     c08:	fee78fa3          	sb	a4,-1(a5)
     c0c:	fb75                	bnez	a4,c00 <strcpy+0x8>
    ;
  return os;
}
     c0e:	6422                	ld	s0,8(sp)
     c10:	0141                	addi	sp,sp,16
     c12:	8082                	ret

0000000000000c14 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c14:	1141                	addi	sp,sp,-16
     c16:	e422                	sd	s0,8(sp)
     c18:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c1a:	00054783          	lbu	a5,0(a0)
     c1e:	cb91                	beqz	a5,c32 <strcmp+0x1e>
     c20:	0005c703          	lbu	a4,0(a1)
     c24:	00f71763          	bne	a4,a5,c32 <strcmp+0x1e>
    p++, q++;
     c28:	0505                	addi	a0,a0,1
     c2a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     c2c:	00054783          	lbu	a5,0(a0)
     c30:	fbe5                	bnez	a5,c20 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     c32:	0005c503          	lbu	a0,0(a1)
}
     c36:	40a7853b          	subw	a0,a5,a0
     c3a:	6422                	ld	s0,8(sp)
     c3c:	0141                	addi	sp,sp,16
     c3e:	8082                	ret

0000000000000c40 <strlen>:

uint
strlen(const char *s)
{
     c40:	1141                	addi	sp,sp,-16
     c42:	e422                	sd	s0,8(sp)
     c44:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c46:	00054783          	lbu	a5,0(a0)
     c4a:	cf91                	beqz	a5,c66 <strlen+0x26>
     c4c:	0505                	addi	a0,a0,1
     c4e:	87aa                	mv	a5,a0
     c50:	4685                	li	a3,1
     c52:	9e89                	subw	a3,a3,a0
     c54:	00f6853b          	addw	a0,a3,a5
     c58:	0785                	addi	a5,a5,1
     c5a:	fff7c703          	lbu	a4,-1(a5)
     c5e:	fb7d                	bnez	a4,c54 <strlen+0x14>
    ;
  return n;
}
     c60:	6422                	ld	s0,8(sp)
     c62:	0141                	addi	sp,sp,16
     c64:	8082                	ret
  for(n = 0; s[n]; n++)
     c66:	4501                	li	a0,0
     c68:	bfe5                	j	c60 <strlen+0x20>

0000000000000c6a <memset>:

void*
memset(void *dst, int c, uint n)
{
     c6a:	1141                	addi	sp,sp,-16
     c6c:	e422                	sd	s0,8(sp)
     c6e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c70:	ca19                	beqz	a2,c86 <memset+0x1c>
     c72:	87aa                	mv	a5,a0
     c74:	1602                	slli	a2,a2,0x20
     c76:	9201                	srli	a2,a2,0x20
     c78:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c7c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c80:	0785                	addi	a5,a5,1
     c82:	fee79de3          	bne	a5,a4,c7c <memset+0x12>
  }
  return dst;
}
     c86:	6422                	ld	s0,8(sp)
     c88:	0141                	addi	sp,sp,16
     c8a:	8082                	ret

0000000000000c8c <strchr>:

char*
strchr(const char *s, char c)
{
     c8c:	1141                	addi	sp,sp,-16
     c8e:	e422                	sd	s0,8(sp)
     c90:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c92:	00054783          	lbu	a5,0(a0)
     c96:	cb99                	beqz	a5,cac <strchr+0x20>
    if(*s == c)
     c98:	00f58763          	beq	a1,a5,ca6 <strchr+0x1a>
  for(; *s; s++)
     c9c:	0505                	addi	a0,a0,1
     c9e:	00054783          	lbu	a5,0(a0)
     ca2:	fbfd                	bnez	a5,c98 <strchr+0xc>
      return (char*)s;
  return 0;
     ca4:	4501                	li	a0,0
}
     ca6:	6422                	ld	s0,8(sp)
     ca8:	0141                	addi	sp,sp,16
     caa:	8082                	ret
  return 0;
     cac:	4501                	li	a0,0
     cae:	bfe5                	j	ca6 <strchr+0x1a>

0000000000000cb0 <gets>:

char*
gets(char *buf, int max)
{
     cb0:	711d                	addi	sp,sp,-96
     cb2:	ec86                	sd	ra,88(sp)
     cb4:	e8a2                	sd	s0,80(sp)
     cb6:	e4a6                	sd	s1,72(sp)
     cb8:	e0ca                	sd	s2,64(sp)
     cba:	fc4e                	sd	s3,56(sp)
     cbc:	f852                	sd	s4,48(sp)
     cbe:	f456                	sd	s5,40(sp)
     cc0:	f05a                	sd	s6,32(sp)
     cc2:	ec5e                	sd	s7,24(sp)
     cc4:	1080                	addi	s0,sp,96
     cc6:	8baa                	mv	s7,a0
     cc8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     cca:	892a                	mv	s2,a0
     ccc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     cce:	4aa9                	li	s5,10
     cd0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     cd2:	89a6                	mv	s3,s1
     cd4:	2485                	addiw	s1,s1,1
     cd6:	0344d863          	bge	s1,s4,d06 <gets+0x56>
    cc = read(0, &c, 1);
     cda:	4605                	li	a2,1
     cdc:	faf40593          	addi	a1,s0,-81
     ce0:	4501                	li	a0,0
     ce2:	00000097          	auipc	ra,0x0
     ce6:	2b8080e7          	jalr	696(ra) # f9a <read>
    if(cc < 1)
     cea:	00a05e63          	blez	a0,d06 <gets+0x56>
    buf[i++] = c;
     cee:	faf44783          	lbu	a5,-81(s0)
     cf2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     cf6:	01578763          	beq	a5,s5,d04 <gets+0x54>
     cfa:	0905                	addi	s2,s2,1
     cfc:	fd679be3          	bne	a5,s6,cd2 <gets+0x22>
  for(i=0; i+1 < max; ){
     d00:	89a6                	mv	s3,s1
     d02:	a011                	j	d06 <gets+0x56>
     d04:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     d06:	99de                	add	s3,s3,s7
     d08:	00098023          	sb	zero,0(s3)
  return buf;
}
     d0c:	855e                	mv	a0,s7
     d0e:	60e6                	ld	ra,88(sp)
     d10:	6446                	ld	s0,80(sp)
     d12:	64a6                	ld	s1,72(sp)
     d14:	6906                	ld	s2,64(sp)
     d16:	79e2                	ld	s3,56(sp)
     d18:	7a42                	ld	s4,48(sp)
     d1a:	7aa2                	ld	s5,40(sp)
     d1c:	7b02                	ld	s6,32(sp)
     d1e:	6be2                	ld	s7,24(sp)
     d20:	6125                	addi	sp,sp,96
     d22:	8082                	ret

0000000000000d24 <stat>:

int
stat(const char *n, struct stat *st)
{
     d24:	1101                	addi	sp,sp,-32
     d26:	ec06                	sd	ra,24(sp)
     d28:	e822                	sd	s0,16(sp)
     d2a:	e426                	sd	s1,8(sp)
     d2c:	e04a                	sd	s2,0(sp)
     d2e:	1000                	addi	s0,sp,32
     d30:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d32:	4581                	li	a1,0
     d34:	00000097          	auipc	ra,0x0
     d38:	28e080e7          	jalr	654(ra) # fc2 <open>
  if(fd < 0)
     d3c:	02054563          	bltz	a0,d66 <stat+0x42>
     d40:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d42:	85ca                	mv	a1,s2
     d44:	00000097          	auipc	ra,0x0
     d48:	296080e7          	jalr	662(ra) # fda <fstat>
     d4c:	892a                	mv	s2,a0
  close(fd);
     d4e:	8526                	mv	a0,s1
     d50:	00000097          	auipc	ra,0x0
     d54:	25a080e7          	jalr	602(ra) # faa <close>
  return r;
}
     d58:	854a                	mv	a0,s2
     d5a:	60e2                	ld	ra,24(sp)
     d5c:	6442                	ld	s0,16(sp)
     d5e:	64a2                	ld	s1,8(sp)
     d60:	6902                	ld	s2,0(sp)
     d62:	6105                	addi	sp,sp,32
     d64:	8082                	ret
    return -1;
     d66:	597d                	li	s2,-1
     d68:	bfc5                	j	d58 <stat+0x34>

0000000000000d6a <atoi>:

int
atoi(const char *s)
{
     d6a:	1141                	addi	sp,sp,-16
     d6c:	e422                	sd	s0,8(sp)
     d6e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d70:	00054603          	lbu	a2,0(a0)
     d74:	fd06079b          	addiw	a5,a2,-48
     d78:	0ff7f793          	andi	a5,a5,255
     d7c:	4725                	li	a4,9
     d7e:	02f76963          	bltu	a4,a5,db0 <atoi+0x46>
     d82:	86aa                	mv	a3,a0
  n = 0;
     d84:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     d86:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     d88:	0685                	addi	a3,a3,1
     d8a:	0025179b          	slliw	a5,a0,0x2
     d8e:	9fa9                	addw	a5,a5,a0
     d90:	0017979b          	slliw	a5,a5,0x1
     d94:	9fb1                	addw	a5,a5,a2
     d96:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d9a:	0006c603          	lbu	a2,0(a3)
     d9e:	fd06071b          	addiw	a4,a2,-48
     da2:	0ff77713          	andi	a4,a4,255
     da6:	fee5f1e3          	bgeu	a1,a4,d88 <atoi+0x1e>
  return n;
}
     daa:	6422                	ld	s0,8(sp)
     dac:	0141                	addi	sp,sp,16
     dae:	8082                	ret
  n = 0;
     db0:	4501                	li	a0,0
     db2:	bfe5                	j	daa <atoi+0x40>

0000000000000db4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     db4:	1141                	addi	sp,sp,-16
     db6:	e422                	sd	s0,8(sp)
     db8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     dba:	02b57463          	bgeu	a0,a1,de2 <memmove+0x2e>
    while(n-- > 0)
     dbe:	00c05f63          	blez	a2,ddc <memmove+0x28>
     dc2:	1602                	slli	a2,a2,0x20
     dc4:	9201                	srli	a2,a2,0x20
     dc6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     dca:	872a                	mv	a4,a0
      *dst++ = *src++;
     dcc:	0585                	addi	a1,a1,1
     dce:	0705                	addi	a4,a4,1
     dd0:	fff5c683          	lbu	a3,-1(a1)
     dd4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     dd8:	fee79ae3          	bne	a5,a4,dcc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ddc:	6422                	ld	s0,8(sp)
     dde:	0141                	addi	sp,sp,16
     de0:	8082                	ret
    dst += n;
     de2:	00c50733          	add	a4,a0,a2
    src += n;
     de6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     de8:	fec05ae3          	blez	a2,ddc <memmove+0x28>
     dec:	fff6079b          	addiw	a5,a2,-1
     df0:	1782                	slli	a5,a5,0x20
     df2:	9381                	srli	a5,a5,0x20
     df4:	fff7c793          	not	a5,a5
     df8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     dfa:	15fd                	addi	a1,a1,-1
     dfc:	177d                	addi	a4,a4,-1
     dfe:	0005c683          	lbu	a3,0(a1)
     e02:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     e06:	fee79ae3          	bne	a5,a4,dfa <memmove+0x46>
     e0a:	bfc9                	j	ddc <memmove+0x28>

0000000000000e0c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     e0c:	1141                	addi	sp,sp,-16
     e0e:	e422                	sd	s0,8(sp)
     e10:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     e12:	ca05                	beqz	a2,e42 <memcmp+0x36>
     e14:	fff6069b          	addiw	a3,a2,-1
     e18:	1682                	slli	a3,a3,0x20
     e1a:	9281                	srli	a3,a3,0x20
     e1c:	0685                	addi	a3,a3,1
     e1e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     e20:	00054783          	lbu	a5,0(a0)
     e24:	0005c703          	lbu	a4,0(a1)
     e28:	00e79863          	bne	a5,a4,e38 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     e2c:	0505                	addi	a0,a0,1
    p2++;
     e2e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e30:	fed518e3          	bne	a0,a3,e20 <memcmp+0x14>
  }
  return 0;
     e34:	4501                	li	a0,0
     e36:	a019                	j	e3c <memcmp+0x30>
      return *p1 - *p2;
     e38:	40e7853b          	subw	a0,a5,a4
}
     e3c:	6422                	ld	s0,8(sp)
     e3e:	0141                	addi	sp,sp,16
     e40:	8082                	ret
  return 0;
     e42:	4501                	li	a0,0
     e44:	bfe5                	j	e3c <memcmp+0x30>

0000000000000e46 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e46:	1141                	addi	sp,sp,-16
     e48:	e406                	sd	ra,8(sp)
     e4a:	e022                	sd	s0,0(sp)
     e4c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e4e:	00000097          	auipc	ra,0x0
     e52:	f66080e7          	jalr	-154(ra) # db4 <memmove>
}
     e56:	60a2                	ld	ra,8(sp)
     e58:	6402                	ld	s0,0(sp)
     e5a:	0141                	addi	sp,sp,16
     e5c:	8082                	ret

0000000000000e5e <csem_down>:


void 
csem_down(struct counting_semaphore *sem) {
     e5e:	1101                	addi	sp,sp,-32
     e60:	ec06                	sd	ra,24(sp)
     e62:	e822                	sd	s0,16(sp)
     e64:	e426                	sd	s1,8(sp)
     e66:	1000                	addi	s0,sp,32
     e68:	84aa                	mv	s1,a0
    bsem_down(sem->bsem2);
     e6a:	4148                	lw	a0,4(a0)
     e6c:	00000097          	auipc	ra,0x0
     e70:	1ce080e7          	jalr	462(ra) # 103a <bsem_down>
    bsem_down(sem->bsem1);
     e74:	4088                	lw	a0,0(s1)
     e76:	00000097          	auipc	ra,0x0
     e7a:	1c4080e7          	jalr	452(ra) # 103a <bsem_down>
    sem->count -= 1;
     e7e:	449c                	lw	a5,8(s1)
     e80:	37fd                	addiw	a5,a5,-1
     e82:	0007871b          	sext.w	a4,a5
     e86:	c49c                	sw	a5,8(s1)
    if (sem->count > 0)
     e88:	00e04c63          	bgtz	a4,ea0 <csem_down+0x42>
    	bsem_up(sem->bsem2);
    bsem_up(sem->bsem1);
     e8c:	4088                	lw	a0,0(s1)
     e8e:	00000097          	auipc	ra,0x0
     e92:	1b4080e7          	jalr	436(ra) # 1042 <bsem_up>
}
     e96:	60e2                	ld	ra,24(sp)
     e98:	6442                	ld	s0,16(sp)
     e9a:	64a2                	ld	s1,8(sp)
     e9c:	6105                	addi	sp,sp,32
     e9e:	8082                	ret
    	bsem_up(sem->bsem2);
     ea0:	40c8                	lw	a0,4(s1)
     ea2:	00000097          	auipc	ra,0x0
     ea6:	1a0080e7          	jalr	416(ra) # 1042 <bsem_up>
     eaa:	b7cd                	j	e8c <csem_down+0x2e>

0000000000000eac <csem_up>:


void 
csem_up(struct counting_semaphore *sem) {
     eac:	1101                	addi	sp,sp,-32
     eae:	ec06                	sd	ra,24(sp)
     eb0:	e822                	sd	s0,16(sp)
     eb2:	e426                	sd	s1,8(sp)
     eb4:	1000                	addi	s0,sp,32
     eb6:	84aa                	mv	s1,a0
	bsem_down(sem->bsem1);
     eb8:	4108                	lw	a0,0(a0)
     eba:	00000097          	auipc	ra,0x0
     ebe:	180080e7          	jalr	384(ra) # 103a <bsem_down>
	sem->count += 1;
     ec2:	449c                	lw	a5,8(s1)
     ec4:	2785                	addiw	a5,a5,1
     ec6:	0007871b          	sext.w	a4,a5
     eca:	c49c                	sw	a5,8(s1)
	if (sem->count == 1)
     ecc:	4785                	li	a5,1
     ece:	00f70c63          	beq	a4,a5,ee6 <csem_up+0x3a>
		bsem_up(sem->bsem2);
	bsem_up(sem->bsem1);
     ed2:	4088                	lw	a0,0(s1)
     ed4:	00000097          	auipc	ra,0x0
     ed8:	16e080e7          	jalr	366(ra) # 1042 <bsem_up>
}
     edc:	60e2                	ld	ra,24(sp)
     ede:	6442                	ld	s0,16(sp)
     ee0:	64a2                	ld	s1,8(sp)
     ee2:	6105                	addi	sp,sp,32
     ee4:	8082                	ret
		bsem_up(sem->bsem2);
     ee6:	40c8                	lw	a0,4(s1)
     ee8:	00000097          	auipc	ra,0x0
     eec:	15a080e7          	jalr	346(ra) # 1042 <bsem_up>
     ef0:	b7cd                	j	ed2 <csem_up+0x26>

0000000000000ef2 <csem_alloc>:


int 
csem_alloc(struct counting_semaphore *sem, int count) {
     ef2:	7179                	addi	sp,sp,-48
     ef4:	f406                	sd	ra,40(sp)
     ef6:	f022                	sd	s0,32(sp)
     ef8:	ec26                	sd	s1,24(sp)
     efa:	e84a                	sd	s2,16(sp)
     efc:	e44e                	sd	s3,8(sp)
     efe:	1800                	addi	s0,sp,48
     f00:	892a                	mv	s2,a0
     f02:	89ae                	mv	s3,a1
    int bsem1 = bsem_alloc();
     f04:	00000097          	auipc	ra,0x0
     f08:	14e080e7          	jalr	334(ra) # 1052 <bsem_alloc>
     f0c:	84aa                	mv	s1,a0
    int bsem2 = bsem_alloc();
     f0e:	00000097          	auipc	ra,0x0
     f12:	144080e7          	jalr	324(ra) # 1052 <bsem_alloc>
    if (bsem1 == -1 || bsem2 == -1)
     f16:	57fd                	li	a5,-1
     f18:	00f48d63          	beq	s1,a5,f32 <csem_alloc+0x40>
     f1c:	02f50863          	beq	a0,a5,f4c <csem_alloc+0x5a>
        return -1; 
    sem->bsem1 = bsem1;
     f20:	00992023          	sw	s1,0(s2)
    sem->bsem2 = bsem2;
     f24:	00a92223          	sw	a0,4(s2)
    if (count == 0)
     f28:	00098d63          	beqz	s3,f42 <csem_alloc+0x50>
        // Binary semaphore first value = min(1, count)
        bsem_down(sem->bsem2); 
    sem->count = count;
     f2c:	01392423          	sw	s3,8(s2)
    return 0;
     f30:	4481                	li	s1,0
}
     f32:	8526                	mv	a0,s1
     f34:	70a2                	ld	ra,40(sp)
     f36:	7402                	ld	s0,32(sp)
     f38:	64e2                	ld	s1,24(sp)
     f3a:	6942                	ld	s2,16(sp)
     f3c:	69a2                	ld	s3,8(sp)
     f3e:	6145                	addi	sp,sp,48
     f40:	8082                	ret
        bsem_down(sem->bsem2); 
     f42:	00000097          	auipc	ra,0x0
     f46:	0f8080e7          	jalr	248(ra) # 103a <bsem_down>
     f4a:	b7cd                	j	f2c <csem_alloc+0x3a>
        return -1; 
     f4c:	84aa                	mv	s1,a0
     f4e:	b7d5                	j	f32 <csem_alloc+0x40>

0000000000000f50 <csem_free>:


void 
csem_free(struct counting_semaphore *sem) {
     f50:	1101                	addi	sp,sp,-32
     f52:	ec06                	sd	ra,24(sp)
     f54:	e822                	sd	s0,16(sp)
     f56:	e426                	sd	s1,8(sp)
     f58:	1000                	addi	s0,sp,32
     f5a:	84aa                	mv	s1,a0
    bsem_free(sem->bsem1);
     f5c:	4108                	lw	a0,0(a0)
     f5e:	00000097          	auipc	ra,0x0
     f62:	0ec080e7          	jalr	236(ra) # 104a <bsem_free>
    bsem_free(sem->bsem2);
     f66:	40c8                	lw	a0,4(s1)
     f68:	00000097          	auipc	ra,0x0
     f6c:	0e2080e7          	jalr	226(ra) # 104a <bsem_free>
    //free(sem);
}
     f70:	60e2                	ld	ra,24(sp)
     f72:	6442                	ld	s0,16(sp)
     f74:	64a2                	ld	s1,8(sp)
     f76:	6105                	addi	sp,sp,32
     f78:	8082                	ret

0000000000000f7a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     f7a:	4885                	li	a7,1
 ecall
     f7c:	00000073          	ecall
 ret
     f80:	8082                	ret

0000000000000f82 <exit>:
.global exit
exit:
 li a7, SYS_exit
     f82:	4889                	li	a7,2
 ecall
     f84:	00000073          	ecall
 ret
     f88:	8082                	ret

0000000000000f8a <wait>:
.global wait
wait:
 li a7, SYS_wait
     f8a:	488d                	li	a7,3
 ecall
     f8c:	00000073          	ecall
 ret
     f90:	8082                	ret

0000000000000f92 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     f92:	4891                	li	a7,4
 ecall
     f94:	00000073          	ecall
 ret
     f98:	8082                	ret

0000000000000f9a <read>:
.global read
read:
 li a7, SYS_read
     f9a:	4895                	li	a7,5
 ecall
     f9c:	00000073          	ecall
 ret
     fa0:	8082                	ret

0000000000000fa2 <write>:
.global write
write:
 li a7, SYS_write
     fa2:	48c1                	li	a7,16
 ecall
     fa4:	00000073          	ecall
 ret
     fa8:	8082                	ret

0000000000000faa <close>:
.global close
close:
 li a7, SYS_close
     faa:	48d5                	li	a7,21
 ecall
     fac:	00000073          	ecall
 ret
     fb0:	8082                	ret

0000000000000fb2 <kill>:
.global kill
kill:
 li a7, SYS_kill
     fb2:	4899                	li	a7,6
 ecall
     fb4:	00000073          	ecall
 ret
     fb8:	8082                	ret

0000000000000fba <exec>:
.global exec
exec:
 li a7, SYS_exec
     fba:	489d                	li	a7,7
 ecall
     fbc:	00000073          	ecall
 ret
     fc0:	8082                	ret

0000000000000fc2 <open>:
.global open
open:
 li a7, SYS_open
     fc2:	48bd                	li	a7,15
 ecall
     fc4:	00000073          	ecall
 ret
     fc8:	8082                	ret

0000000000000fca <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     fca:	48c5                	li	a7,17
 ecall
     fcc:	00000073          	ecall
 ret
     fd0:	8082                	ret

0000000000000fd2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     fd2:	48c9                	li	a7,18
 ecall
     fd4:	00000073          	ecall
 ret
     fd8:	8082                	ret

0000000000000fda <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     fda:	48a1                	li	a7,8
 ecall
     fdc:	00000073          	ecall
 ret
     fe0:	8082                	ret

0000000000000fe2 <link>:
.global link
link:
 li a7, SYS_link
     fe2:	48cd                	li	a7,19
 ecall
     fe4:	00000073          	ecall
 ret
     fe8:	8082                	ret

0000000000000fea <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     fea:	48d1                	li	a7,20
 ecall
     fec:	00000073          	ecall
 ret
     ff0:	8082                	ret

0000000000000ff2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     ff2:	48a5                	li	a7,9
 ecall
     ff4:	00000073          	ecall
 ret
     ff8:	8082                	ret

0000000000000ffa <dup>:
.global dup
dup:
 li a7, SYS_dup
     ffa:	48a9                	li	a7,10
 ecall
     ffc:	00000073          	ecall
 ret
    1000:	8082                	ret

0000000000001002 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1002:	48ad                	li	a7,11
 ecall
    1004:	00000073          	ecall
 ret
    1008:	8082                	ret

000000000000100a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    100a:	48b1                	li	a7,12
 ecall
    100c:	00000073          	ecall
 ret
    1010:	8082                	ret

0000000000001012 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1012:	48b5                	li	a7,13
 ecall
    1014:	00000073          	ecall
 ret
    1018:	8082                	ret

000000000000101a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    101a:	48b9                	li	a7,14
 ecall
    101c:	00000073          	ecall
 ret
    1020:	8082                	ret

0000000000001022 <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
    1022:	48d9                	li	a7,22
 ecall
    1024:	00000073          	ecall
 ret
    1028:	8082                	ret

000000000000102a <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
    102a:	48dd                	li	a7,23
 ecall
    102c:	00000073          	ecall
 ret
    1030:	8082                	ret

0000000000001032 <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
    1032:	48e1                	li	a7,24
 ecall
    1034:	00000073          	ecall
 ret
    1038:	8082                	ret

000000000000103a <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
    103a:	48ed                	li	a7,27
 ecall
    103c:	00000073          	ecall
 ret
    1040:	8082                	ret

0000000000001042 <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
    1042:	48f1                	li	a7,28
 ecall
    1044:	00000073          	ecall
 ret
    1048:	8082                	ret

000000000000104a <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
    104a:	48e9                	li	a7,26
 ecall
    104c:	00000073          	ecall
 ret
    1050:	8082                	ret

0000000000001052 <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
    1052:	48e5                	li	a7,25
 ecall
    1054:	00000073          	ecall
 ret
    1058:	8082                	ret

000000000000105a <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
    105a:	48f5                	li	a7,29
 ecall
    105c:	00000073          	ecall
 ret
    1060:	8082                	ret

0000000000001062 <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
    1062:	48f9                	li	a7,30
 ecall
    1064:	00000073          	ecall
 ret
    1068:	8082                	ret

000000000000106a <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
    106a:	48fd                	li	a7,31
 ecall
    106c:	00000073          	ecall
 ret
    1070:	8082                	ret

0000000000001072 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
    1072:	02000893          	li	a7,32
 ecall
    1076:	00000073          	ecall
 ret
    107a:	8082                	ret

000000000000107c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    107c:	1101                	addi	sp,sp,-32
    107e:	ec06                	sd	ra,24(sp)
    1080:	e822                	sd	s0,16(sp)
    1082:	1000                	addi	s0,sp,32
    1084:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1088:	4605                	li	a2,1
    108a:	fef40593          	addi	a1,s0,-17
    108e:	00000097          	auipc	ra,0x0
    1092:	f14080e7          	jalr	-236(ra) # fa2 <write>
}
    1096:	60e2                	ld	ra,24(sp)
    1098:	6442                	ld	s0,16(sp)
    109a:	6105                	addi	sp,sp,32
    109c:	8082                	ret

000000000000109e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    109e:	7139                	addi	sp,sp,-64
    10a0:	fc06                	sd	ra,56(sp)
    10a2:	f822                	sd	s0,48(sp)
    10a4:	f426                	sd	s1,40(sp)
    10a6:	f04a                	sd	s2,32(sp)
    10a8:	ec4e                	sd	s3,24(sp)
    10aa:	0080                	addi	s0,sp,64
    10ac:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    10ae:	c299                	beqz	a3,10b4 <printint+0x16>
    10b0:	0805c863          	bltz	a1,1140 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    10b4:	2581                	sext.w	a1,a1
  neg = 0;
    10b6:	4881                	li	a7,0
    10b8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    10bc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    10be:	2601                	sext.w	a2,a2
    10c0:	00000517          	auipc	a0,0x0
    10c4:	72850513          	addi	a0,a0,1832 # 17e8 <digits>
    10c8:	883a                	mv	a6,a4
    10ca:	2705                	addiw	a4,a4,1
    10cc:	02c5f7bb          	remuw	a5,a1,a2
    10d0:	1782                	slli	a5,a5,0x20
    10d2:	9381                	srli	a5,a5,0x20
    10d4:	97aa                	add	a5,a5,a0
    10d6:	0007c783          	lbu	a5,0(a5)
    10da:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    10de:	0005879b          	sext.w	a5,a1
    10e2:	02c5d5bb          	divuw	a1,a1,a2
    10e6:	0685                	addi	a3,a3,1
    10e8:	fec7f0e3          	bgeu	a5,a2,10c8 <printint+0x2a>
  if(neg)
    10ec:	00088b63          	beqz	a7,1102 <printint+0x64>
    buf[i++] = '-';
    10f0:	fd040793          	addi	a5,s0,-48
    10f4:	973e                	add	a4,a4,a5
    10f6:	02d00793          	li	a5,45
    10fa:	fef70823          	sb	a5,-16(a4)
    10fe:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1102:	02e05863          	blez	a4,1132 <printint+0x94>
    1106:	fc040793          	addi	a5,s0,-64
    110a:	00e78933          	add	s2,a5,a4
    110e:	fff78993          	addi	s3,a5,-1
    1112:	99ba                	add	s3,s3,a4
    1114:	377d                	addiw	a4,a4,-1
    1116:	1702                	slli	a4,a4,0x20
    1118:	9301                	srli	a4,a4,0x20
    111a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    111e:	fff94583          	lbu	a1,-1(s2)
    1122:	8526                	mv	a0,s1
    1124:	00000097          	auipc	ra,0x0
    1128:	f58080e7          	jalr	-168(ra) # 107c <putc>
  while(--i >= 0)
    112c:	197d                	addi	s2,s2,-1
    112e:	ff3918e3          	bne	s2,s3,111e <printint+0x80>
}
    1132:	70e2                	ld	ra,56(sp)
    1134:	7442                	ld	s0,48(sp)
    1136:	74a2                	ld	s1,40(sp)
    1138:	7902                	ld	s2,32(sp)
    113a:	69e2                	ld	s3,24(sp)
    113c:	6121                	addi	sp,sp,64
    113e:	8082                	ret
    x = -xx;
    1140:	40b005bb          	negw	a1,a1
    neg = 1;
    1144:	4885                	li	a7,1
    x = -xx;
    1146:	bf8d                	j	10b8 <printint+0x1a>

0000000000001148 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1148:	7119                	addi	sp,sp,-128
    114a:	fc86                	sd	ra,120(sp)
    114c:	f8a2                	sd	s0,112(sp)
    114e:	f4a6                	sd	s1,104(sp)
    1150:	f0ca                	sd	s2,96(sp)
    1152:	ecce                	sd	s3,88(sp)
    1154:	e8d2                	sd	s4,80(sp)
    1156:	e4d6                	sd	s5,72(sp)
    1158:	e0da                	sd	s6,64(sp)
    115a:	fc5e                	sd	s7,56(sp)
    115c:	f862                	sd	s8,48(sp)
    115e:	f466                	sd	s9,40(sp)
    1160:	f06a                	sd	s10,32(sp)
    1162:	ec6e                	sd	s11,24(sp)
    1164:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1166:	0005c903          	lbu	s2,0(a1)
    116a:	18090f63          	beqz	s2,1308 <vprintf+0x1c0>
    116e:	8aaa                	mv	s5,a0
    1170:	8b32                	mv	s6,a2
    1172:	00158493          	addi	s1,a1,1
  state = 0;
    1176:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1178:	02500a13          	li	s4,37
      if(c == 'd'){
    117c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    1180:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    1184:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    1188:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    118c:	00000b97          	auipc	s7,0x0
    1190:	65cb8b93          	addi	s7,s7,1628 # 17e8 <digits>
    1194:	a839                	j	11b2 <vprintf+0x6a>
        putc(fd, c);
    1196:	85ca                	mv	a1,s2
    1198:	8556                	mv	a0,s5
    119a:	00000097          	auipc	ra,0x0
    119e:	ee2080e7          	jalr	-286(ra) # 107c <putc>
    11a2:	a019                	j	11a8 <vprintf+0x60>
    } else if(state == '%'){
    11a4:	01498f63          	beq	s3,s4,11c2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    11a8:	0485                	addi	s1,s1,1
    11aa:	fff4c903          	lbu	s2,-1(s1)
    11ae:	14090d63          	beqz	s2,1308 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    11b2:	0009079b          	sext.w	a5,s2
    if(state == 0){
    11b6:	fe0997e3          	bnez	s3,11a4 <vprintf+0x5c>
      if(c == '%'){
    11ba:	fd479ee3          	bne	a5,s4,1196 <vprintf+0x4e>
        state = '%';
    11be:	89be                	mv	s3,a5
    11c0:	b7e5                	j	11a8 <vprintf+0x60>
      if(c == 'd'){
    11c2:	05878063          	beq	a5,s8,1202 <vprintf+0xba>
      } else if(c == 'l') {
    11c6:	05978c63          	beq	a5,s9,121e <vprintf+0xd6>
      } else if(c == 'x') {
    11ca:	07a78863          	beq	a5,s10,123a <vprintf+0xf2>
      } else if(c == 'p') {
    11ce:	09b78463          	beq	a5,s11,1256 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    11d2:	07300713          	li	a4,115
    11d6:	0ce78663          	beq	a5,a4,12a2 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    11da:	06300713          	li	a4,99
    11de:	0ee78e63          	beq	a5,a4,12da <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    11e2:	11478863          	beq	a5,s4,12f2 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    11e6:	85d2                	mv	a1,s4
    11e8:	8556                	mv	a0,s5
    11ea:	00000097          	auipc	ra,0x0
    11ee:	e92080e7          	jalr	-366(ra) # 107c <putc>
        putc(fd, c);
    11f2:	85ca                	mv	a1,s2
    11f4:	8556                	mv	a0,s5
    11f6:	00000097          	auipc	ra,0x0
    11fa:	e86080e7          	jalr	-378(ra) # 107c <putc>
      }
      state = 0;
    11fe:	4981                	li	s3,0
    1200:	b765                	j	11a8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    1202:	008b0913          	addi	s2,s6,8
    1206:	4685                	li	a3,1
    1208:	4629                	li	a2,10
    120a:	000b2583          	lw	a1,0(s6)
    120e:	8556                	mv	a0,s5
    1210:	00000097          	auipc	ra,0x0
    1214:	e8e080e7          	jalr	-370(ra) # 109e <printint>
    1218:	8b4a                	mv	s6,s2
      state = 0;
    121a:	4981                	li	s3,0
    121c:	b771                	j	11a8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    121e:	008b0913          	addi	s2,s6,8
    1222:	4681                	li	a3,0
    1224:	4629                	li	a2,10
    1226:	000b2583          	lw	a1,0(s6)
    122a:	8556                	mv	a0,s5
    122c:	00000097          	auipc	ra,0x0
    1230:	e72080e7          	jalr	-398(ra) # 109e <printint>
    1234:	8b4a                	mv	s6,s2
      state = 0;
    1236:	4981                	li	s3,0
    1238:	bf85                	j	11a8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    123a:	008b0913          	addi	s2,s6,8
    123e:	4681                	li	a3,0
    1240:	4641                	li	a2,16
    1242:	000b2583          	lw	a1,0(s6)
    1246:	8556                	mv	a0,s5
    1248:	00000097          	auipc	ra,0x0
    124c:	e56080e7          	jalr	-426(ra) # 109e <printint>
    1250:	8b4a                	mv	s6,s2
      state = 0;
    1252:	4981                	li	s3,0
    1254:	bf91                	j	11a8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1256:	008b0793          	addi	a5,s6,8
    125a:	f8f43423          	sd	a5,-120(s0)
    125e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1262:	03000593          	li	a1,48
    1266:	8556                	mv	a0,s5
    1268:	00000097          	auipc	ra,0x0
    126c:	e14080e7          	jalr	-492(ra) # 107c <putc>
  putc(fd, 'x');
    1270:	85ea                	mv	a1,s10
    1272:	8556                	mv	a0,s5
    1274:	00000097          	auipc	ra,0x0
    1278:	e08080e7          	jalr	-504(ra) # 107c <putc>
    127c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    127e:	03c9d793          	srli	a5,s3,0x3c
    1282:	97de                	add	a5,a5,s7
    1284:	0007c583          	lbu	a1,0(a5)
    1288:	8556                	mv	a0,s5
    128a:	00000097          	auipc	ra,0x0
    128e:	df2080e7          	jalr	-526(ra) # 107c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1292:	0992                	slli	s3,s3,0x4
    1294:	397d                	addiw	s2,s2,-1
    1296:	fe0914e3          	bnez	s2,127e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    129a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    129e:	4981                	li	s3,0
    12a0:	b721                	j	11a8 <vprintf+0x60>
        s = va_arg(ap, char*);
    12a2:	008b0993          	addi	s3,s6,8
    12a6:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    12aa:	02090163          	beqz	s2,12cc <vprintf+0x184>
        while(*s != 0){
    12ae:	00094583          	lbu	a1,0(s2)
    12b2:	c9a1                	beqz	a1,1302 <vprintf+0x1ba>
          putc(fd, *s);
    12b4:	8556                	mv	a0,s5
    12b6:	00000097          	auipc	ra,0x0
    12ba:	dc6080e7          	jalr	-570(ra) # 107c <putc>
          s++;
    12be:	0905                	addi	s2,s2,1
        while(*s != 0){
    12c0:	00094583          	lbu	a1,0(s2)
    12c4:	f9e5                	bnez	a1,12b4 <vprintf+0x16c>
        s = va_arg(ap, char*);
    12c6:	8b4e                	mv	s6,s3
      state = 0;
    12c8:	4981                	li	s3,0
    12ca:	bdf9                	j	11a8 <vprintf+0x60>
          s = "(null)";
    12cc:	00000917          	auipc	s2,0x0
    12d0:	51490913          	addi	s2,s2,1300 # 17e0 <malloc+0x3ce>
        while(*s != 0){
    12d4:	02800593          	li	a1,40
    12d8:	bff1                	j	12b4 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    12da:	008b0913          	addi	s2,s6,8
    12de:	000b4583          	lbu	a1,0(s6)
    12e2:	8556                	mv	a0,s5
    12e4:	00000097          	auipc	ra,0x0
    12e8:	d98080e7          	jalr	-616(ra) # 107c <putc>
    12ec:	8b4a                	mv	s6,s2
      state = 0;
    12ee:	4981                	li	s3,0
    12f0:	bd65                	j	11a8 <vprintf+0x60>
        putc(fd, c);
    12f2:	85d2                	mv	a1,s4
    12f4:	8556                	mv	a0,s5
    12f6:	00000097          	auipc	ra,0x0
    12fa:	d86080e7          	jalr	-634(ra) # 107c <putc>
      state = 0;
    12fe:	4981                	li	s3,0
    1300:	b565                	j	11a8 <vprintf+0x60>
        s = va_arg(ap, char*);
    1302:	8b4e                	mv	s6,s3
      state = 0;
    1304:	4981                	li	s3,0
    1306:	b54d                	j	11a8 <vprintf+0x60>
    }
  }
}
    1308:	70e6                	ld	ra,120(sp)
    130a:	7446                	ld	s0,112(sp)
    130c:	74a6                	ld	s1,104(sp)
    130e:	7906                	ld	s2,96(sp)
    1310:	69e6                	ld	s3,88(sp)
    1312:	6a46                	ld	s4,80(sp)
    1314:	6aa6                	ld	s5,72(sp)
    1316:	6b06                	ld	s6,64(sp)
    1318:	7be2                	ld	s7,56(sp)
    131a:	7c42                	ld	s8,48(sp)
    131c:	7ca2                	ld	s9,40(sp)
    131e:	7d02                	ld	s10,32(sp)
    1320:	6de2                	ld	s11,24(sp)
    1322:	6109                	addi	sp,sp,128
    1324:	8082                	ret

0000000000001326 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1326:	715d                	addi	sp,sp,-80
    1328:	ec06                	sd	ra,24(sp)
    132a:	e822                	sd	s0,16(sp)
    132c:	1000                	addi	s0,sp,32
    132e:	e010                	sd	a2,0(s0)
    1330:	e414                	sd	a3,8(s0)
    1332:	e818                	sd	a4,16(s0)
    1334:	ec1c                	sd	a5,24(s0)
    1336:	03043023          	sd	a6,32(s0)
    133a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    133e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1342:	8622                	mv	a2,s0
    1344:	00000097          	auipc	ra,0x0
    1348:	e04080e7          	jalr	-508(ra) # 1148 <vprintf>
}
    134c:	60e2                	ld	ra,24(sp)
    134e:	6442                	ld	s0,16(sp)
    1350:	6161                	addi	sp,sp,80
    1352:	8082                	ret

0000000000001354 <printf>:

void
printf(const char *fmt, ...)
{
    1354:	711d                	addi	sp,sp,-96
    1356:	ec06                	sd	ra,24(sp)
    1358:	e822                	sd	s0,16(sp)
    135a:	1000                	addi	s0,sp,32
    135c:	e40c                	sd	a1,8(s0)
    135e:	e810                	sd	a2,16(s0)
    1360:	ec14                	sd	a3,24(s0)
    1362:	f018                	sd	a4,32(s0)
    1364:	f41c                	sd	a5,40(s0)
    1366:	03043823          	sd	a6,48(s0)
    136a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    136e:	00840613          	addi	a2,s0,8
    1372:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1376:	85aa                	mv	a1,a0
    1378:	4505                	li	a0,1
    137a:	00000097          	auipc	ra,0x0
    137e:	dce080e7          	jalr	-562(ra) # 1148 <vprintf>
}
    1382:	60e2                	ld	ra,24(sp)
    1384:	6442                	ld	s0,16(sp)
    1386:	6125                	addi	sp,sp,96
    1388:	8082                	ret

000000000000138a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    138a:	1141                	addi	sp,sp,-16
    138c:	e422                	sd	s0,8(sp)
    138e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1390:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1394:	00000797          	auipc	a5,0x0
    1398:	4747b783          	ld	a5,1140(a5) # 1808 <freep>
    139c:	a805                	j	13cc <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    139e:	4618                	lw	a4,8(a2)
    13a0:	9db9                	addw	a1,a1,a4
    13a2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    13a6:	6398                	ld	a4,0(a5)
    13a8:	6318                	ld	a4,0(a4)
    13aa:	fee53823          	sd	a4,-16(a0)
    13ae:	a091                	j	13f2 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    13b0:	ff852703          	lw	a4,-8(a0)
    13b4:	9e39                	addw	a2,a2,a4
    13b6:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    13b8:	ff053703          	ld	a4,-16(a0)
    13bc:	e398                	sd	a4,0(a5)
    13be:	a099                	j	1404 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    13c0:	6398                	ld	a4,0(a5)
    13c2:	00e7e463          	bltu	a5,a4,13ca <free+0x40>
    13c6:	00e6ea63          	bltu	a3,a4,13da <free+0x50>
{
    13ca:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    13cc:	fed7fae3          	bgeu	a5,a3,13c0 <free+0x36>
    13d0:	6398                	ld	a4,0(a5)
    13d2:	00e6e463          	bltu	a3,a4,13da <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    13d6:	fee7eae3          	bltu	a5,a4,13ca <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    13da:	ff852583          	lw	a1,-8(a0)
    13de:	6390                	ld	a2,0(a5)
    13e0:	02059813          	slli	a6,a1,0x20
    13e4:	01c85713          	srli	a4,a6,0x1c
    13e8:	9736                	add	a4,a4,a3
    13ea:	fae60ae3          	beq	a2,a4,139e <free+0x14>
    bp->s.ptr = p->s.ptr;
    13ee:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    13f2:	4790                	lw	a2,8(a5)
    13f4:	02061593          	slli	a1,a2,0x20
    13f8:	01c5d713          	srli	a4,a1,0x1c
    13fc:	973e                	add	a4,a4,a5
    13fe:	fae689e3          	beq	a3,a4,13b0 <free+0x26>
  } else
    p->s.ptr = bp;
    1402:	e394                	sd	a3,0(a5)
  freep = p;
    1404:	00000717          	auipc	a4,0x0
    1408:	40f73223          	sd	a5,1028(a4) # 1808 <freep>
}
    140c:	6422                	ld	s0,8(sp)
    140e:	0141                	addi	sp,sp,16
    1410:	8082                	ret

0000000000001412 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1412:	7139                	addi	sp,sp,-64
    1414:	fc06                	sd	ra,56(sp)
    1416:	f822                	sd	s0,48(sp)
    1418:	f426                	sd	s1,40(sp)
    141a:	f04a                	sd	s2,32(sp)
    141c:	ec4e                	sd	s3,24(sp)
    141e:	e852                	sd	s4,16(sp)
    1420:	e456                	sd	s5,8(sp)
    1422:	e05a                	sd	s6,0(sp)
    1424:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1426:	02051493          	slli	s1,a0,0x20
    142a:	9081                	srli	s1,s1,0x20
    142c:	04bd                	addi	s1,s1,15
    142e:	8091                	srli	s1,s1,0x4
    1430:	0014899b          	addiw	s3,s1,1
    1434:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1436:	00000517          	auipc	a0,0x0
    143a:	3d253503          	ld	a0,978(a0) # 1808 <freep>
    143e:	c515                	beqz	a0,146a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1440:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1442:	4798                	lw	a4,8(a5)
    1444:	02977f63          	bgeu	a4,s1,1482 <malloc+0x70>
    1448:	8a4e                	mv	s4,s3
    144a:	0009871b          	sext.w	a4,s3
    144e:	6685                	lui	a3,0x1
    1450:	00d77363          	bgeu	a4,a3,1456 <malloc+0x44>
    1454:	6a05                	lui	s4,0x1
    1456:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    145a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    145e:	00000917          	auipc	s2,0x0
    1462:	3aa90913          	addi	s2,s2,938 # 1808 <freep>
  if(p == (char*)-1)
    1466:	5afd                	li	s5,-1
    1468:	a895                	j	14dc <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    146a:	00000797          	auipc	a5,0x0
    146e:	78e78793          	addi	a5,a5,1934 # 1bf8 <base>
    1472:	00000717          	auipc	a4,0x0
    1476:	38f73b23          	sd	a5,918(a4) # 1808 <freep>
    147a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    147c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1480:	b7e1                	j	1448 <malloc+0x36>
      if(p->s.size == nunits)
    1482:	02e48c63          	beq	s1,a4,14ba <malloc+0xa8>
        p->s.size -= nunits;
    1486:	4137073b          	subw	a4,a4,s3
    148a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    148c:	02071693          	slli	a3,a4,0x20
    1490:	01c6d713          	srli	a4,a3,0x1c
    1494:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1496:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    149a:	00000717          	auipc	a4,0x0
    149e:	36a73723          	sd	a0,878(a4) # 1808 <freep>
      return (void*)(p + 1);
    14a2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    14a6:	70e2                	ld	ra,56(sp)
    14a8:	7442                	ld	s0,48(sp)
    14aa:	74a2                	ld	s1,40(sp)
    14ac:	7902                	ld	s2,32(sp)
    14ae:	69e2                	ld	s3,24(sp)
    14b0:	6a42                	ld	s4,16(sp)
    14b2:	6aa2                	ld	s5,8(sp)
    14b4:	6b02                	ld	s6,0(sp)
    14b6:	6121                	addi	sp,sp,64
    14b8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    14ba:	6398                	ld	a4,0(a5)
    14bc:	e118                	sd	a4,0(a0)
    14be:	bff1                	j	149a <malloc+0x88>
  hp->s.size = nu;
    14c0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    14c4:	0541                	addi	a0,a0,16
    14c6:	00000097          	auipc	ra,0x0
    14ca:	ec4080e7          	jalr	-316(ra) # 138a <free>
  return freep;
    14ce:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    14d2:	d971                	beqz	a0,14a6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    14d6:	4798                	lw	a4,8(a5)
    14d8:	fa9775e3          	bgeu	a4,s1,1482 <malloc+0x70>
    if(p == freep)
    14dc:	00093703          	ld	a4,0(s2)
    14e0:	853e                	mv	a0,a5
    14e2:	fef719e3          	bne	a4,a5,14d4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    14e6:	8552                	mv	a0,s4
    14e8:	00000097          	auipc	ra,0x0
    14ec:	b22080e7          	jalr	-1246(ra) # 100a <sbrk>
  if(p == (char*)-1)
    14f0:	fd5518e3          	bne	a0,s5,14c0 <malloc+0xae>
        return 0;
    14f4:	4501                	li	a0,0
    14f6:	bf45                	j	14a6 <malloc+0x94>
