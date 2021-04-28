
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
    80000068:	08c78793          	addi	a5,a5,140 # 800060f0 <timervec>
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
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd27ff>
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
    80000122:	400080e7          	jalr	1024(ra) # 8000251e <either_copyin>
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
    800001c6:	f48080e7          	jalr	-184(ra) # 8000210a <sleep>
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
    80000202:	2ca080e7          	jalr	714(ra) # 800024c8 <either_copyout>
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
    800002e2:	296080e7          	jalr	662(ra) # 80002574 <procdump>
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
    80000436:	e64080e7          	jalr	-412(ra) # 80002296 <wakeup>
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
    80000464:	00027797          	auipc	a5,0x27
    80000468:	6b478793          	addi	a5,a5,1716 # 80027b18 <devsw>
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
    80000882:	a18080e7          	jalr	-1512(ra) # 80002296 <wakeup>
    
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
    8000090a:	00002097          	auipc	ra,0x2
    8000090e:	800080e7          	jalr	-2048(ra) # 8000210a <sleep>
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
    800009ea:	0002b797          	auipc	a5,0x2b
    800009ee:	61678793          	addi	a5,a5,1558 # 8002c000 <end>
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
    80000aba:	0002b517          	auipc	a0,0x2b
    80000abe:	54650513          	addi	a0,a0,1350 # 8002c000 <end>
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
    80000eb6:	c02080e7          	jalr	-1022(ra) # 80002ab4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eba:	00005097          	auipc	ra,0x5
    80000ebe:	276080e7          	jalr	630(ra) # 80006130 <plicinithart>
  }

  scheduler();        
    80000ec2:	00001097          	auipc	ra,0x1
    80000ec6:	096080e7          	jalr	150(ra) # 80001f58 <scheduler>
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
    80000f2e:	b62080e7          	jalr	-1182(ra) # 80002a8c <trapinit>
    trapinithart();  // install kernel trap vector
    80000f32:	00002097          	auipc	ra,0x2
    80000f36:	b82080e7          	jalr	-1150(ra) # 80002ab4 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f3a:	00005097          	auipc	ra,0x5
    80000f3e:	1e0080e7          	jalr	480(ra) # 8000611a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f42:	00005097          	auipc	ra,0x5
    80000f46:	1ee080e7          	jalr	494(ra) # 80006130 <plicinithart>
    binit();         // buffer cache
    80000f4a:	00002097          	auipc	ra,0x2
    80000f4e:	392080e7          	jalr	914(ra) # 800032dc <binit>
    iinit();         // inode cache
    80000f52:	00003097          	auipc	ra,0x3
    80000f56:	a24080e7          	jalr	-1500(ra) # 80003976 <iinit>
    fileinit();      // file table
    80000f5a:	00004097          	auipc	ra,0x4
    80000f5e:	9d2080e7          	jalr	-1582(ra) # 8000492c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f62:	00005097          	auipc	ra,0x5
    80000f66:	2f6080e7          	jalr	758(ra) # 80006258 <virtio_disk_init>
    userinit();      // first user process
    80000f6a:	00001097          	auipc	ra,0x1
    80000f6e:	d62080e7          	jalr	-670(ra) # 80001ccc <userinit>
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
    800017e0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd3000>
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
    8000183c:	0001ca17          	auipc	s4,0x1c
    80001840:	094a0a13          	addi	s4,s4,148 # 8001d8d0 <tickslock>
    char *pa = kalloc();
    80001844:	fffff097          	auipc	ra,0xfffff
    80001848:	28e080e7          	jalr	654(ra) # 80000ad2 <kalloc>
    8000184c:	862a                	mv	a2,a0
    if(pa == 0)
    8000184e:	c131                	beqz	a0,80001892 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001850:	416485b3          	sub	a1,s1,s6
    80001854:	858d                	srai	a1,a1,0x3
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
    80001876:	30848493          	addi	s1,s1,776
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
    80001908:	0001c997          	auipc	s3,0x1c
    8000190c:	fc898993          	addi	s3,s3,-56 # 8001d8d0 <tickslock>
      initlock(&p->lock, "proc");
    80001910:	85da                	mv	a1,s6
    80001912:	8526                	mv	a0,s1
    80001914:	fffff097          	auipc	ra,0xfffff
    80001918:	21e080e7          	jalr	542(ra) # 80000b32 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    8000191c:	415487b3          	sub	a5,s1,s5
    80001920:	878d                	srai	a5,a5,0x3
    80001922:	000a3703          	ld	a4,0(s4)
    80001926:	02e787b3          	mul	a5,a5,a4
    8000192a:	2785                	addiw	a5,a5,1
    8000192c:	00d7979b          	slliw	a5,a5,0xd
    80001930:	40f907b3          	sub	a5,s2,a5
    80001934:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001936:	30848493          	addi	s1,s1,776
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
    800019d2:	f127a783          	lw	a5,-238(a5) # 800088e0 <first.1>
    800019d6:	eb89                	bnez	a5,800019e8 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800019d8:	00001097          	auipc	ra,0x1
    800019dc:	0f4080e7          	jalr	244(ra) # 80002acc <usertrapret>
}
    800019e0:	60a2                	ld	ra,8(sp)
    800019e2:	6402                	ld	s0,0(sp)
    800019e4:	0141                	addi	sp,sp,16
    800019e6:	8082                	ret
    first = 0;
    800019e8:	00007797          	auipc	a5,0x7
    800019ec:	ee07ac23          	sw	zero,-264(a5) # 800088e0 <first.1>
    fsinit(ROOTDEV);
    800019f0:	4505                	li	a0,1
    800019f2:	00002097          	auipc	ra,0x2
    800019f6:	f04080e7          	jalr	-252(ra) # 800038f6 <fsinit>
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
    80001a1e:	eca78793          	addi	a5,a5,-310 # 800088e4 <nextpid>
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
    80001b9e:	0001c997          	auipc	s3,0x1c
    80001ba2:	d3298993          	addi	s3,s3,-718 # 8001d8d0 <tickslock>
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
    80001bbe:	30848493          	addi	s1,s1,776
    80001bc2:	ff3492e3          	bne	s1,s3,80001ba6 <allocproc+0x1e>
  return 0;
    80001bc6:	4481                	li	s1,0
    80001bc8:	a075                	j	80001c74 <allocproc+0xec>
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
    80001be0:	2604ac23          	sw	zero,632(s1)
  p->signal_mask_backup = 0;
    80001be4:	2604ae23          	sw	zero,636(s1)
  p->ignore_signals = 0;
    80001be8:	2804a023          	sw	zero,640(s1)
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
    80001c16:	28448513          	addi	a0,s1,644
    80001c1a:	fffff097          	auipc	ra,0xfffff
    80001c1e:	0a4080e7          	jalr	164(ra) # 80000cbe <memset>
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c22:	fffff097          	auipc	ra,0xfffff
    80001c26:	eb0080e7          	jalr	-336(ra) # 80000ad2 <kalloc>
    80001c2a:	892a                	mv	s2,a0
    80001c2c:	eca8                	sd	a0,88(s1)
    80001c2e:	c939                	beqz	a0,80001c84 <allocproc+0xfc>
  if((p->UserTrapFrameBackup = (struct trapframe *)kalloc()) == 0){
    80001c30:	fffff097          	auipc	ra,0xfffff
    80001c34:	ea2080e7          	jalr	-350(ra) # 80000ad2 <kalloc>
    80001c38:	892a                	mv	s2,a0
    80001c3a:	26a4b823          	sd	a0,624(s1)
    80001c3e:	cd39                	beqz	a0,80001c9c <allocproc+0x114>
  p->pagetable = proc_pagetable(p);
    80001c40:	8526                	mv	a0,s1
    80001c42:	00000097          	auipc	ra,0x0
    80001c46:	e00080e7          	jalr	-512(ra) # 80001a42 <proc_pagetable>
    80001c4a:	892a                	mv	s2,a0
    80001c4c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c4e:	c13d                	beqz	a0,80001cb4 <allocproc+0x12c>
  memset(&p->context, 0, sizeof(p->context));
    80001c50:	07000613          	li	a2,112
    80001c54:	4581                	li	a1,0
    80001c56:	06048513          	addi	a0,s1,96
    80001c5a:	fffff097          	auipc	ra,0xfffff
    80001c5e:	064080e7          	jalr	100(ra) # 80000cbe <memset>
  p->context.ra = (uint64)forkret;
    80001c62:	00000797          	auipc	a5,0x0
    80001c66:	d5478793          	addi	a5,a5,-684 # 800019b6 <forkret>
    80001c6a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c6c:	60bc                	ld	a5,64(s1)
    80001c6e:	6705                	lui	a4,0x1
    80001c70:	97ba                	add	a5,a5,a4
    80001c72:	f4bc                	sd	a5,104(s1)
}
    80001c74:	8526                	mv	a0,s1
    80001c76:	70a2                	ld	ra,40(sp)
    80001c78:	7402                	ld	s0,32(sp)
    80001c7a:	64e2                	ld	s1,24(sp)
    80001c7c:	6942                	ld	s2,16(sp)
    80001c7e:	69a2                	ld	s3,8(sp)
    80001c80:	6145                	addi	sp,sp,48
    80001c82:	8082                	ret
    freeproc(p);
    80001c84:	8526                	mv	a0,s1
    80001c86:	00000097          	auipc	ra,0x0
    80001c8a:	eaa080e7          	jalr	-342(ra) # 80001b30 <freeproc>
    release(&p->lock);
    80001c8e:	8526                	mv	a0,s1
    80001c90:	fffff097          	auipc	ra,0xfffff
    80001c94:	fe6080e7          	jalr	-26(ra) # 80000c76 <release>
    return 0;
    80001c98:	84ca                	mv	s1,s2
    80001c9a:	bfe9                	j	80001c74 <allocproc+0xec>
    freeproc(p);
    80001c9c:	8526                	mv	a0,s1
    80001c9e:	00000097          	auipc	ra,0x0
    80001ca2:	e92080e7          	jalr	-366(ra) # 80001b30 <freeproc>
    release(&p->lock);
    80001ca6:	8526                	mv	a0,s1
    80001ca8:	fffff097          	auipc	ra,0xfffff
    80001cac:	fce080e7          	jalr	-50(ra) # 80000c76 <release>
    return 0;
    80001cb0:	84ca                	mv	s1,s2
    80001cb2:	b7c9                	j	80001c74 <allocproc+0xec>
    freeproc(p);
    80001cb4:	8526                	mv	a0,s1
    80001cb6:	00000097          	auipc	ra,0x0
    80001cba:	e7a080e7          	jalr	-390(ra) # 80001b30 <freeproc>
    release(&p->lock);
    80001cbe:	8526                	mv	a0,s1
    80001cc0:	fffff097          	auipc	ra,0xfffff
    80001cc4:	fb6080e7          	jalr	-74(ra) # 80000c76 <release>
    return 0;
    80001cc8:	84ca                	mv	s1,s2
    80001cca:	b76d                	j	80001c74 <allocproc+0xec>

0000000080001ccc <userinit>:
{
    80001ccc:	1101                	addi	sp,sp,-32
    80001cce:	ec06                	sd	ra,24(sp)
    80001cd0:	e822                	sd	s0,16(sp)
    80001cd2:	e426                	sd	s1,8(sp)
    80001cd4:	1000                	addi	s0,sp,32
  p = allocproc();
    80001cd6:	00000097          	auipc	ra,0x0
    80001cda:	eb2080e7          	jalr	-334(ra) # 80001b88 <allocproc>
    80001cde:	84aa                	mv	s1,a0
  initproc = p;
    80001ce0:	00007797          	auipc	a5,0x7
    80001ce4:	34a7b423          	sd	a0,840(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001ce8:	03400613          	li	a2,52
    80001cec:	00007597          	auipc	a1,0x7
    80001cf0:	c0458593          	addi	a1,a1,-1020 # 800088f0 <initcode>
    80001cf4:	6928                	ld	a0,80(a0)
    80001cf6:	fffff097          	auipc	ra,0xfffff
    80001cfa:	63e080e7          	jalr	1598(ra) # 80001334 <uvminit>
  p->sz = PGSIZE;
    80001cfe:	6785                	lui	a5,0x1
    80001d00:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d02:	6cb8                	ld	a4,88(s1)
    80001d04:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d08:	6cb8                	ld	a4,88(s1)
    80001d0a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d0c:	4641                	li	a2,16
    80001d0e:	00006597          	auipc	a1,0x6
    80001d12:	4da58593          	addi	a1,a1,1242 # 800081e8 <digits+0x1a8>
    80001d16:	15848513          	addi	a0,s1,344
    80001d1a:	fffff097          	auipc	ra,0xfffff
    80001d1e:	0f6080e7          	jalr	246(ra) # 80000e10 <safestrcpy>
  p->cwd = namei("/");
    80001d22:	00006517          	auipc	a0,0x6
    80001d26:	4d650513          	addi	a0,a0,1238 # 800081f8 <digits+0x1b8>
    80001d2a:	00002097          	auipc	ra,0x2
    80001d2e:	5fa080e7          	jalr	1530(ra) # 80004324 <namei>
    80001d32:	14a4b823          	sd	a0,336(s1)
  p->pendingSignals = 0;
    80001d36:	1604a423          	sw	zero,360(s1)
  p->signalMask = 0;
    80001d3a:	1604a623          	sw	zero,364(s1)
  for (int i = 0; i < 32; i++) {
    80001d3e:	17048793          	addi	a5,s1,368
    80001d42:	27048713          	addi	a4,s1,624
    p->signalHandlers[i] = SIG_DFL;
    80001d46:	0007b023          	sd	zero,0(a5) # 1000 <_entry-0x7ffff000>
  for (int i = 0; i < 32; i++) {
    80001d4a:	07a1                	addi	a5,a5,8
    80001d4c:	fee79de3          	bne	a5,a4,80001d46 <userinit+0x7a>
  p->ignore_signals = 0;
    80001d50:	2804a023          	sw	zero,640(s1)
  p->stopped = 0;
    80001d54:	2604ac23          	sw	zero,632(s1)
  p->state = RUNNABLE;
    80001d58:	478d                	li	a5,3
    80001d5a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d5c:	8526                	mv	a0,s1
    80001d5e:	fffff097          	auipc	ra,0xfffff
    80001d62:	f18080e7          	jalr	-232(ra) # 80000c76 <release>
}
    80001d66:	60e2                	ld	ra,24(sp)
    80001d68:	6442                	ld	s0,16(sp)
    80001d6a:	64a2                	ld	s1,8(sp)
    80001d6c:	6105                	addi	sp,sp,32
    80001d6e:	8082                	ret

0000000080001d70 <growproc>:
{
    80001d70:	1101                	addi	sp,sp,-32
    80001d72:	ec06                	sd	ra,24(sp)
    80001d74:	e822                	sd	s0,16(sp)
    80001d76:	e426                	sd	s1,8(sp)
    80001d78:	e04a                	sd	s2,0(sp)
    80001d7a:	1000                	addi	s0,sp,32
    80001d7c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d7e:	00000097          	auipc	ra,0x0
    80001d82:	c00080e7          	jalr	-1024(ra) # 8000197e <myproc>
    80001d86:	892a                	mv	s2,a0
  sz = p->sz;
    80001d88:	652c                	ld	a1,72(a0)
    80001d8a:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001d8e:	00904f63          	bgtz	s1,80001dac <growproc+0x3c>
  } else if(n < 0){
    80001d92:	0204cc63          	bltz	s1,80001dca <growproc+0x5a>
  p->sz = sz;
    80001d96:	1602                	slli	a2,a2,0x20
    80001d98:	9201                	srli	a2,a2,0x20
    80001d9a:	04c93423          	sd	a2,72(s2)
  return 0;
    80001d9e:	4501                	li	a0,0
}
    80001da0:	60e2                	ld	ra,24(sp)
    80001da2:	6442                	ld	s0,16(sp)
    80001da4:	64a2                	ld	s1,8(sp)
    80001da6:	6902                	ld	s2,0(sp)
    80001da8:	6105                	addi	sp,sp,32
    80001daa:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001dac:	9e25                	addw	a2,a2,s1
    80001dae:	1602                	slli	a2,a2,0x20
    80001db0:	9201                	srli	a2,a2,0x20
    80001db2:	1582                	slli	a1,a1,0x20
    80001db4:	9181                	srli	a1,a1,0x20
    80001db6:	6928                	ld	a0,80(a0)
    80001db8:	fffff097          	auipc	ra,0xfffff
    80001dbc:	636080e7          	jalr	1590(ra) # 800013ee <uvmalloc>
    80001dc0:	0005061b          	sext.w	a2,a0
    80001dc4:	fa69                	bnez	a2,80001d96 <growproc+0x26>
      return -1;
    80001dc6:	557d                	li	a0,-1
    80001dc8:	bfe1                	j	80001da0 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001dca:	9e25                	addw	a2,a2,s1
    80001dcc:	1602                	slli	a2,a2,0x20
    80001dce:	9201                	srli	a2,a2,0x20
    80001dd0:	1582                	slli	a1,a1,0x20
    80001dd2:	9181                	srli	a1,a1,0x20
    80001dd4:	6928                	ld	a0,80(a0)
    80001dd6:	fffff097          	auipc	ra,0xfffff
    80001dda:	5d0080e7          	jalr	1488(ra) # 800013a6 <uvmdealloc>
    80001dde:	0005061b          	sext.w	a2,a0
    80001de2:	bf55                	j	80001d96 <growproc+0x26>

0000000080001de4 <fork>:
{
    80001de4:	7139                	addi	sp,sp,-64
    80001de6:	fc06                	sd	ra,56(sp)
    80001de8:	f822                	sd	s0,48(sp)
    80001dea:	f426                	sd	s1,40(sp)
    80001dec:	f04a                	sd	s2,32(sp)
    80001dee:	ec4e                	sd	s3,24(sp)
    80001df0:	e852                	sd	s4,16(sp)
    80001df2:	e456                	sd	s5,8(sp)
    80001df4:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001df6:	00000097          	auipc	ra,0x0
    80001dfa:	b88080e7          	jalr	-1144(ra) # 8000197e <myproc>
    80001dfe:	8a2a                	mv	s4,a0
  if((np = allocproc()) == 0){
    80001e00:	00000097          	auipc	ra,0x0
    80001e04:	d88080e7          	jalr	-632(ra) # 80001b88 <allocproc>
    80001e08:	14050663          	beqz	a0,80001f54 <fork+0x170>
    80001e0c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e0e:	048a3603          	ld	a2,72(s4)
    80001e12:	692c                	ld	a1,80(a0)
    80001e14:	050a3503          	ld	a0,80(s4)
    80001e18:	fffff097          	auipc	ra,0xfffff
    80001e1c:	722080e7          	jalr	1826(ra) # 8000153a <uvmcopy>
    80001e20:	06054863          	bltz	a0,80001e90 <fork+0xac>
  np->sz = p->sz;
    80001e24:	048a3783          	ld	a5,72(s4)
    80001e28:	04f9b423          	sd	a5,72(s3)
  np->signalMask = p->signalMask; //inherit signal mask from parent
    80001e2c:	16ca2783          	lw	a5,364(s4)
    80001e30:	16f9a623          	sw	a5,364(s3)
  for (int i = 0; i<32; i++) //inherit signal handlers from parent
    80001e34:	170a0793          	addi	a5,s4,368
    80001e38:	17098713          	addi	a4,s3,368
    80001e3c:	270a0613          	addi	a2,s4,624
    np->signalHandlers[i] = p->signalHandlers[i]; 
    80001e40:	6394                	ld	a3,0(a5)
    80001e42:	e314                	sd	a3,0(a4)
  for (int i = 0; i<32; i++) //inherit signal handlers from parent
    80001e44:	07a1                	addi	a5,a5,8
    80001e46:	0721                	addi	a4,a4,8
    80001e48:	fec79ce3          	bne	a5,a2,80001e40 <fork+0x5c>
  *(np->trapframe) = *(p->trapframe);
    80001e4c:	058a3683          	ld	a3,88(s4)
    80001e50:	87b6                	mv	a5,a3
    80001e52:	0589b703          	ld	a4,88(s3)
    80001e56:	12068693          	addi	a3,a3,288
    80001e5a:	0007b803          	ld	a6,0(a5)
    80001e5e:	6788                	ld	a0,8(a5)
    80001e60:	6b8c                	ld	a1,16(a5)
    80001e62:	6f90                	ld	a2,24(a5)
    80001e64:	01073023          	sd	a6,0(a4)
    80001e68:	e708                	sd	a0,8(a4)
    80001e6a:	eb0c                	sd	a1,16(a4)
    80001e6c:	ef10                	sd	a2,24(a4)
    80001e6e:	02078793          	addi	a5,a5,32
    80001e72:	02070713          	addi	a4,a4,32
    80001e76:	fed792e3          	bne	a5,a3,80001e5a <fork+0x76>
  np->trapframe->a0 = 0;
    80001e7a:	0589b783          	ld	a5,88(s3)
    80001e7e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e82:	0d0a0493          	addi	s1,s4,208
    80001e86:	0d098913          	addi	s2,s3,208
    80001e8a:	150a0a93          	addi	s5,s4,336
    80001e8e:	a00d                	j	80001eb0 <fork+0xcc>
    freeproc(np);
    80001e90:	854e                	mv	a0,s3
    80001e92:	00000097          	auipc	ra,0x0
    80001e96:	c9e080e7          	jalr	-866(ra) # 80001b30 <freeproc>
    release(&np->lock);
    80001e9a:	854e                	mv	a0,s3
    80001e9c:	fffff097          	auipc	ra,0xfffff
    80001ea0:	dda080e7          	jalr	-550(ra) # 80000c76 <release>
    return -1;
    80001ea4:	597d                	li	s2,-1
    80001ea6:	a869                	j	80001f40 <fork+0x15c>
  for(i = 0; i < NOFILE; i++)
    80001ea8:	04a1                	addi	s1,s1,8
    80001eaa:	0921                	addi	s2,s2,8
    80001eac:	01548b63          	beq	s1,s5,80001ec2 <fork+0xde>
    if(p->ofile[i])
    80001eb0:	6088                	ld	a0,0(s1)
    80001eb2:	d97d                	beqz	a0,80001ea8 <fork+0xc4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001eb4:	00003097          	auipc	ra,0x3
    80001eb8:	b0a080e7          	jalr	-1270(ra) # 800049be <filedup>
    80001ebc:	00a93023          	sd	a0,0(s2)
    80001ec0:	b7e5                	j	80001ea8 <fork+0xc4>
  np->cwd = idup(p->cwd);
    80001ec2:	150a3503          	ld	a0,336(s4)
    80001ec6:	00002097          	auipc	ra,0x2
    80001eca:	c6a080e7          	jalr	-918(ra) # 80003b30 <idup>
    80001ece:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ed2:	4641                	li	a2,16
    80001ed4:	158a0593          	addi	a1,s4,344
    80001ed8:	15898513          	addi	a0,s3,344
    80001edc:	fffff097          	auipc	ra,0xfffff
    80001ee0:	f34080e7          	jalr	-204(ra) # 80000e10 <safestrcpy>
  pid = np->pid;
    80001ee4:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001ee8:	854e                	mv	a0,s3
    80001eea:	fffff097          	auipc	ra,0xfffff
    80001eee:	d8c080e7          	jalr	-628(ra) # 80000c76 <release>
  acquire(&wait_lock);
    80001ef2:	0000f497          	auipc	s1,0xf
    80001ef6:	3c648493          	addi	s1,s1,966 # 800112b8 <wait_lock>
    80001efa:	8526                	mv	a0,s1
    80001efc:	fffff097          	auipc	ra,0xfffff
    80001f00:	cc6080e7          	jalr	-826(ra) # 80000bc2 <acquire>
  np->parent = p;
    80001f04:	0349bc23          	sd	s4,56(s3)
  release(&wait_lock);
    80001f08:	8526                	mv	a0,s1
    80001f0a:	fffff097          	auipc	ra,0xfffff
    80001f0e:	d6c080e7          	jalr	-660(ra) # 80000c76 <release>
  acquire(&np->lock);
    80001f12:	854e                	mv	a0,s3
    80001f14:	fffff097          	auipc	ra,0xfffff
    80001f18:	cae080e7          	jalr	-850(ra) # 80000bc2 <acquire>
  np->pendingSignals = 0;
    80001f1c:	1609a423          	sw	zero,360(s3)
  np->signalMask = p->signalMask;
    80001f20:	16ca2783          	lw	a5,364(s4)
    80001f24:	16f9a623          	sw	a5,364(s3)
  np->ignore_signals = 0;
    80001f28:	2809a023          	sw	zero,640(s3)
  np->stopped = 0;
    80001f2c:	2609ac23          	sw	zero,632(s3)
  np->state = RUNNABLE;
    80001f30:	478d                	li	a5,3
    80001f32:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001f36:	854e                	mv	a0,s3
    80001f38:	fffff097          	auipc	ra,0xfffff
    80001f3c:	d3e080e7          	jalr	-706(ra) # 80000c76 <release>
}
    80001f40:	854a                	mv	a0,s2
    80001f42:	70e2                	ld	ra,56(sp)
    80001f44:	7442                	ld	s0,48(sp)
    80001f46:	74a2                	ld	s1,40(sp)
    80001f48:	7902                	ld	s2,32(sp)
    80001f4a:	69e2                	ld	s3,24(sp)
    80001f4c:	6a42                	ld	s4,16(sp)
    80001f4e:	6aa2                	ld	s5,8(sp)
    80001f50:	6121                	addi	sp,sp,64
    80001f52:	8082                	ret
    return -1;
    80001f54:	597d                	li	s2,-1
    80001f56:	b7ed                	j	80001f40 <fork+0x15c>

0000000080001f58 <scheduler>:
{
    80001f58:	7139                	addi	sp,sp,-64
    80001f5a:	fc06                	sd	ra,56(sp)
    80001f5c:	f822                	sd	s0,48(sp)
    80001f5e:	f426                	sd	s1,40(sp)
    80001f60:	f04a                	sd	s2,32(sp)
    80001f62:	ec4e                	sd	s3,24(sp)
    80001f64:	e852                	sd	s4,16(sp)
    80001f66:	e456                	sd	s5,8(sp)
    80001f68:	e05a                	sd	s6,0(sp)
    80001f6a:	0080                	addi	s0,sp,64
    80001f6c:	8792                	mv	a5,tp
  int id = r_tp();
    80001f6e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f70:	00779a93          	slli	s5,a5,0x7
    80001f74:	0000f717          	auipc	a4,0xf
    80001f78:	32c70713          	addi	a4,a4,812 # 800112a0 <pid_lock>
    80001f7c:	9756                	add	a4,a4,s5
    80001f7e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001f82:	0000f717          	auipc	a4,0xf
    80001f86:	35670713          	addi	a4,a4,854 # 800112d8 <cpus+0x8>
    80001f8a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001f8c:	498d                	li	s3,3
        p->state = RUNNING;
    80001f8e:	4b11                	li	s6,4
        c->proc = p;
    80001f90:	079e                	slli	a5,a5,0x7
    80001f92:	0000fa17          	auipc	s4,0xf
    80001f96:	30ea0a13          	addi	s4,s4,782 # 800112a0 <pid_lock>
    80001f9a:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f9c:	0001c917          	auipc	s2,0x1c
    80001fa0:	93490913          	addi	s2,s2,-1740 # 8001d8d0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fa4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fa8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fac:	10079073          	csrw	sstatus,a5
    80001fb0:	0000f497          	auipc	s1,0xf
    80001fb4:	72048493          	addi	s1,s1,1824 # 800116d0 <proc>
    80001fb8:	a811                	j	80001fcc <scheduler+0x74>
      release(&p->lock);
    80001fba:	8526                	mv	a0,s1
    80001fbc:	fffff097          	auipc	ra,0xfffff
    80001fc0:	cba080e7          	jalr	-838(ra) # 80000c76 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fc4:	30848493          	addi	s1,s1,776
    80001fc8:	fd248ee3          	beq	s1,s2,80001fa4 <scheduler+0x4c>
      acquire(&p->lock);
    80001fcc:	8526                	mv	a0,s1
    80001fce:	fffff097          	auipc	ra,0xfffff
    80001fd2:	bf4080e7          	jalr	-1036(ra) # 80000bc2 <acquire>
      if(p->state == RUNNABLE) {
    80001fd6:	4c9c                	lw	a5,24(s1)
    80001fd8:	ff3791e3          	bne	a5,s3,80001fba <scheduler+0x62>
        p->state = RUNNING;
    80001fdc:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001fe0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001fe4:	06048593          	addi	a1,s1,96
    80001fe8:	8556                	mv	a0,s5
    80001fea:	00001097          	auipc	ra,0x1
    80001fee:	a38080e7          	jalr	-1480(ra) # 80002a22 <swtch>
        c->proc = 0;
    80001ff2:	020a3823          	sd	zero,48(s4)
    80001ff6:	b7d1                	j	80001fba <scheduler+0x62>

0000000080001ff8 <sched>:
{
    80001ff8:	7179                	addi	sp,sp,-48
    80001ffa:	f406                	sd	ra,40(sp)
    80001ffc:	f022                	sd	s0,32(sp)
    80001ffe:	ec26                	sd	s1,24(sp)
    80002000:	e84a                	sd	s2,16(sp)
    80002002:	e44e                	sd	s3,8(sp)
    80002004:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002006:	00000097          	auipc	ra,0x0
    8000200a:	978080e7          	jalr	-1672(ra) # 8000197e <myproc>
    8000200e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002010:	fffff097          	auipc	ra,0xfffff
    80002014:	b38080e7          	jalr	-1224(ra) # 80000b48 <holding>
    80002018:	c93d                	beqz	a0,8000208e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000201a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000201c:	2781                	sext.w	a5,a5
    8000201e:	079e                	slli	a5,a5,0x7
    80002020:	0000f717          	auipc	a4,0xf
    80002024:	28070713          	addi	a4,a4,640 # 800112a0 <pid_lock>
    80002028:	97ba                	add	a5,a5,a4
    8000202a:	0a87a703          	lw	a4,168(a5)
    8000202e:	4785                	li	a5,1
    80002030:	06f71763          	bne	a4,a5,8000209e <sched+0xa6>
  if(p->state == RUNNING)
    80002034:	4c98                	lw	a4,24(s1)
    80002036:	4791                	li	a5,4
    80002038:	06f70b63          	beq	a4,a5,800020ae <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000203c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002040:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002042:	efb5                	bnez	a5,800020be <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002044:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002046:	0000f917          	auipc	s2,0xf
    8000204a:	25a90913          	addi	s2,s2,602 # 800112a0 <pid_lock>
    8000204e:	2781                	sext.w	a5,a5
    80002050:	079e                	slli	a5,a5,0x7
    80002052:	97ca                	add	a5,a5,s2
    80002054:	0ac7a983          	lw	s3,172(a5)
    80002058:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000205a:	2781                	sext.w	a5,a5
    8000205c:	079e                	slli	a5,a5,0x7
    8000205e:	0000f597          	auipc	a1,0xf
    80002062:	27a58593          	addi	a1,a1,634 # 800112d8 <cpus+0x8>
    80002066:	95be                	add	a1,a1,a5
    80002068:	06048513          	addi	a0,s1,96
    8000206c:	00001097          	auipc	ra,0x1
    80002070:	9b6080e7          	jalr	-1610(ra) # 80002a22 <swtch>
    80002074:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002076:	2781                	sext.w	a5,a5
    80002078:	079e                	slli	a5,a5,0x7
    8000207a:	97ca                	add	a5,a5,s2
    8000207c:	0b37a623          	sw	s3,172(a5)
}
    80002080:	70a2                	ld	ra,40(sp)
    80002082:	7402                	ld	s0,32(sp)
    80002084:	64e2                	ld	s1,24(sp)
    80002086:	6942                	ld	s2,16(sp)
    80002088:	69a2                	ld	s3,8(sp)
    8000208a:	6145                	addi	sp,sp,48
    8000208c:	8082                	ret
    panic("sched p->lock");
    8000208e:	00006517          	auipc	a0,0x6
    80002092:	17250513          	addi	a0,a0,370 # 80008200 <digits+0x1c0>
    80002096:	ffffe097          	auipc	ra,0xffffe
    8000209a:	494080e7          	jalr	1172(ra) # 8000052a <panic>
    panic("sched locks");
    8000209e:	00006517          	auipc	a0,0x6
    800020a2:	17250513          	addi	a0,a0,370 # 80008210 <digits+0x1d0>
    800020a6:	ffffe097          	auipc	ra,0xffffe
    800020aa:	484080e7          	jalr	1156(ra) # 8000052a <panic>
    panic("sched running");
    800020ae:	00006517          	auipc	a0,0x6
    800020b2:	17250513          	addi	a0,a0,370 # 80008220 <digits+0x1e0>
    800020b6:	ffffe097          	auipc	ra,0xffffe
    800020ba:	474080e7          	jalr	1140(ra) # 8000052a <panic>
    panic("sched interruptible");
    800020be:	00006517          	auipc	a0,0x6
    800020c2:	17250513          	addi	a0,a0,370 # 80008230 <digits+0x1f0>
    800020c6:	ffffe097          	auipc	ra,0xffffe
    800020ca:	464080e7          	jalr	1124(ra) # 8000052a <panic>

00000000800020ce <yield>:
{
    800020ce:	1101                	addi	sp,sp,-32
    800020d0:	ec06                	sd	ra,24(sp)
    800020d2:	e822                	sd	s0,16(sp)
    800020d4:	e426                	sd	s1,8(sp)
    800020d6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800020d8:	00000097          	auipc	ra,0x0
    800020dc:	8a6080e7          	jalr	-1882(ra) # 8000197e <myproc>
    800020e0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	ae0080e7          	jalr	-1312(ra) # 80000bc2 <acquire>
  p->state = RUNNABLE;
    800020ea:	478d                	li	a5,3
    800020ec:	cc9c                	sw	a5,24(s1)
  sched();
    800020ee:	00000097          	auipc	ra,0x0
    800020f2:	f0a080e7          	jalr	-246(ra) # 80001ff8 <sched>
  release(&p->lock);
    800020f6:	8526                	mv	a0,s1
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	b7e080e7          	jalr	-1154(ra) # 80000c76 <release>
}
    80002100:	60e2                	ld	ra,24(sp)
    80002102:	6442                	ld	s0,16(sp)
    80002104:	64a2                	ld	s1,8(sp)
    80002106:	6105                	addi	sp,sp,32
    80002108:	8082                	ret

000000008000210a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000210a:	7179                	addi	sp,sp,-48
    8000210c:	f406                	sd	ra,40(sp)
    8000210e:	f022                	sd	s0,32(sp)
    80002110:	ec26                	sd	s1,24(sp)
    80002112:	e84a                	sd	s2,16(sp)
    80002114:	e44e                	sd	s3,8(sp)
    80002116:	1800                	addi	s0,sp,48
    80002118:	89aa                	mv	s3,a0
    8000211a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000211c:	00000097          	auipc	ra,0x0
    80002120:	862080e7          	jalr	-1950(ra) # 8000197e <myproc>
    80002124:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002126:	fffff097          	auipc	ra,0xfffff
    8000212a:	a9c080e7          	jalr	-1380(ra) # 80000bc2 <acquire>
  release(lk);
    8000212e:	854a                	mv	a0,s2
    80002130:	fffff097          	auipc	ra,0xfffff
    80002134:	b46080e7          	jalr	-1210(ra) # 80000c76 <release>

  // Go to sleep.
  p->chan = chan;
    80002138:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000213c:	4789                	li	a5,2
    8000213e:	cc9c                	sw	a5,24(s1)

  sched();
    80002140:	00000097          	auipc	ra,0x0
    80002144:	eb8080e7          	jalr	-328(ra) # 80001ff8 <sched>

  // Tidy up.
  p->chan = 0;
    80002148:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000214c:	8526                	mv	a0,s1
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	b28080e7          	jalr	-1240(ra) # 80000c76 <release>
  acquire(lk);
    80002156:	854a                	mv	a0,s2
    80002158:	fffff097          	auipc	ra,0xfffff
    8000215c:	a6a080e7          	jalr	-1430(ra) # 80000bc2 <acquire>
}
    80002160:	70a2                	ld	ra,40(sp)
    80002162:	7402                	ld	s0,32(sp)
    80002164:	64e2                	ld	s1,24(sp)
    80002166:	6942                	ld	s2,16(sp)
    80002168:	69a2                	ld	s3,8(sp)
    8000216a:	6145                	addi	sp,sp,48
    8000216c:	8082                	ret

000000008000216e <wait>:
{
    8000216e:	715d                	addi	sp,sp,-80
    80002170:	e486                	sd	ra,72(sp)
    80002172:	e0a2                	sd	s0,64(sp)
    80002174:	fc26                	sd	s1,56(sp)
    80002176:	f84a                	sd	s2,48(sp)
    80002178:	f44e                	sd	s3,40(sp)
    8000217a:	f052                	sd	s4,32(sp)
    8000217c:	ec56                	sd	s5,24(sp)
    8000217e:	e85a                	sd	s6,16(sp)
    80002180:	e45e                	sd	s7,8(sp)
    80002182:	e062                	sd	s8,0(sp)
    80002184:	0880                	addi	s0,sp,80
    80002186:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002188:	fffff097          	auipc	ra,0xfffff
    8000218c:	7f6080e7          	jalr	2038(ra) # 8000197e <myproc>
    80002190:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002192:	0000f517          	auipc	a0,0xf
    80002196:	12650513          	addi	a0,a0,294 # 800112b8 <wait_lock>
    8000219a:	fffff097          	auipc	ra,0xfffff
    8000219e:	a28080e7          	jalr	-1496(ra) # 80000bc2 <acquire>
    havekids = 0;
    800021a2:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800021a4:	4a15                	li	s4,5
        havekids = 1;
    800021a6:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800021a8:	0001b997          	auipc	s3,0x1b
    800021ac:	72898993          	addi	s3,s3,1832 # 8001d8d0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021b0:	0000fc17          	auipc	s8,0xf
    800021b4:	108c0c13          	addi	s8,s8,264 # 800112b8 <wait_lock>
    havekids = 0;
    800021b8:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800021ba:	0000f497          	auipc	s1,0xf
    800021be:	51648493          	addi	s1,s1,1302 # 800116d0 <proc>
    800021c2:	a0bd                	j	80002230 <wait+0xc2>
          pid = np->pid;
    800021c4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800021c8:	000b0e63          	beqz	s6,800021e4 <wait+0x76>
    800021cc:	4691                	li	a3,4
    800021ce:	02c48613          	addi	a2,s1,44
    800021d2:	85da                	mv	a1,s6
    800021d4:	05093503          	ld	a0,80(s2)
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	466080e7          	jalr	1126(ra) # 8000163e <copyout>
    800021e0:	02054563          	bltz	a0,8000220a <wait+0x9c>
          freeproc(np);
    800021e4:	8526                	mv	a0,s1
    800021e6:	00000097          	auipc	ra,0x0
    800021ea:	94a080e7          	jalr	-1718(ra) # 80001b30 <freeproc>
          release(&np->lock);
    800021ee:	8526                	mv	a0,s1
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	a86080e7          	jalr	-1402(ra) # 80000c76 <release>
          release(&wait_lock);
    800021f8:	0000f517          	auipc	a0,0xf
    800021fc:	0c050513          	addi	a0,a0,192 # 800112b8 <wait_lock>
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	a76080e7          	jalr	-1418(ra) # 80000c76 <release>
          return pid;
    80002208:	a09d                	j	8000226e <wait+0x100>
            release(&np->lock);
    8000220a:	8526                	mv	a0,s1
    8000220c:	fffff097          	auipc	ra,0xfffff
    80002210:	a6a080e7          	jalr	-1430(ra) # 80000c76 <release>
            release(&wait_lock);
    80002214:	0000f517          	auipc	a0,0xf
    80002218:	0a450513          	addi	a0,a0,164 # 800112b8 <wait_lock>
    8000221c:	fffff097          	auipc	ra,0xfffff
    80002220:	a5a080e7          	jalr	-1446(ra) # 80000c76 <release>
            return -1;
    80002224:	59fd                	li	s3,-1
    80002226:	a0a1                	j	8000226e <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80002228:	30848493          	addi	s1,s1,776
    8000222c:	03348463          	beq	s1,s3,80002254 <wait+0xe6>
      if(np->parent == p){
    80002230:	7c9c                	ld	a5,56(s1)
    80002232:	ff279be3          	bne	a5,s2,80002228 <wait+0xba>
        acquire(&np->lock);
    80002236:	8526                	mv	a0,s1
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	98a080e7          	jalr	-1654(ra) # 80000bc2 <acquire>
        if(np->state == ZOMBIE){
    80002240:	4c9c                	lw	a5,24(s1)
    80002242:	f94781e3          	beq	a5,s4,800021c4 <wait+0x56>
        release(&np->lock);
    80002246:	8526                	mv	a0,s1
    80002248:	fffff097          	auipc	ra,0xfffff
    8000224c:	a2e080e7          	jalr	-1490(ra) # 80000c76 <release>
        havekids = 1;
    80002250:	8756                	mv	a4,s5
    80002252:	bfd9                	j	80002228 <wait+0xba>
    if(!havekids || p->killed){
    80002254:	c701                	beqz	a4,8000225c <wait+0xee>
    80002256:	02892783          	lw	a5,40(s2)
    8000225a:	c79d                	beqz	a5,80002288 <wait+0x11a>
      release(&wait_lock);
    8000225c:	0000f517          	auipc	a0,0xf
    80002260:	05c50513          	addi	a0,a0,92 # 800112b8 <wait_lock>
    80002264:	fffff097          	auipc	ra,0xfffff
    80002268:	a12080e7          	jalr	-1518(ra) # 80000c76 <release>
      return -1;
    8000226c:	59fd                	li	s3,-1
}
    8000226e:	854e                	mv	a0,s3
    80002270:	60a6                	ld	ra,72(sp)
    80002272:	6406                	ld	s0,64(sp)
    80002274:	74e2                	ld	s1,56(sp)
    80002276:	7942                	ld	s2,48(sp)
    80002278:	79a2                	ld	s3,40(sp)
    8000227a:	7a02                	ld	s4,32(sp)
    8000227c:	6ae2                	ld	s5,24(sp)
    8000227e:	6b42                	ld	s6,16(sp)
    80002280:	6ba2                	ld	s7,8(sp)
    80002282:	6c02                	ld	s8,0(sp)
    80002284:	6161                	addi	sp,sp,80
    80002286:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002288:	85e2                	mv	a1,s8
    8000228a:	854a                	mv	a0,s2
    8000228c:	00000097          	auipc	ra,0x0
    80002290:	e7e080e7          	jalr	-386(ra) # 8000210a <sleep>
    havekids = 0;
    80002294:	b715                	j	800021b8 <wait+0x4a>

0000000080002296 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002296:	7139                	addi	sp,sp,-64
    80002298:	fc06                	sd	ra,56(sp)
    8000229a:	f822                	sd	s0,48(sp)
    8000229c:	f426                	sd	s1,40(sp)
    8000229e:	f04a                	sd	s2,32(sp)
    800022a0:	ec4e                	sd	s3,24(sp)
    800022a2:	e852                	sd	s4,16(sp)
    800022a4:	e456                	sd	s5,8(sp)
    800022a6:	0080                	addi	s0,sp,64
    800022a8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800022aa:	0000f497          	auipc	s1,0xf
    800022ae:	42648493          	addi	s1,s1,1062 # 800116d0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800022b2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800022b4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800022b6:	0001b917          	auipc	s2,0x1b
    800022ba:	61a90913          	addi	s2,s2,1562 # 8001d8d0 <tickslock>
    800022be:	a811                	j	800022d2 <wakeup+0x3c>
      }
      release(&p->lock);
    800022c0:	8526                	mv	a0,s1
    800022c2:	fffff097          	auipc	ra,0xfffff
    800022c6:	9b4080e7          	jalr	-1612(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800022ca:	30848493          	addi	s1,s1,776
    800022ce:	03248663          	beq	s1,s2,800022fa <wakeup+0x64>
    if(p != myproc()){
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	6ac080e7          	jalr	1708(ra) # 8000197e <myproc>
    800022da:	fea488e3          	beq	s1,a0,800022ca <wakeup+0x34>
      acquire(&p->lock);
    800022de:	8526                	mv	a0,s1
    800022e0:	fffff097          	auipc	ra,0xfffff
    800022e4:	8e2080e7          	jalr	-1822(ra) # 80000bc2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800022e8:	4c9c                	lw	a5,24(s1)
    800022ea:	fd379be3          	bne	a5,s3,800022c0 <wakeup+0x2a>
    800022ee:	709c                	ld	a5,32(s1)
    800022f0:	fd4798e3          	bne	a5,s4,800022c0 <wakeup+0x2a>
        p->state = RUNNABLE;
    800022f4:	0154ac23          	sw	s5,24(s1)
    800022f8:	b7e1                	j	800022c0 <wakeup+0x2a>
    }
  }
}
    800022fa:	70e2                	ld	ra,56(sp)
    800022fc:	7442                	ld	s0,48(sp)
    800022fe:	74a2                	ld	s1,40(sp)
    80002300:	7902                	ld	s2,32(sp)
    80002302:	69e2                	ld	s3,24(sp)
    80002304:	6a42                	ld	s4,16(sp)
    80002306:	6aa2                	ld	s5,8(sp)
    80002308:	6121                	addi	sp,sp,64
    8000230a:	8082                	ret

000000008000230c <reparent>:
{
    8000230c:	7179                	addi	sp,sp,-48
    8000230e:	f406                	sd	ra,40(sp)
    80002310:	f022                	sd	s0,32(sp)
    80002312:	ec26                	sd	s1,24(sp)
    80002314:	e84a                	sd	s2,16(sp)
    80002316:	e44e                	sd	s3,8(sp)
    80002318:	e052                	sd	s4,0(sp)
    8000231a:	1800                	addi	s0,sp,48
    8000231c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000231e:	0000f497          	auipc	s1,0xf
    80002322:	3b248493          	addi	s1,s1,946 # 800116d0 <proc>
      pp->parent = initproc;
    80002326:	00007a17          	auipc	s4,0x7
    8000232a:	d02a0a13          	addi	s4,s4,-766 # 80009028 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000232e:	0001b997          	auipc	s3,0x1b
    80002332:	5a298993          	addi	s3,s3,1442 # 8001d8d0 <tickslock>
    80002336:	a029                	j	80002340 <reparent+0x34>
    80002338:	30848493          	addi	s1,s1,776
    8000233c:	01348d63          	beq	s1,s3,80002356 <reparent+0x4a>
    if(pp->parent == p){
    80002340:	7c9c                	ld	a5,56(s1)
    80002342:	ff279be3          	bne	a5,s2,80002338 <reparent+0x2c>
      pp->parent = initproc;
    80002346:	000a3503          	ld	a0,0(s4)
    8000234a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000234c:	00000097          	auipc	ra,0x0
    80002350:	f4a080e7          	jalr	-182(ra) # 80002296 <wakeup>
    80002354:	b7d5                	j	80002338 <reparent+0x2c>
}
    80002356:	70a2                	ld	ra,40(sp)
    80002358:	7402                	ld	s0,32(sp)
    8000235a:	64e2                	ld	s1,24(sp)
    8000235c:	6942                	ld	s2,16(sp)
    8000235e:	69a2                	ld	s3,8(sp)
    80002360:	6a02                	ld	s4,0(sp)
    80002362:	6145                	addi	sp,sp,48
    80002364:	8082                	ret

0000000080002366 <exit>:
{
    80002366:	7179                	addi	sp,sp,-48
    80002368:	f406                	sd	ra,40(sp)
    8000236a:	f022                	sd	s0,32(sp)
    8000236c:	ec26                	sd	s1,24(sp)
    8000236e:	e84a                	sd	s2,16(sp)
    80002370:	e44e                	sd	s3,8(sp)
    80002372:	e052                	sd	s4,0(sp)
    80002374:	1800                	addi	s0,sp,48
    80002376:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002378:	fffff097          	auipc	ra,0xfffff
    8000237c:	606080e7          	jalr	1542(ra) # 8000197e <myproc>
    80002380:	89aa                	mv	s3,a0
  if(p == initproc)
    80002382:	00007797          	auipc	a5,0x7
    80002386:	ca67b783          	ld	a5,-858(a5) # 80009028 <initproc>
    8000238a:	0d050493          	addi	s1,a0,208
    8000238e:	15050913          	addi	s2,a0,336
    80002392:	02a79363          	bne	a5,a0,800023b8 <exit+0x52>
    panic("init exiting");
    80002396:	00006517          	auipc	a0,0x6
    8000239a:	eb250513          	addi	a0,a0,-334 # 80008248 <digits+0x208>
    8000239e:	ffffe097          	auipc	ra,0xffffe
    800023a2:	18c080e7          	jalr	396(ra) # 8000052a <panic>
      fileclose(f);
    800023a6:	00002097          	auipc	ra,0x2
    800023aa:	66a080e7          	jalr	1642(ra) # 80004a10 <fileclose>
      p->ofile[fd] = 0;
    800023ae:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800023b2:	04a1                	addi	s1,s1,8
    800023b4:	01248563          	beq	s1,s2,800023be <exit+0x58>
    if(p->ofile[fd]){
    800023b8:	6088                	ld	a0,0(s1)
    800023ba:	f575                	bnez	a0,800023a6 <exit+0x40>
    800023bc:	bfdd                	j	800023b2 <exit+0x4c>
  begin_op();
    800023be:	00002097          	auipc	ra,0x2
    800023c2:	186080e7          	jalr	390(ra) # 80004544 <begin_op>
  iput(p->cwd);
    800023c6:	1509b503          	ld	a0,336(s3)
    800023ca:	00002097          	auipc	ra,0x2
    800023ce:	95e080e7          	jalr	-1698(ra) # 80003d28 <iput>
  end_op();
    800023d2:	00002097          	auipc	ra,0x2
    800023d6:	1f2080e7          	jalr	498(ra) # 800045c4 <end_op>
  p->cwd = 0;
    800023da:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800023de:	0000f497          	auipc	s1,0xf
    800023e2:	eda48493          	addi	s1,s1,-294 # 800112b8 <wait_lock>
    800023e6:	8526                	mv	a0,s1
    800023e8:	ffffe097          	auipc	ra,0xffffe
    800023ec:	7da080e7          	jalr	2010(ra) # 80000bc2 <acquire>
  reparent(p);
    800023f0:	854e                	mv	a0,s3
    800023f2:	00000097          	auipc	ra,0x0
    800023f6:	f1a080e7          	jalr	-230(ra) # 8000230c <reparent>
  wakeup(p->parent);
    800023fa:	0389b503          	ld	a0,56(s3)
    800023fe:	00000097          	auipc	ra,0x0
    80002402:	e98080e7          	jalr	-360(ra) # 80002296 <wakeup>
  acquire(&p->lock);
    80002406:	854e                	mv	a0,s3
    80002408:	ffffe097          	auipc	ra,0xffffe
    8000240c:	7ba080e7          	jalr	1978(ra) # 80000bc2 <acquire>
  p->xstate = status;
    80002410:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002414:	4795                	li	a5,5
    80002416:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000241a:	8526                	mv	a0,s1
    8000241c:	fffff097          	auipc	ra,0xfffff
    80002420:	85a080e7          	jalr	-1958(ra) # 80000c76 <release>
  sched();
    80002424:	00000097          	auipc	ra,0x0
    80002428:	bd4080e7          	jalr	-1068(ra) # 80001ff8 <sched>
  panic("zombie exit");
    8000242c:	00006517          	auipc	a0,0x6
    80002430:	e2c50513          	addi	a0,a0,-468 # 80008258 <digits+0x218>
    80002434:	ffffe097          	auipc	ra,0xffffe
    80002438:	0f6080e7          	jalr	246(ra) # 8000052a <panic>

000000008000243c <kill>:
int
kill(int pid, int signum)
{
  struct proc *p;

  if(signum >= SIGNALS_SIZE || signum < 0) return -1;
    8000243c:	47fd                	li	a5,31
    8000243e:	08b7e363          	bltu	a5,a1,800024c4 <kill+0x88>
{
    80002442:	7179                	addi	sp,sp,-48
    80002444:	f406                	sd	ra,40(sp)
    80002446:	f022                	sd	s0,32(sp)
    80002448:	ec26                	sd	s1,24(sp)
    8000244a:	e84a                	sd	s2,16(sp)
    8000244c:	e44e                	sd	s3,8(sp)
    8000244e:	e052                	sd	s4,0(sp)
    80002450:	1800                	addi	s0,sp,48
    80002452:	892a                	mv	s2,a0
    80002454:	8a2e                	mv	s4,a1

  for(p = proc; p < &proc[NPROC]; p++){
    80002456:	0000f497          	auipc	s1,0xf
    8000245a:	27a48493          	addi	s1,s1,634 # 800116d0 <proc>
    8000245e:	0001b997          	auipc	s3,0x1b
    80002462:	47298993          	addi	s3,s3,1138 # 8001d8d0 <tickslock>
    acquire(&p->lock);
    80002466:	8526                	mv	a0,s1
    80002468:	ffffe097          	auipc	ra,0xffffe
    8000246c:	75a080e7          	jalr	1882(ra) # 80000bc2 <acquire>
    if(p->pid == pid){
    80002470:	589c                	lw	a5,48(s1)
    80002472:	01278d63          	beq	a5,s2,8000248c <kill+0x50>
      //   p->state = RUNNABLE;
      // }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002476:	8526                	mv	a0,s1
    80002478:	ffffe097          	auipc	ra,0xffffe
    8000247c:	7fe080e7          	jalr	2046(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002480:	30848493          	addi	s1,s1,776
    80002484:	ff3491e3          	bne	s1,s3,80002466 <kill+0x2a>
  }
  return -1;
    80002488:	557d                	li	a0,-1
    8000248a:	a015                	j	800024ae <kill+0x72>
      if(signum == SIGKILL)
    8000248c:	47a5                	li	a5,9
    8000248e:	02fa0863          	beq	s4,a5,800024be <kill+0x82>
      p->pendingSignals |= (1 << signum);
    80002492:	4785                	li	a5,1
    80002494:	0147973b          	sllw	a4,a5,s4
    80002498:	1684a783          	lw	a5,360(s1)
    8000249c:	8fd9                	or	a5,a5,a4
    8000249e:	16f4a423          	sw	a5,360(s1)
      release(&p->lock);
    800024a2:	8526                	mv	a0,s1
    800024a4:	ffffe097          	auipc	ra,0xffffe
    800024a8:	7d2080e7          	jalr	2002(ra) # 80000c76 <release>
      return 0;
    800024ac:	4501                	li	a0,0
}
    800024ae:	70a2                	ld	ra,40(sp)
    800024b0:	7402                	ld	s0,32(sp)
    800024b2:	64e2                	ld	s1,24(sp)
    800024b4:	6942                	ld	s2,16(sp)
    800024b6:	69a2                	ld	s3,8(sp)
    800024b8:	6a02                	ld	s4,0(sp)
    800024ba:	6145                	addi	sp,sp,48
    800024bc:	8082                	ret
        p->killed = 1; 
    800024be:	4785                	li	a5,1
    800024c0:	d49c                	sw	a5,40(s1)
    800024c2:	bfc1                	j	80002492 <kill+0x56>
  if(signum >= SIGNALS_SIZE || signum < 0) return -1;
    800024c4:	557d                	li	a0,-1
}
    800024c6:	8082                	ret

00000000800024c8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800024c8:	7179                	addi	sp,sp,-48
    800024ca:	f406                	sd	ra,40(sp)
    800024cc:	f022                	sd	s0,32(sp)
    800024ce:	ec26                	sd	s1,24(sp)
    800024d0:	e84a                	sd	s2,16(sp)
    800024d2:	e44e                	sd	s3,8(sp)
    800024d4:	e052                	sd	s4,0(sp)
    800024d6:	1800                	addi	s0,sp,48
    800024d8:	84aa                	mv	s1,a0
    800024da:	892e                	mv	s2,a1
    800024dc:	89b2                	mv	s3,a2
    800024de:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024e0:	fffff097          	auipc	ra,0xfffff
    800024e4:	49e080e7          	jalr	1182(ra) # 8000197e <myproc>
  if(user_dst){
    800024e8:	c08d                	beqz	s1,8000250a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800024ea:	86d2                	mv	a3,s4
    800024ec:	864e                	mv	a2,s3
    800024ee:	85ca                	mv	a1,s2
    800024f0:	6928                	ld	a0,80(a0)
    800024f2:	fffff097          	auipc	ra,0xfffff
    800024f6:	14c080e7          	jalr	332(ra) # 8000163e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024fa:	70a2                	ld	ra,40(sp)
    800024fc:	7402                	ld	s0,32(sp)
    800024fe:	64e2                	ld	s1,24(sp)
    80002500:	6942                	ld	s2,16(sp)
    80002502:	69a2                	ld	s3,8(sp)
    80002504:	6a02                	ld	s4,0(sp)
    80002506:	6145                	addi	sp,sp,48
    80002508:	8082                	ret
    memmove((char *)dst, src, len);
    8000250a:	000a061b          	sext.w	a2,s4
    8000250e:	85ce                	mv	a1,s3
    80002510:	854a                	mv	a0,s2
    80002512:	fffff097          	auipc	ra,0xfffff
    80002516:	808080e7          	jalr	-2040(ra) # 80000d1a <memmove>
    return 0;
    8000251a:	8526                	mv	a0,s1
    8000251c:	bff9                	j	800024fa <either_copyout+0x32>

000000008000251e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000251e:	7179                	addi	sp,sp,-48
    80002520:	f406                	sd	ra,40(sp)
    80002522:	f022                	sd	s0,32(sp)
    80002524:	ec26                	sd	s1,24(sp)
    80002526:	e84a                	sd	s2,16(sp)
    80002528:	e44e                	sd	s3,8(sp)
    8000252a:	e052                	sd	s4,0(sp)
    8000252c:	1800                	addi	s0,sp,48
    8000252e:	892a                	mv	s2,a0
    80002530:	84ae                	mv	s1,a1
    80002532:	89b2                	mv	s3,a2
    80002534:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002536:	fffff097          	auipc	ra,0xfffff
    8000253a:	448080e7          	jalr	1096(ra) # 8000197e <myproc>
  if(user_src){
    8000253e:	c08d                	beqz	s1,80002560 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002540:	86d2                	mv	a3,s4
    80002542:	864e                	mv	a2,s3
    80002544:	85ca                	mv	a1,s2
    80002546:	6928                	ld	a0,80(a0)
    80002548:	fffff097          	auipc	ra,0xfffff
    8000254c:	182080e7          	jalr	386(ra) # 800016ca <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002550:	70a2                	ld	ra,40(sp)
    80002552:	7402                	ld	s0,32(sp)
    80002554:	64e2                	ld	s1,24(sp)
    80002556:	6942                	ld	s2,16(sp)
    80002558:	69a2                	ld	s3,8(sp)
    8000255a:	6a02                	ld	s4,0(sp)
    8000255c:	6145                	addi	sp,sp,48
    8000255e:	8082                	ret
    memmove(dst, (char*)src, len);
    80002560:	000a061b          	sext.w	a2,s4
    80002564:	85ce                	mv	a1,s3
    80002566:	854a                	mv	a0,s2
    80002568:	ffffe097          	auipc	ra,0xffffe
    8000256c:	7b2080e7          	jalr	1970(ra) # 80000d1a <memmove>
    return 0;
    80002570:	8526                	mv	a0,s1
    80002572:	bff9                	j	80002550 <either_copyin+0x32>

0000000080002574 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002574:	715d                	addi	sp,sp,-80
    80002576:	e486                	sd	ra,72(sp)
    80002578:	e0a2                	sd	s0,64(sp)
    8000257a:	fc26                	sd	s1,56(sp)
    8000257c:	f84a                	sd	s2,48(sp)
    8000257e:	f44e                	sd	s3,40(sp)
    80002580:	f052                	sd	s4,32(sp)
    80002582:	ec56                	sd	s5,24(sp)
    80002584:	e85a                	sd	s6,16(sp)
    80002586:	e45e                	sd	s7,8(sp)
    80002588:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000258a:	00006517          	auipc	a0,0x6
    8000258e:	b3e50513          	addi	a0,a0,-1218 # 800080c8 <digits+0x88>
    80002592:	ffffe097          	auipc	ra,0xffffe
    80002596:	fe2080e7          	jalr	-30(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000259a:	0000f497          	auipc	s1,0xf
    8000259e:	28e48493          	addi	s1,s1,654 # 80011828 <proc+0x158>
    800025a2:	0001b917          	auipc	s2,0x1b
    800025a6:	48690913          	addi	s2,s2,1158 # 8001da28 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025aa:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800025ac:	00006997          	auipc	s3,0x6
    800025b0:	cbc98993          	addi	s3,s3,-836 # 80008268 <digits+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    800025b4:	00006a97          	auipc	s5,0x6
    800025b8:	cbca8a93          	addi	s5,s5,-836 # 80008270 <digits+0x230>
    printf("\n");
    800025bc:	00006a17          	auipc	s4,0x6
    800025c0:	b0ca0a13          	addi	s4,s4,-1268 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025c4:	00006b97          	auipc	s7,0x6
    800025c8:	db4b8b93          	addi	s7,s7,-588 # 80008378 <states.0>
    800025cc:	a00d                	j	800025ee <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800025ce:	ed86a583          	lw	a1,-296(a3)
    800025d2:	8556                	mv	a0,s5
    800025d4:	ffffe097          	auipc	ra,0xffffe
    800025d8:	fa0080e7          	jalr	-96(ra) # 80000574 <printf>
    printf("\n");
    800025dc:	8552                	mv	a0,s4
    800025de:	ffffe097          	auipc	ra,0xffffe
    800025e2:	f96080e7          	jalr	-106(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025e6:	30848493          	addi	s1,s1,776
    800025ea:	03248263          	beq	s1,s2,8000260e <procdump+0x9a>
    if(p->state == UNUSED)
    800025ee:	86a6                	mv	a3,s1
    800025f0:	ec04a783          	lw	a5,-320(s1)
    800025f4:	dbed                	beqz	a5,800025e6 <procdump+0x72>
      state = "???";
    800025f6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025f8:	fcfb6be3          	bltu	s6,a5,800025ce <procdump+0x5a>
    800025fc:	02079713          	slli	a4,a5,0x20
    80002600:	01d75793          	srli	a5,a4,0x1d
    80002604:	97de                	add	a5,a5,s7
    80002606:	6390                	ld	a2,0(a5)
    80002608:	f279                	bnez	a2,800025ce <procdump+0x5a>
      state = "???";
    8000260a:	864e                	mv	a2,s3
    8000260c:	b7c9                	j	800025ce <procdump+0x5a>
  }
}
    8000260e:	60a6                	ld	ra,72(sp)
    80002610:	6406                	ld	s0,64(sp)
    80002612:	74e2                	ld	s1,56(sp)
    80002614:	7942                	ld	s2,48(sp)
    80002616:	79a2                	ld	s3,40(sp)
    80002618:	7a02                	ld	s4,32(sp)
    8000261a:	6ae2                	ld	s5,24(sp)
    8000261c:	6b42                	ld	s6,16(sp)
    8000261e:	6ba2                	ld	s7,8(sp)
    80002620:	6161                	addi	sp,sp,80
    80002622:	8082                	ret

0000000080002624 <sigprocmask>:

uint
sigprocmask(uint sigmask){
    80002624:	1101                	addi	sp,sp,-32
    80002626:	ec06                	sd	ra,24(sp)
    80002628:	e822                	sd	s0,16(sp)
    8000262a:	e426                	sd	s1,8(sp)
    8000262c:	1000                	addi	s0,sp,32
    8000262e:	84aa                	mv	s1,a0

  struct proc* p = myproc ();
    80002630:	fffff097          	auipc	ra,0xfffff
    80002634:	34e080e7          	jalr	846(ra) # 8000197e <myproc>
    80002638:	87aa                	mv	a5,a0
  uint oldMask = p->signalMask;
    8000263a:	16c52503          	lw	a0,364(a0)
  p->signalMask = sigmask;
    8000263e:	1697a623          	sw	s1,364(a5)
  return oldMask;
}
    80002642:	60e2                	ld	ra,24(sp)
    80002644:	6442                	ld	s0,16(sp)
    80002646:	64a2                	ld	s1,8(sp)
    80002648:	6105                	addi	sp,sp,32
    8000264a:	8082                	ret

000000008000264c <sigaction>:
sigaction(int signum, const struct sigaction *act, struct sigaction *oldact){

  // printf ("signum is: %d\nact adress is: %d\noldact address is: %d\n", signum,act,oldact);
  // Check that signum in the correct range

  if (signum < 0 || signum >= 32)
    8000264c:	0005079b          	sext.w	a5,a0
    80002650:	477d                	li	a4,31
    80002652:	0ef76163          	bltu	a4,a5,80002734 <sigaction+0xe8>
sigaction(int signum, const struct sigaction *act, struct sigaction *oldact){
    80002656:	7139                	addi	sp,sp,-64
    80002658:	fc06                	sd	ra,56(sp)
    8000265a:	f822                	sd	s0,48(sp)
    8000265c:	f426                	sd	s1,40(sp)
    8000265e:	f04a                	sd	s2,32(sp)
    80002660:	ec4e                	sd	s3,24(sp)
    80002662:	e852                	sd	s4,16(sp)
    80002664:	0080                	addi	s0,sp,64
    80002666:	84aa                	mv	s1,a0
    80002668:	8a2e                	mv	s4,a1
    8000266a:	89b2                	mv	s3,a2
    return -1;

  if (signum == SIGSTOP || signum == SIGKILL)
    8000266c:	37dd                	addiw	a5,a5,-9
    8000266e:	9bdd                	andi	a5,a5,-9
    80002670:	2781                	sext.w	a5,a5
    80002672:	c3f9                	beqz	a5,80002738 <sigaction+0xec>
      return -1;

  struct proc* p = myproc ();
    80002674:	fffff097          	auipc	ra,0xfffff
    80002678:	30a080e7          	jalr	778(ra) # 8000197e <myproc>
    8000267c:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000267e:	ffffe097          	auipc	ra,0xffffe
    80002682:	544080e7          	jalr	1348(ra) # 80000bc2 <acquire>

  if (oldact){
    80002686:	04098963          	beqz	s3,800026d8 <sigaction+0x8c>

    struct sigaction oldSig;
    oldSig.sa_handler = p->signalHandlers[signum];
    8000268a:	02e48793          	addi	a5,s1,46
    8000268e:	078e                	slli	a5,a5,0x3
    80002690:	97ca                	add	a5,a5,s2
    80002692:	639c                	ld	a5,0(a5)
    80002694:	fcf43023          	sd	a5,-64(s0)
    oldSig.sigmask = p->maskHandlers[signum];
    80002698:	0a048793          	addi	a5,s1,160
    8000269c:	078a                	slli	a5,a5,0x2
    8000269e:	97ca                	add	a5,a5,s2
    800026a0:	43dc                	lw	a5,4(a5)
    800026a2:	fcf42423          	sw	a5,-56(s0)

    if (copyout(p->pagetable, (uint64) oldact, (char*)&oldSig.sa_handler, sizeof(8)) < 0)
    800026a6:	4691                	li	a3,4
    800026a8:	fc040613          	addi	a2,s0,-64
    800026ac:	85ce                	mv	a1,s3
    800026ae:	05093503          	ld	a0,80(s2)
    800026b2:	fffff097          	auipc	ra,0xfffff
    800026b6:	f8c080e7          	jalr	-116(ra) # 8000163e <copyout>
    800026ba:	06054963          	bltz	a0,8000272c <sigaction+0xe0>
      return -1;

    if (copyout(p->pagetable, (uint64) oldact+8, (char*)&oldSig.sigmask, sizeof(uint)) < 0)
    800026be:	4691                	li	a3,4
    800026c0:	fc840613          	addi	a2,s0,-56
    800026c4:	00898593          	addi	a1,s3,8
    800026c8:	05093503          	ld	a0,80(s2)
    800026cc:	fffff097          	auipc	ra,0xfffff
    800026d0:	f72080e7          	jalr	-142(ra) # 8000163e <copyout>
    800026d4:	04054c63          	bltz	a0,8000272c <sigaction+0xe0>
      return -1;  
  }
  if (act){
    800026d8:	020a0c63          	beqz	s4,80002710 <sigaction+0xc4>
    struct sigaction newSig;
    if(copyin(p->pagetable,(char*)&newSig, (uint64)act, sizeof(struct sigaction))<0)
    800026dc:	46c1                	li	a3,16
    800026de:	8652                	mv	a2,s4
    800026e0:	fc040593          	addi	a1,s0,-64
    800026e4:	05093503          	ld	a0,80(s2)
    800026e8:	fffff097          	auipc	ra,0xfffff
    800026ec:	fe2080e7          	jalr	-30(ra) # 800016ca <copyin>
    800026f0:	04054063          	bltz	a0,80002730 <sigaction+0xe4>
      return -1;

    if(newSig.sigmask <0)
      return -1;

    p->signalHandlers[signum] = newSig.sa_handler;
    800026f4:	02e48793          	addi	a5,s1,46
    800026f8:	078e                	slli	a5,a5,0x3
    800026fa:	97ca                	add	a5,a5,s2
    800026fc:	fc043703          	ld	a4,-64(s0)
    80002700:	e398                	sd	a4,0(a5)

    p->maskHandlers[signum] = newSig.sigmask;
    80002702:	0a048493          	addi	s1,s1,160
    80002706:	048a                	slli	s1,s1,0x2
    80002708:	94ca                	add	s1,s1,s2
    8000270a:	fc842783          	lw	a5,-56(s0)
    8000270e:	c0dc                	sw	a5,4(s1)
  }
  release(&p->lock);
    80002710:	854a                	mv	a0,s2
    80002712:	ffffe097          	auipc	ra,0xffffe
    80002716:	564080e7          	jalr	1380(ra) # 80000c76 <release>
  return 0;
    8000271a:	4501                	li	a0,0
}
    8000271c:	70e2                	ld	ra,56(sp)
    8000271e:	7442                	ld	s0,48(sp)
    80002720:	74a2                	ld	s1,40(sp)
    80002722:	7902                	ld	s2,32(sp)
    80002724:	69e2                	ld	s3,24(sp)
    80002726:	6a42                	ld	s4,16(sp)
    80002728:	6121                	addi	sp,sp,64
    8000272a:	8082                	ret
      return -1;
    8000272c:	557d                	li	a0,-1
    8000272e:	b7fd                	j	8000271c <sigaction+0xd0>
      return -1;
    80002730:	557d                	li	a0,-1
    80002732:	b7ed                	j	8000271c <sigaction+0xd0>
    return -1;
    80002734:	557d                	li	a0,-1
}
    80002736:	8082                	ret
      return -1;
    80002738:	557d                	li	a0,-1
    8000273a:	b7cd                	j	8000271c <sigaction+0xd0>

000000008000273c <sigret>:


void
sigret (void){
    8000273c:	1101                	addi	sp,sp,-32
    8000273e:	ec06                	sd	ra,24(sp)
    80002740:	e822                	sd	s0,16(sp)
    80002742:	e426                	sd	s1,8(sp)
    80002744:	1000                	addi	s0,sp,32
  struct proc* p = myproc();
    80002746:	fffff097          	auipc	ra,0xfffff
    8000274a:	238080e7          	jalr	568(ra) # 8000197e <myproc>
    8000274e:	84aa                	mv	s1,a0
  printf("sig ret\n");
    80002750:	00006517          	auipc	a0,0x6
    80002754:	b3050513          	addi	a0,a0,-1232 # 80008280 <digits+0x240>
    80002758:	ffffe097          	auipc	ra,0xffffe
    8000275c:	e1c080e7          	jalr	-484(ra) # 80000574 <printf>
  memmove(p->trapframe, p->UserTrapFrameBackup, sizeof(struct trapframe));
    80002760:	12000613          	li	a2,288
    80002764:	2704b583          	ld	a1,624(s1)
    80002768:	6ca8                	ld	a0,88(s1)
    8000276a:	ffffe097          	auipc	ra,0xffffe
    8000276e:	5b0080e7          	jalr	1456(ra) # 80000d1a <memmove>
  p->signalMask = p->signal_mask_backup;
    80002772:	27c4a783          	lw	a5,636(s1)
    80002776:	16f4a623          	sw	a5,364(s1)
  p->ignore_signals = 0;
    8000277a:	2804a023          	sw	zero,640(s1)
}
    8000277e:	60e2                	ld	ra,24(sp)
    80002780:	6442                	ld	s0,16(sp)
    80002782:	64a2                	ld	s1,8(sp)
    80002784:	6105                	addi	sp,sp,32
    80002786:	8082                	ret

0000000080002788 <usersignal>:

void usersignal(struct proc *p, int signum){
    80002788:	7179                	addi	sp,sp,-48
    8000278a:	f406                	sd	ra,40(sp)
    8000278c:	f022                	sd	s0,32(sp)
    8000278e:	ec26                	sd	s1,24(sp)
    80002790:	e84a                	sd	s2,16(sp)
    80002792:	e44e                	sd	s3,8(sp)
    80002794:	1800                	addi	s0,sp,48
    80002796:	84aa                	mv	s1,a0
    80002798:	892e                	mv	s2,a1
  printf("here in usersignal\n");
    8000279a:	00006517          	auipc	a0,0x6
    8000279e:	af650513          	addi	a0,a0,-1290 # 80008290 <digits+0x250>
    800027a2:	ffffe097          	auipc	ra,0xffffe
    800027a6:	dd2080e7          	jalr	-558(ra) # 80000574 <printf>
  at the process page table, using local variable (to a user space address) */
  // uint64 act_handler;
  // copyin(p->pagetable, (char*)&sigact, (uint64)p->signalHandlers[signum], sizeof(uint64));

  // Extract sigmask from sigaction, and backup the old signal mask
  p->signal_mask_backup = p->signalMask;
    800027aa:	16c4a783          	lw	a5,364(s1)
    800027ae:	26f4ae23          	sw	a5,636(s1)
  p->signalMask = p->maskHandlers[signum];
    800027b2:	0a090793          	addi	a5,s2,160
    800027b6:	078a                	slli	a5,a5,0x2
    800027b8:	97a6                	add	a5,a5,s1
    800027ba:	43dc                	lw	a5,4(a5)
    800027bc:	16f4a623          	sw	a5,364(s1)

  // indicate that the process is at "signal handling" by turn on a flag
  p->ignore_signals = 1;
    800027c0:	4785                	li	a5,1
    800027c2:	28f4a023          	sw	a5,640(s1)

  // reduce the process trapframe stack pointer by the size of the trapframe
  p->trapframe->sp -= sizeof(struct trapframe);
    800027c6:	6cb8                	ld	a4,88(s1)
    800027c8:	7b1c                	ld	a5,48(a4)
    800027ca:	ee078793          	addi	a5,a5,-288
    800027ce:	fb1c                	sd	a5,48(a4)
  //p->UserTrapFrameBackup = (struct trapframe *)p->trapframe->sp;


  /* use the "copyout" function (from kernel to user), to copy the current process trapframe, 
  to the trapframe backup stack pointer (to reduce its stack pointer at the user space) */
  copyout(p->pagetable, (uint64)p->UserTrapFrameBackup, (char *)p->trapframe, sizeof(struct trapframe));
    800027d0:	12000693          	li	a3,288
    800027d4:	6cb0                	ld	a2,88(s1)
    800027d6:	2704b583          	ld	a1,624(s1)
    800027da:	68a8                	ld	a0,80(s1)
    800027dc:	fffff097          	auipc	ra,0xfffff
    800027e0:	e62080e7          	jalr	-414(ra) # 8000163e <copyout>
  //memmove(p->UserTrapFrameBackup, p->trapframe, sizeof(struct trapframe));

  // Extract handler from signalHandlers, and updated saved user pc to point to signal handler
  printf("The address of the function p->signalHandlers[signum] is =%p\n",p->signalHandlers[signum]);
    800027e4:	00391993          	slli	s3,s2,0x3
    800027e8:	99a6                	add	s3,s3,s1
    800027ea:	1709b583          	ld	a1,368(s3)
    800027ee:	00006517          	auipc	a0,0x6
    800027f2:	aba50513          	addi	a0,a0,-1350 # 800082a8 <digits+0x268>
    800027f6:	ffffe097          	auipc	ra,0xffffe
    800027fa:	d7e080e7          	jalr	-642(ra) # 80000574 <printf>

  p->trapframe->epc = (uint64)p->signalHandlers[signum];
    800027fe:	6cbc                	ld	a5,88(s1)
    80002800:	1709b703          	ld	a4,368(s3)
    80002804:	ef98                	sd	a4,24(a5)

  // Calculate the size of sig_ret
  uint sigret_size = end_ret - start_ret;

  // Reduce stack pointer by size of function sigret and copy out function to user stack
  p->trapframe->sp -= sigret_size;
    80002806:	6cb8                	ld	a4,88(s1)
  uint sigret_size = end_ret - start_ret;
    80002808:	00004617          	auipc	a2,0x4
    8000280c:	9ae60613          	addi	a2,a2,-1618 # 800061b6 <start_ret>
    80002810:	00004697          	auipc	a3,0x4
    80002814:	9ac68693          	addi	a3,a3,-1620 # 800061bc <free_desc>
    80002818:	8e91                	sub	a3,a3,a2
  p->trapframe->sp -= sigret_size;
    8000281a:	1682                	slli	a3,a3,0x20
    8000281c:	9281                	srli	a3,a3,0x20
    8000281e:	7b1c                	ld	a5,48(a4)
    80002820:	8f95                	sub	a5,a5,a3
    80002822:	fb1c                	sd	a5,48(a4)
  copyout(p->pagetable, p->trapframe->sp, (char *)&start_ret, sigret_size);
    80002824:	6cbc                	ld	a5,88(s1)
    80002826:	7b8c                	ld	a1,48(a5)
    80002828:	68a8                	ld	a0,80(s1)
    8000282a:	fffff097          	auipc	ra,0xfffff
    8000282e:	e14080e7          	jalr	-492(ra) # 8000163e <copyout>

  // parameter = signum
  p->trapframe->a0 = signum;
    80002832:	6cbc                	ld	a5,88(s1)
    80002834:	0727b823          	sd	s2,112(a5)

  // update return address so that after handler finishes it will jump to sigret  
  p->trapframe->ra = p->trapframe->sp;
    80002838:	6cbc                	ld	a5,88(s1)
    8000283a:	7b98                	ld	a4,48(a5)
    8000283c:	f798                	sd	a4,40(a5)


}
    8000283e:	70a2                	ld	ra,40(sp)
    80002840:	7402                	ld	s0,32(sp)
    80002842:	64e2                	ld	s1,24(sp)
    80002844:	6942                	ld	s2,16(sp)
    80002846:	69a2                	ld	s3,8(sp)
    80002848:	6145                	addi	sp,sp,48
    8000284a:	8082                	ret

000000008000284c <stopSignal>:

void stopSignal(struct proc *p){
    8000284c:	1101                	addi	sp,sp,-32
    8000284e:	ec06                	sd	ra,24(sp)
    80002850:	e822                	sd	s0,16(sp)
    80002852:	e426                	sd	s1,8(sp)
    80002854:	1000                	addi	s0,sp,32
    80002856:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002858:	ffffe097          	auipc	ra,0xffffe
    8000285c:	36a080e7          	jalr	874(ra) # 80000bc2 <acquire>
  p->stopped = 1;
    80002860:	4785                	li	a5,1
    80002862:	26f4ac23          	sw	a5,632(s1)
  release(&p->lock);
    80002866:	8526                	mv	a0,s1
    80002868:	ffffe097          	auipc	ra,0xffffe
    8000286c:	40e080e7          	jalr	1038(ra) # 80000c76 <release>
}
    80002870:	60e2                	ld	ra,24(sp)
    80002872:	6442                	ld	s0,16(sp)
    80002874:	64a2                	ld	s1,8(sp)
    80002876:	6105                	addi	sp,sp,32
    80002878:	8082                	ret

000000008000287a <contSignal>:

void contSignal(struct proc *p){
    8000287a:	1101                	addi	sp,sp,-32
    8000287c:	ec06                	sd	ra,24(sp)
    8000287e:	e822                	sd	s0,16(sp)
    80002880:	e426                	sd	s1,8(sp)
    80002882:	1000                	addi	s0,sp,32
    80002884:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002886:	ffffe097          	auipc	ra,0xffffe
    8000288a:	33c080e7          	jalr	828(ra) # 80000bc2 <acquire>
  p->stopped = 0;
    8000288e:	2604ac23          	sw	zero,632(s1)
  release(&p->lock);
    80002892:	8526                	mv	a0,s1
    80002894:	ffffe097          	auipc	ra,0xffffe
    80002898:	3e2080e7          	jalr	994(ra) # 80000c76 <release>
}
    8000289c:	60e2                	ld	ra,24(sp)
    8000289e:	6442                	ld	s0,16(sp)
    800028a0:	64a2                	ld	s1,8(sp)
    800028a2:	6105                	addi	sp,sp,32
    800028a4:	8082                	ret

00000000800028a6 <handling_signals>:


void handling_signals(){
    800028a6:	7159                	addi	sp,sp,-112
    800028a8:	f486                	sd	ra,104(sp)
    800028aa:	f0a2                	sd	s0,96(sp)
    800028ac:	eca6                	sd	s1,88(sp)
    800028ae:	e8ca                	sd	s2,80(sp)
    800028b0:	e4ce                	sd	s3,72(sp)
    800028b2:	e0d2                	sd	s4,64(sp)
    800028b4:	fc56                	sd	s5,56(sp)
    800028b6:	f85a                	sd	s6,48(sp)
    800028b8:	f45e                	sd	s7,40(sp)
    800028ba:	f062                	sd	s8,32(sp)
    800028bc:	ec66                	sd	s9,24(sp)
    800028be:	e86a                	sd	s10,16(sp)
    800028c0:	e46e                	sd	s11,8(sp)
    800028c2:	1880                	addi	s0,sp,112
  struct proc *p = myproc();
    800028c4:	fffff097          	auipc	ra,0xfffff
    800028c8:	0ba080e7          	jalr	186(ra) # 8000197e <myproc>

  // ass2
  
  // If first process or all signals are ignored -> return
  if((p == 0) || (p->signalMask == 0xffffffff) || p->ignore_signals) return;
    800028cc:	12050c63          	beqz	a0,80002a04 <handling_signals+0x15e>
    800028d0:	89aa                	mv	s3,a0
    800028d2:	16c52783          	lw	a5,364(a0)
    800028d6:	577d                	li	a4,-1
    800028d8:	12e78663          	beq	a5,a4,80002a04 <handling_signals+0x15e>
    800028dc:	28052483          	lw	s1,640(a0)
    800028e0:	12049263          	bnez	s1,80002a04 <handling_signals+0x15e>

  // Check if stopped and has a pending SIGCONT signal, if none are received, it will yield the CPU.
  if(p->stopped && !(p->signalMask & (1 << SIGSTOP))) {
    800028e4:	27852703          	lw	a4,632(a0)
    800028e8:	c739                	beqz	a4,80002936 <handling_signals+0x90>
    800028ea:	83c5                	srli	a5,a5,0x11
    800028ec:	8b85                	andi	a5,a5,1
    800028ee:	e7a1                	bnez	a5,80002936 <handling_signals+0x90>
    int cont_pend;
    while(1){   
      acquire(&p->lock);
      cont_pend = p->pendingSignals & (1 << SIGCONT);
    800028f0:	00080937          	lui	s2,0x80
      acquire(&p->lock);
    800028f4:	854e                	mv	a0,s3
    800028f6:	ffffe097          	auipc	ra,0xffffe
    800028fa:	2cc080e7          	jalr	716(ra) # 80000bc2 <acquire>
      cont_pend = p->pendingSignals & (1 << SIGCONT);
    800028fe:	1689a703          	lw	a4,360(s3)
    80002902:	012777b3          	and	a5,a4,s2
      if(cont_pend){
    80002906:	2781                	sext.w	a5,a5
    80002908:	eb99                	bnez	a5,8000291e <handling_signals+0x78>
        p->pendingSignals ^= (1 << SIGCONT);
        release(&p->lock);
        break;
      }
      else{
        release(&p->lock);
    8000290a:	854e                	mv	a0,s3
    8000290c:	ffffe097          	auipc	ra,0xffffe
    80002910:	36a080e7          	jalr	874(ra) # 80000c76 <release>
        yield();
    80002914:	fffff097          	auipc	ra,0xfffff
    80002918:	7ba080e7          	jalr	1978(ra) # 800020ce <yield>
      acquire(&p->lock);
    8000291c:	bfe1                	j	800028f4 <handling_signals+0x4e>
        p->stopped = 0;
    8000291e:	2609ac23          	sw	zero,632(s3)
        p->pendingSignals ^= (1 << SIGCONT);
    80002922:	000807b7          	lui	a5,0x80
    80002926:	8f3d                	xor	a4,a4,a5
    80002928:	16e9a423          	sw	a4,360(s3)
        release(&p->lock);
    8000292c:	854e                	mv	a0,s3
    8000292e:	ffffe097          	auipc	ra,0xffffe
    80002932:	348080e7          	jalr	840(ra) # 80000c76 <release>
      }
    }
  }

  for(int sig = 0 ; sig < SIGNALS_SIZE ; sig++){
    80002936:	17098a13          	addi	s4,s3,368
    uint pandSigs = p->pendingSignals;
    uint sigMask = p->signalMask;
    // check if panding for the i'th signal and it's not blocked.
    if( (pandSigs & (1 << sig)) && !(sigMask & (1 << sig)) ){
    8000293a:	4b05                	li	s6,1
      printf("signal %d got panding and not blocked\n", sig);
    8000293c:	00006b97          	auipc	s7,0x6
    80002940:	9acb8b93          	addi	s7,s7,-1620 # 800082e8 <digits+0x2a8>
            break;
        }
        //turning bit of pending singal off
        p->pendingSignals ^= (1 << sig); 
      }
      else if (p->signalHandlers[sig] != (void*)SIG_IGN){
    80002944:	4c05                	li	s8,1
        printf("sig == %d and user handler\n", sig);
    80002946:	00006c97          	auipc	s9,0x6
    8000294a:	9eac8c93          	addi	s9,s9,-1558 # 80008330 <digits+0x2f0>
        switch(sig)
    8000294e:	4dc5                	li	s11,17
    80002950:	4d4d                	li	s10,19
  for(int sig = 0 ; sig < SIGNALS_SIZE ; sig++){
    80002952:	02000a93          	li	s5,32
    80002956:	a0a9                	j	800029a0 <handling_signals+0xfa>
        printf("sig == %d and default handler\n", sig);
    80002958:	85a6                	mv	a1,s1
    8000295a:	00006517          	auipc	a0,0x6
    8000295e:	9b650513          	addi	a0,a0,-1610 # 80008310 <digits+0x2d0>
    80002962:	ffffe097          	auipc	ra,0xffffe
    80002966:	c12080e7          	jalr	-1006(ra) # 80000574 <printf>
        switch(sig)
    8000296a:	01b48c63          	beq	s1,s11,80002982 <handling_signals+0xdc>
    8000296e:	09a48563          	beq	s1,s10,800029f8 <handling_signals+0x152>
            kill(p->pid, SIGKILL);
    80002972:	45a5                	li	a1,9
    80002974:	0309a503          	lw	a0,48(s3)
    80002978:	00000097          	auipc	ra,0x0
    8000297c:	ac4080e7          	jalr	-1340(ra) # 8000243c <kill>
            break;
    80002980:	a031                	j	8000298c <handling_signals+0xe6>
            stopSignal(p);
    80002982:	854e                	mv	a0,s3
    80002984:	00000097          	auipc	ra,0x0
    80002988:	ec8080e7          	jalr	-312(ra) # 8000284c <stopSignal>
        p->pendingSignals ^= (1 << sig); 
    8000298c:	1689a783          	lw	a5,360(s3)
    80002990:	0127c933          	xor	s2,a5,s2
    80002994:	1729a423          	sw	s2,360(s3)
  for(int sig = 0 ; sig < SIGNALS_SIZE ; sig++){
    80002998:	2485                	addiw	s1,s1,1
    8000299a:	0a21                	addi	s4,s4,8
    8000299c:	07548463          	beq	s1,s5,80002a04 <handling_signals+0x15e>
    if( (pandSigs & (1 << sig)) && !(sigMask & (1 << sig)) ){
    800029a0:	009b193b          	sllw	s2,s6,s1
    800029a4:	1689a783          	lw	a5,360(s3)
    800029a8:	0127f7b3          	and	a5,a5,s2
    800029ac:	2781                	sext.w	a5,a5
    800029ae:	d7ed                	beqz	a5,80002998 <handling_signals+0xf2>
    800029b0:	16c9a783          	lw	a5,364(s3)
    800029b4:	0127f7b3          	and	a5,a5,s2
    800029b8:	2781                	sext.w	a5,a5
    800029ba:	fff9                	bnez	a5,80002998 <handling_signals+0xf2>
      printf("signal %d got panding and not blocked\n", sig);
    800029bc:	85a6                	mv	a1,s1
    800029be:	855e                	mv	a0,s7
    800029c0:	ffffe097          	auipc	ra,0xffffe
    800029c4:	bb4080e7          	jalr	-1100(ra) # 80000574 <printf>
      if(p->signalHandlers[sig] == (void*)SIG_DFL){
    800029c8:	000a3783          	ld	a5,0(s4)
    800029cc:	d7d1                	beqz	a5,80002958 <handling_signals+0xb2>
      else if (p->signalHandlers[sig] != (void*)SIG_IGN){
    800029ce:	fd8785e3          	beq	a5,s8,80002998 <handling_signals+0xf2>
        printf("sig == %d and user handler\n", sig);
    800029d2:	85a6                	mv	a1,s1
    800029d4:	8566                	mv	a0,s9
    800029d6:	ffffe097          	auipc	ra,0xffffe
    800029da:	b9e080e7          	jalr	-1122(ra) # 80000574 <printf>
        usersignal(p, sig);
    800029de:	85a6                	mv	a1,s1
    800029e0:	854e                	mv	a0,s3
    800029e2:	00000097          	auipc	ra,0x0
    800029e6:	da6080e7          	jalr	-602(ra) # 80002788 <usersignal>
        p->pendingSignals ^= (1 << sig); //turning bit off
    800029ea:	1689a783          	lw	a5,360(s3)
    800029ee:	0127c933          	xor	s2,a5,s2
    800029f2:	1729a423          	sw	s2,360(s3)
    800029f6:	b74d                	j	80002998 <handling_signals+0xf2>
            contSignal(p);
    800029f8:	854e                	mv	a0,s3
    800029fa:	00000097          	auipc	ra,0x0
    800029fe:	e80080e7          	jalr	-384(ra) # 8000287a <contSignal>
            break;
    80002a02:	b769                	j	8000298c <handling_signals+0xe6>
      }
    }
  }
}
    80002a04:	70a6                	ld	ra,104(sp)
    80002a06:	7406                	ld	s0,96(sp)
    80002a08:	64e6                	ld	s1,88(sp)
    80002a0a:	6946                	ld	s2,80(sp)
    80002a0c:	69a6                	ld	s3,72(sp)
    80002a0e:	6a06                	ld	s4,64(sp)
    80002a10:	7ae2                	ld	s5,56(sp)
    80002a12:	7b42                	ld	s6,48(sp)
    80002a14:	7ba2                	ld	s7,40(sp)
    80002a16:	7c02                	ld	s8,32(sp)
    80002a18:	6ce2                	ld	s9,24(sp)
    80002a1a:	6d42                	ld	s10,16(sp)
    80002a1c:	6da2                	ld	s11,8(sp)
    80002a1e:	6165                	addi	sp,sp,112
    80002a20:	8082                	ret

0000000080002a22 <swtch>:
    80002a22:	00153023          	sd	ra,0(a0)
    80002a26:	00253423          	sd	sp,8(a0)
    80002a2a:	e900                	sd	s0,16(a0)
    80002a2c:	ed04                	sd	s1,24(a0)
    80002a2e:	03253023          	sd	s2,32(a0)
    80002a32:	03353423          	sd	s3,40(a0)
    80002a36:	03453823          	sd	s4,48(a0)
    80002a3a:	03553c23          	sd	s5,56(a0)
    80002a3e:	05653023          	sd	s6,64(a0)
    80002a42:	05753423          	sd	s7,72(a0)
    80002a46:	05853823          	sd	s8,80(a0)
    80002a4a:	05953c23          	sd	s9,88(a0)
    80002a4e:	07a53023          	sd	s10,96(a0)
    80002a52:	07b53423          	sd	s11,104(a0)
    80002a56:	0005b083          	ld	ra,0(a1)
    80002a5a:	0085b103          	ld	sp,8(a1)
    80002a5e:	6980                	ld	s0,16(a1)
    80002a60:	6d84                	ld	s1,24(a1)
    80002a62:	0205b903          	ld	s2,32(a1)
    80002a66:	0285b983          	ld	s3,40(a1)
    80002a6a:	0305ba03          	ld	s4,48(a1)
    80002a6e:	0385ba83          	ld	s5,56(a1)
    80002a72:	0405bb03          	ld	s6,64(a1)
    80002a76:	0485bb83          	ld	s7,72(a1)
    80002a7a:	0505bc03          	ld	s8,80(a1)
    80002a7e:	0585bc83          	ld	s9,88(a1)
    80002a82:	0605bd03          	ld	s10,96(a1)
    80002a86:	0685bd83          	ld	s11,104(a1)
    80002a8a:	8082                	ret

0000000080002a8c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002a8c:	1141                	addi	sp,sp,-16
    80002a8e:	e406                	sd	ra,8(sp)
    80002a90:	e022                	sd	s0,0(sp)
    80002a92:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002a94:	00006597          	auipc	a1,0x6
    80002a98:	91458593          	addi	a1,a1,-1772 # 800083a8 <states.0+0x30>
    80002a9c:	0001b517          	auipc	a0,0x1b
    80002aa0:	e3450513          	addi	a0,a0,-460 # 8001d8d0 <tickslock>
    80002aa4:	ffffe097          	auipc	ra,0xffffe
    80002aa8:	08e080e7          	jalr	142(ra) # 80000b32 <initlock>
}
    80002aac:	60a2                	ld	ra,8(sp)
    80002aae:	6402                	ld	s0,0(sp)
    80002ab0:	0141                	addi	sp,sp,16
    80002ab2:	8082                	ret

0000000080002ab4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002ab4:	1141                	addi	sp,sp,-16
    80002ab6:	e422                	sd	s0,8(sp)
    80002ab8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002aba:	00003797          	auipc	a5,0x3
    80002abe:	5a678793          	addi	a5,a5,1446 # 80006060 <kernelvec>
    80002ac2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002ac6:	6422                	ld	s0,8(sp)
    80002ac8:	0141                	addi	sp,sp,16
    80002aca:	8082                	ret

0000000080002acc <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002acc:	7179                	addi	sp,sp,-48
    80002ace:	f406                	sd	ra,40(sp)
    80002ad0:	f022                	sd	s0,32(sp)
    80002ad2:	ec26                	sd	s1,24(sp)
    80002ad4:	e84a                	sd	s2,16(sp)
    80002ad6:	e44e                	sd	s3,8(sp)
    80002ad8:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002ada:	fffff097          	auipc	ra,0xfffff
    80002ade:	ea4080e7          	jalr	-348(ra) # 8000197e <myproc>
    80002ae2:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ae4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002ae8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002aea:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002aee:	00004997          	auipc	s3,0x4
    80002af2:	51298993          	addi	s3,s3,1298 # 80007000 <_trampoline>
    80002af6:	00004797          	auipc	a5,0x4
    80002afa:	50a78793          	addi	a5,a5,1290 # 80007000 <_trampoline>
    80002afe:	413787b3          	sub	a5,a5,s3
    80002b02:	04000937          	lui	s2,0x4000
    80002b06:	197d                	addi	s2,s2,-1
    80002b08:	0932                	slli	s2,s2,0xc
    80002b0a:	97ca                	add	a5,a5,s2
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b0c:	10579073          	csrw	stvec,a5

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002b10:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002b12:	18002773          	csrr	a4,satp
    80002b16:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002b18:	6d38                	ld	a4,88(a0)
    80002b1a:	613c                	ld	a5,64(a0)
    80002b1c:	6685                	lui	a3,0x1
    80002b1e:	97b6                	add	a5,a5,a3
    80002b20:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002b22:	6d3c                	ld	a5,88(a0)
    80002b24:	00000717          	auipc	a4,0x0
    80002b28:	14870713          	addi	a4,a4,328 # 80002c6c <usertrap>
    80002b2c:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002b2e:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002b30:	8712                	mv	a4,tp
    80002b32:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b34:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002b38:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002b3c:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b40:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002b44:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002b46:	6f9c                	ld	a5,24(a5)
    80002b48:	14179073          	csrw	sepc,a5

  handling_signals();
    80002b4c:	00000097          	auipc	ra,0x0
    80002b50:	d5a080e7          	jalr	-678(ra) # 800028a6 <handling_signals>

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002b54:	68ac                	ld	a1,80(s1)
    80002b56:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002b58:	00004797          	auipc	a5,0x4
    80002b5c:	53878793          	addi	a5,a5,1336 # 80007090 <userret>
    80002b60:	413787b3          	sub	a5,a5,s3
    80002b64:	993e                	add	s2,s2,a5
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002b66:	57fd                	li	a5,-1
    80002b68:	17fe                	slli	a5,a5,0x3f
    80002b6a:	8ddd                	or	a1,a1,a5
    80002b6c:	02000537          	lui	a0,0x2000
    80002b70:	157d                	addi	a0,a0,-1
    80002b72:	0536                	slli	a0,a0,0xd
    80002b74:	9902                	jalr	s2
}
    80002b76:	70a2                	ld	ra,40(sp)
    80002b78:	7402                	ld	s0,32(sp)
    80002b7a:	64e2                	ld	s1,24(sp)
    80002b7c:	6942                	ld	s2,16(sp)
    80002b7e:	69a2                	ld	s3,8(sp)
    80002b80:	6145                	addi	sp,sp,48
    80002b82:	8082                	ret

0000000080002b84 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002b84:	1101                	addi	sp,sp,-32
    80002b86:	ec06                	sd	ra,24(sp)
    80002b88:	e822                	sd	s0,16(sp)
    80002b8a:	e426                	sd	s1,8(sp)
    80002b8c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002b8e:	0001b497          	auipc	s1,0x1b
    80002b92:	d4248493          	addi	s1,s1,-702 # 8001d8d0 <tickslock>
    80002b96:	8526                	mv	a0,s1
    80002b98:	ffffe097          	auipc	ra,0xffffe
    80002b9c:	02a080e7          	jalr	42(ra) # 80000bc2 <acquire>
  ticks++;
    80002ba0:	00006517          	auipc	a0,0x6
    80002ba4:	49050513          	addi	a0,a0,1168 # 80009030 <ticks>
    80002ba8:	411c                	lw	a5,0(a0)
    80002baa:	2785                	addiw	a5,a5,1
    80002bac:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002bae:	fffff097          	auipc	ra,0xfffff
    80002bb2:	6e8080e7          	jalr	1768(ra) # 80002296 <wakeup>
  release(&tickslock);
    80002bb6:	8526                	mv	a0,s1
    80002bb8:	ffffe097          	auipc	ra,0xffffe
    80002bbc:	0be080e7          	jalr	190(ra) # 80000c76 <release>
}
    80002bc0:	60e2                	ld	ra,24(sp)
    80002bc2:	6442                	ld	s0,16(sp)
    80002bc4:	64a2                	ld	s1,8(sp)
    80002bc6:	6105                	addi	sp,sp,32
    80002bc8:	8082                	ret

0000000080002bca <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002bca:	1101                	addi	sp,sp,-32
    80002bcc:	ec06                	sd	ra,24(sp)
    80002bce:	e822                	sd	s0,16(sp)
    80002bd0:	e426                	sd	s1,8(sp)
    80002bd2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002bd4:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002bd8:	00074d63          	bltz	a4,80002bf2 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002bdc:	57fd                	li	a5,-1
    80002bde:	17fe                	slli	a5,a5,0x3f
    80002be0:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002be2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002be4:	06f70363          	beq	a4,a5,80002c4a <devintr+0x80>
  }
}
    80002be8:	60e2                	ld	ra,24(sp)
    80002bea:	6442                	ld	s0,16(sp)
    80002bec:	64a2                	ld	s1,8(sp)
    80002bee:	6105                	addi	sp,sp,32
    80002bf0:	8082                	ret
     (scause & 0xff) == 9){
    80002bf2:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002bf6:	46a5                	li	a3,9
    80002bf8:	fed792e3          	bne	a5,a3,80002bdc <devintr+0x12>
    int irq = plic_claim();
    80002bfc:	00003097          	auipc	ra,0x3
    80002c00:	56c080e7          	jalr	1388(ra) # 80006168 <plic_claim>
    80002c04:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002c06:	47a9                	li	a5,10
    80002c08:	02f50763          	beq	a0,a5,80002c36 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002c0c:	4785                	li	a5,1
    80002c0e:	02f50963          	beq	a0,a5,80002c40 <devintr+0x76>
    return 1;
    80002c12:	4505                	li	a0,1
    } else if(irq){
    80002c14:	d8f1                	beqz	s1,80002be8 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002c16:	85a6                	mv	a1,s1
    80002c18:	00005517          	auipc	a0,0x5
    80002c1c:	79850513          	addi	a0,a0,1944 # 800083b0 <states.0+0x38>
    80002c20:	ffffe097          	auipc	ra,0xffffe
    80002c24:	954080e7          	jalr	-1708(ra) # 80000574 <printf>
      plic_complete(irq);
    80002c28:	8526                	mv	a0,s1
    80002c2a:	00003097          	auipc	ra,0x3
    80002c2e:	562080e7          	jalr	1378(ra) # 8000618c <plic_complete>
    return 1;
    80002c32:	4505                	li	a0,1
    80002c34:	bf55                	j	80002be8 <devintr+0x1e>
      uartintr();
    80002c36:	ffffe097          	auipc	ra,0xffffe
    80002c3a:	d50080e7          	jalr	-688(ra) # 80000986 <uartintr>
    80002c3e:	b7ed                	j	80002c28 <devintr+0x5e>
      virtio_disk_intr();
    80002c40:	00004097          	auipc	ra,0x4
    80002c44:	9e4080e7          	jalr	-1564(ra) # 80006624 <virtio_disk_intr>
    80002c48:	b7c5                	j	80002c28 <devintr+0x5e>
    if(cpuid() == 0){
    80002c4a:	fffff097          	auipc	ra,0xfffff
    80002c4e:	d08080e7          	jalr	-760(ra) # 80001952 <cpuid>
    80002c52:	c901                	beqz	a0,80002c62 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002c54:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002c58:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002c5a:	14479073          	csrw	sip,a5
    return 2;
    80002c5e:	4509                	li	a0,2
    80002c60:	b761                	j	80002be8 <devintr+0x1e>
      clockintr();
    80002c62:	00000097          	auipc	ra,0x0
    80002c66:	f22080e7          	jalr	-222(ra) # 80002b84 <clockintr>
    80002c6a:	b7ed                	j	80002c54 <devintr+0x8a>

0000000080002c6c <usertrap>:
{
    80002c6c:	1101                	addi	sp,sp,-32
    80002c6e:	ec06                	sd	ra,24(sp)
    80002c70:	e822                	sd	s0,16(sp)
    80002c72:	e426                	sd	s1,8(sp)
    80002c74:	e04a                	sd	s2,0(sp)
    80002c76:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c78:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002c7c:	1007f793          	andi	a5,a5,256
    80002c80:	e3ad                	bnez	a5,80002ce2 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c82:	00003797          	auipc	a5,0x3
    80002c86:	3de78793          	addi	a5,a5,990 # 80006060 <kernelvec>
    80002c8a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002c8e:	fffff097          	auipc	ra,0xfffff
    80002c92:	cf0080e7          	jalr	-784(ra) # 8000197e <myproc>
    80002c96:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002c98:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c9a:	14102773          	csrr	a4,sepc
    80002c9e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ca0:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002ca4:	47a1                	li	a5,8
    80002ca6:	04f71c63          	bne	a4,a5,80002cfe <usertrap+0x92>
    if(p->killed)
    80002caa:	551c                	lw	a5,40(a0)
    80002cac:	e3b9                	bnez	a5,80002cf2 <usertrap+0x86>
    p->trapframe->epc += 4;
    80002cae:	6cb8                	ld	a4,88(s1)
    80002cb0:	6f1c                	ld	a5,24(a4)
    80002cb2:	0791                	addi	a5,a5,4
    80002cb4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cb6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002cba:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002cbe:	10079073          	csrw	sstatus,a5
    syscall();
    80002cc2:	00000097          	auipc	ra,0x0
    80002cc6:	2e0080e7          	jalr	736(ra) # 80002fa2 <syscall>
  if(p->killed)
    80002cca:	549c                	lw	a5,40(s1)
    80002ccc:	ebc1                	bnez	a5,80002d5c <usertrap+0xf0>
  usertrapret();
    80002cce:	00000097          	auipc	ra,0x0
    80002cd2:	dfe080e7          	jalr	-514(ra) # 80002acc <usertrapret>
}
    80002cd6:	60e2                	ld	ra,24(sp)
    80002cd8:	6442                	ld	s0,16(sp)
    80002cda:	64a2                	ld	s1,8(sp)
    80002cdc:	6902                	ld	s2,0(sp)
    80002cde:	6105                	addi	sp,sp,32
    80002ce0:	8082                	ret
    panic("usertrap: not from user mode");
    80002ce2:	00005517          	auipc	a0,0x5
    80002ce6:	6ee50513          	addi	a0,a0,1774 # 800083d0 <states.0+0x58>
    80002cea:	ffffe097          	auipc	ra,0xffffe
    80002cee:	840080e7          	jalr	-1984(ra) # 8000052a <panic>
      exit(-1);
    80002cf2:	557d                	li	a0,-1
    80002cf4:	fffff097          	auipc	ra,0xfffff
    80002cf8:	672080e7          	jalr	1650(ra) # 80002366 <exit>
    80002cfc:	bf4d                	j	80002cae <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002cfe:	00000097          	auipc	ra,0x0
    80002d02:	ecc080e7          	jalr	-308(ra) # 80002bca <devintr>
    80002d06:	892a                	mv	s2,a0
    80002d08:	c501                	beqz	a0,80002d10 <usertrap+0xa4>
  if(p->killed)
    80002d0a:	549c                	lw	a5,40(s1)
    80002d0c:	c3a1                	beqz	a5,80002d4c <usertrap+0xe0>
    80002d0e:	a815                	j	80002d42 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d10:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002d14:	5890                	lw	a2,48(s1)
    80002d16:	00005517          	auipc	a0,0x5
    80002d1a:	6da50513          	addi	a0,a0,1754 # 800083f0 <states.0+0x78>
    80002d1e:	ffffe097          	auipc	ra,0xffffe
    80002d22:	856080e7          	jalr	-1962(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d26:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d2a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d2e:	00005517          	auipc	a0,0x5
    80002d32:	6f250513          	addi	a0,a0,1778 # 80008420 <states.0+0xa8>
    80002d36:	ffffe097          	auipc	ra,0xffffe
    80002d3a:	83e080e7          	jalr	-1986(ra) # 80000574 <printf>
    p->killed = 1;
    80002d3e:	4785                	li	a5,1
    80002d40:	d49c                	sw	a5,40(s1)
    exit(-1);
    80002d42:	557d                	li	a0,-1
    80002d44:	fffff097          	auipc	ra,0xfffff
    80002d48:	622080e7          	jalr	1570(ra) # 80002366 <exit>
  if(which_dev == 2)
    80002d4c:	4789                	li	a5,2
    80002d4e:	f8f910e3          	bne	s2,a5,80002cce <usertrap+0x62>
    yield();
    80002d52:	fffff097          	auipc	ra,0xfffff
    80002d56:	37c080e7          	jalr	892(ra) # 800020ce <yield>
    80002d5a:	bf95                	j	80002cce <usertrap+0x62>
  int which_dev = 0;
    80002d5c:	4901                	li	s2,0
    80002d5e:	b7d5                	j	80002d42 <usertrap+0xd6>

0000000080002d60 <kerneltrap>:
{
    80002d60:	7179                	addi	sp,sp,-48
    80002d62:	f406                	sd	ra,40(sp)
    80002d64:	f022                	sd	s0,32(sp)
    80002d66:	ec26                	sd	s1,24(sp)
    80002d68:	e84a                	sd	s2,16(sp)
    80002d6a:	e44e                	sd	s3,8(sp)
    80002d6c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d6e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d72:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d76:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002d7a:	1004f793          	andi	a5,s1,256
    80002d7e:	cb85                	beqz	a5,80002dae <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d80:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002d84:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002d86:	ef85                	bnez	a5,80002dbe <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002d88:	00000097          	auipc	ra,0x0
    80002d8c:	e42080e7          	jalr	-446(ra) # 80002bca <devintr>
    80002d90:	cd1d                	beqz	a0,80002dce <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d92:	4789                	li	a5,2
    80002d94:	06f50a63          	beq	a0,a5,80002e08 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002d98:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d9c:	10049073          	csrw	sstatus,s1
}
    80002da0:	70a2                	ld	ra,40(sp)
    80002da2:	7402                	ld	s0,32(sp)
    80002da4:	64e2                	ld	s1,24(sp)
    80002da6:	6942                	ld	s2,16(sp)
    80002da8:	69a2                	ld	s3,8(sp)
    80002daa:	6145                	addi	sp,sp,48
    80002dac:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002dae:	00005517          	auipc	a0,0x5
    80002db2:	69250513          	addi	a0,a0,1682 # 80008440 <states.0+0xc8>
    80002db6:	ffffd097          	auipc	ra,0xffffd
    80002dba:	774080e7          	jalr	1908(ra) # 8000052a <panic>
    panic("kerneltrap: interrupts enabled");
    80002dbe:	00005517          	auipc	a0,0x5
    80002dc2:	6aa50513          	addi	a0,a0,1706 # 80008468 <states.0+0xf0>
    80002dc6:	ffffd097          	auipc	ra,0xffffd
    80002dca:	764080e7          	jalr	1892(ra) # 8000052a <panic>
    printf("scause %p\n", scause);
    80002dce:	85ce                	mv	a1,s3
    80002dd0:	00005517          	auipc	a0,0x5
    80002dd4:	6b850513          	addi	a0,a0,1720 # 80008488 <states.0+0x110>
    80002dd8:	ffffd097          	auipc	ra,0xffffd
    80002ddc:	79c080e7          	jalr	1948(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002de0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002de4:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002de8:	00005517          	auipc	a0,0x5
    80002dec:	6b050513          	addi	a0,a0,1712 # 80008498 <states.0+0x120>
    80002df0:	ffffd097          	auipc	ra,0xffffd
    80002df4:	784080e7          	jalr	1924(ra) # 80000574 <printf>
    panic("kerneltrap");
    80002df8:	00005517          	auipc	a0,0x5
    80002dfc:	6b850513          	addi	a0,a0,1720 # 800084b0 <states.0+0x138>
    80002e00:	ffffd097          	auipc	ra,0xffffd
    80002e04:	72a080e7          	jalr	1834(ra) # 8000052a <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002e08:	fffff097          	auipc	ra,0xfffff
    80002e0c:	b76080e7          	jalr	-1162(ra) # 8000197e <myproc>
    80002e10:	d541                	beqz	a0,80002d98 <kerneltrap+0x38>
    80002e12:	fffff097          	auipc	ra,0xfffff
    80002e16:	b6c080e7          	jalr	-1172(ra) # 8000197e <myproc>
    80002e1a:	4d18                	lw	a4,24(a0)
    80002e1c:	4791                	li	a5,4
    80002e1e:	f6f71de3          	bne	a4,a5,80002d98 <kerneltrap+0x38>
    yield();
    80002e22:	fffff097          	auipc	ra,0xfffff
    80002e26:	2ac080e7          	jalr	684(ra) # 800020ce <yield>
    80002e2a:	b7bd                	j	80002d98 <kerneltrap+0x38>

0000000080002e2c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002e2c:	1101                	addi	sp,sp,-32
    80002e2e:	ec06                	sd	ra,24(sp)
    80002e30:	e822                	sd	s0,16(sp)
    80002e32:	e426                	sd	s1,8(sp)
    80002e34:	1000                	addi	s0,sp,32
    80002e36:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002e38:	fffff097          	auipc	ra,0xfffff
    80002e3c:	b46080e7          	jalr	-1210(ra) # 8000197e <myproc>
  switch (n) {
    80002e40:	4795                	li	a5,5
    80002e42:	0497e163          	bltu	a5,s1,80002e84 <argraw+0x58>
    80002e46:	048a                	slli	s1,s1,0x2
    80002e48:	00005717          	auipc	a4,0x5
    80002e4c:	6a070713          	addi	a4,a4,1696 # 800084e8 <states.0+0x170>
    80002e50:	94ba                	add	s1,s1,a4
    80002e52:	409c                	lw	a5,0(s1)
    80002e54:	97ba                	add	a5,a5,a4
    80002e56:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002e58:	6d3c                	ld	a5,88(a0)
    80002e5a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002e5c:	60e2                	ld	ra,24(sp)
    80002e5e:	6442                	ld	s0,16(sp)
    80002e60:	64a2                	ld	s1,8(sp)
    80002e62:	6105                	addi	sp,sp,32
    80002e64:	8082                	ret
    return p->trapframe->a1;
    80002e66:	6d3c                	ld	a5,88(a0)
    80002e68:	7fa8                	ld	a0,120(a5)
    80002e6a:	bfcd                	j	80002e5c <argraw+0x30>
    return p->trapframe->a2;
    80002e6c:	6d3c                	ld	a5,88(a0)
    80002e6e:	63c8                	ld	a0,128(a5)
    80002e70:	b7f5                	j	80002e5c <argraw+0x30>
    return p->trapframe->a3;
    80002e72:	6d3c                	ld	a5,88(a0)
    80002e74:	67c8                	ld	a0,136(a5)
    80002e76:	b7dd                	j	80002e5c <argraw+0x30>
    return p->trapframe->a4;
    80002e78:	6d3c                	ld	a5,88(a0)
    80002e7a:	6bc8                	ld	a0,144(a5)
    80002e7c:	b7c5                	j	80002e5c <argraw+0x30>
    return p->trapframe->a5;
    80002e7e:	6d3c                	ld	a5,88(a0)
    80002e80:	6fc8                	ld	a0,152(a5)
    80002e82:	bfe9                	j	80002e5c <argraw+0x30>
  panic("argraw");
    80002e84:	00005517          	auipc	a0,0x5
    80002e88:	63c50513          	addi	a0,a0,1596 # 800084c0 <states.0+0x148>
    80002e8c:	ffffd097          	auipc	ra,0xffffd
    80002e90:	69e080e7          	jalr	1694(ra) # 8000052a <panic>

0000000080002e94 <fetchaddr>:
{
    80002e94:	1101                	addi	sp,sp,-32
    80002e96:	ec06                	sd	ra,24(sp)
    80002e98:	e822                	sd	s0,16(sp)
    80002e9a:	e426                	sd	s1,8(sp)
    80002e9c:	e04a                	sd	s2,0(sp)
    80002e9e:	1000                	addi	s0,sp,32
    80002ea0:	84aa                	mv	s1,a0
    80002ea2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002ea4:	fffff097          	auipc	ra,0xfffff
    80002ea8:	ada080e7          	jalr	-1318(ra) # 8000197e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002eac:	653c                	ld	a5,72(a0)
    80002eae:	02f4f863          	bgeu	s1,a5,80002ede <fetchaddr+0x4a>
    80002eb2:	00848713          	addi	a4,s1,8
    80002eb6:	02e7e663          	bltu	a5,a4,80002ee2 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002eba:	46a1                	li	a3,8
    80002ebc:	8626                	mv	a2,s1
    80002ebe:	85ca                	mv	a1,s2
    80002ec0:	6928                	ld	a0,80(a0)
    80002ec2:	fffff097          	auipc	ra,0xfffff
    80002ec6:	808080e7          	jalr	-2040(ra) # 800016ca <copyin>
    80002eca:	00a03533          	snez	a0,a0
    80002ece:	40a00533          	neg	a0,a0
}
    80002ed2:	60e2                	ld	ra,24(sp)
    80002ed4:	6442                	ld	s0,16(sp)
    80002ed6:	64a2                	ld	s1,8(sp)
    80002ed8:	6902                	ld	s2,0(sp)
    80002eda:	6105                	addi	sp,sp,32
    80002edc:	8082                	ret
    return -1;
    80002ede:	557d                	li	a0,-1
    80002ee0:	bfcd                	j	80002ed2 <fetchaddr+0x3e>
    80002ee2:	557d                	li	a0,-1
    80002ee4:	b7fd                	j	80002ed2 <fetchaddr+0x3e>

0000000080002ee6 <fetchstr>:
{
    80002ee6:	7179                	addi	sp,sp,-48
    80002ee8:	f406                	sd	ra,40(sp)
    80002eea:	f022                	sd	s0,32(sp)
    80002eec:	ec26                	sd	s1,24(sp)
    80002eee:	e84a                	sd	s2,16(sp)
    80002ef0:	e44e                	sd	s3,8(sp)
    80002ef2:	1800                	addi	s0,sp,48
    80002ef4:	892a                	mv	s2,a0
    80002ef6:	84ae                	mv	s1,a1
    80002ef8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002efa:	fffff097          	auipc	ra,0xfffff
    80002efe:	a84080e7          	jalr	-1404(ra) # 8000197e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002f02:	86ce                	mv	a3,s3
    80002f04:	864a                	mv	a2,s2
    80002f06:	85a6                	mv	a1,s1
    80002f08:	6928                	ld	a0,80(a0)
    80002f0a:	fffff097          	auipc	ra,0xfffff
    80002f0e:	84e080e7          	jalr	-1970(ra) # 80001758 <copyinstr>
  if(err < 0)
    80002f12:	00054763          	bltz	a0,80002f20 <fetchstr+0x3a>
  return strlen(buf);
    80002f16:	8526                	mv	a0,s1
    80002f18:	ffffe097          	auipc	ra,0xffffe
    80002f1c:	f2a080e7          	jalr	-214(ra) # 80000e42 <strlen>
}
    80002f20:	70a2                	ld	ra,40(sp)
    80002f22:	7402                	ld	s0,32(sp)
    80002f24:	64e2                	ld	s1,24(sp)
    80002f26:	6942                	ld	s2,16(sp)
    80002f28:	69a2                	ld	s3,8(sp)
    80002f2a:	6145                	addi	sp,sp,48
    80002f2c:	8082                	ret

0000000080002f2e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002f2e:	1101                	addi	sp,sp,-32
    80002f30:	ec06                	sd	ra,24(sp)
    80002f32:	e822                	sd	s0,16(sp)
    80002f34:	e426                	sd	s1,8(sp)
    80002f36:	1000                	addi	s0,sp,32
    80002f38:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002f3a:	00000097          	auipc	ra,0x0
    80002f3e:	ef2080e7          	jalr	-270(ra) # 80002e2c <argraw>
    80002f42:	c088                	sw	a0,0(s1)
  return 0;
}
    80002f44:	4501                	li	a0,0
    80002f46:	60e2                	ld	ra,24(sp)
    80002f48:	6442                	ld	s0,16(sp)
    80002f4a:	64a2                	ld	s1,8(sp)
    80002f4c:	6105                	addi	sp,sp,32
    80002f4e:	8082                	ret

0000000080002f50 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002f50:	1101                	addi	sp,sp,-32
    80002f52:	ec06                	sd	ra,24(sp)
    80002f54:	e822                	sd	s0,16(sp)
    80002f56:	e426                	sd	s1,8(sp)
    80002f58:	1000                	addi	s0,sp,32
    80002f5a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002f5c:	00000097          	auipc	ra,0x0
    80002f60:	ed0080e7          	jalr	-304(ra) # 80002e2c <argraw>
    80002f64:	e088                	sd	a0,0(s1)
  return 0;
}
    80002f66:	4501                	li	a0,0
    80002f68:	60e2                	ld	ra,24(sp)
    80002f6a:	6442                	ld	s0,16(sp)
    80002f6c:	64a2                	ld	s1,8(sp)
    80002f6e:	6105                	addi	sp,sp,32
    80002f70:	8082                	ret

0000000080002f72 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002f72:	1101                	addi	sp,sp,-32
    80002f74:	ec06                	sd	ra,24(sp)
    80002f76:	e822                	sd	s0,16(sp)
    80002f78:	e426                	sd	s1,8(sp)
    80002f7a:	e04a                	sd	s2,0(sp)
    80002f7c:	1000                	addi	s0,sp,32
    80002f7e:	84ae                	mv	s1,a1
    80002f80:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002f82:	00000097          	auipc	ra,0x0
    80002f86:	eaa080e7          	jalr	-342(ra) # 80002e2c <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002f8a:	864a                	mv	a2,s2
    80002f8c:	85a6                	mv	a1,s1
    80002f8e:	00000097          	auipc	ra,0x0
    80002f92:	f58080e7          	jalr	-168(ra) # 80002ee6 <fetchstr>
}
    80002f96:	60e2                	ld	ra,24(sp)
    80002f98:	6442                	ld	s0,16(sp)
    80002f9a:	64a2                	ld	s1,8(sp)
    80002f9c:	6902                	ld	s2,0(sp)
    80002f9e:	6105                	addi	sp,sp,32
    80002fa0:	8082                	ret

0000000080002fa2 <syscall>:
[SYS_sigret]   sys_sigret,
};

void
syscall(void)
{
    80002fa2:	1101                	addi	sp,sp,-32
    80002fa4:	ec06                	sd	ra,24(sp)
    80002fa6:	e822                	sd	s0,16(sp)
    80002fa8:	e426                	sd	s1,8(sp)
    80002faa:	e04a                	sd	s2,0(sp)
    80002fac:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002fae:	fffff097          	auipc	ra,0xfffff
    80002fb2:	9d0080e7          	jalr	-1584(ra) # 8000197e <myproc>
    80002fb6:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002fb8:	05853903          	ld	s2,88(a0)
    80002fbc:	0a893783          	ld	a5,168(s2) # 40000a8 <_entry-0x7bffff58>
    80002fc0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002fc4:	37fd                	addiw	a5,a5,-1
    80002fc6:	475d                	li	a4,23
    80002fc8:	00f76f63          	bltu	a4,a5,80002fe6 <syscall+0x44>
    80002fcc:	00369713          	slli	a4,a3,0x3
    80002fd0:	00005797          	auipc	a5,0x5
    80002fd4:	53078793          	addi	a5,a5,1328 # 80008500 <syscalls>
    80002fd8:	97ba                	add	a5,a5,a4
    80002fda:	639c                	ld	a5,0(a5)
    80002fdc:	c789                	beqz	a5,80002fe6 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002fde:	9782                	jalr	a5
    80002fe0:	06a93823          	sd	a0,112(s2)
    80002fe4:	a839                	j	80003002 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002fe6:	15848613          	addi	a2,s1,344
    80002fea:	588c                	lw	a1,48(s1)
    80002fec:	00005517          	auipc	a0,0x5
    80002ff0:	4dc50513          	addi	a0,a0,1244 # 800084c8 <states.0+0x150>
    80002ff4:	ffffd097          	auipc	ra,0xffffd
    80002ff8:	580080e7          	jalr	1408(ra) # 80000574 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002ffc:	6cbc                	ld	a5,88(s1)
    80002ffe:	577d                	li	a4,-1
    80003000:	fbb8                	sd	a4,112(a5)
  }
}
    80003002:	60e2                	ld	ra,24(sp)
    80003004:	6442                	ld	s0,16(sp)
    80003006:	64a2                	ld	s1,8(sp)
    80003008:	6902                	ld	s2,0(sp)
    8000300a:	6105                	addi	sp,sp,32
    8000300c:	8082                	ret

000000008000300e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000300e:	1101                	addi	sp,sp,-32
    80003010:	ec06                	sd	ra,24(sp)
    80003012:	e822                	sd	s0,16(sp)
    80003014:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80003016:	fec40593          	addi	a1,s0,-20
    8000301a:	4501                	li	a0,0
    8000301c:	00000097          	auipc	ra,0x0
    80003020:	f12080e7          	jalr	-238(ra) # 80002f2e <argint>
    return -1;
    80003024:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80003026:	00054963          	bltz	a0,80003038 <sys_exit+0x2a>
  exit(n);
    8000302a:	fec42503          	lw	a0,-20(s0)
    8000302e:	fffff097          	auipc	ra,0xfffff
    80003032:	338080e7          	jalr	824(ra) # 80002366 <exit>
  return 0;  // not reached
    80003036:	4781                	li	a5,0
}
    80003038:	853e                	mv	a0,a5
    8000303a:	60e2                	ld	ra,24(sp)
    8000303c:	6442                	ld	s0,16(sp)
    8000303e:	6105                	addi	sp,sp,32
    80003040:	8082                	ret

0000000080003042 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003042:	1141                	addi	sp,sp,-16
    80003044:	e406                	sd	ra,8(sp)
    80003046:	e022                	sd	s0,0(sp)
    80003048:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	934080e7          	jalr	-1740(ra) # 8000197e <myproc>
}
    80003052:	5908                	lw	a0,48(a0)
    80003054:	60a2                	ld	ra,8(sp)
    80003056:	6402                	ld	s0,0(sp)
    80003058:	0141                	addi	sp,sp,16
    8000305a:	8082                	ret

000000008000305c <sys_fork>:

uint64
sys_fork(void)
{
    8000305c:	1141                	addi	sp,sp,-16
    8000305e:	e406                	sd	ra,8(sp)
    80003060:	e022                	sd	s0,0(sp)
    80003062:	0800                	addi	s0,sp,16
  return fork();
    80003064:	fffff097          	auipc	ra,0xfffff
    80003068:	d80080e7          	jalr	-640(ra) # 80001de4 <fork>
}
    8000306c:	60a2                	ld	ra,8(sp)
    8000306e:	6402                	ld	s0,0(sp)
    80003070:	0141                	addi	sp,sp,16
    80003072:	8082                	ret

0000000080003074 <sys_wait>:

uint64
sys_wait(void)
{
    80003074:	1101                	addi	sp,sp,-32
    80003076:	ec06                	sd	ra,24(sp)
    80003078:	e822                	sd	s0,16(sp)
    8000307a:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000307c:	fe840593          	addi	a1,s0,-24
    80003080:	4501                	li	a0,0
    80003082:	00000097          	auipc	ra,0x0
    80003086:	ece080e7          	jalr	-306(ra) # 80002f50 <argaddr>
    8000308a:	87aa                	mv	a5,a0
    return -1;
    8000308c:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000308e:	0007c863          	bltz	a5,8000309e <sys_wait+0x2a>
  return wait(p);
    80003092:	fe843503          	ld	a0,-24(s0)
    80003096:	fffff097          	auipc	ra,0xfffff
    8000309a:	0d8080e7          	jalr	216(ra) # 8000216e <wait>
}
    8000309e:	60e2                	ld	ra,24(sp)
    800030a0:	6442                	ld	s0,16(sp)
    800030a2:	6105                	addi	sp,sp,32
    800030a4:	8082                	ret

00000000800030a6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800030a6:	7179                	addi	sp,sp,-48
    800030a8:	f406                	sd	ra,40(sp)
    800030aa:	f022                	sd	s0,32(sp)
    800030ac:	ec26                	sd	s1,24(sp)
    800030ae:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800030b0:	fdc40593          	addi	a1,s0,-36
    800030b4:	4501                	li	a0,0
    800030b6:	00000097          	auipc	ra,0x0
    800030ba:	e78080e7          	jalr	-392(ra) # 80002f2e <argint>
    return -1;
    800030be:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    800030c0:	00054f63          	bltz	a0,800030de <sys_sbrk+0x38>
  addr = myproc()->sz;
    800030c4:	fffff097          	auipc	ra,0xfffff
    800030c8:	8ba080e7          	jalr	-1862(ra) # 8000197e <myproc>
    800030cc:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800030ce:	fdc42503          	lw	a0,-36(s0)
    800030d2:	fffff097          	auipc	ra,0xfffff
    800030d6:	c9e080e7          	jalr	-866(ra) # 80001d70 <growproc>
    800030da:	00054863          	bltz	a0,800030ea <sys_sbrk+0x44>
    return -1;
  return addr;
}
    800030de:	8526                	mv	a0,s1
    800030e0:	70a2                	ld	ra,40(sp)
    800030e2:	7402                	ld	s0,32(sp)
    800030e4:	64e2                	ld	s1,24(sp)
    800030e6:	6145                	addi	sp,sp,48
    800030e8:	8082                	ret
    return -1;
    800030ea:	54fd                	li	s1,-1
    800030ec:	bfcd                	j	800030de <sys_sbrk+0x38>

00000000800030ee <sys_sleep>:

uint64
sys_sleep(void)
{
    800030ee:	7139                	addi	sp,sp,-64
    800030f0:	fc06                	sd	ra,56(sp)
    800030f2:	f822                	sd	s0,48(sp)
    800030f4:	f426                	sd	s1,40(sp)
    800030f6:	f04a                	sd	s2,32(sp)
    800030f8:	ec4e                	sd	s3,24(sp)
    800030fa:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800030fc:	fcc40593          	addi	a1,s0,-52
    80003100:	4501                	li	a0,0
    80003102:	00000097          	auipc	ra,0x0
    80003106:	e2c080e7          	jalr	-468(ra) # 80002f2e <argint>
    return -1;
    8000310a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000310c:	06054563          	bltz	a0,80003176 <sys_sleep+0x88>
  acquire(&tickslock);
    80003110:	0001a517          	auipc	a0,0x1a
    80003114:	7c050513          	addi	a0,a0,1984 # 8001d8d0 <tickslock>
    80003118:	ffffe097          	auipc	ra,0xffffe
    8000311c:	aaa080e7          	jalr	-1366(ra) # 80000bc2 <acquire>
  ticks0 = ticks;
    80003120:	00006917          	auipc	s2,0x6
    80003124:	f1092903          	lw	s2,-240(s2) # 80009030 <ticks>
  while(ticks - ticks0 < n){
    80003128:	fcc42783          	lw	a5,-52(s0)
    8000312c:	cf85                	beqz	a5,80003164 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000312e:	0001a997          	auipc	s3,0x1a
    80003132:	7a298993          	addi	s3,s3,1954 # 8001d8d0 <tickslock>
    80003136:	00006497          	auipc	s1,0x6
    8000313a:	efa48493          	addi	s1,s1,-262 # 80009030 <ticks>
    if(myproc()->killed){
    8000313e:	fffff097          	auipc	ra,0xfffff
    80003142:	840080e7          	jalr	-1984(ra) # 8000197e <myproc>
    80003146:	551c                	lw	a5,40(a0)
    80003148:	ef9d                	bnez	a5,80003186 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000314a:	85ce                	mv	a1,s3
    8000314c:	8526                	mv	a0,s1
    8000314e:	fffff097          	auipc	ra,0xfffff
    80003152:	fbc080e7          	jalr	-68(ra) # 8000210a <sleep>
  while(ticks - ticks0 < n){
    80003156:	409c                	lw	a5,0(s1)
    80003158:	412787bb          	subw	a5,a5,s2
    8000315c:	fcc42703          	lw	a4,-52(s0)
    80003160:	fce7efe3          	bltu	a5,a4,8000313e <sys_sleep+0x50>
  }
  release(&tickslock);
    80003164:	0001a517          	auipc	a0,0x1a
    80003168:	76c50513          	addi	a0,a0,1900 # 8001d8d0 <tickslock>
    8000316c:	ffffe097          	auipc	ra,0xffffe
    80003170:	b0a080e7          	jalr	-1270(ra) # 80000c76 <release>
  return 0;
    80003174:	4781                	li	a5,0
}
    80003176:	853e                	mv	a0,a5
    80003178:	70e2                	ld	ra,56(sp)
    8000317a:	7442                	ld	s0,48(sp)
    8000317c:	74a2                	ld	s1,40(sp)
    8000317e:	7902                	ld	s2,32(sp)
    80003180:	69e2                	ld	s3,24(sp)
    80003182:	6121                	addi	sp,sp,64
    80003184:	8082                	ret
      release(&tickslock);
    80003186:	0001a517          	auipc	a0,0x1a
    8000318a:	74a50513          	addi	a0,a0,1866 # 8001d8d0 <tickslock>
    8000318e:	ffffe097          	auipc	ra,0xffffe
    80003192:	ae8080e7          	jalr	-1304(ra) # 80000c76 <release>
      return -1;
    80003196:	57fd                	li	a5,-1
    80003198:	bff9                	j	80003176 <sys_sleep+0x88>

000000008000319a <sys_kill>:

uint64
sys_kill(void)
{
    8000319a:	1101                	addi	sp,sp,-32
    8000319c:	ec06                	sd	ra,24(sp)
    8000319e:	e822                	sd	s0,16(sp)
    800031a0:	1000                	addi	s0,sp,32
  int pid;
  int signum;

  if(argint(0, &pid) < 0 || argint(1, &signum) < 0)
    800031a2:	fec40593          	addi	a1,s0,-20
    800031a6:	4501                	li	a0,0
    800031a8:	00000097          	auipc	ra,0x0
    800031ac:	d86080e7          	jalr	-634(ra) # 80002f2e <argint>
    return -1;
    800031b0:	57fd                	li	a5,-1
  if(argint(0, &pid) < 0 || argint(1, &signum) < 0)
    800031b2:	02054563          	bltz	a0,800031dc <sys_kill+0x42>
    800031b6:	fe840593          	addi	a1,s0,-24
    800031ba:	4505                	li	a0,1
    800031bc:	00000097          	auipc	ra,0x0
    800031c0:	d72080e7          	jalr	-654(ra) # 80002f2e <argint>
    return -1;
    800031c4:	57fd                	li	a5,-1
  if(argint(0, &pid) < 0 || argint(1, &signum) < 0)
    800031c6:	00054b63          	bltz	a0,800031dc <sys_kill+0x42>
  return kill(pid, signum);
    800031ca:	fe842583          	lw	a1,-24(s0)
    800031ce:	fec42503          	lw	a0,-20(s0)
    800031d2:	fffff097          	auipc	ra,0xfffff
    800031d6:	26a080e7          	jalr	618(ra) # 8000243c <kill>
    800031da:	87aa                	mv	a5,a0
}
    800031dc:	853e                	mv	a0,a5
    800031de:	60e2                	ld	ra,24(sp)
    800031e0:	6442                	ld	s0,16(sp)
    800031e2:	6105                	addi	sp,sp,32
    800031e4:	8082                	ret

00000000800031e6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800031e6:	1101                	addi	sp,sp,-32
    800031e8:	ec06                	sd	ra,24(sp)
    800031ea:	e822                	sd	s0,16(sp)
    800031ec:	e426                	sd	s1,8(sp)
    800031ee:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800031f0:	0001a517          	auipc	a0,0x1a
    800031f4:	6e050513          	addi	a0,a0,1760 # 8001d8d0 <tickslock>
    800031f8:	ffffe097          	auipc	ra,0xffffe
    800031fc:	9ca080e7          	jalr	-1590(ra) # 80000bc2 <acquire>
  xticks = ticks;
    80003200:	00006497          	auipc	s1,0x6
    80003204:	e304a483          	lw	s1,-464(s1) # 80009030 <ticks>
  release(&tickslock);
    80003208:	0001a517          	auipc	a0,0x1a
    8000320c:	6c850513          	addi	a0,a0,1736 # 8001d8d0 <tickslock>
    80003210:	ffffe097          	auipc	ra,0xffffe
    80003214:	a66080e7          	jalr	-1434(ra) # 80000c76 <release>
  return xticks;
}
    80003218:	02049513          	slli	a0,s1,0x20
    8000321c:	9101                	srli	a0,a0,0x20
    8000321e:	60e2                	ld	ra,24(sp)
    80003220:	6442                	ld	s0,16(sp)
    80003222:	64a2                	ld	s1,8(sp)
    80003224:	6105                	addi	sp,sp,32
    80003226:	8082                	ret

0000000080003228 <sys_sigprocmask>:


/* sig proc mask*/
uint64
sys_sigprocmask(void)
{
    80003228:	1101                	addi	sp,sp,-32
    8000322a:	ec06                	sd	ra,24(sp)
    8000322c:	e822                	sd	s0,16(sp)
    8000322e:	1000                	addi	s0,sp,32
  int mask;

  if(argint(0, &mask) < 0)
    80003230:	fec40593          	addi	a1,s0,-20
    80003234:	4501                	li	a0,0
    80003236:	00000097          	auipc	ra,0x0
    8000323a:	cf8080e7          	jalr	-776(ra) # 80002f2e <argint>
    8000323e:	87aa                	mv	a5,a0
    return -1;
    80003240:	557d                	li	a0,-1
  if(argint(0, &mask) < 0)
    80003242:	0007ca63          	bltz	a5,80003256 <sys_sigprocmask+0x2e>
  
  return sigprocmask(mask);
    80003246:	fec42503          	lw	a0,-20(s0)
    8000324a:	fffff097          	auipc	ra,0xfffff
    8000324e:	3da080e7          	jalr	986(ra) # 80002624 <sigprocmask>
    80003252:	1502                	slli	a0,a0,0x20
    80003254:	9101                	srli	a0,a0,0x20
}
    80003256:	60e2                	ld	ra,24(sp)
    80003258:	6442                	ld	s0,16(sp)
    8000325a:	6105                	addi	sp,sp,32
    8000325c:	8082                	ret

000000008000325e <sys_sigaction>:
//   return sigaction (signum,act,oldact);
// }

uint64
sys_sigaction(void)
{
    8000325e:	7179                	addi	sp,sp,-48
    80003260:	f406                	sd	ra,40(sp)
    80003262:	f022                	sd	s0,32(sp)
    80003264:	1800                	addi	s0,sp,48
  int signum;
  uint64 act;
  uint64 oldact;
  if(argint(0, &signum) < 0)
    80003266:	fec40593          	addi	a1,s0,-20
    8000326a:	4501                	li	a0,0
    8000326c:	00000097          	auipc	ra,0x0
    80003270:	cc2080e7          	jalr	-830(ra) # 80002f2e <argint>
    return -1;
    80003274:	57fd                	li	a5,-1
  if(argint(0, &signum) < 0)
    80003276:	04054163          	bltz	a0,800032b8 <sys_sigaction+0x5a>
  if(argaddr(1, &act) < 0)
    8000327a:	fe040593          	addi	a1,s0,-32
    8000327e:	4505                	li	a0,1
    80003280:	00000097          	auipc	ra,0x0
    80003284:	cd0080e7          	jalr	-816(ra) # 80002f50 <argaddr>
    return -1;
    80003288:	57fd                	li	a5,-1
  if(argaddr(1, &act) < 0)
    8000328a:	02054763          	bltz	a0,800032b8 <sys_sigaction+0x5a>
  if(argaddr(2, &oldact) < 0)
    8000328e:	fd840593          	addi	a1,s0,-40
    80003292:	4509                	li	a0,2
    80003294:	00000097          	auipc	ra,0x0
    80003298:	cbc080e7          	jalr	-836(ra) # 80002f50 <argaddr>
    return -1;
    8000329c:	57fd                	li	a5,-1
  if(argaddr(2, &oldact) < 0)
    8000329e:	00054d63          	bltz	a0,800032b8 <sys_sigaction+0x5a>

  return sigaction (signum,(struct sigaction*)act,(struct sigaction*)oldact);
    800032a2:	fd843603          	ld	a2,-40(s0)
    800032a6:	fe043583          	ld	a1,-32(s0)
    800032aa:	fec42503          	lw	a0,-20(s0)
    800032ae:	fffff097          	auipc	ra,0xfffff
    800032b2:	39e080e7          	jalr	926(ra) # 8000264c <sigaction>
    800032b6:	87aa                	mv	a5,a0
}
    800032b8:	853e                	mv	a0,a5
    800032ba:	70a2                	ld	ra,40(sp)
    800032bc:	7402                	ld	s0,32(sp)
    800032be:	6145                	addi	sp,sp,48
    800032c0:	8082                	ret

00000000800032c2 <sys_sigret>:

uint64
sys_sigret(void)
{
    800032c2:	1141                	addi	sp,sp,-16
    800032c4:	e406                	sd	ra,8(sp)
    800032c6:	e022                	sd	s0,0(sp)
    800032c8:	0800                	addi	s0,sp,16
  sigret();
    800032ca:	fffff097          	auipc	ra,0xfffff
    800032ce:	472080e7          	jalr	1138(ra) # 8000273c <sigret>
  return 0;
}
    800032d2:	4501                	li	a0,0
    800032d4:	60a2                	ld	ra,8(sp)
    800032d6:	6402                	ld	s0,0(sp)
    800032d8:	0141                	addi	sp,sp,16
    800032da:	8082                	ret

00000000800032dc <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800032dc:	7179                	addi	sp,sp,-48
    800032de:	f406                	sd	ra,40(sp)
    800032e0:	f022                	sd	s0,32(sp)
    800032e2:	ec26                	sd	s1,24(sp)
    800032e4:	e84a                	sd	s2,16(sp)
    800032e6:	e44e                	sd	s3,8(sp)
    800032e8:	e052                	sd	s4,0(sp)
    800032ea:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800032ec:	00005597          	auipc	a1,0x5
    800032f0:	2dc58593          	addi	a1,a1,732 # 800085c8 <syscalls+0xc8>
    800032f4:	0001a517          	auipc	a0,0x1a
    800032f8:	5f450513          	addi	a0,a0,1524 # 8001d8e8 <bcache>
    800032fc:	ffffe097          	auipc	ra,0xffffe
    80003300:	836080e7          	jalr	-1994(ra) # 80000b32 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003304:	00022797          	auipc	a5,0x22
    80003308:	5e478793          	addi	a5,a5,1508 # 800258e8 <bcache+0x8000>
    8000330c:	00023717          	auipc	a4,0x23
    80003310:	84470713          	addi	a4,a4,-1980 # 80025b50 <bcache+0x8268>
    80003314:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003318:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000331c:	0001a497          	auipc	s1,0x1a
    80003320:	5e448493          	addi	s1,s1,1508 # 8001d900 <bcache+0x18>
    b->next = bcache.head.next;
    80003324:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003326:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003328:	00005a17          	auipc	s4,0x5
    8000332c:	2a8a0a13          	addi	s4,s4,680 # 800085d0 <syscalls+0xd0>
    b->next = bcache.head.next;
    80003330:	2b893783          	ld	a5,696(s2)
    80003334:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003336:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000333a:	85d2                	mv	a1,s4
    8000333c:	01048513          	addi	a0,s1,16
    80003340:	00001097          	auipc	ra,0x1
    80003344:	4c2080e7          	jalr	1218(ra) # 80004802 <initsleeplock>
    bcache.head.next->prev = b;
    80003348:	2b893783          	ld	a5,696(s2)
    8000334c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000334e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003352:	45848493          	addi	s1,s1,1112
    80003356:	fd349de3          	bne	s1,s3,80003330 <binit+0x54>
  }
}
    8000335a:	70a2                	ld	ra,40(sp)
    8000335c:	7402                	ld	s0,32(sp)
    8000335e:	64e2                	ld	s1,24(sp)
    80003360:	6942                	ld	s2,16(sp)
    80003362:	69a2                	ld	s3,8(sp)
    80003364:	6a02                	ld	s4,0(sp)
    80003366:	6145                	addi	sp,sp,48
    80003368:	8082                	ret

000000008000336a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000336a:	7179                	addi	sp,sp,-48
    8000336c:	f406                	sd	ra,40(sp)
    8000336e:	f022                	sd	s0,32(sp)
    80003370:	ec26                	sd	s1,24(sp)
    80003372:	e84a                	sd	s2,16(sp)
    80003374:	e44e                	sd	s3,8(sp)
    80003376:	1800                	addi	s0,sp,48
    80003378:	892a                	mv	s2,a0
    8000337a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000337c:	0001a517          	auipc	a0,0x1a
    80003380:	56c50513          	addi	a0,a0,1388 # 8001d8e8 <bcache>
    80003384:	ffffe097          	auipc	ra,0xffffe
    80003388:	83e080e7          	jalr	-1986(ra) # 80000bc2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000338c:	00023497          	auipc	s1,0x23
    80003390:	8144b483          	ld	s1,-2028(s1) # 80025ba0 <bcache+0x82b8>
    80003394:	00022797          	auipc	a5,0x22
    80003398:	7bc78793          	addi	a5,a5,1980 # 80025b50 <bcache+0x8268>
    8000339c:	02f48f63          	beq	s1,a5,800033da <bread+0x70>
    800033a0:	873e                	mv	a4,a5
    800033a2:	a021                	j	800033aa <bread+0x40>
    800033a4:	68a4                	ld	s1,80(s1)
    800033a6:	02e48a63          	beq	s1,a4,800033da <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800033aa:	449c                	lw	a5,8(s1)
    800033ac:	ff279ce3          	bne	a5,s2,800033a4 <bread+0x3a>
    800033b0:	44dc                	lw	a5,12(s1)
    800033b2:	ff3799e3          	bne	a5,s3,800033a4 <bread+0x3a>
      b->refcnt++;
    800033b6:	40bc                	lw	a5,64(s1)
    800033b8:	2785                	addiw	a5,a5,1
    800033ba:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800033bc:	0001a517          	auipc	a0,0x1a
    800033c0:	52c50513          	addi	a0,a0,1324 # 8001d8e8 <bcache>
    800033c4:	ffffe097          	auipc	ra,0xffffe
    800033c8:	8b2080e7          	jalr	-1870(ra) # 80000c76 <release>
      acquiresleep(&b->lock);
    800033cc:	01048513          	addi	a0,s1,16
    800033d0:	00001097          	auipc	ra,0x1
    800033d4:	46c080e7          	jalr	1132(ra) # 8000483c <acquiresleep>
      return b;
    800033d8:	a8b9                	j	80003436 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800033da:	00022497          	auipc	s1,0x22
    800033de:	7be4b483          	ld	s1,1982(s1) # 80025b98 <bcache+0x82b0>
    800033e2:	00022797          	auipc	a5,0x22
    800033e6:	76e78793          	addi	a5,a5,1902 # 80025b50 <bcache+0x8268>
    800033ea:	00f48863          	beq	s1,a5,800033fa <bread+0x90>
    800033ee:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800033f0:	40bc                	lw	a5,64(s1)
    800033f2:	cf81                	beqz	a5,8000340a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800033f4:	64a4                	ld	s1,72(s1)
    800033f6:	fee49de3          	bne	s1,a4,800033f0 <bread+0x86>
  panic("bget: no buffers");
    800033fa:	00005517          	auipc	a0,0x5
    800033fe:	1de50513          	addi	a0,a0,478 # 800085d8 <syscalls+0xd8>
    80003402:	ffffd097          	auipc	ra,0xffffd
    80003406:	128080e7          	jalr	296(ra) # 8000052a <panic>
      b->dev = dev;
    8000340a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000340e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003412:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003416:	4785                	li	a5,1
    80003418:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000341a:	0001a517          	auipc	a0,0x1a
    8000341e:	4ce50513          	addi	a0,a0,1230 # 8001d8e8 <bcache>
    80003422:	ffffe097          	auipc	ra,0xffffe
    80003426:	854080e7          	jalr	-1964(ra) # 80000c76 <release>
      acquiresleep(&b->lock);
    8000342a:	01048513          	addi	a0,s1,16
    8000342e:	00001097          	auipc	ra,0x1
    80003432:	40e080e7          	jalr	1038(ra) # 8000483c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003436:	409c                	lw	a5,0(s1)
    80003438:	cb89                	beqz	a5,8000344a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000343a:	8526                	mv	a0,s1
    8000343c:	70a2                	ld	ra,40(sp)
    8000343e:	7402                	ld	s0,32(sp)
    80003440:	64e2                	ld	s1,24(sp)
    80003442:	6942                	ld	s2,16(sp)
    80003444:	69a2                	ld	s3,8(sp)
    80003446:	6145                	addi	sp,sp,48
    80003448:	8082                	ret
    virtio_disk_rw(b, 0);
    8000344a:	4581                	li	a1,0
    8000344c:	8526                	mv	a0,s1
    8000344e:	00003097          	auipc	ra,0x3
    80003452:	f4e080e7          	jalr	-178(ra) # 8000639c <virtio_disk_rw>
    b->valid = 1;
    80003456:	4785                	li	a5,1
    80003458:	c09c                	sw	a5,0(s1)
  return b;
    8000345a:	b7c5                	j	8000343a <bread+0xd0>

000000008000345c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000345c:	1101                	addi	sp,sp,-32
    8000345e:	ec06                	sd	ra,24(sp)
    80003460:	e822                	sd	s0,16(sp)
    80003462:	e426                	sd	s1,8(sp)
    80003464:	1000                	addi	s0,sp,32
    80003466:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003468:	0541                	addi	a0,a0,16
    8000346a:	00001097          	auipc	ra,0x1
    8000346e:	46c080e7          	jalr	1132(ra) # 800048d6 <holdingsleep>
    80003472:	cd01                	beqz	a0,8000348a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003474:	4585                	li	a1,1
    80003476:	8526                	mv	a0,s1
    80003478:	00003097          	auipc	ra,0x3
    8000347c:	f24080e7          	jalr	-220(ra) # 8000639c <virtio_disk_rw>
}
    80003480:	60e2                	ld	ra,24(sp)
    80003482:	6442                	ld	s0,16(sp)
    80003484:	64a2                	ld	s1,8(sp)
    80003486:	6105                	addi	sp,sp,32
    80003488:	8082                	ret
    panic("bwrite");
    8000348a:	00005517          	auipc	a0,0x5
    8000348e:	16650513          	addi	a0,a0,358 # 800085f0 <syscalls+0xf0>
    80003492:	ffffd097          	auipc	ra,0xffffd
    80003496:	098080e7          	jalr	152(ra) # 8000052a <panic>

000000008000349a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000349a:	1101                	addi	sp,sp,-32
    8000349c:	ec06                	sd	ra,24(sp)
    8000349e:	e822                	sd	s0,16(sp)
    800034a0:	e426                	sd	s1,8(sp)
    800034a2:	e04a                	sd	s2,0(sp)
    800034a4:	1000                	addi	s0,sp,32
    800034a6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800034a8:	01050913          	addi	s2,a0,16
    800034ac:	854a                	mv	a0,s2
    800034ae:	00001097          	auipc	ra,0x1
    800034b2:	428080e7          	jalr	1064(ra) # 800048d6 <holdingsleep>
    800034b6:	c92d                	beqz	a0,80003528 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800034b8:	854a                	mv	a0,s2
    800034ba:	00001097          	auipc	ra,0x1
    800034be:	3d8080e7          	jalr	984(ra) # 80004892 <releasesleep>

  acquire(&bcache.lock);
    800034c2:	0001a517          	auipc	a0,0x1a
    800034c6:	42650513          	addi	a0,a0,1062 # 8001d8e8 <bcache>
    800034ca:	ffffd097          	auipc	ra,0xffffd
    800034ce:	6f8080e7          	jalr	1784(ra) # 80000bc2 <acquire>
  b->refcnt--;
    800034d2:	40bc                	lw	a5,64(s1)
    800034d4:	37fd                	addiw	a5,a5,-1
    800034d6:	0007871b          	sext.w	a4,a5
    800034da:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800034dc:	eb05                	bnez	a4,8000350c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800034de:	68bc                	ld	a5,80(s1)
    800034e0:	64b8                	ld	a4,72(s1)
    800034e2:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800034e4:	64bc                	ld	a5,72(s1)
    800034e6:	68b8                	ld	a4,80(s1)
    800034e8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800034ea:	00022797          	auipc	a5,0x22
    800034ee:	3fe78793          	addi	a5,a5,1022 # 800258e8 <bcache+0x8000>
    800034f2:	2b87b703          	ld	a4,696(a5)
    800034f6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800034f8:	00022717          	auipc	a4,0x22
    800034fc:	65870713          	addi	a4,a4,1624 # 80025b50 <bcache+0x8268>
    80003500:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003502:	2b87b703          	ld	a4,696(a5)
    80003506:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003508:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000350c:	0001a517          	auipc	a0,0x1a
    80003510:	3dc50513          	addi	a0,a0,988 # 8001d8e8 <bcache>
    80003514:	ffffd097          	auipc	ra,0xffffd
    80003518:	762080e7          	jalr	1890(ra) # 80000c76 <release>
}
    8000351c:	60e2                	ld	ra,24(sp)
    8000351e:	6442                	ld	s0,16(sp)
    80003520:	64a2                	ld	s1,8(sp)
    80003522:	6902                	ld	s2,0(sp)
    80003524:	6105                	addi	sp,sp,32
    80003526:	8082                	ret
    panic("brelse");
    80003528:	00005517          	auipc	a0,0x5
    8000352c:	0d050513          	addi	a0,a0,208 # 800085f8 <syscalls+0xf8>
    80003530:	ffffd097          	auipc	ra,0xffffd
    80003534:	ffa080e7          	jalr	-6(ra) # 8000052a <panic>

0000000080003538 <bpin>:

void
bpin(struct buf *b) {
    80003538:	1101                	addi	sp,sp,-32
    8000353a:	ec06                	sd	ra,24(sp)
    8000353c:	e822                	sd	s0,16(sp)
    8000353e:	e426                	sd	s1,8(sp)
    80003540:	1000                	addi	s0,sp,32
    80003542:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003544:	0001a517          	auipc	a0,0x1a
    80003548:	3a450513          	addi	a0,a0,932 # 8001d8e8 <bcache>
    8000354c:	ffffd097          	auipc	ra,0xffffd
    80003550:	676080e7          	jalr	1654(ra) # 80000bc2 <acquire>
  b->refcnt++;
    80003554:	40bc                	lw	a5,64(s1)
    80003556:	2785                	addiw	a5,a5,1
    80003558:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000355a:	0001a517          	auipc	a0,0x1a
    8000355e:	38e50513          	addi	a0,a0,910 # 8001d8e8 <bcache>
    80003562:	ffffd097          	auipc	ra,0xffffd
    80003566:	714080e7          	jalr	1812(ra) # 80000c76 <release>
}
    8000356a:	60e2                	ld	ra,24(sp)
    8000356c:	6442                	ld	s0,16(sp)
    8000356e:	64a2                	ld	s1,8(sp)
    80003570:	6105                	addi	sp,sp,32
    80003572:	8082                	ret

0000000080003574 <bunpin>:

void
bunpin(struct buf *b) {
    80003574:	1101                	addi	sp,sp,-32
    80003576:	ec06                	sd	ra,24(sp)
    80003578:	e822                	sd	s0,16(sp)
    8000357a:	e426                	sd	s1,8(sp)
    8000357c:	1000                	addi	s0,sp,32
    8000357e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003580:	0001a517          	auipc	a0,0x1a
    80003584:	36850513          	addi	a0,a0,872 # 8001d8e8 <bcache>
    80003588:	ffffd097          	auipc	ra,0xffffd
    8000358c:	63a080e7          	jalr	1594(ra) # 80000bc2 <acquire>
  b->refcnt--;
    80003590:	40bc                	lw	a5,64(s1)
    80003592:	37fd                	addiw	a5,a5,-1
    80003594:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003596:	0001a517          	auipc	a0,0x1a
    8000359a:	35250513          	addi	a0,a0,850 # 8001d8e8 <bcache>
    8000359e:	ffffd097          	auipc	ra,0xffffd
    800035a2:	6d8080e7          	jalr	1752(ra) # 80000c76 <release>
}
    800035a6:	60e2                	ld	ra,24(sp)
    800035a8:	6442                	ld	s0,16(sp)
    800035aa:	64a2                	ld	s1,8(sp)
    800035ac:	6105                	addi	sp,sp,32
    800035ae:	8082                	ret

00000000800035b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800035b0:	1101                	addi	sp,sp,-32
    800035b2:	ec06                	sd	ra,24(sp)
    800035b4:	e822                	sd	s0,16(sp)
    800035b6:	e426                	sd	s1,8(sp)
    800035b8:	e04a                	sd	s2,0(sp)
    800035ba:	1000                	addi	s0,sp,32
    800035bc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800035be:	00d5d59b          	srliw	a1,a1,0xd
    800035c2:	00023797          	auipc	a5,0x23
    800035c6:	a027a783          	lw	a5,-1534(a5) # 80025fc4 <sb+0x1c>
    800035ca:	9dbd                	addw	a1,a1,a5
    800035cc:	00000097          	auipc	ra,0x0
    800035d0:	d9e080e7          	jalr	-610(ra) # 8000336a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800035d4:	0074f713          	andi	a4,s1,7
    800035d8:	4785                	li	a5,1
    800035da:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800035de:	14ce                	slli	s1,s1,0x33
    800035e0:	90d9                	srli	s1,s1,0x36
    800035e2:	00950733          	add	a4,a0,s1
    800035e6:	05874703          	lbu	a4,88(a4)
    800035ea:	00e7f6b3          	and	a3,a5,a4
    800035ee:	c69d                	beqz	a3,8000361c <bfree+0x6c>
    800035f0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800035f2:	94aa                	add	s1,s1,a0
    800035f4:	fff7c793          	not	a5,a5
    800035f8:	8ff9                	and	a5,a5,a4
    800035fa:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800035fe:	00001097          	auipc	ra,0x1
    80003602:	11e080e7          	jalr	286(ra) # 8000471c <log_write>
  brelse(bp);
    80003606:	854a                	mv	a0,s2
    80003608:	00000097          	auipc	ra,0x0
    8000360c:	e92080e7          	jalr	-366(ra) # 8000349a <brelse>
}
    80003610:	60e2                	ld	ra,24(sp)
    80003612:	6442                	ld	s0,16(sp)
    80003614:	64a2                	ld	s1,8(sp)
    80003616:	6902                	ld	s2,0(sp)
    80003618:	6105                	addi	sp,sp,32
    8000361a:	8082                	ret
    panic("freeing free block");
    8000361c:	00005517          	auipc	a0,0x5
    80003620:	fe450513          	addi	a0,a0,-28 # 80008600 <syscalls+0x100>
    80003624:	ffffd097          	auipc	ra,0xffffd
    80003628:	f06080e7          	jalr	-250(ra) # 8000052a <panic>

000000008000362c <balloc>:
{
    8000362c:	711d                	addi	sp,sp,-96
    8000362e:	ec86                	sd	ra,88(sp)
    80003630:	e8a2                	sd	s0,80(sp)
    80003632:	e4a6                	sd	s1,72(sp)
    80003634:	e0ca                	sd	s2,64(sp)
    80003636:	fc4e                	sd	s3,56(sp)
    80003638:	f852                	sd	s4,48(sp)
    8000363a:	f456                	sd	s5,40(sp)
    8000363c:	f05a                	sd	s6,32(sp)
    8000363e:	ec5e                	sd	s7,24(sp)
    80003640:	e862                	sd	s8,16(sp)
    80003642:	e466                	sd	s9,8(sp)
    80003644:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003646:	00023797          	auipc	a5,0x23
    8000364a:	9667a783          	lw	a5,-1690(a5) # 80025fac <sb+0x4>
    8000364e:	cbd1                	beqz	a5,800036e2 <balloc+0xb6>
    80003650:	8baa                	mv	s7,a0
    80003652:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003654:	00023b17          	auipc	s6,0x23
    80003658:	954b0b13          	addi	s6,s6,-1708 # 80025fa8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000365c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000365e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003660:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003662:	6c89                	lui	s9,0x2
    80003664:	a831                	j	80003680 <balloc+0x54>
    brelse(bp);
    80003666:	854a                	mv	a0,s2
    80003668:	00000097          	auipc	ra,0x0
    8000366c:	e32080e7          	jalr	-462(ra) # 8000349a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003670:	015c87bb          	addw	a5,s9,s5
    80003674:	00078a9b          	sext.w	s5,a5
    80003678:	004b2703          	lw	a4,4(s6)
    8000367c:	06eaf363          	bgeu	s5,a4,800036e2 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80003680:	41fad79b          	sraiw	a5,s5,0x1f
    80003684:	0137d79b          	srliw	a5,a5,0x13
    80003688:	015787bb          	addw	a5,a5,s5
    8000368c:	40d7d79b          	sraiw	a5,a5,0xd
    80003690:	01cb2583          	lw	a1,28(s6)
    80003694:	9dbd                	addw	a1,a1,a5
    80003696:	855e                	mv	a0,s7
    80003698:	00000097          	auipc	ra,0x0
    8000369c:	cd2080e7          	jalr	-814(ra) # 8000336a <bread>
    800036a0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036a2:	004b2503          	lw	a0,4(s6)
    800036a6:	000a849b          	sext.w	s1,s5
    800036aa:	8662                	mv	a2,s8
    800036ac:	faa4fde3          	bgeu	s1,a0,80003666 <balloc+0x3a>
      m = 1 << (bi % 8);
    800036b0:	41f6579b          	sraiw	a5,a2,0x1f
    800036b4:	01d7d69b          	srliw	a3,a5,0x1d
    800036b8:	00c6873b          	addw	a4,a3,a2
    800036bc:	00777793          	andi	a5,a4,7
    800036c0:	9f95                	subw	a5,a5,a3
    800036c2:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800036c6:	4037571b          	sraiw	a4,a4,0x3
    800036ca:	00e906b3          	add	a3,s2,a4
    800036ce:	0586c683          	lbu	a3,88(a3) # 1058 <_entry-0x7fffefa8>
    800036d2:	00d7f5b3          	and	a1,a5,a3
    800036d6:	cd91                	beqz	a1,800036f2 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036d8:	2605                	addiw	a2,a2,1
    800036da:	2485                	addiw	s1,s1,1
    800036dc:	fd4618e3          	bne	a2,s4,800036ac <balloc+0x80>
    800036e0:	b759                	j	80003666 <balloc+0x3a>
  panic("balloc: out of blocks");
    800036e2:	00005517          	auipc	a0,0x5
    800036e6:	f3650513          	addi	a0,a0,-202 # 80008618 <syscalls+0x118>
    800036ea:	ffffd097          	auipc	ra,0xffffd
    800036ee:	e40080e7          	jalr	-448(ra) # 8000052a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800036f2:	974a                	add	a4,a4,s2
    800036f4:	8fd5                	or	a5,a5,a3
    800036f6:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800036fa:	854a                	mv	a0,s2
    800036fc:	00001097          	auipc	ra,0x1
    80003700:	020080e7          	jalr	32(ra) # 8000471c <log_write>
        brelse(bp);
    80003704:	854a                	mv	a0,s2
    80003706:	00000097          	auipc	ra,0x0
    8000370a:	d94080e7          	jalr	-620(ra) # 8000349a <brelse>
  bp = bread(dev, bno);
    8000370e:	85a6                	mv	a1,s1
    80003710:	855e                	mv	a0,s7
    80003712:	00000097          	auipc	ra,0x0
    80003716:	c58080e7          	jalr	-936(ra) # 8000336a <bread>
    8000371a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000371c:	40000613          	li	a2,1024
    80003720:	4581                	li	a1,0
    80003722:	05850513          	addi	a0,a0,88
    80003726:	ffffd097          	auipc	ra,0xffffd
    8000372a:	598080e7          	jalr	1432(ra) # 80000cbe <memset>
  log_write(bp);
    8000372e:	854a                	mv	a0,s2
    80003730:	00001097          	auipc	ra,0x1
    80003734:	fec080e7          	jalr	-20(ra) # 8000471c <log_write>
  brelse(bp);
    80003738:	854a                	mv	a0,s2
    8000373a:	00000097          	auipc	ra,0x0
    8000373e:	d60080e7          	jalr	-672(ra) # 8000349a <brelse>
}
    80003742:	8526                	mv	a0,s1
    80003744:	60e6                	ld	ra,88(sp)
    80003746:	6446                	ld	s0,80(sp)
    80003748:	64a6                	ld	s1,72(sp)
    8000374a:	6906                	ld	s2,64(sp)
    8000374c:	79e2                	ld	s3,56(sp)
    8000374e:	7a42                	ld	s4,48(sp)
    80003750:	7aa2                	ld	s5,40(sp)
    80003752:	7b02                	ld	s6,32(sp)
    80003754:	6be2                	ld	s7,24(sp)
    80003756:	6c42                	ld	s8,16(sp)
    80003758:	6ca2                	ld	s9,8(sp)
    8000375a:	6125                	addi	sp,sp,96
    8000375c:	8082                	ret

000000008000375e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000375e:	7179                	addi	sp,sp,-48
    80003760:	f406                	sd	ra,40(sp)
    80003762:	f022                	sd	s0,32(sp)
    80003764:	ec26                	sd	s1,24(sp)
    80003766:	e84a                	sd	s2,16(sp)
    80003768:	e44e                	sd	s3,8(sp)
    8000376a:	e052                	sd	s4,0(sp)
    8000376c:	1800                	addi	s0,sp,48
    8000376e:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003770:	47ad                	li	a5,11
    80003772:	04b7fe63          	bgeu	a5,a1,800037ce <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003776:	ff45849b          	addiw	s1,a1,-12
    8000377a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000377e:	0ff00793          	li	a5,255
    80003782:	0ae7e463          	bltu	a5,a4,8000382a <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003786:	08052583          	lw	a1,128(a0)
    8000378a:	c5b5                	beqz	a1,800037f6 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000378c:	00092503          	lw	a0,0(s2)
    80003790:	00000097          	auipc	ra,0x0
    80003794:	bda080e7          	jalr	-1062(ra) # 8000336a <bread>
    80003798:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000379a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000379e:	02049713          	slli	a4,s1,0x20
    800037a2:	01e75593          	srli	a1,a4,0x1e
    800037a6:	00b784b3          	add	s1,a5,a1
    800037aa:	0004a983          	lw	s3,0(s1)
    800037ae:	04098e63          	beqz	s3,8000380a <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800037b2:	8552                	mv	a0,s4
    800037b4:	00000097          	auipc	ra,0x0
    800037b8:	ce6080e7          	jalr	-794(ra) # 8000349a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800037bc:	854e                	mv	a0,s3
    800037be:	70a2                	ld	ra,40(sp)
    800037c0:	7402                	ld	s0,32(sp)
    800037c2:	64e2                	ld	s1,24(sp)
    800037c4:	6942                	ld	s2,16(sp)
    800037c6:	69a2                	ld	s3,8(sp)
    800037c8:	6a02                	ld	s4,0(sp)
    800037ca:	6145                	addi	sp,sp,48
    800037cc:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800037ce:	02059793          	slli	a5,a1,0x20
    800037d2:	01e7d593          	srli	a1,a5,0x1e
    800037d6:	00b504b3          	add	s1,a0,a1
    800037da:	0504a983          	lw	s3,80(s1)
    800037de:	fc099fe3          	bnez	s3,800037bc <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800037e2:	4108                	lw	a0,0(a0)
    800037e4:	00000097          	auipc	ra,0x0
    800037e8:	e48080e7          	jalr	-440(ra) # 8000362c <balloc>
    800037ec:	0005099b          	sext.w	s3,a0
    800037f0:	0534a823          	sw	s3,80(s1)
    800037f4:	b7e1                	j	800037bc <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800037f6:	4108                	lw	a0,0(a0)
    800037f8:	00000097          	auipc	ra,0x0
    800037fc:	e34080e7          	jalr	-460(ra) # 8000362c <balloc>
    80003800:	0005059b          	sext.w	a1,a0
    80003804:	08b92023          	sw	a1,128(s2)
    80003808:	b751                	j	8000378c <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000380a:	00092503          	lw	a0,0(s2)
    8000380e:	00000097          	auipc	ra,0x0
    80003812:	e1e080e7          	jalr	-482(ra) # 8000362c <balloc>
    80003816:	0005099b          	sext.w	s3,a0
    8000381a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000381e:	8552                	mv	a0,s4
    80003820:	00001097          	auipc	ra,0x1
    80003824:	efc080e7          	jalr	-260(ra) # 8000471c <log_write>
    80003828:	b769                	j	800037b2 <bmap+0x54>
  panic("bmap: out of range");
    8000382a:	00005517          	auipc	a0,0x5
    8000382e:	e0650513          	addi	a0,a0,-506 # 80008630 <syscalls+0x130>
    80003832:	ffffd097          	auipc	ra,0xffffd
    80003836:	cf8080e7          	jalr	-776(ra) # 8000052a <panic>

000000008000383a <iget>:
{
    8000383a:	7179                	addi	sp,sp,-48
    8000383c:	f406                	sd	ra,40(sp)
    8000383e:	f022                	sd	s0,32(sp)
    80003840:	ec26                	sd	s1,24(sp)
    80003842:	e84a                	sd	s2,16(sp)
    80003844:	e44e                	sd	s3,8(sp)
    80003846:	e052                	sd	s4,0(sp)
    80003848:	1800                	addi	s0,sp,48
    8000384a:	89aa                	mv	s3,a0
    8000384c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000384e:	00022517          	auipc	a0,0x22
    80003852:	77a50513          	addi	a0,a0,1914 # 80025fc8 <itable>
    80003856:	ffffd097          	auipc	ra,0xffffd
    8000385a:	36c080e7          	jalr	876(ra) # 80000bc2 <acquire>
  empty = 0;
    8000385e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003860:	00022497          	auipc	s1,0x22
    80003864:	78048493          	addi	s1,s1,1920 # 80025fe0 <itable+0x18>
    80003868:	00024697          	auipc	a3,0x24
    8000386c:	20868693          	addi	a3,a3,520 # 80027a70 <log>
    80003870:	a039                	j	8000387e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003872:	02090b63          	beqz	s2,800038a8 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003876:	08848493          	addi	s1,s1,136
    8000387a:	02d48a63          	beq	s1,a3,800038ae <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000387e:	449c                	lw	a5,8(s1)
    80003880:	fef059e3          	blez	a5,80003872 <iget+0x38>
    80003884:	4098                	lw	a4,0(s1)
    80003886:	ff3716e3          	bne	a4,s3,80003872 <iget+0x38>
    8000388a:	40d8                	lw	a4,4(s1)
    8000388c:	ff4713e3          	bne	a4,s4,80003872 <iget+0x38>
      ip->ref++;
    80003890:	2785                	addiw	a5,a5,1
    80003892:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003894:	00022517          	auipc	a0,0x22
    80003898:	73450513          	addi	a0,a0,1844 # 80025fc8 <itable>
    8000389c:	ffffd097          	auipc	ra,0xffffd
    800038a0:	3da080e7          	jalr	986(ra) # 80000c76 <release>
      return ip;
    800038a4:	8926                	mv	s2,s1
    800038a6:	a03d                	j	800038d4 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800038a8:	f7f9                	bnez	a5,80003876 <iget+0x3c>
    800038aa:	8926                	mv	s2,s1
    800038ac:	b7e9                	j	80003876 <iget+0x3c>
  if(empty == 0)
    800038ae:	02090c63          	beqz	s2,800038e6 <iget+0xac>
  ip->dev = dev;
    800038b2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800038b6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800038ba:	4785                	li	a5,1
    800038bc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800038c0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800038c4:	00022517          	auipc	a0,0x22
    800038c8:	70450513          	addi	a0,a0,1796 # 80025fc8 <itable>
    800038cc:	ffffd097          	auipc	ra,0xffffd
    800038d0:	3aa080e7          	jalr	938(ra) # 80000c76 <release>
}
    800038d4:	854a                	mv	a0,s2
    800038d6:	70a2                	ld	ra,40(sp)
    800038d8:	7402                	ld	s0,32(sp)
    800038da:	64e2                	ld	s1,24(sp)
    800038dc:	6942                	ld	s2,16(sp)
    800038de:	69a2                	ld	s3,8(sp)
    800038e0:	6a02                	ld	s4,0(sp)
    800038e2:	6145                	addi	sp,sp,48
    800038e4:	8082                	ret
    panic("iget: no inodes");
    800038e6:	00005517          	auipc	a0,0x5
    800038ea:	d6250513          	addi	a0,a0,-670 # 80008648 <syscalls+0x148>
    800038ee:	ffffd097          	auipc	ra,0xffffd
    800038f2:	c3c080e7          	jalr	-964(ra) # 8000052a <panic>

00000000800038f6 <fsinit>:
fsinit(int dev) {
    800038f6:	7179                	addi	sp,sp,-48
    800038f8:	f406                	sd	ra,40(sp)
    800038fa:	f022                	sd	s0,32(sp)
    800038fc:	ec26                	sd	s1,24(sp)
    800038fe:	e84a                	sd	s2,16(sp)
    80003900:	e44e                	sd	s3,8(sp)
    80003902:	1800                	addi	s0,sp,48
    80003904:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003906:	4585                	li	a1,1
    80003908:	00000097          	auipc	ra,0x0
    8000390c:	a62080e7          	jalr	-1438(ra) # 8000336a <bread>
    80003910:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003912:	00022997          	auipc	s3,0x22
    80003916:	69698993          	addi	s3,s3,1686 # 80025fa8 <sb>
    8000391a:	02000613          	li	a2,32
    8000391e:	05850593          	addi	a1,a0,88
    80003922:	854e                	mv	a0,s3
    80003924:	ffffd097          	auipc	ra,0xffffd
    80003928:	3f6080e7          	jalr	1014(ra) # 80000d1a <memmove>
  brelse(bp);
    8000392c:	8526                	mv	a0,s1
    8000392e:	00000097          	auipc	ra,0x0
    80003932:	b6c080e7          	jalr	-1172(ra) # 8000349a <brelse>
  if(sb.magic != FSMAGIC)
    80003936:	0009a703          	lw	a4,0(s3)
    8000393a:	102037b7          	lui	a5,0x10203
    8000393e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003942:	02f71263          	bne	a4,a5,80003966 <fsinit+0x70>
  initlog(dev, &sb);
    80003946:	00022597          	auipc	a1,0x22
    8000394a:	66258593          	addi	a1,a1,1634 # 80025fa8 <sb>
    8000394e:	854a                	mv	a0,s2
    80003950:	00001097          	auipc	ra,0x1
    80003954:	b4e080e7          	jalr	-1202(ra) # 8000449e <initlog>
}
    80003958:	70a2                	ld	ra,40(sp)
    8000395a:	7402                	ld	s0,32(sp)
    8000395c:	64e2                	ld	s1,24(sp)
    8000395e:	6942                	ld	s2,16(sp)
    80003960:	69a2                	ld	s3,8(sp)
    80003962:	6145                	addi	sp,sp,48
    80003964:	8082                	ret
    panic("invalid file system");
    80003966:	00005517          	auipc	a0,0x5
    8000396a:	cf250513          	addi	a0,a0,-782 # 80008658 <syscalls+0x158>
    8000396e:	ffffd097          	auipc	ra,0xffffd
    80003972:	bbc080e7          	jalr	-1092(ra) # 8000052a <panic>

0000000080003976 <iinit>:
{
    80003976:	7179                	addi	sp,sp,-48
    80003978:	f406                	sd	ra,40(sp)
    8000397a:	f022                	sd	s0,32(sp)
    8000397c:	ec26                	sd	s1,24(sp)
    8000397e:	e84a                	sd	s2,16(sp)
    80003980:	e44e                	sd	s3,8(sp)
    80003982:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003984:	00005597          	auipc	a1,0x5
    80003988:	cec58593          	addi	a1,a1,-788 # 80008670 <syscalls+0x170>
    8000398c:	00022517          	auipc	a0,0x22
    80003990:	63c50513          	addi	a0,a0,1596 # 80025fc8 <itable>
    80003994:	ffffd097          	auipc	ra,0xffffd
    80003998:	19e080e7          	jalr	414(ra) # 80000b32 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000399c:	00022497          	auipc	s1,0x22
    800039a0:	65448493          	addi	s1,s1,1620 # 80025ff0 <itable+0x28>
    800039a4:	00024997          	auipc	s3,0x24
    800039a8:	0dc98993          	addi	s3,s3,220 # 80027a80 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800039ac:	00005917          	auipc	s2,0x5
    800039b0:	ccc90913          	addi	s2,s2,-820 # 80008678 <syscalls+0x178>
    800039b4:	85ca                	mv	a1,s2
    800039b6:	8526                	mv	a0,s1
    800039b8:	00001097          	auipc	ra,0x1
    800039bc:	e4a080e7          	jalr	-438(ra) # 80004802 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800039c0:	08848493          	addi	s1,s1,136
    800039c4:	ff3498e3          	bne	s1,s3,800039b4 <iinit+0x3e>
}
    800039c8:	70a2                	ld	ra,40(sp)
    800039ca:	7402                	ld	s0,32(sp)
    800039cc:	64e2                	ld	s1,24(sp)
    800039ce:	6942                	ld	s2,16(sp)
    800039d0:	69a2                	ld	s3,8(sp)
    800039d2:	6145                	addi	sp,sp,48
    800039d4:	8082                	ret

00000000800039d6 <ialloc>:
{
    800039d6:	715d                	addi	sp,sp,-80
    800039d8:	e486                	sd	ra,72(sp)
    800039da:	e0a2                	sd	s0,64(sp)
    800039dc:	fc26                	sd	s1,56(sp)
    800039de:	f84a                	sd	s2,48(sp)
    800039e0:	f44e                	sd	s3,40(sp)
    800039e2:	f052                	sd	s4,32(sp)
    800039e4:	ec56                	sd	s5,24(sp)
    800039e6:	e85a                	sd	s6,16(sp)
    800039e8:	e45e                	sd	s7,8(sp)
    800039ea:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800039ec:	00022717          	auipc	a4,0x22
    800039f0:	5c872703          	lw	a4,1480(a4) # 80025fb4 <sb+0xc>
    800039f4:	4785                	li	a5,1
    800039f6:	04e7fa63          	bgeu	a5,a4,80003a4a <ialloc+0x74>
    800039fa:	8aaa                	mv	s5,a0
    800039fc:	8bae                	mv	s7,a1
    800039fe:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003a00:	00022a17          	auipc	s4,0x22
    80003a04:	5a8a0a13          	addi	s4,s4,1448 # 80025fa8 <sb>
    80003a08:	00048b1b          	sext.w	s6,s1
    80003a0c:	0044d793          	srli	a5,s1,0x4
    80003a10:	018a2583          	lw	a1,24(s4)
    80003a14:	9dbd                	addw	a1,a1,a5
    80003a16:	8556                	mv	a0,s5
    80003a18:	00000097          	auipc	ra,0x0
    80003a1c:	952080e7          	jalr	-1710(ra) # 8000336a <bread>
    80003a20:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003a22:	05850993          	addi	s3,a0,88
    80003a26:	00f4f793          	andi	a5,s1,15
    80003a2a:	079a                	slli	a5,a5,0x6
    80003a2c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003a2e:	00099783          	lh	a5,0(s3)
    80003a32:	c785                	beqz	a5,80003a5a <ialloc+0x84>
    brelse(bp);
    80003a34:	00000097          	auipc	ra,0x0
    80003a38:	a66080e7          	jalr	-1434(ra) # 8000349a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a3c:	0485                	addi	s1,s1,1
    80003a3e:	00ca2703          	lw	a4,12(s4)
    80003a42:	0004879b          	sext.w	a5,s1
    80003a46:	fce7e1e3          	bltu	a5,a4,80003a08 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003a4a:	00005517          	auipc	a0,0x5
    80003a4e:	c3650513          	addi	a0,a0,-970 # 80008680 <syscalls+0x180>
    80003a52:	ffffd097          	auipc	ra,0xffffd
    80003a56:	ad8080e7          	jalr	-1320(ra) # 8000052a <panic>
      memset(dip, 0, sizeof(*dip));
    80003a5a:	04000613          	li	a2,64
    80003a5e:	4581                	li	a1,0
    80003a60:	854e                	mv	a0,s3
    80003a62:	ffffd097          	auipc	ra,0xffffd
    80003a66:	25c080e7          	jalr	604(ra) # 80000cbe <memset>
      dip->type = type;
    80003a6a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003a6e:	854a                	mv	a0,s2
    80003a70:	00001097          	auipc	ra,0x1
    80003a74:	cac080e7          	jalr	-852(ra) # 8000471c <log_write>
      brelse(bp);
    80003a78:	854a                	mv	a0,s2
    80003a7a:	00000097          	auipc	ra,0x0
    80003a7e:	a20080e7          	jalr	-1504(ra) # 8000349a <brelse>
      return iget(dev, inum);
    80003a82:	85da                	mv	a1,s6
    80003a84:	8556                	mv	a0,s5
    80003a86:	00000097          	auipc	ra,0x0
    80003a8a:	db4080e7          	jalr	-588(ra) # 8000383a <iget>
}
    80003a8e:	60a6                	ld	ra,72(sp)
    80003a90:	6406                	ld	s0,64(sp)
    80003a92:	74e2                	ld	s1,56(sp)
    80003a94:	7942                	ld	s2,48(sp)
    80003a96:	79a2                	ld	s3,40(sp)
    80003a98:	7a02                	ld	s4,32(sp)
    80003a9a:	6ae2                	ld	s5,24(sp)
    80003a9c:	6b42                	ld	s6,16(sp)
    80003a9e:	6ba2                	ld	s7,8(sp)
    80003aa0:	6161                	addi	sp,sp,80
    80003aa2:	8082                	ret

0000000080003aa4 <iupdate>:
{
    80003aa4:	1101                	addi	sp,sp,-32
    80003aa6:	ec06                	sd	ra,24(sp)
    80003aa8:	e822                	sd	s0,16(sp)
    80003aaa:	e426                	sd	s1,8(sp)
    80003aac:	e04a                	sd	s2,0(sp)
    80003aae:	1000                	addi	s0,sp,32
    80003ab0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003ab2:	415c                	lw	a5,4(a0)
    80003ab4:	0047d79b          	srliw	a5,a5,0x4
    80003ab8:	00022597          	auipc	a1,0x22
    80003abc:	5085a583          	lw	a1,1288(a1) # 80025fc0 <sb+0x18>
    80003ac0:	9dbd                	addw	a1,a1,a5
    80003ac2:	4108                	lw	a0,0(a0)
    80003ac4:	00000097          	auipc	ra,0x0
    80003ac8:	8a6080e7          	jalr	-1882(ra) # 8000336a <bread>
    80003acc:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003ace:	05850793          	addi	a5,a0,88
    80003ad2:	40c8                	lw	a0,4(s1)
    80003ad4:	893d                	andi	a0,a0,15
    80003ad6:	051a                	slli	a0,a0,0x6
    80003ad8:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003ada:	04449703          	lh	a4,68(s1)
    80003ade:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003ae2:	04649703          	lh	a4,70(s1)
    80003ae6:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003aea:	04849703          	lh	a4,72(s1)
    80003aee:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003af2:	04a49703          	lh	a4,74(s1)
    80003af6:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003afa:	44f8                	lw	a4,76(s1)
    80003afc:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003afe:	03400613          	li	a2,52
    80003b02:	05048593          	addi	a1,s1,80
    80003b06:	0531                	addi	a0,a0,12
    80003b08:	ffffd097          	auipc	ra,0xffffd
    80003b0c:	212080e7          	jalr	530(ra) # 80000d1a <memmove>
  log_write(bp);
    80003b10:	854a                	mv	a0,s2
    80003b12:	00001097          	auipc	ra,0x1
    80003b16:	c0a080e7          	jalr	-1014(ra) # 8000471c <log_write>
  brelse(bp);
    80003b1a:	854a                	mv	a0,s2
    80003b1c:	00000097          	auipc	ra,0x0
    80003b20:	97e080e7          	jalr	-1666(ra) # 8000349a <brelse>
}
    80003b24:	60e2                	ld	ra,24(sp)
    80003b26:	6442                	ld	s0,16(sp)
    80003b28:	64a2                	ld	s1,8(sp)
    80003b2a:	6902                	ld	s2,0(sp)
    80003b2c:	6105                	addi	sp,sp,32
    80003b2e:	8082                	ret

0000000080003b30 <idup>:
{
    80003b30:	1101                	addi	sp,sp,-32
    80003b32:	ec06                	sd	ra,24(sp)
    80003b34:	e822                	sd	s0,16(sp)
    80003b36:	e426                	sd	s1,8(sp)
    80003b38:	1000                	addi	s0,sp,32
    80003b3a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003b3c:	00022517          	auipc	a0,0x22
    80003b40:	48c50513          	addi	a0,a0,1164 # 80025fc8 <itable>
    80003b44:	ffffd097          	auipc	ra,0xffffd
    80003b48:	07e080e7          	jalr	126(ra) # 80000bc2 <acquire>
  ip->ref++;
    80003b4c:	449c                	lw	a5,8(s1)
    80003b4e:	2785                	addiw	a5,a5,1
    80003b50:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003b52:	00022517          	auipc	a0,0x22
    80003b56:	47650513          	addi	a0,a0,1142 # 80025fc8 <itable>
    80003b5a:	ffffd097          	auipc	ra,0xffffd
    80003b5e:	11c080e7          	jalr	284(ra) # 80000c76 <release>
}
    80003b62:	8526                	mv	a0,s1
    80003b64:	60e2                	ld	ra,24(sp)
    80003b66:	6442                	ld	s0,16(sp)
    80003b68:	64a2                	ld	s1,8(sp)
    80003b6a:	6105                	addi	sp,sp,32
    80003b6c:	8082                	ret

0000000080003b6e <ilock>:
{
    80003b6e:	1101                	addi	sp,sp,-32
    80003b70:	ec06                	sd	ra,24(sp)
    80003b72:	e822                	sd	s0,16(sp)
    80003b74:	e426                	sd	s1,8(sp)
    80003b76:	e04a                	sd	s2,0(sp)
    80003b78:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003b7a:	c115                	beqz	a0,80003b9e <ilock+0x30>
    80003b7c:	84aa                	mv	s1,a0
    80003b7e:	451c                	lw	a5,8(a0)
    80003b80:	00f05f63          	blez	a5,80003b9e <ilock+0x30>
  acquiresleep(&ip->lock);
    80003b84:	0541                	addi	a0,a0,16
    80003b86:	00001097          	auipc	ra,0x1
    80003b8a:	cb6080e7          	jalr	-842(ra) # 8000483c <acquiresleep>
  if(ip->valid == 0){
    80003b8e:	40bc                	lw	a5,64(s1)
    80003b90:	cf99                	beqz	a5,80003bae <ilock+0x40>
}
    80003b92:	60e2                	ld	ra,24(sp)
    80003b94:	6442                	ld	s0,16(sp)
    80003b96:	64a2                	ld	s1,8(sp)
    80003b98:	6902                	ld	s2,0(sp)
    80003b9a:	6105                	addi	sp,sp,32
    80003b9c:	8082                	ret
    panic("ilock");
    80003b9e:	00005517          	auipc	a0,0x5
    80003ba2:	afa50513          	addi	a0,a0,-1286 # 80008698 <syscalls+0x198>
    80003ba6:	ffffd097          	auipc	ra,0xffffd
    80003baa:	984080e7          	jalr	-1660(ra) # 8000052a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003bae:	40dc                	lw	a5,4(s1)
    80003bb0:	0047d79b          	srliw	a5,a5,0x4
    80003bb4:	00022597          	auipc	a1,0x22
    80003bb8:	40c5a583          	lw	a1,1036(a1) # 80025fc0 <sb+0x18>
    80003bbc:	9dbd                	addw	a1,a1,a5
    80003bbe:	4088                	lw	a0,0(s1)
    80003bc0:	fffff097          	auipc	ra,0xfffff
    80003bc4:	7aa080e7          	jalr	1962(ra) # 8000336a <bread>
    80003bc8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003bca:	05850593          	addi	a1,a0,88
    80003bce:	40dc                	lw	a5,4(s1)
    80003bd0:	8bbd                	andi	a5,a5,15
    80003bd2:	079a                	slli	a5,a5,0x6
    80003bd4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003bd6:	00059783          	lh	a5,0(a1)
    80003bda:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003bde:	00259783          	lh	a5,2(a1)
    80003be2:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003be6:	00459783          	lh	a5,4(a1)
    80003bea:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003bee:	00659783          	lh	a5,6(a1)
    80003bf2:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003bf6:	459c                	lw	a5,8(a1)
    80003bf8:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003bfa:	03400613          	li	a2,52
    80003bfe:	05b1                	addi	a1,a1,12
    80003c00:	05048513          	addi	a0,s1,80
    80003c04:	ffffd097          	auipc	ra,0xffffd
    80003c08:	116080e7          	jalr	278(ra) # 80000d1a <memmove>
    brelse(bp);
    80003c0c:	854a                	mv	a0,s2
    80003c0e:	00000097          	auipc	ra,0x0
    80003c12:	88c080e7          	jalr	-1908(ra) # 8000349a <brelse>
    ip->valid = 1;
    80003c16:	4785                	li	a5,1
    80003c18:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003c1a:	04449783          	lh	a5,68(s1)
    80003c1e:	fbb5                	bnez	a5,80003b92 <ilock+0x24>
      panic("ilock: no type");
    80003c20:	00005517          	auipc	a0,0x5
    80003c24:	a8050513          	addi	a0,a0,-1408 # 800086a0 <syscalls+0x1a0>
    80003c28:	ffffd097          	auipc	ra,0xffffd
    80003c2c:	902080e7          	jalr	-1790(ra) # 8000052a <panic>

0000000080003c30 <iunlock>:
{
    80003c30:	1101                	addi	sp,sp,-32
    80003c32:	ec06                	sd	ra,24(sp)
    80003c34:	e822                	sd	s0,16(sp)
    80003c36:	e426                	sd	s1,8(sp)
    80003c38:	e04a                	sd	s2,0(sp)
    80003c3a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003c3c:	c905                	beqz	a0,80003c6c <iunlock+0x3c>
    80003c3e:	84aa                	mv	s1,a0
    80003c40:	01050913          	addi	s2,a0,16
    80003c44:	854a                	mv	a0,s2
    80003c46:	00001097          	auipc	ra,0x1
    80003c4a:	c90080e7          	jalr	-880(ra) # 800048d6 <holdingsleep>
    80003c4e:	cd19                	beqz	a0,80003c6c <iunlock+0x3c>
    80003c50:	449c                	lw	a5,8(s1)
    80003c52:	00f05d63          	blez	a5,80003c6c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003c56:	854a                	mv	a0,s2
    80003c58:	00001097          	auipc	ra,0x1
    80003c5c:	c3a080e7          	jalr	-966(ra) # 80004892 <releasesleep>
}
    80003c60:	60e2                	ld	ra,24(sp)
    80003c62:	6442                	ld	s0,16(sp)
    80003c64:	64a2                	ld	s1,8(sp)
    80003c66:	6902                	ld	s2,0(sp)
    80003c68:	6105                	addi	sp,sp,32
    80003c6a:	8082                	ret
    panic("iunlock");
    80003c6c:	00005517          	auipc	a0,0x5
    80003c70:	a4450513          	addi	a0,a0,-1468 # 800086b0 <syscalls+0x1b0>
    80003c74:	ffffd097          	auipc	ra,0xffffd
    80003c78:	8b6080e7          	jalr	-1866(ra) # 8000052a <panic>

0000000080003c7c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003c7c:	7179                	addi	sp,sp,-48
    80003c7e:	f406                	sd	ra,40(sp)
    80003c80:	f022                	sd	s0,32(sp)
    80003c82:	ec26                	sd	s1,24(sp)
    80003c84:	e84a                	sd	s2,16(sp)
    80003c86:	e44e                	sd	s3,8(sp)
    80003c88:	e052                	sd	s4,0(sp)
    80003c8a:	1800                	addi	s0,sp,48
    80003c8c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003c8e:	05050493          	addi	s1,a0,80
    80003c92:	08050913          	addi	s2,a0,128
    80003c96:	a021                	j	80003c9e <itrunc+0x22>
    80003c98:	0491                	addi	s1,s1,4
    80003c9a:	01248d63          	beq	s1,s2,80003cb4 <itrunc+0x38>
    if(ip->addrs[i]){
    80003c9e:	408c                	lw	a1,0(s1)
    80003ca0:	dde5                	beqz	a1,80003c98 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003ca2:	0009a503          	lw	a0,0(s3)
    80003ca6:	00000097          	auipc	ra,0x0
    80003caa:	90a080e7          	jalr	-1782(ra) # 800035b0 <bfree>
      ip->addrs[i] = 0;
    80003cae:	0004a023          	sw	zero,0(s1)
    80003cb2:	b7dd                	j	80003c98 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003cb4:	0809a583          	lw	a1,128(s3)
    80003cb8:	e185                	bnez	a1,80003cd8 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003cba:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003cbe:	854e                	mv	a0,s3
    80003cc0:	00000097          	auipc	ra,0x0
    80003cc4:	de4080e7          	jalr	-540(ra) # 80003aa4 <iupdate>
}
    80003cc8:	70a2                	ld	ra,40(sp)
    80003cca:	7402                	ld	s0,32(sp)
    80003ccc:	64e2                	ld	s1,24(sp)
    80003cce:	6942                	ld	s2,16(sp)
    80003cd0:	69a2                	ld	s3,8(sp)
    80003cd2:	6a02                	ld	s4,0(sp)
    80003cd4:	6145                	addi	sp,sp,48
    80003cd6:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003cd8:	0009a503          	lw	a0,0(s3)
    80003cdc:	fffff097          	auipc	ra,0xfffff
    80003ce0:	68e080e7          	jalr	1678(ra) # 8000336a <bread>
    80003ce4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003ce6:	05850493          	addi	s1,a0,88
    80003cea:	45850913          	addi	s2,a0,1112
    80003cee:	a021                	j	80003cf6 <itrunc+0x7a>
    80003cf0:	0491                	addi	s1,s1,4
    80003cf2:	01248b63          	beq	s1,s2,80003d08 <itrunc+0x8c>
      if(a[j])
    80003cf6:	408c                	lw	a1,0(s1)
    80003cf8:	dde5                	beqz	a1,80003cf0 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003cfa:	0009a503          	lw	a0,0(s3)
    80003cfe:	00000097          	auipc	ra,0x0
    80003d02:	8b2080e7          	jalr	-1870(ra) # 800035b0 <bfree>
    80003d06:	b7ed                	j	80003cf0 <itrunc+0x74>
    brelse(bp);
    80003d08:	8552                	mv	a0,s4
    80003d0a:	fffff097          	auipc	ra,0xfffff
    80003d0e:	790080e7          	jalr	1936(ra) # 8000349a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003d12:	0809a583          	lw	a1,128(s3)
    80003d16:	0009a503          	lw	a0,0(s3)
    80003d1a:	00000097          	auipc	ra,0x0
    80003d1e:	896080e7          	jalr	-1898(ra) # 800035b0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003d22:	0809a023          	sw	zero,128(s3)
    80003d26:	bf51                	j	80003cba <itrunc+0x3e>

0000000080003d28 <iput>:
{
    80003d28:	1101                	addi	sp,sp,-32
    80003d2a:	ec06                	sd	ra,24(sp)
    80003d2c:	e822                	sd	s0,16(sp)
    80003d2e:	e426                	sd	s1,8(sp)
    80003d30:	e04a                	sd	s2,0(sp)
    80003d32:	1000                	addi	s0,sp,32
    80003d34:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003d36:	00022517          	auipc	a0,0x22
    80003d3a:	29250513          	addi	a0,a0,658 # 80025fc8 <itable>
    80003d3e:	ffffd097          	auipc	ra,0xffffd
    80003d42:	e84080e7          	jalr	-380(ra) # 80000bc2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003d46:	4498                	lw	a4,8(s1)
    80003d48:	4785                	li	a5,1
    80003d4a:	02f70363          	beq	a4,a5,80003d70 <iput+0x48>
  ip->ref--;
    80003d4e:	449c                	lw	a5,8(s1)
    80003d50:	37fd                	addiw	a5,a5,-1
    80003d52:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003d54:	00022517          	auipc	a0,0x22
    80003d58:	27450513          	addi	a0,a0,628 # 80025fc8 <itable>
    80003d5c:	ffffd097          	auipc	ra,0xffffd
    80003d60:	f1a080e7          	jalr	-230(ra) # 80000c76 <release>
}
    80003d64:	60e2                	ld	ra,24(sp)
    80003d66:	6442                	ld	s0,16(sp)
    80003d68:	64a2                	ld	s1,8(sp)
    80003d6a:	6902                	ld	s2,0(sp)
    80003d6c:	6105                	addi	sp,sp,32
    80003d6e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003d70:	40bc                	lw	a5,64(s1)
    80003d72:	dff1                	beqz	a5,80003d4e <iput+0x26>
    80003d74:	04a49783          	lh	a5,74(s1)
    80003d78:	fbf9                	bnez	a5,80003d4e <iput+0x26>
    acquiresleep(&ip->lock);
    80003d7a:	01048913          	addi	s2,s1,16
    80003d7e:	854a                	mv	a0,s2
    80003d80:	00001097          	auipc	ra,0x1
    80003d84:	abc080e7          	jalr	-1348(ra) # 8000483c <acquiresleep>
    release(&itable.lock);
    80003d88:	00022517          	auipc	a0,0x22
    80003d8c:	24050513          	addi	a0,a0,576 # 80025fc8 <itable>
    80003d90:	ffffd097          	auipc	ra,0xffffd
    80003d94:	ee6080e7          	jalr	-282(ra) # 80000c76 <release>
    itrunc(ip);
    80003d98:	8526                	mv	a0,s1
    80003d9a:	00000097          	auipc	ra,0x0
    80003d9e:	ee2080e7          	jalr	-286(ra) # 80003c7c <itrunc>
    ip->type = 0;
    80003da2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003da6:	8526                	mv	a0,s1
    80003da8:	00000097          	auipc	ra,0x0
    80003dac:	cfc080e7          	jalr	-772(ra) # 80003aa4 <iupdate>
    ip->valid = 0;
    80003db0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003db4:	854a                	mv	a0,s2
    80003db6:	00001097          	auipc	ra,0x1
    80003dba:	adc080e7          	jalr	-1316(ra) # 80004892 <releasesleep>
    acquire(&itable.lock);
    80003dbe:	00022517          	auipc	a0,0x22
    80003dc2:	20a50513          	addi	a0,a0,522 # 80025fc8 <itable>
    80003dc6:	ffffd097          	auipc	ra,0xffffd
    80003dca:	dfc080e7          	jalr	-516(ra) # 80000bc2 <acquire>
    80003dce:	b741                	j	80003d4e <iput+0x26>

0000000080003dd0 <iunlockput>:
{
    80003dd0:	1101                	addi	sp,sp,-32
    80003dd2:	ec06                	sd	ra,24(sp)
    80003dd4:	e822                	sd	s0,16(sp)
    80003dd6:	e426                	sd	s1,8(sp)
    80003dd8:	1000                	addi	s0,sp,32
    80003dda:	84aa                	mv	s1,a0
  iunlock(ip);
    80003ddc:	00000097          	auipc	ra,0x0
    80003de0:	e54080e7          	jalr	-428(ra) # 80003c30 <iunlock>
  iput(ip);
    80003de4:	8526                	mv	a0,s1
    80003de6:	00000097          	auipc	ra,0x0
    80003dea:	f42080e7          	jalr	-190(ra) # 80003d28 <iput>
}
    80003dee:	60e2                	ld	ra,24(sp)
    80003df0:	6442                	ld	s0,16(sp)
    80003df2:	64a2                	ld	s1,8(sp)
    80003df4:	6105                	addi	sp,sp,32
    80003df6:	8082                	ret

0000000080003df8 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003df8:	1141                	addi	sp,sp,-16
    80003dfa:	e422                	sd	s0,8(sp)
    80003dfc:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003dfe:	411c                	lw	a5,0(a0)
    80003e00:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003e02:	415c                	lw	a5,4(a0)
    80003e04:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003e06:	04451783          	lh	a5,68(a0)
    80003e0a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003e0e:	04a51783          	lh	a5,74(a0)
    80003e12:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003e16:	04c56783          	lwu	a5,76(a0)
    80003e1a:	e99c                	sd	a5,16(a1)
}
    80003e1c:	6422                	ld	s0,8(sp)
    80003e1e:	0141                	addi	sp,sp,16
    80003e20:	8082                	ret

0000000080003e22 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003e22:	457c                	lw	a5,76(a0)
    80003e24:	0ed7e963          	bltu	a5,a3,80003f16 <readi+0xf4>
{
    80003e28:	7159                	addi	sp,sp,-112
    80003e2a:	f486                	sd	ra,104(sp)
    80003e2c:	f0a2                	sd	s0,96(sp)
    80003e2e:	eca6                	sd	s1,88(sp)
    80003e30:	e8ca                	sd	s2,80(sp)
    80003e32:	e4ce                	sd	s3,72(sp)
    80003e34:	e0d2                	sd	s4,64(sp)
    80003e36:	fc56                	sd	s5,56(sp)
    80003e38:	f85a                	sd	s6,48(sp)
    80003e3a:	f45e                	sd	s7,40(sp)
    80003e3c:	f062                	sd	s8,32(sp)
    80003e3e:	ec66                	sd	s9,24(sp)
    80003e40:	e86a                	sd	s10,16(sp)
    80003e42:	e46e                	sd	s11,8(sp)
    80003e44:	1880                	addi	s0,sp,112
    80003e46:	8baa                	mv	s7,a0
    80003e48:	8c2e                	mv	s8,a1
    80003e4a:	8ab2                	mv	s5,a2
    80003e4c:	84b6                	mv	s1,a3
    80003e4e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003e50:	9f35                	addw	a4,a4,a3
    return 0;
    80003e52:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003e54:	0ad76063          	bltu	a4,a3,80003ef4 <readi+0xd2>
  if(off + n > ip->size)
    80003e58:	00e7f463          	bgeu	a5,a4,80003e60 <readi+0x3e>
    n = ip->size - off;
    80003e5c:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e60:	0a0b0963          	beqz	s6,80003f12 <readi+0xf0>
    80003e64:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e66:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003e6a:	5cfd                	li	s9,-1
    80003e6c:	a82d                	j	80003ea6 <readi+0x84>
    80003e6e:	020a1d93          	slli	s11,s4,0x20
    80003e72:	020ddd93          	srli	s11,s11,0x20
    80003e76:	05890793          	addi	a5,s2,88
    80003e7a:	86ee                	mv	a3,s11
    80003e7c:	963e                	add	a2,a2,a5
    80003e7e:	85d6                	mv	a1,s5
    80003e80:	8562                	mv	a0,s8
    80003e82:	ffffe097          	auipc	ra,0xffffe
    80003e86:	646080e7          	jalr	1606(ra) # 800024c8 <either_copyout>
    80003e8a:	05950d63          	beq	a0,s9,80003ee4 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003e8e:	854a                	mv	a0,s2
    80003e90:	fffff097          	auipc	ra,0xfffff
    80003e94:	60a080e7          	jalr	1546(ra) # 8000349a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e98:	013a09bb          	addw	s3,s4,s3
    80003e9c:	009a04bb          	addw	s1,s4,s1
    80003ea0:	9aee                	add	s5,s5,s11
    80003ea2:	0569f763          	bgeu	s3,s6,80003ef0 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003ea6:	000ba903          	lw	s2,0(s7)
    80003eaa:	00a4d59b          	srliw	a1,s1,0xa
    80003eae:	855e                	mv	a0,s7
    80003eb0:	00000097          	auipc	ra,0x0
    80003eb4:	8ae080e7          	jalr	-1874(ra) # 8000375e <bmap>
    80003eb8:	0005059b          	sext.w	a1,a0
    80003ebc:	854a                	mv	a0,s2
    80003ebe:	fffff097          	auipc	ra,0xfffff
    80003ec2:	4ac080e7          	jalr	1196(ra) # 8000336a <bread>
    80003ec6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ec8:	3ff4f613          	andi	a2,s1,1023
    80003ecc:	40cd07bb          	subw	a5,s10,a2
    80003ed0:	413b073b          	subw	a4,s6,s3
    80003ed4:	8a3e                	mv	s4,a5
    80003ed6:	2781                	sext.w	a5,a5
    80003ed8:	0007069b          	sext.w	a3,a4
    80003edc:	f8f6f9e3          	bgeu	a3,a5,80003e6e <readi+0x4c>
    80003ee0:	8a3a                	mv	s4,a4
    80003ee2:	b771                	j	80003e6e <readi+0x4c>
      brelse(bp);
    80003ee4:	854a                	mv	a0,s2
    80003ee6:	fffff097          	auipc	ra,0xfffff
    80003eea:	5b4080e7          	jalr	1460(ra) # 8000349a <brelse>
      tot = -1;
    80003eee:	59fd                	li	s3,-1
  }
  return tot;
    80003ef0:	0009851b          	sext.w	a0,s3
}
    80003ef4:	70a6                	ld	ra,104(sp)
    80003ef6:	7406                	ld	s0,96(sp)
    80003ef8:	64e6                	ld	s1,88(sp)
    80003efa:	6946                	ld	s2,80(sp)
    80003efc:	69a6                	ld	s3,72(sp)
    80003efe:	6a06                	ld	s4,64(sp)
    80003f00:	7ae2                	ld	s5,56(sp)
    80003f02:	7b42                	ld	s6,48(sp)
    80003f04:	7ba2                	ld	s7,40(sp)
    80003f06:	7c02                	ld	s8,32(sp)
    80003f08:	6ce2                	ld	s9,24(sp)
    80003f0a:	6d42                	ld	s10,16(sp)
    80003f0c:	6da2                	ld	s11,8(sp)
    80003f0e:	6165                	addi	sp,sp,112
    80003f10:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f12:	89da                	mv	s3,s6
    80003f14:	bff1                	j	80003ef0 <readi+0xce>
    return 0;
    80003f16:	4501                	li	a0,0
}
    80003f18:	8082                	ret

0000000080003f1a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f1a:	457c                	lw	a5,76(a0)
    80003f1c:	10d7e863          	bltu	a5,a3,8000402c <writei+0x112>
{
    80003f20:	7159                	addi	sp,sp,-112
    80003f22:	f486                	sd	ra,104(sp)
    80003f24:	f0a2                	sd	s0,96(sp)
    80003f26:	eca6                	sd	s1,88(sp)
    80003f28:	e8ca                	sd	s2,80(sp)
    80003f2a:	e4ce                	sd	s3,72(sp)
    80003f2c:	e0d2                	sd	s4,64(sp)
    80003f2e:	fc56                	sd	s5,56(sp)
    80003f30:	f85a                	sd	s6,48(sp)
    80003f32:	f45e                	sd	s7,40(sp)
    80003f34:	f062                	sd	s8,32(sp)
    80003f36:	ec66                	sd	s9,24(sp)
    80003f38:	e86a                	sd	s10,16(sp)
    80003f3a:	e46e                	sd	s11,8(sp)
    80003f3c:	1880                	addi	s0,sp,112
    80003f3e:	8b2a                	mv	s6,a0
    80003f40:	8c2e                	mv	s8,a1
    80003f42:	8ab2                	mv	s5,a2
    80003f44:	8936                	mv	s2,a3
    80003f46:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003f48:	00e687bb          	addw	a5,a3,a4
    80003f4c:	0ed7e263          	bltu	a5,a3,80004030 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003f50:	00043737          	lui	a4,0x43
    80003f54:	0ef76063          	bltu	a4,a5,80004034 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f58:	0c0b8863          	beqz	s7,80004028 <writei+0x10e>
    80003f5c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f5e:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003f62:	5cfd                	li	s9,-1
    80003f64:	a091                	j	80003fa8 <writei+0x8e>
    80003f66:	02099d93          	slli	s11,s3,0x20
    80003f6a:	020ddd93          	srli	s11,s11,0x20
    80003f6e:	05848793          	addi	a5,s1,88
    80003f72:	86ee                	mv	a3,s11
    80003f74:	8656                	mv	a2,s5
    80003f76:	85e2                	mv	a1,s8
    80003f78:	953e                	add	a0,a0,a5
    80003f7a:	ffffe097          	auipc	ra,0xffffe
    80003f7e:	5a4080e7          	jalr	1444(ra) # 8000251e <either_copyin>
    80003f82:	07950263          	beq	a0,s9,80003fe6 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003f86:	8526                	mv	a0,s1
    80003f88:	00000097          	auipc	ra,0x0
    80003f8c:	794080e7          	jalr	1940(ra) # 8000471c <log_write>
    brelse(bp);
    80003f90:	8526                	mv	a0,s1
    80003f92:	fffff097          	auipc	ra,0xfffff
    80003f96:	508080e7          	jalr	1288(ra) # 8000349a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f9a:	01498a3b          	addw	s4,s3,s4
    80003f9e:	0129893b          	addw	s2,s3,s2
    80003fa2:	9aee                	add	s5,s5,s11
    80003fa4:	057a7663          	bgeu	s4,s7,80003ff0 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003fa8:	000b2483          	lw	s1,0(s6)
    80003fac:	00a9559b          	srliw	a1,s2,0xa
    80003fb0:	855a                	mv	a0,s6
    80003fb2:	fffff097          	auipc	ra,0xfffff
    80003fb6:	7ac080e7          	jalr	1964(ra) # 8000375e <bmap>
    80003fba:	0005059b          	sext.w	a1,a0
    80003fbe:	8526                	mv	a0,s1
    80003fc0:	fffff097          	auipc	ra,0xfffff
    80003fc4:	3aa080e7          	jalr	938(ra) # 8000336a <bread>
    80003fc8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fca:	3ff97513          	andi	a0,s2,1023
    80003fce:	40ad07bb          	subw	a5,s10,a0
    80003fd2:	414b873b          	subw	a4,s7,s4
    80003fd6:	89be                	mv	s3,a5
    80003fd8:	2781                	sext.w	a5,a5
    80003fda:	0007069b          	sext.w	a3,a4
    80003fde:	f8f6f4e3          	bgeu	a3,a5,80003f66 <writei+0x4c>
    80003fe2:	89ba                	mv	s3,a4
    80003fe4:	b749                	j	80003f66 <writei+0x4c>
      brelse(bp);
    80003fe6:	8526                	mv	a0,s1
    80003fe8:	fffff097          	auipc	ra,0xfffff
    80003fec:	4b2080e7          	jalr	1202(ra) # 8000349a <brelse>
  }

  if(off > ip->size)
    80003ff0:	04cb2783          	lw	a5,76(s6)
    80003ff4:	0127f463          	bgeu	a5,s2,80003ffc <writei+0xe2>
    ip->size = off;
    80003ff8:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003ffc:	855a                	mv	a0,s6
    80003ffe:	00000097          	auipc	ra,0x0
    80004002:	aa6080e7          	jalr	-1370(ra) # 80003aa4 <iupdate>

  return tot;
    80004006:	000a051b          	sext.w	a0,s4
}
    8000400a:	70a6                	ld	ra,104(sp)
    8000400c:	7406                	ld	s0,96(sp)
    8000400e:	64e6                	ld	s1,88(sp)
    80004010:	6946                	ld	s2,80(sp)
    80004012:	69a6                	ld	s3,72(sp)
    80004014:	6a06                	ld	s4,64(sp)
    80004016:	7ae2                	ld	s5,56(sp)
    80004018:	7b42                	ld	s6,48(sp)
    8000401a:	7ba2                	ld	s7,40(sp)
    8000401c:	7c02                	ld	s8,32(sp)
    8000401e:	6ce2                	ld	s9,24(sp)
    80004020:	6d42                	ld	s10,16(sp)
    80004022:	6da2                	ld	s11,8(sp)
    80004024:	6165                	addi	sp,sp,112
    80004026:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004028:	8a5e                	mv	s4,s7
    8000402a:	bfc9                	j	80003ffc <writei+0xe2>
    return -1;
    8000402c:	557d                	li	a0,-1
}
    8000402e:	8082                	ret
    return -1;
    80004030:	557d                	li	a0,-1
    80004032:	bfe1                	j	8000400a <writei+0xf0>
    return -1;
    80004034:	557d                	li	a0,-1
    80004036:	bfd1                	j	8000400a <writei+0xf0>

0000000080004038 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004038:	1141                	addi	sp,sp,-16
    8000403a:	e406                	sd	ra,8(sp)
    8000403c:	e022                	sd	s0,0(sp)
    8000403e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004040:	4639                	li	a2,14
    80004042:	ffffd097          	auipc	ra,0xffffd
    80004046:	d54080e7          	jalr	-684(ra) # 80000d96 <strncmp>
}
    8000404a:	60a2                	ld	ra,8(sp)
    8000404c:	6402                	ld	s0,0(sp)
    8000404e:	0141                	addi	sp,sp,16
    80004050:	8082                	ret

0000000080004052 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004052:	7139                	addi	sp,sp,-64
    80004054:	fc06                	sd	ra,56(sp)
    80004056:	f822                	sd	s0,48(sp)
    80004058:	f426                	sd	s1,40(sp)
    8000405a:	f04a                	sd	s2,32(sp)
    8000405c:	ec4e                	sd	s3,24(sp)
    8000405e:	e852                	sd	s4,16(sp)
    80004060:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004062:	04451703          	lh	a4,68(a0)
    80004066:	4785                	li	a5,1
    80004068:	00f71a63          	bne	a4,a5,8000407c <dirlookup+0x2a>
    8000406c:	892a                	mv	s2,a0
    8000406e:	89ae                	mv	s3,a1
    80004070:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004072:	457c                	lw	a5,76(a0)
    80004074:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004076:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004078:	e79d                	bnez	a5,800040a6 <dirlookup+0x54>
    8000407a:	a8a5                	j	800040f2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000407c:	00004517          	auipc	a0,0x4
    80004080:	63c50513          	addi	a0,a0,1596 # 800086b8 <syscalls+0x1b8>
    80004084:	ffffc097          	auipc	ra,0xffffc
    80004088:	4a6080e7          	jalr	1190(ra) # 8000052a <panic>
      panic("dirlookup read");
    8000408c:	00004517          	auipc	a0,0x4
    80004090:	64450513          	addi	a0,a0,1604 # 800086d0 <syscalls+0x1d0>
    80004094:	ffffc097          	auipc	ra,0xffffc
    80004098:	496080e7          	jalr	1174(ra) # 8000052a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000409c:	24c1                	addiw	s1,s1,16
    8000409e:	04c92783          	lw	a5,76(s2)
    800040a2:	04f4f763          	bgeu	s1,a5,800040f0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800040a6:	4741                	li	a4,16
    800040a8:	86a6                	mv	a3,s1
    800040aa:	fc040613          	addi	a2,s0,-64
    800040ae:	4581                	li	a1,0
    800040b0:	854a                	mv	a0,s2
    800040b2:	00000097          	auipc	ra,0x0
    800040b6:	d70080e7          	jalr	-656(ra) # 80003e22 <readi>
    800040ba:	47c1                	li	a5,16
    800040bc:	fcf518e3          	bne	a0,a5,8000408c <dirlookup+0x3a>
    if(de.inum == 0)
    800040c0:	fc045783          	lhu	a5,-64(s0)
    800040c4:	dfe1                	beqz	a5,8000409c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800040c6:	fc240593          	addi	a1,s0,-62
    800040ca:	854e                	mv	a0,s3
    800040cc:	00000097          	auipc	ra,0x0
    800040d0:	f6c080e7          	jalr	-148(ra) # 80004038 <namecmp>
    800040d4:	f561                	bnez	a0,8000409c <dirlookup+0x4a>
      if(poff)
    800040d6:	000a0463          	beqz	s4,800040de <dirlookup+0x8c>
        *poff = off;
    800040da:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800040de:	fc045583          	lhu	a1,-64(s0)
    800040e2:	00092503          	lw	a0,0(s2)
    800040e6:	fffff097          	auipc	ra,0xfffff
    800040ea:	754080e7          	jalr	1876(ra) # 8000383a <iget>
    800040ee:	a011                	j	800040f2 <dirlookup+0xa0>
  return 0;
    800040f0:	4501                	li	a0,0
}
    800040f2:	70e2                	ld	ra,56(sp)
    800040f4:	7442                	ld	s0,48(sp)
    800040f6:	74a2                	ld	s1,40(sp)
    800040f8:	7902                	ld	s2,32(sp)
    800040fa:	69e2                	ld	s3,24(sp)
    800040fc:	6a42                	ld	s4,16(sp)
    800040fe:	6121                	addi	sp,sp,64
    80004100:	8082                	ret

0000000080004102 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004102:	711d                	addi	sp,sp,-96
    80004104:	ec86                	sd	ra,88(sp)
    80004106:	e8a2                	sd	s0,80(sp)
    80004108:	e4a6                	sd	s1,72(sp)
    8000410a:	e0ca                	sd	s2,64(sp)
    8000410c:	fc4e                	sd	s3,56(sp)
    8000410e:	f852                	sd	s4,48(sp)
    80004110:	f456                	sd	s5,40(sp)
    80004112:	f05a                	sd	s6,32(sp)
    80004114:	ec5e                	sd	s7,24(sp)
    80004116:	e862                	sd	s8,16(sp)
    80004118:	e466                	sd	s9,8(sp)
    8000411a:	1080                	addi	s0,sp,96
    8000411c:	84aa                	mv	s1,a0
    8000411e:	8aae                	mv	s5,a1
    80004120:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004122:	00054703          	lbu	a4,0(a0)
    80004126:	02f00793          	li	a5,47
    8000412a:	02f70363          	beq	a4,a5,80004150 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000412e:	ffffe097          	auipc	ra,0xffffe
    80004132:	850080e7          	jalr	-1968(ra) # 8000197e <myproc>
    80004136:	15053503          	ld	a0,336(a0)
    8000413a:	00000097          	auipc	ra,0x0
    8000413e:	9f6080e7          	jalr	-1546(ra) # 80003b30 <idup>
    80004142:	89aa                	mv	s3,a0
  while(*path == '/')
    80004144:	02f00913          	li	s2,47
  len = path - s;
    80004148:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    8000414a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000414c:	4b85                	li	s7,1
    8000414e:	a865                	j	80004206 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80004150:	4585                	li	a1,1
    80004152:	4505                	li	a0,1
    80004154:	fffff097          	auipc	ra,0xfffff
    80004158:	6e6080e7          	jalr	1766(ra) # 8000383a <iget>
    8000415c:	89aa                	mv	s3,a0
    8000415e:	b7dd                	j	80004144 <namex+0x42>
      iunlockput(ip);
    80004160:	854e                	mv	a0,s3
    80004162:	00000097          	auipc	ra,0x0
    80004166:	c6e080e7          	jalr	-914(ra) # 80003dd0 <iunlockput>
      return 0;
    8000416a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000416c:	854e                	mv	a0,s3
    8000416e:	60e6                	ld	ra,88(sp)
    80004170:	6446                	ld	s0,80(sp)
    80004172:	64a6                	ld	s1,72(sp)
    80004174:	6906                	ld	s2,64(sp)
    80004176:	79e2                	ld	s3,56(sp)
    80004178:	7a42                	ld	s4,48(sp)
    8000417a:	7aa2                	ld	s5,40(sp)
    8000417c:	7b02                	ld	s6,32(sp)
    8000417e:	6be2                	ld	s7,24(sp)
    80004180:	6c42                	ld	s8,16(sp)
    80004182:	6ca2                	ld	s9,8(sp)
    80004184:	6125                	addi	sp,sp,96
    80004186:	8082                	ret
      iunlock(ip);
    80004188:	854e                	mv	a0,s3
    8000418a:	00000097          	auipc	ra,0x0
    8000418e:	aa6080e7          	jalr	-1370(ra) # 80003c30 <iunlock>
      return ip;
    80004192:	bfe9                	j	8000416c <namex+0x6a>
      iunlockput(ip);
    80004194:	854e                	mv	a0,s3
    80004196:	00000097          	auipc	ra,0x0
    8000419a:	c3a080e7          	jalr	-966(ra) # 80003dd0 <iunlockput>
      return 0;
    8000419e:	89e6                	mv	s3,s9
    800041a0:	b7f1                	j	8000416c <namex+0x6a>
  len = path - s;
    800041a2:	40b48633          	sub	a2,s1,a1
    800041a6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800041aa:	099c5463          	bge	s8,s9,80004232 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800041ae:	4639                	li	a2,14
    800041b0:	8552                	mv	a0,s4
    800041b2:	ffffd097          	auipc	ra,0xffffd
    800041b6:	b68080e7          	jalr	-1176(ra) # 80000d1a <memmove>
  while(*path == '/')
    800041ba:	0004c783          	lbu	a5,0(s1)
    800041be:	01279763          	bne	a5,s2,800041cc <namex+0xca>
    path++;
    800041c2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800041c4:	0004c783          	lbu	a5,0(s1)
    800041c8:	ff278de3          	beq	a5,s2,800041c2 <namex+0xc0>
    ilock(ip);
    800041cc:	854e                	mv	a0,s3
    800041ce:	00000097          	auipc	ra,0x0
    800041d2:	9a0080e7          	jalr	-1632(ra) # 80003b6e <ilock>
    if(ip->type != T_DIR){
    800041d6:	04499783          	lh	a5,68(s3)
    800041da:	f97793e3          	bne	a5,s7,80004160 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800041de:	000a8563          	beqz	s5,800041e8 <namex+0xe6>
    800041e2:	0004c783          	lbu	a5,0(s1)
    800041e6:	d3cd                	beqz	a5,80004188 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800041e8:	865a                	mv	a2,s6
    800041ea:	85d2                	mv	a1,s4
    800041ec:	854e                	mv	a0,s3
    800041ee:	00000097          	auipc	ra,0x0
    800041f2:	e64080e7          	jalr	-412(ra) # 80004052 <dirlookup>
    800041f6:	8caa                	mv	s9,a0
    800041f8:	dd51                	beqz	a0,80004194 <namex+0x92>
    iunlockput(ip);
    800041fa:	854e                	mv	a0,s3
    800041fc:	00000097          	auipc	ra,0x0
    80004200:	bd4080e7          	jalr	-1068(ra) # 80003dd0 <iunlockput>
    ip = next;
    80004204:	89e6                	mv	s3,s9
  while(*path == '/')
    80004206:	0004c783          	lbu	a5,0(s1)
    8000420a:	05279763          	bne	a5,s2,80004258 <namex+0x156>
    path++;
    8000420e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004210:	0004c783          	lbu	a5,0(s1)
    80004214:	ff278de3          	beq	a5,s2,8000420e <namex+0x10c>
  if(*path == 0)
    80004218:	c79d                	beqz	a5,80004246 <namex+0x144>
    path++;
    8000421a:	85a6                	mv	a1,s1
  len = path - s;
    8000421c:	8cda                	mv	s9,s6
    8000421e:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80004220:	01278963          	beq	a5,s2,80004232 <namex+0x130>
    80004224:	dfbd                	beqz	a5,800041a2 <namex+0xa0>
    path++;
    80004226:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80004228:	0004c783          	lbu	a5,0(s1)
    8000422c:	ff279ce3          	bne	a5,s2,80004224 <namex+0x122>
    80004230:	bf8d                	j	800041a2 <namex+0xa0>
    memmove(name, s, len);
    80004232:	2601                	sext.w	a2,a2
    80004234:	8552                	mv	a0,s4
    80004236:	ffffd097          	auipc	ra,0xffffd
    8000423a:	ae4080e7          	jalr	-1308(ra) # 80000d1a <memmove>
    name[len] = 0;
    8000423e:	9cd2                	add	s9,s9,s4
    80004240:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004244:	bf9d                	j	800041ba <namex+0xb8>
  if(nameiparent){
    80004246:	f20a83e3          	beqz	s5,8000416c <namex+0x6a>
    iput(ip);
    8000424a:	854e                	mv	a0,s3
    8000424c:	00000097          	auipc	ra,0x0
    80004250:	adc080e7          	jalr	-1316(ra) # 80003d28 <iput>
    return 0;
    80004254:	4981                	li	s3,0
    80004256:	bf19                	j	8000416c <namex+0x6a>
  if(*path == 0)
    80004258:	d7fd                	beqz	a5,80004246 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000425a:	0004c783          	lbu	a5,0(s1)
    8000425e:	85a6                	mv	a1,s1
    80004260:	b7d1                	j	80004224 <namex+0x122>

0000000080004262 <dirlink>:
{
    80004262:	7139                	addi	sp,sp,-64
    80004264:	fc06                	sd	ra,56(sp)
    80004266:	f822                	sd	s0,48(sp)
    80004268:	f426                	sd	s1,40(sp)
    8000426a:	f04a                	sd	s2,32(sp)
    8000426c:	ec4e                	sd	s3,24(sp)
    8000426e:	e852                	sd	s4,16(sp)
    80004270:	0080                	addi	s0,sp,64
    80004272:	892a                	mv	s2,a0
    80004274:	8a2e                	mv	s4,a1
    80004276:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004278:	4601                	li	a2,0
    8000427a:	00000097          	auipc	ra,0x0
    8000427e:	dd8080e7          	jalr	-552(ra) # 80004052 <dirlookup>
    80004282:	e93d                	bnez	a0,800042f8 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004284:	04c92483          	lw	s1,76(s2)
    80004288:	c49d                	beqz	s1,800042b6 <dirlink+0x54>
    8000428a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000428c:	4741                	li	a4,16
    8000428e:	86a6                	mv	a3,s1
    80004290:	fc040613          	addi	a2,s0,-64
    80004294:	4581                	li	a1,0
    80004296:	854a                	mv	a0,s2
    80004298:	00000097          	auipc	ra,0x0
    8000429c:	b8a080e7          	jalr	-1142(ra) # 80003e22 <readi>
    800042a0:	47c1                	li	a5,16
    800042a2:	06f51163          	bne	a0,a5,80004304 <dirlink+0xa2>
    if(de.inum == 0)
    800042a6:	fc045783          	lhu	a5,-64(s0)
    800042aa:	c791                	beqz	a5,800042b6 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800042ac:	24c1                	addiw	s1,s1,16
    800042ae:	04c92783          	lw	a5,76(s2)
    800042b2:	fcf4ede3          	bltu	s1,a5,8000428c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800042b6:	4639                	li	a2,14
    800042b8:	85d2                	mv	a1,s4
    800042ba:	fc240513          	addi	a0,s0,-62
    800042be:	ffffd097          	auipc	ra,0xffffd
    800042c2:	b14080e7          	jalr	-1260(ra) # 80000dd2 <strncpy>
  de.inum = inum;
    800042c6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042ca:	4741                	li	a4,16
    800042cc:	86a6                	mv	a3,s1
    800042ce:	fc040613          	addi	a2,s0,-64
    800042d2:	4581                	li	a1,0
    800042d4:	854a                	mv	a0,s2
    800042d6:	00000097          	auipc	ra,0x0
    800042da:	c44080e7          	jalr	-956(ra) # 80003f1a <writei>
    800042de:	872a                	mv	a4,a0
    800042e0:	47c1                	li	a5,16
  return 0;
    800042e2:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042e4:	02f71863          	bne	a4,a5,80004314 <dirlink+0xb2>
}
    800042e8:	70e2                	ld	ra,56(sp)
    800042ea:	7442                	ld	s0,48(sp)
    800042ec:	74a2                	ld	s1,40(sp)
    800042ee:	7902                	ld	s2,32(sp)
    800042f0:	69e2                	ld	s3,24(sp)
    800042f2:	6a42                	ld	s4,16(sp)
    800042f4:	6121                	addi	sp,sp,64
    800042f6:	8082                	ret
    iput(ip);
    800042f8:	00000097          	auipc	ra,0x0
    800042fc:	a30080e7          	jalr	-1488(ra) # 80003d28 <iput>
    return -1;
    80004300:	557d                	li	a0,-1
    80004302:	b7dd                	j	800042e8 <dirlink+0x86>
      panic("dirlink read");
    80004304:	00004517          	auipc	a0,0x4
    80004308:	3dc50513          	addi	a0,a0,988 # 800086e0 <syscalls+0x1e0>
    8000430c:	ffffc097          	auipc	ra,0xffffc
    80004310:	21e080e7          	jalr	542(ra) # 8000052a <panic>
    panic("dirlink");
    80004314:	00004517          	auipc	a0,0x4
    80004318:	4dc50513          	addi	a0,a0,1244 # 800087f0 <syscalls+0x2f0>
    8000431c:	ffffc097          	auipc	ra,0xffffc
    80004320:	20e080e7          	jalr	526(ra) # 8000052a <panic>

0000000080004324 <namei>:

struct inode*
namei(char *path)
{
    80004324:	1101                	addi	sp,sp,-32
    80004326:	ec06                	sd	ra,24(sp)
    80004328:	e822                	sd	s0,16(sp)
    8000432a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000432c:	fe040613          	addi	a2,s0,-32
    80004330:	4581                	li	a1,0
    80004332:	00000097          	auipc	ra,0x0
    80004336:	dd0080e7          	jalr	-560(ra) # 80004102 <namex>
}
    8000433a:	60e2                	ld	ra,24(sp)
    8000433c:	6442                	ld	s0,16(sp)
    8000433e:	6105                	addi	sp,sp,32
    80004340:	8082                	ret

0000000080004342 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004342:	1141                	addi	sp,sp,-16
    80004344:	e406                	sd	ra,8(sp)
    80004346:	e022                	sd	s0,0(sp)
    80004348:	0800                	addi	s0,sp,16
    8000434a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000434c:	4585                	li	a1,1
    8000434e:	00000097          	auipc	ra,0x0
    80004352:	db4080e7          	jalr	-588(ra) # 80004102 <namex>
}
    80004356:	60a2                	ld	ra,8(sp)
    80004358:	6402                	ld	s0,0(sp)
    8000435a:	0141                	addi	sp,sp,16
    8000435c:	8082                	ret

000000008000435e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000435e:	1101                	addi	sp,sp,-32
    80004360:	ec06                	sd	ra,24(sp)
    80004362:	e822                	sd	s0,16(sp)
    80004364:	e426                	sd	s1,8(sp)
    80004366:	e04a                	sd	s2,0(sp)
    80004368:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000436a:	00023917          	auipc	s2,0x23
    8000436e:	70690913          	addi	s2,s2,1798 # 80027a70 <log>
    80004372:	01892583          	lw	a1,24(s2)
    80004376:	02892503          	lw	a0,40(s2)
    8000437a:	fffff097          	auipc	ra,0xfffff
    8000437e:	ff0080e7          	jalr	-16(ra) # 8000336a <bread>
    80004382:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004384:	02c92683          	lw	a3,44(s2)
    80004388:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000438a:	02d05863          	blez	a3,800043ba <write_head+0x5c>
    8000438e:	00023797          	auipc	a5,0x23
    80004392:	71278793          	addi	a5,a5,1810 # 80027aa0 <log+0x30>
    80004396:	05c50713          	addi	a4,a0,92
    8000439a:	36fd                	addiw	a3,a3,-1
    8000439c:	02069613          	slli	a2,a3,0x20
    800043a0:	01e65693          	srli	a3,a2,0x1e
    800043a4:	00023617          	auipc	a2,0x23
    800043a8:	70060613          	addi	a2,a2,1792 # 80027aa4 <log+0x34>
    800043ac:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800043ae:	4390                	lw	a2,0(a5)
    800043b0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800043b2:	0791                	addi	a5,a5,4
    800043b4:	0711                	addi	a4,a4,4
    800043b6:	fed79ce3          	bne	a5,a3,800043ae <write_head+0x50>
  }
  bwrite(buf);
    800043ba:	8526                	mv	a0,s1
    800043bc:	fffff097          	auipc	ra,0xfffff
    800043c0:	0a0080e7          	jalr	160(ra) # 8000345c <bwrite>
  brelse(buf);
    800043c4:	8526                	mv	a0,s1
    800043c6:	fffff097          	auipc	ra,0xfffff
    800043ca:	0d4080e7          	jalr	212(ra) # 8000349a <brelse>
}
    800043ce:	60e2                	ld	ra,24(sp)
    800043d0:	6442                	ld	s0,16(sp)
    800043d2:	64a2                	ld	s1,8(sp)
    800043d4:	6902                	ld	s2,0(sp)
    800043d6:	6105                	addi	sp,sp,32
    800043d8:	8082                	ret

00000000800043da <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800043da:	00023797          	auipc	a5,0x23
    800043de:	6c27a783          	lw	a5,1730(a5) # 80027a9c <log+0x2c>
    800043e2:	0af05d63          	blez	a5,8000449c <install_trans+0xc2>
{
    800043e6:	7139                	addi	sp,sp,-64
    800043e8:	fc06                	sd	ra,56(sp)
    800043ea:	f822                	sd	s0,48(sp)
    800043ec:	f426                	sd	s1,40(sp)
    800043ee:	f04a                	sd	s2,32(sp)
    800043f0:	ec4e                	sd	s3,24(sp)
    800043f2:	e852                	sd	s4,16(sp)
    800043f4:	e456                	sd	s5,8(sp)
    800043f6:	e05a                	sd	s6,0(sp)
    800043f8:	0080                	addi	s0,sp,64
    800043fa:	8b2a                	mv	s6,a0
    800043fc:	00023a97          	auipc	s5,0x23
    80004400:	6a4a8a93          	addi	s5,s5,1700 # 80027aa0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004404:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004406:	00023997          	auipc	s3,0x23
    8000440a:	66a98993          	addi	s3,s3,1642 # 80027a70 <log>
    8000440e:	a00d                	j	80004430 <install_trans+0x56>
    brelse(lbuf);
    80004410:	854a                	mv	a0,s2
    80004412:	fffff097          	auipc	ra,0xfffff
    80004416:	088080e7          	jalr	136(ra) # 8000349a <brelse>
    brelse(dbuf);
    8000441a:	8526                	mv	a0,s1
    8000441c:	fffff097          	auipc	ra,0xfffff
    80004420:	07e080e7          	jalr	126(ra) # 8000349a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004424:	2a05                	addiw	s4,s4,1
    80004426:	0a91                	addi	s5,s5,4
    80004428:	02c9a783          	lw	a5,44(s3)
    8000442c:	04fa5e63          	bge	s4,a5,80004488 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004430:	0189a583          	lw	a1,24(s3)
    80004434:	014585bb          	addw	a1,a1,s4
    80004438:	2585                	addiw	a1,a1,1
    8000443a:	0289a503          	lw	a0,40(s3)
    8000443e:	fffff097          	auipc	ra,0xfffff
    80004442:	f2c080e7          	jalr	-212(ra) # 8000336a <bread>
    80004446:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004448:	000aa583          	lw	a1,0(s5)
    8000444c:	0289a503          	lw	a0,40(s3)
    80004450:	fffff097          	auipc	ra,0xfffff
    80004454:	f1a080e7          	jalr	-230(ra) # 8000336a <bread>
    80004458:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000445a:	40000613          	li	a2,1024
    8000445e:	05890593          	addi	a1,s2,88
    80004462:	05850513          	addi	a0,a0,88
    80004466:	ffffd097          	auipc	ra,0xffffd
    8000446a:	8b4080e7          	jalr	-1868(ra) # 80000d1a <memmove>
    bwrite(dbuf);  // write dst to disk
    8000446e:	8526                	mv	a0,s1
    80004470:	fffff097          	auipc	ra,0xfffff
    80004474:	fec080e7          	jalr	-20(ra) # 8000345c <bwrite>
    if(recovering == 0)
    80004478:	f80b1ce3          	bnez	s6,80004410 <install_trans+0x36>
      bunpin(dbuf);
    8000447c:	8526                	mv	a0,s1
    8000447e:	fffff097          	auipc	ra,0xfffff
    80004482:	0f6080e7          	jalr	246(ra) # 80003574 <bunpin>
    80004486:	b769                	j	80004410 <install_trans+0x36>
}
    80004488:	70e2                	ld	ra,56(sp)
    8000448a:	7442                	ld	s0,48(sp)
    8000448c:	74a2                	ld	s1,40(sp)
    8000448e:	7902                	ld	s2,32(sp)
    80004490:	69e2                	ld	s3,24(sp)
    80004492:	6a42                	ld	s4,16(sp)
    80004494:	6aa2                	ld	s5,8(sp)
    80004496:	6b02                	ld	s6,0(sp)
    80004498:	6121                	addi	sp,sp,64
    8000449a:	8082                	ret
    8000449c:	8082                	ret

000000008000449e <initlog>:
{
    8000449e:	7179                	addi	sp,sp,-48
    800044a0:	f406                	sd	ra,40(sp)
    800044a2:	f022                	sd	s0,32(sp)
    800044a4:	ec26                	sd	s1,24(sp)
    800044a6:	e84a                	sd	s2,16(sp)
    800044a8:	e44e                	sd	s3,8(sp)
    800044aa:	1800                	addi	s0,sp,48
    800044ac:	892a                	mv	s2,a0
    800044ae:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800044b0:	00023497          	auipc	s1,0x23
    800044b4:	5c048493          	addi	s1,s1,1472 # 80027a70 <log>
    800044b8:	00004597          	auipc	a1,0x4
    800044bc:	23858593          	addi	a1,a1,568 # 800086f0 <syscalls+0x1f0>
    800044c0:	8526                	mv	a0,s1
    800044c2:	ffffc097          	auipc	ra,0xffffc
    800044c6:	670080e7          	jalr	1648(ra) # 80000b32 <initlock>
  log.start = sb->logstart;
    800044ca:	0149a583          	lw	a1,20(s3)
    800044ce:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800044d0:	0109a783          	lw	a5,16(s3)
    800044d4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800044d6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800044da:	854a                	mv	a0,s2
    800044dc:	fffff097          	auipc	ra,0xfffff
    800044e0:	e8e080e7          	jalr	-370(ra) # 8000336a <bread>
  log.lh.n = lh->n;
    800044e4:	4d34                	lw	a3,88(a0)
    800044e6:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800044e8:	02d05663          	blez	a3,80004514 <initlog+0x76>
    800044ec:	05c50793          	addi	a5,a0,92
    800044f0:	00023717          	auipc	a4,0x23
    800044f4:	5b070713          	addi	a4,a4,1456 # 80027aa0 <log+0x30>
    800044f8:	36fd                	addiw	a3,a3,-1
    800044fa:	02069613          	slli	a2,a3,0x20
    800044fe:	01e65693          	srli	a3,a2,0x1e
    80004502:	06050613          	addi	a2,a0,96
    80004506:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004508:	4390                	lw	a2,0(a5)
    8000450a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000450c:	0791                	addi	a5,a5,4
    8000450e:	0711                	addi	a4,a4,4
    80004510:	fed79ce3          	bne	a5,a3,80004508 <initlog+0x6a>
  brelse(buf);
    80004514:	fffff097          	auipc	ra,0xfffff
    80004518:	f86080e7          	jalr	-122(ra) # 8000349a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000451c:	4505                	li	a0,1
    8000451e:	00000097          	auipc	ra,0x0
    80004522:	ebc080e7          	jalr	-324(ra) # 800043da <install_trans>
  log.lh.n = 0;
    80004526:	00023797          	auipc	a5,0x23
    8000452a:	5607ab23          	sw	zero,1398(a5) # 80027a9c <log+0x2c>
  write_head(); // clear the log
    8000452e:	00000097          	auipc	ra,0x0
    80004532:	e30080e7          	jalr	-464(ra) # 8000435e <write_head>
}
    80004536:	70a2                	ld	ra,40(sp)
    80004538:	7402                	ld	s0,32(sp)
    8000453a:	64e2                	ld	s1,24(sp)
    8000453c:	6942                	ld	s2,16(sp)
    8000453e:	69a2                	ld	s3,8(sp)
    80004540:	6145                	addi	sp,sp,48
    80004542:	8082                	ret

0000000080004544 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004544:	1101                	addi	sp,sp,-32
    80004546:	ec06                	sd	ra,24(sp)
    80004548:	e822                	sd	s0,16(sp)
    8000454a:	e426                	sd	s1,8(sp)
    8000454c:	e04a                	sd	s2,0(sp)
    8000454e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004550:	00023517          	auipc	a0,0x23
    80004554:	52050513          	addi	a0,a0,1312 # 80027a70 <log>
    80004558:	ffffc097          	auipc	ra,0xffffc
    8000455c:	66a080e7          	jalr	1642(ra) # 80000bc2 <acquire>
  while(1){
    if(log.committing){
    80004560:	00023497          	auipc	s1,0x23
    80004564:	51048493          	addi	s1,s1,1296 # 80027a70 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004568:	4979                	li	s2,30
    8000456a:	a039                	j	80004578 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000456c:	85a6                	mv	a1,s1
    8000456e:	8526                	mv	a0,s1
    80004570:	ffffe097          	auipc	ra,0xffffe
    80004574:	b9a080e7          	jalr	-1126(ra) # 8000210a <sleep>
    if(log.committing){
    80004578:	50dc                	lw	a5,36(s1)
    8000457a:	fbed                	bnez	a5,8000456c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000457c:	509c                	lw	a5,32(s1)
    8000457e:	0017871b          	addiw	a4,a5,1
    80004582:	0007069b          	sext.w	a3,a4
    80004586:	0027179b          	slliw	a5,a4,0x2
    8000458a:	9fb9                	addw	a5,a5,a4
    8000458c:	0017979b          	slliw	a5,a5,0x1
    80004590:	54d8                	lw	a4,44(s1)
    80004592:	9fb9                	addw	a5,a5,a4
    80004594:	00f95963          	bge	s2,a5,800045a6 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004598:	85a6                	mv	a1,s1
    8000459a:	8526                	mv	a0,s1
    8000459c:	ffffe097          	auipc	ra,0xffffe
    800045a0:	b6e080e7          	jalr	-1170(ra) # 8000210a <sleep>
    800045a4:	bfd1                	j	80004578 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800045a6:	00023517          	auipc	a0,0x23
    800045aa:	4ca50513          	addi	a0,a0,1226 # 80027a70 <log>
    800045ae:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800045b0:	ffffc097          	auipc	ra,0xffffc
    800045b4:	6c6080e7          	jalr	1734(ra) # 80000c76 <release>
      break;
    }
  }
}
    800045b8:	60e2                	ld	ra,24(sp)
    800045ba:	6442                	ld	s0,16(sp)
    800045bc:	64a2                	ld	s1,8(sp)
    800045be:	6902                	ld	s2,0(sp)
    800045c0:	6105                	addi	sp,sp,32
    800045c2:	8082                	ret

00000000800045c4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800045c4:	7139                	addi	sp,sp,-64
    800045c6:	fc06                	sd	ra,56(sp)
    800045c8:	f822                	sd	s0,48(sp)
    800045ca:	f426                	sd	s1,40(sp)
    800045cc:	f04a                	sd	s2,32(sp)
    800045ce:	ec4e                	sd	s3,24(sp)
    800045d0:	e852                	sd	s4,16(sp)
    800045d2:	e456                	sd	s5,8(sp)
    800045d4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800045d6:	00023497          	auipc	s1,0x23
    800045da:	49a48493          	addi	s1,s1,1178 # 80027a70 <log>
    800045de:	8526                	mv	a0,s1
    800045e0:	ffffc097          	auipc	ra,0xffffc
    800045e4:	5e2080e7          	jalr	1506(ra) # 80000bc2 <acquire>
  log.outstanding -= 1;
    800045e8:	509c                	lw	a5,32(s1)
    800045ea:	37fd                	addiw	a5,a5,-1
    800045ec:	0007891b          	sext.w	s2,a5
    800045f0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800045f2:	50dc                	lw	a5,36(s1)
    800045f4:	e7b9                	bnez	a5,80004642 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800045f6:	04091e63          	bnez	s2,80004652 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800045fa:	00023497          	auipc	s1,0x23
    800045fe:	47648493          	addi	s1,s1,1142 # 80027a70 <log>
    80004602:	4785                	li	a5,1
    80004604:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004606:	8526                	mv	a0,s1
    80004608:	ffffc097          	auipc	ra,0xffffc
    8000460c:	66e080e7          	jalr	1646(ra) # 80000c76 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004610:	54dc                	lw	a5,44(s1)
    80004612:	06f04763          	bgtz	a5,80004680 <end_op+0xbc>
    acquire(&log.lock);
    80004616:	00023497          	auipc	s1,0x23
    8000461a:	45a48493          	addi	s1,s1,1114 # 80027a70 <log>
    8000461e:	8526                	mv	a0,s1
    80004620:	ffffc097          	auipc	ra,0xffffc
    80004624:	5a2080e7          	jalr	1442(ra) # 80000bc2 <acquire>
    log.committing = 0;
    80004628:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000462c:	8526                	mv	a0,s1
    8000462e:	ffffe097          	auipc	ra,0xffffe
    80004632:	c68080e7          	jalr	-920(ra) # 80002296 <wakeup>
    release(&log.lock);
    80004636:	8526                	mv	a0,s1
    80004638:	ffffc097          	auipc	ra,0xffffc
    8000463c:	63e080e7          	jalr	1598(ra) # 80000c76 <release>
}
    80004640:	a03d                	j	8000466e <end_op+0xaa>
    panic("log.committing");
    80004642:	00004517          	auipc	a0,0x4
    80004646:	0b650513          	addi	a0,a0,182 # 800086f8 <syscalls+0x1f8>
    8000464a:	ffffc097          	auipc	ra,0xffffc
    8000464e:	ee0080e7          	jalr	-288(ra) # 8000052a <panic>
    wakeup(&log);
    80004652:	00023497          	auipc	s1,0x23
    80004656:	41e48493          	addi	s1,s1,1054 # 80027a70 <log>
    8000465a:	8526                	mv	a0,s1
    8000465c:	ffffe097          	auipc	ra,0xffffe
    80004660:	c3a080e7          	jalr	-966(ra) # 80002296 <wakeup>
  release(&log.lock);
    80004664:	8526                	mv	a0,s1
    80004666:	ffffc097          	auipc	ra,0xffffc
    8000466a:	610080e7          	jalr	1552(ra) # 80000c76 <release>
}
    8000466e:	70e2                	ld	ra,56(sp)
    80004670:	7442                	ld	s0,48(sp)
    80004672:	74a2                	ld	s1,40(sp)
    80004674:	7902                	ld	s2,32(sp)
    80004676:	69e2                	ld	s3,24(sp)
    80004678:	6a42                	ld	s4,16(sp)
    8000467a:	6aa2                	ld	s5,8(sp)
    8000467c:	6121                	addi	sp,sp,64
    8000467e:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004680:	00023a97          	auipc	s5,0x23
    80004684:	420a8a93          	addi	s5,s5,1056 # 80027aa0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004688:	00023a17          	auipc	s4,0x23
    8000468c:	3e8a0a13          	addi	s4,s4,1000 # 80027a70 <log>
    80004690:	018a2583          	lw	a1,24(s4)
    80004694:	012585bb          	addw	a1,a1,s2
    80004698:	2585                	addiw	a1,a1,1
    8000469a:	028a2503          	lw	a0,40(s4)
    8000469e:	fffff097          	auipc	ra,0xfffff
    800046a2:	ccc080e7          	jalr	-820(ra) # 8000336a <bread>
    800046a6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800046a8:	000aa583          	lw	a1,0(s5)
    800046ac:	028a2503          	lw	a0,40(s4)
    800046b0:	fffff097          	auipc	ra,0xfffff
    800046b4:	cba080e7          	jalr	-838(ra) # 8000336a <bread>
    800046b8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800046ba:	40000613          	li	a2,1024
    800046be:	05850593          	addi	a1,a0,88
    800046c2:	05848513          	addi	a0,s1,88
    800046c6:	ffffc097          	auipc	ra,0xffffc
    800046ca:	654080e7          	jalr	1620(ra) # 80000d1a <memmove>
    bwrite(to);  // write the log
    800046ce:	8526                	mv	a0,s1
    800046d0:	fffff097          	auipc	ra,0xfffff
    800046d4:	d8c080e7          	jalr	-628(ra) # 8000345c <bwrite>
    brelse(from);
    800046d8:	854e                	mv	a0,s3
    800046da:	fffff097          	auipc	ra,0xfffff
    800046de:	dc0080e7          	jalr	-576(ra) # 8000349a <brelse>
    brelse(to);
    800046e2:	8526                	mv	a0,s1
    800046e4:	fffff097          	auipc	ra,0xfffff
    800046e8:	db6080e7          	jalr	-586(ra) # 8000349a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800046ec:	2905                	addiw	s2,s2,1
    800046ee:	0a91                	addi	s5,s5,4
    800046f0:	02ca2783          	lw	a5,44(s4)
    800046f4:	f8f94ee3          	blt	s2,a5,80004690 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800046f8:	00000097          	auipc	ra,0x0
    800046fc:	c66080e7          	jalr	-922(ra) # 8000435e <write_head>
    install_trans(0); // Now install writes to home locations
    80004700:	4501                	li	a0,0
    80004702:	00000097          	auipc	ra,0x0
    80004706:	cd8080e7          	jalr	-808(ra) # 800043da <install_trans>
    log.lh.n = 0;
    8000470a:	00023797          	auipc	a5,0x23
    8000470e:	3807a923          	sw	zero,914(a5) # 80027a9c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004712:	00000097          	auipc	ra,0x0
    80004716:	c4c080e7          	jalr	-948(ra) # 8000435e <write_head>
    8000471a:	bdf5                	j	80004616 <end_op+0x52>

000000008000471c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000471c:	1101                	addi	sp,sp,-32
    8000471e:	ec06                	sd	ra,24(sp)
    80004720:	e822                	sd	s0,16(sp)
    80004722:	e426                	sd	s1,8(sp)
    80004724:	e04a                	sd	s2,0(sp)
    80004726:	1000                	addi	s0,sp,32
    80004728:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000472a:	00023917          	auipc	s2,0x23
    8000472e:	34690913          	addi	s2,s2,838 # 80027a70 <log>
    80004732:	854a                	mv	a0,s2
    80004734:	ffffc097          	auipc	ra,0xffffc
    80004738:	48e080e7          	jalr	1166(ra) # 80000bc2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000473c:	02c92603          	lw	a2,44(s2)
    80004740:	47f5                	li	a5,29
    80004742:	06c7c563          	blt	a5,a2,800047ac <log_write+0x90>
    80004746:	00023797          	auipc	a5,0x23
    8000474a:	3467a783          	lw	a5,838(a5) # 80027a8c <log+0x1c>
    8000474e:	37fd                	addiw	a5,a5,-1
    80004750:	04f65e63          	bge	a2,a5,800047ac <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004754:	00023797          	auipc	a5,0x23
    80004758:	33c7a783          	lw	a5,828(a5) # 80027a90 <log+0x20>
    8000475c:	06f05063          	blez	a5,800047bc <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004760:	4781                	li	a5,0
    80004762:	06c05563          	blez	a2,800047cc <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004766:	44cc                	lw	a1,12(s1)
    80004768:	00023717          	auipc	a4,0x23
    8000476c:	33870713          	addi	a4,a4,824 # 80027aa0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004770:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004772:	4314                	lw	a3,0(a4)
    80004774:	04b68c63          	beq	a3,a1,800047cc <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004778:	2785                	addiw	a5,a5,1
    8000477a:	0711                	addi	a4,a4,4
    8000477c:	fef61be3          	bne	a2,a5,80004772 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004780:	0621                	addi	a2,a2,8
    80004782:	060a                	slli	a2,a2,0x2
    80004784:	00023797          	auipc	a5,0x23
    80004788:	2ec78793          	addi	a5,a5,748 # 80027a70 <log>
    8000478c:	963e                	add	a2,a2,a5
    8000478e:	44dc                	lw	a5,12(s1)
    80004790:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004792:	8526                	mv	a0,s1
    80004794:	fffff097          	auipc	ra,0xfffff
    80004798:	da4080e7          	jalr	-604(ra) # 80003538 <bpin>
    log.lh.n++;
    8000479c:	00023717          	auipc	a4,0x23
    800047a0:	2d470713          	addi	a4,a4,724 # 80027a70 <log>
    800047a4:	575c                	lw	a5,44(a4)
    800047a6:	2785                	addiw	a5,a5,1
    800047a8:	d75c                	sw	a5,44(a4)
    800047aa:	a835                	j	800047e6 <log_write+0xca>
    panic("too big a transaction");
    800047ac:	00004517          	auipc	a0,0x4
    800047b0:	f5c50513          	addi	a0,a0,-164 # 80008708 <syscalls+0x208>
    800047b4:	ffffc097          	auipc	ra,0xffffc
    800047b8:	d76080e7          	jalr	-650(ra) # 8000052a <panic>
    panic("log_write outside of trans");
    800047bc:	00004517          	auipc	a0,0x4
    800047c0:	f6450513          	addi	a0,a0,-156 # 80008720 <syscalls+0x220>
    800047c4:	ffffc097          	auipc	ra,0xffffc
    800047c8:	d66080e7          	jalr	-666(ra) # 8000052a <panic>
  log.lh.block[i] = b->blockno;
    800047cc:	00878713          	addi	a4,a5,8
    800047d0:	00271693          	slli	a3,a4,0x2
    800047d4:	00023717          	auipc	a4,0x23
    800047d8:	29c70713          	addi	a4,a4,668 # 80027a70 <log>
    800047dc:	9736                	add	a4,a4,a3
    800047de:	44d4                	lw	a3,12(s1)
    800047e0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800047e2:	faf608e3          	beq	a2,a5,80004792 <log_write+0x76>
  }
  release(&log.lock);
    800047e6:	00023517          	auipc	a0,0x23
    800047ea:	28a50513          	addi	a0,a0,650 # 80027a70 <log>
    800047ee:	ffffc097          	auipc	ra,0xffffc
    800047f2:	488080e7          	jalr	1160(ra) # 80000c76 <release>
}
    800047f6:	60e2                	ld	ra,24(sp)
    800047f8:	6442                	ld	s0,16(sp)
    800047fa:	64a2                	ld	s1,8(sp)
    800047fc:	6902                	ld	s2,0(sp)
    800047fe:	6105                	addi	sp,sp,32
    80004800:	8082                	ret

0000000080004802 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004802:	1101                	addi	sp,sp,-32
    80004804:	ec06                	sd	ra,24(sp)
    80004806:	e822                	sd	s0,16(sp)
    80004808:	e426                	sd	s1,8(sp)
    8000480a:	e04a                	sd	s2,0(sp)
    8000480c:	1000                	addi	s0,sp,32
    8000480e:	84aa                	mv	s1,a0
    80004810:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004812:	00004597          	auipc	a1,0x4
    80004816:	f2e58593          	addi	a1,a1,-210 # 80008740 <syscalls+0x240>
    8000481a:	0521                	addi	a0,a0,8
    8000481c:	ffffc097          	auipc	ra,0xffffc
    80004820:	316080e7          	jalr	790(ra) # 80000b32 <initlock>
  lk->name = name;
    80004824:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004828:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000482c:	0204a423          	sw	zero,40(s1)
}
    80004830:	60e2                	ld	ra,24(sp)
    80004832:	6442                	ld	s0,16(sp)
    80004834:	64a2                	ld	s1,8(sp)
    80004836:	6902                	ld	s2,0(sp)
    80004838:	6105                	addi	sp,sp,32
    8000483a:	8082                	ret

000000008000483c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000483c:	1101                	addi	sp,sp,-32
    8000483e:	ec06                	sd	ra,24(sp)
    80004840:	e822                	sd	s0,16(sp)
    80004842:	e426                	sd	s1,8(sp)
    80004844:	e04a                	sd	s2,0(sp)
    80004846:	1000                	addi	s0,sp,32
    80004848:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000484a:	00850913          	addi	s2,a0,8
    8000484e:	854a                	mv	a0,s2
    80004850:	ffffc097          	auipc	ra,0xffffc
    80004854:	372080e7          	jalr	882(ra) # 80000bc2 <acquire>
  while (lk->locked) {
    80004858:	409c                	lw	a5,0(s1)
    8000485a:	cb89                	beqz	a5,8000486c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000485c:	85ca                	mv	a1,s2
    8000485e:	8526                	mv	a0,s1
    80004860:	ffffe097          	auipc	ra,0xffffe
    80004864:	8aa080e7          	jalr	-1878(ra) # 8000210a <sleep>
  while (lk->locked) {
    80004868:	409c                	lw	a5,0(s1)
    8000486a:	fbed                	bnez	a5,8000485c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000486c:	4785                	li	a5,1
    8000486e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004870:	ffffd097          	auipc	ra,0xffffd
    80004874:	10e080e7          	jalr	270(ra) # 8000197e <myproc>
    80004878:	591c                	lw	a5,48(a0)
    8000487a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000487c:	854a                	mv	a0,s2
    8000487e:	ffffc097          	auipc	ra,0xffffc
    80004882:	3f8080e7          	jalr	1016(ra) # 80000c76 <release>
}
    80004886:	60e2                	ld	ra,24(sp)
    80004888:	6442                	ld	s0,16(sp)
    8000488a:	64a2                	ld	s1,8(sp)
    8000488c:	6902                	ld	s2,0(sp)
    8000488e:	6105                	addi	sp,sp,32
    80004890:	8082                	ret

0000000080004892 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004892:	1101                	addi	sp,sp,-32
    80004894:	ec06                	sd	ra,24(sp)
    80004896:	e822                	sd	s0,16(sp)
    80004898:	e426                	sd	s1,8(sp)
    8000489a:	e04a                	sd	s2,0(sp)
    8000489c:	1000                	addi	s0,sp,32
    8000489e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800048a0:	00850913          	addi	s2,a0,8
    800048a4:	854a                	mv	a0,s2
    800048a6:	ffffc097          	auipc	ra,0xffffc
    800048aa:	31c080e7          	jalr	796(ra) # 80000bc2 <acquire>
  lk->locked = 0;
    800048ae:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800048b2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800048b6:	8526                	mv	a0,s1
    800048b8:	ffffe097          	auipc	ra,0xffffe
    800048bc:	9de080e7          	jalr	-1570(ra) # 80002296 <wakeup>
  release(&lk->lk);
    800048c0:	854a                	mv	a0,s2
    800048c2:	ffffc097          	auipc	ra,0xffffc
    800048c6:	3b4080e7          	jalr	948(ra) # 80000c76 <release>
}
    800048ca:	60e2                	ld	ra,24(sp)
    800048cc:	6442                	ld	s0,16(sp)
    800048ce:	64a2                	ld	s1,8(sp)
    800048d0:	6902                	ld	s2,0(sp)
    800048d2:	6105                	addi	sp,sp,32
    800048d4:	8082                	ret

00000000800048d6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800048d6:	7179                	addi	sp,sp,-48
    800048d8:	f406                	sd	ra,40(sp)
    800048da:	f022                	sd	s0,32(sp)
    800048dc:	ec26                	sd	s1,24(sp)
    800048de:	e84a                	sd	s2,16(sp)
    800048e0:	e44e                	sd	s3,8(sp)
    800048e2:	1800                	addi	s0,sp,48
    800048e4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800048e6:	00850913          	addi	s2,a0,8
    800048ea:	854a                	mv	a0,s2
    800048ec:	ffffc097          	auipc	ra,0xffffc
    800048f0:	2d6080e7          	jalr	726(ra) # 80000bc2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800048f4:	409c                	lw	a5,0(s1)
    800048f6:	ef99                	bnez	a5,80004914 <holdingsleep+0x3e>
    800048f8:	4481                	li	s1,0
  release(&lk->lk);
    800048fa:	854a                	mv	a0,s2
    800048fc:	ffffc097          	auipc	ra,0xffffc
    80004900:	37a080e7          	jalr	890(ra) # 80000c76 <release>
  return r;
}
    80004904:	8526                	mv	a0,s1
    80004906:	70a2                	ld	ra,40(sp)
    80004908:	7402                	ld	s0,32(sp)
    8000490a:	64e2                	ld	s1,24(sp)
    8000490c:	6942                	ld	s2,16(sp)
    8000490e:	69a2                	ld	s3,8(sp)
    80004910:	6145                	addi	sp,sp,48
    80004912:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004914:	0284a983          	lw	s3,40(s1)
    80004918:	ffffd097          	auipc	ra,0xffffd
    8000491c:	066080e7          	jalr	102(ra) # 8000197e <myproc>
    80004920:	5904                	lw	s1,48(a0)
    80004922:	413484b3          	sub	s1,s1,s3
    80004926:	0014b493          	seqz	s1,s1
    8000492a:	bfc1                	j	800048fa <holdingsleep+0x24>

000000008000492c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000492c:	1141                	addi	sp,sp,-16
    8000492e:	e406                	sd	ra,8(sp)
    80004930:	e022                	sd	s0,0(sp)
    80004932:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004934:	00004597          	auipc	a1,0x4
    80004938:	e1c58593          	addi	a1,a1,-484 # 80008750 <syscalls+0x250>
    8000493c:	00023517          	auipc	a0,0x23
    80004940:	27c50513          	addi	a0,a0,636 # 80027bb8 <ftable>
    80004944:	ffffc097          	auipc	ra,0xffffc
    80004948:	1ee080e7          	jalr	494(ra) # 80000b32 <initlock>
}
    8000494c:	60a2                	ld	ra,8(sp)
    8000494e:	6402                	ld	s0,0(sp)
    80004950:	0141                	addi	sp,sp,16
    80004952:	8082                	ret

0000000080004954 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004954:	1101                	addi	sp,sp,-32
    80004956:	ec06                	sd	ra,24(sp)
    80004958:	e822                	sd	s0,16(sp)
    8000495a:	e426                	sd	s1,8(sp)
    8000495c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000495e:	00023517          	auipc	a0,0x23
    80004962:	25a50513          	addi	a0,a0,602 # 80027bb8 <ftable>
    80004966:	ffffc097          	auipc	ra,0xffffc
    8000496a:	25c080e7          	jalr	604(ra) # 80000bc2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000496e:	00023497          	auipc	s1,0x23
    80004972:	26248493          	addi	s1,s1,610 # 80027bd0 <ftable+0x18>
    80004976:	00024717          	auipc	a4,0x24
    8000497a:	1fa70713          	addi	a4,a4,506 # 80028b70 <ftable+0xfb8>
    if(f->ref == 0){
    8000497e:	40dc                	lw	a5,4(s1)
    80004980:	cf99                	beqz	a5,8000499e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004982:	02848493          	addi	s1,s1,40
    80004986:	fee49ce3          	bne	s1,a4,8000497e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000498a:	00023517          	auipc	a0,0x23
    8000498e:	22e50513          	addi	a0,a0,558 # 80027bb8 <ftable>
    80004992:	ffffc097          	auipc	ra,0xffffc
    80004996:	2e4080e7          	jalr	740(ra) # 80000c76 <release>
  return 0;
    8000499a:	4481                	li	s1,0
    8000499c:	a819                	j	800049b2 <filealloc+0x5e>
      f->ref = 1;
    8000499e:	4785                	li	a5,1
    800049a0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800049a2:	00023517          	auipc	a0,0x23
    800049a6:	21650513          	addi	a0,a0,534 # 80027bb8 <ftable>
    800049aa:	ffffc097          	auipc	ra,0xffffc
    800049ae:	2cc080e7          	jalr	716(ra) # 80000c76 <release>
}
    800049b2:	8526                	mv	a0,s1
    800049b4:	60e2                	ld	ra,24(sp)
    800049b6:	6442                	ld	s0,16(sp)
    800049b8:	64a2                	ld	s1,8(sp)
    800049ba:	6105                	addi	sp,sp,32
    800049bc:	8082                	ret

00000000800049be <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800049be:	1101                	addi	sp,sp,-32
    800049c0:	ec06                	sd	ra,24(sp)
    800049c2:	e822                	sd	s0,16(sp)
    800049c4:	e426                	sd	s1,8(sp)
    800049c6:	1000                	addi	s0,sp,32
    800049c8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800049ca:	00023517          	auipc	a0,0x23
    800049ce:	1ee50513          	addi	a0,a0,494 # 80027bb8 <ftable>
    800049d2:	ffffc097          	auipc	ra,0xffffc
    800049d6:	1f0080e7          	jalr	496(ra) # 80000bc2 <acquire>
  if(f->ref < 1)
    800049da:	40dc                	lw	a5,4(s1)
    800049dc:	02f05263          	blez	a5,80004a00 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800049e0:	2785                	addiw	a5,a5,1
    800049e2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800049e4:	00023517          	auipc	a0,0x23
    800049e8:	1d450513          	addi	a0,a0,468 # 80027bb8 <ftable>
    800049ec:	ffffc097          	auipc	ra,0xffffc
    800049f0:	28a080e7          	jalr	650(ra) # 80000c76 <release>
  return f;
}
    800049f4:	8526                	mv	a0,s1
    800049f6:	60e2                	ld	ra,24(sp)
    800049f8:	6442                	ld	s0,16(sp)
    800049fa:	64a2                	ld	s1,8(sp)
    800049fc:	6105                	addi	sp,sp,32
    800049fe:	8082                	ret
    panic("filedup");
    80004a00:	00004517          	auipc	a0,0x4
    80004a04:	d5850513          	addi	a0,a0,-680 # 80008758 <syscalls+0x258>
    80004a08:	ffffc097          	auipc	ra,0xffffc
    80004a0c:	b22080e7          	jalr	-1246(ra) # 8000052a <panic>

0000000080004a10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004a10:	7139                	addi	sp,sp,-64
    80004a12:	fc06                	sd	ra,56(sp)
    80004a14:	f822                	sd	s0,48(sp)
    80004a16:	f426                	sd	s1,40(sp)
    80004a18:	f04a                	sd	s2,32(sp)
    80004a1a:	ec4e                	sd	s3,24(sp)
    80004a1c:	e852                	sd	s4,16(sp)
    80004a1e:	e456                	sd	s5,8(sp)
    80004a20:	0080                	addi	s0,sp,64
    80004a22:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004a24:	00023517          	auipc	a0,0x23
    80004a28:	19450513          	addi	a0,a0,404 # 80027bb8 <ftable>
    80004a2c:	ffffc097          	auipc	ra,0xffffc
    80004a30:	196080e7          	jalr	406(ra) # 80000bc2 <acquire>
  if(f->ref < 1)
    80004a34:	40dc                	lw	a5,4(s1)
    80004a36:	06f05163          	blez	a5,80004a98 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004a3a:	37fd                	addiw	a5,a5,-1
    80004a3c:	0007871b          	sext.w	a4,a5
    80004a40:	c0dc                	sw	a5,4(s1)
    80004a42:	06e04363          	bgtz	a4,80004aa8 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004a46:	0004a903          	lw	s2,0(s1)
    80004a4a:	0094ca83          	lbu	s5,9(s1)
    80004a4e:	0104ba03          	ld	s4,16(s1)
    80004a52:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004a56:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004a5a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004a5e:	00023517          	auipc	a0,0x23
    80004a62:	15a50513          	addi	a0,a0,346 # 80027bb8 <ftable>
    80004a66:	ffffc097          	auipc	ra,0xffffc
    80004a6a:	210080e7          	jalr	528(ra) # 80000c76 <release>

  if(ff.type == FD_PIPE){
    80004a6e:	4785                	li	a5,1
    80004a70:	04f90d63          	beq	s2,a5,80004aca <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004a74:	3979                	addiw	s2,s2,-2
    80004a76:	4785                	li	a5,1
    80004a78:	0527e063          	bltu	a5,s2,80004ab8 <fileclose+0xa8>
    begin_op();
    80004a7c:	00000097          	auipc	ra,0x0
    80004a80:	ac8080e7          	jalr	-1336(ra) # 80004544 <begin_op>
    iput(ff.ip);
    80004a84:	854e                	mv	a0,s3
    80004a86:	fffff097          	auipc	ra,0xfffff
    80004a8a:	2a2080e7          	jalr	674(ra) # 80003d28 <iput>
    end_op();
    80004a8e:	00000097          	auipc	ra,0x0
    80004a92:	b36080e7          	jalr	-1226(ra) # 800045c4 <end_op>
    80004a96:	a00d                	j	80004ab8 <fileclose+0xa8>
    panic("fileclose");
    80004a98:	00004517          	auipc	a0,0x4
    80004a9c:	cc850513          	addi	a0,a0,-824 # 80008760 <syscalls+0x260>
    80004aa0:	ffffc097          	auipc	ra,0xffffc
    80004aa4:	a8a080e7          	jalr	-1398(ra) # 8000052a <panic>
    release(&ftable.lock);
    80004aa8:	00023517          	auipc	a0,0x23
    80004aac:	11050513          	addi	a0,a0,272 # 80027bb8 <ftable>
    80004ab0:	ffffc097          	auipc	ra,0xffffc
    80004ab4:	1c6080e7          	jalr	454(ra) # 80000c76 <release>
  }
}
    80004ab8:	70e2                	ld	ra,56(sp)
    80004aba:	7442                	ld	s0,48(sp)
    80004abc:	74a2                	ld	s1,40(sp)
    80004abe:	7902                	ld	s2,32(sp)
    80004ac0:	69e2                	ld	s3,24(sp)
    80004ac2:	6a42                	ld	s4,16(sp)
    80004ac4:	6aa2                	ld	s5,8(sp)
    80004ac6:	6121                	addi	sp,sp,64
    80004ac8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004aca:	85d6                	mv	a1,s5
    80004acc:	8552                	mv	a0,s4
    80004ace:	00000097          	auipc	ra,0x0
    80004ad2:	34c080e7          	jalr	844(ra) # 80004e1a <pipeclose>
    80004ad6:	b7cd                	j	80004ab8 <fileclose+0xa8>

0000000080004ad8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004ad8:	715d                	addi	sp,sp,-80
    80004ada:	e486                	sd	ra,72(sp)
    80004adc:	e0a2                	sd	s0,64(sp)
    80004ade:	fc26                	sd	s1,56(sp)
    80004ae0:	f84a                	sd	s2,48(sp)
    80004ae2:	f44e                	sd	s3,40(sp)
    80004ae4:	0880                	addi	s0,sp,80
    80004ae6:	84aa                	mv	s1,a0
    80004ae8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004aea:	ffffd097          	auipc	ra,0xffffd
    80004aee:	e94080e7          	jalr	-364(ra) # 8000197e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004af2:	409c                	lw	a5,0(s1)
    80004af4:	37f9                	addiw	a5,a5,-2
    80004af6:	4705                	li	a4,1
    80004af8:	04f76763          	bltu	a4,a5,80004b46 <filestat+0x6e>
    80004afc:	892a                	mv	s2,a0
    ilock(f->ip);
    80004afe:	6c88                	ld	a0,24(s1)
    80004b00:	fffff097          	auipc	ra,0xfffff
    80004b04:	06e080e7          	jalr	110(ra) # 80003b6e <ilock>
    stati(f->ip, &st);
    80004b08:	fb840593          	addi	a1,s0,-72
    80004b0c:	6c88                	ld	a0,24(s1)
    80004b0e:	fffff097          	auipc	ra,0xfffff
    80004b12:	2ea080e7          	jalr	746(ra) # 80003df8 <stati>
    iunlock(f->ip);
    80004b16:	6c88                	ld	a0,24(s1)
    80004b18:	fffff097          	auipc	ra,0xfffff
    80004b1c:	118080e7          	jalr	280(ra) # 80003c30 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004b20:	46e1                	li	a3,24
    80004b22:	fb840613          	addi	a2,s0,-72
    80004b26:	85ce                	mv	a1,s3
    80004b28:	05093503          	ld	a0,80(s2)
    80004b2c:	ffffd097          	auipc	ra,0xffffd
    80004b30:	b12080e7          	jalr	-1262(ra) # 8000163e <copyout>
    80004b34:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004b38:	60a6                	ld	ra,72(sp)
    80004b3a:	6406                	ld	s0,64(sp)
    80004b3c:	74e2                	ld	s1,56(sp)
    80004b3e:	7942                	ld	s2,48(sp)
    80004b40:	79a2                	ld	s3,40(sp)
    80004b42:	6161                	addi	sp,sp,80
    80004b44:	8082                	ret
  return -1;
    80004b46:	557d                	li	a0,-1
    80004b48:	bfc5                	j	80004b38 <filestat+0x60>

0000000080004b4a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004b4a:	7179                	addi	sp,sp,-48
    80004b4c:	f406                	sd	ra,40(sp)
    80004b4e:	f022                	sd	s0,32(sp)
    80004b50:	ec26                	sd	s1,24(sp)
    80004b52:	e84a                	sd	s2,16(sp)
    80004b54:	e44e                	sd	s3,8(sp)
    80004b56:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004b58:	00854783          	lbu	a5,8(a0)
    80004b5c:	c3d5                	beqz	a5,80004c00 <fileread+0xb6>
    80004b5e:	84aa                	mv	s1,a0
    80004b60:	89ae                	mv	s3,a1
    80004b62:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004b64:	411c                	lw	a5,0(a0)
    80004b66:	4705                	li	a4,1
    80004b68:	04e78963          	beq	a5,a4,80004bba <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004b6c:	470d                	li	a4,3
    80004b6e:	04e78d63          	beq	a5,a4,80004bc8 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004b72:	4709                	li	a4,2
    80004b74:	06e79e63          	bne	a5,a4,80004bf0 <fileread+0xa6>
    ilock(f->ip);
    80004b78:	6d08                	ld	a0,24(a0)
    80004b7a:	fffff097          	auipc	ra,0xfffff
    80004b7e:	ff4080e7          	jalr	-12(ra) # 80003b6e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004b82:	874a                	mv	a4,s2
    80004b84:	5094                	lw	a3,32(s1)
    80004b86:	864e                	mv	a2,s3
    80004b88:	4585                	li	a1,1
    80004b8a:	6c88                	ld	a0,24(s1)
    80004b8c:	fffff097          	auipc	ra,0xfffff
    80004b90:	296080e7          	jalr	662(ra) # 80003e22 <readi>
    80004b94:	892a                	mv	s2,a0
    80004b96:	00a05563          	blez	a0,80004ba0 <fileread+0x56>
      f->off += r;
    80004b9a:	509c                	lw	a5,32(s1)
    80004b9c:	9fa9                	addw	a5,a5,a0
    80004b9e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004ba0:	6c88                	ld	a0,24(s1)
    80004ba2:	fffff097          	auipc	ra,0xfffff
    80004ba6:	08e080e7          	jalr	142(ra) # 80003c30 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004baa:	854a                	mv	a0,s2
    80004bac:	70a2                	ld	ra,40(sp)
    80004bae:	7402                	ld	s0,32(sp)
    80004bb0:	64e2                	ld	s1,24(sp)
    80004bb2:	6942                	ld	s2,16(sp)
    80004bb4:	69a2                	ld	s3,8(sp)
    80004bb6:	6145                	addi	sp,sp,48
    80004bb8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004bba:	6908                	ld	a0,16(a0)
    80004bbc:	00000097          	auipc	ra,0x0
    80004bc0:	3c0080e7          	jalr	960(ra) # 80004f7c <piperead>
    80004bc4:	892a                	mv	s2,a0
    80004bc6:	b7d5                	j	80004baa <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004bc8:	02451783          	lh	a5,36(a0)
    80004bcc:	03079693          	slli	a3,a5,0x30
    80004bd0:	92c1                	srli	a3,a3,0x30
    80004bd2:	4725                	li	a4,9
    80004bd4:	02d76863          	bltu	a4,a3,80004c04 <fileread+0xba>
    80004bd8:	0792                	slli	a5,a5,0x4
    80004bda:	00023717          	auipc	a4,0x23
    80004bde:	f3e70713          	addi	a4,a4,-194 # 80027b18 <devsw>
    80004be2:	97ba                	add	a5,a5,a4
    80004be4:	639c                	ld	a5,0(a5)
    80004be6:	c38d                	beqz	a5,80004c08 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004be8:	4505                	li	a0,1
    80004bea:	9782                	jalr	a5
    80004bec:	892a                	mv	s2,a0
    80004bee:	bf75                	j	80004baa <fileread+0x60>
    panic("fileread");
    80004bf0:	00004517          	auipc	a0,0x4
    80004bf4:	b8050513          	addi	a0,a0,-1152 # 80008770 <syscalls+0x270>
    80004bf8:	ffffc097          	auipc	ra,0xffffc
    80004bfc:	932080e7          	jalr	-1742(ra) # 8000052a <panic>
    return -1;
    80004c00:	597d                	li	s2,-1
    80004c02:	b765                	j	80004baa <fileread+0x60>
      return -1;
    80004c04:	597d                	li	s2,-1
    80004c06:	b755                	j	80004baa <fileread+0x60>
    80004c08:	597d                	li	s2,-1
    80004c0a:	b745                	j	80004baa <fileread+0x60>

0000000080004c0c <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004c0c:	715d                	addi	sp,sp,-80
    80004c0e:	e486                	sd	ra,72(sp)
    80004c10:	e0a2                	sd	s0,64(sp)
    80004c12:	fc26                	sd	s1,56(sp)
    80004c14:	f84a                	sd	s2,48(sp)
    80004c16:	f44e                	sd	s3,40(sp)
    80004c18:	f052                	sd	s4,32(sp)
    80004c1a:	ec56                	sd	s5,24(sp)
    80004c1c:	e85a                	sd	s6,16(sp)
    80004c1e:	e45e                	sd	s7,8(sp)
    80004c20:	e062                	sd	s8,0(sp)
    80004c22:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004c24:	00954783          	lbu	a5,9(a0)
    80004c28:	10078663          	beqz	a5,80004d34 <filewrite+0x128>
    80004c2c:	892a                	mv	s2,a0
    80004c2e:	8aae                	mv	s5,a1
    80004c30:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c32:	411c                	lw	a5,0(a0)
    80004c34:	4705                	li	a4,1
    80004c36:	02e78263          	beq	a5,a4,80004c5a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c3a:	470d                	li	a4,3
    80004c3c:	02e78663          	beq	a5,a4,80004c68 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c40:	4709                	li	a4,2
    80004c42:	0ee79163          	bne	a5,a4,80004d24 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004c46:	0ac05d63          	blez	a2,80004d00 <filewrite+0xf4>
    int i = 0;
    80004c4a:	4981                	li	s3,0
    80004c4c:	6b05                	lui	s6,0x1
    80004c4e:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004c52:	6b85                	lui	s7,0x1
    80004c54:	c00b8b9b          	addiw	s7,s7,-1024
    80004c58:	a861                	j	80004cf0 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004c5a:	6908                	ld	a0,16(a0)
    80004c5c:	00000097          	auipc	ra,0x0
    80004c60:	22e080e7          	jalr	558(ra) # 80004e8a <pipewrite>
    80004c64:	8a2a                	mv	s4,a0
    80004c66:	a045                	j	80004d06 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004c68:	02451783          	lh	a5,36(a0)
    80004c6c:	03079693          	slli	a3,a5,0x30
    80004c70:	92c1                	srli	a3,a3,0x30
    80004c72:	4725                	li	a4,9
    80004c74:	0cd76263          	bltu	a4,a3,80004d38 <filewrite+0x12c>
    80004c78:	0792                	slli	a5,a5,0x4
    80004c7a:	00023717          	auipc	a4,0x23
    80004c7e:	e9e70713          	addi	a4,a4,-354 # 80027b18 <devsw>
    80004c82:	97ba                	add	a5,a5,a4
    80004c84:	679c                	ld	a5,8(a5)
    80004c86:	cbdd                	beqz	a5,80004d3c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004c88:	4505                	li	a0,1
    80004c8a:	9782                	jalr	a5
    80004c8c:	8a2a                	mv	s4,a0
    80004c8e:	a8a5                	j	80004d06 <filewrite+0xfa>
    80004c90:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004c94:	00000097          	auipc	ra,0x0
    80004c98:	8b0080e7          	jalr	-1872(ra) # 80004544 <begin_op>
      ilock(f->ip);
    80004c9c:	01893503          	ld	a0,24(s2)
    80004ca0:	fffff097          	auipc	ra,0xfffff
    80004ca4:	ece080e7          	jalr	-306(ra) # 80003b6e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004ca8:	8762                	mv	a4,s8
    80004caa:	02092683          	lw	a3,32(s2)
    80004cae:	01598633          	add	a2,s3,s5
    80004cb2:	4585                	li	a1,1
    80004cb4:	01893503          	ld	a0,24(s2)
    80004cb8:	fffff097          	auipc	ra,0xfffff
    80004cbc:	262080e7          	jalr	610(ra) # 80003f1a <writei>
    80004cc0:	84aa                	mv	s1,a0
    80004cc2:	00a05763          	blez	a0,80004cd0 <filewrite+0xc4>
        f->off += r;
    80004cc6:	02092783          	lw	a5,32(s2)
    80004cca:	9fa9                	addw	a5,a5,a0
    80004ccc:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004cd0:	01893503          	ld	a0,24(s2)
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	f5c080e7          	jalr	-164(ra) # 80003c30 <iunlock>
      end_op();
    80004cdc:	00000097          	auipc	ra,0x0
    80004ce0:	8e8080e7          	jalr	-1816(ra) # 800045c4 <end_op>

      if(r != n1){
    80004ce4:	009c1f63          	bne	s8,s1,80004d02 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004ce8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004cec:	0149db63          	bge	s3,s4,80004d02 <filewrite+0xf6>
      int n1 = n - i;
    80004cf0:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004cf4:	84be                	mv	s1,a5
    80004cf6:	2781                	sext.w	a5,a5
    80004cf8:	f8fb5ce3          	bge	s6,a5,80004c90 <filewrite+0x84>
    80004cfc:	84de                	mv	s1,s7
    80004cfe:	bf49                	j	80004c90 <filewrite+0x84>
    int i = 0;
    80004d00:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004d02:	013a1f63          	bne	s4,s3,80004d20 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004d06:	8552                	mv	a0,s4
    80004d08:	60a6                	ld	ra,72(sp)
    80004d0a:	6406                	ld	s0,64(sp)
    80004d0c:	74e2                	ld	s1,56(sp)
    80004d0e:	7942                	ld	s2,48(sp)
    80004d10:	79a2                	ld	s3,40(sp)
    80004d12:	7a02                	ld	s4,32(sp)
    80004d14:	6ae2                	ld	s5,24(sp)
    80004d16:	6b42                	ld	s6,16(sp)
    80004d18:	6ba2                	ld	s7,8(sp)
    80004d1a:	6c02                	ld	s8,0(sp)
    80004d1c:	6161                	addi	sp,sp,80
    80004d1e:	8082                	ret
    ret = (i == n ? n : -1);
    80004d20:	5a7d                	li	s4,-1
    80004d22:	b7d5                	j	80004d06 <filewrite+0xfa>
    panic("filewrite");
    80004d24:	00004517          	auipc	a0,0x4
    80004d28:	a5c50513          	addi	a0,a0,-1444 # 80008780 <syscalls+0x280>
    80004d2c:	ffffb097          	auipc	ra,0xffffb
    80004d30:	7fe080e7          	jalr	2046(ra) # 8000052a <panic>
    return -1;
    80004d34:	5a7d                	li	s4,-1
    80004d36:	bfc1                	j	80004d06 <filewrite+0xfa>
      return -1;
    80004d38:	5a7d                	li	s4,-1
    80004d3a:	b7f1                	j	80004d06 <filewrite+0xfa>
    80004d3c:	5a7d                	li	s4,-1
    80004d3e:	b7e1                	j	80004d06 <filewrite+0xfa>

0000000080004d40 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004d40:	7179                	addi	sp,sp,-48
    80004d42:	f406                	sd	ra,40(sp)
    80004d44:	f022                	sd	s0,32(sp)
    80004d46:	ec26                	sd	s1,24(sp)
    80004d48:	e84a                	sd	s2,16(sp)
    80004d4a:	e44e                	sd	s3,8(sp)
    80004d4c:	e052                	sd	s4,0(sp)
    80004d4e:	1800                	addi	s0,sp,48
    80004d50:	84aa                	mv	s1,a0
    80004d52:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004d54:	0005b023          	sd	zero,0(a1)
    80004d58:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004d5c:	00000097          	auipc	ra,0x0
    80004d60:	bf8080e7          	jalr	-1032(ra) # 80004954 <filealloc>
    80004d64:	e088                	sd	a0,0(s1)
    80004d66:	c551                	beqz	a0,80004df2 <pipealloc+0xb2>
    80004d68:	00000097          	auipc	ra,0x0
    80004d6c:	bec080e7          	jalr	-1044(ra) # 80004954 <filealloc>
    80004d70:	00aa3023          	sd	a0,0(s4)
    80004d74:	c92d                	beqz	a0,80004de6 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004d76:	ffffc097          	auipc	ra,0xffffc
    80004d7a:	d5c080e7          	jalr	-676(ra) # 80000ad2 <kalloc>
    80004d7e:	892a                	mv	s2,a0
    80004d80:	c125                	beqz	a0,80004de0 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004d82:	4985                	li	s3,1
    80004d84:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004d88:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004d8c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004d90:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004d94:	00004597          	auipc	a1,0x4
    80004d98:	9fc58593          	addi	a1,a1,-1540 # 80008790 <syscalls+0x290>
    80004d9c:	ffffc097          	auipc	ra,0xffffc
    80004da0:	d96080e7          	jalr	-618(ra) # 80000b32 <initlock>
  (*f0)->type = FD_PIPE;
    80004da4:	609c                	ld	a5,0(s1)
    80004da6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004daa:	609c                	ld	a5,0(s1)
    80004dac:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004db0:	609c                	ld	a5,0(s1)
    80004db2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004db6:	609c                	ld	a5,0(s1)
    80004db8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004dbc:	000a3783          	ld	a5,0(s4)
    80004dc0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004dc4:	000a3783          	ld	a5,0(s4)
    80004dc8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004dcc:	000a3783          	ld	a5,0(s4)
    80004dd0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004dd4:	000a3783          	ld	a5,0(s4)
    80004dd8:	0127b823          	sd	s2,16(a5)
  return 0;
    80004ddc:	4501                	li	a0,0
    80004dde:	a025                	j	80004e06 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004de0:	6088                	ld	a0,0(s1)
    80004de2:	e501                	bnez	a0,80004dea <pipealloc+0xaa>
    80004de4:	a039                	j	80004df2 <pipealloc+0xb2>
    80004de6:	6088                	ld	a0,0(s1)
    80004de8:	c51d                	beqz	a0,80004e16 <pipealloc+0xd6>
    fileclose(*f0);
    80004dea:	00000097          	auipc	ra,0x0
    80004dee:	c26080e7          	jalr	-986(ra) # 80004a10 <fileclose>
  if(*f1)
    80004df2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004df6:	557d                	li	a0,-1
  if(*f1)
    80004df8:	c799                	beqz	a5,80004e06 <pipealloc+0xc6>
    fileclose(*f1);
    80004dfa:	853e                	mv	a0,a5
    80004dfc:	00000097          	auipc	ra,0x0
    80004e00:	c14080e7          	jalr	-1004(ra) # 80004a10 <fileclose>
  return -1;
    80004e04:	557d                	li	a0,-1
}
    80004e06:	70a2                	ld	ra,40(sp)
    80004e08:	7402                	ld	s0,32(sp)
    80004e0a:	64e2                	ld	s1,24(sp)
    80004e0c:	6942                	ld	s2,16(sp)
    80004e0e:	69a2                	ld	s3,8(sp)
    80004e10:	6a02                	ld	s4,0(sp)
    80004e12:	6145                	addi	sp,sp,48
    80004e14:	8082                	ret
  return -1;
    80004e16:	557d                	li	a0,-1
    80004e18:	b7fd                	j	80004e06 <pipealloc+0xc6>

0000000080004e1a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004e1a:	1101                	addi	sp,sp,-32
    80004e1c:	ec06                	sd	ra,24(sp)
    80004e1e:	e822                	sd	s0,16(sp)
    80004e20:	e426                	sd	s1,8(sp)
    80004e22:	e04a                	sd	s2,0(sp)
    80004e24:	1000                	addi	s0,sp,32
    80004e26:	84aa                	mv	s1,a0
    80004e28:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004e2a:	ffffc097          	auipc	ra,0xffffc
    80004e2e:	d98080e7          	jalr	-616(ra) # 80000bc2 <acquire>
  if(writable){
    80004e32:	02090d63          	beqz	s2,80004e6c <pipeclose+0x52>
    pi->writeopen = 0;
    80004e36:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004e3a:	21848513          	addi	a0,s1,536
    80004e3e:	ffffd097          	auipc	ra,0xffffd
    80004e42:	458080e7          	jalr	1112(ra) # 80002296 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004e46:	2204b783          	ld	a5,544(s1)
    80004e4a:	eb95                	bnez	a5,80004e7e <pipeclose+0x64>
    release(&pi->lock);
    80004e4c:	8526                	mv	a0,s1
    80004e4e:	ffffc097          	auipc	ra,0xffffc
    80004e52:	e28080e7          	jalr	-472(ra) # 80000c76 <release>
    kfree((char*)pi);
    80004e56:	8526                	mv	a0,s1
    80004e58:	ffffc097          	auipc	ra,0xffffc
    80004e5c:	b7e080e7          	jalr	-1154(ra) # 800009d6 <kfree>
  } else
    release(&pi->lock);
}
    80004e60:	60e2                	ld	ra,24(sp)
    80004e62:	6442                	ld	s0,16(sp)
    80004e64:	64a2                	ld	s1,8(sp)
    80004e66:	6902                	ld	s2,0(sp)
    80004e68:	6105                	addi	sp,sp,32
    80004e6a:	8082                	ret
    pi->readopen = 0;
    80004e6c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004e70:	21c48513          	addi	a0,s1,540
    80004e74:	ffffd097          	auipc	ra,0xffffd
    80004e78:	422080e7          	jalr	1058(ra) # 80002296 <wakeup>
    80004e7c:	b7e9                	j	80004e46 <pipeclose+0x2c>
    release(&pi->lock);
    80004e7e:	8526                	mv	a0,s1
    80004e80:	ffffc097          	auipc	ra,0xffffc
    80004e84:	df6080e7          	jalr	-522(ra) # 80000c76 <release>
}
    80004e88:	bfe1                	j	80004e60 <pipeclose+0x46>

0000000080004e8a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004e8a:	711d                	addi	sp,sp,-96
    80004e8c:	ec86                	sd	ra,88(sp)
    80004e8e:	e8a2                	sd	s0,80(sp)
    80004e90:	e4a6                	sd	s1,72(sp)
    80004e92:	e0ca                	sd	s2,64(sp)
    80004e94:	fc4e                	sd	s3,56(sp)
    80004e96:	f852                	sd	s4,48(sp)
    80004e98:	f456                	sd	s5,40(sp)
    80004e9a:	f05a                	sd	s6,32(sp)
    80004e9c:	ec5e                	sd	s7,24(sp)
    80004e9e:	e862                	sd	s8,16(sp)
    80004ea0:	1080                	addi	s0,sp,96
    80004ea2:	84aa                	mv	s1,a0
    80004ea4:	8aae                	mv	s5,a1
    80004ea6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004ea8:	ffffd097          	auipc	ra,0xffffd
    80004eac:	ad6080e7          	jalr	-1322(ra) # 8000197e <myproc>
    80004eb0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004eb2:	8526                	mv	a0,s1
    80004eb4:	ffffc097          	auipc	ra,0xffffc
    80004eb8:	d0e080e7          	jalr	-754(ra) # 80000bc2 <acquire>
  while(i < n){
    80004ebc:	0b405363          	blez	s4,80004f62 <pipewrite+0xd8>
  int i = 0;
    80004ec0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004ec2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004ec4:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004ec8:	21c48b93          	addi	s7,s1,540
    80004ecc:	a089                	j	80004f0e <pipewrite+0x84>
      release(&pi->lock);
    80004ece:	8526                	mv	a0,s1
    80004ed0:	ffffc097          	auipc	ra,0xffffc
    80004ed4:	da6080e7          	jalr	-602(ra) # 80000c76 <release>
      return -1;
    80004ed8:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004eda:	854a                	mv	a0,s2
    80004edc:	60e6                	ld	ra,88(sp)
    80004ede:	6446                	ld	s0,80(sp)
    80004ee0:	64a6                	ld	s1,72(sp)
    80004ee2:	6906                	ld	s2,64(sp)
    80004ee4:	79e2                	ld	s3,56(sp)
    80004ee6:	7a42                	ld	s4,48(sp)
    80004ee8:	7aa2                	ld	s5,40(sp)
    80004eea:	7b02                	ld	s6,32(sp)
    80004eec:	6be2                	ld	s7,24(sp)
    80004eee:	6c42                	ld	s8,16(sp)
    80004ef0:	6125                	addi	sp,sp,96
    80004ef2:	8082                	ret
      wakeup(&pi->nread);
    80004ef4:	8562                	mv	a0,s8
    80004ef6:	ffffd097          	auipc	ra,0xffffd
    80004efa:	3a0080e7          	jalr	928(ra) # 80002296 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004efe:	85a6                	mv	a1,s1
    80004f00:	855e                	mv	a0,s7
    80004f02:	ffffd097          	auipc	ra,0xffffd
    80004f06:	208080e7          	jalr	520(ra) # 8000210a <sleep>
  while(i < n){
    80004f0a:	05495d63          	bge	s2,s4,80004f64 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80004f0e:	2204a783          	lw	a5,544(s1)
    80004f12:	dfd5                	beqz	a5,80004ece <pipewrite+0x44>
    80004f14:	0289a783          	lw	a5,40(s3)
    80004f18:	fbdd                	bnez	a5,80004ece <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004f1a:	2184a783          	lw	a5,536(s1)
    80004f1e:	21c4a703          	lw	a4,540(s1)
    80004f22:	2007879b          	addiw	a5,a5,512
    80004f26:	fcf707e3          	beq	a4,a5,80004ef4 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004f2a:	4685                	li	a3,1
    80004f2c:	01590633          	add	a2,s2,s5
    80004f30:	faf40593          	addi	a1,s0,-81
    80004f34:	0509b503          	ld	a0,80(s3)
    80004f38:	ffffc097          	auipc	ra,0xffffc
    80004f3c:	792080e7          	jalr	1938(ra) # 800016ca <copyin>
    80004f40:	03650263          	beq	a0,s6,80004f64 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004f44:	21c4a783          	lw	a5,540(s1)
    80004f48:	0017871b          	addiw	a4,a5,1
    80004f4c:	20e4ae23          	sw	a4,540(s1)
    80004f50:	1ff7f793          	andi	a5,a5,511
    80004f54:	97a6                	add	a5,a5,s1
    80004f56:	faf44703          	lbu	a4,-81(s0)
    80004f5a:	00e78c23          	sb	a4,24(a5)
      i++;
    80004f5e:	2905                	addiw	s2,s2,1
    80004f60:	b76d                	j	80004f0a <pipewrite+0x80>
  int i = 0;
    80004f62:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004f64:	21848513          	addi	a0,s1,536
    80004f68:	ffffd097          	auipc	ra,0xffffd
    80004f6c:	32e080e7          	jalr	814(ra) # 80002296 <wakeup>
  release(&pi->lock);
    80004f70:	8526                	mv	a0,s1
    80004f72:	ffffc097          	auipc	ra,0xffffc
    80004f76:	d04080e7          	jalr	-764(ra) # 80000c76 <release>
  return i;
    80004f7a:	b785                	j	80004eda <pipewrite+0x50>

0000000080004f7c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004f7c:	715d                	addi	sp,sp,-80
    80004f7e:	e486                	sd	ra,72(sp)
    80004f80:	e0a2                	sd	s0,64(sp)
    80004f82:	fc26                	sd	s1,56(sp)
    80004f84:	f84a                	sd	s2,48(sp)
    80004f86:	f44e                	sd	s3,40(sp)
    80004f88:	f052                	sd	s4,32(sp)
    80004f8a:	ec56                	sd	s5,24(sp)
    80004f8c:	e85a                	sd	s6,16(sp)
    80004f8e:	0880                	addi	s0,sp,80
    80004f90:	84aa                	mv	s1,a0
    80004f92:	892e                	mv	s2,a1
    80004f94:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004f96:	ffffd097          	auipc	ra,0xffffd
    80004f9a:	9e8080e7          	jalr	-1560(ra) # 8000197e <myproc>
    80004f9e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004fa0:	8526                	mv	a0,s1
    80004fa2:	ffffc097          	auipc	ra,0xffffc
    80004fa6:	c20080e7          	jalr	-992(ra) # 80000bc2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004faa:	2184a703          	lw	a4,536(s1)
    80004fae:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004fb2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004fb6:	02f71463          	bne	a4,a5,80004fde <piperead+0x62>
    80004fba:	2244a783          	lw	a5,548(s1)
    80004fbe:	c385                	beqz	a5,80004fde <piperead+0x62>
    if(pr->killed){
    80004fc0:	028a2783          	lw	a5,40(s4)
    80004fc4:	ebc1                	bnez	a5,80005054 <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004fc6:	85a6                	mv	a1,s1
    80004fc8:	854e                	mv	a0,s3
    80004fca:	ffffd097          	auipc	ra,0xffffd
    80004fce:	140080e7          	jalr	320(ra) # 8000210a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004fd2:	2184a703          	lw	a4,536(s1)
    80004fd6:	21c4a783          	lw	a5,540(s1)
    80004fda:	fef700e3          	beq	a4,a5,80004fba <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004fde:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004fe0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004fe2:	05505363          	blez	s5,80005028 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004fe6:	2184a783          	lw	a5,536(s1)
    80004fea:	21c4a703          	lw	a4,540(s1)
    80004fee:	02f70d63          	beq	a4,a5,80005028 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004ff2:	0017871b          	addiw	a4,a5,1
    80004ff6:	20e4ac23          	sw	a4,536(s1)
    80004ffa:	1ff7f793          	andi	a5,a5,511
    80004ffe:	97a6                	add	a5,a5,s1
    80005000:	0187c783          	lbu	a5,24(a5)
    80005004:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005008:	4685                	li	a3,1
    8000500a:	fbf40613          	addi	a2,s0,-65
    8000500e:	85ca                	mv	a1,s2
    80005010:	050a3503          	ld	a0,80(s4)
    80005014:	ffffc097          	auipc	ra,0xffffc
    80005018:	62a080e7          	jalr	1578(ra) # 8000163e <copyout>
    8000501c:	01650663          	beq	a0,s6,80005028 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005020:	2985                	addiw	s3,s3,1
    80005022:	0905                	addi	s2,s2,1
    80005024:	fd3a91e3          	bne	s5,s3,80004fe6 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005028:	21c48513          	addi	a0,s1,540
    8000502c:	ffffd097          	auipc	ra,0xffffd
    80005030:	26a080e7          	jalr	618(ra) # 80002296 <wakeup>
  release(&pi->lock);
    80005034:	8526                	mv	a0,s1
    80005036:	ffffc097          	auipc	ra,0xffffc
    8000503a:	c40080e7          	jalr	-960(ra) # 80000c76 <release>
  return i;
}
    8000503e:	854e                	mv	a0,s3
    80005040:	60a6                	ld	ra,72(sp)
    80005042:	6406                	ld	s0,64(sp)
    80005044:	74e2                	ld	s1,56(sp)
    80005046:	7942                	ld	s2,48(sp)
    80005048:	79a2                	ld	s3,40(sp)
    8000504a:	7a02                	ld	s4,32(sp)
    8000504c:	6ae2                	ld	s5,24(sp)
    8000504e:	6b42                	ld	s6,16(sp)
    80005050:	6161                	addi	sp,sp,80
    80005052:	8082                	ret
      release(&pi->lock);
    80005054:	8526                	mv	a0,s1
    80005056:	ffffc097          	auipc	ra,0xffffc
    8000505a:	c20080e7          	jalr	-992(ra) # 80000c76 <release>
      return -1;
    8000505e:	59fd                	li	s3,-1
    80005060:	bff9                	j	8000503e <piperead+0xc2>

0000000080005062 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80005062:	de010113          	addi	sp,sp,-544
    80005066:	20113c23          	sd	ra,536(sp)
    8000506a:	20813823          	sd	s0,528(sp)
    8000506e:	20913423          	sd	s1,520(sp)
    80005072:	21213023          	sd	s2,512(sp)
    80005076:	ffce                	sd	s3,504(sp)
    80005078:	fbd2                	sd	s4,496(sp)
    8000507a:	f7d6                	sd	s5,488(sp)
    8000507c:	f3da                	sd	s6,480(sp)
    8000507e:	efde                	sd	s7,472(sp)
    80005080:	ebe2                	sd	s8,464(sp)
    80005082:	e7e6                	sd	s9,456(sp)
    80005084:	e3ea                	sd	s10,448(sp)
    80005086:	ff6e                	sd	s11,440(sp)
    80005088:	1400                	addi	s0,sp,544
    8000508a:	892a                	mv	s2,a0
    8000508c:	dea43423          	sd	a0,-536(s0)
    80005090:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005094:	ffffd097          	auipc	ra,0xffffd
    80005098:	8ea080e7          	jalr	-1814(ra) # 8000197e <myproc>
    8000509c:	84aa                	mv	s1,a0

  begin_op();
    8000509e:	fffff097          	auipc	ra,0xfffff
    800050a2:	4a6080e7          	jalr	1190(ra) # 80004544 <begin_op>

  if((ip = namei(path)) == 0){
    800050a6:	854a                	mv	a0,s2
    800050a8:	fffff097          	auipc	ra,0xfffff
    800050ac:	27c080e7          	jalr	636(ra) # 80004324 <namei>
    800050b0:	c93d                	beqz	a0,80005126 <exec+0xc4>
    800050b2:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800050b4:	fffff097          	auipc	ra,0xfffff
    800050b8:	aba080e7          	jalr	-1350(ra) # 80003b6e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800050bc:	04000713          	li	a4,64
    800050c0:	4681                	li	a3,0
    800050c2:	e4840613          	addi	a2,s0,-440
    800050c6:	4581                	li	a1,0
    800050c8:	8556                	mv	a0,s5
    800050ca:	fffff097          	auipc	ra,0xfffff
    800050ce:	d58080e7          	jalr	-680(ra) # 80003e22 <readi>
    800050d2:	04000793          	li	a5,64
    800050d6:	00f51a63          	bne	a0,a5,800050ea <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800050da:	e4842703          	lw	a4,-440(s0)
    800050de:	464c47b7          	lui	a5,0x464c4
    800050e2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800050e6:	04f70663          	beq	a4,a5,80005132 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800050ea:	8556                	mv	a0,s5
    800050ec:	fffff097          	auipc	ra,0xfffff
    800050f0:	ce4080e7          	jalr	-796(ra) # 80003dd0 <iunlockput>
    end_op();
    800050f4:	fffff097          	auipc	ra,0xfffff
    800050f8:	4d0080e7          	jalr	1232(ra) # 800045c4 <end_op>
  }
  return -1;
    800050fc:	557d                	li	a0,-1
}
    800050fe:	21813083          	ld	ra,536(sp)
    80005102:	21013403          	ld	s0,528(sp)
    80005106:	20813483          	ld	s1,520(sp)
    8000510a:	20013903          	ld	s2,512(sp)
    8000510e:	79fe                	ld	s3,504(sp)
    80005110:	7a5e                	ld	s4,496(sp)
    80005112:	7abe                	ld	s5,488(sp)
    80005114:	7b1e                	ld	s6,480(sp)
    80005116:	6bfe                	ld	s7,472(sp)
    80005118:	6c5e                	ld	s8,464(sp)
    8000511a:	6cbe                	ld	s9,456(sp)
    8000511c:	6d1e                	ld	s10,448(sp)
    8000511e:	7dfa                	ld	s11,440(sp)
    80005120:	22010113          	addi	sp,sp,544
    80005124:	8082                	ret
    end_op();
    80005126:	fffff097          	auipc	ra,0xfffff
    8000512a:	49e080e7          	jalr	1182(ra) # 800045c4 <end_op>
    return -1;
    8000512e:	557d                	li	a0,-1
    80005130:	b7f9                	j	800050fe <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80005132:	8526                	mv	a0,s1
    80005134:	ffffd097          	auipc	ra,0xffffd
    80005138:	90e080e7          	jalr	-1778(ra) # 80001a42 <proc_pagetable>
    8000513c:	8b2a                	mv	s6,a0
    8000513e:	d555                	beqz	a0,800050ea <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005140:	e6842783          	lw	a5,-408(s0)
    80005144:	e8045703          	lhu	a4,-384(s0)
    80005148:	c735                	beqz	a4,800051b4 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    8000514a:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000514c:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80005150:	6a05                	lui	s4,0x1
    80005152:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80005156:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    8000515a:	6d85                	lui	s11,0x1
    8000515c:	7d7d                	lui	s10,0xfffff
    8000515e:	acb9                	j	800053bc <exec+0x35a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80005160:	00003517          	auipc	a0,0x3
    80005164:	63850513          	addi	a0,a0,1592 # 80008798 <syscalls+0x298>
    80005168:	ffffb097          	auipc	ra,0xffffb
    8000516c:	3c2080e7          	jalr	962(ra) # 8000052a <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005170:	874a                	mv	a4,s2
    80005172:	009c86bb          	addw	a3,s9,s1
    80005176:	4581                	li	a1,0
    80005178:	8556                	mv	a0,s5
    8000517a:	fffff097          	auipc	ra,0xfffff
    8000517e:	ca8080e7          	jalr	-856(ra) # 80003e22 <readi>
    80005182:	2501                	sext.w	a0,a0
    80005184:	1ca91c63          	bne	s2,a0,8000535c <exec+0x2fa>
  for(i = 0; i < sz; i += PGSIZE){
    80005188:	009d84bb          	addw	s1,s11,s1
    8000518c:	013d09bb          	addw	s3,s10,s3
    80005190:	2174f663          	bgeu	s1,s7,8000539c <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    80005194:	02049593          	slli	a1,s1,0x20
    80005198:	9181                	srli	a1,a1,0x20
    8000519a:	95e2                	add	a1,a1,s8
    8000519c:	855a                	mv	a0,s6
    8000519e:	ffffc097          	auipc	ra,0xffffc
    800051a2:	eae080e7          	jalr	-338(ra) # 8000104c <walkaddr>
    800051a6:	862a                	mv	a2,a0
    if(pa == 0)
    800051a8:	dd45                	beqz	a0,80005160 <exec+0xfe>
      n = PGSIZE;
    800051aa:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800051ac:	fd49f2e3          	bgeu	s3,s4,80005170 <exec+0x10e>
      n = sz - i;
    800051b0:	894e                	mv	s2,s3
    800051b2:	bf7d                	j	80005170 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    800051b4:	4481                	li	s1,0
  iunlockput(ip);
    800051b6:	8556                	mv	a0,s5
    800051b8:	fffff097          	auipc	ra,0xfffff
    800051bc:	c18080e7          	jalr	-1000(ra) # 80003dd0 <iunlockput>
  end_op();
    800051c0:	fffff097          	auipc	ra,0xfffff
    800051c4:	404080e7          	jalr	1028(ra) # 800045c4 <end_op>
  p = myproc();
    800051c8:	ffffc097          	auipc	ra,0xffffc
    800051cc:	7b6080e7          	jalr	1974(ra) # 8000197e <myproc>
    800051d0:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800051d2:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800051d6:	6785                	lui	a5,0x1
    800051d8:	17fd                	addi	a5,a5,-1
    800051da:	94be                	add	s1,s1,a5
    800051dc:	77fd                	lui	a5,0xfffff
    800051de:	8fe5                	and	a5,a5,s1
    800051e0:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800051e4:	6609                	lui	a2,0x2
    800051e6:	963e                	add	a2,a2,a5
    800051e8:	85be                	mv	a1,a5
    800051ea:	855a                	mv	a0,s6
    800051ec:	ffffc097          	auipc	ra,0xffffc
    800051f0:	202080e7          	jalr	514(ra) # 800013ee <uvmalloc>
    800051f4:	8c2a                	mv	s8,a0
  ip = 0;
    800051f6:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800051f8:	16050263          	beqz	a0,8000535c <exec+0x2fa>
  uvmclear(pagetable, sz-2*PGSIZE);
    800051fc:	75f9                	lui	a1,0xffffe
    800051fe:	95aa                	add	a1,a1,a0
    80005200:	855a                	mv	a0,s6
    80005202:	ffffc097          	auipc	ra,0xffffc
    80005206:	40a080e7          	jalr	1034(ra) # 8000160c <uvmclear>
  stackbase = sp - PGSIZE;
    8000520a:	7afd                	lui	s5,0xfffff
    8000520c:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000520e:	df043783          	ld	a5,-528(s0)
    80005212:	6388                	ld	a0,0(a5)
    80005214:	c925                	beqz	a0,80005284 <exec+0x222>
    80005216:	e8840993          	addi	s3,s0,-376
    8000521a:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    8000521e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005220:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005222:	ffffc097          	auipc	ra,0xffffc
    80005226:	c20080e7          	jalr	-992(ra) # 80000e42 <strlen>
    8000522a:	0015079b          	addiw	a5,a0,1
    8000522e:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005232:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80005236:	15596763          	bltu	s2,s5,80005384 <exec+0x322>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000523a:	df043d83          	ld	s11,-528(s0)
    8000523e:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005242:	8552                	mv	a0,s4
    80005244:	ffffc097          	auipc	ra,0xffffc
    80005248:	bfe080e7          	jalr	-1026(ra) # 80000e42 <strlen>
    8000524c:	0015069b          	addiw	a3,a0,1
    80005250:	8652                	mv	a2,s4
    80005252:	85ca                	mv	a1,s2
    80005254:	855a                	mv	a0,s6
    80005256:	ffffc097          	auipc	ra,0xffffc
    8000525a:	3e8080e7          	jalr	1000(ra) # 8000163e <copyout>
    8000525e:	12054763          	bltz	a0,8000538c <exec+0x32a>
    ustack[argc] = sp;
    80005262:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005266:	0485                	addi	s1,s1,1
    80005268:	008d8793          	addi	a5,s11,8
    8000526c:	def43823          	sd	a5,-528(s0)
    80005270:	008db503          	ld	a0,8(s11)
    80005274:	c911                	beqz	a0,80005288 <exec+0x226>
    if(argc >= MAXARG)
    80005276:	09a1                	addi	s3,s3,8
    80005278:	fb9995e3          	bne	s3,s9,80005222 <exec+0x1c0>
  sz = sz1;
    8000527c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005280:	4a81                	li	s5,0
    80005282:	a8e9                	j	8000535c <exec+0x2fa>
  sp = sz;
    80005284:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005286:	4481                	li	s1,0
  ustack[argc] = 0;
    80005288:	00349793          	slli	a5,s1,0x3
    8000528c:	f9040713          	addi	a4,s0,-112
    80005290:	97ba                	add	a5,a5,a4
    80005292:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd2ef8>
  sp -= (argc+1) * sizeof(uint64);
    80005296:	00148693          	addi	a3,s1,1
    8000529a:	068e                	slli	a3,a3,0x3
    8000529c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800052a0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800052a4:	01597663          	bgeu	s2,s5,800052b0 <exec+0x24e>
  sz = sz1;
    800052a8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800052ac:	4a81                	li	s5,0
    800052ae:	a07d                	j	8000535c <exec+0x2fa>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800052b0:	e8840613          	addi	a2,s0,-376
    800052b4:	85ca                	mv	a1,s2
    800052b6:	855a                	mv	a0,s6
    800052b8:	ffffc097          	auipc	ra,0xffffc
    800052bc:	386080e7          	jalr	902(ra) # 8000163e <copyout>
    800052c0:	0c054a63          	bltz	a0,80005394 <exec+0x332>
  p->trapframe->a1 = sp;
    800052c4:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800052c8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800052cc:	de843783          	ld	a5,-536(s0)
    800052d0:	0007c703          	lbu	a4,0(a5)
    800052d4:	cf11                	beqz	a4,800052f0 <exec+0x28e>
    800052d6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800052d8:	02f00693          	li	a3,47
    800052dc:	a039                	j	800052ea <exec+0x288>
      last = s+1;
    800052de:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800052e2:	0785                	addi	a5,a5,1
    800052e4:	fff7c703          	lbu	a4,-1(a5)
    800052e8:	c701                	beqz	a4,800052f0 <exec+0x28e>
    if(*s == '/')
    800052ea:	fed71ce3          	bne	a4,a3,800052e2 <exec+0x280>
    800052ee:	bfc5                	j	800052de <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800052f0:	4641                	li	a2,16
    800052f2:	de843583          	ld	a1,-536(s0)
    800052f6:	158b8513          	addi	a0,s7,344
    800052fa:	ffffc097          	auipc	ra,0xffffc
    800052fe:	b16080e7          	jalr	-1258(ra) # 80000e10 <safestrcpy>
  oldpagetable = p->pagetable;
    80005302:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80005306:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000530a:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000530e:	058bb783          	ld	a5,88(s7)
    80005312:	e6043703          	ld	a4,-416(s0)
    80005316:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005318:	058bb783          	ld	a5,88(s7)
    8000531c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005320:	85ea                	mv	a1,s10
    80005322:	ffffc097          	auipc	ra,0xffffc
    80005326:	7bc080e7          	jalr	1980(ra) # 80001ade <proc_freepagetable>
  for (int i =0; i<32; i++){
    8000532a:	170b8713          	addi	a4,s7,368
    8000532e:	284b8793          	addi	a5,s7,644
    80005332:	304b8593          	addi	a1,s7,772
    if(signalHanlder != (void*)SIG_IGN && signalHanlder != (void*)SIG_DFL){
    80005336:	4605                	li	a2,1
    80005338:	a029                	j	80005342 <exec+0x2e0>
  for (int i =0; i<32; i++){
    8000533a:	0721                	addi	a4,a4,8
    8000533c:	0791                	addi	a5,a5,4
    8000533e:	00f58863          	beq	a1,a5,8000534e <exec+0x2ec>
    if(signalHanlder != (void*)SIG_IGN && signalHanlder != (void*)SIG_DFL){
    80005342:	6314                	ld	a3,0(a4)
    80005344:	fed67be3          	bgeu	a2,a3,8000533a <exec+0x2d8>
      p->maskHandlers[i]= 0;
    80005348:	0007a023          	sw	zero,0(a5)
    8000534c:	b7fd                	j	8000533a <exec+0x2d8>
  p->signalMask = 0;
    8000534e:	160ba623          	sw	zero,364(s7)
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005352:	0004851b          	sext.w	a0,s1
    80005356:	b365                	j	800050fe <exec+0x9c>
    80005358:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000535c:	df843583          	ld	a1,-520(s0)
    80005360:	855a                	mv	a0,s6
    80005362:	ffffc097          	auipc	ra,0xffffc
    80005366:	77c080e7          	jalr	1916(ra) # 80001ade <proc_freepagetable>
  if(ip){
    8000536a:	d80a90e3          	bnez	s5,800050ea <exec+0x88>
  return -1;
    8000536e:	557d                	li	a0,-1
    80005370:	b379                	j	800050fe <exec+0x9c>
    80005372:	de943c23          	sd	s1,-520(s0)
    80005376:	b7dd                	j	8000535c <exec+0x2fa>
    80005378:	de943c23          	sd	s1,-520(s0)
    8000537c:	b7c5                	j	8000535c <exec+0x2fa>
    8000537e:	de943c23          	sd	s1,-520(s0)
    80005382:	bfe9                	j	8000535c <exec+0x2fa>
  sz = sz1;
    80005384:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005388:	4a81                	li	s5,0
    8000538a:	bfc9                	j	8000535c <exec+0x2fa>
  sz = sz1;
    8000538c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005390:	4a81                	li	s5,0
    80005392:	b7e9                	j	8000535c <exec+0x2fa>
  sz = sz1;
    80005394:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005398:	4a81                	li	s5,0
    8000539a:	b7c9                	j	8000535c <exec+0x2fa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000539c:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800053a0:	e0843783          	ld	a5,-504(s0)
    800053a4:	0017869b          	addiw	a3,a5,1
    800053a8:	e0d43423          	sd	a3,-504(s0)
    800053ac:	e0043783          	ld	a5,-512(s0)
    800053b0:	0387879b          	addiw	a5,a5,56
    800053b4:	e8045703          	lhu	a4,-384(s0)
    800053b8:	dee6dfe3          	bge	a3,a4,800051b6 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800053bc:	2781                	sext.w	a5,a5
    800053be:	e0f43023          	sd	a5,-512(s0)
    800053c2:	03800713          	li	a4,56
    800053c6:	86be                	mv	a3,a5
    800053c8:	e1040613          	addi	a2,s0,-496
    800053cc:	4581                	li	a1,0
    800053ce:	8556                	mv	a0,s5
    800053d0:	fffff097          	auipc	ra,0xfffff
    800053d4:	a52080e7          	jalr	-1454(ra) # 80003e22 <readi>
    800053d8:	03800793          	li	a5,56
    800053dc:	f6f51ee3          	bne	a0,a5,80005358 <exec+0x2f6>
    if(ph.type != ELF_PROG_LOAD)
    800053e0:	e1042783          	lw	a5,-496(s0)
    800053e4:	4705                	li	a4,1
    800053e6:	fae79de3          	bne	a5,a4,800053a0 <exec+0x33e>
    if(ph.memsz < ph.filesz)
    800053ea:	e3843603          	ld	a2,-456(s0)
    800053ee:	e3043783          	ld	a5,-464(s0)
    800053f2:	f8f660e3          	bltu	a2,a5,80005372 <exec+0x310>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800053f6:	e2043783          	ld	a5,-480(s0)
    800053fa:	963e                	add	a2,a2,a5
    800053fc:	f6f66ee3          	bltu	a2,a5,80005378 <exec+0x316>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005400:	85a6                	mv	a1,s1
    80005402:	855a                	mv	a0,s6
    80005404:	ffffc097          	auipc	ra,0xffffc
    80005408:	fea080e7          	jalr	-22(ra) # 800013ee <uvmalloc>
    8000540c:	dea43c23          	sd	a0,-520(s0)
    80005410:	d53d                	beqz	a0,8000537e <exec+0x31c>
    if(ph.vaddr % PGSIZE != 0)
    80005412:	e2043c03          	ld	s8,-480(s0)
    80005416:	de043783          	ld	a5,-544(s0)
    8000541a:	00fc77b3          	and	a5,s8,a5
    8000541e:	ff9d                	bnez	a5,8000535c <exec+0x2fa>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005420:	e1842c83          	lw	s9,-488(s0)
    80005424:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005428:	f60b8ae3          	beqz	s7,8000539c <exec+0x33a>
    8000542c:	89de                	mv	s3,s7
    8000542e:	4481                	li	s1,0
    80005430:	b395                	j	80005194 <exec+0x132>

0000000080005432 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005432:	7179                	addi	sp,sp,-48
    80005434:	f406                	sd	ra,40(sp)
    80005436:	f022                	sd	s0,32(sp)
    80005438:	ec26                	sd	s1,24(sp)
    8000543a:	e84a                	sd	s2,16(sp)
    8000543c:	1800                	addi	s0,sp,48
    8000543e:	892e                	mv	s2,a1
    80005440:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005442:	fdc40593          	addi	a1,s0,-36
    80005446:	ffffe097          	auipc	ra,0xffffe
    8000544a:	ae8080e7          	jalr	-1304(ra) # 80002f2e <argint>
    8000544e:	04054063          	bltz	a0,8000548e <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005452:	fdc42703          	lw	a4,-36(s0)
    80005456:	47bd                	li	a5,15
    80005458:	02e7ed63          	bltu	a5,a4,80005492 <argfd+0x60>
    8000545c:	ffffc097          	auipc	ra,0xffffc
    80005460:	522080e7          	jalr	1314(ra) # 8000197e <myproc>
    80005464:	fdc42703          	lw	a4,-36(s0)
    80005468:	01a70793          	addi	a5,a4,26
    8000546c:	078e                	slli	a5,a5,0x3
    8000546e:	953e                	add	a0,a0,a5
    80005470:	611c                	ld	a5,0(a0)
    80005472:	c395                	beqz	a5,80005496 <argfd+0x64>
    return -1;
  if(pfd)
    80005474:	00090463          	beqz	s2,8000547c <argfd+0x4a>
    *pfd = fd;
    80005478:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000547c:	4501                	li	a0,0
  if(pf)
    8000547e:	c091                	beqz	s1,80005482 <argfd+0x50>
    *pf = f;
    80005480:	e09c                	sd	a5,0(s1)
}
    80005482:	70a2                	ld	ra,40(sp)
    80005484:	7402                	ld	s0,32(sp)
    80005486:	64e2                	ld	s1,24(sp)
    80005488:	6942                	ld	s2,16(sp)
    8000548a:	6145                	addi	sp,sp,48
    8000548c:	8082                	ret
    return -1;
    8000548e:	557d                	li	a0,-1
    80005490:	bfcd                	j	80005482 <argfd+0x50>
    return -1;
    80005492:	557d                	li	a0,-1
    80005494:	b7fd                	j	80005482 <argfd+0x50>
    80005496:	557d                	li	a0,-1
    80005498:	b7ed                	j	80005482 <argfd+0x50>

000000008000549a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000549a:	1101                	addi	sp,sp,-32
    8000549c:	ec06                	sd	ra,24(sp)
    8000549e:	e822                	sd	s0,16(sp)
    800054a0:	e426                	sd	s1,8(sp)
    800054a2:	1000                	addi	s0,sp,32
    800054a4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800054a6:	ffffc097          	auipc	ra,0xffffc
    800054aa:	4d8080e7          	jalr	1240(ra) # 8000197e <myproc>
    800054ae:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800054b0:	0d050793          	addi	a5,a0,208
    800054b4:	4501                	li	a0,0
    800054b6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800054b8:	6398                	ld	a4,0(a5)
    800054ba:	cb19                	beqz	a4,800054d0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800054bc:	2505                	addiw	a0,a0,1
    800054be:	07a1                	addi	a5,a5,8
    800054c0:	fed51ce3          	bne	a0,a3,800054b8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800054c4:	557d                	li	a0,-1
}
    800054c6:	60e2                	ld	ra,24(sp)
    800054c8:	6442                	ld	s0,16(sp)
    800054ca:	64a2                	ld	s1,8(sp)
    800054cc:	6105                	addi	sp,sp,32
    800054ce:	8082                	ret
      p->ofile[fd] = f;
    800054d0:	01a50793          	addi	a5,a0,26
    800054d4:	078e                	slli	a5,a5,0x3
    800054d6:	963e                	add	a2,a2,a5
    800054d8:	e204                	sd	s1,0(a2)
      return fd;
    800054da:	b7f5                	j	800054c6 <fdalloc+0x2c>

00000000800054dc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800054dc:	715d                	addi	sp,sp,-80
    800054de:	e486                	sd	ra,72(sp)
    800054e0:	e0a2                	sd	s0,64(sp)
    800054e2:	fc26                	sd	s1,56(sp)
    800054e4:	f84a                	sd	s2,48(sp)
    800054e6:	f44e                	sd	s3,40(sp)
    800054e8:	f052                	sd	s4,32(sp)
    800054ea:	ec56                	sd	s5,24(sp)
    800054ec:	0880                	addi	s0,sp,80
    800054ee:	89ae                	mv	s3,a1
    800054f0:	8ab2                	mv	s5,a2
    800054f2:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800054f4:	fb040593          	addi	a1,s0,-80
    800054f8:	fffff097          	auipc	ra,0xfffff
    800054fc:	e4a080e7          	jalr	-438(ra) # 80004342 <nameiparent>
    80005500:	892a                	mv	s2,a0
    80005502:	12050e63          	beqz	a0,8000563e <create+0x162>
    return 0;

  ilock(dp);
    80005506:	ffffe097          	auipc	ra,0xffffe
    8000550a:	668080e7          	jalr	1640(ra) # 80003b6e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000550e:	4601                	li	a2,0
    80005510:	fb040593          	addi	a1,s0,-80
    80005514:	854a                	mv	a0,s2
    80005516:	fffff097          	auipc	ra,0xfffff
    8000551a:	b3c080e7          	jalr	-1220(ra) # 80004052 <dirlookup>
    8000551e:	84aa                	mv	s1,a0
    80005520:	c921                	beqz	a0,80005570 <create+0x94>
    iunlockput(dp);
    80005522:	854a                	mv	a0,s2
    80005524:	fffff097          	auipc	ra,0xfffff
    80005528:	8ac080e7          	jalr	-1876(ra) # 80003dd0 <iunlockput>
    ilock(ip);
    8000552c:	8526                	mv	a0,s1
    8000552e:	ffffe097          	auipc	ra,0xffffe
    80005532:	640080e7          	jalr	1600(ra) # 80003b6e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005536:	2981                	sext.w	s3,s3
    80005538:	4789                	li	a5,2
    8000553a:	02f99463          	bne	s3,a5,80005562 <create+0x86>
    8000553e:	0444d783          	lhu	a5,68(s1)
    80005542:	37f9                	addiw	a5,a5,-2
    80005544:	17c2                	slli	a5,a5,0x30
    80005546:	93c1                	srli	a5,a5,0x30
    80005548:	4705                	li	a4,1
    8000554a:	00f76c63          	bltu	a4,a5,80005562 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000554e:	8526                	mv	a0,s1
    80005550:	60a6                	ld	ra,72(sp)
    80005552:	6406                	ld	s0,64(sp)
    80005554:	74e2                	ld	s1,56(sp)
    80005556:	7942                	ld	s2,48(sp)
    80005558:	79a2                	ld	s3,40(sp)
    8000555a:	7a02                	ld	s4,32(sp)
    8000555c:	6ae2                	ld	s5,24(sp)
    8000555e:	6161                	addi	sp,sp,80
    80005560:	8082                	ret
    iunlockput(ip);
    80005562:	8526                	mv	a0,s1
    80005564:	fffff097          	auipc	ra,0xfffff
    80005568:	86c080e7          	jalr	-1940(ra) # 80003dd0 <iunlockput>
    return 0;
    8000556c:	4481                	li	s1,0
    8000556e:	b7c5                	j	8000554e <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005570:	85ce                	mv	a1,s3
    80005572:	00092503          	lw	a0,0(s2)
    80005576:	ffffe097          	auipc	ra,0xffffe
    8000557a:	460080e7          	jalr	1120(ra) # 800039d6 <ialloc>
    8000557e:	84aa                	mv	s1,a0
    80005580:	c521                	beqz	a0,800055c8 <create+0xec>
  ilock(ip);
    80005582:	ffffe097          	auipc	ra,0xffffe
    80005586:	5ec080e7          	jalr	1516(ra) # 80003b6e <ilock>
  ip->major = major;
    8000558a:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000558e:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005592:	4a05                	li	s4,1
    80005594:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005598:	8526                	mv	a0,s1
    8000559a:	ffffe097          	auipc	ra,0xffffe
    8000559e:	50a080e7          	jalr	1290(ra) # 80003aa4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800055a2:	2981                	sext.w	s3,s3
    800055a4:	03498a63          	beq	s3,s4,800055d8 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800055a8:	40d0                	lw	a2,4(s1)
    800055aa:	fb040593          	addi	a1,s0,-80
    800055ae:	854a                	mv	a0,s2
    800055b0:	fffff097          	auipc	ra,0xfffff
    800055b4:	cb2080e7          	jalr	-846(ra) # 80004262 <dirlink>
    800055b8:	06054b63          	bltz	a0,8000562e <create+0x152>
  iunlockput(dp);
    800055bc:	854a                	mv	a0,s2
    800055be:	fffff097          	auipc	ra,0xfffff
    800055c2:	812080e7          	jalr	-2030(ra) # 80003dd0 <iunlockput>
  return ip;
    800055c6:	b761                	j	8000554e <create+0x72>
    panic("create: ialloc");
    800055c8:	00003517          	auipc	a0,0x3
    800055cc:	1f050513          	addi	a0,a0,496 # 800087b8 <syscalls+0x2b8>
    800055d0:	ffffb097          	auipc	ra,0xffffb
    800055d4:	f5a080e7          	jalr	-166(ra) # 8000052a <panic>
    dp->nlink++;  // for ".."
    800055d8:	04a95783          	lhu	a5,74(s2)
    800055dc:	2785                	addiw	a5,a5,1
    800055de:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800055e2:	854a                	mv	a0,s2
    800055e4:	ffffe097          	auipc	ra,0xffffe
    800055e8:	4c0080e7          	jalr	1216(ra) # 80003aa4 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800055ec:	40d0                	lw	a2,4(s1)
    800055ee:	00003597          	auipc	a1,0x3
    800055f2:	1da58593          	addi	a1,a1,474 # 800087c8 <syscalls+0x2c8>
    800055f6:	8526                	mv	a0,s1
    800055f8:	fffff097          	auipc	ra,0xfffff
    800055fc:	c6a080e7          	jalr	-918(ra) # 80004262 <dirlink>
    80005600:	00054f63          	bltz	a0,8000561e <create+0x142>
    80005604:	00492603          	lw	a2,4(s2)
    80005608:	00003597          	auipc	a1,0x3
    8000560c:	1c858593          	addi	a1,a1,456 # 800087d0 <syscalls+0x2d0>
    80005610:	8526                	mv	a0,s1
    80005612:	fffff097          	auipc	ra,0xfffff
    80005616:	c50080e7          	jalr	-944(ra) # 80004262 <dirlink>
    8000561a:	f80557e3          	bgez	a0,800055a8 <create+0xcc>
      panic("create dots");
    8000561e:	00003517          	auipc	a0,0x3
    80005622:	1ba50513          	addi	a0,a0,442 # 800087d8 <syscalls+0x2d8>
    80005626:	ffffb097          	auipc	ra,0xffffb
    8000562a:	f04080e7          	jalr	-252(ra) # 8000052a <panic>
    panic("create: dirlink");
    8000562e:	00003517          	auipc	a0,0x3
    80005632:	1ba50513          	addi	a0,a0,442 # 800087e8 <syscalls+0x2e8>
    80005636:	ffffb097          	auipc	ra,0xffffb
    8000563a:	ef4080e7          	jalr	-268(ra) # 8000052a <panic>
    return 0;
    8000563e:	84aa                	mv	s1,a0
    80005640:	b739                	j	8000554e <create+0x72>

0000000080005642 <sys_dup>:
{
    80005642:	7179                	addi	sp,sp,-48
    80005644:	f406                	sd	ra,40(sp)
    80005646:	f022                	sd	s0,32(sp)
    80005648:	ec26                	sd	s1,24(sp)
    8000564a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000564c:	fd840613          	addi	a2,s0,-40
    80005650:	4581                	li	a1,0
    80005652:	4501                	li	a0,0
    80005654:	00000097          	auipc	ra,0x0
    80005658:	dde080e7          	jalr	-546(ra) # 80005432 <argfd>
    return -1;
    8000565c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000565e:	02054363          	bltz	a0,80005684 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005662:	fd843503          	ld	a0,-40(s0)
    80005666:	00000097          	auipc	ra,0x0
    8000566a:	e34080e7          	jalr	-460(ra) # 8000549a <fdalloc>
    8000566e:	84aa                	mv	s1,a0
    return -1;
    80005670:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005672:	00054963          	bltz	a0,80005684 <sys_dup+0x42>
  filedup(f);
    80005676:	fd843503          	ld	a0,-40(s0)
    8000567a:	fffff097          	auipc	ra,0xfffff
    8000567e:	344080e7          	jalr	836(ra) # 800049be <filedup>
  return fd;
    80005682:	87a6                	mv	a5,s1
}
    80005684:	853e                	mv	a0,a5
    80005686:	70a2                	ld	ra,40(sp)
    80005688:	7402                	ld	s0,32(sp)
    8000568a:	64e2                	ld	s1,24(sp)
    8000568c:	6145                	addi	sp,sp,48
    8000568e:	8082                	ret

0000000080005690 <sys_read>:
{
    80005690:	7179                	addi	sp,sp,-48
    80005692:	f406                	sd	ra,40(sp)
    80005694:	f022                	sd	s0,32(sp)
    80005696:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005698:	fe840613          	addi	a2,s0,-24
    8000569c:	4581                	li	a1,0
    8000569e:	4501                	li	a0,0
    800056a0:	00000097          	auipc	ra,0x0
    800056a4:	d92080e7          	jalr	-622(ra) # 80005432 <argfd>
    return -1;
    800056a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800056aa:	04054163          	bltz	a0,800056ec <sys_read+0x5c>
    800056ae:	fe440593          	addi	a1,s0,-28
    800056b2:	4509                	li	a0,2
    800056b4:	ffffe097          	auipc	ra,0xffffe
    800056b8:	87a080e7          	jalr	-1926(ra) # 80002f2e <argint>
    return -1;
    800056bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800056be:	02054763          	bltz	a0,800056ec <sys_read+0x5c>
    800056c2:	fd840593          	addi	a1,s0,-40
    800056c6:	4505                	li	a0,1
    800056c8:	ffffe097          	auipc	ra,0xffffe
    800056cc:	888080e7          	jalr	-1912(ra) # 80002f50 <argaddr>
    return -1;
    800056d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800056d2:	00054d63          	bltz	a0,800056ec <sys_read+0x5c>
  return fileread(f, p, n);
    800056d6:	fe442603          	lw	a2,-28(s0)
    800056da:	fd843583          	ld	a1,-40(s0)
    800056de:	fe843503          	ld	a0,-24(s0)
    800056e2:	fffff097          	auipc	ra,0xfffff
    800056e6:	468080e7          	jalr	1128(ra) # 80004b4a <fileread>
    800056ea:	87aa                	mv	a5,a0
}
    800056ec:	853e                	mv	a0,a5
    800056ee:	70a2                	ld	ra,40(sp)
    800056f0:	7402                	ld	s0,32(sp)
    800056f2:	6145                	addi	sp,sp,48
    800056f4:	8082                	ret

00000000800056f6 <sys_write>:
{
    800056f6:	7179                	addi	sp,sp,-48
    800056f8:	f406                	sd	ra,40(sp)
    800056fa:	f022                	sd	s0,32(sp)
    800056fc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800056fe:	fe840613          	addi	a2,s0,-24
    80005702:	4581                	li	a1,0
    80005704:	4501                	li	a0,0
    80005706:	00000097          	auipc	ra,0x0
    8000570a:	d2c080e7          	jalr	-724(ra) # 80005432 <argfd>
    return -1;
    8000570e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005710:	04054163          	bltz	a0,80005752 <sys_write+0x5c>
    80005714:	fe440593          	addi	a1,s0,-28
    80005718:	4509                	li	a0,2
    8000571a:	ffffe097          	auipc	ra,0xffffe
    8000571e:	814080e7          	jalr	-2028(ra) # 80002f2e <argint>
    return -1;
    80005722:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005724:	02054763          	bltz	a0,80005752 <sys_write+0x5c>
    80005728:	fd840593          	addi	a1,s0,-40
    8000572c:	4505                	li	a0,1
    8000572e:	ffffe097          	auipc	ra,0xffffe
    80005732:	822080e7          	jalr	-2014(ra) # 80002f50 <argaddr>
    return -1;
    80005736:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005738:	00054d63          	bltz	a0,80005752 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000573c:	fe442603          	lw	a2,-28(s0)
    80005740:	fd843583          	ld	a1,-40(s0)
    80005744:	fe843503          	ld	a0,-24(s0)
    80005748:	fffff097          	auipc	ra,0xfffff
    8000574c:	4c4080e7          	jalr	1220(ra) # 80004c0c <filewrite>
    80005750:	87aa                	mv	a5,a0
}
    80005752:	853e                	mv	a0,a5
    80005754:	70a2                	ld	ra,40(sp)
    80005756:	7402                	ld	s0,32(sp)
    80005758:	6145                	addi	sp,sp,48
    8000575a:	8082                	ret

000000008000575c <sys_close>:
{
    8000575c:	1101                	addi	sp,sp,-32
    8000575e:	ec06                	sd	ra,24(sp)
    80005760:	e822                	sd	s0,16(sp)
    80005762:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005764:	fe040613          	addi	a2,s0,-32
    80005768:	fec40593          	addi	a1,s0,-20
    8000576c:	4501                	li	a0,0
    8000576e:	00000097          	auipc	ra,0x0
    80005772:	cc4080e7          	jalr	-828(ra) # 80005432 <argfd>
    return -1;
    80005776:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005778:	02054463          	bltz	a0,800057a0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000577c:	ffffc097          	auipc	ra,0xffffc
    80005780:	202080e7          	jalr	514(ra) # 8000197e <myproc>
    80005784:	fec42783          	lw	a5,-20(s0)
    80005788:	07e9                	addi	a5,a5,26
    8000578a:	078e                	slli	a5,a5,0x3
    8000578c:	97aa                	add	a5,a5,a0
    8000578e:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005792:	fe043503          	ld	a0,-32(s0)
    80005796:	fffff097          	auipc	ra,0xfffff
    8000579a:	27a080e7          	jalr	634(ra) # 80004a10 <fileclose>
  return 0;
    8000579e:	4781                	li	a5,0
}
    800057a0:	853e                	mv	a0,a5
    800057a2:	60e2                	ld	ra,24(sp)
    800057a4:	6442                	ld	s0,16(sp)
    800057a6:	6105                	addi	sp,sp,32
    800057a8:	8082                	ret

00000000800057aa <sys_fstat>:
{
    800057aa:	1101                	addi	sp,sp,-32
    800057ac:	ec06                	sd	ra,24(sp)
    800057ae:	e822                	sd	s0,16(sp)
    800057b0:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800057b2:	fe840613          	addi	a2,s0,-24
    800057b6:	4581                	li	a1,0
    800057b8:	4501                	li	a0,0
    800057ba:	00000097          	auipc	ra,0x0
    800057be:	c78080e7          	jalr	-904(ra) # 80005432 <argfd>
    return -1;
    800057c2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800057c4:	02054563          	bltz	a0,800057ee <sys_fstat+0x44>
    800057c8:	fe040593          	addi	a1,s0,-32
    800057cc:	4505                	li	a0,1
    800057ce:	ffffd097          	auipc	ra,0xffffd
    800057d2:	782080e7          	jalr	1922(ra) # 80002f50 <argaddr>
    return -1;
    800057d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800057d8:	00054b63          	bltz	a0,800057ee <sys_fstat+0x44>
  return filestat(f, st);
    800057dc:	fe043583          	ld	a1,-32(s0)
    800057e0:	fe843503          	ld	a0,-24(s0)
    800057e4:	fffff097          	auipc	ra,0xfffff
    800057e8:	2f4080e7          	jalr	756(ra) # 80004ad8 <filestat>
    800057ec:	87aa                	mv	a5,a0
}
    800057ee:	853e                	mv	a0,a5
    800057f0:	60e2                	ld	ra,24(sp)
    800057f2:	6442                	ld	s0,16(sp)
    800057f4:	6105                	addi	sp,sp,32
    800057f6:	8082                	ret

00000000800057f8 <sys_link>:
{
    800057f8:	7169                	addi	sp,sp,-304
    800057fa:	f606                	sd	ra,296(sp)
    800057fc:	f222                	sd	s0,288(sp)
    800057fe:	ee26                	sd	s1,280(sp)
    80005800:	ea4a                	sd	s2,272(sp)
    80005802:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005804:	08000613          	li	a2,128
    80005808:	ed040593          	addi	a1,s0,-304
    8000580c:	4501                	li	a0,0
    8000580e:	ffffd097          	auipc	ra,0xffffd
    80005812:	764080e7          	jalr	1892(ra) # 80002f72 <argstr>
    return -1;
    80005816:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005818:	10054e63          	bltz	a0,80005934 <sys_link+0x13c>
    8000581c:	08000613          	li	a2,128
    80005820:	f5040593          	addi	a1,s0,-176
    80005824:	4505                	li	a0,1
    80005826:	ffffd097          	auipc	ra,0xffffd
    8000582a:	74c080e7          	jalr	1868(ra) # 80002f72 <argstr>
    return -1;
    8000582e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005830:	10054263          	bltz	a0,80005934 <sys_link+0x13c>
  begin_op();
    80005834:	fffff097          	auipc	ra,0xfffff
    80005838:	d10080e7          	jalr	-752(ra) # 80004544 <begin_op>
  if((ip = namei(old)) == 0){
    8000583c:	ed040513          	addi	a0,s0,-304
    80005840:	fffff097          	auipc	ra,0xfffff
    80005844:	ae4080e7          	jalr	-1308(ra) # 80004324 <namei>
    80005848:	84aa                	mv	s1,a0
    8000584a:	c551                	beqz	a0,800058d6 <sys_link+0xde>
  ilock(ip);
    8000584c:	ffffe097          	auipc	ra,0xffffe
    80005850:	322080e7          	jalr	802(ra) # 80003b6e <ilock>
  if(ip->type == T_DIR){
    80005854:	04449703          	lh	a4,68(s1)
    80005858:	4785                	li	a5,1
    8000585a:	08f70463          	beq	a4,a5,800058e2 <sys_link+0xea>
  ip->nlink++;
    8000585e:	04a4d783          	lhu	a5,74(s1)
    80005862:	2785                	addiw	a5,a5,1
    80005864:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005868:	8526                	mv	a0,s1
    8000586a:	ffffe097          	auipc	ra,0xffffe
    8000586e:	23a080e7          	jalr	570(ra) # 80003aa4 <iupdate>
  iunlock(ip);
    80005872:	8526                	mv	a0,s1
    80005874:	ffffe097          	auipc	ra,0xffffe
    80005878:	3bc080e7          	jalr	956(ra) # 80003c30 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000587c:	fd040593          	addi	a1,s0,-48
    80005880:	f5040513          	addi	a0,s0,-176
    80005884:	fffff097          	auipc	ra,0xfffff
    80005888:	abe080e7          	jalr	-1346(ra) # 80004342 <nameiparent>
    8000588c:	892a                	mv	s2,a0
    8000588e:	c935                	beqz	a0,80005902 <sys_link+0x10a>
  ilock(dp);
    80005890:	ffffe097          	auipc	ra,0xffffe
    80005894:	2de080e7          	jalr	734(ra) # 80003b6e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005898:	00092703          	lw	a4,0(s2)
    8000589c:	409c                	lw	a5,0(s1)
    8000589e:	04f71d63          	bne	a4,a5,800058f8 <sys_link+0x100>
    800058a2:	40d0                	lw	a2,4(s1)
    800058a4:	fd040593          	addi	a1,s0,-48
    800058a8:	854a                	mv	a0,s2
    800058aa:	fffff097          	auipc	ra,0xfffff
    800058ae:	9b8080e7          	jalr	-1608(ra) # 80004262 <dirlink>
    800058b2:	04054363          	bltz	a0,800058f8 <sys_link+0x100>
  iunlockput(dp);
    800058b6:	854a                	mv	a0,s2
    800058b8:	ffffe097          	auipc	ra,0xffffe
    800058bc:	518080e7          	jalr	1304(ra) # 80003dd0 <iunlockput>
  iput(ip);
    800058c0:	8526                	mv	a0,s1
    800058c2:	ffffe097          	auipc	ra,0xffffe
    800058c6:	466080e7          	jalr	1126(ra) # 80003d28 <iput>
  end_op();
    800058ca:	fffff097          	auipc	ra,0xfffff
    800058ce:	cfa080e7          	jalr	-774(ra) # 800045c4 <end_op>
  return 0;
    800058d2:	4781                	li	a5,0
    800058d4:	a085                	j	80005934 <sys_link+0x13c>
    end_op();
    800058d6:	fffff097          	auipc	ra,0xfffff
    800058da:	cee080e7          	jalr	-786(ra) # 800045c4 <end_op>
    return -1;
    800058de:	57fd                	li	a5,-1
    800058e0:	a891                	j	80005934 <sys_link+0x13c>
    iunlockput(ip);
    800058e2:	8526                	mv	a0,s1
    800058e4:	ffffe097          	auipc	ra,0xffffe
    800058e8:	4ec080e7          	jalr	1260(ra) # 80003dd0 <iunlockput>
    end_op();
    800058ec:	fffff097          	auipc	ra,0xfffff
    800058f0:	cd8080e7          	jalr	-808(ra) # 800045c4 <end_op>
    return -1;
    800058f4:	57fd                	li	a5,-1
    800058f6:	a83d                	j	80005934 <sys_link+0x13c>
    iunlockput(dp);
    800058f8:	854a                	mv	a0,s2
    800058fa:	ffffe097          	auipc	ra,0xffffe
    800058fe:	4d6080e7          	jalr	1238(ra) # 80003dd0 <iunlockput>
  ilock(ip);
    80005902:	8526                	mv	a0,s1
    80005904:	ffffe097          	auipc	ra,0xffffe
    80005908:	26a080e7          	jalr	618(ra) # 80003b6e <ilock>
  ip->nlink--;
    8000590c:	04a4d783          	lhu	a5,74(s1)
    80005910:	37fd                	addiw	a5,a5,-1
    80005912:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005916:	8526                	mv	a0,s1
    80005918:	ffffe097          	auipc	ra,0xffffe
    8000591c:	18c080e7          	jalr	396(ra) # 80003aa4 <iupdate>
  iunlockput(ip);
    80005920:	8526                	mv	a0,s1
    80005922:	ffffe097          	auipc	ra,0xffffe
    80005926:	4ae080e7          	jalr	1198(ra) # 80003dd0 <iunlockput>
  end_op();
    8000592a:	fffff097          	auipc	ra,0xfffff
    8000592e:	c9a080e7          	jalr	-870(ra) # 800045c4 <end_op>
  return -1;
    80005932:	57fd                	li	a5,-1
}
    80005934:	853e                	mv	a0,a5
    80005936:	70b2                	ld	ra,296(sp)
    80005938:	7412                	ld	s0,288(sp)
    8000593a:	64f2                	ld	s1,280(sp)
    8000593c:	6952                	ld	s2,272(sp)
    8000593e:	6155                	addi	sp,sp,304
    80005940:	8082                	ret

0000000080005942 <sys_unlink>:
{
    80005942:	7151                	addi	sp,sp,-240
    80005944:	f586                	sd	ra,232(sp)
    80005946:	f1a2                	sd	s0,224(sp)
    80005948:	eda6                	sd	s1,216(sp)
    8000594a:	e9ca                	sd	s2,208(sp)
    8000594c:	e5ce                	sd	s3,200(sp)
    8000594e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005950:	08000613          	li	a2,128
    80005954:	f3040593          	addi	a1,s0,-208
    80005958:	4501                	li	a0,0
    8000595a:	ffffd097          	auipc	ra,0xffffd
    8000595e:	618080e7          	jalr	1560(ra) # 80002f72 <argstr>
    80005962:	18054163          	bltz	a0,80005ae4 <sys_unlink+0x1a2>
  begin_op();
    80005966:	fffff097          	auipc	ra,0xfffff
    8000596a:	bde080e7          	jalr	-1058(ra) # 80004544 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000596e:	fb040593          	addi	a1,s0,-80
    80005972:	f3040513          	addi	a0,s0,-208
    80005976:	fffff097          	auipc	ra,0xfffff
    8000597a:	9cc080e7          	jalr	-1588(ra) # 80004342 <nameiparent>
    8000597e:	84aa                	mv	s1,a0
    80005980:	c979                	beqz	a0,80005a56 <sys_unlink+0x114>
  ilock(dp);
    80005982:	ffffe097          	auipc	ra,0xffffe
    80005986:	1ec080e7          	jalr	492(ra) # 80003b6e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000598a:	00003597          	auipc	a1,0x3
    8000598e:	e3e58593          	addi	a1,a1,-450 # 800087c8 <syscalls+0x2c8>
    80005992:	fb040513          	addi	a0,s0,-80
    80005996:	ffffe097          	auipc	ra,0xffffe
    8000599a:	6a2080e7          	jalr	1698(ra) # 80004038 <namecmp>
    8000599e:	14050a63          	beqz	a0,80005af2 <sys_unlink+0x1b0>
    800059a2:	00003597          	auipc	a1,0x3
    800059a6:	e2e58593          	addi	a1,a1,-466 # 800087d0 <syscalls+0x2d0>
    800059aa:	fb040513          	addi	a0,s0,-80
    800059ae:	ffffe097          	auipc	ra,0xffffe
    800059b2:	68a080e7          	jalr	1674(ra) # 80004038 <namecmp>
    800059b6:	12050e63          	beqz	a0,80005af2 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800059ba:	f2c40613          	addi	a2,s0,-212
    800059be:	fb040593          	addi	a1,s0,-80
    800059c2:	8526                	mv	a0,s1
    800059c4:	ffffe097          	auipc	ra,0xffffe
    800059c8:	68e080e7          	jalr	1678(ra) # 80004052 <dirlookup>
    800059cc:	892a                	mv	s2,a0
    800059ce:	12050263          	beqz	a0,80005af2 <sys_unlink+0x1b0>
  ilock(ip);
    800059d2:	ffffe097          	auipc	ra,0xffffe
    800059d6:	19c080e7          	jalr	412(ra) # 80003b6e <ilock>
  if(ip->nlink < 1)
    800059da:	04a91783          	lh	a5,74(s2)
    800059de:	08f05263          	blez	a5,80005a62 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800059e2:	04491703          	lh	a4,68(s2)
    800059e6:	4785                	li	a5,1
    800059e8:	08f70563          	beq	a4,a5,80005a72 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800059ec:	4641                	li	a2,16
    800059ee:	4581                	li	a1,0
    800059f0:	fc040513          	addi	a0,s0,-64
    800059f4:	ffffb097          	auipc	ra,0xffffb
    800059f8:	2ca080e7          	jalr	714(ra) # 80000cbe <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800059fc:	4741                	li	a4,16
    800059fe:	f2c42683          	lw	a3,-212(s0)
    80005a02:	fc040613          	addi	a2,s0,-64
    80005a06:	4581                	li	a1,0
    80005a08:	8526                	mv	a0,s1
    80005a0a:	ffffe097          	auipc	ra,0xffffe
    80005a0e:	510080e7          	jalr	1296(ra) # 80003f1a <writei>
    80005a12:	47c1                	li	a5,16
    80005a14:	0af51563          	bne	a0,a5,80005abe <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005a18:	04491703          	lh	a4,68(s2)
    80005a1c:	4785                	li	a5,1
    80005a1e:	0af70863          	beq	a4,a5,80005ace <sys_unlink+0x18c>
  iunlockput(dp);
    80005a22:	8526                	mv	a0,s1
    80005a24:	ffffe097          	auipc	ra,0xffffe
    80005a28:	3ac080e7          	jalr	940(ra) # 80003dd0 <iunlockput>
  ip->nlink--;
    80005a2c:	04a95783          	lhu	a5,74(s2)
    80005a30:	37fd                	addiw	a5,a5,-1
    80005a32:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005a36:	854a                	mv	a0,s2
    80005a38:	ffffe097          	auipc	ra,0xffffe
    80005a3c:	06c080e7          	jalr	108(ra) # 80003aa4 <iupdate>
  iunlockput(ip);
    80005a40:	854a                	mv	a0,s2
    80005a42:	ffffe097          	auipc	ra,0xffffe
    80005a46:	38e080e7          	jalr	910(ra) # 80003dd0 <iunlockput>
  end_op();
    80005a4a:	fffff097          	auipc	ra,0xfffff
    80005a4e:	b7a080e7          	jalr	-1158(ra) # 800045c4 <end_op>
  return 0;
    80005a52:	4501                	li	a0,0
    80005a54:	a84d                	j	80005b06 <sys_unlink+0x1c4>
    end_op();
    80005a56:	fffff097          	auipc	ra,0xfffff
    80005a5a:	b6e080e7          	jalr	-1170(ra) # 800045c4 <end_op>
    return -1;
    80005a5e:	557d                	li	a0,-1
    80005a60:	a05d                	j	80005b06 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005a62:	00003517          	auipc	a0,0x3
    80005a66:	d9650513          	addi	a0,a0,-618 # 800087f8 <syscalls+0x2f8>
    80005a6a:	ffffb097          	auipc	ra,0xffffb
    80005a6e:	ac0080e7          	jalr	-1344(ra) # 8000052a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005a72:	04c92703          	lw	a4,76(s2)
    80005a76:	02000793          	li	a5,32
    80005a7a:	f6e7f9e3          	bgeu	a5,a4,800059ec <sys_unlink+0xaa>
    80005a7e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a82:	4741                	li	a4,16
    80005a84:	86ce                	mv	a3,s3
    80005a86:	f1840613          	addi	a2,s0,-232
    80005a8a:	4581                	li	a1,0
    80005a8c:	854a                	mv	a0,s2
    80005a8e:	ffffe097          	auipc	ra,0xffffe
    80005a92:	394080e7          	jalr	916(ra) # 80003e22 <readi>
    80005a96:	47c1                	li	a5,16
    80005a98:	00f51b63          	bne	a0,a5,80005aae <sys_unlink+0x16c>
    if(de.inum != 0)
    80005a9c:	f1845783          	lhu	a5,-232(s0)
    80005aa0:	e7a1                	bnez	a5,80005ae8 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005aa2:	29c1                	addiw	s3,s3,16
    80005aa4:	04c92783          	lw	a5,76(s2)
    80005aa8:	fcf9ede3          	bltu	s3,a5,80005a82 <sys_unlink+0x140>
    80005aac:	b781                	j	800059ec <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005aae:	00003517          	auipc	a0,0x3
    80005ab2:	d6250513          	addi	a0,a0,-670 # 80008810 <syscalls+0x310>
    80005ab6:	ffffb097          	auipc	ra,0xffffb
    80005aba:	a74080e7          	jalr	-1420(ra) # 8000052a <panic>
    panic("unlink: writei");
    80005abe:	00003517          	auipc	a0,0x3
    80005ac2:	d6a50513          	addi	a0,a0,-662 # 80008828 <syscalls+0x328>
    80005ac6:	ffffb097          	auipc	ra,0xffffb
    80005aca:	a64080e7          	jalr	-1436(ra) # 8000052a <panic>
    dp->nlink--;
    80005ace:	04a4d783          	lhu	a5,74(s1)
    80005ad2:	37fd                	addiw	a5,a5,-1
    80005ad4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005ad8:	8526                	mv	a0,s1
    80005ada:	ffffe097          	auipc	ra,0xffffe
    80005ade:	fca080e7          	jalr	-54(ra) # 80003aa4 <iupdate>
    80005ae2:	b781                	j	80005a22 <sys_unlink+0xe0>
    return -1;
    80005ae4:	557d                	li	a0,-1
    80005ae6:	a005                	j	80005b06 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005ae8:	854a                	mv	a0,s2
    80005aea:	ffffe097          	auipc	ra,0xffffe
    80005aee:	2e6080e7          	jalr	742(ra) # 80003dd0 <iunlockput>
  iunlockput(dp);
    80005af2:	8526                	mv	a0,s1
    80005af4:	ffffe097          	auipc	ra,0xffffe
    80005af8:	2dc080e7          	jalr	732(ra) # 80003dd0 <iunlockput>
  end_op();
    80005afc:	fffff097          	auipc	ra,0xfffff
    80005b00:	ac8080e7          	jalr	-1336(ra) # 800045c4 <end_op>
  return -1;
    80005b04:	557d                	li	a0,-1
}
    80005b06:	70ae                	ld	ra,232(sp)
    80005b08:	740e                	ld	s0,224(sp)
    80005b0a:	64ee                	ld	s1,216(sp)
    80005b0c:	694e                	ld	s2,208(sp)
    80005b0e:	69ae                	ld	s3,200(sp)
    80005b10:	616d                	addi	sp,sp,240
    80005b12:	8082                	ret

0000000080005b14 <sys_open>:

uint64
sys_open(void)
{
    80005b14:	7131                	addi	sp,sp,-192
    80005b16:	fd06                	sd	ra,184(sp)
    80005b18:	f922                	sd	s0,176(sp)
    80005b1a:	f526                	sd	s1,168(sp)
    80005b1c:	f14a                	sd	s2,160(sp)
    80005b1e:	ed4e                	sd	s3,152(sp)
    80005b20:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005b22:	08000613          	li	a2,128
    80005b26:	f5040593          	addi	a1,s0,-176
    80005b2a:	4501                	li	a0,0
    80005b2c:	ffffd097          	auipc	ra,0xffffd
    80005b30:	446080e7          	jalr	1094(ra) # 80002f72 <argstr>
    return -1;
    80005b34:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005b36:	0c054163          	bltz	a0,80005bf8 <sys_open+0xe4>
    80005b3a:	f4c40593          	addi	a1,s0,-180
    80005b3e:	4505                	li	a0,1
    80005b40:	ffffd097          	auipc	ra,0xffffd
    80005b44:	3ee080e7          	jalr	1006(ra) # 80002f2e <argint>
    80005b48:	0a054863          	bltz	a0,80005bf8 <sys_open+0xe4>

  begin_op();
    80005b4c:	fffff097          	auipc	ra,0xfffff
    80005b50:	9f8080e7          	jalr	-1544(ra) # 80004544 <begin_op>

  if(omode & O_CREATE){
    80005b54:	f4c42783          	lw	a5,-180(s0)
    80005b58:	2007f793          	andi	a5,a5,512
    80005b5c:	cbdd                	beqz	a5,80005c12 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005b5e:	4681                	li	a3,0
    80005b60:	4601                	li	a2,0
    80005b62:	4589                	li	a1,2
    80005b64:	f5040513          	addi	a0,s0,-176
    80005b68:	00000097          	auipc	ra,0x0
    80005b6c:	974080e7          	jalr	-1676(ra) # 800054dc <create>
    80005b70:	892a                	mv	s2,a0
    if(ip == 0){
    80005b72:	c959                	beqz	a0,80005c08 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005b74:	04491703          	lh	a4,68(s2)
    80005b78:	478d                	li	a5,3
    80005b7a:	00f71763          	bne	a4,a5,80005b88 <sys_open+0x74>
    80005b7e:	04695703          	lhu	a4,70(s2)
    80005b82:	47a5                	li	a5,9
    80005b84:	0ce7ec63          	bltu	a5,a4,80005c5c <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005b88:	fffff097          	auipc	ra,0xfffff
    80005b8c:	dcc080e7          	jalr	-564(ra) # 80004954 <filealloc>
    80005b90:	89aa                	mv	s3,a0
    80005b92:	10050263          	beqz	a0,80005c96 <sys_open+0x182>
    80005b96:	00000097          	auipc	ra,0x0
    80005b9a:	904080e7          	jalr	-1788(ra) # 8000549a <fdalloc>
    80005b9e:	84aa                	mv	s1,a0
    80005ba0:	0e054663          	bltz	a0,80005c8c <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005ba4:	04491703          	lh	a4,68(s2)
    80005ba8:	478d                	li	a5,3
    80005baa:	0cf70463          	beq	a4,a5,80005c72 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005bae:	4789                	li	a5,2
    80005bb0:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005bb4:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005bb8:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005bbc:	f4c42783          	lw	a5,-180(s0)
    80005bc0:	0017c713          	xori	a4,a5,1
    80005bc4:	8b05                	andi	a4,a4,1
    80005bc6:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005bca:	0037f713          	andi	a4,a5,3
    80005bce:	00e03733          	snez	a4,a4
    80005bd2:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005bd6:	4007f793          	andi	a5,a5,1024
    80005bda:	c791                	beqz	a5,80005be6 <sys_open+0xd2>
    80005bdc:	04491703          	lh	a4,68(s2)
    80005be0:	4789                	li	a5,2
    80005be2:	08f70f63          	beq	a4,a5,80005c80 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005be6:	854a                	mv	a0,s2
    80005be8:	ffffe097          	auipc	ra,0xffffe
    80005bec:	048080e7          	jalr	72(ra) # 80003c30 <iunlock>
  end_op();
    80005bf0:	fffff097          	auipc	ra,0xfffff
    80005bf4:	9d4080e7          	jalr	-1580(ra) # 800045c4 <end_op>

  return fd;
}
    80005bf8:	8526                	mv	a0,s1
    80005bfa:	70ea                	ld	ra,184(sp)
    80005bfc:	744a                	ld	s0,176(sp)
    80005bfe:	74aa                	ld	s1,168(sp)
    80005c00:	790a                	ld	s2,160(sp)
    80005c02:	69ea                	ld	s3,152(sp)
    80005c04:	6129                	addi	sp,sp,192
    80005c06:	8082                	ret
      end_op();
    80005c08:	fffff097          	auipc	ra,0xfffff
    80005c0c:	9bc080e7          	jalr	-1604(ra) # 800045c4 <end_op>
      return -1;
    80005c10:	b7e5                	j	80005bf8 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005c12:	f5040513          	addi	a0,s0,-176
    80005c16:	ffffe097          	auipc	ra,0xffffe
    80005c1a:	70e080e7          	jalr	1806(ra) # 80004324 <namei>
    80005c1e:	892a                	mv	s2,a0
    80005c20:	c905                	beqz	a0,80005c50 <sys_open+0x13c>
    ilock(ip);
    80005c22:	ffffe097          	auipc	ra,0xffffe
    80005c26:	f4c080e7          	jalr	-180(ra) # 80003b6e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005c2a:	04491703          	lh	a4,68(s2)
    80005c2e:	4785                	li	a5,1
    80005c30:	f4f712e3          	bne	a4,a5,80005b74 <sys_open+0x60>
    80005c34:	f4c42783          	lw	a5,-180(s0)
    80005c38:	dba1                	beqz	a5,80005b88 <sys_open+0x74>
      iunlockput(ip);
    80005c3a:	854a                	mv	a0,s2
    80005c3c:	ffffe097          	auipc	ra,0xffffe
    80005c40:	194080e7          	jalr	404(ra) # 80003dd0 <iunlockput>
      end_op();
    80005c44:	fffff097          	auipc	ra,0xfffff
    80005c48:	980080e7          	jalr	-1664(ra) # 800045c4 <end_op>
      return -1;
    80005c4c:	54fd                	li	s1,-1
    80005c4e:	b76d                	j	80005bf8 <sys_open+0xe4>
      end_op();
    80005c50:	fffff097          	auipc	ra,0xfffff
    80005c54:	974080e7          	jalr	-1676(ra) # 800045c4 <end_op>
      return -1;
    80005c58:	54fd                	li	s1,-1
    80005c5a:	bf79                	j	80005bf8 <sys_open+0xe4>
    iunlockput(ip);
    80005c5c:	854a                	mv	a0,s2
    80005c5e:	ffffe097          	auipc	ra,0xffffe
    80005c62:	172080e7          	jalr	370(ra) # 80003dd0 <iunlockput>
    end_op();
    80005c66:	fffff097          	auipc	ra,0xfffff
    80005c6a:	95e080e7          	jalr	-1698(ra) # 800045c4 <end_op>
    return -1;
    80005c6e:	54fd                	li	s1,-1
    80005c70:	b761                	j	80005bf8 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005c72:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005c76:	04691783          	lh	a5,70(s2)
    80005c7a:	02f99223          	sh	a5,36(s3)
    80005c7e:	bf2d                	j	80005bb8 <sys_open+0xa4>
    itrunc(ip);
    80005c80:	854a                	mv	a0,s2
    80005c82:	ffffe097          	auipc	ra,0xffffe
    80005c86:	ffa080e7          	jalr	-6(ra) # 80003c7c <itrunc>
    80005c8a:	bfb1                	j	80005be6 <sys_open+0xd2>
      fileclose(f);
    80005c8c:	854e                	mv	a0,s3
    80005c8e:	fffff097          	auipc	ra,0xfffff
    80005c92:	d82080e7          	jalr	-638(ra) # 80004a10 <fileclose>
    iunlockput(ip);
    80005c96:	854a                	mv	a0,s2
    80005c98:	ffffe097          	auipc	ra,0xffffe
    80005c9c:	138080e7          	jalr	312(ra) # 80003dd0 <iunlockput>
    end_op();
    80005ca0:	fffff097          	auipc	ra,0xfffff
    80005ca4:	924080e7          	jalr	-1756(ra) # 800045c4 <end_op>
    return -1;
    80005ca8:	54fd                	li	s1,-1
    80005caa:	b7b9                	j	80005bf8 <sys_open+0xe4>

0000000080005cac <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005cac:	7175                	addi	sp,sp,-144
    80005cae:	e506                	sd	ra,136(sp)
    80005cb0:	e122                	sd	s0,128(sp)
    80005cb2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005cb4:	fffff097          	auipc	ra,0xfffff
    80005cb8:	890080e7          	jalr	-1904(ra) # 80004544 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005cbc:	08000613          	li	a2,128
    80005cc0:	f7040593          	addi	a1,s0,-144
    80005cc4:	4501                	li	a0,0
    80005cc6:	ffffd097          	auipc	ra,0xffffd
    80005cca:	2ac080e7          	jalr	684(ra) # 80002f72 <argstr>
    80005cce:	02054963          	bltz	a0,80005d00 <sys_mkdir+0x54>
    80005cd2:	4681                	li	a3,0
    80005cd4:	4601                	li	a2,0
    80005cd6:	4585                	li	a1,1
    80005cd8:	f7040513          	addi	a0,s0,-144
    80005cdc:	00000097          	auipc	ra,0x0
    80005ce0:	800080e7          	jalr	-2048(ra) # 800054dc <create>
    80005ce4:	cd11                	beqz	a0,80005d00 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005ce6:	ffffe097          	auipc	ra,0xffffe
    80005cea:	0ea080e7          	jalr	234(ra) # 80003dd0 <iunlockput>
  end_op();
    80005cee:	fffff097          	auipc	ra,0xfffff
    80005cf2:	8d6080e7          	jalr	-1834(ra) # 800045c4 <end_op>
  return 0;
    80005cf6:	4501                	li	a0,0
}
    80005cf8:	60aa                	ld	ra,136(sp)
    80005cfa:	640a                	ld	s0,128(sp)
    80005cfc:	6149                	addi	sp,sp,144
    80005cfe:	8082                	ret
    end_op();
    80005d00:	fffff097          	auipc	ra,0xfffff
    80005d04:	8c4080e7          	jalr	-1852(ra) # 800045c4 <end_op>
    return -1;
    80005d08:	557d                	li	a0,-1
    80005d0a:	b7fd                	j	80005cf8 <sys_mkdir+0x4c>

0000000080005d0c <sys_mknod>:

uint64
sys_mknod(void)
{
    80005d0c:	7135                	addi	sp,sp,-160
    80005d0e:	ed06                	sd	ra,152(sp)
    80005d10:	e922                	sd	s0,144(sp)
    80005d12:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005d14:	fffff097          	auipc	ra,0xfffff
    80005d18:	830080e7          	jalr	-2000(ra) # 80004544 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005d1c:	08000613          	li	a2,128
    80005d20:	f7040593          	addi	a1,s0,-144
    80005d24:	4501                	li	a0,0
    80005d26:	ffffd097          	auipc	ra,0xffffd
    80005d2a:	24c080e7          	jalr	588(ra) # 80002f72 <argstr>
    80005d2e:	04054a63          	bltz	a0,80005d82 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005d32:	f6c40593          	addi	a1,s0,-148
    80005d36:	4505                	li	a0,1
    80005d38:	ffffd097          	auipc	ra,0xffffd
    80005d3c:	1f6080e7          	jalr	502(ra) # 80002f2e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005d40:	04054163          	bltz	a0,80005d82 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005d44:	f6840593          	addi	a1,s0,-152
    80005d48:	4509                	li	a0,2
    80005d4a:	ffffd097          	auipc	ra,0xffffd
    80005d4e:	1e4080e7          	jalr	484(ra) # 80002f2e <argint>
     argint(1, &major) < 0 ||
    80005d52:	02054863          	bltz	a0,80005d82 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005d56:	f6841683          	lh	a3,-152(s0)
    80005d5a:	f6c41603          	lh	a2,-148(s0)
    80005d5e:	458d                	li	a1,3
    80005d60:	f7040513          	addi	a0,s0,-144
    80005d64:	fffff097          	auipc	ra,0xfffff
    80005d68:	778080e7          	jalr	1912(ra) # 800054dc <create>
     argint(2, &minor) < 0 ||
    80005d6c:	c919                	beqz	a0,80005d82 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005d6e:	ffffe097          	auipc	ra,0xffffe
    80005d72:	062080e7          	jalr	98(ra) # 80003dd0 <iunlockput>
  end_op();
    80005d76:	fffff097          	auipc	ra,0xfffff
    80005d7a:	84e080e7          	jalr	-1970(ra) # 800045c4 <end_op>
  return 0;
    80005d7e:	4501                	li	a0,0
    80005d80:	a031                	j	80005d8c <sys_mknod+0x80>
    end_op();
    80005d82:	fffff097          	auipc	ra,0xfffff
    80005d86:	842080e7          	jalr	-1982(ra) # 800045c4 <end_op>
    return -1;
    80005d8a:	557d                	li	a0,-1
}
    80005d8c:	60ea                	ld	ra,152(sp)
    80005d8e:	644a                	ld	s0,144(sp)
    80005d90:	610d                	addi	sp,sp,160
    80005d92:	8082                	ret

0000000080005d94 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005d94:	7135                	addi	sp,sp,-160
    80005d96:	ed06                	sd	ra,152(sp)
    80005d98:	e922                	sd	s0,144(sp)
    80005d9a:	e526                	sd	s1,136(sp)
    80005d9c:	e14a                	sd	s2,128(sp)
    80005d9e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005da0:	ffffc097          	auipc	ra,0xffffc
    80005da4:	bde080e7          	jalr	-1058(ra) # 8000197e <myproc>
    80005da8:	892a                	mv	s2,a0
  
  begin_op();
    80005daa:	ffffe097          	auipc	ra,0xffffe
    80005dae:	79a080e7          	jalr	1946(ra) # 80004544 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005db2:	08000613          	li	a2,128
    80005db6:	f6040593          	addi	a1,s0,-160
    80005dba:	4501                	li	a0,0
    80005dbc:	ffffd097          	auipc	ra,0xffffd
    80005dc0:	1b6080e7          	jalr	438(ra) # 80002f72 <argstr>
    80005dc4:	04054b63          	bltz	a0,80005e1a <sys_chdir+0x86>
    80005dc8:	f6040513          	addi	a0,s0,-160
    80005dcc:	ffffe097          	auipc	ra,0xffffe
    80005dd0:	558080e7          	jalr	1368(ra) # 80004324 <namei>
    80005dd4:	84aa                	mv	s1,a0
    80005dd6:	c131                	beqz	a0,80005e1a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005dd8:	ffffe097          	auipc	ra,0xffffe
    80005ddc:	d96080e7          	jalr	-618(ra) # 80003b6e <ilock>
  if(ip->type != T_DIR){
    80005de0:	04449703          	lh	a4,68(s1)
    80005de4:	4785                	li	a5,1
    80005de6:	04f71063          	bne	a4,a5,80005e26 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005dea:	8526                	mv	a0,s1
    80005dec:	ffffe097          	auipc	ra,0xffffe
    80005df0:	e44080e7          	jalr	-444(ra) # 80003c30 <iunlock>
  iput(p->cwd);
    80005df4:	15093503          	ld	a0,336(s2)
    80005df8:	ffffe097          	auipc	ra,0xffffe
    80005dfc:	f30080e7          	jalr	-208(ra) # 80003d28 <iput>
  end_op();
    80005e00:	ffffe097          	auipc	ra,0xffffe
    80005e04:	7c4080e7          	jalr	1988(ra) # 800045c4 <end_op>
  p->cwd = ip;
    80005e08:	14993823          	sd	s1,336(s2)
  return 0;
    80005e0c:	4501                	li	a0,0
}
    80005e0e:	60ea                	ld	ra,152(sp)
    80005e10:	644a                	ld	s0,144(sp)
    80005e12:	64aa                	ld	s1,136(sp)
    80005e14:	690a                	ld	s2,128(sp)
    80005e16:	610d                	addi	sp,sp,160
    80005e18:	8082                	ret
    end_op();
    80005e1a:	ffffe097          	auipc	ra,0xffffe
    80005e1e:	7aa080e7          	jalr	1962(ra) # 800045c4 <end_op>
    return -1;
    80005e22:	557d                	li	a0,-1
    80005e24:	b7ed                	j	80005e0e <sys_chdir+0x7a>
    iunlockput(ip);
    80005e26:	8526                	mv	a0,s1
    80005e28:	ffffe097          	auipc	ra,0xffffe
    80005e2c:	fa8080e7          	jalr	-88(ra) # 80003dd0 <iunlockput>
    end_op();
    80005e30:	ffffe097          	auipc	ra,0xffffe
    80005e34:	794080e7          	jalr	1940(ra) # 800045c4 <end_op>
    return -1;
    80005e38:	557d                	li	a0,-1
    80005e3a:	bfd1                	j	80005e0e <sys_chdir+0x7a>

0000000080005e3c <sys_exec>:

uint64
sys_exec(void)
{
    80005e3c:	7145                	addi	sp,sp,-464
    80005e3e:	e786                	sd	ra,456(sp)
    80005e40:	e3a2                	sd	s0,448(sp)
    80005e42:	ff26                	sd	s1,440(sp)
    80005e44:	fb4a                	sd	s2,432(sp)
    80005e46:	f74e                	sd	s3,424(sp)
    80005e48:	f352                	sd	s4,416(sp)
    80005e4a:	ef56                	sd	s5,408(sp)
    80005e4c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005e4e:	08000613          	li	a2,128
    80005e52:	f4040593          	addi	a1,s0,-192
    80005e56:	4501                	li	a0,0
    80005e58:	ffffd097          	auipc	ra,0xffffd
    80005e5c:	11a080e7          	jalr	282(ra) # 80002f72 <argstr>
    return -1;
    80005e60:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005e62:	0c054a63          	bltz	a0,80005f36 <sys_exec+0xfa>
    80005e66:	e3840593          	addi	a1,s0,-456
    80005e6a:	4505                	li	a0,1
    80005e6c:	ffffd097          	auipc	ra,0xffffd
    80005e70:	0e4080e7          	jalr	228(ra) # 80002f50 <argaddr>
    80005e74:	0c054163          	bltz	a0,80005f36 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005e78:	10000613          	li	a2,256
    80005e7c:	4581                	li	a1,0
    80005e7e:	e4040513          	addi	a0,s0,-448
    80005e82:	ffffb097          	auipc	ra,0xffffb
    80005e86:	e3c080e7          	jalr	-452(ra) # 80000cbe <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005e8a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005e8e:	89a6                	mv	s3,s1
    80005e90:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005e92:	02000a13          	li	s4,32
    80005e96:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005e9a:	00391793          	slli	a5,s2,0x3
    80005e9e:	e3040593          	addi	a1,s0,-464
    80005ea2:	e3843503          	ld	a0,-456(s0)
    80005ea6:	953e                	add	a0,a0,a5
    80005ea8:	ffffd097          	auipc	ra,0xffffd
    80005eac:	fec080e7          	jalr	-20(ra) # 80002e94 <fetchaddr>
    80005eb0:	02054a63          	bltz	a0,80005ee4 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005eb4:	e3043783          	ld	a5,-464(s0)
    80005eb8:	c3b9                	beqz	a5,80005efe <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005eba:	ffffb097          	auipc	ra,0xffffb
    80005ebe:	c18080e7          	jalr	-1000(ra) # 80000ad2 <kalloc>
    80005ec2:	85aa                	mv	a1,a0
    80005ec4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005ec8:	cd11                	beqz	a0,80005ee4 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005eca:	6605                	lui	a2,0x1
    80005ecc:	e3043503          	ld	a0,-464(s0)
    80005ed0:	ffffd097          	auipc	ra,0xffffd
    80005ed4:	016080e7          	jalr	22(ra) # 80002ee6 <fetchstr>
    80005ed8:	00054663          	bltz	a0,80005ee4 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005edc:	0905                	addi	s2,s2,1
    80005ede:	09a1                	addi	s3,s3,8
    80005ee0:	fb491be3          	bne	s2,s4,80005e96 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ee4:	10048913          	addi	s2,s1,256
    80005ee8:	6088                	ld	a0,0(s1)
    80005eea:	c529                	beqz	a0,80005f34 <sys_exec+0xf8>
    kfree(argv[i]);
    80005eec:	ffffb097          	auipc	ra,0xffffb
    80005ef0:	aea080e7          	jalr	-1302(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ef4:	04a1                	addi	s1,s1,8
    80005ef6:	ff2499e3          	bne	s1,s2,80005ee8 <sys_exec+0xac>
  return -1;
    80005efa:	597d                	li	s2,-1
    80005efc:	a82d                	j	80005f36 <sys_exec+0xfa>
      argv[i] = 0;
    80005efe:	0a8e                	slli	s5,s5,0x3
    80005f00:	fc040793          	addi	a5,s0,-64
    80005f04:	9abe                	add	s5,s5,a5
    80005f06:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd2e80>
  int ret = exec(path, argv);
    80005f0a:	e4040593          	addi	a1,s0,-448
    80005f0e:	f4040513          	addi	a0,s0,-192
    80005f12:	fffff097          	auipc	ra,0xfffff
    80005f16:	150080e7          	jalr	336(ra) # 80005062 <exec>
    80005f1a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f1c:	10048993          	addi	s3,s1,256
    80005f20:	6088                	ld	a0,0(s1)
    80005f22:	c911                	beqz	a0,80005f36 <sys_exec+0xfa>
    kfree(argv[i]);
    80005f24:	ffffb097          	auipc	ra,0xffffb
    80005f28:	ab2080e7          	jalr	-1358(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f2c:	04a1                	addi	s1,s1,8
    80005f2e:	ff3499e3          	bne	s1,s3,80005f20 <sys_exec+0xe4>
    80005f32:	a011                	j	80005f36 <sys_exec+0xfa>
  return -1;
    80005f34:	597d                	li	s2,-1
}
    80005f36:	854a                	mv	a0,s2
    80005f38:	60be                	ld	ra,456(sp)
    80005f3a:	641e                	ld	s0,448(sp)
    80005f3c:	74fa                	ld	s1,440(sp)
    80005f3e:	795a                	ld	s2,432(sp)
    80005f40:	79ba                	ld	s3,424(sp)
    80005f42:	7a1a                	ld	s4,416(sp)
    80005f44:	6afa                	ld	s5,408(sp)
    80005f46:	6179                	addi	sp,sp,464
    80005f48:	8082                	ret

0000000080005f4a <sys_pipe>:

uint64
sys_pipe(void)
{
    80005f4a:	7139                	addi	sp,sp,-64
    80005f4c:	fc06                	sd	ra,56(sp)
    80005f4e:	f822                	sd	s0,48(sp)
    80005f50:	f426                	sd	s1,40(sp)
    80005f52:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005f54:	ffffc097          	auipc	ra,0xffffc
    80005f58:	a2a080e7          	jalr	-1494(ra) # 8000197e <myproc>
    80005f5c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005f5e:	fd840593          	addi	a1,s0,-40
    80005f62:	4501                	li	a0,0
    80005f64:	ffffd097          	auipc	ra,0xffffd
    80005f68:	fec080e7          	jalr	-20(ra) # 80002f50 <argaddr>
    return -1;
    80005f6c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005f6e:	0e054063          	bltz	a0,8000604e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005f72:	fc840593          	addi	a1,s0,-56
    80005f76:	fd040513          	addi	a0,s0,-48
    80005f7a:	fffff097          	auipc	ra,0xfffff
    80005f7e:	dc6080e7          	jalr	-570(ra) # 80004d40 <pipealloc>
    return -1;
    80005f82:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005f84:	0c054563          	bltz	a0,8000604e <sys_pipe+0x104>
  fd0 = -1;
    80005f88:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005f8c:	fd043503          	ld	a0,-48(s0)
    80005f90:	fffff097          	auipc	ra,0xfffff
    80005f94:	50a080e7          	jalr	1290(ra) # 8000549a <fdalloc>
    80005f98:	fca42223          	sw	a0,-60(s0)
    80005f9c:	08054c63          	bltz	a0,80006034 <sys_pipe+0xea>
    80005fa0:	fc843503          	ld	a0,-56(s0)
    80005fa4:	fffff097          	auipc	ra,0xfffff
    80005fa8:	4f6080e7          	jalr	1270(ra) # 8000549a <fdalloc>
    80005fac:	fca42023          	sw	a0,-64(s0)
    80005fb0:	06054863          	bltz	a0,80006020 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005fb4:	4691                	li	a3,4
    80005fb6:	fc440613          	addi	a2,s0,-60
    80005fba:	fd843583          	ld	a1,-40(s0)
    80005fbe:	68a8                	ld	a0,80(s1)
    80005fc0:	ffffb097          	auipc	ra,0xffffb
    80005fc4:	67e080e7          	jalr	1662(ra) # 8000163e <copyout>
    80005fc8:	02054063          	bltz	a0,80005fe8 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005fcc:	4691                	li	a3,4
    80005fce:	fc040613          	addi	a2,s0,-64
    80005fd2:	fd843583          	ld	a1,-40(s0)
    80005fd6:	0591                	addi	a1,a1,4
    80005fd8:	68a8                	ld	a0,80(s1)
    80005fda:	ffffb097          	auipc	ra,0xffffb
    80005fde:	664080e7          	jalr	1636(ra) # 8000163e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005fe2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005fe4:	06055563          	bgez	a0,8000604e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005fe8:	fc442783          	lw	a5,-60(s0)
    80005fec:	07e9                	addi	a5,a5,26
    80005fee:	078e                	slli	a5,a5,0x3
    80005ff0:	97a6                	add	a5,a5,s1
    80005ff2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005ff6:	fc042503          	lw	a0,-64(s0)
    80005ffa:	0569                	addi	a0,a0,26
    80005ffc:	050e                	slli	a0,a0,0x3
    80005ffe:	9526                	add	a0,a0,s1
    80006000:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80006004:	fd043503          	ld	a0,-48(s0)
    80006008:	fffff097          	auipc	ra,0xfffff
    8000600c:	a08080e7          	jalr	-1528(ra) # 80004a10 <fileclose>
    fileclose(wf);
    80006010:	fc843503          	ld	a0,-56(s0)
    80006014:	fffff097          	auipc	ra,0xfffff
    80006018:	9fc080e7          	jalr	-1540(ra) # 80004a10 <fileclose>
    return -1;
    8000601c:	57fd                	li	a5,-1
    8000601e:	a805                	j	8000604e <sys_pipe+0x104>
    if(fd0 >= 0)
    80006020:	fc442783          	lw	a5,-60(s0)
    80006024:	0007c863          	bltz	a5,80006034 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80006028:	01a78513          	addi	a0,a5,26
    8000602c:	050e                	slli	a0,a0,0x3
    8000602e:	9526                	add	a0,a0,s1
    80006030:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80006034:	fd043503          	ld	a0,-48(s0)
    80006038:	fffff097          	auipc	ra,0xfffff
    8000603c:	9d8080e7          	jalr	-1576(ra) # 80004a10 <fileclose>
    fileclose(wf);
    80006040:	fc843503          	ld	a0,-56(s0)
    80006044:	fffff097          	auipc	ra,0xfffff
    80006048:	9cc080e7          	jalr	-1588(ra) # 80004a10 <fileclose>
    return -1;
    8000604c:	57fd                	li	a5,-1
}
    8000604e:	853e                	mv	a0,a5
    80006050:	70e2                	ld	ra,56(sp)
    80006052:	7442                	ld	s0,48(sp)
    80006054:	74a2                	ld	s1,40(sp)
    80006056:	6121                	addi	sp,sp,64
    80006058:	8082                	ret
    8000605a:	0000                	unimp
    8000605c:	0000                	unimp
	...

0000000080006060 <kernelvec>:
    80006060:	7111                	addi	sp,sp,-256
    80006062:	e006                	sd	ra,0(sp)
    80006064:	e40a                	sd	sp,8(sp)
    80006066:	e80e                	sd	gp,16(sp)
    80006068:	ec12                	sd	tp,24(sp)
    8000606a:	f016                	sd	t0,32(sp)
    8000606c:	f41a                	sd	t1,40(sp)
    8000606e:	f81e                	sd	t2,48(sp)
    80006070:	fc22                	sd	s0,56(sp)
    80006072:	e0a6                	sd	s1,64(sp)
    80006074:	e4aa                	sd	a0,72(sp)
    80006076:	e8ae                	sd	a1,80(sp)
    80006078:	ecb2                	sd	a2,88(sp)
    8000607a:	f0b6                	sd	a3,96(sp)
    8000607c:	f4ba                	sd	a4,104(sp)
    8000607e:	f8be                	sd	a5,112(sp)
    80006080:	fcc2                	sd	a6,120(sp)
    80006082:	e146                	sd	a7,128(sp)
    80006084:	e54a                	sd	s2,136(sp)
    80006086:	e94e                	sd	s3,144(sp)
    80006088:	ed52                	sd	s4,152(sp)
    8000608a:	f156                	sd	s5,160(sp)
    8000608c:	f55a                	sd	s6,168(sp)
    8000608e:	f95e                	sd	s7,176(sp)
    80006090:	fd62                	sd	s8,184(sp)
    80006092:	e1e6                	sd	s9,192(sp)
    80006094:	e5ea                	sd	s10,200(sp)
    80006096:	e9ee                	sd	s11,208(sp)
    80006098:	edf2                	sd	t3,216(sp)
    8000609a:	f1f6                	sd	t4,224(sp)
    8000609c:	f5fa                	sd	t5,232(sp)
    8000609e:	f9fe                	sd	t6,240(sp)
    800060a0:	cc1fc0ef          	jal	ra,80002d60 <kerneltrap>
    800060a4:	6082                	ld	ra,0(sp)
    800060a6:	6122                	ld	sp,8(sp)
    800060a8:	61c2                	ld	gp,16(sp)
    800060aa:	7282                	ld	t0,32(sp)
    800060ac:	7322                	ld	t1,40(sp)
    800060ae:	73c2                	ld	t2,48(sp)
    800060b0:	7462                	ld	s0,56(sp)
    800060b2:	6486                	ld	s1,64(sp)
    800060b4:	6526                	ld	a0,72(sp)
    800060b6:	65c6                	ld	a1,80(sp)
    800060b8:	6666                	ld	a2,88(sp)
    800060ba:	7686                	ld	a3,96(sp)
    800060bc:	7726                	ld	a4,104(sp)
    800060be:	77c6                	ld	a5,112(sp)
    800060c0:	7866                	ld	a6,120(sp)
    800060c2:	688a                	ld	a7,128(sp)
    800060c4:	692a                	ld	s2,136(sp)
    800060c6:	69ca                	ld	s3,144(sp)
    800060c8:	6a6a                	ld	s4,152(sp)
    800060ca:	7a8a                	ld	s5,160(sp)
    800060cc:	7b2a                	ld	s6,168(sp)
    800060ce:	7bca                	ld	s7,176(sp)
    800060d0:	7c6a                	ld	s8,184(sp)
    800060d2:	6c8e                	ld	s9,192(sp)
    800060d4:	6d2e                	ld	s10,200(sp)
    800060d6:	6dce                	ld	s11,208(sp)
    800060d8:	6e6e                	ld	t3,216(sp)
    800060da:	7e8e                	ld	t4,224(sp)
    800060dc:	7f2e                	ld	t5,232(sp)
    800060de:	7fce                	ld	t6,240(sp)
    800060e0:	6111                	addi	sp,sp,256
    800060e2:	10200073          	sret
    800060e6:	00000013          	nop
    800060ea:	00000013          	nop
    800060ee:	0001                	nop

00000000800060f0 <timervec>:
    800060f0:	34051573          	csrrw	a0,mscratch,a0
    800060f4:	e10c                	sd	a1,0(a0)
    800060f6:	e510                	sd	a2,8(a0)
    800060f8:	e914                	sd	a3,16(a0)
    800060fa:	6d0c                	ld	a1,24(a0)
    800060fc:	7110                	ld	a2,32(a0)
    800060fe:	6194                	ld	a3,0(a1)
    80006100:	96b2                	add	a3,a3,a2
    80006102:	e194                	sd	a3,0(a1)
    80006104:	4589                	li	a1,2
    80006106:	14459073          	csrw	sip,a1
    8000610a:	6914                	ld	a3,16(a0)
    8000610c:	6510                	ld	a2,8(a0)
    8000610e:	610c                	ld	a1,0(a0)
    80006110:	34051573          	csrrw	a0,mscratch,a0
    80006114:	30200073          	mret
	...

000000008000611a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000611a:	1141                	addi	sp,sp,-16
    8000611c:	e422                	sd	s0,8(sp)
    8000611e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006120:	0c0007b7          	lui	a5,0xc000
    80006124:	4705                	li	a4,1
    80006126:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006128:	c3d8                	sw	a4,4(a5)
}
    8000612a:	6422                	ld	s0,8(sp)
    8000612c:	0141                	addi	sp,sp,16
    8000612e:	8082                	ret

0000000080006130 <plicinithart>:

void
plicinithart(void)
{
    80006130:	1141                	addi	sp,sp,-16
    80006132:	e406                	sd	ra,8(sp)
    80006134:	e022                	sd	s0,0(sp)
    80006136:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006138:	ffffc097          	auipc	ra,0xffffc
    8000613c:	81a080e7          	jalr	-2022(ra) # 80001952 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006140:	0085171b          	slliw	a4,a0,0x8
    80006144:	0c0027b7          	lui	a5,0xc002
    80006148:	97ba                	add	a5,a5,a4
    8000614a:	40200713          	li	a4,1026
    8000614e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006152:	00d5151b          	slliw	a0,a0,0xd
    80006156:	0c2017b7          	lui	a5,0xc201
    8000615a:	953e                	add	a0,a0,a5
    8000615c:	00052023          	sw	zero,0(a0)
}
    80006160:	60a2                	ld	ra,8(sp)
    80006162:	6402                	ld	s0,0(sp)
    80006164:	0141                	addi	sp,sp,16
    80006166:	8082                	ret

0000000080006168 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006168:	1141                	addi	sp,sp,-16
    8000616a:	e406                	sd	ra,8(sp)
    8000616c:	e022                	sd	s0,0(sp)
    8000616e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006170:	ffffb097          	auipc	ra,0xffffb
    80006174:	7e2080e7          	jalr	2018(ra) # 80001952 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006178:	00d5179b          	slliw	a5,a0,0xd
    8000617c:	0c201537          	lui	a0,0xc201
    80006180:	953e                	add	a0,a0,a5
  return irq;
}
    80006182:	4148                	lw	a0,4(a0)
    80006184:	60a2                	ld	ra,8(sp)
    80006186:	6402                	ld	s0,0(sp)
    80006188:	0141                	addi	sp,sp,16
    8000618a:	8082                	ret

000000008000618c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000618c:	1101                	addi	sp,sp,-32
    8000618e:	ec06                	sd	ra,24(sp)
    80006190:	e822                	sd	s0,16(sp)
    80006192:	e426                	sd	s1,8(sp)
    80006194:	1000                	addi	s0,sp,32
    80006196:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006198:	ffffb097          	auipc	ra,0xffffb
    8000619c:	7ba080e7          	jalr	1978(ra) # 80001952 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800061a0:	00d5151b          	slliw	a0,a0,0xd
    800061a4:	0c2017b7          	lui	a5,0xc201
    800061a8:	97aa                	add	a5,a5,a0
    800061aa:	c3c4                	sw	s1,4(a5)
}
    800061ac:	60e2                	ld	ra,24(sp)
    800061ae:	6442                	ld	s0,16(sp)
    800061b0:	64a2                	ld	s1,8(sp)
    800061b2:	6105                	addi	sp,sp,32
    800061b4:	8082                	ret

00000000800061b6 <start_ret>:
    800061b6:	48e1                	li	a7,24
    800061b8:	00000073          	ecall

00000000800061bc <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800061bc:	1141                	addi	sp,sp,-16
    800061be:	e406                	sd	ra,8(sp)
    800061c0:	e022                	sd	s0,0(sp)
    800061c2:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800061c4:	479d                	li	a5,7
    800061c6:	06a7c963          	blt	a5,a0,80006238 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800061ca:	00023797          	auipc	a5,0x23
    800061ce:	e3678793          	addi	a5,a5,-458 # 80029000 <disk>
    800061d2:	00a78733          	add	a4,a5,a0
    800061d6:	6789                	lui	a5,0x2
    800061d8:	97ba                	add	a5,a5,a4
    800061da:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800061de:	e7ad                	bnez	a5,80006248 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800061e0:	00451793          	slli	a5,a0,0x4
    800061e4:	00025717          	auipc	a4,0x25
    800061e8:	e1c70713          	addi	a4,a4,-484 # 8002b000 <disk+0x2000>
    800061ec:	6314                	ld	a3,0(a4)
    800061ee:	96be                	add	a3,a3,a5
    800061f0:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800061f4:	6314                	ld	a3,0(a4)
    800061f6:	96be                	add	a3,a3,a5
    800061f8:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800061fc:	6314                	ld	a3,0(a4)
    800061fe:	96be                	add	a3,a3,a5
    80006200:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80006204:	6318                	ld	a4,0(a4)
    80006206:	97ba                	add	a5,a5,a4
    80006208:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    8000620c:	00023797          	auipc	a5,0x23
    80006210:	df478793          	addi	a5,a5,-524 # 80029000 <disk>
    80006214:	97aa                	add	a5,a5,a0
    80006216:	6509                	lui	a0,0x2
    80006218:	953e                	add	a0,a0,a5
    8000621a:	4785                	li	a5,1
    8000621c:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80006220:	00025517          	auipc	a0,0x25
    80006224:	df850513          	addi	a0,a0,-520 # 8002b018 <disk+0x2018>
    80006228:	ffffc097          	auipc	ra,0xffffc
    8000622c:	06e080e7          	jalr	110(ra) # 80002296 <wakeup>
}
    80006230:	60a2                	ld	ra,8(sp)
    80006232:	6402                	ld	s0,0(sp)
    80006234:	0141                	addi	sp,sp,16
    80006236:	8082                	ret
    panic("free_desc 1");
    80006238:	00002517          	auipc	a0,0x2
    8000623c:	60050513          	addi	a0,a0,1536 # 80008838 <syscalls+0x338>
    80006240:	ffffa097          	auipc	ra,0xffffa
    80006244:	2ea080e7          	jalr	746(ra) # 8000052a <panic>
    panic("free_desc 2");
    80006248:	00002517          	auipc	a0,0x2
    8000624c:	60050513          	addi	a0,a0,1536 # 80008848 <syscalls+0x348>
    80006250:	ffffa097          	auipc	ra,0xffffa
    80006254:	2da080e7          	jalr	730(ra) # 8000052a <panic>

0000000080006258 <virtio_disk_init>:
{
    80006258:	1101                	addi	sp,sp,-32
    8000625a:	ec06                	sd	ra,24(sp)
    8000625c:	e822                	sd	s0,16(sp)
    8000625e:	e426                	sd	s1,8(sp)
    80006260:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006262:	00002597          	auipc	a1,0x2
    80006266:	5f658593          	addi	a1,a1,1526 # 80008858 <syscalls+0x358>
    8000626a:	00025517          	auipc	a0,0x25
    8000626e:	ebe50513          	addi	a0,a0,-322 # 8002b128 <disk+0x2128>
    80006272:	ffffb097          	auipc	ra,0xffffb
    80006276:	8c0080e7          	jalr	-1856(ra) # 80000b32 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000627a:	100017b7          	lui	a5,0x10001
    8000627e:	4398                	lw	a4,0(a5)
    80006280:	2701                	sext.w	a4,a4
    80006282:	747277b7          	lui	a5,0x74727
    80006286:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000628a:	0ef71163          	bne	a4,a5,8000636c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000628e:	100017b7          	lui	a5,0x10001
    80006292:	43dc                	lw	a5,4(a5)
    80006294:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006296:	4705                	li	a4,1
    80006298:	0ce79a63          	bne	a5,a4,8000636c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000629c:	100017b7          	lui	a5,0x10001
    800062a0:	479c                	lw	a5,8(a5)
    800062a2:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800062a4:	4709                	li	a4,2
    800062a6:	0ce79363          	bne	a5,a4,8000636c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800062aa:	100017b7          	lui	a5,0x10001
    800062ae:	47d8                	lw	a4,12(a5)
    800062b0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800062b2:	554d47b7          	lui	a5,0x554d4
    800062b6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800062ba:	0af71963          	bne	a4,a5,8000636c <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800062be:	100017b7          	lui	a5,0x10001
    800062c2:	4705                	li	a4,1
    800062c4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800062c6:	470d                	li	a4,3
    800062c8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800062ca:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800062cc:	c7ffe737          	lui	a4,0xc7ffe
    800062d0:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd275f>
    800062d4:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800062d6:	2701                	sext.w	a4,a4
    800062d8:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800062da:	472d                	li	a4,11
    800062dc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800062de:	473d                	li	a4,15
    800062e0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800062e2:	6705                	lui	a4,0x1
    800062e4:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800062e6:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800062ea:	5bdc                	lw	a5,52(a5)
    800062ec:	2781                	sext.w	a5,a5
  if(max == 0)
    800062ee:	c7d9                	beqz	a5,8000637c <virtio_disk_init+0x124>
  if(max < NUM)
    800062f0:	471d                	li	a4,7
    800062f2:	08f77d63          	bgeu	a4,a5,8000638c <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800062f6:	100014b7          	lui	s1,0x10001
    800062fa:	47a1                	li	a5,8
    800062fc:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800062fe:	6609                	lui	a2,0x2
    80006300:	4581                	li	a1,0
    80006302:	00023517          	auipc	a0,0x23
    80006306:	cfe50513          	addi	a0,a0,-770 # 80029000 <disk>
    8000630a:	ffffb097          	auipc	ra,0xffffb
    8000630e:	9b4080e7          	jalr	-1612(ra) # 80000cbe <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006312:	00023717          	auipc	a4,0x23
    80006316:	cee70713          	addi	a4,a4,-786 # 80029000 <disk>
    8000631a:	00c75793          	srli	a5,a4,0xc
    8000631e:	2781                	sext.w	a5,a5
    80006320:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80006322:	00025797          	auipc	a5,0x25
    80006326:	cde78793          	addi	a5,a5,-802 # 8002b000 <disk+0x2000>
    8000632a:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    8000632c:	00023717          	auipc	a4,0x23
    80006330:	d5470713          	addi	a4,a4,-684 # 80029080 <disk+0x80>
    80006334:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80006336:	00024717          	auipc	a4,0x24
    8000633a:	cca70713          	addi	a4,a4,-822 # 8002a000 <disk+0x1000>
    8000633e:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80006340:	4705                	li	a4,1
    80006342:	00e78c23          	sb	a4,24(a5)
    80006346:	00e78ca3          	sb	a4,25(a5)
    8000634a:	00e78d23          	sb	a4,26(a5)
    8000634e:	00e78da3          	sb	a4,27(a5)
    80006352:	00e78e23          	sb	a4,28(a5)
    80006356:	00e78ea3          	sb	a4,29(a5)
    8000635a:	00e78f23          	sb	a4,30(a5)
    8000635e:	00e78fa3          	sb	a4,31(a5)
}
    80006362:	60e2                	ld	ra,24(sp)
    80006364:	6442                	ld	s0,16(sp)
    80006366:	64a2                	ld	s1,8(sp)
    80006368:	6105                	addi	sp,sp,32
    8000636a:	8082                	ret
    panic("could not find virtio disk");
    8000636c:	00002517          	auipc	a0,0x2
    80006370:	4fc50513          	addi	a0,a0,1276 # 80008868 <syscalls+0x368>
    80006374:	ffffa097          	auipc	ra,0xffffa
    80006378:	1b6080e7          	jalr	438(ra) # 8000052a <panic>
    panic("virtio disk has no queue 0");
    8000637c:	00002517          	auipc	a0,0x2
    80006380:	50c50513          	addi	a0,a0,1292 # 80008888 <syscalls+0x388>
    80006384:	ffffa097          	auipc	ra,0xffffa
    80006388:	1a6080e7          	jalr	422(ra) # 8000052a <panic>
    panic("virtio disk max queue too short");
    8000638c:	00002517          	auipc	a0,0x2
    80006390:	51c50513          	addi	a0,a0,1308 # 800088a8 <syscalls+0x3a8>
    80006394:	ffffa097          	auipc	ra,0xffffa
    80006398:	196080e7          	jalr	406(ra) # 8000052a <panic>

000000008000639c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000639c:	7119                	addi	sp,sp,-128
    8000639e:	fc86                	sd	ra,120(sp)
    800063a0:	f8a2                	sd	s0,112(sp)
    800063a2:	f4a6                	sd	s1,104(sp)
    800063a4:	f0ca                	sd	s2,96(sp)
    800063a6:	ecce                	sd	s3,88(sp)
    800063a8:	e8d2                	sd	s4,80(sp)
    800063aa:	e4d6                	sd	s5,72(sp)
    800063ac:	e0da                	sd	s6,64(sp)
    800063ae:	fc5e                	sd	s7,56(sp)
    800063b0:	f862                	sd	s8,48(sp)
    800063b2:	f466                	sd	s9,40(sp)
    800063b4:	f06a                	sd	s10,32(sp)
    800063b6:	ec6e                	sd	s11,24(sp)
    800063b8:	0100                	addi	s0,sp,128
    800063ba:	8aaa                	mv	s5,a0
    800063bc:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800063be:	00c52c83          	lw	s9,12(a0)
    800063c2:	001c9c9b          	slliw	s9,s9,0x1
    800063c6:	1c82                	slli	s9,s9,0x20
    800063c8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800063cc:	00025517          	auipc	a0,0x25
    800063d0:	d5c50513          	addi	a0,a0,-676 # 8002b128 <disk+0x2128>
    800063d4:	ffffa097          	auipc	ra,0xffffa
    800063d8:	7ee080e7          	jalr	2030(ra) # 80000bc2 <acquire>
  for(int i = 0; i < 3; i++){
    800063dc:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800063de:	44a1                	li	s1,8
      disk.free[i] = 0;
    800063e0:	00023c17          	auipc	s8,0x23
    800063e4:	c20c0c13          	addi	s8,s8,-992 # 80029000 <disk>
    800063e8:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800063ea:	4b0d                	li	s6,3
    800063ec:	a0ad                	j	80006456 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800063ee:	00fc0733          	add	a4,s8,a5
    800063f2:	975e                	add	a4,a4,s7
    800063f4:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800063f8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800063fa:	0207c563          	bltz	a5,80006424 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800063fe:	2905                	addiw	s2,s2,1
    80006400:	0611                	addi	a2,a2,4
    80006402:	19690d63          	beq	s2,s6,8000659c <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80006406:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006408:	00025717          	auipc	a4,0x25
    8000640c:	c1070713          	addi	a4,a4,-1008 # 8002b018 <disk+0x2018>
    80006410:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006412:	00074683          	lbu	a3,0(a4)
    80006416:	fee1                	bnez	a3,800063ee <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80006418:	2785                	addiw	a5,a5,1
    8000641a:	0705                	addi	a4,a4,1
    8000641c:	fe979be3          	bne	a5,s1,80006412 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80006420:	57fd                	li	a5,-1
    80006422:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006424:	01205d63          	blez	s2,8000643e <virtio_disk_rw+0xa2>
    80006428:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    8000642a:	000a2503          	lw	a0,0(s4)
    8000642e:	00000097          	auipc	ra,0x0
    80006432:	d8e080e7          	jalr	-626(ra) # 800061bc <free_desc>
      for(int j = 0; j < i; j++)
    80006436:	2d85                	addiw	s11,s11,1
    80006438:	0a11                	addi	s4,s4,4
    8000643a:	ffb918e3          	bne	s2,s11,8000642a <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000643e:	00025597          	auipc	a1,0x25
    80006442:	cea58593          	addi	a1,a1,-790 # 8002b128 <disk+0x2128>
    80006446:	00025517          	auipc	a0,0x25
    8000644a:	bd250513          	addi	a0,a0,-1070 # 8002b018 <disk+0x2018>
    8000644e:	ffffc097          	auipc	ra,0xffffc
    80006452:	cbc080e7          	jalr	-836(ra) # 8000210a <sleep>
  for(int i = 0; i < 3; i++){
    80006456:	f8040a13          	addi	s4,s0,-128
{
    8000645a:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000645c:	894e                	mv	s2,s3
    8000645e:	b765                	j	80006406 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80006460:	00025697          	auipc	a3,0x25
    80006464:	ba06b683          	ld	a3,-1120(a3) # 8002b000 <disk+0x2000>
    80006468:	96ba                	add	a3,a3,a4
    8000646a:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000646e:	00023817          	auipc	a6,0x23
    80006472:	b9280813          	addi	a6,a6,-1134 # 80029000 <disk>
    80006476:	00025697          	auipc	a3,0x25
    8000647a:	b8a68693          	addi	a3,a3,-1142 # 8002b000 <disk+0x2000>
    8000647e:	6290                	ld	a2,0(a3)
    80006480:	963a                	add	a2,a2,a4
    80006482:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80006486:	0015e593          	ori	a1,a1,1
    8000648a:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    8000648e:	f8842603          	lw	a2,-120(s0)
    80006492:	628c                	ld	a1,0(a3)
    80006494:	972e                	add	a4,a4,a1
    80006496:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000649a:	20050593          	addi	a1,a0,512
    8000649e:	0592                	slli	a1,a1,0x4
    800064a0:	95c2                	add	a1,a1,a6
    800064a2:	577d                	li	a4,-1
    800064a4:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800064a8:	00461713          	slli	a4,a2,0x4
    800064ac:	6290                	ld	a2,0(a3)
    800064ae:	963a                	add	a2,a2,a4
    800064b0:	03078793          	addi	a5,a5,48
    800064b4:	97c2                	add	a5,a5,a6
    800064b6:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800064b8:	629c                	ld	a5,0(a3)
    800064ba:	97ba                	add	a5,a5,a4
    800064bc:	4605                	li	a2,1
    800064be:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800064c0:	629c                	ld	a5,0(a3)
    800064c2:	97ba                	add	a5,a5,a4
    800064c4:	4809                	li	a6,2
    800064c6:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800064ca:	629c                	ld	a5,0(a3)
    800064cc:	973e                	add	a4,a4,a5
    800064ce:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800064d2:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800064d6:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800064da:	6698                	ld	a4,8(a3)
    800064dc:	00275783          	lhu	a5,2(a4)
    800064e0:	8b9d                	andi	a5,a5,7
    800064e2:	0786                	slli	a5,a5,0x1
    800064e4:	97ba                	add	a5,a5,a4
    800064e6:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    800064ea:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800064ee:	6698                	ld	a4,8(a3)
    800064f0:	00275783          	lhu	a5,2(a4)
    800064f4:	2785                	addiw	a5,a5,1
    800064f6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800064fa:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800064fe:	100017b7          	lui	a5,0x10001
    80006502:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006506:	004aa783          	lw	a5,4(s5)
    8000650a:	02c79163          	bne	a5,a2,8000652c <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    8000650e:	00025917          	auipc	s2,0x25
    80006512:	c1a90913          	addi	s2,s2,-998 # 8002b128 <disk+0x2128>
  while(b->disk == 1) {
    80006516:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006518:	85ca                	mv	a1,s2
    8000651a:	8556                	mv	a0,s5
    8000651c:	ffffc097          	auipc	ra,0xffffc
    80006520:	bee080e7          	jalr	-1042(ra) # 8000210a <sleep>
  while(b->disk == 1) {
    80006524:	004aa783          	lw	a5,4(s5)
    80006528:	fe9788e3          	beq	a5,s1,80006518 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    8000652c:	f8042903          	lw	s2,-128(s0)
    80006530:	20090793          	addi	a5,s2,512
    80006534:	00479713          	slli	a4,a5,0x4
    80006538:	00023797          	auipc	a5,0x23
    8000653c:	ac878793          	addi	a5,a5,-1336 # 80029000 <disk>
    80006540:	97ba                	add	a5,a5,a4
    80006542:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80006546:	00025997          	auipc	s3,0x25
    8000654a:	aba98993          	addi	s3,s3,-1350 # 8002b000 <disk+0x2000>
    8000654e:	00491713          	slli	a4,s2,0x4
    80006552:	0009b783          	ld	a5,0(s3)
    80006556:	97ba                	add	a5,a5,a4
    80006558:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000655c:	854a                	mv	a0,s2
    8000655e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006562:	00000097          	auipc	ra,0x0
    80006566:	c5a080e7          	jalr	-934(ra) # 800061bc <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000656a:	8885                	andi	s1,s1,1
    8000656c:	f0ed                	bnez	s1,8000654e <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000656e:	00025517          	auipc	a0,0x25
    80006572:	bba50513          	addi	a0,a0,-1094 # 8002b128 <disk+0x2128>
    80006576:	ffffa097          	auipc	ra,0xffffa
    8000657a:	700080e7          	jalr	1792(ra) # 80000c76 <release>
}
    8000657e:	70e6                	ld	ra,120(sp)
    80006580:	7446                	ld	s0,112(sp)
    80006582:	74a6                	ld	s1,104(sp)
    80006584:	7906                	ld	s2,96(sp)
    80006586:	69e6                	ld	s3,88(sp)
    80006588:	6a46                	ld	s4,80(sp)
    8000658a:	6aa6                	ld	s5,72(sp)
    8000658c:	6b06                	ld	s6,64(sp)
    8000658e:	7be2                	ld	s7,56(sp)
    80006590:	7c42                	ld	s8,48(sp)
    80006592:	7ca2                	ld	s9,40(sp)
    80006594:	7d02                	ld	s10,32(sp)
    80006596:	6de2                	ld	s11,24(sp)
    80006598:	6109                	addi	sp,sp,128
    8000659a:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000659c:	f8042503          	lw	a0,-128(s0)
    800065a0:	20050793          	addi	a5,a0,512
    800065a4:	0792                	slli	a5,a5,0x4
  if(write)
    800065a6:	00023817          	auipc	a6,0x23
    800065aa:	a5a80813          	addi	a6,a6,-1446 # 80029000 <disk>
    800065ae:	00f80733          	add	a4,a6,a5
    800065b2:	01a036b3          	snez	a3,s10
    800065b6:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800065ba:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800065be:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800065c2:	7679                	lui	a2,0xffffe
    800065c4:	963e                	add	a2,a2,a5
    800065c6:	00025697          	auipc	a3,0x25
    800065ca:	a3a68693          	addi	a3,a3,-1478 # 8002b000 <disk+0x2000>
    800065ce:	6298                	ld	a4,0(a3)
    800065d0:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800065d2:	0a878593          	addi	a1,a5,168
    800065d6:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800065d8:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800065da:	6298                	ld	a4,0(a3)
    800065dc:	9732                	add	a4,a4,a2
    800065de:	45c1                	li	a1,16
    800065e0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800065e2:	6298                	ld	a4,0(a3)
    800065e4:	9732                	add	a4,a4,a2
    800065e6:	4585                	li	a1,1
    800065e8:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800065ec:	f8442703          	lw	a4,-124(s0)
    800065f0:	628c                	ld	a1,0(a3)
    800065f2:	962e                	add	a2,a2,a1
    800065f4:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd200e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800065f8:	0712                	slli	a4,a4,0x4
    800065fa:	6290                	ld	a2,0(a3)
    800065fc:	963a                	add	a2,a2,a4
    800065fe:	058a8593          	addi	a1,s5,88
    80006602:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006604:	6294                	ld	a3,0(a3)
    80006606:	96ba                	add	a3,a3,a4
    80006608:	40000613          	li	a2,1024
    8000660c:	c690                	sw	a2,8(a3)
  if(write)
    8000660e:	e40d19e3          	bnez	s10,80006460 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006612:	00025697          	auipc	a3,0x25
    80006616:	9ee6b683          	ld	a3,-1554(a3) # 8002b000 <disk+0x2000>
    8000661a:	96ba                	add	a3,a3,a4
    8000661c:	4609                	li	a2,2
    8000661e:	00c69623          	sh	a2,12(a3)
    80006622:	b5b1                	j	8000646e <virtio_disk_rw+0xd2>

0000000080006624 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006624:	1101                	addi	sp,sp,-32
    80006626:	ec06                	sd	ra,24(sp)
    80006628:	e822                	sd	s0,16(sp)
    8000662a:	e426                	sd	s1,8(sp)
    8000662c:	e04a                	sd	s2,0(sp)
    8000662e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006630:	00025517          	auipc	a0,0x25
    80006634:	af850513          	addi	a0,a0,-1288 # 8002b128 <disk+0x2128>
    80006638:	ffffa097          	auipc	ra,0xffffa
    8000663c:	58a080e7          	jalr	1418(ra) # 80000bc2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006640:	10001737          	lui	a4,0x10001
    80006644:	533c                	lw	a5,96(a4)
    80006646:	8b8d                	andi	a5,a5,3
    80006648:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000664a:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000664e:	00025797          	auipc	a5,0x25
    80006652:	9b278793          	addi	a5,a5,-1614 # 8002b000 <disk+0x2000>
    80006656:	6b94                	ld	a3,16(a5)
    80006658:	0207d703          	lhu	a4,32(a5)
    8000665c:	0026d783          	lhu	a5,2(a3)
    80006660:	06f70163          	beq	a4,a5,800066c2 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006664:	00023917          	auipc	s2,0x23
    80006668:	99c90913          	addi	s2,s2,-1636 # 80029000 <disk>
    8000666c:	00025497          	auipc	s1,0x25
    80006670:	99448493          	addi	s1,s1,-1644 # 8002b000 <disk+0x2000>
    __sync_synchronize();
    80006674:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006678:	6898                	ld	a4,16(s1)
    8000667a:	0204d783          	lhu	a5,32(s1)
    8000667e:	8b9d                	andi	a5,a5,7
    80006680:	078e                	slli	a5,a5,0x3
    80006682:	97ba                	add	a5,a5,a4
    80006684:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006686:	20078713          	addi	a4,a5,512
    8000668a:	0712                	slli	a4,a4,0x4
    8000668c:	974a                	add	a4,a4,s2
    8000668e:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80006692:	e731                	bnez	a4,800066de <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006694:	20078793          	addi	a5,a5,512
    80006698:	0792                	slli	a5,a5,0x4
    8000669a:	97ca                	add	a5,a5,s2
    8000669c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    8000669e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800066a2:	ffffc097          	auipc	ra,0xffffc
    800066a6:	bf4080e7          	jalr	-1036(ra) # 80002296 <wakeup>

    disk.used_idx += 1;
    800066aa:	0204d783          	lhu	a5,32(s1)
    800066ae:	2785                	addiw	a5,a5,1
    800066b0:	17c2                	slli	a5,a5,0x30
    800066b2:	93c1                	srli	a5,a5,0x30
    800066b4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800066b8:	6898                	ld	a4,16(s1)
    800066ba:	00275703          	lhu	a4,2(a4)
    800066be:	faf71be3          	bne	a4,a5,80006674 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800066c2:	00025517          	auipc	a0,0x25
    800066c6:	a6650513          	addi	a0,a0,-1434 # 8002b128 <disk+0x2128>
    800066ca:	ffffa097          	auipc	ra,0xffffa
    800066ce:	5ac080e7          	jalr	1452(ra) # 80000c76 <release>
}
    800066d2:	60e2                	ld	ra,24(sp)
    800066d4:	6442                	ld	s0,16(sp)
    800066d6:	64a2                	ld	s1,8(sp)
    800066d8:	6902                	ld	s2,0(sp)
    800066da:	6105                	addi	sp,sp,32
    800066dc:	8082                	ret
      panic("virtio_disk_intr status");
    800066de:	00002517          	auipc	a0,0x2
    800066e2:	1ea50513          	addi	a0,a0,490 # 800088c8 <syscalls+0x3c8>
    800066e6:	ffffa097          	auipc	ra,0xffffa
    800066ea:	e44080e7          	jalr	-444(ra) # 8000052a <panic>
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
