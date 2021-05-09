
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7d763          	bge	a5,a0,3e <main+0x3e>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	02091793          	slli	a5,s2,0x20
  20:	01d7d913          	srli	s2,a5,0x1d
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  28:	6088                	ld	a0,0(s1)
  2a:	00000097          	auipc	ra,0x0
  2e:	428080e7          	jalr	1064(ra) # 452 <unlink>
  32:	02054463          	bltz	a0,5a <main+0x5a>
  for(i = 1; i < argc; i++){
  36:	04a1                	addi	s1,s1,8
  38:	ff2498e3          	bne	s1,s2,28 <main+0x28>
  3c:	a80d                	j	6e <main+0x6e>
    fprintf(2, "Usage: rm files...\n");
  3e:	00001597          	auipc	a1,0x1
  42:	93a58593          	addi	a1,a1,-1734 # 978 <malloc+0xe6>
  46:	4509                	li	a0,2
  48:	00000097          	auipc	ra,0x0
  4c:	75e080e7          	jalr	1886(ra) # 7a6 <fprintf>
    exit(1);
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	3b0080e7          	jalr	944(ra) # 402 <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	6090                	ld	a2,0(s1)
  5c:	00001597          	auipc	a1,0x1
  60:	93458593          	addi	a1,a1,-1740 # 990 <malloc+0xfe>
  64:	4509                	li	a0,2
  66:	00000097          	auipc	ra,0x0
  6a:	740080e7          	jalr	1856(ra) # 7a6 <fprintf>
      break;
    }
  }

  exit(0);
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	392080e7          	jalr	914(ra) # 402 <exit>

0000000000000078 <strcpy>:
#include "kernel/Csemaphore.h"


char*
strcpy(char *s, const char *t)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0x8>
    ;
  return os;
}
  8e:	6422                	ld	s0,8(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	cb91                	beqz	a5,b2 <strcmp+0x1e>
  a0:	0005c703          	lbu	a4,0(a1)
  a4:	00f71763          	bne	a4,a5,b2 <strcmp+0x1e>
    p++, q++;
  a8:	0505                	addi	a0,a0,1
  aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	fbe5                	bnez	a5,a0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b2:	0005c503          	lbu	a0,0(a1)
}
  b6:	40a7853b          	subw	a0,a5,a0
  ba:	6422                	ld	s0,8(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e422                	sd	s0,8(sp)
  c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	cf91                	beqz	a5,e6 <strlen+0x26>
  cc:	0505                	addi	a0,a0,1
  ce:	87aa                	mv	a5,a0
  d0:	4685                	li	a3,1
  d2:	9e89                	subw	a3,a3,a0
  d4:	00f6853b          	addw	a0,a3,a5
  d8:	0785                	addi	a5,a5,1
  da:	fff7c703          	lbu	a4,-1(a5)
  de:	fb7d                	bnez	a4,d4 <strlen+0x14>
    ;
  return n;
}
  e0:	6422                	ld	s0,8(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret
  for(n = 0; s[n]; n++)
  e6:	4501                	li	a0,0
  e8:	bfe5                	j	e0 <strlen+0x20>

00000000000000ea <memset>:

void*
memset(void *dst, int c, uint n)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f0:	ca19                	beqz	a2,106 <memset+0x1c>
  f2:	87aa                	mv	a5,a0
  f4:	1602                	slli	a2,a2,0x20
  f6:	9201                	srli	a2,a2,0x20
  f8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  fc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 100:	0785                	addi	a5,a5,1
 102:	fee79de3          	bne	a5,a4,fc <memset+0x12>
  }
  return dst;
}
 106:	6422                	ld	s0,8(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret

000000000000010c <strchr>:

char*
strchr(const char *s, char c)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  for(; *s; s++)
 112:	00054783          	lbu	a5,0(a0)
 116:	cb99                	beqz	a5,12c <strchr+0x20>
    if(*s == c)
 118:	00f58763          	beq	a1,a5,126 <strchr+0x1a>
  for(; *s; s++)
 11c:	0505                	addi	a0,a0,1
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbfd                	bnez	a5,118 <strchr+0xc>
      return (char*)s;
  return 0;
 124:	4501                	li	a0,0
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret
  return 0;
 12c:	4501                	li	a0,0
 12e:	bfe5                	j	126 <strchr+0x1a>

0000000000000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	711d                	addi	sp,sp,-96
 132:	ec86                	sd	ra,88(sp)
 134:	e8a2                	sd	s0,80(sp)
 136:	e4a6                	sd	s1,72(sp)
 138:	e0ca                	sd	s2,64(sp)
 13a:	fc4e                	sd	s3,56(sp)
 13c:	f852                	sd	s4,48(sp)
 13e:	f456                	sd	s5,40(sp)
 140:	f05a                	sd	s6,32(sp)
 142:	ec5e                	sd	s7,24(sp)
 144:	1080                	addi	s0,sp,96
 146:	8baa                	mv	s7,a0
 148:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14a:	892a                	mv	s2,a0
 14c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 14e:	4aa9                	li	s5,10
 150:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 152:	89a6                	mv	s3,s1
 154:	2485                	addiw	s1,s1,1
 156:	0344d863          	bge	s1,s4,186 <gets+0x56>
    cc = read(0, &c, 1);
 15a:	4605                	li	a2,1
 15c:	faf40593          	addi	a1,s0,-81
 160:	4501                	li	a0,0
 162:	00000097          	auipc	ra,0x0
 166:	2b8080e7          	jalr	696(ra) # 41a <read>
    if(cc < 1)
 16a:	00a05e63          	blez	a0,186 <gets+0x56>
    buf[i++] = c;
 16e:	faf44783          	lbu	a5,-81(s0)
 172:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 176:	01578763          	beq	a5,s5,184 <gets+0x54>
 17a:	0905                	addi	s2,s2,1
 17c:	fd679be3          	bne	a5,s6,152 <gets+0x22>
  for(i=0; i+1 < max; ){
 180:	89a6                	mv	s3,s1
 182:	a011                	j	186 <gets+0x56>
 184:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 186:	99de                	add	s3,s3,s7
 188:	00098023          	sb	zero,0(s3)
  return buf;
}
 18c:	855e                	mv	a0,s7
 18e:	60e6                	ld	ra,88(sp)
 190:	6446                	ld	s0,80(sp)
 192:	64a6                	ld	s1,72(sp)
 194:	6906                	ld	s2,64(sp)
 196:	79e2                	ld	s3,56(sp)
 198:	7a42                	ld	s4,48(sp)
 19a:	7aa2                	ld	s5,40(sp)
 19c:	7b02                	ld	s6,32(sp)
 19e:	6be2                	ld	s7,24(sp)
 1a0:	6125                	addi	sp,sp,96
 1a2:	8082                	ret

00000000000001a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a4:	1101                	addi	sp,sp,-32
 1a6:	ec06                	sd	ra,24(sp)
 1a8:	e822                	sd	s0,16(sp)
 1aa:	e426                	sd	s1,8(sp)
 1ac:	e04a                	sd	s2,0(sp)
 1ae:	1000                	addi	s0,sp,32
 1b0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b2:	4581                	li	a1,0
 1b4:	00000097          	auipc	ra,0x0
 1b8:	28e080e7          	jalr	654(ra) # 442 <open>
  if(fd < 0)
 1bc:	02054563          	bltz	a0,1e6 <stat+0x42>
 1c0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c2:	85ca                	mv	a1,s2
 1c4:	00000097          	auipc	ra,0x0
 1c8:	296080e7          	jalr	662(ra) # 45a <fstat>
 1cc:	892a                	mv	s2,a0
  close(fd);
 1ce:	8526                	mv	a0,s1
 1d0:	00000097          	auipc	ra,0x0
 1d4:	25a080e7          	jalr	602(ra) # 42a <close>
  return r;
}
 1d8:	854a                	mv	a0,s2
 1da:	60e2                	ld	ra,24(sp)
 1dc:	6442                	ld	s0,16(sp)
 1de:	64a2                	ld	s1,8(sp)
 1e0:	6902                	ld	s2,0(sp)
 1e2:	6105                	addi	sp,sp,32
 1e4:	8082                	ret
    return -1;
 1e6:	597d                	li	s2,-1
 1e8:	bfc5                	j	1d8 <stat+0x34>

00000000000001ea <atoi>:

int
atoi(const char *s)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e422                	sd	s0,8(sp)
 1ee:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f0:	00054603          	lbu	a2,0(a0)
 1f4:	fd06079b          	addiw	a5,a2,-48
 1f8:	0ff7f793          	andi	a5,a5,255
 1fc:	4725                	li	a4,9
 1fe:	02f76963          	bltu	a4,a5,230 <atoi+0x46>
 202:	86aa                	mv	a3,a0
  n = 0;
 204:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 206:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 208:	0685                	addi	a3,a3,1
 20a:	0025179b          	slliw	a5,a0,0x2
 20e:	9fa9                	addw	a5,a5,a0
 210:	0017979b          	slliw	a5,a5,0x1
 214:	9fb1                	addw	a5,a5,a2
 216:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21a:	0006c603          	lbu	a2,0(a3)
 21e:	fd06071b          	addiw	a4,a2,-48
 222:	0ff77713          	andi	a4,a4,255
 226:	fee5f1e3          	bgeu	a1,a4,208 <atoi+0x1e>
  return n;
}
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret
  n = 0;
 230:	4501                	li	a0,0
 232:	bfe5                	j	22a <atoi+0x40>

0000000000000234 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23a:	02b57463          	bgeu	a0,a1,262 <memmove+0x2e>
    while(n-- > 0)
 23e:	00c05f63          	blez	a2,25c <memmove+0x28>
 242:	1602                	slli	a2,a2,0x20
 244:	9201                	srli	a2,a2,0x20
 246:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24a:	872a                	mv	a4,a0
      *dst++ = *src++;
 24c:	0585                	addi	a1,a1,1
 24e:	0705                	addi	a4,a4,1
 250:	fff5c683          	lbu	a3,-1(a1)
 254:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 258:	fee79ae3          	bne	a5,a4,24c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
    dst += n;
 262:	00c50733          	add	a4,a0,a2
    src += n;
 266:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 268:	fec05ae3          	blez	a2,25c <memmove+0x28>
 26c:	fff6079b          	addiw	a5,a2,-1
 270:	1782                	slli	a5,a5,0x20
 272:	9381                	srli	a5,a5,0x20
 274:	fff7c793          	not	a5,a5
 278:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27a:	15fd                	addi	a1,a1,-1
 27c:	177d                	addi	a4,a4,-1
 27e:	0005c683          	lbu	a3,0(a1)
 282:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 286:	fee79ae3          	bne	a5,a4,27a <memmove+0x46>
 28a:	bfc9                	j	25c <memmove+0x28>

000000000000028c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 292:	ca05                	beqz	a2,2c2 <memcmp+0x36>
 294:	fff6069b          	addiw	a3,a2,-1
 298:	1682                	slli	a3,a3,0x20
 29a:	9281                	srli	a3,a3,0x20
 29c:	0685                	addi	a3,a3,1
 29e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	0005c703          	lbu	a4,0(a1)
 2a8:	00e79863          	bne	a5,a4,2b8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ac:	0505                	addi	a0,a0,1
    p2++;
 2ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b0:	fed518e3          	bne	a0,a3,2a0 <memcmp+0x14>
  }
  return 0;
 2b4:	4501                	li	a0,0
 2b6:	a019                	j	2bc <memcmp+0x30>
      return *p1 - *p2;
 2b8:	40e7853b          	subw	a0,a5,a4
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
  return 0;
 2c2:	4501                	li	a0,0
 2c4:	bfe5                	j	2bc <memcmp+0x30>

00000000000002c6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ce:	00000097          	auipc	ra,0x0
 2d2:	f66080e7          	jalr	-154(ra) # 234 <memmove>
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <csem_down>:


void 
csem_down(struct counting_semaphore *sem) {
 2de:	1101                	addi	sp,sp,-32
 2e0:	ec06                	sd	ra,24(sp)
 2e2:	e822                	sd	s0,16(sp)
 2e4:	e426                	sd	s1,8(sp)
 2e6:	1000                	addi	s0,sp,32
 2e8:	84aa                	mv	s1,a0
    bsem_down(sem->bsem2);
 2ea:	4148                	lw	a0,4(a0)
 2ec:	00000097          	auipc	ra,0x0
 2f0:	1ce080e7          	jalr	462(ra) # 4ba <bsem_down>
    bsem_down(sem->bsem1);
 2f4:	4088                	lw	a0,0(s1)
 2f6:	00000097          	auipc	ra,0x0
 2fa:	1c4080e7          	jalr	452(ra) # 4ba <bsem_down>
    sem->count -= 1;
 2fe:	449c                	lw	a5,8(s1)
 300:	37fd                	addiw	a5,a5,-1
 302:	0007871b          	sext.w	a4,a5
 306:	c49c                	sw	a5,8(s1)
    if (sem->count > 0)
 308:	00e04c63          	bgtz	a4,320 <csem_down+0x42>
    	bsem_up(sem->bsem2);
    bsem_up(sem->bsem1);
 30c:	4088                	lw	a0,0(s1)
 30e:	00000097          	auipc	ra,0x0
 312:	1b4080e7          	jalr	436(ra) # 4c2 <bsem_up>
}
 316:	60e2                	ld	ra,24(sp)
 318:	6442                	ld	s0,16(sp)
 31a:	64a2                	ld	s1,8(sp)
 31c:	6105                	addi	sp,sp,32
 31e:	8082                	ret
    	bsem_up(sem->bsem2);
 320:	40c8                	lw	a0,4(s1)
 322:	00000097          	auipc	ra,0x0
 326:	1a0080e7          	jalr	416(ra) # 4c2 <bsem_up>
 32a:	b7cd                	j	30c <csem_down+0x2e>

000000000000032c <csem_up>:


void 
csem_up(struct counting_semaphore *sem) {
 32c:	1101                	addi	sp,sp,-32
 32e:	ec06                	sd	ra,24(sp)
 330:	e822                	sd	s0,16(sp)
 332:	e426                	sd	s1,8(sp)
 334:	1000                	addi	s0,sp,32
 336:	84aa                	mv	s1,a0
	bsem_down(sem->bsem1);
 338:	4108                	lw	a0,0(a0)
 33a:	00000097          	auipc	ra,0x0
 33e:	180080e7          	jalr	384(ra) # 4ba <bsem_down>
	sem->count += 1;
 342:	449c                	lw	a5,8(s1)
 344:	2785                	addiw	a5,a5,1
 346:	0007871b          	sext.w	a4,a5
 34a:	c49c                	sw	a5,8(s1)
	if (sem->count == 1)
 34c:	4785                	li	a5,1
 34e:	00f70c63          	beq	a4,a5,366 <csem_up+0x3a>
		bsem_up(sem->bsem2);
	bsem_up(sem->bsem1);
 352:	4088                	lw	a0,0(s1)
 354:	00000097          	auipc	ra,0x0
 358:	16e080e7          	jalr	366(ra) # 4c2 <bsem_up>
}
 35c:	60e2                	ld	ra,24(sp)
 35e:	6442                	ld	s0,16(sp)
 360:	64a2                	ld	s1,8(sp)
 362:	6105                	addi	sp,sp,32
 364:	8082                	ret
		bsem_up(sem->bsem2);
 366:	40c8                	lw	a0,4(s1)
 368:	00000097          	auipc	ra,0x0
 36c:	15a080e7          	jalr	346(ra) # 4c2 <bsem_up>
 370:	b7cd                	j	352 <csem_up+0x26>

0000000000000372 <csem_alloc>:


int 
csem_alloc(struct counting_semaphore *sem, int count) {
 372:	7179                	addi	sp,sp,-48
 374:	f406                	sd	ra,40(sp)
 376:	f022                	sd	s0,32(sp)
 378:	ec26                	sd	s1,24(sp)
 37a:	e84a                	sd	s2,16(sp)
 37c:	e44e                	sd	s3,8(sp)
 37e:	1800                	addi	s0,sp,48
 380:	892a                	mv	s2,a0
 382:	89ae                	mv	s3,a1
    int bsem1 = bsem_alloc();
 384:	00000097          	auipc	ra,0x0
 388:	14e080e7          	jalr	334(ra) # 4d2 <bsem_alloc>
 38c:	84aa                	mv	s1,a0
    int bsem2 = bsem_alloc();
 38e:	00000097          	auipc	ra,0x0
 392:	144080e7          	jalr	324(ra) # 4d2 <bsem_alloc>
    if (bsem1 == -1 || bsem2 == -1)
 396:	57fd                	li	a5,-1
 398:	00f48d63          	beq	s1,a5,3b2 <csem_alloc+0x40>
 39c:	02f50863          	beq	a0,a5,3cc <csem_alloc+0x5a>
        return -1; 
    sem->bsem1 = bsem1;
 3a0:	00992023          	sw	s1,0(s2)
    sem->bsem2 = bsem2;
 3a4:	00a92223          	sw	a0,4(s2)
    if (count == 0)
 3a8:	00098d63          	beqz	s3,3c2 <csem_alloc+0x50>
        // Binary semaphore first value = min(1, count)
        bsem_down(sem->bsem2); 
    sem->count = count;
 3ac:	01392423          	sw	s3,8(s2)
    return 0;
 3b0:	4481                	li	s1,0
}
 3b2:	8526                	mv	a0,s1
 3b4:	70a2                	ld	ra,40(sp)
 3b6:	7402                	ld	s0,32(sp)
 3b8:	64e2                	ld	s1,24(sp)
 3ba:	6942                	ld	s2,16(sp)
 3bc:	69a2                	ld	s3,8(sp)
 3be:	6145                	addi	sp,sp,48
 3c0:	8082                	ret
        bsem_down(sem->bsem2); 
 3c2:	00000097          	auipc	ra,0x0
 3c6:	0f8080e7          	jalr	248(ra) # 4ba <bsem_down>
 3ca:	b7cd                	j	3ac <csem_alloc+0x3a>
        return -1; 
 3cc:	84aa                	mv	s1,a0
 3ce:	b7d5                	j	3b2 <csem_alloc+0x40>

00000000000003d0 <csem_free>:


void 
csem_free(struct counting_semaphore *sem) {
 3d0:	1101                	addi	sp,sp,-32
 3d2:	ec06                	sd	ra,24(sp)
 3d4:	e822                	sd	s0,16(sp)
 3d6:	e426                	sd	s1,8(sp)
 3d8:	1000                	addi	s0,sp,32
 3da:	84aa                	mv	s1,a0
    bsem_free(sem->bsem1);
 3dc:	4108                	lw	a0,0(a0)
 3de:	00000097          	auipc	ra,0x0
 3e2:	0ec080e7          	jalr	236(ra) # 4ca <bsem_free>
    bsem_free(sem->bsem2);
 3e6:	40c8                	lw	a0,4(s1)
 3e8:	00000097          	auipc	ra,0x0
 3ec:	0e2080e7          	jalr	226(ra) # 4ca <bsem_free>
    //free(sem);
}
 3f0:	60e2                	ld	ra,24(sp)
 3f2:	6442                	ld	s0,16(sp)
 3f4:	64a2                	ld	s1,8(sp)
 3f6:	6105                	addi	sp,sp,32
 3f8:	8082                	ret

00000000000003fa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3fa:	4885                	li	a7,1
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <exit>:
.global exit
exit:
 li a7, SYS_exit
 402:	4889                	li	a7,2
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <wait>:
.global wait
wait:
 li a7, SYS_wait
 40a:	488d                	li	a7,3
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 412:	4891                	li	a7,4
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <read>:
.global read
read:
 li a7, SYS_read
 41a:	4895                	li	a7,5
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <write>:
.global write
write:
 li a7, SYS_write
 422:	48c1                	li	a7,16
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <close>:
.global close
close:
 li a7, SYS_close
 42a:	48d5                	li	a7,21
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <kill>:
.global kill
kill:
 li a7, SYS_kill
 432:	4899                	li	a7,6
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <exec>:
.global exec
exec:
 li a7, SYS_exec
 43a:	489d                	li	a7,7
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <open>:
.global open
open:
 li a7, SYS_open
 442:	48bd                	li	a7,15
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 44a:	48c5                	li	a7,17
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 452:	48c9                	li	a7,18
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 45a:	48a1                	li	a7,8
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <link>:
.global link
link:
 li a7, SYS_link
 462:	48cd                	li	a7,19
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 46a:	48d1                	li	a7,20
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 472:	48a5                	li	a7,9
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <dup>:
.global dup
dup:
 li a7, SYS_dup
 47a:	48a9                	li	a7,10
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 482:	48ad                	li	a7,11
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 48a:	48b1                	li	a7,12
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 492:	48b5                	li	a7,13
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 49a:	48b9                	li	a7,14
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 4a2:	48d9                	li	a7,22
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 4aa:	48dd                	li	a7,23
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 4b2:	48e1                	li	a7,24
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
 4ba:	48ed                	li	a7,27
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
 4c2:	48f1                	li	a7,28
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
 4ca:	48e9                	li	a7,26
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
 4d2:	48e5                	li	a7,25
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
 4da:	48f5                	li	a7,29
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
 4e2:	48f9                	li	a7,30
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
 4ea:	48fd                	li	a7,31
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
 4f2:	02000893          	li	a7,32
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4fc:	1101                	addi	sp,sp,-32
 4fe:	ec06                	sd	ra,24(sp)
 500:	e822                	sd	s0,16(sp)
 502:	1000                	addi	s0,sp,32
 504:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 508:	4605                	li	a2,1
 50a:	fef40593          	addi	a1,s0,-17
 50e:	00000097          	auipc	ra,0x0
 512:	f14080e7          	jalr	-236(ra) # 422 <write>
}
 516:	60e2                	ld	ra,24(sp)
 518:	6442                	ld	s0,16(sp)
 51a:	6105                	addi	sp,sp,32
 51c:	8082                	ret

000000000000051e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51e:	7139                	addi	sp,sp,-64
 520:	fc06                	sd	ra,56(sp)
 522:	f822                	sd	s0,48(sp)
 524:	f426                	sd	s1,40(sp)
 526:	f04a                	sd	s2,32(sp)
 528:	ec4e                	sd	s3,24(sp)
 52a:	0080                	addi	s0,sp,64
 52c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 52e:	c299                	beqz	a3,534 <printint+0x16>
 530:	0805c863          	bltz	a1,5c0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 534:	2581                	sext.w	a1,a1
  neg = 0;
 536:	4881                	li	a7,0
 538:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 53c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 53e:	2601                	sext.w	a2,a2
 540:	00000517          	auipc	a0,0x0
 544:	47850513          	addi	a0,a0,1144 # 9b8 <digits>
 548:	883a                	mv	a6,a4
 54a:	2705                	addiw	a4,a4,1
 54c:	02c5f7bb          	remuw	a5,a1,a2
 550:	1782                	slli	a5,a5,0x20
 552:	9381                	srli	a5,a5,0x20
 554:	97aa                	add	a5,a5,a0
 556:	0007c783          	lbu	a5,0(a5)
 55a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 55e:	0005879b          	sext.w	a5,a1
 562:	02c5d5bb          	divuw	a1,a1,a2
 566:	0685                	addi	a3,a3,1
 568:	fec7f0e3          	bgeu	a5,a2,548 <printint+0x2a>
  if(neg)
 56c:	00088b63          	beqz	a7,582 <printint+0x64>
    buf[i++] = '-';
 570:	fd040793          	addi	a5,s0,-48
 574:	973e                	add	a4,a4,a5
 576:	02d00793          	li	a5,45
 57a:	fef70823          	sb	a5,-16(a4)
 57e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 582:	02e05863          	blez	a4,5b2 <printint+0x94>
 586:	fc040793          	addi	a5,s0,-64
 58a:	00e78933          	add	s2,a5,a4
 58e:	fff78993          	addi	s3,a5,-1
 592:	99ba                	add	s3,s3,a4
 594:	377d                	addiw	a4,a4,-1
 596:	1702                	slli	a4,a4,0x20
 598:	9301                	srli	a4,a4,0x20
 59a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 59e:	fff94583          	lbu	a1,-1(s2)
 5a2:	8526                	mv	a0,s1
 5a4:	00000097          	auipc	ra,0x0
 5a8:	f58080e7          	jalr	-168(ra) # 4fc <putc>
  while(--i >= 0)
 5ac:	197d                	addi	s2,s2,-1
 5ae:	ff3918e3          	bne	s2,s3,59e <printint+0x80>
}
 5b2:	70e2                	ld	ra,56(sp)
 5b4:	7442                	ld	s0,48(sp)
 5b6:	74a2                	ld	s1,40(sp)
 5b8:	7902                	ld	s2,32(sp)
 5ba:	69e2                	ld	s3,24(sp)
 5bc:	6121                	addi	sp,sp,64
 5be:	8082                	ret
    x = -xx;
 5c0:	40b005bb          	negw	a1,a1
    neg = 1;
 5c4:	4885                	li	a7,1
    x = -xx;
 5c6:	bf8d                	j	538 <printint+0x1a>

00000000000005c8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5c8:	7119                	addi	sp,sp,-128
 5ca:	fc86                	sd	ra,120(sp)
 5cc:	f8a2                	sd	s0,112(sp)
 5ce:	f4a6                	sd	s1,104(sp)
 5d0:	f0ca                	sd	s2,96(sp)
 5d2:	ecce                	sd	s3,88(sp)
 5d4:	e8d2                	sd	s4,80(sp)
 5d6:	e4d6                	sd	s5,72(sp)
 5d8:	e0da                	sd	s6,64(sp)
 5da:	fc5e                	sd	s7,56(sp)
 5dc:	f862                	sd	s8,48(sp)
 5de:	f466                	sd	s9,40(sp)
 5e0:	f06a                	sd	s10,32(sp)
 5e2:	ec6e                	sd	s11,24(sp)
 5e4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5e6:	0005c903          	lbu	s2,0(a1)
 5ea:	18090f63          	beqz	s2,788 <vprintf+0x1c0>
 5ee:	8aaa                	mv	s5,a0
 5f0:	8b32                	mv	s6,a2
 5f2:	00158493          	addi	s1,a1,1
  state = 0;
 5f6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5f8:	02500a13          	li	s4,37
      if(c == 'd'){
 5fc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 600:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 604:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 608:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 60c:	00000b97          	auipc	s7,0x0
 610:	3acb8b93          	addi	s7,s7,940 # 9b8 <digits>
 614:	a839                	j	632 <vprintf+0x6a>
        putc(fd, c);
 616:	85ca                	mv	a1,s2
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	ee2080e7          	jalr	-286(ra) # 4fc <putc>
 622:	a019                	j	628 <vprintf+0x60>
    } else if(state == '%'){
 624:	01498f63          	beq	s3,s4,642 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 628:	0485                	addi	s1,s1,1
 62a:	fff4c903          	lbu	s2,-1(s1)
 62e:	14090d63          	beqz	s2,788 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 632:	0009079b          	sext.w	a5,s2
    if(state == 0){
 636:	fe0997e3          	bnez	s3,624 <vprintf+0x5c>
      if(c == '%'){
 63a:	fd479ee3          	bne	a5,s4,616 <vprintf+0x4e>
        state = '%';
 63e:	89be                	mv	s3,a5
 640:	b7e5                	j	628 <vprintf+0x60>
      if(c == 'd'){
 642:	05878063          	beq	a5,s8,682 <vprintf+0xba>
      } else if(c == 'l') {
 646:	05978c63          	beq	a5,s9,69e <vprintf+0xd6>
      } else if(c == 'x') {
 64a:	07a78863          	beq	a5,s10,6ba <vprintf+0xf2>
      } else if(c == 'p') {
 64e:	09b78463          	beq	a5,s11,6d6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 652:	07300713          	li	a4,115
 656:	0ce78663          	beq	a5,a4,722 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 65a:	06300713          	li	a4,99
 65e:	0ee78e63          	beq	a5,a4,75a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 662:	11478863          	beq	a5,s4,772 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 666:	85d2                	mv	a1,s4
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	e92080e7          	jalr	-366(ra) # 4fc <putc>
        putc(fd, c);
 672:	85ca                	mv	a1,s2
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	e86080e7          	jalr	-378(ra) # 4fc <putc>
      }
      state = 0;
 67e:	4981                	li	s3,0
 680:	b765                	j	628 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 682:	008b0913          	addi	s2,s6,8
 686:	4685                	li	a3,1
 688:	4629                	li	a2,10
 68a:	000b2583          	lw	a1,0(s6)
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	e8e080e7          	jalr	-370(ra) # 51e <printint>
 698:	8b4a                	mv	s6,s2
      state = 0;
 69a:	4981                	li	s3,0
 69c:	b771                	j	628 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69e:	008b0913          	addi	s2,s6,8
 6a2:	4681                	li	a3,0
 6a4:	4629                	li	a2,10
 6a6:	000b2583          	lw	a1,0(s6)
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	e72080e7          	jalr	-398(ra) # 51e <printint>
 6b4:	8b4a                	mv	s6,s2
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	bf85                	j	628 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6ba:	008b0913          	addi	s2,s6,8
 6be:	4681                	li	a3,0
 6c0:	4641                	li	a2,16
 6c2:	000b2583          	lw	a1,0(s6)
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	e56080e7          	jalr	-426(ra) # 51e <printint>
 6d0:	8b4a                	mv	s6,s2
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bf91                	j	628 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6d6:	008b0793          	addi	a5,s6,8
 6da:	f8f43423          	sd	a5,-120(s0)
 6de:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6e2:	03000593          	li	a1,48
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e14080e7          	jalr	-492(ra) # 4fc <putc>
  putc(fd, 'x');
 6f0:	85ea                	mv	a1,s10
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	e08080e7          	jalr	-504(ra) # 4fc <putc>
 6fc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fe:	03c9d793          	srli	a5,s3,0x3c
 702:	97de                	add	a5,a5,s7
 704:	0007c583          	lbu	a1,0(a5)
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	df2080e7          	jalr	-526(ra) # 4fc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 712:	0992                	slli	s3,s3,0x4
 714:	397d                	addiw	s2,s2,-1
 716:	fe0914e3          	bnez	s2,6fe <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 71a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 71e:	4981                	li	s3,0
 720:	b721                	j	628 <vprintf+0x60>
        s = va_arg(ap, char*);
 722:	008b0993          	addi	s3,s6,8
 726:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 72a:	02090163          	beqz	s2,74c <vprintf+0x184>
        while(*s != 0){
 72e:	00094583          	lbu	a1,0(s2)
 732:	c9a1                	beqz	a1,782 <vprintf+0x1ba>
          putc(fd, *s);
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	dc6080e7          	jalr	-570(ra) # 4fc <putc>
          s++;
 73e:	0905                	addi	s2,s2,1
        while(*s != 0){
 740:	00094583          	lbu	a1,0(s2)
 744:	f9e5                	bnez	a1,734 <vprintf+0x16c>
        s = va_arg(ap, char*);
 746:	8b4e                	mv	s6,s3
      state = 0;
 748:	4981                	li	s3,0
 74a:	bdf9                	j	628 <vprintf+0x60>
          s = "(null)";
 74c:	00000917          	auipc	s2,0x0
 750:	26490913          	addi	s2,s2,612 # 9b0 <malloc+0x11e>
        while(*s != 0){
 754:	02800593          	li	a1,40
 758:	bff1                	j	734 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 75a:	008b0913          	addi	s2,s6,8
 75e:	000b4583          	lbu	a1,0(s6)
 762:	8556                	mv	a0,s5
 764:	00000097          	auipc	ra,0x0
 768:	d98080e7          	jalr	-616(ra) # 4fc <putc>
 76c:	8b4a                	mv	s6,s2
      state = 0;
 76e:	4981                	li	s3,0
 770:	bd65                	j	628 <vprintf+0x60>
        putc(fd, c);
 772:	85d2                	mv	a1,s4
 774:	8556                	mv	a0,s5
 776:	00000097          	auipc	ra,0x0
 77a:	d86080e7          	jalr	-634(ra) # 4fc <putc>
      state = 0;
 77e:	4981                	li	s3,0
 780:	b565                	j	628 <vprintf+0x60>
        s = va_arg(ap, char*);
 782:	8b4e                	mv	s6,s3
      state = 0;
 784:	4981                	li	s3,0
 786:	b54d                	j	628 <vprintf+0x60>
    }
  }
}
 788:	70e6                	ld	ra,120(sp)
 78a:	7446                	ld	s0,112(sp)
 78c:	74a6                	ld	s1,104(sp)
 78e:	7906                	ld	s2,96(sp)
 790:	69e6                	ld	s3,88(sp)
 792:	6a46                	ld	s4,80(sp)
 794:	6aa6                	ld	s5,72(sp)
 796:	6b06                	ld	s6,64(sp)
 798:	7be2                	ld	s7,56(sp)
 79a:	7c42                	ld	s8,48(sp)
 79c:	7ca2                	ld	s9,40(sp)
 79e:	7d02                	ld	s10,32(sp)
 7a0:	6de2                	ld	s11,24(sp)
 7a2:	6109                	addi	sp,sp,128
 7a4:	8082                	ret

00000000000007a6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a6:	715d                	addi	sp,sp,-80
 7a8:	ec06                	sd	ra,24(sp)
 7aa:	e822                	sd	s0,16(sp)
 7ac:	1000                	addi	s0,sp,32
 7ae:	e010                	sd	a2,0(s0)
 7b0:	e414                	sd	a3,8(s0)
 7b2:	e818                	sd	a4,16(s0)
 7b4:	ec1c                	sd	a5,24(s0)
 7b6:	03043023          	sd	a6,32(s0)
 7ba:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7be:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c2:	8622                	mv	a2,s0
 7c4:	00000097          	auipc	ra,0x0
 7c8:	e04080e7          	jalr	-508(ra) # 5c8 <vprintf>
}
 7cc:	60e2                	ld	ra,24(sp)
 7ce:	6442                	ld	s0,16(sp)
 7d0:	6161                	addi	sp,sp,80
 7d2:	8082                	ret

00000000000007d4 <printf>:

void
printf(const char *fmt, ...)
{
 7d4:	711d                	addi	sp,sp,-96
 7d6:	ec06                	sd	ra,24(sp)
 7d8:	e822                	sd	s0,16(sp)
 7da:	1000                	addi	s0,sp,32
 7dc:	e40c                	sd	a1,8(s0)
 7de:	e810                	sd	a2,16(s0)
 7e0:	ec14                	sd	a3,24(s0)
 7e2:	f018                	sd	a4,32(s0)
 7e4:	f41c                	sd	a5,40(s0)
 7e6:	03043823          	sd	a6,48(s0)
 7ea:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ee:	00840613          	addi	a2,s0,8
 7f2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f6:	85aa                	mv	a1,a0
 7f8:	4505                	li	a0,1
 7fa:	00000097          	auipc	ra,0x0
 7fe:	dce080e7          	jalr	-562(ra) # 5c8 <vprintf>
}
 802:	60e2                	ld	ra,24(sp)
 804:	6442                	ld	s0,16(sp)
 806:	6125                	addi	sp,sp,96
 808:	8082                	ret

000000000000080a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 80a:	1141                	addi	sp,sp,-16
 80c:	e422                	sd	s0,8(sp)
 80e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 810:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 814:	00000797          	auipc	a5,0x0
 818:	1bc7b783          	ld	a5,444(a5) # 9d0 <freep>
 81c:	a805                	j	84c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 81e:	4618                	lw	a4,8(a2)
 820:	9db9                	addw	a1,a1,a4
 822:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 826:	6398                	ld	a4,0(a5)
 828:	6318                	ld	a4,0(a4)
 82a:	fee53823          	sd	a4,-16(a0)
 82e:	a091                	j	872 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 830:	ff852703          	lw	a4,-8(a0)
 834:	9e39                	addw	a2,a2,a4
 836:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 838:	ff053703          	ld	a4,-16(a0)
 83c:	e398                	sd	a4,0(a5)
 83e:	a099                	j	884 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 840:	6398                	ld	a4,0(a5)
 842:	00e7e463          	bltu	a5,a4,84a <free+0x40>
 846:	00e6ea63          	bltu	a3,a4,85a <free+0x50>
{
 84a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84c:	fed7fae3          	bgeu	a5,a3,840 <free+0x36>
 850:	6398                	ld	a4,0(a5)
 852:	00e6e463          	bltu	a3,a4,85a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 856:	fee7eae3          	bltu	a5,a4,84a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 85a:	ff852583          	lw	a1,-8(a0)
 85e:	6390                	ld	a2,0(a5)
 860:	02059813          	slli	a6,a1,0x20
 864:	01c85713          	srli	a4,a6,0x1c
 868:	9736                	add	a4,a4,a3
 86a:	fae60ae3          	beq	a2,a4,81e <free+0x14>
    bp->s.ptr = p->s.ptr;
 86e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 872:	4790                	lw	a2,8(a5)
 874:	02061593          	slli	a1,a2,0x20
 878:	01c5d713          	srli	a4,a1,0x1c
 87c:	973e                	add	a4,a4,a5
 87e:	fae689e3          	beq	a3,a4,830 <free+0x26>
  } else
    p->s.ptr = bp;
 882:	e394                	sd	a3,0(a5)
  freep = p;
 884:	00000717          	auipc	a4,0x0
 888:	14f73623          	sd	a5,332(a4) # 9d0 <freep>
}
 88c:	6422                	ld	s0,8(sp)
 88e:	0141                	addi	sp,sp,16
 890:	8082                	ret

0000000000000892 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 892:	7139                	addi	sp,sp,-64
 894:	fc06                	sd	ra,56(sp)
 896:	f822                	sd	s0,48(sp)
 898:	f426                	sd	s1,40(sp)
 89a:	f04a                	sd	s2,32(sp)
 89c:	ec4e                	sd	s3,24(sp)
 89e:	e852                	sd	s4,16(sp)
 8a0:	e456                	sd	s5,8(sp)
 8a2:	e05a                	sd	s6,0(sp)
 8a4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a6:	02051493          	slli	s1,a0,0x20
 8aa:	9081                	srli	s1,s1,0x20
 8ac:	04bd                	addi	s1,s1,15
 8ae:	8091                	srli	s1,s1,0x4
 8b0:	0014899b          	addiw	s3,s1,1
 8b4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8b6:	00000517          	auipc	a0,0x0
 8ba:	11a53503          	ld	a0,282(a0) # 9d0 <freep>
 8be:	c515                	beqz	a0,8ea <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c2:	4798                	lw	a4,8(a5)
 8c4:	02977f63          	bgeu	a4,s1,902 <malloc+0x70>
 8c8:	8a4e                	mv	s4,s3
 8ca:	0009871b          	sext.w	a4,s3
 8ce:	6685                	lui	a3,0x1
 8d0:	00d77363          	bgeu	a4,a3,8d6 <malloc+0x44>
 8d4:	6a05                	lui	s4,0x1
 8d6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8da:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8de:	00000917          	auipc	s2,0x0
 8e2:	0f290913          	addi	s2,s2,242 # 9d0 <freep>
  if(p == (char*)-1)
 8e6:	5afd                	li	s5,-1
 8e8:	a895                	j	95c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8ea:	00000797          	auipc	a5,0x0
 8ee:	0ee78793          	addi	a5,a5,238 # 9d8 <base>
 8f2:	00000717          	auipc	a4,0x0
 8f6:	0cf73f23          	sd	a5,222(a4) # 9d0 <freep>
 8fa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8fc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 900:	b7e1                	j	8c8 <malloc+0x36>
      if(p->s.size == nunits)
 902:	02e48c63          	beq	s1,a4,93a <malloc+0xa8>
        p->s.size -= nunits;
 906:	4137073b          	subw	a4,a4,s3
 90a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 90c:	02071693          	slli	a3,a4,0x20
 910:	01c6d713          	srli	a4,a3,0x1c
 914:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 916:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 91a:	00000717          	auipc	a4,0x0
 91e:	0aa73b23          	sd	a0,182(a4) # 9d0 <freep>
      return (void*)(p + 1);
 922:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 926:	70e2                	ld	ra,56(sp)
 928:	7442                	ld	s0,48(sp)
 92a:	74a2                	ld	s1,40(sp)
 92c:	7902                	ld	s2,32(sp)
 92e:	69e2                	ld	s3,24(sp)
 930:	6a42                	ld	s4,16(sp)
 932:	6aa2                	ld	s5,8(sp)
 934:	6b02                	ld	s6,0(sp)
 936:	6121                	addi	sp,sp,64
 938:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 93a:	6398                	ld	a4,0(a5)
 93c:	e118                	sd	a4,0(a0)
 93e:	bff1                	j	91a <malloc+0x88>
  hp->s.size = nu;
 940:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 944:	0541                	addi	a0,a0,16
 946:	00000097          	auipc	ra,0x0
 94a:	ec4080e7          	jalr	-316(ra) # 80a <free>
  return freep;
 94e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 952:	d971                	beqz	a0,926 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 954:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 956:	4798                	lw	a4,8(a5)
 958:	fa9775e3          	bgeu	a4,s1,902 <malloc+0x70>
    if(p == freep)
 95c:	00093703          	ld	a4,0(s2)
 960:	853e                	mv	a0,a5
 962:	fef719e3          	bne	a4,a5,954 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 966:	8552                	mv	a0,s4
 968:	00000097          	auipc	ra,0x0
 96c:	b22080e7          	jalr	-1246(ra) # 48a <sbrk>
  if(p == (char*)-1)
 970:	fd5518e3          	bne	a0,s5,940 <malloc+0xae>
        return 0;
 974:	4501                	li	a0,0
 976:	bf45                	j	926 <malloc+0x94>
