
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  fprintf(2, "$ ");
      10:	00001597          	auipc	a1,0x1
      14:	44858593          	addi	a1,a1,1096 # 1458 <malloc+0xea>
      18:	4509                	li	a0,2
      1a:	00001097          	auipc	ra,0x1
      1e:	268080e7          	jalr	616(ra) # 1282 <fprintf>
  memset(buf, 0, nbuf);
      22:	864a                	mv	a2,s2
      24:	4581                	li	a1,0
      26:	8526                	mv	a0,s1
      28:	00001097          	auipc	ra,0x1
      2c:	b9e080e7          	jalr	-1122(ra) # bc6 <memset>
  gets(buf, nbuf);
      30:	85ca                	mv	a1,s2
      32:	8526                	mv	a0,s1
      34:	00001097          	auipc	ra,0x1
      38:	bd8080e7          	jalr	-1064(ra) # c0c <gets>
  if(buf[0] == 0) // EOF
      3c:	0004c503          	lbu	a0,0(s1)
      40:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      44:	40a00533          	neg	a0,a0
      48:	60e2                	ld	ra,24(sp)
      4a:	6442                	ld	s0,16(sp)
      4c:	64a2                	ld	s1,8(sp)
      4e:	6902                	ld	s2,0(sp)
      50:	6105                	addi	sp,sp,32
      52:	8082                	ret

0000000000000054 <panic>:
  exit(0);
}

void
panic(char *s)
{
      54:	1141                	addi	sp,sp,-16
      56:	e406                	sd	ra,8(sp)
      58:	e022                	sd	s0,0(sp)
      5a:	0800                	addi	s0,sp,16
      5c:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      5e:	00001597          	auipc	a1,0x1
      62:	40258593          	addi	a1,a1,1026 # 1460 <malloc+0xf2>
      66:	4509                	li	a0,2
      68:	00001097          	auipc	ra,0x1
      6c:	21a080e7          	jalr	538(ra) # 1282 <fprintf>
  exit(1);
      70:	4505                	li	a0,1
      72:	00001097          	auipc	ra,0x1
      76:	e6c080e7          	jalr	-404(ra) # ede <exit>

000000000000007a <fork1>:
}

int
fork1(void)
{
      7a:	1141                	addi	sp,sp,-16
      7c:	e406                	sd	ra,8(sp)
      7e:	e022                	sd	s0,0(sp)
      80:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      82:	00001097          	auipc	ra,0x1
      86:	e54080e7          	jalr	-428(ra) # ed6 <fork>
  if(pid == -1)
      8a:	57fd                	li	a5,-1
      8c:	00f50663          	beq	a0,a5,98 <fork1+0x1e>
    panic("fork");
  return pid;
}
      90:	60a2                	ld	ra,8(sp)
      92:	6402                	ld	s0,0(sp)
      94:	0141                	addi	sp,sp,16
      96:	8082                	ret
    panic("fork");
      98:	00001517          	auipc	a0,0x1
      9c:	3d050513          	addi	a0,a0,976 # 1468 <malloc+0xfa>
      a0:	00000097          	auipc	ra,0x0
      a4:	fb4080e7          	jalr	-76(ra) # 54 <panic>

00000000000000a8 <runcmd>:
{
      a8:	7179                	addi	sp,sp,-48
      aa:	f406                	sd	ra,40(sp)
      ac:	f022                	sd	s0,32(sp)
      ae:	ec26                	sd	s1,24(sp)
      b0:	1800                	addi	s0,sp,48
  if(cmd == 0)
      b2:	c10d                	beqz	a0,d4 <runcmd+0x2c>
      b4:	84aa                	mv	s1,a0
  switch(cmd->type){
      b6:	4118                	lw	a4,0(a0)
      b8:	4795                	li	a5,5
      ba:	02e7e263          	bltu	a5,a4,de <runcmd+0x36>
      be:	00056783          	lwu	a5,0(a0)
      c2:	078a                	slli	a5,a5,0x2
      c4:	00001717          	auipc	a4,0x1
      c8:	4a470713          	addi	a4,a4,1188 # 1568 <malloc+0x1fa>
      cc:	97ba                	add	a5,a5,a4
      ce:	439c                	lw	a5,0(a5)
      d0:	97ba                	add	a5,a5,a4
      d2:	8782                	jr	a5
    exit(1);
      d4:	4505                	li	a0,1
      d6:	00001097          	auipc	ra,0x1
      da:	e08080e7          	jalr	-504(ra) # ede <exit>
    panic("runcmd");
      de:	00001517          	auipc	a0,0x1
      e2:	39250513          	addi	a0,a0,914 # 1470 <malloc+0x102>
      e6:	00000097          	auipc	ra,0x0
      ea:	f6e080e7          	jalr	-146(ra) # 54 <panic>
    if(ecmd->argv[0] == 0)
      ee:	6508                	ld	a0,8(a0)
      f0:	c515                	beqz	a0,11c <runcmd+0x74>
    exec(ecmd->argv[0], ecmd->argv);
      f2:	00848593          	addi	a1,s1,8
      f6:	00001097          	auipc	ra,0x1
      fa:	e20080e7          	jalr	-480(ra) # f16 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      fe:	6490                	ld	a2,8(s1)
     100:	00001597          	auipc	a1,0x1
     104:	37858593          	addi	a1,a1,888 # 1478 <malloc+0x10a>
     108:	4509                	li	a0,2
     10a:	00001097          	auipc	ra,0x1
     10e:	178080e7          	jalr	376(ra) # 1282 <fprintf>
  exit(0);
     112:	4501                	li	a0,0
     114:	00001097          	auipc	ra,0x1
     118:	dca080e7          	jalr	-566(ra) # ede <exit>
      exit(1);
     11c:	4505                	li	a0,1
     11e:	00001097          	auipc	ra,0x1
     122:	dc0080e7          	jalr	-576(ra) # ede <exit>
    close(rcmd->fd);
     126:	5148                	lw	a0,36(a0)
     128:	00001097          	auipc	ra,0x1
     12c:	dde080e7          	jalr	-546(ra) # f06 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     130:	508c                	lw	a1,32(s1)
     132:	6888                	ld	a0,16(s1)
     134:	00001097          	auipc	ra,0x1
     138:	dea080e7          	jalr	-534(ra) # f1e <open>
     13c:	00054763          	bltz	a0,14a <runcmd+0xa2>
    runcmd(rcmd->cmd);
     140:	6488                	ld	a0,8(s1)
     142:	00000097          	auipc	ra,0x0
     146:	f66080e7          	jalr	-154(ra) # a8 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     14a:	6890                	ld	a2,16(s1)
     14c:	00001597          	auipc	a1,0x1
     150:	33c58593          	addi	a1,a1,828 # 1488 <malloc+0x11a>
     154:	4509                	li	a0,2
     156:	00001097          	auipc	ra,0x1
     15a:	12c080e7          	jalr	300(ra) # 1282 <fprintf>
      exit(1);
     15e:	4505                	li	a0,1
     160:	00001097          	auipc	ra,0x1
     164:	d7e080e7          	jalr	-642(ra) # ede <exit>
    if(fork1() == 0)
     168:	00000097          	auipc	ra,0x0
     16c:	f12080e7          	jalr	-238(ra) # 7a <fork1>
     170:	c919                	beqz	a0,186 <runcmd+0xde>
    wait(0);
     172:	4501                	li	a0,0
     174:	00001097          	auipc	ra,0x1
     178:	d72080e7          	jalr	-654(ra) # ee6 <wait>
    runcmd(lcmd->right);
     17c:	6888                	ld	a0,16(s1)
     17e:	00000097          	auipc	ra,0x0
     182:	f2a080e7          	jalr	-214(ra) # a8 <runcmd>
      runcmd(lcmd->left);
     186:	6488                	ld	a0,8(s1)
     188:	00000097          	auipc	ra,0x0
     18c:	f20080e7          	jalr	-224(ra) # a8 <runcmd>
    if(pipe(p) < 0)
     190:	fd840513          	addi	a0,s0,-40
     194:	00001097          	auipc	ra,0x1
     198:	d5a080e7          	jalr	-678(ra) # eee <pipe>
     19c:	04054363          	bltz	a0,1e2 <runcmd+0x13a>
    if(fork1() == 0){
     1a0:	00000097          	auipc	ra,0x0
     1a4:	eda080e7          	jalr	-294(ra) # 7a <fork1>
     1a8:	c529                	beqz	a0,1f2 <runcmd+0x14a>
    if(fork1() == 0){
     1aa:	00000097          	auipc	ra,0x0
     1ae:	ed0080e7          	jalr	-304(ra) # 7a <fork1>
     1b2:	cd25                	beqz	a0,22a <runcmd+0x182>
    close(p[0]);
     1b4:	fd842503          	lw	a0,-40(s0)
     1b8:	00001097          	auipc	ra,0x1
     1bc:	d4e080e7          	jalr	-690(ra) # f06 <close>
    close(p[1]);
     1c0:	fdc42503          	lw	a0,-36(s0)
     1c4:	00001097          	auipc	ra,0x1
     1c8:	d42080e7          	jalr	-702(ra) # f06 <close>
    wait(0);
     1cc:	4501                	li	a0,0
     1ce:	00001097          	auipc	ra,0x1
     1d2:	d18080e7          	jalr	-744(ra) # ee6 <wait>
    wait(0);
     1d6:	4501                	li	a0,0
     1d8:	00001097          	auipc	ra,0x1
     1dc:	d0e080e7          	jalr	-754(ra) # ee6 <wait>
    break;
     1e0:	bf0d                	j	112 <runcmd+0x6a>
      panic("pipe");
     1e2:	00001517          	auipc	a0,0x1
     1e6:	2b650513          	addi	a0,a0,694 # 1498 <malloc+0x12a>
     1ea:	00000097          	auipc	ra,0x0
     1ee:	e6a080e7          	jalr	-406(ra) # 54 <panic>
      close(1);
     1f2:	4505                	li	a0,1
     1f4:	00001097          	auipc	ra,0x1
     1f8:	d12080e7          	jalr	-750(ra) # f06 <close>
      dup(p[1]);
     1fc:	fdc42503          	lw	a0,-36(s0)
     200:	00001097          	auipc	ra,0x1
     204:	d56080e7          	jalr	-682(ra) # f56 <dup>
      close(p[0]);
     208:	fd842503          	lw	a0,-40(s0)
     20c:	00001097          	auipc	ra,0x1
     210:	cfa080e7          	jalr	-774(ra) # f06 <close>
      close(p[1]);
     214:	fdc42503          	lw	a0,-36(s0)
     218:	00001097          	auipc	ra,0x1
     21c:	cee080e7          	jalr	-786(ra) # f06 <close>
      runcmd(pcmd->left);
     220:	6488                	ld	a0,8(s1)
     222:	00000097          	auipc	ra,0x0
     226:	e86080e7          	jalr	-378(ra) # a8 <runcmd>
      close(0);
     22a:	00001097          	auipc	ra,0x1
     22e:	cdc080e7          	jalr	-804(ra) # f06 <close>
      dup(p[0]);
     232:	fd842503          	lw	a0,-40(s0)
     236:	00001097          	auipc	ra,0x1
     23a:	d20080e7          	jalr	-736(ra) # f56 <dup>
      close(p[0]);
     23e:	fd842503          	lw	a0,-40(s0)
     242:	00001097          	auipc	ra,0x1
     246:	cc4080e7          	jalr	-828(ra) # f06 <close>
      close(p[1]);
     24a:	fdc42503          	lw	a0,-36(s0)
     24e:	00001097          	auipc	ra,0x1
     252:	cb8080e7          	jalr	-840(ra) # f06 <close>
      runcmd(pcmd->right);
     256:	6888                	ld	a0,16(s1)
     258:	00000097          	auipc	ra,0x0
     25c:	e50080e7          	jalr	-432(ra) # a8 <runcmd>
    if(fork1() == 0)
     260:	00000097          	auipc	ra,0x0
     264:	e1a080e7          	jalr	-486(ra) # 7a <fork1>
     268:	ea0515e3          	bnez	a0,112 <runcmd+0x6a>
      runcmd(bcmd->cmd);
     26c:	6488                	ld	a0,8(s1)
     26e:	00000097          	auipc	ra,0x0
     272:	e3a080e7          	jalr	-454(ra) # a8 <runcmd>

0000000000000276 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     276:	1101                	addi	sp,sp,-32
     278:	ec06                	sd	ra,24(sp)
     27a:	e822                	sd	s0,16(sp)
     27c:	e426                	sd	s1,8(sp)
     27e:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     280:	0a800513          	li	a0,168
     284:	00001097          	auipc	ra,0x1
     288:	0ea080e7          	jalr	234(ra) # 136e <malloc>
     28c:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     28e:	0a800613          	li	a2,168
     292:	4581                	li	a1,0
     294:	00001097          	auipc	ra,0x1
     298:	932080e7          	jalr	-1742(ra) # bc6 <memset>
  cmd->type = EXEC;
     29c:	4785                	li	a5,1
     29e:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2a0:	8526                	mv	a0,s1
     2a2:	60e2                	ld	ra,24(sp)
     2a4:	6442                	ld	s0,16(sp)
     2a6:	64a2                	ld	s1,8(sp)
     2a8:	6105                	addi	sp,sp,32
     2aa:	8082                	ret

00000000000002ac <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2ac:	7139                	addi	sp,sp,-64
     2ae:	fc06                	sd	ra,56(sp)
     2b0:	f822                	sd	s0,48(sp)
     2b2:	f426                	sd	s1,40(sp)
     2b4:	f04a                	sd	s2,32(sp)
     2b6:	ec4e                	sd	s3,24(sp)
     2b8:	e852                	sd	s4,16(sp)
     2ba:	e456                	sd	s5,8(sp)
     2bc:	e05a                	sd	s6,0(sp)
     2be:	0080                	addi	s0,sp,64
     2c0:	8b2a                	mv	s6,a0
     2c2:	8aae                	mv	s5,a1
     2c4:	8a32                	mv	s4,a2
     2c6:	89b6                	mv	s3,a3
     2c8:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ca:	02800513          	li	a0,40
     2ce:	00001097          	auipc	ra,0x1
     2d2:	0a0080e7          	jalr	160(ra) # 136e <malloc>
     2d6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2d8:	02800613          	li	a2,40
     2dc:	4581                	li	a1,0
     2de:	00001097          	auipc	ra,0x1
     2e2:	8e8080e7          	jalr	-1816(ra) # bc6 <memset>
  cmd->type = REDIR;
     2e6:	4789                	li	a5,2
     2e8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2ea:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     2ee:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     2f2:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     2f6:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     2fa:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     2fe:	8526                	mv	a0,s1
     300:	70e2                	ld	ra,56(sp)
     302:	7442                	ld	s0,48(sp)
     304:	74a2                	ld	s1,40(sp)
     306:	7902                	ld	s2,32(sp)
     308:	69e2                	ld	s3,24(sp)
     30a:	6a42                	ld	s4,16(sp)
     30c:	6aa2                	ld	s5,8(sp)
     30e:	6b02                	ld	s6,0(sp)
     310:	6121                	addi	sp,sp,64
     312:	8082                	ret

0000000000000314 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     314:	7179                	addi	sp,sp,-48
     316:	f406                	sd	ra,40(sp)
     318:	f022                	sd	s0,32(sp)
     31a:	ec26                	sd	s1,24(sp)
     31c:	e84a                	sd	s2,16(sp)
     31e:	e44e                	sd	s3,8(sp)
     320:	1800                	addi	s0,sp,48
     322:	89aa                	mv	s3,a0
     324:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     326:	4561                	li	a0,24
     328:	00001097          	auipc	ra,0x1
     32c:	046080e7          	jalr	70(ra) # 136e <malloc>
     330:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     332:	4661                	li	a2,24
     334:	4581                	li	a1,0
     336:	00001097          	auipc	ra,0x1
     33a:	890080e7          	jalr	-1904(ra) # bc6 <memset>
  cmd->type = PIPE;
     33e:	478d                	li	a5,3
     340:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     342:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     346:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     34a:	8526                	mv	a0,s1
     34c:	70a2                	ld	ra,40(sp)
     34e:	7402                	ld	s0,32(sp)
     350:	64e2                	ld	s1,24(sp)
     352:	6942                	ld	s2,16(sp)
     354:	69a2                	ld	s3,8(sp)
     356:	6145                	addi	sp,sp,48
     358:	8082                	ret

000000000000035a <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     35a:	7179                	addi	sp,sp,-48
     35c:	f406                	sd	ra,40(sp)
     35e:	f022                	sd	s0,32(sp)
     360:	ec26                	sd	s1,24(sp)
     362:	e84a                	sd	s2,16(sp)
     364:	e44e                	sd	s3,8(sp)
     366:	1800                	addi	s0,sp,48
     368:	89aa                	mv	s3,a0
     36a:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     36c:	4561                	li	a0,24
     36e:	00001097          	auipc	ra,0x1
     372:	000080e7          	jalr	ra # 136e <malloc>
     376:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     378:	4661                	li	a2,24
     37a:	4581                	li	a1,0
     37c:	00001097          	auipc	ra,0x1
     380:	84a080e7          	jalr	-1974(ra) # bc6 <memset>
  cmd->type = LIST;
     384:	4791                	li	a5,4
     386:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     388:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     38c:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     390:	8526                	mv	a0,s1
     392:	70a2                	ld	ra,40(sp)
     394:	7402                	ld	s0,32(sp)
     396:	64e2                	ld	s1,24(sp)
     398:	6942                	ld	s2,16(sp)
     39a:	69a2                	ld	s3,8(sp)
     39c:	6145                	addi	sp,sp,48
     39e:	8082                	ret

00000000000003a0 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3a0:	1101                	addi	sp,sp,-32
     3a2:	ec06                	sd	ra,24(sp)
     3a4:	e822                	sd	s0,16(sp)
     3a6:	e426                	sd	s1,8(sp)
     3a8:	e04a                	sd	s2,0(sp)
     3aa:	1000                	addi	s0,sp,32
     3ac:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3ae:	4541                	li	a0,16
     3b0:	00001097          	auipc	ra,0x1
     3b4:	fbe080e7          	jalr	-66(ra) # 136e <malloc>
     3b8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3ba:	4641                	li	a2,16
     3bc:	4581                	li	a1,0
     3be:	00001097          	auipc	ra,0x1
     3c2:	808080e7          	jalr	-2040(ra) # bc6 <memset>
  cmd->type = BACK;
     3c6:	4795                	li	a5,5
     3c8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3ca:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3ce:	8526                	mv	a0,s1
     3d0:	60e2                	ld	ra,24(sp)
     3d2:	6442                	ld	s0,16(sp)
     3d4:	64a2                	ld	s1,8(sp)
     3d6:	6902                	ld	s2,0(sp)
     3d8:	6105                	addi	sp,sp,32
     3da:	8082                	ret

00000000000003dc <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3dc:	7139                	addi	sp,sp,-64
     3de:	fc06                	sd	ra,56(sp)
     3e0:	f822                	sd	s0,48(sp)
     3e2:	f426                	sd	s1,40(sp)
     3e4:	f04a                	sd	s2,32(sp)
     3e6:	ec4e                	sd	s3,24(sp)
     3e8:	e852                	sd	s4,16(sp)
     3ea:	e456                	sd	s5,8(sp)
     3ec:	e05a                	sd	s6,0(sp)
     3ee:	0080                	addi	s0,sp,64
     3f0:	8a2a                	mv	s4,a0
     3f2:	892e                	mv	s2,a1
     3f4:	8ab2                	mv	s5,a2
     3f6:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     3f8:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     3fa:	00001997          	auipc	s3,0x1
     3fe:	1c698993          	addi	s3,s3,454 # 15c0 <whitespace>
     402:	00b4fd63          	bgeu	s1,a1,41c <gettoken+0x40>
     406:	0004c583          	lbu	a1,0(s1)
     40a:	854e                	mv	a0,s3
     40c:	00000097          	auipc	ra,0x0
     410:	7dc080e7          	jalr	2012(ra) # be8 <strchr>
     414:	c501                	beqz	a0,41c <gettoken+0x40>
    s++;
     416:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     418:	fe9917e3          	bne	s2,s1,406 <gettoken+0x2a>
  if(q)
     41c:	000a8463          	beqz	s5,424 <gettoken+0x48>
    *q = s;
     420:	009ab023          	sd	s1,0(s5)
  ret = *s;
     424:	0004c783          	lbu	a5,0(s1)
     428:	00078a9b          	sext.w	s5,a5
  switch(*s){
     42c:	03c00713          	li	a4,60
     430:	06f76563          	bltu	a4,a5,49a <gettoken+0xbe>
     434:	03a00713          	li	a4,58
     438:	00f76e63          	bltu	a4,a5,454 <gettoken+0x78>
     43c:	cf89                	beqz	a5,456 <gettoken+0x7a>
     43e:	02600713          	li	a4,38
     442:	00e78963          	beq	a5,a4,454 <gettoken+0x78>
     446:	fd87879b          	addiw	a5,a5,-40
     44a:	0ff7f793          	andi	a5,a5,255
     44e:	4705                	li	a4,1
     450:	06f76c63          	bltu	a4,a5,4c8 <gettoken+0xec>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     454:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     456:	000b0463          	beqz	s6,45e <gettoken+0x82>
    *eq = s;
     45a:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     45e:	00001997          	auipc	s3,0x1
     462:	16298993          	addi	s3,s3,354 # 15c0 <whitespace>
     466:	0124fd63          	bgeu	s1,s2,480 <gettoken+0xa4>
     46a:	0004c583          	lbu	a1,0(s1)
     46e:	854e                	mv	a0,s3
     470:	00000097          	auipc	ra,0x0
     474:	778080e7          	jalr	1912(ra) # be8 <strchr>
     478:	c501                	beqz	a0,480 <gettoken+0xa4>
    s++;
     47a:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     47c:	fe9917e3          	bne	s2,s1,46a <gettoken+0x8e>
  *ps = s;
     480:	009a3023          	sd	s1,0(s4)
  return ret;
}
     484:	8556                	mv	a0,s5
     486:	70e2                	ld	ra,56(sp)
     488:	7442                	ld	s0,48(sp)
     48a:	74a2                	ld	s1,40(sp)
     48c:	7902                	ld	s2,32(sp)
     48e:	69e2                	ld	s3,24(sp)
     490:	6a42                	ld	s4,16(sp)
     492:	6aa2                	ld	s5,8(sp)
     494:	6b02                	ld	s6,0(sp)
     496:	6121                	addi	sp,sp,64
     498:	8082                	ret
  switch(*s){
     49a:	03e00713          	li	a4,62
     49e:	02e79163          	bne	a5,a4,4c0 <gettoken+0xe4>
    s++;
     4a2:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     4a6:	0014c703          	lbu	a4,1(s1)
     4aa:	03e00793          	li	a5,62
      s++;
     4ae:	0489                	addi	s1,s1,2
      ret = '+';
     4b0:	02b00a93          	li	s5,43
    if(*s == '>'){
     4b4:	faf701e3          	beq	a4,a5,456 <gettoken+0x7a>
    s++;
     4b8:	84b6                	mv	s1,a3
  ret = *s;
     4ba:	03e00a93          	li	s5,62
     4be:	bf61                	j	456 <gettoken+0x7a>
  switch(*s){
     4c0:	07c00713          	li	a4,124
     4c4:	f8e788e3          	beq	a5,a4,454 <gettoken+0x78>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4c8:	00001997          	auipc	s3,0x1
     4cc:	0f898993          	addi	s3,s3,248 # 15c0 <whitespace>
     4d0:	00001a97          	auipc	s5,0x1
     4d4:	0e8a8a93          	addi	s5,s5,232 # 15b8 <symbols>
     4d8:	0324f563          	bgeu	s1,s2,502 <gettoken+0x126>
     4dc:	0004c583          	lbu	a1,0(s1)
     4e0:	854e                	mv	a0,s3
     4e2:	00000097          	auipc	ra,0x0
     4e6:	706080e7          	jalr	1798(ra) # be8 <strchr>
     4ea:	e505                	bnez	a0,512 <gettoken+0x136>
     4ec:	0004c583          	lbu	a1,0(s1)
     4f0:	8556                	mv	a0,s5
     4f2:	00000097          	auipc	ra,0x0
     4f6:	6f6080e7          	jalr	1782(ra) # be8 <strchr>
     4fa:	e909                	bnez	a0,50c <gettoken+0x130>
      s++;
     4fc:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4fe:	fc991fe3          	bne	s2,s1,4dc <gettoken+0x100>
  if(eq)
     502:	06100a93          	li	s5,97
     506:	f40b1ae3          	bnez	s6,45a <gettoken+0x7e>
     50a:	bf9d                	j	480 <gettoken+0xa4>
    ret = 'a';
     50c:	06100a93          	li	s5,97
     510:	b799                	j	456 <gettoken+0x7a>
     512:	06100a93          	li	s5,97
     516:	b781                	j	456 <gettoken+0x7a>

0000000000000518 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     518:	7139                	addi	sp,sp,-64
     51a:	fc06                	sd	ra,56(sp)
     51c:	f822                	sd	s0,48(sp)
     51e:	f426                	sd	s1,40(sp)
     520:	f04a                	sd	s2,32(sp)
     522:	ec4e                	sd	s3,24(sp)
     524:	e852                	sd	s4,16(sp)
     526:	e456                	sd	s5,8(sp)
     528:	0080                	addi	s0,sp,64
     52a:	8a2a                	mv	s4,a0
     52c:	892e                	mv	s2,a1
     52e:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     530:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     532:	00001997          	auipc	s3,0x1
     536:	08e98993          	addi	s3,s3,142 # 15c0 <whitespace>
     53a:	00b4fd63          	bgeu	s1,a1,554 <peek+0x3c>
     53e:	0004c583          	lbu	a1,0(s1)
     542:	854e                	mv	a0,s3
     544:	00000097          	auipc	ra,0x0
     548:	6a4080e7          	jalr	1700(ra) # be8 <strchr>
     54c:	c501                	beqz	a0,554 <peek+0x3c>
    s++;
     54e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     550:	fe9917e3          	bne	s2,s1,53e <peek+0x26>
  *ps = s;
     554:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     558:	0004c583          	lbu	a1,0(s1)
     55c:	4501                	li	a0,0
     55e:	e991                	bnez	a1,572 <peek+0x5a>
}
     560:	70e2                	ld	ra,56(sp)
     562:	7442                	ld	s0,48(sp)
     564:	74a2                	ld	s1,40(sp)
     566:	7902                	ld	s2,32(sp)
     568:	69e2                	ld	s3,24(sp)
     56a:	6a42                	ld	s4,16(sp)
     56c:	6aa2                	ld	s5,8(sp)
     56e:	6121                	addi	sp,sp,64
     570:	8082                	ret
  return *s && strchr(toks, *s);
     572:	8556                	mv	a0,s5
     574:	00000097          	auipc	ra,0x0
     578:	674080e7          	jalr	1652(ra) # be8 <strchr>
     57c:	00a03533          	snez	a0,a0
     580:	b7c5                	j	560 <peek+0x48>

0000000000000582 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     582:	7159                	addi	sp,sp,-112
     584:	f486                	sd	ra,104(sp)
     586:	f0a2                	sd	s0,96(sp)
     588:	eca6                	sd	s1,88(sp)
     58a:	e8ca                	sd	s2,80(sp)
     58c:	e4ce                	sd	s3,72(sp)
     58e:	e0d2                	sd	s4,64(sp)
     590:	fc56                	sd	s5,56(sp)
     592:	f85a                	sd	s6,48(sp)
     594:	f45e                	sd	s7,40(sp)
     596:	f062                	sd	s8,32(sp)
     598:	ec66                	sd	s9,24(sp)
     59a:	1880                	addi	s0,sp,112
     59c:	8a2a                	mv	s4,a0
     59e:	89ae                	mv	s3,a1
     5a0:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5a2:	00001b97          	auipc	s7,0x1
     5a6:	f1eb8b93          	addi	s7,s7,-226 # 14c0 <malloc+0x152>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5aa:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     5ae:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     5b2:	a02d                	j	5dc <parseredirs+0x5a>
      panic("missing file for redirection");
     5b4:	00001517          	auipc	a0,0x1
     5b8:	eec50513          	addi	a0,a0,-276 # 14a0 <malloc+0x132>
     5bc:	00000097          	auipc	ra,0x0
     5c0:	a98080e7          	jalr	-1384(ra) # 54 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5c4:	4701                	li	a4,0
     5c6:	4681                	li	a3,0
     5c8:	f9043603          	ld	a2,-112(s0)
     5cc:	f9843583          	ld	a1,-104(s0)
     5d0:	8552                	mv	a0,s4
     5d2:	00000097          	auipc	ra,0x0
     5d6:	cda080e7          	jalr	-806(ra) # 2ac <redircmd>
     5da:	8a2a                	mv	s4,a0
    switch(tok){
     5dc:	03e00b13          	li	s6,62
     5e0:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     5e4:	865e                	mv	a2,s7
     5e6:	85ca                	mv	a1,s2
     5e8:	854e                	mv	a0,s3
     5ea:	00000097          	auipc	ra,0x0
     5ee:	f2e080e7          	jalr	-210(ra) # 518 <peek>
     5f2:	c925                	beqz	a0,662 <parseredirs+0xe0>
    tok = gettoken(ps, es, 0, 0);
     5f4:	4681                	li	a3,0
     5f6:	4601                	li	a2,0
     5f8:	85ca                	mv	a1,s2
     5fa:	854e                	mv	a0,s3
     5fc:	00000097          	auipc	ra,0x0
     600:	de0080e7          	jalr	-544(ra) # 3dc <gettoken>
     604:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     606:	f9040693          	addi	a3,s0,-112
     60a:	f9840613          	addi	a2,s0,-104
     60e:	85ca                	mv	a1,s2
     610:	854e                	mv	a0,s3
     612:	00000097          	auipc	ra,0x0
     616:	dca080e7          	jalr	-566(ra) # 3dc <gettoken>
     61a:	f9851de3          	bne	a0,s8,5b4 <parseredirs+0x32>
    switch(tok){
     61e:	fb9483e3          	beq	s1,s9,5c4 <parseredirs+0x42>
     622:	03648263          	beq	s1,s6,646 <parseredirs+0xc4>
     626:	fb549fe3          	bne	s1,s5,5e4 <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     62a:	4705                	li	a4,1
     62c:	20100693          	li	a3,513
     630:	f9043603          	ld	a2,-112(s0)
     634:	f9843583          	ld	a1,-104(s0)
     638:	8552                	mv	a0,s4
     63a:	00000097          	auipc	ra,0x0
     63e:	c72080e7          	jalr	-910(ra) # 2ac <redircmd>
     642:	8a2a                	mv	s4,a0
      break;
     644:	bf61                	j	5dc <parseredirs+0x5a>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     646:	4705                	li	a4,1
     648:	60100693          	li	a3,1537
     64c:	f9043603          	ld	a2,-112(s0)
     650:	f9843583          	ld	a1,-104(s0)
     654:	8552                	mv	a0,s4
     656:	00000097          	auipc	ra,0x0
     65a:	c56080e7          	jalr	-938(ra) # 2ac <redircmd>
     65e:	8a2a                	mv	s4,a0
      break;
     660:	bfb5                	j	5dc <parseredirs+0x5a>
    }
  }
  return cmd;
}
     662:	8552                	mv	a0,s4
     664:	70a6                	ld	ra,104(sp)
     666:	7406                	ld	s0,96(sp)
     668:	64e6                	ld	s1,88(sp)
     66a:	6946                	ld	s2,80(sp)
     66c:	69a6                	ld	s3,72(sp)
     66e:	6a06                	ld	s4,64(sp)
     670:	7ae2                	ld	s5,56(sp)
     672:	7b42                	ld	s6,48(sp)
     674:	7ba2                	ld	s7,40(sp)
     676:	7c02                	ld	s8,32(sp)
     678:	6ce2                	ld	s9,24(sp)
     67a:	6165                	addi	sp,sp,112
     67c:	8082                	ret

000000000000067e <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     67e:	7159                	addi	sp,sp,-112
     680:	f486                	sd	ra,104(sp)
     682:	f0a2                	sd	s0,96(sp)
     684:	eca6                	sd	s1,88(sp)
     686:	e8ca                	sd	s2,80(sp)
     688:	e4ce                	sd	s3,72(sp)
     68a:	e0d2                	sd	s4,64(sp)
     68c:	fc56                	sd	s5,56(sp)
     68e:	f85a                	sd	s6,48(sp)
     690:	f45e                	sd	s7,40(sp)
     692:	f062                	sd	s8,32(sp)
     694:	ec66                	sd	s9,24(sp)
     696:	1880                	addi	s0,sp,112
     698:	8a2a                	mv	s4,a0
     69a:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     69c:	00001617          	auipc	a2,0x1
     6a0:	e2c60613          	addi	a2,a2,-468 # 14c8 <malloc+0x15a>
     6a4:	00000097          	auipc	ra,0x0
     6a8:	e74080e7          	jalr	-396(ra) # 518 <peek>
     6ac:	e905                	bnez	a0,6dc <parseexec+0x5e>
     6ae:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6b0:	00000097          	auipc	ra,0x0
     6b4:	bc6080e7          	jalr	-1082(ra) # 276 <execcmd>
     6b8:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6ba:	8656                	mv	a2,s5
     6bc:	85d2                	mv	a1,s4
     6be:	00000097          	auipc	ra,0x0
     6c2:	ec4080e7          	jalr	-316(ra) # 582 <parseredirs>
     6c6:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6c8:	008c0913          	addi	s2,s8,8
     6cc:	00001b17          	auipc	s6,0x1
     6d0:	e1cb0b13          	addi	s6,s6,-484 # 14e8 <malloc+0x17a>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     6d4:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     6d8:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     6da:	a0b1                	j	726 <parseexec+0xa8>
    return parseblock(ps, es);
     6dc:	85d6                	mv	a1,s5
     6de:	8552                	mv	a0,s4
     6e0:	00000097          	auipc	ra,0x0
     6e4:	1bc080e7          	jalr	444(ra) # 89c <parseblock>
     6e8:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     6ea:	8526                	mv	a0,s1
     6ec:	70a6                	ld	ra,104(sp)
     6ee:	7406                	ld	s0,96(sp)
     6f0:	64e6                	ld	s1,88(sp)
     6f2:	6946                	ld	s2,80(sp)
     6f4:	69a6                	ld	s3,72(sp)
     6f6:	6a06                	ld	s4,64(sp)
     6f8:	7ae2                	ld	s5,56(sp)
     6fa:	7b42                	ld	s6,48(sp)
     6fc:	7ba2                	ld	s7,40(sp)
     6fe:	7c02                	ld	s8,32(sp)
     700:	6ce2                	ld	s9,24(sp)
     702:	6165                	addi	sp,sp,112
     704:	8082                	ret
      panic("syntax");
     706:	00001517          	auipc	a0,0x1
     70a:	dca50513          	addi	a0,a0,-566 # 14d0 <malloc+0x162>
     70e:	00000097          	auipc	ra,0x0
     712:	946080e7          	jalr	-1722(ra) # 54 <panic>
    ret = parseredirs(ret, ps, es);
     716:	8656                	mv	a2,s5
     718:	85d2                	mv	a1,s4
     71a:	8526                	mv	a0,s1
     71c:	00000097          	auipc	ra,0x0
     720:	e66080e7          	jalr	-410(ra) # 582 <parseredirs>
     724:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     726:	865a                	mv	a2,s6
     728:	85d6                	mv	a1,s5
     72a:	8552                	mv	a0,s4
     72c:	00000097          	auipc	ra,0x0
     730:	dec080e7          	jalr	-532(ra) # 518 <peek>
     734:	e131                	bnez	a0,778 <parseexec+0xfa>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     736:	f9040693          	addi	a3,s0,-112
     73a:	f9840613          	addi	a2,s0,-104
     73e:	85d6                	mv	a1,s5
     740:	8552                	mv	a0,s4
     742:	00000097          	auipc	ra,0x0
     746:	c9a080e7          	jalr	-870(ra) # 3dc <gettoken>
     74a:	c51d                	beqz	a0,778 <parseexec+0xfa>
    if(tok != 'a')
     74c:	fb951de3          	bne	a0,s9,706 <parseexec+0x88>
    cmd->argv[argc] = q;
     750:	f9843783          	ld	a5,-104(s0)
     754:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     758:	f9043783          	ld	a5,-112(s0)
     75c:	04f93823          	sd	a5,80(s2)
    argc++;
     760:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     762:	0921                	addi	s2,s2,8
     764:	fb7999e3          	bne	s3,s7,716 <parseexec+0x98>
      panic("too many args");
     768:	00001517          	auipc	a0,0x1
     76c:	d7050513          	addi	a0,a0,-656 # 14d8 <malloc+0x16a>
     770:	00000097          	auipc	ra,0x0
     774:	8e4080e7          	jalr	-1820(ra) # 54 <panic>
  cmd->argv[argc] = 0;
     778:	098e                	slli	s3,s3,0x3
     77a:	99e2                	add	s3,s3,s8
     77c:	0009b423          	sd	zero,8(s3)
  cmd->eargv[argc] = 0;
     780:	0409bc23          	sd	zero,88(s3)
  return ret;
     784:	b79d                	j	6ea <parseexec+0x6c>

0000000000000786 <parsepipe>:
{
     786:	7179                	addi	sp,sp,-48
     788:	f406                	sd	ra,40(sp)
     78a:	f022                	sd	s0,32(sp)
     78c:	ec26                	sd	s1,24(sp)
     78e:	e84a                	sd	s2,16(sp)
     790:	e44e                	sd	s3,8(sp)
     792:	1800                	addi	s0,sp,48
     794:	892a                	mv	s2,a0
     796:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     798:	00000097          	auipc	ra,0x0
     79c:	ee6080e7          	jalr	-282(ra) # 67e <parseexec>
     7a0:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7a2:	00001617          	auipc	a2,0x1
     7a6:	d4e60613          	addi	a2,a2,-690 # 14f0 <malloc+0x182>
     7aa:	85ce                	mv	a1,s3
     7ac:	854a                	mv	a0,s2
     7ae:	00000097          	auipc	ra,0x0
     7b2:	d6a080e7          	jalr	-662(ra) # 518 <peek>
     7b6:	e909                	bnez	a0,7c8 <parsepipe+0x42>
}
     7b8:	8526                	mv	a0,s1
     7ba:	70a2                	ld	ra,40(sp)
     7bc:	7402                	ld	s0,32(sp)
     7be:	64e2                	ld	s1,24(sp)
     7c0:	6942                	ld	s2,16(sp)
     7c2:	69a2                	ld	s3,8(sp)
     7c4:	6145                	addi	sp,sp,48
     7c6:	8082                	ret
    gettoken(ps, es, 0, 0);
     7c8:	4681                	li	a3,0
     7ca:	4601                	li	a2,0
     7cc:	85ce                	mv	a1,s3
     7ce:	854a                	mv	a0,s2
     7d0:	00000097          	auipc	ra,0x0
     7d4:	c0c080e7          	jalr	-1012(ra) # 3dc <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7d8:	85ce                	mv	a1,s3
     7da:	854a                	mv	a0,s2
     7dc:	00000097          	auipc	ra,0x0
     7e0:	faa080e7          	jalr	-86(ra) # 786 <parsepipe>
     7e4:	85aa                	mv	a1,a0
     7e6:	8526                	mv	a0,s1
     7e8:	00000097          	auipc	ra,0x0
     7ec:	b2c080e7          	jalr	-1236(ra) # 314 <pipecmd>
     7f0:	84aa                	mv	s1,a0
  return cmd;
     7f2:	b7d9                	j	7b8 <parsepipe+0x32>

00000000000007f4 <parseline>:
{
     7f4:	7179                	addi	sp,sp,-48
     7f6:	f406                	sd	ra,40(sp)
     7f8:	f022                	sd	s0,32(sp)
     7fa:	ec26                	sd	s1,24(sp)
     7fc:	e84a                	sd	s2,16(sp)
     7fe:	e44e                	sd	s3,8(sp)
     800:	e052                	sd	s4,0(sp)
     802:	1800                	addi	s0,sp,48
     804:	892a                	mv	s2,a0
     806:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     808:	00000097          	auipc	ra,0x0
     80c:	f7e080e7          	jalr	-130(ra) # 786 <parsepipe>
     810:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     812:	00001a17          	auipc	s4,0x1
     816:	ce6a0a13          	addi	s4,s4,-794 # 14f8 <malloc+0x18a>
     81a:	a839                	j	838 <parseline+0x44>
    gettoken(ps, es, 0, 0);
     81c:	4681                	li	a3,0
     81e:	4601                	li	a2,0
     820:	85ce                	mv	a1,s3
     822:	854a                	mv	a0,s2
     824:	00000097          	auipc	ra,0x0
     828:	bb8080e7          	jalr	-1096(ra) # 3dc <gettoken>
    cmd = backcmd(cmd);
     82c:	8526                	mv	a0,s1
     82e:	00000097          	auipc	ra,0x0
     832:	b72080e7          	jalr	-1166(ra) # 3a0 <backcmd>
     836:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     838:	8652                	mv	a2,s4
     83a:	85ce                	mv	a1,s3
     83c:	854a                	mv	a0,s2
     83e:	00000097          	auipc	ra,0x0
     842:	cda080e7          	jalr	-806(ra) # 518 <peek>
     846:	f979                	bnez	a0,81c <parseline+0x28>
  if(peek(ps, es, ";")){
     848:	00001617          	auipc	a2,0x1
     84c:	cb860613          	addi	a2,a2,-840 # 1500 <malloc+0x192>
     850:	85ce                	mv	a1,s3
     852:	854a                	mv	a0,s2
     854:	00000097          	auipc	ra,0x0
     858:	cc4080e7          	jalr	-828(ra) # 518 <peek>
     85c:	e911                	bnez	a0,870 <parseline+0x7c>
}
     85e:	8526                	mv	a0,s1
     860:	70a2                	ld	ra,40(sp)
     862:	7402                	ld	s0,32(sp)
     864:	64e2                	ld	s1,24(sp)
     866:	6942                	ld	s2,16(sp)
     868:	69a2                	ld	s3,8(sp)
     86a:	6a02                	ld	s4,0(sp)
     86c:	6145                	addi	sp,sp,48
     86e:	8082                	ret
    gettoken(ps, es, 0, 0);
     870:	4681                	li	a3,0
     872:	4601                	li	a2,0
     874:	85ce                	mv	a1,s3
     876:	854a                	mv	a0,s2
     878:	00000097          	auipc	ra,0x0
     87c:	b64080e7          	jalr	-1180(ra) # 3dc <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     880:	85ce                	mv	a1,s3
     882:	854a                	mv	a0,s2
     884:	00000097          	auipc	ra,0x0
     888:	f70080e7          	jalr	-144(ra) # 7f4 <parseline>
     88c:	85aa                	mv	a1,a0
     88e:	8526                	mv	a0,s1
     890:	00000097          	auipc	ra,0x0
     894:	aca080e7          	jalr	-1334(ra) # 35a <listcmd>
     898:	84aa                	mv	s1,a0
  return cmd;
     89a:	b7d1                	j	85e <parseline+0x6a>

000000000000089c <parseblock>:
{
     89c:	7179                	addi	sp,sp,-48
     89e:	f406                	sd	ra,40(sp)
     8a0:	f022                	sd	s0,32(sp)
     8a2:	ec26                	sd	s1,24(sp)
     8a4:	e84a                	sd	s2,16(sp)
     8a6:	e44e                	sd	s3,8(sp)
     8a8:	1800                	addi	s0,sp,48
     8aa:	84aa                	mv	s1,a0
     8ac:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8ae:	00001617          	auipc	a2,0x1
     8b2:	c1a60613          	addi	a2,a2,-998 # 14c8 <malloc+0x15a>
     8b6:	00000097          	auipc	ra,0x0
     8ba:	c62080e7          	jalr	-926(ra) # 518 <peek>
     8be:	c12d                	beqz	a0,920 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8c0:	4681                	li	a3,0
     8c2:	4601                	li	a2,0
     8c4:	85ca                	mv	a1,s2
     8c6:	8526                	mv	a0,s1
     8c8:	00000097          	auipc	ra,0x0
     8cc:	b14080e7          	jalr	-1260(ra) # 3dc <gettoken>
  cmd = parseline(ps, es);
     8d0:	85ca                	mv	a1,s2
     8d2:	8526                	mv	a0,s1
     8d4:	00000097          	auipc	ra,0x0
     8d8:	f20080e7          	jalr	-224(ra) # 7f4 <parseline>
     8dc:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     8de:	00001617          	auipc	a2,0x1
     8e2:	c3a60613          	addi	a2,a2,-966 # 1518 <malloc+0x1aa>
     8e6:	85ca                	mv	a1,s2
     8e8:	8526                	mv	a0,s1
     8ea:	00000097          	auipc	ra,0x0
     8ee:	c2e080e7          	jalr	-978(ra) # 518 <peek>
     8f2:	cd1d                	beqz	a0,930 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     8f4:	4681                	li	a3,0
     8f6:	4601                	li	a2,0
     8f8:	85ca                	mv	a1,s2
     8fa:	8526                	mv	a0,s1
     8fc:	00000097          	auipc	ra,0x0
     900:	ae0080e7          	jalr	-1312(ra) # 3dc <gettoken>
  cmd = parseredirs(cmd, ps, es);
     904:	864a                	mv	a2,s2
     906:	85a6                	mv	a1,s1
     908:	854e                	mv	a0,s3
     90a:	00000097          	auipc	ra,0x0
     90e:	c78080e7          	jalr	-904(ra) # 582 <parseredirs>
}
     912:	70a2                	ld	ra,40(sp)
     914:	7402                	ld	s0,32(sp)
     916:	64e2                	ld	s1,24(sp)
     918:	6942                	ld	s2,16(sp)
     91a:	69a2                	ld	s3,8(sp)
     91c:	6145                	addi	sp,sp,48
     91e:	8082                	ret
    panic("parseblock");
     920:	00001517          	auipc	a0,0x1
     924:	be850513          	addi	a0,a0,-1048 # 1508 <malloc+0x19a>
     928:	fffff097          	auipc	ra,0xfffff
     92c:	72c080e7          	jalr	1836(ra) # 54 <panic>
    panic("syntax - missing )");
     930:	00001517          	auipc	a0,0x1
     934:	bf050513          	addi	a0,a0,-1040 # 1520 <malloc+0x1b2>
     938:	fffff097          	auipc	ra,0xfffff
     93c:	71c080e7          	jalr	1820(ra) # 54 <panic>

0000000000000940 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     940:	1101                	addi	sp,sp,-32
     942:	ec06                	sd	ra,24(sp)
     944:	e822                	sd	s0,16(sp)
     946:	e426                	sd	s1,8(sp)
     948:	1000                	addi	s0,sp,32
     94a:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     94c:	c521                	beqz	a0,994 <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     94e:	4118                	lw	a4,0(a0)
     950:	4795                	li	a5,5
     952:	04e7e163          	bltu	a5,a4,994 <nulterminate+0x54>
     956:	00056783          	lwu	a5,0(a0)
     95a:	078a                	slli	a5,a5,0x2
     95c:	00001717          	auipc	a4,0x1
     960:	c2470713          	addi	a4,a4,-988 # 1580 <malloc+0x212>
     964:	97ba                	add	a5,a5,a4
     966:	439c                	lw	a5,0(a5)
     968:	97ba                	add	a5,a5,a4
     96a:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     96c:	651c                	ld	a5,8(a0)
     96e:	c39d                	beqz	a5,994 <nulterminate+0x54>
     970:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     974:	67b8                	ld	a4,72(a5)
     976:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     97a:	07a1                	addi	a5,a5,8
     97c:	ff87b703          	ld	a4,-8(a5)
     980:	fb75                	bnez	a4,974 <nulterminate+0x34>
     982:	a809                	j	994 <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     984:	6508                	ld	a0,8(a0)
     986:	00000097          	auipc	ra,0x0
     98a:	fba080e7          	jalr	-70(ra) # 940 <nulterminate>
    *rcmd->efile = 0;
     98e:	6c9c                	ld	a5,24(s1)
     990:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     994:	8526                	mv	a0,s1
     996:	60e2                	ld	ra,24(sp)
     998:	6442                	ld	s0,16(sp)
     99a:	64a2                	ld	s1,8(sp)
     99c:	6105                	addi	sp,sp,32
     99e:	8082                	ret
    nulterminate(pcmd->left);
     9a0:	6508                	ld	a0,8(a0)
     9a2:	00000097          	auipc	ra,0x0
     9a6:	f9e080e7          	jalr	-98(ra) # 940 <nulterminate>
    nulterminate(pcmd->right);
     9aa:	6888                	ld	a0,16(s1)
     9ac:	00000097          	auipc	ra,0x0
     9b0:	f94080e7          	jalr	-108(ra) # 940 <nulterminate>
    break;
     9b4:	b7c5                	j	994 <nulterminate+0x54>
    nulterminate(lcmd->left);
     9b6:	6508                	ld	a0,8(a0)
     9b8:	00000097          	auipc	ra,0x0
     9bc:	f88080e7          	jalr	-120(ra) # 940 <nulterminate>
    nulterminate(lcmd->right);
     9c0:	6888                	ld	a0,16(s1)
     9c2:	00000097          	auipc	ra,0x0
     9c6:	f7e080e7          	jalr	-130(ra) # 940 <nulterminate>
    break;
     9ca:	b7e9                	j	994 <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9cc:	6508                	ld	a0,8(a0)
     9ce:	00000097          	auipc	ra,0x0
     9d2:	f72080e7          	jalr	-142(ra) # 940 <nulterminate>
    break;
     9d6:	bf7d                	j	994 <nulterminate+0x54>

00000000000009d8 <parsecmd>:
{
     9d8:	7179                	addi	sp,sp,-48
     9da:	f406                	sd	ra,40(sp)
     9dc:	f022                	sd	s0,32(sp)
     9de:	ec26                	sd	s1,24(sp)
     9e0:	e84a                	sd	s2,16(sp)
     9e2:	1800                	addi	s0,sp,48
     9e4:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     9e8:	84aa                	mv	s1,a0
     9ea:	00000097          	auipc	ra,0x0
     9ee:	1b2080e7          	jalr	434(ra) # b9c <strlen>
     9f2:	1502                	slli	a0,a0,0x20
     9f4:	9101                	srli	a0,a0,0x20
     9f6:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     9f8:	85a6                	mv	a1,s1
     9fa:	fd840513          	addi	a0,s0,-40
     9fe:	00000097          	auipc	ra,0x0
     a02:	df6080e7          	jalr	-522(ra) # 7f4 <parseline>
     a06:	892a                	mv	s2,a0
  peek(&s, es, "");
     a08:	00001617          	auipc	a2,0x1
     a0c:	b3060613          	addi	a2,a2,-1232 # 1538 <malloc+0x1ca>
     a10:	85a6                	mv	a1,s1
     a12:	fd840513          	addi	a0,s0,-40
     a16:	00000097          	auipc	ra,0x0
     a1a:	b02080e7          	jalr	-1278(ra) # 518 <peek>
  if(s != es){
     a1e:	fd843603          	ld	a2,-40(s0)
     a22:	00961e63          	bne	a2,s1,a3e <parsecmd+0x66>
  nulterminate(cmd);
     a26:	854a                	mv	a0,s2
     a28:	00000097          	auipc	ra,0x0
     a2c:	f18080e7          	jalr	-232(ra) # 940 <nulterminate>
}
     a30:	854a                	mv	a0,s2
     a32:	70a2                	ld	ra,40(sp)
     a34:	7402                	ld	s0,32(sp)
     a36:	64e2                	ld	s1,24(sp)
     a38:	6942                	ld	s2,16(sp)
     a3a:	6145                	addi	sp,sp,48
     a3c:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a3e:	00001597          	auipc	a1,0x1
     a42:	b0258593          	addi	a1,a1,-1278 # 1540 <malloc+0x1d2>
     a46:	4509                	li	a0,2
     a48:	00001097          	auipc	ra,0x1
     a4c:	83a080e7          	jalr	-1990(ra) # 1282 <fprintf>
    panic("syntax");
     a50:	00001517          	auipc	a0,0x1
     a54:	a8050513          	addi	a0,a0,-1408 # 14d0 <malloc+0x162>
     a58:	fffff097          	auipc	ra,0xfffff
     a5c:	5fc080e7          	jalr	1532(ra) # 54 <panic>

0000000000000a60 <main>:
{
     a60:	7139                	addi	sp,sp,-64
     a62:	fc06                	sd	ra,56(sp)
     a64:	f822                	sd	s0,48(sp)
     a66:	f426                	sd	s1,40(sp)
     a68:	f04a                	sd	s2,32(sp)
     a6a:	ec4e                	sd	s3,24(sp)
     a6c:	e852                	sd	s4,16(sp)
     a6e:	e456                	sd	s5,8(sp)
     a70:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     a72:	00001497          	auipc	s1,0x1
     a76:	ade48493          	addi	s1,s1,-1314 # 1550 <malloc+0x1e2>
     a7a:	4589                	li	a1,2
     a7c:	8526                	mv	a0,s1
     a7e:	00000097          	auipc	ra,0x0
     a82:	4a0080e7          	jalr	1184(ra) # f1e <open>
     a86:	00054963          	bltz	a0,a98 <main+0x38>
    if(fd >= 3){
     a8a:	4789                	li	a5,2
     a8c:	fea7d7e3          	bge	a5,a0,a7a <main+0x1a>
      close(fd);
     a90:	00000097          	auipc	ra,0x0
     a94:	476080e7          	jalr	1142(ra) # f06 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     a98:	00001497          	auipc	s1,0x1
     a9c:	b3848493          	addi	s1,s1,-1224 # 15d0 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     aa0:	06300913          	li	s2,99
     aa4:	02000993          	li	s3,32
      if(chdir(buf+3) < 0)
     aa8:	00001a17          	auipc	s4,0x1
     aac:	b2ba0a13          	addi	s4,s4,-1237 # 15d3 <buf.0+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     ab0:	00001a97          	auipc	s5,0x1
     ab4:	aa8a8a93          	addi	s5,s5,-1368 # 1558 <malloc+0x1ea>
     ab8:	a819                	j	ace <main+0x6e>
    if(fork1() == 0)
     aba:	fffff097          	auipc	ra,0xfffff
     abe:	5c0080e7          	jalr	1472(ra) # 7a <fork1>
     ac2:	c925                	beqz	a0,b32 <main+0xd2>
    wait(0);
     ac4:	4501                	li	a0,0
     ac6:	00000097          	auipc	ra,0x0
     aca:	420080e7          	jalr	1056(ra) # ee6 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     ace:	06400593          	li	a1,100
     ad2:	8526                	mv	a0,s1
     ad4:	fffff097          	auipc	ra,0xfffff
     ad8:	52c080e7          	jalr	1324(ra) # 0 <getcmd>
     adc:	06054763          	bltz	a0,b4a <main+0xea>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ae0:	0004c783          	lbu	a5,0(s1)
     ae4:	fd279be3          	bne	a5,s2,aba <main+0x5a>
     ae8:	0014c703          	lbu	a4,1(s1)
     aec:	06400793          	li	a5,100
     af0:	fcf715e3          	bne	a4,a5,aba <main+0x5a>
     af4:	0024c783          	lbu	a5,2(s1)
     af8:	fd3791e3          	bne	a5,s3,aba <main+0x5a>
      buf[strlen(buf)-1] = 0;  // chop \n
     afc:	8526                	mv	a0,s1
     afe:	00000097          	auipc	ra,0x0
     b02:	09e080e7          	jalr	158(ra) # b9c <strlen>
     b06:	fff5079b          	addiw	a5,a0,-1
     b0a:	1782                	slli	a5,a5,0x20
     b0c:	9381                	srli	a5,a5,0x20
     b0e:	97a6                	add	a5,a5,s1
     b10:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     b14:	8552                	mv	a0,s4
     b16:	00000097          	auipc	ra,0x0
     b1a:	438080e7          	jalr	1080(ra) # f4e <chdir>
     b1e:	fa0558e3          	bgez	a0,ace <main+0x6e>
        fprintf(2, "cannot cd %s\n", buf+3);
     b22:	8652                	mv	a2,s4
     b24:	85d6                	mv	a1,s5
     b26:	4509                	li	a0,2
     b28:	00000097          	auipc	ra,0x0
     b2c:	75a080e7          	jalr	1882(ra) # 1282 <fprintf>
     b30:	bf79                	j	ace <main+0x6e>
      runcmd(parsecmd(buf));
     b32:	00001517          	auipc	a0,0x1
     b36:	a9e50513          	addi	a0,a0,-1378 # 15d0 <buf.0>
     b3a:	00000097          	auipc	ra,0x0
     b3e:	e9e080e7          	jalr	-354(ra) # 9d8 <parsecmd>
     b42:	fffff097          	auipc	ra,0xfffff
     b46:	566080e7          	jalr	1382(ra) # a8 <runcmd>
  exit(0);
     b4a:	4501                	li	a0,0
     b4c:	00000097          	auipc	ra,0x0
     b50:	392080e7          	jalr	914(ra) # ede <exit>

0000000000000b54 <strcpy>:
#include "kernel/Csemaphore.h"


char*
strcpy(char *s, const char *t)
{
     b54:	1141                	addi	sp,sp,-16
     b56:	e422                	sd	s0,8(sp)
     b58:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b5a:	87aa                	mv	a5,a0
     b5c:	0585                	addi	a1,a1,1
     b5e:	0785                	addi	a5,a5,1
     b60:	fff5c703          	lbu	a4,-1(a1)
     b64:	fee78fa3          	sb	a4,-1(a5)
     b68:	fb75                	bnez	a4,b5c <strcpy+0x8>
    ;
  return os;
}
     b6a:	6422                	ld	s0,8(sp)
     b6c:	0141                	addi	sp,sp,16
     b6e:	8082                	ret

0000000000000b70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b70:	1141                	addi	sp,sp,-16
     b72:	e422                	sd	s0,8(sp)
     b74:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     b76:	00054783          	lbu	a5,0(a0)
     b7a:	cb91                	beqz	a5,b8e <strcmp+0x1e>
     b7c:	0005c703          	lbu	a4,0(a1)
     b80:	00f71763          	bne	a4,a5,b8e <strcmp+0x1e>
    p++, q++;
     b84:	0505                	addi	a0,a0,1
     b86:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     b88:	00054783          	lbu	a5,0(a0)
     b8c:	fbe5                	bnez	a5,b7c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     b8e:	0005c503          	lbu	a0,0(a1)
}
     b92:	40a7853b          	subw	a0,a5,a0
     b96:	6422                	ld	s0,8(sp)
     b98:	0141                	addi	sp,sp,16
     b9a:	8082                	ret

0000000000000b9c <strlen>:

uint
strlen(const char *s)
{
     b9c:	1141                	addi	sp,sp,-16
     b9e:	e422                	sd	s0,8(sp)
     ba0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     ba2:	00054783          	lbu	a5,0(a0)
     ba6:	cf91                	beqz	a5,bc2 <strlen+0x26>
     ba8:	0505                	addi	a0,a0,1
     baa:	87aa                	mv	a5,a0
     bac:	4685                	li	a3,1
     bae:	9e89                	subw	a3,a3,a0
     bb0:	00f6853b          	addw	a0,a3,a5
     bb4:	0785                	addi	a5,a5,1
     bb6:	fff7c703          	lbu	a4,-1(a5)
     bba:	fb7d                	bnez	a4,bb0 <strlen+0x14>
    ;
  return n;
}
     bbc:	6422                	ld	s0,8(sp)
     bbe:	0141                	addi	sp,sp,16
     bc0:	8082                	ret
  for(n = 0; s[n]; n++)
     bc2:	4501                	li	a0,0
     bc4:	bfe5                	j	bbc <strlen+0x20>

0000000000000bc6 <memset>:

void*
memset(void *dst, int c, uint n)
{
     bc6:	1141                	addi	sp,sp,-16
     bc8:	e422                	sd	s0,8(sp)
     bca:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     bcc:	ca19                	beqz	a2,be2 <memset+0x1c>
     bce:	87aa                	mv	a5,a0
     bd0:	1602                	slli	a2,a2,0x20
     bd2:	9201                	srli	a2,a2,0x20
     bd4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     bd8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     bdc:	0785                	addi	a5,a5,1
     bde:	fee79de3          	bne	a5,a4,bd8 <memset+0x12>
  }
  return dst;
}
     be2:	6422                	ld	s0,8(sp)
     be4:	0141                	addi	sp,sp,16
     be6:	8082                	ret

0000000000000be8 <strchr>:

char*
strchr(const char *s, char c)
{
     be8:	1141                	addi	sp,sp,-16
     bea:	e422                	sd	s0,8(sp)
     bec:	0800                	addi	s0,sp,16
  for(; *s; s++)
     bee:	00054783          	lbu	a5,0(a0)
     bf2:	cb99                	beqz	a5,c08 <strchr+0x20>
    if(*s == c)
     bf4:	00f58763          	beq	a1,a5,c02 <strchr+0x1a>
  for(; *s; s++)
     bf8:	0505                	addi	a0,a0,1
     bfa:	00054783          	lbu	a5,0(a0)
     bfe:	fbfd                	bnez	a5,bf4 <strchr+0xc>
      return (char*)s;
  return 0;
     c00:	4501                	li	a0,0
}
     c02:	6422                	ld	s0,8(sp)
     c04:	0141                	addi	sp,sp,16
     c06:	8082                	ret
  return 0;
     c08:	4501                	li	a0,0
     c0a:	bfe5                	j	c02 <strchr+0x1a>

0000000000000c0c <gets>:

char*
gets(char *buf, int max)
{
     c0c:	711d                	addi	sp,sp,-96
     c0e:	ec86                	sd	ra,88(sp)
     c10:	e8a2                	sd	s0,80(sp)
     c12:	e4a6                	sd	s1,72(sp)
     c14:	e0ca                	sd	s2,64(sp)
     c16:	fc4e                	sd	s3,56(sp)
     c18:	f852                	sd	s4,48(sp)
     c1a:	f456                	sd	s5,40(sp)
     c1c:	f05a                	sd	s6,32(sp)
     c1e:	ec5e                	sd	s7,24(sp)
     c20:	1080                	addi	s0,sp,96
     c22:	8baa                	mv	s7,a0
     c24:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c26:	892a                	mv	s2,a0
     c28:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c2a:	4aa9                	li	s5,10
     c2c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c2e:	89a6                	mv	s3,s1
     c30:	2485                	addiw	s1,s1,1
     c32:	0344d863          	bge	s1,s4,c62 <gets+0x56>
    cc = read(0, &c, 1);
     c36:	4605                	li	a2,1
     c38:	faf40593          	addi	a1,s0,-81
     c3c:	4501                	li	a0,0
     c3e:	00000097          	auipc	ra,0x0
     c42:	2b8080e7          	jalr	696(ra) # ef6 <read>
    if(cc < 1)
     c46:	00a05e63          	blez	a0,c62 <gets+0x56>
    buf[i++] = c;
     c4a:	faf44783          	lbu	a5,-81(s0)
     c4e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c52:	01578763          	beq	a5,s5,c60 <gets+0x54>
     c56:	0905                	addi	s2,s2,1
     c58:	fd679be3          	bne	a5,s6,c2e <gets+0x22>
  for(i=0; i+1 < max; ){
     c5c:	89a6                	mv	s3,s1
     c5e:	a011                	j	c62 <gets+0x56>
     c60:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c62:	99de                	add	s3,s3,s7
     c64:	00098023          	sb	zero,0(s3)
  return buf;
}
     c68:	855e                	mv	a0,s7
     c6a:	60e6                	ld	ra,88(sp)
     c6c:	6446                	ld	s0,80(sp)
     c6e:	64a6                	ld	s1,72(sp)
     c70:	6906                	ld	s2,64(sp)
     c72:	79e2                	ld	s3,56(sp)
     c74:	7a42                	ld	s4,48(sp)
     c76:	7aa2                	ld	s5,40(sp)
     c78:	7b02                	ld	s6,32(sp)
     c7a:	6be2                	ld	s7,24(sp)
     c7c:	6125                	addi	sp,sp,96
     c7e:	8082                	ret

0000000000000c80 <stat>:

int
stat(const char *n, struct stat *st)
{
     c80:	1101                	addi	sp,sp,-32
     c82:	ec06                	sd	ra,24(sp)
     c84:	e822                	sd	s0,16(sp)
     c86:	e426                	sd	s1,8(sp)
     c88:	e04a                	sd	s2,0(sp)
     c8a:	1000                	addi	s0,sp,32
     c8c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c8e:	4581                	li	a1,0
     c90:	00000097          	auipc	ra,0x0
     c94:	28e080e7          	jalr	654(ra) # f1e <open>
  if(fd < 0)
     c98:	02054563          	bltz	a0,cc2 <stat+0x42>
     c9c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     c9e:	85ca                	mv	a1,s2
     ca0:	00000097          	auipc	ra,0x0
     ca4:	296080e7          	jalr	662(ra) # f36 <fstat>
     ca8:	892a                	mv	s2,a0
  close(fd);
     caa:	8526                	mv	a0,s1
     cac:	00000097          	auipc	ra,0x0
     cb0:	25a080e7          	jalr	602(ra) # f06 <close>
  return r;
}
     cb4:	854a                	mv	a0,s2
     cb6:	60e2                	ld	ra,24(sp)
     cb8:	6442                	ld	s0,16(sp)
     cba:	64a2                	ld	s1,8(sp)
     cbc:	6902                	ld	s2,0(sp)
     cbe:	6105                	addi	sp,sp,32
     cc0:	8082                	ret
    return -1;
     cc2:	597d                	li	s2,-1
     cc4:	bfc5                	j	cb4 <stat+0x34>

0000000000000cc6 <atoi>:

int
atoi(const char *s)
{
     cc6:	1141                	addi	sp,sp,-16
     cc8:	e422                	sd	s0,8(sp)
     cca:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     ccc:	00054603          	lbu	a2,0(a0)
     cd0:	fd06079b          	addiw	a5,a2,-48
     cd4:	0ff7f793          	andi	a5,a5,255
     cd8:	4725                	li	a4,9
     cda:	02f76963          	bltu	a4,a5,d0c <atoi+0x46>
     cde:	86aa                	mv	a3,a0
  n = 0;
     ce0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     ce2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     ce4:	0685                	addi	a3,a3,1
     ce6:	0025179b          	slliw	a5,a0,0x2
     cea:	9fa9                	addw	a5,a5,a0
     cec:	0017979b          	slliw	a5,a5,0x1
     cf0:	9fb1                	addw	a5,a5,a2
     cf2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     cf6:	0006c603          	lbu	a2,0(a3)
     cfa:	fd06071b          	addiw	a4,a2,-48
     cfe:	0ff77713          	andi	a4,a4,255
     d02:	fee5f1e3          	bgeu	a1,a4,ce4 <atoi+0x1e>
  return n;
}
     d06:	6422                	ld	s0,8(sp)
     d08:	0141                	addi	sp,sp,16
     d0a:	8082                	ret
  n = 0;
     d0c:	4501                	li	a0,0
     d0e:	bfe5                	j	d06 <atoi+0x40>

0000000000000d10 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d10:	1141                	addi	sp,sp,-16
     d12:	e422                	sd	s0,8(sp)
     d14:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d16:	02b57463          	bgeu	a0,a1,d3e <memmove+0x2e>
    while(n-- > 0)
     d1a:	00c05f63          	blez	a2,d38 <memmove+0x28>
     d1e:	1602                	slli	a2,a2,0x20
     d20:	9201                	srli	a2,a2,0x20
     d22:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d26:	872a                	mv	a4,a0
      *dst++ = *src++;
     d28:	0585                	addi	a1,a1,1
     d2a:	0705                	addi	a4,a4,1
     d2c:	fff5c683          	lbu	a3,-1(a1)
     d30:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d34:	fee79ae3          	bne	a5,a4,d28 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d38:	6422                	ld	s0,8(sp)
     d3a:	0141                	addi	sp,sp,16
     d3c:	8082                	ret
    dst += n;
     d3e:	00c50733          	add	a4,a0,a2
    src += n;
     d42:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d44:	fec05ae3          	blez	a2,d38 <memmove+0x28>
     d48:	fff6079b          	addiw	a5,a2,-1
     d4c:	1782                	slli	a5,a5,0x20
     d4e:	9381                	srli	a5,a5,0x20
     d50:	fff7c793          	not	a5,a5
     d54:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d56:	15fd                	addi	a1,a1,-1
     d58:	177d                	addi	a4,a4,-1
     d5a:	0005c683          	lbu	a3,0(a1)
     d5e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d62:	fee79ae3          	bne	a5,a4,d56 <memmove+0x46>
     d66:	bfc9                	j	d38 <memmove+0x28>

0000000000000d68 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     d68:	1141                	addi	sp,sp,-16
     d6a:	e422                	sd	s0,8(sp)
     d6c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     d6e:	ca05                	beqz	a2,d9e <memcmp+0x36>
     d70:	fff6069b          	addiw	a3,a2,-1
     d74:	1682                	slli	a3,a3,0x20
     d76:	9281                	srli	a3,a3,0x20
     d78:	0685                	addi	a3,a3,1
     d7a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     d7c:	00054783          	lbu	a5,0(a0)
     d80:	0005c703          	lbu	a4,0(a1)
     d84:	00e79863          	bne	a5,a4,d94 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     d88:	0505                	addi	a0,a0,1
    p2++;
     d8a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     d8c:	fed518e3          	bne	a0,a3,d7c <memcmp+0x14>
  }
  return 0;
     d90:	4501                	li	a0,0
     d92:	a019                	j	d98 <memcmp+0x30>
      return *p1 - *p2;
     d94:	40e7853b          	subw	a0,a5,a4
}
     d98:	6422                	ld	s0,8(sp)
     d9a:	0141                	addi	sp,sp,16
     d9c:	8082                	ret
  return 0;
     d9e:	4501                	li	a0,0
     da0:	bfe5                	j	d98 <memcmp+0x30>

0000000000000da2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     da2:	1141                	addi	sp,sp,-16
     da4:	e406                	sd	ra,8(sp)
     da6:	e022                	sd	s0,0(sp)
     da8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     daa:	00000097          	auipc	ra,0x0
     dae:	f66080e7          	jalr	-154(ra) # d10 <memmove>
}
     db2:	60a2                	ld	ra,8(sp)
     db4:	6402                	ld	s0,0(sp)
     db6:	0141                	addi	sp,sp,16
     db8:	8082                	ret

0000000000000dba <csem_down>:


void 
csem_down(struct counting_semaphore *sem) {
     dba:	1101                	addi	sp,sp,-32
     dbc:	ec06                	sd	ra,24(sp)
     dbe:	e822                	sd	s0,16(sp)
     dc0:	e426                	sd	s1,8(sp)
     dc2:	1000                	addi	s0,sp,32
     dc4:	84aa                	mv	s1,a0
    bsem_down(sem->bsem2);
     dc6:	4148                	lw	a0,4(a0)
     dc8:	00000097          	auipc	ra,0x0
     dcc:	1ce080e7          	jalr	462(ra) # f96 <bsem_down>
    bsem_down(sem->bsem1);
     dd0:	4088                	lw	a0,0(s1)
     dd2:	00000097          	auipc	ra,0x0
     dd6:	1c4080e7          	jalr	452(ra) # f96 <bsem_down>
    sem->count -= 1;
     dda:	449c                	lw	a5,8(s1)
     ddc:	37fd                	addiw	a5,a5,-1
     dde:	0007871b          	sext.w	a4,a5
     de2:	c49c                	sw	a5,8(s1)
    if (sem->count > 0)
     de4:	00e04c63          	bgtz	a4,dfc <csem_down+0x42>
    	bsem_up(sem->bsem2);
    bsem_up(sem->bsem1);
     de8:	4088                	lw	a0,0(s1)
     dea:	00000097          	auipc	ra,0x0
     dee:	1b4080e7          	jalr	436(ra) # f9e <bsem_up>
}
     df2:	60e2                	ld	ra,24(sp)
     df4:	6442                	ld	s0,16(sp)
     df6:	64a2                	ld	s1,8(sp)
     df8:	6105                	addi	sp,sp,32
     dfa:	8082                	ret
    	bsem_up(sem->bsem2);
     dfc:	40c8                	lw	a0,4(s1)
     dfe:	00000097          	auipc	ra,0x0
     e02:	1a0080e7          	jalr	416(ra) # f9e <bsem_up>
     e06:	b7cd                	j	de8 <csem_down+0x2e>

0000000000000e08 <csem_up>:


void 
csem_up(struct counting_semaphore *sem) {
     e08:	1101                	addi	sp,sp,-32
     e0a:	ec06                	sd	ra,24(sp)
     e0c:	e822                	sd	s0,16(sp)
     e0e:	e426                	sd	s1,8(sp)
     e10:	1000                	addi	s0,sp,32
     e12:	84aa                	mv	s1,a0
	bsem_down(sem->bsem1);
     e14:	4108                	lw	a0,0(a0)
     e16:	00000097          	auipc	ra,0x0
     e1a:	180080e7          	jalr	384(ra) # f96 <bsem_down>
	sem->count += 1;
     e1e:	449c                	lw	a5,8(s1)
     e20:	2785                	addiw	a5,a5,1
     e22:	0007871b          	sext.w	a4,a5
     e26:	c49c                	sw	a5,8(s1)
	if (sem->count == 1)
     e28:	4785                	li	a5,1
     e2a:	00f70c63          	beq	a4,a5,e42 <csem_up+0x3a>
		bsem_up(sem->bsem2);
	bsem_up(sem->bsem1);
     e2e:	4088                	lw	a0,0(s1)
     e30:	00000097          	auipc	ra,0x0
     e34:	16e080e7          	jalr	366(ra) # f9e <bsem_up>
}
     e38:	60e2                	ld	ra,24(sp)
     e3a:	6442                	ld	s0,16(sp)
     e3c:	64a2                	ld	s1,8(sp)
     e3e:	6105                	addi	sp,sp,32
     e40:	8082                	ret
		bsem_up(sem->bsem2);
     e42:	40c8                	lw	a0,4(s1)
     e44:	00000097          	auipc	ra,0x0
     e48:	15a080e7          	jalr	346(ra) # f9e <bsem_up>
     e4c:	b7cd                	j	e2e <csem_up+0x26>

0000000000000e4e <csem_alloc>:


int 
csem_alloc(struct counting_semaphore *sem, int count) {
     e4e:	7179                	addi	sp,sp,-48
     e50:	f406                	sd	ra,40(sp)
     e52:	f022                	sd	s0,32(sp)
     e54:	ec26                	sd	s1,24(sp)
     e56:	e84a                	sd	s2,16(sp)
     e58:	e44e                	sd	s3,8(sp)
     e5a:	1800                	addi	s0,sp,48
     e5c:	892a                	mv	s2,a0
     e5e:	89ae                	mv	s3,a1
    int bsem1 = bsem_alloc();
     e60:	00000097          	auipc	ra,0x0
     e64:	14e080e7          	jalr	334(ra) # fae <bsem_alloc>
     e68:	84aa                	mv	s1,a0
    int bsem2 = bsem_alloc();
     e6a:	00000097          	auipc	ra,0x0
     e6e:	144080e7          	jalr	324(ra) # fae <bsem_alloc>
    if (bsem1 == -1 || bsem2 == -1)
     e72:	57fd                	li	a5,-1
     e74:	00f48d63          	beq	s1,a5,e8e <csem_alloc+0x40>
     e78:	02f50863          	beq	a0,a5,ea8 <csem_alloc+0x5a>
        return -1; 
    sem->bsem1 = bsem1;
     e7c:	00992023          	sw	s1,0(s2)
    sem->bsem2 = bsem2;
     e80:	00a92223          	sw	a0,4(s2)
    if (count == 0)
     e84:	00098d63          	beqz	s3,e9e <csem_alloc+0x50>
        // Binary semaphore first value = min(1, count)
        bsem_down(sem->bsem2); 
    sem->count = count;
     e88:	01392423          	sw	s3,8(s2)
    return 0;
     e8c:	4481                	li	s1,0
}
     e8e:	8526                	mv	a0,s1
     e90:	70a2                	ld	ra,40(sp)
     e92:	7402                	ld	s0,32(sp)
     e94:	64e2                	ld	s1,24(sp)
     e96:	6942                	ld	s2,16(sp)
     e98:	69a2                	ld	s3,8(sp)
     e9a:	6145                	addi	sp,sp,48
     e9c:	8082                	ret
        bsem_down(sem->bsem2); 
     e9e:	00000097          	auipc	ra,0x0
     ea2:	0f8080e7          	jalr	248(ra) # f96 <bsem_down>
     ea6:	b7cd                	j	e88 <csem_alloc+0x3a>
        return -1; 
     ea8:	84aa                	mv	s1,a0
     eaa:	b7d5                	j	e8e <csem_alloc+0x40>

0000000000000eac <csem_free>:


void 
csem_free(struct counting_semaphore *sem) {
     eac:	1101                	addi	sp,sp,-32
     eae:	ec06                	sd	ra,24(sp)
     eb0:	e822                	sd	s0,16(sp)
     eb2:	e426                	sd	s1,8(sp)
     eb4:	1000                	addi	s0,sp,32
     eb6:	84aa                	mv	s1,a0
    bsem_free(sem->bsem1);
     eb8:	4108                	lw	a0,0(a0)
     eba:	00000097          	auipc	ra,0x0
     ebe:	0ec080e7          	jalr	236(ra) # fa6 <bsem_free>
    bsem_free(sem->bsem2);
     ec2:	40c8                	lw	a0,4(s1)
     ec4:	00000097          	auipc	ra,0x0
     ec8:	0e2080e7          	jalr	226(ra) # fa6 <bsem_free>
    //free(sem);
}
     ecc:	60e2                	ld	ra,24(sp)
     ece:	6442                	ld	s0,16(sp)
     ed0:	64a2                	ld	s1,8(sp)
     ed2:	6105                	addi	sp,sp,32
     ed4:	8082                	ret

0000000000000ed6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     ed6:	4885                	li	a7,1
 ecall
     ed8:	00000073          	ecall
 ret
     edc:	8082                	ret

0000000000000ede <exit>:
.global exit
exit:
 li a7, SYS_exit
     ede:	4889                	li	a7,2
 ecall
     ee0:	00000073          	ecall
 ret
     ee4:	8082                	ret

0000000000000ee6 <wait>:
.global wait
wait:
 li a7, SYS_wait
     ee6:	488d                	li	a7,3
 ecall
     ee8:	00000073          	ecall
 ret
     eec:	8082                	ret

0000000000000eee <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     eee:	4891                	li	a7,4
 ecall
     ef0:	00000073          	ecall
 ret
     ef4:	8082                	ret

0000000000000ef6 <read>:
.global read
read:
 li a7, SYS_read
     ef6:	4895                	li	a7,5
 ecall
     ef8:	00000073          	ecall
 ret
     efc:	8082                	ret

0000000000000efe <write>:
.global write
write:
 li a7, SYS_write
     efe:	48c1                	li	a7,16
 ecall
     f00:	00000073          	ecall
 ret
     f04:	8082                	ret

0000000000000f06 <close>:
.global close
close:
 li a7, SYS_close
     f06:	48d5                	li	a7,21
 ecall
     f08:	00000073          	ecall
 ret
     f0c:	8082                	ret

0000000000000f0e <kill>:
.global kill
kill:
 li a7, SYS_kill
     f0e:	4899                	li	a7,6
 ecall
     f10:	00000073          	ecall
 ret
     f14:	8082                	ret

0000000000000f16 <exec>:
.global exec
exec:
 li a7, SYS_exec
     f16:	489d                	li	a7,7
 ecall
     f18:	00000073          	ecall
 ret
     f1c:	8082                	ret

0000000000000f1e <open>:
.global open
open:
 li a7, SYS_open
     f1e:	48bd                	li	a7,15
 ecall
     f20:	00000073          	ecall
 ret
     f24:	8082                	ret

0000000000000f26 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     f26:	48c5                	li	a7,17
 ecall
     f28:	00000073          	ecall
 ret
     f2c:	8082                	ret

0000000000000f2e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     f2e:	48c9                	li	a7,18
 ecall
     f30:	00000073          	ecall
 ret
     f34:	8082                	ret

0000000000000f36 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     f36:	48a1                	li	a7,8
 ecall
     f38:	00000073          	ecall
 ret
     f3c:	8082                	ret

0000000000000f3e <link>:
.global link
link:
 li a7, SYS_link
     f3e:	48cd                	li	a7,19
 ecall
     f40:	00000073          	ecall
 ret
     f44:	8082                	ret

0000000000000f46 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f46:	48d1                	li	a7,20
 ecall
     f48:	00000073          	ecall
 ret
     f4c:	8082                	ret

0000000000000f4e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f4e:	48a5                	li	a7,9
 ecall
     f50:	00000073          	ecall
 ret
     f54:	8082                	ret

0000000000000f56 <dup>:
.global dup
dup:
 li a7, SYS_dup
     f56:	48a9                	li	a7,10
 ecall
     f58:	00000073          	ecall
 ret
     f5c:	8082                	ret

0000000000000f5e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f5e:	48ad                	li	a7,11
 ecall
     f60:	00000073          	ecall
 ret
     f64:	8082                	ret

0000000000000f66 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f66:	48b1                	li	a7,12
 ecall
     f68:	00000073          	ecall
 ret
     f6c:	8082                	ret

0000000000000f6e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f6e:	48b5                	li	a7,13
 ecall
     f70:	00000073          	ecall
 ret
     f74:	8082                	ret

0000000000000f76 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f76:	48b9                	li	a7,14
 ecall
     f78:	00000073          	ecall
 ret
     f7c:	8082                	ret

0000000000000f7e <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
     f7e:	48d9                	li	a7,22
 ecall
     f80:	00000073          	ecall
 ret
     f84:	8082                	ret

0000000000000f86 <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
     f86:	48dd                	li	a7,23
 ecall
     f88:	00000073          	ecall
 ret
     f8c:	8082                	ret

0000000000000f8e <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
     f8e:	48e1                	li	a7,24
 ecall
     f90:	00000073          	ecall
 ret
     f94:	8082                	ret

0000000000000f96 <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
     f96:	48ed                	li	a7,27
 ecall
     f98:	00000073          	ecall
 ret
     f9c:	8082                	ret

0000000000000f9e <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
     f9e:	48f1                	li	a7,28
 ecall
     fa0:	00000073          	ecall
 ret
     fa4:	8082                	ret

0000000000000fa6 <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
     fa6:	48e9                	li	a7,26
 ecall
     fa8:	00000073          	ecall
 ret
     fac:	8082                	ret

0000000000000fae <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
     fae:	48e5                	li	a7,25
 ecall
     fb0:	00000073          	ecall
 ret
     fb4:	8082                	ret

0000000000000fb6 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
     fb6:	48f5                	li	a7,29
 ecall
     fb8:	00000073          	ecall
 ret
     fbc:	8082                	ret

0000000000000fbe <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
     fbe:	48f9                	li	a7,30
 ecall
     fc0:	00000073          	ecall
 ret
     fc4:	8082                	ret

0000000000000fc6 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
     fc6:	48fd                	li	a7,31
 ecall
     fc8:	00000073          	ecall
 ret
     fcc:	8082                	ret

0000000000000fce <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
     fce:	02000893          	li	a7,32
 ecall
     fd2:	00000073          	ecall
 ret
     fd6:	8082                	ret

0000000000000fd8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     fd8:	1101                	addi	sp,sp,-32
     fda:	ec06                	sd	ra,24(sp)
     fdc:	e822                	sd	s0,16(sp)
     fde:	1000                	addi	s0,sp,32
     fe0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     fe4:	4605                	li	a2,1
     fe6:	fef40593          	addi	a1,s0,-17
     fea:	00000097          	auipc	ra,0x0
     fee:	f14080e7          	jalr	-236(ra) # efe <write>
}
     ff2:	60e2                	ld	ra,24(sp)
     ff4:	6442                	ld	s0,16(sp)
     ff6:	6105                	addi	sp,sp,32
     ff8:	8082                	ret

0000000000000ffa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ffa:	7139                	addi	sp,sp,-64
     ffc:	fc06                	sd	ra,56(sp)
     ffe:	f822                	sd	s0,48(sp)
    1000:	f426                	sd	s1,40(sp)
    1002:	f04a                	sd	s2,32(sp)
    1004:	ec4e                	sd	s3,24(sp)
    1006:	0080                	addi	s0,sp,64
    1008:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    100a:	c299                	beqz	a3,1010 <printint+0x16>
    100c:	0805c863          	bltz	a1,109c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1010:	2581                	sext.w	a1,a1
  neg = 0;
    1012:	4881                	li	a7,0
    1014:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1018:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    101a:	2601                	sext.w	a2,a2
    101c:	00000517          	auipc	a0,0x0
    1020:	58450513          	addi	a0,a0,1412 # 15a0 <digits>
    1024:	883a                	mv	a6,a4
    1026:	2705                	addiw	a4,a4,1
    1028:	02c5f7bb          	remuw	a5,a1,a2
    102c:	1782                	slli	a5,a5,0x20
    102e:	9381                	srli	a5,a5,0x20
    1030:	97aa                	add	a5,a5,a0
    1032:	0007c783          	lbu	a5,0(a5)
    1036:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    103a:	0005879b          	sext.w	a5,a1
    103e:	02c5d5bb          	divuw	a1,a1,a2
    1042:	0685                	addi	a3,a3,1
    1044:	fec7f0e3          	bgeu	a5,a2,1024 <printint+0x2a>
  if(neg)
    1048:	00088b63          	beqz	a7,105e <printint+0x64>
    buf[i++] = '-';
    104c:	fd040793          	addi	a5,s0,-48
    1050:	973e                	add	a4,a4,a5
    1052:	02d00793          	li	a5,45
    1056:	fef70823          	sb	a5,-16(a4)
    105a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    105e:	02e05863          	blez	a4,108e <printint+0x94>
    1062:	fc040793          	addi	a5,s0,-64
    1066:	00e78933          	add	s2,a5,a4
    106a:	fff78993          	addi	s3,a5,-1
    106e:	99ba                	add	s3,s3,a4
    1070:	377d                	addiw	a4,a4,-1
    1072:	1702                	slli	a4,a4,0x20
    1074:	9301                	srli	a4,a4,0x20
    1076:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    107a:	fff94583          	lbu	a1,-1(s2)
    107e:	8526                	mv	a0,s1
    1080:	00000097          	auipc	ra,0x0
    1084:	f58080e7          	jalr	-168(ra) # fd8 <putc>
  while(--i >= 0)
    1088:	197d                	addi	s2,s2,-1
    108a:	ff3918e3          	bne	s2,s3,107a <printint+0x80>
}
    108e:	70e2                	ld	ra,56(sp)
    1090:	7442                	ld	s0,48(sp)
    1092:	74a2                	ld	s1,40(sp)
    1094:	7902                	ld	s2,32(sp)
    1096:	69e2                	ld	s3,24(sp)
    1098:	6121                	addi	sp,sp,64
    109a:	8082                	ret
    x = -xx;
    109c:	40b005bb          	negw	a1,a1
    neg = 1;
    10a0:	4885                	li	a7,1
    x = -xx;
    10a2:	bf8d                	j	1014 <printint+0x1a>

00000000000010a4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    10a4:	7119                	addi	sp,sp,-128
    10a6:	fc86                	sd	ra,120(sp)
    10a8:	f8a2                	sd	s0,112(sp)
    10aa:	f4a6                	sd	s1,104(sp)
    10ac:	f0ca                	sd	s2,96(sp)
    10ae:	ecce                	sd	s3,88(sp)
    10b0:	e8d2                	sd	s4,80(sp)
    10b2:	e4d6                	sd	s5,72(sp)
    10b4:	e0da                	sd	s6,64(sp)
    10b6:	fc5e                	sd	s7,56(sp)
    10b8:	f862                	sd	s8,48(sp)
    10ba:	f466                	sd	s9,40(sp)
    10bc:	f06a                	sd	s10,32(sp)
    10be:	ec6e                	sd	s11,24(sp)
    10c0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    10c2:	0005c903          	lbu	s2,0(a1)
    10c6:	18090f63          	beqz	s2,1264 <vprintf+0x1c0>
    10ca:	8aaa                	mv	s5,a0
    10cc:	8b32                	mv	s6,a2
    10ce:	00158493          	addi	s1,a1,1
  state = 0;
    10d2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    10d4:	02500a13          	li	s4,37
      if(c == 'd'){
    10d8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    10dc:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    10e0:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    10e4:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10e8:	00000b97          	auipc	s7,0x0
    10ec:	4b8b8b93          	addi	s7,s7,1208 # 15a0 <digits>
    10f0:	a839                	j	110e <vprintf+0x6a>
        putc(fd, c);
    10f2:	85ca                	mv	a1,s2
    10f4:	8556                	mv	a0,s5
    10f6:	00000097          	auipc	ra,0x0
    10fa:	ee2080e7          	jalr	-286(ra) # fd8 <putc>
    10fe:	a019                	j	1104 <vprintf+0x60>
    } else if(state == '%'){
    1100:	01498f63          	beq	s3,s4,111e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    1104:	0485                	addi	s1,s1,1
    1106:	fff4c903          	lbu	s2,-1(s1)
    110a:	14090d63          	beqz	s2,1264 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    110e:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1112:	fe0997e3          	bnez	s3,1100 <vprintf+0x5c>
      if(c == '%'){
    1116:	fd479ee3          	bne	a5,s4,10f2 <vprintf+0x4e>
        state = '%';
    111a:	89be                	mv	s3,a5
    111c:	b7e5                	j	1104 <vprintf+0x60>
      if(c == 'd'){
    111e:	05878063          	beq	a5,s8,115e <vprintf+0xba>
      } else if(c == 'l') {
    1122:	05978c63          	beq	a5,s9,117a <vprintf+0xd6>
      } else if(c == 'x') {
    1126:	07a78863          	beq	a5,s10,1196 <vprintf+0xf2>
      } else if(c == 'p') {
    112a:	09b78463          	beq	a5,s11,11b2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    112e:	07300713          	li	a4,115
    1132:	0ce78663          	beq	a5,a4,11fe <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1136:	06300713          	li	a4,99
    113a:	0ee78e63          	beq	a5,a4,1236 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    113e:	11478863          	beq	a5,s4,124e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1142:	85d2                	mv	a1,s4
    1144:	8556                	mv	a0,s5
    1146:	00000097          	auipc	ra,0x0
    114a:	e92080e7          	jalr	-366(ra) # fd8 <putc>
        putc(fd, c);
    114e:	85ca                	mv	a1,s2
    1150:	8556                	mv	a0,s5
    1152:	00000097          	auipc	ra,0x0
    1156:	e86080e7          	jalr	-378(ra) # fd8 <putc>
      }
      state = 0;
    115a:	4981                	li	s3,0
    115c:	b765                	j	1104 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    115e:	008b0913          	addi	s2,s6,8
    1162:	4685                	li	a3,1
    1164:	4629                	li	a2,10
    1166:	000b2583          	lw	a1,0(s6)
    116a:	8556                	mv	a0,s5
    116c:	00000097          	auipc	ra,0x0
    1170:	e8e080e7          	jalr	-370(ra) # ffa <printint>
    1174:	8b4a                	mv	s6,s2
      state = 0;
    1176:	4981                	li	s3,0
    1178:	b771                	j	1104 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    117a:	008b0913          	addi	s2,s6,8
    117e:	4681                	li	a3,0
    1180:	4629                	li	a2,10
    1182:	000b2583          	lw	a1,0(s6)
    1186:	8556                	mv	a0,s5
    1188:	00000097          	auipc	ra,0x0
    118c:	e72080e7          	jalr	-398(ra) # ffa <printint>
    1190:	8b4a                	mv	s6,s2
      state = 0;
    1192:	4981                	li	s3,0
    1194:	bf85                	j	1104 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1196:	008b0913          	addi	s2,s6,8
    119a:	4681                	li	a3,0
    119c:	4641                	li	a2,16
    119e:	000b2583          	lw	a1,0(s6)
    11a2:	8556                	mv	a0,s5
    11a4:	00000097          	auipc	ra,0x0
    11a8:	e56080e7          	jalr	-426(ra) # ffa <printint>
    11ac:	8b4a                	mv	s6,s2
      state = 0;
    11ae:	4981                	li	s3,0
    11b0:	bf91                	j	1104 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    11b2:	008b0793          	addi	a5,s6,8
    11b6:	f8f43423          	sd	a5,-120(s0)
    11ba:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    11be:	03000593          	li	a1,48
    11c2:	8556                	mv	a0,s5
    11c4:	00000097          	auipc	ra,0x0
    11c8:	e14080e7          	jalr	-492(ra) # fd8 <putc>
  putc(fd, 'x');
    11cc:	85ea                	mv	a1,s10
    11ce:	8556                	mv	a0,s5
    11d0:	00000097          	auipc	ra,0x0
    11d4:	e08080e7          	jalr	-504(ra) # fd8 <putc>
    11d8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    11da:	03c9d793          	srli	a5,s3,0x3c
    11de:	97de                	add	a5,a5,s7
    11e0:	0007c583          	lbu	a1,0(a5)
    11e4:	8556                	mv	a0,s5
    11e6:	00000097          	auipc	ra,0x0
    11ea:	df2080e7          	jalr	-526(ra) # fd8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    11ee:	0992                	slli	s3,s3,0x4
    11f0:	397d                	addiw	s2,s2,-1
    11f2:	fe0914e3          	bnez	s2,11da <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    11f6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    11fa:	4981                	li	s3,0
    11fc:	b721                	j	1104 <vprintf+0x60>
        s = va_arg(ap, char*);
    11fe:	008b0993          	addi	s3,s6,8
    1202:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    1206:	02090163          	beqz	s2,1228 <vprintf+0x184>
        while(*s != 0){
    120a:	00094583          	lbu	a1,0(s2)
    120e:	c9a1                	beqz	a1,125e <vprintf+0x1ba>
          putc(fd, *s);
    1210:	8556                	mv	a0,s5
    1212:	00000097          	auipc	ra,0x0
    1216:	dc6080e7          	jalr	-570(ra) # fd8 <putc>
          s++;
    121a:	0905                	addi	s2,s2,1
        while(*s != 0){
    121c:	00094583          	lbu	a1,0(s2)
    1220:	f9e5                	bnez	a1,1210 <vprintf+0x16c>
        s = va_arg(ap, char*);
    1222:	8b4e                	mv	s6,s3
      state = 0;
    1224:	4981                	li	s3,0
    1226:	bdf9                	j	1104 <vprintf+0x60>
          s = "(null)";
    1228:	00000917          	auipc	s2,0x0
    122c:	37090913          	addi	s2,s2,880 # 1598 <malloc+0x22a>
        while(*s != 0){
    1230:	02800593          	li	a1,40
    1234:	bff1                	j	1210 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    1236:	008b0913          	addi	s2,s6,8
    123a:	000b4583          	lbu	a1,0(s6)
    123e:	8556                	mv	a0,s5
    1240:	00000097          	auipc	ra,0x0
    1244:	d98080e7          	jalr	-616(ra) # fd8 <putc>
    1248:	8b4a                	mv	s6,s2
      state = 0;
    124a:	4981                	li	s3,0
    124c:	bd65                	j	1104 <vprintf+0x60>
        putc(fd, c);
    124e:	85d2                	mv	a1,s4
    1250:	8556                	mv	a0,s5
    1252:	00000097          	auipc	ra,0x0
    1256:	d86080e7          	jalr	-634(ra) # fd8 <putc>
      state = 0;
    125a:	4981                	li	s3,0
    125c:	b565                	j	1104 <vprintf+0x60>
        s = va_arg(ap, char*);
    125e:	8b4e                	mv	s6,s3
      state = 0;
    1260:	4981                	li	s3,0
    1262:	b54d                	j	1104 <vprintf+0x60>
    }
  }
}
    1264:	70e6                	ld	ra,120(sp)
    1266:	7446                	ld	s0,112(sp)
    1268:	74a6                	ld	s1,104(sp)
    126a:	7906                	ld	s2,96(sp)
    126c:	69e6                	ld	s3,88(sp)
    126e:	6a46                	ld	s4,80(sp)
    1270:	6aa6                	ld	s5,72(sp)
    1272:	6b06                	ld	s6,64(sp)
    1274:	7be2                	ld	s7,56(sp)
    1276:	7c42                	ld	s8,48(sp)
    1278:	7ca2                	ld	s9,40(sp)
    127a:	7d02                	ld	s10,32(sp)
    127c:	6de2                	ld	s11,24(sp)
    127e:	6109                	addi	sp,sp,128
    1280:	8082                	ret

0000000000001282 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1282:	715d                	addi	sp,sp,-80
    1284:	ec06                	sd	ra,24(sp)
    1286:	e822                	sd	s0,16(sp)
    1288:	1000                	addi	s0,sp,32
    128a:	e010                	sd	a2,0(s0)
    128c:	e414                	sd	a3,8(s0)
    128e:	e818                	sd	a4,16(s0)
    1290:	ec1c                	sd	a5,24(s0)
    1292:	03043023          	sd	a6,32(s0)
    1296:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    129a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    129e:	8622                	mv	a2,s0
    12a0:	00000097          	auipc	ra,0x0
    12a4:	e04080e7          	jalr	-508(ra) # 10a4 <vprintf>
}
    12a8:	60e2                	ld	ra,24(sp)
    12aa:	6442                	ld	s0,16(sp)
    12ac:	6161                	addi	sp,sp,80
    12ae:	8082                	ret

00000000000012b0 <printf>:

void
printf(const char *fmt, ...)
{
    12b0:	711d                	addi	sp,sp,-96
    12b2:	ec06                	sd	ra,24(sp)
    12b4:	e822                	sd	s0,16(sp)
    12b6:	1000                	addi	s0,sp,32
    12b8:	e40c                	sd	a1,8(s0)
    12ba:	e810                	sd	a2,16(s0)
    12bc:	ec14                	sd	a3,24(s0)
    12be:	f018                	sd	a4,32(s0)
    12c0:	f41c                	sd	a5,40(s0)
    12c2:	03043823          	sd	a6,48(s0)
    12c6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    12ca:	00840613          	addi	a2,s0,8
    12ce:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    12d2:	85aa                	mv	a1,a0
    12d4:	4505                	li	a0,1
    12d6:	00000097          	auipc	ra,0x0
    12da:	dce080e7          	jalr	-562(ra) # 10a4 <vprintf>
}
    12de:	60e2                	ld	ra,24(sp)
    12e0:	6442                	ld	s0,16(sp)
    12e2:	6125                	addi	sp,sp,96
    12e4:	8082                	ret

00000000000012e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    12e6:	1141                	addi	sp,sp,-16
    12e8:	e422                	sd	s0,8(sp)
    12ea:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    12ec:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12f0:	00000797          	auipc	a5,0x0
    12f4:	2d87b783          	ld	a5,728(a5) # 15c8 <freep>
    12f8:	a805                	j	1328 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    12fa:	4618                	lw	a4,8(a2)
    12fc:	9db9                	addw	a1,a1,a4
    12fe:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1302:	6398                	ld	a4,0(a5)
    1304:	6318                	ld	a4,0(a4)
    1306:	fee53823          	sd	a4,-16(a0)
    130a:	a091                	j	134e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    130c:	ff852703          	lw	a4,-8(a0)
    1310:	9e39                	addw	a2,a2,a4
    1312:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1314:	ff053703          	ld	a4,-16(a0)
    1318:	e398                	sd	a4,0(a5)
    131a:	a099                	j	1360 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    131c:	6398                	ld	a4,0(a5)
    131e:	00e7e463          	bltu	a5,a4,1326 <free+0x40>
    1322:	00e6ea63          	bltu	a3,a4,1336 <free+0x50>
{
    1326:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1328:	fed7fae3          	bgeu	a5,a3,131c <free+0x36>
    132c:	6398                	ld	a4,0(a5)
    132e:	00e6e463          	bltu	a3,a4,1336 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1332:	fee7eae3          	bltu	a5,a4,1326 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1336:	ff852583          	lw	a1,-8(a0)
    133a:	6390                	ld	a2,0(a5)
    133c:	02059813          	slli	a6,a1,0x20
    1340:	01c85713          	srli	a4,a6,0x1c
    1344:	9736                	add	a4,a4,a3
    1346:	fae60ae3          	beq	a2,a4,12fa <free+0x14>
    bp->s.ptr = p->s.ptr;
    134a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    134e:	4790                	lw	a2,8(a5)
    1350:	02061593          	slli	a1,a2,0x20
    1354:	01c5d713          	srli	a4,a1,0x1c
    1358:	973e                	add	a4,a4,a5
    135a:	fae689e3          	beq	a3,a4,130c <free+0x26>
  } else
    p->s.ptr = bp;
    135e:	e394                	sd	a3,0(a5)
  freep = p;
    1360:	00000717          	auipc	a4,0x0
    1364:	26f73423          	sd	a5,616(a4) # 15c8 <freep>
}
    1368:	6422                	ld	s0,8(sp)
    136a:	0141                	addi	sp,sp,16
    136c:	8082                	ret

000000000000136e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    136e:	7139                	addi	sp,sp,-64
    1370:	fc06                	sd	ra,56(sp)
    1372:	f822                	sd	s0,48(sp)
    1374:	f426                	sd	s1,40(sp)
    1376:	f04a                	sd	s2,32(sp)
    1378:	ec4e                	sd	s3,24(sp)
    137a:	e852                	sd	s4,16(sp)
    137c:	e456                	sd	s5,8(sp)
    137e:	e05a                	sd	s6,0(sp)
    1380:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1382:	02051493          	slli	s1,a0,0x20
    1386:	9081                	srli	s1,s1,0x20
    1388:	04bd                	addi	s1,s1,15
    138a:	8091                	srli	s1,s1,0x4
    138c:	0014899b          	addiw	s3,s1,1
    1390:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1392:	00000517          	auipc	a0,0x0
    1396:	23653503          	ld	a0,566(a0) # 15c8 <freep>
    139a:	c515                	beqz	a0,13c6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    139c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    139e:	4798                	lw	a4,8(a5)
    13a0:	02977f63          	bgeu	a4,s1,13de <malloc+0x70>
    13a4:	8a4e                	mv	s4,s3
    13a6:	0009871b          	sext.w	a4,s3
    13aa:	6685                	lui	a3,0x1
    13ac:	00d77363          	bgeu	a4,a3,13b2 <malloc+0x44>
    13b0:	6a05                	lui	s4,0x1
    13b2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    13b6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    13ba:	00000917          	auipc	s2,0x0
    13be:	20e90913          	addi	s2,s2,526 # 15c8 <freep>
  if(p == (char*)-1)
    13c2:	5afd                	li	s5,-1
    13c4:	a895                	j	1438 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    13c6:	00000797          	auipc	a5,0x0
    13ca:	27278793          	addi	a5,a5,626 # 1638 <base>
    13ce:	00000717          	auipc	a4,0x0
    13d2:	1ef73d23          	sd	a5,506(a4) # 15c8 <freep>
    13d6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    13d8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    13dc:	b7e1                	j	13a4 <malloc+0x36>
      if(p->s.size == nunits)
    13de:	02e48c63          	beq	s1,a4,1416 <malloc+0xa8>
        p->s.size -= nunits;
    13e2:	4137073b          	subw	a4,a4,s3
    13e6:	c798                	sw	a4,8(a5)
        p += p->s.size;
    13e8:	02071693          	slli	a3,a4,0x20
    13ec:	01c6d713          	srli	a4,a3,0x1c
    13f0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    13f2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    13f6:	00000717          	auipc	a4,0x0
    13fa:	1ca73923          	sd	a0,466(a4) # 15c8 <freep>
      return (void*)(p + 1);
    13fe:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1402:	70e2                	ld	ra,56(sp)
    1404:	7442                	ld	s0,48(sp)
    1406:	74a2                	ld	s1,40(sp)
    1408:	7902                	ld	s2,32(sp)
    140a:	69e2                	ld	s3,24(sp)
    140c:	6a42                	ld	s4,16(sp)
    140e:	6aa2                	ld	s5,8(sp)
    1410:	6b02                	ld	s6,0(sp)
    1412:	6121                	addi	sp,sp,64
    1414:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1416:	6398                	ld	a4,0(a5)
    1418:	e118                	sd	a4,0(a0)
    141a:	bff1                	j	13f6 <malloc+0x88>
  hp->s.size = nu;
    141c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1420:	0541                	addi	a0,a0,16
    1422:	00000097          	auipc	ra,0x0
    1426:	ec4080e7          	jalr	-316(ra) # 12e6 <free>
  return freep;
    142a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    142e:	d971                	beqz	a0,1402 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1430:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1432:	4798                	lw	a4,8(a5)
    1434:	fa9775e3          	bgeu	a4,s1,13de <malloc+0x70>
    if(p == freep)
    1438:	00093703          	ld	a4,0(s2)
    143c:	853e                	mv	a0,a5
    143e:	fef719e3          	bne	a4,a5,1430 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    1442:	8552                	mv	a0,s4
    1444:	00000097          	auipc	ra,0x0
    1448:	b22080e7          	jalr	-1246(ra) # f66 <sbrk>
  if(p == (char*)-1)
    144c:	fd5518e3          	bne	a0,s5,141c <malloc+0xae>
        return 0;
    1450:	4501                	li	a0,0
    1452:	bf45                	j	1402 <malloc+0x94>
