
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
    80000068:	abc78793          	addi	a5,a5,-1348 # 80006b20 <timervec>
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
    80000122:	7e4080e7          	jalr	2020(ra) # 80002902 <either_copyin>
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
    800001c6:	1b2080e7          	jalr	434(ra) # 80002374 <sleep>
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
    80000202:	6a8080e7          	jalr	1704(ra) # 800028a6 <either_copyout>
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
    800002e2:	680080e7          	jalr	1664(ra) # 8000295e <procdump>
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
    80000436:	102080e7          	jalr	258(ra) # 80002534 <wakeup>
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
    8000055c:	b7050513          	addi	a0,a0,-1168 # 800090c8 <digits+0x88>
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
    80000882:	cb6080e7          	jalr	-842(ra) # 80002534 <wakeup>
    
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
    8000090e:	a6a080e7          	jalr	-1430(ra) # 80002374 <sleep>
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
    80000ec4:	3e8080e7          	jalr	1000(ra) # 800032a8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec8:	00006097          	auipc	ra,0x6
    80000ecc:	c98080e7          	jalr	-872(ra) # 80006b60 <plicinithart>
  }

  scheduler();        
    80000ed0:	00001097          	auipc	ra,0x1
    80000ed4:	2a0080e7          	jalr	672(ra) # 80002170 <scheduler>
    consoleinit();
    80000ed8:	fffff097          	auipc	ra,0xfffff
    80000edc:	564080e7          	jalr	1380(ra) # 8000043c <consoleinit>
    printfinit();
    80000ee0:	00000097          	auipc	ra,0x0
    80000ee4:	874080e7          	jalr	-1932(ra) # 80000754 <printfinit>
    printf("\n");
    80000ee8:	00008517          	auipc	a0,0x8
    80000eec:	1e050513          	addi	a0,a0,480 # 800090c8 <digits+0x88>
    80000ef0:	fffff097          	auipc	ra,0xfffff
    80000ef4:	684080e7          	jalr	1668(ra) # 80000574 <printf>
    printf("xv6 kernel is booting\n");
    80000ef8:	00008517          	auipc	a0,0x8
    80000efc:	1a850513          	addi	a0,a0,424 # 800090a0 <digits+0x60>
    80000f00:	fffff097          	auipc	ra,0xfffff
    80000f04:	674080e7          	jalr	1652(ra) # 80000574 <printf>
    printf("\n");
    80000f08:	00008517          	auipc	a0,0x8
    80000f0c:	1c050513          	addi	a0,a0,448 # 800090c8 <digits+0x88>
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
    80000f3c:	348080e7          	jalr	840(ra) # 80003280 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f40:	00002097          	auipc	ra,0x2
    80000f44:	368080e7          	jalr	872(ra) # 800032a8 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f48:	00006097          	auipc	ra,0x6
    80000f4c:	c02080e7          	jalr	-1022(ra) # 80006b4a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f50:	00006097          	auipc	ra,0x6
    80000f54:	c10080e7          	jalr	-1008(ra) # 80006b60 <plicinithart>
    binit();         // buffer cache
    80000f58:	00003097          	auipc	ra,0x3
    80000f5c:	d54080e7          	jalr	-684(ra) # 80003cac <binit>
    iinit();         // inode cache
    80000f60:	00003097          	auipc	ra,0x3
    80000f64:	3e6080e7          	jalr	998(ra) # 80004346 <iinit>
    fileinit();      // file table
    80000f68:	00004097          	auipc	ra,0x4
    80000f6c:	398080e7          	jalr	920(ra) # 80005300 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f70:	00006097          	auipc	ra,0x6
    80000f74:	d18080e7          	jalr	-744(ra) # 80006c88 <virtio_disk_init>
    userinit();      // first user process
    80000f78:	00001097          	auipc	ra,0x1
    80000f7c:	ebc080e7          	jalr	-324(ra) # 80001e34 <userinit>
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
  //printf("debug: starting forkret function\npid %d\ntid %d\n\n", myproc()->pid, mythread()->tid);
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001a40:	00000097          	auipc	ra,0x0
    80001a44:	fb8080e7          	jalr	-72(ra) # 800019f8 <myproc>
    80001a48:	fffff097          	auipc	ra,0xfffff
    80001a4c:	23c080e7          	jalr	572(ra) # 80000c84 <release>

  if (first) {
    80001a50:	00008797          	auipc	a5,0x8
    80001a54:	ed07a783          	lw	a5,-304(a5) # 80009920 <first.1>
    80001a58:	eb89                	bnez	a5,80001a6a <forkret+0x32>
    first = 0;
    fsinit(ROOTDEV);
  }
  //printf("debug: finishing forkret\n");

  usertrapret();
    80001a5a:	00002097          	auipc	ra,0x2
    80001a5e:	866080e7          	jalr	-1946(ra) # 800032c0 <usertrapret>

}
    80001a62:	60a2                	ld	ra,8(sp)
    80001a64:	6402                	ld	s0,0(sp)
    80001a66:	0141                	addi	sp,sp,16
    80001a68:	8082                	ret
    first = 0;
    80001a6a:	00008797          	auipc	a5,0x8
    80001a6e:	ea07ab23          	sw	zero,-330(a5) # 80009920 <first.1>
    fsinit(ROOTDEV);
    80001a72:	4505                	li	a0,1
    80001a74:	00003097          	auipc	ra,0x3
    80001a78:	852080e7          	jalr	-1966(ra) # 800042c6 <fsinit>
    80001a7c:	bff9                	j	80001a5a <forkret+0x22>

0000000080001a7e <mythread>:
mythread(void) {
    80001a7e:	1101                	addi	sp,sp,-32
    80001a80:	ec06                	sd	ra,24(sp)
    80001a82:	e822                	sd	s0,16(sp)
    80001a84:	e426                	sd	s1,8(sp)
    80001a86:	1000                	addi	s0,sp,32
  push_off();
    80001a88:	fffff097          	auipc	ra,0xfffff
    80001a8c:	0ee080e7          	jalr	238(ra) # 80000b76 <push_off>
    80001a90:	8792                	mv	a5,tp
  struct thread *t = c->thread;
    80001a92:	0007871b          	sext.w	a4,a5
    80001a96:	00471793          	slli	a5,a4,0x4
    80001a9a:	97ba                	add	a5,a5,a4
    80001a9c:	078e                	slli	a5,a5,0x3
    80001a9e:	00011717          	auipc	a4,0x11
    80001aa2:	80270713          	addi	a4,a4,-2046 # 800122a0 <pid_lock>
    80001aa6:	97ba                	add	a5,a5,a4
    80001aa8:	7f84                	ld	s1,56(a5)
  pop_off();
    80001aaa:	fffff097          	auipc	ra,0xfffff
    80001aae:	174080e7          	jalr	372(ra) # 80000c1e <pop_off>
}
    80001ab2:	8526                	mv	a0,s1
    80001ab4:	60e2                	ld	ra,24(sp)
    80001ab6:	6442                	ld	s0,16(sp)
    80001ab8:	64a2                	ld	s1,8(sp)
    80001aba:	6105                	addi	sp,sp,32
    80001abc:	8082                	ret

0000000080001abe <allocpid>:
allocpid() {
    80001abe:	1101                	addi	sp,sp,-32
    80001ac0:	ec06                	sd	ra,24(sp)
    80001ac2:	e822                	sd	s0,16(sp)
    80001ac4:	e426                	sd	s1,8(sp)
    80001ac6:	e04a                	sd	s2,0(sp)
    80001ac8:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001aca:	00010917          	auipc	s2,0x10
    80001ace:	7d690913          	addi	s2,s2,2006 # 800122a0 <pid_lock>
    80001ad2:	854a                	mv	a0,s2
    80001ad4:	fffff097          	auipc	ra,0xfffff
    80001ad8:	0f6080e7          	jalr	246(ra) # 80000bca <acquire>
  pid = nextpid;
    80001adc:	00008797          	auipc	a5,0x8
    80001ae0:	e4c78793          	addi	a5,a5,-436 # 80009928 <nextpid>
    80001ae4:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001ae6:	0014871b          	addiw	a4,s1,1
    80001aea:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001aec:	854a                	mv	a0,s2
    80001aee:	fffff097          	auipc	ra,0xfffff
    80001af2:	196080e7          	jalr	406(ra) # 80000c84 <release>
}
    80001af6:	8526                	mv	a0,s1
    80001af8:	60e2                	ld	ra,24(sp)
    80001afa:	6442                	ld	s0,16(sp)
    80001afc:	64a2                	ld	s1,8(sp)
    80001afe:	6902                	ld	s2,0(sp)
    80001b00:	6105                	addi	sp,sp,32
    80001b02:	8082                	ret

0000000080001b04 <alloctid>:
alloctid() {
    80001b04:	1101                	addi	sp,sp,-32
    80001b06:	ec06                	sd	ra,24(sp)
    80001b08:	e822                	sd	s0,16(sp)
    80001b0a:	e426                	sd	s1,8(sp)
    80001b0c:	e04a                	sd	s2,0(sp)
    80001b0e:	1000                	addi	s0,sp,32
  acquire(&tid_lock);
    80001b10:	00011917          	auipc	s2,0x11
    80001b14:	c0090913          	addi	s2,s2,-1024 # 80012710 <tid_lock>
    80001b18:	854a                	mv	a0,s2
    80001b1a:	fffff097          	auipc	ra,0xfffff
    80001b1e:	0b0080e7          	jalr	176(ra) # 80000bca <acquire>
  tid = nexttid;
    80001b22:	00008797          	auipc	a5,0x8
    80001b26:	e0278793          	addi	a5,a5,-510 # 80009924 <nexttid>
    80001b2a:	4384                	lw	s1,0(a5)
  nexttid = nexttid + 1;
    80001b2c:	0014871b          	addiw	a4,s1,1
    80001b30:	c398                	sw	a4,0(a5)
  release(&tid_lock);
    80001b32:	854a                	mv	a0,s2
    80001b34:	fffff097          	auipc	ra,0xfffff
    80001b38:	150080e7          	jalr	336(ra) # 80000c84 <release>
}
    80001b3c:	8526                	mv	a0,s1
    80001b3e:	60e2                	ld	ra,24(sp)
    80001b40:	6442                	ld	s0,16(sp)
    80001b42:	64a2                	ld	s1,8(sp)
    80001b44:	6902                	ld	s2,0(sp)
    80001b46:	6105                	addi	sp,sp,32
    80001b48:	8082                	ret

0000000080001b4a <proc_pagetable>:
{
    80001b4a:	1101                	addi	sp,sp,-32
    80001b4c:	ec06                	sd	ra,24(sp)
    80001b4e:	e822                	sd	s0,16(sp)
    80001b50:	e426                	sd	s1,8(sp)
    80001b52:	e04a                	sd	s2,0(sp)
    80001b54:	1000                	addi	s0,sp,32
    80001b56:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b58:	fffff097          	auipc	ra,0xfffff
    80001b5c:	7bc080e7          	jalr	1980(ra) # 80001314 <uvmcreate>
    80001b60:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b62:	c139                	beqz	a0,80001ba8 <proc_pagetable+0x5e>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b64:	4729                	li	a4,10
    80001b66:	00006697          	auipc	a3,0x6
    80001b6a:	49a68693          	addi	a3,a3,1178 # 80008000 <_trampoline>
    80001b6e:	6605                	lui	a2,0x1
    80001b70:	040005b7          	lui	a1,0x4000
    80001b74:	15fd                	addi	a1,a1,-1
    80001b76:	05b2                	slli	a1,a1,0xc
    80001b78:	fffff097          	auipc	ra,0xfffff
    80001b7c:	524080e7          	jalr	1316(ra) # 8000109c <mappages>
    80001b80:	02054b63          	bltz	a0,80001bb6 <proc_pagetable+0x6c>
              (uint64)(p->main_thread->trapframe), PTE_R | PTE_W) < 0){
    80001b84:	6505                	lui	a0,0x1
    80001b86:	954a                	add	a0,a0,s2
    80001b88:	f3053783          	ld	a5,-208(a0) # f30 <_entry-0x7ffff0d0>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b8c:	4719                	li	a4,6
    80001b8e:	7f94                	ld	a3,56(a5)
    80001b90:	6605                	lui	a2,0x1
    80001b92:	020005b7          	lui	a1,0x2000
    80001b96:	15fd                	addi	a1,a1,-1
    80001b98:	05b6                	slli	a1,a1,0xd
    80001b9a:	8526                	mv	a0,s1
    80001b9c:	fffff097          	auipc	ra,0xfffff
    80001ba0:	500080e7          	jalr	1280(ra) # 8000109c <mappages>
    80001ba4:	02054163          	bltz	a0,80001bc6 <proc_pagetable+0x7c>
}
    80001ba8:	8526                	mv	a0,s1
    80001baa:	60e2                	ld	ra,24(sp)
    80001bac:	6442                	ld	s0,16(sp)
    80001bae:	64a2                	ld	s1,8(sp)
    80001bb0:	6902                	ld	s2,0(sp)
    80001bb2:	6105                	addi	sp,sp,32
    80001bb4:	8082                	ret
    uvmfree(pagetable, 0);
    80001bb6:	4581                	li	a1,0
    80001bb8:	8526                	mv	a0,s1
    80001bba:	00000097          	auipc	ra,0x0
    80001bbe:	956080e7          	jalr	-1706(ra) # 80001510 <uvmfree>
    return 0;
    80001bc2:	4481                	li	s1,0
    80001bc4:	b7d5                	j	80001ba8 <proc_pagetable+0x5e>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bc6:	4681                	li	a3,0
    80001bc8:	4605                	li	a2,1
    80001bca:	040005b7          	lui	a1,0x4000
    80001bce:	15fd                	addi	a1,a1,-1
    80001bd0:	05b2                	slli	a1,a1,0xc
    80001bd2:	8526                	mv	a0,s1
    80001bd4:	fffff097          	auipc	ra,0xfffff
    80001bd8:	67c080e7          	jalr	1660(ra) # 80001250 <uvmunmap>
    uvmfree(pagetable, 0);
    80001bdc:	4581                	li	a1,0
    80001bde:	8526                	mv	a0,s1
    80001be0:	00000097          	auipc	ra,0x0
    80001be4:	930080e7          	jalr	-1744(ra) # 80001510 <uvmfree>
    return 0;
    80001be8:	4481                	li	s1,0
    80001bea:	bf7d                	j	80001ba8 <proc_pagetable+0x5e>

0000000080001bec <proc_freepagetable>:
{
    80001bec:	1101                	addi	sp,sp,-32
    80001bee:	ec06                	sd	ra,24(sp)
    80001bf0:	e822                	sd	s0,16(sp)
    80001bf2:	e426                	sd	s1,8(sp)
    80001bf4:	e04a                	sd	s2,0(sp)
    80001bf6:	1000                	addi	s0,sp,32
    80001bf8:	84aa                	mv	s1,a0
    80001bfa:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bfc:	4681                	li	a3,0
    80001bfe:	4605                	li	a2,1
    80001c00:	040005b7          	lui	a1,0x4000
    80001c04:	15fd                	addi	a1,a1,-1
    80001c06:	05b2                	slli	a1,a1,0xc
    80001c08:	fffff097          	auipc	ra,0xfffff
    80001c0c:	648080e7          	jalr	1608(ra) # 80001250 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001c10:	4681                	li	a3,0
    80001c12:	4605                	li	a2,1
    80001c14:	020005b7          	lui	a1,0x2000
    80001c18:	15fd                	addi	a1,a1,-1
    80001c1a:	05b6                	slli	a1,a1,0xd
    80001c1c:	8526                	mv	a0,s1
    80001c1e:	fffff097          	auipc	ra,0xfffff
    80001c22:	632080e7          	jalr	1586(ra) # 80001250 <uvmunmap>
  uvmfree(pagetable, sz);
    80001c26:	85ca                	mv	a1,s2
    80001c28:	8526                	mv	a0,s1
    80001c2a:	00000097          	auipc	ra,0x0
    80001c2e:	8e6080e7          	jalr	-1818(ra) # 80001510 <uvmfree>
}
    80001c32:	60e2                	ld	ra,24(sp)
    80001c34:	6442                	ld	s0,16(sp)
    80001c36:	64a2                	ld	s1,8(sp)
    80001c38:	6902                	ld	s2,0(sp)
    80001c3a:	6105                	addi	sp,sp,32
    80001c3c:	8082                	ret

0000000080001c3e <freeproc>:
{
    80001c3e:	1101                	addi	sp,sp,-32
    80001c40:	ec06                	sd	ra,24(sp)
    80001c42:	e822                	sd	s0,16(sp)
    80001c44:	e426                	sd	s1,8(sp)
    80001c46:	1000                	addi	s0,sp,32
    80001c48:	84aa                	mv	s1,a0
  if(p->pagetable)
    80001c4a:	6785                	lui	a5,0x1
    80001c4c:	97aa                	add	a5,a5,a0
    80001c4e:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80001c52:	c909                	beqz	a0,80001c64 <freeproc+0x26>
    proc_freepagetable(p->pagetable, p->sz);
    80001c54:	6785                	lui	a5,0x1
    80001c56:	97a6                	add	a5,a5,s1
    80001c58:	f387b583          	ld	a1,-200(a5) # f38 <_entry-0x7ffff0c8>
    80001c5c:	00000097          	auipc	ra,0x0
    80001c60:	f90080e7          	jalr	-112(ra) # 80001bec <proc_freepagetable>
  if(p->threads->trapframe)
    80001c64:	70a8                	ld	a0,96(s1)
    80001c66:	c509                	beqz	a0,80001c70 <freeproc+0x32>
    kfree((void*)p->threads->trapframe);
    80001c68:	fffff097          	auipc	ra,0xfffff
    80001c6c:	d6e080e7          	jalr	-658(ra) # 800009d6 <kfree>
  p->pagetable = 0;
    80001c70:	6785                	lui	a5,0x1
    80001c72:	97a6                	add	a5,a5,s1
    80001c74:	f407b023          	sd	zero,-192(a5) # f40 <_entry-0x7ffff0c0>
  p->sz = 0;
    80001c78:	f207bc23          	sd	zero,-200(a5)
  p->pid = 0;
    80001c7c:	0204a223          	sw	zero,36(s1)
  p->parent = 0;
    80001c80:	f207b423          	sd	zero,-216(a5)
  p->name[0] = 0;
    80001c84:	fc078823          	sb	zero,-48(a5)
  p->killed = 0;
    80001c88:	0004ae23          	sw	zero,28(s1)
  p->xstate = 0;
    80001c8c:	0204a023          	sw	zero,32(s1)
  p->state = UNUSED;
    80001c90:	0004ac23          	sw	zero,24(s1)
}
    80001c94:	60e2                	ld	ra,24(sp)
    80001c96:	6442                	ld	s0,16(sp)
    80001c98:	64a2                	ld	s1,8(sp)
    80001c9a:	6105                	addi	sp,sp,32
    80001c9c:	8082                	ret

0000000080001c9e <allocproc>:
{
    80001c9e:	7179                	addi	sp,sp,-48
    80001ca0:	f406                	sd	ra,40(sp)
    80001ca2:	f022                	sd	s0,32(sp)
    80001ca4:	ec26                	sd	s1,24(sp)
    80001ca6:	e84a                	sd	s2,16(sp)
    80001ca8:	e44e                	sd	s3,8(sp)
    80001caa:	e052                	sd	s4,0(sp)
    80001cac:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cae:	00011497          	auipc	s1,0x11
    80001cb2:	aaa48493          	addi	s1,s1,-1366 # 80012758 <proc>
    80001cb6:	6985                	lui	s3,0x1
    80001cb8:	17898993          	addi	s3,s3,376 # 1178 <_entry-0x7fffee88>
    80001cbc:	00057a17          	auipc	s4,0x57
    80001cc0:	89ca0a13          	addi	s4,s4,-1892 # 80058558 <tickslock>
    acquire(&p->lock);
    80001cc4:	8526                	mv	a0,s1
    80001cc6:	fffff097          	auipc	ra,0xfffff
    80001cca:	f04080e7          	jalr	-252(ra) # 80000bca <acquire>
    if(p->state == UNUSED) {
    80001cce:	4c9c                	lw	a5,24(s1)
    80001cd0:	cb99                	beqz	a5,80001ce6 <allocproc+0x48>
      release(&p->lock);
    80001cd2:	8526                	mv	a0,s1
    80001cd4:	fffff097          	auipc	ra,0xfffff
    80001cd8:	fb0080e7          	jalr	-80(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cdc:	94ce                	add	s1,s1,s3
    80001cde:	ff4493e3          	bne	s1,s4,80001cc4 <allocproc+0x26>
  return 0;
    80001ce2:	4481                	li	s1,0
    80001ce4:	a0fd                	j	80001dd2 <allocproc+0x134>
  p->pid = allocpid();
    80001ce6:	00000097          	auipc	ra,0x0
    80001cea:	dd8080e7          	jalr	-552(ra) # 80001abe <allocpid>
    80001cee:	d0c8                	sw	a0,36(s1)
  p->state = USED;
    80001cf0:	4785                	li	a5,1
    80001cf2:	cc9c                	sw	a5,24(s1)
  p->pendingSignals = 0;
    80001cf4:	6705                	lui	a4,0x1
    80001cf6:	00e487b3          	add	a5,s1,a4
    80001cfa:	fe07a023          	sw	zero,-32(a5)
  p->signalMask = 0;
    80001cfe:	fe07a223          	sw	zero,-28(a5)
  p->stopped = 0;
    80001d02:	0e07a423          	sw	zero,232(a5)
  p->signal_mask_backup = 0;
    80001d06:	0e07a623          	sw	zero,236(a5)
  p->ignore_signals = 0;
    80001d0a:	0e07a823          	sw	zero,240(a5)
  for(int i = 0; i<32 ; i++)
    80001d0e:	fe870793          	addi	a5,a4,-24 # fe8 <_entry-0x7ffff018>
    80001d12:	97a6                	add	a5,a5,s1
    80001d14:	0e870713          	addi	a4,a4,232
    80001d18:	9726                	add	a4,a4,s1
    p->signalHandlers[i] = SIG_DFL;
    80001d1a:	0007b023          	sd	zero,0(a5)
  for(int i = 0; i<32 ; i++)
    80001d1e:	07a1                	addi	a5,a5,8
    80001d20:	fee79de3          	bne	a5,a4,80001d1a <allocproc+0x7c>
  memset(p->signalHandlers, SIG_DFL, sizeof(p->signalHandlers));
    80001d24:	6905                	lui	s2,0x1
    80001d26:	fe890513          	addi	a0,s2,-24 # fe8 <_entry-0x7ffff018>
    80001d2a:	10000613          	li	a2,256
    80001d2e:	4581                	li	a1,0
    80001d30:	9526                	add	a0,a0,s1
    80001d32:	fffff097          	auipc	ra,0xfffff
    80001d36:	f9a080e7          	jalr	-102(ra) # 80000ccc <memset>
  memset(p->maskHandlers, 0, sizeof(p->maskHandlers));
    80001d3a:	0f490513          	addi	a0,s2,244
    80001d3e:	08000613          	li	a2,128
    80001d42:	4581                	li	a1,0
    80001d44:	9526                	add	a0,a0,s1
    80001d46:	fffff097          	auipc	ra,0xfffff
    80001d4a:	f86080e7          	jalr	-122(ra) # 80000ccc <memset>
  p->main_thread = p->threads;
    80001d4e:	9926                	add	s2,s2,s1
    80001d50:	02848793          	addi	a5,s1,40
    80001d54:	f2f93823          	sd	a5,-208(s2)
  p->main_thread->tid = alloctid();
    80001d58:	00000097          	auipc	ra,0x0
    80001d5c:	dac080e7          	jalr	-596(ra) # 80001b04 <alloctid>
    80001d60:	c0a8                	sw	a0,64(s1)
  p->main_thread->state = USED;
    80001d62:	f3093783          	ld	a5,-208(s2)
    80001d66:	4705                	li	a4,1
    80001d68:	c398                	sw	a4,0(a5)
  p->main_thread->proc_parent = p;
    80001d6a:	f3093783          	ld	a5,-208(s2)
    80001d6e:	f784                	sd	s1,40(a5)
  if((p->main_thread->trapframe = (struct trapframe *)kalloc()) == 0){
    80001d70:	f3093983          	ld	s3,-208(s2)
    80001d74:	fffff097          	auipc	ra,0xfffff
    80001d78:	d5e080e7          	jalr	-674(ra) # 80000ad2 <kalloc>
    80001d7c:	892a                	mv	s2,a0
    80001d7e:	02a9bc23          	sd	a0,56(s3)
    80001d82:	c12d                	beqz	a0,80001de4 <allocproc+0x146>
  p->pagetable = proc_pagetable(p);
    80001d84:	8526                	mv	a0,s1
    80001d86:	00000097          	auipc	ra,0x0
    80001d8a:	dc4080e7          	jalr	-572(ra) # 80001b4a <proc_pagetable>
    80001d8e:	892a                	mv	s2,a0
    80001d90:	6785                	lui	a5,0x1
    80001d92:	97a6                	add	a5,a5,s1
    80001d94:	f4a7b023          	sd	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
  if(p->pagetable == 0){
    80001d98:	c935                	beqz	a0,80001e0c <allocproc+0x16e>
  memset(&p->main_thread->context, 0, sizeof(p->main_thread->context));
    80001d9a:	6985                	lui	s3,0x1
    80001d9c:	01348933          	add	s2,s1,s3
    80001da0:	f3093503          	ld	a0,-208(s2)
    80001da4:	07000613          	li	a2,112
    80001da8:	4581                	li	a1,0
    80001daa:	16050513          	addi	a0,a0,352
    80001dae:	fffff097          	auipc	ra,0xfffff
    80001db2:	f1e080e7          	jalr	-226(ra) # 80000ccc <memset>
  p->main_thread->context.ra = (uint64)forkret;
    80001db6:	f3093783          	ld	a5,-208(s2)
    80001dba:	00000717          	auipc	a4,0x0
    80001dbe:	c7e70713          	addi	a4,a4,-898 # 80001a38 <forkret>
    80001dc2:	16e7b023          	sd	a4,352(a5)
  p->main_thread->context.sp = p->main_thread->kstack + PGSIZE;
    80001dc6:	f3093703          	ld	a4,-208(s2)
    80001dca:	7b1c                	ld	a5,48(a4)
    80001dcc:	97ce                	add	a5,a5,s3
    80001dce:	16f73423          	sd	a5,360(a4)
}
    80001dd2:	8526                	mv	a0,s1
    80001dd4:	70a2                	ld	ra,40(sp)
    80001dd6:	7402                	ld	s0,32(sp)
    80001dd8:	64e2                	ld	s1,24(sp)
    80001dda:	6942                	ld	s2,16(sp)
    80001ddc:	69a2                	ld	s3,8(sp)
    80001dde:	6a02                	ld	s4,0(sp)
    80001de0:	6145                	addi	sp,sp,48
    80001de2:	8082                	ret
    freeproc(p);
    80001de4:	8526                	mv	a0,s1
    80001de6:	00000097          	auipc	ra,0x0
    80001dea:	e58080e7          	jalr	-424(ra) # 80001c3e <freeproc>
    freethread(p->main_thread);
    80001dee:	6785                	lui	a5,0x1
    80001df0:	97a6                	add	a5,a5,s1
    80001df2:	f307b503          	ld	a0,-208(a5) # f30 <_entry-0x7ffff0d0>
    80001df6:	00000097          	auipc	ra,0x0
    80001dfa:	a24080e7          	jalr	-1500(ra) # 8000181a <freethread>
    release(&p->lock);
    80001dfe:	8526                	mv	a0,s1
    80001e00:	fffff097          	auipc	ra,0xfffff
    80001e04:	e84080e7          	jalr	-380(ra) # 80000c84 <release>
    return 0;
    80001e08:	84ca                	mv	s1,s2
    80001e0a:	b7e1                	j	80001dd2 <allocproc+0x134>
    freeproc(p);
    80001e0c:	8526                	mv	a0,s1
    80001e0e:	00000097          	auipc	ra,0x0
    80001e12:	e30080e7          	jalr	-464(ra) # 80001c3e <freeproc>
    freethread(p->main_thread);
    80001e16:	6785                	lui	a5,0x1
    80001e18:	97a6                	add	a5,a5,s1
    80001e1a:	f307b503          	ld	a0,-208(a5) # f30 <_entry-0x7ffff0d0>
    80001e1e:	00000097          	auipc	ra,0x0
    80001e22:	9fc080e7          	jalr	-1540(ra) # 8000181a <freethread>
    release(&p->lock);
    80001e26:	8526                	mv	a0,s1
    80001e28:	fffff097          	auipc	ra,0xfffff
    80001e2c:	e5c080e7          	jalr	-420(ra) # 80000c84 <release>
    return 0;
    80001e30:	84ca                	mv	s1,s2
    80001e32:	b745                	j	80001dd2 <allocproc+0x134>

0000000080001e34 <userinit>:
{
    80001e34:	7179                	addi	sp,sp,-48
    80001e36:	f406                	sd	ra,40(sp)
    80001e38:	f022                	sd	s0,32(sp)
    80001e3a:	ec26                	sd	s1,24(sp)
    80001e3c:	e84a                	sd	s2,16(sp)
    80001e3e:	e44e                	sd	s3,8(sp)
    80001e40:	1800                	addi	s0,sp,48
  p = allocproc();
    80001e42:	00000097          	auipc	ra,0x0
    80001e46:	e5c080e7          	jalr	-420(ra) # 80001c9e <allocproc>
    80001e4a:	892a                	mv	s2,a0
  initproc = p;
    80001e4c:	00008797          	auipc	a5,0x8
    80001e50:	1ca7be23          	sd	a0,476(a5) # 8000a028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001e54:	6485                	lui	s1,0x1
    80001e56:	009509b3          	add	s3,a0,s1
    80001e5a:	03400613          	li	a2,52
    80001e5e:	00008597          	auipc	a1,0x8
    80001e62:	ad258593          	addi	a1,a1,-1326 # 80009930 <initcode>
    80001e66:	f409b503          	ld	a0,-192(s3) # f40 <_entry-0x7ffff0c0>
    80001e6a:	fffff097          	auipc	ra,0xfffff
    80001e6e:	4d8080e7          	jalr	1240(ra) # 80001342 <uvminit>
  p->sz = PGSIZE;
    80001e72:	f299bc23          	sd	s1,-200(s3)
  p->main_thread->trapframe->epc = 0;      // user program counter
    80001e76:	f309b783          	ld	a5,-208(s3)
    80001e7a:	7f9c                	ld	a5,56(a5)
    80001e7c:	0007bc23          	sd	zero,24(a5)
  p->main_thread->trapframe->sp = PGSIZE;  // user stack pointer
    80001e80:	f309b783          	ld	a5,-208(s3)
    80001e84:	7f9c                	ld	a5,56(a5)
    80001e86:	fb84                	sd	s1,48(a5)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001e88:	fd048513          	addi	a0,s1,-48 # fd0 <_entry-0x7ffff030>
    80001e8c:	4641                	li	a2,16
    80001e8e:	00007597          	auipc	a1,0x7
    80001e92:	35a58593          	addi	a1,a1,858 # 800091e8 <digits+0x1a8>
    80001e96:	954a                	add	a0,a0,s2
    80001e98:	fffff097          	auipc	ra,0xfffff
    80001e9c:	f86080e7          	jalr	-122(ra) # 80000e1e <safestrcpy>
  p->cwd = namei("/");
    80001ea0:	00007517          	auipc	a0,0x7
    80001ea4:	35850513          	addi	a0,a0,856 # 800091f8 <digits+0x1b8>
    80001ea8:	00003097          	auipc	ra,0x3
    80001eac:	e50080e7          	jalr	-432(ra) # 80004cf8 <namei>
    80001eb0:	fca9b423          	sd	a0,-56(s3)
  p->pendingSignals = 0;
    80001eb4:	fe09a023          	sw	zero,-32(s3)
  p->signalMask = 0;
    80001eb8:	fe09a223          	sw	zero,-28(s3)
  for (int i = 0; i < 32; i++) {
    80001ebc:	fe848793          	addi	a5,s1,-24
    80001ec0:	97ca                	add	a5,a5,s2
    80001ec2:	0e848713          	addi	a4,s1,232
    80001ec6:	974a                	add	a4,a4,s2
    p->signalHandlers[i] = SIG_DFL;
    80001ec8:	0007b023          	sd	zero,0(a5)
  for (int i = 0; i < 32; i++) {
    80001ecc:	07a1                	addi	a5,a5,8
    80001ece:	fee79de3          	bne	a5,a4,80001ec8 <userinit+0x94>
  p->ignore_signals = 0;
    80001ed2:	6785                	lui	a5,0x1
    80001ed4:	97ca                	add	a5,a5,s2
    80001ed6:	0e07a823          	sw	zero,240(a5) # 10f0 <_entry-0x7fffef10>
  p->stopped = 0;
    80001eda:	0e07a423          	sw	zero,232(a5)
  p->main_thread->state = RUNNABLE;
    80001ede:	f307b783          	ld	a5,-208(a5)
    80001ee2:	470d                	li	a4,3
    80001ee4:	c398                	sw	a4,0(a5)
  release(&p->lock);
    80001ee6:	854a                	mv	a0,s2
    80001ee8:	fffff097          	auipc	ra,0xfffff
    80001eec:	d9c080e7          	jalr	-612(ra) # 80000c84 <release>
}
    80001ef0:	70a2                	ld	ra,40(sp)
    80001ef2:	7402                	ld	s0,32(sp)
    80001ef4:	64e2                	ld	s1,24(sp)
    80001ef6:	6942                	ld	s2,16(sp)
    80001ef8:	69a2                	ld	s3,8(sp)
    80001efa:	6145                	addi	sp,sp,48
    80001efc:	8082                	ret

0000000080001efe <growproc>:
{
    80001efe:	1101                	addi	sp,sp,-32
    80001f00:	ec06                	sd	ra,24(sp)
    80001f02:	e822                	sd	s0,16(sp)
    80001f04:	e426                	sd	s1,8(sp)
    80001f06:	e04a                	sd	s2,0(sp)
    80001f08:	1000                	addi	s0,sp,32
    80001f0a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001f0c:	00000097          	auipc	ra,0x0
    80001f10:	aec080e7          	jalr	-1300(ra) # 800019f8 <myproc>
    80001f14:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001f16:	fffff097          	auipc	ra,0xfffff
    80001f1a:	cb4080e7          	jalr	-844(ra) # 80000bca <acquire>
  sz = p->sz;
    80001f1e:	6785                	lui	a5,0x1
    80001f20:	97a6                	add	a5,a5,s1
    80001f22:	f387b583          	ld	a1,-200(a5) # f38 <_entry-0x7ffff0c8>
    80001f26:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001f2a:	03204663          	bgtz	s2,80001f56 <growproc+0x58>
  } else if(n < 0){
    80001f2e:	04094c63          	bltz	s2,80001f86 <growproc+0x88>
  p->sz = sz;
    80001f32:	6785                	lui	a5,0x1
    80001f34:	97a6                	add	a5,a5,s1
    80001f36:	1602                	slli	a2,a2,0x20
    80001f38:	9201                	srli	a2,a2,0x20
    80001f3a:	f2c7bc23          	sd	a2,-200(a5) # f38 <_entry-0x7ffff0c8>
  release(&p->lock);
    80001f3e:	8526                	mv	a0,s1
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	d44080e7          	jalr	-700(ra) # 80000c84 <release>
  return 0;
    80001f48:	4501                	li	a0,0
}
    80001f4a:	60e2                	ld	ra,24(sp)
    80001f4c:	6442                	ld	s0,16(sp)
    80001f4e:	64a2                	ld	s1,8(sp)
    80001f50:	6902                	ld	s2,0(sp)
    80001f52:	6105                	addi	sp,sp,32
    80001f54:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001f56:	00c9063b          	addw	a2,s2,a2
    80001f5a:	6785                	lui	a5,0x1
    80001f5c:	97a6                	add	a5,a5,s1
    80001f5e:	1602                	slli	a2,a2,0x20
    80001f60:	9201                	srli	a2,a2,0x20
    80001f62:	1582                	slli	a1,a1,0x20
    80001f64:	9181                	srli	a1,a1,0x20
    80001f66:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80001f6a:	fffff097          	auipc	ra,0xfffff
    80001f6e:	492080e7          	jalr	1170(ra) # 800013fc <uvmalloc>
    80001f72:	0005061b          	sext.w	a2,a0
    80001f76:	fe55                	bnez	a2,80001f32 <growproc+0x34>
      release(&p->lock);
    80001f78:	8526                	mv	a0,s1
    80001f7a:	fffff097          	auipc	ra,0xfffff
    80001f7e:	d0a080e7          	jalr	-758(ra) # 80000c84 <release>
      return -1;
    80001f82:	557d                	li	a0,-1
    80001f84:	b7d9                	j	80001f4a <growproc+0x4c>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001f86:	00c9063b          	addw	a2,s2,a2
    80001f8a:	6785                	lui	a5,0x1
    80001f8c:	97a6                	add	a5,a5,s1
    80001f8e:	1602                	slli	a2,a2,0x20
    80001f90:	9201                	srli	a2,a2,0x20
    80001f92:	1582                	slli	a1,a1,0x20
    80001f94:	9181                	srli	a1,a1,0x20
    80001f96:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80001f9a:	fffff097          	auipc	ra,0xfffff
    80001f9e:	41a080e7          	jalr	1050(ra) # 800013b4 <uvmdealloc>
    80001fa2:	0005061b          	sext.w	a2,a0
    80001fa6:	b771                	j	80001f32 <growproc+0x34>

0000000080001fa8 <fork>:
{
    80001fa8:	7139                	addi	sp,sp,-64
    80001faa:	fc06                	sd	ra,56(sp)
    80001fac:	f822                	sd	s0,48(sp)
    80001fae:	f426                	sd	s1,40(sp)
    80001fb0:	f04a                	sd	s2,32(sp)
    80001fb2:	ec4e                	sd	s3,24(sp)
    80001fb4:	e852                	sd	s4,16(sp)
    80001fb6:	e456                	sd	s5,8(sp)
    80001fb8:	e05a                	sd	s6,0(sp)
    80001fba:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001fbc:	00000097          	auipc	ra,0x0
    80001fc0:	a3c080e7          	jalr	-1476(ra) # 800019f8 <myproc>
    80001fc4:	8a2a                	mv	s4,a0
  struct thread *t = mythread();
    80001fc6:	00000097          	auipc	ra,0x0
    80001fca:	ab8080e7          	jalr	-1352(ra) # 80001a7e <mythread>
    80001fce:	84aa                	mv	s1,a0
  if((np = allocproc()) == 0){
    80001fd0:	00000097          	auipc	ra,0x0
    80001fd4:	cce080e7          	jalr	-818(ra) # 80001c9e <allocproc>
    80001fd8:	18050a63          	beqz	a0,8000216c <fork+0x1c4>
    80001fdc:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001fde:	6785                	lui	a5,0x1
    80001fe0:	00fa0733          	add	a4,s4,a5
    80001fe4:	97aa                	add	a5,a5,a0
    80001fe6:	f3873603          	ld	a2,-200(a4)
    80001fea:	f407b583          	ld	a1,-192(a5) # f40 <_entry-0x7ffff0c0>
    80001fee:	f4073503          	ld	a0,-192(a4)
    80001ff2:	fffff097          	auipc	ra,0xfffff
    80001ff6:	556080e7          	jalr	1366(ra) # 80001548 <uvmcopy>
    80001ffa:	08054763          	bltz	a0,80002088 <fork+0xe0>
  np->sz = p->sz;
    80001ffe:	6605                	lui	a2,0x1
    80002000:	00ca0733          	add	a4,s4,a2
    80002004:	f3873683          	ld	a3,-200(a4)
    80002008:	00c987b3          	add	a5,s3,a2
    8000200c:	f2d7bc23          	sd	a3,-200(a5)
  np->signalMask = p->signalMask; //inherit signal mask from parent
    80002010:	fe472703          	lw	a4,-28(a4)
    80002014:	fee7a223          	sw	a4,-28(a5)
  for (int i = 0; i<32; i++) //inherit signal handlers from parent
    80002018:	fe860713          	addi	a4,a2,-24 # fe8 <_entry-0x7ffff018>
    8000201c:	00ea07b3          	add	a5,s4,a4
    80002020:	974e                	add	a4,a4,s3
    80002022:	0e860613          	addi	a2,a2,232
    80002026:	9652                	add	a2,a2,s4
    np->signalHandlers[i] = p->signalHandlers[i]; 
    80002028:	6394                	ld	a3,0(a5)
    8000202a:	e314                	sd	a3,0(a4)
  for (int i = 0; i<32; i++) //inherit signal handlers from parent
    8000202c:	07a1                	addi	a5,a5,8
    8000202e:	0721                	addi	a4,a4,8
    80002030:	fec79ce3          	bne	a5,a2,80002028 <fork+0x80>
  *(np->main_thread->trapframe) = *(t->trapframe);
    80002034:	7c94                	ld	a3,56(s1)
    80002036:	6785                	lui	a5,0x1
    80002038:	97ce                	add	a5,a5,s3
    8000203a:	f307b703          	ld	a4,-208(a5) # f30 <_entry-0x7ffff0d0>
    8000203e:	87b6                	mv	a5,a3
    80002040:	7f18                	ld	a4,56(a4)
    80002042:	12068693          	addi	a3,a3,288
    80002046:	0007b803          	ld	a6,0(a5)
    8000204a:	6788                	ld	a0,8(a5)
    8000204c:	6b8c                	ld	a1,16(a5)
    8000204e:	6f90                	ld	a2,24(a5)
    80002050:	01073023          	sd	a6,0(a4)
    80002054:	e708                	sd	a0,8(a4)
    80002056:	eb0c                	sd	a1,16(a4)
    80002058:	ef10                	sd	a2,24(a4)
    8000205a:	02078793          	addi	a5,a5,32
    8000205e:	02070713          	addi	a4,a4,32
    80002062:	fed792e3          	bne	a5,a3,80002046 <fork+0x9e>
  np->main_thread->trapframe->a0 = 0;
    80002066:	6a85                	lui	s5,0x1
    80002068:	015987b3          	add	a5,s3,s5
    8000206c:	f307b783          	ld	a5,-208(a5)
    80002070:	7f9c                	ld	a5,56(a5)
    80002072:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002076:	f48a8913          	addi	s2,s5,-184 # f48 <_entry-0x7ffff0b8>
    8000207a:	012a04b3          	add	s1,s4,s2
    8000207e:	994e                	add	s2,s2,s3
    80002080:	fc8a8a93          	addi	s5,s5,-56
    80002084:	9ad2                	add	s5,s5,s4
    80002086:	a80d                	j	800020b8 <fork+0x110>
    freeproc(np);
    80002088:	854e                	mv	a0,s3
    8000208a:	00000097          	auipc	ra,0x0
    8000208e:	bb4080e7          	jalr	-1100(ra) # 80001c3e <freeproc>
    freethread(np->main_thread);
    80002092:	6785                	lui	a5,0x1
    80002094:	97ce                	add	a5,a5,s3
    80002096:	f307b503          	ld	a0,-208(a5) # f30 <_entry-0x7ffff0d0>
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	780080e7          	jalr	1920(ra) # 8000181a <freethread>
    release(&np->lock);
    800020a2:	854e                	mv	a0,s3
    800020a4:	fffff097          	auipc	ra,0xfffff
    800020a8:	be0080e7          	jalr	-1056(ra) # 80000c84 <release>
    return -1;
    800020ac:	5b7d                	li	s6,-1
    800020ae:	a065                	j	80002156 <fork+0x1ae>
  for(i = 0; i < NOFILE; i++)
    800020b0:	04a1                	addi	s1,s1,8
    800020b2:	0921                	addi	s2,s2,8
    800020b4:	01548b63          	beq	s1,s5,800020ca <fork+0x122>
    if(p->ofile[i])
    800020b8:	6088                	ld	a0,0(s1)
    800020ba:	d97d                	beqz	a0,800020b0 <fork+0x108>
      np->ofile[i] = filedup(p->ofile[i]);
    800020bc:	00003097          	auipc	ra,0x3
    800020c0:	2d6080e7          	jalr	726(ra) # 80005392 <filedup>
    800020c4:	00a93023          	sd	a0,0(s2)
    800020c8:	b7e5                	j	800020b0 <fork+0x108>
  np->cwd = idup(p->cwd);
    800020ca:	6905                	lui	s2,0x1
    800020cc:	012a0ab3          	add	s5,s4,s2
    800020d0:	fc8ab503          	ld	a0,-56(s5)
    800020d4:	00002097          	auipc	ra,0x2
    800020d8:	42c080e7          	jalr	1068(ra) # 80004500 <idup>
    800020dc:	012984b3          	add	s1,s3,s2
    800020e0:	fca4b423          	sd	a0,-56(s1)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800020e4:	fd090513          	addi	a0,s2,-48 # fd0 <_entry-0x7ffff030>
    800020e8:	4641                	li	a2,16
    800020ea:	00aa05b3          	add	a1,s4,a0
    800020ee:	954e                	add	a0,a0,s3
    800020f0:	fffff097          	auipc	ra,0xfffff
    800020f4:	d2e080e7          	jalr	-722(ra) # 80000e1e <safestrcpy>
  pid = np->pid;
    800020f8:	0249ab03          	lw	s6,36(s3)
  release(&np->lock);
    800020fc:	854e                	mv	a0,s3
    800020fe:	fffff097          	auipc	ra,0xfffff
    80002102:	b86080e7          	jalr	-1146(ra) # 80000c84 <release>
  acquire(&wait_lock);
    80002106:	00010917          	auipc	s2,0x10
    8000210a:	1b290913          	addi	s2,s2,434 # 800122b8 <wait_lock>
    8000210e:	854a                	mv	a0,s2
    80002110:	fffff097          	auipc	ra,0xfffff
    80002114:	aba080e7          	jalr	-1350(ra) # 80000bca <acquire>
  np->parent = p;
    80002118:	f344b423          	sd	s4,-216(s1)
  release(&wait_lock);
    8000211c:	854a                	mv	a0,s2
    8000211e:	fffff097          	auipc	ra,0xfffff
    80002122:	b66080e7          	jalr	-1178(ra) # 80000c84 <release>
  acquire(&np->lock);
    80002126:	854e                	mv	a0,s3
    80002128:	fffff097          	auipc	ra,0xfffff
    8000212c:	aa2080e7          	jalr	-1374(ra) # 80000bca <acquire>
  np->pendingSignals = 0;
    80002130:	fe04a023          	sw	zero,-32(s1)
  np->signalMask = p->signalMask;
    80002134:	fe4aa783          	lw	a5,-28(s5)
    80002138:	fef4a223          	sw	a5,-28(s1)
  np->ignore_signals = 0;
    8000213c:	0e04a823          	sw	zero,240(s1)
  np->stopped = 0;
    80002140:	0e04a423          	sw	zero,232(s1)
  np->main_thread->state = RUNNABLE;
    80002144:	f304b783          	ld	a5,-208(s1)
    80002148:	470d                	li	a4,3
    8000214a:	c398                	sw	a4,0(a5)
  release(&np->lock);
    8000214c:	854e                	mv	a0,s3
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	b36080e7          	jalr	-1226(ra) # 80000c84 <release>
}
    80002156:	855a                	mv	a0,s6
    80002158:	70e2                	ld	ra,56(sp)
    8000215a:	7442                	ld	s0,48(sp)
    8000215c:	74a2                	ld	s1,40(sp)
    8000215e:	7902                	ld	s2,32(sp)
    80002160:	69e2                	ld	s3,24(sp)
    80002162:	6a42                	ld	s4,16(sp)
    80002164:	6aa2                	ld	s5,8(sp)
    80002166:	6b02                	ld	s6,0(sp)
    80002168:	6121                	addi	sp,sp,64
    8000216a:	8082                	ret
    return -1;
    8000216c:	5b7d                	li	s6,-1
    8000216e:	b7e5                	j	80002156 <fork+0x1ae>

0000000080002170 <scheduler>:
{
    80002170:	711d                	addi	sp,sp,-96
    80002172:	ec86                	sd	ra,88(sp)
    80002174:	e8a2                	sd	s0,80(sp)
    80002176:	e4a6                	sd	s1,72(sp)
    80002178:	e0ca                	sd	s2,64(sp)
    8000217a:	fc4e                	sd	s3,56(sp)
    8000217c:	f852                	sd	s4,48(sp)
    8000217e:	f456                	sd	s5,40(sp)
    80002180:	f05a                	sd	s6,32(sp)
    80002182:	ec5e                	sd	s7,24(sp)
    80002184:	e862                	sd	s8,16(sp)
    80002186:	e466                	sd	s9,8(sp)
    80002188:	1080                	addi	s0,sp,96
    8000218a:	8792                	mv	a5,tp
  int id = r_tp();
    8000218c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000218e:	00479713          	slli	a4,a5,0x4
    80002192:	00f706b3          	add	a3,a4,a5
    80002196:	00369613          	slli	a2,a3,0x3
    8000219a:	00010697          	auipc	a3,0x10
    8000219e:	10668693          	addi	a3,a3,262 # 800122a0 <pid_lock>
    800021a2:	96b2                	add	a3,a3,a2
    800021a4:	0206b823          	sd	zero,48(a3)
  c->thread = 0;
    800021a8:	0206bc23          	sd	zero,56(a3)
          swtch(&c->context, &t->context);
    800021ac:	00010717          	auipc	a4,0x10
    800021b0:	13470713          	addi	a4,a4,308 # 800122e0 <cpus+0x10>
    800021b4:	00e60c33          	add	s8,a2,a4
          c->thread = t;
    800021b8:	8ab6                	mv	s5,a3
    for(p = proc; p < &proc[NPROC]; p++) {
    800021ba:	6b85                	lui	s7,0x1
    800021bc:	178b8b93          	addi	s7,s7,376 # 1178 <_entry-0x7fffee88>
    800021c0:	00056c97          	auipc	s9,0x56
    800021c4:	398c8c93          	addi	s9,s9,920 # 80058558 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800021c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800021cc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800021d0:	10079073          	csrw	sstatus,a5
    800021d4:	00011917          	auipc	s2,0x11
    800021d8:	4ac90913          	addi	s2,s2,1196 # 80013680 <proc+0xf28>
    800021dc:	00010a17          	auipc	s4,0x10
    800021e0:	57ca0a13          	addi	s4,s4,1404 # 80012758 <proc>
    800021e4:	a099                	j	8000222a <scheduler+0xba>
      for (t = p->threads; t < &p->threads[NTHREAD]; t++){
    800021e6:	1e048493          	addi	s1,s1,480
    800021ea:	03248763          	beq	s1,s2,80002218 <scheduler+0xa8>
        if(t->state == RUNNABLE) {
    800021ee:	409c                	lw	a5,0(s1)
    800021f0:	ff379be3          	bne	a5,s3,800021e6 <scheduler+0x76>
          t->state = RUNNING;
    800021f4:	0164a023          	sw	s6,0(s1)
          c->thread = t;
    800021f8:	029abc23          	sd	s1,56(s5)
          c->proc = p;
    800021fc:	034ab823          	sd	s4,48(s5)
          swtch(&c->context, &t->context);
    80002200:	16048593          	addi	a1,s1,352
    80002204:	8562                	mv	a0,s8
    80002206:	00001097          	auipc	ra,0x1
    8000220a:	010080e7          	jalr	16(ra) # 80003216 <swtch>
          c->proc = 0;
    8000220e:	020ab823          	sd	zero,48(s5)
          c->thread = 0;
    80002212:	020abc23          	sd	zero,56(s5)
    80002216:	bfc1                	j	800021e6 <scheduler+0x76>
       release(&p->lock);
    80002218:	8552                	mv	a0,s4
    8000221a:	fffff097          	auipc	ra,0xfffff
    8000221e:	a6a080e7          	jalr	-1430(ra) # 80000c84 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002222:	9a5e                	add	s4,s4,s7
    80002224:	995e                	add	s2,s2,s7
    80002226:	fb9a01e3          	beq	s4,s9,800021c8 <scheduler+0x58>
      acquire(&p->lock);
    8000222a:	8552                	mv	a0,s4
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	99e080e7          	jalr	-1634(ra) # 80000bca <acquire>
      for (t = p->threads; t < &p->threads[NTHREAD]; t++){
    80002234:	028a0493          	addi	s1,s4,40
        if(t->state == RUNNABLE) {
    80002238:	498d                	li	s3,3
          t->state = RUNNING;
    8000223a:	4b11                	li	s6,4
    8000223c:	bf4d                	j	800021ee <scheduler+0x7e>

000000008000223e <sched>:
{
    8000223e:	7179                	addi	sp,sp,-48
    80002240:	f406                	sd	ra,40(sp)
    80002242:	f022                	sd	s0,32(sp)
    80002244:	ec26                	sd	s1,24(sp)
    80002246:	e84a                	sd	s2,16(sp)
    80002248:	e44e                	sd	s3,8(sp)
    8000224a:	1800                	addi	s0,sp,48
  struct thread *t = mythread();
    8000224c:	00000097          	auipc	ra,0x0
    80002250:	832080e7          	jalr	-1998(ra) # 80001a7e <mythread>
    80002254:	84aa                	mv	s1,a0
  if(!holding(&t->proc_parent->lock))
    80002256:	7508                	ld	a0,40(a0)
    80002258:	fffff097          	auipc	ra,0xfffff
    8000225c:	8f0080e7          	jalr	-1808(ra) # 80000b48 <holding>
    80002260:	c959                	beqz	a0,800022f6 <sched+0xb8>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002262:	8792                	mv	a5,tp
  if(mycpu()->noff != 1){
    80002264:	0007871b          	sext.w	a4,a5
    80002268:	00471793          	slli	a5,a4,0x4
    8000226c:	97ba                	add	a5,a5,a4
    8000226e:	078e                	slli	a5,a5,0x3
    80002270:	00010717          	auipc	a4,0x10
    80002274:	03070713          	addi	a4,a4,48 # 800122a0 <pid_lock>
    80002278:	97ba                	add	a5,a5,a4
    8000227a:	0b07a703          	lw	a4,176(a5)
    8000227e:	4785                	li	a5,1
    80002280:	08f71363          	bne	a4,a5,80002306 <sched+0xc8>
  if(t->state == RUNNING)
    80002284:	4098                	lw	a4,0(s1)
    80002286:	4791                	li	a5,4
    80002288:	08f70763          	beq	a4,a5,80002316 <sched+0xd8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000228c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002290:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002292:	ebd1                	bnez	a5,80002326 <sched+0xe8>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002294:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002296:	00010917          	auipc	s2,0x10
    8000229a:	00a90913          	addi	s2,s2,10 # 800122a0 <pid_lock>
    8000229e:	0007871b          	sext.w	a4,a5
    800022a2:	00471793          	slli	a5,a4,0x4
    800022a6:	97ba                	add	a5,a5,a4
    800022a8:	078e                	slli	a5,a5,0x3
    800022aa:	97ca                	add	a5,a5,s2
    800022ac:	0b47a983          	lw	s3,180(a5)
    800022b0:	8792                	mv	a5,tp
  swtch(&t->context, &mycpu()->context);
    800022b2:	0007859b          	sext.w	a1,a5
    800022b6:	00459793          	slli	a5,a1,0x4
    800022ba:	97ae                	add	a5,a5,a1
    800022bc:	078e                	slli	a5,a5,0x3
    800022be:	00010597          	auipc	a1,0x10
    800022c2:	02258593          	addi	a1,a1,34 # 800122e0 <cpus+0x10>
    800022c6:	95be                	add	a1,a1,a5
    800022c8:	16048513          	addi	a0,s1,352
    800022cc:	00001097          	auipc	ra,0x1
    800022d0:	f4a080e7          	jalr	-182(ra) # 80003216 <swtch>
    800022d4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800022d6:	0007871b          	sext.w	a4,a5
    800022da:	00471793          	slli	a5,a4,0x4
    800022de:	97ba                	add	a5,a5,a4
    800022e0:	078e                	slli	a5,a5,0x3
    800022e2:	97ca                	add	a5,a5,s2
    800022e4:	0b37aa23          	sw	s3,180(a5)
}
    800022e8:	70a2                	ld	ra,40(sp)
    800022ea:	7402                	ld	s0,32(sp)
    800022ec:	64e2                	ld	s1,24(sp)
    800022ee:	6942                	ld	s2,16(sp)
    800022f0:	69a2                	ld	s3,8(sp)
    800022f2:	6145                	addi	sp,sp,48
    800022f4:	8082                	ret
    panic("sched p->lock");
    800022f6:	00007517          	auipc	a0,0x7
    800022fa:	f0a50513          	addi	a0,a0,-246 # 80009200 <digits+0x1c0>
    800022fe:	ffffe097          	auipc	ra,0xffffe
    80002302:	22c080e7          	jalr	556(ra) # 8000052a <panic>
    panic("sched locks");
    80002306:	00007517          	auipc	a0,0x7
    8000230a:	f0a50513          	addi	a0,a0,-246 # 80009210 <digits+0x1d0>
    8000230e:	ffffe097          	auipc	ra,0xffffe
    80002312:	21c080e7          	jalr	540(ra) # 8000052a <panic>
    panic("sched running");
    80002316:	00007517          	auipc	a0,0x7
    8000231a:	f0a50513          	addi	a0,a0,-246 # 80009220 <digits+0x1e0>
    8000231e:	ffffe097          	auipc	ra,0xffffe
    80002322:	20c080e7          	jalr	524(ra) # 8000052a <panic>
    panic("sched interruptible");
    80002326:	00007517          	auipc	a0,0x7
    8000232a:	f0a50513          	addi	a0,a0,-246 # 80009230 <digits+0x1f0>
    8000232e:	ffffe097          	auipc	ra,0xffffe
    80002332:	1fc080e7          	jalr	508(ra) # 8000052a <panic>

0000000080002336 <yield>:
{
    80002336:	1101                	addi	sp,sp,-32
    80002338:	ec06                	sd	ra,24(sp)
    8000233a:	e822                	sd	s0,16(sp)
    8000233c:	e426                	sd	s1,8(sp)
    8000233e:	1000                	addi	s0,sp,32
  struct thread *t = mythread();
    80002340:	fffff097          	auipc	ra,0xfffff
    80002344:	73e080e7          	jalr	1854(ra) # 80001a7e <mythread>
    80002348:	84aa                	mv	s1,a0
  acquire(&t->proc_parent->lock);
    8000234a:	7508                	ld	a0,40(a0)
    8000234c:	fffff097          	auipc	ra,0xfffff
    80002350:	87e080e7          	jalr	-1922(ra) # 80000bca <acquire>
  t->state = RUNNABLE;
    80002354:	478d                	li	a5,3
    80002356:	c09c                	sw	a5,0(s1)
  sched();
    80002358:	00000097          	auipc	ra,0x0
    8000235c:	ee6080e7          	jalr	-282(ra) # 8000223e <sched>
  release(&t->proc_parent->lock);
    80002360:	7488                	ld	a0,40(s1)
    80002362:	fffff097          	auipc	ra,0xfffff
    80002366:	922080e7          	jalr	-1758(ra) # 80000c84 <release>
}
    8000236a:	60e2                	ld	ra,24(sp)
    8000236c:	6442                	ld	s0,16(sp)
    8000236e:	64a2                	ld	s1,8(sp)
    80002370:	6105                	addi	sp,sp,32
    80002372:	8082                	ret

0000000080002374 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002374:	7179                	addi	sp,sp,-48
    80002376:	f406                	sd	ra,40(sp)
    80002378:	f022                	sd	s0,32(sp)
    8000237a:	ec26                	sd	s1,24(sp)
    8000237c:	e84a                	sd	s2,16(sp)
    8000237e:	e44e                	sd	s3,8(sp)
    80002380:	1800                	addi	s0,sp,48
    80002382:	89aa                	mv	s3,a0
    80002384:	892e                	mv	s2,a1
  //printf("debug: lock:%s starting sleep function\n", lk->name);
  struct thread *t = mythread();
    80002386:	fffff097          	auipc	ra,0xfffff
    8000238a:	6f8080e7          	jalr	1784(ra) # 80001a7e <mythread>
    8000238e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&t->proc_parent->lock);  //DOC: sleeplock1
    80002390:	7508                	ld	a0,40(a0)
    80002392:	fffff097          	auipc	ra,0xfffff
    80002396:	838080e7          	jalr	-1992(ra) # 80000bca <acquire>
  release(lk);
    8000239a:	854a                	mv	a0,s2
    8000239c:	fffff097          	auipc	ra,0xfffff
    800023a0:	8e8080e7          	jalr	-1816(ra) # 80000c84 <release>

  // Go to sleep.
  t->chan = chan;
    800023a4:	0134b423          	sd	s3,8(s1)
  t->state = SLEEPING;
    800023a8:	4789                	li	a5,2
    800023aa:	c09c                	sw	a5,0(s1)
  //printf(" tid %d go to sleep\n", t->tid);
  sched();
    800023ac:	00000097          	auipc	ra,0x0
    800023b0:	e92080e7          	jalr	-366(ra) # 8000223e <sched>
  //printf("debug: lock:%s finish to sleep\n", lk->name);

  // Tidy up.
  t->chan = 0;
    800023b4:	0004b423          	sd	zero,8(s1)

  // Reacquire original lock.
  release(&t->proc_parent->lock);
    800023b8:	7488                	ld	a0,40(s1)
    800023ba:	fffff097          	auipc	ra,0xfffff
    800023be:	8ca080e7          	jalr	-1846(ra) # 80000c84 <release>
  acquire(lk);
    800023c2:	854a                	mv	a0,s2
    800023c4:	fffff097          	auipc	ra,0xfffff
    800023c8:	806080e7          	jalr	-2042(ra) # 80000bca <acquire>
  //printf("debug: exit from sleep function\n");
}
    800023cc:	70a2                	ld	ra,40(sp)
    800023ce:	7402                	ld	s0,32(sp)
    800023d0:	64e2                	ld	s1,24(sp)
    800023d2:	6942                	ld	s2,16(sp)
    800023d4:	69a2                	ld	s3,8(sp)
    800023d6:	6145                	addi	sp,sp,48
    800023d8:	8082                	ret

00000000800023da <wait>:
{
    800023da:	711d                	addi	sp,sp,-96
    800023dc:	ec86                	sd	ra,88(sp)
    800023de:	e8a2                	sd	s0,80(sp)
    800023e0:	e4a6                	sd	s1,72(sp)
    800023e2:	e0ca                	sd	s2,64(sp)
    800023e4:	fc4e                	sd	s3,56(sp)
    800023e6:	f852                	sd	s4,48(sp)
    800023e8:	f456                	sd	s5,40(sp)
    800023ea:	f05a                	sd	s6,32(sp)
    800023ec:	ec5e                	sd	s7,24(sp)
    800023ee:	e862                	sd	s8,16(sp)
    800023f0:	e466                	sd	s9,8(sp)
    800023f2:	1080                	addi	s0,sp,96
    800023f4:	8c2a                	mv	s8,a0
  struct proc *p = myproc();
    800023f6:	fffff097          	auipc	ra,0xfffff
    800023fa:	602080e7          	jalr	1538(ra) # 800019f8 <myproc>
    800023fe:	89aa                	mv	s3,a0
  acquire(&wait_lock);
    80002400:	00010517          	auipc	a0,0x10
    80002404:	eb850513          	addi	a0,a0,-328 # 800122b8 <wait_lock>
    80002408:	ffffe097          	auipc	ra,0xffffe
    8000240c:	7c2080e7          	jalr	1986(ra) # 80000bca <acquire>
    80002410:	6a05                	lui	s4,0x1
    80002412:	f28a0a93          	addi	s5,s4,-216 # f28 <_entry-0x7ffff0d8>
        if(np->state == ZOMBIE){
    80002416:	4b95                	li	s7,5
    for(np = proc; np < &proc[NPROC]; np++){
    80002418:	178a0a13          	addi	s4,s4,376
    8000241c:	00056b17          	auipc	s6,0x56
    80002420:	13cb0b13          	addi	s6,s6,316 # 80058558 <tickslock>
    havekids = 0;
    80002424:	4701                	li	a4,0
    for(np = proc; np < &proc[NPROC]; np++){
    80002426:	00010497          	auipc	s1,0x10
    8000242a:	33248493          	addi	s1,s1,818 # 80012758 <proc>
        havekids = 1;
    8000242e:	4c85                	li	s9,1
    80002430:	a841                	j	800024c0 <wait+0xe6>
          pid = np->pid;
    80002432:	0244aa03          	lw	s4,36(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002436:	000c1563          	bnez	s8,80002440 <wait+0x66>
          for(tt = np->threads; tt<&np->threads[NTHREAD]; tt++){
    8000243a:	02848993          	addi	s3,s1,40
    8000243e:	a091                	j	80002482 <wait+0xa8>
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002440:	6785                	lui	a5,0x1
    80002442:	99be                	add	s3,s3,a5
    80002444:	4691                	li	a3,4
    80002446:	02048613          	addi	a2,s1,32
    8000244a:	85e2                	mv	a1,s8
    8000244c:	f409b503          	ld	a0,-192(s3)
    80002450:	fffff097          	auipc	ra,0xfffff
    80002454:	1fc080e7          	jalr	508(ra) # 8000164c <copyout>
    80002458:	fe0551e3          	bgez	a0,8000243a <wait+0x60>
            release(&np->lock);
    8000245c:	8526                	mv	a0,s1
    8000245e:	fffff097          	auipc	ra,0xfffff
    80002462:	826080e7          	jalr	-2010(ra) # 80000c84 <release>
            release(&wait_lock);
    80002466:	00010517          	auipc	a0,0x10
    8000246a:	e5250513          	addi	a0,a0,-430 # 800122b8 <wait_lock>
    8000246e:	fffff097          	auipc	ra,0xfffff
    80002472:	816080e7          	jalr	-2026(ra) # 80000c84 <release>
            return -1;
    80002476:	5a7d                	li	s4,-1
    80002478:	a071                	j	80002504 <wait+0x12a>
          for(tt = np->threads; tt<&np->threads[NTHREAD]; tt++){
    8000247a:	1e098993          	addi	s3,s3,480
    8000247e:	01298b63          	beq	s3,s2,80002494 <wait+0xba>
            if(tt->state != UNUSED)
    80002482:	0009a783          	lw	a5,0(s3)
    80002486:	dbf5                	beqz	a5,8000247a <wait+0xa0>
              freethread(tt);
    80002488:	854e                	mv	a0,s3
    8000248a:	fffff097          	auipc	ra,0xfffff
    8000248e:	390080e7          	jalr	912(ra) # 8000181a <freethread>
    80002492:	b7e5                	j	8000247a <wait+0xa0>
          freeproc(np);
    80002494:	8526                	mv	a0,s1
    80002496:	fffff097          	auipc	ra,0xfffff
    8000249a:	7a8080e7          	jalr	1960(ra) # 80001c3e <freeproc>
          release(&np->lock);
    8000249e:	8526                	mv	a0,s1
    800024a0:	ffffe097          	auipc	ra,0xffffe
    800024a4:	7e4080e7          	jalr	2020(ra) # 80000c84 <release>
          release(&wait_lock);
    800024a8:	00010517          	auipc	a0,0x10
    800024ac:	e1050513          	addi	a0,a0,-496 # 800122b8 <wait_lock>
    800024b0:	ffffe097          	auipc	ra,0xffffe
    800024b4:	7d4080e7          	jalr	2004(ra) # 80000c84 <release>
          return pid;
    800024b8:	a0b1                	j	80002504 <wait+0x12a>
    for(np = proc; np < &proc[NPROC]; np++){
    800024ba:	94d2                	add	s1,s1,s4
    800024bc:	03648763          	beq	s1,s6,800024ea <wait+0x110>
      if(np->parent == p){
    800024c0:	01548933          	add	s2,s1,s5
    800024c4:	00093783          	ld	a5,0(s2)
    800024c8:	ff3799e3          	bne	a5,s3,800024ba <wait+0xe0>
        acquire(&np->lock);
    800024cc:	8526                	mv	a0,s1
    800024ce:	ffffe097          	auipc	ra,0xffffe
    800024d2:	6fc080e7          	jalr	1788(ra) # 80000bca <acquire>
        if(np->state == ZOMBIE){
    800024d6:	4c9c                	lw	a5,24(s1)
    800024d8:	f5778de3          	beq	a5,s7,80002432 <wait+0x58>
        release(&np->lock);
    800024dc:	8526                	mv	a0,s1
    800024de:	ffffe097          	auipc	ra,0xffffe
    800024e2:	7a6080e7          	jalr	1958(ra) # 80000c84 <release>
        havekids = 1;
    800024e6:	8766                	mv	a4,s9
    800024e8:	bfc9                	j	800024ba <wait+0xe0>
    if(!havekids || p->killed){
    800024ea:	c701                	beqz	a4,800024f2 <wait+0x118>
    800024ec:	01c9a783          	lw	a5,28(s3)
    800024f0:	cb85                	beqz	a5,80002520 <wait+0x146>
      release(&wait_lock);
    800024f2:	00010517          	auipc	a0,0x10
    800024f6:	dc650513          	addi	a0,a0,-570 # 800122b8 <wait_lock>
    800024fa:	ffffe097          	auipc	ra,0xffffe
    800024fe:	78a080e7          	jalr	1930(ra) # 80000c84 <release>
      return -1;
    80002502:	5a7d                	li	s4,-1
}
    80002504:	8552                	mv	a0,s4
    80002506:	60e6                	ld	ra,88(sp)
    80002508:	6446                	ld	s0,80(sp)
    8000250a:	64a6                	ld	s1,72(sp)
    8000250c:	6906                	ld	s2,64(sp)
    8000250e:	79e2                	ld	s3,56(sp)
    80002510:	7a42                	ld	s4,48(sp)
    80002512:	7aa2                	ld	s5,40(sp)
    80002514:	7b02                	ld	s6,32(sp)
    80002516:	6be2                	ld	s7,24(sp)
    80002518:	6c42                	ld	s8,16(sp)
    8000251a:	6ca2                	ld	s9,8(sp)
    8000251c:	6125                	addi	sp,sp,96
    8000251e:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002520:	00010597          	auipc	a1,0x10
    80002524:	d9858593          	addi	a1,a1,-616 # 800122b8 <wait_lock>
    80002528:	854e                	mv	a0,s3
    8000252a:	00000097          	auipc	ra,0x0
    8000252e:	e4a080e7          	jalr	-438(ra) # 80002374 <sleep>
    havekids = 0;
    80002532:	bdcd                	j	80002424 <wait+0x4a>

0000000080002534 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002534:	711d                	addi	sp,sp,-96
    80002536:	ec86                	sd	ra,88(sp)
    80002538:	e8a2                	sd	s0,80(sp)
    8000253a:	e4a6                	sd	s1,72(sp)
    8000253c:	e0ca                	sd	s2,64(sp)
    8000253e:	fc4e                	sd	s3,56(sp)
    80002540:	f852                	sd	s4,48(sp)
    80002542:	f456                	sd	s5,40(sp)
    80002544:	f05a                	sd	s6,32(sp)
    80002546:	ec5e                	sd	s7,24(sp)
    80002548:	e862                	sd	s8,16(sp)
    8000254a:	e466                	sd	s9,8(sp)
    8000254c:	e06a                	sd	s10,0(sp)
    8000254e:	1080                	addi	s0,sp,96
    80002550:	8aaa                	mv	s5,a0
  //printf("debug: starting wakeup\n");
  struct proc *p;
  struct thread *t;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002552:	00011917          	auipc	s2,0x11
    80002556:	12e90913          	addi	s2,s2,302 # 80013680 <proc+0xf28>
    8000255a:	00057c97          	auipc	s9,0x57
    8000255e:	f26c8c93          	addi	s9,s9,-218 # 80059480 <bcache+0xf10>
    80002562:	7b7d                	lui	s6,0xfffff
    80002564:	0d8b0c13          	addi	s8,s6,216 # fffffffffffff0d8 <end+0xffffffff7ff980d8>
    80002568:	100b0b13          	addi	s6,s6,256
    acquire(&p->lock);
    for (t = p->threads; t < &p->threads[NTHREAD]; t++){
      if (t != mythread()){
        if(t->state == SLEEPING && t->chan == chan) {
    8000256c:	4989                	li	s3,2
          t->state = RUNNABLE;
    8000256e:	4d0d                	li	s10,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002570:	6b85                	lui	s7,0x1
    80002572:	178b8b93          	addi	s7,s7,376 # 1178 <_entry-0x7fffee88>
    80002576:	a825                	j	800025ae <wakeup+0x7a>
    for (t = p->threads; t < &p->threads[NTHREAD]; t++){
    80002578:	1e048493          	addi	s1,s1,480
    8000257c:	03248163          	beq	s1,s2,8000259e <wakeup+0x6a>
      if (t != mythread()){
    80002580:	fffff097          	auipc	ra,0xfffff
    80002584:	4fe080e7          	jalr	1278(ra) # 80001a7e <mythread>
    80002588:	fea488e3          	beq	s1,a0,80002578 <wakeup+0x44>
        if(t->state == SLEEPING && t->chan == chan) {
    8000258c:	409c                	lw	a5,0(s1)
    8000258e:	ff3795e3          	bne	a5,s3,80002578 <wakeup+0x44>
    80002592:	649c                	ld	a5,8(s1)
    80002594:	ff5792e3          	bne	a5,s5,80002578 <wakeup+0x44>
          t->state = RUNNABLE;
    80002598:	01a4a023          	sw	s10,0(s1)
    8000259c:	bff1                	j	80002578 <wakeup+0x44>
        }
      }
    }
    release(&p->lock);
    8000259e:	8552                	mv	a0,s4
    800025a0:	ffffe097          	auipc	ra,0xffffe
    800025a4:	6e4080e7          	jalr	1764(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800025a8:	995e                	add	s2,s2,s7
    800025aa:	01990c63          	beq	s2,s9,800025c2 <wakeup+0x8e>
    acquire(&p->lock);
    800025ae:	01890a33          	add	s4,s2,s8
    800025b2:	8552                	mv	a0,s4
    800025b4:	ffffe097          	auipc	ra,0xffffe
    800025b8:	616080e7          	jalr	1558(ra) # 80000bca <acquire>
    for (t = p->threads; t < &p->threads[NTHREAD]; t++){
    800025bc:	016904b3          	add	s1,s2,s6
    800025c0:	b7c1                	j	80002580 <wakeup+0x4c>
    
  }
  //printf("debug: finishing wakeup\n");

}
    800025c2:	60e6                	ld	ra,88(sp)
    800025c4:	6446                	ld	s0,80(sp)
    800025c6:	64a6                	ld	s1,72(sp)
    800025c8:	6906                	ld	s2,64(sp)
    800025ca:	79e2                	ld	s3,56(sp)
    800025cc:	7a42                	ld	s4,48(sp)
    800025ce:	7aa2                	ld	s5,40(sp)
    800025d0:	7b02                	ld	s6,32(sp)
    800025d2:	6be2                	ld	s7,24(sp)
    800025d4:	6c42                	ld	s8,16(sp)
    800025d6:	6ca2                	ld	s9,8(sp)
    800025d8:	6d02                	ld	s10,0(sp)
    800025da:	6125                	addi	sp,sp,96
    800025dc:	8082                	ret

00000000800025de <reparent>:
{
    800025de:	7139                	addi	sp,sp,-64
    800025e0:	fc06                	sd	ra,56(sp)
    800025e2:	f822                	sd	s0,48(sp)
    800025e4:	f426                	sd	s1,40(sp)
    800025e6:	f04a                	sd	s2,32(sp)
    800025e8:	ec4e                	sd	s3,24(sp)
    800025ea:	e852                	sd	s4,16(sp)
    800025ec:	e456                	sd	s5,8(sp)
    800025ee:	e05a                	sd	s6,0(sp)
    800025f0:	0080                	addi	s0,sp,64
    800025f2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800025f4:	00011497          	auipc	s1,0x11
    800025f8:	08c48493          	addi	s1,s1,140 # 80013680 <proc+0xf28>
    800025fc:	00057a17          	auipc	s4,0x57
    80002600:	e84a0a13          	addi	s4,s4,-380 # 80059480 <bcache+0xf10>
      pp->parent = initproc;
    80002604:	00008b17          	auipc	s6,0x8
    80002608:	a24b0b13          	addi	s6,s6,-1500 # 8000a028 <initproc>
      wakeup(initproc->main_thread);
    8000260c:	6a85                	lui	s5,0x1
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000260e:	178a8993          	addi	s3,s5,376 # 1178 <_entry-0x7fffee88>
    80002612:	a021                	j	8000261a <reparent+0x3c>
    80002614:	94ce                	add	s1,s1,s3
    80002616:	03448063          	beq	s1,s4,80002636 <reparent+0x58>
    if(pp->parent == p){
    8000261a:	609c                	ld	a5,0(s1)
    8000261c:	ff279ce3          	bne	a5,s2,80002614 <reparent+0x36>
      pp->parent = initproc;
    80002620:	000b3783          	ld	a5,0(s6)
    80002624:	e09c                	sd	a5,0(s1)
      wakeup(initproc->main_thread);
    80002626:	97d6                	add	a5,a5,s5
    80002628:	f307b503          	ld	a0,-208(a5) # f30 <_entry-0x7ffff0d0>
    8000262c:	00000097          	auipc	ra,0x0
    80002630:	f08080e7          	jalr	-248(ra) # 80002534 <wakeup>
    80002634:	b7c5                	j	80002614 <reparent+0x36>
}
    80002636:	70e2                	ld	ra,56(sp)
    80002638:	7442                	ld	s0,48(sp)
    8000263a:	74a2                	ld	s1,40(sp)
    8000263c:	7902                	ld	s2,32(sp)
    8000263e:	69e2                	ld	s3,24(sp)
    80002640:	6a42                	ld	s4,16(sp)
    80002642:	6aa2                	ld	s5,8(sp)
    80002644:	6b02                	ld	s6,0(sp)
    80002646:	6121                	addi	sp,sp,64
    80002648:	8082                	ret

000000008000264a <Treparent>:
{
    8000264a:	7139                	addi	sp,sp,-64
    8000264c:	fc06                	sd	ra,56(sp)
    8000264e:	f822                	sd	s0,48(sp)
    80002650:	f426                	sd	s1,40(sp)
    80002652:	f04a                	sd	s2,32(sp)
    80002654:	ec4e                	sd	s3,24(sp)
    80002656:	e852                	sd	s4,16(sp)
    80002658:	e456                	sd	s5,8(sp)
    8000265a:	0080                	addi	s0,sp,64
    8000265c:	892a                	mv	s2,a0
  struct proc *p = t->proc_parent;
    8000265e:	02853a03          	ld	s4,40(a0)
  for(tt = p->threads; tt < &p->threads[NTHREAD]; tt++){
    80002662:	028a0493          	addi	s1,s4,40
    80002666:	6985                	lui	s3,0x1
    80002668:	f2898993          	addi	s3,s3,-216 # f28 <_entry-0x7ffff0d8>
    8000266c:	99d2                	add	s3,s3,s4
    if(tt->thread_parent == t && t!=p->main_thread){
    8000266e:	6785                	lui	a5,0x1
    80002670:	9a3e                	add	s4,s4,a5
      printf("found a children\n");
    80002672:	00007a97          	auipc	s5,0x7
    80002676:	bd6a8a93          	addi	s5,s5,-1066 # 80009248 <digits+0x208>
    8000267a:	a821                	j	80002692 <Treparent+0x48>
      p->main_thread = tt;
    8000267c:	f29a3823          	sd	s1,-208(s4)
      printf("found a children\n");
    80002680:	8556                	mv	a0,s5
    80002682:	ffffe097          	auipc	ra,0xffffe
    80002686:	ef2080e7          	jalr	-270(ra) # 80000574 <printf>
  for(tt = p->threads; tt < &p->threads[NTHREAD]; tt++){
    8000268a:	1e048493          	addi	s1,s1,480
    8000268e:	00998f63          	beq	s3,s1,800026ac <Treparent+0x62>
    if(tt->thread_parent == t && t!=p->main_thread){
    80002692:	709c                	ld	a5,32(s1)
    80002694:	ff279be3          	bne	a5,s2,8000268a <Treparent+0x40>
    80002698:	f30a3503          	ld	a0,-208(s4)
    8000269c:	ff2500e3          	beq	a0,s2,8000267c <Treparent+0x32>
      tt->thread_parent = p->main_thread;
    800026a0:	f088                	sd	a0,32(s1)
      wakeup(p->main_thread);
    800026a2:	00000097          	auipc	ra,0x0
    800026a6:	e92080e7          	jalr	-366(ra) # 80002534 <wakeup>
    800026aa:	b7c5                	j	8000268a <Treparent+0x40>
}
    800026ac:	70e2                	ld	ra,56(sp)
    800026ae:	7442                	ld	s0,48(sp)
    800026b0:	74a2                	ld	s1,40(sp)
    800026b2:	7902                	ld	s2,32(sp)
    800026b4:	69e2                	ld	s3,24(sp)
    800026b6:	6a42                	ld	s4,16(sp)
    800026b8:	6aa2                	ld	s5,8(sp)
    800026ba:	6121                	addi	sp,sp,64
    800026bc:	8082                	ret

00000000800026be <exit>:
{
    800026be:	7139                	addi	sp,sp,-64
    800026c0:	fc06                	sd	ra,56(sp)
    800026c2:	f822                	sd	s0,48(sp)
    800026c4:	f426                	sd	s1,40(sp)
    800026c6:	f04a                	sd	s2,32(sp)
    800026c8:	ec4e                	sd	s3,24(sp)
    800026ca:	e852                	sd	s4,16(sp)
    800026cc:	e456                	sd	s5,8(sp)
    800026ce:	0080                	addi	s0,sp,64
    800026d0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800026d2:	fffff097          	auipc	ra,0xfffff
    800026d6:	326080e7          	jalr	806(ra) # 800019f8 <myproc>
  if(p == initproc)
    800026da:	00008797          	auipc	a5,0x8
    800026de:	94e7b783          	ld	a5,-1714(a5) # 8000a028 <initproc>
    800026e2:	02a78463          	beq	a5,a0,8000270a <exit+0x4c>
    800026e6:	89aa                	mv	s3,a0
  printf("inside exit for pid %d\n", p->pid);
    800026e8:	514c                	lw	a1,36(a0)
    800026ea:	00007517          	auipc	a0,0x7
    800026ee:	b8650513          	addi	a0,a0,-1146 # 80009270 <digits+0x230>
    800026f2:	ffffe097          	auipc	ra,0xffffe
    800026f6:	e82080e7          	jalr	-382(ra) # 80000574 <printf>
  for(int fd = 0; fd < NOFILE; fd++){
    800026fa:	6905                	lui	s2,0x1
    800026fc:	f4890493          	addi	s1,s2,-184 # f48 <_entry-0x7ffff0b8>
    80002700:	94ce                	add	s1,s1,s3
    80002702:	fc890913          	addi	s2,s2,-56
    80002706:	994e                	add	s2,s2,s3
    80002708:	a015                	j	8000272c <exit+0x6e>
    panic("init exiting");
    8000270a:	00007517          	auipc	a0,0x7
    8000270e:	b5650513          	addi	a0,a0,-1194 # 80009260 <digits+0x220>
    80002712:	ffffe097          	auipc	ra,0xffffe
    80002716:	e18080e7          	jalr	-488(ra) # 8000052a <panic>
      fileclose(f);
    8000271a:	00003097          	auipc	ra,0x3
    8000271e:	cca080e7          	jalr	-822(ra) # 800053e4 <fileclose>
      p->ofile[fd] = 0;
    80002722:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002726:	04a1                	addi	s1,s1,8
    80002728:	01248563          	beq	s1,s2,80002732 <exit+0x74>
    if(p->ofile[fd]){
    8000272c:	6088                	ld	a0,0(s1)
    8000272e:	f575                	bnez	a0,8000271a <exit+0x5c>
    80002730:	bfdd                	j	80002726 <exit+0x68>
  begin_op();
    80002732:	00002097          	auipc	ra,0x2
    80002736:	7e6080e7          	jalr	2022(ra) # 80004f18 <begin_op>
  iput(p->cwd);
    8000273a:	6905                	lui	s2,0x1
    8000273c:	012984b3          	add	s1,s3,s2
    80002740:	fc84b503          	ld	a0,-56(s1)
    80002744:	00002097          	auipc	ra,0x2
    80002748:	fb4080e7          	jalr	-76(ra) # 800046f8 <iput>
  end_op();
    8000274c:	00003097          	auipc	ra,0x3
    80002750:	84c080e7          	jalr	-1972(ra) # 80004f98 <end_op>
  p->cwd = 0;
    80002754:	fc04b423          	sd	zero,-56(s1)
  acquire(&wait_lock);
    80002758:	00010517          	auipc	a0,0x10
    8000275c:	b6050513          	addi	a0,a0,-1184 # 800122b8 <wait_lock>
    80002760:	ffffe097          	auipc	ra,0xffffe
    80002764:	46a080e7          	jalr	1130(ra) # 80000bca <acquire>
  reparent(p);
    80002768:	854e                	mv	a0,s3
    8000276a:	00000097          	auipc	ra,0x0
    8000276e:	e74080e7          	jalr	-396(ra) # 800025de <reparent>
  wakeup(p->parent);
    80002772:	f284b503          	ld	a0,-216(s1)
    80002776:	00000097          	auipc	ra,0x0
    8000277a:	dbe080e7          	jalr	-578(ra) # 80002534 <wakeup>
  for(t=p->threads; t < &p->threads[NTHREAD]; t++){
    8000277e:	02898493          	addi	s1,s3,40
    80002782:	f2890913          	addi	s2,s2,-216 # f28 <_entry-0x7ffff0d8>
    80002786:	994e                	add	s2,s2,s3
    t->state = ZOMBIE;
    80002788:	4a95                	li	s5,5
    8000278a:	0154a023          	sw	s5,0(s1)
    wakeup(t);
    8000278e:	8526                	mv	a0,s1
    80002790:	00000097          	auipc	ra,0x0
    80002794:	da4080e7          	jalr	-604(ra) # 80002534 <wakeup>
  for(t=p->threads; t < &p->threads[NTHREAD]; t++){
    80002798:	1e048493          	addi	s1,s1,480
    8000279c:	fe9917e3          	bne	s2,s1,8000278a <exit+0xcc>
  acquire(&p->lock);
    800027a0:	854e                	mv	a0,s3
    800027a2:	ffffe097          	auipc	ra,0xffffe
    800027a6:	428080e7          	jalr	1064(ra) # 80000bca <acquire>
  p->xstate = status;
    800027aa:	0349a023          	sw	s4,32(s3)
  p->state = ZOMBIE;
    800027ae:	4795                	li	a5,5
    800027b0:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800027b4:	00010517          	auipc	a0,0x10
    800027b8:	b0450513          	addi	a0,a0,-1276 # 800122b8 <wait_lock>
    800027bc:	ffffe097          	auipc	ra,0xffffe
    800027c0:	4c8080e7          	jalr	1224(ra) # 80000c84 <release>
  sched();
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	a7a080e7          	jalr	-1414(ra) # 8000223e <sched>
  panic("zombie exit");
    800027cc:	00007517          	auipc	a0,0x7
    800027d0:	abc50513          	addi	a0,a0,-1348 # 80009288 <digits+0x248>
    800027d4:	ffffe097          	auipc	ra,0xffffe
    800027d8:	d56080e7          	jalr	-682(ra) # 8000052a <panic>

00000000800027dc <kill>:
{
  //printf("debug: starting kill function\n");
  struct proc *p;
  struct thread *t;

  if(signum >= SIGNALS_SIZE || signum < 0) return -1;
    800027dc:	47fd                	li	a5,31
    800027de:	0cb7e263          	bltu	a5,a1,800028a2 <kill+0xc6>
{
    800027e2:	7139                	addi	sp,sp,-64
    800027e4:	fc06                	sd	ra,56(sp)
    800027e6:	f822                	sd	s0,48(sp)
    800027e8:	f426                	sd	s1,40(sp)
    800027ea:	f04a                	sd	s2,32(sp)
    800027ec:	ec4e                	sd	s3,24(sp)
    800027ee:	e852                	sd	s4,16(sp)
    800027f0:	e456                	sd	s5,8(sp)
    800027f2:	0080                	addi	s0,sp,64
    800027f4:	892a                	mv	s2,a0
    800027f6:	8aae                	mv	s5,a1

  for(p = proc; p < &proc[NPROC]; p++){
    800027f8:	00010497          	auipc	s1,0x10
    800027fc:	f6048493          	addi	s1,s1,-160 # 80012758 <proc>
    80002800:	6985                	lui	s3,0x1
    80002802:	17898993          	addi	s3,s3,376 # 1178 <_entry-0x7fffee88>
    80002806:	00056a17          	auipc	s4,0x56
    8000280a:	d52a0a13          	addi	s4,s4,-686 # 80058558 <tickslock>
    acquire(&p->lock);
    8000280e:	8526                	mv	a0,s1
    80002810:	ffffe097          	auipc	ra,0xffffe
    80002814:	3ba080e7          	jalr	954(ra) # 80000bca <acquire>
    if(p->pid == pid){
    80002818:	50dc                	lw	a5,36(s1)
    8000281a:	01278c63          	beq	a5,s2,80002832 <kill+0x56>
      p->pendingSignals |= (1 << signum);

      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000281e:	8526                	mv	a0,s1
    80002820:	ffffe097          	auipc	ra,0xffffe
    80002824:	464080e7          	jalr	1124(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002828:	94ce                	add	s1,s1,s3
    8000282a:	ff4492e3          	bne	s1,s4,8000280e <kill+0x32>
  }
  return -1;
    8000282e:	557d                	li	a0,-1
    80002830:	a02d                	j	8000285a <kill+0x7e>
      if(signum == SIGKILL){
    80002832:	47a5                	li	a5,9
    80002834:	02fa8c63          	beq	s5,a5,8000286c <kill+0x90>
      p->pendingSignals |= (1 << signum);
    80002838:	6785                	lui	a5,0x1
    8000283a:	97a6                	add	a5,a5,s1
    8000283c:	4705                	li	a4,1
    8000283e:	0157173b          	sllw	a4,a4,s5
    80002842:	fe07aa83          	lw	s5,-32(a5) # fe0 <_entry-0x7ffff020>
    80002846:	00eaeab3          	or	s5,s5,a4
    8000284a:	ff57a023          	sw	s5,-32(a5)
      release(&p->lock);
    8000284e:	8526                	mv	a0,s1
    80002850:	ffffe097          	auipc	ra,0xffffe
    80002854:	434080e7          	jalr	1076(ra) # 80000c84 <release>
      return 0;
    80002858:	4501                	li	a0,0
}
    8000285a:	70e2                	ld	ra,56(sp)
    8000285c:	7442                	ld	s0,48(sp)
    8000285e:	74a2                	ld	s1,40(sp)
    80002860:	7902                	ld	s2,32(sp)
    80002862:	69e2                	ld	s3,24(sp)
    80002864:	6a42                	ld	s4,16(sp)
    80002866:	6aa2                	ld	s5,8(sp)
    80002868:	6121                	addi	sp,sp,64
    8000286a:	8082                	ret
        p->killed = 1; 
    8000286c:	4785                	li	a5,1
    8000286e:	ccdc                	sw	a5,28(s1)
        if(p->state == SLEEPING){ //-----------------> Was in the previous version, according to the forum now it's redundant
    80002870:	4c98                	lw	a4,24(s1)
    80002872:	4789                	li	a5,2
    80002874:	00f70b63          	beq	a4,a5,8000288a <kill+0xae>
        for(t=p->threads; t<&p->threads[NTHREAD]; t++){
    80002878:	02848793          	addi	a5,s1,40
    8000287c:	6685                	lui	a3,0x1
    8000287e:	f2868693          	addi	a3,a3,-216 # f28 <_entry-0x7ffff0d8>
    80002882:	96a6                	add	a3,a3,s1
          if(t->state == SLEEPING){
    80002884:	4609                	li	a2,2
            t->state = RUNNABLE;
    80002886:	458d                	li	a1,3
    80002888:	a801                	j	80002898 <kill+0xbc>
          p->state = RUNNABLE;
    8000288a:	478d                	li	a5,3
    8000288c:	cc9c                	sw	a5,24(s1)
    8000288e:	b7ed                	j	80002878 <kill+0x9c>
        for(t=p->threads; t<&p->threads[NTHREAD]; t++){
    80002890:	1e078793          	addi	a5,a5,480
    80002894:	fad782e3          	beq	a5,a3,80002838 <kill+0x5c>
          if(t->state == SLEEPING){
    80002898:	4398                	lw	a4,0(a5)
    8000289a:	fec71be3          	bne	a4,a2,80002890 <kill+0xb4>
            t->state = RUNNABLE;
    8000289e:	c38c                	sw	a1,0(a5)
    800028a0:	bfc5                	j	80002890 <kill+0xb4>
  if(signum >= SIGNALS_SIZE || signum < 0) return -1;
    800028a2:	557d                	li	a0,-1
}
    800028a4:	8082                	ret

00000000800028a6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800028a6:	7179                	addi	sp,sp,-48
    800028a8:	f406                	sd	ra,40(sp)
    800028aa:	f022                	sd	s0,32(sp)
    800028ac:	ec26                	sd	s1,24(sp)
    800028ae:	e84a                	sd	s2,16(sp)
    800028b0:	e44e                	sd	s3,8(sp)
    800028b2:	e052                	sd	s4,0(sp)
    800028b4:	1800                	addi	s0,sp,48
    800028b6:	84aa                	mv	s1,a0
    800028b8:	892e                	mv	s2,a1
    800028ba:	89b2                	mv	s3,a2
    800028bc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800028be:	fffff097          	auipc	ra,0xfffff
    800028c2:	13a080e7          	jalr	314(ra) # 800019f8 <myproc>
  if(user_dst){
    800028c6:	c485                	beqz	s1,800028ee <either_copyout+0x48>
    return copyout(p->pagetable, dst, src, len);
    800028c8:	6785                	lui	a5,0x1
    800028ca:	953e                	add	a0,a0,a5
    800028cc:	86d2                	mv	a3,s4
    800028ce:	864e                	mv	a2,s3
    800028d0:	85ca                	mv	a1,s2
    800028d2:	f4053503          	ld	a0,-192(a0)
    800028d6:	fffff097          	auipc	ra,0xfffff
    800028da:	d76080e7          	jalr	-650(ra) # 8000164c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800028de:	70a2                	ld	ra,40(sp)
    800028e0:	7402                	ld	s0,32(sp)
    800028e2:	64e2                	ld	s1,24(sp)
    800028e4:	6942                	ld	s2,16(sp)
    800028e6:	69a2                	ld	s3,8(sp)
    800028e8:	6a02                	ld	s4,0(sp)
    800028ea:	6145                	addi	sp,sp,48
    800028ec:	8082                	ret
    memmove((char *)dst, src, len);
    800028ee:	000a061b          	sext.w	a2,s4
    800028f2:	85ce                	mv	a1,s3
    800028f4:	854a                	mv	a0,s2
    800028f6:	ffffe097          	auipc	ra,0xffffe
    800028fa:	432080e7          	jalr	1074(ra) # 80000d28 <memmove>
    return 0;
    800028fe:	8526                	mv	a0,s1
    80002900:	bff9                	j	800028de <either_copyout+0x38>

0000000080002902 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002902:	7179                	addi	sp,sp,-48
    80002904:	f406                	sd	ra,40(sp)
    80002906:	f022                	sd	s0,32(sp)
    80002908:	ec26                	sd	s1,24(sp)
    8000290a:	e84a                	sd	s2,16(sp)
    8000290c:	e44e                	sd	s3,8(sp)
    8000290e:	e052                	sd	s4,0(sp)
    80002910:	1800                	addi	s0,sp,48
    80002912:	892a                	mv	s2,a0
    80002914:	84ae                	mv	s1,a1
    80002916:	89b2                	mv	s3,a2
    80002918:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000291a:	fffff097          	auipc	ra,0xfffff
    8000291e:	0de080e7          	jalr	222(ra) # 800019f8 <myproc>
  if(user_src){
    80002922:	c485                	beqz	s1,8000294a <either_copyin+0x48>
    return copyin(p->pagetable, dst, src, len);
    80002924:	6785                	lui	a5,0x1
    80002926:	97aa                	add	a5,a5,a0
    80002928:	86d2                	mv	a3,s4
    8000292a:	864e                	mv	a2,s3
    8000292c:	85ca                	mv	a1,s2
    8000292e:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80002932:	fffff097          	auipc	ra,0xfffff
    80002936:	da6080e7          	jalr	-602(ra) # 800016d8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000293a:	70a2                	ld	ra,40(sp)
    8000293c:	7402                	ld	s0,32(sp)
    8000293e:	64e2                	ld	s1,24(sp)
    80002940:	6942                	ld	s2,16(sp)
    80002942:	69a2                	ld	s3,8(sp)
    80002944:	6a02                	ld	s4,0(sp)
    80002946:	6145                	addi	sp,sp,48
    80002948:	8082                	ret
    memmove(dst, (char*)src, len);
    8000294a:	000a061b          	sext.w	a2,s4
    8000294e:	85ce                	mv	a1,s3
    80002950:	854a                	mv	a0,s2
    80002952:	ffffe097          	auipc	ra,0xffffe
    80002956:	3d6080e7          	jalr	982(ra) # 80000d28 <memmove>
    return 0;
    8000295a:	8526                	mv	a0,s1
    8000295c:	bff9                	j	8000293a <either_copyin+0x38>

000000008000295e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000295e:	715d                	addi	sp,sp,-80
    80002960:	e486                	sd	ra,72(sp)
    80002962:	e0a2                	sd	s0,64(sp)
    80002964:	fc26                	sd	s1,56(sp)
    80002966:	f84a                	sd	s2,48(sp)
    80002968:	f44e                	sd	s3,40(sp)
    8000296a:	f052                	sd	s4,32(sp)
    8000296c:	ec56                	sd	s5,24(sp)
    8000296e:	e85a                	sd	s6,16(sp)
    80002970:	e45e                	sd	s7,8(sp)
    80002972:	e062                	sd	s8,0(sp)
    80002974:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002976:	00006517          	auipc	a0,0x6
    8000297a:	75250513          	addi	a0,a0,1874 # 800090c8 <digits+0x88>
    8000297e:	ffffe097          	auipc	ra,0xffffe
    80002982:	bf6080e7          	jalr	-1034(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002986:	00010497          	auipc	s1,0x10
    8000298a:	dd248493          	addi	s1,s1,-558 # 80012758 <proc>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000298e:	4b95                	li	s7,5
      state = states[p->state];
    else
      state = "???";
    80002990:	00007a17          	auipc	s4,0x7
    80002994:	908a0a13          	addi	s4,s4,-1784 # 80009298 <digits+0x258>
    printf("%d %s %s", p->pid, state, p->name);
    80002998:	6905                	lui	s2,0x1
    8000299a:	fd090b13          	addi	s6,s2,-48 # fd0 <_entry-0x7ffff030>
    8000299e:	00007a97          	auipc	s5,0x7
    800029a2:	902a8a93          	addi	s5,s5,-1790 # 800092a0 <digits+0x260>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029a6:	00007c17          	auipc	s8,0x7
    800029aa:	9aac0c13          	addi	s8,s8,-1622 # 80009350 <states.0>
  for(p = proc; p < &proc[NPROC]; p++){
    800029ae:	17890913          	addi	s2,s2,376
    800029b2:	00056997          	auipc	s3,0x56
    800029b6:	ba698993          	addi	s3,s3,-1114 # 80058558 <tickslock>
    800029ba:	a025                	j	800029e2 <procdump+0x84>
    printf("%d %s %s", p->pid, state, p->name);
    800029bc:	016486b3          	add	a3,s1,s6
    800029c0:	50cc                	lw	a1,36(s1)
    800029c2:	8556                	mv	a0,s5
    800029c4:	ffffe097          	auipc	ra,0xffffe
    800029c8:	bb0080e7          	jalr	-1104(ra) # 80000574 <printf>
    printf("\n");
    800029cc:	00006517          	auipc	a0,0x6
    800029d0:	6fc50513          	addi	a0,a0,1788 # 800090c8 <digits+0x88>
    800029d4:	ffffe097          	auipc	ra,0xffffe
    800029d8:	ba0080e7          	jalr	-1120(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800029dc:	94ca                	add	s1,s1,s2
    800029de:	03348063          	beq	s1,s3,800029fe <procdump+0xa0>
    if(p->state == UNUSED)
    800029e2:	4c9c                	lw	a5,24(s1)
    800029e4:	dfe5                	beqz	a5,800029dc <procdump+0x7e>
      state = "???";
    800029e6:	8652                	mv	a2,s4
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029e8:	fcfbeae3          	bltu	s7,a5,800029bc <procdump+0x5e>
    800029ec:	02079713          	slli	a4,a5,0x20
    800029f0:	01d75793          	srli	a5,a4,0x1d
    800029f4:	97e2                	add	a5,a5,s8
    800029f6:	6390                	ld	a2,0(a5)
    800029f8:	f271                	bnez	a2,800029bc <procdump+0x5e>
      state = "???";
    800029fa:	8652                	mv	a2,s4
    800029fc:	b7c1                	j	800029bc <procdump+0x5e>
  }
}
    800029fe:	60a6                	ld	ra,72(sp)
    80002a00:	6406                	ld	s0,64(sp)
    80002a02:	74e2                	ld	s1,56(sp)
    80002a04:	7942                	ld	s2,48(sp)
    80002a06:	79a2                	ld	s3,40(sp)
    80002a08:	7a02                	ld	s4,32(sp)
    80002a0a:	6ae2                	ld	s5,24(sp)
    80002a0c:	6b42                	ld	s6,16(sp)
    80002a0e:	6ba2                	ld	s7,8(sp)
    80002a10:	6c02                	ld	s8,0(sp)
    80002a12:	6161                	addi	sp,sp,80
    80002a14:	8082                	ret

0000000080002a16 <sigprocmask>:

uint
sigprocmask(uint sigmask){
    80002a16:	1101                	addi	sp,sp,-32
    80002a18:	ec06                	sd	ra,24(sp)
    80002a1a:	e822                	sd	s0,16(sp)
    80002a1c:	e426                	sd	s1,8(sp)
    80002a1e:	1000                	addi	s0,sp,32
    80002a20:	84aa                	mv	s1,a0

  struct proc* p = myproc ();
    80002a22:	fffff097          	auipc	ra,0xfffff
    80002a26:	fd6080e7          	jalr	-42(ra) # 800019f8 <myproc>
  uint oldMask = p->signalMask;
    80002a2a:	6785                	lui	a5,0x1
    80002a2c:	97aa                	add	a5,a5,a0
    80002a2e:	fe47a503          	lw	a0,-28(a5) # fe4 <_entry-0x7ffff01c>
  p->signalMask = sigmask;
    80002a32:	fe97a223          	sw	s1,-28(a5)
  return oldMask;
}
    80002a36:	60e2                	ld	ra,24(sp)
    80002a38:	6442                	ld	s0,16(sp)
    80002a3a:	64a2                	ld	s1,8(sp)
    80002a3c:	6105                	addi	sp,sp,32
    80002a3e:	8082                	ret

0000000080002a40 <sigaction>:
sigaction(int signum, const struct sigaction *act, struct sigaction *oldact){

  // printf ("signum is: %d\nact adress is: %d\noldact address is: %d\n", signum,act,oldact);
  // Check that signum in the correct range

  if (signum < 0 || signum >= 32)
    80002a40:	0005079b          	sext.w	a5,a0
    80002a44:	477d                	li	a4,31
    80002a46:	0ef76763          	bltu	a4,a5,80002b34 <sigaction+0xf4>
sigaction(int signum, const struct sigaction *act, struct sigaction *oldact){
    80002a4a:	7139                	addi	sp,sp,-64
    80002a4c:	fc06                	sd	ra,56(sp)
    80002a4e:	f822                	sd	s0,48(sp)
    80002a50:	f426                	sd	s1,40(sp)
    80002a52:	f04a                	sd	s2,32(sp)
    80002a54:	ec4e                	sd	s3,24(sp)
    80002a56:	e852                	sd	s4,16(sp)
    80002a58:	0080                	addi	s0,sp,64
    80002a5a:	84aa                	mv	s1,a0
    80002a5c:	8a2e                	mv	s4,a1
    80002a5e:	89b2                	mv	s3,a2
    return -1;

  if (signum == SIGSTOP || signum == SIGKILL)
    80002a60:	37dd                	addiw	a5,a5,-9
    80002a62:	9bdd                	andi	a5,a5,-9
    80002a64:	2781                	sext.w	a5,a5
    80002a66:	cbe9                	beqz	a5,80002b38 <sigaction+0xf8>
      return -1;

  struct proc* p = myproc ();
    80002a68:	fffff097          	auipc	ra,0xfffff
    80002a6c:	f90080e7          	jalr	-112(ra) # 800019f8 <myproc>
    80002a70:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002a72:	ffffe097          	auipc	ra,0xffffe
    80002a76:	158080e7          	jalr	344(ra) # 80000bca <acquire>

  if (oldact){
    80002a7a:	04098d63          	beqz	s3,80002ad4 <sigaction+0x94>

    struct sigaction oldSig;
    oldSig.sa_handler = p->signalHandlers[signum];
    80002a7e:	1fc48793          	addi	a5,s1,508
    80002a82:	078e                	slli	a5,a5,0x3
    80002a84:	97ca                	add	a5,a5,s2
    80002a86:	679c                	ld	a5,8(a5)
    80002a88:	fcf43023          	sd	a5,-64(s0)
    oldSig.sigmask = p->maskHandlers[signum];
    80002a8c:	43c48793          	addi	a5,s1,1084
    80002a90:	078a                	slli	a5,a5,0x2
    80002a92:	97ca                	add	a5,a5,s2
    80002a94:	43dc                	lw	a5,4(a5)
    80002a96:	fcf42423          	sw	a5,-56(s0)

    if (copyout(p->pagetable, (uint64) oldact, (char*)&oldSig.sa_handler, sizeof(8)) < 0)
    80002a9a:	6785                	lui	a5,0x1
    80002a9c:	97ca                	add	a5,a5,s2
    80002a9e:	4691                	li	a3,4
    80002aa0:	fc040613          	addi	a2,s0,-64
    80002aa4:	85ce                	mv	a1,s3
    80002aa6:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80002aaa:	fffff097          	auipc	ra,0xfffff
    80002aae:	ba2080e7          	jalr	-1118(ra) # 8000164c <copyout>
    80002ab2:	06054d63          	bltz	a0,80002b2c <sigaction+0xec>
      return -1;

    if (copyout(p->pagetable, (uint64) oldact+8, (char*)&oldSig.sigmask, sizeof(uint)) < 0)
    80002ab6:	6785                	lui	a5,0x1
    80002ab8:	97ca                	add	a5,a5,s2
    80002aba:	4691                	li	a3,4
    80002abc:	fc840613          	addi	a2,s0,-56
    80002ac0:	00898593          	addi	a1,s3,8
    80002ac4:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80002ac8:	fffff097          	auipc	ra,0xfffff
    80002acc:	b84080e7          	jalr	-1148(ra) # 8000164c <copyout>
    80002ad0:	04054e63          	bltz	a0,80002b2c <sigaction+0xec>
      return -1;  
  }
  if (act){
    80002ad4:	020a0e63          	beqz	s4,80002b10 <sigaction+0xd0>
    struct sigaction newSig;
    if(copyin(p->pagetable,(char*)&newSig, (uint64)act, sizeof(struct sigaction))<0)
    80002ad8:	6785                	lui	a5,0x1
    80002ada:	97ca                	add	a5,a5,s2
    80002adc:	46c1                	li	a3,16
    80002ade:	8652                	mv	a2,s4
    80002ae0:	fc040593          	addi	a1,s0,-64
    80002ae4:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80002ae8:	fffff097          	auipc	ra,0xfffff
    80002aec:	bf0080e7          	jalr	-1040(ra) # 800016d8 <copyin>
    80002af0:	04054063          	bltz	a0,80002b30 <sigaction+0xf0>
      return -1;

    if(newSig.sigmask <0)
      return -1;

    p->signalHandlers[signum] = newSig.sa_handler;
    80002af4:	1fc48793          	addi	a5,s1,508
    80002af8:	078e                	slli	a5,a5,0x3
    80002afa:	97ca                	add	a5,a5,s2
    80002afc:	fc043703          	ld	a4,-64(s0)
    80002b00:	e798                	sd	a4,8(a5)

    p->maskHandlers[signum] = newSig.sigmask;
    80002b02:	43c48493          	addi	s1,s1,1084
    80002b06:	048a                	slli	s1,s1,0x2
    80002b08:	94ca                	add	s1,s1,s2
    80002b0a:	fc842783          	lw	a5,-56(s0)
    80002b0e:	c0dc                	sw	a5,4(s1)
  }
  release(&p->lock);
    80002b10:	854a                	mv	a0,s2
    80002b12:	ffffe097          	auipc	ra,0xffffe
    80002b16:	172080e7          	jalr	370(ra) # 80000c84 <release>
  return 0;
    80002b1a:	4501                	li	a0,0
}
    80002b1c:	70e2                	ld	ra,56(sp)
    80002b1e:	7442                	ld	s0,48(sp)
    80002b20:	74a2                	ld	s1,40(sp)
    80002b22:	7902                	ld	s2,32(sp)
    80002b24:	69e2                	ld	s3,24(sp)
    80002b26:	6a42                	ld	s4,16(sp)
    80002b28:	6121                	addi	sp,sp,64
    80002b2a:	8082                	ret
      return -1;
    80002b2c:	557d                	li	a0,-1
    80002b2e:	b7fd                	j	80002b1c <sigaction+0xdc>
      return -1;
    80002b30:	557d                	li	a0,-1
    80002b32:	b7ed                	j	80002b1c <sigaction+0xdc>
    return -1;
    80002b34:	557d                	li	a0,-1
}
    80002b36:	8082                	ret
      return -1;
    80002b38:	557d                	li	a0,-1
    80002b3a:	b7cd                	j	80002b1c <sigaction+0xdc>

0000000080002b3c <sigret>:


void
sigret (void){
    80002b3c:	1101                	addi	sp,sp,-32
    80002b3e:	ec06                	sd	ra,24(sp)
    80002b40:	e822                	sd	s0,16(sp)
    80002b42:	e426                	sd	s1,8(sp)
    80002b44:	e04a                	sd	s2,0(sp)
    80002b46:	1000                	addi	s0,sp,32
  struct proc* p = myproc();
    80002b48:	fffff097          	auipc	ra,0xfffff
    80002b4c:	eb0080e7          	jalr	-336(ra) # 800019f8 <myproc>
    80002b50:	84aa                	mv	s1,a0
  struct thread* t = mythread();
    80002b52:	fffff097          	auipc	ra,0xfffff
    80002b56:	f2c080e7          	jalr	-212(ra) # 80001a7e <mythread>
    80002b5a:	892a                	mv	s2,a0
  printf("sig ret\n");
    80002b5c:	00006517          	auipc	a0,0x6
    80002b60:	75450513          	addi	a0,a0,1876 # 800092b0 <digits+0x270>
    80002b64:	ffffe097          	auipc	ra,0xffffe
    80002b68:	a10080e7          	jalr	-1520(ra) # 80000574 <printf>
  *t->trapframe = t->UserTrapFrameBackup;
    80002b6c:	04090793          	addi	a5,s2,64
    80002b70:	03893703          	ld	a4,56(s2)
    80002b74:	16090913          	addi	s2,s2,352
    80002b78:	6388                	ld	a0,0(a5)
    80002b7a:	678c                	ld	a1,8(a5)
    80002b7c:	6b90                	ld	a2,16(a5)
    80002b7e:	6f94                	ld	a3,24(a5)
    80002b80:	e308                	sd	a0,0(a4)
    80002b82:	e70c                	sd	a1,8(a4)
    80002b84:	eb10                	sd	a2,16(a4)
    80002b86:	ef14                	sd	a3,24(a4)
    80002b88:	02078793          	addi	a5,a5,32
    80002b8c:	02070713          	addi	a4,a4,32
    80002b90:	ff2794e3          	bne	a5,s2,80002b78 <sigret+0x3c>
  // memmove(p->trapframe, p->UserTrapFrameBackup, sizeof(struct trapframe));
  // if(copyin(p->pagetable,(char*)p->trapframe, (uint64)p->UserTrapFrameBackup, sizeof(struct trapframe)) < 0)
  // printf("fopyin doesnt work\n");
  p->signalMask = p->signal_mask_backup;
    80002b94:	6505                	lui	a0,0x1
    80002b96:	9526                	add	a0,a0,s1
    80002b98:	0ec52783          	lw	a5,236(a0) # 10ec <_entry-0x7fffef14>
    80002b9c:	fef52223          	sw	a5,-28(a0)
  p->ignore_signals = 0;
    80002ba0:	0e052823          	sw	zero,240(a0)
}
    80002ba4:	60e2                	ld	ra,24(sp)
    80002ba6:	6442                	ld	s0,16(sp)
    80002ba8:	64a2                	ld	s1,8(sp)
    80002baa:	6902                	ld	s2,0(sp)
    80002bac:	6105                	addi	sp,sp,32
    80002bae:	8082                	ret

0000000080002bb0 <usersignal>:

void usersignal(struct thread *t, int signum){
    80002bb0:	7179                	addi	sp,sp,-48
    80002bb2:	f406                	sd	ra,40(sp)
    80002bb4:	f022                	sd	s0,32(sp)
    80002bb6:	ec26                	sd	s1,24(sp)
    80002bb8:	e84a                	sd	s2,16(sp)
    80002bba:	e44e                	sd	s3,8(sp)
    80002bbc:	e052                	sd	s4,0(sp)
    80002bbe:	1800                	addi	s0,sp,48
    80002bc0:	84aa                	mv	s1,a0
    80002bc2:	89ae                	mv	s3,a1
  struct proc *p = t->proc_parent;
    80002bc4:	02853a03          	ld	s4,40(a0)
  // Extract sigmask from sigaction, and backup the old signal mask
  p->signal_mask_backup = p->signalMask;
    80002bc8:	6905                	lui	s2,0x1
    80002bca:	9952                	add	s2,s2,s4
    80002bcc:	fe492783          	lw	a5,-28(s2) # fe4 <_entry-0x7ffff01c>
    80002bd0:	0ef92623          	sw	a5,236(s2)
  p->signalMask = p->maskHandlers[signum];
    80002bd4:	43c58793          	addi	a5,a1,1084
    80002bd8:	078a                	slli	a5,a5,0x2
    80002bda:	97d2                	add	a5,a5,s4
    80002bdc:	43dc                	lw	a5,4(a5)
    80002bde:	fef92223          	sw	a5,-28(s2)

  // indicate that the process is at "signal handling" by turn on a flag
  p->ignore_signals = 1;
    80002be2:	4785                	li	a5,1
    80002be4:	0ef92823          	sw	a5,240(s2)

  // copy the current process trapframe, to the trapframe backup 
  memmove(&t->UserTrapFrameBackup, t->trapframe, sizeof(struct trapframe));
    80002be8:	12000613          	li	a2,288
    80002bec:	7d0c                	ld	a1,56(a0)
    80002bee:	04050513          	addi	a0,a0,64
    80002bf2:	ffffe097          	auipc	ra,0xffffe
    80002bf6:	136080e7          	jalr	310(ra) # 80000d28 <memmove>

  // Extract handler from signalHandlers, and updated saved user pc to point to signal handler
  t->trapframe->epc = (uint64)p->signalHandlers[signum];
    80002bfa:	7c98                	ld	a4,56(s1)
    80002bfc:	1fc98793          	addi	a5,s3,508
    80002c00:	078e                	slli	a5,a5,0x3
    80002c02:	9a3e                	add	s4,s4,a5
    80002c04:	008a3783          	ld	a5,8(s4)
    80002c08:	ef1c                	sd	a5,24(a4)

  // Calculate the size of sig_ret
  uint sigret_size = end_ret - start_ret;

  // Reduce stack pointer by size of function sigret and copy out function to user stack
  t->trapframe->sp -= sigret_size;
    80002c0a:	7c98                	ld	a4,56(s1)
  uint sigret_size = end_ret - start_ret;
    80002c0c:	00004617          	auipc	a2,0x4
    80002c10:	fda60613          	addi	a2,a2,-38 # 80006be6 <start_ret>
    80002c14:	00004697          	auipc	a3,0x4
    80002c18:	fd868693          	addi	a3,a3,-40 # 80006bec <free_desc>
    80002c1c:	8e91                	sub	a3,a3,a2
  t->trapframe->sp -= sigret_size;
    80002c1e:	1682                	slli	a3,a3,0x20
    80002c20:	9281                	srli	a3,a3,0x20
    80002c22:	7b1c                	ld	a5,48(a4)
    80002c24:	8f95                	sub	a5,a5,a3
    80002c26:	fb1c                	sd	a5,48(a4)
  copyout(p->pagetable, t->trapframe->sp, (char *)&start_ret, sigret_size);
    80002c28:	7c9c                	ld	a5,56(s1)
    80002c2a:	7b8c                	ld	a1,48(a5)
    80002c2c:	f4093503          	ld	a0,-192(s2)
    80002c30:	fffff097          	auipc	ra,0xfffff
    80002c34:	a1c080e7          	jalr	-1508(ra) # 8000164c <copyout>

  // parameter = signum
  t->trapframe->a0 = signum;
    80002c38:	7c9c                	ld	a5,56(s1)
    80002c3a:	0737b823          	sd	s3,112(a5)

  // update return address so that after handler finishes it will jump to sigret  
  t->trapframe->ra = t->trapframe->sp;
    80002c3e:	7c9c                	ld	a5,56(s1)
    80002c40:	7b98                	ld	a4,48(a5)
    80002c42:	f798                	sd	a4,40(a5)

}
    80002c44:	70a2                	ld	ra,40(sp)
    80002c46:	7402                	ld	s0,32(sp)
    80002c48:	64e2                	ld	s1,24(sp)
    80002c4a:	6942                	ld	s2,16(sp)
    80002c4c:	69a2                	ld	s3,8(sp)
    80002c4e:	6a02                	ld	s4,0(sp)
    80002c50:	6145                	addi	sp,sp,48
    80002c52:	8082                	ret

0000000080002c54 <stopSignal>:





void stopSignal(struct proc *p){
    80002c54:	1141                	addi	sp,sp,-16
    80002c56:	e422                	sd	s0,8(sp)
    80002c58:	0800                	addi	s0,sp,16

  p->stopped = 1;
    80002c5a:	6785                	lui	a5,0x1
    80002c5c:	953e                	add	a0,a0,a5
    80002c5e:	4785                	li	a5,1
    80002c60:	0ef52423          	sw	a5,232(a0)

}
    80002c64:	6422                	ld	s0,8(sp)
    80002c66:	0141                	addi	sp,sp,16
    80002c68:	8082                	ret

0000000080002c6a <contSignal>:

void contSignal(struct proc *p){
    80002c6a:	1141                	addi	sp,sp,-16
    80002c6c:	e422                	sd	s0,8(sp)
    80002c6e:	0800                	addi	s0,sp,16

  p->stopped = 0;
    80002c70:	6785                	lui	a5,0x1
    80002c72:	953e                	add	a0,a0,a5
    80002c74:	0e052423          	sw	zero,232(a0)

}
    80002c78:	6422                	ld	s0,8(sp)
    80002c7a:	0141                	addi	sp,sp,16
    80002c7c:	8082                	ret

0000000080002c7e <handling_signals>:


void handling_signals(){
    80002c7e:	7159                	addi	sp,sp,-112
    80002c80:	f486                	sd	ra,104(sp)
    80002c82:	f0a2                	sd	s0,96(sp)
    80002c84:	eca6                	sd	s1,88(sp)
    80002c86:	e8ca                	sd	s2,80(sp)
    80002c88:	e4ce                	sd	s3,72(sp)
    80002c8a:	e0d2                	sd	s4,64(sp)
    80002c8c:	fc56                	sd	s5,56(sp)
    80002c8e:	f85a                	sd	s6,48(sp)
    80002c90:	f45e                	sd	s7,40(sp)
    80002c92:	f062                	sd	s8,32(sp)
    80002c94:	ec66                	sd	s9,24(sp)
    80002c96:	e86a                	sd	s10,16(sp)
    80002c98:	e46e                	sd	s11,8(sp)
    80002c9a:	1880                	addi	s0,sp,112
  struct proc *p = myproc();
    80002c9c:	fffff097          	auipc	ra,0xfffff
    80002ca0:	d5c080e7          	jalr	-676(ra) # 800019f8 <myproc>

  // ass2

  // If first process or all signals are ignored -> return
  if((p == 0) || (p->signalMask == 0xffffffff) || p->ignore_signals) return;
    80002ca4:	10050f63          	beqz	a0,80002dc2 <handling_signals+0x144>
    80002ca8:	8baa                	mv	s7,a0
    80002caa:	6785                	lui	a5,0x1
    80002cac:	97aa                	add	a5,a5,a0
    80002cae:	fe47a783          	lw	a5,-28(a5) # fe4 <_entry-0x7ffff01c>
    80002cb2:	577d                	li	a4,-1
    80002cb4:	10e78763          	beq	a5,a4,80002dc2 <handling_signals+0x144>
    80002cb8:	6705                	lui	a4,0x1
    80002cba:	972a                	add	a4,a4,a0
    80002cbc:	0f072483          	lw	s1,240(a4) # 10f0 <_entry-0x7fffef10>
    80002cc0:	10049163          	bnez	s1,80002dc2 <handling_signals+0x144>

  // Check if stopped and has a pending SIGCONT signal, if none are received, it will yield the CPU.
  if(p->stopped && !(p->signalMask & (1 << SIGSTOP))) {
    80002cc4:	6705                	lui	a4,0x1
    80002cc6:	972a                	add	a4,a4,a0
    80002cc8:	0e872703          	lw	a4,232(a4) # 10e8 <_entry-0x7fffef18>
    80002ccc:	c339                	beqz	a4,80002d12 <handling_signals+0x94>
    80002cce:	83c5                	srli	a5,a5,0x11
    80002cd0:	8b85                	andi	a5,a5,1
    80002cd2:	e3a1                	bnez	a5,80002d12 <handling_signals+0x94>
    int cont_pend;
    while(1){   
      // acquire(&p->lock);
      cont_pend = p->pendingSignals & (1 << SIGCONT);
    80002cd4:	6785                	lui	a5,0x1
    80002cd6:	97aa                	add	a5,a5,a0
    80002cd8:	fe07a703          	lw	a4,-32(a5) # fe0 <_entry-0x7ffff020>
    80002cdc:	01375793          	srli	a5,a4,0x13
      if(cont_pend){
    80002ce0:	8b85                	andi	a5,a5,1
      cont_pend = p->pendingSignals & (1 << SIGCONT);
    80002ce2:	6905                	lui	s2,0x1
    80002ce4:	992a                	add	s2,s2,a0
    80002ce6:	000809b7          	lui	s3,0x80
      if(cont_pend){
    80002cea:	eb99                	bnez	a5,80002d00 <handling_signals+0x82>
        // release(&p->lock);
        break;
      }
      else{
        // release(&p->lock);
        yield();
    80002cec:	fffff097          	auipc	ra,0xfffff
    80002cf0:	64a080e7          	jalr	1610(ra) # 80002336 <yield>
      cont_pend = p->pendingSignals & (1 << SIGCONT);
    80002cf4:	fe092703          	lw	a4,-32(s2) # fe0 <_entry-0x7ffff020>
    80002cf8:	013777b3          	and	a5,a4,s3
      if(cont_pend){
    80002cfc:	2781                	sext.w	a5,a5
    80002cfe:	d7fd                	beqz	a5,80002cec <handling_signals+0x6e>
        p->stopped = 0;
    80002d00:	6785                	lui	a5,0x1
    80002d02:	97de                	add	a5,a5,s7
    80002d04:	0e07a423          	sw	zero,232(a5) # 10e8 <_entry-0x7fffef18>
        p->pendingSignals ^= (1 << SIGCONT);
    80002d08:	000806b7          	lui	a3,0x80
    80002d0c:	8f35                	xor	a4,a4,a3
    80002d0e:	fee7a023          	sw	a4,-32(a5)
      }
    }
  }

  for(int sig = 0 ; sig < SIGNALS_SIZE ; sig++){
    80002d12:	6985                	lui	s3,0x1
    80002d14:	19a1                	addi	s3,s3,-24
    80002d16:	99de                	add	s3,s3,s7
    uint pandSigs = p->pendingSignals;
    uint sigMask = p->signalMask;
    // check if panding for the i'th signal and it's not blocked.
    if( (pandSigs & (1 << sig)) && !(sigMask & (1 << sig)) ){
    80002d18:	4b05                	li	s6,1
    uint pandSigs = p->pendingSignals;
    80002d1a:	6a05                	lui	s4,0x1
    80002d1c:	9a5e                	add	s4,s4,s7
            break;
        }
        //turning bit of pending singal off
        p->pendingSignals ^= (1 << sig); 
      }
      else if (p->signalHandlers[sig] != (void*)SIG_IGN){
    80002d1e:	4c05                	li	s8,1
        if(p->pid == 6) 
    80002d20:	4d99                	li	s11,6
        switch(sig)
    80002d22:	4d45                	li	s10,17
    80002d24:	4ccd                	li	s9,19
  for(int sig = 0 ; sig < SIGNALS_SIZE ; sig++){
    80002d26:	02000a93          	li	s5,32
    80002d2a:	a0b1                	j	80002d76 <handling_signals+0xf8>
        if(p->pid == 6) 
    80002d2c:	024ba783          	lw	a5,36(s7)
    80002d30:	01b78e63          	beq	a5,s11,80002d4c <handling_signals+0xce>
        switch(sig)
    80002d34:	03a48563          	beq	s1,s10,80002d5e <handling_signals+0xe0>
    80002d38:	09948263          	beq	s1,s9,80002dbc <handling_signals+0x13e>
            kill(p->pid, SIGKILL);
    80002d3c:	45a5                	li	a1,9
    80002d3e:	024ba503          	lw	a0,36(s7)
    80002d42:	00000097          	auipc	ra,0x0
    80002d46:	a9a080e7          	jalr	-1382(ra) # 800027dc <kill>
            break;
    80002d4a:	a821                	j	80002d62 <handling_signals+0xe4>
          printf("pid 6 = child , in handle SIG_DFL\n");
    80002d4c:	00006517          	auipc	a0,0x6
    80002d50:	57450513          	addi	a0,a0,1396 # 800092c0 <digits+0x280>
    80002d54:	ffffe097          	auipc	ra,0xffffe
    80002d58:	820080e7          	jalr	-2016(ra) # 80000574 <printf>
    80002d5c:	bfe1                	j	80002d34 <handling_signals+0xb6>
  p->stopped = 1;
    80002d5e:	0f8a2423          	sw	s8,232(s4) # 10e8 <_entry-0x7fffef18>
        p->pendingSignals ^= (1 << sig); 
    80002d62:	fe0a2783          	lw	a5,-32(s4)
    80002d66:	0127c933          	xor	s2,a5,s2
    80002d6a:	ff2a2023          	sw	s2,-32(s4)
  for(int sig = 0 ; sig < SIGNALS_SIZE ; sig++){
    80002d6e:	2485                	addiw	s1,s1,1
    80002d70:	09a1                	addi	s3,s3,8
    80002d72:	05548863          	beq	s1,s5,80002dc2 <handling_signals+0x144>
    if( (pandSigs & (1 << sig)) && !(sigMask & (1 << sig)) ){
    80002d76:	009b193b          	sllw	s2,s6,s1
    80002d7a:	fe0a2783          	lw	a5,-32(s4)
    80002d7e:	0127f7b3          	and	a5,a5,s2
    80002d82:	2781                	sext.w	a5,a5
    80002d84:	d7ed                	beqz	a5,80002d6e <handling_signals+0xf0>
    80002d86:	fe4a2783          	lw	a5,-28(s4)
    80002d8a:	0127f7b3          	and	a5,a5,s2
    80002d8e:	2781                	sext.w	a5,a5
    80002d90:	fff9                	bnez	a5,80002d6e <handling_signals+0xf0>
      if(p->signalHandlers[sig] == (void*)SIG_DFL){
    80002d92:	0009b783          	ld	a5,0(s3) # 1000 <_entry-0x7ffff000>
    80002d96:	dbd9                	beqz	a5,80002d2c <handling_signals+0xae>
      else if (p->signalHandlers[sig] != (void*)SIG_IGN){
    80002d98:	fd878be3          	beq	a5,s8,80002d6e <handling_signals+0xf0>
        usersignal(mythread(), sig);
    80002d9c:	fffff097          	auipc	ra,0xfffff
    80002da0:	ce2080e7          	jalr	-798(ra) # 80001a7e <mythread>
    80002da4:	85a6                	mv	a1,s1
    80002da6:	00000097          	auipc	ra,0x0
    80002daa:	e0a080e7          	jalr	-502(ra) # 80002bb0 <usersignal>
        p->pendingSignals ^= (1 << sig); //turning bit off
    80002dae:	fe0a2783          	lw	a5,-32(s4)
    80002db2:	0127c933          	xor	s2,a5,s2
    80002db6:	ff2a2023          	sw	s2,-32(s4)
    80002dba:	bf55                	j	80002d6e <handling_signals+0xf0>
  p->stopped = 0;
    80002dbc:	0e0a2423          	sw	zero,232(s4)
}
    80002dc0:	b74d                	j	80002d62 <handling_signals+0xe4>
      }
    }
  }
}
    80002dc2:	70a6                	ld	ra,104(sp)
    80002dc4:	7406                	ld	s0,96(sp)
    80002dc6:	64e6                	ld	s1,88(sp)
    80002dc8:	6946                	ld	s2,80(sp)
    80002dca:	69a6                	ld	s3,72(sp)
    80002dcc:	6a06                	ld	s4,64(sp)
    80002dce:	7ae2                	ld	s5,56(sp)
    80002dd0:	7b42                	ld	s6,48(sp)
    80002dd2:	7ba2                	ld	s7,40(sp)
    80002dd4:	7c02                	ld	s8,32(sp)
    80002dd6:	6ce2                	ld	s9,24(sp)
    80002dd8:	6d42                	ld	s10,16(sp)
    80002dda:	6da2                	ld	s11,8(sp)
    80002ddc:	6165                	addi	sp,sp,112
    80002dde:	8082                	ret

0000000080002de0 <bsem_alloc>:

int bsems[MAX_BSEM] = {[0 ... MAX_BSEM-1] = -1};

// Alloc bsem and make it a 1.

int bsem_alloc(){
    80002de0:	1101                	addi	sp,sp,-32
    80002de2:	ec06                	sd	ra,24(sp)
    80002de4:	e822                	sd	s0,16(sp)
    80002de6:	e426                	sd	s1,8(sp)
    80002de8:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80002dea:	0000f517          	auipc	a0,0xf
    80002dee:	4b650513          	addi	a0,a0,1206 # 800122a0 <pid_lock>
    80002df2:	ffffe097          	auipc	ra,0xffffe
    80002df6:	dd8080e7          	jalr	-552(ra) # 80000bca <acquire>
  for (int i = 0; i < MAX_BSEM; i++) {
    80002dfa:	00007797          	auipc	a5,0x7
    80002dfe:	b6e78793          	addi	a5,a5,-1170 # 80009968 <bsems>
    80002e02:	4481                	li	s1,0
	  if (bsems[i] == -1) {
    80002e04:	56fd                	li	a3,-1
  for (int i = 0; i < MAX_BSEM; i++) {
    80002e06:	08000613          	li	a2,128
	  if (bsems[i] == -1) {
    80002e0a:	4398                	lw	a4,0(a5)
    80002e0c:	02d70063          	beq	a4,a3,80002e2c <bsem_alloc+0x4c>
  for (int i = 0; i < MAX_BSEM; i++) {
    80002e10:	2485                	addiw	s1,s1,1
    80002e12:	0791                	addi	a5,a5,4
    80002e14:	fec49be3          	bne	s1,a2,80002e0a <bsem_alloc+0x2a>
	  	bsems[i] = 1;
      release(&pid_lock);
	  	return i;
	  } 
	}
  release(&pid_lock);
    80002e18:	0000f517          	auipc	a0,0xf
    80002e1c:	48850513          	addi	a0,a0,1160 # 800122a0 <pid_lock>
    80002e20:	ffffe097          	auipc	ra,0xffffe
    80002e24:	e64080e7          	jalr	-412(ra) # 80000c84 <release>
  return -1;
    80002e28:	54fd                	li	s1,-1
    80002e2a:	a015                	j	80002e4e <bsem_alloc+0x6e>
	  	bsems[i] = 1;
    80002e2c:	00249713          	slli	a4,s1,0x2
    80002e30:	00007797          	auipc	a5,0x7
    80002e34:	b0078793          	addi	a5,a5,-1280 # 80009930 <initcode>
    80002e38:	97ba                	add	a5,a5,a4
    80002e3a:	4705                	li	a4,1
    80002e3c:	df98                	sw	a4,56(a5)
      release(&pid_lock);
    80002e3e:	0000f517          	auipc	a0,0xf
    80002e42:	46250513          	addi	a0,a0,1122 # 800122a0 <pid_lock>
    80002e46:	ffffe097          	auipc	ra,0xffffe
    80002e4a:	e3e080e7          	jalr	-450(ra) # 80000c84 <release>
}
    80002e4e:	8526                	mv	a0,s1
    80002e50:	60e2                	ld	ra,24(sp)
    80002e52:	6442                	ld	s0,16(sp)
    80002e54:	64a2                	ld	s1,8(sp)
    80002e56:	6105                	addi	sp,sp,32
    80002e58:	8082                	ret

0000000080002e5a <bsem_free>:

// Free bsem make it -1 again.

void bsem_free(int i){
    80002e5a:	1101                	addi	sp,sp,-32
    80002e5c:	ec06                	sd	ra,24(sp)
    80002e5e:	e822                	sd	s0,16(sp)
    80002e60:	e426                	sd	s1,8(sp)
    80002e62:	e04a                	sd	s2,0(sp)
    80002e64:	1000                	addi	s0,sp,32
    80002e66:	84aa                	mv	s1,a0
  acquire(&pid_lock);
    80002e68:	0000f917          	auipc	s2,0xf
    80002e6c:	43890913          	addi	s2,s2,1080 # 800122a0 <pid_lock>
    80002e70:	854a                	mv	a0,s2
    80002e72:	ffffe097          	auipc	ra,0xffffe
    80002e76:	d58080e7          	jalr	-680(ra) # 80000bca <acquire>
  bsems[i] = -1;
    80002e7a:	048a                	slli	s1,s1,0x2
    80002e7c:	00007517          	auipc	a0,0x7
    80002e80:	ab450513          	addi	a0,a0,-1356 # 80009930 <initcode>
    80002e84:	94aa                	add	s1,s1,a0
    80002e86:	57fd                	li	a5,-1
    80002e88:	dc9c                	sw	a5,56(s1)
  release(&pid_lock);
    80002e8a:	854a                	mv	a0,s2
    80002e8c:	ffffe097          	auipc	ra,0xffffe
    80002e90:	df8080e7          	jalr	-520(ra) # 80000c84 <release>
}
    80002e94:	60e2                	ld	ra,24(sp)
    80002e96:	6442                	ld	s0,16(sp)
    80002e98:	64a2                	ld	s1,8(sp)
    80002e9a:	6902                	ld	s2,0(sp)
    80002e9c:	6105                	addi	sp,sp,32
    80002e9e:	8082                	ret

0000000080002ea0 <bsem_down>:

/* While so that only one thread will continue. 
   sleep on chanel of kind spinlock, with lock pid_lock */

void bsem_down(int i){
    80002ea0:	7179                	addi	sp,sp,-48
    80002ea2:	f406                	sd	ra,40(sp)
    80002ea4:	f022                	sd	s0,32(sp)
    80002ea6:	ec26                	sd	s1,24(sp)
    80002ea8:	e84a                	sd	s2,16(sp)
    80002eaa:	e44e                	sd	s3,8(sp)
    80002eac:	e052                	sd	s4,0(sp)
    80002eae:	1800                	addi	s0,sp,48
    80002eb0:	8a2a                	mv	s4,a0
  acquire(&pid_lock);
    80002eb2:	0000f517          	auipc	a0,0xf
    80002eb6:	3ee50513          	addi	a0,a0,1006 # 800122a0 <pid_lock>
    80002eba:	ffffe097          	auipc	ra,0xffffe
    80002ebe:	d10080e7          	jalr	-752(ra) # 80000bca <acquire>
  while(bsems[i] == 0){
    80002ec2:	002a1713          	slli	a4,s4,0x2
    80002ec6:	00007797          	auipc	a5,0x7
    80002eca:	a6a78793          	addi	a5,a5,-1430 # 80009930 <initcode>
    80002ece:	97ba                	add	a5,a5,a4
    80002ed0:	5f9c                	lw	a5,56(a5)
    80002ed2:	e795                	bnez	a5,80002efe <bsem_down+0x5e>
    sleep(&chanel, &pid_lock);
    80002ed4:	0000f997          	auipc	s3,0xf
    80002ed8:	3cc98993          	addi	s3,s3,972 # 800122a0 <pid_lock>
    80002edc:	00010917          	auipc	s2,0x10
    80002ee0:	84c90913          	addi	s2,s2,-1972 # 80012728 <chanel>
  while(bsems[i] == 0){
    80002ee4:	00007497          	auipc	s1,0x7
    80002ee8:	a4c48493          	addi	s1,s1,-1460 # 80009930 <initcode>
    80002eec:	94ba                	add	s1,s1,a4
    sleep(&chanel, &pid_lock);
    80002eee:	85ce                	mv	a1,s3
    80002ef0:	854a                	mv	a0,s2
    80002ef2:	fffff097          	auipc	ra,0xfffff
    80002ef6:	482080e7          	jalr	1154(ra) # 80002374 <sleep>
  while(bsems[i] == 0){
    80002efa:	5c9c                	lw	a5,56(s1)
    80002efc:	dbed                	beqz	a5,80002eee <bsem_down+0x4e>
  }
  bsems[i] = 0;
    80002efe:	0a0a                	slli	s4,s4,0x2
    80002f00:	00007797          	auipc	a5,0x7
    80002f04:	a3078793          	addi	a5,a5,-1488 # 80009930 <initcode>
    80002f08:	9a3e                	add	s4,s4,a5
    80002f0a:	020a2c23          	sw	zero,56(s4)
  release(&pid_lock);
    80002f0e:	0000f517          	auipc	a0,0xf
    80002f12:	39250513          	addi	a0,a0,914 # 800122a0 <pid_lock>
    80002f16:	ffffe097          	auipc	ra,0xffffe
    80002f1a:	d6e080e7          	jalr	-658(ra) # 80000c84 <release>
}
    80002f1e:	70a2                	ld	ra,40(sp)
    80002f20:	7402                	ld	s0,32(sp)
    80002f22:	64e2                	ld	s1,24(sp)
    80002f24:	6942                	ld	s2,16(sp)
    80002f26:	69a2                	ld	s3,8(sp)
    80002f28:	6a02                	ld	s4,0(sp)
    80002f2a:	6145                	addi	sp,sp,48
    80002f2c:	8082                	ret

0000000080002f2e <bsem_up>:

// Turn bsems[i] on and wake up thread that is sleeping on chanel and waiting for bsems[i].

void bsem_up(int i){
    80002f2e:	1101                	addi	sp,sp,-32
    80002f30:	ec06                	sd	ra,24(sp)
    80002f32:	e822                	sd	s0,16(sp)
    80002f34:	e426                	sd	s1,8(sp)
    80002f36:	e04a                	sd	s2,0(sp)
    80002f38:	1000                	addi	s0,sp,32
    80002f3a:	84aa                	mv	s1,a0
  acquire(&pid_lock);
    80002f3c:	0000f917          	auipc	s2,0xf
    80002f40:	36490913          	addi	s2,s2,868 # 800122a0 <pid_lock>
    80002f44:	854a                	mv	a0,s2
    80002f46:	ffffe097          	auipc	ra,0xffffe
    80002f4a:	c84080e7          	jalr	-892(ra) # 80000bca <acquire>
  bsems[i] = 1;
    80002f4e:	048a                	slli	s1,s1,0x2
    80002f50:	00007517          	auipc	a0,0x7
    80002f54:	9e050513          	addi	a0,a0,-1568 # 80009930 <initcode>
    80002f58:	94aa                	add	s1,s1,a0
    80002f5a:	4785                	li	a5,1
    80002f5c:	dc9c                	sw	a5,56(s1)
  wakeup(&chanel);
    80002f5e:	0000f517          	auipc	a0,0xf
    80002f62:	7ca50513          	addi	a0,a0,1994 # 80012728 <chanel>
    80002f66:	fffff097          	auipc	ra,0xfffff
    80002f6a:	5ce080e7          	jalr	1486(ra) # 80002534 <wakeup>
  release(&pid_lock);
    80002f6e:	854a                	mv	a0,s2
    80002f70:	ffffe097          	auipc	ra,0xffffe
    80002f74:	d14080e7          	jalr	-748(ra) # 80000c84 <release>
}
    80002f78:	60e2                	ld	ra,24(sp)
    80002f7a:	6442                	ld	s0,16(sp)
    80002f7c:	64a2                	ld	s1,8(sp)
    80002f7e:	6902                	ld	s2,0(sp)
    80002f80:	6105                	addi	sp,sp,32
    80002f82:	8082                	ret

0000000080002f84 <kthread_create>:

  return t;
}

int
kthread_create (void ( *start_func)(), void *stack ){
    80002f84:	715d                	addi	sp,sp,-80
    80002f86:	e486                	sd	ra,72(sp)
    80002f88:	e0a2                	sd	s0,64(sp)
    80002f8a:	fc26                	sd	s1,56(sp)
    80002f8c:	f84a                	sd	s2,48(sp)
    80002f8e:	f44e                	sd	s3,40(sp)
    80002f90:	f052                	sd	s4,32(sp)
    80002f92:	ec56                	sd	s5,24(sp)
    80002f94:	e85a                	sd	s6,16(sp)
    80002f96:	e45e                	sd	s7,8(sp)
    80002f98:	0880                	addi	s0,sp,80
    80002f9a:	8b2a                	mv	s6,a0
    80002f9c:	8aae                	mv	s5,a1
  struct thread *curr_thread = mythread();
    80002f9e:	fffff097          	auipc	ra,0xfffff
    80002fa2:	ae0080e7          	jalr	-1312(ra) # 80001a7e <mythread>
    80002fa6:	8a2a                	mv	s4,a0
  struct proc *p = curr_thread->proc_parent;
    80002fa8:	02853903          	ld	s2,40(a0)
  acquire(&p->lock);
    80002fac:	854a                	mv	a0,s2
    80002fae:	ffffe097          	auipc	ra,0xffffe
    80002fb2:	c1c080e7          	jalr	-996(ra) # 80000bca <acquire>
  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
    80002fb6:	02890993          	addi	s3,s2,40
    80002fba:	6705                	lui	a4,0x1
    80002fbc:	f2870713          	addi	a4,a4,-216 # f28 <_entry-0x7ffff0d8>
    80002fc0:	974a                	add	a4,a4,s2
    80002fc2:	84ce                	mv	s1,s3
    if(t->state == UNUSED || t->state == ZOMBIE) {
    80002fc4:	4695                	li	a3,5
    80002fc6:	409c                	lw	a5,0(s1)
    80002fc8:	cb9d                	beqz	a5,80002ffe <kthread_create+0x7a>
    80002fca:	02d78a63          	beq	a5,a3,80002ffe <kthread_create+0x7a>
  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
    80002fce:	1e048493          	addi	s1,s1,480
    80002fd2:	fee49ae3          	bne	s1,a4,80002fc6 <kthread_create+0x42>
  release(&p->lock);
    80002fd6:	854a                	mv	a0,s2
    80002fd8:	ffffe097          	auipc	ra,0xffffe
    80002fdc:	cac080e7          	jalr	-852(ra) # 80000c84 <release>
  return 0;
    80002fe0:	4481                	li	s1,0
  struct thread *t = allocthread (start_func, stack);
  t->state = RUNNABLE;
    80002fe2:	478d                	li	a5,3
    80002fe4:	c09c                	sw	a5,0(s1)
  if(t == 0)
    return -1;
  return t->tid;
}
    80002fe6:	4c88                	lw	a0,24(s1)
    80002fe8:	60a6                	ld	ra,72(sp)
    80002fea:	6406                	ld	s0,64(sp)
    80002fec:	74e2                	ld	s1,56(sp)
    80002fee:	7942                	ld	s2,48(sp)
    80002ff0:	79a2                	ld	s3,40(sp)
    80002ff2:	7a02                	ld	s4,32(sp)
    80002ff4:	6ae2                	ld	s5,24(sp)
    80002ff6:	6b42                	ld	s6,16(sp)
    80002ff8:	6ba2                	ld	s7,8(sp)
    80002ffa:	6161                	addi	sp,sp,80
    80002ffc:	8082                	ret
  t->tid = alloctid();
    80002ffe:	fffff097          	auipc	ra,0xfffff
    80003002:	b06080e7          	jalr	-1274(ra) # 80001b04 <alloctid>
    80003006:	cc88                	sw	a0,24(s1)
  t->state = USED;
    80003008:	4785                	li	a5,1
    8000300a:	c09c                	sw	a5,0(s1)
  t->proc_parent = p;
    8000300c:	0324b423          	sd	s2,40(s1)
  t->thread_parent = curr_thread;
    80003010:	0344b023          	sd	s4,32(s1)
  release(&p->lock);
    80003014:	854a                	mv	a0,s2
    80003016:	ffffe097          	auipc	ra,0xffffe
    8000301a:	c6e080e7          	jalr	-914(ra) # 80000c84 <release>
  if((t->kstack = (uint64) kalloc()) == 0){
    8000301e:	ffffe097          	auipc	ra,0xffffe
    80003022:	ab4080e7          	jalr	-1356(ra) # 80000ad2 <kalloc>
    80003026:	8baa                	mv	s7,a0
    80003028:	f888                	sd	a0,48(s1)
    8000302a:	c92d                	beqz	a0,8000309c <kthread_create+0x118>
  t->trapframe = p->threads->trapframe + (sizeof(struct trapframe) * (int)(t-p->threads));
    8000302c:	41348533          	sub	a0,s1,s3
    80003030:	8515                	srai	a0,a0,0x5
    80003032:	00006797          	auipc	a5,0x6
    80003036:	fd67b783          	ld	a5,-42(a5) # 80009008 <etext+0x8>
    8000303a:	02f5053b          	mulw	a0,a0,a5
    8000303e:	67d1                	lui	a5,0x14
    80003040:	40078793          	addi	a5,a5,1024 # 14400 <_entry-0x7ffebc00>
    80003044:	02f50533          	mul	a0,a0,a5
    80003048:	06093783          	ld	a5,96(s2)
    8000304c:	953e                	add	a0,a0,a5
    8000304e:	fc88                	sd	a0,56(s1)
  memmove ((void *) t->trapframe, (void*) curr_thread->trapframe, sizeof(struct trapframe));
    80003050:	12000613          	li	a2,288
    80003054:	038a3583          	ld	a1,56(s4)
    80003058:	ffffe097          	auipc	ra,0xffffe
    8000305c:	cd0080e7          	jalr	-816(ra) # 80000d28 <memmove>
  memset(&t->context, 0, sizeof(t->context));
    80003060:	07000613          	li	a2,112
    80003064:	4581                	li	a1,0
    80003066:	16048513          	addi	a0,s1,352
    8000306a:	ffffe097          	auipc	ra,0xffffe
    8000306e:	c62080e7          	jalr	-926(ra) # 80000ccc <memset>
  t->context.ra = (uint64)forkret;
    80003072:	fffff797          	auipc	a5,0xfffff
    80003076:	9c678793          	addi	a5,a5,-1594 # 80001a38 <forkret>
    8000307a:	16f4b023          	sd	a5,352(s1)
  t->context.sp = t->kstack + PGSIZE;
    8000307e:	6785                	lui	a5,0x1
    80003080:	7898                	ld	a4,48(s1)
    80003082:	973e                	add	a4,a4,a5
    80003084:	16e4b423          	sd	a4,360(s1)
  t->trapframe->epc = (uint64) start_func;
    80003088:	7c98                	ld	a4,56(s1)
    8000308a:	01673c23          	sd	s6,24(a4)
  t->trapframe->sp = (uint64) stack + MAX_STACK_SIZE; 
    8000308e:	7c98                	ld	a4,56(s1)
    80003090:	fa078793          	addi	a5,a5,-96 # fa0 <_entry-0x7ffff060>
    80003094:	9abe                	add	s5,s5,a5
    80003096:	03573823          	sd	s5,48(a4)
  return t;
    8000309a:	b7a1                	j	80002fe2 <kthread_create+0x5e>
    freethread(t);
    8000309c:	8526                	mv	a0,s1
    8000309e:	ffffe097          	auipc	ra,0xffffe
    800030a2:	77c080e7          	jalr	1916(ra) # 8000181a <freethread>
    release(&p->lock);
    800030a6:	854a                	mv	a0,s2
    800030a8:	ffffe097          	auipc	ra,0xffffe
    800030ac:	bdc080e7          	jalr	-1060(ra) # 80000c84 <release>
    return 0;
    800030b0:	84de                	mv	s1,s7
    800030b2:	bf05                	j	80002fe2 <kthread_create+0x5e>

00000000800030b4 <kthread_id>:

int
kthread_id(){
    800030b4:	1141                	addi	sp,sp,-16
    800030b6:	e406                	sd	ra,8(sp)
    800030b8:	e022                	sd	s0,0(sp)
    800030ba:	0800                	addi	s0,sp,16
  return mythread()->tid;
    800030bc:	fffff097          	auipc	ra,0xfffff
    800030c0:	9c2080e7          	jalr	-1598(ra) # 80001a7e <mythread>
}
    800030c4:	4d08                	lw	a0,24(a0)
    800030c6:	60a2                	ld	ra,8(sp)
    800030c8:	6402                	ld	s0,0(sp)
    800030ca:	0141                	addi	sp,sp,16
    800030cc:	8082                	ret

00000000800030ce <kthread_exit>:

void
kthread_exit(int status){
    800030ce:	7179                	addi	sp,sp,-48
    800030d0:	f406                	sd	ra,40(sp)
    800030d2:	f022                	sd	s0,32(sp)
    800030d4:	ec26                	sd	s1,24(sp)
    800030d6:	e84a                	sd	s2,16(sp)
    800030d8:	e44e                	sd	s3,8(sp)
    800030da:	1800                	addi	s0,sp,48
    800030dc:	89aa                	mv	s3,a0
  struct thread *t = mythread();
    800030de:	fffff097          	auipc	ra,0xfffff
    800030e2:	9a0080e7          	jalr	-1632(ra) # 80001a7e <mythread>
    800030e6:	84aa                	mv	s1,a0
  printf("inside exit for tid: %d\n", t->tid);
    800030e8:	4d0c                	lw	a1,24(a0)
    800030ea:	00006517          	auipc	a0,0x6
    800030ee:	1fe50513          	addi	a0,a0,510 # 800092e8 <digits+0x2a8>
    800030f2:	ffffd097          	auipc	ra,0xffffd
    800030f6:	482080e7          	jalr	1154(ra) # 80000574 <printf>
  struct proc *p = t->proc_parent;
    800030fa:	0284b903          	ld	s2,40(s1)

  acquire(&wait_lock);
    800030fe:	0000f517          	auipc	a0,0xf
    80003102:	1ba50513          	addi	a0,a0,442 # 800122b8 <wait_lock>
    80003106:	ffffe097          	auipc	ra,0xffffe
    8000310a:	ac4080e7          	jalr	-1340(ra) # 80000bca <acquire>

  Treparent (t);
    8000310e:	8526                	mv	a0,s1
    80003110:	fffff097          	auipc	ra,0xfffff
    80003114:	53a080e7          	jalr	1338(ra) # 8000264a <Treparent>

    // Parent might be sleeping in wait().
  if(t->thread_parent)
    80003118:	7088                	ld	a0,32(s1)
    8000311a:	c509                	beqz	a0,80003124 <kthread_exit+0x56>
    wakeup(t->thread_parent);
    8000311c:	fffff097          	auipc	ra,0xfffff
    80003120:	418080e7          	jalr	1048(ra) # 80002534 <wakeup>

  t->xstate = status;
    80003124:	0134aa23          	sw	s3,20(s1)
  t->state = ZOMBIE;
    80003128:	4795                	li	a5,5
    8000312a:	c09c                	sw	a5,0(s1)
  printf("update status for tid: %d\n", t->tid);
    8000312c:	4c8c                	lw	a1,24(s1)
    8000312e:	00006517          	auipc	a0,0x6
    80003132:	1da50513          	addi	a0,a0,474 # 80009308 <digits+0x2c8>
    80003136:	ffffd097          	auipc	ra,0xffffd
    8000313a:	43e080e7          	jalr	1086(ra) # 80000574 <printf>
    // Check if this is the last thread of the process
  struct thread * tt;
  acquire(&p->lock);
    8000313e:	854a                	mv	a0,s2
    80003140:	ffffe097          	auipc	ra,0xffffe
    80003144:	a8a080e7          	jalr	-1398(ra) # 80000bca <acquire>
  for (tt = p->threads; tt < &p->threads[NTHREAD]; tt++){
    80003148:	02890793          	addi	a5,s2,40
    8000314c:	6685                	lui	a3,0x1
    8000314e:	f2868693          	addi	a3,a3,-216 # f28 <_entry-0x7ffff0d8>
    80003152:	96ca                	add	a3,a3,s2
      if(tt->state == USED || tt->state == SLEEPING || tt->state == RUNNABLE || tt->state == RUNNING){
    80003154:	460d                	li	a2,3
    80003156:	4398                	lw	a4,0(a5)
    80003158:	377d                	addiw	a4,a4,-1
    8000315a:	02e67863          	bgeu	a2,a4,8000318a <kthread_exit+0xbc>
  for (tt = p->threads; tt < &p->threads[NTHREAD]; tt++){
    8000315e:	1e078793          	addi	a5,a5,480
    80003162:	fef69ae3          	bne	a3,a5,80003156 <kthread_exit+0x88>
        goto found;
      }
  }
    //not found an active thread, should terminate the process
  release(&p->lock);
    80003166:	854a                	mv	a0,s2
    80003168:	ffffe097          	auipc	ra,0xffffe
    8000316c:	b1c080e7          	jalr	-1252(ra) # 80000c84 <release>
  release(&wait_lock);
    80003170:	0000f517          	auipc	a0,0xf
    80003174:	14850513          	addi	a0,a0,328 # 800122b8 <wait_lock>
    80003178:	ffffe097          	auipc	ra,0xffffe
    8000317c:	b0c080e7          	jalr	-1268(ra) # 80000c84 <release>
  exit(0);
    80003180:	4501                	li	a0,0
    80003182:	fffff097          	auipc	ra,0xfffff
    80003186:	53c080e7          	jalr	1340(ra) # 800026be <exit>
  panic("zombie exit");

  found:
  release(&wait_lock);
    8000318a:	0000f517          	auipc	a0,0xf
    8000318e:	12e50513          	addi	a0,a0,302 # 800122b8 <wait_lock>
    80003192:	ffffe097          	auipc	ra,0xffffe
    80003196:	af2080e7          	jalr	-1294(ra) # 80000c84 <release>

    // Jump into the scheduler, never to return.
  sched();
    8000319a:	fffff097          	auipc	ra,0xfffff
    8000319e:	0a4080e7          	jalr	164(ra) # 8000223e <sched>
  panic("zombie exit");
    800031a2:	00006517          	auipc	a0,0x6
    800031a6:	0e650513          	addi	a0,a0,230 # 80009288 <digits+0x248>
    800031aa:	ffffd097          	auipc	ra,0xffffd
    800031ae:	380080e7          	jalr	896(ra) # 8000052a <panic>

00000000800031b2 <kthread_join>:
}

int
kthread_join (int thread_id, int *status){
    800031b2:	1101                	addi	sp,sp,-32
    800031b4:	ec06                	sd	ra,24(sp)
    800031b6:	e822                	sd	s0,16(sp)
    800031b8:	e426                	sd	s1,8(sp)
    800031ba:	e04a                	sd	s2,0(sp)
    800031bc:	1000                	addi	s0,sp,32
    800031be:	84aa                	mv	s1,a0
  struct thread *t = mythread();
    800031c0:	fffff097          	auipc	ra,0xfffff
    800031c4:	8be080e7          	jalr	-1858(ra) # 80001a7e <mythread>
  struct proc *p = t->proc_parent;
    800031c8:	02853903          	ld	s2,40(a0)

    // Check if there's a thread with the thread_id
  struct thread * tt;
  acquire(&p->lock);
    800031cc:	854a                	mv	a0,s2
    800031ce:	ffffe097          	auipc	ra,0xffffe
    800031d2:	9fc080e7          	jalr	-1540(ra) # 80000bca <acquire>
  for (tt = p->threads; tt < &p->threads[NTHREAD]; tt++){
    800031d6:	02890793          	addi	a5,s2,40
    800031da:	6685                	lui	a3,0x1
    800031dc:	f2868693          	addi	a3,a3,-216 # f28 <_entry-0x7ffff0d8>
    800031e0:	96ca                	add	a3,a3,s2
    if(tt->tid == thread_id){
    800031e2:	4f98                	lw	a4,24(a5)
    800031e4:	02970263          	beq	a4,s1,80003208 <kthread_join+0x56>
  for (tt = p->threads; tt < &p->threads[NTHREAD]; tt++){
    800031e8:	1e078793          	addi	a5,a5,480
    800031ec:	fed79be3          	bne	a5,a3,800031e2 <kthread_join+0x30>
    } else {
    }
  }

    // Means didn't find a thread of the process with this ID
  release(&p->lock);
    800031f0:	854a                	mv	a0,s2
    800031f2:	ffffe097          	auipc	ra,0xffffe
    800031f6:	a92080e7          	jalr	-1390(ra) # 80000c84 <release>
  return -1;
    800031fa:	557d                	li	a0,-1
    *status = tt->xstate; 
    return 0;
  }
  goto sleeping;

    800031fc:	60e2                	ld	ra,24(sp)
    800031fe:	6442                	ld	s0,16(sp)
    80003200:	64a2                	ld	s1,8(sp)
    80003202:	6902                	ld	s2,0(sp)
    80003204:	6105                	addi	sp,sp,32
    80003206:	8082                	ret
  release(&p->lock);
    80003208:	854a                	mv	a0,s2
    8000320a:	ffffe097          	auipc	ra,0xffffe
    8000320e:	a7a080e7          	jalr	-1414(ra) # 80000c84 <release>
    return 0;
    80003212:	4501                	li	a0,0
    80003214:	b7e5                	j	800031fc <kthread_join+0x4a>

0000000080003216 <swtch>:
    80003216:	00153023          	sd	ra,0(a0)
    8000321a:	00253423          	sd	sp,8(a0)
    8000321e:	e900                	sd	s0,16(a0)
    80003220:	ed04                	sd	s1,24(a0)
    80003222:	03253023          	sd	s2,32(a0)
    80003226:	03353423          	sd	s3,40(a0)
    8000322a:	03453823          	sd	s4,48(a0)
    8000322e:	03553c23          	sd	s5,56(a0)
    80003232:	05653023          	sd	s6,64(a0)
    80003236:	05753423          	sd	s7,72(a0)
    8000323a:	05853823          	sd	s8,80(a0)
    8000323e:	05953c23          	sd	s9,88(a0)
    80003242:	07a53023          	sd	s10,96(a0)
    80003246:	07b53423          	sd	s11,104(a0)
    8000324a:	0005b083          	ld	ra,0(a1)
    8000324e:	0085b103          	ld	sp,8(a1)
    80003252:	6980                	ld	s0,16(a1)
    80003254:	6d84                	ld	s1,24(a1)
    80003256:	0205b903          	ld	s2,32(a1)
    8000325a:	0285b983          	ld	s3,40(a1)
    8000325e:	0305ba03          	ld	s4,48(a1)
    80003262:	0385ba83          	ld	s5,56(a1)
    80003266:	0405bb03          	ld	s6,64(a1)
    8000326a:	0485bb83          	ld	s7,72(a1)
    8000326e:	0505bc03          	ld	s8,80(a1)
    80003272:	0585bc83          	ld	s9,88(a1)
    80003276:	0605bd03          	ld	s10,96(a1)
    8000327a:	0685bd83          	ld	s11,104(a1)
    8000327e:	8082                	ret

0000000080003280 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80003280:	1141                	addi	sp,sp,-16
    80003282:	e406                	sd	ra,8(sp)
    80003284:	e022                	sd	s0,0(sp)
    80003286:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80003288:	00006597          	auipc	a1,0x6
    8000328c:	0f858593          	addi	a1,a1,248 # 80009380 <states.0+0x30>
    80003290:	00055517          	auipc	a0,0x55
    80003294:	2c850513          	addi	a0,a0,712 # 80058558 <tickslock>
    80003298:	ffffe097          	auipc	ra,0xffffe
    8000329c:	89a080e7          	jalr	-1894(ra) # 80000b32 <initlock>
}
    800032a0:	60a2                	ld	ra,8(sp)
    800032a2:	6402                	ld	s0,0(sp)
    800032a4:	0141                	addi	sp,sp,16
    800032a6:	8082                	ret

00000000800032a8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800032a8:	1141                	addi	sp,sp,-16
    800032aa:	e422                	sd	s0,8(sp)
    800032ac:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800032ae:	00003797          	auipc	a5,0x3
    800032b2:	7e278793          	addi	a5,a5,2018 # 80006a90 <kernelvec>
    800032b6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800032ba:	6422                	ld	s0,8(sp)
    800032bc:	0141                	addi	sp,sp,16
    800032be:	8082                	ret

00000000800032c0 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800032c0:	1101                	addi	sp,sp,-32
    800032c2:	ec06                	sd	ra,24(sp)
    800032c4:	e822                	sd	s0,16(sp)
    800032c6:	e426                	sd	s1,8(sp)
    800032c8:	e04a                	sd	s2,0(sp)
    800032ca:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800032cc:	ffffe097          	auipc	ra,0xffffe
    800032d0:	72c080e7          	jalr	1836(ra) # 800019f8 <myproc>
    800032d4:	892a                	mv	s2,a0
  struct thread *t = mythread();
    800032d6:	ffffe097          	auipc	ra,0xffffe
    800032da:	7a8080e7          	jalr	1960(ra) # 80001a7e <mythread>
    800032de:	84aa                	mv	s1,a0
  handling_signals();
    800032e0:	00000097          	auipc	ra,0x0
    800032e4:	99e080e7          	jalr	-1634(ra) # 80002c7e <handling_signals>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800032e8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800032ec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800032ee:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    800032f2:	00005817          	auipc	a6,0x5
    800032f6:	d0e80813          	addi	a6,a6,-754 # 80008000 <_trampoline>
    800032fa:	00005697          	auipc	a3,0x5
    800032fe:	d0668693          	addi	a3,a3,-762 # 80008000 <_trampoline>
    80003302:	410686b3          	sub	a3,a3,a6
    80003306:	040007b7          	lui	a5,0x4000
    8000330a:	17fd                	addi	a5,a5,-1
    8000330c:	07b2                	slli	a5,a5,0xc
    8000330e:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003310:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  t->trapframe->kernel_satp = r_satp();         // kernel page table
    80003314:	7c98                	ld	a4,56(s1)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80003316:	180026f3          	csrr	a3,satp
    8000331a:	e314                	sd	a3,0(a4)
  t->trapframe->kernel_sp = t->kstack + PGSIZE; // process's kernel stack
    8000331c:	7c98                	ld	a4,56(s1)
    8000331e:	6605                	lui	a2,0x1
    80003320:	7894                	ld	a3,48(s1)
    80003322:	96b2                	add	a3,a3,a2
    80003324:	e714                	sd	a3,8(a4)
  t->trapframe->kernel_trap = (uint64)usertrap;
    80003326:	7c98                	ld	a4,56(s1)
    80003328:	00000697          	auipc	a3,0x0
    8000332c:	16268693          	addi	a3,a3,354 # 8000348a <usertrap>
    80003330:	eb14                	sd	a3,16(a4)
  t->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80003332:	7c98                	ld	a4,56(s1)
  asm volatile("mv %0, tp" : "=r" (x) );
    80003334:	8692                	mv	a3,tp
    80003336:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003338:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000333c:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80003340:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003344:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(t->trapframe->epc);
    80003348:	7c98                	ld	a4,56(s1)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000334a:	6f18                	ld	a4,24(a4)
    8000334c:	14171073          	csrw	sepc,a4

  

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80003350:	964a                	add	a2,a2,s2
    80003352:	f4063583          	ld	a1,-192(a2) # f40 <_entry-0x7ffff0c0>
    80003356:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
  ((void (*)(uint64,uint64))fn)(TRAPFRAME + (sizeof(struct trapframe) * (t-p->threads)), satp);
    80003358:	02890513          	addi	a0,s2,40
    8000335c:	40a48533          	sub	a0,s1,a0
    80003360:	8515                	srai	a0,a0,0x5
    80003362:	00006497          	auipc	s1,0x6
    80003366:	ca64b483          	ld	s1,-858(s1) # 80009008 <etext+0x8>
    8000336a:	02950533          	mul	a0,a0,s1
    8000336e:	00351493          	slli	s1,a0,0x3
    80003372:	9526                	add	a0,a0,s1
    80003374:	0516                	slli	a0,a0,0x5
    80003376:	020006b7          	lui	a3,0x2000
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    8000337a:	00005717          	auipc	a4,0x5
    8000337e:	d1670713          	addi	a4,a4,-746 # 80008090 <userret>
    80003382:	41070733          	sub	a4,a4,a6
    80003386:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME + (sizeof(struct trapframe) * (t-p->threads)), satp);
    80003388:	577d                	li	a4,-1
    8000338a:	177e                	slli	a4,a4,0x3f
    8000338c:	8dd9                	or	a1,a1,a4
    8000338e:	16fd                	addi	a3,a3,-1
    80003390:	06b6                	slli	a3,a3,0xd
    80003392:	9536                	add	a0,a0,a3
    80003394:	9782                	jalr	a5
}
    80003396:	60e2                	ld	ra,24(sp)
    80003398:	6442                	ld	s0,16(sp)
    8000339a:	64a2                	ld	s1,8(sp)
    8000339c:	6902                	ld	s2,0(sp)
    8000339e:	6105                	addi	sp,sp,32
    800033a0:	8082                	ret

00000000800033a2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800033a2:	1101                	addi	sp,sp,-32
    800033a4:	ec06                	sd	ra,24(sp)
    800033a6:	e822                	sd	s0,16(sp)
    800033a8:	e426                	sd	s1,8(sp)
    800033aa:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800033ac:	00055497          	auipc	s1,0x55
    800033b0:	1ac48493          	addi	s1,s1,428 # 80058558 <tickslock>
    800033b4:	8526                	mv	a0,s1
    800033b6:	ffffe097          	auipc	ra,0xffffe
    800033ba:	814080e7          	jalr	-2028(ra) # 80000bca <acquire>
  ticks++;
    800033be:	00007517          	auipc	a0,0x7
    800033c2:	c7250513          	addi	a0,a0,-910 # 8000a030 <ticks>
    800033c6:	411c                	lw	a5,0(a0)
    800033c8:	2785                	addiw	a5,a5,1
    800033ca:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800033cc:	fffff097          	auipc	ra,0xfffff
    800033d0:	168080e7          	jalr	360(ra) # 80002534 <wakeup>
  release(&tickslock);
    800033d4:	8526                	mv	a0,s1
    800033d6:	ffffe097          	auipc	ra,0xffffe
    800033da:	8ae080e7          	jalr	-1874(ra) # 80000c84 <release>
}
    800033de:	60e2                	ld	ra,24(sp)
    800033e0:	6442                	ld	s0,16(sp)
    800033e2:	64a2                	ld	s1,8(sp)
    800033e4:	6105                	addi	sp,sp,32
    800033e6:	8082                	ret

00000000800033e8 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800033e8:	1101                	addi	sp,sp,-32
    800033ea:	ec06                	sd	ra,24(sp)
    800033ec:	e822                	sd	s0,16(sp)
    800033ee:	e426                	sd	s1,8(sp)
    800033f0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800033f2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800033f6:	00074d63          	bltz	a4,80003410 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    800033fa:	57fd                	li	a5,-1
    800033fc:	17fe                	slli	a5,a5,0x3f
    800033fe:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80003400:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80003402:	06f70363          	beq	a4,a5,80003468 <devintr+0x80>
  }
}
    80003406:	60e2                	ld	ra,24(sp)
    80003408:	6442                	ld	s0,16(sp)
    8000340a:	64a2                	ld	s1,8(sp)
    8000340c:	6105                	addi	sp,sp,32
    8000340e:	8082                	ret
     (scause & 0xff) == 9){
    80003410:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80003414:	46a5                	li	a3,9
    80003416:	fed792e3          	bne	a5,a3,800033fa <devintr+0x12>
    int irq = plic_claim();
    8000341a:	00003097          	auipc	ra,0x3
    8000341e:	77e080e7          	jalr	1918(ra) # 80006b98 <plic_claim>
    80003422:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80003424:	47a9                	li	a5,10
    80003426:	02f50763          	beq	a0,a5,80003454 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    8000342a:	4785                	li	a5,1
    8000342c:	02f50963          	beq	a0,a5,8000345e <devintr+0x76>
    return 1;
    80003430:	4505                	li	a0,1
    } else if(irq){
    80003432:	d8f1                	beqz	s1,80003406 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80003434:	85a6                	mv	a1,s1
    80003436:	00006517          	auipc	a0,0x6
    8000343a:	f5250513          	addi	a0,a0,-174 # 80009388 <states.0+0x38>
    8000343e:	ffffd097          	auipc	ra,0xffffd
    80003442:	136080e7          	jalr	310(ra) # 80000574 <printf>
      plic_complete(irq);
    80003446:	8526                	mv	a0,s1
    80003448:	00003097          	auipc	ra,0x3
    8000344c:	774080e7          	jalr	1908(ra) # 80006bbc <plic_complete>
    return 1;
    80003450:	4505                	li	a0,1
    80003452:	bf55                	j	80003406 <devintr+0x1e>
      uartintr();
    80003454:	ffffd097          	auipc	ra,0xffffd
    80003458:	532080e7          	jalr	1330(ra) # 80000986 <uartintr>
    8000345c:	b7ed                	j	80003446 <devintr+0x5e>
      virtio_disk_intr();
    8000345e:	00004097          	auipc	ra,0x4
    80003462:	bf6080e7          	jalr	-1034(ra) # 80007054 <virtio_disk_intr>
    80003466:	b7c5                	j	80003446 <devintr+0x5e>
    if(cpuid() == 0){
    80003468:	ffffe097          	auipc	ra,0xffffe
    8000346c:	55c080e7          	jalr	1372(ra) # 800019c4 <cpuid>
    80003470:	c901                	beqz	a0,80003480 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80003472:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80003476:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80003478:	14479073          	csrw	sip,a5
    return 2;
    8000347c:	4509                	li	a0,2
    8000347e:	b761                	j	80003406 <devintr+0x1e>
      clockintr();
    80003480:	00000097          	auipc	ra,0x0
    80003484:	f22080e7          	jalr	-222(ra) # 800033a2 <clockintr>
    80003488:	b7ed                	j	80003472 <devintr+0x8a>

000000008000348a <usertrap>:
{
    8000348a:	1101                	addi	sp,sp,-32
    8000348c:	ec06                	sd	ra,24(sp)
    8000348e:	e822                	sd	s0,16(sp)
    80003490:	e426                	sd	s1,8(sp)
    80003492:	e04a                	sd	s2,0(sp)
    80003494:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003496:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000349a:	1007f793          	andi	a5,a5,256
    8000349e:	e3bd                	bnez	a5,80003504 <usertrap+0x7a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800034a0:	00003797          	auipc	a5,0x3
    800034a4:	5f078793          	addi	a5,a5,1520 # 80006a90 <kernelvec>
    800034a8:	10579073          	csrw	stvec,a5
  struct thread *t = mythread();
    800034ac:	ffffe097          	auipc	ra,0xffffe
    800034b0:	5d2080e7          	jalr	1490(ra) # 80001a7e <mythread>
    800034b4:	84aa                	mv	s1,a0
  t->trapframe->epc = r_sepc();
    800034b6:	7d1c                	ld	a5,56(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800034b8:	14102773          	csrr	a4,sepc
    800034bc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800034be:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800034c2:	47a1                	li	a5,8
    800034c4:	04f71e63          	bne	a4,a5,80003520 <usertrap+0x96>
    if(t->proc_parent->killed)
    800034c8:	751c                	ld	a5,40(a0)
    800034ca:	4fdc                	lw	a5,28(a5)
    800034cc:	e7a1                	bnez	a5,80003514 <usertrap+0x8a>
    t->trapframe->epc += 4;
    800034ce:	7c98                	ld	a4,56(s1)
    800034d0:	6f1c                	ld	a5,24(a4)
    800034d2:	0791                	addi	a5,a5,4
    800034d4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800034d6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800034da:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800034de:	10079073          	csrw	sstatus,a5
    syscall();
    800034e2:	00000097          	auipc	ra,0x0
    800034e6:	2f8080e7          	jalr	760(ra) # 800037da <syscall>
  if(t->proc_parent->killed)
    800034ea:	749c                	ld	a5,40(s1)
    800034ec:	4fdc                	lw	a5,28(a5)
    800034ee:	efb5                	bnez	a5,8000356a <usertrap+0xe0>
  usertrapret();
    800034f0:	00000097          	auipc	ra,0x0
    800034f4:	dd0080e7          	jalr	-560(ra) # 800032c0 <usertrapret>
}
    800034f8:	60e2                	ld	ra,24(sp)
    800034fa:	6442                	ld	s0,16(sp)
    800034fc:	64a2                	ld	s1,8(sp)
    800034fe:	6902                	ld	s2,0(sp)
    80003500:	6105                	addi	sp,sp,32
    80003502:	8082                	ret
    panic("usertrap: not from user mode");
    80003504:	00006517          	auipc	a0,0x6
    80003508:	ea450513          	addi	a0,a0,-348 # 800093a8 <states.0+0x58>
    8000350c:	ffffd097          	auipc	ra,0xffffd
    80003510:	01e080e7          	jalr	30(ra) # 8000052a <panic>
      exit(-1);
    80003514:	557d                	li	a0,-1
    80003516:	fffff097          	auipc	ra,0xfffff
    8000351a:	1a8080e7          	jalr	424(ra) # 800026be <exit>
    8000351e:	bf45                	j	800034ce <usertrap+0x44>
  } else if((which_dev = devintr()) != 0){
    80003520:	00000097          	auipc	ra,0x0
    80003524:	ec8080e7          	jalr	-312(ra) # 800033e8 <devintr>
    80003528:	892a                	mv	s2,a0
    8000352a:	c509                	beqz	a0,80003534 <usertrap+0xaa>
  if(t->proc_parent->killed)
    8000352c:	749c                	ld	a5,40(s1)
    8000352e:	4fdc                	lw	a5,28(a5)
    80003530:	c3b9                	beqz	a5,80003576 <usertrap+0xec>
    80003532:	a82d                	j	8000356c <usertrap+0xe2>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003534:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p tid=%d\n", r_scause(), t->tid);
    80003538:	4c90                	lw	a2,24(s1)
    8000353a:	00006517          	auipc	a0,0x6
    8000353e:	e8e50513          	addi	a0,a0,-370 # 800093c8 <states.0+0x78>
    80003542:	ffffd097          	auipc	ra,0xffffd
    80003546:	032080e7          	jalr	50(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000354a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000354e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003552:	00006517          	auipc	a0,0x6
    80003556:	ea650513          	addi	a0,a0,-346 # 800093f8 <states.0+0xa8>
    8000355a:	ffffd097          	auipc	ra,0xffffd
    8000355e:	01a080e7          	jalr	26(ra) # 80000574 <printf>
    t->proc_parent->killed = 1;
    80003562:	749c                	ld	a5,40(s1)
    80003564:	4705                	li	a4,1
    80003566:	cfd8                	sw	a4,28(a5)
    80003568:	b749                	j	800034ea <usertrap+0x60>
  if(t->proc_parent->killed)
    8000356a:	4901                	li	s2,0
    exit(-1);
    8000356c:	557d                	li	a0,-1
    8000356e:	fffff097          	auipc	ra,0xfffff
    80003572:	150080e7          	jalr	336(ra) # 800026be <exit>
  if(which_dev == 2)
    80003576:	4789                	li	a5,2
    80003578:	f6f91ce3          	bne	s2,a5,800034f0 <usertrap+0x66>
    yield();
    8000357c:	fffff097          	auipc	ra,0xfffff
    80003580:	dba080e7          	jalr	-582(ra) # 80002336 <yield>
    80003584:	b7b5                	j	800034f0 <usertrap+0x66>

0000000080003586 <kerneltrap>:
{
    80003586:	7179                	addi	sp,sp,-48
    80003588:	f406                	sd	ra,40(sp)
    8000358a:	f022                	sd	s0,32(sp)
    8000358c:	ec26                	sd	s1,24(sp)
    8000358e:	e84a                	sd	s2,16(sp)
    80003590:	e44e                	sd	s3,8(sp)
    80003592:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003594:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003598:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000359c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800035a0:	1004f793          	andi	a5,s1,256
    800035a4:	cb85                	beqz	a5,800035d4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800035a6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800035aa:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800035ac:	ef85                	bnez	a5,800035e4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800035ae:	00000097          	auipc	ra,0x0
    800035b2:	e3a080e7          	jalr	-454(ra) # 800033e8 <devintr>
    800035b6:	cd1d                	beqz	a0,800035f4 <kerneltrap+0x6e>
  if(which_dev == 2 && mythread() != 0 && mythread()->state == RUNNING)
    800035b8:	4789                	li	a5,2
    800035ba:	06f50a63          	beq	a0,a5,8000362e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800035be:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800035c2:	10049073          	csrw	sstatus,s1
}
    800035c6:	70a2                	ld	ra,40(sp)
    800035c8:	7402                	ld	s0,32(sp)
    800035ca:	64e2                	ld	s1,24(sp)
    800035cc:	6942                	ld	s2,16(sp)
    800035ce:	69a2                	ld	s3,8(sp)
    800035d0:	6145                	addi	sp,sp,48
    800035d2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800035d4:	00006517          	auipc	a0,0x6
    800035d8:	e4450513          	addi	a0,a0,-444 # 80009418 <states.0+0xc8>
    800035dc:	ffffd097          	auipc	ra,0xffffd
    800035e0:	f4e080e7          	jalr	-178(ra) # 8000052a <panic>
    panic("kerneltrap: interrupts enabled");
    800035e4:	00006517          	auipc	a0,0x6
    800035e8:	e5c50513          	addi	a0,a0,-420 # 80009440 <states.0+0xf0>
    800035ec:	ffffd097          	auipc	ra,0xffffd
    800035f0:	f3e080e7          	jalr	-194(ra) # 8000052a <panic>
    printf("scause %p\n", scause);
    800035f4:	85ce                	mv	a1,s3
    800035f6:	00006517          	auipc	a0,0x6
    800035fa:	e6a50513          	addi	a0,a0,-406 # 80009460 <states.0+0x110>
    800035fe:	ffffd097          	auipc	ra,0xffffd
    80003602:	f76080e7          	jalr	-138(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003606:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000360a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000360e:	00006517          	auipc	a0,0x6
    80003612:	e6250513          	addi	a0,a0,-414 # 80009470 <states.0+0x120>
    80003616:	ffffd097          	auipc	ra,0xffffd
    8000361a:	f5e080e7          	jalr	-162(ra) # 80000574 <printf>
    panic("kerneltrap");
    8000361e:	00006517          	auipc	a0,0x6
    80003622:	e6a50513          	addi	a0,a0,-406 # 80009488 <states.0+0x138>
    80003626:	ffffd097          	auipc	ra,0xffffd
    8000362a:	f04080e7          	jalr	-252(ra) # 8000052a <panic>
  if(which_dev == 2 && mythread() != 0 && mythread()->state == RUNNING)
    8000362e:	ffffe097          	auipc	ra,0xffffe
    80003632:	450080e7          	jalr	1104(ra) # 80001a7e <mythread>
    80003636:	d541                	beqz	a0,800035be <kerneltrap+0x38>
    80003638:	ffffe097          	auipc	ra,0xffffe
    8000363c:	446080e7          	jalr	1094(ra) # 80001a7e <mythread>
    80003640:	4118                	lw	a4,0(a0)
    80003642:	4791                	li	a5,4
    80003644:	f6f71de3          	bne	a4,a5,800035be <kerneltrap+0x38>
    yield();
    80003648:	fffff097          	auipc	ra,0xfffff
    8000364c:	cee080e7          	jalr	-786(ra) # 80002336 <yield>
    80003650:	b7bd                	j	800035be <kerneltrap+0x38>

0000000080003652 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80003652:	1101                	addi	sp,sp,-32
    80003654:	ec06                	sd	ra,24(sp)
    80003656:	e822                	sd	s0,16(sp)
    80003658:	e426                	sd	s1,8(sp)
    8000365a:	1000                	addi	s0,sp,32
    8000365c:	84aa                	mv	s1,a0
  struct thread *t = mythread();
    8000365e:	ffffe097          	auipc	ra,0xffffe
    80003662:	420080e7          	jalr	1056(ra) # 80001a7e <mythread>
  switch (n) {
    80003666:	4795                	li	a5,5
    80003668:	0497e163          	bltu	a5,s1,800036aa <argraw+0x58>
    8000366c:	048a                	slli	s1,s1,0x2
    8000366e:	00006717          	auipc	a4,0x6
    80003672:	e5270713          	addi	a4,a4,-430 # 800094c0 <states.0+0x170>
    80003676:	94ba                	add	s1,s1,a4
    80003678:	409c                	lw	a5,0(s1)
    8000367a:	97ba                	add	a5,a5,a4
    8000367c:	8782                	jr	a5
  case 0:
    return t->trapframe->a0;
    8000367e:	7d1c                	ld	a5,56(a0)
    80003680:	7ba8                	ld	a0,112(a5)
  case 5:
    return t->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80003682:	60e2                	ld	ra,24(sp)
    80003684:	6442                	ld	s0,16(sp)
    80003686:	64a2                	ld	s1,8(sp)
    80003688:	6105                	addi	sp,sp,32
    8000368a:	8082                	ret
    return t->trapframe->a1;
    8000368c:	7d1c                	ld	a5,56(a0)
    8000368e:	7fa8                	ld	a0,120(a5)
    80003690:	bfcd                	j	80003682 <argraw+0x30>
    return t->trapframe->a2;
    80003692:	7d1c                	ld	a5,56(a0)
    80003694:	63c8                	ld	a0,128(a5)
    80003696:	b7f5                	j	80003682 <argraw+0x30>
    return t->trapframe->a3;
    80003698:	7d1c                	ld	a5,56(a0)
    8000369a:	67c8                	ld	a0,136(a5)
    8000369c:	b7dd                	j	80003682 <argraw+0x30>
    return t->trapframe->a4;
    8000369e:	7d1c                	ld	a5,56(a0)
    800036a0:	6bc8                	ld	a0,144(a5)
    800036a2:	b7c5                	j	80003682 <argraw+0x30>
    return t->trapframe->a5;
    800036a4:	7d1c                	ld	a5,56(a0)
    800036a6:	6fc8                	ld	a0,152(a5)
    800036a8:	bfe9                	j	80003682 <argraw+0x30>
  panic("argraw");
    800036aa:	00006517          	auipc	a0,0x6
    800036ae:	dee50513          	addi	a0,a0,-530 # 80009498 <states.0+0x148>
    800036b2:	ffffd097          	auipc	ra,0xffffd
    800036b6:	e78080e7          	jalr	-392(ra) # 8000052a <panic>

00000000800036ba <fetchaddr>:
{
    800036ba:	1101                	addi	sp,sp,-32
    800036bc:	ec06                	sd	ra,24(sp)
    800036be:	e822                	sd	s0,16(sp)
    800036c0:	e426                	sd	s1,8(sp)
    800036c2:	e04a                	sd	s2,0(sp)
    800036c4:	1000                	addi	s0,sp,32
    800036c6:	84aa                	mv	s1,a0
    800036c8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800036ca:	ffffe097          	auipc	ra,0xffffe
    800036ce:	32e080e7          	jalr	814(ra) # 800019f8 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800036d2:	6785                	lui	a5,0x1
    800036d4:	97aa                	add	a5,a5,a0
    800036d6:	f387b783          	ld	a5,-200(a5) # f38 <_entry-0x7ffff0c8>
    800036da:	02f4fb63          	bgeu	s1,a5,80003710 <fetchaddr+0x56>
    800036de:	00848713          	addi	a4,s1,8
    800036e2:	02e7e963          	bltu	a5,a4,80003714 <fetchaddr+0x5a>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800036e6:	6785                	lui	a5,0x1
    800036e8:	97aa                	add	a5,a5,a0
    800036ea:	46a1                	li	a3,8
    800036ec:	8626                	mv	a2,s1
    800036ee:	85ca                	mv	a1,s2
    800036f0:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    800036f4:	ffffe097          	auipc	ra,0xffffe
    800036f8:	fe4080e7          	jalr	-28(ra) # 800016d8 <copyin>
    800036fc:	00a03533          	snez	a0,a0
    80003700:	40a00533          	neg	a0,a0
}
    80003704:	60e2                	ld	ra,24(sp)
    80003706:	6442                	ld	s0,16(sp)
    80003708:	64a2                	ld	s1,8(sp)
    8000370a:	6902                	ld	s2,0(sp)
    8000370c:	6105                	addi	sp,sp,32
    8000370e:	8082                	ret
    return -1;
    80003710:	557d                	li	a0,-1
    80003712:	bfcd                	j	80003704 <fetchaddr+0x4a>
    80003714:	557d                	li	a0,-1
    80003716:	b7fd                	j	80003704 <fetchaddr+0x4a>

0000000080003718 <fetchstr>:
{
    80003718:	7179                	addi	sp,sp,-48
    8000371a:	f406                	sd	ra,40(sp)
    8000371c:	f022                	sd	s0,32(sp)
    8000371e:	ec26                	sd	s1,24(sp)
    80003720:	e84a                	sd	s2,16(sp)
    80003722:	e44e                	sd	s3,8(sp)
    80003724:	1800                	addi	s0,sp,48
    80003726:	892a                	mv	s2,a0
    80003728:	84ae                	mv	s1,a1
    8000372a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000372c:	ffffe097          	auipc	ra,0xffffe
    80003730:	2cc080e7          	jalr	716(ra) # 800019f8 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80003734:	6785                	lui	a5,0x1
    80003736:	97aa                	add	a5,a5,a0
    80003738:	86ce                	mv	a3,s3
    8000373a:	864a                	mv	a2,s2
    8000373c:	85a6                	mv	a1,s1
    8000373e:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80003742:	ffffe097          	auipc	ra,0xffffe
    80003746:	024080e7          	jalr	36(ra) # 80001766 <copyinstr>
  if(err < 0)
    8000374a:	00054763          	bltz	a0,80003758 <fetchstr+0x40>
  return strlen(buf);
    8000374e:	8526                	mv	a0,s1
    80003750:	ffffd097          	auipc	ra,0xffffd
    80003754:	700080e7          	jalr	1792(ra) # 80000e50 <strlen>
}
    80003758:	70a2                	ld	ra,40(sp)
    8000375a:	7402                	ld	s0,32(sp)
    8000375c:	64e2                	ld	s1,24(sp)
    8000375e:	6942                	ld	s2,16(sp)
    80003760:	69a2                	ld	s3,8(sp)
    80003762:	6145                	addi	sp,sp,48
    80003764:	8082                	ret

0000000080003766 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80003766:	1101                	addi	sp,sp,-32
    80003768:	ec06                	sd	ra,24(sp)
    8000376a:	e822                	sd	s0,16(sp)
    8000376c:	e426                	sd	s1,8(sp)
    8000376e:	1000                	addi	s0,sp,32
    80003770:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003772:	00000097          	auipc	ra,0x0
    80003776:	ee0080e7          	jalr	-288(ra) # 80003652 <argraw>
    8000377a:	c088                	sw	a0,0(s1)
  return 0;
}
    8000377c:	4501                	li	a0,0
    8000377e:	60e2                	ld	ra,24(sp)
    80003780:	6442                	ld	s0,16(sp)
    80003782:	64a2                	ld	s1,8(sp)
    80003784:	6105                	addi	sp,sp,32
    80003786:	8082                	ret

0000000080003788 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80003788:	1101                	addi	sp,sp,-32
    8000378a:	ec06                	sd	ra,24(sp)
    8000378c:	e822                	sd	s0,16(sp)
    8000378e:	e426                	sd	s1,8(sp)
    80003790:	1000                	addi	s0,sp,32
    80003792:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003794:	00000097          	auipc	ra,0x0
    80003798:	ebe080e7          	jalr	-322(ra) # 80003652 <argraw>
    8000379c:	e088                	sd	a0,0(s1)
  return 0;
}
    8000379e:	4501                	li	a0,0
    800037a0:	60e2                	ld	ra,24(sp)
    800037a2:	6442                	ld	s0,16(sp)
    800037a4:	64a2                	ld	s1,8(sp)
    800037a6:	6105                	addi	sp,sp,32
    800037a8:	8082                	ret

00000000800037aa <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800037aa:	1101                	addi	sp,sp,-32
    800037ac:	ec06                	sd	ra,24(sp)
    800037ae:	e822                	sd	s0,16(sp)
    800037b0:	e426                	sd	s1,8(sp)
    800037b2:	e04a                	sd	s2,0(sp)
    800037b4:	1000                	addi	s0,sp,32
    800037b6:	84ae                	mv	s1,a1
    800037b8:	8932                	mv	s2,a2
  *ip = argraw(n);
    800037ba:	00000097          	auipc	ra,0x0
    800037be:	e98080e7          	jalr	-360(ra) # 80003652 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800037c2:	864a                	mv	a2,s2
    800037c4:	85a6                	mv	a1,s1
    800037c6:	00000097          	auipc	ra,0x0
    800037ca:	f52080e7          	jalr	-174(ra) # 80003718 <fetchstr>
}
    800037ce:	60e2                	ld	ra,24(sp)
    800037d0:	6442                	ld	s0,16(sp)
    800037d2:	64a2                	ld	s1,8(sp)
    800037d4:	6902                	ld	s2,0(sp)
    800037d6:	6105                	addi	sp,sp,32
    800037d8:	8082                	ret

00000000800037da <syscall>:
[SYS_kthread_join]   sys_kthread_join,
};

void
syscall(void)
{
    800037da:	1101                	addi	sp,sp,-32
    800037dc:	ec06                	sd	ra,24(sp)
    800037de:	e822                	sd	s0,16(sp)
    800037e0:	e426                	sd	s1,8(sp)
    800037e2:	e04a                	sd	s2,0(sp)
    800037e4:	1000                	addi	s0,sp,32
  int num;
  struct thread *t = mythread();
    800037e6:	ffffe097          	auipc	ra,0xffffe
    800037ea:	298080e7          	jalr	664(ra) # 80001a7e <mythread>
    800037ee:	84aa                	mv	s1,a0

  num = t->trapframe->a7;
    800037f0:	03853903          	ld	s2,56(a0)
    800037f4:	0a893783          	ld	a5,168(s2)
    800037f8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800037fc:	37fd                	addiw	a5,a5,-1
    800037fe:	477d                	li	a4,31
    80003800:	00f76f63          	bltu	a4,a5,8000381e <syscall+0x44>
    80003804:	00369713          	slli	a4,a3,0x3
    80003808:	00006797          	auipc	a5,0x6
    8000380c:	cd078793          	addi	a5,a5,-816 # 800094d8 <syscalls>
    80003810:	97ba                	add	a5,a5,a4
    80003812:	639c                	ld	a5,0(a5)
    80003814:	c789                	beqz	a5,8000381e <syscall+0x44>
    t->trapframe->a0 = syscalls[num]();
    80003816:	9782                	jalr	a5
    80003818:	06a93823          	sd	a0,112(s2)
    8000381c:	a839                	j	8000383a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000381e:	1d048613          	addi	a2,s1,464
    80003822:	4c8c                	lw	a1,24(s1)
    80003824:	00006517          	auipc	a0,0x6
    80003828:	c7c50513          	addi	a0,a0,-900 # 800094a0 <states.0+0x150>
    8000382c:	ffffd097          	auipc	ra,0xffffd
    80003830:	d48080e7          	jalr	-696(ra) # 80000574 <printf>
            t->tid, t->name, num);
    t->trapframe->a0 = -1;
    80003834:	7c9c                	ld	a5,56(s1)
    80003836:	577d                	li	a4,-1
    80003838:	fbb8                	sd	a4,112(a5)
  }
}
    8000383a:	60e2                	ld	ra,24(sp)
    8000383c:	6442                	ld	s0,16(sp)
    8000383e:	64a2                	ld	s1,8(sp)
    80003840:	6902                	ld	s2,0(sp)
    80003842:	6105                	addi	sp,sp,32
    80003844:	8082                	ret

0000000080003846 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003846:	1101                	addi	sp,sp,-32
    80003848:	ec06                	sd	ra,24(sp)
    8000384a:	e822                	sd	s0,16(sp)
    8000384c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000384e:	fec40593          	addi	a1,s0,-20
    80003852:	4501                	li	a0,0
    80003854:	00000097          	auipc	ra,0x0
    80003858:	f12080e7          	jalr	-238(ra) # 80003766 <argint>
    return -1;
    8000385c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000385e:	00054963          	bltz	a0,80003870 <sys_exit+0x2a>
  exit(n);
    80003862:	fec42503          	lw	a0,-20(s0)
    80003866:	fffff097          	auipc	ra,0xfffff
    8000386a:	e58080e7          	jalr	-424(ra) # 800026be <exit>
  return 0;  // not reached
    8000386e:	4781                	li	a5,0
}
    80003870:	853e                	mv	a0,a5
    80003872:	60e2                	ld	ra,24(sp)
    80003874:	6442                	ld	s0,16(sp)
    80003876:	6105                	addi	sp,sp,32
    80003878:	8082                	ret

000000008000387a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000387a:	1141                	addi	sp,sp,-16
    8000387c:	e406                	sd	ra,8(sp)
    8000387e:	e022                	sd	s0,0(sp)
    80003880:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003882:	ffffe097          	auipc	ra,0xffffe
    80003886:	176080e7          	jalr	374(ra) # 800019f8 <myproc>
}
    8000388a:	5148                	lw	a0,36(a0)
    8000388c:	60a2                	ld	ra,8(sp)
    8000388e:	6402                	ld	s0,0(sp)
    80003890:	0141                	addi	sp,sp,16
    80003892:	8082                	ret

0000000080003894 <sys_fork>:

uint64
sys_fork(void)
{
    80003894:	1141                	addi	sp,sp,-16
    80003896:	e406                	sd	ra,8(sp)
    80003898:	e022                	sd	s0,0(sp)
    8000389a:	0800                	addi	s0,sp,16
  return fork();
    8000389c:	ffffe097          	auipc	ra,0xffffe
    800038a0:	70c080e7          	jalr	1804(ra) # 80001fa8 <fork>
}
    800038a4:	60a2                	ld	ra,8(sp)
    800038a6:	6402                	ld	s0,0(sp)
    800038a8:	0141                	addi	sp,sp,16
    800038aa:	8082                	ret

00000000800038ac <sys_wait>:

uint64
sys_wait(void)
{
    800038ac:	1101                	addi	sp,sp,-32
    800038ae:	ec06                	sd	ra,24(sp)
    800038b0:	e822                	sd	s0,16(sp)
    800038b2:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800038b4:	fe840593          	addi	a1,s0,-24
    800038b8:	4501                	li	a0,0
    800038ba:	00000097          	auipc	ra,0x0
    800038be:	ece080e7          	jalr	-306(ra) # 80003788 <argaddr>
    800038c2:	87aa                	mv	a5,a0
    return -1;
    800038c4:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800038c6:	0007c863          	bltz	a5,800038d6 <sys_wait+0x2a>
  return wait(p);
    800038ca:	fe843503          	ld	a0,-24(s0)
    800038ce:	fffff097          	auipc	ra,0xfffff
    800038d2:	b0c080e7          	jalr	-1268(ra) # 800023da <wait>
}
    800038d6:	60e2                	ld	ra,24(sp)
    800038d8:	6442                	ld	s0,16(sp)
    800038da:	6105                	addi	sp,sp,32
    800038dc:	8082                	ret

00000000800038de <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800038de:	7179                	addi	sp,sp,-48
    800038e0:	f406                	sd	ra,40(sp)
    800038e2:	f022                	sd	s0,32(sp)
    800038e4:	ec26                	sd	s1,24(sp)
    800038e6:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800038e8:	fdc40593          	addi	a1,s0,-36
    800038ec:	4501                	li	a0,0
    800038ee:	00000097          	auipc	ra,0x0
    800038f2:	e78080e7          	jalr	-392(ra) # 80003766 <argint>
    return -1;
    800038f6:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    800038f8:	02054263          	bltz	a0,8000391c <sys_sbrk+0x3e>
  addr = myproc()->sz;
    800038fc:	ffffe097          	auipc	ra,0xffffe
    80003900:	0fc080e7          	jalr	252(ra) # 800019f8 <myproc>
    80003904:	6785                	lui	a5,0x1
    80003906:	953e                	add	a0,a0,a5
    80003908:	f3852483          	lw	s1,-200(a0)
  if(growproc(n) < 0)
    8000390c:	fdc42503          	lw	a0,-36(s0)
    80003910:	ffffe097          	auipc	ra,0xffffe
    80003914:	5ee080e7          	jalr	1518(ra) # 80001efe <growproc>
    80003918:	00054863          	bltz	a0,80003928 <sys_sbrk+0x4a>
    return -1;
  return addr;
}
    8000391c:	8526                	mv	a0,s1
    8000391e:	70a2                	ld	ra,40(sp)
    80003920:	7402                	ld	s0,32(sp)
    80003922:	64e2                	ld	s1,24(sp)
    80003924:	6145                	addi	sp,sp,48
    80003926:	8082                	ret
    return -1;
    80003928:	54fd                	li	s1,-1
    8000392a:	bfcd                	j	8000391c <sys_sbrk+0x3e>

000000008000392c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000392c:	7139                	addi	sp,sp,-64
    8000392e:	fc06                	sd	ra,56(sp)
    80003930:	f822                	sd	s0,48(sp)
    80003932:	f426                	sd	s1,40(sp)
    80003934:	f04a                	sd	s2,32(sp)
    80003936:	ec4e                	sd	s3,24(sp)
    80003938:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000393a:	fcc40593          	addi	a1,s0,-52
    8000393e:	4501                	li	a0,0
    80003940:	00000097          	auipc	ra,0x0
    80003944:	e26080e7          	jalr	-474(ra) # 80003766 <argint>
    return -1;
    80003948:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000394a:	06054563          	bltz	a0,800039b4 <sys_sleep+0x88>
  acquire(&tickslock);
    8000394e:	00055517          	auipc	a0,0x55
    80003952:	c0a50513          	addi	a0,a0,-1014 # 80058558 <tickslock>
    80003956:	ffffd097          	auipc	ra,0xffffd
    8000395a:	274080e7          	jalr	628(ra) # 80000bca <acquire>
  ticks0 = ticks;
    8000395e:	00006917          	auipc	s2,0x6
    80003962:	6d292903          	lw	s2,1746(s2) # 8000a030 <ticks>
  while(ticks - ticks0 < n){
    80003966:	fcc42783          	lw	a5,-52(s0)
    8000396a:	cf85                	beqz	a5,800039a2 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000396c:	00055997          	auipc	s3,0x55
    80003970:	bec98993          	addi	s3,s3,-1044 # 80058558 <tickslock>
    80003974:	00006497          	auipc	s1,0x6
    80003978:	6bc48493          	addi	s1,s1,1724 # 8000a030 <ticks>
    if(myproc()->killed){
    8000397c:	ffffe097          	auipc	ra,0xffffe
    80003980:	07c080e7          	jalr	124(ra) # 800019f8 <myproc>
    80003984:	4d5c                	lw	a5,28(a0)
    80003986:	ef9d                	bnez	a5,800039c4 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80003988:	85ce                	mv	a1,s3
    8000398a:	8526                	mv	a0,s1
    8000398c:	fffff097          	auipc	ra,0xfffff
    80003990:	9e8080e7          	jalr	-1560(ra) # 80002374 <sleep>
  while(ticks - ticks0 < n){
    80003994:	409c                	lw	a5,0(s1)
    80003996:	412787bb          	subw	a5,a5,s2
    8000399a:	fcc42703          	lw	a4,-52(s0)
    8000399e:	fce7efe3          	bltu	a5,a4,8000397c <sys_sleep+0x50>
  }
  release(&tickslock);
    800039a2:	00055517          	auipc	a0,0x55
    800039a6:	bb650513          	addi	a0,a0,-1098 # 80058558 <tickslock>
    800039aa:	ffffd097          	auipc	ra,0xffffd
    800039ae:	2da080e7          	jalr	730(ra) # 80000c84 <release>
  return 0;
    800039b2:	4781                	li	a5,0
}
    800039b4:	853e                	mv	a0,a5
    800039b6:	70e2                	ld	ra,56(sp)
    800039b8:	7442                	ld	s0,48(sp)
    800039ba:	74a2                	ld	s1,40(sp)
    800039bc:	7902                	ld	s2,32(sp)
    800039be:	69e2                	ld	s3,24(sp)
    800039c0:	6121                	addi	sp,sp,64
    800039c2:	8082                	ret
      release(&tickslock);
    800039c4:	00055517          	auipc	a0,0x55
    800039c8:	b9450513          	addi	a0,a0,-1132 # 80058558 <tickslock>
    800039cc:	ffffd097          	auipc	ra,0xffffd
    800039d0:	2b8080e7          	jalr	696(ra) # 80000c84 <release>
      return -1;
    800039d4:	57fd                	li	a5,-1
    800039d6:	bff9                	j	800039b4 <sys_sleep+0x88>

00000000800039d8 <sys_kill>:

uint64
sys_kill(void)
{
    800039d8:	1101                	addi	sp,sp,-32
    800039da:	ec06                	sd	ra,24(sp)
    800039dc:	e822                	sd	s0,16(sp)
    800039de:	1000                	addi	s0,sp,32
  int pid;
  int signum;

  if(argint(0, &pid) < 0 || argint(1, &signum) < 0)
    800039e0:	fec40593          	addi	a1,s0,-20
    800039e4:	4501                	li	a0,0
    800039e6:	00000097          	auipc	ra,0x0
    800039ea:	d80080e7          	jalr	-640(ra) # 80003766 <argint>
    return -1;
    800039ee:	57fd                	li	a5,-1
  if(argint(0, &pid) < 0 || argint(1, &signum) < 0)
    800039f0:	02054563          	bltz	a0,80003a1a <sys_kill+0x42>
    800039f4:	fe840593          	addi	a1,s0,-24
    800039f8:	4505                	li	a0,1
    800039fa:	00000097          	auipc	ra,0x0
    800039fe:	d6c080e7          	jalr	-660(ra) # 80003766 <argint>
    return -1;
    80003a02:	57fd                	li	a5,-1
  if(argint(0, &pid) < 0 || argint(1, &signum) < 0)
    80003a04:	00054b63          	bltz	a0,80003a1a <sys_kill+0x42>
  return kill(pid, signum);
    80003a08:	fe842583          	lw	a1,-24(s0)
    80003a0c:	fec42503          	lw	a0,-20(s0)
    80003a10:	fffff097          	auipc	ra,0xfffff
    80003a14:	dcc080e7          	jalr	-564(ra) # 800027dc <kill>
    80003a18:	87aa                	mv	a5,a0
}
    80003a1a:	853e                	mv	a0,a5
    80003a1c:	60e2                	ld	ra,24(sp)
    80003a1e:	6442                	ld	s0,16(sp)
    80003a20:	6105                	addi	sp,sp,32
    80003a22:	8082                	ret

0000000080003a24 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003a24:	1101                	addi	sp,sp,-32
    80003a26:	ec06                	sd	ra,24(sp)
    80003a28:	e822                	sd	s0,16(sp)
    80003a2a:	e426                	sd	s1,8(sp)
    80003a2c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003a2e:	00055517          	auipc	a0,0x55
    80003a32:	b2a50513          	addi	a0,a0,-1238 # 80058558 <tickslock>
    80003a36:	ffffd097          	auipc	ra,0xffffd
    80003a3a:	194080e7          	jalr	404(ra) # 80000bca <acquire>
  xticks = ticks;
    80003a3e:	00006497          	auipc	s1,0x6
    80003a42:	5f24a483          	lw	s1,1522(s1) # 8000a030 <ticks>
  release(&tickslock);
    80003a46:	00055517          	auipc	a0,0x55
    80003a4a:	b1250513          	addi	a0,a0,-1262 # 80058558 <tickslock>
    80003a4e:	ffffd097          	auipc	ra,0xffffd
    80003a52:	236080e7          	jalr	566(ra) # 80000c84 <release>
  return xticks;
}
    80003a56:	02049513          	slli	a0,s1,0x20
    80003a5a:	9101                	srli	a0,a0,0x20
    80003a5c:	60e2                	ld	ra,24(sp)
    80003a5e:	6442                	ld	s0,16(sp)
    80003a60:	64a2                	ld	s1,8(sp)
    80003a62:	6105                	addi	sp,sp,32
    80003a64:	8082                	ret

0000000080003a66 <sys_sigprocmask>:


/* sig proc mask*/
uint64
sys_sigprocmask(void)
{
    80003a66:	1101                	addi	sp,sp,-32
    80003a68:	ec06                	sd	ra,24(sp)
    80003a6a:	e822                	sd	s0,16(sp)
    80003a6c:	1000                	addi	s0,sp,32
  int mask;

  if(argint(0, &mask) < 0)
    80003a6e:	fec40593          	addi	a1,s0,-20
    80003a72:	4501                	li	a0,0
    80003a74:	00000097          	auipc	ra,0x0
    80003a78:	cf2080e7          	jalr	-782(ra) # 80003766 <argint>
    80003a7c:	87aa                	mv	a5,a0
    return -1;
    80003a7e:	557d                	li	a0,-1
  if(argint(0, &mask) < 0)
    80003a80:	0007ca63          	bltz	a5,80003a94 <sys_sigprocmask+0x2e>
  
  return sigprocmask(mask);
    80003a84:	fec42503          	lw	a0,-20(s0)
    80003a88:	fffff097          	auipc	ra,0xfffff
    80003a8c:	f8e080e7          	jalr	-114(ra) # 80002a16 <sigprocmask>
    80003a90:	1502                	slli	a0,a0,0x20
    80003a92:	9101                	srli	a0,a0,0x20
}
    80003a94:	60e2                	ld	ra,24(sp)
    80003a96:	6442                	ld	s0,16(sp)
    80003a98:	6105                	addi	sp,sp,32
    80003a9a:	8082                	ret

0000000080003a9c <sys_sigaction>:
//   return sigaction (signum,act,oldact);
// }

uint64
sys_sigaction(void)
{
    80003a9c:	7179                	addi	sp,sp,-48
    80003a9e:	f406                	sd	ra,40(sp)
    80003aa0:	f022                	sd	s0,32(sp)
    80003aa2:	1800                	addi	s0,sp,48
  int signum;
  uint64 act;
  uint64 oldact;
  if(argint(0, &signum) < 0)
    80003aa4:	fec40593          	addi	a1,s0,-20
    80003aa8:	4501                	li	a0,0
    80003aaa:	00000097          	auipc	ra,0x0
    80003aae:	cbc080e7          	jalr	-836(ra) # 80003766 <argint>
    return -1;
    80003ab2:	57fd                	li	a5,-1
  if(argint(0, &signum) < 0)
    80003ab4:	04054163          	bltz	a0,80003af6 <sys_sigaction+0x5a>
  if(argaddr(1, &act) < 0)
    80003ab8:	fe040593          	addi	a1,s0,-32
    80003abc:	4505                	li	a0,1
    80003abe:	00000097          	auipc	ra,0x0
    80003ac2:	cca080e7          	jalr	-822(ra) # 80003788 <argaddr>
    return -1;
    80003ac6:	57fd                	li	a5,-1
  if(argaddr(1, &act) < 0)
    80003ac8:	02054763          	bltz	a0,80003af6 <sys_sigaction+0x5a>
  if(argaddr(2, &oldact) < 0)
    80003acc:	fd840593          	addi	a1,s0,-40
    80003ad0:	4509                	li	a0,2
    80003ad2:	00000097          	auipc	ra,0x0
    80003ad6:	cb6080e7          	jalr	-842(ra) # 80003788 <argaddr>
    return -1;
    80003ada:	57fd                	li	a5,-1
  if(argaddr(2, &oldact) < 0)
    80003adc:	00054d63          	bltz	a0,80003af6 <sys_sigaction+0x5a>

  return sigaction (signum,(struct sigaction*)act,(struct sigaction*)oldact);
    80003ae0:	fd843603          	ld	a2,-40(s0)
    80003ae4:	fe043583          	ld	a1,-32(s0)
    80003ae8:	fec42503          	lw	a0,-20(s0)
    80003aec:	fffff097          	auipc	ra,0xfffff
    80003af0:	f54080e7          	jalr	-172(ra) # 80002a40 <sigaction>
    80003af4:	87aa                	mv	a5,a0
}
    80003af6:	853e                	mv	a0,a5
    80003af8:	70a2                	ld	ra,40(sp)
    80003afa:	7402                	ld	s0,32(sp)
    80003afc:	6145                	addi	sp,sp,48
    80003afe:	8082                	ret

0000000080003b00 <sys_sigret>:

uint64
sys_sigret(void)
{
    80003b00:	1141                	addi	sp,sp,-16
    80003b02:	e406                	sd	ra,8(sp)
    80003b04:	e022                	sd	s0,0(sp)
    80003b06:	0800                	addi	s0,sp,16
  sigret();
    80003b08:	fffff097          	auipc	ra,0xfffff
    80003b0c:	034080e7          	jalr	52(ra) # 80002b3c <sigret>
  return 0;
}
    80003b10:	4501                	li	a0,0
    80003b12:	60a2                	ld	ra,8(sp)
    80003b14:	6402                	ld	s0,0(sp)
    80003b16:	0141                	addi	sp,sp,16
    80003b18:	8082                	ret

0000000080003b1a <sys_bsem_alloc>:

uint64
sys_bsem_alloc(void)
{
    80003b1a:	1141                	addi	sp,sp,-16
    80003b1c:	e406                	sd	ra,8(sp)
    80003b1e:	e022                	sd	s0,0(sp)
    80003b20:	0800                	addi	s0,sp,16
  return bsem_alloc();
    80003b22:	fffff097          	auipc	ra,0xfffff
    80003b26:	2be080e7          	jalr	702(ra) # 80002de0 <bsem_alloc>
}
    80003b2a:	60a2                	ld	ra,8(sp)
    80003b2c:	6402                	ld	s0,0(sp)
    80003b2e:	0141                	addi	sp,sp,16
    80003b30:	8082                	ret

0000000080003b32 <sys_bsem_free>:

void
sys_bsem_free(void)
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
    80003b44:	c26080e7          	jalr	-986(ra) # 80003766 <argint>
    80003b48:	00055663          	bgez	a0,80003b54 <sys_bsem_free+0x22>
    bsem_free(i);
}
    80003b4c:	60e2                	ld	ra,24(sp)
    80003b4e:	6442                	ld	s0,16(sp)
    80003b50:	6105                	addi	sp,sp,32
    80003b52:	8082                	ret
    bsem_free(i);
    80003b54:	fec42503          	lw	a0,-20(s0)
    80003b58:	fffff097          	auipc	ra,0xfffff
    80003b5c:	302080e7          	jalr	770(ra) # 80002e5a <bsem_free>
}
    80003b60:	b7f5                	j	80003b4c <sys_bsem_free+0x1a>

0000000080003b62 <sys_bsem_down>:

void
sys_bsem_down(void)
{
    80003b62:	1101                	addi	sp,sp,-32
    80003b64:	ec06                	sd	ra,24(sp)
    80003b66:	e822                	sd	s0,16(sp)
    80003b68:	1000                	addi	s0,sp,32
  int i;
  if(argint(0, &i) >= 0)
    80003b6a:	fec40593          	addi	a1,s0,-20
    80003b6e:	4501                	li	a0,0
    80003b70:	00000097          	auipc	ra,0x0
    80003b74:	bf6080e7          	jalr	-1034(ra) # 80003766 <argint>
    80003b78:	00055663          	bgez	a0,80003b84 <sys_bsem_down+0x22>
    bsem_down(i);
}
    80003b7c:	60e2                	ld	ra,24(sp)
    80003b7e:	6442                	ld	s0,16(sp)
    80003b80:	6105                	addi	sp,sp,32
    80003b82:	8082                	ret
    bsem_down(i);
    80003b84:	fec42503          	lw	a0,-20(s0)
    80003b88:	fffff097          	auipc	ra,0xfffff
    80003b8c:	318080e7          	jalr	792(ra) # 80002ea0 <bsem_down>
}
    80003b90:	b7f5                	j	80003b7c <sys_bsem_down+0x1a>

0000000080003b92 <sys_bsem_up>:

void
sys_bsem_up(void)
{
    80003b92:	1101                	addi	sp,sp,-32
    80003b94:	ec06                	sd	ra,24(sp)
    80003b96:	e822                	sd	s0,16(sp)
    80003b98:	1000                	addi	s0,sp,32
  int i;
  if(argint(0, &i) >= 0)
    80003b9a:	fec40593          	addi	a1,s0,-20
    80003b9e:	4501                	li	a0,0
    80003ba0:	00000097          	auipc	ra,0x0
    80003ba4:	bc6080e7          	jalr	-1082(ra) # 80003766 <argint>
    80003ba8:	00055663          	bgez	a0,80003bb4 <sys_bsem_up+0x22>
    bsem_up(i);
}
    80003bac:	60e2                	ld	ra,24(sp)
    80003bae:	6442                	ld	s0,16(sp)
    80003bb0:	6105                	addi	sp,sp,32
    80003bb2:	8082                	ret
    bsem_up(i);
    80003bb4:	fec42503          	lw	a0,-20(s0)
    80003bb8:	fffff097          	auipc	ra,0xfffff
    80003bbc:	376080e7          	jalr	886(ra) # 80002f2e <bsem_up>
}
    80003bc0:	b7f5                	j	80003bac <sys_bsem_up+0x1a>

0000000080003bc2 <sys_kthread_create>:

uint64
sys_kthread_create(void)
{
    80003bc2:	7179                	addi	sp,sp,-48
    80003bc4:	f406                	sd	ra,40(sp)
    80003bc6:	f022                	sd	s0,32(sp)
    80003bc8:	ec26                	sd	s1,24(sp)
    80003bca:	1800                	addi	s0,sp,48
  uint64 fun;
  uint64 stack;
  if(argaddr(0, &fun)<0)
    80003bcc:	fd840593          	addi	a1,s0,-40
    80003bd0:	4501                	li	a0,0
    80003bd2:	00000097          	auipc	ra,0x0
    80003bd6:	bb6080e7          	jalr	-1098(ra) # 80003788 <argaddr>
    return -1;
    80003bda:	54fd                	li	s1,-1
  if(argaddr(0, &fun)<0)
    80003bdc:	02054d63          	bltz	a0,80003c16 <sys_kthread_create+0x54>
  if(argaddr(1, &stack)<0)
    80003be0:	fd040593          	addi	a1,s0,-48
    80003be4:	4505                	li	a0,1
    80003be6:	00000097          	auipc	ra,0x0
    80003bea:	ba2080e7          	jalr	-1118(ra) # 80003788 <argaddr>
    80003bee:	02054463          	bltz	a0,80003c16 <sys_kthread_create+0x54>
    return -1;
  int x = kthread_create((void (*)())fun,(void *) stack);
    80003bf2:	fd043583          	ld	a1,-48(s0)
    80003bf6:	fd843503          	ld	a0,-40(s0)
    80003bfa:	fffff097          	auipc	ra,0xfffff
    80003bfe:	38a080e7          	jalr	906(ra) # 80002f84 <kthread_create>
    80003c02:	84aa                	mv	s1,a0
  printf("the value of kthread_create is: %d\n", x);
    80003c04:	85aa                	mv	a1,a0
    80003c06:	00006517          	auipc	a0,0x6
    80003c0a:	9da50513          	addi	a0,a0,-1574 # 800095e0 <syscalls+0x108>
    80003c0e:	ffffd097          	auipc	ra,0xffffd
    80003c12:	966080e7          	jalr	-1690(ra) # 80000574 <printf>
  return x;
}
    80003c16:	8526                	mv	a0,s1
    80003c18:	70a2                	ld	ra,40(sp)
    80003c1a:	7402                	ld	s0,32(sp)
    80003c1c:	64e2                	ld	s1,24(sp)
    80003c1e:	6145                	addi	sp,sp,48
    80003c20:	8082                	ret

0000000080003c22 <sys_kthread_id>:

uint64
sys_kthread_id(void)
{
    80003c22:	1141                	addi	sp,sp,-16
    80003c24:	e406                	sd	ra,8(sp)
    80003c26:	e022                	sd	s0,0(sp)
    80003c28:	0800                	addi	s0,sp,16
  return kthread_id();
    80003c2a:	fffff097          	auipc	ra,0xfffff
    80003c2e:	48a080e7          	jalr	1162(ra) # 800030b4 <kthread_id>
}
    80003c32:	60a2                	ld	ra,8(sp)
    80003c34:	6402                	ld	s0,0(sp)
    80003c36:	0141                	addi	sp,sp,16
    80003c38:	8082                	ret

0000000080003c3a <sys_kthread_exit>:

uint64
sys_kthread_exit(void)
{
    80003c3a:	1101                	addi	sp,sp,-32
    80003c3c:	ec06                	sd	ra,24(sp)
    80003c3e:	e822                	sd	s0,16(sp)
    80003c40:	1000                	addi	s0,sp,32
  int status;
  if(argint(0, &status) < 0)
    80003c42:	fec40593          	addi	a1,s0,-20
    80003c46:	4501                	li	a0,0
    80003c48:	00000097          	auipc	ra,0x0
    80003c4c:	b1e080e7          	jalr	-1250(ra) # 80003766 <argint>
    return -1;
    80003c50:	57fd                	li	a5,-1
  if(argint(0, &status) < 0)
    80003c52:	00054963          	bltz	a0,80003c64 <sys_kthread_exit+0x2a>
  kthread_exit(status);
    80003c56:	fec42503          	lw	a0,-20(s0)
    80003c5a:	fffff097          	auipc	ra,0xfffff
    80003c5e:	474080e7          	jalr	1140(ra) # 800030ce <kthread_exit>
  return 0;
    80003c62:	4781                	li	a5,0
}
    80003c64:	853e                	mv	a0,a5
    80003c66:	60e2                	ld	ra,24(sp)
    80003c68:	6442                	ld	s0,16(sp)
    80003c6a:	6105                	addi	sp,sp,32
    80003c6c:	8082                	ret

0000000080003c6e <sys_kthread_join>:

uint64
sys_kthread_join(void)
{
    80003c6e:	1101                	addi	sp,sp,-32
    80003c70:	ec06                	sd	ra,24(sp)
    80003c72:	e822                	sd	s0,16(sp)
    80003c74:	1000                	addi	s0,sp,32
  int tid;
  if(argint(0, &tid) < 0)
    80003c76:	fec40593          	addi	a1,s0,-20
    80003c7a:	4501                	li	a0,0
    80003c7c:	00000097          	auipc	ra,0x0
    80003c80:	aea080e7          	jalr	-1302(ra) # 80003766 <argint>
    80003c84:	87aa                	mv	a5,a0
    return -1;
    80003c86:	557d                	li	a0,-1
  if(argint(0, &tid) < 0)
    80003c88:	0007ce63          	bltz	a5,80003ca4 <sys_kthread_join+0x36>
  int * status = (int *) mythread()->trapframe->a1;
    80003c8c:	ffffe097          	auipc	ra,0xffffe
    80003c90:	df2080e7          	jalr	-526(ra) # 80001a7e <mythread>
    80003c94:	7d1c                	ld	a5,56(a0)
  return kthread_join(tid,status);
    80003c96:	7fac                	ld	a1,120(a5)
    80003c98:	fec42503          	lw	a0,-20(s0)
    80003c9c:	fffff097          	auipc	ra,0xfffff
    80003ca0:	516080e7          	jalr	1302(ra) # 800031b2 <kthread_join>
}
    80003ca4:	60e2                	ld	ra,24(sp)
    80003ca6:	6442                	ld	s0,16(sp)
    80003ca8:	6105                	addi	sp,sp,32
    80003caa:	8082                	ret

0000000080003cac <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003cac:	7179                	addi	sp,sp,-48
    80003cae:	f406                	sd	ra,40(sp)
    80003cb0:	f022                	sd	s0,32(sp)
    80003cb2:	ec26                	sd	s1,24(sp)
    80003cb4:	e84a                	sd	s2,16(sp)
    80003cb6:	e44e                	sd	s3,8(sp)
    80003cb8:	e052                	sd	s4,0(sp)
    80003cba:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003cbc:	00006597          	auipc	a1,0x6
    80003cc0:	94c58593          	addi	a1,a1,-1716 # 80009608 <syscalls+0x130>
    80003cc4:	00055517          	auipc	a0,0x55
    80003cc8:	8ac50513          	addi	a0,a0,-1876 # 80058570 <bcache>
    80003ccc:	ffffd097          	auipc	ra,0xffffd
    80003cd0:	e66080e7          	jalr	-410(ra) # 80000b32 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003cd4:	0005d797          	auipc	a5,0x5d
    80003cd8:	89c78793          	addi	a5,a5,-1892 # 80060570 <bcache+0x8000>
    80003cdc:	0005d717          	auipc	a4,0x5d
    80003ce0:	afc70713          	addi	a4,a4,-1284 # 800607d8 <bcache+0x8268>
    80003ce4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003ce8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003cec:	00055497          	auipc	s1,0x55
    80003cf0:	89c48493          	addi	s1,s1,-1892 # 80058588 <bcache+0x18>
    b->next = bcache.head.next;
    80003cf4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003cf6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003cf8:	00006a17          	auipc	s4,0x6
    80003cfc:	918a0a13          	addi	s4,s4,-1768 # 80009610 <syscalls+0x138>
    b->next = bcache.head.next;
    80003d00:	2b893783          	ld	a5,696(s2)
    80003d04:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003d06:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003d0a:	85d2                	mv	a1,s4
    80003d0c:	01048513          	addi	a0,s1,16
    80003d10:	00001097          	auipc	ra,0x1
    80003d14:	4c6080e7          	jalr	1222(ra) # 800051d6 <initsleeplock>
    bcache.head.next->prev = b;
    80003d18:	2b893783          	ld	a5,696(s2)
    80003d1c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003d1e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003d22:	45848493          	addi	s1,s1,1112
    80003d26:	fd349de3          	bne	s1,s3,80003d00 <binit+0x54>
  }
}
    80003d2a:	70a2                	ld	ra,40(sp)
    80003d2c:	7402                	ld	s0,32(sp)
    80003d2e:	64e2                	ld	s1,24(sp)
    80003d30:	6942                	ld	s2,16(sp)
    80003d32:	69a2                	ld	s3,8(sp)
    80003d34:	6a02                	ld	s4,0(sp)
    80003d36:	6145                	addi	sp,sp,48
    80003d38:	8082                	ret

0000000080003d3a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003d3a:	7179                	addi	sp,sp,-48
    80003d3c:	f406                	sd	ra,40(sp)
    80003d3e:	f022                	sd	s0,32(sp)
    80003d40:	ec26                	sd	s1,24(sp)
    80003d42:	e84a                	sd	s2,16(sp)
    80003d44:	e44e                	sd	s3,8(sp)
    80003d46:	1800                	addi	s0,sp,48
    80003d48:	892a                	mv	s2,a0
    80003d4a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003d4c:	00055517          	auipc	a0,0x55
    80003d50:	82450513          	addi	a0,a0,-2012 # 80058570 <bcache>
    80003d54:	ffffd097          	auipc	ra,0xffffd
    80003d58:	e76080e7          	jalr	-394(ra) # 80000bca <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003d5c:	0005d497          	auipc	s1,0x5d
    80003d60:	acc4b483          	ld	s1,-1332(s1) # 80060828 <bcache+0x82b8>
    80003d64:	0005d797          	auipc	a5,0x5d
    80003d68:	a7478793          	addi	a5,a5,-1420 # 800607d8 <bcache+0x8268>
    80003d6c:	02f48f63          	beq	s1,a5,80003daa <bread+0x70>
    80003d70:	873e                	mv	a4,a5
    80003d72:	a021                	j	80003d7a <bread+0x40>
    80003d74:	68a4                	ld	s1,80(s1)
    80003d76:	02e48a63          	beq	s1,a4,80003daa <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003d7a:	449c                	lw	a5,8(s1)
    80003d7c:	ff279ce3          	bne	a5,s2,80003d74 <bread+0x3a>
    80003d80:	44dc                	lw	a5,12(s1)
    80003d82:	ff3799e3          	bne	a5,s3,80003d74 <bread+0x3a>
      b->refcnt++;
    80003d86:	40bc                	lw	a5,64(s1)
    80003d88:	2785                	addiw	a5,a5,1
    80003d8a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003d8c:	00054517          	auipc	a0,0x54
    80003d90:	7e450513          	addi	a0,a0,2020 # 80058570 <bcache>
    80003d94:	ffffd097          	auipc	ra,0xffffd
    80003d98:	ef0080e7          	jalr	-272(ra) # 80000c84 <release>
      acquiresleep(&b->lock);
    80003d9c:	01048513          	addi	a0,s1,16
    80003da0:	00001097          	auipc	ra,0x1
    80003da4:	470080e7          	jalr	1136(ra) # 80005210 <acquiresleep>
      return b;
    80003da8:	a8b9                	j	80003e06 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003daa:	0005d497          	auipc	s1,0x5d
    80003dae:	a764b483          	ld	s1,-1418(s1) # 80060820 <bcache+0x82b0>
    80003db2:	0005d797          	auipc	a5,0x5d
    80003db6:	a2678793          	addi	a5,a5,-1498 # 800607d8 <bcache+0x8268>
    80003dba:	00f48863          	beq	s1,a5,80003dca <bread+0x90>
    80003dbe:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003dc0:	40bc                	lw	a5,64(s1)
    80003dc2:	cf81                	beqz	a5,80003dda <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003dc4:	64a4                	ld	s1,72(s1)
    80003dc6:	fee49de3          	bne	s1,a4,80003dc0 <bread+0x86>
  panic("bget: no buffers");
    80003dca:	00006517          	auipc	a0,0x6
    80003dce:	84e50513          	addi	a0,a0,-1970 # 80009618 <syscalls+0x140>
    80003dd2:	ffffc097          	auipc	ra,0xffffc
    80003dd6:	758080e7          	jalr	1880(ra) # 8000052a <panic>
      b->dev = dev;
    80003dda:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003dde:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003de2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003de6:	4785                	li	a5,1
    80003de8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003dea:	00054517          	auipc	a0,0x54
    80003dee:	78650513          	addi	a0,a0,1926 # 80058570 <bcache>
    80003df2:	ffffd097          	auipc	ra,0xffffd
    80003df6:	e92080e7          	jalr	-366(ra) # 80000c84 <release>
      acquiresleep(&b->lock);
    80003dfa:	01048513          	addi	a0,s1,16
    80003dfe:	00001097          	auipc	ra,0x1
    80003e02:	412080e7          	jalr	1042(ra) # 80005210 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);

  if(!b->valid) {
    80003e06:	409c                	lw	a5,0(s1)
    80003e08:	cb89                	beqz	a5,80003e1a <bread+0xe0>
    //printf("debug: finish virtio func\n");

    b->valid = 1;
  }
  return b;
}
    80003e0a:	8526                	mv	a0,s1
    80003e0c:	70a2                	ld	ra,40(sp)
    80003e0e:	7402                	ld	s0,32(sp)
    80003e10:	64e2                	ld	s1,24(sp)
    80003e12:	6942                	ld	s2,16(sp)
    80003e14:	69a2                	ld	s3,8(sp)
    80003e16:	6145                	addi	sp,sp,48
    80003e18:	8082                	ret
    virtio_disk_rw(b, 0);
    80003e1a:	4581                	li	a1,0
    80003e1c:	8526                	mv	a0,s1
    80003e1e:	00003097          	auipc	ra,0x3
    80003e22:	fae080e7          	jalr	-82(ra) # 80006dcc <virtio_disk_rw>
    b->valid = 1;
    80003e26:	4785                	li	a5,1
    80003e28:	c09c                	sw	a5,0(s1)
  return b;
    80003e2a:	b7c5                	j	80003e0a <bread+0xd0>

0000000080003e2c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003e2c:	1101                	addi	sp,sp,-32
    80003e2e:	ec06                	sd	ra,24(sp)
    80003e30:	e822                	sd	s0,16(sp)
    80003e32:	e426                	sd	s1,8(sp)
    80003e34:	1000                	addi	s0,sp,32
    80003e36:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003e38:	0541                	addi	a0,a0,16
    80003e3a:	00001097          	auipc	ra,0x1
    80003e3e:	470080e7          	jalr	1136(ra) # 800052aa <holdingsleep>
    80003e42:	cd01                	beqz	a0,80003e5a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003e44:	4585                	li	a1,1
    80003e46:	8526                	mv	a0,s1
    80003e48:	00003097          	auipc	ra,0x3
    80003e4c:	f84080e7          	jalr	-124(ra) # 80006dcc <virtio_disk_rw>
}
    80003e50:	60e2                	ld	ra,24(sp)
    80003e52:	6442                	ld	s0,16(sp)
    80003e54:	64a2                	ld	s1,8(sp)
    80003e56:	6105                	addi	sp,sp,32
    80003e58:	8082                	ret
    panic("bwrite");
    80003e5a:	00005517          	auipc	a0,0x5
    80003e5e:	7d650513          	addi	a0,a0,2006 # 80009630 <syscalls+0x158>
    80003e62:	ffffc097          	auipc	ra,0xffffc
    80003e66:	6c8080e7          	jalr	1736(ra) # 8000052a <panic>

0000000080003e6a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003e6a:	1101                	addi	sp,sp,-32
    80003e6c:	ec06                	sd	ra,24(sp)
    80003e6e:	e822                	sd	s0,16(sp)
    80003e70:	e426                	sd	s1,8(sp)
    80003e72:	e04a                	sd	s2,0(sp)
    80003e74:	1000                	addi	s0,sp,32
    80003e76:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003e78:	01050913          	addi	s2,a0,16
    80003e7c:	854a                	mv	a0,s2
    80003e7e:	00001097          	auipc	ra,0x1
    80003e82:	42c080e7          	jalr	1068(ra) # 800052aa <holdingsleep>
    80003e86:	c92d                	beqz	a0,80003ef8 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003e88:	854a                	mv	a0,s2
    80003e8a:	00001097          	auipc	ra,0x1
    80003e8e:	3dc080e7          	jalr	988(ra) # 80005266 <releasesleep>

  acquire(&bcache.lock);
    80003e92:	00054517          	auipc	a0,0x54
    80003e96:	6de50513          	addi	a0,a0,1758 # 80058570 <bcache>
    80003e9a:	ffffd097          	auipc	ra,0xffffd
    80003e9e:	d30080e7          	jalr	-720(ra) # 80000bca <acquire>
  b->refcnt--;
    80003ea2:	40bc                	lw	a5,64(s1)
    80003ea4:	37fd                	addiw	a5,a5,-1
    80003ea6:	0007871b          	sext.w	a4,a5
    80003eaa:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003eac:	eb05                	bnez	a4,80003edc <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003eae:	68bc                	ld	a5,80(s1)
    80003eb0:	64b8                	ld	a4,72(s1)
    80003eb2:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003eb4:	64bc                	ld	a5,72(s1)
    80003eb6:	68b8                	ld	a4,80(s1)
    80003eb8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003eba:	0005c797          	auipc	a5,0x5c
    80003ebe:	6b678793          	addi	a5,a5,1718 # 80060570 <bcache+0x8000>
    80003ec2:	2b87b703          	ld	a4,696(a5)
    80003ec6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003ec8:	0005d717          	auipc	a4,0x5d
    80003ecc:	91070713          	addi	a4,a4,-1776 # 800607d8 <bcache+0x8268>
    80003ed0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003ed2:	2b87b703          	ld	a4,696(a5)
    80003ed6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003ed8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003edc:	00054517          	auipc	a0,0x54
    80003ee0:	69450513          	addi	a0,a0,1684 # 80058570 <bcache>
    80003ee4:	ffffd097          	auipc	ra,0xffffd
    80003ee8:	da0080e7          	jalr	-608(ra) # 80000c84 <release>
}
    80003eec:	60e2                	ld	ra,24(sp)
    80003eee:	6442                	ld	s0,16(sp)
    80003ef0:	64a2                	ld	s1,8(sp)
    80003ef2:	6902                	ld	s2,0(sp)
    80003ef4:	6105                	addi	sp,sp,32
    80003ef6:	8082                	ret
    panic("brelse");
    80003ef8:	00005517          	auipc	a0,0x5
    80003efc:	74050513          	addi	a0,a0,1856 # 80009638 <syscalls+0x160>
    80003f00:	ffffc097          	auipc	ra,0xffffc
    80003f04:	62a080e7          	jalr	1578(ra) # 8000052a <panic>

0000000080003f08 <bpin>:

void
bpin(struct buf *b) {
    80003f08:	1101                	addi	sp,sp,-32
    80003f0a:	ec06                	sd	ra,24(sp)
    80003f0c:	e822                	sd	s0,16(sp)
    80003f0e:	e426                	sd	s1,8(sp)
    80003f10:	1000                	addi	s0,sp,32
    80003f12:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003f14:	00054517          	auipc	a0,0x54
    80003f18:	65c50513          	addi	a0,a0,1628 # 80058570 <bcache>
    80003f1c:	ffffd097          	auipc	ra,0xffffd
    80003f20:	cae080e7          	jalr	-850(ra) # 80000bca <acquire>
  b->refcnt++;
    80003f24:	40bc                	lw	a5,64(s1)
    80003f26:	2785                	addiw	a5,a5,1
    80003f28:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003f2a:	00054517          	auipc	a0,0x54
    80003f2e:	64650513          	addi	a0,a0,1606 # 80058570 <bcache>
    80003f32:	ffffd097          	auipc	ra,0xffffd
    80003f36:	d52080e7          	jalr	-686(ra) # 80000c84 <release>
}
    80003f3a:	60e2                	ld	ra,24(sp)
    80003f3c:	6442                	ld	s0,16(sp)
    80003f3e:	64a2                	ld	s1,8(sp)
    80003f40:	6105                	addi	sp,sp,32
    80003f42:	8082                	ret

0000000080003f44 <bunpin>:

void
bunpin(struct buf *b) {
    80003f44:	1101                	addi	sp,sp,-32
    80003f46:	ec06                	sd	ra,24(sp)
    80003f48:	e822                	sd	s0,16(sp)
    80003f4a:	e426                	sd	s1,8(sp)
    80003f4c:	1000                	addi	s0,sp,32
    80003f4e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003f50:	00054517          	auipc	a0,0x54
    80003f54:	62050513          	addi	a0,a0,1568 # 80058570 <bcache>
    80003f58:	ffffd097          	auipc	ra,0xffffd
    80003f5c:	c72080e7          	jalr	-910(ra) # 80000bca <acquire>
  b->refcnt--;
    80003f60:	40bc                	lw	a5,64(s1)
    80003f62:	37fd                	addiw	a5,a5,-1
    80003f64:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003f66:	00054517          	auipc	a0,0x54
    80003f6a:	60a50513          	addi	a0,a0,1546 # 80058570 <bcache>
    80003f6e:	ffffd097          	auipc	ra,0xffffd
    80003f72:	d16080e7          	jalr	-746(ra) # 80000c84 <release>
}
    80003f76:	60e2                	ld	ra,24(sp)
    80003f78:	6442                	ld	s0,16(sp)
    80003f7a:	64a2                	ld	s1,8(sp)
    80003f7c:	6105                	addi	sp,sp,32
    80003f7e:	8082                	ret

0000000080003f80 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003f80:	1101                	addi	sp,sp,-32
    80003f82:	ec06                	sd	ra,24(sp)
    80003f84:	e822                	sd	s0,16(sp)
    80003f86:	e426                	sd	s1,8(sp)
    80003f88:	e04a                	sd	s2,0(sp)
    80003f8a:	1000                	addi	s0,sp,32
    80003f8c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003f8e:	00d5d59b          	srliw	a1,a1,0xd
    80003f92:	0005d797          	auipc	a5,0x5d
    80003f96:	cba7a783          	lw	a5,-838(a5) # 80060c4c <sb+0x1c>
    80003f9a:	9dbd                	addw	a1,a1,a5
    80003f9c:	00000097          	auipc	ra,0x0
    80003fa0:	d9e080e7          	jalr	-610(ra) # 80003d3a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003fa4:	0074f713          	andi	a4,s1,7
    80003fa8:	4785                	li	a5,1
    80003faa:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003fae:	14ce                	slli	s1,s1,0x33
    80003fb0:	90d9                	srli	s1,s1,0x36
    80003fb2:	00950733          	add	a4,a0,s1
    80003fb6:	05874703          	lbu	a4,88(a4)
    80003fba:	00e7f6b3          	and	a3,a5,a4
    80003fbe:	c69d                	beqz	a3,80003fec <bfree+0x6c>
    80003fc0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003fc2:	94aa                	add	s1,s1,a0
    80003fc4:	fff7c793          	not	a5,a5
    80003fc8:	8ff9                	and	a5,a5,a4
    80003fca:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003fce:	00001097          	auipc	ra,0x1
    80003fd2:	122080e7          	jalr	290(ra) # 800050f0 <log_write>
  brelse(bp);
    80003fd6:	854a                	mv	a0,s2
    80003fd8:	00000097          	auipc	ra,0x0
    80003fdc:	e92080e7          	jalr	-366(ra) # 80003e6a <brelse>
}
    80003fe0:	60e2                	ld	ra,24(sp)
    80003fe2:	6442                	ld	s0,16(sp)
    80003fe4:	64a2                	ld	s1,8(sp)
    80003fe6:	6902                	ld	s2,0(sp)
    80003fe8:	6105                	addi	sp,sp,32
    80003fea:	8082                	ret
    panic("freeing free block");
    80003fec:	00005517          	auipc	a0,0x5
    80003ff0:	65450513          	addi	a0,a0,1620 # 80009640 <syscalls+0x168>
    80003ff4:	ffffc097          	auipc	ra,0xffffc
    80003ff8:	536080e7          	jalr	1334(ra) # 8000052a <panic>

0000000080003ffc <balloc>:
{
    80003ffc:	711d                	addi	sp,sp,-96
    80003ffe:	ec86                	sd	ra,88(sp)
    80004000:	e8a2                	sd	s0,80(sp)
    80004002:	e4a6                	sd	s1,72(sp)
    80004004:	e0ca                	sd	s2,64(sp)
    80004006:	fc4e                	sd	s3,56(sp)
    80004008:	f852                	sd	s4,48(sp)
    8000400a:	f456                	sd	s5,40(sp)
    8000400c:	f05a                	sd	s6,32(sp)
    8000400e:	ec5e                	sd	s7,24(sp)
    80004010:	e862                	sd	s8,16(sp)
    80004012:	e466                	sd	s9,8(sp)
    80004014:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80004016:	0005d797          	auipc	a5,0x5d
    8000401a:	c1e7a783          	lw	a5,-994(a5) # 80060c34 <sb+0x4>
    8000401e:	cbd1                	beqz	a5,800040b2 <balloc+0xb6>
    80004020:	8baa                	mv	s7,a0
    80004022:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80004024:	0005db17          	auipc	s6,0x5d
    80004028:	c0cb0b13          	addi	s6,s6,-1012 # 80060c30 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000402c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000402e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004030:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80004032:	6c89                	lui	s9,0x2
    80004034:	a831                	j	80004050 <balloc+0x54>
    brelse(bp);
    80004036:	854a                	mv	a0,s2
    80004038:	00000097          	auipc	ra,0x0
    8000403c:	e32080e7          	jalr	-462(ra) # 80003e6a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80004040:	015c87bb          	addw	a5,s9,s5
    80004044:	00078a9b          	sext.w	s5,a5
    80004048:	004b2703          	lw	a4,4(s6)
    8000404c:	06eaf363          	bgeu	s5,a4,800040b2 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80004050:	41fad79b          	sraiw	a5,s5,0x1f
    80004054:	0137d79b          	srliw	a5,a5,0x13
    80004058:	015787bb          	addw	a5,a5,s5
    8000405c:	40d7d79b          	sraiw	a5,a5,0xd
    80004060:	01cb2583          	lw	a1,28(s6)
    80004064:	9dbd                	addw	a1,a1,a5
    80004066:	855e                	mv	a0,s7
    80004068:	00000097          	auipc	ra,0x0
    8000406c:	cd2080e7          	jalr	-814(ra) # 80003d3a <bread>
    80004070:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004072:	004b2503          	lw	a0,4(s6)
    80004076:	000a849b          	sext.w	s1,s5
    8000407a:	8662                	mv	a2,s8
    8000407c:	faa4fde3          	bgeu	s1,a0,80004036 <balloc+0x3a>
      m = 1 << (bi % 8);
    80004080:	41f6579b          	sraiw	a5,a2,0x1f
    80004084:	01d7d69b          	srliw	a3,a5,0x1d
    80004088:	00c6873b          	addw	a4,a3,a2
    8000408c:	00777793          	andi	a5,a4,7
    80004090:	9f95                	subw	a5,a5,a3
    80004092:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80004096:	4037571b          	sraiw	a4,a4,0x3
    8000409a:	00e906b3          	add	a3,s2,a4
    8000409e:	0586c683          	lbu	a3,88(a3) # 2000058 <_entry-0x7dffffa8>
    800040a2:	00d7f5b3          	and	a1,a5,a3
    800040a6:	cd91                	beqz	a1,800040c2 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800040a8:	2605                	addiw	a2,a2,1
    800040aa:	2485                	addiw	s1,s1,1
    800040ac:	fd4618e3          	bne	a2,s4,8000407c <balloc+0x80>
    800040b0:	b759                	j	80004036 <balloc+0x3a>
  panic("balloc: out of blocks");
    800040b2:	00005517          	auipc	a0,0x5
    800040b6:	5a650513          	addi	a0,a0,1446 # 80009658 <syscalls+0x180>
    800040ba:	ffffc097          	auipc	ra,0xffffc
    800040be:	470080e7          	jalr	1136(ra) # 8000052a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800040c2:	974a                	add	a4,a4,s2
    800040c4:	8fd5                	or	a5,a5,a3
    800040c6:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800040ca:	854a                	mv	a0,s2
    800040cc:	00001097          	auipc	ra,0x1
    800040d0:	024080e7          	jalr	36(ra) # 800050f0 <log_write>
        brelse(bp);
    800040d4:	854a                	mv	a0,s2
    800040d6:	00000097          	auipc	ra,0x0
    800040da:	d94080e7          	jalr	-620(ra) # 80003e6a <brelse>
  bp = bread(dev, bno);
    800040de:	85a6                	mv	a1,s1
    800040e0:	855e                	mv	a0,s7
    800040e2:	00000097          	auipc	ra,0x0
    800040e6:	c58080e7          	jalr	-936(ra) # 80003d3a <bread>
    800040ea:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800040ec:	40000613          	li	a2,1024
    800040f0:	4581                	li	a1,0
    800040f2:	05850513          	addi	a0,a0,88
    800040f6:	ffffd097          	auipc	ra,0xffffd
    800040fa:	bd6080e7          	jalr	-1066(ra) # 80000ccc <memset>
  log_write(bp);
    800040fe:	854a                	mv	a0,s2
    80004100:	00001097          	auipc	ra,0x1
    80004104:	ff0080e7          	jalr	-16(ra) # 800050f0 <log_write>
  brelse(bp);
    80004108:	854a                	mv	a0,s2
    8000410a:	00000097          	auipc	ra,0x0
    8000410e:	d60080e7          	jalr	-672(ra) # 80003e6a <brelse>
}
    80004112:	8526                	mv	a0,s1
    80004114:	60e6                	ld	ra,88(sp)
    80004116:	6446                	ld	s0,80(sp)
    80004118:	64a6                	ld	s1,72(sp)
    8000411a:	6906                	ld	s2,64(sp)
    8000411c:	79e2                	ld	s3,56(sp)
    8000411e:	7a42                	ld	s4,48(sp)
    80004120:	7aa2                	ld	s5,40(sp)
    80004122:	7b02                	ld	s6,32(sp)
    80004124:	6be2                	ld	s7,24(sp)
    80004126:	6c42                	ld	s8,16(sp)
    80004128:	6ca2                	ld	s9,8(sp)
    8000412a:	6125                	addi	sp,sp,96
    8000412c:	8082                	ret

000000008000412e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000412e:	7179                	addi	sp,sp,-48
    80004130:	f406                	sd	ra,40(sp)
    80004132:	f022                	sd	s0,32(sp)
    80004134:	ec26                	sd	s1,24(sp)
    80004136:	e84a                	sd	s2,16(sp)
    80004138:	e44e                	sd	s3,8(sp)
    8000413a:	e052                	sd	s4,0(sp)
    8000413c:	1800                	addi	s0,sp,48
    8000413e:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80004140:	47ad                	li	a5,11
    80004142:	04b7fe63          	bgeu	a5,a1,8000419e <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80004146:	ff45849b          	addiw	s1,a1,-12
    8000414a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000414e:	0ff00793          	li	a5,255
    80004152:	0ae7e463          	bltu	a5,a4,800041fa <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80004156:	08052583          	lw	a1,128(a0)
    8000415a:	c5b5                	beqz	a1,800041c6 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000415c:	00092503          	lw	a0,0(s2)
    80004160:	00000097          	auipc	ra,0x0
    80004164:	bda080e7          	jalr	-1062(ra) # 80003d3a <bread>
    80004168:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000416a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000416e:	02049713          	slli	a4,s1,0x20
    80004172:	01e75593          	srli	a1,a4,0x1e
    80004176:	00b784b3          	add	s1,a5,a1
    8000417a:	0004a983          	lw	s3,0(s1)
    8000417e:	04098e63          	beqz	s3,800041da <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80004182:	8552                	mv	a0,s4
    80004184:	00000097          	auipc	ra,0x0
    80004188:	ce6080e7          	jalr	-794(ra) # 80003e6a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000418c:	854e                	mv	a0,s3
    8000418e:	70a2                	ld	ra,40(sp)
    80004190:	7402                	ld	s0,32(sp)
    80004192:	64e2                	ld	s1,24(sp)
    80004194:	6942                	ld	s2,16(sp)
    80004196:	69a2                	ld	s3,8(sp)
    80004198:	6a02                	ld	s4,0(sp)
    8000419a:	6145                	addi	sp,sp,48
    8000419c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000419e:	02059793          	slli	a5,a1,0x20
    800041a2:	01e7d593          	srli	a1,a5,0x1e
    800041a6:	00b504b3          	add	s1,a0,a1
    800041aa:	0504a983          	lw	s3,80(s1)
    800041ae:	fc099fe3          	bnez	s3,8000418c <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800041b2:	4108                	lw	a0,0(a0)
    800041b4:	00000097          	auipc	ra,0x0
    800041b8:	e48080e7          	jalr	-440(ra) # 80003ffc <balloc>
    800041bc:	0005099b          	sext.w	s3,a0
    800041c0:	0534a823          	sw	s3,80(s1)
    800041c4:	b7e1                	j	8000418c <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800041c6:	4108                	lw	a0,0(a0)
    800041c8:	00000097          	auipc	ra,0x0
    800041cc:	e34080e7          	jalr	-460(ra) # 80003ffc <balloc>
    800041d0:	0005059b          	sext.w	a1,a0
    800041d4:	08b92023          	sw	a1,128(s2)
    800041d8:	b751                	j	8000415c <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800041da:	00092503          	lw	a0,0(s2)
    800041de:	00000097          	auipc	ra,0x0
    800041e2:	e1e080e7          	jalr	-482(ra) # 80003ffc <balloc>
    800041e6:	0005099b          	sext.w	s3,a0
    800041ea:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800041ee:	8552                	mv	a0,s4
    800041f0:	00001097          	auipc	ra,0x1
    800041f4:	f00080e7          	jalr	-256(ra) # 800050f0 <log_write>
    800041f8:	b769                	j	80004182 <bmap+0x54>
  panic("bmap: out of range");
    800041fa:	00005517          	auipc	a0,0x5
    800041fe:	47650513          	addi	a0,a0,1142 # 80009670 <syscalls+0x198>
    80004202:	ffffc097          	auipc	ra,0xffffc
    80004206:	328080e7          	jalr	808(ra) # 8000052a <panic>

000000008000420a <iget>:
{
    8000420a:	7179                	addi	sp,sp,-48
    8000420c:	f406                	sd	ra,40(sp)
    8000420e:	f022                	sd	s0,32(sp)
    80004210:	ec26                	sd	s1,24(sp)
    80004212:	e84a                	sd	s2,16(sp)
    80004214:	e44e                	sd	s3,8(sp)
    80004216:	e052                	sd	s4,0(sp)
    80004218:	1800                	addi	s0,sp,48
    8000421a:	89aa                	mv	s3,a0
    8000421c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000421e:	0005d517          	auipc	a0,0x5d
    80004222:	a3250513          	addi	a0,a0,-1486 # 80060c50 <itable>
    80004226:	ffffd097          	auipc	ra,0xffffd
    8000422a:	9a4080e7          	jalr	-1628(ra) # 80000bca <acquire>
  empty = 0;
    8000422e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004230:	0005d497          	auipc	s1,0x5d
    80004234:	a3848493          	addi	s1,s1,-1480 # 80060c68 <itable+0x18>
    80004238:	0005e697          	auipc	a3,0x5e
    8000423c:	4c068693          	addi	a3,a3,1216 # 800626f8 <log>
    80004240:	a039                	j	8000424e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004242:	02090b63          	beqz	s2,80004278 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004246:	08848493          	addi	s1,s1,136
    8000424a:	02d48a63          	beq	s1,a3,8000427e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000424e:	449c                	lw	a5,8(s1)
    80004250:	fef059e3          	blez	a5,80004242 <iget+0x38>
    80004254:	4098                	lw	a4,0(s1)
    80004256:	ff3716e3          	bne	a4,s3,80004242 <iget+0x38>
    8000425a:	40d8                	lw	a4,4(s1)
    8000425c:	ff4713e3          	bne	a4,s4,80004242 <iget+0x38>
      ip->ref++;
    80004260:	2785                	addiw	a5,a5,1
    80004262:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80004264:	0005d517          	auipc	a0,0x5d
    80004268:	9ec50513          	addi	a0,a0,-1556 # 80060c50 <itable>
    8000426c:	ffffd097          	auipc	ra,0xffffd
    80004270:	a18080e7          	jalr	-1512(ra) # 80000c84 <release>
      return ip;
    80004274:	8926                	mv	s2,s1
    80004276:	a03d                	j	800042a4 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004278:	f7f9                	bnez	a5,80004246 <iget+0x3c>
    8000427a:	8926                	mv	s2,s1
    8000427c:	b7e9                	j	80004246 <iget+0x3c>
  if(empty == 0)
    8000427e:	02090c63          	beqz	s2,800042b6 <iget+0xac>
  ip->dev = dev;
    80004282:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80004286:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000428a:	4785                	li	a5,1
    8000428c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80004290:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80004294:	0005d517          	auipc	a0,0x5d
    80004298:	9bc50513          	addi	a0,a0,-1604 # 80060c50 <itable>
    8000429c:	ffffd097          	auipc	ra,0xffffd
    800042a0:	9e8080e7          	jalr	-1560(ra) # 80000c84 <release>
}
    800042a4:	854a                	mv	a0,s2
    800042a6:	70a2                	ld	ra,40(sp)
    800042a8:	7402                	ld	s0,32(sp)
    800042aa:	64e2                	ld	s1,24(sp)
    800042ac:	6942                	ld	s2,16(sp)
    800042ae:	69a2                	ld	s3,8(sp)
    800042b0:	6a02                	ld	s4,0(sp)
    800042b2:	6145                	addi	sp,sp,48
    800042b4:	8082                	ret
    panic("iget: no inodes");
    800042b6:	00005517          	auipc	a0,0x5
    800042ba:	3d250513          	addi	a0,a0,978 # 80009688 <syscalls+0x1b0>
    800042be:	ffffc097          	auipc	ra,0xffffc
    800042c2:	26c080e7          	jalr	620(ra) # 8000052a <panic>

00000000800042c6 <fsinit>:
fsinit(int dev) {
    800042c6:	7179                	addi	sp,sp,-48
    800042c8:	f406                	sd	ra,40(sp)
    800042ca:	f022                	sd	s0,32(sp)
    800042cc:	ec26                	sd	s1,24(sp)
    800042ce:	e84a                	sd	s2,16(sp)
    800042d0:	e44e                	sd	s3,8(sp)
    800042d2:	1800                	addi	s0,sp,48
    800042d4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800042d6:	4585                	li	a1,1
    800042d8:	00000097          	auipc	ra,0x0
    800042dc:	a62080e7          	jalr	-1438(ra) # 80003d3a <bread>
    800042e0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800042e2:	0005d997          	auipc	s3,0x5d
    800042e6:	94e98993          	addi	s3,s3,-1714 # 80060c30 <sb>
    800042ea:	02000613          	li	a2,32
    800042ee:	05850593          	addi	a1,a0,88
    800042f2:	854e                	mv	a0,s3
    800042f4:	ffffd097          	auipc	ra,0xffffd
    800042f8:	a34080e7          	jalr	-1484(ra) # 80000d28 <memmove>
  brelse(bp);
    800042fc:	8526                	mv	a0,s1
    800042fe:	00000097          	auipc	ra,0x0
    80004302:	b6c080e7          	jalr	-1172(ra) # 80003e6a <brelse>
  if(sb.magic != FSMAGIC)
    80004306:	0009a703          	lw	a4,0(s3)
    8000430a:	102037b7          	lui	a5,0x10203
    8000430e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80004312:	02f71263          	bne	a4,a5,80004336 <fsinit+0x70>
  initlog(dev, &sb);
    80004316:	0005d597          	auipc	a1,0x5d
    8000431a:	91a58593          	addi	a1,a1,-1766 # 80060c30 <sb>
    8000431e:	854a                	mv	a0,s2
    80004320:	00001097          	auipc	ra,0x1
    80004324:	b52080e7          	jalr	-1198(ra) # 80004e72 <initlog>
}
    80004328:	70a2                	ld	ra,40(sp)
    8000432a:	7402                	ld	s0,32(sp)
    8000432c:	64e2                	ld	s1,24(sp)
    8000432e:	6942                	ld	s2,16(sp)
    80004330:	69a2                	ld	s3,8(sp)
    80004332:	6145                	addi	sp,sp,48
    80004334:	8082                	ret
    panic("invalid file system");
    80004336:	00005517          	auipc	a0,0x5
    8000433a:	36250513          	addi	a0,a0,866 # 80009698 <syscalls+0x1c0>
    8000433e:	ffffc097          	auipc	ra,0xffffc
    80004342:	1ec080e7          	jalr	492(ra) # 8000052a <panic>

0000000080004346 <iinit>:
{
    80004346:	7179                	addi	sp,sp,-48
    80004348:	f406                	sd	ra,40(sp)
    8000434a:	f022                	sd	s0,32(sp)
    8000434c:	ec26                	sd	s1,24(sp)
    8000434e:	e84a                	sd	s2,16(sp)
    80004350:	e44e                	sd	s3,8(sp)
    80004352:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80004354:	00005597          	auipc	a1,0x5
    80004358:	35c58593          	addi	a1,a1,860 # 800096b0 <syscalls+0x1d8>
    8000435c:	0005d517          	auipc	a0,0x5d
    80004360:	8f450513          	addi	a0,a0,-1804 # 80060c50 <itable>
    80004364:	ffffc097          	auipc	ra,0xffffc
    80004368:	7ce080e7          	jalr	1998(ra) # 80000b32 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000436c:	0005d497          	auipc	s1,0x5d
    80004370:	90c48493          	addi	s1,s1,-1780 # 80060c78 <itable+0x28>
    80004374:	0005e997          	auipc	s3,0x5e
    80004378:	39498993          	addi	s3,s3,916 # 80062708 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000437c:	00005917          	auipc	s2,0x5
    80004380:	33c90913          	addi	s2,s2,828 # 800096b8 <syscalls+0x1e0>
    80004384:	85ca                	mv	a1,s2
    80004386:	8526                	mv	a0,s1
    80004388:	00001097          	auipc	ra,0x1
    8000438c:	e4e080e7          	jalr	-434(ra) # 800051d6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80004390:	08848493          	addi	s1,s1,136
    80004394:	ff3498e3          	bne	s1,s3,80004384 <iinit+0x3e>
}
    80004398:	70a2                	ld	ra,40(sp)
    8000439a:	7402                	ld	s0,32(sp)
    8000439c:	64e2                	ld	s1,24(sp)
    8000439e:	6942                	ld	s2,16(sp)
    800043a0:	69a2                	ld	s3,8(sp)
    800043a2:	6145                	addi	sp,sp,48
    800043a4:	8082                	ret

00000000800043a6 <ialloc>:
{
    800043a6:	715d                	addi	sp,sp,-80
    800043a8:	e486                	sd	ra,72(sp)
    800043aa:	e0a2                	sd	s0,64(sp)
    800043ac:	fc26                	sd	s1,56(sp)
    800043ae:	f84a                	sd	s2,48(sp)
    800043b0:	f44e                	sd	s3,40(sp)
    800043b2:	f052                	sd	s4,32(sp)
    800043b4:	ec56                	sd	s5,24(sp)
    800043b6:	e85a                	sd	s6,16(sp)
    800043b8:	e45e                	sd	s7,8(sp)
    800043ba:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800043bc:	0005d717          	auipc	a4,0x5d
    800043c0:	88072703          	lw	a4,-1920(a4) # 80060c3c <sb+0xc>
    800043c4:	4785                	li	a5,1
    800043c6:	04e7fa63          	bgeu	a5,a4,8000441a <ialloc+0x74>
    800043ca:	8aaa                	mv	s5,a0
    800043cc:	8bae                	mv	s7,a1
    800043ce:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800043d0:	0005da17          	auipc	s4,0x5d
    800043d4:	860a0a13          	addi	s4,s4,-1952 # 80060c30 <sb>
    800043d8:	00048b1b          	sext.w	s6,s1
    800043dc:	0044d793          	srli	a5,s1,0x4
    800043e0:	018a2583          	lw	a1,24(s4)
    800043e4:	9dbd                	addw	a1,a1,a5
    800043e6:	8556                	mv	a0,s5
    800043e8:	00000097          	auipc	ra,0x0
    800043ec:	952080e7          	jalr	-1710(ra) # 80003d3a <bread>
    800043f0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800043f2:	05850993          	addi	s3,a0,88
    800043f6:	00f4f793          	andi	a5,s1,15
    800043fa:	079a                	slli	a5,a5,0x6
    800043fc:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800043fe:	00099783          	lh	a5,0(s3)
    80004402:	c785                	beqz	a5,8000442a <ialloc+0x84>
    brelse(bp);
    80004404:	00000097          	auipc	ra,0x0
    80004408:	a66080e7          	jalr	-1434(ra) # 80003e6a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000440c:	0485                	addi	s1,s1,1
    8000440e:	00ca2703          	lw	a4,12(s4)
    80004412:	0004879b          	sext.w	a5,s1
    80004416:	fce7e1e3          	bltu	a5,a4,800043d8 <ialloc+0x32>
  panic("ialloc: no inodes");
    8000441a:	00005517          	auipc	a0,0x5
    8000441e:	2a650513          	addi	a0,a0,678 # 800096c0 <syscalls+0x1e8>
    80004422:	ffffc097          	auipc	ra,0xffffc
    80004426:	108080e7          	jalr	264(ra) # 8000052a <panic>
      memset(dip, 0, sizeof(*dip));
    8000442a:	04000613          	li	a2,64
    8000442e:	4581                	li	a1,0
    80004430:	854e                	mv	a0,s3
    80004432:	ffffd097          	auipc	ra,0xffffd
    80004436:	89a080e7          	jalr	-1894(ra) # 80000ccc <memset>
      dip->type = type;
    8000443a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000443e:	854a                	mv	a0,s2
    80004440:	00001097          	auipc	ra,0x1
    80004444:	cb0080e7          	jalr	-848(ra) # 800050f0 <log_write>
      brelse(bp);
    80004448:	854a                	mv	a0,s2
    8000444a:	00000097          	auipc	ra,0x0
    8000444e:	a20080e7          	jalr	-1504(ra) # 80003e6a <brelse>
      return iget(dev, inum);
    80004452:	85da                	mv	a1,s6
    80004454:	8556                	mv	a0,s5
    80004456:	00000097          	auipc	ra,0x0
    8000445a:	db4080e7          	jalr	-588(ra) # 8000420a <iget>
}
    8000445e:	60a6                	ld	ra,72(sp)
    80004460:	6406                	ld	s0,64(sp)
    80004462:	74e2                	ld	s1,56(sp)
    80004464:	7942                	ld	s2,48(sp)
    80004466:	79a2                	ld	s3,40(sp)
    80004468:	7a02                	ld	s4,32(sp)
    8000446a:	6ae2                	ld	s5,24(sp)
    8000446c:	6b42                	ld	s6,16(sp)
    8000446e:	6ba2                	ld	s7,8(sp)
    80004470:	6161                	addi	sp,sp,80
    80004472:	8082                	ret

0000000080004474 <iupdate>:
{
    80004474:	1101                	addi	sp,sp,-32
    80004476:	ec06                	sd	ra,24(sp)
    80004478:	e822                	sd	s0,16(sp)
    8000447a:	e426                	sd	s1,8(sp)
    8000447c:	e04a                	sd	s2,0(sp)
    8000447e:	1000                	addi	s0,sp,32
    80004480:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004482:	415c                	lw	a5,4(a0)
    80004484:	0047d79b          	srliw	a5,a5,0x4
    80004488:	0005c597          	auipc	a1,0x5c
    8000448c:	7c05a583          	lw	a1,1984(a1) # 80060c48 <sb+0x18>
    80004490:	9dbd                	addw	a1,a1,a5
    80004492:	4108                	lw	a0,0(a0)
    80004494:	00000097          	auipc	ra,0x0
    80004498:	8a6080e7          	jalr	-1882(ra) # 80003d3a <bread>
    8000449c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000449e:	05850793          	addi	a5,a0,88
    800044a2:	40c8                	lw	a0,4(s1)
    800044a4:	893d                	andi	a0,a0,15
    800044a6:	051a                	slli	a0,a0,0x6
    800044a8:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800044aa:	04449703          	lh	a4,68(s1)
    800044ae:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800044b2:	04649703          	lh	a4,70(s1)
    800044b6:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800044ba:	04849703          	lh	a4,72(s1)
    800044be:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800044c2:	04a49703          	lh	a4,74(s1)
    800044c6:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800044ca:	44f8                	lw	a4,76(s1)
    800044cc:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800044ce:	03400613          	li	a2,52
    800044d2:	05048593          	addi	a1,s1,80
    800044d6:	0531                	addi	a0,a0,12
    800044d8:	ffffd097          	auipc	ra,0xffffd
    800044dc:	850080e7          	jalr	-1968(ra) # 80000d28 <memmove>
  log_write(bp);
    800044e0:	854a                	mv	a0,s2
    800044e2:	00001097          	auipc	ra,0x1
    800044e6:	c0e080e7          	jalr	-1010(ra) # 800050f0 <log_write>
  brelse(bp);
    800044ea:	854a                	mv	a0,s2
    800044ec:	00000097          	auipc	ra,0x0
    800044f0:	97e080e7          	jalr	-1666(ra) # 80003e6a <brelse>
}
    800044f4:	60e2                	ld	ra,24(sp)
    800044f6:	6442                	ld	s0,16(sp)
    800044f8:	64a2                	ld	s1,8(sp)
    800044fa:	6902                	ld	s2,0(sp)
    800044fc:	6105                	addi	sp,sp,32
    800044fe:	8082                	ret

0000000080004500 <idup>:
{
    80004500:	1101                	addi	sp,sp,-32
    80004502:	ec06                	sd	ra,24(sp)
    80004504:	e822                	sd	s0,16(sp)
    80004506:	e426                	sd	s1,8(sp)
    80004508:	1000                	addi	s0,sp,32
    8000450a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000450c:	0005c517          	auipc	a0,0x5c
    80004510:	74450513          	addi	a0,a0,1860 # 80060c50 <itable>
    80004514:	ffffc097          	auipc	ra,0xffffc
    80004518:	6b6080e7          	jalr	1718(ra) # 80000bca <acquire>
  ip->ref++;
    8000451c:	449c                	lw	a5,8(s1)
    8000451e:	2785                	addiw	a5,a5,1
    80004520:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004522:	0005c517          	auipc	a0,0x5c
    80004526:	72e50513          	addi	a0,a0,1838 # 80060c50 <itable>
    8000452a:	ffffc097          	auipc	ra,0xffffc
    8000452e:	75a080e7          	jalr	1882(ra) # 80000c84 <release>
}
    80004532:	8526                	mv	a0,s1
    80004534:	60e2                	ld	ra,24(sp)
    80004536:	6442                	ld	s0,16(sp)
    80004538:	64a2                	ld	s1,8(sp)
    8000453a:	6105                	addi	sp,sp,32
    8000453c:	8082                	ret

000000008000453e <ilock>:
{
    8000453e:	1101                	addi	sp,sp,-32
    80004540:	ec06                	sd	ra,24(sp)
    80004542:	e822                	sd	s0,16(sp)
    80004544:	e426                	sd	s1,8(sp)
    80004546:	e04a                	sd	s2,0(sp)
    80004548:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000454a:	c115                	beqz	a0,8000456e <ilock+0x30>
    8000454c:	84aa                	mv	s1,a0
    8000454e:	451c                	lw	a5,8(a0)
    80004550:	00f05f63          	blez	a5,8000456e <ilock+0x30>
  acquiresleep(&ip->lock);
    80004554:	0541                	addi	a0,a0,16
    80004556:	00001097          	auipc	ra,0x1
    8000455a:	cba080e7          	jalr	-838(ra) # 80005210 <acquiresleep>
  if(ip->valid == 0){
    8000455e:	40bc                	lw	a5,64(s1)
    80004560:	cf99                	beqz	a5,8000457e <ilock+0x40>
}
    80004562:	60e2                	ld	ra,24(sp)
    80004564:	6442                	ld	s0,16(sp)
    80004566:	64a2                	ld	s1,8(sp)
    80004568:	6902                	ld	s2,0(sp)
    8000456a:	6105                	addi	sp,sp,32
    8000456c:	8082                	ret
    panic("ilock");
    8000456e:	00005517          	auipc	a0,0x5
    80004572:	16a50513          	addi	a0,a0,362 # 800096d8 <syscalls+0x200>
    80004576:	ffffc097          	auipc	ra,0xffffc
    8000457a:	fb4080e7          	jalr	-76(ra) # 8000052a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000457e:	40dc                	lw	a5,4(s1)
    80004580:	0047d79b          	srliw	a5,a5,0x4
    80004584:	0005c597          	auipc	a1,0x5c
    80004588:	6c45a583          	lw	a1,1732(a1) # 80060c48 <sb+0x18>
    8000458c:	9dbd                	addw	a1,a1,a5
    8000458e:	4088                	lw	a0,0(s1)
    80004590:	fffff097          	auipc	ra,0xfffff
    80004594:	7aa080e7          	jalr	1962(ra) # 80003d3a <bread>
    80004598:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000459a:	05850593          	addi	a1,a0,88
    8000459e:	40dc                	lw	a5,4(s1)
    800045a0:	8bbd                	andi	a5,a5,15
    800045a2:	079a                	slli	a5,a5,0x6
    800045a4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800045a6:	00059783          	lh	a5,0(a1)
    800045aa:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800045ae:	00259783          	lh	a5,2(a1)
    800045b2:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800045b6:	00459783          	lh	a5,4(a1)
    800045ba:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800045be:	00659783          	lh	a5,6(a1)
    800045c2:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800045c6:	459c                	lw	a5,8(a1)
    800045c8:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800045ca:	03400613          	li	a2,52
    800045ce:	05b1                	addi	a1,a1,12
    800045d0:	05048513          	addi	a0,s1,80
    800045d4:	ffffc097          	auipc	ra,0xffffc
    800045d8:	754080e7          	jalr	1876(ra) # 80000d28 <memmove>
    brelse(bp);
    800045dc:	854a                	mv	a0,s2
    800045de:	00000097          	auipc	ra,0x0
    800045e2:	88c080e7          	jalr	-1908(ra) # 80003e6a <brelse>
    ip->valid = 1;
    800045e6:	4785                	li	a5,1
    800045e8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800045ea:	04449783          	lh	a5,68(s1)
    800045ee:	fbb5                	bnez	a5,80004562 <ilock+0x24>
      panic("ilock: no type");
    800045f0:	00005517          	auipc	a0,0x5
    800045f4:	0f050513          	addi	a0,a0,240 # 800096e0 <syscalls+0x208>
    800045f8:	ffffc097          	auipc	ra,0xffffc
    800045fc:	f32080e7          	jalr	-206(ra) # 8000052a <panic>

0000000080004600 <iunlock>:
{
    80004600:	1101                	addi	sp,sp,-32
    80004602:	ec06                	sd	ra,24(sp)
    80004604:	e822                	sd	s0,16(sp)
    80004606:	e426                	sd	s1,8(sp)
    80004608:	e04a                	sd	s2,0(sp)
    8000460a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000460c:	c905                	beqz	a0,8000463c <iunlock+0x3c>
    8000460e:	84aa                	mv	s1,a0
    80004610:	01050913          	addi	s2,a0,16
    80004614:	854a                	mv	a0,s2
    80004616:	00001097          	auipc	ra,0x1
    8000461a:	c94080e7          	jalr	-876(ra) # 800052aa <holdingsleep>
    8000461e:	cd19                	beqz	a0,8000463c <iunlock+0x3c>
    80004620:	449c                	lw	a5,8(s1)
    80004622:	00f05d63          	blez	a5,8000463c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80004626:	854a                	mv	a0,s2
    80004628:	00001097          	auipc	ra,0x1
    8000462c:	c3e080e7          	jalr	-962(ra) # 80005266 <releasesleep>
}
    80004630:	60e2                	ld	ra,24(sp)
    80004632:	6442                	ld	s0,16(sp)
    80004634:	64a2                	ld	s1,8(sp)
    80004636:	6902                	ld	s2,0(sp)
    80004638:	6105                	addi	sp,sp,32
    8000463a:	8082                	ret
    panic("iunlock");
    8000463c:	00005517          	auipc	a0,0x5
    80004640:	0b450513          	addi	a0,a0,180 # 800096f0 <syscalls+0x218>
    80004644:	ffffc097          	auipc	ra,0xffffc
    80004648:	ee6080e7          	jalr	-282(ra) # 8000052a <panic>

000000008000464c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000464c:	7179                	addi	sp,sp,-48
    8000464e:	f406                	sd	ra,40(sp)
    80004650:	f022                	sd	s0,32(sp)
    80004652:	ec26                	sd	s1,24(sp)
    80004654:	e84a                	sd	s2,16(sp)
    80004656:	e44e                	sd	s3,8(sp)
    80004658:	e052                	sd	s4,0(sp)
    8000465a:	1800                	addi	s0,sp,48
    8000465c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000465e:	05050493          	addi	s1,a0,80
    80004662:	08050913          	addi	s2,a0,128
    80004666:	a021                	j	8000466e <itrunc+0x22>
    80004668:	0491                	addi	s1,s1,4
    8000466a:	01248d63          	beq	s1,s2,80004684 <itrunc+0x38>
    if(ip->addrs[i]){
    8000466e:	408c                	lw	a1,0(s1)
    80004670:	dde5                	beqz	a1,80004668 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80004672:	0009a503          	lw	a0,0(s3)
    80004676:	00000097          	auipc	ra,0x0
    8000467a:	90a080e7          	jalr	-1782(ra) # 80003f80 <bfree>
      ip->addrs[i] = 0;
    8000467e:	0004a023          	sw	zero,0(s1)
    80004682:	b7dd                	j	80004668 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80004684:	0809a583          	lw	a1,128(s3)
    80004688:	e185                	bnez	a1,800046a8 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000468a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000468e:	854e                	mv	a0,s3
    80004690:	00000097          	auipc	ra,0x0
    80004694:	de4080e7          	jalr	-540(ra) # 80004474 <iupdate>
}
    80004698:	70a2                	ld	ra,40(sp)
    8000469a:	7402                	ld	s0,32(sp)
    8000469c:	64e2                	ld	s1,24(sp)
    8000469e:	6942                	ld	s2,16(sp)
    800046a0:	69a2                	ld	s3,8(sp)
    800046a2:	6a02                	ld	s4,0(sp)
    800046a4:	6145                	addi	sp,sp,48
    800046a6:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800046a8:	0009a503          	lw	a0,0(s3)
    800046ac:	fffff097          	auipc	ra,0xfffff
    800046b0:	68e080e7          	jalr	1678(ra) # 80003d3a <bread>
    800046b4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800046b6:	05850493          	addi	s1,a0,88
    800046ba:	45850913          	addi	s2,a0,1112
    800046be:	a021                	j	800046c6 <itrunc+0x7a>
    800046c0:	0491                	addi	s1,s1,4
    800046c2:	01248b63          	beq	s1,s2,800046d8 <itrunc+0x8c>
      if(a[j])
    800046c6:	408c                	lw	a1,0(s1)
    800046c8:	dde5                	beqz	a1,800046c0 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    800046ca:	0009a503          	lw	a0,0(s3)
    800046ce:	00000097          	auipc	ra,0x0
    800046d2:	8b2080e7          	jalr	-1870(ra) # 80003f80 <bfree>
    800046d6:	b7ed                	j	800046c0 <itrunc+0x74>
    brelse(bp);
    800046d8:	8552                	mv	a0,s4
    800046da:	fffff097          	auipc	ra,0xfffff
    800046de:	790080e7          	jalr	1936(ra) # 80003e6a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800046e2:	0809a583          	lw	a1,128(s3)
    800046e6:	0009a503          	lw	a0,0(s3)
    800046ea:	00000097          	auipc	ra,0x0
    800046ee:	896080e7          	jalr	-1898(ra) # 80003f80 <bfree>
    ip->addrs[NDIRECT] = 0;
    800046f2:	0809a023          	sw	zero,128(s3)
    800046f6:	bf51                	j	8000468a <itrunc+0x3e>

00000000800046f8 <iput>:
{
    800046f8:	1101                	addi	sp,sp,-32
    800046fa:	ec06                	sd	ra,24(sp)
    800046fc:	e822                	sd	s0,16(sp)
    800046fe:	e426                	sd	s1,8(sp)
    80004700:	e04a                	sd	s2,0(sp)
    80004702:	1000                	addi	s0,sp,32
    80004704:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004706:	0005c517          	auipc	a0,0x5c
    8000470a:	54a50513          	addi	a0,a0,1354 # 80060c50 <itable>
    8000470e:	ffffc097          	auipc	ra,0xffffc
    80004712:	4bc080e7          	jalr	1212(ra) # 80000bca <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004716:	4498                	lw	a4,8(s1)
    80004718:	4785                	li	a5,1
    8000471a:	02f70363          	beq	a4,a5,80004740 <iput+0x48>
  ip->ref--;
    8000471e:	449c                	lw	a5,8(s1)
    80004720:	37fd                	addiw	a5,a5,-1
    80004722:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004724:	0005c517          	auipc	a0,0x5c
    80004728:	52c50513          	addi	a0,a0,1324 # 80060c50 <itable>
    8000472c:	ffffc097          	auipc	ra,0xffffc
    80004730:	558080e7          	jalr	1368(ra) # 80000c84 <release>
}
    80004734:	60e2                	ld	ra,24(sp)
    80004736:	6442                	ld	s0,16(sp)
    80004738:	64a2                	ld	s1,8(sp)
    8000473a:	6902                	ld	s2,0(sp)
    8000473c:	6105                	addi	sp,sp,32
    8000473e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004740:	40bc                	lw	a5,64(s1)
    80004742:	dff1                	beqz	a5,8000471e <iput+0x26>
    80004744:	04a49783          	lh	a5,74(s1)
    80004748:	fbf9                	bnez	a5,8000471e <iput+0x26>
    acquiresleep(&ip->lock);
    8000474a:	01048913          	addi	s2,s1,16
    8000474e:	854a                	mv	a0,s2
    80004750:	00001097          	auipc	ra,0x1
    80004754:	ac0080e7          	jalr	-1344(ra) # 80005210 <acquiresleep>
    release(&itable.lock);
    80004758:	0005c517          	auipc	a0,0x5c
    8000475c:	4f850513          	addi	a0,a0,1272 # 80060c50 <itable>
    80004760:	ffffc097          	auipc	ra,0xffffc
    80004764:	524080e7          	jalr	1316(ra) # 80000c84 <release>
    itrunc(ip);
    80004768:	8526                	mv	a0,s1
    8000476a:	00000097          	auipc	ra,0x0
    8000476e:	ee2080e7          	jalr	-286(ra) # 8000464c <itrunc>
    ip->type = 0;
    80004772:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004776:	8526                	mv	a0,s1
    80004778:	00000097          	auipc	ra,0x0
    8000477c:	cfc080e7          	jalr	-772(ra) # 80004474 <iupdate>
    ip->valid = 0;
    80004780:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004784:	854a                	mv	a0,s2
    80004786:	00001097          	auipc	ra,0x1
    8000478a:	ae0080e7          	jalr	-1312(ra) # 80005266 <releasesleep>
    acquire(&itable.lock);
    8000478e:	0005c517          	auipc	a0,0x5c
    80004792:	4c250513          	addi	a0,a0,1218 # 80060c50 <itable>
    80004796:	ffffc097          	auipc	ra,0xffffc
    8000479a:	434080e7          	jalr	1076(ra) # 80000bca <acquire>
    8000479e:	b741                	j	8000471e <iput+0x26>

00000000800047a0 <iunlockput>:
{
    800047a0:	1101                	addi	sp,sp,-32
    800047a2:	ec06                	sd	ra,24(sp)
    800047a4:	e822                	sd	s0,16(sp)
    800047a6:	e426                	sd	s1,8(sp)
    800047a8:	1000                	addi	s0,sp,32
    800047aa:	84aa                	mv	s1,a0
  iunlock(ip);
    800047ac:	00000097          	auipc	ra,0x0
    800047b0:	e54080e7          	jalr	-428(ra) # 80004600 <iunlock>
  iput(ip);
    800047b4:	8526                	mv	a0,s1
    800047b6:	00000097          	auipc	ra,0x0
    800047ba:	f42080e7          	jalr	-190(ra) # 800046f8 <iput>
}
    800047be:	60e2                	ld	ra,24(sp)
    800047c0:	6442                	ld	s0,16(sp)
    800047c2:	64a2                	ld	s1,8(sp)
    800047c4:	6105                	addi	sp,sp,32
    800047c6:	8082                	ret

00000000800047c8 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800047c8:	1141                	addi	sp,sp,-16
    800047ca:	e422                	sd	s0,8(sp)
    800047cc:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800047ce:	411c                	lw	a5,0(a0)
    800047d0:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800047d2:	415c                	lw	a5,4(a0)
    800047d4:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800047d6:	04451783          	lh	a5,68(a0)
    800047da:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800047de:	04a51783          	lh	a5,74(a0)
    800047e2:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800047e6:	04c56783          	lwu	a5,76(a0)
    800047ea:	e99c                	sd	a5,16(a1)
}
    800047ec:	6422                	ld	s0,8(sp)
    800047ee:	0141                	addi	sp,sp,16
    800047f0:	8082                	ret

00000000800047f2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800047f2:	457c                	lw	a5,76(a0)
    800047f4:	0ed7e963          	bltu	a5,a3,800048e6 <readi+0xf4>
{
    800047f8:	7159                	addi	sp,sp,-112
    800047fa:	f486                	sd	ra,104(sp)
    800047fc:	f0a2                	sd	s0,96(sp)
    800047fe:	eca6                	sd	s1,88(sp)
    80004800:	e8ca                	sd	s2,80(sp)
    80004802:	e4ce                	sd	s3,72(sp)
    80004804:	e0d2                	sd	s4,64(sp)
    80004806:	fc56                	sd	s5,56(sp)
    80004808:	f85a                	sd	s6,48(sp)
    8000480a:	f45e                	sd	s7,40(sp)
    8000480c:	f062                	sd	s8,32(sp)
    8000480e:	ec66                	sd	s9,24(sp)
    80004810:	e86a                	sd	s10,16(sp)
    80004812:	e46e                	sd	s11,8(sp)
    80004814:	1880                	addi	s0,sp,112
    80004816:	8baa                	mv	s7,a0
    80004818:	8c2e                	mv	s8,a1
    8000481a:	8ab2                	mv	s5,a2
    8000481c:	84b6                	mv	s1,a3
    8000481e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004820:	9f35                	addw	a4,a4,a3
    return 0;
    80004822:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80004824:	0ad76063          	bltu	a4,a3,800048c4 <readi+0xd2>
  if(off + n > ip->size)
    80004828:	00e7f463          	bgeu	a5,a4,80004830 <readi+0x3e>
    n = ip->size - off;
    8000482c:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004830:	0a0b0963          	beqz	s6,800048e2 <readi+0xf0>
    80004834:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80004836:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000483a:	5cfd                	li	s9,-1
    8000483c:	a82d                	j	80004876 <readi+0x84>
    8000483e:	020a1d93          	slli	s11,s4,0x20
    80004842:	020ddd93          	srli	s11,s11,0x20
    80004846:	05890793          	addi	a5,s2,88
    8000484a:	86ee                	mv	a3,s11
    8000484c:	963e                	add	a2,a2,a5
    8000484e:	85d6                	mv	a1,s5
    80004850:	8562                	mv	a0,s8
    80004852:	ffffe097          	auipc	ra,0xffffe
    80004856:	054080e7          	jalr	84(ra) # 800028a6 <either_copyout>
    8000485a:	05950d63          	beq	a0,s9,800048b4 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000485e:	854a                	mv	a0,s2
    80004860:	fffff097          	auipc	ra,0xfffff
    80004864:	60a080e7          	jalr	1546(ra) # 80003e6a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004868:	013a09bb          	addw	s3,s4,s3
    8000486c:	009a04bb          	addw	s1,s4,s1
    80004870:	9aee                	add	s5,s5,s11
    80004872:	0569f763          	bgeu	s3,s6,800048c0 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004876:	000ba903          	lw	s2,0(s7)
    8000487a:	00a4d59b          	srliw	a1,s1,0xa
    8000487e:	855e                	mv	a0,s7
    80004880:	00000097          	auipc	ra,0x0
    80004884:	8ae080e7          	jalr	-1874(ra) # 8000412e <bmap>
    80004888:	0005059b          	sext.w	a1,a0
    8000488c:	854a                	mv	a0,s2
    8000488e:	fffff097          	auipc	ra,0xfffff
    80004892:	4ac080e7          	jalr	1196(ra) # 80003d3a <bread>
    80004896:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004898:	3ff4f613          	andi	a2,s1,1023
    8000489c:	40cd07bb          	subw	a5,s10,a2
    800048a0:	413b073b          	subw	a4,s6,s3
    800048a4:	8a3e                	mv	s4,a5
    800048a6:	2781                	sext.w	a5,a5
    800048a8:	0007069b          	sext.w	a3,a4
    800048ac:	f8f6f9e3          	bgeu	a3,a5,8000483e <readi+0x4c>
    800048b0:	8a3a                	mv	s4,a4
    800048b2:	b771                	j	8000483e <readi+0x4c>
      brelse(bp);
    800048b4:	854a                	mv	a0,s2
    800048b6:	fffff097          	auipc	ra,0xfffff
    800048ba:	5b4080e7          	jalr	1460(ra) # 80003e6a <brelse>
      tot = -1;
    800048be:	59fd                	li	s3,-1
  }
  return tot;
    800048c0:	0009851b          	sext.w	a0,s3
}
    800048c4:	70a6                	ld	ra,104(sp)
    800048c6:	7406                	ld	s0,96(sp)
    800048c8:	64e6                	ld	s1,88(sp)
    800048ca:	6946                	ld	s2,80(sp)
    800048cc:	69a6                	ld	s3,72(sp)
    800048ce:	6a06                	ld	s4,64(sp)
    800048d0:	7ae2                	ld	s5,56(sp)
    800048d2:	7b42                	ld	s6,48(sp)
    800048d4:	7ba2                	ld	s7,40(sp)
    800048d6:	7c02                	ld	s8,32(sp)
    800048d8:	6ce2                	ld	s9,24(sp)
    800048da:	6d42                	ld	s10,16(sp)
    800048dc:	6da2                	ld	s11,8(sp)
    800048de:	6165                	addi	sp,sp,112
    800048e0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800048e2:	89da                	mv	s3,s6
    800048e4:	bff1                	j	800048c0 <readi+0xce>
    return 0;
    800048e6:	4501                	li	a0,0
}
    800048e8:	8082                	ret

00000000800048ea <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800048ea:	457c                	lw	a5,76(a0)
    800048ec:	10d7e863          	bltu	a5,a3,800049fc <writei+0x112>
{
    800048f0:	7159                	addi	sp,sp,-112
    800048f2:	f486                	sd	ra,104(sp)
    800048f4:	f0a2                	sd	s0,96(sp)
    800048f6:	eca6                	sd	s1,88(sp)
    800048f8:	e8ca                	sd	s2,80(sp)
    800048fa:	e4ce                	sd	s3,72(sp)
    800048fc:	e0d2                	sd	s4,64(sp)
    800048fe:	fc56                	sd	s5,56(sp)
    80004900:	f85a                	sd	s6,48(sp)
    80004902:	f45e                	sd	s7,40(sp)
    80004904:	f062                	sd	s8,32(sp)
    80004906:	ec66                	sd	s9,24(sp)
    80004908:	e86a                	sd	s10,16(sp)
    8000490a:	e46e                	sd	s11,8(sp)
    8000490c:	1880                	addi	s0,sp,112
    8000490e:	8b2a                	mv	s6,a0
    80004910:	8c2e                	mv	s8,a1
    80004912:	8ab2                	mv	s5,a2
    80004914:	8936                	mv	s2,a3
    80004916:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80004918:	00e687bb          	addw	a5,a3,a4
    8000491c:	0ed7e263          	bltu	a5,a3,80004a00 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004920:	00043737          	lui	a4,0x43
    80004924:	0ef76063          	bltu	a4,a5,80004a04 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004928:	0c0b8863          	beqz	s7,800049f8 <writei+0x10e>
    8000492c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000492e:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004932:	5cfd                	li	s9,-1
    80004934:	a091                	j	80004978 <writei+0x8e>
    80004936:	02099d93          	slli	s11,s3,0x20
    8000493a:	020ddd93          	srli	s11,s11,0x20
    8000493e:	05848793          	addi	a5,s1,88
    80004942:	86ee                	mv	a3,s11
    80004944:	8656                	mv	a2,s5
    80004946:	85e2                	mv	a1,s8
    80004948:	953e                	add	a0,a0,a5
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	fb8080e7          	jalr	-72(ra) # 80002902 <either_copyin>
    80004952:	07950263          	beq	a0,s9,800049b6 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004956:	8526                	mv	a0,s1
    80004958:	00000097          	auipc	ra,0x0
    8000495c:	798080e7          	jalr	1944(ra) # 800050f0 <log_write>
    brelse(bp);
    80004960:	8526                	mv	a0,s1
    80004962:	fffff097          	auipc	ra,0xfffff
    80004966:	508080e7          	jalr	1288(ra) # 80003e6a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000496a:	01498a3b          	addw	s4,s3,s4
    8000496e:	0129893b          	addw	s2,s3,s2
    80004972:	9aee                	add	s5,s5,s11
    80004974:	057a7663          	bgeu	s4,s7,800049c0 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004978:	000b2483          	lw	s1,0(s6)
    8000497c:	00a9559b          	srliw	a1,s2,0xa
    80004980:	855a                	mv	a0,s6
    80004982:	fffff097          	auipc	ra,0xfffff
    80004986:	7ac080e7          	jalr	1964(ra) # 8000412e <bmap>
    8000498a:	0005059b          	sext.w	a1,a0
    8000498e:	8526                	mv	a0,s1
    80004990:	fffff097          	auipc	ra,0xfffff
    80004994:	3aa080e7          	jalr	938(ra) # 80003d3a <bread>
    80004998:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000499a:	3ff97513          	andi	a0,s2,1023
    8000499e:	40ad07bb          	subw	a5,s10,a0
    800049a2:	414b873b          	subw	a4,s7,s4
    800049a6:	89be                	mv	s3,a5
    800049a8:	2781                	sext.w	a5,a5
    800049aa:	0007069b          	sext.w	a3,a4
    800049ae:	f8f6f4e3          	bgeu	a3,a5,80004936 <writei+0x4c>
    800049b2:	89ba                	mv	s3,a4
    800049b4:	b749                	j	80004936 <writei+0x4c>
      brelse(bp);
    800049b6:	8526                	mv	a0,s1
    800049b8:	fffff097          	auipc	ra,0xfffff
    800049bc:	4b2080e7          	jalr	1202(ra) # 80003e6a <brelse>
  }

  if(off > ip->size)
    800049c0:	04cb2783          	lw	a5,76(s6)
    800049c4:	0127f463          	bgeu	a5,s2,800049cc <writei+0xe2>
    ip->size = off;
    800049c8:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800049cc:	855a                	mv	a0,s6
    800049ce:	00000097          	auipc	ra,0x0
    800049d2:	aa6080e7          	jalr	-1370(ra) # 80004474 <iupdate>

  return tot;
    800049d6:	000a051b          	sext.w	a0,s4
}
    800049da:	70a6                	ld	ra,104(sp)
    800049dc:	7406                	ld	s0,96(sp)
    800049de:	64e6                	ld	s1,88(sp)
    800049e0:	6946                	ld	s2,80(sp)
    800049e2:	69a6                	ld	s3,72(sp)
    800049e4:	6a06                	ld	s4,64(sp)
    800049e6:	7ae2                	ld	s5,56(sp)
    800049e8:	7b42                	ld	s6,48(sp)
    800049ea:	7ba2                	ld	s7,40(sp)
    800049ec:	7c02                	ld	s8,32(sp)
    800049ee:	6ce2                	ld	s9,24(sp)
    800049f0:	6d42                	ld	s10,16(sp)
    800049f2:	6da2                	ld	s11,8(sp)
    800049f4:	6165                	addi	sp,sp,112
    800049f6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800049f8:	8a5e                	mv	s4,s7
    800049fa:	bfc9                	j	800049cc <writei+0xe2>
    return -1;
    800049fc:	557d                	li	a0,-1
}
    800049fe:	8082                	ret
    return -1;
    80004a00:	557d                	li	a0,-1
    80004a02:	bfe1                	j	800049da <writei+0xf0>
    return -1;
    80004a04:	557d                	li	a0,-1
    80004a06:	bfd1                	j	800049da <writei+0xf0>

0000000080004a08 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004a08:	1141                	addi	sp,sp,-16
    80004a0a:	e406                	sd	ra,8(sp)
    80004a0c:	e022                	sd	s0,0(sp)
    80004a0e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004a10:	4639                	li	a2,14
    80004a12:	ffffc097          	auipc	ra,0xffffc
    80004a16:	392080e7          	jalr	914(ra) # 80000da4 <strncmp>
}
    80004a1a:	60a2                	ld	ra,8(sp)
    80004a1c:	6402                	ld	s0,0(sp)
    80004a1e:	0141                	addi	sp,sp,16
    80004a20:	8082                	ret

0000000080004a22 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004a22:	7139                	addi	sp,sp,-64
    80004a24:	fc06                	sd	ra,56(sp)
    80004a26:	f822                	sd	s0,48(sp)
    80004a28:	f426                	sd	s1,40(sp)
    80004a2a:	f04a                	sd	s2,32(sp)
    80004a2c:	ec4e                	sd	s3,24(sp)
    80004a2e:	e852                	sd	s4,16(sp)
    80004a30:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004a32:	04451703          	lh	a4,68(a0)
    80004a36:	4785                	li	a5,1
    80004a38:	00f71a63          	bne	a4,a5,80004a4c <dirlookup+0x2a>
    80004a3c:	892a                	mv	s2,a0
    80004a3e:	89ae                	mv	s3,a1
    80004a40:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004a42:	457c                	lw	a5,76(a0)
    80004a44:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004a46:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004a48:	e79d                	bnez	a5,80004a76 <dirlookup+0x54>
    80004a4a:	a8a5                	j	80004ac2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004a4c:	00005517          	auipc	a0,0x5
    80004a50:	cac50513          	addi	a0,a0,-852 # 800096f8 <syscalls+0x220>
    80004a54:	ffffc097          	auipc	ra,0xffffc
    80004a58:	ad6080e7          	jalr	-1322(ra) # 8000052a <panic>
      panic("dirlookup read");
    80004a5c:	00005517          	auipc	a0,0x5
    80004a60:	cb450513          	addi	a0,a0,-844 # 80009710 <syscalls+0x238>
    80004a64:	ffffc097          	auipc	ra,0xffffc
    80004a68:	ac6080e7          	jalr	-1338(ra) # 8000052a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004a6c:	24c1                	addiw	s1,s1,16
    80004a6e:	04c92783          	lw	a5,76(s2)
    80004a72:	04f4f763          	bgeu	s1,a5,80004ac0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a76:	4741                	li	a4,16
    80004a78:	86a6                	mv	a3,s1
    80004a7a:	fc040613          	addi	a2,s0,-64
    80004a7e:	4581                	li	a1,0
    80004a80:	854a                	mv	a0,s2
    80004a82:	00000097          	auipc	ra,0x0
    80004a86:	d70080e7          	jalr	-656(ra) # 800047f2 <readi>
    80004a8a:	47c1                	li	a5,16
    80004a8c:	fcf518e3          	bne	a0,a5,80004a5c <dirlookup+0x3a>
    if(de.inum == 0)
    80004a90:	fc045783          	lhu	a5,-64(s0)
    80004a94:	dfe1                	beqz	a5,80004a6c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004a96:	fc240593          	addi	a1,s0,-62
    80004a9a:	854e                	mv	a0,s3
    80004a9c:	00000097          	auipc	ra,0x0
    80004aa0:	f6c080e7          	jalr	-148(ra) # 80004a08 <namecmp>
    80004aa4:	f561                	bnez	a0,80004a6c <dirlookup+0x4a>
      if(poff)
    80004aa6:	000a0463          	beqz	s4,80004aae <dirlookup+0x8c>
        *poff = off;
    80004aaa:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004aae:	fc045583          	lhu	a1,-64(s0)
    80004ab2:	00092503          	lw	a0,0(s2)
    80004ab6:	fffff097          	auipc	ra,0xfffff
    80004aba:	754080e7          	jalr	1876(ra) # 8000420a <iget>
    80004abe:	a011                	j	80004ac2 <dirlookup+0xa0>
  return 0;
    80004ac0:	4501                	li	a0,0
}
    80004ac2:	70e2                	ld	ra,56(sp)
    80004ac4:	7442                	ld	s0,48(sp)
    80004ac6:	74a2                	ld	s1,40(sp)
    80004ac8:	7902                	ld	s2,32(sp)
    80004aca:	69e2                	ld	s3,24(sp)
    80004acc:	6a42                	ld	s4,16(sp)
    80004ace:	6121                	addi	sp,sp,64
    80004ad0:	8082                	ret

0000000080004ad2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004ad2:	711d                	addi	sp,sp,-96
    80004ad4:	ec86                	sd	ra,88(sp)
    80004ad6:	e8a2                	sd	s0,80(sp)
    80004ad8:	e4a6                	sd	s1,72(sp)
    80004ada:	e0ca                	sd	s2,64(sp)
    80004adc:	fc4e                	sd	s3,56(sp)
    80004ade:	f852                	sd	s4,48(sp)
    80004ae0:	f456                	sd	s5,40(sp)
    80004ae2:	f05a                	sd	s6,32(sp)
    80004ae4:	ec5e                	sd	s7,24(sp)
    80004ae6:	e862                	sd	s8,16(sp)
    80004ae8:	e466                	sd	s9,8(sp)
    80004aea:	1080                	addi	s0,sp,96
    80004aec:	84aa                	mv	s1,a0
    80004aee:	8aae                	mv	s5,a1
    80004af0:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004af2:	00054703          	lbu	a4,0(a0)
    80004af6:	02f00793          	li	a5,47
    80004afa:	02f70563          	beq	a4,a5,80004b24 <namex+0x52>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004afe:	ffffd097          	auipc	ra,0xffffd
    80004b02:	efa080e7          	jalr	-262(ra) # 800019f8 <myproc>
    80004b06:	6785                	lui	a5,0x1
    80004b08:	97aa                	add	a5,a5,a0
    80004b0a:	fc87b503          	ld	a0,-56(a5) # fc8 <_entry-0x7ffff038>
    80004b0e:	00000097          	auipc	ra,0x0
    80004b12:	9f2080e7          	jalr	-1550(ra) # 80004500 <idup>
    80004b16:	89aa                	mv	s3,a0
  while(*path == '/')
    80004b18:	02f00913          	li	s2,47
  len = path - s;
    80004b1c:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80004b1e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004b20:	4b85                	li	s7,1
    80004b22:	a865                	j	80004bda <namex+0x108>
    ip = iget(ROOTDEV, ROOTINO);
    80004b24:	4585                	li	a1,1
    80004b26:	4505                	li	a0,1
    80004b28:	fffff097          	auipc	ra,0xfffff
    80004b2c:	6e2080e7          	jalr	1762(ra) # 8000420a <iget>
    80004b30:	89aa                	mv	s3,a0
    80004b32:	b7dd                	j	80004b18 <namex+0x46>
      iunlockput(ip);
    80004b34:	854e                	mv	a0,s3
    80004b36:	00000097          	auipc	ra,0x0
    80004b3a:	c6a080e7          	jalr	-918(ra) # 800047a0 <iunlockput>
      return 0;
    80004b3e:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004b40:	854e                	mv	a0,s3
    80004b42:	60e6                	ld	ra,88(sp)
    80004b44:	6446                	ld	s0,80(sp)
    80004b46:	64a6                	ld	s1,72(sp)
    80004b48:	6906                	ld	s2,64(sp)
    80004b4a:	79e2                	ld	s3,56(sp)
    80004b4c:	7a42                	ld	s4,48(sp)
    80004b4e:	7aa2                	ld	s5,40(sp)
    80004b50:	7b02                	ld	s6,32(sp)
    80004b52:	6be2                	ld	s7,24(sp)
    80004b54:	6c42                	ld	s8,16(sp)
    80004b56:	6ca2                	ld	s9,8(sp)
    80004b58:	6125                	addi	sp,sp,96
    80004b5a:	8082                	ret
      iunlock(ip);
    80004b5c:	854e                	mv	a0,s3
    80004b5e:	00000097          	auipc	ra,0x0
    80004b62:	aa2080e7          	jalr	-1374(ra) # 80004600 <iunlock>
      return ip;
    80004b66:	bfe9                	j	80004b40 <namex+0x6e>
      iunlockput(ip);
    80004b68:	854e                	mv	a0,s3
    80004b6a:	00000097          	auipc	ra,0x0
    80004b6e:	c36080e7          	jalr	-970(ra) # 800047a0 <iunlockput>
      return 0;
    80004b72:	89e6                	mv	s3,s9
    80004b74:	b7f1                	j	80004b40 <namex+0x6e>
  len = path - s;
    80004b76:	40b48633          	sub	a2,s1,a1
    80004b7a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004b7e:	099c5463          	bge	s8,s9,80004c06 <namex+0x134>
    memmove(name, s, DIRSIZ);
    80004b82:	4639                	li	a2,14
    80004b84:	8552                	mv	a0,s4
    80004b86:	ffffc097          	auipc	ra,0xffffc
    80004b8a:	1a2080e7          	jalr	418(ra) # 80000d28 <memmove>
  while(*path == '/')
    80004b8e:	0004c783          	lbu	a5,0(s1)
    80004b92:	01279763          	bne	a5,s2,80004ba0 <namex+0xce>
    path++;
    80004b96:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004b98:	0004c783          	lbu	a5,0(s1)
    80004b9c:	ff278de3          	beq	a5,s2,80004b96 <namex+0xc4>
    ilock(ip);
    80004ba0:	854e                	mv	a0,s3
    80004ba2:	00000097          	auipc	ra,0x0
    80004ba6:	99c080e7          	jalr	-1636(ra) # 8000453e <ilock>
    if(ip->type != T_DIR){
    80004baa:	04499783          	lh	a5,68(s3)
    80004bae:	f97793e3          	bne	a5,s7,80004b34 <namex+0x62>
    if(nameiparent && *path == '\0'){
    80004bb2:	000a8563          	beqz	s5,80004bbc <namex+0xea>
    80004bb6:	0004c783          	lbu	a5,0(s1)
    80004bba:	d3cd                	beqz	a5,80004b5c <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004bbc:	865a                	mv	a2,s6
    80004bbe:	85d2                	mv	a1,s4
    80004bc0:	854e                	mv	a0,s3
    80004bc2:	00000097          	auipc	ra,0x0
    80004bc6:	e60080e7          	jalr	-416(ra) # 80004a22 <dirlookup>
    80004bca:	8caa                	mv	s9,a0
    80004bcc:	dd51                	beqz	a0,80004b68 <namex+0x96>
    iunlockput(ip);
    80004bce:	854e                	mv	a0,s3
    80004bd0:	00000097          	auipc	ra,0x0
    80004bd4:	bd0080e7          	jalr	-1072(ra) # 800047a0 <iunlockput>
    ip = next;
    80004bd8:	89e6                	mv	s3,s9
  while(*path == '/')
    80004bda:	0004c783          	lbu	a5,0(s1)
    80004bde:	05279763          	bne	a5,s2,80004c2c <namex+0x15a>
    path++;
    80004be2:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004be4:	0004c783          	lbu	a5,0(s1)
    80004be8:	ff278de3          	beq	a5,s2,80004be2 <namex+0x110>
  if(*path == 0)
    80004bec:	c79d                	beqz	a5,80004c1a <namex+0x148>
    path++;
    80004bee:	85a6                	mv	a1,s1
  len = path - s;
    80004bf0:	8cda                	mv	s9,s6
    80004bf2:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80004bf4:	01278963          	beq	a5,s2,80004c06 <namex+0x134>
    80004bf8:	dfbd                	beqz	a5,80004b76 <namex+0xa4>
    path++;
    80004bfa:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80004bfc:	0004c783          	lbu	a5,0(s1)
    80004c00:	ff279ce3          	bne	a5,s2,80004bf8 <namex+0x126>
    80004c04:	bf8d                	j	80004b76 <namex+0xa4>
    memmove(name, s, len);
    80004c06:	2601                	sext.w	a2,a2
    80004c08:	8552                	mv	a0,s4
    80004c0a:	ffffc097          	auipc	ra,0xffffc
    80004c0e:	11e080e7          	jalr	286(ra) # 80000d28 <memmove>
    name[len] = 0;
    80004c12:	9cd2                	add	s9,s9,s4
    80004c14:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004c18:	bf9d                	j	80004b8e <namex+0xbc>
  if(nameiparent){
    80004c1a:	f20a83e3          	beqz	s5,80004b40 <namex+0x6e>
    iput(ip);
    80004c1e:	854e                	mv	a0,s3
    80004c20:	00000097          	auipc	ra,0x0
    80004c24:	ad8080e7          	jalr	-1320(ra) # 800046f8 <iput>
    return 0;
    80004c28:	4981                	li	s3,0
    80004c2a:	bf19                	j	80004b40 <namex+0x6e>
  if(*path == 0)
    80004c2c:	d7fd                	beqz	a5,80004c1a <namex+0x148>
  while(*path != '/' && *path != 0)
    80004c2e:	0004c783          	lbu	a5,0(s1)
    80004c32:	85a6                	mv	a1,s1
    80004c34:	b7d1                	j	80004bf8 <namex+0x126>

0000000080004c36 <dirlink>:
{
    80004c36:	7139                	addi	sp,sp,-64
    80004c38:	fc06                	sd	ra,56(sp)
    80004c3a:	f822                	sd	s0,48(sp)
    80004c3c:	f426                	sd	s1,40(sp)
    80004c3e:	f04a                	sd	s2,32(sp)
    80004c40:	ec4e                	sd	s3,24(sp)
    80004c42:	e852                	sd	s4,16(sp)
    80004c44:	0080                	addi	s0,sp,64
    80004c46:	892a                	mv	s2,a0
    80004c48:	8a2e                	mv	s4,a1
    80004c4a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004c4c:	4601                	li	a2,0
    80004c4e:	00000097          	auipc	ra,0x0
    80004c52:	dd4080e7          	jalr	-556(ra) # 80004a22 <dirlookup>
    80004c56:	e93d                	bnez	a0,80004ccc <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004c58:	04c92483          	lw	s1,76(s2)
    80004c5c:	c49d                	beqz	s1,80004c8a <dirlink+0x54>
    80004c5e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c60:	4741                	li	a4,16
    80004c62:	86a6                	mv	a3,s1
    80004c64:	fc040613          	addi	a2,s0,-64
    80004c68:	4581                	li	a1,0
    80004c6a:	854a                	mv	a0,s2
    80004c6c:	00000097          	auipc	ra,0x0
    80004c70:	b86080e7          	jalr	-1146(ra) # 800047f2 <readi>
    80004c74:	47c1                	li	a5,16
    80004c76:	06f51163          	bne	a0,a5,80004cd8 <dirlink+0xa2>
    if(de.inum == 0)
    80004c7a:	fc045783          	lhu	a5,-64(s0)
    80004c7e:	c791                	beqz	a5,80004c8a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004c80:	24c1                	addiw	s1,s1,16
    80004c82:	04c92783          	lw	a5,76(s2)
    80004c86:	fcf4ede3          	bltu	s1,a5,80004c60 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004c8a:	4639                	li	a2,14
    80004c8c:	85d2                	mv	a1,s4
    80004c8e:	fc240513          	addi	a0,s0,-62
    80004c92:	ffffc097          	auipc	ra,0xffffc
    80004c96:	14e080e7          	jalr	334(ra) # 80000de0 <strncpy>
  de.inum = inum;
    80004c9a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c9e:	4741                	li	a4,16
    80004ca0:	86a6                	mv	a3,s1
    80004ca2:	fc040613          	addi	a2,s0,-64
    80004ca6:	4581                	li	a1,0
    80004ca8:	854a                	mv	a0,s2
    80004caa:	00000097          	auipc	ra,0x0
    80004cae:	c40080e7          	jalr	-960(ra) # 800048ea <writei>
    80004cb2:	872a                	mv	a4,a0
    80004cb4:	47c1                	li	a5,16
  return 0;
    80004cb6:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cb8:	02f71863          	bne	a4,a5,80004ce8 <dirlink+0xb2>
}
    80004cbc:	70e2                	ld	ra,56(sp)
    80004cbe:	7442                	ld	s0,48(sp)
    80004cc0:	74a2                	ld	s1,40(sp)
    80004cc2:	7902                	ld	s2,32(sp)
    80004cc4:	69e2                	ld	s3,24(sp)
    80004cc6:	6a42                	ld	s4,16(sp)
    80004cc8:	6121                	addi	sp,sp,64
    80004cca:	8082                	ret
    iput(ip);
    80004ccc:	00000097          	auipc	ra,0x0
    80004cd0:	a2c080e7          	jalr	-1492(ra) # 800046f8 <iput>
    return -1;
    80004cd4:	557d                	li	a0,-1
    80004cd6:	b7dd                	j	80004cbc <dirlink+0x86>
      panic("dirlink read");
    80004cd8:	00005517          	auipc	a0,0x5
    80004cdc:	a4850513          	addi	a0,a0,-1464 # 80009720 <syscalls+0x248>
    80004ce0:	ffffc097          	auipc	ra,0xffffc
    80004ce4:	84a080e7          	jalr	-1974(ra) # 8000052a <panic>
    panic("dirlink");
    80004ce8:	00005517          	auipc	a0,0x5
    80004cec:	b4850513          	addi	a0,a0,-1208 # 80009830 <syscalls+0x358>
    80004cf0:	ffffc097          	auipc	ra,0xffffc
    80004cf4:	83a080e7          	jalr	-1990(ra) # 8000052a <panic>

0000000080004cf8 <namei>:

struct inode*
namei(char *path)
{
    80004cf8:	1101                	addi	sp,sp,-32
    80004cfa:	ec06                	sd	ra,24(sp)
    80004cfc:	e822                	sd	s0,16(sp)
    80004cfe:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004d00:	fe040613          	addi	a2,s0,-32
    80004d04:	4581                	li	a1,0
    80004d06:	00000097          	auipc	ra,0x0
    80004d0a:	dcc080e7          	jalr	-564(ra) # 80004ad2 <namex>
}
    80004d0e:	60e2                	ld	ra,24(sp)
    80004d10:	6442                	ld	s0,16(sp)
    80004d12:	6105                	addi	sp,sp,32
    80004d14:	8082                	ret

0000000080004d16 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004d16:	1141                	addi	sp,sp,-16
    80004d18:	e406                	sd	ra,8(sp)
    80004d1a:	e022                	sd	s0,0(sp)
    80004d1c:	0800                	addi	s0,sp,16
    80004d1e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004d20:	4585                	li	a1,1
    80004d22:	00000097          	auipc	ra,0x0
    80004d26:	db0080e7          	jalr	-592(ra) # 80004ad2 <namex>
}
    80004d2a:	60a2                	ld	ra,8(sp)
    80004d2c:	6402                	ld	s0,0(sp)
    80004d2e:	0141                	addi	sp,sp,16
    80004d30:	8082                	ret

0000000080004d32 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004d32:	1101                	addi	sp,sp,-32
    80004d34:	ec06                	sd	ra,24(sp)
    80004d36:	e822                	sd	s0,16(sp)
    80004d38:	e426                	sd	s1,8(sp)
    80004d3a:	e04a                	sd	s2,0(sp)
    80004d3c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004d3e:	0005e917          	auipc	s2,0x5e
    80004d42:	9ba90913          	addi	s2,s2,-1606 # 800626f8 <log>
    80004d46:	01892583          	lw	a1,24(s2)
    80004d4a:	02892503          	lw	a0,40(s2)
    80004d4e:	fffff097          	auipc	ra,0xfffff
    80004d52:	fec080e7          	jalr	-20(ra) # 80003d3a <bread>
    80004d56:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004d58:	02c92683          	lw	a3,44(s2)
    80004d5c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004d5e:	02d05863          	blez	a3,80004d8e <write_head+0x5c>
    80004d62:	0005e797          	auipc	a5,0x5e
    80004d66:	9c678793          	addi	a5,a5,-1594 # 80062728 <log+0x30>
    80004d6a:	05c50713          	addi	a4,a0,92
    80004d6e:	36fd                	addiw	a3,a3,-1
    80004d70:	02069613          	slli	a2,a3,0x20
    80004d74:	01e65693          	srli	a3,a2,0x1e
    80004d78:	0005e617          	auipc	a2,0x5e
    80004d7c:	9b460613          	addi	a2,a2,-1612 # 8006272c <log+0x34>
    80004d80:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004d82:	4390                	lw	a2,0(a5)
    80004d84:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004d86:	0791                	addi	a5,a5,4
    80004d88:	0711                	addi	a4,a4,4
    80004d8a:	fed79ce3          	bne	a5,a3,80004d82 <write_head+0x50>
  }
  bwrite(buf);
    80004d8e:	8526                	mv	a0,s1
    80004d90:	fffff097          	auipc	ra,0xfffff
    80004d94:	09c080e7          	jalr	156(ra) # 80003e2c <bwrite>
  brelse(buf);
    80004d98:	8526                	mv	a0,s1
    80004d9a:	fffff097          	auipc	ra,0xfffff
    80004d9e:	0d0080e7          	jalr	208(ra) # 80003e6a <brelse>
}
    80004da2:	60e2                	ld	ra,24(sp)
    80004da4:	6442                	ld	s0,16(sp)
    80004da6:	64a2                	ld	s1,8(sp)
    80004da8:	6902                	ld	s2,0(sp)
    80004daa:	6105                	addi	sp,sp,32
    80004dac:	8082                	ret

0000000080004dae <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004dae:	0005e797          	auipc	a5,0x5e
    80004db2:	9767a783          	lw	a5,-1674(a5) # 80062724 <log+0x2c>
    80004db6:	0af05d63          	blez	a5,80004e70 <install_trans+0xc2>
{
    80004dba:	7139                	addi	sp,sp,-64
    80004dbc:	fc06                	sd	ra,56(sp)
    80004dbe:	f822                	sd	s0,48(sp)
    80004dc0:	f426                	sd	s1,40(sp)
    80004dc2:	f04a                	sd	s2,32(sp)
    80004dc4:	ec4e                	sd	s3,24(sp)
    80004dc6:	e852                	sd	s4,16(sp)
    80004dc8:	e456                	sd	s5,8(sp)
    80004dca:	e05a                	sd	s6,0(sp)
    80004dcc:	0080                	addi	s0,sp,64
    80004dce:	8b2a                	mv	s6,a0
    80004dd0:	0005ea97          	auipc	s5,0x5e
    80004dd4:	958a8a93          	addi	s5,s5,-1704 # 80062728 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004dd8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004dda:	0005e997          	auipc	s3,0x5e
    80004dde:	91e98993          	addi	s3,s3,-1762 # 800626f8 <log>
    80004de2:	a00d                	j	80004e04 <install_trans+0x56>
    brelse(lbuf);
    80004de4:	854a                	mv	a0,s2
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	084080e7          	jalr	132(ra) # 80003e6a <brelse>
    brelse(dbuf);
    80004dee:	8526                	mv	a0,s1
    80004df0:	fffff097          	auipc	ra,0xfffff
    80004df4:	07a080e7          	jalr	122(ra) # 80003e6a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004df8:	2a05                	addiw	s4,s4,1
    80004dfa:	0a91                	addi	s5,s5,4
    80004dfc:	02c9a783          	lw	a5,44(s3)
    80004e00:	04fa5e63          	bge	s4,a5,80004e5c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004e04:	0189a583          	lw	a1,24(s3)
    80004e08:	014585bb          	addw	a1,a1,s4
    80004e0c:	2585                	addiw	a1,a1,1
    80004e0e:	0289a503          	lw	a0,40(s3)
    80004e12:	fffff097          	auipc	ra,0xfffff
    80004e16:	f28080e7          	jalr	-216(ra) # 80003d3a <bread>
    80004e1a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004e1c:	000aa583          	lw	a1,0(s5)
    80004e20:	0289a503          	lw	a0,40(s3)
    80004e24:	fffff097          	auipc	ra,0xfffff
    80004e28:	f16080e7          	jalr	-234(ra) # 80003d3a <bread>
    80004e2c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004e2e:	40000613          	li	a2,1024
    80004e32:	05890593          	addi	a1,s2,88
    80004e36:	05850513          	addi	a0,a0,88
    80004e3a:	ffffc097          	auipc	ra,0xffffc
    80004e3e:	eee080e7          	jalr	-274(ra) # 80000d28 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004e42:	8526                	mv	a0,s1
    80004e44:	fffff097          	auipc	ra,0xfffff
    80004e48:	fe8080e7          	jalr	-24(ra) # 80003e2c <bwrite>
    if(recovering == 0)
    80004e4c:	f80b1ce3          	bnez	s6,80004de4 <install_trans+0x36>
      bunpin(dbuf);
    80004e50:	8526                	mv	a0,s1
    80004e52:	fffff097          	auipc	ra,0xfffff
    80004e56:	0f2080e7          	jalr	242(ra) # 80003f44 <bunpin>
    80004e5a:	b769                	j	80004de4 <install_trans+0x36>
}
    80004e5c:	70e2                	ld	ra,56(sp)
    80004e5e:	7442                	ld	s0,48(sp)
    80004e60:	74a2                	ld	s1,40(sp)
    80004e62:	7902                	ld	s2,32(sp)
    80004e64:	69e2                	ld	s3,24(sp)
    80004e66:	6a42                	ld	s4,16(sp)
    80004e68:	6aa2                	ld	s5,8(sp)
    80004e6a:	6b02                	ld	s6,0(sp)
    80004e6c:	6121                	addi	sp,sp,64
    80004e6e:	8082                	ret
    80004e70:	8082                	ret

0000000080004e72 <initlog>:
{
    80004e72:	7179                	addi	sp,sp,-48
    80004e74:	f406                	sd	ra,40(sp)
    80004e76:	f022                	sd	s0,32(sp)
    80004e78:	ec26                	sd	s1,24(sp)
    80004e7a:	e84a                	sd	s2,16(sp)
    80004e7c:	e44e                	sd	s3,8(sp)
    80004e7e:	1800                	addi	s0,sp,48
    80004e80:	892a                	mv	s2,a0
    80004e82:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004e84:	0005e497          	auipc	s1,0x5e
    80004e88:	87448493          	addi	s1,s1,-1932 # 800626f8 <log>
    80004e8c:	00005597          	auipc	a1,0x5
    80004e90:	8a458593          	addi	a1,a1,-1884 # 80009730 <syscalls+0x258>
    80004e94:	8526                	mv	a0,s1
    80004e96:	ffffc097          	auipc	ra,0xffffc
    80004e9a:	c9c080e7          	jalr	-868(ra) # 80000b32 <initlock>
  log.start = sb->logstart;
    80004e9e:	0149a583          	lw	a1,20(s3)
    80004ea2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004ea4:	0109a783          	lw	a5,16(s3)
    80004ea8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004eaa:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004eae:	854a                	mv	a0,s2
    80004eb0:	fffff097          	auipc	ra,0xfffff
    80004eb4:	e8a080e7          	jalr	-374(ra) # 80003d3a <bread>
  log.lh.n = lh->n;
    80004eb8:	4d34                	lw	a3,88(a0)
    80004eba:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004ebc:	02d05663          	blez	a3,80004ee8 <initlog+0x76>
    80004ec0:	05c50793          	addi	a5,a0,92
    80004ec4:	0005e717          	auipc	a4,0x5e
    80004ec8:	86470713          	addi	a4,a4,-1948 # 80062728 <log+0x30>
    80004ecc:	36fd                	addiw	a3,a3,-1
    80004ece:	02069613          	slli	a2,a3,0x20
    80004ed2:	01e65693          	srli	a3,a2,0x1e
    80004ed6:	06050613          	addi	a2,a0,96
    80004eda:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004edc:	4390                	lw	a2,0(a5)
    80004ede:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004ee0:	0791                	addi	a5,a5,4
    80004ee2:	0711                	addi	a4,a4,4
    80004ee4:	fed79ce3          	bne	a5,a3,80004edc <initlog+0x6a>
  brelse(buf);
    80004ee8:	fffff097          	auipc	ra,0xfffff
    80004eec:	f82080e7          	jalr	-126(ra) # 80003e6a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004ef0:	4505                	li	a0,1
    80004ef2:	00000097          	auipc	ra,0x0
    80004ef6:	ebc080e7          	jalr	-324(ra) # 80004dae <install_trans>
  log.lh.n = 0;
    80004efa:	0005e797          	auipc	a5,0x5e
    80004efe:	8207a523          	sw	zero,-2006(a5) # 80062724 <log+0x2c>
  write_head(); // clear the log
    80004f02:	00000097          	auipc	ra,0x0
    80004f06:	e30080e7          	jalr	-464(ra) # 80004d32 <write_head>
}
    80004f0a:	70a2                	ld	ra,40(sp)
    80004f0c:	7402                	ld	s0,32(sp)
    80004f0e:	64e2                	ld	s1,24(sp)
    80004f10:	6942                	ld	s2,16(sp)
    80004f12:	69a2                	ld	s3,8(sp)
    80004f14:	6145                	addi	sp,sp,48
    80004f16:	8082                	ret

0000000080004f18 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004f18:	1101                	addi	sp,sp,-32
    80004f1a:	ec06                	sd	ra,24(sp)
    80004f1c:	e822                	sd	s0,16(sp)
    80004f1e:	e426                	sd	s1,8(sp)
    80004f20:	e04a                	sd	s2,0(sp)
    80004f22:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004f24:	0005d517          	auipc	a0,0x5d
    80004f28:	7d450513          	addi	a0,a0,2004 # 800626f8 <log>
    80004f2c:	ffffc097          	auipc	ra,0xffffc
    80004f30:	c9e080e7          	jalr	-866(ra) # 80000bca <acquire>
  while(1){
    if(log.committing){
    80004f34:	0005d497          	auipc	s1,0x5d
    80004f38:	7c448493          	addi	s1,s1,1988 # 800626f8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004f3c:	4979                	li	s2,30
    80004f3e:	a039                	j	80004f4c <begin_op+0x34>
      sleep(&log, &log.lock);
    80004f40:	85a6                	mv	a1,s1
    80004f42:	8526                	mv	a0,s1
    80004f44:	ffffd097          	auipc	ra,0xffffd
    80004f48:	430080e7          	jalr	1072(ra) # 80002374 <sleep>
    if(log.committing){
    80004f4c:	50dc                	lw	a5,36(s1)
    80004f4e:	fbed                	bnez	a5,80004f40 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004f50:	509c                	lw	a5,32(s1)
    80004f52:	0017871b          	addiw	a4,a5,1
    80004f56:	0007069b          	sext.w	a3,a4
    80004f5a:	0027179b          	slliw	a5,a4,0x2
    80004f5e:	9fb9                	addw	a5,a5,a4
    80004f60:	0017979b          	slliw	a5,a5,0x1
    80004f64:	54d8                	lw	a4,44(s1)
    80004f66:	9fb9                	addw	a5,a5,a4
    80004f68:	00f95963          	bge	s2,a5,80004f7a <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004f6c:	85a6                	mv	a1,s1
    80004f6e:	8526                	mv	a0,s1
    80004f70:	ffffd097          	auipc	ra,0xffffd
    80004f74:	404080e7          	jalr	1028(ra) # 80002374 <sleep>
    80004f78:	bfd1                	j	80004f4c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004f7a:	0005d517          	auipc	a0,0x5d
    80004f7e:	77e50513          	addi	a0,a0,1918 # 800626f8 <log>
    80004f82:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004f84:	ffffc097          	auipc	ra,0xffffc
    80004f88:	d00080e7          	jalr	-768(ra) # 80000c84 <release>
      break;
    }
  }
}
    80004f8c:	60e2                	ld	ra,24(sp)
    80004f8e:	6442                	ld	s0,16(sp)
    80004f90:	64a2                	ld	s1,8(sp)
    80004f92:	6902                	ld	s2,0(sp)
    80004f94:	6105                	addi	sp,sp,32
    80004f96:	8082                	ret

0000000080004f98 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004f98:	7139                	addi	sp,sp,-64
    80004f9a:	fc06                	sd	ra,56(sp)
    80004f9c:	f822                	sd	s0,48(sp)
    80004f9e:	f426                	sd	s1,40(sp)
    80004fa0:	f04a                	sd	s2,32(sp)
    80004fa2:	ec4e                	sd	s3,24(sp)
    80004fa4:	e852                	sd	s4,16(sp)
    80004fa6:	e456                	sd	s5,8(sp)
    80004fa8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004faa:	0005d497          	auipc	s1,0x5d
    80004fae:	74e48493          	addi	s1,s1,1870 # 800626f8 <log>
    80004fb2:	8526                	mv	a0,s1
    80004fb4:	ffffc097          	auipc	ra,0xffffc
    80004fb8:	c16080e7          	jalr	-1002(ra) # 80000bca <acquire>
  log.outstanding -= 1;
    80004fbc:	509c                	lw	a5,32(s1)
    80004fbe:	37fd                	addiw	a5,a5,-1
    80004fc0:	0007891b          	sext.w	s2,a5
    80004fc4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004fc6:	50dc                	lw	a5,36(s1)
    80004fc8:	e7b9                	bnez	a5,80005016 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004fca:	04091e63          	bnez	s2,80005026 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004fce:	0005d497          	auipc	s1,0x5d
    80004fd2:	72a48493          	addi	s1,s1,1834 # 800626f8 <log>
    80004fd6:	4785                	li	a5,1
    80004fd8:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004fda:	8526                	mv	a0,s1
    80004fdc:	ffffc097          	auipc	ra,0xffffc
    80004fe0:	ca8080e7          	jalr	-856(ra) # 80000c84 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004fe4:	54dc                	lw	a5,44(s1)
    80004fe6:	06f04763          	bgtz	a5,80005054 <end_op+0xbc>
    acquire(&log.lock);
    80004fea:	0005d497          	auipc	s1,0x5d
    80004fee:	70e48493          	addi	s1,s1,1806 # 800626f8 <log>
    80004ff2:	8526                	mv	a0,s1
    80004ff4:	ffffc097          	auipc	ra,0xffffc
    80004ff8:	bd6080e7          	jalr	-1066(ra) # 80000bca <acquire>
    log.committing = 0;
    80004ffc:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80005000:	8526                	mv	a0,s1
    80005002:	ffffd097          	auipc	ra,0xffffd
    80005006:	532080e7          	jalr	1330(ra) # 80002534 <wakeup>
    release(&log.lock);
    8000500a:	8526                	mv	a0,s1
    8000500c:	ffffc097          	auipc	ra,0xffffc
    80005010:	c78080e7          	jalr	-904(ra) # 80000c84 <release>
}
    80005014:	a03d                	j	80005042 <end_op+0xaa>
    panic("log.committing");
    80005016:	00004517          	auipc	a0,0x4
    8000501a:	72250513          	addi	a0,a0,1826 # 80009738 <syscalls+0x260>
    8000501e:	ffffb097          	auipc	ra,0xffffb
    80005022:	50c080e7          	jalr	1292(ra) # 8000052a <panic>
    wakeup(&log);
    80005026:	0005d497          	auipc	s1,0x5d
    8000502a:	6d248493          	addi	s1,s1,1746 # 800626f8 <log>
    8000502e:	8526                	mv	a0,s1
    80005030:	ffffd097          	auipc	ra,0xffffd
    80005034:	504080e7          	jalr	1284(ra) # 80002534 <wakeup>
  release(&log.lock);
    80005038:	8526                	mv	a0,s1
    8000503a:	ffffc097          	auipc	ra,0xffffc
    8000503e:	c4a080e7          	jalr	-950(ra) # 80000c84 <release>
}
    80005042:	70e2                	ld	ra,56(sp)
    80005044:	7442                	ld	s0,48(sp)
    80005046:	74a2                	ld	s1,40(sp)
    80005048:	7902                	ld	s2,32(sp)
    8000504a:	69e2                	ld	s3,24(sp)
    8000504c:	6a42                	ld	s4,16(sp)
    8000504e:	6aa2                	ld	s5,8(sp)
    80005050:	6121                	addi	sp,sp,64
    80005052:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80005054:	0005da97          	auipc	s5,0x5d
    80005058:	6d4a8a93          	addi	s5,s5,1748 # 80062728 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000505c:	0005da17          	auipc	s4,0x5d
    80005060:	69ca0a13          	addi	s4,s4,1692 # 800626f8 <log>
    80005064:	018a2583          	lw	a1,24(s4)
    80005068:	012585bb          	addw	a1,a1,s2
    8000506c:	2585                	addiw	a1,a1,1
    8000506e:	028a2503          	lw	a0,40(s4)
    80005072:	fffff097          	auipc	ra,0xfffff
    80005076:	cc8080e7          	jalr	-824(ra) # 80003d3a <bread>
    8000507a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000507c:	000aa583          	lw	a1,0(s5)
    80005080:	028a2503          	lw	a0,40(s4)
    80005084:	fffff097          	auipc	ra,0xfffff
    80005088:	cb6080e7          	jalr	-842(ra) # 80003d3a <bread>
    8000508c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000508e:	40000613          	li	a2,1024
    80005092:	05850593          	addi	a1,a0,88
    80005096:	05848513          	addi	a0,s1,88
    8000509a:	ffffc097          	auipc	ra,0xffffc
    8000509e:	c8e080e7          	jalr	-882(ra) # 80000d28 <memmove>
    bwrite(to);  // write the log
    800050a2:	8526                	mv	a0,s1
    800050a4:	fffff097          	auipc	ra,0xfffff
    800050a8:	d88080e7          	jalr	-632(ra) # 80003e2c <bwrite>
    brelse(from);
    800050ac:	854e                	mv	a0,s3
    800050ae:	fffff097          	auipc	ra,0xfffff
    800050b2:	dbc080e7          	jalr	-580(ra) # 80003e6a <brelse>
    brelse(to);
    800050b6:	8526                	mv	a0,s1
    800050b8:	fffff097          	auipc	ra,0xfffff
    800050bc:	db2080e7          	jalr	-590(ra) # 80003e6a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800050c0:	2905                	addiw	s2,s2,1
    800050c2:	0a91                	addi	s5,s5,4
    800050c4:	02ca2783          	lw	a5,44(s4)
    800050c8:	f8f94ee3          	blt	s2,a5,80005064 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800050cc:	00000097          	auipc	ra,0x0
    800050d0:	c66080e7          	jalr	-922(ra) # 80004d32 <write_head>
    install_trans(0); // Now install writes to home locations
    800050d4:	4501                	li	a0,0
    800050d6:	00000097          	auipc	ra,0x0
    800050da:	cd8080e7          	jalr	-808(ra) # 80004dae <install_trans>
    log.lh.n = 0;
    800050de:	0005d797          	auipc	a5,0x5d
    800050e2:	6407a323          	sw	zero,1606(a5) # 80062724 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800050e6:	00000097          	auipc	ra,0x0
    800050ea:	c4c080e7          	jalr	-948(ra) # 80004d32 <write_head>
    800050ee:	bdf5                	j	80004fea <end_op+0x52>

00000000800050f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800050f0:	1101                	addi	sp,sp,-32
    800050f2:	ec06                	sd	ra,24(sp)
    800050f4:	e822                	sd	s0,16(sp)
    800050f6:	e426                	sd	s1,8(sp)
    800050f8:	e04a                	sd	s2,0(sp)
    800050fa:	1000                	addi	s0,sp,32
    800050fc:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800050fe:	0005d917          	auipc	s2,0x5d
    80005102:	5fa90913          	addi	s2,s2,1530 # 800626f8 <log>
    80005106:	854a                	mv	a0,s2
    80005108:	ffffc097          	auipc	ra,0xffffc
    8000510c:	ac2080e7          	jalr	-1342(ra) # 80000bca <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80005110:	02c92603          	lw	a2,44(s2)
    80005114:	47f5                	li	a5,29
    80005116:	06c7c563          	blt	a5,a2,80005180 <log_write+0x90>
    8000511a:	0005d797          	auipc	a5,0x5d
    8000511e:	5fa7a783          	lw	a5,1530(a5) # 80062714 <log+0x1c>
    80005122:	37fd                	addiw	a5,a5,-1
    80005124:	04f65e63          	bge	a2,a5,80005180 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80005128:	0005d797          	auipc	a5,0x5d
    8000512c:	5f07a783          	lw	a5,1520(a5) # 80062718 <log+0x20>
    80005130:	06f05063          	blez	a5,80005190 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80005134:	4781                	li	a5,0
    80005136:	06c05563          	blez	a2,800051a0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    8000513a:	44cc                	lw	a1,12(s1)
    8000513c:	0005d717          	auipc	a4,0x5d
    80005140:	5ec70713          	addi	a4,a4,1516 # 80062728 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80005144:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80005146:	4314                	lw	a3,0(a4)
    80005148:	04b68c63          	beq	a3,a1,800051a0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000514c:	2785                	addiw	a5,a5,1
    8000514e:	0711                	addi	a4,a4,4
    80005150:	fef61be3          	bne	a2,a5,80005146 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80005154:	0621                	addi	a2,a2,8
    80005156:	060a                	slli	a2,a2,0x2
    80005158:	0005d797          	auipc	a5,0x5d
    8000515c:	5a078793          	addi	a5,a5,1440 # 800626f8 <log>
    80005160:	963e                	add	a2,a2,a5
    80005162:	44dc                	lw	a5,12(s1)
    80005164:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80005166:	8526                	mv	a0,s1
    80005168:	fffff097          	auipc	ra,0xfffff
    8000516c:	da0080e7          	jalr	-608(ra) # 80003f08 <bpin>
    log.lh.n++;
    80005170:	0005d717          	auipc	a4,0x5d
    80005174:	58870713          	addi	a4,a4,1416 # 800626f8 <log>
    80005178:	575c                	lw	a5,44(a4)
    8000517a:	2785                	addiw	a5,a5,1
    8000517c:	d75c                	sw	a5,44(a4)
    8000517e:	a835                	j	800051ba <log_write+0xca>
    panic("too big a transaction");
    80005180:	00004517          	auipc	a0,0x4
    80005184:	5c850513          	addi	a0,a0,1480 # 80009748 <syscalls+0x270>
    80005188:	ffffb097          	auipc	ra,0xffffb
    8000518c:	3a2080e7          	jalr	930(ra) # 8000052a <panic>
    panic("log_write outside of trans");
    80005190:	00004517          	auipc	a0,0x4
    80005194:	5d050513          	addi	a0,a0,1488 # 80009760 <syscalls+0x288>
    80005198:	ffffb097          	auipc	ra,0xffffb
    8000519c:	392080e7          	jalr	914(ra) # 8000052a <panic>
  log.lh.block[i] = b->blockno;
    800051a0:	00878713          	addi	a4,a5,8
    800051a4:	00271693          	slli	a3,a4,0x2
    800051a8:	0005d717          	auipc	a4,0x5d
    800051ac:	55070713          	addi	a4,a4,1360 # 800626f8 <log>
    800051b0:	9736                	add	a4,a4,a3
    800051b2:	44d4                	lw	a3,12(s1)
    800051b4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800051b6:	faf608e3          	beq	a2,a5,80005166 <log_write+0x76>
  }
  release(&log.lock);
    800051ba:	0005d517          	auipc	a0,0x5d
    800051be:	53e50513          	addi	a0,a0,1342 # 800626f8 <log>
    800051c2:	ffffc097          	auipc	ra,0xffffc
    800051c6:	ac2080e7          	jalr	-1342(ra) # 80000c84 <release>
}
    800051ca:	60e2                	ld	ra,24(sp)
    800051cc:	6442                	ld	s0,16(sp)
    800051ce:	64a2                	ld	s1,8(sp)
    800051d0:	6902                	ld	s2,0(sp)
    800051d2:	6105                	addi	sp,sp,32
    800051d4:	8082                	ret

00000000800051d6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800051d6:	1101                	addi	sp,sp,-32
    800051d8:	ec06                	sd	ra,24(sp)
    800051da:	e822                	sd	s0,16(sp)
    800051dc:	e426                	sd	s1,8(sp)
    800051de:	e04a                	sd	s2,0(sp)
    800051e0:	1000                	addi	s0,sp,32
    800051e2:	84aa                	mv	s1,a0
    800051e4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800051e6:	00004597          	auipc	a1,0x4
    800051ea:	59a58593          	addi	a1,a1,1434 # 80009780 <syscalls+0x2a8>
    800051ee:	0521                	addi	a0,a0,8
    800051f0:	ffffc097          	auipc	ra,0xffffc
    800051f4:	942080e7          	jalr	-1726(ra) # 80000b32 <initlock>
  lk->name = name;
    800051f8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800051fc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005200:	0204a423          	sw	zero,40(s1)
}
    80005204:	60e2                	ld	ra,24(sp)
    80005206:	6442                	ld	s0,16(sp)
    80005208:	64a2                	ld	s1,8(sp)
    8000520a:	6902                	ld	s2,0(sp)
    8000520c:	6105                	addi	sp,sp,32
    8000520e:	8082                	ret

0000000080005210 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80005210:	1101                	addi	sp,sp,-32
    80005212:	ec06                	sd	ra,24(sp)
    80005214:	e822                	sd	s0,16(sp)
    80005216:	e426                	sd	s1,8(sp)
    80005218:	e04a                	sd	s2,0(sp)
    8000521a:	1000                	addi	s0,sp,32
    8000521c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000521e:	00850913          	addi	s2,a0,8
    80005222:	854a                	mv	a0,s2
    80005224:	ffffc097          	auipc	ra,0xffffc
    80005228:	9a6080e7          	jalr	-1626(ra) # 80000bca <acquire>
  while (lk->locked) {
    8000522c:	409c                	lw	a5,0(s1)
    8000522e:	cb89                	beqz	a5,80005240 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80005230:	85ca                	mv	a1,s2
    80005232:	8526                	mv	a0,s1
    80005234:	ffffd097          	auipc	ra,0xffffd
    80005238:	140080e7          	jalr	320(ra) # 80002374 <sleep>
  while (lk->locked) {
    8000523c:	409c                	lw	a5,0(s1)
    8000523e:	fbed                	bnez	a5,80005230 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80005240:	4785                	li	a5,1
    80005242:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80005244:	ffffc097          	auipc	ra,0xffffc
    80005248:	7b4080e7          	jalr	1972(ra) # 800019f8 <myproc>
    8000524c:	515c                	lw	a5,36(a0)
    8000524e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80005250:	854a                	mv	a0,s2
    80005252:	ffffc097          	auipc	ra,0xffffc
    80005256:	a32080e7          	jalr	-1486(ra) # 80000c84 <release>
}
    8000525a:	60e2                	ld	ra,24(sp)
    8000525c:	6442                	ld	s0,16(sp)
    8000525e:	64a2                	ld	s1,8(sp)
    80005260:	6902                	ld	s2,0(sp)
    80005262:	6105                	addi	sp,sp,32
    80005264:	8082                	ret

0000000080005266 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80005266:	1101                	addi	sp,sp,-32
    80005268:	ec06                	sd	ra,24(sp)
    8000526a:	e822                	sd	s0,16(sp)
    8000526c:	e426                	sd	s1,8(sp)
    8000526e:	e04a                	sd	s2,0(sp)
    80005270:	1000                	addi	s0,sp,32
    80005272:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80005274:	00850913          	addi	s2,a0,8
    80005278:	854a                	mv	a0,s2
    8000527a:	ffffc097          	auipc	ra,0xffffc
    8000527e:	950080e7          	jalr	-1712(ra) # 80000bca <acquire>
  lk->locked = 0;
    80005282:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005286:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000528a:	8526                	mv	a0,s1
    8000528c:	ffffd097          	auipc	ra,0xffffd
    80005290:	2a8080e7          	jalr	680(ra) # 80002534 <wakeup>
  release(&lk->lk);
    80005294:	854a                	mv	a0,s2
    80005296:	ffffc097          	auipc	ra,0xffffc
    8000529a:	9ee080e7          	jalr	-1554(ra) # 80000c84 <release>
}
    8000529e:	60e2                	ld	ra,24(sp)
    800052a0:	6442                	ld	s0,16(sp)
    800052a2:	64a2                	ld	s1,8(sp)
    800052a4:	6902                	ld	s2,0(sp)
    800052a6:	6105                	addi	sp,sp,32
    800052a8:	8082                	ret

00000000800052aa <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800052aa:	7179                	addi	sp,sp,-48
    800052ac:	f406                	sd	ra,40(sp)
    800052ae:	f022                	sd	s0,32(sp)
    800052b0:	ec26                	sd	s1,24(sp)
    800052b2:	e84a                	sd	s2,16(sp)
    800052b4:	e44e                	sd	s3,8(sp)
    800052b6:	1800                	addi	s0,sp,48
    800052b8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800052ba:	00850913          	addi	s2,a0,8
    800052be:	854a                	mv	a0,s2
    800052c0:	ffffc097          	auipc	ra,0xffffc
    800052c4:	90a080e7          	jalr	-1782(ra) # 80000bca <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800052c8:	409c                	lw	a5,0(s1)
    800052ca:	ef99                	bnez	a5,800052e8 <holdingsleep+0x3e>
    800052cc:	4481                	li	s1,0
  release(&lk->lk);
    800052ce:	854a                	mv	a0,s2
    800052d0:	ffffc097          	auipc	ra,0xffffc
    800052d4:	9b4080e7          	jalr	-1612(ra) # 80000c84 <release>
  return r;
}
    800052d8:	8526                	mv	a0,s1
    800052da:	70a2                	ld	ra,40(sp)
    800052dc:	7402                	ld	s0,32(sp)
    800052de:	64e2                	ld	s1,24(sp)
    800052e0:	6942                	ld	s2,16(sp)
    800052e2:	69a2                	ld	s3,8(sp)
    800052e4:	6145                	addi	sp,sp,48
    800052e6:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800052e8:	0284a983          	lw	s3,40(s1)
    800052ec:	ffffc097          	auipc	ra,0xffffc
    800052f0:	70c080e7          	jalr	1804(ra) # 800019f8 <myproc>
    800052f4:	5144                	lw	s1,36(a0)
    800052f6:	413484b3          	sub	s1,s1,s3
    800052fa:	0014b493          	seqz	s1,s1
    800052fe:	bfc1                	j	800052ce <holdingsleep+0x24>

0000000080005300 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80005300:	1141                	addi	sp,sp,-16
    80005302:	e406                	sd	ra,8(sp)
    80005304:	e022                	sd	s0,0(sp)
    80005306:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80005308:	00004597          	auipc	a1,0x4
    8000530c:	48858593          	addi	a1,a1,1160 # 80009790 <syscalls+0x2b8>
    80005310:	0005d517          	auipc	a0,0x5d
    80005314:	53050513          	addi	a0,a0,1328 # 80062840 <ftable>
    80005318:	ffffc097          	auipc	ra,0xffffc
    8000531c:	81a080e7          	jalr	-2022(ra) # 80000b32 <initlock>
}
    80005320:	60a2                	ld	ra,8(sp)
    80005322:	6402                	ld	s0,0(sp)
    80005324:	0141                	addi	sp,sp,16
    80005326:	8082                	ret

0000000080005328 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80005328:	1101                	addi	sp,sp,-32
    8000532a:	ec06                	sd	ra,24(sp)
    8000532c:	e822                	sd	s0,16(sp)
    8000532e:	e426                	sd	s1,8(sp)
    80005330:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80005332:	0005d517          	auipc	a0,0x5d
    80005336:	50e50513          	addi	a0,a0,1294 # 80062840 <ftable>
    8000533a:	ffffc097          	auipc	ra,0xffffc
    8000533e:	890080e7          	jalr	-1904(ra) # 80000bca <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005342:	0005d497          	auipc	s1,0x5d
    80005346:	51648493          	addi	s1,s1,1302 # 80062858 <ftable+0x18>
    8000534a:	0005e717          	auipc	a4,0x5e
    8000534e:	4ae70713          	addi	a4,a4,1198 # 800637f8 <ftable+0xfb8>
    if(f->ref == 0){
    80005352:	40dc                	lw	a5,4(s1)
    80005354:	cf99                	beqz	a5,80005372 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005356:	02848493          	addi	s1,s1,40
    8000535a:	fee49ce3          	bne	s1,a4,80005352 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000535e:	0005d517          	auipc	a0,0x5d
    80005362:	4e250513          	addi	a0,a0,1250 # 80062840 <ftable>
    80005366:	ffffc097          	auipc	ra,0xffffc
    8000536a:	91e080e7          	jalr	-1762(ra) # 80000c84 <release>
  return 0;
    8000536e:	4481                	li	s1,0
    80005370:	a819                	j	80005386 <filealloc+0x5e>
      f->ref = 1;
    80005372:	4785                	li	a5,1
    80005374:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80005376:	0005d517          	auipc	a0,0x5d
    8000537a:	4ca50513          	addi	a0,a0,1226 # 80062840 <ftable>
    8000537e:	ffffc097          	auipc	ra,0xffffc
    80005382:	906080e7          	jalr	-1786(ra) # 80000c84 <release>
}
    80005386:	8526                	mv	a0,s1
    80005388:	60e2                	ld	ra,24(sp)
    8000538a:	6442                	ld	s0,16(sp)
    8000538c:	64a2                	ld	s1,8(sp)
    8000538e:	6105                	addi	sp,sp,32
    80005390:	8082                	ret

0000000080005392 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80005392:	1101                	addi	sp,sp,-32
    80005394:	ec06                	sd	ra,24(sp)
    80005396:	e822                	sd	s0,16(sp)
    80005398:	e426                	sd	s1,8(sp)
    8000539a:	1000                	addi	s0,sp,32
    8000539c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000539e:	0005d517          	auipc	a0,0x5d
    800053a2:	4a250513          	addi	a0,a0,1186 # 80062840 <ftable>
    800053a6:	ffffc097          	auipc	ra,0xffffc
    800053aa:	824080e7          	jalr	-2012(ra) # 80000bca <acquire>
  if(f->ref < 1)
    800053ae:	40dc                	lw	a5,4(s1)
    800053b0:	02f05263          	blez	a5,800053d4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800053b4:	2785                	addiw	a5,a5,1
    800053b6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800053b8:	0005d517          	auipc	a0,0x5d
    800053bc:	48850513          	addi	a0,a0,1160 # 80062840 <ftable>
    800053c0:	ffffc097          	auipc	ra,0xffffc
    800053c4:	8c4080e7          	jalr	-1852(ra) # 80000c84 <release>
  return f;
}
    800053c8:	8526                	mv	a0,s1
    800053ca:	60e2                	ld	ra,24(sp)
    800053cc:	6442                	ld	s0,16(sp)
    800053ce:	64a2                	ld	s1,8(sp)
    800053d0:	6105                	addi	sp,sp,32
    800053d2:	8082                	ret
    panic("filedup");
    800053d4:	00004517          	auipc	a0,0x4
    800053d8:	3c450513          	addi	a0,a0,964 # 80009798 <syscalls+0x2c0>
    800053dc:	ffffb097          	auipc	ra,0xffffb
    800053e0:	14e080e7          	jalr	334(ra) # 8000052a <panic>

00000000800053e4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800053e4:	7139                	addi	sp,sp,-64
    800053e6:	fc06                	sd	ra,56(sp)
    800053e8:	f822                	sd	s0,48(sp)
    800053ea:	f426                	sd	s1,40(sp)
    800053ec:	f04a                	sd	s2,32(sp)
    800053ee:	ec4e                	sd	s3,24(sp)
    800053f0:	e852                	sd	s4,16(sp)
    800053f2:	e456                	sd	s5,8(sp)
    800053f4:	0080                	addi	s0,sp,64
    800053f6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800053f8:	0005d517          	auipc	a0,0x5d
    800053fc:	44850513          	addi	a0,a0,1096 # 80062840 <ftable>
    80005400:	ffffb097          	auipc	ra,0xffffb
    80005404:	7ca080e7          	jalr	1994(ra) # 80000bca <acquire>
  if(f->ref < 1)
    80005408:	40dc                	lw	a5,4(s1)
    8000540a:	06f05163          	blez	a5,8000546c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000540e:	37fd                	addiw	a5,a5,-1
    80005410:	0007871b          	sext.w	a4,a5
    80005414:	c0dc                	sw	a5,4(s1)
    80005416:	06e04363          	bgtz	a4,8000547c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000541a:	0004a903          	lw	s2,0(s1)
    8000541e:	0094ca83          	lbu	s5,9(s1)
    80005422:	0104ba03          	ld	s4,16(s1)
    80005426:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000542a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000542e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80005432:	0005d517          	auipc	a0,0x5d
    80005436:	40e50513          	addi	a0,a0,1038 # 80062840 <ftable>
    8000543a:	ffffc097          	auipc	ra,0xffffc
    8000543e:	84a080e7          	jalr	-1974(ra) # 80000c84 <release>

  if(ff.type == FD_PIPE){
    80005442:	4785                	li	a5,1
    80005444:	04f90d63          	beq	s2,a5,8000549e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80005448:	3979                	addiw	s2,s2,-2
    8000544a:	4785                	li	a5,1
    8000544c:	0527e063          	bltu	a5,s2,8000548c <fileclose+0xa8>
    begin_op();
    80005450:	00000097          	auipc	ra,0x0
    80005454:	ac8080e7          	jalr	-1336(ra) # 80004f18 <begin_op>
    iput(ff.ip);
    80005458:	854e                	mv	a0,s3
    8000545a:	fffff097          	auipc	ra,0xfffff
    8000545e:	29e080e7          	jalr	670(ra) # 800046f8 <iput>
    end_op();
    80005462:	00000097          	auipc	ra,0x0
    80005466:	b36080e7          	jalr	-1226(ra) # 80004f98 <end_op>
    8000546a:	a00d                	j	8000548c <fileclose+0xa8>
    panic("fileclose");
    8000546c:	00004517          	auipc	a0,0x4
    80005470:	33450513          	addi	a0,a0,820 # 800097a0 <syscalls+0x2c8>
    80005474:	ffffb097          	auipc	ra,0xffffb
    80005478:	0b6080e7          	jalr	182(ra) # 8000052a <panic>
    release(&ftable.lock);
    8000547c:	0005d517          	auipc	a0,0x5d
    80005480:	3c450513          	addi	a0,a0,964 # 80062840 <ftable>
    80005484:	ffffc097          	auipc	ra,0xffffc
    80005488:	800080e7          	jalr	-2048(ra) # 80000c84 <release>
  }
}
    8000548c:	70e2                	ld	ra,56(sp)
    8000548e:	7442                	ld	s0,48(sp)
    80005490:	74a2                	ld	s1,40(sp)
    80005492:	7902                	ld	s2,32(sp)
    80005494:	69e2                	ld	s3,24(sp)
    80005496:	6a42                	ld	s4,16(sp)
    80005498:	6aa2                	ld	s5,8(sp)
    8000549a:	6121                	addi	sp,sp,64
    8000549c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000549e:	85d6                	mv	a1,s5
    800054a0:	8552                	mv	a0,s4
    800054a2:	00000097          	auipc	ra,0x0
    800054a6:	350080e7          	jalr	848(ra) # 800057f2 <pipeclose>
    800054aa:	b7cd                	j	8000548c <fileclose+0xa8>

00000000800054ac <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800054ac:	715d                	addi	sp,sp,-80
    800054ae:	e486                	sd	ra,72(sp)
    800054b0:	e0a2                	sd	s0,64(sp)
    800054b2:	fc26                	sd	s1,56(sp)
    800054b4:	f84a                	sd	s2,48(sp)
    800054b6:	f44e                	sd	s3,40(sp)
    800054b8:	0880                	addi	s0,sp,80
    800054ba:	84aa                	mv	s1,a0
    800054bc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800054be:	ffffc097          	auipc	ra,0xffffc
    800054c2:	53a080e7          	jalr	1338(ra) # 800019f8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800054c6:	409c                	lw	a5,0(s1)
    800054c8:	37f9                	addiw	a5,a5,-2
    800054ca:	4705                	li	a4,1
    800054cc:	04f76963          	bltu	a4,a5,8000551e <filestat+0x72>
    800054d0:	892a                	mv	s2,a0
    ilock(f->ip);
    800054d2:	6c88                	ld	a0,24(s1)
    800054d4:	fffff097          	auipc	ra,0xfffff
    800054d8:	06a080e7          	jalr	106(ra) # 8000453e <ilock>
    stati(f->ip, &st);
    800054dc:	fb840593          	addi	a1,s0,-72
    800054e0:	6c88                	ld	a0,24(s1)
    800054e2:	fffff097          	auipc	ra,0xfffff
    800054e6:	2e6080e7          	jalr	742(ra) # 800047c8 <stati>
    iunlock(f->ip);
    800054ea:	6c88                	ld	a0,24(s1)
    800054ec:	fffff097          	auipc	ra,0xfffff
    800054f0:	114080e7          	jalr	276(ra) # 80004600 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800054f4:	6505                	lui	a0,0x1
    800054f6:	954a                	add	a0,a0,s2
    800054f8:	46e1                	li	a3,24
    800054fa:	fb840613          	addi	a2,s0,-72
    800054fe:	85ce                	mv	a1,s3
    80005500:	f4053503          	ld	a0,-192(a0) # f40 <_entry-0x7ffff0c0>
    80005504:	ffffc097          	auipc	ra,0xffffc
    80005508:	148080e7          	jalr	328(ra) # 8000164c <copyout>
    8000550c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80005510:	60a6                	ld	ra,72(sp)
    80005512:	6406                	ld	s0,64(sp)
    80005514:	74e2                	ld	s1,56(sp)
    80005516:	7942                	ld	s2,48(sp)
    80005518:	79a2                	ld	s3,40(sp)
    8000551a:	6161                	addi	sp,sp,80
    8000551c:	8082                	ret
  return -1;
    8000551e:	557d                	li	a0,-1
    80005520:	bfc5                	j	80005510 <filestat+0x64>

0000000080005522 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80005522:	7179                	addi	sp,sp,-48
    80005524:	f406                	sd	ra,40(sp)
    80005526:	f022                	sd	s0,32(sp)
    80005528:	ec26                	sd	s1,24(sp)
    8000552a:	e84a                	sd	s2,16(sp)
    8000552c:	e44e                	sd	s3,8(sp)
    8000552e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80005530:	00854783          	lbu	a5,8(a0)
    80005534:	c3d5                	beqz	a5,800055d8 <fileread+0xb6>
    80005536:	84aa                	mv	s1,a0
    80005538:	89ae                	mv	s3,a1
    8000553a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000553c:	411c                	lw	a5,0(a0)
    8000553e:	4705                	li	a4,1
    80005540:	04e78963          	beq	a5,a4,80005592 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005544:	470d                	li	a4,3
    80005546:	04e78d63          	beq	a5,a4,800055a0 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000554a:	4709                	li	a4,2
    8000554c:	06e79e63          	bne	a5,a4,800055c8 <fileread+0xa6>
    ilock(f->ip);
    80005550:	6d08                	ld	a0,24(a0)
    80005552:	fffff097          	auipc	ra,0xfffff
    80005556:	fec080e7          	jalr	-20(ra) # 8000453e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000555a:	874a                	mv	a4,s2
    8000555c:	5094                	lw	a3,32(s1)
    8000555e:	864e                	mv	a2,s3
    80005560:	4585                	li	a1,1
    80005562:	6c88                	ld	a0,24(s1)
    80005564:	fffff097          	auipc	ra,0xfffff
    80005568:	28e080e7          	jalr	654(ra) # 800047f2 <readi>
    8000556c:	892a                	mv	s2,a0
    8000556e:	00a05563          	blez	a0,80005578 <fileread+0x56>
      f->off += r;
    80005572:	509c                	lw	a5,32(s1)
    80005574:	9fa9                	addw	a5,a5,a0
    80005576:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80005578:	6c88                	ld	a0,24(s1)
    8000557a:	fffff097          	auipc	ra,0xfffff
    8000557e:	086080e7          	jalr	134(ra) # 80004600 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80005582:	854a                	mv	a0,s2
    80005584:	70a2                	ld	ra,40(sp)
    80005586:	7402                	ld	s0,32(sp)
    80005588:	64e2                	ld	s1,24(sp)
    8000558a:	6942                	ld	s2,16(sp)
    8000558c:	69a2                	ld	s3,8(sp)
    8000558e:	6145                	addi	sp,sp,48
    80005590:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80005592:	6908                	ld	a0,16(a0)
    80005594:	00000097          	auipc	ra,0x0
    80005598:	3c8080e7          	jalr	968(ra) # 8000595c <piperead>
    8000559c:	892a                	mv	s2,a0
    8000559e:	b7d5                	j	80005582 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800055a0:	02451783          	lh	a5,36(a0)
    800055a4:	03079693          	slli	a3,a5,0x30
    800055a8:	92c1                	srli	a3,a3,0x30
    800055aa:	4725                	li	a4,9
    800055ac:	02d76863          	bltu	a4,a3,800055dc <fileread+0xba>
    800055b0:	0792                	slli	a5,a5,0x4
    800055b2:	0005d717          	auipc	a4,0x5d
    800055b6:	1ee70713          	addi	a4,a4,494 # 800627a0 <devsw>
    800055ba:	97ba                	add	a5,a5,a4
    800055bc:	639c                	ld	a5,0(a5)
    800055be:	c38d                	beqz	a5,800055e0 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800055c0:	4505                	li	a0,1
    800055c2:	9782                	jalr	a5
    800055c4:	892a                	mv	s2,a0
    800055c6:	bf75                	j	80005582 <fileread+0x60>
    panic("fileread");
    800055c8:	00004517          	auipc	a0,0x4
    800055cc:	1e850513          	addi	a0,a0,488 # 800097b0 <syscalls+0x2d8>
    800055d0:	ffffb097          	auipc	ra,0xffffb
    800055d4:	f5a080e7          	jalr	-166(ra) # 8000052a <panic>
    return -1;
    800055d8:	597d                	li	s2,-1
    800055da:	b765                	j	80005582 <fileread+0x60>
      return -1;
    800055dc:	597d                	li	s2,-1
    800055de:	b755                	j	80005582 <fileread+0x60>
    800055e0:	597d                	li	s2,-1
    800055e2:	b745                	j	80005582 <fileread+0x60>

00000000800055e4 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    800055e4:	715d                	addi	sp,sp,-80
    800055e6:	e486                	sd	ra,72(sp)
    800055e8:	e0a2                	sd	s0,64(sp)
    800055ea:	fc26                	sd	s1,56(sp)
    800055ec:	f84a                	sd	s2,48(sp)
    800055ee:	f44e                	sd	s3,40(sp)
    800055f0:	f052                	sd	s4,32(sp)
    800055f2:	ec56                	sd	s5,24(sp)
    800055f4:	e85a                	sd	s6,16(sp)
    800055f6:	e45e                	sd	s7,8(sp)
    800055f8:	e062                	sd	s8,0(sp)
    800055fa:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800055fc:	00954783          	lbu	a5,9(a0)
    80005600:	10078663          	beqz	a5,8000570c <filewrite+0x128>
    80005604:	892a                	mv	s2,a0
    80005606:	8aae                	mv	s5,a1
    80005608:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000560a:	411c                	lw	a5,0(a0)
    8000560c:	4705                	li	a4,1
    8000560e:	02e78263          	beq	a5,a4,80005632 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005612:	470d                	li	a4,3
    80005614:	02e78663          	beq	a5,a4,80005640 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80005618:	4709                	li	a4,2
    8000561a:	0ee79163          	bne	a5,a4,800056fc <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000561e:	0ac05d63          	blez	a2,800056d8 <filewrite+0xf4>
    int i = 0;
    80005622:	4981                	li	s3,0
    80005624:	6b05                	lui	s6,0x1
    80005626:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    8000562a:	6b85                	lui	s7,0x1
    8000562c:	c00b8b9b          	addiw	s7,s7,-1024
    80005630:	a861                	j	800056c8 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80005632:	6908                	ld	a0,16(a0)
    80005634:	00000097          	auipc	ra,0x0
    80005638:	22e080e7          	jalr	558(ra) # 80005862 <pipewrite>
    8000563c:	8a2a                	mv	s4,a0
    8000563e:	a045                	j	800056de <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80005640:	02451783          	lh	a5,36(a0)
    80005644:	03079693          	slli	a3,a5,0x30
    80005648:	92c1                	srli	a3,a3,0x30
    8000564a:	4725                	li	a4,9
    8000564c:	0cd76263          	bltu	a4,a3,80005710 <filewrite+0x12c>
    80005650:	0792                	slli	a5,a5,0x4
    80005652:	0005d717          	auipc	a4,0x5d
    80005656:	14e70713          	addi	a4,a4,334 # 800627a0 <devsw>
    8000565a:	97ba                	add	a5,a5,a4
    8000565c:	679c                	ld	a5,8(a5)
    8000565e:	cbdd                	beqz	a5,80005714 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80005660:	4505                	li	a0,1
    80005662:	9782                	jalr	a5
    80005664:	8a2a                	mv	s4,a0
    80005666:	a8a5                	j	800056de <filewrite+0xfa>
    80005668:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000566c:	00000097          	auipc	ra,0x0
    80005670:	8ac080e7          	jalr	-1876(ra) # 80004f18 <begin_op>
      ilock(f->ip);
    80005674:	01893503          	ld	a0,24(s2)
    80005678:	fffff097          	auipc	ra,0xfffff
    8000567c:	ec6080e7          	jalr	-314(ra) # 8000453e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005680:	8762                	mv	a4,s8
    80005682:	02092683          	lw	a3,32(s2)
    80005686:	01598633          	add	a2,s3,s5
    8000568a:	4585                	li	a1,1
    8000568c:	01893503          	ld	a0,24(s2)
    80005690:	fffff097          	auipc	ra,0xfffff
    80005694:	25a080e7          	jalr	602(ra) # 800048ea <writei>
    80005698:	84aa                	mv	s1,a0
    8000569a:	00a05763          	blez	a0,800056a8 <filewrite+0xc4>
        f->off += r;
    8000569e:	02092783          	lw	a5,32(s2)
    800056a2:	9fa9                	addw	a5,a5,a0
    800056a4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800056a8:	01893503          	ld	a0,24(s2)
    800056ac:	fffff097          	auipc	ra,0xfffff
    800056b0:	f54080e7          	jalr	-172(ra) # 80004600 <iunlock>
      end_op();
    800056b4:	00000097          	auipc	ra,0x0
    800056b8:	8e4080e7          	jalr	-1820(ra) # 80004f98 <end_op>

      if(r != n1){
    800056bc:	009c1f63          	bne	s8,s1,800056da <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    800056c0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800056c4:	0149db63          	bge	s3,s4,800056da <filewrite+0xf6>
      int n1 = n - i;
    800056c8:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800056cc:	84be                	mv	s1,a5
    800056ce:	2781                	sext.w	a5,a5
    800056d0:	f8fb5ce3          	bge	s6,a5,80005668 <filewrite+0x84>
    800056d4:	84de                	mv	s1,s7
    800056d6:	bf49                	j	80005668 <filewrite+0x84>
    int i = 0;
    800056d8:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800056da:	013a1f63          	bne	s4,s3,800056f8 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800056de:	8552                	mv	a0,s4
    800056e0:	60a6                	ld	ra,72(sp)
    800056e2:	6406                	ld	s0,64(sp)
    800056e4:	74e2                	ld	s1,56(sp)
    800056e6:	7942                	ld	s2,48(sp)
    800056e8:	79a2                	ld	s3,40(sp)
    800056ea:	7a02                	ld	s4,32(sp)
    800056ec:	6ae2                	ld	s5,24(sp)
    800056ee:	6b42                	ld	s6,16(sp)
    800056f0:	6ba2                	ld	s7,8(sp)
    800056f2:	6c02                	ld	s8,0(sp)
    800056f4:	6161                	addi	sp,sp,80
    800056f6:	8082                	ret
    ret = (i == n ? n : -1);
    800056f8:	5a7d                	li	s4,-1
    800056fa:	b7d5                	j	800056de <filewrite+0xfa>
    panic("filewrite");
    800056fc:	00004517          	auipc	a0,0x4
    80005700:	0c450513          	addi	a0,a0,196 # 800097c0 <syscalls+0x2e8>
    80005704:	ffffb097          	auipc	ra,0xffffb
    80005708:	e26080e7          	jalr	-474(ra) # 8000052a <panic>
    return -1;
    8000570c:	5a7d                	li	s4,-1
    8000570e:	bfc1                	j	800056de <filewrite+0xfa>
      return -1;
    80005710:	5a7d                	li	s4,-1
    80005712:	b7f1                	j	800056de <filewrite+0xfa>
    80005714:	5a7d                	li	s4,-1
    80005716:	b7e1                	j	800056de <filewrite+0xfa>

0000000080005718 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005718:	7179                	addi	sp,sp,-48
    8000571a:	f406                	sd	ra,40(sp)
    8000571c:	f022                	sd	s0,32(sp)
    8000571e:	ec26                	sd	s1,24(sp)
    80005720:	e84a                	sd	s2,16(sp)
    80005722:	e44e                	sd	s3,8(sp)
    80005724:	e052                	sd	s4,0(sp)
    80005726:	1800                	addi	s0,sp,48
    80005728:	84aa                	mv	s1,a0
    8000572a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000572c:	0005b023          	sd	zero,0(a1)
    80005730:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80005734:	00000097          	auipc	ra,0x0
    80005738:	bf4080e7          	jalr	-1036(ra) # 80005328 <filealloc>
    8000573c:	e088                	sd	a0,0(s1)
    8000573e:	c551                	beqz	a0,800057ca <pipealloc+0xb2>
    80005740:	00000097          	auipc	ra,0x0
    80005744:	be8080e7          	jalr	-1048(ra) # 80005328 <filealloc>
    80005748:	00aa3023          	sd	a0,0(s4)
    8000574c:	c92d                	beqz	a0,800057be <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000574e:	ffffb097          	auipc	ra,0xffffb
    80005752:	384080e7          	jalr	900(ra) # 80000ad2 <kalloc>
    80005756:	892a                	mv	s2,a0
    80005758:	c125                	beqz	a0,800057b8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000575a:	4985                	li	s3,1
    8000575c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80005760:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80005764:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80005768:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000576c:	00004597          	auipc	a1,0x4
    80005770:	06458593          	addi	a1,a1,100 # 800097d0 <syscalls+0x2f8>
    80005774:	ffffb097          	auipc	ra,0xffffb
    80005778:	3be080e7          	jalr	958(ra) # 80000b32 <initlock>
  (*f0)->type = FD_PIPE;
    8000577c:	609c                	ld	a5,0(s1)
    8000577e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80005782:	609c                	ld	a5,0(s1)
    80005784:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80005788:	609c                	ld	a5,0(s1)
    8000578a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000578e:	609c                	ld	a5,0(s1)
    80005790:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80005794:	000a3783          	ld	a5,0(s4)
    80005798:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000579c:	000a3783          	ld	a5,0(s4)
    800057a0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800057a4:	000a3783          	ld	a5,0(s4)
    800057a8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800057ac:	000a3783          	ld	a5,0(s4)
    800057b0:	0127b823          	sd	s2,16(a5)
  return 0;
    800057b4:	4501                	li	a0,0
    800057b6:	a025                	j	800057de <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800057b8:	6088                	ld	a0,0(s1)
    800057ba:	e501                	bnez	a0,800057c2 <pipealloc+0xaa>
    800057bc:	a039                	j	800057ca <pipealloc+0xb2>
    800057be:	6088                	ld	a0,0(s1)
    800057c0:	c51d                	beqz	a0,800057ee <pipealloc+0xd6>
    fileclose(*f0);
    800057c2:	00000097          	auipc	ra,0x0
    800057c6:	c22080e7          	jalr	-990(ra) # 800053e4 <fileclose>
  if(*f1)
    800057ca:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800057ce:	557d                	li	a0,-1
  if(*f1)
    800057d0:	c799                	beqz	a5,800057de <pipealloc+0xc6>
    fileclose(*f1);
    800057d2:	853e                	mv	a0,a5
    800057d4:	00000097          	auipc	ra,0x0
    800057d8:	c10080e7          	jalr	-1008(ra) # 800053e4 <fileclose>
  return -1;
    800057dc:	557d                	li	a0,-1
}
    800057de:	70a2                	ld	ra,40(sp)
    800057e0:	7402                	ld	s0,32(sp)
    800057e2:	64e2                	ld	s1,24(sp)
    800057e4:	6942                	ld	s2,16(sp)
    800057e6:	69a2                	ld	s3,8(sp)
    800057e8:	6a02                	ld	s4,0(sp)
    800057ea:	6145                	addi	sp,sp,48
    800057ec:	8082                	ret
  return -1;
    800057ee:	557d                	li	a0,-1
    800057f0:	b7fd                	j	800057de <pipealloc+0xc6>

00000000800057f2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800057f2:	1101                	addi	sp,sp,-32
    800057f4:	ec06                	sd	ra,24(sp)
    800057f6:	e822                	sd	s0,16(sp)
    800057f8:	e426                	sd	s1,8(sp)
    800057fa:	e04a                	sd	s2,0(sp)
    800057fc:	1000                	addi	s0,sp,32
    800057fe:	84aa                	mv	s1,a0
    80005800:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005802:	ffffb097          	auipc	ra,0xffffb
    80005806:	3c8080e7          	jalr	968(ra) # 80000bca <acquire>
  if(writable){
    8000580a:	02090d63          	beqz	s2,80005844 <pipeclose+0x52>
    pi->writeopen = 0;
    8000580e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005812:	21848513          	addi	a0,s1,536
    80005816:	ffffd097          	auipc	ra,0xffffd
    8000581a:	d1e080e7          	jalr	-738(ra) # 80002534 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000581e:	2204b783          	ld	a5,544(s1)
    80005822:	eb95                	bnez	a5,80005856 <pipeclose+0x64>
    release(&pi->lock);
    80005824:	8526                	mv	a0,s1
    80005826:	ffffb097          	auipc	ra,0xffffb
    8000582a:	45e080e7          	jalr	1118(ra) # 80000c84 <release>
    kfree((char*)pi);
    8000582e:	8526                	mv	a0,s1
    80005830:	ffffb097          	auipc	ra,0xffffb
    80005834:	1a6080e7          	jalr	422(ra) # 800009d6 <kfree>
  } else
    release(&pi->lock);
}
    80005838:	60e2                	ld	ra,24(sp)
    8000583a:	6442                	ld	s0,16(sp)
    8000583c:	64a2                	ld	s1,8(sp)
    8000583e:	6902                	ld	s2,0(sp)
    80005840:	6105                	addi	sp,sp,32
    80005842:	8082                	ret
    pi->readopen = 0;
    80005844:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005848:	21c48513          	addi	a0,s1,540
    8000584c:	ffffd097          	auipc	ra,0xffffd
    80005850:	ce8080e7          	jalr	-792(ra) # 80002534 <wakeup>
    80005854:	b7e9                	j	8000581e <pipeclose+0x2c>
    release(&pi->lock);
    80005856:	8526                	mv	a0,s1
    80005858:	ffffb097          	auipc	ra,0xffffb
    8000585c:	42c080e7          	jalr	1068(ra) # 80000c84 <release>
}
    80005860:	bfe1                	j	80005838 <pipeclose+0x46>

0000000080005862 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005862:	7159                	addi	sp,sp,-112
    80005864:	f486                	sd	ra,104(sp)
    80005866:	f0a2                	sd	s0,96(sp)
    80005868:	eca6                	sd	s1,88(sp)
    8000586a:	e8ca                	sd	s2,80(sp)
    8000586c:	e4ce                	sd	s3,72(sp)
    8000586e:	e0d2                	sd	s4,64(sp)
    80005870:	fc56                	sd	s5,56(sp)
    80005872:	f85a                	sd	s6,48(sp)
    80005874:	f45e                	sd	s7,40(sp)
    80005876:	f062                	sd	s8,32(sp)
    80005878:	ec66                	sd	s9,24(sp)
    8000587a:	1880                	addi	s0,sp,112
    8000587c:	84aa                	mv	s1,a0
    8000587e:	8aae                	mv	s5,a1
    80005880:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80005882:	ffffc097          	auipc	ra,0xffffc
    80005886:	176080e7          	jalr	374(ra) # 800019f8 <myproc>
    8000588a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000588c:	8526                	mv	a0,s1
    8000588e:	ffffb097          	auipc	ra,0xffffb
    80005892:	33c080e7          	jalr	828(ra) # 80000bca <acquire>
  while(i < n){
    80005896:	0b405663          	blez	s4,80005942 <pipewrite+0xe0>
  int i = 0;
    8000589a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000589c:	6b05                	lui	s6,0x1
    8000589e:	9b4e                	add	s6,s6,s3
    800058a0:	5bfd                	li	s7,-1
      wakeup(&pi->nread);
    800058a2:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800058a6:	21c48c13          	addi	s8,s1,540
    800058aa:	a091                	j	800058ee <pipewrite+0x8c>
      release(&pi->lock);
    800058ac:	8526                	mv	a0,s1
    800058ae:	ffffb097          	auipc	ra,0xffffb
    800058b2:	3d6080e7          	jalr	982(ra) # 80000c84 <release>
      return -1;
    800058b6:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800058b8:	854a                	mv	a0,s2
    800058ba:	70a6                	ld	ra,104(sp)
    800058bc:	7406                	ld	s0,96(sp)
    800058be:	64e6                	ld	s1,88(sp)
    800058c0:	6946                	ld	s2,80(sp)
    800058c2:	69a6                	ld	s3,72(sp)
    800058c4:	6a06                	ld	s4,64(sp)
    800058c6:	7ae2                	ld	s5,56(sp)
    800058c8:	7b42                	ld	s6,48(sp)
    800058ca:	7ba2                	ld	s7,40(sp)
    800058cc:	7c02                	ld	s8,32(sp)
    800058ce:	6ce2                	ld	s9,24(sp)
    800058d0:	6165                	addi	sp,sp,112
    800058d2:	8082                	ret
      wakeup(&pi->nread);
    800058d4:	8566                	mv	a0,s9
    800058d6:	ffffd097          	auipc	ra,0xffffd
    800058da:	c5e080e7          	jalr	-930(ra) # 80002534 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800058de:	85a6                	mv	a1,s1
    800058e0:	8562                	mv	a0,s8
    800058e2:	ffffd097          	auipc	ra,0xffffd
    800058e6:	a92080e7          	jalr	-1390(ra) # 80002374 <sleep>
  while(i < n){
    800058ea:	05495d63          	bge	s2,s4,80005944 <pipewrite+0xe2>
    if(pi->readopen == 0 || pr->killed){
    800058ee:	2204a783          	lw	a5,544(s1)
    800058f2:	dfcd                	beqz	a5,800058ac <pipewrite+0x4a>
    800058f4:	01c9a783          	lw	a5,28(s3)
    800058f8:	fbd5                	bnez	a5,800058ac <pipewrite+0x4a>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800058fa:	2184a783          	lw	a5,536(s1)
    800058fe:	21c4a703          	lw	a4,540(s1)
    80005902:	2007879b          	addiw	a5,a5,512
    80005906:	fcf707e3          	beq	a4,a5,800058d4 <pipewrite+0x72>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000590a:	4685                	li	a3,1
    8000590c:	01590633          	add	a2,s2,s5
    80005910:	f9f40593          	addi	a1,s0,-97
    80005914:	f40b3503          	ld	a0,-192(s6) # f40 <_entry-0x7ffff0c0>
    80005918:	ffffc097          	auipc	ra,0xffffc
    8000591c:	dc0080e7          	jalr	-576(ra) # 800016d8 <copyin>
    80005920:	03750263          	beq	a0,s7,80005944 <pipewrite+0xe2>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005924:	21c4a783          	lw	a5,540(s1)
    80005928:	0017871b          	addiw	a4,a5,1
    8000592c:	20e4ae23          	sw	a4,540(s1)
    80005930:	1ff7f793          	andi	a5,a5,511
    80005934:	97a6                	add	a5,a5,s1
    80005936:	f9f44703          	lbu	a4,-97(s0)
    8000593a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000593e:	2905                	addiw	s2,s2,1
    80005940:	b76d                	j	800058ea <pipewrite+0x88>
  int i = 0;
    80005942:	4901                	li	s2,0
  wakeup(&pi->nread);
    80005944:	21848513          	addi	a0,s1,536
    80005948:	ffffd097          	auipc	ra,0xffffd
    8000594c:	bec080e7          	jalr	-1044(ra) # 80002534 <wakeup>
  release(&pi->lock);
    80005950:	8526                	mv	a0,s1
    80005952:	ffffb097          	auipc	ra,0xffffb
    80005956:	332080e7          	jalr	818(ra) # 80000c84 <release>
  return i;
    8000595a:	bfb9                	j	800058b8 <pipewrite+0x56>

000000008000595c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000595c:	715d                	addi	sp,sp,-80
    8000595e:	e486                	sd	ra,72(sp)
    80005960:	e0a2                	sd	s0,64(sp)
    80005962:	fc26                	sd	s1,56(sp)
    80005964:	f84a                	sd	s2,48(sp)
    80005966:	f44e                	sd	s3,40(sp)
    80005968:	f052                	sd	s4,32(sp)
    8000596a:	ec56                	sd	s5,24(sp)
    8000596c:	e85a                	sd	s6,16(sp)
    8000596e:	0880                	addi	s0,sp,80
    80005970:	84aa                	mv	s1,a0
    80005972:	892e                	mv	s2,a1
    80005974:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80005976:	ffffc097          	auipc	ra,0xffffc
    8000597a:	082080e7          	jalr	130(ra) # 800019f8 <myproc>
    8000597e:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80005980:	8526                	mv	a0,s1
    80005982:	ffffb097          	auipc	ra,0xffffb
    80005986:	248080e7          	jalr	584(ra) # 80000bca <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000598a:	2184a703          	lw	a4,536(s1)
    8000598e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005992:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005996:	02f71463          	bne	a4,a5,800059be <piperead+0x62>
    8000599a:	2244a783          	lw	a5,548(s1)
    8000599e:	c385                	beqz	a5,800059be <piperead+0x62>
    if(pr->killed){
    800059a0:	01caa783          	lw	a5,28(s5)
    800059a4:	ebd1                	bnez	a5,80005a38 <piperead+0xdc>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800059a6:	85a6                	mv	a1,s1
    800059a8:	854e                	mv	a0,s3
    800059aa:	ffffd097          	auipc	ra,0xffffd
    800059ae:	9ca080e7          	jalr	-1590(ra) # 80002374 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800059b2:	2184a703          	lw	a4,536(s1)
    800059b6:	21c4a783          	lw	a5,540(s1)
    800059ba:	fef700e3          	beq	a4,a5,8000599a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800059be:	4981                	li	s3,0
    800059c0:	09405363          	blez	s4,80005a46 <piperead+0xea>
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800059c4:	6505                	lui	a0,0x1
    800059c6:	9aaa                	add	s5,s5,a0
    800059c8:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800059ca:	2184a783          	lw	a5,536(s1)
    800059ce:	21c4a703          	lw	a4,540(s1)
    800059d2:	02f70d63          	beq	a4,a5,80005a0c <piperead+0xb0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800059d6:	0017871b          	addiw	a4,a5,1
    800059da:	20e4ac23          	sw	a4,536(s1)
    800059de:	1ff7f793          	andi	a5,a5,511
    800059e2:	97a6                	add	a5,a5,s1
    800059e4:	0187c783          	lbu	a5,24(a5)
    800059e8:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800059ec:	4685                	li	a3,1
    800059ee:	fbf40613          	addi	a2,s0,-65
    800059f2:	85ca                	mv	a1,s2
    800059f4:	f40ab503          	ld	a0,-192(s5)
    800059f8:	ffffc097          	auipc	ra,0xffffc
    800059fc:	c54080e7          	jalr	-940(ra) # 8000164c <copyout>
    80005a00:	01650663          	beq	a0,s6,80005a0c <piperead+0xb0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005a04:	2985                	addiw	s3,s3,1
    80005a06:	0905                	addi	s2,s2,1
    80005a08:	fd3a11e3          	bne	s4,s3,800059ca <piperead+0x6e>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005a0c:	21c48513          	addi	a0,s1,540
    80005a10:	ffffd097          	auipc	ra,0xffffd
    80005a14:	b24080e7          	jalr	-1244(ra) # 80002534 <wakeup>
  release(&pi->lock);
    80005a18:	8526                	mv	a0,s1
    80005a1a:	ffffb097          	auipc	ra,0xffffb
    80005a1e:	26a080e7          	jalr	618(ra) # 80000c84 <release>
  return i;
}
    80005a22:	854e                	mv	a0,s3
    80005a24:	60a6                	ld	ra,72(sp)
    80005a26:	6406                	ld	s0,64(sp)
    80005a28:	74e2                	ld	s1,56(sp)
    80005a2a:	7942                	ld	s2,48(sp)
    80005a2c:	79a2                	ld	s3,40(sp)
    80005a2e:	7a02                	ld	s4,32(sp)
    80005a30:	6ae2                	ld	s5,24(sp)
    80005a32:	6b42                	ld	s6,16(sp)
    80005a34:	6161                	addi	sp,sp,80
    80005a36:	8082                	ret
      release(&pi->lock);
    80005a38:	8526                	mv	a0,s1
    80005a3a:	ffffb097          	auipc	ra,0xffffb
    80005a3e:	24a080e7          	jalr	586(ra) # 80000c84 <release>
      return -1;
    80005a42:	59fd                	li	s3,-1
    80005a44:	bff9                	j	80005a22 <piperead+0xc6>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005a46:	4981                	li	s3,0
    80005a48:	b7d1                	j	80005a0c <piperead+0xb0>

0000000080005a4a <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80005a4a:	dd010113          	addi	sp,sp,-560
    80005a4e:	22113423          	sd	ra,552(sp)
    80005a52:	22813023          	sd	s0,544(sp)
    80005a56:	20913c23          	sd	s1,536(sp)
    80005a5a:	21213823          	sd	s2,528(sp)
    80005a5e:	21313423          	sd	s3,520(sp)
    80005a62:	21413023          	sd	s4,512(sp)
    80005a66:	ffd6                	sd	s5,504(sp)
    80005a68:	fbda                	sd	s6,496(sp)
    80005a6a:	f7de                	sd	s7,488(sp)
    80005a6c:	f3e2                	sd	s8,480(sp)
    80005a6e:	efe6                	sd	s9,472(sp)
    80005a70:	ebea                	sd	s10,464(sp)
    80005a72:	e7ee                	sd	s11,456(sp)
    80005a74:	1c00                	addi	s0,sp,560
    80005a76:	892a                	mv	s2,a0
    80005a78:	dea43423          	sd	a0,-536(s0)
    80005a7c:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005a80:	ffffc097          	auipc	ra,0xffffc
    80005a84:	f78080e7          	jalr	-136(ra) # 800019f8 <myproc>
    80005a88:	84aa                	mv	s1,a0
  struct thread *t = mythread();
    80005a8a:	ffffc097          	auipc	ra,0xffffc
    80005a8e:	ff4080e7          	jalr	-12(ra) # 80001a7e <mythread>
    80005a92:	dea43023          	sd	a0,-544(s0)

  begin_op();
    80005a96:	fffff097          	auipc	ra,0xfffff
    80005a9a:	482080e7          	jalr	1154(ra) # 80004f18 <begin_op>

  if((ip = namei(path)) == 0){
    80005a9e:	854a                	mv	a0,s2
    80005aa0:	fffff097          	auipc	ra,0xfffff
    80005aa4:	258080e7          	jalr	600(ra) # 80004cf8 <namei>
    80005aa8:	cd2d                	beqz	a0,80005b22 <exec+0xd8>
    80005aaa:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005aac:	fffff097          	auipc	ra,0xfffff
    80005ab0:	a92080e7          	jalr	-1390(ra) # 8000453e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005ab4:	04000713          	li	a4,64
    80005ab8:	4681                	li	a3,0
    80005aba:	e4840613          	addi	a2,s0,-440
    80005abe:	4581                	li	a1,0
    80005ac0:	8556                	mv	a0,s5
    80005ac2:	fffff097          	auipc	ra,0xfffff
    80005ac6:	d30080e7          	jalr	-720(ra) # 800047f2 <readi>
    80005aca:	04000793          	li	a5,64
    80005ace:	00f51a63          	bne	a0,a5,80005ae2 <exec+0x98>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80005ad2:	e4842703          	lw	a4,-440(s0)
    80005ad6:	464c47b7          	lui	a5,0x464c4
    80005ada:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005ade:	04f70863          	beq	a4,a5,80005b2e <exec+0xe4>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005ae2:	8556                	mv	a0,s5
    80005ae4:	fffff097          	auipc	ra,0xfffff
    80005ae8:	cbc080e7          	jalr	-836(ra) # 800047a0 <iunlockput>
    end_op();
    80005aec:	fffff097          	auipc	ra,0xfffff
    80005af0:	4ac080e7          	jalr	1196(ra) # 80004f98 <end_op>
  }
  return -1;
    80005af4:	557d                	li	a0,-1
}
    80005af6:	22813083          	ld	ra,552(sp)
    80005afa:	22013403          	ld	s0,544(sp)
    80005afe:	21813483          	ld	s1,536(sp)
    80005b02:	21013903          	ld	s2,528(sp)
    80005b06:	20813983          	ld	s3,520(sp)
    80005b0a:	20013a03          	ld	s4,512(sp)
    80005b0e:	7afe                	ld	s5,504(sp)
    80005b10:	7b5e                	ld	s6,496(sp)
    80005b12:	7bbe                	ld	s7,488(sp)
    80005b14:	7c1e                	ld	s8,480(sp)
    80005b16:	6cfe                	ld	s9,472(sp)
    80005b18:	6d5e                	ld	s10,464(sp)
    80005b1a:	6dbe                	ld	s11,456(sp)
    80005b1c:	23010113          	addi	sp,sp,560
    80005b20:	8082                	ret
    end_op();
    80005b22:	fffff097          	auipc	ra,0xfffff
    80005b26:	476080e7          	jalr	1142(ra) # 80004f98 <end_op>
    return -1;
    80005b2a:	557d                	li	a0,-1
    80005b2c:	b7e9                	j	80005af6 <exec+0xac>
  if((pagetable = proc_pagetable(p)) == 0)
    80005b2e:	8526                	mv	a0,s1
    80005b30:	ffffc097          	auipc	ra,0xffffc
    80005b34:	01a080e7          	jalr	26(ra) # 80001b4a <proc_pagetable>
    80005b38:	8b2a                	mv	s6,a0
    80005b3a:	d545                	beqz	a0,80005ae2 <exec+0x98>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005b3c:	e6842783          	lw	a5,-408(s0)
    80005b40:	e8045703          	lhu	a4,-384(s0)
    80005b44:	c735                	beqz	a4,80005bb0 <exec+0x166>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80005b46:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005b48:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80005b4c:	6a05                	lui	s4,0x1
    80005b4e:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80005b52:	dce43c23          	sd	a4,-552(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80005b56:	6d85                	lui	s11,0x1
    80005b58:	7d7d                	lui	s10,0xfffff
    80005b5a:	ac9d                	j	80005dd0 <exec+0x386>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80005b5c:	00004517          	auipc	a0,0x4
    80005b60:	c7c50513          	addi	a0,a0,-900 # 800097d8 <syscalls+0x300>
    80005b64:	ffffb097          	auipc	ra,0xffffb
    80005b68:	9c6080e7          	jalr	-1594(ra) # 8000052a <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005b6c:	874a                	mv	a4,s2
    80005b6e:	009c86bb          	addw	a3,s9,s1
    80005b72:	4581                	li	a1,0
    80005b74:	8556                	mv	a0,s5
    80005b76:	fffff097          	auipc	ra,0xfffff
    80005b7a:	c7c080e7          	jalr	-900(ra) # 800047f2 <readi>
    80005b7e:	2501                	sext.w	a0,a0
    80005b80:	1ea91863          	bne	s2,a0,80005d70 <exec+0x326>
  for(i = 0; i < sz; i += PGSIZE){
    80005b84:	009d84bb          	addw	s1,s11,s1
    80005b88:	013d09bb          	addw	s3,s10,s3
    80005b8c:	2374f263          	bgeu	s1,s7,80005db0 <exec+0x366>
    pa = walkaddr(pagetable, va + i);
    80005b90:	02049593          	slli	a1,s1,0x20
    80005b94:	9181                	srli	a1,a1,0x20
    80005b96:	95e2                	add	a1,a1,s8
    80005b98:	855a                	mv	a0,s6
    80005b9a:	ffffb097          	auipc	ra,0xffffb
    80005b9e:	4c0080e7          	jalr	1216(ra) # 8000105a <walkaddr>
    80005ba2:	862a                	mv	a2,a0
    if(pa == 0)
    80005ba4:	dd45                	beqz	a0,80005b5c <exec+0x112>
      n = PGSIZE;
    80005ba6:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80005ba8:	fd49f2e3          	bgeu	s3,s4,80005b6c <exec+0x122>
      n = sz - i;
    80005bac:	894e                	mv	s2,s3
    80005bae:	bf7d                	j	80005b6c <exec+0x122>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80005bb0:	4481                	li	s1,0
  iunlockput(ip);
    80005bb2:	8556                	mv	a0,s5
    80005bb4:	fffff097          	auipc	ra,0xfffff
    80005bb8:	bec080e7          	jalr	-1044(ra) # 800047a0 <iunlockput>
  end_op();
    80005bbc:	fffff097          	auipc	ra,0xfffff
    80005bc0:	3dc080e7          	jalr	988(ra) # 80004f98 <end_op>
  p = myproc();
    80005bc4:	ffffc097          	auipc	ra,0xffffc
    80005bc8:	e34080e7          	jalr	-460(ra) # 800019f8 <myproc>
    80005bcc:	8a2a                	mv	s4,a0
  uint64 oldsz = p->sz;
    80005bce:	6785                	lui	a5,0x1
    80005bd0:	00f50733          	add	a4,a0,a5
    80005bd4:	f3873d03          	ld	s10,-200(a4)
  sz = PGROUNDUP(sz);
    80005bd8:	17fd                	addi	a5,a5,-1
    80005bda:	94be                	add	s1,s1,a5
    80005bdc:	77fd                	lui	a5,0xfffff
    80005bde:	8fe5                	and	a5,a5,s1
    80005be0:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005be4:	6609                	lui	a2,0x2
    80005be6:	963e                	add	a2,a2,a5
    80005be8:	85be                	mv	a1,a5
    80005bea:	855a                	mv	a0,s6
    80005bec:	ffffc097          	auipc	ra,0xffffc
    80005bf0:	810080e7          	jalr	-2032(ra) # 800013fc <uvmalloc>
    80005bf4:	8caa                	mv	s9,a0
  ip = 0;
    80005bf6:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005bf8:	16050c63          	beqz	a0,80005d70 <exec+0x326>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005bfc:	75f9                	lui	a1,0xffffe
    80005bfe:	95aa                	add	a1,a1,a0
    80005c00:	855a                	mv	a0,s6
    80005c02:	ffffc097          	auipc	ra,0xffffc
    80005c06:	a18080e7          	jalr	-1512(ra) # 8000161a <uvmclear>
  stackbase = sp - PGSIZE;
    80005c0a:	7bfd                	lui	s7,0xfffff
    80005c0c:	9be6                	add	s7,s7,s9
  for(argc = 0; argv[argc]; argc++) {
    80005c0e:	df043783          	ld	a5,-528(s0)
    80005c12:	6388                	ld	a0,0(a5)
    80005c14:	c925                	beqz	a0,80005c84 <exec+0x23a>
    80005c16:	e8840993          	addi	s3,s0,-376
    80005c1a:	f8840c13          	addi	s8,s0,-120
  sp = sz;
    80005c1e:	8966                	mv	s2,s9
  for(argc = 0; argv[argc]; argc++) {
    80005c20:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005c22:	ffffb097          	auipc	ra,0xffffb
    80005c26:	22e080e7          	jalr	558(ra) # 80000e50 <strlen>
    80005c2a:	0015079b          	addiw	a5,a0,1
    80005c2e:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005c32:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80005c36:	17796163          	bltu	s2,s7,80005d98 <exec+0x34e>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005c3a:	df043d83          	ld	s11,-528(s0)
    80005c3e:	000dba83          	ld	s5,0(s11) # 1000 <_entry-0x7ffff000>
    80005c42:	8556                	mv	a0,s5
    80005c44:	ffffb097          	auipc	ra,0xffffb
    80005c48:	20c080e7          	jalr	524(ra) # 80000e50 <strlen>
    80005c4c:	0015069b          	addiw	a3,a0,1
    80005c50:	8656                	mv	a2,s5
    80005c52:	85ca                	mv	a1,s2
    80005c54:	855a                	mv	a0,s6
    80005c56:	ffffc097          	auipc	ra,0xffffc
    80005c5a:	9f6080e7          	jalr	-1546(ra) # 8000164c <copyout>
    80005c5e:	14054163          	bltz	a0,80005da0 <exec+0x356>
    ustack[argc] = sp;
    80005c62:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005c66:	0485                	addi	s1,s1,1
    80005c68:	008d8793          	addi	a5,s11,8
    80005c6c:	def43823          	sd	a5,-528(s0)
    80005c70:	008db503          	ld	a0,8(s11)
    80005c74:	c911                	beqz	a0,80005c88 <exec+0x23e>
    if(argc >= MAXARG)
    80005c76:	09a1                	addi	s3,s3,8
    80005c78:	fb8995e3          	bne	s3,s8,80005c22 <exec+0x1d8>
  sz = sz1;
    80005c7c:	df943c23          	sd	s9,-520(s0)
  ip = 0;
    80005c80:	4a81                	li	s5,0
    80005c82:	a0fd                	j	80005d70 <exec+0x326>
  sp = sz;
    80005c84:	8966                	mv	s2,s9
  for(argc = 0; argv[argc]; argc++) {
    80005c86:	4481                	li	s1,0
  ustack[argc] = 0;
    80005c88:	00349793          	slli	a5,s1,0x3
    80005c8c:	f9040713          	addi	a4,s0,-112
    80005c90:	97ba                	add	a5,a5,a4
    80005c92:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ff97ef8>
  sp -= (argc+1) * sizeof(uint64);
    80005c96:	00148693          	addi	a3,s1,1
    80005c9a:	068e                	slli	a3,a3,0x3
    80005c9c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005ca0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80005ca4:	01797663          	bgeu	s2,s7,80005cb0 <exec+0x266>
  sz = sz1;
    80005ca8:	df943c23          	sd	s9,-520(s0)
  ip = 0;
    80005cac:	4a81                	li	s5,0
    80005cae:	a0c9                	j	80005d70 <exec+0x326>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005cb0:	e8840613          	addi	a2,s0,-376
    80005cb4:	85ca                	mv	a1,s2
    80005cb6:	855a                	mv	a0,s6
    80005cb8:	ffffc097          	auipc	ra,0xffffc
    80005cbc:	994080e7          	jalr	-1644(ra) # 8000164c <copyout>
    80005cc0:	0e054463          	bltz	a0,80005da8 <exec+0x35e>
  t->trapframe->a1 = sp;
    80005cc4:	de043783          	ld	a5,-544(s0)
    80005cc8:	7f9c                	ld	a5,56(a5)
    80005cca:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005cce:	de843783          	ld	a5,-536(s0)
    80005cd2:	0007c703          	lbu	a4,0(a5)
    80005cd6:	cf11                	beqz	a4,80005cf2 <exec+0x2a8>
    80005cd8:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005cda:	02f00693          	li	a3,47
    80005cde:	a039                	j	80005cec <exec+0x2a2>
      last = s+1;
    80005ce0:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005ce4:	0785                	addi	a5,a5,1
    80005ce6:	fff7c703          	lbu	a4,-1(a5)
    80005cea:	c701                	beqz	a4,80005cf2 <exec+0x2a8>
    if(*s == '/')
    80005cec:	fed71ce3          	bne	a4,a3,80005ce4 <exec+0x29a>
    80005cf0:	bfc5                	j	80005ce0 <exec+0x296>
  safestrcpy(p->name, last, sizeof(p->name));
    80005cf2:	6985                	lui	s3,0x1
    80005cf4:	fd098513          	addi	a0,s3,-48 # fd0 <_entry-0x7ffff030>
    80005cf8:	4641                	li	a2,16
    80005cfa:	de843583          	ld	a1,-536(s0)
    80005cfe:	9552                	add	a0,a0,s4
    80005d00:	ffffb097          	auipc	ra,0xffffb
    80005d04:	11e080e7          	jalr	286(ra) # 80000e1e <safestrcpy>
  oldpagetable = p->pagetable;
    80005d08:	013a07b3          	add	a5,s4,s3
    80005d0c:	f407b503          	ld	a0,-192(a5)
  p->pagetable = pagetable;
    80005d10:	f567b023          	sd	s6,-192(a5)
  p->sz = sz;
    80005d14:	f397bc23          	sd	s9,-200(a5)
  t->trapframe->epc = elf.entry;  // initial program counter = main
    80005d18:	de043683          	ld	a3,-544(s0)
    80005d1c:	7e9c                	ld	a5,56(a3)
    80005d1e:	e6043703          	ld	a4,-416(s0)
    80005d22:	ef98                	sd	a4,24(a5)
  t->trapframe->sp = sp; // initial stack pointer
    80005d24:	7e9c                	ld	a5,56(a3)
    80005d26:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005d2a:	85ea                	mv	a1,s10
    80005d2c:	ffffc097          	auipc	ra,0xffffc
    80005d30:	ec0080e7          	jalr	-320(ra) # 80001bec <proc_freepagetable>
  for (int i =0; i<32; i++){
    80005d34:	fe898713          	addi	a4,s3,-24
    80005d38:	9752                	add	a4,a4,s4
    80005d3a:	0f498793          	addi	a5,s3,244
    80005d3e:	97d2                	add	a5,a5,s4
    80005d40:	17498693          	addi	a3,s3,372
    80005d44:	96d2                	add	a3,a3,s4
    if(signalHanlder != (void*)SIG_IGN && signalHanlder != (void*)SIG_DFL){
    80005d46:	4585                	li	a1,1
    80005d48:	a029                	j	80005d52 <exec+0x308>
  for (int i =0; i<32; i++){
    80005d4a:	0721                	addi	a4,a4,8
    80005d4c:	0791                	addi	a5,a5,4
    80005d4e:	00f68863          	beq	a3,a5,80005d5e <exec+0x314>
    if(signalHanlder != (void*)SIG_IGN && signalHanlder != (void*)SIG_DFL){
    80005d52:	6310                	ld	a2,0(a4)
    80005d54:	fec5fbe3          	bgeu	a1,a2,80005d4a <exec+0x300>
      p->maskHandlers[i]= 0;
    80005d58:	0007a023          	sw	zero,0(a5)
    80005d5c:	b7fd                	j	80005d4a <exec+0x300>
  p->signalMask = 0;
    80005d5e:	6785                	lui	a5,0x1
    80005d60:	9a3e                	add	s4,s4,a5
    80005d62:	fe0a2223          	sw	zero,-28(s4)
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005d66:	0004851b          	sext.w	a0,s1
    80005d6a:	b371                	j	80005af6 <exec+0xac>
    80005d6c:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005d70:	df843583          	ld	a1,-520(s0)
    80005d74:	855a                	mv	a0,s6
    80005d76:	ffffc097          	auipc	ra,0xffffc
    80005d7a:	e76080e7          	jalr	-394(ra) # 80001bec <proc_freepagetable>
  if(ip){
    80005d7e:	d60a92e3          	bnez	s5,80005ae2 <exec+0x98>
  return -1;
    80005d82:	557d                	li	a0,-1
    80005d84:	bb8d                	j	80005af6 <exec+0xac>
    80005d86:	de943c23          	sd	s1,-520(s0)
    80005d8a:	b7dd                	j	80005d70 <exec+0x326>
    80005d8c:	de943c23          	sd	s1,-520(s0)
    80005d90:	b7c5                	j	80005d70 <exec+0x326>
    80005d92:	de943c23          	sd	s1,-520(s0)
    80005d96:	bfe9                	j	80005d70 <exec+0x326>
  sz = sz1;
    80005d98:	df943c23          	sd	s9,-520(s0)
  ip = 0;
    80005d9c:	4a81                	li	s5,0
    80005d9e:	bfc9                	j	80005d70 <exec+0x326>
  sz = sz1;
    80005da0:	df943c23          	sd	s9,-520(s0)
  ip = 0;
    80005da4:	4a81                	li	s5,0
    80005da6:	b7e9                	j	80005d70 <exec+0x326>
  sz = sz1;
    80005da8:	df943c23          	sd	s9,-520(s0)
  ip = 0;
    80005dac:	4a81                	li	s5,0
    80005dae:	b7c9                	j	80005d70 <exec+0x326>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005db0:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005db4:	e0843783          	ld	a5,-504(s0)
    80005db8:	0017869b          	addiw	a3,a5,1
    80005dbc:	e0d43423          	sd	a3,-504(s0)
    80005dc0:	e0043783          	ld	a5,-512(s0)
    80005dc4:	0387879b          	addiw	a5,a5,56
    80005dc8:	e8045703          	lhu	a4,-384(s0)
    80005dcc:	dee6d3e3          	bge	a3,a4,80005bb2 <exec+0x168>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005dd0:	2781                	sext.w	a5,a5
    80005dd2:	e0f43023          	sd	a5,-512(s0)
    80005dd6:	03800713          	li	a4,56
    80005dda:	86be                	mv	a3,a5
    80005ddc:	e1040613          	addi	a2,s0,-496
    80005de0:	4581                	li	a1,0
    80005de2:	8556                	mv	a0,s5
    80005de4:	fffff097          	auipc	ra,0xfffff
    80005de8:	a0e080e7          	jalr	-1522(ra) # 800047f2 <readi>
    80005dec:	03800793          	li	a5,56
    80005df0:	f6f51ee3          	bne	a0,a5,80005d6c <exec+0x322>
    if(ph.type != ELF_PROG_LOAD)
    80005df4:	e1042783          	lw	a5,-496(s0)
    80005df8:	4705                	li	a4,1
    80005dfa:	fae79de3          	bne	a5,a4,80005db4 <exec+0x36a>
    if(ph.memsz < ph.filesz)
    80005dfe:	e3843603          	ld	a2,-456(s0)
    80005e02:	e3043783          	ld	a5,-464(s0)
    80005e06:	f8f660e3          	bltu	a2,a5,80005d86 <exec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005e0a:	e2043783          	ld	a5,-480(s0)
    80005e0e:	963e                	add	a2,a2,a5
    80005e10:	f6f66ee3          	bltu	a2,a5,80005d8c <exec+0x342>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005e14:	85a6                	mv	a1,s1
    80005e16:	855a                	mv	a0,s6
    80005e18:	ffffb097          	auipc	ra,0xffffb
    80005e1c:	5e4080e7          	jalr	1508(ra) # 800013fc <uvmalloc>
    80005e20:	dea43c23          	sd	a0,-520(s0)
    80005e24:	d53d                	beqz	a0,80005d92 <exec+0x348>
    if(ph.vaddr % PGSIZE != 0)
    80005e26:	e2043c03          	ld	s8,-480(s0)
    80005e2a:	dd843783          	ld	a5,-552(s0)
    80005e2e:	00fc77b3          	and	a5,s8,a5
    80005e32:	ff9d                	bnez	a5,80005d70 <exec+0x326>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005e34:	e1842c83          	lw	s9,-488(s0)
    80005e38:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005e3c:	f60b8ae3          	beqz	s7,80005db0 <exec+0x366>
    80005e40:	89de                	mv	s3,s7
    80005e42:	4481                	li	s1,0
    80005e44:	b3b1                	j	80005b90 <exec+0x146>

0000000080005e46 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005e46:	7179                	addi	sp,sp,-48
    80005e48:	f406                	sd	ra,40(sp)
    80005e4a:	f022                	sd	s0,32(sp)
    80005e4c:	ec26                	sd	s1,24(sp)
    80005e4e:	e84a                	sd	s2,16(sp)
    80005e50:	1800                	addi	s0,sp,48
    80005e52:	892e                	mv	s2,a1
    80005e54:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005e56:	fdc40593          	addi	a1,s0,-36
    80005e5a:	ffffe097          	auipc	ra,0xffffe
    80005e5e:	90c080e7          	jalr	-1780(ra) # 80003766 <argint>
    80005e62:	04054063          	bltz	a0,80005ea2 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005e66:	fdc42703          	lw	a4,-36(s0)
    80005e6a:	47bd                	li	a5,15
    80005e6c:	02e7ed63          	bltu	a5,a4,80005ea6 <argfd+0x60>
    80005e70:	ffffc097          	auipc	ra,0xffffc
    80005e74:	b88080e7          	jalr	-1144(ra) # 800019f8 <myproc>
    80005e78:	fdc42703          	lw	a4,-36(s0)
    80005e7c:	1e870793          	addi	a5,a4,488
    80005e80:	078e                	slli	a5,a5,0x3
    80005e82:	953e                	add	a0,a0,a5
    80005e84:	651c                	ld	a5,8(a0)
    80005e86:	c395                	beqz	a5,80005eaa <argfd+0x64>
    return -1;
  if(pfd)
    80005e88:	00090463          	beqz	s2,80005e90 <argfd+0x4a>
    *pfd = fd;
    80005e8c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005e90:	4501                	li	a0,0
  if(pf)
    80005e92:	c091                	beqz	s1,80005e96 <argfd+0x50>
    *pf = f;
    80005e94:	e09c                	sd	a5,0(s1)
}
    80005e96:	70a2                	ld	ra,40(sp)
    80005e98:	7402                	ld	s0,32(sp)
    80005e9a:	64e2                	ld	s1,24(sp)
    80005e9c:	6942                	ld	s2,16(sp)
    80005e9e:	6145                	addi	sp,sp,48
    80005ea0:	8082                	ret
    return -1;
    80005ea2:	557d                	li	a0,-1
    80005ea4:	bfcd                	j	80005e96 <argfd+0x50>
    return -1;
    80005ea6:	557d                	li	a0,-1
    80005ea8:	b7fd                	j	80005e96 <argfd+0x50>
    80005eaa:	557d                	li	a0,-1
    80005eac:	b7ed                	j	80005e96 <argfd+0x50>

0000000080005eae <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005eae:	1101                	addi	sp,sp,-32
    80005eb0:	ec06                	sd	ra,24(sp)
    80005eb2:	e822                	sd	s0,16(sp)
    80005eb4:	e426                	sd	s1,8(sp)
    80005eb6:	1000                	addi	s0,sp,32
    80005eb8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005eba:	ffffc097          	auipc	ra,0xffffc
    80005ebe:	b3e080e7          	jalr	-1218(ra) # 800019f8 <myproc>
    80005ec2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005ec4:	6785                	lui	a5,0x1
    80005ec6:	f4878793          	addi	a5,a5,-184 # f48 <_entry-0x7ffff0b8>
    80005eca:	97aa                	add	a5,a5,a0
    80005ecc:	4501                	li	a0,0
    80005ece:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005ed0:	6398                	ld	a4,0(a5)
    80005ed2:	cb19                	beqz	a4,80005ee8 <fdalloc+0x3a>
  for(fd = 0; fd < NOFILE; fd++){
    80005ed4:	2505                	addiw	a0,a0,1
    80005ed6:	07a1                	addi	a5,a5,8
    80005ed8:	fed51ce3          	bne	a0,a3,80005ed0 <fdalloc+0x22>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005edc:	557d                	li	a0,-1
}
    80005ede:	60e2                	ld	ra,24(sp)
    80005ee0:	6442                	ld	s0,16(sp)
    80005ee2:	64a2                	ld	s1,8(sp)
    80005ee4:	6105                	addi	sp,sp,32
    80005ee6:	8082                	ret
      p->ofile[fd] = f;
    80005ee8:	1e850793          	addi	a5,a0,488
    80005eec:	078e                	slli	a5,a5,0x3
    80005eee:	963e                	add	a2,a2,a5
    80005ef0:	e604                	sd	s1,8(a2)
      return fd;
    80005ef2:	b7f5                	j	80005ede <fdalloc+0x30>

0000000080005ef4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005ef4:	715d                	addi	sp,sp,-80
    80005ef6:	e486                	sd	ra,72(sp)
    80005ef8:	e0a2                	sd	s0,64(sp)
    80005efa:	fc26                	sd	s1,56(sp)
    80005efc:	f84a                	sd	s2,48(sp)
    80005efe:	f44e                	sd	s3,40(sp)
    80005f00:	f052                	sd	s4,32(sp)
    80005f02:	ec56                	sd	s5,24(sp)
    80005f04:	0880                	addi	s0,sp,80
    80005f06:	89ae                	mv	s3,a1
    80005f08:	8ab2                	mv	s5,a2
    80005f0a:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005f0c:	fb040593          	addi	a1,s0,-80
    80005f10:	fffff097          	auipc	ra,0xfffff
    80005f14:	e06080e7          	jalr	-506(ra) # 80004d16 <nameiparent>
    80005f18:	892a                	mv	s2,a0
    80005f1a:	12050e63          	beqz	a0,80006056 <create+0x162>
    return 0;

  ilock(dp);
    80005f1e:	ffffe097          	auipc	ra,0xffffe
    80005f22:	620080e7          	jalr	1568(ra) # 8000453e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005f26:	4601                	li	a2,0
    80005f28:	fb040593          	addi	a1,s0,-80
    80005f2c:	854a                	mv	a0,s2
    80005f2e:	fffff097          	auipc	ra,0xfffff
    80005f32:	af4080e7          	jalr	-1292(ra) # 80004a22 <dirlookup>
    80005f36:	84aa                	mv	s1,a0
    80005f38:	c921                	beqz	a0,80005f88 <create+0x94>
    iunlockput(dp);
    80005f3a:	854a                	mv	a0,s2
    80005f3c:	fffff097          	auipc	ra,0xfffff
    80005f40:	864080e7          	jalr	-1948(ra) # 800047a0 <iunlockput>
    ilock(ip);
    80005f44:	8526                	mv	a0,s1
    80005f46:	ffffe097          	auipc	ra,0xffffe
    80005f4a:	5f8080e7          	jalr	1528(ra) # 8000453e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005f4e:	2981                	sext.w	s3,s3
    80005f50:	4789                	li	a5,2
    80005f52:	02f99463          	bne	s3,a5,80005f7a <create+0x86>
    80005f56:	0444d783          	lhu	a5,68(s1)
    80005f5a:	37f9                	addiw	a5,a5,-2
    80005f5c:	17c2                	slli	a5,a5,0x30
    80005f5e:	93c1                	srli	a5,a5,0x30
    80005f60:	4705                	li	a4,1
    80005f62:	00f76c63          	bltu	a4,a5,80005f7a <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005f66:	8526                	mv	a0,s1
    80005f68:	60a6                	ld	ra,72(sp)
    80005f6a:	6406                	ld	s0,64(sp)
    80005f6c:	74e2                	ld	s1,56(sp)
    80005f6e:	7942                	ld	s2,48(sp)
    80005f70:	79a2                	ld	s3,40(sp)
    80005f72:	7a02                	ld	s4,32(sp)
    80005f74:	6ae2                	ld	s5,24(sp)
    80005f76:	6161                	addi	sp,sp,80
    80005f78:	8082                	ret
    iunlockput(ip);
    80005f7a:	8526                	mv	a0,s1
    80005f7c:	fffff097          	auipc	ra,0xfffff
    80005f80:	824080e7          	jalr	-2012(ra) # 800047a0 <iunlockput>
    return 0;
    80005f84:	4481                	li	s1,0
    80005f86:	b7c5                	j	80005f66 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005f88:	85ce                	mv	a1,s3
    80005f8a:	00092503          	lw	a0,0(s2)
    80005f8e:	ffffe097          	auipc	ra,0xffffe
    80005f92:	418080e7          	jalr	1048(ra) # 800043a6 <ialloc>
    80005f96:	84aa                	mv	s1,a0
    80005f98:	c521                	beqz	a0,80005fe0 <create+0xec>
  ilock(ip);
    80005f9a:	ffffe097          	auipc	ra,0xffffe
    80005f9e:	5a4080e7          	jalr	1444(ra) # 8000453e <ilock>
  ip->major = major;
    80005fa2:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005fa6:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005faa:	4a05                	li	s4,1
    80005fac:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005fb0:	8526                	mv	a0,s1
    80005fb2:	ffffe097          	auipc	ra,0xffffe
    80005fb6:	4c2080e7          	jalr	1218(ra) # 80004474 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005fba:	2981                	sext.w	s3,s3
    80005fbc:	03498a63          	beq	s3,s4,80005ff0 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005fc0:	40d0                	lw	a2,4(s1)
    80005fc2:	fb040593          	addi	a1,s0,-80
    80005fc6:	854a                	mv	a0,s2
    80005fc8:	fffff097          	auipc	ra,0xfffff
    80005fcc:	c6e080e7          	jalr	-914(ra) # 80004c36 <dirlink>
    80005fd0:	06054b63          	bltz	a0,80006046 <create+0x152>
  iunlockput(dp);
    80005fd4:	854a                	mv	a0,s2
    80005fd6:	ffffe097          	auipc	ra,0xffffe
    80005fda:	7ca080e7          	jalr	1994(ra) # 800047a0 <iunlockput>
  return ip;
    80005fde:	b761                	j	80005f66 <create+0x72>
    panic("create: ialloc");
    80005fe0:	00004517          	auipc	a0,0x4
    80005fe4:	81850513          	addi	a0,a0,-2024 # 800097f8 <syscalls+0x320>
    80005fe8:	ffffa097          	auipc	ra,0xffffa
    80005fec:	542080e7          	jalr	1346(ra) # 8000052a <panic>
    dp->nlink++;  // for ".."
    80005ff0:	04a95783          	lhu	a5,74(s2)
    80005ff4:	2785                	addiw	a5,a5,1
    80005ff6:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005ffa:	854a                	mv	a0,s2
    80005ffc:	ffffe097          	auipc	ra,0xffffe
    80006000:	478080e7          	jalr	1144(ra) # 80004474 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80006004:	40d0                	lw	a2,4(s1)
    80006006:	00004597          	auipc	a1,0x4
    8000600a:	80258593          	addi	a1,a1,-2046 # 80009808 <syscalls+0x330>
    8000600e:	8526                	mv	a0,s1
    80006010:	fffff097          	auipc	ra,0xfffff
    80006014:	c26080e7          	jalr	-986(ra) # 80004c36 <dirlink>
    80006018:	00054f63          	bltz	a0,80006036 <create+0x142>
    8000601c:	00492603          	lw	a2,4(s2)
    80006020:	00003597          	auipc	a1,0x3
    80006024:	7f058593          	addi	a1,a1,2032 # 80009810 <syscalls+0x338>
    80006028:	8526                	mv	a0,s1
    8000602a:	fffff097          	auipc	ra,0xfffff
    8000602e:	c0c080e7          	jalr	-1012(ra) # 80004c36 <dirlink>
    80006032:	f80557e3          	bgez	a0,80005fc0 <create+0xcc>
      panic("create dots");
    80006036:	00003517          	auipc	a0,0x3
    8000603a:	7e250513          	addi	a0,a0,2018 # 80009818 <syscalls+0x340>
    8000603e:	ffffa097          	auipc	ra,0xffffa
    80006042:	4ec080e7          	jalr	1260(ra) # 8000052a <panic>
    panic("create: dirlink");
    80006046:	00003517          	auipc	a0,0x3
    8000604a:	7e250513          	addi	a0,a0,2018 # 80009828 <syscalls+0x350>
    8000604e:	ffffa097          	auipc	ra,0xffffa
    80006052:	4dc080e7          	jalr	1244(ra) # 8000052a <panic>
    return 0;
    80006056:	84aa                	mv	s1,a0
    80006058:	b739                	j	80005f66 <create+0x72>

000000008000605a <sys_dup>:
{
    8000605a:	7179                	addi	sp,sp,-48
    8000605c:	f406                	sd	ra,40(sp)
    8000605e:	f022                	sd	s0,32(sp)
    80006060:	ec26                	sd	s1,24(sp)
    80006062:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80006064:	fd840613          	addi	a2,s0,-40
    80006068:	4581                	li	a1,0
    8000606a:	4501                	li	a0,0
    8000606c:	00000097          	auipc	ra,0x0
    80006070:	dda080e7          	jalr	-550(ra) # 80005e46 <argfd>
    return -1;
    80006074:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80006076:	02054363          	bltz	a0,8000609c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000607a:	fd843503          	ld	a0,-40(s0)
    8000607e:	00000097          	auipc	ra,0x0
    80006082:	e30080e7          	jalr	-464(ra) # 80005eae <fdalloc>
    80006086:	84aa                	mv	s1,a0
    return -1;
    80006088:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000608a:	00054963          	bltz	a0,8000609c <sys_dup+0x42>
  filedup(f);
    8000608e:	fd843503          	ld	a0,-40(s0)
    80006092:	fffff097          	auipc	ra,0xfffff
    80006096:	300080e7          	jalr	768(ra) # 80005392 <filedup>
  return fd;
    8000609a:	87a6                	mv	a5,s1
}
    8000609c:	853e                	mv	a0,a5
    8000609e:	70a2                	ld	ra,40(sp)
    800060a0:	7402                	ld	s0,32(sp)
    800060a2:	64e2                	ld	s1,24(sp)
    800060a4:	6145                	addi	sp,sp,48
    800060a6:	8082                	ret

00000000800060a8 <sys_read>:
{
    800060a8:	7179                	addi	sp,sp,-48
    800060aa:	f406                	sd	ra,40(sp)
    800060ac:	f022                	sd	s0,32(sp)
    800060ae:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800060b0:	fe840613          	addi	a2,s0,-24
    800060b4:	4581                	li	a1,0
    800060b6:	4501                	li	a0,0
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	d8e080e7          	jalr	-626(ra) # 80005e46 <argfd>
    return -1;
    800060c0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800060c2:	04054163          	bltz	a0,80006104 <sys_read+0x5c>
    800060c6:	fe440593          	addi	a1,s0,-28
    800060ca:	4509                	li	a0,2
    800060cc:	ffffd097          	auipc	ra,0xffffd
    800060d0:	69a080e7          	jalr	1690(ra) # 80003766 <argint>
    return -1;
    800060d4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800060d6:	02054763          	bltz	a0,80006104 <sys_read+0x5c>
    800060da:	fd840593          	addi	a1,s0,-40
    800060de:	4505                	li	a0,1
    800060e0:	ffffd097          	auipc	ra,0xffffd
    800060e4:	6a8080e7          	jalr	1704(ra) # 80003788 <argaddr>
    return -1;
    800060e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800060ea:	00054d63          	bltz	a0,80006104 <sys_read+0x5c>
  return fileread(f, p, n);
    800060ee:	fe442603          	lw	a2,-28(s0)
    800060f2:	fd843583          	ld	a1,-40(s0)
    800060f6:	fe843503          	ld	a0,-24(s0)
    800060fa:	fffff097          	auipc	ra,0xfffff
    800060fe:	428080e7          	jalr	1064(ra) # 80005522 <fileread>
    80006102:	87aa                	mv	a5,a0
}
    80006104:	853e                	mv	a0,a5
    80006106:	70a2                	ld	ra,40(sp)
    80006108:	7402                	ld	s0,32(sp)
    8000610a:	6145                	addi	sp,sp,48
    8000610c:	8082                	ret

000000008000610e <sys_write>:
{
    8000610e:	7179                	addi	sp,sp,-48
    80006110:	f406                	sd	ra,40(sp)
    80006112:	f022                	sd	s0,32(sp)
    80006114:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006116:	fe840613          	addi	a2,s0,-24
    8000611a:	4581                	li	a1,0
    8000611c:	4501                	li	a0,0
    8000611e:	00000097          	auipc	ra,0x0
    80006122:	d28080e7          	jalr	-728(ra) # 80005e46 <argfd>
    return -1;
    80006126:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006128:	04054163          	bltz	a0,8000616a <sys_write+0x5c>
    8000612c:	fe440593          	addi	a1,s0,-28
    80006130:	4509                	li	a0,2
    80006132:	ffffd097          	auipc	ra,0xffffd
    80006136:	634080e7          	jalr	1588(ra) # 80003766 <argint>
    return -1;
    8000613a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000613c:	02054763          	bltz	a0,8000616a <sys_write+0x5c>
    80006140:	fd840593          	addi	a1,s0,-40
    80006144:	4505                	li	a0,1
    80006146:	ffffd097          	auipc	ra,0xffffd
    8000614a:	642080e7          	jalr	1602(ra) # 80003788 <argaddr>
    return -1;
    8000614e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006150:	00054d63          	bltz	a0,8000616a <sys_write+0x5c>
  return filewrite(f, p, n);
    80006154:	fe442603          	lw	a2,-28(s0)
    80006158:	fd843583          	ld	a1,-40(s0)
    8000615c:	fe843503          	ld	a0,-24(s0)
    80006160:	fffff097          	auipc	ra,0xfffff
    80006164:	484080e7          	jalr	1156(ra) # 800055e4 <filewrite>
    80006168:	87aa                	mv	a5,a0
}
    8000616a:	853e                	mv	a0,a5
    8000616c:	70a2                	ld	ra,40(sp)
    8000616e:	7402                	ld	s0,32(sp)
    80006170:	6145                	addi	sp,sp,48
    80006172:	8082                	ret

0000000080006174 <sys_close>:
{
    80006174:	1101                	addi	sp,sp,-32
    80006176:	ec06                	sd	ra,24(sp)
    80006178:	e822                	sd	s0,16(sp)
    8000617a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000617c:	fe040613          	addi	a2,s0,-32
    80006180:	fec40593          	addi	a1,s0,-20
    80006184:	4501                	li	a0,0
    80006186:	00000097          	auipc	ra,0x0
    8000618a:	cc0080e7          	jalr	-832(ra) # 80005e46 <argfd>
    return -1;
    8000618e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80006190:	02054563          	bltz	a0,800061ba <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    80006194:	ffffc097          	auipc	ra,0xffffc
    80006198:	864080e7          	jalr	-1948(ra) # 800019f8 <myproc>
    8000619c:	fec42783          	lw	a5,-20(s0)
    800061a0:	1e878793          	addi	a5,a5,488
    800061a4:	078e                	slli	a5,a5,0x3
    800061a6:	97aa                	add	a5,a5,a0
    800061a8:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    800061ac:	fe043503          	ld	a0,-32(s0)
    800061b0:	fffff097          	auipc	ra,0xfffff
    800061b4:	234080e7          	jalr	564(ra) # 800053e4 <fileclose>
  return 0;
    800061b8:	4781                	li	a5,0
}
    800061ba:	853e                	mv	a0,a5
    800061bc:	60e2                	ld	ra,24(sp)
    800061be:	6442                	ld	s0,16(sp)
    800061c0:	6105                	addi	sp,sp,32
    800061c2:	8082                	ret

00000000800061c4 <sys_fstat>:
{
    800061c4:	1101                	addi	sp,sp,-32
    800061c6:	ec06                	sd	ra,24(sp)
    800061c8:	e822                	sd	s0,16(sp)
    800061ca:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800061cc:	fe840613          	addi	a2,s0,-24
    800061d0:	4581                	li	a1,0
    800061d2:	4501                	li	a0,0
    800061d4:	00000097          	auipc	ra,0x0
    800061d8:	c72080e7          	jalr	-910(ra) # 80005e46 <argfd>
    return -1;
    800061dc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800061de:	02054563          	bltz	a0,80006208 <sys_fstat+0x44>
    800061e2:	fe040593          	addi	a1,s0,-32
    800061e6:	4505                	li	a0,1
    800061e8:	ffffd097          	auipc	ra,0xffffd
    800061ec:	5a0080e7          	jalr	1440(ra) # 80003788 <argaddr>
    return -1;
    800061f0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800061f2:	00054b63          	bltz	a0,80006208 <sys_fstat+0x44>
  return filestat(f, st);
    800061f6:	fe043583          	ld	a1,-32(s0)
    800061fa:	fe843503          	ld	a0,-24(s0)
    800061fe:	fffff097          	auipc	ra,0xfffff
    80006202:	2ae080e7          	jalr	686(ra) # 800054ac <filestat>
    80006206:	87aa                	mv	a5,a0
}
    80006208:	853e                	mv	a0,a5
    8000620a:	60e2                	ld	ra,24(sp)
    8000620c:	6442                	ld	s0,16(sp)
    8000620e:	6105                	addi	sp,sp,32
    80006210:	8082                	ret

0000000080006212 <sys_link>:
{
    80006212:	7169                	addi	sp,sp,-304
    80006214:	f606                	sd	ra,296(sp)
    80006216:	f222                	sd	s0,288(sp)
    80006218:	ee26                	sd	s1,280(sp)
    8000621a:	ea4a                	sd	s2,272(sp)
    8000621c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000621e:	08000613          	li	a2,128
    80006222:	ed040593          	addi	a1,s0,-304
    80006226:	4501                	li	a0,0
    80006228:	ffffd097          	auipc	ra,0xffffd
    8000622c:	582080e7          	jalr	1410(ra) # 800037aa <argstr>
    return -1;
    80006230:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80006232:	10054e63          	bltz	a0,8000634e <sys_link+0x13c>
    80006236:	08000613          	li	a2,128
    8000623a:	f5040593          	addi	a1,s0,-176
    8000623e:	4505                	li	a0,1
    80006240:	ffffd097          	auipc	ra,0xffffd
    80006244:	56a080e7          	jalr	1386(ra) # 800037aa <argstr>
    return -1;
    80006248:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000624a:	10054263          	bltz	a0,8000634e <sys_link+0x13c>
  begin_op();
    8000624e:	fffff097          	auipc	ra,0xfffff
    80006252:	cca080e7          	jalr	-822(ra) # 80004f18 <begin_op>
  if((ip = namei(old)) == 0){
    80006256:	ed040513          	addi	a0,s0,-304
    8000625a:	fffff097          	auipc	ra,0xfffff
    8000625e:	a9e080e7          	jalr	-1378(ra) # 80004cf8 <namei>
    80006262:	84aa                	mv	s1,a0
    80006264:	c551                	beqz	a0,800062f0 <sys_link+0xde>
  ilock(ip);
    80006266:	ffffe097          	auipc	ra,0xffffe
    8000626a:	2d8080e7          	jalr	728(ra) # 8000453e <ilock>
  if(ip->type == T_DIR){
    8000626e:	04449703          	lh	a4,68(s1)
    80006272:	4785                	li	a5,1
    80006274:	08f70463          	beq	a4,a5,800062fc <sys_link+0xea>
  ip->nlink++;
    80006278:	04a4d783          	lhu	a5,74(s1)
    8000627c:	2785                	addiw	a5,a5,1
    8000627e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80006282:	8526                	mv	a0,s1
    80006284:	ffffe097          	auipc	ra,0xffffe
    80006288:	1f0080e7          	jalr	496(ra) # 80004474 <iupdate>
  iunlock(ip);
    8000628c:	8526                	mv	a0,s1
    8000628e:	ffffe097          	auipc	ra,0xffffe
    80006292:	372080e7          	jalr	882(ra) # 80004600 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80006296:	fd040593          	addi	a1,s0,-48
    8000629a:	f5040513          	addi	a0,s0,-176
    8000629e:	fffff097          	auipc	ra,0xfffff
    800062a2:	a78080e7          	jalr	-1416(ra) # 80004d16 <nameiparent>
    800062a6:	892a                	mv	s2,a0
    800062a8:	c935                	beqz	a0,8000631c <sys_link+0x10a>
  ilock(dp);
    800062aa:	ffffe097          	auipc	ra,0xffffe
    800062ae:	294080e7          	jalr	660(ra) # 8000453e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800062b2:	00092703          	lw	a4,0(s2)
    800062b6:	409c                	lw	a5,0(s1)
    800062b8:	04f71d63          	bne	a4,a5,80006312 <sys_link+0x100>
    800062bc:	40d0                	lw	a2,4(s1)
    800062be:	fd040593          	addi	a1,s0,-48
    800062c2:	854a                	mv	a0,s2
    800062c4:	fffff097          	auipc	ra,0xfffff
    800062c8:	972080e7          	jalr	-1678(ra) # 80004c36 <dirlink>
    800062cc:	04054363          	bltz	a0,80006312 <sys_link+0x100>
  iunlockput(dp);
    800062d0:	854a                	mv	a0,s2
    800062d2:	ffffe097          	auipc	ra,0xffffe
    800062d6:	4ce080e7          	jalr	1230(ra) # 800047a0 <iunlockput>
  iput(ip);
    800062da:	8526                	mv	a0,s1
    800062dc:	ffffe097          	auipc	ra,0xffffe
    800062e0:	41c080e7          	jalr	1052(ra) # 800046f8 <iput>
  end_op();
    800062e4:	fffff097          	auipc	ra,0xfffff
    800062e8:	cb4080e7          	jalr	-844(ra) # 80004f98 <end_op>
  return 0;
    800062ec:	4781                	li	a5,0
    800062ee:	a085                	j	8000634e <sys_link+0x13c>
    end_op();
    800062f0:	fffff097          	auipc	ra,0xfffff
    800062f4:	ca8080e7          	jalr	-856(ra) # 80004f98 <end_op>
    return -1;
    800062f8:	57fd                	li	a5,-1
    800062fa:	a891                	j	8000634e <sys_link+0x13c>
    iunlockput(ip);
    800062fc:	8526                	mv	a0,s1
    800062fe:	ffffe097          	auipc	ra,0xffffe
    80006302:	4a2080e7          	jalr	1186(ra) # 800047a0 <iunlockput>
    end_op();
    80006306:	fffff097          	auipc	ra,0xfffff
    8000630a:	c92080e7          	jalr	-878(ra) # 80004f98 <end_op>
    return -1;
    8000630e:	57fd                	li	a5,-1
    80006310:	a83d                	j	8000634e <sys_link+0x13c>
    iunlockput(dp);
    80006312:	854a                	mv	a0,s2
    80006314:	ffffe097          	auipc	ra,0xffffe
    80006318:	48c080e7          	jalr	1164(ra) # 800047a0 <iunlockput>
  ilock(ip);
    8000631c:	8526                	mv	a0,s1
    8000631e:	ffffe097          	auipc	ra,0xffffe
    80006322:	220080e7          	jalr	544(ra) # 8000453e <ilock>
  ip->nlink--;
    80006326:	04a4d783          	lhu	a5,74(s1)
    8000632a:	37fd                	addiw	a5,a5,-1
    8000632c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80006330:	8526                	mv	a0,s1
    80006332:	ffffe097          	auipc	ra,0xffffe
    80006336:	142080e7          	jalr	322(ra) # 80004474 <iupdate>
  iunlockput(ip);
    8000633a:	8526                	mv	a0,s1
    8000633c:	ffffe097          	auipc	ra,0xffffe
    80006340:	464080e7          	jalr	1124(ra) # 800047a0 <iunlockput>
  end_op();
    80006344:	fffff097          	auipc	ra,0xfffff
    80006348:	c54080e7          	jalr	-940(ra) # 80004f98 <end_op>
  return -1;
    8000634c:	57fd                	li	a5,-1
}
    8000634e:	853e                	mv	a0,a5
    80006350:	70b2                	ld	ra,296(sp)
    80006352:	7412                	ld	s0,288(sp)
    80006354:	64f2                	ld	s1,280(sp)
    80006356:	6952                	ld	s2,272(sp)
    80006358:	6155                	addi	sp,sp,304
    8000635a:	8082                	ret

000000008000635c <sys_unlink>:
{
    8000635c:	7151                	addi	sp,sp,-240
    8000635e:	f586                	sd	ra,232(sp)
    80006360:	f1a2                	sd	s0,224(sp)
    80006362:	eda6                	sd	s1,216(sp)
    80006364:	e9ca                	sd	s2,208(sp)
    80006366:	e5ce                	sd	s3,200(sp)
    80006368:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000636a:	08000613          	li	a2,128
    8000636e:	f3040593          	addi	a1,s0,-208
    80006372:	4501                	li	a0,0
    80006374:	ffffd097          	auipc	ra,0xffffd
    80006378:	436080e7          	jalr	1078(ra) # 800037aa <argstr>
    8000637c:	18054163          	bltz	a0,800064fe <sys_unlink+0x1a2>
  begin_op();
    80006380:	fffff097          	auipc	ra,0xfffff
    80006384:	b98080e7          	jalr	-1128(ra) # 80004f18 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80006388:	fb040593          	addi	a1,s0,-80
    8000638c:	f3040513          	addi	a0,s0,-208
    80006390:	fffff097          	auipc	ra,0xfffff
    80006394:	986080e7          	jalr	-1658(ra) # 80004d16 <nameiparent>
    80006398:	84aa                	mv	s1,a0
    8000639a:	c979                	beqz	a0,80006470 <sys_unlink+0x114>
  ilock(dp);
    8000639c:	ffffe097          	auipc	ra,0xffffe
    800063a0:	1a2080e7          	jalr	418(ra) # 8000453e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800063a4:	00003597          	auipc	a1,0x3
    800063a8:	46458593          	addi	a1,a1,1124 # 80009808 <syscalls+0x330>
    800063ac:	fb040513          	addi	a0,s0,-80
    800063b0:	ffffe097          	auipc	ra,0xffffe
    800063b4:	658080e7          	jalr	1624(ra) # 80004a08 <namecmp>
    800063b8:	14050a63          	beqz	a0,8000650c <sys_unlink+0x1b0>
    800063bc:	00003597          	auipc	a1,0x3
    800063c0:	45458593          	addi	a1,a1,1108 # 80009810 <syscalls+0x338>
    800063c4:	fb040513          	addi	a0,s0,-80
    800063c8:	ffffe097          	auipc	ra,0xffffe
    800063cc:	640080e7          	jalr	1600(ra) # 80004a08 <namecmp>
    800063d0:	12050e63          	beqz	a0,8000650c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800063d4:	f2c40613          	addi	a2,s0,-212
    800063d8:	fb040593          	addi	a1,s0,-80
    800063dc:	8526                	mv	a0,s1
    800063de:	ffffe097          	auipc	ra,0xffffe
    800063e2:	644080e7          	jalr	1604(ra) # 80004a22 <dirlookup>
    800063e6:	892a                	mv	s2,a0
    800063e8:	12050263          	beqz	a0,8000650c <sys_unlink+0x1b0>
  ilock(ip);
    800063ec:	ffffe097          	auipc	ra,0xffffe
    800063f0:	152080e7          	jalr	338(ra) # 8000453e <ilock>
  if(ip->nlink < 1)
    800063f4:	04a91783          	lh	a5,74(s2)
    800063f8:	08f05263          	blez	a5,8000647c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800063fc:	04491703          	lh	a4,68(s2)
    80006400:	4785                	li	a5,1
    80006402:	08f70563          	beq	a4,a5,8000648c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80006406:	4641                	li	a2,16
    80006408:	4581                	li	a1,0
    8000640a:	fc040513          	addi	a0,s0,-64
    8000640e:	ffffb097          	auipc	ra,0xffffb
    80006412:	8be080e7          	jalr	-1858(ra) # 80000ccc <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80006416:	4741                	li	a4,16
    80006418:	f2c42683          	lw	a3,-212(s0)
    8000641c:	fc040613          	addi	a2,s0,-64
    80006420:	4581                	li	a1,0
    80006422:	8526                	mv	a0,s1
    80006424:	ffffe097          	auipc	ra,0xffffe
    80006428:	4c6080e7          	jalr	1222(ra) # 800048ea <writei>
    8000642c:	47c1                	li	a5,16
    8000642e:	0af51563          	bne	a0,a5,800064d8 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80006432:	04491703          	lh	a4,68(s2)
    80006436:	4785                	li	a5,1
    80006438:	0af70863          	beq	a4,a5,800064e8 <sys_unlink+0x18c>
  iunlockput(dp);
    8000643c:	8526                	mv	a0,s1
    8000643e:	ffffe097          	auipc	ra,0xffffe
    80006442:	362080e7          	jalr	866(ra) # 800047a0 <iunlockput>
  ip->nlink--;
    80006446:	04a95783          	lhu	a5,74(s2)
    8000644a:	37fd                	addiw	a5,a5,-1
    8000644c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80006450:	854a                	mv	a0,s2
    80006452:	ffffe097          	auipc	ra,0xffffe
    80006456:	022080e7          	jalr	34(ra) # 80004474 <iupdate>
  iunlockput(ip);
    8000645a:	854a                	mv	a0,s2
    8000645c:	ffffe097          	auipc	ra,0xffffe
    80006460:	344080e7          	jalr	836(ra) # 800047a0 <iunlockput>
  end_op();
    80006464:	fffff097          	auipc	ra,0xfffff
    80006468:	b34080e7          	jalr	-1228(ra) # 80004f98 <end_op>
  return 0;
    8000646c:	4501                	li	a0,0
    8000646e:	a84d                	j	80006520 <sys_unlink+0x1c4>
    end_op();
    80006470:	fffff097          	auipc	ra,0xfffff
    80006474:	b28080e7          	jalr	-1240(ra) # 80004f98 <end_op>
    return -1;
    80006478:	557d                	li	a0,-1
    8000647a:	a05d                	j	80006520 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000647c:	00003517          	auipc	a0,0x3
    80006480:	3bc50513          	addi	a0,a0,956 # 80009838 <syscalls+0x360>
    80006484:	ffffa097          	auipc	ra,0xffffa
    80006488:	0a6080e7          	jalr	166(ra) # 8000052a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000648c:	04c92703          	lw	a4,76(s2)
    80006490:	02000793          	li	a5,32
    80006494:	f6e7f9e3          	bgeu	a5,a4,80006406 <sys_unlink+0xaa>
    80006498:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000649c:	4741                	li	a4,16
    8000649e:	86ce                	mv	a3,s3
    800064a0:	f1840613          	addi	a2,s0,-232
    800064a4:	4581                	li	a1,0
    800064a6:	854a                	mv	a0,s2
    800064a8:	ffffe097          	auipc	ra,0xffffe
    800064ac:	34a080e7          	jalr	842(ra) # 800047f2 <readi>
    800064b0:	47c1                	li	a5,16
    800064b2:	00f51b63          	bne	a0,a5,800064c8 <sys_unlink+0x16c>
    if(de.inum != 0)
    800064b6:	f1845783          	lhu	a5,-232(s0)
    800064ba:	e7a1                	bnez	a5,80006502 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800064bc:	29c1                	addiw	s3,s3,16
    800064be:	04c92783          	lw	a5,76(s2)
    800064c2:	fcf9ede3          	bltu	s3,a5,8000649c <sys_unlink+0x140>
    800064c6:	b781                	j	80006406 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800064c8:	00003517          	auipc	a0,0x3
    800064cc:	38850513          	addi	a0,a0,904 # 80009850 <syscalls+0x378>
    800064d0:	ffffa097          	auipc	ra,0xffffa
    800064d4:	05a080e7          	jalr	90(ra) # 8000052a <panic>
    panic("unlink: writei");
    800064d8:	00003517          	auipc	a0,0x3
    800064dc:	39050513          	addi	a0,a0,912 # 80009868 <syscalls+0x390>
    800064e0:	ffffa097          	auipc	ra,0xffffa
    800064e4:	04a080e7          	jalr	74(ra) # 8000052a <panic>
    dp->nlink--;
    800064e8:	04a4d783          	lhu	a5,74(s1)
    800064ec:	37fd                	addiw	a5,a5,-1
    800064ee:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800064f2:	8526                	mv	a0,s1
    800064f4:	ffffe097          	auipc	ra,0xffffe
    800064f8:	f80080e7          	jalr	-128(ra) # 80004474 <iupdate>
    800064fc:	b781                	j	8000643c <sys_unlink+0xe0>
    return -1;
    800064fe:	557d                	li	a0,-1
    80006500:	a005                	j	80006520 <sys_unlink+0x1c4>
    iunlockput(ip);
    80006502:	854a                	mv	a0,s2
    80006504:	ffffe097          	auipc	ra,0xffffe
    80006508:	29c080e7          	jalr	668(ra) # 800047a0 <iunlockput>
  iunlockput(dp);
    8000650c:	8526                	mv	a0,s1
    8000650e:	ffffe097          	auipc	ra,0xffffe
    80006512:	292080e7          	jalr	658(ra) # 800047a0 <iunlockput>
  end_op();
    80006516:	fffff097          	auipc	ra,0xfffff
    8000651a:	a82080e7          	jalr	-1406(ra) # 80004f98 <end_op>
  return -1;
    8000651e:	557d                	li	a0,-1
}
    80006520:	70ae                	ld	ra,232(sp)
    80006522:	740e                	ld	s0,224(sp)
    80006524:	64ee                	ld	s1,216(sp)
    80006526:	694e                	ld	s2,208(sp)
    80006528:	69ae                	ld	s3,200(sp)
    8000652a:	616d                	addi	sp,sp,240
    8000652c:	8082                	ret

000000008000652e <sys_open>:

uint64
sys_open(void)
{
    8000652e:	7131                	addi	sp,sp,-192
    80006530:	fd06                	sd	ra,184(sp)
    80006532:	f922                	sd	s0,176(sp)
    80006534:	f526                	sd	s1,168(sp)
    80006536:	f14a                	sd	s2,160(sp)
    80006538:	ed4e                	sd	s3,152(sp)
    8000653a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000653c:	08000613          	li	a2,128
    80006540:	f5040593          	addi	a1,s0,-176
    80006544:	4501                	li	a0,0
    80006546:	ffffd097          	auipc	ra,0xffffd
    8000654a:	264080e7          	jalr	612(ra) # 800037aa <argstr>
    return -1;
    8000654e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80006550:	0c054163          	bltz	a0,80006612 <sys_open+0xe4>
    80006554:	f4c40593          	addi	a1,s0,-180
    80006558:	4505                	li	a0,1
    8000655a:	ffffd097          	auipc	ra,0xffffd
    8000655e:	20c080e7          	jalr	524(ra) # 80003766 <argint>
    80006562:	0a054863          	bltz	a0,80006612 <sys_open+0xe4>

  begin_op();
    80006566:	fffff097          	auipc	ra,0xfffff
    8000656a:	9b2080e7          	jalr	-1614(ra) # 80004f18 <begin_op>

  if(omode & O_CREATE){
    8000656e:	f4c42783          	lw	a5,-180(s0)
    80006572:	2007f793          	andi	a5,a5,512
    80006576:	cbdd                	beqz	a5,8000662c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80006578:	4681                	li	a3,0
    8000657a:	4601                	li	a2,0
    8000657c:	4589                	li	a1,2
    8000657e:	f5040513          	addi	a0,s0,-176
    80006582:	00000097          	auipc	ra,0x0
    80006586:	972080e7          	jalr	-1678(ra) # 80005ef4 <create>
    8000658a:	892a                	mv	s2,a0
    if(ip == 0){
    8000658c:	c959                	beqz	a0,80006622 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000658e:	04491703          	lh	a4,68(s2)
    80006592:	478d                	li	a5,3
    80006594:	00f71763          	bne	a4,a5,800065a2 <sys_open+0x74>
    80006598:	04695703          	lhu	a4,70(s2)
    8000659c:	47a5                	li	a5,9
    8000659e:	0ce7ec63          	bltu	a5,a4,80006676 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800065a2:	fffff097          	auipc	ra,0xfffff
    800065a6:	d86080e7          	jalr	-634(ra) # 80005328 <filealloc>
    800065aa:	89aa                	mv	s3,a0
    800065ac:	10050263          	beqz	a0,800066b0 <sys_open+0x182>
    800065b0:	00000097          	auipc	ra,0x0
    800065b4:	8fe080e7          	jalr	-1794(ra) # 80005eae <fdalloc>
    800065b8:	84aa                	mv	s1,a0
    800065ba:	0e054663          	bltz	a0,800066a6 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800065be:	04491703          	lh	a4,68(s2)
    800065c2:	478d                	li	a5,3
    800065c4:	0cf70463          	beq	a4,a5,8000668c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800065c8:	4789                	li	a5,2
    800065ca:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800065ce:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800065d2:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    800065d6:	f4c42783          	lw	a5,-180(s0)
    800065da:	0017c713          	xori	a4,a5,1
    800065de:	8b05                	andi	a4,a4,1
    800065e0:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800065e4:	0037f713          	andi	a4,a5,3
    800065e8:	00e03733          	snez	a4,a4
    800065ec:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800065f0:	4007f793          	andi	a5,a5,1024
    800065f4:	c791                	beqz	a5,80006600 <sys_open+0xd2>
    800065f6:	04491703          	lh	a4,68(s2)
    800065fa:	4789                	li	a5,2
    800065fc:	08f70f63          	beq	a4,a5,8000669a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80006600:	854a                	mv	a0,s2
    80006602:	ffffe097          	auipc	ra,0xffffe
    80006606:	ffe080e7          	jalr	-2(ra) # 80004600 <iunlock>
  end_op();
    8000660a:	fffff097          	auipc	ra,0xfffff
    8000660e:	98e080e7          	jalr	-1650(ra) # 80004f98 <end_op>

  return fd;
}
    80006612:	8526                	mv	a0,s1
    80006614:	70ea                	ld	ra,184(sp)
    80006616:	744a                	ld	s0,176(sp)
    80006618:	74aa                	ld	s1,168(sp)
    8000661a:	790a                	ld	s2,160(sp)
    8000661c:	69ea                	ld	s3,152(sp)
    8000661e:	6129                	addi	sp,sp,192
    80006620:	8082                	ret
      end_op();
    80006622:	fffff097          	auipc	ra,0xfffff
    80006626:	976080e7          	jalr	-1674(ra) # 80004f98 <end_op>
      return -1;
    8000662a:	b7e5                	j	80006612 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    8000662c:	f5040513          	addi	a0,s0,-176
    80006630:	ffffe097          	auipc	ra,0xffffe
    80006634:	6c8080e7          	jalr	1736(ra) # 80004cf8 <namei>
    80006638:	892a                	mv	s2,a0
    8000663a:	c905                	beqz	a0,8000666a <sys_open+0x13c>
    ilock(ip);
    8000663c:	ffffe097          	auipc	ra,0xffffe
    80006640:	f02080e7          	jalr	-254(ra) # 8000453e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80006644:	04491703          	lh	a4,68(s2)
    80006648:	4785                	li	a5,1
    8000664a:	f4f712e3          	bne	a4,a5,8000658e <sys_open+0x60>
    8000664e:	f4c42783          	lw	a5,-180(s0)
    80006652:	dba1                	beqz	a5,800065a2 <sys_open+0x74>
      iunlockput(ip);
    80006654:	854a                	mv	a0,s2
    80006656:	ffffe097          	auipc	ra,0xffffe
    8000665a:	14a080e7          	jalr	330(ra) # 800047a0 <iunlockput>
      end_op();
    8000665e:	fffff097          	auipc	ra,0xfffff
    80006662:	93a080e7          	jalr	-1734(ra) # 80004f98 <end_op>
      return -1;
    80006666:	54fd                	li	s1,-1
    80006668:	b76d                	j	80006612 <sys_open+0xe4>
      end_op();
    8000666a:	fffff097          	auipc	ra,0xfffff
    8000666e:	92e080e7          	jalr	-1746(ra) # 80004f98 <end_op>
      return -1;
    80006672:	54fd                	li	s1,-1
    80006674:	bf79                	j	80006612 <sys_open+0xe4>
    iunlockput(ip);
    80006676:	854a                	mv	a0,s2
    80006678:	ffffe097          	auipc	ra,0xffffe
    8000667c:	128080e7          	jalr	296(ra) # 800047a0 <iunlockput>
    end_op();
    80006680:	fffff097          	auipc	ra,0xfffff
    80006684:	918080e7          	jalr	-1768(ra) # 80004f98 <end_op>
    return -1;
    80006688:	54fd                	li	s1,-1
    8000668a:	b761                	j	80006612 <sys_open+0xe4>
    f->type = FD_DEVICE;
    8000668c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80006690:	04691783          	lh	a5,70(s2)
    80006694:	02f99223          	sh	a5,36(s3)
    80006698:	bf2d                	j	800065d2 <sys_open+0xa4>
    itrunc(ip);
    8000669a:	854a                	mv	a0,s2
    8000669c:	ffffe097          	auipc	ra,0xffffe
    800066a0:	fb0080e7          	jalr	-80(ra) # 8000464c <itrunc>
    800066a4:	bfb1                	j	80006600 <sys_open+0xd2>
      fileclose(f);
    800066a6:	854e                	mv	a0,s3
    800066a8:	fffff097          	auipc	ra,0xfffff
    800066ac:	d3c080e7          	jalr	-708(ra) # 800053e4 <fileclose>
    iunlockput(ip);
    800066b0:	854a                	mv	a0,s2
    800066b2:	ffffe097          	auipc	ra,0xffffe
    800066b6:	0ee080e7          	jalr	238(ra) # 800047a0 <iunlockput>
    end_op();
    800066ba:	fffff097          	auipc	ra,0xfffff
    800066be:	8de080e7          	jalr	-1826(ra) # 80004f98 <end_op>
    return -1;
    800066c2:	54fd                	li	s1,-1
    800066c4:	b7b9                	j	80006612 <sys_open+0xe4>

00000000800066c6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800066c6:	7175                	addi	sp,sp,-144
    800066c8:	e506                	sd	ra,136(sp)
    800066ca:	e122                	sd	s0,128(sp)
    800066cc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800066ce:	fffff097          	auipc	ra,0xfffff
    800066d2:	84a080e7          	jalr	-1974(ra) # 80004f18 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800066d6:	08000613          	li	a2,128
    800066da:	f7040593          	addi	a1,s0,-144
    800066de:	4501                	li	a0,0
    800066e0:	ffffd097          	auipc	ra,0xffffd
    800066e4:	0ca080e7          	jalr	202(ra) # 800037aa <argstr>
    800066e8:	02054963          	bltz	a0,8000671a <sys_mkdir+0x54>
    800066ec:	4681                	li	a3,0
    800066ee:	4601                	li	a2,0
    800066f0:	4585                	li	a1,1
    800066f2:	f7040513          	addi	a0,s0,-144
    800066f6:	fffff097          	auipc	ra,0xfffff
    800066fa:	7fe080e7          	jalr	2046(ra) # 80005ef4 <create>
    800066fe:	cd11                	beqz	a0,8000671a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006700:	ffffe097          	auipc	ra,0xffffe
    80006704:	0a0080e7          	jalr	160(ra) # 800047a0 <iunlockput>
  end_op();
    80006708:	fffff097          	auipc	ra,0xfffff
    8000670c:	890080e7          	jalr	-1904(ra) # 80004f98 <end_op>
  return 0;
    80006710:	4501                	li	a0,0
}
    80006712:	60aa                	ld	ra,136(sp)
    80006714:	640a                	ld	s0,128(sp)
    80006716:	6149                	addi	sp,sp,144
    80006718:	8082                	ret
    end_op();
    8000671a:	fffff097          	auipc	ra,0xfffff
    8000671e:	87e080e7          	jalr	-1922(ra) # 80004f98 <end_op>
    return -1;
    80006722:	557d                	li	a0,-1
    80006724:	b7fd                	j	80006712 <sys_mkdir+0x4c>

0000000080006726 <sys_mknod>:

uint64
sys_mknod(void)
{
    80006726:	7135                	addi	sp,sp,-160
    80006728:	ed06                	sd	ra,152(sp)
    8000672a:	e922                	sd	s0,144(sp)
    8000672c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000672e:	ffffe097          	auipc	ra,0xffffe
    80006732:	7ea080e7          	jalr	2026(ra) # 80004f18 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006736:	08000613          	li	a2,128
    8000673a:	f7040593          	addi	a1,s0,-144
    8000673e:	4501                	li	a0,0
    80006740:	ffffd097          	auipc	ra,0xffffd
    80006744:	06a080e7          	jalr	106(ra) # 800037aa <argstr>
    80006748:	04054a63          	bltz	a0,8000679c <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    8000674c:	f6c40593          	addi	a1,s0,-148
    80006750:	4505                	li	a0,1
    80006752:	ffffd097          	auipc	ra,0xffffd
    80006756:	014080e7          	jalr	20(ra) # 80003766 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000675a:	04054163          	bltz	a0,8000679c <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    8000675e:	f6840593          	addi	a1,s0,-152
    80006762:	4509                	li	a0,2
    80006764:	ffffd097          	auipc	ra,0xffffd
    80006768:	002080e7          	jalr	2(ra) # 80003766 <argint>
     argint(1, &major) < 0 ||
    8000676c:	02054863          	bltz	a0,8000679c <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80006770:	f6841683          	lh	a3,-152(s0)
    80006774:	f6c41603          	lh	a2,-148(s0)
    80006778:	458d                	li	a1,3
    8000677a:	f7040513          	addi	a0,s0,-144
    8000677e:	fffff097          	auipc	ra,0xfffff
    80006782:	776080e7          	jalr	1910(ra) # 80005ef4 <create>
     argint(2, &minor) < 0 ||
    80006786:	c919                	beqz	a0,8000679c <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006788:	ffffe097          	auipc	ra,0xffffe
    8000678c:	018080e7          	jalr	24(ra) # 800047a0 <iunlockput>
  end_op();
    80006790:	fffff097          	auipc	ra,0xfffff
    80006794:	808080e7          	jalr	-2040(ra) # 80004f98 <end_op>
  return 0;
    80006798:	4501                	li	a0,0
    8000679a:	a031                	j	800067a6 <sys_mknod+0x80>
    end_op();
    8000679c:	ffffe097          	auipc	ra,0xffffe
    800067a0:	7fc080e7          	jalr	2044(ra) # 80004f98 <end_op>
    return -1;
    800067a4:	557d                	li	a0,-1
}
    800067a6:	60ea                	ld	ra,152(sp)
    800067a8:	644a                	ld	s0,144(sp)
    800067aa:	610d                	addi	sp,sp,160
    800067ac:	8082                	ret

00000000800067ae <sys_chdir>:

uint64
sys_chdir(void)
{
    800067ae:	7135                	addi	sp,sp,-160
    800067b0:	ed06                	sd	ra,152(sp)
    800067b2:	e922                	sd	s0,144(sp)
    800067b4:	e526                	sd	s1,136(sp)
    800067b6:	e14a                	sd	s2,128(sp)
    800067b8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800067ba:	ffffb097          	auipc	ra,0xffffb
    800067be:	23e080e7          	jalr	574(ra) # 800019f8 <myproc>
    800067c2:	892a                	mv	s2,a0
  
  begin_op();
    800067c4:	ffffe097          	auipc	ra,0xffffe
    800067c8:	754080e7          	jalr	1876(ra) # 80004f18 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800067cc:	08000613          	li	a2,128
    800067d0:	f6040593          	addi	a1,s0,-160
    800067d4:	4501                	li	a0,0
    800067d6:	ffffd097          	auipc	ra,0xffffd
    800067da:	fd4080e7          	jalr	-44(ra) # 800037aa <argstr>
    800067de:	04054d63          	bltz	a0,80006838 <sys_chdir+0x8a>
    800067e2:	f6040513          	addi	a0,s0,-160
    800067e6:	ffffe097          	auipc	ra,0xffffe
    800067ea:	512080e7          	jalr	1298(ra) # 80004cf8 <namei>
    800067ee:	84aa                	mv	s1,a0
    800067f0:	c521                	beqz	a0,80006838 <sys_chdir+0x8a>
    end_op();
    return -1;
  }
  ilock(ip);
    800067f2:	ffffe097          	auipc	ra,0xffffe
    800067f6:	d4c080e7          	jalr	-692(ra) # 8000453e <ilock>
  if(ip->type != T_DIR){
    800067fa:	04449703          	lh	a4,68(s1)
    800067fe:	4785                	li	a5,1
    80006800:	04f71263          	bne	a4,a5,80006844 <sys_chdir+0x96>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80006804:	8526                	mv	a0,s1
    80006806:	ffffe097          	auipc	ra,0xffffe
    8000680a:	dfa080e7          	jalr	-518(ra) # 80004600 <iunlock>
  iput(p->cwd);
    8000680e:	6505                	lui	a0,0x1
    80006810:	992a                	add	s2,s2,a0
    80006812:	fc893503          	ld	a0,-56(s2)
    80006816:	ffffe097          	auipc	ra,0xffffe
    8000681a:	ee2080e7          	jalr	-286(ra) # 800046f8 <iput>
  end_op();
    8000681e:	ffffe097          	auipc	ra,0xffffe
    80006822:	77a080e7          	jalr	1914(ra) # 80004f98 <end_op>
  p->cwd = ip;
    80006826:	fc993423          	sd	s1,-56(s2)
  return 0;
    8000682a:	4501                	li	a0,0
}
    8000682c:	60ea                	ld	ra,152(sp)
    8000682e:	644a                	ld	s0,144(sp)
    80006830:	64aa                	ld	s1,136(sp)
    80006832:	690a                	ld	s2,128(sp)
    80006834:	610d                	addi	sp,sp,160
    80006836:	8082                	ret
    end_op();
    80006838:	ffffe097          	auipc	ra,0xffffe
    8000683c:	760080e7          	jalr	1888(ra) # 80004f98 <end_op>
    return -1;
    80006840:	557d                	li	a0,-1
    80006842:	b7ed                	j	8000682c <sys_chdir+0x7e>
    iunlockput(ip);
    80006844:	8526                	mv	a0,s1
    80006846:	ffffe097          	auipc	ra,0xffffe
    8000684a:	f5a080e7          	jalr	-166(ra) # 800047a0 <iunlockput>
    end_op();
    8000684e:	ffffe097          	auipc	ra,0xffffe
    80006852:	74a080e7          	jalr	1866(ra) # 80004f98 <end_op>
    return -1;
    80006856:	557d                	li	a0,-1
    80006858:	bfd1                	j	8000682c <sys_chdir+0x7e>

000000008000685a <sys_exec>:

uint64
sys_exec(void)
{
    8000685a:	7145                	addi	sp,sp,-464
    8000685c:	e786                	sd	ra,456(sp)
    8000685e:	e3a2                	sd	s0,448(sp)
    80006860:	ff26                	sd	s1,440(sp)
    80006862:	fb4a                	sd	s2,432(sp)
    80006864:	f74e                	sd	s3,424(sp)
    80006866:	f352                	sd	s4,416(sp)
    80006868:	ef56                	sd	s5,408(sp)
    8000686a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000686c:	08000613          	li	a2,128
    80006870:	f4040593          	addi	a1,s0,-192
    80006874:	4501                	li	a0,0
    80006876:	ffffd097          	auipc	ra,0xffffd
    8000687a:	f34080e7          	jalr	-204(ra) # 800037aa <argstr>
    return -1;
    8000687e:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80006880:	0c054a63          	bltz	a0,80006954 <sys_exec+0xfa>
    80006884:	e3840593          	addi	a1,s0,-456
    80006888:	4505                	li	a0,1
    8000688a:	ffffd097          	auipc	ra,0xffffd
    8000688e:	efe080e7          	jalr	-258(ra) # 80003788 <argaddr>
    80006892:	0c054163          	bltz	a0,80006954 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80006896:	10000613          	li	a2,256
    8000689a:	4581                	li	a1,0
    8000689c:	e4040513          	addi	a0,s0,-448
    800068a0:	ffffa097          	auipc	ra,0xffffa
    800068a4:	42c080e7          	jalr	1068(ra) # 80000ccc <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800068a8:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800068ac:	89a6                	mv	s3,s1
    800068ae:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800068b0:	02000a13          	li	s4,32
    800068b4:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800068b8:	00391793          	slli	a5,s2,0x3
    800068bc:	e3040593          	addi	a1,s0,-464
    800068c0:	e3843503          	ld	a0,-456(s0)
    800068c4:	953e                	add	a0,a0,a5
    800068c6:	ffffd097          	auipc	ra,0xffffd
    800068ca:	df4080e7          	jalr	-524(ra) # 800036ba <fetchaddr>
    800068ce:	02054a63          	bltz	a0,80006902 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    800068d2:	e3043783          	ld	a5,-464(s0)
    800068d6:	c3b9                	beqz	a5,8000691c <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800068d8:	ffffa097          	auipc	ra,0xffffa
    800068dc:	1fa080e7          	jalr	506(ra) # 80000ad2 <kalloc>
    800068e0:	85aa                	mv	a1,a0
    800068e2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800068e6:	cd11                	beqz	a0,80006902 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800068e8:	6605                	lui	a2,0x1
    800068ea:	e3043503          	ld	a0,-464(s0)
    800068ee:	ffffd097          	auipc	ra,0xffffd
    800068f2:	e2a080e7          	jalr	-470(ra) # 80003718 <fetchstr>
    800068f6:	00054663          	bltz	a0,80006902 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    800068fa:	0905                	addi	s2,s2,1
    800068fc:	09a1                	addi	s3,s3,8
    800068fe:	fb491be3          	bne	s2,s4,800068b4 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006902:	10048913          	addi	s2,s1,256
    80006906:	6088                	ld	a0,0(s1)
    80006908:	c529                	beqz	a0,80006952 <sys_exec+0xf8>
    kfree(argv[i]);
    8000690a:	ffffa097          	auipc	ra,0xffffa
    8000690e:	0cc080e7          	jalr	204(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006912:	04a1                	addi	s1,s1,8
    80006914:	ff2499e3          	bne	s1,s2,80006906 <sys_exec+0xac>
  return -1;
    80006918:	597d                	li	s2,-1
    8000691a:	a82d                	j	80006954 <sys_exec+0xfa>
      argv[i] = 0;
    8000691c:	0a8e                	slli	s5,s5,0x3
    8000691e:	fc040793          	addi	a5,s0,-64
    80006922:	9abe                	add	s5,s5,a5
    80006924:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80006928:	e4040593          	addi	a1,s0,-448
    8000692c:	f4040513          	addi	a0,s0,-192
    80006930:	fffff097          	auipc	ra,0xfffff
    80006934:	11a080e7          	jalr	282(ra) # 80005a4a <exec>
    80006938:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000693a:	10048993          	addi	s3,s1,256
    8000693e:	6088                	ld	a0,0(s1)
    80006940:	c911                	beqz	a0,80006954 <sys_exec+0xfa>
    kfree(argv[i]);
    80006942:	ffffa097          	auipc	ra,0xffffa
    80006946:	094080e7          	jalr	148(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000694a:	04a1                	addi	s1,s1,8
    8000694c:	ff3499e3          	bne	s1,s3,8000693e <sys_exec+0xe4>
    80006950:	a011                	j	80006954 <sys_exec+0xfa>
  return -1;
    80006952:	597d                	li	s2,-1
}
    80006954:	854a                	mv	a0,s2
    80006956:	60be                	ld	ra,456(sp)
    80006958:	641e                	ld	s0,448(sp)
    8000695a:	74fa                	ld	s1,440(sp)
    8000695c:	795a                	ld	s2,432(sp)
    8000695e:	79ba                	ld	s3,424(sp)
    80006960:	7a1a                	ld	s4,416(sp)
    80006962:	6afa                	ld	s5,408(sp)
    80006964:	6179                	addi	sp,sp,464
    80006966:	8082                	ret

0000000080006968 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006968:	7139                	addi	sp,sp,-64
    8000696a:	fc06                	sd	ra,56(sp)
    8000696c:	f822                	sd	s0,48(sp)
    8000696e:	f426                	sd	s1,40(sp)
    80006970:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006972:	ffffb097          	auipc	ra,0xffffb
    80006976:	086080e7          	jalr	134(ra) # 800019f8 <myproc>
    8000697a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000697c:	fd840593          	addi	a1,s0,-40
    80006980:	4501                	li	a0,0
    80006982:	ffffd097          	auipc	ra,0xffffd
    80006986:	e06080e7          	jalr	-506(ra) # 80003788 <argaddr>
    return -1;
    8000698a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000698c:	0e054863          	bltz	a0,80006a7c <sys_pipe+0x114>
  if(pipealloc(&rf, &wf) < 0)
    80006990:	fc840593          	addi	a1,s0,-56
    80006994:	fd040513          	addi	a0,s0,-48
    80006998:	fffff097          	auipc	ra,0xfffff
    8000699c:	d80080e7          	jalr	-640(ra) # 80005718 <pipealloc>
    return -1;
    800069a0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800069a2:	0c054d63          	bltz	a0,80006a7c <sys_pipe+0x114>
  fd0 = -1;
    800069a6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800069aa:	fd043503          	ld	a0,-48(s0)
    800069ae:	fffff097          	auipc	ra,0xfffff
    800069b2:	500080e7          	jalr	1280(ra) # 80005eae <fdalloc>
    800069b6:	fca42223          	sw	a0,-60(s0)
    800069ba:	0a054463          	bltz	a0,80006a62 <sys_pipe+0xfa>
    800069be:	fc843503          	ld	a0,-56(s0)
    800069c2:	fffff097          	auipc	ra,0xfffff
    800069c6:	4ec080e7          	jalr	1260(ra) # 80005eae <fdalloc>
    800069ca:	fca42023          	sw	a0,-64(s0)
    800069ce:	08054063          	bltz	a0,80006a4e <sys_pipe+0xe6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800069d2:	6785                	lui	a5,0x1
    800069d4:	97a6                	add	a5,a5,s1
    800069d6:	4691                	li	a3,4
    800069d8:	fc440613          	addi	a2,s0,-60
    800069dc:	fd843583          	ld	a1,-40(s0)
    800069e0:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    800069e4:	ffffb097          	auipc	ra,0xffffb
    800069e8:	c68080e7          	jalr	-920(ra) # 8000164c <copyout>
    800069ec:	02054363          	bltz	a0,80006a12 <sys_pipe+0xaa>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800069f0:	6785                	lui	a5,0x1
    800069f2:	97a6                	add	a5,a5,s1
    800069f4:	4691                	li	a3,4
    800069f6:	fc040613          	addi	a2,s0,-64
    800069fa:	fd843583          	ld	a1,-40(s0)
    800069fe:	0591                	addi	a1,a1,4
    80006a00:	f407b503          	ld	a0,-192(a5) # f40 <_entry-0x7ffff0c0>
    80006a04:	ffffb097          	auipc	ra,0xffffb
    80006a08:	c48080e7          	jalr	-952(ra) # 8000164c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006a0c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006a0e:	06055763          	bgez	a0,80006a7c <sys_pipe+0x114>
    p->ofile[fd0] = 0;
    80006a12:	fc442783          	lw	a5,-60(s0)
    80006a16:	1e878793          	addi	a5,a5,488
    80006a1a:	078e                	slli	a5,a5,0x3
    80006a1c:	97a6                	add	a5,a5,s1
    80006a1e:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80006a22:	fc042503          	lw	a0,-64(s0)
    80006a26:	1e850513          	addi	a0,a0,488 # 11e8 <_entry-0x7fffee18>
    80006a2a:	050e                	slli	a0,a0,0x3
    80006a2c:	9526                	add	a0,a0,s1
    80006a2e:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80006a32:	fd043503          	ld	a0,-48(s0)
    80006a36:	fffff097          	auipc	ra,0xfffff
    80006a3a:	9ae080e7          	jalr	-1618(ra) # 800053e4 <fileclose>
    fileclose(wf);
    80006a3e:	fc843503          	ld	a0,-56(s0)
    80006a42:	fffff097          	auipc	ra,0xfffff
    80006a46:	9a2080e7          	jalr	-1630(ra) # 800053e4 <fileclose>
    return -1;
    80006a4a:	57fd                	li	a5,-1
    80006a4c:	a805                	j	80006a7c <sys_pipe+0x114>
    if(fd0 >= 0)
    80006a4e:	fc442783          	lw	a5,-60(s0)
    80006a52:	0007c863          	bltz	a5,80006a62 <sys_pipe+0xfa>
      p->ofile[fd0] = 0;
    80006a56:	1e878513          	addi	a0,a5,488
    80006a5a:	050e                	slli	a0,a0,0x3
    80006a5c:	9526                	add	a0,a0,s1
    80006a5e:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80006a62:	fd043503          	ld	a0,-48(s0)
    80006a66:	fffff097          	auipc	ra,0xfffff
    80006a6a:	97e080e7          	jalr	-1666(ra) # 800053e4 <fileclose>
    fileclose(wf);
    80006a6e:	fc843503          	ld	a0,-56(s0)
    80006a72:	fffff097          	auipc	ra,0xfffff
    80006a76:	972080e7          	jalr	-1678(ra) # 800053e4 <fileclose>
    return -1;
    80006a7a:	57fd                	li	a5,-1
}
    80006a7c:	853e                	mv	a0,a5
    80006a7e:	70e2                	ld	ra,56(sp)
    80006a80:	7442                	ld	s0,48(sp)
    80006a82:	74a2                	ld	s1,40(sp)
    80006a84:	6121                	addi	sp,sp,64
    80006a86:	8082                	ret
	...

0000000080006a90 <kernelvec>:
    80006a90:	7111                	addi	sp,sp,-256
    80006a92:	e006                	sd	ra,0(sp)
    80006a94:	e40a                	sd	sp,8(sp)
    80006a96:	e80e                	sd	gp,16(sp)
    80006a98:	ec12                	sd	tp,24(sp)
    80006a9a:	f016                	sd	t0,32(sp)
    80006a9c:	f41a                	sd	t1,40(sp)
    80006a9e:	f81e                	sd	t2,48(sp)
    80006aa0:	fc22                	sd	s0,56(sp)
    80006aa2:	e0a6                	sd	s1,64(sp)
    80006aa4:	e4aa                	sd	a0,72(sp)
    80006aa6:	e8ae                	sd	a1,80(sp)
    80006aa8:	ecb2                	sd	a2,88(sp)
    80006aaa:	f0b6                	sd	a3,96(sp)
    80006aac:	f4ba                	sd	a4,104(sp)
    80006aae:	f8be                	sd	a5,112(sp)
    80006ab0:	fcc2                	sd	a6,120(sp)
    80006ab2:	e146                	sd	a7,128(sp)
    80006ab4:	e54a                	sd	s2,136(sp)
    80006ab6:	e94e                	sd	s3,144(sp)
    80006ab8:	ed52                	sd	s4,152(sp)
    80006aba:	f156                	sd	s5,160(sp)
    80006abc:	f55a                	sd	s6,168(sp)
    80006abe:	f95e                	sd	s7,176(sp)
    80006ac0:	fd62                	sd	s8,184(sp)
    80006ac2:	e1e6                	sd	s9,192(sp)
    80006ac4:	e5ea                	sd	s10,200(sp)
    80006ac6:	e9ee                	sd	s11,208(sp)
    80006ac8:	edf2                	sd	t3,216(sp)
    80006aca:	f1f6                	sd	t4,224(sp)
    80006acc:	f5fa                	sd	t5,232(sp)
    80006ace:	f9fe                	sd	t6,240(sp)
    80006ad0:	ab7fc0ef          	jal	ra,80003586 <kerneltrap>
    80006ad4:	6082                	ld	ra,0(sp)
    80006ad6:	6122                	ld	sp,8(sp)
    80006ad8:	61c2                	ld	gp,16(sp)
    80006ada:	7282                	ld	t0,32(sp)
    80006adc:	7322                	ld	t1,40(sp)
    80006ade:	73c2                	ld	t2,48(sp)
    80006ae0:	7462                	ld	s0,56(sp)
    80006ae2:	6486                	ld	s1,64(sp)
    80006ae4:	6526                	ld	a0,72(sp)
    80006ae6:	65c6                	ld	a1,80(sp)
    80006ae8:	6666                	ld	a2,88(sp)
    80006aea:	7686                	ld	a3,96(sp)
    80006aec:	7726                	ld	a4,104(sp)
    80006aee:	77c6                	ld	a5,112(sp)
    80006af0:	7866                	ld	a6,120(sp)
    80006af2:	688a                	ld	a7,128(sp)
    80006af4:	692a                	ld	s2,136(sp)
    80006af6:	69ca                	ld	s3,144(sp)
    80006af8:	6a6a                	ld	s4,152(sp)
    80006afa:	7a8a                	ld	s5,160(sp)
    80006afc:	7b2a                	ld	s6,168(sp)
    80006afe:	7bca                	ld	s7,176(sp)
    80006b00:	7c6a                	ld	s8,184(sp)
    80006b02:	6c8e                	ld	s9,192(sp)
    80006b04:	6d2e                	ld	s10,200(sp)
    80006b06:	6dce                	ld	s11,208(sp)
    80006b08:	6e6e                	ld	t3,216(sp)
    80006b0a:	7e8e                	ld	t4,224(sp)
    80006b0c:	7f2e                	ld	t5,232(sp)
    80006b0e:	7fce                	ld	t6,240(sp)
    80006b10:	6111                	addi	sp,sp,256
    80006b12:	10200073          	sret
    80006b16:	00000013          	nop
    80006b1a:	00000013          	nop
    80006b1e:	0001                	nop

0000000080006b20 <timervec>:
    80006b20:	34051573          	csrrw	a0,mscratch,a0
    80006b24:	e10c                	sd	a1,0(a0)
    80006b26:	e510                	sd	a2,8(a0)
    80006b28:	e914                	sd	a3,16(a0)
    80006b2a:	6d0c                	ld	a1,24(a0)
    80006b2c:	7110                	ld	a2,32(a0)
    80006b2e:	6194                	ld	a3,0(a1)
    80006b30:	96b2                	add	a3,a3,a2
    80006b32:	e194                	sd	a3,0(a1)
    80006b34:	4589                	li	a1,2
    80006b36:	14459073          	csrw	sip,a1
    80006b3a:	6914                	ld	a3,16(a0)
    80006b3c:	6510                	ld	a2,8(a0)
    80006b3e:	610c                	ld	a1,0(a0)
    80006b40:	34051573          	csrrw	a0,mscratch,a0
    80006b44:	30200073          	mret
	...

0000000080006b4a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80006b4a:	1141                	addi	sp,sp,-16
    80006b4c:	e422                	sd	s0,8(sp)
    80006b4e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006b50:	0c0007b7          	lui	a5,0xc000
    80006b54:	4705                	li	a4,1
    80006b56:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006b58:	c3d8                	sw	a4,4(a5)
}
    80006b5a:	6422                	ld	s0,8(sp)
    80006b5c:	0141                	addi	sp,sp,16
    80006b5e:	8082                	ret

0000000080006b60 <plicinithart>:

void
plicinithart(void)
{
    80006b60:	1141                	addi	sp,sp,-16
    80006b62:	e406                	sd	ra,8(sp)
    80006b64:	e022                	sd	s0,0(sp)
    80006b66:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006b68:	ffffb097          	auipc	ra,0xffffb
    80006b6c:	e5c080e7          	jalr	-420(ra) # 800019c4 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006b70:	0085171b          	slliw	a4,a0,0x8
    80006b74:	0c0027b7          	lui	a5,0xc002
    80006b78:	97ba                	add	a5,a5,a4
    80006b7a:	40200713          	li	a4,1026
    80006b7e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006b82:	00d5151b          	slliw	a0,a0,0xd
    80006b86:	0c2017b7          	lui	a5,0xc201
    80006b8a:	953e                	add	a0,a0,a5
    80006b8c:	00052023          	sw	zero,0(a0)
}
    80006b90:	60a2                	ld	ra,8(sp)
    80006b92:	6402                	ld	s0,0(sp)
    80006b94:	0141                	addi	sp,sp,16
    80006b96:	8082                	ret

0000000080006b98 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006b98:	1141                	addi	sp,sp,-16
    80006b9a:	e406                	sd	ra,8(sp)
    80006b9c:	e022                	sd	s0,0(sp)
    80006b9e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006ba0:	ffffb097          	auipc	ra,0xffffb
    80006ba4:	e24080e7          	jalr	-476(ra) # 800019c4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006ba8:	00d5179b          	slliw	a5,a0,0xd
    80006bac:	0c201537          	lui	a0,0xc201
    80006bb0:	953e                	add	a0,a0,a5
  return irq;
}
    80006bb2:	4148                	lw	a0,4(a0)
    80006bb4:	60a2                	ld	ra,8(sp)
    80006bb6:	6402                	ld	s0,0(sp)
    80006bb8:	0141                	addi	sp,sp,16
    80006bba:	8082                	ret

0000000080006bbc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006bbc:	1101                	addi	sp,sp,-32
    80006bbe:	ec06                	sd	ra,24(sp)
    80006bc0:	e822                	sd	s0,16(sp)
    80006bc2:	e426                	sd	s1,8(sp)
    80006bc4:	1000                	addi	s0,sp,32
    80006bc6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006bc8:	ffffb097          	auipc	ra,0xffffb
    80006bcc:	dfc080e7          	jalr	-516(ra) # 800019c4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006bd0:	00d5151b          	slliw	a0,a0,0xd
    80006bd4:	0c2017b7          	lui	a5,0xc201
    80006bd8:	97aa                	add	a5,a5,a0
    80006bda:	c3c4                	sw	s1,4(a5)
}
    80006bdc:	60e2                	ld	ra,24(sp)
    80006bde:	6442                	ld	s0,16(sp)
    80006be0:	64a2                	ld	s1,8(sp)
    80006be2:	6105                	addi	sp,sp,32
    80006be4:	8082                	ret

0000000080006be6 <start_ret>:
    80006be6:	48e1                	li	a7,24
    80006be8:	00000073          	ecall

0000000080006bec <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006bec:	1141                	addi	sp,sp,-16
    80006bee:	e406                	sd	ra,8(sp)
    80006bf0:	e022                	sd	s0,0(sp)
    80006bf2:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006bf4:	479d                	li	a5,7
    80006bf6:	06a7c963          	blt	a5,a0,80006c68 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80006bfa:	0005d797          	auipc	a5,0x5d
    80006bfe:	40678793          	addi	a5,a5,1030 # 80064000 <disk>
    80006c02:	00a78733          	add	a4,a5,a0
    80006c06:	6789                	lui	a5,0x2
    80006c08:	97ba                	add	a5,a5,a4
    80006c0a:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006c0e:	e7ad                	bnez	a5,80006c78 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006c10:	00451793          	slli	a5,a0,0x4
    80006c14:	0005f717          	auipc	a4,0x5f
    80006c18:	3ec70713          	addi	a4,a4,1004 # 80066000 <disk+0x2000>
    80006c1c:	6314                	ld	a3,0(a4)
    80006c1e:	96be                	add	a3,a3,a5
    80006c20:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80006c24:	6314                	ld	a3,0(a4)
    80006c26:	96be                	add	a3,a3,a5
    80006c28:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80006c2c:	6314                	ld	a3,0(a4)
    80006c2e:	96be                	add	a3,a3,a5
    80006c30:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80006c34:	6318                	ld	a4,0(a4)
    80006c36:	97ba                	add	a5,a5,a4
    80006c38:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80006c3c:	0005d797          	auipc	a5,0x5d
    80006c40:	3c478793          	addi	a5,a5,964 # 80064000 <disk>
    80006c44:	97aa                	add	a5,a5,a0
    80006c46:	6509                	lui	a0,0x2
    80006c48:	953e                	add	a0,a0,a5
    80006c4a:	4785                	li	a5,1
    80006c4c:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>

  wakeup(&disk.free[0]);
    80006c50:	0005f517          	auipc	a0,0x5f
    80006c54:	3c850513          	addi	a0,a0,968 # 80066018 <disk+0x2018>
    80006c58:	ffffc097          	auipc	ra,0xffffc
    80006c5c:	8dc080e7          	jalr	-1828(ra) # 80002534 <wakeup>
}
    80006c60:	60a2                	ld	ra,8(sp)
    80006c62:	6402                	ld	s0,0(sp)
    80006c64:	0141                	addi	sp,sp,16
    80006c66:	8082                	ret
    panic("free_desc 1");
    80006c68:	00003517          	auipc	a0,0x3
    80006c6c:	c1050513          	addi	a0,a0,-1008 # 80009878 <syscalls+0x3a0>
    80006c70:	ffffa097          	auipc	ra,0xffffa
    80006c74:	8ba080e7          	jalr	-1862(ra) # 8000052a <panic>
    panic("free_desc 2");
    80006c78:	00003517          	auipc	a0,0x3
    80006c7c:	c1050513          	addi	a0,a0,-1008 # 80009888 <syscalls+0x3b0>
    80006c80:	ffffa097          	auipc	ra,0xffffa
    80006c84:	8aa080e7          	jalr	-1878(ra) # 8000052a <panic>

0000000080006c88 <virtio_disk_init>:
{
    80006c88:	1101                	addi	sp,sp,-32
    80006c8a:	ec06                	sd	ra,24(sp)
    80006c8c:	e822                	sd	s0,16(sp)
    80006c8e:	e426                	sd	s1,8(sp)
    80006c90:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006c92:	00003597          	auipc	a1,0x3
    80006c96:	c0658593          	addi	a1,a1,-1018 # 80009898 <syscalls+0x3c0>
    80006c9a:	0005f517          	auipc	a0,0x5f
    80006c9e:	48e50513          	addi	a0,a0,1166 # 80066128 <disk+0x2128>
    80006ca2:	ffffa097          	auipc	ra,0xffffa
    80006ca6:	e90080e7          	jalr	-368(ra) # 80000b32 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006caa:	100017b7          	lui	a5,0x10001
    80006cae:	4398                	lw	a4,0(a5)
    80006cb0:	2701                	sext.w	a4,a4
    80006cb2:	747277b7          	lui	a5,0x74727
    80006cb6:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006cba:	0ef71163          	bne	a4,a5,80006d9c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006cbe:	100017b7          	lui	a5,0x10001
    80006cc2:	43dc                	lw	a5,4(a5)
    80006cc4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006cc6:	4705                	li	a4,1
    80006cc8:	0ce79a63          	bne	a5,a4,80006d9c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006ccc:	100017b7          	lui	a5,0x10001
    80006cd0:	479c                	lw	a5,8(a5)
    80006cd2:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006cd4:	4709                	li	a4,2
    80006cd6:	0ce79363          	bne	a5,a4,80006d9c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006cda:	100017b7          	lui	a5,0x10001
    80006cde:	47d8                	lw	a4,12(a5)
    80006ce0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006ce2:	554d47b7          	lui	a5,0x554d4
    80006ce6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006cea:	0af71963          	bne	a4,a5,80006d9c <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006cee:	100017b7          	lui	a5,0x10001
    80006cf2:	4705                	li	a4,1
    80006cf4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006cf6:	470d                	li	a4,3
    80006cf8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006cfa:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006cfc:	c7ffe737          	lui	a4,0xc7ffe
    80006d00:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47f9775f>
    80006d04:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006d06:	2701                	sext.w	a4,a4
    80006d08:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006d0a:	472d                	li	a4,11
    80006d0c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006d0e:	473d                	li	a4,15
    80006d10:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006d12:	6705                	lui	a4,0x1
    80006d14:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006d16:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006d1a:	5bdc                	lw	a5,52(a5)
    80006d1c:	2781                	sext.w	a5,a5
  if(max == 0)
    80006d1e:	c7d9                	beqz	a5,80006dac <virtio_disk_init+0x124>
  if(max < NUM)
    80006d20:	471d                	li	a4,7
    80006d22:	08f77d63          	bgeu	a4,a5,80006dbc <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006d26:	100014b7          	lui	s1,0x10001
    80006d2a:	47a1                	li	a5,8
    80006d2c:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80006d2e:	6609                	lui	a2,0x2
    80006d30:	4581                	li	a1,0
    80006d32:	0005d517          	auipc	a0,0x5d
    80006d36:	2ce50513          	addi	a0,a0,718 # 80064000 <disk>
    80006d3a:	ffffa097          	auipc	ra,0xffffa
    80006d3e:	f92080e7          	jalr	-110(ra) # 80000ccc <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006d42:	0005d717          	auipc	a4,0x5d
    80006d46:	2be70713          	addi	a4,a4,702 # 80064000 <disk>
    80006d4a:	00c75793          	srli	a5,a4,0xc
    80006d4e:	2781                	sext.w	a5,a5
    80006d50:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80006d52:	0005f797          	auipc	a5,0x5f
    80006d56:	2ae78793          	addi	a5,a5,686 # 80066000 <disk+0x2000>
    80006d5a:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006d5c:	0005d717          	auipc	a4,0x5d
    80006d60:	32470713          	addi	a4,a4,804 # 80064080 <disk+0x80>
    80006d64:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80006d66:	0005e717          	auipc	a4,0x5e
    80006d6a:	29a70713          	addi	a4,a4,666 # 80065000 <disk+0x1000>
    80006d6e:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80006d70:	4705                	li	a4,1
    80006d72:	00e78c23          	sb	a4,24(a5)
    80006d76:	00e78ca3          	sb	a4,25(a5)
    80006d7a:	00e78d23          	sb	a4,26(a5)
    80006d7e:	00e78da3          	sb	a4,27(a5)
    80006d82:	00e78e23          	sb	a4,28(a5)
    80006d86:	00e78ea3          	sb	a4,29(a5)
    80006d8a:	00e78f23          	sb	a4,30(a5)
    80006d8e:	00e78fa3          	sb	a4,31(a5)
}
    80006d92:	60e2                	ld	ra,24(sp)
    80006d94:	6442                	ld	s0,16(sp)
    80006d96:	64a2                	ld	s1,8(sp)
    80006d98:	6105                	addi	sp,sp,32
    80006d9a:	8082                	ret
    panic("could not find virtio disk");
    80006d9c:	00003517          	auipc	a0,0x3
    80006da0:	b0c50513          	addi	a0,a0,-1268 # 800098a8 <syscalls+0x3d0>
    80006da4:	ffff9097          	auipc	ra,0xffff9
    80006da8:	786080e7          	jalr	1926(ra) # 8000052a <panic>
    panic("virtio disk has no queue 0");
    80006dac:	00003517          	auipc	a0,0x3
    80006db0:	b1c50513          	addi	a0,a0,-1252 # 800098c8 <syscalls+0x3f0>
    80006db4:	ffff9097          	auipc	ra,0xffff9
    80006db8:	776080e7          	jalr	1910(ra) # 8000052a <panic>
    panic("virtio disk max queue too short");
    80006dbc:	00003517          	auipc	a0,0x3
    80006dc0:	b2c50513          	addi	a0,a0,-1236 # 800098e8 <syscalls+0x410>
    80006dc4:	ffff9097          	auipc	ra,0xffff9
    80006dc8:	766080e7          	jalr	1894(ra) # 8000052a <panic>

0000000080006dcc <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006dcc:	7119                	addi	sp,sp,-128
    80006dce:	fc86                	sd	ra,120(sp)
    80006dd0:	f8a2                	sd	s0,112(sp)
    80006dd2:	f4a6                	sd	s1,104(sp)
    80006dd4:	f0ca                	sd	s2,96(sp)
    80006dd6:	ecce                	sd	s3,88(sp)
    80006dd8:	e8d2                	sd	s4,80(sp)
    80006dda:	e4d6                	sd	s5,72(sp)
    80006ddc:	e0da                	sd	s6,64(sp)
    80006dde:	fc5e                	sd	s7,56(sp)
    80006de0:	f862                	sd	s8,48(sp)
    80006de2:	f466                	sd	s9,40(sp)
    80006de4:	f06a                	sd	s10,32(sp)
    80006de6:	ec6e                	sd	s11,24(sp)
    80006de8:	0100                	addi	s0,sp,128
    80006dea:	8aaa                	mv	s5,a0
    80006dec:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006dee:	00c52c83          	lw	s9,12(a0)
    80006df2:	001c9c9b          	slliw	s9,s9,0x1
    80006df6:	1c82                	slli	s9,s9,0x20
    80006df8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006dfc:	0005f517          	auipc	a0,0x5f
    80006e00:	32c50513          	addi	a0,a0,812 # 80066128 <disk+0x2128>
    80006e04:	ffffa097          	auipc	ra,0xffffa
    80006e08:	dc6080e7          	jalr	-570(ra) # 80000bca <acquire>
  for(int i = 0; i < 3; i++){
    80006e0c:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006e0e:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006e10:	0005dc17          	auipc	s8,0x5d
    80006e14:	1f0c0c13          	addi	s8,s8,496 # 80064000 <disk>
    80006e18:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80006e1a:	4b0d                	li	s6,3
    80006e1c:	a0ad                	j	80006e86 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80006e1e:	00fc0733          	add	a4,s8,a5
    80006e22:	975e                	add	a4,a4,s7
    80006e24:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006e28:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006e2a:	0207c563          	bltz	a5,80006e54 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80006e2e:	2905                	addiw	s2,s2,1
    80006e30:	0611                	addi	a2,a2,4
    80006e32:	19690d63          	beq	s2,s6,80006fcc <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80006e36:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006e38:	0005f717          	auipc	a4,0x5f
    80006e3c:	1e070713          	addi	a4,a4,480 # 80066018 <disk+0x2018>
    80006e40:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006e42:	00074683          	lbu	a3,0(a4)
    80006e46:	fee1                	bnez	a3,80006e1e <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80006e48:	2785                	addiw	a5,a5,1
    80006e4a:	0705                	addi	a4,a4,1
    80006e4c:	fe979be3          	bne	a5,s1,80006e42 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80006e50:	57fd                	li	a5,-1
    80006e52:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006e54:	01205d63          	blez	s2,80006e6e <virtio_disk_rw+0xa2>
    80006e58:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006e5a:	000a2503          	lw	a0,0(s4)
    80006e5e:	00000097          	auipc	ra,0x0
    80006e62:	d8e080e7          	jalr	-626(ra) # 80006bec <free_desc>
      for(int j = 0; j < i; j++)
    80006e66:	2d85                	addiw	s11,s11,1
    80006e68:	0a11                	addi	s4,s4,4
    80006e6a:	ffb918e3          	bne	s2,s11,80006e5a <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006e6e:	0005f597          	auipc	a1,0x5f
    80006e72:	2ba58593          	addi	a1,a1,698 # 80066128 <disk+0x2128>
    80006e76:	0005f517          	auipc	a0,0x5f
    80006e7a:	1a250513          	addi	a0,a0,418 # 80066018 <disk+0x2018>
    80006e7e:	ffffb097          	auipc	ra,0xffffb
    80006e82:	4f6080e7          	jalr	1270(ra) # 80002374 <sleep>
  for(int i = 0; i < 3; i++){
    80006e86:	f8040a13          	addi	s4,s0,-128
{
    80006e8a:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006e8c:	894e                	mv	s2,s3
    80006e8e:	b765                	j	80006e36 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80006e90:	0005f697          	auipc	a3,0x5f
    80006e94:	1706b683          	ld	a3,368(a3) # 80066000 <disk+0x2000>
    80006e98:	96ba                	add	a3,a3,a4
    80006e9a:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006e9e:	0005d817          	auipc	a6,0x5d
    80006ea2:	16280813          	addi	a6,a6,354 # 80064000 <disk>
    80006ea6:	0005f697          	auipc	a3,0x5f
    80006eaa:	15a68693          	addi	a3,a3,346 # 80066000 <disk+0x2000>
    80006eae:	6290                	ld	a2,0(a3)
    80006eb0:	963a                	add	a2,a2,a4
    80006eb2:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80006eb6:	0015e593          	ori	a1,a1,1
    80006eba:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80006ebe:	f8842603          	lw	a2,-120(s0)
    80006ec2:	628c                	ld	a1,0(a3)
    80006ec4:	972e                	add	a4,a4,a1
    80006ec6:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006eca:	20050593          	addi	a1,a0,512
    80006ece:	0592                	slli	a1,a1,0x4
    80006ed0:	95c2                	add	a1,a1,a6
    80006ed2:	577d                	li	a4,-1
    80006ed4:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006ed8:	00461713          	slli	a4,a2,0x4
    80006edc:	6290                	ld	a2,0(a3)
    80006ede:	963a                	add	a2,a2,a4
    80006ee0:	03078793          	addi	a5,a5,48
    80006ee4:	97c2                	add	a5,a5,a6
    80006ee6:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    80006ee8:	629c                	ld	a5,0(a3)
    80006eea:	97ba                	add	a5,a5,a4
    80006eec:	4605                	li	a2,1
    80006eee:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006ef0:	629c                	ld	a5,0(a3)
    80006ef2:	97ba                	add	a5,a5,a4
    80006ef4:	4809                	li	a6,2
    80006ef6:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80006efa:	629c                	ld	a5,0(a3)
    80006efc:	973e                	add	a4,a4,a5
    80006efe:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006f02:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80006f06:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006f0a:	6698                	ld	a4,8(a3)
    80006f0c:	00275783          	lhu	a5,2(a4)
    80006f10:	8b9d                	andi	a5,a5,7
    80006f12:	0786                	slli	a5,a5,0x1
    80006f14:	97ba                	add	a5,a5,a4
    80006f16:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    80006f1a:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006f1e:	6698                	ld	a4,8(a3)
    80006f20:	00275783          	lhu	a5,2(a4)
    80006f24:	2785                	addiw	a5,a5,1
    80006f26:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006f2a:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006f2e:	100017b7          	lui	a5,0x10001
    80006f32:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006f36:	004aa783          	lw	a5,4(s5)
    80006f3a:	02c79163          	bne	a5,a2,80006f5c <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80006f3e:	0005f917          	auipc	s2,0x5f
    80006f42:	1ea90913          	addi	s2,s2,490 # 80066128 <disk+0x2128>
  while(b->disk == 1) {
    80006f46:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006f48:	85ca                	mv	a1,s2
    80006f4a:	8556                	mv	a0,s5
    80006f4c:	ffffb097          	auipc	ra,0xffffb
    80006f50:	428080e7          	jalr	1064(ra) # 80002374 <sleep>
  while(b->disk == 1) {
    80006f54:	004aa783          	lw	a5,4(s5)
    80006f58:	fe9788e3          	beq	a5,s1,80006f48 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80006f5c:	f8042903          	lw	s2,-128(s0)
    80006f60:	20090793          	addi	a5,s2,512
    80006f64:	00479713          	slli	a4,a5,0x4
    80006f68:	0005d797          	auipc	a5,0x5d
    80006f6c:	09878793          	addi	a5,a5,152 # 80064000 <disk>
    80006f70:	97ba                	add	a5,a5,a4
    80006f72:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80006f76:	0005f997          	auipc	s3,0x5f
    80006f7a:	08a98993          	addi	s3,s3,138 # 80066000 <disk+0x2000>
    80006f7e:	00491713          	slli	a4,s2,0x4
    80006f82:	0009b783          	ld	a5,0(s3)
    80006f86:	97ba                	add	a5,a5,a4
    80006f88:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006f8c:	854a                	mv	a0,s2
    80006f8e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006f92:	00000097          	auipc	ra,0x0
    80006f96:	c5a080e7          	jalr	-934(ra) # 80006bec <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006f9a:	8885                	andi	s1,s1,1
    80006f9c:	f0ed                	bnez	s1,80006f7e <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006f9e:	0005f517          	auipc	a0,0x5f
    80006fa2:	18a50513          	addi	a0,a0,394 # 80066128 <disk+0x2128>
    80006fa6:	ffffa097          	auipc	ra,0xffffa
    80006faa:	cde080e7          	jalr	-802(ra) # 80000c84 <release>
}
    80006fae:	70e6                	ld	ra,120(sp)
    80006fb0:	7446                	ld	s0,112(sp)
    80006fb2:	74a6                	ld	s1,104(sp)
    80006fb4:	7906                	ld	s2,96(sp)
    80006fb6:	69e6                	ld	s3,88(sp)
    80006fb8:	6a46                	ld	s4,80(sp)
    80006fba:	6aa6                	ld	s5,72(sp)
    80006fbc:	6b06                	ld	s6,64(sp)
    80006fbe:	7be2                	ld	s7,56(sp)
    80006fc0:	7c42                	ld	s8,48(sp)
    80006fc2:	7ca2                	ld	s9,40(sp)
    80006fc4:	7d02                	ld	s10,32(sp)
    80006fc6:	6de2                	ld	s11,24(sp)
    80006fc8:	6109                	addi	sp,sp,128
    80006fca:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006fcc:	f8042503          	lw	a0,-128(s0)
    80006fd0:	20050793          	addi	a5,a0,512
    80006fd4:	0792                	slli	a5,a5,0x4
  if(write)
    80006fd6:	0005d817          	auipc	a6,0x5d
    80006fda:	02a80813          	addi	a6,a6,42 # 80064000 <disk>
    80006fde:	00f80733          	add	a4,a6,a5
    80006fe2:	01a036b3          	snez	a3,s10
    80006fe6:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    80006fea:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80006fee:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006ff2:	7679                	lui	a2,0xffffe
    80006ff4:	963e                	add	a2,a2,a5
    80006ff6:	0005f697          	auipc	a3,0x5f
    80006ffa:	00a68693          	addi	a3,a3,10 # 80066000 <disk+0x2000>
    80006ffe:	6298                	ld	a4,0(a3)
    80007000:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80007002:	0a878593          	addi	a1,a5,168
    80007006:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    80007008:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000700a:	6298                	ld	a4,0(a3)
    8000700c:	9732                	add	a4,a4,a2
    8000700e:	45c1                	li	a1,16
    80007010:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80007012:	6298                	ld	a4,0(a3)
    80007014:	9732                	add	a4,a4,a2
    80007016:	4585                	li	a1,1
    80007018:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    8000701c:	f8442703          	lw	a4,-124(s0)
    80007020:	628c                	ld	a1,0(a3)
    80007022:	962e                	add	a2,a2,a1
    80007024:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ff9700e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80007028:	0712                	slli	a4,a4,0x4
    8000702a:	6290                	ld	a2,0(a3)
    8000702c:	963a                	add	a2,a2,a4
    8000702e:	058a8593          	addi	a1,s5,88
    80007032:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80007034:	6294                	ld	a3,0(a3)
    80007036:	96ba                	add	a3,a3,a4
    80007038:	40000613          	li	a2,1024
    8000703c:	c690                	sw	a2,8(a3)
  if(write)
    8000703e:	e40d19e3          	bnez	s10,80006e90 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80007042:	0005f697          	auipc	a3,0x5f
    80007046:	fbe6b683          	ld	a3,-66(a3) # 80066000 <disk+0x2000>
    8000704a:	96ba                	add	a3,a3,a4
    8000704c:	4609                	li	a2,2
    8000704e:	00c69623          	sh	a2,12(a3)
    80007052:	b5b1                	j	80006e9e <virtio_disk_rw+0xd2>

0000000080007054 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80007054:	1101                	addi	sp,sp,-32
    80007056:	ec06                	sd	ra,24(sp)
    80007058:	e822                	sd	s0,16(sp)
    8000705a:	e426                	sd	s1,8(sp)
    8000705c:	e04a                	sd	s2,0(sp)
    8000705e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80007060:	0005f517          	auipc	a0,0x5f
    80007064:	0c850513          	addi	a0,a0,200 # 80066128 <disk+0x2128>
    80007068:	ffffa097          	auipc	ra,0xffffa
    8000706c:	b62080e7          	jalr	-1182(ra) # 80000bca <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80007070:	10001737          	lui	a4,0x10001
    80007074:	533c                	lw	a5,96(a4)
    80007076:	8b8d                	andi	a5,a5,3
    80007078:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000707a:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000707e:	0005f797          	auipc	a5,0x5f
    80007082:	f8278793          	addi	a5,a5,-126 # 80066000 <disk+0x2000>
    80007086:	6b94                	ld	a3,16(a5)
    80007088:	0207d703          	lhu	a4,32(a5)
    8000708c:	0026d783          	lhu	a5,2(a3)
    80007090:	06f70163          	beq	a4,a5,800070f2 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80007094:	0005d917          	auipc	s2,0x5d
    80007098:	f6c90913          	addi	s2,s2,-148 # 80064000 <disk>
    8000709c:	0005f497          	auipc	s1,0x5f
    800070a0:	f6448493          	addi	s1,s1,-156 # 80066000 <disk+0x2000>
    __sync_synchronize();
    800070a4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800070a8:	6898                	ld	a4,16(s1)
    800070aa:	0204d783          	lhu	a5,32(s1)
    800070ae:	8b9d                	andi	a5,a5,7
    800070b0:	078e                	slli	a5,a5,0x3
    800070b2:	97ba                	add	a5,a5,a4
    800070b4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800070b6:	20078713          	addi	a4,a5,512
    800070ba:	0712                	slli	a4,a4,0x4
    800070bc:	974a                	add	a4,a4,s2
    800070be:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800070c2:	e731                	bnez	a4,8000710e <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800070c4:	20078793          	addi	a5,a5,512
    800070c8:	0792                	slli	a5,a5,0x4
    800070ca:	97ca                	add	a5,a5,s2
    800070cc:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800070ce:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800070d2:	ffffb097          	auipc	ra,0xffffb
    800070d6:	462080e7          	jalr	1122(ra) # 80002534 <wakeup>

    disk.used_idx += 1;
    800070da:	0204d783          	lhu	a5,32(s1)
    800070de:	2785                	addiw	a5,a5,1
    800070e0:	17c2                	slli	a5,a5,0x30
    800070e2:	93c1                	srli	a5,a5,0x30
    800070e4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800070e8:	6898                	ld	a4,16(s1)
    800070ea:	00275703          	lhu	a4,2(a4)
    800070ee:	faf71be3          	bne	a4,a5,800070a4 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800070f2:	0005f517          	auipc	a0,0x5f
    800070f6:	03650513          	addi	a0,a0,54 # 80066128 <disk+0x2128>
    800070fa:	ffffa097          	auipc	ra,0xffffa
    800070fe:	b8a080e7          	jalr	-1142(ra) # 80000c84 <release>
}
    80007102:	60e2                	ld	ra,24(sp)
    80007104:	6442                	ld	s0,16(sp)
    80007106:	64a2                	ld	s1,8(sp)
    80007108:	6902                	ld	s2,0(sp)
    8000710a:	6105                	addi	sp,sp,32
    8000710c:	8082                	ret
      panic("virtio_disk_intr status");
    8000710e:	00002517          	auipc	a0,0x2
    80007112:	7fa50513          	addi	a0,a0,2042 # 80009908 <syscalls+0x430>
    80007116:	ffff9097          	auipc	ra,0xffff9
    8000711a:	414080e7          	jalr	1044(ra) # 8000052a <panic>
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
