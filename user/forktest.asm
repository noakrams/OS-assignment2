
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#define N  1000

void
print(const char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  write(1, s, strlen(s));
   c:	00000097          	auipc	ra,0x0
  10:	15a080e7          	jalr	346(ra) # 166 <strlen>
  14:	0005061b          	sext.w	a2,a0
  18:	85a6                	mv	a1,s1
  1a:	4505                	li	a0,1
  1c:	00000097          	auipc	ra,0x0
  20:	4ac080e7          	jalr	1196(ra) # 4c8 <write>
}
  24:	60e2                	ld	ra,24(sp)
  26:	6442                	ld	s0,16(sp)
  28:	64a2                	ld	s1,8(sp)
  2a:	6105                	addi	sp,sp,32
  2c:	8082                	ret

000000000000002e <forktest>:

void
forktest(void)
{
  2e:	1101                	addi	sp,sp,-32
  30:	ec06                	sd	ra,24(sp)
  32:	e822                	sd	s0,16(sp)
  34:	e426                	sd	s1,8(sp)
  36:	e04a                	sd	s2,0(sp)
  38:	1000                	addi	s0,sp,32
  int n, pid;

  print("fork test\n");
  3a:	00000517          	auipc	a0,0x0
  3e:	56e50513          	addi	a0,a0,1390 # 5a8 <kthread_join+0x10>
  42:	00000097          	auipc	ra,0x0
  46:	fbe080e7          	jalr	-66(ra) # 0 <print>

  for(n=0; n<N; n++){
  4a:	4481                	li	s1,0
  4c:	3e800913          	li	s2,1000
    pid = fork();
  50:	00000097          	auipc	ra,0x0
  54:	450080e7          	jalr	1104(ra) # 4a0 <fork>
    if(pid < 0)
  58:	02054763          	bltz	a0,86 <forktest+0x58>
      break;
    if(pid == 0)
  5c:	c10d                	beqz	a0,7e <forktest+0x50>
  for(n=0; n<N; n++){
  5e:	2485                	addiw	s1,s1,1
  60:	ff2498e3          	bne	s1,s2,50 <forktest+0x22>
      exit(0);
  }

  if(n == N){
    print("fork claimed to work N times!\n");
  64:	00000517          	auipc	a0,0x0
  68:	55450513          	addi	a0,a0,1364 # 5b8 <kthread_join+0x20>
  6c:	00000097          	auipc	ra,0x0
  70:	f94080e7          	jalr	-108(ra) # 0 <print>
    exit(1);
  74:	4505                	li	a0,1
  76:	00000097          	auipc	ra,0x0
  7a:	432080e7          	jalr	1074(ra) # 4a8 <exit>
      exit(0);
  7e:	00000097          	auipc	ra,0x0
  82:	42a080e7          	jalr	1066(ra) # 4a8 <exit>
  if(n == N){
  86:	3e800793          	li	a5,1000
  8a:	fcf48de3          	beq	s1,a5,64 <forktest+0x36>
  }

  for(; n > 0; n--){
  8e:	00905b63          	blez	s1,a4 <forktest+0x76>
    if(wait(0) < 0){
  92:	4501                	li	a0,0
  94:	00000097          	auipc	ra,0x0
  98:	41c080e7          	jalr	1052(ra) # 4b0 <wait>
  9c:	02054a63          	bltz	a0,d0 <forktest+0xa2>
  for(; n > 0; n--){
  a0:	34fd                	addiw	s1,s1,-1
  a2:	f8e5                	bnez	s1,92 <forktest+0x64>
      print("wait stopped early\n");
      exit(1);
    }
  }

  if(wait(0) != -1){
  a4:	4501                	li	a0,0
  a6:	00000097          	auipc	ra,0x0
  aa:	40a080e7          	jalr	1034(ra) # 4b0 <wait>
  ae:	57fd                	li	a5,-1
  b0:	02f51d63          	bne	a0,a5,ea <forktest+0xbc>
    print("wait got too many\n");
    exit(1);
  }

  print("fork test OK\n");
  b4:	00000517          	auipc	a0,0x0
  b8:	55450513          	addi	a0,a0,1364 # 608 <kthread_join+0x70>
  bc:	00000097          	auipc	ra,0x0
  c0:	f44080e7          	jalr	-188(ra) # 0 <print>
}
  c4:	60e2                	ld	ra,24(sp)
  c6:	6442                	ld	s0,16(sp)
  c8:	64a2                	ld	s1,8(sp)
  ca:	6902                	ld	s2,0(sp)
  cc:	6105                	addi	sp,sp,32
  ce:	8082                	ret
      print("wait stopped early\n");
  d0:	00000517          	auipc	a0,0x0
  d4:	50850513          	addi	a0,a0,1288 # 5d8 <kthread_join+0x40>
  d8:	00000097          	auipc	ra,0x0
  dc:	f28080e7          	jalr	-216(ra) # 0 <print>
      exit(1);
  e0:	4505                	li	a0,1
  e2:	00000097          	auipc	ra,0x0
  e6:	3c6080e7          	jalr	966(ra) # 4a8 <exit>
    print("wait got too many\n");
  ea:	00000517          	auipc	a0,0x0
  ee:	50650513          	addi	a0,a0,1286 # 5f0 <kthread_join+0x58>
  f2:	00000097          	auipc	ra,0x0
  f6:	f0e080e7          	jalr	-242(ra) # 0 <print>
    exit(1);
  fa:	4505                	li	a0,1
  fc:	00000097          	auipc	ra,0x0
 100:	3ac080e7          	jalr	940(ra) # 4a8 <exit>

0000000000000104 <main>:

int
main(void)
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  forktest();
 10c:	00000097          	auipc	ra,0x0
 110:	f22080e7          	jalr	-222(ra) # 2e <forktest>
  exit(0);
 114:	4501                	li	a0,0
 116:	00000097          	auipc	ra,0x0
 11a:	392080e7          	jalr	914(ra) # 4a8 <exit>

000000000000011e <strcpy>:
#include "kernel/Csemaphore.h"


char*
strcpy(char *s, const char *t)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 124:	87aa                	mv	a5,a0
 126:	0585                	addi	a1,a1,1
 128:	0785                	addi	a5,a5,1
 12a:	fff5c703          	lbu	a4,-1(a1)
 12e:	fee78fa3          	sb	a4,-1(a5)
 132:	fb75                	bnez	a4,126 <strcpy+0x8>
    ;
  return os;
}
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret

000000000000013a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13a:	1141                	addi	sp,sp,-16
 13c:	e422                	sd	s0,8(sp)
 13e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	cb91                	beqz	a5,158 <strcmp+0x1e>
 146:	0005c703          	lbu	a4,0(a1)
 14a:	00f71763          	bne	a4,a5,158 <strcmp+0x1e>
    p++, q++;
 14e:	0505                	addi	a0,a0,1
 150:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 152:	00054783          	lbu	a5,0(a0)
 156:	fbe5                	bnez	a5,146 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 158:	0005c503          	lbu	a0,0(a1)
}
 15c:	40a7853b          	subw	a0,a5,a0
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <strlen>:

uint
strlen(const char *s)
{
 166:	1141                	addi	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cf91                	beqz	a5,18c <strlen+0x26>
 172:	0505                	addi	a0,a0,1
 174:	87aa                	mv	a5,a0
 176:	4685                	li	a3,1
 178:	9e89                	subw	a3,a3,a0
 17a:	00f6853b          	addw	a0,a3,a5
 17e:	0785                	addi	a5,a5,1
 180:	fff7c703          	lbu	a4,-1(a5)
 184:	fb7d                	bnez	a4,17a <strlen+0x14>
    ;
  return n;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  for(n = 0; s[n]; n++)
 18c:	4501                	li	a0,0
 18e:	bfe5                	j	186 <strlen+0x20>

0000000000000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 196:	ca19                	beqz	a2,1ac <memset+0x1c>
 198:	87aa                	mv	a5,a0
 19a:	1602                	slli	a2,a2,0x20
 19c:	9201                	srli	a2,a2,0x20
 19e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a6:	0785                	addi	a5,a5,1
 1a8:	fee79de3          	bne	a5,a4,1a2 <memset+0x12>
  }
  return dst;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strchr>:

char*
strchr(const char *s, char c)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb99                	beqz	a5,1d2 <strchr+0x20>
    if(*s == c)
 1be:	00f58763          	beq	a1,a5,1cc <strchr+0x1a>
  for(; *s; s++)
 1c2:	0505                	addi	a0,a0,1
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	fbfd                	bnez	a5,1be <strchr+0xc>
      return (char*)s;
  return 0;
 1ca:	4501                	li	a0,0
}
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
  return 0;
 1d2:	4501                	li	a0,0
 1d4:	bfe5                	j	1cc <strchr+0x1a>

00000000000001d6 <gets>:

char*
gets(char *buf, int max)
{
 1d6:	711d                	addi	sp,sp,-96
 1d8:	ec86                	sd	ra,88(sp)
 1da:	e8a2                	sd	s0,80(sp)
 1dc:	e4a6                	sd	s1,72(sp)
 1de:	e0ca                	sd	s2,64(sp)
 1e0:	fc4e                	sd	s3,56(sp)
 1e2:	f852                	sd	s4,48(sp)
 1e4:	f456                	sd	s5,40(sp)
 1e6:	f05a                	sd	s6,32(sp)
 1e8:	ec5e                	sd	s7,24(sp)
 1ea:	1080                	addi	s0,sp,96
 1ec:	8baa                	mv	s7,a0
 1ee:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f0:	892a                	mv	s2,a0
 1f2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f4:	4aa9                	li	s5,10
 1f6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1f8:	89a6                	mv	s3,s1
 1fa:	2485                	addiw	s1,s1,1
 1fc:	0344d863          	bge	s1,s4,22c <gets+0x56>
    cc = read(0, &c, 1);
 200:	4605                	li	a2,1
 202:	faf40593          	addi	a1,s0,-81
 206:	4501                	li	a0,0
 208:	00000097          	auipc	ra,0x0
 20c:	2b8080e7          	jalr	696(ra) # 4c0 <read>
    if(cc < 1)
 210:	00a05e63          	blez	a0,22c <gets+0x56>
    buf[i++] = c;
 214:	faf44783          	lbu	a5,-81(s0)
 218:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21c:	01578763          	beq	a5,s5,22a <gets+0x54>
 220:	0905                	addi	s2,s2,1
 222:	fd679be3          	bne	a5,s6,1f8 <gets+0x22>
  for(i=0; i+1 < max; ){
 226:	89a6                	mv	s3,s1
 228:	a011                	j	22c <gets+0x56>
 22a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 22c:	99de                	add	s3,s3,s7
 22e:	00098023          	sb	zero,0(s3)
  return buf;
}
 232:	855e                	mv	a0,s7
 234:	60e6                	ld	ra,88(sp)
 236:	6446                	ld	s0,80(sp)
 238:	64a6                	ld	s1,72(sp)
 23a:	6906                	ld	s2,64(sp)
 23c:	79e2                	ld	s3,56(sp)
 23e:	7a42                	ld	s4,48(sp)
 240:	7aa2                	ld	s5,40(sp)
 242:	7b02                	ld	s6,32(sp)
 244:	6be2                	ld	s7,24(sp)
 246:	6125                	addi	sp,sp,96
 248:	8082                	ret

000000000000024a <stat>:

int
stat(const char *n, struct stat *st)
{
 24a:	1101                	addi	sp,sp,-32
 24c:	ec06                	sd	ra,24(sp)
 24e:	e822                	sd	s0,16(sp)
 250:	e426                	sd	s1,8(sp)
 252:	e04a                	sd	s2,0(sp)
 254:	1000                	addi	s0,sp,32
 256:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 258:	4581                	li	a1,0
 25a:	00000097          	auipc	ra,0x0
 25e:	28e080e7          	jalr	654(ra) # 4e8 <open>
  if(fd < 0)
 262:	02054563          	bltz	a0,28c <stat+0x42>
 266:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 268:	85ca                	mv	a1,s2
 26a:	00000097          	auipc	ra,0x0
 26e:	296080e7          	jalr	662(ra) # 500 <fstat>
 272:	892a                	mv	s2,a0
  close(fd);
 274:	8526                	mv	a0,s1
 276:	00000097          	auipc	ra,0x0
 27a:	25a080e7          	jalr	602(ra) # 4d0 <close>
  return r;
}
 27e:	854a                	mv	a0,s2
 280:	60e2                	ld	ra,24(sp)
 282:	6442                	ld	s0,16(sp)
 284:	64a2                	ld	s1,8(sp)
 286:	6902                	ld	s2,0(sp)
 288:	6105                	addi	sp,sp,32
 28a:	8082                	ret
    return -1;
 28c:	597d                	li	s2,-1
 28e:	bfc5                	j	27e <stat+0x34>

0000000000000290 <atoi>:

int
atoi(const char *s)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 296:	00054603          	lbu	a2,0(a0)
 29a:	fd06079b          	addiw	a5,a2,-48
 29e:	0ff7f793          	andi	a5,a5,255
 2a2:	4725                	li	a4,9
 2a4:	02f76963          	bltu	a4,a5,2d6 <atoi+0x46>
 2a8:	86aa                	mv	a3,a0
  n = 0;
 2aa:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2ac:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2ae:	0685                	addi	a3,a3,1
 2b0:	0025179b          	slliw	a5,a0,0x2
 2b4:	9fa9                	addw	a5,a5,a0
 2b6:	0017979b          	slliw	a5,a5,0x1
 2ba:	9fb1                	addw	a5,a5,a2
 2bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c0:	0006c603          	lbu	a2,0(a3)
 2c4:	fd06071b          	addiw	a4,a2,-48
 2c8:	0ff77713          	andi	a4,a4,255
 2cc:	fee5f1e3          	bgeu	a1,a4,2ae <atoi+0x1e>
  return n;
}
 2d0:	6422                	ld	s0,8(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret
  n = 0;
 2d6:	4501                	li	a0,0
 2d8:	bfe5                	j	2d0 <atoi+0x40>

00000000000002da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e0:	02b57463          	bgeu	a0,a1,308 <memmove+0x2e>
    while(n-- > 0)
 2e4:	00c05f63          	blez	a2,302 <memmove+0x28>
 2e8:	1602                	slli	a2,a2,0x20
 2ea:	9201                	srli	a2,a2,0x20
 2ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f2:	0585                	addi	a1,a1,1
 2f4:	0705                	addi	a4,a4,1
 2f6:	fff5c683          	lbu	a3,-1(a1)
 2fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2fe:	fee79ae3          	bne	a5,a4,2f2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret
    dst += n;
 308:	00c50733          	add	a4,a0,a2
    src += n;
 30c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 30e:	fec05ae3          	blez	a2,302 <memmove+0x28>
 312:	fff6079b          	addiw	a5,a2,-1
 316:	1782                	slli	a5,a5,0x20
 318:	9381                	srli	a5,a5,0x20
 31a:	fff7c793          	not	a5,a5
 31e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 320:	15fd                	addi	a1,a1,-1
 322:	177d                	addi	a4,a4,-1
 324:	0005c683          	lbu	a3,0(a1)
 328:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 32c:	fee79ae3          	bne	a5,a4,320 <memmove+0x46>
 330:	bfc9                	j	302 <memmove+0x28>

0000000000000332 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 332:	1141                	addi	sp,sp,-16
 334:	e422                	sd	s0,8(sp)
 336:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 338:	ca05                	beqz	a2,368 <memcmp+0x36>
 33a:	fff6069b          	addiw	a3,a2,-1
 33e:	1682                	slli	a3,a3,0x20
 340:	9281                	srli	a3,a3,0x20
 342:	0685                	addi	a3,a3,1
 344:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 346:	00054783          	lbu	a5,0(a0)
 34a:	0005c703          	lbu	a4,0(a1)
 34e:	00e79863          	bne	a5,a4,35e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 352:	0505                	addi	a0,a0,1
    p2++;
 354:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 356:	fed518e3          	bne	a0,a3,346 <memcmp+0x14>
  }
  return 0;
 35a:	4501                	li	a0,0
 35c:	a019                	j	362 <memcmp+0x30>
      return *p1 - *p2;
 35e:	40e7853b          	subw	a0,a5,a4
}
 362:	6422                	ld	s0,8(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret
  return 0;
 368:	4501                	li	a0,0
 36a:	bfe5                	j	362 <memcmp+0x30>

000000000000036c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e406                	sd	ra,8(sp)
 370:	e022                	sd	s0,0(sp)
 372:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 374:	00000097          	auipc	ra,0x0
 378:	f66080e7          	jalr	-154(ra) # 2da <memmove>
}
 37c:	60a2                	ld	ra,8(sp)
 37e:	6402                	ld	s0,0(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret

0000000000000384 <csem_down>:


void 
csem_down(struct counting_semaphore *sem) {
 384:	1101                	addi	sp,sp,-32
 386:	ec06                	sd	ra,24(sp)
 388:	e822                	sd	s0,16(sp)
 38a:	e426                	sd	s1,8(sp)
 38c:	1000                	addi	s0,sp,32
 38e:	84aa                	mv	s1,a0
    bsem_down(sem->bsem2);
 390:	4148                	lw	a0,4(a0)
 392:	00000097          	auipc	ra,0x0
 396:	1ce080e7          	jalr	462(ra) # 560 <bsem_down>
    bsem_down(sem->bsem1);
 39a:	4088                	lw	a0,0(s1)
 39c:	00000097          	auipc	ra,0x0
 3a0:	1c4080e7          	jalr	452(ra) # 560 <bsem_down>
    sem->count -= 1;
 3a4:	449c                	lw	a5,8(s1)
 3a6:	37fd                	addiw	a5,a5,-1
 3a8:	0007871b          	sext.w	a4,a5
 3ac:	c49c                	sw	a5,8(s1)
    if (sem->count > 0)
 3ae:	00e04c63          	bgtz	a4,3c6 <csem_down+0x42>
    	bsem_up(sem->bsem2);
    bsem_up(sem->bsem1);
 3b2:	4088                	lw	a0,0(s1)
 3b4:	00000097          	auipc	ra,0x0
 3b8:	1b4080e7          	jalr	436(ra) # 568 <bsem_up>
}
 3bc:	60e2                	ld	ra,24(sp)
 3be:	6442                	ld	s0,16(sp)
 3c0:	64a2                	ld	s1,8(sp)
 3c2:	6105                	addi	sp,sp,32
 3c4:	8082                	ret
    	bsem_up(sem->bsem2);
 3c6:	40c8                	lw	a0,4(s1)
 3c8:	00000097          	auipc	ra,0x0
 3cc:	1a0080e7          	jalr	416(ra) # 568 <bsem_up>
 3d0:	b7cd                	j	3b2 <csem_down+0x2e>

00000000000003d2 <csem_up>:


void 
csem_up(struct counting_semaphore *sem) {
 3d2:	1101                	addi	sp,sp,-32
 3d4:	ec06                	sd	ra,24(sp)
 3d6:	e822                	sd	s0,16(sp)
 3d8:	e426                	sd	s1,8(sp)
 3da:	1000                	addi	s0,sp,32
 3dc:	84aa                	mv	s1,a0
	bsem_down(sem->bsem1);
 3de:	4108                	lw	a0,0(a0)
 3e0:	00000097          	auipc	ra,0x0
 3e4:	180080e7          	jalr	384(ra) # 560 <bsem_down>
	sem->count += 1;
 3e8:	449c                	lw	a5,8(s1)
 3ea:	2785                	addiw	a5,a5,1
 3ec:	0007871b          	sext.w	a4,a5
 3f0:	c49c                	sw	a5,8(s1)
	if (sem->count == 1)
 3f2:	4785                	li	a5,1
 3f4:	00f70c63          	beq	a4,a5,40c <csem_up+0x3a>
		bsem_up(sem->bsem2);
	bsem_up(sem->bsem1);
 3f8:	4088                	lw	a0,0(s1)
 3fa:	00000097          	auipc	ra,0x0
 3fe:	16e080e7          	jalr	366(ra) # 568 <bsem_up>
}
 402:	60e2                	ld	ra,24(sp)
 404:	6442                	ld	s0,16(sp)
 406:	64a2                	ld	s1,8(sp)
 408:	6105                	addi	sp,sp,32
 40a:	8082                	ret
		bsem_up(sem->bsem2);
 40c:	40c8                	lw	a0,4(s1)
 40e:	00000097          	auipc	ra,0x0
 412:	15a080e7          	jalr	346(ra) # 568 <bsem_up>
 416:	b7cd                	j	3f8 <csem_up+0x26>

0000000000000418 <csem_alloc>:


int 
csem_alloc(struct counting_semaphore *sem, int count) {
 418:	7179                	addi	sp,sp,-48
 41a:	f406                	sd	ra,40(sp)
 41c:	f022                	sd	s0,32(sp)
 41e:	ec26                	sd	s1,24(sp)
 420:	e84a                	sd	s2,16(sp)
 422:	e44e                	sd	s3,8(sp)
 424:	1800                	addi	s0,sp,48
 426:	892a                	mv	s2,a0
 428:	89ae                	mv	s3,a1
    int bsem1 = bsem_alloc();
 42a:	00000097          	auipc	ra,0x0
 42e:	14e080e7          	jalr	334(ra) # 578 <bsem_alloc>
 432:	84aa                	mv	s1,a0
    int bsem2 = bsem_alloc();
 434:	00000097          	auipc	ra,0x0
 438:	144080e7          	jalr	324(ra) # 578 <bsem_alloc>
    if (bsem1 == -1 || bsem2 == -1)
 43c:	57fd                	li	a5,-1
 43e:	00f48d63          	beq	s1,a5,458 <csem_alloc+0x40>
 442:	02f50863          	beq	a0,a5,472 <csem_alloc+0x5a>
        return -1; 
    sem->bsem1 = bsem1;
 446:	00992023          	sw	s1,0(s2)
    sem->bsem2 = bsem2;
 44a:	00a92223          	sw	a0,4(s2)
    if (count == 0)
 44e:	00098d63          	beqz	s3,468 <csem_alloc+0x50>
        // Binary semaphore first value = min(1, count)
        bsem_down(sem->bsem2); 
    sem->count = count;
 452:	01392423          	sw	s3,8(s2)
    return 0;
 456:	4481                	li	s1,0
}
 458:	8526                	mv	a0,s1
 45a:	70a2                	ld	ra,40(sp)
 45c:	7402                	ld	s0,32(sp)
 45e:	64e2                	ld	s1,24(sp)
 460:	6942                	ld	s2,16(sp)
 462:	69a2                	ld	s3,8(sp)
 464:	6145                	addi	sp,sp,48
 466:	8082                	ret
        bsem_down(sem->bsem2); 
 468:	00000097          	auipc	ra,0x0
 46c:	0f8080e7          	jalr	248(ra) # 560 <bsem_down>
 470:	b7cd                	j	452 <csem_alloc+0x3a>
        return -1; 
 472:	84aa                	mv	s1,a0
 474:	b7d5                	j	458 <csem_alloc+0x40>

0000000000000476 <csem_free>:


void 
csem_free(struct counting_semaphore *sem) {
 476:	1101                	addi	sp,sp,-32
 478:	ec06                	sd	ra,24(sp)
 47a:	e822                	sd	s0,16(sp)
 47c:	e426                	sd	s1,8(sp)
 47e:	1000                	addi	s0,sp,32
 480:	84aa                	mv	s1,a0
    bsem_free(sem->bsem1);
 482:	4108                	lw	a0,0(a0)
 484:	00000097          	auipc	ra,0x0
 488:	0ec080e7          	jalr	236(ra) # 570 <bsem_free>
    bsem_free(sem->bsem2);
 48c:	40c8                	lw	a0,4(s1)
 48e:	00000097          	auipc	ra,0x0
 492:	0e2080e7          	jalr	226(ra) # 570 <bsem_free>
    //free(sem);
}
 496:	60e2                	ld	ra,24(sp)
 498:	6442                	ld	s0,16(sp)
 49a:	64a2                	ld	s1,8(sp)
 49c:	6105                	addi	sp,sp,32
 49e:	8082                	ret

00000000000004a0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4a0:	4885                	li	a7,1
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4a8:	4889                	li	a7,2
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4b0:	488d                	li	a7,3
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4b8:	4891                	li	a7,4
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <read>:
.global read
read:
 li a7, SYS_read
 4c0:	4895                	li	a7,5
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <write>:
.global write
write:
 li a7, SYS_write
 4c8:	48c1                	li	a7,16
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <close>:
.global close
close:
 li a7, SYS_close
 4d0:	48d5                	li	a7,21
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4d8:	4899                	li	a7,6
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4e0:	489d                	li	a7,7
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <open>:
.global open
open:
 li a7, SYS_open
 4e8:	48bd                	li	a7,15
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4f0:	48c5                	li	a7,17
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4f8:	48c9                	li	a7,18
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 500:	48a1                	li	a7,8
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <link>:
.global link
link:
 li a7, SYS_link
 508:	48cd                	li	a7,19
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 510:	48d1                	li	a7,20
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 518:	48a5                	li	a7,9
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <dup>:
.global dup
dup:
 li a7, SYS_dup
 520:	48a9                	li	a7,10
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 528:	48ad                	li	a7,11
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 530:	48b1                	li	a7,12
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 538:	48b5                	li	a7,13
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 540:	48b9                	li	a7,14
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 548:	48d9                	li	a7,22
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 550:	48dd                	li	a7,23
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 558:	48e1                	li	a7,24
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
 560:	48ed                	li	a7,27
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
 568:	48f1                	li	a7,28
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
 570:	48e9                	li	a7,26
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
 578:	48e5                	li	a7,25
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
 580:	48f5                	li	a7,29
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
 588:	48f9                	li	a7,30
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
 590:	48fd                	li	a7,31
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
 598:	02000893          	li	a7,32
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret
