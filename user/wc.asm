
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	adbd8d93          	addi	s11,s11,-1317 # b09 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	a60a0a13          	addi	s4,s4,-1440 # a98 <malloc+0xe8>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1e4080e7          	jalr	484(ra) # 22a <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01248d63          	beq	s1,s2,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2b85                	addiw	s7,s7,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0997e3          	bnez	s3,52 <wc+0x52>
        w++;
  68:	2c05                	addiw	s8,s8,1
        inword = 1;
  6a:	4985                	li	s3,1
  6c:	b7dd                	j	52 <wc+0x52>
      c++;
  6e:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	00001597          	auipc	a1,0x1
  7a:	a9258593          	addi	a1,a1,-1390 # b08 <buf>
  7e:	f8843503          	ld	a0,-120(s0)
  82:	00000097          	auipc	ra,0x0
  86:	4b6080e7          	jalr	1206(ra) # 538 <read>
  8a:	00a05f63          	blez	a0,a8 <wc+0xa8>
    for(i=0; i<n; i++){
  8e:	00001497          	auipc	s1,0x1
  92:	a7a48493          	addi	s1,s1,-1414 # b08 <buf>
  96:	00050d1b          	sext.w	s10,a0
  9a:	fff5091b          	addiw	s2,a0,-1
  9e:	1902                	slli	s2,s2,0x20
  a0:	02095913          	srli	s2,s2,0x20
  a4:	996e                	add	s2,s2,s11
  a6:	bf4d                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  a8:	02054e63          	bltz	a0,e4 <wc+0xe4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  ac:	f8043703          	ld	a4,-128(s0)
  b0:	86e6                	mv	a3,s9
  b2:	8662                	mv	a2,s8
  b4:	85de                	mv	a1,s7
  b6:	00001517          	auipc	a0,0x1
  ba:	9fa50513          	addi	a0,a0,-1542 # ab0 <malloc+0x100>
  be:	00001097          	auipc	ra,0x1
  c2:	834080e7          	jalr	-1996(ra) # 8f2 <printf>
}
  c6:	70e6                	ld	ra,120(sp)
  c8:	7446                	ld	s0,112(sp)
  ca:	74a6                	ld	s1,104(sp)
  cc:	7906                	ld	s2,96(sp)
  ce:	69e6                	ld	s3,88(sp)
  d0:	6a46                	ld	s4,80(sp)
  d2:	6aa6                	ld	s5,72(sp)
  d4:	6b06                	ld	s6,64(sp)
  d6:	7be2                	ld	s7,56(sp)
  d8:	7c42                	ld	s8,48(sp)
  da:	7ca2                	ld	s9,40(sp)
  dc:	7d02                	ld	s10,32(sp)
  de:	6de2                	ld	s11,24(sp)
  e0:	6109                	addi	sp,sp,128
  e2:	8082                	ret
    printf("wc: read error\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	9bc50513          	addi	a0,a0,-1604 # aa0 <malloc+0xf0>
  ec:	00001097          	auipc	ra,0x1
  f0:	806080e7          	jalr	-2042(ra) # 8f2 <printf>
    exit(1);
  f4:	4505                	li	a0,1
  f6:	00000097          	auipc	ra,0x0
  fa:	42a080e7          	jalr	1066(ra) # 520 <exit>

00000000000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	7179                	addi	sp,sp,-48
 100:	f406                	sd	ra,40(sp)
 102:	f022                	sd	s0,32(sp)
 104:	ec26                	sd	s1,24(sp)
 106:	e84a                	sd	s2,16(sp)
 108:	e44e                	sd	s3,8(sp)
 10a:	e052                	sd	s4,0(sp)
 10c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
 10e:	4785                	li	a5,1
 110:	04a7d763          	bge	a5,a0,15e <main+0x60>
 114:	00858493          	addi	s1,a1,8
 118:	ffe5099b          	addiw	s3,a0,-2
 11c:	02099793          	slli	a5,s3,0x20
 120:	01d7d993          	srli	s3,a5,0x1d
 124:	05c1                	addi	a1,a1,16
 126:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 128:	4581                	li	a1,0
 12a:	6088                	ld	a0,0(s1)
 12c:	00000097          	auipc	ra,0x0
 130:	434080e7          	jalr	1076(ra) # 560 <open>
 134:	892a                	mv	s2,a0
 136:	04054263          	bltz	a0,17a <main+0x7c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 13a:	608c                	ld	a1,0(s1)
 13c:	00000097          	auipc	ra,0x0
 140:	ec4080e7          	jalr	-316(ra) # 0 <wc>
    close(fd);
 144:	854a                	mv	a0,s2
 146:	00000097          	auipc	ra,0x0
 14a:	402080e7          	jalr	1026(ra) # 548 <close>
  for(i = 1; i < argc; i++){
 14e:	04a1                	addi	s1,s1,8
 150:	fd349ce3          	bne	s1,s3,128 <main+0x2a>
  }
  exit(0);
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	3ca080e7          	jalr	970(ra) # 520 <exit>
    wc(0, "");
 15e:	00001597          	auipc	a1,0x1
 162:	96258593          	addi	a1,a1,-1694 # ac0 <malloc+0x110>
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	e98080e7          	jalr	-360(ra) # 0 <wc>
    exit(0);
 170:	4501                	li	a0,0
 172:	00000097          	auipc	ra,0x0
 176:	3ae080e7          	jalr	942(ra) # 520 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 17a:	608c                	ld	a1,0(s1)
 17c:	00001517          	auipc	a0,0x1
 180:	94c50513          	addi	a0,a0,-1716 # ac8 <malloc+0x118>
 184:	00000097          	auipc	ra,0x0
 188:	76e080e7          	jalr	1902(ra) # 8f2 <printf>
      exit(1);
 18c:	4505                	li	a0,1
 18e:	00000097          	auipc	ra,0x0
 192:	392080e7          	jalr	914(ra) # 520 <exit>

0000000000000196 <strcpy>:
#include "kernel/Csemaphore.h"


char*
strcpy(char *s, const char *t)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 19c:	87aa                	mv	a5,a0
 19e:	0585                	addi	a1,a1,1
 1a0:	0785                	addi	a5,a5,1
 1a2:	fff5c703          	lbu	a4,-1(a1)
 1a6:	fee78fa3          	sb	a4,-1(a5)
 1aa:	fb75                	bnez	a4,19e <strcpy+0x8>
    ;
  return os;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb91                	beqz	a5,1d0 <strcmp+0x1e>
 1be:	0005c703          	lbu	a4,0(a1)
 1c2:	00f71763          	bne	a4,a5,1d0 <strcmp+0x1e>
    p++, q++;
 1c6:	0505                	addi	a0,a0,1
 1c8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbe5                	bnez	a5,1be <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1d0:	0005c503          	lbu	a0,0(a1)
}
 1d4:	40a7853b          	subw	a0,a5,a0
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	addi	sp,sp,16
 1dc:	8082                	ret

00000000000001de <strlen>:

uint
strlen(const char *s)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e422                	sd	s0,8(sp)
 1e2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	cf91                	beqz	a5,204 <strlen+0x26>
 1ea:	0505                	addi	a0,a0,1
 1ec:	87aa                	mv	a5,a0
 1ee:	4685                	li	a3,1
 1f0:	9e89                	subw	a3,a3,a0
 1f2:	00f6853b          	addw	a0,a3,a5
 1f6:	0785                	addi	a5,a5,1
 1f8:	fff7c703          	lbu	a4,-1(a5)
 1fc:	fb7d                	bnez	a4,1f2 <strlen+0x14>
    ;
  return n;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret
  for(n = 0; s[n]; n++)
 204:	4501                	li	a0,0
 206:	bfe5                	j	1fe <strlen+0x20>

0000000000000208 <memset>:

void*
memset(void *dst, int c, uint n)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 20e:	ca19                	beqz	a2,224 <memset+0x1c>
 210:	87aa                	mv	a5,a0
 212:	1602                	slli	a2,a2,0x20
 214:	9201                	srli	a2,a2,0x20
 216:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 21a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 21e:	0785                	addi	a5,a5,1
 220:	fee79de3          	bne	a5,a4,21a <memset+0x12>
  }
  return dst;
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret

000000000000022a <strchr>:

char*
strchr(const char *s, char c)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e422                	sd	s0,8(sp)
 22e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 230:	00054783          	lbu	a5,0(a0)
 234:	cb99                	beqz	a5,24a <strchr+0x20>
    if(*s == c)
 236:	00f58763          	beq	a1,a5,244 <strchr+0x1a>
  for(; *s; s++)
 23a:	0505                	addi	a0,a0,1
 23c:	00054783          	lbu	a5,0(a0)
 240:	fbfd                	bnez	a5,236 <strchr+0xc>
      return (char*)s;
  return 0;
 242:	4501                	li	a0,0
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
  return 0;
 24a:	4501                	li	a0,0
 24c:	bfe5                	j	244 <strchr+0x1a>

000000000000024e <gets>:

char*
gets(char *buf, int max)
{
 24e:	711d                	addi	sp,sp,-96
 250:	ec86                	sd	ra,88(sp)
 252:	e8a2                	sd	s0,80(sp)
 254:	e4a6                	sd	s1,72(sp)
 256:	e0ca                	sd	s2,64(sp)
 258:	fc4e                	sd	s3,56(sp)
 25a:	f852                	sd	s4,48(sp)
 25c:	f456                	sd	s5,40(sp)
 25e:	f05a                	sd	s6,32(sp)
 260:	ec5e                	sd	s7,24(sp)
 262:	1080                	addi	s0,sp,96
 264:	8baa                	mv	s7,a0
 266:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 268:	892a                	mv	s2,a0
 26a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 26c:	4aa9                	li	s5,10
 26e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 270:	89a6                	mv	s3,s1
 272:	2485                	addiw	s1,s1,1
 274:	0344d863          	bge	s1,s4,2a4 <gets+0x56>
    cc = read(0, &c, 1);
 278:	4605                	li	a2,1
 27a:	faf40593          	addi	a1,s0,-81
 27e:	4501                	li	a0,0
 280:	00000097          	auipc	ra,0x0
 284:	2b8080e7          	jalr	696(ra) # 538 <read>
    if(cc < 1)
 288:	00a05e63          	blez	a0,2a4 <gets+0x56>
    buf[i++] = c;
 28c:	faf44783          	lbu	a5,-81(s0)
 290:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 294:	01578763          	beq	a5,s5,2a2 <gets+0x54>
 298:	0905                	addi	s2,s2,1
 29a:	fd679be3          	bne	a5,s6,270 <gets+0x22>
  for(i=0; i+1 < max; ){
 29e:	89a6                	mv	s3,s1
 2a0:	a011                	j	2a4 <gets+0x56>
 2a2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2a4:	99de                	add	s3,s3,s7
 2a6:	00098023          	sb	zero,0(s3)
  return buf;
}
 2aa:	855e                	mv	a0,s7
 2ac:	60e6                	ld	ra,88(sp)
 2ae:	6446                	ld	s0,80(sp)
 2b0:	64a6                	ld	s1,72(sp)
 2b2:	6906                	ld	s2,64(sp)
 2b4:	79e2                	ld	s3,56(sp)
 2b6:	7a42                	ld	s4,48(sp)
 2b8:	7aa2                	ld	s5,40(sp)
 2ba:	7b02                	ld	s6,32(sp)
 2bc:	6be2                	ld	s7,24(sp)
 2be:	6125                	addi	sp,sp,96
 2c0:	8082                	ret

00000000000002c2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c2:	1101                	addi	sp,sp,-32
 2c4:	ec06                	sd	ra,24(sp)
 2c6:	e822                	sd	s0,16(sp)
 2c8:	e426                	sd	s1,8(sp)
 2ca:	e04a                	sd	s2,0(sp)
 2cc:	1000                	addi	s0,sp,32
 2ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d0:	4581                	li	a1,0
 2d2:	00000097          	auipc	ra,0x0
 2d6:	28e080e7          	jalr	654(ra) # 560 <open>
  if(fd < 0)
 2da:	02054563          	bltz	a0,304 <stat+0x42>
 2de:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2e0:	85ca                	mv	a1,s2
 2e2:	00000097          	auipc	ra,0x0
 2e6:	296080e7          	jalr	662(ra) # 578 <fstat>
 2ea:	892a                	mv	s2,a0
  close(fd);
 2ec:	8526                	mv	a0,s1
 2ee:	00000097          	auipc	ra,0x0
 2f2:	25a080e7          	jalr	602(ra) # 548 <close>
  return r;
}
 2f6:	854a                	mv	a0,s2
 2f8:	60e2                	ld	ra,24(sp)
 2fa:	6442                	ld	s0,16(sp)
 2fc:	64a2                	ld	s1,8(sp)
 2fe:	6902                	ld	s2,0(sp)
 300:	6105                	addi	sp,sp,32
 302:	8082                	ret
    return -1;
 304:	597d                	li	s2,-1
 306:	bfc5                	j	2f6 <stat+0x34>

0000000000000308 <atoi>:

int
atoi(const char *s)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30e:	00054603          	lbu	a2,0(a0)
 312:	fd06079b          	addiw	a5,a2,-48
 316:	0ff7f793          	andi	a5,a5,255
 31a:	4725                	li	a4,9
 31c:	02f76963          	bltu	a4,a5,34e <atoi+0x46>
 320:	86aa                	mv	a3,a0
  n = 0;
 322:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 324:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 326:	0685                	addi	a3,a3,1
 328:	0025179b          	slliw	a5,a0,0x2
 32c:	9fa9                	addw	a5,a5,a0
 32e:	0017979b          	slliw	a5,a5,0x1
 332:	9fb1                	addw	a5,a5,a2
 334:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 338:	0006c603          	lbu	a2,0(a3)
 33c:	fd06071b          	addiw	a4,a2,-48
 340:	0ff77713          	andi	a4,a4,255
 344:	fee5f1e3          	bgeu	a1,a4,326 <atoi+0x1e>
  return n;
}
 348:	6422                	ld	s0,8(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret
  n = 0;
 34e:	4501                	li	a0,0
 350:	bfe5                	j	348 <atoi+0x40>

0000000000000352 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 352:	1141                	addi	sp,sp,-16
 354:	e422                	sd	s0,8(sp)
 356:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 358:	02b57463          	bgeu	a0,a1,380 <memmove+0x2e>
    while(n-- > 0)
 35c:	00c05f63          	blez	a2,37a <memmove+0x28>
 360:	1602                	slli	a2,a2,0x20
 362:	9201                	srli	a2,a2,0x20
 364:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 368:	872a                	mv	a4,a0
      *dst++ = *src++;
 36a:	0585                	addi	a1,a1,1
 36c:	0705                	addi	a4,a4,1
 36e:	fff5c683          	lbu	a3,-1(a1)
 372:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 376:	fee79ae3          	bne	a5,a4,36a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret
    dst += n;
 380:	00c50733          	add	a4,a0,a2
    src += n;
 384:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 386:	fec05ae3          	blez	a2,37a <memmove+0x28>
 38a:	fff6079b          	addiw	a5,a2,-1
 38e:	1782                	slli	a5,a5,0x20
 390:	9381                	srli	a5,a5,0x20
 392:	fff7c793          	not	a5,a5
 396:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 398:	15fd                	addi	a1,a1,-1
 39a:	177d                	addi	a4,a4,-1
 39c:	0005c683          	lbu	a3,0(a1)
 3a0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3a4:	fee79ae3          	bne	a5,a4,398 <memmove+0x46>
 3a8:	bfc9                	j	37a <memmove+0x28>

00000000000003aa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3aa:	1141                	addi	sp,sp,-16
 3ac:	e422                	sd	s0,8(sp)
 3ae:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3b0:	ca05                	beqz	a2,3e0 <memcmp+0x36>
 3b2:	fff6069b          	addiw	a3,a2,-1
 3b6:	1682                	slli	a3,a3,0x20
 3b8:	9281                	srli	a3,a3,0x20
 3ba:	0685                	addi	a3,a3,1
 3bc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3be:	00054783          	lbu	a5,0(a0)
 3c2:	0005c703          	lbu	a4,0(a1)
 3c6:	00e79863          	bne	a5,a4,3d6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3ca:	0505                	addi	a0,a0,1
    p2++;
 3cc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3ce:	fed518e3          	bne	a0,a3,3be <memcmp+0x14>
  }
  return 0;
 3d2:	4501                	li	a0,0
 3d4:	a019                	j	3da <memcmp+0x30>
      return *p1 - *p2;
 3d6:	40e7853b          	subw	a0,a5,a4
}
 3da:	6422                	ld	s0,8(sp)
 3dc:	0141                	addi	sp,sp,16
 3de:	8082                	ret
  return 0;
 3e0:	4501                	li	a0,0
 3e2:	bfe5                	j	3da <memcmp+0x30>

00000000000003e4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3e4:	1141                	addi	sp,sp,-16
 3e6:	e406                	sd	ra,8(sp)
 3e8:	e022                	sd	s0,0(sp)
 3ea:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ec:	00000097          	auipc	ra,0x0
 3f0:	f66080e7          	jalr	-154(ra) # 352 <memmove>
}
 3f4:	60a2                	ld	ra,8(sp)
 3f6:	6402                	ld	s0,0(sp)
 3f8:	0141                	addi	sp,sp,16
 3fa:	8082                	ret

00000000000003fc <csem_down>:


void 
csem_down(struct counting_semaphore *sem) {
 3fc:	1101                	addi	sp,sp,-32
 3fe:	ec06                	sd	ra,24(sp)
 400:	e822                	sd	s0,16(sp)
 402:	e426                	sd	s1,8(sp)
 404:	1000                	addi	s0,sp,32
 406:	84aa                	mv	s1,a0
    bsem_down(sem->bsem2);
 408:	4148                	lw	a0,4(a0)
 40a:	00000097          	auipc	ra,0x0
 40e:	1ce080e7          	jalr	462(ra) # 5d8 <bsem_down>
    bsem_down(sem->bsem1);
 412:	4088                	lw	a0,0(s1)
 414:	00000097          	auipc	ra,0x0
 418:	1c4080e7          	jalr	452(ra) # 5d8 <bsem_down>
    sem->count -= 1;
 41c:	449c                	lw	a5,8(s1)
 41e:	37fd                	addiw	a5,a5,-1
 420:	0007871b          	sext.w	a4,a5
 424:	c49c                	sw	a5,8(s1)
    if (sem->count > 0)
 426:	00e04c63          	bgtz	a4,43e <csem_down+0x42>
    	bsem_up(sem->bsem2);
    bsem_up(sem->bsem1);
 42a:	4088                	lw	a0,0(s1)
 42c:	00000097          	auipc	ra,0x0
 430:	1b4080e7          	jalr	436(ra) # 5e0 <bsem_up>
}
 434:	60e2                	ld	ra,24(sp)
 436:	6442                	ld	s0,16(sp)
 438:	64a2                	ld	s1,8(sp)
 43a:	6105                	addi	sp,sp,32
 43c:	8082                	ret
    	bsem_up(sem->bsem2);
 43e:	40c8                	lw	a0,4(s1)
 440:	00000097          	auipc	ra,0x0
 444:	1a0080e7          	jalr	416(ra) # 5e0 <bsem_up>
 448:	b7cd                	j	42a <csem_down+0x2e>

000000000000044a <csem_up>:


void 
csem_up(struct counting_semaphore *sem) {
 44a:	1101                	addi	sp,sp,-32
 44c:	ec06                	sd	ra,24(sp)
 44e:	e822                	sd	s0,16(sp)
 450:	e426                	sd	s1,8(sp)
 452:	1000                	addi	s0,sp,32
 454:	84aa                	mv	s1,a0
	bsem_down(sem->bsem1);
 456:	4108                	lw	a0,0(a0)
 458:	00000097          	auipc	ra,0x0
 45c:	180080e7          	jalr	384(ra) # 5d8 <bsem_down>
	sem->count += 1;
 460:	449c                	lw	a5,8(s1)
 462:	2785                	addiw	a5,a5,1
 464:	0007871b          	sext.w	a4,a5
 468:	c49c                	sw	a5,8(s1)
	if (sem->count == 1)
 46a:	4785                	li	a5,1
 46c:	00f70c63          	beq	a4,a5,484 <csem_up+0x3a>
		bsem_up(sem->bsem2);
	bsem_up(sem->bsem1);
 470:	4088                	lw	a0,0(s1)
 472:	00000097          	auipc	ra,0x0
 476:	16e080e7          	jalr	366(ra) # 5e0 <bsem_up>
}
 47a:	60e2                	ld	ra,24(sp)
 47c:	6442                	ld	s0,16(sp)
 47e:	64a2                	ld	s1,8(sp)
 480:	6105                	addi	sp,sp,32
 482:	8082                	ret
		bsem_up(sem->bsem2);
 484:	40c8                	lw	a0,4(s1)
 486:	00000097          	auipc	ra,0x0
 48a:	15a080e7          	jalr	346(ra) # 5e0 <bsem_up>
 48e:	b7cd                	j	470 <csem_up+0x26>

0000000000000490 <csem_alloc>:


int 
csem_alloc(struct counting_semaphore *sem, int count) {
 490:	7179                	addi	sp,sp,-48
 492:	f406                	sd	ra,40(sp)
 494:	f022                	sd	s0,32(sp)
 496:	ec26                	sd	s1,24(sp)
 498:	e84a                	sd	s2,16(sp)
 49a:	e44e                	sd	s3,8(sp)
 49c:	1800                	addi	s0,sp,48
 49e:	892a                	mv	s2,a0
 4a0:	89ae                	mv	s3,a1
    int bsem1 = bsem_alloc();
 4a2:	00000097          	auipc	ra,0x0
 4a6:	14e080e7          	jalr	334(ra) # 5f0 <bsem_alloc>
 4aa:	84aa                	mv	s1,a0
    int bsem2 = bsem_alloc();
 4ac:	00000097          	auipc	ra,0x0
 4b0:	144080e7          	jalr	324(ra) # 5f0 <bsem_alloc>
    if (bsem1 == -1 || bsem2 == -1)
 4b4:	57fd                	li	a5,-1
 4b6:	00f48d63          	beq	s1,a5,4d0 <csem_alloc+0x40>
 4ba:	02f50863          	beq	a0,a5,4ea <csem_alloc+0x5a>
        return -1; 
    sem->bsem1 = bsem1;
 4be:	00992023          	sw	s1,0(s2)
    sem->bsem2 = bsem2;
 4c2:	00a92223          	sw	a0,4(s2)
    if (count == 0)
 4c6:	00098d63          	beqz	s3,4e0 <csem_alloc+0x50>
        // Binary semaphore first value = min(1, count)
        bsem_down(sem->bsem2); 
    sem->count = count;
 4ca:	01392423          	sw	s3,8(s2)
    return 0;
 4ce:	4481                	li	s1,0
}
 4d0:	8526                	mv	a0,s1
 4d2:	70a2                	ld	ra,40(sp)
 4d4:	7402                	ld	s0,32(sp)
 4d6:	64e2                	ld	s1,24(sp)
 4d8:	6942                	ld	s2,16(sp)
 4da:	69a2                	ld	s3,8(sp)
 4dc:	6145                	addi	sp,sp,48
 4de:	8082                	ret
        bsem_down(sem->bsem2); 
 4e0:	00000097          	auipc	ra,0x0
 4e4:	0f8080e7          	jalr	248(ra) # 5d8 <bsem_down>
 4e8:	b7cd                	j	4ca <csem_alloc+0x3a>
        return -1; 
 4ea:	84aa                	mv	s1,a0
 4ec:	b7d5                	j	4d0 <csem_alloc+0x40>

00000000000004ee <csem_free>:


void 
csem_free(struct counting_semaphore *sem) {
 4ee:	1101                	addi	sp,sp,-32
 4f0:	ec06                	sd	ra,24(sp)
 4f2:	e822                	sd	s0,16(sp)
 4f4:	e426                	sd	s1,8(sp)
 4f6:	1000                	addi	s0,sp,32
 4f8:	84aa                	mv	s1,a0
    bsem_free(sem->bsem1);
 4fa:	4108                	lw	a0,0(a0)
 4fc:	00000097          	auipc	ra,0x0
 500:	0ec080e7          	jalr	236(ra) # 5e8 <bsem_free>
    bsem_free(sem->bsem2);
 504:	40c8                	lw	a0,4(s1)
 506:	00000097          	auipc	ra,0x0
 50a:	0e2080e7          	jalr	226(ra) # 5e8 <bsem_free>
    //free(sem);
}
 50e:	60e2                	ld	ra,24(sp)
 510:	6442                	ld	s0,16(sp)
 512:	64a2                	ld	s1,8(sp)
 514:	6105                	addi	sp,sp,32
 516:	8082                	ret

0000000000000518 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 518:	4885                	li	a7,1
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <exit>:
.global exit
exit:
 li a7, SYS_exit
 520:	4889                	li	a7,2
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <wait>:
.global wait
wait:
 li a7, SYS_wait
 528:	488d                	li	a7,3
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 530:	4891                	li	a7,4
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <read>:
.global read
read:
 li a7, SYS_read
 538:	4895                	li	a7,5
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <write>:
.global write
write:
 li a7, SYS_write
 540:	48c1                	li	a7,16
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <close>:
.global close
close:
 li a7, SYS_close
 548:	48d5                	li	a7,21
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <kill>:
.global kill
kill:
 li a7, SYS_kill
 550:	4899                	li	a7,6
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <exec>:
.global exec
exec:
 li a7, SYS_exec
 558:	489d                	li	a7,7
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <open>:
.global open
open:
 li a7, SYS_open
 560:	48bd                	li	a7,15
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 568:	48c5                	li	a7,17
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 570:	48c9                	li	a7,18
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 578:	48a1                	li	a7,8
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <link>:
.global link
link:
 li a7, SYS_link
 580:	48cd                	li	a7,19
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 588:	48d1                	li	a7,20
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 590:	48a5                	li	a7,9
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <dup>:
.global dup
dup:
 li a7, SYS_dup
 598:	48a9                	li	a7,10
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5a0:	48ad                	li	a7,11
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5a8:	48b1                	li	a7,12
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5b0:	48b5                	li	a7,13
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5b8:	48b9                	li	a7,14
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 5c0:	48d9                	li	a7,22
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 5c8:	48dd                	li	a7,23
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 5d0:	48e1                	li	a7,24
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
 5d8:	48ed                	li	a7,27
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
 5e0:	48f1                	li	a7,28
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
 5e8:	48e9                	li	a7,26
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
 5f0:	48e5                	li	a7,25
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
 5f8:	48f5                	li	a7,29
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
 600:	48f9                	li	a7,30
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
 608:	48fd                	li	a7,31
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
 610:	02000893          	li	a7,32
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 61a:	1101                	addi	sp,sp,-32
 61c:	ec06                	sd	ra,24(sp)
 61e:	e822                	sd	s0,16(sp)
 620:	1000                	addi	s0,sp,32
 622:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 626:	4605                	li	a2,1
 628:	fef40593          	addi	a1,s0,-17
 62c:	00000097          	auipc	ra,0x0
 630:	f14080e7          	jalr	-236(ra) # 540 <write>
}
 634:	60e2                	ld	ra,24(sp)
 636:	6442                	ld	s0,16(sp)
 638:	6105                	addi	sp,sp,32
 63a:	8082                	ret

000000000000063c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 63c:	7139                	addi	sp,sp,-64
 63e:	fc06                	sd	ra,56(sp)
 640:	f822                	sd	s0,48(sp)
 642:	f426                	sd	s1,40(sp)
 644:	f04a                	sd	s2,32(sp)
 646:	ec4e                	sd	s3,24(sp)
 648:	0080                	addi	s0,sp,64
 64a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 64c:	c299                	beqz	a3,652 <printint+0x16>
 64e:	0805c863          	bltz	a1,6de <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 652:	2581                	sext.w	a1,a1
  neg = 0;
 654:	4881                	li	a7,0
 656:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 65a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 65c:	2601                	sext.w	a2,a2
 65e:	00000517          	auipc	a0,0x0
 662:	48a50513          	addi	a0,a0,1162 # ae8 <digits>
 666:	883a                	mv	a6,a4
 668:	2705                	addiw	a4,a4,1
 66a:	02c5f7bb          	remuw	a5,a1,a2
 66e:	1782                	slli	a5,a5,0x20
 670:	9381                	srli	a5,a5,0x20
 672:	97aa                	add	a5,a5,a0
 674:	0007c783          	lbu	a5,0(a5)
 678:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 67c:	0005879b          	sext.w	a5,a1
 680:	02c5d5bb          	divuw	a1,a1,a2
 684:	0685                	addi	a3,a3,1
 686:	fec7f0e3          	bgeu	a5,a2,666 <printint+0x2a>
  if(neg)
 68a:	00088b63          	beqz	a7,6a0 <printint+0x64>
    buf[i++] = '-';
 68e:	fd040793          	addi	a5,s0,-48
 692:	973e                	add	a4,a4,a5
 694:	02d00793          	li	a5,45
 698:	fef70823          	sb	a5,-16(a4)
 69c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6a0:	02e05863          	blez	a4,6d0 <printint+0x94>
 6a4:	fc040793          	addi	a5,s0,-64
 6a8:	00e78933          	add	s2,a5,a4
 6ac:	fff78993          	addi	s3,a5,-1
 6b0:	99ba                	add	s3,s3,a4
 6b2:	377d                	addiw	a4,a4,-1
 6b4:	1702                	slli	a4,a4,0x20
 6b6:	9301                	srli	a4,a4,0x20
 6b8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6bc:	fff94583          	lbu	a1,-1(s2)
 6c0:	8526                	mv	a0,s1
 6c2:	00000097          	auipc	ra,0x0
 6c6:	f58080e7          	jalr	-168(ra) # 61a <putc>
  while(--i >= 0)
 6ca:	197d                	addi	s2,s2,-1
 6cc:	ff3918e3          	bne	s2,s3,6bc <printint+0x80>
}
 6d0:	70e2                	ld	ra,56(sp)
 6d2:	7442                	ld	s0,48(sp)
 6d4:	74a2                	ld	s1,40(sp)
 6d6:	7902                	ld	s2,32(sp)
 6d8:	69e2                	ld	s3,24(sp)
 6da:	6121                	addi	sp,sp,64
 6dc:	8082                	ret
    x = -xx;
 6de:	40b005bb          	negw	a1,a1
    neg = 1;
 6e2:	4885                	li	a7,1
    x = -xx;
 6e4:	bf8d                	j	656 <printint+0x1a>

00000000000006e6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6e6:	7119                	addi	sp,sp,-128
 6e8:	fc86                	sd	ra,120(sp)
 6ea:	f8a2                	sd	s0,112(sp)
 6ec:	f4a6                	sd	s1,104(sp)
 6ee:	f0ca                	sd	s2,96(sp)
 6f0:	ecce                	sd	s3,88(sp)
 6f2:	e8d2                	sd	s4,80(sp)
 6f4:	e4d6                	sd	s5,72(sp)
 6f6:	e0da                	sd	s6,64(sp)
 6f8:	fc5e                	sd	s7,56(sp)
 6fa:	f862                	sd	s8,48(sp)
 6fc:	f466                	sd	s9,40(sp)
 6fe:	f06a                	sd	s10,32(sp)
 700:	ec6e                	sd	s11,24(sp)
 702:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 704:	0005c903          	lbu	s2,0(a1)
 708:	18090f63          	beqz	s2,8a6 <vprintf+0x1c0>
 70c:	8aaa                	mv	s5,a0
 70e:	8b32                	mv	s6,a2
 710:	00158493          	addi	s1,a1,1
  state = 0;
 714:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 716:	02500a13          	li	s4,37
      if(c == 'd'){
 71a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 71e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 722:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 726:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 72a:	00000b97          	auipc	s7,0x0
 72e:	3beb8b93          	addi	s7,s7,958 # ae8 <digits>
 732:	a839                	j	750 <vprintf+0x6a>
        putc(fd, c);
 734:	85ca                	mv	a1,s2
 736:	8556                	mv	a0,s5
 738:	00000097          	auipc	ra,0x0
 73c:	ee2080e7          	jalr	-286(ra) # 61a <putc>
 740:	a019                	j	746 <vprintf+0x60>
    } else if(state == '%'){
 742:	01498f63          	beq	s3,s4,760 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 746:	0485                	addi	s1,s1,1
 748:	fff4c903          	lbu	s2,-1(s1)
 74c:	14090d63          	beqz	s2,8a6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 750:	0009079b          	sext.w	a5,s2
    if(state == 0){
 754:	fe0997e3          	bnez	s3,742 <vprintf+0x5c>
      if(c == '%'){
 758:	fd479ee3          	bne	a5,s4,734 <vprintf+0x4e>
        state = '%';
 75c:	89be                	mv	s3,a5
 75e:	b7e5                	j	746 <vprintf+0x60>
      if(c == 'd'){
 760:	05878063          	beq	a5,s8,7a0 <vprintf+0xba>
      } else if(c == 'l') {
 764:	05978c63          	beq	a5,s9,7bc <vprintf+0xd6>
      } else if(c == 'x') {
 768:	07a78863          	beq	a5,s10,7d8 <vprintf+0xf2>
      } else if(c == 'p') {
 76c:	09b78463          	beq	a5,s11,7f4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 770:	07300713          	li	a4,115
 774:	0ce78663          	beq	a5,a4,840 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 778:	06300713          	li	a4,99
 77c:	0ee78e63          	beq	a5,a4,878 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 780:	11478863          	beq	a5,s4,890 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 784:	85d2                	mv	a1,s4
 786:	8556                	mv	a0,s5
 788:	00000097          	auipc	ra,0x0
 78c:	e92080e7          	jalr	-366(ra) # 61a <putc>
        putc(fd, c);
 790:	85ca                	mv	a1,s2
 792:	8556                	mv	a0,s5
 794:	00000097          	auipc	ra,0x0
 798:	e86080e7          	jalr	-378(ra) # 61a <putc>
      }
      state = 0;
 79c:	4981                	li	s3,0
 79e:	b765                	j	746 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7a0:	008b0913          	addi	s2,s6,8
 7a4:	4685                	li	a3,1
 7a6:	4629                	li	a2,10
 7a8:	000b2583          	lw	a1,0(s6)
 7ac:	8556                	mv	a0,s5
 7ae:	00000097          	auipc	ra,0x0
 7b2:	e8e080e7          	jalr	-370(ra) # 63c <printint>
 7b6:	8b4a                	mv	s6,s2
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	b771                	j	746 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7bc:	008b0913          	addi	s2,s6,8
 7c0:	4681                	li	a3,0
 7c2:	4629                	li	a2,10
 7c4:	000b2583          	lw	a1,0(s6)
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	e72080e7          	jalr	-398(ra) # 63c <printint>
 7d2:	8b4a                	mv	s6,s2
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	bf85                	j	746 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7d8:	008b0913          	addi	s2,s6,8
 7dc:	4681                	li	a3,0
 7de:	4641                	li	a2,16
 7e0:	000b2583          	lw	a1,0(s6)
 7e4:	8556                	mv	a0,s5
 7e6:	00000097          	auipc	ra,0x0
 7ea:	e56080e7          	jalr	-426(ra) # 63c <printint>
 7ee:	8b4a                	mv	s6,s2
      state = 0;
 7f0:	4981                	li	s3,0
 7f2:	bf91                	j	746 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7f4:	008b0793          	addi	a5,s6,8
 7f8:	f8f43423          	sd	a5,-120(s0)
 7fc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 800:	03000593          	li	a1,48
 804:	8556                	mv	a0,s5
 806:	00000097          	auipc	ra,0x0
 80a:	e14080e7          	jalr	-492(ra) # 61a <putc>
  putc(fd, 'x');
 80e:	85ea                	mv	a1,s10
 810:	8556                	mv	a0,s5
 812:	00000097          	auipc	ra,0x0
 816:	e08080e7          	jalr	-504(ra) # 61a <putc>
 81a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 81c:	03c9d793          	srli	a5,s3,0x3c
 820:	97de                	add	a5,a5,s7
 822:	0007c583          	lbu	a1,0(a5)
 826:	8556                	mv	a0,s5
 828:	00000097          	auipc	ra,0x0
 82c:	df2080e7          	jalr	-526(ra) # 61a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 830:	0992                	slli	s3,s3,0x4
 832:	397d                	addiw	s2,s2,-1
 834:	fe0914e3          	bnez	s2,81c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 838:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 83c:	4981                	li	s3,0
 83e:	b721                	j	746 <vprintf+0x60>
        s = va_arg(ap, char*);
 840:	008b0993          	addi	s3,s6,8
 844:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 848:	02090163          	beqz	s2,86a <vprintf+0x184>
        while(*s != 0){
 84c:	00094583          	lbu	a1,0(s2)
 850:	c9a1                	beqz	a1,8a0 <vprintf+0x1ba>
          putc(fd, *s);
 852:	8556                	mv	a0,s5
 854:	00000097          	auipc	ra,0x0
 858:	dc6080e7          	jalr	-570(ra) # 61a <putc>
          s++;
 85c:	0905                	addi	s2,s2,1
        while(*s != 0){
 85e:	00094583          	lbu	a1,0(s2)
 862:	f9e5                	bnez	a1,852 <vprintf+0x16c>
        s = va_arg(ap, char*);
 864:	8b4e                	mv	s6,s3
      state = 0;
 866:	4981                	li	s3,0
 868:	bdf9                	j	746 <vprintf+0x60>
          s = "(null)";
 86a:	00000917          	auipc	s2,0x0
 86e:	27690913          	addi	s2,s2,630 # ae0 <malloc+0x130>
        while(*s != 0){
 872:	02800593          	li	a1,40
 876:	bff1                	j	852 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 878:	008b0913          	addi	s2,s6,8
 87c:	000b4583          	lbu	a1,0(s6)
 880:	8556                	mv	a0,s5
 882:	00000097          	auipc	ra,0x0
 886:	d98080e7          	jalr	-616(ra) # 61a <putc>
 88a:	8b4a                	mv	s6,s2
      state = 0;
 88c:	4981                	li	s3,0
 88e:	bd65                	j	746 <vprintf+0x60>
        putc(fd, c);
 890:	85d2                	mv	a1,s4
 892:	8556                	mv	a0,s5
 894:	00000097          	auipc	ra,0x0
 898:	d86080e7          	jalr	-634(ra) # 61a <putc>
      state = 0;
 89c:	4981                	li	s3,0
 89e:	b565                	j	746 <vprintf+0x60>
        s = va_arg(ap, char*);
 8a0:	8b4e                	mv	s6,s3
      state = 0;
 8a2:	4981                	li	s3,0
 8a4:	b54d                	j	746 <vprintf+0x60>
    }
  }
}
 8a6:	70e6                	ld	ra,120(sp)
 8a8:	7446                	ld	s0,112(sp)
 8aa:	74a6                	ld	s1,104(sp)
 8ac:	7906                	ld	s2,96(sp)
 8ae:	69e6                	ld	s3,88(sp)
 8b0:	6a46                	ld	s4,80(sp)
 8b2:	6aa6                	ld	s5,72(sp)
 8b4:	6b06                	ld	s6,64(sp)
 8b6:	7be2                	ld	s7,56(sp)
 8b8:	7c42                	ld	s8,48(sp)
 8ba:	7ca2                	ld	s9,40(sp)
 8bc:	7d02                	ld	s10,32(sp)
 8be:	6de2                	ld	s11,24(sp)
 8c0:	6109                	addi	sp,sp,128
 8c2:	8082                	ret

00000000000008c4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8c4:	715d                	addi	sp,sp,-80
 8c6:	ec06                	sd	ra,24(sp)
 8c8:	e822                	sd	s0,16(sp)
 8ca:	1000                	addi	s0,sp,32
 8cc:	e010                	sd	a2,0(s0)
 8ce:	e414                	sd	a3,8(s0)
 8d0:	e818                	sd	a4,16(s0)
 8d2:	ec1c                	sd	a5,24(s0)
 8d4:	03043023          	sd	a6,32(s0)
 8d8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8dc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8e0:	8622                	mv	a2,s0
 8e2:	00000097          	auipc	ra,0x0
 8e6:	e04080e7          	jalr	-508(ra) # 6e6 <vprintf>
}
 8ea:	60e2                	ld	ra,24(sp)
 8ec:	6442                	ld	s0,16(sp)
 8ee:	6161                	addi	sp,sp,80
 8f0:	8082                	ret

00000000000008f2 <printf>:

void
printf(const char *fmt, ...)
{
 8f2:	711d                	addi	sp,sp,-96
 8f4:	ec06                	sd	ra,24(sp)
 8f6:	e822                	sd	s0,16(sp)
 8f8:	1000                	addi	s0,sp,32
 8fa:	e40c                	sd	a1,8(s0)
 8fc:	e810                	sd	a2,16(s0)
 8fe:	ec14                	sd	a3,24(s0)
 900:	f018                	sd	a4,32(s0)
 902:	f41c                	sd	a5,40(s0)
 904:	03043823          	sd	a6,48(s0)
 908:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 90c:	00840613          	addi	a2,s0,8
 910:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 914:	85aa                	mv	a1,a0
 916:	4505                	li	a0,1
 918:	00000097          	auipc	ra,0x0
 91c:	dce080e7          	jalr	-562(ra) # 6e6 <vprintf>
}
 920:	60e2                	ld	ra,24(sp)
 922:	6442                	ld	s0,16(sp)
 924:	6125                	addi	sp,sp,96
 926:	8082                	ret

0000000000000928 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 928:	1141                	addi	sp,sp,-16
 92a:	e422                	sd	s0,8(sp)
 92c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 92e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 932:	00000797          	auipc	a5,0x0
 936:	1ce7b783          	ld	a5,462(a5) # b00 <freep>
 93a:	a805                	j	96a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 93c:	4618                	lw	a4,8(a2)
 93e:	9db9                	addw	a1,a1,a4
 940:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 944:	6398                	ld	a4,0(a5)
 946:	6318                	ld	a4,0(a4)
 948:	fee53823          	sd	a4,-16(a0)
 94c:	a091                	j	990 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 94e:	ff852703          	lw	a4,-8(a0)
 952:	9e39                	addw	a2,a2,a4
 954:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 956:	ff053703          	ld	a4,-16(a0)
 95a:	e398                	sd	a4,0(a5)
 95c:	a099                	j	9a2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95e:	6398                	ld	a4,0(a5)
 960:	00e7e463          	bltu	a5,a4,968 <free+0x40>
 964:	00e6ea63          	bltu	a3,a4,978 <free+0x50>
{
 968:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96a:	fed7fae3          	bgeu	a5,a3,95e <free+0x36>
 96e:	6398                	ld	a4,0(a5)
 970:	00e6e463          	bltu	a3,a4,978 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 974:	fee7eae3          	bltu	a5,a4,968 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 978:	ff852583          	lw	a1,-8(a0)
 97c:	6390                	ld	a2,0(a5)
 97e:	02059813          	slli	a6,a1,0x20
 982:	01c85713          	srli	a4,a6,0x1c
 986:	9736                	add	a4,a4,a3
 988:	fae60ae3          	beq	a2,a4,93c <free+0x14>
    bp->s.ptr = p->s.ptr;
 98c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 990:	4790                	lw	a2,8(a5)
 992:	02061593          	slli	a1,a2,0x20
 996:	01c5d713          	srli	a4,a1,0x1c
 99a:	973e                	add	a4,a4,a5
 99c:	fae689e3          	beq	a3,a4,94e <free+0x26>
  } else
    p->s.ptr = bp;
 9a0:	e394                	sd	a3,0(a5)
  freep = p;
 9a2:	00000717          	auipc	a4,0x0
 9a6:	14f73f23          	sd	a5,350(a4) # b00 <freep>
}
 9aa:	6422                	ld	s0,8(sp)
 9ac:	0141                	addi	sp,sp,16
 9ae:	8082                	ret

00000000000009b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9b0:	7139                	addi	sp,sp,-64
 9b2:	fc06                	sd	ra,56(sp)
 9b4:	f822                	sd	s0,48(sp)
 9b6:	f426                	sd	s1,40(sp)
 9b8:	f04a                	sd	s2,32(sp)
 9ba:	ec4e                	sd	s3,24(sp)
 9bc:	e852                	sd	s4,16(sp)
 9be:	e456                	sd	s5,8(sp)
 9c0:	e05a                	sd	s6,0(sp)
 9c2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c4:	02051493          	slli	s1,a0,0x20
 9c8:	9081                	srli	s1,s1,0x20
 9ca:	04bd                	addi	s1,s1,15
 9cc:	8091                	srli	s1,s1,0x4
 9ce:	0014899b          	addiw	s3,s1,1
 9d2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9d4:	00000517          	auipc	a0,0x0
 9d8:	12c53503          	ld	a0,300(a0) # b00 <freep>
 9dc:	c515                	beqz	a0,a08 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9de:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e0:	4798                	lw	a4,8(a5)
 9e2:	02977f63          	bgeu	a4,s1,a20 <malloc+0x70>
 9e6:	8a4e                	mv	s4,s3
 9e8:	0009871b          	sext.w	a4,s3
 9ec:	6685                	lui	a3,0x1
 9ee:	00d77363          	bgeu	a4,a3,9f4 <malloc+0x44>
 9f2:	6a05                	lui	s4,0x1
 9f4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9f8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9fc:	00000917          	auipc	s2,0x0
 a00:	10490913          	addi	s2,s2,260 # b00 <freep>
  if(p == (char*)-1)
 a04:	5afd                	li	s5,-1
 a06:	a895                	j	a7a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a08:	00000797          	auipc	a5,0x0
 a0c:	30078793          	addi	a5,a5,768 # d08 <base>
 a10:	00000717          	auipc	a4,0x0
 a14:	0ef73823          	sd	a5,240(a4) # b00 <freep>
 a18:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a1a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a1e:	b7e1                	j	9e6 <malloc+0x36>
      if(p->s.size == nunits)
 a20:	02e48c63          	beq	s1,a4,a58 <malloc+0xa8>
        p->s.size -= nunits;
 a24:	4137073b          	subw	a4,a4,s3
 a28:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a2a:	02071693          	slli	a3,a4,0x20
 a2e:	01c6d713          	srli	a4,a3,0x1c
 a32:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a34:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a38:	00000717          	auipc	a4,0x0
 a3c:	0ca73423          	sd	a0,200(a4) # b00 <freep>
      return (void*)(p + 1);
 a40:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a44:	70e2                	ld	ra,56(sp)
 a46:	7442                	ld	s0,48(sp)
 a48:	74a2                	ld	s1,40(sp)
 a4a:	7902                	ld	s2,32(sp)
 a4c:	69e2                	ld	s3,24(sp)
 a4e:	6a42                	ld	s4,16(sp)
 a50:	6aa2                	ld	s5,8(sp)
 a52:	6b02                	ld	s6,0(sp)
 a54:	6121                	addi	sp,sp,64
 a56:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a58:	6398                	ld	a4,0(a5)
 a5a:	e118                	sd	a4,0(a0)
 a5c:	bff1                	j	a38 <malloc+0x88>
  hp->s.size = nu;
 a5e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a62:	0541                	addi	a0,a0,16
 a64:	00000097          	auipc	ra,0x0
 a68:	ec4080e7          	jalr	-316(ra) # 928 <free>
  return freep;
 a6c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a70:	d971                	beqz	a0,a44 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a72:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a74:	4798                	lw	a4,8(a5)
 a76:	fa9775e3          	bgeu	a4,s1,a20 <malloc+0x70>
    if(p == freep)
 a7a:	00093703          	ld	a4,0(s2)
 a7e:	853e                	mv	a0,a5
 a80:	fef719e3          	bne	a4,a5,a72 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a84:	8552                	mv	a0,s4
 a86:	00000097          	auipc	ra,0x0
 a8a:	b22080e7          	jalr	-1246(ra) # 5a8 <sbrk>
  if(p == (char*)-1)
 a8e:	fd5518e3          	bne	a0,s5,a5e <malloc+0xae>
        return 0;
 a92:	4501                	li	a0,0
 a94:	bf45                	j	a44 <malloc+0x94>
