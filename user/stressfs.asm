
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	a2a78793          	addi	a5,a5,-1494 # a40 <malloc+0x11a>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	9e450513          	addi	a0,a0,-1564 # a10 <malloc+0xea>
  34:	00001097          	auipc	ra,0x1
  38:	834080e7          	jalr	-1996(ra) # 868 <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	136080e7          	jalr	310(ra) # 17e <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	43a080e7          	jalr	1082(ra) # 48e <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	9c050513          	addi	a0,a0,-1600 # a28 <malloc+0x102>
  70:	00000097          	auipc	ra,0x0
  74:	7f8080e7          	jalr	2040(ra) # 868 <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9cbd                	addw	s1,s1,a5
  7e:	fc940c23          	sb	s1,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	44c080e7          	jalr	1100(ra) # 4d6 <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	416080e7          	jalr	1046(ra) # 4b6 <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	410080e7          	jalr	1040(ra) # 4be <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	98250513          	addi	a0,a0,-1662 # a38 <malloc+0x112>
  be:	00000097          	auipc	ra,0x0
  c2:	7aa080e7          	jalr	1962(ra) # 868 <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	40a080e7          	jalr	1034(ra) # 4d6 <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	3cc080e7          	jalr	972(ra) # 4ae <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	3ce080e7          	jalr	974(ra) # 4be <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	3a4080e7          	jalr	932(ra) # 49e <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	392080e7          	jalr	914(ra) # 496 <exit>

000000000000010c <strcpy>:
#include "kernel/Csemaphore.h"


char*
strcpy(char *s, const char *t)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 112:	87aa                	mv	a5,a0
 114:	0585                	addi	a1,a1,1
 116:	0785                	addi	a5,a5,1
 118:	fff5c703          	lbu	a4,-1(a1)
 11c:	fee78fa3          	sb	a4,-1(a5)
 120:	fb75                	bnez	a4,114 <strcpy+0x8>
    ;
  return os;
}
 122:	6422                	ld	s0,8(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e422                	sd	s0,8(sp)
 12c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb91                	beqz	a5,146 <strcmp+0x1e>
 134:	0005c703          	lbu	a4,0(a1)
 138:	00f71763          	bne	a4,a5,146 <strcmp+0x1e>
    p++, q++;
 13c:	0505                	addi	a0,a0,1
 13e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	fbe5                	bnez	a5,134 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 146:	0005c503          	lbu	a0,0(a1)
}
 14a:	40a7853b          	subw	a0,a5,a0
 14e:	6422                	ld	s0,8(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret

0000000000000154 <strlen>:

uint
strlen(const char *s)
{
 154:	1141                	addi	sp,sp,-16
 156:	e422                	sd	s0,8(sp)
 158:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	cf91                	beqz	a5,17a <strlen+0x26>
 160:	0505                	addi	a0,a0,1
 162:	87aa                	mv	a5,a0
 164:	4685                	li	a3,1
 166:	9e89                	subw	a3,a3,a0
 168:	00f6853b          	addw	a0,a3,a5
 16c:	0785                	addi	a5,a5,1
 16e:	fff7c703          	lbu	a4,-1(a5)
 172:	fb7d                	bnez	a4,168 <strlen+0x14>
    ;
  return n;
}
 174:	6422                	ld	s0,8(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret
  for(n = 0; s[n]; n++)
 17a:	4501                	li	a0,0
 17c:	bfe5                	j	174 <strlen+0x20>

000000000000017e <memset>:

void*
memset(void *dst, int c, uint n)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 184:	ca19                	beqz	a2,19a <memset+0x1c>
 186:	87aa                	mv	a5,a0
 188:	1602                	slli	a2,a2,0x20
 18a:	9201                	srli	a2,a2,0x20
 18c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 190:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 194:	0785                	addi	a5,a5,1
 196:	fee79de3          	bne	a5,a4,190 <memset+0x12>
  }
  return dst;
}
 19a:	6422                	ld	s0,8(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret

00000000000001a0 <strchr>:

char*
strchr(const char *s, char c)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e422                	sd	s0,8(sp)
 1a4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	cb99                	beqz	a5,1c0 <strchr+0x20>
    if(*s == c)
 1ac:	00f58763          	beq	a1,a5,1ba <strchr+0x1a>
  for(; *s; s++)
 1b0:	0505                	addi	a0,a0,1
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	fbfd                	bnez	a5,1ac <strchr+0xc>
      return (char*)s;
  return 0;
 1b8:	4501                	li	a0,0
}
 1ba:	6422                	ld	s0,8(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret
  return 0;
 1c0:	4501                	li	a0,0
 1c2:	bfe5                	j	1ba <strchr+0x1a>

00000000000001c4 <gets>:

char*
gets(char *buf, int max)
{
 1c4:	711d                	addi	sp,sp,-96
 1c6:	ec86                	sd	ra,88(sp)
 1c8:	e8a2                	sd	s0,80(sp)
 1ca:	e4a6                	sd	s1,72(sp)
 1cc:	e0ca                	sd	s2,64(sp)
 1ce:	fc4e                	sd	s3,56(sp)
 1d0:	f852                	sd	s4,48(sp)
 1d2:	f456                	sd	s5,40(sp)
 1d4:	f05a                	sd	s6,32(sp)
 1d6:	ec5e                	sd	s7,24(sp)
 1d8:	1080                	addi	s0,sp,96
 1da:	8baa                	mv	s7,a0
 1dc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1de:	892a                	mv	s2,a0
 1e0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e2:	4aa9                	li	s5,10
 1e4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1e6:	89a6                	mv	s3,s1
 1e8:	2485                	addiw	s1,s1,1
 1ea:	0344d863          	bge	s1,s4,21a <gets+0x56>
    cc = read(0, &c, 1);
 1ee:	4605                	li	a2,1
 1f0:	faf40593          	addi	a1,s0,-81
 1f4:	4501                	li	a0,0
 1f6:	00000097          	auipc	ra,0x0
 1fa:	2b8080e7          	jalr	696(ra) # 4ae <read>
    if(cc < 1)
 1fe:	00a05e63          	blez	a0,21a <gets+0x56>
    buf[i++] = c;
 202:	faf44783          	lbu	a5,-81(s0)
 206:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 20a:	01578763          	beq	a5,s5,218 <gets+0x54>
 20e:	0905                	addi	s2,s2,1
 210:	fd679be3          	bne	a5,s6,1e6 <gets+0x22>
  for(i=0; i+1 < max; ){
 214:	89a6                	mv	s3,s1
 216:	a011                	j	21a <gets+0x56>
 218:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 21a:	99de                	add	s3,s3,s7
 21c:	00098023          	sb	zero,0(s3)
  return buf;
}
 220:	855e                	mv	a0,s7
 222:	60e6                	ld	ra,88(sp)
 224:	6446                	ld	s0,80(sp)
 226:	64a6                	ld	s1,72(sp)
 228:	6906                	ld	s2,64(sp)
 22a:	79e2                	ld	s3,56(sp)
 22c:	7a42                	ld	s4,48(sp)
 22e:	7aa2                	ld	s5,40(sp)
 230:	7b02                	ld	s6,32(sp)
 232:	6be2                	ld	s7,24(sp)
 234:	6125                	addi	sp,sp,96
 236:	8082                	ret

0000000000000238 <stat>:

int
stat(const char *n, struct stat *st)
{
 238:	1101                	addi	sp,sp,-32
 23a:	ec06                	sd	ra,24(sp)
 23c:	e822                	sd	s0,16(sp)
 23e:	e426                	sd	s1,8(sp)
 240:	e04a                	sd	s2,0(sp)
 242:	1000                	addi	s0,sp,32
 244:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 246:	4581                	li	a1,0
 248:	00000097          	auipc	ra,0x0
 24c:	28e080e7          	jalr	654(ra) # 4d6 <open>
  if(fd < 0)
 250:	02054563          	bltz	a0,27a <stat+0x42>
 254:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 256:	85ca                	mv	a1,s2
 258:	00000097          	auipc	ra,0x0
 25c:	296080e7          	jalr	662(ra) # 4ee <fstat>
 260:	892a                	mv	s2,a0
  close(fd);
 262:	8526                	mv	a0,s1
 264:	00000097          	auipc	ra,0x0
 268:	25a080e7          	jalr	602(ra) # 4be <close>
  return r;
}
 26c:	854a                	mv	a0,s2
 26e:	60e2                	ld	ra,24(sp)
 270:	6442                	ld	s0,16(sp)
 272:	64a2                	ld	s1,8(sp)
 274:	6902                	ld	s2,0(sp)
 276:	6105                	addi	sp,sp,32
 278:	8082                	ret
    return -1;
 27a:	597d                	li	s2,-1
 27c:	bfc5                	j	26c <stat+0x34>

000000000000027e <atoi>:

int
atoi(const char *s)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e422                	sd	s0,8(sp)
 282:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 284:	00054603          	lbu	a2,0(a0)
 288:	fd06079b          	addiw	a5,a2,-48
 28c:	0ff7f793          	andi	a5,a5,255
 290:	4725                	li	a4,9
 292:	02f76963          	bltu	a4,a5,2c4 <atoi+0x46>
 296:	86aa                	mv	a3,a0
  n = 0;
 298:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 29a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 29c:	0685                	addi	a3,a3,1
 29e:	0025179b          	slliw	a5,a0,0x2
 2a2:	9fa9                	addw	a5,a5,a0
 2a4:	0017979b          	slliw	a5,a5,0x1
 2a8:	9fb1                	addw	a5,a5,a2
 2aa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ae:	0006c603          	lbu	a2,0(a3)
 2b2:	fd06071b          	addiw	a4,a2,-48
 2b6:	0ff77713          	andi	a4,a4,255
 2ba:	fee5f1e3          	bgeu	a1,a4,29c <atoi+0x1e>
  return n;
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
  n = 0;
 2c4:	4501                	li	a0,0
 2c6:	bfe5                	j	2be <atoi+0x40>

00000000000002c8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ce:	02b57463          	bgeu	a0,a1,2f6 <memmove+0x2e>
    while(n-- > 0)
 2d2:	00c05f63          	blez	a2,2f0 <memmove+0x28>
 2d6:	1602                	slli	a2,a2,0x20
 2d8:	9201                	srli	a2,a2,0x20
 2da:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2de:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e0:	0585                	addi	a1,a1,1
 2e2:	0705                	addi	a4,a4,1
 2e4:	fff5c683          	lbu	a3,-1(a1)
 2e8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ec:	fee79ae3          	bne	a5,a4,2e0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
    dst += n;
 2f6:	00c50733          	add	a4,a0,a2
    src += n;
 2fa:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2fc:	fec05ae3          	blez	a2,2f0 <memmove+0x28>
 300:	fff6079b          	addiw	a5,a2,-1
 304:	1782                	slli	a5,a5,0x20
 306:	9381                	srli	a5,a5,0x20
 308:	fff7c793          	not	a5,a5
 30c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 30e:	15fd                	addi	a1,a1,-1
 310:	177d                	addi	a4,a4,-1
 312:	0005c683          	lbu	a3,0(a1)
 316:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 31a:	fee79ae3          	bne	a5,a4,30e <memmove+0x46>
 31e:	bfc9                	j	2f0 <memmove+0x28>

0000000000000320 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 326:	ca05                	beqz	a2,356 <memcmp+0x36>
 328:	fff6069b          	addiw	a3,a2,-1
 32c:	1682                	slli	a3,a3,0x20
 32e:	9281                	srli	a3,a3,0x20
 330:	0685                	addi	a3,a3,1
 332:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 334:	00054783          	lbu	a5,0(a0)
 338:	0005c703          	lbu	a4,0(a1)
 33c:	00e79863          	bne	a5,a4,34c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 340:	0505                	addi	a0,a0,1
    p2++;
 342:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 344:	fed518e3          	bne	a0,a3,334 <memcmp+0x14>
  }
  return 0;
 348:	4501                	li	a0,0
 34a:	a019                	j	350 <memcmp+0x30>
      return *p1 - *p2;
 34c:	40e7853b          	subw	a0,a5,a4
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
  return 0;
 356:	4501                	li	a0,0
 358:	bfe5                	j	350 <memcmp+0x30>

000000000000035a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 362:	00000097          	auipc	ra,0x0
 366:	f66080e7          	jalr	-154(ra) # 2c8 <memmove>
}
 36a:	60a2                	ld	ra,8(sp)
 36c:	6402                	ld	s0,0(sp)
 36e:	0141                	addi	sp,sp,16
 370:	8082                	ret

0000000000000372 <csem_down>:


void 
csem_down(struct counting_semaphore *sem) {
 372:	1101                	addi	sp,sp,-32
 374:	ec06                	sd	ra,24(sp)
 376:	e822                	sd	s0,16(sp)
 378:	e426                	sd	s1,8(sp)
 37a:	1000                	addi	s0,sp,32
 37c:	84aa                	mv	s1,a0
    bsem_down(sem->bsem2);
 37e:	4148                	lw	a0,4(a0)
 380:	00000097          	auipc	ra,0x0
 384:	1ce080e7          	jalr	462(ra) # 54e <bsem_down>
    bsem_down(sem->bsem1);
 388:	4088                	lw	a0,0(s1)
 38a:	00000097          	auipc	ra,0x0
 38e:	1c4080e7          	jalr	452(ra) # 54e <bsem_down>
    sem->count -= 1;
 392:	449c                	lw	a5,8(s1)
 394:	37fd                	addiw	a5,a5,-1
 396:	0007871b          	sext.w	a4,a5
 39a:	c49c                	sw	a5,8(s1)
    if (sem->count > 0)
 39c:	00e04c63          	bgtz	a4,3b4 <csem_down+0x42>
    	bsem_up(sem->bsem2);
    bsem_up(sem->bsem1);
 3a0:	4088                	lw	a0,0(s1)
 3a2:	00000097          	auipc	ra,0x0
 3a6:	1b4080e7          	jalr	436(ra) # 556 <bsem_up>
}
 3aa:	60e2                	ld	ra,24(sp)
 3ac:	6442                	ld	s0,16(sp)
 3ae:	64a2                	ld	s1,8(sp)
 3b0:	6105                	addi	sp,sp,32
 3b2:	8082                	ret
    	bsem_up(sem->bsem2);
 3b4:	40c8                	lw	a0,4(s1)
 3b6:	00000097          	auipc	ra,0x0
 3ba:	1a0080e7          	jalr	416(ra) # 556 <bsem_up>
 3be:	b7cd                	j	3a0 <csem_down+0x2e>

00000000000003c0 <csem_up>:


void 
csem_up(struct counting_semaphore *sem) {
 3c0:	1101                	addi	sp,sp,-32
 3c2:	ec06                	sd	ra,24(sp)
 3c4:	e822                	sd	s0,16(sp)
 3c6:	e426                	sd	s1,8(sp)
 3c8:	1000                	addi	s0,sp,32
 3ca:	84aa                	mv	s1,a0
	bsem_down(sem->bsem1);
 3cc:	4108                	lw	a0,0(a0)
 3ce:	00000097          	auipc	ra,0x0
 3d2:	180080e7          	jalr	384(ra) # 54e <bsem_down>
	sem->count += 1;
 3d6:	449c                	lw	a5,8(s1)
 3d8:	2785                	addiw	a5,a5,1
 3da:	0007871b          	sext.w	a4,a5
 3de:	c49c                	sw	a5,8(s1)
	if (sem->count == 1)
 3e0:	4785                	li	a5,1
 3e2:	00f70c63          	beq	a4,a5,3fa <csem_up+0x3a>
		bsem_up(sem->bsem2);
	bsem_up(sem->bsem1);
 3e6:	4088                	lw	a0,0(s1)
 3e8:	00000097          	auipc	ra,0x0
 3ec:	16e080e7          	jalr	366(ra) # 556 <bsem_up>
}
 3f0:	60e2                	ld	ra,24(sp)
 3f2:	6442                	ld	s0,16(sp)
 3f4:	64a2                	ld	s1,8(sp)
 3f6:	6105                	addi	sp,sp,32
 3f8:	8082                	ret
		bsem_up(sem->bsem2);
 3fa:	40c8                	lw	a0,4(s1)
 3fc:	00000097          	auipc	ra,0x0
 400:	15a080e7          	jalr	346(ra) # 556 <bsem_up>
 404:	b7cd                	j	3e6 <csem_up+0x26>

0000000000000406 <csem_alloc>:


int 
csem_alloc(struct counting_semaphore *sem, int count) {
 406:	7179                	addi	sp,sp,-48
 408:	f406                	sd	ra,40(sp)
 40a:	f022                	sd	s0,32(sp)
 40c:	ec26                	sd	s1,24(sp)
 40e:	e84a                	sd	s2,16(sp)
 410:	e44e                	sd	s3,8(sp)
 412:	1800                	addi	s0,sp,48
 414:	892a                	mv	s2,a0
 416:	89ae                	mv	s3,a1
    int bsem1 = bsem_alloc();
 418:	00000097          	auipc	ra,0x0
 41c:	14e080e7          	jalr	334(ra) # 566 <bsem_alloc>
 420:	84aa                	mv	s1,a0
    int bsem2 = bsem_alloc();
 422:	00000097          	auipc	ra,0x0
 426:	144080e7          	jalr	324(ra) # 566 <bsem_alloc>
    if (bsem1 == -1 || bsem2 == -1)
 42a:	57fd                	li	a5,-1
 42c:	00f48d63          	beq	s1,a5,446 <csem_alloc+0x40>
 430:	02f50863          	beq	a0,a5,460 <csem_alloc+0x5a>
        return -1; 
    sem->bsem1 = bsem1;
 434:	00992023          	sw	s1,0(s2)
    sem->bsem2 = bsem2;
 438:	00a92223          	sw	a0,4(s2)
    if (count == 0)
 43c:	00098d63          	beqz	s3,456 <csem_alloc+0x50>
        // Binary semaphore first value = min(1, count)
        bsem_down(sem->bsem2); 
    sem->count = count;
 440:	01392423          	sw	s3,8(s2)
    return 0;
 444:	4481                	li	s1,0
}
 446:	8526                	mv	a0,s1
 448:	70a2                	ld	ra,40(sp)
 44a:	7402                	ld	s0,32(sp)
 44c:	64e2                	ld	s1,24(sp)
 44e:	6942                	ld	s2,16(sp)
 450:	69a2                	ld	s3,8(sp)
 452:	6145                	addi	sp,sp,48
 454:	8082                	ret
        bsem_down(sem->bsem2); 
 456:	00000097          	auipc	ra,0x0
 45a:	0f8080e7          	jalr	248(ra) # 54e <bsem_down>
 45e:	b7cd                	j	440 <csem_alloc+0x3a>
        return -1; 
 460:	84aa                	mv	s1,a0
 462:	b7d5                	j	446 <csem_alloc+0x40>

0000000000000464 <csem_free>:


void 
csem_free(struct counting_semaphore *sem) {
 464:	1101                	addi	sp,sp,-32
 466:	ec06                	sd	ra,24(sp)
 468:	e822                	sd	s0,16(sp)
 46a:	e426                	sd	s1,8(sp)
 46c:	1000                	addi	s0,sp,32
 46e:	84aa                	mv	s1,a0
    bsem_free(sem->bsem1);
 470:	4108                	lw	a0,0(a0)
 472:	00000097          	auipc	ra,0x0
 476:	0ec080e7          	jalr	236(ra) # 55e <bsem_free>
    bsem_free(sem->bsem2);
 47a:	40c8                	lw	a0,4(s1)
 47c:	00000097          	auipc	ra,0x0
 480:	0e2080e7          	jalr	226(ra) # 55e <bsem_free>
    //free(sem);
}
 484:	60e2                	ld	ra,24(sp)
 486:	6442                	ld	s0,16(sp)
 488:	64a2                	ld	s1,8(sp)
 48a:	6105                	addi	sp,sp,32
 48c:	8082                	ret

000000000000048e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 48e:	4885                	li	a7,1
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <exit>:
.global exit
exit:
 li a7, SYS_exit
 496:	4889                	li	a7,2
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <wait>:
.global wait
wait:
 li a7, SYS_wait
 49e:	488d                	li	a7,3
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4a6:	4891                	li	a7,4
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <read>:
.global read
read:
 li a7, SYS_read
 4ae:	4895                	li	a7,5
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <write>:
.global write
write:
 li a7, SYS_write
 4b6:	48c1                	li	a7,16
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <close>:
.global close
close:
 li a7, SYS_close
 4be:	48d5                	li	a7,21
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4c6:	4899                	li	a7,6
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <exec>:
.global exec
exec:
 li a7, SYS_exec
 4ce:	489d                	li	a7,7
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <open>:
.global open
open:
 li a7, SYS_open
 4d6:	48bd                	li	a7,15
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4de:	48c5                	li	a7,17
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4e6:	48c9                	li	a7,18
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4ee:	48a1                	li	a7,8
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <link>:
.global link
link:
 li a7, SYS_link
 4f6:	48cd                	li	a7,19
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4fe:	48d1                	li	a7,20
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 506:	48a5                	li	a7,9
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <dup>:
.global dup
dup:
 li a7, SYS_dup
 50e:	48a9                	li	a7,10
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 516:	48ad                	li	a7,11
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 51e:	48b1                	li	a7,12
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 526:	48b5                	li	a7,13
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 52e:	48b9                	li	a7,14
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 536:	48d9                	li	a7,22
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 53e:	48dd                	li	a7,23
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 546:	48e1                	li	a7,24
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
 54e:	48ed                	li	a7,27
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
 556:	48f1                	li	a7,28
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
 55e:	48e9                	li	a7,26
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
 566:	48e5                	li	a7,25
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
 56e:	48f5                	li	a7,29
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
 576:	48f9                	li	a7,30
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
 57e:	48fd                	li	a7,31
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
 586:	02000893          	li	a7,32
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 590:	1101                	addi	sp,sp,-32
 592:	ec06                	sd	ra,24(sp)
 594:	e822                	sd	s0,16(sp)
 596:	1000                	addi	s0,sp,32
 598:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 59c:	4605                	li	a2,1
 59e:	fef40593          	addi	a1,s0,-17
 5a2:	00000097          	auipc	ra,0x0
 5a6:	f14080e7          	jalr	-236(ra) # 4b6 <write>
}
 5aa:	60e2                	ld	ra,24(sp)
 5ac:	6442                	ld	s0,16(sp)
 5ae:	6105                	addi	sp,sp,32
 5b0:	8082                	ret

00000000000005b2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5b2:	7139                	addi	sp,sp,-64
 5b4:	fc06                	sd	ra,56(sp)
 5b6:	f822                	sd	s0,48(sp)
 5b8:	f426                	sd	s1,40(sp)
 5ba:	f04a                	sd	s2,32(sp)
 5bc:	ec4e                	sd	s3,24(sp)
 5be:	0080                	addi	s0,sp,64
 5c0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5c2:	c299                	beqz	a3,5c8 <printint+0x16>
 5c4:	0805c863          	bltz	a1,654 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5c8:	2581                	sext.w	a1,a1
  neg = 0;
 5ca:	4881                	li	a7,0
 5cc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5d0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5d2:	2601                	sext.w	a2,a2
 5d4:	00000517          	auipc	a0,0x0
 5d8:	48450513          	addi	a0,a0,1156 # a58 <digits>
 5dc:	883a                	mv	a6,a4
 5de:	2705                	addiw	a4,a4,1
 5e0:	02c5f7bb          	remuw	a5,a1,a2
 5e4:	1782                	slli	a5,a5,0x20
 5e6:	9381                	srli	a5,a5,0x20
 5e8:	97aa                	add	a5,a5,a0
 5ea:	0007c783          	lbu	a5,0(a5)
 5ee:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5f2:	0005879b          	sext.w	a5,a1
 5f6:	02c5d5bb          	divuw	a1,a1,a2
 5fa:	0685                	addi	a3,a3,1
 5fc:	fec7f0e3          	bgeu	a5,a2,5dc <printint+0x2a>
  if(neg)
 600:	00088b63          	beqz	a7,616 <printint+0x64>
    buf[i++] = '-';
 604:	fd040793          	addi	a5,s0,-48
 608:	973e                	add	a4,a4,a5
 60a:	02d00793          	li	a5,45
 60e:	fef70823          	sb	a5,-16(a4)
 612:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 616:	02e05863          	blez	a4,646 <printint+0x94>
 61a:	fc040793          	addi	a5,s0,-64
 61e:	00e78933          	add	s2,a5,a4
 622:	fff78993          	addi	s3,a5,-1
 626:	99ba                	add	s3,s3,a4
 628:	377d                	addiw	a4,a4,-1
 62a:	1702                	slli	a4,a4,0x20
 62c:	9301                	srli	a4,a4,0x20
 62e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 632:	fff94583          	lbu	a1,-1(s2)
 636:	8526                	mv	a0,s1
 638:	00000097          	auipc	ra,0x0
 63c:	f58080e7          	jalr	-168(ra) # 590 <putc>
  while(--i >= 0)
 640:	197d                	addi	s2,s2,-1
 642:	ff3918e3          	bne	s2,s3,632 <printint+0x80>
}
 646:	70e2                	ld	ra,56(sp)
 648:	7442                	ld	s0,48(sp)
 64a:	74a2                	ld	s1,40(sp)
 64c:	7902                	ld	s2,32(sp)
 64e:	69e2                	ld	s3,24(sp)
 650:	6121                	addi	sp,sp,64
 652:	8082                	ret
    x = -xx;
 654:	40b005bb          	negw	a1,a1
    neg = 1;
 658:	4885                	li	a7,1
    x = -xx;
 65a:	bf8d                	j	5cc <printint+0x1a>

000000000000065c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 65c:	7119                	addi	sp,sp,-128
 65e:	fc86                	sd	ra,120(sp)
 660:	f8a2                	sd	s0,112(sp)
 662:	f4a6                	sd	s1,104(sp)
 664:	f0ca                	sd	s2,96(sp)
 666:	ecce                	sd	s3,88(sp)
 668:	e8d2                	sd	s4,80(sp)
 66a:	e4d6                	sd	s5,72(sp)
 66c:	e0da                	sd	s6,64(sp)
 66e:	fc5e                	sd	s7,56(sp)
 670:	f862                	sd	s8,48(sp)
 672:	f466                	sd	s9,40(sp)
 674:	f06a                	sd	s10,32(sp)
 676:	ec6e                	sd	s11,24(sp)
 678:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 67a:	0005c903          	lbu	s2,0(a1)
 67e:	18090f63          	beqz	s2,81c <vprintf+0x1c0>
 682:	8aaa                	mv	s5,a0
 684:	8b32                	mv	s6,a2
 686:	00158493          	addi	s1,a1,1
  state = 0;
 68a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 68c:	02500a13          	li	s4,37
      if(c == 'd'){
 690:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 694:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 698:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 69c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a0:	00000b97          	auipc	s7,0x0
 6a4:	3b8b8b93          	addi	s7,s7,952 # a58 <digits>
 6a8:	a839                	j	6c6 <vprintf+0x6a>
        putc(fd, c);
 6aa:	85ca                	mv	a1,s2
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	ee2080e7          	jalr	-286(ra) # 590 <putc>
 6b6:	a019                	j	6bc <vprintf+0x60>
    } else if(state == '%'){
 6b8:	01498f63          	beq	s3,s4,6d6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6bc:	0485                	addi	s1,s1,1
 6be:	fff4c903          	lbu	s2,-1(s1)
 6c2:	14090d63          	beqz	s2,81c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6c6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6ca:	fe0997e3          	bnez	s3,6b8 <vprintf+0x5c>
      if(c == '%'){
 6ce:	fd479ee3          	bne	a5,s4,6aa <vprintf+0x4e>
        state = '%';
 6d2:	89be                	mv	s3,a5
 6d4:	b7e5                	j	6bc <vprintf+0x60>
      if(c == 'd'){
 6d6:	05878063          	beq	a5,s8,716 <vprintf+0xba>
      } else if(c == 'l') {
 6da:	05978c63          	beq	a5,s9,732 <vprintf+0xd6>
      } else if(c == 'x') {
 6de:	07a78863          	beq	a5,s10,74e <vprintf+0xf2>
      } else if(c == 'p') {
 6e2:	09b78463          	beq	a5,s11,76a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6e6:	07300713          	li	a4,115
 6ea:	0ce78663          	beq	a5,a4,7b6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ee:	06300713          	li	a4,99
 6f2:	0ee78e63          	beq	a5,a4,7ee <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6f6:	11478863          	beq	a5,s4,806 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6fa:	85d2                	mv	a1,s4
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	e92080e7          	jalr	-366(ra) # 590 <putc>
        putc(fd, c);
 706:	85ca                	mv	a1,s2
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	e86080e7          	jalr	-378(ra) # 590 <putc>
      }
      state = 0;
 712:	4981                	li	s3,0
 714:	b765                	j	6bc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 716:	008b0913          	addi	s2,s6,8
 71a:	4685                	li	a3,1
 71c:	4629                	li	a2,10
 71e:	000b2583          	lw	a1,0(s6)
 722:	8556                	mv	a0,s5
 724:	00000097          	auipc	ra,0x0
 728:	e8e080e7          	jalr	-370(ra) # 5b2 <printint>
 72c:	8b4a                	mv	s6,s2
      state = 0;
 72e:	4981                	li	s3,0
 730:	b771                	j	6bc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 732:	008b0913          	addi	s2,s6,8
 736:	4681                	li	a3,0
 738:	4629                	li	a2,10
 73a:	000b2583          	lw	a1,0(s6)
 73e:	8556                	mv	a0,s5
 740:	00000097          	auipc	ra,0x0
 744:	e72080e7          	jalr	-398(ra) # 5b2 <printint>
 748:	8b4a                	mv	s6,s2
      state = 0;
 74a:	4981                	li	s3,0
 74c:	bf85                	j	6bc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 74e:	008b0913          	addi	s2,s6,8
 752:	4681                	li	a3,0
 754:	4641                	li	a2,16
 756:	000b2583          	lw	a1,0(s6)
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	e56080e7          	jalr	-426(ra) # 5b2 <printint>
 764:	8b4a                	mv	s6,s2
      state = 0;
 766:	4981                	li	s3,0
 768:	bf91                	j	6bc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 76a:	008b0793          	addi	a5,s6,8
 76e:	f8f43423          	sd	a5,-120(s0)
 772:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 776:	03000593          	li	a1,48
 77a:	8556                	mv	a0,s5
 77c:	00000097          	auipc	ra,0x0
 780:	e14080e7          	jalr	-492(ra) # 590 <putc>
  putc(fd, 'x');
 784:	85ea                	mv	a1,s10
 786:	8556                	mv	a0,s5
 788:	00000097          	auipc	ra,0x0
 78c:	e08080e7          	jalr	-504(ra) # 590 <putc>
 790:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 792:	03c9d793          	srli	a5,s3,0x3c
 796:	97de                	add	a5,a5,s7
 798:	0007c583          	lbu	a1,0(a5)
 79c:	8556                	mv	a0,s5
 79e:	00000097          	auipc	ra,0x0
 7a2:	df2080e7          	jalr	-526(ra) # 590 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7a6:	0992                	slli	s3,s3,0x4
 7a8:	397d                	addiw	s2,s2,-1
 7aa:	fe0914e3          	bnez	s2,792 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7ae:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	b721                	j	6bc <vprintf+0x60>
        s = va_arg(ap, char*);
 7b6:	008b0993          	addi	s3,s6,8
 7ba:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7be:	02090163          	beqz	s2,7e0 <vprintf+0x184>
        while(*s != 0){
 7c2:	00094583          	lbu	a1,0(s2)
 7c6:	c9a1                	beqz	a1,816 <vprintf+0x1ba>
          putc(fd, *s);
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	dc6080e7          	jalr	-570(ra) # 590 <putc>
          s++;
 7d2:	0905                	addi	s2,s2,1
        while(*s != 0){
 7d4:	00094583          	lbu	a1,0(s2)
 7d8:	f9e5                	bnez	a1,7c8 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7da:	8b4e                	mv	s6,s3
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	bdf9                	j	6bc <vprintf+0x60>
          s = "(null)";
 7e0:	00000917          	auipc	s2,0x0
 7e4:	27090913          	addi	s2,s2,624 # a50 <malloc+0x12a>
        while(*s != 0){
 7e8:	02800593          	li	a1,40
 7ec:	bff1                	j	7c8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7ee:	008b0913          	addi	s2,s6,8
 7f2:	000b4583          	lbu	a1,0(s6)
 7f6:	8556                	mv	a0,s5
 7f8:	00000097          	auipc	ra,0x0
 7fc:	d98080e7          	jalr	-616(ra) # 590 <putc>
 800:	8b4a                	mv	s6,s2
      state = 0;
 802:	4981                	li	s3,0
 804:	bd65                	j	6bc <vprintf+0x60>
        putc(fd, c);
 806:	85d2                	mv	a1,s4
 808:	8556                	mv	a0,s5
 80a:	00000097          	auipc	ra,0x0
 80e:	d86080e7          	jalr	-634(ra) # 590 <putc>
      state = 0;
 812:	4981                	li	s3,0
 814:	b565                	j	6bc <vprintf+0x60>
        s = va_arg(ap, char*);
 816:	8b4e                	mv	s6,s3
      state = 0;
 818:	4981                	li	s3,0
 81a:	b54d                	j	6bc <vprintf+0x60>
    }
  }
}
 81c:	70e6                	ld	ra,120(sp)
 81e:	7446                	ld	s0,112(sp)
 820:	74a6                	ld	s1,104(sp)
 822:	7906                	ld	s2,96(sp)
 824:	69e6                	ld	s3,88(sp)
 826:	6a46                	ld	s4,80(sp)
 828:	6aa6                	ld	s5,72(sp)
 82a:	6b06                	ld	s6,64(sp)
 82c:	7be2                	ld	s7,56(sp)
 82e:	7c42                	ld	s8,48(sp)
 830:	7ca2                	ld	s9,40(sp)
 832:	7d02                	ld	s10,32(sp)
 834:	6de2                	ld	s11,24(sp)
 836:	6109                	addi	sp,sp,128
 838:	8082                	ret

000000000000083a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 83a:	715d                	addi	sp,sp,-80
 83c:	ec06                	sd	ra,24(sp)
 83e:	e822                	sd	s0,16(sp)
 840:	1000                	addi	s0,sp,32
 842:	e010                	sd	a2,0(s0)
 844:	e414                	sd	a3,8(s0)
 846:	e818                	sd	a4,16(s0)
 848:	ec1c                	sd	a5,24(s0)
 84a:	03043023          	sd	a6,32(s0)
 84e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 852:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 856:	8622                	mv	a2,s0
 858:	00000097          	auipc	ra,0x0
 85c:	e04080e7          	jalr	-508(ra) # 65c <vprintf>
}
 860:	60e2                	ld	ra,24(sp)
 862:	6442                	ld	s0,16(sp)
 864:	6161                	addi	sp,sp,80
 866:	8082                	ret

0000000000000868 <printf>:

void
printf(const char *fmt, ...)
{
 868:	711d                	addi	sp,sp,-96
 86a:	ec06                	sd	ra,24(sp)
 86c:	e822                	sd	s0,16(sp)
 86e:	1000                	addi	s0,sp,32
 870:	e40c                	sd	a1,8(s0)
 872:	e810                	sd	a2,16(s0)
 874:	ec14                	sd	a3,24(s0)
 876:	f018                	sd	a4,32(s0)
 878:	f41c                	sd	a5,40(s0)
 87a:	03043823          	sd	a6,48(s0)
 87e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 882:	00840613          	addi	a2,s0,8
 886:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 88a:	85aa                	mv	a1,a0
 88c:	4505                	li	a0,1
 88e:	00000097          	auipc	ra,0x0
 892:	dce080e7          	jalr	-562(ra) # 65c <vprintf>
}
 896:	60e2                	ld	ra,24(sp)
 898:	6442                	ld	s0,16(sp)
 89a:	6125                	addi	sp,sp,96
 89c:	8082                	ret

000000000000089e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 89e:	1141                	addi	sp,sp,-16
 8a0:	e422                	sd	s0,8(sp)
 8a2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8a4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a8:	00000797          	auipc	a5,0x0
 8ac:	1c87b783          	ld	a5,456(a5) # a70 <freep>
 8b0:	a805                	j	8e0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8b2:	4618                	lw	a4,8(a2)
 8b4:	9db9                	addw	a1,a1,a4
 8b6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ba:	6398                	ld	a4,0(a5)
 8bc:	6318                	ld	a4,0(a4)
 8be:	fee53823          	sd	a4,-16(a0)
 8c2:	a091                	j	906 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8c4:	ff852703          	lw	a4,-8(a0)
 8c8:	9e39                	addw	a2,a2,a4
 8ca:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8cc:	ff053703          	ld	a4,-16(a0)
 8d0:	e398                	sd	a4,0(a5)
 8d2:	a099                	j	918 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d4:	6398                	ld	a4,0(a5)
 8d6:	00e7e463          	bltu	a5,a4,8de <free+0x40>
 8da:	00e6ea63          	bltu	a3,a4,8ee <free+0x50>
{
 8de:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e0:	fed7fae3          	bgeu	a5,a3,8d4 <free+0x36>
 8e4:	6398                	ld	a4,0(a5)
 8e6:	00e6e463          	bltu	a3,a4,8ee <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ea:	fee7eae3          	bltu	a5,a4,8de <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8ee:	ff852583          	lw	a1,-8(a0)
 8f2:	6390                	ld	a2,0(a5)
 8f4:	02059813          	slli	a6,a1,0x20
 8f8:	01c85713          	srli	a4,a6,0x1c
 8fc:	9736                	add	a4,a4,a3
 8fe:	fae60ae3          	beq	a2,a4,8b2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 902:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 906:	4790                	lw	a2,8(a5)
 908:	02061593          	slli	a1,a2,0x20
 90c:	01c5d713          	srli	a4,a1,0x1c
 910:	973e                	add	a4,a4,a5
 912:	fae689e3          	beq	a3,a4,8c4 <free+0x26>
  } else
    p->s.ptr = bp;
 916:	e394                	sd	a3,0(a5)
  freep = p;
 918:	00000717          	auipc	a4,0x0
 91c:	14f73c23          	sd	a5,344(a4) # a70 <freep>
}
 920:	6422                	ld	s0,8(sp)
 922:	0141                	addi	sp,sp,16
 924:	8082                	ret

0000000000000926 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 926:	7139                	addi	sp,sp,-64
 928:	fc06                	sd	ra,56(sp)
 92a:	f822                	sd	s0,48(sp)
 92c:	f426                	sd	s1,40(sp)
 92e:	f04a                	sd	s2,32(sp)
 930:	ec4e                	sd	s3,24(sp)
 932:	e852                	sd	s4,16(sp)
 934:	e456                	sd	s5,8(sp)
 936:	e05a                	sd	s6,0(sp)
 938:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 93a:	02051493          	slli	s1,a0,0x20
 93e:	9081                	srli	s1,s1,0x20
 940:	04bd                	addi	s1,s1,15
 942:	8091                	srli	s1,s1,0x4
 944:	0014899b          	addiw	s3,s1,1
 948:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 94a:	00000517          	auipc	a0,0x0
 94e:	12653503          	ld	a0,294(a0) # a70 <freep>
 952:	c515                	beqz	a0,97e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 954:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 956:	4798                	lw	a4,8(a5)
 958:	02977f63          	bgeu	a4,s1,996 <malloc+0x70>
 95c:	8a4e                	mv	s4,s3
 95e:	0009871b          	sext.w	a4,s3
 962:	6685                	lui	a3,0x1
 964:	00d77363          	bgeu	a4,a3,96a <malloc+0x44>
 968:	6a05                	lui	s4,0x1
 96a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 96e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 972:	00000917          	auipc	s2,0x0
 976:	0fe90913          	addi	s2,s2,254 # a70 <freep>
  if(p == (char*)-1)
 97a:	5afd                	li	s5,-1
 97c:	a895                	j	9f0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 97e:	00000797          	auipc	a5,0x0
 982:	0fa78793          	addi	a5,a5,250 # a78 <base>
 986:	00000717          	auipc	a4,0x0
 98a:	0ef73523          	sd	a5,234(a4) # a70 <freep>
 98e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 990:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 994:	b7e1                	j	95c <malloc+0x36>
      if(p->s.size == nunits)
 996:	02e48c63          	beq	s1,a4,9ce <malloc+0xa8>
        p->s.size -= nunits;
 99a:	4137073b          	subw	a4,a4,s3
 99e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9a0:	02071693          	slli	a3,a4,0x20
 9a4:	01c6d713          	srli	a4,a3,0x1c
 9a8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9aa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ae:	00000717          	auipc	a4,0x0
 9b2:	0ca73123          	sd	a0,194(a4) # a70 <freep>
      return (void*)(p + 1);
 9b6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9ba:	70e2                	ld	ra,56(sp)
 9bc:	7442                	ld	s0,48(sp)
 9be:	74a2                	ld	s1,40(sp)
 9c0:	7902                	ld	s2,32(sp)
 9c2:	69e2                	ld	s3,24(sp)
 9c4:	6a42                	ld	s4,16(sp)
 9c6:	6aa2                	ld	s5,8(sp)
 9c8:	6b02                	ld	s6,0(sp)
 9ca:	6121                	addi	sp,sp,64
 9cc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9ce:	6398                	ld	a4,0(a5)
 9d0:	e118                	sd	a4,0(a0)
 9d2:	bff1                	j	9ae <malloc+0x88>
  hp->s.size = nu;
 9d4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9d8:	0541                	addi	a0,a0,16
 9da:	00000097          	auipc	ra,0x0
 9de:	ec4080e7          	jalr	-316(ra) # 89e <free>
  return freep;
 9e2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9e6:	d971                	beqz	a0,9ba <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ea:	4798                	lw	a4,8(a5)
 9ec:	fa9775e3          	bgeu	a4,s1,996 <malloc+0x70>
    if(p == freep)
 9f0:	00093703          	ld	a4,0(s2)
 9f4:	853e                	mv	a0,a5
 9f6:	fef719e3          	bne	a4,a5,9e8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9fa:	8552                	mv	a0,s4
 9fc:	00000097          	auipc	ra,0x0
 a00:	b22080e7          	jalr	-1246(ra) # 51e <sbrk>
  if(p == (char*)-1)
 a04:	fd5518e3          	bne	a0,s5,9d4 <malloc+0xae>
        return 0;
 a08:	4501                	li	a0,0
 a0a:	bf45                	j	9ba <malloc+0x94>
