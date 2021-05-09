
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	9ea50513          	addi	a0,a0,-1558 # 9f8 <malloc+0xe6>
  16:	00000097          	auipc	ra,0x0
  1a:	4ac080e7          	jalr	1196(ra) # 4c2 <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	4d6080e7          	jalr	1238(ra) # 4fa <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	4cc080e7          	jalr	1228(ra) # 4fa <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	9ca90913          	addi	s2,s2,-1590 # a00 <malloc+0xee>
  3e:	854a                	mv	a0,s2
  40:	00001097          	auipc	ra,0x1
  44:	814080e7          	jalr	-2028(ra) # 854 <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	432080e7          	jalr	1074(ra) # 47a <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	04054d63          	bltz	a0,ac <main+0xac>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  56:	c925                	beqz	a0,c6 <main+0xc6>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	430080e7          	jalr	1072(ra) # 48a <wait>
      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	9e650513          	addi	a0,a0,-1562 # a50 <malloc+0x13e>
  72:	00000097          	auipc	ra,0x0
  76:	7e2080e7          	jalr	2018(ra) # 854 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	406080e7          	jalr	1030(ra) # 482 <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	97050513          	addi	a0,a0,-1680 # 9f8 <malloc+0xe6>
  90:	00000097          	auipc	ra,0x0
  94:	43a080e7          	jalr	1082(ra) # 4ca <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	95e50513          	addi	a0,a0,-1698 # 9f8 <malloc+0xe6>
  a2:	00000097          	auipc	ra,0x0
  a6:	420080e7          	jalr	1056(ra) # 4c2 <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	96c50513          	addi	a0,a0,-1684 # a18 <malloc+0x106>
  b4:	00000097          	auipc	ra,0x0
  b8:	7a0080e7          	jalr	1952(ra) # 854 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	3c4080e7          	jalr	964(ra) # 482 <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	9ca58593          	addi	a1,a1,-1590 # a90 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	96250513          	addi	a0,a0,-1694 # a30 <malloc+0x11e>
  d6:	00000097          	auipc	ra,0x0
  da:	3e4080e7          	jalr	996(ra) # 4ba <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	95a50513          	addi	a0,a0,-1702 # a38 <malloc+0x126>
  e6:	00000097          	auipc	ra,0x0
  ea:	76e080e7          	jalr	1902(ra) # 854 <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	392080e7          	jalr	914(ra) # 482 <exit>

00000000000000f8 <strcpy>:
#include "kernel/Csemaphore.h"


char*
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fe:	87aa                	mv	a5,a0
 100:	0585                	addi	a1,a1,1
 102:	0785                	addi	a5,a5,1
 104:	fff5c703          	lbu	a4,-1(a1)
 108:	fee78fa3          	sb	a4,-1(a5)
 10c:	fb75                	bnez	a4,100 <strcpy+0x8>
    ;
  return os;
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret

0000000000000114 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cb91                	beqz	a5,132 <strcmp+0x1e>
 120:	0005c703          	lbu	a4,0(a1)
 124:	00f71763          	bne	a4,a5,132 <strcmp+0x1e>
    p++, q++;
 128:	0505                	addi	a0,a0,1
 12a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 12c:	00054783          	lbu	a5,0(a0)
 130:	fbe5                	bnez	a5,120 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 132:	0005c503          	lbu	a0,0(a1)
}
 136:	40a7853b          	subw	a0,a5,a0
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <strlen>:

uint
strlen(const char *s)
{
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cf91                	beqz	a5,166 <strlen+0x26>
 14c:	0505                	addi	a0,a0,1
 14e:	87aa                	mv	a5,a0
 150:	4685                	li	a3,1
 152:	9e89                	subw	a3,a3,a0
 154:	00f6853b          	addw	a0,a3,a5
 158:	0785                	addi	a5,a5,1
 15a:	fff7c703          	lbu	a4,-1(a5)
 15e:	fb7d                	bnez	a4,154 <strlen+0x14>
    ;
  return n;
}
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret
  for(n = 0; s[n]; n++)
 166:	4501                	li	a0,0
 168:	bfe5                	j	160 <strlen+0x20>

000000000000016a <memset>:

void*
memset(void *dst, int c, uint n)
{
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 170:	ca19                	beqz	a2,186 <memset+0x1c>
 172:	87aa                	mv	a5,a0
 174:	1602                	slli	a2,a2,0x20
 176:	9201                	srli	a2,a2,0x20
 178:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 17c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 180:	0785                	addi	a5,a5,1
 182:	fee79de3          	bne	a5,a4,17c <memset+0x12>
  }
  return dst;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret

000000000000018c <strchr>:

char*
strchr(const char *s, char c)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	addi	s0,sp,16
  for(; *s; s++)
 192:	00054783          	lbu	a5,0(a0)
 196:	cb99                	beqz	a5,1ac <strchr+0x20>
    if(*s == c)
 198:	00f58763          	beq	a1,a5,1a6 <strchr+0x1a>
  for(; *s; s++)
 19c:	0505                	addi	a0,a0,1
 19e:	00054783          	lbu	a5,0(a0)
 1a2:	fbfd                	bnez	a5,198 <strchr+0xc>
      return (char*)s;
  return 0;
 1a4:	4501                	li	a0,0
}
 1a6:	6422                	ld	s0,8(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret
  return 0;
 1ac:	4501                	li	a0,0
 1ae:	bfe5                	j	1a6 <strchr+0x1a>

00000000000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	711d                	addi	sp,sp,-96
 1b2:	ec86                	sd	ra,88(sp)
 1b4:	e8a2                	sd	s0,80(sp)
 1b6:	e4a6                	sd	s1,72(sp)
 1b8:	e0ca                	sd	s2,64(sp)
 1ba:	fc4e                	sd	s3,56(sp)
 1bc:	f852                	sd	s4,48(sp)
 1be:	f456                	sd	s5,40(sp)
 1c0:	f05a                	sd	s6,32(sp)
 1c2:	ec5e                	sd	s7,24(sp)
 1c4:	1080                	addi	s0,sp,96
 1c6:	8baa                	mv	s7,a0
 1c8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ca:	892a                	mv	s2,a0
 1cc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ce:	4aa9                	li	s5,10
 1d0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d2:	89a6                	mv	s3,s1
 1d4:	2485                	addiw	s1,s1,1
 1d6:	0344d863          	bge	s1,s4,206 <gets+0x56>
    cc = read(0, &c, 1);
 1da:	4605                	li	a2,1
 1dc:	faf40593          	addi	a1,s0,-81
 1e0:	4501                	li	a0,0
 1e2:	00000097          	auipc	ra,0x0
 1e6:	2b8080e7          	jalr	696(ra) # 49a <read>
    if(cc < 1)
 1ea:	00a05e63          	blez	a0,206 <gets+0x56>
    buf[i++] = c;
 1ee:	faf44783          	lbu	a5,-81(s0)
 1f2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f6:	01578763          	beq	a5,s5,204 <gets+0x54>
 1fa:	0905                	addi	s2,s2,1
 1fc:	fd679be3          	bne	a5,s6,1d2 <gets+0x22>
  for(i=0; i+1 < max; ){
 200:	89a6                	mv	s3,s1
 202:	a011                	j	206 <gets+0x56>
 204:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 206:	99de                	add	s3,s3,s7
 208:	00098023          	sb	zero,0(s3)
  return buf;
}
 20c:	855e                	mv	a0,s7
 20e:	60e6                	ld	ra,88(sp)
 210:	6446                	ld	s0,80(sp)
 212:	64a6                	ld	s1,72(sp)
 214:	6906                	ld	s2,64(sp)
 216:	79e2                	ld	s3,56(sp)
 218:	7a42                	ld	s4,48(sp)
 21a:	7aa2                	ld	s5,40(sp)
 21c:	7b02                	ld	s6,32(sp)
 21e:	6be2                	ld	s7,24(sp)
 220:	6125                	addi	sp,sp,96
 222:	8082                	ret

0000000000000224 <stat>:

int
stat(const char *n, struct stat *st)
{
 224:	1101                	addi	sp,sp,-32
 226:	ec06                	sd	ra,24(sp)
 228:	e822                	sd	s0,16(sp)
 22a:	e426                	sd	s1,8(sp)
 22c:	e04a                	sd	s2,0(sp)
 22e:	1000                	addi	s0,sp,32
 230:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 232:	4581                	li	a1,0
 234:	00000097          	auipc	ra,0x0
 238:	28e080e7          	jalr	654(ra) # 4c2 <open>
  if(fd < 0)
 23c:	02054563          	bltz	a0,266 <stat+0x42>
 240:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 242:	85ca                	mv	a1,s2
 244:	00000097          	auipc	ra,0x0
 248:	296080e7          	jalr	662(ra) # 4da <fstat>
 24c:	892a                	mv	s2,a0
  close(fd);
 24e:	8526                	mv	a0,s1
 250:	00000097          	auipc	ra,0x0
 254:	25a080e7          	jalr	602(ra) # 4aa <close>
  return r;
}
 258:	854a                	mv	a0,s2
 25a:	60e2                	ld	ra,24(sp)
 25c:	6442                	ld	s0,16(sp)
 25e:	64a2                	ld	s1,8(sp)
 260:	6902                	ld	s2,0(sp)
 262:	6105                	addi	sp,sp,32
 264:	8082                	ret
    return -1;
 266:	597d                	li	s2,-1
 268:	bfc5                	j	258 <stat+0x34>

000000000000026a <atoi>:

int
atoi(const char *s)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 270:	00054603          	lbu	a2,0(a0)
 274:	fd06079b          	addiw	a5,a2,-48
 278:	0ff7f793          	andi	a5,a5,255
 27c:	4725                	li	a4,9
 27e:	02f76963          	bltu	a4,a5,2b0 <atoi+0x46>
 282:	86aa                	mv	a3,a0
  n = 0;
 284:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 286:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 288:	0685                	addi	a3,a3,1
 28a:	0025179b          	slliw	a5,a0,0x2
 28e:	9fa9                	addw	a5,a5,a0
 290:	0017979b          	slliw	a5,a5,0x1
 294:	9fb1                	addw	a5,a5,a2
 296:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 29a:	0006c603          	lbu	a2,0(a3)
 29e:	fd06071b          	addiw	a4,a2,-48
 2a2:	0ff77713          	andi	a4,a4,255
 2a6:	fee5f1e3          	bgeu	a1,a4,288 <atoi+0x1e>
  return n;
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
  n = 0;
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <atoi+0x40>

00000000000002b4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ba:	02b57463          	bgeu	a0,a1,2e2 <memmove+0x2e>
    while(n-- > 0)
 2be:	00c05f63          	blez	a2,2dc <memmove+0x28>
 2c2:	1602                	slli	a2,a2,0x20
 2c4:	9201                	srli	a2,a2,0x20
 2c6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ca:	872a                	mv	a4,a0
      *dst++ = *src++;
 2cc:	0585                	addi	a1,a1,1
 2ce:	0705                	addi	a4,a4,1
 2d0:	fff5c683          	lbu	a3,-1(a1)
 2d4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d8:	fee79ae3          	bne	a5,a4,2cc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2dc:	6422                	ld	s0,8(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
    dst += n;
 2e2:	00c50733          	add	a4,a0,a2
    src += n;
 2e6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2e8:	fec05ae3          	blez	a2,2dc <memmove+0x28>
 2ec:	fff6079b          	addiw	a5,a2,-1
 2f0:	1782                	slli	a5,a5,0x20
 2f2:	9381                	srli	a5,a5,0x20
 2f4:	fff7c793          	not	a5,a5
 2f8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2fa:	15fd                	addi	a1,a1,-1
 2fc:	177d                	addi	a4,a4,-1
 2fe:	0005c683          	lbu	a3,0(a1)
 302:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 306:	fee79ae3          	bne	a5,a4,2fa <memmove+0x46>
 30a:	bfc9                	j	2dc <memmove+0x28>

000000000000030c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 312:	ca05                	beqz	a2,342 <memcmp+0x36>
 314:	fff6069b          	addiw	a3,a2,-1
 318:	1682                	slli	a3,a3,0x20
 31a:	9281                	srli	a3,a3,0x20
 31c:	0685                	addi	a3,a3,1
 31e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 320:	00054783          	lbu	a5,0(a0)
 324:	0005c703          	lbu	a4,0(a1)
 328:	00e79863          	bne	a5,a4,338 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 32c:	0505                	addi	a0,a0,1
    p2++;
 32e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 330:	fed518e3          	bne	a0,a3,320 <memcmp+0x14>
  }
  return 0;
 334:	4501                	li	a0,0
 336:	a019                	j	33c <memcmp+0x30>
      return *p1 - *p2;
 338:	40e7853b          	subw	a0,a5,a4
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
  return 0;
 342:	4501                	li	a0,0
 344:	bfe5                	j	33c <memcmp+0x30>

0000000000000346 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 346:	1141                	addi	sp,sp,-16
 348:	e406                	sd	ra,8(sp)
 34a:	e022                	sd	s0,0(sp)
 34c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34e:	00000097          	auipc	ra,0x0
 352:	f66080e7          	jalr	-154(ra) # 2b4 <memmove>
}
 356:	60a2                	ld	ra,8(sp)
 358:	6402                	ld	s0,0(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret

000000000000035e <csem_down>:


void 
csem_down(struct counting_semaphore *sem) {
 35e:	1101                	addi	sp,sp,-32
 360:	ec06                	sd	ra,24(sp)
 362:	e822                	sd	s0,16(sp)
 364:	e426                	sd	s1,8(sp)
 366:	1000                	addi	s0,sp,32
 368:	84aa                	mv	s1,a0
    bsem_down(sem->bsem2);
 36a:	4148                	lw	a0,4(a0)
 36c:	00000097          	auipc	ra,0x0
 370:	1ce080e7          	jalr	462(ra) # 53a <bsem_down>
    bsem_down(sem->bsem1);
 374:	4088                	lw	a0,0(s1)
 376:	00000097          	auipc	ra,0x0
 37a:	1c4080e7          	jalr	452(ra) # 53a <bsem_down>
    sem->count -= 1;
 37e:	449c                	lw	a5,8(s1)
 380:	37fd                	addiw	a5,a5,-1
 382:	0007871b          	sext.w	a4,a5
 386:	c49c                	sw	a5,8(s1)
    if (sem->count > 0)
 388:	00e04c63          	bgtz	a4,3a0 <csem_down+0x42>
    	bsem_up(sem->bsem2);
    bsem_up(sem->bsem1);
 38c:	4088                	lw	a0,0(s1)
 38e:	00000097          	auipc	ra,0x0
 392:	1b4080e7          	jalr	436(ra) # 542 <bsem_up>
}
 396:	60e2                	ld	ra,24(sp)
 398:	6442                	ld	s0,16(sp)
 39a:	64a2                	ld	s1,8(sp)
 39c:	6105                	addi	sp,sp,32
 39e:	8082                	ret
    	bsem_up(sem->bsem2);
 3a0:	40c8                	lw	a0,4(s1)
 3a2:	00000097          	auipc	ra,0x0
 3a6:	1a0080e7          	jalr	416(ra) # 542 <bsem_up>
 3aa:	b7cd                	j	38c <csem_down+0x2e>

00000000000003ac <csem_up>:


void 
csem_up(struct counting_semaphore *sem) {
 3ac:	1101                	addi	sp,sp,-32
 3ae:	ec06                	sd	ra,24(sp)
 3b0:	e822                	sd	s0,16(sp)
 3b2:	e426                	sd	s1,8(sp)
 3b4:	1000                	addi	s0,sp,32
 3b6:	84aa                	mv	s1,a0
	bsem_down(sem->bsem1);
 3b8:	4108                	lw	a0,0(a0)
 3ba:	00000097          	auipc	ra,0x0
 3be:	180080e7          	jalr	384(ra) # 53a <bsem_down>
	sem->count += 1;
 3c2:	449c                	lw	a5,8(s1)
 3c4:	2785                	addiw	a5,a5,1
 3c6:	0007871b          	sext.w	a4,a5
 3ca:	c49c                	sw	a5,8(s1)
	if (sem->count == 1)
 3cc:	4785                	li	a5,1
 3ce:	00f70c63          	beq	a4,a5,3e6 <csem_up+0x3a>
		bsem_up(sem->bsem2);
	bsem_up(sem->bsem1);
 3d2:	4088                	lw	a0,0(s1)
 3d4:	00000097          	auipc	ra,0x0
 3d8:	16e080e7          	jalr	366(ra) # 542 <bsem_up>
}
 3dc:	60e2                	ld	ra,24(sp)
 3de:	6442                	ld	s0,16(sp)
 3e0:	64a2                	ld	s1,8(sp)
 3e2:	6105                	addi	sp,sp,32
 3e4:	8082                	ret
		bsem_up(sem->bsem2);
 3e6:	40c8                	lw	a0,4(s1)
 3e8:	00000097          	auipc	ra,0x0
 3ec:	15a080e7          	jalr	346(ra) # 542 <bsem_up>
 3f0:	b7cd                	j	3d2 <csem_up+0x26>

00000000000003f2 <csem_alloc>:


int 
csem_alloc(struct counting_semaphore *sem, int count) {
 3f2:	7179                	addi	sp,sp,-48
 3f4:	f406                	sd	ra,40(sp)
 3f6:	f022                	sd	s0,32(sp)
 3f8:	ec26                	sd	s1,24(sp)
 3fa:	e84a                	sd	s2,16(sp)
 3fc:	e44e                	sd	s3,8(sp)
 3fe:	1800                	addi	s0,sp,48
 400:	892a                	mv	s2,a0
 402:	89ae                	mv	s3,a1
    int bsem1 = bsem_alloc();
 404:	00000097          	auipc	ra,0x0
 408:	14e080e7          	jalr	334(ra) # 552 <bsem_alloc>
 40c:	84aa                	mv	s1,a0
    int bsem2 = bsem_alloc();
 40e:	00000097          	auipc	ra,0x0
 412:	144080e7          	jalr	324(ra) # 552 <bsem_alloc>
    if (bsem1 == -1 || bsem2 == -1)
 416:	57fd                	li	a5,-1
 418:	00f48d63          	beq	s1,a5,432 <csem_alloc+0x40>
 41c:	02f50863          	beq	a0,a5,44c <csem_alloc+0x5a>
        return -1; 
    sem->bsem1 = bsem1;
 420:	00992023          	sw	s1,0(s2)
    sem->bsem2 = bsem2;
 424:	00a92223          	sw	a0,4(s2)
    if (count == 0)
 428:	00098d63          	beqz	s3,442 <csem_alloc+0x50>
        // Binary semaphore first value = min(1, count)
        bsem_down(sem->bsem2); 
    sem->count = count;
 42c:	01392423          	sw	s3,8(s2)
    return 0;
 430:	4481                	li	s1,0
}
 432:	8526                	mv	a0,s1
 434:	70a2                	ld	ra,40(sp)
 436:	7402                	ld	s0,32(sp)
 438:	64e2                	ld	s1,24(sp)
 43a:	6942                	ld	s2,16(sp)
 43c:	69a2                	ld	s3,8(sp)
 43e:	6145                	addi	sp,sp,48
 440:	8082                	ret
        bsem_down(sem->bsem2); 
 442:	00000097          	auipc	ra,0x0
 446:	0f8080e7          	jalr	248(ra) # 53a <bsem_down>
 44a:	b7cd                	j	42c <csem_alloc+0x3a>
        return -1; 
 44c:	84aa                	mv	s1,a0
 44e:	b7d5                	j	432 <csem_alloc+0x40>

0000000000000450 <csem_free>:


void 
csem_free(struct counting_semaphore *sem) {
 450:	1101                	addi	sp,sp,-32
 452:	ec06                	sd	ra,24(sp)
 454:	e822                	sd	s0,16(sp)
 456:	e426                	sd	s1,8(sp)
 458:	1000                	addi	s0,sp,32
 45a:	84aa                	mv	s1,a0
    bsem_free(sem->bsem1);
 45c:	4108                	lw	a0,0(a0)
 45e:	00000097          	auipc	ra,0x0
 462:	0ec080e7          	jalr	236(ra) # 54a <bsem_free>
    bsem_free(sem->bsem2);
 466:	40c8                	lw	a0,4(s1)
 468:	00000097          	auipc	ra,0x0
 46c:	0e2080e7          	jalr	226(ra) # 54a <bsem_free>
    //free(sem);
}
 470:	60e2                	ld	ra,24(sp)
 472:	6442                	ld	s0,16(sp)
 474:	64a2                	ld	s1,8(sp)
 476:	6105                	addi	sp,sp,32
 478:	8082                	ret

000000000000047a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 47a:	4885                	li	a7,1
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <exit>:
.global exit
exit:
 li a7, SYS_exit
 482:	4889                	li	a7,2
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <wait>:
.global wait
wait:
 li a7, SYS_wait
 48a:	488d                	li	a7,3
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 492:	4891                	li	a7,4
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <read>:
.global read
read:
 li a7, SYS_read
 49a:	4895                	li	a7,5
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <write>:
.global write
write:
 li a7, SYS_write
 4a2:	48c1                	li	a7,16
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <close>:
.global close
close:
 li a7, SYS_close
 4aa:	48d5                	li	a7,21
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4b2:	4899                	li	a7,6
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <exec>:
.global exec
exec:
 li a7, SYS_exec
 4ba:	489d                	li	a7,7
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <open>:
.global open
open:
 li a7, SYS_open
 4c2:	48bd                	li	a7,15
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4ca:	48c5                	li	a7,17
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4d2:	48c9                	li	a7,18
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4da:	48a1                	li	a7,8
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <link>:
.global link
link:
 li a7, SYS_link
 4e2:	48cd                	li	a7,19
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ea:	48d1                	li	a7,20
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4f2:	48a5                	li	a7,9
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <dup>:
.global dup
dup:
 li a7, SYS_dup
 4fa:	48a9                	li	a7,10
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 502:	48ad                	li	a7,11
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 50a:	48b1                	li	a7,12
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 512:	48b5                	li	a7,13
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 51a:	48b9                	li	a7,14
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 522:	48d9                	li	a7,22
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 52a:	48dd                	li	a7,23
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 532:	48e1                	li	a7,24
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
 53a:	48ed                	li	a7,27
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
 542:	48f1                	li	a7,28
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
 54a:	48e9                	li	a7,26
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
 552:	48e5                	li	a7,25
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
 55a:	48f5                	li	a7,29
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
 562:	48f9                	li	a7,30
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
 56a:	48fd                	li	a7,31
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
 572:	02000893          	li	a7,32
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 57c:	1101                	addi	sp,sp,-32
 57e:	ec06                	sd	ra,24(sp)
 580:	e822                	sd	s0,16(sp)
 582:	1000                	addi	s0,sp,32
 584:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 588:	4605                	li	a2,1
 58a:	fef40593          	addi	a1,s0,-17
 58e:	00000097          	auipc	ra,0x0
 592:	f14080e7          	jalr	-236(ra) # 4a2 <write>
}
 596:	60e2                	ld	ra,24(sp)
 598:	6442                	ld	s0,16(sp)
 59a:	6105                	addi	sp,sp,32
 59c:	8082                	ret

000000000000059e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 59e:	7139                	addi	sp,sp,-64
 5a0:	fc06                	sd	ra,56(sp)
 5a2:	f822                	sd	s0,48(sp)
 5a4:	f426                	sd	s1,40(sp)
 5a6:	f04a                	sd	s2,32(sp)
 5a8:	ec4e                	sd	s3,24(sp)
 5aa:	0080                	addi	s0,sp,64
 5ac:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5ae:	c299                	beqz	a3,5b4 <printint+0x16>
 5b0:	0805c863          	bltz	a1,640 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5b4:	2581                	sext.w	a1,a1
  neg = 0;
 5b6:	4881                	li	a7,0
 5b8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5bc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5be:	2601                	sext.w	a2,a2
 5c0:	00000517          	auipc	a0,0x0
 5c4:	4b850513          	addi	a0,a0,1208 # a78 <digits>
 5c8:	883a                	mv	a6,a4
 5ca:	2705                	addiw	a4,a4,1
 5cc:	02c5f7bb          	remuw	a5,a1,a2
 5d0:	1782                	slli	a5,a5,0x20
 5d2:	9381                	srli	a5,a5,0x20
 5d4:	97aa                	add	a5,a5,a0
 5d6:	0007c783          	lbu	a5,0(a5)
 5da:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5de:	0005879b          	sext.w	a5,a1
 5e2:	02c5d5bb          	divuw	a1,a1,a2
 5e6:	0685                	addi	a3,a3,1
 5e8:	fec7f0e3          	bgeu	a5,a2,5c8 <printint+0x2a>
  if(neg)
 5ec:	00088b63          	beqz	a7,602 <printint+0x64>
    buf[i++] = '-';
 5f0:	fd040793          	addi	a5,s0,-48
 5f4:	973e                	add	a4,a4,a5
 5f6:	02d00793          	li	a5,45
 5fa:	fef70823          	sb	a5,-16(a4)
 5fe:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 602:	02e05863          	blez	a4,632 <printint+0x94>
 606:	fc040793          	addi	a5,s0,-64
 60a:	00e78933          	add	s2,a5,a4
 60e:	fff78993          	addi	s3,a5,-1
 612:	99ba                	add	s3,s3,a4
 614:	377d                	addiw	a4,a4,-1
 616:	1702                	slli	a4,a4,0x20
 618:	9301                	srli	a4,a4,0x20
 61a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 61e:	fff94583          	lbu	a1,-1(s2)
 622:	8526                	mv	a0,s1
 624:	00000097          	auipc	ra,0x0
 628:	f58080e7          	jalr	-168(ra) # 57c <putc>
  while(--i >= 0)
 62c:	197d                	addi	s2,s2,-1
 62e:	ff3918e3          	bne	s2,s3,61e <printint+0x80>
}
 632:	70e2                	ld	ra,56(sp)
 634:	7442                	ld	s0,48(sp)
 636:	74a2                	ld	s1,40(sp)
 638:	7902                	ld	s2,32(sp)
 63a:	69e2                	ld	s3,24(sp)
 63c:	6121                	addi	sp,sp,64
 63e:	8082                	ret
    x = -xx;
 640:	40b005bb          	negw	a1,a1
    neg = 1;
 644:	4885                	li	a7,1
    x = -xx;
 646:	bf8d                	j	5b8 <printint+0x1a>

0000000000000648 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 648:	7119                	addi	sp,sp,-128
 64a:	fc86                	sd	ra,120(sp)
 64c:	f8a2                	sd	s0,112(sp)
 64e:	f4a6                	sd	s1,104(sp)
 650:	f0ca                	sd	s2,96(sp)
 652:	ecce                	sd	s3,88(sp)
 654:	e8d2                	sd	s4,80(sp)
 656:	e4d6                	sd	s5,72(sp)
 658:	e0da                	sd	s6,64(sp)
 65a:	fc5e                	sd	s7,56(sp)
 65c:	f862                	sd	s8,48(sp)
 65e:	f466                	sd	s9,40(sp)
 660:	f06a                	sd	s10,32(sp)
 662:	ec6e                	sd	s11,24(sp)
 664:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 666:	0005c903          	lbu	s2,0(a1)
 66a:	18090f63          	beqz	s2,808 <vprintf+0x1c0>
 66e:	8aaa                	mv	s5,a0
 670:	8b32                	mv	s6,a2
 672:	00158493          	addi	s1,a1,1
  state = 0;
 676:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 678:	02500a13          	li	s4,37
      if(c == 'd'){
 67c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 680:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 684:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 688:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68c:	00000b97          	auipc	s7,0x0
 690:	3ecb8b93          	addi	s7,s7,1004 # a78 <digits>
 694:	a839                	j	6b2 <vprintf+0x6a>
        putc(fd, c);
 696:	85ca                	mv	a1,s2
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	ee2080e7          	jalr	-286(ra) # 57c <putc>
 6a2:	a019                	j	6a8 <vprintf+0x60>
    } else if(state == '%'){
 6a4:	01498f63          	beq	s3,s4,6c2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6a8:	0485                	addi	s1,s1,1
 6aa:	fff4c903          	lbu	s2,-1(s1)
 6ae:	14090d63          	beqz	s2,808 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6b2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6b6:	fe0997e3          	bnez	s3,6a4 <vprintf+0x5c>
      if(c == '%'){
 6ba:	fd479ee3          	bne	a5,s4,696 <vprintf+0x4e>
        state = '%';
 6be:	89be                	mv	s3,a5
 6c0:	b7e5                	j	6a8 <vprintf+0x60>
      if(c == 'd'){
 6c2:	05878063          	beq	a5,s8,702 <vprintf+0xba>
      } else if(c == 'l') {
 6c6:	05978c63          	beq	a5,s9,71e <vprintf+0xd6>
      } else if(c == 'x') {
 6ca:	07a78863          	beq	a5,s10,73a <vprintf+0xf2>
      } else if(c == 'p') {
 6ce:	09b78463          	beq	a5,s11,756 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6d2:	07300713          	li	a4,115
 6d6:	0ce78663          	beq	a5,a4,7a2 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6da:	06300713          	li	a4,99
 6de:	0ee78e63          	beq	a5,a4,7da <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6e2:	11478863          	beq	a5,s4,7f2 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6e6:	85d2                	mv	a1,s4
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	e92080e7          	jalr	-366(ra) # 57c <putc>
        putc(fd, c);
 6f2:	85ca                	mv	a1,s2
 6f4:	8556                	mv	a0,s5
 6f6:	00000097          	auipc	ra,0x0
 6fa:	e86080e7          	jalr	-378(ra) # 57c <putc>
      }
      state = 0;
 6fe:	4981                	li	s3,0
 700:	b765                	j	6a8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 702:	008b0913          	addi	s2,s6,8
 706:	4685                	li	a3,1
 708:	4629                	li	a2,10
 70a:	000b2583          	lw	a1,0(s6)
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	e8e080e7          	jalr	-370(ra) # 59e <printint>
 718:	8b4a                	mv	s6,s2
      state = 0;
 71a:	4981                	li	s3,0
 71c:	b771                	j	6a8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 71e:	008b0913          	addi	s2,s6,8
 722:	4681                	li	a3,0
 724:	4629                	li	a2,10
 726:	000b2583          	lw	a1,0(s6)
 72a:	8556                	mv	a0,s5
 72c:	00000097          	auipc	ra,0x0
 730:	e72080e7          	jalr	-398(ra) # 59e <printint>
 734:	8b4a                	mv	s6,s2
      state = 0;
 736:	4981                	li	s3,0
 738:	bf85                	j	6a8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 73a:	008b0913          	addi	s2,s6,8
 73e:	4681                	li	a3,0
 740:	4641                	li	a2,16
 742:	000b2583          	lw	a1,0(s6)
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	e56080e7          	jalr	-426(ra) # 59e <printint>
 750:	8b4a                	mv	s6,s2
      state = 0;
 752:	4981                	li	s3,0
 754:	bf91                	j	6a8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 756:	008b0793          	addi	a5,s6,8
 75a:	f8f43423          	sd	a5,-120(s0)
 75e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 762:	03000593          	li	a1,48
 766:	8556                	mv	a0,s5
 768:	00000097          	auipc	ra,0x0
 76c:	e14080e7          	jalr	-492(ra) # 57c <putc>
  putc(fd, 'x');
 770:	85ea                	mv	a1,s10
 772:	8556                	mv	a0,s5
 774:	00000097          	auipc	ra,0x0
 778:	e08080e7          	jalr	-504(ra) # 57c <putc>
 77c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 77e:	03c9d793          	srli	a5,s3,0x3c
 782:	97de                	add	a5,a5,s7
 784:	0007c583          	lbu	a1,0(a5)
 788:	8556                	mv	a0,s5
 78a:	00000097          	auipc	ra,0x0
 78e:	df2080e7          	jalr	-526(ra) # 57c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 792:	0992                	slli	s3,s3,0x4
 794:	397d                	addiw	s2,s2,-1
 796:	fe0914e3          	bnez	s2,77e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 79a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	b721                	j	6a8 <vprintf+0x60>
        s = va_arg(ap, char*);
 7a2:	008b0993          	addi	s3,s6,8
 7a6:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7aa:	02090163          	beqz	s2,7cc <vprintf+0x184>
        while(*s != 0){
 7ae:	00094583          	lbu	a1,0(s2)
 7b2:	c9a1                	beqz	a1,802 <vprintf+0x1ba>
          putc(fd, *s);
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	dc6080e7          	jalr	-570(ra) # 57c <putc>
          s++;
 7be:	0905                	addi	s2,s2,1
        while(*s != 0){
 7c0:	00094583          	lbu	a1,0(s2)
 7c4:	f9e5                	bnez	a1,7b4 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7c6:	8b4e                	mv	s6,s3
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	bdf9                	j	6a8 <vprintf+0x60>
          s = "(null)";
 7cc:	00000917          	auipc	s2,0x0
 7d0:	2a490913          	addi	s2,s2,676 # a70 <malloc+0x15e>
        while(*s != 0){
 7d4:	02800593          	li	a1,40
 7d8:	bff1                	j	7b4 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7da:	008b0913          	addi	s2,s6,8
 7de:	000b4583          	lbu	a1,0(s6)
 7e2:	8556                	mv	a0,s5
 7e4:	00000097          	auipc	ra,0x0
 7e8:	d98080e7          	jalr	-616(ra) # 57c <putc>
 7ec:	8b4a                	mv	s6,s2
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	bd65                	j	6a8 <vprintf+0x60>
        putc(fd, c);
 7f2:	85d2                	mv	a1,s4
 7f4:	8556                	mv	a0,s5
 7f6:	00000097          	auipc	ra,0x0
 7fa:	d86080e7          	jalr	-634(ra) # 57c <putc>
      state = 0;
 7fe:	4981                	li	s3,0
 800:	b565                	j	6a8 <vprintf+0x60>
        s = va_arg(ap, char*);
 802:	8b4e                	mv	s6,s3
      state = 0;
 804:	4981                	li	s3,0
 806:	b54d                	j	6a8 <vprintf+0x60>
    }
  }
}
 808:	70e6                	ld	ra,120(sp)
 80a:	7446                	ld	s0,112(sp)
 80c:	74a6                	ld	s1,104(sp)
 80e:	7906                	ld	s2,96(sp)
 810:	69e6                	ld	s3,88(sp)
 812:	6a46                	ld	s4,80(sp)
 814:	6aa6                	ld	s5,72(sp)
 816:	6b06                	ld	s6,64(sp)
 818:	7be2                	ld	s7,56(sp)
 81a:	7c42                	ld	s8,48(sp)
 81c:	7ca2                	ld	s9,40(sp)
 81e:	7d02                	ld	s10,32(sp)
 820:	6de2                	ld	s11,24(sp)
 822:	6109                	addi	sp,sp,128
 824:	8082                	ret

0000000000000826 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 826:	715d                	addi	sp,sp,-80
 828:	ec06                	sd	ra,24(sp)
 82a:	e822                	sd	s0,16(sp)
 82c:	1000                	addi	s0,sp,32
 82e:	e010                	sd	a2,0(s0)
 830:	e414                	sd	a3,8(s0)
 832:	e818                	sd	a4,16(s0)
 834:	ec1c                	sd	a5,24(s0)
 836:	03043023          	sd	a6,32(s0)
 83a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 83e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 842:	8622                	mv	a2,s0
 844:	00000097          	auipc	ra,0x0
 848:	e04080e7          	jalr	-508(ra) # 648 <vprintf>
}
 84c:	60e2                	ld	ra,24(sp)
 84e:	6442                	ld	s0,16(sp)
 850:	6161                	addi	sp,sp,80
 852:	8082                	ret

0000000000000854 <printf>:

void
printf(const char *fmt, ...)
{
 854:	711d                	addi	sp,sp,-96
 856:	ec06                	sd	ra,24(sp)
 858:	e822                	sd	s0,16(sp)
 85a:	1000                	addi	s0,sp,32
 85c:	e40c                	sd	a1,8(s0)
 85e:	e810                	sd	a2,16(s0)
 860:	ec14                	sd	a3,24(s0)
 862:	f018                	sd	a4,32(s0)
 864:	f41c                	sd	a5,40(s0)
 866:	03043823          	sd	a6,48(s0)
 86a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 86e:	00840613          	addi	a2,s0,8
 872:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 876:	85aa                	mv	a1,a0
 878:	4505                	li	a0,1
 87a:	00000097          	auipc	ra,0x0
 87e:	dce080e7          	jalr	-562(ra) # 648 <vprintf>
}
 882:	60e2                	ld	ra,24(sp)
 884:	6442                	ld	s0,16(sp)
 886:	6125                	addi	sp,sp,96
 888:	8082                	ret

000000000000088a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 88a:	1141                	addi	sp,sp,-16
 88c:	e422                	sd	s0,8(sp)
 88e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 890:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 894:	00000797          	auipc	a5,0x0
 898:	20c7b783          	ld	a5,524(a5) # aa0 <freep>
 89c:	a805                	j	8cc <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 89e:	4618                	lw	a4,8(a2)
 8a0:	9db9                	addw	a1,a1,a4
 8a2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a6:	6398                	ld	a4,0(a5)
 8a8:	6318                	ld	a4,0(a4)
 8aa:	fee53823          	sd	a4,-16(a0)
 8ae:	a091                	j	8f2 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8b0:	ff852703          	lw	a4,-8(a0)
 8b4:	9e39                	addw	a2,a2,a4
 8b6:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8b8:	ff053703          	ld	a4,-16(a0)
 8bc:	e398                	sd	a4,0(a5)
 8be:	a099                	j	904 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c0:	6398                	ld	a4,0(a5)
 8c2:	00e7e463          	bltu	a5,a4,8ca <free+0x40>
 8c6:	00e6ea63          	bltu	a3,a4,8da <free+0x50>
{
 8ca:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8cc:	fed7fae3          	bgeu	a5,a3,8c0 <free+0x36>
 8d0:	6398                	ld	a4,0(a5)
 8d2:	00e6e463          	bltu	a3,a4,8da <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d6:	fee7eae3          	bltu	a5,a4,8ca <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8da:	ff852583          	lw	a1,-8(a0)
 8de:	6390                	ld	a2,0(a5)
 8e0:	02059813          	slli	a6,a1,0x20
 8e4:	01c85713          	srli	a4,a6,0x1c
 8e8:	9736                	add	a4,a4,a3
 8ea:	fae60ae3          	beq	a2,a4,89e <free+0x14>
    bp->s.ptr = p->s.ptr;
 8ee:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8f2:	4790                	lw	a2,8(a5)
 8f4:	02061593          	slli	a1,a2,0x20
 8f8:	01c5d713          	srli	a4,a1,0x1c
 8fc:	973e                	add	a4,a4,a5
 8fe:	fae689e3          	beq	a3,a4,8b0 <free+0x26>
  } else
    p->s.ptr = bp;
 902:	e394                	sd	a3,0(a5)
  freep = p;
 904:	00000717          	auipc	a4,0x0
 908:	18f73e23          	sd	a5,412(a4) # aa0 <freep>
}
 90c:	6422                	ld	s0,8(sp)
 90e:	0141                	addi	sp,sp,16
 910:	8082                	ret

0000000000000912 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 912:	7139                	addi	sp,sp,-64
 914:	fc06                	sd	ra,56(sp)
 916:	f822                	sd	s0,48(sp)
 918:	f426                	sd	s1,40(sp)
 91a:	f04a                	sd	s2,32(sp)
 91c:	ec4e                	sd	s3,24(sp)
 91e:	e852                	sd	s4,16(sp)
 920:	e456                	sd	s5,8(sp)
 922:	e05a                	sd	s6,0(sp)
 924:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 926:	02051493          	slli	s1,a0,0x20
 92a:	9081                	srli	s1,s1,0x20
 92c:	04bd                	addi	s1,s1,15
 92e:	8091                	srli	s1,s1,0x4
 930:	0014899b          	addiw	s3,s1,1
 934:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 936:	00000517          	auipc	a0,0x0
 93a:	16a53503          	ld	a0,362(a0) # aa0 <freep>
 93e:	c515                	beqz	a0,96a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 940:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 942:	4798                	lw	a4,8(a5)
 944:	02977f63          	bgeu	a4,s1,982 <malloc+0x70>
 948:	8a4e                	mv	s4,s3
 94a:	0009871b          	sext.w	a4,s3
 94e:	6685                	lui	a3,0x1
 950:	00d77363          	bgeu	a4,a3,956 <malloc+0x44>
 954:	6a05                	lui	s4,0x1
 956:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 95a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 95e:	00000917          	auipc	s2,0x0
 962:	14290913          	addi	s2,s2,322 # aa0 <freep>
  if(p == (char*)-1)
 966:	5afd                	li	s5,-1
 968:	a895                	j	9dc <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 96a:	00000797          	auipc	a5,0x0
 96e:	13e78793          	addi	a5,a5,318 # aa8 <base>
 972:	00000717          	auipc	a4,0x0
 976:	12f73723          	sd	a5,302(a4) # aa0 <freep>
 97a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 97c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 980:	b7e1                	j	948 <malloc+0x36>
      if(p->s.size == nunits)
 982:	02e48c63          	beq	s1,a4,9ba <malloc+0xa8>
        p->s.size -= nunits;
 986:	4137073b          	subw	a4,a4,s3
 98a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 98c:	02071693          	slli	a3,a4,0x20
 990:	01c6d713          	srli	a4,a3,0x1c
 994:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 996:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 99a:	00000717          	auipc	a4,0x0
 99e:	10a73323          	sd	a0,262(a4) # aa0 <freep>
      return (void*)(p + 1);
 9a2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9a6:	70e2                	ld	ra,56(sp)
 9a8:	7442                	ld	s0,48(sp)
 9aa:	74a2                	ld	s1,40(sp)
 9ac:	7902                	ld	s2,32(sp)
 9ae:	69e2                	ld	s3,24(sp)
 9b0:	6a42                	ld	s4,16(sp)
 9b2:	6aa2                	ld	s5,8(sp)
 9b4:	6b02                	ld	s6,0(sp)
 9b6:	6121                	addi	sp,sp,64
 9b8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9ba:	6398                	ld	a4,0(a5)
 9bc:	e118                	sd	a4,0(a0)
 9be:	bff1                	j	99a <malloc+0x88>
  hp->s.size = nu;
 9c0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9c4:	0541                	addi	a0,a0,16
 9c6:	00000097          	auipc	ra,0x0
 9ca:	ec4080e7          	jalr	-316(ra) # 88a <free>
  return freep;
 9ce:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9d2:	d971                	beqz	a0,9a6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d6:	4798                	lw	a4,8(a5)
 9d8:	fa9775e3          	bgeu	a4,s1,982 <malloc+0x70>
    if(p == freep)
 9dc:	00093703          	ld	a4,0(s2)
 9e0:	853e                	mv	a0,a5
 9e2:	fef719e3          	bne	a4,a5,9d4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9e6:	8552                	mv	a0,s4
 9e8:	00000097          	auipc	ra,0x0
 9ec:	b22080e7          	jalr	-1246(ra) # 50a <sbrk>
  if(p == (char*)-1)
 9f0:	fd5518e3          	bne	a0,s5,9c0 <malloc+0xae>
        return 0;
 9f4:	4501                	li	a0,0
 9f6:	bf45                	j	9a6 <malloc+0x94>
