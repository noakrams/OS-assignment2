
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	a8090913          	addi	s2,s2,-1408 # a90 <buf>
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	4a0080e7          	jalr	1184(ra) # 4c0 <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	494080e7          	jalr	1172(ra) # 4c8 <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	9e058593          	addi	a1,a1,-1568 # a20 <malloc+0xe8>
  48:	4509                	li	a0,2
  4a:	00001097          	auipc	ra,0x1
  4e:	802080e7          	jalr	-2046(ra) # 84c <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	454080e7          	jalr	1108(ra) # 4a8 <exit>
    }
  }
  if(n < 0){
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret
    fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	9ca58593          	addi	a1,a1,-1590 # a38 <malloc+0x100>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	7d4080e7          	jalr	2004(ra) # 84c <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	426080e7          	jalr	1062(ra) # 4a8 <exit>

000000000000008a <main>:

int
main(int argc, char *argv[])
{
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	ec26                	sd	s1,24(sp)
  92:	e84a                	sd	s2,16(sp)
  94:	e44e                	sd	s3,8(sp)
  96:	e052                	sd	s4,0(sp)
  98:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  9a:	4785                	li	a5,1
  9c:	04a7d763          	bge	a5,a0,ea <main+0x60>
  a0:	00858913          	addi	s2,a1,8
  a4:	ffe5099b          	addiw	s3,a0,-2
  a8:	02099793          	slli	a5,s3,0x20
  ac:	01d7d993          	srli	s3,a5,0x1d
  b0:	05c1                	addi	a1,a1,16
  b2:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b4:	4581                	li	a1,0
  b6:	00093503          	ld	a0,0(s2)
  ba:	00000097          	auipc	ra,0x0
  be:	42e080e7          	jalr	1070(ra) # 4e8 <open>
  c2:	84aa                	mv	s1,a0
  c4:	02054d63          	bltz	a0,fe <main+0x74>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c8:	00000097          	auipc	ra,0x0
  cc:	f38080e7          	jalr	-200(ra) # 0 <cat>
    close(fd);
  d0:	8526                	mv	a0,s1
  d2:	00000097          	auipc	ra,0x0
  d6:	3fe080e7          	jalr	1022(ra) # 4d0 <close>
  for(i = 1; i < argc; i++){
  da:	0921                	addi	s2,s2,8
  dc:	fd391ce3          	bne	s2,s3,b4 <main+0x2a>
  }
  exit(0);
  e0:	4501                	li	a0,0
  e2:	00000097          	auipc	ra,0x0
  e6:	3c6080e7          	jalr	966(ra) # 4a8 <exit>
    cat(0);
  ea:	4501                	li	a0,0
  ec:	00000097          	auipc	ra,0x0
  f0:	f14080e7          	jalr	-236(ra) # 0 <cat>
    exit(0);
  f4:	4501                	li	a0,0
  f6:	00000097          	auipc	ra,0x0
  fa:	3b2080e7          	jalr	946(ra) # 4a8 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  fe:	00093603          	ld	a2,0(s2)
 102:	00001597          	auipc	a1,0x1
 106:	94e58593          	addi	a1,a1,-1714 # a50 <malloc+0x118>
 10a:	4509                	li	a0,2
 10c:	00000097          	auipc	ra,0x0
 110:	740080e7          	jalr	1856(ra) # 84c <fprintf>
      exit(1);
 114:	4505                	li	a0,1
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

00000000000005a2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5a2:	1101                	addi	sp,sp,-32
 5a4:	ec06                	sd	ra,24(sp)
 5a6:	e822                	sd	s0,16(sp)
 5a8:	1000                	addi	s0,sp,32
 5aa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ae:	4605                	li	a2,1
 5b0:	fef40593          	addi	a1,s0,-17
 5b4:	00000097          	auipc	ra,0x0
 5b8:	f14080e7          	jalr	-236(ra) # 4c8 <write>
}
 5bc:	60e2                	ld	ra,24(sp)
 5be:	6442                	ld	s0,16(sp)
 5c0:	6105                	addi	sp,sp,32
 5c2:	8082                	ret

00000000000005c4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5c4:	7139                	addi	sp,sp,-64
 5c6:	fc06                	sd	ra,56(sp)
 5c8:	f822                	sd	s0,48(sp)
 5ca:	f426                	sd	s1,40(sp)
 5cc:	f04a                	sd	s2,32(sp)
 5ce:	ec4e                	sd	s3,24(sp)
 5d0:	0080                	addi	s0,sp,64
 5d2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5d4:	c299                	beqz	a3,5da <printint+0x16>
 5d6:	0805c863          	bltz	a1,666 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5da:	2581                	sext.w	a1,a1
  neg = 0;
 5dc:	4881                	li	a7,0
 5de:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5e2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5e4:	2601                	sext.w	a2,a2
 5e6:	00000517          	auipc	a0,0x0
 5ea:	48a50513          	addi	a0,a0,1162 # a70 <digits>
 5ee:	883a                	mv	a6,a4
 5f0:	2705                	addiw	a4,a4,1
 5f2:	02c5f7bb          	remuw	a5,a1,a2
 5f6:	1782                	slli	a5,a5,0x20
 5f8:	9381                	srli	a5,a5,0x20
 5fa:	97aa                	add	a5,a5,a0
 5fc:	0007c783          	lbu	a5,0(a5)
 600:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 604:	0005879b          	sext.w	a5,a1
 608:	02c5d5bb          	divuw	a1,a1,a2
 60c:	0685                	addi	a3,a3,1
 60e:	fec7f0e3          	bgeu	a5,a2,5ee <printint+0x2a>
  if(neg)
 612:	00088b63          	beqz	a7,628 <printint+0x64>
    buf[i++] = '-';
 616:	fd040793          	addi	a5,s0,-48
 61a:	973e                	add	a4,a4,a5
 61c:	02d00793          	li	a5,45
 620:	fef70823          	sb	a5,-16(a4)
 624:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 628:	02e05863          	blez	a4,658 <printint+0x94>
 62c:	fc040793          	addi	a5,s0,-64
 630:	00e78933          	add	s2,a5,a4
 634:	fff78993          	addi	s3,a5,-1
 638:	99ba                	add	s3,s3,a4
 63a:	377d                	addiw	a4,a4,-1
 63c:	1702                	slli	a4,a4,0x20
 63e:	9301                	srli	a4,a4,0x20
 640:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 644:	fff94583          	lbu	a1,-1(s2)
 648:	8526                	mv	a0,s1
 64a:	00000097          	auipc	ra,0x0
 64e:	f58080e7          	jalr	-168(ra) # 5a2 <putc>
  while(--i >= 0)
 652:	197d                	addi	s2,s2,-1
 654:	ff3918e3          	bne	s2,s3,644 <printint+0x80>
}
 658:	70e2                	ld	ra,56(sp)
 65a:	7442                	ld	s0,48(sp)
 65c:	74a2                	ld	s1,40(sp)
 65e:	7902                	ld	s2,32(sp)
 660:	69e2                	ld	s3,24(sp)
 662:	6121                	addi	sp,sp,64
 664:	8082                	ret
    x = -xx;
 666:	40b005bb          	negw	a1,a1
    neg = 1;
 66a:	4885                	li	a7,1
    x = -xx;
 66c:	bf8d                	j	5de <printint+0x1a>

000000000000066e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 66e:	7119                	addi	sp,sp,-128
 670:	fc86                	sd	ra,120(sp)
 672:	f8a2                	sd	s0,112(sp)
 674:	f4a6                	sd	s1,104(sp)
 676:	f0ca                	sd	s2,96(sp)
 678:	ecce                	sd	s3,88(sp)
 67a:	e8d2                	sd	s4,80(sp)
 67c:	e4d6                	sd	s5,72(sp)
 67e:	e0da                	sd	s6,64(sp)
 680:	fc5e                	sd	s7,56(sp)
 682:	f862                	sd	s8,48(sp)
 684:	f466                	sd	s9,40(sp)
 686:	f06a                	sd	s10,32(sp)
 688:	ec6e                	sd	s11,24(sp)
 68a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 68c:	0005c903          	lbu	s2,0(a1)
 690:	18090f63          	beqz	s2,82e <vprintf+0x1c0>
 694:	8aaa                	mv	s5,a0
 696:	8b32                	mv	s6,a2
 698:	00158493          	addi	s1,a1,1
  state = 0;
 69c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 69e:	02500a13          	li	s4,37
      if(c == 'd'){
 6a2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6a6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6aa:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6ae:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b2:	00000b97          	auipc	s7,0x0
 6b6:	3beb8b93          	addi	s7,s7,958 # a70 <digits>
 6ba:	a839                	j	6d8 <vprintf+0x6a>
        putc(fd, c);
 6bc:	85ca                	mv	a1,s2
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	ee2080e7          	jalr	-286(ra) # 5a2 <putc>
 6c8:	a019                	j	6ce <vprintf+0x60>
    } else if(state == '%'){
 6ca:	01498f63          	beq	s3,s4,6e8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6ce:	0485                	addi	s1,s1,1
 6d0:	fff4c903          	lbu	s2,-1(s1)
 6d4:	14090d63          	beqz	s2,82e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6d8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6dc:	fe0997e3          	bnez	s3,6ca <vprintf+0x5c>
      if(c == '%'){
 6e0:	fd479ee3          	bne	a5,s4,6bc <vprintf+0x4e>
        state = '%';
 6e4:	89be                	mv	s3,a5
 6e6:	b7e5                	j	6ce <vprintf+0x60>
      if(c == 'd'){
 6e8:	05878063          	beq	a5,s8,728 <vprintf+0xba>
      } else if(c == 'l') {
 6ec:	05978c63          	beq	a5,s9,744 <vprintf+0xd6>
      } else if(c == 'x') {
 6f0:	07a78863          	beq	a5,s10,760 <vprintf+0xf2>
      } else if(c == 'p') {
 6f4:	09b78463          	beq	a5,s11,77c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6f8:	07300713          	li	a4,115
 6fc:	0ce78663          	beq	a5,a4,7c8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 700:	06300713          	li	a4,99
 704:	0ee78e63          	beq	a5,a4,800 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 708:	11478863          	beq	a5,s4,818 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 70c:	85d2                	mv	a1,s4
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	e92080e7          	jalr	-366(ra) # 5a2 <putc>
        putc(fd, c);
 718:	85ca                	mv	a1,s2
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	e86080e7          	jalr	-378(ra) # 5a2 <putc>
      }
      state = 0;
 724:	4981                	li	s3,0
 726:	b765                	j	6ce <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 728:	008b0913          	addi	s2,s6,8
 72c:	4685                	li	a3,1
 72e:	4629                	li	a2,10
 730:	000b2583          	lw	a1,0(s6)
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	e8e080e7          	jalr	-370(ra) # 5c4 <printint>
 73e:	8b4a                	mv	s6,s2
      state = 0;
 740:	4981                	li	s3,0
 742:	b771                	j	6ce <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 744:	008b0913          	addi	s2,s6,8
 748:	4681                	li	a3,0
 74a:	4629                	li	a2,10
 74c:	000b2583          	lw	a1,0(s6)
 750:	8556                	mv	a0,s5
 752:	00000097          	auipc	ra,0x0
 756:	e72080e7          	jalr	-398(ra) # 5c4 <printint>
 75a:	8b4a                	mv	s6,s2
      state = 0;
 75c:	4981                	li	s3,0
 75e:	bf85                	j	6ce <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 760:	008b0913          	addi	s2,s6,8
 764:	4681                	li	a3,0
 766:	4641                	li	a2,16
 768:	000b2583          	lw	a1,0(s6)
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	e56080e7          	jalr	-426(ra) # 5c4 <printint>
 776:	8b4a                	mv	s6,s2
      state = 0;
 778:	4981                	li	s3,0
 77a:	bf91                	j	6ce <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 77c:	008b0793          	addi	a5,s6,8
 780:	f8f43423          	sd	a5,-120(s0)
 784:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 788:	03000593          	li	a1,48
 78c:	8556                	mv	a0,s5
 78e:	00000097          	auipc	ra,0x0
 792:	e14080e7          	jalr	-492(ra) # 5a2 <putc>
  putc(fd, 'x');
 796:	85ea                	mv	a1,s10
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	e08080e7          	jalr	-504(ra) # 5a2 <putc>
 7a2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7a4:	03c9d793          	srli	a5,s3,0x3c
 7a8:	97de                	add	a5,a5,s7
 7aa:	0007c583          	lbu	a1,0(a5)
 7ae:	8556                	mv	a0,s5
 7b0:	00000097          	auipc	ra,0x0
 7b4:	df2080e7          	jalr	-526(ra) # 5a2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b8:	0992                	slli	s3,s3,0x4
 7ba:	397d                	addiw	s2,s2,-1
 7bc:	fe0914e3          	bnez	s2,7a4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7c0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	b721                	j	6ce <vprintf+0x60>
        s = va_arg(ap, char*);
 7c8:	008b0993          	addi	s3,s6,8
 7cc:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7d0:	02090163          	beqz	s2,7f2 <vprintf+0x184>
        while(*s != 0){
 7d4:	00094583          	lbu	a1,0(s2)
 7d8:	c9a1                	beqz	a1,828 <vprintf+0x1ba>
          putc(fd, *s);
 7da:	8556                	mv	a0,s5
 7dc:	00000097          	auipc	ra,0x0
 7e0:	dc6080e7          	jalr	-570(ra) # 5a2 <putc>
          s++;
 7e4:	0905                	addi	s2,s2,1
        while(*s != 0){
 7e6:	00094583          	lbu	a1,0(s2)
 7ea:	f9e5                	bnez	a1,7da <vprintf+0x16c>
        s = va_arg(ap, char*);
 7ec:	8b4e                	mv	s6,s3
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	bdf9                	j	6ce <vprintf+0x60>
          s = "(null)";
 7f2:	00000917          	auipc	s2,0x0
 7f6:	27690913          	addi	s2,s2,630 # a68 <malloc+0x130>
        while(*s != 0){
 7fa:	02800593          	li	a1,40
 7fe:	bff1                	j	7da <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 800:	008b0913          	addi	s2,s6,8
 804:	000b4583          	lbu	a1,0(s6)
 808:	8556                	mv	a0,s5
 80a:	00000097          	auipc	ra,0x0
 80e:	d98080e7          	jalr	-616(ra) # 5a2 <putc>
 812:	8b4a                	mv	s6,s2
      state = 0;
 814:	4981                	li	s3,0
 816:	bd65                	j	6ce <vprintf+0x60>
        putc(fd, c);
 818:	85d2                	mv	a1,s4
 81a:	8556                	mv	a0,s5
 81c:	00000097          	auipc	ra,0x0
 820:	d86080e7          	jalr	-634(ra) # 5a2 <putc>
      state = 0;
 824:	4981                	li	s3,0
 826:	b565                	j	6ce <vprintf+0x60>
        s = va_arg(ap, char*);
 828:	8b4e                	mv	s6,s3
      state = 0;
 82a:	4981                	li	s3,0
 82c:	b54d                	j	6ce <vprintf+0x60>
    }
  }
}
 82e:	70e6                	ld	ra,120(sp)
 830:	7446                	ld	s0,112(sp)
 832:	74a6                	ld	s1,104(sp)
 834:	7906                	ld	s2,96(sp)
 836:	69e6                	ld	s3,88(sp)
 838:	6a46                	ld	s4,80(sp)
 83a:	6aa6                	ld	s5,72(sp)
 83c:	6b06                	ld	s6,64(sp)
 83e:	7be2                	ld	s7,56(sp)
 840:	7c42                	ld	s8,48(sp)
 842:	7ca2                	ld	s9,40(sp)
 844:	7d02                	ld	s10,32(sp)
 846:	6de2                	ld	s11,24(sp)
 848:	6109                	addi	sp,sp,128
 84a:	8082                	ret

000000000000084c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 84c:	715d                	addi	sp,sp,-80
 84e:	ec06                	sd	ra,24(sp)
 850:	e822                	sd	s0,16(sp)
 852:	1000                	addi	s0,sp,32
 854:	e010                	sd	a2,0(s0)
 856:	e414                	sd	a3,8(s0)
 858:	e818                	sd	a4,16(s0)
 85a:	ec1c                	sd	a5,24(s0)
 85c:	03043023          	sd	a6,32(s0)
 860:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 864:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 868:	8622                	mv	a2,s0
 86a:	00000097          	auipc	ra,0x0
 86e:	e04080e7          	jalr	-508(ra) # 66e <vprintf>
}
 872:	60e2                	ld	ra,24(sp)
 874:	6442                	ld	s0,16(sp)
 876:	6161                	addi	sp,sp,80
 878:	8082                	ret

000000000000087a <printf>:

void
printf(const char *fmt, ...)
{
 87a:	711d                	addi	sp,sp,-96
 87c:	ec06                	sd	ra,24(sp)
 87e:	e822                	sd	s0,16(sp)
 880:	1000                	addi	s0,sp,32
 882:	e40c                	sd	a1,8(s0)
 884:	e810                	sd	a2,16(s0)
 886:	ec14                	sd	a3,24(s0)
 888:	f018                	sd	a4,32(s0)
 88a:	f41c                	sd	a5,40(s0)
 88c:	03043823          	sd	a6,48(s0)
 890:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 894:	00840613          	addi	a2,s0,8
 898:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 89c:	85aa                	mv	a1,a0
 89e:	4505                	li	a0,1
 8a0:	00000097          	auipc	ra,0x0
 8a4:	dce080e7          	jalr	-562(ra) # 66e <vprintf>
}
 8a8:	60e2                	ld	ra,24(sp)
 8aa:	6442                	ld	s0,16(sp)
 8ac:	6125                	addi	sp,sp,96
 8ae:	8082                	ret

00000000000008b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b0:	1141                	addi	sp,sp,-16
 8b2:	e422                	sd	s0,8(sp)
 8b4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8b6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ba:	00000797          	auipc	a5,0x0
 8be:	1ce7b783          	ld	a5,462(a5) # a88 <freep>
 8c2:	a805                	j	8f2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8c4:	4618                	lw	a4,8(a2)
 8c6:	9db9                	addw	a1,a1,a4
 8c8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8cc:	6398                	ld	a4,0(a5)
 8ce:	6318                	ld	a4,0(a4)
 8d0:	fee53823          	sd	a4,-16(a0)
 8d4:	a091                	j	918 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8d6:	ff852703          	lw	a4,-8(a0)
 8da:	9e39                	addw	a2,a2,a4
 8dc:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8de:	ff053703          	ld	a4,-16(a0)
 8e2:	e398                	sd	a4,0(a5)
 8e4:	a099                	j	92a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e6:	6398                	ld	a4,0(a5)
 8e8:	00e7e463          	bltu	a5,a4,8f0 <free+0x40>
 8ec:	00e6ea63          	bltu	a3,a4,900 <free+0x50>
{
 8f0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f2:	fed7fae3          	bgeu	a5,a3,8e6 <free+0x36>
 8f6:	6398                	ld	a4,0(a5)
 8f8:	00e6e463          	bltu	a3,a4,900 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fc:	fee7eae3          	bltu	a5,a4,8f0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 900:	ff852583          	lw	a1,-8(a0)
 904:	6390                	ld	a2,0(a5)
 906:	02059813          	slli	a6,a1,0x20
 90a:	01c85713          	srli	a4,a6,0x1c
 90e:	9736                	add	a4,a4,a3
 910:	fae60ae3          	beq	a2,a4,8c4 <free+0x14>
    bp->s.ptr = p->s.ptr;
 914:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 918:	4790                	lw	a2,8(a5)
 91a:	02061593          	slli	a1,a2,0x20
 91e:	01c5d713          	srli	a4,a1,0x1c
 922:	973e                	add	a4,a4,a5
 924:	fae689e3          	beq	a3,a4,8d6 <free+0x26>
  } else
    p->s.ptr = bp;
 928:	e394                	sd	a3,0(a5)
  freep = p;
 92a:	00000717          	auipc	a4,0x0
 92e:	14f73f23          	sd	a5,350(a4) # a88 <freep>
}
 932:	6422                	ld	s0,8(sp)
 934:	0141                	addi	sp,sp,16
 936:	8082                	ret

0000000000000938 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 938:	7139                	addi	sp,sp,-64
 93a:	fc06                	sd	ra,56(sp)
 93c:	f822                	sd	s0,48(sp)
 93e:	f426                	sd	s1,40(sp)
 940:	f04a                	sd	s2,32(sp)
 942:	ec4e                	sd	s3,24(sp)
 944:	e852                	sd	s4,16(sp)
 946:	e456                	sd	s5,8(sp)
 948:	e05a                	sd	s6,0(sp)
 94a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 94c:	02051493          	slli	s1,a0,0x20
 950:	9081                	srli	s1,s1,0x20
 952:	04bd                	addi	s1,s1,15
 954:	8091                	srli	s1,s1,0x4
 956:	0014899b          	addiw	s3,s1,1
 95a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 95c:	00000517          	auipc	a0,0x0
 960:	12c53503          	ld	a0,300(a0) # a88 <freep>
 964:	c515                	beqz	a0,990 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 966:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 968:	4798                	lw	a4,8(a5)
 96a:	02977f63          	bgeu	a4,s1,9a8 <malloc+0x70>
 96e:	8a4e                	mv	s4,s3
 970:	0009871b          	sext.w	a4,s3
 974:	6685                	lui	a3,0x1
 976:	00d77363          	bgeu	a4,a3,97c <malloc+0x44>
 97a:	6a05                	lui	s4,0x1
 97c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 980:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 984:	00000917          	auipc	s2,0x0
 988:	10490913          	addi	s2,s2,260 # a88 <freep>
  if(p == (char*)-1)
 98c:	5afd                	li	s5,-1
 98e:	a895                	j	a02 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 990:	00000797          	auipc	a5,0x0
 994:	30078793          	addi	a5,a5,768 # c90 <base>
 998:	00000717          	auipc	a4,0x0
 99c:	0ef73823          	sd	a5,240(a4) # a88 <freep>
 9a0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9a2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9a6:	b7e1                	j	96e <malloc+0x36>
      if(p->s.size == nunits)
 9a8:	02e48c63          	beq	s1,a4,9e0 <malloc+0xa8>
        p->s.size -= nunits;
 9ac:	4137073b          	subw	a4,a4,s3
 9b0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9b2:	02071693          	slli	a3,a4,0x20
 9b6:	01c6d713          	srli	a4,a3,0x1c
 9ba:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9bc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9c0:	00000717          	auipc	a4,0x0
 9c4:	0ca73423          	sd	a0,200(a4) # a88 <freep>
      return (void*)(p + 1);
 9c8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9cc:	70e2                	ld	ra,56(sp)
 9ce:	7442                	ld	s0,48(sp)
 9d0:	74a2                	ld	s1,40(sp)
 9d2:	7902                	ld	s2,32(sp)
 9d4:	69e2                	ld	s3,24(sp)
 9d6:	6a42                	ld	s4,16(sp)
 9d8:	6aa2                	ld	s5,8(sp)
 9da:	6b02                	ld	s6,0(sp)
 9dc:	6121                	addi	sp,sp,64
 9de:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9e0:	6398                	ld	a4,0(a5)
 9e2:	e118                	sd	a4,0(a0)
 9e4:	bff1                	j	9c0 <malloc+0x88>
  hp->s.size = nu;
 9e6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9ea:	0541                	addi	a0,a0,16
 9ec:	00000097          	auipc	ra,0x0
 9f0:	ec4080e7          	jalr	-316(ra) # 8b0 <free>
  return freep;
 9f4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9f8:	d971                	beqz	a0,9cc <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9fc:	4798                	lw	a4,8(a5)
 9fe:	fa9775e3          	bgeu	a4,s1,9a8 <malloc+0x70>
    if(p == freep)
 a02:	00093703          	ld	a4,0(s2)
 a06:	853e                	mv	a0,a5
 a08:	fef719e3          	bne	a4,a5,9fa <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a0c:	8552                	mv	a0,s4
 a0e:	00000097          	auipc	ra,0x0
 a12:	b22080e7          	jalr	-1246(ra) # 530 <sbrk>
  if(p == (char*)-1)
 a16:	fd5518e3          	bne	a0,s5,9e6 <malloc+0xae>
        return 0;
 a1a:	4501                	li	a0,0
 a1c:	bf45                	j	9cc <malloc+0x94>
