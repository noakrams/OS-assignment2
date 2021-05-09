
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "kernel/param.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7de63          	bge	a5,a0,4a <main+0x4a>
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]), SIGKILL);
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1b0080e7          	jalr	432(ra) # 1d8 <atoi>
  30:	45a5                	li	a1,9
  32:	00000097          	auipc	ra,0x0
  36:	3ee080e7          	jalr	1006(ra) # 420 <kill>
  for(i=1; i<argc; i++)
  3a:	04a1                	addi	s1,s1,8
  3c:	ff2495e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  40:	4501                	li	a0,0
  42:	00000097          	auipc	ra,0x0
  46:	3ae080e7          	jalr	942(ra) # 3f0 <exit>
    fprintf(2, "usage: kill pid...\n");
  4a:	00001597          	auipc	a1,0x1
  4e:	91e58593          	addi	a1,a1,-1762 # 968 <malloc+0xe8>
  52:	4509                	li	a0,2
  54:	00000097          	auipc	ra,0x0
  58:	740080e7          	jalr	1856(ra) # 794 <fprintf>
    exit(1);
  5c:	4505                	li	a0,1
  5e:	00000097          	auipc	ra,0x0
  62:	392080e7          	jalr	914(ra) # 3f0 <exit>

0000000000000066 <strcpy>:
#include "kernel/Csemaphore.h"


char*
strcpy(char *s, const char *t)
{
  66:	1141                	addi	sp,sp,-16
  68:	e422                	sd	s0,8(sp)
  6a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6c:	87aa                	mv	a5,a0
  6e:	0585                	addi	a1,a1,1
  70:	0785                	addi	a5,a5,1
  72:	fff5c703          	lbu	a4,-1(a1)
  76:	fee78fa3          	sb	a4,-1(a5)
  7a:	fb75                	bnez	a4,6e <strcpy+0x8>
    ;
  return os;
}
  7c:	6422                	ld	s0,8(sp)
  7e:	0141                	addi	sp,sp,16
  80:	8082                	ret

0000000000000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	1141                	addi	sp,sp,-16
  84:	e422                	sd	s0,8(sp)
  86:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cb91                	beqz	a5,a0 <strcmp+0x1e>
  8e:	0005c703          	lbu	a4,0(a1)
  92:	00f71763          	bne	a4,a5,a0 <strcmp+0x1e>
    p++, q++;
  96:	0505                	addi	a0,a0,1
  98:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	fbe5                	bnez	a5,8e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  a0:	0005c503          	lbu	a0,0(a1)
}
  a4:	40a7853b          	subw	a0,a5,a0
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cf91                	beqz	a5,d4 <strlen+0x26>
  ba:	0505                	addi	a0,a0,1
  bc:	87aa                	mv	a5,a0
  be:	4685                	li	a3,1
  c0:	9e89                	subw	a3,a3,a0
  c2:	00f6853b          	addw	a0,a3,a5
  c6:	0785                	addi	a5,a5,1
  c8:	fff7c703          	lbu	a4,-1(a5)
  cc:	fb7d                	bnez	a4,c2 <strlen+0x14>
    ;
  return n;
}
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret
  for(n = 0; s[n]; n++)
  d4:	4501                	li	a0,0
  d6:	bfe5                	j	ce <strlen+0x20>

00000000000000d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  de:	ca19                	beqz	a2,f4 <memset+0x1c>
  e0:	87aa                	mv	a5,a0
  e2:	1602                	slli	a2,a2,0x20
  e4:	9201                	srli	a2,a2,0x20
  e6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ea:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ee:	0785                	addi	a5,a5,1
  f0:	fee79de3          	bne	a5,a4,ea <memset+0x12>
  }
  return dst;
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strchr>:

char*
strchr(const char *s, char c)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e422                	sd	s0,8(sp)
  fe:	0800                	addi	s0,sp,16
  for(; *s; s++)
 100:	00054783          	lbu	a5,0(a0)
 104:	cb99                	beqz	a5,11a <strchr+0x20>
    if(*s == c)
 106:	00f58763          	beq	a1,a5,114 <strchr+0x1a>
  for(; *s; s++)
 10a:	0505                	addi	a0,a0,1
 10c:	00054783          	lbu	a5,0(a0)
 110:	fbfd                	bnez	a5,106 <strchr+0xc>
      return (char*)s;
  return 0;
 112:	4501                	li	a0,0
}
 114:	6422                	ld	s0,8(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret
  return 0;
 11a:	4501                	li	a0,0
 11c:	bfe5                	j	114 <strchr+0x1a>

000000000000011e <gets>:

char*
gets(char *buf, int max)
{
 11e:	711d                	addi	sp,sp,-96
 120:	ec86                	sd	ra,88(sp)
 122:	e8a2                	sd	s0,80(sp)
 124:	e4a6                	sd	s1,72(sp)
 126:	e0ca                	sd	s2,64(sp)
 128:	fc4e                	sd	s3,56(sp)
 12a:	f852                	sd	s4,48(sp)
 12c:	f456                	sd	s5,40(sp)
 12e:	f05a                	sd	s6,32(sp)
 130:	ec5e                	sd	s7,24(sp)
 132:	1080                	addi	s0,sp,96
 134:	8baa                	mv	s7,a0
 136:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 138:	892a                	mv	s2,a0
 13a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13c:	4aa9                	li	s5,10
 13e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 140:	89a6                	mv	s3,s1
 142:	2485                	addiw	s1,s1,1
 144:	0344d863          	bge	s1,s4,174 <gets+0x56>
    cc = read(0, &c, 1);
 148:	4605                	li	a2,1
 14a:	faf40593          	addi	a1,s0,-81
 14e:	4501                	li	a0,0
 150:	00000097          	auipc	ra,0x0
 154:	2b8080e7          	jalr	696(ra) # 408 <read>
    if(cc < 1)
 158:	00a05e63          	blez	a0,174 <gets+0x56>
    buf[i++] = c;
 15c:	faf44783          	lbu	a5,-81(s0)
 160:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 164:	01578763          	beq	a5,s5,172 <gets+0x54>
 168:	0905                	addi	s2,s2,1
 16a:	fd679be3          	bne	a5,s6,140 <gets+0x22>
  for(i=0; i+1 < max; ){
 16e:	89a6                	mv	s3,s1
 170:	a011                	j	174 <gets+0x56>
 172:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 174:	99de                	add	s3,s3,s7
 176:	00098023          	sb	zero,0(s3)
  return buf;
}
 17a:	855e                	mv	a0,s7
 17c:	60e6                	ld	ra,88(sp)
 17e:	6446                	ld	s0,80(sp)
 180:	64a6                	ld	s1,72(sp)
 182:	6906                	ld	s2,64(sp)
 184:	79e2                	ld	s3,56(sp)
 186:	7a42                	ld	s4,48(sp)
 188:	7aa2                	ld	s5,40(sp)
 18a:	7b02                	ld	s6,32(sp)
 18c:	6be2                	ld	s7,24(sp)
 18e:	6125                	addi	sp,sp,96
 190:	8082                	ret

0000000000000192 <stat>:

int
stat(const char *n, struct stat *st)
{
 192:	1101                	addi	sp,sp,-32
 194:	ec06                	sd	ra,24(sp)
 196:	e822                	sd	s0,16(sp)
 198:	e426                	sd	s1,8(sp)
 19a:	e04a                	sd	s2,0(sp)
 19c:	1000                	addi	s0,sp,32
 19e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a0:	4581                	li	a1,0
 1a2:	00000097          	auipc	ra,0x0
 1a6:	28e080e7          	jalr	654(ra) # 430 <open>
  if(fd < 0)
 1aa:	02054563          	bltz	a0,1d4 <stat+0x42>
 1ae:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b0:	85ca                	mv	a1,s2
 1b2:	00000097          	auipc	ra,0x0
 1b6:	296080e7          	jalr	662(ra) # 448 <fstat>
 1ba:	892a                	mv	s2,a0
  close(fd);
 1bc:	8526                	mv	a0,s1
 1be:	00000097          	auipc	ra,0x0
 1c2:	25a080e7          	jalr	602(ra) # 418 <close>
  return r;
}
 1c6:	854a                	mv	a0,s2
 1c8:	60e2                	ld	ra,24(sp)
 1ca:	6442                	ld	s0,16(sp)
 1cc:	64a2                	ld	s1,8(sp)
 1ce:	6902                	ld	s2,0(sp)
 1d0:	6105                	addi	sp,sp,32
 1d2:	8082                	ret
    return -1;
 1d4:	597d                	li	s2,-1
 1d6:	bfc5                	j	1c6 <stat+0x34>

00000000000001d8 <atoi>:

int
atoi(const char *s)
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1de:	00054603          	lbu	a2,0(a0)
 1e2:	fd06079b          	addiw	a5,a2,-48
 1e6:	0ff7f793          	andi	a5,a5,255
 1ea:	4725                	li	a4,9
 1ec:	02f76963          	bltu	a4,a5,21e <atoi+0x46>
 1f0:	86aa                	mv	a3,a0
  n = 0;
 1f2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1f4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1f6:	0685                	addi	a3,a3,1
 1f8:	0025179b          	slliw	a5,a0,0x2
 1fc:	9fa9                	addw	a5,a5,a0
 1fe:	0017979b          	slliw	a5,a5,0x1
 202:	9fb1                	addw	a5,a5,a2
 204:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 208:	0006c603          	lbu	a2,0(a3)
 20c:	fd06071b          	addiw	a4,a2,-48
 210:	0ff77713          	andi	a4,a4,255
 214:	fee5f1e3          	bgeu	a1,a4,1f6 <atoi+0x1e>
  return n;
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret
  n = 0;
 21e:	4501                	li	a0,0
 220:	bfe5                	j	218 <atoi+0x40>

0000000000000222 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 222:	1141                	addi	sp,sp,-16
 224:	e422                	sd	s0,8(sp)
 226:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 228:	02b57463          	bgeu	a0,a1,250 <memmove+0x2e>
    while(n-- > 0)
 22c:	00c05f63          	blez	a2,24a <memmove+0x28>
 230:	1602                	slli	a2,a2,0x20
 232:	9201                	srli	a2,a2,0x20
 234:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 238:	872a                	mv	a4,a0
      *dst++ = *src++;
 23a:	0585                	addi	a1,a1,1
 23c:	0705                	addi	a4,a4,1
 23e:	fff5c683          	lbu	a3,-1(a1)
 242:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 246:	fee79ae3          	bne	a5,a4,23a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 24a:	6422                	ld	s0,8(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret
    dst += n;
 250:	00c50733          	add	a4,a0,a2
    src += n;
 254:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 256:	fec05ae3          	blez	a2,24a <memmove+0x28>
 25a:	fff6079b          	addiw	a5,a2,-1
 25e:	1782                	slli	a5,a5,0x20
 260:	9381                	srli	a5,a5,0x20
 262:	fff7c793          	not	a5,a5
 266:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 268:	15fd                	addi	a1,a1,-1
 26a:	177d                	addi	a4,a4,-1
 26c:	0005c683          	lbu	a3,0(a1)
 270:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 274:	fee79ae3          	bne	a5,a4,268 <memmove+0x46>
 278:	bfc9                	j	24a <memmove+0x28>

000000000000027a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 280:	ca05                	beqz	a2,2b0 <memcmp+0x36>
 282:	fff6069b          	addiw	a3,a2,-1
 286:	1682                	slli	a3,a3,0x20
 288:	9281                	srli	a3,a3,0x20
 28a:	0685                	addi	a3,a3,1
 28c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 28e:	00054783          	lbu	a5,0(a0)
 292:	0005c703          	lbu	a4,0(a1)
 296:	00e79863          	bne	a5,a4,2a6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 29a:	0505                	addi	a0,a0,1
    p2++;
 29c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 29e:	fed518e3          	bne	a0,a3,28e <memcmp+0x14>
  }
  return 0;
 2a2:	4501                	li	a0,0
 2a4:	a019                	j	2aa <memcmp+0x30>
      return *p1 - *p2;
 2a6:	40e7853b          	subw	a0,a5,a4
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
  return 0;
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <memcmp+0x30>

00000000000002b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2bc:	00000097          	auipc	ra,0x0
 2c0:	f66080e7          	jalr	-154(ra) # 222 <memmove>
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <csem_down>:


void 
csem_down(struct counting_semaphore *sem) {
 2cc:	1101                	addi	sp,sp,-32
 2ce:	ec06                	sd	ra,24(sp)
 2d0:	e822                	sd	s0,16(sp)
 2d2:	e426                	sd	s1,8(sp)
 2d4:	1000                	addi	s0,sp,32
 2d6:	84aa                	mv	s1,a0
    bsem_down(sem->bsem2);
 2d8:	4148                	lw	a0,4(a0)
 2da:	00000097          	auipc	ra,0x0
 2de:	1ce080e7          	jalr	462(ra) # 4a8 <bsem_down>
    bsem_down(sem->bsem1);
 2e2:	4088                	lw	a0,0(s1)
 2e4:	00000097          	auipc	ra,0x0
 2e8:	1c4080e7          	jalr	452(ra) # 4a8 <bsem_down>
    sem->count -= 1;
 2ec:	449c                	lw	a5,8(s1)
 2ee:	37fd                	addiw	a5,a5,-1
 2f0:	0007871b          	sext.w	a4,a5
 2f4:	c49c                	sw	a5,8(s1)
    if (sem->count > 0)
 2f6:	00e04c63          	bgtz	a4,30e <csem_down+0x42>
    	bsem_up(sem->bsem2);
    bsem_up(sem->bsem1);
 2fa:	4088                	lw	a0,0(s1)
 2fc:	00000097          	auipc	ra,0x0
 300:	1b4080e7          	jalr	436(ra) # 4b0 <bsem_up>
}
 304:	60e2                	ld	ra,24(sp)
 306:	6442                	ld	s0,16(sp)
 308:	64a2                	ld	s1,8(sp)
 30a:	6105                	addi	sp,sp,32
 30c:	8082                	ret
    	bsem_up(sem->bsem2);
 30e:	40c8                	lw	a0,4(s1)
 310:	00000097          	auipc	ra,0x0
 314:	1a0080e7          	jalr	416(ra) # 4b0 <bsem_up>
 318:	b7cd                	j	2fa <csem_down+0x2e>

000000000000031a <csem_up>:


void 
csem_up(struct counting_semaphore *sem) {
 31a:	1101                	addi	sp,sp,-32
 31c:	ec06                	sd	ra,24(sp)
 31e:	e822                	sd	s0,16(sp)
 320:	e426                	sd	s1,8(sp)
 322:	1000                	addi	s0,sp,32
 324:	84aa                	mv	s1,a0
	bsem_down(sem->bsem1);
 326:	4108                	lw	a0,0(a0)
 328:	00000097          	auipc	ra,0x0
 32c:	180080e7          	jalr	384(ra) # 4a8 <bsem_down>
	sem->count += 1;
 330:	449c                	lw	a5,8(s1)
 332:	2785                	addiw	a5,a5,1
 334:	0007871b          	sext.w	a4,a5
 338:	c49c                	sw	a5,8(s1)
	if (sem->count == 1)
 33a:	4785                	li	a5,1
 33c:	00f70c63          	beq	a4,a5,354 <csem_up+0x3a>
		bsem_up(sem->bsem2);
	bsem_up(sem->bsem1);
 340:	4088                	lw	a0,0(s1)
 342:	00000097          	auipc	ra,0x0
 346:	16e080e7          	jalr	366(ra) # 4b0 <bsem_up>
}
 34a:	60e2                	ld	ra,24(sp)
 34c:	6442                	ld	s0,16(sp)
 34e:	64a2                	ld	s1,8(sp)
 350:	6105                	addi	sp,sp,32
 352:	8082                	ret
		bsem_up(sem->bsem2);
 354:	40c8                	lw	a0,4(s1)
 356:	00000097          	auipc	ra,0x0
 35a:	15a080e7          	jalr	346(ra) # 4b0 <bsem_up>
 35e:	b7cd                	j	340 <csem_up+0x26>

0000000000000360 <csem_alloc>:


int 
csem_alloc(struct counting_semaphore *sem, int count) {
 360:	7179                	addi	sp,sp,-48
 362:	f406                	sd	ra,40(sp)
 364:	f022                	sd	s0,32(sp)
 366:	ec26                	sd	s1,24(sp)
 368:	e84a                	sd	s2,16(sp)
 36a:	e44e                	sd	s3,8(sp)
 36c:	1800                	addi	s0,sp,48
 36e:	892a                	mv	s2,a0
 370:	89ae                	mv	s3,a1
    int bsem1 = bsem_alloc();
 372:	00000097          	auipc	ra,0x0
 376:	14e080e7          	jalr	334(ra) # 4c0 <bsem_alloc>
 37a:	84aa                	mv	s1,a0
    int bsem2 = bsem_alloc();
 37c:	00000097          	auipc	ra,0x0
 380:	144080e7          	jalr	324(ra) # 4c0 <bsem_alloc>
    if (bsem1 == -1 || bsem2 == -1)
 384:	57fd                	li	a5,-1
 386:	00f48d63          	beq	s1,a5,3a0 <csem_alloc+0x40>
 38a:	02f50863          	beq	a0,a5,3ba <csem_alloc+0x5a>
        return -1; 
    sem->bsem1 = bsem1;
 38e:	00992023          	sw	s1,0(s2)
    sem->bsem2 = bsem2;
 392:	00a92223          	sw	a0,4(s2)
    if (count == 0)
 396:	00098d63          	beqz	s3,3b0 <csem_alloc+0x50>
        // Binary semaphore first value = min(1, count)
        bsem_down(sem->bsem2); 
    sem->count = count;
 39a:	01392423          	sw	s3,8(s2)
    return 0;
 39e:	4481                	li	s1,0
}
 3a0:	8526                	mv	a0,s1
 3a2:	70a2                	ld	ra,40(sp)
 3a4:	7402                	ld	s0,32(sp)
 3a6:	64e2                	ld	s1,24(sp)
 3a8:	6942                	ld	s2,16(sp)
 3aa:	69a2                	ld	s3,8(sp)
 3ac:	6145                	addi	sp,sp,48
 3ae:	8082                	ret
        bsem_down(sem->bsem2); 
 3b0:	00000097          	auipc	ra,0x0
 3b4:	0f8080e7          	jalr	248(ra) # 4a8 <bsem_down>
 3b8:	b7cd                	j	39a <csem_alloc+0x3a>
        return -1; 
 3ba:	84aa                	mv	s1,a0
 3bc:	b7d5                	j	3a0 <csem_alloc+0x40>

00000000000003be <csem_free>:


void 
csem_free(struct counting_semaphore *sem) {
 3be:	1101                	addi	sp,sp,-32
 3c0:	ec06                	sd	ra,24(sp)
 3c2:	e822                	sd	s0,16(sp)
 3c4:	e426                	sd	s1,8(sp)
 3c6:	1000                	addi	s0,sp,32
 3c8:	84aa                	mv	s1,a0
    bsem_free(sem->bsem1);
 3ca:	4108                	lw	a0,0(a0)
 3cc:	00000097          	auipc	ra,0x0
 3d0:	0ec080e7          	jalr	236(ra) # 4b8 <bsem_free>
    bsem_free(sem->bsem2);
 3d4:	40c8                	lw	a0,4(s1)
 3d6:	00000097          	auipc	ra,0x0
 3da:	0e2080e7          	jalr	226(ra) # 4b8 <bsem_free>
    //free(sem);
}
 3de:	60e2                	ld	ra,24(sp)
 3e0:	6442                	ld	s0,16(sp)
 3e2:	64a2                	ld	s1,8(sp)
 3e4:	6105                	addi	sp,sp,32
 3e6:	8082                	ret

00000000000003e8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e8:	4885                	li	a7,1
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3f0:	4889                	li	a7,2
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f8:	488d                	li	a7,3
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 400:	4891                	li	a7,4
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <read>:
.global read
read:
 li a7, SYS_read
 408:	4895                	li	a7,5
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <write>:
.global write
write:
 li a7, SYS_write
 410:	48c1                	li	a7,16
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <close>:
.global close
close:
 li a7, SYS_close
 418:	48d5                	li	a7,21
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <kill>:
.global kill
kill:
 li a7, SYS_kill
 420:	4899                	li	a7,6
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <exec>:
.global exec
exec:
 li a7, SYS_exec
 428:	489d                	li	a7,7
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <open>:
.global open
open:
 li a7, SYS_open
 430:	48bd                	li	a7,15
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 438:	48c5                	li	a7,17
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 440:	48c9                	li	a7,18
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 448:	48a1                	li	a7,8
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <link>:
.global link
link:
 li a7, SYS_link
 450:	48cd                	li	a7,19
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 458:	48d1                	li	a7,20
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 460:	48a5                	li	a7,9
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <dup>:
.global dup
dup:
 li a7, SYS_dup
 468:	48a9                	li	a7,10
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 470:	48ad                	li	a7,11
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 478:	48b1                	li	a7,12
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 480:	48b5                	li	a7,13
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 488:	48b9                	li	a7,14
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 490:	48d9                	li	a7,22
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 498:	48dd                	li	a7,23
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 4a0:	48e1                	li	a7,24
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
 4a8:	48ed                	li	a7,27
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
 4b0:	48f1                	li	a7,28
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
 4b8:	48e9                	li	a7,26
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
 4c0:	48e5                	li	a7,25
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
 4c8:	48f5                	li	a7,29
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
 4d0:	48f9                	li	a7,30
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
 4d8:	48fd                	li	a7,31
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
 4e0:	02000893          	li	a7,32
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ea:	1101                	addi	sp,sp,-32
 4ec:	ec06                	sd	ra,24(sp)
 4ee:	e822                	sd	s0,16(sp)
 4f0:	1000                	addi	s0,sp,32
 4f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4f6:	4605                	li	a2,1
 4f8:	fef40593          	addi	a1,s0,-17
 4fc:	00000097          	auipc	ra,0x0
 500:	f14080e7          	jalr	-236(ra) # 410 <write>
}
 504:	60e2                	ld	ra,24(sp)
 506:	6442                	ld	s0,16(sp)
 508:	6105                	addi	sp,sp,32
 50a:	8082                	ret

000000000000050c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 50c:	7139                	addi	sp,sp,-64
 50e:	fc06                	sd	ra,56(sp)
 510:	f822                	sd	s0,48(sp)
 512:	f426                	sd	s1,40(sp)
 514:	f04a                	sd	s2,32(sp)
 516:	ec4e                	sd	s3,24(sp)
 518:	0080                	addi	s0,sp,64
 51a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 51c:	c299                	beqz	a3,522 <printint+0x16>
 51e:	0805c863          	bltz	a1,5ae <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 522:	2581                	sext.w	a1,a1
  neg = 0;
 524:	4881                	li	a7,0
 526:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 52a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 52c:	2601                	sext.w	a2,a2
 52e:	00000517          	auipc	a0,0x0
 532:	45a50513          	addi	a0,a0,1114 # 988 <digits>
 536:	883a                	mv	a6,a4
 538:	2705                	addiw	a4,a4,1
 53a:	02c5f7bb          	remuw	a5,a1,a2
 53e:	1782                	slli	a5,a5,0x20
 540:	9381                	srli	a5,a5,0x20
 542:	97aa                	add	a5,a5,a0
 544:	0007c783          	lbu	a5,0(a5)
 548:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 54c:	0005879b          	sext.w	a5,a1
 550:	02c5d5bb          	divuw	a1,a1,a2
 554:	0685                	addi	a3,a3,1
 556:	fec7f0e3          	bgeu	a5,a2,536 <printint+0x2a>
  if(neg)
 55a:	00088b63          	beqz	a7,570 <printint+0x64>
    buf[i++] = '-';
 55e:	fd040793          	addi	a5,s0,-48
 562:	973e                	add	a4,a4,a5
 564:	02d00793          	li	a5,45
 568:	fef70823          	sb	a5,-16(a4)
 56c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 570:	02e05863          	blez	a4,5a0 <printint+0x94>
 574:	fc040793          	addi	a5,s0,-64
 578:	00e78933          	add	s2,a5,a4
 57c:	fff78993          	addi	s3,a5,-1
 580:	99ba                	add	s3,s3,a4
 582:	377d                	addiw	a4,a4,-1
 584:	1702                	slli	a4,a4,0x20
 586:	9301                	srli	a4,a4,0x20
 588:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 58c:	fff94583          	lbu	a1,-1(s2)
 590:	8526                	mv	a0,s1
 592:	00000097          	auipc	ra,0x0
 596:	f58080e7          	jalr	-168(ra) # 4ea <putc>
  while(--i >= 0)
 59a:	197d                	addi	s2,s2,-1
 59c:	ff3918e3          	bne	s2,s3,58c <printint+0x80>
}
 5a0:	70e2                	ld	ra,56(sp)
 5a2:	7442                	ld	s0,48(sp)
 5a4:	74a2                	ld	s1,40(sp)
 5a6:	7902                	ld	s2,32(sp)
 5a8:	69e2                	ld	s3,24(sp)
 5aa:	6121                	addi	sp,sp,64
 5ac:	8082                	ret
    x = -xx;
 5ae:	40b005bb          	negw	a1,a1
    neg = 1;
 5b2:	4885                	li	a7,1
    x = -xx;
 5b4:	bf8d                	j	526 <printint+0x1a>

00000000000005b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5b6:	7119                	addi	sp,sp,-128
 5b8:	fc86                	sd	ra,120(sp)
 5ba:	f8a2                	sd	s0,112(sp)
 5bc:	f4a6                	sd	s1,104(sp)
 5be:	f0ca                	sd	s2,96(sp)
 5c0:	ecce                	sd	s3,88(sp)
 5c2:	e8d2                	sd	s4,80(sp)
 5c4:	e4d6                	sd	s5,72(sp)
 5c6:	e0da                	sd	s6,64(sp)
 5c8:	fc5e                	sd	s7,56(sp)
 5ca:	f862                	sd	s8,48(sp)
 5cc:	f466                	sd	s9,40(sp)
 5ce:	f06a                	sd	s10,32(sp)
 5d0:	ec6e                	sd	s11,24(sp)
 5d2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5d4:	0005c903          	lbu	s2,0(a1)
 5d8:	18090f63          	beqz	s2,776 <vprintf+0x1c0>
 5dc:	8aaa                	mv	s5,a0
 5de:	8b32                	mv	s6,a2
 5e0:	00158493          	addi	s1,a1,1
  state = 0;
 5e4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5e6:	02500a13          	li	s4,37
      if(c == 'd'){
 5ea:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5ee:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5f2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5f6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5fa:	00000b97          	auipc	s7,0x0
 5fe:	38eb8b93          	addi	s7,s7,910 # 988 <digits>
 602:	a839                	j	620 <vprintf+0x6a>
        putc(fd, c);
 604:	85ca                	mv	a1,s2
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	ee2080e7          	jalr	-286(ra) # 4ea <putc>
 610:	a019                	j	616 <vprintf+0x60>
    } else if(state == '%'){
 612:	01498f63          	beq	s3,s4,630 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 616:	0485                	addi	s1,s1,1
 618:	fff4c903          	lbu	s2,-1(s1)
 61c:	14090d63          	beqz	s2,776 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 620:	0009079b          	sext.w	a5,s2
    if(state == 0){
 624:	fe0997e3          	bnez	s3,612 <vprintf+0x5c>
      if(c == '%'){
 628:	fd479ee3          	bne	a5,s4,604 <vprintf+0x4e>
        state = '%';
 62c:	89be                	mv	s3,a5
 62e:	b7e5                	j	616 <vprintf+0x60>
      if(c == 'd'){
 630:	05878063          	beq	a5,s8,670 <vprintf+0xba>
      } else if(c == 'l') {
 634:	05978c63          	beq	a5,s9,68c <vprintf+0xd6>
      } else if(c == 'x') {
 638:	07a78863          	beq	a5,s10,6a8 <vprintf+0xf2>
      } else if(c == 'p') {
 63c:	09b78463          	beq	a5,s11,6c4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 640:	07300713          	li	a4,115
 644:	0ce78663          	beq	a5,a4,710 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 648:	06300713          	li	a4,99
 64c:	0ee78e63          	beq	a5,a4,748 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 650:	11478863          	beq	a5,s4,760 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 654:	85d2                	mv	a1,s4
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	e92080e7          	jalr	-366(ra) # 4ea <putc>
        putc(fd, c);
 660:	85ca                	mv	a1,s2
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	e86080e7          	jalr	-378(ra) # 4ea <putc>
      }
      state = 0;
 66c:	4981                	li	s3,0
 66e:	b765                	j	616 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 670:	008b0913          	addi	s2,s6,8
 674:	4685                	li	a3,1
 676:	4629                	li	a2,10
 678:	000b2583          	lw	a1,0(s6)
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	e8e080e7          	jalr	-370(ra) # 50c <printint>
 686:	8b4a                	mv	s6,s2
      state = 0;
 688:	4981                	li	s3,0
 68a:	b771                	j	616 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68c:	008b0913          	addi	s2,s6,8
 690:	4681                	li	a3,0
 692:	4629                	li	a2,10
 694:	000b2583          	lw	a1,0(s6)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	e72080e7          	jalr	-398(ra) # 50c <printint>
 6a2:	8b4a                	mv	s6,s2
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bf85                	j	616 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6a8:	008b0913          	addi	s2,s6,8
 6ac:	4681                	li	a3,0
 6ae:	4641                	li	a2,16
 6b0:	000b2583          	lw	a1,0(s6)
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	e56080e7          	jalr	-426(ra) # 50c <printint>
 6be:	8b4a                	mv	s6,s2
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	bf91                	j	616 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6c4:	008b0793          	addi	a5,s6,8
 6c8:	f8f43423          	sd	a5,-120(s0)
 6cc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6d0:	03000593          	li	a1,48
 6d4:	8556                	mv	a0,s5
 6d6:	00000097          	auipc	ra,0x0
 6da:	e14080e7          	jalr	-492(ra) # 4ea <putc>
  putc(fd, 'x');
 6de:	85ea                	mv	a1,s10
 6e0:	8556                	mv	a0,s5
 6e2:	00000097          	auipc	ra,0x0
 6e6:	e08080e7          	jalr	-504(ra) # 4ea <putc>
 6ea:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ec:	03c9d793          	srli	a5,s3,0x3c
 6f0:	97de                	add	a5,a5,s7
 6f2:	0007c583          	lbu	a1,0(a5)
 6f6:	8556                	mv	a0,s5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	df2080e7          	jalr	-526(ra) # 4ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 700:	0992                	slli	s3,s3,0x4
 702:	397d                	addiw	s2,s2,-1
 704:	fe0914e3          	bnez	s2,6ec <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 708:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b721                	j	616 <vprintf+0x60>
        s = va_arg(ap, char*);
 710:	008b0993          	addi	s3,s6,8
 714:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 718:	02090163          	beqz	s2,73a <vprintf+0x184>
        while(*s != 0){
 71c:	00094583          	lbu	a1,0(s2)
 720:	c9a1                	beqz	a1,770 <vprintf+0x1ba>
          putc(fd, *s);
 722:	8556                	mv	a0,s5
 724:	00000097          	auipc	ra,0x0
 728:	dc6080e7          	jalr	-570(ra) # 4ea <putc>
          s++;
 72c:	0905                	addi	s2,s2,1
        while(*s != 0){
 72e:	00094583          	lbu	a1,0(s2)
 732:	f9e5                	bnez	a1,722 <vprintf+0x16c>
        s = va_arg(ap, char*);
 734:	8b4e                	mv	s6,s3
      state = 0;
 736:	4981                	li	s3,0
 738:	bdf9                	j	616 <vprintf+0x60>
          s = "(null)";
 73a:	00000917          	auipc	s2,0x0
 73e:	24690913          	addi	s2,s2,582 # 980 <malloc+0x100>
        while(*s != 0){
 742:	02800593          	li	a1,40
 746:	bff1                	j	722 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 748:	008b0913          	addi	s2,s6,8
 74c:	000b4583          	lbu	a1,0(s6)
 750:	8556                	mv	a0,s5
 752:	00000097          	auipc	ra,0x0
 756:	d98080e7          	jalr	-616(ra) # 4ea <putc>
 75a:	8b4a                	mv	s6,s2
      state = 0;
 75c:	4981                	li	s3,0
 75e:	bd65                	j	616 <vprintf+0x60>
        putc(fd, c);
 760:	85d2                	mv	a1,s4
 762:	8556                	mv	a0,s5
 764:	00000097          	auipc	ra,0x0
 768:	d86080e7          	jalr	-634(ra) # 4ea <putc>
      state = 0;
 76c:	4981                	li	s3,0
 76e:	b565                	j	616 <vprintf+0x60>
        s = va_arg(ap, char*);
 770:	8b4e                	mv	s6,s3
      state = 0;
 772:	4981                	li	s3,0
 774:	b54d                	j	616 <vprintf+0x60>
    }
  }
}
 776:	70e6                	ld	ra,120(sp)
 778:	7446                	ld	s0,112(sp)
 77a:	74a6                	ld	s1,104(sp)
 77c:	7906                	ld	s2,96(sp)
 77e:	69e6                	ld	s3,88(sp)
 780:	6a46                	ld	s4,80(sp)
 782:	6aa6                	ld	s5,72(sp)
 784:	6b06                	ld	s6,64(sp)
 786:	7be2                	ld	s7,56(sp)
 788:	7c42                	ld	s8,48(sp)
 78a:	7ca2                	ld	s9,40(sp)
 78c:	7d02                	ld	s10,32(sp)
 78e:	6de2                	ld	s11,24(sp)
 790:	6109                	addi	sp,sp,128
 792:	8082                	ret

0000000000000794 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 794:	715d                	addi	sp,sp,-80
 796:	ec06                	sd	ra,24(sp)
 798:	e822                	sd	s0,16(sp)
 79a:	1000                	addi	s0,sp,32
 79c:	e010                	sd	a2,0(s0)
 79e:	e414                	sd	a3,8(s0)
 7a0:	e818                	sd	a4,16(s0)
 7a2:	ec1c                	sd	a5,24(s0)
 7a4:	03043023          	sd	a6,32(s0)
 7a8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7b0:	8622                	mv	a2,s0
 7b2:	00000097          	auipc	ra,0x0
 7b6:	e04080e7          	jalr	-508(ra) # 5b6 <vprintf>
}
 7ba:	60e2                	ld	ra,24(sp)
 7bc:	6442                	ld	s0,16(sp)
 7be:	6161                	addi	sp,sp,80
 7c0:	8082                	ret

00000000000007c2 <printf>:

void
printf(const char *fmt, ...)
{
 7c2:	711d                	addi	sp,sp,-96
 7c4:	ec06                	sd	ra,24(sp)
 7c6:	e822                	sd	s0,16(sp)
 7c8:	1000                	addi	s0,sp,32
 7ca:	e40c                	sd	a1,8(s0)
 7cc:	e810                	sd	a2,16(s0)
 7ce:	ec14                	sd	a3,24(s0)
 7d0:	f018                	sd	a4,32(s0)
 7d2:	f41c                	sd	a5,40(s0)
 7d4:	03043823          	sd	a6,48(s0)
 7d8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7dc:	00840613          	addi	a2,s0,8
 7e0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7e4:	85aa                	mv	a1,a0
 7e6:	4505                	li	a0,1
 7e8:	00000097          	auipc	ra,0x0
 7ec:	dce080e7          	jalr	-562(ra) # 5b6 <vprintf>
}
 7f0:	60e2                	ld	ra,24(sp)
 7f2:	6442                	ld	s0,16(sp)
 7f4:	6125                	addi	sp,sp,96
 7f6:	8082                	ret

00000000000007f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f8:	1141                	addi	sp,sp,-16
 7fa:	e422                	sd	s0,8(sp)
 7fc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7fe:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 802:	00000797          	auipc	a5,0x0
 806:	19e7b783          	ld	a5,414(a5) # 9a0 <freep>
 80a:	a805                	j	83a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 80c:	4618                	lw	a4,8(a2)
 80e:	9db9                	addw	a1,a1,a4
 810:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 814:	6398                	ld	a4,0(a5)
 816:	6318                	ld	a4,0(a4)
 818:	fee53823          	sd	a4,-16(a0)
 81c:	a091                	j	860 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 81e:	ff852703          	lw	a4,-8(a0)
 822:	9e39                	addw	a2,a2,a4
 824:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 826:	ff053703          	ld	a4,-16(a0)
 82a:	e398                	sd	a4,0(a5)
 82c:	a099                	j	872 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82e:	6398                	ld	a4,0(a5)
 830:	00e7e463          	bltu	a5,a4,838 <free+0x40>
 834:	00e6ea63          	bltu	a3,a4,848 <free+0x50>
{
 838:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83a:	fed7fae3          	bgeu	a5,a3,82e <free+0x36>
 83e:	6398                	ld	a4,0(a5)
 840:	00e6e463          	bltu	a3,a4,848 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 844:	fee7eae3          	bltu	a5,a4,838 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 848:	ff852583          	lw	a1,-8(a0)
 84c:	6390                	ld	a2,0(a5)
 84e:	02059813          	slli	a6,a1,0x20
 852:	01c85713          	srli	a4,a6,0x1c
 856:	9736                	add	a4,a4,a3
 858:	fae60ae3          	beq	a2,a4,80c <free+0x14>
    bp->s.ptr = p->s.ptr;
 85c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 860:	4790                	lw	a2,8(a5)
 862:	02061593          	slli	a1,a2,0x20
 866:	01c5d713          	srli	a4,a1,0x1c
 86a:	973e                	add	a4,a4,a5
 86c:	fae689e3          	beq	a3,a4,81e <free+0x26>
  } else
    p->s.ptr = bp;
 870:	e394                	sd	a3,0(a5)
  freep = p;
 872:	00000717          	auipc	a4,0x0
 876:	12f73723          	sd	a5,302(a4) # 9a0 <freep>
}
 87a:	6422                	ld	s0,8(sp)
 87c:	0141                	addi	sp,sp,16
 87e:	8082                	ret

0000000000000880 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 880:	7139                	addi	sp,sp,-64
 882:	fc06                	sd	ra,56(sp)
 884:	f822                	sd	s0,48(sp)
 886:	f426                	sd	s1,40(sp)
 888:	f04a                	sd	s2,32(sp)
 88a:	ec4e                	sd	s3,24(sp)
 88c:	e852                	sd	s4,16(sp)
 88e:	e456                	sd	s5,8(sp)
 890:	e05a                	sd	s6,0(sp)
 892:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 894:	02051493          	slli	s1,a0,0x20
 898:	9081                	srli	s1,s1,0x20
 89a:	04bd                	addi	s1,s1,15
 89c:	8091                	srli	s1,s1,0x4
 89e:	0014899b          	addiw	s3,s1,1
 8a2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8a4:	00000517          	auipc	a0,0x0
 8a8:	0fc53503          	ld	a0,252(a0) # 9a0 <freep>
 8ac:	c515                	beqz	a0,8d8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b0:	4798                	lw	a4,8(a5)
 8b2:	02977f63          	bgeu	a4,s1,8f0 <malloc+0x70>
 8b6:	8a4e                	mv	s4,s3
 8b8:	0009871b          	sext.w	a4,s3
 8bc:	6685                	lui	a3,0x1
 8be:	00d77363          	bgeu	a4,a3,8c4 <malloc+0x44>
 8c2:	6a05                	lui	s4,0x1
 8c4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8cc:	00000917          	auipc	s2,0x0
 8d0:	0d490913          	addi	s2,s2,212 # 9a0 <freep>
  if(p == (char*)-1)
 8d4:	5afd                	li	s5,-1
 8d6:	a895                	j	94a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8d8:	00000797          	auipc	a5,0x0
 8dc:	0d078793          	addi	a5,a5,208 # 9a8 <base>
 8e0:	00000717          	auipc	a4,0x0
 8e4:	0cf73023          	sd	a5,192(a4) # 9a0 <freep>
 8e8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ea:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ee:	b7e1                	j	8b6 <malloc+0x36>
      if(p->s.size == nunits)
 8f0:	02e48c63          	beq	s1,a4,928 <malloc+0xa8>
        p->s.size -= nunits;
 8f4:	4137073b          	subw	a4,a4,s3
 8f8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8fa:	02071693          	slli	a3,a4,0x20
 8fe:	01c6d713          	srli	a4,a3,0x1c
 902:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 904:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 908:	00000717          	auipc	a4,0x0
 90c:	08a73c23          	sd	a0,152(a4) # 9a0 <freep>
      return (void*)(p + 1);
 910:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 914:	70e2                	ld	ra,56(sp)
 916:	7442                	ld	s0,48(sp)
 918:	74a2                	ld	s1,40(sp)
 91a:	7902                	ld	s2,32(sp)
 91c:	69e2                	ld	s3,24(sp)
 91e:	6a42                	ld	s4,16(sp)
 920:	6aa2                	ld	s5,8(sp)
 922:	6b02                	ld	s6,0(sp)
 924:	6121                	addi	sp,sp,64
 926:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 928:	6398                	ld	a4,0(a5)
 92a:	e118                	sd	a4,0(a0)
 92c:	bff1                	j	908 <malloc+0x88>
  hp->s.size = nu;
 92e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 932:	0541                	addi	a0,a0,16
 934:	00000097          	auipc	ra,0x0
 938:	ec4080e7          	jalr	-316(ra) # 7f8 <free>
  return freep;
 93c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 940:	d971                	beqz	a0,914 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 942:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 944:	4798                	lw	a4,8(a5)
 946:	fa9775e3          	bgeu	a4,s1,8f0 <malloc+0x70>
    if(p == freep)
 94a:	00093703          	ld	a4,0(s2)
 94e:	853e                	mv	a0,a5
 950:	fef719e3          	bne	a4,a5,942 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 954:	8552                	mv	a0,s4
 956:	00000097          	auipc	ra,0x0
 95a:	b22080e7          	jalr	-1246(ra) # 478 <sbrk>
  if(p == (char*)-1)
 95e:	fd5518e3          	bne	a0,s5,92e <malloc+0xae>
        return 0;
 962:	4501                	li	a0,0
 964:	bf45                	j	914 <malloc+0x94>
