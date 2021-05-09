
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	18010113          	addi	sp,sp,384 # 8000a180 <stack0>
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
    80000052:	0000a717          	auipc	a4,0xa
    80000056:	fee70713          	addi	a4,a4,-18 # 8000a040 <timer_scratch>
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
    80000064:	00007797          	auipc	a5,0x7
    80000068:	a5c78793          	addi	a5,a5,-1444 # 80006ac0 <timervec>
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
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff977ff>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	dcc78793          	addi	a5,a5,-564 # 80000e7a <main>
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
    80000122:	7ae080e7          	jalr	1966(ra) # 800028cc <either_copyin>
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
    8000017c:	00012517          	auipc	a0,0x12
    80000180:	00450513          	addi	a0,a0,4 # 80012180 <cons>
    80000184:	00001097          	auipc	ra,0x1
    80000188:	a46080e7          	jalr	-1466(ra) # 80000bca <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000018c:	00012497          	auipc	s1,0x12
    80000190:	ff448493          	addi	s1,s1,-12 # 80012180 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000194:	00012917          	auipc	s2,0x12
    80000198:	08490913          	addi	s2,s2,132 # 80012218 <cons+0x98>
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
    800001b2:	00002097          	auipc	ra,0x2
    800001b6:	846080e7          	jalr	-1978(ra) # 800019f8 <myproc>
    800001ba:	4d5c                	lw	a5,28(a0)
    800001bc:	e7b5                	bnez	a5,80000228 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001be:	85a6                	mv	a1,s1
    800001c0:	854a                	mv	a0,s2
    800001c2:	00002097          	auipc	ra,0x2
    800001c6:	1bc080e7          	jalr	444(ra) # 8000237e <sleep>
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
    80000202:	672080e7          	jalr	1650(ra) # 80002870 <either_copyout>
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
    80000212:	00012517          	auipc	a0,0x12
    80000216:	f6e50513          	addi	a0,a0,-146 # 80012180 <cons>
    8000021a:	00001097          	auipc	ra,0x1
    8000021e:	a6a080e7          	jalr	-1430(ra) # 80000c84 <release>

  return target - n;
    80000222:	413b053b          	subw	a0,s6,s3
    80000226:	a811                	j	8000023a <consoleread+0xe4>
        release(&cons.lock);
    80000228:	00012517          	auipc	a0,0x12
    8000022c:	f5850513          	addi	a0,a0,-168 # 80012180 <cons>
    80000230:	00001097          	auipc	ra,0x1
    80000234:	a54080e7          	jalr	-1452(ra) # 80000c84 <release>
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
    8000025e:	00012717          	auipc	a4,0x12
    80000262:	faf72d23          	sw	a5,-70(a4) # 80012218 <cons+0x98>
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
    800002b8:	00012517          	auipc	a0,0x12
    800002bc:	ec850513          	addi	a0,a0,-312 # 80012180 <cons>
    800002c0:	00001097          	auipc	ra,0x1
    800002c4:	90a080e7          	jalr	-1782(ra) # 80000bca <acquire>

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
    800002e2:	64a080e7          	jalr	1610(ra) # 80002928 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002e6:	00012517          	auipc	a0,0x12
    800002ea:	e9a50513          	addi	a0,a0,-358 # 80012180 <cons>
    800002ee:	00001097          	auipc	ra,0x1
    800002f2:	996080e7          	jalr	-1642(ra) # 80000c84 <release>
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
    8000030a:	00012717          	auipc	a4,0x12
    8000030e:	e7670713          	addi	a4,a4,-394 # 80012180 <cons>
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
    80000334:	00012797          	auipc	a5,0x12
    80000338:	e4c78793          	addi	a5,a5,-436 # 80012180 <cons>
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
    80000362:	00012797          	auipc	a5,0x12
    80000366:	eb67a783          	lw	a5,-330(a5) # 80012218 <cons+0x98>
    8000036a:	0807879b          	addiw	a5,a5,128
    8000036e:	f6f61ce3          	bne	a2,a5,800002e6 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000372:	863e                	mv	a2,a5
    80000374:	a07d                	j	80000422 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000376:	00012717          	auipc	a4,0x12
    8000037a:	e0a70713          	addi	a4,a4,-502 # 80012180 <cons>
    8000037e:	0a072783          	lw	a5,160(a4)
    80000382:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000386:	00012497          	auipc	s1,0x12
    8000038a:	dfa48493          	addi	s1,s1,-518 # 80012180 <cons>
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
    800003c2:	00012717          	auipc	a4,0x12
    800003c6:	dbe70713          	addi	a4,a4,-578 # 80012180 <cons>
    800003ca:	0a072783          	lw	a5,160(a4)
    800003ce:	09c72703          	lw	a4,156(a4)
    800003d2:	f0f70ae3          	beq	a4,a5,800002e6 <consoleintr+0x3c>
      cons.e--;
    800003d6:	37fd                	addiw	a5,a5,-1
    800003d8:	00012717          	auipc	a4,0x12
    800003dc:	e4f72423          	sw	a5,-440(a4) # 80012220 <cons+0xa0>
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
    800003fe:	00012797          	auipc	a5,0x12
    80000402:	d8278793          	addi	a5,a5,-638 # 80012180 <cons>
    80000406:	0a07a703          	lw	a4,160(a5)
    8000040a:	0017069b          	addiw	a3,a4,1
    8000040e:	0006861b          	sext.w	a2,a3
    80000412:	0ad7a023          	sw	a3,160(a5)
    80000416:	07f77713          	andi	a4,a4,127
    8000041a:	97ba                	add	a5,a5,a4
    8000041c:	4729                	li	a4,10
    8000041e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000422:	00012797          	auipc	a5,0x12
    80000426:	dec7ad23          	sw	a2,-518(a5) # 8001221c <cons+0x9c>
        wakeup(&cons.r);
    8000042a:	00012517          	auipc	a0,0x12
    8000042e:	dee50513          	addi	a0,a0,-530 # 80012218 <cons+0x98>
    80000432:	00002097          	auipc	ra,0x2
    80000436:	0f6080e7          	jalr	246(ra) # 80002528 <wakeup>
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
    80000444:	00009597          	auipc	a1,0x9
    80000448:	bcc58593          	addi	a1,a1,-1076 # 80009010 <etext+0x10>
    8000044c:	00012517          	auipc	a0,0x12
    80000450:	d3450513          	addi	a0,a0,-716 # 80012180 <cons>
    80000454:	00000097          	auipc	ra,0x0
    80000458:	6de080e7          	jalr	1758(ra) # 80000b32 <initlock>

  uartinit();
    8000045c:	00000097          	auipc	ra,0x0
    80000460:	32a080e7          	jalr	810(ra) # 80000786 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000464:	00062797          	auipc	a5,0x62
    80000468:	33c78793          	addi	a5,a5,828 # 800627a0 <devsw>
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
    800004a6:	00009617          	auipc	a2,0x9
    800004aa:	b9a60613          	addi	a2,a2,-1126 # 80009040 <digits>
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
    80000536:	00012797          	auipc	a5,0x12
    8000053a:	d007a523          	sw	zero,-758(a5) # 80012240 <pr+0x18>
  printf("panic: ");
    8000053e:	00009517          	auipc	a0,0x9
    80000542:	ada50513          	addi	a0,a0,-1318 # 80009018 <etext+0x18>
    80000546:	00000097          	auipc	ra,0x0
    8000054a:	02e080e7          	jalr	46(ra) # 80000574 <printf>
  printf(s);
    8000054e:	8526                	mv	a0,s1
    80000550:	00000097          	auipc	ra,0x0
    80000554:	024080e7          	jalr	36(ra) # 80000574 <printf>
  printf("\n");
    80000558:	00009517          	auipc	a0,0x9
    8000055c:	d5050513          	addi	a0,a0,-688 # 800092a8 <digits+0x268>
    80000560:	00000097          	auipc	ra,0x0
    80000564:	014080e7          	jalr	20(ra) # 80000574 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000568:	4785                	li	a5,1
    8000056a:	0000a717          	auipc	a4,0xa
    8000056e:	a8f72b23          	sw	a5,-1386(a4) # 8000a000 <panicked>
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
    800005a6:	00012d97          	auipc	s11,0x12
    800005aa:	c9adad83          	lw	s11,-870(s11) # 80012240 <pr+0x18>
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
    800005d2:	00009b17          	auipc	s6,0x9
    800005d6:	a6eb0b13          	addi	s6,s6,-1426 # 80009040 <digits>
    switch(c){
    800005da:	07300c93          	li	s9,115
    800005de:	06400c13          	li	s8,100
    800005e2:	a82d                	j	8000061c <printf+0xa8>
    acquire(&pr.lock);
    800005e4:	00012517          	auipc	a0,0x12
    800005e8:	c4450513          	addi	a0,a0,-956 # 80012228 <pr>
    800005ec:	00000097          	auipc	ra,0x0
    800005f0:	5de080e7          	jalr	1502(ra) # 80000bca <acquire>
    800005f4:	bf7d                	j	800005b2 <printf+0x3e>
    panic("null fmt");
    800005f6:	00009517          	auipc	a0,0x9
    800005fa:	a3250513          	addi	a0,a0,-1486 # 80009028 <etext+0x28>
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
    800006f0:	00009497          	auipc	s1,0x9
    800006f4:	93048493          	addi	s1,s1,-1744 # 80009020 <etext+0x20>
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
    80000742:	00012517          	auipc	a0,0x12
    80000746:	ae650513          	addi	a0,a0,-1306 # 80012228 <pr>
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	53a080e7          	jalr	1338(ra) # 80000c84 <release>
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
    8000075e:	00012497          	auipc	s1,0x12
    80000762:	aca48493          	addi	s1,s1,-1334 # 80012228 <pr>
    80000766:	00009597          	auipc	a1,0x9
    8000076a:	8d258593          	addi	a1,a1,-1838 # 80009038 <etext+0x38>
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
    800007b6:	00009597          	auipc	a1,0x9
    800007ba:	8a258593          	addi	a1,a1,-1886 # 80009058 <digits+0x18>
    800007be:	00012517          	auipc	a0,0x12
    800007c2:	a8a50513          	addi	a0,a0,-1398 # 80012248 <uart_tx_lock>
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
    800007ea:	0000a797          	auipc	a5,0xa
    800007ee:	8167a783          	lw	a5,-2026(a5) # 8000a000 <panicked>
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
    80000814:	40e080e7          	jalr	1038(ra) # 80000c1e <pop_off>
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
    80000822:	00009797          	auipc	a5,0x9
    80000826:	7e67b783          	ld	a5,2022(a5) # 8000a008 <uart_tx_r>
    8000082a:	00009717          	auipc	a4,0x9
    8000082e:	7e673703          	ld	a4,2022(a4) # 8000a010 <uart_tx_w>
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
    8000084c:	00012a17          	auipc	s4,0x12
    80000850:	9fca0a13          	addi	s4,s4,-1540 # 80012248 <uart_tx_lock>
    uart_tx_r += 1;
    80000854:	00009497          	auipc	s1,0x9
    80000858:	7b448493          	addi	s1,s1,1972 # 8000a008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000085c:	00009997          	auipc	s3,0x9
    80000860:	7b498993          	addi	s3,s3,1972 # 8000a010 <uart_tx_w>
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
    80000882:	caa080e7          	jalr	-854(ra) # 80002528 <wakeup>
    
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
    800008ba:	00012517          	auipc	a0,0x12
    800008be:	98e50513          	addi	a0,a0,-1650 # 80012248 <uart_tx_lock>
    800008c2:	00000097          	auipc	ra,0x0
    800008c6:	308080e7          	jalr	776(ra) # 80000bca <acquire>
  if(panicked){
    800008ca:	00009797          	auipc	a5,0x9
    800008ce:	7367a783          	lw	a5,1846(a5) # 8000a000 <panicked>
    800008d2:	c391                	beqz	a5,800008d6 <uartputc+0x2e>
    for(;;)
    800008d4:	a001                	j	800008d4 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008d6:	00009717          	auipc	a4,0x9
    800008da:	73a73703          	ld	a4,1850(a4) # 8000a010 <uart_tx_w>
    800008de:	00009797          	auipc	a5,0x9
    800008e2:	72a7b783          	ld	a5,1834(a5) # 8000a008 <uart_tx_r>
    800008e6:	02078793          	addi	a5,a5,32
    800008ea:	02e79b63          	bne	a5,a4,80000920 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800008ee:	00012997          	auipc	s3,0x12
    800008f2:	95a98993          	addi	s3,s3,-1702 # 80012248 <uart_tx_lock>
    800008f6:	00009497          	auipc	s1,0x9
    800008fa:	71248493          	addi	s1,s1,1810 # 8000a008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008fe:	00009917          	auipc	s2,0x9
    80000902:	71290913          	addi	s2,s2,1810 # 8000a010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000906:	85ce                	mv	a1,s3
    80000908:	8526                	mv	a0,s1
    8000090a:	00002097          	auipc	ra,0x2
    8000090e:	a74080e7          	jalr	-1420(ra) # 8000237e <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000912:	00093703          	ld	a4,0(s2)
    80000916:	609c                	ld	a5,0(s1)
    80000918:	02078793          	addi	a5,a5,32
    8000091c:	fee785e3          	beq	a5,a4,80000906 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000920:	00012497          	auipc	s1,0x12
    80000924:	92848493          	addi	s1,s1,-1752 # 80012248 <uart_tx_lock>
    80000928:	01f77793          	andi	a5,a4,31
    8000092c:	97a6                	add	a5,a5,s1
    8000092e:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80000932:	0705                	addi	a4,a4,1
    80000934:	00009797          	auipc	a5,0x9
    80000938:	6ce7be23          	sd	a4,1756(a5) # 8000a010 <uart_tx_w>
      uartstart();
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	ee6080e7          	jalr	-282(ra) # 80000822 <uartstart>
      release(&uart_tx_lock);
    80000944:	8526                	mv	a0,s1
    80000946:	00000097          	auipc	ra,0x0
    8000094a:	33e080e7          	jalr	830(ra) # 80000c84 <release>
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
    800009a8:	00012497          	auipc	s1,0x12
    800009ac:	8a048493          	addi	s1,s1,-1888 # 80012248 <uart_tx_lock>
    800009b0:	8526                	mv	a0,s1
    800009b2:	00000097          	auipc	ra,0x0
    800009b6:	218080e7          	jalr	536(ra) # 80000bca <acquire>
  uartstart();
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	e68080e7          	jalr	-408(ra) # 80000822 <uartstart>
  release(&uart_tx_lock);
    800009c2:	8526                	mv	a0,s1
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	2c0080e7          	jalr	704(ra) # 80000c84 <release>
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
    800009ea:	00066797          	auipc	a5,0x66
    800009ee:	61678793          	addi	a5,a5,1558 # 80067000 <end>
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
    80000a06:	2ca080e7          	jalr	714(ra) # 80000ccc <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a0a:	00012917          	auipc	s2,0x12
    80000a0e:	87690913          	addi	s2,s2,-1930 # 80012280 <kmem>
    80000a12:	854a                	mv	a0,s2
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	1b6080e7          	jalr	438(ra) # 80000bca <acquire>
  r->next = kmem.freelist;
    80000a1c:	01893783          	ld	a5,24(s2)
    80000a20:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a22:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a26:	854a                	mv	a0,s2
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	25c080e7          	jalr	604(ra) # 80000c84 <release>
}
    80000a30:	60e2                	ld	ra,24(sp)
    80000a32:	6442                	ld	s0,16(sp)
    80000a34:	64a2                	ld	s1,8(sp)
    80000a36:	6902                	ld	s2,0(sp)
    80000a38:	6105                	addi	sp,sp,32
    80000a3a:	8082                	ret
    panic("kfree");
    80000a3c:	00008517          	auipc	a0,0x8
    80000a40:	62450513          	addi	a0,a0,1572 # 80009060 <digits+0x20>
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
    80000a9e:	00008597          	auipc	a1,0x8
    80000aa2:	5ca58593          	addi	a1,a1,1482 # 80009068 <digits+0x28>
    80000aa6:	00011517          	auipc	a0,0x11
    80000aaa:	7da50513          	addi	a0,a0,2010 # 80012280 <kmem>
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	084080e7          	jalr	132(ra) # 80000b32 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab6:	45c5                	li	a1,17
    80000ab8:	05ee                	slli	a1,a1,0x1b
    80000aba:	00066517          	auipc	a0,0x66
    80000abe:	54650513          	addi	a0,a0,1350 # 80067000 <end>
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
    80000adc:	00011497          	auipc	s1,0x11
    80000ae0:	7a448493          	addi	s1,s1,1956 # 80012280 <kmem>
    80000ae4:	8526                	mv	a0,s1
    80000ae6:	00000097          	auipc	ra,0x0
    80000aea:	0e4080e7          	jalr	228(ra) # 80000bca <acquire>
  r = kmem.freelist;
    80000aee:	6c84                	ld	s1,24(s1)
  if(r)
    80000af0:	c885                	beqz	s1,80000b20 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000af2:	609c                	ld	a5,0(s1)
    80000af4:	00011517          	auipc	a0,0x11
    80000af8:	78c50513          	addi	a0,a0,1932 # 80012280 <kmem>
    80000afc:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	186080e7          	jalr	390(ra) # 80000c84 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b06:	6605                	lui	a2,0x1
    80000b08:	4595                	li	a1,5
    80000b0a:	8526                	mv	a0,s1
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	1c0080e7          	jalr	448(ra) # 80000ccc <memset>
  return (void*)r;
}
    80000b14:	8526                	mv	a0,s1
    80000b16:	60e2                	ld	ra,24(sp)
    80000b18:	6442                	ld	s0,16(sp)
    80000b1a:	64a2                	ld	s1,8(sp)
    80000b1c:	6105                	addi	sp,sp,32
    80000b1e:	8082                	ret
  release(&kmem.lock);
    80000b20:	00011517          	auipc	a0,0x11
    80000b24:	76050513          	addi	a0,a0,1888 # 80012280 <kmem>
    80000b28:	00000097          	auipc	ra,0x0
    80000b2c:	15c080e7          	jalr	348(ra) # 80000c84 <release>
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
    80000b60:	e78080e7          	jalr	-392(ra) # 800019d4 <mycpu>
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
    80000b92:	e46080e7          	jalr	-442(ra) # 800019d4 <mycpu>
    80000b96:	08052783          	lw	a5,128(a0)
    80000b9a:	cf99                	beqz	a5,80000bb8 <push_off+0x42>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b9c:	00001097          	auipc	ra,0x1
    80000ba0:	e38080e7          	jalr	-456(ra) # 800019d4 <mycpu>
    80000ba4:	08052783          	lw	a5,128(a0)
    80000ba8:	2785                	addiw	a5,a5,1
    80000baa:	08f52023          	sw	a5,128(a0)
}
    80000bae:	60e2                	ld	ra,24(sp)
    80000bb0:	6442                	ld	s0,16(sp)
    80000bb2:	64a2                	ld	s1,8(sp)
    80000bb4:	6105                	addi	sp,sp,32
    80000bb6:	8082                	ret
    mycpu()->intena = old;
    80000bb8:	00001097          	auipc	ra,0x1
    80000bbc:	e1c080e7          	jalr	-484(ra) # 800019d4 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bc0:	8085                	srli	s1,s1,0x1
    80000bc2:	8885                	andi	s1,s1,1
    80000bc4:	08952223          	sw	s1,132(a0)
    80000bc8:	bfd1                	j	80000b9c <push_off+0x26>

0000000080000bca <acquire>:
{
    80000bca:	1101                	addi	sp,sp,-32
    80000bcc:	ec06                	sd	ra,24(sp)
    80000bce:	e822                	sd	s0,16(sp)
    80000bd0:	e426                	sd	s1,8(sp)
    80000bd2:	1000                	addi	s0,sp,32
    80000bd4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bd6:	00000097          	auipc	ra,0x0
    80000bda:	fa0080e7          	jalr	-96(ra) # 80000b76 <push_off>
  if(holding(lk))
    80000bde:	8526                	mv	a0,s1
    80000be0:	00000097          	auipc	ra,0x0
    80000be4:	f68080e7          	jalr	-152(ra) # 80000b48 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be8:	4705                	li	a4,1
  if(holding(lk))
    80000bea:	e115                	bnez	a0,80000c0e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bec:	87ba                	mv	a5,a4
    80000bee:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bf2:	2781                	sext.w	a5,a5
    80000bf4:	ffe5                	bnez	a5,80000bec <acquire+0x22>
  __sync_synchronize();
    80000bf6:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000bfa:	00001097          	auipc	ra,0x1
    80000bfe:	dda080e7          	jalr	-550(ra) # 800019d4 <mycpu>
    80000c02:	e888                	sd	a0,16(s1)
}
    80000c04:	60e2                	ld	ra,24(sp)
    80000c06:	6442                	ld	s0,16(sp)
    80000c08:	64a2                	ld	s1,8(sp)
    80000c0a:	6105                	addi	sp,sp,32
    80000c0c:	8082                	ret
    panic("acquire");
    80000c0e:	00008517          	auipc	a0,0x8
    80000c12:	46250513          	addi	a0,a0,1122 # 80009070 <digits+0x30>
    80000c16:	00000097          	auipc	ra,0x0
    80000c1a:	914080e7          	jalr	-1772(ra) # 8000052a <panic>

0000000080000c1e <pop_off>:

void
pop_off(void)
{
    80000c1e:	1141                	addi	sp,sp,-16
    80000c20:	e406                	sd	ra,8(sp)
    80000c22:	e022                	sd	s0,0(sp)
    80000c24:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c26:	00001097          	auipc	ra,0x1
    80000c2a:	dae080e7          	jalr	-594(ra) # 800019d4 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c2e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c32:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c34:	eb85                	bnez	a5,80000c64 <pop_off+0x46>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c36:	08052783          	lw	a5,128(a0)
    80000c3a:	02f05d63          	blez	a5,80000c74 <pop_off+0x56>
    panic("pop_off");
  c->noff -= 1;
    80000c3e:	37fd                	addiw	a5,a5,-1
    80000c40:	0007871b          	sext.w	a4,a5
    80000c44:	08f52023          	sw	a5,128(a0)
  if(c->noff == 0 && c->intena)
    80000c48:	eb11                	bnez	a4,80000c5c <pop_off+0x3e>
    80000c4a:	08452783          	lw	a5,132(a0)
    80000c4e:	c799                	beqz	a5,80000c5c <pop_off+0x3e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c50:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c54:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c58:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c5c:	60a2                	ld	ra,8(sp)
    80000c5e:	6402                	ld	s0,0(sp)
    80000c60:	0141                	addi	sp,sp,16
    80000c62:	8082                	ret
    panic("pop_off - interruptible");
    80000c64:	00008517          	auipc	a0,0x8
    80000c68:	41450513          	addi	a0,a0,1044 # 80009078 <digits+0x38>
    80000c6c:	00000097          	auipc	ra,0x0
    80000c70:	8be080e7          	jalr	-1858(ra) # 8000052a <panic>
    panic("pop_off");
    80000c74:	00008517          	auipc	a0,0x8
    80000c78:	41c50513          	addi	a0,a0,1052 # 80009090 <digits+0x50>
    80000c7c:	00000097          	auipc	ra,0x0
    80000c80:	8ae080e7          	jalr	-1874(ra) # 8000052a <panic>

0000000080000c84 <release>:
{
    80000c84:	1101                	addi	sp,sp,-32
    80000c86:	ec06                	sd	ra,24(sp)
    80000c88:	e822                	sd	s0,16(sp)
    80000c8a:	e426                	sd	s1,8(sp)
    80000c8c:	1000                	addi	s0,sp,32
    80000c8e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c90:	00000097          	auipc	ra,0x0
    80000c94:	eb8080e7          	jalr	-328(ra) # 80000b48 <holding>
    80000c98:	c115                	beqz	a0,80000cbc <release+0x38>
  lk->cpu = 0;
    80000c9a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c9e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca2:	0f50000f          	fence	iorw,ow
    80000ca6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000caa:	00000097          	auipc	ra,0x0
    80000cae:	f74080e7          	jalr	-140(ra) # 80000c1e <pop_off>
}
    80000cb2:	60e2                	ld	ra,24(sp)
    80000cb4:	6442                	ld	s0,16(sp)
    80000cb6:	64a2                	ld	s1,8(sp)
    80000cb8:	6105                	addi	sp,sp,32
    80000cba:	8082                	ret
    panic("release");
    80000cbc:	00008517          	auipc	a0,0x8
    80000cc0:	3dc50513          	addi	a0,a0,988 # 80009098 <digits+0x58>
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	866080e7          	jalr	-1946(ra) # 8000052a <panic>

0000000080000ccc <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000ccc:	1141                	addi	sp,sp,-16
    80000cce:	e422                	sd	s0,8(sp)
    80000cd0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd2:	ca19                	beqz	a2,80000ce8 <memset+0x1c>
    80000cd4:	87aa                	mv	a5,a0
    80000cd6:	1602                	slli	a2,a2,0x20
    80000cd8:	9201                	srli	a2,a2,0x20
    80000cda:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cde:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce2:	0785                	addi	a5,a5,1
    80000ce4:	fee79de3          	bne	a5,a4,80000cde <memset+0x12>
  }
  return dst;
}
    80000ce8:	6422                	ld	s0,8(sp)
    80000cea:	0141                	addi	sp,sp,16
    80000cec:	8082                	ret

0000000080000cee <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cee:	1141                	addi	sp,sp,-16
    80000cf0:	e422                	sd	s0,8(sp)
    80000cf2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf4:	ca05                	beqz	a2,80000d24 <memcmp+0x36>
    80000cf6:	fff6069b          	addiw	a3,a2,-1
    80000cfa:	1682                	slli	a3,a3,0x20
    80000cfc:	9281                	srli	a3,a3,0x20
    80000cfe:	0685                	addi	a3,a3,1
    80000d00:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d02:	00054783          	lbu	a5,0(a0)
    80000d06:	0005c703          	lbu	a4,0(a1)
    80000d0a:	00e79863          	bne	a5,a4,80000d1a <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d0e:	0505                	addi	a0,a0,1
    80000d10:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d12:	fed518e3          	bne	a0,a3,80000d02 <memcmp+0x14>
  }

  return 0;
    80000d16:	4501                	li	a0,0
    80000d18:	a019                	j	80000d1e <memcmp+0x30>
      return *s1 - *s2;
    80000d1a:	40e7853b          	subw	a0,a5,a4
}
    80000d1e:	6422                	ld	s0,8(sp)
    80000d20:	0141                	addi	sp,sp,16
    80000d22:	8082                	ret
  return 0;
    80000d24:	4501                	li	a0,0
    80000d26:	bfe5                	j	80000d1e <memcmp+0x30>

0000000080000d28 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d28:	1141                	addi	sp,sp,-16
    80000d2a:	e422                	sd	s0,8(sp)
    80000d2c:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d2e:	02a5e563          	bltu	a1,a0,80000d58 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d32:	fff6069b          	addiw	a3,a2,-1
    80000d36:	ce11                	beqz	a2,80000d52 <memmove+0x2a>
    80000d38:	1682                	slli	a3,a3,0x20
    80000d3a:	9281                	srli	a3,a3,0x20
    80000d3c:	0685                	addi	a3,a3,1
    80000d3e:	96ae                	add	a3,a3,a1
    80000d40:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d42:	0585                	addi	a1,a1,1
    80000d44:	0785                	addi	a5,a5,1
    80000d46:	fff5c703          	lbu	a4,-1(a1)
    80000d4a:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d4e:	fed59ae3          	bne	a1,a3,80000d42 <memmove+0x1a>

  return dst;
}
    80000d52:	6422                	ld	s0,8(sp)
    80000d54:	0141                	addi	sp,sp,16
    80000d56:	8082                	ret
  if(s < d && s + n > d){
    80000d58:	02061713          	slli	a4,a2,0x20
    80000d5c:	9301                	srli	a4,a4,0x20
    80000d5e:	00e587b3          	add	a5,a1,a4
    80000d62:	fcf578e3          	bgeu	a0,a5,80000d32 <memmove+0xa>
    d += n;
    80000d66:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000d68:	fff6069b          	addiw	a3,a2,-1
    80000d6c:	d27d                	beqz	a2,80000d52 <memmove+0x2a>
    80000d6e:	02069613          	slli	a2,a3,0x20
    80000d72:	9201                	srli	a2,a2,0x20
    80000d74:	fff64613          	not	a2,a2
    80000d78:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000d7a:	17fd                	addi	a5,a5,-1
    80000d7c:	177d                	addi	a4,a4,-1
    80000d7e:	0007c683          	lbu	a3,0(a5)
    80000d82:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000d86:	fef61ae3          	bne	a2,a5,80000d7a <memmove+0x52>
    80000d8a:	b7e1                	j	80000d52 <memmove+0x2a>

0000000080000d8c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d8c:	1141                	addi	sp,sp,-16
    80000d8e:	e406                	sd	ra,8(sp)
    80000d90:	e022                	sd	s0,0(sp)
    80000d92:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d94:	00000097          	auipc	ra,0x0
    80000d98:	f94080e7          	jalr	-108(ra) # 80000d28 <memmove>
}
    80000d9c:	60a2                	ld	ra,8(sp)
    80000d9e:	6402                	ld	s0,0(sp)
    80000da0:	0141                	addi	sp,sp,16
    80000da2:	8082                	ret

0000000080000da4 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000da4:	1141                	addi	sp,sp,-16
    80000da6:	e422                	sd	s0,8(sp)
    80000da8:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000daa:	ce11                	beqz	a2,80000dc6 <strncmp+0x22>
    80000dac:	00054783          	lbu	a5,0(a0)
    80000db0:	cf89                	beqz	a5,80000dca <strncmp+0x26>
    80000db2:	0005c703          	lbu	a4,0(a1)
    80000db6:	00f71a63          	bne	a4,a5,80000dca <strncmp+0x26>
    n--, p++, q++;
    80000dba:	367d                	addiw	a2,a2,-1
    80000dbc:	0505                	addi	a0,a0,1
    80000dbe:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dc0:	f675                	bnez	a2,80000dac <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dc2:	4501                	li	a0,0
    80000dc4:	a809                	j	80000dd6 <strncmp+0x32>
    80000dc6:	4501                	li	a0,0
    80000dc8:	a039                	j	80000dd6 <strncmp+0x32>
  if(n == 0)
    80000dca:	ca09                	beqz	a2,80000ddc <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dcc:	00054503          	lbu	a0,0(a0)
    80000dd0:	0005c783          	lbu	a5,0(a1)
    80000dd4:	9d1d                	subw	a0,a0,a5
}
    80000dd6:	6422                	ld	s0,8(sp)
    80000dd8:	0141                	addi	sp,sp,16
    80000dda:	8082                	ret
    return 0;
    80000ddc:	4501                	li	a0,0
    80000dde:	bfe5                	j	80000dd6 <strncmp+0x32>

0000000080000de0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000de0:	1141                	addi	sp,sp,-16
    80000de2:	e422                	sd	s0,8(sp)
    80000de4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000de6:	872a                	mv	a4,a0
    80000de8:	8832                	mv	a6,a2
    80000dea:	367d                	addiw	a2,a2,-1
    80000dec:	01005963          	blez	a6,80000dfe <strncpy+0x1e>
    80000df0:	0705                	addi	a4,a4,1
    80000df2:	0005c783          	lbu	a5,0(a1)
    80000df6:	fef70fa3          	sb	a5,-1(a4)
    80000dfa:	0585                	addi	a1,a1,1
    80000dfc:	f7f5                	bnez	a5,80000de8 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000dfe:	86ba                	mv	a3,a4
    80000e00:	00c05c63          	blez	a2,80000e18 <strncpy+0x38>
    *s++ = 0;
    80000e04:	0685                	addi	a3,a3,1
    80000e06:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e0a:	fff6c793          	not	a5,a3
    80000e0e:	9fb9                	addw	a5,a5,a4
    80000e10:	010787bb          	addw	a5,a5,a6
    80000e14:	fef048e3          	bgtz	a5,80000e04 <strncpy+0x24>
  return os;
}
    80000e18:	6422                	ld	s0,8(sp)
    80000e1a:	0141                	addi	sp,sp,16
    80000e1c:	8082                	ret

0000000080000e1e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e1e:	1141                	addi	sp,sp,-16
    80000e20:	e422                	sd	s0,8(sp)
    80000e22:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e24:	02c05363          	blez	a2,80000e4a <safestrcpy+0x2c>
    80000e28:	fff6069b          	addiw	a3,a2,-1
    80000e2c:	1682                	slli	a3,a3,0x20
    80000e2e:	9281                	srli	a3,a3,0x20
    80000e30:	96ae                	add	a3,a3,a1
    80000e32:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e34:	00d58963          	beq	a1,a3,80000e46 <safestrcpy+0x28>
    80000e38:	0585                	addi	a1,a1,1
    80000e3a:	0785                	addi	a5,a5,1
    80000e3c:	fff5c703          	lbu	a4,-1(a1)
    80000e40:	fee78fa3          	sb	a4,-1(a5)
    80000e44:	fb65                	bnez	a4,80000e34 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e46:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e4a:	6422                	ld	s0,8(sp)
    80000e4c:	0141                	addi	sp,sp,16
    80000e4e:	8082                	ret

0000000080000e50 <strlen>:

int
strlen(const char *s)
{
    80000e50:	1141                	addi	sp,sp,-16
    80000e52:	e422                	sd	s0,8(sp)
    80000e54:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e56:	00054783          	lbu	a5,0(a0)
    80000e5a:	cf91                	beqz	a5,80000e76 <strlen+0x26>
    80000e5c:	0505                	addi	a0,a0,1
    80000e5e:	87aa                	mv	a5,a0
    80000e60:	4685                	li	a3,1
    80000e62:	9e89                	subw	a3,a3,a0
    80000e64:	00f6853b          	addw	a0,a3,a5
    80000e68:	0785                	addi	a5,a5,1
    80000e6a:	fff7c703          	lbu	a4,-1(a5)
    80000e6e:	fb7d                	bnez	a4,80000e64 <strlen+0x14>
    ;
  return n;
}
    80000e70:	6422                	ld	s0,8(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e76:	4501                	li	a0,0
    80000e78:	bfe5                	j	80000e70 <strlen+0x20>

0000000080000e7a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e7a:	1141                	addi	sp,sp,-16
    80000e7c:	e406                	sd	ra,8(sp)
    80000e7e:	e022                	sd	s0,0(sp)
    80000e80:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e82:	00001097          	auipc	ra,0x1
    80000e86:	b42080e7          	jalr	-1214(ra) # 800019c4 <cpuid>
    userinit();      // first user process

    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e8a:	00009717          	auipc	a4,0x9
    80000e8e:	18e70713          	addi	a4,a4,398 # 8000a018 <started>
  if(cpuid() == 0){
    80000e92:	c139                	beqz	a0,80000ed8 <main+0x5e>
    while(started == 0)
    80000e94:	431c                	lw	a5,0(a4)
    80000e96:	2781                	sext.w	a5,a5
    80000e98:	dff5                	beqz	a5,80000e94 <main+0x1a>
      ;
    __sync_synchronize();
    80000e9a:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e9e:	00001097          	auipc	ra,0x1
    80000ea2:	b26080e7          	jalr	-1242(ra) # 800019c4 <cpuid>
    80000ea6:	85aa                	mv	a1,a0
    80000ea8:	00008517          	auipc	a0,0x8
    80000eac:	21050513          	addi	a0,a0,528 # 800090b8 <digits+0x78>
    80000eb0:	fffff097          	auipc	ra,0xfffff
    80000eb4:	6c4080e7          	jalr	1732(ra) # 80000574 <printf>
    kvminithart();    // turn on paging
    80000eb8:	00000097          	auipc	ra,0x0
    80000ebc:	0d8080e7          	jalr	216(ra) # 80000f90 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ec0:	00002097          	auipc	ra,0x2
    80000ec4:	390080e7          	jalr	912(ra) # 80003250 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec8:	00006097          	auipc	ra,0x6
    80000ecc:	c38080e7          	jalr	-968(ra) # 80006b00 <plicinithart>
  }

  scheduler();        
    80000ed0:	00001097          	auipc	ra,0x1
    80000ed4:	2aa080e7          	jalr	682(ra) # 8000217a <scheduler>
    consoleinit();
    80000ed8:	fffff097          	auipc	ra,0xfffff
    80000edc:	564080e7          	jalr	1380(ra) # 8000043c <consoleinit>
    printfinit();
    80000ee0:	00000097          	auipc	ra,0x0
    80000ee4:	874080e7          	jalr	-1932(ra) # 80000754 <printfinit>
    printf("\n");
    80000ee8:	00008517          	auipc	a0,0x8
    80000eec:	3c050513          	addi	a0,a0,960 # 800092a8 <digits+0x268>
    80000ef0:	fffff097          	auipc	ra,0xfffff
    80000ef4:	684080e7          	jalr	1668(ra) # 80000574 <printf>
    printf("xv6 kernel is booting\n");
    80000ef8:	00008517          	auipc	a0,0x8
    80000efc:	1a850513          	addi	a0,a0,424 # 800090a0 <digits+0x60>
    80000f00:	fffff097          	auipc	ra,0xfffff
    80000f04:	674080e7          	jalr	1652(ra) # 80000574 <printf>
    printf("\n");
    80000f08:	00008517          	auipc	a0,0x8
    80000f0c:	3a050513          	addi	a0,a0,928 # 800092a8 <digits+0x268>
    80000f10:	fffff097          	auipc	ra,0xfffff
    80000f14:	664080e7          	jalr	1636(ra) # 80000574 <printf>
    kinit();         // physical page allocator
    80000f18:	00000097          	auipc	ra,0x0
    80000f1c:	b7e080e7          	jalr	-1154(ra) # 80000a96 <kinit>
    kvminit();       // create kernel page table
    80000f20:	00000097          	auipc	ra,0x0
    80000f24:	310080e7          	jalr	784(ra) # 80001230 <kvminit>
    kvminithart();   // turn on paging
    80000f28:	00000097          	auipc	ra,0x0
    80000f2c:	068080e7          	jalr	104(ra) # 80000f90 <kvminithart>
    procinit();      // process table
    80000f30:	00001097          	auipc	ra,0x1
    80000f34:	9dc080e7          	jalr	-1572(ra) # 8000190c <procinit>
    trapinit();      // trap vectors
    80000f38:	00002097          	auipc	ra,0x2
    80000f3c:	2f0080e7          	jalr	752(ra) # 80003228 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f40:	00002097          	auipc	ra,0x2
    80000f44:	310080e7          	jalr	784(ra) # 80003250 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f48:	00006097          	auipc	ra,0x6
    80000f4c:	ba2080e7          	jalr	-1118(ra) # 80006aea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f50:	00006097          	auipc	ra,0x6
    80000f54:	bb0080e7          	jalr	-1104(ra) # 80006b00 <plicinithart>
    binit();         // buffer cache
    80000f58:	00003097          	auipc	ra,0x3
    80000f5c:	cf4080e7          	jalr	-780(ra) # 80003c4c <binit>
    iinit();         // inode cache
    80000f60:	00003097          	auipc	ra,0x3
    80000f64:	386080e7          	jalr	902(ra) # 800042e6 <iinit>
    fileinit();      // file table
    80000f68:	00004097          	auipc	ra,0x4
    80000f6c:	338080e7          	jalr	824(ra) # 800052a0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f70:	00006097          	auipc	ra,0x6
    80000f74:	cb8080e7          	jalr	-840(ra) # 80006c28 <virtio_disk_init>
    userinit();      // first user process
    80000f78:	00001097          	auipc	ra,0x1
    80000f7c:	ecc080e7          	jalr	-308(ra) # 80001e44 <userinit>
    __sync_synchronize();
    80000f80:	0ff0000f          	fence
    started = 1;
    80000f84:	4785                	li	a5,1
    80000f86:	00009717          	auipc	a4,0x9
    80000f8a:	08f72923          	sw	a5,146(a4) # 8000a018 <started>
    80000f8e:	b789                	j	80000ed0 <main+0x56>

0000000080000f90 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f90:	1141                	addi	sp,sp,-16
    80000f92:	e422                	sd	s0,8(sp)
    80000f94:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000f96:	00009797          	auipc	a5,0x9
    80000f9a:	08a7b783          	ld	a5,138(a5) # 8000a020 <kernel_pagetable>
    80000f9e:	83b1                	srli	a5,a5,0xc
    80000fa0:	577d                	li	a4,-1
    80000fa2:	177e                	slli	a4,a4,0x3f
    80000fa4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fa6:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000faa:	12000073          	sfence.vma
  sfence_vma();
}
    80000fae:	6422                	ld	s0,8(sp)
    80000fb0:	0141                	addi	sp,sp,16
    80000fb2:	8082                	ret

0000000080000fb4 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fb4:	7139                	addi	sp,sp,-64
    80000fb6:	fc06                	sd	ra,56(sp)
    80000fb8:	f822                	sd	s0,48(sp)
    80000fba:	f426                	sd	s1,40(sp)
    80000fbc:	f04a                	sd	s2,32(sp)
    80000fbe:	ec4e                	sd	s3,24(sp)
    80000fc0:	e852                	sd	s4,16(sp)
    80000fc2:	e456                	sd	s5,8(sp)
    80000fc4:	e05a                	sd	s6,0(sp)
    80000fc6:	0080                	addi	s0,sp,64
    80000fc8:	84aa                	mv	s1,a0
    80000fca:	89ae                	mv	s3,a1
    80000fcc:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fce:	57fd                	li	a5,-1
    80000fd0:	83e9                	srli	a5,a5,0x1a
    80000fd2:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fd4:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fd6:	04b7f263          	bgeu	a5,a1,8000101a <walk+0x66>
    panic("walk");
    80000fda:	00008517          	auipc	a0,0x8
    80000fde:	0f650513          	addi	a0,a0,246 # 800090d0 <digits+0x90>
    80000fe2:	fffff097          	auipc	ra,0xfffff
    80000fe6:	548080e7          	jalr	1352(ra) # 8000052a <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fea:	060a8663          	beqz	s5,80001056 <walk+0xa2>
    80000fee:	00000097          	auipc	ra,0x0
    80000ff2:	ae4080e7          	jalr	-1308(ra) # 80000ad2 <kalloc>
    80000ff6:	84aa                	mv	s1,a0
    80000ff8:	c529                	beqz	a0,80001042 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000ffa:	6605                	lui	a2,0x1
    80000ffc:	4581                	li	a1,0
    80000ffe:	00000097          	auipc	ra,0x0
    80001002:	cce080e7          	jalr	-818(ra) # 80000ccc <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001006:	00c4d793          	srli	a5,s1,0xc
    8000100a:	07aa                	slli	a5,a5,0xa
    8000100c:	0017e793          	ori	a5,a5,1
    80001010:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001014:	3a5d                	addiw	s4,s4,-9
    80001016:	036a0063          	beq	s4,s6,80001036 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000101a:	0149d933          	srl	s2,s3,s4
    8000101e:	1ff97913          	andi	s2,s2,511
    80001022:	090e                	slli	s2,s2,0x3
    80001024:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001026:	00093483          	ld	s1,0(s2)
    8000102a:	0014f793          	andi	a5,s1,1
    8000102e:	dfd5                	beqz	a5,80000fea <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001030:	80a9                	srli	s1,s1,0xa
    80001032:	04b2                	slli	s1,s1,0xc
    80001034:	b7c5                	j	80001014 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001036:	00c9d513          	srli	a0,s3,0xc
    8000103a:	1ff57513          	andi	a0,a0,511
    8000103e:	050e                	slli	a0,a0,0x3
    80001040:	9526                	add	a0,a0,s1
}
    80001042:	70e2                	ld	ra,56(sp)
    80001044:	7442                	ld	s0,48(sp)
    80001046:	74a2                	ld	s1,40(sp)
    80001048:	7902                	ld	s2,32(sp)
    8000104a:	69e2                	ld	s3,24(sp)
    8000104c:	6a42                	ld	s4,16(sp)
    8000104e:	6aa2                	ld	s5,8(sp)
    80001050:	6b02                	ld	s6,0(sp)
    80001052:	6121                	addi	sp,sp,64
    80001054:	8082                	ret
        return 0;
    80001056:	4501                	li	a0,0
    80001058:	b7ed                	j	80001042 <walk+0x8e>

000000008000105a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000105a:	57fd                	li	a5,-1
    8000105c:	83e9                	srli	a5,a5,0x1a
    8000105e:	00b7f463          	bgeu	a5,a1,80001066 <walkaddr+0xc>
    return 0;
    80001062:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001064:	8082                	ret
{
    80001066:	1141                	addi	sp,sp,-16
    80001068:	e406                	sd	ra,8(sp)
    8000106a:	e022                	sd	s0,0(sp)
    8000106c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000106e:	4601                	li	a2,0
    80001070:	00000097          	auipc	ra,0x0
    80001074:	f44080e7          	jalr	-188(ra) # 80000fb4 <walk>
  if(pte == 0)
    80001078:	c105                	beqz	a0,80001098 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000107a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000107c:	0117f693          	andi	a3,a5,17
    80001080:	4745                	li	a4,17
    return 0;
    80001082:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001084:	00e68663          	beq	a3,a4,80001090 <walkaddr+0x36>
}
    80001088:	60a2                	ld	ra,8(sp)
    8000108a:	6402                	ld	s0,0(sp)
    8000108c:	0141                	addi	sp,sp,16
    8000108e:	8082                	ret
  pa = PTE2PA(*pte);
    80001090:	00a7d513          	srli	a0,a5,0xa
    80001094:	0532                	slli	a0,a0,0xc
  return pa;
    80001096:	bfcd                	j	80001088 <walkaddr+0x2e>
    return 0;
    80001098:	4501                	li	a0,0
    8000109a:	b7fd                	j	80001088 <walkaddr+0x2e>

000000008000109c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000109c:	715d                	addi	sp,sp,-80
    8000109e:	e486                	sd	ra,72(sp)
    800010a0:	e0a2                	sd	s0,64(sp)
    800010a2:	fc26                	sd	s1,56(sp)
    800010a4:	f84a                	sd	s2,48(sp)
    800010a6:	f44e                	sd	s3,40(sp)
    800010a8:	f052                	sd	s4,32(sp)
    800010aa:	ec56                	sd	s5,24(sp)
    800010ac:	e85a                	sd	s6,16(sp)
    800010ae:	e45e                	sd	s7,8(sp)
    800010b0:	0880                	addi	s0,sp,80
    800010b2:	8aaa                	mv	s5,a0
    800010b4:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    800010b6:	777d                	lui	a4,0xfffff
    800010b8:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010bc:	167d                	addi	a2,a2,-1
    800010be:	00b609b3          	add	s3,a2,a1
    800010c2:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010c6:	893e                	mv	s2,a5
    800010c8:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010cc:	6b85                	lui	s7,0x1
    800010ce:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010d2:	4605                	li	a2,1
    800010d4:	85ca                	mv	a1,s2
    800010d6:	8556                	mv	a0,s5
    800010d8:	00000097          	auipc	ra,0x0
    800010dc:	edc080e7          	jalr	-292(ra) # 80000fb4 <walk>
    800010e0:	c51d                	beqz	a0,8000110e <mappages+0x72>
    if(*pte & PTE_V)
    800010e2:	611c                	ld	a5,0(a0)
    800010e4:	8b85                	andi	a5,a5,1
    800010e6:	ef81                	bnez	a5,800010fe <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010e8:	80b1                	srli	s1,s1,0xc
    800010ea:	04aa                	slli	s1,s1,0xa
    800010ec:	0164e4b3          	or	s1,s1,s6
    800010f0:	0014e493          	ori	s1,s1,1
    800010f4:	e104                	sd	s1,0(a0)
    if(a == last)
    800010f6:	03390863          	beq	s2,s3,80001126 <mappages+0x8a>
    a += PGSIZE;
    800010fa:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010fc:	bfc9                	j	800010ce <mappages+0x32>
      panic("remap");
    800010fe:	00008517          	auipc	a0,0x8
    80001102:	fda50513          	addi	a0,a0,-38 # 800090d8 <digits+0x98>
    80001106:	fffff097          	auipc	ra,0xfffff
    8000110a:	424080e7          	jalr	1060(ra) # 8000052a <panic>
      return -1;
    8000110e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001110:	60a6                	ld	ra,72(sp)
    80001112:	6406                	ld	s0,64(sp)
    80001114:	74e2                	ld	s1,56(sp)
    80001116:	7942                	ld	s2,48(sp)
    80001118:	79a2                	ld	s3,40(sp)
    8000111a:	7a02                	ld	s4,32(sp)
    8000111c:	6ae2                	ld	s5,24(sp)
    8000111e:	6b42                	ld	s6,16(sp)
    80001120:	6ba2                	ld	s7,8(sp)
    80001122:	6161                	addi	sp,sp,80
    80001124:	8082                	ret
  return 0;
    80001126:	4501                	li	a0,0
    80001128:	b7e5                	j	80001110 <mappages+0x74>

000000008000112a <kvmmap>:
{
    8000112a:	1141                	addi	sp,sp,-16
    8000112c:	e406                	sd	ra,8(sp)
    8000112e:	e022                	sd	s0,0(sp)
    80001130:	0800                	addi	s0,sp,16
    80001132:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001134:	86b2                	mv	a3,a2
    80001136:	863e                	mv	a2,a5
    80001138:	00000097          	auipc	ra,0x0
    8000113c:	f64080e7          	jalr	-156(ra) # 8000109c <mappages>
    80001140:	e509                	bnez	a0,8000114a <kvmmap+0x20>
}
    80001142:	60a2                	ld	ra,8(sp)
    80001144:	6402                	ld	s0,0(sp)
    80001146:	0141                	addi	sp,sp,16
    80001148:	8082                	ret
    panic("kvmmap");
    8000114a:	00008517          	auipc	a0,0x8
    8000114e:	f9650513          	addi	a0,a0,-106 # 800090e0 <digits+0xa0>
    80001152:	fffff097          	auipc	ra,0xfffff
    80001156:	3d8080e7          	jalr	984(ra) # 8000052a <panic>

000000008000115a <kvmmake>:
{
    8000115a:	1101                	addi	sp,sp,-32
    8000115c:	ec06                	sd	ra,24(sp)
    8000115e:	e822                	sd	s0,16(sp)
    80001160:	e426                	sd	s1,8(sp)
    80001162:	e04a                	sd	s2,0(sp)
    80001164:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	96c080e7          	jalr	-1684(ra) # 80000ad2 <kalloc>
    8000116e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001170:	6605                	lui	a2,0x1
    80001172:	4581                	li	a1,0
    80001174:	00000097          	auipc	ra,0x0
    80001178:	b58080e7          	jalr	-1192(ra) # 80000ccc <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000117c:	4719                	li	a4,6
    8000117e:	6685                	lui	a3,0x1
    80001180:	10000637          	lui	a2,0x10000
    80001184:	100005b7          	lui	a1,0x10000
    80001188:	8526                	mv	a0,s1
    8000118a:	00000097          	auipc	ra,0x0
    8000118e:	fa0080e7          	jalr	-96(ra) # 8000112a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001192:	4719                	li	a4,6
    80001194:	6685                	lui	a3,0x1
    80001196:	10001637          	lui	a2,0x10001
    8000119a:	100015b7          	lui	a1,0x10001
    8000119e:	8526                	mv	a0,s1
    800011a0:	00000097          	auipc	ra,0x0
    800011a4:	f8a080e7          	jalr	-118(ra) # 8000112a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011a8:	4719                	li	a4,6
    800011aa:	004006b7          	lui	a3,0x400
    800011ae:	0c000637          	lui	a2,0xc000
    800011b2:	0c0005b7          	lui	a1,0xc000
    800011b6:	8526                	mv	a0,s1
    800011b8:	00000097          	auipc	ra,0x0
    800011bc:	f72080e7          	jalr	-142(ra) # 8000112a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011c0:	00008917          	auipc	s2,0x8
    800011c4:	e4090913          	addi	s2,s2,-448 # 80009000 <etext>
    800011c8:	4729                	li	a4,10
    800011ca:	80008697          	auipc	a3,0x80008
    800011ce:	e3668693          	addi	a3,a3,-458 # 9000 <_entry-0x7fff7000>
    800011d2:	4605                	li	a2,1
    800011d4:	067e                	slli	a2,a2,0x1f
    800011d6:	85b2                	mv	a1,a2
    800011d8:	8526                	mv	a0,s1
    800011da:	00000097          	auipc	ra,0x0
    800011de:	f50080e7          	jalr	-176(ra) # 8000112a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011e2:	4719                	li	a4,6
    800011e4:	46c5                	li	a3,17
    800011e6:	06ee                	slli	a3,a3,0x1b
    800011e8:	412686b3          	sub	a3,a3,s2
    800011ec:	864a                	mv	a2,s2
    800011ee:	85ca                	mv	a1,s2
    800011f0:	8526                	mv	a0,s1
    800011f2:	00000097          	auipc	ra,0x0
    800011f6:	f38080e7          	jalr	-200(ra) # 8000112a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011fa:	4729                	li	a4,10
    800011fc:	6685                	lui	a3,0x1
    800011fe:	00007617          	auipc	a2,0x7
    80001202:	e0260613          	addi	a2,a2,-510 # 80008000 <_trampoline>
    80001206:	040005b7          	lui	a1,0x4000
    8000120a:	15fd                	addi	a1,a1,-1
    8000120c:	05b2                	slli	a1,a1,0xc
    8000120e:	8526                	mv	a0,s1
    80001210:	00000097          	auipc	ra,0x0
    80001214:	f1a080e7          	jalr	-230(ra) # 8000112a <kvmmap>
  proc_mapstacks(kpgtbl);
    80001218:	8526                	mv	a0,s1
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	650080e7          	jalr	1616(ra) # 8000186a <proc_mapstacks>
}
    80001222:	8526                	mv	a0,s1
    80001224:	60e2                	ld	ra,24(sp)
    80001226:	6442                	ld	s0,16(sp)
    80001228:	64a2                	ld	s1,8(sp)
    8000122a:	6902                	ld	s2,0(sp)
    8000122c:	6105                	addi	sp,sp,32
    8000122e:	8082                	ret

0000000080001230 <kvminit>:
{
    80001230:	1141                	addi	sp,sp,-16
    80001232:	e406                	sd	ra,8(sp)
    80001234:	e022                	sd	s0,0(sp)
    80001236:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001238:	00000097          	auipc	ra,0x0
    8000123c:	f22080e7          	jalr	-222(ra) # 8000115a <kvmmake>
    80001240:	00009797          	auipc	a5,0x9
    80001244:	dea7b023          	sd	a0,-544(a5) # 8000a020 <kernel_pagetable>
}
    80001248:	60a2                	ld	ra,8(sp)
    8000124a:	6402                	ld	s0,0(sp)
    8000124c:	0141                	addi	sp,sp,16
    8000124e:	8082                	ret

0000000080001250 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001250:	715d                	addi	sp,sp,-80
    80001252:	e486                	sd	ra,72(sp)
    80001254:	e0a2                	sd	s0,64(sp)
    80001256:	fc26                	sd	s1,56(sp)
    80001258:	f84a                	sd	s2,48(sp)
    8000125a:	f44e                	sd	s3,40(sp)
    8000125c:	f052                	sd	s4,32(sp)
    8000125e:	ec56                	sd	s5,24(sp)
    80001260:	e85a                	sd	s6,16(sp)
    80001262:	e45e                	sd	s7,8(sp)
    80001264:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001266:	03459793          	slli	a5,a1,0x34
    8000126a:	e795                	bnez	a5,80001296 <uvmunmap+0x46>
    8000126c:	8a2a                	mv	s4,a0
    8000126e:	892e                	mv	s2,a1
    80001270:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001272:	0632                	slli	a2,a2,0xc
    80001274:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001278:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000127a:	6b05                	lui	s6,0x1
    8000127c:	0735e263          	bltu	a1,s3,800012e0 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001280:	60a6                	ld	ra,72(sp)
    80001282:	6406                	ld	s0,64(sp)
    80001284:	74e2                	ld	s1,56(sp)
    80001286:	7942                	ld	s2,48(sp)
    80001288:	79a2                	ld	s3,40(sp)
    8000128a:	7a02                	ld	s4,32(sp)
    8000128c:	6ae2                	ld	s5,24(sp)
    8000128e:	6b42                	ld	s6,16(sp)
    80001290:	6ba2                	ld	s7,8(sp)
    80001292:	6161                	addi	sp,sp,80
    80001294:	8082                	ret
    panic("uvmunmap: not aligned");
    80001296:	00008517          	auipc	a0,0x8
    8000129a:	e5250513          	addi	a0,a0,-430 # 800090e8 <digits+0xa8>
    8000129e:	fffff097          	auipc	ra,0xfffff
    800012a2:	28c080e7          	jalr	652(ra) # 8000052a <panic>
      panic("uvmunmap: walk");
    800012a6:	00008517          	auipc	a0,0x8
    800012aa:	e5a50513          	addi	a0,a0,-422 # 80009100 <digits+0xc0>
    800012ae:	fffff097          	auipc	ra,0xfffff
    800012b2:	27c080e7          	jalr	636(ra) # 8000052a <panic>
      panic("uvmunmap: not mapped");
    800012b6:	00008517          	auipc	a0,0x8
    800012ba:	e5a50513          	addi	a0,a0,-422 # 80009110 <digits+0xd0>
    800012be:	fffff097          	auipc	ra,0xfffff
    800012c2:	26c080e7          	jalr	620(ra) # 8000052a <panic>
      panic("uvmunmap: not a leaf");
    800012c6:	00008517          	auipc	a0,0x8
    800012ca:	e6250513          	addi	a0,a0,-414 # 80009128 <digits+0xe8>
    800012ce:	fffff097          	auipc	ra,0xfffff
    800012d2:	25c080e7          	jalr	604(ra) # 8000052a <panic>
    *pte = 0;
    800012d6:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012da:	995a                	add	s2,s2,s6
    800012dc:	fb3972e3          	bgeu	s2,s3,80001280 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012e0:	4601                	li	a2,0
    800012e2:	85ca                	mv	a1,s2
    800012e4:	8552                	mv	a0,s4
    800012e6:	00000097          	auipc	ra,0x0
    800012ea:	cce080e7          	jalr	-818(ra) # 80000fb4 <walk>
    800012ee:	84aa                	mv	s1,a0
    800012f0:	d95d                	beqz	a0,800012a6 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800012f2:	6108                	ld	a0,0(a0)
    800012f4:	00157793          	andi	a5,a0,1
    800012f8:	dfdd                	beqz	a5,800012b6 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800012fa:	3ff57793          	andi	a5,a0,1023
    800012fe:	fd7784e3          	beq	a5,s7,800012c6 <uvmunmap+0x76>
    if(do_free){
    80001302:	fc0a8ae3          	beqz	s5,800012d6 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001306:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001308:	0532                	slli	a0,a0,0xc
    8000130a:	fffff097          	auipc	ra,0xfffff
    8000130e:	6cc080e7          	jalr	1740(ra) # 800009d6 <kfree>
    80001312:	b7d1                	j	800012d6 <uvmunmap+0x86>

0000000080001314 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001314:	1101                	addi	sp,sp,-32
    80001316:	ec06                	sd	ra,24(sp)
    80001318:	e822                	sd	s0,16(sp)
    8000131a:	e426                	sd	s1,8(sp)
    8000131c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000131e:	fffff097          	auipc	ra,0xfffff
    80001322:	7b4080e7          	jalr	1972(ra) # 80000ad2 <kalloc>
    80001326:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001328:	c519                	beqz	a0,80001336 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000132a:	6605                	lui	a2,0x1
    8000132c:	4581                	li	a1,0
    8000132e:	00000097          	auipc	ra,0x0
    80001332:	99e080e7          	jalr	-1634(ra) # 80000ccc <memset>
  return pagetable;
}
    80001336:	8526                	mv	a0,s1
    80001338:	60e2                	ld	ra,24(sp)
    8000133a:	6442                	ld	s0,16(sp)
    8000133c:	64a2                	ld	s1,8(sp)
    8000133e:	6105                	addi	sp,sp,32
    80001340:	8082                	ret

0000000080001342 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001342:	7179                	addi	sp,sp,-48
    80001344:	f406                	sd	ra,40(sp)
    80001346:	f022                	sd	s0,32(sp)
    80001348:	ec26                	sd	s1,24(sp)
    8000134a:	e84a                	sd	s2,16(sp)
    8000134c:	e44e                	sd	s3,8(sp)
    8000134e:	e052                	sd	s4,0(sp)
    80001350:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001352:	6785                	lui	a5,0x1
    80001354:	04f67863          	bgeu	a2,a5,800013a4 <uvminit+0x62>
    80001358:	8a2a                	mv	s4,a0
    8000135a:	89ae                	mv	s3,a1
    8000135c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000135e:	fffff097          	auipc	ra,0xfffff
    80001362:	774080e7          	jalr	1908(ra) # 80000ad2 <kalloc>
    80001366:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001368:	6605                	lui	a2,0x1
    8000136a:	4581                	li	a1,0
    8000136c:	00000097          	auipc	ra,0x0
    80001370:	960080e7          	jalr	-1696(ra) # 80000ccc <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001374:	4779                	li	a4,30
    80001376:	86ca                	mv	a3,s2
    80001378:	6605                	lui	a2,0x1
    8000137a:	4581                	li	a1,0
    8000137c:	8552                	mv	a0,s4
    8000137e:	00000097          	auipc	ra,0x0
    80001382:	d1e080e7          	jalr	-738(ra) # 8000109c <mappages>
  memmove(mem, src, sz);
    80001386:	8626                	mv	a2,s1
    80001388:	85ce                	mv	a1,s3
    8000138a:	854a                	mv	a0,s2
    8000138c:	00000097          	auipc	ra,0x0
    80001390:	99c080e7          	jalr	-1636(ra) # 80000d28 <memmove>
}
    80001394:	70a2                	ld	ra,40(sp)
    80001396:	7402                	ld	s0,32(sp)
    80001398:	64e2                	ld	s1,24(sp)
    8000139a:	6942                	ld	s2,16(sp)
    8000139c:	69a2                	ld	s3,8(sp)
    8000139e:	6a02                	ld	s4,0(sp)
    800013a0:	6145                	addi	sp,sp,48
    800013a2:	8082                	ret
    panic("inituvm: more than a page");
    800013a4:	00008517          	auipc	a0,0x8
    800013a8:	d9c50513          	addi	a0,a0,-612 # 80009140 <digits+0x100>
    800013ac:	fffff097          	auipc	ra,0xfffff
    800013b0:	17e080e7          	jalr	382(ra) # 8000052a <panic>

00000000800013b4 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013b4:	1101                	addi	sp,sp,-32
    800013b6:	ec06                	sd	ra,24(sp)
    800013b8:	e822                	sd	s0,16(sp)
    800013ba:	e426                	sd	s1,8(sp)
    800013bc:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013be:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013c0:	00b67d63          	bgeu	a2,a1,800013da <uvmdealloc+0x26>
    800013c4:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013c6:	6785                	lui	a5,0x1
    800013c8:	17fd                	addi	a5,a5,-1
    800013ca:	00f60733          	add	a4,a2,a5
    800013ce:	767d                	lui	a2,0xfffff
    800013d0:	8f71                	and	a4,a4,a2
    800013d2:	97ae                	add	a5,a5,a1
    800013d4:	8ff1                	and	a5,a5,a2
    800013d6:	00f76863          	bltu	a4,a5,800013e6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013da:	8526                	mv	a0,s1
    800013dc:	60e2                	ld	ra,24(sp)
    800013de:	6442                	ld	s0,16(sp)
    800013e0:	64a2                	ld	s1,8(sp)
    800013e2:	6105                	addi	sp,sp,32
    800013e4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013e6:	8f99                	sub	a5,a5,a4
    800013e8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013ea:	4685                	li	a3,1
    800013ec:	0007861b          	sext.w	a2,a5
    800013f0:	85ba                	mv	a1,a4
    800013f2:	00000097          	auipc	ra,0x0
    800013f6:	e5e080e7          	jalr	-418(ra) # 80001250 <uvmunmap>
    800013fa:	b7c5                	j	800013da <uvmdealloc+0x26>

00000000800013fc <uvmalloc>:
  if(newsz < oldsz)
    800013fc:	0ab66163          	bltu	a2,a1,8000149e <uvmalloc+0xa2>
{
    80001400:	7139                	addi	sp,sp,-64
    80001402:	fc06                	sd	ra,56(sp)
    80001404:	f822                	sd	s0,48(sp)
    80001406:	f426                	sd	s1,40(sp)
    80001408:	f04a                	sd	s2,32(sp)
    8000140a:	ec4e                	sd	s3,24(sp)
    8000140c:	e852                	sd	s4,16(sp)
    8000140e:	e456                	sd	s5,8(sp)
    80001410:	0080                	addi	s0,sp,64
    80001412:	8aaa                	mv	s5,a0
    80001414:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001416:	6985                	lui	s3,0x1
    80001418:	19fd                	addi	s3,s3,-1
    8000141a:	95ce                	add	a1,a1,s3
    8000141c:	79fd                	lui	s3,0xfffff
    8000141e:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001422:	08c9f063          	bgeu	s3,a2,800014a2 <uvmalloc+0xa6>
    80001426:	894e                	mv	s2,s3
    mem = kalloc();
    80001428:	fffff097          	auipc	ra,0xfffff
    8000142c:	6aa080e7          	jalr	1706(ra) # 80000ad2 <kalloc>
    80001430:	84aa                	mv	s1,a0
    if(mem == 0){
    80001432:	c51d                	beqz	a0,80001460 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001434:	6605                	lui	a2,0x1
    80001436:	4581                	li	a1,0
    80001438:	00000097          	auipc	ra,0x0
    8000143c:	894080e7          	jalr	-1900(ra) # 80000ccc <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001440:	4779                	li	a4,30
    80001442:	86a6                	mv	a3,s1
    80001444:	6605                	lui	a2,0x1
    80001446:	85ca                	mv	a1,s2
    80001448:	8556                	mv	a0,s5
    8000144a:	00000097          	auipc	ra,0x0
    8000144e:	c52080e7          	jalr	-942(ra) # 8000109c <mappages>
    80001452:	e905                	bnez	a0,80001482 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001454:	6785                	lui	a5,0x1
    80001456:	993e                	add	s2,s2,a5
    80001458:	fd4968e3          	bltu	s2,s4,80001428 <uvmalloc+0x2c>
  return newsz;
    8000145c:	8552                	mv	a0,s4
    8000145e:	a809                	j	80001470 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001460:	864e                	mv	a2,s3
    80001462:	85ca                	mv	a1,s2
    80001464:	8556                	mv	a0,s5
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	f4e080e7          	jalr	-178(ra) # 800013b4 <uvmdealloc>
      return 0;
    8000146e:	4501                	li	a0,0
}
    80001470:	70e2                	ld	ra,56(sp)
    80001472:	7442                	ld	s0,48(sp)
    80001474:	74a2                	ld	s1,40(sp)
    80001476:	7902                	ld	s2,32(sp)
    80001478:	69e2                	ld	s3,24(sp)
    8000147a:	6a42                	ld	s4,16(sp)
    8000147c:	6aa2                	ld	s5,8(sp)
    8000147e:	6121                	addi	sp,sp,64
    80001480:	8082                	ret
      kfree(mem);
    80001482:	8526                	mv	a0,s1
    80001484:	fffff097          	auipc	ra,0xfffff
    80001488:	552080e7          	jalr	1362(ra) # 800009d6 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000148c:	864e                	mv	a2,s3
    8000148e:	85ca                	mv	a1,s2
    80001490:	8556                	mv	a0,s5
    80001492:	00000097          	auipc	ra,0x0
    80001496:	f22080e7          	jalr	-222(ra) # 800013b4 <uvmdealloc>
      return 0;
    8000149a:	4501                	li	a0,0
    8000149c:	bfd1                	j	80001470 <uvmalloc+0x74>
    return oldsz;
    8000149e:	852e                	mv	a0,a1
}
    800014a0:	8082                	ret
  return newsz;
    800014a2:	8532                	mv	a0,a2
    800014a4:	b7f1                	j	80001470 <uvmalloc+0x74>

00000000800014a6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014a6:	7179                	addi	sp,sp,-48
    800014a8:	f406                	sd	ra,40(sp)
    800014aa:	f022                	sd	s0,32(sp)
    800014ac:	ec26                	sd	s1,24(sp)
    800014ae:	e84a                	sd	s2,16(sp)
    800014b0:	e44e                	sd	s3,8(sp)
    800014b2:	e052                	sd	s4,0(sp)
    800014b4:	1800                	addi	s0,sp,48
    800014b6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014b8:	84aa                	mv	s1,a0
    800014ba:	6905                	lui	s2,0x1
    800014bc:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014be:	4985                	li	s3,1
    800014c0:	a821                	j	800014d8 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014c2:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800014c4:	0532                	slli	a0,a0,0xc
    800014c6:	00000097          	auipc	ra,0x0
    800014ca:	fe0080e7          	jalr	-32(ra) # 800014a6 <freewalk>
      pagetable[i] = 0;
    800014ce:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014d2:	04a1                	addi	s1,s1,8
    800014d4:	03248163          	beq	s1,s2,800014f6 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800014d8:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014da:	00f57793          	andi	a5,a0,15
    800014de:	ff3782e3          	beq	a5,s3,800014c2 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014e2:	8905                	andi	a0,a0,1
    800014e4:	d57d                	beqz	a0,800014d2 <freewalk+0x2c>
      panic("freewalk: leaf");
    800014e6:	00008517          	auipc	a0,0x8
    800014ea:	c7a50513          	addi	a0,a0,-902 # 80009160 <digits+0x120>
    800014ee:	fffff097          	auipc	ra,0xfffff
    800014f2:	03c080e7          	jalr	60(ra) # 8000052a <panic>
    }
  }
  kfree((void*)pagetable);
    800014f6:	8552                	mv	a0,s4
    800014f8:	fffff097          	auipc	ra,0xfffff
    800014fc:	4de080e7          	jalr	1246(ra) # 800009d6 <kfree>
}
    80001500:	70a2                	ld	ra,40(sp)
    80001502:	7402                	ld	s0,32(sp)
    80001504:	64e2                	ld	s1,24(sp)
    80001506:	6942                	ld	s2,16(sp)
    80001508:	69a2                	ld	s3,8(sp)
    8000150a:	6a02                	ld	s4,0(sp)
    8000150c:	6145                	addi	sp,sp,48
    8000150e:	8082                	ret

0000000080001510 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001510:	1101                	addi	sp,sp,-32
    80001512:	ec06                	sd	ra,24(sp)
    80001514:	e822                	sd	s0,16(sp)
    80001516:	e426                	sd	s1,8(sp)
    80001518:	1000                	addi	s0,sp,32
    8000151a:	84aa                	mv	s1,a0
  if(sz > 0)
    8000151c:	e999                	bnez	a1,80001532 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000151e:	8526                	mv	a0,s1
    80001520:	00000097          	auipc	ra,0x0
    80001524:	f86080e7          	jalr	-122(ra) # 800014a6 <freewalk>
}
    80001528:	60e2                	ld	ra,24(sp)
    8000152a:	6442                	ld	s0,16(sp)
    8000152c:	64a2                	ld	s1,8(sp)
    8000152e:	6105                	addi	sp,sp,32
    80001530:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001532:	6605                	lui	a2,0x1
    80001534:	167d                	addi	a2,a2,-1
    80001536:	962e                	add	a2,a2,a1
    80001538:	4685                	li	a3,1
    8000153a:	8231                	srli	a2,a2,0xc
    8000153c:	4581                	li	a1,0
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	d12080e7          	jalr	-750(ra) # 80001250 <uvmunmap>
    80001546:	bfe1                	j	8000151e <uvmfree+0xe>

0000000080001548 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001548:	c679                	beqz	a2,80001616 <uvmcopy+0xce>
{
    8000154a:	715d                	addi	sp,sp,-80
    8000154c:	e486                	sd	ra,72(sp)
    8000154e:	e0a2                	sd	s0,64(sp)
    80001550:	fc26                	sd	s1,56(sp)
    80001552:	f84a                	sd	s2,48(sp)
    80001554:	f44e                	sd	s3,40(sp)
    80001556:	f052                	sd	s4,32(sp)
    80001558:	ec56                	sd	s5,24(sp)
    8000155a:	e85a                	sd	s6,16(sp)
    8000155c:	e45e                	sd	s7,8(sp)
    8000155e:	0880                	addi	s0,sp,80
    80001560:	8b2a                	mv	s6,a0
    80001562:	8aae                	mv	s5,a1
    80001564:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001566:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001568:	4601                	li	a2,0
    8000156a:	85ce                	mv	a1,s3
    8000156c:	855a                	mv	a0,s6
    8000156e:	00000097          	auipc	ra,0x0
    80001572:	a46080e7          	jalr	-1466(ra) # 80000fb4 <walk>
    80001576:	c531                	beqz	a0,800015c2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001578:	6118                	ld	a4,0(a0)
    8000157a:	00177793          	andi	a5,a4,1
    8000157e:	cbb1                	beqz	a5,800015d2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001580:	00a75593          	srli	a1,a4,0xa
    80001584:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001588:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000158c:	fffff097          	auipc	ra,0xfffff
    80001590:	546080e7          	jalr	1350(ra) # 80000ad2 <kalloc>
    80001594:	892a                	mv	s2,a0
    80001596:	c939                	beqz	a0,800015ec <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001598:	6605                	lui	a2,0x1
    8000159a:	85de                	mv	a1,s7
    8000159c:	fffff097          	auipc	ra,0xfffff
    800015a0:	78c080e7          	jalr	1932(ra) # 80000d28 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015a4:	8726                	mv	a4,s1
    800015a6:	86ca                	mv	a3,s2
    800015a8:	6605                	lui	a2,0x1
    800015aa:	85ce                	mv	a1,s3
    800015ac:	8556                	mv	a0,s5
    800015ae:	00000097          	auipc	ra,0x0
    800015b2:	aee080e7          	jalr	-1298(ra) # 8000109c <mappages>
    800015b6:	e515                	bnez	a0,800015e2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015b8:	6785                	lui	a5,0x1
    800015ba:	99be                	add	s3,s3,a5
    800015bc:	fb49e6e3          	bltu	s3,s4,80001568 <uvmcopy+0x20>
    800015c0:	a081                	j	80001600 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015c2:	00008517          	auipc	a0,0x8
    800015c6:	bae50513          	addi	a0,a0,-1106 # 80009170 <digits+0x130>
    800015ca:	fffff097          	auipc	ra,0xfffff
    800015ce:	f60080e7          	jalr	-160(ra) # 8000052a <panic>
      panic("uvmcopy: page not present");
    800015d2:	00008517          	auipc	a0,0x8
    800015d6:	bbe50513          	addi	a0,a0,-1090 # 80009190 <digits+0x150>
    800015da:	fffff097          	auipc	ra,0xfffff
    800015de:	f50080e7          	jalr	-176(ra) # 8000052a <panic>
      kfree(mem);
    800015e2:	854a                	mv	a0,s2
    800015e4:	fffff097          	auipc	ra,0xfffff
    800015e8:	3f2080e7          	jalr	1010(ra) # 800009d6 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800015ec:	4685                	li	a3,1
    800015ee:	00c9d613          	srli	a2,s3,0xc
    800015f2:	4581                	li	a1,0
    800015f4:	8556                	mv	a0,s5
    800015f6:	00000097          	auipc	ra,0x0
    800015fa:	c5a080e7          	jalr	-934(ra) # 80001250 <uvmunmap>
  return -1;
    800015fe:	557d                	li	a0,-1
}
    80001600:	60a6                	ld	ra,72(sp)
    80001602:	6406                	ld	s0,64(sp)
    80001604:	74e2                	ld	s1,56(sp)
    80001606:	7942                	ld	s2,48(sp)
    80001608:	79a2                	ld	s3,40(sp)
    8000160a:	7a02                	ld	s4,32(sp)
    8000160c:	6ae2                	ld	s5,24(sp)
    8000160e:	6b42                	ld	s6,16(sp)
    80001610:	6ba2                	ld	s7,8(sp)
    80001612:	6161                	addi	sp,sp,80
    80001614:	8082                	ret
  return 0;
    80001616:	4501                	li	a0,0
}
    80001618:	8082                	ret

000000008000161a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000161a:	1141                	addi	sp,sp,-16
    8000161c:	e406                	sd	ra,8(sp)
    8000161e:	e022                	sd	s0,0(sp)
    80001620:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001622:	4601                	li	a2,0
    80001624:	00000097          	auipc	ra,0x0
    80001628:	990080e7          	jalr	-1648(ra) # 80000fb4 <walk>
  if(pte == 0)
    8000162c:	c901                	beqz	a0,8000163c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000162e:	611c                	ld	a5,0(a0)
    80001630:	9bbd                	andi	a5,a5,-17
    80001632:	e11c                	sd	a5,0(a0)
}
    80001634:	60a2                	ld	ra,8(sp)
    80001636:	6402                	ld	s0,0(sp)
    80001638:	0141                	addi	sp,sp,16
    8000163a:	8082                	ret
    panic("uvmclear");
    8000163c:	00008517          	auipc	a0,0x8
    80001640:	b7450513          	addi	a0,a0,-1164 # 800091b0 <digits+0x170>
    80001644:	fffff097          	auipc	ra,0xfffff
    80001648:	ee6080e7          	jalr	-282(ra) # 8000052a <panic>

000000008000164c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000164c:	c6bd                	beqz	a3,800016ba <copyout+0x6e>
{
    8000164e:	715d                	addi	sp,sp,-80
    80001650:	e486                	sd	ra,72(sp)
    80001652:	e0a2                	sd	s0,64(sp)
    80001654:	fc26                	sd	s1,56(sp)
    80001656:	f84a                	sd	s2,48(sp)
    80001658:	f44e                	sd	s3,40(sp)
    8000165a:	f052                	sd	s4,32(sp)
    8000165c:	ec56                	sd	s5,24(sp)
    8000165e:	e85a                	sd	s6,16(sp)
    80001660:	e45e                	sd	s7,8(sp)
    80001662:	e062                	sd	s8,0(sp)
    80001664:	0880                	addi	s0,sp,80
    80001666:	8b2a                	mv	s6,a0
    80001668:	8c2e                	mv	s8,a1
    8000166a:	8a32                	mv	s4,a2
    8000166c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000166e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001670:	6a85                	lui	s5,0x1
    80001672:	a015                	j	80001696 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001674:	9562                	add	a0,a0,s8
    80001676:	0004861b          	sext.w	a2,s1
    8000167a:	85d2                	mv	a1,s4
    8000167c:	41250533          	sub	a0,a0,s2
    80001680:	fffff097          	auipc	ra,0xfffff
    80001684:	6a8080e7          	jalr	1704(ra) # 80000d28 <memmove>

    len -= n;
    80001688:	409989b3          	sub	s3,s3,s1
    src += n;
    8000168c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000168e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001692:	02098263          	beqz	s3,800016b6 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001696:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000169a:	85ca                	mv	a1,s2
    8000169c:	855a                	mv	a0,s6
    8000169e:	00000097          	auipc	ra,0x0
    800016a2:	9bc080e7          	jalr	-1604(ra) # 8000105a <walkaddr>
    if(pa0 == 0)
    800016a6:	cd01                	beqz	a0,800016be <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016a8:	418904b3          	sub	s1,s2,s8
    800016ac:	94d6                	add	s1,s1,s5
    if(n > len)
    800016ae:	fc99f3e3          	bgeu	s3,s1,80001674 <copyout+0x28>
    800016b2:	84ce                	mv	s1,s3
    800016b4:	b7c1                	j	80001674 <copyout+0x28>
  }
  return 0;
    800016b6:	4501                	li	a0,0
    800016b8:	a021                	j	800016c0 <copyout+0x74>
    800016ba:	4501                	li	a0,0
}
    800016bc:	8082                	ret
      return -1;
    800016be:	557d                	li	a0,-1
}
    800016c0:	60a6                	ld	ra,72(sp)
    800016c2:	6406                	ld	s0,64(sp)
    800016c4:	74e2                	ld	s1,56(sp)
    800016c6:	7942                	ld	s2,48(sp)
    800016c8:	79a2                	ld	s3,40(sp)
    800016ca:	7a02                	ld	s4,32(sp)
    800016cc:	6ae2                	ld	s5,24(sp)
    800016ce:	6b42                	ld	s6,16(sp)
    800016d0:	6ba2                	ld	s7,8(sp)
    800016d2:	6c02                	ld	s8,0(sp)
    800016d4:	6161                	addi	sp,sp,80
    800016d6:	8082                	ret

00000000800016d8 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016d8:	caa5                	beqz	a3,80001748 <copyin+0x70>
{
    800016da:	715d                	addi	sp,sp,-80
    800016dc:	e486                	sd	ra,72(sp)
    800016de:	e0a2                	sd	s0,64(sp)
    800016e0:	fc26                	sd	s1,56(sp)
    800016e2:	f84a                	sd	s2,48(sp)
    800016e4:	f44e                	sd	s3,40(sp)
    800016e6:	f052                	sd	s4,32(sp)
    800016e8:	ec56                	sd	s5,24(sp)
    800016ea:	e85a                	sd	s6,16(sp)
    800016ec:	e45e                	sd	s7,8(sp)
    800016ee:	e062                	sd	s8,0(sp)
    800016f0:	0880                	addi	s0,sp,80
    800016f2:	8b2a                	mv	s6,a0
    800016f4:	8a2e                	mv	s4,a1
    800016f6:	8c32                	mv	s8,a2
    800016f8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800016fa:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016fc:	6a85                	lui	s5,0x1
    800016fe:	a01d                	j	80001724 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001700:	018505b3          	add	a1,a0,s8
    80001704:	0004861b          	sext.w	a2,s1
    80001708:	412585b3          	sub	a1,a1,s2
    8000170c:	8552                	mv	a0,s4
    8000170e:	fffff097          	auipc	ra,0xfffff
    80001712:	61a080e7          	jalr	1562(ra) # 80000d28 <memmove>

    len -= n;
    80001716:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000171a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000171c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001720:	02098263          	beqz	s3,80001744 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001724:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001728:	85ca                	mv	a1,s2
    8000172a:	855a                	mv	a0,s6
    8000172c:	00000097          	auipc	ra,0x0
    80001730:	92e080e7          	jalr	-1746(ra) # 8000105a <walkaddr>
    if(pa0 == 0)
    80001734:	cd01                	beqz	a0,8000174c <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001736:	418904b3          	sub	s1,s2,s8
    8000173a:	94d6                	add	s1,s1,s5
    if(n > len)
    8000173c:	fc99f2e3          	bgeu	s3,s1,80001700 <copyin+0x28>
    80001740:	84ce                	mv	s1,s3
    80001742:	bf7d                	j	80001700 <copyin+0x28>
  }
  return 0;
    80001744:	4501                	li	a0,0
    80001746:	a021                	j	8000174e <copyin+0x76>
    80001748:	4501                	li	a0,0
}
    8000174a:	8082                	ret
      return -1;
    8000174c:	557d                	li	a0,-1
}
    8000174e:	60a6                	ld	ra,72(sp)
    80001750:	6406                	ld	s0,64(sp)
    80001752:	74e2                	ld	s1,56(sp)
    80001754:	7942                	ld	s2,48(sp)
    80001756:	79a2                	ld	s3,40(sp)
    80001758:	7a02                	ld	s4,32(sp)
    8000175a:	6ae2                	ld	s5,24(sp)
    8000175c:	6b42                	ld	s6,16(sp)
    8000175e:	6ba2                	ld	s7,8(sp)
    80001760:	6c02                	ld	s8,0(sp)
    80001762:	6161                	addi	sp,sp,80
    80001764:	8082                	ret

0000000080001766 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001766:	c6c5                	beqz	a3,8000180e <copyinstr+0xa8>
{
    80001768:	715d                	addi	sp,sp,-80
    8000176a:	e486                	sd	ra,72(sp)
    8000176c:	e0a2                	sd	s0,64(sp)
    8000176e:	fc26                	sd	s1,56(sp)
    80001770:	f84a                	sd	s2,48(sp)
    80001772:	f44e                	sd	s3,40(sp)
    80001774:	f052                	sd	s4,32(sp)
    80001776:	ec56                	sd	s5,24(sp)
    80001778:	e85a                	sd	s6,16(sp)
    8000177a:	e45e                	sd	s7,8(sp)
    8000177c:	0880                	addi	s0,sp,80
    8000177e:	8a2a                	mv	s4,a0
    80001780:	8b2e                	mv	s6,a1
    80001782:	8bb2                	mv	s7,a2
    80001784:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001786:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001788:	6985                	lui	s3,0x1
    8000178a:	a035                	j	800017b6 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000178c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001790:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001792:	0017b793          	seqz	a5,a5
    80001796:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000179a:	60a6                	ld	ra,72(sp)
    8000179c:	6406                	ld	s0,64(sp)
    8000179e:	74e2                	ld	s1,56(sp)
    800017a0:	7942                	ld	s2,48(sp)
    800017a2:	79a2                	ld	s3,40(sp)
    800017a4:	7a02                	ld	s4,32(sp)
    800017a6:	6ae2                	ld	s5,24(sp)
    800017a8:	6b42                	ld	s6,16(sp)
    800017aa:	6ba2                	ld	s7,8(sp)
    800017ac:	6161                	addi	sp,sp,80
    800017ae:	8082                	ret
    srcva = va0 + PGSIZE;
    800017b0:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017b4:	c8a9                	beqz	s1,80001806 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800017b6:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017ba:	85ca                	mv	a1,s2
    800017bc:	8552                	mv	a0,s4
    800017be:	00000097          	auipc	ra,0x0
    800017c2:	89c080e7          	jalr	-1892(ra) # 8000105a <walkaddr>
    if(pa0 == 0)
    800017c6:	c131                	beqz	a0,8000180a <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800017c8:	41790833          	sub	a6,s2,s7
    800017cc:	984e                	add	a6,a6,s3
    if(n > max)
    800017ce:	0104f363          	bgeu	s1,a6,800017d4 <copyinstr+0x6e>
    800017d2:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017d4:	955e                	add	a0,a0,s7
    800017d6:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017da:	fc080be3          	beqz	a6,800017b0 <copyinstr+0x4a>
    800017de:	985a                	add	a6,a6,s6
    800017e0:	87da                	mv	a5,s6
      if(*p == '\0'){
    800017e2:	41650633          	sub	a2,a0,s6
    800017e6:	14fd                	addi	s1,s1,-1
    800017e8:	9b26                	add	s6,s6,s1
    800017ea:	00f60733          	add	a4,a2,a5
    800017ee:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ff98000>
    800017f2:	df49                	beqz	a4,8000178c <copyinstr+0x26>
        *dst = *p;
    800017f4:	00e78023          	sb	a4,0(a5)
      --max;
    800017f8:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800017fc:	0785                	addi	a5,a5,1
    while(n > 0){
    800017fe:	ff0796e3          	bne	a5,a6,800017ea <copyinstr+0x84>
      dst++;
    80001802:	8b42                	mv	s6,a6
    80001804:	b775                	j	800017b0 <copyinstr+0x4a>
    80001806:	4781                	li	a5,0
    80001808:	b769                	j	80001792 <copyinstr+0x2c>
      return -1;
    8000180a:	557d                	li	a0,-1
    8000180c:	b779                	j	8000179a <copyinstr+0x34>
  int got_null = 0;
    8000180e:	4781                	li	a5,0
  if(got_null){
    80001810:	0017b793          	seqz	a5,a5
    80001814:	40f00533          	neg	a0,a5
}
    80001818:	8082                	ret

000000008000181a <freethread>:
// free a thread structure and the data hanging from it,
// including user pages.
// t->lock must be held.
static void
freethread(struct thread *t)
{
    8000181a:	1101                	addi	sp,sp,-32
    8000181c:	ec06                	sd	ra,24(sp)
    8000181e:	e822                	sd	s0,16(sp)
    80001820:	e426                	sd	s1,8(sp)
    80001822:	1000                	addi	s0,sp,32
    80001824:	84aa                	mv	s1,a0
  if(t->kstack && t!=t->proc_parent->threads)
    80001826:	7908                	ld	a0,48(a0)
    80001828:	c911                	beqz	a0,8000183c <freethread+0x22>
    8000182a:	749c                	ld	a5,40(s1)
    8000182c:	02878793          	addi	a5,a5,40
    80001830:	00f48663          	beq	s1,a5,8000183c <freethread+0x22>
    kfree((void*)t->kstack);
    80001834:	fffff097          	auipc	ra,0xfffff
    80001838:	1a2080e7          	jalr	418(ra) # 800009d6 <kfree>
  t->trapframe = 0;
    8000183c:	0204bc23          	sd	zero,56(s1)
  t->tid = 0;
    80001840:	0004ac23          	sw	zero,24(s1)
  t->thread_parent = 0;
    80001844:	0204b023          	sd	zero,32(s1)
  t->proc_parent = 0;
    80001848:	0204b423          	sd	zero,40(s1)
  t->name[0] = 0;
    8000184c:	1c048823          	sb	zero,464(s1)
  t->chan = 0;
    80001850:	0004b423          	sd	zero,8(s1)
  t->killed = 0;
    80001854:	0004a823          	sw	zero,16(s1)
  t->xstate = 0;
    80001858:	0004aa23          	sw	zero,20(s1)
  t->state = UNUSED;
    8000185c:	0004a023          	sw	zero,0(s1)
}
    80001860:	60e2                	ld	ra,24(sp)
    80001862:	6442                	ld	s0,16(sp)
    80001864:	64a2                	ld	s1,8(sp)
    80001866:	6105                	addi	sp,sp,32
    80001868:	8082                	ret

000000008000186a <proc_mapstacks>:
proc_mapstacks(pagetable_t kpgtbl) {
    8000186a:	715d                	addi	sp,sp,-80
    8000186c:	e486                	sd	ra,72(sp)
    8000186e:	e0a2                	sd	s0,64(sp)
    80001870:	fc26                	sd	s1,56(sp)
    80001872:	f84a                	sd	s2,48(sp)
    80001874:	f44e                	sd	s3,40(sp)
    80001876:	f052                	sd	s4,32(sp)
    80001878:	ec56                	sd	s5,24(sp)
    8000187a:	e85a                	sd	s6,16(sp)
    8000187c:	e45e                	sd	s7,8(sp)
    8000187e:	e062                	sd	s8,0(sp)
    80001880:	0880                	addi	s0,sp,80
    80001882:	89aa                	mv	s3,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80001884:	00011497          	auipc	s1,0x11
    80001888:	ed448493          	addi	s1,s1,-300 # 80012758 <proc>
    uint64 va = KSTACK((int) (p - proc));
    8000188c:	8c26                	mv	s8,s1
    8000188e:	00007b97          	auipc	s7,0x7
    80001892:	772b8b93          	addi	s7,s7,1906 # 80009000 <etext>
    80001896:	04000937          	lui	s2,0x4000
    8000189a:	197d                	addi	s2,s2,-1
    8000189c:	0932                	slli	s2,s2,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000189e:	6a05                	lui	s4,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    800018a0:	178a0b13          	addi	s6,s4,376 # 1178 <_entry-0x7fffee88>
    800018a4:	00057a97          	auipc	s5,0x57
    800018a8:	cb4a8a93          	addi	s5,s5,-844 # 80058558 <tickslock>
    char *pa = kalloc();
    800018ac:	fffff097          	auipc	ra,0xfffff
    800018b0:	226080e7          	jalr	550(ra) # 80000ad2 <kalloc>
    800018b4:	862a                	mv	a2,a0
    if(pa == 0)
    800018b6:	c139                	beqz	a0,800018fc <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    800018b8:	418485b3          	sub	a1,s1,s8
    800018bc:	858d                	srai	a1,a1,0x3
    800018be:	000bb783          	ld	a5,0(s7)
    800018c2:	02f585b3          	mul	a1,a1,a5
    800018c6:	2585                	addiw	a1,a1,1
    800018c8:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800018cc:	4719                	li	a4,6
    800018ce:	86d2                	mv	a3,s4
    800018d0:	40b905b3          	sub	a1,s2,a1
    800018d4:	854e                	mv	a0,s3
    800018d6:	00000097          	auipc	ra,0x0
    800018da:	854080e7          	jalr	-1964(ra) # 8000112a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018de:	94da                	add	s1,s1,s6
    800018e0:	fd5496e3          	bne	s1,s5,800018ac <proc_mapstacks+0x42>
}
    800018e4:	60a6                	ld	ra,72(sp)
    800018e6:	6406                	ld	s0,64(sp)
    800018e8:	74e2                	ld	s1,56(sp)
    800018ea:	7942                	ld	s2,48(sp)
    800018ec:	79a2                	ld	s3,40(sp)
    800018ee:	7a02                	ld	s4,32(sp)
    800018f0:	6ae2                	ld	s5,24(sp)
    800018f2:	6b42                	ld	s6,16(sp)
    800018f4:	6ba2                	ld	s7,8(sp)
    800018f6:	6c02                	ld	s8,0(sp)
    800018f8:	6161                	addi	sp,sp,80
    800018fa:	8082                	ret
      panic("kalloc");
    800018fc:	00008517          	auipc	a0,0x8
    80001900:	8c450513          	addi	a0,a0,-1852 # 800091c0 <digits+0x180>
    80001904:	fffff097          	auipc	ra,0xfffff
    80001908:	c26080e7          	jalr	-986(ra) # 8000052a <panic>

000000008000190c <procinit>:
{
    8000190c:	715d                	addi	sp,sp,-80
    8000190e:	e486                	sd	ra,72(sp)
    80001910:	e0a2                	sd	s0,64(sp)
    80001912:	fc26                	sd	s1,56(sp)
    80001914:	f84a                	sd	s2,48(sp)
    80001916:	f44e                	sd	s3,40(sp)
    80001918:	f052                	sd	s4,32(sp)
    8000191a:	ec56                	sd	s5,24(sp)
    8000191c:	e85a                	sd	s6,16(sp)
    8000191e:	e45e                	sd	s7,8(sp)
    80001920:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001922:	00008597          	auipc	a1,0x8
    80001926:	8a658593          	addi	a1,a1,-1882 # 800091c8 <digits+0x188>
    8000192a:	00011517          	auipc	a0,0x11
    8000192e:	97650513          	addi	a0,a0,-1674 # 800122a0 <pid_lock>
    80001932:	fffff097          	auipc	ra,0xfffff
    80001936:	200080e7          	jalr	512(ra) # 80000b32 <initlock>
  initlock(&wait_lock, "wait_lock");
    8000193a:	00008597          	auipc	a1,0x8
    8000193e:	89658593          	addi	a1,a1,-1898 # 800091d0 <digits+0x190>
    80001942:	00011517          	auipc	a0,0x11
    80001946:	97650513          	addi	a0,a0,-1674 # 800122b8 <wait_lock>
    8000194a:	fffff097          	auipc	ra,0xfffff
    8000194e:	1e8080e7          	jalr	488(ra) # 80000b32 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001952:	00011497          	auipc	s1,0x11
    80001956:	e0648493          	addi	s1,s1,-506 # 80012758 <proc>
      initlock(&p->lock, "proc");
    8000195a:	00008b97          	auipc	s7,0x8
    8000195e:	886b8b93          	addi	s7,s7,-1914 # 800091e0 <digits+0x1a0>
      p->threads->kstack = KSTACK((int) (p - proc)); // Initialize the first thread of each process
    80001962:	8b26                	mv	s6,s1
    80001964:	00007a97          	auipc	s5,0x7
    80001968:	69ca8a93          	addi	s5,s5,1692 # 80009000 <etext>
    8000196c:	04000937          	lui	s2,0x4000
    80001970:	197d                	addi	s2,s2,-1
    80001972:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001974:	6985                	lui	s3,0x1
    80001976:	17898993          	addi	s3,s3,376 # 1178 <_entry-0x7fffee88>
    8000197a:	00057a17          	auipc	s4,0x57
    8000197e:	bdea0a13          	addi	s4,s4,-1058 # 80058558 <tickslock>
      initlock(&p->lock, "proc");
    80001982:	85de                	mv	a1,s7
    80001984:	8526                	mv	a0,s1
    80001986:	fffff097          	auipc	ra,0xfffff
    8000198a:	1ac080e7          	jalr	428(ra) # 80000b32 <initlock>
      p->threads->kstack = KSTACK((int) (p - proc)); // Initialize the first thread of each process
    8000198e:	416487b3          	sub	a5,s1,s6
    80001992:	878d                	srai	a5,a5,0x3
    80001994:	000ab703          	ld	a4,0(s5)
    80001998:	02e787b3          	mul	a5,a5,a4
    8000199c:	2785                	addiw	a5,a5,1
    8000199e:	00d7979b          	slliw	a5,a5,0xd
    800019a2:	40f907b3          	sub	a5,s2,a5
    800019a6:	ecbc                	sd	a5,88(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800019a8:	94ce                	add	s1,s1,s3
    800019aa:	fd449ce3          	bne	s1,s4,80001982 <procinit+0x76>
}
    800019ae:	60a6                	ld	ra,72(sp)
    800019b0:	6406                	ld	s0,64(sp)
    800019b2:	74e2                	ld	s1,56(sp)
    800019b4:	7942                	ld	s2,48(sp)
    800019b6:	79a2                	ld	s3,40(sp)
    800019b8:	7a02                	ld	s4,32(sp)
    800019ba:	6ae2                	ld	s5,24(sp)
    800019bc:	6b42                	ld	s6,16(sp)
    800019be:	6ba2                	ld	s7,8(sp)
    800019c0:	6161                	addi	sp,sp,80
    800019c2:	8082                	ret

00000000800019c4 <cpuid>:
{
    800019c4:	1141                	addi	sp,sp,-16
    800019c6:	e422                	sd	s0,8(sp)
    800019c8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800019ca:	8512                	mv	a0,tp
}
    800019cc:	2501                	sext.w	a0,a0
    800019ce:	6422                	ld	s0,8(sp)
    800019d0:	0141                	addi	sp,sp,16
    800019d2:	8082                	ret

00000000800019d4 <mycpu>:
mycpu(void) {
    800019d4:	1141                	addi	sp,sp,-16
    800019d6:	e422                	sd	s0,8(sp)
    800019d8:	0800                	addi	s0,sp,16
    800019da:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    800019dc:	0007851b          	sext.w	a0,a5
    800019e0:	00451793          	slli	a5,a0,0x4
    800019e4:	97aa                	add	a5,a5,a0
    800019e6:	078e                	slli	a5,a5,0x3
}
    800019e8:	00011517          	auipc	a0,0x11
    800019ec:	8e850513          	addi	a0,a0,-1816 # 800122d0 <cpus>
    800019f0:	953e                	add	a0,a0,a5
    800019f2:	6422                	ld	s0,8(sp)
    800019f4:	0141                	addi	sp,sp,16
    800019f6:	8082                	ret

00000000800019f8 <myproc>:
myproc(void) {
    800019f8:	1101                	addi	sp,sp,-32
    800019fa:	ec06                	sd	ra,24(sp)
    800019fc:	e822                	sd	s0,16(sp)
    800019fe:	e426                	sd	s1,8(sp)
    80001a00:	1000                	addi	s0,sp,32
  push_off();
    80001a02:	fffff097          	auipc	ra,0xfffff
    80001a06:	174080e7          	jalr	372(ra) # 80000b76 <push_off>
    80001a0a:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001a0c:	0007871b          	sext.w	a4,a5
    80001a10:	00471793          	slli	a5,a4,0x4
    80001a14:	97ba                	add	a5,a5,a4
    80001a16:	078e                	slli	a5,a5,0x3
    80001a18:	00011717          	auipc	a4,0x11
    80001a1c:	88870713          	addi	a4,a4,-1912 # 800122a0 <pid_lock>
    80001a20:	97ba                	add	a5,a5,a4
    80001a22:	7b84                	ld	s1,48(a5)
  pop_off();
    80001a24:	fffff097          	auipc	ra,0xfffff
    80001a28:	1fa080e7          	jalr	506(ra) # 80000c1e <pop_off>
}
    80001a2c:	8526                	mv	a0,s1
    80001a2e:	60e2                	ld	ra,24(sp)
    80001a30:	6442                	ld	s0,16(sp)
    80001a32:	64a2                	ld	s1,8(sp)
    80001a34:	6105                	addi	sp,sp,32
    80001a36:	8082                	ret

0000000080001a38 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001a38:	1141                	addi	sp,sp,-16
    80001a3a:	e406                	sd	ra,8(sp)
    80001a3c:	e022                	sd	s0,0(sp)
    80001a3e:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001a40:	00000097          	auipc	ra,0x0
    80001a44:	fb8080e7          	jalr	-72(ra) # 800019f8 <myproc>
    80001a48:	fffff097          	auipc	ra,0xfffff
    80001a4c:	23c080e7          	jalr	572(ra) # 80000c84 <release>

  if (first) {
    80001a50:	00008797          	auipc	a5,0x8
    80001a54:	f007a783          	lw	a5,-256(a5) # 80009950 <first.1>
    80001a58:	e38d                	bnez	a5,80001a7a <forkret+0x42>
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }
  printf("debug: finishing forkret\n");
    80001a5a:	00007517          	auipc	a0,0x7
    80001a5e:	78e50513          	addi	a0,a0,1934 # 800091e8 <digits+0x1a8>
    80001a62:	fffff097          	auipc	ra,0xfffff
    80001a66:	b12080e7          	jalr	-1262(ra) # 80000574 <printf>

  usertrapret();
    80001a6a:	00001097          	auipc	ra,0x1
    80001a6e:	7fe080e7          	jalr	2046(ra) # 80003268 <usertrapret>

}
    80001a72:	60a2                	ld	ra,8(sp)
    80001a74:	6402                	ld	s0,0(sp)
    80001a76:	0141                	addi	sp,sp,16
    80001a78:	8082                	ret
    first = 0;
    80001a7a:	00008797          	auipc	a5,0x8
    80001a7e:	ec07ab23          	sw	zero,-298(a5) # 80009950 <first.1>
    fsinit(ROOTDEV);
    80001a82:	4505                	li	a0,1
    80001a84:	00002097          	auipc	ra,0x2
    80001a88:	7e2080e7          	jalr	2018(ra) # 80004266 <fsinit>
    80001a8c:	b7f9                	j	80001a5a <forkret+0x22>

0000000080001a8e <mythread>:
mythread(void) {
    80001a8e:	1101                	addi	sp,sp,-32
    80001a90:	ec06                	sd	ra,24(sp)
    80001a92:	e822                	sd	s0,16(sp)
    80001a94:	e426                	sd	s1,8(sp)
    80001a96:	1000                	addi	s0,sp,32
  push_off();
    80001a98:	fffff097          	auipc	ra,0xfffff
    80001a9c:	0de080e7          	jalr	222(ra) # 80000b76 <push_off>
    80001aa0:	8792                	mv	a5,tp
  struct thread *t = c->thread;
    80001aa2:	0007871b          	sext.w	a4,a5
    80001aa6:	00471793          	slli	a5,a4,0x4
    80001aaa:	97ba                	add	a5,a5,a4
    80001aac:	078e                	slli	a5,a5,0x3
    80001aae:	00010717          	auipc	a4,0x10
    80001ab2:	7f270713          	addi	a4,a4,2034 # 800122a0 <pid_lock>
    80001ab6:	97ba                	add	a5,a5,a4
    80001ab8:	7f84                	ld	s1,56(a5)
  pop_off();
    80001aba:	fffff097          	auipc	ra,0xfffff
    80001abe:	164080e7          	jalr	356(ra) # 80000c1e <pop_off>
}
    80001ac2:	8526                	mv	a0,s1
    80001ac4:	60e2                	ld	ra,24(sp)
    80001ac6:	6442                	ld	s0,16(sp)
    80001ac8:	64a2                	ld	s1,8(sp)
    80001aca:	6105                	addi	sp,sp,32
    80001acc:	8082                	ret

0000000080001ace <allocpid>:
allocpid() {
    80001ace:	1101                	addi	sp,sp,-32
    80001ad0:	ec06                	sd	ra,24(sp)
    80001ad2:	e822                	sd	s0,16(sp)
    80001ad4:	e426                	sd	s1,8(sp)
    80001ad6:	e04a                	sd	s2,0(sp)
    80001ad8:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001ada:	00010917          	auipc	s2,0x10
    80001ade:	7c690913          	addi	s2,s2,1990 # 800122a0 <pid_lock>
    80001ae2:	854a                	mv	a0,s2
    80001ae4:	fffff097          	auipc	ra,0xfffff
    80001ae8:	0e6080e7          	jalr	230(ra) # 80000bca <acquire>
  pid = nextpid;
    80001aec:	00008797          	auipc	a5,0x8
    80001af0:	e6c78793          	addi	a5,a5,-404 # 80009958 <nextpid>
    80001af4:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001af6:	0014871b          	addiw	a4,s1,1
    80001afa:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001afc:	854a                	mv	a0,s2
    80001afe:	fffff097          	auipc	ra,0xfffff
    80001b02:	186080e7          	jalr	390(ra) # 80000c84 <release>
}
    80001b06:	8526                	mv	a0,s1
    80001b08:	60e2                	ld	ra,24(sp)
    80001b0a:	6442                	ld	s0,16(sp)
    80001b0c:	64a2                	ld	s1,8(sp)
    80001b0e:	6902                	ld	s2,0(sp)
    80001b10:	6105                	addi	sp,sp,32
    80001b12:	8082                	ret

0000000080001b14 <alloctid>:
alloctid() {
    80001b14:	1101                	addi	sp,sp,-32
    80001b16:	ec06                	sd	ra,24(sp)
    80001b18:	e822                	sd	s0,16(sp)
    80001b1a:	e426                	sd	s1,8(sp)
    80001b1c:	e04a                	sd	s2,0(sp)
    80001b1e:	1000                	addi	s0,sp,32
  acquire(&tid_lock);
    80001b20:	00011917          	auipc	s2,0x11
    80001b24:	bf090913          	addi	s2,s2,-1040 # 80012710 <tid_lock>
    80001b28:	854a                	mv	a0,s2
    80001b2a:	fffff097          	auipc	ra,0xfffff
    80001b2e:	0a0080e7          	jalr	160(ra) # 80000bca <acquire>
  tid = nexttid;
    80001b32:	00008797          	auipc	a5,0x8
    80001b36:	e2278793          	addi	a5,a5,-478 # 80009954 <nexttid>
    80001b3a:	4384                	lw	s1,0(a5)
  nexttid = nexttid + 1;
    80001b3c:	0014871b          	addiw	a4,s1,1
    80001b40:	c398                	sw	a4,0(a5)
  release(&tid_lock);
    80001b42:	854a                	mv	a0,s2
    80001b44:	fffff097          	auipc	ra,0xfffff
    80001b48:	140080e7          	jalr	320(ra) # 80000c84 <release>
}
    80001b4c:	8526                	mv	a0,s1
    80001b4e:	60e2                	ld	ra,24(sp)
    80001b50:	6442                	ld	s0,16(sp)
    80001b52:	64a2                	ld	s1,8(sp)
    80001b54:	6902                	ld	s2,0(sp)
    80001b56:	6105                	addi	sp,sp,32
    80001b58:	8082                	ret

0000000080001b5a <proc_pagetable>:
{
    80001b5a:	1101                	addi	sp,sp,-32
    80001b5c:	ec06                	sd	ra,24(sp)
    80001b5e:	e822                	sd	s0,16(sp)
    80001b60:	e426                	sd	s1,8(sp)
    80001b62:	e04a                	sd	s2,0(sp)
    80001b64:	1000                	addi	s0,sp,32
    80001b66:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b68:	fffff097          	auipc	ra,0xfffff
    80001b6c:	7ac080e7          	jalr	1964(ra) # 80001314 <uvmcreate>
    80001b70:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b72:	c139                	beqz	a0,80001bb8 <proc_pagetable+0x5e>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b74:	4729                	li	a4,10
    80001b76:	00006697          	auipc	a3,0x6
    80001b7a:	48a68693          	addi	a3,a3,1162 # 80008000 <_trampoline>
    80001b7e:	6605                	lui	a2,0x1
    80001b80:	040005b7          	lui	a1,0x4000
    80001b84:	15fd                	addi	a1,a1,-1
    80001b86:	05b2                	slli	a1,a1,0xc
    80001b88:	fffff097          	auipc	ra,0xfffff
    80001b8c:	514080e7          	jalr	1300(ra) # 8000109c <mappages>
    80001b90:	02054b63          	bltz	a0,80001bc6 <proc_pagetable+0x6c>
              (uint64)(p->main_thread->trapframe), PTE_R | PTE_W) < 0){
    80001b94:	6505                	lui	a0,0x1
    80001b96:	954a                	add	a0,a0,s2
    80001b98:	f3053783          	ld	a5,-208(a0) # f30 <_entry-0x7ffff0d0>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b9c:	4719                	li	a4,6
    80001b9e:	7f94                	ld	a3,56(a5)
    80001ba0:	6605                	lui	a2,0x1
    80001ba2:	020005b7          	lui	a1,0x2000
    80001ba6:	15fd                	addi	a1,a1,-1
    80001ba8:	05b6                	slli	a1,a1,0xd
    80001baa:	8526                	mv	a0,s1
    80001bac:	fffff097          	auipc	ra,0xfffff
    80001bb0:	4f0080e7          	jalr	1264(ra) # 8000109c <mappages>
    80001bb4:	02054163          	bltz	a0,80001bd6 <proc_pagetable+0x7c>
}
    80001bb8:	8526                	mv	a0,s1
    80001bba:	60e2                	ld	ra,24(sp)
    80001bbc:	6442                	ld	s0,16(sp)
    80001bbe:	64a2                	ld	s1,8(sp)
    80001bc0:	6902                	ld	s2,0(sp)
    80001bc2:	6105                	addi	sp,sp,32
    80001bc4:	8082                	ret
    uvmfree(pagetable, 0);
    80001bc6:	4581                	li	a1,0
    80001bc8:	8526                	mv	a0,s1
    80001bca:	00000097          	auipc	ra,0x0
    80001bce:	946080e7          	jalr	-1722(ra) # 80001510 <uvmfree>
    return 0;
    80001bd2:	4481                	li	s1,0
    80001bd4:	b7d5                	j	80001bb8 <proc_pagetable+0x5e>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bd6:	4681                	li	a3,0
    80001bd8:	4605                	li	a2,1
    80001bda:	040005b7          	lui	a1,0x4000
    80001bde:	15fd                	addi	a1,a1,-1
    80001be0:	05b2                	slli	a1,a1,0xc
    80001be2:	8526                	mv	a0,s1
    80001be4:	fffff097          	auipc	ra,0xfffff
    80001be8:	66c080e7          	jalr	1644(ra) # 80001250 <uvmunmap>
    uvmfree(pagetable, 0);
    80001bec:	4581                	li	a1,0
    80001bee:	8526                	mv	a0,s1
    80001bf0:	00000097          	auipc	ra,0x0
    80001bf4:	920080e7          	jalr	-1760(ra) # 80001510 <uvmfree>
    return 0;
    80001bf8:	4481                	li	s1,0
    80001bfa:	bf7d                	j	80001bb8 <proc_pagetable+0x5e>

0000000080001bfc <proc_freepagetable>:
{
    80001bfc:	1101                	addi	sp,sp,-32
    80001bfe:	ec06                	sd	ra,24(sp)
    80001c00:	e822                	sd	s0,16(sp)
    80001c02:	e426                	sd	s1,8(sp)
    80001c04:	e04a                	sd	s2,0(sp)
    80001c06:	1000                	addi	s0,sp,32
    80001c08:	84aa                	mv	s1,a0
    80001c0a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c0c:	4681                	li	a3,0
    80001c0e:	4605                	li	a2,1
    80001c10:	040005b7          	lui	a1,0x4000
    80001c14:	15fd                	addi	a1,a1,-1
    80001c16:	05b2                	slli	a1,a1,0xc
    80001c18:	fffff097          	auipc	ra,0xfffff
    80001c1c:	638080e7          	jalr	1592(ra) # 80001250 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001c20:	4681                	li	a3,0
    80001c22:	4605                	li	a2,1
    80001c24:	020005b7          	lui	a1,0x2000
    80001c28:	15fd                	addi	a1,a1,-1
    80001c2a:	05b6                	slli	a1,a1,0xd
    80001c2c:	8526                	mv	a0,s1
    80001c2e:	fffff097          	auipc	ra,0xfffff
    80001c32:	622080e7          	jalr	1570(ra) # 80001250 <uvmunmap>
  uvmfree(pagetable, sz);
    80001c36:	85ca                	mv	a1,s2
    80001c38:	8526                	mv	a0,s1
    80001c3a:	00000097          	auipc	ra,0x0
    80001c3e:	8d6080e7          	jalr	-1834(ra) # 80001510 <uvmfree>
}
    80001c42:	60e2                	ld	ra,24(sp)
    80001c44:	6442                	ld	s0,16(sp)
    80001c46:	64a2                	ld	s1,8(sp)
    80001c48:	6902                	ld	s2,0(sp)
    80001c4a:	6105                	addi	sp,sp,32
    80001c4c:	8082                	ret

0000000080001c4e <freeproc>:
{
    80001c4e:	1101                	addi	sp,sp,-32
    80001c50:	ec06                	sd	ra,24(sp)
    80001c52:	e822                	sd	s0,16(sp)
    80001c54:	e426                	sd	s1,8(sp)
    80001c56:	1000                	addi	s0,sp,32
    80001c58:	84aa                	mv	s1,a0
  if(p->pagetable)
    80001c5a:	6785                	lui	a5,0x1
    80001c5c:	97aa                	add	a5,a5,a0
    80001c5e:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80001c62:	c909                	beqz	a0,80001c74 <freeproc+0x26>
    proc_freepagetable(p->pagetable, p->sz);
    80001c64:	6785                	lui	a5,0x1
    80001c66:	97a6                	add	a5,a5,s1
    80001c68:	f387b583          	ld	a1,-200(a5) # f38 <_entry-0x7ffff0c8>
    80001c6c:	00000097          	auipc	ra,0x0
    80001c70:	f90080e7          	jalr	-112(ra) # 80001bfc <proc_freepagetable>
  if(p->threads->trapframe)
    80001c74:	70a8                	ld	a0,96(s1)
    80001c76:	c509                	beqz	a0,80001c80 <freeproc+0x32>
    kfree((void*)p->threads->trapframe);
    80001c78:	fffff097          	auipc	ra,0xfffff
    80001c7c:	d5e080e7          	jalr	-674(ra) # 800009d6 <kfree>
  p->pagetable = 0;
    80001c80:	6785                	lui	a5,0x1
    80001c82:	97a6                	add	a5,a5,s1
    80001c84:	f407b023          	sd	zero,-192(a5) # f40 <_entry-0x7ffff0c0>
  p->sz = 0;
    80001c88:	f207bc23          	sd	zero,-200(a5)
  p->pid = 0;
    80001c8c:	0204a223          	sw	zero,36(s1)
  p->parent = 0;
    80001c90:	f207b423          	sd	zero,-216(a5)
  p->name[0] = 0;
    80001c94:	fc078823          	sb	zero,-48(a5)
  p->killed = 0;
    80001c98:	0004ae23          	sw	zero,28(s1)
  p->xstate = 0;
    80001c9c:	0204a023          	sw	zero,32(s1)
  p->state = UNUSED;
    80001ca0:	0004ac23          	sw	zero,24(s1)
}
    80001ca4:	60e2                	ld	ra,24(sp)
    80001ca6:	6442                	ld	s0,16(sp)
    80001ca8:	64a2                	ld	s1,8(sp)
    80001caa:	6105                	addi	sp,sp,32
    80001cac:	8082                	ret

0000000080001cae <allocproc>:
{
    80001cae:	7179                	addi	sp,sp,-48
    80001cb0:	f406                	sd	ra,40(sp)
    80001cb2:	f022                	sd	s0,32(sp)
    80001cb4:	ec26                	sd	s1,24(sp)
    80001cb6:	e84a                	sd	s2,16(sp)
    80001cb8:	e44e                	sd	s3,8(sp)
    80001cba:	e052                	sd	s4,0(sp)
    80001cbc:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cbe:	00011497          	auipc	s1,0x11
    80001cc2:	a9a48493          	addi	s1,s1,-1382 # 80012758 <proc>
    80001cc6:	6985                	lui	s3,0x1
    80001cc8:	17898993          	addi	s3,s3,376 # 1178 <_entry-0x7fffee88>
    80001ccc:	00057a17          	auipc	s4,0x57
    80001cd0:	88ca0a13          	addi	s4,s4,-1908 # 80058558 <tickslock>
    acquire(&p->lock);
    80001cd4:	8526                	mv	a0,s1
    80001cd6:	fffff097          	auipc	ra,0xfffff
    80001cda:	ef4080e7          	jalr	-268(ra) # 80000bca <acquire>
    if(p->state == UNUSED) {
    80001cde:	4c9c                	lw	a5,24(s1)
    80001ce0:	cb99                	beqz	a5,80001cf6 <allocproc+0x48>
      release(&p->lock);
    80001ce2:	8526                	mv	a0,s1
    80001ce4:	fffff097          	auipc	ra,0xfffff
    80001ce8:	fa0080e7          	jalr	-96(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cec:	94ce                	add	s1,s1,s3
    80001cee:	ff4493e3          	bne	s1,s4,80001cd4 <allocproc+0x26>
  return 0;
    80001cf2:	4481                	li	s1,0
    80001cf4:	a0fd                	j	80001de2 <allocproc+0x134>
  p->pid = allocpid();
    80001cf6:	00000097          	auipc	ra,0x0
    80001cfa:	dd8080e7          	jalr	-552(ra) # 80001ace <allocpid>
    80001cfe:	d0c8                	sw	a0,36(s1)
  p->state = USED;
    80001d00:	4785                	li	a5,1
    80001d02:	cc9c                	sw	a5,24(s1)
  p->pendingSignals = 0;
    80001d04:	6705                	lui	a4,0x1
    80001d06:	00e487b3          	add	a5,s1,a4
    80001d0a:	fe07a023          	sw	zero,-32(a5)
  p->signalMask = 0;
    80001d0e:	fe07a223          	sw	zero,-28(a5)
  p->stopped = 0;
    80001d12:	0e07a423          	sw	zero,232(a5)
  p->signal_mask_backup = 0;
    80001d16:	0e07a623          	sw	zero,236(a5)
  p->ignore_signals = 0;
    80001d1a:	0e07a823          	sw	zero,240(a5)
  for(int i = 0; i<32 ; i++)
    80001d1e:	fe870793          	addi	a5,a4,-24 # fe8 <_entry-0x7ffff018>
    80001d22:	97a6                	add	a5,a5,s1
    80001d24:	0e870713          	addi	a4,a4,232
    80001d28:	9726                	add	a4,a4,s1
    p->signalHandlers[i] = SIG_DFL;
    80001d2a:	0007b023          	sd	zero,0(a5)
  for(int i = 0; i<32 ; i++)
    80001d2e:	07a1                	addi	a5,a5,8
    80001d30:	fee79de3          	bne	a5,a4,80001d2a <allocproc+0x7c>
  memset(p->signalHandlers, SIG_DFL, sizeof(p->signalHandlers));
    80001d34:	6905                	lui	s2,0x1
    80001d36:	fe890513          	addi	a0,s2,-24 # fe8 <_entry-0x7ffff018>
    80001d3a:	10000613          	li	a2,256
    80001d3e:	4581                	li	a1,0
    80001d40:	9526                	add	a0,a0,s1
    80001d42:	fffff097          	auipc	ra,0xfffff
    80001d46:	f8a080e7          	jalr	-118(ra) # 80000ccc <memset>
  memset(p->maskHandlers, 0, sizeof(p->maskHandlers));
    80001d4a:	0f490513          	addi	a0,s2,244
    80001d4e:	08000613          	li	a2,128
    80001d52:	4581                	li	a1,0
    80001d54:	9526                	add	a0,a0,s1
    80001d56:	fffff097          	auipc	ra,0xfffff
    80001d5a:	f76080e7          	jalr	-138(ra) # 80000ccc <memset>
  p->main_thread = p->threads;
    80001d5e:	9926                	add	s2,s2,s1
    80001d60:	02848793          	addi	a5,s1,40
    80001d64:	f2f93823          	sd	a5,-208(s2)
  p->main_thread->tid = alloctid();
    80001d68:	00000097          	auipc	ra,0x0
    80001d6c:	dac080e7          	jalr	-596(ra) # 80001b14 <alloctid>
    80001d70:	c0a8                	sw	a0,64(s1)
  p->main_thread->state = USED;
    80001d72:	f3093783          	ld	a5,-208(s2)
    80001d76:	4705                	li	a4,1
    80001d78:	c398                	sw	a4,0(a5)
  p->main_thread->proc_parent = p;
    80001d7a:	f3093783          	ld	a5,-208(s2)
    80001d7e:	f784                	sd	s1,40(a5)
  if((p->main_thread->trapframe = (struct trapframe *)kalloc()) == 0){
    80001d80:	f3093983          	ld	s3,-208(s2)
    80001d84:	fffff097          	auipc	ra,0xfffff
    80001d88:	d4e080e7          	jalr	-690(ra) # 80000ad2 <kalloc>
    80001d8c:	892a                	mv	s2,a0
    80001d8e:	02a9bc23          	sd	a0,56(s3)
    80001d92:	c12d                	beqz	a0,80001df4 <allocproc+0x146>
  p->pagetable = proc_pagetable(p);
    80001d94:	8526                	mv	a0,s1
    80001d96:	00000097          	auipc	ra,0x0
    80001d9a:	dc4080e7          	jalr	-572(ra) # 80001b5a <proc_pagetable>
    80001d9e:	892a                	mv	s2,a0
    80001da0:	6785                	lui	a5,0x1
    80001da2:	97a6                	add	a5,a5,s1
    80001da4:	f4a7b023          	sd	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
  if(p->pagetable == 0){
    80001da8:	c935                	beqz	a0,80001e1c <allocproc+0x16e>
  memset(&p->main_thread->context, 0, sizeof(p->main_thread->context));
    80001daa:	6985                	lui	s3,0x1
    80001dac:	01348933          	add	s2,s1,s3
    80001db0:	f3093503          	ld	a0,-208(s2)
    80001db4:	07000613          	li	a2,112
    80001db8:	4581                	li	a1,0
    80001dba:	16050513          	addi	a0,a0,352
    80001dbe:	fffff097          	auipc	ra,0xfffff
    80001dc2:	f0e080e7          	jalr	-242(ra) # 80000ccc <memset>
  p->main_thread->context.ra = (uint64)forkret;
    80001dc6:	f3093783          	ld	a5,-208(s2)
    80001dca:	00000717          	auipc	a4,0x0
    80001dce:	c6e70713          	addi	a4,a4,-914 # 80001a38 <forkret>
    80001dd2:	16e7b023          	sd	a4,352(a5)
  p->main_thread->context.sp = p->main_thread->kstack + PGSIZE;
    80001dd6:	f3093703          	ld	a4,-208(s2)
    80001dda:	7b1c                	ld	a5,48(a4)
    80001ddc:	97ce                	add	a5,a5,s3
    80001dde:	16f73423          	sd	a5,360(a4)
}
    80001de2:	8526                	mv	a0,s1
    80001de4:	70a2                	ld	ra,40(sp)
    80001de6:	7402                	ld	s0,32(sp)
    80001de8:	64e2                	ld	s1,24(sp)
    80001dea:	6942                	ld	s2,16(sp)
    80001dec:	69a2                	ld	s3,8(sp)
    80001dee:	6a02                	ld	s4,0(sp)
    80001df0:	6145                	addi	sp,sp,48
    80001df2:	8082                	ret
    freeproc(p);
    80001df4:	8526                	mv	a0,s1
    80001df6:	00000097          	auipc	ra,0x0
    80001dfa:	e58080e7          	jalr	-424(ra) # 80001c4e <freeproc>
    freethread(p->main_thread);
    80001dfe:	6785                	lui	a5,0x1
    80001e00:	97a6                	add	a5,a5,s1
    80001e02:	f307b503          	ld	a0,-208(a5) # f30 <_entry-0x7ffff0d0>
    80001e06:	00000097          	auipc	ra,0x0
    80001e0a:	a14080e7          	jalr	-1516(ra) # 8000181a <freethread>
    release(&p->lock);
    80001e0e:	8526                	mv	a0,s1
    80001e10:	fffff097          	auipc	ra,0xfffff
    80001e14:	e74080e7          	jalr	-396(ra) # 80000c84 <release>
    return 0;
    80001e18:	84ca                	mv	s1,s2
    80001e1a:	b7e1                	j	80001de2 <allocproc+0x134>
    freeproc(p);
    80001e1c:	8526                	mv	a0,s1
    80001e1e:	00000097          	auipc	ra,0x0
    80001e22:	e30080e7          	jalr	-464(ra) # 80001c4e <freeproc>
    freethread(p->main_thread);
    80001e26:	6785                	lui	a5,0x1
    80001e28:	97a6                	add	a5,a5,s1
    80001e2a:	f307b503          	ld	a0,-208(a5) # f30 <_entry-0x7ffff0d0>
    80001e2e:	00000097          	auipc	ra,0x0
    80001e32:	9ec080e7          	jalr	-1556(ra) # 8000181a <freethread>
    release(&p->lock);
    80001e36:	8526                	mv	a0,s1
    80001e38:	fffff097          	auipc	ra,0xfffff
    80001e3c:	e4c080e7          	jalr	-436(ra) # 80000c84 <release>
    return 0;
    80001e40:	84ca                	mv	s1,s2
    80001e42:	b745                	j	80001de2 <allocproc+0x134>

0000000080001e44 <userinit>:
{
    80001e44:	7179                	addi	sp,sp,-48
    80001e46:	f406                	sd	ra,40(sp)
    80001e48:	f022                	sd	s0,32(sp)
    80001e4a:	ec26                	sd	s1,24(sp)
    80001e4c:	e84a                	sd	s2,16(sp)
    80001e4e:	e44e                	sd	s3,8(sp)
    80001e50:	1800                	addi	s0,sp,48
  p = allocproc();
    80001e52:	00000097          	auipc	ra,0x0
    80001e56:	e5c080e7          	jalr	-420(ra) # 80001cae <allocproc>
    80001e5a:	892a                	mv	s2,a0
  initproc = p;
    80001e5c:	00008797          	auipc	a5,0x8
    80001e60:	1ca7b623          	sd	a0,460(a5) # 8000a028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001e64:	6485                	lui	s1,0x1
    80001e66:	009509b3          	add	s3,a0,s1
    80001e6a:	03400613          	li	a2,52
    80001e6e:	00008597          	auipc	a1,0x8
    80001e72:	af258593          	addi	a1,a1,-1294 # 80009960 <initcode>
    80001e76:	f409b503          	ld	a0,-192(s3) # f40 <_entry-0x7ffff0c0>
    80001e7a:	fffff097          	auipc	ra,0xfffff
    80001e7e:	4c8080e7          	jalr	1224(ra) # 80001342 <uvminit>
  p->sz = PGSIZE;
    80001e82:	f299bc23          	sd	s1,-200(s3)
  p->main_thread->trapframe->epc = 0;      // user program counter
    80001e86:	f309b783          	ld	a5,-208(s3)
    80001e8a:	7f9c                	ld	a5,56(a5)
    80001e8c:	0007bc23          	sd	zero,24(a5)
  p->main_thread->trapframe->sp = PGSIZE;  // user stack pointer
    80001e90:	f309b783          	ld	a5,-208(s3)
    80001e94:	7f9c                	ld	a5,56(a5)
    80001e96:	fb84                	sd	s1,48(a5)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001e98:	fd048513          	addi	a0,s1,-48 # fd0 <_entry-0x7ffff030>
    80001e9c:	4641                	li	a2,16
    80001e9e:	00007597          	auipc	a1,0x7
    80001ea2:	36a58593          	addi	a1,a1,874 # 80009208 <digits+0x1c8>
    80001ea6:	954a                	add	a0,a0,s2
    80001ea8:	fffff097          	auipc	ra,0xfffff
    80001eac:	f76080e7          	jalr	-138(ra) # 80000e1e <safestrcpy>
  p->cwd = namei("/");
    80001eb0:	00007517          	auipc	a0,0x7
    80001eb4:	36850513          	addi	a0,a0,872 # 80009218 <digits+0x1d8>
    80001eb8:	00003097          	auipc	ra,0x3
    80001ebc:	de0080e7          	jalr	-544(ra) # 80004c98 <namei>
    80001ec0:	fca9b423          	sd	a0,-56(s3)
  p->pendingSignals = 0;
    80001ec4:	fe09a023          	sw	zero,-32(s3)
  p->signalMask = 0;
    80001ec8:	fe09a223          	sw	zero,-28(s3)
  for (int i = 0; i < 32; i++) {
    80001ecc:	fe848793          	addi	a5,s1,-24
    80001ed0:	97ca                	add	a5,a5,s2
    80001ed2:	0e848713          	addi	a4,s1,232
    80001ed6:	974a                	add	a4,a4,s2
    p->signalHandlers[i] = SIG_DFL;
    80001ed8:	0007b023          	sd	zero,0(a5)
  for (int i = 0; i < 32; i++) {
    80001edc:	07a1                	addi	a5,a5,8
    80001ede:	fee79de3          	bne	a5,a4,80001ed8 <userinit+0x94>
  p->ignore_signals = 0;
    80001ee2:	6785                	lui	a5,0x1
    80001ee4:	97ca                	add	a5,a5,s2
    80001ee6:	0e07a823          	sw	zero,240(a5) # 10f0 <_entry-0x7fffef10>
  p->stopped = 0;
    80001eea:	0e07a423          	sw	zero,232(a5)
  p->main_thread->state = RUNNABLE;
    80001eee:	f307b783          	ld	a5,-208(a5)
    80001ef2:	470d                	li	a4,3
    80001ef4:	c398                	sw	a4,0(a5)
  release(&p->lock);
    80001ef6:	854a                	mv	a0,s2
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	d8c080e7          	jalr	-628(ra) # 80000c84 <release>
}
    80001f00:	70a2                	ld	ra,40(sp)
    80001f02:	7402                	ld	s0,32(sp)
    80001f04:	64e2                	ld	s1,24(sp)
    80001f06:	6942                	ld	s2,16(sp)
    80001f08:	69a2                	ld	s3,8(sp)
    80001f0a:	6145                	addi	sp,sp,48
    80001f0c:	8082                	ret

0000000080001f0e <growproc>:
{
    80001f0e:	1101                	addi	sp,sp,-32
    80001f10:	ec06                	sd	ra,24(sp)
    80001f12:	e822                	sd	s0,16(sp)
    80001f14:	e426                	sd	s1,8(sp)
    80001f16:	e04a                	sd	s2,0(sp)
    80001f18:	1000                	addi	s0,sp,32
    80001f1a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001f1c:	00000097          	auipc	ra,0x0
    80001f20:	adc080e7          	jalr	-1316(ra) # 800019f8 <myproc>
    80001f24:	84aa                	mv	s1,a0
  sz = p->sz;
    80001f26:	6785                	lui	a5,0x1
    80001f28:	97aa                	add	a5,a5,a0
    80001f2a:	f387b583          	ld	a1,-200(a5) # f38 <_entry-0x7ffff0c8>
    80001f2e:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001f32:	03204163          	bgtz	s2,80001f54 <growproc+0x46>
  } else if(n < 0){
    80001f36:	04094263          	bltz	s2,80001f7a <growproc+0x6c>
  p->sz = sz;
    80001f3a:	6505                	lui	a0,0x1
    80001f3c:	94aa                	add	s1,s1,a0
    80001f3e:	1602                	slli	a2,a2,0x20
    80001f40:	9201                	srli	a2,a2,0x20
    80001f42:	f2c4bc23          	sd	a2,-200(s1)
  return 0;
    80001f46:	4501                	li	a0,0
}
    80001f48:	60e2                	ld	ra,24(sp)
    80001f4a:	6442                	ld	s0,16(sp)
    80001f4c:	64a2                	ld	s1,8(sp)
    80001f4e:	6902                	ld	s2,0(sp)
    80001f50:	6105                	addi	sp,sp,32
    80001f52:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001f54:	00c9063b          	addw	a2,s2,a2
    80001f58:	6785                	lui	a5,0x1
    80001f5a:	97aa                	add	a5,a5,a0
    80001f5c:	1602                	slli	a2,a2,0x20
    80001f5e:	9201                	srli	a2,a2,0x20
    80001f60:	1582                	slli	a1,a1,0x20
    80001f62:	9181                	srli	a1,a1,0x20
    80001f64:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80001f68:	fffff097          	auipc	ra,0xfffff
    80001f6c:	494080e7          	jalr	1172(ra) # 800013fc <uvmalloc>
    80001f70:	0005061b          	sext.w	a2,a0
    80001f74:	f279                	bnez	a2,80001f3a <growproc+0x2c>
      return -1;
    80001f76:	557d                	li	a0,-1
    80001f78:	bfc1                	j	80001f48 <growproc+0x3a>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001f7a:	00c9063b          	addw	a2,s2,a2
    80001f7e:	6785                	lui	a5,0x1
    80001f80:	97aa                	add	a5,a5,a0
    80001f82:	1602                	slli	a2,a2,0x20
    80001f84:	9201                	srli	a2,a2,0x20
    80001f86:	1582                	slli	a1,a1,0x20
    80001f88:	9181                	srli	a1,a1,0x20
    80001f8a:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80001f8e:	fffff097          	auipc	ra,0xfffff
    80001f92:	426080e7          	jalr	1062(ra) # 800013b4 <uvmdealloc>
    80001f96:	0005061b          	sext.w	a2,a0
    80001f9a:	b745                	j	80001f3a <growproc+0x2c>

0000000080001f9c <fork>:
{
    80001f9c:	7139                	addi	sp,sp,-64
    80001f9e:	fc06                	sd	ra,56(sp)
    80001fa0:	f822                	sd	s0,48(sp)
    80001fa2:	f426                	sd	s1,40(sp)
    80001fa4:	f04a                	sd	s2,32(sp)
    80001fa6:	ec4e                	sd	s3,24(sp)
    80001fa8:	e852                	sd	s4,16(sp)
    80001faa:	e456                	sd	s5,8(sp)
    80001fac:	e05a                	sd	s6,0(sp)
    80001fae:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001fb0:	00000097          	auipc	ra,0x0
    80001fb4:	a48080e7          	jalr	-1464(ra) # 800019f8 <myproc>
    80001fb8:	8a2a                	mv	s4,a0
  struct thread *t = mythread();
    80001fba:	00000097          	auipc	ra,0x0
    80001fbe:	ad4080e7          	jalr	-1324(ra) # 80001a8e <mythread>
    80001fc2:	84aa                	mv	s1,a0
  printf("debug: starting fork, tid %d, pid %d\n\n", t->tid, p->pid);
    80001fc4:	024a2603          	lw	a2,36(s4)
    80001fc8:	4d0c                	lw	a1,24(a0)
    80001fca:	00007517          	auipc	a0,0x7
    80001fce:	25650513          	addi	a0,a0,598 # 80009220 <digits+0x1e0>
    80001fd2:	ffffe097          	auipc	ra,0xffffe
    80001fd6:	5a2080e7          	jalr	1442(ra) # 80000574 <printf>
  if((np = allocproc()) == 0){
    80001fda:	00000097          	auipc	ra,0x0
    80001fde:	cd4080e7          	jalr	-812(ra) # 80001cae <allocproc>
    80001fe2:	18050a63          	beqz	a0,80002176 <fork+0x1da>
    80001fe6:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001fe8:	6785                	lui	a5,0x1
    80001fea:	00fa0733          	add	a4,s4,a5
    80001fee:	97aa                	add	a5,a5,a0
    80001ff0:	f3873603          	ld	a2,-200(a4)
    80001ff4:	f407b583          	ld	a1,-192(a5) # f40 <_entry-0x7ffff0c0>
    80001ff8:	f4073503          	ld	a0,-192(a4)
    80001ffc:	fffff097          	auipc	ra,0xfffff
    80002000:	54c080e7          	jalr	1356(ra) # 80001548 <uvmcopy>
    80002004:	08054763          	bltz	a0,80002092 <fork+0xf6>
  np->sz = p->sz;
    80002008:	6605                	lui	a2,0x1
    8000200a:	00ca0733          	add	a4,s4,a2
    8000200e:	f3873683          	ld	a3,-200(a4)
    80002012:	00c987b3          	add	a5,s3,a2
    80002016:	f2d7bc23          	sd	a3,-200(a5)
  np->signalMask = p->signalMask; //inherit signal mask from parent
    8000201a:	fe472703          	lw	a4,-28(a4)
    8000201e:	fee7a223          	sw	a4,-28(a5)
  for (int i = 0; i<32; i++) //inherit signal handlers from parent
    80002022:	fe860713          	addi	a4,a2,-24 # fe8 <_entry-0x7ffff018>
    80002026:	00ea07b3          	add	a5,s4,a4
    8000202a:	974e                	add	a4,a4,s3
    8000202c:	0e860613          	addi	a2,a2,232
    80002030:	9652                	add	a2,a2,s4
    np->signalHandlers[i] = p->signalHandlers[i]; 
    80002032:	6394                	ld	a3,0(a5)
    80002034:	e314                	sd	a3,0(a4)
  for (int i = 0; i<32; i++) //inherit signal handlers from parent
    80002036:	07a1                	addi	a5,a5,8
    80002038:	0721                	addi	a4,a4,8
    8000203a:	fec79ce3          	bne	a5,a2,80002032 <fork+0x96>
  *(np->main_thread->trapframe) = *(t->trapframe);
    8000203e:	7c94                	ld	a3,56(s1)
    80002040:	6785                	lui	a5,0x1
    80002042:	97ce                	add	a5,a5,s3
    80002044:	f307b703          	ld	a4,-208(a5) # f30 <_entry-0x7ffff0d0>
    80002048:	87b6                	mv	a5,a3
    8000204a:	7f18                	ld	a4,56(a4)
    8000204c:	12068693          	addi	a3,a3,288
    80002050:	0007b803          	ld	a6,0(a5)
    80002054:	6788                	ld	a0,8(a5)
    80002056:	6b8c                	ld	a1,16(a5)
    80002058:	6f90                	ld	a2,24(a5)
    8000205a:	01073023          	sd	a6,0(a4)
    8000205e:	e708                	sd	a0,8(a4)
    80002060:	eb0c                	sd	a1,16(a4)
    80002062:	ef10                	sd	a2,24(a4)
    80002064:	02078793          	addi	a5,a5,32
    80002068:	02070713          	addi	a4,a4,32
    8000206c:	fed792e3          	bne	a5,a3,80002050 <fork+0xb4>
  np->main_thread->trapframe->a0 = 0;
    80002070:	6a85                	lui	s5,0x1
    80002072:	015987b3          	add	a5,s3,s5
    80002076:	f307b783          	ld	a5,-208(a5)
    8000207a:	7f9c                	ld	a5,56(a5)
    8000207c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002080:	f48a8913          	addi	s2,s5,-184 # f48 <_entry-0x7ffff0b8>
    80002084:	012a04b3          	add	s1,s4,s2
    80002088:	994e                	add	s2,s2,s3
    8000208a:	fc8a8a93          	addi	s5,s5,-56
    8000208e:	9ad2                	add	s5,s5,s4
    80002090:	a80d                	j	800020c2 <fork+0x126>
    freeproc(np);
    80002092:	854e                	mv	a0,s3
    80002094:	00000097          	auipc	ra,0x0
    80002098:	bba080e7          	jalr	-1094(ra) # 80001c4e <freeproc>
    freethread(np->main_thread);
    8000209c:	6785                	lui	a5,0x1
    8000209e:	97ce                	add	a5,a5,s3
    800020a0:	f307b503          	ld	a0,-208(a5) # f30 <_entry-0x7ffff0d0>
    800020a4:	fffff097          	auipc	ra,0xfffff
    800020a8:	776080e7          	jalr	1910(ra) # 8000181a <freethread>
    release(&np->lock);
    800020ac:	854e                	mv	a0,s3
    800020ae:	fffff097          	auipc	ra,0xfffff
    800020b2:	bd6080e7          	jalr	-1066(ra) # 80000c84 <release>
    return -1;
    800020b6:	5b7d                	li	s6,-1
    800020b8:	a065                	j	80002160 <fork+0x1c4>
  for(i = 0; i < NOFILE; i++)
    800020ba:	04a1                	addi	s1,s1,8
    800020bc:	0921                	addi	s2,s2,8
    800020be:	01548b63          	beq	s1,s5,800020d4 <fork+0x138>
    if(p->ofile[i])
    800020c2:	6088                	ld	a0,0(s1)
    800020c4:	d97d                	beqz	a0,800020ba <fork+0x11e>
      np->ofile[i] = filedup(p->ofile[i]);
    800020c6:	00003097          	auipc	ra,0x3
    800020ca:	26c080e7          	jalr	620(ra) # 80005332 <filedup>
    800020ce:	00a93023          	sd	a0,0(s2)
    800020d2:	b7e5                	j	800020ba <fork+0x11e>
  np->cwd = idup(p->cwd);
    800020d4:	6905                	lui	s2,0x1
    800020d6:	012a0ab3          	add	s5,s4,s2
    800020da:	fc8ab503          	ld	a0,-56(s5)
    800020de:	00002097          	auipc	ra,0x2
    800020e2:	3c2080e7          	jalr	962(ra) # 800044a0 <idup>
    800020e6:	012984b3          	add	s1,s3,s2
    800020ea:	fca4b423          	sd	a0,-56(s1)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800020ee:	fd090513          	addi	a0,s2,-48 # fd0 <_entry-0x7ffff030>
    800020f2:	4641                	li	a2,16
    800020f4:	00aa05b3          	add	a1,s4,a0
    800020f8:	954e                	add	a0,a0,s3
    800020fa:	fffff097          	auipc	ra,0xfffff
    800020fe:	d24080e7          	jalr	-732(ra) # 80000e1e <safestrcpy>
  pid = np->pid;
    80002102:	0249ab03          	lw	s6,36(s3)
  release(&np->lock);
    80002106:	854e                	mv	a0,s3
    80002108:	fffff097          	auipc	ra,0xfffff
    8000210c:	b7c080e7          	jalr	-1156(ra) # 80000c84 <release>
  acquire(&wait_lock);
    80002110:	00010917          	auipc	s2,0x10
    80002114:	1a890913          	addi	s2,s2,424 # 800122b8 <wait_lock>
    80002118:	854a                	mv	a0,s2
    8000211a:	fffff097          	auipc	ra,0xfffff
    8000211e:	ab0080e7          	jalr	-1360(ra) # 80000bca <acquire>
  np->parent = p;
    80002122:	f344b423          	sd	s4,-216(s1)
  release(&wait_lock);
    80002126:	854a                	mv	a0,s2
    80002128:	fffff097          	auipc	ra,0xfffff
    8000212c:	b5c080e7          	jalr	-1188(ra) # 80000c84 <release>
  acquire(&np->lock);
    80002130:	854e                	mv	a0,s3
    80002132:	fffff097          	auipc	ra,0xfffff
    80002136:	a98080e7          	jalr	-1384(ra) # 80000bca <acquire>
  np->pendingSignals = 0;
    8000213a:	fe04a023          	sw	zero,-32(s1)
  np->signalMask = p->signalMask;
    8000213e:	fe4aa783          	lw	a5,-28(s5)
    80002142:	fef4a223          	sw	a5,-28(s1)
  np->ignore_signals = 0;
    80002146:	0e04a823          	sw	zero,240(s1)
  np->stopped = 0;
    8000214a:	0e04a423          	sw	zero,232(s1)
  np->main_thread->state = RUNNABLE;
    8000214e:	f304b783          	ld	a5,-208(s1)
    80002152:	470d                	li	a4,3
    80002154:	c398                	sw	a4,0(a5)
  release(&np->lock);
    80002156:	854e                	mv	a0,s3
    80002158:	fffff097          	auipc	ra,0xfffff
    8000215c:	b2c080e7          	jalr	-1236(ra) # 80000c84 <release>
}
    80002160:	855a                	mv	a0,s6
    80002162:	70e2                	ld	ra,56(sp)
    80002164:	7442                	ld	s0,48(sp)
    80002166:	74a2                	ld	s1,40(sp)
    80002168:	7902                	ld	s2,32(sp)
    8000216a:	69e2                	ld	s3,24(sp)
    8000216c:	6a42                	ld	s4,16(sp)
    8000216e:	6aa2                	ld	s5,8(sp)
    80002170:	6b02                	ld	s6,0(sp)
    80002172:	6121                	addi	sp,sp,64
    80002174:	8082                	ret
    return -1;
    80002176:	5b7d                	li	s6,-1
    80002178:	b7e5                	j	80002160 <fork+0x1c4>

000000008000217a <scheduler>:
{
    8000217a:	711d                	addi	sp,sp,-96
    8000217c:	ec86                	sd	ra,88(sp)
    8000217e:	e8a2                	sd	s0,80(sp)
    80002180:	e4a6                	sd	s1,72(sp)
    80002182:	e0ca                	sd	s2,64(sp)
    80002184:	fc4e                	sd	s3,56(sp)
    80002186:	f852                	sd	s4,48(sp)
    80002188:	f456                	sd	s5,40(sp)
    8000218a:	f05a                	sd	s6,32(sp)
    8000218c:	ec5e                	sd	s7,24(sp)
    8000218e:	e862                	sd	s8,16(sp)
    80002190:	e466                	sd	s9,8(sp)
    80002192:	1080                	addi	s0,sp,96
    80002194:	8792                	mv	a5,tp
  int id = r_tp();
    80002196:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002198:	00479713          	slli	a4,a5,0x4
    8000219c:	00f706b3          	add	a3,a4,a5
    800021a0:	00369613          	slli	a2,a3,0x3
    800021a4:	00010697          	auipc	a3,0x10
    800021a8:	0fc68693          	addi	a3,a3,252 # 800122a0 <pid_lock>
    800021ac:	96b2                	add	a3,a3,a2
    800021ae:	0206b823          	sd	zero,48(a3)
  c->thread = 0;
    800021b2:	0206bc23          	sd	zero,56(a3)
          swtch(&c->context, &t->context);
    800021b6:	00010717          	auipc	a4,0x10
    800021ba:	12a70713          	addi	a4,a4,298 # 800122e0 <cpus+0x10>
    800021be:	00e60c33          	add	s8,a2,a4
          c->thread = t;
    800021c2:	8ab6                	mv	s5,a3
    for(p = proc; p < &proc[NPROC]; p++) {
    800021c4:	6b85                	lui	s7,0x1
    800021c6:	178b8b93          	addi	s7,s7,376 # 1178 <_entry-0x7fffee88>
    800021ca:	00056c97          	auipc	s9,0x56
    800021ce:	38ec8c93          	addi	s9,s9,910 # 80058558 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800021d2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800021d6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800021da:	10079073          	csrw	sstatus,a5
    800021de:	00011917          	auipc	s2,0x11
    800021e2:	4a290913          	addi	s2,s2,1186 # 80013680 <proc+0xf28>
    800021e6:	00010a17          	auipc	s4,0x10
    800021ea:	572a0a13          	addi	s4,s4,1394 # 80012758 <proc>
    800021ee:	a099                	j	80002234 <scheduler+0xba>
      for (t = p->threads; t < &p->threads[NTHREAD]; t++){
    800021f0:	1e048493          	addi	s1,s1,480
    800021f4:	03248763          	beq	s1,s2,80002222 <scheduler+0xa8>
        if(t->state == RUNNABLE) {
    800021f8:	409c                	lw	a5,0(s1)
    800021fa:	ff379be3          	bne	a5,s3,800021f0 <scheduler+0x76>
          t->state = RUNNING;
    800021fe:	0164a023          	sw	s6,0(s1)
          c->thread = t;
    80002202:	029abc23          	sd	s1,56(s5)
          c->proc = p;
    80002206:	034ab823          	sd	s4,48(s5)
          swtch(&c->context, &t->context);
    8000220a:	16048593          	addi	a1,s1,352
    8000220e:	8562                	mv	a0,s8
    80002210:	00001097          	auipc	ra,0x1
    80002214:	fae080e7          	jalr	-82(ra) # 800031be <swtch>
          c->proc = 0;
    80002218:	020ab823          	sd	zero,48(s5)
          c->thread = 0;
    8000221c:	020abc23          	sd	zero,56(s5)
    80002220:	bfc1                	j	800021f0 <scheduler+0x76>
       release(&p->lock);
    80002222:	8552                	mv	a0,s4
    80002224:	fffff097          	auipc	ra,0xfffff
    80002228:	a60080e7          	jalr	-1440(ra) # 80000c84 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000222c:	9a5e                	add	s4,s4,s7
    8000222e:	995e                	add	s2,s2,s7
    80002230:	fb9a01e3          	beq	s4,s9,800021d2 <scheduler+0x58>
      acquire(&p->lock);
    80002234:	8552                	mv	a0,s4
    80002236:	fffff097          	auipc	ra,0xfffff
    8000223a:	994080e7          	jalr	-1644(ra) # 80000bca <acquire>
      for (t = p->threads; t < &p->threads[NTHREAD]; t++){
    8000223e:	028a0493          	addi	s1,s4,40
        if(t->state == RUNNABLE) {
    80002242:	498d                	li	s3,3
          t->state = RUNNING;
    80002244:	4b11                	li	s6,4
    80002246:	bf4d                	j	800021f8 <scheduler+0x7e>

0000000080002248 <sched>:
{
    80002248:	7179                	addi	sp,sp,-48
    8000224a:	f406                	sd	ra,40(sp)
    8000224c:	f022                	sd	s0,32(sp)
    8000224e:	ec26                	sd	s1,24(sp)
    80002250:	e84a                	sd	s2,16(sp)
    80002252:	e44e                	sd	s3,8(sp)
    80002254:	1800                	addi	s0,sp,48
  struct thread *t = mythread();
    80002256:	00000097          	auipc	ra,0x0
    8000225a:	838080e7          	jalr	-1992(ra) # 80001a8e <mythread>
    8000225e:	84aa                	mv	s1,a0
  if(!holding(&t->proc_parent->lock))
    80002260:	7508                	ld	a0,40(a0)
    80002262:	fffff097          	auipc	ra,0xfffff
    80002266:	8e6080e7          	jalr	-1818(ra) # 80000b48 <holding>
    8000226a:	c959                	beqz	a0,80002300 <sched+0xb8>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000226c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1){
    8000226e:	0007871b          	sext.w	a4,a5
    80002272:	00471793          	slli	a5,a4,0x4
    80002276:	97ba                	add	a5,a5,a4
    80002278:	078e                	slli	a5,a5,0x3
    8000227a:	00010717          	auipc	a4,0x10
    8000227e:	02670713          	addi	a4,a4,38 # 800122a0 <pid_lock>
    80002282:	97ba                	add	a5,a5,a4
    80002284:	0b07a703          	lw	a4,176(a5)
    80002288:	4785                	li	a5,1
    8000228a:	08f71363          	bne	a4,a5,80002310 <sched+0xc8>
  if(t->state == RUNNING)
    8000228e:	4098                	lw	a4,0(s1)
    80002290:	4791                	li	a5,4
    80002292:	08f70763          	beq	a4,a5,80002320 <sched+0xd8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002296:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000229a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000229c:	ebd1                	bnez	a5,80002330 <sched+0xe8>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000229e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800022a0:	00010917          	auipc	s2,0x10
    800022a4:	00090913          	mv	s2,s2
    800022a8:	0007871b          	sext.w	a4,a5
    800022ac:	00471793          	slli	a5,a4,0x4
    800022b0:	97ba                	add	a5,a5,a4
    800022b2:	078e                	slli	a5,a5,0x3
    800022b4:	97ca                	add	a5,a5,s2
    800022b6:	0b47a983          	lw	s3,180(a5)
    800022ba:	8792                	mv	a5,tp
  swtch(&t->context, &mycpu()->context);
    800022bc:	0007859b          	sext.w	a1,a5
    800022c0:	00459793          	slli	a5,a1,0x4
    800022c4:	97ae                	add	a5,a5,a1
    800022c6:	078e                	slli	a5,a5,0x3
    800022c8:	00010597          	auipc	a1,0x10
    800022cc:	01858593          	addi	a1,a1,24 # 800122e0 <cpus+0x10>
    800022d0:	95be                	add	a1,a1,a5
    800022d2:	16048513          	addi	a0,s1,352
    800022d6:	00001097          	auipc	ra,0x1
    800022da:	ee8080e7          	jalr	-280(ra) # 800031be <swtch>
    800022de:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800022e0:	0007871b          	sext.w	a4,a5
    800022e4:	00471793          	slli	a5,a4,0x4
    800022e8:	97ba                	add	a5,a5,a4
    800022ea:	078e                	slli	a5,a5,0x3
    800022ec:	97ca                	add	a5,a5,s2
    800022ee:	0b37aa23          	sw	s3,180(a5)
}
    800022f2:	70a2                	ld	ra,40(sp)
    800022f4:	7402                	ld	s0,32(sp)
    800022f6:	64e2                	ld	s1,24(sp)
    800022f8:	6942                	ld	s2,16(sp)
    800022fa:	69a2                	ld	s3,8(sp)
    800022fc:	6145                	addi	sp,sp,48
    800022fe:	8082                	ret
    panic("sched p->lock");
    80002300:	00007517          	auipc	a0,0x7
    80002304:	f4850513          	addi	a0,a0,-184 # 80009248 <digits+0x208>
    80002308:	ffffe097          	auipc	ra,0xffffe
    8000230c:	222080e7          	jalr	546(ra) # 8000052a <panic>
    panic("sched locks");
    80002310:	00007517          	auipc	a0,0x7
    80002314:	f4850513          	addi	a0,a0,-184 # 80009258 <digits+0x218>
    80002318:	ffffe097          	auipc	ra,0xffffe
    8000231c:	212080e7          	jalr	530(ra) # 8000052a <panic>
    panic("sched running");
    80002320:	00007517          	auipc	a0,0x7
    80002324:	f4850513          	addi	a0,a0,-184 # 80009268 <digits+0x228>
    80002328:	ffffe097          	auipc	ra,0xffffe
    8000232c:	202080e7          	jalr	514(ra) # 8000052a <panic>
    panic("sched interruptible");
    80002330:	00007517          	auipc	a0,0x7
    80002334:	f4850513          	addi	a0,a0,-184 # 80009278 <digits+0x238>
    80002338:	ffffe097          	auipc	ra,0xffffe
    8000233c:	1f2080e7          	jalr	498(ra) # 8000052a <panic>

0000000080002340 <yield>:
{
    80002340:	1101                	addi	sp,sp,-32
    80002342:	ec06                	sd	ra,24(sp)
    80002344:	e822                	sd	s0,16(sp)
    80002346:	e426                	sd	s1,8(sp)
    80002348:	1000                	addi	s0,sp,32
  struct thread *t = mythread();
    8000234a:	fffff097          	auipc	ra,0xfffff
    8000234e:	744080e7          	jalr	1860(ra) # 80001a8e <mythread>
    80002352:	84aa                	mv	s1,a0
  acquire(&t->proc_parent->lock);
    80002354:	7508                	ld	a0,40(a0)
    80002356:	fffff097          	auipc	ra,0xfffff
    8000235a:	874080e7          	jalr	-1932(ra) # 80000bca <acquire>
  t->state = RUNNABLE;
    8000235e:	478d                	li	a5,3
    80002360:	c09c                	sw	a5,0(s1)
  sched();
    80002362:	00000097          	auipc	ra,0x0
    80002366:	ee6080e7          	jalr	-282(ra) # 80002248 <sched>
  release(&t->proc_parent->lock);
    8000236a:	7488                	ld	a0,40(s1)
    8000236c:	fffff097          	auipc	ra,0xfffff
    80002370:	918080e7          	jalr	-1768(ra) # 80000c84 <release>
}
    80002374:	60e2                	ld	ra,24(sp)
    80002376:	6442                	ld	s0,16(sp)
    80002378:	64a2                	ld	s1,8(sp)
    8000237a:	6105                	addi	sp,sp,32
    8000237c:	8082                	ret

000000008000237e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000237e:	7179                	addi	sp,sp,-48
    80002380:	f406                	sd	ra,40(sp)
    80002382:	f022                	sd	s0,32(sp)
    80002384:	ec26                	sd	s1,24(sp)
    80002386:	e84a                	sd	s2,16(sp)
    80002388:	e44e                	sd	s3,8(sp)
    8000238a:	1800                	addi	s0,sp,48
    8000238c:	89aa                	mv	s3,a0
    8000238e:	892e                	mv	s2,a1
  //printf("debug: lock:%s starting sleep function\n", lk->name);
  struct thread *t = mythread();
    80002390:	fffff097          	auipc	ra,0xfffff
    80002394:	6fe080e7          	jalr	1790(ra) # 80001a8e <mythread>
    80002398:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&t->proc_parent->lock);  //DOC: sleeplock1
    8000239a:	7508                	ld	a0,40(a0)
    8000239c:	fffff097          	auipc	ra,0xfffff
    800023a0:	82e080e7          	jalr	-2002(ra) # 80000bca <acquire>
  release(lk);
    800023a4:	854a                	mv	a0,s2
    800023a6:	fffff097          	auipc	ra,0xfffff
    800023aa:	8de080e7          	jalr	-1826(ra) # 80000c84 <release>

  // Go to sleep.
  t->chan = chan;
    800023ae:	0134b423          	sd	s3,8(s1)
  t->state = SLEEPING;
    800023b2:	4789                	li	a5,2
    800023b4:	c09c                	sw	a5,0(s1)

  sched();
    800023b6:	00000097          	auipc	ra,0x0
    800023ba:	e92080e7          	jalr	-366(ra) # 80002248 <sched>
  //printf("debug: lock:%s finish to sleep\n", lk->name);

  // Tidy up.
  t->chan = 0;
    800023be:	0004b423          	sd	zero,8(s1)

  // Reacquire original lock.
  release(&t->proc_parent->lock);
    800023c2:	7488                	ld	a0,40(s1)
    800023c4:	fffff097          	auipc	ra,0xfffff
    800023c8:	8c0080e7          	jalr	-1856(ra) # 80000c84 <release>
  acquire(lk);
    800023cc:	854a                	mv	a0,s2
    800023ce:	ffffe097          	auipc	ra,0xffffe
    800023d2:	7fc080e7          	jalr	2044(ra) # 80000bca <acquire>
  //printf("debug: exit from sleep function\n");
}
    800023d6:	70a2                	ld	ra,40(sp)
    800023d8:	7402                	ld	s0,32(sp)
    800023da:	64e2                	ld	s1,24(sp)
    800023dc:	6942                	ld	s2,16(sp)
    800023de:	69a2                	ld	s3,8(sp)
    800023e0:	6145                	addi	sp,sp,48
    800023e2:	8082                	ret

00000000800023e4 <wait>:
{
    800023e4:	715d                	addi	sp,sp,-80
    800023e6:	e486                	sd	ra,72(sp)
    800023e8:	e0a2                	sd	s0,64(sp)
    800023ea:	fc26                	sd	s1,56(sp)
    800023ec:	f84a                	sd	s2,48(sp)
    800023ee:	f44e                	sd	s3,40(sp)
    800023f0:	f052                	sd	s4,32(sp)
    800023f2:	ec56                	sd	s5,24(sp)
    800023f4:	e85a                	sd	s6,16(sp)
    800023f6:	e45e                	sd	s7,8(sp)
    800023f8:	e062                	sd	s8,0(sp)
    800023fa:	0880                	addi	s0,sp,80
    800023fc:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800023fe:	fffff097          	auipc	ra,0xfffff
    80002402:	5fa080e7          	jalr	1530(ra) # 800019f8 <myproc>
    80002406:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002408:	00010517          	auipc	a0,0x10
    8000240c:	eb050513          	addi	a0,a0,-336 # 800122b8 <wait_lock>
    80002410:	ffffe097          	auipc	ra,0xffffe
    80002414:	7ba080e7          	jalr	1978(ra) # 80000bca <acquire>
      if(np->parent == p){
    80002418:	6985                	lui	s3,0x1
    8000241a:	f2898a13          	addi	s4,s3,-216 # f28 <_entry-0x7ffff0d8>
        if(np->state == ZOMBIE){
    8000241e:	4b15                	li	s6,5
    for(np = proc; np < &proc[NPROC]; np++){
    80002420:	17898993          	addi	s3,s3,376
    80002424:	00056a97          	auipc	s5,0x56
    80002428:	134a8a93          	addi	s5,s5,308 # 80058558 <tickslock>
    havekids = 0;
    8000242c:	4701                	li	a4,0
    for(np = proc; np < &proc[NPROC]; np++){
    8000242e:	00010497          	auipc	s1,0x10
    80002432:	32a48493          	addi	s1,s1,810 # 80012758 <proc>
        havekids = 1;
    80002436:	4c05                	li	s8,1
    80002438:	a041                	j	800024b8 <wait+0xd4>
          pid = np->pid;
    8000243a:	0244a983          	lw	s3,36(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000243e:	020b8063          	beqz	s7,8000245e <wait+0x7a>
    80002442:	6785                	lui	a5,0x1
    80002444:	993e                	add	s2,s2,a5
    80002446:	4691                	li	a3,4
    80002448:	02048613          	addi	a2,s1,32
    8000244c:	85de                	mv	a1,s7
    8000244e:	f4093503          	ld	a0,-192(s2) # 800121e0 <cons+0x60>
    80002452:	fffff097          	auipc	ra,0xfffff
    80002456:	1fa080e7          	jalr	506(ra) # 8000164c <copyout>
    8000245a:	02054d63          	bltz	a0,80002494 <wait+0xb0>
          freeproc(np);
    8000245e:	8526                	mv	a0,s1
    80002460:	fffff097          	auipc	ra,0xfffff
    80002464:	7ee080e7          	jalr	2030(ra) # 80001c4e <freeproc>
          freethread(np->main_thread);
    80002468:	6785                	lui	a5,0x1
    8000246a:	97a6                	add	a5,a5,s1
    8000246c:	f307b503          	ld	a0,-208(a5) # f30 <_entry-0x7ffff0d0>
    80002470:	fffff097          	auipc	ra,0xfffff
    80002474:	3aa080e7          	jalr	938(ra) # 8000181a <freethread>
          release(&np->lock);
    80002478:	8526                	mv	a0,s1
    8000247a:	fffff097          	auipc	ra,0xfffff
    8000247e:	80a080e7          	jalr	-2038(ra) # 80000c84 <release>
          release(&wait_lock);
    80002482:	00010517          	auipc	a0,0x10
    80002486:	e3650513          	addi	a0,a0,-458 # 800122b8 <wait_lock>
    8000248a:	ffffe097          	auipc	ra,0xffffe
    8000248e:	7fa080e7          	jalr	2042(ra) # 80000c84 <release>
          return pid;
    80002492:	a0a5                	j	800024fa <wait+0x116>
            release(&np->lock);
    80002494:	8526                	mv	a0,s1
    80002496:	ffffe097          	auipc	ra,0xffffe
    8000249a:	7ee080e7          	jalr	2030(ra) # 80000c84 <release>
            release(&wait_lock);
    8000249e:	00010517          	auipc	a0,0x10
    800024a2:	e1a50513          	addi	a0,a0,-486 # 800122b8 <wait_lock>
    800024a6:	ffffe097          	auipc	ra,0xffffe
    800024aa:	7de080e7          	jalr	2014(ra) # 80000c84 <release>
            return -1;
    800024ae:	59fd                	li	s3,-1
    800024b0:	a0a9                	j	800024fa <wait+0x116>
    for(np = proc; np < &proc[NPROC]; np++){
    800024b2:	94ce                	add	s1,s1,s3
    800024b4:	03548663          	beq	s1,s5,800024e0 <wait+0xfc>
      if(np->parent == p){
    800024b8:	014487b3          	add	a5,s1,s4
    800024bc:	639c                	ld	a5,0(a5)
    800024be:	ff279ae3          	bne	a5,s2,800024b2 <wait+0xce>
        acquire(&np->lock);
    800024c2:	8526                	mv	a0,s1
    800024c4:	ffffe097          	auipc	ra,0xffffe
    800024c8:	706080e7          	jalr	1798(ra) # 80000bca <acquire>
        if(np->state == ZOMBIE){
    800024cc:	4c9c                	lw	a5,24(s1)
    800024ce:	f76786e3          	beq	a5,s6,8000243a <wait+0x56>
        release(&np->lock);
    800024d2:	8526                	mv	a0,s1
    800024d4:	ffffe097          	auipc	ra,0xffffe
    800024d8:	7b0080e7          	jalr	1968(ra) # 80000c84 <release>
        havekids = 1;
    800024dc:	8762                	mv	a4,s8
    800024de:	bfd1                	j	800024b2 <wait+0xce>
    if(!havekids || p->killed){
    800024e0:	c701                	beqz	a4,800024e8 <wait+0x104>
    800024e2:	01c92783          	lw	a5,28(s2)
    800024e6:	c79d                	beqz	a5,80002514 <wait+0x130>
      release(&wait_lock);
    800024e8:	00010517          	auipc	a0,0x10
    800024ec:	dd050513          	addi	a0,a0,-560 # 800122b8 <wait_lock>
    800024f0:	ffffe097          	auipc	ra,0xffffe
    800024f4:	794080e7          	jalr	1940(ra) # 80000c84 <release>
      return -1;
    800024f8:	59fd                	li	s3,-1
}
    800024fa:	854e                	mv	a0,s3
    800024fc:	60a6                	ld	ra,72(sp)
    800024fe:	6406                	ld	s0,64(sp)
    80002500:	74e2                	ld	s1,56(sp)
    80002502:	7942                	ld	s2,48(sp)
    80002504:	79a2                	ld	s3,40(sp)
    80002506:	7a02                	ld	s4,32(sp)
    80002508:	6ae2                	ld	s5,24(sp)
    8000250a:	6b42                	ld	s6,16(sp)
    8000250c:	6ba2                	ld	s7,8(sp)
    8000250e:	6c02                	ld	s8,0(sp)
    80002510:	6161                	addi	sp,sp,80
    80002512:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002514:	00010597          	auipc	a1,0x10
    80002518:	da458593          	addi	a1,a1,-604 # 800122b8 <wait_lock>
    8000251c:	854a                	mv	a0,s2
    8000251e:	00000097          	auipc	ra,0x0
    80002522:	e60080e7          	jalr	-416(ra) # 8000237e <sleep>
    havekids = 0;
    80002526:	b719                	j	8000242c <wait+0x48>

0000000080002528 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002528:	715d                	addi	sp,sp,-80
    8000252a:	e486                	sd	ra,72(sp)
    8000252c:	e0a2                	sd	s0,64(sp)
    8000252e:	fc26                	sd	s1,56(sp)
    80002530:	f84a                	sd	s2,48(sp)
    80002532:	f44e                	sd	s3,40(sp)
    80002534:	f052                	sd	s4,32(sp)
    80002536:	ec56                	sd	s5,24(sp)
    80002538:	e85a                	sd	s6,16(sp)
    8000253a:	e45e                	sd	s7,8(sp)
    8000253c:	e062                	sd	s8,0(sp)
    8000253e:	0880                	addi	s0,sp,80
    80002540:	8baa                	mv	s7,a0
  //printf("debug: starting wakeup\n");
  struct proc *p;
  struct thread *t;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002542:	00011997          	auipc	s3,0x11
    80002546:	13e98993          	addi	s3,s3,318 # 80013680 <proc+0xf28>
    8000254a:	00010917          	auipc	s2,0x10
    8000254e:	20e90913          	addi	s2,s2,526 # 80012758 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      for (t = p->threads; t < &p->threads[NTHREAD]; t++){
        if (t != mythread()){
          if(t->state == SLEEPING && t->chan == chan) {
    80002552:	4a89                	li	s5,2
            t->state = RUNNABLE;
    80002554:	4c0d                	li	s8,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002556:	6a05                	lui	s4,0x1
    80002558:	178a0a13          	addi	s4,s4,376 # 1178 <_entry-0x7fffee88>
    8000255c:	00056b17          	auipc	s6,0x56
    80002560:	ffcb0b13          	addi	s6,s6,-4 # 80058558 <tickslock>
    80002564:	a82d                	j	8000259e <wakeup+0x76>
      for (t = p->threads; t < &p->threads[NTHREAD]; t++){
    80002566:	1e048493          	addi	s1,s1,480
    8000256a:	03348163          	beq	s1,s3,8000258c <wakeup+0x64>
        if (t != mythread()){
    8000256e:	fffff097          	auipc	ra,0xfffff
    80002572:	520080e7          	jalr	1312(ra) # 80001a8e <mythread>
    80002576:	fea488e3          	beq	s1,a0,80002566 <wakeup+0x3e>
          if(t->state == SLEEPING && t->chan == chan) {
    8000257a:	409c                	lw	a5,0(s1)
    8000257c:	ff5795e3          	bne	a5,s5,80002566 <wakeup+0x3e>
    80002580:	649c                	ld	a5,8(s1)
    80002582:	ff7792e3          	bne	a5,s7,80002566 <wakeup+0x3e>
            t->state = RUNNABLE;
    80002586:	0184a023          	sw	s8,0(s1)
    8000258a:	bff1                	j	80002566 <wakeup+0x3e>
          }
        }
      }
      release(&p->lock);
    8000258c:	854a                	mv	a0,s2
    8000258e:	ffffe097          	auipc	ra,0xffffe
    80002592:	6f6080e7          	jalr	1782(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002596:	9952                	add	s2,s2,s4
    80002598:	99d2                	add	s3,s3,s4
    8000259a:	03690063          	beq	s2,s6,800025ba <wakeup+0x92>
    if(p != myproc()){
    8000259e:	fffff097          	auipc	ra,0xfffff
    800025a2:	45a080e7          	jalr	1114(ra) # 800019f8 <myproc>
    800025a6:	fea908e3          	beq	s2,a0,80002596 <wakeup+0x6e>
      acquire(&p->lock);
    800025aa:	854a                	mv	a0,s2
    800025ac:	ffffe097          	auipc	ra,0xffffe
    800025b0:	61e080e7          	jalr	1566(ra) # 80000bca <acquire>
      for (t = p->threads; t < &p->threads[NTHREAD]; t++){
    800025b4:	02890493          	addi	s1,s2,40
    800025b8:	bf5d                	j	8000256e <wakeup+0x46>
    }
  }
  //printf("debug: finishing wakeup\n");

}
    800025ba:	60a6                	ld	ra,72(sp)
    800025bc:	6406                	ld	s0,64(sp)
    800025be:	74e2                	ld	s1,56(sp)
    800025c0:	7942                	ld	s2,48(sp)
    800025c2:	79a2                	ld	s3,40(sp)
    800025c4:	7a02                	ld	s4,32(sp)
    800025c6:	6ae2                	ld	s5,24(sp)
    800025c8:	6b42                	ld	s6,16(sp)
    800025ca:	6ba2                	ld	s7,8(sp)
    800025cc:	6c02                	ld	s8,0(sp)
    800025ce:	6161                	addi	sp,sp,80
    800025d0:	8082                	ret

00000000800025d2 <reparent>:
{
    800025d2:	7139                	addi	sp,sp,-64
    800025d4:	fc06                	sd	ra,56(sp)
    800025d6:	f822                	sd	s0,48(sp)
    800025d8:	f426                	sd	s1,40(sp)
    800025da:	f04a                	sd	s2,32(sp)
    800025dc:	ec4e                	sd	s3,24(sp)
    800025de:	e852                	sd	s4,16(sp)
    800025e0:	e456                	sd	s5,8(sp)
    800025e2:	0080                	addi	s0,sp,64
    800025e4:	89aa                	mv	s3,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800025e6:	00011497          	auipc	s1,0x11
    800025ea:	09a48493          	addi	s1,s1,154 # 80013680 <proc+0xf28>
    800025ee:	00057a17          	auipc	s4,0x57
    800025f2:	e92a0a13          	addi	s4,s4,-366 # 80059480 <bcache+0xf10>
      pp->parent = initproc;
    800025f6:	00008a97          	auipc	s5,0x8
    800025fa:	a32a8a93          	addi	s5,s5,-1486 # 8000a028 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800025fe:	6905                	lui	s2,0x1
    80002600:	17890913          	addi	s2,s2,376 # 1178 <_entry-0x7fffee88>
    80002604:	a021                	j	8000260c <reparent+0x3a>
    80002606:	94ca                	add	s1,s1,s2
    80002608:	01448d63          	beq	s1,s4,80002622 <reparent+0x50>
    if(pp->parent == p){
    8000260c:	609c                	ld	a5,0(s1)
    8000260e:	ff379ce3          	bne	a5,s3,80002606 <reparent+0x34>
      pp->parent = initproc;
    80002612:	000ab503          	ld	a0,0(s5)
    80002616:	e088                	sd	a0,0(s1)
      wakeup(initproc);
    80002618:	00000097          	auipc	ra,0x0
    8000261c:	f10080e7          	jalr	-240(ra) # 80002528 <wakeup>
    80002620:	b7dd                	j	80002606 <reparent+0x34>
}
    80002622:	70e2                	ld	ra,56(sp)
    80002624:	7442                	ld	s0,48(sp)
    80002626:	74a2                	ld	s1,40(sp)
    80002628:	7902                	ld	s2,32(sp)
    8000262a:	69e2                	ld	s3,24(sp)
    8000262c:	6a42                	ld	s4,16(sp)
    8000262e:	6aa2                	ld	s5,8(sp)
    80002630:	6121                	addi	sp,sp,64
    80002632:	8082                	ret

0000000080002634 <Treparent>:
{
    80002634:	7139                	addi	sp,sp,-64
    80002636:	fc06                	sd	ra,56(sp)
    80002638:	f822                	sd	s0,48(sp)
    8000263a:	f426                	sd	s1,40(sp)
    8000263c:	f04a                	sd	s2,32(sp)
    8000263e:	ec4e                	sd	s3,24(sp)
    80002640:	e852                	sd	s4,16(sp)
    80002642:	e456                	sd	s5,8(sp)
    80002644:	e05a                	sd	s6,0(sp)
    80002646:	0080                	addi	s0,sp,64
    80002648:	892a                	mv	s2,a0
  struct proc *p = t->proc_parent;
    8000264a:	02853a03          	ld	s4,40(a0)
  for(tt = p->threads; tt < &p->threads[NTHREAD]; tt++){
    8000264e:	028a0493          	addi	s1,s4,40
    80002652:	6985                	lui	s3,0x1
    80002654:	f2898993          	addi	s3,s3,-216 # f28 <_entry-0x7ffff0d8>
    80002658:	99d2                	add	s3,s3,s4
    printf("Treparent tid number: %d\n",tt->tid);
    8000265a:	00007a97          	auipc	s5,0x7
    8000265e:	c36a8a93          	addi	s5,s5,-970 # 80009290 <digits+0x250>
    if(tt->thread_parent == t && t!=p->main_thread){
    80002662:	6785                	lui	a5,0x1
    80002664:	9a3e                	add	s4,s4,a5
      printf("found a children\n");
    80002666:	00007b17          	auipc	s6,0x7
    8000266a:	c4ab0b13          	addi	s6,s6,-950 # 800092b0 <digits+0x270>
    8000266e:	a821                	j	80002686 <Treparent+0x52>
      p->main_thread = tt;
    80002670:	f29a3823          	sd	s1,-208(s4)
      printf("found a children\n");
    80002674:	855a                	mv	a0,s6
    80002676:	ffffe097          	auipc	ra,0xffffe
    8000267a:	efe080e7          	jalr	-258(ra) # 80000574 <printf>
  for(tt = p->threads; tt < &p->threads[NTHREAD]; tt++){
    8000267e:	1e048493          	addi	s1,s1,480
    80002682:	02998c63          	beq	s3,s1,800026ba <Treparent+0x86>
    printf("Treparent tid number: %d\n",tt->tid);
    80002686:	4c8c                	lw	a1,24(s1)
    80002688:	8556                	mv	a0,s5
    8000268a:	ffffe097          	auipc	ra,0xffffe
    8000268e:	eea080e7          	jalr	-278(ra) # 80000574 <printf>
    if(tt->thread_parent == t && t!=p->main_thread){
    80002692:	709c                	ld	a5,32(s1)
    80002694:	ff2795e3          	bne	a5,s2,8000267e <Treparent+0x4a>
    80002698:	f30a3783          	ld	a5,-208(s4)
    8000269c:	fd278ae3          	beq	a5,s2,80002670 <Treparent+0x3c>
      printf("found a children\n");
    800026a0:	855a                	mv	a0,s6
    800026a2:	ffffe097          	auipc	ra,0xffffe
    800026a6:	ed2080e7          	jalr	-302(ra) # 80000574 <printf>
      tt->thread_parent = p->main_thread;
    800026aa:	f30a3503          	ld	a0,-208(s4)
    800026ae:	f088                	sd	a0,32(s1)
      wakeup(p->main_thread);
    800026b0:	00000097          	auipc	ra,0x0
    800026b4:	e78080e7          	jalr	-392(ra) # 80002528 <wakeup>
    800026b8:	b7d9                	j	8000267e <Treparent+0x4a>
}
    800026ba:	70e2                	ld	ra,56(sp)
    800026bc:	7442                	ld	s0,48(sp)
    800026be:	74a2                	ld	s1,40(sp)
    800026c0:	7902                	ld	s2,32(sp)
    800026c2:	69e2                	ld	s3,24(sp)
    800026c4:	6a42                	ld	s4,16(sp)
    800026c6:	6aa2                	ld	s5,8(sp)
    800026c8:	6b02                	ld	s6,0(sp)
    800026ca:	6121                	addi	sp,sp,64
    800026cc:	8082                	ret

00000000800026ce <exit>:
{
    800026ce:	7179                	addi	sp,sp,-48
    800026d0:	f406                	sd	ra,40(sp)
    800026d2:	f022                	sd	s0,32(sp)
    800026d4:	ec26                	sd	s1,24(sp)
    800026d6:	e84a                	sd	s2,16(sp)
    800026d8:	e44e                	sd	s3,8(sp)
    800026da:	e052                	sd	s4,0(sp)
    800026dc:	1800                	addi	s0,sp,48
    800026de:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800026e0:	fffff097          	auipc	ra,0xfffff
    800026e4:	318080e7          	jalr	792(ra) # 800019f8 <myproc>
  if(p == initproc)
    800026e8:	00008797          	auipc	a5,0x8
    800026ec:	9407b783          	ld	a5,-1728(a5) # 8000a028 <initproc>
    800026f0:	00a78b63          	beq	a5,a0,80002706 <exit+0x38>
    800026f4:	892a                	mv	s2,a0
    800026f6:	6985                	lui	s3,0x1
    800026f8:	f4898493          	addi	s1,s3,-184 # f48 <_entry-0x7ffff0b8>
    800026fc:	94aa                	add	s1,s1,a0
    800026fe:	fc898993          	addi	s3,s3,-56
    80002702:	99aa                	add	s3,s3,a0
    80002704:	a015                	j	80002728 <exit+0x5a>
    panic("init exiting");
    80002706:	00007517          	auipc	a0,0x7
    8000270a:	bc250513          	addi	a0,a0,-1086 # 800092c8 <digits+0x288>
    8000270e:	ffffe097          	auipc	ra,0xffffe
    80002712:	e1c080e7          	jalr	-484(ra) # 8000052a <panic>
      fileclose(f);
    80002716:	00003097          	auipc	ra,0x3
    8000271a:	c6e080e7          	jalr	-914(ra) # 80005384 <fileclose>
      p->ofile[fd] = 0;
    8000271e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002722:	04a1                	addi	s1,s1,8
    80002724:	01348563          	beq	s1,s3,8000272e <exit+0x60>
    if(p->ofile[fd]){
    80002728:	6088                	ld	a0,0(s1)
    8000272a:	f575                	bnez	a0,80002716 <exit+0x48>
    8000272c:	bfdd                	j	80002722 <exit+0x54>
  begin_op();
    8000272e:	00002097          	auipc	ra,0x2
    80002732:	78a080e7          	jalr	1930(ra) # 80004eb8 <begin_op>
  iput(p->cwd);
    80002736:	6485                	lui	s1,0x1
    80002738:	009909b3          	add	s3,s2,s1
    8000273c:	fc89b503          	ld	a0,-56(s3)
    80002740:	00002097          	auipc	ra,0x2
    80002744:	f58080e7          	jalr	-168(ra) # 80004698 <iput>
  end_op();
    80002748:	00002097          	auipc	ra,0x2
    8000274c:	7f0080e7          	jalr	2032(ra) # 80004f38 <end_op>
  p->cwd = 0;
    80002750:	fc09b423          	sd	zero,-56(s3)
  acquire(&wait_lock);
    80002754:	00010517          	auipc	a0,0x10
    80002758:	b6450513          	addi	a0,a0,-1180 # 800122b8 <wait_lock>
    8000275c:	ffffe097          	auipc	ra,0xffffe
    80002760:	46e080e7          	jalr	1134(ra) # 80000bca <acquire>
  reparent(p);
    80002764:	854a                	mv	a0,s2
    80002766:	00000097          	auipc	ra,0x0
    8000276a:	e6c080e7          	jalr	-404(ra) # 800025d2 <reparent>
  wakeup(p->parent);
    8000276e:	f289b503          	ld	a0,-216(s3)
    80002772:	00000097          	auipc	ra,0x0
    80002776:	db6080e7          	jalr	-586(ra) # 80002528 <wakeup>
  acquire(&p->lock);
    8000277a:	854a                	mv	a0,s2
    8000277c:	ffffe097          	auipc	ra,0xffffe
    80002780:	44e080e7          	jalr	1102(ra) # 80000bca <acquire>
  p->xstate = status;
    80002784:	03492023          	sw	s4,32(s2)
  p->state = ZOMBIE;
    80002788:	4795                	li	a5,5
    8000278a:	00f92c23          	sw	a5,24(s2)
  for(t=p->threads; t < &p->threads[NTHREAD]; t++){
    8000278e:	02890793          	addi	a5,s2,40
    80002792:	f2848493          	addi	s1,s1,-216 # f28 <_entry-0x7ffff0d8>
    80002796:	9926                	add	s2,s2,s1
    t->state = ZOMBIE;
    80002798:	4715                	li	a4,5
    8000279a:	c398                	sw	a4,0(a5)
  for(t=p->threads; t < &p->threads[NTHREAD]; t++){
    8000279c:	1e078793          	addi	a5,a5,480
    800027a0:	fef91de3          	bne	s2,a5,8000279a <exit+0xcc>
  release(&wait_lock);
    800027a4:	00010517          	auipc	a0,0x10
    800027a8:	b1450513          	addi	a0,a0,-1260 # 800122b8 <wait_lock>
    800027ac:	ffffe097          	auipc	ra,0xffffe
    800027b0:	4d8080e7          	jalr	1240(ra) # 80000c84 <release>
  sched();
    800027b4:	00000097          	auipc	ra,0x0
    800027b8:	a94080e7          	jalr	-1388(ra) # 80002248 <sched>
  panic("zombie exit");
    800027bc:	00007517          	auipc	a0,0x7
    800027c0:	b1c50513          	addi	a0,a0,-1252 # 800092d8 <digits+0x298>
    800027c4:	ffffe097          	auipc	ra,0xffffe
    800027c8:	d66080e7          	jalr	-666(ra) # 8000052a <panic>

00000000800027cc <kill>:
kill(int pid, int signum)
{
  //printf("debug: starting kill function\n");
  struct proc *p;

  if(signum >= SIGNALS_SIZE || signum < 0) return -1;
    800027cc:	47fd                	li	a5,31
    800027ce:	08b7ef63          	bltu	a5,a1,8000286c <kill+0xa0>
{
    800027d2:	7139                	addi	sp,sp,-64
    800027d4:	fc06                	sd	ra,56(sp)
    800027d6:	f822                	sd	s0,48(sp)
    800027d8:	f426                	sd	s1,40(sp)
    800027da:	f04a                	sd	s2,32(sp)
    800027dc:	ec4e                	sd	s3,24(sp)
    800027de:	e852                	sd	s4,16(sp)
    800027e0:	e456                	sd	s5,8(sp)
    800027e2:	0080                	addi	s0,sp,64
    800027e4:	892a                	mv	s2,a0
    800027e6:	8aae                	mv	s5,a1

  for(p = proc; p < &proc[NPROC]; p++){
    800027e8:	00010497          	auipc	s1,0x10
    800027ec:	f7048493          	addi	s1,s1,-144 # 80012758 <proc>
    800027f0:	6985                	lui	s3,0x1
    800027f2:	17898993          	addi	s3,s3,376 # 1178 <_entry-0x7fffee88>
    800027f6:	00056a17          	auipc	s4,0x56
    800027fa:	d62a0a13          	addi	s4,s4,-670 # 80058558 <tickslock>
    acquire(&p->lock);
    800027fe:	8526                	mv	a0,s1
    80002800:	ffffe097          	auipc	ra,0xffffe
    80002804:	3ca080e7          	jalr	970(ra) # 80000bca <acquire>
    if(p->pid == pid){
    80002808:	50dc                	lw	a5,36(s1)
    8000280a:	01278c63          	beq	a5,s2,80002822 <kill+0x56>
      p->pendingSignals |= (1 << signum);

      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000280e:	8526                	mv	a0,s1
    80002810:	ffffe097          	auipc	ra,0xffffe
    80002814:	474080e7          	jalr	1140(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002818:	94ce                	add	s1,s1,s3
    8000281a:	ff4492e3          	bne	s1,s4,800027fe <kill+0x32>
  }
  return -1;
    8000281e:	557d                	li	a0,-1
    80002820:	a025                	j	80002848 <kill+0x7c>
      if(signum == SIGKILL){
    80002822:	47a5                	li	a5,9
    80002824:	02fa8b63          	beq	s5,a5,8000285a <kill+0x8e>
      p->pendingSignals |= (1 << signum);
    80002828:	6785                	lui	a5,0x1
    8000282a:	97a6                	add	a5,a5,s1
    8000282c:	4705                	li	a4,1
    8000282e:	015716bb          	sllw	a3,a4,s5
    80002832:	fe07a703          	lw	a4,-32(a5) # fe0 <_entry-0x7ffff020>
    80002836:	8f55                	or	a4,a4,a3
    80002838:	fee7a023          	sw	a4,-32(a5)
      release(&p->lock);
    8000283c:	8526                	mv	a0,s1
    8000283e:	ffffe097          	auipc	ra,0xffffe
    80002842:	446080e7          	jalr	1094(ra) # 80000c84 <release>
      return 0;
    80002846:	4501                	li	a0,0
}
    80002848:	70e2                	ld	ra,56(sp)
    8000284a:	7442                	ld	s0,48(sp)
    8000284c:	74a2                	ld	s1,40(sp)
    8000284e:	7902                	ld	s2,32(sp)
    80002850:	69e2                	ld	s3,24(sp)
    80002852:	6a42                	ld	s4,16(sp)
    80002854:	6aa2                	ld	s5,8(sp)
    80002856:	6121                	addi	sp,sp,64
    80002858:	8082                	ret
        p->killed = 1; 
    8000285a:	4785                	li	a5,1
    8000285c:	ccdc                	sw	a5,28(s1)
        if(p->state == SLEEPING){ //-----------------> Was in the previous version, according to the forum now it's redundant
    8000285e:	4c98                	lw	a4,24(s1)
    80002860:	4789                	li	a5,2
    80002862:	fcf713e3          	bne	a4,a5,80002828 <kill+0x5c>
          p->state = RUNNABLE;
    80002866:	478d                	li	a5,3
    80002868:	cc9c                	sw	a5,24(s1)
    8000286a:	bf7d                	j	80002828 <kill+0x5c>
  if(signum >= SIGNALS_SIZE || signum < 0) return -1;
    8000286c:	557d                	li	a0,-1
}
    8000286e:	8082                	ret

0000000080002870 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002870:	7179                	addi	sp,sp,-48
    80002872:	f406                	sd	ra,40(sp)
    80002874:	f022                	sd	s0,32(sp)
    80002876:	ec26                	sd	s1,24(sp)
    80002878:	e84a                	sd	s2,16(sp)
    8000287a:	e44e                	sd	s3,8(sp)
    8000287c:	e052                	sd	s4,0(sp)
    8000287e:	1800                	addi	s0,sp,48
    80002880:	84aa                	mv	s1,a0
    80002882:	892e                	mv	s2,a1
    80002884:	89b2                	mv	s3,a2
    80002886:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002888:	fffff097          	auipc	ra,0xfffff
    8000288c:	170080e7          	jalr	368(ra) # 800019f8 <myproc>
  if(user_dst){
    80002890:	c485                	beqz	s1,800028b8 <either_copyout+0x48>
    return copyout(p->pagetable, dst, src, len);
    80002892:	6785                	lui	a5,0x1
    80002894:	953e                	add	a0,a0,a5
    80002896:	86d2                	mv	a3,s4
    80002898:	864e                	mv	a2,s3
    8000289a:	85ca                	mv	a1,s2
    8000289c:	f4053503          	ld	a0,-192(a0)
    800028a0:	fffff097          	auipc	ra,0xfffff
    800028a4:	dac080e7          	jalr	-596(ra) # 8000164c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800028a8:	70a2                	ld	ra,40(sp)
    800028aa:	7402                	ld	s0,32(sp)
    800028ac:	64e2                	ld	s1,24(sp)
    800028ae:	6942                	ld	s2,16(sp)
    800028b0:	69a2                	ld	s3,8(sp)
    800028b2:	6a02                	ld	s4,0(sp)
    800028b4:	6145                	addi	sp,sp,48
    800028b6:	8082                	ret
    memmove((char *)dst, src, len);
    800028b8:	000a061b          	sext.w	a2,s4
    800028bc:	85ce                	mv	a1,s3
    800028be:	854a                	mv	a0,s2
    800028c0:	ffffe097          	auipc	ra,0xffffe
    800028c4:	468080e7          	jalr	1128(ra) # 80000d28 <memmove>
    return 0;
    800028c8:	8526                	mv	a0,s1
    800028ca:	bff9                	j	800028a8 <either_copyout+0x38>

00000000800028cc <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800028cc:	7179                	addi	sp,sp,-48
    800028ce:	f406                	sd	ra,40(sp)
    800028d0:	f022                	sd	s0,32(sp)
    800028d2:	ec26                	sd	s1,24(sp)
    800028d4:	e84a                	sd	s2,16(sp)
    800028d6:	e44e                	sd	s3,8(sp)
    800028d8:	e052                	sd	s4,0(sp)
    800028da:	1800                	addi	s0,sp,48
    800028dc:	892a                	mv	s2,a0
    800028de:	84ae                	mv	s1,a1
    800028e0:	89b2                	mv	s3,a2
    800028e2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800028e4:	fffff097          	auipc	ra,0xfffff
    800028e8:	114080e7          	jalr	276(ra) # 800019f8 <myproc>
  if(user_src){
    800028ec:	c485                	beqz	s1,80002914 <either_copyin+0x48>
    return copyin(p->pagetable, dst, src, len);
    800028ee:	6785                	lui	a5,0x1
    800028f0:	97aa                	add	a5,a5,a0
    800028f2:	86d2                	mv	a3,s4
    800028f4:	864e                	mv	a2,s3
    800028f6:	85ca                	mv	a1,s2
    800028f8:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    800028fc:	fffff097          	auipc	ra,0xfffff
    80002900:	ddc080e7          	jalr	-548(ra) # 800016d8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002904:	70a2                	ld	ra,40(sp)
    80002906:	7402                	ld	s0,32(sp)
    80002908:	64e2                	ld	s1,24(sp)
    8000290a:	6942                	ld	s2,16(sp)
    8000290c:	69a2                	ld	s3,8(sp)
    8000290e:	6a02                	ld	s4,0(sp)
    80002910:	6145                	addi	sp,sp,48
    80002912:	8082                	ret
    memmove(dst, (char*)src, len);
    80002914:	000a061b          	sext.w	a2,s4
    80002918:	85ce                	mv	a1,s3
    8000291a:	854a                	mv	a0,s2
    8000291c:	ffffe097          	auipc	ra,0xffffe
    80002920:	40c080e7          	jalr	1036(ra) # 80000d28 <memmove>
    return 0;
    80002924:	8526                	mv	a0,s1
    80002926:	bff9                	j	80002904 <either_copyin+0x38>

0000000080002928 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002928:	715d                	addi	sp,sp,-80
    8000292a:	e486                	sd	ra,72(sp)
    8000292c:	e0a2                	sd	s0,64(sp)
    8000292e:	fc26                	sd	s1,56(sp)
    80002930:	f84a                	sd	s2,48(sp)
    80002932:	f44e                	sd	s3,40(sp)
    80002934:	f052                	sd	s4,32(sp)
    80002936:	ec56                	sd	s5,24(sp)
    80002938:	e85a                	sd	s6,16(sp)
    8000293a:	e45e                	sd	s7,8(sp)
    8000293c:	e062                	sd	s8,0(sp)
    8000293e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002940:	00007517          	auipc	a0,0x7
    80002944:	96850513          	addi	a0,a0,-1688 # 800092a8 <digits+0x268>
    80002948:	ffffe097          	auipc	ra,0xffffe
    8000294c:	c2c080e7          	jalr	-980(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002950:	00010497          	auipc	s1,0x10
    80002954:	e0848493          	addi	s1,s1,-504 # 80012758 <proc>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002958:	4b95                	li	s7,5
      state = states[p->state];
    else
      state = "???";
    8000295a:	00007a17          	auipc	s4,0x7
    8000295e:	98ea0a13          	addi	s4,s4,-1650 # 800092e8 <digits+0x2a8>
    printf("%d %s %s", p->pid, state, p->name);
    80002962:	6905                	lui	s2,0x1
    80002964:	fd090b13          	addi	s6,s2,-48 # fd0 <_entry-0x7ffff030>
    80002968:	00007a97          	auipc	s5,0x7
    8000296c:	988a8a93          	addi	s5,s5,-1656 # 800092f0 <digits+0x2b0>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002970:	00007c17          	auipc	s8,0x7
    80002974:	a08c0c13          	addi	s8,s8,-1528 # 80009378 <states.0>
  for(p = proc; p < &proc[NPROC]; p++){
    80002978:	17890913          	addi	s2,s2,376
    8000297c:	00056997          	auipc	s3,0x56
    80002980:	bdc98993          	addi	s3,s3,-1060 # 80058558 <tickslock>
    80002984:	a025                	j	800029ac <procdump+0x84>
    printf("%d %s %s", p->pid, state, p->name);
    80002986:	016486b3          	add	a3,s1,s6
    8000298a:	50cc                	lw	a1,36(s1)
    8000298c:	8556                	mv	a0,s5
    8000298e:	ffffe097          	auipc	ra,0xffffe
    80002992:	be6080e7          	jalr	-1050(ra) # 80000574 <printf>
    printf("\n");
    80002996:	00007517          	auipc	a0,0x7
    8000299a:	91250513          	addi	a0,a0,-1774 # 800092a8 <digits+0x268>
    8000299e:	ffffe097          	auipc	ra,0xffffe
    800029a2:	bd6080e7          	jalr	-1066(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800029a6:	94ca                	add	s1,s1,s2
    800029a8:	03348063          	beq	s1,s3,800029c8 <procdump+0xa0>
    if(p->state == UNUSED)
    800029ac:	4c9c                	lw	a5,24(s1)
    800029ae:	dfe5                	beqz	a5,800029a6 <procdump+0x7e>
      state = "???";
    800029b0:	8652                	mv	a2,s4
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029b2:	fcfbeae3          	bltu	s7,a5,80002986 <procdump+0x5e>
    800029b6:	02079713          	slli	a4,a5,0x20
    800029ba:	01d75793          	srli	a5,a4,0x1d
    800029be:	97e2                	add	a5,a5,s8
    800029c0:	6390                	ld	a2,0(a5)
    800029c2:	f271                	bnez	a2,80002986 <procdump+0x5e>
      state = "???";
    800029c4:	8652                	mv	a2,s4
    800029c6:	b7c1                	j	80002986 <procdump+0x5e>
  }
}
    800029c8:	60a6                	ld	ra,72(sp)
    800029ca:	6406                	ld	s0,64(sp)
    800029cc:	74e2                	ld	s1,56(sp)
    800029ce:	7942                	ld	s2,48(sp)
    800029d0:	79a2                	ld	s3,40(sp)
    800029d2:	7a02                	ld	s4,32(sp)
    800029d4:	6ae2                	ld	s5,24(sp)
    800029d6:	6b42                	ld	s6,16(sp)
    800029d8:	6ba2                	ld	s7,8(sp)
    800029da:	6c02                	ld	s8,0(sp)
    800029dc:	6161                	addi	sp,sp,80
    800029de:	8082                	ret

00000000800029e0 <sigprocmask>:

uint
sigprocmask(uint sigmask){
    800029e0:	1101                	addi	sp,sp,-32
    800029e2:	ec06                	sd	ra,24(sp)
    800029e4:	e822                	sd	s0,16(sp)
    800029e6:	e426                	sd	s1,8(sp)
    800029e8:	1000                	addi	s0,sp,32
    800029ea:	84aa                	mv	s1,a0

  struct proc* p = myproc ();
    800029ec:	fffff097          	auipc	ra,0xfffff
    800029f0:	00c080e7          	jalr	12(ra) # 800019f8 <myproc>
  uint oldMask = p->signalMask;
    800029f4:	6785                	lui	a5,0x1
    800029f6:	97aa                	add	a5,a5,a0
    800029f8:	fe47a503          	lw	a0,-28(a5) # fe4 <_entry-0x7ffff01c>
  p->signalMask = sigmask;
    800029fc:	fe97a223          	sw	s1,-28(a5)
  return oldMask;
}
    80002a00:	60e2                	ld	ra,24(sp)
    80002a02:	6442                	ld	s0,16(sp)
    80002a04:	64a2                	ld	s1,8(sp)
    80002a06:	6105                	addi	sp,sp,32
    80002a08:	8082                	ret

0000000080002a0a <sigaction>:
sigaction(int signum, const struct sigaction *act, struct sigaction *oldact){

  // printf ("signum is: %d\nact adress is: %d\noldact address is: %d\n", signum,act,oldact);
  // Check that signum in the correct range

  if (signum < 0 || signum >= 32)
    80002a0a:	0005079b          	sext.w	a5,a0
    80002a0e:	477d                	li	a4,31
    80002a10:	0ef76763          	bltu	a4,a5,80002afe <sigaction+0xf4>
sigaction(int signum, const struct sigaction *act, struct sigaction *oldact){
    80002a14:	7139                	addi	sp,sp,-64
    80002a16:	fc06                	sd	ra,56(sp)
    80002a18:	f822                	sd	s0,48(sp)
    80002a1a:	f426                	sd	s1,40(sp)
    80002a1c:	f04a                	sd	s2,32(sp)
    80002a1e:	ec4e                	sd	s3,24(sp)
    80002a20:	e852                	sd	s4,16(sp)
    80002a22:	0080                	addi	s0,sp,64
    80002a24:	84aa                	mv	s1,a0
    80002a26:	8a2e                	mv	s4,a1
    80002a28:	89b2                	mv	s3,a2
    return -1;

  if (signum == SIGSTOP || signum == SIGKILL)
    80002a2a:	37dd                	addiw	a5,a5,-9
    80002a2c:	9bdd                	andi	a5,a5,-9
    80002a2e:	2781                	sext.w	a5,a5
    80002a30:	cbe9                	beqz	a5,80002b02 <sigaction+0xf8>
      return -1;

  struct proc* p = myproc ();
    80002a32:	fffff097          	auipc	ra,0xfffff
    80002a36:	fc6080e7          	jalr	-58(ra) # 800019f8 <myproc>
    80002a3a:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002a3c:	ffffe097          	auipc	ra,0xffffe
    80002a40:	18e080e7          	jalr	398(ra) # 80000bca <acquire>

  if (oldact){
    80002a44:	04098d63          	beqz	s3,80002a9e <sigaction+0x94>

    struct sigaction oldSig;
    oldSig.sa_handler = p->signalHandlers[signum];
    80002a48:	1fc48793          	addi	a5,s1,508
    80002a4c:	078e                	slli	a5,a5,0x3
    80002a4e:	97ca                	add	a5,a5,s2
    80002a50:	679c                	ld	a5,8(a5)
    80002a52:	fcf43023          	sd	a5,-64(s0)
    oldSig.sigmask = p->maskHandlers[signum];
    80002a56:	43c48793          	addi	a5,s1,1084
    80002a5a:	078a                	slli	a5,a5,0x2
    80002a5c:	97ca                	add	a5,a5,s2
    80002a5e:	43dc                	lw	a5,4(a5)
    80002a60:	fcf42423          	sw	a5,-56(s0)

    if (copyout(p->pagetable, (uint64) oldact, (char*)&oldSig.sa_handler, sizeof(8)) < 0)
    80002a64:	6785                	lui	a5,0x1
    80002a66:	97ca                	add	a5,a5,s2
    80002a68:	4691                	li	a3,4
    80002a6a:	fc040613          	addi	a2,s0,-64
    80002a6e:	85ce                	mv	a1,s3
    80002a70:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80002a74:	fffff097          	auipc	ra,0xfffff
    80002a78:	bd8080e7          	jalr	-1064(ra) # 8000164c <copyout>
    80002a7c:	06054d63          	bltz	a0,80002af6 <sigaction+0xec>
      return -1;

    if (copyout(p->pagetable, (uint64) oldact+8, (char*)&oldSig.sigmask, sizeof(uint)) < 0)
    80002a80:	6785                	lui	a5,0x1
    80002a82:	97ca                	add	a5,a5,s2
    80002a84:	4691                	li	a3,4
    80002a86:	fc840613          	addi	a2,s0,-56
    80002a8a:	00898593          	addi	a1,s3,8
    80002a8e:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80002a92:	fffff097          	auipc	ra,0xfffff
    80002a96:	bba080e7          	jalr	-1094(ra) # 8000164c <copyout>
    80002a9a:	04054e63          	bltz	a0,80002af6 <sigaction+0xec>
      return -1;  
  }
  if (act){
    80002a9e:	020a0e63          	beqz	s4,80002ada <sigaction+0xd0>
    struct sigaction newSig;
    if(copyin(p->pagetable,(char*)&newSig, (uint64)act, sizeof(struct sigaction))<0)
    80002aa2:	6785                	lui	a5,0x1
    80002aa4:	97ca                	add	a5,a5,s2
    80002aa6:	46c1                	li	a3,16
    80002aa8:	8652                	mv	a2,s4
    80002aaa:	fc040593          	addi	a1,s0,-64
    80002aae:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80002ab2:	fffff097          	auipc	ra,0xfffff
    80002ab6:	c26080e7          	jalr	-986(ra) # 800016d8 <copyin>
    80002aba:	04054063          	bltz	a0,80002afa <sigaction+0xf0>
      return -1;

    if(newSig.sigmask <0)
      return -1;

    p->signalHandlers[signum] = newSig.sa_handler;
    80002abe:	1fc48793          	addi	a5,s1,508
    80002ac2:	078e                	slli	a5,a5,0x3
    80002ac4:	97ca                	add	a5,a5,s2
    80002ac6:	fc043703          	ld	a4,-64(s0)
    80002aca:	e798                	sd	a4,8(a5)

    p->maskHandlers[signum] = newSig.sigmask;
    80002acc:	43c48493          	addi	s1,s1,1084
    80002ad0:	048a                	slli	s1,s1,0x2
    80002ad2:	94ca                	add	s1,s1,s2
    80002ad4:	fc842783          	lw	a5,-56(s0)
    80002ad8:	c0dc                	sw	a5,4(s1)
  }
  release(&p->lock);
    80002ada:	854a                	mv	a0,s2
    80002adc:	ffffe097          	auipc	ra,0xffffe
    80002ae0:	1a8080e7          	jalr	424(ra) # 80000c84 <release>
  return 0;
    80002ae4:	4501                	li	a0,0
}
    80002ae6:	70e2                	ld	ra,56(sp)
    80002ae8:	7442                	ld	s0,48(sp)
    80002aea:	74a2                	ld	s1,40(sp)
    80002aec:	7902                	ld	s2,32(sp)
    80002aee:	69e2                	ld	s3,24(sp)
    80002af0:	6a42                	ld	s4,16(sp)
    80002af2:	6121                	addi	sp,sp,64
    80002af4:	8082                	ret
      return -1;
    80002af6:	557d                	li	a0,-1
    80002af8:	b7fd                	j	80002ae6 <sigaction+0xdc>
      return -1;
    80002afa:	557d                	li	a0,-1
    80002afc:	b7ed                	j	80002ae6 <sigaction+0xdc>
    return -1;
    80002afe:	557d                	li	a0,-1
}
    80002b00:	8082                	ret
      return -1;
    80002b02:	557d                	li	a0,-1
    80002b04:	b7cd                	j	80002ae6 <sigaction+0xdc>

0000000080002b06 <sigret>:


void
sigret (void){
    80002b06:	1101                	addi	sp,sp,-32
    80002b08:	ec06                	sd	ra,24(sp)
    80002b0a:	e822                	sd	s0,16(sp)
    80002b0c:	e426                	sd	s1,8(sp)
    80002b0e:	e04a                	sd	s2,0(sp)
    80002b10:	1000                	addi	s0,sp,32
  struct proc* p = myproc();
    80002b12:	fffff097          	auipc	ra,0xfffff
    80002b16:	ee6080e7          	jalr	-282(ra) # 800019f8 <myproc>
    80002b1a:	84aa                	mv	s1,a0
  struct thread* t = mythread();
    80002b1c:	fffff097          	auipc	ra,0xfffff
    80002b20:	f72080e7          	jalr	-142(ra) # 80001a8e <mythread>
    80002b24:	892a                	mv	s2,a0
  printf("sig ret\n");
    80002b26:	00006517          	auipc	a0,0x6
    80002b2a:	7da50513          	addi	a0,a0,2010 # 80009300 <digits+0x2c0>
    80002b2e:	ffffe097          	auipc	ra,0xffffe
    80002b32:	a46080e7          	jalr	-1466(ra) # 80000574 <printf>
  *t->trapframe = t->UserTrapFrameBackup;
    80002b36:	04090793          	addi	a5,s2,64
    80002b3a:	03893703          	ld	a4,56(s2)
    80002b3e:	16090913          	addi	s2,s2,352
    80002b42:	6388                	ld	a0,0(a5)
    80002b44:	678c                	ld	a1,8(a5)
    80002b46:	6b90                	ld	a2,16(a5)
    80002b48:	6f94                	ld	a3,24(a5)
    80002b4a:	e308                	sd	a0,0(a4)
    80002b4c:	e70c                	sd	a1,8(a4)
    80002b4e:	eb10                	sd	a2,16(a4)
    80002b50:	ef14                	sd	a3,24(a4)
    80002b52:	02078793          	addi	a5,a5,32
    80002b56:	02070713          	addi	a4,a4,32
    80002b5a:	ff2794e3          	bne	a5,s2,80002b42 <sigret+0x3c>
  // memmove(p->trapframe, p->UserTrapFrameBackup, sizeof(struct trapframe));
  // if(copyin(p->pagetable,(char*)p->trapframe, (uint64)p->UserTrapFrameBackup, sizeof(struct trapframe)) < 0)
  // printf("fopyin doesnt work\n");
  p->signalMask = p->signal_mask_backup;
    80002b5e:	6505                	lui	a0,0x1
    80002b60:	9526                	add	a0,a0,s1
    80002b62:	0ec52783          	lw	a5,236(a0) # 10ec <_entry-0x7fffef14>
    80002b66:	fef52223          	sw	a5,-28(a0)
  p->ignore_signals = 0;
    80002b6a:	0e052823          	sw	zero,240(a0)
}
    80002b6e:	60e2                	ld	ra,24(sp)
    80002b70:	6442                	ld	s0,16(sp)
    80002b72:	64a2                	ld	s1,8(sp)
    80002b74:	6902                	ld	s2,0(sp)
    80002b76:	6105                	addi	sp,sp,32
    80002b78:	8082                	ret

0000000080002b7a <usersignal>:

void usersignal(struct thread *t, int signum){
    80002b7a:	7179                	addi	sp,sp,-48
    80002b7c:	f406                	sd	ra,40(sp)
    80002b7e:	f022                	sd	s0,32(sp)
    80002b80:	ec26                	sd	s1,24(sp)
    80002b82:	e84a                	sd	s2,16(sp)
    80002b84:	e44e                	sd	s3,8(sp)
    80002b86:	e052                	sd	s4,0(sp)
    80002b88:	1800                	addi	s0,sp,48
    80002b8a:	84aa                	mv	s1,a0
    80002b8c:	89ae                	mv	s3,a1

  struct proc *p = t->proc_parent;
    80002b8e:	02853a03          	ld	s4,40(a0)
  // Extract sigmask from sigaction, and backup the old signal mask
  p->signal_mask_backup = p->signalMask;
    80002b92:	6905                	lui	s2,0x1
    80002b94:	9952                	add	s2,s2,s4
    80002b96:	fe492783          	lw	a5,-28(s2) # fe4 <_entry-0x7ffff01c>
    80002b9a:	0ef92623          	sw	a5,236(s2)
  p->signalMask = p->maskHandlers[signum];
    80002b9e:	43c58793          	addi	a5,a1,1084
    80002ba2:	078a                	slli	a5,a5,0x2
    80002ba4:	97d2                	add	a5,a5,s4
    80002ba6:	43dc                	lw	a5,4(a5)
    80002ba8:	fef92223          	sw	a5,-28(s2)

  // indicate that the process is at "signal handling" by turn on a flag
  p->ignore_signals = 1;
    80002bac:	4785                	li	a5,1
    80002bae:	0ef92823          	sw	a5,240(s2)

  // copy the current process trapframe, to the trapframe backup 
  memmove(&t->UserTrapFrameBackup, t->trapframe, sizeof(struct trapframe));
    80002bb2:	12000613          	li	a2,288
    80002bb6:	7d0c                	ld	a1,56(a0)
    80002bb8:	04050513          	addi	a0,a0,64
    80002bbc:	ffffe097          	auipc	ra,0xffffe
    80002bc0:	16c080e7          	jalr	364(ra) # 80000d28 <memmove>

  // Extract handler from signalHandlers, and updated saved user pc to point to signal handler
  t->trapframe->epc = (uint64)p->signalHandlers[signum];
    80002bc4:	7c98                	ld	a4,56(s1)
    80002bc6:	1fc98793          	addi	a5,s3,508
    80002bca:	078e                	slli	a5,a5,0x3
    80002bcc:	9a3e                	add	s4,s4,a5
    80002bce:	008a3783          	ld	a5,8(s4)
    80002bd2:	ef1c                	sd	a5,24(a4)

  // Calculate the size of sig_ret
  uint sigret_size = end_ret - start_ret;

  // Reduce stack pointer by size of function sigret and copy out function to user stack
  t->trapframe->sp -= sigret_size;
    80002bd4:	7c98                	ld	a4,56(s1)
  uint sigret_size = end_ret - start_ret;
    80002bd6:	00004617          	auipc	a2,0x4
    80002bda:	fb060613          	addi	a2,a2,-80 # 80006b86 <start_ret>
    80002bde:	00004697          	auipc	a3,0x4
    80002be2:	fae68693          	addi	a3,a3,-82 # 80006b8c <free_desc>
    80002be6:	8e91                	sub	a3,a3,a2
  t->trapframe->sp -= sigret_size;
    80002be8:	1682                	slli	a3,a3,0x20
    80002bea:	9281                	srli	a3,a3,0x20
    80002bec:	7b1c                	ld	a5,48(a4)
    80002bee:	8f95                	sub	a5,a5,a3
    80002bf0:	fb1c                	sd	a5,48(a4)
  copyout(p->pagetable, t->trapframe->sp, (char *)&start_ret, sigret_size);
    80002bf2:	7c9c                	ld	a5,56(s1)
    80002bf4:	7b8c                	ld	a1,48(a5)
    80002bf6:	f4093503          	ld	a0,-192(s2)
    80002bfa:	fffff097          	auipc	ra,0xfffff
    80002bfe:	a52080e7          	jalr	-1454(ra) # 8000164c <copyout>

  // parameter = signum
  t->trapframe->a0 = signum;
    80002c02:	7c9c                	ld	a5,56(s1)
    80002c04:	0737b823          	sd	s3,112(a5)

  // update return address so that after handler finishes it will jump to sigret  
  t->trapframe->ra = t->trapframe->sp;
    80002c08:	7c9c                	ld	a5,56(s1)
    80002c0a:	7b98                	ld	a4,48(a5)
    80002c0c:	f798                	sd	a4,40(a5)

}
    80002c0e:	70a2                	ld	ra,40(sp)
    80002c10:	7402                	ld	s0,32(sp)
    80002c12:	64e2                	ld	s1,24(sp)
    80002c14:	6942                	ld	s2,16(sp)
    80002c16:	69a2                	ld	s3,8(sp)
    80002c18:	6a02                	ld	s4,0(sp)
    80002c1a:	6145                	addi	sp,sp,48
    80002c1c:	8082                	ret

0000000080002c1e <stopSignal>:

void stopSignal(struct proc *p){
    80002c1e:	1141                	addi	sp,sp,-16
    80002c20:	e422                	sd	s0,8(sp)
    80002c22:	0800                	addi	s0,sp,16

  p->stopped = 1;
    80002c24:	6785                	lui	a5,0x1
    80002c26:	953e                	add	a0,a0,a5
    80002c28:	4785                	li	a5,1
    80002c2a:	0ef52423          	sw	a5,232(a0)

}
    80002c2e:	6422                	ld	s0,8(sp)
    80002c30:	0141                	addi	sp,sp,16
    80002c32:	8082                	ret

0000000080002c34 <contSignal>:

void contSignal(struct proc *p){
    80002c34:	1141                	addi	sp,sp,-16
    80002c36:	e422                	sd	s0,8(sp)
    80002c38:	0800                	addi	s0,sp,16

  p->stopped = 0;
    80002c3a:	6785                	lui	a5,0x1
    80002c3c:	953e                	add	a0,a0,a5
    80002c3e:	0e052423          	sw	zero,232(a0)

}
    80002c42:	6422                	ld	s0,8(sp)
    80002c44:	0141                	addi	sp,sp,16
    80002c46:	8082                	ret

0000000080002c48 <handling_signals>:


void handling_signals(){
    80002c48:	711d                	addi	sp,sp,-96
    80002c4a:	ec86                	sd	ra,88(sp)
    80002c4c:	e8a2                	sd	s0,80(sp)
    80002c4e:	e4a6                	sd	s1,72(sp)
    80002c50:	e0ca                	sd	s2,64(sp)
    80002c52:	fc4e                	sd	s3,56(sp)
    80002c54:	f852                	sd	s4,48(sp)
    80002c56:	f456                	sd	s5,40(sp)
    80002c58:	f05a                	sd	s6,32(sp)
    80002c5a:	ec5e                	sd	s7,24(sp)
    80002c5c:	e862                	sd	s8,16(sp)
    80002c5e:	e466                	sd	s9,8(sp)
    80002c60:	e06a                	sd	s10,0(sp)
    80002c62:	1080                	addi	s0,sp,96
  struct proc *p = myproc();
    80002c64:	fffff097          	auipc	ra,0xfffff
    80002c68:	d94080e7          	jalr	-620(ra) # 800019f8 <myproc>

  // ass2
  
  // If first process or all signals are ignored -> return
  if((p == 0) || (p->signalMask == 0xffffffff) || p->ignore_signals) return;
    80002c6c:	10050063          	beqz	a0,80002d6c <handling_signals+0x124>
    80002c70:	8baa                	mv	s7,a0
    80002c72:	6785                	lui	a5,0x1
    80002c74:	97aa                	add	a5,a5,a0
    80002c76:	fe47a783          	lw	a5,-28(a5) # fe4 <_entry-0x7ffff01c>
    80002c7a:	577d                	li	a4,-1
    80002c7c:	0ee78863          	beq	a5,a4,80002d6c <handling_signals+0x124>
    80002c80:	6705                	lui	a4,0x1
    80002c82:	972a                	add	a4,a4,a0
    80002c84:	0f072483          	lw	s1,240(a4) # 10f0 <_entry-0x7fffef10>
    80002c88:	e0f5                	bnez	s1,80002d6c <handling_signals+0x124>

  // Check if stopped and has a pending SIGCONT signal, if none are received, it will yield the CPU.
  if(p->stopped && !(p->signalMask & (1 << SIGSTOP))) {
    80002c8a:	6705                	lui	a4,0x1
    80002c8c:	972a                	add	a4,a4,a0
    80002c8e:	0e872703          	lw	a4,232(a4) # 10e8 <_entry-0x7fffef18>
    80002c92:	c339                	beqz	a4,80002cd8 <handling_signals+0x90>
    80002c94:	83c5                	srli	a5,a5,0x11
    80002c96:	8b85                	andi	a5,a5,1
    80002c98:	e3a1                	bnez	a5,80002cd8 <handling_signals+0x90>
    int cont_pend;
    while(1){   
      // acquire(&p->lock);
      cont_pend = p->pendingSignals & (1 << SIGCONT);
    80002c9a:	6785                	lui	a5,0x1
    80002c9c:	97aa                	add	a5,a5,a0
    80002c9e:	fe07a703          	lw	a4,-32(a5) # fe0 <_entry-0x7ffff020>
    80002ca2:	01375793          	srli	a5,a4,0x13
      if(cont_pend){
    80002ca6:	8b85                	andi	a5,a5,1
      cont_pend = p->pendingSignals & (1 << SIGCONT);
    80002ca8:	6905                	lui	s2,0x1
    80002caa:	992a                	add	s2,s2,a0
    80002cac:	000809b7          	lui	s3,0x80
      if(cont_pend){
    80002cb0:	eb99                	bnez	a5,80002cc6 <handling_signals+0x7e>
        // release(&p->lock);
        break;
      }
      else{
        // release(&p->lock);
        yield();
    80002cb2:	fffff097          	auipc	ra,0xfffff
    80002cb6:	68e080e7          	jalr	1678(ra) # 80002340 <yield>
      cont_pend = p->pendingSignals & (1 << SIGCONT);
    80002cba:	fe092703          	lw	a4,-32(s2) # fe0 <_entry-0x7ffff020>
    80002cbe:	013777b3          	and	a5,a4,s3
      if(cont_pend){
    80002cc2:	2781                	sext.w	a5,a5
    80002cc4:	d7fd                	beqz	a5,80002cb2 <handling_signals+0x6a>
        p->stopped = 0;
    80002cc6:	6785                	lui	a5,0x1
    80002cc8:	97de                	add	a5,a5,s7
    80002cca:	0e07a423          	sw	zero,232(a5) # 10e8 <_entry-0x7fffef18>
        p->pendingSignals ^= (1 << SIGCONT);
    80002cce:	000806b7          	lui	a3,0x80
    80002cd2:	8f35                	xor	a4,a4,a3
    80002cd4:	fee7a023          	sw	a4,-32(a5)
      }
    }
  }

  for(int sig = 0 ; sig < SIGNALS_SIZE ; sig++){
    80002cd8:	6985                	lui	s3,0x1
    80002cda:	19a1                	addi	s3,s3,-24
    80002cdc:	99de                	add	s3,s3,s7
    uint pandSigs = p->pendingSignals;
    uint sigMask = p->signalMask;
    // check if panding for the i'th signal and it's not blocked.
    if( (pandSigs & (1 << sig)) && !(sigMask & (1 << sig)) ){
    80002cde:	4b05                	li	s6,1
    uint pandSigs = p->pendingSignals;
    80002ce0:	6a05                	lui	s4,0x1
    80002ce2:	9a5e                	add	s4,s4,s7
            break;
        }
        //turning bit of pending singal off
        p->pendingSignals ^= (1 << sig); 
      }
      else if (p->signalHandlers[sig] != (void*)SIG_IGN){
    80002ce4:	4c05                	li	s8,1
        switch(sig)
    80002ce6:	4d45                	li	s10,17
    80002ce8:	4ccd                	li	s9,19
  for(int sig = 0 ; sig < SIGNALS_SIZE ; sig++){
    80002cea:	02000a93          	li	s5,32
    80002cee:	a80d                	j	80002d20 <handling_signals+0xd8>
        switch(sig)
    80002cf0:	01a48c63          	beq	s1,s10,80002d08 <handling_signals+0xc0>
    80002cf4:	07948963          	beq	s1,s9,80002d66 <handling_signals+0x11e>
            kill(p->pid, SIGKILL);
    80002cf8:	45a5                	li	a1,9
    80002cfa:	024ba503          	lw	a0,36(s7)
    80002cfe:	00000097          	auipc	ra,0x0
    80002d02:	ace080e7          	jalr	-1330(ra) # 800027cc <kill>
            break;
    80002d06:	a019                	j	80002d0c <handling_signals+0xc4>
  p->stopped = 1;
    80002d08:	0f8a2423          	sw	s8,232(s4) # 10e8 <_entry-0x7fffef18>
        p->pendingSignals ^= (1 << sig); 
    80002d0c:	fe0a2783          	lw	a5,-32(s4)
    80002d10:	0127c933          	xor	s2,a5,s2
    80002d14:	ff2a2023          	sw	s2,-32(s4)
  for(int sig = 0 ; sig < SIGNALS_SIZE ; sig++){
    80002d18:	2485                	addiw	s1,s1,1
    80002d1a:	09a1                	addi	s3,s3,8
    80002d1c:	05548863          	beq	s1,s5,80002d6c <handling_signals+0x124>
    if( (pandSigs & (1 << sig)) && !(sigMask & (1 << sig)) ){
    80002d20:	009b193b          	sllw	s2,s6,s1
    80002d24:	fe0a2783          	lw	a5,-32(s4)
    80002d28:	0127f7b3          	and	a5,a5,s2
    80002d2c:	2781                	sext.w	a5,a5
    80002d2e:	d7ed                	beqz	a5,80002d18 <handling_signals+0xd0>
    80002d30:	fe4a2783          	lw	a5,-28(s4)
    80002d34:	0127f7b3          	and	a5,a5,s2
    80002d38:	2781                	sext.w	a5,a5
    80002d3a:	fff9                	bnez	a5,80002d18 <handling_signals+0xd0>
      if(p->signalHandlers[sig] == (void*)SIG_DFL){
    80002d3c:	0009b783          	ld	a5,0(s3) # 1000 <_entry-0x7ffff000>
    80002d40:	dbc5                	beqz	a5,80002cf0 <handling_signals+0xa8>
      else if (p->signalHandlers[sig] != (void*)SIG_IGN){
    80002d42:	fd878be3          	beq	a5,s8,80002d18 <handling_signals+0xd0>
        usersignal(mythread(), sig);
    80002d46:	fffff097          	auipc	ra,0xfffff
    80002d4a:	d48080e7          	jalr	-696(ra) # 80001a8e <mythread>
    80002d4e:	85a6                	mv	a1,s1
    80002d50:	00000097          	auipc	ra,0x0
    80002d54:	e2a080e7          	jalr	-470(ra) # 80002b7a <usersignal>
        p->pendingSignals ^= (1 << sig); //turning bit off
    80002d58:	fe0a2783          	lw	a5,-32(s4)
    80002d5c:	0127c933          	xor	s2,a5,s2
    80002d60:	ff2a2023          	sw	s2,-32(s4)
    80002d64:	bf55                	j	80002d18 <handling_signals+0xd0>
  p->stopped = 0;
    80002d66:	0e0a2423          	sw	zero,232(s4)
}
    80002d6a:	b74d                	j	80002d0c <handling_signals+0xc4>
      }
    }
  }
}
    80002d6c:	60e6                	ld	ra,88(sp)
    80002d6e:	6446                	ld	s0,80(sp)
    80002d70:	64a6                	ld	s1,72(sp)
    80002d72:	6906                	ld	s2,64(sp)
    80002d74:	79e2                	ld	s3,56(sp)
    80002d76:	7a42                	ld	s4,48(sp)
    80002d78:	7aa2                	ld	s5,40(sp)
    80002d7a:	7b02                	ld	s6,32(sp)
    80002d7c:	6be2                	ld	s7,24(sp)
    80002d7e:	6c42                	ld	s8,16(sp)
    80002d80:	6ca2                	ld	s9,8(sp)
    80002d82:	6d02                	ld	s10,0(sp)
    80002d84:	6125                	addi	sp,sp,96
    80002d86:	8082                	ret

0000000080002d88 <bsem_alloc>:

int bsems[MAX_BSEM] = {[0 ... MAX_BSEM-1] = -1};

// Alloc bsem and make it a 1.

int bsem_alloc(){
    80002d88:	1101                	addi	sp,sp,-32
    80002d8a:	ec06                	sd	ra,24(sp)
    80002d8c:	e822                	sd	s0,16(sp)
    80002d8e:	e426                	sd	s1,8(sp)
    80002d90:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80002d92:	0000f517          	auipc	a0,0xf
    80002d96:	50e50513          	addi	a0,a0,1294 # 800122a0 <pid_lock>
    80002d9a:	ffffe097          	auipc	ra,0xffffe
    80002d9e:	e30080e7          	jalr	-464(ra) # 80000bca <acquire>
  for (int i = 0; i < MAX_BSEM; i++) {
    80002da2:	00007797          	auipc	a5,0x7
    80002da6:	bf678793          	addi	a5,a5,-1034 # 80009998 <bsems>
    80002daa:	4481                	li	s1,0
	  if (bsems[i] == -1) {
    80002dac:	56fd                	li	a3,-1
  for (int i = 0; i < MAX_BSEM; i++) {
    80002dae:	08000613          	li	a2,128
	  if (bsems[i] == -1) {
    80002db2:	4398                	lw	a4,0(a5)
    80002db4:	02d70063          	beq	a4,a3,80002dd4 <bsem_alloc+0x4c>
  for (int i = 0; i < MAX_BSEM; i++) {
    80002db8:	2485                	addiw	s1,s1,1
    80002dba:	0791                	addi	a5,a5,4
    80002dbc:	fec49be3          	bne	s1,a2,80002db2 <bsem_alloc+0x2a>
	  	bsems[i] = 1;
      release(&pid_lock);
	  	return i;
	  } 
	}
  release(&pid_lock);
    80002dc0:	0000f517          	auipc	a0,0xf
    80002dc4:	4e050513          	addi	a0,a0,1248 # 800122a0 <pid_lock>
    80002dc8:	ffffe097          	auipc	ra,0xffffe
    80002dcc:	ebc080e7          	jalr	-324(ra) # 80000c84 <release>
  return -1;
    80002dd0:	54fd                	li	s1,-1
    80002dd2:	a015                	j	80002df6 <bsem_alloc+0x6e>
	  	bsems[i] = 1;
    80002dd4:	00249713          	slli	a4,s1,0x2
    80002dd8:	00007797          	auipc	a5,0x7
    80002ddc:	b8878793          	addi	a5,a5,-1144 # 80009960 <initcode>
    80002de0:	97ba                	add	a5,a5,a4
    80002de2:	4705                	li	a4,1
    80002de4:	df98                	sw	a4,56(a5)
      release(&pid_lock);
    80002de6:	0000f517          	auipc	a0,0xf
    80002dea:	4ba50513          	addi	a0,a0,1210 # 800122a0 <pid_lock>
    80002dee:	ffffe097          	auipc	ra,0xffffe
    80002df2:	e96080e7          	jalr	-362(ra) # 80000c84 <release>
}
    80002df6:	8526                	mv	a0,s1
    80002df8:	60e2                	ld	ra,24(sp)
    80002dfa:	6442                	ld	s0,16(sp)
    80002dfc:	64a2                	ld	s1,8(sp)
    80002dfe:	6105                	addi	sp,sp,32
    80002e00:	8082                	ret

0000000080002e02 <bsem_free>:

// Free bsem make it -1 again.

void bsem_free(int i){
    80002e02:	1101                	addi	sp,sp,-32
    80002e04:	ec06                	sd	ra,24(sp)
    80002e06:	e822                	sd	s0,16(sp)
    80002e08:	e426                	sd	s1,8(sp)
    80002e0a:	e04a                	sd	s2,0(sp)
    80002e0c:	1000                	addi	s0,sp,32
    80002e0e:	84aa                	mv	s1,a0
  acquire(&pid_lock);
    80002e10:	0000f917          	auipc	s2,0xf
    80002e14:	49090913          	addi	s2,s2,1168 # 800122a0 <pid_lock>
    80002e18:	854a                	mv	a0,s2
    80002e1a:	ffffe097          	auipc	ra,0xffffe
    80002e1e:	db0080e7          	jalr	-592(ra) # 80000bca <acquire>
  bsems[i] = -1;
    80002e22:	048a                	slli	s1,s1,0x2
    80002e24:	00007517          	auipc	a0,0x7
    80002e28:	b3c50513          	addi	a0,a0,-1220 # 80009960 <initcode>
    80002e2c:	94aa                	add	s1,s1,a0
    80002e2e:	57fd                	li	a5,-1
    80002e30:	dc9c                	sw	a5,56(s1)
  release(&pid_lock);
    80002e32:	854a                	mv	a0,s2
    80002e34:	ffffe097          	auipc	ra,0xffffe
    80002e38:	e50080e7          	jalr	-432(ra) # 80000c84 <release>
}
    80002e3c:	60e2                	ld	ra,24(sp)
    80002e3e:	6442                	ld	s0,16(sp)
    80002e40:	64a2                	ld	s1,8(sp)
    80002e42:	6902                	ld	s2,0(sp)
    80002e44:	6105                	addi	sp,sp,32
    80002e46:	8082                	ret

0000000080002e48 <bsem_down>:

/* While so that only one thread will continue. 
   sleep on chanel of kind spinlock, with lock pid_lock */

void bsem_down(int i){
    80002e48:	7179                	addi	sp,sp,-48
    80002e4a:	f406                	sd	ra,40(sp)
    80002e4c:	f022                	sd	s0,32(sp)
    80002e4e:	ec26                	sd	s1,24(sp)
    80002e50:	e84a                	sd	s2,16(sp)
    80002e52:	e44e                	sd	s3,8(sp)
    80002e54:	e052                	sd	s4,0(sp)
    80002e56:	1800                	addi	s0,sp,48
    80002e58:	8a2a                	mv	s4,a0
  acquire(&pid_lock);
    80002e5a:	0000f517          	auipc	a0,0xf
    80002e5e:	44650513          	addi	a0,a0,1094 # 800122a0 <pid_lock>
    80002e62:	ffffe097          	auipc	ra,0xffffe
    80002e66:	d68080e7          	jalr	-664(ra) # 80000bca <acquire>
  while(bsems[i] == 0){
    80002e6a:	002a1713          	slli	a4,s4,0x2
    80002e6e:	00007797          	auipc	a5,0x7
    80002e72:	af278793          	addi	a5,a5,-1294 # 80009960 <initcode>
    80002e76:	97ba                	add	a5,a5,a4
    80002e78:	5f9c                	lw	a5,56(a5)
    80002e7a:	e795                	bnez	a5,80002ea6 <bsem_down+0x5e>
    sleep(&chanel, &pid_lock);
    80002e7c:	0000f997          	auipc	s3,0xf
    80002e80:	42498993          	addi	s3,s3,1060 # 800122a0 <pid_lock>
    80002e84:	00010917          	auipc	s2,0x10
    80002e88:	8a490913          	addi	s2,s2,-1884 # 80012728 <chanel>
  while(bsems[i] == 0){
    80002e8c:	00007497          	auipc	s1,0x7
    80002e90:	ad448493          	addi	s1,s1,-1324 # 80009960 <initcode>
    80002e94:	94ba                	add	s1,s1,a4
    sleep(&chanel, &pid_lock);
    80002e96:	85ce                	mv	a1,s3
    80002e98:	854a                	mv	a0,s2
    80002e9a:	fffff097          	auipc	ra,0xfffff
    80002e9e:	4e4080e7          	jalr	1252(ra) # 8000237e <sleep>
  while(bsems[i] == 0){
    80002ea2:	5c9c                	lw	a5,56(s1)
    80002ea4:	dbed                	beqz	a5,80002e96 <bsem_down+0x4e>
  }
  bsems[i] = 0;
    80002ea6:	0a0a                	slli	s4,s4,0x2
    80002ea8:	00007797          	auipc	a5,0x7
    80002eac:	ab878793          	addi	a5,a5,-1352 # 80009960 <initcode>
    80002eb0:	9a3e                	add	s4,s4,a5
    80002eb2:	020a2c23          	sw	zero,56(s4)
  release(&pid_lock);
    80002eb6:	0000f517          	auipc	a0,0xf
    80002eba:	3ea50513          	addi	a0,a0,1002 # 800122a0 <pid_lock>
    80002ebe:	ffffe097          	auipc	ra,0xffffe
    80002ec2:	dc6080e7          	jalr	-570(ra) # 80000c84 <release>
}
    80002ec6:	70a2                	ld	ra,40(sp)
    80002ec8:	7402                	ld	s0,32(sp)
    80002eca:	64e2                	ld	s1,24(sp)
    80002ecc:	6942                	ld	s2,16(sp)
    80002ece:	69a2                	ld	s3,8(sp)
    80002ed0:	6a02                	ld	s4,0(sp)
    80002ed2:	6145                	addi	sp,sp,48
    80002ed4:	8082                	ret

0000000080002ed6 <bsem_up>:

// Turn bsems[i] on and wake up thread that is sleeping on chanel and waiting for bsems[i].

void bsem_up(int i){
    80002ed6:	1101                	addi	sp,sp,-32
    80002ed8:	ec06                	sd	ra,24(sp)
    80002eda:	e822                	sd	s0,16(sp)
    80002edc:	e426                	sd	s1,8(sp)
    80002ede:	e04a                	sd	s2,0(sp)
    80002ee0:	1000                	addi	s0,sp,32
    80002ee2:	84aa                	mv	s1,a0
  acquire(&pid_lock);
    80002ee4:	0000f917          	auipc	s2,0xf
    80002ee8:	3bc90913          	addi	s2,s2,956 # 800122a0 <pid_lock>
    80002eec:	854a                	mv	a0,s2
    80002eee:	ffffe097          	auipc	ra,0xffffe
    80002ef2:	cdc080e7          	jalr	-804(ra) # 80000bca <acquire>
  bsems[i] = 1;
    80002ef6:	048a                	slli	s1,s1,0x2
    80002ef8:	00007517          	auipc	a0,0x7
    80002efc:	a6850513          	addi	a0,a0,-1432 # 80009960 <initcode>
    80002f00:	94aa                	add	s1,s1,a0
    80002f02:	4785                	li	a5,1
    80002f04:	dc9c                	sw	a5,56(s1)
  wakeup(&chanel);
    80002f06:	00010517          	auipc	a0,0x10
    80002f0a:	82250513          	addi	a0,a0,-2014 # 80012728 <chanel>
    80002f0e:	fffff097          	auipc	ra,0xfffff
    80002f12:	61a080e7          	jalr	1562(ra) # 80002528 <wakeup>
  release(&pid_lock);
    80002f16:	854a                	mv	a0,s2
    80002f18:	ffffe097          	auipc	ra,0xffffe
    80002f1c:	d6c080e7          	jalr	-660(ra) # 80000c84 <release>
}
    80002f20:	60e2                	ld	ra,24(sp)
    80002f22:	6442                	ld	s0,16(sp)
    80002f24:	64a2                	ld	s1,8(sp)
    80002f26:	6902                	ld	s2,0(sp)
    80002f28:	6105                	addi	sp,sp,32
    80002f2a:	8082                	ret

0000000080002f2c <kthread_create>:

  return t;
}

int
kthread_create (void ( *start_func)(), void *stack ){
    80002f2c:	715d                	addi	sp,sp,-80
    80002f2e:	e486                	sd	ra,72(sp)
    80002f30:	e0a2                	sd	s0,64(sp)
    80002f32:	fc26                	sd	s1,56(sp)
    80002f34:	f84a                	sd	s2,48(sp)
    80002f36:	f44e                	sd	s3,40(sp)
    80002f38:	f052                	sd	s4,32(sp)
    80002f3a:	ec56                	sd	s5,24(sp)
    80002f3c:	e85a                	sd	s6,16(sp)
    80002f3e:	e45e                	sd	s7,8(sp)
    80002f40:	0880                	addi	s0,sp,80
    80002f42:	8b2a                	mv	s6,a0
    80002f44:	8aae                	mv	s5,a1
  struct thread *curr_thread = mythread();
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	b48080e7          	jalr	-1208(ra) # 80001a8e <mythread>
    80002f4e:	8a2a                	mv	s4,a0
  struct proc *p = curr_thread->proc_parent;
    80002f50:	02853903          	ld	s2,40(a0)
  acquire(&p->lock);
    80002f54:	854a                	mv	a0,s2
    80002f56:	ffffe097          	auipc	ra,0xffffe
    80002f5a:	c74080e7          	jalr	-908(ra) # 80000bca <acquire>
  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
    80002f5e:	02890993          	addi	s3,s2,40
    80002f62:	6705                	lui	a4,0x1
    80002f64:	f2870713          	addi	a4,a4,-216 # f28 <_entry-0x7ffff0d8>
    80002f68:	974a                	add	a4,a4,s2
    80002f6a:	84ce                	mv	s1,s3
    if(t->state == UNUSED || t->state == ZOMBIE) {
    80002f6c:	4695                	li	a3,5
    80002f6e:	409c                	lw	a5,0(s1)
    80002f70:	cb9d                	beqz	a5,80002fa6 <kthread_create+0x7a>
    80002f72:	02d78a63          	beq	a5,a3,80002fa6 <kthread_create+0x7a>
  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
    80002f76:	1e048493          	addi	s1,s1,480
    80002f7a:	fee49ae3          	bne	s1,a4,80002f6e <kthread_create+0x42>
  release(&p->lock);
    80002f7e:	854a                	mv	a0,s2
    80002f80:	ffffe097          	auipc	ra,0xffffe
    80002f84:	d04080e7          	jalr	-764(ra) # 80000c84 <release>
  return 0;
    80002f88:	4481                	li	s1,0
  struct thread *t = allocthread (start_func, stack);
  t->state = RUNNABLE;
    80002f8a:	478d                	li	a5,3
    80002f8c:	c09c                	sw	a5,0(s1)
  if(t == 0)
    return -1;
  return t->tid;
}
    80002f8e:	4c88                	lw	a0,24(s1)
    80002f90:	60a6                	ld	ra,72(sp)
    80002f92:	6406                	ld	s0,64(sp)
    80002f94:	74e2                	ld	s1,56(sp)
    80002f96:	7942                	ld	s2,48(sp)
    80002f98:	79a2                	ld	s3,40(sp)
    80002f9a:	7a02                	ld	s4,32(sp)
    80002f9c:	6ae2                	ld	s5,24(sp)
    80002f9e:	6b42                	ld	s6,16(sp)
    80002fa0:	6ba2                	ld	s7,8(sp)
    80002fa2:	6161                	addi	sp,sp,80
    80002fa4:	8082                	ret
  t->tid = alloctid();
    80002fa6:	fffff097          	auipc	ra,0xfffff
    80002faa:	b6e080e7          	jalr	-1170(ra) # 80001b14 <alloctid>
    80002fae:	cc88                	sw	a0,24(s1)
  t->state = USED;
    80002fb0:	4785                	li	a5,1
    80002fb2:	c09c                	sw	a5,0(s1)
  t->proc_parent = p;
    80002fb4:	0324b423          	sd	s2,40(s1)
  t->thread_parent = curr_thread;
    80002fb8:	0344b023          	sd	s4,32(s1)
  release(&p->lock);
    80002fbc:	854a                	mv	a0,s2
    80002fbe:	ffffe097          	auipc	ra,0xffffe
    80002fc2:	cc6080e7          	jalr	-826(ra) # 80000c84 <release>
  if((t->kstack = (uint64) kalloc()) == 0){
    80002fc6:	ffffe097          	auipc	ra,0xffffe
    80002fca:	b0c080e7          	jalr	-1268(ra) # 80000ad2 <kalloc>
    80002fce:	8baa                	mv	s7,a0
    80002fd0:	f888                	sd	a0,48(s1)
    80002fd2:	c92d                	beqz	a0,80003044 <kthread_create+0x118>
  t->trapframe = p->threads->trapframe + (sizeof(struct trapframe) * (int)(t-p->threads));
    80002fd4:	41348533          	sub	a0,s1,s3
    80002fd8:	8515                	srai	a0,a0,0x5
    80002fda:	00006797          	auipc	a5,0x6
    80002fde:	02e7b783          	ld	a5,46(a5) # 80009008 <etext+0x8>
    80002fe2:	02f5053b          	mulw	a0,a0,a5
    80002fe6:	67d1                	lui	a5,0x14
    80002fe8:	40078793          	addi	a5,a5,1024 # 14400 <_entry-0x7ffebc00>
    80002fec:	02f50533          	mul	a0,a0,a5
    80002ff0:	06093783          	ld	a5,96(s2)
    80002ff4:	953e                	add	a0,a0,a5
    80002ff6:	fc88                	sd	a0,56(s1)
  memmove ((void *) t->trapframe, (void*) curr_thread->trapframe, sizeof(struct trapframe));
    80002ff8:	12000613          	li	a2,288
    80002ffc:	038a3583          	ld	a1,56(s4)
    80003000:	ffffe097          	auipc	ra,0xffffe
    80003004:	d28080e7          	jalr	-728(ra) # 80000d28 <memmove>
  memset(&t->context, 0, sizeof(t->context));
    80003008:	07000613          	li	a2,112
    8000300c:	4581                	li	a1,0
    8000300e:	16048513          	addi	a0,s1,352
    80003012:	ffffe097          	auipc	ra,0xffffe
    80003016:	cba080e7          	jalr	-838(ra) # 80000ccc <memset>
  t->context.ra = (uint64)forkret;
    8000301a:	fffff797          	auipc	a5,0xfffff
    8000301e:	a1e78793          	addi	a5,a5,-1506 # 80001a38 <forkret>
    80003022:	16f4b023          	sd	a5,352(s1)
  t->context.sp = t->kstack + PGSIZE;
    80003026:	6785                	lui	a5,0x1
    80003028:	7898                	ld	a4,48(s1)
    8000302a:	973e                	add	a4,a4,a5
    8000302c:	16e4b423          	sd	a4,360(s1)
  t->trapframe->epc = (uint64) start_func;
    80003030:	7c98                	ld	a4,56(s1)
    80003032:	01673c23          	sd	s6,24(a4)
  t->trapframe->sp = (uint64) stack + MAX_STACK_SIZE; 
    80003036:	7c98                	ld	a4,56(s1)
    80003038:	fa078793          	addi	a5,a5,-96 # fa0 <_entry-0x7ffff060>
    8000303c:	9abe                	add	s5,s5,a5
    8000303e:	03573823          	sd	s5,48(a4)
  return t;
    80003042:	b7a1                	j	80002f8a <kthread_create+0x5e>
    freethread(t);
    80003044:	8526                	mv	a0,s1
    80003046:	ffffe097          	auipc	ra,0xffffe
    8000304a:	7d4080e7          	jalr	2004(ra) # 8000181a <freethread>
    release(&p->lock);
    8000304e:	854a                	mv	a0,s2
    80003050:	ffffe097          	auipc	ra,0xffffe
    80003054:	c34080e7          	jalr	-972(ra) # 80000c84 <release>
    return 0;
    80003058:	84de                	mv	s1,s7
    8000305a:	bf05                	j	80002f8a <kthread_create+0x5e>

000000008000305c <kthread_id>:

int
kthread_id(){
    8000305c:	1141                	addi	sp,sp,-16
    8000305e:	e406                	sd	ra,8(sp)
    80003060:	e022                	sd	s0,0(sp)
    80003062:	0800                	addi	s0,sp,16
  return mythread()->tid;
    80003064:	fffff097          	auipc	ra,0xfffff
    80003068:	a2a080e7          	jalr	-1494(ra) # 80001a8e <mythread>
}
    8000306c:	4d08                	lw	a0,24(a0)
    8000306e:	60a2                	ld	ra,8(sp)
    80003070:	6402                	ld	s0,0(sp)
    80003072:	0141                	addi	sp,sp,16
    80003074:	8082                	ret

0000000080003076 <kthread_exit>:

void
kthread_exit(int status){
    80003076:	7179                	addi	sp,sp,-48
    80003078:	f406                	sd	ra,40(sp)
    8000307a:	f022                	sd	s0,32(sp)
    8000307c:	ec26                	sd	s1,24(sp)
    8000307e:	e84a                	sd	s2,16(sp)
    80003080:	e44e                	sd	s3,8(sp)
    80003082:	1800                	addi	s0,sp,48
    80003084:	89aa                	mv	s3,a0
  struct thread *t = mythread();
    80003086:	fffff097          	auipc	ra,0xfffff
    8000308a:	a08080e7          	jalr	-1528(ra) # 80001a8e <mythread>
    8000308e:	84aa                	mv	s1,a0
  printf("inside exit for tid: %d\n", t->tid);
    80003090:	4d0c                	lw	a1,24(a0)
    80003092:	00006517          	auipc	a0,0x6
    80003096:	27e50513          	addi	a0,a0,638 # 80009310 <digits+0x2d0>
    8000309a:	ffffd097          	auipc	ra,0xffffd
    8000309e:	4da080e7          	jalr	1242(ra) # 80000574 <printf>
  struct proc *p = t->proc_parent;
    800030a2:	0284b903          	ld	s2,40(s1)

  acquire(&wait_lock);
    800030a6:	0000f517          	auipc	a0,0xf
    800030aa:	21250513          	addi	a0,a0,530 # 800122b8 <wait_lock>
    800030ae:	ffffe097          	auipc	ra,0xffffe
    800030b2:	b1c080e7          	jalr	-1252(ra) # 80000bca <acquire>

  Treparent (t);
    800030b6:	8526                	mv	a0,s1
    800030b8:	fffff097          	auipc	ra,0xfffff
    800030bc:	57c080e7          	jalr	1404(ra) # 80002634 <Treparent>

    // Parent might be sleeping in wait().
  if(t->thread_parent)
    800030c0:	7088                	ld	a0,32(s1)
    800030c2:	c509                	beqz	a0,800030cc <kthread_exit+0x56>
    wakeup(t->thread_parent);
    800030c4:	fffff097          	auipc	ra,0xfffff
    800030c8:	464080e7          	jalr	1124(ra) # 80002528 <wakeup>

  t->xstate = status;
    800030cc:	0134aa23          	sw	s3,20(s1)
  t->state = ZOMBIE;
    800030d0:	4795                	li	a5,5
    800030d2:	c09c                	sw	a5,0(s1)
  printf("update status for tid: %d\n", t->tid);
    800030d4:	4c8c                	lw	a1,24(s1)
    800030d6:	00006517          	auipc	a0,0x6
    800030da:	25a50513          	addi	a0,a0,602 # 80009330 <digits+0x2f0>
    800030de:	ffffd097          	auipc	ra,0xffffd
    800030e2:	496080e7          	jalr	1174(ra) # 80000574 <printf>
    // Check if this is the last thread of the process
  struct thread * tt;
  acquire(&p->lock);
    800030e6:	854a                	mv	a0,s2
    800030e8:	ffffe097          	auipc	ra,0xffffe
    800030ec:	ae2080e7          	jalr	-1310(ra) # 80000bca <acquire>
  for (tt = p->threads; tt < &p->threads[NTHREAD]; tt++){
    800030f0:	02890793          	addi	a5,s2,40
    800030f4:	6685                	lui	a3,0x1
    800030f6:	f2868693          	addi	a3,a3,-216 # f28 <_entry-0x7ffff0d8>
    800030fa:	96ca                	add	a3,a3,s2
      if(tt->state == USED || tt->state == SLEEPING || tt->state == RUNNABLE || tt->state == RUNNING){
    800030fc:	460d                	li	a2,3
    800030fe:	4398                	lw	a4,0(a5)
    80003100:	377d                	addiw	a4,a4,-1
    80003102:	02e67863          	bgeu	a2,a4,80003132 <kthread_exit+0xbc>
  for (tt = p->threads; tt < &p->threads[NTHREAD]; tt++){
    80003106:	1e078793          	addi	a5,a5,480
    8000310a:	fef69ae3          	bne	a3,a5,800030fe <kthread_exit+0x88>
        goto found;
      }
  }
    //not found an active thread, should terminate the process
  release(&p->lock);
    8000310e:	854a                	mv	a0,s2
    80003110:	ffffe097          	auipc	ra,0xffffe
    80003114:	b74080e7          	jalr	-1164(ra) # 80000c84 <release>
  release(&wait_lock);
    80003118:	0000f517          	auipc	a0,0xf
    8000311c:	1a050513          	addi	a0,a0,416 # 800122b8 <wait_lock>
    80003120:	ffffe097          	auipc	ra,0xffffe
    80003124:	b64080e7          	jalr	-1180(ra) # 80000c84 <release>
  exit(0);
    80003128:	4501                	li	a0,0
    8000312a:	fffff097          	auipc	ra,0xfffff
    8000312e:	5a4080e7          	jalr	1444(ra) # 800026ce <exit>
  panic("zombie exit");

  found:
  release(&wait_lock);
    80003132:	0000f517          	auipc	a0,0xf
    80003136:	18650513          	addi	a0,a0,390 # 800122b8 <wait_lock>
    8000313a:	ffffe097          	auipc	ra,0xffffe
    8000313e:	b4a080e7          	jalr	-1206(ra) # 80000c84 <release>

    // Jump into the scheduler, never to return.
  sched();
    80003142:	fffff097          	auipc	ra,0xfffff
    80003146:	106080e7          	jalr	262(ra) # 80002248 <sched>
  panic("zombie exit");
    8000314a:	00006517          	auipc	a0,0x6
    8000314e:	18e50513          	addi	a0,a0,398 # 800092d8 <digits+0x298>
    80003152:	ffffd097          	auipc	ra,0xffffd
    80003156:	3d8080e7          	jalr	984(ra) # 8000052a <panic>

000000008000315a <kthread_join>:
}

int
kthread_join (int thread_id, int *status){
    8000315a:	1101                	addi	sp,sp,-32
    8000315c:	ec06                	sd	ra,24(sp)
    8000315e:	e822                	sd	s0,16(sp)
    80003160:	e426                	sd	s1,8(sp)
    80003162:	e04a                	sd	s2,0(sp)
    80003164:	1000                	addi	s0,sp,32
    80003166:	84aa                	mv	s1,a0
  struct thread *t = mythread();
    80003168:	fffff097          	auipc	ra,0xfffff
    8000316c:	926080e7          	jalr	-1754(ra) # 80001a8e <mythread>
  struct proc *p = t->proc_parent;
    80003170:	02853903          	ld	s2,40(a0)

    // Check if there's a thread with the thread_id
  struct thread * tt;
  acquire(&p->lock);
    80003174:	854a                	mv	a0,s2
    80003176:	ffffe097          	auipc	ra,0xffffe
    8000317a:	a54080e7          	jalr	-1452(ra) # 80000bca <acquire>
  for (tt = p->threads; tt < &p->threads[NTHREAD]; tt++){
    8000317e:	02890793          	addi	a5,s2,40
    80003182:	6685                	lui	a3,0x1
    80003184:	f2868693          	addi	a3,a3,-216 # f28 <_entry-0x7ffff0d8>
    80003188:	96ca                	add	a3,a3,s2
    if(tt->tid == thread_id){
    8000318a:	4f98                	lw	a4,24(a5)
    8000318c:	02970263          	beq	a4,s1,800031b0 <kthread_join+0x56>
  for (tt = p->threads; tt < &p->threads[NTHREAD]; tt++){
    80003190:	1e078793          	addi	a5,a5,480
    80003194:	fed79be3          	bne	a5,a3,8000318a <kthread_join+0x30>
    } else {
    }
  }

    // Means didn't find a thread of the process with this ID
  release(&p->lock);
    80003198:	854a                	mv	a0,s2
    8000319a:	ffffe097          	auipc	ra,0xffffe
    8000319e:	aea080e7          	jalr	-1302(ra) # 80000c84 <release>
  return -1;
    800031a2:	557d                	li	a0,-1
    *status = tt->xstate; 
    return 0;
  }
  goto sleeping;

    800031a4:	60e2                	ld	ra,24(sp)
    800031a6:	6442                	ld	s0,16(sp)
    800031a8:	64a2                	ld	s1,8(sp)
    800031aa:	6902                	ld	s2,0(sp)
    800031ac:	6105                	addi	sp,sp,32
    800031ae:	8082                	ret
  release(&p->lock);
    800031b0:	854a                	mv	a0,s2
    800031b2:	ffffe097          	auipc	ra,0xffffe
    800031b6:	ad2080e7          	jalr	-1326(ra) # 80000c84 <release>
    return 0;
    800031ba:	4501                	li	a0,0
    800031bc:	b7e5                	j	800031a4 <kthread_join+0x4a>

00000000800031be <swtch>:
    800031be:	00153023          	sd	ra,0(a0)
    800031c2:	00253423          	sd	sp,8(a0)
    800031c6:	e900                	sd	s0,16(a0)
    800031c8:	ed04                	sd	s1,24(a0)
    800031ca:	03253023          	sd	s2,32(a0)
    800031ce:	03353423          	sd	s3,40(a0)
    800031d2:	03453823          	sd	s4,48(a0)
    800031d6:	03553c23          	sd	s5,56(a0)
    800031da:	05653023          	sd	s6,64(a0)
    800031de:	05753423          	sd	s7,72(a0)
    800031e2:	05853823          	sd	s8,80(a0)
    800031e6:	05953c23          	sd	s9,88(a0)
    800031ea:	07a53023          	sd	s10,96(a0)
    800031ee:	07b53423          	sd	s11,104(a0)
    800031f2:	0005b083          	ld	ra,0(a1)
    800031f6:	0085b103          	ld	sp,8(a1)
    800031fa:	6980                	ld	s0,16(a1)
    800031fc:	6d84                	ld	s1,24(a1)
    800031fe:	0205b903          	ld	s2,32(a1)
    80003202:	0285b983          	ld	s3,40(a1)
    80003206:	0305ba03          	ld	s4,48(a1)
    8000320a:	0385ba83          	ld	s5,56(a1)
    8000320e:	0405bb03          	ld	s6,64(a1)
    80003212:	0485bb83          	ld	s7,72(a1)
    80003216:	0505bc03          	ld	s8,80(a1)
    8000321a:	0585bc83          	ld	s9,88(a1)
    8000321e:	0605bd03          	ld	s10,96(a1)
    80003222:	0685bd83          	ld	s11,104(a1)
    80003226:	8082                	ret

0000000080003228 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80003228:	1141                	addi	sp,sp,-16
    8000322a:	e406                	sd	ra,8(sp)
    8000322c:	e022                	sd	s0,0(sp)
    8000322e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80003230:	00006597          	auipc	a1,0x6
    80003234:	17858593          	addi	a1,a1,376 # 800093a8 <states.0+0x30>
    80003238:	00055517          	auipc	a0,0x55
    8000323c:	32050513          	addi	a0,a0,800 # 80058558 <tickslock>
    80003240:	ffffe097          	auipc	ra,0xffffe
    80003244:	8f2080e7          	jalr	-1806(ra) # 80000b32 <initlock>
}
    80003248:	60a2                	ld	ra,8(sp)
    8000324a:	6402                	ld	s0,0(sp)
    8000324c:	0141                	addi	sp,sp,16
    8000324e:	8082                	ret

0000000080003250 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80003250:	1141                	addi	sp,sp,-16
    80003252:	e422                	sd	s0,8(sp)
    80003254:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003256:	00003797          	auipc	a5,0x3
    8000325a:	7da78793          	addi	a5,a5,2010 # 80006a30 <kernelvec>
    8000325e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80003262:	6422                	ld	s0,8(sp)
    80003264:	0141                	addi	sp,sp,16
    80003266:	8082                	ret

0000000080003268 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80003268:	1101                	addi	sp,sp,-32
    8000326a:	ec06                	sd	ra,24(sp)
    8000326c:	e822                	sd	s0,16(sp)
    8000326e:	e426                	sd	s1,8(sp)
    80003270:	e04a                	sd	s2,0(sp)
    80003272:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80003274:	ffffe097          	auipc	ra,0xffffe
    80003278:	784080e7          	jalr	1924(ra) # 800019f8 <myproc>
    8000327c:	892a                	mv	s2,a0
  struct thread *t = mythread();
    8000327e:	fffff097          	auipc	ra,0xfffff
    80003282:	810080e7          	jalr	-2032(ra) # 80001a8e <mythread>
    80003286:	84aa                	mv	s1,a0
  handling_signals();
    80003288:	00000097          	auipc	ra,0x0
    8000328c:	9c0080e7          	jalr	-1600(ra) # 80002c48 <handling_signals>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003290:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003294:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003296:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    8000329a:	00005817          	auipc	a6,0x5
    8000329e:	d6680813          	addi	a6,a6,-666 # 80008000 <_trampoline>
    800032a2:	00005697          	auipc	a3,0x5
    800032a6:	d5e68693          	addi	a3,a3,-674 # 80008000 <_trampoline>
    800032aa:	410686b3          	sub	a3,a3,a6
    800032ae:	040007b7          	lui	a5,0x4000
    800032b2:	17fd                	addi	a5,a5,-1
    800032b4:	07b2                	slli	a5,a5,0xc
    800032b6:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800032b8:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  t->trapframe->kernel_satp = r_satp();         // kernel page table
    800032bc:	7c98                	ld	a4,56(s1)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800032be:	180026f3          	csrr	a3,satp
    800032c2:	e314                	sd	a3,0(a4)
  t->trapframe->kernel_sp = t->kstack + PGSIZE; // process's kernel stack
    800032c4:	7c98                	ld	a4,56(s1)
    800032c6:	6605                	lui	a2,0x1
    800032c8:	7894                	ld	a3,48(s1)
    800032ca:	96b2                	add	a3,a3,a2
    800032cc:	e714                	sd	a3,8(a4)
  t->trapframe->kernel_trap = (uint64)usertrap;
    800032ce:	7c98                	ld	a4,56(s1)
    800032d0:	00000697          	auipc	a3,0x0
    800032d4:	16268693          	addi	a3,a3,354 # 80003432 <usertrap>
    800032d8:	eb14                	sd	a3,16(a4)
  t->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800032da:	7c98                	ld	a4,56(s1)
  asm volatile("mv %0, tp" : "=r" (x) );
    800032dc:	8692                	mv	a3,tp
    800032de:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800032e0:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800032e4:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800032e8:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800032ec:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(t->trapframe->epc);
    800032f0:	7c98                	ld	a4,56(s1)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800032f2:	6f18                	ld	a4,24(a4)
    800032f4:	14171073          	csrw	sepc,a4

  

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800032f8:	964a                	add	a2,a2,s2
    800032fa:	f4063583          	ld	a1,-192(a2) # f40 <_entry-0x7ffff0c0>
    800032fe:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
  ((void (*)(uint64,uint64))fn)(TRAPFRAME + (sizeof(struct trapframe) * (t-p->threads)), satp);
    80003300:	02890513          	addi	a0,s2,40
    80003304:	40a48533          	sub	a0,s1,a0
    80003308:	8515                	srai	a0,a0,0x5
    8000330a:	00006497          	auipc	s1,0x6
    8000330e:	cfe4b483          	ld	s1,-770(s1) # 80009008 <etext+0x8>
    80003312:	02950533          	mul	a0,a0,s1
    80003316:	00351493          	slli	s1,a0,0x3
    8000331a:	9526                	add	a0,a0,s1
    8000331c:	0516                	slli	a0,a0,0x5
    8000331e:	020006b7          	lui	a3,0x2000
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80003322:	00005717          	auipc	a4,0x5
    80003326:	d6e70713          	addi	a4,a4,-658 # 80008090 <userret>
    8000332a:	41070733          	sub	a4,a4,a6
    8000332e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME + (sizeof(struct trapframe) * (t-p->threads)), satp);
    80003330:	577d                	li	a4,-1
    80003332:	177e                	slli	a4,a4,0x3f
    80003334:	8dd9                	or	a1,a1,a4
    80003336:	16fd                	addi	a3,a3,-1
    80003338:	06b6                	slli	a3,a3,0xd
    8000333a:	9536                	add	a0,a0,a3
    8000333c:	9782                	jalr	a5
}
    8000333e:	60e2                	ld	ra,24(sp)
    80003340:	6442                	ld	s0,16(sp)
    80003342:	64a2                	ld	s1,8(sp)
    80003344:	6902                	ld	s2,0(sp)
    80003346:	6105                	addi	sp,sp,32
    80003348:	8082                	ret

000000008000334a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000334a:	1101                	addi	sp,sp,-32
    8000334c:	ec06                	sd	ra,24(sp)
    8000334e:	e822                	sd	s0,16(sp)
    80003350:	e426                	sd	s1,8(sp)
    80003352:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80003354:	00055497          	auipc	s1,0x55
    80003358:	20448493          	addi	s1,s1,516 # 80058558 <tickslock>
    8000335c:	8526                	mv	a0,s1
    8000335e:	ffffe097          	auipc	ra,0xffffe
    80003362:	86c080e7          	jalr	-1940(ra) # 80000bca <acquire>
  ticks++;
    80003366:	00007517          	auipc	a0,0x7
    8000336a:	cca50513          	addi	a0,a0,-822 # 8000a030 <ticks>
    8000336e:	411c                	lw	a5,0(a0)
    80003370:	2785                	addiw	a5,a5,1
    80003372:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80003374:	fffff097          	auipc	ra,0xfffff
    80003378:	1b4080e7          	jalr	436(ra) # 80002528 <wakeup>
  release(&tickslock);
    8000337c:	8526                	mv	a0,s1
    8000337e:	ffffe097          	auipc	ra,0xffffe
    80003382:	906080e7          	jalr	-1786(ra) # 80000c84 <release>
}
    80003386:	60e2                	ld	ra,24(sp)
    80003388:	6442                	ld	s0,16(sp)
    8000338a:	64a2                	ld	s1,8(sp)
    8000338c:	6105                	addi	sp,sp,32
    8000338e:	8082                	ret

0000000080003390 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80003390:	1101                	addi	sp,sp,-32
    80003392:	ec06                	sd	ra,24(sp)
    80003394:	e822                	sd	s0,16(sp)
    80003396:	e426                	sd	s1,8(sp)
    80003398:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000339a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000339e:	00074d63          	bltz	a4,800033b8 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    800033a2:	57fd                	li	a5,-1
    800033a4:	17fe                	slli	a5,a5,0x3f
    800033a6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800033a8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800033aa:	06f70363          	beq	a4,a5,80003410 <devintr+0x80>
  }
}
    800033ae:	60e2                	ld	ra,24(sp)
    800033b0:	6442                	ld	s0,16(sp)
    800033b2:	64a2                	ld	s1,8(sp)
    800033b4:	6105                	addi	sp,sp,32
    800033b6:	8082                	ret
     (scause & 0xff) == 9){
    800033b8:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    800033bc:	46a5                	li	a3,9
    800033be:	fed792e3          	bne	a5,a3,800033a2 <devintr+0x12>
    int irq = plic_claim();
    800033c2:	00003097          	auipc	ra,0x3
    800033c6:	776080e7          	jalr	1910(ra) # 80006b38 <plic_claim>
    800033ca:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800033cc:	47a9                	li	a5,10
    800033ce:	02f50763          	beq	a0,a5,800033fc <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    800033d2:	4785                	li	a5,1
    800033d4:	02f50963          	beq	a0,a5,80003406 <devintr+0x76>
    return 1;
    800033d8:	4505                	li	a0,1
    } else if(irq){
    800033da:	d8f1                	beqz	s1,800033ae <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    800033dc:	85a6                	mv	a1,s1
    800033de:	00006517          	auipc	a0,0x6
    800033e2:	fd250513          	addi	a0,a0,-46 # 800093b0 <states.0+0x38>
    800033e6:	ffffd097          	auipc	ra,0xffffd
    800033ea:	18e080e7          	jalr	398(ra) # 80000574 <printf>
      plic_complete(irq);
    800033ee:	8526                	mv	a0,s1
    800033f0:	00003097          	auipc	ra,0x3
    800033f4:	76c080e7          	jalr	1900(ra) # 80006b5c <plic_complete>
    return 1;
    800033f8:	4505                	li	a0,1
    800033fa:	bf55                	j	800033ae <devintr+0x1e>
      uartintr();
    800033fc:	ffffd097          	auipc	ra,0xffffd
    80003400:	58a080e7          	jalr	1418(ra) # 80000986 <uartintr>
    80003404:	b7ed                	j	800033ee <devintr+0x5e>
      virtio_disk_intr();
    80003406:	00004097          	auipc	ra,0x4
    8000340a:	bee080e7          	jalr	-1042(ra) # 80006ff4 <virtio_disk_intr>
    8000340e:	b7c5                	j	800033ee <devintr+0x5e>
    if(cpuid() == 0){
    80003410:	ffffe097          	auipc	ra,0xffffe
    80003414:	5b4080e7          	jalr	1460(ra) # 800019c4 <cpuid>
    80003418:	c901                	beqz	a0,80003428 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000341a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000341e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80003420:	14479073          	csrw	sip,a5
    return 2;
    80003424:	4509                	li	a0,2
    80003426:	b761                	j	800033ae <devintr+0x1e>
      clockintr();
    80003428:	00000097          	auipc	ra,0x0
    8000342c:	f22080e7          	jalr	-222(ra) # 8000334a <clockintr>
    80003430:	b7ed                	j	8000341a <devintr+0x8a>

0000000080003432 <usertrap>:
{
    80003432:	1101                	addi	sp,sp,-32
    80003434:	ec06                	sd	ra,24(sp)
    80003436:	e822                	sd	s0,16(sp)
    80003438:	e426                	sd	s1,8(sp)
    8000343a:	e04a                	sd	s2,0(sp)
    8000343c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000343e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80003442:	1007f793          	andi	a5,a5,256
    80003446:	e3ad                	bnez	a5,800034a8 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003448:	00003797          	auipc	a5,0x3
    8000344c:	5e878793          	addi	a5,a5,1512 # 80006a30 <kernelvec>
    80003450:	10579073          	csrw	stvec,a5
  struct thread *t = mythread();
    80003454:	ffffe097          	auipc	ra,0xffffe
    80003458:	63a080e7          	jalr	1594(ra) # 80001a8e <mythread>
    8000345c:	84aa                	mv	s1,a0
  t->trapframe->epc = r_sepc();
    8000345e:	7d1c                	ld	a5,56(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003460:	14102773          	csrr	a4,sepc
    80003464:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003466:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000346a:	47a1                	li	a5,8
    8000346c:	04f71c63          	bne	a4,a5,800034c4 <usertrap+0x92>
    if(t->killed)
    80003470:	491c                	lw	a5,16(a0)
    80003472:	e3b9                	bnez	a5,800034b8 <usertrap+0x86>
    t->trapframe->epc += 4;
    80003474:	7c98                	ld	a4,56(s1)
    80003476:	6f1c                	ld	a5,24(a4)
    80003478:	0791                	addi	a5,a5,4
    8000347a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000347c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003480:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003484:	10079073          	csrw	sstatus,a5
    syscall();
    80003488:	00000097          	auipc	ra,0x0
    8000348c:	2f2080e7          	jalr	754(ra) # 8000377a <syscall>
  if(t->killed)
    80003490:	489c                	lw	a5,16(s1)
    80003492:	ebc1                	bnez	a5,80003522 <usertrap+0xf0>
  usertrapret();
    80003494:	00000097          	auipc	ra,0x0
    80003498:	dd4080e7          	jalr	-556(ra) # 80003268 <usertrapret>
}
    8000349c:	60e2                	ld	ra,24(sp)
    8000349e:	6442                	ld	s0,16(sp)
    800034a0:	64a2                	ld	s1,8(sp)
    800034a2:	6902                	ld	s2,0(sp)
    800034a4:	6105                	addi	sp,sp,32
    800034a6:	8082                	ret
    panic("usertrap: not from user mode");
    800034a8:	00006517          	auipc	a0,0x6
    800034ac:	f2850513          	addi	a0,a0,-216 # 800093d0 <states.0+0x58>
    800034b0:	ffffd097          	auipc	ra,0xffffd
    800034b4:	07a080e7          	jalr	122(ra) # 8000052a <panic>
      kthread_exit(-1);
    800034b8:	557d                	li	a0,-1
    800034ba:	00000097          	auipc	ra,0x0
    800034be:	bbc080e7          	jalr	-1092(ra) # 80003076 <kthread_exit>
    800034c2:	bf4d                	j	80003474 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    800034c4:	00000097          	auipc	ra,0x0
    800034c8:	ecc080e7          	jalr	-308(ra) # 80003390 <devintr>
    800034cc:	892a                	mv	s2,a0
    800034ce:	c501                	beqz	a0,800034d6 <usertrap+0xa4>
  if(t->killed)
    800034d0:	489c                	lw	a5,16(s1)
    800034d2:	c3a1                	beqz	a5,80003512 <usertrap+0xe0>
    800034d4:	a815                	j	80003508 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800034d6:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p tid=%d\n", r_scause(), t->tid);
    800034da:	4c90                	lw	a2,24(s1)
    800034dc:	00006517          	auipc	a0,0x6
    800034e0:	f1450513          	addi	a0,a0,-236 # 800093f0 <states.0+0x78>
    800034e4:	ffffd097          	auipc	ra,0xffffd
    800034e8:	090080e7          	jalr	144(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800034ec:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800034f0:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800034f4:	00006517          	auipc	a0,0x6
    800034f8:	f2c50513          	addi	a0,a0,-212 # 80009420 <states.0+0xa8>
    800034fc:	ffffd097          	auipc	ra,0xffffd
    80003500:	078080e7          	jalr	120(ra) # 80000574 <printf>
    t->killed = 1;
    80003504:	4785                	li	a5,1
    80003506:	c89c                	sw	a5,16(s1)
    kthread_exit(-1);
    80003508:	557d                	li	a0,-1
    8000350a:	00000097          	auipc	ra,0x0
    8000350e:	b6c080e7          	jalr	-1172(ra) # 80003076 <kthread_exit>
  if(which_dev == 2)
    80003512:	4789                	li	a5,2
    80003514:	f8f910e3          	bne	s2,a5,80003494 <usertrap+0x62>
    yield();
    80003518:	fffff097          	auipc	ra,0xfffff
    8000351c:	e28080e7          	jalr	-472(ra) # 80002340 <yield>
    80003520:	bf95                	j	80003494 <usertrap+0x62>
  int which_dev = 0;
    80003522:	4901                	li	s2,0
    80003524:	b7d5                	j	80003508 <usertrap+0xd6>

0000000080003526 <kerneltrap>:
{
    80003526:	7179                	addi	sp,sp,-48
    80003528:	f406                	sd	ra,40(sp)
    8000352a:	f022                	sd	s0,32(sp)
    8000352c:	ec26                	sd	s1,24(sp)
    8000352e:	e84a                	sd	s2,16(sp)
    80003530:	e44e                	sd	s3,8(sp)
    80003532:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003534:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003538:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000353c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80003540:	1004f793          	andi	a5,s1,256
    80003544:	cb85                	beqz	a5,80003574 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003546:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000354a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000354c:	ef85                	bnez	a5,80003584 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    8000354e:	00000097          	auipc	ra,0x0
    80003552:	e42080e7          	jalr	-446(ra) # 80003390 <devintr>
    80003556:	cd1d                	beqz	a0,80003594 <kerneltrap+0x6e>
  if(which_dev == 2 && mythread() != 0 && mythread()->state == RUNNING)
    80003558:	4789                	li	a5,2
    8000355a:	06f50a63          	beq	a0,a5,800035ce <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000355e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003562:	10049073          	csrw	sstatus,s1
}
    80003566:	70a2                	ld	ra,40(sp)
    80003568:	7402                	ld	s0,32(sp)
    8000356a:	64e2                	ld	s1,24(sp)
    8000356c:	6942                	ld	s2,16(sp)
    8000356e:	69a2                	ld	s3,8(sp)
    80003570:	6145                	addi	sp,sp,48
    80003572:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80003574:	00006517          	auipc	a0,0x6
    80003578:	ecc50513          	addi	a0,a0,-308 # 80009440 <states.0+0xc8>
    8000357c:	ffffd097          	auipc	ra,0xffffd
    80003580:	fae080e7          	jalr	-82(ra) # 8000052a <panic>
    panic("kerneltrap: interrupts enabled");
    80003584:	00006517          	auipc	a0,0x6
    80003588:	ee450513          	addi	a0,a0,-284 # 80009468 <states.0+0xf0>
    8000358c:	ffffd097          	auipc	ra,0xffffd
    80003590:	f9e080e7          	jalr	-98(ra) # 8000052a <panic>
    printf("scause %p\n", scause);
    80003594:	85ce                	mv	a1,s3
    80003596:	00006517          	auipc	a0,0x6
    8000359a:	ef250513          	addi	a0,a0,-270 # 80009488 <states.0+0x110>
    8000359e:	ffffd097          	auipc	ra,0xffffd
    800035a2:	fd6080e7          	jalr	-42(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800035a6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800035aa:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800035ae:	00006517          	auipc	a0,0x6
    800035b2:	eea50513          	addi	a0,a0,-278 # 80009498 <states.0+0x120>
    800035b6:	ffffd097          	auipc	ra,0xffffd
    800035ba:	fbe080e7          	jalr	-66(ra) # 80000574 <printf>
    panic("kerneltrap");
    800035be:	00006517          	auipc	a0,0x6
    800035c2:	ef250513          	addi	a0,a0,-270 # 800094b0 <states.0+0x138>
    800035c6:	ffffd097          	auipc	ra,0xffffd
    800035ca:	f64080e7          	jalr	-156(ra) # 8000052a <panic>
  if(which_dev == 2 && mythread() != 0 && mythread()->state == RUNNING)
    800035ce:	ffffe097          	auipc	ra,0xffffe
    800035d2:	4c0080e7          	jalr	1216(ra) # 80001a8e <mythread>
    800035d6:	d541                	beqz	a0,8000355e <kerneltrap+0x38>
    800035d8:	ffffe097          	auipc	ra,0xffffe
    800035dc:	4b6080e7          	jalr	1206(ra) # 80001a8e <mythread>
    800035e0:	4118                	lw	a4,0(a0)
    800035e2:	4791                	li	a5,4
    800035e4:	f6f71de3          	bne	a4,a5,8000355e <kerneltrap+0x38>
    yield();
    800035e8:	fffff097          	auipc	ra,0xfffff
    800035ec:	d58080e7          	jalr	-680(ra) # 80002340 <yield>
    800035f0:	b7bd                	j	8000355e <kerneltrap+0x38>

00000000800035f2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800035f2:	1101                	addi	sp,sp,-32
    800035f4:	ec06                	sd	ra,24(sp)
    800035f6:	e822                	sd	s0,16(sp)
    800035f8:	e426                	sd	s1,8(sp)
    800035fa:	1000                	addi	s0,sp,32
    800035fc:	84aa                	mv	s1,a0
  struct thread *t = mythread();
    800035fe:	ffffe097          	auipc	ra,0xffffe
    80003602:	490080e7          	jalr	1168(ra) # 80001a8e <mythread>
  switch (n) {
    80003606:	4795                	li	a5,5
    80003608:	0497e163          	bltu	a5,s1,8000364a <argraw+0x58>
    8000360c:	048a                	slli	s1,s1,0x2
    8000360e:	00006717          	auipc	a4,0x6
    80003612:	eda70713          	addi	a4,a4,-294 # 800094e8 <states.0+0x170>
    80003616:	94ba                	add	s1,s1,a4
    80003618:	409c                	lw	a5,0(s1)
    8000361a:	97ba                	add	a5,a5,a4
    8000361c:	8782                	jr	a5
  case 0:
    return t->trapframe->a0;
    8000361e:	7d1c                	ld	a5,56(a0)
    80003620:	7ba8                	ld	a0,112(a5)
  case 5:
    return t->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80003622:	60e2                	ld	ra,24(sp)
    80003624:	6442                	ld	s0,16(sp)
    80003626:	64a2                	ld	s1,8(sp)
    80003628:	6105                	addi	sp,sp,32
    8000362a:	8082                	ret
    return t->trapframe->a1;
    8000362c:	7d1c                	ld	a5,56(a0)
    8000362e:	7fa8                	ld	a0,120(a5)
    80003630:	bfcd                	j	80003622 <argraw+0x30>
    return t->trapframe->a2;
    80003632:	7d1c                	ld	a5,56(a0)
    80003634:	63c8                	ld	a0,128(a5)
    80003636:	b7f5                	j	80003622 <argraw+0x30>
    return t->trapframe->a3;
    80003638:	7d1c                	ld	a5,56(a0)
    8000363a:	67c8                	ld	a0,136(a5)
    8000363c:	b7dd                	j	80003622 <argraw+0x30>
    return t->trapframe->a4;
    8000363e:	7d1c                	ld	a5,56(a0)
    80003640:	6bc8                	ld	a0,144(a5)
    80003642:	b7c5                	j	80003622 <argraw+0x30>
    return t->trapframe->a5;
    80003644:	7d1c                	ld	a5,56(a0)
    80003646:	6fc8                	ld	a0,152(a5)
    80003648:	bfe9                	j	80003622 <argraw+0x30>
  panic("argraw");
    8000364a:	00006517          	auipc	a0,0x6
    8000364e:	e7650513          	addi	a0,a0,-394 # 800094c0 <states.0+0x148>
    80003652:	ffffd097          	auipc	ra,0xffffd
    80003656:	ed8080e7          	jalr	-296(ra) # 8000052a <panic>

000000008000365a <fetchaddr>:
{
    8000365a:	1101                	addi	sp,sp,-32
    8000365c:	ec06                	sd	ra,24(sp)
    8000365e:	e822                	sd	s0,16(sp)
    80003660:	e426                	sd	s1,8(sp)
    80003662:	e04a                	sd	s2,0(sp)
    80003664:	1000                	addi	s0,sp,32
    80003666:	84aa                	mv	s1,a0
    80003668:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000366a:	ffffe097          	auipc	ra,0xffffe
    8000366e:	38e080e7          	jalr	910(ra) # 800019f8 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80003672:	6785                	lui	a5,0x1
    80003674:	97aa                	add	a5,a5,a0
    80003676:	f387b783          	ld	a5,-200(a5) # f38 <_entry-0x7ffff0c8>
    8000367a:	02f4fb63          	bgeu	s1,a5,800036b0 <fetchaddr+0x56>
    8000367e:	00848713          	addi	a4,s1,8
    80003682:	02e7e963          	bltu	a5,a4,800036b4 <fetchaddr+0x5a>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003686:	6785                	lui	a5,0x1
    80003688:	97aa                	add	a5,a5,a0
    8000368a:	46a1                	li	a3,8
    8000368c:	8626                	mv	a2,s1
    8000368e:	85ca                	mv	a1,s2
    80003690:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80003694:	ffffe097          	auipc	ra,0xffffe
    80003698:	044080e7          	jalr	68(ra) # 800016d8 <copyin>
    8000369c:	00a03533          	snez	a0,a0
    800036a0:	40a00533          	neg	a0,a0
}
    800036a4:	60e2                	ld	ra,24(sp)
    800036a6:	6442                	ld	s0,16(sp)
    800036a8:	64a2                	ld	s1,8(sp)
    800036aa:	6902                	ld	s2,0(sp)
    800036ac:	6105                	addi	sp,sp,32
    800036ae:	8082                	ret
    return -1;
    800036b0:	557d                	li	a0,-1
    800036b2:	bfcd                	j	800036a4 <fetchaddr+0x4a>
    800036b4:	557d                	li	a0,-1
    800036b6:	b7fd                	j	800036a4 <fetchaddr+0x4a>

00000000800036b8 <fetchstr>:
{
    800036b8:	7179                	addi	sp,sp,-48
    800036ba:	f406                	sd	ra,40(sp)
    800036bc:	f022                	sd	s0,32(sp)
    800036be:	ec26                	sd	s1,24(sp)
    800036c0:	e84a                	sd	s2,16(sp)
    800036c2:	e44e                	sd	s3,8(sp)
    800036c4:	1800                	addi	s0,sp,48
    800036c6:	892a                	mv	s2,a0
    800036c8:	84ae                	mv	s1,a1
    800036ca:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800036cc:	ffffe097          	auipc	ra,0xffffe
    800036d0:	32c080e7          	jalr	812(ra) # 800019f8 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800036d4:	6785                	lui	a5,0x1
    800036d6:	97aa                	add	a5,a5,a0
    800036d8:	86ce                	mv	a3,s3
    800036da:	864a                	mv	a2,s2
    800036dc:	85a6                	mv	a1,s1
    800036de:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    800036e2:	ffffe097          	auipc	ra,0xffffe
    800036e6:	084080e7          	jalr	132(ra) # 80001766 <copyinstr>
  if(err < 0)
    800036ea:	00054763          	bltz	a0,800036f8 <fetchstr+0x40>
  return strlen(buf);
    800036ee:	8526                	mv	a0,s1
    800036f0:	ffffd097          	auipc	ra,0xffffd
    800036f4:	760080e7          	jalr	1888(ra) # 80000e50 <strlen>
}
    800036f8:	70a2                	ld	ra,40(sp)
    800036fa:	7402                	ld	s0,32(sp)
    800036fc:	64e2                	ld	s1,24(sp)
    800036fe:	6942                	ld	s2,16(sp)
    80003700:	69a2                	ld	s3,8(sp)
    80003702:	6145                	addi	sp,sp,48
    80003704:	8082                	ret

0000000080003706 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80003706:	1101                	addi	sp,sp,-32
    80003708:	ec06                	sd	ra,24(sp)
    8000370a:	e822                	sd	s0,16(sp)
    8000370c:	e426                	sd	s1,8(sp)
    8000370e:	1000                	addi	s0,sp,32
    80003710:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003712:	00000097          	auipc	ra,0x0
    80003716:	ee0080e7          	jalr	-288(ra) # 800035f2 <argraw>
    8000371a:	c088                	sw	a0,0(s1)
  return 0;
}
    8000371c:	4501                	li	a0,0
    8000371e:	60e2                	ld	ra,24(sp)
    80003720:	6442                	ld	s0,16(sp)
    80003722:	64a2                	ld	s1,8(sp)
    80003724:	6105                	addi	sp,sp,32
    80003726:	8082                	ret

0000000080003728 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80003728:	1101                	addi	sp,sp,-32
    8000372a:	ec06                	sd	ra,24(sp)
    8000372c:	e822                	sd	s0,16(sp)
    8000372e:	e426                	sd	s1,8(sp)
    80003730:	1000                	addi	s0,sp,32
    80003732:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003734:	00000097          	auipc	ra,0x0
    80003738:	ebe080e7          	jalr	-322(ra) # 800035f2 <argraw>
    8000373c:	e088                	sd	a0,0(s1)
  return 0;
}
    8000373e:	4501                	li	a0,0
    80003740:	60e2                	ld	ra,24(sp)
    80003742:	6442                	ld	s0,16(sp)
    80003744:	64a2                	ld	s1,8(sp)
    80003746:	6105                	addi	sp,sp,32
    80003748:	8082                	ret

000000008000374a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000374a:	1101                	addi	sp,sp,-32
    8000374c:	ec06                	sd	ra,24(sp)
    8000374e:	e822                	sd	s0,16(sp)
    80003750:	e426                	sd	s1,8(sp)
    80003752:	e04a                	sd	s2,0(sp)
    80003754:	1000                	addi	s0,sp,32
    80003756:	84ae                	mv	s1,a1
    80003758:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000375a:	00000097          	auipc	ra,0x0
    8000375e:	e98080e7          	jalr	-360(ra) # 800035f2 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80003762:	864a                	mv	a2,s2
    80003764:	85a6                	mv	a1,s1
    80003766:	00000097          	auipc	ra,0x0
    8000376a:	f52080e7          	jalr	-174(ra) # 800036b8 <fetchstr>
}
    8000376e:	60e2                	ld	ra,24(sp)
    80003770:	6442                	ld	s0,16(sp)
    80003772:	64a2                	ld	s1,8(sp)
    80003774:	6902                	ld	s2,0(sp)
    80003776:	6105                	addi	sp,sp,32
    80003778:	8082                	ret

000000008000377a <syscall>:
[SYS_kthread_join]   sys_kthread_join,
};

void
syscall(void)
{
    8000377a:	1101                	addi	sp,sp,-32
    8000377c:	ec06                	sd	ra,24(sp)
    8000377e:	e822                	sd	s0,16(sp)
    80003780:	e426                	sd	s1,8(sp)
    80003782:	e04a                	sd	s2,0(sp)
    80003784:	1000                	addi	s0,sp,32
  int num;
  struct thread *t = mythread();
    80003786:	ffffe097          	auipc	ra,0xffffe
    8000378a:	308080e7          	jalr	776(ra) # 80001a8e <mythread>
    8000378e:	84aa                	mv	s1,a0

  num = t->trapframe->a7;
    80003790:	03853903          	ld	s2,56(a0)
    80003794:	0a893783          	ld	a5,168(s2)
    80003798:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000379c:	37fd                	addiw	a5,a5,-1
    8000379e:	477d                	li	a4,31
    800037a0:	00f76f63          	bltu	a4,a5,800037be <syscall+0x44>
    800037a4:	00369713          	slli	a4,a3,0x3
    800037a8:	00006797          	auipc	a5,0x6
    800037ac:	d5878793          	addi	a5,a5,-680 # 80009500 <syscalls>
    800037b0:	97ba                	add	a5,a5,a4
    800037b2:	639c                	ld	a5,0(a5)
    800037b4:	c789                	beqz	a5,800037be <syscall+0x44>
    t->trapframe->a0 = syscalls[num]();
    800037b6:	9782                	jalr	a5
    800037b8:	06a93823          	sd	a0,112(s2)
    800037bc:	a839                	j	800037da <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800037be:	1d048613          	addi	a2,s1,464
    800037c2:	4c8c                	lw	a1,24(s1)
    800037c4:	00006517          	auipc	a0,0x6
    800037c8:	d0450513          	addi	a0,a0,-764 # 800094c8 <states.0+0x150>
    800037cc:	ffffd097          	auipc	ra,0xffffd
    800037d0:	da8080e7          	jalr	-600(ra) # 80000574 <printf>
            t->tid, t->name, num);
    t->trapframe->a0 = -1;
    800037d4:	7c9c                	ld	a5,56(s1)
    800037d6:	577d                	li	a4,-1
    800037d8:	fbb8                	sd	a4,112(a5)
  }
}
    800037da:	60e2                	ld	ra,24(sp)
    800037dc:	6442                	ld	s0,16(sp)
    800037de:	64a2                	ld	s1,8(sp)
    800037e0:	6902                	ld	s2,0(sp)
    800037e2:	6105                	addi	sp,sp,32
    800037e4:	8082                	ret

00000000800037e6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800037e6:	1101                	addi	sp,sp,-32
    800037e8:	ec06                	sd	ra,24(sp)
    800037ea:	e822                	sd	s0,16(sp)
    800037ec:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800037ee:	fec40593          	addi	a1,s0,-20
    800037f2:	4501                	li	a0,0
    800037f4:	00000097          	auipc	ra,0x0
    800037f8:	f12080e7          	jalr	-238(ra) # 80003706 <argint>
    return -1;
    800037fc:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800037fe:	00054963          	bltz	a0,80003810 <sys_exit+0x2a>
  exit(n);
    80003802:	fec42503          	lw	a0,-20(s0)
    80003806:	fffff097          	auipc	ra,0xfffff
    8000380a:	ec8080e7          	jalr	-312(ra) # 800026ce <exit>
  return 0;  // not reached
    8000380e:	4781                	li	a5,0
}
    80003810:	853e                	mv	a0,a5
    80003812:	60e2                	ld	ra,24(sp)
    80003814:	6442                	ld	s0,16(sp)
    80003816:	6105                	addi	sp,sp,32
    80003818:	8082                	ret

000000008000381a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000381a:	1141                	addi	sp,sp,-16
    8000381c:	e406                	sd	ra,8(sp)
    8000381e:	e022                	sd	s0,0(sp)
    80003820:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003822:	ffffe097          	auipc	ra,0xffffe
    80003826:	1d6080e7          	jalr	470(ra) # 800019f8 <myproc>
}
    8000382a:	5148                	lw	a0,36(a0)
    8000382c:	60a2                	ld	ra,8(sp)
    8000382e:	6402                	ld	s0,0(sp)
    80003830:	0141                	addi	sp,sp,16
    80003832:	8082                	ret

0000000080003834 <sys_fork>:

uint64
sys_fork(void)
{
    80003834:	1141                	addi	sp,sp,-16
    80003836:	e406                	sd	ra,8(sp)
    80003838:	e022                	sd	s0,0(sp)
    8000383a:	0800                	addi	s0,sp,16
  return fork();
    8000383c:	ffffe097          	auipc	ra,0xffffe
    80003840:	760080e7          	jalr	1888(ra) # 80001f9c <fork>
}
    80003844:	60a2                	ld	ra,8(sp)
    80003846:	6402                	ld	s0,0(sp)
    80003848:	0141                	addi	sp,sp,16
    8000384a:	8082                	ret

000000008000384c <sys_wait>:

uint64
sys_wait(void)
{
    8000384c:	1101                	addi	sp,sp,-32
    8000384e:	ec06                	sd	ra,24(sp)
    80003850:	e822                	sd	s0,16(sp)
    80003852:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80003854:	fe840593          	addi	a1,s0,-24
    80003858:	4501                	li	a0,0
    8000385a:	00000097          	auipc	ra,0x0
    8000385e:	ece080e7          	jalr	-306(ra) # 80003728 <argaddr>
    80003862:	87aa                	mv	a5,a0
    return -1;
    80003864:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80003866:	0007c863          	bltz	a5,80003876 <sys_wait+0x2a>
  return wait(p);
    8000386a:	fe843503          	ld	a0,-24(s0)
    8000386e:	fffff097          	auipc	ra,0xfffff
    80003872:	b76080e7          	jalr	-1162(ra) # 800023e4 <wait>
}
    80003876:	60e2                	ld	ra,24(sp)
    80003878:	6442                	ld	s0,16(sp)
    8000387a:	6105                	addi	sp,sp,32
    8000387c:	8082                	ret

000000008000387e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000387e:	7179                	addi	sp,sp,-48
    80003880:	f406                	sd	ra,40(sp)
    80003882:	f022                	sd	s0,32(sp)
    80003884:	ec26                	sd	s1,24(sp)
    80003886:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80003888:	fdc40593          	addi	a1,s0,-36
    8000388c:	4501                	li	a0,0
    8000388e:	00000097          	auipc	ra,0x0
    80003892:	e78080e7          	jalr	-392(ra) # 80003706 <argint>
    return -1;
    80003896:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80003898:	02054263          	bltz	a0,800038bc <sys_sbrk+0x3e>
  addr = myproc()->sz;
    8000389c:	ffffe097          	auipc	ra,0xffffe
    800038a0:	15c080e7          	jalr	348(ra) # 800019f8 <myproc>
    800038a4:	6785                	lui	a5,0x1
    800038a6:	953e                	add	a0,a0,a5
    800038a8:	f3852483          	lw	s1,-200(a0)
  if(growproc(n) < 0)
    800038ac:	fdc42503          	lw	a0,-36(s0)
    800038b0:	ffffe097          	auipc	ra,0xffffe
    800038b4:	65e080e7          	jalr	1630(ra) # 80001f0e <growproc>
    800038b8:	00054863          	bltz	a0,800038c8 <sys_sbrk+0x4a>
    return -1;
  return addr;
}
    800038bc:	8526                	mv	a0,s1
    800038be:	70a2                	ld	ra,40(sp)
    800038c0:	7402                	ld	s0,32(sp)
    800038c2:	64e2                	ld	s1,24(sp)
    800038c4:	6145                	addi	sp,sp,48
    800038c6:	8082                	ret
    return -1;
    800038c8:	54fd                	li	s1,-1
    800038ca:	bfcd                	j	800038bc <sys_sbrk+0x3e>

00000000800038cc <sys_sleep>:

uint64
sys_sleep(void)
{
    800038cc:	7139                	addi	sp,sp,-64
    800038ce:	fc06                	sd	ra,56(sp)
    800038d0:	f822                	sd	s0,48(sp)
    800038d2:	f426                	sd	s1,40(sp)
    800038d4:	f04a                	sd	s2,32(sp)
    800038d6:	ec4e                	sd	s3,24(sp)
    800038d8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800038da:	fcc40593          	addi	a1,s0,-52
    800038de:	4501                	li	a0,0
    800038e0:	00000097          	auipc	ra,0x0
    800038e4:	e26080e7          	jalr	-474(ra) # 80003706 <argint>
    return -1;
    800038e8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800038ea:	06054563          	bltz	a0,80003954 <sys_sleep+0x88>
  acquire(&tickslock);
    800038ee:	00055517          	auipc	a0,0x55
    800038f2:	c6a50513          	addi	a0,a0,-918 # 80058558 <tickslock>
    800038f6:	ffffd097          	auipc	ra,0xffffd
    800038fa:	2d4080e7          	jalr	724(ra) # 80000bca <acquire>
  ticks0 = ticks;
    800038fe:	00006917          	auipc	s2,0x6
    80003902:	73292903          	lw	s2,1842(s2) # 8000a030 <ticks>
  while(ticks - ticks0 < n){
    80003906:	fcc42783          	lw	a5,-52(s0)
    8000390a:	cf85                	beqz	a5,80003942 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000390c:	00055997          	auipc	s3,0x55
    80003910:	c4c98993          	addi	s3,s3,-948 # 80058558 <tickslock>
    80003914:	00006497          	auipc	s1,0x6
    80003918:	71c48493          	addi	s1,s1,1820 # 8000a030 <ticks>
    if(myproc()->killed){
    8000391c:	ffffe097          	auipc	ra,0xffffe
    80003920:	0dc080e7          	jalr	220(ra) # 800019f8 <myproc>
    80003924:	4d5c                	lw	a5,28(a0)
    80003926:	ef9d                	bnez	a5,80003964 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80003928:	85ce                	mv	a1,s3
    8000392a:	8526                	mv	a0,s1
    8000392c:	fffff097          	auipc	ra,0xfffff
    80003930:	a52080e7          	jalr	-1454(ra) # 8000237e <sleep>
  while(ticks - ticks0 < n){
    80003934:	409c                	lw	a5,0(s1)
    80003936:	412787bb          	subw	a5,a5,s2
    8000393a:	fcc42703          	lw	a4,-52(s0)
    8000393e:	fce7efe3          	bltu	a5,a4,8000391c <sys_sleep+0x50>
  }
  release(&tickslock);
    80003942:	00055517          	auipc	a0,0x55
    80003946:	c1650513          	addi	a0,a0,-1002 # 80058558 <tickslock>
    8000394a:	ffffd097          	auipc	ra,0xffffd
    8000394e:	33a080e7          	jalr	826(ra) # 80000c84 <release>
  return 0;
    80003952:	4781                	li	a5,0
}
    80003954:	853e                	mv	a0,a5
    80003956:	70e2                	ld	ra,56(sp)
    80003958:	7442                	ld	s0,48(sp)
    8000395a:	74a2                	ld	s1,40(sp)
    8000395c:	7902                	ld	s2,32(sp)
    8000395e:	69e2                	ld	s3,24(sp)
    80003960:	6121                	addi	sp,sp,64
    80003962:	8082                	ret
      release(&tickslock);
    80003964:	00055517          	auipc	a0,0x55
    80003968:	bf450513          	addi	a0,a0,-1036 # 80058558 <tickslock>
    8000396c:	ffffd097          	auipc	ra,0xffffd
    80003970:	318080e7          	jalr	792(ra) # 80000c84 <release>
      return -1;
    80003974:	57fd                	li	a5,-1
    80003976:	bff9                	j	80003954 <sys_sleep+0x88>

0000000080003978 <sys_kill>:

uint64
sys_kill(void)
{
    80003978:	1101                	addi	sp,sp,-32
    8000397a:	ec06                	sd	ra,24(sp)
    8000397c:	e822                	sd	s0,16(sp)
    8000397e:	1000                	addi	s0,sp,32
  int pid;
  int signum;

  if(argint(0, &pid) < 0 || argint(1, &signum) < 0)
    80003980:	fec40593          	addi	a1,s0,-20
    80003984:	4501                	li	a0,0
    80003986:	00000097          	auipc	ra,0x0
    8000398a:	d80080e7          	jalr	-640(ra) # 80003706 <argint>
    return -1;
    8000398e:	57fd                	li	a5,-1
  if(argint(0, &pid) < 0 || argint(1, &signum) < 0)
    80003990:	02054563          	bltz	a0,800039ba <sys_kill+0x42>
    80003994:	fe840593          	addi	a1,s0,-24
    80003998:	4505                	li	a0,1
    8000399a:	00000097          	auipc	ra,0x0
    8000399e:	d6c080e7          	jalr	-660(ra) # 80003706 <argint>
    return -1;
    800039a2:	57fd                	li	a5,-1
  if(argint(0, &pid) < 0 || argint(1, &signum) < 0)
    800039a4:	00054b63          	bltz	a0,800039ba <sys_kill+0x42>
  return kill(pid, signum);
    800039a8:	fe842583          	lw	a1,-24(s0)
    800039ac:	fec42503          	lw	a0,-20(s0)
    800039b0:	fffff097          	auipc	ra,0xfffff
    800039b4:	e1c080e7          	jalr	-484(ra) # 800027cc <kill>
    800039b8:	87aa                	mv	a5,a0
}
    800039ba:	853e                	mv	a0,a5
    800039bc:	60e2                	ld	ra,24(sp)
    800039be:	6442                	ld	s0,16(sp)
    800039c0:	6105                	addi	sp,sp,32
    800039c2:	8082                	ret

00000000800039c4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800039c4:	1101                	addi	sp,sp,-32
    800039c6:	ec06                	sd	ra,24(sp)
    800039c8:	e822                	sd	s0,16(sp)
    800039ca:	e426                	sd	s1,8(sp)
    800039cc:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800039ce:	00055517          	auipc	a0,0x55
    800039d2:	b8a50513          	addi	a0,a0,-1142 # 80058558 <tickslock>
    800039d6:	ffffd097          	auipc	ra,0xffffd
    800039da:	1f4080e7          	jalr	500(ra) # 80000bca <acquire>
  xticks = ticks;
    800039de:	00006497          	auipc	s1,0x6
    800039e2:	6524a483          	lw	s1,1618(s1) # 8000a030 <ticks>
  release(&tickslock);
    800039e6:	00055517          	auipc	a0,0x55
    800039ea:	b7250513          	addi	a0,a0,-1166 # 80058558 <tickslock>
    800039ee:	ffffd097          	auipc	ra,0xffffd
    800039f2:	296080e7          	jalr	662(ra) # 80000c84 <release>
  return xticks;
}
    800039f6:	02049513          	slli	a0,s1,0x20
    800039fa:	9101                	srli	a0,a0,0x20
    800039fc:	60e2                	ld	ra,24(sp)
    800039fe:	6442                	ld	s0,16(sp)
    80003a00:	64a2                	ld	s1,8(sp)
    80003a02:	6105                	addi	sp,sp,32
    80003a04:	8082                	ret

0000000080003a06 <sys_sigprocmask>:


/* sig proc mask*/
uint64
sys_sigprocmask(void)
{
    80003a06:	1101                	addi	sp,sp,-32
    80003a08:	ec06                	sd	ra,24(sp)
    80003a0a:	e822                	sd	s0,16(sp)
    80003a0c:	1000                	addi	s0,sp,32
  int mask;

  if(argint(0, &mask) < 0)
    80003a0e:	fec40593          	addi	a1,s0,-20
    80003a12:	4501                	li	a0,0
    80003a14:	00000097          	auipc	ra,0x0
    80003a18:	cf2080e7          	jalr	-782(ra) # 80003706 <argint>
    80003a1c:	87aa                	mv	a5,a0
    return -1;
    80003a1e:	557d                	li	a0,-1
  if(argint(0, &mask) < 0)
    80003a20:	0007ca63          	bltz	a5,80003a34 <sys_sigprocmask+0x2e>
  
  return sigprocmask(mask);
    80003a24:	fec42503          	lw	a0,-20(s0)
    80003a28:	fffff097          	auipc	ra,0xfffff
    80003a2c:	fb8080e7          	jalr	-72(ra) # 800029e0 <sigprocmask>
    80003a30:	1502                	slli	a0,a0,0x20
    80003a32:	9101                	srli	a0,a0,0x20
}
    80003a34:	60e2                	ld	ra,24(sp)
    80003a36:	6442                	ld	s0,16(sp)
    80003a38:	6105                	addi	sp,sp,32
    80003a3a:	8082                	ret

0000000080003a3c <sys_sigaction>:
//   return sigaction (signum,act,oldact);
// }

uint64
sys_sigaction(void)
{
    80003a3c:	7179                	addi	sp,sp,-48
    80003a3e:	f406                	sd	ra,40(sp)
    80003a40:	f022                	sd	s0,32(sp)
    80003a42:	1800                	addi	s0,sp,48
  int signum;
  uint64 act;
  uint64 oldact;
  if(argint(0, &signum) < 0)
    80003a44:	fec40593          	addi	a1,s0,-20
    80003a48:	4501                	li	a0,0
    80003a4a:	00000097          	auipc	ra,0x0
    80003a4e:	cbc080e7          	jalr	-836(ra) # 80003706 <argint>
    return -1;
    80003a52:	57fd                	li	a5,-1
  if(argint(0, &signum) < 0)
    80003a54:	04054163          	bltz	a0,80003a96 <sys_sigaction+0x5a>
  if(argaddr(1, &act) < 0)
    80003a58:	fe040593          	addi	a1,s0,-32
    80003a5c:	4505                	li	a0,1
    80003a5e:	00000097          	auipc	ra,0x0
    80003a62:	cca080e7          	jalr	-822(ra) # 80003728 <argaddr>
    return -1;
    80003a66:	57fd                	li	a5,-1
  if(argaddr(1, &act) < 0)
    80003a68:	02054763          	bltz	a0,80003a96 <sys_sigaction+0x5a>
  if(argaddr(2, &oldact) < 0)
    80003a6c:	fd840593          	addi	a1,s0,-40
    80003a70:	4509                	li	a0,2
    80003a72:	00000097          	auipc	ra,0x0
    80003a76:	cb6080e7          	jalr	-842(ra) # 80003728 <argaddr>
    return -1;
    80003a7a:	57fd                	li	a5,-1
  if(argaddr(2, &oldact) < 0)
    80003a7c:	00054d63          	bltz	a0,80003a96 <sys_sigaction+0x5a>

  return sigaction (signum,(struct sigaction*)act,(struct sigaction*)oldact);
    80003a80:	fd843603          	ld	a2,-40(s0)
    80003a84:	fe043583          	ld	a1,-32(s0)
    80003a88:	fec42503          	lw	a0,-20(s0)
    80003a8c:	fffff097          	auipc	ra,0xfffff
    80003a90:	f7e080e7          	jalr	-130(ra) # 80002a0a <sigaction>
    80003a94:	87aa                	mv	a5,a0
}
    80003a96:	853e                	mv	a0,a5
    80003a98:	70a2                	ld	ra,40(sp)
    80003a9a:	7402                	ld	s0,32(sp)
    80003a9c:	6145                	addi	sp,sp,48
    80003a9e:	8082                	ret

0000000080003aa0 <sys_sigret>:

uint64
sys_sigret(void)
{
    80003aa0:	1141                	addi	sp,sp,-16
    80003aa2:	e406                	sd	ra,8(sp)
    80003aa4:	e022                	sd	s0,0(sp)
    80003aa6:	0800                	addi	s0,sp,16
  sigret();
    80003aa8:	fffff097          	auipc	ra,0xfffff
    80003aac:	05e080e7          	jalr	94(ra) # 80002b06 <sigret>
  return 0;
}
    80003ab0:	4501                	li	a0,0
    80003ab2:	60a2                	ld	ra,8(sp)
    80003ab4:	6402                	ld	s0,0(sp)
    80003ab6:	0141                	addi	sp,sp,16
    80003ab8:	8082                	ret

0000000080003aba <sys_bsem_alloc>:

uint64
sys_bsem_alloc(void)
{
    80003aba:	1141                	addi	sp,sp,-16
    80003abc:	e406                	sd	ra,8(sp)
    80003abe:	e022                	sd	s0,0(sp)
    80003ac0:	0800                	addi	s0,sp,16
  return bsem_alloc();
    80003ac2:	fffff097          	auipc	ra,0xfffff
    80003ac6:	2c6080e7          	jalr	710(ra) # 80002d88 <bsem_alloc>
}
    80003aca:	60a2                	ld	ra,8(sp)
    80003acc:	6402                	ld	s0,0(sp)
    80003ace:	0141                	addi	sp,sp,16
    80003ad0:	8082                	ret

0000000080003ad2 <sys_bsem_free>:

void
sys_bsem_free(void)
{
    80003ad2:	1101                	addi	sp,sp,-32
    80003ad4:	ec06                	sd	ra,24(sp)
    80003ad6:	e822                	sd	s0,16(sp)
    80003ad8:	1000                	addi	s0,sp,32
  int i;
  if(argint(0, &i) >= 0)
    80003ada:	fec40593          	addi	a1,s0,-20
    80003ade:	4501                	li	a0,0
    80003ae0:	00000097          	auipc	ra,0x0
    80003ae4:	c26080e7          	jalr	-986(ra) # 80003706 <argint>
    80003ae8:	00055663          	bgez	a0,80003af4 <sys_bsem_free+0x22>
    bsem_free(i);
}
    80003aec:	60e2                	ld	ra,24(sp)
    80003aee:	6442                	ld	s0,16(sp)
    80003af0:	6105                	addi	sp,sp,32
    80003af2:	8082                	ret
    bsem_free(i);
    80003af4:	fec42503          	lw	a0,-20(s0)
    80003af8:	fffff097          	auipc	ra,0xfffff
    80003afc:	30a080e7          	jalr	778(ra) # 80002e02 <bsem_free>
}
    80003b00:	b7f5                	j	80003aec <sys_bsem_free+0x1a>

0000000080003b02 <sys_bsem_down>:

void
sys_bsem_down(void)
{
    80003b02:	1101                	addi	sp,sp,-32
    80003b04:	ec06                	sd	ra,24(sp)
    80003b06:	e822                	sd	s0,16(sp)
    80003b08:	1000                	addi	s0,sp,32
  int i;
  if(argint(0, &i) >= 0)
    80003b0a:	fec40593          	addi	a1,s0,-20
    80003b0e:	4501                	li	a0,0
    80003b10:	00000097          	auipc	ra,0x0
    80003b14:	bf6080e7          	jalr	-1034(ra) # 80003706 <argint>
    80003b18:	00055663          	bgez	a0,80003b24 <sys_bsem_down+0x22>
    bsem_down(i);
}
    80003b1c:	60e2                	ld	ra,24(sp)
    80003b1e:	6442                	ld	s0,16(sp)
    80003b20:	6105                	addi	sp,sp,32
    80003b22:	8082                	ret
    bsem_down(i);
    80003b24:	fec42503          	lw	a0,-20(s0)
    80003b28:	fffff097          	auipc	ra,0xfffff
    80003b2c:	320080e7          	jalr	800(ra) # 80002e48 <bsem_down>
}
    80003b30:	b7f5                	j	80003b1c <sys_bsem_down+0x1a>

0000000080003b32 <sys_bsem_up>:

void
sys_bsem_up(void)
{
    80003b32:	1101                	addi	sp,sp,-32
    80003b34:	ec06                	sd	ra,24(sp)
    80003b36:	e822                	sd	s0,16(sp)
    80003b38:	1000                	addi	s0,sp,32
  int i;
  if(argint(0, &i) >= 0)
    80003b3a:	fec40593          	addi	a1,s0,-20
    80003b3e:	4501                	li	a0,0
    80003b40:	00000097          	auipc	ra,0x0
    80003b44:	bc6080e7          	jalr	-1082(ra) # 80003706 <argint>
    80003b48:	00055663          	bgez	a0,80003b54 <sys_bsem_up+0x22>
    bsem_up(i);
}
    80003b4c:	60e2                	ld	ra,24(sp)
    80003b4e:	6442                	ld	s0,16(sp)
    80003b50:	6105                	addi	sp,sp,32
    80003b52:	8082                	ret
    bsem_up(i);
    80003b54:	fec42503          	lw	a0,-20(s0)
    80003b58:	fffff097          	auipc	ra,0xfffff
    80003b5c:	37e080e7          	jalr	894(ra) # 80002ed6 <bsem_up>
}
    80003b60:	b7f5                	j	80003b4c <sys_bsem_up+0x1a>

0000000080003b62 <sys_kthread_create>:

uint64
sys_kthread_create(void)
{
    80003b62:	7179                	addi	sp,sp,-48
    80003b64:	f406                	sd	ra,40(sp)
    80003b66:	f022                	sd	s0,32(sp)
    80003b68:	ec26                	sd	s1,24(sp)
    80003b6a:	1800                	addi	s0,sp,48
  uint64 fun;
  uint64 stack;
  if(argaddr(0, &fun)<0)
    80003b6c:	fd840593          	addi	a1,s0,-40
    80003b70:	4501                	li	a0,0
    80003b72:	00000097          	auipc	ra,0x0
    80003b76:	bb6080e7          	jalr	-1098(ra) # 80003728 <argaddr>
    return -1;
    80003b7a:	54fd                	li	s1,-1
  if(argaddr(0, &fun)<0)
    80003b7c:	02054d63          	bltz	a0,80003bb6 <sys_kthread_create+0x54>
  if(argaddr(1, &stack)<0)
    80003b80:	fd040593          	addi	a1,s0,-48
    80003b84:	4505                	li	a0,1
    80003b86:	00000097          	auipc	ra,0x0
    80003b8a:	ba2080e7          	jalr	-1118(ra) # 80003728 <argaddr>
    80003b8e:	02054463          	bltz	a0,80003bb6 <sys_kthread_create+0x54>
    return -1;
  int x = kthread_create((void (*)())fun,(void *) stack);
    80003b92:	fd043583          	ld	a1,-48(s0)
    80003b96:	fd843503          	ld	a0,-40(s0)
    80003b9a:	fffff097          	auipc	ra,0xfffff
    80003b9e:	392080e7          	jalr	914(ra) # 80002f2c <kthread_create>
    80003ba2:	84aa                	mv	s1,a0
  printf("the value of kthread_create is: %d\n", x);
    80003ba4:	85aa                	mv	a1,a0
    80003ba6:	00006517          	auipc	a0,0x6
    80003baa:	a6250513          	addi	a0,a0,-1438 # 80009608 <syscalls+0x108>
    80003bae:	ffffd097          	auipc	ra,0xffffd
    80003bb2:	9c6080e7          	jalr	-1594(ra) # 80000574 <printf>
  return x;
}
    80003bb6:	8526                	mv	a0,s1
    80003bb8:	70a2                	ld	ra,40(sp)
    80003bba:	7402                	ld	s0,32(sp)
    80003bbc:	64e2                	ld	s1,24(sp)
    80003bbe:	6145                	addi	sp,sp,48
    80003bc0:	8082                	ret

0000000080003bc2 <sys_kthread_id>:

uint64
sys_kthread_id(void)
{
    80003bc2:	1141                	addi	sp,sp,-16
    80003bc4:	e406                	sd	ra,8(sp)
    80003bc6:	e022                	sd	s0,0(sp)
    80003bc8:	0800                	addi	s0,sp,16
  return kthread_id();
    80003bca:	fffff097          	auipc	ra,0xfffff
    80003bce:	492080e7          	jalr	1170(ra) # 8000305c <kthread_id>
}
    80003bd2:	60a2                	ld	ra,8(sp)
    80003bd4:	6402                	ld	s0,0(sp)
    80003bd6:	0141                	addi	sp,sp,16
    80003bd8:	8082                	ret

0000000080003bda <sys_kthread_exit>:

uint64
sys_kthread_exit(void)
{
    80003bda:	1101                	addi	sp,sp,-32
    80003bdc:	ec06                	sd	ra,24(sp)
    80003bde:	e822                	sd	s0,16(sp)
    80003be0:	1000                	addi	s0,sp,32
  int status;
  if(argint(0, &status) < 0)
    80003be2:	fec40593          	addi	a1,s0,-20
    80003be6:	4501                	li	a0,0
    80003be8:	00000097          	auipc	ra,0x0
    80003bec:	b1e080e7          	jalr	-1250(ra) # 80003706 <argint>
    return -1;
    80003bf0:	57fd                	li	a5,-1
  if(argint(0, &status) < 0)
    80003bf2:	00054963          	bltz	a0,80003c04 <sys_kthread_exit+0x2a>
  kthread_exit(status);
    80003bf6:	fec42503          	lw	a0,-20(s0)
    80003bfa:	fffff097          	auipc	ra,0xfffff
    80003bfe:	47c080e7          	jalr	1148(ra) # 80003076 <kthread_exit>
  return 0;
    80003c02:	4781                	li	a5,0
}
    80003c04:	853e                	mv	a0,a5
    80003c06:	60e2                	ld	ra,24(sp)
    80003c08:	6442                	ld	s0,16(sp)
    80003c0a:	6105                	addi	sp,sp,32
    80003c0c:	8082                	ret

0000000080003c0e <sys_kthread_join>:

uint64
sys_kthread_join(void)
{
    80003c0e:	1101                	addi	sp,sp,-32
    80003c10:	ec06                	sd	ra,24(sp)
    80003c12:	e822                	sd	s0,16(sp)
    80003c14:	1000                	addi	s0,sp,32
  int tid;
  if(argint(0, &tid) < 0)
    80003c16:	fec40593          	addi	a1,s0,-20
    80003c1a:	4501                	li	a0,0
    80003c1c:	00000097          	auipc	ra,0x0
    80003c20:	aea080e7          	jalr	-1302(ra) # 80003706 <argint>
    80003c24:	87aa                	mv	a5,a0
    return -1;
    80003c26:	557d                	li	a0,-1
  if(argint(0, &tid) < 0)
    80003c28:	0007ce63          	bltz	a5,80003c44 <sys_kthread_join+0x36>
  int * status = (int *) mythread()->trapframe->a1;
    80003c2c:	ffffe097          	auipc	ra,0xffffe
    80003c30:	e62080e7          	jalr	-414(ra) # 80001a8e <mythread>
    80003c34:	7d1c                	ld	a5,56(a0)
  return kthread_join(tid,status);
    80003c36:	7fac                	ld	a1,120(a5)
    80003c38:	fec42503          	lw	a0,-20(s0)
    80003c3c:	fffff097          	auipc	ra,0xfffff
    80003c40:	51e080e7          	jalr	1310(ra) # 8000315a <kthread_join>
}
    80003c44:	60e2                	ld	ra,24(sp)
    80003c46:	6442                	ld	s0,16(sp)
    80003c48:	6105                	addi	sp,sp,32
    80003c4a:	8082                	ret

0000000080003c4c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003c4c:	7179                	addi	sp,sp,-48
    80003c4e:	f406                	sd	ra,40(sp)
    80003c50:	f022                	sd	s0,32(sp)
    80003c52:	ec26                	sd	s1,24(sp)
    80003c54:	e84a                	sd	s2,16(sp)
    80003c56:	e44e                	sd	s3,8(sp)
    80003c58:	e052                	sd	s4,0(sp)
    80003c5a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003c5c:	00006597          	auipc	a1,0x6
    80003c60:	9d458593          	addi	a1,a1,-1580 # 80009630 <syscalls+0x130>
    80003c64:	00055517          	auipc	a0,0x55
    80003c68:	90c50513          	addi	a0,a0,-1780 # 80058570 <bcache>
    80003c6c:	ffffd097          	auipc	ra,0xffffd
    80003c70:	ec6080e7          	jalr	-314(ra) # 80000b32 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003c74:	0005d797          	auipc	a5,0x5d
    80003c78:	8fc78793          	addi	a5,a5,-1796 # 80060570 <bcache+0x8000>
    80003c7c:	0005d717          	auipc	a4,0x5d
    80003c80:	b5c70713          	addi	a4,a4,-1188 # 800607d8 <bcache+0x8268>
    80003c84:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003c88:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003c8c:	00055497          	auipc	s1,0x55
    80003c90:	8fc48493          	addi	s1,s1,-1796 # 80058588 <bcache+0x18>
    b->next = bcache.head.next;
    80003c94:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003c96:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003c98:	00006a17          	auipc	s4,0x6
    80003c9c:	9a0a0a13          	addi	s4,s4,-1632 # 80009638 <syscalls+0x138>
    b->next = bcache.head.next;
    80003ca0:	2b893783          	ld	a5,696(s2)
    80003ca4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003ca6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003caa:	85d2                	mv	a1,s4
    80003cac:	01048513          	addi	a0,s1,16
    80003cb0:	00001097          	auipc	ra,0x1
    80003cb4:	4c6080e7          	jalr	1222(ra) # 80005176 <initsleeplock>
    bcache.head.next->prev = b;
    80003cb8:	2b893783          	ld	a5,696(s2)
    80003cbc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003cbe:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003cc2:	45848493          	addi	s1,s1,1112
    80003cc6:	fd349de3          	bne	s1,s3,80003ca0 <binit+0x54>
  }
}
    80003cca:	70a2                	ld	ra,40(sp)
    80003ccc:	7402                	ld	s0,32(sp)
    80003cce:	64e2                	ld	s1,24(sp)
    80003cd0:	6942                	ld	s2,16(sp)
    80003cd2:	69a2                	ld	s3,8(sp)
    80003cd4:	6a02                	ld	s4,0(sp)
    80003cd6:	6145                	addi	sp,sp,48
    80003cd8:	8082                	ret

0000000080003cda <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003cda:	7179                	addi	sp,sp,-48
    80003cdc:	f406                	sd	ra,40(sp)
    80003cde:	f022                	sd	s0,32(sp)
    80003ce0:	ec26                	sd	s1,24(sp)
    80003ce2:	e84a                	sd	s2,16(sp)
    80003ce4:	e44e                	sd	s3,8(sp)
    80003ce6:	1800                	addi	s0,sp,48
    80003ce8:	892a                	mv	s2,a0
    80003cea:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003cec:	00055517          	auipc	a0,0x55
    80003cf0:	88450513          	addi	a0,a0,-1916 # 80058570 <bcache>
    80003cf4:	ffffd097          	auipc	ra,0xffffd
    80003cf8:	ed6080e7          	jalr	-298(ra) # 80000bca <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003cfc:	0005d497          	auipc	s1,0x5d
    80003d00:	b2c4b483          	ld	s1,-1236(s1) # 80060828 <bcache+0x82b8>
    80003d04:	0005d797          	auipc	a5,0x5d
    80003d08:	ad478793          	addi	a5,a5,-1324 # 800607d8 <bcache+0x8268>
    80003d0c:	02f48f63          	beq	s1,a5,80003d4a <bread+0x70>
    80003d10:	873e                	mv	a4,a5
    80003d12:	a021                	j	80003d1a <bread+0x40>
    80003d14:	68a4                	ld	s1,80(s1)
    80003d16:	02e48a63          	beq	s1,a4,80003d4a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003d1a:	449c                	lw	a5,8(s1)
    80003d1c:	ff279ce3          	bne	a5,s2,80003d14 <bread+0x3a>
    80003d20:	44dc                	lw	a5,12(s1)
    80003d22:	ff3799e3          	bne	a5,s3,80003d14 <bread+0x3a>
      b->refcnt++;
    80003d26:	40bc                	lw	a5,64(s1)
    80003d28:	2785                	addiw	a5,a5,1
    80003d2a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003d2c:	00055517          	auipc	a0,0x55
    80003d30:	84450513          	addi	a0,a0,-1980 # 80058570 <bcache>
    80003d34:	ffffd097          	auipc	ra,0xffffd
    80003d38:	f50080e7          	jalr	-176(ra) # 80000c84 <release>
      acquiresleep(&b->lock);
    80003d3c:	01048513          	addi	a0,s1,16
    80003d40:	00001097          	auipc	ra,0x1
    80003d44:	470080e7          	jalr	1136(ra) # 800051b0 <acquiresleep>
      return b;
    80003d48:	a8b9                	j	80003da6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003d4a:	0005d497          	auipc	s1,0x5d
    80003d4e:	ad64b483          	ld	s1,-1322(s1) # 80060820 <bcache+0x82b0>
    80003d52:	0005d797          	auipc	a5,0x5d
    80003d56:	a8678793          	addi	a5,a5,-1402 # 800607d8 <bcache+0x8268>
    80003d5a:	00f48863          	beq	s1,a5,80003d6a <bread+0x90>
    80003d5e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003d60:	40bc                	lw	a5,64(s1)
    80003d62:	cf81                	beqz	a5,80003d7a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003d64:	64a4                	ld	s1,72(s1)
    80003d66:	fee49de3          	bne	s1,a4,80003d60 <bread+0x86>
  panic("bget: no buffers");
    80003d6a:	00006517          	auipc	a0,0x6
    80003d6e:	8d650513          	addi	a0,a0,-1834 # 80009640 <syscalls+0x140>
    80003d72:	ffffc097          	auipc	ra,0xffffc
    80003d76:	7b8080e7          	jalr	1976(ra) # 8000052a <panic>
      b->dev = dev;
    80003d7a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003d7e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003d82:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003d86:	4785                	li	a5,1
    80003d88:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003d8a:	00054517          	auipc	a0,0x54
    80003d8e:	7e650513          	addi	a0,a0,2022 # 80058570 <bcache>
    80003d92:	ffffd097          	auipc	ra,0xffffd
    80003d96:	ef2080e7          	jalr	-270(ra) # 80000c84 <release>
      acquiresleep(&b->lock);
    80003d9a:	01048513          	addi	a0,s1,16
    80003d9e:	00001097          	auipc	ra,0x1
    80003da2:	412080e7          	jalr	1042(ra) # 800051b0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);

  if(!b->valid) {
    80003da6:	409c                	lw	a5,0(s1)
    80003da8:	cb89                	beqz	a5,80003dba <bread+0xe0>
    //printf("debug: finish virtio func\n");

    b->valid = 1;
  }
  return b;
}
    80003daa:	8526                	mv	a0,s1
    80003dac:	70a2                	ld	ra,40(sp)
    80003dae:	7402                	ld	s0,32(sp)
    80003db0:	64e2                	ld	s1,24(sp)
    80003db2:	6942                	ld	s2,16(sp)
    80003db4:	69a2                	ld	s3,8(sp)
    80003db6:	6145                	addi	sp,sp,48
    80003db8:	8082                	ret
    virtio_disk_rw(b, 0);
    80003dba:	4581                	li	a1,0
    80003dbc:	8526                	mv	a0,s1
    80003dbe:	00003097          	auipc	ra,0x3
    80003dc2:	fae080e7          	jalr	-82(ra) # 80006d6c <virtio_disk_rw>
    b->valid = 1;
    80003dc6:	4785                	li	a5,1
    80003dc8:	c09c                	sw	a5,0(s1)
  return b;
    80003dca:	b7c5                	j	80003daa <bread+0xd0>

0000000080003dcc <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003dcc:	1101                	addi	sp,sp,-32
    80003dce:	ec06                	sd	ra,24(sp)
    80003dd0:	e822                	sd	s0,16(sp)
    80003dd2:	e426                	sd	s1,8(sp)
    80003dd4:	1000                	addi	s0,sp,32
    80003dd6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003dd8:	0541                	addi	a0,a0,16
    80003dda:	00001097          	auipc	ra,0x1
    80003dde:	470080e7          	jalr	1136(ra) # 8000524a <holdingsleep>
    80003de2:	cd01                	beqz	a0,80003dfa <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003de4:	4585                	li	a1,1
    80003de6:	8526                	mv	a0,s1
    80003de8:	00003097          	auipc	ra,0x3
    80003dec:	f84080e7          	jalr	-124(ra) # 80006d6c <virtio_disk_rw>
}
    80003df0:	60e2                	ld	ra,24(sp)
    80003df2:	6442                	ld	s0,16(sp)
    80003df4:	64a2                	ld	s1,8(sp)
    80003df6:	6105                	addi	sp,sp,32
    80003df8:	8082                	ret
    panic("bwrite");
    80003dfa:	00006517          	auipc	a0,0x6
    80003dfe:	85e50513          	addi	a0,a0,-1954 # 80009658 <syscalls+0x158>
    80003e02:	ffffc097          	auipc	ra,0xffffc
    80003e06:	728080e7          	jalr	1832(ra) # 8000052a <panic>

0000000080003e0a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003e0a:	1101                	addi	sp,sp,-32
    80003e0c:	ec06                	sd	ra,24(sp)
    80003e0e:	e822                	sd	s0,16(sp)
    80003e10:	e426                	sd	s1,8(sp)
    80003e12:	e04a                	sd	s2,0(sp)
    80003e14:	1000                	addi	s0,sp,32
    80003e16:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003e18:	01050913          	addi	s2,a0,16
    80003e1c:	854a                	mv	a0,s2
    80003e1e:	00001097          	auipc	ra,0x1
    80003e22:	42c080e7          	jalr	1068(ra) # 8000524a <holdingsleep>
    80003e26:	c92d                	beqz	a0,80003e98 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003e28:	854a                	mv	a0,s2
    80003e2a:	00001097          	auipc	ra,0x1
    80003e2e:	3dc080e7          	jalr	988(ra) # 80005206 <releasesleep>

  acquire(&bcache.lock);
    80003e32:	00054517          	auipc	a0,0x54
    80003e36:	73e50513          	addi	a0,a0,1854 # 80058570 <bcache>
    80003e3a:	ffffd097          	auipc	ra,0xffffd
    80003e3e:	d90080e7          	jalr	-624(ra) # 80000bca <acquire>
  b->refcnt--;
    80003e42:	40bc                	lw	a5,64(s1)
    80003e44:	37fd                	addiw	a5,a5,-1
    80003e46:	0007871b          	sext.w	a4,a5
    80003e4a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003e4c:	eb05                	bnez	a4,80003e7c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003e4e:	68bc                	ld	a5,80(s1)
    80003e50:	64b8                	ld	a4,72(s1)
    80003e52:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003e54:	64bc                	ld	a5,72(s1)
    80003e56:	68b8                	ld	a4,80(s1)
    80003e58:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003e5a:	0005c797          	auipc	a5,0x5c
    80003e5e:	71678793          	addi	a5,a5,1814 # 80060570 <bcache+0x8000>
    80003e62:	2b87b703          	ld	a4,696(a5)
    80003e66:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003e68:	0005d717          	auipc	a4,0x5d
    80003e6c:	97070713          	addi	a4,a4,-1680 # 800607d8 <bcache+0x8268>
    80003e70:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003e72:	2b87b703          	ld	a4,696(a5)
    80003e76:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003e78:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003e7c:	00054517          	auipc	a0,0x54
    80003e80:	6f450513          	addi	a0,a0,1780 # 80058570 <bcache>
    80003e84:	ffffd097          	auipc	ra,0xffffd
    80003e88:	e00080e7          	jalr	-512(ra) # 80000c84 <release>
}
    80003e8c:	60e2                	ld	ra,24(sp)
    80003e8e:	6442                	ld	s0,16(sp)
    80003e90:	64a2                	ld	s1,8(sp)
    80003e92:	6902                	ld	s2,0(sp)
    80003e94:	6105                	addi	sp,sp,32
    80003e96:	8082                	ret
    panic("brelse");
    80003e98:	00005517          	auipc	a0,0x5
    80003e9c:	7c850513          	addi	a0,a0,1992 # 80009660 <syscalls+0x160>
    80003ea0:	ffffc097          	auipc	ra,0xffffc
    80003ea4:	68a080e7          	jalr	1674(ra) # 8000052a <panic>

0000000080003ea8 <bpin>:

void
bpin(struct buf *b) {
    80003ea8:	1101                	addi	sp,sp,-32
    80003eaa:	ec06                	sd	ra,24(sp)
    80003eac:	e822                	sd	s0,16(sp)
    80003eae:	e426                	sd	s1,8(sp)
    80003eb0:	1000                	addi	s0,sp,32
    80003eb2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003eb4:	00054517          	auipc	a0,0x54
    80003eb8:	6bc50513          	addi	a0,a0,1724 # 80058570 <bcache>
    80003ebc:	ffffd097          	auipc	ra,0xffffd
    80003ec0:	d0e080e7          	jalr	-754(ra) # 80000bca <acquire>
  b->refcnt++;
    80003ec4:	40bc                	lw	a5,64(s1)
    80003ec6:	2785                	addiw	a5,a5,1
    80003ec8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003eca:	00054517          	auipc	a0,0x54
    80003ece:	6a650513          	addi	a0,a0,1702 # 80058570 <bcache>
    80003ed2:	ffffd097          	auipc	ra,0xffffd
    80003ed6:	db2080e7          	jalr	-590(ra) # 80000c84 <release>
}
    80003eda:	60e2                	ld	ra,24(sp)
    80003edc:	6442                	ld	s0,16(sp)
    80003ede:	64a2                	ld	s1,8(sp)
    80003ee0:	6105                	addi	sp,sp,32
    80003ee2:	8082                	ret

0000000080003ee4 <bunpin>:

void
bunpin(struct buf *b) {
    80003ee4:	1101                	addi	sp,sp,-32
    80003ee6:	ec06                	sd	ra,24(sp)
    80003ee8:	e822                	sd	s0,16(sp)
    80003eea:	e426                	sd	s1,8(sp)
    80003eec:	1000                	addi	s0,sp,32
    80003eee:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003ef0:	00054517          	auipc	a0,0x54
    80003ef4:	68050513          	addi	a0,a0,1664 # 80058570 <bcache>
    80003ef8:	ffffd097          	auipc	ra,0xffffd
    80003efc:	cd2080e7          	jalr	-814(ra) # 80000bca <acquire>
  b->refcnt--;
    80003f00:	40bc                	lw	a5,64(s1)
    80003f02:	37fd                	addiw	a5,a5,-1
    80003f04:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003f06:	00054517          	auipc	a0,0x54
    80003f0a:	66a50513          	addi	a0,a0,1642 # 80058570 <bcache>
    80003f0e:	ffffd097          	auipc	ra,0xffffd
    80003f12:	d76080e7          	jalr	-650(ra) # 80000c84 <release>
}
    80003f16:	60e2                	ld	ra,24(sp)
    80003f18:	6442                	ld	s0,16(sp)
    80003f1a:	64a2                	ld	s1,8(sp)
    80003f1c:	6105                	addi	sp,sp,32
    80003f1e:	8082                	ret

0000000080003f20 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003f20:	1101                	addi	sp,sp,-32
    80003f22:	ec06                	sd	ra,24(sp)
    80003f24:	e822                	sd	s0,16(sp)
    80003f26:	e426                	sd	s1,8(sp)
    80003f28:	e04a                	sd	s2,0(sp)
    80003f2a:	1000                	addi	s0,sp,32
    80003f2c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003f2e:	00d5d59b          	srliw	a1,a1,0xd
    80003f32:	0005d797          	auipc	a5,0x5d
    80003f36:	d1a7a783          	lw	a5,-742(a5) # 80060c4c <sb+0x1c>
    80003f3a:	9dbd                	addw	a1,a1,a5
    80003f3c:	00000097          	auipc	ra,0x0
    80003f40:	d9e080e7          	jalr	-610(ra) # 80003cda <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003f44:	0074f713          	andi	a4,s1,7
    80003f48:	4785                	li	a5,1
    80003f4a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003f4e:	14ce                	slli	s1,s1,0x33
    80003f50:	90d9                	srli	s1,s1,0x36
    80003f52:	00950733          	add	a4,a0,s1
    80003f56:	05874703          	lbu	a4,88(a4)
    80003f5a:	00e7f6b3          	and	a3,a5,a4
    80003f5e:	c69d                	beqz	a3,80003f8c <bfree+0x6c>
    80003f60:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003f62:	94aa                	add	s1,s1,a0
    80003f64:	fff7c793          	not	a5,a5
    80003f68:	8ff9                	and	a5,a5,a4
    80003f6a:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003f6e:	00001097          	auipc	ra,0x1
    80003f72:	122080e7          	jalr	290(ra) # 80005090 <log_write>
  brelse(bp);
    80003f76:	854a                	mv	a0,s2
    80003f78:	00000097          	auipc	ra,0x0
    80003f7c:	e92080e7          	jalr	-366(ra) # 80003e0a <brelse>
}
    80003f80:	60e2                	ld	ra,24(sp)
    80003f82:	6442                	ld	s0,16(sp)
    80003f84:	64a2                	ld	s1,8(sp)
    80003f86:	6902                	ld	s2,0(sp)
    80003f88:	6105                	addi	sp,sp,32
    80003f8a:	8082                	ret
    panic("freeing free block");
    80003f8c:	00005517          	auipc	a0,0x5
    80003f90:	6dc50513          	addi	a0,a0,1756 # 80009668 <syscalls+0x168>
    80003f94:	ffffc097          	auipc	ra,0xffffc
    80003f98:	596080e7          	jalr	1430(ra) # 8000052a <panic>

0000000080003f9c <balloc>:
{
    80003f9c:	711d                	addi	sp,sp,-96
    80003f9e:	ec86                	sd	ra,88(sp)
    80003fa0:	e8a2                	sd	s0,80(sp)
    80003fa2:	e4a6                	sd	s1,72(sp)
    80003fa4:	e0ca                	sd	s2,64(sp)
    80003fa6:	fc4e                	sd	s3,56(sp)
    80003fa8:	f852                	sd	s4,48(sp)
    80003faa:	f456                	sd	s5,40(sp)
    80003fac:	f05a                	sd	s6,32(sp)
    80003fae:	ec5e                	sd	s7,24(sp)
    80003fb0:	e862                	sd	s8,16(sp)
    80003fb2:	e466                	sd	s9,8(sp)
    80003fb4:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003fb6:	0005d797          	auipc	a5,0x5d
    80003fba:	c7e7a783          	lw	a5,-898(a5) # 80060c34 <sb+0x4>
    80003fbe:	cbd1                	beqz	a5,80004052 <balloc+0xb6>
    80003fc0:	8baa                	mv	s7,a0
    80003fc2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003fc4:	0005db17          	auipc	s6,0x5d
    80003fc8:	c6cb0b13          	addi	s6,s6,-916 # 80060c30 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003fcc:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003fce:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003fd0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003fd2:	6c89                	lui	s9,0x2
    80003fd4:	a831                	j	80003ff0 <balloc+0x54>
    brelse(bp);
    80003fd6:	854a                	mv	a0,s2
    80003fd8:	00000097          	auipc	ra,0x0
    80003fdc:	e32080e7          	jalr	-462(ra) # 80003e0a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003fe0:	015c87bb          	addw	a5,s9,s5
    80003fe4:	00078a9b          	sext.w	s5,a5
    80003fe8:	004b2703          	lw	a4,4(s6)
    80003fec:	06eaf363          	bgeu	s5,a4,80004052 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80003ff0:	41fad79b          	sraiw	a5,s5,0x1f
    80003ff4:	0137d79b          	srliw	a5,a5,0x13
    80003ff8:	015787bb          	addw	a5,a5,s5
    80003ffc:	40d7d79b          	sraiw	a5,a5,0xd
    80004000:	01cb2583          	lw	a1,28(s6)
    80004004:	9dbd                	addw	a1,a1,a5
    80004006:	855e                	mv	a0,s7
    80004008:	00000097          	auipc	ra,0x0
    8000400c:	cd2080e7          	jalr	-814(ra) # 80003cda <bread>
    80004010:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004012:	004b2503          	lw	a0,4(s6)
    80004016:	000a849b          	sext.w	s1,s5
    8000401a:	8662                	mv	a2,s8
    8000401c:	faa4fde3          	bgeu	s1,a0,80003fd6 <balloc+0x3a>
      m = 1 << (bi % 8);
    80004020:	41f6579b          	sraiw	a5,a2,0x1f
    80004024:	01d7d69b          	srliw	a3,a5,0x1d
    80004028:	00c6873b          	addw	a4,a3,a2
    8000402c:	00777793          	andi	a5,a4,7
    80004030:	9f95                	subw	a5,a5,a3
    80004032:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80004036:	4037571b          	sraiw	a4,a4,0x3
    8000403a:	00e906b3          	add	a3,s2,a4
    8000403e:	0586c683          	lbu	a3,88(a3) # 2000058 <_entry-0x7dffffa8>
    80004042:	00d7f5b3          	and	a1,a5,a3
    80004046:	cd91                	beqz	a1,80004062 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004048:	2605                	addiw	a2,a2,1
    8000404a:	2485                	addiw	s1,s1,1
    8000404c:	fd4618e3          	bne	a2,s4,8000401c <balloc+0x80>
    80004050:	b759                	j	80003fd6 <balloc+0x3a>
  panic("balloc: out of blocks");
    80004052:	00005517          	auipc	a0,0x5
    80004056:	62e50513          	addi	a0,a0,1582 # 80009680 <syscalls+0x180>
    8000405a:	ffffc097          	auipc	ra,0xffffc
    8000405e:	4d0080e7          	jalr	1232(ra) # 8000052a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80004062:	974a                	add	a4,a4,s2
    80004064:	8fd5                	or	a5,a5,a3
    80004066:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000406a:	854a                	mv	a0,s2
    8000406c:	00001097          	auipc	ra,0x1
    80004070:	024080e7          	jalr	36(ra) # 80005090 <log_write>
        brelse(bp);
    80004074:	854a                	mv	a0,s2
    80004076:	00000097          	auipc	ra,0x0
    8000407a:	d94080e7          	jalr	-620(ra) # 80003e0a <brelse>
  bp = bread(dev, bno);
    8000407e:	85a6                	mv	a1,s1
    80004080:	855e                	mv	a0,s7
    80004082:	00000097          	auipc	ra,0x0
    80004086:	c58080e7          	jalr	-936(ra) # 80003cda <bread>
    8000408a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000408c:	40000613          	li	a2,1024
    80004090:	4581                	li	a1,0
    80004092:	05850513          	addi	a0,a0,88
    80004096:	ffffd097          	auipc	ra,0xffffd
    8000409a:	c36080e7          	jalr	-970(ra) # 80000ccc <memset>
  log_write(bp);
    8000409e:	854a                	mv	a0,s2
    800040a0:	00001097          	auipc	ra,0x1
    800040a4:	ff0080e7          	jalr	-16(ra) # 80005090 <log_write>
  brelse(bp);
    800040a8:	854a                	mv	a0,s2
    800040aa:	00000097          	auipc	ra,0x0
    800040ae:	d60080e7          	jalr	-672(ra) # 80003e0a <brelse>
}
    800040b2:	8526                	mv	a0,s1
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

00000000800040ce <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800040ce:	7179                	addi	sp,sp,-48
    800040d0:	f406                	sd	ra,40(sp)
    800040d2:	f022                	sd	s0,32(sp)
    800040d4:	ec26                	sd	s1,24(sp)
    800040d6:	e84a                	sd	s2,16(sp)
    800040d8:	e44e                	sd	s3,8(sp)
    800040da:	e052                	sd	s4,0(sp)
    800040dc:	1800                	addi	s0,sp,48
    800040de:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800040e0:	47ad                	li	a5,11
    800040e2:	04b7fe63          	bgeu	a5,a1,8000413e <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800040e6:	ff45849b          	addiw	s1,a1,-12
    800040ea:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800040ee:	0ff00793          	li	a5,255
    800040f2:	0ae7e463          	bltu	a5,a4,8000419a <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800040f6:	08052583          	lw	a1,128(a0)
    800040fa:	c5b5                	beqz	a1,80004166 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800040fc:	00092503          	lw	a0,0(s2)
    80004100:	00000097          	auipc	ra,0x0
    80004104:	bda080e7          	jalr	-1062(ra) # 80003cda <bread>
    80004108:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000410a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000410e:	02049713          	slli	a4,s1,0x20
    80004112:	01e75593          	srli	a1,a4,0x1e
    80004116:	00b784b3          	add	s1,a5,a1
    8000411a:	0004a983          	lw	s3,0(s1)
    8000411e:	04098e63          	beqz	s3,8000417a <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80004122:	8552                	mv	a0,s4
    80004124:	00000097          	auipc	ra,0x0
    80004128:	ce6080e7          	jalr	-794(ra) # 80003e0a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000412c:	854e                	mv	a0,s3
    8000412e:	70a2                	ld	ra,40(sp)
    80004130:	7402                	ld	s0,32(sp)
    80004132:	64e2                	ld	s1,24(sp)
    80004134:	6942                	ld	s2,16(sp)
    80004136:	69a2                	ld	s3,8(sp)
    80004138:	6a02                	ld	s4,0(sp)
    8000413a:	6145                	addi	sp,sp,48
    8000413c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000413e:	02059793          	slli	a5,a1,0x20
    80004142:	01e7d593          	srli	a1,a5,0x1e
    80004146:	00b504b3          	add	s1,a0,a1
    8000414a:	0504a983          	lw	s3,80(s1)
    8000414e:	fc099fe3          	bnez	s3,8000412c <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80004152:	4108                	lw	a0,0(a0)
    80004154:	00000097          	auipc	ra,0x0
    80004158:	e48080e7          	jalr	-440(ra) # 80003f9c <balloc>
    8000415c:	0005099b          	sext.w	s3,a0
    80004160:	0534a823          	sw	s3,80(s1)
    80004164:	b7e1                	j	8000412c <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80004166:	4108                	lw	a0,0(a0)
    80004168:	00000097          	auipc	ra,0x0
    8000416c:	e34080e7          	jalr	-460(ra) # 80003f9c <balloc>
    80004170:	0005059b          	sext.w	a1,a0
    80004174:	08b92023          	sw	a1,128(s2)
    80004178:	b751                	j	800040fc <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000417a:	00092503          	lw	a0,0(s2)
    8000417e:	00000097          	auipc	ra,0x0
    80004182:	e1e080e7          	jalr	-482(ra) # 80003f9c <balloc>
    80004186:	0005099b          	sext.w	s3,a0
    8000418a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000418e:	8552                	mv	a0,s4
    80004190:	00001097          	auipc	ra,0x1
    80004194:	f00080e7          	jalr	-256(ra) # 80005090 <log_write>
    80004198:	b769                	j	80004122 <bmap+0x54>
  panic("bmap: out of range");
    8000419a:	00005517          	auipc	a0,0x5
    8000419e:	4fe50513          	addi	a0,a0,1278 # 80009698 <syscalls+0x198>
    800041a2:	ffffc097          	auipc	ra,0xffffc
    800041a6:	388080e7          	jalr	904(ra) # 8000052a <panic>

00000000800041aa <iget>:
{
    800041aa:	7179                	addi	sp,sp,-48
    800041ac:	f406                	sd	ra,40(sp)
    800041ae:	f022                	sd	s0,32(sp)
    800041b0:	ec26                	sd	s1,24(sp)
    800041b2:	e84a                	sd	s2,16(sp)
    800041b4:	e44e                	sd	s3,8(sp)
    800041b6:	e052                	sd	s4,0(sp)
    800041b8:	1800                	addi	s0,sp,48
    800041ba:	89aa                	mv	s3,a0
    800041bc:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800041be:	0005d517          	auipc	a0,0x5d
    800041c2:	a9250513          	addi	a0,a0,-1390 # 80060c50 <itable>
    800041c6:	ffffd097          	auipc	ra,0xffffd
    800041ca:	a04080e7          	jalr	-1532(ra) # 80000bca <acquire>
  empty = 0;
    800041ce:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800041d0:	0005d497          	auipc	s1,0x5d
    800041d4:	a9848493          	addi	s1,s1,-1384 # 80060c68 <itable+0x18>
    800041d8:	0005e697          	auipc	a3,0x5e
    800041dc:	52068693          	addi	a3,a3,1312 # 800626f8 <log>
    800041e0:	a039                	j	800041ee <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800041e2:	02090b63          	beqz	s2,80004218 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800041e6:	08848493          	addi	s1,s1,136
    800041ea:	02d48a63          	beq	s1,a3,8000421e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800041ee:	449c                	lw	a5,8(s1)
    800041f0:	fef059e3          	blez	a5,800041e2 <iget+0x38>
    800041f4:	4098                	lw	a4,0(s1)
    800041f6:	ff3716e3          	bne	a4,s3,800041e2 <iget+0x38>
    800041fa:	40d8                	lw	a4,4(s1)
    800041fc:	ff4713e3          	bne	a4,s4,800041e2 <iget+0x38>
      ip->ref++;
    80004200:	2785                	addiw	a5,a5,1
    80004202:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80004204:	0005d517          	auipc	a0,0x5d
    80004208:	a4c50513          	addi	a0,a0,-1460 # 80060c50 <itable>
    8000420c:	ffffd097          	auipc	ra,0xffffd
    80004210:	a78080e7          	jalr	-1416(ra) # 80000c84 <release>
      return ip;
    80004214:	8926                	mv	s2,s1
    80004216:	a03d                	j	80004244 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004218:	f7f9                	bnez	a5,800041e6 <iget+0x3c>
    8000421a:	8926                	mv	s2,s1
    8000421c:	b7e9                	j	800041e6 <iget+0x3c>
  if(empty == 0)
    8000421e:	02090c63          	beqz	s2,80004256 <iget+0xac>
  ip->dev = dev;
    80004222:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80004226:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000422a:	4785                	li	a5,1
    8000422c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80004230:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80004234:	0005d517          	auipc	a0,0x5d
    80004238:	a1c50513          	addi	a0,a0,-1508 # 80060c50 <itable>
    8000423c:	ffffd097          	auipc	ra,0xffffd
    80004240:	a48080e7          	jalr	-1464(ra) # 80000c84 <release>
}
    80004244:	854a                	mv	a0,s2
    80004246:	70a2                	ld	ra,40(sp)
    80004248:	7402                	ld	s0,32(sp)
    8000424a:	64e2                	ld	s1,24(sp)
    8000424c:	6942                	ld	s2,16(sp)
    8000424e:	69a2                	ld	s3,8(sp)
    80004250:	6a02                	ld	s4,0(sp)
    80004252:	6145                	addi	sp,sp,48
    80004254:	8082                	ret
    panic("iget: no inodes");
    80004256:	00005517          	auipc	a0,0x5
    8000425a:	45a50513          	addi	a0,a0,1114 # 800096b0 <syscalls+0x1b0>
    8000425e:	ffffc097          	auipc	ra,0xffffc
    80004262:	2cc080e7          	jalr	716(ra) # 8000052a <panic>

0000000080004266 <fsinit>:
fsinit(int dev) {
    80004266:	7179                	addi	sp,sp,-48
    80004268:	f406                	sd	ra,40(sp)
    8000426a:	f022                	sd	s0,32(sp)
    8000426c:	ec26                	sd	s1,24(sp)
    8000426e:	e84a                	sd	s2,16(sp)
    80004270:	e44e                	sd	s3,8(sp)
    80004272:	1800                	addi	s0,sp,48
    80004274:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80004276:	4585                	li	a1,1
    80004278:	00000097          	auipc	ra,0x0
    8000427c:	a62080e7          	jalr	-1438(ra) # 80003cda <bread>
    80004280:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80004282:	0005d997          	auipc	s3,0x5d
    80004286:	9ae98993          	addi	s3,s3,-1618 # 80060c30 <sb>
    8000428a:	02000613          	li	a2,32
    8000428e:	05850593          	addi	a1,a0,88
    80004292:	854e                	mv	a0,s3
    80004294:	ffffd097          	auipc	ra,0xffffd
    80004298:	a94080e7          	jalr	-1388(ra) # 80000d28 <memmove>
  brelse(bp);
    8000429c:	8526                	mv	a0,s1
    8000429e:	00000097          	auipc	ra,0x0
    800042a2:	b6c080e7          	jalr	-1172(ra) # 80003e0a <brelse>
  if(sb.magic != FSMAGIC)
    800042a6:	0009a703          	lw	a4,0(s3)
    800042aa:	102037b7          	lui	a5,0x10203
    800042ae:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800042b2:	02f71263          	bne	a4,a5,800042d6 <fsinit+0x70>
  initlog(dev, &sb);
    800042b6:	0005d597          	auipc	a1,0x5d
    800042ba:	97a58593          	addi	a1,a1,-1670 # 80060c30 <sb>
    800042be:	854a                	mv	a0,s2
    800042c0:	00001097          	auipc	ra,0x1
    800042c4:	b52080e7          	jalr	-1198(ra) # 80004e12 <initlog>
}
    800042c8:	70a2                	ld	ra,40(sp)
    800042ca:	7402                	ld	s0,32(sp)
    800042cc:	64e2                	ld	s1,24(sp)
    800042ce:	6942                	ld	s2,16(sp)
    800042d0:	69a2                	ld	s3,8(sp)
    800042d2:	6145                	addi	sp,sp,48
    800042d4:	8082                	ret
    panic("invalid file system");
    800042d6:	00005517          	auipc	a0,0x5
    800042da:	3ea50513          	addi	a0,a0,1002 # 800096c0 <syscalls+0x1c0>
    800042de:	ffffc097          	auipc	ra,0xffffc
    800042e2:	24c080e7          	jalr	588(ra) # 8000052a <panic>

00000000800042e6 <iinit>:
{
    800042e6:	7179                	addi	sp,sp,-48
    800042e8:	f406                	sd	ra,40(sp)
    800042ea:	f022                	sd	s0,32(sp)
    800042ec:	ec26                	sd	s1,24(sp)
    800042ee:	e84a                	sd	s2,16(sp)
    800042f0:	e44e                	sd	s3,8(sp)
    800042f2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800042f4:	00005597          	auipc	a1,0x5
    800042f8:	3e458593          	addi	a1,a1,996 # 800096d8 <syscalls+0x1d8>
    800042fc:	0005d517          	auipc	a0,0x5d
    80004300:	95450513          	addi	a0,a0,-1708 # 80060c50 <itable>
    80004304:	ffffd097          	auipc	ra,0xffffd
    80004308:	82e080e7          	jalr	-2002(ra) # 80000b32 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000430c:	0005d497          	auipc	s1,0x5d
    80004310:	96c48493          	addi	s1,s1,-1684 # 80060c78 <itable+0x28>
    80004314:	0005e997          	auipc	s3,0x5e
    80004318:	3f498993          	addi	s3,s3,1012 # 80062708 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000431c:	00005917          	auipc	s2,0x5
    80004320:	3c490913          	addi	s2,s2,964 # 800096e0 <syscalls+0x1e0>
    80004324:	85ca                	mv	a1,s2
    80004326:	8526                	mv	a0,s1
    80004328:	00001097          	auipc	ra,0x1
    8000432c:	e4e080e7          	jalr	-434(ra) # 80005176 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80004330:	08848493          	addi	s1,s1,136
    80004334:	ff3498e3          	bne	s1,s3,80004324 <iinit+0x3e>
}
    80004338:	70a2                	ld	ra,40(sp)
    8000433a:	7402                	ld	s0,32(sp)
    8000433c:	64e2                	ld	s1,24(sp)
    8000433e:	6942                	ld	s2,16(sp)
    80004340:	69a2                	ld	s3,8(sp)
    80004342:	6145                	addi	sp,sp,48
    80004344:	8082                	ret

0000000080004346 <ialloc>:
{
    80004346:	715d                	addi	sp,sp,-80
    80004348:	e486                	sd	ra,72(sp)
    8000434a:	e0a2                	sd	s0,64(sp)
    8000434c:	fc26                	sd	s1,56(sp)
    8000434e:	f84a                	sd	s2,48(sp)
    80004350:	f44e                	sd	s3,40(sp)
    80004352:	f052                	sd	s4,32(sp)
    80004354:	ec56                	sd	s5,24(sp)
    80004356:	e85a                	sd	s6,16(sp)
    80004358:	e45e                	sd	s7,8(sp)
    8000435a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000435c:	0005d717          	auipc	a4,0x5d
    80004360:	8e072703          	lw	a4,-1824(a4) # 80060c3c <sb+0xc>
    80004364:	4785                	li	a5,1
    80004366:	04e7fa63          	bgeu	a5,a4,800043ba <ialloc+0x74>
    8000436a:	8aaa                	mv	s5,a0
    8000436c:	8bae                	mv	s7,a1
    8000436e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80004370:	0005da17          	auipc	s4,0x5d
    80004374:	8c0a0a13          	addi	s4,s4,-1856 # 80060c30 <sb>
    80004378:	00048b1b          	sext.w	s6,s1
    8000437c:	0044d793          	srli	a5,s1,0x4
    80004380:	018a2583          	lw	a1,24(s4)
    80004384:	9dbd                	addw	a1,a1,a5
    80004386:	8556                	mv	a0,s5
    80004388:	00000097          	auipc	ra,0x0
    8000438c:	952080e7          	jalr	-1710(ra) # 80003cda <bread>
    80004390:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80004392:	05850993          	addi	s3,a0,88
    80004396:	00f4f793          	andi	a5,s1,15
    8000439a:	079a                	slli	a5,a5,0x6
    8000439c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000439e:	00099783          	lh	a5,0(s3)
    800043a2:	c785                	beqz	a5,800043ca <ialloc+0x84>
    brelse(bp);
    800043a4:	00000097          	auipc	ra,0x0
    800043a8:	a66080e7          	jalr	-1434(ra) # 80003e0a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800043ac:	0485                	addi	s1,s1,1
    800043ae:	00ca2703          	lw	a4,12(s4)
    800043b2:	0004879b          	sext.w	a5,s1
    800043b6:	fce7e1e3          	bltu	a5,a4,80004378 <ialloc+0x32>
  panic("ialloc: no inodes");
    800043ba:	00005517          	auipc	a0,0x5
    800043be:	32e50513          	addi	a0,a0,814 # 800096e8 <syscalls+0x1e8>
    800043c2:	ffffc097          	auipc	ra,0xffffc
    800043c6:	168080e7          	jalr	360(ra) # 8000052a <panic>
      memset(dip, 0, sizeof(*dip));
    800043ca:	04000613          	li	a2,64
    800043ce:	4581                	li	a1,0
    800043d0:	854e                	mv	a0,s3
    800043d2:	ffffd097          	auipc	ra,0xffffd
    800043d6:	8fa080e7          	jalr	-1798(ra) # 80000ccc <memset>
      dip->type = type;
    800043da:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800043de:	854a                	mv	a0,s2
    800043e0:	00001097          	auipc	ra,0x1
    800043e4:	cb0080e7          	jalr	-848(ra) # 80005090 <log_write>
      brelse(bp);
    800043e8:	854a                	mv	a0,s2
    800043ea:	00000097          	auipc	ra,0x0
    800043ee:	a20080e7          	jalr	-1504(ra) # 80003e0a <brelse>
      return iget(dev, inum);
    800043f2:	85da                	mv	a1,s6
    800043f4:	8556                	mv	a0,s5
    800043f6:	00000097          	auipc	ra,0x0
    800043fa:	db4080e7          	jalr	-588(ra) # 800041aa <iget>
}
    800043fe:	60a6                	ld	ra,72(sp)
    80004400:	6406                	ld	s0,64(sp)
    80004402:	74e2                	ld	s1,56(sp)
    80004404:	7942                	ld	s2,48(sp)
    80004406:	79a2                	ld	s3,40(sp)
    80004408:	7a02                	ld	s4,32(sp)
    8000440a:	6ae2                	ld	s5,24(sp)
    8000440c:	6b42                	ld	s6,16(sp)
    8000440e:	6ba2                	ld	s7,8(sp)
    80004410:	6161                	addi	sp,sp,80
    80004412:	8082                	ret

0000000080004414 <iupdate>:
{
    80004414:	1101                	addi	sp,sp,-32
    80004416:	ec06                	sd	ra,24(sp)
    80004418:	e822                	sd	s0,16(sp)
    8000441a:	e426                	sd	s1,8(sp)
    8000441c:	e04a                	sd	s2,0(sp)
    8000441e:	1000                	addi	s0,sp,32
    80004420:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004422:	415c                	lw	a5,4(a0)
    80004424:	0047d79b          	srliw	a5,a5,0x4
    80004428:	0005d597          	auipc	a1,0x5d
    8000442c:	8205a583          	lw	a1,-2016(a1) # 80060c48 <sb+0x18>
    80004430:	9dbd                	addw	a1,a1,a5
    80004432:	4108                	lw	a0,0(a0)
    80004434:	00000097          	auipc	ra,0x0
    80004438:	8a6080e7          	jalr	-1882(ra) # 80003cda <bread>
    8000443c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000443e:	05850793          	addi	a5,a0,88
    80004442:	40c8                	lw	a0,4(s1)
    80004444:	893d                	andi	a0,a0,15
    80004446:	051a                	slli	a0,a0,0x6
    80004448:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    8000444a:	04449703          	lh	a4,68(s1)
    8000444e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80004452:	04649703          	lh	a4,70(s1)
    80004456:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    8000445a:	04849703          	lh	a4,72(s1)
    8000445e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80004462:	04a49703          	lh	a4,74(s1)
    80004466:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    8000446a:	44f8                	lw	a4,76(s1)
    8000446c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000446e:	03400613          	li	a2,52
    80004472:	05048593          	addi	a1,s1,80
    80004476:	0531                	addi	a0,a0,12
    80004478:	ffffd097          	auipc	ra,0xffffd
    8000447c:	8b0080e7          	jalr	-1872(ra) # 80000d28 <memmove>
  log_write(bp);
    80004480:	854a                	mv	a0,s2
    80004482:	00001097          	auipc	ra,0x1
    80004486:	c0e080e7          	jalr	-1010(ra) # 80005090 <log_write>
  brelse(bp);
    8000448a:	854a                	mv	a0,s2
    8000448c:	00000097          	auipc	ra,0x0
    80004490:	97e080e7          	jalr	-1666(ra) # 80003e0a <brelse>
}
    80004494:	60e2                	ld	ra,24(sp)
    80004496:	6442                	ld	s0,16(sp)
    80004498:	64a2                	ld	s1,8(sp)
    8000449a:	6902                	ld	s2,0(sp)
    8000449c:	6105                	addi	sp,sp,32
    8000449e:	8082                	ret

00000000800044a0 <idup>:
{
    800044a0:	1101                	addi	sp,sp,-32
    800044a2:	ec06                	sd	ra,24(sp)
    800044a4:	e822                	sd	s0,16(sp)
    800044a6:	e426                	sd	s1,8(sp)
    800044a8:	1000                	addi	s0,sp,32
    800044aa:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800044ac:	0005c517          	auipc	a0,0x5c
    800044b0:	7a450513          	addi	a0,a0,1956 # 80060c50 <itable>
    800044b4:	ffffc097          	auipc	ra,0xffffc
    800044b8:	716080e7          	jalr	1814(ra) # 80000bca <acquire>
  ip->ref++;
    800044bc:	449c                	lw	a5,8(s1)
    800044be:	2785                	addiw	a5,a5,1
    800044c0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800044c2:	0005c517          	auipc	a0,0x5c
    800044c6:	78e50513          	addi	a0,a0,1934 # 80060c50 <itable>
    800044ca:	ffffc097          	auipc	ra,0xffffc
    800044ce:	7ba080e7          	jalr	1978(ra) # 80000c84 <release>
}
    800044d2:	8526                	mv	a0,s1
    800044d4:	60e2                	ld	ra,24(sp)
    800044d6:	6442                	ld	s0,16(sp)
    800044d8:	64a2                	ld	s1,8(sp)
    800044da:	6105                	addi	sp,sp,32
    800044dc:	8082                	ret

00000000800044de <ilock>:
{
    800044de:	1101                	addi	sp,sp,-32
    800044e0:	ec06                	sd	ra,24(sp)
    800044e2:	e822                	sd	s0,16(sp)
    800044e4:	e426                	sd	s1,8(sp)
    800044e6:	e04a                	sd	s2,0(sp)
    800044e8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800044ea:	c115                	beqz	a0,8000450e <ilock+0x30>
    800044ec:	84aa                	mv	s1,a0
    800044ee:	451c                	lw	a5,8(a0)
    800044f0:	00f05f63          	blez	a5,8000450e <ilock+0x30>
  acquiresleep(&ip->lock);
    800044f4:	0541                	addi	a0,a0,16
    800044f6:	00001097          	auipc	ra,0x1
    800044fa:	cba080e7          	jalr	-838(ra) # 800051b0 <acquiresleep>
  if(ip->valid == 0){
    800044fe:	40bc                	lw	a5,64(s1)
    80004500:	cf99                	beqz	a5,8000451e <ilock+0x40>
}
    80004502:	60e2                	ld	ra,24(sp)
    80004504:	6442                	ld	s0,16(sp)
    80004506:	64a2                	ld	s1,8(sp)
    80004508:	6902                	ld	s2,0(sp)
    8000450a:	6105                	addi	sp,sp,32
    8000450c:	8082                	ret
    panic("ilock");
    8000450e:	00005517          	auipc	a0,0x5
    80004512:	1f250513          	addi	a0,a0,498 # 80009700 <syscalls+0x200>
    80004516:	ffffc097          	auipc	ra,0xffffc
    8000451a:	014080e7          	jalr	20(ra) # 8000052a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000451e:	40dc                	lw	a5,4(s1)
    80004520:	0047d79b          	srliw	a5,a5,0x4
    80004524:	0005c597          	auipc	a1,0x5c
    80004528:	7245a583          	lw	a1,1828(a1) # 80060c48 <sb+0x18>
    8000452c:	9dbd                	addw	a1,a1,a5
    8000452e:	4088                	lw	a0,0(s1)
    80004530:	fffff097          	auipc	ra,0xfffff
    80004534:	7aa080e7          	jalr	1962(ra) # 80003cda <bread>
    80004538:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000453a:	05850593          	addi	a1,a0,88
    8000453e:	40dc                	lw	a5,4(s1)
    80004540:	8bbd                	andi	a5,a5,15
    80004542:	079a                	slli	a5,a5,0x6
    80004544:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80004546:	00059783          	lh	a5,0(a1)
    8000454a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000454e:	00259783          	lh	a5,2(a1)
    80004552:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80004556:	00459783          	lh	a5,4(a1)
    8000455a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000455e:	00659783          	lh	a5,6(a1)
    80004562:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80004566:	459c                	lw	a5,8(a1)
    80004568:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000456a:	03400613          	li	a2,52
    8000456e:	05b1                	addi	a1,a1,12
    80004570:	05048513          	addi	a0,s1,80
    80004574:	ffffc097          	auipc	ra,0xffffc
    80004578:	7b4080e7          	jalr	1972(ra) # 80000d28 <memmove>
    brelse(bp);
    8000457c:	854a                	mv	a0,s2
    8000457e:	00000097          	auipc	ra,0x0
    80004582:	88c080e7          	jalr	-1908(ra) # 80003e0a <brelse>
    ip->valid = 1;
    80004586:	4785                	li	a5,1
    80004588:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000458a:	04449783          	lh	a5,68(s1)
    8000458e:	fbb5                	bnez	a5,80004502 <ilock+0x24>
      panic("ilock: no type");
    80004590:	00005517          	auipc	a0,0x5
    80004594:	17850513          	addi	a0,a0,376 # 80009708 <syscalls+0x208>
    80004598:	ffffc097          	auipc	ra,0xffffc
    8000459c:	f92080e7          	jalr	-110(ra) # 8000052a <panic>

00000000800045a0 <iunlock>:
{
    800045a0:	1101                	addi	sp,sp,-32
    800045a2:	ec06                	sd	ra,24(sp)
    800045a4:	e822                	sd	s0,16(sp)
    800045a6:	e426                	sd	s1,8(sp)
    800045a8:	e04a                	sd	s2,0(sp)
    800045aa:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800045ac:	c905                	beqz	a0,800045dc <iunlock+0x3c>
    800045ae:	84aa                	mv	s1,a0
    800045b0:	01050913          	addi	s2,a0,16
    800045b4:	854a                	mv	a0,s2
    800045b6:	00001097          	auipc	ra,0x1
    800045ba:	c94080e7          	jalr	-876(ra) # 8000524a <holdingsleep>
    800045be:	cd19                	beqz	a0,800045dc <iunlock+0x3c>
    800045c0:	449c                	lw	a5,8(s1)
    800045c2:	00f05d63          	blez	a5,800045dc <iunlock+0x3c>
  releasesleep(&ip->lock);
    800045c6:	854a                	mv	a0,s2
    800045c8:	00001097          	auipc	ra,0x1
    800045cc:	c3e080e7          	jalr	-962(ra) # 80005206 <releasesleep>
}
    800045d0:	60e2                	ld	ra,24(sp)
    800045d2:	6442                	ld	s0,16(sp)
    800045d4:	64a2                	ld	s1,8(sp)
    800045d6:	6902                	ld	s2,0(sp)
    800045d8:	6105                	addi	sp,sp,32
    800045da:	8082                	ret
    panic("iunlock");
    800045dc:	00005517          	auipc	a0,0x5
    800045e0:	13c50513          	addi	a0,a0,316 # 80009718 <syscalls+0x218>
    800045e4:	ffffc097          	auipc	ra,0xffffc
    800045e8:	f46080e7          	jalr	-186(ra) # 8000052a <panic>

00000000800045ec <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800045ec:	7179                	addi	sp,sp,-48
    800045ee:	f406                	sd	ra,40(sp)
    800045f0:	f022                	sd	s0,32(sp)
    800045f2:	ec26                	sd	s1,24(sp)
    800045f4:	e84a                	sd	s2,16(sp)
    800045f6:	e44e                	sd	s3,8(sp)
    800045f8:	e052                	sd	s4,0(sp)
    800045fa:	1800                	addi	s0,sp,48
    800045fc:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800045fe:	05050493          	addi	s1,a0,80
    80004602:	08050913          	addi	s2,a0,128
    80004606:	a021                	j	8000460e <itrunc+0x22>
    80004608:	0491                	addi	s1,s1,4
    8000460a:	01248d63          	beq	s1,s2,80004624 <itrunc+0x38>
    if(ip->addrs[i]){
    8000460e:	408c                	lw	a1,0(s1)
    80004610:	dde5                	beqz	a1,80004608 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80004612:	0009a503          	lw	a0,0(s3)
    80004616:	00000097          	auipc	ra,0x0
    8000461a:	90a080e7          	jalr	-1782(ra) # 80003f20 <bfree>
      ip->addrs[i] = 0;
    8000461e:	0004a023          	sw	zero,0(s1)
    80004622:	b7dd                	j	80004608 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80004624:	0809a583          	lw	a1,128(s3)
    80004628:	e185                	bnez	a1,80004648 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000462a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000462e:	854e                	mv	a0,s3
    80004630:	00000097          	auipc	ra,0x0
    80004634:	de4080e7          	jalr	-540(ra) # 80004414 <iupdate>
}
    80004638:	70a2                	ld	ra,40(sp)
    8000463a:	7402                	ld	s0,32(sp)
    8000463c:	64e2                	ld	s1,24(sp)
    8000463e:	6942                	ld	s2,16(sp)
    80004640:	69a2                	ld	s3,8(sp)
    80004642:	6a02                	ld	s4,0(sp)
    80004644:	6145                	addi	sp,sp,48
    80004646:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80004648:	0009a503          	lw	a0,0(s3)
    8000464c:	fffff097          	auipc	ra,0xfffff
    80004650:	68e080e7          	jalr	1678(ra) # 80003cda <bread>
    80004654:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80004656:	05850493          	addi	s1,a0,88
    8000465a:	45850913          	addi	s2,a0,1112
    8000465e:	a021                	j	80004666 <itrunc+0x7a>
    80004660:	0491                	addi	s1,s1,4
    80004662:	01248b63          	beq	s1,s2,80004678 <itrunc+0x8c>
      if(a[j])
    80004666:	408c                	lw	a1,0(s1)
    80004668:	dde5                	beqz	a1,80004660 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    8000466a:	0009a503          	lw	a0,0(s3)
    8000466e:	00000097          	auipc	ra,0x0
    80004672:	8b2080e7          	jalr	-1870(ra) # 80003f20 <bfree>
    80004676:	b7ed                	j	80004660 <itrunc+0x74>
    brelse(bp);
    80004678:	8552                	mv	a0,s4
    8000467a:	fffff097          	auipc	ra,0xfffff
    8000467e:	790080e7          	jalr	1936(ra) # 80003e0a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004682:	0809a583          	lw	a1,128(s3)
    80004686:	0009a503          	lw	a0,0(s3)
    8000468a:	00000097          	auipc	ra,0x0
    8000468e:	896080e7          	jalr	-1898(ra) # 80003f20 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004692:	0809a023          	sw	zero,128(s3)
    80004696:	bf51                	j	8000462a <itrunc+0x3e>

0000000080004698 <iput>:
{
    80004698:	1101                	addi	sp,sp,-32
    8000469a:	ec06                	sd	ra,24(sp)
    8000469c:	e822                	sd	s0,16(sp)
    8000469e:	e426                	sd	s1,8(sp)
    800046a0:	e04a                	sd	s2,0(sp)
    800046a2:	1000                	addi	s0,sp,32
    800046a4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800046a6:	0005c517          	auipc	a0,0x5c
    800046aa:	5aa50513          	addi	a0,a0,1450 # 80060c50 <itable>
    800046ae:	ffffc097          	auipc	ra,0xffffc
    800046b2:	51c080e7          	jalr	1308(ra) # 80000bca <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800046b6:	4498                	lw	a4,8(s1)
    800046b8:	4785                	li	a5,1
    800046ba:	02f70363          	beq	a4,a5,800046e0 <iput+0x48>
  ip->ref--;
    800046be:	449c                	lw	a5,8(s1)
    800046c0:	37fd                	addiw	a5,a5,-1
    800046c2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800046c4:	0005c517          	auipc	a0,0x5c
    800046c8:	58c50513          	addi	a0,a0,1420 # 80060c50 <itable>
    800046cc:	ffffc097          	auipc	ra,0xffffc
    800046d0:	5b8080e7          	jalr	1464(ra) # 80000c84 <release>
}
    800046d4:	60e2                	ld	ra,24(sp)
    800046d6:	6442                	ld	s0,16(sp)
    800046d8:	64a2                	ld	s1,8(sp)
    800046da:	6902                	ld	s2,0(sp)
    800046dc:	6105                	addi	sp,sp,32
    800046de:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800046e0:	40bc                	lw	a5,64(s1)
    800046e2:	dff1                	beqz	a5,800046be <iput+0x26>
    800046e4:	04a49783          	lh	a5,74(s1)
    800046e8:	fbf9                	bnez	a5,800046be <iput+0x26>
    acquiresleep(&ip->lock);
    800046ea:	01048913          	addi	s2,s1,16
    800046ee:	854a                	mv	a0,s2
    800046f0:	00001097          	auipc	ra,0x1
    800046f4:	ac0080e7          	jalr	-1344(ra) # 800051b0 <acquiresleep>
    release(&itable.lock);
    800046f8:	0005c517          	auipc	a0,0x5c
    800046fc:	55850513          	addi	a0,a0,1368 # 80060c50 <itable>
    80004700:	ffffc097          	auipc	ra,0xffffc
    80004704:	584080e7          	jalr	1412(ra) # 80000c84 <release>
    itrunc(ip);
    80004708:	8526                	mv	a0,s1
    8000470a:	00000097          	auipc	ra,0x0
    8000470e:	ee2080e7          	jalr	-286(ra) # 800045ec <itrunc>
    ip->type = 0;
    80004712:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004716:	8526                	mv	a0,s1
    80004718:	00000097          	auipc	ra,0x0
    8000471c:	cfc080e7          	jalr	-772(ra) # 80004414 <iupdate>
    ip->valid = 0;
    80004720:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004724:	854a                	mv	a0,s2
    80004726:	00001097          	auipc	ra,0x1
    8000472a:	ae0080e7          	jalr	-1312(ra) # 80005206 <releasesleep>
    acquire(&itable.lock);
    8000472e:	0005c517          	auipc	a0,0x5c
    80004732:	52250513          	addi	a0,a0,1314 # 80060c50 <itable>
    80004736:	ffffc097          	auipc	ra,0xffffc
    8000473a:	494080e7          	jalr	1172(ra) # 80000bca <acquire>
    8000473e:	b741                	j	800046be <iput+0x26>

0000000080004740 <iunlockput>:
{
    80004740:	1101                	addi	sp,sp,-32
    80004742:	ec06                	sd	ra,24(sp)
    80004744:	e822                	sd	s0,16(sp)
    80004746:	e426                	sd	s1,8(sp)
    80004748:	1000                	addi	s0,sp,32
    8000474a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000474c:	00000097          	auipc	ra,0x0
    80004750:	e54080e7          	jalr	-428(ra) # 800045a0 <iunlock>
  iput(ip);
    80004754:	8526                	mv	a0,s1
    80004756:	00000097          	auipc	ra,0x0
    8000475a:	f42080e7          	jalr	-190(ra) # 80004698 <iput>
}
    8000475e:	60e2                	ld	ra,24(sp)
    80004760:	6442                	ld	s0,16(sp)
    80004762:	64a2                	ld	s1,8(sp)
    80004764:	6105                	addi	sp,sp,32
    80004766:	8082                	ret

0000000080004768 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004768:	1141                	addi	sp,sp,-16
    8000476a:	e422                	sd	s0,8(sp)
    8000476c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000476e:	411c                	lw	a5,0(a0)
    80004770:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80004772:	415c                	lw	a5,4(a0)
    80004774:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80004776:	04451783          	lh	a5,68(a0)
    8000477a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000477e:	04a51783          	lh	a5,74(a0)
    80004782:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004786:	04c56783          	lwu	a5,76(a0)
    8000478a:	e99c                	sd	a5,16(a1)
}
    8000478c:	6422                	ld	s0,8(sp)
    8000478e:	0141                	addi	sp,sp,16
    80004790:	8082                	ret

0000000080004792 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004792:	457c                	lw	a5,76(a0)
    80004794:	0ed7e963          	bltu	a5,a3,80004886 <readi+0xf4>
{
    80004798:	7159                	addi	sp,sp,-112
    8000479a:	f486                	sd	ra,104(sp)
    8000479c:	f0a2                	sd	s0,96(sp)
    8000479e:	eca6                	sd	s1,88(sp)
    800047a0:	e8ca                	sd	s2,80(sp)
    800047a2:	e4ce                	sd	s3,72(sp)
    800047a4:	e0d2                	sd	s4,64(sp)
    800047a6:	fc56                	sd	s5,56(sp)
    800047a8:	f85a                	sd	s6,48(sp)
    800047aa:	f45e                	sd	s7,40(sp)
    800047ac:	f062                	sd	s8,32(sp)
    800047ae:	ec66                	sd	s9,24(sp)
    800047b0:	e86a                	sd	s10,16(sp)
    800047b2:	e46e                	sd	s11,8(sp)
    800047b4:	1880                	addi	s0,sp,112
    800047b6:	8baa                	mv	s7,a0
    800047b8:	8c2e                	mv	s8,a1
    800047ba:	8ab2                	mv	s5,a2
    800047bc:	84b6                	mv	s1,a3
    800047be:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800047c0:	9f35                	addw	a4,a4,a3
    return 0;
    800047c2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800047c4:	0ad76063          	bltu	a4,a3,80004864 <readi+0xd2>
  if(off + n > ip->size)
    800047c8:	00e7f463          	bgeu	a5,a4,800047d0 <readi+0x3e>
    n = ip->size - off;
    800047cc:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800047d0:	0a0b0963          	beqz	s6,80004882 <readi+0xf0>
    800047d4:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800047d6:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800047da:	5cfd                	li	s9,-1
    800047dc:	a82d                	j	80004816 <readi+0x84>
    800047de:	020a1d93          	slli	s11,s4,0x20
    800047e2:	020ddd93          	srli	s11,s11,0x20
    800047e6:	05890793          	addi	a5,s2,88
    800047ea:	86ee                	mv	a3,s11
    800047ec:	963e                	add	a2,a2,a5
    800047ee:	85d6                	mv	a1,s5
    800047f0:	8562                	mv	a0,s8
    800047f2:	ffffe097          	auipc	ra,0xffffe
    800047f6:	07e080e7          	jalr	126(ra) # 80002870 <either_copyout>
    800047fa:	05950d63          	beq	a0,s9,80004854 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800047fe:	854a                	mv	a0,s2
    80004800:	fffff097          	auipc	ra,0xfffff
    80004804:	60a080e7          	jalr	1546(ra) # 80003e0a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004808:	013a09bb          	addw	s3,s4,s3
    8000480c:	009a04bb          	addw	s1,s4,s1
    80004810:	9aee                	add	s5,s5,s11
    80004812:	0569f763          	bgeu	s3,s6,80004860 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004816:	000ba903          	lw	s2,0(s7)
    8000481a:	00a4d59b          	srliw	a1,s1,0xa
    8000481e:	855e                	mv	a0,s7
    80004820:	00000097          	auipc	ra,0x0
    80004824:	8ae080e7          	jalr	-1874(ra) # 800040ce <bmap>
    80004828:	0005059b          	sext.w	a1,a0
    8000482c:	854a                	mv	a0,s2
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	4ac080e7          	jalr	1196(ra) # 80003cda <bread>
    80004836:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004838:	3ff4f613          	andi	a2,s1,1023
    8000483c:	40cd07bb          	subw	a5,s10,a2
    80004840:	413b073b          	subw	a4,s6,s3
    80004844:	8a3e                	mv	s4,a5
    80004846:	2781                	sext.w	a5,a5
    80004848:	0007069b          	sext.w	a3,a4
    8000484c:	f8f6f9e3          	bgeu	a3,a5,800047de <readi+0x4c>
    80004850:	8a3a                	mv	s4,a4
    80004852:	b771                	j	800047de <readi+0x4c>
      brelse(bp);
    80004854:	854a                	mv	a0,s2
    80004856:	fffff097          	auipc	ra,0xfffff
    8000485a:	5b4080e7          	jalr	1460(ra) # 80003e0a <brelse>
      tot = -1;
    8000485e:	59fd                	li	s3,-1
  }
  return tot;
    80004860:	0009851b          	sext.w	a0,s3
}
    80004864:	70a6                	ld	ra,104(sp)
    80004866:	7406                	ld	s0,96(sp)
    80004868:	64e6                	ld	s1,88(sp)
    8000486a:	6946                	ld	s2,80(sp)
    8000486c:	69a6                	ld	s3,72(sp)
    8000486e:	6a06                	ld	s4,64(sp)
    80004870:	7ae2                	ld	s5,56(sp)
    80004872:	7b42                	ld	s6,48(sp)
    80004874:	7ba2                	ld	s7,40(sp)
    80004876:	7c02                	ld	s8,32(sp)
    80004878:	6ce2                	ld	s9,24(sp)
    8000487a:	6d42                	ld	s10,16(sp)
    8000487c:	6da2                	ld	s11,8(sp)
    8000487e:	6165                	addi	sp,sp,112
    80004880:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004882:	89da                	mv	s3,s6
    80004884:	bff1                	j	80004860 <readi+0xce>
    return 0;
    80004886:	4501                	li	a0,0
}
    80004888:	8082                	ret

000000008000488a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000488a:	457c                	lw	a5,76(a0)
    8000488c:	10d7e863          	bltu	a5,a3,8000499c <writei+0x112>
{
    80004890:	7159                	addi	sp,sp,-112
    80004892:	f486                	sd	ra,104(sp)
    80004894:	f0a2                	sd	s0,96(sp)
    80004896:	eca6                	sd	s1,88(sp)
    80004898:	e8ca                	sd	s2,80(sp)
    8000489a:	e4ce                	sd	s3,72(sp)
    8000489c:	e0d2                	sd	s4,64(sp)
    8000489e:	fc56                	sd	s5,56(sp)
    800048a0:	f85a                	sd	s6,48(sp)
    800048a2:	f45e                	sd	s7,40(sp)
    800048a4:	f062                	sd	s8,32(sp)
    800048a6:	ec66                	sd	s9,24(sp)
    800048a8:	e86a                	sd	s10,16(sp)
    800048aa:	e46e                	sd	s11,8(sp)
    800048ac:	1880                	addi	s0,sp,112
    800048ae:	8b2a                	mv	s6,a0
    800048b0:	8c2e                	mv	s8,a1
    800048b2:	8ab2                	mv	s5,a2
    800048b4:	8936                	mv	s2,a3
    800048b6:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800048b8:	00e687bb          	addw	a5,a3,a4
    800048bc:	0ed7e263          	bltu	a5,a3,800049a0 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800048c0:	00043737          	lui	a4,0x43
    800048c4:	0ef76063          	bltu	a4,a5,800049a4 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800048c8:	0c0b8863          	beqz	s7,80004998 <writei+0x10e>
    800048cc:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800048ce:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800048d2:	5cfd                	li	s9,-1
    800048d4:	a091                	j	80004918 <writei+0x8e>
    800048d6:	02099d93          	slli	s11,s3,0x20
    800048da:	020ddd93          	srli	s11,s11,0x20
    800048de:	05848793          	addi	a5,s1,88
    800048e2:	86ee                	mv	a3,s11
    800048e4:	8656                	mv	a2,s5
    800048e6:	85e2                	mv	a1,s8
    800048e8:	953e                	add	a0,a0,a5
    800048ea:	ffffe097          	auipc	ra,0xffffe
    800048ee:	fe2080e7          	jalr	-30(ra) # 800028cc <either_copyin>
    800048f2:	07950263          	beq	a0,s9,80004956 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800048f6:	8526                	mv	a0,s1
    800048f8:	00000097          	auipc	ra,0x0
    800048fc:	798080e7          	jalr	1944(ra) # 80005090 <log_write>
    brelse(bp);
    80004900:	8526                	mv	a0,s1
    80004902:	fffff097          	auipc	ra,0xfffff
    80004906:	508080e7          	jalr	1288(ra) # 80003e0a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000490a:	01498a3b          	addw	s4,s3,s4
    8000490e:	0129893b          	addw	s2,s3,s2
    80004912:	9aee                	add	s5,s5,s11
    80004914:	057a7663          	bgeu	s4,s7,80004960 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004918:	000b2483          	lw	s1,0(s6)
    8000491c:	00a9559b          	srliw	a1,s2,0xa
    80004920:	855a                	mv	a0,s6
    80004922:	fffff097          	auipc	ra,0xfffff
    80004926:	7ac080e7          	jalr	1964(ra) # 800040ce <bmap>
    8000492a:	0005059b          	sext.w	a1,a0
    8000492e:	8526                	mv	a0,s1
    80004930:	fffff097          	auipc	ra,0xfffff
    80004934:	3aa080e7          	jalr	938(ra) # 80003cda <bread>
    80004938:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000493a:	3ff97513          	andi	a0,s2,1023
    8000493e:	40ad07bb          	subw	a5,s10,a0
    80004942:	414b873b          	subw	a4,s7,s4
    80004946:	89be                	mv	s3,a5
    80004948:	2781                	sext.w	a5,a5
    8000494a:	0007069b          	sext.w	a3,a4
    8000494e:	f8f6f4e3          	bgeu	a3,a5,800048d6 <writei+0x4c>
    80004952:	89ba                	mv	s3,a4
    80004954:	b749                	j	800048d6 <writei+0x4c>
      brelse(bp);
    80004956:	8526                	mv	a0,s1
    80004958:	fffff097          	auipc	ra,0xfffff
    8000495c:	4b2080e7          	jalr	1202(ra) # 80003e0a <brelse>
  }

  if(off > ip->size)
    80004960:	04cb2783          	lw	a5,76(s6)
    80004964:	0127f463          	bgeu	a5,s2,8000496c <writei+0xe2>
    ip->size = off;
    80004968:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000496c:	855a                	mv	a0,s6
    8000496e:	00000097          	auipc	ra,0x0
    80004972:	aa6080e7          	jalr	-1370(ra) # 80004414 <iupdate>

  return tot;
    80004976:	000a051b          	sext.w	a0,s4
}
    8000497a:	70a6                	ld	ra,104(sp)
    8000497c:	7406                	ld	s0,96(sp)
    8000497e:	64e6                	ld	s1,88(sp)
    80004980:	6946                	ld	s2,80(sp)
    80004982:	69a6                	ld	s3,72(sp)
    80004984:	6a06                	ld	s4,64(sp)
    80004986:	7ae2                	ld	s5,56(sp)
    80004988:	7b42                	ld	s6,48(sp)
    8000498a:	7ba2                	ld	s7,40(sp)
    8000498c:	7c02                	ld	s8,32(sp)
    8000498e:	6ce2                	ld	s9,24(sp)
    80004990:	6d42                	ld	s10,16(sp)
    80004992:	6da2                	ld	s11,8(sp)
    80004994:	6165                	addi	sp,sp,112
    80004996:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004998:	8a5e                	mv	s4,s7
    8000499a:	bfc9                	j	8000496c <writei+0xe2>
    return -1;
    8000499c:	557d                	li	a0,-1
}
    8000499e:	8082                	ret
    return -1;
    800049a0:	557d                	li	a0,-1
    800049a2:	bfe1                	j	8000497a <writei+0xf0>
    return -1;
    800049a4:	557d                	li	a0,-1
    800049a6:	bfd1                	j	8000497a <writei+0xf0>

00000000800049a8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800049a8:	1141                	addi	sp,sp,-16
    800049aa:	e406                	sd	ra,8(sp)
    800049ac:	e022                	sd	s0,0(sp)
    800049ae:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800049b0:	4639                	li	a2,14
    800049b2:	ffffc097          	auipc	ra,0xffffc
    800049b6:	3f2080e7          	jalr	1010(ra) # 80000da4 <strncmp>
}
    800049ba:	60a2                	ld	ra,8(sp)
    800049bc:	6402                	ld	s0,0(sp)
    800049be:	0141                	addi	sp,sp,16
    800049c0:	8082                	ret

00000000800049c2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800049c2:	7139                	addi	sp,sp,-64
    800049c4:	fc06                	sd	ra,56(sp)
    800049c6:	f822                	sd	s0,48(sp)
    800049c8:	f426                	sd	s1,40(sp)
    800049ca:	f04a                	sd	s2,32(sp)
    800049cc:	ec4e                	sd	s3,24(sp)
    800049ce:	e852                	sd	s4,16(sp)
    800049d0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800049d2:	04451703          	lh	a4,68(a0)
    800049d6:	4785                	li	a5,1
    800049d8:	00f71a63          	bne	a4,a5,800049ec <dirlookup+0x2a>
    800049dc:	892a                	mv	s2,a0
    800049de:	89ae                	mv	s3,a1
    800049e0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800049e2:	457c                	lw	a5,76(a0)
    800049e4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800049e6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800049e8:	e79d                	bnez	a5,80004a16 <dirlookup+0x54>
    800049ea:	a8a5                	j	80004a62 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800049ec:	00005517          	auipc	a0,0x5
    800049f0:	d3450513          	addi	a0,a0,-716 # 80009720 <syscalls+0x220>
    800049f4:	ffffc097          	auipc	ra,0xffffc
    800049f8:	b36080e7          	jalr	-1226(ra) # 8000052a <panic>
      panic("dirlookup read");
    800049fc:	00005517          	auipc	a0,0x5
    80004a00:	d3c50513          	addi	a0,a0,-708 # 80009738 <syscalls+0x238>
    80004a04:	ffffc097          	auipc	ra,0xffffc
    80004a08:	b26080e7          	jalr	-1242(ra) # 8000052a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004a0c:	24c1                	addiw	s1,s1,16
    80004a0e:	04c92783          	lw	a5,76(s2)
    80004a12:	04f4f763          	bgeu	s1,a5,80004a60 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a16:	4741                	li	a4,16
    80004a18:	86a6                	mv	a3,s1
    80004a1a:	fc040613          	addi	a2,s0,-64
    80004a1e:	4581                	li	a1,0
    80004a20:	854a                	mv	a0,s2
    80004a22:	00000097          	auipc	ra,0x0
    80004a26:	d70080e7          	jalr	-656(ra) # 80004792 <readi>
    80004a2a:	47c1                	li	a5,16
    80004a2c:	fcf518e3          	bne	a0,a5,800049fc <dirlookup+0x3a>
    if(de.inum == 0)
    80004a30:	fc045783          	lhu	a5,-64(s0)
    80004a34:	dfe1                	beqz	a5,80004a0c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004a36:	fc240593          	addi	a1,s0,-62
    80004a3a:	854e                	mv	a0,s3
    80004a3c:	00000097          	auipc	ra,0x0
    80004a40:	f6c080e7          	jalr	-148(ra) # 800049a8 <namecmp>
    80004a44:	f561                	bnez	a0,80004a0c <dirlookup+0x4a>
      if(poff)
    80004a46:	000a0463          	beqz	s4,80004a4e <dirlookup+0x8c>
        *poff = off;
    80004a4a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004a4e:	fc045583          	lhu	a1,-64(s0)
    80004a52:	00092503          	lw	a0,0(s2)
    80004a56:	fffff097          	auipc	ra,0xfffff
    80004a5a:	754080e7          	jalr	1876(ra) # 800041aa <iget>
    80004a5e:	a011                	j	80004a62 <dirlookup+0xa0>
  return 0;
    80004a60:	4501                	li	a0,0
}
    80004a62:	70e2                	ld	ra,56(sp)
    80004a64:	7442                	ld	s0,48(sp)
    80004a66:	74a2                	ld	s1,40(sp)
    80004a68:	7902                	ld	s2,32(sp)
    80004a6a:	69e2                	ld	s3,24(sp)
    80004a6c:	6a42                	ld	s4,16(sp)
    80004a6e:	6121                	addi	sp,sp,64
    80004a70:	8082                	ret

0000000080004a72 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004a72:	711d                	addi	sp,sp,-96
    80004a74:	ec86                	sd	ra,88(sp)
    80004a76:	e8a2                	sd	s0,80(sp)
    80004a78:	e4a6                	sd	s1,72(sp)
    80004a7a:	e0ca                	sd	s2,64(sp)
    80004a7c:	fc4e                	sd	s3,56(sp)
    80004a7e:	f852                	sd	s4,48(sp)
    80004a80:	f456                	sd	s5,40(sp)
    80004a82:	f05a                	sd	s6,32(sp)
    80004a84:	ec5e                	sd	s7,24(sp)
    80004a86:	e862                	sd	s8,16(sp)
    80004a88:	e466                	sd	s9,8(sp)
    80004a8a:	1080                	addi	s0,sp,96
    80004a8c:	84aa                	mv	s1,a0
    80004a8e:	8aae                	mv	s5,a1
    80004a90:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004a92:	00054703          	lbu	a4,0(a0)
    80004a96:	02f00793          	li	a5,47
    80004a9a:	02f70563          	beq	a4,a5,80004ac4 <namex+0x52>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004a9e:	ffffd097          	auipc	ra,0xffffd
    80004aa2:	f5a080e7          	jalr	-166(ra) # 800019f8 <myproc>
    80004aa6:	6785                	lui	a5,0x1
    80004aa8:	97aa                	add	a5,a5,a0
    80004aaa:	fc87b503          	ld	a0,-56(a5) # fc8 <_entry-0x7ffff038>
    80004aae:	00000097          	auipc	ra,0x0
    80004ab2:	9f2080e7          	jalr	-1550(ra) # 800044a0 <idup>
    80004ab6:	89aa                	mv	s3,a0
  while(*path == '/')
    80004ab8:	02f00913          	li	s2,47
  len = path - s;
    80004abc:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80004abe:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004ac0:	4b85                	li	s7,1
    80004ac2:	a865                	j	80004b7a <namex+0x108>
    ip = iget(ROOTDEV, ROOTINO);
    80004ac4:	4585                	li	a1,1
    80004ac6:	4505                	li	a0,1
    80004ac8:	fffff097          	auipc	ra,0xfffff
    80004acc:	6e2080e7          	jalr	1762(ra) # 800041aa <iget>
    80004ad0:	89aa                	mv	s3,a0
    80004ad2:	b7dd                	j	80004ab8 <namex+0x46>
      iunlockput(ip);
    80004ad4:	854e                	mv	a0,s3
    80004ad6:	00000097          	auipc	ra,0x0
    80004ada:	c6a080e7          	jalr	-918(ra) # 80004740 <iunlockput>
      return 0;
    80004ade:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004ae0:	854e                	mv	a0,s3
    80004ae2:	60e6                	ld	ra,88(sp)
    80004ae4:	6446                	ld	s0,80(sp)
    80004ae6:	64a6                	ld	s1,72(sp)
    80004ae8:	6906                	ld	s2,64(sp)
    80004aea:	79e2                	ld	s3,56(sp)
    80004aec:	7a42                	ld	s4,48(sp)
    80004aee:	7aa2                	ld	s5,40(sp)
    80004af0:	7b02                	ld	s6,32(sp)
    80004af2:	6be2                	ld	s7,24(sp)
    80004af4:	6c42                	ld	s8,16(sp)
    80004af6:	6ca2                	ld	s9,8(sp)
    80004af8:	6125                	addi	sp,sp,96
    80004afa:	8082                	ret
      iunlock(ip);
    80004afc:	854e                	mv	a0,s3
    80004afe:	00000097          	auipc	ra,0x0
    80004b02:	aa2080e7          	jalr	-1374(ra) # 800045a0 <iunlock>
      return ip;
    80004b06:	bfe9                	j	80004ae0 <namex+0x6e>
      iunlockput(ip);
    80004b08:	854e                	mv	a0,s3
    80004b0a:	00000097          	auipc	ra,0x0
    80004b0e:	c36080e7          	jalr	-970(ra) # 80004740 <iunlockput>
      return 0;
    80004b12:	89e6                	mv	s3,s9
    80004b14:	b7f1                	j	80004ae0 <namex+0x6e>
  len = path - s;
    80004b16:	40b48633          	sub	a2,s1,a1
    80004b1a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004b1e:	099c5463          	bge	s8,s9,80004ba6 <namex+0x134>
    memmove(name, s, DIRSIZ);
    80004b22:	4639                	li	a2,14
    80004b24:	8552                	mv	a0,s4
    80004b26:	ffffc097          	auipc	ra,0xffffc
    80004b2a:	202080e7          	jalr	514(ra) # 80000d28 <memmove>
  while(*path == '/')
    80004b2e:	0004c783          	lbu	a5,0(s1)
    80004b32:	01279763          	bne	a5,s2,80004b40 <namex+0xce>
    path++;
    80004b36:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004b38:	0004c783          	lbu	a5,0(s1)
    80004b3c:	ff278de3          	beq	a5,s2,80004b36 <namex+0xc4>
    ilock(ip);
    80004b40:	854e                	mv	a0,s3
    80004b42:	00000097          	auipc	ra,0x0
    80004b46:	99c080e7          	jalr	-1636(ra) # 800044de <ilock>
    if(ip->type != T_DIR){
    80004b4a:	04499783          	lh	a5,68(s3)
    80004b4e:	f97793e3          	bne	a5,s7,80004ad4 <namex+0x62>
    if(nameiparent && *path == '\0'){
    80004b52:	000a8563          	beqz	s5,80004b5c <namex+0xea>
    80004b56:	0004c783          	lbu	a5,0(s1)
    80004b5a:	d3cd                	beqz	a5,80004afc <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004b5c:	865a                	mv	a2,s6
    80004b5e:	85d2                	mv	a1,s4
    80004b60:	854e                	mv	a0,s3
    80004b62:	00000097          	auipc	ra,0x0
    80004b66:	e60080e7          	jalr	-416(ra) # 800049c2 <dirlookup>
    80004b6a:	8caa                	mv	s9,a0
    80004b6c:	dd51                	beqz	a0,80004b08 <namex+0x96>
    iunlockput(ip);
    80004b6e:	854e                	mv	a0,s3
    80004b70:	00000097          	auipc	ra,0x0
    80004b74:	bd0080e7          	jalr	-1072(ra) # 80004740 <iunlockput>
    ip = next;
    80004b78:	89e6                	mv	s3,s9
  while(*path == '/')
    80004b7a:	0004c783          	lbu	a5,0(s1)
    80004b7e:	05279763          	bne	a5,s2,80004bcc <namex+0x15a>
    path++;
    80004b82:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004b84:	0004c783          	lbu	a5,0(s1)
    80004b88:	ff278de3          	beq	a5,s2,80004b82 <namex+0x110>
  if(*path == 0)
    80004b8c:	c79d                	beqz	a5,80004bba <namex+0x148>
    path++;
    80004b8e:	85a6                	mv	a1,s1
  len = path - s;
    80004b90:	8cda                	mv	s9,s6
    80004b92:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80004b94:	01278963          	beq	a5,s2,80004ba6 <namex+0x134>
    80004b98:	dfbd                	beqz	a5,80004b16 <namex+0xa4>
    path++;
    80004b9a:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80004b9c:	0004c783          	lbu	a5,0(s1)
    80004ba0:	ff279ce3          	bne	a5,s2,80004b98 <namex+0x126>
    80004ba4:	bf8d                	j	80004b16 <namex+0xa4>
    memmove(name, s, len);
    80004ba6:	2601                	sext.w	a2,a2
    80004ba8:	8552                	mv	a0,s4
    80004baa:	ffffc097          	auipc	ra,0xffffc
    80004bae:	17e080e7          	jalr	382(ra) # 80000d28 <memmove>
    name[len] = 0;
    80004bb2:	9cd2                	add	s9,s9,s4
    80004bb4:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004bb8:	bf9d                	j	80004b2e <namex+0xbc>
  if(nameiparent){
    80004bba:	f20a83e3          	beqz	s5,80004ae0 <namex+0x6e>
    iput(ip);
    80004bbe:	854e                	mv	a0,s3
    80004bc0:	00000097          	auipc	ra,0x0
    80004bc4:	ad8080e7          	jalr	-1320(ra) # 80004698 <iput>
    return 0;
    80004bc8:	4981                	li	s3,0
    80004bca:	bf19                	j	80004ae0 <namex+0x6e>
  if(*path == 0)
    80004bcc:	d7fd                	beqz	a5,80004bba <namex+0x148>
  while(*path != '/' && *path != 0)
    80004bce:	0004c783          	lbu	a5,0(s1)
    80004bd2:	85a6                	mv	a1,s1
    80004bd4:	b7d1                	j	80004b98 <namex+0x126>

0000000080004bd6 <dirlink>:
{
    80004bd6:	7139                	addi	sp,sp,-64
    80004bd8:	fc06                	sd	ra,56(sp)
    80004bda:	f822                	sd	s0,48(sp)
    80004bdc:	f426                	sd	s1,40(sp)
    80004bde:	f04a                	sd	s2,32(sp)
    80004be0:	ec4e                	sd	s3,24(sp)
    80004be2:	e852                	sd	s4,16(sp)
    80004be4:	0080                	addi	s0,sp,64
    80004be6:	892a                	mv	s2,a0
    80004be8:	8a2e                	mv	s4,a1
    80004bea:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004bec:	4601                	li	a2,0
    80004bee:	00000097          	auipc	ra,0x0
    80004bf2:	dd4080e7          	jalr	-556(ra) # 800049c2 <dirlookup>
    80004bf6:	e93d                	bnez	a0,80004c6c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004bf8:	04c92483          	lw	s1,76(s2)
    80004bfc:	c49d                	beqz	s1,80004c2a <dirlink+0x54>
    80004bfe:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c00:	4741                	li	a4,16
    80004c02:	86a6                	mv	a3,s1
    80004c04:	fc040613          	addi	a2,s0,-64
    80004c08:	4581                	li	a1,0
    80004c0a:	854a                	mv	a0,s2
    80004c0c:	00000097          	auipc	ra,0x0
    80004c10:	b86080e7          	jalr	-1146(ra) # 80004792 <readi>
    80004c14:	47c1                	li	a5,16
    80004c16:	06f51163          	bne	a0,a5,80004c78 <dirlink+0xa2>
    if(de.inum == 0)
    80004c1a:	fc045783          	lhu	a5,-64(s0)
    80004c1e:	c791                	beqz	a5,80004c2a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004c20:	24c1                	addiw	s1,s1,16
    80004c22:	04c92783          	lw	a5,76(s2)
    80004c26:	fcf4ede3          	bltu	s1,a5,80004c00 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004c2a:	4639                	li	a2,14
    80004c2c:	85d2                	mv	a1,s4
    80004c2e:	fc240513          	addi	a0,s0,-62
    80004c32:	ffffc097          	auipc	ra,0xffffc
    80004c36:	1ae080e7          	jalr	430(ra) # 80000de0 <strncpy>
  de.inum = inum;
    80004c3a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c3e:	4741                	li	a4,16
    80004c40:	86a6                	mv	a3,s1
    80004c42:	fc040613          	addi	a2,s0,-64
    80004c46:	4581                	li	a1,0
    80004c48:	854a                	mv	a0,s2
    80004c4a:	00000097          	auipc	ra,0x0
    80004c4e:	c40080e7          	jalr	-960(ra) # 8000488a <writei>
    80004c52:	872a                	mv	a4,a0
    80004c54:	47c1                	li	a5,16
  return 0;
    80004c56:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c58:	02f71863          	bne	a4,a5,80004c88 <dirlink+0xb2>
}
    80004c5c:	70e2                	ld	ra,56(sp)
    80004c5e:	7442                	ld	s0,48(sp)
    80004c60:	74a2                	ld	s1,40(sp)
    80004c62:	7902                	ld	s2,32(sp)
    80004c64:	69e2                	ld	s3,24(sp)
    80004c66:	6a42                	ld	s4,16(sp)
    80004c68:	6121                	addi	sp,sp,64
    80004c6a:	8082                	ret
    iput(ip);
    80004c6c:	00000097          	auipc	ra,0x0
    80004c70:	a2c080e7          	jalr	-1492(ra) # 80004698 <iput>
    return -1;
    80004c74:	557d                	li	a0,-1
    80004c76:	b7dd                	j	80004c5c <dirlink+0x86>
      panic("dirlink read");
    80004c78:	00005517          	auipc	a0,0x5
    80004c7c:	ad050513          	addi	a0,a0,-1328 # 80009748 <syscalls+0x248>
    80004c80:	ffffc097          	auipc	ra,0xffffc
    80004c84:	8aa080e7          	jalr	-1878(ra) # 8000052a <panic>
    panic("dirlink");
    80004c88:	00005517          	auipc	a0,0x5
    80004c8c:	bd050513          	addi	a0,a0,-1072 # 80009858 <syscalls+0x358>
    80004c90:	ffffc097          	auipc	ra,0xffffc
    80004c94:	89a080e7          	jalr	-1894(ra) # 8000052a <panic>

0000000080004c98 <namei>:

struct inode*
namei(char *path)
{
    80004c98:	1101                	addi	sp,sp,-32
    80004c9a:	ec06                	sd	ra,24(sp)
    80004c9c:	e822                	sd	s0,16(sp)
    80004c9e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004ca0:	fe040613          	addi	a2,s0,-32
    80004ca4:	4581                	li	a1,0
    80004ca6:	00000097          	auipc	ra,0x0
    80004caa:	dcc080e7          	jalr	-564(ra) # 80004a72 <namex>
}
    80004cae:	60e2                	ld	ra,24(sp)
    80004cb0:	6442                	ld	s0,16(sp)
    80004cb2:	6105                	addi	sp,sp,32
    80004cb4:	8082                	ret

0000000080004cb6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004cb6:	1141                	addi	sp,sp,-16
    80004cb8:	e406                	sd	ra,8(sp)
    80004cba:	e022                	sd	s0,0(sp)
    80004cbc:	0800                	addi	s0,sp,16
    80004cbe:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004cc0:	4585                	li	a1,1
    80004cc2:	00000097          	auipc	ra,0x0
    80004cc6:	db0080e7          	jalr	-592(ra) # 80004a72 <namex>
}
    80004cca:	60a2                	ld	ra,8(sp)
    80004ccc:	6402                	ld	s0,0(sp)
    80004cce:	0141                	addi	sp,sp,16
    80004cd0:	8082                	ret

0000000080004cd2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004cd2:	1101                	addi	sp,sp,-32
    80004cd4:	ec06                	sd	ra,24(sp)
    80004cd6:	e822                	sd	s0,16(sp)
    80004cd8:	e426                	sd	s1,8(sp)
    80004cda:	e04a                	sd	s2,0(sp)
    80004cdc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004cde:	0005e917          	auipc	s2,0x5e
    80004ce2:	a1a90913          	addi	s2,s2,-1510 # 800626f8 <log>
    80004ce6:	01892583          	lw	a1,24(s2)
    80004cea:	02892503          	lw	a0,40(s2)
    80004cee:	fffff097          	auipc	ra,0xfffff
    80004cf2:	fec080e7          	jalr	-20(ra) # 80003cda <bread>
    80004cf6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004cf8:	02c92683          	lw	a3,44(s2)
    80004cfc:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004cfe:	02d05863          	blez	a3,80004d2e <write_head+0x5c>
    80004d02:	0005e797          	auipc	a5,0x5e
    80004d06:	a2678793          	addi	a5,a5,-1498 # 80062728 <log+0x30>
    80004d0a:	05c50713          	addi	a4,a0,92
    80004d0e:	36fd                	addiw	a3,a3,-1
    80004d10:	02069613          	slli	a2,a3,0x20
    80004d14:	01e65693          	srli	a3,a2,0x1e
    80004d18:	0005e617          	auipc	a2,0x5e
    80004d1c:	a1460613          	addi	a2,a2,-1516 # 8006272c <log+0x34>
    80004d20:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004d22:	4390                	lw	a2,0(a5)
    80004d24:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004d26:	0791                	addi	a5,a5,4
    80004d28:	0711                	addi	a4,a4,4
    80004d2a:	fed79ce3          	bne	a5,a3,80004d22 <write_head+0x50>
  }
  bwrite(buf);
    80004d2e:	8526                	mv	a0,s1
    80004d30:	fffff097          	auipc	ra,0xfffff
    80004d34:	09c080e7          	jalr	156(ra) # 80003dcc <bwrite>
  brelse(buf);
    80004d38:	8526                	mv	a0,s1
    80004d3a:	fffff097          	auipc	ra,0xfffff
    80004d3e:	0d0080e7          	jalr	208(ra) # 80003e0a <brelse>
}
    80004d42:	60e2                	ld	ra,24(sp)
    80004d44:	6442                	ld	s0,16(sp)
    80004d46:	64a2                	ld	s1,8(sp)
    80004d48:	6902                	ld	s2,0(sp)
    80004d4a:	6105                	addi	sp,sp,32
    80004d4c:	8082                	ret

0000000080004d4e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004d4e:	0005e797          	auipc	a5,0x5e
    80004d52:	9d67a783          	lw	a5,-1578(a5) # 80062724 <log+0x2c>
    80004d56:	0af05d63          	blez	a5,80004e10 <install_trans+0xc2>
{
    80004d5a:	7139                	addi	sp,sp,-64
    80004d5c:	fc06                	sd	ra,56(sp)
    80004d5e:	f822                	sd	s0,48(sp)
    80004d60:	f426                	sd	s1,40(sp)
    80004d62:	f04a                	sd	s2,32(sp)
    80004d64:	ec4e                	sd	s3,24(sp)
    80004d66:	e852                	sd	s4,16(sp)
    80004d68:	e456                	sd	s5,8(sp)
    80004d6a:	e05a                	sd	s6,0(sp)
    80004d6c:	0080                	addi	s0,sp,64
    80004d6e:	8b2a                	mv	s6,a0
    80004d70:	0005ea97          	auipc	s5,0x5e
    80004d74:	9b8a8a93          	addi	s5,s5,-1608 # 80062728 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004d78:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004d7a:	0005e997          	auipc	s3,0x5e
    80004d7e:	97e98993          	addi	s3,s3,-1666 # 800626f8 <log>
    80004d82:	a00d                	j	80004da4 <install_trans+0x56>
    brelse(lbuf);
    80004d84:	854a                	mv	a0,s2
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	084080e7          	jalr	132(ra) # 80003e0a <brelse>
    brelse(dbuf);
    80004d8e:	8526                	mv	a0,s1
    80004d90:	fffff097          	auipc	ra,0xfffff
    80004d94:	07a080e7          	jalr	122(ra) # 80003e0a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004d98:	2a05                	addiw	s4,s4,1
    80004d9a:	0a91                	addi	s5,s5,4
    80004d9c:	02c9a783          	lw	a5,44(s3)
    80004da0:	04fa5e63          	bge	s4,a5,80004dfc <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004da4:	0189a583          	lw	a1,24(s3)
    80004da8:	014585bb          	addw	a1,a1,s4
    80004dac:	2585                	addiw	a1,a1,1
    80004dae:	0289a503          	lw	a0,40(s3)
    80004db2:	fffff097          	auipc	ra,0xfffff
    80004db6:	f28080e7          	jalr	-216(ra) # 80003cda <bread>
    80004dba:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004dbc:	000aa583          	lw	a1,0(s5)
    80004dc0:	0289a503          	lw	a0,40(s3)
    80004dc4:	fffff097          	auipc	ra,0xfffff
    80004dc8:	f16080e7          	jalr	-234(ra) # 80003cda <bread>
    80004dcc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004dce:	40000613          	li	a2,1024
    80004dd2:	05890593          	addi	a1,s2,88
    80004dd6:	05850513          	addi	a0,a0,88
    80004dda:	ffffc097          	auipc	ra,0xffffc
    80004dde:	f4e080e7          	jalr	-178(ra) # 80000d28 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004de2:	8526                	mv	a0,s1
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	fe8080e7          	jalr	-24(ra) # 80003dcc <bwrite>
    if(recovering == 0)
    80004dec:	f80b1ce3          	bnez	s6,80004d84 <install_trans+0x36>
      bunpin(dbuf);
    80004df0:	8526                	mv	a0,s1
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	0f2080e7          	jalr	242(ra) # 80003ee4 <bunpin>
    80004dfa:	b769                	j	80004d84 <install_trans+0x36>
}
    80004dfc:	70e2                	ld	ra,56(sp)
    80004dfe:	7442                	ld	s0,48(sp)
    80004e00:	74a2                	ld	s1,40(sp)
    80004e02:	7902                	ld	s2,32(sp)
    80004e04:	69e2                	ld	s3,24(sp)
    80004e06:	6a42                	ld	s4,16(sp)
    80004e08:	6aa2                	ld	s5,8(sp)
    80004e0a:	6b02                	ld	s6,0(sp)
    80004e0c:	6121                	addi	sp,sp,64
    80004e0e:	8082                	ret
    80004e10:	8082                	ret

0000000080004e12 <initlog>:
{
    80004e12:	7179                	addi	sp,sp,-48
    80004e14:	f406                	sd	ra,40(sp)
    80004e16:	f022                	sd	s0,32(sp)
    80004e18:	ec26                	sd	s1,24(sp)
    80004e1a:	e84a                	sd	s2,16(sp)
    80004e1c:	e44e                	sd	s3,8(sp)
    80004e1e:	1800                	addi	s0,sp,48
    80004e20:	892a                	mv	s2,a0
    80004e22:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004e24:	0005e497          	auipc	s1,0x5e
    80004e28:	8d448493          	addi	s1,s1,-1836 # 800626f8 <log>
    80004e2c:	00005597          	auipc	a1,0x5
    80004e30:	92c58593          	addi	a1,a1,-1748 # 80009758 <syscalls+0x258>
    80004e34:	8526                	mv	a0,s1
    80004e36:	ffffc097          	auipc	ra,0xffffc
    80004e3a:	cfc080e7          	jalr	-772(ra) # 80000b32 <initlock>
  log.start = sb->logstart;
    80004e3e:	0149a583          	lw	a1,20(s3)
    80004e42:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004e44:	0109a783          	lw	a5,16(s3)
    80004e48:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004e4a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004e4e:	854a                	mv	a0,s2
    80004e50:	fffff097          	auipc	ra,0xfffff
    80004e54:	e8a080e7          	jalr	-374(ra) # 80003cda <bread>
  log.lh.n = lh->n;
    80004e58:	4d34                	lw	a3,88(a0)
    80004e5a:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004e5c:	02d05663          	blez	a3,80004e88 <initlog+0x76>
    80004e60:	05c50793          	addi	a5,a0,92
    80004e64:	0005e717          	auipc	a4,0x5e
    80004e68:	8c470713          	addi	a4,a4,-1852 # 80062728 <log+0x30>
    80004e6c:	36fd                	addiw	a3,a3,-1
    80004e6e:	02069613          	slli	a2,a3,0x20
    80004e72:	01e65693          	srli	a3,a2,0x1e
    80004e76:	06050613          	addi	a2,a0,96
    80004e7a:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004e7c:	4390                	lw	a2,0(a5)
    80004e7e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004e80:	0791                	addi	a5,a5,4
    80004e82:	0711                	addi	a4,a4,4
    80004e84:	fed79ce3          	bne	a5,a3,80004e7c <initlog+0x6a>
  brelse(buf);
    80004e88:	fffff097          	auipc	ra,0xfffff
    80004e8c:	f82080e7          	jalr	-126(ra) # 80003e0a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004e90:	4505                	li	a0,1
    80004e92:	00000097          	auipc	ra,0x0
    80004e96:	ebc080e7          	jalr	-324(ra) # 80004d4e <install_trans>
  log.lh.n = 0;
    80004e9a:	0005e797          	auipc	a5,0x5e
    80004e9e:	8807a523          	sw	zero,-1910(a5) # 80062724 <log+0x2c>
  write_head(); // clear the log
    80004ea2:	00000097          	auipc	ra,0x0
    80004ea6:	e30080e7          	jalr	-464(ra) # 80004cd2 <write_head>
}
    80004eaa:	70a2                	ld	ra,40(sp)
    80004eac:	7402                	ld	s0,32(sp)
    80004eae:	64e2                	ld	s1,24(sp)
    80004eb0:	6942                	ld	s2,16(sp)
    80004eb2:	69a2                	ld	s3,8(sp)
    80004eb4:	6145                	addi	sp,sp,48
    80004eb6:	8082                	ret

0000000080004eb8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004eb8:	1101                	addi	sp,sp,-32
    80004eba:	ec06                	sd	ra,24(sp)
    80004ebc:	e822                	sd	s0,16(sp)
    80004ebe:	e426                	sd	s1,8(sp)
    80004ec0:	e04a                	sd	s2,0(sp)
    80004ec2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004ec4:	0005e517          	auipc	a0,0x5e
    80004ec8:	83450513          	addi	a0,a0,-1996 # 800626f8 <log>
    80004ecc:	ffffc097          	auipc	ra,0xffffc
    80004ed0:	cfe080e7          	jalr	-770(ra) # 80000bca <acquire>
  while(1){
    if(log.committing){
    80004ed4:	0005e497          	auipc	s1,0x5e
    80004ed8:	82448493          	addi	s1,s1,-2012 # 800626f8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004edc:	4979                	li	s2,30
    80004ede:	a039                	j	80004eec <begin_op+0x34>
      sleep(&log, &log.lock);
    80004ee0:	85a6                	mv	a1,s1
    80004ee2:	8526                	mv	a0,s1
    80004ee4:	ffffd097          	auipc	ra,0xffffd
    80004ee8:	49a080e7          	jalr	1178(ra) # 8000237e <sleep>
    if(log.committing){
    80004eec:	50dc                	lw	a5,36(s1)
    80004eee:	fbed                	bnez	a5,80004ee0 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004ef0:	509c                	lw	a5,32(s1)
    80004ef2:	0017871b          	addiw	a4,a5,1
    80004ef6:	0007069b          	sext.w	a3,a4
    80004efa:	0027179b          	slliw	a5,a4,0x2
    80004efe:	9fb9                	addw	a5,a5,a4
    80004f00:	0017979b          	slliw	a5,a5,0x1
    80004f04:	54d8                	lw	a4,44(s1)
    80004f06:	9fb9                	addw	a5,a5,a4
    80004f08:	00f95963          	bge	s2,a5,80004f1a <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004f0c:	85a6                	mv	a1,s1
    80004f0e:	8526                	mv	a0,s1
    80004f10:	ffffd097          	auipc	ra,0xffffd
    80004f14:	46e080e7          	jalr	1134(ra) # 8000237e <sleep>
    80004f18:	bfd1                	j	80004eec <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004f1a:	0005d517          	auipc	a0,0x5d
    80004f1e:	7de50513          	addi	a0,a0,2014 # 800626f8 <log>
    80004f22:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004f24:	ffffc097          	auipc	ra,0xffffc
    80004f28:	d60080e7          	jalr	-672(ra) # 80000c84 <release>
      break;
    }
  }
}
    80004f2c:	60e2                	ld	ra,24(sp)
    80004f2e:	6442                	ld	s0,16(sp)
    80004f30:	64a2                	ld	s1,8(sp)
    80004f32:	6902                	ld	s2,0(sp)
    80004f34:	6105                	addi	sp,sp,32
    80004f36:	8082                	ret

0000000080004f38 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004f38:	7139                	addi	sp,sp,-64
    80004f3a:	fc06                	sd	ra,56(sp)
    80004f3c:	f822                	sd	s0,48(sp)
    80004f3e:	f426                	sd	s1,40(sp)
    80004f40:	f04a                	sd	s2,32(sp)
    80004f42:	ec4e                	sd	s3,24(sp)
    80004f44:	e852                	sd	s4,16(sp)
    80004f46:	e456                	sd	s5,8(sp)
    80004f48:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004f4a:	0005d497          	auipc	s1,0x5d
    80004f4e:	7ae48493          	addi	s1,s1,1966 # 800626f8 <log>
    80004f52:	8526                	mv	a0,s1
    80004f54:	ffffc097          	auipc	ra,0xffffc
    80004f58:	c76080e7          	jalr	-906(ra) # 80000bca <acquire>
  log.outstanding -= 1;
    80004f5c:	509c                	lw	a5,32(s1)
    80004f5e:	37fd                	addiw	a5,a5,-1
    80004f60:	0007891b          	sext.w	s2,a5
    80004f64:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004f66:	50dc                	lw	a5,36(s1)
    80004f68:	e7b9                	bnez	a5,80004fb6 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004f6a:	04091e63          	bnez	s2,80004fc6 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004f6e:	0005d497          	auipc	s1,0x5d
    80004f72:	78a48493          	addi	s1,s1,1930 # 800626f8 <log>
    80004f76:	4785                	li	a5,1
    80004f78:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004f7a:	8526                	mv	a0,s1
    80004f7c:	ffffc097          	auipc	ra,0xffffc
    80004f80:	d08080e7          	jalr	-760(ra) # 80000c84 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004f84:	54dc                	lw	a5,44(s1)
    80004f86:	06f04763          	bgtz	a5,80004ff4 <end_op+0xbc>
    acquire(&log.lock);
    80004f8a:	0005d497          	auipc	s1,0x5d
    80004f8e:	76e48493          	addi	s1,s1,1902 # 800626f8 <log>
    80004f92:	8526                	mv	a0,s1
    80004f94:	ffffc097          	auipc	ra,0xffffc
    80004f98:	c36080e7          	jalr	-970(ra) # 80000bca <acquire>
    log.committing = 0;
    80004f9c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004fa0:	8526                	mv	a0,s1
    80004fa2:	ffffd097          	auipc	ra,0xffffd
    80004fa6:	586080e7          	jalr	1414(ra) # 80002528 <wakeup>
    release(&log.lock);
    80004faa:	8526                	mv	a0,s1
    80004fac:	ffffc097          	auipc	ra,0xffffc
    80004fb0:	cd8080e7          	jalr	-808(ra) # 80000c84 <release>
}
    80004fb4:	a03d                	j	80004fe2 <end_op+0xaa>
    panic("log.committing");
    80004fb6:	00004517          	auipc	a0,0x4
    80004fba:	7aa50513          	addi	a0,a0,1962 # 80009760 <syscalls+0x260>
    80004fbe:	ffffb097          	auipc	ra,0xffffb
    80004fc2:	56c080e7          	jalr	1388(ra) # 8000052a <panic>
    wakeup(&log);
    80004fc6:	0005d497          	auipc	s1,0x5d
    80004fca:	73248493          	addi	s1,s1,1842 # 800626f8 <log>
    80004fce:	8526                	mv	a0,s1
    80004fd0:	ffffd097          	auipc	ra,0xffffd
    80004fd4:	558080e7          	jalr	1368(ra) # 80002528 <wakeup>
  release(&log.lock);
    80004fd8:	8526                	mv	a0,s1
    80004fda:	ffffc097          	auipc	ra,0xffffc
    80004fde:	caa080e7          	jalr	-854(ra) # 80000c84 <release>
}
    80004fe2:	70e2                	ld	ra,56(sp)
    80004fe4:	7442                	ld	s0,48(sp)
    80004fe6:	74a2                	ld	s1,40(sp)
    80004fe8:	7902                	ld	s2,32(sp)
    80004fea:	69e2                	ld	s3,24(sp)
    80004fec:	6a42                	ld	s4,16(sp)
    80004fee:	6aa2                	ld	s5,8(sp)
    80004ff0:	6121                	addi	sp,sp,64
    80004ff2:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004ff4:	0005da97          	auipc	s5,0x5d
    80004ff8:	734a8a93          	addi	s5,s5,1844 # 80062728 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004ffc:	0005da17          	auipc	s4,0x5d
    80005000:	6fca0a13          	addi	s4,s4,1788 # 800626f8 <log>
    80005004:	018a2583          	lw	a1,24(s4)
    80005008:	012585bb          	addw	a1,a1,s2
    8000500c:	2585                	addiw	a1,a1,1
    8000500e:	028a2503          	lw	a0,40(s4)
    80005012:	fffff097          	auipc	ra,0xfffff
    80005016:	cc8080e7          	jalr	-824(ra) # 80003cda <bread>
    8000501a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000501c:	000aa583          	lw	a1,0(s5)
    80005020:	028a2503          	lw	a0,40(s4)
    80005024:	fffff097          	auipc	ra,0xfffff
    80005028:	cb6080e7          	jalr	-842(ra) # 80003cda <bread>
    8000502c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000502e:	40000613          	li	a2,1024
    80005032:	05850593          	addi	a1,a0,88
    80005036:	05848513          	addi	a0,s1,88
    8000503a:	ffffc097          	auipc	ra,0xffffc
    8000503e:	cee080e7          	jalr	-786(ra) # 80000d28 <memmove>
    bwrite(to);  // write the log
    80005042:	8526                	mv	a0,s1
    80005044:	fffff097          	auipc	ra,0xfffff
    80005048:	d88080e7          	jalr	-632(ra) # 80003dcc <bwrite>
    brelse(from);
    8000504c:	854e                	mv	a0,s3
    8000504e:	fffff097          	auipc	ra,0xfffff
    80005052:	dbc080e7          	jalr	-580(ra) # 80003e0a <brelse>
    brelse(to);
    80005056:	8526                	mv	a0,s1
    80005058:	fffff097          	auipc	ra,0xfffff
    8000505c:	db2080e7          	jalr	-590(ra) # 80003e0a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005060:	2905                	addiw	s2,s2,1
    80005062:	0a91                	addi	s5,s5,4
    80005064:	02ca2783          	lw	a5,44(s4)
    80005068:	f8f94ee3          	blt	s2,a5,80005004 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000506c:	00000097          	auipc	ra,0x0
    80005070:	c66080e7          	jalr	-922(ra) # 80004cd2 <write_head>
    install_trans(0); // Now install writes to home locations
    80005074:	4501                	li	a0,0
    80005076:	00000097          	auipc	ra,0x0
    8000507a:	cd8080e7          	jalr	-808(ra) # 80004d4e <install_trans>
    log.lh.n = 0;
    8000507e:	0005d797          	auipc	a5,0x5d
    80005082:	6a07a323          	sw	zero,1702(a5) # 80062724 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80005086:	00000097          	auipc	ra,0x0
    8000508a:	c4c080e7          	jalr	-948(ra) # 80004cd2 <write_head>
    8000508e:	bdf5                	j	80004f8a <end_op+0x52>

0000000080005090 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80005090:	1101                	addi	sp,sp,-32
    80005092:	ec06                	sd	ra,24(sp)
    80005094:	e822                	sd	s0,16(sp)
    80005096:	e426                	sd	s1,8(sp)
    80005098:	e04a                	sd	s2,0(sp)
    8000509a:	1000                	addi	s0,sp,32
    8000509c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000509e:	0005d917          	auipc	s2,0x5d
    800050a2:	65a90913          	addi	s2,s2,1626 # 800626f8 <log>
    800050a6:	854a                	mv	a0,s2
    800050a8:	ffffc097          	auipc	ra,0xffffc
    800050ac:	b22080e7          	jalr	-1246(ra) # 80000bca <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800050b0:	02c92603          	lw	a2,44(s2)
    800050b4:	47f5                	li	a5,29
    800050b6:	06c7c563          	blt	a5,a2,80005120 <log_write+0x90>
    800050ba:	0005d797          	auipc	a5,0x5d
    800050be:	65a7a783          	lw	a5,1626(a5) # 80062714 <log+0x1c>
    800050c2:	37fd                	addiw	a5,a5,-1
    800050c4:	04f65e63          	bge	a2,a5,80005120 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800050c8:	0005d797          	auipc	a5,0x5d
    800050cc:	6507a783          	lw	a5,1616(a5) # 80062718 <log+0x20>
    800050d0:	06f05063          	blez	a5,80005130 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800050d4:	4781                	li	a5,0
    800050d6:	06c05563          	blez	a2,80005140 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800050da:	44cc                	lw	a1,12(s1)
    800050dc:	0005d717          	auipc	a4,0x5d
    800050e0:	64c70713          	addi	a4,a4,1612 # 80062728 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800050e4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800050e6:	4314                	lw	a3,0(a4)
    800050e8:	04b68c63          	beq	a3,a1,80005140 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800050ec:	2785                	addiw	a5,a5,1
    800050ee:	0711                	addi	a4,a4,4
    800050f0:	fef61be3          	bne	a2,a5,800050e6 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800050f4:	0621                	addi	a2,a2,8
    800050f6:	060a                	slli	a2,a2,0x2
    800050f8:	0005d797          	auipc	a5,0x5d
    800050fc:	60078793          	addi	a5,a5,1536 # 800626f8 <log>
    80005100:	963e                	add	a2,a2,a5
    80005102:	44dc                	lw	a5,12(s1)
    80005104:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80005106:	8526                	mv	a0,s1
    80005108:	fffff097          	auipc	ra,0xfffff
    8000510c:	da0080e7          	jalr	-608(ra) # 80003ea8 <bpin>
    log.lh.n++;
    80005110:	0005d717          	auipc	a4,0x5d
    80005114:	5e870713          	addi	a4,a4,1512 # 800626f8 <log>
    80005118:	575c                	lw	a5,44(a4)
    8000511a:	2785                	addiw	a5,a5,1
    8000511c:	d75c                	sw	a5,44(a4)
    8000511e:	a835                	j	8000515a <log_write+0xca>
    panic("too big a transaction");
    80005120:	00004517          	auipc	a0,0x4
    80005124:	65050513          	addi	a0,a0,1616 # 80009770 <syscalls+0x270>
    80005128:	ffffb097          	auipc	ra,0xffffb
    8000512c:	402080e7          	jalr	1026(ra) # 8000052a <panic>
    panic("log_write outside of trans");
    80005130:	00004517          	auipc	a0,0x4
    80005134:	65850513          	addi	a0,a0,1624 # 80009788 <syscalls+0x288>
    80005138:	ffffb097          	auipc	ra,0xffffb
    8000513c:	3f2080e7          	jalr	1010(ra) # 8000052a <panic>
  log.lh.block[i] = b->blockno;
    80005140:	00878713          	addi	a4,a5,8
    80005144:	00271693          	slli	a3,a4,0x2
    80005148:	0005d717          	auipc	a4,0x5d
    8000514c:	5b070713          	addi	a4,a4,1456 # 800626f8 <log>
    80005150:	9736                	add	a4,a4,a3
    80005152:	44d4                	lw	a3,12(s1)
    80005154:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80005156:	faf608e3          	beq	a2,a5,80005106 <log_write+0x76>
  }
  release(&log.lock);
    8000515a:	0005d517          	auipc	a0,0x5d
    8000515e:	59e50513          	addi	a0,a0,1438 # 800626f8 <log>
    80005162:	ffffc097          	auipc	ra,0xffffc
    80005166:	b22080e7          	jalr	-1246(ra) # 80000c84 <release>
}
    8000516a:	60e2                	ld	ra,24(sp)
    8000516c:	6442                	ld	s0,16(sp)
    8000516e:	64a2                	ld	s1,8(sp)
    80005170:	6902                	ld	s2,0(sp)
    80005172:	6105                	addi	sp,sp,32
    80005174:	8082                	ret

0000000080005176 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80005176:	1101                	addi	sp,sp,-32
    80005178:	ec06                	sd	ra,24(sp)
    8000517a:	e822                	sd	s0,16(sp)
    8000517c:	e426                	sd	s1,8(sp)
    8000517e:	e04a                	sd	s2,0(sp)
    80005180:	1000                	addi	s0,sp,32
    80005182:	84aa                	mv	s1,a0
    80005184:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80005186:	00004597          	auipc	a1,0x4
    8000518a:	62258593          	addi	a1,a1,1570 # 800097a8 <syscalls+0x2a8>
    8000518e:	0521                	addi	a0,a0,8
    80005190:	ffffc097          	auipc	ra,0xffffc
    80005194:	9a2080e7          	jalr	-1630(ra) # 80000b32 <initlock>
  lk->name = name;
    80005198:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000519c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800051a0:	0204a423          	sw	zero,40(s1)
}
    800051a4:	60e2                	ld	ra,24(sp)
    800051a6:	6442                	ld	s0,16(sp)
    800051a8:	64a2                	ld	s1,8(sp)
    800051aa:	6902                	ld	s2,0(sp)
    800051ac:	6105                	addi	sp,sp,32
    800051ae:	8082                	ret

00000000800051b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800051b0:	1101                	addi	sp,sp,-32
    800051b2:	ec06                	sd	ra,24(sp)
    800051b4:	e822                	sd	s0,16(sp)
    800051b6:	e426                	sd	s1,8(sp)
    800051b8:	e04a                	sd	s2,0(sp)
    800051ba:	1000                	addi	s0,sp,32
    800051bc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800051be:	00850913          	addi	s2,a0,8
    800051c2:	854a                	mv	a0,s2
    800051c4:	ffffc097          	auipc	ra,0xffffc
    800051c8:	a06080e7          	jalr	-1530(ra) # 80000bca <acquire>
  while (lk->locked) {
    800051cc:	409c                	lw	a5,0(s1)
    800051ce:	cb89                	beqz	a5,800051e0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800051d0:	85ca                	mv	a1,s2
    800051d2:	8526                	mv	a0,s1
    800051d4:	ffffd097          	auipc	ra,0xffffd
    800051d8:	1aa080e7          	jalr	426(ra) # 8000237e <sleep>
  while (lk->locked) {
    800051dc:	409c                	lw	a5,0(s1)
    800051de:	fbed                	bnez	a5,800051d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800051e0:	4785                	li	a5,1
    800051e2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800051e4:	ffffd097          	auipc	ra,0xffffd
    800051e8:	814080e7          	jalr	-2028(ra) # 800019f8 <myproc>
    800051ec:	515c                	lw	a5,36(a0)
    800051ee:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800051f0:	854a                	mv	a0,s2
    800051f2:	ffffc097          	auipc	ra,0xffffc
    800051f6:	a92080e7          	jalr	-1390(ra) # 80000c84 <release>
}
    800051fa:	60e2                	ld	ra,24(sp)
    800051fc:	6442                	ld	s0,16(sp)
    800051fe:	64a2                	ld	s1,8(sp)
    80005200:	6902                	ld	s2,0(sp)
    80005202:	6105                	addi	sp,sp,32
    80005204:	8082                	ret

0000000080005206 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80005206:	1101                	addi	sp,sp,-32
    80005208:	ec06                	sd	ra,24(sp)
    8000520a:	e822                	sd	s0,16(sp)
    8000520c:	e426                	sd	s1,8(sp)
    8000520e:	e04a                	sd	s2,0(sp)
    80005210:	1000                	addi	s0,sp,32
    80005212:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80005214:	00850913          	addi	s2,a0,8
    80005218:	854a                	mv	a0,s2
    8000521a:	ffffc097          	auipc	ra,0xffffc
    8000521e:	9b0080e7          	jalr	-1616(ra) # 80000bca <acquire>
  lk->locked = 0;
    80005222:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005226:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000522a:	8526                	mv	a0,s1
    8000522c:	ffffd097          	auipc	ra,0xffffd
    80005230:	2fc080e7          	jalr	764(ra) # 80002528 <wakeup>
  release(&lk->lk);
    80005234:	854a                	mv	a0,s2
    80005236:	ffffc097          	auipc	ra,0xffffc
    8000523a:	a4e080e7          	jalr	-1458(ra) # 80000c84 <release>
}
    8000523e:	60e2                	ld	ra,24(sp)
    80005240:	6442                	ld	s0,16(sp)
    80005242:	64a2                	ld	s1,8(sp)
    80005244:	6902                	ld	s2,0(sp)
    80005246:	6105                	addi	sp,sp,32
    80005248:	8082                	ret

000000008000524a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000524a:	7179                	addi	sp,sp,-48
    8000524c:	f406                	sd	ra,40(sp)
    8000524e:	f022                	sd	s0,32(sp)
    80005250:	ec26                	sd	s1,24(sp)
    80005252:	e84a                	sd	s2,16(sp)
    80005254:	e44e                	sd	s3,8(sp)
    80005256:	1800                	addi	s0,sp,48
    80005258:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000525a:	00850913          	addi	s2,a0,8
    8000525e:	854a                	mv	a0,s2
    80005260:	ffffc097          	auipc	ra,0xffffc
    80005264:	96a080e7          	jalr	-1686(ra) # 80000bca <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80005268:	409c                	lw	a5,0(s1)
    8000526a:	ef99                	bnez	a5,80005288 <holdingsleep+0x3e>
    8000526c:	4481                	li	s1,0
  release(&lk->lk);
    8000526e:	854a                	mv	a0,s2
    80005270:	ffffc097          	auipc	ra,0xffffc
    80005274:	a14080e7          	jalr	-1516(ra) # 80000c84 <release>
  return r;
}
    80005278:	8526                	mv	a0,s1
    8000527a:	70a2                	ld	ra,40(sp)
    8000527c:	7402                	ld	s0,32(sp)
    8000527e:	64e2                	ld	s1,24(sp)
    80005280:	6942                	ld	s2,16(sp)
    80005282:	69a2                	ld	s3,8(sp)
    80005284:	6145                	addi	sp,sp,48
    80005286:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80005288:	0284a983          	lw	s3,40(s1)
    8000528c:	ffffc097          	auipc	ra,0xffffc
    80005290:	76c080e7          	jalr	1900(ra) # 800019f8 <myproc>
    80005294:	5144                	lw	s1,36(a0)
    80005296:	413484b3          	sub	s1,s1,s3
    8000529a:	0014b493          	seqz	s1,s1
    8000529e:	bfc1                	j	8000526e <holdingsleep+0x24>

00000000800052a0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800052a0:	1141                	addi	sp,sp,-16
    800052a2:	e406                	sd	ra,8(sp)
    800052a4:	e022                	sd	s0,0(sp)
    800052a6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800052a8:	00004597          	auipc	a1,0x4
    800052ac:	51058593          	addi	a1,a1,1296 # 800097b8 <syscalls+0x2b8>
    800052b0:	0005d517          	auipc	a0,0x5d
    800052b4:	59050513          	addi	a0,a0,1424 # 80062840 <ftable>
    800052b8:	ffffc097          	auipc	ra,0xffffc
    800052bc:	87a080e7          	jalr	-1926(ra) # 80000b32 <initlock>
}
    800052c0:	60a2                	ld	ra,8(sp)
    800052c2:	6402                	ld	s0,0(sp)
    800052c4:	0141                	addi	sp,sp,16
    800052c6:	8082                	ret

00000000800052c8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800052c8:	1101                	addi	sp,sp,-32
    800052ca:	ec06                	sd	ra,24(sp)
    800052cc:	e822                	sd	s0,16(sp)
    800052ce:	e426                	sd	s1,8(sp)
    800052d0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800052d2:	0005d517          	auipc	a0,0x5d
    800052d6:	56e50513          	addi	a0,a0,1390 # 80062840 <ftable>
    800052da:	ffffc097          	auipc	ra,0xffffc
    800052de:	8f0080e7          	jalr	-1808(ra) # 80000bca <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800052e2:	0005d497          	auipc	s1,0x5d
    800052e6:	57648493          	addi	s1,s1,1398 # 80062858 <ftable+0x18>
    800052ea:	0005e717          	auipc	a4,0x5e
    800052ee:	50e70713          	addi	a4,a4,1294 # 800637f8 <ftable+0xfb8>
    if(f->ref == 0){
    800052f2:	40dc                	lw	a5,4(s1)
    800052f4:	cf99                	beqz	a5,80005312 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800052f6:	02848493          	addi	s1,s1,40
    800052fa:	fee49ce3          	bne	s1,a4,800052f2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800052fe:	0005d517          	auipc	a0,0x5d
    80005302:	54250513          	addi	a0,a0,1346 # 80062840 <ftable>
    80005306:	ffffc097          	auipc	ra,0xffffc
    8000530a:	97e080e7          	jalr	-1666(ra) # 80000c84 <release>
  return 0;
    8000530e:	4481                	li	s1,0
    80005310:	a819                	j	80005326 <filealloc+0x5e>
      f->ref = 1;
    80005312:	4785                	li	a5,1
    80005314:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80005316:	0005d517          	auipc	a0,0x5d
    8000531a:	52a50513          	addi	a0,a0,1322 # 80062840 <ftable>
    8000531e:	ffffc097          	auipc	ra,0xffffc
    80005322:	966080e7          	jalr	-1690(ra) # 80000c84 <release>
}
    80005326:	8526                	mv	a0,s1
    80005328:	60e2                	ld	ra,24(sp)
    8000532a:	6442                	ld	s0,16(sp)
    8000532c:	64a2                	ld	s1,8(sp)
    8000532e:	6105                	addi	sp,sp,32
    80005330:	8082                	ret

0000000080005332 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80005332:	1101                	addi	sp,sp,-32
    80005334:	ec06                	sd	ra,24(sp)
    80005336:	e822                	sd	s0,16(sp)
    80005338:	e426                	sd	s1,8(sp)
    8000533a:	1000                	addi	s0,sp,32
    8000533c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000533e:	0005d517          	auipc	a0,0x5d
    80005342:	50250513          	addi	a0,a0,1282 # 80062840 <ftable>
    80005346:	ffffc097          	auipc	ra,0xffffc
    8000534a:	884080e7          	jalr	-1916(ra) # 80000bca <acquire>
  if(f->ref < 1)
    8000534e:	40dc                	lw	a5,4(s1)
    80005350:	02f05263          	blez	a5,80005374 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80005354:	2785                	addiw	a5,a5,1
    80005356:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80005358:	0005d517          	auipc	a0,0x5d
    8000535c:	4e850513          	addi	a0,a0,1256 # 80062840 <ftable>
    80005360:	ffffc097          	auipc	ra,0xffffc
    80005364:	924080e7          	jalr	-1756(ra) # 80000c84 <release>
  return f;
}
    80005368:	8526                	mv	a0,s1
    8000536a:	60e2                	ld	ra,24(sp)
    8000536c:	6442                	ld	s0,16(sp)
    8000536e:	64a2                	ld	s1,8(sp)
    80005370:	6105                	addi	sp,sp,32
    80005372:	8082                	ret
    panic("filedup");
    80005374:	00004517          	auipc	a0,0x4
    80005378:	44c50513          	addi	a0,a0,1100 # 800097c0 <syscalls+0x2c0>
    8000537c:	ffffb097          	auipc	ra,0xffffb
    80005380:	1ae080e7          	jalr	430(ra) # 8000052a <panic>

0000000080005384 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80005384:	7139                	addi	sp,sp,-64
    80005386:	fc06                	sd	ra,56(sp)
    80005388:	f822                	sd	s0,48(sp)
    8000538a:	f426                	sd	s1,40(sp)
    8000538c:	f04a                	sd	s2,32(sp)
    8000538e:	ec4e                	sd	s3,24(sp)
    80005390:	e852                	sd	s4,16(sp)
    80005392:	e456                	sd	s5,8(sp)
    80005394:	0080                	addi	s0,sp,64
    80005396:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80005398:	0005d517          	auipc	a0,0x5d
    8000539c:	4a850513          	addi	a0,a0,1192 # 80062840 <ftable>
    800053a0:	ffffc097          	auipc	ra,0xffffc
    800053a4:	82a080e7          	jalr	-2006(ra) # 80000bca <acquire>
  if(f->ref < 1)
    800053a8:	40dc                	lw	a5,4(s1)
    800053aa:	06f05163          	blez	a5,8000540c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800053ae:	37fd                	addiw	a5,a5,-1
    800053b0:	0007871b          	sext.w	a4,a5
    800053b4:	c0dc                	sw	a5,4(s1)
    800053b6:	06e04363          	bgtz	a4,8000541c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800053ba:	0004a903          	lw	s2,0(s1)
    800053be:	0094ca83          	lbu	s5,9(s1)
    800053c2:	0104ba03          	ld	s4,16(s1)
    800053c6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800053ca:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800053ce:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800053d2:	0005d517          	auipc	a0,0x5d
    800053d6:	46e50513          	addi	a0,a0,1134 # 80062840 <ftable>
    800053da:	ffffc097          	auipc	ra,0xffffc
    800053de:	8aa080e7          	jalr	-1878(ra) # 80000c84 <release>

  if(ff.type == FD_PIPE){
    800053e2:	4785                	li	a5,1
    800053e4:	04f90d63          	beq	s2,a5,8000543e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800053e8:	3979                	addiw	s2,s2,-2
    800053ea:	4785                	li	a5,1
    800053ec:	0527e063          	bltu	a5,s2,8000542c <fileclose+0xa8>
    begin_op();
    800053f0:	00000097          	auipc	ra,0x0
    800053f4:	ac8080e7          	jalr	-1336(ra) # 80004eb8 <begin_op>
    iput(ff.ip);
    800053f8:	854e                	mv	a0,s3
    800053fa:	fffff097          	auipc	ra,0xfffff
    800053fe:	29e080e7          	jalr	670(ra) # 80004698 <iput>
    end_op();
    80005402:	00000097          	auipc	ra,0x0
    80005406:	b36080e7          	jalr	-1226(ra) # 80004f38 <end_op>
    8000540a:	a00d                	j	8000542c <fileclose+0xa8>
    panic("fileclose");
    8000540c:	00004517          	auipc	a0,0x4
    80005410:	3bc50513          	addi	a0,a0,956 # 800097c8 <syscalls+0x2c8>
    80005414:	ffffb097          	auipc	ra,0xffffb
    80005418:	116080e7          	jalr	278(ra) # 8000052a <panic>
    release(&ftable.lock);
    8000541c:	0005d517          	auipc	a0,0x5d
    80005420:	42450513          	addi	a0,a0,1060 # 80062840 <ftable>
    80005424:	ffffc097          	auipc	ra,0xffffc
    80005428:	860080e7          	jalr	-1952(ra) # 80000c84 <release>
  }
}
    8000542c:	70e2                	ld	ra,56(sp)
    8000542e:	7442                	ld	s0,48(sp)
    80005430:	74a2                	ld	s1,40(sp)
    80005432:	7902                	ld	s2,32(sp)
    80005434:	69e2                	ld	s3,24(sp)
    80005436:	6a42                	ld	s4,16(sp)
    80005438:	6aa2                	ld	s5,8(sp)
    8000543a:	6121                	addi	sp,sp,64
    8000543c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000543e:	85d6                	mv	a1,s5
    80005440:	8552                	mv	a0,s4
    80005442:	00000097          	auipc	ra,0x0
    80005446:	350080e7          	jalr	848(ra) # 80005792 <pipeclose>
    8000544a:	b7cd                	j	8000542c <fileclose+0xa8>

000000008000544c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000544c:	715d                	addi	sp,sp,-80
    8000544e:	e486                	sd	ra,72(sp)
    80005450:	e0a2                	sd	s0,64(sp)
    80005452:	fc26                	sd	s1,56(sp)
    80005454:	f84a                	sd	s2,48(sp)
    80005456:	f44e                	sd	s3,40(sp)
    80005458:	0880                	addi	s0,sp,80
    8000545a:	84aa                	mv	s1,a0
    8000545c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000545e:	ffffc097          	auipc	ra,0xffffc
    80005462:	59a080e7          	jalr	1434(ra) # 800019f8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80005466:	409c                	lw	a5,0(s1)
    80005468:	37f9                	addiw	a5,a5,-2
    8000546a:	4705                	li	a4,1
    8000546c:	04f76963          	bltu	a4,a5,800054be <filestat+0x72>
    80005470:	892a                	mv	s2,a0
    ilock(f->ip);
    80005472:	6c88                	ld	a0,24(s1)
    80005474:	fffff097          	auipc	ra,0xfffff
    80005478:	06a080e7          	jalr	106(ra) # 800044de <ilock>
    stati(f->ip, &st);
    8000547c:	fb840593          	addi	a1,s0,-72
    80005480:	6c88                	ld	a0,24(s1)
    80005482:	fffff097          	auipc	ra,0xfffff
    80005486:	2e6080e7          	jalr	742(ra) # 80004768 <stati>
    iunlock(f->ip);
    8000548a:	6c88                	ld	a0,24(s1)
    8000548c:	fffff097          	auipc	ra,0xfffff
    80005490:	114080e7          	jalr	276(ra) # 800045a0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80005494:	6505                	lui	a0,0x1
    80005496:	954a                	add	a0,a0,s2
    80005498:	46e1                	li	a3,24
    8000549a:	fb840613          	addi	a2,s0,-72
    8000549e:	85ce                	mv	a1,s3
    800054a0:	f4053503          	ld	a0,-192(a0) # f40 <_entry-0x7ffff0c0>
    800054a4:	ffffc097          	auipc	ra,0xffffc
    800054a8:	1a8080e7          	jalr	424(ra) # 8000164c <copyout>
    800054ac:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800054b0:	60a6                	ld	ra,72(sp)
    800054b2:	6406                	ld	s0,64(sp)
    800054b4:	74e2                	ld	s1,56(sp)
    800054b6:	7942                	ld	s2,48(sp)
    800054b8:	79a2                	ld	s3,40(sp)
    800054ba:	6161                	addi	sp,sp,80
    800054bc:	8082                	ret
  return -1;
    800054be:	557d                	li	a0,-1
    800054c0:	bfc5                	j	800054b0 <filestat+0x64>

00000000800054c2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800054c2:	7179                	addi	sp,sp,-48
    800054c4:	f406                	sd	ra,40(sp)
    800054c6:	f022                	sd	s0,32(sp)
    800054c8:	ec26                	sd	s1,24(sp)
    800054ca:	e84a                	sd	s2,16(sp)
    800054cc:	e44e                	sd	s3,8(sp)
    800054ce:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800054d0:	00854783          	lbu	a5,8(a0)
    800054d4:	c3d5                	beqz	a5,80005578 <fileread+0xb6>
    800054d6:	84aa                	mv	s1,a0
    800054d8:	89ae                	mv	s3,a1
    800054da:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800054dc:	411c                	lw	a5,0(a0)
    800054de:	4705                	li	a4,1
    800054e0:	04e78963          	beq	a5,a4,80005532 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800054e4:	470d                	li	a4,3
    800054e6:	04e78d63          	beq	a5,a4,80005540 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800054ea:	4709                	li	a4,2
    800054ec:	06e79e63          	bne	a5,a4,80005568 <fileread+0xa6>
    ilock(f->ip);
    800054f0:	6d08                	ld	a0,24(a0)
    800054f2:	fffff097          	auipc	ra,0xfffff
    800054f6:	fec080e7          	jalr	-20(ra) # 800044de <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800054fa:	874a                	mv	a4,s2
    800054fc:	5094                	lw	a3,32(s1)
    800054fe:	864e                	mv	a2,s3
    80005500:	4585                	li	a1,1
    80005502:	6c88                	ld	a0,24(s1)
    80005504:	fffff097          	auipc	ra,0xfffff
    80005508:	28e080e7          	jalr	654(ra) # 80004792 <readi>
    8000550c:	892a                	mv	s2,a0
    8000550e:	00a05563          	blez	a0,80005518 <fileread+0x56>
      f->off += r;
    80005512:	509c                	lw	a5,32(s1)
    80005514:	9fa9                	addw	a5,a5,a0
    80005516:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80005518:	6c88                	ld	a0,24(s1)
    8000551a:	fffff097          	auipc	ra,0xfffff
    8000551e:	086080e7          	jalr	134(ra) # 800045a0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80005522:	854a                	mv	a0,s2
    80005524:	70a2                	ld	ra,40(sp)
    80005526:	7402                	ld	s0,32(sp)
    80005528:	64e2                	ld	s1,24(sp)
    8000552a:	6942                	ld	s2,16(sp)
    8000552c:	69a2                	ld	s3,8(sp)
    8000552e:	6145                	addi	sp,sp,48
    80005530:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80005532:	6908                	ld	a0,16(a0)
    80005534:	00000097          	auipc	ra,0x0
    80005538:	3c8080e7          	jalr	968(ra) # 800058fc <piperead>
    8000553c:	892a                	mv	s2,a0
    8000553e:	b7d5                	j	80005522 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80005540:	02451783          	lh	a5,36(a0)
    80005544:	03079693          	slli	a3,a5,0x30
    80005548:	92c1                	srli	a3,a3,0x30
    8000554a:	4725                	li	a4,9
    8000554c:	02d76863          	bltu	a4,a3,8000557c <fileread+0xba>
    80005550:	0792                	slli	a5,a5,0x4
    80005552:	0005d717          	auipc	a4,0x5d
    80005556:	24e70713          	addi	a4,a4,590 # 800627a0 <devsw>
    8000555a:	97ba                	add	a5,a5,a4
    8000555c:	639c                	ld	a5,0(a5)
    8000555e:	c38d                	beqz	a5,80005580 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80005560:	4505                	li	a0,1
    80005562:	9782                	jalr	a5
    80005564:	892a                	mv	s2,a0
    80005566:	bf75                	j	80005522 <fileread+0x60>
    panic("fileread");
    80005568:	00004517          	auipc	a0,0x4
    8000556c:	27050513          	addi	a0,a0,624 # 800097d8 <syscalls+0x2d8>
    80005570:	ffffb097          	auipc	ra,0xffffb
    80005574:	fba080e7          	jalr	-70(ra) # 8000052a <panic>
    return -1;
    80005578:	597d                	li	s2,-1
    8000557a:	b765                	j	80005522 <fileread+0x60>
      return -1;
    8000557c:	597d                	li	s2,-1
    8000557e:	b755                	j	80005522 <fileread+0x60>
    80005580:	597d                	li	s2,-1
    80005582:	b745                	j	80005522 <fileread+0x60>

0000000080005584 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80005584:	715d                	addi	sp,sp,-80
    80005586:	e486                	sd	ra,72(sp)
    80005588:	e0a2                	sd	s0,64(sp)
    8000558a:	fc26                	sd	s1,56(sp)
    8000558c:	f84a                	sd	s2,48(sp)
    8000558e:	f44e                	sd	s3,40(sp)
    80005590:	f052                	sd	s4,32(sp)
    80005592:	ec56                	sd	s5,24(sp)
    80005594:	e85a                	sd	s6,16(sp)
    80005596:	e45e                	sd	s7,8(sp)
    80005598:	e062                	sd	s8,0(sp)
    8000559a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    8000559c:	00954783          	lbu	a5,9(a0)
    800055a0:	10078663          	beqz	a5,800056ac <filewrite+0x128>
    800055a4:	892a                	mv	s2,a0
    800055a6:	8aae                	mv	s5,a1
    800055a8:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800055aa:	411c                	lw	a5,0(a0)
    800055ac:	4705                	li	a4,1
    800055ae:	02e78263          	beq	a5,a4,800055d2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800055b2:	470d                	li	a4,3
    800055b4:	02e78663          	beq	a5,a4,800055e0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800055b8:	4709                	li	a4,2
    800055ba:	0ee79163          	bne	a5,a4,8000569c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800055be:	0ac05d63          	blez	a2,80005678 <filewrite+0xf4>
    int i = 0;
    800055c2:	4981                	li	s3,0
    800055c4:	6b05                	lui	s6,0x1
    800055c6:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800055ca:	6b85                	lui	s7,0x1
    800055cc:	c00b8b9b          	addiw	s7,s7,-1024
    800055d0:	a861                	j	80005668 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    800055d2:	6908                	ld	a0,16(a0)
    800055d4:	00000097          	auipc	ra,0x0
    800055d8:	22e080e7          	jalr	558(ra) # 80005802 <pipewrite>
    800055dc:	8a2a                	mv	s4,a0
    800055de:	a045                	j	8000567e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800055e0:	02451783          	lh	a5,36(a0)
    800055e4:	03079693          	slli	a3,a5,0x30
    800055e8:	92c1                	srli	a3,a3,0x30
    800055ea:	4725                	li	a4,9
    800055ec:	0cd76263          	bltu	a4,a3,800056b0 <filewrite+0x12c>
    800055f0:	0792                	slli	a5,a5,0x4
    800055f2:	0005d717          	auipc	a4,0x5d
    800055f6:	1ae70713          	addi	a4,a4,430 # 800627a0 <devsw>
    800055fa:	97ba                	add	a5,a5,a4
    800055fc:	679c                	ld	a5,8(a5)
    800055fe:	cbdd                	beqz	a5,800056b4 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80005600:	4505                	li	a0,1
    80005602:	9782                	jalr	a5
    80005604:	8a2a                	mv	s4,a0
    80005606:	a8a5                	j	8000567e <filewrite+0xfa>
    80005608:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000560c:	00000097          	auipc	ra,0x0
    80005610:	8ac080e7          	jalr	-1876(ra) # 80004eb8 <begin_op>
      ilock(f->ip);
    80005614:	01893503          	ld	a0,24(s2)
    80005618:	fffff097          	auipc	ra,0xfffff
    8000561c:	ec6080e7          	jalr	-314(ra) # 800044de <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005620:	8762                	mv	a4,s8
    80005622:	02092683          	lw	a3,32(s2)
    80005626:	01598633          	add	a2,s3,s5
    8000562a:	4585                	li	a1,1
    8000562c:	01893503          	ld	a0,24(s2)
    80005630:	fffff097          	auipc	ra,0xfffff
    80005634:	25a080e7          	jalr	602(ra) # 8000488a <writei>
    80005638:	84aa                	mv	s1,a0
    8000563a:	00a05763          	blez	a0,80005648 <filewrite+0xc4>
        f->off += r;
    8000563e:	02092783          	lw	a5,32(s2)
    80005642:	9fa9                	addw	a5,a5,a0
    80005644:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80005648:	01893503          	ld	a0,24(s2)
    8000564c:	fffff097          	auipc	ra,0xfffff
    80005650:	f54080e7          	jalr	-172(ra) # 800045a0 <iunlock>
      end_op();
    80005654:	00000097          	auipc	ra,0x0
    80005658:	8e4080e7          	jalr	-1820(ra) # 80004f38 <end_op>

      if(r != n1){
    8000565c:	009c1f63          	bne	s8,s1,8000567a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80005660:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80005664:	0149db63          	bge	s3,s4,8000567a <filewrite+0xf6>
      int n1 = n - i;
    80005668:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    8000566c:	84be                	mv	s1,a5
    8000566e:	2781                	sext.w	a5,a5
    80005670:	f8fb5ce3          	bge	s6,a5,80005608 <filewrite+0x84>
    80005674:	84de                	mv	s1,s7
    80005676:	bf49                	j	80005608 <filewrite+0x84>
    int i = 0;
    80005678:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    8000567a:	013a1f63          	bne	s4,s3,80005698 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000567e:	8552                	mv	a0,s4
    80005680:	60a6                	ld	ra,72(sp)
    80005682:	6406                	ld	s0,64(sp)
    80005684:	74e2                	ld	s1,56(sp)
    80005686:	7942                	ld	s2,48(sp)
    80005688:	79a2                	ld	s3,40(sp)
    8000568a:	7a02                	ld	s4,32(sp)
    8000568c:	6ae2                	ld	s5,24(sp)
    8000568e:	6b42                	ld	s6,16(sp)
    80005690:	6ba2                	ld	s7,8(sp)
    80005692:	6c02                	ld	s8,0(sp)
    80005694:	6161                	addi	sp,sp,80
    80005696:	8082                	ret
    ret = (i == n ? n : -1);
    80005698:	5a7d                	li	s4,-1
    8000569a:	b7d5                	j	8000567e <filewrite+0xfa>
    panic("filewrite");
    8000569c:	00004517          	auipc	a0,0x4
    800056a0:	14c50513          	addi	a0,a0,332 # 800097e8 <syscalls+0x2e8>
    800056a4:	ffffb097          	auipc	ra,0xffffb
    800056a8:	e86080e7          	jalr	-378(ra) # 8000052a <panic>
    return -1;
    800056ac:	5a7d                	li	s4,-1
    800056ae:	bfc1                	j	8000567e <filewrite+0xfa>
      return -1;
    800056b0:	5a7d                	li	s4,-1
    800056b2:	b7f1                	j	8000567e <filewrite+0xfa>
    800056b4:	5a7d                	li	s4,-1
    800056b6:	b7e1                	j	8000567e <filewrite+0xfa>

00000000800056b8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800056b8:	7179                	addi	sp,sp,-48
    800056ba:	f406                	sd	ra,40(sp)
    800056bc:	f022                	sd	s0,32(sp)
    800056be:	ec26                	sd	s1,24(sp)
    800056c0:	e84a                	sd	s2,16(sp)
    800056c2:	e44e                	sd	s3,8(sp)
    800056c4:	e052                	sd	s4,0(sp)
    800056c6:	1800                	addi	s0,sp,48
    800056c8:	84aa                	mv	s1,a0
    800056ca:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800056cc:	0005b023          	sd	zero,0(a1)
    800056d0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800056d4:	00000097          	auipc	ra,0x0
    800056d8:	bf4080e7          	jalr	-1036(ra) # 800052c8 <filealloc>
    800056dc:	e088                	sd	a0,0(s1)
    800056de:	c551                	beqz	a0,8000576a <pipealloc+0xb2>
    800056e0:	00000097          	auipc	ra,0x0
    800056e4:	be8080e7          	jalr	-1048(ra) # 800052c8 <filealloc>
    800056e8:	00aa3023          	sd	a0,0(s4)
    800056ec:	c92d                	beqz	a0,8000575e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800056ee:	ffffb097          	auipc	ra,0xffffb
    800056f2:	3e4080e7          	jalr	996(ra) # 80000ad2 <kalloc>
    800056f6:	892a                	mv	s2,a0
    800056f8:	c125                	beqz	a0,80005758 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800056fa:	4985                	li	s3,1
    800056fc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80005700:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80005704:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80005708:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000570c:	00004597          	auipc	a1,0x4
    80005710:	0ec58593          	addi	a1,a1,236 # 800097f8 <syscalls+0x2f8>
    80005714:	ffffb097          	auipc	ra,0xffffb
    80005718:	41e080e7          	jalr	1054(ra) # 80000b32 <initlock>
  (*f0)->type = FD_PIPE;
    8000571c:	609c                	ld	a5,0(s1)
    8000571e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80005722:	609c                	ld	a5,0(s1)
    80005724:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80005728:	609c                	ld	a5,0(s1)
    8000572a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000572e:	609c                	ld	a5,0(s1)
    80005730:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80005734:	000a3783          	ld	a5,0(s4)
    80005738:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000573c:	000a3783          	ld	a5,0(s4)
    80005740:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80005744:	000a3783          	ld	a5,0(s4)
    80005748:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000574c:	000a3783          	ld	a5,0(s4)
    80005750:	0127b823          	sd	s2,16(a5)
  return 0;
    80005754:	4501                	li	a0,0
    80005756:	a025                	j	8000577e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80005758:	6088                	ld	a0,0(s1)
    8000575a:	e501                	bnez	a0,80005762 <pipealloc+0xaa>
    8000575c:	a039                	j	8000576a <pipealloc+0xb2>
    8000575e:	6088                	ld	a0,0(s1)
    80005760:	c51d                	beqz	a0,8000578e <pipealloc+0xd6>
    fileclose(*f0);
    80005762:	00000097          	auipc	ra,0x0
    80005766:	c22080e7          	jalr	-990(ra) # 80005384 <fileclose>
  if(*f1)
    8000576a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000576e:	557d                	li	a0,-1
  if(*f1)
    80005770:	c799                	beqz	a5,8000577e <pipealloc+0xc6>
    fileclose(*f1);
    80005772:	853e                	mv	a0,a5
    80005774:	00000097          	auipc	ra,0x0
    80005778:	c10080e7          	jalr	-1008(ra) # 80005384 <fileclose>
  return -1;
    8000577c:	557d                	li	a0,-1
}
    8000577e:	70a2                	ld	ra,40(sp)
    80005780:	7402                	ld	s0,32(sp)
    80005782:	64e2                	ld	s1,24(sp)
    80005784:	6942                	ld	s2,16(sp)
    80005786:	69a2                	ld	s3,8(sp)
    80005788:	6a02                	ld	s4,0(sp)
    8000578a:	6145                	addi	sp,sp,48
    8000578c:	8082                	ret
  return -1;
    8000578e:	557d                	li	a0,-1
    80005790:	b7fd                	j	8000577e <pipealloc+0xc6>

0000000080005792 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005792:	1101                	addi	sp,sp,-32
    80005794:	ec06                	sd	ra,24(sp)
    80005796:	e822                	sd	s0,16(sp)
    80005798:	e426                	sd	s1,8(sp)
    8000579a:	e04a                	sd	s2,0(sp)
    8000579c:	1000                	addi	s0,sp,32
    8000579e:	84aa                	mv	s1,a0
    800057a0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800057a2:	ffffb097          	auipc	ra,0xffffb
    800057a6:	428080e7          	jalr	1064(ra) # 80000bca <acquire>
  if(writable){
    800057aa:	02090d63          	beqz	s2,800057e4 <pipeclose+0x52>
    pi->writeopen = 0;
    800057ae:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800057b2:	21848513          	addi	a0,s1,536
    800057b6:	ffffd097          	auipc	ra,0xffffd
    800057ba:	d72080e7          	jalr	-654(ra) # 80002528 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800057be:	2204b783          	ld	a5,544(s1)
    800057c2:	eb95                	bnez	a5,800057f6 <pipeclose+0x64>
    release(&pi->lock);
    800057c4:	8526                	mv	a0,s1
    800057c6:	ffffb097          	auipc	ra,0xffffb
    800057ca:	4be080e7          	jalr	1214(ra) # 80000c84 <release>
    kfree((char*)pi);
    800057ce:	8526                	mv	a0,s1
    800057d0:	ffffb097          	auipc	ra,0xffffb
    800057d4:	206080e7          	jalr	518(ra) # 800009d6 <kfree>
  } else
    release(&pi->lock);
}
    800057d8:	60e2                	ld	ra,24(sp)
    800057da:	6442                	ld	s0,16(sp)
    800057dc:	64a2                	ld	s1,8(sp)
    800057de:	6902                	ld	s2,0(sp)
    800057e0:	6105                	addi	sp,sp,32
    800057e2:	8082                	ret
    pi->readopen = 0;
    800057e4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800057e8:	21c48513          	addi	a0,s1,540
    800057ec:	ffffd097          	auipc	ra,0xffffd
    800057f0:	d3c080e7          	jalr	-708(ra) # 80002528 <wakeup>
    800057f4:	b7e9                	j	800057be <pipeclose+0x2c>
    release(&pi->lock);
    800057f6:	8526                	mv	a0,s1
    800057f8:	ffffb097          	auipc	ra,0xffffb
    800057fc:	48c080e7          	jalr	1164(ra) # 80000c84 <release>
}
    80005800:	bfe1                	j	800057d8 <pipeclose+0x46>

0000000080005802 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005802:	7159                	addi	sp,sp,-112
    80005804:	f486                	sd	ra,104(sp)
    80005806:	f0a2                	sd	s0,96(sp)
    80005808:	eca6                	sd	s1,88(sp)
    8000580a:	e8ca                	sd	s2,80(sp)
    8000580c:	e4ce                	sd	s3,72(sp)
    8000580e:	e0d2                	sd	s4,64(sp)
    80005810:	fc56                	sd	s5,56(sp)
    80005812:	f85a                	sd	s6,48(sp)
    80005814:	f45e                	sd	s7,40(sp)
    80005816:	f062                	sd	s8,32(sp)
    80005818:	ec66                	sd	s9,24(sp)
    8000581a:	1880                	addi	s0,sp,112
    8000581c:	84aa                	mv	s1,a0
    8000581e:	8aae                	mv	s5,a1
    80005820:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80005822:	ffffc097          	auipc	ra,0xffffc
    80005826:	1d6080e7          	jalr	470(ra) # 800019f8 <myproc>
    8000582a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000582c:	8526                	mv	a0,s1
    8000582e:	ffffb097          	auipc	ra,0xffffb
    80005832:	39c080e7          	jalr	924(ra) # 80000bca <acquire>
  while(i < n){
    80005836:	0b405663          	blez	s4,800058e2 <pipewrite+0xe0>
  int i = 0;
    8000583a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000583c:	6b05                	lui	s6,0x1
    8000583e:	9b4e                	add	s6,s6,s3
    80005840:	5bfd                	li	s7,-1
      wakeup(&pi->nread);
    80005842:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005846:	21c48c13          	addi	s8,s1,540
    8000584a:	a091                	j	8000588e <pipewrite+0x8c>
      release(&pi->lock);
    8000584c:	8526                	mv	a0,s1
    8000584e:	ffffb097          	auipc	ra,0xffffb
    80005852:	436080e7          	jalr	1078(ra) # 80000c84 <release>
      return -1;
    80005856:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80005858:	854a                	mv	a0,s2
    8000585a:	70a6                	ld	ra,104(sp)
    8000585c:	7406                	ld	s0,96(sp)
    8000585e:	64e6                	ld	s1,88(sp)
    80005860:	6946                	ld	s2,80(sp)
    80005862:	69a6                	ld	s3,72(sp)
    80005864:	6a06                	ld	s4,64(sp)
    80005866:	7ae2                	ld	s5,56(sp)
    80005868:	7b42                	ld	s6,48(sp)
    8000586a:	7ba2                	ld	s7,40(sp)
    8000586c:	7c02                	ld	s8,32(sp)
    8000586e:	6ce2                	ld	s9,24(sp)
    80005870:	6165                	addi	sp,sp,112
    80005872:	8082                	ret
      wakeup(&pi->nread);
    80005874:	8566                	mv	a0,s9
    80005876:	ffffd097          	auipc	ra,0xffffd
    8000587a:	cb2080e7          	jalr	-846(ra) # 80002528 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000587e:	85a6                	mv	a1,s1
    80005880:	8562                	mv	a0,s8
    80005882:	ffffd097          	auipc	ra,0xffffd
    80005886:	afc080e7          	jalr	-1284(ra) # 8000237e <sleep>
  while(i < n){
    8000588a:	05495d63          	bge	s2,s4,800058e4 <pipewrite+0xe2>
    if(pi->readopen == 0 || pr->killed){
    8000588e:	2204a783          	lw	a5,544(s1)
    80005892:	dfcd                	beqz	a5,8000584c <pipewrite+0x4a>
    80005894:	01c9a783          	lw	a5,28(s3)
    80005898:	fbd5                	bnez	a5,8000584c <pipewrite+0x4a>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000589a:	2184a783          	lw	a5,536(s1)
    8000589e:	21c4a703          	lw	a4,540(s1)
    800058a2:	2007879b          	addiw	a5,a5,512
    800058a6:	fcf707e3          	beq	a4,a5,80005874 <pipewrite+0x72>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800058aa:	4685                	li	a3,1
    800058ac:	01590633          	add	a2,s2,s5
    800058b0:	f9f40593          	addi	a1,s0,-97
    800058b4:	f40b3503          	ld	a0,-192(s6) # f40 <_entry-0x7ffff0c0>
    800058b8:	ffffc097          	auipc	ra,0xffffc
    800058bc:	e20080e7          	jalr	-480(ra) # 800016d8 <copyin>
    800058c0:	03750263          	beq	a0,s7,800058e4 <pipewrite+0xe2>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800058c4:	21c4a783          	lw	a5,540(s1)
    800058c8:	0017871b          	addiw	a4,a5,1
    800058cc:	20e4ae23          	sw	a4,540(s1)
    800058d0:	1ff7f793          	andi	a5,a5,511
    800058d4:	97a6                	add	a5,a5,s1
    800058d6:	f9f44703          	lbu	a4,-97(s0)
    800058da:	00e78c23          	sb	a4,24(a5)
      i++;
    800058de:	2905                	addiw	s2,s2,1
    800058e0:	b76d                	j	8000588a <pipewrite+0x88>
  int i = 0;
    800058e2:	4901                	li	s2,0
  wakeup(&pi->nread);
    800058e4:	21848513          	addi	a0,s1,536
    800058e8:	ffffd097          	auipc	ra,0xffffd
    800058ec:	c40080e7          	jalr	-960(ra) # 80002528 <wakeup>
  release(&pi->lock);
    800058f0:	8526                	mv	a0,s1
    800058f2:	ffffb097          	auipc	ra,0xffffb
    800058f6:	392080e7          	jalr	914(ra) # 80000c84 <release>
  return i;
    800058fa:	bfb9                	j	80005858 <pipewrite+0x56>

00000000800058fc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800058fc:	715d                	addi	sp,sp,-80
    800058fe:	e486                	sd	ra,72(sp)
    80005900:	e0a2                	sd	s0,64(sp)
    80005902:	fc26                	sd	s1,56(sp)
    80005904:	f84a                	sd	s2,48(sp)
    80005906:	f44e                	sd	s3,40(sp)
    80005908:	f052                	sd	s4,32(sp)
    8000590a:	ec56                	sd	s5,24(sp)
    8000590c:	e85a                	sd	s6,16(sp)
    8000590e:	0880                	addi	s0,sp,80
    80005910:	84aa                	mv	s1,a0
    80005912:	892e                	mv	s2,a1
    80005914:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80005916:	ffffc097          	auipc	ra,0xffffc
    8000591a:	0e2080e7          	jalr	226(ra) # 800019f8 <myproc>
    8000591e:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80005920:	8526                	mv	a0,s1
    80005922:	ffffb097          	auipc	ra,0xffffb
    80005926:	2a8080e7          	jalr	680(ra) # 80000bca <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000592a:	2184a703          	lw	a4,536(s1)
    8000592e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005932:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005936:	02f71463          	bne	a4,a5,8000595e <piperead+0x62>
    8000593a:	2244a783          	lw	a5,548(s1)
    8000593e:	c385                	beqz	a5,8000595e <piperead+0x62>
    if(pr->killed){
    80005940:	01caa783          	lw	a5,28(s5)
    80005944:	ebd1                	bnez	a5,800059d8 <piperead+0xdc>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005946:	85a6                	mv	a1,s1
    80005948:	854e                	mv	a0,s3
    8000594a:	ffffd097          	auipc	ra,0xffffd
    8000594e:	a34080e7          	jalr	-1484(ra) # 8000237e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005952:	2184a703          	lw	a4,536(s1)
    80005956:	21c4a783          	lw	a5,540(s1)
    8000595a:	fef700e3          	beq	a4,a5,8000593a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000595e:	4981                	li	s3,0
    80005960:	09405363          	blez	s4,800059e6 <piperead+0xea>
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005964:	6505                	lui	a0,0x1
    80005966:	9aaa                	add	s5,s5,a0
    80005968:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000596a:	2184a783          	lw	a5,536(s1)
    8000596e:	21c4a703          	lw	a4,540(s1)
    80005972:	02f70d63          	beq	a4,a5,800059ac <piperead+0xb0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005976:	0017871b          	addiw	a4,a5,1
    8000597a:	20e4ac23          	sw	a4,536(s1)
    8000597e:	1ff7f793          	andi	a5,a5,511
    80005982:	97a6                	add	a5,a5,s1
    80005984:	0187c783          	lbu	a5,24(a5)
    80005988:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000598c:	4685                	li	a3,1
    8000598e:	fbf40613          	addi	a2,s0,-65
    80005992:	85ca                	mv	a1,s2
    80005994:	f40ab503          	ld	a0,-192(s5)
    80005998:	ffffc097          	auipc	ra,0xffffc
    8000599c:	cb4080e7          	jalr	-844(ra) # 8000164c <copyout>
    800059a0:	01650663          	beq	a0,s6,800059ac <piperead+0xb0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800059a4:	2985                	addiw	s3,s3,1
    800059a6:	0905                	addi	s2,s2,1
    800059a8:	fd3a11e3          	bne	s4,s3,8000596a <piperead+0x6e>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800059ac:	21c48513          	addi	a0,s1,540
    800059b0:	ffffd097          	auipc	ra,0xffffd
    800059b4:	b78080e7          	jalr	-1160(ra) # 80002528 <wakeup>
  release(&pi->lock);
    800059b8:	8526                	mv	a0,s1
    800059ba:	ffffb097          	auipc	ra,0xffffb
    800059be:	2ca080e7          	jalr	714(ra) # 80000c84 <release>
  return i;
}
    800059c2:	854e                	mv	a0,s3
    800059c4:	60a6                	ld	ra,72(sp)
    800059c6:	6406                	ld	s0,64(sp)
    800059c8:	74e2                	ld	s1,56(sp)
    800059ca:	7942                	ld	s2,48(sp)
    800059cc:	79a2                	ld	s3,40(sp)
    800059ce:	7a02                	ld	s4,32(sp)
    800059d0:	6ae2                	ld	s5,24(sp)
    800059d2:	6b42                	ld	s6,16(sp)
    800059d4:	6161                	addi	sp,sp,80
    800059d6:	8082                	ret
      release(&pi->lock);
    800059d8:	8526                	mv	a0,s1
    800059da:	ffffb097          	auipc	ra,0xffffb
    800059de:	2aa080e7          	jalr	682(ra) # 80000c84 <release>
      return -1;
    800059e2:	59fd                	li	s3,-1
    800059e4:	bff9                	j	800059c2 <piperead+0xc6>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800059e6:	4981                	li	s3,0
    800059e8:	b7d1                	j	800059ac <piperead+0xb0>

00000000800059ea <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800059ea:	dd010113          	addi	sp,sp,-560
    800059ee:	22113423          	sd	ra,552(sp)
    800059f2:	22813023          	sd	s0,544(sp)
    800059f6:	20913c23          	sd	s1,536(sp)
    800059fa:	21213823          	sd	s2,528(sp)
    800059fe:	21313423          	sd	s3,520(sp)
    80005a02:	21413023          	sd	s4,512(sp)
    80005a06:	ffd6                	sd	s5,504(sp)
    80005a08:	fbda                	sd	s6,496(sp)
    80005a0a:	f7de                	sd	s7,488(sp)
    80005a0c:	f3e2                	sd	s8,480(sp)
    80005a0e:	efe6                	sd	s9,472(sp)
    80005a10:	ebea                	sd	s10,464(sp)
    80005a12:	e7ee                	sd	s11,456(sp)
    80005a14:	1c00                	addi	s0,sp,560
    80005a16:	892a                	mv	s2,a0
    80005a18:	dea43423          	sd	a0,-536(s0)
    80005a1c:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005a20:	ffffc097          	auipc	ra,0xffffc
    80005a24:	fd8080e7          	jalr	-40(ra) # 800019f8 <myproc>
    80005a28:	84aa                	mv	s1,a0
  struct thread *t = mythread();
    80005a2a:	ffffc097          	auipc	ra,0xffffc
    80005a2e:	064080e7          	jalr	100(ra) # 80001a8e <mythread>
    80005a32:	dea43023          	sd	a0,-544(s0)

  begin_op();
    80005a36:	fffff097          	auipc	ra,0xfffff
    80005a3a:	482080e7          	jalr	1154(ra) # 80004eb8 <begin_op>

  if((ip = namei(path)) == 0){
    80005a3e:	854a                	mv	a0,s2
    80005a40:	fffff097          	auipc	ra,0xfffff
    80005a44:	258080e7          	jalr	600(ra) # 80004c98 <namei>
    80005a48:	cd2d                	beqz	a0,80005ac2 <exec+0xd8>
    80005a4a:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005a4c:	fffff097          	auipc	ra,0xfffff
    80005a50:	a92080e7          	jalr	-1390(ra) # 800044de <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005a54:	04000713          	li	a4,64
    80005a58:	4681                	li	a3,0
    80005a5a:	e4840613          	addi	a2,s0,-440
    80005a5e:	4581                	li	a1,0
    80005a60:	8556                	mv	a0,s5
    80005a62:	fffff097          	auipc	ra,0xfffff
    80005a66:	d30080e7          	jalr	-720(ra) # 80004792 <readi>
    80005a6a:	04000793          	li	a5,64
    80005a6e:	00f51a63          	bne	a0,a5,80005a82 <exec+0x98>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80005a72:	e4842703          	lw	a4,-440(s0)
    80005a76:	464c47b7          	lui	a5,0x464c4
    80005a7a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005a7e:	04f70863          	beq	a4,a5,80005ace <exec+0xe4>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005a82:	8556                	mv	a0,s5
    80005a84:	fffff097          	auipc	ra,0xfffff
    80005a88:	cbc080e7          	jalr	-836(ra) # 80004740 <iunlockput>
    end_op();
    80005a8c:	fffff097          	auipc	ra,0xfffff
    80005a90:	4ac080e7          	jalr	1196(ra) # 80004f38 <end_op>
  }
  return -1;
    80005a94:	557d                	li	a0,-1
}
    80005a96:	22813083          	ld	ra,552(sp)
    80005a9a:	22013403          	ld	s0,544(sp)
    80005a9e:	21813483          	ld	s1,536(sp)
    80005aa2:	21013903          	ld	s2,528(sp)
    80005aa6:	20813983          	ld	s3,520(sp)
    80005aaa:	20013a03          	ld	s4,512(sp)
    80005aae:	7afe                	ld	s5,504(sp)
    80005ab0:	7b5e                	ld	s6,496(sp)
    80005ab2:	7bbe                	ld	s7,488(sp)
    80005ab4:	7c1e                	ld	s8,480(sp)
    80005ab6:	6cfe                	ld	s9,472(sp)
    80005ab8:	6d5e                	ld	s10,464(sp)
    80005aba:	6dbe                	ld	s11,456(sp)
    80005abc:	23010113          	addi	sp,sp,560
    80005ac0:	8082                	ret
    end_op();
    80005ac2:	fffff097          	auipc	ra,0xfffff
    80005ac6:	476080e7          	jalr	1142(ra) # 80004f38 <end_op>
    return -1;
    80005aca:	557d                	li	a0,-1
    80005acc:	b7e9                	j	80005a96 <exec+0xac>
  if((pagetable = proc_pagetable(p)) == 0)
    80005ace:	8526                	mv	a0,s1
    80005ad0:	ffffc097          	auipc	ra,0xffffc
    80005ad4:	08a080e7          	jalr	138(ra) # 80001b5a <proc_pagetable>
    80005ad8:	8b2a                	mv	s6,a0
    80005ada:	d545                	beqz	a0,80005a82 <exec+0x98>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005adc:	e6842783          	lw	a5,-408(s0)
    80005ae0:	e8045703          	lhu	a4,-384(s0)
    80005ae4:	c735                	beqz	a4,80005b50 <exec+0x166>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80005ae6:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005ae8:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80005aec:	6a05                	lui	s4,0x1
    80005aee:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80005af2:	dce43c23          	sd	a4,-552(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80005af6:	6d85                	lui	s11,0x1
    80005af8:	7d7d                	lui	s10,0xfffff
    80005afa:	ac9d                	j	80005d70 <exec+0x386>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80005afc:	00004517          	auipc	a0,0x4
    80005b00:	d0450513          	addi	a0,a0,-764 # 80009800 <syscalls+0x300>
    80005b04:	ffffb097          	auipc	ra,0xffffb
    80005b08:	a26080e7          	jalr	-1498(ra) # 8000052a <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005b0c:	874a                	mv	a4,s2
    80005b0e:	009c86bb          	addw	a3,s9,s1
    80005b12:	4581                	li	a1,0
    80005b14:	8556                	mv	a0,s5
    80005b16:	fffff097          	auipc	ra,0xfffff
    80005b1a:	c7c080e7          	jalr	-900(ra) # 80004792 <readi>
    80005b1e:	2501                	sext.w	a0,a0
    80005b20:	1ea91863          	bne	s2,a0,80005d10 <exec+0x326>
  for(i = 0; i < sz; i += PGSIZE){
    80005b24:	009d84bb          	addw	s1,s11,s1
    80005b28:	013d09bb          	addw	s3,s10,s3
    80005b2c:	2374f263          	bgeu	s1,s7,80005d50 <exec+0x366>
    pa = walkaddr(pagetable, va + i);
    80005b30:	02049593          	slli	a1,s1,0x20
    80005b34:	9181                	srli	a1,a1,0x20
    80005b36:	95e2                	add	a1,a1,s8
    80005b38:	855a                	mv	a0,s6
    80005b3a:	ffffb097          	auipc	ra,0xffffb
    80005b3e:	520080e7          	jalr	1312(ra) # 8000105a <walkaddr>
    80005b42:	862a                	mv	a2,a0
    if(pa == 0)
    80005b44:	dd45                	beqz	a0,80005afc <exec+0x112>
      n = PGSIZE;
    80005b46:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80005b48:	fd49f2e3          	bgeu	s3,s4,80005b0c <exec+0x122>
      n = sz - i;
    80005b4c:	894e                	mv	s2,s3
    80005b4e:	bf7d                	j	80005b0c <exec+0x122>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80005b50:	4481                	li	s1,0
  iunlockput(ip);
    80005b52:	8556                	mv	a0,s5
    80005b54:	fffff097          	auipc	ra,0xfffff
    80005b58:	bec080e7          	jalr	-1044(ra) # 80004740 <iunlockput>
  end_op();
    80005b5c:	fffff097          	auipc	ra,0xfffff
    80005b60:	3dc080e7          	jalr	988(ra) # 80004f38 <end_op>
  p = myproc();
    80005b64:	ffffc097          	auipc	ra,0xffffc
    80005b68:	e94080e7          	jalr	-364(ra) # 800019f8 <myproc>
    80005b6c:	8a2a                	mv	s4,a0
  uint64 oldsz = p->sz;
    80005b6e:	6785                	lui	a5,0x1
    80005b70:	00f50733          	add	a4,a0,a5
    80005b74:	f3873d03          	ld	s10,-200(a4)
  sz = PGROUNDUP(sz);
    80005b78:	17fd                	addi	a5,a5,-1
    80005b7a:	94be                	add	s1,s1,a5
    80005b7c:	77fd                	lui	a5,0xfffff
    80005b7e:	8fe5                	and	a5,a5,s1
    80005b80:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005b84:	6609                	lui	a2,0x2
    80005b86:	963e                	add	a2,a2,a5
    80005b88:	85be                	mv	a1,a5
    80005b8a:	855a                	mv	a0,s6
    80005b8c:	ffffc097          	auipc	ra,0xffffc
    80005b90:	870080e7          	jalr	-1936(ra) # 800013fc <uvmalloc>
    80005b94:	8caa                	mv	s9,a0
  ip = 0;
    80005b96:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005b98:	16050c63          	beqz	a0,80005d10 <exec+0x326>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005b9c:	75f9                	lui	a1,0xffffe
    80005b9e:	95aa                	add	a1,a1,a0
    80005ba0:	855a                	mv	a0,s6
    80005ba2:	ffffc097          	auipc	ra,0xffffc
    80005ba6:	a78080e7          	jalr	-1416(ra) # 8000161a <uvmclear>
  stackbase = sp - PGSIZE;
    80005baa:	7bfd                	lui	s7,0xfffff
    80005bac:	9be6                	add	s7,s7,s9
  for(argc = 0; argv[argc]; argc++) {
    80005bae:	df043783          	ld	a5,-528(s0)
    80005bb2:	6388                	ld	a0,0(a5)
    80005bb4:	c925                	beqz	a0,80005c24 <exec+0x23a>
    80005bb6:	e8840993          	addi	s3,s0,-376
    80005bba:	f8840c13          	addi	s8,s0,-120
  sp = sz;
    80005bbe:	8966                	mv	s2,s9
  for(argc = 0; argv[argc]; argc++) {
    80005bc0:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005bc2:	ffffb097          	auipc	ra,0xffffb
    80005bc6:	28e080e7          	jalr	654(ra) # 80000e50 <strlen>
    80005bca:	0015079b          	addiw	a5,a0,1
    80005bce:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005bd2:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80005bd6:	17796163          	bltu	s2,s7,80005d38 <exec+0x34e>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005bda:	df043d83          	ld	s11,-528(s0)
    80005bde:	000dba83          	ld	s5,0(s11) # 1000 <_entry-0x7ffff000>
    80005be2:	8556                	mv	a0,s5
    80005be4:	ffffb097          	auipc	ra,0xffffb
    80005be8:	26c080e7          	jalr	620(ra) # 80000e50 <strlen>
    80005bec:	0015069b          	addiw	a3,a0,1
    80005bf0:	8656                	mv	a2,s5
    80005bf2:	85ca                	mv	a1,s2
    80005bf4:	855a                	mv	a0,s6
    80005bf6:	ffffc097          	auipc	ra,0xffffc
    80005bfa:	a56080e7          	jalr	-1450(ra) # 8000164c <copyout>
    80005bfe:	14054163          	bltz	a0,80005d40 <exec+0x356>
    ustack[argc] = sp;
    80005c02:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005c06:	0485                	addi	s1,s1,1
    80005c08:	008d8793          	addi	a5,s11,8
    80005c0c:	def43823          	sd	a5,-528(s0)
    80005c10:	008db503          	ld	a0,8(s11)
    80005c14:	c911                	beqz	a0,80005c28 <exec+0x23e>
    if(argc >= MAXARG)
    80005c16:	09a1                	addi	s3,s3,8
    80005c18:	fb8995e3          	bne	s3,s8,80005bc2 <exec+0x1d8>
  sz = sz1;
    80005c1c:	df943c23          	sd	s9,-520(s0)
  ip = 0;
    80005c20:	4a81                	li	s5,0
    80005c22:	a0fd                	j	80005d10 <exec+0x326>
  sp = sz;
    80005c24:	8966                	mv	s2,s9
  for(argc = 0; argv[argc]; argc++) {
    80005c26:	4481                	li	s1,0
  ustack[argc] = 0;
    80005c28:	00349793          	slli	a5,s1,0x3
    80005c2c:	f9040713          	addi	a4,s0,-112
    80005c30:	97ba                	add	a5,a5,a4
    80005c32:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ff97ef8>
  sp -= (argc+1) * sizeof(uint64);
    80005c36:	00148693          	addi	a3,s1,1
    80005c3a:	068e                	slli	a3,a3,0x3
    80005c3c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005c40:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80005c44:	01797663          	bgeu	s2,s7,80005c50 <exec+0x266>
  sz = sz1;
    80005c48:	df943c23          	sd	s9,-520(s0)
  ip = 0;
    80005c4c:	4a81                	li	s5,0
    80005c4e:	a0c9                	j	80005d10 <exec+0x326>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005c50:	e8840613          	addi	a2,s0,-376
    80005c54:	85ca                	mv	a1,s2
    80005c56:	855a                	mv	a0,s6
    80005c58:	ffffc097          	auipc	ra,0xffffc
    80005c5c:	9f4080e7          	jalr	-1548(ra) # 8000164c <copyout>
    80005c60:	0e054463          	bltz	a0,80005d48 <exec+0x35e>
  t->trapframe->a1 = sp;
    80005c64:	de043783          	ld	a5,-544(s0)
    80005c68:	7f9c                	ld	a5,56(a5)
    80005c6a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005c6e:	de843783          	ld	a5,-536(s0)
    80005c72:	0007c703          	lbu	a4,0(a5)
    80005c76:	cf11                	beqz	a4,80005c92 <exec+0x2a8>
    80005c78:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005c7a:	02f00693          	li	a3,47
    80005c7e:	a039                	j	80005c8c <exec+0x2a2>
      last = s+1;
    80005c80:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005c84:	0785                	addi	a5,a5,1
    80005c86:	fff7c703          	lbu	a4,-1(a5)
    80005c8a:	c701                	beqz	a4,80005c92 <exec+0x2a8>
    if(*s == '/')
    80005c8c:	fed71ce3          	bne	a4,a3,80005c84 <exec+0x29a>
    80005c90:	bfc5                	j	80005c80 <exec+0x296>
  safestrcpy(p->name, last, sizeof(p->name));
    80005c92:	6985                	lui	s3,0x1
    80005c94:	fd098513          	addi	a0,s3,-48 # fd0 <_entry-0x7ffff030>
    80005c98:	4641                	li	a2,16
    80005c9a:	de843583          	ld	a1,-536(s0)
    80005c9e:	9552                	add	a0,a0,s4
    80005ca0:	ffffb097          	auipc	ra,0xffffb
    80005ca4:	17e080e7          	jalr	382(ra) # 80000e1e <safestrcpy>
  oldpagetable = p->pagetable;
    80005ca8:	013a07b3          	add	a5,s4,s3
    80005cac:	f407b503          	ld	a0,-192(a5)
  p->pagetable = pagetable;
    80005cb0:	f567b023          	sd	s6,-192(a5)
  p->sz = sz;
    80005cb4:	f397bc23          	sd	s9,-200(a5)
  t->trapframe->epc = elf.entry;  // initial program counter = main
    80005cb8:	de043683          	ld	a3,-544(s0)
    80005cbc:	7e9c                	ld	a5,56(a3)
    80005cbe:	e6043703          	ld	a4,-416(s0)
    80005cc2:	ef98                	sd	a4,24(a5)
  t->trapframe->sp = sp; // initial stack pointer
    80005cc4:	7e9c                	ld	a5,56(a3)
    80005cc6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005cca:	85ea                	mv	a1,s10
    80005ccc:	ffffc097          	auipc	ra,0xffffc
    80005cd0:	f30080e7          	jalr	-208(ra) # 80001bfc <proc_freepagetable>
  for (int i =0; i<32; i++){
    80005cd4:	fe898713          	addi	a4,s3,-24
    80005cd8:	9752                	add	a4,a4,s4
    80005cda:	0f498793          	addi	a5,s3,244
    80005cde:	97d2                	add	a5,a5,s4
    80005ce0:	17498693          	addi	a3,s3,372
    80005ce4:	96d2                	add	a3,a3,s4
    if(signalHanlder != (void*)SIG_IGN && signalHanlder != (void*)SIG_DFL){
    80005ce6:	4585                	li	a1,1
    80005ce8:	a029                	j	80005cf2 <exec+0x308>
  for (int i =0; i<32; i++){
    80005cea:	0721                	addi	a4,a4,8
    80005cec:	0791                	addi	a5,a5,4
    80005cee:	00f68863          	beq	a3,a5,80005cfe <exec+0x314>
    if(signalHanlder != (void*)SIG_IGN && signalHanlder != (void*)SIG_DFL){
    80005cf2:	6310                	ld	a2,0(a4)
    80005cf4:	fec5fbe3          	bgeu	a1,a2,80005cea <exec+0x300>
      p->maskHandlers[i]= 0;
    80005cf8:	0007a023          	sw	zero,0(a5)
    80005cfc:	b7fd                	j	80005cea <exec+0x300>
  p->signalMask = 0;
    80005cfe:	6785                	lui	a5,0x1
    80005d00:	9a3e                	add	s4,s4,a5
    80005d02:	fe0a2223          	sw	zero,-28(s4)
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005d06:	0004851b          	sext.w	a0,s1
    80005d0a:	b371                	j	80005a96 <exec+0xac>
    80005d0c:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005d10:	df843583          	ld	a1,-520(s0)
    80005d14:	855a                	mv	a0,s6
    80005d16:	ffffc097          	auipc	ra,0xffffc
    80005d1a:	ee6080e7          	jalr	-282(ra) # 80001bfc <proc_freepagetable>
  if(ip){
    80005d1e:	d60a92e3          	bnez	s5,80005a82 <exec+0x98>
  return -1;
    80005d22:	557d                	li	a0,-1
    80005d24:	bb8d                	j	80005a96 <exec+0xac>
    80005d26:	de943c23          	sd	s1,-520(s0)
    80005d2a:	b7dd                	j	80005d10 <exec+0x326>
    80005d2c:	de943c23          	sd	s1,-520(s0)
    80005d30:	b7c5                	j	80005d10 <exec+0x326>
    80005d32:	de943c23          	sd	s1,-520(s0)
    80005d36:	bfe9                	j	80005d10 <exec+0x326>
  sz = sz1;
    80005d38:	df943c23          	sd	s9,-520(s0)
  ip = 0;
    80005d3c:	4a81                	li	s5,0
    80005d3e:	bfc9                	j	80005d10 <exec+0x326>
  sz = sz1;
    80005d40:	df943c23          	sd	s9,-520(s0)
  ip = 0;
    80005d44:	4a81                	li	s5,0
    80005d46:	b7e9                	j	80005d10 <exec+0x326>
  sz = sz1;
    80005d48:	df943c23          	sd	s9,-520(s0)
  ip = 0;
    80005d4c:	4a81                	li	s5,0
    80005d4e:	b7c9                	j	80005d10 <exec+0x326>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005d50:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005d54:	e0843783          	ld	a5,-504(s0)
    80005d58:	0017869b          	addiw	a3,a5,1
    80005d5c:	e0d43423          	sd	a3,-504(s0)
    80005d60:	e0043783          	ld	a5,-512(s0)
    80005d64:	0387879b          	addiw	a5,a5,56
    80005d68:	e8045703          	lhu	a4,-384(s0)
    80005d6c:	dee6d3e3          	bge	a3,a4,80005b52 <exec+0x168>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005d70:	2781                	sext.w	a5,a5
    80005d72:	e0f43023          	sd	a5,-512(s0)
    80005d76:	03800713          	li	a4,56
    80005d7a:	86be                	mv	a3,a5
    80005d7c:	e1040613          	addi	a2,s0,-496
    80005d80:	4581                	li	a1,0
    80005d82:	8556                	mv	a0,s5
    80005d84:	fffff097          	auipc	ra,0xfffff
    80005d88:	a0e080e7          	jalr	-1522(ra) # 80004792 <readi>
    80005d8c:	03800793          	li	a5,56
    80005d90:	f6f51ee3          	bne	a0,a5,80005d0c <exec+0x322>
    if(ph.type != ELF_PROG_LOAD)
    80005d94:	e1042783          	lw	a5,-496(s0)
    80005d98:	4705                	li	a4,1
    80005d9a:	fae79de3          	bne	a5,a4,80005d54 <exec+0x36a>
    if(ph.memsz < ph.filesz)
    80005d9e:	e3843603          	ld	a2,-456(s0)
    80005da2:	e3043783          	ld	a5,-464(s0)
    80005da6:	f8f660e3          	bltu	a2,a5,80005d26 <exec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005daa:	e2043783          	ld	a5,-480(s0)
    80005dae:	963e                	add	a2,a2,a5
    80005db0:	f6f66ee3          	bltu	a2,a5,80005d2c <exec+0x342>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005db4:	85a6                	mv	a1,s1
    80005db6:	855a                	mv	a0,s6
    80005db8:	ffffb097          	auipc	ra,0xffffb
    80005dbc:	644080e7          	jalr	1604(ra) # 800013fc <uvmalloc>
    80005dc0:	dea43c23          	sd	a0,-520(s0)
    80005dc4:	d53d                	beqz	a0,80005d32 <exec+0x348>
    if(ph.vaddr % PGSIZE != 0)
    80005dc6:	e2043c03          	ld	s8,-480(s0)
    80005dca:	dd843783          	ld	a5,-552(s0)
    80005dce:	00fc77b3          	and	a5,s8,a5
    80005dd2:	ff9d                	bnez	a5,80005d10 <exec+0x326>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005dd4:	e1842c83          	lw	s9,-488(s0)
    80005dd8:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005ddc:	f60b8ae3          	beqz	s7,80005d50 <exec+0x366>
    80005de0:	89de                	mv	s3,s7
    80005de2:	4481                	li	s1,0
    80005de4:	b3b1                	j	80005b30 <exec+0x146>

0000000080005de6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005de6:	7179                	addi	sp,sp,-48
    80005de8:	f406                	sd	ra,40(sp)
    80005dea:	f022                	sd	s0,32(sp)
    80005dec:	ec26                	sd	s1,24(sp)
    80005dee:	e84a                	sd	s2,16(sp)
    80005df0:	1800                	addi	s0,sp,48
    80005df2:	892e                	mv	s2,a1
    80005df4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005df6:	fdc40593          	addi	a1,s0,-36
    80005dfa:	ffffe097          	auipc	ra,0xffffe
    80005dfe:	90c080e7          	jalr	-1780(ra) # 80003706 <argint>
    80005e02:	04054063          	bltz	a0,80005e42 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005e06:	fdc42703          	lw	a4,-36(s0)
    80005e0a:	47bd                	li	a5,15
    80005e0c:	02e7ed63          	bltu	a5,a4,80005e46 <argfd+0x60>
    80005e10:	ffffc097          	auipc	ra,0xffffc
    80005e14:	be8080e7          	jalr	-1048(ra) # 800019f8 <myproc>
    80005e18:	fdc42703          	lw	a4,-36(s0)
    80005e1c:	1e870793          	addi	a5,a4,488
    80005e20:	078e                	slli	a5,a5,0x3
    80005e22:	953e                	add	a0,a0,a5
    80005e24:	651c                	ld	a5,8(a0)
    80005e26:	c395                	beqz	a5,80005e4a <argfd+0x64>
    return -1;
  if(pfd)
    80005e28:	00090463          	beqz	s2,80005e30 <argfd+0x4a>
    *pfd = fd;
    80005e2c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005e30:	4501                	li	a0,0
  if(pf)
    80005e32:	c091                	beqz	s1,80005e36 <argfd+0x50>
    *pf = f;
    80005e34:	e09c                	sd	a5,0(s1)
}
    80005e36:	70a2                	ld	ra,40(sp)
    80005e38:	7402                	ld	s0,32(sp)
    80005e3a:	64e2                	ld	s1,24(sp)
    80005e3c:	6942                	ld	s2,16(sp)
    80005e3e:	6145                	addi	sp,sp,48
    80005e40:	8082                	ret
    return -1;
    80005e42:	557d                	li	a0,-1
    80005e44:	bfcd                	j	80005e36 <argfd+0x50>
    return -1;
    80005e46:	557d                	li	a0,-1
    80005e48:	b7fd                	j	80005e36 <argfd+0x50>
    80005e4a:	557d                	li	a0,-1
    80005e4c:	b7ed                	j	80005e36 <argfd+0x50>

0000000080005e4e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005e4e:	1101                	addi	sp,sp,-32
    80005e50:	ec06                	sd	ra,24(sp)
    80005e52:	e822                	sd	s0,16(sp)
    80005e54:	e426                	sd	s1,8(sp)
    80005e56:	1000                	addi	s0,sp,32
    80005e58:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005e5a:	ffffc097          	auipc	ra,0xffffc
    80005e5e:	b9e080e7          	jalr	-1122(ra) # 800019f8 <myproc>
    80005e62:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005e64:	6785                	lui	a5,0x1
    80005e66:	f4878793          	addi	a5,a5,-184 # f48 <_entry-0x7ffff0b8>
    80005e6a:	97aa                	add	a5,a5,a0
    80005e6c:	4501                	li	a0,0
    80005e6e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005e70:	6398                	ld	a4,0(a5)
    80005e72:	cb19                	beqz	a4,80005e88 <fdalloc+0x3a>
  for(fd = 0; fd < NOFILE; fd++){
    80005e74:	2505                	addiw	a0,a0,1
    80005e76:	07a1                	addi	a5,a5,8
    80005e78:	fed51ce3          	bne	a0,a3,80005e70 <fdalloc+0x22>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005e7c:	557d                	li	a0,-1
}
    80005e7e:	60e2                	ld	ra,24(sp)
    80005e80:	6442                	ld	s0,16(sp)
    80005e82:	64a2                	ld	s1,8(sp)
    80005e84:	6105                	addi	sp,sp,32
    80005e86:	8082                	ret
      p->ofile[fd] = f;
    80005e88:	1e850793          	addi	a5,a0,488
    80005e8c:	078e                	slli	a5,a5,0x3
    80005e8e:	963e                	add	a2,a2,a5
    80005e90:	e604                	sd	s1,8(a2)
      return fd;
    80005e92:	b7f5                	j	80005e7e <fdalloc+0x30>

0000000080005e94 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005e94:	715d                	addi	sp,sp,-80
    80005e96:	e486                	sd	ra,72(sp)
    80005e98:	e0a2                	sd	s0,64(sp)
    80005e9a:	fc26                	sd	s1,56(sp)
    80005e9c:	f84a                	sd	s2,48(sp)
    80005e9e:	f44e                	sd	s3,40(sp)
    80005ea0:	f052                	sd	s4,32(sp)
    80005ea2:	ec56                	sd	s5,24(sp)
    80005ea4:	0880                	addi	s0,sp,80
    80005ea6:	89ae                	mv	s3,a1
    80005ea8:	8ab2                	mv	s5,a2
    80005eaa:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005eac:	fb040593          	addi	a1,s0,-80
    80005eb0:	fffff097          	auipc	ra,0xfffff
    80005eb4:	e06080e7          	jalr	-506(ra) # 80004cb6 <nameiparent>
    80005eb8:	892a                	mv	s2,a0
    80005eba:	12050e63          	beqz	a0,80005ff6 <create+0x162>
    return 0;

  ilock(dp);
    80005ebe:	ffffe097          	auipc	ra,0xffffe
    80005ec2:	620080e7          	jalr	1568(ra) # 800044de <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005ec6:	4601                	li	a2,0
    80005ec8:	fb040593          	addi	a1,s0,-80
    80005ecc:	854a                	mv	a0,s2
    80005ece:	fffff097          	auipc	ra,0xfffff
    80005ed2:	af4080e7          	jalr	-1292(ra) # 800049c2 <dirlookup>
    80005ed6:	84aa                	mv	s1,a0
    80005ed8:	c921                	beqz	a0,80005f28 <create+0x94>
    iunlockput(dp);
    80005eda:	854a                	mv	a0,s2
    80005edc:	fffff097          	auipc	ra,0xfffff
    80005ee0:	864080e7          	jalr	-1948(ra) # 80004740 <iunlockput>
    ilock(ip);
    80005ee4:	8526                	mv	a0,s1
    80005ee6:	ffffe097          	auipc	ra,0xffffe
    80005eea:	5f8080e7          	jalr	1528(ra) # 800044de <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005eee:	2981                	sext.w	s3,s3
    80005ef0:	4789                	li	a5,2
    80005ef2:	02f99463          	bne	s3,a5,80005f1a <create+0x86>
    80005ef6:	0444d783          	lhu	a5,68(s1)
    80005efa:	37f9                	addiw	a5,a5,-2
    80005efc:	17c2                	slli	a5,a5,0x30
    80005efe:	93c1                	srli	a5,a5,0x30
    80005f00:	4705                	li	a4,1
    80005f02:	00f76c63          	bltu	a4,a5,80005f1a <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005f06:	8526                	mv	a0,s1
    80005f08:	60a6                	ld	ra,72(sp)
    80005f0a:	6406                	ld	s0,64(sp)
    80005f0c:	74e2                	ld	s1,56(sp)
    80005f0e:	7942                	ld	s2,48(sp)
    80005f10:	79a2                	ld	s3,40(sp)
    80005f12:	7a02                	ld	s4,32(sp)
    80005f14:	6ae2                	ld	s5,24(sp)
    80005f16:	6161                	addi	sp,sp,80
    80005f18:	8082                	ret
    iunlockput(ip);
    80005f1a:	8526                	mv	a0,s1
    80005f1c:	fffff097          	auipc	ra,0xfffff
    80005f20:	824080e7          	jalr	-2012(ra) # 80004740 <iunlockput>
    return 0;
    80005f24:	4481                	li	s1,0
    80005f26:	b7c5                	j	80005f06 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005f28:	85ce                	mv	a1,s3
    80005f2a:	00092503          	lw	a0,0(s2)
    80005f2e:	ffffe097          	auipc	ra,0xffffe
    80005f32:	418080e7          	jalr	1048(ra) # 80004346 <ialloc>
    80005f36:	84aa                	mv	s1,a0
    80005f38:	c521                	beqz	a0,80005f80 <create+0xec>
  ilock(ip);
    80005f3a:	ffffe097          	auipc	ra,0xffffe
    80005f3e:	5a4080e7          	jalr	1444(ra) # 800044de <ilock>
  ip->major = major;
    80005f42:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005f46:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005f4a:	4a05                	li	s4,1
    80005f4c:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005f50:	8526                	mv	a0,s1
    80005f52:	ffffe097          	auipc	ra,0xffffe
    80005f56:	4c2080e7          	jalr	1218(ra) # 80004414 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005f5a:	2981                	sext.w	s3,s3
    80005f5c:	03498a63          	beq	s3,s4,80005f90 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005f60:	40d0                	lw	a2,4(s1)
    80005f62:	fb040593          	addi	a1,s0,-80
    80005f66:	854a                	mv	a0,s2
    80005f68:	fffff097          	auipc	ra,0xfffff
    80005f6c:	c6e080e7          	jalr	-914(ra) # 80004bd6 <dirlink>
    80005f70:	06054b63          	bltz	a0,80005fe6 <create+0x152>
  iunlockput(dp);
    80005f74:	854a                	mv	a0,s2
    80005f76:	ffffe097          	auipc	ra,0xffffe
    80005f7a:	7ca080e7          	jalr	1994(ra) # 80004740 <iunlockput>
  return ip;
    80005f7e:	b761                	j	80005f06 <create+0x72>
    panic("create: ialloc");
    80005f80:	00004517          	auipc	a0,0x4
    80005f84:	8a050513          	addi	a0,a0,-1888 # 80009820 <syscalls+0x320>
    80005f88:	ffffa097          	auipc	ra,0xffffa
    80005f8c:	5a2080e7          	jalr	1442(ra) # 8000052a <panic>
    dp->nlink++;  // for ".."
    80005f90:	04a95783          	lhu	a5,74(s2)
    80005f94:	2785                	addiw	a5,a5,1
    80005f96:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005f9a:	854a                	mv	a0,s2
    80005f9c:	ffffe097          	auipc	ra,0xffffe
    80005fa0:	478080e7          	jalr	1144(ra) # 80004414 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005fa4:	40d0                	lw	a2,4(s1)
    80005fa6:	00004597          	auipc	a1,0x4
    80005faa:	88a58593          	addi	a1,a1,-1910 # 80009830 <syscalls+0x330>
    80005fae:	8526                	mv	a0,s1
    80005fb0:	fffff097          	auipc	ra,0xfffff
    80005fb4:	c26080e7          	jalr	-986(ra) # 80004bd6 <dirlink>
    80005fb8:	00054f63          	bltz	a0,80005fd6 <create+0x142>
    80005fbc:	00492603          	lw	a2,4(s2)
    80005fc0:	00004597          	auipc	a1,0x4
    80005fc4:	87858593          	addi	a1,a1,-1928 # 80009838 <syscalls+0x338>
    80005fc8:	8526                	mv	a0,s1
    80005fca:	fffff097          	auipc	ra,0xfffff
    80005fce:	c0c080e7          	jalr	-1012(ra) # 80004bd6 <dirlink>
    80005fd2:	f80557e3          	bgez	a0,80005f60 <create+0xcc>
      panic("create dots");
    80005fd6:	00004517          	auipc	a0,0x4
    80005fda:	86a50513          	addi	a0,a0,-1942 # 80009840 <syscalls+0x340>
    80005fde:	ffffa097          	auipc	ra,0xffffa
    80005fe2:	54c080e7          	jalr	1356(ra) # 8000052a <panic>
    panic("create: dirlink");
    80005fe6:	00004517          	auipc	a0,0x4
    80005fea:	86a50513          	addi	a0,a0,-1942 # 80009850 <syscalls+0x350>
    80005fee:	ffffa097          	auipc	ra,0xffffa
    80005ff2:	53c080e7          	jalr	1340(ra) # 8000052a <panic>
    return 0;
    80005ff6:	84aa                	mv	s1,a0
    80005ff8:	b739                	j	80005f06 <create+0x72>

0000000080005ffa <sys_dup>:
{
    80005ffa:	7179                	addi	sp,sp,-48
    80005ffc:	f406                	sd	ra,40(sp)
    80005ffe:	f022                	sd	s0,32(sp)
    80006000:	ec26                	sd	s1,24(sp)
    80006002:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80006004:	fd840613          	addi	a2,s0,-40
    80006008:	4581                	li	a1,0
    8000600a:	4501                	li	a0,0
    8000600c:	00000097          	auipc	ra,0x0
    80006010:	dda080e7          	jalr	-550(ra) # 80005de6 <argfd>
    return -1;
    80006014:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80006016:	02054363          	bltz	a0,8000603c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000601a:	fd843503          	ld	a0,-40(s0)
    8000601e:	00000097          	auipc	ra,0x0
    80006022:	e30080e7          	jalr	-464(ra) # 80005e4e <fdalloc>
    80006026:	84aa                	mv	s1,a0
    return -1;
    80006028:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000602a:	00054963          	bltz	a0,8000603c <sys_dup+0x42>
  filedup(f);
    8000602e:	fd843503          	ld	a0,-40(s0)
    80006032:	fffff097          	auipc	ra,0xfffff
    80006036:	300080e7          	jalr	768(ra) # 80005332 <filedup>
  return fd;
    8000603a:	87a6                	mv	a5,s1
}
    8000603c:	853e                	mv	a0,a5
    8000603e:	70a2                	ld	ra,40(sp)
    80006040:	7402                	ld	s0,32(sp)
    80006042:	64e2                	ld	s1,24(sp)
    80006044:	6145                	addi	sp,sp,48
    80006046:	8082                	ret

0000000080006048 <sys_read>:
{
    80006048:	7179                	addi	sp,sp,-48
    8000604a:	f406                	sd	ra,40(sp)
    8000604c:	f022                	sd	s0,32(sp)
    8000604e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006050:	fe840613          	addi	a2,s0,-24
    80006054:	4581                	li	a1,0
    80006056:	4501                	li	a0,0
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	d8e080e7          	jalr	-626(ra) # 80005de6 <argfd>
    return -1;
    80006060:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006062:	04054163          	bltz	a0,800060a4 <sys_read+0x5c>
    80006066:	fe440593          	addi	a1,s0,-28
    8000606a:	4509                	li	a0,2
    8000606c:	ffffd097          	auipc	ra,0xffffd
    80006070:	69a080e7          	jalr	1690(ra) # 80003706 <argint>
    return -1;
    80006074:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006076:	02054763          	bltz	a0,800060a4 <sys_read+0x5c>
    8000607a:	fd840593          	addi	a1,s0,-40
    8000607e:	4505                	li	a0,1
    80006080:	ffffd097          	auipc	ra,0xffffd
    80006084:	6a8080e7          	jalr	1704(ra) # 80003728 <argaddr>
    return -1;
    80006088:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000608a:	00054d63          	bltz	a0,800060a4 <sys_read+0x5c>
  return fileread(f, p, n);
    8000608e:	fe442603          	lw	a2,-28(s0)
    80006092:	fd843583          	ld	a1,-40(s0)
    80006096:	fe843503          	ld	a0,-24(s0)
    8000609a:	fffff097          	auipc	ra,0xfffff
    8000609e:	428080e7          	jalr	1064(ra) # 800054c2 <fileread>
    800060a2:	87aa                	mv	a5,a0
}
    800060a4:	853e                	mv	a0,a5
    800060a6:	70a2                	ld	ra,40(sp)
    800060a8:	7402                	ld	s0,32(sp)
    800060aa:	6145                	addi	sp,sp,48
    800060ac:	8082                	ret

00000000800060ae <sys_write>:
{
    800060ae:	7179                	addi	sp,sp,-48
    800060b0:	f406                	sd	ra,40(sp)
    800060b2:	f022                	sd	s0,32(sp)
    800060b4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800060b6:	fe840613          	addi	a2,s0,-24
    800060ba:	4581                	li	a1,0
    800060bc:	4501                	li	a0,0
    800060be:	00000097          	auipc	ra,0x0
    800060c2:	d28080e7          	jalr	-728(ra) # 80005de6 <argfd>
    return -1;
    800060c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800060c8:	04054163          	bltz	a0,8000610a <sys_write+0x5c>
    800060cc:	fe440593          	addi	a1,s0,-28
    800060d0:	4509                	li	a0,2
    800060d2:	ffffd097          	auipc	ra,0xffffd
    800060d6:	634080e7          	jalr	1588(ra) # 80003706 <argint>
    return -1;
    800060da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800060dc:	02054763          	bltz	a0,8000610a <sys_write+0x5c>
    800060e0:	fd840593          	addi	a1,s0,-40
    800060e4:	4505                	li	a0,1
    800060e6:	ffffd097          	auipc	ra,0xffffd
    800060ea:	642080e7          	jalr	1602(ra) # 80003728 <argaddr>
    return -1;
    800060ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800060f0:	00054d63          	bltz	a0,8000610a <sys_write+0x5c>
  return filewrite(f, p, n);
    800060f4:	fe442603          	lw	a2,-28(s0)
    800060f8:	fd843583          	ld	a1,-40(s0)
    800060fc:	fe843503          	ld	a0,-24(s0)
    80006100:	fffff097          	auipc	ra,0xfffff
    80006104:	484080e7          	jalr	1156(ra) # 80005584 <filewrite>
    80006108:	87aa                	mv	a5,a0
}
    8000610a:	853e                	mv	a0,a5
    8000610c:	70a2                	ld	ra,40(sp)
    8000610e:	7402                	ld	s0,32(sp)
    80006110:	6145                	addi	sp,sp,48
    80006112:	8082                	ret

0000000080006114 <sys_close>:
{
    80006114:	1101                	addi	sp,sp,-32
    80006116:	ec06                	sd	ra,24(sp)
    80006118:	e822                	sd	s0,16(sp)
    8000611a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000611c:	fe040613          	addi	a2,s0,-32
    80006120:	fec40593          	addi	a1,s0,-20
    80006124:	4501                	li	a0,0
    80006126:	00000097          	auipc	ra,0x0
    8000612a:	cc0080e7          	jalr	-832(ra) # 80005de6 <argfd>
    return -1;
    8000612e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80006130:	02054563          	bltz	a0,8000615a <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    80006134:	ffffc097          	auipc	ra,0xffffc
    80006138:	8c4080e7          	jalr	-1852(ra) # 800019f8 <myproc>
    8000613c:	fec42783          	lw	a5,-20(s0)
    80006140:	1e878793          	addi	a5,a5,488
    80006144:	078e                	slli	a5,a5,0x3
    80006146:	97aa                	add	a5,a5,a0
    80006148:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    8000614c:	fe043503          	ld	a0,-32(s0)
    80006150:	fffff097          	auipc	ra,0xfffff
    80006154:	234080e7          	jalr	564(ra) # 80005384 <fileclose>
  return 0;
    80006158:	4781                	li	a5,0
}
    8000615a:	853e                	mv	a0,a5
    8000615c:	60e2                	ld	ra,24(sp)
    8000615e:	6442                	ld	s0,16(sp)
    80006160:	6105                	addi	sp,sp,32
    80006162:	8082                	ret

0000000080006164 <sys_fstat>:
{
    80006164:	1101                	addi	sp,sp,-32
    80006166:	ec06                	sd	ra,24(sp)
    80006168:	e822                	sd	s0,16(sp)
    8000616a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000616c:	fe840613          	addi	a2,s0,-24
    80006170:	4581                	li	a1,0
    80006172:	4501                	li	a0,0
    80006174:	00000097          	auipc	ra,0x0
    80006178:	c72080e7          	jalr	-910(ra) # 80005de6 <argfd>
    return -1;
    8000617c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000617e:	02054563          	bltz	a0,800061a8 <sys_fstat+0x44>
    80006182:	fe040593          	addi	a1,s0,-32
    80006186:	4505                	li	a0,1
    80006188:	ffffd097          	auipc	ra,0xffffd
    8000618c:	5a0080e7          	jalr	1440(ra) # 80003728 <argaddr>
    return -1;
    80006190:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80006192:	00054b63          	bltz	a0,800061a8 <sys_fstat+0x44>
  return filestat(f, st);
    80006196:	fe043583          	ld	a1,-32(s0)
    8000619a:	fe843503          	ld	a0,-24(s0)
    8000619e:	fffff097          	auipc	ra,0xfffff
    800061a2:	2ae080e7          	jalr	686(ra) # 8000544c <filestat>
    800061a6:	87aa                	mv	a5,a0
}
    800061a8:	853e                	mv	a0,a5
    800061aa:	60e2                	ld	ra,24(sp)
    800061ac:	6442                	ld	s0,16(sp)
    800061ae:	6105                	addi	sp,sp,32
    800061b0:	8082                	ret

00000000800061b2 <sys_link>:
{
    800061b2:	7169                	addi	sp,sp,-304
    800061b4:	f606                	sd	ra,296(sp)
    800061b6:	f222                	sd	s0,288(sp)
    800061b8:	ee26                	sd	s1,280(sp)
    800061ba:	ea4a                	sd	s2,272(sp)
    800061bc:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800061be:	08000613          	li	a2,128
    800061c2:	ed040593          	addi	a1,s0,-304
    800061c6:	4501                	li	a0,0
    800061c8:	ffffd097          	auipc	ra,0xffffd
    800061cc:	582080e7          	jalr	1410(ra) # 8000374a <argstr>
    return -1;
    800061d0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800061d2:	10054e63          	bltz	a0,800062ee <sys_link+0x13c>
    800061d6:	08000613          	li	a2,128
    800061da:	f5040593          	addi	a1,s0,-176
    800061de:	4505                	li	a0,1
    800061e0:	ffffd097          	auipc	ra,0xffffd
    800061e4:	56a080e7          	jalr	1386(ra) # 8000374a <argstr>
    return -1;
    800061e8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800061ea:	10054263          	bltz	a0,800062ee <sys_link+0x13c>
  begin_op();
    800061ee:	fffff097          	auipc	ra,0xfffff
    800061f2:	cca080e7          	jalr	-822(ra) # 80004eb8 <begin_op>
  if((ip = namei(old)) == 0){
    800061f6:	ed040513          	addi	a0,s0,-304
    800061fa:	fffff097          	auipc	ra,0xfffff
    800061fe:	a9e080e7          	jalr	-1378(ra) # 80004c98 <namei>
    80006202:	84aa                	mv	s1,a0
    80006204:	c551                	beqz	a0,80006290 <sys_link+0xde>
  ilock(ip);
    80006206:	ffffe097          	auipc	ra,0xffffe
    8000620a:	2d8080e7          	jalr	728(ra) # 800044de <ilock>
  if(ip->type == T_DIR){
    8000620e:	04449703          	lh	a4,68(s1)
    80006212:	4785                	li	a5,1
    80006214:	08f70463          	beq	a4,a5,8000629c <sys_link+0xea>
  ip->nlink++;
    80006218:	04a4d783          	lhu	a5,74(s1)
    8000621c:	2785                	addiw	a5,a5,1
    8000621e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80006222:	8526                	mv	a0,s1
    80006224:	ffffe097          	auipc	ra,0xffffe
    80006228:	1f0080e7          	jalr	496(ra) # 80004414 <iupdate>
  iunlock(ip);
    8000622c:	8526                	mv	a0,s1
    8000622e:	ffffe097          	auipc	ra,0xffffe
    80006232:	372080e7          	jalr	882(ra) # 800045a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80006236:	fd040593          	addi	a1,s0,-48
    8000623a:	f5040513          	addi	a0,s0,-176
    8000623e:	fffff097          	auipc	ra,0xfffff
    80006242:	a78080e7          	jalr	-1416(ra) # 80004cb6 <nameiparent>
    80006246:	892a                	mv	s2,a0
    80006248:	c935                	beqz	a0,800062bc <sys_link+0x10a>
  ilock(dp);
    8000624a:	ffffe097          	auipc	ra,0xffffe
    8000624e:	294080e7          	jalr	660(ra) # 800044de <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80006252:	00092703          	lw	a4,0(s2)
    80006256:	409c                	lw	a5,0(s1)
    80006258:	04f71d63          	bne	a4,a5,800062b2 <sys_link+0x100>
    8000625c:	40d0                	lw	a2,4(s1)
    8000625e:	fd040593          	addi	a1,s0,-48
    80006262:	854a                	mv	a0,s2
    80006264:	fffff097          	auipc	ra,0xfffff
    80006268:	972080e7          	jalr	-1678(ra) # 80004bd6 <dirlink>
    8000626c:	04054363          	bltz	a0,800062b2 <sys_link+0x100>
  iunlockput(dp);
    80006270:	854a                	mv	a0,s2
    80006272:	ffffe097          	auipc	ra,0xffffe
    80006276:	4ce080e7          	jalr	1230(ra) # 80004740 <iunlockput>
  iput(ip);
    8000627a:	8526                	mv	a0,s1
    8000627c:	ffffe097          	auipc	ra,0xffffe
    80006280:	41c080e7          	jalr	1052(ra) # 80004698 <iput>
  end_op();
    80006284:	fffff097          	auipc	ra,0xfffff
    80006288:	cb4080e7          	jalr	-844(ra) # 80004f38 <end_op>
  return 0;
    8000628c:	4781                	li	a5,0
    8000628e:	a085                	j	800062ee <sys_link+0x13c>
    end_op();
    80006290:	fffff097          	auipc	ra,0xfffff
    80006294:	ca8080e7          	jalr	-856(ra) # 80004f38 <end_op>
    return -1;
    80006298:	57fd                	li	a5,-1
    8000629a:	a891                	j	800062ee <sys_link+0x13c>
    iunlockput(ip);
    8000629c:	8526                	mv	a0,s1
    8000629e:	ffffe097          	auipc	ra,0xffffe
    800062a2:	4a2080e7          	jalr	1186(ra) # 80004740 <iunlockput>
    end_op();
    800062a6:	fffff097          	auipc	ra,0xfffff
    800062aa:	c92080e7          	jalr	-878(ra) # 80004f38 <end_op>
    return -1;
    800062ae:	57fd                	li	a5,-1
    800062b0:	a83d                	j	800062ee <sys_link+0x13c>
    iunlockput(dp);
    800062b2:	854a                	mv	a0,s2
    800062b4:	ffffe097          	auipc	ra,0xffffe
    800062b8:	48c080e7          	jalr	1164(ra) # 80004740 <iunlockput>
  ilock(ip);
    800062bc:	8526                	mv	a0,s1
    800062be:	ffffe097          	auipc	ra,0xffffe
    800062c2:	220080e7          	jalr	544(ra) # 800044de <ilock>
  ip->nlink--;
    800062c6:	04a4d783          	lhu	a5,74(s1)
    800062ca:	37fd                	addiw	a5,a5,-1
    800062cc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800062d0:	8526                	mv	a0,s1
    800062d2:	ffffe097          	auipc	ra,0xffffe
    800062d6:	142080e7          	jalr	322(ra) # 80004414 <iupdate>
  iunlockput(ip);
    800062da:	8526                	mv	a0,s1
    800062dc:	ffffe097          	auipc	ra,0xffffe
    800062e0:	464080e7          	jalr	1124(ra) # 80004740 <iunlockput>
  end_op();
    800062e4:	fffff097          	auipc	ra,0xfffff
    800062e8:	c54080e7          	jalr	-940(ra) # 80004f38 <end_op>
  return -1;
    800062ec:	57fd                	li	a5,-1
}
    800062ee:	853e                	mv	a0,a5
    800062f0:	70b2                	ld	ra,296(sp)
    800062f2:	7412                	ld	s0,288(sp)
    800062f4:	64f2                	ld	s1,280(sp)
    800062f6:	6952                	ld	s2,272(sp)
    800062f8:	6155                	addi	sp,sp,304
    800062fa:	8082                	ret

00000000800062fc <sys_unlink>:
{
    800062fc:	7151                	addi	sp,sp,-240
    800062fe:	f586                	sd	ra,232(sp)
    80006300:	f1a2                	sd	s0,224(sp)
    80006302:	eda6                	sd	s1,216(sp)
    80006304:	e9ca                	sd	s2,208(sp)
    80006306:	e5ce                	sd	s3,200(sp)
    80006308:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000630a:	08000613          	li	a2,128
    8000630e:	f3040593          	addi	a1,s0,-208
    80006312:	4501                	li	a0,0
    80006314:	ffffd097          	auipc	ra,0xffffd
    80006318:	436080e7          	jalr	1078(ra) # 8000374a <argstr>
    8000631c:	18054163          	bltz	a0,8000649e <sys_unlink+0x1a2>
  begin_op();
    80006320:	fffff097          	auipc	ra,0xfffff
    80006324:	b98080e7          	jalr	-1128(ra) # 80004eb8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80006328:	fb040593          	addi	a1,s0,-80
    8000632c:	f3040513          	addi	a0,s0,-208
    80006330:	fffff097          	auipc	ra,0xfffff
    80006334:	986080e7          	jalr	-1658(ra) # 80004cb6 <nameiparent>
    80006338:	84aa                	mv	s1,a0
    8000633a:	c979                	beqz	a0,80006410 <sys_unlink+0x114>
  ilock(dp);
    8000633c:	ffffe097          	auipc	ra,0xffffe
    80006340:	1a2080e7          	jalr	418(ra) # 800044de <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80006344:	00003597          	auipc	a1,0x3
    80006348:	4ec58593          	addi	a1,a1,1260 # 80009830 <syscalls+0x330>
    8000634c:	fb040513          	addi	a0,s0,-80
    80006350:	ffffe097          	auipc	ra,0xffffe
    80006354:	658080e7          	jalr	1624(ra) # 800049a8 <namecmp>
    80006358:	14050a63          	beqz	a0,800064ac <sys_unlink+0x1b0>
    8000635c:	00003597          	auipc	a1,0x3
    80006360:	4dc58593          	addi	a1,a1,1244 # 80009838 <syscalls+0x338>
    80006364:	fb040513          	addi	a0,s0,-80
    80006368:	ffffe097          	auipc	ra,0xffffe
    8000636c:	640080e7          	jalr	1600(ra) # 800049a8 <namecmp>
    80006370:	12050e63          	beqz	a0,800064ac <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80006374:	f2c40613          	addi	a2,s0,-212
    80006378:	fb040593          	addi	a1,s0,-80
    8000637c:	8526                	mv	a0,s1
    8000637e:	ffffe097          	auipc	ra,0xffffe
    80006382:	644080e7          	jalr	1604(ra) # 800049c2 <dirlookup>
    80006386:	892a                	mv	s2,a0
    80006388:	12050263          	beqz	a0,800064ac <sys_unlink+0x1b0>
  ilock(ip);
    8000638c:	ffffe097          	auipc	ra,0xffffe
    80006390:	152080e7          	jalr	338(ra) # 800044de <ilock>
  if(ip->nlink < 1)
    80006394:	04a91783          	lh	a5,74(s2)
    80006398:	08f05263          	blez	a5,8000641c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000639c:	04491703          	lh	a4,68(s2)
    800063a0:	4785                	li	a5,1
    800063a2:	08f70563          	beq	a4,a5,8000642c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800063a6:	4641                	li	a2,16
    800063a8:	4581                	li	a1,0
    800063aa:	fc040513          	addi	a0,s0,-64
    800063ae:	ffffb097          	auipc	ra,0xffffb
    800063b2:	91e080e7          	jalr	-1762(ra) # 80000ccc <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800063b6:	4741                	li	a4,16
    800063b8:	f2c42683          	lw	a3,-212(s0)
    800063bc:	fc040613          	addi	a2,s0,-64
    800063c0:	4581                	li	a1,0
    800063c2:	8526                	mv	a0,s1
    800063c4:	ffffe097          	auipc	ra,0xffffe
    800063c8:	4c6080e7          	jalr	1222(ra) # 8000488a <writei>
    800063cc:	47c1                	li	a5,16
    800063ce:	0af51563          	bne	a0,a5,80006478 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800063d2:	04491703          	lh	a4,68(s2)
    800063d6:	4785                	li	a5,1
    800063d8:	0af70863          	beq	a4,a5,80006488 <sys_unlink+0x18c>
  iunlockput(dp);
    800063dc:	8526                	mv	a0,s1
    800063de:	ffffe097          	auipc	ra,0xffffe
    800063e2:	362080e7          	jalr	866(ra) # 80004740 <iunlockput>
  ip->nlink--;
    800063e6:	04a95783          	lhu	a5,74(s2)
    800063ea:	37fd                	addiw	a5,a5,-1
    800063ec:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800063f0:	854a                	mv	a0,s2
    800063f2:	ffffe097          	auipc	ra,0xffffe
    800063f6:	022080e7          	jalr	34(ra) # 80004414 <iupdate>
  iunlockput(ip);
    800063fa:	854a                	mv	a0,s2
    800063fc:	ffffe097          	auipc	ra,0xffffe
    80006400:	344080e7          	jalr	836(ra) # 80004740 <iunlockput>
  end_op();
    80006404:	fffff097          	auipc	ra,0xfffff
    80006408:	b34080e7          	jalr	-1228(ra) # 80004f38 <end_op>
  return 0;
    8000640c:	4501                	li	a0,0
    8000640e:	a84d                	j	800064c0 <sys_unlink+0x1c4>
    end_op();
    80006410:	fffff097          	auipc	ra,0xfffff
    80006414:	b28080e7          	jalr	-1240(ra) # 80004f38 <end_op>
    return -1;
    80006418:	557d                	li	a0,-1
    8000641a:	a05d                	j	800064c0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000641c:	00003517          	auipc	a0,0x3
    80006420:	44450513          	addi	a0,a0,1092 # 80009860 <syscalls+0x360>
    80006424:	ffffa097          	auipc	ra,0xffffa
    80006428:	106080e7          	jalr	262(ra) # 8000052a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000642c:	04c92703          	lw	a4,76(s2)
    80006430:	02000793          	li	a5,32
    80006434:	f6e7f9e3          	bgeu	a5,a4,800063a6 <sys_unlink+0xaa>
    80006438:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000643c:	4741                	li	a4,16
    8000643e:	86ce                	mv	a3,s3
    80006440:	f1840613          	addi	a2,s0,-232
    80006444:	4581                	li	a1,0
    80006446:	854a                	mv	a0,s2
    80006448:	ffffe097          	auipc	ra,0xffffe
    8000644c:	34a080e7          	jalr	842(ra) # 80004792 <readi>
    80006450:	47c1                	li	a5,16
    80006452:	00f51b63          	bne	a0,a5,80006468 <sys_unlink+0x16c>
    if(de.inum != 0)
    80006456:	f1845783          	lhu	a5,-232(s0)
    8000645a:	e7a1                	bnez	a5,800064a2 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000645c:	29c1                	addiw	s3,s3,16
    8000645e:	04c92783          	lw	a5,76(s2)
    80006462:	fcf9ede3          	bltu	s3,a5,8000643c <sys_unlink+0x140>
    80006466:	b781                	j	800063a6 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80006468:	00003517          	auipc	a0,0x3
    8000646c:	41050513          	addi	a0,a0,1040 # 80009878 <syscalls+0x378>
    80006470:	ffffa097          	auipc	ra,0xffffa
    80006474:	0ba080e7          	jalr	186(ra) # 8000052a <panic>
    panic("unlink: writei");
    80006478:	00003517          	auipc	a0,0x3
    8000647c:	41850513          	addi	a0,a0,1048 # 80009890 <syscalls+0x390>
    80006480:	ffffa097          	auipc	ra,0xffffa
    80006484:	0aa080e7          	jalr	170(ra) # 8000052a <panic>
    dp->nlink--;
    80006488:	04a4d783          	lhu	a5,74(s1)
    8000648c:	37fd                	addiw	a5,a5,-1
    8000648e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80006492:	8526                	mv	a0,s1
    80006494:	ffffe097          	auipc	ra,0xffffe
    80006498:	f80080e7          	jalr	-128(ra) # 80004414 <iupdate>
    8000649c:	b781                	j	800063dc <sys_unlink+0xe0>
    return -1;
    8000649e:	557d                	li	a0,-1
    800064a0:	a005                	j	800064c0 <sys_unlink+0x1c4>
    iunlockput(ip);
    800064a2:	854a                	mv	a0,s2
    800064a4:	ffffe097          	auipc	ra,0xffffe
    800064a8:	29c080e7          	jalr	668(ra) # 80004740 <iunlockput>
  iunlockput(dp);
    800064ac:	8526                	mv	a0,s1
    800064ae:	ffffe097          	auipc	ra,0xffffe
    800064b2:	292080e7          	jalr	658(ra) # 80004740 <iunlockput>
  end_op();
    800064b6:	fffff097          	auipc	ra,0xfffff
    800064ba:	a82080e7          	jalr	-1406(ra) # 80004f38 <end_op>
  return -1;
    800064be:	557d                	li	a0,-1
}
    800064c0:	70ae                	ld	ra,232(sp)
    800064c2:	740e                	ld	s0,224(sp)
    800064c4:	64ee                	ld	s1,216(sp)
    800064c6:	694e                	ld	s2,208(sp)
    800064c8:	69ae                	ld	s3,200(sp)
    800064ca:	616d                	addi	sp,sp,240
    800064cc:	8082                	ret

00000000800064ce <sys_open>:

uint64
sys_open(void)
{
    800064ce:	7131                	addi	sp,sp,-192
    800064d0:	fd06                	sd	ra,184(sp)
    800064d2:	f922                	sd	s0,176(sp)
    800064d4:	f526                	sd	s1,168(sp)
    800064d6:	f14a                	sd	s2,160(sp)
    800064d8:	ed4e                	sd	s3,152(sp)
    800064da:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800064dc:	08000613          	li	a2,128
    800064e0:	f5040593          	addi	a1,s0,-176
    800064e4:	4501                	li	a0,0
    800064e6:	ffffd097          	auipc	ra,0xffffd
    800064ea:	264080e7          	jalr	612(ra) # 8000374a <argstr>
    return -1;
    800064ee:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800064f0:	0c054163          	bltz	a0,800065b2 <sys_open+0xe4>
    800064f4:	f4c40593          	addi	a1,s0,-180
    800064f8:	4505                	li	a0,1
    800064fa:	ffffd097          	auipc	ra,0xffffd
    800064fe:	20c080e7          	jalr	524(ra) # 80003706 <argint>
    80006502:	0a054863          	bltz	a0,800065b2 <sys_open+0xe4>

  begin_op();
    80006506:	fffff097          	auipc	ra,0xfffff
    8000650a:	9b2080e7          	jalr	-1614(ra) # 80004eb8 <begin_op>

  if(omode & O_CREATE){
    8000650e:	f4c42783          	lw	a5,-180(s0)
    80006512:	2007f793          	andi	a5,a5,512
    80006516:	cbdd                	beqz	a5,800065cc <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80006518:	4681                	li	a3,0
    8000651a:	4601                	li	a2,0
    8000651c:	4589                	li	a1,2
    8000651e:	f5040513          	addi	a0,s0,-176
    80006522:	00000097          	auipc	ra,0x0
    80006526:	972080e7          	jalr	-1678(ra) # 80005e94 <create>
    8000652a:	892a                	mv	s2,a0
    if(ip == 0){
    8000652c:	c959                	beqz	a0,800065c2 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000652e:	04491703          	lh	a4,68(s2)
    80006532:	478d                	li	a5,3
    80006534:	00f71763          	bne	a4,a5,80006542 <sys_open+0x74>
    80006538:	04695703          	lhu	a4,70(s2)
    8000653c:	47a5                	li	a5,9
    8000653e:	0ce7ec63          	bltu	a5,a4,80006616 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80006542:	fffff097          	auipc	ra,0xfffff
    80006546:	d86080e7          	jalr	-634(ra) # 800052c8 <filealloc>
    8000654a:	89aa                	mv	s3,a0
    8000654c:	10050263          	beqz	a0,80006650 <sys_open+0x182>
    80006550:	00000097          	auipc	ra,0x0
    80006554:	8fe080e7          	jalr	-1794(ra) # 80005e4e <fdalloc>
    80006558:	84aa                	mv	s1,a0
    8000655a:	0e054663          	bltz	a0,80006646 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000655e:	04491703          	lh	a4,68(s2)
    80006562:	478d                	li	a5,3
    80006564:	0cf70463          	beq	a4,a5,8000662c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80006568:	4789                	li	a5,2
    8000656a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000656e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80006572:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80006576:	f4c42783          	lw	a5,-180(s0)
    8000657a:	0017c713          	xori	a4,a5,1
    8000657e:	8b05                	andi	a4,a4,1
    80006580:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80006584:	0037f713          	andi	a4,a5,3
    80006588:	00e03733          	snez	a4,a4
    8000658c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80006590:	4007f793          	andi	a5,a5,1024
    80006594:	c791                	beqz	a5,800065a0 <sys_open+0xd2>
    80006596:	04491703          	lh	a4,68(s2)
    8000659a:	4789                	li	a5,2
    8000659c:	08f70f63          	beq	a4,a5,8000663a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    800065a0:	854a                	mv	a0,s2
    800065a2:	ffffe097          	auipc	ra,0xffffe
    800065a6:	ffe080e7          	jalr	-2(ra) # 800045a0 <iunlock>
  end_op();
    800065aa:	fffff097          	auipc	ra,0xfffff
    800065ae:	98e080e7          	jalr	-1650(ra) # 80004f38 <end_op>

  return fd;
}
    800065b2:	8526                	mv	a0,s1
    800065b4:	70ea                	ld	ra,184(sp)
    800065b6:	744a                	ld	s0,176(sp)
    800065b8:	74aa                	ld	s1,168(sp)
    800065ba:	790a                	ld	s2,160(sp)
    800065bc:	69ea                	ld	s3,152(sp)
    800065be:	6129                	addi	sp,sp,192
    800065c0:	8082                	ret
      end_op();
    800065c2:	fffff097          	auipc	ra,0xfffff
    800065c6:	976080e7          	jalr	-1674(ra) # 80004f38 <end_op>
      return -1;
    800065ca:	b7e5                	j	800065b2 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    800065cc:	f5040513          	addi	a0,s0,-176
    800065d0:	ffffe097          	auipc	ra,0xffffe
    800065d4:	6c8080e7          	jalr	1736(ra) # 80004c98 <namei>
    800065d8:	892a                	mv	s2,a0
    800065da:	c905                	beqz	a0,8000660a <sys_open+0x13c>
    ilock(ip);
    800065dc:	ffffe097          	auipc	ra,0xffffe
    800065e0:	f02080e7          	jalr	-254(ra) # 800044de <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800065e4:	04491703          	lh	a4,68(s2)
    800065e8:	4785                	li	a5,1
    800065ea:	f4f712e3          	bne	a4,a5,8000652e <sys_open+0x60>
    800065ee:	f4c42783          	lw	a5,-180(s0)
    800065f2:	dba1                	beqz	a5,80006542 <sys_open+0x74>
      iunlockput(ip);
    800065f4:	854a                	mv	a0,s2
    800065f6:	ffffe097          	auipc	ra,0xffffe
    800065fa:	14a080e7          	jalr	330(ra) # 80004740 <iunlockput>
      end_op();
    800065fe:	fffff097          	auipc	ra,0xfffff
    80006602:	93a080e7          	jalr	-1734(ra) # 80004f38 <end_op>
      return -1;
    80006606:	54fd                	li	s1,-1
    80006608:	b76d                	j	800065b2 <sys_open+0xe4>
      end_op();
    8000660a:	fffff097          	auipc	ra,0xfffff
    8000660e:	92e080e7          	jalr	-1746(ra) # 80004f38 <end_op>
      return -1;
    80006612:	54fd                	li	s1,-1
    80006614:	bf79                	j	800065b2 <sys_open+0xe4>
    iunlockput(ip);
    80006616:	854a                	mv	a0,s2
    80006618:	ffffe097          	auipc	ra,0xffffe
    8000661c:	128080e7          	jalr	296(ra) # 80004740 <iunlockput>
    end_op();
    80006620:	fffff097          	auipc	ra,0xfffff
    80006624:	918080e7          	jalr	-1768(ra) # 80004f38 <end_op>
    return -1;
    80006628:	54fd                	li	s1,-1
    8000662a:	b761                	j	800065b2 <sys_open+0xe4>
    f->type = FD_DEVICE;
    8000662c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80006630:	04691783          	lh	a5,70(s2)
    80006634:	02f99223          	sh	a5,36(s3)
    80006638:	bf2d                	j	80006572 <sys_open+0xa4>
    itrunc(ip);
    8000663a:	854a                	mv	a0,s2
    8000663c:	ffffe097          	auipc	ra,0xffffe
    80006640:	fb0080e7          	jalr	-80(ra) # 800045ec <itrunc>
    80006644:	bfb1                	j	800065a0 <sys_open+0xd2>
      fileclose(f);
    80006646:	854e                	mv	a0,s3
    80006648:	fffff097          	auipc	ra,0xfffff
    8000664c:	d3c080e7          	jalr	-708(ra) # 80005384 <fileclose>
    iunlockput(ip);
    80006650:	854a                	mv	a0,s2
    80006652:	ffffe097          	auipc	ra,0xffffe
    80006656:	0ee080e7          	jalr	238(ra) # 80004740 <iunlockput>
    end_op();
    8000665a:	fffff097          	auipc	ra,0xfffff
    8000665e:	8de080e7          	jalr	-1826(ra) # 80004f38 <end_op>
    return -1;
    80006662:	54fd                	li	s1,-1
    80006664:	b7b9                	j	800065b2 <sys_open+0xe4>

0000000080006666 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80006666:	7175                	addi	sp,sp,-144
    80006668:	e506                	sd	ra,136(sp)
    8000666a:	e122                	sd	s0,128(sp)
    8000666c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000666e:	fffff097          	auipc	ra,0xfffff
    80006672:	84a080e7          	jalr	-1974(ra) # 80004eb8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80006676:	08000613          	li	a2,128
    8000667a:	f7040593          	addi	a1,s0,-144
    8000667e:	4501                	li	a0,0
    80006680:	ffffd097          	auipc	ra,0xffffd
    80006684:	0ca080e7          	jalr	202(ra) # 8000374a <argstr>
    80006688:	02054963          	bltz	a0,800066ba <sys_mkdir+0x54>
    8000668c:	4681                	li	a3,0
    8000668e:	4601                	li	a2,0
    80006690:	4585                	li	a1,1
    80006692:	f7040513          	addi	a0,s0,-144
    80006696:	fffff097          	auipc	ra,0xfffff
    8000669a:	7fe080e7          	jalr	2046(ra) # 80005e94 <create>
    8000669e:	cd11                	beqz	a0,800066ba <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800066a0:	ffffe097          	auipc	ra,0xffffe
    800066a4:	0a0080e7          	jalr	160(ra) # 80004740 <iunlockput>
  end_op();
    800066a8:	fffff097          	auipc	ra,0xfffff
    800066ac:	890080e7          	jalr	-1904(ra) # 80004f38 <end_op>
  return 0;
    800066b0:	4501                	li	a0,0
}
    800066b2:	60aa                	ld	ra,136(sp)
    800066b4:	640a                	ld	s0,128(sp)
    800066b6:	6149                	addi	sp,sp,144
    800066b8:	8082                	ret
    end_op();
    800066ba:	fffff097          	auipc	ra,0xfffff
    800066be:	87e080e7          	jalr	-1922(ra) # 80004f38 <end_op>
    return -1;
    800066c2:	557d                	li	a0,-1
    800066c4:	b7fd                	j	800066b2 <sys_mkdir+0x4c>

00000000800066c6 <sys_mknod>:

uint64
sys_mknod(void)
{
    800066c6:	7135                	addi	sp,sp,-160
    800066c8:	ed06                	sd	ra,152(sp)
    800066ca:	e922                	sd	s0,144(sp)
    800066cc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800066ce:	ffffe097          	auipc	ra,0xffffe
    800066d2:	7ea080e7          	jalr	2026(ra) # 80004eb8 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800066d6:	08000613          	li	a2,128
    800066da:	f7040593          	addi	a1,s0,-144
    800066de:	4501                	li	a0,0
    800066e0:	ffffd097          	auipc	ra,0xffffd
    800066e4:	06a080e7          	jalr	106(ra) # 8000374a <argstr>
    800066e8:	04054a63          	bltz	a0,8000673c <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    800066ec:	f6c40593          	addi	a1,s0,-148
    800066f0:	4505                	li	a0,1
    800066f2:	ffffd097          	auipc	ra,0xffffd
    800066f6:	014080e7          	jalr	20(ra) # 80003706 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800066fa:	04054163          	bltz	a0,8000673c <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    800066fe:	f6840593          	addi	a1,s0,-152
    80006702:	4509                	li	a0,2
    80006704:	ffffd097          	auipc	ra,0xffffd
    80006708:	002080e7          	jalr	2(ra) # 80003706 <argint>
     argint(1, &major) < 0 ||
    8000670c:	02054863          	bltz	a0,8000673c <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80006710:	f6841683          	lh	a3,-152(s0)
    80006714:	f6c41603          	lh	a2,-148(s0)
    80006718:	458d                	li	a1,3
    8000671a:	f7040513          	addi	a0,s0,-144
    8000671e:	fffff097          	auipc	ra,0xfffff
    80006722:	776080e7          	jalr	1910(ra) # 80005e94 <create>
     argint(2, &minor) < 0 ||
    80006726:	c919                	beqz	a0,8000673c <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006728:	ffffe097          	auipc	ra,0xffffe
    8000672c:	018080e7          	jalr	24(ra) # 80004740 <iunlockput>
  end_op();
    80006730:	fffff097          	auipc	ra,0xfffff
    80006734:	808080e7          	jalr	-2040(ra) # 80004f38 <end_op>
  return 0;
    80006738:	4501                	li	a0,0
    8000673a:	a031                	j	80006746 <sys_mknod+0x80>
    end_op();
    8000673c:	ffffe097          	auipc	ra,0xffffe
    80006740:	7fc080e7          	jalr	2044(ra) # 80004f38 <end_op>
    return -1;
    80006744:	557d                	li	a0,-1
}
    80006746:	60ea                	ld	ra,152(sp)
    80006748:	644a                	ld	s0,144(sp)
    8000674a:	610d                	addi	sp,sp,160
    8000674c:	8082                	ret

000000008000674e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000674e:	7135                	addi	sp,sp,-160
    80006750:	ed06                	sd	ra,152(sp)
    80006752:	e922                	sd	s0,144(sp)
    80006754:	e526                	sd	s1,136(sp)
    80006756:	e14a                	sd	s2,128(sp)
    80006758:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000675a:	ffffb097          	auipc	ra,0xffffb
    8000675e:	29e080e7          	jalr	670(ra) # 800019f8 <myproc>
    80006762:	892a                	mv	s2,a0
  
  begin_op();
    80006764:	ffffe097          	auipc	ra,0xffffe
    80006768:	754080e7          	jalr	1876(ra) # 80004eb8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000676c:	08000613          	li	a2,128
    80006770:	f6040593          	addi	a1,s0,-160
    80006774:	4501                	li	a0,0
    80006776:	ffffd097          	auipc	ra,0xffffd
    8000677a:	fd4080e7          	jalr	-44(ra) # 8000374a <argstr>
    8000677e:	04054d63          	bltz	a0,800067d8 <sys_chdir+0x8a>
    80006782:	f6040513          	addi	a0,s0,-160
    80006786:	ffffe097          	auipc	ra,0xffffe
    8000678a:	512080e7          	jalr	1298(ra) # 80004c98 <namei>
    8000678e:	84aa                	mv	s1,a0
    80006790:	c521                	beqz	a0,800067d8 <sys_chdir+0x8a>
    end_op();
    return -1;
  }
  ilock(ip);
    80006792:	ffffe097          	auipc	ra,0xffffe
    80006796:	d4c080e7          	jalr	-692(ra) # 800044de <ilock>
  if(ip->type != T_DIR){
    8000679a:	04449703          	lh	a4,68(s1)
    8000679e:	4785                	li	a5,1
    800067a0:	04f71263          	bne	a4,a5,800067e4 <sys_chdir+0x96>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800067a4:	8526                	mv	a0,s1
    800067a6:	ffffe097          	auipc	ra,0xffffe
    800067aa:	dfa080e7          	jalr	-518(ra) # 800045a0 <iunlock>
  iput(p->cwd);
    800067ae:	6505                	lui	a0,0x1
    800067b0:	992a                	add	s2,s2,a0
    800067b2:	fc893503          	ld	a0,-56(s2)
    800067b6:	ffffe097          	auipc	ra,0xffffe
    800067ba:	ee2080e7          	jalr	-286(ra) # 80004698 <iput>
  end_op();
    800067be:	ffffe097          	auipc	ra,0xffffe
    800067c2:	77a080e7          	jalr	1914(ra) # 80004f38 <end_op>
  p->cwd = ip;
    800067c6:	fc993423          	sd	s1,-56(s2)
  return 0;
    800067ca:	4501                	li	a0,0
}
    800067cc:	60ea                	ld	ra,152(sp)
    800067ce:	644a                	ld	s0,144(sp)
    800067d0:	64aa                	ld	s1,136(sp)
    800067d2:	690a                	ld	s2,128(sp)
    800067d4:	610d                	addi	sp,sp,160
    800067d6:	8082                	ret
    end_op();
    800067d8:	ffffe097          	auipc	ra,0xffffe
    800067dc:	760080e7          	jalr	1888(ra) # 80004f38 <end_op>
    return -1;
    800067e0:	557d                	li	a0,-1
    800067e2:	b7ed                	j	800067cc <sys_chdir+0x7e>
    iunlockput(ip);
    800067e4:	8526                	mv	a0,s1
    800067e6:	ffffe097          	auipc	ra,0xffffe
    800067ea:	f5a080e7          	jalr	-166(ra) # 80004740 <iunlockput>
    end_op();
    800067ee:	ffffe097          	auipc	ra,0xffffe
    800067f2:	74a080e7          	jalr	1866(ra) # 80004f38 <end_op>
    return -1;
    800067f6:	557d                	li	a0,-1
    800067f8:	bfd1                	j	800067cc <sys_chdir+0x7e>

00000000800067fa <sys_exec>:

uint64
sys_exec(void)
{
    800067fa:	7145                	addi	sp,sp,-464
    800067fc:	e786                	sd	ra,456(sp)
    800067fe:	e3a2                	sd	s0,448(sp)
    80006800:	ff26                	sd	s1,440(sp)
    80006802:	fb4a                	sd	s2,432(sp)
    80006804:	f74e                	sd	s3,424(sp)
    80006806:	f352                	sd	s4,416(sp)
    80006808:	ef56                	sd	s5,408(sp)
    8000680a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000680c:	08000613          	li	a2,128
    80006810:	f4040593          	addi	a1,s0,-192
    80006814:	4501                	li	a0,0
    80006816:	ffffd097          	auipc	ra,0xffffd
    8000681a:	f34080e7          	jalr	-204(ra) # 8000374a <argstr>
    return -1;
    8000681e:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80006820:	0c054a63          	bltz	a0,800068f4 <sys_exec+0xfa>
    80006824:	e3840593          	addi	a1,s0,-456
    80006828:	4505                	li	a0,1
    8000682a:	ffffd097          	auipc	ra,0xffffd
    8000682e:	efe080e7          	jalr	-258(ra) # 80003728 <argaddr>
    80006832:	0c054163          	bltz	a0,800068f4 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80006836:	10000613          	li	a2,256
    8000683a:	4581                	li	a1,0
    8000683c:	e4040513          	addi	a0,s0,-448
    80006840:	ffffa097          	auipc	ra,0xffffa
    80006844:	48c080e7          	jalr	1164(ra) # 80000ccc <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80006848:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000684c:	89a6                	mv	s3,s1
    8000684e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80006850:	02000a13          	li	s4,32
    80006854:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006858:	00391793          	slli	a5,s2,0x3
    8000685c:	e3040593          	addi	a1,s0,-464
    80006860:	e3843503          	ld	a0,-456(s0)
    80006864:	953e                	add	a0,a0,a5
    80006866:	ffffd097          	auipc	ra,0xffffd
    8000686a:	df4080e7          	jalr	-524(ra) # 8000365a <fetchaddr>
    8000686e:	02054a63          	bltz	a0,800068a2 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80006872:	e3043783          	ld	a5,-464(s0)
    80006876:	c3b9                	beqz	a5,800068bc <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80006878:	ffffa097          	auipc	ra,0xffffa
    8000687c:	25a080e7          	jalr	602(ra) # 80000ad2 <kalloc>
    80006880:	85aa                	mv	a1,a0
    80006882:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80006886:	cd11                	beqz	a0,800068a2 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006888:	6605                	lui	a2,0x1
    8000688a:	e3043503          	ld	a0,-464(s0)
    8000688e:	ffffd097          	auipc	ra,0xffffd
    80006892:	e2a080e7          	jalr	-470(ra) # 800036b8 <fetchstr>
    80006896:	00054663          	bltz	a0,800068a2 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000689a:	0905                	addi	s2,s2,1
    8000689c:	09a1                	addi	s3,s3,8
    8000689e:	fb491be3          	bne	s2,s4,80006854 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800068a2:	10048913          	addi	s2,s1,256
    800068a6:	6088                	ld	a0,0(s1)
    800068a8:	c529                	beqz	a0,800068f2 <sys_exec+0xf8>
    kfree(argv[i]);
    800068aa:	ffffa097          	auipc	ra,0xffffa
    800068ae:	12c080e7          	jalr	300(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800068b2:	04a1                	addi	s1,s1,8
    800068b4:	ff2499e3          	bne	s1,s2,800068a6 <sys_exec+0xac>
  return -1;
    800068b8:	597d                	li	s2,-1
    800068ba:	a82d                	j	800068f4 <sys_exec+0xfa>
      argv[i] = 0;
    800068bc:	0a8e                	slli	s5,s5,0x3
    800068be:	fc040793          	addi	a5,s0,-64
    800068c2:	9abe                	add	s5,s5,a5
    800068c4:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800068c8:	e4040593          	addi	a1,s0,-448
    800068cc:	f4040513          	addi	a0,s0,-192
    800068d0:	fffff097          	auipc	ra,0xfffff
    800068d4:	11a080e7          	jalr	282(ra) # 800059ea <exec>
    800068d8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800068da:	10048993          	addi	s3,s1,256
    800068de:	6088                	ld	a0,0(s1)
    800068e0:	c911                	beqz	a0,800068f4 <sys_exec+0xfa>
    kfree(argv[i]);
    800068e2:	ffffa097          	auipc	ra,0xffffa
    800068e6:	0f4080e7          	jalr	244(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800068ea:	04a1                	addi	s1,s1,8
    800068ec:	ff3499e3          	bne	s1,s3,800068de <sys_exec+0xe4>
    800068f0:	a011                	j	800068f4 <sys_exec+0xfa>
  return -1;
    800068f2:	597d                	li	s2,-1
}
    800068f4:	854a                	mv	a0,s2
    800068f6:	60be                	ld	ra,456(sp)
    800068f8:	641e                	ld	s0,448(sp)
    800068fa:	74fa                	ld	s1,440(sp)
    800068fc:	795a                	ld	s2,432(sp)
    800068fe:	79ba                	ld	s3,424(sp)
    80006900:	7a1a                	ld	s4,416(sp)
    80006902:	6afa                	ld	s5,408(sp)
    80006904:	6179                	addi	sp,sp,464
    80006906:	8082                	ret

0000000080006908 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006908:	7139                	addi	sp,sp,-64
    8000690a:	fc06                	sd	ra,56(sp)
    8000690c:	f822                	sd	s0,48(sp)
    8000690e:	f426                	sd	s1,40(sp)
    80006910:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006912:	ffffb097          	auipc	ra,0xffffb
    80006916:	0e6080e7          	jalr	230(ra) # 800019f8 <myproc>
    8000691a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000691c:	fd840593          	addi	a1,s0,-40
    80006920:	4501                	li	a0,0
    80006922:	ffffd097          	auipc	ra,0xffffd
    80006926:	e06080e7          	jalr	-506(ra) # 80003728 <argaddr>
    return -1;
    8000692a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000692c:	0e054863          	bltz	a0,80006a1c <sys_pipe+0x114>
  if(pipealloc(&rf, &wf) < 0)
    80006930:	fc840593          	addi	a1,s0,-56
    80006934:	fd040513          	addi	a0,s0,-48
    80006938:	fffff097          	auipc	ra,0xfffff
    8000693c:	d80080e7          	jalr	-640(ra) # 800056b8 <pipealloc>
    return -1;
    80006940:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006942:	0c054d63          	bltz	a0,80006a1c <sys_pipe+0x114>
  fd0 = -1;
    80006946:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000694a:	fd043503          	ld	a0,-48(s0)
    8000694e:	fffff097          	auipc	ra,0xfffff
    80006952:	500080e7          	jalr	1280(ra) # 80005e4e <fdalloc>
    80006956:	fca42223          	sw	a0,-60(s0)
    8000695a:	0a054463          	bltz	a0,80006a02 <sys_pipe+0xfa>
    8000695e:	fc843503          	ld	a0,-56(s0)
    80006962:	fffff097          	auipc	ra,0xfffff
    80006966:	4ec080e7          	jalr	1260(ra) # 80005e4e <fdalloc>
    8000696a:	fca42023          	sw	a0,-64(s0)
    8000696e:	08054063          	bltz	a0,800069ee <sys_pipe+0xe6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006972:	6785                	lui	a5,0x1
    80006974:	97a6                	add	a5,a5,s1
    80006976:	4691                	li	a3,4
    80006978:	fc440613          	addi	a2,s0,-60
    8000697c:	fd843583          	ld	a1,-40(s0)
    80006980:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80006984:	ffffb097          	auipc	ra,0xffffb
    80006988:	cc8080e7          	jalr	-824(ra) # 8000164c <copyout>
    8000698c:	02054363          	bltz	a0,800069b2 <sys_pipe+0xaa>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006990:	6785                	lui	a5,0x1
    80006992:	97a6                	add	a5,a5,s1
    80006994:	4691                	li	a3,4
    80006996:	fc040613          	addi	a2,s0,-64
    8000699a:	fd843583          	ld	a1,-40(s0)
    8000699e:	0591                	addi	a1,a1,4
    800069a0:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    800069a4:	ffffb097          	auipc	ra,0xffffb
    800069a8:	ca8080e7          	jalr	-856(ra) # 8000164c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800069ac:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800069ae:	06055763          	bgez	a0,80006a1c <sys_pipe+0x114>
    p->ofile[fd0] = 0;
    800069b2:	fc442783          	lw	a5,-60(s0)
    800069b6:	1e878793          	addi	a5,a5,488
    800069ba:	078e                	slli	a5,a5,0x3
    800069bc:	97a6                	add	a5,a5,s1
    800069be:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800069c2:	fc042503          	lw	a0,-64(s0)
    800069c6:	1e850513          	addi	a0,a0,488 # 11e8 <_entry-0x7fffee18>
    800069ca:	050e                	slli	a0,a0,0x3
    800069cc:	9526                	add	a0,a0,s1
    800069ce:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800069d2:	fd043503          	ld	a0,-48(s0)
    800069d6:	fffff097          	auipc	ra,0xfffff
    800069da:	9ae080e7          	jalr	-1618(ra) # 80005384 <fileclose>
    fileclose(wf);
    800069de:	fc843503          	ld	a0,-56(s0)
    800069e2:	fffff097          	auipc	ra,0xfffff
    800069e6:	9a2080e7          	jalr	-1630(ra) # 80005384 <fileclose>
    return -1;
    800069ea:	57fd                	li	a5,-1
    800069ec:	a805                	j	80006a1c <sys_pipe+0x114>
    if(fd0 >= 0)
    800069ee:	fc442783          	lw	a5,-60(s0)
    800069f2:	0007c863          	bltz	a5,80006a02 <sys_pipe+0xfa>
      p->ofile[fd0] = 0;
    800069f6:	1e878513          	addi	a0,a5,488
    800069fa:	050e                	slli	a0,a0,0x3
    800069fc:	9526                	add	a0,a0,s1
    800069fe:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80006a02:	fd043503          	ld	a0,-48(s0)
    80006a06:	fffff097          	auipc	ra,0xfffff
    80006a0a:	97e080e7          	jalr	-1666(ra) # 80005384 <fileclose>
    fileclose(wf);
    80006a0e:	fc843503          	ld	a0,-56(s0)
    80006a12:	fffff097          	auipc	ra,0xfffff
    80006a16:	972080e7          	jalr	-1678(ra) # 80005384 <fileclose>
    return -1;
    80006a1a:	57fd                	li	a5,-1
}
    80006a1c:	853e                	mv	a0,a5
    80006a1e:	70e2                	ld	ra,56(sp)
    80006a20:	7442                	ld	s0,48(sp)
    80006a22:	74a2                	ld	s1,40(sp)
    80006a24:	6121                	addi	sp,sp,64
    80006a26:	8082                	ret
	...

0000000080006a30 <kernelvec>:
    80006a30:	7111                	addi	sp,sp,-256
    80006a32:	e006                	sd	ra,0(sp)
    80006a34:	e40a                	sd	sp,8(sp)
    80006a36:	e80e                	sd	gp,16(sp)
    80006a38:	ec12                	sd	tp,24(sp)
    80006a3a:	f016                	sd	t0,32(sp)
    80006a3c:	f41a                	sd	t1,40(sp)
    80006a3e:	f81e                	sd	t2,48(sp)
    80006a40:	fc22                	sd	s0,56(sp)
    80006a42:	e0a6                	sd	s1,64(sp)
    80006a44:	e4aa                	sd	a0,72(sp)
    80006a46:	e8ae                	sd	a1,80(sp)
    80006a48:	ecb2                	sd	a2,88(sp)
    80006a4a:	f0b6                	sd	a3,96(sp)
    80006a4c:	f4ba                	sd	a4,104(sp)
    80006a4e:	f8be                	sd	a5,112(sp)
    80006a50:	fcc2                	sd	a6,120(sp)
    80006a52:	e146                	sd	a7,128(sp)
    80006a54:	e54a                	sd	s2,136(sp)
    80006a56:	e94e                	sd	s3,144(sp)
    80006a58:	ed52                	sd	s4,152(sp)
    80006a5a:	f156                	sd	s5,160(sp)
    80006a5c:	f55a                	sd	s6,168(sp)
    80006a5e:	f95e                	sd	s7,176(sp)
    80006a60:	fd62                	sd	s8,184(sp)
    80006a62:	e1e6                	sd	s9,192(sp)
    80006a64:	e5ea                	sd	s10,200(sp)
    80006a66:	e9ee                	sd	s11,208(sp)
    80006a68:	edf2                	sd	t3,216(sp)
    80006a6a:	f1f6                	sd	t4,224(sp)
    80006a6c:	f5fa                	sd	t5,232(sp)
    80006a6e:	f9fe                	sd	t6,240(sp)
    80006a70:	ab7fc0ef          	jal	ra,80003526 <kerneltrap>
    80006a74:	6082                	ld	ra,0(sp)
    80006a76:	6122                	ld	sp,8(sp)
    80006a78:	61c2                	ld	gp,16(sp)
    80006a7a:	7282                	ld	t0,32(sp)
    80006a7c:	7322                	ld	t1,40(sp)
    80006a7e:	73c2                	ld	t2,48(sp)
    80006a80:	7462                	ld	s0,56(sp)
    80006a82:	6486                	ld	s1,64(sp)
    80006a84:	6526                	ld	a0,72(sp)
    80006a86:	65c6                	ld	a1,80(sp)
    80006a88:	6666                	ld	a2,88(sp)
    80006a8a:	7686                	ld	a3,96(sp)
    80006a8c:	7726                	ld	a4,104(sp)
    80006a8e:	77c6                	ld	a5,112(sp)
    80006a90:	7866                	ld	a6,120(sp)
    80006a92:	688a                	ld	a7,128(sp)
    80006a94:	692a                	ld	s2,136(sp)
    80006a96:	69ca                	ld	s3,144(sp)
    80006a98:	6a6a                	ld	s4,152(sp)
    80006a9a:	7a8a                	ld	s5,160(sp)
    80006a9c:	7b2a                	ld	s6,168(sp)
    80006a9e:	7bca                	ld	s7,176(sp)
    80006aa0:	7c6a                	ld	s8,184(sp)
    80006aa2:	6c8e                	ld	s9,192(sp)
    80006aa4:	6d2e                	ld	s10,200(sp)
    80006aa6:	6dce                	ld	s11,208(sp)
    80006aa8:	6e6e                	ld	t3,216(sp)
    80006aaa:	7e8e                	ld	t4,224(sp)
    80006aac:	7f2e                	ld	t5,232(sp)
    80006aae:	7fce                	ld	t6,240(sp)
    80006ab0:	6111                	addi	sp,sp,256
    80006ab2:	10200073          	sret
    80006ab6:	00000013          	nop
    80006aba:	00000013          	nop
    80006abe:	0001                	nop

0000000080006ac0 <timervec>:
    80006ac0:	34051573          	csrrw	a0,mscratch,a0
    80006ac4:	e10c                	sd	a1,0(a0)
    80006ac6:	e510                	sd	a2,8(a0)
    80006ac8:	e914                	sd	a3,16(a0)
    80006aca:	6d0c                	ld	a1,24(a0)
    80006acc:	7110                	ld	a2,32(a0)
    80006ace:	6194                	ld	a3,0(a1)
    80006ad0:	96b2                	add	a3,a3,a2
    80006ad2:	e194                	sd	a3,0(a1)
    80006ad4:	4589                	li	a1,2
    80006ad6:	14459073          	csrw	sip,a1
    80006ada:	6914                	ld	a3,16(a0)
    80006adc:	6510                	ld	a2,8(a0)
    80006ade:	610c                	ld	a1,0(a0)
    80006ae0:	34051573          	csrrw	a0,mscratch,a0
    80006ae4:	30200073          	mret
	...

0000000080006aea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80006aea:	1141                	addi	sp,sp,-16
    80006aec:	e422                	sd	s0,8(sp)
    80006aee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006af0:	0c0007b7          	lui	a5,0xc000
    80006af4:	4705                	li	a4,1
    80006af6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006af8:	c3d8                	sw	a4,4(a5)
}
    80006afa:	6422                	ld	s0,8(sp)
    80006afc:	0141                	addi	sp,sp,16
    80006afe:	8082                	ret

0000000080006b00 <plicinithart>:

void
plicinithart(void)
{
    80006b00:	1141                	addi	sp,sp,-16
    80006b02:	e406                	sd	ra,8(sp)
    80006b04:	e022                	sd	s0,0(sp)
    80006b06:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006b08:	ffffb097          	auipc	ra,0xffffb
    80006b0c:	ebc080e7          	jalr	-324(ra) # 800019c4 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006b10:	0085171b          	slliw	a4,a0,0x8
    80006b14:	0c0027b7          	lui	a5,0xc002
    80006b18:	97ba                	add	a5,a5,a4
    80006b1a:	40200713          	li	a4,1026
    80006b1e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006b22:	00d5151b          	slliw	a0,a0,0xd
    80006b26:	0c2017b7          	lui	a5,0xc201
    80006b2a:	953e                	add	a0,a0,a5
    80006b2c:	00052023          	sw	zero,0(a0)
}
    80006b30:	60a2                	ld	ra,8(sp)
    80006b32:	6402                	ld	s0,0(sp)
    80006b34:	0141                	addi	sp,sp,16
    80006b36:	8082                	ret

0000000080006b38 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006b38:	1141                	addi	sp,sp,-16
    80006b3a:	e406                	sd	ra,8(sp)
    80006b3c:	e022                	sd	s0,0(sp)
    80006b3e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006b40:	ffffb097          	auipc	ra,0xffffb
    80006b44:	e84080e7          	jalr	-380(ra) # 800019c4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006b48:	00d5179b          	slliw	a5,a0,0xd
    80006b4c:	0c201537          	lui	a0,0xc201
    80006b50:	953e                	add	a0,a0,a5
  return irq;
}
    80006b52:	4148                	lw	a0,4(a0)
    80006b54:	60a2                	ld	ra,8(sp)
    80006b56:	6402                	ld	s0,0(sp)
    80006b58:	0141                	addi	sp,sp,16
    80006b5a:	8082                	ret

0000000080006b5c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006b5c:	1101                	addi	sp,sp,-32
    80006b5e:	ec06                	sd	ra,24(sp)
    80006b60:	e822                	sd	s0,16(sp)
    80006b62:	e426                	sd	s1,8(sp)
    80006b64:	1000                	addi	s0,sp,32
    80006b66:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006b68:	ffffb097          	auipc	ra,0xffffb
    80006b6c:	e5c080e7          	jalr	-420(ra) # 800019c4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006b70:	00d5151b          	slliw	a0,a0,0xd
    80006b74:	0c2017b7          	lui	a5,0xc201
    80006b78:	97aa                	add	a5,a5,a0
    80006b7a:	c3c4                	sw	s1,4(a5)
}
    80006b7c:	60e2                	ld	ra,24(sp)
    80006b7e:	6442                	ld	s0,16(sp)
    80006b80:	64a2                	ld	s1,8(sp)
    80006b82:	6105                	addi	sp,sp,32
    80006b84:	8082                	ret

0000000080006b86 <start_ret>:
    80006b86:	48e1                	li	a7,24
    80006b88:	00000073          	ecall

0000000080006b8c <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006b8c:	1141                	addi	sp,sp,-16
    80006b8e:	e406                	sd	ra,8(sp)
    80006b90:	e022                	sd	s0,0(sp)
    80006b92:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006b94:	479d                	li	a5,7
    80006b96:	06a7c963          	blt	a5,a0,80006c08 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80006b9a:	0005d797          	auipc	a5,0x5d
    80006b9e:	46678793          	addi	a5,a5,1126 # 80064000 <disk>
    80006ba2:	00a78733          	add	a4,a5,a0
    80006ba6:	6789                	lui	a5,0x2
    80006ba8:	97ba                	add	a5,a5,a4
    80006baa:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006bae:	e7ad                	bnez	a5,80006c18 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006bb0:	00451793          	slli	a5,a0,0x4
    80006bb4:	0005f717          	auipc	a4,0x5f
    80006bb8:	44c70713          	addi	a4,a4,1100 # 80066000 <disk+0x2000>
    80006bbc:	6314                	ld	a3,0(a4)
    80006bbe:	96be                	add	a3,a3,a5
    80006bc0:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80006bc4:	6314                	ld	a3,0(a4)
    80006bc6:	96be                	add	a3,a3,a5
    80006bc8:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80006bcc:	6314                	ld	a3,0(a4)
    80006bce:	96be                	add	a3,a3,a5
    80006bd0:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80006bd4:	6318                	ld	a4,0(a4)
    80006bd6:	97ba                	add	a5,a5,a4
    80006bd8:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80006bdc:	0005d797          	auipc	a5,0x5d
    80006be0:	42478793          	addi	a5,a5,1060 # 80064000 <disk>
    80006be4:	97aa                	add	a5,a5,a0
    80006be6:	6509                	lui	a0,0x2
    80006be8:	953e                	add	a0,a0,a5
    80006bea:	4785                	li	a5,1
    80006bec:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>

  wakeup(&disk.free[0]);
    80006bf0:	0005f517          	auipc	a0,0x5f
    80006bf4:	42850513          	addi	a0,a0,1064 # 80066018 <disk+0x2018>
    80006bf8:	ffffc097          	auipc	ra,0xffffc
    80006bfc:	930080e7          	jalr	-1744(ra) # 80002528 <wakeup>
}
    80006c00:	60a2                	ld	ra,8(sp)
    80006c02:	6402                	ld	s0,0(sp)
    80006c04:	0141                	addi	sp,sp,16
    80006c06:	8082                	ret
    panic("free_desc 1");
    80006c08:	00003517          	auipc	a0,0x3
    80006c0c:	c9850513          	addi	a0,a0,-872 # 800098a0 <syscalls+0x3a0>
    80006c10:	ffffa097          	auipc	ra,0xffffa
    80006c14:	91a080e7          	jalr	-1766(ra) # 8000052a <panic>
    panic("free_desc 2");
    80006c18:	00003517          	auipc	a0,0x3
    80006c1c:	c9850513          	addi	a0,a0,-872 # 800098b0 <syscalls+0x3b0>
    80006c20:	ffffa097          	auipc	ra,0xffffa
    80006c24:	90a080e7          	jalr	-1782(ra) # 8000052a <panic>

0000000080006c28 <virtio_disk_init>:
{
    80006c28:	1101                	addi	sp,sp,-32
    80006c2a:	ec06                	sd	ra,24(sp)
    80006c2c:	e822                	sd	s0,16(sp)
    80006c2e:	e426                	sd	s1,8(sp)
    80006c30:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006c32:	00003597          	auipc	a1,0x3
    80006c36:	c8e58593          	addi	a1,a1,-882 # 800098c0 <syscalls+0x3c0>
    80006c3a:	0005f517          	auipc	a0,0x5f
    80006c3e:	4ee50513          	addi	a0,a0,1262 # 80066128 <disk+0x2128>
    80006c42:	ffffa097          	auipc	ra,0xffffa
    80006c46:	ef0080e7          	jalr	-272(ra) # 80000b32 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006c4a:	100017b7          	lui	a5,0x10001
    80006c4e:	4398                	lw	a4,0(a5)
    80006c50:	2701                	sext.w	a4,a4
    80006c52:	747277b7          	lui	a5,0x74727
    80006c56:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006c5a:	0ef71163          	bne	a4,a5,80006d3c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006c5e:	100017b7          	lui	a5,0x10001
    80006c62:	43dc                	lw	a5,4(a5)
    80006c64:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006c66:	4705                	li	a4,1
    80006c68:	0ce79a63          	bne	a5,a4,80006d3c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006c6c:	100017b7          	lui	a5,0x10001
    80006c70:	479c                	lw	a5,8(a5)
    80006c72:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006c74:	4709                	li	a4,2
    80006c76:	0ce79363          	bne	a5,a4,80006d3c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006c7a:	100017b7          	lui	a5,0x10001
    80006c7e:	47d8                	lw	a4,12(a5)
    80006c80:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006c82:	554d47b7          	lui	a5,0x554d4
    80006c86:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006c8a:	0af71963          	bne	a4,a5,80006d3c <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006c8e:	100017b7          	lui	a5,0x10001
    80006c92:	4705                	li	a4,1
    80006c94:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006c96:	470d                	li	a4,3
    80006c98:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006c9a:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006c9c:	c7ffe737          	lui	a4,0xc7ffe
    80006ca0:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47f9775f>
    80006ca4:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006ca6:	2701                	sext.w	a4,a4
    80006ca8:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006caa:	472d                	li	a4,11
    80006cac:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006cae:	473d                	li	a4,15
    80006cb0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006cb2:	6705                	lui	a4,0x1
    80006cb4:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006cb6:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006cba:	5bdc                	lw	a5,52(a5)
    80006cbc:	2781                	sext.w	a5,a5
  if(max == 0)
    80006cbe:	c7d9                	beqz	a5,80006d4c <virtio_disk_init+0x124>
  if(max < NUM)
    80006cc0:	471d                	li	a4,7
    80006cc2:	08f77d63          	bgeu	a4,a5,80006d5c <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006cc6:	100014b7          	lui	s1,0x10001
    80006cca:	47a1                	li	a5,8
    80006ccc:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80006cce:	6609                	lui	a2,0x2
    80006cd0:	4581                	li	a1,0
    80006cd2:	0005d517          	auipc	a0,0x5d
    80006cd6:	32e50513          	addi	a0,a0,814 # 80064000 <disk>
    80006cda:	ffffa097          	auipc	ra,0xffffa
    80006cde:	ff2080e7          	jalr	-14(ra) # 80000ccc <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006ce2:	0005d717          	auipc	a4,0x5d
    80006ce6:	31e70713          	addi	a4,a4,798 # 80064000 <disk>
    80006cea:	00c75793          	srli	a5,a4,0xc
    80006cee:	2781                	sext.w	a5,a5
    80006cf0:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80006cf2:	0005f797          	auipc	a5,0x5f
    80006cf6:	30e78793          	addi	a5,a5,782 # 80066000 <disk+0x2000>
    80006cfa:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006cfc:	0005d717          	auipc	a4,0x5d
    80006d00:	38470713          	addi	a4,a4,900 # 80064080 <disk+0x80>
    80006d04:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80006d06:	0005e717          	auipc	a4,0x5e
    80006d0a:	2fa70713          	addi	a4,a4,762 # 80065000 <disk+0x1000>
    80006d0e:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80006d10:	4705                	li	a4,1
    80006d12:	00e78c23          	sb	a4,24(a5)
    80006d16:	00e78ca3          	sb	a4,25(a5)
    80006d1a:	00e78d23          	sb	a4,26(a5)
    80006d1e:	00e78da3          	sb	a4,27(a5)
    80006d22:	00e78e23          	sb	a4,28(a5)
    80006d26:	00e78ea3          	sb	a4,29(a5)
    80006d2a:	00e78f23          	sb	a4,30(a5)
    80006d2e:	00e78fa3          	sb	a4,31(a5)
}
    80006d32:	60e2                	ld	ra,24(sp)
    80006d34:	6442                	ld	s0,16(sp)
    80006d36:	64a2                	ld	s1,8(sp)
    80006d38:	6105                	addi	sp,sp,32
    80006d3a:	8082                	ret
    panic("could not find virtio disk");
    80006d3c:	00003517          	auipc	a0,0x3
    80006d40:	b9450513          	addi	a0,a0,-1132 # 800098d0 <syscalls+0x3d0>
    80006d44:	ffff9097          	auipc	ra,0xffff9
    80006d48:	7e6080e7          	jalr	2022(ra) # 8000052a <panic>
    panic("virtio disk has no queue 0");
    80006d4c:	00003517          	auipc	a0,0x3
    80006d50:	ba450513          	addi	a0,a0,-1116 # 800098f0 <syscalls+0x3f0>
    80006d54:	ffff9097          	auipc	ra,0xffff9
    80006d58:	7d6080e7          	jalr	2006(ra) # 8000052a <panic>
    panic("virtio disk max queue too short");
    80006d5c:	00003517          	auipc	a0,0x3
    80006d60:	bb450513          	addi	a0,a0,-1100 # 80009910 <syscalls+0x410>
    80006d64:	ffff9097          	auipc	ra,0xffff9
    80006d68:	7c6080e7          	jalr	1990(ra) # 8000052a <panic>

0000000080006d6c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006d6c:	7119                	addi	sp,sp,-128
    80006d6e:	fc86                	sd	ra,120(sp)
    80006d70:	f8a2                	sd	s0,112(sp)
    80006d72:	f4a6                	sd	s1,104(sp)
    80006d74:	f0ca                	sd	s2,96(sp)
    80006d76:	ecce                	sd	s3,88(sp)
    80006d78:	e8d2                	sd	s4,80(sp)
    80006d7a:	e4d6                	sd	s5,72(sp)
    80006d7c:	e0da                	sd	s6,64(sp)
    80006d7e:	fc5e                	sd	s7,56(sp)
    80006d80:	f862                	sd	s8,48(sp)
    80006d82:	f466                	sd	s9,40(sp)
    80006d84:	f06a                	sd	s10,32(sp)
    80006d86:	ec6e                	sd	s11,24(sp)
    80006d88:	0100                	addi	s0,sp,128
    80006d8a:	8aaa                	mv	s5,a0
    80006d8c:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006d8e:	00c52c83          	lw	s9,12(a0)
    80006d92:	001c9c9b          	slliw	s9,s9,0x1
    80006d96:	1c82                	slli	s9,s9,0x20
    80006d98:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006d9c:	0005f517          	auipc	a0,0x5f
    80006da0:	38c50513          	addi	a0,a0,908 # 80066128 <disk+0x2128>
    80006da4:	ffffa097          	auipc	ra,0xffffa
    80006da8:	e26080e7          	jalr	-474(ra) # 80000bca <acquire>
  for(int i = 0; i < 3; i++){
    80006dac:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006dae:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006db0:	0005dc17          	auipc	s8,0x5d
    80006db4:	250c0c13          	addi	s8,s8,592 # 80064000 <disk>
    80006db8:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80006dba:	4b0d                	li	s6,3
    80006dbc:	a0ad                	j	80006e26 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80006dbe:	00fc0733          	add	a4,s8,a5
    80006dc2:	975e                	add	a4,a4,s7
    80006dc4:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006dc8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006dca:	0207c563          	bltz	a5,80006df4 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80006dce:	2905                	addiw	s2,s2,1
    80006dd0:	0611                	addi	a2,a2,4
    80006dd2:	19690d63          	beq	s2,s6,80006f6c <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80006dd6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006dd8:	0005f717          	auipc	a4,0x5f
    80006ddc:	24070713          	addi	a4,a4,576 # 80066018 <disk+0x2018>
    80006de0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006de2:	00074683          	lbu	a3,0(a4)
    80006de6:	fee1                	bnez	a3,80006dbe <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80006de8:	2785                	addiw	a5,a5,1
    80006dea:	0705                	addi	a4,a4,1
    80006dec:	fe979be3          	bne	a5,s1,80006de2 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80006df0:	57fd                	li	a5,-1
    80006df2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006df4:	01205d63          	blez	s2,80006e0e <virtio_disk_rw+0xa2>
    80006df8:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006dfa:	000a2503          	lw	a0,0(s4)
    80006dfe:	00000097          	auipc	ra,0x0
    80006e02:	d8e080e7          	jalr	-626(ra) # 80006b8c <free_desc>
      for(int j = 0; j < i; j++)
    80006e06:	2d85                	addiw	s11,s11,1
    80006e08:	0a11                	addi	s4,s4,4
    80006e0a:	ffb918e3          	bne	s2,s11,80006dfa <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006e0e:	0005f597          	auipc	a1,0x5f
    80006e12:	31a58593          	addi	a1,a1,794 # 80066128 <disk+0x2128>
    80006e16:	0005f517          	auipc	a0,0x5f
    80006e1a:	20250513          	addi	a0,a0,514 # 80066018 <disk+0x2018>
    80006e1e:	ffffb097          	auipc	ra,0xffffb
    80006e22:	560080e7          	jalr	1376(ra) # 8000237e <sleep>
  for(int i = 0; i < 3; i++){
    80006e26:	f8040a13          	addi	s4,s0,-128
{
    80006e2a:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006e2c:	894e                	mv	s2,s3
    80006e2e:	b765                	j	80006dd6 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80006e30:	0005f697          	auipc	a3,0x5f
    80006e34:	1d06b683          	ld	a3,464(a3) # 80066000 <disk+0x2000>
    80006e38:	96ba                	add	a3,a3,a4
    80006e3a:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006e3e:	0005d817          	auipc	a6,0x5d
    80006e42:	1c280813          	addi	a6,a6,450 # 80064000 <disk>
    80006e46:	0005f697          	auipc	a3,0x5f
    80006e4a:	1ba68693          	addi	a3,a3,442 # 80066000 <disk+0x2000>
    80006e4e:	6290                	ld	a2,0(a3)
    80006e50:	963a                	add	a2,a2,a4
    80006e52:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80006e56:	0015e593          	ori	a1,a1,1
    80006e5a:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80006e5e:	f8842603          	lw	a2,-120(s0)
    80006e62:	628c                	ld	a1,0(a3)
    80006e64:	972e                	add	a4,a4,a1
    80006e66:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006e6a:	20050593          	addi	a1,a0,512
    80006e6e:	0592                	slli	a1,a1,0x4
    80006e70:	95c2                	add	a1,a1,a6
    80006e72:	577d                	li	a4,-1
    80006e74:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006e78:	00461713          	slli	a4,a2,0x4
    80006e7c:	6290                	ld	a2,0(a3)
    80006e7e:	963a                	add	a2,a2,a4
    80006e80:	03078793          	addi	a5,a5,48
    80006e84:	97c2                	add	a5,a5,a6
    80006e86:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    80006e88:	629c                	ld	a5,0(a3)
    80006e8a:	97ba                	add	a5,a5,a4
    80006e8c:	4605                	li	a2,1
    80006e8e:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006e90:	629c                	ld	a5,0(a3)
    80006e92:	97ba                	add	a5,a5,a4
    80006e94:	4809                	li	a6,2
    80006e96:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80006e9a:	629c                	ld	a5,0(a3)
    80006e9c:	973e                	add	a4,a4,a5
    80006e9e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006ea2:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80006ea6:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006eaa:	6698                	ld	a4,8(a3)
    80006eac:	00275783          	lhu	a5,2(a4)
    80006eb0:	8b9d                	andi	a5,a5,7
    80006eb2:	0786                	slli	a5,a5,0x1
    80006eb4:	97ba                	add	a5,a5,a4
    80006eb6:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    80006eba:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006ebe:	6698                	ld	a4,8(a3)
    80006ec0:	00275783          	lhu	a5,2(a4)
    80006ec4:	2785                	addiw	a5,a5,1
    80006ec6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006eca:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006ece:	100017b7          	lui	a5,0x10001
    80006ed2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006ed6:	004aa783          	lw	a5,4(s5)
    80006eda:	02c79163          	bne	a5,a2,80006efc <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80006ede:	0005f917          	auipc	s2,0x5f
    80006ee2:	24a90913          	addi	s2,s2,586 # 80066128 <disk+0x2128>
  while(b->disk == 1) {
    80006ee6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006ee8:	85ca                	mv	a1,s2
    80006eea:	8556                	mv	a0,s5
    80006eec:	ffffb097          	auipc	ra,0xffffb
    80006ef0:	492080e7          	jalr	1170(ra) # 8000237e <sleep>
  while(b->disk == 1) {
    80006ef4:	004aa783          	lw	a5,4(s5)
    80006ef8:	fe9788e3          	beq	a5,s1,80006ee8 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80006efc:	f8042903          	lw	s2,-128(s0)
    80006f00:	20090793          	addi	a5,s2,512
    80006f04:	00479713          	slli	a4,a5,0x4
    80006f08:	0005d797          	auipc	a5,0x5d
    80006f0c:	0f878793          	addi	a5,a5,248 # 80064000 <disk>
    80006f10:	97ba                	add	a5,a5,a4
    80006f12:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80006f16:	0005f997          	auipc	s3,0x5f
    80006f1a:	0ea98993          	addi	s3,s3,234 # 80066000 <disk+0x2000>
    80006f1e:	00491713          	slli	a4,s2,0x4
    80006f22:	0009b783          	ld	a5,0(s3)
    80006f26:	97ba                	add	a5,a5,a4
    80006f28:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006f2c:	854a                	mv	a0,s2
    80006f2e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006f32:	00000097          	auipc	ra,0x0
    80006f36:	c5a080e7          	jalr	-934(ra) # 80006b8c <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006f3a:	8885                	andi	s1,s1,1
    80006f3c:	f0ed                	bnez	s1,80006f1e <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006f3e:	0005f517          	auipc	a0,0x5f
    80006f42:	1ea50513          	addi	a0,a0,490 # 80066128 <disk+0x2128>
    80006f46:	ffffa097          	auipc	ra,0xffffa
    80006f4a:	d3e080e7          	jalr	-706(ra) # 80000c84 <release>
}
    80006f4e:	70e6                	ld	ra,120(sp)
    80006f50:	7446                	ld	s0,112(sp)
    80006f52:	74a6                	ld	s1,104(sp)
    80006f54:	7906                	ld	s2,96(sp)
    80006f56:	69e6                	ld	s3,88(sp)
    80006f58:	6a46                	ld	s4,80(sp)
    80006f5a:	6aa6                	ld	s5,72(sp)
    80006f5c:	6b06                	ld	s6,64(sp)
    80006f5e:	7be2                	ld	s7,56(sp)
    80006f60:	7c42                	ld	s8,48(sp)
    80006f62:	7ca2                	ld	s9,40(sp)
    80006f64:	7d02                	ld	s10,32(sp)
    80006f66:	6de2                	ld	s11,24(sp)
    80006f68:	6109                	addi	sp,sp,128
    80006f6a:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006f6c:	f8042503          	lw	a0,-128(s0)
    80006f70:	20050793          	addi	a5,a0,512
    80006f74:	0792                	slli	a5,a5,0x4
  if(write)
    80006f76:	0005d817          	auipc	a6,0x5d
    80006f7a:	08a80813          	addi	a6,a6,138 # 80064000 <disk>
    80006f7e:	00f80733          	add	a4,a6,a5
    80006f82:	01a036b3          	snez	a3,s10
    80006f86:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    80006f8a:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80006f8e:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006f92:	7679                	lui	a2,0xffffe
    80006f94:	963e                	add	a2,a2,a5
    80006f96:	0005f697          	auipc	a3,0x5f
    80006f9a:	06a68693          	addi	a3,a3,106 # 80066000 <disk+0x2000>
    80006f9e:	6298                	ld	a4,0(a3)
    80006fa0:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006fa2:	0a878593          	addi	a1,a5,168
    80006fa6:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006fa8:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006faa:	6298                	ld	a4,0(a3)
    80006fac:	9732                	add	a4,a4,a2
    80006fae:	45c1                	li	a1,16
    80006fb0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006fb2:	6298                	ld	a4,0(a3)
    80006fb4:	9732                	add	a4,a4,a2
    80006fb6:	4585                	li	a1,1
    80006fb8:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80006fbc:	f8442703          	lw	a4,-124(s0)
    80006fc0:	628c                	ld	a1,0(a3)
    80006fc2:	962e                	add	a2,a2,a1
    80006fc4:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ff9700e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80006fc8:	0712                	slli	a4,a4,0x4
    80006fca:	6290                	ld	a2,0(a3)
    80006fcc:	963a                	add	a2,a2,a4
    80006fce:	058a8593          	addi	a1,s5,88
    80006fd2:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006fd4:	6294                	ld	a3,0(a3)
    80006fd6:	96ba                	add	a3,a3,a4
    80006fd8:	40000613          	li	a2,1024
    80006fdc:	c690                	sw	a2,8(a3)
  if(write)
    80006fde:	e40d19e3          	bnez	s10,80006e30 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006fe2:	0005f697          	auipc	a3,0x5f
    80006fe6:	01e6b683          	ld	a3,30(a3) # 80066000 <disk+0x2000>
    80006fea:	96ba                	add	a3,a3,a4
    80006fec:	4609                	li	a2,2
    80006fee:	00c69623          	sh	a2,12(a3)
    80006ff2:	b5b1                	j	80006e3e <virtio_disk_rw+0xd2>

0000000080006ff4 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006ff4:	1101                	addi	sp,sp,-32
    80006ff6:	ec06                	sd	ra,24(sp)
    80006ff8:	e822                	sd	s0,16(sp)
    80006ffa:	e426                	sd	s1,8(sp)
    80006ffc:	e04a                	sd	s2,0(sp)
    80006ffe:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80007000:	0005f517          	auipc	a0,0x5f
    80007004:	12850513          	addi	a0,a0,296 # 80066128 <disk+0x2128>
    80007008:	ffffa097          	auipc	ra,0xffffa
    8000700c:	bc2080e7          	jalr	-1086(ra) # 80000bca <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80007010:	10001737          	lui	a4,0x10001
    80007014:	533c                	lw	a5,96(a4)
    80007016:	8b8d                	andi	a5,a5,3
    80007018:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000701a:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000701e:	0005f797          	auipc	a5,0x5f
    80007022:	fe278793          	addi	a5,a5,-30 # 80066000 <disk+0x2000>
    80007026:	6b94                	ld	a3,16(a5)
    80007028:	0207d703          	lhu	a4,32(a5)
    8000702c:	0026d783          	lhu	a5,2(a3)
    80007030:	06f70163          	beq	a4,a5,80007092 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80007034:	0005d917          	auipc	s2,0x5d
    80007038:	fcc90913          	addi	s2,s2,-52 # 80064000 <disk>
    8000703c:	0005f497          	auipc	s1,0x5f
    80007040:	fc448493          	addi	s1,s1,-60 # 80066000 <disk+0x2000>
    __sync_synchronize();
    80007044:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80007048:	6898                	ld	a4,16(s1)
    8000704a:	0204d783          	lhu	a5,32(s1)
    8000704e:	8b9d                	andi	a5,a5,7
    80007050:	078e                	slli	a5,a5,0x3
    80007052:	97ba                	add	a5,a5,a4
    80007054:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80007056:	20078713          	addi	a4,a5,512
    8000705a:	0712                	slli	a4,a4,0x4
    8000705c:	974a                	add	a4,a4,s2
    8000705e:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80007062:	e731                	bnez	a4,800070ae <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80007064:	20078793          	addi	a5,a5,512
    80007068:	0792                	slli	a5,a5,0x4
    8000706a:	97ca                	add	a5,a5,s2
    8000706c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    8000706e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80007072:	ffffb097          	auipc	ra,0xffffb
    80007076:	4b6080e7          	jalr	1206(ra) # 80002528 <wakeup>

    disk.used_idx += 1;
    8000707a:	0204d783          	lhu	a5,32(s1)
    8000707e:	2785                	addiw	a5,a5,1
    80007080:	17c2                	slli	a5,a5,0x30
    80007082:	93c1                	srli	a5,a5,0x30
    80007084:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80007088:	6898                	ld	a4,16(s1)
    8000708a:	00275703          	lhu	a4,2(a4)
    8000708e:	faf71be3          	bne	a4,a5,80007044 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80007092:	0005f517          	auipc	a0,0x5f
    80007096:	09650513          	addi	a0,a0,150 # 80066128 <disk+0x2128>
    8000709a:	ffffa097          	auipc	ra,0xffffa
    8000709e:	bea080e7          	jalr	-1046(ra) # 80000c84 <release>
}
    800070a2:	60e2                	ld	ra,24(sp)
    800070a4:	6442                	ld	s0,16(sp)
    800070a6:	64a2                	ld	s1,8(sp)
    800070a8:	6902                	ld	s2,0(sp)
    800070aa:	6105                	addi	sp,sp,32
    800070ac:	8082                	ret
      panic("virtio_disk_intr status");
    800070ae:	00003517          	auipc	a0,0x3
    800070b2:	88250513          	addi	a0,a0,-1918 # 80009930 <syscalls+0x430>
    800070b6:	ffff9097          	auipc	ra,0xffff9
    800070ba:	474080e7          	jalr	1140(ra) # 8000052a <panic>
	...

0000000080008000 <_trampoline>:
    80008000:	14051573          	csrrw	a0,sscratch,a0
    80008004:	02153423          	sd	ra,40(a0)
    80008008:	02253823          	sd	sp,48(a0)
    8000800c:	02353c23          	sd	gp,56(a0)
    80008010:	04453023          	sd	tp,64(a0)
    80008014:	04553423          	sd	t0,72(a0)
    80008018:	04653823          	sd	t1,80(a0)
    8000801c:	04753c23          	sd	t2,88(a0)
    80008020:	f120                	sd	s0,96(a0)
    80008022:	f524                	sd	s1,104(a0)
    80008024:	fd2c                	sd	a1,120(a0)
    80008026:	e150                	sd	a2,128(a0)
    80008028:	e554                	sd	a3,136(a0)
    8000802a:	e958                	sd	a4,144(a0)
    8000802c:	ed5c                	sd	a5,152(a0)
    8000802e:	0b053023          	sd	a6,160(a0)
    80008032:	0b153423          	sd	a7,168(a0)
    80008036:	0b253823          	sd	s2,176(a0)
    8000803a:	0b353c23          	sd	s3,184(a0)
    8000803e:	0d453023          	sd	s4,192(a0)
    80008042:	0d553423          	sd	s5,200(a0)
    80008046:	0d653823          	sd	s6,208(a0)
    8000804a:	0d753c23          	sd	s7,216(a0)
    8000804e:	0f853023          	sd	s8,224(a0)
    80008052:	0f953423          	sd	s9,232(a0)
    80008056:	0fa53823          	sd	s10,240(a0)
    8000805a:	0fb53c23          	sd	s11,248(a0)
    8000805e:	11c53023          	sd	t3,256(a0)
    80008062:	11d53423          	sd	t4,264(a0)
    80008066:	11e53823          	sd	t5,272(a0)
    8000806a:	11f53c23          	sd	t6,280(a0)
    8000806e:	140022f3          	csrr	t0,sscratch
    80008072:	06553823          	sd	t0,112(a0)
    80008076:	00853103          	ld	sp,8(a0)
    8000807a:	02053203          	ld	tp,32(a0)
    8000807e:	01053283          	ld	t0,16(a0)
    80008082:	00053303          	ld	t1,0(a0)
    80008086:	18031073          	csrw	satp,t1
    8000808a:	12000073          	sfence.vma
    8000808e:	8282                	jr	t0

0000000080008090 <userret>:
    80008090:	18059073          	csrw	satp,a1
    80008094:	12000073          	sfence.vma
    80008098:	07053283          	ld	t0,112(a0)
    8000809c:	14029073          	csrw	sscratch,t0
    800080a0:	02853083          	ld	ra,40(a0)
    800080a4:	03053103          	ld	sp,48(a0)
    800080a8:	03853183          	ld	gp,56(a0)
    800080ac:	04053203          	ld	tp,64(a0)
    800080b0:	04853283          	ld	t0,72(a0)
    800080b4:	05053303          	ld	t1,80(a0)
    800080b8:	05853383          	ld	t2,88(a0)
    800080bc:	7120                	ld	s0,96(a0)
    800080be:	7524                	ld	s1,104(a0)
    800080c0:	7d2c                	ld	a1,120(a0)
    800080c2:	6150                	ld	a2,128(a0)
    800080c4:	6554                	ld	a3,136(a0)
    800080c6:	6958                	ld	a4,144(a0)
    800080c8:	6d5c                	ld	a5,152(a0)
    800080ca:	0a053803          	ld	a6,160(a0)
    800080ce:	0a853883          	ld	a7,168(a0)
    800080d2:	0b053903          	ld	s2,176(a0)
    800080d6:	0b853983          	ld	s3,184(a0)
    800080da:	0c053a03          	ld	s4,192(a0)
    800080de:	0c853a83          	ld	s5,200(a0)
    800080e2:	0d053b03          	ld	s6,208(a0)
    800080e6:	0d853b83          	ld	s7,216(a0)
    800080ea:	0e053c03          	ld	s8,224(a0)
    800080ee:	0e853c83          	ld	s9,232(a0)
    800080f2:	0f053d03          	ld	s10,240(a0)
    800080f6:	0f853d83          	ld	s11,248(a0)
    800080fa:	10053e03          	ld	t3,256(a0)
    800080fe:	10853e83          	ld	t4,264(a0)
    80008102:	11053f03          	ld	t5,272(a0)
    80008106:	11853f83          	ld	t6,280(a0)
    8000810a:	14051573          	csrrw	a0,sscratch,a0
    8000810e:	10200073          	sret
	...
