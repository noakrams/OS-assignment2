
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  if(argc != 3){
   a:	478d                	li	a5,3
   c:	02f50063          	beq	a0,a5,2c <main+0x2c>
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	95058593          	addi	a1,a1,-1712 # 960 <malloc+0xe6>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	774080e7          	jalr	1908(ra) # 78e <fprintf>
    exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	3c6080e7          	jalr	966(ra) # 3ea <exit>
  2c:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  2e:	698c                	ld	a1,16(a1)
  30:	6488                	ld	a0,8(s1)
  32:	00000097          	auipc	ra,0x0
  36:	418080e7          	jalr	1048(ra) # 44a <link>
  3a:	00054763          	bltz	a0,48 <main+0x48>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	3aa080e7          	jalr	938(ra) # 3ea <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	6894                	ld	a3,16(s1)
  4a:	6490                	ld	a2,8(s1)
  4c:	00001597          	auipc	a1,0x1
  50:	92c58593          	addi	a1,a1,-1748 # 978 <malloc+0xfe>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	738080e7          	jalr	1848(ra) # 78e <fprintf>
  5e:	b7c5                	j	3e <main+0x3e>

0000000000000060 <strcpy>:
#include "kernel/Csemaphore.h"


char*
strcpy(char *s, const char *t)
{
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0x8>
    ;
  return os;
}
  76:	6422                	ld	s0,8(sp)
  78:	0141                	addi	sp,sp,16
  7a:	8082                	ret

000000000000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e422                	sd	s0,8(sp)
  80:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  82:	00054783          	lbu	a5,0(a0)
  86:	cb91                	beqz	a5,9a <strcmp+0x1e>
  88:	0005c703          	lbu	a4,0(a1)
  8c:	00f71763          	bne	a4,a5,9a <strcmp+0x1e>
    p++, q++;
  90:	0505                	addi	a0,a0,1
  92:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  94:	00054783          	lbu	a5,0(a0)
  98:	fbe5                	bnez	a5,88 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9a:	0005c503          	lbu	a0,0(a1)
}
  9e:	40a7853b          	subw	a0,a5,a0
  a2:	6422                	ld	s0,8(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret

00000000000000a8 <strlen>:

uint
strlen(const char *s)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	cf91                	beqz	a5,ce <strlen+0x26>
  b4:	0505                	addi	a0,a0,1
  b6:	87aa                	mv	a5,a0
  b8:	4685                	li	a3,1
  ba:	9e89                	subw	a3,a3,a0
  bc:	00f6853b          	addw	a0,a3,a5
  c0:	0785                	addi	a5,a5,1
  c2:	fff7c703          	lbu	a4,-1(a5)
  c6:	fb7d                	bnez	a4,bc <strlen+0x14>
    ;
  return n;
}
  c8:	6422                	ld	s0,8(sp)
  ca:	0141                	addi	sp,sp,16
  cc:	8082                	ret
  for(n = 0; s[n]; n++)
  ce:	4501                	li	a0,0
  d0:	bfe5                	j	c8 <strlen+0x20>

00000000000000d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d8:	ca19                	beqz	a2,ee <memset+0x1c>
  da:	87aa                	mv	a5,a0
  dc:	1602                	slli	a2,a2,0x20
  de:	9201                	srli	a2,a2,0x20
  e0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  e8:	0785                	addi	a5,a5,1
  ea:	fee79de3          	bne	a5,a4,e4 <memset+0x12>
  }
  return dst;
}
  ee:	6422                	ld	s0,8(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret

00000000000000f4 <strchr>:

char*
strchr(const char *s, char c)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  fa:	00054783          	lbu	a5,0(a0)
  fe:	cb99                	beqz	a5,114 <strchr+0x20>
    if(*s == c)
 100:	00f58763          	beq	a1,a5,10e <strchr+0x1a>
  for(; *s; s++)
 104:	0505                	addi	a0,a0,1
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbfd                	bnez	a5,100 <strchr+0xc>
      return (char*)s;
  return 0;
 10c:	4501                	li	a0,0
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret
  return 0;
 114:	4501                	li	a0,0
 116:	bfe5                	j	10e <strchr+0x1a>

0000000000000118 <gets>:

char*
gets(char *buf, int max)
{
 118:	711d                	addi	sp,sp,-96
 11a:	ec86                	sd	ra,88(sp)
 11c:	e8a2                	sd	s0,80(sp)
 11e:	e4a6                	sd	s1,72(sp)
 120:	e0ca                	sd	s2,64(sp)
 122:	fc4e                	sd	s3,56(sp)
 124:	f852                	sd	s4,48(sp)
 126:	f456                	sd	s5,40(sp)
 128:	f05a                	sd	s6,32(sp)
 12a:	ec5e                	sd	s7,24(sp)
 12c:	1080                	addi	s0,sp,96
 12e:	8baa                	mv	s7,a0
 130:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 132:	892a                	mv	s2,a0
 134:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 136:	4aa9                	li	s5,10
 138:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 13a:	89a6                	mv	s3,s1
 13c:	2485                	addiw	s1,s1,1
 13e:	0344d863          	bge	s1,s4,16e <gets+0x56>
    cc = read(0, &c, 1);
 142:	4605                	li	a2,1
 144:	faf40593          	addi	a1,s0,-81
 148:	4501                	li	a0,0
 14a:	00000097          	auipc	ra,0x0
 14e:	2b8080e7          	jalr	696(ra) # 402 <read>
    if(cc < 1)
 152:	00a05e63          	blez	a0,16e <gets+0x56>
    buf[i++] = c;
 156:	faf44783          	lbu	a5,-81(s0)
 15a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 15e:	01578763          	beq	a5,s5,16c <gets+0x54>
 162:	0905                	addi	s2,s2,1
 164:	fd679be3          	bne	a5,s6,13a <gets+0x22>
  for(i=0; i+1 < max; ){
 168:	89a6                	mv	s3,s1
 16a:	a011                	j	16e <gets+0x56>
 16c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 16e:	99de                	add	s3,s3,s7
 170:	00098023          	sb	zero,0(s3)
  return buf;
}
 174:	855e                	mv	a0,s7
 176:	60e6                	ld	ra,88(sp)
 178:	6446                	ld	s0,80(sp)
 17a:	64a6                	ld	s1,72(sp)
 17c:	6906                	ld	s2,64(sp)
 17e:	79e2                	ld	s3,56(sp)
 180:	7a42                	ld	s4,48(sp)
 182:	7aa2                	ld	s5,40(sp)
 184:	7b02                	ld	s6,32(sp)
 186:	6be2                	ld	s7,24(sp)
 188:	6125                	addi	sp,sp,96
 18a:	8082                	ret

000000000000018c <stat>:

int
stat(const char *n, struct stat *st)
{
 18c:	1101                	addi	sp,sp,-32
 18e:	ec06                	sd	ra,24(sp)
 190:	e822                	sd	s0,16(sp)
 192:	e426                	sd	s1,8(sp)
 194:	e04a                	sd	s2,0(sp)
 196:	1000                	addi	s0,sp,32
 198:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19a:	4581                	li	a1,0
 19c:	00000097          	auipc	ra,0x0
 1a0:	28e080e7          	jalr	654(ra) # 42a <open>
  if(fd < 0)
 1a4:	02054563          	bltz	a0,1ce <stat+0x42>
 1a8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1aa:	85ca                	mv	a1,s2
 1ac:	00000097          	auipc	ra,0x0
 1b0:	296080e7          	jalr	662(ra) # 442 <fstat>
 1b4:	892a                	mv	s2,a0
  close(fd);
 1b6:	8526                	mv	a0,s1
 1b8:	00000097          	auipc	ra,0x0
 1bc:	25a080e7          	jalr	602(ra) # 412 <close>
  return r;
}
 1c0:	854a                	mv	a0,s2
 1c2:	60e2                	ld	ra,24(sp)
 1c4:	6442                	ld	s0,16(sp)
 1c6:	64a2                	ld	s1,8(sp)
 1c8:	6902                	ld	s2,0(sp)
 1ca:	6105                	addi	sp,sp,32
 1cc:	8082                	ret
    return -1;
 1ce:	597d                	li	s2,-1
 1d0:	bfc5                	j	1c0 <stat+0x34>

00000000000001d2 <atoi>:

int
atoi(const char *s)
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e422                	sd	s0,8(sp)
 1d6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d8:	00054603          	lbu	a2,0(a0)
 1dc:	fd06079b          	addiw	a5,a2,-48
 1e0:	0ff7f793          	andi	a5,a5,255
 1e4:	4725                	li	a4,9
 1e6:	02f76963          	bltu	a4,a5,218 <atoi+0x46>
 1ea:	86aa                	mv	a3,a0
  n = 0;
 1ec:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1ee:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1f0:	0685                	addi	a3,a3,1
 1f2:	0025179b          	slliw	a5,a0,0x2
 1f6:	9fa9                	addw	a5,a5,a0
 1f8:	0017979b          	slliw	a5,a5,0x1
 1fc:	9fb1                	addw	a5,a5,a2
 1fe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 202:	0006c603          	lbu	a2,0(a3)
 206:	fd06071b          	addiw	a4,a2,-48
 20a:	0ff77713          	andi	a4,a4,255
 20e:	fee5f1e3          	bgeu	a1,a4,1f0 <atoi+0x1e>
  return n;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
  n = 0;
 218:	4501                	li	a0,0
 21a:	bfe5                	j	212 <atoi+0x40>

000000000000021c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 222:	02b57463          	bgeu	a0,a1,24a <memmove+0x2e>
    while(n-- > 0)
 226:	00c05f63          	blez	a2,244 <memmove+0x28>
 22a:	1602                	slli	a2,a2,0x20
 22c:	9201                	srli	a2,a2,0x20
 22e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 232:	872a                	mv	a4,a0
      *dst++ = *src++;
 234:	0585                	addi	a1,a1,1
 236:	0705                	addi	a4,a4,1
 238:	fff5c683          	lbu	a3,-1(a1)
 23c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 240:	fee79ae3          	bne	a5,a4,234 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
    dst += n;
 24a:	00c50733          	add	a4,a0,a2
    src += n;
 24e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 250:	fec05ae3          	blez	a2,244 <memmove+0x28>
 254:	fff6079b          	addiw	a5,a2,-1
 258:	1782                	slli	a5,a5,0x20
 25a:	9381                	srli	a5,a5,0x20
 25c:	fff7c793          	not	a5,a5
 260:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 262:	15fd                	addi	a1,a1,-1
 264:	177d                	addi	a4,a4,-1
 266:	0005c683          	lbu	a3,0(a1)
 26a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 26e:	fee79ae3          	bne	a5,a4,262 <memmove+0x46>
 272:	bfc9                	j	244 <memmove+0x28>

0000000000000274 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 274:	1141                	addi	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 27a:	ca05                	beqz	a2,2aa <memcmp+0x36>
 27c:	fff6069b          	addiw	a3,a2,-1
 280:	1682                	slli	a3,a3,0x20
 282:	9281                	srli	a3,a3,0x20
 284:	0685                	addi	a3,a3,1
 286:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 288:	00054783          	lbu	a5,0(a0)
 28c:	0005c703          	lbu	a4,0(a1)
 290:	00e79863          	bne	a5,a4,2a0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 294:	0505                	addi	a0,a0,1
    p2++;
 296:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 298:	fed518e3          	bne	a0,a3,288 <memcmp+0x14>
  }
  return 0;
 29c:	4501                	li	a0,0
 29e:	a019                	j	2a4 <memcmp+0x30>
      return *p1 - *p2;
 2a0:	40e7853b          	subw	a0,a5,a4
}
 2a4:	6422                	ld	s0,8(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret
  return 0;
 2aa:	4501                	li	a0,0
 2ac:	bfe5                	j	2a4 <memcmp+0x30>

00000000000002ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e406                	sd	ra,8(sp)
 2b2:	e022                	sd	s0,0(sp)
 2b4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2b6:	00000097          	auipc	ra,0x0
 2ba:	f66080e7          	jalr	-154(ra) # 21c <memmove>
}
 2be:	60a2                	ld	ra,8(sp)
 2c0:	6402                	ld	s0,0(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret

00000000000002c6 <csem_down>:


void 
csem_down(struct counting_semaphore *sem) {
 2c6:	1101                	addi	sp,sp,-32
 2c8:	ec06                	sd	ra,24(sp)
 2ca:	e822                	sd	s0,16(sp)
 2cc:	e426                	sd	s1,8(sp)
 2ce:	1000                	addi	s0,sp,32
 2d0:	84aa                	mv	s1,a0
    bsem_down(sem->bsem2);
 2d2:	4148                	lw	a0,4(a0)
 2d4:	00000097          	auipc	ra,0x0
 2d8:	1ce080e7          	jalr	462(ra) # 4a2 <bsem_down>
    bsem_down(sem->bsem1);
 2dc:	4088                	lw	a0,0(s1)
 2de:	00000097          	auipc	ra,0x0
 2e2:	1c4080e7          	jalr	452(ra) # 4a2 <bsem_down>
    sem->count -= 1;
 2e6:	449c                	lw	a5,8(s1)
 2e8:	37fd                	addiw	a5,a5,-1
 2ea:	0007871b          	sext.w	a4,a5
 2ee:	c49c                	sw	a5,8(s1)
    if (sem->count > 0)
 2f0:	00e04c63          	bgtz	a4,308 <csem_down+0x42>
    	bsem_up(sem->bsem2);
    bsem_up(sem->bsem1);
 2f4:	4088                	lw	a0,0(s1)
 2f6:	00000097          	auipc	ra,0x0
 2fa:	1b4080e7          	jalr	436(ra) # 4aa <bsem_up>
}
 2fe:	60e2                	ld	ra,24(sp)
 300:	6442                	ld	s0,16(sp)
 302:	64a2                	ld	s1,8(sp)
 304:	6105                	addi	sp,sp,32
 306:	8082                	ret
    	bsem_up(sem->bsem2);
 308:	40c8                	lw	a0,4(s1)
 30a:	00000097          	auipc	ra,0x0
 30e:	1a0080e7          	jalr	416(ra) # 4aa <bsem_up>
 312:	b7cd                	j	2f4 <csem_down+0x2e>

0000000000000314 <csem_up>:


void 
csem_up(struct counting_semaphore *sem) {
 314:	1101                	addi	sp,sp,-32
 316:	ec06                	sd	ra,24(sp)
 318:	e822                	sd	s0,16(sp)
 31a:	e426                	sd	s1,8(sp)
 31c:	1000                	addi	s0,sp,32
 31e:	84aa                	mv	s1,a0
	bsem_down(sem->bsem1);
 320:	4108                	lw	a0,0(a0)
 322:	00000097          	auipc	ra,0x0
 326:	180080e7          	jalr	384(ra) # 4a2 <bsem_down>
	sem->count += 1;
 32a:	449c                	lw	a5,8(s1)
 32c:	2785                	addiw	a5,a5,1
 32e:	0007871b          	sext.w	a4,a5
 332:	c49c                	sw	a5,8(s1)
	if (sem->count == 1)
 334:	4785                	li	a5,1
 336:	00f70c63          	beq	a4,a5,34e <csem_up+0x3a>
		bsem_up(sem->bsem2);
	bsem_up(sem->bsem1);
 33a:	4088                	lw	a0,0(s1)
 33c:	00000097          	auipc	ra,0x0
 340:	16e080e7          	jalr	366(ra) # 4aa <bsem_up>
}
 344:	60e2                	ld	ra,24(sp)
 346:	6442                	ld	s0,16(sp)
 348:	64a2                	ld	s1,8(sp)
 34a:	6105                	addi	sp,sp,32
 34c:	8082                	ret
		bsem_up(sem->bsem2);
 34e:	40c8                	lw	a0,4(s1)
 350:	00000097          	auipc	ra,0x0
 354:	15a080e7          	jalr	346(ra) # 4aa <bsem_up>
 358:	b7cd                	j	33a <csem_up+0x26>

000000000000035a <csem_alloc>:


int 
csem_alloc(struct counting_semaphore *sem, int count) {
 35a:	7179                	addi	sp,sp,-48
 35c:	f406                	sd	ra,40(sp)
 35e:	f022                	sd	s0,32(sp)
 360:	ec26                	sd	s1,24(sp)
 362:	e84a                	sd	s2,16(sp)
 364:	e44e                	sd	s3,8(sp)
 366:	1800                	addi	s0,sp,48
 368:	892a                	mv	s2,a0
 36a:	89ae                	mv	s3,a1
    int bsem1 = bsem_alloc();
 36c:	00000097          	auipc	ra,0x0
 370:	14e080e7          	jalr	334(ra) # 4ba <bsem_alloc>
 374:	84aa                	mv	s1,a0
    int bsem2 = bsem_alloc();
 376:	00000097          	auipc	ra,0x0
 37a:	144080e7          	jalr	324(ra) # 4ba <bsem_alloc>
    if (bsem1 == -1 || bsem2 == -1)
 37e:	57fd                	li	a5,-1
 380:	00f48d63          	beq	s1,a5,39a <csem_alloc+0x40>
 384:	02f50863          	beq	a0,a5,3b4 <csem_alloc+0x5a>
        return -1; 
    sem->bsem1 = bsem1;
 388:	00992023          	sw	s1,0(s2)
    sem->bsem2 = bsem2;
 38c:	00a92223          	sw	a0,4(s2)
    if (count == 0)
 390:	00098d63          	beqz	s3,3aa <csem_alloc+0x50>
        // Binary semaphore first value = min(1, count)
        bsem_down(sem->bsem2); 
    sem->count = count;
 394:	01392423          	sw	s3,8(s2)
    return 0;
 398:	4481                	li	s1,0
}
 39a:	8526                	mv	a0,s1
 39c:	70a2                	ld	ra,40(sp)
 39e:	7402                	ld	s0,32(sp)
 3a0:	64e2                	ld	s1,24(sp)
 3a2:	6942                	ld	s2,16(sp)
 3a4:	69a2                	ld	s3,8(sp)
 3a6:	6145                	addi	sp,sp,48
 3a8:	8082                	ret
        bsem_down(sem->bsem2); 
 3aa:	00000097          	auipc	ra,0x0
 3ae:	0f8080e7          	jalr	248(ra) # 4a2 <bsem_down>
 3b2:	b7cd                	j	394 <csem_alloc+0x3a>
        return -1; 
 3b4:	84aa                	mv	s1,a0
 3b6:	b7d5                	j	39a <csem_alloc+0x40>

00000000000003b8 <csem_free>:


void 
csem_free(struct counting_semaphore *sem) {
 3b8:	1101                	addi	sp,sp,-32
 3ba:	ec06                	sd	ra,24(sp)
 3bc:	e822                	sd	s0,16(sp)
 3be:	e426                	sd	s1,8(sp)
 3c0:	1000                	addi	s0,sp,32
 3c2:	84aa                	mv	s1,a0
    bsem_free(sem->bsem1);
 3c4:	4108                	lw	a0,0(a0)
 3c6:	00000097          	auipc	ra,0x0
 3ca:	0ec080e7          	jalr	236(ra) # 4b2 <bsem_free>
    bsem_free(sem->bsem2);
 3ce:	40c8                	lw	a0,4(s1)
 3d0:	00000097          	auipc	ra,0x0
 3d4:	0e2080e7          	jalr	226(ra) # 4b2 <bsem_free>
    //free(sem);
}
 3d8:	60e2                	ld	ra,24(sp)
 3da:	6442                	ld	s0,16(sp)
 3dc:	64a2                	ld	s1,8(sp)
 3de:	6105                	addi	sp,sp,32
 3e0:	8082                	ret

00000000000003e2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e2:	4885                	li	a7,1
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ea:	4889                	li	a7,2
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f2:	488d                	li	a7,3
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3fa:	4891                	li	a7,4
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <read>:
.global read
read:
 li a7, SYS_read
 402:	4895                	li	a7,5
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <write>:
.global write
write:
 li a7, SYS_write
 40a:	48c1                	li	a7,16
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <close>:
.global close
close:
 li a7, SYS_close
 412:	48d5                	li	a7,21
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <kill>:
.global kill
kill:
 li a7, SYS_kill
 41a:	4899                	li	a7,6
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <exec>:
.global exec
exec:
 li a7, SYS_exec
 422:	489d                	li	a7,7
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <open>:
.global open
open:
 li a7, SYS_open
 42a:	48bd                	li	a7,15
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 432:	48c5                	li	a7,17
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 43a:	48c9                	li	a7,18
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 442:	48a1                	li	a7,8
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <link>:
.global link
link:
 li a7, SYS_link
 44a:	48cd                	li	a7,19
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 452:	48d1                	li	a7,20
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 45a:	48a5                	li	a7,9
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <dup>:
.global dup
dup:
 li a7, SYS_dup
 462:	48a9                	li	a7,10
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 46a:	48ad                	li	a7,11
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 472:	48b1                	li	a7,12
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 47a:	48b5                	li	a7,13
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 482:	48b9                	li	a7,14
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 48a:	48d9                	li	a7,22
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 492:	48dd                	li	a7,23
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 49a:	48e1                	li	a7,24
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
 4a2:	48ed                	li	a7,27
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
 4aa:	48f1                	li	a7,28
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
 4b2:	48e9                	li	a7,26
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
 4ba:	48e5                	li	a7,25
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
 4c2:	48f5                	li	a7,29
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
 4ca:	48f9                	li	a7,30
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
 4d2:	48fd                	li	a7,31
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
 4da:	02000893          	li	a7,32
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4e4:	1101                	addi	sp,sp,-32
 4e6:	ec06                	sd	ra,24(sp)
 4e8:	e822                	sd	s0,16(sp)
 4ea:	1000                	addi	s0,sp,32
 4ec:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4f0:	4605                	li	a2,1
 4f2:	fef40593          	addi	a1,s0,-17
 4f6:	00000097          	auipc	ra,0x0
 4fa:	f14080e7          	jalr	-236(ra) # 40a <write>
}
 4fe:	60e2                	ld	ra,24(sp)
 500:	6442                	ld	s0,16(sp)
 502:	6105                	addi	sp,sp,32
 504:	8082                	ret

0000000000000506 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 506:	7139                	addi	sp,sp,-64
 508:	fc06                	sd	ra,56(sp)
 50a:	f822                	sd	s0,48(sp)
 50c:	f426                	sd	s1,40(sp)
 50e:	f04a                	sd	s2,32(sp)
 510:	ec4e                	sd	s3,24(sp)
 512:	0080                	addi	s0,sp,64
 514:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 516:	c299                	beqz	a3,51c <printint+0x16>
 518:	0805c863          	bltz	a1,5a8 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 51c:	2581                	sext.w	a1,a1
  neg = 0;
 51e:	4881                	li	a7,0
 520:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 524:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 526:	2601                	sext.w	a2,a2
 528:	00000517          	auipc	a0,0x0
 52c:	47050513          	addi	a0,a0,1136 # 998 <digits>
 530:	883a                	mv	a6,a4
 532:	2705                	addiw	a4,a4,1
 534:	02c5f7bb          	remuw	a5,a1,a2
 538:	1782                	slli	a5,a5,0x20
 53a:	9381                	srli	a5,a5,0x20
 53c:	97aa                	add	a5,a5,a0
 53e:	0007c783          	lbu	a5,0(a5)
 542:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 546:	0005879b          	sext.w	a5,a1
 54a:	02c5d5bb          	divuw	a1,a1,a2
 54e:	0685                	addi	a3,a3,1
 550:	fec7f0e3          	bgeu	a5,a2,530 <printint+0x2a>
  if(neg)
 554:	00088b63          	beqz	a7,56a <printint+0x64>
    buf[i++] = '-';
 558:	fd040793          	addi	a5,s0,-48
 55c:	973e                	add	a4,a4,a5
 55e:	02d00793          	li	a5,45
 562:	fef70823          	sb	a5,-16(a4)
 566:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 56a:	02e05863          	blez	a4,59a <printint+0x94>
 56e:	fc040793          	addi	a5,s0,-64
 572:	00e78933          	add	s2,a5,a4
 576:	fff78993          	addi	s3,a5,-1
 57a:	99ba                	add	s3,s3,a4
 57c:	377d                	addiw	a4,a4,-1
 57e:	1702                	slli	a4,a4,0x20
 580:	9301                	srli	a4,a4,0x20
 582:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 586:	fff94583          	lbu	a1,-1(s2)
 58a:	8526                	mv	a0,s1
 58c:	00000097          	auipc	ra,0x0
 590:	f58080e7          	jalr	-168(ra) # 4e4 <putc>
  while(--i >= 0)
 594:	197d                	addi	s2,s2,-1
 596:	ff3918e3          	bne	s2,s3,586 <printint+0x80>
}
 59a:	70e2                	ld	ra,56(sp)
 59c:	7442                	ld	s0,48(sp)
 59e:	74a2                	ld	s1,40(sp)
 5a0:	7902                	ld	s2,32(sp)
 5a2:	69e2                	ld	s3,24(sp)
 5a4:	6121                	addi	sp,sp,64
 5a6:	8082                	ret
    x = -xx;
 5a8:	40b005bb          	negw	a1,a1
    neg = 1;
 5ac:	4885                	li	a7,1
    x = -xx;
 5ae:	bf8d                	j	520 <printint+0x1a>

00000000000005b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5b0:	7119                	addi	sp,sp,-128
 5b2:	fc86                	sd	ra,120(sp)
 5b4:	f8a2                	sd	s0,112(sp)
 5b6:	f4a6                	sd	s1,104(sp)
 5b8:	f0ca                	sd	s2,96(sp)
 5ba:	ecce                	sd	s3,88(sp)
 5bc:	e8d2                	sd	s4,80(sp)
 5be:	e4d6                	sd	s5,72(sp)
 5c0:	e0da                	sd	s6,64(sp)
 5c2:	fc5e                	sd	s7,56(sp)
 5c4:	f862                	sd	s8,48(sp)
 5c6:	f466                	sd	s9,40(sp)
 5c8:	f06a                	sd	s10,32(sp)
 5ca:	ec6e                	sd	s11,24(sp)
 5cc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5ce:	0005c903          	lbu	s2,0(a1)
 5d2:	18090f63          	beqz	s2,770 <vprintf+0x1c0>
 5d6:	8aaa                	mv	s5,a0
 5d8:	8b32                	mv	s6,a2
 5da:	00158493          	addi	s1,a1,1
  state = 0;
 5de:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5e0:	02500a13          	li	s4,37
      if(c == 'd'){
 5e4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5e8:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5ec:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5f0:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f4:	00000b97          	auipc	s7,0x0
 5f8:	3a4b8b93          	addi	s7,s7,932 # 998 <digits>
 5fc:	a839                	j	61a <vprintf+0x6a>
        putc(fd, c);
 5fe:	85ca                	mv	a1,s2
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	ee2080e7          	jalr	-286(ra) # 4e4 <putc>
 60a:	a019                	j	610 <vprintf+0x60>
    } else if(state == '%'){
 60c:	01498f63          	beq	s3,s4,62a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 610:	0485                	addi	s1,s1,1
 612:	fff4c903          	lbu	s2,-1(s1)
 616:	14090d63          	beqz	s2,770 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 61a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 61e:	fe0997e3          	bnez	s3,60c <vprintf+0x5c>
      if(c == '%'){
 622:	fd479ee3          	bne	a5,s4,5fe <vprintf+0x4e>
        state = '%';
 626:	89be                	mv	s3,a5
 628:	b7e5                	j	610 <vprintf+0x60>
      if(c == 'd'){
 62a:	05878063          	beq	a5,s8,66a <vprintf+0xba>
      } else if(c == 'l') {
 62e:	05978c63          	beq	a5,s9,686 <vprintf+0xd6>
      } else if(c == 'x') {
 632:	07a78863          	beq	a5,s10,6a2 <vprintf+0xf2>
      } else if(c == 'p') {
 636:	09b78463          	beq	a5,s11,6be <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 63a:	07300713          	li	a4,115
 63e:	0ce78663          	beq	a5,a4,70a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 642:	06300713          	li	a4,99
 646:	0ee78e63          	beq	a5,a4,742 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 64a:	11478863          	beq	a5,s4,75a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 64e:	85d2                	mv	a1,s4
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	e92080e7          	jalr	-366(ra) # 4e4 <putc>
        putc(fd, c);
 65a:	85ca                	mv	a1,s2
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	e86080e7          	jalr	-378(ra) # 4e4 <putc>
      }
      state = 0;
 666:	4981                	li	s3,0
 668:	b765                	j	610 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 66a:	008b0913          	addi	s2,s6,8
 66e:	4685                	li	a3,1
 670:	4629                	li	a2,10
 672:	000b2583          	lw	a1,0(s6)
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	e8e080e7          	jalr	-370(ra) # 506 <printint>
 680:	8b4a                	mv	s6,s2
      state = 0;
 682:	4981                	li	s3,0
 684:	b771                	j	610 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 686:	008b0913          	addi	s2,s6,8
 68a:	4681                	li	a3,0
 68c:	4629                	li	a2,10
 68e:	000b2583          	lw	a1,0(s6)
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	e72080e7          	jalr	-398(ra) # 506 <printint>
 69c:	8b4a                	mv	s6,s2
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	bf85                	j	610 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6a2:	008b0913          	addi	s2,s6,8
 6a6:	4681                	li	a3,0
 6a8:	4641                	li	a2,16
 6aa:	000b2583          	lw	a1,0(s6)
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	e56080e7          	jalr	-426(ra) # 506 <printint>
 6b8:	8b4a                	mv	s6,s2
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	bf91                	j	610 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6be:	008b0793          	addi	a5,s6,8
 6c2:	f8f43423          	sd	a5,-120(s0)
 6c6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6ca:	03000593          	li	a1,48
 6ce:	8556                	mv	a0,s5
 6d0:	00000097          	auipc	ra,0x0
 6d4:	e14080e7          	jalr	-492(ra) # 4e4 <putc>
  putc(fd, 'x');
 6d8:	85ea                	mv	a1,s10
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	e08080e7          	jalr	-504(ra) # 4e4 <putc>
 6e4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e6:	03c9d793          	srli	a5,s3,0x3c
 6ea:	97de                	add	a5,a5,s7
 6ec:	0007c583          	lbu	a1,0(a5)
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	df2080e7          	jalr	-526(ra) # 4e4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6fa:	0992                	slli	s3,s3,0x4
 6fc:	397d                	addiw	s2,s2,-1
 6fe:	fe0914e3          	bnez	s2,6e6 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 702:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 706:	4981                	li	s3,0
 708:	b721                	j	610 <vprintf+0x60>
        s = va_arg(ap, char*);
 70a:	008b0993          	addi	s3,s6,8
 70e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 712:	02090163          	beqz	s2,734 <vprintf+0x184>
        while(*s != 0){
 716:	00094583          	lbu	a1,0(s2)
 71a:	c9a1                	beqz	a1,76a <vprintf+0x1ba>
          putc(fd, *s);
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	dc6080e7          	jalr	-570(ra) # 4e4 <putc>
          s++;
 726:	0905                	addi	s2,s2,1
        while(*s != 0){
 728:	00094583          	lbu	a1,0(s2)
 72c:	f9e5                	bnez	a1,71c <vprintf+0x16c>
        s = va_arg(ap, char*);
 72e:	8b4e                	mv	s6,s3
      state = 0;
 730:	4981                	li	s3,0
 732:	bdf9                	j	610 <vprintf+0x60>
          s = "(null)";
 734:	00000917          	auipc	s2,0x0
 738:	25c90913          	addi	s2,s2,604 # 990 <malloc+0x116>
        while(*s != 0){
 73c:	02800593          	li	a1,40
 740:	bff1                	j	71c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 742:	008b0913          	addi	s2,s6,8
 746:	000b4583          	lbu	a1,0(s6)
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	d98080e7          	jalr	-616(ra) # 4e4 <putc>
 754:	8b4a                	mv	s6,s2
      state = 0;
 756:	4981                	li	s3,0
 758:	bd65                	j	610 <vprintf+0x60>
        putc(fd, c);
 75a:	85d2                	mv	a1,s4
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	d86080e7          	jalr	-634(ra) # 4e4 <putc>
      state = 0;
 766:	4981                	li	s3,0
 768:	b565                	j	610 <vprintf+0x60>
        s = va_arg(ap, char*);
 76a:	8b4e                	mv	s6,s3
      state = 0;
 76c:	4981                	li	s3,0
 76e:	b54d                	j	610 <vprintf+0x60>
    }
  }
}
 770:	70e6                	ld	ra,120(sp)
 772:	7446                	ld	s0,112(sp)
 774:	74a6                	ld	s1,104(sp)
 776:	7906                	ld	s2,96(sp)
 778:	69e6                	ld	s3,88(sp)
 77a:	6a46                	ld	s4,80(sp)
 77c:	6aa6                	ld	s5,72(sp)
 77e:	6b06                	ld	s6,64(sp)
 780:	7be2                	ld	s7,56(sp)
 782:	7c42                	ld	s8,48(sp)
 784:	7ca2                	ld	s9,40(sp)
 786:	7d02                	ld	s10,32(sp)
 788:	6de2                	ld	s11,24(sp)
 78a:	6109                	addi	sp,sp,128
 78c:	8082                	ret

000000000000078e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 78e:	715d                	addi	sp,sp,-80
 790:	ec06                	sd	ra,24(sp)
 792:	e822                	sd	s0,16(sp)
 794:	1000                	addi	s0,sp,32
 796:	e010                	sd	a2,0(s0)
 798:	e414                	sd	a3,8(s0)
 79a:	e818                	sd	a4,16(s0)
 79c:	ec1c                	sd	a5,24(s0)
 79e:	03043023          	sd	a6,32(s0)
 7a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7aa:	8622                	mv	a2,s0
 7ac:	00000097          	auipc	ra,0x0
 7b0:	e04080e7          	jalr	-508(ra) # 5b0 <vprintf>
}
 7b4:	60e2                	ld	ra,24(sp)
 7b6:	6442                	ld	s0,16(sp)
 7b8:	6161                	addi	sp,sp,80
 7ba:	8082                	ret

00000000000007bc <printf>:

void
printf(const char *fmt, ...)
{
 7bc:	711d                	addi	sp,sp,-96
 7be:	ec06                	sd	ra,24(sp)
 7c0:	e822                	sd	s0,16(sp)
 7c2:	1000                	addi	s0,sp,32
 7c4:	e40c                	sd	a1,8(s0)
 7c6:	e810                	sd	a2,16(s0)
 7c8:	ec14                	sd	a3,24(s0)
 7ca:	f018                	sd	a4,32(s0)
 7cc:	f41c                	sd	a5,40(s0)
 7ce:	03043823          	sd	a6,48(s0)
 7d2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d6:	00840613          	addi	a2,s0,8
 7da:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7de:	85aa                	mv	a1,a0
 7e0:	4505                	li	a0,1
 7e2:	00000097          	auipc	ra,0x0
 7e6:	dce080e7          	jalr	-562(ra) # 5b0 <vprintf>
}
 7ea:	60e2                	ld	ra,24(sp)
 7ec:	6442                	ld	s0,16(sp)
 7ee:	6125                	addi	sp,sp,96
 7f0:	8082                	ret

00000000000007f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f2:	1141                	addi	sp,sp,-16
 7f4:	e422                	sd	s0,8(sp)
 7f6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fc:	00000797          	auipc	a5,0x0
 800:	1b47b783          	ld	a5,436(a5) # 9b0 <freep>
 804:	a805                	j	834 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 806:	4618                	lw	a4,8(a2)
 808:	9db9                	addw	a1,a1,a4
 80a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 80e:	6398                	ld	a4,0(a5)
 810:	6318                	ld	a4,0(a4)
 812:	fee53823          	sd	a4,-16(a0)
 816:	a091                	j	85a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 818:	ff852703          	lw	a4,-8(a0)
 81c:	9e39                	addw	a2,a2,a4
 81e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 820:	ff053703          	ld	a4,-16(a0)
 824:	e398                	sd	a4,0(a5)
 826:	a099                	j	86c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	6398                	ld	a4,0(a5)
 82a:	00e7e463          	bltu	a5,a4,832 <free+0x40>
 82e:	00e6ea63          	bltu	a3,a4,842 <free+0x50>
{
 832:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 834:	fed7fae3          	bgeu	a5,a3,828 <free+0x36>
 838:	6398                	ld	a4,0(a5)
 83a:	00e6e463          	bltu	a3,a4,842 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83e:	fee7eae3          	bltu	a5,a4,832 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 842:	ff852583          	lw	a1,-8(a0)
 846:	6390                	ld	a2,0(a5)
 848:	02059813          	slli	a6,a1,0x20
 84c:	01c85713          	srli	a4,a6,0x1c
 850:	9736                	add	a4,a4,a3
 852:	fae60ae3          	beq	a2,a4,806 <free+0x14>
    bp->s.ptr = p->s.ptr;
 856:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 85a:	4790                	lw	a2,8(a5)
 85c:	02061593          	slli	a1,a2,0x20
 860:	01c5d713          	srli	a4,a1,0x1c
 864:	973e                	add	a4,a4,a5
 866:	fae689e3          	beq	a3,a4,818 <free+0x26>
  } else
    p->s.ptr = bp;
 86a:	e394                	sd	a3,0(a5)
  freep = p;
 86c:	00000717          	auipc	a4,0x0
 870:	14f73223          	sd	a5,324(a4) # 9b0 <freep>
}
 874:	6422                	ld	s0,8(sp)
 876:	0141                	addi	sp,sp,16
 878:	8082                	ret

000000000000087a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 87a:	7139                	addi	sp,sp,-64
 87c:	fc06                	sd	ra,56(sp)
 87e:	f822                	sd	s0,48(sp)
 880:	f426                	sd	s1,40(sp)
 882:	f04a                	sd	s2,32(sp)
 884:	ec4e                	sd	s3,24(sp)
 886:	e852                	sd	s4,16(sp)
 888:	e456                	sd	s5,8(sp)
 88a:	e05a                	sd	s6,0(sp)
 88c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88e:	02051493          	slli	s1,a0,0x20
 892:	9081                	srli	s1,s1,0x20
 894:	04bd                	addi	s1,s1,15
 896:	8091                	srli	s1,s1,0x4
 898:	0014899b          	addiw	s3,s1,1
 89c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 89e:	00000517          	auipc	a0,0x0
 8a2:	11253503          	ld	a0,274(a0) # 9b0 <freep>
 8a6:	c515                	beqz	a0,8d2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8aa:	4798                	lw	a4,8(a5)
 8ac:	02977f63          	bgeu	a4,s1,8ea <malloc+0x70>
 8b0:	8a4e                	mv	s4,s3
 8b2:	0009871b          	sext.w	a4,s3
 8b6:	6685                	lui	a3,0x1
 8b8:	00d77363          	bgeu	a4,a3,8be <malloc+0x44>
 8bc:	6a05                	lui	s4,0x1
 8be:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c6:	00000917          	auipc	s2,0x0
 8ca:	0ea90913          	addi	s2,s2,234 # 9b0 <freep>
  if(p == (char*)-1)
 8ce:	5afd                	li	s5,-1
 8d0:	a895                	j	944 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8d2:	00000797          	auipc	a5,0x0
 8d6:	0e678793          	addi	a5,a5,230 # 9b8 <base>
 8da:	00000717          	auipc	a4,0x0
 8de:	0cf73b23          	sd	a5,214(a4) # 9b0 <freep>
 8e2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8e4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8e8:	b7e1                	j	8b0 <malloc+0x36>
      if(p->s.size == nunits)
 8ea:	02e48c63          	beq	s1,a4,922 <malloc+0xa8>
        p->s.size -= nunits;
 8ee:	4137073b          	subw	a4,a4,s3
 8f2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8f4:	02071693          	slli	a3,a4,0x20
 8f8:	01c6d713          	srli	a4,a3,0x1c
 8fc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8fe:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 902:	00000717          	auipc	a4,0x0
 906:	0aa73723          	sd	a0,174(a4) # 9b0 <freep>
      return (void*)(p + 1);
 90a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 90e:	70e2                	ld	ra,56(sp)
 910:	7442                	ld	s0,48(sp)
 912:	74a2                	ld	s1,40(sp)
 914:	7902                	ld	s2,32(sp)
 916:	69e2                	ld	s3,24(sp)
 918:	6a42                	ld	s4,16(sp)
 91a:	6aa2                	ld	s5,8(sp)
 91c:	6b02                	ld	s6,0(sp)
 91e:	6121                	addi	sp,sp,64
 920:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 922:	6398                	ld	a4,0(a5)
 924:	e118                	sd	a4,0(a0)
 926:	bff1                	j	902 <malloc+0x88>
  hp->s.size = nu;
 928:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 92c:	0541                	addi	a0,a0,16
 92e:	00000097          	auipc	ra,0x0
 932:	ec4080e7          	jalr	-316(ra) # 7f2 <free>
  return freep;
 936:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 93a:	d971                	beqz	a0,90e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93e:	4798                	lw	a4,8(a5)
 940:	fa9775e3          	bgeu	a4,s1,8ea <malloc+0x70>
    if(p == freep)
 944:	00093703          	ld	a4,0(s2)
 948:	853e                	mv	a0,a5
 94a:	fef719e3          	bne	a4,a5,93c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 94e:	8552                	mv	a0,s4
 950:	00000097          	auipc	ra,0x0
 954:	b22080e7          	jalr	-1246(ra) # 472 <sbrk>
  if(p == (char*)-1)
 958:	fd5518e3          	bne	a0,s5,928 <malloc+0xae>
        return 0;
 95c:	4501                	li	a0,0
 95e:	bf45                	j	90e <malloc+0x94>
