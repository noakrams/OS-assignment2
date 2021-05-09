
user/_echo:     file format elf64-littleriscv


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
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  int i;

  for(i = 1; i < argc; i++){
  10:	4785                	li	a5,1
  12:	06a7d463          	bge	a5,a0,7a <main+0x7a>
  16:	00858493          	addi	s1,a1,8
  1a:	ffe5099b          	addiw	s3,a0,-2
  1e:	02099793          	slli	a5,s3,0x20
  22:	01d7d993          	srli	s3,a5,0x1d
  26:	05c1                	addi	a1,a1,16
  28:	99ae                	add	s3,s3,a1
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  2a:	00001a17          	auipc	s4,0x1
  2e:	95ea0a13          	addi	s4,s4,-1698 # 988 <malloc+0xea>
    write(1, argv[i], strlen(argv[i]));
  32:	0004b903          	ld	s2,0(s1)
  36:	854a                	mv	a0,s2
  38:	00000097          	auipc	ra,0x0
  3c:	094080e7          	jalr	148(ra) # cc <strlen>
  40:	0005061b          	sext.w	a2,a0
  44:	85ca                	mv	a1,s2
  46:	4505                	li	a0,1
  48:	00000097          	auipc	ra,0x0
  4c:	3e6080e7          	jalr	998(ra) # 42e <write>
    if(i + 1 < argc){
  50:	04a1                	addi	s1,s1,8
  52:	01348a63          	beq	s1,s3,66 <main+0x66>
      write(1, " ", 1);
  56:	4605                	li	a2,1
  58:	85d2                	mv	a1,s4
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	3d2080e7          	jalr	978(ra) # 42e <write>
  for(i = 1; i < argc; i++){
  64:	b7f9                	j	32 <main+0x32>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00001597          	auipc	a1,0x1
  6c:	92858593          	addi	a1,a1,-1752 # 990 <malloc+0xf2>
  70:	4505                	li	a0,1
  72:	00000097          	auipc	ra,0x0
  76:	3bc080e7          	jalr	956(ra) # 42e <write>
    }
  }
  exit(0);
  7a:	4501                	li	a0,0
  7c:	00000097          	auipc	ra,0x0
  80:	392080e7          	jalr	914(ra) # 40e <exit>

0000000000000084 <strcpy>:
#include "kernel/Csemaphore.h"


char*
strcpy(char *s, const char *t)
{
  84:	1141                	addi	sp,sp,-16
  86:	e422                	sd	s0,8(sp)
  88:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8a:	87aa                	mv	a5,a0
  8c:	0585                	addi	a1,a1,1
  8e:	0785                	addi	a5,a5,1
  90:	fff5c703          	lbu	a4,-1(a1)
  94:	fee78fa3          	sb	a4,-1(a5)
  98:	fb75                	bnez	a4,8c <strcpy+0x8>
    ;
  return os;
}
  9a:	6422                	ld	s0,8(sp)
  9c:	0141                	addi	sp,sp,16
  9e:	8082                	ret

00000000000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a6:	00054783          	lbu	a5,0(a0)
  aa:	cb91                	beqz	a5,be <strcmp+0x1e>
  ac:	0005c703          	lbu	a4,0(a1)
  b0:	00f71763          	bne	a4,a5,be <strcmp+0x1e>
    p++, q++;
  b4:	0505                	addi	a0,a0,1
  b6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b8:	00054783          	lbu	a5,0(a0)
  bc:	fbe5                	bnez	a5,ac <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  be:	0005c503          	lbu	a0,0(a1)
}
  c2:	40a7853b          	subw	a0,a5,a0
  c6:	6422                	ld	s0,8(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret

00000000000000cc <strlen>:

uint
strlen(const char *s)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e422                	sd	s0,8(sp)
  d0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cf91                	beqz	a5,f2 <strlen+0x26>
  d8:	0505                	addi	a0,a0,1
  da:	87aa                	mv	a5,a0
  dc:	4685                	li	a3,1
  de:	9e89                	subw	a3,a3,a0
  e0:	00f6853b          	addw	a0,a3,a5
  e4:	0785                	addi	a5,a5,1
  e6:	fff7c703          	lbu	a4,-1(a5)
  ea:	fb7d                	bnez	a4,e0 <strlen+0x14>
    ;
  return n;
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret
  for(n = 0; s[n]; n++)
  f2:	4501                	li	a0,0
  f4:	bfe5                	j	ec <strlen+0x20>

00000000000000f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fc:	ca19                	beqz	a2,112 <memset+0x1c>
  fe:	87aa                	mv	a5,a0
 100:	1602                	slli	a2,a2,0x20
 102:	9201                	srli	a2,a2,0x20
 104:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 108:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10c:	0785                	addi	a5,a5,1
 10e:	fee79de3          	bne	a5,a4,108 <memset+0x12>
  }
  return dst;
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strchr>:

char*
strchr(const char *s, char c)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e422                	sd	s0,8(sp)
 11c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 11e:	00054783          	lbu	a5,0(a0)
 122:	cb99                	beqz	a5,138 <strchr+0x20>
    if(*s == c)
 124:	00f58763          	beq	a1,a5,132 <strchr+0x1a>
  for(; *s; s++)
 128:	0505                	addi	a0,a0,1
 12a:	00054783          	lbu	a5,0(a0)
 12e:	fbfd                	bnez	a5,124 <strchr+0xc>
      return (char*)s;
  return 0;
 130:	4501                	li	a0,0
}
 132:	6422                	ld	s0,8(sp)
 134:	0141                	addi	sp,sp,16
 136:	8082                	ret
  return 0;
 138:	4501                	li	a0,0
 13a:	bfe5                	j	132 <strchr+0x1a>

000000000000013c <gets>:

char*
gets(char *buf, int max)
{
 13c:	711d                	addi	sp,sp,-96
 13e:	ec86                	sd	ra,88(sp)
 140:	e8a2                	sd	s0,80(sp)
 142:	e4a6                	sd	s1,72(sp)
 144:	e0ca                	sd	s2,64(sp)
 146:	fc4e                	sd	s3,56(sp)
 148:	f852                	sd	s4,48(sp)
 14a:	f456                	sd	s5,40(sp)
 14c:	f05a                	sd	s6,32(sp)
 14e:	ec5e                	sd	s7,24(sp)
 150:	1080                	addi	s0,sp,96
 152:	8baa                	mv	s7,a0
 154:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 156:	892a                	mv	s2,a0
 158:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 15a:	4aa9                	li	s5,10
 15c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 15e:	89a6                	mv	s3,s1
 160:	2485                	addiw	s1,s1,1
 162:	0344d863          	bge	s1,s4,192 <gets+0x56>
    cc = read(0, &c, 1);
 166:	4605                	li	a2,1
 168:	faf40593          	addi	a1,s0,-81
 16c:	4501                	li	a0,0
 16e:	00000097          	auipc	ra,0x0
 172:	2b8080e7          	jalr	696(ra) # 426 <read>
    if(cc < 1)
 176:	00a05e63          	blez	a0,192 <gets+0x56>
    buf[i++] = c;
 17a:	faf44783          	lbu	a5,-81(s0)
 17e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 182:	01578763          	beq	a5,s5,190 <gets+0x54>
 186:	0905                	addi	s2,s2,1
 188:	fd679be3          	bne	a5,s6,15e <gets+0x22>
  for(i=0; i+1 < max; ){
 18c:	89a6                	mv	s3,s1
 18e:	a011                	j	192 <gets+0x56>
 190:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 192:	99de                	add	s3,s3,s7
 194:	00098023          	sb	zero,0(s3)
  return buf;
}
 198:	855e                	mv	a0,s7
 19a:	60e6                	ld	ra,88(sp)
 19c:	6446                	ld	s0,80(sp)
 19e:	64a6                	ld	s1,72(sp)
 1a0:	6906                	ld	s2,64(sp)
 1a2:	79e2                	ld	s3,56(sp)
 1a4:	7a42                	ld	s4,48(sp)
 1a6:	7aa2                	ld	s5,40(sp)
 1a8:	7b02                	ld	s6,32(sp)
 1aa:	6be2                	ld	s7,24(sp)
 1ac:	6125                	addi	sp,sp,96
 1ae:	8082                	ret

00000000000001b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b0:	1101                	addi	sp,sp,-32
 1b2:	ec06                	sd	ra,24(sp)
 1b4:	e822                	sd	s0,16(sp)
 1b6:	e426                	sd	s1,8(sp)
 1b8:	e04a                	sd	s2,0(sp)
 1ba:	1000                	addi	s0,sp,32
 1bc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1be:	4581                	li	a1,0
 1c0:	00000097          	auipc	ra,0x0
 1c4:	28e080e7          	jalr	654(ra) # 44e <open>
  if(fd < 0)
 1c8:	02054563          	bltz	a0,1f2 <stat+0x42>
 1cc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ce:	85ca                	mv	a1,s2
 1d0:	00000097          	auipc	ra,0x0
 1d4:	296080e7          	jalr	662(ra) # 466 <fstat>
 1d8:	892a                	mv	s2,a0
  close(fd);
 1da:	8526                	mv	a0,s1
 1dc:	00000097          	auipc	ra,0x0
 1e0:	25a080e7          	jalr	602(ra) # 436 <close>
  return r;
}
 1e4:	854a                	mv	a0,s2
 1e6:	60e2                	ld	ra,24(sp)
 1e8:	6442                	ld	s0,16(sp)
 1ea:	64a2                	ld	s1,8(sp)
 1ec:	6902                	ld	s2,0(sp)
 1ee:	6105                	addi	sp,sp,32
 1f0:	8082                	ret
    return -1;
 1f2:	597d                	li	s2,-1
 1f4:	bfc5                	j	1e4 <stat+0x34>

00000000000001f6 <atoi>:

int
atoi(const char *s)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e422                	sd	s0,8(sp)
 1fa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1fc:	00054603          	lbu	a2,0(a0)
 200:	fd06079b          	addiw	a5,a2,-48
 204:	0ff7f793          	andi	a5,a5,255
 208:	4725                	li	a4,9
 20a:	02f76963          	bltu	a4,a5,23c <atoi+0x46>
 20e:	86aa                	mv	a3,a0
  n = 0;
 210:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 212:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 214:	0685                	addi	a3,a3,1
 216:	0025179b          	slliw	a5,a0,0x2
 21a:	9fa9                	addw	a5,a5,a0
 21c:	0017979b          	slliw	a5,a5,0x1
 220:	9fb1                	addw	a5,a5,a2
 222:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 226:	0006c603          	lbu	a2,0(a3)
 22a:	fd06071b          	addiw	a4,a2,-48
 22e:	0ff77713          	andi	a4,a4,255
 232:	fee5f1e3          	bgeu	a1,a4,214 <atoi+0x1e>
  return n;
}
 236:	6422                	ld	s0,8(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret
  n = 0;
 23c:	4501                	li	a0,0
 23e:	bfe5                	j	236 <atoi+0x40>

0000000000000240 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 240:	1141                	addi	sp,sp,-16
 242:	e422                	sd	s0,8(sp)
 244:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 246:	02b57463          	bgeu	a0,a1,26e <memmove+0x2e>
    while(n-- > 0)
 24a:	00c05f63          	blez	a2,268 <memmove+0x28>
 24e:	1602                	slli	a2,a2,0x20
 250:	9201                	srli	a2,a2,0x20
 252:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 256:	872a                	mv	a4,a0
      *dst++ = *src++;
 258:	0585                	addi	a1,a1,1
 25a:	0705                	addi	a4,a4,1
 25c:	fff5c683          	lbu	a3,-1(a1)
 260:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 264:	fee79ae3          	bne	a5,a4,258 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 268:	6422                	ld	s0,8(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret
    dst += n;
 26e:	00c50733          	add	a4,a0,a2
    src += n;
 272:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 274:	fec05ae3          	blez	a2,268 <memmove+0x28>
 278:	fff6079b          	addiw	a5,a2,-1
 27c:	1782                	slli	a5,a5,0x20
 27e:	9381                	srli	a5,a5,0x20
 280:	fff7c793          	not	a5,a5
 284:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 286:	15fd                	addi	a1,a1,-1
 288:	177d                	addi	a4,a4,-1
 28a:	0005c683          	lbu	a3,0(a1)
 28e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 292:	fee79ae3          	bne	a5,a4,286 <memmove+0x46>
 296:	bfc9                	j	268 <memmove+0x28>

0000000000000298 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 29e:	ca05                	beqz	a2,2ce <memcmp+0x36>
 2a0:	fff6069b          	addiw	a3,a2,-1
 2a4:	1682                	slli	a3,a3,0x20
 2a6:	9281                	srli	a3,a3,0x20
 2a8:	0685                	addi	a3,a3,1
 2aa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	0005c703          	lbu	a4,0(a1)
 2b4:	00e79863          	bne	a5,a4,2c4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2b8:	0505                	addi	a0,a0,1
    p2++;
 2ba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2bc:	fed518e3          	bne	a0,a3,2ac <memcmp+0x14>
  }
  return 0;
 2c0:	4501                	li	a0,0
 2c2:	a019                	j	2c8 <memcmp+0x30>
      return *p1 - *p2;
 2c4:	40e7853b          	subw	a0,a5,a4
}
 2c8:	6422                	ld	s0,8(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret
  return 0;
 2ce:	4501                	li	a0,0
 2d0:	bfe5                	j	2c8 <memcmp+0x30>

00000000000002d2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2da:	00000097          	auipc	ra,0x0
 2de:	f66080e7          	jalr	-154(ra) # 240 <memmove>
}
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <csem_down>:


void 
csem_down(struct counting_semaphore *sem) {
 2ea:	1101                	addi	sp,sp,-32
 2ec:	ec06                	sd	ra,24(sp)
 2ee:	e822                	sd	s0,16(sp)
 2f0:	e426                	sd	s1,8(sp)
 2f2:	1000                	addi	s0,sp,32
 2f4:	84aa                	mv	s1,a0
    bsem_down(sem->bsem2);
 2f6:	4148                	lw	a0,4(a0)
 2f8:	00000097          	auipc	ra,0x0
 2fc:	1ce080e7          	jalr	462(ra) # 4c6 <bsem_down>
    bsem_down(sem->bsem1);
 300:	4088                	lw	a0,0(s1)
 302:	00000097          	auipc	ra,0x0
 306:	1c4080e7          	jalr	452(ra) # 4c6 <bsem_down>
    sem->count -= 1;
 30a:	449c                	lw	a5,8(s1)
 30c:	37fd                	addiw	a5,a5,-1
 30e:	0007871b          	sext.w	a4,a5
 312:	c49c                	sw	a5,8(s1)
    if (sem->count > 0)
 314:	00e04c63          	bgtz	a4,32c <csem_down+0x42>
    	bsem_up(sem->bsem2);
    bsem_up(sem->bsem1);
 318:	4088                	lw	a0,0(s1)
 31a:	00000097          	auipc	ra,0x0
 31e:	1b4080e7          	jalr	436(ra) # 4ce <bsem_up>
}
 322:	60e2                	ld	ra,24(sp)
 324:	6442                	ld	s0,16(sp)
 326:	64a2                	ld	s1,8(sp)
 328:	6105                	addi	sp,sp,32
 32a:	8082                	ret
    	bsem_up(sem->bsem2);
 32c:	40c8                	lw	a0,4(s1)
 32e:	00000097          	auipc	ra,0x0
 332:	1a0080e7          	jalr	416(ra) # 4ce <bsem_up>
 336:	b7cd                	j	318 <csem_down+0x2e>

0000000000000338 <csem_up>:


void 
csem_up(struct counting_semaphore *sem) {
 338:	1101                	addi	sp,sp,-32
 33a:	ec06                	sd	ra,24(sp)
 33c:	e822                	sd	s0,16(sp)
 33e:	e426                	sd	s1,8(sp)
 340:	1000                	addi	s0,sp,32
 342:	84aa                	mv	s1,a0
	bsem_down(sem->bsem1);
 344:	4108                	lw	a0,0(a0)
 346:	00000097          	auipc	ra,0x0
 34a:	180080e7          	jalr	384(ra) # 4c6 <bsem_down>
	sem->count += 1;
 34e:	449c                	lw	a5,8(s1)
 350:	2785                	addiw	a5,a5,1
 352:	0007871b          	sext.w	a4,a5
 356:	c49c                	sw	a5,8(s1)
	if (sem->count == 1)
 358:	4785                	li	a5,1
 35a:	00f70c63          	beq	a4,a5,372 <csem_up+0x3a>
		bsem_up(sem->bsem2);
	bsem_up(sem->bsem1);
 35e:	4088                	lw	a0,0(s1)
 360:	00000097          	auipc	ra,0x0
 364:	16e080e7          	jalr	366(ra) # 4ce <bsem_up>
}
 368:	60e2                	ld	ra,24(sp)
 36a:	6442                	ld	s0,16(sp)
 36c:	64a2                	ld	s1,8(sp)
 36e:	6105                	addi	sp,sp,32
 370:	8082                	ret
		bsem_up(sem->bsem2);
 372:	40c8                	lw	a0,4(s1)
 374:	00000097          	auipc	ra,0x0
 378:	15a080e7          	jalr	346(ra) # 4ce <bsem_up>
 37c:	b7cd                	j	35e <csem_up+0x26>

000000000000037e <csem_alloc>:


int 
csem_alloc(struct counting_semaphore *sem, int count) {
 37e:	7179                	addi	sp,sp,-48
 380:	f406                	sd	ra,40(sp)
 382:	f022                	sd	s0,32(sp)
 384:	ec26                	sd	s1,24(sp)
 386:	e84a                	sd	s2,16(sp)
 388:	e44e                	sd	s3,8(sp)
 38a:	1800                	addi	s0,sp,48
 38c:	892a                	mv	s2,a0
 38e:	89ae                	mv	s3,a1
    int bsem1 = bsem_alloc();
 390:	00000097          	auipc	ra,0x0
 394:	14e080e7          	jalr	334(ra) # 4de <bsem_alloc>
 398:	84aa                	mv	s1,a0
    int bsem2 = bsem_alloc();
 39a:	00000097          	auipc	ra,0x0
 39e:	144080e7          	jalr	324(ra) # 4de <bsem_alloc>
    if (bsem1 == -1 || bsem2 == -1)
 3a2:	57fd                	li	a5,-1
 3a4:	00f48d63          	beq	s1,a5,3be <csem_alloc+0x40>
 3a8:	02f50863          	beq	a0,a5,3d8 <csem_alloc+0x5a>
        return -1; 
    sem->bsem1 = bsem1;
 3ac:	00992023          	sw	s1,0(s2)
    sem->bsem2 = bsem2;
 3b0:	00a92223          	sw	a0,4(s2)
    if (count == 0)
 3b4:	00098d63          	beqz	s3,3ce <csem_alloc+0x50>
        // Binary semaphore first value = min(1, count)
        bsem_down(sem->bsem2); 
    sem->count = count;
 3b8:	01392423          	sw	s3,8(s2)
    return 0;
 3bc:	4481                	li	s1,0
}
 3be:	8526                	mv	a0,s1
 3c0:	70a2                	ld	ra,40(sp)
 3c2:	7402                	ld	s0,32(sp)
 3c4:	64e2                	ld	s1,24(sp)
 3c6:	6942                	ld	s2,16(sp)
 3c8:	69a2                	ld	s3,8(sp)
 3ca:	6145                	addi	sp,sp,48
 3cc:	8082                	ret
        bsem_down(sem->bsem2); 
 3ce:	00000097          	auipc	ra,0x0
 3d2:	0f8080e7          	jalr	248(ra) # 4c6 <bsem_down>
 3d6:	b7cd                	j	3b8 <csem_alloc+0x3a>
        return -1; 
 3d8:	84aa                	mv	s1,a0
 3da:	b7d5                	j	3be <csem_alloc+0x40>

00000000000003dc <csem_free>:


void 
csem_free(struct counting_semaphore *sem) {
 3dc:	1101                	addi	sp,sp,-32
 3de:	ec06                	sd	ra,24(sp)
 3e0:	e822                	sd	s0,16(sp)
 3e2:	e426                	sd	s1,8(sp)
 3e4:	1000                	addi	s0,sp,32
 3e6:	84aa                	mv	s1,a0
    bsem_free(sem->bsem1);
 3e8:	4108                	lw	a0,0(a0)
 3ea:	00000097          	auipc	ra,0x0
 3ee:	0ec080e7          	jalr	236(ra) # 4d6 <bsem_free>
    bsem_free(sem->bsem2);
 3f2:	40c8                	lw	a0,4(s1)
 3f4:	00000097          	auipc	ra,0x0
 3f8:	0e2080e7          	jalr	226(ra) # 4d6 <bsem_free>
    //free(sem);
}
 3fc:	60e2                	ld	ra,24(sp)
 3fe:	6442                	ld	s0,16(sp)
 400:	64a2                	ld	s1,8(sp)
 402:	6105                	addi	sp,sp,32
 404:	8082                	ret

0000000000000406 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 406:	4885                	li	a7,1
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <exit>:
.global exit
exit:
 li a7, SYS_exit
 40e:	4889                	li	a7,2
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <wait>:
.global wait
wait:
 li a7, SYS_wait
 416:	488d                	li	a7,3
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 41e:	4891                	li	a7,4
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <read>:
.global read
read:
 li a7, SYS_read
 426:	4895                	li	a7,5
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <write>:
.global write
write:
 li a7, SYS_write
 42e:	48c1                	li	a7,16
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <close>:
.global close
close:
 li a7, SYS_close
 436:	48d5                	li	a7,21
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <kill>:
.global kill
kill:
 li a7, SYS_kill
 43e:	4899                	li	a7,6
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <exec>:
.global exec
exec:
 li a7, SYS_exec
 446:	489d                	li	a7,7
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <open>:
.global open
open:
 li a7, SYS_open
 44e:	48bd                	li	a7,15
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 456:	48c5                	li	a7,17
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 45e:	48c9                	li	a7,18
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 466:	48a1                	li	a7,8
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <link>:
.global link
link:
 li a7, SYS_link
 46e:	48cd                	li	a7,19
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 476:	48d1                	li	a7,20
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 47e:	48a5                	li	a7,9
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <dup>:
.global dup
dup:
 li a7, SYS_dup
 486:	48a9                	li	a7,10
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 48e:	48ad                	li	a7,11
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 496:	48b1                	li	a7,12
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 49e:	48b5                	li	a7,13
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4a6:	48b9                	li	a7,14
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 4ae:	48d9                	li	a7,22
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 4b6:	48dd                	li	a7,23
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 4be:	48e1                	li	a7,24
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
 4c6:	48ed                	li	a7,27
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
 4ce:	48f1                	li	a7,28
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
 4d6:	48e9                	li	a7,26
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
 4de:	48e5                	li	a7,25
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
 4e6:	48f5                	li	a7,29
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
 4ee:	48f9                	li	a7,30
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
 4f6:	48fd                	li	a7,31
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
 4fe:	02000893          	li	a7,32
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 508:	1101                	addi	sp,sp,-32
 50a:	ec06                	sd	ra,24(sp)
 50c:	e822                	sd	s0,16(sp)
 50e:	1000                	addi	s0,sp,32
 510:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 514:	4605                	li	a2,1
 516:	fef40593          	addi	a1,s0,-17
 51a:	00000097          	auipc	ra,0x0
 51e:	f14080e7          	jalr	-236(ra) # 42e <write>
}
 522:	60e2                	ld	ra,24(sp)
 524:	6442                	ld	s0,16(sp)
 526:	6105                	addi	sp,sp,32
 528:	8082                	ret

000000000000052a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 52a:	7139                	addi	sp,sp,-64
 52c:	fc06                	sd	ra,56(sp)
 52e:	f822                	sd	s0,48(sp)
 530:	f426                	sd	s1,40(sp)
 532:	f04a                	sd	s2,32(sp)
 534:	ec4e                	sd	s3,24(sp)
 536:	0080                	addi	s0,sp,64
 538:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 53a:	c299                	beqz	a3,540 <printint+0x16>
 53c:	0805c863          	bltz	a1,5cc <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 540:	2581                	sext.w	a1,a1
  neg = 0;
 542:	4881                	li	a7,0
 544:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 548:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 54a:	2601                	sext.w	a2,a2
 54c:	00000517          	auipc	a0,0x0
 550:	45450513          	addi	a0,a0,1108 # 9a0 <digits>
 554:	883a                	mv	a6,a4
 556:	2705                	addiw	a4,a4,1
 558:	02c5f7bb          	remuw	a5,a1,a2
 55c:	1782                	slli	a5,a5,0x20
 55e:	9381                	srli	a5,a5,0x20
 560:	97aa                	add	a5,a5,a0
 562:	0007c783          	lbu	a5,0(a5)
 566:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 56a:	0005879b          	sext.w	a5,a1
 56e:	02c5d5bb          	divuw	a1,a1,a2
 572:	0685                	addi	a3,a3,1
 574:	fec7f0e3          	bgeu	a5,a2,554 <printint+0x2a>
  if(neg)
 578:	00088b63          	beqz	a7,58e <printint+0x64>
    buf[i++] = '-';
 57c:	fd040793          	addi	a5,s0,-48
 580:	973e                	add	a4,a4,a5
 582:	02d00793          	li	a5,45
 586:	fef70823          	sb	a5,-16(a4)
 58a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 58e:	02e05863          	blez	a4,5be <printint+0x94>
 592:	fc040793          	addi	a5,s0,-64
 596:	00e78933          	add	s2,a5,a4
 59a:	fff78993          	addi	s3,a5,-1
 59e:	99ba                	add	s3,s3,a4
 5a0:	377d                	addiw	a4,a4,-1
 5a2:	1702                	slli	a4,a4,0x20
 5a4:	9301                	srli	a4,a4,0x20
 5a6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5aa:	fff94583          	lbu	a1,-1(s2)
 5ae:	8526                	mv	a0,s1
 5b0:	00000097          	auipc	ra,0x0
 5b4:	f58080e7          	jalr	-168(ra) # 508 <putc>
  while(--i >= 0)
 5b8:	197d                	addi	s2,s2,-1
 5ba:	ff3918e3          	bne	s2,s3,5aa <printint+0x80>
}
 5be:	70e2                	ld	ra,56(sp)
 5c0:	7442                	ld	s0,48(sp)
 5c2:	74a2                	ld	s1,40(sp)
 5c4:	7902                	ld	s2,32(sp)
 5c6:	69e2                	ld	s3,24(sp)
 5c8:	6121                	addi	sp,sp,64
 5ca:	8082                	ret
    x = -xx;
 5cc:	40b005bb          	negw	a1,a1
    neg = 1;
 5d0:	4885                	li	a7,1
    x = -xx;
 5d2:	bf8d                	j	544 <printint+0x1a>

00000000000005d4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5d4:	7119                	addi	sp,sp,-128
 5d6:	fc86                	sd	ra,120(sp)
 5d8:	f8a2                	sd	s0,112(sp)
 5da:	f4a6                	sd	s1,104(sp)
 5dc:	f0ca                	sd	s2,96(sp)
 5de:	ecce                	sd	s3,88(sp)
 5e0:	e8d2                	sd	s4,80(sp)
 5e2:	e4d6                	sd	s5,72(sp)
 5e4:	e0da                	sd	s6,64(sp)
 5e6:	fc5e                	sd	s7,56(sp)
 5e8:	f862                	sd	s8,48(sp)
 5ea:	f466                	sd	s9,40(sp)
 5ec:	f06a                	sd	s10,32(sp)
 5ee:	ec6e                	sd	s11,24(sp)
 5f0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5f2:	0005c903          	lbu	s2,0(a1)
 5f6:	18090f63          	beqz	s2,794 <vprintf+0x1c0>
 5fa:	8aaa                	mv	s5,a0
 5fc:	8b32                	mv	s6,a2
 5fe:	00158493          	addi	s1,a1,1
  state = 0;
 602:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 604:	02500a13          	li	s4,37
      if(c == 'd'){
 608:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 60c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 610:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 614:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 618:	00000b97          	auipc	s7,0x0
 61c:	388b8b93          	addi	s7,s7,904 # 9a0 <digits>
 620:	a839                	j	63e <vprintf+0x6a>
        putc(fd, c);
 622:	85ca                	mv	a1,s2
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	ee2080e7          	jalr	-286(ra) # 508 <putc>
 62e:	a019                	j	634 <vprintf+0x60>
    } else if(state == '%'){
 630:	01498f63          	beq	s3,s4,64e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 634:	0485                	addi	s1,s1,1
 636:	fff4c903          	lbu	s2,-1(s1)
 63a:	14090d63          	beqz	s2,794 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 63e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 642:	fe0997e3          	bnez	s3,630 <vprintf+0x5c>
      if(c == '%'){
 646:	fd479ee3          	bne	a5,s4,622 <vprintf+0x4e>
        state = '%';
 64a:	89be                	mv	s3,a5
 64c:	b7e5                	j	634 <vprintf+0x60>
      if(c == 'd'){
 64e:	05878063          	beq	a5,s8,68e <vprintf+0xba>
      } else if(c == 'l') {
 652:	05978c63          	beq	a5,s9,6aa <vprintf+0xd6>
      } else if(c == 'x') {
 656:	07a78863          	beq	a5,s10,6c6 <vprintf+0xf2>
      } else if(c == 'p') {
 65a:	09b78463          	beq	a5,s11,6e2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 65e:	07300713          	li	a4,115
 662:	0ce78663          	beq	a5,a4,72e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 666:	06300713          	li	a4,99
 66a:	0ee78e63          	beq	a5,a4,766 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 66e:	11478863          	beq	a5,s4,77e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 672:	85d2                	mv	a1,s4
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	e92080e7          	jalr	-366(ra) # 508 <putc>
        putc(fd, c);
 67e:	85ca                	mv	a1,s2
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	e86080e7          	jalr	-378(ra) # 508 <putc>
      }
      state = 0;
 68a:	4981                	li	s3,0
 68c:	b765                	j	634 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 68e:	008b0913          	addi	s2,s6,8
 692:	4685                	li	a3,1
 694:	4629                	li	a2,10
 696:	000b2583          	lw	a1,0(s6)
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	e8e080e7          	jalr	-370(ra) # 52a <printint>
 6a4:	8b4a                	mv	s6,s2
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	b771                	j	634 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6aa:	008b0913          	addi	s2,s6,8
 6ae:	4681                	li	a3,0
 6b0:	4629                	li	a2,10
 6b2:	000b2583          	lw	a1,0(s6)
 6b6:	8556                	mv	a0,s5
 6b8:	00000097          	auipc	ra,0x0
 6bc:	e72080e7          	jalr	-398(ra) # 52a <printint>
 6c0:	8b4a                	mv	s6,s2
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	bf85                	j	634 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6c6:	008b0913          	addi	s2,s6,8
 6ca:	4681                	li	a3,0
 6cc:	4641                	li	a2,16
 6ce:	000b2583          	lw	a1,0(s6)
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	e56080e7          	jalr	-426(ra) # 52a <printint>
 6dc:	8b4a                	mv	s6,s2
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	bf91                	j	634 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6e2:	008b0793          	addi	a5,s6,8
 6e6:	f8f43423          	sd	a5,-120(s0)
 6ea:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6ee:	03000593          	li	a1,48
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	e14080e7          	jalr	-492(ra) # 508 <putc>
  putc(fd, 'x');
 6fc:	85ea                	mv	a1,s10
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	e08080e7          	jalr	-504(ra) # 508 <putc>
 708:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 70a:	03c9d793          	srli	a5,s3,0x3c
 70e:	97de                	add	a5,a5,s7
 710:	0007c583          	lbu	a1,0(a5)
 714:	8556                	mv	a0,s5
 716:	00000097          	auipc	ra,0x0
 71a:	df2080e7          	jalr	-526(ra) # 508 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71e:	0992                	slli	s3,s3,0x4
 720:	397d                	addiw	s2,s2,-1
 722:	fe0914e3          	bnez	s2,70a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 726:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 72a:	4981                	li	s3,0
 72c:	b721                	j	634 <vprintf+0x60>
        s = va_arg(ap, char*);
 72e:	008b0993          	addi	s3,s6,8
 732:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 736:	02090163          	beqz	s2,758 <vprintf+0x184>
        while(*s != 0){
 73a:	00094583          	lbu	a1,0(s2)
 73e:	c9a1                	beqz	a1,78e <vprintf+0x1ba>
          putc(fd, *s);
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	dc6080e7          	jalr	-570(ra) # 508 <putc>
          s++;
 74a:	0905                	addi	s2,s2,1
        while(*s != 0){
 74c:	00094583          	lbu	a1,0(s2)
 750:	f9e5                	bnez	a1,740 <vprintf+0x16c>
        s = va_arg(ap, char*);
 752:	8b4e                	mv	s6,s3
      state = 0;
 754:	4981                	li	s3,0
 756:	bdf9                	j	634 <vprintf+0x60>
          s = "(null)";
 758:	00000917          	auipc	s2,0x0
 75c:	24090913          	addi	s2,s2,576 # 998 <malloc+0xfa>
        while(*s != 0){
 760:	02800593          	li	a1,40
 764:	bff1                	j	740 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 766:	008b0913          	addi	s2,s6,8
 76a:	000b4583          	lbu	a1,0(s6)
 76e:	8556                	mv	a0,s5
 770:	00000097          	auipc	ra,0x0
 774:	d98080e7          	jalr	-616(ra) # 508 <putc>
 778:	8b4a                	mv	s6,s2
      state = 0;
 77a:	4981                	li	s3,0
 77c:	bd65                	j	634 <vprintf+0x60>
        putc(fd, c);
 77e:	85d2                	mv	a1,s4
 780:	8556                	mv	a0,s5
 782:	00000097          	auipc	ra,0x0
 786:	d86080e7          	jalr	-634(ra) # 508 <putc>
      state = 0;
 78a:	4981                	li	s3,0
 78c:	b565                	j	634 <vprintf+0x60>
        s = va_arg(ap, char*);
 78e:	8b4e                	mv	s6,s3
      state = 0;
 790:	4981                	li	s3,0
 792:	b54d                	j	634 <vprintf+0x60>
    }
  }
}
 794:	70e6                	ld	ra,120(sp)
 796:	7446                	ld	s0,112(sp)
 798:	74a6                	ld	s1,104(sp)
 79a:	7906                	ld	s2,96(sp)
 79c:	69e6                	ld	s3,88(sp)
 79e:	6a46                	ld	s4,80(sp)
 7a0:	6aa6                	ld	s5,72(sp)
 7a2:	6b06                	ld	s6,64(sp)
 7a4:	7be2                	ld	s7,56(sp)
 7a6:	7c42                	ld	s8,48(sp)
 7a8:	7ca2                	ld	s9,40(sp)
 7aa:	7d02                	ld	s10,32(sp)
 7ac:	6de2                	ld	s11,24(sp)
 7ae:	6109                	addi	sp,sp,128
 7b0:	8082                	ret

00000000000007b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b2:	715d                	addi	sp,sp,-80
 7b4:	ec06                	sd	ra,24(sp)
 7b6:	e822                	sd	s0,16(sp)
 7b8:	1000                	addi	s0,sp,32
 7ba:	e010                	sd	a2,0(s0)
 7bc:	e414                	sd	a3,8(s0)
 7be:	e818                	sd	a4,16(s0)
 7c0:	ec1c                	sd	a5,24(s0)
 7c2:	03043023          	sd	a6,32(s0)
 7c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ce:	8622                	mv	a2,s0
 7d0:	00000097          	auipc	ra,0x0
 7d4:	e04080e7          	jalr	-508(ra) # 5d4 <vprintf>
}
 7d8:	60e2                	ld	ra,24(sp)
 7da:	6442                	ld	s0,16(sp)
 7dc:	6161                	addi	sp,sp,80
 7de:	8082                	ret

00000000000007e0 <printf>:

void
printf(const char *fmt, ...)
{
 7e0:	711d                	addi	sp,sp,-96
 7e2:	ec06                	sd	ra,24(sp)
 7e4:	e822                	sd	s0,16(sp)
 7e6:	1000                	addi	s0,sp,32
 7e8:	e40c                	sd	a1,8(s0)
 7ea:	e810                	sd	a2,16(s0)
 7ec:	ec14                	sd	a3,24(s0)
 7ee:	f018                	sd	a4,32(s0)
 7f0:	f41c                	sd	a5,40(s0)
 7f2:	03043823          	sd	a6,48(s0)
 7f6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7fa:	00840613          	addi	a2,s0,8
 7fe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 802:	85aa                	mv	a1,a0
 804:	4505                	li	a0,1
 806:	00000097          	auipc	ra,0x0
 80a:	dce080e7          	jalr	-562(ra) # 5d4 <vprintf>
}
 80e:	60e2                	ld	ra,24(sp)
 810:	6442                	ld	s0,16(sp)
 812:	6125                	addi	sp,sp,96
 814:	8082                	ret

0000000000000816 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 816:	1141                	addi	sp,sp,-16
 818:	e422                	sd	s0,8(sp)
 81a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 81c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 820:	00000797          	auipc	a5,0x0
 824:	1987b783          	ld	a5,408(a5) # 9b8 <freep>
 828:	a805                	j	858 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 82a:	4618                	lw	a4,8(a2)
 82c:	9db9                	addw	a1,a1,a4
 82e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 832:	6398                	ld	a4,0(a5)
 834:	6318                	ld	a4,0(a4)
 836:	fee53823          	sd	a4,-16(a0)
 83a:	a091                	j	87e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 83c:	ff852703          	lw	a4,-8(a0)
 840:	9e39                	addw	a2,a2,a4
 842:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 844:	ff053703          	ld	a4,-16(a0)
 848:	e398                	sd	a4,0(a5)
 84a:	a099                	j	890 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84c:	6398                	ld	a4,0(a5)
 84e:	00e7e463          	bltu	a5,a4,856 <free+0x40>
 852:	00e6ea63          	bltu	a3,a4,866 <free+0x50>
{
 856:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 858:	fed7fae3          	bgeu	a5,a3,84c <free+0x36>
 85c:	6398                	ld	a4,0(a5)
 85e:	00e6e463          	bltu	a3,a4,866 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 862:	fee7eae3          	bltu	a5,a4,856 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 866:	ff852583          	lw	a1,-8(a0)
 86a:	6390                	ld	a2,0(a5)
 86c:	02059813          	slli	a6,a1,0x20
 870:	01c85713          	srli	a4,a6,0x1c
 874:	9736                	add	a4,a4,a3
 876:	fae60ae3          	beq	a2,a4,82a <free+0x14>
    bp->s.ptr = p->s.ptr;
 87a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 87e:	4790                	lw	a2,8(a5)
 880:	02061593          	slli	a1,a2,0x20
 884:	01c5d713          	srli	a4,a1,0x1c
 888:	973e                	add	a4,a4,a5
 88a:	fae689e3          	beq	a3,a4,83c <free+0x26>
  } else
    p->s.ptr = bp;
 88e:	e394                	sd	a3,0(a5)
  freep = p;
 890:	00000717          	auipc	a4,0x0
 894:	12f73423          	sd	a5,296(a4) # 9b8 <freep>
}
 898:	6422                	ld	s0,8(sp)
 89a:	0141                	addi	sp,sp,16
 89c:	8082                	ret

000000000000089e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 89e:	7139                	addi	sp,sp,-64
 8a0:	fc06                	sd	ra,56(sp)
 8a2:	f822                	sd	s0,48(sp)
 8a4:	f426                	sd	s1,40(sp)
 8a6:	f04a                	sd	s2,32(sp)
 8a8:	ec4e                	sd	s3,24(sp)
 8aa:	e852                	sd	s4,16(sp)
 8ac:	e456                	sd	s5,8(sp)
 8ae:	e05a                	sd	s6,0(sp)
 8b0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b2:	02051493          	slli	s1,a0,0x20
 8b6:	9081                	srli	s1,s1,0x20
 8b8:	04bd                	addi	s1,s1,15
 8ba:	8091                	srli	s1,s1,0x4
 8bc:	0014899b          	addiw	s3,s1,1
 8c0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8c2:	00000517          	auipc	a0,0x0
 8c6:	0f653503          	ld	a0,246(a0) # 9b8 <freep>
 8ca:	c515                	beqz	a0,8f6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ce:	4798                	lw	a4,8(a5)
 8d0:	02977f63          	bgeu	a4,s1,90e <malloc+0x70>
 8d4:	8a4e                	mv	s4,s3
 8d6:	0009871b          	sext.w	a4,s3
 8da:	6685                	lui	a3,0x1
 8dc:	00d77363          	bgeu	a4,a3,8e2 <malloc+0x44>
 8e0:	6a05                	lui	s4,0x1
 8e2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ea:	00000917          	auipc	s2,0x0
 8ee:	0ce90913          	addi	s2,s2,206 # 9b8 <freep>
  if(p == (char*)-1)
 8f2:	5afd                	li	s5,-1
 8f4:	a895                	j	968 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8f6:	00000797          	auipc	a5,0x0
 8fa:	0ca78793          	addi	a5,a5,202 # 9c0 <base>
 8fe:	00000717          	auipc	a4,0x0
 902:	0af73d23          	sd	a5,186(a4) # 9b8 <freep>
 906:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 908:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 90c:	b7e1                	j	8d4 <malloc+0x36>
      if(p->s.size == nunits)
 90e:	02e48c63          	beq	s1,a4,946 <malloc+0xa8>
        p->s.size -= nunits;
 912:	4137073b          	subw	a4,a4,s3
 916:	c798                	sw	a4,8(a5)
        p += p->s.size;
 918:	02071693          	slli	a3,a4,0x20
 91c:	01c6d713          	srli	a4,a3,0x1c
 920:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 922:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 926:	00000717          	auipc	a4,0x0
 92a:	08a73923          	sd	a0,146(a4) # 9b8 <freep>
      return (void*)(p + 1);
 92e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 932:	70e2                	ld	ra,56(sp)
 934:	7442                	ld	s0,48(sp)
 936:	74a2                	ld	s1,40(sp)
 938:	7902                	ld	s2,32(sp)
 93a:	69e2                	ld	s3,24(sp)
 93c:	6a42                	ld	s4,16(sp)
 93e:	6aa2                	ld	s5,8(sp)
 940:	6b02                	ld	s6,0(sp)
 942:	6121                	addi	sp,sp,64
 944:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 946:	6398                	ld	a4,0(a5)
 948:	e118                	sd	a4,0(a0)
 94a:	bff1                	j	926 <malloc+0x88>
  hp->s.size = nu;
 94c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 950:	0541                	addi	a0,a0,16
 952:	00000097          	auipc	ra,0x0
 956:	ec4080e7          	jalr	-316(ra) # 816 <free>
  return freep;
 95a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 95e:	d971                	beqz	a0,932 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 960:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 962:	4798                	lw	a4,8(a5)
 964:	fa9775e3          	bgeu	a4,s1,90e <malloc+0x70>
    if(p == freep)
 968:	00093703          	ld	a4,0(s2)
 96c:	853e                	mv	a0,a5
 96e:	fef719e3          	bne	a4,a5,960 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 972:	8552                	mv	a0,s4
 974:	00000097          	auipc	ra,0x0
 978:	b22080e7          	jalr	-1246(ra) # 496 <sbrk>
  if(p == (char*)-1)
 97c:	fd5518e3          	bne	a0,s5,94c <malloc+0xae>
        return 0;
 980:	4501                	li	a0,0
 982:	bf45                	j	932 <malloc+0x94>
