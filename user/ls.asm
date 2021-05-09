
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	30c080e7          	jalr	780(ra) # 31c <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	2e0080e7          	jalr	736(ra) # 31c <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2be080e7          	jalr	702(ra) # 31c <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	c0a98993          	addi	s3,s3,-1014 # c70 <buf.0>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	41a080e7          	jalr	1050(ra) # 490 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	29c080e7          	jalr	668(ra) # 31c <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	28e080e7          	jalr	654(ra) # 31c <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	29e080e7          	jalr	670(ra) # 346 <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	addi	s0,sp,624
  d6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  d8:	4581                	li	a1,0
  da:	00000097          	auipc	ra,0x0
  de:	5c4080e7          	jalr	1476(ra) # 69e <open>
  e2:	06054f63          	bltz	a0,160 <ls+0xac>
  e6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  e8:	d9840593          	addi	a1,s0,-616
  ec:	00000097          	auipc	ra,0x0
  f0:	5ca080e7          	jalr	1482(ra) # 6b6 <fstat>
  f4:	08054163          	bltz	a0,176 <ls+0xc2>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  f8:	da041783          	lh	a5,-608(s0)
  fc:	0007869b          	sext.w	a3,a5
 100:	4705                	li	a4,1
 102:	08e68a63          	beq	a3,a4,196 <ls+0xe2>
 106:	4709                	li	a4,2
 108:	02e69663          	bne	a3,a4,134 <ls+0x80>
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 10c:	854a                	mv	a0,s2
 10e:	00000097          	auipc	ra,0x0
 112:	ef2080e7          	jalr	-270(ra) # 0 <fmtname>
 116:	85aa                	mv	a1,a0
 118:	da843703          	ld	a4,-600(s0)
 11c:	d9c42683          	lw	a3,-612(s0)
 120:	da041603          	lh	a2,-608(s0)
 124:	00001517          	auipc	a0,0x1
 128:	ae450513          	addi	a0,a0,-1308 # c08 <malloc+0x11a>
 12c:	00001097          	auipc	ra,0x1
 130:	904080e7          	jalr	-1788(ra) # a30 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 134:	8526                	mv	a0,s1
 136:	00000097          	auipc	ra,0x0
 13a:	550080e7          	jalr	1360(ra) # 686 <close>
}
 13e:	26813083          	ld	ra,616(sp)
 142:	26013403          	ld	s0,608(sp)
 146:	25813483          	ld	s1,600(sp)
 14a:	25013903          	ld	s2,592(sp)
 14e:	24813983          	ld	s3,584(sp)
 152:	24013a03          	ld	s4,576(sp)
 156:	23813a83          	ld	s5,568(sp)
 15a:	27010113          	addi	sp,sp,624
 15e:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 160:	864a                	mv	a2,s2
 162:	00001597          	auipc	a1,0x1
 166:	a7658593          	addi	a1,a1,-1418 # bd8 <malloc+0xea>
 16a:	4509                	li	a0,2
 16c:	00001097          	auipc	ra,0x1
 170:	896080e7          	jalr	-1898(ra) # a02 <fprintf>
    return;
 174:	b7e9                	j	13e <ls+0x8a>
    fprintf(2, "ls: cannot stat %s\n", path);
 176:	864a                	mv	a2,s2
 178:	00001597          	auipc	a1,0x1
 17c:	a7858593          	addi	a1,a1,-1416 # bf0 <malloc+0x102>
 180:	4509                	li	a0,2
 182:	00001097          	auipc	ra,0x1
 186:	880080e7          	jalr	-1920(ra) # a02 <fprintf>
    close(fd);
 18a:	8526                	mv	a0,s1
 18c:	00000097          	auipc	ra,0x0
 190:	4fa080e7          	jalr	1274(ra) # 686 <close>
    return;
 194:	b76d                	j	13e <ls+0x8a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 196:	854a                	mv	a0,s2
 198:	00000097          	auipc	ra,0x0
 19c:	184080e7          	jalr	388(ra) # 31c <strlen>
 1a0:	2541                	addiw	a0,a0,16
 1a2:	20000793          	li	a5,512
 1a6:	00a7fb63          	bgeu	a5,a0,1bc <ls+0x108>
      printf("ls: path too long\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	a6e50513          	addi	a0,a0,-1426 # c18 <malloc+0x12a>
 1b2:	00001097          	auipc	ra,0x1
 1b6:	87e080e7          	jalr	-1922(ra) # a30 <printf>
      break;
 1ba:	bfad                	j	134 <ls+0x80>
    strcpy(buf, path);
 1bc:	85ca                	mv	a1,s2
 1be:	dc040513          	addi	a0,s0,-576
 1c2:	00000097          	auipc	ra,0x0
 1c6:	112080e7          	jalr	274(ra) # 2d4 <strcpy>
    p = buf+strlen(buf);
 1ca:	dc040513          	addi	a0,s0,-576
 1ce:	00000097          	auipc	ra,0x0
 1d2:	14e080e7          	jalr	334(ra) # 31c <strlen>
 1d6:	02051913          	slli	s2,a0,0x20
 1da:	02095913          	srli	s2,s2,0x20
 1de:	dc040793          	addi	a5,s0,-576
 1e2:	993e                	add	s2,s2,a5
    *p++ = '/';
 1e4:	00190993          	addi	s3,s2,1
 1e8:	02f00793          	li	a5,47
 1ec:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1f0:	00001a17          	auipc	s4,0x1
 1f4:	a40a0a13          	addi	s4,s4,-1472 # c30 <malloc+0x142>
        printf("ls: cannot stat %s\n", buf);
 1f8:	00001a97          	auipc	s5,0x1
 1fc:	9f8a8a93          	addi	s5,s5,-1544 # bf0 <malloc+0x102>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 200:	a801                	j	210 <ls+0x15c>
        printf("ls: cannot stat %s\n", buf);
 202:	dc040593          	addi	a1,s0,-576
 206:	8556                	mv	a0,s5
 208:	00001097          	auipc	ra,0x1
 20c:	828080e7          	jalr	-2008(ra) # a30 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 210:	4641                	li	a2,16
 212:	db040593          	addi	a1,s0,-592
 216:	8526                	mv	a0,s1
 218:	00000097          	auipc	ra,0x0
 21c:	45e080e7          	jalr	1118(ra) # 676 <read>
 220:	47c1                	li	a5,16
 222:	f0f519e3          	bne	a0,a5,134 <ls+0x80>
      if(de.inum == 0)
 226:	db045783          	lhu	a5,-592(s0)
 22a:	d3fd                	beqz	a5,210 <ls+0x15c>
      memmove(p, de.name, DIRSIZ);
 22c:	4639                	li	a2,14
 22e:	db240593          	addi	a1,s0,-590
 232:	854e                	mv	a0,s3
 234:	00000097          	auipc	ra,0x0
 238:	25c080e7          	jalr	604(ra) # 490 <memmove>
      p[DIRSIZ] = 0;
 23c:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 240:	d9840593          	addi	a1,s0,-616
 244:	dc040513          	addi	a0,s0,-576
 248:	00000097          	auipc	ra,0x0
 24c:	1b8080e7          	jalr	440(ra) # 400 <stat>
 250:	fa0549e3          	bltz	a0,202 <ls+0x14e>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 254:	dc040513          	addi	a0,s0,-576
 258:	00000097          	auipc	ra,0x0
 25c:	da8080e7          	jalr	-600(ra) # 0 <fmtname>
 260:	85aa                	mv	a1,a0
 262:	da843703          	ld	a4,-600(s0)
 266:	d9c42683          	lw	a3,-612(s0)
 26a:	da041603          	lh	a2,-608(s0)
 26e:	8552                	mv	a0,s4
 270:	00000097          	auipc	ra,0x0
 274:	7c0080e7          	jalr	1984(ra) # a30 <printf>
 278:	bf61                	j	210 <ls+0x15c>

000000000000027a <main>:

int
main(int argc, char *argv[])
{
 27a:	1101                	addi	sp,sp,-32
 27c:	ec06                	sd	ra,24(sp)
 27e:	e822                	sd	s0,16(sp)
 280:	e426                	sd	s1,8(sp)
 282:	e04a                	sd	s2,0(sp)
 284:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 286:	4785                	li	a5,1
 288:	02a7d963          	bge	a5,a0,2ba <main+0x40>
 28c:	00858493          	addi	s1,a1,8
 290:	ffe5091b          	addiw	s2,a0,-2
 294:	02091793          	slli	a5,s2,0x20
 298:	01d7d913          	srli	s2,a5,0x1d
 29c:	05c1                	addi	a1,a1,16
 29e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a0:	6088                	ld	a0,0(s1)
 2a2:	00000097          	auipc	ra,0x0
 2a6:	e12080e7          	jalr	-494(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2aa:	04a1                	addi	s1,s1,8
 2ac:	ff249ae3          	bne	s1,s2,2a0 <main+0x26>
  exit(0);
 2b0:	4501                	li	a0,0
 2b2:	00000097          	auipc	ra,0x0
 2b6:	3ac080e7          	jalr	940(ra) # 65e <exit>
    ls(".");
 2ba:	00001517          	auipc	a0,0x1
 2be:	98650513          	addi	a0,a0,-1658 # c40 <malloc+0x152>
 2c2:	00000097          	auipc	ra,0x0
 2c6:	df2080e7          	jalr	-526(ra) # b4 <ls>
    exit(0);
 2ca:	4501                	li	a0,0
 2cc:	00000097          	auipc	ra,0x0
 2d0:	392080e7          	jalr	914(ra) # 65e <exit>

00000000000002d4 <strcpy>:
#include "kernel/Csemaphore.h"


char*
strcpy(char *s, const char *t)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e422                	sd	s0,8(sp)
 2d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2da:	87aa                	mv	a5,a0
 2dc:	0585                	addi	a1,a1,1
 2de:	0785                	addi	a5,a5,1
 2e0:	fff5c703          	lbu	a4,-1(a1)
 2e4:	fee78fa3          	sb	a4,-1(a5)
 2e8:	fb75                	bnez	a4,2dc <strcpy+0x8>
    ;
  return os;
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret

00000000000002f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2f6:	00054783          	lbu	a5,0(a0)
 2fa:	cb91                	beqz	a5,30e <strcmp+0x1e>
 2fc:	0005c703          	lbu	a4,0(a1)
 300:	00f71763          	bne	a4,a5,30e <strcmp+0x1e>
    p++, q++;
 304:	0505                	addi	a0,a0,1
 306:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 308:	00054783          	lbu	a5,0(a0)
 30c:	fbe5                	bnez	a5,2fc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 30e:	0005c503          	lbu	a0,0(a1)
}
 312:	40a7853b          	subw	a0,a5,a0
 316:	6422                	ld	s0,8(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <strlen>:

uint
strlen(const char *s)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 322:	00054783          	lbu	a5,0(a0)
 326:	cf91                	beqz	a5,342 <strlen+0x26>
 328:	0505                	addi	a0,a0,1
 32a:	87aa                	mv	a5,a0
 32c:	4685                	li	a3,1
 32e:	9e89                	subw	a3,a3,a0
 330:	00f6853b          	addw	a0,a3,a5
 334:	0785                	addi	a5,a5,1
 336:	fff7c703          	lbu	a4,-1(a5)
 33a:	fb7d                	bnez	a4,330 <strlen+0x14>
    ;
  return n;
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
  for(n = 0; s[n]; n++)
 342:	4501                	li	a0,0
 344:	bfe5                	j	33c <strlen+0x20>

0000000000000346 <memset>:

void*
memset(void *dst, int c, uint n)
{
 346:	1141                	addi	sp,sp,-16
 348:	e422                	sd	s0,8(sp)
 34a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 34c:	ca19                	beqz	a2,362 <memset+0x1c>
 34e:	87aa                	mv	a5,a0
 350:	1602                	slli	a2,a2,0x20
 352:	9201                	srli	a2,a2,0x20
 354:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 358:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 35c:	0785                	addi	a5,a5,1
 35e:	fee79de3          	bne	a5,a4,358 <memset+0x12>
  }
  return dst;
}
 362:	6422                	ld	s0,8(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret

0000000000000368 <strchr>:

char*
strchr(const char *s, char c)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 36e:	00054783          	lbu	a5,0(a0)
 372:	cb99                	beqz	a5,388 <strchr+0x20>
    if(*s == c)
 374:	00f58763          	beq	a1,a5,382 <strchr+0x1a>
  for(; *s; s++)
 378:	0505                	addi	a0,a0,1
 37a:	00054783          	lbu	a5,0(a0)
 37e:	fbfd                	bnez	a5,374 <strchr+0xc>
      return (char*)s;
  return 0;
 380:	4501                	li	a0,0
}
 382:	6422                	ld	s0,8(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret
  return 0;
 388:	4501                	li	a0,0
 38a:	bfe5                	j	382 <strchr+0x1a>

000000000000038c <gets>:

char*
gets(char *buf, int max)
{
 38c:	711d                	addi	sp,sp,-96
 38e:	ec86                	sd	ra,88(sp)
 390:	e8a2                	sd	s0,80(sp)
 392:	e4a6                	sd	s1,72(sp)
 394:	e0ca                	sd	s2,64(sp)
 396:	fc4e                	sd	s3,56(sp)
 398:	f852                	sd	s4,48(sp)
 39a:	f456                	sd	s5,40(sp)
 39c:	f05a                	sd	s6,32(sp)
 39e:	ec5e                	sd	s7,24(sp)
 3a0:	1080                	addi	s0,sp,96
 3a2:	8baa                	mv	s7,a0
 3a4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a6:	892a                	mv	s2,a0
 3a8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3aa:	4aa9                	li	s5,10
 3ac:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3ae:	89a6                	mv	s3,s1
 3b0:	2485                	addiw	s1,s1,1
 3b2:	0344d863          	bge	s1,s4,3e2 <gets+0x56>
    cc = read(0, &c, 1);
 3b6:	4605                	li	a2,1
 3b8:	faf40593          	addi	a1,s0,-81
 3bc:	4501                	li	a0,0
 3be:	00000097          	auipc	ra,0x0
 3c2:	2b8080e7          	jalr	696(ra) # 676 <read>
    if(cc < 1)
 3c6:	00a05e63          	blez	a0,3e2 <gets+0x56>
    buf[i++] = c;
 3ca:	faf44783          	lbu	a5,-81(s0)
 3ce:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3d2:	01578763          	beq	a5,s5,3e0 <gets+0x54>
 3d6:	0905                	addi	s2,s2,1
 3d8:	fd679be3          	bne	a5,s6,3ae <gets+0x22>
  for(i=0; i+1 < max; ){
 3dc:	89a6                	mv	s3,s1
 3de:	a011                	j	3e2 <gets+0x56>
 3e0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3e2:	99de                	add	s3,s3,s7
 3e4:	00098023          	sb	zero,0(s3)
  return buf;
}
 3e8:	855e                	mv	a0,s7
 3ea:	60e6                	ld	ra,88(sp)
 3ec:	6446                	ld	s0,80(sp)
 3ee:	64a6                	ld	s1,72(sp)
 3f0:	6906                	ld	s2,64(sp)
 3f2:	79e2                	ld	s3,56(sp)
 3f4:	7a42                	ld	s4,48(sp)
 3f6:	7aa2                	ld	s5,40(sp)
 3f8:	7b02                	ld	s6,32(sp)
 3fa:	6be2                	ld	s7,24(sp)
 3fc:	6125                	addi	sp,sp,96
 3fe:	8082                	ret

0000000000000400 <stat>:

int
stat(const char *n, struct stat *st)
{
 400:	1101                	addi	sp,sp,-32
 402:	ec06                	sd	ra,24(sp)
 404:	e822                	sd	s0,16(sp)
 406:	e426                	sd	s1,8(sp)
 408:	e04a                	sd	s2,0(sp)
 40a:	1000                	addi	s0,sp,32
 40c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 40e:	4581                	li	a1,0
 410:	00000097          	auipc	ra,0x0
 414:	28e080e7          	jalr	654(ra) # 69e <open>
  if(fd < 0)
 418:	02054563          	bltz	a0,442 <stat+0x42>
 41c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 41e:	85ca                	mv	a1,s2
 420:	00000097          	auipc	ra,0x0
 424:	296080e7          	jalr	662(ra) # 6b6 <fstat>
 428:	892a                	mv	s2,a0
  close(fd);
 42a:	8526                	mv	a0,s1
 42c:	00000097          	auipc	ra,0x0
 430:	25a080e7          	jalr	602(ra) # 686 <close>
  return r;
}
 434:	854a                	mv	a0,s2
 436:	60e2                	ld	ra,24(sp)
 438:	6442                	ld	s0,16(sp)
 43a:	64a2                	ld	s1,8(sp)
 43c:	6902                	ld	s2,0(sp)
 43e:	6105                	addi	sp,sp,32
 440:	8082                	ret
    return -1;
 442:	597d                	li	s2,-1
 444:	bfc5                	j	434 <stat+0x34>

0000000000000446 <atoi>:

int
atoi(const char *s)
{
 446:	1141                	addi	sp,sp,-16
 448:	e422                	sd	s0,8(sp)
 44a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 44c:	00054603          	lbu	a2,0(a0)
 450:	fd06079b          	addiw	a5,a2,-48
 454:	0ff7f793          	andi	a5,a5,255
 458:	4725                	li	a4,9
 45a:	02f76963          	bltu	a4,a5,48c <atoi+0x46>
 45e:	86aa                	mv	a3,a0
  n = 0;
 460:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 462:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 464:	0685                	addi	a3,a3,1
 466:	0025179b          	slliw	a5,a0,0x2
 46a:	9fa9                	addw	a5,a5,a0
 46c:	0017979b          	slliw	a5,a5,0x1
 470:	9fb1                	addw	a5,a5,a2
 472:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 476:	0006c603          	lbu	a2,0(a3)
 47a:	fd06071b          	addiw	a4,a2,-48
 47e:	0ff77713          	andi	a4,a4,255
 482:	fee5f1e3          	bgeu	a1,a4,464 <atoi+0x1e>
  return n;
}
 486:	6422                	ld	s0,8(sp)
 488:	0141                	addi	sp,sp,16
 48a:	8082                	ret
  n = 0;
 48c:	4501                	li	a0,0
 48e:	bfe5                	j	486 <atoi+0x40>

0000000000000490 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 490:	1141                	addi	sp,sp,-16
 492:	e422                	sd	s0,8(sp)
 494:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 496:	02b57463          	bgeu	a0,a1,4be <memmove+0x2e>
    while(n-- > 0)
 49a:	00c05f63          	blez	a2,4b8 <memmove+0x28>
 49e:	1602                	slli	a2,a2,0x20
 4a0:	9201                	srli	a2,a2,0x20
 4a2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4a6:	872a                	mv	a4,a0
      *dst++ = *src++;
 4a8:	0585                	addi	a1,a1,1
 4aa:	0705                	addi	a4,a4,1
 4ac:	fff5c683          	lbu	a3,-1(a1)
 4b0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4b4:	fee79ae3          	bne	a5,a4,4a8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4b8:	6422                	ld	s0,8(sp)
 4ba:	0141                	addi	sp,sp,16
 4bc:	8082                	ret
    dst += n;
 4be:	00c50733          	add	a4,a0,a2
    src += n;
 4c2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4c4:	fec05ae3          	blez	a2,4b8 <memmove+0x28>
 4c8:	fff6079b          	addiw	a5,a2,-1
 4cc:	1782                	slli	a5,a5,0x20
 4ce:	9381                	srli	a5,a5,0x20
 4d0:	fff7c793          	not	a5,a5
 4d4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4d6:	15fd                	addi	a1,a1,-1
 4d8:	177d                	addi	a4,a4,-1
 4da:	0005c683          	lbu	a3,0(a1)
 4de:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4e2:	fee79ae3          	bne	a5,a4,4d6 <memmove+0x46>
 4e6:	bfc9                	j	4b8 <memmove+0x28>

00000000000004e8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4e8:	1141                	addi	sp,sp,-16
 4ea:	e422                	sd	s0,8(sp)
 4ec:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ee:	ca05                	beqz	a2,51e <memcmp+0x36>
 4f0:	fff6069b          	addiw	a3,a2,-1
 4f4:	1682                	slli	a3,a3,0x20
 4f6:	9281                	srli	a3,a3,0x20
 4f8:	0685                	addi	a3,a3,1
 4fa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4fc:	00054783          	lbu	a5,0(a0)
 500:	0005c703          	lbu	a4,0(a1)
 504:	00e79863          	bne	a5,a4,514 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 508:	0505                	addi	a0,a0,1
    p2++;
 50a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 50c:	fed518e3          	bne	a0,a3,4fc <memcmp+0x14>
  }
  return 0;
 510:	4501                	li	a0,0
 512:	a019                	j	518 <memcmp+0x30>
      return *p1 - *p2;
 514:	40e7853b          	subw	a0,a5,a4
}
 518:	6422                	ld	s0,8(sp)
 51a:	0141                	addi	sp,sp,16
 51c:	8082                	ret
  return 0;
 51e:	4501                	li	a0,0
 520:	bfe5                	j	518 <memcmp+0x30>

0000000000000522 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 522:	1141                	addi	sp,sp,-16
 524:	e406                	sd	ra,8(sp)
 526:	e022                	sd	s0,0(sp)
 528:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 52a:	00000097          	auipc	ra,0x0
 52e:	f66080e7          	jalr	-154(ra) # 490 <memmove>
}
 532:	60a2                	ld	ra,8(sp)
 534:	6402                	ld	s0,0(sp)
 536:	0141                	addi	sp,sp,16
 538:	8082                	ret

000000000000053a <csem_down>:


void 
csem_down(struct counting_semaphore *sem) {
 53a:	1101                	addi	sp,sp,-32
 53c:	ec06                	sd	ra,24(sp)
 53e:	e822                	sd	s0,16(sp)
 540:	e426                	sd	s1,8(sp)
 542:	1000                	addi	s0,sp,32
 544:	84aa                	mv	s1,a0
    bsem_down(sem->bsem2);
 546:	4148                	lw	a0,4(a0)
 548:	00000097          	auipc	ra,0x0
 54c:	1ce080e7          	jalr	462(ra) # 716 <bsem_down>
    bsem_down(sem->bsem1);
 550:	4088                	lw	a0,0(s1)
 552:	00000097          	auipc	ra,0x0
 556:	1c4080e7          	jalr	452(ra) # 716 <bsem_down>
    sem->count -= 1;
 55a:	449c                	lw	a5,8(s1)
 55c:	37fd                	addiw	a5,a5,-1
 55e:	0007871b          	sext.w	a4,a5
 562:	c49c                	sw	a5,8(s1)
    if (sem->count > 0)
 564:	00e04c63          	bgtz	a4,57c <csem_down+0x42>
    	bsem_up(sem->bsem2);
    bsem_up(sem->bsem1);
 568:	4088                	lw	a0,0(s1)
 56a:	00000097          	auipc	ra,0x0
 56e:	1b4080e7          	jalr	436(ra) # 71e <bsem_up>
}
 572:	60e2                	ld	ra,24(sp)
 574:	6442                	ld	s0,16(sp)
 576:	64a2                	ld	s1,8(sp)
 578:	6105                	addi	sp,sp,32
 57a:	8082                	ret
    	bsem_up(sem->bsem2);
 57c:	40c8                	lw	a0,4(s1)
 57e:	00000097          	auipc	ra,0x0
 582:	1a0080e7          	jalr	416(ra) # 71e <bsem_up>
 586:	b7cd                	j	568 <csem_down+0x2e>

0000000000000588 <csem_up>:


void 
csem_up(struct counting_semaphore *sem) {
 588:	1101                	addi	sp,sp,-32
 58a:	ec06                	sd	ra,24(sp)
 58c:	e822                	sd	s0,16(sp)
 58e:	e426                	sd	s1,8(sp)
 590:	1000                	addi	s0,sp,32
 592:	84aa                	mv	s1,a0
	bsem_down(sem->bsem1);
 594:	4108                	lw	a0,0(a0)
 596:	00000097          	auipc	ra,0x0
 59a:	180080e7          	jalr	384(ra) # 716 <bsem_down>
	sem->count += 1;
 59e:	449c                	lw	a5,8(s1)
 5a0:	2785                	addiw	a5,a5,1
 5a2:	0007871b          	sext.w	a4,a5
 5a6:	c49c                	sw	a5,8(s1)
	if (sem->count == 1)
 5a8:	4785                	li	a5,1
 5aa:	00f70c63          	beq	a4,a5,5c2 <csem_up+0x3a>
		bsem_up(sem->bsem2);
	bsem_up(sem->bsem1);
 5ae:	4088                	lw	a0,0(s1)
 5b0:	00000097          	auipc	ra,0x0
 5b4:	16e080e7          	jalr	366(ra) # 71e <bsem_up>
}
 5b8:	60e2                	ld	ra,24(sp)
 5ba:	6442                	ld	s0,16(sp)
 5bc:	64a2                	ld	s1,8(sp)
 5be:	6105                	addi	sp,sp,32
 5c0:	8082                	ret
		bsem_up(sem->bsem2);
 5c2:	40c8                	lw	a0,4(s1)
 5c4:	00000097          	auipc	ra,0x0
 5c8:	15a080e7          	jalr	346(ra) # 71e <bsem_up>
 5cc:	b7cd                	j	5ae <csem_up+0x26>

00000000000005ce <csem_alloc>:


int 
csem_alloc(struct counting_semaphore *sem, int count) {
 5ce:	7179                	addi	sp,sp,-48
 5d0:	f406                	sd	ra,40(sp)
 5d2:	f022                	sd	s0,32(sp)
 5d4:	ec26                	sd	s1,24(sp)
 5d6:	e84a                	sd	s2,16(sp)
 5d8:	e44e                	sd	s3,8(sp)
 5da:	1800                	addi	s0,sp,48
 5dc:	892a                	mv	s2,a0
 5de:	89ae                	mv	s3,a1
    int bsem1 = bsem_alloc();
 5e0:	00000097          	auipc	ra,0x0
 5e4:	14e080e7          	jalr	334(ra) # 72e <bsem_alloc>
 5e8:	84aa                	mv	s1,a0
    int bsem2 = bsem_alloc();
 5ea:	00000097          	auipc	ra,0x0
 5ee:	144080e7          	jalr	324(ra) # 72e <bsem_alloc>
    if (bsem1 == -1 || bsem2 == -1)
 5f2:	57fd                	li	a5,-1
 5f4:	00f48d63          	beq	s1,a5,60e <csem_alloc+0x40>
 5f8:	02f50863          	beq	a0,a5,628 <csem_alloc+0x5a>
        return -1; 
    sem->bsem1 = bsem1;
 5fc:	00992023          	sw	s1,0(s2)
    sem->bsem2 = bsem2;
 600:	00a92223          	sw	a0,4(s2)
    if (count == 0)
 604:	00098d63          	beqz	s3,61e <csem_alloc+0x50>
        // Binary semaphore first value = min(1, count)
        bsem_down(sem->bsem2); 
    sem->count = count;
 608:	01392423          	sw	s3,8(s2)
    return 0;
 60c:	4481                	li	s1,0
}
 60e:	8526                	mv	a0,s1
 610:	70a2                	ld	ra,40(sp)
 612:	7402                	ld	s0,32(sp)
 614:	64e2                	ld	s1,24(sp)
 616:	6942                	ld	s2,16(sp)
 618:	69a2                	ld	s3,8(sp)
 61a:	6145                	addi	sp,sp,48
 61c:	8082                	ret
        bsem_down(sem->bsem2); 
 61e:	00000097          	auipc	ra,0x0
 622:	0f8080e7          	jalr	248(ra) # 716 <bsem_down>
 626:	b7cd                	j	608 <csem_alloc+0x3a>
        return -1; 
 628:	84aa                	mv	s1,a0
 62a:	b7d5                	j	60e <csem_alloc+0x40>

000000000000062c <csem_free>:


void 
csem_free(struct counting_semaphore *sem) {
 62c:	1101                	addi	sp,sp,-32
 62e:	ec06                	sd	ra,24(sp)
 630:	e822                	sd	s0,16(sp)
 632:	e426                	sd	s1,8(sp)
 634:	1000                	addi	s0,sp,32
 636:	84aa                	mv	s1,a0
    bsem_free(sem->bsem1);
 638:	4108                	lw	a0,0(a0)
 63a:	00000097          	auipc	ra,0x0
 63e:	0ec080e7          	jalr	236(ra) # 726 <bsem_free>
    bsem_free(sem->bsem2);
 642:	40c8                	lw	a0,4(s1)
 644:	00000097          	auipc	ra,0x0
 648:	0e2080e7          	jalr	226(ra) # 726 <bsem_free>
    //free(sem);
}
 64c:	60e2                	ld	ra,24(sp)
 64e:	6442                	ld	s0,16(sp)
 650:	64a2                	ld	s1,8(sp)
 652:	6105                	addi	sp,sp,32
 654:	8082                	ret

0000000000000656 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 656:	4885                	li	a7,1
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <exit>:
.global exit
exit:
 li a7, SYS_exit
 65e:	4889                	li	a7,2
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <wait>:
.global wait
wait:
 li a7, SYS_wait
 666:	488d                	li	a7,3
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 66e:	4891                	li	a7,4
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <read>:
.global read
read:
 li a7, SYS_read
 676:	4895                	li	a7,5
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <write>:
.global write
write:
 li a7, SYS_write
 67e:	48c1                	li	a7,16
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <close>:
.global close
close:
 li a7, SYS_close
 686:	48d5                	li	a7,21
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <kill>:
.global kill
kill:
 li a7, SYS_kill
 68e:	4899                	li	a7,6
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <exec>:
.global exec
exec:
 li a7, SYS_exec
 696:	489d                	li	a7,7
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <open>:
.global open
open:
 li a7, SYS_open
 69e:	48bd                	li	a7,15
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6a6:	48c5                	li	a7,17
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6ae:	48c9                	li	a7,18
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6b6:	48a1                	li	a7,8
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <link>:
.global link
link:
 li a7, SYS_link
 6be:	48cd                	li	a7,19
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6c6:	48d1                	li	a7,20
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6ce:	48a5                	li	a7,9
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6d6:	48a9                	li	a7,10
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6de:	48ad                	li	a7,11
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6e6:	48b1                	li	a7,12
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6ee:	48b5                	li	a7,13
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6f6:	48b9                	li	a7,14
 ecall
 6f8:	00000073          	ecall
 ret
 6fc:	8082                	ret

00000000000006fe <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 6fe:	48d9                	li	a7,22
 ecall
 700:	00000073          	ecall
 ret
 704:	8082                	ret

0000000000000706 <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 706:	48dd                	li	a7,23
 ecall
 708:	00000073          	ecall
 ret
 70c:	8082                	ret

000000000000070e <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 70e:	48e1                	li	a7,24
 ecall
 710:	00000073          	ecall
 ret
 714:	8082                	ret

0000000000000716 <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
 716:	48ed                	li	a7,27
 ecall
 718:	00000073          	ecall
 ret
 71c:	8082                	ret

000000000000071e <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
 71e:	48f1                	li	a7,28
 ecall
 720:	00000073          	ecall
 ret
 724:	8082                	ret

0000000000000726 <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
 726:	48e9                	li	a7,26
 ecall
 728:	00000073          	ecall
 ret
 72c:	8082                	ret

000000000000072e <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
 72e:	48e5                	li	a7,25
 ecall
 730:	00000073          	ecall
 ret
 734:	8082                	ret

0000000000000736 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
 736:	48f5                	li	a7,29
 ecall
 738:	00000073          	ecall
 ret
 73c:	8082                	ret

000000000000073e <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
 73e:	48f9                	li	a7,30
 ecall
 740:	00000073          	ecall
 ret
 744:	8082                	ret

0000000000000746 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
 746:	48fd                	li	a7,31
 ecall
 748:	00000073          	ecall
 ret
 74c:	8082                	ret

000000000000074e <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
 74e:	02000893          	li	a7,32
 ecall
 752:	00000073          	ecall
 ret
 756:	8082                	ret

0000000000000758 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 758:	1101                	addi	sp,sp,-32
 75a:	ec06                	sd	ra,24(sp)
 75c:	e822                	sd	s0,16(sp)
 75e:	1000                	addi	s0,sp,32
 760:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 764:	4605                	li	a2,1
 766:	fef40593          	addi	a1,s0,-17
 76a:	00000097          	auipc	ra,0x0
 76e:	f14080e7          	jalr	-236(ra) # 67e <write>
}
 772:	60e2                	ld	ra,24(sp)
 774:	6442                	ld	s0,16(sp)
 776:	6105                	addi	sp,sp,32
 778:	8082                	ret

000000000000077a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 77a:	7139                	addi	sp,sp,-64
 77c:	fc06                	sd	ra,56(sp)
 77e:	f822                	sd	s0,48(sp)
 780:	f426                	sd	s1,40(sp)
 782:	f04a                	sd	s2,32(sp)
 784:	ec4e                	sd	s3,24(sp)
 786:	0080                	addi	s0,sp,64
 788:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 78a:	c299                	beqz	a3,790 <printint+0x16>
 78c:	0805c863          	bltz	a1,81c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 790:	2581                	sext.w	a1,a1
  neg = 0;
 792:	4881                	li	a7,0
 794:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 798:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 79a:	2601                	sext.w	a2,a2
 79c:	00000517          	auipc	a0,0x0
 7a0:	4b450513          	addi	a0,a0,1204 # c50 <digits>
 7a4:	883a                	mv	a6,a4
 7a6:	2705                	addiw	a4,a4,1
 7a8:	02c5f7bb          	remuw	a5,a1,a2
 7ac:	1782                	slli	a5,a5,0x20
 7ae:	9381                	srli	a5,a5,0x20
 7b0:	97aa                	add	a5,a5,a0
 7b2:	0007c783          	lbu	a5,0(a5)
 7b6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7ba:	0005879b          	sext.w	a5,a1
 7be:	02c5d5bb          	divuw	a1,a1,a2
 7c2:	0685                	addi	a3,a3,1
 7c4:	fec7f0e3          	bgeu	a5,a2,7a4 <printint+0x2a>
  if(neg)
 7c8:	00088b63          	beqz	a7,7de <printint+0x64>
    buf[i++] = '-';
 7cc:	fd040793          	addi	a5,s0,-48
 7d0:	973e                	add	a4,a4,a5
 7d2:	02d00793          	li	a5,45
 7d6:	fef70823          	sb	a5,-16(a4)
 7da:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 7de:	02e05863          	blez	a4,80e <printint+0x94>
 7e2:	fc040793          	addi	a5,s0,-64
 7e6:	00e78933          	add	s2,a5,a4
 7ea:	fff78993          	addi	s3,a5,-1
 7ee:	99ba                	add	s3,s3,a4
 7f0:	377d                	addiw	a4,a4,-1
 7f2:	1702                	slli	a4,a4,0x20
 7f4:	9301                	srli	a4,a4,0x20
 7f6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7fa:	fff94583          	lbu	a1,-1(s2)
 7fe:	8526                	mv	a0,s1
 800:	00000097          	auipc	ra,0x0
 804:	f58080e7          	jalr	-168(ra) # 758 <putc>
  while(--i >= 0)
 808:	197d                	addi	s2,s2,-1
 80a:	ff3918e3          	bne	s2,s3,7fa <printint+0x80>
}
 80e:	70e2                	ld	ra,56(sp)
 810:	7442                	ld	s0,48(sp)
 812:	74a2                	ld	s1,40(sp)
 814:	7902                	ld	s2,32(sp)
 816:	69e2                	ld	s3,24(sp)
 818:	6121                	addi	sp,sp,64
 81a:	8082                	ret
    x = -xx;
 81c:	40b005bb          	negw	a1,a1
    neg = 1;
 820:	4885                	li	a7,1
    x = -xx;
 822:	bf8d                	j	794 <printint+0x1a>

0000000000000824 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 824:	7119                	addi	sp,sp,-128
 826:	fc86                	sd	ra,120(sp)
 828:	f8a2                	sd	s0,112(sp)
 82a:	f4a6                	sd	s1,104(sp)
 82c:	f0ca                	sd	s2,96(sp)
 82e:	ecce                	sd	s3,88(sp)
 830:	e8d2                	sd	s4,80(sp)
 832:	e4d6                	sd	s5,72(sp)
 834:	e0da                	sd	s6,64(sp)
 836:	fc5e                	sd	s7,56(sp)
 838:	f862                	sd	s8,48(sp)
 83a:	f466                	sd	s9,40(sp)
 83c:	f06a                	sd	s10,32(sp)
 83e:	ec6e                	sd	s11,24(sp)
 840:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 842:	0005c903          	lbu	s2,0(a1)
 846:	18090f63          	beqz	s2,9e4 <vprintf+0x1c0>
 84a:	8aaa                	mv	s5,a0
 84c:	8b32                	mv	s6,a2
 84e:	00158493          	addi	s1,a1,1
  state = 0;
 852:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 854:	02500a13          	li	s4,37
      if(c == 'd'){
 858:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 85c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 860:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 864:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 868:	00000b97          	auipc	s7,0x0
 86c:	3e8b8b93          	addi	s7,s7,1000 # c50 <digits>
 870:	a839                	j	88e <vprintf+0x6a>
        putc(fd, c);
 872:	85ca                	mv	a1,s2
 874:	8556                	mv	a0,s5
 876:	00000097          	auipc	ra,0x0
 87a:	ee2080e7          	jalr	-286(ra) # 758 <putc>
 87e:	a019                	j	884 <vprintf+0x60>
    } else if(state == '%'){
 880:	01498f63          	beq	s3,s4,89e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 884:	0485                	addi	s1,s1,1
 886:	fff4c903          	lbu	s2,-1(s1)
 88a:	14090d63          	beqz	s2,9e4 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 88e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 892:	fe0997e3          	bnez	s3,880 <vprintf+0x5c>
      if(c == '%'){
 896:	fd479ee3          	bne	a5,s4,872 <vprintf+0x4e>
        state = '%';
 89a:	89be                	mv	s3,a5
 89c:	b7e5                	j	884 <vprintf+0x60>
      if(c == 'd'){
 89e:	05878063          	beq	a5,s8,8de <vprintf+0xba>
      } else if(c == 'l') {
 8a2:	05978c63          	beq	a5,s9,8fa <vprintf+0xd6>
      } else if(c == 'x') {
 8a6:	07a78863          	beq	a5,s10,916 <vprintf+0xf2>
      } else if(c == 'p') {
 8aa:	09b78463          	beq	a5,s11,932 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 8ae:	07300713          	li	a4,115
 8b2:	0ce78663          	beq	a5,a4,97e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8b6:	06300713          	li	a4,99
 8ba:	0ee78e63          	beq	a5,a4,9b6 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 8be:	11478863          	beq	a5,s4,9ce <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8c2:	85d2                	mv	a1,s4
 8c4:	8556                	mv	a0,s5
 8c6:	00000097          	auipc	ra,0x0
 8ca:	e92080e7          	jalr	-366(ra) # 758 <putc>
        putc(fd, c);
 8ce:	85ca                	mv	a1,s2
 8d0:	8556                	mv	a0,s5
 8d2:	00000097          	auipc	ra,0x0
 8d6:	e86080e7          	jalr	-378(ra) # 758 <putc>
      }
      state = 0;
 8da:	4981                	li	s3,0
 8dc:	b765                	j	884 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 8de:	008b0913          	addi	s2,s6,8
 8e2:	4685                	li	a3,1
 8e4:	4629                	li	a2,10
 8e6:	000b2583          	lw	a1,0(s6)
 8ea:	8556                	mv	a0,s5
 8ec:	00000097          	auipc	ra,0x0
 8f0:	e8e080e7          	jalr	-370(ra) # 77a <printint>
 8f4:	8b4a                	mv	s6,s2
      state = 0;
 8f6:	4981                	li	s3,0
 8f8:	b771                	j	884 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8fa:	008b0913          	addi	s2,s6,8
 8fe:	4681                	li	a3,0
 900:	4629                	li	a2,10
 902:	000b2583          	lw	a1,0(s6)
 906:	8556                	mv	a0,s5
 908:	00000097          	auipc	ra,0x0
 90c:	e72080e7          	jalr	-398(ra) # 77a <printint>
 910:	8b4a                	mv	s6,s2
      state = 0;
 912:	4981                	li	s3,0
 914:	bf85                	j	884 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 916:	008b0913          	addi	s2,s6,8
 91a:	4681                	li	a3,0
 91c:	4641                	li	a2,16
 91e:	000b2583          	lw	a1,0(s6)
 922:	8556                	mv	a0,s5
 924:	00000097          	auipc	ra,0x0
 928:	e56080e7          	jalr	-426(ra) # 77a <printint>
 92c:	8b4a                	mv	s6,s2
      state = 0;
 92e:	4981                	li	s3,0
 930:	bf91                	j	884 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 932:	008b0793          	addi	a5,s6,8
 936:	f8f43423          	sd	a5,-120(s0)
 93a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 93e:	03000593          	li	a1,48
 942:	8556                	mv	a0,s5
 944:	00000097          	auipc	ra,0x0
 948:	e14080e7          	jalr	-492(ra) # 758 <putc>
  putc(fd, 'x');
 94c:	85ea                	mv	a1,s10
 94e:	8556                	mv	a0,s5
 950:	00000097          	auipc	ra,0x0
 954:	e08080e7          	jalr	-504(ra) # 758 <putc>
 958:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 95a:	03c9d793          	srli	a5,s3,0x3c
 95e:	97de                	add	a5,a5,s7
 960:	0007c583          	lbu	a1,0(a5)
 964:	8556                	mv	a0,s5
 966:	00000097          	auipc	ra,0x0
 96a:	df2080e7          	jalr	-526(ra) # 758 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 96e:	0992                	slli	s3,s3,0x4
 970:	397d                	addiw	s2,s2,-1
 972:	fe0914e3          	bnez	s2,95a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 976:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 97a:	4981                	li	s3,0
 97c:	b721                	j	884 <vprintf+0x60>
        s = va_arg(ap, char*);
 97e:	008b0993          	addi	s3,s6,8
 982:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 986:	02090163          	beqz	s2,9a8 <vprintf+0x184>
        while(*s != 0){
 98a:	00094583          	lbu	a1,0(s2)
 98e:	c9a1                	beqz	a1,9de <vprintf+0x1ba>
          putc(fd, *s);
 990:	8556                	mv	a0,s5
 992:	00000097          	auipc	ra,0x0
 996:	dc6080e7          	jalr	-570(ra) # 758 <putc>
          s++;
 99a:	0905                	addi	s2,s2,1
        while(*s != 0){
 99c:	00094583          	lbu	a1,0(s2)
 9a0:	f9e5                	bnez	a1,990 <vprintf+0x16c>
        s = va_arg(ap, char*);
 9a2:	8b4e                	mv	s6,s3
      state = 0;
 9a4:	4981                	li	s3,0
 9a6:	bdf9                	j	884 <vprintf+0x60>
          s = "(null)";
 9a8:	00000917          	auipc	s2,0x0
 9ac:	2a090913          	addi	s2,s2,672 # c48 <malloc+0x15a>
        while(*s != 0){
 9b0:	02800593          	li	a1,40
 9b4:	bff1                	j	990 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 9b6:	008b0913          	addi	s2,s6,8
 9ba:	000b4583          	lbu	a1,0(s6)
 9be:	8556                	mv	a0,s5
 9c0:	00000097          	auipc	ra,0x0
 9c4:	d98080e7          	jalr	-616(ra) # 758 <putc>
 9c8:	8b4a                	mv	s6,s2
      state = 0;
 9ca:	4981                	li	s3,0
 9cc:	bd65                	j	884 <vprintf+0x60>
        putc(fd, c);
 9ce:	85d2                	mv	a1,s4
 9d0:	8556                	mv	a0,s5
 9d2:	00000097          	auipc	ra,0x0
 9d6:	d86080e7          	jalr	-634(ra) # 758 <putc>
      state = 0;
 9da:	4981                	li	s3,0
 9dc:	b565                	j	884 <vprintf+0x60>
        s = va_arg(ap, char*);
 9de:	8b4e                	mv	s6,s3
      state = 0;
 9e0:	4981                	li	s3,0
 9e2:	b54d                	j	884 <vprintf+0x60>
    }
  }
}
 9e4:	70e6                	ld	ra,120(sp)
 9e6:	7446                	ld	s0,112(sp)
 9e8:	74a6                	ld	s1,104(sp)
 9ea:	7906                	ld	s2,96(sp)
 9ec:	69e6                	ld	s3,88(sp)
 9ee:	6a46                	ld	s4,80(sp)
 9f0:	6aa6                	ld	s5,72(sp)
 9f2:	6b06                	ld	s6,64(sp)
 9f4:	7be2                	ld	s7,56(sp)
 9f6:	7c42                	ld	s8,48(sp)
 9f8:	7ca2                	ld	s9,40(sp)
 9fa:	7d02                	ld	s10,32(sp)
 9fc:	6de2                	ld	s11,24(sp)
 9fe:	6109                	addi	sp,sp,128
 a00:	8082                	ret

0000000000000a02 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a02:	715d                	addi	sp,sp,-80
 a04:	ec06                	sd	ra,24(sp)
 a06:	e822                	sd	s0,16(sp)
 a08:	1000                	addi	s0,sp,32
 a0a:	e010                	sd	a2,0(s0)
 a0c:	e414                	sd	a3,8(s0)
 a0e:	e818                	sd	a4,16(s0)
 a10:	ec1c                	sd	a5,24(s0)
 a12:	03043023          	sd	a6,32(s0)
 a16:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a1a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a1e:	8622                	mv	a2,s0
 a20:	00000097          	auipc	ra,0x0
 a24:	e04080e7          	jalr	-508(ra) # 824 <vprintf>
}
 a28:	60e2                	ld	ra,24(sp)
 a2a:	6442                	ld	s0,16(sp)
 a2c:	6161                	addi	sp,sp,80
 a2e:	8082                	ret

0000000000000a30 <printf>:

void
printf(const char *fmt, ...)
{
 a30:	711d                	addi	sp,sp,-96
 a32:	ec06                	sd	ra,24(sp)
 a34:	e822                	sd	s0,16(sp)
 a36:	1000                	addi	s0,sp,32
 a38:	e40c                	sd	a1,8(s0)
 a3a:	e810                	sd	a2,16(s0)
 a3c:	ec14                	sd	a3,24(s0)
 a3e:	f018                	sd	a4,32(s0)
 a40:	f41c                	sd	a5,40(s0)
 a42:	03043823          	sd	a6,48(s0)
 a46:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a4a:	00840613          	addi	a2,s0,8
 a4e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a52:	85aa                	mv	a1,a0
 a54:	4505                	li	a0,1
 a56:	00000097          	auipc	ra,0x0
 a5a:	dce080e7          	jalr	-562(ra) # 824 <vprintf>
}
 a5e:	60e2                	ld	ra,24(sp)
 a60:	6442                	ld	s0,16(sp)
 a62:	6125                	addi	sp,sp,96
 a64:	8082                	ret

0000000000000a66 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a66:	1141                	addi	sp,sp,-16
 a68:	e422                	sd	s0,8(sp)
 a6a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a6c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a70:	00000797          	auipc	a5,0x0
 a74:	1f87b783          	ld	a5,504(a5) # c68 <freep>
 a78:	a805                	j	aa8 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a7a:	4618                	lw	a4,8(a2)
 a7c:	9db9                	addw	a1,a1,a4
 a7e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a82:	6398                	ld	a4,0(a5)
 a84:	6318                	ld	a4,0(a4)
 a86:	fee53823          	sd	a4,-16(a0)
 a8a:	a091                	j	ace <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a8c:	ff852703          	lw	a4,-8(a0)
 a90:	9e39                	addw	a2,a2,a4
 a92:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 a94:	ff053703          	ld	a4,-16(a0)
 a98:	e398                	sd	a4,0(a5)
 a9a:	a099                	j	ae0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a9c:	6398                	ld	a4,0(a5)
 a9e:	00e7e463          	bltu	a5,a4,aa6 <free+0x40>
 aa2:	00e6ea63          	bltu	a3,a4,ab6 <free+0x50>
{
 aa6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aa8:	fed7fae3          	bgeu	a5,a3,a9c <free+0x36>
 aac:	6398                	ld	a4,0(a5)
 aae:	00e6e463          	bltu	a3,a4,ab6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ab2:	fee7eae3          	bltu	a5,a4,aa6 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 ab6:	ff852583          	lw	a1,-8(a0)
 aba:	6390                	ld	a2,0(a5)
 abc:	02059813          	slli	a6,a1,0x20
 ac0:	01c85713          	srli	a4,a6,0x1c
 ac4:	9736                	add	a4,a4,a3
 ac6:	fae60ae3          	beq	a2,a4,a7a <free+0x14>
    bp->s.ptr = p->s.ptr;
 aca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ace:	4790                	lw	a2,8(a5)
 ad0:	02061593          	slli	a1,a2,0x20
 ad4:	01c5d713          	srli	a4,a1,0x1c
 ad8:	973e                	add	a4,a4,a5
 ada:	fae689e3          	beq	a3,a4,a8c <free+0x26>
  } else
    p->s.ptr = bp;
 ade:	e394                	sd	a3,0(a5)
  freep = p;
 ae0:	00000717          	auipc	a4,0x0
 ae4:	18f73423          	sd	a5,392(a4) # c68 <freep>
}
 ae8:	6422                	ld	s0,8(sp)
 aea:	0141                	addi	sp,sp,16
 aec:	8082                	ret

0000000000000aee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 aee:	7139                	addi	sp,sp,-64
 af0:	fc06                	sd	ra,56(sp)
 af2:	f822                	sd	s0,48(sp)
 af4:	f426                	sd	s1,40(sp)
 af6:	f04a                	sd	s2,32(sp)
 af8:	ec4e                	sd	s3,24(sp)
 afa:	e852                	sd	s4,16(sp)
 afc:	e456                	sd	s5,8(sp)
 afe:	e05a                	sd	s6,0(sp)
 b00:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b02:	02051493          	slli	s1,a0,0x20
 b06:	9081                	srli	s1,s1,0x20
 b08:	04bd                	addi	s1,s1,15
 b0a:	8091                	srli	s1,s1,0x4
 b0c:	0014899b          	addiw	s3,s1,1
 b10:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b12:	00000517          	auipc	a0,0x0
 b16:	15653503          	ld	a0,342(a0) # c68 <freep>
 b1a:	c515                	beqz	a0,b46 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b1c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b1e:	4798                	lw	a4,8(a5)
 b20:	02977f63          	bgeu	a4,s1,b5e <malloc+0x70>
 b24:	8a4e                	mv	s4,s3
 b26:	0009871b          	sext.w	a4,s3
 b2a:	6685                	lui	a3,0x1
 b2c:	00d77363          	bgeu	a4,a3,b32 <malloc+0x44>
 b30:	6a05                	lui	s4,0x1
 b32:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b36:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b3a:	00000917          	auipc	s2,0x0
 b3e:	12e90913          	addi	s2,s2,302 # c68 <freep>
  if(p == (char*)-1)
 b42:	5afd                	li	s5,-1
 b44:	a895                	j	bb8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 b46:	00000797          	auipc	a5,0x0
 b4a:	13a78793          	addi	a5,a5,314 # c80 <base>
 b4e:	00000717          	auipc	a4,0x0
 b52:	10f73d23          	sd	a5,282(a4) # c68 <freep>
 b56:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b58:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b5c:	b7e1                	j	b24 <malloc+0x36>
      if(p->s.size == nunits)
 b5e:	02e48c63          	beq	s1,a4,b96 <malloc+0xa8>
        p->s.size -= nunits;
 b62:	4137073b          	subw	a4,a4,s3
 b66:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b68:	02071693          	slli	a3,a4,0x20
 b6c:	01c6d713          	srli	a4,a3,0x1c
 b70:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b72:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b76:	00000717          	auipc	a4,0x0
 b7a:	0ea73923          	sd	a0,242(a4) # c68 <freep>
      return (void*)(p + 1);
 b7e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b82:	70e2                	ld	ra,56(sp)
 b84:	7442                	ld	s0,48(sp)
 b86:	74a2                	ld	s1,40(sp)
 b88:	7902                	ld	s2,32(sp)
 b8a:	69e2                	ld	s3,24(sp)
 b8c:	6a42                	ld	s4,16(sp)
 b8e:	6aa2                	ld	s5,8(sp)
 b90:	6b02                	ld	s6,0(sp)
 b92:	6121                	addi	sp,sp,64
 b94:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b96:	6398                	ld	a4,0(a5)
 b98:	e118                	sd	a4,0(a0)
 b9a:	bff1                	j	b76 <malloc+0x88>
  hp->s.size = nu;
 b9c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ba0:	0541                	addi	a0,a0,16
 ba2:	00000097          	auipc	ra,0x0
 ba6:	ec4080e7          	jalr	-316(ra) # a66 <free>
  return freep;
 baa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bae:	d971                	beqz	a0,b82 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bb0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bb2:	4798                	lw	a4,8(a5)
 bb4:	fa9775e3          	bgeu	a4,s1,b5e <malloc+0x70>
    if(p == freep)
 bb8:	00093703          	ld	a4,0(s2)
 bbc:	853e                	mv	a0,a5
 bbe:	fef719e3          	bne	a4,a5,bb0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 bc2:	8552                	mv	a0,s4
 bc4:	00000097          	auipc	ra,0x0
 bc8:	b22080e7          	jalr	-1246(ra) # 6e6 <sbrk>
  if(p == (char*)-1)
 bcc:	fd5518e3          	bne	a0,s5,b9c <malloc+0xae>
        return 0;
 bd0:	4501                	li	a0,0
 bd2:	bf45                	j	b82 <malloc+0x94>
