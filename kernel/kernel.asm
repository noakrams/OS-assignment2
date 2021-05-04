
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	18010113          	addi	sp,sp,384 # 80009180 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	ra,8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	00009717          	auipc	a4,0x9
    80000056:	fee70713          	addi	a4,a4,-18 # 80009040 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	00006797          	auipc	a5,0x6
    80000068:	fcc78793          	addi	a5,a5,-52 # 80006030 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffcd7ff>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	dbe78793          	addi	a5,a5,-578 # 80000e6c <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  timerinit();
    800000d8:	00000097          	auipc	ra,0x0
    800000dc:	f44080e7          	jalr	-188(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000e0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000e4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000e6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e8:	30200073          	mret
}
    800000ec:	60a2                	ld	ra,8(sp)
    800000ee:	6402                	ld	s0,0(sp)
    800000f0:	0141                	addi	sp,sp,16
    800000f2:	8082                	ret

00000000800000f4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000f4:	715d                	addi	sp,sp,-80
    800000f6:	e486                	sd	ra,72(sp)
    800000f8:	e0a2                	sd	s0,64(sp)
    800000fa:	fc26                	sd	s1,56(sp)
    800000fc:	f84a                	sd	s2,48(sp)
    800000fe:	f44e                	sd	s3,40(sp)
    80000100:	f052                	sd	s4,32(sp)
    80000102:	ec56                	sd	s5,24(sp)
    80000104:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000106:	04c05663          	blez	a2,80000152 <consolewrite+0x5e>
    8000010a:	8a2a                	mv	s4,a0
    8000010c:	84ae                	mv	s1,a1
    8000010e:	89b2                	mv	s3,a2
    80000110:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000112:	5afd                	li	s5,-1
    80000114:	4685                	li	a3,1
    80000116:	8626                	mv	a2,s1
    80000118:	85d2                	mv	a1,s4
    8000011a:	fbf40513          	addi	a0,s0,-65
    8000011e:	00002097          	auipc	ra,0x2
    80000122:	3e4080e7          	jalr	996(ra) # 80002502 <either_copyin>
    80000126:	01550c63          	beq	a0,s5,8000013e <consolewrite+0x4a>
      break;
    uartputc(c);
    8000012a:	fbf44503          	lbu	a0,-65(s0)
    8000012e:	00000097          	auipc	ra,0x0
    80000132:	77a080e7          	jalr	1914(ra) # 800008a8 <uartputc>
  for(i = 0; i < n; i++){
    80000136:	2905                	addiw	s2,s2,1
    80000138:	0485                	addi	s1,s1,1
    8000013a:	fd299de3          	bne	s3,s2,80000114 <consolewrite+0x20>
  }

  return i;
}
    8000013e:	854a                	mv	a0,s2
    80000140:	60a6                	ld	ra,72(sp)
    80000142:	6406                	ld	s0,64(sp)
    80000144:	74e2                	ld	s1,56(sp)
    80000146:	7942                	ld	s2,48(sp)
    80000148:	79a2                	ld	s3,40(sp)
    8000014a:	7a02                	ld	s4,32(sp)
    8000014c:	6ae2                	ld	s5,24(sp)
    8000014e:	6161                	addi	sp,sp,80
    80000150:	8082                	ret
  for(i = 0; i < n; i++){
    80000152:	4901                	li	s2,0
    80000154:	b7ed                	j	8000013e <consolewrite+0x4a>

0000000080000156 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000156:	7159                	addi	sp,sp,-112
    80000158:	f486                	sd	ra,104(sp)
    8000015a:	f0a2                	sd	s0,96(sp)
    8000015c:	eca6                	sd	s1,88(sp)
    8000015e:	e8ca                	sd	s2,80(sp)
    80000160:	e4ce                	sd	s3,72(sp)
    80000162:	e0d2                	sd	s4,64(sp)
    80000164:	fc56                	sd	s5,56(sp)
    80000166:	f85a                	sd	s6,48(sp)
    80000168:	f45e                	sd	s7,40(sp)
    8000016a:	f062                	sd	s8,32(sp)
    8000016c:	ec66                	sd	s9,24(sp)
    8000016e:	e86a                	sd	s10,16(sp)
    80000170:	1880                	addi	s0,sp,112
    80000172:	8aaa                	mv	s5,a0
    80000174:	8a2e                	mv	s4,a1
    80000176:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000178:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000017c:	00011517          	auipc	a0,0x11
    80000180:	00450513          	addi	a0,a0,4 # 80011180 <cons>
    80000184:	00001097          	auipc	ra,0x1
    80000188:	a3e080e7          	jalr	-1474(ra) # 80000bc2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000018c:	00011497          	auipc	s1,0x11
    80000190:	ff448493          	addi	s1,s1,-12 # 80011180 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000194:	00011917          	auipc	s2,0x11
    80000198:	08490913          	addi	s2,s2,132 # 80011218 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    8000019c:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000019e:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001a0:	4ca9                	li	s9,10
  while(n > 0){
    800001a2:	07305863          	blez	s3,80000212 <consoleread+0xbc>
    while(cons.r == cons.w){
    800001a6:	0984a783          	lw	a5,152(s1)
    800001aa:	09c4a703          	lw	a4,156(s1)
    800001ae:	02f71463          	bne	a4,a5,800001d6 <consoleread+0x80>
      if(myproc()->killed){
    800001b2:	00001097          	auipc	ra,0x1
    800001b6:	7cc080e7          	jalr	1996(ra) # 8000197e <myproc>
    800001ba:	551c                	lw	a5,40(a0)
    800001bc:	e7b5                	bnez	a5,80000228 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001be:	85a6                	mv	a1,s1
    800001c0:	854a                	mv	a0,s2
    800001c2:	00002097          	auipc	ra,0x2
    800001c6:	f20080e7          	jalr	-224(ra) # 800020e2 <sleep>
    while(cons.r == cons.w){
    800001ca:	0984a783          	lw	a5,152(s1)
    800001ce:	09c4a703          	lw	a4,156(s1)
    800001d2:	fef700e3          	beq	a4,a5,800001b2 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001d6:	0017871b          	addiw	a4,a5,1
    800001da:	08e4ac23          	sw	a4,152(s1)
    800001de:	07f7f713          	andi	a4,a5,127
    800001e2:	9726                	add	a4,a4,s1
    800001e4:	01874703          	lbu	a4,24(a4)
    800001e8:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800001ec:	077d0563          	beq	s10,s7,80000256 <consoleread+0x100>
    cbuf = c;
    800001f0:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001f4:	4685                	li	a3,1
    800001f6:	f9f40613          	addi	a2,s0,-97
    800001fa:	85d2                	mv	a1,s4
    800001fc:	8556                	mv	a0,s5
    800001fe:	00002097          	auipc	ra,0x2
    80000202:	2ae080e7          	jalr	686(ra) # 800024ac <either_copyout>
    80000206:	01850663          	beq	a0,s8,80000212 <consoleread+0xbc>
    dst++;
    8000020a:	0a05                	addi	s4,s4,1
    --n;
    8000020c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    8000020e:	f99d1ae3          	bne	s10,s9,800001a2 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000212:	00011517          	auipc	a0,0x11
    80000216:	f6e50513          	addi	a0,a0,-146 # 80011180 <cons>
    8000021a:	00001097          	auipc	ra,0x1
    8000021e:	a5c080e7          	jalr	-1444(ra) # 80000c76 <release>

  return target - n;
    80000222:	413b053b          	subw	a0,s6,s3
    80000226:	a811                	j	8000023a <consoleread+0xe4>
        release(&cons.lock);
    80000228:	00011517          	auipc	a0,0x11
    8000022c:	f5850513          	addi	a0,a0,-168 # 80011180 <cons>
    80000230:	00001097          	auipc	ra,0x1
    80000234:	a46080e7          	jalr	-1466(ra) # 80000c76 <release>
        return -1;
    80000238:	557d                	li	a0,-1
}
    8000023a:	70a6                	ld	ra,104(sp)
    8000023c:	7406                	ld	s0,96(sp)
    8000023e:	64e6                	ld	s1,88(sp)
    80000240:	6946                	ld	s2,80(sp)
    80000242:	69a6                	ld	s3,72(sp)
    80000244:	6a06                	ld	s4,64(sp)
    80000246:	7ae2                	ld	s5,56(sp)
    80000248:	7b42                	ld	s6,48(sp)
    8000024a:	7ba2                	ld	s7,40(sp)
    8000024c:	7c02                	ld	s8,32(sp)
    8000024e:	6ce2                	ld	s9,24(sp)
    80000250:	6d42                	ld	s10,16(sp)
    80000252:	6165                	addi	sp,sp,112
    80000254:	8082                	ret
      if(n < target){
    80000256:	0009871b          	sext.w	a4,s3
    8000025a:	fb677ce3          	bgeu	a4,s6,80000212 <consoleread+0xbc>
        cons.r--;
    8000025e:	00011717          	auipc	a4,0x11
    80000262:	faf72d23          	sw	a5,-70(a4) # 80011218 <cons+0x98>
    80000266:	b775                	j	80000212 <consoleread+0xbc>

0000000080000268 <consputc>:
{
    80000268:	1141                	addi	sp,sp,-16
    8000026a:	e406                	sd	ra,8(sp)
    8000026c:	e022                	sd	s0,0(sp)
    8000026e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000270:	10000793          	li	a5,256
    80000274:	00f50a63          	beq	a0,a5,80000288 <consputc+0x20>
    uartputc_sync(c);
    80000278:	00000097          	auipc	ra,0x0
    8000027c:	55e080e7          	jalr	1374(ra) # 800007d6 <uartputc_sync>
}
    80000280:	60a2                	ld	ra,8(sp)
    80000282:	6402                	ld	s0,0(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000288:	4521                	li	a0,8
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	54c080e7          	jalr	1356(ra) # 800007d6 <uartputc_sync>
    80000292:	02000513          	li	a0,32
    80000296:	00000097          	auipc	ra,0x0
    8000029a:	540080e7          	jalr	1344(ra) # 800007d6 <uartputc_sync>
    8000029e:	4521                	li	a0,8
    800002a0:	00000097          	auipc	ra,0x0
    800002a4:	536080e7          	jalr	1334(ra) # 800007d6 <uartputc_sync>
    800002a8:	bfe1                	j	80000280 <consputc+0x18>

00000000800002aa <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002aa:	1101                	addi	sp,sp,-32
    800002ac:	ec06                	sd	ra,24(sp)
    800002ae:	e822                	sd	s0,16(sp)
    800002b0:	e426                	sd	s1,8(sp)
    800002b2:	e04a                	sd	s2,0(sp)
    800002b4:	1000                	addi	s0,sp,32
    800002b6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b8:	00011517          	auipc	a0,0x11
    800002bc:	ec850513          	addi	a0,a0,-312 # 80011180 <cons>
    800002c0:	00001097          	auipc	ra,0x1
    800002c4:	902080e7          	jalr	-1790(ra) # 80000bc2 <acquire>

  switch(c){
    800002c8:	47d5                	li	a5,21
    800002ca:	0af48663          	beq	s1,a5,80000376 <consoleintr+0xcc>
    800002ce:	0297ca63          	blt	a5,s1,80000302 <consoleintr+0x58>
    800002d2:	47a1                	li	a5,8
    800002d4:	0ef48763          	beq	s1,a5,800003c2 <consoleintr+0x118>
    800002d8:	47c1                	li	a5,16
    800002da:	10f49a63          	bne	s1,a5,800003ee <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002de:	00002097          	auipc	ra,0x2
    800002e2:	27a080e7          	jalr	634(ra) # 80002558 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002e6:	00011517          	auipc	a0,0x11
    800002ea:	e9a50513          	addi	a0,a0,-358 # 80011180 <cons>
    800002ee:	00001097          	auipc	ra,0x1
    800002f2:	988080e7          	jalr	-1656(ra) # 80000c76 <release>
}
    800002f6:	60e2                	ld	ra,24(sp)
    800002f8:	6442                	ld	s0,16(sp)
    800002fa:	64a2                	ld	s1,8(sp)
    800002fc:	6902                	ld	s2,0(sp)
    800002fe:	6105                	addi	sp,sp,32
    80000300:	8082                	ret
  switch(c){
    80000302:	07f00793          	li	a5,127
    80000306:	0af48e63          	beq	s1,a5,800003c2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000030a:	00011717          	auipc	a4,0x11
    8000030e:	e7670713          	addi	a4,a4,-394 # 80011180 <cons>
    80000312:	0a072783          	lw	a5,160(a4)
    80000316:	09872703          	lw	a4,152(a4)
    8000031a:	9f99                	subw	a5,a5,a4
    8000031c:	07f00713          	li	a4,127
    80000320:	fcf763e3          	bltu	a4,a5,800002e6 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000324:	47b5                	li	a5,13
    80000326:	0cf48763          	beq	s1,a5,800003f4 <consoleintr+0x14a>
      consputc(c);
    8000032a:	8526                	mv	a0,s1
    8000032c:	00000097          	auipc	ra,0x0
    80000330:	f3c080e7          	jalr	-196(ra) # 80000268 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000334:	00011797          	auipc	a5,0x11
    80000338:	e4c78793          	addi	a5,a5,-436 # 80011180 <cons>
    8000033c:	0a07a703          	lw	a4,160(a5)
    80000340:	0017069b          	addiw	a3,a4,1
    80000344:	0006861b          	sext.w	a2,a3
    80000348:	0ad7a023          	sw	a3,160(a5)
    8000034c:	07f77713          	andi	a4,a4,127
    80000350:	97ba                	add	a5,a5,a4
    80000352:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000356:	47a9                	li	a5,10
    80000358:	0cf48563          	beq	s1,a5,80000422 <consoleintr+0x178>
    8000035c:	4791                	li	a5,4
    8000035e:	0cf48263          	beq	s1,a5,80000422 <consoleintr+0x178>
    80000362:	00011797          	auipc	a5,0x11
    80000366:	eb67a783          	lw	a5,-330(a5) # 80011218 <cons+0x98>
    8000036a:	0807879b          	addiw	a5,a5,128
    8000036e:	f6f61ce3          	bne	a2,a5,800002e6 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000372:	863e                	mv	a2,a5
    80000374:	a07d                	j	80000422 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000376:	00011717          	auipc	a4,0x11
    8000037a:	e0a70713          	addi	a4,a4,-502 # 80011180 <cons>
    8000037e:	0a072783          	lw	a5,160(a4)
    80000382:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000386:	00011497          	auipc	s1,0x11
    8000038a:	dfa48493          	addi	s1,s1,-518 # 80011180 <cons>
    while(cons.e != cons.w &&
    8000038e:	4929                	li	s2,10
    80000390:	f4f70be3          	beq	a4,a5,800002e6 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000394:	37fd                	addiw	a5,a5,-1
    80000396:	07f7f713          	andi	a4,a5,127
    8000039a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000039c:	01874703          	lbu	a4,24(a4)
    800003a0:	f52703e3          	beq	a4,s2,800002e6 <consoleintr+0x3c>
      cons.e--;
    800003a4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003a8:	10000513          	li	a0,256
    800003ac:	00000097          	auipc	ra,0x0
    800003b0:	ebc080e7          	jalr	-324(ra) # 80000268 <consputc>
    while(cons.e != cons.w &&
    800003b4:	0a04a783          	lw	a5,160(s1)
    800003b8:	09c4a703          	lw	a4,156(s1)
    800003bc:	fcf71ce3          	bne	a4,a5,80000394 <consoleintr+0xea>
    800003c0:	b71d                	j	800002e6 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003c2:	00011717          	auipc	a4,0x11
    800003c6:	dbe70713          	addi	a4,a4,-578 # 80011180 <cons>
    800003ca:	0a072783          	lw	a5,160(a4)
    800003ce:	09c72703          	lw	a4,156(a4)
    800003d2:	f0f70ae3          	beq	a4,a5,800002e6 <consoleintr+0x3c>
      cons.e--;
    800003d6:	37fd                	addiw	a5,a5,-1
    800003d8:	00011717          	auipc	a4,0x11
    800003dc:	e4f72423          	sw	a5,-440(a4) # 80011220 <cons+0xa0>
      consputc(BACKSPACE);
    800003e0:	10000513          	li	a0,256
    800003e4:	00000097          	auipc	ra,0x0
    800003e8:	e84080e7          	jalr	-380(ra) # 80000268 <consputc>
    800003ec:	bded                	j	800002e6 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800003ee:	ee048ce3          	beqz	s1,800002e6 <consoleintr+0x3c>
    800003f2:	bf21                	j	8000030a <consoleintr+0x60>
      consputc(c);
    800003f4:	4529                	li	a0,10
    800003f6:	00000097          	auipc	ra,0x0
    800003fa:	e72080e7          	jalr	-398(ra) # 80000268 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800003fe:	00011797          	auipc	a5,0x11
    80000402:	d8278793          	addi	a5,a5,-638 # 80011180 <cons>
    80000406:	0a07a703          	lw	a4,160(a5)
    8000040a:	0017069b          	addiw	a3,a4,1
    8000040e:	0006861b          	sext.w	a2,a3
    80000412:	0ad7a023          	sw	a3,160(a5)
    80000416:	07f77713          	andi	a4,a4,127
    8000041a:	97ba                	add	a5,a5,a4
    8000041c:	4729                	li	a4,10
    8000041e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000422:	00011797          	auipc	a5,0x11
    80000426:	dec7ad23          	sw	a2,-518(a5) # 8001121c <cons+0x9c>
        wakeup(&cons.r);
    8000042a:	00011517          	auipc	a0,0x11
    8000042e:	dee50513          	addi	a0,a0,-530 # 80011218 <cons+0x98>
    80000432:	00002097          	auipc	ra,0x2
    80000436:	e3c080e7          	jalr	-452(ra) # 8000226e <wakeup>
    8000043a:	b575                	j	800002e6 <consoleintr+0x3c>

000000008000043c <consoleinit>:

void
consoleinit(void)
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e406                	sd	ra,8(sp)
    80000440:	e022                	sd	s0,0(sp)
    80000442:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000444:	00008597          	auipc	a1,0x8
    80000448:	bcc58593          	addi	a1,a1,-1076 # 80008010 <etext+0x10>
    8000044c:	00011517          	auipc	a0,0x11
    80000450:	d3450513          	addi	a0,a0,-716 # 80011180 <cons>
    80000454:	00000097          	auipc	ra,0x0
    80000458:	6de080e7          	jalr	1758(ra) # 80000b32 <initlock>

  uartinit();
    8000045c:	00000097          	auipc	ra,0x0
    80000460:	32a080e7          	jalr	810(ra) # 80000786 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000464:	0002c797          	auipc	a5,0x2c
    80000468:	cb478793          	addi	a5,a5,-844 # 8002c118 <devsw>
    8000046c:	00000717          	auipc	a4,0x0
    80000470:	cea70713          	addi	a4,a4,-790 # 80000156 <consoleread>
    80000474:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000476:	00000717          	auipc	a4,0x0
    8000047a:	c7e70713          	addi	a4,a4,-898 # 800000f4 <consolewrite>
    8000047e:	ef98                	sd	a4,24(a5)
}
    80000480:	60a2                	ld	ra,8(sp)
    80000482:	6402                	ld	s0,0(sp)
    80000484:	0141                	addi	sp,sp,16
    80000486:	8082                	ret

0000000080000488 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80000488:	7179                	addi	sp,sp,-48
    8000048a:	f406                	sd	ra,40(sp)
    8000048c:	f022                	sd	s0,32(sp)
    8000048e:	ec26                	sd	s1,24(sp)
    80000490:	e84a                	sd	s2,16(sp)
    80000492:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80000494:	c219                	beqz	a2,8000049a <printint+0x12>
    80000496:	08054663          	bltz	a0,80000522 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    8000049a:	2501                	sext.w	a0,a0
    8000049c:	4881                	li	a7,0
    8000049e:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004a2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004a4:	2581                	sext.w	a1,a1
    800004a6:	00008617          	auipc	a2,0x8
    800004aa:	b9a60613          	addi	a2,a2,-1126 # 80008040 <digits>
    800004ae:	883a                	mv	a6,a4
    800004b0:	2705                	addiw	a4,a4,1
    800004b2:	02b577bb          	remuw	a5,a0,a1
    800004b6:	1782                	slli	a5,a5,0x20
    800004b8:	9381                	srli	a5,a5,0x20
    800004ba:	97b2                	add	a5,a5,a2
    800004bc:	0007c783          	lbu	a5,0(a5)
    800004c0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004c4:	0005079b          	sext.w	a5,a0
    800004c8:	02b5553b          	divuw	a0,a0,a1
    800004cc:	0685                	addi	a3,a3,1
    800004ce:	feb7f0e3          	bgeu	a5,a1,800004ae <printint+0x26>

  if(sign)
    800004d2:	00088b63          	beqz	a7,800004e8 <printint+0x60>
    buf[i++] = '-';
    800004d6:	fe040793          	addi	a5,s0,-32
    800004da:	973e                	add	a4,a4,a5
    800004dc:	02d00793          	li	a5,45
    800004e0:	fef70823          	sb	a5,-16(a4)
    800004e4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004e8:	02e05763          	blez	a4,80000516 <printint+0x8e>
    800004ec:	fd040793          	addi	a5,s0,-48
    800004f0:	00e784b3          	add	s1,a5,a4
    800004f4:	fff78913          	addi	s2,a5,-1
    800004f8:	993a                	add	s2,s2,a4
    800004fa:	377d                	addiw	a4,a4,-1
    800004fc:	1702                	slli	a4,a4,0x20
    800004fe:	9301                	srli	a4,a4,0x20
    80000500:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000504:	fff4c503          	lbu	a0,-1(s1)
    80000508:	00000097          	auipc	ra,0x0
    8000050c:	d60080e7          	jalr	-672(ra) # 80000268 <consputc>
  while(--i >= 0)
    80000510:	14fd                	addi	s1,s1,-1
    80000512:	ff2499e3          	bne	s1,s2,80000504 <printint+0x7c>
}
    80000516:	70a2                	ld	ra,40(sp)
    80000518:	7402                	ld	s0,32(sp)
    8000051a:	64e2                	ld	s1,24(sp)
    8000051c:	6942                	ld	s2,16(sp)
    8000051e:	6145                	addi	sp,sp,48
    80000520:	8082                	ret
    x = -xx;
    80000522:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000526:	4885                	li	a7,1
    x = -xx;
    80000528:	bf9d                	j	8000049e <printint+0x16>

000000008000052a <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000052a:	1101                	addi	sp,sp,-32
    8000052c:	ec06                	sd	ra,24(sp)
    8000052e:	e822                	sd	s0,16(sp)
    80000530:	e426                	sd	s1,8(sp)
    80000532:	1000                	addi	s0,sp,32
    80000534:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000536:	00011797          	auipc	a5,0x11
    8000053a:	d007a523          	sw	zero,-758(a5) # 80011240 <pr+0x18>
  printf("panic: ");
    8000053e:	00008517          	auipc	a0,0x8
    80000542:	ada50513          	addi	a0,a0,-1318 # 80008018 <etext+0x18>
    80000546:	00000097          	auipc	ra,0x0
    8000054a:	02e080e7          	jalr	46(ra) # 80000574 <printf>
  printf(s);
    8000054e:	8526                	mv	a0,s1
    80000550:	00000097          	auipc	ra,0x0
    80000554:	024080e7          	jalr	36(ra) # 80000574 <printf>
  printf("\n");
    80000558:	00008517          	auipc	a0,0x8
    8000055c:	b7050513          	addi	a0,a0,-1168 # 800080c8 <digits+0x88>
    80000560:	00000097          	auipc	ra,0x0
    80000564:	014080e7          	jalr	20(ra) # 80000574 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000568:	4785                	li	a5,1
    8000056a:	00009717          	auipc	a4,0x9
    8000056e:	a8f72b23          	sw	a5,-1386(a4) # 80009000 <panicked>
  for(;;)
    80000572:	a001                	j	80000572 <panic+0x48>

0000000080000574 <printf>:
{
    80000574:	7131                	addi	sp,sp,-192
    80000576:	fc86                	sd	ra,120(sp)
    80000578:	f8a2                	sd	s0,112(sp)
    8000057a:	f4a6                	sd	s1,104(sp)
    8000057c:	f0ca                	sd	s2,96(sp)
    8000057e:	ecce                	sd	s3,88(sp)
    80000580:	e8d2                	sd	s4,80(sp)
    80000582:	e4d6                	sd	s5,72(sp)
    80000584:	e0da                	sd	s6,64(sp)
    80000586:	fc5e                	sd	s7,56(sp)
    80000588:	f862                	sd	s8,48(sp)
    8000058a:	f466                	sd	s9,40(sp)
    8000058c:	f06a                	sd	s10,32(sp)
    8000058e:	ec6e                	sd	s11,24(sp)
    80000590:	0100                	addi	s0,sp,128
    80000592:	8a2a                	mv	s4,a0
    80000594:	e40c                	sd	a1,8(s0)
    80000596:	e810                	sd	a2,16(s0)
    80000598:	ec14                	sd	a3,24(s0)
    8000059a:	f018                	sd	a4,32(s0)
    8000059c:	f41c                	sd	a5,40(s0)
    8000059e:	03043823          	sd	a6,48(s0)
    800005a2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005a6:	00011d97          	auipc	s11,0x11
    800005aa:	c9adad83          	lw	s11,-870(s11) # 80011240 <pr+0x18>
  if(locking)
    800005ae:	020d9b63          	bnez	s11,800005e4 <printf+0x70>
  if (fmt == 0)
    800005b2:	040a0263          	beqz	s4,800005f6 <printf+0x82>
  va_start(ap, fmt);
    800005b6:	00840793          	addi	a5,s0,8
    800005ba:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005be:	000a4503          	lbu	a0,0(s4)
    800005c2:	14050f63          	beqz	a0,80000720 <printf+0x1ac>
    800005c6:	4981                	li	s3,0
    if(c != '%'){
    800005c8:	02500a93          	li	s5,37
    switch(c){
    800005cc:	07000b93          	li	s7,112
  consputc('x');
    800005d0:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005d2:	00008b17          	auipc	s6,0x8
    800005d6:	a6eb0b13          	addi	s6,s6,-1426 # 80008040 <digits>
    switch(c){
    800005da:	07300c93          	li	s9,115
    800005de:	06400c13          	li	s8,100
    800005e2:	a82d                	j	8000061c <printf+0xa8>
    acquire(&pr.lock);
    800005e4:	00011517          	auipc	a0,0x11
    800005e8:	c4450513          	addi	a0,a0,-956 # 80011228 <pr>
    800005ec:	00000097          	auipc	ra,0x0
    800005f0:	5d6080e7          	jalr	1494(ra) # 80000bc2 <acquire>
    800005f4:	bf7d                	j	800005b2 <printf+0x3e>
    panic("null fmt");
    800005f6:	00008517          	auipc	a0,0x8
    800005fa:	a3250513          	addi	a0,a0,-1486 # 80008028 <etext+0x28>
    800005fe:	00000097          	auipc	ra,0x0
    80000602:	f2c080e7          	jalr	-212(ra) # 8000052a <panic>
      consputc(c);
    80000606:	00000097          	auipc	ra,0x0
    8000060a:	c62080e7          	jalr	-926(ra) # 80000268 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000060e:	2985                	addiw	s3,s3,1
    80000610:	013a07b3          	add	a5,s4,s3
    80000614:	0007c503          	lbu	a0,0(a5)
    80000618:	10050463          	beqz	a0,80000720 <printf+0x1ac>
    if(c != '%'){
    8000061c:	ff5515e3          	bne	a0,s5,80000606 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000620:	2985                	addiw	s3,s3,1
    80000622:	013a07b3          	add	a5,s4,s3
    80000626:	0007c783          	lbu	a5,0(a5)
    8000062a:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000062e:	cbed                	beqz	a5,80000720 <printf+0x1ac>
    switch(c){
    80000630:	05778a63          	beq	a5,s7,80000684 <printf+0x110>
    80000634:	02fbf663          	bgeu	s7,a5,80000660 <printf+0xec>
    80000638:	09978863          	beq	a5,s9,800006c8 <printf+0x154>
    8000063c:	07800713          	li	a4,120
    80000640:	0ce79563          	bne	a5,a4,8000070a <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4605                	li	a2,1
    80000652:	85ea                	mv	a1,s10
    80000654:	4388                	lw	a0,0(a5)
    80000656:	00000097          	auipc	ra,0x0
    8000065a:	e32080e7          	jalr	-462(ra) # 80000488 <printint>
      break;
    8000065e:	bf45                	j	8000060e <printf+0x9a>
    switch(c){
    80000660:	09578f63          	beq	a5,s5,800006fe <printf+0x18a>
    80000664:	0b879363          	bne	a5,s8,8000070a <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000668:	f8843783          	ld	a5,-120(s0)
    8000066c:	00878713          	addi	a4,a5,8
    80000670:	f8e43423          	sd	a4,-120(s0)
    80000674:	4605                	li	a2,1
    80000676:	45a9                	li	a1,10
    80000678:	4388                	lw	a0,0(a5)
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	e0e080e7          	jalr	-498(ra) # 80000488 <printint>
      break;
    80000682:	b771                	j	8000060e <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000684:	f8843783          	ld	a5,-120(s0)
    80000688:	00878713          	addi	a4,a5,8
    8000068c:	f8e43423          	sd	a4,-120(s0)
    80000690:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80000694:	03000513          	li	a0,48
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	bd0080e7          	jalr	-1072(ra) # 80000268 <consputc>
  consputc('x');
    800006a0:	07800513          	li	a0,120
    800006a4:	00000097          	auipc	ra,0x0
    800006a8:	bc4080e7          	jalr	-1084(ra) # 80000268 <consputc>
    800006ac:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ae:	03c95793          	srli	a5,s2,0x3c
    800006b2:	97da                	add	a5,a5,s6
    800006b4:	0007c503          	lbu	a0,0(a5)
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	bb0080e7          	jalr	-1104(ra) # 80000268 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006c0:	0912                	slli	s2,s2,0x4
    800006c2:	34fd                	addiw	s1,s1,-1
    800006c4:	f4ed                	bnez	s1,800006ae <printf+0x13a>
    800006c6:	b7a1                	j	8000060e <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006c8:	f8843783          	ld	a5,-120(s0)
    800006cc:	00878713          	addi	a4,a5,8
    800006d0:	f8e43423          	sd	a4,-120(s0)
    800006d4:	6384                	ld	s1,0(a5)
    800006d6:	cc89                	beqz	s1,800006f0 <printf+0x17c>
      for(; *s; s++)
    800006d8:	0004c503          	lbu	a0,0(s1)
    800006dc:	d90d                	beqz	a0,8000060e <printf+0x9a>
        consputc(*s);
    800006de:	00000097          	auipc	ra,0x0
    800006e2:	b8a080e7          	jalr	-1142(ra) # 80000268 <consputc>
      for(; *s; s++)
    800006e6:	0485                	addi	s1,s1,1
    800006e8:	0004c503          	lbu	a0,0(s1)
    800006ec:	f96d                	bnez	a0,800006de <printf+0x16a>
    800006ee:	b705                	j	8000060e <printf+0x9a>
        s = "(null)";
    800006f0:	00008497          	auipc	s1,0x8
    800006f4:	93048493          	addi	s1,s1,-1744 # 80008020 <etext+0x20>
      for(; *s; s++)
    800006f8:	02800513          	li	a0,40
    800006fc:	b7cd                	j	800006de <printf+0x16a>
      consputc('%');
    800006fe:	8556                	mv	a0,s5
    80000700:	00000097          	auipc	ra,0x0
    80000704:	b68080e7          	jalr	-1176(ra) # 80000268 <consputc>
      break;
    80000708:	b719                	j	8000060e <printf+0x9a>
      consputc('%');
    8000070a:	8556                	mv	a0,s5
    8000070c:	00000097          	auipc	ra,0x0
    80000710:	b5c080e7          	jalr	-1188(ra) # 80000268 <consputc>
      consputc(c);
    80000714:	8526                	mv	a0,s1
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	b52080e7          	jalr	-1198(ra) # 80000268 <consputc>
      break;
    8000071e:	bdc5                	j	8000060e <printf+0x9a>
  if(locking)
    80000720:	020d9163          	bnez	s11,80000742 <printf+0x1ce>
}
    80000724:	70e6                	ld	ra,120(sp)
    80000726:	7446                	ld	s0,112(sp)
    80000728:	74a6                	ld	s1,104(sp)
    8000072a:	7906                	ld	s2,96(sp)
    8000072c:	69e6                	ld	s3,88(sp)
    8000072e:	6a46                	ld	s4,80(sp)
    80000730:	6aa6                	ld	s5,72(sp)
    80000732:	6b06                	ld	s6,64(sp)
    80000734:	7be2                	ld	s7,56(sp)
    80000736:	7c42                	ld	s8,48(sp)
    80000738:	7ca2                	ld	s9,40(sp)
    8000073a:	7d02                	ld	s10,32(sp)
    8000073c:	6de2                	ld	s11,24(sp)
    8000073e:	6129                	addi	sp,sp,192
    80000740:	8082                	ret
    release(&pr.lock);
    80000742:	00011517          	auipc	a0,0x11
    80000746:	ae650513          	addi	a0,a0,-1306 # 80011228 <pr>
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	52c080e7          	jalr	1324(ra) # 80000c76 <release>
}
    80000752:	bfc9                	j	80000724 <printf+0x1b0>

0000000080000754 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000754:	1101                	addi	sp,sp,-32
    80000756:	ec06                	sd	ra,24(sp)
    80000758:	e822                	sd	s0,16(sp)
    8000075a:	e426                	sd	s1,8(sp)
    8000075c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000075e:	00011497          	auipc	s1,0x11
    80000762:	aca48493          	addi	s1,s1,-1334 # 80011228 <pr>
    80000766:	00008597          	auipc	a1,0x8
    8000076a:	8d258593          	addi	a1,a1,-1838 # 80008038 <etext+0x38>
    8000076e:	8526                	mv	a0,s1
    80000770:	00000097          	auipc	ra,0x0
    80000774:	3c2080e7          	jalr	962(ra) # 80000b32 <initlock>
  pr.locking = 1;
    80000778:	4785                	li	a5,1
    8000077a:	cc9c                	sw	a5,24(s1)
}
    8000077c:	60e2                	ld	ra,24(sp)
    8000077e:	6442                	ld	s0,16(sp)
    80000780:	64a2                	ld	s1,8(sp)
    80000782:	6105                	addi	sp,sp,32
    80000784:	8082                	ret

0000000080000786 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000786:	1141                	addi	sp,sp,-16
    80000788:	e406                	sd	ra,8(sp)
    8000078a:	e022                	sd	s0,0(sp)
    8000078c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000078e:	100007b7          	lui	a5,0x10000
    80000792:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000796:	f8000713          	li	a4,-128
    8000079a:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000079e:	470d                	li	a4,3
    800007a0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007a4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007a8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007ac:	469d                	li	a3,7
    800007ae:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007b2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007b6:	00008597          	auipc	a1,0x8
    800007ba:	8a258593          	addi	a1,a1,-1886 # 80008058 <digits+0x18>
    800007be:	00011517          	auipc	a0,0x11
    800007c2:	a8a50513          	addi	a0,a0,-1398 # 80011248 <uart_tx_lock>
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	36c080e7          	jalr	876(ra) # 80000b32 <initlock>
}
    800007ce:	60a2                	ld	ra,8(sp)
    800007d0:	6402                	ld	s0,0(sp)
    800007d2:	0141                	addi	sp,sp,16
    800007d4:	8082                	ret

00000000800007d6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007d6:	1101                	addi	sp,sp,-32
    800007d8:	ec06                	sd	ra,24(sp)
    800007da:	e822                	sd	s0,16(sp)
    800007dc:	e426                	sd	s1,8(sp)
    800007de:	1000                	addi	s0,sp,32
    800007e0:	84aa                	mv	s1,a0
  push_off();
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	394080e7          	jalr	916(ra) # 80000b76 <push_off>

  if(panicked){
    800007ea:	00009797          	auipc	a5,0x9
    800007ee:	8167a783          	lw	a5,-2026(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007f2:	10000737          	lui	a4,0x10000
  if(panicked){
    800007f6:	c391                	beqz	a5,800007fa <uartputc_sync+0x24>
    for(;;)
    800007f8:	a001                	j	800007f8 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007fa:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800007fe:	0207f793          	andi	a5,a5,32
    80000802:	dfe5                	beqz	a5,800007fa <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000804:	0ff4f513          	andi	a0,s1,255
    80000808:	100007b7          	lui	a5,0x10000
    8000080c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000810:	00000097          	auipc	ra,0x0
    80000814:	406080e7          	jalr	1030(ra) # 80000c16 <pop_off>
}
    80000818:	60e2                	ld	ra,24(sp)
    8000081a:	6442                	ld	s0,16(sp)
    8000081c:	64a2                	ld	s1,8(sp)
    8000081e:	6105                	addi	sp,sp,32
    80000820:	8082                	ret

0000000080000822 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000822:	00008797          	auipc	a5,0x8
    80000826:	7e67b783          	ld	a5,2022(a5) # 80009008 <uart_tx_r>
    8000082a:	00008717          	auipc	a4,0x8
    8000082e:	7e673703          	ld	a4,2022(a4) # 80009010 <uart_tx_w>
    80000832:	06f70a63          	beq	a4,a5,800008a6 <uartstart+0x84>
{
    80000836:	7139                	addi	sp,sp,-64
    80000838:	fc06                	sd	ra,56(sp)
    8000083a:	f822                	sd	s0,48(sp)
    8000083c:	f426                	sd	s1,40(sp)
    8000083e:	f04a                	sd	s2,32(sp)
    80000840:	ec4e                	sd	s3,24(sp)
    80000842:	e852                	sd	s4,16(sp)
    80000844:	e456                	sd	s5,8(sp)
    80000846:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000848:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000084c:	00011a17          	auipc	s4,0x11
    80000850:	9fca0a13          	addi	s4,s4,-1540 # 80011248 <uart_tx_lock>
    uart_tx_r += 1;
    80000854:	00008497          	auipc	s1,0x8
    80000858:	7b448493          	addi	s1,s1,1972 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000085c:	00008997          	auipc	s3,0x8
    80000860:	7b498993          	addi	s3,s3,1972 # 80009010 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000864:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000868:	02077713          	andi	a4,a4,32
    8000086c:	c705                	beqz	a4,80000894 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000086e:	01f7f713          	andi	a4,a5,31
    80000872:	9752                	add	a4,a4,s4
    80000874:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80000878:	0785                	addi	a5,a5,1
    8000087a:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000087c:	8526                	mv	a0,s1
    8000087e:	00002097          	auipc	ra,0x2
    80000882:	9f0080e7          	jalr	-1552(ra) # 8000226e <wakeup>
    
    WriteReg(THR, c);
    80000886:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000088a:	609c                	ld	a5,0(s1)
    8000088c:	0009b703          	ld	a4,0(s3)
    80000890:	fcf71ae3          	bne	a4,a5,80000864 <uartstart+0x42>
  }
}
    80000894:	70e2                	ld	ra,56(sp)
    80000896:	7442                	ld	s0,48(sp)
    80000898:	74a2                	ld	s1,40(sp)
    8000089a:	7902                	ld	s2,32(sp)
    8000089c:	69e2                	ld	s3,24(sp)
    8000089e:	6a42                	ld	s4,16(sp)
    800008a0:	6aa2                	ld	s5,8(sp)
    800008a2:	6121                	addi	sp,sp,64
    800008a4:	8082                	ret
    800008a6:	8082                	ret

00000000800008a8 <uartputc>:
{
    800008a8:	7179                	addi	sp,sp,-48
    800008aa:	f406                	sd	ra,40(sp)
    800008ac:	f022                	sd	s0,32(sp)
    800008ae:	ec26                	sd	s1,24(sp)
    800008b0:	e84a                	sd	s2,16(sp)
    800008b2:	e44e                	sd	s3,8(sp)
    800008b4:	e052                	sd	s4,0(sp)
    800008b6:	1800                	addi	s0,sp,48
    800008b8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ba:	00011517          	auipc	a0,0x11
    800008be:	98e50513          	addi	a0,a0,-1650 # 80011248 <uart_tx_lock>
    800008c2:	00000097          	auipc	ra,0x0
    800008c6:	300080e7          	jalr	768(ra) # 80000bc2 <acquire>
  if(panicked){
    800008ca:	00008797          	auipc	a5,0x8
    800008ce:	7367a783          	lw	a5,1846(a5) # 80009000 <panicked>
    800008d2:	c391                	beqz	a5,800008d6 <uartputc+0x2e>
    for(;;)
    800008d4:	a001                	j	800008d4 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008d6:	00008717          	auipc	a4,0x8
    800008da:	73a73703          	ld	a4,1850(a4) # 80009010 <uart_tx_w>
    800008de:	00008797          	auipc	a5,0x8
    800008e2:	72a7b783          	ld	a5,1834(a5) # 80009008 <uart_tx_r>
    800008e6:	02078793          	addi	a5,a5,32
    800008ea:	02e79b63          	bne	a5,a4,80000920 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800008ee:	00011997          	auipc	s3,0x11
    800008f2:	95a98993          	addi	s3,s3,-1702 # 80011248 <uart_tx_lock>
    800008f6:	00008497          	auipc	s1,0x8
    800008fa:	71248493          	addi	s1,s1,1810 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008fe:	00008917          	auipc	s2,0x8
    80000902:	71290913          	addi	s2,s2,1810 # 80009010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000906:	85ce                	mv	a1,s3
    80000908:	8526                	mv	a0,s1
    8000090a:	00001097          	auipc	ra,0x1
    8000090e:	7d8080e7          	jalr	2008(ra) # 800020e2 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000912:	00093703          	ld	a4,0(s2)
    80000916:	609c                	ld	a5,0(s1)
    80000918:	02078793          	addi	a5,a5,32
    8000091c:	fee785e3          	beq	a5,a4,80000906 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000920:	00011497          	auipc	s1,0x11
    80000924:	92848493          	addi	s1,s1,-1752 # 80011248 <uart_tx_lock>
    80000928:	01f77793          	andi	a5,a4,31
    8000092c:	97a6                	add	a5,a5,s1
    8000092e:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80000932:	0705                	addi	a4,a4,1
    80000934:	00008797          	auipc	a5,0x8
    80000938:	6ce7be23          	sd	a4,1756(a5) # 80009010 <uart_tx_w>
      uartstart();
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	ee6080e7          	jalr	-282(ra) # 80000822 <uartstart>
      release(&uart_tx_lock);
    80000944:	8526                	mv	a0,s1
    80000946:	00000097          	auipc	ra,0x0
    8000094a:	330080e7          	jalr	816(ra) # 80000c76 <release>
}
    8000094e:	70a2                	ld	ra,40(sp)
    80000950:	7402                	ld	s0,32(sp)
    80000952:	64e2                	ld	s1,24(sp)
    80000954:	6942                	ld	s2,16(sp)
    80000956:	69a2                	ld	s3,8(sp)
    80000958:	6a02                	ld	s4,0(sp)
    8000095a:	6145                	addi	sp,sp,48
    8000095c:	8082                	ret

000000008000095e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000095e:	1141                	addi	sp,sp,-16
    80000960:	e422                	sd	s0,8(sp)
    80000962:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000964:	100007b7          	lui	a5,0x10000
    80000968:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000096c:	8b85                	andi	a5,a5,1
    8000096e:	cb91                	beqz	a5,80000982 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000970:	100007b7          	lui	a5,0x10000
    80000974:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000978:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000097c:	6422                	ld	s0,8(sp)
    8000097e:	0141                	addi	sp,sp,16
    80000980:	8082                	ret
    return -1;
    80000982:	557d                	li	a0,-1
    80000984:	bfe5                	j	8000097c <uartgetc+0x1e>

0000000080000986 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80000986:	1101                	addi	sp,sp,-32
    80000988:	ec06                	sd	ra,24(sp)
    8000098a:	e822                	sd	s0,16(sp)
    8000098c:	e426                	sd	s1,8(sp)
    8000098e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000990:	54fd                	li	s1,-1
    80000992:	a029                	j	8000099c <uartintr+0x16>
      break;
    consoleintr(c);
    80000994:	00000097          	auipc	ra,0x0
    80000998:	916080e7          	jalr	-1770(ra) # 800002aa <consoleintr>
    int c = uartgetc();
    8000099c:	00000097          	auipc	ra,0x0
    800009a0:	fc2080e7          	jalr	-62(ra) # 8000095e <uartgetc>
    if(c == -1)
    800009a4:	fe9518e3          	bne	a0,s1,80000994 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009a8:	00011497          	auipc	s1,0x11
    800009ac:	8a048493          	addi	s1,s1,-1888 # 80011248 <uart_tx_lock>
    800009b0:	8526                	mv	a0,s1
    800009b2:	00000097          	auipc	ra,0x0
    800009b6:	210080e7          	jalr	528(ra) # 80000bc2 <acquire>
  uartstart();
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	e68080e7          	jalr	-408(ra) # 80000822 <uartstart>
  release(&uart_tx_lock);
    800009c2:	8526                	mv	a0,s1
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	2b2080e7          	jalr	690(ra) # 80000c76 <release>
}
    800009cc:	60e2                	ld	ra,24(sp)
    800009ce:	6442                	ld	s0,16(sp)
    800009d0:	64a2                	ld	s1,8(sp)
    800009d2:	6105                	addi	sp,sp,32
    800009d4:	8082                	ret

00000000800009d6 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	e04a                	sd	s2,0(sp)
    800009e0:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009e2:	03451793          	slli	a5,a0,0x34
    800009e6:	ebb9                	bnez	a5,80000a3c <kfree+0x66>
    800009e8:	84aa                	mv	s1,a0
    800009ea:	00030797          	auipc	a5,0x30
    800009ee:	61678793          	addi	a5,a5,1558 # 80031000 <end>
    800009f2:	04f56563          	bltu	a0,a5,80000a3c <kfree+0x66>
    800009f6:	47c5                	li	a5,17
    800009f8:	07ee                	slli	a5,a5,0x1b
    800009fa:	04f57163          	bgeu	a0,a5,80000a3c <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800009fe:	6605                	lui	a2,0x1
    80000a00:	4585                	li	a1,1
    80000a02:	00000097          	auipc	ra,0x0
    80000a06:	2bc080e7          	jalr	700(ra) # 80000cbe <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a0a:	00011917          	auipc	s2,0x11
    80000a0e:	87690913          	addi	s2,s2,-1930 # 80011280 <kmem>
    80000a12:	854a                	mv	a0,s2
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	1ae080e7          	jalr	430(ra) # 80000bc2 <acquire>
  r->next = kmem.freelist;
    80000a1c:	01893783          	ld	a5,24(s2)
    80000a20:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a22:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a26:	854a                	mv	a0,s2
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	24e080e7          	jalr	590(ra) # 80000c76 <release>
}
    80000a30:	60e2                	ld	ra,24(sp)
    80000a32:	6442                	ld	s0,16(sp)
    80000a34:	64a2                	ld	s1,8(sp)
    80000a36:	6902                	ld	s2,0(sp)
    80000a38:	6105                	addi	sp,sp,32
    80000a3a:	8082                	ret
    panic("kfree");
    80000a3c:	00007517          	auipc	a0,0x7
    80000a40:	62450513          	addi	a0,a0,1572 # 80008060 <digits+0x20>
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	ae6080e7          	jalr	-1306(ra) # 8000052a <panic>

0000000080000a4c <freerange>:
{
    80000a4c:	7179                	addi	sp,sp,-48
    80000a4e:	f406                	sd	ra,40(sp)
    80000a50:	f022                	sd	s0,32(sp)
    80000a52:	ec26                	sd	s1,24(sp)
    80000a54:	e84a                	sd	s2,16(sp)
    80000a56:	e44e                	sd	s3,8(sp)
    80000a58:	e052                	sd	s4,0(sp)
    80000a5a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a5c:	6785                	lui	a5,0x1
    80000a5e:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a62:	94aa                	add	s1,s1,a0
    80000a64:	757d                	lui	a0,0xfffff
    80000a66:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a68:	94be                	add	s1,s1,a5
    80000a6a:	0095ee63          	bltu	a1,s1,80000a86 <freerange+0x3a>
    80000a6e:	892e                	mv	s2,a1
    kfree(p);
    80000a70:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a72:	6985                	lui	s3,0x1
    kfree(p);
    80000a74:	01448533          	add	a0,s1,s4
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	f5e080e7          	jalr	-162(ra) # 800009d6 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a80:	94ce                	add	s1,s1,s3
    80000a82:	fe9979e3          	bgeu	s2,s1,80000a74 <freerange+0x28>
}
    80000a86:	70a2                	ld	ra,40(sp)
    80000a88:	7402                	ld	s0,32(sp)
    80000a8a:	64e2                	ld	s1,24(sp)
    80000a8c:	6942                	ld	s2,16(sp)
    80000a8e:	69a2                	ld	s3,8(sp)
    80000a90:	6a02                	ld	s4,0(sp)
    80000a92:	6145                	addi	sp,sp,48
    80000a94:	8082                	ret

0000000080000a96 <kinit>:
{
    80000a96:	1141                	addi	sp,sp,-16
    80000a98:	e406                	sd	ra,8(sp)
    80000a9a:	e022                	sd	s0,0(sp)
    80000a9c:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000a9e:	00007597          	auipc	a1,0x7
    80000aa2:	5ca58593          	addi	a1,a1,1482 # 80008068 <digits+0x28>
    80000aa6:	00010517          	auipc	a0,0x10
    80000aaa:	7da50513          	addi	a0,a0,2010 # 80011280 <kmem>
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	084080e7          	jalr	132(ra) # 80000b32 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab6:	45c5                	li	a1,17
    80000ab8:	05ee                	slli	a1,a1,0x1b
    80000aba:	00030517          	auipc	a0,0x30
    80000abe:	54650513          	addi	a0,a0,1350 # 80031000 <end>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	f8a080e7          	jalr	-118(ra) # 80000a4c <freerange>
}
    80000aca:	60a2                	ld	ra,8(sp)
    80000acc:	6402                	ld	s0,0(sp)
    80000ace:	0141                	addi	sp,sp,16
    80000ad0:	8082                	ret

0000000080000ad2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ad2:	1101                	addi	sp,sp,-32
    80000ad4:	ec06                	sd	ra,24(sp)
    80000ad6:	e822                	sd	s0,16(sp)
    80000ad8:	e426                	sd	s1,8(sp)
    80000ada:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000adc:	00010497          	auipc	s1,0x10
    80000ae0:	7a448493          	addi	s1,s1,1956 # 80011280 <kmem>
    80000ae4:	8526                	mv	a0,s1
    80000ae6:	00000097          	auipc	ra,0x0
    80000aea:	0dc080e7          	jalr	220(ra) # 80000bc2 <acquire>
  r = kmem.freelist;
    80000aee:	6c84                	ld	s1,24(s1)
  if(r)
    80000af0:	c885                	beqz	s1,80000b20 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000af2:	609c                	ld	a5,0(s1)
    80000af4:	00010517          	auipc	a0,0x10
    80000af8:	78c50513          	addi	a0,a0,1932 # 80011280 <kmem>
    80000afc:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	178080e7          	jalr	376(ra) # 80000c76 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b06:	6605                	lui	a2,0x1
    80000b08:	4595                	li	a1,5
    80000b0a:	8526                	mv	a0,s1
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	1b2080e7          	jalr	434(ra) # 80000cbe <memset>
  return (void*)r;
}
    80000b14:	8526                	mv	a0,s1
    80000b16:	60e2                	ld	ra,24(sp)
    80000b18:	6442                	ld	s0,16(sp)
    80000b1a:	64a2                	ld	s1,8(sp)
    80000b1c:	6105                	addi	sp,sp,32
    80000b1e:	8082                	ret
  release(&kmem.lock);
    80000b20:	00010517          	auipc	a0,0x10
    80000b24:	76050513          	addi	a0,a0,1888 # 80011280 <kmem>
    80000b28:	00000097          	auipc	ra,0x0
    80000b2c:	14e080e7          	jalr	334(ra) # 80000c76 <release>
  if(r)
    80000b30:	b7d5                	j	80000b14 <kalloc+0x42>

0000000080000b32 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b32:	1141                	addi	sp,sp,-16
    80000b34:	e422                	sd	s0,8(sp)
    80000b36:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b38:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b3a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b3e:	00053823          	sd	zero,16(a0)
}
    80000b42:	6422                	ld	s0,8(sp)
    80000b44:	0141                	addi	sp,sp,16
    80000b46:	8082                	ret

0000000080000b48 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b48:	411c                	lw	a5,0(a0)
    80000b4a:	e399                	bnez	a5,80000b50 <holding+0x8>
    80000b4c:	4501                	li	a0,0
  return r;
}
    80000b4e:	8082                	ret
{
    80000b50:	1101                	addi	sp,sp,-32
    80000b52:	ec06                	sd	ra,24(sp)
    80000b54:	e822                	sd	s0,16(sp)
    80000b56:	e426                	sd	s1,8(sp)
    80000b58:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b5a:	6904                	ld	s1,16(a0)
    80000b5c:	00001097          	auipc	ra,0x1
    80000b60:	e06080e7          	jalr	-506(ra) # 80001962 <mycpu>
    80000b64:	40a48533          	sub	a0,s1,a0
    80000b68:	00153513          	seqz	a0,a0
}
    80000b6c:	60e2                	ld	ra,24(sp)
    80000b6e:	6442                	ld	s0,16(sp)
    80000b70:	64a2                	ld	s1,8(sp)
    80000b72:	6105                	addi	sp,sp,32
    80000b74:	8082                	ret

0000000080000b76 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b76:	1101                	addi	sp,sp,-32
    80000b78:	ec06                	sd	ra,24(sp)
    80000b7a:	e822                	sd	s0,16(sp)
    80000b7c:	e426                	sd	s1,8(sp)
    80000b7e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b80:	100024f3          	csrr	s1,sstatus
    80000b84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b88:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b8a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b8e:	00001097          	auipc	ra,0x1
    80000b92:	dd4080e7          	jalr	-556(ra) # 80001962 <mycpu>
    80000b96:	5d3c                	lw	a5,120(a0)
    80000b98:	cf89                	beqz	a5,80000bb2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b9a:	00001097          	auipc	ra,0x1
    80000b9e:	dc8080e7          	jalr	-568(ra) # 80001962 <mycpu>
    80000ba2:	5d3c                	lw	a5,120(a0)
    80000ba4:	2785                	addiw	a5,a5,1
    80000ba6:	dd3c                	sw	a5,120(a0)
}
    80000ba8:	60e2                	ld	ra,24(sp)
    80000baa:	6442                	ld	s0,16(sp)
    80000bac:	64a2                	ld	s1,8(sp)
    80000bae:	6105                	addi	sp,sp,32
    80000bb0:	8082                	ret
    mycpu()->intena = old;
    80000bb2:	00001097          	auipc	ra,0x1
    80000bb6:	db0080e7          	jalr	-592(ra) # 80001962 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bba:	8085                	srli	s1,s1,0x1
    80000bbc:	8885                	andi	s1,s1,1
    80000bbe:	dd64                	sw	s1,124(a0)
    80000bc0:	bfe9                	j	80000b9a <push_off+0x24>

0000000080000bc2 <acquire>:
{
    80000bc2:	1101                	addi	sp,sp,-32
    80000bc4:	ec06                	sd	ra,24(sp)
    80000bc6:	e822                	sd	s0,16(sp)
    80000bc8:	e426                	sd	s1,8(sp)
    80000bca:	1000                	addi	s0,sp,32
    80000bcc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bce:	00000097          	auipc	ra,0x0
    80000bd2:	fa8080e7          	jalr	-88(ra) # 80000b76 <push_off>
  if(holding(lk))
    80000bd6:	8526                	mv	a0,s1
    80000bd8:	00000097          	auipc	ra,0x0
    80000bdc:	f70080e7          	jalr	-144(ra) # 80000b48 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be0:	4705                	li	a4,1
  if(holding(lk))
    80000be2:	e115                	bnez	a0,80000c06 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be4:	87ba                	mv	a5,a4
    80000be6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bea:	2781                	sext.w	a5,a5
    80000bec:	ffe5                	bnez	a5,80000be4 <acquire+0x22>
  __sync_synchronize();
    80000bee:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000bf2:	00001097          	auipc	ra,0x1
    80000bf6:	d70080e7          	jalr	-656(ra) # 80001962 <mycpu>
    80000bfa:	e888                	sd	a0,16(s1)
}
    80000bfc:	60e2                	ld	ra,24(sp)
    80000bfe:	6442                	ld	s0,16(sp)
    80000c00:	64a2                	ld	s1,8(sp)
    80000c02:	6105                	addi	sp,sp,32
    80000c04:	8082                	ret
    panic("acquire");
    80000c06:	00007517          	auipc	a0,0x7
    80000c0a:	46a50513          	addi	a0,a0,1130 # 80008070 <digits+0x30>
    80000c0e:	00000097          	auipc	ra,0x0
    80000c12:	91c080e7          	jalr	-1764(ra) # 8000052a <panic>

0000000080000c16 <pop_off>:

void
pop_off(void)
{
    80000c16:	1141                	addi	sp,sp,-16
    80000c18:	e406                	sd	ra,8(sp)
    80000c1a:	e022                	sd	s0,0(sp)
    80000c1c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c1e:	00001097          	auipc	ra,0x1
    80000c22:	d44080e7          	jalr	-700(ra) # 80001962 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c26:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c2a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c2c:	e78d                	bnez	a5,80000c56 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c2e:	5d3c                	lw	a5,120(a0)
    80000c30:	02f05b63          	blez	a5,80000c66 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c34:	37fd                	addiw	a5,a5,-1
    80000c36:	0007871b          	sext.w	a4,a5
    80000c3a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c3c:	eb09                	bnez	a4,80000c4e <pop_off+0x38>
    80000c3e:	5d7c                	lw	a5,124(a0)
    80000c40:	c799                	beqz	a5,80000c4e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c42:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c46:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c4a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c4e:	60a2                	ld	ra,8(sp)
    80000c50:	6402                	ld	s0,0(sp)
    80000c52:	0141                	addi	sp,sp,16
    80000c54:	8082                	ret
    panic("pop_off - interruptible");
    80000c56:	00007517          	auipc	a0,0x7
    80000c5a:	42250513          	addi	a0,a0,1058 # 80008078 <digits+0x38>
    80000c5e:	00000097          	auipc	ra,0x0
    80000c62:	8cc080e7          	jalr	-1844(ra) # 8000052a <panic>
    panic("pop_off");
    80000c66:	00007517          	auipc	a0,0x7
    80000c6a:	42a50513          	addi	a0,a0,1066 # 80008090 <digits+0x50>
    80000c6e:	00000097          	auipc	ra,0x0
    80000c72:	8bc080e7          	jalr	-1860(ra) # 8000052a <panic>

0000000080000c76 <release>:
{
    80000c76:	1101                	addi	sp,sp,-32
    80000c78:	ec06                	sd	ra,24(sp)
    80000c7a:	e822                	sd	s0,16(sp)
    80000c7c:	e426                	sd	s1,8(sp)
    80000c7e:	1000                	addi	s0,sp,32
    80000c80:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	ec6080e7          	jalr	-314(ra) # 80000b48 <holding>
    80000c8a:	c115                	beqz	a0,80000cae <release+0x38>
  lk->cpu = 0;
    80000c8c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c90:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000c94:	0f50000f          	fence	iorw,ow
    80000c98:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000c9c:	00000097          	auipc	ra,0x0
    80000ca0:	f7a080e7          	jalr	-134(ra) # 80000c16 <pop_off>
}
    80000ca4:	60e2                	ld	ra,24(sp)
    80000ca6:	6442                	ld	s0,16(sp)
    80000ca8:	64a2                	ld	s1,8(sp)
    80000caa:	6105                	addi	sp,sp,32
    80000cac:	8082                	ret
    panic("release");
    80000cae:	00007517          	auipc	a0,0x7
    80000cb2:	3ea50513          	addi	a0,a0,1002 # 80008098 <digits+0x58>
    80000cb6:	00000097          	auipc	ra,0x0
    80000cba:	874080e7          	jalr	-1932(ra) # 8000052a <panic>

0000000080000cbe <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cbe:	1141                	addi	sp,sp,-16
    80000cc0:	e422                	sd	s0,8(sp)
    80000cc2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cc4:	ca19                	beqz	a2,80000cda <memset+0x1c>
    80000cc6:	87aa                	mv	a5,a0
    80000cc8:	1602                	slli	a2,a2,0x20
    80000cca:	9201                	srli	a2,a2,0x20
    80000ccc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cd0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cd4:	0785                	addi	a5,a5,1
    80000cd6:	fee79de3          	bne	a5,a4,80000cd0 <memset+0x12>
  }
  return dst;
}
    80000cda:	6422                	ld	s0,8(sp)
    80000cdc:	0141                	addi	sp,sp,16
    80000cde:	8082                	ret

0000000080000ce0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000ce0:	1141                	addi	sp,sp,-16
    80000ce2:	e422                	sd	s0,8(sp)
    80000ce4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000ce6:	ca05                	beqz	a2,80000d16 <memcmp+0x36>
    80000ce8:	fff6069b          	addiw	a3,a2,-1
    80000cec:	1682                	slli	a3,a3,0x20
    80000cee:	9281                	srli	a3,a3,0x20
    80000cf0:	0685                	addi	a3,a3,1
    80000cf2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cf4:	00054783          	lbu	a5,0(a0)
    80000cf8:	0005c703          	lbu	a4,0(a1)
    80000cfc:	00e79863          	bne	a5,a4,80000d0c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d00:	0505                	addi	a0,a0,1
    80000d02:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d04:	fed518e3          	bne	a0,a3,80000cf4 <memcmp+0x14>
  }

  return 0;
    80000d08:	4501                	li	a0,0
    80000d0a:	a019                	j	80000d10 <memcmp+0x30>
      return *s1 - *s2;
    80000d0c:	40e7853b          	subw	a0,a5,a4
}
    80000d10:	6422                	ld	s0,8(sp)
    80000d12:	0141                	addi	sp,sp,16
    80000d14:	8082                	ret
  return 0;
    80000d16:	4501                	li	a0,0
    80000d18:	bfe5                	j	80000d10 <memcmp+0x30>

0000000080000d1a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d1a:	1141                	addi	sp,sp,-16
    80000d1c:	e422                	sd	s0,8(sp)
    80000d1e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d20:	02a5e563          	bltu	a1,a0,80000d4a <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d24:	fff6069b          	addiw	a3,a2,-1
    80000d28:	ce11                	beqz	a2,80000d44 <memmove+0x2a>
    80000d2a:	1682                	slli	a3,a3,0x20
    80000d2c:	9281                	srli	a3,a3,0x20
    80000d2e:	0685                	addi	a3,a3,1
    80000d30:	96ae                	add	a3,a3,a1
    80000d32:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d34:	0585                	addi	a1,a1,1
    80000d36:	0785                	addi	a5,a5,1
    80000d38:	fff5c703          	lbu	a4,-1(a1)
    80000d3c:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d40:	fed59ae3          	bne	a1,a3,80000d34 <memmove+0x1a>

  return dst;
}
    80000d44:	6422                	ld	s0,8(sp)
    80000d46:	0141                	addi	sp,sp,16
    80000d48:	8082                	ret
  if(s < d && s + n > d){
    80000d4a:	02061713          	slli	a4,a2,0x20
    80000d4e:	9301                	srli	a4,a4,0x20
    80000d50:	00e587b3          	add	a5,a1,a4
    80000d54:	fcf578e3          	bgeu	a0,a5,80000d24 <memmove+0xa>
    d += n;
    80000d58:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000d5a:	fff6069b          	addiw	a3,a2,-1
    80000d5e:	d27d                	beqz	a2,80000d44 <memmove+0x2a>
    80000d60:	02069613          	slli	a2,a3,0x20
    80000d64:	9201                	srli	a2,a2,0x20
    80000d66:	fff64613          	not	a2,a2
    80000d6a:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000d6c:	17fd                	addi	a5,a5,-1
    80000d6e:	177d                	addi	a4,a4,-1
    80000d70:	0007c683          	lbu	a3,0(a5)
    80000d74:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000d78:	fef61ae3          	bne	a2,a5,80000d6c <memmove+0x52>
    80000d7c:	b7e1                	j	80000d44 <memmove+0x2a>

0000000080000d7e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d7e:	1141                	addi	sp,sp,-16
    80000d80:	e406                	sd	ra,8(sp)
    80000d82:	e022                	sd	s0,0(sp)
    80000d84:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d86:	00000097          	auipc	ra,0x0
    80000d8a:	f94080e7          	jalr	-108(ra) # 80000d1a <memmove>
}
    80000d8e:	60a2                	ld	ra,8(sp)
    80000d90:	6402                	ld	s0,0(sp)
    80000d92:	0141                	addi	sp,sp,16
    80000d94:	8082                	ret

0000000080000d96 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d96:	1141                	addi	sp,sp,-16
    80000d98:	e422                	sd	s0,8(sp)
    80000d9a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d9c:	ce11                	beqz	a2,80000db8 <strncmp+0x22>
    80000d9e:	00054783          	lbu	a5,0(a0)
    80000da2:	cf89                	beqz	a5,80000dbc <strncmp+0x26>
    80000da4:	0005c703          	lbu	a4,0(a1)
    80000da8:	00f71a63          	bne	a4,a5,80000dbc <strncmp+0x26>
    n--, p++, q++;
    80000dac:	367d                	addiw	a2,a2,-1
    80000dae:	0505                	addi	a0,a0,1
    80000db0:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db2:	f675                	bnez	a2,80000d9e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db4:	4501                	li	a0,0
    80000db6:	a809                	j	80000dc8 <strncmp+0x32>
    80000db8:	4501                	li	a0,0
    80000dba:	a039                	j	80000dc8 <strncmp+0x32>
  if(n == 0)
    80000dbc:	ca09                	beqz	a2,80000dce <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dbe:	00054503          	lbu	a0,0(a0)
    80000dc2:	0005c783          	lbu	a5,0(a1)
    80000dc6:	9d1d                	subw	a0,a0,a5
}
    80000dc8:	6422                	ld	s0,8(sp)
    80000dca:	0141                	addi	sp,sp,16
    80000dcc:	8082                	ret
    return 0;
    80000dce:	4501                	li	a0,0
    80000dd0:	bfe5                	j	80000dc8 <strncmp+0x32>

0000000080000dd2 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dd2:	1141                	addi	sp,sp,-16
    80000dd4:	e422                	sd	s0,8(sp)
    80000dd6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dd8:	872a                	mv	a4,a0
    80000dda:	8832                	mv	a6,a2
    80000ddc:	367d                	addiw	a2,a2,-1
    80000dde:	01005963          	blez	a6,80000df0 <strncpy+0x1e>
    80000de2:	0705                	addi	a4,a4,1
    80000de4:	0005c783          	lbu	a5,0(a1)
    80000de8:	fef70fa3          	sb	a5,-1(a4)
    80000dec:	0585                	addi	a1,a1,1
    80000dee:	f7f5                	bnez	a5,80000dda <strncpy+0x8>
    ;
  while(n-- > 0)
    80000df0:	86ba                	mv	a3,a4
    80000df2:	00c05c63          	blez	a2,80000e0a <strncpy+0x38>
    *s++ = 0;
    80000df6:	0685                	addi	a3,a3,1
    80000df8:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000dfc:	fff6c793          	not	a5,a3
    80000e00:	9fb9                	addw	a5,a5,a4
    80000e02:	010787bb          	addw	a5,a5,a6
    80000e06:	fef048e3          	bgtz	a5,80000df6 <strncpy+0x24>
  return os;
}
    80000e0a:	6422                	ld	s0,8(sp)
    80000e0c:	0141                	addi	sp,sp,16
    80000e0e:	8082                	ret

0000000080000e10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e10:	1141                	addi	sp,sp,-16
    80000e12:	e422                	sd	s0,8(sp)
    80000e14:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e16:	02c05363          	blez	a2,80000e3c <safestrcpy+0x2c>
    80000e1a:	fff6069b          	addiw	a3,a2,-1
    80000e1e:	1682                	slli	a3,a3,0x20
    80000e20:	9281                	srli	a3,a3,0x20
    80000e22:	96ae                	add	a3,a3,a1
    80000e24:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e26:	00d58963          	beq	a1,a3,80000e38 <safestrcpy+0x28>
    80000e2a:	0585                	addi	a1,a1,1
    80000e2c:	0785                	addi	a5,a5,1
    80000e2e:	fff5c703          	lbu	a4,-1(a1)
    80000e32:	fee78fa3          	sb	a4,-1(a5)
    80000e36:	fb65                	bnez	a4,80000e26 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e38:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e3c:	6422                	ld	s0,8(sp)
    80000e3e:	0141                	addi	sp,sp,16
    80000e40:	8082                	ret

0000000080000e42 <strlen>:

int
strlen(const char *s)
{
    80000e42:	1141                	addi	sp,sp,-16
    80000e44:	e422                	sd	s0,8(sp)
    80000e46:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e48:	00054783          	lbu	a5,0(a0)
    80000e4c:	cf91                	beqz	a5,80000e68 <strlen+0x26>
    80000e4e:	0505                	addi	a0,a0,1
    80000e50:	87aa                	mv	a5,a0
    80000e52:	4685                	li	a3,1
    80000e54:	9e89                	subw	a3,a3,a0
    80000e56:	00f6853b          	addw	a0,a3,a5
    80000e5a:	0785                	addi	a5,a5,1
    80000e5c:	fff7c703          	lbu	a4,-1(a5)
    80000e60:	fb7d                	bnez	a4,80000e56 <strlen+0x14>
    ;
  return n;
}
    80000e62:	6422                	ld	s0,8(sp)
    80000e64:	0141                	addi	sp,sp,16
    80000e66:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e68:	4501                	li	a0,0
    80000e6a:	bfe5                	j	80000e62 <strlen+0x20>

0000000080000e6c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e6c:	1141                	addi	sp,sp,-16
    80000e6e:	e406                	sd	ra,8(sp)
    80000e70:	e022                	sd	s0,0(sp)
    80000e72:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e74:	00001097          	auipc	ra,0x1
    80000e78:	ade080e7          	jalr	-1314(ra) # 80001952 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e7c:	00008717          	auipc	a4,0x8
    80000e80:	19c70713          	addi	a4,a4,412 # 80009018 <started>
  if(cpuid() == 0){
    80000e84:	c139                	beqz	a0,80000eca <main+0x5e>
    while(started == 0)
    80000e86:	431c                	lw	a5,0(a4)
    80000e88:	2781                	sext.w	a5,a5
    80000e8a:	dff5                	beqz	a5,80000e86 <main+0x1a>
      ;
    __sync_synchronize();
    80000e8c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e90:	00001097          	auipc	ra,0x1
    80000e94:	ac2080e7          	jalr	-1342(ra) # 80001952 <cpuid>
    80000e98:	85aa                	mv	a1,a0
    80000e9a:	00007517          	auipc	a0,0x7
    80000e9e:	21e50513          	addi	a0,a0,542 # 800080b8 <digits+0x78>
    80000ea2:	fffff097          	auipc	ra,0xfffff
    80000ea6:	6d2080e7          	jalr	1746(ra) # 80000574 <printf>
    kvminithart();    // turn on paging
    80000eaa:	00000097          	auipc	ra,0x0
    80000eae:	0d8080e7          	jalr	216(ra) # 80000f82 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eb2:	00002097          	auipc	ra,0x2
    80000eb6:	b54080e7          	jalr	-1196(ra) # 80002a06 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eba:	00005097          	auipc	ra,0x5
    80000ebe:	1b6080e7          	jalr	438(ra) # 80006070 <plicinithart>
  }

  scheduler();        
    80000ec2:	00001097          	auipc	ra,0x1
    80000ec6:	06e080e7          	jalr	110(ra) # 80001f30 <scheduler>
    consoleinit();
    80000eca:	fffff097          	auipc	ra,0xfffff
    80000ece:	572080e7          	jalr	1394(ra) # 8000043c <consoleinit>
    printfinit();
    80000ed2:	00000097          	auipc	ra,0x0
    80000ed6:	882080e7          	jalr	-1918(ra) # 80000754 <printfinit>
    printf("\n");
    80000eda:	00007517          	auipc	a0,0x7
    80000ede:	1ee50513          	addi	a0,a0,494 # 800080c8 <digits+0x88>
    80000ee2:	fffff097          	auipc	ra,0xfffff
    80000ee6:	692080e7          	jalr	1682(ra) # 80000574 <printf>
    printf("xv6 kernel is booting\n");
    80000eea:	00007517          	auipc	a0,0x7
    80000eee:	1b650513          	addi	a0,a0,438 # 800080a0 <digits+0x60>
    80000ef2:	fffff097          	auipc	ra,0xfffff
    80000ef6:	682080e7          	jalr	1666(ra) # 80000574 <printf>
    printf("\n");
    80000efa:	00007517          	auipc	a0,0x7
    80000efe:	1ce50513          	addi	a0,a0,462 # 800080c8 <digits+0x88>
    80000f02:	fffff097          	auipc	ra,0xfffff
    80000f06:	672080e7          	jalr	1650(ra) # 80000574 <printf>
    kinit();         // physical page allocator
    80000f0a:	00000097          	auipc	ra,0x0
    80000f0e:	b8c080e7          	jalr	-1140(ra) # 80000a96 <kinit>
    kvminit();       // create kernel page table
    80000f12:	00000097          	auipc	ra,0x0
    80000f16:	310080e7          	jalr	784(ra) # 80001222 <kvminit>
    kvminithart();   // turn on paging
    80000f1a:	00000097          	auipc	ra,0x0
    80000f1e:	068080e7          	jalr	104(ra) # 80000f82 <kvminithart>
    procinit();      // process table
    80000f22:	00001097          	auipc	ra,0x1
    80000f26:	980080e7          	jalr	-1664(ra) # 800018a2 <procinit>
    trapinit();      // trap vectors
    80000f2a:	00002097          	auipc	ra,0x2
    80000f2e:	ab4080e7          	jalr	-1356(ra) # 800029de <trapinit>
    trapinithart();  // install kernel trap vector
    80000f32:	00002097          	auipc	ra,0x2
    80000f36:	ad4080e7          	jalr	-1324(ra) # 80002a06 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f3a:	00005097          	auipc	ra,0x5
    80000f3e:	120080e7          	jalr	288(ra) # 8000605a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f42:	00005097          	auipc	ra,0x5
    80000f46:	12e080e7          	jalr	302(ra) # 80006070 <plicinithart>
    binit();         // buffer cache
    80000f4a:	00002097          	auipc	ra,0x2
    80000f4e:	2d8080e7          	jalr	728(ra) # 80003222 <binit>
    iinit();         // inode cache
    80000f52:	00003097          	auipc	ra,0x3
    80000f56:	96a080e7          	jalr	-1686(ra) # 800038bc <iinit>
    fileinit();      // file table
    80000f5a:	00004097          	auipc	ra,0x4
    80000f5e:	918080e7          	jalr	-1768(ra) # 80004872 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f62:	00005097          	auipc	ra,0x5
    80000f66:	236080e7          	jalr	566(ra) # 80006198 <virtio_disk_init>
    userinit();      // first user process
    80000f6a:	00001097          	auipc	ra,0x1
    80000f6e:	d3a080e7          	jalr	-710(ra) # 80001ca4 <userinit>
    __sync_synchronize();
    80000f72:	0ff0000f          	fence
    started = 1;
    80000f76:	4785                	li	a5,1
    80000f78:	00008717          	auipc	a4,0x8
    80000f7c:	0af72023          	sw	a5,160(a4) # 80009018 <started>
    80000f80:	b789                	j	80000ec2 <main+0x56>

0000000080000f82 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f82:	1141                	addi	sp,sp,-16
    80000f84:	e422                	sd	s0,8(sp)
    80000f86:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000f88:	00008797          	auipc	a5,0x8
    80000f8c:	0987b783          	ld	a5,152(a5) # 80009020 <kernel_pagetable>
    80000f90:	83b1                	srli	a5,a5,0xc
    80000f92:	577d                	li	a4,-1
    80000f94:	177e                	slli	a4,a4,0x3f
    80000f96:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f98:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f9c:	12000073          	sfence.vma
  sfence_vma();
}
    80000fa0:	6422                	ld	s0,8(sp)
    80000fa2:	0141                	addi	sp,sp,16
    80000fa4:	8082                	ret

0000000080000fa6 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fa6:	7139                	addi	sp,sp,-64
    80000fa8:	fc06                	sd	ra,56(sp)
    80000faa:	f822                	sd	s0,48(sp)
    80000fac:	f426                	sd	s1,40(sp)
    80000fae:	f04a                	sd	s2,32(sp)
    80000fb0:	ec4e                	sd	s3,24(sp)
    80000fb2:	e852                	sd	s4,16(sp)
    80000fb4:	e456                	sd	s5,8(sp)
    80000fb6:	e05a                	sd	s6,0(sp)
    80000fb8:	0080                	addi	s0,sp,64
    80000fba:	84aa                	mv	s1,a0
    80000fbc:	89ae                	mv	s3,a1
    80000fbe:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fc0:	57fd                	li	a5,-1
    80000fc2:	83e9                	srli	a5,a5,0x1a
    80000fc4:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fc6:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fc8:	04b7f263          	bgeu	a5,a1,8000100c <walk+0x66>
    panic("walk");
    80000fcc:	00007517          	auipc	a0,0x7
    80000fd0:	10450513          	addi	a0,a0,260 # 800080d0 <digits+0x90>
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	556080e7          	jalr	1366(ra) # 8000052a <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fdc:	060a8663          	beqz	s5,80001048 <walk+0xa2>
    80000fe0:	00000097          	auipc	ra,0x0
    80000fe4:	af2080e7          	jalr	-1294(ra) # 80000ad2 <kalloc>
    80000fe8:	84aa                	mv	s1,a0
    80000fea:	c529                	beqz	a0,80001034 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000fec:	6605                	lui	a2,0x1
    80000fee:	4581                	li	a1,0
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	cce080e7          	jalr	-818(ra) # 80000cbe <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000ff8:	00c4d793          	srli	a5,s1,0xc
    80000ffc:	07aa                	slli	a5,a5,0xa
    80000ffe:	0017e793          	ori	a5,a5,1
    80001002:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001006:	3a5d                	addiw	s4,s4,-9
    80001008:	036a0063          	beq	s4,s6,80001028 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000100c:	0149d933          	srl	s2,s3,s4
    80001010:	1ff97913          	andi	s2,s2,511
    80001014:	090e                	slli	s2,s2,0x3
    80001016:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001018:	00093483          	ld	s1,0(s2)
    8000101c:	0014f793          	andi	a5,s1,1
    80001020:	dfd5                	beqz	a5,80000fdc <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001022:	80a9                	srli	s1,s1,0xa
    80001024:	04b2                	slli	s1,s1,0xc
    80001026:	b7c5                	j	80001006 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001028:	00c9d513          	srli	a0,s3,0xc
    8000102c:	1ff57513          	andi	a0,a0,511
    80001030:	050e                	slli	a0,a0,0x3
    80001032:	9526                	add	a0,a0,s1
}
    80001034:	70e2                	ld	ra,56(sp)
    80001036:	7442                	ld	s0,48(sp)
    80001038:	74a2                	ld	s1,40(sp)
    8000103a:	7902                	ld	s2,32(sp)
    8000103c:	69e2                	ld	s3,24(sp)
    8000103e:	6a42                	ld	s4,16(sp)
    80001040:	6aa2                	ld	s5,8(sp)
    80001042:	6b02                	ld	s6,0(sp)
    80001044:	6121                	addi	sp,sp,64
    80001046:	8082                	ret
        return 0;
    80001048:	4501                	li	a0,0
    8000104a:	b7ed                	j	80001034 <walk+0x8e>

000000008000104c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000104c:	57fd                	li	a5,-1
    8000104e:	83e9                	srli	a5,a5,0x1a
    80001050:	00b7f463          	bgeu	a5,a1,80001058 <walkaddr+0xc>
    return 0;
    80001054:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001056:	8082                	ret
{
    80001058:	1141                	addi	sp,sp,-16
    8000105a:	e406                	sd	ra,8(sp)
    8000105c:	e022                	sd	s0,0(sp)
    8000105e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001060:	4601                	li	a2,0
    80001062:	00000097          	auipc	ra,0x0
    80001066:	f44080e7          	jalr	-188(ra) # 80000fa6 <walk>
  if(pte == 0)
    8000106a:	c105                	beqz	a0,8000108a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000106c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000106e:	0117f693          	andi	a3,a5,17
    80001072:	4745                	li	a4,17
    return 0;
    80001074:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001076:	00e68663          	beq	a3,a4,80001082 <walkaddr+0x36>
}
    8000107a:	60a2                	ld	ra,8(sp)
    8000107c:	6402                	ld	s0,0(sp)
    8000107e:	0141                	addi	sp,sp,16
    80001080:	8082                	ret
  pa = PTE2PA(*pte);
    80001082:	00a7d513          	srli	a0,a5,0xa
    80001086:	0532                	slli	a0,a0,0xc
  return pa;
    80001088:	bfcd                	j	8000107a <walkaddr+0x2e>
    return 0;
    8000108a:	4501                	li	a0,0
    8000108c:	b7fd                	j	8000107a <walkaddr+0x2e>

000000008000108e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000108e:	715d                	addi	sp,sp,-80
    80001090:	e486                	sd	ra,72(sp)
    80001092:	e0a2                	sd	s0,64(sp)
    80001094:	fc26                	sd	s1,56(sp)
    80001096:	f84a                	sd	s2,48(sp)
    80001098:	f44e                	sd	s3,40(sp)
    8000109a:	f052                	sd	s4,32(sp)
    8000109c:	ec56                	sd	s5,24(sp)
    8000109e:	e85a                	sd	s6,16(sp)
    800010a0:	e45e                	sd	s7,8(sp)
    800010a2:	0880                	addi	s0,sp,80
    800010a4:	8aaa                	mv	s5,a0
    800010a6:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    800010a8:	777d                	lui	a4,0xfffff
    800010aa:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010ae:	167d                	addi	a2,a2,-1
    800010b0:	00b609b3          	add	s3,a2,a1
    800010b4:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010b8:	893e                	mv	s2,a5
    800010ba:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010be:	6b85                	lui	s7,0x1
    800010c0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010c4:	4605                	li	a2,1
    800010c6:	85ca                	mv	a1,s2
    800010c8:	8556                	mv	a0,s5
    800010ca:	00000097          	auipc	ra,0x0
    800010ce:	edc080e7          	jalr	-292(ra) # 80000fa6 <walk>
    800010d2:	c51d                	beqz	a0,80001100 <mappages+0x72>
    if(*pte & PTE_V)
    800010d4:	611c                	ld	a5,0(a0)
    800010d6:	8b85                	andi	a5,a5,1
    800010d8:	ef81                	bnez	a5,800010f0 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010da:	80b1                	srli	s1,s1,0xc
    800010dc:	04aa                	slli	s1,s1,0xa
    800010de:	0164e4b3          	or	s1,s1,s6
    800010e2:	0014e493          	ori	s1,s1,1
    800010e6:	e104                	sd	s1,0(a0)
    if(a == last)
    800010e8:	03390863          	beq	s2,s3,80001118 <mappages+0x8a>
    a += PGSIZE;
    800010ec:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010ee:	bfc9                	j	800010c0 <mappages+0x32>
      panic("remap");
    800010f0:	00007517          	auipc	a0,0x7
    800010f4:	fe850513          	addi	a0,a0,-24 # 800080d8 <digits+0x98>
    800010f8:	fffff097          	auipc	ra,0xfffff
    800010fc:	432080e7          	jalr	1074(ra) # 8000052a <panic>
      return -1;
    80001100:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001102:	60a6                	ld	ra,72(sp)
    80001104:	6406                	ld	s0,64(sp)
    80001106:	74e2                	ld	s1,56(sp)
    80001108:	7942                	ld	s2,48(sp)
    8000110a:	79a2                	ld	s3,40(sp)
    8000110c:	7a02                	ld	s4,32(sp)
    8000110e:	6ae2                	ld	s5,24(sp)
    80001110:	6b42                	ld	s6,16(sp)
    80001112:	6ba2                	ld	s7,8(sp)
    80001114:	6161                	addi	sp,sp,80
    80001116:	8082                	ret
  return 0;
    80001118:	4501                	li	a0,0
    8000111a:	b7e5                	j	80001102 <mappages+0x74>

000000008000111c <kvmmap>:
{
    8000111c:	1141                	addi	sp,sp,-16
    8000111e:	e406                	sd	ra,8(sp)
    80001120:	e022                	sd	s0,0(sp)
    80001122:	0800                	addi	s0,sp,16
    80001124:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001126:	86b2                	mv	a3,a2
    80001128:	863e                	mv	a2,a5
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f64080e7          	jalr	-156(ra) # 8000108e <mappages>
    80001132:	e509                	bnez	a0,8000113c <kvmmap+0x20>
}
    80001134:	60a2                	ld	ra,8(sp)
    80001136:	6402                	ld	s0,0(sp)
    80001138:	0141                	addi	sp,sp,16
    8000113a:	8082                	ret
    panic("kvmmap");
    8000113c:	00007517          	auipc	a0,0x7
    80001140:	fa450513          	addi	a0,a0,-92 # 800080e0 <digits+0xa0>
    80001144:	fffff097          	auipc	ra,0xfffff
    80001148:	3e6080e7          	jalr	998(ra) # 8000052a <panic>

000000008000114c <kvmmake>:
{
    8000114c:	1101                	addi	sp,sp,-32
    8000114e:	ec06                	sd	ra,24(sp)
    80001150:	e822                	sd	s0,16(sp)
    80001152:	e426                	sd	s1,8(sp)
    80001154:	e04a                	sd	s2,0(sp)
    80001156:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001158:	00000097          	auipc	ra,0x0
    8000115c:	97a080e7          	jalr	-1670(ra) # 80000ad2 <kalloc>
    80001160:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001162:	6605                	lui	a2,0x1
    80001164:	4581                	li	a1,0
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	b58080e7          	jalr	-1192(ra) # 80000cbe <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000116e:	4719                	li	a4,6
    80001170:	6685                	lui	a3,0x1
    80001172:	10000637          	lui	a2,0x10000
    80001176:	100005b7          	lui	a1,0x10000
    8000117a:	8526                	mv	a0,s1
    8000117c:	00000097          	auipc	ra,0x0
    80001180:	fa0080e7          	jalr	-96(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001184:	4719                	li	a4,6
    80001186:	6685                	lui	a3,0x1
    80001188:	10001637          	lui	a2,0x10001
    8000118c:	100015b7          	lui	a1,0x10001
    80001190:	8526                	mv	a0,s1
    80001192:	00000097          	auipc	ra,0x0
    80001196:	f8a080e7          	jalr	-118(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000119a:	4719                	li	a4,6
    8000119c:	004006b7          	lui	a3,0x400
    800011a0:	0c000637          	lui	a2,0xc000
    800011a4:	0c0005b7          	lui	a1,0xc000
    800011a8:	8526                	mv	a0,s1
    800011aa:	00000097          	auipc	ra,0x0
    800011ae:	f72080e7          	jalr	-142(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011b2:	00007917          	auipc	s2,0x7
    800011b6:	e4e90913          	addi	s2,s2,-434 # 80008000 <etext>
    800011ba:	4729                	li	a4,10
    800011bc:	80007697          	auipc	a3,0x80007
    800011c0:	e4468693          	addi	a3,a3,-444 # 8000 <_entry-0x7fff8000>
    800011c4:	4605                	li	a2,1
    800011c6:	067e                	slli	a2,a2,0x1f
    800011c8:	85b2                	mv	a1,a2
    800011ca:	8526                	mv	a0,s1
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	f50080e7          	jalr	-176(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011d4:	4719                	li	a4,6
    800011d6:	46c5                	li	a3,17
    800011d8:	06ee                	slli	a3,a3,0x1b
    800011da:	412686b3          	sub	a3,a3,s2
    800011de:	864a                	mv	a2,s2
    800011e0:	85ca                	mv	a1,s2
    800011e2:	8526                	mv	a0,s1
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	f38080e7          	jalr	-200(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011ec:	4729                	li	a4,10
    800011ee:	6685                	lui	a3,0x1
    800011f0:	00006617          	auipc	a2,0x6
    800011f4:	e1060613          	addi	a2,a2,-496 # 80007000 <_trampoline>
    800011f8:	040005b7          	lui	a1,0x4000
    800011fc:	15fd                	addi	a1,a1,-1
    800011fe:	05b2                	slli	a1,a1,0xc
    80001200:	8526                	mv	a0,s1
    80001202:	00000097          	auipc	ra,0x0
    80001206:	f1a080e7          	jalr	-230(ra) # 8000111c <kvmmap>
  proc_mapstacks(kpgtbl);
    8000120a:	8526                	mv	a0,s1
    8000120c:	00000097          	auipc	ra,0x0
    80001210:	600080e7          	jalr	1536(ra) # 8000180c <proc_mapstacks>
}
    80001214:	8526                	mv	a0,s1
    80001216:	60e2                	ld	ra,24(sp)
    80001218:	6442                	ld	s0,16(sp)
    8000121a:	64a2                	ld	s1,8(sp)
    8000121c:	6902                	ld	s2,0(sp)
    8000121e:	6105                	addi	sp,sp,32
    80001220:	8082                	ret

0000000080001222 <kvminit>:
{
    80001222:	1141                	addi	sp,sp,-16
    80001224:	e406                	sd	ra,8(sp)
    80001226:	e022                	sd	s0,0(sp)
    80001228:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000122a:	00000097          	auipc	ra,0x0
    8000122e:	f22080e7          	jalr	-222(ra) # 8000114c <kvmmake>
    80001232:	00008797          	auipc	a5,0x8
    80001236:	dea7b723          	sd	a0,-530(a5) # 80009020 <kernel_pagetable>
}
    8000123a:	60a2                	ld	ra,8(sp)
    8000123c:	6402                	ld	s0,0(sp)
    8000123e:	0141                	addi	sp,sp,16
    80001240:	8082                	ret

0000000080001242 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001242:	715d                	addi	sp,sp,-80
    80001244:	e486                	sd	ra,72(sp)
    80001246:	e0a2                	sd	s0,64(sp)
    80001248:	fc26                	sd	s1,56(sp)
    8000124a:	f84a                	sd	s2,48(sp)
    8000124c:	f44e                	sd	s3,40(sp)
    8000124e:	f052                	sd	s4,32(sp)
    80001250:	ec56                	sd	s5,24(sp)
    80001252:	e85a                	sd	s6,16(sp)
    80001254:	e45e                	sd	s7,8(sp)
    80001256:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001258:	03459793          	slli	a5,a1,0x34
    8000125c:	e795                	bnez	a5,80001288 <uvmunmap+0x46>
    8000125e:	8a2a                	mv	s4,a0
    80001260:	892e                	mv	s2,a1
    80001262:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001264:	0632                	slli	a2,a2,0xc
    80001266:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000126a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000126c:	6b05                	lui	s6,0x1
    8000126e:	0735e263          	bltu	a1,s3,800012d2 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001272:	60a6                	ld	ra,72(sp)
    80001274:	6406                	ld	s0,64(sp)
    80001276:	74e2                	ld	s1,56(sp)
    80001278:	7942                	ld	s2,48(sp)
    8000127a:	79a2                	ld	s3,40(sp)
    8000127c:	7a02                	ld	s4,32(sp)
    8000127e:	6ae2                	ld	s5,24(sp)
    80001280:	6b42                	ld	s6,16(sp)
    80001282:	6ba2                	ld	s7,8(sp)
    80001284:	6161                	addi	sp,sp,80
    80001286:	8082                	ret
    panic("uvmunmap: not aligned");
    80001288:	00007517          	auipc	a0,0x7
    8000128c:	e6050513          	addi	a0,a0,-416 # 800080e8 <digits+0xa8>
    80001290:	fffff097          	auipc	ra,0xfffff
    80001294:	29a080e7          	jalr	666(ra) # 8000052a <panic>
      panic("uvmunmap: walk");
    80001298:	00007517          	auipc	a0,0x7
    8000129c:	e6850513          	addi	a0,a0,-408 # 80008100 <digits+0xc0>
    800012a0:	fffff097          	auipc	ra,0xfffff
    800012a4:	28a080e7          	jalr	650(ra) # 8000052a <panic>
      panic("uvmunmap: not mapped");
    800012a8:	00007517          	auipc	a0,0x7
    800012ac:	e6850513          	addi	a0,a0,-408 # 80008110 <digits+0xd0>
    800012b0:	fffff097          	auipc	ra,0xfffff
    800012b4:	27a080e7          	jalr	634(ra) # 8000052a <panic>
      panic("uvmunmap: not a leaf");
    800012b8:	00007517          	auipc	a0,0x7
    800012bc:	e7050513          	addi	a0,a0,-400 # 80008128 <digits+0xe8>
    800012c0:	fffff097          	auipc	ra,0xfffff
    800012c4:	26a080e7          	jalr	618(ra) # 8000052a <panic>
    *pte = 0;
    800012c8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012cc:	995a                	add	s2,s2,s6
    800012ce:	fb3972e3          	bgeu	s2,s3,80001272 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012d2:	4601                	li	a2,0
    800012d4:	85ca                	mv	a1,s2
    800012d6:	8552                	mv	a0,s4
    800012d8:	00000097          	auipc	ra,0x0
    800012dc:	cce080e7          	jalr	-818(ra) # 80000fa6 <walk>
    800012e0:	84aa                	mv	s1,a0
    800012e2:	d95d                	beqz	a0,80001298 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800012e4:	6108                	ld	a0,0(a0)
    800012e6:	00157793          	andi	a5,a0,1
    800012ea:	dfdd                	beqz	a5,800012a8 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800012ec:	3ff57793          	andi	a5,a0,1023
    800012f0:	fd7784e3          	beq	a5,s7,800012b8 <uvmunmap+0x76>
    if(do_free){
    800012f4:	fc0a8ae3          	beqz	s5,800012c8 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800012f8:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800012fa:	0532                	slli	a0,a0,0xc
    800012fc:	fffff097          	auipc	ra,0xfffff
    80001300:	6da080e7          	jalr	1754(ra) # 800009d6 <kfree>
    80001304:	b7d1                	j	800012c8 <uvmunmap+0x86>

0000000080001306 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001306:	1101                	addi	sp,sp,-32
    80001308:	ec06                	sd	ra,24(sp)
    8000130a:	e822                	sd	s0,16(sp)
    8000130c:	e426                	sd	s1,8(sp)
    8000130e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001310:	fffff097          	auipc	ra,0xfffff
    80001314:	7c2080e7          	jalr	1986(ra) # 80000ad2 <kalloc>
    80001318:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000131a:	c519                	beqz	a0,80001328 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000131c:	6605                	lui	a2,0x1
    8000131e:	4581                	li	a1,0
    80001320:	00000097          	auipc	ra,0x0
    80001324:	99e080e7          	jalr	-1634(ra) # 80000cbe <memset>
  return pagetable;
}
    80001328:	8526                	mv	a0,s1
    8000132a:	60e2                	ld	ra,24(sp)
    8000132c:	6442                	ld	s0,16(sp)
    8000132e:	64a2                	ld	s1,8(sp)
    80001330:	6105                	addi	sp,sp,32
    80001332:	8082                	ret

0000000080001334 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001334:	7179                	addi	sp,sp,-48
    80001336:	f406                	sd	ra,40(sp)
    80001338:	f022                	sd	s0,32(sp)
    8000133a:	ec26                	sd	s1,24(sp)
    8000133c:	e84a                	sd	s2,16(sp)
    8000133e:	e44e                	sd	s3,8(sp)
    80001340:	e052                	sd	s4,0(sp)
    80001342:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001344:	6785                	lui	a5,0x1
    80001346:	04f67863          	bgeu	a2,a5,80001396 <uvminit+0x62>
    8000134a:	8a2a                	mv	s4,a0
    8000134c:	89ae                	mv	s3,a1
    8000134e:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80001350:	fffff097          	auipc	ra,0xfffff
    80001354:	782080e7          	jalr	1922(ra) # 80000ad2 <kalloc>
    80001358:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000135a:	6605                	lui	a2,0x1
    8000135c:	4581                	li	a1,0
    8000135e:	00000097          	auipc	ra,0x0
    80001362:	960080e7          	jalr	-1696(ra) # 80000cbe <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001366:	4779                	li	a4,30
    80001368:	86ca                	mv	a3,s2
    8000136a:	6605                	lui	a2,0x1
    8000136c:	4581                	li	a1,0
    8000136e:	8552                	mv	a0,s4
    80001370:	00000097          	auipc	ra,0x0
    80001374:	d1e080e7          	jalr	-738(ra) # 8000108e <mappages>
  memmove(mem, src, sz);
    80001378:	8626                	mv	a2,s1
    8000137a:	85ce                	mv	a1,s3
    8000137c:	854a                	mv	a0,s2
    8000137e:	00000097          	auipc	ra,0x0
    80001382:	99c080e7          	jalr	-1636(ra) # 80000d1a <memmove>
}
    80001386:	70a2                	ld	ra,40(sp)
    80001388:	7402                	ld	s0,32(sp)
    8000138a:	64e2                	ld	s1,24(sp)
    8000138c:	6942                	ld	s2,16(sp)
    8000138e:	69a2                	ld	s3,8(sp)
    80001390:	6a02                	ld	s4,0(sp)
    80001392:	6145                	addi	sp,sp,48
    80001394:	8082                	ret
    panic("inituvm: more than a page");
    80001396:	00007517          	auipc	a0,0x7
    8000139a:	daa50513          	addi	a0,a0,-598 # 80008140 <digits+0x100>
    8000139e:	fffff097          	auipc	ra,0xfffff
    800013a2:	18c080e7          	jalr	396(ra) # 8000052a <panic>

00000000800013a6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013a6:	1101                	addi	sp,sp,-32
    800013a8:	ec06                	sd	ra,24(sp)
    800013aa:	e822                	sd	s0,16(sp)
    800013ac:	e426                	sd	s1,8(sp)
    800013ae:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013b0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013b2:	00b67d63          	bgeu	a2,a1,800013cc <uvmdealloc+0x26>
    800013b6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013b8:	6785                	lui	a5,0x1
    800013ba:	17fd                	addi	a5,a5,-1
    800013bc:	00f60733          	add	a4,a2,a5
    800013c0:	767d                	lui	a2,0xfffff
    800013c2:	8f71                	and	a4,a4,a2
    800013c4:	97ae                	add	a5,a5,a1
    800013c6:	8ff1                	and	a5,a5,a2
    800013c8:	00f76863          	bltu	a4,a5,800013d8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013cc:	8526                	mv	a0,s1
    800013ce:	60e2                	ld	ra,24(sp)
    800013d0:	6442                	ld	s0,16(sp)
    800013d2:	64a2                	ld	s1,8(sp)
    800013d4:	6105                	addi	sp,sp,32
    800013d6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013d8:	8f99                	sub	a5,a5,a4
    800013da:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013dc:	4685                	li	a3,1
    800013de:	0007861b          	sext.w	a2,a5
    800013e2:	85ba                	mv	a1,a4
    800013e4:	00000097          	auipc	ra,0x0
    800013e8:	e5e080e7          	jalr	-418(ra) # 80001242 <uvmunmap>
    800013ec:	b7c5                	j	800013cc <uvmdealloc+0x26>

00000000800013ee <uvmalloc>:
  if(newsz < oldsz)
    800013ee:	0ab66163          	bltu	a2,a1,80001490 <uvmalloc+0xa2>
{
    800013f2:	7139                	addi	sp,sp,-64
    800013f4:	fc06                	sd	ra,56(sp)
    800013f6:	f822                	sd	s0,48(sp)
    800013f8:	f426                	sd	s1,40(sp)
    800013fa:	f04a                	sd	s2,32(sp)
    800013fc:	ec4e                	sd	s3,24(sp)
    800013fe:	e852                	sd	s4,16(sp)
    80001400:	e456                	sd	s5,8(sp)
    80001402:	0080                	addi	s0,sp,64
    80001404:	8aaa                	mv	s5,a0
    80001406:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001408:	6985                	lui	s3,0x1
    8000140a:	19fd                	addi	s3,s3,-1
    8000140c:	95ce                	add	a1,a1,s3
    8000140e:	79fd                	lui	s3,0xfffff
    80001410:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001414:	08c9f063          	bgeu	s3,a2,80001494 <uvmalloc+0xa6>
    80001418:	894e                	mv	s2,s3
    mem = kalloc();
    8000141a:	fffff097          	auipc	ra,0xfffff
    8000141e:	6b8080e7          	jalr	1720(ra) # 80000ad2 <kalloc>
    80001422:	84aa                	mv	s1,a0
    if(mem == 0){
    80001424:	c51d                	beqz	a0,80001452 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001426:	6605                	lui	a2,0x1
    80001428:	4581                	li	a1,0
    8000142a:	00000097          	auipc	ra,0x0
    8000142e:	894080e7          	jalr	-1900(ra) # 80000cbe <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001432:	4779                	li	a4,30
    80001434:	86a6                	mv	a3,s1
    80001436:	6605                	lui	a2,0x1
    80001438:	85ca                	mv	a1,s2
    8000143a:	8556                	mv	a0,s5
    8000143c:	00000097          	auipc	ra,0x0
    80001440:	c52080e7          	jalr	-942(ra) # 8000108e <mappages>
    80001444:	e905                	bnez	a0,80001474 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001446:	6785                	lui	a5,0x1
    80001448:	993e                	add	s2,s2,a5
    8000144a:	fd4968e3          	bltu	s2,s4,8000141a <uvmalloc+0x2c>
  return newsz;
    8000144e:	8552                	mv	a0,s4
    80001450:	a809                	j	80001462 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001452:	864e                	mv	a2,s3
    80001454:	85ca                	mv	a1,s2
    80001456:	8556                	mv	a0,s5
    80001458:	00000097          	auipc	ra,0x0
    8000145c:	f4e080e7          	jalr	-178(ra) # 800013a6 <uvmdealloc>
      return 0;
    80001460:	4501                	li	a0,0
}
    80001462:	70e2                	ld	ra,56(sp)
    80001464:	7442                	ld	s0,48(sp)
    80001466:	74a2                	ld	s1,40(sp)
    80001468:	7902                	ld	s2,32(sp)
    8000146a:	69e2                	ld	s3,24(sp)
    8000146c:	6a42                	ld	s4,16(sp)
    8000146e:	6aa2                	ld	s5,8(sp)
    80001470:	6121                	addi	sp,sp,64
    80001472:	8082                	ret
      kfree(mem);
    80001474:	8526                	mv	a0,s1
    80001476:	fffff097          	auipc	ra,0xfffff
    8000147a:	560080e7          	jalr	1376(ra) # 800009d6 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000147e:	864e                	mv	a2,s3
    80001480:	85ca                	mv	a1,s2
    80001482:	8556                	mv	a0,s5
    80001484:	00000097          	auipc	ra,0x0
    80001488:	f22080e7          	jalr	-222(ra) # 800013a6 <uvmdealloc>
      return 0;
    8000148c:	4501                	li	a0,0
    8000148e:	bfd1                	j	80001462 <uvmalloc+0x74>
    return oldsz;
    80001490:	852e                	mv	a0,a1
}
    80001492:	8082                	ret
  return newsz;
    80001494:	8532                	mv	a0,a2
    80001496:	b7f1                	j	80001462 <uvmalloc+0x74>

0000000080001498 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001498:	7179                	addi	sp,sp,-48
    8000149a:	f406                	sd	ra,40(sp)
    8000149c:	f022                	sd	s0,32(sp)
    8000149e:	ec26                	sd	s1,24(sp)
    800014a0:	e84a                	sd	s2,16(sp)
    800014a2:	e44e                	sd	s3,8(sp)
    800014a4:	e052                	sd	s4,0(sp)
    800014a6:	1800                	addi	s0,sp,48
    800014a8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014aa:	84aa                	mv	s1,a0
    800014ac:	6905                	lui	s2,0x1
    800014ae:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014b0:	4985                	li	s3,1
    800014b2:	a821                	j	800014ca <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014b4:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800014b6:	0532                	slli	a0,a0,0xc
    800014b8:	00000097          	auipc	ra,0x0
    800014bc:	fe0080e7          	jalr	-32(ra) # 80001498 <freewalk>
      pagetable[i] = 0;
    800014c0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014c4:	04a1                	addi	s1,s1,8
    800014c6:	03248163          	beq	s1,s2,800014e8 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800014ca:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014cc:	00f57793          	andi	a5,a0,15
    800014d0:	ff3782e3          	beq	a5,s3,800014b4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014d4:	8905                	andi	a0,a0,1
    800014d6:	d57d                	beqz	a0,800014c4 <freewalk+0x2c>
      panic("freewalk: leaf");
    800014d8:	00007517          	auipc	a0,0x7
    800014dc:	c8850513          	addi	a0,a0,-888 # 80008160 <digits+0x120>
    800014e0:	fffff097          	auipc	ra,0xfffff
    800014e4:	04a080e7          	jalr	74(ra) # 8000052a <panic>
    }
  }
  kfree((void*)pagetable);
    800014e8:	8552                	mv	a0,s4
    800014ea:	fffff097          	auipc	ra,0xfffff
    800014ee:	4ec080e7          	jalr	1260(ra) # 800009d6 <kfree>
}
    800014f2:	70a2                	ld	ra,40(sp)
    800014f4:	7402                	ld	s0,32(sp)
    800014f6:	64e2                	ld	s1,24(sp)
    800014f8:	6942                	ld	s2,16(sp)
    800014fa:	69a2                	ld	s3,8(sp)
    800014fc:	6a02                	ld	s4,0(sp)
    800014fe:	6145                	addi	sp,sp,48
    80001500:	8082                	ret

0000000080001502 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001502:	1101                	addi	sp,sp,-32
    80001504:	ec06                	sd	ra,24(sp)
    80001506:	e822                	sd	s0,16(sp)
    80001508:	e426                	sd	s1,8(sp)
    8000150a:	1000                	addi	s0,sp,32
    8000150c:	84aa                	mv	s1,a0
  if(sz > 0)
    8000150e:	e999                	bnez	a1,80001524 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001510:	8526                	mv	a0,s1
    80001512:	00000097          	auipc	ra,0x0
    80001516:	f86080e7          	jalr	-122(ra) # 80001498 <freewalk>
}
    8000151a:	60e2                	ld	ra,24(sp)
    8000151c:	6442                	ld	s0,16(sp)
    8000151e:	64a2                	ld	s1,8(sp)
    80001520:	6105                	addi	sp,sp,32
    80001522:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001524:	6605                	lui	a2,0x1
    80001526:	167d                	addi	a2,a2,-1
    80001528:	962e                	add	a2,a2,a1
    8000152a:	4685                	li	a3,1
    8000152c:	8231                	srli	a2,a2,0xc
    8000152e:	4581                	li	a1,0
    80001530:	00000097          	auipc	ra,0x0
    80001534:	d12080e7          	jalr	-750(ra) # 80001242 <uvmunmap>
    80001538:	bfe1                	j	80001510 <uvmfree+0xe>

000000008000153a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000153a:	c679                	beqz	a2,80001608 <uvmcopy+0xce>
{
    8000153c:	715d                	addi	sp,sp,-80
    8000153e:	e486                	sd	ra,72(sp)
    80001540:	e0a2                	sd	s0,64(sp)
    80001542:	fc26                	sd	s1,56(sp)
    80001544:	f84a                	sd	s2,48(sp)
    80001546:	f44e                	sd	s3,40(sp)
    80001548:	f052                	sd	s4,32(sp)
    8000154a:	ec56                	sd	s5,24(sp)
    8000154c:	e85a                	sd	s6,16(sp)
    8000154e:	e45e                	sd	s7,8(sp)
    80001550:	0880                	addi	s0,sp,80
    80001552:	8b2a                	mv	s6,a0
    80001554:	8aae                	mv	s5,a1
    80001556:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001558:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000155a:	4601                	li	a2,0
    8000155c:	85ce                	mv	a1,s3
    8000155e:	855a                	mv	a0,s6
    80001560:	00000097          	auipc	ra,0x0
    80001564:	a46080e7          	jalr	-1466(ra) # 80000fa6 <walk>
    80001568:	c531                	beqz	a0,800015b4 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000156a:	6118                	ld	a4,0(a0)
    8000156c:	00177793          	andi	a5,a4,1
    80001570:	cbb1                	beqz	a5,800015c4 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001572:	00a75593          	srli	a1,a4,0xa
    80001576:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000157a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000157e:	fffff097          	auipc	ra,0xfffff
    80001582:	554080e7          	jalr	1364(ra) # 80000ad2 <kalloc>
    80001586:	892a                	mv	s2,a0
    80001588:	c939                	beqz	a0,800015de <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000158a:	6605                	lui	a2,0x1
    8000158c:	85de                	mv	a1,s7
    8000158e:	fffff097          	auipc	ra,0xfffff
    80001592:	78c080e7          	jalr	1932(ra) # 80000d1a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001596:	8726                	mv	a4,s1
    80001598:	86ca                	mv	a3,s2
    8000159a:	6605                	lui	a2,0x1
    8000159c:	85ce                	mv	a1,s3
    8000159e:	8556                	mv	a0,s5
    800015a0:	00000097          	auipc	ra,0x0
    800015a4:	aee080e7          	jalr	-1298(ra) # 8000108e <mappages>
    800015a8:	e515                	bnez	a0,800015d4 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015aa:	6785                	lui	a5,0x1
    800015ac:	99be                	add	s3,s3,a5
    800015ae:	fb49e6e3          	bltu	s3,s4,8000155a <uvmcopy+0x20>
    800015b2:	a081                	j	800015f2 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015b4:	00007517          	auipc	a0,0x7
    800015b8:	bbc50513          	addi	a0,a0,-1092 # 80008170 <digits+0x130>
    800015bc:	fffff097          	auipc	ra,0xfffff
    800015c0:	f6e080e7          	jalr	-146(ra) # 8000052a <panic>
      panic("uvmcopy: page not present");
    800015c4:	00007517          	auipc	a0,0x7
    800015c8:	bcc50513          	addi	a0,a0,-1076 # 80008190 <digits+0x150>
    800015cc:	fffff097          	auipc	ra,0xfffff
    800015d0:	f5e080e7          	jalr	-162(ra) # 8000052a <panic>
      kfree(mem);
    800015d4:	854a                	mv	a0,s2
    800015d6:	fffff097          	auipc	ra,0xfffff
    800015da:	400080e7          	jalr	1024(ra) # 800009d6 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800015de:	4685                	li	a3,1
    800015e0:	00c9d613          	srli	a2,s3,0xc
    800015e4:	4581                	li	a1,0
    800015e6:	8556                	mv	a0,s5
    800015e8:	00000097          	auipc	ra,0x0
    800015ec:	c5a080e7          	jalr	-934(ra) # 80001242 <uvmunmap>
  return -1;
    800015f0:	557d                	li	a0,-1
}
    800015f2:	60a6                	ld	ra,72(sp)
    800015f4:	6406                	ld	s0,64(sp)
    800015f6:	74e2                	ld	s1,56(sp)
    800015f8:	7942                	ld	s2,48(sp)
    800015fa:	79a2                	ld	s3,40(sp)
    800015fc:	7a02                	ld	s4,32(sp)
    800015fe:	6ae2                	ld	s5,24(sp)
    80001600:	6b42                	ld	s6,16(sp)
    80001602:	6ba2                	ld	s7,8(sp)
    80001604:	6161                	addi	sp,sp,80
    80001606:	8082                	ret
  return 0;
    80001608:	4501                	li	a0,0
}
    8000160a:	8082                	ret

000000008000160c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000160c:	1141                	addi	sp,sp,-16
    8000160e:	e406                	sd	ra,8(sp)
    80001610:	e022                	sd	s0,0(sp)
    80001612:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001614:	4601                	li	a2,0
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	990080e7          	jalr	-1648(ra) # 80000fa6 <walk>
  if(pte == 0)
    8000161e:	c901                	beqz	a0,8000162e <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001620:	611c                	ld	a5,0(a0)
    80001622:	9bbd                	andi	a5,a5,-17
    80001624:	e11c                	sd	a5,0(a0)
}
    80001626:	60a2                	ld	ra,8(sp)
    80001628:	6402                	ld	s0,0(sp)
    8000162a:	0141                	addi	sp,sp,16
    8000162c:	8082                	ret
    panic("uvmclear");
    8000162e:	00007517          	auipc	a0,0x7
    80001632:	b8250513          	addi	a0,a0,-1150 # 800081b0 <digits+0x170>
    80001636:	fffff097          	auipc	ra,0xfffff
    8000163a:	ef4080e7          	jalr	-268(ra) # 8000052a <panic>

000000008000163e <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000163e:	c6bd                	beqz	a3,800016ac <copyout+0x6e>
{
    80001640:	715d                	addi	sp,sp,-80
    80001642:	e486                	sd	ra,72(sp)
    80001644:	e0a2                	sd	s0,64(sp)
    80001646:	fc26                	sd	s1,56(sp)
    80001648:	f84a                	sd	s2,48(sp)
    8000164a:	f44e                	sd	s3,40(sp)
    8000164c:	f052                	sd	s4,32(sp)
    8000164e:	ec56                	sd	s5,24(sp)
    80001650:	e85a                	sd	s6,16(sp)
    80001652:	e45e                	sd	s7,8(sp)
    80001654:	e062                	sd	s8,0(sp)
    80001656:	0880                	addi	s0,sp,80
    80001658:	8b2a                	mv	s6,a0
    8000165a:	8c2e                	mv	s8,a1
    8000165c:	8a32                	mv	s4,a2
    8000165e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001660:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001662:	6a85                	lui	s5,0x1
    80001664:	a015                	j	80001688 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001666:	9562                	add	a0,a0,s8
    80001668:	0004861b          	sext.w	a2,s1
    8000166c:	85d2                	mv	a1,s4
    8000166e:	41250533          	sub	a0,a0,s2
    80001672:	fffff097          	auipc	ra,0xfffff
    80001676:	6a8080e7          	jalr	1704(ra) # 80000d1a <memmove>

    len -= n;
    8000167a:	409989b3          	sub	s3,s3,s1
    src += n;
    8000167e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001680:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001684:	02098263          	beqz	s3,800016a8 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001688:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000168c:	85ca                	mv	a1,s2
    8000168e:	855a                	mv	a0,s6
    80001690:	00000097          	auipc	ra,0x0
    80001694:	9bc080e7          	jalr	-1604(ra) # 8000104c <walkaddr>
    if(pa0 == 0)
    80001698:	cd01                	beqz	a0,800016b0 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000169a:	418904b3          	sub	s1,s2,s8
    8000169e:	94d6                	add	s1,s1,s5
    if(n > len)
    800016a0:	fc99f3e3          	bgeu	s3,s1,80001666 <copyout+0x28>
    800016a4:	84ce                	mv	s1,s3
    800016a6:	b7c1                	j	80001666 <copyout+0x28>
  }
  return 0;
    800016a8:	4501                	li	a0,0
    800016aa:	a021                	j	800016b2 <copyout+0x74>
    800016ac:	4501                	li	a0,0
}
    800016ae:	8082                	ret
      return -1;
    800016b0:	557d                	li	a0,-1
}
    800016b2:	60a6                	ld	ra,72(sp)
    800016b4:	6406                	ld	s0,64(sp)
    800016b6:	74e2                	ld	s1,56(sp)
    800016b8:	7942                	ld	s2,48(sp)
    800016ba:	79a2                	ld	s3,40(sp)
    800016bc:	7a02                	ld	s4,32(sp)
    800016be:	6ae2                	ld	s5,24(sp)
    800016c0:	6b42                	ld	s6,16(sp)
    800016c2:	6ba2                	ld	s7,8(sp)
    800016c4:	6c02                	ld	s8,0(sp)
    800016c6:	6161                	addi	sp,sp,80
    800016c8:	8082                	ret

00000000800016ca <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016ca:	caa5                	beqz	a3,8000173a <copyin+0x70>
{
    800016cc:	715d                	addi	sp,sp,-80
    800016ce:	e486                	sd	ra,72(sp)
    800016d0:	e0a2                	sd	s0,64(sp)
    800016d2:	fc26                	sd	s1,56(sp)
    800016d4:	f84a                	sd	s2,48(sp)
    800016d6:	f44e                	sd	s3,40(sp)
    800016d8:	f052                	sd	s4,32(sp)
    800016da:	ec56                	sd	s5,24(sp)
    800016dc:	e85a                	sd	s6,16(sp)
    800016de:	e45e                	sd	s7,8(sp)
    800016e0:	e062                	sd	s8,0(sp)
    800016e2:	0880                	addi	s0,sp,80
    800016e4:	8b2a                	mv	s6,a0
    800016e6:	8a2e                	mv	s4,a1
    800016e8:	8c32                	mv	s8,a2
    800016ea:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800016ec:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016ee:	6a85                	lui	s5,0x1
    800016f0:	a01d                	j	80001716 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800016f2:	018505b3          	add	a1,a0,s8
    800016f6:	0004861b          	sext.w	a2,s1
    800016fa:	412585b3          	sub	a1,a1,s2
    800016fe:	8552                	mv	a0,s4
    80001700:	fffff097          	auipc	ra,0xfffff
    80001704:	61a080e7          	jalr	1562(ra) # 80000d1a <memmove>

    len -= n;
    80001708:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000170c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000170e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001712:	02098263          	beqz	s3,80001736 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001716:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000171a:	85ca                	mv	a1,s2
    8000171c:	855a                	mv	a0,s6
    8000171e:	00000097          	auipc	ra,0x0
    80001722:	92e080e7          	jalr	-1746(ra) # 8000104c <walkaddr>
    if(pa0 == 0)
    80001726:	cd01                	beqz	a0,8000173e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001728:	418904b3          	sub	s1,s2,s8
    8000172c:	94d6                	add	s1,s1,s5
    if(n > len)
    8000172e:	fc99f2e3          	bgeu	s3,s1,800016f2 <copyin+0x28>
    80001732:	84ce                	mv	s1,s3
    80001734:	bf7d                	j	800016f2 <copyin+0x28>
  }
  return 0;
    80001736:	4501                	li	a0,0
    80001738:	a021                	j	80001740 <copyin+0x76>
    8000173a:	4501                	li	a0,0
}
    8000173c:	8082                	ret
      return -1;
    8000173e:	557d                	li	a0,-1
}
    80001740:	60a6                	ld	ra,72(sp)
    80001742:	6406                	ld	s0,64(sp)
    80001744:	74e2                	ld	s1,56(sp)
    80001746:	7942                	ld	s2,48(sp)
    80001748:	79a2                	ld	s3,40(sp)
    8000174a:	7a02                	ld	s4,32(sp)
    8000174c:	6ae2                	ld	s5,24(sp)
    8000174e:	6b42                	ld	s6,16(sp)
    80001750:	6ba2                	ld	s7,8(sp)
    80001752:	6c02                	ld	s8,0(sp)
    80001754:	6161                	addi	sp,sp,80
    80001756:	8082                	ret

0000000080001758 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001758:	c6c5                	beqz	a3,80001800 <copyinstr+0xa8>
{
    8000175a:	715d                	addi	sp,sp,-80
    8000175c:	e486                	sd	ra,72(sp)
    8000175e:	e0a2                	sd	s0,64(sp)
    80001760:	fc26                	sd	s1,56(sp)
    80001762:	f84a                	sd	s2,48(sp)
    80001764:	f44e                	sd	s3,40(sp)
    80001766:	f052                	sd	s4,32(sp)
    80001768:	ec56                	sd	s5,24(sp)
    8000176a:	e85a                	sd	s6,16(sp)
    8000176c:	e45e                	sd	s7,8(sp)
    8000176e:	0880                	addi	s0,sp,80
    80001770:	8a2a                	mv	s4,a0
    80001772:	8b2e                	mv	s6,a1
    80001774:	8bb2                	mv	s7,a2
    80001776:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001778:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000177a:	6985                	lui	s3,0x1
    8000177c:	a035                	j	800017a8 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000177e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001782:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001784:	0017b793          	seqz	a5,a5
    80001788:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000178c:	60a6                	ld	ra,72(sp)
    8000178e:	6406                	ld	s0,64(sp)
    80001790:	74e2                	ld	s1,56(sp)
    80001792:	7942                	ld	s2,48(sp)
    80001794:	79a2                	ld	s3,40(sp)
    80001796:	7a02                	ld	s4,32(sp)
    80001798:	6ae2                	ld	s5,24(sp)
    8000179a:	6b42                	ld	s6,16(sp)
    8000179c:	6ba2                	ld	s7,8(sp)
    8000179e:	6161                	addi	sp,sp,80
    800017a0:	8082                	ret
    srcva = va0 + PGSIZE;
    800017a2:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017a6:	c8a9                	beqz	s1,800017f8 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800017a8:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017ac:	85ca                	mv	a1,s2
    800017ae:	8552                	mv	a0,s4
    800017b0:	00000097          	auipc	ra,0x0
    800017b4:	89c080e7          	jalr	-1892(ra) # 8000104c <walkaddr>
    if(pa0 == 0)
    800017b8:	c131                	beqz	a0,800017fc <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800017ba:	41790833          	sub	a6,s2,s7
    800017be:	984e                	add	a6,a6,s3
    if(n > max)
    800017c0:	0104f363          	bgeu	s1,a6,800017c6 <copyinstr+0x6e>
    800017c4:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017c6:	955e                	add	a0,a0,s7
    800017c8:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017cc:	fc080be3          	beqz	a6,800017a2 <copyinstr+0x4a>
    800017d0:	985a                	add	a6,a6,s6
    800017d2:	87da                	mv	a5,s6
      if(*p == '\0'){
    800017d4:	41650633          	sub	a2,a0,s6
    800017d8:	14fd                	addi	s1,s1,-1
    800017da:	9b26                	add	s6,s6,s1
    800017dc:	00f60733          	add	a4,a2,a5
    800017e0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffce000>
    800017e4:	df49                	beqz	a4,8000177e <copyinstr+0x26>
        *dst = *p;
    800017e6:	00e78023          	sb	a4,0(a5)
      --max;
    800017ea:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800017ee:	0785                	addi	a5,a5,1
    while(n > 0){
    800017f0:	ff0796e3          	bne	a5,a6,800017dc <copyinstr+0x84>
      dst++;
    800017f4:	8b42                	mv	s6,a6
    800017f6:	b775                	j	800017a2 <copyinstr+0x4a>
    800017f8:	4781                	li	a5,0
    800017fa:	b769                	j	80001784 <copyinstr+0x2c>
      return -1;
    800017fc:	557d                	li	a0,-1
    800017fe:	b779                	j	8000178c <copyinstr+0x34>
  int got_null = 0;
    80001800:	4781                	li	a5,0
  if(got_null){
    80001802:	0017b793          	seqz	a5,a5
    80001806:	40f00533          	neg	a0,a5
}
    8000180a:	8082                	ret

000000008000180c <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    8000180c:	7139                	addi	sp,sp,-64
    8000180e:	fc06                	sd	ra,56(sp)
    80001810:	f822                	sd	s0,48(sp)
    80001812:	f426                	sd	s1,40(sp)
    80001814:	f04a                	sd	s2,32(sp)
    80001816:	ec4e                	sd	s3,24(sp)
    80001818:	e852                	sd	s4,16(sp)
    8000181a:	e456                	sd	s5,8(sp)
    8000181c:	e05a                	sd	s6,0(sp)
    8000181e:	0080                	addi	s0,sp,64
    80001820:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001822:	00010497          	auipc	s1,0x10
    80001826:	eae48493          	addi	s1,s1,-338 # 800116d0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    8000182a:	8b26                	mv	s6,s1
    8000182c:	00006a97          	auipc	s5,0x6
    80001830:	7d4a8a93          	addi	s5,s5,2004 # 80008000 <etext>
    80001834:	04000937          	lui	s2,0x4000
    80001838:	197d                	addi	s2,s2,-1
    8000183a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000183c:	00020a17          	auipc	s4,0x20
    80001840:	694a0a13          	addi	s4,s4,1684 # 80021ed0 <tickslock>
    char *pa = kalloc();
    80001844:	fffff097          	auipc	ra,0xfffff
    80001848:	28e080e7          	jalr	654(ra) # 80000ad2 <kalloc>
    8000184c:	862a                	mv	a2,a0
    if(pa == 0)
    8000184e:	c131                	beqz	a0,80001892 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001850:	416485b3          	sub	a1,s1,s6
    80001854:	8595                	srai	a1,a1,0x5
    80001856:	000ab783          	ld	a5,0(s5)
    8000185a:	02f585b3          	mul	a1,a1,a5
    8000185e:	2585                	addiw	a1,a1,1
    80001860:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001864:	4719                	li	a4,6
    80001866:	6685                	lui	a3,0x1
    80001868:	40b905b3          	sub	a1,s2,a1
    8000186c:	854e                	mv	a0,s3
    8000186e:	00000097          	auipc	ra,0x0
    80001872:	8ae080e7          	jalr	-1874(ra) # 8000111c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001876:	42048493          	addi	s1,s1,1056
    8000187a:	fd4495e3          	bne	s1,s4,80001844 <proc_mapstacks+0x38>
  }
}
    8000187e:	70e2                	ld	ra,56(sp)
    80001880:	7442                	ld	s0,48(sp)
    80001882:	74a2                	ld	s1,40(sp)
    80001884:	7902                	ld	s2,32(sp)
    80001886:	69e2                	ld	s3,24(sp)
    80001888:	6a42                	ld	s4,16(sp)
    8000188a:	6aa2                	ld	s5,8(sp)
    8000188c:	6b02                	ld	s6,0(sp)
    8000188e:	6121                	addi	sp,sp,64
    80001890:	8082                	ret
      panic("kalloc");
    80001892:	00007517          	auipc	a0,0x7
    80001896:	92e50513          	addi	a0,a0,-1746 # 800081c0 <digits+0x180>
    8000189a:	fffff097          	auipc	ra,0xfffff
    8000189e:	c90080e7          	jalr	-880(ra) # 8000052a <panic>

00000000800018a2 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    800018a2:	7139                	addi	sp,sp,-64
    800018a4:	fc06                	sd	ra,56(sp)
    800018a6:	f822                	sd	s0,48(sp)
    800018a8:	f426                	sd	s1,40(sp)
    800018aa:	f04a                	sd	s2,32(sp)
    800018ac:	ec4e                	sd	s3,24(sp)
    800018ae:	e852                	sd	s4,16(sp)
    800018b0:	e456                	sd	s5,8(sp)
    800018b2:	e05a                	sd	s6,0(sp)
    800018b4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800018b6:	00007597          	auipc	a1,0x7
    800018ba:	91258593          	addi	a1,a1,-1774 # 800081c8 <digits+0x188>
    800018be:	00010517          	auipc	a0,0x10
    800018c2:	9e250513          	addi	a0,a0,-1566 # 800112a0 <pid_lock>
    800018c6:	fffff097          	auipc	ra,0xfffff
    800018ca:	26c080e7          	jalr	620(ra) # 80000b32 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018ce:	00007597          	auipc	a1,0x7
    800018d2:	90258593          	addi	a1,a1,-1790 # 800081d0 <digits+0x190>
    800018d6:	00010517          	auipc	a0,0x10
    800018da:	9e250513          	addi	a0,a0,-1566 # 800112b8 <wait_lock>
    800018de:	fffff097          	auipc	ra,0xfffff
    800018e2:	254080e7          	jalr	596(ra) # 80000b32 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018e6:	00010497          	auipc	s1,0x10
    800018ea:	dea48493          	addi	s1,s1,-534 # 800116d0 <proc>
      initlock(&p->lock, "proc");
    800018ee:	00007b17          	auipc	s6,0x7
    800018f2:	8f2b0b13          	addi	s6,s6,-1806 # 800081e0 <digits+0x1a0>
      p->kstack = KSTACK((int) (p - proc));
    800018f6:	8aa6                	mv	s5,s1
    800018f8:	00006a17          	auipc	s4,0x6
    800018fc:	708a0a13          	addi	s4,s4,1800 # 80008000 <etext>
    80001900:	04000937          	lui	s2,0x4000
    80001904:	197d                	addi	s2,s2,-1
    80001906:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001908:	00020997          	auipc	s3,0x20
    8000190c:	5c898993          	addi	s3,s3,1480 # 80021ed0 <tickslock>
      initlock(&p->lock, "proc");
    80001910:	85da                	mv	a1,s6
    80001912:	8526                	mv	a0,s1
    80001914:	fffff097          	auipc	ra,0xfffff
    80001918:	21e080e7          	jalr	542(ra) # 80000b32 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    8000191c:	415487b3          	sub	a5,s1,s5
    80001920:	8795                	srai	a5,a5,0x5
    80001922:	000a3703          	ld	a4,0(s4)
    80001926:	02e787b3          	mul	a5,a5,a4
    8000192a:	2785                	addiw	a5,a5,1
    8000192c:	00d7979b          	slliw	a5,a5,0xd
    80001930:	40f907b3          	sub	a5,s2,a5
    80001934:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001936:	42048493          	addi	s1,s1,1056
    8000193a:	fd349be3          	bne	s1,s3,80001910 <procinit+0x6e>
  }
}
    8000193e:	70e2                	ld	ra,56(sp)
    80001940:	7442                	ld	s0,48(sp)
    80001942:	74a2                	ld	s1,40(sp)
    80001944:	7902                	ld	s2,32(sp)
    80001946:	69e2                	ld	s3,24(sp)
    80001948:	6a42                	ld	s4,16(sp)
    8000194a:	6aa2                	ld	s5,8(sp)
    8000194c:	6b02                	ld	s6,0(sp)
    8000194e:	6121                	addi	sp,sp,64
    80001950:	8082                	ret

0000000080001952 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001952:	1141                	addi	sp,sp,-16
    80001954:	e422                	sd	s0,8(sp)
    80001956:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001958:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000195a:	2501                	sext.w	a0,a0
    8000195c:	6422                	ld	s0,8(sp)
    8000195e:	0141                	addi	sp,sp,16
    80001960:	8082                	ret

0000000080001962 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80001962:	1141                	addi	sp,sp,-16
    80001964:	e422                	sd	s0,8(sp)
    80001966:	0800                	addi	s0,sp,16
    80001968:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000196a:	2781                	sext.w	a5,a5
    8000196c:	079e                	slli	a5,a5,0x7
  return c;
}
    8000196e:	00010517          	auipc	a0,0x10
    80001972:	96250513          	addi	a0,a0,-1694 # 800112d0 <cpus>
    80001976:	953e                	add	a0,a0,a5
    80001978:	6422                	ld	s0,8(sp)
    8000197a:	0141                	addi	sp,sp,16
    8000197c:	8082                	ret

000000008000197e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    8000197e:	1101                	addi	sp,sp,-32
    80001980:	ec06                	sd	ra,24(sp)
    80001982:	e822                	sd	s0,16(sp)
    80001984:	e426                	sd	s1,8(sp)
    80001986:	1000                	addi	s0,sp,32
  push_off();
    80001988:	fffff097          	auipc	ra,0xfffff
    8000198c:	1ee080e7          	jalr	494(ra) # 80000b76 <push_off>
    80001990:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001992:	2781                	sext.w	a5,a5
    80001994:	079e                	slli	a5,a5,0x7
    80001996:	00010717          	auipc	a4,0x10
    8000199a:	90a70713          	addi	a4,a4,-1782 # 800112a0 <pid_lock>
    8000199e:	97ba                	add	a5,a5,a4
    800019a0:	7b84                	ld	s1,48(a5)
  pop_off();
    800019a2:	fffff097          	auipc	ra,0xfffff
    800019a6:	274080e7          	jalr	628(ra) # 80000c16 <pop_off>
  return p;
}
    800019aa:	8526                	mv	a0,s1
    800019ac:	60e2                	ld	ra,24(sp)
    800019ae:	6442                	ld	s0,16(sp)
    800019b0:	64a2                	ld	s1,8(sp)
    800019b2:	6105                	addi	sp,sp,32
    800019b4:	8082                	ret

00000000800019b6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800019b6:	1141                	addi	sp,sp,-16
    800019b8:	e406                	sd	ra,8(sp)
    800019ba:	e022                	sd	s0,0(sp)
    800019bc:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800019be:	00000097          	auipc	ra,0x0
    800019c2:	fc0080e7          	jalr	-64(ra) # 8000197e <myproc>
    800019c6:	fffff097          	auipc	ra,0xfffff
    800019ca:	2b0080e7          	jalr	688(ra) # 80000c76 <release>

  if (first) {
    800019ce:	00007797          	auipc	a5,0x7
    800019d2:	e927a783          	lw	a5,-366(a5) # 80008860 <first.1>
    800019d6:	eb89                	bnez	a5,800019e8 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800019d8:	00001097          	auipc	ra,0x1
    800019dc:	046080e7          	jalr	70(ra) # 80002a1e <usertrapret>
}
    800019e0:	60a2                	ld	ra,8(sp)
    800019e2:	6402                	ld	s0,0(sp)
    800019e4:	0141                	addi	sp,sp,16
    800019e6:	8082                	ret
    first = 0;
    800019e8:	00007797          	auipc	a5,0x7
    800019ec:	e607ac23          	sw	zero,-392(a5) # 80008860 <first.1>
    fsinit(ROOTDEV);
    800019f0:	4505                	li	a0,1
    800019f2:	00002097          	auipc	ra,0x2
    800019f6:	e4a080e7          	jalr	-438(ra) # 8000383c <fsinit>
    800019fa:	bff9                	j	800019d8 <forkret+0x22>

00000000800019fc <allocpid>:
allocpid() {
    800019fc:	1101                	addi	sp,sp,-32
    800019fe:	ec06                	sd	ra,24(sp)
    80001a00:	e822                	sd	s0,16(sp)
    80001a02:	e426                	sd	s1,8(sp)
    80001a04:	e04a                	sd	s2,0(sp)
    80001a06:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a08:	00010917          	auipc	s2,0x10
    80001a0c:	89890913          	addi	s2,s2,-1896 # 800112a0 <pid_lock>
    80001a10:	854a                	mv	a0,s2
    80001a12:	fffff097          	auipc	ra,0xfffff
    80001a16:	1b0080e7          	jalr	432(ra) # 80000bc2 <acquire>
  pid = nextpid;
    80001a1a:	00007797          	auipc	a5,0x7
    80001a1e:	e4a78793          	addi	a5,a5,-438 # 80008864 <nextpid>
    80001a22:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a24:	0014871b          	addiw	a4,s1,1
    80001a28:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a2a:	854a                	mv	a0,s2
    80001a2c:	fffff097          	auipc	ra,0xfffff
    80001a30:	24a080e7          	jalr	586(ra) # 80000c76 <release>
}
    80001a34:	8526                	mv	a0,s1
    80001a36:	60e2                	ld	ra,24(sp)
    80001a38:	6442                	ld	s0,16(sp)
    80001a3a:	64a2                	ld	s1,8(sp)
    80001a3c:	6902                	ld	s2,0(sp)
    80001a3e:	6105                	addi	sp,sp,32
    80001a40:	8082                	ret

0000000080001a42 <proc_pagetable>:
{
    80001a42:	1101                	addi	sp,sp,-32
    80001a44:	ec06                	sd	ra,24(sp)
    80001a46:	e822                	sd	s0,16(sp)
    80001a48:	e426                	sd	s1,8(sp)
    80001a4a:	e04a                	sd	s2,0(sp)
    80001a4c:	1000                	addi	s0,sp,32
    80001a4e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a50:	00000097          	auipc	ra,0x0
    80001a54:	8b6080e7          	jalr	-1866(ra) # 80001306 <uvmcreate>
    80001a58:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a5a:	c121                	beqz	a0,80001a9a <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a5c:	4729                	li	a4,10
    80001a5e:	00005697          	auipc	a3,0x5
    80001a62:	5a268693          	addi	a3,a3,1442 # 80007000 <_trampoline>
    80001a66:	6605                	lui	a2,0x1
    80001a68:	040005b7          	lui	a1,0x4000
    80001a6c:	15fd                	addi	a1,a1,-1
    80001a6e:	05b2                	slli	a1,a1,0xc
    80001a70:	fffff097          	auipc	ra,0xfffff
    80001a74:	61e080e7          	jalr	1566(ra) # 8000108e <mappages>
    80001a78:	02054863          	bltz	a0,80001aa8 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001a7c:	4719                	li	a4,6
    80001a7e:	05893683          	ld	a3,88(s2)
    80001a82:	6605                	lui	a2,0x1
    80001a84:	020005b7          	lui	a1,0x2000
    80001a88:	15fd                	addi	a1,a1,-1
    80001a8a:	05b6                	slli	a1,a1,0xd
    80001a8c:	8526                	mv	a0,s1
    80001a8e:	fffff097          	auipc	ra,0xfffff
    80001a92:	600080e7          	jalr	1536(ra) # 8000108e <mappages>
    80001a96:	02054163          	bltz	a0,80001ab8 <proc_pagetable+0x76>
}
    80001a9a:	8526                	mv	a0,s1
    80001a9c:	60e2                	ld	ra,24(sp)
    80001a9e:	6442                	ld	s0,16(sp)
    80001aa0:	64a2                	ld	s1,8(sp)
    80001aa2:	6902                	ld	s2,0(sp)
    80001aa4:	6105                	addi	sp,sp,32
    80001aa6:	8082                	ret
    uvmfree(pagetable, 0);
    80001aa8:	4581                	li	a1,0
    80001aaa:	8526                	mv	a0,s1
    80001aac:	00000097          	auipc	ra,0x0
    80001ab0:	a56080e7          	jalr	-1450(ra) # 80001502 <uvmfree>
    return 0;
    80001ab4:	4481                	li	s1,0
    80001ab6:	b7d5                	j	80001a9a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ab8:	4681                	li	a3,0
    80001aba:	4605                	li	a2,1
    80001abc:	040005b7          	lui	a1,0x4000
    80001ac0:	15fd                	addi	a1,a1,-1
    80001ac2:	05b2                	slli	a1,a1,0xc
    80001ac4:	8526                	mv	a0,s1
    80001ac6:	fffff097          	auipc	ra,0xfffff
    80001aca:	77c080e7          	jalr	1916(ra) # 80001242 <uvmunmap>
    uvmfree(pagetable, 0);
    80001ace:	4581                	li	a1,0
    80001ad0:	8526                	mv	a0,s1
    80001ad2:	00000097          	auipc	ra,0x0
    80001ad6:	a30080e7          	jalr	-1488(ra) # 80001502 <uvmfree>
    return 0;
    80001ada:	4481                	li	s1,0
    80001adc:	bf7d                	j	80001a9a <proc_pagetable+0x58>

0000000080001ade <proc_freepagetable>:
{
    80001ade:	1101                	addi	sp,sp,-32
    80001ae0:	ec06                	sd	ra,24(sp)
    80001ae2:	e822                	sd	s0,16(sp)
    80001ae4:	e426                	sd	s1,8(sp)
    80001ae6:	e04a                	sd	s2,0(sp)
    80001ae8:	1000                	addi	s0,sp,32
    80001aea:	84aa                	mv	s1,a0
    80001aec:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001aee:	4681                	li	a3,0
    80001af0:	4605                	li	a2,1
    80001af2:	040005b7          	lui	a1,0x4000
    80001af6:	15fd                	addi	a1,a1,-1
    80001af8:	05b2                	slli	a1,a1,0xc
    80001afa:	fffff097          	auipc	ra,0xfffff
    80001afe:	748080e7          	jalr	1864(ra) # 80001242 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b02:	4681                	li	a3,0
    80001b04:	4605                	li	a2,1
    80001b06:	020005b7          	lui	a1,0x2000
    80001b0a:	15fd                	addi	a1,a1,-1
    80001b0c:	05b6                	slli	a1,a1,0xd
    80001b0e:	8526                	mv	a0,s1
    80001b10:	fffff097          	auipc	ra,0xfffff
    80001b14:	732080e7          	jalr	1842(ra) # 80001242 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b18:	85ca                	mv	a1,s2
    80001b1a:	8526                	mv	a0,s1
    80001b1c:	00000097          	auipc	ra,0x0
    80001b20:	9e6080e7          	jalr	-1562(ra) # 80001502 <uvmfree>
}
    80001b24:	60e2                	ld	ra,24(sp)
    80001b26:	6442                	ld	s0,16(sp)
    80001b28:	64a2                	ld	s1,8(sp)
    80001b2a:	6902                	ld	s2,0(sp)
    80001b2c:	6105                	addi	sp,sp,32
    80001b2e:	8082                	ret

0000000080001b30 <freeproc>:
{
    80001b30:	1101                	addi	sp,sp,-32
    80001b32:	ec06                	sd	ra,24(sp)
    80001b34:	e822                	sd	s0,16(sp)
    80001b36:	e426                	sd	s1,8(sp)
    80001b38:	1000                	addi	s0,sp,32
    80001b3a:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b3c:	6d28                	ld	a0,88(a0)
    80001b3e:	c509                	beqz	a0,80001b48 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b40:	fffff097          	auipc	ra,0xfffff
    80001b44:	e96080e7          	jalr	-362(ra) # 800009d6 <kfree>
  p->trapframe = 0;
    80001b48:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b4c:	68a8                	ld	a0,80(s1)
    80001b4e:	c511                	beqz	a0,80001b5a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b50:	64ac                	ld	a1,72(s1)
    80001b52:	00000097          	auipc	ra,0x0
    80001b56:	f8c080e7          	jalr	-116(ra) # 80001ade <proc_freepagetable>
  p->pagetable = 0;
    80001b5a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b5e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b62:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001b66:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001b6a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b6e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b72:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b76:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b7a:	0004ac23          	sw	zero,24(s1)
}
    80001b7e:	60e2                	ld	ra,24(sp)
    80001b80:	6442                	ld	s0,16(sp)
    80001b82:	64a2                	ld	s1,8(sp)
    80001b84:	6105                	addi	sp,sp,32
    80001b86:	8082                	ret

0000000080001b88 <allocproc>:
{
    80001b88:	7179                	addi	sp,sp,-48
    80001b8a:	f406                	sd	ra,40(sp)
    80001b8c:	f022                	sd	s0,32(sp)
    80001b8e:	ec26                	sd	s1,24(sp)
    80001b90:	e84a                	sd	s2,16(sp)
    80001b92:	e44e                	sd	s3,8(sp)
    80001b94:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b96:	00010497          	auipc	s1,0x10
    80001b9a:	b3a48493          	addi	s1,s1,-1222 # 800116d0 <proc>
    80001b9e:	00020997          	auipc	s3,0x20
    80001ba2:	33298993          	addi	s3,s3,818 # 80021ed0 <tickslock>
    acquire(&p->lock);
    80001ba6:	8526                	mv	a0,s1
    80001ba8:	fffff097          	auipc	ra,0xfffff
    80001bac:	01a080e7          	jalr	26(ra) # 80000bc2 <acquire>
    if(p->state == UNUSED) {
    80001bb0:	4c9c                	lw	a5,24(s1)
    80001bb2:	cf81                	beqz	a5,80001bca <allocproc+0x42>
      release(&p->lock);
    80001bb4:	8526                	mv	a0,s1
    80001bb6:	fffff097          	auipc	ra,0xfffff
    80001bba:	0c0080e7          	jalr	192(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bbe:	42048493          	addi	s1,s1,1056
    80001bc2:	ff3492e3          	bne	s1,s3,80001ba6 <allocproc+0x1e>
  return 0;
    80001bc6:	4481                	li	s1,0
    80001bc8:	a871                	j	80001c64 <allocproc+0xdc>
  p->pid = allocpid();
    80001bca:	00000097          	auipc	ra,0x0
    80001bce:	e32080e7          	jalr	-462(ra) # 800019fc <allocpid>
    80001bd2:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001bd4:	4785                	li	a5,1
    80001bd6:	cc9c                	sw	a5,24(s1)
  p->pendingSignals = 0;
    80001bd8:	1604a423          	sw	zero,360(s1)
  p->signalMask = 0;
    80001bdc:	1604a623          	sw	zero,364(s1)
  p->stopped = 0;
    80001be0:	3804a823          	sw	zero,912(s1)
  p->signal_mask_backup = 0;
    80001be4:	3804aa23          	sw	zero,916(s1)
  p->ignore_signals = 0;
    80001be8:	3804ac23          	sw	zero,920(s1)
  for(int i = 0; i<32 ; i++)
    80001bec:	17048793          	addi	a5,s1,368
    80001bf0:	27048713          	addi	a4,s1,624
    p->signalHandlers[i] = SIG_DFL;
    80001bf4:	0007b023          	sd	zero,0(a5)
  for(int i = 0; i<32 ; i++)
    80001bf8:	07a1                	addi	a5,a5,8
    80001bfa:	fee79de3          	bne	a5,a4,80001bf4 <allocproc+0x6c>
  memset(p->signalHandlers, SIG_DFL, sizeof(p->signalHandlers));
    80001bfe:	10000613          	li	a2,256
    80001c02:	4581                	li	a1,0
    80001c04:	17048513          	addi	a0,s1,368
    80001c08:	fffff097          	auipc	ra,0xfffff
    80001c0c:	0b6080e7          	jalr	182(ra) # 80000cbe <memset>
  memset(p->maskHandlers, 0, sizeof(p->maskHandlers));
    80001c10:	08000613          	li	a2,128
    80001c14:	4581                	li	a1,0
    80001c16:	39c48513          	addi	a0,s1,924
    80001c1a:	fffff097          	auipc	ra,0xfffff
    80001c1e:	0a4080e7          	jalr	164(ra) # 80000cbe <memset>
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c22:	fffff097          	auipc	ra,0xfffff
    80001c26:	eb0080e7          	jalr	-336(ra) # 80000ad2 <kalloc>
    80001c2a:	892a                	mv	s2,a0
    80001c2c:	eca8                	sd	a0,88(s1)
    80001c2e:	c139                	beqz	a0,80001c74 <allocproc+0xec>
  p->pagetable = proc_pagetable(p);
    80001c30:	8526                	mv	a0,s1
    80001c32:	00000097          	auipc	ra,0x0
    80001c36:	e10080e7          	jalr	-496(ra) # 80001a42 <proc_pagetable>
    80001c3a:	892a                	mv	s2,a0
    80001c3c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c3e:	c539                	beqz	a0,80001c8c <allocproc+0x104>
  memset(&p->context, 0, sizeof(p->context));
    80001c40:	07000613          	li	a2,112
    80001c44:	4581                	li	a1,0
    80001c46:	06048513          	addi	a0,s1,96
    80001c4a:	fffff097          	auipc	ra,0xfffff
    80001c4e:	074080e7          	jalr	116(ra) # 80000cbe <memset>
  p->context.ra = (uint64)forkret;
    80001c52:	00000797          	auipc	a5,0x0
    80001c56:	d6478793          	addi	a5,a5,-668 # 800019b6 <forkret>
    80001c5a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c5c:	60bc                	ld	a5,64(s1)
    80001c5e:	6705                	lui	a4,0x1
    80001c60:	97ba                	add	a5,a5,a4
    80001c62:	f4bc                	sd	a5,104(s1)
}
    80001c64:	8526                	mv	a0,s1
    80001c66:	70a2                	ld	ra,40(sp)
    80001c68:	7402                	ld	s0,32(sp)
    80001c6a:	64e2                	ld	s1,24(sp)
    80001c6c:	6942                	ld	s2,16(sp)
    80001c6e:	69a2                	ld	s3,8(sp)
    80001c70:	6145                	addi	sp,sp,48
    80001c72:	8082                	ret
    freeproc(p);
    80001c74:	8526                	mv	a0,s1
    80001c76:	00000097          	auipc	ra,0x0
    80001c7a:	eba080e7          	jalr	-326(ra) # 80001b30 <freeproc>
    release(&p->lock);
    80001c7e:	8526                	mv	a0,s1
    80001c80:	fffff097          	auipc	ra,0xfffff
    80001c84:	ff6080e7          	jalr	-10(ra) # 80000c76 <release>
    return 0;
    80001c88:	84ca                	mv	s1,s2
    80001c8a:	bfe9                	j	80001c64 <allocproc+0xdc>
    freeproc(p);
    80001c8c:	8526                	mv	a0,s1
    80001c8e:	00000097          	auipc	ra,0x0
    80001c92:	ea2080e7          	jalr	-350(ra) # 80001b30 <freeproc>
    release(&p->lock);
    80001c96:	8526                	mv	a0,s1
    80001c98:	fffff097          	auipc	ra,0xfffff
    80001c9c:	fde080e7          	jalr	-34(ra) # 80000c76 <release>
    return 0;
    80001ca0:	84ca                	mv	s1,s2
    80001ca2:	b7c9                	j	80001c64 <allocproc+0xdc>

0000000080001ca4 <userinit>:
{
    80001ca4:	1101                	addi	sp,sp,-32
    80001ca6:	ec06                	sd	ra,24(sp)
    80001ca8:	e822                	sd	s0,16(sp)
    80001caa:	e426                	sd	s1,8(sp)
    80001cac:	1000                	addi	s0,sp,32
  p = allocproc();
    80001cae:	00000097          	auipc	ra,0x0
    80001cb2:	eda080e7          	jalr	-294(ra) # 80001b88 <allocproc>
    80001cb6:	84aa                	mv	s1,a0
  initproc = p;
    80001cb8:	00007797          	auipc	a5,0x7
    80001cbc:	36a7b823          	sd	a0,880(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001cc0:	03400613          	li	a2,52
    80001cc4:	00007597          	auipc	a1,0x7
    80001cc8:	bac58593          	addi	a1,a1,-1108 # 80008870 <initcode>
    80001ccc:	6928                	ld	a0,80(a0)
    80001cce:	fffff097          	auipc	ra,0xfffff
    80001cd2:	666080e7          	jalr	1638(ra) # 80001334 <uvminit>
  p->sz = PGSIZE;
    80001cd6:	6785                	lui	a5,0x1
    80001cd8:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001cda:	6cb8                	ld	a4,88(s1)
    80001cdc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001ce0:	6cb8                	ld	a4,88(s1)
    80001ce2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001ce4:	4641                	li	a2,16
    80001ce6:	00006597          	auipc	a1,0x6
    80001cea:	50258593          	addi	a1,a1,1282 # 800081e8 <digits+0x1a8>
    80001cee:	15848513          	addi	a0,s1,344
    80001cf2:	fffff097          	auipc	ra,0xfffff
    80001cf6:	11e080e7          	jalr	286(ra) # 80000e10 <safestrcpy>
  p->cwd = namei("/");
    80001cfa:	00006517          	auipc	a0,0x6
    80001cfe:	4fe50513          	addi	a0,a0,1278 # 800081f8 <digits+0x1b8>
    80001d02:	00002097          	auipc	ra,0x2
    80001d06:	568080e7          	jalr	1384(ra) # 8000426a <namei>
    80001d0a:	14a4b823          	sd	a0,336(s1)
  p->pendingSignals = 0;
    80001d0e:	1604a423          	sw	zero,360(s1)
  p->signalMask = 0;
    80001d12:	1604a623          	sw	zero,364(s1)
  for (int i = 0; i < 32; i++) {
    80001d16:	17048793          	addi	a5,s1,368
    80001d1a:	27048713          	addi	a4,s1,624
    p->signalHandlers[i] = SIG_DFL;
    80001d1e:	0007b023          	sd	zero,0(a5) # 1000 <_entry-0x7ffff000>
  for (int i = 0; i < 32; i++) {
    80001d22:	07a1                	addi	a5,a5,8
    80001d24:	fee79de3          	bne	a5,a4,80001d1e <userinit+0x7a>
  p->ignore_signals = 0;
    80001d28:	3804ac23          	sw	zero,920(s1)
  p->stopped = 0;
    80001d2c:	3804a823          	sw	zero,912(s1)
  p->state = RUNNABLE;
    80001d30:	478d                	li	a5,3
    80001d32:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d34:	8526                	mv	a0,s1
    80001d36:	fffff097          	auipc	ra,0xfffff
    80001d3a:	f40080e7          	jalr	-192(ra) # 80000c76 <release>
}
    80001d3e:	60e2                	ld	ra,24(sp)
    80001d40:	6442                	ld	s0,16(sp)
    80001d42:	64a2                	ld	s1,8(sp)
    80001d44:	6105                	addi	sp,sp,32
    80001d46:	8082                	ret

0000000080001d48 <growproc>:
{
    80001d48:	1101                	addi	sp,sp,-32
    80001d4a:	ec06                	sd	ra,24(sp)
    80001d4c:	e822                	sd	s0,16(sp)
    80001d4e:	e426                	sd	s1,8(sp)
    80001d50:	e04a                	sd	s2,0(sp)
    80001d52:	1000                	addi	s0,sp,32
    80001d54:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d56:	00000097          	auipc	ra,0x0
    80001d5a:	c28080e7          	jalr	-984(ra) # 8000197e <myproc>
    80001d5e:	892a                	mv	s2,a0
  sz = p->sz;
    80001d60:	652c                	ld	a1,72(a0)
    80001d62:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001d66:	00904f63          	bgtz	s1,80001d84 <growproc+0x3c>
  } else if(n < 0){
    80001d6a:	0204cc63          	bltz	s1,80001da2 <growproc+0x5a>
  p->sz = sz;
    80001d6e:	1602                	slli	a2,a2,0x20
    80001d70:	9201                	srli	a2,a2,0x20
    80001d72:	04c93423          	sd	a2,72(s2)
  return 0;
    80001d76:	4501                	li	a0,0
}
    80001d78:	60e2                	ld	ra,24(sp)
    80001d7a:	6442                	ld	s0,16(sp)
    80001d7c:	64a2                	ld	s1,8(sp)
    80001d7e:	6902                	ld	s2,0(sp)
    80001d80:	6105                	addi	sp,sp,32
    80001d82:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001d84:	9e25                	addw	a2,a2,s1
    80001d86:	1602                	slli	a2,a2,0x20
    80001d88:	9201                	srli	a2,a2,0x20
    80001d8a:	1582                	slli	a1,a1,0x20
    80001d8c:	9181                	srli	a1,a1,0x20
    80001d8e:	6928                	ld	a0,80(a0)
    80001d90:	fffff097          	auipc	ra,0xfffff
    80001d94:	65e080e7          	jalr	1630(ra) # 800013ee <uvmalloc>
    80001d98:	0005061b          	sext.w	a2,a0
    80001d9c:	fa69                	bnez	a2,80001d6e <growproc+0x26>
      return -1;
    80001d9e:	557d                	li	a0,-1
    80001da0:	bfe1                	j	80001d78 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001da2:	9e25                	addw	a2,a2,s1
    80001da4:	1602                	slli	a2,a2,0x20
    80001da6:	9201                	srli	a2,a2,0x20
    80001da8:	1582                	slli	a1,a1,0x20
    80001daa:	9181                	srli	a1,a1,0x20
    80001dac:	6928                	ld	a0,80(a0)
    80001dae:	fffff097          	auipc	ra,0xfffff
    80001db2:	5f8080e7          	jalr	1528(ra) # 800013a6 <uvmdealloc>
    80001db6:	0005061b          	sext.w	a2,a0
    80001dba:	bf55                	j	80001d6e <growproc+0x26>

0000000080001dbc <fork>:
{
    80001dbc:	7139                	addi	sp,sp,-64
    80001dbe:	fc06                	sd	ra,56(sp)
    80001dc0:	f822                	sd	s0,48(sp)
    80001dc2:	f426                	sd	s1,40(sp)
    80001dc4:	f04a                	sd	s2,32(sp)
    80001dc6:	ec4e                	sd	s3,24(sp)
    80001dc8:	e852                	sd	s4,16(sp)
    80001dca:	e456                	sd	s5,8(sp)
    80001dcc:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001dce:	00000097          	auipc	ra,0x0
    80001dd2:	bb0080e7          	jalr	-1104(ra) # 8000197e <myproc>
    80001dd6:	8a2a                	mv	s4,a0
  if((np = allocproc()) == 0){
    80001dd8:	00000097          	auipc	ra,0x0
    80001ddc:	db0080e7          	jalr	-592(ra) # 80001b88 <allocproc>
    80001de0:	14050663          	beqz	a0,80001f2c <fork+0x170>
    80001de4:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001de6:	048a3603          	ld	a2,72(s4)
    80001dea:	692c                	ld	a1,80(a0)
    80001dec:	050a3503          	ld	a0,80(s4)
    80001df0:	fffff097          	auipc	ra,0xfffff
    80001df4:	74a080e7          	jalr	1866(ra) # 8000153a <uvmcopy>
    80001df8:	06054863          	bltz	a0,80001e68 <fork+0xac>
  np->sz = p->sz;
    80001dfc:	048a3783          	ld	a5,72(s4)
    80001e00:	04f9b423          	sd	a5,72(s3)
  np->signalMask = p->signalMask; //inherit signal mask from parent
    80001e04:	16ca2783          	lw	a5,364(s4)
    80001e08:	16f9a623          	sw	a5,364(s3)
  for (int i = 0; i<32; i++) //inherit signal handlers from parent
    80001e0c:	170a0793          	addi	a5,s4,368
    80001e10:	17098713          	addi	a4,s3,368
    80001e14:	270a0613          	addi	a2,s4,624
    np->signalHandlers[i] = p->signalHandlers[i]; 
    80001e18:	6394                	ld	a3,0(a5)
    80001e1a:	e314                	sd	a3,0(a4)
  for (int i = 0; i<32; i++) //inherit signal handlers from parent
    80001e1c:	07a1                	addi	a5,a5,8
    80001e1e:	0721                	addi	a4,a4,8
    80001e20:	fec79ce3          	bne	a5,a2,80001e18 <fork+0x5c>
  *(np->trapframe) = *(p->trapframe);
    80001e24:	058a3683          	ld	a3,88(s4)
    80001e28:	87b6                	mv	a5,a3
    80001e2a:	0589b703          	ld	a4,88(s3)
    80001e2e:	12068693          	addi	a3,a3,288
    80001e32:	0007b803          	ld	a6,0(a5)
    80001e36:	6788                	ld	a0,8(a5)
    80001e38:	6b8c                	ld	a1,16(a5)
    80001e3a:	6f90                	ld	a2,24(a5)
    80001e3c:	01073023          	sd	a6,0(a4)
    80001e40:	e708                	sd	a0,8(a4)
    80001e42:	eb0c                	sd	a1,16(a4)
    80001e44:	ef10                	sd	a2,24(a4)
    80001e46:	02078793          	addi	a5,a5,32
    80001e4a:	02070713          	addi	a4,a4,32
    80001e4e:	fed792e3          	bne	a5,a3,80001e32 <fork+0x76>
  np->trapframe->a0 = 0;
    80001e52:	0589b783          	ld	a5,88(s3)
    80001e56:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e5a:	0d0a0493          	addi	s1,s4,208
    80001e5e:	0d098913          	addi	s2,s3,208
    80001e62:	150a0a93          	addi	s5,s4,336
    80001e66:	a00d                	j	80001e88 <fork+0xcc>
    freeproc(np);
    80001e68:	854e                	mv	a0,s3
    80001e6a:	00000097          	auipc	ra,0x0
    80001e6e:	cc6080e7          	jalr	-826(ra) # 80001b30 <freeproc>
    release(&np->lock);
    80001e72:	854e                	mv	a0,s3
    80001e74:	fffff097          	auipc	ra,0xfffff
    80001e78:	e02080e7          	jalr	-510(ra) # 80000c76 <release>
    return -1;
    80001e7c:	597d                	li	s2,-1
    80001e7e:	a869                	j	80001f18 <fork+0x15c>
  for(i = 0; i < NOFILE; i++)
    80001e80:	04a1                	addi	s1,s1,8
    80001e82:	0921                	addi	s2,s2,8
    80001e84:	01548b63          	beq	s1,s5,80001e9a <fork+0xde>
    if(p->ofile[i])
    80001e88:	6088                	ld	a0,0(s1)
    80001e8a:	d97d                	beqz	a0,80001e80 <fork+0xc4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e8c:	00003097          	auipc	ra,0x3
    80001e90:	a78080e7          	jalr	-1416(ra) # 80004904 <filedup>
    80001e94:	00a93023          	sd	a0,0(s2)
    80001e98:	b7e5                	j	80001e80 <fork+0xc4>
  np->cwd = idup(p->cwd);
    80001e9a:	150a3503          	ld	a0,336(s4)
    80001e9e:	00002097          	auipc	ra,0x2
    80001ea2:	bd8080e7          	jalr	-1064(ra) # 80003a76 <idup>
    80001ea6:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001eaa:	4641                	li	a2,16
    80001eac:	158a0593          	addi	a1,s4,344
    80001eb0:	15898513          	addi	a0,s3,344
    80001eb4:	fffff097          	auipc	ra,0xfffff
    80001eb8:	f5c080e7          	jalr	-164(ra) # 80000e10 <safestrcpy>
  pid = np->pid;
    80001ebc:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001ec0:	854e                	mv	a0,s3
    80001ec2:	fffff097          	auipc	ra,0xfffff
    80001ec6:	db4080e7          	jalr	-588(ra) # 80000c76 <release>
  acquire(&wait_lock);
    80001eca:	0000f497          	auipc	s1,0xf
    80001ece:	3ee48493          	addi	s1,s1,1006 # 800112b8 <wait_lock>
    80001ed2:	8526                	mv	a0,s1
    80001ed4:	fffff097          	auipc	ra,0xfffff
    80001ed8:	cee080e7          	jalr	-786(ra) # 80000bc2 <acquire>
  np->parent = p;
    80001edc:	0349bc23          	sd	s4,56(s3)
  release(&wait_lock);
    80001ee0:	8526                	mv	a0,s1
    80001ee2:	fffff097          	auipc	ra,0xfffff
    80001ee6:	d94080e7          	jalr	-620(ra) # 80000c76 <release>
  acquire(&np->lock);
    80001eea:	854e                	mv	a0,s3
    80001eec:	fffff097          	auipc	ra,0xfffff
    80001ef0:	cd6080e7          	jalr	-810(ra) # 80000bc2 <acquire>
  np->pendingSignals = 0;
    80001ef4:	1609a423          	sw	zero,360(s3)
  np->signalMask = p->signalMask;
    80001ef8:	16ca2783          	lw	a5,364(s4)
    80001efc:	16f9a623          	sw	a5,364(s3)
  np->ignore_signals = 0;
    80001f00:	3809ac23          	sw	zero,920(s3)
  np->stopped = 0;
    80001f04:	3809a823          	sw	zero,912(s3)
  np->state = RUNNABLE;
    80001f08:	478d                	li	a5,3
    80001f0a:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001f0e:	854e                	mv	a0,s3
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	d66080e7          	jalr	-666(ra) # 80000c76 <release>
}
    80001f18:	854a                	mv	a0,s2
    80001f1a:	70e2                	ld	ra,56(sp)
    80001f1c:	7442                	ld	s0,48(sp)
    80001f1e:	74a2                	ld	s1,40(sp)
    80001f20:	7902                	ld	s2,32(sp)
    80001f22:	69e2                	ld	s3,24(sp)
    80001f24:	6a42                	ld	s4,16(sp)
    80001f26:	6aa2                	ld	s5,8(sp)
    80001f28:	6121                	addi	sp,sp,64
    80001f2a:	8082                	ret
    return -1;
    80001f2c:	597d                	li	s2,-1
    80001f2e:	b7ed                	j	80001f18 <fork+0x15c>

0000000080001f30 <scheduler>:
{
    80001f30:	7139                	addi	sp,sp,-64
    80001f32:	fc06                	sd	ra,56(sp)
    80001f34:	f822                	sd	s0,48(sp)
    80001f36:	f426                	sd	s1,40(sp)
    80001f38:	f04a                	sd	s2,32(sp)
    80001f3a:	ec4e                	sd	s3,24(sp)
    80001f3c:	e852                	sd	s4,16(sp)
    80001f3e:	e456                	sd	s5,8(sp)
    80001f40:	e05a                	sd	s6,0(sp)
    80001f42:	0080                	addi	s0,sp,64
    80001f44:	8792                	mv	a5,tp
  int id = r_tp();
    80001f46:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f48:	00779a93          	slli	s5,a5,0x7
    80001f4c:	0000f717          	auipc	a4,0xf
    80001f50:	35470713          	addi	a4,a4,852 # 800112a0 <pid_lock>
    80001f54:	9756                	add	a4,a4,s5
    80001f56:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001f5a:	0000f717          	auipc	a4,0xf
    80001f5e:	37e70713          	addi	a4,a4,894 # 800112d8 <cpus+0x8>
    80001f62:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001f64:	498d                	li	s3,3
        p->state = RUNNING;
    80001f66:	4b11                	li	s6,4
        c->proc = p;
    80001f68:	079e                	slli	a5,a5,0x7
    80001f6a:	0000fa17          	auipc	s4,0xf
    80001f6e:	336a0a13          	addi	s4,s4,822 # 800112a0 <pid_lock>
    80001f72:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f74:	00020917          	auipc	s2,0x20
    80001f78:	f5c90913          	addi	s2,s2,-164 # 80021ed0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f80:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f84:	10079073          	csrw	sstatus,a5
    80001f88:	0000f497          	auipc	s1,0xf
    80001f8c:	74848493          	addi	s1,s1,1864 # 800116d0 <proc>
    80001f90:	a811                	j	80001fa4 <scheduler+0x74>
      release(&p->lock);
    80001f92:	8526                	mv	a0,s1
    80001f94:	fffff097          	auipc	ra,0xfffff
    80001f98:	ce2080e7          	jalr	-798(ra) # 80000c76 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f9c:	42048493          	addi	s1,s1,1056
    80001fa0:	fd248ee3          	beq	s1,s2,80001f7c <scheduler+0x4c>
      acquire(&p->lock);
    80001fa4:	8526                	mv	a0,s1
    80001fa6:	fffff097          	auipc	ra,0xfffff
    80001faa:	c1c080e7          	jalr	-996(ra) # 80000bc2 <acquire>
      if(p->state == RUNNABLE) {
    80001fae:	4c9c                	lw	a5,24(s1)
    80001fb0:	ff3791e3          	bne	a5,s3,80001f92 <scheduler+0x62>
        p->state = RUNNING;
    80001fb4:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001fb8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001fbc:	06048593          	addi	a1,s1,96
    80001fc0:	8556                	mv	a0,s5
    80001fc2:	00001097          	auipc	ra,0x1
    80001fc6:	9b2080e7          	jalr	-1614(ra) # 80002974 <swtch>
        c->proc = 0;
    80001fca:	020a3823          	sd	zero,48(s4)
    80001fce:	b7d1                	j	80001f92 <scheduler+0x62>

0000000080001fd0 <sched>:
{
    80001fd0:	7179                	addi	sp,sp,-48
    80001fd2:	f406                	sd	ra,40(sp)
    80001fd4:	f022                	sd	s0,32(sp)
    80001fd6:	ec26                	sd	s1,24(sp)
    80001fd8:	e84a                	sd	s2,16(sp)
    80001fda:	e44e                	sd	s3,8(sp)
    80001fdc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001fde:	00000097          	auipc	ra,0x0
    80001fe2:	9a0080e7          	jalr	-1632(ra) # 8000197e <myproc>
    80001fe6:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001fe8:	fffff097          	auipc	ra,0xfffff
    80001fec:	b60080e7          	jalr	-1184(ra) # 80000b48 <holding>
    80001ff0:	c93d                	beqz	a0,80002066 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ff2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001ff4:	2781                	sext.w	a5,a5
    80001ff6:	079e                	slli	a5,a5,0x7
    80001ff8:	0000f717          	auipc	a4,0xf
    80001ffc:	2a870713          	addi	a4,a4,680 # 800112a0 <pid_lock>
    80002000:	97ba                	add	a5,a5,a4
    80002002:	0a87a703          	lw	a4,168(a5)
    80002006:	4785                	li	a5,1
    80002008:	06f71763          	bne	a4,a5,80002076 <sched+0xa6>
  if(p->state == RUNNING)
    8000200c:	4c98                	lw	a4,24(s1)
    8000200e:	4791                	li	a5,4
    80002010:	06f70b63          	beq	a4,a5,80002086 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002014:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002018:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000201a:	efb5                	bnez	a5,80002096 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000201c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000201e:	0000f917          	auipc	s2,0xf
    80002022:	28290913          	addi	s2,s2,642 # 800112a0 <pid_lock>
    80002026:	2781                	sext.w	a5,a5
    80002028:	079e                	slli	a5,a5,0x7
    8000202a:	97ca                	add	a5,a5,s2
    8000202c:	0ac7a983          	lw	s3,172(a5)
    80002030:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002032:	2781                	sext.w	a5,a5
    80002034:	079e                	slli	a5,a5,0x7
    80002036:	0000f597          	auipc	a1,0xf
    8000203a:	2a258593          	addi	a1,a1,674 # 800112d8 <cpus+0x8>
    8000203e:	95be                	add	a1,a1,a5
    80002040:	06048513          	addi	a0,s1,96
    80002044:	00001097          	auipc	ra,0x1
    80002048:	930080e7          	jalr	-1744(ra) # 80002974 <swtch>
    8000204c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000204e:	2781                	sext.w	a5,a5
    80002050:	079e                	slli	a5,a5,0x7
    80002052:	97ca                	add	a5,a5,s2
    80002054:	0b37a623          	sw	s3,172(a5)
}
    80002058:	70a2                	ld	ra,40(sp)
    8000205a:	7402                	ld	s0,32(sp)
    8000205c:	64e2                	ld	s1,24(sp)
    8000205e:	6942                	ld	s2,16(sp)
    80002060:	69a2                	ld	s3,8(sp)
    80002062:	6145                	addi	sp,sp,48
    80002064:	8082                	ret
    panic("sched p->lock");
    80002066:	00006517          	auipc	a0,0x6
    8000206a:	19a50513          	addi	a0,a0,410 # 80008200 <digits+0x1c0>
    8000206e:	ffffe097          	auipc	ra,0xffffe
    80002072:	4bc080e7          	jalr	1212(ra) # 8000052a <panic>
    panic("sched locks");
    80002076:	00006517          	auipc	a0,0x6
    8000207a:	19a50513          	addi	a0,a0,410 # 80008210 <digits+0x1d0>
    8000207e:	ffffe097          	auipc	ra,0xffffe
    80002082:	4ac080e7          	jalr	1196(ra) # 8000052a <panic>
    panic("sched running");
    80002086:	00006517          	auipc	a0,0x6
    8000208a:	19a50513          	addi	a0,a0,410 # 80008220 <digits+0x1e0>
    8000208e:	ffffe097          	auipc	ra,0xffffe
    80002092:	49c080e7          	jalr	1180(ra) # 8000052a <panic>
    panic("sched interruptible");
    80002096:	00006517          	auipc	a0,0x6
    8000209a:	19a50513          	addi	a0,a0,410 # 80008230 <digits+0x1f0>
    8000209e:	ffffe097          	auipc	ra,0xffffe
    800020a2:	48c080e7          	jalr	1164(ra) # 8000052a <panic>

00000000800020a6 <yield>:
{
    800020a6:	1101                	addi	sp,sp,-32
    800020a8:	ec06                	sd	ra,24(sp)
    800020aa:	e822                	sd	s0,16(sp)
    800020ac:	e426                	sd	s1,8(sp)
    800020ae:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800020b0:	00000097          	auipc	ra,0x0
    800020b4:	8ce080e7          	jalr	-1842(ra) # 8000197e <myproc>
    800020b8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020ba:	fffff097          	auipc	ra,0xfffff
    800020be:	b08080e7          	jalr	-1272(ra) # 80000bc2 <acquire>
  p->state = RUNNABLE;
    800020c2:	478d                	li	a5,3
    800020c4:	cc9c                	sw	a5,24(s1)
  sched();
    800020c6:	00000097          	auipc	ra,0x0
    800020ca:	f0a080e7          	jalr	-246(ra) # 80001fd0 <sched>
  release(&p->lock);
    800020ce:	8526                	mv	a0,s1
    800020d0:	fffff097          	auipc	ra,0xfffff
    800020d4:	ba6080e7          	jalr	-1114(ra) # 80000c76 <release>
}
    800020d8:	60e2                	ld	ra,24(sp)
    800020da:	6442                	ld	s0,16(sp)
    800020dc:	64a2                	ld	s1,8(sp)
    800020de:	6105                	addi	sp,sp,32
    800020e0:	8082                	ret

00000000800020e2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800020e2:	7179                	addi	sp,sp,-48
    800020e4:	f406                	sd	ra,40(sp)
    800020e6:	f022                	sd	s0,32(sp)
    800020e8:	ec26                	sd	s1,24(sp)
    800020ea:	e84a                	sd	s2,16(sp)
    800020ec:	e44e                	sd	s3,8(sp)
    800020ee:	1800                	addi	s0,sp,48
    800020f0:	89aa                	mv	s3,a0
    800020f2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020f4:	00000097          	auipc	ra,0x0
    800020f8:	88a080e7          	jalr	-1910(ra) # 8000197e <myproc>
    800020fc:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800020fe:	fffff097          	auipc	ra,0xfffff
    80002102:	ac4080e7          	jalr	-1340(ra) # 80000bc2 <acquire>
  release(lk);
    80002106:	854a                	mv	a0,s2
    80002108:	fffff097          	auipc	ra,0xfffff
    8000210c:	b6e080e7          	jalr	-1170(ra) # 80000c76 <release>

  // Go to sleep.
  p->chan = chan;
    80002110:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002114:	4789                	li	a5,2
    80002116:	cc9c                	sw	a5,24(s1)

  sched();
    80002118:	00000097          	auipc	ra,0x0
    8000211c:	eb8080e7          	jalr	-328(ra) # 80001fd0 <sched>

  // Tidy up.
  p->chan = 0;
    80002120:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002124:	8526                	mv	a0,s1
    80002126:	fffff097          	auipc	ra,0xfffff
    8000212a:	b50080e7          	jalr	-1200(ra) # 80000c76 <release>
  acquire(lk);
    8000212e:	854a                	mv	a0,s2
    80002130:	fffff097          	auipc	ra,0xfffff
    80002134:	a92080e7          	jalr	-1390(ra) # 80000bc2 <acquire>
}
    80002138:	70a2                	ld	ra,40(sp)
    8000213a:	7402                	ld	s0,32(sp)
    8000213c:	64e2                	ld	s1,24(sp)
    8000213e:	6942                	ld	s2,16(sp)
    80002140:	69a2                	ld	s3,8(sp)
    80002142:	6145                	addi	sp,sp,48
    80002144:	8082                	ret

0000000080002146 <wait>:
{
    80002146:	715d                	addi	sp,sp,-80
    80002148:	e486                	sd	ra,72(sp)
    8000214a:	e0a2                	sd	s0,64(sp)
    8000214c:	fc26                	sd	s1,56(sp)
    8000214e:	f84a                	sd	s2,48(sp)
    80002150:	f44e                	sd	s3,40(sp)
    80002152:	f052                	sd	s4,32(sp)
    80002154:	ec56                	sd	s5,24(sp)
    80002156:	e85a                	sd	s6,16(sp)
    80002158:	e45e                	sd	s7,8(sp)
    8000215a:	e062                	sd	s8,0(sp)
    8000215c:	0880                	addi	s0,sp,80
    8000215e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002160:	00000097          	auipc	ra,0x0
    80002164:	81e080e7          	jalr	-2018(ra) # 8000197e <myproc>
    80002168:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000216a:	0000f517          	auipc	a0,0xf
    8000216e:	14e50513          	addi	a0,a0,334 # 800112b8 <wait_lock>
    80002172:	fffff097          	auipc	ra,0xfffff
    80002176:	a50080e7          	jalr	-1456(ra) # 80000bc2 <acquire>
    havekids = 0;
    8000217a:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000217c:	4a15                	li	s4,5
        havekids = 1;
    8000217e:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80002180:	00020997          	auipc	s3,0x20
    80002184:	d5098993          	addi	s3,s3,-688 # 80021ed0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002188:	0000fc17          	auipc	s8,0xf
    8000218c:	130c0c13          	addi	s8,s8,304 # 800112b8 <wait_lock>
    havekids = 0;
    80002190:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002192:	0000f497          	auipc	s1,0xf
    80002196:	53e48493          	addi	s1,s1,1342 # 800116d0 <proc>
    8000219a:	a0bd                	j	80002208 <wait+0xc2>
          pid = np->pid;
    8000219c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800021a0:	000b0e63          	beqz	s6,800021bc <wait+0x76>
    800021a4:	4691                	li	a3,4
    800021a6:	02c48613          	addi	a2,s1,44
    800021aa:	85da                	mv	a1,s6
    800021ac:	05093503          	ld	a0,80(s2)
    800021b0:	fffff097          	auipc	ra,0xfffff
    800021b4:	48e080e7          	jalr	1166(ra) # 8000163e <copyout>
    800021b8:	02054563          	bltz	a0,800021e2 <wait+0x9c>
          freeproc(np);
    800021bc:	8526                	mv	a0,s1
    800021be:	00000097          	auipc	ra,0x0
    800021c2:	972080e7          	jalr	-1678(ra) # 80001b30 <freeproc>
          release(&np->lock);
    800021c6:	8526                	mv	a0,s1
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	aae080e7          	jalr	-1362(ra) # 80000c76 <release>
          release(&wait_lock);
    800021d0:	0000f517          	auipc	a0,0xf
    800021d4:	0e850513          	addi	a0,a0,232 # 800112b8 <wait_lock>
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	a9e080e7          	jalr	-1378(ra) # 80000c76 <release>
          return pid;
    800021e0:	a09d                	j	80002246 <wait+0x100>
            release(&np->lock);
    800021e2:	8526                	mv	a0,s1
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	a92080e7          	jalr	-1390(ra) # 80000c76 <release>
            release(&wait_lock);
    800021ec:	0000f517          	auipc	a0,0xf
    800021f0:	0cc50513          	addi	a0,a0,204 # 800112b8 <wait_lock>
    800021f4:	fffff097          	auipc	ra,0xfffff
    800021f8:	a82080e7          	jalr	-1406(ra) # 80000c76 <release>
            return -1;
    800021fc:	59fd                	li	s3,-1
    800021fe:	a0a1                	j	80002246 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80002200:	42048493          	addi	s1,s1,1056
    80002204:	03348463          	beq	s1,s3,8000222c <wait+0xe6>
      if(np->parent == p){
    80002208:	7c9c                	ld	a5,56(s1)
    8000220a:	ff279be3          	bne	a5,s2,80002200 <wait+0xba>
        acquire(&np->lock);
    8000220e:	8526                	mv	a0,s1
    80002210:	fffff097          	auipc	ra,0xfffff
    80002214:	9b2080e7          	jalr	-1614(ra) # 80000bc2 <acquire>
        if(np->state == ZOMBIE){
    80002218:	4c9c                	lw	a5,24(s1)
    8000221a:	f94781e3          	beq	a5,s4,8000219c <wait+0x56>
        release(&np->lock);
    8000221e:	8526                	mv	a0,s1
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	a56080e7          	jalr	-1450(ra) # 80000c76 <release>
        havekids = 1;
    80002228:	8756                	mv	a4,s5
    8000222a:	bfd9                	j	80002200 <wait+0xba>
    if(!havekids || p->killed){
    8000222c:	c701                	beqz	a4,80002234 <wait+0xee>
    8000222e:	02892783          	lw	a5,40(s2)
    80002232:	c79d                	beqz	a5,80002260 <wait+0x11a>
      release(&wait_lock);
    80002234:	0000f517          	auipc	a0,0xf
    80002238:	08450513          	addi	a0,a0,132 # 800112b8 <wait_lock>
    8000223c:	fffff097          	auipc	ra,0xfffff
    80002240:	a3a080e7          	jalr	-1478(ra) # 80000c76 <release>
      return -1;
    80002244:	59fd                	li	s3,-1
}
    80002246:	854e                	mv	a0,s3
    80002248:	60a6                	ld	ra,72(sp)
    8000224a:	6406                	ld	s0,64(sp)
    8000224c:	74e2                	ld	s1,56(sp)
    8000224e:	7942                	ld	s2,48(sp)
    80002250:	79a2                	ld	s3,40(sp)
    80002252:	7a02                	ld	s4,32(sp)
    80002254:	6ae2                	ld	s5,24(sp)
    80002256:	6b42                	ld	s6,16(sp)
    80002258:	6ba2                	ld	s7,8(sp)
    8000225a:	6c02                	ld	s8,0(sp)
    8000225c:	6161                	addi	sp,sp,80
    8000225e:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002260:	85e2                	mv	a1,s8
    80002262:	854a                	mv	a0,s2
    80002264:	00000097          	auipc	ra,0x0
    80002268:	e7e080e7          	jalr	-386(ra) # 800020e2 <sleep>
    havekids = 0;
    8000226c:	b715                	j	80002190 <wait+0x4a>

000000008000226e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000226e:	7139                	addi	sp,sp,-64
    80002270:	fc06                	sd	ra,56(sp)
    80002272:	f822                	sd	s0,48(sp)
    80002274:	f426                	sd	s1,40(sp)
    80002276:	f04a                	sd	s2,32(sp)
    80002278:	ec4e                	sd	s3,24(sp)
    8000227a:	e852                	sd	s4,16(sp)
    8000227c:	e456                	sd	s5,8(sp)
    8000227e:	0080                	addi	s0,sp,64
    80002280:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002282:	0000f497          	auipc	s1,0xf
    80002286:	44e48493          	addi	s1,s1,1102 # 800116d0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000228a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000228c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000228e:	00020917          	auipc	s2,0x20
    80002292:	c4290913          	addi	s2,s2,-958 # 80021ed0 <tickslock>
    80002296:	a811                	j	800022aa <wakeup+0x3c>
      }
      release(&p->lock);
    80002298:	8526                	mv	a0,s1
    8000229a:	fffff097          	auipc	ra,0xfffff
    8000229e:	9dc080e7          	jalr	-1572(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800022a2:	42048493          	addi	s1,s1,1056
    800022a6:	03248663          	beq	s1,s2,800022d2 <wakeup+0x64>
    if(p != myproc()){
    800022aa:	fffff097          	auipc	ra,0xfffff
    800022ae:	6d4080e7          	jalr	1748(ra) # 8000197e <myproc>
    800022b2:	fea488e3          	beq	s1,a0,800022a2 <wakeup+0x34>
      acquire(&p->lock);
    800022b6:	8526                	mv	a0,s1
    800022b8:	fffff097          	auipc	ra,0xfffff
    800022bc:	90a080e7          	jalr	-1782(ra) # 80000bc2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800022c0:	4c9c                	lw	a5,24(s1)
    800022c2:	fd379be3          	bne	a5,s3,80002298 <wakeup+0x2a>
    800022c6:	709c                	ld	a5,32(s1)
    800022c8:	fd4798e3          	bne	a5,s4,80002298 <wakeup+0x2a>
        p->state = RUNNABLE;
    800022cc:	0154ac23          	sw	s5,24(s1)
    800022d0:	b7e1                	j	80002298 <wakeup+0x2a>
    }
  }
}
    800022d2:	70e2                	ld	ra,56(sp)
    800022d4:	7442                	ld	s0,48(sp)
    800022d6:	74a2                	ld	s1,40(sp)
    800022d8:	7902                	ld	s2,32(sp)
    800022da:	69e2                	ld	s3,24(sp)
    800022dc:	6a42                	ld	s4,16(sp)
    800022de:	6aa2                	ld	s5,8(sp)
    800022e0:	6121                	addi	sp,sp,64
    800022e2:	8082                	ret

00000000800022e4 <reparent>:
{
    800022e4:	7179                	addi	sp,sp,-48
    800022e6:	f406                	sd	ra,40(sp)
    800022e8:	f022                	sd	s0,32(sp)
    800022ea:	ec26                	sd	s1,24(sp)
    800022ec:	e84a                	sd	s2,16(sp)
    800022ee:	e44e                	sd	s3,8(sp)
    800022f0:	e052                	sd	s4,0(sp)
    800022f2:	1800                	addi	s0,sp,48
    800022f4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022f6:	0000f497          	auipc	s1,0xf
    800022fa:	3da48493          	addi	s1,s1,986 # 800116d0 <proc>
      pp->parent = initproc;
    800022fe:	00007a17          	auipc	s4,0x7
    80002302:	d2aa0a13          	addi	s4,s4,-726 # 80009028 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002306:	00020997          	auipc	s3,0x20
    8000230a:	bca98993          	addi	s3,s3,-1078 # 80021ed0 <tickslock>
    8000230e:	a029                	j	80002318 <reparent+0x34>
    80002310:	42048493          	addi	s1,s1,1056
    80002314:	01348d63          	beq	s1,s3,8000232e <reparent+0x4a>
    if(pp->parent == p){
    80002318:	7c9c                	ld	a5,56(s1)
    8000231a:	ff279be3          	bne	a5,s2,80002310 <reparent+0x2c>
      pp->parent = initproc;
    8000231e:	000a3503          	ld	a0,0(s4)
    80002322:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002324:	00000097          	auipc	ra,0x0
    80002328:	f4a080e7          	jalr	-182(ra) # 8000226e <wakeup>
    8000232c:	b7d5                	j	80002310 <reparent+0x2c>
}
    8000232e:	70a2                	ld	ra,40(sp)
    80002330:	7402                	ld	s0,32(sp)
    80002332:	64e2                	ld	s1,24(sp)
    80002334:	6942                	ld	s2,16(sp)
    80002336:	69a2                	ld	s3,8(sp)
    80002338:	6a02                	ld	s4,0(sp)
    8000233a:	6145                	addi	sp,sp,48
    8000233c:	8082                	ret

000000008000233e <exit>:
{
    8000233e:	7179                	addi	sp,sp,-48
    80002340:	f406                	sd	ra,40(sp)
    80002342:	f022                	sd	s0,32(sp)
    80002344:	ec26                	sd	s1,24(sp)
    80002346:	e84a                	sd	s2,16(sp)
    80002348:	e44e                	sd	s3,8(sp)
    8000234a:	e052                	sd	s4,0(sp)
    8000234c:	1800                	addi	s0,sp,48
    8000234e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002350:	fffff097          	auipc	ra,0xfffff
    80002354:	62e080e7          	jalr	1582(ra) # 8000197e <myproc>
    80002358:	89aa                	mv	s3,a0
  if(p == initproc)
    8000235a:	00007797          	auipc	a5,0x7
    8000235e:	cce7b783          	ld	a5,-818(a5) # 80009028 <initproc>
    80002362:	0d050493          	addi	s1,a0,208
    80002366:	15050913          	addi	s2,a0,336
    8000236a:	02a79363          	bne	a5,a0,80002390 <exit+0x52>
    panic("init exiting");
    8000236e:	00006517          	auipc	a0,0x6
    80002372:	eda50513          	addi	a0,a0,-294 # 80008248 <digits+0x208>
    80002376:	ffffe097          	auipc	ra,0xffffe
    8000237a:	1b4080e7          	jalr	436(ra) # 8000052a <panic>
      fileclose(f);
    8000237e:	00002097          	auipc	ra,0x2
    80002382:	5d8080e7          	jalr	1496(ra) # 80004956 <fileclose>
      p->ofile[fd] = 0;
    80002386:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000238a:	04a1                	addi	s1,s1,8
    8000238c:	01248563          	beq	s1,s2,80002396 <exit+0x58>
    if(p->ofile[fd]){
    80002390:	6088                	ld	a0,0(s1)
    80002392:	f575                	bnez	a0,8000237e <exit+0x40>
    80002394:	bfdd                	j	8000238a <exit+0x4c>
  begin_op();
    80002396:	00002097          	auipc	ra,0x2
    8000239a:	0f4080e7          	jalr	244(ra) # 8000448a <begin_op>
  iput(p->cwd);
    8000239e:	1509b503          	ld	a0,336(s3)
    800023a2:	00002097          	auipc	ra,0x2
    800023a6:	8cc080e7          	jalr	-1844(ra) # 80003c6e <iput>
  end_op();
    800023aa:	00002097          	auipc	ra,0x2
    800023ae:	160080e7          	jalr	352(ra) # 8000450a <end_op>
  p->cwd = 0;
    800023b2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800023b6:	0000f497          	auipc	s1,0xf
    800023ba:	f0248493          	addi	s1,s1,-254 # 800112b8 <wait_lock>
    800023be:	8526                	mv	a0,s1
    800023c0:	fffff097          	auipc	ra,0xfffff
    800023c4:	802080e7          	jalr	-2046(ra) # 80000bc2 <acquire>
  reparent(p);
    800023c8:	854e                	mv	a0,s3
    800023ca:	00000097          	auipc	ra,0x0
    800023ce:	f1a080e7          	jalr	-230(ra) # 800022e4 <reparent>
  wakeup(p->parent);
    800023d2:	0389b503          	ld	a0,56(s3)
    800023d6:	00000097          	auipc	ra,0x0
    800023da:	e98080e7          	jalr	-360(ra) # 8000226e <wakeup>
  acquire(&p->lock);
    800023de:	854e                	mv	a0,s3
    800023e0:	ffffe097          	auipc	ra,0xffffe
    800023e4:	7e2080e7          	jalr	2018(ra) # 80000bc2 <acquire>
  p->xstate = status;
    800023e8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800023ec:	4795                	li	a5,5
    800023ee:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800023f2:	8526                	mv	a0,s1
    800023f4:	fffff097          	auipc	ra,0xfffff
    800023f8:	882080e7          	jalr	-1918(ra) # 80000c76 <release>
  sched();
    800023fc:	00000097          	auipc	ra,0x0
    80002400:	bd4080e7          	jalr	-1068(ra) # 80001fd0 <sched>
  panic("zombie exit");
    80002404:	00006517          	auipc	a0,0x6
    80002408:	e5450513          	addi	a0,a0,-428 # 80008258 <digits+0x218>
    8000240c:	ffffe097          	auipc	ra,0xffffe
    80002410:	11e080e7          	jalr	286(ra) # 8000052a <panic>

0000000080002414 <kill>:
int
kill(int pid, int signum)
{
  struct proc *p;

  if(signum >= SIGNALS_SIZE || signum < 0) return -1;
    80002414:	47fd                	li	a5,31
    80002416:	08b7e963          	bltu	a5,a1,800024a8 <kill+0x94>
{
    8000241a:	7179                	addi	sp,sp,-48
    8000241c:	f406                	sd	ra,40(sp)
    8000241e:	f022                	sd	s0,32(sp)
    80002420:	ec26                	sd	s1,24(sp)
    80002422:	e84a                	sd	s2,16(sp)
    80002424:	e44e                	sd	s3,8(sp)
    80002426:	e052                	sd	s4,0(sp)
    80002428:	1800                	addi	s0,sp,48
    8000242a:	892a                	mv	s2,a0
    8000242c:	8a2e                	mv	s4,a1

  for(p = proc; p < &proc[NPROC]; p++){
    8000242e:	0000f497          	auipc	s1,0xf
    80002432:	2a248493          	addi	s1,s1,674 # 800116d0 <proc>
    80002436:	00020997          	auipc	s3,0x20
    8000243a:	a9a98993          	addi	s3,s3,-1382 # 80021ed0 <tickslock>
    acquire(&p->lock);
    8000243e:	8526                	mv	a0,s1
    80002440:	ffffe097          	auipc	ra,0xffffe
    80002444:	782080e7          	jalr	1922(ra) # 80000bc2 <acquire>
    if(p->pid == pid){
    80002448:	589c                	lw	a5,48(s1)
    8000244a:	01278d63          	beq	a5,s2,80002464 <kill+0x50>
      p->pendingSignals |= (1 << signum);

      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000244e:	8526                	mv	a0,s1
    80002450:	fffff097          	auipc	ra,0xfffff
    80002454:	826080e7          	jalr	-2010(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002458:	42048493          	addi	s1,s1,1056
    8000245c:	ff3491e3          	bne	s1,s3,8000243e <kill+0x2a>
  }
  return -1;
    80002460:	557d                	li	a0,-1
    80002462:	a015                	j	80002486 <kill+0x72>
      if(signum == SIGKILL){
    80002464:	47a5                	li	a5,9
    80002466:	02fa0863          	beq	s4,a5,80002496 <kill+0x82>
      p->pendingSignals |= (1 << signum);
    8000246a:	4785                	li	a5,1
    8000246c:	0147973b          	sllw	a4,a5,s4
    80002470:	1684a783          	lw	a5,360(s1)
    80002474:	8fd9                	or	a5,a5,a4
    80002476:	16f4a423          	sw	a5,360(s1)
      release(&p->lock);
    8000247a:	8526                	mv	a0,s1
    8000247c:	ffffe097          	auipc	ra,0xffffe
    80002480:	7fa080e7          	jalr	2042(ra) # 80000c76 <release>
      return 0;
    80002484:	4501                	li	a0,0
}
    80002486:	70a2                	ld	ra,40(sp)
    80002488:	7402                	ld	s0,32(sp)
    8000248a:	64e2                	ld	s1,24(sp)
    8000248c:	6942                	ld	s2,16(sp)
    8000248e:	69a2                	ld	s3,8(sp)
    80002490:	6a02                	ld	s4,0(sp)
    80002492:	6145                	addi	sp,sp,48
    80002494:	8082                	ret
        p->killed = 1; 
    80002496:	4785                	li	a5,1
    80002498:	d49c                	sw	a5,40(s1)
        if(p->state == SLEEPING){ //-----------------> Was in the previous version, according to the forum now it's redundant
    8000249a:	4c98                	lw	a4,24(s1)
    8000249c:	4789                	li	a5,2
    8000249e:	fcf716e3          	bne	a4,a5,8000246a <kill+0x56>
          p->state = RUNNABLE;
    800024a2:	478d                	li	a5,3
    800024a4:	cc9c                	sw	a5,24(s1)
    800024a6:	b7d1                	j	8000246a <kill+0x56>
  if(signum >= SIGNALS_SIZE || signum < 0) return -1;
    800024a8:	557d                	li	a0,-1
}
    800024aa:	8082                	ret

00000000800024ac <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800024ac:	7179                	addi	sp,sp,-48
    800024ae:	f406                	sd	ra,40(sp)
    800024b0:	f022                	sd	s0,32(sp)
    800024b2:	ec26                	sd	s1,24(sp)
    800024b4:	e84a                	sd	s2,16(sp)
    800024b6:	e44e                	sd	s3,8(sp)
    800024b8:	e052                	sd	s4,0(sp)
    800024ba:	1800                	addi	s0,sp,48
    800024bc:	84aa                	mv	s1,a0
    800024be:	892e                	mv	s2,a1
    800024c0:	89b2                	mv	s3,a2
    800024c2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024c4:	fffff097          	auipc	ra,0xfffff
    800024c8:	4ba080e7          	jalr	1210(ra) # 8000197e <myproc>
  if(user_dst){
    800024cc:	c08d                	beqz	s1,800024ee <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800024ce:	86d2                	mv	a3,s4
    800024d0:	864e                	mv	a2,s3
    800024d2:	85ca                	mv	a1,s2
    800024d4:	6928                	ld	a0,80(a0)
    800024d6:	fffff097          	auipc	ra,0xfffff
    800024da:	168080e7          	jalr	360(ra) # 8000163e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024de:	70a2                	ld	ra,40(sp)
    800024e0:	7402                	ld	s0,32(sp)
    800024e2:	64e2                	ld	s1,24(sp)
    800024e4:	6942                	ld	s2,16(sp)
    800024e6:	69a2                	ld	s3,8(sp)
    800024e8:	6a02                	ld	s4,0(sp)
    800024ea:	6145                	addi	sp,sp,48
    800024ec:	8082                	ret
    memmove((char *)dst, src, len);
    800024ee:	000a061b          	sext.w	a2,s4
    800024f2:	85ce                	mv	a1,s3
    800024f4:	854a                	mv	a0,s2
    800024f6:	fffff097          	auipc	ra,0xfffff
    800024fa:	824080e7          	jalr	-2012(ra) # 80000d1a <memmove>
    return 0;
    800024fe:	8526                	mv	a0,s1
    80002500:	bff9                	j	800024de <either_copyout+0x32>

0000000080002502 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002502:	7179                	addi	sp,sp,-48
    80002504:	f406                	sd	ra,40(sp)
    80002506:	f022                	sd	s0,32(sp)
    80002508:	ec26                	sd	s1,24(sp)
    8000250a:	e84a                	sd	s2,16(sp)
    8000250c:	e44e                	sd	s3,8(sp)
    8000250e:	e052                	sd	s4,0(sp)
    80002510:	1800                	addi	s0,sp,48
    80002512:	892a                	mv	s2,a0
    80002514:	84ae                	mv	s1,a1
    80002516:	89b2                	mv	s3,a2
    80002518:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000251a:	fffff097          	auipc	ra,0xfffff
    8000251e:	464080e7          	jalr	1124(ra) # 8000197e <myproc>
  if(user_src){
    80002522:	c08d                	beqz	s1,80002544 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002524:	86d2                	mv	a3,s4
    80002526:	864e                	mv	a2,s3
    80002528:	85ca                	mv	a1,s2
    8000252a:	6928                	ld	a0,80(a0)
    8000252c:	fffff097          	auipc	ra,0xfffff
    80002530:	19e080e7          	jalr	414(ra) # 800016ca <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002534:	70a2                	ld	ra,40(sp)
    80002536:	7402                	ld	s0,32(sp)
    80002538:	64e2                	ld	s1,24(sp)
    8000253a:	6942                	ld	s2,16(sp)
    8000253c:	69a2                	ld	s3,8(sp)
    8000253e:	6a02                	ld	s4,0(sp)
    80002540:	6145                	addi	sp,sp,48
    80002542:	8082                	ret
    memmove(dst, (char*)src, len);
    80002544:	000a061b          	sext.w	a2,s4
    80002548:	85ce                	mv	a1,s3
    8000254a:	854a                	mv	a0,s2
    8000254c:	ffffe097          	auipc	ra,0xffffe
    80002550:	7ce080e7          	jalr	1998(ra) # 80000d1a <memmove>
    return 0;
    80002554:	8526                	mv	a0,s1
    80002556:	bff9                	j	80002534 <either_copyin+0x32>

0000000080002558 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002558:	715d                	addi	sp,sp,-80
    8000255a:	e486                	sd	ra,72(sp)
    8000255c:	e0a2                	sd	s0,64(sp)
    8000255e:	fc26                	sd	s1,56(sp)
    80002560:	f84a                	sd	s2,48(sp)
    80002562:	f44e                	sd	s3,40(sp)
    80002564:	f052                	sd	s4,32(sp)
    80002566:	ec56                	sd	s5,24(sp)
    80002568:	e85a                	sd	s6,16(sp)
    8000256a:	e45e                	sd	s7,8(sp)
    8000256c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000256e:	00006517          	auipc	a0,0x6
    80002572:	b5a50513          	addi	a0,a0,-1190 # 800080c8 <digits+0x88>
    80002576:	ffffe097          	auipc	ra,0xffffe
    8000257a:	ffe080e7          	jalr	-2(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000257e:	0000f497          	auipc	s1,0xf
    80002582:	2aa48493          	addi	s1,s1,682 # 80011828 <proc+0x158>
    80002586:	00020917          	auipc	s2,0x20
    8000258a:	aa290913          	addi	s2,s2,-1374 # 80022028 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000258e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002590:	00006997          	auipc	s3,0x6
    80002594:	cd898993          	addi	s3,s3,-808 # 80008268 <digits+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    80002598:	00006a97          	auipc	s5,0x6
    8000259c:	cd8a8a93          	addi	s5,s5,-808 # 80008270 <digits+0x230>
    printf("\n");
    800025a0:	00006a17          	auipc	s4,0x6
    800025a4:	b28a0a13          	addi	s4,s4,-1240 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025a8:	00006b97          	auipc	s7,0x6
    800025ac:	d48b8b93          	addi	s7,s7,-696 # 800082f0 <states.0>
    800025b0:	a00d                	j	800025d2 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800025b2:	ed86a583          	lw	a1,-296(a3)
    800025b6:	8556                	mv	a0,s5
    800025b8:	ffffe097          	auipc	ra,0xffffe
    800025bc:	fbc080e7          	jalr	-68(ra) # 80000574 <printf>
    printf("\n");
    800025c0:	8552                	mv	a0,s4
    800025c2:	ffffe097          	auipc	ra,0xffffe
    800025c6:	fb2080e7          	jalr	-78(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025ca:	42048493          	addi	s1,s1,1056
    800025ce:	03248263          	beq	s1,s2,800025f2 <procdump+0x9a>
    if(p->state == UNUSED)
    800025d2:	86a6                	mv	a3,s1
    800025d4:	ec04a783          	lw	a5,-320(s1)
    800025d8:	dbed                	beqz	a5,800025ca <procdump+0x72>
      state = "???";
    800025da:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025dc:	fcfb6be3          	bltu	s6,a5,800025b2 <procdump+0x5a>
    800025e0:	02079713          	slli	a4,a5,0x20
    800025e4:	01d75793          	srli	a5,a4,0x1d
    800025e8:	97de                	add	a5,a5,s7
    800025ea:	6390                	ld	a2,0(a5)
    800025ec:	f279                	bnez	a2,800025b2 <procdump+0x5a>
      state = "???";
    800025ee:	864e                	mv	a2,s3
    800025f0:	b7c9                	j	800025b2 <procdump+0x5a>
  }
}
    800025f2:	60a6                	ld	ra,72(sp)
    800025f4:	6406                	ld	s0,64(sp)
    800025f6:	74e2                	ld	s1,56(sp)
    800025f8:	7942                	ld	s2,48(sp)
    800025fa:	79a2                	ld	s3,40(sp)
    800025fc:	7a02                	ld	s4,32(sp)
    800025fe:	6ae2                	ld	s5,24(sp)
    80002600:	6b42                	ld	s6,16(sp)
    80002602:	6ba2                	ld	s7,8(sp)
    80002604:	6161                	addi	sp,sp,80
    80002606:	8082                	ret

0000000080002608 <sigprocmask>:

uint
sigprocmask(uint sigmask){
    80002608:	1101                	addi	sp,sp,-32
    8000260a:	ec06                	sd	ra,24(sp)
    8000260c:	e822                	sd	s0,16(sp)
    8000260e:	e426                	sd	s1,8(sp)
    80002610:	1000                	addi	s0,sp,32
    80002612:	84aa                	mv	s1,a0

  struct proc* p = myproc ();
    80002614:	fffff097          	auipc	ra,0xfffff
    80002618:	36a080e7          	jalr	874(ra) # 8000197e <myproc>
    8000261c:	87aa                	mv	a5,a0
  uint oldMask = p->signalMask;
    8000261e:	16c52503          	lw	a0,364(a0)
  p->signalMask = sigmask;
    80002622:	1697a623          	sw	s1,364(a5)
  return oldMask;
}
    80002626:	60e2                	ld	ra,24(sp)
    80002628:	6442                	ld	s0,16(sp)
    8000262a:	64a2                	ld	s1,8(sp)
    8000262c:	6105                	addi	sp,sp,32
    8000262e:	8082                	ret

0000000080002630 <sigaction>:
sigaction(int signum, const struct sigaction *act, struct sigaction *oldact){

  // printf ("signum is: %d\nact adress is: %d\noldact address is: %d\n", signum,act,oldact);
  // Check that signum in the correct range

  if (signum < 0 || signum >= 32)
    80002630:	0005079b          	sext.w	a5,a0
    80002634:	477d                	li	a4,31
    80002636:	0ef76163          	bltu	a4,a5,80002718 <sigaction+0xe8>
sigaction(int signum, const struct sigaction *act, struct sigaction *oldact){
    8000263a:	7139                	addi	sp,sp,-64
    8000263c:	fc06                	sd	ra,56(sp)
    8000263e:	f822                	sd	s0,48(sp)
    80002640:	f426                	sd	s1,40(sp)
    80002642:	f04a                	sd	s2,32(sp)
    80002644:	ec4e                	sd	s3,24(sp)
    80002646:	e852                	sd	s4,16(sp)
    80002648:	0080                	addi	s0,sp,64
    8000264a:	84aa                	mv	s1,a0
    8000264c:	8a2e                	mv	s4,a1
    8000264e:	89b2                	mv	s3,a2
    return -1;

  if (signum == SIGSTOP || signum == SIGKILL)
    80002650:	37dd                	addiw	a5,a5,-9
    80002652:	9bdd                	andi	a5,a5,-9
    80002654:	2781                	sext.w	a5,a5
    80002656:	c3f9                	beqz	a5,8000271c <sigaction+0xec>
      return -1;

  struct proc* p = myproc ();
    80002658:	fffff097          	auipc	ra,0xfffff
    8000265c:	326080e7          	jalr	806(ra) # 8000197e <myproc>
    80002660:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002662:	ffffe097          	auipc	ra,0xffffe
    80002666:	560080e7          	jalr	1376(ra) # 80000bc2 <acquire>

  if (oldact){
    8000266a:	04098963          	beqz	s3,800026bc <sigaction+0x8c>

    struct sigaction oldSig;
    oldSig.sa_handler = p->signalHandlers[signum];
    8000266e:	02e48793          	addi	a5,s1,46
    80002672:	078e                	slli	a5,a5,0x3
    80002674:	97ca                	add	a5,a5,s2
    80002676:	639c                	ld	a5,0(a5)
    80002678:	fcf43023          	sd	a5,-64(s0)
    oldSig.sigmask = p->maskHandlers[signum];
    8000267c:	0e448793          	addi	a5,s1,228
    80002680:	078a                	slli	a5,a5,0x2
    80002682:	97ca                	add	a5,a5,s2
    80002684:	47dc                	lw	a5,12(a5)
    80002686:	fcf42423          	sw	a5,-56(s0)

    if (copyout(p->pagetable, (uint64) oldact, (char*)&oldSig.sa_handler, sizeof(8)) < 0)
    8000268a:	4691                	li	a3,4
    8000268c:	fc040613          	addi	a2,s0,-64
    80002690:	85ce                	mv	a1,s3
    80002692:	05093503          	ld	a0,80(s2)
    80002696:	fffff097          	auipc	ra,0xfffff
    8000269a:	fa8080e7          	jalr	-88(ra) # 8000163e <copyout>
    8000269e:	06054963          	bltz	a0,80002710 <sigaction+0xe0>
      return -1;

    if (copyout(p->pagetable, (uint64) oldact+8, (char*)&oldSig.sigmask, sizeof(uint)) < 0)
    800026a2:	4691                	li	a3,4
    800026a4:	fc840613          	addi	a2,s0,-56
    800026a8:	00898593          	addi	a1,s3,8
    800026ac:	05093503          	ld	a0,80(s2)
    800026b0:	fffff097          	auipc	ra,0xfffff
    800026b4:	f8e080e7          	jalr	-114(ra) # 8000163e <copyout>
    800026b8:	04054c63          	bltz	a0,80002710 <sigaction+0xe0>
      return -1;  
  }
  if (act){
    800026bc:	020a0c63          	beqz	s4,800026f4 <sigaction+0xc4>
    struct sigaction newSig;
    if(copyin(p->pagetable,(char*)&newSig, (uint64)act, sizeof(struct sigaction))<0)
    800026c0:	46c1                	li	a3,16
    800026c2:	8652                	mv	a2,s4
    800026c4:	fc040593          	addi	a1,s0,-64
    800026c8:	05093503          	ld	a0,80(s2)
    800026cc:	fffff097          	auipc	ra,0xfffff
    800026d0:	ffe080e7          	jalr	-2(ra) # 800016ca <copyin>
    800026d4:	04054063          	bltz	a0,80002714 <sigaction+0xe4>
      return -1;

    if(newSig.sigmask <0)
      return -1;

    p->signalHandlers[signum] = newSig.sa_handler;
    800026d8:	02e48793          	addi	a5,s1,46
    800026dc:	078e                	slli	a5,a5,0x3
    800026de:	97ca                	add	a5,a5,s2
    800026e0:	fc043703          	ld	a4,-64(s0)
    800026e4:	e398                	sd	a4,0(a5)

    p->maskHandlers[signum] = newSig.sigmask;
    800026e6:	0e448493          	addi	s1,s1,228
    800026ea:	048a                	slli	s1,s1,0x2
    800026ec:	94ca                	add	s1,s1,s2
    800026ee:	fc842783          	lw	a5,-56(s0)
    800026f2:	c4dc                	sw	a5,12(s1)
  }
  release(&p->lock);
    800026f4:	854a                	mv	a0,s2
    800026f6:	ffffe097          	auipc	ra,0xffffe
    800026fa:	580080e7          	jalr	1408(ra) # 80000c76 <release>
  return 0;
    800026fe:	4501                	li	a0,0
}
    80002700:	70e2                	ld	ra,56(sp)
    80002702:	7442                	ld	s0,48(sp)
    80002704:	74a2                	ld	s1,40(sp)
    80002706:	7902                	ld	s2,32(sp)
    80002708:	69e2                	ld	s3,24(sp)
    8000270a:	6a42                	ld	s4,16(sp)
    8000270c:	6121                	addi	sp,sp,64
    8000270e:	8082                	ret
      return -1;
    80002710:	557d                	li	a0,-1
    80002712:	b7fd                	j	80002700 <sigaction+0xd0>
      return -1;
    80002714:	557d                	li	a0,-1
    80002716:	b7ed                	j	80002700 <sigaction+0xd0>
    return -1;
    80002718:	557d                	li	a0,-1
}
    8000271a:	8082                	ret
      return -1;
    8000271c:	557d                	li	a0,-1
    8000271e:	b7cd                	j	80002700 <sigaction+0xd0>

0000000080002720 <sigret>:


void
sigret (void){
    80002720:	1101                	addi	sp,sp,-32
    80002722:	ec06                	sd	ra,24(sp)
    80002724:	e822                	sd	s0,16(sp)
    80002726:	e426                	sd	s1,8(sp)
    80002728:	1000                	addi	s0,sp,32
  struct proc* p = myproc();
    8000272a:	fffff097          	auipc	ra,0xfffff
    8000272e:	254080e7          	jalr	596(ra) # 8000197e <myproc>
    80002732:	84aa                	mv	s1,a0
  printf("sig ret\n");
    80002734:	00006517          	auipc	a0,0x6
    80002738:	b4c50513          	addi	a0,a0,-1204 # 80008280 <digits+0x240>
    8000273c:	ffffe097          	auipc	ra,0xffffe
    80002740:	e38080e7          	jalr	-456(ra) # 80000574 <printf>
  *p->trapframe = p->UserTrapFrameBackup;
    80002744:	27048793          	addi	a5,s1,624
    80002748:	6cb8                	ld	a4,88(s1)
    8000274a:	39048693          	addi	a3,s1,912
    8000274e:	0007b803          	ld	a6,0(a5)
    80002752:	6788                	ld	a0,8(a5)
    80002754:	6b8c                	ld	a1,16(a5)
    80002756:	6f90                	ld	a2,24(a5)
    80002758:	01073023          	sd	a6,0(a4)
    8000275c:	e708                	sd	a0,8(a4)
    8000275e:	eb0c                	sd	a1,16(a4)
    80002760:	ef10                	sd	a2,24(a4)
    80002762:	02078793          	addi	a5,a5,32
    80002766:	02070713          	addi	a4,a4,32
    8000276a:	fed792e3          	bne	a5,a3,8000274e <sigret+0x2e>
  // memmove(p->trapframe, p->UserTrapFrameBackup, sizeof(struct trapframe));
  // if(copyin(p->pagetable,(char*)p->trapframe, (uint64)p->UserTrapFrameBackup, sizeof(struct trapframe)) < 0)
  // printf("fopyin doesnt work\n");
  p->signalMask = p->signal_mask_backup;
    8000276e:	3944a783          	lw	a5,916(s1)
    80002772:	16f4a623          	sw	a5,364(s1)
  p->ignore_signals = 0;
    80002776:	3804ac23          	sw	zero,920(s1)
}
    8000277a:	60e2                	ld	ra,24(sp)
    8000277c:	6442                	ld	s0,16(sp)
    8000277e:	64a2                	ld	s1,8(sp)
    80002780:	6105                	addi	sp,sp,32
    80002782:	8082                	ret

0000000080002784 <usersignal>:

void usersignal(struct proc *p, int signum){
    80002784:	1101                	addi	sp,sp,-32
    80002786:	ec06                	sd	ra,24(sp)
    80002788:	e822                	sd	s0,16(sp)
    8000278a:	e426                	sd	s1,8(sp)
    8000278c:	e04a                	sd	s2,0(sp)
    8000278e:	1000                	addi	s0,sp,32
    80002790:	84aa                	mv	s1,a0
    80002792:	892e                	mv	s2,a1
  printf("here in usersignal\n");
    80002794:	00006517          	auipc	a0,0x6
    80002798:	afc50513          	addi	a0,a0,-1284 # 80008290 <digits+0x250>
    8000279c:	ffffe097          	auipc	ra,0xffffe
    800027a0:	dd8080e7          	jalr	-552(ra) # 80000574 <printf>
  at the process page table, using local variable (to a user space address) */
  // uint64 act_handler;
  // copyin(p->pagetable, (char*)&sigact, (uint64)p->signalHandlers[signum], sizeof(uint64));

  // Extract sigmask from sigaction, and backup the old signal mask
  p->signal_mask_backup = p->signalMask;
    800027a4:	16c4a783          	lw	a5,364(s1)
    800027a8:	38f4aa23          	sw	a5,916(s1)
  p->signalMask = p->maskHandlers[signum];
    800027ac:	0e490793          	addi	a5,s2,228
    800027b0:	078a                	slli	a5,a5,0x2
    800027b2:	97a6                	add	a5,a5,s1
    800027b4:	47dc                	lw	a5,12(a5)
    800027b6:	16f4a623          	sw	a5,364(s1)

  // indicate that the process is at "signal handling" by turn on a flag
  p->ignore_signals = 1;
    800027ba:	4785                	li	a5,1
    800027bc:	38f4ac23          	sw	a5,920(s1)
  // uint64 UserTrapFrameBackup = p->trapframe->sp;

  /* use the "copyout" function (from kernel to user), to copy the current process trapframe, 
  to the trapframe backup stack pointer (to reduce its stack pointer at the user space) */
  //copyout(p->pagetable, (uint64)p->UserTrapFrameBackup, (char *)&p->trapframe, sizeof(struct trapframe));
  memmove(&p->UserTrapFrameBackup, p->trapframe, sizeof(struct trapframe));
    800027c0:	12000613          	li	a2,288
    800027c4:	6cac                	ld	a1,88(s1)
    800027c6:	27048513          	addi	a0,s1,624
    800027ca:	ffffe097          	auipc	ra,0xffffe
    800027ce:	550080e7          	jalr	1360(ra) # 80000d1a <memmove>
  // copyout(p->pagetable, UserTrapFrameBackup, (char *)&p->trapframe, sizeof(struct trapframe));

  // Extract handler from signalHandlers, and updated saved user pc to point to signal handler
  p->trapframe->epc = (uint64)p->signalHandlers[signum];
    800027d2:	6cb8                	ld	a4,88(s1)
    800027d4:	02e90793          	addi	a5,s2,46
    800027d8:	078e                	slli	a5,a5,0x3
    800027da:	97a6                	add	a5,a5,s1
    800027dc:	639c                	ld	a5,0(a5)
    800027de:	ef1c                	sd	a5,24(a4)

  // Calculate the size of sig_ret
  uint sigret_size = end_ret - start_ret;

  // Reduce stack pointer by size of function sigret and copy out function to user stack
  p->trapframe->sp -= sigret_size;
    800027e0:	6cb8                	ld	a4,88(s1)
  uint sigret_size = end_ret - start_ret;
    800027e2:	00004617          	auipc	a2,0x4
    800027e6:	91460613          	addi	a2,a2,-1772 # 800060f6 <start_ret>
    800027ea:	00004697          	auipc	a3,0x4
    800027ee:	91268693          	addi	a3,a3,-1774 # 800060fc <free_desc>
    800027f2:	8e91                	sub	a3,a3,a2
  p->trapframe->sp -= sigret_size;
    800027f4:	1682                	slli	a3,a3,0x20
    800027f6:	9281                	srli	a3,a3,0x20
    800027f8:	7b1c                	ld	a5,48(a4)
    800027fa:	8f95                	sub	a5,a5,a3
    800027fc:	fb1c                	sd	a5,48(a4)
  copyout(p->pagetable, p->trapframe->sp, (char *)&start_ret, sigret_size);
    800027fe:	6cbc                	ld	a5,88(s1)
    80002800:	7b8c                	ld	a1,48(a5)
    80002802:	68a8                	ld	a0,80(s1)
    80002804:	fffff097          	auipc	ra,0xfffff
    80002808:	e3a080e7          	jalr	-454(ra) # 8000163e <copyout>

  // parameter = signum
  p->trapframe->a0 = signum;
    8000280c:	6cbc                	ld	a5,88(s1)
    8000280e:	0727b823          	sd	s2,112(a5)

  // update return address so that after handler finishes it will jump to sigret  
  p->trapframe->ra = p->trapframe->sp;
    80002812:	6cbc                	ld	a5,88(s1)
    80002814:	7b98                	ld	a4,48(a5)
    80002816:	f798                	sd	a4,40(a5)

}
    80002818:	60e2                	ld	ra,24(sp)
    8000281a:	6442                	ld	s0,16(sp)
    8000281c:	64a2                	ld	s1,8(sp)
    8000281e:	6902                	ld	s2,0(sp)
    80002820:	6105                	addi	sp,sp,32
    80002822:	8082                	ret

0000000080002824 <stopSignal>:

void stopSignal(struct proc *p){
    80002824:	1141                	addi	sp,sp,-16
    80002826:	e422                	sd	s0,8(sp)
    80002828:	0800                	addi	s0,sp,16

  p->stopped = 1;
    8000282a:	4785                	li	a5,1
    8000282c:	38f52823          	sw	a5,912(a0)

}
    80002830:	6422                	ld	s0,8(sp)
    80002832:	0141                	addi	sp,sp,16
    80002834:	8082                	ret

0000000080002836 <contSignal>:

void contSignal(struct proc *p){
    80002836:	1141                	addi	sp,sp,-16
    80002838:	e422                	sd	s0,8(sp)
    8000283a:	0800                	addi	s0,sp,16

  p->stopped = 0;
    8000283c:	38052823          	sw	zero,912(a0)

}
    80002840:	6422                	ld	s0,8(sp)
    80002842:	0141                	addi	sp,sp,16
    80002844:	8082                	ret

0000000080002846 <handling_signals>:


void handling_signals(){
    80002846:	711d                	addi	sp,sp,-96
    80002848:	ec86                	sd	ra,88(sp)
    8000284a:	e8a2                	sd	s0,80(sp)
    8000284c:	e4a6                	sd	s1,72(sp)
    8000284e:	e0ca                	sd	s2,64(sp)
    80002850:	fc4e                	sd	s3,56(sp)
    80002852:	f852                	sd	s4,48(sp)
    80002854:	f456                	sd	s5,40(sp)
    80002856:	f05a                	sd	s6,32(sp)
    80002858:	ec5e                	sd	s7,24(sp)
    8000285a:	e862                	sd	s8,16(sp)
    8000285c:	e466                	sd	s9,8(sp)
    8000285e:	e06a                	sd	s10,0(sp)
    80002860:	1080                	addi	s0,sp,96
  struct proc *p = myproc();
    80002862:	fffff097          	auipc	ra,0xfffff
    80002866:	11c080e7          	jalr	284(ra) # 8000197e <myproc>

  // ass2
  
  // If first process or all signals are ignored -> return
  if((p == 0) || (p->signalMask == 0xffffffff) || p->ignore_signals) return;
    8000286a:	c57d                	beqz	a0,80002958 <handling_signals+0x112>
    8000286c:	89aa                	mv	s3,a0
    8000286e:	16c52783          	lw	a5,364(a0)
    80002872:	577d                	li	a4,-1
    80002874:	0ee78263          	beq	a5,a4,80002958 <handling_signals+0x112>
    80002878:	39852483          	lw	s1,920(a0)
    8000287c:	ecf1                	bnez	s1,80002958 <handling_signals+0x112>

  // Check if stopped and has a pending SIGCONT signal, if none are received, it will yield the CPU.
  if(p->stopped && !(p->signalMask & (1 << SIGSTOP))) {
    8000287e:	39052703          	lw	a4,912(a0)
    80002882:	cf0d                	beqz	a4,800028bc <handling_signals+0x76>
    80002884:	83c5                	srli	a5,a5,0x11
    80002886:	8b85                	andi	a5,a5,1
    80002888:	eb95                	bnez	a5,800028bc <handling_signals+0x76>
    int cont_pend;
    while(1){   
      // acquire(&p->lock);
      cont_pend = p->pendingSignals & (1 << SIGCONT);
    8000288a:	16852703          	lw	a4,360(a0)
    8000288e:	01375793          	srli	a5,a4,0x13
      if(cont_pend){
    80002892:	8b85                	andi	a5,a5,1
      cont_pend = p->pendingSignals & (1 << SIGCONT);
    80002894:	00080937          	lui	s2,0x80
      if(cont_pend){
    80002898:	eb99                	bnez	a5,800028ae <handling_signals+0x68>
        // release(&p->lock);
        break;
      }
      else{
        // release(&p->lock);
        yield();
    8000289a:	00000097          	auipc	ra,0x0
    8000289e:	80c080e7          	jalr	-2036(ra) # 800020a6 <yield>
      cont_pend = p->pendingSignals & (1 << SIGCONT);
    800028a2:	1689a703          	lw	a4,360(s3)
    800028a6:	012777b3          	and	a5,a4,s2
      if(cont_pend){
    800028aa:	2781                	sext.w	a5,a5
    800028ac:	d7fd                	beqz	a5,8000289a <handling_signals+0x54>
        p->stopped = 0;
    800028ae:	3809a823          	sw	zero,912(s3)
        p->pendingSignals ^= (1 << SIGCONT);
    800028b2:	000807b7          	lui	a5,0x80
    800028b6:	8f3d                	xor	a4,a4,a5
    800028b8:	16e9a423          	sw	a4,360(s3)
      }
    }
  }

  for(int sig = 0 ; sig < SIGNALS_SIZE ; sig++){
    800028bc:	17098a13          	addi	s4,s3,368
    uint pandSigs = p->pendingSignals;
    uint sigMask = p->signalMask;
    // check if panding for the i'th signal and it's not blocked.
    if( (pandSigs & (1 << sig)) && !(sigMask & (1 << sig)) ){
    800028c0:	4b05                	li	s6,1
            break;
        }
        //turning bit of pending singal off
        p->pendingSignals ^= (1 << sig); 
      }
      else if (p->signalHandlers[sig] != (void*)SIG_IGN){
    800028c2:	4b85                	li	s7,1
        printf("sig == %d and user handler\n", sig);
    800028c4:	00006c17          	auipc	s8,0x6
    800028c8:	9e4c0c13          	addi	s8,s8,-1564 # 800082a8 <digits+0x268>
        switch(sig)
    800028cc:	4d45                	li	s10,17
    800028ce:	4ccd                	li	s9,19
  for(int sig = 0 ; sig < SIGNALS_SIZE ; sig++){
    800028d0:	02000a93          	li	s5,32
    800028d4:	a80d                	j	80002906 <handling_signals+0xc0>
        switch(sig)
    800028d6:	01a48c63          	beq	s1,s10,800028ee <handling_signals+0xa8>
    800028da:	07948c63          	beq	s1,s9,80002952 <handling_signals+0x10c>
            kill(p->pid, SIGKILL);
    800028de:	45a5                	li	a1,9
    800028e0:	0309a503          	lw	a0,48(s3)
    800028e4:	00000097          	auipc	ra,0x0
    800028e8:	b30080e7          	jalr	-1232(ra) # 80002414 <kill>
            break;
    800028ec:	a019                	j	800028f2 <handling_signals+0xac>
  p->stopped = 1;
    800028ee:	3979a823          	sw	s7,912(s3)
        p->pendingSignals ^= (1 << sig); 
    800028f2:	1689a783          	lw	a5,360(s3)
    800028f6:	0127c933          	xor	s2,a5,s2
    800028fa:	1729a423          	sw	s2,360(s3)
  for(int sig = 0 ; sig < SIGNALS_SIZE ; sig++){
    800028fe:	2485                	addiw	s1,s1,1
    80002900:	0a21                	addi	s4,s4,8
    80002902:	05548b63          	beq	s1,s5,80002958 <handling_signals+0x112>
    if( (pandSigs & (1 << sig)) && !(sigMask & (1 << sig)) ){
    80002906:	009b193b          	sllw	s2,s6,s1
    8000290a:	1689a783          	lw	a5,360(s3)
    8000290e:	0127f7b3          	and	a5,a5,s2
    80002912:	2781                	sext.w	a5,a5
    80002914:	d7ed                	beqz	a5,800028fe <handling_signals+0xb8>
    80002916:	16c9a783          	lw	a5,364(s3)
    8000291a:	0127f7b3          	and	a5,a5,s2
    8000291e:	2781                	sext.w	a5,a5
    80002920:	fff9                	bnez	a5,800028fe <handling_signals+0xb8>
      if(p->signalHandlers[sig] == (void*)SIG_DFL){
    80002922:	000a3783          	ld	a5,0(s4)
    80002926:	dbc5                	beqz	a5,800028d6 <handling_signals+0x90>
      else if (p->signalHandlers[sig] != (void*)SIG_IGN){
    80002928:	fd778be3          	beq	a5,s7,800028fe <handling_signals+0xb8>
        printf("sig == %d and user handler\n", sig);
    8000292c:	85a6                	mv	a1,s1
    8000292e:	8562                	mv	a0,s8
    80002930:	ffffe097          	auipc	ra,0xffffe
    80002934:	c44080e7          	jalr	-956(ra) # 80000574 <printf>
        usersignal(p, sig);
    80002938:	85a6                	mv	a1,s1
    8000293a:	854e                	mv	a0,s3
    8000293c:	00000097          	auipc	ra,0x0
    80002940:	e48080e7          	jalr	-440(ra) # 80002784 <usersignal>
        p->pendingSignals ^= (1 << sig); //turning bit off
    80002944:	1689a783          	lw	a5,360(s3)
    80002948:	0127c933          	xor	s2,a5,s2
    8000294c:	1729a423          	sw	s2,360(s3)
    80002950:	b77d                	j	800028fe <handling_signals+0xb8>
  p->stopped = 0;
    80002952:	3809a823          	sw	zero,912(s3)
}
    80002956:	bf71                	j	800028f2 <handling_signals+0xac>
      }
    }
  }
}
    80002958:	60e6                	ld	ra,88(sp)
    8000295a:	6446                	ld	s0,80(sp)
    8000295c:	64a6                	ld	s1,72(sp)
    8000295e:	6906                	ld	s2,64(sp)
    80002960:	79e2                	ld	s3,56(sp)
    80002962:	7a42                	ld	s4,48(sp)
    80002964:	7aa2                	ld	s5,40(sp)
    80002966:	7b02                	ld	s6,32(sp)
    80002968:	6be2                	ld	s7,24(sp)
    8000296a:	6c42                	ld	s8,16(sp)
    8000296c:	6ca2                	ld	s9,8(sp)
    8000296e:	6d02                	ld	s10,0(sp)
    80002970:	6125                	addi	sp,sp,96
    80002972:	8082                	ret

0000000080002974 <swtch>:
    80002974:	00153023          	sd	ra,0(a0)
    80002978:	00253423          	sd	sp,8(a0)
    8000297c:	e900                	sd	s0,16(a0)
    8000297e:	ed04                	sd	s1,24(a0)
    80002980:	03253023          	sd	s2,32(a0)
    80002984:	03353423          	sd	s3,40(a0)
    80002988:	03453823          	sd	s4,48(a0)
    8000298c:	03553c23          	sd	s5,56(a0)
    80002990:	05653023          	sd	s6,64(a0)
    80002994:	05753423          	sd	s7,72(a0)
    80002998:	05853823          	sd	s8,80(a0)
    8000299c:	05953c23          	sd	s9,88(a0)
    800029a0:	07a53023          	sd	s10,96(a0)
    800029a4:	07b53423          	sd	s11,104(a0)
    800029a8:	0005b083          	ld	ra,0(a1)
    800029ac:	0085b103          	ld	sp,8(a1)
    800029b0:	6980                	ld	s0,16(a1)
    800029b2:	6d84                	ld	s1,24(a1)
    800029b4:	0205b903          	ld	s2,32(a1)
    800029b8:	0285b983          	ld	s3,40(a1)
    800029bc:	0305ba03          	ld	s4,48(a1)
    800029c0:	0385ba83          	ld	s5,56(a1)
    800029c4:	0405bb03          	ld	s6,64(a1)
    800029c8:	0485bb83          	ld	s7,72(a1)
    800029cc:	0505bc03          	ld	s8,80(a1)
    800029d0:	0585bc83          	ld	s9,88(a1)
    800029d4:	0605bd03          	ld	s10,96(a1)
    800029d8:	0685bd83          	ld	s11,104(a1)
    800029dc:	8082                	ret

00000000800029de <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800029de:	1141                	addi	sp,sp,-16
    800029e0:	e406                	sd	ra,8(sp)
    800029e2:	e022                	sd	s0,0(sp)
    800029e4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800029e6:	00006597          	auipc	a1,0x6
    800029ea:	93a58593          	addi	a1,a1,-1734 # 80008320 <states.0+0x30>
    800029ee:	0001f517          	auipc	a0,0x1f
    800029f2:	4e250513          	addi	a0,a0,1250 # 80021ed0 <tickslock>
    800029f6:	ffffe097          	auipc	ra,0xffffe
    800029fa:	13c080e7          	jalr	316(ra) # 80000b32 <initlock>
}
    800029fe:	60a2                	ld	ra,8(sp)
    80002a00:	6402                	ld	s0,0(sp)
    80002a02:	0141                	addi	sp,sp,16
    80002a04:	8082                	ret

0000000080002a06 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002a06:	1141                	addi	sp,sp,-16
    80002a08:	e422                	sd	s0,8(sp)
    80002a0a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a0c:	00003797          	auipc	a5,0x3
    80002a10:	59478793          	addi	a5,a5,1428 # 80005fa0 <kernelvec>
    80002a14:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002a18:	6422                	ld	s0,8(sp)
    80002a1a:	0141                	addi	sp,sp,16
    80002a1c:	8082                	ret

0000000080002a1e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002a1e:	1101                	addi	sp,sp,-32
    80002a20:	ec06                	sd	ra,24(sp)
    80002a22:	e822                	sd	s0,16(sp)
    80002a24:	e426                	sd	s1,8(sp)
    80002a26:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002a28:	fffff097          	auipc	ra,0xfffff
    80002a2c:	f56080e7          	jalr	-170(ra) # 8000197e <myproc>
    80002a30:	84aa                	mv	s1,a0
  handling_signals();
    80002a32:	00000097          	auipc	ra,0x0
    80002a36:	e14080e7          	jalr	-492(ra) # 80002846 <handling_signals>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a3a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002a3e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a40:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002a44:	00004617          	auipc	a2,0x4
    80002a48:	5bc60613          	addi	a2,a2,1468 # 80007000 <_trampoline>
    80002a4c:	00004697          	auipc	a3,0x4
    80002a50:	5b468693          	addi	a3,a3,1460 # 80007000 <_trampoline>
    80002a54:	8e91                	sub	a3,a3,a2
    80002a56:	040007b7          	lui	a5,0x4000
    80002a5a:	17fd                	addi	a5,a5,-1
    80002a5c:	07b2                	slli	a5,a5,0xc
    80002a5e:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a60:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002a64:	6cb8                	ld	a4,88(s1)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002a66:	180026f3          	csrr	a3,satp
    80002a6a:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002a6c:	6cb8                	ld	a4,88(s1)
    80002a6e:	60b4                	ld	a3,64(s1)
    80002a70:	6585                	lui	a1,0x1
    80002a72:	96ae                	add	a3,a3,a1
    80002a74:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002a76:	6cb8                	ld	a4,88(s1)
    80002a78:	00000697          	auipc	a3,0x0
    80002a7c:	13a68693          	addi	a3,a3,314 # 80002bb2 <usertrap>
    80002a80:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002a82:	6cb8                	ld	a4,88(s1)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002a84:	8692                	mv	a3,tp
    80002a86:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a88:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002a8c:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002a90:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a94:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002a98:	6cb8                	ld	a4,88(s1)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a9a:	6f18                	ld	a4,24(a4)
    80002a9c:	14171073          	csrw	sepc,a4

  

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002aa0:	68ac                	ld	a1,80(s1)
    80002aa2:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002aa4:	00004717          	auipc	a4,0x4
    80002aa8:	5ec70713          	addi	a4,a4,1516 # 80007090 <userret>
    80002aac:	8f11                	sub	a4,a4,a2
    80002aae:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002ab0:	577d                	li	a4,-1
    80002ab2:	177e                	slli	a4,a4,0x3f
    80002ab4:	8dd9                	or	a1,a1,a4
    80002ab6:	02000537          	lui	a0,0x2000
    80002aba:	157d                	addi	a0,a0,-1
    80002abc:	0536                	slli	a0,a0,0xd
    80002abe:	9782                	jalr	a5
}
    80002ac0:	60e2                	ld	ra,24(sp)
    80002ac2:	6442                	ld	s0,16(sp)
    80002ac4:	64a2                	ld	s1,8(sp)
    80002ac6:	6105                	addi	sp,sp,32
    80002ac8:	8082                	ret

0000000080002aca <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002aca:	1101                	addi	sp,sp,-32
    80002acc:	ec06                	sd	ra,24(sp)
    80002ace:	e822                	sd	s0,16(sp)
    80002ad0:	e426                	sd	s1,8(sp)
    80002ad2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002ad4:	0001f497          	auipc	s1,0x1f
    80002ad8:	3fc48493          	addi	s1,s1,1020 # 80021ed0 <tickslock>
    80002adc:	8526                	mv	a0,s1
    80002ade:	ffffe097          	auipc	ra,0xffffe
    80002ae2:	0e4080e7          	jalr	228(ra) # 80000bc2 <acquire>
  ticks++;
    80002ae6:	00006517          	auipc	a0,0x6
    80002aea:	54a50513          	addi	a0,a0,1354 # 80009030 <ticks>
    80002aee:	411c                	lw	a5,0(a0)
    80002af0:	2785                	addiw	a5,a5,1
    80002af2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002af4:	fffff097          	auipc	ra,0xfffff
    80002af8:	77a080e7          	jalr	1914(ra) # 8000226e <wakeup>
  release(&tickslock);
    80002afc:	8526                	mv	a0,s1
    80002afe:	ffffe097          	auipc	ra,0xffffe
    80002b02:	178080e7          	jalr	376(ra) # 80000c76 <release>
}
    80002b06:	60e2                	ld	ra,24(sp)
    80002b08:	6442                	ld	s0,16(sp)
    80002b0a:	64a2                	ld	s1,8(sp)
    80002b0c:	6105                	addi	sp,sp,32
    80002b0e:	8082                	ret

0000000080002b10 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002b10:	1101                	addi	sp,sp,-32
    80002b12:	ec06                	sd	ra,24(sp)
    80002b14:	e822                	sd	s0,16(sp)
    80002b16:	e426                	sd	s1,8(sp)
    80002b18:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b1a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002b1e:	00074d63          	bltz	a4,80002b38 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002b22:	57fd                	li	a5,-1
    80002b24:	17fe                	slli	a5,a5,0x3f
    80002b26:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002b28:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002b2a:	06f70363          	beq	a4,a5,80002b90 <devintr+0x80>
  }
}
    80002b2e:	60e2                	ld	ra,24(sp)
    80002b30:	6442                	ld	s0,16(sp)
    80002b32:	64a2                	ld	s1,8(sp)
    80002b34:	6105                	addi	sp,sp,32
    80002b36:	8082                	ret
     (scause & 0xff) == 9){
    80002b38:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002b3c:	46a5                	li	a3,9
    80002b3e:	fed792e3          	bne	a5,a3,80002b22 <devintr+0x12>
    int irq = plic_claim();
    80002b42:	00003097          	auipc	ra,0x3
    80002b46:	566080e7          	jalr	1382(ra) # 800060a8 <plic_claim>
    80002b4a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002b4c:	47a9                	li	a5,10
    80002b4e:	02f50763          	beq	a0,a5,80002b7c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002b52:	4785                	li	a5,1
    80002b54:	02f50963          	beq	a0,a5,80002b86 <devintr+0x76>
    return 1;
    80002b58:	4505                	li	a0,1
    } else if(irq){
    80002b5a:	d8f1                	beqz	s1,80002b2e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002b5c:	85a6                	mv	a1,s1
    80002b5e:	00005517          	auipc	a0,0x5
    80002b62:	7ca50513          	addi	a0,a0,1994 # 80008328 <states.0+0x38>
    80002b66:	ffffe097          	auipc	ra,0xffffe
    80002b6a:	a0e080e7          	jalr	-1522(ra) # 80000574 <printf>
      plic_complete(irq);
    80002b6e:	8526                	mv	a0,s1
    80002b70:	00003097          	auipc	ra,0x3
    80002b74:	55c080e7          	jalr	1372(ra) # 800060cc <plic_complete>
    return 1;
    80002b78:	4505                	li	a0,1
    80002b7a:	bf55                	j	80002b2e <devintr+0x1e>
      uartintr();
    80002b7c:	ffffe097          	auipc	ra,0xffffe
    80002b80:	e0a080e7          	jalr	-502(ra) # 80000986 <uartintr>
    80002b84:	b7ed                	j	80002b6e <devintr+0x5e>
      virtio_disk_intr();
    80002b86:	00004097          	auipc	ra,0x4
    80002b8a:	9de080e7          	jalr	-1570(ra) # 80006564 <virtio_disk_intr>
    80002b8e:	b7c5                	j	80002b6e <devintr+0x5e>
    if(cpuid() == 0){
    80002b90:	fffff097          	auipc	ra,0xfffff
    80002b94:	dc2080e7          	jalr	-574(ra) # 80001952 <cpuid>
    80002b98:	c901                	beqz	a0,80002ba8 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002b9a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002b9e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002ba0:	14479073          	csrw	sip,a5
    return 2;
    80002ba4:	4509                	li	a0,2
    80002ba6:	b761                	j	80002b2e <devintr+0x1e>
      clockintr();
    80002ba8:	00000097          	auipc	ra,0x0
    80002bac:	f22080e7          	jalr	-222(ra) # 80002aca <clockintr>
    80002bb0:	b7ed                	j	80002b9a <devintr+0x8a>

0000000080002bb2 <usertrap>:
{
    80002bb2:	1101                	addi	sp,sp,-32
    80002bb4:	ec06                	sd	ra,24(sp)
    80002bb6:	e822                	sd	s0,16(sp)
    80002bb8:	e426                	sd	s1,8(sp)
    80002bba:	e04a                	sd	s2,0(sp)
    80002bbc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bbe:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002bc2:	1007f793          	andi	a5,a5,256
    80002bc6:	e3ad                	bnez	a5,80002c28 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002bc8:	00003797          	auipc	a5,0x3
    80002bcc:	3d878793          	addi	a5,a5,984 # 80005fa0 <kernelvec>
    80002bd0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002bd4:	fffff097          	auipc	ra,0xfffff
    80002bd8:	daa080e7          	jalr	-598(ra) # 8000197e <myproc>
    80002bdc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002bde:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002be0:	14102773          	csrr	a4,sepc
    80002be4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002be6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002bea:	47a1                	li	a5,8
    80002bec:	04f71c63          	bne	a4,a5,80002c44 <usertrap+0x92>
    if(p->killed)
    80002bf0:	551c                	lw	a5,40(a0)
    80002bf2:	e3b9                	bnez	a5,80002c38 <usertrap+0x86>
    p->trapframe->epc += 4;
    80002bf4:	6cb8                	ld	a4,88(s1)
    80002bf6:	6f1c                	ld	a5,24(a4)
    80002bf8:	0791                	addi	a5,a5,4
    80002bfa:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bfc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002c00:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c04:	10079073          	csrw	sstatus,a5
    syscall();
    80002c08:	00000097          	auipc	ra,0x0
    80002c0c:	2e0080e7          	jalr	736(ra) # 80002ee8 <syscall>
  if(p->killed)
    80002c10:	549c                	lw	a5,40(s1)
    80002c12:	ebc1                	bnez	a5,80002ca2 <usertrap+0xf0>
  usertrapret();
    80002c14:	00000097          	auipc	ra,0x0
    80002c18:	e0a080e7          	jalr	-502(ra) # 80002a1e <usertrapret>
}
    80002c1c:	60e2                	ld	ra,24(sp)
    80002c1e:	6442                	ld	s0,16(sp)
    80002c20:	64a2                	ld	s1,8(sp)
    80002c22:	6902                	ld	s2,0(sp)
    80002c24:	6105                	addi	sp,sp,32
    80002c26:	8082                	ret
    panic("usertrap: not from user mode");
    80002c28:	00005517          	auipc	a0,0x5
    80002c2c:	72050513          	addi	a0,a0,1824 # 80008348 <states.0+0x58>
    80002c30:	ffffe097          	auipc	ra,0xffffe
    80002c34:	8fa080e7          	jalr	-1798(ra) # 8000052a <panic>
      exit(-1);
    80002c38:	557d                	li	a0,-1
    80002c3a:	fffff097          	auipc	ra,0xfffff
    80002c3e:	704080e7          	jalr	1796(ra) # 8000233e <exit>
    80002c42:	bf4d                	j	80002bf4 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002c44:	00000097          	auipc	ra,0x0
    80002c48:	ecc080e7          	jalr	-308(ra) # 80002b10 <devintr>
    80002c4c:	892a                	mv	s2,a0
    80002c4e:	c501                	beqz	a0,80002c56 <usertrap+0xa4>
  if(p->killed)
    80002c50:	549c                	lw	a5,40(s1)
    80002c52:	c3a1                	beqz	a5,80002c92 <usertrap+0xe0>
    80002c54:	a815                	j	80002c88 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c56:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002c5a:	5890                	lw	a2,48(s1)
    80002c5c:	00005517          	auipc	a0,0x5
    80002c60:	70c50513          	addi	a0,a0,1804 # 80008368 <states.0+0x78>
    80002c64:	ffffe097          	auipc	ra,0xffffe
    80002c68:	910080e7          	jalr	-1776(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c6c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002c70:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002c74:	00005517          	auipc	a0,0x5
    80002c78:	72450513          	addi	a0,a0,1828 # 80008398 <states.0+0xa8>
    80002c7c:	ffffe097          	auipc	ra,0xffffe
    80002c80:	8f8080e7          	jalr	-1800(ra) # 80000574 <printf>
    p->killed = 1;
    80002c84:	4785                	li	a5,1
    80002c86:	d49c                	sw	a5,40(s1)
    exit(-1);
    80002c88:	557d                	li	a0,-1
    80002c8a:	fffff097          	auipc	ra,0xfffff
    80002c8e:	6b4080e7          	jalr	1716(ra) # 8000233e <exit>
  if(which_dev == 2)
    80002c92:	4789                	li	a5,2
    80002c94:	f8f910e3          	bne	s2,a5,80002c14 <usertrap+0x62>
    yield();
    80002c98:	fffff097          	auipc	ra,0xfffff
    80002c9c:	40e080e7          	jalr	1038(ra) # 800020a6 <yield>
    80002ca0:	bf95                	j	80002c14 <usertrap+0x62>
  int which_dev = 0;
    80002ca2:	4901                	li	s2,0
    80002ca4:	b7d5                	j	80002c88 <usertrap+0xd6>

0000000080002ca6 <kerneltrap>:
{
    80002ca6:	7179                	addi	sp,sp,-48
    80002ca8:	f406                	sd	ra,40(sp)
    80002caa:	f022                	sd	s0,32(sp)
    80002cac:	ec26                	sd	s1,24(sp)
    80002cae:	e84a                	sd	s2,16(sp)
    80002cb0:	e44e                	sd	s3,8(sp)
    80002cb2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002cb4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cb8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002cbc:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002cc0:	1004f793          	andi	a5,s1,256
    80002cc4:	cb85                	beqz	a5,80002cf4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cc6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002cca:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002ccc:	ef85                	bnez	a5,80002d04 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002cce:	00000097          	auipc	ra,0x0
    80002cd2:	e42080e7          	jalr	-446(ra) # 80002b10 <devintr>
    80002cd6:	cd1d                	beqz	a0,80002d14 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002cd8:	4789                	li	a5,2
    80002cda:	06f50a63          	beq	a0,a5,80002d4e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002cde:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ce2:	10049073          	csrw	sstatus,s1
}
    80002ce6:	70a2                	ld	ra,40(sp)
    80002ce8:	7402                	ld	s0,32(sp)
    80002cea:	64e2                	ld	s1,24(sp)
    80002cec:	6942                	ld	s2,16(sp)
    80002cee:	69a2                	ld	s3,8(sp)
    80002cf0:	6145                	addi	sp,sp,48
    80002cf2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002cf4:	00005517          	auipc	a0,0x5
    80002cf8:	6c450513          	addi	a0,a0,1732 # 800083b8 <states.0+0xc8>
    80002cfc:	ffffe097          	auipc	ra,0xffffe
    80002d00:	82e080e7          	jalr	-2002(ra) # 8000052a <panic>
    panic("kerneltrap: interrupts enabled");
    80002d04:	00005517          	auipc	a0,0x5
    80002d08:	6dc50513          	addi	a0,a0,1756 # 800083e0 <states.0+0xf0>
    80002d0c:	ffffe097          	auipc	ra,0xffffe
    80002d10:	81e080e7          	jalr	-2018(ra) # 8000052a <panic>
    printf("scause %p\n", scause);
    80002d14:	85ce                	mv	a1,s3
    80002d16:	00005517          	auipc	a0,0x5
    80002d1a:	6ea50513          	addi	a0,a0,1770 # 80008400 <states.0+0x110>
    80002d1e:	ffffe097          	auipc	ra,0xffffe
    80002d22:	856080e7          	jalr	-1962(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d26:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d2a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d2e:	00005517          	auipc	a0,0x5
    80002d32:	6e250513          	addi	a0,a0,1762 # 80008410 <states.0+0x120>
    80002d36:	ffffe097          	auipc	ra,0xffffe
    80002d3a:	83e080e7          	jalr	-1986(ra) # 80000574 <printf>
    panic("kerneltrap");
    80002d3e:	00005517          	auipc	a0,0x5
    80002d42:	6ea50513          	addi	a0,a0,1770 # 80008428 <states.0+0x138>
    80002d46:	ffffd097          	auipc	ra,0xffffd
    80002d4a:	7e4080e7          	jalr	2020(ra) # 8000052a <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d4e:	fffff097          	auipc	ra,0xfffff
    80002d52:	c30080e7          	jalr	-976(ra) # 8000197e <myproc>
    80002d56:	d541                	beqz	a0,80002cde <kerneltrap+0x38>
    80002d58:	fffff097          	auipc	ra,0xfffff
    80002d5c:	c26080e7          	jalr	-986(ra) # 8000197e <myproc>
    80002d60:	4d18                	lw	a4,24(a0)
    80002d62:	4791                	li	a5,4
    80002d64:	f6f71de3          	bne	a4,a5,80002cde <kerneltrap+0x38>
    yield();
    80002d68:	fffff097          	auipc	ra,0xfffff
    80002d6c:	33e080e7          	jalr	830(ra) # 800020a6 <yield>
    80002d70:	b7bd                	j	80002cde <kerneltrap+0x38>

0000000080002d72 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002d72:	1101                	addi	sp,sp,-32
    80002d74:	ec06                	sd	ra,24(sp)
    80002d76:	e822                	sd	s0,16(sp)
    80002d78:	e426                	sd	s1,8(sp)
    80002d7a:	1000                	addi	s0,sp,32
    80002d7c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002d7e:	fffff097          	auipc	ra,0xfffff
    80002d82:	c00080e7          	jalr	-1024(ra) # 8000197e <myproc>
  switch (n) {
    80002d86:	4795                	li	a5,5
    80002d88:	0497e163          	bltu	a5,s1,80002dca <argraw+0x58>
    80002d8c:	048a                	slli	s1,s1,0x2
    80002d8e:	00005717          	auipc	a4,0x5
    80002d92:	6d270713          	addi	a4,a4,1746 # 80008460 <states.0+0x170>
    80002d96:	94ba                	add	s1,s1,a4
    80002d98:	409c                	lw	a5,0(s1)
    80002d9a:	97ba                	add	a5,a5,a4
    80002d9c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002d9e:	6d3c                	ld	a5,88(a0)
    80002da0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002da2:	60e2                	ld	ra,24(sp)
    80002da4:	6442                	ld	s0,16(sp)
    80002da6:	64a2                	ld	s1,8(sp)
    80002da8:	6105                	addi	sp,sp,32
    80002daa:	8082                	ret
    return p->trapframe->a1;
    80002dac:	6d3c                	ld	a5,88(a0)
    80002dae:	7fa8                	ld	a0,120(a5)
    80002db0:	bfcd                	j	80002da2 <argraw+0x30>
    return p->trapframe->a2;
    80002db2:	6d3c                	ld	a5,88(a0)
    80002db4:	63c8                	ld	a0,128(a5)
    80002db6:	b7f5                	j	80002da2 <argraw+0x30>
    return p->trapframe->a3;
    80002db8:	6d3c                	ld	a5,88(a0)
    80002dba:	67c8                	ld	a0,136(a5)
    80002dbc:	b7dd                	j	80002da2 <argraw+0x30>
    return p->trapframe->a4;
    80002dbe:	6d3c                	ld	a5,88(a0)
    80002dc0:	6bc8                	ld	a0,144(a5)
    80002dc2:	b7c5                	j	80002da2 <argraw+0x30>
    return p->trapframe->a5;
    80002dc4:	6d3c                	ld	a5,88(a0)
    80002dc6:	6fc8                	ld	a0,152(a5)
    80002dc8:	bfe9                	j	80002da2 <argraw+0x30>
  panic("argraw");
    80002dca:	00005517          	auipc	a0,0x5
    80002dce:	66e50513          	addi	a0,a0,1646 # 80008438 <states.0+0x148>
    80002dd2:	ffffd097          	auipc	ra,0xffffd
    80002dd6:	758080e7          	jalr	1880(ra) # 8000052a <panic>

0000000080002dda <fetchaddr>:
{
    80002dda:	1101                	addi	sp,sp,-32
    80002ddc:	ec06                	sd	ra,24(sp)
    80002dde:	e822                	sd	s0,16(sp)
    80002de0:	e426                	sd	s1,8(sp)
    80002de2:	e04a                	sd	s2,0(sp)
    80002de4:	1000                	addi	s0,sp,32
    80002de6:	84aa                	mv	s1,a0
    80002de8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002dea:	fffff097          	auipc	ra,0xfffff
    80002dee:	b94080e7          	jalr	-1132(ra) # 8000197e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002df2:	653c                	ld	a5,72(a0)
    80002df4:	02f4f863          	bgeu	s1,a5,80002e24 <fetchaddr+0x4a>
    80002df8:	00848713          	addi	a4,s1,8
    80002dfc:	02e7e663          	bltu	a5,a4,80002e28 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002e00:	46a1                	li	a3,8
    80002e02:	8626                	mv	a2,s1
    80002e04:	85ca                	mv	a1,s2
    80002e06:	6928                	ld	a0,80(a0)
    80002e08:	fffff097          	auipc	ra,0xfffff
    80002e0c:	8c2080e7          	jalr	-1854(ra) # 800016ca <copyin>
    80002e10:	00a03533          	snez	a0,a0
    80002e14:	40a00533          	neg	a0,a0
}
    80002e18:	60e2                	ld	ra,24(sp)
    80002e1a:	6442                	ld	s0,16(sp)
    80002e1c:	64a2                	ld	s1,8(sp)
    80002e1e:	6902                	ld	s2,0(sp)
    80002e20:	6105                	addi	sp,sp,32
    80002e22:	8082                	ret
    return -1;
    80002e24:	557d                	li	a0,-1
    80002e26:	bfcd                	j	80002e18 <fetchaddr+0x3e>
    80002e28:	557d                	li	a0,-1
    80002e2a:	b7fd                	j	80002e18 <fetchaddr+0x3e>

0000000080002e2c <fetchstr>:
{
    80002e2c:	7179                	addi	sp,sp,-48
    80002e2e:	f406                	sd	ra,40(sp)
    80002e30:	f022                	sd	s0,32(sp)
    80002e32:	ec26                	sd	s1,24(sp)
    80002e34:	e84a                	sd	s2,16(sp)
    80002e36:	e44e                	sd	s3,8(sp)
    80002e38:	1800                	addi	s0,sp,48
    80002e3a:	892a                	mv	s2,a0
    80002e3c:	84ae                	mv	s1,a1
    80002e3e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002e40:	fffff097          	auipc	ra,0xfffff
    80002e44:	b3e080e7          	jalr	-1218(ra) # 8000197e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002e48:	86ce                	mv	a3,s3
    80002e4a:	864a                	mv	a2,s2
    80002e4c:	85a6                	mv	a1,s1
    80002e4e:	6928                	ld	a0,80(a0)
    80002e50:	fffff097          	auipc	ra,0xfffff
    80002e54:	908080e7          	jalr	-1784(ra) # 80001758 <copyinstr>
  if(err < 0)
    80002e58:	00054763          	bltz	a0,80002e66 <fetchstr+0x3a>
  return strlen(buf);
    80002e5c:	8526                	mv	a0,s1
    80002e5e:	ffffe097          	auipc	ra,0xffffe
    80002e62:	fe4080e7          	jalr	-28(ra) # 80000e42 <strlen>
}
    80002e66:	70a2                	ld	ra,40(sp)
    80002e68:	7402                	ld	s0,32(sp)
    80002e6a:	64e2                	ld	s1,24(sp)
    80002e6c:	6942                	ld	s2,16(sp)
    80002e6e:	69a2                	ld	s3,8(sp)
    80002e70:	6145                	addi	sp,sp,48
    80002e72:	8082                	ret

0000000080002e74 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002e74:	1101                	addi	sp,sp,-32
    80002e76:	ec06                	sd	ra,24(sp)
    80002e78:	e822                	sd	s0,16(sp)
    80002e7a:	e426                	sd	s1,8(sp)
    80002e7c:	1000                	addi	s0,sp,32
    80002e7e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002e80:	00000097          	auipc	ra,0x0
    80002e84:	ef2080e7          	jalr	-270(ra) # 80002d72 <argraw>
    80002e88:	c088                	sw	a0,0(s1)
  return 0;
}
    80002e8a:	4501                	li	a0,0
    80002e8c:	60e2                	ld	ra,24(sp)
    80002e8e:	6442                	ld	s0,16(sp)
    80002e90:	64a2                	ld	s1,8(sp)
    80002e92:	6105                	addi	sp,sp,32
    80002e94:	8082                	ret

0000000080002e96 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002e96:	1101                	addi	sp,sp,-32
    80002e98:	ec06                	sd	ra,24(sp)
    80002e9a:	e822                	sd	s0,16(sp)
    80002e9c:	e426                	sd	s1,8(sp)
    80002e9e:	1000                	addi	s0,sp,32
    80002ea0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ea2:	00000097          	auipc	ra,0x0
    80002ea6:	ed0080e7          	jalr	-304(ra) # 80002d72 <argraw>
    80002eaa:	e088                	sd	a0,0(s1)
  return 0;
}
    80002eac:	4501                	li	a0,0
    80002eae:	60e2                	ld	ra,24(sp)
    80002eb0:	6442                	ld	s0,16(sp)
    80002eb2:	64a2                	ld	s1,8(sp)
    80002eb4:	6105                	addi	sp,sp,32
    80002eb6:	8082                	ret

0000000080002eb8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002eb8:	1101                	addi	sp,sp,-32
    80002eba:	ec06                	sd	ra,24(sp)
    80002ebc:	e822                	sd	s0,16(sp)
    80002ebe:	e426                	sd	s1,8(sp)
    80002ec0:	e04a                	sd	s2,0(sp)
    80002ec2:	1000                	addi	s0,sp,32
    80002ec4:	84ae                	mv	s1,a1
    80002ec6:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002ec8:	00000097          	auipc	ra,0x0
    80002ecc:	eaa080e7          	jalr	-342(ra) # 80002d72 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002ed0:	864a                	mv	a2,s2
    80002ed2:	85a6                	mv	a1,s1
    80002ed4:	00000097          	auipc	ra,0x0
    80002ed8:	f58080e7          	jalr	-168(ra) # 80002e2c <fetchstr>
}
    80002edc:	60e2                	ld	ra,24(sp)
    80002ede:	6442                	ld	s0,16(sp)
    80002ee0:	64a2                	ld	s1,8(sp)
    80002ee2:	6902                	ld	s2,0(sp)
    80002ee4:	6105                	addi	sp,sp,32
    80002ee6:	8082                	ret

0000000080002ee8 <syscall>:
[SYS_sigret]   sys_sigret,
};

void
syscall(void)
{
    80002ee8:	1101                	addi	sp,sp,-32
    80002eea:	ec06                	sd	ra,24(sp)
    80002eec:	e822                	sd	s0,16(sp)
    80002eee:	e426                	sd	s1,8(sp)
    80002ef0:	e04a                	sd	s2,0(sp)
    80002ef2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002ef4:	fffff097          	auipc	ra,0xfffff
    80002ef8:	a8a080e7          	jalr	-1398(ra) # 8000197e <myproc>
    80002efc:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002efe:	05853903          	ld	s2,88(a0)
    80002f02:	0a893783          	ld	a5,168(s2) # 800a8 <_entry-0x7ff7ff58>
    80002f06:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002f0a:	37fd                	addiw	a5,a5,-1
    80002f0c:	475d                	li	a4,23
    80002f0e:	00f76f63          	bltu	a4,a5,80002f2c <syscall+0x44>
    80002f12:	00369713          	slli	a4,a3,0x3
    80002f16:	00005797          	auipc	a5,0x5
    80002f1a:	56278793          	addi	a5,a5,1378 # 80008478 <syscalls>
    80002f1e:	97ba                	add	a5,a5,a4
    80002f20:	639c                	ld	a5,0(a5)
    80002f22:	c789                	beqz	a5,80002f2c <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002f24:	9782                	jalr	a5
    80002f26:	06a93823          	sd	a0,112(s2)
    80002f2a:	a839                	j	80002f48 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002f2c:	15848613          	addi	a2,s1,344
    80002f30:	588c                	lw	a1,48(s1)
    80002f32:	00005517          	auipc	a0,0x5
    80002f36:	50e50513          	addi	a0,a0,1294 # 80008440 <states.0+0x150>
    80002f3a:	ffffd097          	auipc	ra,0xffffd
    80002f3e:	63a080e7          	jalr	1594(ra) # 80000574 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002f42:	6cbc                	ld	a5,88(s1)
    80002f44:	577d                	li	a4,-1
    80002f46:	fbb8                	sd	a4,112(a5)
  }
}
    80002f48:	60e2                	ld	ra,24(sp)
    80002f4a:	6442                	ld	s0,16(sp)
    80002f4c:	64a2                	ld	s1,8(sp)
    80002f4e:	6902                	ld	s2,0(sp)
    80002f50:	6105                	addi	sp,sp,32
    80002f52:	8082                	ret

0000000080002f54 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002f54:	1101                	addi	sp,sp,-32
    80002f56:	ec06                	sd	ra,24(sp)
    80002f58:	e822                	sd	s0,16(sp)
    80002f5a:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002f5c:	fec40593          	addi	a1,s0,-20
    80002f60:	4501                	li	a0,0
    80002f62:	00000097          	auipc	ra,0x0
    80002f66:	f12080e7          	jalr	-238(ra) # 80002e74 <argint>
    return -1;
    80002f6a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002f6c:	00054963          	bltz	a0,80002f7e <sys_exit+0x2a>
  exit(n);
    80002f70:	fec42503          	lw	a0,-20(s0)
    80002f74:	fffff097          	auipc	ra,0xfffff
    80002f78:	3ca080e7          	jalr	970(ra) # 8000233e <exit>
  return 0;  // not reached
    80002f7c:	4781                	li	a5,0
}
    80002f7e:	853e                	mv	a0,a5
    80002f80:	60e2                	ld	ra,24(sp)
    80002f82:	6442                	ld	s0,16(sp)
    80002f84:	6105                	addi	sp,sp,32
    80002f86:	8082                	ret

0000000080002f88 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002f88:	1141                	addi	sp,sp,-16
    80002f8a:	e406                	sd	ra,8(sp)
    80002f8c:	e022                	sd	s0,0(sp)
    80002f8e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002f90:	fffff097          	auipc	ra,0xfffff
    80002f94:	9ee080e7          	jalr	-1554(ra) # 8000197e <myproc>
}
    80002f98:	5908                	lw	a0,48(a0)
    80002f9a:	60a2                	ld	ra,8(sp)
    80002f9c:	6402                	ld	s0,0(sp)
    80002f9e:	0141                	addi	sp,sp,16
    80002fa0:	8082                	ret

0000000080002fa2 <sys_fork>:

uint64
sys_fork(void)
{
    80002fa2:	1141                	addi	sp,sp,-16
    80002fa4:	e406                	sd	ra,8(sp)
    80002fa6:	e022                	sd	s0,0(sp)
    80002fa8:	0800                	addi	s0,sp,16
  return fork();
    80002faa:	fffff097          	auipc	ra,0xfffff
    80002fae:	e12080e7          	jalr	-494(ra) # 80001dbc <fork>
}
    80002fb2:	60a2                	ld	ra,8(sp)
    80002fb4:	6402                	ld	s0,0(sp)
    80002fb6:	0141                	addi	sp,sp,16
    80002fb8:	8082                	ret

0000000080002fba <sys_wait>:

uint64
sys_wait(void)
{
    80002fba:	1101                	addi	sp,sp,-32
    80002fbc:	ec06                	sd	ra,24(sp)
    80002fbe:	e822                	sd	s0,16(sp)
    80002fc0:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002fc2:	fe840593          	addi	a1,s0,-24
    80002fc6:	4501                	li	a0,0
    80002fc8:	00000097          	auipc	ra,0x0
    80002fcc:	ece080e7          	jalr	-306(ra) # 80002e96 <argaddr>
    80002fd0:	87aa                	mv	a5,a0
    return -1;
    80002fd2:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002fd4:	0007c863          	bltz	a5,80002fe4 <sys_wait+0x2a>
  return wait(p);
    80002fd8:	fe843503          	ld	a0,-24(s0)
    80002fdc:	fffff097          	auipc	ra,0xfffff
    80002fe0:	16a080e7          	jalr	362(ra) # 80002146 <wait>
}
    80002fe4:	60e2                	ld	ra,24(sp)
    80002fe6:	6442                	ld	s0,16(sp)
    80002fe8:	6105                	addi	sp,sp,32
    80002fea:	8082                	ret

0000000080002fec <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002fec:	7179                	addi	sp,sp,-48
    80002fee:	f406                	sd	ra,40(sp)
    80002ff0:	f022                	sd	s0,32(sp)
    80002ff2:	ec26                	sd	s1,24(sp)
    80002ff4:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002ff6:	fdc40593          	addi	a1,s0,-36
    80002ffa:	4501                	li	a0,0
    80002ffc:	00000097          	auipc	ra,0x0
    80003000:	e78080e7          	jalr	-392(ra) # 80002e74 <argint>
    return -1;
    80003004:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80003006:	00054f63          	bltz	a0,80003024 <sys_sbrk+0x38>
  addr = myproc()->sz;
    8000300a:	fffff097          	auipc	ra,0xfffff
    8000300e:	974080e7          	jalr	-1676(ra) # 8000197e <myproc>
    80003012:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80003014:	fdc42503          	lw	a0,-36(s0)
    80003018:	fffff097          	auipc	ra,0xfffff
    8000301c:	d30080e7          	jalr	-720(ra) # 80001d48 <growproc>
    80003020:	00054863          	bltz	a0,80003030 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80003024:	8526                	mv	a0,s1
    80003026:	70a2                	ld	ra,40(sp)
    80003028:	7402                	ld	s0,32(sp)
    8000302a:	64e2                	ld	s1,24(sp)
    8000302c:	6145                	addi	sp,sp,48
    8000302e:	8082                	ret
    return -1;
    80003030:	54fd                	li	s1,-1
    80003032:	bfcd                	j	80003024 <sys_sbrk+0x38>

0000000080003034 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003034:	7139                	addi	sp,sp,-64
    80003036:	fc06                	sd	ra,56(sp)
    80003038:	f822                	sd	s0,48(sp)
    8000303a:	f426                	sd	s1,40(sp)
    8000303c:	f04a                	sd	s2,32(sp)
    8000303e:	ec4e                	sd	s3,24(sp)
    80003040:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80003042:	fcc40593          	addi	a1,s0,-52
    80003046:	4501                	li	a0,0
    80003048:	00000097          	auipc	ra,0x0
    8000304c:	e2c080e7          	jalr	-468(ra) # 80002e74 <argint>
    return -1;
    80003050:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80003052:	06054563          	bltz	a0,800030bc <sys_sleep+0x88>
  acquire(&tickslock);
    80003056:	0001f517          	auipc	a0,0x1f
    8000305a:	e7a50513          	addi	a0,a0,-390 # 80021ed0 <tickslock>
    8000305e:	ffffe097          	auipc	ra,0xffffe
    80003062:	b64080e7          	jalr	-1180(ra) # 80000bc2 <acquire>
  ticks0 = ticks;
    80003066:	00006917          	auipc	s2,0x6
    8000306a:	fca92903          	lw	s2,-54(s2) # 80009030 <ticks>
  while(ticks - ticks0 < n){
    8000306e:	fcc42783          	lw	a5,-52(s0)
    80003072:	cf85                	beqz	a5,800030aa <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003074:	0001f997          	auipc	s3,0x1f
    80003078:	e5c98993          	addi	s3,s3,-420 # 80021ed0 <tickslock>
    8000307c:	00006497          	auipc	s1,0x6
    80003080:	fb448493          	addi	s1,s1,-76 # 80009030 <ticks>
    if(myproc()->killed){
    80003084:	fffff097          	auipc	ra,0xfffff
    80003088:	8fa080e7          	jalr	-1798(ra) # 8000197e <myproc>
    8000308c:	551c                	lw	a5,40(a0)
    8000308e:	ef9d                	bnez	a5,800030cc <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80003090:	85ce                	mv	a1,s3
    80003092:	8526                	mv	a0,s1
    80003094:	fffff097          	auipc	ra,0xfffff
    80003098:	04e080e7          	jalr	78(ra) # 800020e2 <sleep>
  while(ticks - ticks0 < n){
    8000309c:	409c                	lw	a5,0(s1)
    8000309e:	412787bb          	subw	a5,a5,s2
    800030a2:	fcc42703          	lw	a4,-52(s0)
    800030a6:	fce7efe3          	bltu	a5,a4,80003084 <sys_sleep+0x50>
  }
  release(&tickslock);
    800030aa:	0001f517          	auipc	a0,0x1f
    800030ae:	e2650513          	addi	a0,a0,-474 # 80021ed0 <tickslock>
    800030b2:	ffffe097          	auipc	ra,0xffffe
    800030b6:	bc4080e7          	jalr	-1084(ra) # 80000c76 <release>
  return 0;
    800030ba:	4781                	li	a5,0
}
    800030bc:	853e                	mv	a0,a5
    800030be:	70e2                	ld	ra,56(sp)
    800030c0:	7442                	ld	s0,48(sp)
    800030c2:	74a2                	ld	s1,40(sp)
    800030c4:	7902                	ld	s2,32(sp)
    800030c6:	69e2                	ld	s3,24(sp)
    800030c8:	6121                	addi	sp,sp,64
    800030ca:	8082                	ret
      release(&tickslock);
    800030cc:	0001f517          	auipc	a0,0x1f
    800030d0:	e0450513          	addi	a0,a0,-508 # 80021ed0 <tickslock>
    800030d4:	ffffe097          	auipc	ra,0xffffe
    800030d8:	ba2080e7          	jalr	-1118(ra) # 80000c76 <release>
      return -1;
    800030dc:	57fd                	li	a5,-1
    800030de:	bff9                	j	800030bc <sys_sleep+0x88>

00000000800030e0 <sys_kill>:

uint64
sys_kill(void)
{
    800030e0:	1101                	addi	sp,sp,-32
    800030e2:	ec06                	sd	ra,24(sp)
    800030e4:	e822                	sd	s0,16(sp)
    800030e6:	1000                	addi	s0,sp,32
  int pid;
  int signum;

  if(argint(0, &pid) < 0 || argint(1, &signum) < 0)
    800030e8:	fec40593          	addi	a1,s0,-20
    800030ec:	4501                	li	a0,0
    800030ee:	00000097          	auipc	ra,0x0
    800030f2:	d86080e7          	jalr	-634(ra) # 80002e74 <argint>
    return -1;
    800030f6:	57fd                	li	a5,-1
  if(argint(0, &pid) < 0 || argint(1, &signum) < 0)
    800030f8:	02054563          	bltz	a0,80003122 <sys_kill+0x42>
    800030fc:	fe840593          	addi	a1,s0,-24
    80003100:	4505                	li	a0,1
    80003102:	00000097          	auipc	ra,0x0
    80003106:	d72080e7          	jalr	-654(ra) # 80002e74 <argint>
    return -1;
    8000310a:	57fd                	li	a5,-1
  if(argint(0, &pid) < 0 || argint(1, &signum) < 0)
    8000310c:	00054b63          	bltz	a0,80003122 <sys_kill+0x42>
  return kill(pid, signum);
    80003110:	fe842583          	lw	a1,-24(s0)
    80003114:	fec42503          	lw	a0,-20(s0)
    80003118:	fffff097          	auipc	ra,0xfffff
    8000311c:	2fc080e7          	jalr	764(ra) # 80002414 <kill>
    80003120:	87aa                	mv	a5,a0
}
    80003122:	853e                	mv	a0,a5
    80003124:	60e2                	ld	ra,24(sp)
    80003126:	6442                	ld	s0,16(sp)
    80003128:	6105                	addi	sp,sp,32
    8000312a:	8082                	ret

000000008000312c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000312c:	1101                	addi	sp,sp,-32
    8000312e:	ec06                	sd	ra,24(sp)
    80003130:	e822                	sd	s0,16(sp)
    80003132:	e426                	sd	s1,8(sp)
    80003134:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003136:	0001f517          	auipc	a0,0x1f
    8000313a:	d9a50513          	addi	a0,a0,-614 # 80021ed0 <tickslock>
    8000313e:	ffffe097          	auipc	ra,0xffffe
    80003142:	a84080e7          	jalr	-1404(ra) # 80000bc2 <acquire>
  xticks = ticks;
    80003146:	00006497          	auipc	s1,0x6
    8000314a:	eea4a483          	lw	s1,-278(s1) # 80009030 <ticks>
  release(&tickslock);
    8000314e:	0001f517          	auipc	a0,0x1f
    80003152:	d8250513          	addi	a0,a0,-638 # 80021ed0 <tickslock>
    80003156:	ffffe097          	auipc	ra,0xffffe
    8000315a:	b20080e7          	jalr	-1248(ra) # 80000c76 <release>
  return xticks;
}
    8000315e:	02049513          	slli	a0,s1,0x20
    80003162:	9101                	srli	a0,a0,0x20
    80003164:	60e2                	ld	ra,24(sp)
    80003166:	6442                	ld	s0,16(sp)
    80003168:	64a2                	ld	s1,8(sp)
    8000316a:	6105                	addi	sp,sp,32
    8000316c:	8082                	ret

000000008000316e <sys_sigprocmask>:


/* sig proc mask*/
uint64
sys_sigprocmask(void)
{
    8000316e:	1101                	addi	sp,sp,-32
    80003170:	ec06                	sd	ra,24(sp)
    80003172:	e822                	sd	s0,16(sp)
    80003174:	1000                	addi	s0,sp,32
  int mask;

  if(argint(0, &mask) < 0)
    80003176:	fec40593          	addi	a1,s0,-20
    8000317a:	4501                	li	a0,0
    8000317c:	00000097          	auipc	ra,0x0
    80003180:	cf8080e7          	jalr	-776(ra) # 80002e74 <argint>
    80003184:	87aa                	mv	a5,a0
    return -1;
    80003186:	557d                	li	a0,-1
  if(argint(0, &mask) < 0)
    80003188:	0007ca63          	bltz	a5,8000319c <sys_sigprocmask+0x2e>
  
  return sigprocmask(mask);
    8000318c:	fec42503          	lw	a0,-20(s0)
    80003190:	fffff097          	auipc	ra,0xfffff
    80003194:	478080e7          	jalr	1144(ra) # 80002608 <sigprocmask>
    80003198:	1502                	slli	a0,a0,0x20
    8000319a:	9101                	srli	a0,a0,0x20
}
    8000319c:	60e2                	ld	ra,24(sp)
    8000319e:	6442                	ld	s0,16(sp)
    800031a0:	6105                	addi	sp,sp,32
    800031a2:	8082                	ret

00000000800031a4 <sys_sigaction>:
//   return sigaction (signum,act,oldact);
// }

uint64
sys_sigaction(void)
{
    800031a4:	7179                	addi	sp,sp,-48
    800031a6:	f406                	sd	ra,40(sp)
    800031a8:	f022                	sd	s0,32(sp)
    800031aa:	1800                	addi	s0,sp,48
  int signum;
  uint64 act;
  uint64 oldact;
  if(argint(0, &signum) < 0)
    800031ac:	fec40593          	addi	a1,s0,-20
    800031b0:	4501                	li	a0,0
    800031b2:	00000097          	auipc	ra,0x0
    800031b6:	cc2080e7          	jalr	-830(ra) # 80002e74 <argint>
    return -1;
    800031ba:	57fd                	li	a5,-1
  if(argint(0, &signum) < 0)
    800031bc:	04054163          	bltz	a0,800031fe <sys_sigaction+0x5a>
  if(argaddr(1, &act) < 0)
    800031c0:	fe040593          	addi	a1,s0,-32
    800031c4:	4505                	li	a0,1
    800031c6:	00000097          	auipc	ra,0x0
    800031ca:	cd0080e7          	jalr	-816(ra) # 80002e96 <argaddr>
    return -1;
    800031ce:	57fd                	li	a5,-1
  if(argaddr(1, &act) < 0)
    800031d0:	02054763          	bltz	a0,800031fe <sys_sigaction+0x5a>
  if(argaddr(2, &oldact) < 0)
    800031d4:	fd840593          	addi	a1,s0,-40
    800031d8:	4509                	li	a0,2
    800031da:	00000097          	auipc	ra,0x0
    800031de:	cbc080e7          	jalr	-836(ra) # 80002e96 <argaddr>
    return -1;
    800031e2:	57fd                	li	a5,-1
  if(argaddr(2, &oldact) < 0)
    800031e4:	00054d63          	bltz	a0,800031fe <sys_sigaction+0x5a>

  return sigaction (signum,(struct sigaction*)act,(struct sigaction*)oldact);
    800031e8:	fd843603          	ld	a2,-40(s0)
    800031ec:	fe043583          	ld	a1,-32(s0)
    800031f0:	fec42503          	lw	a0,-20(s0)
    800031f4:	fffff097          	auipc	ra,0xfffff
    800031f8:	43c080e7          	jalr	1084(ra) # 80002630 <sigaction>
    800031fc:	87aa                	mv	a5,a0
}
    800031fe:	853e                	mv	a0,a5
    80003200:	70a2                	ld	ra,40(sp)
    80003202:	7402                	ld	s0,32(sp)
    80003204:	6145                	addi	sp,sp,48
    80003206:	8082                	ret

0000000080003208 <sys_sigret>:

uint64
sys_sigret(void)
{
    80003208:	1141                	addi	sp,sp,-16
    8000320a:	e406                	sd	ra,8(sp)
    8000320c:	e022                	sd	s0,0(sp)
    8000320e:	0800                	addi	s0,sp,16
  sigret();
    80003210:	fffff097          	auipc	ra,0xfffff
    80003214:	510080e7          	jalr	1296(ra) # 80002720 <sigret>
  return 0;
}
    80003218:	4501                	li	a0,0
    8000321a:	60a2                	ld	ra,8(sp)
    8000321c:	6402                	ld	s0,0(sp)
    8000321e:	0141                	addi	sp,sp,16
    80003220:	8082                	ret

0000000080003222 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003222:	7179                	addi	sp,sp,-48
    80003224:	f406                	sd	ra,40(sp)
    80003226:	f022                	sd	s0,32(sp)
    80003228:	ec26                	sd	s1,24(sp)
    8000322a:	e84a                	sd	s2,16(sp)
    8000322c:	e44e                	sd	s3,8(sp)
    8000322e:	e052                	sd	s4,0(sp)
    80003230:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003232:	00005597          	auipc	a1,0x5
    80003236:	30e58593          	addi	a1,a1,782 # 80008540 <syscalls+0xc8>
    8000323a:	0001f517          	auipc	a0,0x1f
    8000323e:	cae50513          	addi	a0,a0,-850 # 80021ee8 <bcache>
    80003242:	ffffe097          	auipc	ra,0xffffe
    80003246:	8f0080e7          	jalr	-1808(ra) # 80000b32 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000324a:	00027797          	auipc	a5,0x27
    8000324e:	c9e78793          	addi	a5,a5,-866 # 80029ee8 <bcache+0x8000>
    80003252:	00027717          	auipc	a4,0x27
    80003256:	efe70713          	addi	a4,a4,-258 # 8002a150 <bcache+0x8268>
    8000325a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000325e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003262:	0001f497          	auipc	s1,0x1f
    80003266:	c9e48493          	addi	s1,s1,-866 # 80021f00 <bcache+0x18>
    b->next = bcache.head.next;
    8000326a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000326c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000326e:	00005a17          	auipc	s4,0x5
    80003272:	2daa0a13          	addi	s4,s4,730 # 80008548 <syscalls+0xd0>
    b->next = bcache.head.next;
    80003276:	2b893783          	ld	a5,696(s2)
    8000327a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000327c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003280:	85d2                	mv	a1,s4
    80003282:	01048513          	addi	a0,s1,16
    80003286:	00001097          	auipc	ra,0x1
    8000328a:	4c2080e7          	jalr	1218(ra) # 80004748 <initsleeplock>
    bcache.head.next->prev = b;
    8000328e:	2b893783          	ld	a5,696(s2)
    80003292:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003294:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003298:	45848493          	addi	s1,s1,1112
    8000329c:	fd349de3          	bne	s1,s3,80003276 <binit+0x54>
  }
}
    800032a0:	70a2                	ld	ra,40(sp)
    800032a2:	7402                	ld	s0,32(sp)
    800032a4:	64e2                	ld	s1,24(sp)
    800032a6:	6942                	ld	s2,16(sp)
    800032a8:	69a2                	ld	s3,8(sp)
    800032aa:	6a02                	ld	s4,0(sp)
    800032ac:	6145                	addi	sp,sp,48
    800032ae:	8082                	ret

00000000800032b0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800032b0:	7179                	addi	sp,sp,-48
    800032b2:	f406                	sd	ra,40(sp)
    800032b4:	f022                	sd	s0,32(sp)
    800032b6:	ec26                	sd	s1,24(sp)
    800032b8:	e84a                	sd	s2,16(sp)
    800032ba:	e44e                	sd	s3,8(sp)
    800032bc:	1800                	addi	s0,sp,48
    800032be:	892a                	mv	s2,a0
    800032c0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800032c2:	0001f517          	auipc	a0,0x1f
    800032c6:	c2650513          	addi	a0,a0,-986 # 80021ee8 <bcache>
    800032ca:	ffffe097          	auipc	ra,0xffffe
    800032ce:	8f8080e7          	jalr	-1800(ra) # 80000bc2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800032d2:	00027497          	auipc	s1,0x27
    800032d6:	ece4b483          	ld	s1,-306(s1) # 8002a1a0 <bcache+0x82b8>
    800032da:	00027797          	auipc	a5,0x27
    800032de:	e7678793          	addi	a5,a5,-394 # 8002a150 <bcache+0x8268>
    800032e2:	02f48f63          	beq	s1,a5,80003320 <bread+0x70>
    800032e6:	873e                	mv	a4,a5
    800032e8:	a021                	j	800032f0 <bread+0x40>
    800032ea:	68a4                	ld	s1,80(s1)
    800032ec:	02e48a63          	beq	s1,a4,80003320 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800032f0:	449c                	lw	a5,8(s1)
    800032f2:	ff279ce3          	bne	a5,s2,800032ea <bread+0x3a>
    800032f6:	44dc                	lw	a5,12(s1)
    800032f8:	ff3799e3          	bne	a5,s3,800032ea <bread+0x3a>
      b->refcnt++;
    800032fc:	40bc                	lw	a5,64(s1)
    800032fe:	2785                	addiw	a5,a5,1
    80003300:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003302:	0001f517          	auipc	a0,0x1f
    80003306:	be650513          	addi	a0,a0,-1050 # 80021ee8 <bcache>
    8000330a:	ffffe097          	auipc	ra,0xffffe
    8000330e:	96c080e7          	jalr	-1684(ra) # 80000c76 <release>
      acquiresleep(&b->lock);
    80003312:	01048513          	addi	a0,s1,16
    80003316:	00001097          	auipc	ra,0x1
    8000331a:	46c080e7          	jalr	1132(ra) # 80004782 <acquiresleep>
      return b;
    8000331e:	a8b9                	j	8000337c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003320:	00027497          	auipc	s1,0x27
    80003324:	e784b483          	ld	s1,-392(s1) # 8002a198 <bcache+0x82b0>
    80003328:	00027797          	auipc	a5,0x27
    8000332c:	e2878793          	addi	a5,a5,-472 # 8002a150 <bcache+0x8268>
    80003330:	00f48863          	beq	s1,a5,80003340 <bread+0x90>
    80003334:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003336:	40bc                	lw	a5,64(s1)
    80003338:	cf81                	beqz	a5,80003350 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000333a:	64a4                	ld	s1,72(s1)
    8000333c:	fee49de3          	bne	s1,a4,80003336 <bread+0x86>
  panic("bget: no buffers");
    80003340:	00005517          	auipc	a0,0x5
    80003344:	21050513          	addi	a0,a0,528 # 80008550 <syscalls+0xd8>
    80003348:	ffffd097          	auipc	ra,0xffffd
    8000334c:	1e2080e7          	jalr	482(ra) # 8000052a <panic>
      b->dev = dev;
    80003350:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003354:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003358:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000335c:	4785                	li	a5,1
    8000335e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003360:	0001f517          	auipc	a0,0x1f
    80003364:	b8850513          	addi	a0,a0,-1144 # 80021ee8 <bcache>
    80003368:	ffffe097          	auipc	ra,0xffffe
    8000336c:	90e080e7          	jalr	-1778(ra) # 80000c76 <release>
      acquiresleep(&b->lock);
    80003370:	01048513          	addi	a0,s1,16
    80003374:	00001097          	auipc	ra,0x1
    80003378:	40e080e7          	jalr	1038(ra) # 80004782 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000337c:	409c                	lw	a5,0(s1)
    8000337e:	cb89                	beqz	a5,80003390 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003380:	8526                	mv	a0,s1
    80003382:	70a2                	ld	ra,40(sp)
    80003384:	7402                	ld	s0,32(sp)
    80003386:	64e2                	ld	s1,24(sp)
    80003388:	6942                	ld	s2,16(sp)
    8000338a:	69a2                	ld	s3,8(sp)
    8000338c:	6145                	addi	sp,sp,48
    8000338e:	8082                	ret
    virtio_disk_rw(b, 0);
    80003390:	4581                	li	a1,0
    80003392:	8526                	mv	a0,s1
    80003394:	00003097          	auipc	ra,0x3
    80003398:	f48080e7          	jalr	-184(ra) # 800062dc <virtio_disk_rw>
    b->valid = 1;
    8000339c:	4785                	li	a5,1
    8000339e:	c09c                	sw	a5,0(s1)
  return b;
    800033a0:	b7c5                	j	80003380 <bread+0xd0>

00000000800033a2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800033a2:	1101                	addi	sp,sp,-32
    800033a4:	ec06                	sd	ra,24(sp)
    800033a6:	e822                	sd	s0,16(sp)
    800033a8:	e426                	sd	s1,8(sp)
    800033aa:	1000                	addi	s0,sp,32
    800033ac:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800033ae:	0541                	addi	a0,a0,16
    800033b0:	00001097          	auipc	ra,0x1
    800033b4:	46c080e7          	jalr	1132(ra) # 8000481c <holdingsleep>
    800033b8:	cd01                	beqz	a0,800033d0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800033ba:	4585                	li	a1,1
    800033bc:	8526                	mv	a0,s1
    800033be:	00003097          	auipc	ra,0x3
    800033c2:	f1e080e7          	jalr	-226(ra) # 800062dc <virtio_disk_rw>
}
    800033c6:	60e2                	ld	ra,24(sp)
    800033c8:	6442                	ld	s0,16(sp)
    800033ca:	64a2                	ld	s1,8(sp)
    800033cc:	6105                	addi	sp,sp,32
    800033ce:	8082                	ret
    panic("bwrite");
    800033d0:	00005517          	auipc	a0,0x5
    800033d4:	19850513          	addi	a0,a0,408 # 80008568 <syscalls+0xf0>
    800033d8:	ffffd097          	auipc	ra,0xffffd
    800033dc:	152080e7          	jalr	338(ra) # 8000052a <panic>

00000000800033e0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800033e0:	1101                	addi	sp,sp,-32
    800033e2:	ec06                	sd	ra,24(sp)
    800033e4:	e822                	sd	s0,16(sp)
    800033e6:	e426                	sd	s1,8(sp)
    800033e8:	e04a                	sd	s2,0(sp)
    800033ea:	1000                	addi	s0,sp,32
    800033ec:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800033ee:	01050913          	addi	s2,a0,16
    800033f2:	854a                	mv	a0,s2
    800033f4:	00001097          	auipc	ra,0x1
    800033f8:	428080e7          	jalr	1064(ra) # 8000481c <holdingsleep>
    800033fc:	c92d                	beqz	a0,8000346e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800033fe:	854a                	mv	a0,s2
    80003400:	00001097          	auipc	ra,0x1
    80003404:	3d8080e7          	jalr	984(ra) # 800047d8 <releasesleep>

  acquire(&bcache.lock);
    80003408:	0001f517          	auipc	a0,0x1f
    8000340c:	ae050513          	addi	a0,a0,-1312 # 80021ee8 <bcache>
    80003410:	ffffd097          	auipc	ra,0xffffd
    80003414:	7b2080e7          	jalr	1970(ra) # 80000bc2 <acquire>
  b->refcnt--;
    80003418:	40bc                	lw	a5,64(s1)
    8000341a:	37fd                	addiw	a5,a5,-1
    8000341c:	0007871b          	sext.w	a4,a5
    80003420:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003422:	eb05                	bnez	a4,80003452 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003424:	68bc                	ld	a5,80(s1)
    80003426:	64b8                	ld	a4,72(s1)
    80003428:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000342a:	64bc                	ld	a5,72(s1)
    8000342c:	68b8                	ld	a4,80(s1)
    8000342e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003430:	00027797          	auipc	a5,0x27
    80003434:	ab878793          	addi	a5,a5,-1352 # 80029ee8 <bcache+0x8000>
    80003438:	2b87b703          	ld	a4,696(a5)
    8000343c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000343e:	00027717          	auipc	a4,0x27
    80003442:	d1270713          	addi	a4,a4,-750 # 8002a150 <bcache+0x8268>
    80003446:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003448:	2b87b703          	ld	a4,696(a5)
    8000344c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000344e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003452:	0001f517          	auipc	a0,0x1f
    80003456:	a9650513          	addi	a0,a0,-1386 # 80021ee8 <bcache>
    8000345a:	ffffe097          	auipc	ra,0xffffe
    8000345e:	81c080e7          	jalr	-2020(ra) # 80000c76 <release>
}
    80003462:	60e2                	ld	ra,24(sp)
    80003464:	6442                	ld	s0,16(sp)
    80003466:	64a2                	ld	s1,8(sp)
    80003468:	6902                	ld	s2,0(sp)
    8000346a:	6105                	addi	sp,sp,32
    8000346c:	8082                	ret
    panic("brelse");
    8000346e:	00005517          	auipc	a0,0x5
    80003472:	10250513          	addi	a0,a0,258 # 80008570 <syscalls+0xf8>
    80003476:	ffffd097          	auipc	ra,0xffffd
    8000347a:	0b4080e7          	jalr	180(ra) # 8000052a <panic>

000000008000347e <bpin>:

void
bpin(struct buf *b) {
    8000347e:	1101                	addi	sp,sp,-32
    80003480:	ec06                	sd	ra,24(sp)
    80003482:	e822                	sd	s0,16(sp)
    80003484:	e426                	sd	s1,8(sp)
    80003486:	1000                	addi	s0,sp,32
    80003488:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000348a:	0001f517          	auipc	a0,0x1f
    8000348e:	a5e50513          	addi	a0,a0,-1442 # 80021ee8 <bcache>
    80003492:	ffffd097          	auipc	ra,0xffffd
    80003496:	730080e7          	jalr	1840(ra) # 80000bc2 <acquire>
  b->refcnt++;
    8000349a:	40bc                	lw	a5,64(s1)
    8000349c:	2785                	addiw	a5,a5,1
    8000349e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800034a0:	0001f517          	auipc	a0,0x1f
    800034a4:	a4850513          	addi	a0,a0,-1464 # 80021ee8 <bcache>
    800034a8:	ffffd097          	auipc	ra,0xffffd
    800034ac:	7ce080e7          	jalr	1998(ra) # 80000c76 <release>
}
    800034b0:	60e2                	ld	ra,24(sp)
    800034b2:	6442                	ld	s0,16(sp)
    800034b4:	64a2                	ld	s1,8(sp)
    800034b6:	6105                	addi	sp,sp,32
    800034b8:	8082                	ret

00000000800034ba <bunpin>:

void
bunpin(struct buf *b) {
    800034ba:	1101                	addi	sp,sp,-32
    800034bc:	ec06                	sd	ra,24(sp)
    800034be:	e822                	sd	s0,16(sp)
    800034c0:	e426                	sd	s1,8(sp)
    800034c2:	1000                	addi	s0,sp,32
    800034c4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800034c6:	0001f517          	auipc	a0,0x1f
    800034ca:	a2250513          	addi	a0,a0,-1502 # 80021ee8 <bcache>
    800034ce:	ffffd097          	auipc	ra,0xffffd
    800034d2:	6f4080e7          	jalr	1780(ra) # 80000bc2 <acquire>
  b->refcnt--;
    800034d6:	40bc                	lw	a5,64(s1)
    800034d8:	37fd                	addiw	a5,a5,-1
    800034da:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800034dc:	0001f517          	auipc	a0,0x1f
    800034e0:	a0c50513          	addi	a0,a0,-1524 # 80021ee8 <bcache>
    800034e4:	ffffd097          	auipc	ra,0xffffd
    800034e8:	792080e7          	jalr	1938(ra) # 80000c76 <release>
}
    800034ec:	60e2                	ld	ra,24(sp)
    800034ee:	6442                	ld	s0,16(sp)
    800034f0:	64a2                	ld	s1,8(sp)
    800034f2:	6105                	addi	sp,sp,32
    800034f4:	8082                	ret

00000000800034f6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800034f6:	1101                	addi	sp,sp,-32
    800034f8:	ec06                	sd	ra,24(sp)
    800034fa:	e822                	sd	s0,16(sp)
    800034fc:	e426                	sd	s1,8(sp)
    800034fe:	e04a                	sd	s2,0(sp)
    80003500:	1000                	addi	s0,sp,32
    80003502:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003504:	00d5d59b          	srliw	a1,a1,0xd
    80003508:	00027797          	auipc	a5,0x27
    8000350c:	0bc7a783          	lw	a5,188(a5) # 8002a5c4 <sb+0x1c>
    80003510:	9dbd                	addw	a1,a1,a5
    80003512:	00000097          	auipc	ra,0x0
    80003516:	d9e080e7          	jalr	-610(ra) # 800032b0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000351a:	0074f713          	andi	a4,s1,7
    8000351e:	4785                	li	a5,1
    80003520:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003524:	14ce                	slli	s1,s1,0x33
    80003526:	90d9                	srli	s1,s1,0x36
    80003528:	00950733          	add	a4,a0,s1
    8000352c:	05874703          	lbu	a4,88(a4)
    80003530:	00e7f6b3          	and	a3,a5,a4
    80003534:	c69d                	beqz	a3,80003562 <bfree+0x6c>
    80003536:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003538:	94aa                	add	s1,s1,a0
    8000353a:	fff7c793          	not	a5,a5
    8000353e:	8ff9                	and	a5,a5,a4
    80003540:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003544:	00001097          	auipc	ra,0x1
    80003548:	11e080e7          	jalr	286(ra) # 80004662 <log_write>
  brelse(bp);
    8000354c:	854a                	mv	a0,s2
    8000354e:	00000097          	auipc	ra,0x0
    80003552:	e92080e7          	jalr	-366(ra) # 800033e0 <brelse>
}
    80003556:	60e2                	ld	ra,24(sp)
    80003558:	6442                	ld	s0,16(sp)
    8000355a:	64a2                	ld	s1,8(sp)
    8000355c:	6902                	ld	s2,0(sp)
    8000355e:	6105                	addi	sp,sp,32
    80003560:	8082                	ret
    panic("freeing free block");
    80003562:	00005517          	auipc	a0,0x5
    80003566:	01650513          	addi	a0,a0,22 # 80008578 <syscalls+0x100>
    8000356a:	ffffd097          	auipc	ra,0xffffd
    8000356e:	fc0080e7          	jalr	-64(ra) # 8000052a <panic>

0000000080003572 <balloc>:
{
    80003572:	711d                	addi	sp,sp,-96
    80003574:	ec86                	sd	ra,88(sp)
    80003576:	e8a2                	sd	s0,80(sp)
    80003578:	e4a6                	sd	s1,72(sp)
    8000357a:	e0ca                	sd	s2,64(sp)
    8000357c:	fc4e                	sd	s3,56(sp)
    8000357e:	f852                	sd	s4,48(sp)
    80003580:	f456                	sd	s5,40(sp)
    80003582:	f05a                	sd	s6,32(sp)
    80003584:	ec5e                	sd	s7,24(sp)
    80003586:	e862                	sd	s8,16(sp)
    80003588:	e466                	sd	s9,8(sp)
    8000358a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000358c:	00027797          	auipc	a5,0x27
    80003590:	0207a783          	lw	a5,32(a5) # 8002a5ac <sb+0x4>
    80003594:	cbd1                	beqz	a5,80003628 <balloc+0xb6>
    80003596:	8baa                	mv	s7,a0
    80003598:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000359a:	00027b17          	auipc	s6,0x27
    8000359e:	00eb0b13          	addi	s6,s6,14 # 8002a5a8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800035a2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800035a4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800035a6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800035a8:	6c89                	lui	s9,0x2
    800035aa:	a831                	j	800035c6 <balloc+0x54>
    brelse(bp);
    800035ac:	854a                	mv	a0,s2
    800035ae:	00000097          	auipc	ra,0x0
    800035b2:	e32080e7          	jalr	-462(ra) # 800033e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800035b6:	015c87bb          	addw	a5,s9,s5
    800035ba:	00078a9b          	sext.w	s5,a5
    800035be:	004b2703          	lw	a4,4(s6)
    800035c2:	06eaf363          	bgeu	s5,a4,80003628 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800035c6:	41fad79b          	sraiw	a5,s5,0x1f
    800035ca:	0137d79b          	srliw	a5,a5,0x13
    800035ce:	015787bb          	addw	a5,a5,s5
    800035d2:	40d7d79b          	sraiw	a5,a5,0xd
    800035d6:	01cb2583          	lw	a1,28(s6)
    800035da:	9dbd                	addw	a1,a1,a5
    800035dc:	855e                	mv	a0,s7
    800035de:	00000097          	auipc	ra,0x0
    800035e2:	cd2080e7          	jalr	-814(ra) # 800032b0 <bread>
    800035e6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800035e8:	004b2503          	lw	a0,4(s6)
    800035ec:	000a849b          	sext.w	s1,s5
    800035f0:	8662                	mv	a2,s8
    800035f2:	faa4fde3          	bgeu	s1,a0,800035ac <balloc+0x3a>
      m = 1 << (bi % 8);
    800035f6:	41f6579b          	sraiw	a5,a2,0x1f
    800035fa:	01d7d69b          	srliw	a3,a5,0x1d
    800035fe:	00c6873b          	addw	a4,a3,a2
    80003602:	00777793          	andi	a5,a4,7
    80003606:	9f95                	subw	a5,a5,a3
    80003608:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000360c:	4037571b          	sraiw	a4,a4,0x3
    80003610:	00e906b3          	add	a3,s2,a4
    80003614:	0586c683          	lbu	a3,88(a3)
    80003618:	00d7f5b3          	and	a1,a5,a3
    8000361c:	cd91                	beqz	a1,80003638 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000361e:	2605                	addiw	a2,a2,1
    80003620:	2485                	addiw	s1,s1,1
    80003622:	fd4618e3          	bne	a2,s4,800035f2 <balloc+0x80>
    80003626:	b759                	j	800035ac <balloc+0x3a>
  panic("balloc: out of blocks");
    80003628:	00005517          	auipc	a0,0x5
    8000362c:	f6850513          	addi	a0,a0,-152 # 80008590 <syscalls+0x118>
    80003630:	ffffd097          	auipc	ra,0xffffd
    80003634:	efa080e7          	jalr	-262(ra) # 8000052a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003638:	974a                	add	a4,a4,s2
    8000363a:	8fd5                	or	a5,a5,a3
    8000363c:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003640:	854a                	mv	a0,s2
    80003642:	00001097          	auipc	ra,0x1
    80003646:	020080e7          	jalr	32(ra) # 80004662 <log_write>
        brelse(bp);
    8000364a:	854a                	mv	a0,s2
    8000364c:	00000097          	auipc	ra,0x0
    80003650:	d94080e7          	jalr	-620(ra) # 800033e0 <brelse>
  bp = bread(dev, bno);
    80003654:	85a6                	mv	a1,s1
    80003656:	855e                	mv	a0,s7
    80003658:	00000097          	auipc	ra,0x0
    8000365c:	c58080e7          	jalr	-936(ra) # 800032b0 <bread>
    80003660:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003662:	40000613          	li	a2,1024
    80003666:	4581                	li	a1,0
    80003668:	05850513          	addi	a0,a0,88
    8000366c:	ffffd097          	auipc	ra,0xffffd
    80003670:	652080e7          	jalr	1618(ra) # 80000cbe <memset>
  log_write(bp);
    80003674:	854a                	mv	a0,s2
    80003676:	00001097          	auipc	ra,0x1
    8000367a:	fec080e7          	jalr	-20(ra) # 80004662 <log_write>
  brelse(bp);
    8000367e:	854a                	mv	a0,s2
    80003680:	00000097          	auipc	ra,0x0
    80003684:	d60080e7          	jalr	-672(ra) # 800033e0 <brelse>
}
    80003688:	8526                	mv	a0,s1
    8000368a:	60e6                	ld	ra,88(sp)
    8000368c:	6446                	ld	s0,80(sp)
    8000368e:	64a6                	ld	s1,72(sp)
    80003690:	6906                	ld	s2,64(sp)
    80003692:	79e2                	ld	s3,56(sp)
    80003694:	7a42                	ld	s4,48(sp)
    80003696:	7aa2                	ld	s5,40(sp)
    80003698:	7b02                	ld	s6,32(sp)
    8000369a:	6be2                	ld	s7,24(sp)
    8000369c:	6c42                	ld	s8,16(sp)
    8000369e:	6ca2                	ld	s9,8(sp)
    800036a0:	6125                	addi	sp,sp,96
    800036a2:	8082                	ret

00000000800036a4 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800036a4:	7179                	addi	sp,sp,-48
    800036a6:	f406                	sd	ra,40(sp)
    800036a8:	f022                	sd	s0,32(sp)
    800036aa:	ec26                	sd	s1,24(sp)
    800036ac:	e84a                	sd	s2,16(sp)
    800036ae:	e44e                	sd	s3,8(sp)
    800036b0:	e052                	sd	s4,0(sp)
    800036b2:	1800                	addi	s0,sp,48
    800036b4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800036b6:	47ad                	li	a5,11
    800036b8:	04b7fe63          	bgeu	a5,a1,80003714 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800036bc:	ff45849b          	addiw	s1,a1,-12
    800036c0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800036c4:	0ff00793          	li	a5,255
    800036c8:	0ae7e463          	bltu	a5,a4,80003770 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800036cc:	08052583          	lw	a1,128(a0)
    800036d0:	c5b5                	beqz	a1,8000373c <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800036d2:	00092503          	lw	a0,0(s2)
    800036d6:	00000097          	auipc	ra,0x0
    800036da:	bda080e7          	jalr	-1062(ra) # 800032b0 <bread>
    800036de:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800036e0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800036e4:	02049713          	slli	a4,s1,0x20
    800036e8:	01e75593          	srli	a1,a4,0x1e
    800036ec:	00b784b3          	add	s1,a5,a1
    800036f0:	0004a983          	lw	s3,0(s1)
    800036f4:	04098e63          	beqz	s3,80003750 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800036f8:	8552                	mv	a0,s4
    800036fa:	00000097          	auipc	ra,0x0
    800036fe:	ce6080e7          	jalr	-794(ra) # 800033e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003702:	854e                	mv	a0,s3
    80003704:	70a2                	ld	ra,40(sp)
    80003706:	7402                	ld	s0,32(sp)
    80003708:	64e2                	ld	s1,24(sp)
    8000370a:	6942                	ld	s2,16(sp)
    8000370c:	69a2                	ld	s3,8(sp)
    8000370e:	6a02                	ld	s4,0(sp)
    80003710:	6145                	addi	sp,sp,48
    80003712:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003714:	02059793          	slli	a5,a1,0x20
    80003718:	01e7d593          	srli	a1,a5,0x1e
    8000371c:	00b504b3          	add	s1,a0,a1
    80003720:	0504a983          	lw	s3,80(s1)
    80003724:	fc099fe3          	bnez	s3,80003702 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003728:	4108                	lw	a0,0(a0)
    8000372a:	00000097          	auipc	ra,0x0
    8000372e:	e48080e7          	jalr	-440(ra) # 80003572 <balloc>
    80003732:	0005099b          	sext.w	s3,a0
    80003736:	0534a823          	sw	s3,80(s1)
    8000373a:	b7e1                	j	80003702 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000373c:	4108                	lw	a0,0(a0)
    8000373e:	00000097          	auipc	ra,0x0
    80003742:	e34080e7          	jalr	-460(ra) # 80003572 <balloc>
    80003746:	0005059b          	sext.w	a1,a0
    8000374a:	08b92023          	sw	a1,128(s2)
    8000374e:	b751                	j	800036d2 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003750:	00092503          	lw	a0,0(s2)
    80003754:	00000097          	auipc	ra,0x0
    80003758:	e1e080e7          	jalr	-482(ra) # 80003572 <balloc>
    8000375c:	0005099b          	sext.w	s3,a0
    80003760:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003764:	8552                	mv	a0,s4
    80003766:	00001097          	auipc	ra,0x1
    8000376a:	efc080e7          	jalr	-260(ra) # 80004662 <log_write>
    8000376e:	b769                	j	800036f8 <bmap+0x54>
  panic("bmap: out of range");
    80003770:	00005517          	auipc	a0,0x5
    80003774:	e3850513          	addi	a0,a0,-456 # 800085a8 <syscalls+0x130>
    80003778:	ffffd097          	auipc	ra,0xffffd
    8000377c:	db2080e7          	jalr	-590(ra) # 8000052a <panic>

0000000080003780 <iget>:
{
    80003780:	7179                	addi	sp,sp,-48
    80003782:	f406                	sd	ra,40(sp)
    80003784:	f022                	sd	s0,32(sp)
    80003786:	ec26                	sd	s1,24(sp)
    80003788:	e84a                	sd	s2,16(sp)
    8000378a:	e44e                	sd	s3,8(sp)
    8000378c:	e052                	sd	s4,0(sp)
    8000378e:	1800                	addi	s0,sp,48
    80003790:	89aa                	mv	s3,a0
    80003792:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003794:	00027517          	auipc	a0,0x27
    80003798:	e3450513          	addi	a0,a0,-460 # 8002a5c8 <itable>
    8000379c:	ffffd097          	auipc	ra,0xffffd
    800037a0:	426080e7          	jalr	1062(ra) # 80000bc2 <acquire>
  empty = 0;
    800037a4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800037a6:	00027497          	auipc	s1,0x27
    800037aa:	e3a48493          	addi	s1,s1,-454 # 8002a5e0 <itable+0x18>
    800037ae:	00029697          	auipc	a3,0x29
    800037b2:	8c268693          	addi	a3,a3,-1854 # 8002c070 <log>
    800037b6:	a039                	j	800037c4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800037b8:	02090b63          	beqz	s2,800037ee <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800037bc:	08848493          	addi	s1,s1,136
    800037c0:	02d48a63          	beq	s1,a3,800037f4 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800037c4:	449c                	lw	a5,8(s1)
    800037c6:	fef059e3          	blez	a5,800037b8 <iget+0x38>
    800037ca:	4098                	lw	a4,0(s1)
    800037cc:	ff3716e3          	bne	a4,s3,800037b8 <iget+0x38>
    800037d0:	40d8                	lw	a4,4(s1)
    800037d2:	ff4713e3          	bne	a4,s4,800037b8 <iget+0x38>
      ip->ref++;
    800037d6:	2785                	addiw	a5,a5,1
    800037d8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800037da:	00027517          	auipc	a0,0x27
    800037de:	dee50513          	addi	a0,a0,-530 # 8002a5c8 <itable>
    800037e2:	ffffd097          	auipc	ra,0xffffd
    800037e6:	494080e7          	jalr	1172(ra) # 80000c76 <release>
      return ip;
    800037ea:	8926                	mv	s2,s1
    800037ec:	a03d                	j	8000381a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800037ee:	f7f9                	bnez	a5,800037bc <iget+0x3c>
    800037f0:	8926                	mv	s2,s1
    800037f2:	b7e9                	j	800037bc <iget+0x3c>
  if(empty == 0)
    800037f4:	02090c63          	beqz	s2,8000382c <iget+0xac>
  ip->dev = dev;
    800037f8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800037fc:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003800:	4785                	li	a5,1
    80003802:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003806:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000380a:	00027517          	auipc	a0,0x27
    8000380e:	dbe50513          	addi	a0,a0,-578 # 8002a5c8 <itable>
    80003812:	ffffd097          	auipc	ra,0xffffd
    80003816:	464080e7          	jalr	1124(ra) # 80000c76 <release>
}
    8000381a:	854a                	mv	a0,s2
    8000381c:	70a2                	ld	ra,40(sp)
    8000381e:	7402                	ld	s0,32(sp)
    80003820:	64e2                	ld	s1,24(sp)
    80003822:	6942                	ld	s2,16(sp)
    80003824:	69a2                	ld	s3,8(sp)
    80003826:	6a02                	ld	s4,0(sp)
    80003828:	6145                	addi	sp,sp,48
    8000382a:	8082                	ret
    panic("iget: no inodes");
    8000382c:	00005517          	auipc	a0,0x5
    80003830:	d9450513          	addi	a0,a0,-620 # 800085c0 <syscalls+0x148>
    80003834:	ffffd097          	auipc	ra,0xffffd
    80003838:	cf6080e7          	jalr	-778(ra) # 8000052a <panic>

000000008000383c <fsinit>:
fsinit(int dev) {
    8000383c:	7179                	addi	sp,sp,-48
    8000383e:	f406                	sd	ra,40(sp)
    80003840:	f022                	sd	s0,32(sp)
    80003842:	ec26                	sd	s1,24(sp)
    80003844:	e84a                	sd	s2,16(sp)
    80003846:	e44e                	sd	s3,8(sp)
    80003848:	1800                	addi	s0,sp,48
    8000384a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000384c:	4585                	li	a1,1
    8000384e:	00000097          	auipc	ra,0x0
    80003852:	a62080e7          	jalr	-1438(ra) # 800032b0 <bread>
    80003856:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003858:	00027997          	auipc	s3,0x27
    8000385c:	d5098993          	addi	s3,s3,-688 # 8002a5a8 <sb>
    80003860:	02000613          	li	a2,32
    80003864:	05850593          	addi	a1,a0,88
    80003868:	854e                	mv	a0,s3
    8000386a:	ffffd097          	auipc	ra,0xffffd
    8000386e:	4b0080e7          	jalr	1200(ra) # 80000d1a <memmove>
  brelse(bp);
    80003872:	8526                	mv	a0,s1
    80003874:	00000097          	auipc	ra,0x0
    80003878:	b6c080e7          	jalr	-1172(ra) # 800033e0 <brelse>
  if(sb.magic != FSMAGIC)
    8000387c:	0009a703          	lw	a4,0(s3)
    80003880:	102037b7          	lui	a5,0x10203
    80003884:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003888:	02f71263          	bne	a4,a5,800038ac <fsinit+0x70>
  initlog(dev, &sb);
    8000388c:	00027597          	auipc	a1,0x27
    80003890:	d1c58593          	addi	a1,a1,-740 # 8002a5a8 <sb>
    80003894:	854a                	mv	a0,s2
    80003896:	00001097          	auipc	ra,0x1
    8000389a:	b4e080e7          	jalr	-1202(ra) # 800043e4 <initlog>
}
    8000389e:	70a2                	ld	ra,40(sp)
    800038a0:	7402                	ld	s0,32(sp)
    800038a2:	64e2                	ld	s1,24(sp)
    800038a4:	6942                	ld	s2,16(sp)
    800038a6:	69a2                	ld	s3,8(sp)
    800038a8:	6145                	addi	sp,sp,48
    800038aa:	8082                	ret
    panic("invalid file system");
    800038ac:	00005517          	auipc	a0,0x5
    800038b0:	d2450513          	addi	a0,a0,-732 # 800085d0 <syscalls+0x158>
    800038b4:	ffffd097          	auipc	ra,0xffffd
    800038b8:	c76080e7          	jalr	-906(ra) # 8000052a <panic>

00000000800038bc <iinit>:
{
    800038bc:	7179                	addi	sp,sp,-48
    800038be:	f406                	sd	ra,40(sp)
    800038c0:	f022                	sd	s0,32(sp)
    800038c2:	ec26                	sd	s1,24(sp)
    800038c4:	e84a                	sd	s2,16(sp)
    800038c6:	e44e                	sd	s3,8(sp)
    800038c8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800038ca:	00005597          	auipc	a1,0x5
    800038ce:	d1e58593          	addi	a1,a1,-738 # 800085e8 <syscalls+0x170>
    800038d2:	00027517          	auipc	a0,0x27
    800038d6:	cf650513          	addi	a0,a0,-778 # 8002a5c8 <itable>
    800038da:	ffffd097          	auipc	ra,0xffffd
    800038de:	258080e7          	jalr	600(ra) # 80000b32 <initlock>
  for(i = 0; i < NINODE; i++) {
    800038e2:	00027497          	auipc	s1,0x27
    800038e6:	d0e48493          	addi	s1,s1,-754 # 8002a5f0 <itable+0x28>
    800038ea:	00028997          	auipc	s3,0x28
    800038ee:	79698993          	addi	s3,s3,1942 # 8002c080 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800038f2:	00005917          	auipc	s2,0x5
    800038f6:	cfe90913          	addi	s2,s2,-770 # 800085f0 <syscalls+0x178>
    800038fa:	85ca                	mv	a1,s2
    800038fc:	8526                	mv	a0,s1
    800038fe:	00001097          	auipc	ra,0x1
    80003902:	e4a080e7          	jalr	-438(ra) # 80004748 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003906:	08848493          	addi	s1,s1,136
    8000390a:	ff3498e3          	bne	s1,s3,800038fa <iinit+0x3e>
}
    8000390e:	70a2                	ld	ra,40(sp)
    80003910:	7402                	ld	s0,32(sp)
    80003912:	64e2                	ld	s1,24(sp)
    80003914:	6942                	ld	s2,16(sp)
    80003916:	69a2                	ld	s3,8(sp)
    80003918:	6145                	addi	sp,sp,48
    8000391a:	8082                	ret

000000008000391c <ialloc>:
{
    8000391c:	715d                	addi	sp,sp,-80
    8000391e:	e486                	sd	ra,72(sp)
    80003920:	e0a2                	sd	s0,64(sp)
    80003922:	fc26                	sd	s1,56(sp)
    80003924:	f84a                	sd	s2,48(sp)
    80003926:	f44e                	sd	s3,40(sp)
    80003928:	f052                	sd	s4,32(sp)
    8000392a:	ec56                	sd	s5,24(sp)
    8000392c:	e85a                	sd	s6,16(sp)
    8000392e:	e45e                	sd	s7,8(sp)
    80003930:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003932:	00027717          	auipc	a4,0x27
    80003936:	c8272703          	lw	a4,-894(a4) # 8002a5b4 <sb+0xc>
    8000393a:	4785                	li	a5,1
    8000393c:	04e7fa63          	bgeu	a5,a4,80003990 <ialloc+0x74>
    80003940:	8aaa                	mv	s5,a0
    80003942:	8bae                	mv	s7,a1
    80003944:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003946:	00027a17          	auipc	s4,0x27
    8000394a:	c62a0a13          	addi	s4,s4,-926 # 8002a5a8 <sb>
    8000394e:	00048b1b          	sext.w	s6,s1
    80003952:	0044d793          	srli	a5,s1,0x4
    80003956:	018a2583          	lw	a1,24(s4)
    8000395a:	9dbd                	addw	a1,a1,a5
    8000395c:	8556                	mv	a0,s5
    8000395e:	00000097          	auipc	ra,0x0
    80003962:	952080e7          	jalr	-1710(ra) # 800032b0 <bread>
    80003966:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003968:	05850993          	addi	s3,a0,88
    8000396c:	00f4f793          	andi	a5,s1,15
    80003970:	079a                	slli	a5,a5,0x6
    80003972:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003974:	00099783          	lh	a5,0(s3)
    80003978:	c785                	beqz	a5,800039a0 <ialloc+0x84>
    brelse(bp);
    8000397a:	00000097          	auipc	ra,0x0
    8000397e:	a66080e7          	jalr	-1434(ra) # 800033e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003982:	0485                	addi	s1,s1,1
    80003984:	00ca2703          	lw	a4,12(s4)
    80003988:	0004879b          	sext.w	a5,s1
    8000398c:	fce7e1e3          	bltu	a5,a4,8000394e <ialloc+0x32>
  panic("ialloc: no inodes");
    80003990:	00005517          	auipc	a0,0x5
    80003994:	c6850513          	addi	a0,a0,-920 # 800085f8 <syscalls+0x180>
    80003998:	ffffd097          	auipc	ra,0xffffd
    8000399c:	b92080e7          	jalr	-1134(ra) # 8000052a <panic>
      memset(dip, 0, sizeof(*dip));
    800039a0:	04000613          	li	a2,64
    800039a4:	4581                	li	a1,0
    800039a6:	854e                	mv	a0,s3
    800039a8:	ffffd097          	auipc	ra,0xffffd
    800039ac:	316080e7          	jalr	790(ra) # 80000cbe <memset>
      dip->type = type;
    800039b0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800039b4:	854a                	mv	a0,s2
    800039b6:	00001097          	auipc	ra,0x1
    800039ba:	cac080e7          	jalr	-852(ra) # 80004662 <log_write>
      brelse(bp);
    800039be:	854a                	mv	a0,s2
    800039c0:	00000097          	auipc	ra,0x0
    800039c4:	a20080e7          	jalr	-1504(ra) # 800033e0 <brelse>
      return iget(dev, inum);
    800039c8:	85da                	mv	a1,s6
    800039ca:	8556                	mv	a0,s5
    800039cc:	00000097          	auipc	ra,0x0
    800039d0:	db4080e7          	jalr	-588(ra) # 80003780 <iget>
}
    800039d4:	60a6                	ld	ra,72(sp)
    800039d6:	6406                	ld	s0,64(sp)
    800039d8:	74e2                	ld	s1,56(sp)
    800039da:	7942                	ld	s2,48(sp)
    800039dc:	79a2                	ld	s3,40(sp)
    800039de:	7a02                	ld	s4,32(sp)
    800039e0:	6ae2                	ld	s5,24(sp)
    800039e2:	6b42                	ld	s6,16(sp)
    800039e4:	6ba2                	ld	s7,8(sp)
    800039e6:	6161                	addi	sp,sp,80
    800039e8:	8082                	ret

00000000800039ea <iupdate>:
{
    800039ea:	1101                	addi	sp,sp,-32
    800039ec:	ec06                	sd	ra,24(sp)
    800039ee:	e822                	sd	s0,16(sp)
    800039f0:	e426                	sd	s1,8(sp)
    800039f2:	e04a                	sd	s2,0(sp)
    800039f4:	1000                	addi	s0,sp,32
    800039f6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800039f8:	415c                	lw	a5,4(a0)
    800039fa:	0047d79b          	srliw	a5,a5,0x4
    800039fe:	00027597          	auipc	a1,0x27
    80003a02:	bc25a583          	lw	a1,-1086(a1) # 8002a5c0 <sb+0x18>
    80003a06:	9dbd                	addw	a1,a1,a5
    80003a08:	4108                	lw	a0,0(a0)
    80003a0a:	00000097          	auipc	ra,0x0
    80003a0e:	8a6080e7          	jalr	-1882(ra) # 800032b0 <bread>
    80003a12:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003a14:	05850793          	addi	a5,a0,88
    80003a18:	40c8                	lw	a0,4(s1)
    80003a1a:	893d                	andi	a0,a0,15
    80003a1c:	051a                	slli	a0,a0,0x6
    80003a1e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003a20:	04449703          	lh	a4,68(s1)
    80003a24:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003a28:	04649703          	lh	a4,70(s1)
    80003a2c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003a30:	04849703          	lh	a4,72(s1)
    80003a34:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003a38:	04a49703          	lh	a4,74(s1)
    80003a3c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003a40:	44f8                	lw	a4,76(s1)
    80003a42:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003a44:	03400613          	li	a2,52
    80003a48:	05048593          	addi	a1,s1,80
    80003a4c:	0531                	addi	a0,a0,12
    80003a4e:	ffffd097          	auipc	ra,0xffffd
    80003a52:	2cc080e7          	jalr	716(ra) # 80000d1a <memmove>
  log_write(bp);
    80003a56:	854a                	mv	a0,s2
    80003a58:	00001097          	auipc	ra,0x1
    80003a5c:	c0a080e7          	jalr	-1014(ra) # 80004662 <log_write>
  brelse(bp);
    80003a60:	854a                	mv	a0,s2
    80003a62:	00000097          	auipc	ra,0x0
    80003a66:	97e080e7          	jalr	-1666(ra) # 800033e0 <brelse>
}
    80003a6a:	60e2                	ld	ra,24(sp)
    80003a6c:	6442                	ld	s0,16(sp)
    80003a6e:	64a2                	ld	s1,8(sp)
    80003a70:	6902                	ld	s2,0(sp)
    80003a72:	6105                	addi	sp,sp,32
    80003a74:	8082                	ret

0000000080003a76 <idup>:
{
    80003a76:	1101                	addi	sp,sp,-32
    80003a78:	ec06                	sd	ra,24(sp)
    80003a7a:	e822                	sd	s0,16(sp)
    80003a7c:	e426                	sd	s1,8(sp)
    80003a7e:	1000                	addi	s0,sp,32
    80003a80:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003a82:	00027517          	auipc	a0,0x27
    80003a86:	b4650513          	addi	a0,a0,-1210 # 8002a5c8 <itable>
    80003a8a:	ffffd097          	auipc	ra,0xffffd
    80003a8e:	138080e7          	jalr	312(ra) # 80000bc2 <acquire>
  ip->ref++;
    80003a92:	449c                	lw	a5,8(s1)
    80003a94:	2785                	addiw	a5,a5,1
    80003a96:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003a98:	00027517          	auipc	a0,0x27
    80003a9c:	b3050513          	addi	a0,a0,-1232 # 8002a5c8 <itable>
    80003aa0:	ffffd097          	auipc	ra,0xffffd
    80003aa4:	1d6080e7          	jalr	470(ra) # 80000c76 <release>
}
    80003aa8:	8526                	mv	a0,s1
    80003aaa:	60e2                	ld	ra,24(sp)
    80003aac:	6442                	ld	s0,16(sp)
    80003aae:	64a2                	ld	s1,8(sp)
    80003ab0:	6105                	addi	sp,sp,32
    80003ab2:	8082                	ret

0000000080003ab4 <ilock>:
{
    80003ab4:	1101                	addi	sp,sp,-32
    80003ab6:	ec06                	sd	ra,24(sp)
    80003ab8:	e822                	sd	s0,16(sp)
    80003aba:	e426                	sd	s1,8(sp)
    80003abc:	e04a                	sd	s2,0(sp)
    80003abe:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003ac0:	c115                	beqz	a0,80003ae4 <ilock+0x30>
    80003ac2:	84aa                	mv	s1,a0
    80003ac4:	451c                	lw	a5,8(a0)
    80003ac6:	00f05f63          	blez	a5,80003ae4 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003aca:	0541                	addi	a0,a0,16
    80003acc:	00001097          	auipc	ra,0x1
    80003ad0:	cb6080e7          	jalr	-842(ra) # 80004782 <acquiresleep>
  if(ip->valid == 0){
    80003ad4:	40bc                	lw	a5,64(s1)
    80003ad6:	cf99                	beqz	a5,80003af4 <ilock+0x40>
}
    80003ad8:	60e2                	ld	ra,24(sp)
    80003ada:	6442                	ld	s0,16(sp)
    80003adc:	64a2                	ld	s1,8(sp)
    80003ade:	6902                	ld	s2,0(sp)
    80003ae0:	6105                	addi	sp,sp,32
    80003ae2:	8082                	ret
    panic("ilock");
    80003ae4:	00005517          	auipc	a0,0x5
    80003ae8:	b2c50513          	addi	a0,a0,-1236 # 80008610 <syscalls+0x198>
    80003aec:	ffffd097          	auipc	ra,0xffffd
    80003af0:	a3e080e7          	jalr	-1474(ra) # 8000052a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003af4:	40dc                	lw	a5,4(s1)
    80003af6:	0047d79b          	srliw	a5,a5,0x4
    80003afa:	00027597          	auipc	a1,0x27
    80003afe:	ac65a583          	lw	a1,-1338(a1) # 8002a5c0 <sb+0x18>
    80003b02:	9dbd                	addw	a1,a1,a5
    80003b04:	4088                	lw	a0,0(s1)
    80003b06:	fffff097          	auipc	ra,0xfffff
    80003b0a:	7aa080e7          	jalr	1962(ra) # 800032b0 <bread>
    80003b0e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003b10:	05850593          	addi	a1,a0,88
    80003b14:	40dc                	lw	a5,4(s1)
    80003b16:	8bbd                	andi	a5,a5,15
    80003b18:	079a                	slli	a5,a5,0x6
    80003b1a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003b1c:	00059783          	lh	a5,0(a1)
    80003b20:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003b24:	00259783          	lh	a5,2(a1)
    80003b28:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003b2c:	00459783          	lh	a5,4(a1)
    80003b30:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003b34:	00659783          	lh	a5,6(a1)
    80003b38:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003b3c:	459c                	lw	a5,8(a1)
    80003b3e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003b40:	03400613          	li	a2,52
    80003b44:	05b1                	addi	a1,a1,12
    80003b46:	05048513          	addi	a0,s1,80
    80003b4a:	ffffd097          	auipc	ra,0xffffd
    80003b4e:	1d0080e7          	jalr	464(ra) # 80000d1a <memmove>
    brelse(bp);
    80003b52:	854a                	mv	a0,s2
    80003b54:	00000097          	auipc	ra,0x0
    80003b58:	88c080e7          	jalr	-1908(ra) # 800033e0 <brelse>
    ip->valid = 1;
    80003b5c:	4785                	li	a5,1
    80003b5e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003b60:	04449783          	lh	a5,68(s1)
    80003b64:	fbb5                	bnez	a5,80003ad8 <ilock+0x24>
      panic("ilock: no type");
    80003b66:	00005517          	auipc	a0,0x5
    80003b6a:	ab250513          	addi	a0,a0,-1358 # 80008618 <syscalls+0x1a0>
    80003b6e:	ffffd097          	auipc	ra,0xffffd
    80003b72:	9bc080e7          	jalr	-1604(ra) # 8000052a <panic>

0000000080003b76 <iunlock>:
{
    80003b76:	1101                	addi	sp,sp,-32
    80003b78:	ec06                	sd	ra,24(sp)
    80003b7a:	e822                	sd	s0,16(sp)
    80003b7c:	e426                	sd	s1,8(sp)
    80003b7e:	e04a                	sd	s2,0(sp)
    80003b80:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003b82:	c905                	beqz	a0,80003bb2 <iunlock+0x3c>
    80003b84:	84aa                	mv	s1,a0
    80003b86:	01050913          	addi	s2,a0,16
    80003b8a:	854a                	mv	a0,s2
    80003b8c:	00001097          	auipc	ra,0x1
    80003b90:	c90080e7          	jalr	-880(ra) # 8000481c <holdingsleep>
    80003b94:	cd19                	beqz	a0,80003bb2 <iunlock+0x3c>
    80003b96:	449c                	lw	a5,8(s1)
    80003b98:	00f05d63          	blez	a5,80003bb2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003b9c:	854a                	mv	a0,s2
    80003b9e:	00001097          	auipc	ra,0x1
    80003ba2:	c3a080e7          	jalr	-966(ra) # 800047d8 <releasesleep>
}
    80003ba6:	60e2                	ld	ra,24(sp)
    80003ba8:	6442                	ld	s0,16(sp)
    80003baa:	64a2                	ld	s1,8(sp)
    80003bac:	6902                	ld	s2,0(sp)
    80003bae:	6105                	addi	sp,sp,32
    80003bb0:	8082                	ret
    panic("iunlock");
    80003bb2:	00005517          	auipc	a0,0x5
    80003bb6:	a7650513          	addi	a0,a0,-1418 # 80008628 <syscalls+0x1b0>
    80003bba:	ffffd097          	auipc	ra,0xffffd
    80003bbe:	970080e7          	jalr	-1680(ra) # 8000052a <panic>

0000000080003bc2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003bc2:	7179                	addi	sp,sp,-48
    80003bc4:	f406                	sd	ra,40(sp)
    80003bc6:	f022                	sd	s0,32(sp)
    80003bc8:	ec26                	sd	s1,24(sp)
    80003bca:	e84a                	sd	s2,16(sp)
    80003bcc:	e44e                	sd	s3,8(sp)
    80003bce:	e052                	sd	s4,0(sp)
    80003bd0:	1800                	addi	s0,sp,48
    80003bd2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003bd4:	05050493          	addi	s1,a0,80
    80003bd8:	08050913          	addi	s2,a0,128
    80003bdc:	a021                	j	80003be4 <itrunc+0x22>
    80003bde:	0491                	addi	s1,s1,4
    80003be0:	01248d63          	beq	s1,s2,80003bfa <itrunc+0x38>
    if(ip->addrs[i]){
    80003be4:	408c                	lw	a1,0(s1)
    80003be6:	dde5                	beqz	a1,80003bde <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003be8:	0009a503          	lw	a0,0(s3)
    80003bec:	00000097          	auipc	ra,0x0
    80003bf0:	90a080e7          	jalr	-1782(ra) # 800034f6 <bfree>
      ip->addrs[i] = 0;
    80003bf4:	0004a023          	sw	zero,0(s1)
    80003bf8:	b7dd                	j	80003bde <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003bfa:	0809a583          	lw	a1,128(s3)
    80003bfe:	e185                	bnez	a1,80003c1e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003c00:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003c04:	854e                	mv	a0,s3
    80003c06:	00000097          	auipc	ra,0x0
    80003c0a:	de4080e7          	jalr	-540(ra) # 800039ea <iupdate>
}
    80003c0e:	70a2                	ld	ra,40(sp)
    80003c10:	7402                	ld	s0,32(sp)
    80003c12:	64e2                	ld	s1,24(sp)
    80003c14:	6942                	ld	s2,16(sp)
    80003c16:	69a2                	ld	s3,8(sp)
    80003c18:	6a02                	ld	s4,0(sp)
    80003c1a:	6145                	addi	sp,sp,48
    80003c1c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003c1e:	0009a503          	lw	a0,0(s3)
    80003c22:	fffff097          	auipc	ra,0xfffff
    80003c26:	68e080e7          	jalr	1678(ra) # 800032b0 <bread>
    80003c2a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003c2c:	05850493          	addi	s1,a0,88
    80003c30:	45850913          	addi	s2,a0,1112
    80003c34:	a021                	j	80003c3c <itrunc+0x7a>
    80003c36:	0491                	addi	s1,s1,4
    80003c38:	01248b63          	beq	s1,s2,80003c4e <itrunc+0x8c>
      if(a[j])
    80003c3c:	408c                	lw	a1,0(s1)
    80003c3e:	dde5                	beqz	a1,80003c36 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003c40:	0009a503          	lw	a0,0(s3)
    80003c44:	00000097          	auipc	ra,0x0
    80003c48:	8b2080e7          	jalr	-1870(ra) # 800034f6 <bfree>
    80003c4c:	b7ed                	j	80003c36 <itrunc+0x74>
    brelse(bp);
    80003c4e:	8552                	mv	a0,s4
    80003c50:	fffff097          	auipc	ra,0xfffff
    80003c54:	790080e7          	jalr	1936(ra) # 800033e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003c58:	0809a583          	lw	a1,128(s3)
    80003c5c:	0009a503          	lw	a0,0(s3)
    80003c60:	00000097          	auipc	ra,0x0
    80003c64:	896080e7          	jalr	-1898(ra) # 800034f6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003c68:	0809a023          	sw	zero,128(s3)
    80003c6c:	bf51                	j	80003c00 <itrunc+0x3e>

0000000080003c6e <iput>:
{
    80003c6e:	1101                	addi	sp,sp,-32
    80003c70:	ec06                	sd	ra,24(sp)
    80003c72:	e822                	sd	s0,16(sp)
    80003c74:	e426                	sd	s1,8(sp)
    80003c76:	e04a                	sd	s2,0(sp)
    80003c78:	1000                	addi	s0,sp,32
    80003c7a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003c7c:	00027517          	auipc	a0,0x27
    80003c80:	94c50513          	addi	a0,a0,-1716 # 8002a5c8 <itable>
    80003c84:	ffffd097          	auipc	ra,0xffffd
    80003c88:	f3e080e7          	jalr	-194(ra) # 80000bc2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c8c:	4498                	lw	a4,8(s1)
    80003c8e:	4785                	li	a5,1
    80003c90:	02f70363          	beq	a4,a5,80003cb6 <iput+0x48>
  ip->ref--;
    80003c94:	449c                	lw	a5,8(s1)
    80003c96:	37fd                	addiw	a5,a5,-1
    80003c98:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003c9a:	00027517          	auipc	a0,0x27
    80003c9e:	92e50513          	addi	a0,a0,-1746 # 8002a5c8 <itable>
    80003ca2:	ffffd097          	auipc	ra,0xffffd
    80003ca6:	fd4080e7          	jalr	-44(ra) # 80000c76 <release>
}
    80003caa:	60e2                	ld	ra,24(sp)
    80003cac:	6442                	ld	s0,16(sp)
    80003cae:	64a2                	ld	s1,8(sp)
    80003cb0:	6902                	ld	s2,0(sp)
    80003cb2:	6105                	addi	sp,sp,32
    80003cb4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003cb6:	40bc                	lw	a5,64(s1)
    80003cb8:	dff1                	beqz	a5,80003c94 <iput+0x26>
    80003cba:	04a49783          	lh	a5,74(s1)
    80003cbe:	fbf9                	bnez	a5,80003c94 <iput+0x26>
    acquiresleep(&ip->lock);
    80003cc0:	01048913          	addi	s2,s1,16
    80003cc4:	854a                	mv	a0,s2
    80003cc6:	00001097          	auipc	ra,0x1
    80003cca:	abc080e7          	jalr	-1348(ra) # 80004782 <acquiresleep>
    release(&itable.lock);
    80003cce:	00027517          	auipc	a0,0x27
    80003cd2:	8fa50513          	addi	a0,a0,-1798 # 8002a5c8 <itable>
    80003cd6:	ffffd097          	auipc	ra,0xffffd
    80003cda:	fa0080e7          	jalr	-96(ra) # 80000c76 <release>
    itrunc(ip);
    80003cde:	8526                	mv	a0,s1
    80003ce0:	00000097          	auipc	ra,0x0
    80003ce4:	ee2080e7          	jalr	-286(ra) # 80003bc2 <itrunc>
    ip->type = 0;
    80003ce8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003cec:	8526                	mv	a0,s1
    80003cee:	00000097          	auipc	ra,0x0
    80003cf2:	cfc080e7          	jalr	-772(ra) # 800039ea <iupdate>
    ip->valid = 0;
    80003cf6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003cfa:	854a                	mv	a0,s2
    80003cfc:	00001097          	auipc	ra,0x1
    80003d00:	adc080e7          	jalr	-1316(ra) # 800047d8 <releasesleep>
    acquire(&itable.lock);
    80003d04:	00027517          	auipc	a0,0x27
    80003d08:	8c450513          	addi	a0,a0,-1852 # 8002a5c8 <itable>
    80003d0c:	ffffd097          	auipc	ra,0xffffd
    80003d10:	eb6080e7          	jalr	-330(ra) # 80000bc2 <acquire>
    80003d14:	b741                	j	80003c94 <iput+0x26>

0000000080003d16 <iunlockput>:
{
    80003d16:	1101                	addi	sp,sp,-32
    80003d18:	ec06                	sd	ra,24(sp)
    80003d1a:	e822                	sd	s0,16(sp)
    80003d1c:	e426                	sd	s1,8(sp)
    80003d1e:	1000                	addi	s0,sp,32
    80003d20:	84aa                	mv	s1,a0
  iunlock(ip);
    80003d22:	00000097          	auipc	ra,0x0
    80003d26:	e54080e7          	jalr	-428(ra) # 80003b76 <iunlock>
  iput(ip);
    80003d2a:	8526                	mv	a0,s1
    80003d2c:	00000097          	auipc	ra,0x0
    80003d30:	f42080e7          	jalr	-190(ra) # 80003c6e <iput>
}
    80003d34:	60e2                	ld	ra,24(sp)
    80003d36:	6442                	ld	s0,16(sp)
    80003d38:	64a2                	ld	s1,8(sp)
    80003d3a:	6105                	addi	sp,sp,32
    80003d3c:	8082                	ret

0000000080003d3e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003d3e:	1141                	addi	sp,sp,-16
    80003d40:	e422                	sd	s0,8(sp)
    80003d42:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003d44:	411c                	lw	a5,0(a0)
    80003d46:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003d48:	415c                	lw	a5,4(a0)
    80003d4a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003d4c:	04451783          	lh	a5,68(a0)
    80003d50:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003d54:	04a51783          	lh	a5,74(a0)
    80003d58:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003d5c:	04c56783          	lwu	a5,76(a0)
    80003d60:	e99c                	sd	a5,16(a1)
}
    80003d62:	6422                	ld	s0,8(sp)
    80003d64:	0141                	addi	sp,sp,16
    80003d66:	8082                	ret

0000000080003d68 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003d68:	457c                	lw	a5,76(a0)
    80003d6a:	0ed7e963          	bltu	a5,a3,80003e5c <readi+0xf4>
{
    80003d6e:	7159                	addi	sp,sp,-112
    80003d70:	f486                	sd	ra,104(sp)
    80003d72:	f0a2                	sd	s0,96(sp)
    80003d74:	eca6                	sd	s1,88(sp)
    80003d76:	e8ca                	sd	s2,80(sp)
    80003d78:	e4ce                	sd	s3,72(sp)
    80003d7a:	e0d2                	sd	s4,64(sp)
    80003d7c:	fc56                	sd	s5,56(sp)
    80003d7e:	f85a                	sd	s6,48(sp)
    80003d80:	f45e                	sd	s7,40(sp)
    80003d82:	f062                	sd	s8,32(sp)
    80003d84:	ec66                	sd	s9,24(sp)
    80003d86:	e86a                	sd	s10,16(sp)
    80003d88:	e46e                	sd	s11,8(sp)
    80003d8a:	1880                	addi	s0,sp,112
    80003d8c:	8baa                	mv	s7,a0
    80003d8e:	8c2e                	mv	s8,a1
    80003d90:	8ab2                	mv	s5,a2
    80003d92:	84b6                	mv	s1,a3
    80003d94:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003d96:	9f35                	addw	a4,a4,a3
    return 0;
    80003d98:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003d9a:	0ad76063          	bltu	a4,a3,80003e3a <readi+0xd2>
  if(off + n > ip->size)
    80003d9e:	00e7f463          	bgeu	a5,a4,80003da6 <readi+0x3e>
    n = ip->size - off;
    80003da2:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003da6:	0a0b0963          	beqz	s6,80003e58 <readi+0xf0>
    80003daa:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003dac:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003db0:	5cfd                	li	s9,-1
    80003db2:	a82d                	j	80003dec <readi+0x84>
    80003db4:	020a1d93          	slli	s11,s4,0x20
    80003db8:	020ddd93          	srli	s11,s11,0x20
    80003dbc:	05890793          	addi	a5,s2,88
    80003dc0:	86ee                	mv	a3,s11
    80003dc2:	963e                	add	a2,a2,a5
    80003dc4:	85d6                	mv	a1,s5
    80003dc6:	8562                	mv	a0,s8
    80003dc8:	ffffe097          	auipc	ra,0xffffe
    80003dcc:	6e4080e7          	jalr	1764(ra) # 800024ac <either_copyout>
    80003dd0:	05950d63          	beq	a0,s9,80003e2a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003dd4:	854a                	mv	a0,s2
    80003dd6:	fffff097          	auipc	ra,0xfffff
    80003dda:	60a080e7          	jalr	1546(ra) # 800033e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003dde:	013a09bb          	addw	s3,s4,s3
    80003de2:	009a04bb          	addw	s1,s4,s1
    80003de6:	9aee                	add	s5,s5,s11
    80003de8:	0569f763          	bgeu	s3,s6,80003e36 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003dec:	000ba903          	lw	s2,0(s7)
    80003df0:	00a4d59b          	srliw	a1,s1,0xa
    80003df4:	855e                	mv	a0,s7
    80003df6:	00000097          	auipc	ra,0x0
    80003dfa:	8ae080e7          	jalr	-1874(ra) # 800036a4 <bmap>
    80003dfe:	0005059b          	sext.w	a1,a0
    80003e02:	854a                	mv	a0,s2
    80003e04:	fffff097          	auipc	ra,0xfffff
    80003e08:	4ac080e7          	jalr	1196(ra) # 800032b0 <bread>
    80003e0c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e0e:	3ff4f613          	andi	a2,s1,1023
    80003e12:	40cd07bb          	subw	a5,s10,a2
    80003e16:	413b073b          	subw	a4,s6,s3
    80003e1a:	8a3e                	mv	s4,a5
    80003e1c:	2781                	sext.w	a5,a5
    80003e1e:	0007069b          	sext.w	a3,a4
    80003e22:	f8f6f9e3          	bgeu	a3,a5,80003db4 <readi+0x4c>
    80003e26:	8a3a                	mv	s4,a4
    80003e28:	b771                	j	80003db4 <readi+0x4c>
      brelse(bp);
    80003e2a:	854a                	mv	a0,s2
    80003e2c:	fffff097          	auipc	ra,0xfffff
    80003e30:	5b4080e7          	jalr	1460(ra) # 800033e0 <brelse>
      tot = -1;
    80003e34:	59fd                	li	s3,-1
  }
  return tot;
    80003e36:	0009851b          	sext.w	a0,s3
}
    80003e3a:	70a6                	ld	ra,104(sp)
    80003e3c:	7406                	ld	s0,96(sp)
    80003e3e:	64e6                	ld	s1,88(sp)
    80003e40:	6946                	ld	s2,80(sp)
    80003e42:	69a6                	ld	s3,72(sp)
    80003e44:	6a06                	ld	s4,64(sp)
    80003e46:	7ae2                	ld	s5,56(sp)
    80003e48:	7b42                	ld	s6,48(sp)
    80003e4a:	7ba2                	ld	s7,40(sp)
    80003e4c:	7c02                	ld	s8,32(sp)
    80003e4e:	6ce2                	ld	s9,24(sp)
    80003e50:	6d42                	ld	s10,16(sp)
    80003e52:	6da2                	ld	s11,8(sp)
    80003e54:	6165                	addi	sp,sp,112
    80003e56:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e58:	89da                	mv	s3,s6
    80003e5a:	bff1                	j	80003e36 <readi+0xce>
    return 0;
    80003e5c:	4501                	li	a0,0
}
    80003e5e:	8082                	ret

0000000080003e60 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003e60:	457c                	lw	a5,76(a0)
    80003e62:	10d7e863          	bltu	a5,a3,80003f72 <writei+0x112>
{
    80003e66:	7159                	addi	sp,sp,-112
    80003e68:	f486                	sd	ra,104(sp)
    80003e6a:	f0a2                	sd	s0,96(sp)
    80003e6c:	eca6                	sd	s1,88(sp)
    80003e6e:	e8ca                	sd	s2,80(sp)
    80003e70:	e4ce                	sd	s3,72(sp)
    80003e72:	e0d2                	sd	s4,64(sp)
    80003e74:	fc56                	sd	s5,56(sp)
    80003e76:	f85a                	sd	s6,48(sp)
    80003e78:	f45e                	sd	s7,40(sp)
    80003e7a:	f062                	sd	s8,32(sp)
    80003e7c:	ec66                	sd	s9,24(sp)
    80003e7e:	e86a                	sd	s10,16(sp)
    80003e80:	e46e                	sd	s11,8(sp)
    80003e82:	1880                	addi	s0,sp,112
    80003e84:	8b2a                	mv	s6,a0
    80003e86:	8c2e                	mv	s8,a1
    80003e88:	8ab2                	mv	s5,a2
    80003e8a:	8936                	mv	s2,a3
    80003e8c:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003e8e:	00e687bb          	addw	a5,a3,a4
    80003e92:	0ed7e263          	bltu	a5,a3,80003f76 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003e96:	00043737          	lui	a4,0x43
    80003e9a:	0ef76063          	bltu	a4,a5,80003f7a <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003e9e:	0c0b8863          	beqz	s7,80003f6e <writei+0x10e>
    80003ea2:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ea4:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003ea8:	5cfd                	li	s9,-1
    80003eaa:	a091                	j	80003eee <writei+0x8e>
    80003eac:	02099d93          	slli	s11,s3,0x20
    80003eb0:	020ddd93          	srli	s11,s11,0x20
    80003eb4:	05848793          	addi	a5,s1,88
    80003eb8:	86ee                	mv	a3,s11
    80003eba:	8656                	mv	a2,s5
    80003ebc:	85e2                	mv	a1,s8
    80003ebe:	953e                	add	a0,a0,a5
    80003ec0:	ffffe097          	auipc	ra,0xffffe
    80003ec4:	642080e7          	jalr	1602(ra) # 80002502 <either_copyin>
    80003ec8:	07950263          	beq	a0,s9,80003f2c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003ecc:	8526                	mv	a0,s1
    80003ece:	00000097          	auipc	ra,0x0
    80003ed2:	794080e7          	jalr	1940(ra) # 80004662 <log_write>
    brelse(bp);
    80003ed6:	8526                	mv	a0,s1
    80003ed8:	fffff097          	auipc	ra,0xfffff
    80003edc:	508080e7          	jalr	1288(ra) # 800033e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ee0:	01498a3b          	addw	s4,s3,s4
    80003ee4:	0129893b          	addw	s2,s3,s2
    80003ee8:	9aee                	add	s5,s5,s11
    80003eea:	057a7663          	bgeu	s4,s7,80003f36 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003eee:	000b2483          	lw	s1,0(s6)
    80003ef2:	00a9559b          	srliw	a1,s2,0xa
    80003ef6:	855a                	mv	a0,s6
    80003ef8:	fffff097          	auipc	ra,0xfffff
    80003efc:	7ac080e7          	jalr	1964(ra) # 800036a4 <bmap>
    80003f00:	0005059b          	sext.w	a1,a0
    80003f04:	8526                	mv	a0,s1
    80003f06:	fffff097          	auipc	ra,0xfffff
    80003f0a:	3aa080e7          	jalr	938(ra) # 800032b0 <bread>
    80003f0e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f10:	3ff97513          	andi	a0,s2,1023
    80003f14:	40ad07bb          	subw	a5,s10,a0
    80003f18:	414b873b          	subw	a4,s7,s4
    80003f1c:	89be                	mv	s3,a5
    80003f1e:	2781                	sext.w	a5,a5
    80003f20:	0007069b          	sext.w	a3,a4
    80003f24:	f8f6f4e3          	bgeu	a3,a5,80003eac <writei+0x4c>
    80003f28:	89ba                	mv	s3,a4
    80003f2a:	b749                	j	80003eac <writei+0x4c>
      brelse(bp);
    80003f2c:	8526                	mv	a0,s1
    80003f2e:	fffff097          	auipc	ra,0xfffff
    80003f32:	4b2080e7          	jalr	1202(ra) # 800033e0 <brelse>
  }

  if(off > ip->size)
    80003f36:	04cb2783          	lw	a5,76(s6)
    80003f3a:	0127f463          	bgeu	a5,s2,80003f42 <writei+0xe2>
    ip->size = off;
    80003f3e:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003f42:	855a                	mv	a0,s6
    80003f44:	00000097          	auipc	ra,0x0
    80003f48:	aa6080e7          	jalr	-1370(ra) # 800039ea <iupdate>

  return tot;
    80003f4c:	000a051b          	sext.w	a0,s4
}
    80003f50:	70a6                	ld	ra,104(sp)
    80003f52:	7406                	ld	s0,96(sp)
    80003f54:	64e6                	ld	s1,88(sp)
    80003f56:	6946                	ld	s2,80(sp)
    80003f58:	69a6                	ld	s3,72(sp)
    80003f5a:	6a06                	ld	s4,64(sp)
    80003f5c:	7ae2                	ld	s5,56(sp)
    80003f5e:	7b42                	ld	s6,48(sp)
    80003f60:	7ba2                	ld	s7,40(sp)
    80003f62:	7c02                	ld	s8,32(sp)
    80003f64:	6ce2                	ld	s9,24(sp)
    80003f66:	6d42                	ld	s10,16(sp)
    80003f68:	6da2                	ld	s11,8(sp)
    80003f6a:	6165                	addi	sp,sp,112
    80003f6c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f6e:	8a5e                	mv	s4,s7
    80003f70:	bfc9                	j	80003f42 <writei+0xe2>
    return -1;
    80003f72:	557d                	li	a0,-1
}
    80003f74:	8082                	ret
    return -1;
    80003f76:	557d                	li	a0,-1
    80003f78:	bfe1                	j	80003f50 <writei+0xf0>
    return -1;
    80003f7a:	557d                	li	a0,-1
    80003f7c:	bfd1                	j	80003f50 <writei+0xf0>

0000000080003f7e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003f7e:	1141                	addi	sp,sp,-16
    80003f80:	e406                	sd	ra,8(sp)
    80003f82:	e022                	sd	s0,0(sp)
    80003f84:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003f86:	4639                	li	a2,14
    80003f88:	ffffd097          	auipc	ra,0xffffd
    80003f8c:	e0e080e7          	jalr	-498(ra) # 80000d96 <strncmp>
}
    80003f90:	60a2                	ld	ra,8(sp)
    80003f92:	6402                	ld	s0,0(sp)
    80003f94:	0141                	addi	sp,sp,16
    80003f96:	8082                	ret

0000000080003f98 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003f98:	7139                	addi	sp,sp,-64
    80003f9a:	fc06                	sd	ra,56(sp)
    80003f9c:	f822                	sd	s0,48(sp)
    80003f9e:	f426                	sd	s1,40(sp)
    80003fa0:	f04a                	sd	s2,32(sp)
    80003fa2:	ec4e                	sd	s3,24(sp)
    80003fa4:	e852                	sd	s4,16(sp)
    80003fa6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003fa8:	04451703          	lh	a4,68(a0)
    80003fac:	4785                	li	a5,1
    80003fae:	00f71a63          	bne	a4,a5,80003fc2 <dirlookup+0x2a>
    80003fb2:	892a                	mv	s2,a0
    80003fb4:	89ae                	mv	s3,a1
    80003fb6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fb8:	457c                	lw	a5,76(a0)
    80003fba:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003fbc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fbe:	e79d                	bnez	a5,80003fec <dirlookup+0x54>
    80003fc0:	a8a5                	j	80004038 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003fc2:	00004517          	auipc	a0,0x4
    80003fc6:	66e50513          	addi	a0,a0,1646 # 80008630 <syscalls+0x1b8>
    80003fca:	ffffc097          	auipc	ra,0xffffc
    80003fce:	560080e7          	jalr	1376(ra) # 8000052a <panic>
      panic("dirlookup read");
    80003fd2:	00004517          	auipc	a0,0x4
    80003fd6:	67650513          	addi	a0,a0,1654 # 80008648 <syscalls+0x1d0>
    80003fda:	ffffc097          	auipc	ra,0xffffc
    80003fde:	550080e7          	jalr	1360(ra) # 8000052a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fe2:	24c1                	addiw	s1,s1,16
    80003fe4:	04c92783          	lw	a5,76(s2)
    80003fe8:	04f4f763          	bgeu	s1,a5,80004036 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003fec:	4741                	li	a4,16
    80003fee:	86a6                	mv	a3,s1
    80003ff0:	fc040613          	addi	a2,s0,-64
    80003ff4:	4581                	li	a1,0
    80003ff6:	854a                	mv	a0,s2
    80003ff8:	00000097          	auipc	ra,0x0
    80003ffc:	d70080e7          	jalr	-656(ra) # 80003d68 <readi>
    80004000:	47c1                	li	a5,16
    80004002:	fcf518e3          	bne	a0,a5,80003fd2 <dirlookup+0x3a>
    if(de.inum == 0)
    80004006:	fc045783          	lhu	a5,-64(s0)
    8000400a:	dfe1                	beqz	a5,80003fe2 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000400c:	fc240593          	addi	a1,s0,-62
    80004010:	854e                	mv	a0,s3
    80004012:	00000097          	auipc	ra,0x0
    80004016:	f6c080e7          	jalr	-148(ra) # 80003f7e <namecmp>
    8000401a:	f561                	bnez	a0,80003fe2 <dirlookup+0x4a>
      if(poff)
    8000401c:	000a0463          	beqz	s4,80004024 <dirlookup+0x8c>
        *poff = off;
    80004020:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004024:	fc045583          	lhu	a1,-64(s0)
    80004028:	00092503          	lw	a0,0(s2)
    8000402c:	fffff097          	auipc	ra,0xfffff
    80004030:	754080e7          	jalr	1876(ra) # 80003780 <iget>
    80004034:	a011                	j	80004038 <dirlookup+0xa0>
  return 0;
    80004036:	4501                	li	a0,0
}
    80004038:	70e2                	ld	ra,56(sp)
    8000403a:	7442                	ld	s0,48(sp)
    8000403c:	74a2                	ld	s1,40(sp)
    8000403e:	7902                	ld	s2,32(sp)
    80004040:	69e2                	ld	s3,24(sp)
    80004042:	6a42                	ld	s4,16(sp)
    80004044:	6121                	addi	sp,sp,64
    80004046:	8082                	ret

0000000080004048 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004048:	711d                	addi	sp,sp,-96
    8000404a:	ec86                	sd	ra,88(sp)
    8000404c:	e8a2                	sd	s0,80(sp)
    8000404e:	e4a6                	sd	s1,72(sp)
    80004050:	e0ca                	sd	s2,64(sp)
    80004052:	fc4e                	sd	s3,56(sp)
    80004054:	f852                	sd	s4,48(sp)
    80004056:	f456                	sd	s5,40(sp)
    80004058:	f05a                	sd	s6,32(sp)
    8000405a:	ec5e                	sd	s7,24(sp)
    8000405c:	e862                	sd	s8,16(sp)
    8000405e:	e466                	sd	s9,8(sp)
    80004060:	1080                	addi	s0,sp,96
    80004062:	84aa                	mv	s1,a0
    80004064:	8aae                	mv	s5,a1
    80004066:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004068:	00054703          	lbu	a4,0(a0)
    8000406c:	02f00793          	li	a5,47
    80004070:	02f70363          	beq	a4,a5,80004096 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004074:	ffffe097          	auipc	ra,0xffffe
    80004078:	90a080e7          	jalr	-1782(ra) # 8000197e <myproc>
    8000407c:	15053503          	ld	a0,336(a0)
    80004080:	00000097          	auipc	ra,0x0
    80004084:	9f6080e7          	jalr	-1546(ra) # 80003a76 <idup>
    80004088:	89aa                	mv	s3,a0
  while(*path == '/')
    8000408a:	02f00913          	li	s2,47
  len = path - s;
    8000408e:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80004090:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004092:	4b85                	li	s7,1
    80004094:	a865                	j	8000414c <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80004096:	4585                	li	a1,1
    80004098:	4505                	li	a0,1
    8000409a:	fffff097          	auipc	ra,0xfffff
    8000409e:	6e6080e7          	jalr	1766(ra) # 80003780 <iget>
    800040a2:	89aa                	mv	s3,a0
    800040a4:	b7dd                	j	8000408a <namex+0x42>
      iunlockput(ip);
    800040a6:	854e                	mv	a0,s3
    800040a8:	00000097          	auipc	ra,0x0
    800040ac:	c6e080e7          	jalr	-914(ra) # 80003d16 <iunlockput>
      return 0;
    800040b0:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800040b2:	854e                	mv	a0,s3
    800040b4:	60e6                	ld	ra,88(sp)
    800040b6:	6446                	ld	s0,80(sp)
    800040b8:	64a6                	ld	s1,72(sp)
    800040ba:	6906                	ld	s2,64(sp)
    800040bc:	79e2                	ld	s3,56(sp)
    800040be:	7a42                	ld	s4,48(sp)
    800040c0:	7aa2                	ld	s5,40(sp)
    800040c2:	7b02                	ld	s6,32(sp)
    800040c4:	6be2                	ld	s7,24(sp)
    800040c6:	6c42                	ld	s8,16(sp)
    800040c8:	6ca2                	ld	s9,8(sp)
    800040ca:	6125                	addi	sp,sp,96
    800040cc:	8082                	ret
      iunlock(ip);
    800040ce:	854e                	mv	a0,s3
    800040d0:	00000097          	auipc	ra,0x0
    800040d4:	aa6080e7          	jalr	-1370(ra) # 80003b76 <iunlock>
      return ip;
    800040d8:	bfe9                	j	800040b2 <namex+0x6a>
      iunlockput(ip);
    800040da:	854e                	mv	a0,s3
    800040dc:	00000097          	auipc	ra,0x0
    800040e0:	c3a080e7          	jalr	-966(ra) # 80003d16 <iunlockput>
      return 0;
    800040e4:	89e6                	mv	s3,s9
    800040e6:	b7f1                	j	800040b2 <namex+0x6a>
  len = path - s;
    800040e8:	40b48633          	sub	a2,s1,a1
    800040ec:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800040f0:	099c5463          	bge	s8,s9,80004178 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800040f4:	4639                	li	a2,14
    800040f6:	8552                	mv	a0,s4
    800040f8:	ffffd097          	auipc	ra,0xffffd
    800040fc:	c22080e7          	jalr	-990(ra) # 80000d1a <memmove>
  while(*path == '/')
    80004100:	0004c783          	lbu	a5,0(s1)
    80004104:	01279763          	bne	a5,s2,80004112 <namex+0xca>
    path++;
    80004108:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000410a:	0004c783          	lbu	a5,0(s1)
    8000410e:	ff278de3          	beq	a5,s2,80004108 <namex+0xc0>
    ilock(ip);
    80004112:	854e                	mv	a0,s3
    80004114:	00000097          	auipc	ra,0x0
    80004118:	9a0080e7          	jalr	-1632(ra) # 80003ab4 <ilock>
    if(ip->type != T_DIR){
    8000411c:	04499783          	lh	a5,68(s3)
    80004120:	f97793e3          	bne	a5,s7,800040a6 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80004124:	000a8563          	beqz	s5,8000412e <namex+0xe6>
    80004128:	0004c783          	lbu	a5,0(s1)
    8000412c:	d3cd                	beqz	a5,800040ce <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000412e:	865a                	mv	a2,s6
    80004130:	85d2                	mv	a1,s4
    80004132:	854e                	mv	a0,s3
    80004134:	00000097          	auipc	ra,0x0
    80004138:	e64080e7          	jalr	-412(ra) # 80003f98 <dirlookup>
    8000413c:	8caa                	mv	s9,a0
    8000413e:	dd51                	beqz	a0,800040da <namex+0x92>
    iunlockput(ip);
    80004140:	854e                	mv	a0,s3
    80004142:	00000097          	auipc	ra,0x0
    80004146:	bd4080e7          	jalr	-1068(ra) # 80003d16 <iunlockput>
    ip = next;
    8000414a:	89e6                	mv	s3,s9
  while(*path == '/')
    8000414c:	0004c783          	lbu	a5,0(s1)
    80004150:	05279763          	bne	a5,s2,8000419e <namex+0x156>
    path++;
    80004154:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004156:	0004c783          	lbu	a5,0(s1)
    8000415a:	ff278de3          	beq	a5,s2,80004154 <namex+0x10c>
  if(*path == 0)
    8000415e:	c79d                	beqz	a5,8000418c <namex+0x144>
    path++;
    80004160:	85a6                	mv	a1,s1
  len = path - s;
    80004162:	8cda                	mv	s9,s6
    80004164:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80004166:	01278963          	beq	a5,s2,80004178 <namex+0x130>
    8000416a:	dfbd                	beqz	a5,800040e8 <namex+0xa0>
    path++;
    8000416c:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000416e:	0004c783          	lbu	a5,0(s1)
    80004172:	ff279ce3          	bne	a5,s2,8000416a <namex+0x122>
    80004176:	bf8d                	j	800040e8 <namex+0xa0>
    memmove(name, s, len);
    80004178:	2601                	sext.w	a2,a2
    8000417a:	8552                	mv	a0,s4
    8000417c:	ffffd097          	auipc	ra,0xffffd
    80004180:	b9e080e7          	jalr	-1122(ra) # 80000d1a <memmove>
    name[len] = 0;
    80004184:	9cd2                	add	s9,s9,s4
    80004186:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000418a:	bf9d                	j	80004100 <namex+0xb8>
  if(nameiparent){
    8000418c:	f20a83e3          	beqz	s5,800040b2 <namex+0x6a>
    iput(ip);
    80004190:	854e                	mv	a0,s3
    80004192:	00000097          	auipc	ra,0x0
    80004196:	adc080e7          	jalr	-1316(ra) # 80003c6e <iput>
    return 0;
    8000419a:	4981                	li	s3,0
    8000419c:	bf19                	j	800040b2 <namex+0x6a>
  if(*path == 0)
    8000419e:	d7fd                	beqz	a5,8000418c <namex+0x144>
  while(*path != '/' && *path != 0)
    800041a0:	0004c783          	lbu	a5,0(s1)
    800041a4:	85a6                	mv	a1,s1
    800041a6:	b7d1                	j	8000416a <namex+0x122>

00000000800041a8 <dirlink>:
{
    800041a8:	7139                	addi	sp,sp,-64
    800041aa:	fc06                	sd	ra,56(sp)
    800041ac:	f822                	sd	s0,48(sp)
    800041ae:	f426                	sd	s1,40(sp)
    800041b0:	f04a                	sd	s2,32(sp)
    800041b2:	ec4e                	sd	s3,24(sp)
    800041b4:	e852                	sd	s4,16(sp)
    800041b6:	0080                	addi	s0,sp,64
    800041b8:	892a                	mv	s2,a0
    800041ba:	8a2e                	mv	s4,a1
    800041bc:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800041be:	4601                	li	a2,0
    800041c0:	00000097          	auipc	ra,0x0
    800041c4:	dd8080e7          	jalr	-552(ra) # 80003f98 <dirlookup>
    800041c8:	e93d                	bnez	a0,8000423e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041ca:	04c92483          	lw	s1,76(s2)
    800041ce:	c49d                	beqz	s1,800041fc <dirlink+0x54>
    800041d0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041d2:	4741                	li	a4,16
    800041d4:	86a6                	mv	a3,s1
    800041d6:	fc040613          	addi	a2,s0,-64
    800041da:	4581                	li	a1,0
    800041dc:	854a                	mv	a0,s2
    800041de:	00000097          	auipc	ra,0x0
    800041e2:	b8a080e7          	jalr	-1142(ra) # 80003d68 <readi>
    800041e6:	47c1                	li	a5,16
    800041e8:	06f51163          	bne	a0,a5,8000424a <dirlink+0xa2>
    if(de.inum == 0)
    800041ec:	fc045783          	lhu	a5,-64(s0)
    800041f0:	c791                	beqz	a5,800041fc <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041f2:	24c1                	addiw	s1,s1,16
    800041f4:	04c92783          	lw	a5,76(s2)
    800041f8:	fcf4ede3          	bltu	s1,a5,800041d2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800041fc:	4639                	li	a2,14
    800041fe:	85d2                	mv	a1,s4
    80004200:	fc240513          	addi	a0,s0,-62
    80004204:	ffffd097          	auipc	ra,0xffffd
    80004208:	bce080e7          	jalr	-1074(ra) # 80000dd2 <strncpy>
  de.inum = inum;
    8000420c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004210:	4741                	li	a4,16
    80004212:	86a6                	mv	a3,s1
    80004214:	fc040613          	addi	a2,s0,-64
    80004218:	4581                	li	a1,0
    8000421a:	854a                	mv	a0,s2
    8000421c:	00000097          	auipc	ra,0x0
    80004220:	c44080e7          	jalr	-956(ra) # 80003e60 <writei>
    80004224:	872a                	mv	a4,a0
    80004226:	47c1                	li	a5,16
  return 0;
    80004228:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000422a:	02f71863          	bne	a4,a5,8000425a <dirlink+0xb2>
}
    8000422e:	70e2                	ld	ra,56(sp)
    80004230:	7442                	ld	s0,48(sp)
    80004232:	74a2                	ld	s1,40(sp)
    80004234:	7902                	ld	s2,32(sp)
    80004236:	69e2                	ld	s3,24(sp)
    80004238:	6a42                	ld	s4,16(sp)
    8000423a:	6121                	addi	sp,sp,64
    8000423c:	8082                	ret
    iput(ip);
    8000423e:	00000097          	auipc	ra,0x0
    80004242:	a30080e7          	jalr	-1488(ra) # 80003c6e <iput>
    return -1;
    80004246:	557d                	li	a0,-1
    80004248:	b7dd                	j	8000422e <dirlink+0x86>
      panic("dirlink read");
    8000424a:	00004517          	auipc	a0,0x4
    8000424e:	40e50513          	addi	a0,a0,1038 # 80008658 <syscalls+0x1e0>
    80004252:	ffffc097          	auipc	ra,0xffffc
    80004256:	2d8080e7          	jalr	728(ra) # 8000052a <panic>
    panic("dirlink");
    8000425a:	00004517          	auipc	a0,0x4
    8000425e:	50e50513          	addi	a0,a0,1294 # 80008768 <syscalls+0x2f0>
    80004262:	ffffc097          	auipc	ra,0xffffc
    80004266:	2c8080e7          	jalr	712(ra) # 8000052a <panic>

000000008000426a <namei>:

struct inode*
namei(char *path)
{
    8000426a:	1101                	addi	sp,sp,-32
    8000426c:	ec06                	sd	ra,24(sp)
    8000426e:	e822                	sd	s0,16(sp)
    80004270:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004272:	fe040613          	addi	a2,s0,-32
    80004276:	4581                	li	a1,0
    80004278:	00000097          	auipc	ra,0x0
    8000427c:	dd0080e7          	jalr	-560(ra) # 80004048 <namex>
}
    80004280:	60e2                	ld	ra,24(sp)
    80004282:	6442                	ld	s0,16(sp)
    80004284:	6105                	addi	sp,sp,32
    80004286:	8082                	ret

0000000080004288 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004288:	1141                	addi	sp,sp,-16
    8000428a:	e406                	sd	ra,8(sp)
    8000428c:	e022                	sd	s0,0(sp)
    8000428e:	0800                	addi	s0,sp,16
    80004290:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004292:	4585                	li	a1,1
    80004294:	00000097          	auipc	ra,0x0
    80004298:	db4080e7          	jalr	-588(ra) # 80004048 <namex>
}
    8000429c:	60a2                	ld	ra,8(sp)
    8000429e:	6402                	ld	s0,0(sp)
    800042a0:	0141                	addi	sp,sp,16
    800042a2:	8082                	ret

00000000800042a4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800042a4:	1101                	addi	sp,sp,-32
    800042a6:	ec06                	sd	ra,24(sp)
    800042a8:	e822                	sd	s0,16(sp)
    800042aa:	e426                	sd	s1,8(sp)
    800042ac:	e04a                	sd	s2,0(sp)
    800042ae:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800042b0:	00028917          	auipc	s2,0x28
    800042b4:	dc090913          	addi	s2,s2,-576 # 8002c070 <log>
    800042b8:	01892583          	lw	a1,24(s2)
    800042bc:	02892503          	lw	a0,40(s2)
    800042c0:	fffff097          	auipc	ra,0xfffff
    800042c4:	ff0080e7          	jalr	-16(ra) # 800032b0 <bread>
    800042c8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800042ca:	02c92683          	lw	a3,44(s2)
    800042ce:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800042d0:	02d05863          	blez	a3,80004300 <write_head+0x5c>
    800042d4:	00028797          	auipc	a5,0x28
    800042d8:	dcc78793          	addi	a5,a5,-564 # 8002c0a0 <log+0x30>
    800042dc:	05c50713          	addi	a4,a0,92
    800042e0:	36fd                	addiw	a3,a3,-1
    800042e2:	02069613          	slli	a2,a3,0x20
    800042e6:	01e65693          	srli	a3,a2,0x1e
    800042ea:	00028617          	auipc	a2,0x28
    800042ee:	dba60613          	addi	a2,a2,-582 # 8002c0a4 <log+0x34>
    800042f2:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800042f4:	4390                	lw	a2,0(a5)
    800042f6:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800042f8:	0791                	addi	a5,a5,4
    800042fa:	0711                	addi	a4,a4,4
    800042fc:	fed79ce3          	bne	a5,a3,800042f4 <write_head+0x50>
  }
  bwrite(buf);
    80004300:	8526                	mv	a0,s1
    80004302:	fffff097          	auipc	ra,0xfffff
    80004306:	0a0080e7          	jalr	160(ra) # 800033a2 <bwrite>
  brelse(buf);
    8000430a:	8526                	mv	a0,s1
    8000430c:	fffff097          	auipc	ra,0xfffff
    80004310:	0d4080e7          	jalr	212(ra) # 800033e0 <brelse>
}
    80004314:	60e2                	ld	ra,24(sp)
    80004316:	6442                	ld	s0,16(sp)
    80004318:	64a2                	ld	s1,8(sp)
    8000431a:	6902                	ld	s2,0(sp)
    8000431c:	6105                	addi	sp,sp,32
    8000431e:	8082                	ret

0000000080004320 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004320:	00028797          	auipc	a5,0x28
    80004324:	d7c7a783          	lw	a5,-644(a5) # 8002c09c <log+0x2c>
    80004328:	0af05d63          	blez	a5,800043e2 <install_trans+0xc2>
{
    8000432c:	7139                	addi	sp,sp,-64
    8000432e:	fc06                	sd	ra,56(sp)
    80004330:	f822                	sd	s0,48(sp)
    80004332:	f426                	sd	s1,40(sp)
    80004334:	f04a                	sd	s2,32(sp)
    80004336:	ec4e                	sd	s3,24(sp)
    80004338:	e852                	sd	s4,16(sp)
    8000433a:	e456                	sd	s5,8(sp)
    8000433c:	e05a                	sd	s6,0(sp)
    8000433e:	0080                	addi	s0,sp,64
    80004340:	8b2a                	mv	s6,a0
    80004342:	00028a97          	auipc	s5,0x28
    80004346:	d5ea8a93          	addi	s5,s5,-674 # 8002c0a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000434a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000434c:	00028997          	auipc	s3,0x28
    80004350:	d2498993          	addi	s3,s3,-732 # 8002c070 <log>
    80004354:	a00d                	j	80004376 <install_trans+0x56>
    brelse(lbuf);
    80004356:	854a                	mv	a0,s2
    80004358:	fffff097          	auipc	ra,0xfffff
    8000435c:	088080e7          	jalr	136(ra) # 800033e0 <brelse>
    brelse(dbuf);
    80004360:	8526                	mv	a0,s1
    80004362:	fffff097          	auipc	ra,0xfffff
    80004366:	07e080e7          	jalr	126(ra) # 800033e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000436a:	2a05                	addiw	s4,s4,1
    8000436c:	0a91                	addi	s5,s5,4
    8000436e:	02c9a783          	lw	a5,44(s3)
    80004372:	04fa5e63          	bge	s4,a5,800043ce <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004376:	0189a583          	lw	a1,24(s3)
    8000437a:	014585bb          	addw	a1,a1,s4
    8000437e:	2585                	addiw	a1,a1,1
    80004380:	0289a503          	lw	a0,40(s3)
    80004384:	fffff097          	auipc	ra,0xfffff
    80004388:	f2c080e7          	jalr	-212(ra) # 800032b0 <bread>
    8000438c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000438e:	000aa583          	lw	a1,0(s5)
    80004392:	0289a503          	lw	a0,40(s3)
    80004396:	fffff097          	auipc	ra,0xfffff
    8000439a:	f1a080e7          	jalr	-230(ra) # 800032b0 <bread>
    8000439e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800043a0:	40000613          	li	a2,1024
    800043a4:	05890593          	addi	a1,s2,88
    800043a8:	05850513          	addi	a0,a0,88
    800043ac:	ffffd097          	auipc	ra,0xffffd
    800043b0:	96e080e7          	jalr	-1682(ra) # 80000d1a <memmove>
    bwrite(dbuf);  // write dst to disk
    800043b4:	8526                	mv	a0,s1
    800043b6:	fffff097          	auipc	ra,0xfffff
    800043ba:	fec080e7          	jalr	-20(ra) # 800033a2 <bwrite>
    if(recovering == 0)
    800043be:	f80b1ce3          	bnez	s6,80004356 <install_trans+0x36>
      bunpin(dbuf);
    800043c2:	8526                	mv	a0,s1
    800043c4:	fffff097          	auipc	ra,0xfffff
    800043c8:	0f6080e7          	jalr	246(ra) # 800034ba <bunpin>
    800043cc:	b769                	j	80004356 <install_trans+0x36>
}
    800043ce:	70e2                	ld	ra,56(sp)
    800043d0:	7442                	ld	s0,48(sp)
    800043d2:	74a2                	ld	s1,40(sp)
    800043d4:	7902                	ld	s2,32(sp)
    800043d6:	69e2                	ld	s3,24(sp)
    800043d8:	6a42                	ld	s4,16(sp)
    800043da:	6aa2                	ld	s5,8(sp)
    800043dc:	6b02                	ld	s6,0(sp)
    800043de:	6121                	addi	sp,sp,64
    800043e0:	8082                	ret
    800043e2:	8082                	ret

00000000800043e4 <initlog>:
{
    800043e4:	7179                	addi	sp,sp,-48
    800043e6:	f406                	sd	ra,40(sp)
    800043e8:	f022                	sd	s0,32(sp)
    800043ea:	ec26                	sd	s1,24(sp)
    800043ec:	e84a                	sd	s2,16(sp)
    800043ee:	e44e                	sd	s3,8(sp)
    800043f0:	1800                	addi	s0,sp,48
    800043f2:	892a                	mv	s2,a0
    800043f4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800043f6:	00028497          	auipc	s1,0x28
    800043fa:	c7a48493          	addi	s1,s1,-902 # 8002c070 <log>
    800043fe:	00004597          	auipc	a1,0x4
    80004402:	26a58593          	addi	a1,a1,618 # 80008668 <syscalls+0x1f0>
    80004406:	8526                	mv	a0,s1
    80004408:	ffffc097          	auipc	ra,0xffffc
    8000440c:	72a080e7          	jalr	1834(ra) # 80000b32 <initlock>
  log.start = sb->logstart;
    80004410:	0149a583          	lw	a1,20(s3)
    80004414:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004416:	0109a783          	lw	a5,16(s3)
    8000441a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000441c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004420:	854a                	mv	a0,s2
    80004422:	fffff097          	auipc	ra,0xfffff
    80004426:	e8e080e7          	jalr	-370(ra) # 800032b0 <bread>
  log.lh.n = lh->n;
    8000442a:	4d34                	lw	a3,88(a0)
    8000442c:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000442e:	02d05663          	blez	a3,8000445a <initlog+0x76>
    80004432:	05c50793          	addi	a5,a0,92
    80004436:	00028717          	auipc	a4,0x28
    8000443a:	c6a70713          	addi	a4,a4,-918 # 8002c0a0 <log+0x30>
    8000443e:	36fd                	addiw	a3,a3,-1
    80004440:	02069613          	slli	a2,a3,0x20
    80004444:	01e65693          	srli	a3,a2,0x1e
    80004448:	06050613          	addi	a2,a0,96
    8000444c:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000444e:	4390                	lw	a2,0(a5)
    80004450:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004452:	0791                	addi	a5,a5,4
    80004454:	0711                	addi	a4,a4,4
    80004456:	fed79ce3          	bne	a5,a3,8000444e <initlog+0x6a>
  brelse(buf);
    8000445a:	fffff097          	auipc	ra,0xfffff
    8000445e:	f86080e7          	jalr	-122(ra) # 800033e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004462:	4505                	li	a0,1
    80004464:	00000097          	auipc	ra,0x0
    80004468:	ebc080e7          	jalr	-324(ra) # 80004320 <install_trans>
  log.lh.n = 0;
    8000446c:	00028797          	auipc	a5,0x28
    80004470:	c207a823          	sw	zero,-976(a5) # 8002c09c <log+0x2c>
  write_head(); // clear the log
    80004474:	00000097          	auipc	ra,0x0
    80004478:	e30080e7          	jalr	-464(ra) # 800042a4 <write_head>
}
    8000447c:	70a2                	ld	ra,40(sp)
    8000447e:	7402                	ld	s0,32(sp)
    80004480:	64e2                	ld	s1,24(sp)
    80004482:	6942                	ld	s2,16(sp)
    80004484:	69a2                	ld	s3,8(sp)
    80004486:	6145                	addi	sp,sp,48
    80004488:	8082                	ret

000000008000448a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000448a:	1101                	addi	sp,sp,-32
    8000448c:	ec06                	sd	ra,24(sp)
    8000448e:	e822                	sd	s0,16(sp)
    80004490:	e426                	sd	s1,8(sp)
    80004492:	e04a                	sd	s2,0(sp)
    80004494:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004496:	00028517          	auipc	a0,0x28
    8000449a:	bda50513          	addi	a0,a0,-1062 # 8002c070 <log>
    8000449e:	ffffc097          	auipc	ra,0xffffc
    800044a2:	724080e7          	jalr	1828(ra) # 80000bc2 <acquire>
  while(1){
    if(log.committing){
    800044a6:	00028497          	auipc	s1,0x28
    800044aa:	bca48493          	addi	s1,s1,-1078 # 8002c070 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800044ae:	4979                	li	s2,30
    800044b0:	a039                	j	800044be <begin_op+0x34>
      sleep(&log, &log.lock);
    800044b2:	85a6                	mv	a1,s1
    800044b4:	8526                	mv	a0,s1
    800044b6:	ffffe097          	auipc	ra,0xffffe
    800044ba:	c2c080e7          	jalr	-980(ra) # 800020e2 <sleep>
    if(log.committing){
    800044be:	50dc                	lw	a5,36(s1)
    800044c0:	fbed                	bnez	a5,800044b2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800044c2:	509c                	lw	a5,32(s1)
    800044c4:	0017871b          	addiw	a4,a5,1
    800044c8:	0007069b          	sext.w	a3,a4
    800044cc:	0027179b          	slliw	a5,a4,0x2
    800044d0:	9fb9                	addw	a5,a5,a4
    800044d2:	0017979b          	slliw	a5,a5,0x1
    800044d6:	54d8                	lw	a4,44(s1)
    800044d8:	9fb9                	addw	a5,a5,a4
    800044da:	00f95963          	bge	s2,a5,800044ec <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800044de:	85a6                	mv	a1,s1
    800044e0:	8526                	mv	a0,s1
    800044e2:	ffffe097          	auipc	ra,0xffffe
    800044e6:	c00080e7          	jalr	-1024(ra) # 800020e2 <sleep>
    800044ea:	bfd1                	j	800044be <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800044ec:	00028517          	auipc	a0,0x28
    800044f0:	b8450513          	addi	a0,a0,-1148 # 8002c070 <log>
    800044f4:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800044f6:	ffffc097          	auipc	ra,0xffffc
    800044fa:	780080e7          	jalr	1920(ra) # 80000c76 <release>
      break;
    }
  }
}
    800044fe:	60e2                	ld	ra,24(sp)
    80004500:	6442                	ld	s0,16(sp)
    80004502:	64a2                	ld	s1,8(sp)
    80004504:	6902                	ld	s2,0(sp)
    80004506:	6105                	addi	sp,sp,32
    80004508:	8082                	ret

000000008000450a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000450a:	7139                	addi	sp,sp,-64
    8000450c:	fc06                	sd	ra,56(sp)
    8000450e:	f822                	sd	s0,48(sp)
    80004510:	f426                	sd	s1,40(sp)
    80004512:	f04a                	sd	s2,32(sp)
    80004514:	ec4e                	sd	s3,24(sp)
    80004516:	e852                	sd	s4,16(sp)
    80004518:	e456                	sd	s5,8(sp)
    8000451a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000451c:	00028497          	auipc	s1,0x28
    80004520:	b5448493          	addi	s1,s1,-1196 # 8002c070 <log>
    80004524:	8526                	mv	a0,s1
    80004526:	ffffc097          	auipc	ra,0xffffc
    8000452a:	69c080e7          	jalr	1692(ra) # 80000bc2 <acquire>
  log.outstanding -= 1;
    8000452e:	509c                	lw	a5,32(s1)
    80004530:	37fd                	addiw	a5,a5,-1
    80004532:	0007891b          	sext.w	s2,a5
    80004536:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004538:	50dc                	lw	a5,36(s1)
    8000453a:	e7b9                	bnez	a5,80004588 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000453c:	04091e63          	bnez	s2,80004598 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004540:	00028497          	auipc	s1,0x28
    80004544:	b3048493          	addi	s1,s1,-1232 # 8002c070 <log>
    80004548:	4785                	li	a5,1
    8000454a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000454c:	8526                	mv	a0,s1
    8000454e:	ffffc097          	auipc	ra,0xffffc
    80004552:	728080e7          	jalr	1832(ra) # 80000c76 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004556:	54dc                	lw	a5,44(s1)
    80004558:	06f04763          	bgtz	a5,800045c6 <end_op+0xbc>
    acquire(&log.lock);
    8000455c:	00028497          	auipc	s1,0x28
    80004560:	b1448493          	addi	s1,s1,-1260 # 8002c070 <log>
    80004564:	8526                	mv	a0,s1
    80004566:	ffffc097          	auipc	ra,0xffffc
    8000456a:	65c080e7          	jalr	1628(ra) # 80000bc2 <acquire>
    log.committing = 0;
    8000456e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004572:	8526                	mv	a0,s1
    80004574:	ffffe097          	auipc	ra,0xffffe
    80004578:	cfa080e7          	jalr	-774(ra) # 8000226e <wakeup>
    release(&log.lock);
    8000457c:	8526                	mv	a0,s1
    8000457e:	ffffc097          	auipc	ra,0xffffc
    80004582:	6f8080e7          	jalr	1784(ra) # 80000c76 <release>
}
    80004586:	a03d                	j	800045b4 <end_op+0xaa>
    panic("log.committing");
    80004588:	00004517          	auipc	a0,0x4
    8000458c:	0e850513          	addi	a0,a0,232 # 80008670 <syscalls+0x1f8>
    80004590:	ffffc097          	auipc	ra,0xffffc
    80004594:	f9a080e7          	jalr	-102(ra) # 8000052a <panic>
    wakeup(&log);
    80004598:	00028497          	auipc	s1,0x28
    8000459c:	ad848493          	addi	s1,s1,-1320 # 8002c070 <log>
    800045a0:	8526                	mv	a0,s1
    800045a2:	ffffe097          	auipc	ra,0xffffe
    800045a6:	ccc080e7          	jalr	-820(ra) # 8000226e <wakeup>
  release(&log.lock);
    800045aa:	8526                	mv	a0,s1
    800045ac:	ffffc097          	auipc	ra,0xffffc
    800045b0:	6ca080e7          	jalr	1738(ra) # 80000c76 <release>
}
    800045b4:	70e2                	ld	ra,56(sp)
    800045b6:	7442                	ld	s0,48(sp)
    800045b8:	74a2                	ld	s1,40(sp)
    800045ba:	7902                	ld	s2,32(sp)
    800045bc:	69e2                	ld	s3,24(sp)
    800045be:	6a42                	ld	s4,16(sp)
    800045c0:	6aa2                	ld	s5,8(sp)
    800045c2:	6121                	addi	sp,sp,64
    800045c4:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800045c6:	00028a97          	auipc	s5,0x28
    800045ca:	adaa8a93          	addi	s5,s5,-1318 # 8002c0a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800045ce:	00028a17          	auipc	s4,0x28
    800045d2:	aa2a0a13          	addi	s4,s4,-1374 # 8002c070 <log>
    800045d6:	018a2583          	lw	a1,24(s4)
    800045da:	012585bb          	addw	a1,a1,s2
    800045de:	2585                	addiw	a1,a1,1
    800045e0:	028a2503          	lw	a0,40(s4)
    800045e4:	fffff097          	auipc	ra,0xfffff
    800045e8:	ccc080e7          	jalr	-820(ra) # 800032b0 <bread>
    800045ec:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800045ee:	000aa583          	lw	a1,0(s5)
    800045f2:	028a2503          	lw	a0,40(s4)
    800045f6:	fffff097          	auipc	ra,0xfffff
    800045fa:	cba080e7          	jalr	-838(ra) # 800032b0 <bread>
    800045fe:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004600:	40000613          	li	a2,1024
    80004604:	05850593          	addi	a1,a0,88
    80004608:	05848513          	addi	a0,s1,88
    8000460c:	ffffc097          	auipc	ra,0xffffc
    80004610:	70e080e7          	jalr	1806(ra) # 80000d1a <memmove>
    bwrite(to);  // write the log
    80004614:	8526                	mv	a0,s1
    80004616:	fffff097          	auipc	ra,0xfffff
    8000461a:	d8c080e7          	jalr	-628(ra) # 800033a2 <bwrite>
    brelse(from);
    8000461e:	854e                	mv	a0,s3
    80004620:	fffff097          	auipc	ra,0xfffff
    80004624:	dc0080e7          	jalr	-576(ra) # 800033e0 <brelse>
    brelse(to);
    80004628:	8526                	mv	a0,s1
    8000462a:	fffff097          	auipc	ra,0xfffff
    8000462e:	db6080e7          	jalr	-586(ra) # 800033e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004632:	2905                	addiw	s2,s2,1
    80004634:	0a91                	addi	s5,s5,4
    80004636:	02ca2783          	lw	a5,44(s4)
    8000463a:	f8f94ee3          	blt	s2,a5,800045d6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000463e:	00000097          	auipc	ra,0x0
    80004642:	c66080e7          	jalr	-922(ra) # 800042a4 <write_head>
    install_trans(0); // Now install writes to home locations
    80004646:	4501                	li	a0,0
    80004648:	00000097          	auipc	ra,0x0
    8000464c:	cd8080e7          	jalr	-808(ra) # 80004320 <install_trans>
    log.lh.n = 0;
    80004650:	00028797          	auipc	a5,0x28
    80004654:	a407a623          	sw	zero,-1460(a5) # 8002c09c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004658:	00000097          	auipc	ra,0x0
    8000465c:	c4c080e7          	jalr	-948(ra) # 800042a4 <write_head>
    80004660:	bdf5                	j	8000455c <end_op+0x52>

0000000080004662 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004662:	1101                	addi	sp,sp,-32
    80004664:	ec06                	sd	ra,24(sp)
    80004666:	e822                	sd	s0,16(sp)
    80004668:	e426                	sd	s1,8(sp)
    8000466a:	e04a                	sd	s2,0(sp)
    8000466c:	1000                	addi	s0,sp,32
    8000466e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004670:	00028917          	auipc	s2,0x28
    80004674:	a0090913          	addi	s2,s2,-1536 # 8002c070 <log>
    80004678:	854a                	mv	a0,s2
    8000467a:	ffffc097          	auipc	ra,0xffffc
    8000467e:	548080e7          	jalr	1352(ra) # 80000bc2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004682:	02c92603          	lw	a2,44(s2)
    80004686:	47f5                	li	a5,29
    80004688:	06c7c563          	blt	a5,a2,800046f2 <log_write+0x90>
    8000468c:	00028797          	auipc	a5,0x28
    80004690:	a007a783          	lw	a5,-1536(a5) # 8002c08c <log+0x1c>
    80004694:	37fd                	addiw	a5,a5,-1
    80004696:	04f65e63          	bge	a2,a5,800046f2 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000469a:	00028797          	auipc	a5,0x28
    8000469e:	9f67a783          	lw	a5,-1546(a5) # 8002c090 <log+0x20>
    800046a2:	06f05063          	blez	a5,80004702 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800046a6:	4781                	li	a5,0
    800046a8:	06c05563          	blez	a2,80004712 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800046ac:	44cc                	lw	a1,12(s1)
    800046ae:	00028717          	auipc	a4,0x28
    800046b2:	9f270713          	addi	a4,a4,-1550 # 8002c0a0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800046b6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800046b8:	4314                	lw	a3,0(a4)
    800046ba:	04b68c63          	beq	a3,a1,80004712 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800046be:	2785                	addiw	a5,a5,1
    800046c0:	0711                	addi	a4,a4,4
    800046c2:	fef61be3          	bne	a2,a5,800046b8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800046c6:	0621                	addi	a2,a2,8
    800046c8:	060a                	slli	a2,a2,0x2
    800046ca:	00028797          	auipc	a5,0x28
    800046ce:	9a678793          	addi	a5,a5,-1626 # 8002c070 <log>
    800046d2:	963e                	add	a2,a2,a5
    800046d4:	44dc                	lw	a5,12(s1)
    800046d6:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800046d8:	8526                	mv	a0,s1
    800046da:	fffff097          	auipc	ra,0xfffff
    800046de:	da4080e7          	jalr	-604(ra) # 8000347e <bpin>
    log.lh.n++;
    800046e2:	00028717          	auipc	a4,0x28
    800046e6:	98e70713          	addi	a4,a4,-1650 # 8002c070 <log>
    800046ea:	575c                	lw	a5,44(a4)
    800046ec:	2785                	addiw	a5,a5,1
    800046ee:	d75c                	sw	a5,44(a4)
    800046f0:	a835                	j	8000472c <log_write+0xca>
    panic("too big a transaction");
    800046f2:	00004517          	auipc	a0,0x4
    800046f6:	f8e50513          	addi	a0,a0,-114 # 80008680 <syscalls+0x208>
    800046fa:	ffffc097          	auipc	ra,0xffffc
    800046fe:	e30080e7          	jalr	-464(ra) # 8000052a <panic>
    panic("log_write outside of trans");
    80004702:	00004517          	auipc	a0,0x4
    80004706:	f9650513          	addi	a0,a0,-106 # 80008698 <syscalls+0x220>
    8000470a:	ffffc097          	auipc	ra,0xffffc
    8000470e:	e20080e7          	jalr	-480(ra) # 8000052a <panic>
  log.lh.block[i] = b->blockno;
    80004712:	00878713          	addi	a4,a5,8
    80004716:	00271693          	slli	a3,a4,0x2
    8000471a:	00028717          	auipc	a4,0x28
    8000471e:	95670713          	addi	a4,a4,-1706 # 8002c070 <log>
    80004722:	9736                	add	a4,a4,a3
    80004724:	44d4                	lw	a3,12(s1)
    80004726:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004728:	faf608e3          	beq	a2,a5,800046d8 <log_write+0x76>
  }
  release(&log.lock);
    8000472c:	00028517          	auipc	a0,0x28
    80004730:	94450513          	addi	a0,a0,-1724 # 8002c070 <log>
    80004734:	ffffc097          	auipc	ra,0xffffc
    80004738:	542080e7          	jalr	1346(ra) # 80000c76 <release>
}
    8000473c:	60e2                	ld	ra,24(sp)
    8000473e:	6442                	ld	s0,16(sp)
    80004740:	64a2                	ld	s1,8(sp)
    80004742:	6902                	ld	s2,0(sp)
    80004744:	6105                	addi	sp,sp,32
    80004746:	8082                	ret

0000000080004748 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004748:	1101                	addi	sp,sp,-32
    8000474a:	ec06                	sd	ra,24(sp)
    8000474c:	e822                	sd	s0,16(sp)
    8000474e:	e426                	sd	s1,8(sp)
    80004750:	e04a                	sd	s2,0(sp)
    80004752:	1000                	addi	s0,sp,32
    80004754:	84aa                	mv	s1,a0
    80004756:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004758:	00004597          	auipc	a1,0x4
    8000475c:	f6058593          	addi	a1,a1,-160 # 800086b8 <syscalls+0x240>
    80004760:	0521                	addi	a0,a0,8
    80004762:	ffffc097          	auipc	ra,0xffffc
    80004766:	3d0080e7          	jalr	976(ra) # 80000b32 <initlock>
  lk->name = name;
    8000476a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000476e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004772:	0204a423          	sw	zero,40(s1)
}
    80004776:	60e2                	ld	ra,24(sp)
    80004778:	6442                	ld	s0,16(sp)
    8000477a:	64a2                	ld	s1,8(sp)
    8000477c:	6902                	ld	s2,0(sp)
    8000477e:	6105                	addi	sp,sp,32
    80004780:	8082                	ret

0000000080004782 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004782:	1101                	addi	sp,sp,-32
    80004784:	ec06                	sd	ra,24(sp)
    80004786:	e822                	sd	s0,16(sp)
    80004788:	e426                	sd	s1,8(sp)
    8000478a:	e04a                	sd	s2,0(sp)
    8000478c:	1000                	addi	s0,sp,32
    8000478e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004790:	00850913          	addi	s2,a0,8
    80004794:	854a                	mv	a0,s2
    80004796:	ffffc097          	auipc	ra,0xffffc
    8000479a:	42c080e7          	jalr	1068(ra) # 80000bc2 <acquire>
  while (lk->locked) {
    8000479e:	409c                	lw	a5,0(s1)
    800047a0:	cb89                	beqz	a5,800047b2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800047a2:	85ca                	mv	a1,s2
    800047a4:	8526                	mv	a0,s1
    800047a6:	ffffe097          	auipc	ra,0xffffe
    800047aa:	93c080e7          	jalr	-1732(ra) # 800020e2 <sleep>
  while (lk->locked) {
    800047ae:	409c                	lw	a5,0(s1)
    800047b0:	fbed                	bnez	a5,800047a2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800047b2:	4785                	li	a5,1
    800047b4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800047b6:	ffffd097          	auipc	ra,0xffffd
    800047ba:	1c8080e7          	jalr	456(ra) # 8000197e <myproc>
    800047be:	591c                	lw	a5,48(a0)
    800047c0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800047c2:	854a                	mv	a0,s2
    800047c4:	ffffc097          	auipc	ra,0xffffc
    800047c8:	4b2080e7          	jalr	1202(ra) # 80000c76 <release>
}
    800047cc:	60e2                	ld	ra,24(sp)
    800047ce:	6442                	ld	s0,16(sp)
    800047d0:	64a2                	ld	s1,8(sp)
    800047d2:	6902                	ld	s2,0(sp)
    800047d4:	6105                	addi	sp,sp,32
    800047d6:	8082                	ret

00000000800047d8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800047d8:	1101                	addi	sp,sp,-32
    800047da:	ec06                	sd	ra,24(sp)
    800047dc:	e822                	sd	s0,16(sp)
    800047de:	e426                	sd	s1,8(sp)
    800047e0:	e04a                	sd	s2,0(sp)
    800047e2:	1000                	addi	s0,sp,32
    800047e4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800047e6:	00850913          	addi	s2,a0,8
    800047ea:	854a                	mv	a0,s2
    800047ec:	ffffc097          	auipc	ra,0xffffc
    800047f0:	3d6080e7          	jalr	982(ra) # 80000bc2 <acquire>
  lk->locked = 0;
    800047f4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800047f8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800047fc:	8526                	mv	a0,s1
    800047fe:	ffffe097          	auipc	ra,0xffffe
    80004802:	a70080e7          	jalr	-1424(ra) # 8000226e <wakeup>
  release(&lk->lk);
    80004806:	854a                	mv	a0,s2
    80004808:	ffffc097          	auipc	ra,0xffffc
    8000480c:	46e080e7          	jalr	1134(ra) # 80000c76 <release>
}
    80004810:	60e2                	ld	ra,24(sp)
    80004812:	6442                	ld	s0,16(sp)
    80004814:	64a2                	ld	s1,8(sp)
    80004816:	6902                	ld	s2,0(sp)
    80004818:	6105                	addi	sp,sp,32
    8000481a:	8082                	ret

000000008000481c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000481c:	7179                	addi	sp,sp,-48
    8000481e:	f406                	sd	ra,40(sp)
    80004820:	f022                	sd	s0,32(sp)
    80004822:	ec26                	sd	s1,24(sp)
    80004824:	e84a                	sd	s2,16(sp)
    80004826:	e44e                	sd	s3,8(sp)
    80004828:	1800                	addi	s0,sp,48
    8000482a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000482c:	00850913          	addi	s2,a0,8
    80004830:	854a                	mv	a0,s2
    80004832:	ffffc097          	auipc	ra,0xffffc
    80004836:	390080e7          	jalr	912(ra) # 80000bc2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000483a:	409c                	lw	a5,0(s1)
    8000483c:	ef99                	bnez	a5,8000485a <holdingsleep+0x3e>
    8000483e:	4481                	li	s1,0
  release(&lk->lk);
    80004840:	854a                	mv	a0,s2
    80004842:	ffffc097          	auipc	ra,0xffffc
    80004846:	434080e7          	jalr	1076(ra) # 80000c76 <release>
  return r;
}
    8000484a:	8526                	mv	a0,s1
    8000484c:	70a2                	ld	ra,40(sp)
    8000484e:	7402                	ld	s0,32(sp)
    80004850:	64e2                	ld	s1,24(sp)
    80004852:	6942                	ld	s2,16(sp)
    80004854:	69a2                	ld	s3,8(sp)
    80004856:	6145                	addi	sp,sp,48
    80004858:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000485a:	0284a983          	lw	s3,40(s1)
    8000485e:	ffffd097          	auipc	ra,0xffffd
    80004862:	120080e7          	jalr	288(ra) # 8000197e <myproc>
    80004866:	5904                	lw	s1,48(a0)
    80004868:	413484b3          	sub	s1,s1,s3
    8000486c:	0014b493          	seqz	s1,s1
    80004870:	bfc1                	j	80004840 <holdingsleep+0x24>

0000000080004872 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004872:	1141                	addi	sp,sp,-16
    80004874:	e406                	sd	ra,8(sp)
    80004876:	e022                	sd	s0,0(sp)
    80004878:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000487a:	00004597          	auipc	a1,0x4
    8000487e:	e4e58593          	addi	a1,a1,-434 # 800086c8 <syscalls+0x250>
    80004882:	00028517          	auipc	a0,0x28
    80004886:	93650513          	addi	a0,a0,-1738 # 8002c1b8 <ftable>
    8000488a:	ffffc097          	auipc	ra,0xffffc
    8000488e:	2a8080e7          	jalr	680(ra) # 80000b32 <initlock>
}
    80004892:	60a2                	ld	ra,8(sp)
    80004894:	6402                	ld	s0,0(sp)
    80004896:	0141                	addi	sp,sp,16
    80004898:	8082                	ret

000000008000489a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000489a:	1101                	addi	sp,sp,-32
    8000489c:	ec06                	sd	ra,24(sp)
    8000489e:	e822                	sd	s0,16(sp)
    800048a0:	e426                	sd	s1,8(sp)
    800048a2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800048a4:	00028517          	auipc	a0,0x28
    800048a8:	91450513          	addi	a0,a0,-1772 # 8002c1b8 <ftable>
    800048ac:	ffffc097          	auipc	ra,0xffffc
    800048b0:	316080e7          	jalr	790(ra) # 80000bc2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800048b4:	00028497          	auipc	s1,0x28
    800048b8:	91c48493          	addi	s1,s1,-1764 # 8002c1d0 <ftable+0x18>
    800048bc:	00029717          	auipc	a4,0x29
    800048c0:	8b470713          	addi	a4,a4,-1868 # 8002d170 <ftable+0xfb8>
    if(f->ref == 0){
    800048c4:	40dc                	lw	a5,4(s1)
    800048c6:	cf99                	beqz	a5,800048e4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800048c8:	02848493          	addi	s1,s1,40
    800048cc:	fee49ce3          	bne	s1,a4,800048c4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800048d0:	00028517          	auipc	a0,0x28
    800048d4:	8e850513          	addi	a0,a0,-1816 # 8002c1b8 <ftable>
    800048d8:	ffffc097          	auipc	ra,0xffffc
    800048dc:	39e080e7          	jalr	926(ra) # 80000c76 <release>
  return 0;
    800048e0:	4481                	li	s1,0
    800048e2:	a819                	j	800048f8 <filealloc+0x5e>
      f->ref = 1;
    800048e4:	4785                	li	a5,1
    800048e6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800048e8:	00028517          	auipc	a0,0x28
    800048ec:	8d050513          	addi	a0,a0,-1840 # 8002c1b8 <ftable>
    800048f0:	ffffc097          	auipc	ra,0xffffc
    800048f4:	386080e7          	jalr	902(ra) # 80000c76 <release>
}
    800048f8:	8526                	mv	a0,s1
    800048fa:	60e2                	ld	ra,24(sp)
    800048fc:	6442                	ld	s0,16(sp)
    800048fe:	64a2                	ld	s1,8(sp)
    80004900:	6105                	addi	sp,sp,32
    80004902:	8082                	ret

0000000080004904 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004904:	1101                	addi	sp,sp,-32
    80004906:	ec06                	sd	ra,24(sp)
    80004908:	e822                	sd	s0,16(sp)
    8000490a:	e426                	sd	s1,8(sp)
    8000490c:	1000                	addi	s0,sp,32
    8000490e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004910:	00028517          	auipc	a0,0x28
    80004914:	8a850513          	addi	a0,a0,-1880 # 8002c1b8 <ftable>
    80004918:	ffffc097          	auipc	ra,0xffffc
    8000491c:	2aa080e7          	jalr	682(ra) # 80000bc2 <acquire>
  if(f->ref < 1)
    80004920:	40dc                	lw	a5,4(s1)
    80004922:	02f05263          	blez	a5,80004946 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004926:	2785                	addiw	a5,a5,1
    80004928:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000492a:	00028517          	auipc	a0,0x28
    8000492e:	88e50513          	addi	a0,a0,-1906 # 8002c1b8 <ftable>
    80004932:	ffffc097          	auipc	ra,0xffffc
    80004936:	344080e7          	jalr	836(ra) # 80000c76 <release>
  return f;
}
    8000493a:	8526                	mv	a0,s1
    8000493c:	60e2                	ld	ra,24(sp)
    8000493e:	6442                	ld	s0,16(sp)
    80004940:	64a2                	ld	s1,8(sp)
    80004942:	6105                	addi	sp,sp,32
    80004944:	8082                	ret
    panic("filedup");
    80004946:	00004517          	auipc	a0,0x4
    8000494a:	d8a50513          	addi	a0,a0,-630 # 800086d0 <syscalls+0x258>
    8000494e:	ffffc097          	auipc	ra,0xffffc
    80004952:	bdc080e7          	jalr	-1060(ra) # 8000052a <panic>

0000000080004956 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004956:	7139                	addi	sp,sp,-64
    80004958:	fc06                	sd	ra,56(sp)
    8000495a:	f822                	sd	s0,48(sp)
    8000495c:	f426                	sd	s1,40(sp)
    8000495e:	f04a                	sd	s2,32(sp)
    80004960:	ec4e                	sd	s3,24(sp)
    80004962:	e852                	sd	s4,16(sp)
    80004964:	e456                	sd	s5,8(sp)
    80004966:	0080                	addi	s0,sp,64
    80004968:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000496a:	00028517          	auipc	a0,0x28
    8000496e:	84e50513          	addi	a0,a0,-1970 # 8002c1b8 <ftable>
    80004972:	ffffc097          	auipc	ra,0xffffc
    80004976:	250080e7          	jalr	592(ra) # 80000bc2 <acquire>
  if(f->ref < 1)
    8000497a:	40dc                	lw	a5,4(s1)
    8000497c:	06f05163          	blez	a5,800049de <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004980:	37fd                	addiw	a5,a5,-1
    80004982:	0007871b          	sext.w	a4,a5
    80004986:	c0dc                	sw	a5,4(s1)
    80004988:	06e04363          	bgtz	a4,800049ee <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000498c:	0004a903          	lw	s2,0(s1)
    80004990:	0094ca83          	lbu	s5,9(s1)
    80004994:	0104ba03          	ld	s4,16(s1)
    80004998:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000499c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800049a0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800049a4:	00028517          	auipc	a0,0x28
    800049a8:	81450513          	addi	a0,a0,-2028 # 8002c1b8 <ftable>
    800049ac:	ffffc097          	auipc	ra,0xffffc
    800049b0:	2ca080e7          	jalr	714(ra) # 80000c76 <release>

  if(ff.type == FD_PIPE){
    800049b4:	4785                	li	a5,1
    800049b6:	04f90d63          	beq	s2,a5,80004a10 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800049ba:	3979                	addiw	s2,s2,-2
    800049bc:	4785                	li	a5,1
    800049be:	0527e063          	bltu	a5,s2,800049fe <fileclose+0xa8>
    begin_op();
    800049c2:	00000097          	auipc	ra,0x0
    800049c6:	ac8080e7          	jalr	-1336(ra) # 8000448a <begin_op>
    iput(ff.ip);
    800049ca:	854e                	mv	a0,s3
    800049cc:	fffff097          	auipc	ra,0xfffff
    800049d0:	2a2080e7          	jalr	674(ra) # 80003c6e <iput>
    end_op();
    800049d4:	00000097          	auipc	ra,0x0
    800049d8:	b36080e7          	jalr	-1226(ra) # 8000450a <end_op>
    800049dc:	a00d                	j	800049fe <fileclose+0xa8>
    panic("fileclose");
    800049de:	00004517          	auipc	a0,0x4
    800049e2:	cfa50513          	addi	a0,a0,-774 # 800086d8 <syscalls+0x260>
    800049e6:	ffffc097          	auipc	ra,0xffffc
    800049ea:	b44080e7          	jalr	-1212(ra) # 8000052a <panic>
    release(&ftable.lock);
    800049ee:	00027517          	auipc	a0,0x27
    800049f2:	7ca50513          	addi	a0,a0,1994 # 8002c1b8 <ftable>
    800049f6:	ffffc097          	auipc	ra,0xffffc
    800049fa:	280080e7          	jalr	640(ra) # 80000c76 <release>
  }
}
    800049fe:	70e2                	ld	ra,56(sp)
    80004a00:	7442                	ld	s0,48(sp)
    80004a02:	74a2                	ld	s1,40(sp)
    80004a04:	7902                	ld	s2,32(sp)
    80004a06:	69e2                	ld	s3,24(sp)
    80004a08:	6a42                	ld	s4,16(sp)
    80004a0a:	6aa2                	ld	s5,8(sp)
    80004a0c:	6121                	addi	sp,sp,64
    80004a0e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004a10:	85d6                	mv	a1,s5
    80004a12:	8552                	mv	a0,s4
    80004a14:	00000097          	auipc	ra,0x0
    80004a18:	34c080e7          	jalr	844(ra) # 80004d60 <pipeclose>
    80004a1c:	b7cd                	j	800049fe <fileclose+0xa8>

0000000080004a1e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004a1e:	715d                	addi	sp,sp,-80
    80004a20:	e486                	sd	ra,72(sp)
    80004a22:	e0a2                	sd	s0,64(sp)
    80004a24:	fc26                	sd	s1,56(sp)
    80004a26:	f84a                	sd	s2,48(sp)
    80004a28:	f44e                	sd	s3,40(sp)
    80004a2a:	0880                	addi	s0,sp,80
    80004a2c:	84aa                	mv	s1,a0
    80004a2e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004a30:	ffffd097          	auipc	ra,0xffffd
    80004a34:	f4e080e7          	jalr	-178(ra) # 8000197e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004a38:	409c                	lw	a5,0(s1)
    80004a3a:	37f9                	addiw	a5,a5,-2
    80004a3c:	4705                	li	a4,1
    80004a3e:	04f76763          	bltu	a4,a5,80004a8c <filestat+0x6e>
    80004a42:	892a                	mv	s2,a0
    ilock(f->ip);
    80004a44:	6c88                	ld	a0,24(s1)
    80004a46:	fffff097          	auipc	ra,0xfffff
    80004a4a:	06e080e7          	jalr	110(ra) # 80003ab4 <ilock>
    stati(f->ip, &st);
    80004a4e:	fb840593          	addi	a1,s0,-72
    80004a52:	6c88                	ld	a0,24(s1)
    80004a54:	fffff097          	auipc	ra,0xfffff
    80004a58:	2ea080e7          	jalr	746(ra) # 80003d3e <stati>
    iunlock(f->ip);
    80004a5c:	6c88                	ld	a0,24(s1)
    80004a5e:	fffff097          	auipc	ra,0xfffff
    80004a62:	118080e7          	jalr	280(ra) # 80003b76 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004a66:	46e1                	li	a3,24
    80004a68:	fb840613          	addi	a2,s0,-72
    80004a6c:	85ce                	mv	a1,s3
    80004a6e:	05093503          	ld	a0,80(s2)
    80004a72:	ffffd097          	auipc	ra,0xffffd
    80004a76:	bcc080e7          	jalr	-1076(ra) # 8000163e <copyout>
    80004a7a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004a7e:	60a6                	ld	ra,72(sp)
    80004a80:	6406                	ld	s0,64(sp)
    80004a82:	74e2                	ld	s1,56(sp)
    80004a84:	7942                	ld	s2,48(sp)
    80004a86:	79a2                	ld	s3,40(sp)
    80004a88:	6161                	addi	sp,sp,80
    80004a8a:	8082                	ret
  return -1;
    80004a8c:	557d                	li	a0,-1
    80004a8e:	bfc5                	j	80004a7e <filestat+0x60>

0000000080004a90 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004a90:	7179                	addi	sp,sp,-48
    80004a92:	f406                	sd	ra,40(sp)
    80004a94:	f022                	sd	s0,32(sp)
    80004a96:	ec26                	sd	s1,24(sp)
    80004a98:	e84a                	sd	s2,16(sp)
    80004a9a:	e44e                	sd	s3,8(sp)
    80004a9c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004a9e:	00854783          	lbu	a5,8(a0)
    80004aa2:	c3d5                	beqz	a5,80004b46 <fileread+0xb6>
    80004aa4:	84aa                	mv	s1,a0
    80004aa6:	89ae                	mv	s3,a1
    80004aa8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004aaa:	411c                	lw	a5,0(a0)
    80004aac:	4705                	li	a4,1
    80004aae:	04e78963          	beq	a5,a4,80004b00 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004ab2:	470d                	li	a4,3
    80004ab4:	04e78d63          	beq	a5,a4,80004b0e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004ab8:	4709                	li	a4,2
    80004aba:	06e79e63          	bne	a5,a4,80004b36 <fileread+0xa6>
    ilock(f->ip);
    80004abe:	6d08                	ld	a0,24(a0)
    80004ac0:	fffff097          	auipc	ra,0xfffff
    80004ac4:	ff4080e7          	jalr	-12(ra) # 80003ab4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004ac8:	874a                	mv	a4,s2
    80004aca:	5094                	lw	a3,32(s1)
    80004acc:	864e                	mv	a2,s3
    80004ace:	4585                	li	a1,1
    80004ad0:	6c88                	ld	a0,24(s1)
    80004ad2:	fffff097          	auipc	ra,0xfffff
    80004ad6:	296080e7          	jalr	662(ra) # 80003d68 <readi>
    80004ada:	892a                	mv	s2,a0
    80004adc:	00a05563          	blez	a0,80004ae6 <fileread+0x56>
      f->off += r;
    80004ae0:	509c                	lw	a5,32(s1)
    80004ae2:	9fa9                	addw	a5,a5,a0
    80004ae4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004ae6:	6c88                	ld	a0,24(s1)
    80004ae8:	fffff097          	auipc	ra,0xfffff
    80004aec:	08e080e7          	jalr	142(ra) # 80003b76 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004af0:	854a                	mv	a0,s2
    80004af2:	70a2                	ld	ra,40(sp)
    80004af4:	7402                	ld	s0,32(sp)
    80004af6:	64e2                	ld	s1,24(sp)
    80004af8:	6942                	ld	s2,16(sp)
    80004afa:	69a2                	ld	s3,8(sp)
    80004afc:	6145                	addi	sp,sp,48
    80004afe:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004b00:	6908                	ld	a0,16(a0)
    80004b02:	00000097          	auipc	ra,0x0
    80004b06:	3c0080e7          	jalr	960(ra) # 80004ec2 <piperead>
    80004b0a:	892a                	mv	s2,a0
    80004b0c:	b7d5                	j	80004af0 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004b0e:	02451783          	lh	a5,36(a0)
    80004b12:	03079693          	slli	a3,a5,0x30
    80004b16:	92c1                	srli	a3,a3,0x30
    80004b18:	4725                	li	a4,9
    80004b1a:	02d76863          	bltu	a4,a3,80004b4a <fileread+0xba>
    80004b1e:	0792                	slli	a5,a5,0x4
    80004b20:	00027717          	auipc	a4,0x27
    80004b24:	5f870713          	addi	a4,a4,1528 # 8002c118 <devsw>
    80004b28:	97ba                	add	a5,a5,a4
    80004b2a:	639c                	ld	a5,0(a5)
    80004b2c:	c38d                	beqz	a5,80004b4e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004b2e:	4505                	li	a0,1
    80004b30:	9782                	jalr	a5
    80004b32:	892a                	mv	s2,a0
    80004b34:	bf75                	j	80004af0 <fileread+0x60>
    panic("fileread");
    80004b36:	00004517          	auipc	a0,0x4
    80004b3a:	bb250513          	addi	a0,a0,-1102 # 800086e8 <syscalls+0x270>
    80004b3e:	ffffc097          	auipc	ra,0xffffc
    80004b42:	9ec080e7          	jalr	-1556(ra) # 8000052a <panic>
    return -1;
    80004b46:	597d                	li	s2,-1
    80004b48:	b765                	j	80004af0 <fileread+0x60>
      return -1;
    80004b4a:	597d                	li	s2,-1
    80004b4c:	b755                	j	80004af0 <fileread+0x60>
    80004b4e:	597d                	li	s2,-1
    80004b50:	b745                	j	80004af0 <fileread+0x60>

0000000080004b52 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004b52:	715d                	addi	sp,sp,-80
    80004b54:	e486                	sd	ra,72(sp)
    80004b56:	e0a2                	sd	s0,64(sp)
    80004b58:	fc26                	sd	s1,56(sp)
    80004b5a:	f84a                	sd	s2,48(sp)
    80004b5c:	f44e                	sd	s3,40(sp)
    80004b5e:	f052                	sd	s4,32(sp)
    80004b60:	ec56                	sd	s5,24(sp)
    80004b62:	e85a                	sd	s6,16(sp)
    80004b64:	e45e                	sd	s7,8(sp)
    80004b66:	e062                	sd	s8,0(sp)
    80004b68:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004b6a:	00954783          	lbu	a5,9(a0)
    80004b6e:	10078663          	beqz	a5,80004c7a <filewrite+0x128>
    80004b72:	892a                	mv	s2,a0
    80004b74:	8aae                	mv	s5,a1
    80004b76:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004b78:	411c                	lw	a5,0(a0)
    80004b7a:	4705                	li	a4,1
    80004b7c:	02e78263          	beq	a5,a4,80004ba0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004b80:	470d                	li	a4,3
    80004b82:	02e78663          	beq	a5,a4,80004bae <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004b86:	4709                	li	a4,2
    80004b88:	0ee79163          	bne	a5,a4,80004c6a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004b8c:	0ac05d63          	blez	a2,80004c46 <filewrite+0xf4>
    int i = 0;
    80004b90:	4981                	li	s3,0
    80004b92:	6b05                	lui	s6,0x1
    80004b94:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004b98:	6b85                	lui	s7,0x1
    80004b9a:	c00b8b9b          	addiw	s7,s7,-1024
    80004b9e:	a861                	j	80004c36 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004ba0:	6908                	ld	a0,16(a0)
    80004ba2:	00000097          	auipc	ra,0x0
    80004ba6:	22e080e7          	jalr	558(ra) # 80004dd0 <pipewrite>
    80004baa:	8a2a                	mv	s4,a0
    80004bac:	a045                	j	80004c4c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004bae:	02451783          	lh	a5,36(a0)
    80004bb2:	03079693          	slli	a3,a5,0x30
    80004bb6:	92c1                	srli	a3,a3,0x30
    80004bb8:	4725                	li	a4,9
    80004bba:	0cd76263          	bltu	a4,a3,80004c7e <filewrite+0x12c>
    80004bbe:	0792                	slli	a5,a5,0x4
    80004bc0:	00027717          	auipc	a4,0x27
    80004bc4:	55870713          	addi	a4,a4,1368 # 8002c118 <devsw>
    80004bc8:	97ba                	add	a5,a5,a4
    80004bca:	679c                	ld	a5,8(a5)
    80004bcc:	cbdd                	beqz	a5,80004c82 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004bce:	4505                	li	a0,1
    80004bd0:	9782                	jalr	a5
    80004bd2:	8a2a                	mv	s4,a0
    80004bd4:	a8a5                	j	80004c4c <filewrite+0xfa>
    80004bd6:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004bda:	00000097          	auipc	ra,0x0
    80004bde:	8b0080e7          	jalr	-1872(ra) # 8000448a <begin_op>
      ilock(f->ip);
    80004be2:	01893503          	ld	a0,24(s2)
    80004be6:	fffff097          	auipc	ra,0xfffff
    80004bea:	ece080e7          	jalr	-306(ra) # 80003ab4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004bee:	8762                	mv	a4,s8
    80004bf0:	02092683          	lw	a3,32(s2)
    80004bf4:	01598633          	add	a2,s3,s5
    80004bf8:	4585                	li	a1,1
    80004bfa:	01893503          	ld	a0,24(s2)
    80004bfe:	fffff097          	auipc	ra,0xfffff
    80004c02:	262080e7          	jalr	610(ra) # 80003e60 <writei>
    80004c06:	84aa                	mv	s1,a0
    80004c08:	00a05763          	blez	a0,80004c16 <filewrite+0xc4>
        f->off += r;
    80004c0c:	02092783          	lw	a5,32(s2)
    80004c10:	9fa9                	addw	a5,a5,a0
    80004c12:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004c16:	01893503          	ld	a0,24(s2)
    80004c1a:	fffff097          	auipc	ra,0xfffff
    80004c1e:	f5c080e7          	jalr	-164(ra) # 80003b76 <iunlock>
      end_op();
    80004c22:	00000097          	auipc	ra,0x0
    80004c26:	8e8080e7          	jalr	-1816(ra) # 8000450a <end_op>

      if(r != n1){
    80004c2a:	009c1f63          	bne	s8,s1,80004c48 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004c2e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004c32:	0149db63          	bge	s3,s4,80004c48 <filewrite+0xf6>
      int n1 = n - i;
    80004c36:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004c3a:	84be                	mv	s1,a5
    80004c3c:	2781                	sext.w	a5,a5
    80004c3e:	f8fb5ce3          	bge	s6,a5,80004bd6 <filewrite+0x84>
    80004c42:	84de                	mv	s1,s7
    80004c44:	bf49                	j	80004bd6 <filewrite+0x84>
    int i = 0;
    80004c46:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004c48:	013a1f63          	bne	s4,s3,80004c66 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004c4c:	8552                	mv	a0,s4
    80004c4e:	60a6                	ld	ra,72(sp)
    80004c50:	6406                	ld	s0,64(sp)
    80004c52:	74e2                	ld	s1,56(sp)
    80004c54:	7942                	ld	s2,48(sp)
    80004c56:	79a2                	ld	s3,40(sp)
    80004c58:	7a02                	ld	s4,32(sp)
    80004c5a:	6ae2                	ld	s5,24(sp)
    80004c5c:	6b42                	ld	s6,16(sp)
    80004c5e:	6ba2                	ld	s7,8(sp)
    80004c60:	6c02                	ld	s8,0(sp)
    80004c62:	6161                	addi	sp,sp,80
    80004c64:	8082                	ret
    ret = (i == n ? n : -1);
    80004c66:	5a7d                	li	s4,-1
    80004c68:	b7d5                	j	80004c4c <filewrite+0xfa>
    panic("filewrite");
    80004c6a:	00004517          	auipc	a0,0x4
    80004c6e:	a8e50513          	addi	a0,a0,-1394 # 800086f8 <syscalls+0x280>
    80004c72:	ffffc097          	auipc	ra,0xffffc
    80004c76:	8b8080e7          	jalr	-1864(ra) # 8000052a <panic>
    return -1;
    80004c7a:	5a7d                	li	s4,-1
    80004c7c:	bfc1                	j	80004c4c <filewrite+0xfa>
      return -1;
    80004c7e:	5a7d                	li	s4,-1
    80004c80:	b7f1                	j	80004c4c <filewrite+0xfa>
    80004c82:	5a7d                	li	s4,-1
    80004c84:	b7e1                	j	80004c4c <filewrite+0xfa>

0000000080004c86 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004c86:	7179                	addi	sp,sp,-48
    80004c88:	f406                	sd	ra,40(sp)
    80004c8a:	f022                	sd	s0,32(sp)
    80004c8c:	ec26                	sd	s1,24(sp)
    80004c8e:	e84a                	sd	s2,16(sp)
    80004c90:	e44e                	sd	s3,8(sp)
    80004c92:	e052                	sd	s4,0(sp)
    80004c94:	1800                	addi	s0,sp,48
    80004c96:	84aa                	mv	s1,a0
    80004c98:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004c9a:	0005b023          	sd	zero,0(a1)
    80004c9e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004ca2:	00000097          	auipc	ra,0x0
    80004ca6:	bf8080e7          	jalr	-1032(ra) # 8000489a <filealloc>
    80004caa:	e088                	sd	a0,0(s1)
    80004cac:	c551                	beqz	a0,80004d38 <pipealloc+0xb2>
    80004cae:	00000097          	auipc	ra,0x0
    80004cb2:	bec080e7          	jalr	-1044(ra) # 8000489a <filealloc>
    80004cb6:	00aa3023          	sd	a0,0(s4)
    80004cba:	c92d                	beqz	a0,80004d2c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004cbc:	ffffc097          	auipc	ra,0xffffc
    80004cc0:	e16080e7          	jalr	-490(ra) # 80000ad2 <kalloc>
    80004cc4:	892a                	mv	s2,a0
    80004cc6:	c125                	beqz	a0,80004d26 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004cc8:	4985                	li	s3,1
    80004cca:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004cce:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004cd2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004cd6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004cda:	00004597          	auipc	a1,0x4
    80004cde:	a2e58593          	addi	a1,a1,-1490 # 80008708 <syscalls+0x290>
    80004ce2:	ffffc097          	auipc	ra,0xffffc
    80004ce6:	e50080e7          	jalr	-432(ra) # 80000b32 <initlock>
  (*f0)->type = FD_PIPE;
    80004cea:	609c                	ld	a5,0(s1)
    80004cec:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004cf0:	609c                	ld	a5,0(s1)
    80004cf2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004cf6:	609c                	ld	a5,0(s1)
    80004cf8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004cfc:	609c                	ld	a5,0(s1)
    80004cfe:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004d02:	000a3783          	ld	a5,0(s4)
    80004d06:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004d0a:	000a3783          	ld	a5,0(s4)
    80004d0e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004d12:	000a3783          	ld	a5,0(s4)
    80004d16:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004d1a:	000a3783          	ld	a5,0(s4)
    80004d1e:	0127b823          	sd	s2,16(a5)
  return 0;
    80004d22:	4501                	li	a0,0
    80004d24:	a025                	j	80004d4c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004d26:	6088                	ld	a0,0(s1)
    80004d28:	e501                	bnez	a0,80004d30 <pipealloc+0xaa>
    80004d2a:	a039                	j	80004d38 <pipealloc+0xb2>
    80004d2c:	6088                	ld	a0,0(s1)
    80004d2e:	c51d                	beqz	a0,80004d5c <pipealloc+0xd6>
    fileclose(*f0);
    80004d30:	00000097          	auipc	ra,0x0
    80004d34:	c26080e7          	jalr	-986(ra) # 80004956 <fileclose>
  if(*f1)
    80004d38:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004d3c:	557d                	li	a0,-1
  if(*f1)
    80004d3e:	c799                	beqz	a5,80004d4c <pipealloc+0xc6>
    fileclose(*f1);
    80004d40:	853e                	mv	a0,a5
    80004d42:	00000097          	auipc	ra,0x0
    80004d46:	c14080e7          	jalr	-1004(ra) # 80004956 <fileclose>
  return -1;
    80004d4a:	557d                	li	a0,-1
}
    80004d4c:	70a2                	ld	ra,40(sp)
    80004d4e:	7402                	ld	s0,32(sp)
    80004d50:	64e2                	ld	s1,24(sp)
    80004d52:	6942                	ld	s2,16(sp)
    80004d54:	69a2                	ld	s3,8(sp)
    80004d56:	6a02                	ld	s4,0(sp)
    80004d58:	6145                	addi	sp,sp,48
    80004d5a:	8082                	ret
  return -1;
    80004d5c:	557d                	li	a0,-1
    80004d5e:	b7fd                	j	80004d4c <pipealloc+0xc6>

0000000080004d60 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004d60:	1101                	addi	sp,sp,-32
    80004d62:	ec06                	sd	ra,24(sp)
    80004d64:	e822                	sd	s0,16(sp)
    80004d66:	e426                	sd	s1,8(sp)
    80004d68:	e04a                	sd	s2,0(sp)
    80004d6a:	1000                	addi	s0,sp,32
    80004d6c:	84aa                	mv	s1,a0
    80004d6e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004d70:	ffffc097          	auipc	ra,0xffffc
    80004d74:	e52080e7          	jalr	-430(ra) # 80000bc2 <acquire>
  if(writable){
    80004d78:	02090d63          	beqz	s2,80004db2 <pipeclose+0x52>
    pi->writeopen = 0;
    80004d7c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004d80:	21848513          	addi	a0,s1,536
    80004d84:	ffffd097          	auipc	ra,0xffffd
    80004d88:	4ea080e7          	jalr	1258(ra) # 8000226e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004d8c:	2204b783          	ld	a5,544(s1)
    80004d90:	eb95                	bnez	a5,80004dc4 <pipeclose+0x64>
    release(&pi->lock);
    80004d92:	8526                	mv	a0,s1
    80004d94:	ffffc097          	auipc	ra,0xffffc
    80004d98:	ee2080e7          	jalr	-286(ra) # 80000c76 <release>
    kfree((char*)pi);
    80004d9c:	8526                	mv	a0,s1
    80004d9e:	ffffc097          	auipc	ra,0xffffc
    80004da2:	c38080e7          	jalr	-968(ra) # 800009d6 <kfree>
  } else
    release(&pi->lock);
}
    80004da6:	60e2                	ld	ra,24(sp)
    80004da8:	6442                	ld	s0,16(sp)
    80004daa:	64a2                	ld	s1,8(sp)
    80004dac:	6902                	ld	s2,0(sp)
    80004dae:	6105                	addi	sp,sp,32
    80004db0:	8082                	ret
    pi->readopen = 0;
    80004db2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004db6:	21c48513          	addi	a0,s1,540
    80004dba:	ffffd097          	auipc	ra,0xffffd
    80004dbe:	4b4080e7          	jalr	1204(ra) # 8000226e <wakeup>
    80004dc2:	b7e9                	j	80004d8c <pipeclose+0x2c>
    release(&pi->lock);
    80004dc4:	8526                	mv	a0,s1
    80004dc6:	ffffc097          	auipc	ra,0xffffc
    80004dca:	eb0080e7          	jalr	-336(ra) # 80000c76 <release>
}
    80004dce:	bfe1                	j	80004da6 <pipeclose+0x46>

0000000080004dd0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004dd0:	711d                	addi	sp,sp,-96
    80004dd2:	ec86                	sd	ra,88(sp)
    80004dd4:	e8a2                	sd	s0,80(sp)
    80004dd6:	e4a6                	sd	s1,72(sp)
    80004dd8:	e0ca                	sd	s2,64(sp)
    80004dda:	fc4e                	sd	s3,56(sp)
    80004ddc:	f852                	sd	s4,48(sp)
    80004dde:	f456                	sd	s5,40(sp)
    80004de0:	f05a                	sd	s6,32(sp)
    80004de2:	ec5e                	sd	s7,24(sp)
    80004de4:	e862                	sd	s8,16(sp)
    80004de6:	1080                	addi	s0,sp,96
    80004de8:	84aa                	mv	s1,a0
    80004dea:	8aae                	mv	s5,a1
    80004dec:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004dee:	ffffd097          	auipc	ra,0xffffd
    80004df2:	b90080e7          	jalr	-1136(ra) # 8000197e <myproc>
    80004df6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004df8:	8526                	mv	a0,s1
    80004dfa:	ffffc097          	auipc	ra,0xffffc
    80004dfe:	dc8080e7          	jalr	-568(ra) # 80000bc2 <acquire>
  while(i < n){
    80004e02:	0b405363          	blez	s4,80004ea8 <pipewrite+0xd8>
  int i = 0;
    80004e06:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004e08:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004e0a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004e0e:	21c48b93          	addi	s7,s1,540
    80004e12:	a089                	j	80004e54 <pipewrite+0x84>
      release(&pi->lock);
    80004e14:	8526                	mv	a0,s1
    80004e16:	ffffc097          	auipc	ra,0xffffc
    80004e1a:	e60080e7          	jalr	-416(ra) # 80000c76 <release>
      return -1;
    80004e1e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004e20:	854a                	mv	a0,s2
    80004e22:	60e6                	ld	ra,88(sp)
    80004e24:	6446                	ld	s0,80(sp)
    80004e26:	64a6                	ld	s1,72(sp)
    80004e28:	6906                	ld	s2,64(sp)
    80004e2a:	79e2                	ld	s3,56(sp)
    80004e2c:	7a42                	ld	s4,48(sp)
    80004e2e:	7aa2                	ld	s5,40(sp)
    80004e30:	7b02                	ld	s6,32(sp)
    80004e32:	6be2                	ld	s7,24(sp)
    80004e34:	6c42                	ld	s8,16(sp)
    80004e36:	6125                	addi	sp,sp,96
    80004e38:	8082                	ret
      wakeup(&pi->nread);
    80004e3a:	8562                	mv	a0,s8
    80004e3c:	ffffd097          	auipc	ra,0xffffd
    80004e40:	432080e7          	jalr	1074(ra) # 8000226e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004e44:	85a6                	mv	a1,s1
    80004e46:	855e                	mv	a0,s7
    80004e48:	ffffd097          	auipc	ra,0xffffd
    80004e4c:	29a080e7          	jalr	666(ra) # 800020e2 <sleep>
  while(i < n){
    80004e50:	05495d63          	bge	s2,s4,80004eaa <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80004e54:	2204a783          	lw	a5,544(s1)
    80004e58:	dfd5                	beqz	a5,80004e14 <pipewrite+0x44>
    80004e5a:	0289a783          	lw	a5,40(s3)
    80004e5e:	fbdd                	bnez	a5,80004e14 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004e60:	2184a783          	lw	a5,536(s1)
    80004e64:	21c4a703          	lw	a4,540(s1)
    80004e68:	2007879b          	addiw	a5,a5,512
    80004e6c:	fcf707e3          	beq	a4,a5,80004e3a <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004e70:	4685                	li	a3,1
    80004e72:	01590633          	add	a2,s2,s5
    80004e76:	faf40593          	addi	a1,s0,-81
    80004e7a:	0509b503          	ld	a0,80(s3)
    80004e7e:	ffffd097          	auipc	ra,0xffffd
    80004e82:	84c080e7          	jalr	-1972(ra) # 800016ca <copyin>
    80004e86:	03650263          	beq	a0,s6,80004eaa <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004e8a:	21c4a783          	lw	a5,540(s1)
    80004e8e:	0017871b          	addiw	a4,a5,1
    80004e92:	20e4ae23          	sw	a4,540(s1)
    80004e96:	1ff7f793          	andi	a5,a5,511
    80004e9a:	97a6                	add	a5,a5,s1
    80004e9c:	faf44703          	lbu	a4,-81(s0)
    80004ea0:	00e78c23          	sb	a4,24(a5)
      i++;
    80004ea4:	2905                	addiw	s2,s2,1
    80004ea6:	b76d                	j	80004e50 <pipewrite+0x80>
  int i = 0;
    80004ea8:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004eaa:	21848513          	addi	a0,s1,536
    80004eae:	ffffd097          	auipc	ra,0xffffd
    80004eb2:	3c0080e7          	jalr	960(ra) # 8000226e <wakeup>
  release(&pi->lock);
    80004eb6:	8526                	mv	a0,s1
    80004eb8:	ffffc097          	auipc	ra,0xffffc
    80004ebc:	dbe080e7          	jalr	-578(ra) # 80000c76 <release>
  return i;
    80004ec0:	b785                	j	80004e20 <pipewrite+0x50>

0000000080004ec2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004ec2:	715d                	addi	sp,sp,-80
    80004ec4:	e486                	sd	ra,72(sp)
    80004ec6:	e0a2                	sd	s0,64(sp)
    80004ec8:	fc26                	sd	s1,56(sp)
    80004eca:	f84a                	sd	s2,48(sp)
    80004ecc:	f44e                	sd	s3,40(sp)
    80004ece:	f052                	sd	s4,32(sp)
    80004ed0:	ec56                	sd	s5,24(sp)
    80004ed2:	e85a                	sd	s6,16(sp)
    80004ed4:	0880                	addi	s0,sp,80
    80004ed6:	84aa                	mv	s1,a0
    80004ed8:	892e                	mv	s2,a1
    80004eda:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004edc:	ffffd097          	auipc	ra,0xffffd
    80004ee0:	aa2080e7          	jalr	-1374(ra) # 8000197e <myproc>
    80004ee4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004ee6:	8526                	mv	a0,s1
    80004ee8:	ffffc097          	auipc	ra,0xffffc
    80004eec:	cda080e7          	jalr	-806(ra) # 80000bc2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ef0:	2184a703          	lw	a4,536(s1)
    80004ef4:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004ef8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004efc:	02f71463          	bne	a4,a5,80004f24 <piperead+0x62>
    80004f00:	2244a783          	lw	a5,548(s1)
    80004f04:	c385                	beqz	a5,80004f24 <piperead+0x62>
    if(pr->killed){
    80004f06:	028a2783          	lw	a5,40(s4)
    80004f0a:	ebc1                	bnez	a5,80004f9a <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004f0c:	85a6                	mv	a1,s1
    80004f0e:	854e                	mv	a0,s3
    80004f10:	ffffd097          	auipc	ra,0xffffd
    80004f14:	1d2080e7          	jalr	466(ra) # 800020e2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f18:	2184a703          	lw	a4,536(s1)
    80004f1c:	21c4a783          	lw	a5,540(s1)
    80004f20:	fef700e3          	beq	a4,a5,80004f00 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f24:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004f26:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f28:	05505363          	blez	s5,80004f6e <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004f2c:	2184a783          	lw	a5,536(s1)
    80004f30:	21c4a703          	lw	a4,540(s1)
    80004f34:	02f70d63          	beq	a4,a5,80004f6e <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004f38:	0017871b          	addiw	a4,a5,1
    80004f3c:	20e4ac23          	sw	a4,536(s1)
    80004f40:	1ff7f793          	andi	a5,a5,511
    80004f44:	97a6                	add	a5,a5,s1
    80004f46:	0187c783          	lbu	a5,24(a5)
    80004f4a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004f4e:	4685                	li	a3,1
    80004f50:	fbf40613          	addi	a2,s0,-65
    80004f54:	85ca                	mv	a1,s2
    80004f56:	050a3503          	ld	a0,80(s4)
    80004f5a:	ffffc097          	auipc	ra,0xffffc
    80004f5e:	6e4080e7          	jalr	1764(ra) # 8000163e <copyout>
    80004f62:	01650663          	beq	a0,s6,80004f6e <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f66:	2985                	addiw	s3,s3,1
    80004f68:	0905                	addi	s2,s2,1
    80004f6a:	fd3a91e3          	bne	s5,s3,80004f2c <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004f6e:	21c48513          	addi	a0,s1,540
    80004f72:	ffffd097          	auipc	ra,0xffffd
    80004f76:	2fc080e7          	jalr	764(ra) # 8000226e <wakeup>
  release(&pi->lock);
    80004f7a:	8526                	mv	a0,s1
    80004f7c:	ffffc097          	auipc	ra,0xffffc
    80004f80:	cfa080e7          	jalr	-774(ra) # 80000c76 <release>
  return i;
}
    80004f84:	854e                	mv	a0,s3
    80004f86:	60a6                	ld	ra,72(sp)
    80004f88:	6406                	ld	s0,64(sp)
    80004f8a:	74e2                	ld	s1,56(sp)
    80004f8c:	7942                	ld	s2,48(sp)
    80004f8e:	79a2                	ld	s3,40(sp)
    80004f90:	7a02                	ld	s4,32(sp)
    80004f92:	6ae2                	ld	s5,24(sp)
    80004f94:	6b42                	ld	s6,16(sp)
    80004f96:	6161                	addi	sp,sp,80
    80004f98:	8082                	ret
      release(&pi->lock);
    80004f9a:	8526                	mv	a0,s1
    80004f9c:	ffffc097          	auipc	ra,0xffffc
    80004fa0:	cda080e7          	jalr	-806(ra) # 80000c76 <release>
      return -1;
    80004fa4:	59fd                	li	s3,-1
    80004fa6:	bff9                	j	80004f84 <piperead+0xc2>

0000000080004fa8 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004fa8:	de010113          	addi	sp,sp,-544
    80004fac:	20113c23          	sd	ra,536(sp)
    80004fb0:	20813823          	sd	s0,528(sp)
    80004fb4:	20913423          	sd	s1,520(sp)
    80004fb8:	21213023          	sd	s2,512(sp)
    80004fbc:	ffce                	sd	s3,504(sp)
    80004fbe:	fbd2                	sd	s4,496(sp)
    80004fc0:	f7d6                	sd	s5,488(sp)
    80004fc2:	f3da                	sd	s6,480(sp)
    80004fc4:	efde                	sd	s7,472(sp)
    80004fc6:	ebe2                	sd	s8,464(sp)
    80004fc8:	e7e6                	sd	s9,456(sp)
    80004fca:	e3ea                	sd	s10,448(sp)
    80004fcc:	ff6e                	sd	s11,440(sp)
    80004fce:	1400                	addi	s0,sp,544
    80004fd0:	892a                	mv	s2,a0
    80004fd2:	dea43423          	sd	a0,-536(s0)
    80004fd6:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004fda:	ffffd097          	auipc	ra,0xffffd
    80004fde:	9a4080e7          	jalr	-1628(ra) # 8000197e <myproc>
    80004fe2:	84aa                	mv	s1,a0

  begin_op();
    80004fe4:	fffff097          	auipc	ra,0xfffff
    80004fe8:	4a6080e7          	jalr	1190(ra) # 8000448a <begin_op>

  if((ip = namei(path)) == 0){
    80004fec:	854a                	mv	a0,s2
    80004fee:	fffff097          	auipc	ra,0xfffff
    80004ff2:	27c080e7          	jalr	636(ra) # 8000426a <namei>
    80004ff6:	c93d                	beqz	a0,8000506c <exec+0xc4>
    80004ff8:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004ffa:	fffff097          	auipc	ra,0xfffff
    80004ffe:	aba080e7          	jalr	-1350(ra) # 80003ab4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005002:	04000713          	li	a4,64
    80005006:	4681                	li	a3,0
    80005008:	e4840613          	addi	a2,s0,-440
    8000500c:	4581                	li	a1,0
    8000500e:	8556                	mv	a0,s5
    80005010:	fffff097          	auipc	ra,0xfffff
    80005014:	d58080e7          	jalr	-680(ra) # 80003d68 <readi>
    80005018:	04000793          	li	a5,64
    8000501c:	00f51a63          	bne	a0,a5,80005030 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80005020:	e4842703          	lw	a4,-440(s0)
    80005024:	464c47b7          	lui	a5,0x464c4
    80005028:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000502c:	04f70663          	beq	a4,a5,80005078 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005030:	8556                	mv	a0,s5
    80005032:	fffff097          	auipc	ra,0xfffff
    80005036:	ce4080e7          	jalr	-796(ra) # 80003d16 <iunlockput>
    end_op();
    8000503a:	fffff097          	auipc	ra,0xfffff
    8000503e:	4d0080e7          	jalr	1232(ra) # 8000450a <end_op>
  }
  return -1;
    80005042:	557d                	li	a0,-1
}
    80005044:	21813083          	ld	ra,536(sp)
    80005048:	21013403          	ld	s0,528(sp)
    8000504c:	20813483          	ld	s1,520(sp)
    80005050:	20013903          	ld	s2,512(sp)
    80005054:	79fe                	ld	s3,504(sp)
    80005056:	7a5e                	ld	s4,496(sp)
    80005058:	7abe                	ld	s5,488(sp)
    8000505a:	7b1e                	ld	s6,480(sp)
    8000505c:	6bfe                	ld	s7,472(sp)
    8000505e:	6c5e                	ld	s8,464(sp)
    80005060:	6cbe                	ld	s9,456(sp)
    80005062:	6d1e                	ld	s10,448(sp)
    80005064:	7dfa                	ld	s11,440(sp)
    80005066:	22010113          	addi	sp,sp,544
    8000506a:	8082                	ret
    end_op();
    8000506c:	fffff097          	auipc	ra,0xfffff
    80005070:	49e080e7          	jalr	1182(ra) # 8000450a <end_op>
    return -1;
    80005074:	557d                	li	a0,-1
    80005076:	b7f9                	j	80005044 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80005078:	8526                	mv	a0,s1
    8000507a:	ffffd097          	auipc	ra,0xffffd
    8000507e:	9c8080e7          	jalr	-1592(ra) # 80001a42 <proc_pagetable>
    80005082:	8b2a                	mv	s6,a0
    80005084:	d555                	beqz	a0,80005030 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005086:	e6842783          	lw	a5,-408(s0)
    8000508a:	e8045703          	lhu	a4,-384(s0)
    8000508e:	c735                	beqz	a4,800050fa <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80005090:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005092:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80005096:	6a05                	lui	s4,0x1
    80005098:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000509c:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    800050a0:	6d85                	lui	s11,0x1
    800050a2:	7d7d                	lui	s10,0xfffff
    800050a4:	acb9                	j	80005302 <exec+0x35a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800050a6:	00003517          	auipc	a0,0x3
    800050aa:	66a50513          	addi	a0,a0,1642 # 80008710 <syscalls+0x298>
    800050ae:	ffffb097          	auipc	ra,0xffffb
    800050b2:	47c080e7          	jalr	1148(ra) # 8000052a <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800050b6:	874a                	mv	a4,s2
    800050b8:	009c86bb          	addw	a3,s9,s1
    800050bc:	4581                	li	a1,0
    800050be:	8556                	mv	a0,s5
    800050c0:	fffff097          	auipc	ra,0xfffff
    800050c4:	ca8080e7          	jalr	-856(ra) # 80003d68 <readi>
    800050c8:	2501                	sext.w	a0,a0
    800050ca:	1ca91c63          	bne	s2,a0,800052a2 <exec+0x2fa>
  for(i = 0; i < sz; i += PGSIZE){
    800050ce:	009d84bb          	addw	s1,s11,s1
    800050d2:	013d09bb          	addw	s3,s10,s3
    800050d6:	2174f663          	bgeu	s1,s7,800052e2 <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    800050da:	02049593          	slli	a1,s1,0x20
    800050de:	9181                	srli	a1,a1,0x20
    800050e0:	95e2                	add	a1,a1,s8
    800050e2:	855a                	mv	a0,s6
    800050e4:	ffffc097          	auipc	ra,0xffffc
    800050e8:	f68080e7          	jalr	-152(ra) # 8000104c <walkaddr>
    800050ec:	862a                	mv	a2,a0
    if(pa == 0)
    800050ee:	dd45                	beqz	a0,800050a6 <exec+0xfe>
      n = PGSIZE;
    800050f0:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800050f2:	fd49f2e3          	bgeu	s3,s4,800050b6 <exec+0x10e>
      n = sz - i;
    800050f6:	894e                	mv	s2,s3
    800050f8:	bf7d                	j	800050b6 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    800050fa:	4481                	li	s1,0
  iunlockput(ip);
    800050fc:	8556                	mv	a0,s5
    800050fe:	fffff097          	auipc	ra,0xfffff
    80005102:	c18080e7          	jalr	-1000(ra) # 80003d16 <iunlockput>
  end_op();
    80005106:	fffff097          	auipc	ra,0xfffff
    8000510a:	404080e7          	jalr	1028(ra) # 8000450a <end_op>
  p = myproc();
    8000510e:	ffffd097          	auipc	ra,0xffffd
    80005112:	870080e7          	jalr	-1936(ra) # 8000197e <myproc>
    80005116:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80005118:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000511c:	6785                	lui	a5,0x1
    8000511e:	17fd                	addi	a5,a5,-1
    80005120:	94be                	add	s1,s1,a5
    80005122:	77fd                	lui	a5,0xfffff
    80005124:	8fe5                	and	a5,a5,s1
    80005126:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000512a:	6609                	lui	a2,0x2
    8000512c:	963e                	add	a2,a2,a5
    8000512e:	85be                	mv	a1,a5
    80005130:	855a                	mv	a0,s6
    80005132:	ffffc097          	auipc	ra,0xffffc
    80005136:	2bc080e7          	jalr	700(ra) # 800013ee <uvmalloc>
    8000513a:	8c2a                	mv	s8,a0
  ip = 0;
    8000513c:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000513e:	16050263          	beqz	a0,800052a2 <exec+0x2fa>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005142:	75f9                	lui	a1,0xffffe
    80005144:	95aa                	add	a1,a1,a0
    80005146:	855a                	mv	a0,s6
    80005148:	ffffc097          	auipc	ra,0xffffc
    8000514c:	4c4080e7          	jalr	1220(ra) # 8000160c <uvmclear>
  stackbase = sp - PGSIZE;
    80005150:	7afd                	lui	s5,0xfffff
    80005152:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80005154:	df043783          	ld	a5,-528(s0)
    80005158:	6388                	ld	a0,0(a5)
    8000515a:	c925                	beqz	a0,800051ca <exec+0x222>
    8000515c:	e8840993          	addi	s3,s0,-376
    80005160:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80005164:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005166:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	cda080e7          	jalr	-806(ra) # 80000e42 <strlen>
    80005170:	0015079b          	addiw	a5,a0,1
    80005174:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005178:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000517c:	15596763          	bltu	s2,s5,800052ca <exec+0x322>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005180:	df043d83          	ld	s11,-528(s0)
    80005184:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005188:	8552                	mv	a0,s4
    8000518a:	ffffc097          	auipc	ra,0xffffc
    8000518e:	cb8080e7          	jalr	-840(ra) # 80000e42 <strlen>
    80005192:	0015069b          	addiw	a3,a0,1
    80005196:	8652                	mv	a2,s4
    80005198:	85ca                	mv	a1,s2
    8000519a:	855a                	mv	a0,s6
    8000519c:	ffffc097          	auipc	ra,0xffffc
    800051a0:	4a2080e7          	jalr	1186(ra) # 8000163e <copyout>
    800051a4:	12054763          	bltz	a0,800052d2 <exec+0x32a>
    ustack[argc] = sp;
    800051a8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800051ac:	0485                	addi	s1,s1,1
    800051ae:	008d8793          	addi	a5,s11,8
    800051b2:	def43823          	sd	a5,-528(s0)
    800051b6:	008db503          	ld	a0,8(s11)
    800051ba:	c911                	beqz	a0,800051ce <exec+0x226>
    if(argc >= MAXARG)
    800051bc:	09a1                	addi	s3,s3,8
    800051be:	fb9995e3          	bne	s3,s9,80005168 <exec+0x1c0>
  sz = sz1;
    800051c2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800051c6:	4a81                	li	s5,0
    800051c8:	a8e9                	j	800052a2 <exec+0x2fa>
  sp = sz;
    800051ca:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800051cc:	4481                	li	s1,0
  ustack[argc] = 0;
    800051ce:	00349793          	slli	a5,s1,0x3
    800051d2:	f9040713          	addi	a4,s0,-112
    800051d6:	97ba                	add	a5,a5,a4
    800051d8:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffcdef8>
  sp -= (argc+1) * sizeof(uint64);
    800051dc:	00148693          	addi	a3,s1,1
    800051e0:	068e                	slli	a3,a3,0x3
    800051e2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800051e6:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800051ea:	01597663          	bgeu	s2,s5,800051f6 <exec+0x24e>
  sz = sz1;
    800051ee:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800051f2:	4a81                	li	s5,0
    800051f4:	a07d                	j	800052a2 <exec+0x2fa>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800051f6:	e8840613          	addi	a2,s0,-376
    800051fa:	85ca                	mv	a1,s2
    800051fc:	855a                	mv	a0,s6
    800051fe:	ffffc097          	auipc	ra,0xffffc
    80005202:	440080e7          	jalr	1088(ra) # 8000163e <copyout>
    80005206:	0c054a63          	bltz	a0,800052da <exec+0x332>
  p->trapframe->a1 = sp;
    8000520a:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    8000520e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005212:	de843783          	ld	a5,-536(s0)
    80005216:	0007c703          	lbu	a4,0(a5)
    8000521a:	cf11                	beqz	a4,80005236 <exec+0x28e>
    8000521c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000521e:	02f00693          	li	a3,47
    80005222:	a039                	j	80005230 <exec+0x288>
      last = s+1;
    80005224:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005228:	0785                	addi	a5,a5,1
    8000522a:	fff7c703          	lbu	a4,-1(a5)
    8000522e:	c701                	beqz	a4,80005236 <exec+0x28e>
    if(*s == '/')
    80005230:	fed71ce3          	bne	a4,a3,80005228 <exec+0x280>
    80005234:	bfc5                	j	80005224 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80005236:	4641                	li	a2,16
    80005238:	de843583          	ld	a1,-536(s0)
    8000523c:	158b8513          	addi	a0,s7,344
    80005240:	ffffc097          	auipc	ra,0xffffc
    80005244:	bd0080e7          	jalr	-1072(ra) # 80000e10 <safestrcpy>
  oldpagetable = p->pagetable;
    80005248:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000524c:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80005250:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005254:	058bb783          	ld	a5,88(s7)
    80005258:	e6043703          	ld	a4,-416(s0)
    8000525c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000525e:	058bb783          	ld	a5,88(s7)
    80005262:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005266:	85ea                	mv	a1,s10
    80005268:	ffffd097          	auipc	ra,0xffffd
    8000526c:	876080e7          	jalr	-1930(ra) # 80001ade <proc_freepagetable>
  for (int i =0; i<32; i++){
    80005270:	170b8713          	addi	a4,s7,368
    80005274:	39cb8793          	addi	a5,s7,924
    80005278:	41cb8593          	addi	a1,s7,1052
    if(signalHanlder != (void*)SIG_IGN && signalHanlder != (void*)SIG_DFL){
    8000527c:	4605                	li	a2,1
    8000527e:	a029                	j	80005288 <exec+0x2e0>
  for (int i =0; i<32; i++){
    80005280:	0721                	addi	a4,a4,8
    80005282:	0791                	addi	a5,a5,4
    80005284:	00f58863          	beq	a1,a5,80005294 <exec+0x2ec>
    if(signalHanlder != (void*)SIG_IGN && signalHanlder != (void*)SIG_DFL){
    80005288:	6314                	ld	a3,0(a4)
    8000528a:	fed67be3          	bgeu	a2,a3,80005280 <exec+0x2d8>
      p->maskHandlers[i]= 0;
    8000528e:	0007a023          	sw	zero,0(a5)
    80005292:	b7fd                	j	80005280 <exec+0x2d8>
  p->signalMask = 0;
    80005294:	160ba623          	sw	zero,364(s7)
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005298:	0004851b          	sext.w	a0,s1
    8000529c:	b365                	j	80005044 <exec+0x9c>
    8000529e:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800052a2:	df843583          	ld	a1,-520(s0)
    800052a6:	855a                	mv	a0,s6
    800052a8:	ffffd097          	auipc	ra,0xffffd
    800052ac:	836080e7          	jalr	-1994(ra) # 80001ade <proc_freepagetable>
  if(ip){
    800052b0:	d80a90e3          	bnez	s5,80005030 <exec+0x88>
  return -1;
    800052b4:	557d                	li	a0,-1
    800052b6:	b379                	j	80005044 <exec+0x9c>
    800052b8:	de943c23          	sd	s1,-520(s0)
    800052bc:	b7dd                	j	800052a2 <exec+0x2fa>
    800052be:	de943c23          	sd	s1,-520(s0)
    800052c2:	b7c5                	j	800052a2 <exec+0x2fa>
    800052c4:	de943c23          	sd	s1,-520(s0)
    800052c8:	bfe9                	j	800052a2 <exec+0x2fa>
  sz = sz1;
    800052ca:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800052ce:	4a81                	li	s5,0
    800052d0:	bfc9                	j	800052a2 <exec+0x2fa>
  sz = sz1;
    800052d2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800052d6:	4a81                	li	s5,0
    800052d8:	b7e9                	j	800052a2 <exec+0x2fa>
  sz = sz1;
    800052da:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800052de:	4a81                	li	s5,0
    800052e0:	b7c9                	j	800052a2 <exec+0x2fa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800052e2:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800052e6:	e0843783          	ld	a5,-504(s0)
    800052ea:	0017869b          	addiw	a3,a5,1
    800052ee:	e0d43423          	sd	a3,-504(s0)
    800052f2:	e0043783          	ld	a5,-512(s0)
    800052f6:	0387879b          	addiw	a5,a5,56
    800052fa:	e8045703          	lhu	a4,-384(s0)
    800052fe:	dee6dfe3          	bge	a3,a4,800050fc <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005302:	2781                	sext.w	a5,a5
    80005304:	e0f43023          	sd	a5,-512(s0)
    80005308:	03800713          	li	a4,56
    8000530c:	86be                	mv	a3,a5
    8000530e:	e1040613          	addi	a2,s0,-496
    80005312:	4581                	li	a1,0
    80005314:	8556                	mv	a0,s5
    80005316:	fffff097          	auipc	ra,0xfffff
    8000531a:	a52080e7          	jalr	-1454(ra) # 80003d68 <readi>
    8000531e:	03800793          	li	a5,56
    80005322:	f6f51ee3          	bne	a0,a5,8000529e <exec+0x2f6>
    if(ph.type != ELF_PROG_LOAD)
    80005326:	e1042783          	lw	a5,-496(s0)
    8000532a:	4705                	li	a4,1
    8000532c:	fae79de3          	bne	a5,a4,800052e6 <exec+0x33e>
    if(ph.memsz < ph.filesz)
    80005330:	e3843603          	ld	a2,-456(s0)
    80005334:	e3043783          	ld	a5,-464(s0)
    80005338:	f8f660e3          	bltu	a2,a5,800052b8 <exec+0x310>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000533c:	e2043783          	ld	a5,-480(s0)
    80005340:	963e                	add	a2,a2,a5
    80005342:	f6f66ee3          	bltu	a2,a5,800052be <exec+0x316>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005346:	85a6                	mv	a1,s1
    80005348:	855a                	mv	a0,s6
    8000534a:	ffffc097          	auipc	ra,0xffffc
    8000534e:	0a4080e7          	jalr	164(ra) # 800013ee <uvmalloc>
    80005352:	dea43c23          	sd	a0,-520(s0)
    80005356:	d53d                	beqz	a0,800052c4 <exec+0x31c>
    if(ph.vaddr % PGSIZE != 0)
    80005358:	e2043c03          	ld	s8,-480(s0)
    8000535c:	de043783          	ld	a5,-544(s0)
    80005360:	00fc77b3          	and	a5,s8,a5
    80005364:	ff9d                	bnez	a5,800052a2 <exec+0x2fa>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005366:	e1842c83          	lw	s9,-488(s0)
    8000536a:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000536e:	f60b8ae3          	beqz	s7,800052e2 <exec+0x33a>
    80005372:	89de                	mv	s3,s7
    80005374:	4481                	li	s1,0
    80005376:	b395                	j	800050da <exec+0x132>

0000000080005378 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005378:	7179                	addi	sp,sp,-48
    8000537a:	f406                	sd	ra,40(sp)
    8000537c:	f022                	sd	s0,32(sp)
    8000537e:	ec26                	sd	s1,24(sp)
    80005380:	e84a                	sd	s2,16(sp)
    80005382:	1800                	addi	s0,sp,48
    80005384:	892e                	mv	s2,a1
    80005386:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005388:	fdc40593          	addi	a1,s0,-36
    8000538c:	ffffe097          	auipc	ra,0xffffe
    80005390:	ae8080e7          	jalr	-1304(ra) # 80002e74 <argint>
    80005394:	04054063          	bltz	a0,800053d4 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005398:	fdc42703          	lw	a4,-36(s0)
    8000539c:	47bd                	li	a5,15
    8000539e:	02e7ed63          	bltu	a5,a4,800053d8 <argfd+0x60>
    800053a2:	ffffc097          	auipc	ra,0xffffc
    800053a6:	5dc080e7          	jalr	1500(ra) # 8000197e <myproc>
    800053aa:	fdc42703          	lw	a4,-36(s0)
    800053ae:	01a70793          	addi	a5,a4,26
    800053b2:	078e                	slli	a5,a5,0x3
    800053b4:	953e                	add	a0,a0,a5
    800053b6:	611c                	ld	a5,0(a0)
    800053b8:	c395                	beqz	a5,800053dc <argfd+0x64>
    return -1;
  if(pfd)
    800053ba:	00090463          	beqz	s2,800053c2 <argfd+0x4a>
    *pfd = fd;
    800053be:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800053c2:	4501                	li	a0,0
  if(pf)
    800053c4:	c091                	beqz	s1,800053c8 <argfd+0x50>
    *pf = f;
    800053c6:	e09c                	sd	a5,0(s1)
}
    800053c8:	70a2                	ld	ra,40(sp)
    800053ca:	7402                	ld	s0,32(sp)
    800053cc:	64e2                	ld	s1,24(sp)
    800053ce:	6942                	ld	s2,16(sp)
    800053d0:	6145                	addi	sp,sp,48
    800053d2:	8082                	ret
    return -1;
    800053d4:	557d                	li	a0,-1
    800053d6:	bfcd                	j	800053c8 <argfd+0x50>
    return -1;
    800053d8:	557d                	li	a0,-1
    800053da:	b7fd                	j	800053c8 <argfd+0x50>
    800053dc:	557d                	li	a0,-1
    800053de:	b7ed                	j	800053c8 <argfd+0x50>

00000000800053e0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800053e0:	1101                	addi	sp,sp,-32
    800053e2:	ec06                	sd	ra,24(sp)
    800053e4:	e822                	sd	s0,16(sp)
    800053e6:	e426                	sd	s1,8(sp)
    800053e8:	1000                	addi	s0,sp,32
    800053ea:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800053ec:	ffffc097          	auipc	ra,0xffffc
    800053f0:	592080e7          	jalr	1426(ra) # 8000197e <myproc>
    800053f4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800053f6:	0d050793          	addi	a5,a0,208
    800053fa:	4501                	li	a0,0
    800053fc:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800053fe:	6398                	ld	a4,0(a5)
    80005400:	cb19                	beqz	a4,80005416 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005402:	2505                	addiw	a0,a0,1
    80005404:	07a1                	addi	a5,a5,8
    80005406:	fed51ce3          	bne	a0,a3,800053fe <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000540a:	557d                	li	a0,-1
}
    8000540c:	60e2                	ld	ra,24(sp)
    8000540e:	6442                	ld	s0,16(sp)
    80005410:	64a2                	ld	s1,8(sp)
    80005412:	6105                	addi	sp,sp,32
    80005414:	8082                	ret
      p->ofile[fd] = f;
    80005416:	01a50793          	addi	a5,a0,26
    8000541a:	078e                	slli	a5,a5,0x3
    8000541c:	963e                	add	a2,a2,a5
    8000541e:	e204                	sd	s1,0(a2)
      return fd;
    80005420:	b7f5                	j	8000540c <fdalloc+0x2c>

0000000080005422 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005422:	715d                	addi	sp,sp,-80
    80005424:	e486                	sd	ra,72(sp)
    80005426:	e0a2                	sd	s0,64(sp)
    80005428:	fc26                	sd	s1,56(sp)
    8000542a:	f84a                	sd	s2,48(sp)
    8000542c:	f44e                	sd	s3,40(sp)
    8000542e:	f052                	sd	s4,32(sp)
    80005430:	ec56                	sd	s5,24(sp)
    80005432:	0880                	addi	s0,sp,80
    80005434:	89ae                	mv	s3,a1
    80005436:	8ab2                	mv	s5,a2
    80005438:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000543a:	fb040593          	addi	a1,s0,-80
    8000543e:	fffff097          	auipc	ra,0xfffff
    80005442:	e4a080e7          	jalr	-438(ra) # 80004288 <nameiparent>
    80005446:	892a                	mv	s2,a0
    80005448:	12050e63          	beqz	a0,80005584 <create+0x162>
    return 0;

  ilock(dp);
    8000544c:	ffffe097          	auipc	ra,0xffffe
    80005450:	668080e7          	jalr	1640(ra) # 80003ab4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005454:	4601                	li	a2,0
    80005456:	fb040593          	addi	a1,s0,-80
    8000545a:	854a                	mv	a0,s2
    8000545c:	fffff097          	auipc	ra,0xfffff
    80005460:	b3c080e7          	jalr	-1220(ra) # 80003f98 <dirlookup>
    80005464:	84aa                	mv	s1,a0
    80005466:	c921                	beqz	a0,800054b6 <create+0x94>
    iunlockput(dp);
    80005468:	854a                	mv	a0,s2
    8000546a:	fffff097          	auipc	ra,0xfffff
    8000546e:	8ac080e7          	jalr	-1876(ra) # 80003d16 <iunlockput>
    ilock(ip);
    80005472:	8526                	mv	a0,s1
    80005474:	ffffe097          	auipc	ra,0xffffe
    80005478:	640080e7          	jalr	1600(ra) # 80003ab4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000547c:	2981                	sext.w	s3,s3
    8000547e:	4789                	li	a5,2
    80005480:	02f99463          	bne	s3,a5,800054a8 <create+0x86>
    80005484:	0444d783          	lhu	a5,68(s1)
    80005488:	37f9                	addiw	a5,a5,-2
    8000548a:	17c2                	slli	a5,a5,0x30
    8000548c:	93c1                	srli	a5,a5,0x30
    8000548e:	4705                	li	a4,1
    80005490:	00f76c63          	bltu	a4,a5,800054a8 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005494:	8526                	mv	a0,s1
    80005496:	60a6                	ld	ra,72(sp)
    80005498:	6406                	ld	s0,64(sp)
    8000549a:	74e2                	ld	s1,56(sp)
    8000549c:	7942                	ld	s2,48(sp)
    8000549e:	79a2                	ld	s3,40(sp)
    800054a0:	7a02                	ld	s4,32(sp)
    800054a2:	6ae2                	ld	s5,24(sp)
    800054a4:	6161                	addi	sp,sp,80
    800054a6:	8082                	ret
    iunlockput(ip);
    800054a8:	8526                	mv	a0,s1
    800054aa:	fffff097          	auipc	ra,0xfffff
    800054ae:	86c080e7          	jalr	-1940(ra) # 80003d16 <iunlockput>
    return 0;
    800054b2:	4481                	li	s1,0
    800054b4:	b7c5                	j	80005494 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800054b6:	85ce                	mv	a1,s3
    800054b8:	00092503          	lw	a0,0(s2)
    800054bc:	ffffe097          	auipc	ra,0xffffe
    800054c0:	460080e7          	jalr	1120(ra) # 8000391c <ialloc>
    800054c4:	84aa                	mv	s1,a0
    800054c6:	c521                	beqz	a0,8000550e <create+0xec>
  ilock(ip);
    800054c8:	ffffe097          	auipc	ra,0xffffe
    800054cc:	5ec080e7          	jalr	1516(ra) # 80003ab4 <ilock>
  ip->major = major;
    800054d0:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800054d4:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800054d8:	4a05                	li	s4,1
    800054da:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800054de:	8526                	mv	a0,s1
    800054e0:	ffffe097          	auipc	ra,0xffffe
    800054e4:	50a080e7          	jalr	1290(ra) # 800039ea <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800054e8:	2981                	sext.w	s3,s3
    800054ea:	03498a63          	beq	s3,s4,8000551e <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800054ee:	40d0                	lw	a2,4(s1)
    800054f0:	fb040593          	addi	a1,s0,-80
    800054f4:	854a                	mv	a0,s2
    800054f6:	fffff097          	auipc	ra,0xfffff
    800054fa:	cb2080e7          	jalr	-846(ra) # 800041a8 <dirlink>
    800054fe:	06054b63          	bltz	a0,80005574 <create+0x152>
  iunlockput(dp);
    80005502:	854a                	mv	a0,s2
    80005504:	fffff097          	auipc	ra,0xfffff
    80005508:	812080e7          	jalr	-2030(ra) # 80003d16 <iunlockput>
  return ip;
    8000550c:	b761                	j	80005494 <create+0x72>
    panic("create: ialloc");
    8000550e:	00003517          	auipc	a0,0x3
    80005512:	22250513          	addi	a0,a0,546 # 80008730 <syscalls+0x2b8>
    80005516:	ffffb097          	auipc	ra,0xffffb
    8000551a:	014080e7          	jalr	20(ra) # 8000052a <panic>
    dp->nlink++;  // for ".."
    8000551e:	04a95783          	lhu	a5,74(s2)
    80005522:	2785                	addiw	a5,a5,1
    80005524:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005528:	854a                	mv	a0,s2
    8000552a:	ffffe097          	auipc	ra,0xffffe
    8000552e:	4c0080e7          	jalr	1216(ra) # 800039ea <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005532:	40d0                	lw	a2,4(s1)
    80005534:	00003597          	auipc	a1,0x3
    80005538:	20c58593          	addi	a1,a1,524 # 80008740 <syscalls+0x2c8>
    8000553c:	8526                	mv	a0,s1
    8000553e:	fffff097          	auipc	ra,0xfffff
    80005542:	c6a080e7          	jalr	-918(ra) # 800041a8 <dirlink>
    80005546:	00054f63          	bltz	a0,80005564 <create+0x142>
    8000554a:	00492603          	lw	a2,4(s2)
    8000554e:	00003597          	auipc	a1,0x3
    80005552:	1fa58593          	addi	a1,a1,506 # 80008748 <syscalls+0x2d0>
    80005556:	8526                	mv	a0,s1
    80005558:	fffff097          	auipc	ra,0xfffff
    8000555c:	c50080e7          	jalr	-944(ra) # 800041a8 <dirlink>
    80005560:	f80557e3          	bgez	a0,800054ee <create+0xcc>
      panic("create dots");
    80005564:	00003517          	auipc	a0,0x3
    80005568:	1ec50513          	addi	a0,a0,492 # 80008750 <syscalls+0x2d8>
    8000556c:	ffffb097          	auipc	ra,0xffffb
    80005570:	fbe080e7          	jalr	-66(ra) # 8000052a <panic>
    panic("create: dirlink");
    80005574:	00003517          	auipc	a0,0x3
    80005578:	1ec50513          	addi	a0,a0,492 # 80008760 <syscalls+0x2e8>
    8000557c:	ffffb097          	auipc	ra,0xffffb
    80005580:	fae080e7          	jalr	-82(ra) # 8000052a <panic>
    return 0;
    80005584:	84aa                	mv	s1,a0
    80005586:	b739                	j	80005494 <create+0x72>

0000000080005588 <sys_dup>:
{
    80005588:	7179                	addi	sp,sp,-48
    8000558a:	f406                	sd	ra,40(sp)
    8000558c:	f022                	sd	s0,32(sp)
    8000558e:	ec26                	sd	s1,24(sp)
    80005590:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005592:	fd840613          	addi	a2,s0,-40
    80005596:	4581                	li	a1,0
    80005598:	4501                	li	a0,0
    8000559a:	00000097          	auipc	ra,0x0
    8000559e:	dde080e7          	jalr	-546(ra) # 80005378 <argfd>
    return -1;
    800055a2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800055a4:	02054363          	bltz	a0,800055ca <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800055a8:	fd843503          	ld	a0,-40(s0)
    800055ac:	00000097          	auipc	ra,0x0
    800055b0:	e34080e7          	jalr	-460(ra) # 800053e0 <fdalloc>
    800055b4:	84aa                	mv	s1,a0
    return -1;
    800055b6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800055b8:	00054963          	bltz	a0,800055ca <sys_dup+0x42>
  filedup(f);
    800055bc:	fd843503          	ld	a0,-40(s0)
    800055c0:	fffff097          	auipc	ra,0xfffff
    800055c4:	344080e7          	jalr	836(ra) # 80004904 <filedup>
  return fd;
    800055c8:	87a6                	mv	a5,s1
}
    800055ca:	853e                	mv	a0,a5
    800055cc:	70a2                	ld	ra,40(sp)
    800055ce:	7402                	ld	s0,32(sp)
    800055d0:	64e2                	ld	s1,24(sp)
    800055d2:	6145                	addi	sp,sp,48
    800055d4:	8082                	ret

00000000800055d6 <sys_read>:
{
    800055d6:	7179                	addi	sp,sp,-48
    800055d8:	f406                	sd	ra,40(sp)
    800055da:	f022                	sd	s0,32(sp)
    800055dc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055de:	fe840613          	addi	a2,s0,-24
    800055e2:	4581                	li	a1,0
    800055e4:	4501                	li	a0,0
    800055e6:	00000097          	auipc	ra,0x0
    800055ea:	d92080e7          	jalr	-622(ra) # 80005378 <argfd>
    return -1;
    800055ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055f0:	04054163          	bltz	a0,80005632 <sys_read+0x5c>
    800055f4:	fe440593          	addi	a1,s0,-28
    800055f8:	4509                	li	a0,2
    800055fa:	ffffe097          	auipc	ra,0xffffe
    800055fe:	87a080e7          	jalr	-1926(ra) # 80002e74 <argint>
    return -1;
    80005602:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005604:	02054763          	bltz	a0,80005632 <sys_read+0x5c>
    80005608:	fd840593          	addi	a1,s0,-40
    8000560c:	4505                	li	a0,1
    8000560e:	ffffe097          	auipc	ra,0xffffe
    80005612:	888080e7          	jalr	-1912(ra) # 80002e96 <argaddr>
    return -1;
    80005616:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005618:	00054d63          	bltz	a0,80005632 <sys_read+0x5c>
  return fileread(f, p, n);
    8000561c:	fe442603          	lw	a2,-28(s0)
    80005620:	fd843583          	ld	a1,-40(s0)
    80005624:	fe843503          	ld	a0,-24(s0)
    80005628:	fffff097          	auipc	ra,0xfffff
    8000562c:	468080e7          	jalr	1128(ra) # 80004a90 <fileread>
    80005630:	87aa                	mv	a5,a0
}
    80005632:	853e                	mv	a0,a5
    80005634:	70a2                	ld	ra,40(sp)
    80005636:	7402                	ld	s0,32(sp)
    80005638:	6145                	addi	sp,sp,48
    8000563a:	8082                	ret

000000008000563c <sys_write>:
{
    8000563c:	7179                	addi	sp,sp,-48
    8000563e:	f406                	sd	ra,40(sp)
    80005640:	f022                	sd	s0,32(sp)
    80005642:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005644:	fe840613          	addi	a2,s0,-24
    80005648:	4581                	li	a1,0
    8000564a:	4501                	li	a0,0
    8000564c:	00000097          	auipc	ra,0x0
    80005650:	d2c080e7          	jalr	-724(ra) # 80005378 <argfd>
    return -1;
    80005654:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005656:	04054163          	bltz	a0,80005698 <sys_write+0x5c>
    8000565a:	fe440593          	addi	a1,s0,-28
    8000565e:	4509                	li	a0,2
    80005660:	ffffe097          	auipc	ra,0xffffe
    80005664:	814080e7          	jalr	-2028(ra) # 80002e74 <argint>
    return -1;
    80005668:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000566a:	02054763          	bltz	a0,80005698 <sys_write+0x5c>
    8000566e:	fd840593          	addi	a1,s0,-40
    80005672:	4505                	li	a0,1
    80005674:	ffffe097          	auipc	ra,0xffffe
    80005678:	822080e7          	jalr	-2014(ra) # 80002e96 <argaddr>
    return -1;
    8000567c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000567e:	00054d63          	bltz	a0,80005698 <sys_write+0x5c>
  return filewrite(f, p, n);
    80005682:	fe442603          	lw	a2,-28(s0)
    80005686:	fd843583          	ld	a1,-40(s0)
    8000568a:	fe843503          	ld	a0,-24(s0)
    8000568e:	fffff097          	auipc	ra,0xfffff
    80005692:	4c4080e7          	jalr	1220(ra) # 80004b52 <filewrite>
    80005696:	87aa                	mv	a5,a0
}
    80005698:	853e                	mv	a0,a5
    8000569a:	70a2                	ld	ra,40(sp)
    8000569c:	7402                	ld	s0,32(sp)
    8000569e:	6145                	addi	sp,sp,48
    800056a0:	8082                	ret

00000000800056a2 <sys_close>:
{
    800056a2:	1101                	addi	sp,sp,-32
    800056a4:	ec06                	sd	ra,24(sp)
    800056a6:	e822                	sd	s0,16(sp)
    800056a8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800056aa:	fe040613          	addi	a2,s0,-32
    800056ae:	fec40593          	addi	a1,s0,-20
    800056b2:	4501                	li	a0,0
    800056b4:	00000097          	auipc	ra,0x0
    800056b8:	cc4080e7          	jalr	-828(ra) # 80005378 <argfd>
    return -1;
    800056bc:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800056be:	02054463          	bltz	a0,800056e6 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800056c2:	ffffc097          	auipc	ra,0xffffc
    800056c6:	2bc080e7          	jalr	700(ra) # 8000197e <myproc>
    800056ca:	fec42783          	lw	a5,-20(s0)
    800056ce:	07e9                	addi	a5,a5,26
    800056d0:	078e                	slli	a5,a5,0x3
    800056d2:	97aa                	add	a5,a5,a0
    800056d4:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800056d8:	fe043503          	ld	a0,-32(s0)
    800056dc:	fffff097          	auipc	ra,0xfffff
    800056e0:	27a080e7          	jalr	634(ra) # 80004956 <fileclose>
  return 0;
    800056e4:	4781                	li	a5,0
}
    800056e6:	853e                	mv	a0,a5
    800056e8:	60e2                	ld	ra,24(sp)
    800056ea:	6442                	ld	s0,16(sp)
    800056ec:	6105                	addi	sp,sp,32
    800056ee:	8082                	ret

00000000800056f0 <sys_fstat>:
{
    800056f0:	1101                	addi	sp,sp,-32
    800056f2:	ec06                	sd	ra,24(sp)
    800056f4:	e822                	sd	s0,16(sp)
    800056f6:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800056f8:	fe840613          	addi	a2,s0,-24
    800056fc:	4581                	li	a1,0
    800056fe:	4501                	li	a0,0
    80005700:	00000097          	auipc	ra,0x0
    80005704:	c78080e7          	jalr	-904(ra) # 80005378 <argfd>
    return -1;
    80005708:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000570a:	02054563          	bltz	a0,80005734 <sys_fstat+0x44>
    8000570e:	fe040593          	addi	a1,s0,-32
    80005712:	4505                	li	a0,1
    80005714:	ffffd097          	auipc	ra,0xffffd
    80005718:	782080e7          	jalr	1922(ra) # 80002e96 <argaddr>
    return -1;
    8000571c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000571e:	00054b63          	bltz	a0,80005734 <sys_fstat+0x44>
  return filestat(f, st);
    80005722:	fe043583          	ld	a1,-32(s0)
    80005726:	fe843503          	ld	a0,-24(s0)
    8000572a:	fffff097          	auipc	ra,0xfffff
    8000572e:	2f4080e7          	jalr	756(ra) # 80004a1e <filestat>
    80005732:	87aa                	mv	a5,a0
}
    80005734:	853e                	mv	a0,a5
    80005736:	60e2                	ld	ra,24(sp)
    80005738:	6442                	ld	s0,16(sp)
    8000573a:	6105                	addi	sp,sp,32
    8000573c:	8082                	ret

000000008000573e <sys_link>:
{
    8000573e:	7169                	addi	sp,sp,-304
    80005740:	f606                	sd	ra,296(sp)
    80005742:	f222                	sd	s0,288(sp)
    80005744:	ee26                	sd	s1,280(sp)
    80005746:	ea4a                	sd	s2,272(sp)
    80005748:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000574a:	08000613          	li	a2,128
    8000574e:	ed040593          	addi	a1,s0,-304
    80005752:	4501                	li	a0,0
    80005754:	ffffd097          	auipc	ra,0xffffd
    80005758:	764080e7          	jalr	1892(ra) # 80002eb8 <argstr>
    return -1;
    8000575c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000575e:	10054e63          	bltz	a0,8000587a <sys_link+0x13c>
    80005762:	08000613          	li	a2,128
    80005766:	f5040593          	addi	a1,s0,-176
    8000576a:	4505                	li	a0,1
    8000576c:	ffffd097          	auipc	ra,0xffffd
    80005770:	74c080e7          	jalr	1868(ra) # 80002eb8 <argstr>
    return -1;
    80005774:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005776:	10054263          	bltz	a0,8000587a <sys_link+0x13c>
  begin_op();
    8000577a:	fffff097          	auipc	ra,0xfffff
    8000577e:	d10080e7          	jalr	-752(ra) # 8000448a <begin_op>
  if((ip = namei(old)) == 0){
    80005782:	ed040513          	addi	a0,s0,-304
    80005786:	fffff097          	auipc	ra,0xfffff
    8000578a:	ae4080e7          	jalr	-1308(ra) # 8000426a <namei>
    8000578e:	84aa                	mv	s1,a0
    80005790:	c551                	beqz	a0,8000581c <sys_link+0xde>
  ilock(ip);
    80005792:	ffffe097          	auipc	ra,0xffffe
    80005796:	322080e7          	jalr	802(ra) # 80003ab4 <ilock>
  if(ip->type == T_DIR){
    8000579a:	04449703          	lh	a4,68(s1)
    8000579e:	4785                	li	a5,1
    800057a0:	08f70463          	beq	a4,a5,80005828 <sys_link+0xea>
  ip->nlink++;
    800057a4:	04a4d783          	lhu	a5,74(s1)
    800057a8:	2785                	addiw	a5,a5,1
    800057aa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800057ae:	8526                	mv	a0,s1
    800057b0:	ffffe097          	auipc	ra,0xffffe
    800057b4:	23a080e7          	jalr	570(ra) # 800039ea <iupdate>
  iunlock(ip);
    800057b8:	8526                	mv	a0,s1
    800057ba:	ffffe097          	auipc	ra,0xffffe
    800057be:	3bc080e7          	jalr	956(ra) # 80003b76 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800057c2:	fd040593          	addi	a1,s0,-48
    800057c6:	f5040513          	addi	a0,s0,-176
    800057ca:	fffff097          	auipc	ra,0xfffff
    800057ce:	abe080e7          	jalr	-1346(ra) # 80004288 <nameiparent>
    800057d2:	892a                	mv	s2,a0
    800057d4:	c935                	beqz	a0,80005848 <sys_link+0x10a>
  ilock(dp);
    800057d6:	ffffe097          	auipc	ra,0xffffe
    800057da:	2de080e7          	jalr	734(ra) # 80003ab4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800057de:	00092703          	lw	a4,0(s2)
    800057e2:	409c                	lw	a5,0(s1)
    800057e4:	04f71d63          	bne	a4,a5,8000583e <sys_link+0x100>
    800057e8:	40d0                	lw	a2,4(s1)
    800057ea:	fd040593          	addi	a1,s0,-48
    800057ee:	854a                	mv	a0,s2
    800057f0:	fffff097          	auipc	ra,0xfffff
    800057f4:	9b8080e7          	jalr	-1608(ra) # 800041a8 <dirlink>
    800057f8:	04054363          	bltz	a0,8000583e <sys_link+0x100>
  iunlockput(dp);
    800057fc:	854a                	mv	a0,s2
    800057fe:	ffffe097          	auipc	ra,0xffffe
    80005802:	518080e7          	jalr	1304(ra) # 80003d16 <iunlockput>
  iput(ip);
    80005806:	8526                	mv	a0,s1
    80005808:	ffffe097          	auipc	ra,0xffffe
    8000580c:	466080e7          	jalr	1126(ra) # 80003c6e <iput>
  end_op();
    80005810:	fffff097          	auipc	ra,0xfffff
    80005814:	cfa080e7          	jalr	-774(ra) # 8000450a <end_op>
  return 0;
    80005818:	4781                	li	a5,0
    8000581a:	a085                	j	8000587a <sys_link+0x13c>
    end_op();
    8000581c:	fffff097          	auipc	ra,0xfffff
    80005820:	cee080e7          	jalr	-786(ra) # 8000450a <end_op>
    return -1;
    80005824:	57fd                	li	a5,-1
    80005826:	a891                	j	8000587a <sys_link+0x13c>
    iunlockput(ip);
    80005828:	8526                	mv	a0,s1
    8000582a:	ffffe097          	auipc	ra,0xffffe
    8000582e:	4ec080e7          	jalr	1260(ra) # 80003d16 <iunlockput>
    end_op();
    80005832:	fffff097          	auipc	ra,0xfffff
    80005836:	cd8080e7          	jalr	-808(ra) # 8000450a <end_op>
    return -1;
    8000583a:	57fd                	li	a5,-1
    8000583c:	a83d                	j	8000587a <sys_link+0x13c>
    iunlockput(dp);
    8000583e:	854a                	mv	a0,s2
    80005840:	ffffe097          	auipc	ra,0xffffe
    80005844:	4d6080e7          	jalr	1238(ra) # 80003d16 <iunlockput>
  ilock(ip);
    80005848:	8526                	mv	a0,s1
    8000584a:	ffffe097          	auipc	ra,0xffffe
    8000584e:	26a080e7          	jalr	618(ra) # 80003ab4 <ilock>
  ip->nlink--;
    80005852:	04a4d783          	lhu	a5,74(s1)
    80005856:	37fd                	addiw	a5,a5,-1
    80005858:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000585c:	8526                	mv	a0,s1
    8000585e:	ffffe097          	auipc	ra,0xffffe
    80005862:	18c080e7          	jalr	396(ra) # 800039ea <iupdate>
  iunlockput(ip);
    80005866:	8526                	mv	a0,s1
    80005868:	ffffe097          	auipc	ra,0xffffe
    8000586c:	4ae080e7          	jalr	1198(ra) # 80003d16 <iunlockput>
  end_op();
    80005870:	fffff097          	auipc	ra,0xfffff
    80005874:	c9a080e7          	jalr	-870(ra) # 8000450a <end_op>
  return -1;
    80005878:	57fd                	li	a5,-1
}
    8000587a:	853e                	mv	a0,a5
    8000587c:	70b2                	ld	ra,296(sp)
    8000587e:	7412                	ld	s0,288(sp)
    80005880:	64f2                	ld	s1,280(sp)
    80005882:	6952                	ld	s2,272(sp)
    80005884:	6155                	addi	sp,sp,304
    80005886:	8082                	ret

0000000080005888 <sys_unlink>:
{
    80005888:	7151                	addi	sp,sp,-240
    8000588a:	f586                	sd	ra,232(sp)
    8000588c:	f1a2                	sd	s0,224(sp)
    8000588e:	eda6                	sd	s1,216(sp)
    80005890:	e9ca                	sd	s2,208(sp)
    80005892:	e5ce                	sd	s3,200(sp)
    80005894:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005896:	08000613          	li	a2,128
    8000589a:	f3040593          	addi	a1,s0,-208
    8000589e:	4501                	li	a0,0
    800058a0:	ffffd097          	auipc	ra,0xffffd
    800058a4:	618080e7          	jalr	1560(ra) # 80002eb8 <argstr>
    800058a8:	18054163          	bltz	a0,80005a2a <sys_unlink+0x1a2>
  begin_op();
    800058ac:	fffff097          	auipc	ra,0xfffff
    800058b0:	bde080e7          	jalr	-1058(ra) # 8000448a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800058b4:	fb040593          	addi	a1,s0,-80
    800058b8:	f3040513          	addi	a0,s0,-208
    800058bc:	fffff097          	auipc	ra,0xfffff
    800058c0:	9cc080e7          	jalr	-1588(ra) # 80004288 <nameiparent>
    800058c4:	84aa                	mv	s1,a0
    800058c6:	c979                	beqz	a0,8000599c <sys_unlink+0x114>
  ilock(dp);
    800058c8:	ffffe097          	auipc	ra,0xffffe
    800058cc:	1ec080e7          	jalr	492(ra) # 80003ab4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800058d0:	00003597          	auipc	a1,0x3
    800058d4:	e7058593          	addi	a1,a1,-400 # 80008740 <syscalls+0x2c8>
    800058d8:	fb040513          	addi	a0,s0,-80
    800058dc:	ffffe097          	auipc	ra,0xffffe
    800058e0:	6a2080e7          	jalr	1698(ra) # 80003f7e <namecmp>
    800058e4:	14050a63          	beqz	a0,80005a38 <sys_unlink+0x1b0>
    800058e8:	00003597          	auipc	a1,0x3
    800058ec:	e6058593          	addi	a1,a1,-416 # 80008748 <syscalls+0x2d0>
    800058f0:	fb040513          	addi	a0,s0,-80
    800058f4:	ffffe097          	auipc	ra,0xffffe
    800058f8:	68a080e7          	jalr	1674(ra) # 80003f7e <namecmp>
    800058fc:	12050e63          	beqz	a0,80005a38 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005900:	f2c40613          	addi	a2,s0,-212
    80005904:	fb040593          	addi	a1,s0,-80
    80005908:	8526                	mv	a0,s1
    8000590a:	ffffe097          	auipc	ra,0xffffe
    8000590e:	68e080e7          	jalr	1678(ra) # 80003f98 <dirlookup>
    80005912:	892a                	mv	s2,a0
    80005914:	12050263          	beqz	a0,80005a38 <sys_unlink+0x1b0>
  ilock(ip);
    80005918:	ffffe097          	auipc	ra,0xffffe
    8000591c:	19c080e7          	jalr	412(ra) # 80003ab4 <ilock>
  if(ip->nlink < 1)
    80005920:	04a91783          	lh	a5,74(s2)
    80005924:	08f05263          	blez	a5,800059a8 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005928:	04491703          	lh	a4,68(s2)
    8000592c:	4785                	li	a5,1
    8000592e:	08f70563          	beq	a4,a5,800059b8 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005932:	4641                	li	a2,16
    80005934:	4581                	li	a1,0
    80005936:	fc040513          	addi	a0,s0,-64
    8000593a:	ffffb097          	auipc	ra,0xffffb
    8000593e:	384080e7          	jalr	900(ra) # 80000cbe <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005942:	4741                	li	a4,16
    80005944:	f2c42683          	lw	a3,-212(s0)
    80005948:	fc040613          	addi	a2,s0,-64
    8000594c:	4581                	li	a1,0
    8000594e:	8526                	mv	a0,s1
    80005950:	ffffe097          	auipc	ra,0xffffe
    80005954:	510080e7          	jalr	1296(ra) # 80003e60 <writei>
    80005958:	47c1                	li	a5,16
    8000595a:	0af51563          	bne	a0,a5,80005a04 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    8000595e:	04491703          	lh	a4,68(s2)
    80005962:	4785                	li	a5,1
    80005964:	0af70863          	beq	a4,a5,80005a14 <sys_unlink+0x18c>
  iunlockput(dp);
    80005968:	8526                	mv	a0,s1
    8000596a:	ffffe097          	auipc	ra,0xffffe
    8000596e:	3ac080e7          	jalr	940(ra) # 80003d16 <iunlockput>
  ip->nlink--;
    80005972:	04a95783          	lhu	a5,74(s2)
    80005976:	37fd                	addiw	a5,a5,-1
    80005978:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000597c:	854a                	mv	a0,s2
    8000597e:	ffffe097          	auipc	ra,0xffffe
    80005982:	06c080e7          	jalr	108(ra) # 800039ea <iupdate>
  iunlockput(ip);
    80005986:	854a                	mv	a0,s2
    80005988:	ffffe097          	auipc	ra,0xffffe
    8000598c:	38e080e7          	jalr	910(ra) # 80003d16 <iunlockput>
  end_op();
    80005990:	fffff097          	auipc	ra,0xfffff
    80005994:	b7a080e7          	jalr	-1158(ra) # 8000450a <end_op>
  return 0;
    80005998:	4501                	li	a0,0
    8000599a:	a84d                	j	80005a4c <sys_unlink+0x1c4>
    end_op();
    8000599c:	fffff097          	auipc	ra,0xfffff
    800059a0:	b6e080e7          	jalr	-1170(ra) # 8000450a <end_op>
    return -1;
    800059a4:	557d                	li	a0,-1
    800059a6:	a05d                	j	80005a4c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800059a8:	00003517          	auipc	a0,0x3
    800059ac:	dc850513          	addi	a0,a0,-568 # 80008770 <syscalls+0x2f8>
    800059b0:	ffffb097          	auipc	ra,0xffffb
    800059b4:	b7a080e7          	jalr	-1158(ra) # 8000052a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800059b8:	04c92703          	lw	a4,76(s2)
    800059bc:	02000793          	li	a5,32
    800059c0:	f6e7f9e3          	bgeu	a5,a4,80005932 <sys_unlink+0xaa>
    800059c4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800059c8:	4741                	li	a4,16
    800059ca:	86ce                	mv	a3,s3
    800059cc:	f1840613          	addi	a2,s0,-232
    800059d0:	4581                	li	a1,0
    800059d2:	854a                	mv	a0,s2
    800059d4:	ffffe097          	auipc	ra,0xffffe
    800059d8:	394080e7          	jalr	916(ra) # 80003d68 <readi>
    800059dc:	47c1                	li	a5,16
    800059de:	00f51b63          	bne	a0,a5,800059f4 <sys_unlink+0x16c>
    if(de.inum != 0)
    800059e2:	f1845783          	lhu	a5,-232(s0)
    800059e6:	e7a1                	bnez	a5,80005a2e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800059e8:	29c1                	addiw	s3,s3,16
    800059ea:	04c92783          	lw	a5,76(s2)
    800059ee:	fcf9ede3          	bltu	s3,a5,800059c8 <sys_unlink+0x140>
    800059f2:	b781                	j	80005932 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800059f4:	00003517          	auipc	a0,0x3
    800059f8:	d9450513          	addi	a0,a0,-620 # 80008788 <syscalls+0x310>
    800059fc:	ffffb097          	auipc	ra,0xffffb
    80005a00:	b2e080e7          	jalr	-1234(ra) # 8000052a <panic>
    panic("unlink: writei");
    80005a04:	00003517          	auipc	a0,0x3
    80005a08:	d9c50513          	addi	a0,a0,-612 # 800087a0 <syscalls+0x328>
    80005a0c:	ffffb097          	auipc	ra,0xffffb
    80005a10:	b1e080e7          	jalr	-1250(ra) # 8000052a <panic>
    dp->nlink--;
    80005a14:	04a4d783          	lhu	a5,74(s1)
    80005a18:	37fd                	addiw	a5,a5,-1
    80005a1a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005a1e:	8526                	mv	a0,s1
    80005a20:	ffffe097          	auipc	ra,0xffffe
    80005a24:	fca080e7          	jalr	-54(ra) # 800039ea <iupdate>
    80005a28:	b781                	j	80005968 <sys_unlink+0xe0>
    return -1;
    80005a2a:	557d                	li	a0,-1
    80005a2c:	a005                	j	80005a4c <sys_unlink+0x1c4>
    iunlockput(ip);
    80005a2e:	854a                	mv	a0,s2
    80005a30:	ffffe097          	auipc	ra,0xffffe
    80005a34:	2e6080e7          	jalr	742(ra) # 80003d16 <iunlockput>
  iunlockput(dp);
    80005a38:	8526                	mv	a0,s1
    80005a3a:	ffffe097          	auipc	ra,0xffffe
    80005a3e:	2dc080e7          	jalr	732(ra) # 80003d16 <iunlockput>
  end_op();
    80005a42:	fffff097          	auipc	ra,0xfffff
    80005a46:	ac8080e7          	jalr	-1336(ra) # 8000450a <end_op>
  return -1;
    80005a4a:	557d                	li	a0,-1
}
    80005a4c:	70ae                	ld	ra,232(sp)
    80005a4e:	740e                	ld	s0,224(sp)
    80005a50:	64ee                	ld	s1,216(sp)
    80005a52:	694e                	ld	s2,208(sp)
    80005a54:	69ae                	ld	s3,200(sp)
    80005a56:	616d                	addi	sp,sp,240
    80005a58:	8082                	ret

0000000080005a5a <sys_open>:

uint64
sys_open(void)
{
    80005a5a:	7131                	addi	sp,sp,-192
    80005a5c:	fd06                	sd	ra,184(sp)
    80005a5e:	f922                	sd	s0,176(sp)
    80005a60:	f526                	sd	s1,168(sp)
    80005a62:	f14a                	sd	s2,160(sp)
    80005a64:	ed4e                	sd	s3,152(sp)
    80005a66:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005a68:	08000613          	li	a2,128
    80005a6c:	f5040593          	addi	a1,s0,-176
    80005a70:	4501                	li	a0,0
    80005a72:	ffffd097          	auipc	ra,0xffffd
    80005a76:	446080e7          	jalr	1094(ra) # 80002eb8 <argstr>
    return -1;
    80005a7a:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005a7c:	0c054163          	bltz	a0,80005b3e <sys_open+0xe4>
    80005a80:	f4c40593          	addi	a1,s0,-180
    80005a84:	4505                	li	a0,1
    80005a86:	ffffd097          	auipc	ra,0xffffd
    80005a8a:	3ee080e7          	jalr	1006(ra) # 80002e74 <argint>
    80005a8e:	0a054863          	bltz	a0,80005b3e <sys_open+0xe4>

  begin_op();
    80005a92:	fffff097          	auipc	ra,0xfffff
    80005a96:	9f8080e7          	jalr	-1544(ra) # 8000448a <begin_op>

  if(omode & O_CREATE){
    80005a9a:	f4c42783          	lw	a5,-180(s0)
    80005a9e:	2007f793          	andi	a5,a5,512
    80005aa2:	cbdd                	beqz	a5,80005b58 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005aa4:	4681                	li	a3,0
    80005aa6:	4601                	li	a2,0
    80005aa8:	4589                	li	a1,2
    80005aaa:	f5040513          	addi	a0,s0,-176
    80005aae:	00000097          	auipc	ra,0x0
    80005ab2:	974080e7          	jalr	-1676(ra) # 80005422 <create>
    80005ab6:	892a                	mv	s2,a0
    if(ip == 0){
    80005ab8:	c959                	beqz	a0,80005b4e <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005aba:	04491703          	lh	a4,68(s2)
    80005abe:	478d                	li	a5,3
    80005ac0:	00f71763          	bne	a4,a5,80005ace <sys_open+0x74>
    80005ac4:	04695703          	lhu	a4,70(s2)
    80005ac8:	47a5                	li	a5,9
    80005aca:	0ce7ec63          	bltu	a5,a4,80005ba2 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005ace:	fffff097          	auipc	ra,0xfffff
    80005ad2:	dcc080e7          	jalr	-564(ra) # 8000489a <filealloc>
    80005ad6:	89aa                	mv	s3,a0
    80005ad8:	10050263          	beqz	a0,80005bdc <sys_open+0x182>
    80005adc:	00000097          	auipc	ra,0x0
    80005ae0:	904080e7          	jalr	-1788(ra) # 800053e0 <fdalloc>
    80005ae4:	84aa                	mv	s1,a0
    80005ae6:	0e054663          	bltz	a0,80005bd2 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005aea:	04491703          	lh	a4,68(s2)
    80005aee:	478d                	li	a5,3
    80005af0:	0cf70463          	beq	a4,a5,80005bb8 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005af4:	4789                	li	a5,2
    80005af6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005afa:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005afe:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005b02:	f4c42783          	lw	a5,-180(s0)
    80005b06:	0017c713          	xori	a4,a5,1
    80005b0a:	8b05                	andi	a4,a4,1
    80005b0c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005b10:	0037f713          	andi	a4,a5,3
    80005b14:	00e03733          	snez	a4,a4
    80005b18:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005b1c:	4007f793          	andi	a5,a5,1024
    80005b20:	c791                	beqz	a5,80005b2c <sys_open+0xd2>
    80005b22:	04491703          	lh	a4,68(s2)
    80005b26:	4789                	li	a5,2
    80005b28:	08f70f63          	beq	a4,a5,80005bc6 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005b2c:	854a                	mv	a0,s2
    80005b2e:	ffffe097          	auipc	ra,0xffffe
    80005b32:	048080e7          	jalr	72(ra) # 80003b76 <iunlock>
  end_op();
    80005b36:	fffff097          	auipc	ra,0xfffff
    80005b3a:	9d4080e7          	jalr	-1580(ra) # 8000450a <end_op>

  return fd;
}
    80005b3e:	8526                	mv	a0,s1
    80005b40:	70ea                	ld	ra,184(sp)
    80005b42:	744a                	ld	s0,176(sp)
    80005b44:	74aa                	ld	s1,168(sp)
    80005b46:	790a                	ld	s2,160(sp)
    80005b48:	69ea                	ld	s3,152(sp)
    80005b4a:	6129                	addi	sp,sp,192
    80005b4c:	8082                	ret
      end_op();
    80005b4e:	fffff097          	auipc	ra,0xfffff
    80005b52:	9bc080e7          	jalr	-1604(ra) # 8000450a <end_op>
      return -1;
    80005b56:	b7e5                	j	80005b3e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005b58:	f5040513          	addi	a0,s0,-176
    80005b5c:	ffffe097          	auipc	ra,0xffffe
    80005b60:	70e080e7          	jalr	1806(ra) # 8000426a <namei>
    80005b64:	892a                	mv	s2,a0
    80005b66:	c905                	beqz	a0,80005b96 <sys_open+0x13c>
    ilock(ip);
    80005b68:	ffffe097          	auipc	ra,0xffffe
    80005b6c:	f4c080e7          	jalr	-180(ra) # 80003ab4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005b70:	04491703          	lh	a4,68(s2)
    80005b74:	4785                	li	a5,1
    80005b76:	f4f712e3          	bne	a4,a5,80005aba <sys_open+0x60>
    80005b7a:	f4c42783          	lw	a5,-180(s0)
    80005b7e:	dba1                	beqz	a5,80005ace <sys_open+0x74>
      iunlockput(ip);
    80005b80:	854a                	mv	a0,s2
    80005b82:	ffffe097          	auipc	ra,0xffffe
    80005b86:	194080e7          	jalr	404(ra) # 80003d16 <iunlockput>
      end_op();
    80005b8a:	fffff097          	auipc	ra,0xfffff
    80005b8e:	980080e7          	jalr	-1664(ra) # 8000450a <end_op>
      return -1;
    80005b92:	54fd                	li	s1,-1
    80005b94:	b76d                	j	80005b3e <sys_open+0xe4>
      end_op();
    80005b96:	fffff097          	auipc	ra,0xfffff
    80005b9a:	974080e7          	jalr	-1676(ra) # 8000450a <end_op>
      return -1;
    80005b9e:	54fd                	li	s1,-1
    80005ba0:	bf79                	j	80005b3e <sys_open+0xe4>
    iunlockput(ip);
    80005ba2:	854a                	mv	a0,s2
    80005ba4:	ffffe097          	auipc	ra,0xffffe
    80005ba8:	172080e7          	jalr	370(ra) # 80003d16 <iunlockput>
    end_op();
    80005bac:	fffff097          	auipc	ra,0xfffff
    80005bb0:	95e080e7          	jalr	-1698(ra) # 8000450a <end_op>
    return -1;
    80005bb4:	54fd                	li	s1,-1
    80005bb6:	b761                	j	80005b3e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005bb8:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005bbc:	04691783          	lh	a5,70(s2)
    80005bc0:	02f99223          	sh	a5,36(s3)
    80005bc4:	bf2d                	j	80005afe <sys_open+0xa4>
    itrunc(ip);
    80005bc6:	854a                	mv	a0,s2
    80005bc8:	ffffe097          	auipc	ra,0xffffe
    80005bcc:	ffa080e7          	jalr	-6(ra) # 80003bc2 <itrunc>
    80005bd0:	bfb1                	j	80005b2c <sys_open+0xd2>
      fileclose(f);
    80005bd2:	854e                	mv	a0,s3
    80005bd4:	fffff097          	auipc	ra,0xfffff
    80005bd8:	d82080e7          	jalr	-638(ra) # 80004956 <fileclose>
    iunlockput(ip);
    80005bdc:	854a                	mv	a0,s2
    80005bde:	ffffe097          	auipc	ra,0xffffe
    80005be2:	138080e7          	jalr	312(ra) # 80003d16 <iunlockput>
    end_op();
    80005be6:	fffff097          	auipc	ra,0xfffff
    80005bea:	924080e7          	jalr	-1756(ra) # 8000450a <end_op>
    return -1;
    80005bee:	54fd                	li	s1,-1
    80005bf0:	b7b9                	j	80005b3e <sys_open+0xe4>

0000000080005bf2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005bf2:	7175                	addi	sp,sp,-144
    80005bf4:	e506                	sd	ra,136(sp)
    80005bf6:	e122                	sd	s0,128(sp)
    80005bf8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005bfa:	fffff097          	auipc	ra,0xfffff
    80005bfe:	890080e7          	jalr	-1904(ra) # 8000448a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005c02:	08000613          	li	a2,128
    80005c06:	f7040593          	addi	a1,s0,-144
    80005c0a:	4501                	li	a0,0
    80005c0c:	ffffd097          	auipc	ra,0xffffd
    80005c10:	2ac080e7          	jalr	684(ra) # 80002eb8 <argstr>
    80005c14:	02054963          	bltz	a0,80005c46 <sys_mkdir+0x54>
    80005c18:	4681                	li	a3,0
    80005c1a:	4601                	li	a2,0
    80005c1c:	4585                	li	a1,1
    80005c1e:	f7040513          	addi	a0,s0,-144
    80005c22:	00000097          	auipc	ra,0x0
    80005c26:	800080e7          	jalr	-2048(ra) # 80005422 <create>
    80005c2a:	cd11                	beqz	a0,80005c46 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005c2c:	ffffe097          	auipc	ra,0xffffe
    80005c30:	0ea080e7          	jalr	234(ra) # 80003d16 <iunlockput>
  end_op();
    80005c34:	fffff097          	auipc	ra,0xfffff
    80005c38:	8d6080e7          	jalr	-1834(ra) # 8000450a <end_op>
  return 0;
    80005c3c:	4501                	li	a0,0
}
    80005c3e:	60aa                	ld	ra,136(sp)
    80005c40:	640a                	ld	s0,128(sp)
    80005c42:	6149                	addi	sp,sp,144
    80005c44:	8082                	ret
    end_op();
    80005c46:	fffff097          	auipc	ra,0xfffff
    80005c4a:	8c4080e7          	jalr	-1852(ra) # 8000450a <end_op>
    return -1;
    80005c4e:	557d                	li	a0,-1
    80005c50:	b7fd                	j	80005c3e <sys_mkdir+0x4c>

0000000080005c52 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005c52:	7135                	addi	sp,sp,-160
    80005c54:	ed06                	sd	ra,152(sp)
    80005c56:	e922                	sd	s0,144(sp)
    80005c58:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005c5a:	fffff097          	auipc	ra,0xfffff
    80005c5e:	830080e7          	jalr	-2000(ra) # 8000448a <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005c62:	08000613          	li	a2,128
    80005c66:	f7040593          	addi	a1,s0,-144
    80005c6a:	4501                	li	a0,0
    80005c6c:	ffffd097          	auipc	ra,0xffffd
    80005c70:	24c080e7          	jalr	588(ra) # 80002eb8 <argstr>
    80005c74:	04054a63          	bltz	a0,80005cc8 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005c78:	f6c40593          	addi	a1,s0,-148
    80005c7c:	4505                	li	a0,1
    80005c7e:	ffffd097          	auipc	ra,0xffffd
    80005c82:	1f6080e7          	jalr	502(ra) # 80002e74 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005c86:	04054163          	bltz	a0,80005cc8 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005c8a:	f6840593          	addi	a1,s0,-152
    80005c8e:	4509                	li	a0,2
    80005c90:	ffffd097          	auipc	ra,0xffffd
    80005c94:	1e4080e7          	jalr	484(ra) # 80002e74 <argint>
     argint(1, &major) < 0 ||
    80005c98:	02054863          	bltz	a0,80005cc8 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005c9c:	f6841683          	lh	a3,-152(s0)
    80005ca0:	f6c41603          	lh	a2,-148(s0)
    80005ca4:	458d                	li	a1,3
    80005ca6:	f7040513          	addi	a0,s0,-144
    80005caa:	fffff097          	auipc	ra,0xfffff
    80005cae:	778080e7          	jalr	1912(ra) # 80005422 <create>
     argint(2, &minor) < 0 ||
    80005cb2:	c919                	beqz	a0,80005cc8 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005cb4:	ffffe097          	auipc	ra,0xffffe
    80005cb8:	062080e7          	jalr	98(ra) # 80003d16 <iunlockput>
  end_op();
    80005cbc:	fffff097          	auipc	ra,0xfffff
    80005cc0:	84e080e7          	jalr	-1970(ra) # 8000450a <end_op>
  return 0;
    80005cc4:	4501                	li	a0,0
    80005cc6:	a031                	j	80005cd2 <sys_mknod+0x80>
    end_op();
    80005cc8:	fffff097          	auipc	ra,0xfffff
    80005ccc:	842080e7          	jalr	-1982(ra) # 8000450a <end_op>
    return -1;
    80005cd0:	557d                	li	a0,-1
}
    80005cd2:	60ea                	ld	ra,152(sp)
    80005cd4:	644a                	ld	s0,144(sp)
    80005cd6:	610d                	addi	sp,sp,160
    80005cd8:	8082                	ret

0000000080005cda <sys_chdir>:

uint64
sys_chdir(void)
{
    80005cda:	7135                	addi	sp,sp,-160
    80005cdc:	ed06                	sd	ra,152(sp)
    80005cde:	e922                	sd	s0,144(sp)
    80005ce0:	e526                	sd	s1,136(sp)
    80005ce2:	e14a                	sd	s2,128(sp)
    80005ce4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005ce6:	ffffc097          	auipc	ra,0xffffc
    80005cea:	c98080e7          	jalr	-872(ra) # 8000197e <myproc>
    80005cee:	892a                	mv	s2,a0
  
  begin_op();
    80005cf0:	ffffe097          	auipc	ra,0xffffe
    80005cf4:	79a080e7          	jalr	1946(ra) # 8000448a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005cf8:	08000613          	li	a2,128
    80005cfc:	f6040593          	addi	a1,s0,-160
    80005d00:	4501                	li	a0,0
    80005d02:	ffffd097          	auipc	ra,0xffffd
    80005d06:	1b6080e7          	jalr	438(ra) # 80002eb8 <argstr>
    80005d0a:	04054b63          	bltz	a0,80005d60 <sys_chdir+0x86>
    80005d0e:	f6040513          	addi	a0,s0,-160
    80005d12:	ffffe097          	auipc	ra,0xffffe
    80005d16:	558080e7          	jalr	1368(ra) # 8000426a <namei>
    80005d1a:	84aa                	mv	s1,a0
    80005d1c:	c131                	beqz	a0,80005d60 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005d1e:	ffffe097          	auipc	ra,0xffffe
    80005d22:	d96080e7          	jalr	-618(ra) # 80003ab4 <ilock>
  if(ip->type != T_DIR){
    80005d26:	04449703          	lh	a4,68(s1)
    80005d2a:	4785                	li	a5,1
    80005d2c:	04f71063          	bne	a4,a5,80005d6c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005d30:	8526                	mv	a0,s1
    80005d32:	ffffe097          	auipc	ra,0xffffe
    80005d36:	e44080e7          	jalr	-444(ra) # 80003b76 <iunlock>
  iput(p->cwd);
    80005d3a:	15093503          	ld	a0,336(s2)
    80005d3e:	ffffe097          	auipc	ra,0xffffe
    80005d42:	f30080e7          	jalr	-208(ra) # 80003c6e <iput>
  end_op();
    80005d46:	ffffe097          	auipc	ra,0xffffe
    80005d4a:	7c4080e7          	jalr	1988(ra) # 8000450a <end_op>
  p->cwd = ip;
    80005d4e:	14993823          	sd	s1,336(s2)
  return 0;
    80005d52:	4501                	li	a0,0
}
    80005d54:	60ea                	ld	ra,152(sp)
    80005d56:	644a                	ld	s0,144(sp)
    80005d58:	64aa                	ld	s1,136(sp)
    80005d5a:	690a                	ld	s2,128(sp)
    80005d5c:	610d                	addi	sp,sp,160
    80005d5e:	8082                	ret
    end_op();
    80005d60:	ffffe097          	auipc	ra,0xffffe
    80005d64:	7aa080e7          	jalr	1962(ra) # 8000450a <end_op>
    return -1;
    80005d68:	557d                	li	a0,-1
    80005d6a:	b7ed                	j	80005d54 <sys_chdir+0x7a>
    iunlockput(ip);
    80005d6c:	8526                	mv	a0,s1
    80005d6e:	ffffe097          	auipc	ra,0xffffe
    80005d72:	fa8080e7          	jalr	-88(ra) # 80003d16 <iunlockput>
    end_op();
    80005d76:	ffffe097          	auipc	ra,0xffffe
    80005d7a:	794080e7          	jalr	1940(ra) # 8000450a <end_op>
    return -1;
    80005d7e:	557d                	li	a0,-1
    80005d80:	bfd1                	j	80005d54 <sys_chdir+0x7a>

0000000080005d82 <sys_exec>:

uint64
sys_exec(void)
{
    80005d82:	7145                	addi	sp,sp,-464
    80005d84:	e786                	sd	ra,456(sp)
    80005d86:	e3a2                	sd	s0,448(sp)
    80005d88:	ff26                	sd	s1,440(sp)
    80005d8a:	fb4a                	sd	s2,432(sp)
    80005d8c:	f74e                	sd	s3,424(sp)
    80005d8e:	f352                	sd	s4,416(sp)
    80005d90:	ef56                	sd	s5,408(sp)
    80005d92:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005d94:	08000613          	li	a2,128
    80005d98:	f4040593          	addi	a1,s0,-192
    80005d9c:	4501                	li	a0,0
    80005d9e:	ffffd097          	auipc	ra,0xffffd
    80005da2:	11a080e7          	jalr	282(ra) # 80002eb8 <argstr>
    return -1;
    80005da6:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005da8:	0c054a63          	bltz	a0,80005e7c <sys_exec+0xfa>
    80005dac:	e3840593          	addi	a1,s0,-456
    80005db0:	4505                	li	a0,1
    80005db2:	ffffd097          	auipc	ra,0xffffd
    80005db6:	0e4080e7          	jalr	228(ra) # 80002e96 <argaddr>
    80005dba:	0c054163          	bltz	a0,80005e7c <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005dbe:	10000613          	li	a2,256
    80005dc2:	4581                	li	a1,0
    80005dc4:	e4040513          	addi	a0,s0,-448
    80005dc8:	ffffb097          	auipc	ra,0xffffb
    80005dcc:	ef6080e7          	jalr	-266(ra) # 80000cbe <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005dd0:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005dd4:	89a6                	mv	s3,s1
    80005dd6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005dd8:	02000a13          	li	s4,32
    80005ddc:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005de0:	00391793          	slli	a5,s2,0x3
    80005de4:	e3040593          	addi	a1,s0,-464
    80005de8:	e3843503          	ld	a0,-456(s0)
    80005dec:	953e                	add	a0,a0,a5
    80005dee:	ffffd097          	auipc	ra,0xffffd
    80005df2:	fec080e7          	jalr	-20(ra) # 80002dda <fetchaddr>
    80005df6:	02054a63          	bltz	a0,80005e2a <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005dfa:	e3043783          	ld	a5,-464(s0)
    80005dfe:	c3b9                	beqz	a5,80005e44 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005e00:	ffffb097          	auipc	ra,0xffffb
    80005e04:	cd2080e7          	jalr	-814(ra) # 80000ad2 <kalloc>
    80005e08:	85aa                	mv	a1,a0
    80005e0a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005e0e:	cd11                	beqz	a0,80005e2a <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005e10:	6605                	lui	a2,0x1
    80005e12:	e3043503          	ld	a0,-464(s0)
    80005e16:	ffffd097          	auipc	ra,0xffffd
    80005e1a:	016080e7          	jalr	22(ra) # 80002e2c <fetchstr>
    80005e1e:	00054663          	bltz	a0,80005e2a <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005e22:	0905                	addi	s2,s2,1
    80005e24:	09a1                	addi	s3,s3,8
    80005e26:	fb491be3          	bne	s2,s4,80005ddc <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e2a:	10048913          	addi	s2,s1,256
    80005e2e:	6088                	ld	a0,0(s1)
    80005e30:	c529                	beqz	a0,80005e7a <sys_exec+0xf8>
    kfree(argv[i]);
    80005e32:	ffffb097          	auipc	ra,0xffffb
    80005e36:	ba4080e7          	jalr	-1116(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e3a:	04a1                	addi	s1,s1,8
    80005e3c:	ff2499e3          	bne	s1,s2,80005e2e <sys_exec+0xac>
  return -1;
    80005e40:	597d                	li	s2,-1
    80005e42:	a82d                	j	80005e7c <sys_exec+0xfa>
      argv[i] = 0;
    80005e44:	0a8e                	slli	s5,s5,0x3
    80005e46:	fc040793          	addi	a5,s0,-64
    80005e4a:	9abe                	add	s5,s5,a5
    80005e4c:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffcde80>
  int ret = exec(path, argv);
    80005e50:	e4040593          	addi	a1,s0,-448
    80005e54:	f4040513          	addi	a0,s0,-192
    80005e58:	fffff097          	auipc	ra,0xfffff
    80005e5c:	150080e7          	jalr	336(ra) # 80004fa8 <exec>
    80005e60:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e62:	10048993          	addi	s3,s1,256
    80005e66:	6088                	ld	a0,0(s1)
    80005e68:	c911                	beqz	a0,80005e7c <sys_exec+0xfa>
    kfree(argv[i]);
    80005e6a:	ffffb097          	auipc	ra,0xffffb
    80005e6e:	b6c080e7          	jalr	-1172(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e72:	04a1                	addi	s1,s1,8
    80005e74:	ff3499e3          	bne	s1,s3,80005e66 <sys_exec+0xe4>
    80005e78:	a011                	j	80005e7c <sys_exec+0xfa>
  return -1;
    80005e7a:	597d                	li	s2,-1
}
    80005e7c:	854a                	mv	a0,s2
    80005e7e:	60be                	ld	ra,456(sp)
    80005e80:	641e                	ld	s0,448(sp)
    80005e82:	74fa                	ld	s1,440(sp)
    80005e84:	795a                	ld	s2,432(sp)
    80005e86:	79ba                	ld	s3,424(sp)
    80005e88:	7a1a                	ld	s4,416(sp)
    80005e8a:	6afa                	ld	s5,408(sp)
    80005e8c:	6179                	addi	sp,sp,464
    80005e8e:	8082                	ret

0000000080005e90 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005e90:	7139                	addi	sp,sp,-64
    80005e92:	fc06                	sd	ra,56(sp)
    80005e94:	f822                	sd	s0,48(sp)
    80005e96:	f426                	sd	s1,40(sp)
    80005e98:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005e9a:	ffffc097          	auipc	ra,0xffffc
    80005e9e:	ae4080e7          	jalr	-1308(ra) # 8000197e <myproc>
    80005ea2:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005ea4:	fd840593          	addi	a1,s0,-40
    80005ea8:	4501                	li	a0,0
    80005eaa:	ffffd097          	auipc	ra,0xffffd
    80005eae:	fec080e7          	jalr	-20(ra) # 80002e96 <argaddr>
    return -1;
    80005eb2:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005eb4:	0e054063          	bltz	a0,80005f94 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005eb8:	fc840593          	addi	a1,s0,-56
    80005ebc:	fd040513          	addi	a0,s0,-48
    80005ec0:	fffff097          	auipc	ra,0xfffff
    80005ec4:	dc6080e7          	jalr	-570(ra) # 80004c86 <pipealloc>
    return -1;
    80005ec8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005eca:	0c054563          	bltz	a0,80005f94 <sys_pipe+0x104>
  fd0 = -1;
    80005ece:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005ed2:	fd043503          	ld	a0,-48(s0)
    80005ed6:	fffff097          	auipc	ra,0xfffff
    80005eda:	50a080e7          	jalr	1290(ra) # 800053e0 <fdalloc>
    80005ede:	fca42223          	sw	a0,-60(s0)
    80005ee2:	08054c63          	bltz	a0,80005f7a <sys_pipe+0xea>
    80005ee6:	fc843503          	ld	a0,-56(s0)
    80005eea:	fffff097          	auipc	ra,0xfffff
    80005eee:	4f6080e7          	jalr	1270(ra) # 800053e0 <fdalloc>
    80005ef2:	fca42023          	sw	a0,-64(s0)
    80005ef6:	06054863          	bltz	a0,80005f66 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005efa:	4691                	li	a3,4
    80005efc:	fc440613          	addi	a2,s0,-60
    80005f00:	fd843583          	ld	a1,-40(s0)
    80005f04:	68a8                	ld	a0,80(s1)
    80005f06:	ffffb097          	auipc	ra,0xffffb
    80005f0a:	738080e7          	jalr	1848(ra) # 8000163e <copyout>
    80005f0e:	02054063          	bltz	a0,80005f2e <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005f12:	4691                	li	a3,4
    80005f14:	fc040613          	addi	a2,s0,-64
    80005f18:	fd843583          	ld	a1,-40(s0)
    80005f1c:	0591                	addi	a1,a1,4
    80005f1e:	68a8                	ld	a0,80(s1)
    80005f20:	ffffb097          	auipc	ra,0xffffb
    80005f24:	71e080e7          	jalr	1822(ra) # 8000163e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005f28:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005f2a:	06055563          	bgez	a0,80005f94 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005f2e:	fc442783          	lw	a5,-60(s0)
    80005f32:	07e9                	addi	a5,a5,26
    80005f34:	078e                	slli	a5,a5,0x3
    80005f36:	97a6                	add	a5,a5,s1
    80005f38:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005f3c:	fc042503          	lw	a0,-64(s0)
    80005f40:	0569                	addi	a0,a0,26
    80005f42:	050e                	slli	a0,a0,0x3
    80005f44:	9526                	add	a0,a0,s1
    80005f46:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005f4a:	fd043503          	ld	a0,-48(s0)
    80005f4e:	fffff097          	auipc	ra,0xfffff
    80005f52:	a08080e7          	jalr	-1528(ra) # 80004956 <fileclose>
    fileclose(wf);
    80005f56:	fc843503          	ld	a0,-56(s0)
    80005f5a:	fffff097          	auipc	ra,0xfffff
    80005f5e:	9fc080e7          	jalr	-1540(ra) # 80004956 <fileclose>
    return -1;
    80005f62:	57fd                	li	a5,-1
    80005f64:	a805                	j	80005f94 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005f66:	fc442783          	lw	a5,-60(s0)
    80005f6a:	0007c863          	bltz	a5,80005f7a <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005f6e:	01a78513          	addi	a0,a5,26
    80005f72:	050e                	slli	a0,a0,0x3
    80005f74:	9526                	add	a0,a0,s1
    80005f76:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005f7a:	fd043503          	ld	a0,-48(s0)
    80005f7e:	fffff097          	auipc	ra,0xfffff
    80005f82:	9d8080e7          	jalr	-1576(ra) # 80004956 <fileclose>
    fileclose(wf);
    80005f86:	fc843503          	ld	a0,-56(s0)
    80005f8a:	fffff097          	auipc	ra,0xfffff
    80005f8e:	9cc080e7          	jalr	-1588(ra) # 80004956 <fileclose>
    return -1;
    80005f92:	57fd                	li	a5,-1
}
    80005f94:	853e                	mv	a0,a5
    80005f96:	70e2                	ld	ra,56(sp)
    80005f98:	7442                	ld	s0,48(sp)
    80005f9a:	74a2                	ld	s1,40(sp)
    80005f9c:	6121                	addi	sp,sp,64
    80005f9e:	8082                	ret

0000000080005fa0 <kernelvec>:
    80005fa0:	7111                	addi	sp,sp,-256
    80005fa2:	e006                	sd	ra,0(sp)
    80005fa4:	e40a                	sd	sp,8(sp)
    80005fa6:	e80e                	sd	gp,16(sp)
    80005fa8:	ec12                	sd	tp,24(sp)
    80005faa:	f016                	sd	t0,32(sp)
    80005fac:	f41a                	sd	t1,40(sp)
    80005fae:	f81e                	sd	t2,48(sp)
    80005fb0:	fc22                	sd	s0,56(sp)
    80005fb2:	e0a6                	sd	s1,64(sp)
    80005fb4:	e4aa                	sd	a0,72(sp)
    80005fb6:	e8ae                	sd	a1,80(sp)
    80005fb8:	ecb2                	sd	a2,88(sp)
    80005fba:	f0b6                	sd	a3,96(sp)
    80005fbc:	f4ba                	sd	a4,104(sp)
    80005fbe:	f8be                	sd	a5,112(sp)
    80005fc0:	fcc2                	sd	a6,120(sp)
    80005fc2:	e146                	sd	a7,128(sp)
    80005fc4:	e54a                	sd	s2,136(sp)
    80005fc6:	e94e                	sd	s3,144(sp)
    80005fc8:	ed52                	sd	s4,152(sp)
    80005fca:	f156                	sd	s5,160(sp)
    80005fcc:	f55a                	sd	s6,168(sp)
    80005fce:	f95e                	sd	s7,176(sp)
    80005fd0:	fd62                	sd	s8,184(sp)
    80005fd2:	e1e6                	sd	s9,192(sp)
    80005fd4:	e5ea                	sd	s10,200(sp)
    80005fd6:	e9ee                	sd	s11,208(sp)
    80005fd8:	edf2                	sd	t3,216(sp)
    80005fda:	f1f6                	sd	t4,224(sp)
    80005fdc:	f5fa                	sd	t5,232(sp)
    80005fde:	f9fe                	sd	t6,240(sp)
    80005fe0:	cc7fc0ef          	jal	ra,80002ca6 <kerneltrap>
    80005fe4:	6082                	ld	ra,0(sp)
    80005fe6:	6122                	ld	sp,8(sp)
    80005fe8:	61c2                	ld	gp,16(sp)
    80005fea:	7282                	ld	t0,32(sp)
    80005fec:	7322                	ld	t1,40(sp)
    80005fee:	73c2                	ld	t2,48(sp)
    80005ff0:	7462                	ld	s0,56(sp)
    80005ff2:	6486                	ld	s1,64(sp)
    80005ff4:	6526                	ld	a0,72(sp)
    80005ff6:	65c6                	ld	a1,80(sp)
    80005ff8:	6666                	ld	a2,88(sp)
    80005ffa:	7686                	ld	a3,96(sp)
    80005ffc:	7726                	ld	a4,104(sp)
    80005ffe:	77c6                	ld	a5,112(sp)
    80006000:	7866                	ld	a6,120(sp)
    80006002:	688a                	ld	a7,128(sp)
    80006004:	692a                	ld	s2,136(sp)
    80006006:	69ca                	ld	s3,144(sp)
    80006008:	6a6a                	ld	s4,152(sp)
    8000600a:	7a8a                	ld	s5,160(sp)
    8000600c:	7b2a                	ld	s6,168(sp)
    8000600e:	7bca                	ld	s7,176(sp)
    80006010:	7c6a                	ld	s8,184(sp)
    80006012:	6c8e                	ld	s9,192(sp)
    80006014:	6d2e                	ld	s10,200(sp)
    80006016:	6dce                	ld	s11,208(sp)
    80006018:	6e6e                	ld	t3,216(sp)
    8000601a:	7e8e                	ld	t4,224(sp)
    8000601c:	7f2e                	ld	t5,232(sp)
    8000601e:	7fce                	ld	t6,240(sp)
    80006020:	6111                	addi	sp,sp,256
    80006022:	10200073          	sret
    80006026:	00000013          	nop
    8000602a:	00000013          	nop
    8000602e:	0001                	nop

0000000080006030 <timervec>:
    80006030:	34051573          	csrrw	a0,mscratch,a0
    80006034:	e10c                	sd	a1,0(a0)
    80006036:	e510                	sd	a2,8(a0)
    80006038:	e914                	sd	a3,16(a0)
    8000603a:	6d0c                	ld	a1,24(a0)
    8000603c:	7110                	ld	a2,32(a0)
    8000603e:	6194                	ld	a3,0(a1)
    80006040:	96b2                	add	a3,a3,a2
    80006042:	e194                	sd	a3,0(a1)
    80006044:	4589                	li	a1,2
    80006046:	14459073          	csrw	sip,a1
    8000604a:	6914                	ld	a3,16(a0)
    8000604c:	6510                	ld	a2,8(a0)
    8000604e:	610c                	ld	a1,0(a0)
    80006050:	34051573          	csrrw	a0,mscratch,a0
    80006054:	30200073          	mret
	...

000000008000605a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000605a:	1141                	addi	sp,sp,-16
    8000605c:	e422                	sd	s0,8(sp)
    8000605e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006060:	0c0007b7          	lui	a5,0xc000
    80006064:	4705                	li	a4,1
    80006066:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006068:	c3d8                	sw	a4,4(a5)
}
    8000606a:	6422                	ld	s0,8(sp)
    8000606c:	0141                	addi	sp,sp,16
    8000606e:	8082                	ret

0000000080006070 <plicinithart>:

void
plicinithart(void)
{
    80006070:	1141                	addi	sp,sp,-16
    80006072:	e406                	sd	ra,8(sp)
    80006074:	e022                	sd	s0,0(sp)
    80006076:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006078:	ffffc097          	auipc	ra,0xffffc
    8000607c:	8da080e7          	jalr	-1830(ra) # 80001952 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006080:	0085171b          	slliw	a4,a0,0x8
    80006084:	0c0027b7          	lui	a5,0xc002
    80006088:	97ba                	add	a5,a5,a4
    8000608a:	40200713          	li	a4,1026
    8000608e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006092:	00d5151b          	slliw	a0,a0,0xd
    80006096:	0c2017b7          	lui	a5,0xc201
    8000609a:	953e                	add	a0,a0,a5
    8000609c:	00052023          	sw	zero,0(a0)
}
    800060a0:	60a2                	ld	ra,8(sp)
    800060a2:	6402                	ld	s0,0(sp)
    800060a4:	0141                	addi	sp,sp,16
    800060a6:	8082                	ret

00000000800060a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800060a8:	1141                	addi	sp,sp,-16
    800060aa:	e406                	sd	ra,8(sp)
    800060ac:	e022                	sd	s0,0(sp)
    800060ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800060b0:	ffffc097          	auipc	ra,0xffffc
    800060b4:	8a2080e7          	jalr	-1886(ra) # 80001952 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800060b8:	00d5179b          	slliw	a5,a0,0xd
    800060bc:	0c201537          	lui	a0,0xc201
    800060c0:	953e                	add	a0,a0,a5
  return irq;
}
    800060c2:	4148                	lw	a0,4(a0)
    800060c4:	60a2                	ld	ra,8(sp)
    800060c6:	6402                	ld	s0,0(sp)
    800060c8:	0141                	addi	sp,sp,16
    800060ca:	8082                	ret

00000000800060cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800060cc:	1101                	addi	sp,sp,-32
    800060ce:	ec06                	sd	ra,24(sp)
    800060d0:	e822                	sd	s0,16(sp)
    800060d2:	e426                	sd	s1,8(sp)
    800060d4:	1000                	addi	s0,sp,32
    800060d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800060d8:	ffffc097          	auipc	ra,0xffffc
    800060dc:	87a080e7          	jalr	-1926(ra) # 80001952 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800060e0:	00d5151b          	slliw	a0,a0,0xd
    800060e4:	0c2017b7          	lui	a5,0xc201
    800060e8:	97aa                	add	a5,a5,a0
    800060ea:	c3c4                	sw	s1,4(a5)
}
    800060ec:	60e2                	ld	ra,24(sp)
    800060ee:	6442                	ld	s0,16(sp)
    800060f0:	64a2                	ld	s1,8(sp)
    800060f2:	6105                	addi	sp,sp,32
    800060f4:	8082                	ret

00000000800060f6 <start_ret>:
    800060f6:	48e1                	li	a7,24
    800060f8:	00000073          	ecall

00000000800060fc <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800060fc:	1141                	addi	sp,sp,-16
    800060fe:	e406                	sd	ra,8(sp)
    80006100:	e022                	sd	s0,0(sp)
    80006102:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006104:	479d                	li	a5,7
    80006106:	06a7c963          	blt	a5,a0,80006178 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    8000610a:	00028797          	auipc	a5,0x28
    8000610e:	ef678793          	addi	a5,a5,-266 # 8002e000 <disk>
    80006112:	00a78733          	add	a4,a5,a0
    80006116:	6789                	lui	a5,0x2
    80006118:	97ba                	add	a5,a5,a4
    8000611a:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000611e:	e7ad                	bnez	a5,80006188 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006120:	00451793          	slli	a5,a0,0x4
    80006124:	0002a717          	auipc	a4,0x2a
    80006128:	edc70713          	addi	a4,a4,-292 # 80030000 <disk+0x2000>
    8000612c:	6314                	ld	a3,0(a4)
    8000612e:	96be                	add	a3,a3,a5
    80006130:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80006134:	6314                	ld	a3,0(a4)
    80006136:	96be                	add	a3,a3,a5
    80006138:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    8000613c:	6314                	ld	a3,0(a4)
    8000613e:	96be                	add	a3,a3,a5
    80006140:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80006144:	6318                	ld	a4,0(a4)
    80006146:	97ba                	add	a5,a5,a4
    80006148:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    8000614c:	00028797          	auipc	a5,0x28
    80006150:	eb478793          	addi	a5,a5,-332 # 8002e000 <disk>
    80006154:	97aa                	add	a5,a5,a0
    80006156:	6509                	lui	a0,0x2
    80006158:	953e                	add	a0,a0,a5
    8000615a:	4785                	li	a5,1
    8000615c:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80006160:	0002a517          	auipc	a0,0x2a
    80006164:	eb850513          	addi	a0,a0,-328 # 80030018 <disk+0x2018>
    80006168:	ffffc097          	auipc	ra,0xffffc
    8000616c:	106080e7          	jalr	262(ra) # 8000226e <wakeup>
}
    80006170:	60a2                	ld	ra,8(sp)
    80006172:	6402                	ld	s0,0(sp)
    80006174:	0141                	addi	sp,sp,16
    80006176:	8082                	ret
    panic("free_desc 1");
    80006178:	00002517          	auipc	a0,0x2
    8000617c:	63850513          	addi	a0,a0,1592 # 800087b0 <syscalls+0x338>
    80006180:	ffffa097          	auipc	ra,0xffffa
    80006184:	3aa080e7          	jalr	938(ra) # 8000052a <panic>
    panic("free_desc 2");
    80006188:	00002517          	auipc	a0,0x2
    8000618c:	63850513          	addi	a0,a0,1592 # 800087c0 <syscalls+0x348>
    80006190:	ffffa097          	auipc	ra,0xffffa
    80006194:	39a080e7          	jalr	922(ra) # 8000052a <panic>

0000000080006198 <virtio_disk_init>:
{
    80006198:	1101                	addi	sp,sp,-32
    8000619a:	ec06                	sd	ra,24(sp)
    8000619c:	e822                	sd	s0,16(sp)
    8000619e:	e426                	sd	s1,8(sp)
    800061a0:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800061a2:	00002597          	auipc	a1,0x2
    800061a6:	62e58593          	addi	a1,a1,1582 # 800087d0 <syscalls+0x358>
    800061aa:	0002a517          	auipc	a0,0x2a
    800061ae:	f7e50513          	addi	a0,a0,-130 # 80030128 <disk+0x2128>
    800061b2:	ffffb097          	auipc	ra,0xffffb
    800061b6:	980080e7          	jalr	-1664(ra) # 80000b32 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800061ba:	100017b7          	lui	a5,0x10001
    800061be:	4398                	lw	a4,0(a5)
    800061c0:	2701                	sext.w	a4,a4
    800061c2:	747277b7          	lui	a5,0x74727
    800061c6:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800061ca:	0ef71163          	bne	a4,a5,800062ac <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800061ce:	100017b7          	lui	a5,0x10001
    800061d2:	43dc                	lw	a5,4(a5)
    800061d4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800061d6:	4705                	li	a4,1
    800061d8:	0ce79a63          	bne	a5,a4,800062ac <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800061dc:	100017b7          	lui	a5,0x10001
    800061e0:	479c                	lw	a5,8(a5)
    800061e2:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800061e4:	4709                	li	a4,2
    800061e6:	0ce79363          	bne	a5,a4,800062ac <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800061ea:	100017b7          	lui	a5,0x10001
    800061ee:	47d8                	lw	a4,12(a5)
    800061f0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800061f2:	554d47b7          	lui	a5,0x554d4
    800061f6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800061fa:	0af71963          	bne	a4,a5,800062ac <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800061fe:	100017b7          	lui	a5,0x10001
    80006202:	4705                	li	a4,1
    80006204:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006206:	470d                	li	a4,3
    80006208:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000620a:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000620c:	c7ffe737          	lui	a4,0xc7ffe
    80006210:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fcd75f>
    80006214:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006216:	2701                	sext.w	a4,a4
    80006218:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000621a:	472d                	li	a4,11
    8000621c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000621e:	473d                	li	a4,15
    80006220:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006222:	6705                	lui	a4,0x1
    80006224:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006226:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000622a:	5bdc                	lw	a5,52(a5)
    8000622c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000622e:	c7d9                	beqz	a5,800062bc <virtio_disk_init+0x124>
  if(max < NUM)
    80006230:	471d                	li	a4,7
    80006232:	08f77d63          	bgeu	a4,a5,800062cc <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006236:	100014b7          	lui	s1,0x10001
    8000623a:	47a1                	li	a5,8
    8000623c:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    8000623e:	6609                	lui	a2,0x2
    80006240:	4581                	li	a1,0
    80006242:	00028517          	auipc	a0,0x28
    80006246:	dbe50513          	addi	a0,a0,-578 # 8002e000 <disk>
    8000624a:	ffffb097          	auipc	ra,0xffffb
    8000624e:	a74080e7          	jalr	-1420(ra) # 80000cbe <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006252:	00028717          	auipc	a4,0x28
    80006256:	dae70713          	addi	a4,a4,-594 # 8002e000 <disk>
    8000625a:	00c75793          	srli	a5,a4,0xc
    8000625e:	2781                	sext.w	a5,a5
    80006260:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80006262:	0002a797          	auipc	a5,0x2a
    80006266:	d9e78793          	addi	a5,a5,-610 # 80030000 <disk+0x2000>
    8000626a:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    8000626c:	00028717          	auipc	a4,0x28
    80006270:	e1470713          	addi	a4,a4,-492 # 8002e080 <disk+0x80>
    80006274:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80006276:	00029717          	auipc	a4,0x29
    8000627a:	d8a70713          	addi	a4,a4,-630 # 8002f000 <disk+0x1000>
    8000627e:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80006280:	4705                	li	a4,1
    80006282:	00e78c23          	sb	a4,24(a5)
    80006286:	00e78ca3          	sb	a4,25(a5)
    8000628a:	00e78d23          	sb	a4,26(a5)
    8000628e:	00e78da3          	sb	a4,27(a5)
    80006292:	00e78e23          	sb	a4,28(a5)
    80006296:	00e78ea3          	sb	a4,29(a5)
    8000629a:	00e78f23          	sb	a4,30(a5)
    8000629e:	00e78fa3          	sb	a4,31(a5)
}
    800062a2:	60e2                	ld	ra,24(sp)
    800062a4:	6442                	ld	s0,16(sp)
    800062a6:	64a2                	ld	s1,8(sp)
    800062a8:	6105                	addi	sp,sp,32
    800062aa:	8082                	ret
    panic("could not find virtio disk");
    800062ac:	00002517          	auipc	a0,0x2
    800062b0:	53450513          	addi	a0,a0,1332 # 800087e0 <syscalls+0x368>
    800062b4:	ffffa097          	auipc	ra,0xffffa
    800062b8:	276080e7          	jalr	630(ra) # 8000052a <panic>
    panic("virtio disk has no queue 0");
    800062bc:	00002517          	auipc	a0,0x2
    800062c0:	54450513          	addi	a0,a0,1348 # 80008800 <syscalls+0x388>
    800062c4:	ffffa097          	auipc	ra,0xffffa
    800062c8:	266080e7          	jalr	614(ra) # 8000052a <panic>
    panic("virtio disk max queue too short");
    800062cc:	00002517          	auipc	a0,0x2
    800062d0:	55450513          	addi	a0,a0,1364 # 80008820 <syscalls+0x3a8>
    800062d4:	ffffa097          	auipc	ra,0xffffa
    800062d8:	256080e7          	jalr	598(ra) # 8000052a <panic>

00000000800062dc <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800062dc:	7119                	addi	sp,sp,-128
    800062de:	fc86                	sd	ra,120(sp)
    800062e0:	f8a2                	sd	s0,112(sp)
    800062e2:	f4a6                	sd	s1,104(sp)
    800062e4:	f0ca                	sd	s2,96(sp)
    800062e6:	ecce                	sd	s3,88(sp)
    800062e8:	e8d2                	sd	s4,80(sp)
    800062ea:	e4d6                	sd	s5,72(sp)
    800062ec:	e0da                	sd	s6,64(sp)
    800062ee:	fc5e                	sd	s7,56(sp)
    800062f0:	f862                	sd	s8,48(sp)
    800062f2:	f466                	sd	s9,40(sp)
    800062f4:	f06a                	sd	s10,32(sp)
    800062f6:	ec6e                	sd	s11,24(sp)
    800062f8:	0100                	addi	s0,sp,128
    800062fa:	8aaa                	mv	s5,a0
    800062fc:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800062fe:	00c52c83          	lw	s9,12(a0)
    80006302:	001c9c9b          	slliw	s9,s9,0x1
    80006306:	1c82                	slli	s9,s9,0x20
    80006308:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000630c:	0002a517          	auipc	a0,0x2a
    80006310:	e1c50513          	addi	a0,a0,-484 # 80030128 <disk+0x2128>
    80006314:	ffffb097          	auipc	ra,0xffffb
    80006318:	8ae080e7          	jalr	-1874(ra) # 80000bc2 <acquire>
  for(int i = 0; i < 3; i++){
    8000631c:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000631e:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006320:	00028c17          	auipc	s8,0x28
    80006324:	ce0c0c13          	addi	s8,s8,-800 # 8002e000 <disk>
    80006328:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    8000632a:	4b0d                	li	s6,3
    8000632c:	a0ad                	j	80006396 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    8000632e:	00fc0733          	add	a4,s8,a5
    80006332:	975e                	add	a4,a4,s7
    80006334:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006338:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000633a:	0207c563          	bltz	a5,80006364 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000633e:	2905                	addiw	s2,s2,1
    80006340:	0611                	addi	a2,a2,4
    80006342:	19690d63          	beq	s2,s6,800064dc <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80006346:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006348:	0002a717          	auipc	a4,0x2a
    8000634c:	cd070713          	addi	a4,a4,-816 # 80030018 <disk+0x2018>
    80006350:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006352:	00074683          	lbu	a3,0(a4)
    80006356:	fee1                	bnez	a3,8000632e <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80006358:	2785                	addiw	a5,a5,1
    8000635a:	0705                	addi	a4,a4,1
    8000635c:	fe979be3          	bne	a5,s1,80006352 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80006360:	57fd                	li	a5,-1
    80006362:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006364:	01205d63          	blez	s2,8000637e <virtio_disk_rw+0xa2>
    80006368:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    8000636a:	000a2503          	lw	a0,0(s4)
    8000636e:	00000097          	auipc	ra,0x0
    80006372:	d8e080e7          	jalr	-626(ra) # 800060fc <free_desc>
      for(int j = 0; j < i; j++)
    80006376:	2d85                	addiw	s11,s11,1
    80006378:	0a11                	addi	s4,s4,4
    8000637a:	ffb918e3          	bne	s2,s11,8000636a <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000637e:	0002a597          	auipc	a1,0x2a
    80006382:	daa58593          	addi	a1,a1,-598 # 80030128 <disk+0x2128>
    80006386:	0002a517          	auipc	a0,0x2a
    8000638a:	c9250513          	addi	a0,a0,-878 # 80030018 <disk+0x2018>
    8000638e:	ffffc097          	auipc	ra,0xffffc
    80006392:	d54080e7          	jalr	-684(ra) # 800020e2 <sleep>
  for(int i = 0; i < 3; i++){
    80006396:	f8040a13          	addi	s4,s0,-128
{
    8000639a:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000639c:	894e                	mv	s2,s3
    8000639e:	b765                	j	80006346 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800063a0:	0002a697          	auipc	a3,0x2a
    800063a4:	c606b683          	ld	a3,-928(a3) # 80030000 <disk+0x2000>
    800063a8:	96ba                	add	a3,a3,a4
    800063aa:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800063ae:	00028817          	auipc	a6,0x28
    800063b2:	c5280813          	addi	a6,a6,-942 # 8002e000 <disk>
    800063b6:	0002a697          	auipc	a3,0x2a
    800063ba:	c4a68693          	addi	a3,a3,-950 # 80030000 <disk+0x2000>
    800063be:	6290                	ld	a2,0(a3)
    800063c0:	963a                	add	a2,a2,a4
    800063c2:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    800063c6:	0015e593          	ori	a1,a1,1
    800063ca:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800063ce:	f8842603          	lw	a2,-120(s0)
    800063d2:	628c                	ld	a1,0(a3)
    800063d4:	972e                	add	a4,a4,a1
    800063d6:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800063da:	20050593          	addi	a1,a0,512
    800063de:	0592                	slli	a1,a1,0x4
    800063e0:	95c2                	add	a1,a1,a6
    800063e2:	577d                	li	a4,-1
    800063e4:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800063e8:	00461713          	slli	a4,a2,0x4
    800063ec:	6290                	ld	a2,0(a3)
    800063ee:	963a                	add	a2,a2,a4
    800063f0:	03078793          	addi	a5,a5,48
    800063f4:	97c2                	add	a5,a5,a6
    800063f6:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800063f8:	629c                	ld	a5,0(a3)
    800063fa:	97ba                	add	a5,a5,a4
    800063fc:	4605                	li	a2,1
    800063fe:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006400:	629c                	ld	a5,0(a3)
    80006402:	97ba                	add	a5,a5,a4
    80006404:	4809                	li	a6,2
    80006406:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    8000640a:	629c                	ld	a5,0(a3)
    8000640c:	973e                	add	a4,a4,a5
    8000640e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006412:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80006416:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000641a:	6698                	ld	a4,8(a3)
    8000641c:	00275783          	lhu	a5,2(a4)
    80006420:	8b9d                	andi	a5,a5,7
    80006422:	0786                	slli	a5,a5,0x1
    80006424:	97ba                	add	a5,a5,a4
    80006426:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    8000642a:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000642e:	6698                	ld	a4,8(a3)
    80006430:	00275783          	lhu	a5,2(a4)
    80006434:	2785                	addiw	a5,a5,1
    80006436:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000643a:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000643e:	100017b7          	lui	a5,0x10001
    80006442:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006446:	004aa783          	lw	a5,4(s5)
    8000644a:	02c79163          	bne	a5,a2,8000646c <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    8000644e:	0002a917          	auipc	s2,0x2a
    80006452:	cda90913          	addi	s2,s2,-806 # 80030128 <disk+0x2128>
  while(b->disk == 1) {
    80006456:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006458:	85ca                	mv	a1,s2
    8000645a:	8556                	mv	a0,s5
    8000645c:	ffffc097          	auipc	ra,0xffffc
    80006460:	c86080e7          	jalr	-890(ra) # 800020e2 <sleep>
  while(b->disk == 1) {
    80006464:	004aa783          	lw	a5,4(s5)
    80006468:	fe9788e3          	beq	a5,s1,80006458 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    8000646c:	f8042903          	lw	s2,-128(s0)
    80006470:	20090793          	addi	a5,s2,512
    80006474:	00479713          	slli	a4,a5,0x4
    80006478:	00028797          	auipc	a5,0x28
    8000647c:	b8878793          	addi	a5,a5,-1144 # 8002e000 <disk>
    80006480:	97ba                	add	a5,a5,a4
    80006482:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80006486:	0002a997          	auipc	s3,0x2a
    8000648a:	b7a98993          	addi	s3,s3,-1158 # 80030000 <disk+0x2000>
    8000648e:	00491713          	slli	a4,s2,0x4
    80006492:	0009b783          	ld	a5,0(s3)
    80006496:	97ba                	add	a5,a5,a4
    80006498:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000649c:	854a                	mv	a0,s2
    8000649e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800064a2:	00000097          	auipc	ra,0x0
    800064a6:	c5a080e7          	jalr	-934(ra) # 800060fc <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800064aa:	8885                	andi	s1,s1,1
    800064ac:	f0ed                	bnez	s1,8000648e <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800064ae:	0002a517          	auipc	a0,0x2a
    800064b2:	c7a50513          	addi	a0,a0,-902 # 80030128 <disk+0x2128>
    800064b6:	ffffa097          	auipc	ra,0xffffa
    800064ba:	7c0080e7          	jalr	1984(ra) # 80000c76 <release>
}
    800064be:	70e6                	ld	ra,120(sp)
    800064c0:	7446                	ld	s0,112(sp)
    800064c2:	74a6                	ld	s1,104(sp)
    800064c4:	7906                	ld	s2,96(sp)
    800064c6:	69e6                	ld	s3,88(sp)
    800064c8:	6a46                	ld	s4,80(sp)
    800064ca:	6aa6                	ld	s5,72(sp)
    800064cc:	6b06                	ld	s6,64(sp)
    800064ce:	7be2                	ld	s7,56(sp)
    800064d0:	7c42                	ld	s8,48(sp)
    800064d2:	7ca2                	ld	s9,40(sp)
    800064d4:	7d02                	ld	s10,32(sp)
    800064d6:	6de2                	ld	s11,24(sp)
    800064d8:	6109                	addi	sp,sp,128
    800064da:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800064dc:	f8042503          	lw	a0,-128(s0)
    800064e0:	20050793          	addi	a5,a0,512
    800064e4:	0792                	slli	a5,a5,0x4
  if(write)
    800064e6:	00028817          	auipc	a6,0x28
    800064ea:	b1a80813          	addi	a6,a6,-1254 # 8002e000 <disk>
    800064ee:	00f80733          	add	a4,a6,a5
    800064f2:	01a036b3          	snez	a3,s10
    800064f6:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800064fa:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800064fe:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006502:	7679                	lui	a2,0xffffe
    80006504:	963e                	add	a2,a2,a5
    80006506:	0002a697          	auipc	a3,0x2a
    8000650a:	afa68693          	addi	a3,a3,-1286 # 80030000 <disk+0x2000>
    8000650e:	6298                	ld	a4,0(a3)
    80006510:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006512:	0a878593          	addi	a1,a5,168
    80006516:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006518:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000651a:	6298                	ld	a4,0(a3)
    8000651c:	9732                	add	a4,a4,a2
    8000651e:	45c1                	li	a1,16
    80006520:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006522:	6298                	ld	a4,0(a3)
    80006524:	9732                	add	a4,a4,a2
    80006526:	4585                	li	a1,1
    80006528:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    8000652c:	f8442703          	lw	a4,-124(s0)
    80006530:	628c                	ld	a1,0(a3)
    80006532:	962e                	add	a2,a2,a1
    80006534:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffcd00e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80006538:	0712                	slli	a4,a4,0x4
    8000653a:	6290                	ld	a2,0(a3)
    8000653c:	963a                	add	a2,a2,a4
    8000653e:	058a8593          	addi	a1,s5,88
    80006542:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006544:	6294                	ld	a3,0(a3)
    80006546:	96ba                	add	a3,a3,a4
    80006548:	40000613          	li	a2,1024
    8000654c:	c690                	sw	a2,8(a3)
  if(write)
    8000654e:	e40d19e3          	bnez	s10,800063a0 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006552:	0002a697          	auipc	a3,0x2a
    80006556:	aae6b683          	ld	a3,-1362(a3) # 80030000 <disk+0x2000>
    8000655a:	96ba                	add	a3,a3,a4
    8000655c:	4609                	li	a2,2
    8000655e:	00c69623          	sh	a2,12(a3)
    80006562:	b5b1                	j	800063ae <virtio_disk_rw+0xd2>

0000000080006564 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006564:	1101                	addi	sp,sp,-32
    80006566:	ec06                	sd	ra,24(sp)
    80006568:	e822                	sd	s0,16(sp)
    8000656a:	e426                	sd	s1,8(sp)
    8000656c:	e04a                	sd	s2,0(sp)
    8000656e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006570:	0002a517          	auipc	a0,0x2a
    80006574:	bb850513          	addi	a0,a0,-1096 # 80030128 <disk+0x2128>
    80006578:	ffffa097          	auipc	ra,0xffffa
    8000657c:	64a080e7          	jalr	1610(ra) # 80000bc2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006580:	10001737          	lui	a4,0x10001
    80006584:	533c                	lw	a5,96(a4)
    80006586:	8b8d                	andi	a5,a5,3
    80006588:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000658a:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000658e:	0002a797          	auipc	a5,0x2a
    80006592:	a7278793          	addi	a5,a5,-1422 # 80030000 <disk+0x2000>
    80006596:	6b94                	ld	a3,16(a5)
    80006598:	0207d703          	lhu	a4,32(a5)
    8000659c:	0026d783          	lhu	a5,2(a3)
    800065a0:	06f70163          	beq	a4,a5,80006602 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800065a4:	00028917          	auipc	s2,0x28
    800065a8:	a5c90913          	addi	s2,s2,-1444 # 8002e000 <disk>
    800065ac:	0002a497          	auipc	s1,0x2a
    800065b0:	a5448493          	addi	s1,s1,-1452 # 80030000 <disk+0x2000>
    __sync_synchronize();
    800065b4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800065b8:	6898                	ld	a4,16(s1)
    800065ba:	0204d783          	lhu	a5,32(s1)
    800065be:	8b9d                	andi	a5,a5,7
    800065c0:	078e                	slli	a5,a5,0x3
    800065c2:	97ba                	add	a5,a5,a4
    800065c4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800065c6:	20078713          	addi	a4,a5,512
    800065ca:	0712                	slli	a4,a4,0x4
    800065cc:	974a                	add	a4,a4,s2
    800065ce:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800065d2:	e731                	bnez	a4,8000661e <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800065d4:	20078793          	addi	a5,a5,512
    800065d8:	0792                	slli	a5,a5,0x4
    800065da:	97ca                	add	a5,a5,s2
    800065dc:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800065de:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800065e2:	ffffc097          	auipc	ra,0xffffc
    800065e6:	c8c080e7          	jalr	-884(ra) # 8000226e <wakeup>

    disk.used_idx += 1;
    800065ea:	0204d783          	lhu	a5,32(s1)
    800065ee:	2785                	addiw	a5,a5,1
    800065f0:	17c2                	slli	a5,a5,0x30
    800065f2:	93c1                	srli	a5,a5,0x30
    800065f4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800065f8:	6898                	ld	a4,16(s1)
    800065fa:	00275703          	lhu	a4,2(a4)
    800065fe:	faf71be3          	bne	a4,a5,800065b4 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80006602:	0002a517          	auipc	a0,0x2a
    80006606:	b2650513          	addi	a0,a0,-1242 # 80030128 <disk+0x2128>
    8000660a:	ffffa097          	auipc	ra,0xffffa
    8000660e:	66c080e7          	jalr	1644(ra) # 80000c76 <release>
}
    80006612:	60e2                	ld	ra,24(sp)
    80006614:	6442                	ld	s0,16(sp)
    80006616:	64a2                	ld	s1,8(sp)
    80006618:	6902                	ld	s2,0(sp)
    8000661a:	6105                	addi	sp,sp,32
    8000661c:	8082                	ret
      panic("virtio_disk_intr status");
    8000661e:	00002517          	auipc	a0,0x2
    80006622:	22250513          	addi	a0,a0,546 # 80008840 <syscalls+0x3c8>
    80006626:	ffffa097          	auipc	ra,0xffffa
    8000662a:	f04080e7          	jalr	-252(ra) # 8000052a <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
