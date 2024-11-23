
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	6e013103          	ld	sp,1760(sp) # 8000a6e0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdad8f>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	de278793          	addi	a5,a5,-542 # 80000e62 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	f84a                	sd	s2,48(sp)
    800000d8:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000da:	04c05263          	blez	a2,8000011e <consolewrite+0x4e>
    800000de:	fc26                	sd	s1,56(sp)
    800000e0:	f44e                	sd	s3,40(sp)
    800000e2:	f052                	sd	s4,32(sp)
    800000e4:	ec56                	sd	s5,24(sp)
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	15a020ef          	jal	80002254 <either_copyin>
    800000fe:	03550263          	beq	a0,s5,80000122 <consolewrite+0x52>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	035000ef          	jal	8000093a <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
    80000112:	894e                	mv	s2,s3
    80000114:	74e2                	ld	s1,56(sp)
    80000116:	79a2                	ld	s3,40(sp)
    80000118:	7a02                	ld	s4,32(sp)
    8000011a:	6ae2                	ld	s5,24(sp)
    8000011c:	a039                	j	8000012a <consolewrite+0x5a>
    8000011e:	4901                	li	s2,0
    80000120:	a029                	j	8000012a <consolewrite+0x5a>
    80000122:	74e2                	ld	s1,56(sp)
    80000124:	79a2                	ld	s3,40(sp)
    80000126:	7a02                	ld	s4,32(sp)
    80000128:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    8000012a:	854a                	mv	a0,s2
    8000012c:	60a6                	ld	ra,72(sp)
    8000012e:	6406                	ld	s0,64(sp)
    80000130:	7942                	ld	s2,48(sp)
    80000132:	6161                	addi	sp,sp,80
    80000134:	8082                	ret

0000000080000136 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000136:	711d                	addi	sp,sp,-96
    80000138:	ec86                	sd	ra,88(sp)
    8000013a:	e8a2                	sd	s0,80(sp)
    8000013c:	e4a6                	sd	s1,72(sp)
    8000013e:	e0ca                	sd	s2,64(sp)
    80000140:	fc4e                	sd	s3,56(sp)
    80000142:	f852                	sd	s4,48(sp)
    80000144:	f456                	sd	s5,40(sp)
    80000146:	f05a                	sd	s6,32(sp)
    80000148:	1080                	addi	s0,sp,96
    8000014a:	8aaa                	mv	s5,a0
    8000014c:	8a2e                	mv	s4,a1
    8000014e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000150:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000154:	00012517          	auipc	a0,0x12
    80000158:	5ec50513          	addi	a0,a0,1516 # 80012740 <cons>
    8000015c:	299000ef          	jal	80000bf4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00012497          	auipc	s1,0x12
    80000164:	5e048493          	addi	s1,s1,1504 # 80012740 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00012917          	auipc	s2,0x12
    8000016c:	67090913          	addi	s2,s2,1648 # 800127d8 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	760010ef          	jal	800018e0 <myproc>
    80000184:	763010ef          	jal	800020e6 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	521010ef          	jal	80001eae <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00012717          	auipc	a4,0x12
    800001a4:	5a070713          	addi	a4,a4,1440 # 80012740 <cons>
    800001a8:	0017869b          	addiw	a3,a5,1
    800001ac:	08d72c23          	sw	a3,152(a4)
    800001b0:	07f7f693          	andi	a3,a5,127
    800001b4:	9736                	add	a4,a4,a3
    800001b6:	01874703          	lbu	a4,24(a4)
    800001ba:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001be:	4691                	li	a3,4
    800001c0:	04db8663          	beq	s7,a3,8000020c <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001c4:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001c8:	4685                	li	a3,1
    800001ca:	faf40613          	addi	a2,s0,-81
    800001ce:	85d2                	mv	a1,s4
    800001d0:	8556                	mv	a0,s5
    800001d2:	038020ef          	jal	8000220a <either_copyout>
    800001d6:	57fd                	li	a5,-1
    800001d8:	04f50863          	beq	a0,a5,80000228 <consoleread+0xf2>
      break;

    dst++;
    800001dc:	0a05                	addi	s4,s4,1
    --n;
    800001de:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001e0:	47a9                	li	a5,10
    800001e2:	04fb8d63          	beq	s7,a5,8000023c <consoleread+0x106>
    800001e6:	6be2                	ld	s7,24(sp)
    800001e8:	b761                	j	80000170 <consoleread+0x3a>
        release(&cons.lock);
    800001ea:	00012517          	auipc	a0,0x12
    800001ee:	55650513          	addi	a0,a0,1366 # 80012740 <cons>
    800001f2:	29b000ef          	jal	80000c8c <release>
        return -1;
    800001f6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800001f8:	60e6                	ld	ra,88(sp)
    800001fa:	6446                	ld	s0,80(sp)
    800001fc:	64a6                	ld	s1,72(sp)
    800001fe:	6906                	ld	s2,64(sp)
    80000200:	79e2                	ld	s3,56(sp)
    80000202:	7a42                	ld	s4,48(sp)
    80000204:	7aa2                	ld	s5,40(sp)
    80000206:	7b02                	ld	s6,32(sp)
    80000208:	6125                	addi	sp,sp,96
    8000020a:	8082                	ret
      if(n < target){
    8000020c:	0009871b          	sext.w	a4,s3
    80000210:	01677a63          	bgeu	a4,s6,80000224 <consoleread+0xee>
        cons.r--;
    80000214:	00012717          	auipc	a4,0x12
    80000218:	5cf72223          	sw	a5,1476(a4) # 800127d8 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00012517          	auipc	a0,0x12
    8000022e:	51650513          	addi	a0,a0,1302 # 80012740 <cons>
    80000232:	25b000ef          	jal	80000c8c <release>
  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	bf7d                	j	800001f8 <consoleread+0xc2>
    8000023c:	6be2                	ld	s7,24(sp)
    8000023e:	b7f5                	j	8000022a <consoleread+0xf4>

0000000080000240 <consputc>:
{
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e406                	sd	ra,8(sp)
    80000244:	e022                	sd	s0,0(sp)
    80000246:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000248:	10000793          	li	a5,256
    8000024c:	00f50863          	beq	a0,a5,8000025c <consputc+0x1c>
    uartputc_sync(c);
    80000250:	604000ef          	jal	80000854 <uartputc_sync>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000025c:	4521                	li	a0,8
    8000025e:	5f6000ef          	jal	80000854 <uartputc_sync>
    80000262:	02000513          	li	a0,32
    80000266:	5ee000ef          	jal	80000854 <uartputc_sync>
    8000026a:	4521                	li	a0,8
    8000026c:	5e8000ef          	jal	80000854 <uartputc_sync>
    80000270:	b7d5                	j	80000254 <consputc+0x14>

0000000080000272 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000272:	1101                	addi	sp,sp,-32
    80000274:	ec06                	sd	ra,24(sp)
    80000276:	e822                	sd	s0,16(sp)
    80000278:	e426                	sd	s1,8(sp)
    8000027a:	1000                	addi	s0,sp,32
    8000027c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000027e:	00012517          	auipc	a0,0x12
    80000282:	4c250513          	addi	a0,a0,1218 # 80012740 <cons>
    80000286:	16f000ef          	jal	80000bf4 <acquire>

  switch(c){
    8000028a:	47d5                	li	a5,21
    8000028c:	08f48f63          	beq	s1,a5,8000032a <consoleintr+0xb8>
    80000290:	0297c563          	blt	a5,s1,800002ba <consoleintr+0x48>
    80000294:	47a1                	li	a5,8
    80000296:	0ef48463          	beq	s1,a5,8000037e <consoleintr+0x10c>
    8000029a:	47c1                	li	a5,16
    8000029c:	10f49563          	bne	s1,a5,800003a6 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800002a0:	7ff010ef          	jal	8000229e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002a4:	00012517          	auipc	a0,0x12
    800002a8:	49c50513          	addi	a0,a0,1180 # 80012740 <cons>
    800002ac:	1e1000ef          	jal	80000c8c <release>
}
    800002b0:	60e2                	ld	ra,24(sp)
    800002b2:	6442                	ld	s0,16(sp)
    800002b4:	64a2                	ld	s1,8(sp)
    800002b6:	6105                	addi	sp,sp,32
    800002b8:	8082                	ret
  switch(c){
    800002ba:	07f00793          	li	a5,127
    800002be:	0cf48063          	beq	s1,a5,8000037e <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002c2:	00012717          	auipc	a4,0x12
    800002c6:	47e70713          	addi	a4,a4,1150 # 80012740 <cons>
    800002ca:	0a072783          	lw	a5,160(a4)
    800002ce:	09872703          	lw	a4,152(a4)
    800002d2:	9f99                	subw	a5,a5,a4
    800002d4:	07f00713          	li	a4,127
    800002d8:	fcf766e3          	bltu	a4,a5,800002a4 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800002dc:	47b5                	li	a5,13
    800002de:	0cf48763          	beq	s1,a5,800003ac <consoleintr+0x13a>
      consputc(c);
    800002e2:	8526                	mv	a0,s1
    800002e4:	f5dff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002e8:	00012797          	auipc	a5,0x12
    800002ec:	45878793          	addi	a5,a5,1112 # 80012740 <cons>
    800002f0:	0a07a683          	lw	a3,160(a5)
    800002f4:	0016871b          	addiw	a4,a3,1
    800002f8:	0007061b          	sext.w	a2,a4
    800002fc:	0ae7a023          	sw	a4,160(a5)
    80000300:	07f6f693          	andi	a3,a3,127
    80000304:	97b6                	add	a5,a5,a3
    80000306:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000030a:	47a9                	li	a5,10
    8000030c:	0cf48563          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000310:	4791                	li	a5,4
    80000312:	0cf48263          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000316:	00012797          	auipc	a5,0x12
    8000031a:	4c27a783          	lw	a5,1218(a5) # 800127d8 <cons+0x98>
    8000031e:	9f1d                	subw	a4,a4,a5
    80000320:	08000793          	li	a5,128
    80000324:	f8f710e3          	bne	a4,a5,800002a4 <consoleintr+0x32>
    80000328:	a07d                	j	800003d6 <consoleintr+0x164>
    8000032a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000032c:	00012717          	auipc	a4,0x12
    80000330:	41470713          	addi	a4,a4,1044 # 80012740 <cons>
    80000334:	0a072783          	lw	a5,160(a4)
    80000338:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000033c:	00012497          	auipc	s1,0x12
    80000340:	40448493          	addi	s1,s1,1028 # 80012740 <cons>
    while(cons.e != cons.w &&
    80000344:	4929                	li	s2,10
    80000346:	02f70863          	beq	a4,a5,80000376 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	37fd                	addiw	a5,a5,-1
    8000034c:	07f7f713          	andi	a4,a5,127
    80000350:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000352:	01874703          	lbu	a4,24(a4)
    80000356:	03270263          	beq	a4,s2,8000037a <consoleintr+0x108>
      cons.e--;
    8000035a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000035e:	10000513          	li	a0,256
    80000362:	edfff0ef          	jal	80000240 <consputc>
    while(cons.e != cons.w &&
    80000366:	0a04a783          	lw	a5,160(s1)
    8000036a:	09c4a703          	lw	a4,156(s1)
    8000036e:	fcf71ee3          	bne	a4,a5,8000034a <consoleintr+0xd8>
    80000372:	6902                	ld	s2,0(sp)
    80000374:	bf05                	j	800002a4 <consoleintr+0x32>
    80000376:	6902                	ld	s2,0(sp)
    80000378:	b735                	j	800002a4 <consoleintr+0x32>
    8000037a:	6902                	ld	s2,0(sp)
    8000037c:	b725                	j	800002a4 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000037e:	00012717          	auipc	a4,0x12
    80000382:	3c270713          	addi	a4,a4,962 # 80012740 <cons>
    80000386:	0a072783          	lw	a5,160(a4)
    8000038a:	09c72703          	lw	a4,156(a4)
    8000038e:	f0f70be3          	beq	a4,a5,800002a4 <consoleintr+0x32>
      cons.e--;
    80000392:	37fd                	addiw	a5,a5,-1
    80000394:	00012717          	auipc	a4,0x12
    80000398:	44f72623          	sw	a5,1100(a4) # 800127e0 <cons+0xa0>
      consputc(BACKSPACE);
    8000039c:	10000513          	li	a0,256
    800003a0:	ea1ff0ef          	jal	80000240 <consputc>
    800003a4:	b701                	j	800002a4 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003a6:	ee048fe3          	beqz	s1,800002a4 <consoleintr+0x32>
    800003aa:	bf21                	j	800002c2 <consoleintr+0x50>
      consputc(c);
    800003ac:	4529                	li	a0,10
    800003ae:	e93ff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003b2:	00012797          	auipc	a5,0x12
    800003b6:	38e78793          	addi	a5,a5,910 # 80012740 <cons>
    800003ba:	0a07a703          	lw	a4,160(a5)
    800003be:	0017069b          	addiw	a3,a4,1
    800003c2:	0006861b          	sext.w	a2,a3
    800003c6:	0ad7a023          	sw	a3,160(a5)
    800003ca:	07f77713          	andi	a4,a4,127
    800003ce:	97ba                	add	a5,a5,a4
    800003d0:	4729                	li	a4,10
    800003d2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003d6:	00012797          	auipc	a5,0x12
    800003da:	40c7a323          	sw	a2,1030(a5) # 800127dc <cons+0x9c>
        wakeup(&cons.r);
    800003de:	00012517          	auipc	a0,0x12
    800003e2:	3fa50513          	addi	a0,a0,1018 # 800127d8 <cons+0x98>
    800003e6:	315010ef          	jal	80001efa <wakeup>
    800003ea:	bd6d                	j	800002a4 <consoleintr+0x32>

00000000800003ec <consoleinit>:

void
consoleinit(void)
{
    800003ec:	1141                	addi	sp,sp,-16
    800003ee:	e406                	sd	ra,8(sp)
    800003f0:	e022                	sd	s0,0(sp)
    800003f2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800003f4:	00007597          	auipc	a1,0x7
    800003f8:	c0c58593          	addi	a1,a1,-1012 # 80007000 <etext>
    800003fc:	00012517          	auipc	a0,0x12
    80000400:	34450513          	addi	a0,a0,836 # 80012740 <cons>
    80000404:	770000ef          	jal	80000b74 <initlock>

  uartinit();
    80000408:	3f4000ef          	jal	800007fc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000040c:	00022797          	auipc	a5,0x22
    80000410:	4cc78793          	addi	a5,a5,1228 # 800228d8 <devsw>
    80000414:	00000717          	auipc	a4,0x0
    80000418:	d2270713          	addi	a4,a4,-734 # 80000136 <consoleread>
    8000041c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000041e:	00000717          	auipc	a4,0x0
    80000422:	cb270713          	addi	a4,a4,-846 # 800000d0 <consolewrite>
    80000426:	ef98                	sd	a4,24(a5)
}
    80000428:	60a2                	ld	ra,8(sp)
    8000042a:	6402                	ld	s0,0(sp)
    8000042c:	0141                	addi	sp,sp,16
    8000042e:	8082                	ret

0000000080000430 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000430:	7179                	addi	sp,sp,-48
    80000432:	f406                	sd	ra,40(sp)
    80000434:	f022                	sd	s0,32(sp)
    80000436:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000438:	c219                	beqz	a2,8000043e <printint+0xe>
    8000043a:	08054063          	bltz	a0,800004ba <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000043e:	4881                	li	a7,0
    80000440:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000444:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000446:	00007617          	auipc	a2,0x7
    8000044a:	6ea60613          	addi	a2,a2,1770 # 80007b30 <digits>
    8000044e:	883e                	mv	a6,a5
    80000450:	2785                	addiw	a5,a5,1
    80000452:	02b57733          	remu	a4,a0,a1
    80000456:	9732                	add	a4,a4,a2
    80000458:	00074703          	lbu	a4,0(a4)
    8000045c:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000460:	872a                	mv	a4,a0
    80000462:	02b55533          	divu	a0,a0,a1
    80000466:	0685                	addi	a3,a3,1
    80000468:	feb773e3          	bgeu	a4,a1,8000044e <printint+0x1e>

  if(sign)
    8000046c:	00088a63          	beqz	a7,80000480 <printint+0x50>
    buf[i++] = '-';
    80000470:	1781                	addi	a5,a5,-32
    80000472:	97a2                	add	a5,a5,s0
    80000474:	02d00713          	li	a4,45
    80000478:	fee78823          	sb	a4,-16(a5)
    8000047c:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80000480:	02f05963          	blez	a5,800004b2 <printint+0x82>
    80000484:	ec26                	sd	s1,24(sp)
    80000486:	e84a                	sd	s2,16(sp)
    80000488:	fd040713          	addi	a4,s0,-48
    8000048c:	00f704b3          	add	s1,a4,a5
    80000490:	fff70913          	addi	s2,a4,-1
    80000494:	993e                	add	s2,s2,a5
    80000496:	37fd                	addiw	a5,a5,-1
    80000498:	1782                	slli	a5,a5,0x20
    8000049a:	9381                	srli	a5,a5,0x20
    8000049c:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004a0:	fff4c503          	lbu	a0,-1(s1)
    800004a4:	d9dff0ef          	jal	80000240 <consputc>
  while(--i >= 0)
    800004a8:	14fd                	addi	s1,s1,-1
    800004aa:	ff249be3          	bne	s1,s2,800004a0 <printint+0x70>
    800004ae:	64e2                	ld	s1,24(sp)
    800004b0:	6942                	ld	s2,16(sp)
}
    800004b2:	70a2                	ld	ra,40(sp)
    800004b4:	7402                	ld	s0,32(sp)
    800004b6:	6145                	addi	sp,sp,48
    800004b8:	8082                	ret
    x = -xx;
    800004ba:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004be:	4885                	li	a7,1
    x = -xx;
    800004c0:	b741                	j	80000440 <printint+0x10>

00000000800004c2 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004c2:	7155                	addi	sp,sp,-208
    800004c4:	e506                	sd	ra,136(sp)
    800004c6:	e122                	sd	s0,128(sp)
    800004c8:	f0d2                	sd	s4,96(sp)
    800004ca:	0900                	addi	s0,sp,144
    800004cc:	8a2a                	mv	s4,a0
    800004ce:	e40c                	sd	a1,8(s0)
    800004d0:	e810                	sd	a2,16(s0)
    800004d2:	ec14                	sd	a3,24(s0)
    800004d4:	f018                	sd	a4,32(s0)
    800004d6:	f41c                	sd	a5,40(s0)
    800004d8:	03043823          	sd	a6,48(s0)
    800004dc:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004e0:	00012797          	auipc	a5,0x12
    800004e4:	3207a783          	lw	a5,800(a5) # 80012800 <pr+0x18>
    800004e8:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004ec:	e3a1                	bnez	a5,8000052c <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004ee:	00840793          	addi	a5,s0,8
    800004f2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004f6:	00054503          	lbu	a0,0(a0)
    800004fa:	26050763          	beqz	a0,80000768 <printf+0x2a6>
    800004fe:	fca6                	sd	s1,120(sp)
    80000500:	f8ca                	sd	s2,112(sp)
    80000502:	f4ce                	sd	s3,104(sp)
    80000504:	ecd6                	sd	s5,88(sp)
    80000506:	e8da                	sd	s6,80(sp)
    80000508:	e0e2                	sd	s8,64(sp)
    8000050a:	fc66                	sd	s9,56(sp)
    8000050c:	f86a                	sd	s10,48(sp)
    8000050e:	f46e                	sd	s11,40(sp)
    80000510:	4981                	li	s3,0
    if(cx != '%'){
    80000512:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000516:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000051a:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000051e:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000522:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000526:	07000d93          	li	s11,112
    8000052a:	a815                	j	8000055e <printf+0x9c>
    acquire(&pr.lock);
    8000052c:	00012517          	auipc	a0,0x12
    80000530:	2bc50513          	addi	a0,a0,700 # 800127e8 <pr>
    80000534:	6c0000ef          	jal	80000bf4 <acquire>
  va_start(ap, fmt);
    80000538:	00840793          	addi	a5,s0,8
    8000053c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000540:	000a4503          	lbu	a0,0(s4)
    80000544:	fd4d                	bnez	a0,800004fe <printf+0x3c>
    80000546:	a481                	j	80000786 <printf+0x2c4>
      consputc(cx);
    80000548:	cf9ff0ef          	jal	80000240 <consputc>
      continue;
    8000054c:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054e:	0014899b          	addiw	s3,s1,1
    80000552:	013a07b3          	add	a5,s4,s3
    80000556:	0007c503          	lbu	a0,0(a5)
    8000055a:	1e050b63          	beqz	a0,80000750 <printf+0x28e>
    if(cx != '%'){
    8000055e:	ff5515e3          	bne	a0,s5,80000548 <printf+0x86>
    i++;
    80000562:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000566:	009a07b3          	add	a5,s4,s1
    8000056a:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000056e:	1e090163          	beqz	s2,80000750 <printf+0x28e>
    80000572:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000576:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000578:	c789                	beqz	a5,80000582 <printf+0xc0>
    8000057a:	009a0733          	add	a4,s4,s1
    8000057e:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000582:	03690763          	beq	s2,s6,800005b0 <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80000586:	05890163          	beq	s2,s8,800005c8 <printf+0x106>
    } else if(c0 == 'u'){
    8000058a:	0d990b63          	beq	s2,s9,80000660 <printf+0x19e>
    } else if(c0 == 'x'){
    8000058e:	13a90163          	beq	s2,s10,800006b0 <printf+0x1ee>
    } else if(c0 == 'p'){
    80000592:	13b90b63          	beq	s2,s11,800006c8 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80000596:	07300793          	li	a5,115
    8000059a:	16f90a63          	beq	s2,a5,8000070e <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000059e:	1b590463          	beq	s2,s5,80000746 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005a2:	8556                	mv	a0,s5
    800005a4:	c9dff0ef          	jal	80000240 <consputc>
      consputc(c0);
    800005a8:	854a                	mv	a0,s2
    800005aa:	c97ff0ef          	jal	80000240 <consputc>
    800005ae:	b745                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005b0:	f8843783          	ld	a5,-120(s0)
    800005b4:	00878713          	addi	a4,a5,8
    800005b8:	f8e43423          	sd	a4,-120(s0)
    800005bc:	4605                	li	a2,1
    800005be:	45a9                	li	a1,10
    800005c0:	4388                	lw	a0,0(a5)
    800005c2:	e6fff0ef          	jal	80000430 <printint>
    800005c6:	b761                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005c8:	03678663          	beq	a5,s6,800005f4 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005cc:	05878263          	beq	a5,s8,80000610 <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800005d0:	0b978463          	beq	a5,s9,80000678 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800005d4:	fda797e3          	bne	a5,s10,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800005d8:	f8843783          	ld	a5,-120(s0)
    800005dc:	00878713          	addi	a4,a5,8
    800005e0:	f8e43423          	sd	a4,-120(s0)
    800005e4:	4601                	li	a2,0
    800005e6:	45c1                	li	a1,16
    800005e8:	6388                	ld	a0,0(a5)
    800005ea:	e47ff0ef          	jal	80000430 <printint>
      i += 1;
    800005ee:	0029849b          	addiw	s1,s3,2
    800005f2:	bfb1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800005f4:	f8843783          	ld	a5,-120(s0)
    800005f8:	00878713          	addi	a4,a5,8
    800005fc:	f8e43423          	sd	a4,-120(s0)
    80000600:	4605                	li	a2,1
    80000602:	45a9                	li	a1,10
    80000604:	6388                	ld	a0,0(a5)
    80000606:	e2bff0ef          	jal	80000430 <printint>
      i += 1;
    8000060a:	0029849b          	addiw	s1,s3,2
    8000060e:	b781                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000610:	06400793          	li	a5,100
    80000614:	02f68863          	beq	a3,a5,80000644 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000618:	07500793          	li	a5,117
    8000061c:	06f68c63          	beq	a3,a5,80000694 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000620:	07800793          	li	a5,120
    80000624:	f6f69fe3          	bne	a3,a5,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80000628:	f8843783          	ld	a5,-120(s0)
    8000062c:	00878713          	addi	a4,a5,8
    80000630:	f8e43423          	sd	a4,-120(s0)
    80000634:	4601                	li	a2,0
    80000636:	45c1                	li	a1,16
    80000638:	6388                	ld	a0,0(a5)
    8000063a:	df7ff0ef          	jal	80000430 <printint>
      i += 2;
    8000063e:	0039849b          	addiw	s1,s3,3
    80000642:	b731                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4605                	li	a2,1
    80000652:	45a9                	li	a1,10
    80000654:	6388                	ld	a0,0(a5)
    80000656:	ddbff0ef          	jal	80000430 <printint>
      i += 2;
    8000065a:	0039849b          	addiw	s1,s3,3
    8000065e:	bdc5                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    80000660:	f8843783          	ld	a5,-120(s0)
    80000664:	00878713          	addi	a4,a5,8
    80000668:	f8e43423          	sd	a4,-120(s0)
    8000066c:	4601                	li	a2,0
    8000066e:	45a9                	li	a1,10
    80000670:	4388                	lw	a0,0(a5)
    80000672:	dbfff0ef          	jal	80000430 <printint>
    80000676:	bde1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	4601                	li	a2,0
    80000686:	45a9                	li	a1,10
    80000688:	6388                	ld	a0,0(a5)
    8000068a:	da7ff0ef          	jal	80000430 <printint>
      i += 1;
    8000068e:	0029849b          	addiw	s1,s3,2
    80000692:	bd75                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000694:	f8843783          	ld	a5,-120(s0)
    80000698:	00878713          	addi	a4,a5,8
    8000069c:	f8e43423          	sd	a4,-120(s0)
    800006a0:	4601                	li	a2,0
    800006a2:	45a9                	li	a1,10
    800006a4:	6388                	ld	a0,0(a5)
    800006a6:	d8bff0ef          	jal	80000430 <printint>
      i += 2;
    800006aa:	0039849b          	addiw	s1,s3,3
    800006ae:	b545                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006b0:	f8843783          	ld	a5,-120(s0)
    800006b4:	00878713          	addi	a4,a5,8
    800006b8:	f8e43423          	sd	a4,-120(s0)
    800006bc:	4601                	li	a2,0
    800006be:	45c1                	li	a1,16
    800006c0:	4388                	lw	a0,0(a5)
    800006c2:	d6fff0ef          	jal	80000430 <printint>
    800006c6:	b561                	j	8000054e <printf+0x8c>
    800006c8:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006ca:	f8843783          	ld	a5,-120(s0)
    800006ce:	00878713          	addi	a4,a5,8
    800006d2:	f8e43423          	sd	a4,-120(s0)
    800006d6:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006da:	03000513          	li	a0,48
    800006de:	b63ff0ef          	jal	80000240 <consputc>
  consputc('x');
    800006e2:	07800513          	li	a0,120
    800006e6:	b5bff0ef          	jal	80000240 <consputc>
    800006ea:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ec:	00007b97          	auipc	s7,0x7
    800006f0:	444b8b93          	addi	s7,s7,1092 # 80007b30 <digits>
    800006f4:	03c9d793          	srli	a5,s3,0x3c
    800006f8:	97de                	add	a5,a5,s7
    800006fa:	0007c503          	lbu	a0,0(a5)
    800006fe:	b43ff0ef          	jal	80000240 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000702:	0992                	slli	s3,s3,0x4
    80000704:	397d                	addiw	s2,s2,-1
    80000706:	fe0917e3          	bnez	s2,800006f4 <printf+0x232>
    8000070a:	6ba6                	ld	s7,72(sp)
    8000070c:	b589                	j	8000054e <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000070e:	f8843783          	ld	a5,-120(s0)
    80000712:	00878713          	addi	a4,a5,8
    80000716:	f8e43423          	sd	a4,-120(s0)
    8000071a:	0007b903          	ld	s2,0(a5)
    8000071e:	00090d63          	beqz	s2,80000738 <printf+0x276>
      for(; *s; s++)
    80000722:	00094503          	lbu	a0,0(s2)
    80000726:	e20504e3          	beqz	a0,8000054e <printf+0x8c>
        consputc(*s);
    8000072a:	b17ff0ef          	jal	80000240 <consputc>
      for(; *s; s++)
    8000072e:	0905                	addi	s2,s2,1
    80000730:	00094503          	lbu	a0,0(s2)
    80000734:	f97d                	bnez	a0,8000072a <printf+0x268>
    80000736:	bd21                	j	8000054e <printf+0x8c>
        s = "(null)";
    80000738:	00007917          	auipc	s2,0x7
    8000073c:	8d090913          	addi	s2,s2,-1840 # 80007008 <etext+0x8>
      for(; *s; s++)
    80000740:	02800513          	li	a0,40
    80000744:	b7dd                	j	8000072a <printf+0x268>
      consputc('%');
    80000746:	02500513          	li	a0,37
    8000074a:	af7ff0ef          	jal	80000240 <consputc>
    8000074e:	b501                	j	8000054e <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80000750:	f7843783          	ld	a5,-136(s0)
    80000754:	e385                	bnez	a5,80000774 <printf+0x2b2>
    80000756:	74e6                	ld	s1,120(sp)
    80000758:	7946                	ld	s2,112(sp)
    8000075a:	79a6                	ld	s3,104(sp)
    8000075c:	6ae6                	ld	s5,88(sp)
    8000075e:	6b46                	ld	s6,80(sp)
    80000760:	6c06                	ld	s8,64(sp)
    80000762:	7ce2                	ld	s9,56(sp)
    80000764:	7d42                	ld	s10,48(sp)
    80000766:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80000768:	4501                	li	a0,0
    8000076a:	60aa                	ld	ra,136(sp)
    8000076c:	640a                	ld	s0,128(sp)
    8000076e:	7a06                	ld	s4,96(sp)
    80000770:	6169                	addi	sp,sp,208
    80000772:	8082                	ret
    80000774:	74e6                	ld	s1,120(sp)
    80000776:	7946                	ld	s2,112(sp)
    80000778:	79a6                	ld	s3,104(sp)
    8000077a:	6ae6                	ld	s5,88(sp)
    8000077c:	6b46                	ld	s6,80(sp)
    8000077e:	6c06                	ld	s8,64(sp)
    80000780:	7ce2                	ld	s9,56(sp)
    80000782:	7d42                	ld	s10,48(sp)
    80000784:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80000786:	00012517          	auipc	a0,0x12
    8000078a:	06250513          	addi	a0,a0,98 # 800127e8 <pr>
    8000078e:	4fe000ef          	jal	80000c8c <release>
    80000792:	bfd9                	j	80000768 <printf+0x2a6>

0000000080000794 <panic>:

void
panic(char *s)
{
    80000794:	1101                	addi	sp,sp,-32
    80000796:	ec06                	sd	ra,24(sp)
    80000798:	e822                	sd	s0,16(sp)
    8000079a:	e426                	sd	s1,8(sp)
    8000079c:	1000                	addi	s0,sp,32
    8000079e:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007a0:	00012797          	auipc	a5,0x12
    800007a4:	0607a023          	sw	zero,96(a5) # 80012800 <pr+0x18>
  printf("panic: ");
    800007a8:	00007517          	auipc	a0,0x7
    800007ac:	87050513          	addi	a0,a0,-1936 # 80007018 <etext+0x18>
    800007b0:	d13ff0ef          	jal	800004c2 <printf>
  printf("%s\n", s);
    800007b4:	85a6                	mv	a1,s1
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	86a50513          	addi	a0,a0,-1942 # 80007020 <etext+0x20>
    800007be:	d05ff0ef          	jal	800004c2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007c2:	4785                	li	a5,1
    800007c4:	0000a717          	auipc	a4,0xa
    800007c8:	f2f72e23          	sw	a5,-196(a4) # 8000a700 <panicked>
  for(;;)
    800007cc:	a001                	j	800007cc <panic+0x38>

00000000800007ce <printfinit>:
    ;
}

void
printfinit(void)
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007d8:	00012497          	auipc	s1,0x12
    800007dc:	01048493          	addi	s1,s1,16 # 800127e8 <pr>
    800007e0:	00007597          	auipc	a1,0x7
    800007e4:	84858593          	addi	a1,a1,-1976 # 80007028 <etext+0x28>
    800007e8:	8526                	mv	a0,s1
    800007ea:	38a000ef          	jal	80000b74 <initlock>
  pr.locking = 1;
    800007ee:	4785                	li	a5,1
    800007f0:	cc9c                	sw	a5,24(s1)
}
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007fc:	1141                	addi	sp,sp,-16
    800007fe:	e406                	sd	ra,8(sp)
    80000800:	e022                	sd	s0,0(sp)
    80000802:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000804:	100007b7          	lui	a5,0x10000
    80000808:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000080c:	10000737          	lui	a4,0x10000
    80000810:	f8000693          	li	a3,-128
    80000814:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000818:	468d                	li	a3,3
    8000081a:	10000637          	lui	a2,0x10000
    8000081e:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000822:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000826:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000082a:	10000737          	lui	a4,0x10000
    8000082e:	461d                	li	a2,7
    80000830:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000834:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000838:	00006597          	auipc	a1,0x6
    8000083c:	7f858593          	addi	a1,a1,2040 # 80007030 <etext+0x30>
    80000840:	00012517          	auipc	a0,0x12
    80000844:	fc850513          	addi	a0,a0,-56 # 80012808 <uart_tx_lock>
    80000848:	32c000ef          	jal	80000b74 <initlock>
}
    8000084c:	60a2                	ld	ra,8(sp)
    8000084e:	6402                	ld	s0,0(sp)
    80000850:	0141                	addi	sp,sp,16
    80000852:	8082                	ret

0000000080000854 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	1000                	addi	s0,sp,32
    8000085e:	84aa                	mv	s1,a0
  push_off();
    80000860:	354000ef          	jal	80000bb4 <push_off>

  if(panicked){
    80000864:	0000a797          	auipc	a5,0xa
    80000868:	e9c7a783          	lw	a5,-356(a5) # 8000a700 <panicked>
    8000086c:	e795                	bnez	a5,80000898 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000086e:	10000737          	lui	a4,0x10000
    80000872:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000874:	00074783          	lbu	a5,0(a4)
    80000878:	0207f793          	andi	a5,a5,32
    8000087c:	dfe5                	beqz	a5,80000874 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000087e:	0ff4f513          	zext.b	a0,s1
    80000882:	100007b7          	lui	a5,0x10000
    80000886:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000088a:	3ae000ef          	jal	80000c38 <pop_off>
}
    8000088e:	60e2                	ld	ra,24(sp)
    80000890:	6442                	ld	s0,16(sp)
    80000892:	64a2                	ld	s1,8(sp)
    80000894:	6105                	addi	sp,sp,32
    80000896:	8082                	ret
    for(;;)
    80000898:	a001                	j	80000898 <uartputc_sync+0x44>

000000008000089a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000089a:	0000a797          	auipc	a5,0xa
    8000089e:	e6e7b783          	ld	a5,-402(a5) # 8000a708 <uart_tx_r>
    800008a2:	0000a717          	auipc	a4,0xa
    800008a6:	e6e73703          	ld	a4,-402(a4) # 8000a710 <uart_tx_w>
    800008aa:	08f70263          	beq	a4,a5,8000092e <uartstart+0x94>
{
    800008ae:	7139                	addi	sp,sp,-64
    800008b0:	fc06                	sd	ra,56(sp)
    800008b2:	f822                	sd	s0,48(sp)
    800008b4:	f426                	sd	s1,40(sp)
    800008b6:	f04a                	sd	s2,32(sp)
    800008b8:	ec4e                	sd	s3,24(sp)
    800008ba:	e852                	sd	s4,16(sp)
    800008bc:	e456                	sd	s5,8(sp)
    800008be:	e05a                	sd	s6,0(sp)
    800008c0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008c2:	10000937          	lui	s2,0x10000
    800008c6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008c8:	00012a97          	auipc	s5,0x12
    800008cc:	f40a8a93          	addi	s5,s5,-192 # 80012808 <uart_tx_lock>
    uart_tx_r += 1;
    800008d0:	0000a497          	auipc	s1,0xa
    800008d4:	e3848493          	addi	s1,s1,-456 # 8000a708 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008d8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008dc:	0000a997          	auipc	s3,0xa
    800008e0:	e3498993          	addi	s3,s3,-460 # 8000a710 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008e4:	00094703          	lbu	a4,0(s2)
    800008e8:	02077713          	andi	a4,a4,32
    800008ec:	c71d                	beqz	a4,8000091a <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ee:	01f7f713          	andi	a4,a5,31
    800008f2:	9756                	add	a4,a4,s5
    800008f4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008f8:	0785                	addi	a5,a5,1
    800008fa:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008fc:	8526                	mv	a0,s1
    800008fe:	5fc010ef          	jal	80001efa <wakeup>
    WriteReg(THR, c);
    80000902:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000906:	609c                	ld	a5,0(s1)
    80000908:	0009b703          	ld	a4,0(s3)
    8000090c:	fcf71ce3          	bne	a4,a5,800008e4 <uartstart+0x4a>
      ReadReg(ISR);
    80000910:	100007b7          	lui	a5,0x10000
    80000914:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000916:	0007c783          	lbu	a5,0(a5)
  }
}
    8000091a:	70e2                	ld	ra,56(sp)
    8000091c:	7442                	ld	s0,48(sp)
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	69e2                	ld	s3,24(sp)
    80000924:	6a42                	ld	s4,16(sp)
    80000926:	6aa2                	ld	s5,8(sp)
    80000928:	6b02                	ld	s6,0(sp)
    8000092a:	6121                	addi	sp,sp,64
    8000092c:	8082                	ret
      ReadReg(ISR);
    8000092e:	100007b7          	lui	a5,0x10000
    80000932:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000934:	0007c783          	lbu	a5,0(a5)
      return;
    80000938:	8082                	ret

000000008000093a <uartputc>:
{
    8000093a:	7179                	addi	sp,sp,-48
    8000093c:	f406                	sd	ra,40(sp)
    8000093e:	f022                	sd	s0,32(sp)
    80000940:	ec26                	sd	s1,24(sp)
    80000942:	e84a                	sd	s2,16(sp)
    80000944:	e44e                	sd	s3,8(sp)
    80000946:	e052                	sd	s4,0(sp)
    80000948:	1800                	addi	s0,sp,48
    8000094a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000094c:	00012517          	auipc	a0,0x12
    80000950:	ebc50513          	addi	a0,a0,-324 # 80012808 <uart_tx_lock>
    80000954:	2a0000ef          	jal	80000bf4 <acquire>
  if(panicked){
    80000958:	0000a797          	auipc	a5,0xa
    8000095c:	da87a783          	lw	a5,-600(a5) # 8000a700 <panicked>
    80000960:	efbd                	bnez	a5,800009de <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000962:	0000a717          	auipc	a4,0xa
    80000966:	dae73703          	ld	a4,-594(a4) # 8000a710 <uart_tx_w>
    8000096a:	0000a797          	auipc	a5,0xa
    8000096e:	d9e7b783          	ld	a5,-610(a5) # 8000a708 <uart_tx_r>
    80000972:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000976:	00012997          	auipc	s3,0x12
    8000097a:	e9298993          	addi	s3,s3,-366 # 80012808 <uart_tx_lock>
    8000097e:	0000a497          	auipc	s1,0xa
    80000982:	d8a48493          	addi	s1,s1,-630 # 8000a708 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	0000a917          	auipc	s2,0xa
    8000098a:	d8a90913          	addi	s2,s2,-630 # 8000a710 <uart_tx_w>
    8000098e:	00e79d63          	bne	a5,a4,800009a8 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000992:	85ce                	mv	a1,s3
    80000994:	8526                	mv	a0,s1
    80000996:	518010ef          	jal	80001eae <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099a:	00093703          	ld	a4,0(s2)
    8000099e:	609c                	ld	a5,0(s1)
    800009a0:	02078793          	addi	a5,a5,32
    800009a4:	fee787e3          	beq	a5,a4,80000992 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a8:	00012497          	auipc	s1,0x12
    800009ac:	e6048493          	addi	s1,s1,-416 # 80012808 <uart_tx_lock>
    800009b0:	01f77793          	andi	a5,a4,31
    800009b4:	97a6                	add	a5,a5,s1
    800009b6:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009ba:	0705                	addi	a4,a4,1
    800009bc:	0000a797          	auipc	a5,0xa
    800009c0:	d4e7ba23          	sd	a4,-684(a5) # 8000a710 <uart_tx_w>
  uartstart();
    800009c4:	ed7ff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    800009c8:	8526                	mv	a0,s1
    800009ca:	2c2000ef          	jal	80000c8c <release>
}
    800009ce:	70a2                	ld	ra,40(sp)
    800009d0:	7402                	ld	s0,32(sp)
    800009d2:	64e2                	ld	s1,24(sp)
    800009d4:	6942                	ld	s2,16(sp)
    800009d6:	69a2                	ld	s3,8(sp)
    800009d8:	6a02                	ld	s4,0(sp)
    800009da:	6145                	addi	sp,sp,48
    800009dc:	8082                	ret
    for(;;)
    800009de:	a001                	j	800009de <uartputc+0xa4>

00000000800009e0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009e0:	1141                	addi	sp,sp,-16
    800009e2:	e422                	sd	s0,8(sp)
    800009e4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009e6:	100007b7          	lui	a5,0x10000
    800009ea:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009ec:	0007c783          	lbu	a5,0(a5)
    800009f0:	8b85                	andi	a5,a5,1
    800009f2:	cb81                	beqz	a5,80000a02 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009f4:	100007b7          	lui	a5,0x10000
    800009f8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009fc:	6422                	ld	s0,8(sp)
    800009fe:	0141                	addi	sp,sp,16
    80000a00:	8082                	ret
    return -1;
    80000a02:	557d                	li	a0,-1
    80000a04:	bfe5                	j	800009fc <uartgetc+0x1c>

0000000080000a06 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a06:	1101                	addi	sp,sp,-32
    80000a08:	ec06                	sd	ra,24(sp)
    80000a0a:	e822                	sd	s0,16(sp)
    80000a0c:	e426                	sd	s1,8(sp)
    80000a0e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a10:	54fd                	li	s1,-1
    80000a12:	a019                	j	80000a18 <uartintr+0x12>
      break;
    consoleintr(c);
    80000a14:	85fff0ef          	jal	80000272 <consoleintr>
    int c = uartgetc();
    80000a18:	fc9ff0ef          	jal	800009e0 <uartgetc>
    if(c == -1)
    80000a1c:	fe951ce3          	bne	a0,s1,80000a14 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a20:	00012497          	auipc	s1,0x12
    80000a24:	de848493          	addi	s1,s1,-536 # 80012808 <uart_tx_lock>
    80000a28:	8526                	mv	a0,s1
    80000a2a:	1ca000ef          	jal	80000bf4 <acquire>
  uartstart();
    80000a2e:	e6dff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    80000a32:	8526                	mv	a0,s1
    80000a34:	258000ef          	jal	80000c8c <release>
}
    80000a38:	60e2                	ld	ra,24(sp)
    80000a3a:	6442                	ld	s0,16(sp)
    80000a3c:	64a2                	ld	s1,8(sp)
    80000a3e:	6105                	addi	sp,sp,32
    80000a40:	8082                	ret

0000000080000a42 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a42:	1101                	addi	sp,sp,-32
    80000a44:	ec06                	sd	ra,24(sp)
    80000a46:	e822                	sd	s0,16(sp)
    80000a48:	e426                	sd	s1,8(sp)
    80000a4a:	e04a                	sd	s2,0(sp)
    80000a4c:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a4e:	03451793          	slli	a5,a0,0x34
    80000a52:	e7a9                	bnez	a5,80000a9c <kfree+0x5a>
    80000a54:	84aa                	mv	s1,a0
    80000a56:	00023797          	auipc	a5,0x23
    80000a5a:	01a78793          	addi	a5,a5,26 # 80023a70 <end>
    80000a5e:	02f56f63          	bltu	a0,a5,80000a9c <kfree+0x5a>
    80000a62:	47c5                	li	a5,17
    80000a64:	07ee                	slli	a5,a5,0x1b
    80000a66:	02f57b63          	bgeu	a0,a5,80000a9c <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a6a:	6605                	lui	a2,0x1
    80000a6c:	4585                	li	a1,1
    80000a6e:	25a000ef          	jal	80000cc8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a72:	00012917          	auipc	s2,0x12
    80000a76:	dce90913          	addi	s2,s2,-562 # 80012840 <kmem>
    80000a7a:	854a                	mv	a0,s2
    80000a7c:	178000ef          	jal	80000bf4 <acquire>
  r->next = kmem.freelist;
    80000a80:	01893783          	ld	a5,24(s2)
    80000a84:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a86:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a8a:	854a                	mv	a0,s2
    80000a8c:	200000ef          	jal	80000c8c <release>
}
    80000a90:	60e2                	ld	ra,24(sp)
    80000a92:	6442                	ld	s0,16(sp)
    80000a94:	64a2                	ld	s1,8(sp)
    80000a96:	6902                	ld	s2,0(sp)
    80000a98:	6105                	addi	sp,sp,32
    80000a9a:	8082                	ret
    panic("kfree");
    80000a9c:	00006517          	auipc	a0,0x6
    80000aa0:	59c50513          	addi	a0,a0,1436 # 80007038 <etext+0x38>
    80000aa4:	cf1ff0ef          	jal	80000794 <panic>

0000000080000aa8 <freerange>:
{
    80000aa8:	7179                	addi	sp,sp,-48
    80000aaa:	f406                	sd	ra,40(sp)
    80000aac:	f022                	sd	s0,32(sp)
    80000aae:	ec26                	sd	s1,24(sp)
    80000ab0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab2:	6785                	lui	a5,0x1
    80000ab4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ab8:	00e504b3          	add	s1,a0,a4
    80000abc:	777d                	lui	a4,0xfffff
    80000abe:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac0:	94be                	add	s1,s1,a5
    80000ac2:	0295e263          	bltu	a1,s1,80000ae6 <freerange+0x3e>
    80000ac6:	e84a                	sd	s2,16(sp)
    80000ac8:	e44e                	sd	s3,8(sp)
    80000aca:	e052                	sd	s4,0(sp)
    80000acc:	892e                	mv	s2,a1
    kfree(p);
    80000ace:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad0:	6985                	lui	s3,0x1
    kfree(p);
    80000ad2:	01448533          	add	a0,s1,s4
    80000ad6:	f6dff0ef          	jal	80000a42 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ada:	94ce                	add	s1,s1,s3
    80000adc:	fe997be3          	bgeu	s2,s1,80000ad2 <freerange+0x2a>
    80000ae0:	6942                	ld	s2,16(sp)
    80000ae2:	69a2                	ld	s3,8(sp)
    80000ae4:	6a02                	ld	s4,0(sp)
}
    80000ae6:	70a2                	ld	ra,40(sp)
    80000ae8:	7402                	ld	s0,32(sp)
    80000aea:	64e2                	ld	s1,24(sp)
    80000aec:	6145                	addi	sp,sp,48
    80000aee:	8082                	ret

0000000080000af0 <kinit>:
{
    80000af0:	1141                	addi	sp,sp,-16
    80000af2:	e406                	sd	ra,8(sp)
    80000af4:	e022                	sd	s0,0(sp)
    80000af6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af8:	00006597          	auipc	a1,0x6
    80000afc:	54858593          	addi	a1,a1,1352 # 80007040 <etext+0x40>
    80000b00:	00012517          	auipc	a0,0x12
    80000b04:	d4050513          	addi	a0,a0,-704 # 80012840 <kmem>
    80000b08:	06c000ef          	jal	80000b74 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b0c:	45c5                	li	a1,17
    80000b0e:	05ee                	slli	a1,a1,0x1b
    80000b10:	00023517          	auipc	a0,0x23
    80000b14:	f6050513          	addi	a0,a0,-160 # 80023a70 <end>
    80000b18:	f91ff0ef          	jal	80000aa8 <freerange>
}
    80000b1c:	60a2                	ld	ra,8(sp)
    80000b1e:	6402                	ld	s0,0(sp)
    80000b20:	0141                	addi	sp,sp,16
    80000b22:	8082                	ret

0000000080000b24 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b24:	1101                	addi	sp,sp,-32
    80000b26:	ec06                	sd	ra,24(sp)
    80000b28:	e822                	sd	s0,16(sp)
    80000b2a:	e426                	sd	s1,8(sp)
    80000b2c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b2e:	00012497          	auipc	s1,0x12
    80000b32:	d1248493          	addi	s1,s1,-750 # 80012840 <kmem>
    80000b36:	8526                	mv	a0,s1
    80000b38:	0bc000ef          	jal	80000bf4 <acquire>
  r = kmem.freelist;
    80000b3c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3e:	c485                	beqz	s1,80000b66 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b40:	609c                	ld	a5,0(s1)
    80000b42:	00012517          	auipc	a0,0x12
    80000b46:	cfe50513          	addi	a0,a0,-770 # 80012840 <kmem>
    80000b4a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b4c:	140000ef          	jal	80000c8c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b50:	6605                	lui	a2,0x1
    80000b52:	4595                	li	a1,5
    80000b54:	8526                	mv	a0,s1
    80000b56:	172000ef          	jal	80000cc8 <memset>
  return (void*)r;
}
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	60e2                	ld	ra,24(sp)
    80000b5e:	6442                	ld	s0,16(sp)
    80000b60:	64a2                	ld	s1,8(sp)
    80000b62:	6105                	addi	sp,sp,32
    80000b64:	8082                	ret
  release(&kmem.lock);
    80000b66:	00012517          	auipc	a0,0x12
    80000b6a:	cda50513          	addi	a0,a0,-806 # 80012840 <kmem>
    80000b6e:	11e000ef          	jal	80000c8c <release>
  if(r)
    80000b72:	b7e5                	j	80000b5a <kalloc+0x36>

0000000080000b74 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b74:	1141                	addi	sp,sp,-16
    80000b76:	e422                	sd	s0,8(sp)
    80000b78:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b7a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b7c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b80:	00053823          	sd	zero,16(a0)
}
    80000b84:	6422                	ld	s0,8(sp)
    80000b86:	0141                	addi	sp,sp,16
    80000b88:	8082                	ret

0000000080000b8a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b8a:	411c                	lw	a5,0(a0)
    80000b8c:	e399                	bnez	a5,80000b92 <holding+0x8>
    80000b8e:	4501                	li	a0,0
  return r;
}
    80000b90:	8082                	ret
{
    80000b92:	1101                	addi	sp,sp,-32
    80000b94:	ec06                	sd	ra,24(sp)
    80000b96:	e822                	sd	s0,16(sp)
    80000b98:	e426                	sd	s1,8(sp)
    80000b9a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b9c:	6904                	ld	s1,16(a0)
    80000b9e:	527000ef          	jal	800018c4 <mycpu>
    80000ba2:	40a48533          	sub	a0,s1,a0
    80000ba6:	00153513          	seqz	a0,a0
}
    80000baa:	60e2                	ld	ra,24(sp)
    80000bac:	6442                	ld	s0,16(sp)
    80000bae:	64a2                	ld	s1,8(sp)
    80000bb0:	6105                	addi	sp,sp,32
    80000bb2:	8082                	ret

0000000080000bb4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb4:	1101                	addi	sp,sp,-32
    80000bb6:	ec06                	sd	ra,24(sp)
    80000bb8:	e822                	sd	s0,16(sp)
    80000bba:	e426                	sd	s1,8(sp)
    80000bbc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bbe:	100024f3          	csrr	s1,sstatus
    80000bc2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bc8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bcc:	4f9000ef          	jal	800018c4 <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cb99                	beqz	a5,80000be8 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	4f1000ef          	jal	800018c4 <mycpu>
    80000bd8:	5d3c                	lw	a5,120(a0)
    80000bda:	2785                	addiw	a5,a5,1
    80000bdc:	dd3c                	sw	a5,120(a0)
}
    80000bde:	60e2                	ld	ra,24(sp)
    80000be0:	6442                	ld	s0,16(sp)
    80000be2:	64a2                	ld	s1,8(sp)
    80000be4:	6105                	addi	sp,sp,32
    80000be6:	8082                	ret
    mycpu()->intena = old;
    80000be8:	4dd000ef          	jal	800018c4 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bec:	8085                	srli	s1,s1,0x1
    80000bee:	8885                	andi	s1,s1,1
    80000bf0:	dd64                	sw	s1,124(a0)
    80000bf2:	b7cd                	j	80000bd4 <push_off+0x20>

0000000080000bf4 <acquire>:
{
    80000bf4:	1101                	addi	sp,sp,-32
    80000bf6:	ec06                	sd	ra,24(sp)
    80000bf8:	e822                	sd	s0,16(sp)
    80000bfa:	e426                	sd	s1,8(sp)
    80000bfc:	1000                	addi	s0,sp,32
    80000bfe:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c00:	fb5ff0ef          	jal	80000bb4 <push_off>
  if(holding(lk))
    80000c04:	8526                	mv	a0,s1
    80000c06:	f85ff0ef          	jal	80000b8a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0a:	4705                	li	a4,1
  if(holding(lk))
    80000c0c:	e105                	bnez	a0,80000c2c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0e:	87ba                	mv	a5,a4
    80000c10:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c14:	2781                	sext.w	a5,a5
    80000c16:	ffe5                	bnez	a5,80000c0e <acquire+0x1a>
  __sync_synchronize();
    80000c18:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c1c:	4a9000ef          	jal	800018c4 <mycpu>
    80000c20:	e888                	sd	a0,16(s1)
}
    80000c22:	60e2                	ld	ra,24(sp)
    80000c24:	6442                	ld	s0,16(sp)
    80000c26:	64a2                	ld	s1,8(sp)
    80000c28:	6105                	addi	sp,sp,32
    80000c2a:	8082                	ret
    panic("acquire");
    80000c2c:	00006517          	auipc	a0,0x6
    80000c30:	41c50513          	addi	a0,a0,1052 # 80007048 <etext+0x48>
    80000c34:	b61ff0ef          	jal	80000794 <panic>

0000000080000c38 <pop_off>:

void
pop_off(void)
{
    80000c38:	1141                	addi	sp,sp,-16
    80000c3a:	e406                	sd	ra,8(sp)
    80000c3c:	e022                	sd	s0,0(sp)
    80000c3e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c40:	485000ef          	jal	800018c4 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c44:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c48:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c4a:	e78d                	bnez	a5,80000c74 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c4c:	5d3c                	lw	a5,120(a0)
    80000c4e:	02f05963          	blez	a5,80000c80 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c52:	37fd                	addiw	a5,a5,-1
    80000c54:	0007871b          	sext.w	a4,a5
    80000c58:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c5a:	eb09                	bnez	a4,80000c6c <pop_off+0x34>
    80000c5c:	5d7c                	lw	a5,124(a0)
    80000c5e:	c799                	beqz	a5,80000c6c <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c60:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c64:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c68:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c6c:	60a2                	ld	ra,8(sp)
    80000c6e:	6402                	ld	s0,0(sp)
    80000c70:	0141                	addi	sp,sp,16
    80000c72:	8082                	ret
    panic("pop_off - interruptible");
    80000c74:	00006517          	auipc	a0,0x6
    80000c78:	3dc50513          	addi	a0,a0,988 # 80007050 <etext+0x50>
    80000c7c:	b19ff0ef          	jal	80000794 <panic>
    panic("pop_off");
    80000c80:	00006517          	auipc	a0,0x6
    80000c84:	3e850513          	addi	a0,a0,1000 # 80007068 <etext+0x68>
    80000c88:	b0dff0ef          	jal	80000794 <panic>

0000000080000c8c <release>:
{
    80000c8c:	1101                	addi	sp,sp,-32
    80000c8e:	ec06                	sd	ra,24(sp)
    80000c90:	e822                	sd	s0,16(sp)
    80000c92:	e426                	sd	s1,8(sp)
    80000c94:	1000                	addi	s0,sp,32
    80000c96:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c98:	ef3ff0ef          	jal	80000b8a <holding>
    80000c9c:	c105                	beqz	a0,80000cbc <release+0x30>
  lk->cpu = 0;
    80000c9e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca2:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000ca6:	0310000f          	fence	rw,w
    80000caa:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cae:	f8bff0ef          	jal	80000c38 <pop_off>
}
    80000cb2:	60e2                	ld	ra,24(sp)
    80000cb4:	6442                	ld	s0,16(sp)
    80000cb6:	64a2                	ld	s1,8(sp)
    80000cb8:	6105                	addi	sp,sp,32
    80000cba:	8082                	ret
    panic("release");
    80000cbc:	00006517          	auipc	a0,0x6
    80000cc0:	3b450513          	addi	a0,a0,948 # 80007070 <etext+0x70>
    80000cc4:	ad1ff0ef          	jal	80000794 <panic>

0000000080000cc8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cc8:	1141                	addi	sp,sp,-16
    80000cca:	e422                	sd	s0,8(sp)
    80000ccc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cce:	ca19                	beqz	a2,80000ce4 <memset+0x1c>
    80000cd0:	87aa                	mv	a5,a0
    80000cd2:	1602                	slli	a2,a2,0x20
    80000cd4:	9201                	srli	a2,a2,0x20
    80000cd6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cda:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cde:	0785                	addi	a5,a5,1
    80000ce0:	fee79de3          	bne	a5,a4,80000cda <memset+0x12>
  }
  return dst;
}
    80000ce4:	6422                	ld	s0,8(sp)
    80000ce6:	0141                	addi	sp,sp,16
    80000ce8:	8082                	ret

0000000080000cea <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cea:	1141                	addi	sp,sp,-16
    80000cec:	e422                	sd	s0,8(sp)
    80000cee:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf0:	ca05                	beqz	a2,80000d20 <memcmp+0x36>
    80000cf2:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cf6:	1682                	slli	a3,a3,0x20
    80000cf8:	9281                	srli	a3,a3,0x20
    80000cfa:	0685                	addi	a3,a3,1
    80000cfc:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cfe:	00054783          	lbu	a5,0(a0)
    80000d02:	0005c703          	lbu	a4,0(a1)
    80000d06:	00e79863          	bne	a5,a4,80000d16 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d0a:	0505                	addi	a0,a0,1
    80000d0c:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d0e:	fed518e3          	bne	a0,a3,80000cfe <memcmp+0x14>
  }

  return 0;
    80000d12:	4501                	li	a0,0
    80000d14:	a019                	j	80000d1a <memcmp+0x30>
      return *s1 - *s2;
    80000d16:	40e7853b          	subw	a0,a5,a4
}
    80000d1a:	6422                	ld	s0,8(sp)
    80000d1c:	0141                	addi	sp,sp,16
    80000d1e:	8082                	ret
  return 0;
    80000d20:	4501                	li	a0,0
    80000d22:	bfe5                	j	80000d1a <memcmp+0x30>

0000000080000d24 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d24:	1141                	addi	sp,sp,-16
    80000d26:	e422                	sd	s0,8(sp)
    80000d28:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d2a:	c205                	beqz	a2,80000d4a <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d2c:	02a5e263          	bltu	a1,a0,80000d50 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d30:	1602                	slli	a2,a2,0x20
    80000d32:	9201                	srli	a2,a2,0x20
    80000d34:	00c587b3          	add	a5,a1,a2
{
    80000d38:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d3a:	0585                	addi	a1,a1,1
    80000d3c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb591>
    80000d3e:	fff5c683          	lbu	a3,-1(a1)
    80000d42:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d46:	feb79ae3          	bne	a5,a1,80000d3a <memmove+0x16>

  return dst;
}
    80000d4a:	6422                	ld	s0,8(sp)
    80000d4c:	0141                	addi	sp,sp,16
    80000d4e:	8082                	ret
  if(s < d && s + n > d){
    80000d50:	02061693          	slli	a3,a2,0x20
    80000d54:	9281                	srli	a3,a3,0x20
    80000d56:	00d58733          	add	a4,a1,a3
    80000d5a:	fce57be3          	bgeu	a0,a4,80000d30 <memmove+0xc>
    d += n;
    80000d5e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d60:	fff6079b          	addiw	a5,a2,-1
    80000d64:	1782                	slli	a5,a5,0x20
    80000d66:	9381                	srli	a5,a5,0x20
    80000d68:	fff7c793          	not	a5,a5
    80000d6c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d6e:	177d                	addi	a4,a4,-1
    80000d70:	16fd                	addi	a3,a3,-1
    80000d72:	00074603          	lbu	a2,0(a4)
    80000d76:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d7a:	fef71ae3          	bne	a4,a5,80000d6e <memmove+0x4a>
    80000d7e:	b7f1                	j	80000d4a <memmove+0x26>

0000000080000d80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d80:	1141                	addi	sp,sp,-16
    80000d82:	e406                	sd	ra,8(sp)
    80000d84:	e022                	sd	s0,0(sp)
    80000d86:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d88:	f9dff0ef          	jal	80000d24 <memmove>
}
    80000d8c:	60a2                	ld	ra,8(sp)
    80000d8e:	6402                	ld	s0,0(sp)
    80000d90:	0141                	addi	sp,sp,16
    80000d92:	8082                	ret

0000000080000d94 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d94:	1141                	addi	sp,sp,-16
    80000d96:	e422                	sd	s0,8(sp)
    80000d98:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d9a:	ce11                	beqz	a2,80000db6 <strncmp+0x22>
    80000d9c:	00054783          	lbu	a5,0(a0)
    80000da0:	cf89                	beqz	a5,80000dba <strncmp+0x26>
    80000da2:	0005c703          	lbu	a4,0(a1)
    80000da6:	00f71a63          	bne	a4,a5,80000dba <strncmp+0x26>
    n--, p++, q++;
    80000daa:	367d                	addiw	a2,a2,-1
    80000dac:	0505                	addi	a0,a0,1
    80000dae:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db0:	f675                	bnez	a2,80000d9c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db2:	4501                	li	a0,0
    80000db4:	a801                	j	80000dc4 <strncmp+0x30>
    80000db6:	4501                	li	a0,0
    80000db8:	a031                	j	80000dc4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000dba:	00054503          	lbu	a0,0(a0)
    80000dbe:	0005c783          	lbu	a5,0(a1)
    80000dc2:	9d1d                	subw	a0,a0,a5
}
    80000dc4:	6422                	ld	s0,8(sp)
    80000dc6:	0141                	addi	sp,sp,16
    80000dc8:	8082                	ret

0000000080000dca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dca:	1141                	addi	sp,sp,-16
    80000dcc:	e422                	sd	s0,8(sp)
    80000dce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dd0:	87aa                	mv	a5,a0
    80000dd2:	86b2                	mv	a3,a2
    80000dd4:	367d                	addiw	a2,a2,-1
    80000dd6:	02d05563          	blez	a3,80000e00 <strncpy+0x36>
    80000dda:	0785                	addi	a5,a5,1
    80000ddc:	0005c703          	lbu	a4,0(a1)
    80000de0:	fee78fa3          	sb	a4,-1(a5)
    80000de4:	0585                	addi	a1,a1,1
    80000de6:	f775                	bnez	a4,80000dd2 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000de8:	873e                	mv	a4,a5
    80000dea:	9fb5                	addw	a5,a5,a3
    80000dec:	37fd                	addiw	a5,a5,-1
    80000dee:	00c05963          	blez	a2,80000e00 <strncpy+0x36>
    *s++ = 0;
    80000df2:	0705                	addi	a4,a4,1
    80000df4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000df8:	40e786bb          	subw	a3,a5,a4
    80000dfc:	fed04be3          	bgtz	a3,80000df2 <strncpy+0x28>
  return os;
}
    80000e00:	6422                	ld	s0,8(sp)
    80000e02:	0141                	addi	sp,sp,16
    80000e04:	8082                	ret

0000000080000e06 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e06:	1141                	addi	sp,sp,-16
    80000e08:	e422                	sd	s0,8(sp)
    80000e0a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e0c:	02c05363          	blez	a2,80000e32 <safestrcpy+0x2c>
    80000e10:	fff6069b          	addiw	a3,a2,-1
    80000e14:	1682                	slli	a3,a3,0x20
    80000e16:	9281                	srli	a3,a3,0x20
    80000e18:	96ae                	add	a3,a3,a1
    80000e1a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e1c:	00d58963          	beq	a1,a3,80000e2e <safestrcpy+0x28>
    80000e20:	0585                	addi	a1,a1,1
    80000e22:	0785                	addi	a5,a5,1
    80000e24:	fff5c703          	lbu	a4,-1(a1)
    80000e28:	fee78fa3          	sb	a4,-1(a5)
    80000e2c:	fb65                	bnez	a4,80000e1c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e2e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <strlen>:

int
strlen(const char *s)
{
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e422                	sd	s0,8(sp)
    80000e3c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e3e:	00054783          	lbu	a5,0(a0)
    80000e42:	cf91                	beqz	a5,80000e5e <strlen+0x26>
    80000e44:	0505                	addi	a0,a0,1
    80000e46:	87aa                	mv	a5,a0
    80000e48:	86be                	mv	a3,a5
    80000e4a:	0785                	addi	a5,a5,1
    80000e4c:	fff7c703          	lbu	a4,-1(a5)
    80000e50:	ff65                	bnez	a4,80000e48 <strlen+0x10>
    80000e52:	40a6853b          	subw	a0,a3,a0
    80000e56:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e58:	6422                	ld	s0,8(sp)
    80000e5a:	0141                	addi	sp,sp,16
    80000e5c:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e5e:	4501                	li	a0,0
    80000e60:	bfe5                	j	80000e58 <strlen+0x20>

0000000080000e62 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e406                	sd	ra,8(sp)
    80000e66:	e022                	sd	s0,0(sp)
    80000e68:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e6a:	24b000ef          	jal	800018b4 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e6e:	0000a717          	auipc	a4,0xa
    80000e72:	8aa70713          	addi	a4,a4,-1878 # 8000a718 <started>
  if(cpuid() == 0){
    80000e76:	c51d                	beqz	a0,80000ea4 <main+0x42>
    while(started == 0)
    80000e78:	431c                	lw	a5,0(a4)
    80000e7a:	2781                	sext.w	a5,a5
    80000e7c:	dff5                	beqz	a5,80000e78 <main+0x16>
      ;
    __sync_synchronize();
    80000e7e:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000e82:	233000ef          	jal	800018b4 <cpuid>
    80000e86:	85aa                	mv	a1,a0
    80000e88:	00006517          	auipc	a0,0x6
    80000e8c:	21050513          	addi	a0,a0,528 # 80007098 <etext+0x98>
    80000e90:	e32ff0ef          	jal	800004c2 <printf>
    kvminithart();    // turn on paging
    80000e94:	080000ef          	jal	80000f14 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e98:	538010ef          	jal	800023d0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e9c:	79c040ef          	jal	80005638 <plicinithart>
  }

  scheduler();        
    80000ea0:	675000ef          	jal	80001d14 <scheduler>
    consoleinit();
    80000ea4:	d48ff0ef          	jal	800003ec <consoleinit>
    printfinit();
    80000ea8:	927ff0ef          	jal	800007ce <printfinit>
    printf("\n");
    80000eac:	00006517          	auipc	a0,0x6
    80000eb0:	1cc50513          	addi	a0,a0,460 # 80007078 <etext+0x78>
    80000eb4:	e0eff0ef          	jal	800004c2 <printf>
    printf("xv6 kernel is booting\n");
    80000eb8:	00006517          	auipc	a0,0x6
    80000ebc:	1c850513          	addi	a0,a0,456 # 80007080 <etext+0x80>
    80000ec0:	e02ff0ef          	jal	800004c2 <printf>
    printf("\n");
    80000ec4:	00006517          	auipc	a0,0x6
    80000ec8:	1b450513          	addi	a0,a0,436 # 80007078 <etext+0x78>
    80000ecc:	df6ff0ef          	jal	800004c2 <printf>
    kinit();         // physical page allocator
    80000ed0:	c21ff0ef          	jal	80000af0 <kinit>
    kvminit();       // create kernel page table
    80000ed4:	2ca000ef          	jal	8000119e <kvminit>
    kvminithart();   // turn on paging
    80000ed8:	03c000ef          	jal	80000f14 <kvminithart>
    procinit();      // process table
    80000edc:	123000ef          	jal	800017fe <procinit>
    trapinit();      // trap vectors
    80000ee0:	4cc010ef          	jal	800023ac <trapinit>
    trapinithart();  // install kernel trap vector
    80000ee4:	4ec010ef          	jal	800023d0 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ee8:	736040ef          	jal	8000561e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000eec:	74c040ef          	jal	80005638 <plicinithart>
    binit();         // buffer cache
    80000ef0:	6ef010ef          	jal	80002dde <binit>
    iinit();         // inode table
    80000ef4:	4e0020ef          	jal	800033d4 <iinit>
    fileinit();      // file table
    80000ef8:	28c030ef          	jal	80004184 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efc:	02d040ef          	jal	80005728 <virtio_disk_init>
    userinit();      // first user process
    80000f00:	449000ef          	jal	80001b48 <userinit>
    __sync_synchronize();
    80000f04:	0330000f          	fence	rw,rw
    started = 1;
    80000f08:	4785                	li	a5,1
    80000f0a:	0000a717          	auipc	a4,0xa
    80000f0e:	80f72723          	sw	a5,-2034(a4) # 8000a718 <started>
    80000f12:	b779                	j	80000ea0 <main+0x3e>

0000000080000f14 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f14:	1141                	addi	sp,sp,-16
    80000f16:	e422                	sd	s0,8(sp)
    80000f18:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f1a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f1e:	0000a797          	auipc	a5,0xa
    80000f22:	8027b783          	ld	a5,-2046(a5) # 8000a720 <kernel_pagetable>
    80000f26:	83b1                	srli	a5,a5,0xc
    80000f28:	577d                	li	a4,-1
    80000f2a:	177e                	slli	a4,a4,0x3f
    80000f2c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f2e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f32:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f36:	6422                	ld	s0,8(sp)
    80000f38:	0141                	addi	sp,sp,16
    80000f3a:	8082                	ret

0000000080000f3c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f3c:	7139                	addi	sp,sp,-64
    80000f3e:	fc06                	sd	ra,56(sp)
    80000f40:	f822                	sd	s0,48(sp)
    80000f42:	f426                	sd	s1,40(sp)
    80000f44:	f04a                	sd	s2,32(sp)
    80000f46:	ec4e                	sd	s3,24(sp)
    80000f48:	e852                	sd	s4,16(sp)
    80000f4a:	e456                	sd	s5,8(sp)
    80000f4c:	e05a                	sd	s6,0(sp)
    80000f4e:	0080                	addi	s0,sp,64
    80000f50:	84aa                	mv	s1,a0
    80000f52:	89ae                	mv	s3,a1
    80000f54:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f56:	57fd                	li	a5,-1
    80000f58:	83e9                	srli	a5,a5,0x1a
    80000f5a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f5c:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f5e:	02b7fc63          	bgeu	a5,a1,80000f96 <walk+0x5a>
    panic("walk");
    80000f62:	00006517          	auipc	a0,0x6
    80000f66:	14e50513          	addi	a0,a0,334 # 800070b0 <etext+0xb0>
    80000f6a:	82bff0ef          	jal	80000794 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f6e:	060a8263          	beqz	s5,80000fd2 <walk+0x96>
    80000f72:	bb3ff0ef          	jal	80000b24 <kalloc>
    80000f76:	84aa                	mv	s1,a0
    80000f78:	c139                	beqz	a0,80000fbe <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f7a:	6605                	lui	a2,0x1
    80000f7c:	4581                	li	a1,0
    80000f7e:	d4bff0ef          	jal	80000cc8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f82:	00c4d793          	srli	a5,s1,0xc
    80000f86:	07aa                	slli	a5,a5,0xa
    80000f88:	0017e793          	ori	a5,a5,1
    80000f8c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f90:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb587>
    80000f92:	036a0063          	beq	s4,s6,80000fb2 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f96:	0149d933          	srl	s2,s3,s4
    80000f9a:	1ff97913          	andi	s2,s2,511
    80000f9e:	090e                	slli	s2,s2,0x3
    80000fa0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fa2:	00093483          	ld	s1,0(s2)
    80000fa6:	0014f793          	andi	a5,s1,1
    80000faa:	d3f1                	beqz	a5,80000f6e <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fac:	80a9                	srli	s1,s1,0xa
    80000fae:	04b2                	slli	s1,s1,0xc
    80000fb0:	b7c5                	j	80000f90 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000fb2:	00c9d513          	srli	a0,s3,0xc
    80000fb6:	1ff57513          	andi	a0,a0,511
    80000fba:	050e                	slli	a0,a0,0x3
    80000fbc:	9526                	add	a0,a0,s1
}
    80000fbe:	70e2                	ld	ra,56(sp)
    80000fc0:	7442                	ld	s0,48(sp)
    80000fc2:	74a2                	ld	s1,40(sp)
    80000fc4:	7902                	ld	s2,32(sp)
    80000fc6:	69e2                	ld	s3,24(sp)
    80000fc8:	6a42                	ld	s4,16(sp)
    80000fca:	6aa2                	ld	s5,8(sp)
    80000fcc:	6b02                	ld	s6,0(sp)
    80000fce:	6121                	addi	sp,sp,64
    80000fd0:	8082                	ret
        return 0;
    80000fd2:	4501                	li	a0,0
    80000fd4:	b7ed                	j	80000fbe <walk+0x82>

0000000080000fd6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fd6:	57fd                	li	a5,-1
    80000fd8:	83e9                	srli	a5,a5,0x1a
    80000fda:	00b7f463          	bgeu	a5,a1,80000fe2 <walkaddr+0xc>
    return 0;
    80000fde:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fe0:	8082                	ret
{
    80000fe2:	1141                	addi	sp,sp,-16
    80000fe4:	e406                	sd	ra,8(sp)
    80000fe6:	e022                	sd	s0,0(sp)
    80000fe8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fea:	4601                	li	a2,0
    80000fec:	f51ff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    80000ff0:	c105                	beqz	a0,80001010 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000ff2:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000ff4:	0117f693          	andi	a3,a5,17
    80000ff8:	4745                	li	a4,17
    return 0;
    80000ffa:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000ffc:	00e68663          	beq	a3,a4,80001008 <walkaddr+0x32>
}
    80001000:	60a2                	ld	ra,8(sp)
    80001002:	6402                	ld	s0,0(sp)
    80001004:	0141                	addi	sp,sp,16
    80001006:	8082                	ret
  pa = PTE2PA(*pte);
    80001008:	83a9                	srli	a5,a5,0xa
    8000100a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000100e:	bfcd                	j	80001000 <walkaddr+0x2a>
    return 0;
    80001010:	4501                	li	a0,0
    80001012:	b7fd                	j	80001000 <walkaddr+0x2a>

0000000080001014 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001014:	715d                	addi	sp,sp,-80
    80001016:	e486                	sd	ra,72(sp)
    80001018:	e0a2                	sd	s0,64(sp)
    8000101a:	fc26                	sd	s1,56(sp)
    8000101c:	f84a                	sd	s2,48(sp)
    8000101e:	f44e                	sd	s3,40(sp)
    80001020:	f052                	sd	s4,32(sp)
    80001022:	ec56                	sd	s5,24(sp)
    80001024:	e85a                	sd	s6,16(sp)
    80001026:	e45e                	sd	s7,8(sp)
    80001028:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000102a:	03459793          	slli	a5,a1,0x34
    8000102e:	e7a9                	bnez	a5,80001078 <mappages+0x64>
    80001030:	8aaa                	mv	s5,a0
    80001032:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001034:	03461793          	slli	a5,a2,0x34
    80001038:	e7b1                	bnez	a5,80001084 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    8000103a:	ca39                	beqz	a2,80001090 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000103c:	77fd                	lui	a5,0xfffff
    8000103e:	963e                	add	a2,a2,a5
    80001040:	00b609b3          	add	s3,a2,a1
  a = va;
    80001044:	892e                	mv	s2,a1
    80001046:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000104a:	6b85                	lui	s7,0x1
    8000104c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001050:	4605                	li	a2,1
    80001052:	85ca                	mv	a1,s2
    80001054:	8556                	mv	a0,s5
    80001056:	ee7ff0ef          	jal	80000f3c <walk>
    8000105a:	c539                	beqz	a0,800010a8 <mappages+0x94>
    if(*pte & PTE_V)
    8000105c:	611c                	ld	a5,0(a0)
    8000105e:	8b85                	andi	a5,a5,1
    80001060:	ef95                	bnez	a5,8000109c <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001062:	80b1                	srli	s1,s1,0xc
    80001064:	04aa                	slli	s1,s1,0xa
    80001066:	0164e4b3          	or	s1,s1,s6
    8000106a:	0014e493          	ori	s1,s1,1
    8000106e:	e104                	sd	s1,0(a0)
    if(a == last)
    80001070:	05390863          	beq	s2,s3,800010c0 <mappages+0xac>
    a += PGSIZE;
    80001074:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001076:	bfd9                	j	8000104c <mappages+0x38>
    panic("mappages: va not aligned");
    80001078:	00006517          	auipc	a0,0x6
    8000107c:	04050513          	addi	a0,a0,64 # 800070b8 <etext+0xb8>
    80001080:	f14ff0ef          	jal	80000794 <panic>
    panic("mappages: size not aligned");
    80001084:	00006517          	auipc	a0,0x6
    80001088:	05450513          	addi	a0,a0,84 # 800070d8 <etext+0xd8>
    8000108c:	f08ff0ef          	jal	80000794 <panic>
    panic("mappages: size");
    80001090:	00006517          	auipc	a0,0x6
    80001094:	06850513          	addi	a0,a0,104 # 800070f8 <etext+0xf8>
    80001098:	efcff0ef          	jal	80000794 <panic>
      panic("mappages: remap");
    8000109c:	00006517          	auipc	a0,0x6
    800010a0:	06c50513          	addi	a0,a0,108 # 80007108 <etext+0x108>
    800010a4:	ef0ff0ef          	jal	80000794 <panic>
      return -1;
    800010a8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010aa:	60a6                	ld	ra,72(sp)
    800010ac:	6406                	ld	s0,64(sp)
    800010ae:	74e2                	ld	s1,56(sp)
    800010b0:	7942                	ld	s2,48(sp)
    800010b2:	79a2                	ld	s3,40(sp)
    800010b4:	7a02                	ld	s4,32(sp)
    800010b6:	6ae2                	ld	s5,24(sp)
    800010b8:	6b42                	ld	s6,16(sp)
    800010ba:	6ba2                	ld	s7,8(sp)
    800010bc:	6161                	addi	sp,sp,80
    800010be:	8082                	ret
  return 0;
    800010c0:	4501                	li	a0,0
    800010c2:	b7e5                	j	800010aa <mappages+0x96>

00000000800010c4 <kvmmap>:
{
    800010c4:	1141                	addi	sp,sp,-16
    800010c6:	e406                	sd	ra,8(sp)
    800010c8:	e022                	sd	s0,0(sp)
    800010ca:	0800                	addi	s0,sp,16
    800010cc:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010ce:	86b2                	mv	a3,a2
    800010d0:	863e                	mv	a2,a5
    800010d2:	f43ff0ef          	jal	80001014 <mappages>
    800010d6:	e509                	bnez	a0,800010e0 <kvmmap+0x1c>
}
    800010d8:	60a2                	ld	ra,8(sp)
    800010da:	6402                	ld	s0,0(sp)
    800010dc:	0141                	addi	sp,sp,16
    800010de:	8082                	ret
    panic("kvmmap");
    800010e0:	00006517          	auipc	a0,0x6
    800010e4:	03850513          	addi	a0,a0,56 # 80007118 <etext+0x118>
    800010e8:	eacff0ef          	jal	80000794 <panic>

00000000800010ec <kvmmake>:
{
    800010ec:	1101                	addi	sp,sp,-32
    800010ee:	ec06                	sd	ra,24(sp)
    800010f0:	e822                	sd	s0,16(sp)
    800010f2:	e426                	sd	s1,8(sp)
    800010f4:	e04a                	sd	s2,0(sp)
    800010f6:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010f8:	a2dff0ef          	jal	80000b24 <kalloc>
    800010fc:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010fe:	6605                	lui	a2,0x1
    80001100:	4581                	li	a1,0
    80001102:	bc7ff0ef          	jal	80000cc8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001106:	4719                	li	a4,6
    80001108:	6685                	lui	a3,0x1
    8000110a:	10000637          	lui	a2,0x10000
    8000110e:	100005b7          	lui	a1,0x10000
    80001112:	8526                	mv	a0,s1
    80001114:	fb1ff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001118:	4719                	li	a4,6
    8000111a:	6685                	lui	a3,0x1
    8000111c:	10001637          	lui	a2,0x10001
    80001120:	100015b7          	lui	a1,0x10001
    80001124:	8526                	mv	a0,s1
    80001126:	f9fff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000112a:	4719                	li	a4,6
    8000112c:	040006b7          	lui	a3,0x4000
    80001130:	0c000637          	lui	a2,0xc000
    80001134:	0c0005b7          	lui	a1,0xc000
    80001138:	8526                	mv	a0,s1
    8000113a:	f8bff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000113e:	00006917          	auipc	s2,0x6
    80001142:	ec290913          	addi	s2,s2,-318 # 80007000 <etext>
    80001146:	4729                	li	a4,10
    80001148:	80006697          	auipc	a3,0x80006
    8000114c:	eb868693          	addi	a3,a3,-328 # 7000 <_entry-0x7fff9000>
    80001150:	4605                	li	a2,1
    80001152:	067e                	slli	a2,a2,0x1f
    80001154:	85b2                	mv	a1,a2
    80001156:	8526                	mv	a0,s1
    80001158:	f6dff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000115c:	46c5                	li	a3,17
    8000115e:	06ee                	slli	a3,a3,0x1b
    80001160:	4719                	li	a4,6
    80001162:	412686b3          	sub	a3,a3,s2
    80001166:	864a                	mv	a2,s2
    80001168:	85ca                	mv	a1,s2
    8000116a:	8526                	mv	a0,s1
    8000116c:	f59ff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001170:	4729                	li	a4,10
    80001172:	6685                	lui	a3,0x1
    80001174:	00005617          	auipc	a2,0x5
    80001178:	e8c60613          	addi	a2,a2,-372 # 80006000 <_trampoline>
    8000117c:	040005b7          	lui	a1,0x4000
    80001180:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001182:	05b2                	slli	a1,a1,0xc
    80001184:	8526                	mv	a0,s1
    80001186:	f3fff0ef          	jal	800010c4 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000118a:	8526                	mv	a0,s1
    8000118c:	5da000ef          	jal	80001766 <proc_mapstacks>
}
    80001190:	8526                	mv	a0,s1
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	64a2                	ld	s1,8(sp)
    80001198:	6902                	ld	s2,0(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret

000000008000119e <kvminit>:
{
    8000119e:	1141                	addi	sp,sp,-16
    800011a0:	e406                	sd	ra,8(sp)
    800011a2:	e022                	sd	s0,0(sp)
    800011a4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011a6:	f47ff0ef          	jal	800010ec <kvmmake>
    800011aa:	00009797          	auipc	a5,0x9
    800011ae:	56a7bb23          	sd	a0,1398(a5) # 8000a720 <kernel_pagetable>
}
    800011b2:	60a2                	ld	ra,8(sp)
    800011b4:	6402                	ld	s0,0(sp)
    800011b6:	0141                	addi	sp,sp,16
    800011b8:	8082                	ret

00000000800011ba <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011ba:	715d                	addi	sp,sp,-80
    800011bc:	e486                	sd	ra,72(sp)
    800011be:	e0a2                	sd	s0,64(sp)
    800011c0:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011c2:	03459793          	slli	a5,a1,0x34
    800011c6:	e39d                	bnez	a5,800011ec <uvmunmap+0x32>
    800011c8:	f84a                	sd	s2,48(sp)
    800011ca:	f44e                	sd	s3,40(sp)
    800011cc:	f052                	sd	s4,32(sp)
    800011ce:	ec56                	sd	s5,24(sp)
    800011d0:	e85a                	sd	s6,16(sp)
    800011d2:	e45e                	sd	s7,8(sp)
    800011d4:	8a2a                	mv	s4,a0
    800011d6:	892e                	mv	s2,a1
    800011d8:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011da:	0632                	slli	a2,a2,0xc
    800011dc:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800011e0:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011e2:	6b05                	lui	s6,0x1
    800011e4:	0735ff63          	bgeu	a1,s3,80001262 <uvmunmap+0xa8>
    800011e8:	fc26                	sd	s1,56(sp)
    800011ea:	a0a9                	j	80001234 <uvmunmap+0x7a>
    800011ec:	fc26                	sd	s1,56(sp)
    800011ee:	f84a                	sd	s2,48(sp)
    800011f0:	f44e                	sd	s3,40(sp)
    800011f2:	f052                	sd	s4,32(sp)
    800011f4:	ec56                	sd	s5,24(sp)
    800011f6:	e85a                	sd	s6,16(sp)
    800011f8:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800011fa:	00006517          	auipc	a0,0x6
    800011fe:	f2650513          	addi	a0,a0,-218 # 80007120 <etext+0x120>
    80001202:	d92ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: walk");
    80001206:	00006517          	auipc	a0,0x6
    8000120a:	f3250513          	addi	a0,a0,-206 # 80007138 <etext+0x138>
    8000120e:	d86ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not mapped");
    80001212:	00006517          	auipc	a0,0x6
    80001216:	f3650513          	addi	a0,a0,-202 # 80007148 <etext+0x148>
    8000121a:	d7aff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not a leaf");
    8000121e:	00006517          	auipc	a0,0x6
    80001222:	f4250513          	addi	a0,a0,-190 # 80007160 <etext+0x160>
    80001226:	d6eff0ef          	jal	80000794 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000122a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000122e:	995a                	add	s2,s2,s6
    80001230:	03397863          	bgeu	s2,s3,80001260 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001234:	4601                	li	a2,0
    80001236:	85ca                	mv	a1,s2
    80001238:	8552                	mv	a0,s4
    8000123a:	d03ff0ef          	jal	80000f3c <walk>
    8000123e:	84aa                	mv	s1,a0
    80001240:	d179                	beqz	a0,80001206 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001242:	6108                	ld	a0,0(a0)
    80001244:	00157793          	andi	a5,a0,1
    80001248:	d7e9                	beqz	a5,80001212 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000124a:	3ff57793          	andi	a5,a0,1023
    8000124e:	fd7788e3          	beq	a5,s7,8000121e <uvmunmap+0x64>
    if(do_free){
    80001252:	fc0a8ce3          	beqz	s5,8000122a <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001256:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001258:	0532                	slli	a0,a0,0xc
    8000125a:	fe8ff0ef          	jal	80000a42 <kfree>
    8000125e:	b7f1                	j	8000122a <uvmunmap+0x70>
    80001260:	74e2                	ld	s1,56(sp)
    80001262:	7942                	ld	s2,48(sp)
    80001264:	79a2                	ld	s3,40(sp)
    80001266:	7a02                	ld	s4,32(sp)
    80001268:	6ae2                	ld	s5,24(sp)
    8000126a:	6b42                	ld	s6,16(sp)
    8000126c:	6ba2                	ld	s7,8(sp)
  }
}
    8000126e:	60a6                	ld	ra,72(sp)
    80001270:	6406                	ld	s0,64(sp)
    80001272:	6161                	addi	sp,sp,80
    80001274:	8082                	ret

0000000080001276 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001276:	1101                	addi	sp,sp,-32
    80001278:	ec06                	sd	ra,24(sp)
    8000127a:	e822                	sd	s0,16(sp)
    8000127c:	e426                	sd	s1,8(sp)
    8000127e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001280:	8a5ff0ef          	jal	80000b24 <kalloc>
    80001284:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001286:	c509                	beqz	a0,80001290 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001288:	6605                	lui	a2,0x1
    8000128a:	4581                	li	a1,0
    8000128c:	a3dff0ef          	jal	80000cc8 <memset>
  return pagetable;
}
    80001290:	8526                	mv	a0,s1
    80001292:	60e2                	ld	ra,24(sp)
    80001294:	6442                	ld	s0,16(sp)
    80001296:	64a2                	ld	s1,8(sp)
    80001298:	6105                	addi	sp,sp,32
    8000129a:	8082                	ret

000000008000129c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000129c:	7179                	addi	sp,sp,-48
    8000129e:	f406                	sd	ra,40(sp)
    800012a0:	f022                	sd	s0,32(sp)
    800012a2:	ec26                	sd	s1,24(sp)
    800012a4:	e84a                	sd	s2,16(sp)
    800012a6:	e44e                	sd	s3,8(sp)
    800012a8:	e052                	sd	s4,0(sp)
    800012aa:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012ac:	6785                	lui	a5,0x1
    800012ae:	04f67063          	bgeu	a2,a5,800012ee <uvmfirst+0x52>
    800012b2:	8a2a                	mv	s4,a0
    800012b4:	89ae                	mv	s3,a1
    800012b6:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012b8:	86dff0ef          	jal	80000b24 <kalloc>
    800012bc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012be:	6605                	lui	a2,0x1
    800012c0:	4581                	li	a1,0
    800012c2:	a07ff0ef          	jal	80000cc8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012c6:	4779                	li	a4,30
    800012c8:	86ca                	mv	a3,s2
    800012ca:	6605                	lui	a2,0x1
    800012cc:	4581                	li	a1,0
    800012ce:	8552                	mv	a0,s4
    800012d0:	d45ff0ef          	jal	80001014 <mappages>
  memmove(mem, src, sz);
    800012d4:	8626                	mv	a2,s1
    800012d6:	85ce                	mv	a1,s3
    800012d8:	854a                	mv	a0,s2
    800012da:	a4bff0ef          	jal	80000d24 <memmove>
}
    800012de:	70a2                	ld	ra,40(sp)
    800012e0:	7402                	ld	s0,32(sp)
    800012e2:	64e2                	ld	s1,24(sp)
    800012e4:	6942                	ld	s2,16(sp)
    800012e6:	69a2                	ld	s3,8(sp)
    800012e8:	6a02                	ld	s4,0(sp)
    800012ea:	6145                	addi	sp,sp,48
    800012ec:	8082                	ret
    panic("uvmfirst: more than a page");
    800012ee:	00006517          	auipc	a0,0x6
    800012f2:	e8a50513          	addi	a0,a0,-374 # 80007178 <etext+0x178>
    800012f6:	c9eff0ef          	jal	80000794 <panic>

00000000800012fa <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800012fa:	1101                	addi	sp,sp,-32
    800012fc:	ec06                	sd	ra,24(sp)
    800012fe:	e822                	sd	s0,16(sp)
    80001300:	e426                	sd	s1,8(sp)
    80001302:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001304:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001306:	00b67d63          	bgeu	a2,a1,80001320 <uvmdealloc+0x26>
    8000130a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000130c:	6785                	lui	a5,0x1
    8000130e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001310:	00f60733          	add	a4,a2,a5
    80001314:	76fd                	lui	a3,0xfffff
    80001316:	8f75                	and	a4,a4,a3
    80001318:	97ae                	add	a5,a5,a1
    8000131a:	8ff5                	and	a5,a5,a3
    8000131c:	00f76863          	bltu	a4,a5,8000132c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001320:	8526                	mv	a0,s1
    80001322:	60e2                	ld	ra,24(sp)
    80001324:	6442                	ld	s0,16(sp)
    80001326:	64a2                	ld	s1,8(sp)
    80001328:	6105                	addi	sp,sp,32
    8000132a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000132c:	8f99                	sub	a5,a5,a4
    8000132e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001330:	4685                	li	a3,1
    80001332:	0007861b          	sext.w	a2,a5
    80001336:	85ba                	mv	a1,a4
    80001338:	e83ff0ef          	jal	800011ba <uvmunmap>
    8000133c:	b7d5                	j	80001320 <uvmdealloc+0x26>

000000008000133e <uvmalloc>:
  if(newsz < oldsz)
    8000133e:	08b66f63          	bltu	a2,a1,800013dc <uvmalloc+0x9e>
{
    80001342:	7139                	addi	sp,sp,-64
    80001344:	fc06                	sd	ra,56(sp)
    80001346:	f822                	sd	s0,48(sp)
    80001348:	ec4e                	sd	s3,24(sp)
    8000134a:	e852                	sd	s4,16(sp)
    8000134c:	e456                	sd	s5,8(sp)
    8000134e:	0080                	addi	s0,sp,64
    80001350:	8aaa                	mv	s5,a0
    80001352:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001354:	6785                	lui	a5,0x1
    80001356:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001358:	95be                	add	a1,a1,a5
    8000135a:	77fd                	lui	a5,0xfffff
    8000135c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001360:	08c9f063          	bgeu	s3,a2,800013e0 <uvmalloc+0xa2>
    80001364:	f426                	sd	s1,40(sp)
    80001366:	f04a                	sd	s2,32(sp)
    80001368:	e05a                	sd	s6,0(sp)
    8000136a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000136c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001370:	fb4ff0ef          	jal	80000b24 <kalloc>
    80001374:	84aa                	mv	s1,a0
    if(mem == 0){
    80001376:	c515                	beqz	a0,800013a2 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001378:	6605                	lui	a2,0x1
    8000137a:	4581                	li	a1,0
    8000137c:	94dff0ef          	jal	80000cc8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001380:	875a                	mv	a4,s6
    80001382:	86a6                	mv	a3,s1
    80001384:	6605                	lui	a2,0x1
    80001386:	85ca                	mv	a1,s2
    80001388:	8556                	mv	a0,s5
    8000138a:	c8bff0ef          	jal	80001014 <mappages>
    8000138e:	e915                	bnez	a0,800013c2 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001390:	6785                	lui	a5,0x1
    80001392:	993e                	add	s2,s2,a5
    80001394:	fd496ee3          	bltu	s2,s4,80001370 <uvmalloc+0x32>
  return newsz;
    80001398:	8552                	mv	a0,s4
    8000139a:	74a2                	ld	s1,40(sp)
    8000139c:	7902                	ld	s2,32(sp)
    8000139e:	6b02                	ld	s6,0(sp)
    800013a0:	a811                	j	800013b4 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800013a2:	864e                	mv	a2,s3
    800013a4:	85ca                	mv	a1,s2
    800013a6:	8556                	mv	a0,s5
    800013a8:	f53ff0ef          	jal	800012fa <uvmdealloc>
      return 0;
    800013ac:	4501                	li	a0,0
    800013ae:	74a2                	ld	s1,40(sp)
    800013b0:	7902                	ld	s2,32(sp)
    800013b2:	6b02                	ld	s6,0(sp)
}
    800013b4:	70e2                	ld	ra,56(sp)
    800013b6:	7442                	ld	s0,48(sp)
    800013b8:	69e2                	ld	s3,24(sp)
    800013ba:	6a42                	ld	s4,16(sp)
    800013bc:	6aa2                	ld	s5,8(sp)
    800013be:	6121                	addi	sp,sp,64
    800013c0:	8082                	ret
      kfree(mem);
    800013c2:	8526                	mv	a0,s1
    800013c4:	e7eff0ef          	jal	80000a42 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013c8:	864e                	mv	a2,s3
    800013ca:	85ca                	mv	a1,s2
    800013cc:	8556                	mv	a0,s5
    800013ce:	f2dff0ef          	jal	800012fa <uvmdealloc>
      return 0;
    800013d2:	4501                	li	a0,0
    800013d4:	74a2                	ld	s1,40(sp)
    800013d6:	7902                	ld	s2,32(sp)
    800013d8:	6b02                	ld	s6,0(sp)
    800013da:	bfe9                	j	800013b4 <uvmalloc+0x76>
    return oldsz;
    800013dc:	852e                	mv	a0,a1
}
    800013de:	8082                	ret
  return newsz;
    800013e0:	8532                	mv	a0,a2
    800013e2:	bfc9                	j	800013b4 <uvmalloc+0x76>

00000000800013e4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800013e4:	7179                	addi	sp,sp,-48
    800013e6:	f406                	sd	ra,40(sp)
    800013e8:	f022                	sd	s0,32(sp)
    800013ea:	ec26                	sd	s1,24(sp)
    800013ec:	e84a                	sd	s2,16(sp)
    800013ee:	e44e                	sd	s3,8(sp)
    800013f0:	e052                	sd	s4,0(sp)
    800013f2:	1800                	addi	s0,sp,48
    800013f4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800013f6:	84aa                	mv	s1,a0
    800013f8:	6905                	lui	s2,0x1
    800013fa:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013fc:	4985                	li	s3,1
    800013fe:	a819                	j	80001414 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001400:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001402:	00c79513          	slli	a0,a5,0xc
    80001406:	fdfff0ef          	jal	800013e4 <freewalk>
      pagetable[i] = 0;
    8000140a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000140e:	04a1                	addi	s1,s1,8
    80001410:	01248f63          	beq	s1,s2,8000142e <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001414:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001416:	00f7f713          	andi	a4,a5,15
    8000141a:	ff3703e3          	beq	a4,s3,80001400 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000141e:	8b85                	andi	a5,a5,1
    80001420:	d7fd                	beqz	a5,8000140e <freewalk+0x2a>
      panic("freewalk: leaf");
    80001422:	00006517          	auipc	a0,0x6
    80001426:	d7650513          	addi	a0,a0,-650 # 80007198 <etext+0x198>
    8000142a:	b6aff0ef          	jal	80000794 <panic>
    }
  }
  kfree((void*)pagetable);
    8000142e:	8552                	mv	a0,s4
    80001430:	e12ff0ef          	jal	80000a42 <kfree>
}
    80001434:	70a2                	ld	ra,40(sp)
    80001436:	7402                	ld	s0,32(sp)
    80001438:	64e2                	ld	s1,24(sp)
    8000143a:	6942                	ld	s2,16(sp)
    8000143c:	69a2                	ld	s3,8(sp)
    8000143e:	6a02                	ld	s4,0(sp)
    80001440:	6145                	addi	sp,sp,48
    80001442:	8082                	ret

0000000080001444 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001444:	1101                	addi	sp,sp,-32
    80001446:	ec06                	sd	ra,24(sp)
    80001448:	e822                	sd	s0,16(sp)
    8000144a:	e426                	sd	s1,8(sp)
    8000144c:	1000                	addi	s0,sp,32
    8000144e:	84aa                	mv	s1,a0
  if(sz > 0)
    80001450:	e989                	bnez	a1,80001462 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001452:	8526                	mv	a0,s1
    80001454:	f91ff0ef          	jal	800013e4 <freewalk>
}
    80001458:	60e2                	ld	ra,24(sp)
    8000145a:	6442                	ld	s0,16(sp)
    8000145c:	64a2                	ld	s1,8(sp)
    8000145e:	6105                	addi	sp,sp,32
    80001460:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001462:	6785                	lui	a5,0x1
    80001464:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001466:	95be                	add	a1,a1,a5
    80001468:	4685                	li	a3,1
    8000146a:	00c5d613          	srli	a2,a1,0xc
    8000146e:	4581                	li	a1,0
    80001470:	d4bff0ef          	jal	800011ba <uvmunmap>
    80001474:	bff9                	j	80001452 <uvmfree+0xe>

0000000080001476 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001476:	c65d                	beqz	a2,80001524 <uvmcopy+0xae>
{
    80001478:	715d                	addi	sp,sp,-80
    8000147a:	e486                	sd	ra,72(sp)
    8000147c:	e0a2                	sd	s0,64(sp)
    8000147e:	fc26                	sd	s1,56(sp)
    80001480:	f84a                	sd	s2,48(sp)
    80001482:	f44e                	sd	s3,40(sp)
    80001484:	f052                	sd	s4,32(sp)
    80001486:	ec56                	sd	s5,24(sp)
    80001488:	e85a                	sd	s6,16(sp)
    8000148a:	e45e                	sd	s7,8(sp)
    8000148c:	0880                	addi	s0,sp,80
    8000148e:	8b2a                	mv	s6,a0
    80001490:	8aae                	mv	s5,a1
    80001492:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001494:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001496:	4601                	li	a2,0
    80001498:	85ce                	mv	a1,s3
    8000149a:	855a                	mv	a0,s6
    8000149c:	aa1ff0ef          	jal	80000f3c <walk>
    800014a0:	c121                	beqz	a0,800014e0 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800014a2:	6118                	ld	a4,0(a0)
    800014a4:	00177793          	andi	a5,a4,1
    800014a8:	c3b1                	beqz	a5,800014ec <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800014aa:	00a75593          	srli	a1,a4,0xa
    800014ae:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014b2:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014b6:	e6eff0ef          	jal	80000b24 <kalloc>
    800014ba:	892a                	mv	s2,a0
    800014bc:	c129                	beqz	a0,800014fe <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014be:	6605                	lui	a2,0x1
    800014c0:	85de                	mv	a1,s7
    800014c2:	863ff0ef          	jal	80000d24 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014c6:	8726                	mv	a4,s1
    800014c8:	86ca                	mv	a3,s2
    800014ca:	6605                	lui	a2,0x1
    800014cc:	85ce                	mv	a1,s3
    800014ce:	8556                	mv	a0,s5
    800014d0:	b45ff0ef          	jal	80001014 <mappages>
    800014d4:	e115                	bnez	a0,800014f8 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    800014d6:	6785                	lui	a5,0x1
    800014d8:	99be                	add	s3,s3,a5
    800014da:	fb49eee3          	bltu	s3,s4,80001496 <uvmcopy+0x20>
    800014de:	a805                	j	8000150e <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    800014e0:	00006517          	auipc	a0,0x6
    800014e4:	cc850513          	addi	a0,a0,-824 # 800071a8 <etext+0x1a8>
    800014e8:	aacff0ef          	jal	80000794 <panic>
      panic("uvmcopy: page not present");
    800014ec:	00006517          	auipc	a0,0x6
    800014f0:	cdc50513          	addi	a0,a0,-804 # 800071c8 <etext+0x1c8>
    800014f4:	aa0ff0ef          	jal	80000794 <panic>
      kfree(mem);
    800014f8:	854a                	mv	a0,s2
    800014fa:	d48ff0ef          	jal	80000a42 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800014fe:	4685                	li	a3,1
    80001500:	00c9d613          	srli	a2,s3,0xc
    80001504:	4581                	li	a1,0
    80001506:	8556                	mv	a0,s5
    80001508:	cb3ff0ef          	jal	800011ba <uvmunmap>
  return -1;
    8000150c:	557d                	li	a0,-1
}
    8000150e:	60a6                	ld	ra,72(sp)
    80001510:	6406                	ld	s0,64(sp)
    80001512:	74e2                	ld	s1,56(sp)
    80001514:	7942                	ld	s2,48(sp)
    80001516:	79a2                	ld	s3,40(sp)
    80001518:	7a02                	ld	s4,32(sp)
    8000151a:	6ae2                	ld	s5,24(sp)
    8000151c:	6b42                	ld	s6,16(sp)
    8000151e:	6ba2                	ld	s7,8(sp)
    80001520:	6161                	addi	sp,sp,80
    80001522:	8082                	ret
  return 0;
    80001524:	4501                	li	a0,0
}
    80001526:	8082                	ret

0000000080001528 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001528:	1141                	addi	sp,sp,-16
    8000152a:	e406                	sd	ra,8(sp)
    8000152c:	e022                	sd	s0,0(sp)
    8000152e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001530:	4601                	li	a2,0
    80001532:	a0bff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    80001536:	c901                	beqz	a0,80001546 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001538:	611c                	ld	a5,0(a0)
    8000153a:	9bbd                	andi	a5,a5,-17
    8000153c:	e11c                	sd	a5,0(a0)
}
    8000153e:	60a2                	ld	ra,8(sp)
    80001540:	6402                	ld	s0,0(sp)
    80001542:	0141                	addi	sp,sp,16
    80001544:	8082                	ret
    panic("uvmclear");
    80001546:	00006517          	auipc	a0,0x6
    8000154a:	ca250513          	addi	a0,a0,-862 # 800071e8 <etext+0x1e8>
    8000154e:	a46ff0ef          	jal	80000794 <panic>

0000000080001552 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001552:	cad1                	beqz	a3,800015e6 <copyout+0x94>
{
    80001554:	711d                	addi	sp,sp,-96
    80001556:	ec86                	sd	ra,88(sp)
    80001558:	e8a2                	sd	s0,80(sp)
    8000155a:	e4a6                	sd	s1,72(sp)
    8000155c:	fc4e                	sd	s3,56(sp)
    8000155e:	f456                	sd	s5,40(sp)
    80001560:	f05a                	sd	s6,32(sp)
    80001562:	ec5e                	sd	s7,24(sp)
    80001564:	1080                	addi	s0,sp,96
    80001566:	8baa                	mv	s7,a0
    80001568:	8aae                	mv	s5,a1
    8000156a:	8b32                	mv	s6,a2
    8000156c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000156e:	74fd                	lui	s1,0xfffff
    80001570:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001572:	57fd                	li	a5,-1
    80001574:	83e9                	srli	a5,a5,0x1a
    80001576:	0697ea63          	bltu	a5,s1,800015ea <copyout+0x98>
    8000157a:	e0ca                	sd	s2,64(sp)
    8000157c:	f852                	sd	s4,48(sp)
    8000157e:	e862                	sd	s8,16(sp)
    80001580:	e466                	sd	s9,8(sp)
    80001582:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001584:	4cd5                	li	s9,21
    80001586:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80001588:	8c3e                	mv	s8,a5
    8000158a:	a025                	j	800015b2 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    8000158c:	83a9                	srli	a5,a5,0xa
    8000158e:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001590:	409a8533          	sub	a0,s5,s1
    80001594:	0009061b          	sext.w	a2,s2
    80001598:	85da                	mv	a1,s6
    8000159a:	953e                	add	a0,a0,a5
    8000159c:	f88ff0ef          	jal	80000d24 <memmove>

    len -= n;
    800015a0:	412989b3          	sub	s3,s3,s2
    src += n;
    800015a4:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800015a6:	02098963          	beqz	s3,800015d8 <copyout+0x86>
    if(va0 >= MAXVA)
    800015aa:	054c6263          	bltu	s8,s4,800015ee <copyout+0x9c>
    800015ae:	84d2                	mv	s1,s4
    800015b0:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800015b2:	4601                	li	a2,0
    800015b4:	85a6                	mv	a1,s1
    800015b6:	855e                	mv	a0,s7
    800015b8:	985ff0ef          	jal	80000f3c <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015bc:	c121                	beqz	a0,800015fc <copyout+0xaa>
    800015be:	611c                	ld	a5,0(a0)
    800015c0:	0157f713          	andi	a4,a5,21
    800015c4:	05971b63          	bne	a4,s9,8000161a <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    800015c8:	01a48a33          	add	s4,s1,s10
    800015cc:	415a0933          	sub	s2,s4,s5
    if(n > len)
    800015d0:	fb29fee3          	bgeu	s3,s2,8000158c <copyout+0x3a>
    800015d4:	894e                	mv	s2,s3
    800015d6:	bf5d                	j	8000158c <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    800015d8:	4501                	li	a0,0
    800015da:	6906                	ld	s2,64(sp)
    800015dc:	7a42                	ld	s4,48(sp)
    800015de:	6c42                	ld	s8,16(sp)
    800015e0:	6ca2                	ld	s9,8(sp)
    800015e2:	6d02                	ld	s10,0(sp)
    800015e4:	a015                	j	80001608 <copyout+0xb6>
    800015e6:	4501                	li	a0,0
}
    800015e8:	8082                	ret
      return -1;
    800015ea:	557d                	li	a0,-1
    800015ec:	a831                	j	80001608 <copyout+0xb6>
    800015ee:	557d                	li	a0,-1
    800015f0:	6906                	ld	s2,64(sp)
    800015f2:	7a42                	ld	s4,48(sp)
    800015f4:	6c42                	ld	s8,16(sp)
    800015f6:	6ca2                	ld	s9,8(sp)
    800015f8:	6d02                	ld	s10,0(sp)
    800015fa:	a039                	j	80001608 <copyout+0xb6>
      return -1;
    800015fc:	557d                	li	a0,-1
    800015fe:	6906                	ld	s2,64(sp)
    80001600:	7a42                	ld	s4,48(sp)
    80001602:	6c42                	ld	s8,16(sp)
    80001604:	6ca2                	ld	s9,8(sp)
    80001606:	6d02                	ld	s10,0(sp)
}
    80001608:	60e6                	ld	ra,88(sp)
    8000160a:	6446                	ld	s0,80(sp)
    8000160c:	64a6                	ld	s1,72(sp)
    8000160e:	79e2                	ld	s3,56(sp)
    80001610:	7aa2                	ld	s5,40(sp)
    80001612:	7b02                	ld	s6,32(sp)
    80001614:	6be2                	ld	s7,24(sp)
    80001616:	6125                	addi	sp,sp,96
    80001618:	8082                	ret
      return -1;
    8000161a:	557d                	li	a0,-1
    8000161c:	6906                	ld	s2,64(sp)
    8000161e:	7a42                	ld	s4,48(sp)
    80001620:	6c42                	ld	s8,16(sp)
    80001622:	6ca2                	ld	s9,8(sp)
    80001624:	6d02                	ld	s10,0(sp)
    80001626:	b7cd                	j	80001608 <copyout+0xb6>

0000000080001628 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001628:	c6a5                	beqz	a3,80001690 <copyin+0x68>
{
    8000162a:	715d                	addi	sp,sp,-80
    8000162c:	e486                	sd	ra,72(sp)
    8000162e:	e0a2                	sd	s0,64(sp)
    80001630:	fc26                	sd	s1,56(sp)
    80001632:	f84a                	sd	s2,48(sp)
    80001634:	f44e                	sd	s3,40(sp)
    80001636:	f052                	sd	s4,32(sp)
    80001638:	ec56                	sd	s5,24(sp)
    8000163a:	e85a                	sd	s6,16(sp)
    8000163c:	e45e                	sd	s7,8(sp)
    8000163e:	e062                	sd	s8,0(sp)
    80001640:	0880                	addi	s0,sp,80
    80001642:	8b2a                	mv	s6,a0
    80001644:	8a2e                	mv	s4,a1
    80001646:	8c32                	mv	s8,a2
    80001648:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000164a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000164c:	6a85                	lui	s5,0x1
    8000164e:	a00d                	j	80001670 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001650:	018505b3          	add	a1,a0,s8
    80001654:	0004861b          	sext.w	a2,s1
    80001658:	412585b3          	sub	a1,a1,s2
    8000165c:	8552                	mv	a0,s4
    8000165e:	ec6ff0ef          	jal	80000d24 <memmove>

    len -= n;
    80001662:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001666:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001668:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000166c:	02098063          	beqz	s3,8000168c <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80001670:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001674:	85ca                	mv	a1,s2
    80001676:	855a                	mv	a0,s6
    80001678:	95fff0ef          	jal	80000fd6 <walkaddr>
    if(pa0 == 0)
    8000167c:	cd01                	beqz	a0,80001694 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    8000167e:	418904b3          	sub	s1,s2,s8
    80001682:	94d6                	add	s1,s1,s5
    if(n > len)
    80001684:	fc99f6e3          	bgeu	s3,s1,80001650 <copyin+0x28>
    80001688:	84ce                	mv	s1,s3
    8000168a:	b7d9                	j	80001650 <copyin+0x28>
  }
  return 0;
    8000168c:	4501                	li	a0,0
    8000168e:	a021                	j	80001696 <copyin+0x6e>
    80001690:	4501                	li	a0,0
}
    80001692:	8082                	ret
      return -1;
    80001694:	557d                	li	a0,-1
}
    80001696:	60a6                	ld	ra,72(sp)
    80001698:	6406                	ld	s0,64(sp)
    8000169a:	74e2                	ld	s1,56(sp)
    8000169c:	7942                	ld	s2,48(sp)
    8000169e:	79a2                	ld	s3,40(sp)
    800016a0:	7a02                	ld	s4,32(sp)
    800016a2:	6ae2                	ld	s5,24(sp)
    800016a4:	6b42                	ld	s6,16(sp)
    800016a6:	6ba2                	ld	s7,8(sp)
    800016a8:	6c02                	ld	s8,0(sp)
    800016aa:	6161                	addi	sp,sp,80
    800016ac:	8082                	ret

00000000800016ae <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800016ae:	c6dd                	beqz	a3,8000175c <copyinstr+0xae>
{
    800016b0:	715d                	addi	sp,sp,-80
    800016b2:	e486                	sd	ra,72(sp)
    800016b4:	e0a2                	sd	s0,64(sp)
    800016b6:	fc26                	sd	s1,56(sp)
    800016b8:	f84a                	sd	s2,48(sp)
    800016ba:	f44e                	sd	s3,40(sp)
    800016bc:	f052                	sd	s4,32(sp)
    800016be:	ec56                	sd	s5,24(sp)
    800016c0:	e85a                	sd	s6,16(sp)
    800016c2:	e45e                	sd	s7,8(sp)
    800016c4:	0880                	addi	s0,sp,80
    800016c6:	8a2a                	mv	s4,a0
    800016c8:	8b2e                	mv	s6,a1
    800016ca:	8bb2                	mv	s7,a2
    800016cc:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800016ce:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016d0:	6985                	lui	s3,0x1
    800016d2:	a825                	j	8000170a <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016d4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016d8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016da:	37fd                	addiw	a5,a5,-1
    800016dc:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016e0:	60a6                	ld	ra,72(sp)
    800016e2:	6406                	ld	s0,64(sp)
    800016e4:	74e2                	ld	s1,56(sp)
    800016e6:	7942                	ld	s2,48(sp)
    800016e8:	79a2                	ld	s3,40(sp)
    800016ea:	7a02                	ld	s4,32(sp)
    800016ec:	6ae2                	ld	s5,24(sp)
    800016ee:	6b42                	ld	s6,16(sp)
    800016f0:	6ba2                	ld	s7,8(sp)
    800016f2:	6161                	addi	sp,sp,80
    800016f4:	8082                	ret
    800016f6:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    800016fa:	9742                	add	a4,a4,a6
      --max;
    800016fc:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001700:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001704:	04e58463          	beq	a1,a4,8000174c <copyinstr+0x9e>
{
    80001708:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    8000170a:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000170e:	85a6                	mv	a1,s1
    80001710:	8552                	mv	a0,s4
    80001712:	8c5ff0ef          	jal	80000fd6 <walkaddr>
    if(pa0 == 0)
    80001716:	cd0d                	beqz	a0,80001750 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001718:	417486b3          	sub	a3,s1,s7
    8000171c:	96ce                	add	a3,a3,s3
    if(n > max)
    8000171e:	00d97363          	bgeu	s2,a3,80001724 <copyinstr+0x76>
    80001722:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001724:	955e                	add	a0,a0,s7
    80001726:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001728:	c695                	beqz	a3,80001754 <copyinstr+0xa6>
    8000172a:	87da                	mv	a5,s6
    8000172c:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000172e:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001732:	96da                	add	a3,a3,s6
    80001734:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001736:	00f60733          	add	a4,a2,a5
    8000173a:	00074703          	lbu	a4,0(a4)
    8000173e:	db59                	beqz	a4,800016d4 <copyinstr+0x26>
        *dst = *p;
    80001740:	00e78023          	sb	a4,0(a5)
      dst++;
    80001744:	0785                	addi	a5,a5,1
    while(n > 0){
    80001746:	fed797e3          	bne	a5,a3,80001734 <copyinstr+0x86>
    8000174a:	b775                	j	800016f6 <copyinstr+0x48>
    8000174c:	4781                	li	a5,0
    8000174e:	b771                	j	800016da <copyinstr+0x2c>
      return -1;
    80001750:	557d                	li	a0,-1
    80001752:	b779                	j	800016e0 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001754:	6b85                	lui	s7,0x1
    80001756:	9ba6                	add	s7,s7,s1
    80001758:	87da                	mv	a5,s6
    8000175a:	b77d                	j	80001708 <copyinstr+0x5a>
  int got_null = 0;
    8000175c:	4781                	li	a5,0
  if(got_null){
    8000175e:	37fd                	addiw	a5,a5,-1
    80001760:	0007851b          	sext.w	a0,a5
}
    80001764:	8082                	ret

0000000080001766 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001766:	7139                	addi	sp,sp,-64
    80001768:	fc06                	sd	ra,56(sp)
    8000176a:	f822                	sd	s0,48(sp)
    8000176c:	f426                	sd	s1,40(sp)
    8000176e:	f04a                	sd	s2,32(sp)
    80001770:	ec4e                	sd	s3,24(sp)
    80001772:	e852                	sd	s4,16(sp)
    80001774:	e456                	sd	s5,8(sp)
    80001776:	e05a                	sd	s6,0(sp)
    80001778:	0080                	addi	s0,sp,64
    8000177a:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000177c:	00011497          	auipc	s1,0x11
    80001780:	51448493          	addi	s1,s1,1300 # 80012c90 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001784:	8b26                	mv	s6,s1
    80001786:	04fa5937          	lui	s2,0x4fa5
    8000178a:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    8000178e:	0932                	slli	s2,s2,0xc
    80001790:	fa590913          	addi	s2,s2,-91
    80001794:	0932                	slli	s2,s2,0xc
    80001796:	fa590913          	addi	s2,s2,-91
    8000179a:	0932                	slli	s2,s2,0xc
    8000179c:	fa590913          	addi	s2,s2,-91
    800017a0:	040009b7          	lui	s3,0x4000
    800017a4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017a6:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017a8:	00017a97          	auipc	s5,0x17
    800017ac:	ee8a8a93          	addi	s5,s5,-280 # 80018690 <tickslock>
    char *pa = kalloc();
    800017b0:	b74ff0ef          	jal	80000b24 <kalloc>
    800017b4:	862a                	mv	a2,a0
    if(pa == 0)
    800017b6:	cd15                	beqz	a0,800017f2 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017b8:	416485b3          	sub	a1,s1,s6
    800017bc:	858d                	srai	a1,a1,0x3
    800017be:	032585b3          	mul	a1,a1,s2
    800017c2:	2585                	addiw	a1,a1,1
    800017c4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017c8:	4719                	li	a4,6
    800017ca:	6685                	lui	a3,0x1
    800017cc:	40b985b3          	sub	a1,s3,a1
    800017d0:	8552                	mv	a0,s4
    800017d2:	8f3ff0ef          	jal	800010c4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017d6:	16848493          	addi	s1,s1,360
    800017da:	fd549be3          	bne	s1,s5,800017b0 <proc_mapstacks+0x4a>
  }
}
    800017de:	70e2                	ld	ra,56(sp)
    800017e0:	7442                	ld	s0,48(sp)
    800017e2:	74a2                	ld	s1,40(sp)
    800017e4:	7902                	ld	s2,32(sp)
    800017e6:	69e2                	ld	s3,24(sp)
    800017e8:	6a42                	ld	s4,16(sp)
    800017ea:	6aa2                	ld	s5,8(sp)
    800017ec:	6b02                	ld	s6,0(sp)
    800017ee:	6121                	addi	sp,sp,64
    800017f0:	8082                	ret
      panic("kalloc");
    800017f2:	00006517          	auipc	a0,0x6
    800017f6:	a0650513          	addi	a0,a0,-1530 # 800071f8 <etext+0x1f8>
    800017fa:	f9bfe0ef          	jal	80000794 <panic>

00000000800017fe <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800017fe:	7139                	addi	sp,sp,-64
    80001800:	fc06                	sd	ra,56(sp)
    80001802:	f822                	sd	s0,48(sp)
    80001804:	f426                	sd	s1,40(sp)
    80001806:	f04a                	sd	s2,32(sp)
    80001808:	ec4e                	sd	s3,24(sp)
    8000180a:	e852                	sd	s4,16(sp)
    8000180c:	e456                	sd	s5,8(sp)
    8000180e:	e05a                	sd	s6,0(sp)
    80001810:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001812:	00006597          	auipc	a1,0x6
    80001816:	9ee58593          	addi	a1,a1,-1554 # 80007200 <etext+0x200>
    8000181a:	00011517          	auipc	a0,0x11
    8000181e:	04650513          	addi	a0,a0,70 # 80012860 <pid_lock>
    80001822:	b52ff0ef          	jal	80000b74 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001826:	00006597          	auipc	a1,0x6
    8000182a:	9e258593          	addi	a1,a1,-1566 # 80007208 <etext+0x208>
    8000182e:	00011517          	auipc	a0,0x11
    80001832:	04a50513          	addi	a0,a0,74 # 80012878 <wait_lock>
    80001836:	b3eff0ef          	jal	80000b74 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000183a:	00011497          	auipc	s1,0x11
    8000183e:	45648493          	addi	s1,s1,1110 # 80012c90 <proc>
      initlock(&p->lock, "proc");
    80001842:	00006b17          	auipc	s6,0x6
    80001846:	9d6b0b13          	addi	s6,s6,-1578 # 80007218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000184a:	8aa6                	mv	s5,s1
    8000184c:	04fa5937          	lui	s2,0x4fa5
    80001850:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001854:	0932                	slli	s2,s2,0xc
    80001856:	fa590913          	addi	s2,s2,-91
    8000185a:	0932                	slli	s2,s2,0xc
    8000185c:	fa590913          	addi	s2,s2,-91
    80001860:	0932                	slli	s2,s2,0xc
    80001862:	fa590913          	addi	s2,s2,-91
    80001866:	040009b7          	lui	s3,0x4000
    8000186a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000186c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000186e:	00017a17          	auipc	s4,0x17
    80001872:	e22a0a13          	addi	s4,s4,-478 # 80018690 <tickslock>
      initlock(&p->lock, "proc");
    80001876:	85da                	mv	a1,s6
    80001878:	8526                	mv	a0,s1
    8000187a:	afaff0ef          	jal	80000b74 <initlock>
      p->state = UNUSED;
    8000187e:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001882:	415487b3          	sub	a5,s1,s5
    80001886:	878d                	srai	a5,a5,0x3
    80001888:	032787b3          	mul	a5,a5,s2
    8000188c:	2785                	addiw	a5,a5,1
    8000188e:	00d7979b          	slliw	a5,a5,0xd
    80001892:	40f987b3          	sub	a5,s3,a5
    80001896:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001898:	16848493          	addi	s1,s1,360
    8000189c:	fd449de3          	bne	s1,s4,80001876 <procinit+0x78>
  }
}
    800018a0:	70e2                	ld	ra,56(sp)
    800018a2:	7442                	ld	s0,48(sp)
    800018a4:	74a2                	ld	s1,40(sp)
    800018a6:	7902                	ld	s2,32(sp)
    800018a8:	69e2                	ld	s3,24(sp)
    800018aa:	6a42                	ld	s4,16(sp)
    800018ac:	6aa2                	ld	s5,8(sp)
    800018ae:	6b02                	ld	s6,0(sp)
    800018b0:	6121                	addi	sp,sp,64
    800018b2:	8082                	ret

00000000800018b4 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018b4:	1141                	addi	sp,sp,-16
    800018b6:	e422                	sd	s0,8(sp)
    800018b8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018ba:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018bc:	2501                	sext.w	a0,a0
    800018be:	6422                	ld	s0,8(sp)
    800018c0:	0141                	addi	sp,sp,16
    800018c2:	8082                	ret

00000000800018c4 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018c4:	1141                	addi	sp,sp,-16
    800018c6:	e422                	sd	s0,8(sp)
    800018c8:	0800                	addi	s0,sp,16
    800018ca:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018cc:	2781                	sext.w	a5,a5
    800018ce:	079e                	slli	a5,a5,0x7
  return c;
}
    800018d0:	00011517          	auipc	a0,0x11
    800018d4:	fc050513          	addi	a0,a0,-64 # 80012890 <cpus>
    800018d8:	953e                	add	a0,a0,a5
    800018da:	6422                	ld	s0,8(sp)
    800018dc:	0141                	addi	sp,sp,16
    800018de:	8082                	ret

00000000800018e0 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800018e0:	1101                	addi	sp,sp,-32
    800018e2:	ec06                	sd	ra,24(sp)
    800018e4:	e822                	sd	s0,16(sp)
    800018e6:	e426                	sd	s1,8(sp)
    800018e8:	1000                	addi	s0,sp,32
  push_off();
    800018ea:	acaff0ef          	jal	80000bb4 <push_off>
    800018ee:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018f0:	2781                	sext.w	a5,a5
    800018f2:	079e                	slli	a5,a5,0x7
    800018f4:	00011717          	auipc	a4,0x11
    800018f8:	f6c70713          	addi	a4,a4,-148 # 80012860 <pid_lock>
    800018fc:	97ba                	add	a5,a5,a4
    800018fe:	7b84                	ld	s1,48(a5)
  pop_off();
    80001900:	b38ff0ef          	jal	80000c38 <pop_off>
  return p;
}
    80001904:	8526                	mv	a0,s1
    80001906:	60e2                	ld	ra,24(sp)
    80001908:	6442                	ld	s0,16(sp)
    8000190a:	64a2                	ld	s1,8(sp)
    8000190c:	6105                	addi	sp,sp,32
    8000190e:	8082                	ret

0000000080001910 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001910:	1141                	addi	sp,sp,-16
    80001912:	e406                	sd	ra,8(sp)
    80001914:	e022                	sd	s0,0(sp)
    80001916:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001918:	fc9ff0ef          	jal	800018e0 <myproc>
    8000191c:	b70ff0ef          	jal	80000c8c <release>

  if (first) {
    80001920:	00009797          	auipc	a5,0x9
    80001924:	d707a783          	lw	a5,-656(a5) # 8000a690 <first.1>
    80001928:	e799                	bnez	a5,80001936 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    8000192a:	2bf000ef          	jal	800023e8 <usertrapret>
}
    8000192e:	60a2                	ld	ra,8(sp)
    80001930:	6402                	ld	s0,0(sp)
    80001932:	0141                	addi	sp,sp,16
    80001934:	8082                	ret
    fsinit(ROOTDEV);
    80001936:	4505                	li	a0,1
    80001938:	231010ef          	jal	80003368 <fsinit>
    first = 0;
    8000193c:	00009797          	auipc	a5,0x9
    80001940:	d407aa23          	sw	zero,-684(a5) # 8000a690 <first.1>
    __sync_synchronize();
    80001944:	0330000f          	fence	rw,rw
    80001948:	b7cd                	j	8000192a <forkret+0x1a>

000000008000194a <allocpid>:
{
    8000194a:	1101                	addi	sp,sp,-32
    8000194c:	ec06                	sd	ra,24(sp)
    8000194e:	e822                	sd	s0,16(sp)
    80001950:	e426                	sd	s1,8(sp)
    80001952:	e04a                	sd	s2,0(sp)
    80001954:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001956:	00011917          	auipc	s2,0x11
    8000195a:	f0a90913          	addi	s2,s2,-246 # 80012860 <pid_lock>
    8000195e:	854a                	mv	a0,s2
    80001960:	a94ff0ef          	jal	80000bf4 <acquire>
  pid = nextpid;
    80001964:	00009797          	auipc	a5,0x9
    80001968:	d3078793          	addi	a5,a5,-720 # 8000a694 <nextpid>
    8000196c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000196e:	0014871b          	addiw	a4,s1,1
    80001972:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001974:	854a                	mv	a0,s2
    80001976:	b16ff0ef          	jal	80000c8c <release>
}
    8000197a:	8526                	mv	a0,s1
    8000197c:	60e2                	ld	ra,24(sp)
    8000197e:	6442                	ld	s0,16(sp)
    80001980:	64a2                	ld	s1,8(sp)
    80001982:	6902                	ld	s2,0(sp)
    80001984:	6105                	addi	sp,sp,32
    80001986:	8082                	ret

0000000080001988 <proc_pagetable>:
{
    80001988:	1101                	addi	sp,sp,-32
    8000198a:	ec06                	sd	ra,24(sp)
    8000198c:	e822                	sd	s0,16(sp)
    8000198e:	e426                	sd	s1,8(sp)
    80001990:	e04a                	sd	s2,0(sp)
    80001992:	1000                	addi	s0,sp,32
    80001994:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001996:	8e1ff0ef          	jal	80001276 <uvmcreate>
    8000199a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000199c:	cd05                	beqz	a0,800019d4 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000199e:	4729                	li	a4,10
    800019a0:	00004697          	auipc	a3,0x4
    800019a4:	66068693          	addi	a3,a3,1632 # 80006000 <_trampoline>
    800019a8:	6605                	lui	a2,0x1
    800019aa:	040005b7          	lui	a1,0x4000
    800019ae:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019b0:	05b2                	slli	a1,a1,0xc
    800019b2:	e62ff0ef          	jal	80001014 <mappages>
    800019b6:	02054663          	bltz	a0,800019e2 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800019ba:	4719                	li	a4,6
    800019bc:	05893683          	ld	a3,88(s2)
    800019c0:	6605                	lui	a2,0x1
    800019c2:	020005b7          	lui	a1,0x2000
    800019c6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019c8:	05b6                	slli	a1,a1,0xd
    800019ca:	8526                	mv	a0,s1
    800019cc:	e48ff0ef          	jal	80001014 <mappages>
    800019d0:	00054f63          	bltz	a0,800019ee <proc_pagetable+0x66>
}
    800019d4:	8526                	mv	a0,s1
    800019d6:	60e2                	ld	ra,24(sp)
    800019d8:	6442                	ld	s0,16(sp)
    800019da:	64a2                	ld	s1,8(sp)
    800019dc:	6902                	ld	s2,0(sp)
    800019de:	6105                	addi	sp,sp,32
    800019e0:	8082                	ret
    uvmfree(pagetable, 0);
    800019e2:	4581                	li	a1,0
    800019e4:	8526                	mv	a0,s1
    800019e6:	a5fff0ef          	jal	80001444 <uvmfree>
    return 0;
    800019ea:	4481                	li	s1,0
    800019ec:	b7e5                	j	800019d4 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800019ee:	4681                	li	a3,0
    800019f0:	4605                	li	a2,1
    800019f2:	040005b7          	lui	a1,0x4000
    800019f6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019f8:	05b2                	slli	a1,a1,0xc
    800019fa:	8526                	mv	a0,s1
    800019fc:	fbeff0ef          	jal	800011ba <uvmunmap>
    uvmfree(pagetable, 0);
    80001a00:	4581                	li	a1,0
    80001a02:	8526                	mv	a0,s1
    80001a04:	a41ff0ef          	jal	80001444 <uvmfree>
    return 0;
    80001a08:	4481                	li	s1,0
    80001a0a:	b7e9                	j	800019d4 <proc_pagetable+0x4c>

0000000080001a0c <proc_freepagetable>:
{
    80001a0c:	1101                	addi	sp,sp,-32
    80001a0e:	ec06                	sd	ra,24(sp)
    80001a10:	e822                	sd	s0,16(sp)
    80001a12:	e426                	sd	s1,8(sp)
    80001a14:	e04a                	sd	s2,0(sp)
    80001a16:	1000                	addi	s0,sp,32
    80001a18:	84aa                	mv	s1,a0
    80001a1a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a1c:	4681                	li	a3,0
    80001a1e:	4605                	li	a2,1
    80001a20:	040005b7          	lui	a1,0x4000
    80001a24:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a26:	05b2                	slli	a1,a1,0xc
    80001a28:	f92ff0ef          	jal	800011ba <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a2c:	4681                	li	a3,0
    80001a2e:	4605                	li	a2,1
    80001a30:	020005b7          	lui	a1,0x2000
    80001a34:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a36:	05b6                	slli	a1,a1,0xd
    80001a38:	8526                	mv	a0,s1
    80001a3a:	f80ff0ef          	jal	800011ba <uvmunmap>
  uvmfree(pagetable, sz);
    80001a3e:	85ca                	mv	a1,s2
    80001a40:	8526                	mv	a0,s1
    80001a42:	a03ff0ef          	jal	80001444 <uvmfree>
}
    80001a46:	60e2                	ld	ra,24(sp)
    80001a48:	6442                	ld	s0,16(sp)
    80001a4a:	64a2                	ld	s1,8(sp)
    80001a4c:	6902                	ld	s2,0(sp)
    80001a4e:	6105                	addi	sp,sp,32
    80001a50:	8082                	ret

0000000080001a52 <freeproc>:
{
    80001a52:	1101                	addi	sp,sp,-32
    80001a54:	ec06                	sd	ra,24(sp)
    80001a56:	e822                	sd	s0,16(sp)
    80001a58:	e426                	sd	s1,8(sp)
    80001a5a:	1000                	addi	s0,sp,32
    80001a5c:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001a5e:	6d28                	ld	a0,88(a0)
    80001a60:	c119                	beqz	a0,80001a66 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001a62:	fe1fe0ef          	jal	80000a42 <kfree>
  p->trapframe = 0;
    80001a66:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001a6a:	68a8                	ld	a0,80(s1)
    80001a6c:	c501                	beqz	a0,80001a74 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001a6e:	64ac                	ld	a1,72(s1)
    80001a70:	f9dff0ef          	jal	80001a0c <proc_freepagetable>
  p->pagetable = 0;
    80001a74:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001a78:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001a7c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001a80:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001a84:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001a88:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001a8c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001a90:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001a94:	0004ac23          	sw	zero,24(s1)
}
    80001a98:	60e2                	ld	ra,24(sp)
    80001a9a:	6442                	ld	s0,16(sp)
    80001a9c:	64a2                	ld	s1,8(sp)
    80001a9e:	6105                	addi	sp,sp,32
    80001aa0:	8082                	ret

0000000080001aa2 <allocproc>:
{
    80001aa2:	1101                	addi	sp,sp,-32
    80001aa4:	ec06                	sd	ra,24(sp)
    80001aa6:	e822                	sd	s0,16(sp)
    80001aa8:	e426                	sd	s1,8(sp)
    80001aaa:	e04a                	sd	s2,0(sp)
    80001aac:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001aae:	00011497          	auipc	s1,0x11
    80001ab2:	1e248493          	addi	s1,s1,482 # 80012c90 <proc>
    80001ab6:	00017917          	auipc	s2,0x17
    80001aba:	bda90913          	addi	s2,s2,-1062 # 80018690 <tickslock>
    acquire(&p->lock);
    80001abe:	8526                	mv	a0,s1
    80001ac0:	934ff0ef          	jal	80000bf4 <acquire>
    if(p->state == UNUSED) {
    80001ac4:	4c9c                	lw	a5,24(s1)
    80001ac6:	cb91                	beqz	a5,80001ada <allocproc+0x38>
      release(&p->lock);
    80001ac8:	8526                	mv	a0,s1
    80001aca:	9c2ff0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ace:	16848493          	addi	s1,s1,360
    80001ad2:	ff2496e3          	bne	s1,s2,80001abe <allocproc+0x1c>
  return 0;
    80001ad6:	4481                	li	s1,0
    80001ad8:	a089                	j	80001b1a <allocproc+0x78>
  p->pid = allocpid();
    80001ada:	e71ff0ef          	jal	8000194a <allocpid>
    80001ade:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001ae0:	4785                	li	a5,1
    80001ae2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001ae4:	840ff0ef          	jal	80000b24 <kalloc>
    80001ae8:	892a                	mv	s2,a0
    80001aea:	eca8                	sd	a0,88(s1)
    80001aec:	cd15                	beqz	a0,80001b28 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001aee:	8526                	mv	a0,s1
    80001af0:	e99ff0ef          	jal	80001988 <proc_pagetable>
    80001af4:	892a                	mv	s2,a0
    80001af6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001af8:	c121                	beqz	a0,80001b38 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001afa:	07000613          	li	a2,112
    80001afe:	4581                	li	a1,0
    80001b00:	06048513          	addi	a0,s1,96
    80001b04:	9c4ff0ef          	jal	80000cc8 <memset>
  p->context.ra = (uint64)forkret;
    80001b08:	00000797          	auipc	a5,0x0
    80001b0c:	e0878793          	addi	a5,a5,-504 # 80001910 <forkret>
    80001b10:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b12:	60bc                	ld	a5,64(s1)
    80001b14:	6705                	lui	a4,0x1
    80001b16:	97ba                	add	a5,a5,a4
    80001b18:	f4bc                	sd	a5,104(s1)
}
    80001b1a:	8526                	mv	a0,s1
    80001b1c:	60e2                	ld	ra,24(sp)
    80001b1e:	6442                	ld	s0,16(sp)
    80001b20:	64a2                	ld	s1,8(sp)
    80001b22:	6902                	ld	s2,0(sp)
    80001b24:	6105                	addi	sp,sp,32
    80001b26:	8082                	ret
    freeproc(p);
    80001b28:	8526                	mv	a0,s1
    80001b2a:	f29ff0ef          	jal	80001a52 <freeproc>
    release(&p->lock);
    80001b2e:	8526                	mv	a0,s1
    80001b30:	95cff0ef          	jal	80000c8c <release>
    return 0;
    80001b34:	84ca                	mv	s1,s2
    80001b36:	b7d5                	j	80001b1a <allocproc+0x78>
    freeproc(p);
    80001b38:	8526                	mv	a0,s1
    80001b3a:	f19ff0ef          	jal	80001a52 <freeproc>
    release(&p->lock);
    80001b3e:	8526                	mv	a0,s1
    80001b40:	94cff0ef          	jal	80000c8c <release>
    return 0;
    80001b44:	84ca                	mv	s1,s2
    80001b46:	bfd1                	j	80001b1a <allocproc+0x78>

0000000080001b48 <userinit>:
{
    80001b48:	1101                	addi	sp,sp,-32
    80001b4a:	ec06                	sd	ra,24(sp)
    80001b4c:	e822                	sd	s0,16(sp)
    80001b4e:	e426                	sd	s1,8(sp)
    80001b50:	1000                	addi	s0,sp,32
  p = allocproc();
    80001b52:	f51ff0ef          	jal	80001aa2 <allocproc>
    80001b56:	84aa                	mv	s1,a0
  initproc = p;
    80001b58:	00009797          	auipc	a5,0x9
    80001b5c:	bca7b823          	sd	a0,-1072(a5) # 8000a728 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001b60:	03400613          	li	a2,52
    80001b64:	00009597          	auipc	a1,0x9
    80001b68:	b3c58593          	addi	a1,a1,-1220 # 8000a6a0 <initcode>
    80001b6c:	6928                	ld	a0,80(a0)
    80001b6e:	f2eff0ef          	jal	8000129c <uvmfirst>
  p->sz = PGSIZE;
    80001b72:	6785                	lui	a5,0x1
    80001b74:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001b76:	6cb8                	ld	a4,88(s1)
    80001b78:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001b7c:	6cb8                	ld	a4,88(s1)
    80001b7e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001b80:	4641                	li	a2,16
    80001b82:	00005597          	auipc	a1,0x5
    80001b86:	69e58593          	addi	a1,a1,1694 # 80007220 <etext+0x220>
    80001b8a:	15848513          	addi	a0,s1,344
    80001b8e:	a78ff0ef          	jal	80000e06 <safestrcpy>
  p->cwd = namei("/");
    80001b92:	00005517          	auipc	a0,0x5
    80001b96:	69e50513          	addi	a0,a0,1694 # 80007230 <etext+0x230>
    80001b9a:	0dc020ef          	jal	80003c76 <namei>
    80001b9e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001ba2:	478d                	li	a5,3
    80001ba4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001ba6:	8526                	mv	a0,s1
    80001ba8:	8e4ff0ef          	jal	80000c8c <release>
}
    80001bac:	60e2                	ld	ra,24(sp)
    80001bae:	6442                	ld	s0,16(sp)
    80001bb0:	64a2                	ld	s1,8(sp)
    80001bb2:	6105                	addi	sp,sp,32
    80001bb4:	8082                	ret

0000000080001bb6 <growproc>:
{
    80001bb6:	1101                	addi	sp,sp,-32
    80001bb8:	ec06                	sd	ra,24(sp)
    80001bba:	e822                	sd	s0,16(sp)
    80001bbc:	e426                	sd	s1,8(sp)
    80001bbe:	e04a                	sd	s2,0(sp)
    80001bc0:	1000                	addi	s0,sp,32
    80001bc2:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001bc4:	d1dff0ef          	jal	800018e0 <myproc>
    80001bc8:	84aa                	mv	s1,a0
  sz = p->sz;
    80001bca:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001bcc:	01204c63          	bgtz	s2,80001be4 <growproc+0x2e>
  } else if(n < 0){
    80001bd0:	02094463          	bltz	s2,80001bf8 <growproc+0x42>
  p->sz = sz;
    80001bd4:	e4ac                	sd	a1,72(s1)
  return 0;
    80001bd6:	4501                	li	a0,0
}
    80001bd8:	60e2                	ld	ra,24(sp)
    80001bda:	6442                	ld	s0,16(sp)
    80001bdc:	64a2                	ld	s1,8(sp)
    80001bde:	6902                	ld	s2,0(sp)
    80001be0:	6105                	addi	sp,sp,32
    80001be2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001be4:	4691                	li	a3,4
    80001be6:	00b90633          	add	a2,s2,a1
    80001bea:	6928                	ld	a0,80(a0)
    80001bec:	f52ff0ef          	jal	8000133e <uvmalloc>
    80001bf0:	85aa                	mv	a1,a0
    80001bf2:	f16d                	bnez	a0,80001bd4 <growproc+0x1e>
      return -1;
    80001bf4:	557d                	li	a0,-1
    80001bf6:	b7cd                	j	80001bd8 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001bf8:	00b90633          	add	a2,s2,a1
    80001bfc:	6928                	ld	a0,80(a0)
    80001bfe:	efcff0ef          	jal	800012fa <uvmdealloc>
    80001c02:	85aa                	mv	a1,a0
    80001c04:	bfc1                	j	80001bd4 <growproc+0x1e>

0000000080001c06 <fork>:
{
    80001c06:	7139                	addi	sp,sp,-64
    80001c08:	fc06                	sd	ra,56(sp)
    80001c0a:	f822                	sd	s0,48(sp)
    80001c0c:	f04a                	sd	s2,32(sp)
    80001c0e:	e456                	sd	s5,8(sp)
    80001c10:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c12:	ccfff0ef          	jal	800018e0 <myproc>
    80001c16:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001c18:	e8bff0ef          	jal	80001aa2 <allocproc>
    80001c1c:	0e050a63          	beqz	a0,80001d10 <fork+0x10a>
    80001c20:	e852                	sd	s4,16(sp)
    80001c22:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001c24:	048ab603          	ld	a2,72(s5)
    80001c28:	692c                	ld	a1,80(a0)
    80001c2a:	050ab503          	ld	a0,80(s5)
    80001c2e:	849ff0ef          	jal	80001476 <uvmcopy>
    80001c32:	04054a63          	bltz	a0,80001c86 <fork+0x80>
    80001c36:	f426                	sd	s1,40(sp)
    80001c38:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001c3a:	048ab783          	ld	a5,72(s5)
    80001c3e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001c42:	058ab683          	ld	a3,88(s5)
    80001c46:	87b6                	mv	a5,a3
    80001c48:	058a3703          	ld	a4,88(s4)
    80001c4c:	12068693          	addi	a3,a3,288
    80001c50:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001c54:	6788                	ld	a0,8(a5)
    80001c56:	6b8c                	ld	a1,16(a5)
    80001c58:	6f90                	ld	a2,24(a5)
    80001c5a:	01073023          	sd	a6,0(a4)
    80001c5e:	e708                	sd	a0,8(a4)
    80001c60:	eb0c                	sd	a1,16(a4)
    80001c62:	ef10                	sd	a2,24(a4)
    80001c64:	02078793          	addi	a5,a5,32
    80001c68:	02070713          	addi	a4,a4,32
    80001c6c:	fed792e3          	bne	a5,a3,80001c50 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001c70:	058a3783          	ld	a5,88(s4)
    80001c74:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001c78:	0d0a8493          	addi	s1,s5,208
    80001c7c:	0d0a0913          	addi	s2,s4,208
    80001c80:	150a8993          	addi	s3,s5,336
    80001c84:	a831                	j	80001ca0 <fork+0x9a>
    freeproc(np);
    80001c86:	8552                	mv	a0,s4
    80001c88:	dcbff0ef          	jal	80001a52 <freeproc>
    release(&np->lock);
    80001c8c:	8552                	mv	a0,s4
    80001c8e:	ffffe0ef          	jal	80000c8c <release>
    return -1;
    80001c92:	597d                	li	s2,-1
    80001c94:	6a42                	ld	s4,16(sp)
    80001c96:	a0b5                	j	80001d02 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001c98:	04a1                	addi	s1,s1,8
    80001c9a:	0921                	addi	s2,s2,8
    80001c9c:	01348963          	beq	s1,s3,80001cae <fork+0xa8>
    if(p->ofile[i])
    80001ca0:	6088                	ld	a0,0(s1)
    80001ca2:	d97d                	beqz	a0,80001c98 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001ca4:	562020ef          	jal	80004206 <filedup>
    80001ca8:	00a93023          	sd	a0,0(s2)
    80001cac:	b7f5                	j	80001c98 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001cae:	150ab503          	ld	a0,336(s5)
    80001cb2:	0b5010ef          	jal	80003566 <idup>
    80001cb6:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001cba:	4641                	li	a2,16
    80001cbc:	158a8593          	addi	a1,s5,344
    80001cc0:	158a0513          	addi	a0,s4,344
    80001cc4:	942ff0ef          	jal	80000e06 <safestrcpy>
  pid = np->pid;
    80001cc8:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001ccc:	8552                	mv	a0,s4
    80001cce:	fbffe0ef          	jal	80000c8c <release>
  acquire(&wait_lock);
    80001cd2:	00011497          	auipc	s1,0x11
    80001cd6:	ba648493          	addi	s1,s1,-1114 # 80012878 <wait_lock>
    80001cda:	8526                	mv	a0,s1
    80001cdc:	f19fe0ef          	jal	80000bf4 <acquire>
  np->parent = p;
    80001ce0:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001ce4:	8526                	mv	a0,s1
    80001ce6:	fa7fe0ef          	jal	80000c8c <release>
  acquire(&np->lock);
    80001cea:	8552                	mv	a0,s4
    80001cec:	f09fe0ef          	jal	80000bf4 <acquire>
  np->state = RUNNABLE;
    80001cf0:	478d                	li	a5,3
    80001cf2:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001cf6:	8552                	mv	a0,s4
    80001cf8:	f95fe0ef          	jal	80000c8c <release>
  return pid;
    80001cfc:	74a2                	ld	s1,40(sp)
    80001cfe:	69e2                	ld	s3,24(sp)
    80001d00:	6a42                	ld	s4,16(sp)
}
    80001d02:	854a                	mv	a0,s2
    80001d04:	70e2                	ld	ra,56(sp)
    80001d06:	7442                	ld	s0,48(sp)
    80001d08:	7902                	ld	s2,32(sp)
    80001d0a:	6aa2                	ld	s5,8(sp)
    80001d0c:	6121                	addi	sp,sp,64
    80001d0e:	8082                	ret
    return -1;
    80001d10:	597d                	li	s2,-1
    80001d12:	bfc5                	j	80001d02 <fork+0xfc>

0000000080001d14 <scheduler>:
{
    80001d14:	715d                	addi	sp,sp,-80
    80001d16:	e486                	sd	ra,72(sp)
    80001d18:	e0a2                	sd	s0,64(sp)
    80001d1a:	fc26                	sd	s1,56(sp)
    80001d1c:	f84a                	sd	s2,48(sp)
    80001d1e:	f44e                	sd	s3,40(sp)
    80001d20:	f052                	sd	s4,32(sp)
    80001d22:	ec56                	sd	s5,24(sp)
    80001d24:	e85a                	sd	s6,16(sp)
    80001d26:	e45e                	sd	s7,8(sp)
    80001d28:	e062                	sd	s8,0(sp)
    80001d2a:	0880                	addi	s0,sp,80
    80001d2c:	8792                	mv	a5,tp
  int id = r_tp();
    80001d2e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d30:	00779b13          	slli	s6,a5,0x7
    80001d34:	00011717          	auipc	a4,0x11
    80001d38:	b2c70713          	addi	a4,a4,-1236 # 80012860 <pid_lock>
    80001d3c:	975a                	add	a4,a4,s6
    80001d3e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001d42:	00011717          	auipc	a4,0x11
    80001d46:	b5670713          	addi	a4,a4,-1194 # 80012898 <cpus+0x8>
    80001d4a:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001d4c:	4c11                	li	s8,4
        c->proc = p;
    80001d4e:	079e                	slli	a5,a5,0x7
    80001d50:	00011a17          	auipc	s4,0x11
    80001d54:	b10a0a13          	addi	s4,s4,-1264 # 80012860 <pid_lock>
    80001d58:	9a3e                	add	s4,s4,a5
        found = 1;
    80001d5a:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d5c:	00017997          	auipc	s3,0x17
    80001d60:	93498993          	addi	s3,s3,-1740 # 80018690 <tickslock>
    80001d64:	a0a9                	j	80001dae <scheduler+0x9a>
      release(&p->lock);
    80001d66:	8526                	mv	a0,s1
    80001d68:	f25fe0ef          	jal	80000c8c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d6c:	16848493          	addi	s1,s1,360
    80001d70:	03348563          	beq	s1,s3,80001d9a <scheduler+0x86>
      acquire(&p->lock);
    80001d74:	8526                	mv	a0,s1
    80001d76:	e7ffe0ef          	jal	80000bf4 <acquire>
      if(p->state == RUNNABLE) {
    80001d7a:	4c9c                	lw	a5,24(s1)
    80001d7c:	ff2795e3          	bne	a5,s2,80001d66 <scheduler+0x52>
        p->state = RUNNING;
    80001d80:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001d84:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001d88:	06048593          	addi	a1,s1,96
    80001d8c:	855a                	mv	a0,s6
    80001d8e:	5b4000ef          	jal	80002342 <swtch>
        c->proc = 0;
    80001d92:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001d96:	8ade                	mv	s5,s7
    80001d98:	b7f9                	j	80001d66 <scheduler+0x52>
    if(found == 0) {
    80001d9a:	000a9a63          	bnez	s5,80001dae <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d9e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001da2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001da6:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001daa:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dae:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001db2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001db6:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001dba:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dbc:	00011497          	auipc	s1,0x11
    80001dc0:	ed448493          	addi	s1,s1,-300 # 80012c90 <proc>
      if(p->state == RUNNABLE) {
    80001dc4:	490d                	li	s2,3
    80001dc6:	b77d                	j	80001d74 <scheduler+0x60>

0000000080001dc8 <sched>:
{
    80001dc8:	7179                	addi	sp,sp,-48
    80001dca:	f406                	sd	ra,40(sp)
    80001dcc:	f022                	sd	s0,32(sp)
    80001dce:	ec26                	sd	s1,24(sp)
    80001dd0:	e84a                	sd	s2,16(sp)
    80001dd2:	e44e                	sd	s3,8(sp)
    80001dd4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001dd6:	b0bff0ef          	jal	800018e0 <myproc>
    80001dda:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001ddc:	daffe0ef          	jal	80000b8a <holding>
    80001de0:	c92d                	beqz	a0,80001e52 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001de2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001de4:	2781                	sext.w	a5,a5
    80001de6:	079e                	slli	a5,a5,0x7
    80001de8:	00011717          	auipc	a4,0x11
    80001dec:	a7870713          	addi	a4,a4,-1416 # 80012860 <pid_lock>
    80001df0:	97ba                	add	a5,a5,a4
    80001df2:	0a87a703          	lw	a4,168(a5)
    80001df6:	4785                	li	a5,1
    80001df8:	06f71363          	bne	a4,a5,80001e5e <sched+0x96>
  if(p->state == RUNNING)
    80001dfc:	4c98                	lw	a4,24(s1)
    80001dfe:	4791                	li	a5,4
    80001e00:	06f70563          	beq	a4,a5,80001e6a <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e04:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e08:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e0a:	e7b5                	bnez	a5,80001e76 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e0c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e0e:	00011917          	auipc	s2,0x11
    80001e12:	a5290913          	addi	s2,s2,-1454 # 80012860 <pid_lock>
    80001e16:	2781                	sext.w	a5,a5
    80001e18:	079e                	slli	a5,a5,0x7
    80001e1a:	97ca                	add	a5,a5,s2
    80001e1c:	0ac7a983          	lw	s3,172(a5)
    80001e20:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e22:	2781                	sext.w	a5,a5
    80001e24:	079e                	slli	a5,a5,0x7
    80001e26:	00011597          	auipc	a1,0x11
    80001e2a:	a7258593          	addi	a1,a1,-1422 # 80012898 <cpus+0x8>
    80001e2e:	95be                	add	a1,a1,a5
    80001e30:	06048513          	addi	a0,s1,96
    80001e34:	50e000ef          	jal	80002342 <swtch>
    80001e38:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001e3a:	2781                	sext.w	a5,a5
    80001e3c:	079e                	slli	a5,a5,0x7
    80001e3e:	993e                	add	s2,s2,a5
    80001e40:	0b392623          	sw	s3,172(s2)
}
    80001e44:	70a2                	ld	ra,40(sp)
    80001e46:	7402                	ld	s0,32(sp)
    80001e48:	64e2                	ld	s1,24(sp)
    80001e4a:	6942                	ld	s2,16(sp)
    80001e4c:	69a2                	ld	s3,8(sp)
    80001e4e:	6145                	addi	sp,sp,48
    80001e50:	8082                	ret
    panic("sched p->lock");
    80001e52:	00005517          	auipc	a0,0x5
    80001e56:	3e650513          	addi	a0,a0,998 # 80007238 <etext+0x238>
    80001e5a:	93bfe0ef          	jal	80000794 <panic>
    panic("sched locks");
    80001e5e:	00005517          	auipc	a0,0x5
    80001e62:	3ea50513          	addi	a0,a0,1002 # 80007248 <etext+0x248>
    80001e66:	92ffe0ef          	jal	80000794 <panic>
    panic("sched running");
    80001e6a:	00005517          	auipc	a0,0x5
    80001e6e:	3ee50513          	addi	a0,a0,1006 # 80007258 <etext+0x258>
    80001e72:	923fe0ef          	jal	80000794 <panic>
    panic("sched interruptible");
    80001e76:	00005517          	auipc	a0,0x5
    80001e7a:	3f250513          	addi	a0,a0,1010 # 80007268 <etext+0x268>
    80001e7e:	917fe0ef          	jal	80000794 <panic>

0000000080001e82 <yield>:
{
    80001e82:	1101                	addi	sp,sp,-32
    80001e84:	ec06                	sd	ra,24(sp)
    80001e86:	e822                	sd	s0,16(sp)
    80001e88:	e426                	sd	s1,8(sp)
    80001e8a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001e8c:	a55ff0ef          	jal	800018e0 <myproc>
    80001e90:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001e92:	d63fe0ef          	jal	80000bf4 <acquire>
  p->state = RUNNABLE;
    80001e96:	478d                	li	a5,3
    80001e98:	cc9c                	sw	a5,24(s1)
  sched();
    80001e9a:	f2fff0ef          	jal	80001dc8 <sched>
  release(&p->lock);
    80001e9e:	8526                	mv	a0,s1
    80001ea0:	dedfe0ef          	jal	80000c8c <release>
}
    80001ea4:	60e2                	ld	ra,24(sp)
    80001ea6:	6442                	ld	s0,16(sp)
    80001ea8:	64a2                	ld	s1,8(sp)
    80001eaa:	6105                	addi	sp,sp,32
    80001eac:	8082                	ret

0000000080001eae <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001eae:	7179                	addi	sp,sp,-48
    80001eb0:	f406                	sd	ra,40(sp)
    80001eb2:	f022                	sd	s0,32(sp)
    80001eb4:	ec26                	sd	s1,24(sp)
    80001eb6:	e84a                	sd	s2,16(sp)
    80001eb8:	e44e                	sd	s3,8(sp)
    80001eba:	1800                	addi	s0,sp,48
    80001ebc:	89aa                	mv	s3,a0
    80001ebe:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ec0:	a21ff0ef          	jal	800018e0 <myproc>
    80001ec4:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001ec6:	d2ffe0ef          	jal	80000bf4 <acquire>
  release(lk);
    80001eca:	854a                	mv	a0,s2
    80001ecc:	dc1fe0ef          	jal	80000c8c <release>

  // Go to sleep.
  p->chan = chan;
    80001ed0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001ed4:	4789                	li	a5,2
    80001ed6:	cc9c                	sw	a5,24(s1)

  sched();
    80001ed8:	ef1ff0ef          	jal	80001dc8 <sched>

  // Tidy up.
  p->chan = 0;
    80001edc:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001ee0:	8526                	mv	a0,s1
    80001ee2:	dabfe0ef          	jal	80000c8c <release>
  acquire(lk);
    80001ee6:	854a                	mv	a0,s2
    80001ee8:	d0dfe0ef          	jal	80000bf4 <acquire>
}
    80001eec:	70a2                	ld	ra,40(sp)
    80001eee:	7402                	ld	s0,32(sp)
    80001ef0:	64e2                	ld	s1,24(sp)
    80001ef2:	6942                	ld	s2,16(sp)
    80001ef4:	69a2                	ld	s3,8(sp)
    80001ef6:	6145                	addi	sp,sp,48
    80001ef8:	8082                	ret

0000000080001efa <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001efa:	7139                	addi	sp,sp,-64
    80001efc:	fc06                	sd	ra,56(sp)
    80001efe:	f822                	sd	s0,48(sp)
    80001f00:	f426                	sd	s1,40(sp)
    80001f02:	f04a                	sd	s2,32(sp)
    80001f04:	ec4e                	sd	s3,24(sp)
    80001f06:	e852                	sd	s4,16(sp)
    80001f08:	e456                	sd	s5,8(sp)
    80001f0a:	0080                	addi	s0,sp,64
    80001f0c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001f0e:	00011497          	auipc	s1,0x11
    80001f12:	d8248493          	addi	s1,s1,-638 # 80012c90 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001f16:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001f18:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f1a:	00016917          	auipc	s2,0x16
    80001f1e:	77690913          	addi	s2,s2,1910 # 80018690 <tickslock>
    80001f22:	a801                	j	80001f32 <wakeup+0x38>
      }
      release(&p->lock);
    80001f24:	8526                	mv	a0,s1
    80001f26:	d67fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f2a:	16848493          	addi	s1,s1,360
    80001f2e:	03248263          	beq	s1,s2,80001f52 <wakeup+0x58>
    if(p != myproc()){
    80001f32:	9afff0ef          	jal	800018e0 <myproc>
    80001f36:	fea48ae3          	beq	s1,a0,80001f2a <wakeup+0x30>
      acquire(&p->lock);
    80001f3a:	8526                	mv	a0,s1
    80001f3c:	cb9fe0ef          	jal	80000bf4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001f40:	4c9c                	lw	a5,24(s1)
    80001f42:	ff3791e3          	bne	a5,s3,80001f24 <wakeup+0x2a>
    80001f46:	709c                	ld	a5,32(s1)
    80001f48:	fd479ee3          	bne	a5,s4,80001f24 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001f4c:	0154ac23          	sw	s5,24(s1)
    80001f50:	bfd1                	j	80001f24 <wakeup+0x2a>
    }
  }
}
    80001f52:	70e2                	ld	ra,56(sp)
    80001f54:	7442                	ld	s0,48(sp)
    80001f56:	74a2                	ld	s1,40(sp)
    80001f58:	7902                	ld	s2,32(sp)
    80001f5a:	69e2                	ld	s3,24(sp)
    80001f5c:	6a42                	ld	s4,16(sp)
    80001f5e:	6aa2                	ld	s5,8(sp)
    80001f60:	6121                	addi	sp,sp,64
    80001f62:	8082                	ret

0000000080001f64 <reparent>:
{
    80001f64:	7179                	addi	sp,sp,-48
    80001f66:	f406                	sd	ra,40(sp)
    80001f68:	f022                	sd	s0,32(sp)
    80001f6a:	ec26                	sd	s1,24(sp)
    80001f6c:	e84a                	sd	s2,16(sp)
    80001f6e:	e44e                	sd	s3,8(sp)
    80001f70:	e052                	sd	s4,0(sp)
    80001f72:	1800                	addi	s0,sp,48
    80001f74:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f76:	00011497          	auipc	s1,0x11
    80001f7a:	d1a48493          	addi	s1,s1,-742 # 80012c90 <proc>
      pp->parent = initproc;
    80001f7e:	00008a17          	auipc	s4,0x8
    80001f82:	7aaa0a13          	addi	s4,s4,1962 # 8000a728 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f86:	00016997          	auipc	s3,0x16
    80001f8a:	70a98993          	addi	s3,s3,1802 # 80018690 <tickslock>
    80001f8e:	a029                	j	80001f98 <reparent+0x34>
    80001f90:	16848493          	addi	s1,s1,360
    80001f94:	01348b63          	beq	s1,s3,80001faa <reparent+0x46>
    if(pp->parent == p){
    80001f98:	7c9c                	ld	a5,56(s1)
    80001f9a:	ff279be3          	bne	a5,s2,80001f90 <reparent+0x2c>
      pp->parent = initproc;
    80001f9e:	000a3503          	ld	a0,0(s4)
    80001fa2:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001fa4:	f57ff0ef          	jal	80001efa <wakeup>
    80001fa8:	b7e5                	j	80001f90 <reparent+0x2c>
}
    80001faa:	70a2                	ld	ra,40(sp)
    80001fac:	7402                	ld	s0,32(sp)
    80001fae:	64e2                	ld	s1,24(sp)
    80001fb0:	6942                	ld	s2,16(sp)
    80001fb2:	69a2                	ld	s3,8(sp)
    80001fb4:	6a02                	ld	s4,0(sp)
    80001fb6:	6145                	addi	sp,sp,48
    80001fb8:	8082                	ret

0000000080001fba <exit>:
{
    80001fba:	7179                	addi	sp,sp,-48
    80001fbc:	f406                	sd	ra,40(sp)
    80001fbe:	f022                	sd	s0,32(sp)
    80001fc0:	ec26                	sd	s1,24(sp)
    80001fc2:	e84a                	sd	s2,16(sp)
    80001fc4:	e44e                	sd	s3,8(sp)
    80001fc6:	e052                	sd	s4,0(sp)
    80001fc8:	1800                	addi	s0,sp,48
    80001fca:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001fcc:	915ff0ef          	jal	800018e0 <myproc>
    80001fd0:	89aa                	mv	s3,a0
  if(p == initproc)
    80001fd2:	00008797          	auipc	a5,0x8
    80001fd6:	7567b783          	ld	a5,1878(a5) # 8000a728 <initproc>
    80001fda:	0d050493          	addi	s1,a0,208
    80001fde:	15050913          	addi	s2,a0,336
    80001fe2:	00a79f63          	bne	a5,a0,80002000 <exit+0x46>
    panic("init exiting");
    80001fe6:	00005517          	auipc	a0,0x5
    80001fea:	29a50513          	addi	a0,a0,666 # 80007280 <etext+0x280>
    80001fee:	fa6fe0ef          	jal	80000794 <panic>
      fileclose(f);
    80001ff2:	25a020ef          	jal	8000424c <fileclose>
      p->ofile[fd] = 0;
    80001ff6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001ffa:	04a1                	addi	s1,s1,8
    80001ffc:	01248563          	beq	s1,s2,80002006 <exit+0x4c>
    if(p->ofile[fd]){
    80002000:	6088                	ld	a0,0(s1)
    80002002:	f965                	bnez	a0,80001ff2 <exit+0x38>
    80002004:	bfdd                	j	80001ffa <exit+0x40>
  begin_op();
    80002006:	62d010ef          	jal	80003e32 <begin_op>
  iput(p->cwd);
    8000200a:	1509b503          	ld	a0,336(s3)
    8000200e:	710010ef          	jal	8000371e <iput>
  end_op();
    80002012:	68b010ef          	jal	80003e9c <end_op>
  p->cwd = 0;
    80002016:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000201a:	00011497          	auipc	s1,0x11
    8000201e:	85e48493          	addi	s1,s1,-1954 # 80012878 <wait_lock>
    80002022:	8526                	mv	a0,s1
    80002024:	bd1fe0ef          	jal	80000bf4 <acquire>
  reparent(p);
    80002028:	854e                	mv	a0,s3
    8000202a:	f3bff0ef          	jal	80001f64 <reparent>
  wakeup(p->parent);
    8000202e:	0389b503          	ld	a0,56(s3)
    80002032:	ec9ff0ef          	jal	80001efa <wakeup>
  acquire(&p->lock);
    80002036:	854e                	mv	a0,s3
    80002038:	bbdfe0ef          	jal	80000bf4 <acquire>
  p->xstate = status;
    8000203c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002040:	4795                	li	a5,5
    80002042:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002046:	8526                	mv	a0,s1
    80002048:	c45fe0ef          	jal	80000c8c <release>
  sched();
    8000204c:	d7dff0ef          	jal	80001dc8 <sched>
  panic("zombie exit");
    80002050:	00005517          	auipc	a0,0x5
    80002054:	24050513          	addi	a0,a0,576 # 80007290 <etext+0x290>
    80002058:	f3cfe0ef          	jal	80000794 <panic>

000000008000205c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000205c:	7179                	addi	sp,sp,-48
    8000205e:	f406                	sd	ra,40(sp)
    80002060:	f022                	sd	s0,32(sp)
    80002062:	ec26                	sd	s1,24(sp)
    80002064:	e84a                	sd	s2,16(sp)
    80002066:	e44e                	sd	s3,8(sp)
    80002068:	1800                	addi	s0,sp,48
    8000206a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000206c:	00011497          	auipc	s1,0x11
    80002070:	c2448493          	addi	s1,s1,-988 # 80012c90 <proc>
    80002074:	00016997          	auipc	s3,0x16
    80002078:	61c98993          	addi	s3,s3,1564 # 80018690 <tickslock>
    acquire(&p->lock);
    8000207c:	8526                	mv	a0,s1
    8000207e:	b77fe0ef          	jal	80000bf4 <acquire>
    if(p->pid == pid){
    80002082:	589c                	lw	a5,48(s1)
    80002084:	01278b63          	beq	a5,s2,8000209a <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002088:	8526                	mv	a0,s1
    8000208a:	c03fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000208e:	16848493          	addi	s1,s1,360
    80002092:	ff3495e3          	bne	s1,s3,8000207c <kill+0x20>
  }
  return -1;
    80002096:	557d                	li	a0,-1
    80002098:	a819                	j	800020ae <kill+0x52>
      p->killed = 1;
    8000209a:	4785                	li	a5,1
    8000209c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000209e:	4c98                	lw	a4,24(s1)
    800020a0:	4789                	li	a5,2
    800020a2:	00f70d63          	beq	a4,a5,800020bc <kill+0x60>
      release(&p->lock);
    800020a6:	8526                	mv	a0,s1
    800020a8:	be5fe0ef          	jal	80000c8c <release>
      return 0;
    800020ac:	4501                	li	a0,0
}
    800020ae:	70a2                	ld	ra,40(sp)
    800020b0:	7402                	ld	s0,32(sp)
    800020b2:	64e2                	ld	s1,24(sp)
    800020b4:	6942                	ld	s2,16(sp)
    800020b6:	69a2                	ld	s3,8(sp)
    800020b8:	6145                	addi	sp,sp,48
    800020ba:	8082                	ret
        p->state = RUNNABLE;
    800020bc:	478d                	li	a5,3
    800020be:	cc9c                	sw	a5,24(s1)
    800020c0:	b7dd                	j	800020a6 <kill+0x4a>

00000000800020c2 <setkilled>:

void
setkilled(struct proc *p)
{
    800020c2:	1101                	addi	sp,sp,-32
    800020c4:	ec06                	sd	ra,24(sp)
    800020c6:	e822                	sd	s0,16(sp)
    800020c8:	e426                	sd	s1,8(sp)
    800020ca:	1000                	addi	s0,sp,32
    800020cc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020ce:	b27fe0ef          	jal	80000bf4 <acquire>
  p->killed = 1;
    800020d2:	4785                	li	a5,1
    800020d4:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800020d6:	8526                	mv	a0,s1
    800020d8:	bb5fe0ef          	jal	80000c8c <release>
}
    800020dc:	60e2                	ld	ra,24(sp)
    800020de:	6442                	ld	s0,16(sp)
    800020e0:	64a2                	ld	s1,8(sp)
    800020e2:	6105                	addi	sp,sp,32
    800020e4:	8082                	ret

00000000800020e6 <killed>:

int
killed(struct proc *p)
{
    800020e6:	1101                	addi	sp,sp,-32
    800020e8:	ec06                	sd	ra,24(sp)
    800020ea:	e822                	sd	s0,16(sp)
    800020ec:	e426                	sd	s1,8(sp)
    800020ee:	e04a                	sd	s2,0(sp)
    800020f0:	1000                	addi	s0,sp,32
    800020f2:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800020f4:	b01fe0ef          	jal	80000bf4 <acquire>
  k = p->killed;
    800020f8:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800020fc:	8526                	mv	a0,s1
    800020fe:	b8ffe0ef          	jal	80000c8c <release>
  return k;
}
    80002102:	854a                	mv	a0,s2
    80002104:	60e2                	ld	ra,24(sp)
    80002106:	6442                	ld	s0,16(sp)
    80002108:	64a2                	ld	s1,8(sp)
    8000210a:	6902                	ld	s2,0(sp)
    8000210c:	6105                	addi	sp,sp,32
    8000210e:	8082                	ret

0000000080002110 <wait>:
{
    80002110:	715d                	addi	sp,sp,-80
    80002112:	e486                	sd	ra,72(sp)
    80002114:	e0a2                	sd	s0,64(sp)
    80002116:	fc26                	sd	s1,56(sp)
    80002118:	f84a                	sd	s2,48(sp)
    8000211a:	f44e                	sd	s3,40(sp)
    8000211c:	f052                	sd	s4,32(sp)
    8000211e:	ec56                	sd	s5,24(sp)
    80002120:	e85a                	sd	s6,16(sp)
    80002122:	e45e                	sd	s7,8(sp)
    80002124:	e062                	sd	s8,0(sp)
    80002126:	0880                	addi	s0,sp,80
    80002128:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000212a:	fb6ff0ef          	jal	800018e0 <myproc>
    8000212e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002130:	00010517          	auipc	a0,0x10
    80002134:	74850513          	addi	a0,a0,1864 # 80012878 <wait_lock>
    80002138:	abdfe0ef          	jal	80000bf4 <acquire>
    havekids = 0;
    8000213c:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000213e:	4a15                	li	s4,5
        havekids = 1;
    80002140:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002142:	00016997          	auipc	s3,0x16
    80002146:	54e98993          	addi	s3,s3,1358 # 80018690 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000214a:	00010c17          	auipc	s8,0x10
    8000214e:	72ec0c13          	addi	s8,s8,1838 # 80012878 <wait_lock>
    80002152:	a871                	j	800021ee <wait+0xde>
          pid = pp->pid;
    80002154:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002158:	000b0c63          	beqz	s6,80002170 <wait+0x60>
    8000215c:	4691                	li	a3,4
    8000215e:	02c48613          	addi	a2,s1,44
    80002162:	85da                	mv	a1,s6
    80002164:	05093503          	ld	a0,80(s2)
    80002168:	beaff0ef          	jal	80001552 <copyout>
    8000216c:	02054b63          	bltz	a0,800021a2 <wait+0x92>
          freeproc(pp);
    80002170:	8526                	mv	a0,s1
    80002172:	8e1ff0ef          	jal	80001a52 <freeproc>
          release(&pp->lock);
    80002176:	8526                	mv	a0,s1
    80002178:	b15fe0ef          	jal	80000c8c <release>
          release(&wait_lock);
    8000217c:	00010517          	auipc	a0,0x10
    80002180:	6fc50513          	addi	a0,a0,1788 # 80012878 <wait_lock>
    80002184:	b09fe0ef          	jal	80000c8c <release>
}
    80002188:	854e                	mv	a0,s3
    8000218a:	60a6                	ld	ra,72(sp)
    8000218c:	6406                	ld	s0,64(sp)
    8000218e:	74e2                	ld	s1,56(sp)
    80002190:	7942                	ld	s2,48(sp)
    80002192:	79a2                	ld	s3,40(sp)
    80002194:	7a02                	ld	s4,32(sp)
    80002196:	6ae2                	ld	s5,24(sp)
    80002198:	6b42                	ld	s6,16(sp)
    8000219a:	6ba2                	ld	s7,8(sp)
    8000219c:	6c02                	ld	s8,0(sp)
    8000219e:	6161                	addi	sp,sp,80
    800021a0:	8082                	ret
            release(&pp->lock);
    800021a2:	8526                	mv	a0,s1
    800021a4:	ae9fe0ef          	jal	80000c8c <release>
            release(&wait_lock);
    800021a8:	00010517          	auipc	a0,0x10
    800021ac:	6d050513          	addi	a0,a0,1744 # 80012878 <wait_lock>
    800021b0:	addfe0ef          	jal	80000c8c <release>
            return -1;
    800021b4:	59fd                	li	s3,-1
    800021b6:	bfc9                	j	80002188 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021b8:	16848493          	addi	s1,s1,360
    800021bc:	03348063          	beq	s1,s3,800021dc <wait+0xcc>
      if(pp->parent == p){
    800021c0:	7c9c                	ld	a5,56(s1)
    800021c2:	ff279be3          	bne	a5,s2,800021b8 <wait+0xa8>
        acquire(&pp->lock);
    800021c6:	8526                	mv	a0,s1
    800021c8:	a2dfe0ef          	jal	80000bf4 <acquire>
        if(pp->state == ZOMBIE){
    800021cc:	4c9c                	lw	a5,24(s1)
    800021ce:	f94783e3          	beq	a5,s4,80002154 <wait+0x44>
        release(&pp->lock);
    800021d2:	8526                	mv	a0,s1
    800021d4:	ab9fe0ef          	jal	80000c8c <release>
        havekids = 1;
    800021d8:	8756                	mv	a4,s5
    800021da:	bff9                	j	800021b8 <wait+0xa8>
    if(!havekids || killed(p)){
    800021dc:	cf19                	beqz	a4,800021fa <wait+0xea>
    800021de:	854a                	mv	a0,s2
    800021e0:	f07ff0ef          	jal	800020e6 <killed>
    800021e4:	e919                	bnez	a0,800021fa <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021e6:	85e2                	mv	a1,s8
    800021e8:	854a                	mv	a0,s2
    800021ea:	cc5ff0ef          	jal	80001eae <sleep>
    havekids = 0;
    800021ee:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021f0:	00011497          	auipc	s1,0x11
    800021f4:	aa048493          	addi	s1,s1,-1376 # 80012c90 <proc>
    800021f8:	b7e1                	j	800021c0 <wait+0xb0>
      release(&wait_lock);
    800021fa:	00010517          	auipc	a0,0x10
    800021fe:	67e50513          	addi	a0,a0,1662 # 80012878 <wait_lock>
    80002202:	a8bfe0ef          	jal	80000c8c <release>
      return -1;
    80002206:	59fd                	li	s3,-1
    80002208:	b741                	j	80002188 <wait+0x78>

000000008000220a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000220a:	7179                	addi	sp,sp,-48
    8000220c:	f406                	sd	ra,40(sp)
    8000220e:	f022                	sd	s0,32(sp)
    80002210:	ec26                	sd	s1,24(sp)
    80002212:	e84a                	sd	s2,16(sp)
    80002214:	e44e                	sd	s3,8(sp)
    80002216:	e052                	sd	s4,0(sp)
    80002218:	1800                	addi	s0,sp,48
    8000221a:	84aa                	mv	s1,a0
    8000221c:	892e                	mv	s2,a1
    8000221e:	89b2                	mv	s3,a2
    80002220:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002222:	ebeff0ef          	jal	800018e0 <myproc>
  if(user_dst){
    80002226:	cc99                	beqz	s1,80002244 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002228:	86d2                	mv	a3,s4
    8000222a:	864e                	mv	a2,s3
    8000222c:	85ca                	mv	a1,s2
    8000222e:	6928                	ld	a0,80(a0)
    80002230:	b22ff0ef          	jal	80001552 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002234:	70a2                	ld	ra,40(sp)
    80002236:	7402                	ld	s0,32(sp)
    80002238:	64e2                	ld	s1,24(sp)
    8000223a:	6942                	ld	s2,16(sp)
    8000223c:	69a2                	ld	s3,8(sp)
    8000223e:	6a02                	ld	s4,0(sp)
    80002240:	6145                	addi	sp,sp,48
    80002242:	8082                	ret
    memmove((char *)dst, src, len);
    80002244:	000a061b          	sext.w	a2,s4
    80002248:	85ce                	mv	a1,s3
    8000224a:	854a                	mv	a0,s2
    8000224c:	ad9fe0ef          	jal	80000d24 <memmove>
    return 0;
    80002250:	8526                	mv	a0,s1
    80002252:	b7cd                	j	80002234 <either_copyout+0x2a>

0000000080002254 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002254:	7179                	addi	sp,sp,-48
    80002256:	f406                	sd	ra,40(sp)
    80002258:	f022                	sd	s0,32(sp)
    8000225a:	ec26                	sd	s1,24(sp)
    8000225c:	e84a                	sd	s2,16(sp)
    8000225e:	e44e                	sd	s3,8(sp)
    80002260:	e052                	sd	s4,0(sp)
    80002262:	1800                	addi	s0,sp,48
    80002264:	892a                	mv	s2,a0
    80002266:	84ae                	mv	s1,a1
    80002268:	89b2                	mv	s3,a2
    8000226a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000226c:	e74ff0ef          	jal	800018e0 <myproc>
  if(user_src){
    80002270:	cc99                	beqz	s1,8000228e <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002272:	86d2                	mv	a3,s4
    80002274:	864e                	mv	a2,s3
    80002276:	85ca                	mv	a1,s2
    80002278:	6928                	ld	a0,80(a0)
    8000227a:	baeff0ef          	jal	80001628 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000227e:	70a2                	ld	ra,40(sp)
    80002280:	7402                	ld	s0,32(sp)
    80002282:	64e2                	ld	s1,24(sp)
    80002284:	6942                	ld	s2,16(sp)
    80002286:	69a2                	ld	s3,8(sp)
    80002288:	6a02                	ld	s4,0(sp)
    8000228a:	6145                	addi	sp,sp,48
    8000228c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000228e:	000a061b          	sext.w	a2,s4
    80002292:	85ce                	mv	a1,s3
    80002294:	854a                	mv	a0,s2
    80002296:	a8ffe0ef          	jal	80000d24 <memmove>
    return 0;
    8000229a:	8526                	mv	a0,s1
    8000229c:	b7cd                	j	8000227e <either_copyin+0x2a>

000000008000229e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000229e:	715d                	addi	sp,sp,-80
    800022a0:	e486                	sd	ra,72(sp)
    800022a2:	e0a2                	sd	s0,64(sp)
    800022a4:	fc26                	sd	s1,56(sp)
    800022a6:	f84a                	sd	s2,48(sp)
    800022a8:	f44e                	sd	s3,40(sp)
    800022aa:	f052                	sd	s4,32(sp)
    800022ac:	ec56                	sd	s5,24(sp)
    800022ae:	e85a                	sd	s6,16(sp)
    800022b0:	e45e                	sd	s7,8(sp)
    800022b2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800022b4:	00005517          	auipc	a0,0x5
    800022b8:	dc450513          	addi	a0,a0,-572 # 80007078 <etext+0x78>
    800022bc:	a06fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800022c0:	00011497          	auipc	s1,0x11
    800022c4:	b2848493          	addi	s1,s1,-1240 # 80012de8 <proc+0x158>
    800022c8:	00016917          	auipc	s2,0x16
    800022cc:	52090913          	addi	s2,s2,1312 # 800187e8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022d0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800022d2:	00005997          	auipc	s3,0x5
    800022d6:	fce98993          	addi	s3,s3,-50 # 800072a0 <etext+0x2a0>
    printf("%d %s %s", p->pid, state, p->name);
    800022da:	00005a97          	auipc	s5,0x5
    800022de:	fcea8a93          	addi	s5,s5,-50 # 800072a8 <etext+0x2a8>
    printf("\n");
    800022e2:	00005a17          	auipc	s4,0x5
    800022e6:	d96a0a13          	addi	s4,s4,-618 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022ea:	00006b97          	auipc	s7,0x6
    800022ee:	85eb8b93          	addi	s7,s7,-1954 # 80007b48 <states.0>
    800022f2:	a829                	j	8000230c <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800022f4:	ed86a583          	lw	a1,-296(a3)
    800022f8:	8556                	mv	a0,s5
    800022fa:	9c8fe0ef          	jal	800004c2 <printf>
    printf("\n");
    800022fe:	8552                	mv	a0,s4
    80002300:	9c2fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002304:	16848493          	addi	s1,s1,360
    80002308:	03248263          	beq	s1,s2,8000232c <procdump+0x8e>
    if(p->state == UNUSED)
    8000230c:	86a6                	mv	a3,s1
    8000230e:	ec04a783          	lw	a5,-320(s1)
    80002312:	dbed                	beqz	a5,80002304 <procdump+0x66>
      state = "???";
    80002314:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002316:	fcfb6fe3          	bltu	s6,a5,800022f4 <procdump+0x56>
    8000231a:	02079713          	slli	a4,a5,0x20
    8000231e:	01d75793          	srli	a5,a4,0x1d
    80002322:	97de                	add	a5,a5,s7
    80002324:	6390                	ld	a2,0(a5)
    80002326:	f679                	bnez	a2,800022f4 <procdump+0x56>
      state = "???";
    80002328:	864e                	mv	a2,s3
    8000232a:	b7e9                	j	800022f4 <procdump+0x56>
  }
}
    8000232c:	60a6                	ld	ra,72(sp)
    8000232e:	6406                	ld	s0,64(sp)
    80002330:	74e2                	ld	s1,56(sp)
    80002332:	7942                	ld	s2,48(sp)
    80002334:	79a2                	ld	s3,40(sp)
    80002336:	7a02                	ld	s4,32(sp)
    80002338:	6ae2                	ld	s5,24(sp)
    8000233a:	6b42                	ld	s6,16(sp)
    8000233c:	6ba2                	ld	s7,8(sp)
    8000233e:	6161                	addi	sp,sp,80
    80002340:	8082                	ret

0000000080002342 <swtch>:
    80002342:	00153023          	sd	ra,0(a0)
    80002346:	00253423          	sd	sp,8(a0)
    8000234a:	e900                	sd	s0,16(a0)
    8000234c:	ed04                	sd	s1,24(a0)
    8000234e:	03253023          	sd	s2,32(a0)
    80002352:	03353423          	sd	s3,40(a0)
    80002356:	03453823          	sd	s4,48(a0)
    8000235a:	03553c23          	sd	s5,56(a0)
    8000235e:	05653023          	sd	s6,64(a0)
    80002362:	05753423          	sd	s7,72(a0)
    80002366:	05853823          	sd	s8,80(a0)
    8000236a:	05953c23          	sd	s9,88(a0)
    8000236e:	07a53023          	sd	s10,96(a0)
    80002372:	07b53423          	sd	s11,104(a0)
    80002376:	0005b083          	ld	ra,0(a1)
    8000237a:	0085b103          	ld	sp,8(a1)
    8000237e:	6980                	ld	s0,16(a1)
    80002380:	6d84                	ld	s1,24(a1)
    80002382:	0205b903          	ld	s2,32(a1)
    80002386:	0285b983          	ld	s3,40(a1)
    8000238a:	0305ba03          	ld	s4,48(a1)
    8000238e:	0385ba83          	ld	s5,56(a1)
    80002392:	0405bb03          	ld	s6,64(a1)
    80002396:	0485bb83          	ld	s7,72(a1)
    8000239a:	0505bc03          	ld	s8,80(a1)
    8000239e:	0585bc83          	ld	s9,88(a1)
    800023a2:	0605bd03          	ld	s10,96(a1)
    800023a6:	0685bd83          	ld	s11,104(a1)
    800023aa:	8082                	ret

00000000800023ac <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800023ac:	1141                	addi	sp,sp,-16
    800023ae:	e406                	sd	ra,8(sp)
    800023b0:	e022                	sd	s0,0(sp)
    800023b2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800023b4:	00005597          	auipc	a1,0x5
    800023b8:	f3458593          	addi	a1,a1,-204 # 800072e8 <etext+0x2e8>
    800023bc:	00016517          	auipc	a0,0x16
    800023c0:	2d450513          	addi	a0,a0,724 # 80018690 <tickslock>
    800023c4:	fb0fe0ef          	jal	80000b74 <initlock>
}
    800023c8:	60a2                	ld	ra,8(sp)
    800023ca:	6402                	ld	s0,0(sp)
    800023cc:	0141                	addi	sp,sp,16
    800023ce:	8082                	ret

00000000800023d0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800023d0:	1141                	addi	sp,sp,-16
    800023d2:	e422                	sd	s0,8(sp)
    800023d4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800023d6:	00003797          	auipc	a5,0x3
    800023da:	1ea78793          	addi	a5,a5,490 # 800055c0 <kernelvec>
    800023de:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800023e2:	6422                	ld	s0,8(sp)
    800023e4:	0141                	addi	sp,sp,16
    800023e6:	8082                	ret

00000000800023e8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800023e8:	1141                	addi	sp,sp,-16
    800023ea:	e406                	sd	ra,8(sp)
    800023ec:	e022                	sd	s0,0(sp)
    800023ee:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800023f0:	cf0ff0ef          	jal	800018e0 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800023f4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800023f8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800023fa:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800023fe:	00004697          	auipc	a3,0x4
    80002402:	c0268693          	addi	a3,a3,-1022 # 80006000 <_trampoline>
    80002406:	00004717          	auipc	a4,0x4
    8000240a:	bfa70713          	addi	a4,a4,-1030 # 80006000 <_trampoline>
    8000240e:	8f15                	sub	a4,a4,a3
    80002410:	040007b7          	lui	a5,0x4000
    80002414:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002416:	07b2                	slli	a5,a5,0xc
    80002418:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000241a:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000241e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002420:	18002673          	csrr	a2,satp
    80002424:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002426:	6d30                	ld	a2,88(a0)
    80002428:	6138                	ld	a4,64(a0)
    8000242a:	6585                	lui	a1,0x1
    8000242c:	972e                	add	a4,a4,a1
    8000242e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002430:	6d38                	ld	a4,88(a0)
    80002432:	00000617          	auipc	a2,0x0
    80002436:	11060613          	addi	a2,a2,272 # 80002542 <usertrap>
    8000243a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000243c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000243e:	8612                	mv	a2,tp
    80002440:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002442:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002446:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000244a:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000244e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002452:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002454:	6f18                	ld	a4,24(a4)
    80002456:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000245a:	6928                	ld	a0,80(a0)
    8000245c:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000245e:	00004717          	auipc	a4,0x4
    80002462:	c3e70713          	addi	a4,a4,-962 # 8000609c <userret>
    80002466:	8f15                	sub	a4,a4,a3
    80002468:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000246a:	577d                	li	a4,-1
    8000246c:	177e                	slli	a4,a4,0x3f
    8000246e:	8d59                	or	a0,a0,a4
    80002470:	9782                	jalr	a5
}
    80002472:	60a2                	ld	ra,8(sp)
    80002474:	6402                	ld	s0,0(sp)
    80002476:	0141                	addi	sp,sp,16
    80002478:	8082                	ret

000000008000247a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000247a:	1101                	addi	sp,sp,-32
    8000247c:	ec06                	sd	ra,24(sp)
    8000247e:	e822                	sd	s0,16(sp)
    80002480:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002482:	c32ff0ef          	jal	800018b4 <cpuid>
    80002486:	cd11                	beqz	a0,800024a2 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002488:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000248c:	000f4737          	lui	a4,0xf4
    80002490:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002494:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002496:	14d79073          	csrw	stimecmp,a5
}
    8000249a:	60e2                	ld	ra,24(sp)
    8000249c:	6442                	ld	s0,16(sp)
    8000249e:	6105                	addi	sp,sp,32
    800024a0:	8082                	ret
    800024a2:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800024a4:	00016497          	auipc	s1,0x16
    800024a8:	1ec48493          	addi	s1,s1,492 # 80018690 <tickslock>
    800024ac:	8526                	mv	a0,s1
    800024ae:	f46fe0ef          	jal	80000bf4 <acquire>
    ticks++;
    800024b2:	00008517          	auipc	a0,0x8
    800024b6:	27e50513          	addi	a0,a0,638 # 8000a730 <ticks>
    800024ba:	411c                	lw	a5,0(a0)
    800024bc:	2785                	addiw	a5,a5,1
    800024be:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800024c0:	a3bff0ef          	jal	80001efa <wakeup>
    release(&tickslock);
    800024c4:	8526                	mv	a0,s1
    800024c6:	fc6fe0ef          	jal	80000c8c <release>
    800024ca:	64a2                	ld	s1,8(sp)
    800024cc:	bf75                	j	80002488 <clockintr+0xe>

00000000800024ce <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800024ce:	1101                	addi	sp,sp,-32
    800024d0:	ec06                	sd	ra,24(sp)
    800024d2:	e822                	sd	s0,16(sp)
    800024d4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800024d6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800024da:	57fd                	li	a5,-1
    800024dc:	17fe                	slli	a5,a5,0x3f
    800024de:	07a5                	addi	a5,a5,9
    800024e0:	00f70c63          	beq	a4,a5,800024f8 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800024e4:	57fd                	li	a5,-1
    800024e6:	17fe                	slli	a5,a5,0x3f
    800024e8:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800024ea:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800024ec:	04f70763          	beq	a4,a5,8000253a <devintr+0x6c>
  }
}
    800024f0:	60e2                	ld	ra,24(sp)
    800024f2:	6442                	ld	s0,16(sp)
    800024f4:	6105                	addi	sp,sp,32
    800024f6:	8082                	ret
    800024f8:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800024fa:	172030ef          	jal	8000566c <plic_claim>
    800024fe:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002500:	47a9                	li	a5,10
    80002502:	00f50963          	beq	a0,a5,80002514 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80002506:	4785                	li	a5,1
    80002508:	00f50963          	beq	a0,a5,8000251a <devintr+0x4c>
    return 1;
    8000250c:	4505                	li	a0,1
    } else if(irq){
    8000250e:	e889                	bnez	s1,80002520 <devintr+0x52>
    80002510:	64a2                	ld	s1,8(sp)
    80002512:	bff9                	j	800024f0 <devintr+0x22>
      uartintr();
    80002514:	cf2fe0ef          	jal	80000a06 <uartintr>
    if(irq)
    80002518:	a819                	j	8000252e <devintr+0x60>
      virtio_disk_intr();
    8000251a:	618030ef          	jal	80005b32 <virtio_disk_intr>
    if(irq)
    8000251e:	a801                	j	8000252e <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002520:	85a6                	mv	a1,s1
    80002522:	00005517          	auipc	a0,0x5
    80002526:	dce50513          	addi	a0,a0,-562 # 800072f0 <etext+0x2f0>
    8000252a:	f99fd0ef          	jal	800004c2 <printf>
      plic_complete(irq);
    8000252e:	8526                	mv	a0,s1
    80002530:	15c030ef          	jal	8000568c <plic_complete>
    return 1;
    80002534:	4505                	li	a0,1
    80002536:	64a2                	ld	s1,8(sp)
    80002538:	bf65                	j	800024f0 <devintr+0x22>
    clockintr();
    8000253a:	f41ff0ef          	jal	8000247a <clockintr>
    return 2;
    8000253e:	4509                	li	a0,2
    80002540:	bf45                	j	800024f0 <devintr+0x22>

0000000080002542 <usertrap>:
{
    80002542:	1101                	addi	sp,sp,-32
    80002544:	ec06                	sd	ra,24(sp)
    80002546:	e822                	sd	s0,16(sp)
    80002548:	e426                	sd	s1,8(sp)
    8000254a:	e04a                	sd	s2,0(sp)
    8000254c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000254e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002552:	1007f793          	andi	a5,a5,256
    80002556:	ef85                	bnez	a5,8000258e <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002558:	00003797          	auipc	a5,0x3
    8000255c:	06878793          	addi	a5,a5,104 # 800055c0 <kernelvec>
    80002560:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002564:	b7cff0ef          	jal	800018e0 <myproc>
    80002568:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000256a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000256c:	14102773          	csrr	a4,sepc
    80002570:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002572:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002576:	47a1                	li	a5,8
    80002578:	02f70163          	beq	a4,a5,8000259a <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    8000257c:	f53ff0ef          	jal	800024ce <devintr>
    80002580:	892a                	mv	s2,a0
    80002582:	c135                	beqz	a0,800025e6 <usertrap+0xa4>
  if(killed(p))
    80002584:	8526                	mv	a0,s1
    80002586:	b61ff0ef          	jal	800020e6 <killed>
    8000258a:	cd1d                	beqz	a0,800025c8 <usertrap+0x86>
    8000258c:	a81d                	j	800025c2 <usertrap+0x80>
    panic("usertrap: not from user mode");
    8000258e:	00005517          	auipc	a0,0x5
    80002592:	d8250513          	addi	a0,a0,-638 # 80007310 <etext+0x310>
    80002596:	9fefe0ef          	jal	80000794 <panic>
    if(killed(p))
    8000259a:	b4dff0ef          	jal	800020e6 <killed>
    8000259e:	e121                	bnez	a0,800025de <usertrap+0x9c>
    p->trapframe->epc += 4;
    800025a0:	6cb8                	ld	a4,88(s1)
    800025a2:	6f1c                	ld	a5,24(a4)
    800025a4:	0791                	addi	a5,a5,4
    800025a6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025a8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800025ac:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025b0:	10079073          	csrw	sstatus,a5
    syscall();
    800025b4:	248000ef          	jal	800027fc <syscall>
  if(killed(p))
    800025b8:	8526                	mv	a0,s1
    800025ba:	b2dff0ef          	jal	800020e6 <killed>
    800025be:	c901                	beqz	a0,800025ce <usertrap+0x8c>
    800025c0:	4901                	li	s2,0
    exit(-1);
    800025c2:	557d                	li	a0,-1
    800025c4:	9f7ff0ef          	jal	80001fba <exit>
  if(which_dev == 2)
    800025c8:	4789                	li	a5,2
    800025ca:	04f90563          	beq	s2,a5,80002614 <usertrap+0xd2>
  usertrapret();
    800025ce:	e1bff0ef          	jal	800023e8 <usertrapret>
}
    800025d2:	60e2                	ld	ra,24(sp)
    800025d4:	6442                	ld	s0,16(sp)
    800025d6:	64a2                	ld	s1,8(sp)
    800025d8:	6902                	ld	s2,0(sp)
    800025da:	6105                	addi	sp,sp,32
    800025dc:	8082                	ret
      exit(-1);
    800025de:	557d                	li	a0,-1
    800025e0:	9dbff0ef          	jal	80001fba <exit>
    800025e4:	bf75                	j	800025a0 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025e6:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800025ea:	5890                	lw	a2,48(s1)
    800025ec:	00005517          	auipc	a0,0x5
    800025f0:	d4450513          	addi	a0,a0,-700 # 80007330 <etext+0x330>
    800025f4:	ecffd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025f8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800025fc:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002600:	00005517          	auipc	a0,0x5
    80002604:	d6050513          	addi	a0,a0,-672 # 80007360 <etext+0x360>
    80002608:	ebbfd0ef          	jal	800004c2 <printf>
    setkilled(p);
    8000260c:	8526                	mv	a0,s1
    8000260e:	ab5ff0ef          	jal	800020c2 <setkilled>
    80002612:	b75d                	j	800025b8 <usertrap+0x76>
    yield();
    80002614:	86fff0ef          	jal	80001e82 <yield>
    80002618:	bf5d                	j	800025ce <usertrap+0x8c>

000000008000261a <kerneltrap>:
{
    8000261a:	7179                	addi	sp,sp,-48
    8000261c:	f406                	sd	ra,40(sp)
    8000261e:	f022                	sd	s0,32(sp)
    80002620:	ec26                	sd	s1,24(sp)
    80002622:	e84a                	sd	s2,16(sp)
    80002624:	e44e                	sd	s3,8(sp)
    80002626:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002628:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000262c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002630:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002634:	1004f793          	andi	a5,s1,256
    80002638:	c795                	beqz	a5,80002664 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000263a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000263e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002640:	eb85                	bnez	a5,80002670 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002642:	e8dff0ef          	jal	800024ce <devintr>
    80002646:	c91d                	beqz	a0,8000267c <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002648:	4789                	li	a5,2
    8000264a:	04f50a63          	beq	a0,a5,8000269e <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000264e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002652:	10049073          	csrw	sstatus,s1
}
    80002656:	70a2                	ld	ra,40(sp)
    80002658:	7402                	ld	s0,32(sp)
    8000265a:	64e2                	ld	s1,24(sp)
    8000265c:	6942                	ld	s2,16(sp)
    8000265e:	69a2                	ld	s3,8(sp)
    80002660:	6145                	addi	sp,sp,48
    80002662:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002664:	00005517          	auipc	a0,0x5
    80002668:	d2450513          	addi	a0,a0,-732 # 80007388 <etext+0x388>
    8000266c:	928fe0ef          	jal	80000794 <panic>
    panic("kerneltrap: interrupts enabled");
    80002670:	00005517          	auipc	a0,0x5
    80002674:	d4050513          	addi	a0,a0,-704 # 800073b0 <etext+0x3b0>
    80002678:	91cfe0ef          	jal	80000794 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000267c:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002680:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002684:	85ce                	mv	a1,s3
    80002686:	00005517          	auipc	a0,0x5
    8000268a:	d4a50513          	addi	a0,a0,-694 # 800073d0 <etext+0x3d0>
    8000268e:	e35fd0ef          	jal	800004c2 <printf>
    panic("kerneltrap");
    80002692:	00005517          	auipc	a0,0x5
    80002696:	d6650513          	addi	a0,a0,-666 # 800073f8 <etext+0x3f8>
    8000269a:	8fafe0ef          	jal	80000794 <panic>
  if(which_dev == 2 && myproc() != 0)
    8000269e:	a42ff0ef          	jal	800018e0 <myproc>
    800026a2:	d555                	beqz	a0,8000264e <kerneltrap+0x34>
    yield();
    800026a4:	fdeff0ef          	jal	80001e82 <yield>
    800026a8:	b75d                	j	8000264e <kerneltrap+0x34>

00000000800026aa <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800026aa:	1101                	addi	sp,sp,-32
    800026ac:	ec06                	sd	ra,24(sp)
    800026ae:	e822                	sd	s0,16(sp)
    800026b0:	e426                	sd	s1,8(sp)
    800026b2:	1000                	addi	s0,sp,32
    800026b4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800026b6:	a2aff0ef          	jal	800018e0 <myproc>
  switch (n) {
    800026ba:	4795                	li	a5,5
    800026bc:	0497e163          	bltu	a5,s1,800026fe <argraw+0x54>
    800026c0:	048a                	slli	s1,s1,0x2
    800026c2:	00005717          	auipc	a4,0x5
    800026c6:	4b670713          	addi	a4,a4,1206 # 80007b78 <states.0+0x30>
    800026ca:	94ba                	add	s1,s1,a4
    800026cc:	409c                	lw	a5,0(s1)
    800026ce:	97ba                	add	a5,a5,a4
    800026d0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800026d2:	6d3c                	ld	a5,88(a0)
    800026d4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800026d6:	60e2                	ld	ra,24(sp)
    800026d8:	6442                	ld	s0,16(sp)
    800026da:	64a2                	ld	s1,8(sp)
    800026dc:	6105                	addi	sp,sp,32
    800026de:	8082                	ret
    return p->trapframe->a1;
    800026e0:	6d3c                	ld	a5,88(a0)
    800026e2:	7fa8                	ld	a0,120(a5)
    800026e4:	bfcd                	j	800026d6 <argraw+0x2c>
    return p->trapframe->a2;
    800026e6:	6d3c                	ld	a5,88(a0)
    800026e8:	63c8                	ld	a0,128(a5)
    800026ea:	b7f5                	j	800026d6 <argraw+0x2c>
    return p->trapframe->a3;
    800026ec:	6d3c                	ld	a5,88(a0)
    800026ee:	67c8                	ld	a0,136(a5)
    800026f0:	b7dd                	j	800026d6 <argraw+0x2c>
    return p->trapframe->a4;
    800026f2:	6d3c                	ld	a5,88(a0)
    800026f4:	6bc8                	ld	a0,144(a5)
    800026f6:	b7c5                	j	800026d6 <argraw+0x2c>
    return p->trapframe->a5;
    800026f8:	6d3c                	ld	a5,88(a0)
    800026fa:	6fc8                	ld	a0,152(a5)
    800026fc:	bfe9                	j	800026d6 <argraw+0x2c>
  panic("argraw");
    800026fe:	00005517          	auipc	a0,0x5
    80002702:	d0a50513          	addi	a0,a0,-758 # 80007408 <etext+0x408>
    80002706:	88efe0ef          	jal	80000794 <panic>

000000008000270a <fetchaddr>:
{
    8000270a:	1101                	addi	sp,sp,-32
    8000270c:	ec06                	sd	ra,24(sp)
    8000270e:	e822                	sd	s0,16(sp)
    80002710:	e426                	sd	s1,8(sp)
    80002712:	e04a                	sd	s2,0(sp)
    80002714:	1000                	addi	s0,sp,32
    80002716:	84aa                	mv	s1,a0
    80002718:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000271a:	9c6ff0ef          	jal	800018e0 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000271e:	653c                	ld	a5,72(a0)
    80002720:	02f4f663          	bgeu	s1,a5,8000274c <fetchaddr+0x42>
    80002724:	00848713          	addi	a4,s1,8
    80002728:	02e7e463          	bltu	a5,a4,80002750 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000272c:	46a1                	li	a3,8
    8000272e:	8626                	mv	a2,s1
    80002730:	85ca                	mv	a1,s2
    80002732:	6928                	ld	a0,80(a0)
    80002734:	ef5fe0ef          	jal	80001628 <copyin>
    80002738:	00a03533          	snez	a0,a0
    8000273c:	40a00533          	neg	a0,a0
}
    80002740:	60e2                	ld	ra,24(sp)
    80002742:	6442                	ld	s0,16(sp)
    80002744:	64a2                	ld	s1,8(sp)
    80002746:	6902                	ld	s2,0(sp)
    80002748:	6105                	addi	sp,sp,32
    8000274a:	8082                	ret
    return -1;
    8000274c:	557d                	li	a0,-1
    8000274e:	bfcd                	j	80002740 <fetchaddr+0x36>
    80002750:	557d                	li	a0,-1
    80002752:	b7fd                	j	80002740 <fetchaddr+0x36>

0000000080002754 <fetchstr>:
{
    80002754:	7179                	addi	sp,sp,-48
    80002756:	f406                	sd	ra,40(sp)
    80002758:	f022                	sd	s0,32(sp)
    8000275a:	ec26                	sd	s1,24(sp)
    8000275c:	e84a                	sd	s2,16(sp)
    8000275e:	e44e                	sd	s3,8(sp)
    80002760:	1800                	addi	s0,sp,48
    80002762:	892a                	mv	s2,a0
    80002764:	84ae                	mv	s1,a1
    80002766:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002768:	978ff0ef          	jal	800018e0 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000276c:	86ce                	mv	a3,s3
    8000276e:	864a                	mv	a2,s2
    80002770:	85a6                	mv	a1,s1
    80002772:	6928                	ld	a0,80(a0)
    80002774:	f3bfe0ef          	jal	800016ae <copyinstr>
    80002778:	00054c63          	bltz	a0,80002790 <fetchstr+0x3c>
  return strlen(buf);
    8000277c:	8526                	mv	a0,s1
    8000277e:	ebafe0ef          	jal	80000e38 <strlen>
}
    80002782:	70a2                	ld	ra,40(sp)
    80002784:	7402                	ld	s0,32(sp)
    80002786:	64e2                	ld	s1,24(sp)
    80002788:	6942                	ld	s2,16(sp)
    8000278a:	69a2                	ld	s3,8(sp)
    8000278c:	6145                	addi	sp,sp,48
    8000278e:	8082                	ret
    return -1;
    80002790:	557d                	li	a0,-1
    80002792:	bfc5                	j	80002782 <fetchstr+0x2e>

0000000080002794 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002794:	1101                	addi	sp,sp,-32
    80002796:	ec06                	sd	ra,24(sp)
    80002798:	e822                	sd	s0,16(sp)
    8000279a:	e426                	sd	s1,8(sp)
    8000279c:	1000                	addi	s0,sp,32
    8000279e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027a0:	f0bff0ef          	jal	800026aa <argraw>
    800027a4:	c088                	sw	a0,0(s1)
}
    800027a6:	60e2                	ld	ra,24(sp)
    800027a8:	6442                	ld	s0,16(sp)
    800027aa:	64a2                	ld	s1,8(sp)
    800027ac:	6105                	addi	sp,sp,32
    800027ae:	8082                	ret

00000000800027b0 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800027b0:	1101                	addi	sp,sp,-32
    800027b2:	ec06                	sd	ra,24(sp)
    800027b4:	e822                	sd	s0,16(sp)
    800027b6:	e426                	sd	s1,8(sp)
    800027b8:	1000                	addi	s0,sp,32
    800027ba:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027bc:	eefff0ef          	jal	800026aa <argraw>
    800027c0:	e088                	sd	a0,0(s1)
}
    800027c2:	60e2                	ld	ra,24(sp)
    800027c4:	6442                	ld	s0,16(sp)
    800027c6:	64a2                	ld	s1,8(sp)
    800027c8:	6105                	addi	sp,sp,32
    800027ca:	8082                	ret

00000000800027cc <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800027cc:	7179                	addi	sp,sp,-48
    800027ce:	f406                	sd	ra,40(sp)
    800027d0:	f022                	sd	s0,32(sp)
    800027d2:	ec26                	sd	s1,24(sp)
    800027d4:	e84a                	sd	s2,16(sp)
    800027d6:	1800                	addi	s0,sp,48
    800027d8:	84ae                	mv	s1,a1
    800027da:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800027dc:	fd840593          	addi	a1,s0,-40
    800027e0:	fd1ff0ef          	jal	800027b0 <argaddr>
  return fetchstr(addr, buf, max);
    800027e4:	864a                	mv	a2,s2
    800027e6:	85a6                	mv	a1,s1
    800027e8:	fd843503          	ld	a0,-40(s0)
    800027ec:	f69ff0ef          	jal	80002754 <fetchstr>
}
    800027f0:	70a2                	ld	ra,40(sp)
    800027f2:	7402                	ld	s0,32(sp)
    800027f4:	64e2                	ld	s1,24(sp)
    800027f6:	6942                	ld	s2,16(sp)
    800027f8:	6145                	addi	sp,sp,48
    800027fa:	8082                	ret

00000000800027fc <syscall>:
[SYS_sem_down] sys_sem_down,
};

void
syscall(void)
{
    800027fc:	1101                	addi	sp,sp,-32
    800027fe:	ec06                	sd	ra,24(sp)
    80002800:	e822                	sd	s0,16(sp)
    80002802:	e426                	sd	s1,8(sp)
    80002804:	e04a                	sd	s2,0(sp)
    80002806:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002808:	8d8ff0ef          	jal	800018e0 <myproc>
    8000280c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000280e:	05853903          	ld	s2,88(a0)
    80002812:	0a893783          	ld	a5,168(s2)
    80002816:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000281a:	37fd                	addiw	a5,a5,-1
    8000281c:	475d                	li	a4,23
    8000281e:	00f76f63          	bltu	a4,a5,8000283c <syscall+0x40>
    80002822:	00369713          	slli	a4,a3,0x3
    80002826:	00005797          	auipc	a5,0x5
    8000282a:	36a78793          	addi	a5,a5,874 # 80007b90 <syscalls>
    8000282e:	97ba                	add	a5,a5,a4
    80002830:	639c                	ld	a5,0(a5)
    80002832:	c789                	beqz	a5,8000283c <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002834:	9782                	jalr	a5
    80002836:	06a93823          	sd	a0,112(s2)
    8000283a:	a829                	j	80002854 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000283c:	15848613          	addi	a2,s1,344
    80002840:	588c                	lw	a1,48(s1)
    80002842:	00005517          	auipc	a0,0x5
    80002846:	bce50513          	addi	a0,a0,-1074 # 80007410 <etext+0x410>
    8000284a:	c79fd0ef          	jal	800004c2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000284e:	6cbc                	ld	a5,88(s1)
    80002850:	577d                	li	a4,-1
    80002852:	fbb8                	sd	a4,112(a5)
  }
}
    80002854:	60e2                	ld	ra,24(sp)
    80002856:	6442                	ld	s0,16(sp)
    80002858:	64a2                	ld	s1,8(sp)
    8000285a:	6902                	ld	s2,0(sp)
    8000285c:	6105                	addi	sp,sp,32
    8000285e:	8082                	ret

0000000080002860 <sem_initialize>:
    int value;        // Counter for available resources
    void *chan;       // Channel for sleeping processes
    struct spinlock lock; // Spinlock for mutual exclusion
};
void
sem_initialize(struct sem *s, int value) {
    80002860:	1141                	addi	sp,sp,-16
    80002862:	e406                	sd	ra,8(sp)
    80002864:	e022                	sd	s0,0(sp)
    80002866:	0800                	addi	s0,sp,16
    s->value = value;
    80002868:	c10c                	sw	a1,0(a0)
    s->chan = s; // Use the semaphore's address as the channel
    8000286a:	e508                	sd	a0,8(a0)
    initlock(&s->lock, "semaphore");
    8000286c:	00005597          	auipc	a1,0x5
    80002870:	bc458593          	addi	a1,a1,-1084 # 80007430 <etext+0x430>
    80002874:	0541                	addi	a0,a0,16
    80002876:	afefe0ef          	jal	80000b74 <initlock>
}
    8000287a:	60a2                	ld	ra,8(sp)
    8000287c:	6402                	ld	s0,0(sp)
    8000287e:	0141                	addi	sp,sp,16
    80002880:	8082                	ret

0000000080002882 <sem_down>:

void
sem_down(struct sem *s) {
    80002882:	1101                	addi	sp,sp,-32
    80002884:	ec06                	sd	ra,24(sp)
    80002886:	e822                	sd	s0,16(sp)
    80002888:	e426                	sd	s1,8(sp)
    8000288a:	e04a                	sd	s2,0(sp)
    8000288c:	1000                	addi	s0,sp,32
    8000288e:	84aa                	mv	s1,a0
    acquire(&s->lock);
    80002890:	01050913          	addi	s2,a0,16
    80002894:	854a                	mv	a0,s2
    80002896:	b5efe0ef          	jal	80000bf4 <acquire>
    s->value--;
    8000289a:	409c                	lw	a5,0(s1)
    8000289c:	37fd                	addiw	a5,a5,-1
    8000289e:	c09c                	sw	a5,0(s1)
    if (s->value < 0) {
    800028a0:	02079713          	slli	a4,a5,0x20
    800028a4:	00074b63          	bltz	a4,800028ba <sem_down+0x38>
        sleep(s->chan, &s->lock); // Sleep until signaled
    }
    release(&s->lock);
    800028a8:	854a                	mv	a0,s2
    800028aa:	be2fe0ef          	jal	80000c8c <release>
}
    800028ae:	60e2                	ld	ra,24(sp)
    800028b0:	6442                	ld	s0,16(sp)
    800028b2:	64a2                	ld	s1,8(sp)
    800028b4:	6902                	ld	s2,0(sp)
    800028b6:	6105                	addi	sp,sp,32
    800028b8:	8082                	ret
        sleep(s->chan, &s->lock); // Sleep until signaled
    800028ba:	85ca                	mv	a1,s2
    800028bc:	6488                	ld	a0,8(s1)
    800028be:	df0ff0ef          	jal	80001eae <sleep>
    800028c2:	b7dd                	j	800028a8 <sem_down+0x26>

00000000800028c4 <sem_up>:

void
sem_up(struct sem *s) {
    800028c4:	1101                	addi	sp,sp,-32
    800028c6:	ec06                	sd	ra,24(sp)
    800028c8:	e822                	sd	s0,16(sp)
    800028ca:	e426                	sd	s1,8(sp)
    800028cc:	e04a                	sd	s2,0(sp)
    800028ce:	1000                	addi	s0,sp,32
    800028d0:	84aa                	mv	s1,a0
    acquire(&s->lock);
    800028d2:	01050913          	addi	s2,a0,16
    800028d6:	854a                	mv	a0,s2
    800028d8:	b1cfe0ef          	jal	80000bf4 <acquire>
    s->value++;
    800028dc:	409c                	lw	a5,0(s1)
    800028de:	2785                	addiw	a5,a5,1
    800028e0:	0007871b          	sext.w	a4,a5
    800028e4:	c09c                	sw	a5,0(s1)
    if (s->value <= 0) {
    800028e6:	00e05b63          	blez	a4,800028fc <sem_up+0x38>
        wakeup(s->chan); // Wake up one sleeping process
    }
    release(&s->lock);
    800028ea:	854a                	mv	a0,s2
    800028ec:	ba0fe0ef          	jal	80000c8c <release>
}
    800028f0:	60e2                	ld	ra,24(sp)
    800028f2:	6442                	ld	s0,16(sp)
    800028f4:	64a2                	ld	s1,8(sp)
    800028f6:	6902                	ld	s2,0(sp)
    800028f8:	6105                	addi	sp,sp,32
    800028fa:	8082                	ret
        wakeup(s->chan); // Wake up one sleeping process
    800028fc:	6488                	ld	a0,8(s1)
    800028fe:	dfcff0ef          	jal	80001efa <wakeup>
    80002902:	b7e5                	j	800028ea <sem_up+0x26>

0000000080002904 <sys_exit>:
#include "proc.h"


uint64
sys_exit(void)
{
    80002904:	1101                	addi	sp,sp,-32
    80002906:	ec06                	sd	ra,24(sp)
    80002908:	e822                	sd	s0,16(sp)
    8000290a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000290c:	fec40593          	addi	a1,s0,-20
    80002910:	4501                	li	a0,0
    80002912:	e83ff0ef          	jal	80002794 <argint>
  exit(n);
    80002916:	fec42503          	lw	a0,-20(s0)
    8000291a:	ea0ff0ef          	jal	80001fba <exit>
  return 0;  // not reached
}
    8000291e:	4501                	li	a0,0
    80002920:	60e2                	ld	ra,24(sp)
    80002922:	6442                	ld	s0,16(sp)
    80002924:	6105                	addi	sp,sp,32
    80002926:	8082                	ret

0000000080002928 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002928:	1141                	addi	sp,sp,-16
    8000292a:	e406                	sd	ra,8(sp)
    8000292c:	e022                	sd	s0,0(sp)
    8000292e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002930:	fb1fe0ef          	jal	800018e0 <myproc>
}
    80002934:	5908                	lw	a0,48(a0)
    80002936:	60a2                	ld	ra,8(sp)
    80002938:	6402                	ld	s0,0(sp)
    8000293a:	0141                	addi	sp,sp,16
    8000293c:	8082                	ret

000000008000293e <sys_fork>:

uint64
sys_fork(void)
{
    8000293e:	1141                	addi	sp,sp,-16
    80002940:	e406                	sd	ra,8(sp)
    80002942:	e022                	sd	s0,0(sp)
    80002944:	0800                	addi	s0,sp,16
  return fork();
    80002946:	ac0ff0ef          	jal	80001c06 <fork>
}
    8000294a:	60a2                	ld	ra,8(sp)
    8000294c:	6402                	ld	s0,0(sp)
    8000294e:	0141                	addi	sp,sp,16
    80002950:	8082                	ret

0000000080002952 <sys_wait>:

uint64
sys_wait(void)
{
    80002952:	1101                	addi	sp,sp,-32
    80002954:	ec06                	sd	ra,24(sp)
    80002956:	e822                	sd	s0,16(sp)
    80002958:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000295a:	fe840593          	addi	a1,s0,-24
    8000295e:	4501                	li	a0,0
    80002960:	e51ff0ef          	jal	800027b0 <argaddr>
  return wait(p);
    80002964:	fe843503          	ld	a0,-24(s0)
    80002968:	fa8ff0ef          	jal	80002110 <wait>
}
    8000296c:	60e2                	ld	ra,24(sp)
    8000296e:	6442                	ld	s0,16(sp)
    80002970:	6105                	addi	sp,sp,32
    80002972:	8082                	ret

0000000080002974 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002974:	7179                	addi	sp,sp,-48
    80002976:	f406                	sd	ra,40(sp)
    80002978:	f022                	sd	s0,32(sp)
    8000297a:	ec26                	sd	s1,24(sp)
    8000297c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000297e:	fdc40593          	addi	a1,s0,-36
    80002982:	4501                	li	a0,0
    80002984:	e11ff0ef          	jal	80002794 <argint>
  addr = myproc()->sz;
    80002988:	f59fe0ef          	jal	800018e0 <myproc>
    8000298c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000298e:	fdc42503          	lw	a0,-36(s0)
    80002992:	a24ff0ef          	jal	80001bb6 <growproc>
    80002996:	00054863          	bltz	a0,800029a6 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    8000299a:	8526                	mv	a0,s1
    8000299c:	70a2                	ld	ra,40(sp)
    8000299e:	7402                	ld	s0,32(sp)
    800029a0:	64e2                	ld	s1,24(sp)
    800029a2:	6145                	addi	sp,sp,48
    800029a4:	8082                	ret
    return -1;
    800029a6:	54fd                	li	s1,-1
    800029a8:	bfcd                	j	8000299a <sys_sbrk+0x26>

00000000800029aa <sys_sleep>:

uint64
sys_sleep(void)
{
    800029aa:	7139                	addi	sp,sp,-64
    800029ac:	fc06                	sd	ra,56(sp)
    800029ae:	f822                	sd	s0,48(sp)
    800029b0:	f04a                	sd	s2,32(sp)
    800029b2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800029b4:	fcc40593          	addi	a1,s0,-52
    800029b8:	4501                	li	a0,0
    800029ba:	ddbff0ef          	jal	80002794 <argint>
  if(n < 0)
    800029be:	fcc42783          	lw	a5,-52(s0)
    800029c2:	0607c763          	bltz	a5,80002a30 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    800029c6:	00016517          	auipc	a0,0x16
    800029ca:	cca50513          	addi	a0,a0,-822 # 80018690 <tickslock>
    800029ce:	a26fe0ef          	jal	80000bf4 <acquire>
  ticks0 = ticks;
    800029d2:	00008917          	auipc	s2,0x8
    800029d6:	d5e92903          	lw	s2,-674(s2) # 8000a730 <ticks>
  while(ticks - ticks0 < n){
    800029da:	fcc42783          	lw	a5,-52(s0)
    800029de:	cf8d                	beqz	a5,80002a18 <sys_sleep+0x6e>
    800029e0:	f426                	sd	s1,40(sp)
    800029e2:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800029e4:	00016997          	auipc	s3,0x16
    800029e8:	cac98993          	addi	s3,s3,-852 # 80018690 <tickslock>
    800029ec:	00008497          	auipc	s1,0x8
    800029f0:	d4448493          	addi	s1,s1,-700 # 8000a730 <ticks>
    if(killed(myproc())){
    800029f4:	eedfe0ef          	jal	800018e0 <myproc>
    800029f8:	eeeff0ef          	jal	800020e6 <killed>
    800029fc:	ed0d                	bnez	a0,80002a36 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    800029fe:	85ce                	mv	a1,s3
    80002a00:	8526                	mv	a0,s1
    80002a02:	cacff0ef          	jal	80001eae <sleep>
  while(ticks - ticks0 < n){
    80002a06:	409c                	lw	a5,0(s1)
    80002a08:	412787bb          	subw	a5,a5,s2
    80002a0c:	fcc42703          	lw	a4,-52(s0)
    80002a10:	fee7e2e3          	bltu	a5,a4,800029f4 <sys_sleep+0x4a>
    80002a14:	74a2                	ld	s1,40(sp)
    80002a16:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002a18:	00016517          	auipc	a0,0x16
    80002a1c:	c7850513          	addi	a0,a0,-904 # 80018690 <tickslock>
    80002a20:	a6cfe0ef          	jal	80000c8c <release>
  return 0;
    80002a24:	4501                	li	a0,0
}
    80002a26:	70e2                	ld	ra,56(sp)
    80002a28:	7442                	ld	s0,48(sp)
    80002a2a:	7902                	ld	s2,32(sp)
    80002a2c:	6121                	addi	sp,sp,64
    80002a2e:	8082                	ret
    n = 0;
    80002a30:	fc042623          	sw	zero,-52(s0)
    80002a34:	bf49                	j	800029c6 <sys_sleep+0x1c>
      release(&tickslock);
    80002a36:	00016517          	auipc	a0,0x16
    80002a3a:	c5a50513          	addi	a0,a0,-934 # 80018690 <tickslock>
    80002a3e:	a4efe0ef          	jal	80000c8c <release>
      return -1;
    80002a42:	557d                	li	a0,-1
    80002a44:	74a2                	ld	s1,40(sp)
    80002a46:	69e2                	ld	s3,24(sp)
    80002a48:	bff9                	j	80002a26 <sys_sleep+0x7c>

0000000080002a4a <sys_kill>:

uint64
sys_kill(void)
{
    80002a4a:	1101                	addi	sp,sp,-32
    80002a4c:	ec06                	sd	ra,24(sp)
    80002a4e:	e822                	sd	s0,16(sp)
    80002a50:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002a52:	fec40593          	addi	a1,s0,-20
    80002a56:	4501                	li	a0,0
    80002a58:	d3dff0ef          	jal	80002794 <argint>
  return kill(pid);
    80002a5c:	fec42503          	lw	a0,-20(s0)
    80002a60:	dfcff0ef          	jal	8000205c <kill>
}
    80002a64:	60e2                	ld	ra,24(sp)
    80002a66:	6442                	ld	s0,16(sp)
    80002a68:	6105                	addi	sp,sp,32
    80002a6a:	8082                	ret

0000000080002a6c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002a6c:	1101                	addi	sp,sp,-32
    80002a6e:	ec06                	sd	ra,24(sp)
    80002a70:	e822                	sd	s0,16(sp)
    80002a72:	e426                	sd	s1,8(sp)
    80002a74:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002a76:	00016517          	auipc	a0,0x16
    80002a7a:	c1a50513          	addi	a0,a0,-998 # 80018690 <tickslock>
    80002a7e:	976fe0ef          	jal	80000bf4 <acquire>
  xticks = ticks;
    80002a82:	00008497          	auipc	s1,0x8
    80002a86:	cae4a483          	lw	s1,-850(s1) # 8000a730 <ticks>
  release(&tickslock);
    80002a8a:	00016517          	auipc	a0,0x16
    80002a8e:	c0650513          	addi	a0,a0,-1018 # 80018690 <tickslock>
    80002a92:	9fafe0ef          	jal	80000c8c <release>
  return xticks;
}
    80002a96:	02049513          	slli	a0,s1,0x20
    80002a9a:	9101                	srli	a0,a0,0x20
    80002a9c:	60e2                	ld	ra,24(sp)
    80002a9e:	6442                	ld	s0,16(sp)
    80002aa0:	64a2                	ld	s1,8(sp)
    80002aa2:	6105                	addi	sp,sp,32
    80002aa4:	8082                	ret

0000000080002aa6 <sys_sem_init>:

int sys_sem_init(void) {
    80002aa6:	7179                	addi	sp,sp,-48
    80002aa8:	f406                	sd	ra,40(sp)
    80002aaa:	f022                	sd	s0,32(sp)
    80002aac:	1800                	addi	s0,sp,48
    struct sem *s;
    uint64 addr;  // To store the user-space address
    int value = -1;  // Initialize to an invalid value
    80002aae:	57fd                	li	a5,-1
    80002ab0:	fcf42a23          	sw	a5,-44(s0)

    // Retrieve the pointer argument (user-space address of semaphore struct)
    argaddr(0, &addr);  // Just call argaddr, no need to check return value here
    80002ab4:	fd840593          	addi	a1,s0,-40
    80002ab8:	4501                	li	a0,0
    80002aba:	cf7ff0ef          	jal	800027b0 <argaddr>

    // Debug: Print user address
    printf("sys_sem_init: User address = 0x%lx\n", addr);
    80002abe:	fd843583          	ld	a1,-40(s0)
    80002ac2:	00005517          	auipc	a0,0x5
    80002ac6:	97e50513          	addi	a0,a0,-1666 # 80007440 <etext+0x440>
    80002aca:	9f9fd0ef          	jal	800004c2 <printf>

    // Ensure the address is valid
    if (addr == 0) {
    80002ace:	fd843783          	ld	a5,-40(s0)
    80002ad2:	cfd9                	beqz	a5,80002b70 <sys_sem_init+0xca>
    80002ad4:	ec26                	sd	s1,24(sp)
        printf("sys_sem_init: Invalid address or out of range\n");
        return -1;  // Return error if the address is NULL or out of range
    }

    // Allocate memory for the semaphore structure in kernel space
    s = (struct sem *)kalloc();  // Allocating memory in kernel space
    80002ad6:	84efe0ef          	jal	80000b24 <kalloc>
    80002ada:	84aa                	mv	s1,a0
    if (s == 0) {
    80002adc:	c155                	beqz	a0,80002b80 <sys_sem_init+0xda>
    80002ade:	e84a                	sd	s2,16(sp)
        printf("sys_sem_init: Memory allocation failed\n");
        return -1;  // Return error if memory allocation failed
    }

    // Debug: Check if copyin will work by printing the status of the memory page
    uint64 va0 = PGROUNDDOWN(addr);  // Align address to page boundary
    80002ae0:	797d                	lui	s2,0xfffff
    80002ae2:	fd843783          	ld	a5,-40(s0)
    80002ae6:	00f97933          	and	s2,s2,a5
    uint64 pa0 = walkaddr(myproc()->pagetable, va0);
    80002aea:	df7fe0ef          	jal	800018e0 <myproc>
    80002aee:	85ca                	mv	a1,s2
    80002af0:	6928                	ld	a0,80(a0)
    80002af2:	ce4fe0ef          	jal	80000fd6 <walkaddr>
    if (pa0 == 0) {
    80002af6:	cd51                	beqz	a0,80002b92 <sys_sem_init+0xec>
        kfree(s);  // Free allocated memory if copyin fails
        return -1;
    }

    // Copy data from user space to kernel space using copyin
    if (copyin(myproc()->pagetable, (char *)s, addr, sizeof(struct sem)) < 0) {
    80002af8:	de9fe0ef          	jal	800018e0 <myproc>
    80002afc:	02800693          	li	a3,40
    80002b00:	fd843603          	ld	a2,-40(s0)
    80002b04:	85a6                	mv	a1,s1
    80002b06:	6928                	ld	a0,80(a0)
    80002b08:	b21fe0ef          	jal	80001628 <copyin>
    80002b0c:	0a054063          	bltz	a0,80002bac <sys_sem_init+0x106>
        kfree(s);  // Free allocated memory if copyin fails
        return -1;  // Return error if copyin fails
    }

    // Fetch the semaphore value from user arguments (use argint without a return check)
    argint(1, &value);  // Just fetch the value, no need to check return value here
    80002b10:	fd440593          	addi	a1,s0,-44
    80002b14:	4505                	li	a0,1
    80002b16:	c7fff0ef          	jal	80002794 <argint>

    // Debug: Print semaphore value
    printf("sys_sem_init: Semaphore value = %d\n", value);
    80002b1a:	fd442583          	lw	a1,-44(s0)
    80002b1e:	00005517          	auipc	a0,0x5
    80002b22:	a1250513          	addi	a0,a0,-1518 # 80007530 <etext+0x530>
    80002b26:	99dfd0ef          	jal	800004c2 <printf>

    // Validate the semaphore value
    if (value < 0) {
    80002b2a:	fd442583          	lw	a1,-44(s0)
    80002b2e:	0805cc63          	bltz	a1,80002bc6 <sys_sem_init+0x120>
        kfree(s);  // Free memory if value is invalid
        return -1;  // Return error if value is invalid
    }

    // Initialize the semaphore with the provided value
    sem_initialize(s, value);
    80002b32:	8526                	mv	a0,s1
    80002b34:	d2dff0ef          	jal	80002860 <sem_initialize>
    printf("sys_sem_init: Semaphore initialized with value %d\n", value);
    80002b38:	fd442583          	lw	a1,-44(s0)
    80002b3c:	00005517          	auipc	a0,0x5
    80002b40:	a4450513          	addi	a0,a0,-1468 # 80007580 <etext+0x580>
    80002b44:	97ffd0ef          	jal	800004c2 <printf>

    // Copy the updated semaphore value back to user space
    if (copyout(myproc()->pagetable, addr, (char *)s, sizeof(struct sem)) < 0) {
    80002b48:	d99fe0ef          	jal	800018e0 <myproc>
    80002b4c:	02800693          	li	a3,40
    80002b50:	8626                	mv	a2,s1
    80002b52:	fd843583          	ld	a1,-40(s0)
    80002b56:	6928                	ld	a0,80(a0)
    80002b58:	9fbfe0ef          	jal	80001552 <copyout>
    80002b5c:	87aa                	mv	a5,a0
        printf("sys_sem_init: copyout failed\n");
        kfree(s);  // Free memory if copyout fails
        return -1;  // Return error if copyout fails
    }

    return 0;  // Success
    80002b5e:	4501                	li	a0,0
    if (copyout(myproc()->pagetable, addr, (char *)s, sizeof(struct sem)) < 0) {
    80002b60:	0807c063          	bltz	a5,80002be0 <sys_sem_init+0x13a>
    80002b64:	64e2                	ld	s1,24(sp)
    80002b66:	6942                	ld	s2,16(sp)
}
    80002b68:	70a2                	ld	ra,40(sp)
    80002b6a:	7402                	ld	s0,32(sp)
    80002b6c:	6145                	addi	sp,sp,48
    80002b6e:	8082                	ret
        printf("sys_sem_init: Invalid address or out of range\n");
    80002b70:	00005517          	auipc	a0,0x5
    80002b74:	8f850513          	addi	a0,a0,-1800 # 80007468 <etext+0x468>
    80002b78:	94bfd0ef          	jal	800004c2 <printf>
        return -1;  // Return error if the address is NULL or out of range
    80002b7c:	557d                	li	a0,-1
    80002b7e:	b7ed                	j	80002b68 <sys_sem_init+0xc2>
        printf("sys_sem_init: Memory allocation failed\n");
    80002b80:	00005517          	auipc	a0,0x5
    80002b84:	91850513          	addi	a0,a0,-1768 # 80007498 <etext+0x498>
    80002b88:	93bfd0ef          	jal	800004c2 <printf>
        return -1;  // Return error if memory allocation failed
    80002b8c:	557d                	li	a0,-1
    80002b8e:	64e2                	ld	s1,24(sp)
    80002b90:	bfe1                	j	80002b68 <sys_sem_init+0xc2>
        printf("sys_sem_init: Invalid user-space address (physical address lookup failed)\n");
    80002b92:	00005517          	auipc	a0,0x5
    80002b96:	92e50513          	addi	a0,a0,-1746 # 800074c0 <etext+0x4c0>
    80002b9a:	929fd0ef          	jal	800004c2 <printf>
        kfree(s);  // Free allocated memory if copyin fails
    80002b9e:	8526                	mv	a0,s1
    80002ba0:	ea3fd0ef          	jal	80000a42 <kfree>
        return -1;
    80002ba4:	557d                	li	a0,-1
    80002ba6:	64e2                	ld	s1,24(sp)
    80002ba8:	6942                	ld	s2,16(sp)
    80002baa:	bf7d                	j	80002b68 <sys_sem_init+0xc2>
        printf("sys_sem_init: copyin failed\n");
    80002bac:	00005517          	auipc	a0,0x5
    80002bb0:	96450513          	addi	a0,a0,-1692 # 80007510 <etext+0x510>
    80002bb4:	90ffd0ef          	jal	800004c2 <printf>
        kfree(s);  // Free allocated memory if copyin fails
    80002bb8:	8526                	mv	a0,s1
    80002bba:	e89fd0ef          	jal	80000a42 <kfree>
        return -1;  // Return error if copyin fails
    80002bbe:	557d                	li	a0,-1
    80002bc0:	64e2                	ld	s1,24(sp)
    80002bc2:	6942                	ld	s2,16(sp)
    80002bc4:	b755                	j	80002b68 <sys_sem_init+0xc2>
        printf("sys_sem_init: Invalid semaphore value\n");
    80002bc6:	00005517          	auipc	a0,0x5
    80002bca:	99250513          	addi	a0,a0,-1646 # 80007558 <etext+0x558>
    80002bce:	8f5fd0ef          	jal	800004c2 <printf>
        kfree(s);  // Free memory if value is invalid
    80002bd2:	8526                	mv	a0,s1
    80002bd4:	e6ffd0ef          	jal	80000a42 <kfree>
        return -1;  // Return error if value is invalid
    80002bd8:	557d                	li	a0,-1
    80002bda:	64e2                	ld	s1,24(sp)
    80002bdc:	6942                	ld	s2,16(sp)
    80002bde:	b769                	j	80002b68 <sys_sem_init+0xc2>
        printf("sys_sem_init: copyout failed\n");
    80002be0:	00005517          	auipc	a0,0x5
    80002be4:	9d850513          	addi	a0,a0,-1576 # 800075b8 <etext+0x5b8>
    80002be8:	8dbfd0ef          	jal	800004c2 <printf>
        kfree(s);  // Free memory if copyout fails
    80002bec:	8526                	mv	a0,s1
    80002bee:	e55fd0ef          	jal	80000a42 <kfree>
        return -1;  // Return error if copyout fails
    80002bf2:	557d                	li	a0,-1
    80002bf4:	64e2                	ld	s1,24(sp)
    80002bf6:	6942                	ld	s2,16(sp)
    80002bf8:	bf85                	j	80002b68 <sys_sem_init+0xc2>

0000000080002bfa <sys_sem_up>:

int sys_sem_up(void) {
    80002bfa:	7179                	addi	sp,sp,-48
    80002bfc:	f406                	sd	ra,40(sp)
    80002bfe:	f022                	sd	s0,32(sp)
    80002c00:	ec26                	sd	s1,24(sp)
    80002c02:	1800                	addi	s0,sp,48
    struct sem *s;  // Pointer to semaphore structure in kernel space
    uint64 addr;  // To store the user-space address
    uint64 va0, pa0;

    // Get the semaphore pointer from user space argument
    argaddr(0, &addr);
    80002c04:	fd840593          	addi	a1,s0,-40
    80002c08:	4501                	li	a0,0
    80002c0a:	ba7ff0ef          	jal	800027b0 <argaddr>

    // Debug: Print the user-space address
    printf("sys_sem_up: User address = 0x%lx\n", addr);
    80002c0e:	fd843583          	ld	a1,-40(s0)
    80002c12:	00005517          	auipc	a0,0x5
    80002c16:	9c650513          	addi	a0,a0,-1594 # 800075d8 <etext+0x5d8>
    80002c1a:	8a9fd0ef          	jal	800004c2 <printf>

    // Ensure the address is valid and mapped in the page table
    va0 = PGROUNDDOWN(addr);  // Align the address to the page boundary
    80002c1e:	74fd                	lui	s1,0xfffff
    80002c20:	fd843783          	ld	a5,-40(s0)
    80002c24:	8cfd                	and	s1,s1,a5
    pa0 = walkaddr(myproc()->pagetable, va0);
    80002c26:	cbbfe0ef          	jal	800018e0 <myproc>
    80002c2a:	85a6                	mv	a1,s1
    80002c2c:	6928                	ld	a0,80(a0)
    80002c2e:	ba8fe0ef          	jal	80000fd6 <walkaddr>
    if (pa0 == 0) {
    80002c32:	c53d                	beqz	a0,80002ca0 <sys_sem_up+0xa6>
        printf("sys_sem_up: Invalid or unmapped address\n");
        return -1;  // Return error if the address is invalid
    }

    // Allocate memory for the semaphore structure in kernel space
    s = (struct sem *)kalloc();
    80002c34:	ef1fd0ef          	jal	80000b24 <kalloc>
    80002c38:	84aa                	mv	s1,a0
    if (s == 0) {
    80002c3a:	c93d                	beqz	a0,80002cb0 <sys_sem_up+0xb6>
        printf("sys_sem_up: Memory allocation failed\n");
        return -1;  // Return error if memory allocation fails
    }

    // Copy the semaphore structure from user space to kernel space
    if (copyin(myproc()->pagetable, (char *)s, addr, sizeof(struct sem)) < 0) {
    80002c3c:	ca5fe0ef          	jal	800018e0 <myproc>
    80002c40:	02800693          	li	a3,40
    80002c44:	fd843603          	ld	a2,-40(s0)
    80002c48:	85a6                	mv	a1,s1
    80002c4a:	6928                	ld	a0,80(a0)
    80002c4c:	9ddfe0ef          	jal	80001628 <copyin>
    80002c50:	06054863          	bltz	a0,80002cc0 <sys_sem_up+0xc6>
        kfree(s);  // Free memory if copyin fails
        return -1;  // Return error if copyin fails
    }

    // Debug: Print semaphore value before incrementing (sem_up operation)
    printf("sys_sem_up: Semaphore value before incrementing = %d\n", s->value);
    80002c54:	408c                	lw	a1,0(s1)
    80002c56:	00005517          	auipc	a0,0x5
    80002c5a:	a2250513          	addi	a0,a0,-1502 # 80007678 <etext+0x678>
    80002c5e:	865fd0ef          	jal	800004c2 <printf>

    // Perform the sem_up operation (increment the semaphore)
    sem_up(s);
    80002c62:	8526                	mv	a0,s1
    80002c64:	c61ff0ef          	jal	800028c4 <sem_up>

    // Debug: Print semaphore value after incrementing
    printf("sys_sem_up: Semaphore value after incrementing = %d\n", s->value);
    80002c68:	408c                	lw	a1,0(s1)
    80002c6a:	00005517          	auipc	a0,0x5
    80002c6e:	a4650513          	addi	a0,a0,-1466 # 800076b0 <etext+0x6b0>
    80002c72:	851fd0ef          	jal	800004c2 <printf>

    // Copy the updated semaphore structure back to user space
    if (copyout(myproc()->pagetable, addr, (char *)s, sizeof(struct sem)) < 0) {
    80002c76:	c6bfe0ef          	jal	800018e0 <myproc>
    80002c7a:	02800693          	li	a3,40
    80002c7e:	8626                	mv	a2,s1
    80002c80:	fd843583          	ld	a1,-40(s0)
    80002c84:	6928                	ld	a0,80(a0)
    80002c86:	8cdfe0ef          	jal	80001552 <copyout>
    80002c8a:	04054663          	bltz	a0,80002cd6 <sys_sem_up+0xdc>
        kfree(s);  // Free memory if copyout fails
        return -1;  // Return error if copyout fails
    }

    // Free allocated memory after use
    kfree(s);
    80002c8e:	8526                	mv	a0,s1
    80002c90:	db3fd0ef          	jal	80000a42 <kfree>

    return 0;
    80002c94:	4501                	li	a0,0
}
    80002c96:	70a2                	ld	ra,40(sp)
    80002c98:	7402                	ld	s0,32(sp)
    80002c9a:	64e2                	ld	s1,24(sp)
    80002c9c:	6145                	addi	sp,sp,48
    80002c9e:	8082                	ret
        printf("sys_sem_up: Invalid or unmapped address\n");
    80002ca0:	00005517          	auipc	a0,0x5
    80002ca4:	96050513          	addi	a0,a0,-1696 # 80007600 <etext+0x600>
    80002ca8:	81bfd0ef          	jal	800004c2 <printf>
        return -1;  // Return error if the address is invalid
    80002cac:	557d                	li	a0,-1
    80002cae:	b7e5                	j	80002c96 <sys_sem_up+0x9c>
        printf("sys_sem_up: Memory allocation failed\n");
    80002cb0:	00005517          	auipc	a0,0x5
    80002cb4:	98050513          	addi	a0,a0,-1664 # 80007630 <etext+0x630>
    80002cb8:	80bfd0ef          	jal	800004c2 <printf>
        return -1;  // Return error if memory allocation fails
    80002cbc:	557d                	li	a0,-1
    80002cbe:	bfe1                	j	80002c96 <sys_sem_up+0x9c>
        printf("sys_sem_up: copyin failed\n");
    80002cc0:	00005517          	auipc	a0,0x5
    80002cc4:	99850513          	addi	a0,a0,-1640 # 80007658 <etext+0x658>
    80002cc8:	ffafd0ef          	jal	800004c2 <printf>
        kfree(s);  // Free memory if copyin fails
    80002ccc:	8526                	mv	a0,s1
    80002cce:	d75fd0ef          	jal	80000a42 <kfree>
        return -1;  // Return error if copyin fails
    80002cd2:	557d                	li	a0,-1
    80002cd4:	b7c9                	j	80002c96 <sys_sem_up+0x9c>
        printf("sys_sem_up: copyout failed\n");
    80002cd6:	00005517          	auipc	a0,0x5
    80002cda:	a1250513          	addi	a0,a0,-1518 # 800076e8 <etext+0x6e8>
    80002cde:	fe4fd0ef          	jal	800004c2 <printf>
        kfree(s);  // Free memory if copyout fails
    80002ce2:	8526                	mv	a0,s1
    80002ce4:	d5ffd0ef          	jal	80000a42 <kfree>
        return -1;  // Return error if copyout fails
    80002ce8:	557d                	li	a0,-1
    80002cea:	b775                	j	80002c96 <sys_sem_up+0x9c>

0000000080002cec <sys_sem_down>:

int sys_sem_down(void) {
    80002cec:	7179                	addi	sp,sp,-48
    80002cee:	f406                	sd	ra,40(sp)
    80002cf0:	f022                	sd	s0,32(sp)
    80002cf2:	ec26                	sd	s1,24(sp)
    80002cf4:	1800                	addi	s0,sp,48
    struct sem *s;
    uint64 addr;  // To store the user-space address
    uint64 va0, pa0;

    // Get the semaphore address from user space
    argaddr(0, &addr);
    80002cf6:	fd840593          	addi	a1,s0,-40
    80002cfa:	4501                	li	a0,0
    80002cfc:	ab5ff0ef          	jal	800027b0 <argaddr>

    // Debug: Print user-space address
    printf("sys_sem_down: User address = 0x%lx\n", addr);
    80002d00:	fd843583          	ld	a1,-40(s0)
    80002d04:	00005517          	auipc	a0,0x5
    80002d08:	a0450513          	addi	a0,a0,-1532 # 80007708 <etext+0x708>
    80002d0c:	fb6fd0ef          	jal	800004c2 <printf>

    // Ensure the address is valid by checking if it's in the user-space region
    va0 = PGROUNDDOWN(addr);  // Align address to page boundary
    80002d10:	74fd                	lui	s1,0xfffff
    80002d12:	fd843783          	ld	a5,-40(s0)
    80002d16:	8cfd                	and	s1,s1,a5
    pa0 = walkaddr(myproc()->pagetable, va0);  // Get the physical address
    80002d18:	bc9fe0ef          	jal	800018e0 <myproc>
    80002d1c:	85a6                	mv	a1,s1
    80002d1e:	6928                	ld	a0,80(a0)
    80002d20:	ab6fe0ef          	jal	80000fd6 <walkaddr>

    if (pa0 == 0) {
    80002d24:	c53d                	beqz	a0,80002d92 <sys_sem_down+0xa6>
        printf("sys_sem_down: Invalid or unmapped address\n");
        return -1;  // Return error if address is invalid or not mapped
    }

    // Allocate memory for the semaphore structure in kernel space
    s = (struct sem *)kalloc();
    80002d26:	dfffd0ef          	jal	80000b24 <kalloc>
    80002d2a:	84aa                	mv	s1,a0
    if (s == 0) {
    80002d2c:	c93d                	beqz	a0,80002da2 <sys_sem_down+0xb6>
        printf("sys_sem_down: Memory allocation failed\n");
        return -1;  // Return error if memory allocation fails
    }

    // Copy the semaphore structure from user space to kernel space
    if (copyin(myproc()->pagetable, (char *)s, addr, sizeof(struct sem)) < 0) {
    80002d2e:	bb3fe0ef          	jal	800018e0 <myproc>
    80002d32:	02800693          	li	a3,40
    80002d36:	fd843603          	ld	a2,-40(s0)
    80002d3a:	85a6                	mv	a1,s1
    80002d3c:	6928                	ld	a0,80(a0)
    80002d3e:	8ebfe0ef          	jal	80001628 <copyin>
    80002d42:	06054863          	bltz	a0,80002db2 <sys_sem_down+0xc6>
        kfree(s);  // Free memory if copyin fails
        return -1;  // Return error if copyin fails
    }

    // Debug: Print semaphore value before decrementing
    printf("sys_sem_down: Semaphore value = %d\n", s->value);
    80002d46:	408c                	lw	a1,0(s1)
    80002d48:	00005517          	auipc	a0,0x5
    80002d4c:	a6050513          	addi	a0,a0,-1440 # 800077a8 <etext+0x7a8>
    80002d50:	f72fd0ef          	jal	800004c2 <printf>

    // Perform the sem_down operation (decrement the semaphore)
    sem_down(s);
    80002d54:	8526                	mv	a0,s1
    80002d56:	b2dff0ef          	jal	80002882 <sem_down>

    // Debug: Print semaphore value after decrementing
    printf("sys_sem_down: Semaphore value = %d\n", s->value);
    80002d5a:	408c                	lw	a1,0(s1)
    80002d5c:	00005517          	auipc	a0,0x5
    80002d60:	a4c50513          	addi	a0,a0,-1460 # 800077a8 <etext+0x7a8>
    80002d64:	f5efd0ef          	jal	800004c2 <printf>

    // Copy the updated semaphore structure back to user space
    if (copyout(myproc()->pagetable, addr, (char *)s, sizeof(struct sem)) < 0) {
    80002d68:	b79fe0ef          	jal	800018e0 <myproc>
    80002d6c:	02800693          	li	a3,40
    80002d70:	8626                	mv	a2,s1
    80002d72:	fd843583          	ld	a1,-40(s0)
    80002d76:	6928                	ld	a0,80(a0)
    80002d78:	fdafe0ef          	jal	80001552 <copyout>
    80002d7c:	04054663          	bltz	a0,80002dc8 <sys_sem_down+0xdc>
        printf("sys_sem_down: copyout failed\n");
        kfree(s);  // Free memory if copyout fails
        return -1;  // Return error if copyout fails
    }

    kfree(s);  // Free allocated memory after use
    80002d80:	8526                	mv	a0,s1
    80002d82:	cc1fd0ef          	jal	80000a42 <kfree>
    return 0;
    80002d86:	4501                	li	a0,0
}
    80002d88:	70a2                	ld	ra,40(sp)
    80002d8a:	7402                	ld	s0,32(sp)
    80002d8c:	64e2                	ld	s1,24(sp)
    80002d8e:	6145                	addi	sp,sp,48
    80002d90:	8082                	ret
        printf("sys_sem_down: Invalid or unmapped address\n");
    80002d92:	00005517          	auipc	a0,0x5
    80002d96:	99e50513          	addi	a0,a0,-1634 # 80007730 <etext+0x730>
    80002d9a:	f28fd0ef          	jal	800004c2 <printf>
        return -1;  // Return error if address is invalid or not mapped
    80002d9e:	557d                	li	a0,-1
    80002da0:	b7e5                	j	80002d88 <sys_sem_down+0x9c>
        printf("sys_sem_down: Memory allocation failed\n");
    80002da2:	00005517          	auipc	a0,0x5
    80002da6:	9be50513          	addi	a0,a0,-1602 # 80007760 <etext+0x760>
    80002daa:	f18fd0ef          	jal	800004c2 <printf>
        return -1;  // Return error if memory allocation fails
    80002dae:	557d                	li	a0,-1
    80002db0:	bfe1                	j	80002d88 <sys_sem_down+0x9c>
        printf("sys_sem_down: copyin failed\n");
    80002db2:	00005517          	auipc	a0,0x5
    80002db6:	9d650513          	addi	a0,a0,-1578 # 80007788 <etext+0x788>
    80002dba:	f08fd0ef          	jal	800004c2 <printf>
        kfree(s);  // Free memory if copyin fails
    80002dbe:	8526                	mv	a0,s1
    80002dc0:	c83fd0ef          	jal	80000a42 <kfree>
        return -1;  // Return error if copyin fails
    80002dc4:	557d                	li	a0,-1
    80002dc6:	b7c9                	j	80002d88 <sys_sem_down+0x9c>
        printf("sys_sem_down: copyout failed\n");
    80002dc8:	00005517          	auipc	a0,0x5
    80002dcc:	a0850513          	addi	a0,a0,-1528 # 800077d0 <etext+0x7d0>
    80002dd0:	ef2fd0ef          	jal	800004c2 <printf>
        kfree(s);  // Free memory if copyout fails
    80002dd4:	8526                	mv	a0,s1
    80002dd6:	c6dfd0ef          	jal	80000a42 <kfree>
        return -1;  // Return error if copyout fails
    80002dda:	557d                	li	a0,-1
    80002ddc:	b775                	j	80002d88 <sys_sem_down+0x9c>

0000000080002dde <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002dde:	7179                	addi	sp,sp,-48
    80002de0:	f406                	sd	ra,40(sp)
    80002de2:	f022                	sd	s0,32(sp)
    80002de4:	ec26                	sd	s1,24(sp)
    80002de6:	e84a                	sd	s2,16(sp)
    80002de8:	e44e                	sd	s3,8(sp)
    80002dea:	e052                	sd	s4,0(sp)
    80002dec:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002dee:	00005597          	auipc	a1,0x5
    80002df2:	a0258593          	addi	a1,a1,-1534 # 800077f0 <etext+0x7f0>
    80002df6:	00016517          	auipc	a0,0x16
    80002dfa:	8b250513          	addi	a0,a0,-1870 # 800186a8 <bcache>
    80002dfe:	d77fd0ef          	jal	80000b74 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002e02:	0001e797          	auipc	a5,0x1e
    80002e06:	8a678793          	addi	a5,a5,-1882 # 800206a8 <bcache+0x8000>
    80002e0a:	0001e717          	auipc	a4,0x1e
    80002e0e:	b0670713          	addi	a4,a4,-1274 # 80020910 <bcache+0x8268>
    80002e12:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002e16:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e1a:	00016497          	auipc	s1,0x16
    80002e1e:	8a648493          	addi	s1,s1,-1882 # 800186c0 <bcache+0x18>
    b->next = bcache.head.next;
    80002e22:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002e24:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002e26:	00005a17          	auipc	s4,0x5
    80002e2a:	9d2a0a13          	addi	s4,s4,-1582 # 800077f8 <etext+0x7f8>
    b->next = bcache.head.next;
    80002e2e:	2b893783          	ld	a5,696(s2) # fffffffffffff2b8 <end+0xffffffff7ffdb848>
    80002e32:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002e34:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002e38:	85d2                	mv	a1,s4
    80002e3a:	01048513          	addi	a0,s1,16
    80002e3e:	248010ef          	jal	80004086 <initsleeplock>
    bcache.head.next->prev = b;
    80002e42:	2b893783          	ld	a5,696(s2)
    80002e46:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002e48:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e4c:	45848493          	addi	s1,s1,1112
    80002e50:	fd349fe3          	bne	s1,s3,80002e2e <binit+0x50>
  }
}
    80002e54:	70a2                	ld	ra,40(sp)
    80002e56:	7402                	ld	s0,32(sp)
    80002e58:	64e2                	ld	s1,24(sp)
    80002e5a:	6942                	ld	s2,16(sp)
    80002e5c:	69a2                	ld	s3,8(sp)
    80002e5e:	6a02                	ld	s4,0(sp)
    80002e60:	6145                	addi	sp,sp,48
    80002e62:	8082                	ret

0000000080002e64 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002e64:	7179                	addi	sp,sp,-48
    80002e66:	f406                	sd	ra,40(sp)
    80002e68:	f022                	sd	s0,32(sp)
    80002e6a:	ec26                	sd	s1,24(sp)
    80002e6c:	e84a                	sd	s2,16(sp)
    80002e6e:	e44e                	sd	s3,8(sp)
    80002e70:	1800                	addi	s0,sp,48
    80002e72:	892a                	mv	s2,a0
    80002e74:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002e76:	00016517          	auipc	a0,0x16
    80002e7a:	83250513          	addi	a0,a0,-1998 # 800186a8 <bcache>
    80002e7e:	d77fd0ef          	jal	80000bf4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002e82:	0001e497          	auipc	s1,0x1e
    80002e86:	ade4b483          	ld	s1,-1314(s1) # 80020960 <bcache+0x82b8>
    80002e8a:	0001e797          	auipc	a5,0x1e
    80002e8e:	a8678793          	addi	a5,a5,-1402 # 80020910 <bcache+0x8268>
    80002e92:	02f48b63          	beq	s1,a5,80002ec8 <bread+0x64>
    80002e96:	873e                	mv	a4,a5
    80002e98:	a021                	j	80002ea0 <bread+0x3c>
    80002e9a:	68a4                	ld	s1,80(s1)
    80002e9c:	02e48663          	beq	s1,a4,80002ec8 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002ea0:	449c                	lw	a5,8(s1)
    80002ea2:	ff279ce3          	bne	a5,s2,80002e9a <bread+0x36>
    80002ea6:	44dc                	lw	a5,12(s1)
    80002ea8:	ff3799e3          	bne	a5,s3,80002e9a <bread+0x36>
      b->refcnt++;
    80002eac:	40bc                	lw	a5,64(s1)
    80002eae:	2785                	addiw	a5,a5,1
    80002eb0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002eb2:	00015517          	auipc	a0,0x15
    80002eb6:	7f650513          	addi	a0,a0,2038 # 800186a8 <bcache>
    80002eba:	dd3fd0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002ebe:	01048513          	addi	a0,s1,16
    80002ec2:	1fa010ef          	jal	800040bc <acquiresleep>
      return b;
    80002ec6:	a889                	j	80002f18 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002ec8:	0001e497          	auipc	s1,0x1e
    80002ecc:	a904b483          	ld	s1,-1392(s1) # 80020958 <bcache+0x82b0>
    80002ed0:	0001e797          	auipc	a5,0x1e
    80002ed4:	a4078793          	addi	a5,a5,-1472 # 80020910 <bcache+0x8268>
    80002ed8:	00f48863          	beq	s1,a5,80002ee8 <bread+0x84>
    80002edc:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002ede:	40bc                	lw	a5,64(s1)
    80002ee0:	cb91                	beqz	a5,80002ef4 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002ee2:	64a4                	ld	s1,72(s1)
    80002ee4:	fee49de3          	bne	s1,a4,80002ede <bread+0x7a>
  panic("bget: no buffers");
    80002ee8:	00005517          	auipc	a0,0x5
    80002eec:	91850513          	addi	a0,a0,-1768 # 80007800 <etext+0x800>
    80002ef0:	8a5fd0ef          	jal	80000794 <panic>
      b->dev = dev;
    80002ef4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002ef8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002efc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002f00:	4785                	li	a5,1
    80002f02:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f04:	00015517          	auipc	a0,0x15
    80002f08:	7a450513          	addi	a0,a0,1956 # 800186a8 <bcache>
    80002f0c:	d81fd0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002f10:	01048513          	addi	a0,s1,16
    80002f14:	1a8010ef          	jal	800040bc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002f18:	409c                	lw	a5,0(s1)
    80002f1a:	cb89                	beqz	a5,80002f2c <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002f1c:	8526                	mv	a0,s1
    80002f1e:	70a2                	ld	ra,40(sp)
    80002f20:	7402                	ld	s0,32(sp)
    80002f22:	64e2                	ld	s1,24(sp)
    80002f24:	6942                	ld	s2,16(sp)
    80002f26:	69a2                	ld	s3,8(sp)
    80002f28:	6145                	addi	sp,sp,48
    80002f2a:	8082                	ret
    virtio_disk_rw(b, 0);
    80002f2c:	4581                	li	a1,0
    80002f2e:	8526                	mv	a0,s1
    80002f30:	1f1020ef          	jal	80005920 <virtio_disk_rw>
    b->valid = 1;
    80002f34:	4785                	li	a5,1
    80002f36:	c09c                	sw	a5,0(s1)
  return b;
    80002f38:	b7d5                	j	80002f1c <bread+0xb8>

0000000080002f3a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002f3a:	1101                	addi	sp,sp,-32
    80002f3c:	ec06                	sd	ra,24(sp)
    80002f3e:	e822                	sd	s0,16(sp)
    80002f40:	e426                	sd	s1,8(sp)
    80002f42:	1000                	addi	s0,sp,32
    80002f44:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f46:	0541                	addi	a0,a0,16
    80002f48:	1f2010ef          	jal	8000413a <holdingsleep>
    80002f4c:	c911                	beqz	a0,80002f60 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002f4e:	4585                	li	a1,1
    80002f50:	8526                	mv	a0,s1
    80002f52:	1cf020ef          	jal	80005920 <virtio_disk_rw>
}
    80002f56:	60e2                	ld	ra,24(sp)
    80002f58:	6442                	ld	s0,16(sp)
    80002f5a:	64a2                	ld	s1,8(sp)
    80002f5c:	6105                	addi	sp,sp,32
    80002f5e:	8082                	ret
    panic("bwrite");
    80002f60:	00005517          	auipc	a0,0x5
    80002f64:	8b850513          	addi	a0,a0,-1864 # 80007818 <etext+0x818>
    80002f68:	82dfd0ef          	jal	80000794 <panic>

0000000080002f6c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002f6c:	1101                	addi	sp,sp,-32
    80002f6e:	ec06                	sd	ra,24(sp)
    80002f70:	e822                	sd	s0,16(sp)
    80002f72:	e426                	sd	s1,8(sp)
    80002f74:	e04a                	sd	s2,0(sp)
    80002f76:	1000                	addi	s0,sp,32
    80002f78:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f7a:	01050913          	addi	s2,a0,16
    80002f7e:	854a                	mv	a0,s2
    80002f80:	1ba010ef          	jal	8000413a <holdingsleep>
    80002f84:	c135                	beqz	a0,80002fe8 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002f86:	854a                	mv	a0,s2
    80002f88:	17a010ef          	jal	80004102 <releasesleep>

  acquire(&bcache.lock);
    80002f8c:	00015517          	auipc	a0,0x15
    80002f90:	71c50513          	addi	a0,a0,1820 # 800186a8 <bcache>
    80002f94:	c61fd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80002f98:	40bc                	lw	a5,64(s1)
    80002f9a:	37fd                	addiw	a5,a5,-1
    80002f9c:	0007871b          	sext.w	a4,a5
    80002fa0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002fa2:	e71d                	bnez	a4,80002fd0 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002fa4:	68b8                	ld	a4,80(s1)
    80002fa6:	64bc                	ld	a5,72(s1)
    80002fa8:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002faa:	68b8                	ld	a4,80(s1)
    80002fac:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002fae:	0001d797          	auipc	a5,0x1d
    80002fb2:	6fa78793          	addi	a5,a5,1786 # 800206a8 <bcache+0x8000>
    80002fb6:	2b87b703          	ld	a4,696(a5)
    80002fba:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002fbc:	0001e717          	auipc	a4,0x1e
    80002fc0:	95470713          	addi	a4,a4,-1708 # 80020910 <bcache+0x8268>
    80002fc4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002fc6:	2b87b703          	ld	a4,696(a5)
    80002fca:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002fcc:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002fd0:	00015517          	auipc	a0,0x15
    80002fd4:	6d850513          	addi	a0,a0,1752 # 800186a8 <bcache>
    80002fd8:	cb5fd0ef          	jal	80000c8c <release>
}
    80002fdc:	60e2                	ld	ra,24(sp)
    80002fde:	6442                	ld	s0,16(sp)
    80002fe0:	64a2                	ld	s1,8(sp)
    80002fe2:	6902                	ld	s2,0(sp)
    80002fe4:	6105                	addi	sp,sp,32
    80002fe6:	8082                	ret
    panic("brelse");
    80002fe8:	00005517          	auipc	a0,0x5
    80002fec:	83850513          	addi	a0,a0,-1992 # 80007820 <etext+0x820>
    80002ff0:	fa4fd0ef          	jal	80000794 <panic>

0000000080002ff4 <bpin>:

void
bpin(struct buf *b) {
    80002ff4:	1101                	addi	sp,sp,-32
    80002ff6:	ec06                	sd	ra,24(sp)
    80002ff8:	e822                	sd	s0,16(sp)
    80002ffa:	e426                	sd	s1,8(sp)
    80002ffc:	1000                	addi	s0,sp,32
    80002ffe:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003000:	00015517          	auipc	a0,0x15
    80003004:	6a850513          	addi	a0,a0,1704 # 800186a8 <bcache>
    80003008:	bedfd0ef          	jal	80000bf4 <acquire>
  b->refcnt++;
    8000300c:	40bc                	lw	a5,64(s1)
    8000300e:	2785                	addiw	a5,a5,1
    80003010:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003012:	00015517          	auipc	a0,0x15
    80003016:	69650513          	addi	a0,a0,1686 # 800186a8 <bcache>
    8000301a:	c73fd0ef          	jal	80000c8c <release>
}
    8000301e:	60e2                	ld	ra,24(sp)
    80003020:	6442                	ld	s0,16(sp)
    80003022:	64a2                	ld	s1,8(sp)
    80003024:	6105                	addi	sp,sp,32
    80003026:	8082                	ret

0000000080003028 <bunpin>:

void
bunpin(struct buf *b) {
    80003028:	1101                	addi	sp,sp,-32
    8000302a:	ec06                	sd	ra,24(sp)
    8000302c:	e822                	sd	s0,16(sp)
    8000302e:	e426                	sd	s1,8(sp)
    80003030:	1000                	addi	s0,sp,32
    80003032:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003034:	00015517          	auipc	a0,0x15
    80003038:	67450513          	addi	a0,a0,1652 # 800186a8 <bcache>
    8000303c:	bb9fd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80003040:	40bc                	lw	a5,64(s1)
    80003042:	37fd                	addiw	a5,a5,-1
    80003044:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003046:	00015517          	auipc	a0,0x15
    8000304a:	66250513          	addi	a0,a0,1634 # 800186a8 <bcache>
    8000304e:	c3ffd0ef          	jal	80000c8c <release>
}
    80003052:	60e2                	ld	ra,24(sp)
    80003054:	6442                	ld	s0,16(sp)
    80003056:	64a2                	ld	s1,8(sp)
    80003058:	6105                	addi	sp,sp,32
    8000305a:	8082                	ret

000000008000305c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000305c:	1101                	addi	sp,sp,-32
    8000305e:	ec06                	sd	ra,24(sp)
    80003060:	e822                	sd	s0,16(sp)
    80003062:	e426                	sd	s1,8(sp)
    80003064:	e04a                	sd	s2,0(sp)
    80003066:	1000                	addi	s0,sp,32
    80003068:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000306a:	00d5d59b          	srliw	a1,a1,0xd
    8000306e:	0001e797          	auipc	a5,0x1e
    80003072:	d167a783          	lw	a5,-746(a5) # 80020d84 <sb+0x1c>
    80003076:	9dbd                	addw	a1,a1,a5
    80003078:	dedff0ef          	jal	80002e64 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000307c:	0074f713          	andi	a4,s1,7
    80003080:	4785                	li	a5,1
    80003082:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003086:	14ce                	slli	s1,s1,0x33
    80003088:	90d9                	srli	s1,s1,0x36
    8000308a:	00950733          	add	a4,a0,s1
    8000308e:	05874703          	lbu	a4,88(a4)
    80003092:	00e7f6b3          	and	a3,a5,a4
    80003096:	c29d                	beqz	a3,800030bc <bfree+0x60>
    80003098:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000309a:	94aa                	add	s1,s1,a0
    8000309c:	fff7c793          	not	a5,a5
    800030a0:	8f7d                	and	a4,a4,a5
    800030a2:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800030a6:	711000ef          	jal	80003fb6 <log_write>
  brelse(bp);
    800030aa:	854a                	mv	a0,s2
    800030ac:	ec1ff0ef          	jal	80002f6c <brelse>
}
    800030b0:	60e2                	ld	ra,24(sp)
    800030b2:	6442                	ld	s0,16(sp)
    800030b4:	64a2                	ld	s1,8(sp)
    800030b6:	6902                	ld	s2,0(sp)
    800030b8:	6105                	addi	sp,sp,32
    800030ba:	8082                	ret
    panic("freeing free block");
    800030bc:	00004517          	auipc	a0,0x4
    800030c0:	76c50513          	addi	a0,a0,1900 # 80007828 <etext+0x828>
    800030c4:	ed0fd0ef          	jal	80000794 <panic>

00000000800030c8 <balloc>:
{
    800030c8:	711d                	addi	sp,sp,-96
    800030ca:	ec86                	sd	ra,88(sp)
    800030cc:	e8a2                	sd	s0,80(sp)
    800030ce:	e4a6                	sd	s1,72(sp)
    800030d0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800030d2:	0001e797          	auipc	a5,0x1e
    800030d6:	c9a7a783          	lw	a5,-870(a5) # 80020d6c <sb+0x4>
    800030da:	0e078f63          	beqz	a5,800031d8 <balloc+0x110>
    800030de:	e0ca                	sd	s2,64(sp)
    800030e0:	fc4e                	sd	s3,56(sp)
    800030e2:	f852                	sd	s4,48(sp)
    800030e4:	f456                	sd	s5,40(sp)
    800030e6:	f05a                	sd	s6,32(sp)
    800030e8:	ec5e                	sd	s7,24(sp)
    800030ea:	e862                	sd	s8,16(sp)
    800030ec:	e466                	sd	s9,8(sp)
    800030ee:	8baa                	mv	s7,a0
    800030f0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800030f2:	0001eb17          	auipc	s6,0x1e
    800030f6:	c76b0b13          	addi	s6,s6,-906 # 80020d68 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030fa:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800030fc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030fe:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003100:	6c89                	lui	s9,0x2
    80003102:	a0b5                	j	8000316e <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003104:	97ca                	add	a5,a5,s2
    80003106:	8e55                	or	a2,a2,a3
    80003108:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000310c:	854a                	mv	a0,s2
    8000310e:	6a9000ef          	jal	80003fb6 <log_write>
        brelse(bp);
    80003112:	854a                	mv	a0,s2
    80003114:	e59ff0ef          	jal	80002f6c <brelse>
  bp = bread(dev, bno);
    80003118:	85a6                	mv	a1,s1
    8000311a:	855e                	mv	a0,s7
    8000311c:	d49ff0ef          	jal	80002e64 <bread>
    80003120:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003122:	40000613          	li	a2,1024
    80003126:	4581                	li	a1,0
    80003128:	05850513          	addi	a0,a0,88
    8000312c:	b9dfd0ef          	jal	80000cc8 <memset>
  log_write(bp);
    80003130:	854a                	mv	a0,s2
    80003132:	685000ef          	jal	80003fb6 <log_write>
  brelse(bp);
    80003136:	854a                	mv	a0,s2
    80003138:	e35ff0ef          	jal	80002f6c <brelse>
}
    8000313c:	6906                	ld	s2,64(sp)
    8000313e:	79e2                	ld	s3,56(sp)
    80003140:	7a42                	ld	s4,48(sp)
    80003142:	7aa2                	ld	s5,40(sp)
    80003144:	7b02                	ld	s6,32(sp)
    80003146:	6be2                	ld	s7,24(sp)
    80003148:	6c42                	ld	s8,16(sp)
    8000314a:	6ca2                	ld	s9,8(sp)
}
    8000314c:	8526                	mv	a0,s1
    8000314e:	60e6                	ld	ra,88(sp)
    80003150:	6446                	ld	s0,80(sp)
    80003152:	64a6                	ld	s1,72(sp)
    80003154:	6125                	addi	sp,sp,96
    80003156:	8082                	ret
    brelse(bp);
    80003158:	854a                	mv	a0,s2
    8000315a:	e13ff0ef          	jal	80002f6c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000315e:	015c87bb          	addw	a5,s9,s5
    80003162:	00078a9b          	sext.w	s5,a5
    80003166:	004b2703          	lw	a4,4(s6)
    8000316a:	04eaff63          	bgeu	s5,a4,800031c8 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    8000316e:	41fad79b          	sraiw	a5,s5,0x1f
    80003172:	0137d79b          	srliw	a5,a5,0x13
    80003176:	015787bb          	addw	a5,a5,s5
    8000317a:	40d7d79b          	sraiw	a5,a5,0xd
    8000317e:	01cb2583          	lw	a1,28(s6)
    80003182:	9dbd                	addw	a1,a1,a5
    80003184:	855e                	mv	a0,s7
    80003186:	cdfff0ef          	jal	80002e64 <bread>
    8000318a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000318c:	004b2503          	lw	a0,4(s6)
    80003190:	000a849b          	sext.w	s1,s5
    80003194:	8762                	mv	a4,s8
    80003196:	fca4f1e3          	bgeu	s1,a0,80003158 <balloc+0x90>
      m = 1 << (bi % 8);
    8000319a:	00777693          	andi	a3,a4,7
    8000319e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800031a2:	41f7579b          	sraiw	a5,a4,0x1f
    800031a6:	01d7d79b          	srliw	a5,a5,0x1d
    800031aa:	9fb9                	addw	a5,a5,a4
    800031ac:	4037d79b          	sraiw	a5,a5,0x3
    800031b0:	00f90633          	add	a2,s2,a5
    800031b4:	05864603          	lbu	a2,88(a2)
    800031b8:	00c6f5b3          	and	a1,a3,a2
    800031bc:	d5a1                	beqz	a1,80003104 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031be:	2705                	addiw	a4,a4,1
    800031c0:	2485                	addiw	s1,s1,1
    800031c2:	fd471ae3          	bne	a4,s4,80003196 <balloc+0xce>
    800031c6:	bf49                	j	80003158 <balloc+0x90>
    800031c8:	6906                	ld	s2,64(sp)
    800031ca:	79e2                	ld	s3,56(sp)
    800031cc:	7a42                	ld	s4,48(sp)
    800031ce:	7aa2                	ld	s5,40(sp)
    800031d0:	7b02                	ld	s6,32(sp)
    800031d2:	6be2                	ld	s7,24(sp)
    800031d4:	6c42                	ld	s8,16(sp)
    800031d6:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800031d8:	00004517          	auipc	a0,0x4
    800031dc:	66850513          	addi	a0,a0,1640 # 80007840 <etext+0x840>
    800031e0:	ae2fd0ef          	jal	800004c2 <printf>
  return 0;
    800031e4:	4481                	li	s1,0
    800031e6:	b79d                	j	8000314c <balloc+0x84>

00000000800031e8 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800031e8:	7179                	addi	sp,sp,-48
    800031ea:	f406                	sd	ra,40(sp)
    800031ec:	f022                	sd	s0,32(sp)
    800031ee:	ec26                	sd	s1,24(sp)
    800031f0:	e84a                	sd	s2,16(sp)
    800031f2:	e44e                	sd	s3,8(sp)
    800031f4:	1800                	addi	s0,sp,48
    800031f6:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800031f8:	47ad                	li	a5,11
    800031fa:	02b7e663          	bltu	a5,a1,80003226 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800031fe:	02059793          	slli	a5,a1,0x20
    80003202:	01e7d593          	srli	a1,a5,0x1e
    80003206:	00b504b3          	add	s1,a0,a1
    8000320a:	0504a903          	lw	s2,80(s1)
    8000320e:	06091a63          	bnez	s2,80003282 <bmap+0x9a>
      addr = balloc(ip->dev);
    80003212:	4108                	lw	a0,0(a0)
    80003214:	eb5ff0ef          	jal	800030c8 <balloc>
    80003218:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000321c:	06090363          	beqz	s2,80003282 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80003220:	0524a823          	sw	s2,80(s1)
    80003224:	a8b9                	j	80003282 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003226:	ff45849b          	addiw	s1,a1,-12
    8000322a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000322e:	0ff00793          	li	a5,255
    80003232:	06e7ee63          	bltu	a5,a4,800032ae <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003236:	08052903          	lw	s2,128(a0)
    8000323a:	00091d63          	bnez	s2,80003254 <bmap+0x6c>
      addr = balloc(ip->dev);
    8000323e:	4108                	lw	a0,0(a0)
    80003240:	e89ff0ef          	jal	800030c8 <balloc>
    80003244:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003248:	02090d63          	beqz	s2,80003282 <bmap+0x9a>
    8000324c:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000324e:	0929a023          	sw	s2,128(s3)
    80003252:	a011                	j	80003256 <bmap+0x6e>
    80003254:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003256:	85ca                	mv	a1,s2
    80003258:	0009a503          	lw	a0,0(s3)
    8000325c:	c09ff0ef          	jal	80002e64 <bread>
    80003260:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003262:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003266:	02049713          	slli	a4,s1,0x20
    8000326a:	01e75593          	srli	a1,a4,0x1e
    8000326e:	00b784b3          	add	s1,a5,a1
    80003272:	0004a903          	lw	s2,0(s1)
    80003276:	00090e63          	beqz	s2,80003292 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000327a:	8552                	mv	a0,s4
    8000327c:	cf1ff0ef          	jal	80002f6c <brelse>
    return addr;
    80003280:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003282:	854a                	mv	a0,s2
    80003284:	70a2                	ld	ra,40(sp)
    80003286:	7402                	ld	s0,32(sp)
    80003288:	64e2                	ld	s1,24(sp)
    8000328a:	6942                	ld	s2,16(sp)
    8000328c:	69a2                	ld	s3,8(sp)
    8000328e:	6145                	addi	sp,sp,48
    80003290:	8082                	ret
      addr = balloc(ip->dev);
    80003292:	0009a503          	lw	a0,0(s3)
    80003296:	e33ff0ef          	jal	800030c8 <balloc>
    8000329a:	0005091b          	sext.w	s2,a0
      if(addr){
    8000329e:	fc090ee3          	beqz	s2,8000327a <bmap+0x92>
        a[bn] = addr;
    800032a2:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800032a6:	8552                	mv	a0,s4
    800032a8:	50f000ef          	jal	80003fb6 <log_write>
    800032ac:	b7f9                	j	8000327a <bmap+0x92>
    800032ae:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800032b0:	00004517          	auipc	a0,0x4
    800032b4:	5a850513          	addi	a0,a0,1448 # 80007858 <etext+0x858>
    800032b8:	cdcfd0ef          	jal	80000794 <panic>

00000000800032bc <iget>:
{
    800032bc:	7179                	addi	sp,sp,-48
    800032be:	f406                	sd	ra,40(sp)
    800032c0:	f022                	sd	s0,32(sp)
    800032c2:	ec26                	sd	s1,24(sp)
    800032c4:	e84a                	sd	s2,16(sp)
    800032c6:	e44e                	sd	s3,8(sp)
    800032c8:	e052                	sd	s4,0(sp)
    800032ca:	1800                	addi	s0,sp,48
    800032cc:	89aa                	mv	s3,a0
    800032ce:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800032d0:	0001e517          	auipc	a0,0x1e
    800032d4:	ab850513          	addi	a0,a0,-1352 # 80020d88 <itable>
    800032d8:	91dfd0ef          	jal	80000bf4 <acquire>
  empty = 0;
    800032dc:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800032de:	0001e497          	auipc	s1,0x1e
    800032e2:	ac248493          	addi	s1,s1,-1342 # 80020da0 <itable+0x18>
    800032e6:	0001f697          	auipc	a3,0x1f
    800032ea:	54a68693          	addi	a3,a3,1354 # 80022830 <log>
    800032ee:	a039                	j	800032fc <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800032f0:	02090963          	beqz	s2,80003322 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800032f4:	08848493          	addi	s1,s1,136
    800032f8:	02d48863          	beq	s1,a3,80003328 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800032fc:	449c                	lw	a5,8(s1)
    800032fe:	fef059e3          	blez	a5,800032f0 <iget+0x34>
    80003302:	4098                	lw	a4,0(s1)
    80003304:	ff3716e3          	bne	a4,s3,800032f0 <iget+0x34>
    80003308:	40d8                	lw	a4,4(s1)
    8000330a:	ff4713e3          	bne	a4,s4,800032f0 <iget+0x34>
      ip->ref++;
    8000330e:	2785                	addiw	a5,a5,1
    80003310:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003312:	0001e517          	auipc	a0,0x1e
    80003316:	a7650513          	addi	a0,a0,-1418 # 80020d88 <itable>
    8000331a:	973fd0ef          	jal	80000c8c <release>
      return ip;
    8000331e:	8926                	mv	s2,s1
    80003320:	a02d                	j	8000334a <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003322:	fbe9                	bnez	a5,800032f4 <iget+0x38>
      empty = ip;
    80003324:	8926                	mv	s2,s1
    80003326:	b7f9                	j	800032f4 <iget+0x38>
  if(empty == 0)
    80003328:	02090a63          	beqz	s2,8000335c <iget+0xa0>
  ip->dev = dev;
    8000332c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003330:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003334:	4785                	li	a5,1
    80003336:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000333a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000333e:	0001e517          	auipc	a0,0x1e
    80003342:	a4a50513          	addi	a0,a0,-1462 # 80020d88 <itable>
    80003346:	947fd0ef          	jal	80000c8c <release>
}
    8000334a:	854a                	mv	a0,s2
    8000334c:	70a2                	ld	ra,40(sp)
    8000334e:	7402                	ld	s0,32(sp)
    80003350:	64e2                	ld	s1,24(sp)
    80003352:	6942                	ld	s2,16(sp)
    80003354:	69a2                	ld	s3,8(sp)
    80003356:	6a02                	ld	s4,0(sp)
    80003358:	6145                	addi	sp,sp,48
    8000335a:	8082                	ret
    panic("iget: no inodes");
    8000335c:	00004517          	auipc	a0,0x4
    80003360:	51450513          	addi	a0,a0,1300 # 80007870 <etext+0x870>
    80003364:	c30fd0ef          	jal	80000794 <panic>

0000000080003368 <fsinit>:
fsinit(int dev) {
    80003368:	7179                	addi	sp,sp,-48
    8000336a:	f406                	sd	ra,40(sp)
    8000336c:	f022                	sd	s0,32(sp)
    8000336e:	ec26                	sd	s1,24(sp)
    80003370:	e84a                	sd	s2,16(sp)
    80003372:	e44e                	sd	s3,8(sp)
    80003374:	1800                	addi	s0,sp,48
    80003376:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003378:	4585                	li	a1,1
    8000337a:	aebff0ef          	jal	80002e64 <bread>
    8000337e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003380:	0001e997          	auipc	s3,0x1e
    80003384:	9e898993          	addi	s3,s3,-1560 # 80020d68 <sb>
    80003388:	02000613          	li	a2,32
    8000338c:	05850593          	addi	a1,a0,88
    80003390:	854e                	mv	a0,s3
    80003392:	993fd0ef          	jal	80000d24 <memmove>
  brelse(bp);
    80003396:	8526                	mv	a0,s1
    80003398:	bd5ff0ef          	jal	80002f6c <brelse>
  if(sb.magic != FSMAGIC)
    8000339c:	0009a703          	lw	a4,0(s3)
    800033a0:	102037b7          	lui	a5,0x10203
    800033a4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800033a8:	02f71063          	bne	a4,a5,800033c8 <fsinit+0x60>
  initlog(dev, &sb);
    800033ac:	0001e597          	auipc	a1,0x1e
    800033b0:	9bc58593          	addi	a1,a1,-1604 # 80020d68 <sb>
    800033b4:	854a                	mv	a0,s2
    800033b6:	1f9000ef          	jal	80003dae <initlog>
}
    800033ba:	70a2                	ld	ra,40(sp)
    800033bc:	7402                	ld	s0,32(sp)
    800033be:	64e2                	ld	s1,24(sp)
    800033c0:	6942                	ld	s2,16(sp)
    800033c2:	69a2                	ld	s3,8(sp)
    800033c4:	6145                	addi	sp,sp,48
    800033c6:	8082                	ret
    panic("invalid file system");
    800033c8:	00004517          	auipc	a0,0x4
    800033cc:	4b850513          	addi	a0,a0,1208 # 80007880 <etext+0x880>
    800033d0:	bc4fd0ef          	jal	80000794 <panic>

00000000800033d4 <iinit>:
{
    800033d4:	7179                	addi	sp,sp,-48
    800033d6:	f406                	sd	ra,40(sp)
    800033d8:	f022                	sd	s0,32(sp)
    800033da:	ec26                	sd	s1,24(sp)
    800033dc:	e84a                	sd	s2,16(sp)
    800033de:	e44e                	sd	s3,8(sp)
    800033e0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800033e2:	00004597          	auipc	a1,0x4
    800033e6:	4b658593          	addi	a1,a1,1206 # 80007898 <etext+0x898>
    800033ea:	0001e517          	auipc	a0,0x1e
    800033ee:	99e50513          	addi	a0,a0,-1634 # 80020d88 <itable>
    800033f2:	f82fd0ef          	jal	80000b74 <initlock>
  for(i = 0; i < NINODE; i++) {
    800033f6:	0001e497          	auipc	s1,0x1e
    800033fa:	9ba48493          	addi	s1,s1,-1606 # 80020db0 <itable+0x28>
    800033fe:	0001f997          	auipc	s3,0x1f
    80003402:	44298993          	addi	s3,s3,1090 # 80022840 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003406:	00004917          	auipc	s2,0x4
    8000340a:	49a90913          	addi	s2,s2,1178 # 800078a0 <etext+0x8a0>
    8000340e:	85ca                	mv	a1,s2
    80003410:	8526                	mv	a0,s1
    80003412:	475000ef          	jal	80004086 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003416:	08848493          	addi	s1,s1,136
    8000341a:	ff349ae3          	bne	s1,s3,8000340e <iinit+0x3a>
}
    8000341e:	70a2                	ld	ra,40(sp)
    80003420:	7402                	ld	s0,32(sp)
    80003422:	64e2                	ld	s1,24(sp)
    80003424:	6942                	ld	s2,16(sp)
    80003426:	69a2                	ld	s3,8(sp)
    80003428:	6145                	addi	sp,sp,48
    8000342a:	8082                	ret

000000008000342c <ialloc>:
{
    8000342c:	7139                	addi	sp,sp,-64
    8000342e:	fc06                	sd	ra,56(sp)
    80003430:	f822                	sd	s0,48(sp)
    80003432:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003434:	0001e717          	auipc	a4,0x1e
    80003438:	94072703          	lw	a4,-1728(a4) # 80020d74 <sb+0xc>
    8000343c:	4785                	li	a5,1
    8000343e:	06e7f063          	bgeu	a5,a4,8000349e <ialloc+0x72>
    80003442:	f426                	sd	s1,40(sp)
    80003444:	f04a                	sd	s2,32(sp)
    80003446:	ec4e                	sd	s3,24(sp)
    80003448:	e852                	sd	s4,16(sp)
    8000344a:	e456                	sd	s5,8(sp)
    8000344c:	e05a                	sd	s6,0(sp)
    8000344e:	8aaa                	mv	s5,a0
    80003450:	8b2e                	mv	s6,a1
    80003452:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003454:	0001ea17          	auipc	s4,0x1e
    80003458:	914a0a13          	addi	s4,s4,-1772 # 80020d68 <sb>
    8000345c:	00495593          	srli	a1,s2,0x4
    80003460:	018a2783          	lw	a5,24(s4)
    80003464:	9dbd                	addw	a1,a1,a5
    80003466:	8556                	mv	a0,s5
    80003468:	9fdff0ef          	jal	80002e64 <bread>
    8000346c:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000346e:	05850993          	addi	s3,a0,88
    80003472:	00f97793          	andi	a5,s2,15
    80003476:	079a                	slli	a5,a5,0x6
    80003478:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000347a:	00099783          	lh	a5,0(s3)
    8000347e:	cb9d                	beqz	a5,800034b4 <ialloc+0x88>
    brelse(bp);
    80003480:	aedff0ef          	jal	80002f6c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003484:	0905                	addi	s2,s2,1
    80003486:	00ca2703          	lw	a4,12(s4)
    8000348a:	0009079b          	sext.w	a5,s2
    8000348e:	fce7e7e3          	bltu	a5,a4,8000345c <ialloc+0x30>
    80003492:	74a2                	ld	s1,40(sp)
    80003494:	7902                	ld	s2,32(sp)
    80003496:	69e2                	ld	s3,24(sp)
    80003498:	6a42                	ld	s4,16(sp)
    8000349a:	6aa2                	ld	s5,8(sp)
    8000349c:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000349e:	00004517          	auipc	a0,0x4
    800034a2:	40a50513          	addi	a0,a0,1034 # 800078a8 <etext+0x8a8>
    800034a6:	81cfd0ef          	jal	800004c2 <printf>
  return 0;
    800034aa:	4501                	li	a0,0
}
    800034ac:	70e2                	ld	ra,56(sp)
    800034ae:	7442                	ld	s0,48(sp)
    800034b0:	6121                	addi	sp,sp,64
    800034b2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800034b4:	04000613          	li	a2,64
    800034b8:	4581                	li	a1,0
    800034ba:	854e                	mv	a0,s3
    800034bc:	80dfd0ef          	jal	80000cc8 <memset>
      dip->type = type;
    800034c0:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800034c4:	8526                	mv	a0,s1
    800034c6:	2f1000ef          	jal	80003fb6 <log_write>
      brelse(bp);
    800034ca:	8526                	mv	a0,s1
    800034cc:	aa1ff0ef          	jal	80002f6c <brelse>
      return iget(dev, inum);
    800034d0:	0009059b          	sext.w	a1,s2
    800034d4:	8556                	mv	a0,s5
    800034d6:	de7ff0ef          	jal	800032bc <iget>
    800034da:	74a2                	ld	s1,40(sp)
    800034dc:	7902                	ld	s2,32(sp)
    800034de:	69e2                	ld	s3,24(sp)
    800034e0:	6a42                	ld	s4,16(sp)
    800034e2:	6aa2                	ld	s5,8(sp)
    800034e4:	6b02                	ld	s6,0(sp)
    800034e6:	b7d9                	j	800034ac <ialloc+0x80>

00000000800034e8 <iupdate>:
{
    800034e8:	1101                	addi	sp,sp,-32
    800034ea:	ec06                	sd	ra,24(sp)
    800034ec:	e822                	sd	s0,16(sp)
    800034ee:	e426                	sd	s1,8(sp)
    800034f0:	e04a                	sd	s2,0(sp)
    800034f2:	1000                	addi	s0,sp,32
    800034f4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800034f6:	415c                	lw	a5,4(a0)
    800034f8:	0047d79b          	srliw	a5,a5,0x4
    800034fc:	0001e597          	auipc	a1,0x1e
    80003500:	8845a583          	lw	a1,-1916(a1) # 80020d80 <sb+0x18>
    80003504:	9dbd                	addw	a1,a1,a5
    80003506:	4108                	lw	a0,0(a0)
    80003508:	95dff0ef          	jal	80002e64 <bread>
    8000350c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000350e:	05850793          	addi	a5,a0,88
    80003512:	40d8                	lw	a4,4(s1)
    80003514:	8b3d                	andi	a4,a4,15
    80003516:	071a                	slli	a4,a4,0x6
    80003518:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000351a:	04449703          	lh	a4,68(s1)
    8000351e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003522:	04649703          	lh	a4,70(s1)
    80003526:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000352a:	04849703          	lh	a4,72(s1)
    8000352e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003532:	04a49703          	lh	a4,74(s1)
    80003536:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000353a:	44f8                	lw	a4,76(s1)
    8000353c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000353e:	03400613          	li	a2,52
    80003542:	05048593          	addi	a1,s1,80
    80003546:	00c78513          	addi	a0,a5,12
    8000354a:	fdafd0ef          	jal	80000d24 <memmove>
  log_write(bp);
    8000354e:	854a                	mv	a0,s2
    80003550:	267000ef          	jal	80003fb6 <log_write>
  brelse(bp);
    80003554:	854a                	mv	a0,s2
    80003556:	a17ff0ef          	jal	80002f6c <brelse>
}
    8000355a:	60e2                	ld	ra,24(sp)
    8000355c:	6442                	ld	s0,16(sp)
    8000355e:	64a2                	ld	s1,8(sp)
    80003560:	6902                	ld	s2,0(sp)
    80003562:	6105                	addi	sp,sp,32
    80003564:	8082                	ret

0000000080003566 <idup>:
{
    80003566:	1101                	addi	sp,sp,-32
    80003568:	ec06                	sd	ra,24(sp)
    8000356a:	e822                	sd	s0,16(sp)
    8000356c:	e426                	sd	s1,8(sp)
    8000356e:	1000                	addi	s0,sp,32
    80003570:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003572:	0001e517          	auipc	a0,0x1e
    80003576:	81650513          	addi	a0,a0,-2026 # 80020d88 <itable>
    8000357a:	e7afd0ef          	jal	80000bf4 <acquire>
  ip->ref++;
    8000357e:	449c                	lw	a5,8(s1)
    80003580:	2785                	addiw	a5,a5,1
    80003582:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003584:	0001e517          	auipc	a0,0x1e
    80003588:	80450513          	addi	a0,a0,-2044 # 80020d88 <itable>
    8000358c:	f00fd0ef          	jal	80000c8c <release>
}
    80003590:	8526                	mv	a0,s1
    80003592:	60e2                	ld	ra,24(sp)
    80003594:	6442                	ld	s0,16(sp)
    80003596:	64a2                	ld	s1,8(sp)
    80003598:	6105                	addi	sp,sp,32
    8000359a:	8082                	ret

000000008000359c <ilock>:
{
    8000359c:	1101                	addi	sp,sp,-32
    8000359e:	ec06                	sd	ra,24(sp)
    800035a0:	e822                	sd	s0,16(sp)
    800035a2:	e426                	sd	s1,8(sp)
    800035a4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800035a6:	cd19                	beqz	a0,800035c4 <ilock+0x28>
    800035a8:	84aa                	mv	s1,a0
    800035aa:	451c                	lw	a5,8(a0)
    800035ac:	00f05c63          	blez	a5,800035c4 <ilock+0x28>
  acquiresleep(&ip->lock);
    800035b0:	0541                	addi	a0,a0,16
    800035b2:	30b000ef          	jal	800040bc <acquiresleep>
  if(ip->valid == 0){
    800035b6:	40bc                	lw	a5,64(s1)
    800035b8:	cf89                	beqz	a5,800035d2 <ilock+0x36>
}
    800035ba:	60e2                	ld	ra,24(sp)
    800035bc:	6442                	ld	s0,16(sp)
    800035be:	64a2                	ld	s1,8(sp)
    800035c0:	6105                	addi	sp,sp,32
    800035c2:	8082                	ret
    800035c4:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800035c6:	00004517          	auipc	a0,0x4
    800035ca:	2fa50513          	addi	a0,a0,762 # 800078c0 <etext+0x8c0>
    800035ce:	9c6fd0ef          	jal	80000794 <panic>
    800035d2:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800035d4:	40dc                	lw	a5,4(s1)
    800035d6:	0047d79b          	srliw	a5,a5,0x4
    800035da:	0001d597          	auipc	a1,0x1d
    800035de:	7a65a583          	lw	a1,1958(a1) # 80020d80 <sb+0x18>
    800035e2:	9dbd                	addw	a1,a1,a5
    800035e4:	4088                	lw	a0,0(s1)
    800035e6:	87fff0ef          	jal	80002e64 <bread>
    800035ea:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800035ec:	05850593          	addi	a1,a0,88
    800035f0:	40dc                	lw	a5,4(s1)
    800035f2:	8bbd                	andi	a5,a5,15
    800035f4:	079a                	slli	a5,a5,0x6
    800035f6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800035f8:	00059783          	lh	a5,0(a1)
    800035fc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003600:	00259783          	lh	a5,2(a1)
    80003604:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003608:	00459783          	lh	a5,4(a1)
    8000360c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003610:	00659783          	lh	a5,6(a1)
    80003614:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003618:	459c                	lw	a5,8(a1)
    8000361a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000361c:	03400613          	li	a2,52
    80003620:	05b1                	addi	a1,a1,12
    80003622:	05048513          	addi	a0,s1,80
    80003626:	efefd0ef          	jal	80000d24 <memmove>
    brelse(bp);
    8000362a:	854a                	mv	a0,s2
    8000362c:	941ff0ef          	jal	80002f6c <brelse>
    ip->valid = 1;
    80003630:	4785                	li	a5,1
    80003632:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003634:	04449783          	lh	a5,68(s1)
    80003638:	c399                	beqz	a5,8000363e <ilock+0xa2>
    8000363a:	6902                	ld	s2,0(sp)
    8000363c:	bfbd                	j	800035ba <ilock+0x1e>
      panic("ilock: no type");
    8000363e:	00004517          	auipc	a0,0x4
    80003642:	28a50513          	addi	a0,a0,650 # 800078c8 <etext+0x8c8>
    80003646:	94efd0ef          	jal	80000794 <panic>

000000008000364a <iunlock>:
{
    8000364a:	1101                	addi	sp,sp,-32
    8000364c:	ec06                	sd	ra,24(sp)
    8000364e:	e822                	sd	s0,16(sp)
    80003650:	e426                	sd	s1,8(sp)
    80003652:	e04a                	sd	s2,0(sp)
    80003654:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003656:	c505                	beqz	a0,8000367e <iunlock+0x34>
    80003658:	84aa                	mv	s1,a0
    8000365a:	01050913          	addi	s2,a0,16
    8000365e:	854a                	mv	a0,s2
    80003660:	2db000ef          	jal	8000413a <holdingsleep>
    80003664:	cd09                	beqz	a0,8000367e <iunlock+0x34>
    80003666:	449c                	lw	a5,8(s1)
    80003668:	00f05b63          	blez	a5,8000367e <iunlock+0x34>
  releasesleep(&ip->lock);
    8000366c:	854a                	mv	a0,s2
    8000366e:	295000ef          	jal	80004102 <releasesleep>
}
    80003672:	60e2                	ld	ra,24(sp)
    80003674:	6442                	ld	s0,16(sp)
    80003676:	64a2                	ld	s1,8(sp)
    80003678:	6902                	ld	s2,0(sp)
    8000367a:	6105                	addi	sp,sp,32
    8000367c:	8082                	ret
    panic("iunlock");
    8000367e:	00004517          	auipc	a0,0x4
    80003682:	25a50513          	addi	a0,a0,602 # 800078d8 <etext+0x8d8>
    80003686:	90efd0ef          	jal	80000794 <panic>

000000008000368a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000368a:	7179                	addi	sp,sp,-48
    8000368c:	f406                	sd	ra,40(sp)
    8000368e:	f022                	sd	s0,32(sp)
    80003690:	ec26                	sd	s1,24(sp)
    80003692:	e84a                	sd	s2,16(sp)
    80003694:	e44e                	sd	s3,8(sp)
    80003696:	1800                	addi	s0,sp,48
    80003698:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000369a:	05050493          	addi	s1,a0,80
    8000369e:	08050913          	addi	s2,a0,128
    800036a2:	a021                	j	800036aa <itrunc+0x20>
    800036a4:	0491                	addi	s1,s1,4
    800036a6:	01248b63          	beq	s1,s2,800036bc <itrunc+0x32>
    if(ip->addrs[i]){
    800036aa:	408c                	lw	a1,0(s1)
    800036ac:	dde5                	beqz	a1,800036a4 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800036ae:	0009a503          	lw	a0,0(s3)
    800036b2:	9abff0ef          	jal	8000305c <bfree>
      ip->addrs[i] = 0;
    800036b6:	0004a023          	sw	zero,0(s1)
    800036ba:	b7ed                	j	800036a4 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800036bc:	0809a583          	lw	a1,128(s3)
    800036c0:	ed89                	bnez	a1,800036da <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800036c2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800036c6:	854e                	mv	a0,s3
    800036c8:	e21ff0ef          	jal	800034e8 <iupdate>
}
    800036cc:	70a2                	ld	ra,40(sp)
    800036ce:	7402                	ld	s0,32(sp)
    800036d0:	64e2                	ld	s1,24(sp)
    800036d2:	6942                	ld	s2,16(sp)
    800036d4:	69a2                	ld	s3,8(sp)
    800036d6:	6145                	addi	sp,sp,48
    800036d8:	8082                	ret
    800036da:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800036dc:	0009a503          	lw	a0,0(s3)
    800036e0:	f84ff0ef          	jal	80002e64 <bread>
    800036e4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800036e6:	05850493          	addi	s1,a0,88
    800036ea:	45850913          	addi	s2,a0,1112
    800036ee:	a021                	j	800036f6 <itrunc+0x6c>
    800036f0:	0491                	addi	s1,s1,4
    800036f2:	01248963          	beq	s1,s2,80003704 <itrunc+0x7a>
      if(a[j])
    800036f6:	408c                	lw	a1,0(s1)
    800036f8:	dde5                	beqz	a1,800036f0 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800036fa:	0009a503          	lw	a0,0(s3)
    800036fe:	95fff0ef          	jal	8000305c <bfree>
    80003702:	b7fd                	j	800036f0 <itrunc+0x66>
    brelse(bp);
    80003704:	8552                	mv	a0,s4
    80003706:	867ff0ef          	jal	80002f6c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000370a:	0809a583          	lw	a1,128(s3)
    8000370e:	0009a503          	lw	a0,0(s3)
    80003712:	94bff0ef          	jal	8000305c <bfree>
    ip->addrs[NDIRECT] = 0;
    80003716:	0809a023          	sw	zero,128(s3)
    8000371a:	6a02                	ld	s4,0(sp)
    8000371c:	b75d                	j	800036c2 <itrunc+0x38>

000000008000371e <iput>:
{
    8000371e:	1101                	addi	sp,sp,-32
    80003720:	ec06                	sd	ra,24(sp)
    80003722:	e822                	sd	s0,16(sp)
    80003724:	e426                	sd	s1,8(sp)
    80003726:	1000                	addi	s0,sp,32
    80003728:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000372a:	0001d517          	auipc	a0,0x1d
    8000372e:	65e50513          	addi	a0,a0,1630 # 80020d88 <itable>
    80003732:	cc2fd0ef          	jal	80000bf4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003736:	4498                	lw	a4,8(s1)
    80003738:	4785                	li	a5,1
    8000373a:	02f70063          	beq	a4,a5,8000375a <iput+0x3c>
  ip->ref--;
    8000373e:	449c                	lw	a5,8(s1)
    80003740:	37fd                	addiw	a5,a5,-1
    80003742:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003744:	0001d517          	auipc	a0,0x1d
    80003748:	64450513          	addi	a0,a0,1604 # 80020d88 <itable>
    8000374c:	d40fd0ef          	jal	80000c8c <release>
}
    80003750:	60e2                	ld	ra,24(sp)
    80003752:	6442                	ld	s0,16(sp)
    80003754:	64a2                	ld	s1,8(sp)
    80003756:	6105                	addi	sp,sp,32
    80003758:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000375a:	40bc                	lw	a5,64(s1)
    8000375c:	d3ed                	beqz	a5,8000373e <iput+0x20>
    8000375e:	04a49783          	lh	a5,74(s1)
    80003762:	fff1                	bnez	a5,8000373e <iput+0x20>
    80003764:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003766:	01048913          	addi	s2,s1,16
    8000376a:	854a                	mv	a0,s2
    8000376c:	151000ef          	jal	800040bc <acquiresleep>
    release(&itable.lock);
    80003770:	0001d517          	auipc	a0,0x1d
    80003774:	61850513          	addi	a0,a0,1560 # 80020d88 <itable>
    80003778:	d14fd0ef          	jal	80000c8c <release>
    itrunc(ip);
    8000377c:	8526                	mv	a0,s1
    8000377e:	f0dff0ef          	jal	8000368a <itrunc>
    ip->type = 0;
    80003782:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003786:	8526                	mv	a0,s1
    80003788:	d61ff0ef          	jal	800034e8 <iupdate>
    ip->valid = 0;
    8000378c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003790:	854a                	mv	a0,s2
    80003792:	171000ef          	jal	80004102 <releasesleep>
    acquire(&itable.lock);
    80003796:	0001d517          	auipc	a0,0x1d
    8000379a:	5f250513          	addi	a0,a0,1522 # 80020d88 <itable>
    8000379e:	c56fd0ef          	jal	80000bf4 <acquire>
    800037a2:	6902                	ld	s2,0(sp)
    800037a4:	bf69                	j	8000373e <iput+0x20>

00000000800037a6 <iunlockput>:
{
    800037a6:	1101                	addi	sp,sp,-32
    800037a8:	ec06                	sd	ra,24(sp)
    800037aa:	e822                	sd	s0,16(sp)
    800037ac:	e426                	sd	s1,8(sp)
    800037ae:	1000                	addi	s0,sp,32
    800037b0:	84aa                	mv	s1,a0
  iunlock(ip);
    800037b2:	e99ff0ef          	jal	8000364a <iunlock>
  iput(ip);
    800037b6:	8526                	mv	a0,s1
    800037b8:	f67ff0ef          	jal	8000371e <iput>
}
    800037bc:	60e2                	ld	ra,24(sp)
    800037be:	6442                	ld	s0,16(sp)
    800037c0:	64a2                	ld	s1,8(sp)
    800037c2:	6105                	addi	sp,sp,32
    800037c4:	8082                	ret

00000000800037c6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800037c6:	1141                	addi	sp,sp,-16
    800037c8:	e422                	sd	s0,8(sp)
    800037ca:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800037cc:	411c                	lw	a5,0(a0)
    800037ce:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800037d0:	415c                	lw	a5,4(a0)
    800037d2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800037d4:	04451783          	lh	a5,68(a0)
    800037d8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800037dc:	04a51783          	lh	a5,74(a0)
    800037e0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800037e4:	04c56783          	lwu	a5,76(a0)
    800037e8:	e99c                	sd	a5,16(a1)
}
    800037ea:	6422                	ld	s0,8(sp)
    800037ec:	0141                	addi	sp,sp,16
    800037ee:	8082                	ret

00000000800037f0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800037f0:	457c                	lw	a5,76(a0)
    800037f2:	0ed7eb63          	bltu	a5,a3,800038e8 <readi+0xf8>
{
    800037f6:	7159                	addi	sp,sp,-112
    800037f8:	f486                	sd	ra,104(sp)
    800037fa:	f0a2                	sd	s0,96(sp)
    800037fc:	eca6                	sd	s1,88(sp)
    800037fe:	e0d2                	sd	s4,64(sp)
    80003800:	fc56                	sd	s5,56(sp)
    80003802:	f85a                	sd	s6,48(sp)
    80003804:	f45e                	sd	s7,40(sp)
    80003806:	1880                	addi	s0,sp,112
    80003808:	8b2a                	mv	s6,a0
    8000380a:	8bae                	mv	s7,a1
    8000380c:	8a32                	mv	s4,a2
    8000380e:	84b6                	mv	s1,a3
    80003810:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003812:	9f35                	addw	a4,a4,a3
    return 0;
    80003814:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003816:	0cd76063          	bltu	a4,a3,800038d6 <readi+0xe6>
    8000381a:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000381c:	00e7f463          	bgeu	a5,a4,80003824 <readi+0x34>
    n = ip->size - off;
    80003820:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003824:	080a8f63          	beqz	s5,800038c2 <readi+0xd2>
    80003828:	e8ca                	sd	s2,80(sp)
    8000382a:	f062                	sd	s8,32(sp)
    8000382c:	ec66                	sd	s9,24(sp)
    8000382e:	e86a                	sd	s10,16(sp)
    80003830:	e46e                	sd	s11,8(sp)
    80003832:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003834:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003838:	5c7d                	li	s8,-1
    8000383a:	a80d                	j	8000386c <readi+0x7c>
    8000383c:	020d1d93          	slli	s11,s10,0x20
    80003840:	020ddd93          	srli	s11,s11,0x20
    80003844:	05890613          	addi	a2,s2,88
    80003848:	86ee                	mv	a3,s11
    8000384a:	963a                	add	a2,a2,a4
    8000384c:	85d2                	mv	a1,s4
    8000384e:	855e                	mv	a0,s7
    80003850:	9bbfe0ef          	jal	8000220a <either_copyout>
    80003854:	05850763          	beq	a0,s8,800038a2 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003858:	854a                	mv	a0,s2
    8000385a:	f12ff0ef          	jal	80002f6c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000385e:	013d09bb          	addw	s3,s10,s3
    80003862:	009d04bb          	addw	s1,s10,s1
    80003866:	9a6e                	add	s4,s4,s11
    80003868:	0559f763          	bgeu	s3,s5,800038b6 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    8000386c:	00a4d59b          	srliw	a1,s1,0xa
    80003870:	855a                	mv	a0,s6
    80003872:	977ff0ef          	jal	800031e8 <bmap>
    80003876:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000387a:	c5b1                	beqz	a1,800038c6 <readi+0xd6>
    bp = bread(ip->dev, addr);
    8000387c:	000b2503          	lw	a0,0(s6)
    80003880:	de4ff0ef          	jal	80002e64 <bread>
    80003884:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003886:	3ff4f713          	andi	a4,s1,1023
    8000388a:	40ec87bb          	subw	a5,s9,a4
    8000388e:	413a86bb          	subw	a3,s5,s3
    80003892:	8d3e                	mv	s10,a5
    80003894:	2781                	sext.w	a5,a5
    80003896:	0006861b          	sext.w	a2,a3
    8000389a:	faf671e3          	bgeu	a2,a5,8000383c <readi+0x4c>
    8000389e:	8d36                	mv	s10,a3
    800038a0:	bf71                	j	8000383c <readi+0x4c>
      brelse(bp);
    800038a2:	854a                	mv	a0,s2
    800038a4:	ec8ff0ef          	jal	80002f6c <brelse>
      tot = -1;
    800038a8:	59fd                	li	s3,-1
      break;
    800038aa:	6946                	ld	s2,80(sp)
    800038ac:	7c02                	ld	s8,32(sp)
    800038ae:	6ce2                	ld	s9,24(sp)
    800038b0:	6d42                	ld	s10,16(sp)
    800038b2:	6da2                	ld	s11,8(sp)
    800038b4:	a831                	j	800038d0 <readi+0xe0>
    800038b6:	6946                	ld	s2,80(sp)
    800038b8:	7c02                	ld	s8,32(sp)
    800038ba:	6ce2                	ld	s9,24(sp)
    800038bc:	6d42                	ld	s10,16(sp)
    800038be:	6da2                	ld	s11,8(sp)
    800038c0:	a801                	j	800038d0 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800038c2:	89d6                	mv	s3,s5
    800038c4:	a031                	j	800038d0 <readi+0xe0>
    800038c6:	6946                	ld	s2,80(sp)
    800038c8:	7c02                	ld	s8,32(sp)
    800038ca:	6ce2                	ld	s9,24(sp)
    800038cc:	6d42                	ld	s10,16(sp)
    800038ce:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800038d0:	0009851b          	sext.w	a0,s3
    800038d4:	69a6                	ld	s3,72(sp)
}
    800038d6:	70a6                	ld	ra,104(sp)
    800038d8:	7406                	ld	s0,96(sp)
    800038da:	64e6                	ld	s1,88(sp)
    800038dc:	6a06                	ld	s4,64(sp)
    800038de:	7ae2                	ld	s5,56(sp)
    800038e0:	7b42                	ld	s6,48(sp)
    800038e2:	7ba2                	ld	s7,40(sp)
    800038e4:	6165                	addi	sp,sp,112
    800038e6:	8082                	ret
    return 0;
    800038e8:	4501                	li	a0,0
}
    800038ea:	8082                	ret

00000000800038ec <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800038ec:	457c                	lw	a5,76(a0)
    800038ee:	10d7e063          	bltu	a5,a3,800039ee <writei+0x102>
{
    800038f2:	7159                	addi	sp,sp,-112
    800038f4:	f486                	sd	ra,104(sp)
    800038f6:	f0a2                	sd	s0,96(sp)
    800038f8:	e8ca                	sd	s2,80(sp)
    800038fa:	e0d2                	sd	s4,64(sp)
    800038fc:	fc56                	sd	s5,56(sp)
    800038fe:	f85a                	sd	s6,48(sp)
    80003900:	f45e                	sd	s7,40(sp)
    80003902:	1880                	addi	s0,sp,112
    80003904:	8aaa                	mv	s5,a0
    80003906:	8bae                	mv	s7,a1
    80003908:	8a32                	mv	s4,a2
    8000390a:	8936                	mv	s2,a3
    8000390c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000390e:	00e687bb          	addw	a5,a3,a4
    80003912:	0ed7e063          	bltu	a5,a3,800039f2 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003916:	00043737          	lui	a4,0x43
    8000391a:	0cf76e63          	bltu	a4,a5,800039f6 <writei+0x10a>
    8000391e:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003920:	0a0b0f63          	beqz	s6,800039de <writei+0xf2>
    80003924:	eca6                	sd	s1,88(sp)
    80003926:	f062                	sd	s8,32(sp)
    80003928:	ec66                	sd	s9,24(sp)
    8000392a:	e86a                	sd	s10,16(sp)
    8000392c:	e46e                	sd	s11,8(sp)
    8000392e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003930:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003934:	5c7d                	li	s8,-1
    80003936:	a825                	j	8000396e <writei+0x82>
    80003938:	020d1d93          	slli	s11,s10,0x20
    8000393c:	020ddd93          	srli	s11,s11,0x20
    80003940:	05848513          	addi	a0,s1,88
    80003944:	86ee                	mv	a3,s11
    80003946:	8652                	mv	a2,s4
    80003948:	85de                	mv	a1,s7
    8000394a:	953a                	add	a0,a0,a4
    8000394c:	909fe0ef          	jal	80002254 <either_copyin>
    80003950:	05850a63          	beq	a0,s8,800039a4 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003954:	8526                	mv	a0,s1
    80003956:	660000ef          	jal	80003fb6 <log_write>
    brelse(bp);
    8000395a:	8526                	mv	a0,s1
    8000395c:	e10ff0ef          	jal	80002f6c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003960:	013d09bb          	addw	s3,s10,s3
    80003964:	012d093b          	addw	s2,s10,s2
    80003968:	9a6e                	add	s4,s4,s11
    8000396a:	0569f063          	bgeu	s3,s6,800039aa <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    8000396e:	00a9559b          	srliw	a1,s2,0xa
    80003972:	8556                	mv	a0,s5
    80003974:	875ff0ef          	jal	800031e8 <bmap>
    80003978:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000397c:	c59d                	beqz	a1,800039aa <writei+0xbe>
    bp = bread(ip->dev, addr);
    8000397e:	000aa503          	lw	a0,0(s5)
    80003982:	ce2ff0ef          	jal	80002e64 <bread>
    80003986:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003988:	3ff97713          	andi	a4,s2,1023
    8000398c:	40ec87bb          	subw	a5,s9,a4
    80003990:	413b06bb          	subw	a3,s6,s3
    80003994:	8d3e                	mv	s10,a5
    80003996:	2781                	sext.w	a5,a5
    80003998:	0006861b          	sext.w	a2,a3
    8000399c:	f8f67ee3          	bgeu	a2,a5,80003938 <writei+0x4c>
    800039a0:	8d36                	mv	s10,a3
    800039a2:	bf59                	j	80003938 <writei+0x4c>
      brelse(bp);
    800039a4:	8526                	mv	a0,s1
    800039a6:	dc6ff0ef          	jal	80002f6c <brelse>
  }

  if(off > ip->size)
    800039aa:	04caa783          	lw	a5,76(s5)
    800039ae:	0327fa63          	bgeu	a5,s2,800039e2 <writei+0xf6>
    ip->size = off;
    800039b2:	052aa623          	sw	s2,76(s5)
    800039b6:	64e6                	ld	s1,88(sp)
    800039b8:	7c02                	ld	s8,32(sp)
    800039ba:	6ce2                	ld	s9,24(sp)
    800039bc:	6d42                	ld	s10,16(sp)
    800039be:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800039c0:	8556                	mv	a0,s5
    800039c2:	b27ff0ef          	jal	800034e8 <iupdate>

  return tot;
    800039c6:	0009851b          	sext.w	a0,s3
    800039ca:	69a6                	ld	s3,72(sp)
}
    800039cc:	70a6                	ld	ra,104(sp)
    800039ce:	7406                	ld	s0,96(sp)
    800039d0:	6946                	ld	s2,80(sp)
    800039d2:	6a06                	ld	s4,64(sp)
    800039d4:	7ae2                	ld	s5,56(sp)
    800039d6:	7b42                	ld	s6,48(sp)
    800039d8:	7ba2                	ld	s7,40(sp)
    800039da:	6165                	addi	sp,sp,112
    800039dc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039de:	89da                	mv	s3,s6
    800039e0:	b7c5                	j	800039c0 <writei+0xd4>
    800039e2:	64e6                	ld	s1,88(sp)
    800039e4:	7c02                	ld	s8,32(sp)
    800039e6:	6ce2                	ld	s9,24(sp)
    800039e8:	6d42                	ld	s10,16(sp)
    800039ea:	6da2                	ld	s11,8(sp)
    800039ec:	bfd1                	j	800039c0 <writei+0xd4>
    return -1;
    800039ee:	557d                	li	a0,-1
}
    800039f0:	8082                	ret
    return -1;
    800039f2:	557d                	li	a0,-1
    800039f4:	bfe1                	j	800039cc <writei+0xe0>
    return -1;
    800039f6:	557d                	li	a0,-1
    800039f8:	bfd1                	j	800039cc <writei+0xe0>

00000000800039fa <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800039fa:	1141                	addi	sp,sp,-16
    800039fc:	e406                	sd	ra,8(sp)
    800039fe:	e022                	sd	s0,0(sp)
    80003a00:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003a02:	4639                	li	a2,14
    80003a04:	b90fd0ef          	jal	80000d94 <strncmp>
}
    80003a08:	60a2                	ld	ra,8(sp)
    80003a0a:	6402                	ld	s0,0(sp)
    80003a0c:	0141                	addi	sp,sp,16
    80003a0e:	8082                	ret

0000000080003a10 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003a10:	7139                	addi	sp,sp,-64
    80003a12:	fc06                	sd	ra,56(sp)
    80003a14:	f822                	sd	s0,48(sp)
    80003a16:	f426                	sd	s1,40(sp)
    80003a18:	f04a                	sd	s2,32(sp)
    80003a1a:	ec4e                	sd	s3,24(sp)
    80003a1c:	e852                	sd	s4,16(sp)
    80003a1e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003a20:	04451703          	lh	a4,68(a0)
    80003a24:	4785                	li	a5,1
    80003a26:	00f71a63          	bne	a4,a5,80003a3a <dirlookup+0x2a>
    80003a2a:	892a                	mv	s2,a0
    80003a2c:	89ae                	mv	s3,a1
    80003a2e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a30:	457c                	lw	a5,76(a0)
    80003a32:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003a34:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a36:	e39d                	bnez	a5,80003a5c <dirlookup+0x4c>
    80003a38:	a095                	j	80003a9c <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003a3a:	00004517          	auipc	a0,0x4
    80003a3e:	ea650513          	addi	a0,a0,-346 # 800078e0 <etext+0x8e0>
    80003a42:	d53fc0ef          	jal	80000794 <panic>
      panic("dirlookup read");
    80003a46:	00004517          	auipc	a0,0x4
    80003a4a:	eb250513          	addi	a0,a0,-334 # 800078f8 <etext+0x8f8>
    80003a4e:	d47fc0ef          	jal	80000794 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a52:	24c1                	addiw	s1,s1,16
    80003a54:	04c92783          	lw	a5,76(s2)
    80003a58:	04f4f163          	bgeu	s1,a5,80003a9a <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a5c:	4741                	li	a4,16
    80003a5e:	86a6                	mv	a3,s1
    80003a60:	fc040613          	addi	a2,s0,-64
    80003a64:	4581                	li	a1,0
    80003a66:	854a                	mv	a0,s2
    80003a68:	d89ff0ef          	jal	800037f0 <readi>
    80003a6c:	47c1                	li	a5,16
    80003a6e:	fcf51ce3          	bne	a0,a5,80003a46 <dirlookup+0x36>
    if(de.inum == 0)
    80003a72:	fc045783          	lhu	a5,-64(s0)
    80003a76:	dff1                	beqz	a5,80003a52 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003a78:	fc240593          	addi	a1,s0,-62
    80003a7c:	854e                	mv	a0,s3
    80003a7e:	f7dff0ef          	jal	800039fa <namecmp>
    80003a82:	f961                	bnez	a0,80003a52 <dirlookup+0x42>
      if(poff)
    80003a84:	000a0463          	beqz	s4,80003a8c <dirlookup+0x7c>
        *poff = off;
    80003a88:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003a8c:	fc045583          	lhu	a1,-64(s0)
    80003a90:	00092503          	lw	a0,0(s2)
    80003a94:	829ff0ef          	jal	800032bc <iget>
    80003a98:	a011                	j	80003a9c <dirlookup+0x8c>
  return 0;
    80003a9a:	4501                	li	a0,0
}
    80003a9c:	70e2                	ld	ra,56(sp)
    80003a9e:	7442                	ld	s0,48(sp)
    80003aa0:	74a2                	ld	s1,40(sp)
    80003aa2:	7902                	ld	s2,32(sp)
    80003aa4:	69e2                	ld	s3,24(sp)
    80003aa6:	6a42                	ld	s4,16(sp)
    80003aa8:	6121                	addi	sp,sp,64
    80003aaa:	8082                	ret

0000000080003aac <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003aac:	711d                	addi	sp,sp,-96
    80003aae:	ec86                	sd	ra,88(sp)
    80003ab0:	e8a2                	sd	s0,80(sp)
    80003ab2:	e4a6                	sd	s1,72(sp)
    80003ab4:	e0ca                	sd	s2,64(sp)
    80003ab6:	fc4e                	sd	s3,56(sp)
    80003ab8:	f852                	sd	s4,48(sp)
    80003aba:	f456                	sd	s5,40(sp)
    80003abc:	f05a                	sd	s6,32(sp)
    80003abe:	ec5e                	sd	s7,24(sp)
    80003ac0:	e862                	sd	s8,16(sp)
    80003ac2:	e466                	sd	s9,8(sp)
    80003ac4:	1080                	addi	s0,sp,96
    80003ac6:	84aa                	mv	s1,a0
    80003ac8:	8b2e                	mv	s6,a1
    80003aca:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003acc:	00054703          	lbu	a4,0(a0)
    80003ad0:	02f00793          	li	a5,47
    80003ad4:	00f70e63          	beq	a4,a5,80003af0 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003ad8:	e09fd0ef          	jal	800018e0 <myproc>
    80003adc:	15053503          	ld	a0,336(a0)
    80003ae0:	a87ff0ef          	jal	80003566 <idup>
    80003ae4:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003ae6:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003aea:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003aec:	4b85                	li	s7,1
    80003aee:	a871                	j	80003b8a <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003af0:	4585                	li	a1,1
    80003af2:	4505                	li	a0,1
    80003af4:	fc8ff0ef          	jal	800032bc <iget>
    80003af8:	8a2a                	mv	s4,a0
    80003afa:	b7f5                	j	80003ae6 <namex+0x3a>
      iunlockput(ip);
    80003afc:	8552                	mv	a0,s4
    80003afe:	ca9ff0ef          	jal	800037a6 <iunlockput>
      return 0;
    80003b02:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003b04:	8552                	mv	a0,s4
    80003b06:	60e6                	ld	ra,88(sp)
    80003b08:	6446                	ld	s0,80(sp)
    80003b0a:	64a6                	ld	s1,72(sp)
    80003b0c:	6906                	ld	s2,64(sp)
    80003b0e:	79e2                	ld	s3,56(sp)
    80003b10:	7a42                	ld	s4,48(sp)
    80003b12:	7aa2                	ld	s5,40(sp)
    80003b14:	7b02                	ld	s6,32(sp)
    80003b16:	6be2                	ld	s7,24(sp)
    80003b18:	6c42                	ld	s8,16(sp)
    80003b1a:	6ca2                	ld	s9,8(sp)
    80003b1c:	6125                	addi	sp,sp,96
    80003b1e:	8082                	ret
      iunlock(ip);
    80003b20:	8552                	mv	a0,s4
    80003b22:	b29ff0ef          	jal	8000364a <iunlock>
      return ip;
    80003b26:	bff9                	j	80003b04 <namex+0x58>
      iunlockput(ip);
    80003b28:	8552                	mv	a0,s4
    80003b2a:	c7dff0ef          	jal	800037a6 <iunlockput>
      return 0;
    80003b2e:	8a4e                	mv	s4,s3
    80003b30:	bfd1                	j	80003b04 <namex+0x58>
  len = path - s;
    80003b32:	40998633          	sub	a2,s3,s1
    80003b36:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003b3a:	099c5063          	bge	s8,s9,80003bba <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003b3e:	4639                	li	a2,14
    80003b40:	85a6                	mv	a1,s1
    80003b42:	8556                	mv	a0,s5
    80003b44:	9e0fd0ef          	jal	80000d24 <memmove>
    80003b48:	84ce                	mv	s1,s3
  while(*path == '/')
    80003b4a:	0004c783          	lbu	a5,0(s1)
    80003b4e:	01279763          	bne	a5,s2,80003b5c <namex+0xb0>
    path++;
    80003b52:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003b54:	0004c783          	lbu	a5,0(s1)
    80003b58:	ff278de3          	beq	a5,s2,80003b52 <namex+0xa6>
    ilock(ip);
    80003b5c:	8552                	mv	a0,s4
    80003b5e:	a3fff0ef          	jal	8000359c <ilock>
    if(ip->type != T_DIR){
    80003b62:	044a1783          	lh	a5,68(s4)
    80003b66:	f9779be3          	bne	a5,s7,80003afc <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003b6a:	000b0563          	beqz	s6,80003b74 <namex+0xc8>
    80003b6e:	0004c783          	lbu	a5,0(s1)
    80003b72:	d7dd                	beqz	a5,80003b20 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003b74:	4601                	li	a2,0
    80003b76:	85d6                	mv	a1,s5
    80003b78:	8552                	mv	a0,s4
    80003b7a:	e97ff0ef          	jal	80003a10 <dirlookup>
    80003b7e:	89aa                	mv	s3,a0
    80003b80:	d545                	beqz	a0,80003b28 <namex+0x7c>
    iunlockput(ip);
    80003b82:	8552                	mv	a0,s4
    80003b84:	c23ff0ef          	jal	800037a6 <iunlockput>
    ip = next;
    80003b88:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003b8a:	0004c783          	lbu	a5,0(s1)
    80003b8e:	01279763          	bne	a5,s2,80003b9c <namex+0xf0>
    path++;
    80003b92:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003b94:	0004c783          	lbu	a5,0(s1)
    80003b98:	ff278de3          	beq	a5,s2,80003b92 <namex+0xe6>
  if(*path == 0)
    80003b9c:	cb8d                	beqz	a5,80003bce <namex+0x122>
  while(*path != '/' && *path != 0)
    80003b9e:	0004c783          	lbu	a5,0(s1)
    80003ba2:	89a6                	mv	s3,s1
  len = path - s;
    80003ba4:	4c81                	li	s9,0
    80003ba6:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003ba8:	01278963          	beq	a5,s2,80003bba <namex+0x10e>
    80003bac:	d3d9                	beqz	a5,80003b32 <namex+0x86>
    path++;
    80003bae:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003bb0:	0009c783          	lbu	a5,0(s3)
    80003bb4:	ff279ce3          	bne	a5,s2,80003bac <namex+0x100>
    80003bb8:	bfad                	j	80003b32 <namex+0x86>
    memmove(name, s, len);
    80003bba:	2601                	sext.w	a2,a2
    80003bbc:	85a6                	mv	a1,s1
    80003bbe:	8556                	mv	a0,s5
    80003bc0:	964fd0ef          	jal	80000d24 <memmove>
    name[len] = 0;
    80003bc4:	9cd6                	add	s9,s9,s5
    80003bc6:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003bca:	84ce                	mv	s1,s3
    80003bcc:	bfbd                	j	80003b4a <namex+0x9e>
  if(nameiparent){
    80003bce:	f20b0be3          	beqz	s6,80003b04 <namex+0x58>
    iput(ip);
    80003bd2:	8552                	mv	a0,s4
    80003bd4:	b4bff0ef          	jal	8000371e <iput>
    return 0;
    80003bd8:	4a01                	li	s4,0
    80003bda:	b72d                	j	80003b04 <namex+0x58>

0000000080003bdc <dirlink>:
{
    80003bdc:	7139                	addi	sp,sp,-64
    80003bde:	fc06                	sd	ra,56(sp)
    80003be0:	f822                	sd	s0,48(sp)
    80003be2:	f04a                	sd	s2,32(sp)
    80003be4:	ec4e                	sd	s3,24(sp)
    80003be6:	e852                	sd	s4,16(sp)
    80003be8:	0080                	addi	s0,sp,64
    80003bea:	892a                	mv	s2,a0
    80003bec:	8a2e                	mv	s4,a1
    80003bee:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003bf0:	4601                	li	a2,0
    80003bf2:	e1fff0ef          	jal	80003a10 <dirlookup>
    80003bf6:	e535                	bnez	a0,80003c62 <dirlink+0x86>
    80003bf8:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003bfa:	04c92483          	lw	s1,76(s2)
    80003bfe:	c48d                	beqz	s1,80003c28 <dirlink+0x4c>
    80003c00:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c02:	4741                	li	a4,16
    80003c04:	86a6                	mv	a3,s1
    80003c06:	fc040613          	addi	a2,s0,-64
    80003c0a:	4581                	li	a1,0
    80003c0c:	854a                	mv	a0,s2
    80003c0e:	be3ff0ef          	jal	800037f0 <readi>
    80003c12:	47c1                	li	a5,16
    80003c14:	04f51b63          	bne	a0,a5,80003c6a <dirlink+0x8e>
    if(de.inum == 0)
    80003c18:	fc045783          	lhu	a5,-64(s0)
    80003c1c:	c791                	beqz	a5,80003c28 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c1e:	24c1                	addiw	s1,s1,16
    80003c20:	04c92783          	lw	a5,76(s2)
    80003c24:	fcf4efe3          	bltu	s1,a5,80003c02 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003c28:	4639                	li	a2,14
    80003c2a:	85d2                	mv	a1,s4
    80003c2c:	fc240513          	addi	a0,s0,-62
    80003c30:	99afd0ef          	jal	80000dca <strncpy>
  de.inum = inum;
    80003c34:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c38:	4741                	li	a4,16
    80003c3a:	86a6                	mv	a3,s1
    80003c3c:	fc040613          	addi	a2,s0,-64
    80003c40:	4581                	li	a1,0
    80003c42:	854a                	mv	a0,s2
    80003c44:	ca9ff0ef          	jal	800038ec <writei>
    80003c48:	1541                	addi	a0,a0,-16
    80003c4a:	00a03533          	snez	a0,a0
    80003c4e:	40a00533          	neg	a0,a0
    80003c52:	74a2                	ld	s1,40(sp)
}
    80003c54:	70e2                	ld	ra,56(sp)
    80003c56:	7442                	ld	s0,48(sp)
    80003c58:	7902                	ld	s2,32(sp)
    80003c5a:	69e2                	ld	s3,24(sp)
    80003c5c:	6a42                	ld	s4,16(sp)
    80003c5e:	6121                	addi	sp,sp,64
    80003c60:	8082                	ret
    iput(ip);
    80003c62:	abdff0ef          	jal	8000371e <iput>
    return -1;
    80003c66:	557d                	li	a0,-1
    80003c68:	b7f5                	j	80003c54 <dirlink+0x78>
      panic("dirlink read");
    80003c6a:	00004517          	auipc	a0,0x4
    80003c6e:	c9e50513          	addi	a0,a0,-866 # 80007908 <etext+0x908>
    80003c72:	b23fc0ef          	jal	80000794 <panic>

0000000080003c76 <namei>:

struct inode*
namei(char *path)
{
    80003c76:	1101                	addi	sp,sp,-32
    80003c78:	ec06                	sd	ra,24(sp)
    80003c7a:	e822                	sd	s0,16(sp)
    80003c7c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003c7e:	fe040613          	addi	a2,s0,-32
    80003c82:	4581                	li	a1,0
    80003c84:	e29ff0ef          	jal	80003aac <namex>
}
    80003c88:	60e2                	ld	ra,24(sp)
    80003c8a:	6442                	ld	s0,16(sp)
    80003c8c:	6105                	addi	sp,sp,32
    80003c8e:	8082                	ret

0000000080003c90 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003c90:	1141                	addi	sp,sp,-16
    80003c92:	e406                	sd	ra,8(sp)
    80003c94:	e022                	sd	s0,0(sp)
    80003c96:	0800                	addi	s0,sp,16
    80003c98:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003c9a:	4585                	li	a1,1
    80003c9c:	e11ff0ef          	jal	80003aac <namex>
}
    80003ca0:	60a2                	ld	ra,8(sp)
    80003ca2:	6402                	ld	s0,0(sp)
    80003ca4:	0141                	addi	sp,sp,16
    80003ca6:	8082                	ret

0000000080003ca8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003ca8:	1101                	addi	sp,sp,-32
    80003caa:	ec06                	sd	ra,24(sp)
    80003cac:	e822                	sd	s0,16(sp)
    80003cae:	e426                	sd	s1,8(sp)
    80003cb0:	e04a                	sd	s2,0(sp)
    80003cb2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003cb4:	0001f917          	auipc	s2,0x1f
    80003cb8:	b7c90913          	addi	s2,s2,-1156 # 80022830 <log>
    80003cbc:	01892583          	lw	a1,24(s2)
    80003cc0:	02892503          	lw	a0,40(s2)
    80003cc4:	9a0ff0ef          	jal	80002e64 <bread>
    80003cc8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003cca:	02c92603          	lw	a2,44(s2)
    80003cce:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003cd0:	00c05f63          	blez	a2,80003cee <write_head+0x46>
    80003cd4:	0001f717          	auipc	a4,0x1f
    80003cd8:	b8c70713          	addi	a4,a4,-1140 # 80022860 <log+0x30>
    80003cdc:	87aa                	mv	a5,a0
    80003cde:	060a                	slli	a2,a2,0x2
    80003ce0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003ce2:	4314                	lw	a3,0(a4)
    80003ce4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003ce6:	0711                	addi	a4,a4,4
    80003ce8:	0791                	addi	a5,a5,4
    80003cea:	fec79ce3          	bne	a5,a2,80003ce2 <write_head+0x3a>
  }
  bwrite(buf);
    80003cee:	8526                	mv	a0,s1
    80003cf0:	a4aff0ef          	jal	80002f3a <bwrite>
  brelse(buf);
    80003cf4:	8526                	mv	a0,s1
    80003cf6:	a76ff0ef          	jal	80002f6c <brelse>
}
    80003cfa:	60e2                	ld	ra,24(sp)
    80003cfc:	6442                	ld	s0,16(sp)
    80003cfe:	64a2                	ld	s1,8(sp)
    80003d00:	6902                	ld	s2,0(sp)
    80003d02:	6105                	addi	sp,sp,32
    80003d04:	8082                	ret

0000000080003d06 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d06:	0001f797          	auipc	a5,0x1f
    80003d0a:	b567a783          	lw	a5,-1194(a5) # 8002285c <log+0x2c>
    80003d0e:	08f05f63          	blez	a5,80003dac <install_trans+0xa6>
{
    80003d12:	7139                	addi	sp,sp,-64
    80003d14:	fc06                	sd	ra,56(sp)
    80003d16:	f822                	sd	s0,48(sp)
    80003d18:	f426                	sd	s1,40(sp)
    80003d1a:	f04a                	sd	s2,32(sp)
    80003d1c:	ec4e                	sd	s3,24(sp)
    80003d1e:	e852                	sd	s4,16(sp)
    80003d20:	e456                	sd	s5,8(sp)
    80003d22:	e05a                	sd	s6,0(sp)
    80003d24:	0080                	addi	s0,sp,64
    80003d26:	8b2a                	mv	s6,a0
    80003d28:	0001fa97          	auipc	s5,0x1f
    80003d2c:	b38a8a93          	addi	s5,s5,-1224 # 80022860 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d30:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003d32:	0001f997          	auipc	s3,0x1f
    80003d36:	afe98993          	addi	s3,s3,-1282 # 80022830 <log>
    80003d3a:	a829                	j	80003d54 <install_trans+0x4e>
    brelse(lbuf);
    80003d3c:	854a                	mv	a0,s2
    80003d3e:	a2eff0ef          	jal	80002f6c <brelse>
    brelse(dbuf);
    80003d42:	8526                	mv	a0,s1
    80003d44:	a28ff0ef          	jal	80002f6c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d48:	2a05                	addiw	s4,s4,1
    80003d4a:	0a91                	addi	s5,s5,4
    80003d4c:	02c9a783          	lw	a5,44(s3)
    80003d50:	04fa5463          	bge	s4,a5,80003d98 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003d54:	0189a583          	lw	a1,24(s3)
    80003d58:	014585bb          	addw	a1,a1,s4
    80003d5c:	2585                	addiw	a1,a1,1
    80003d5e:	0289a503          	lw	a0,40(s3)
    80003d62:	902ff0ef          	jal	80002e64 <bread>
    80003d66:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003d68:	000aa583          	lw	a1,0(s5)
    80003d6c:	0289a503          	lw	a0,40(s3)
    80003d70:	8f4ff0ef          	jal	80002e64 <bread>
    80003d74:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003d76:	40000613          	li	a2,1024
    80003d7a:	05890593          	addi	a1,s2,88
    80003d7e:	05850513          	addi	a0,a0,88
    80003d82:	fa3fc0ef          	jal	80000d24 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003d86:	8526                	mv	a0,s1
    80003d88:	9b2ff0ef          	jal	80002f3a <bwrite>
    if(recovering == 0)
    80003d8c:	fa0b18e3          	bnez	s6,80003d3c <install_trans+0x36>
      bunpin(dbuf);
    80003d90:	8526                	mv	a0,s1
    80003d92:	a96ff0ef          	jal	80003028 <bunpin>
    80003d96:	b75d                	j	80003d3c <install_trans+0x36>
}
    80003d98:	70e2                	ld	ra,56(sp)
    80003d9a:	7442                	ld	s0,48(sp)
    80003d9c:	74a2                	ld	s1,40(sp)
    80003d9e:	7902                	ld	s2,32(sp)
    80003da0:	69e2                	ld	s3,24(sp)
    80003da2:	6a42                	ld	s4,16(sp)
    80003da4:	6aa2                	ld	s5,8(sp)
    80003da6:	6b02                	ld	s6,0(sp)
    80003da8:	6121                	addi	sp,sp,64
    80003daa:	8082                	ret
    80003dac:	8082                	ret

0000000080003dae <initlog>:
{
    80003dae:	7179                	addi	sp,sp,-48
    80003db0:	f406                	sd	ra,40(sp)
    80003db2:	f022                	sd	s0,32(sp)
    80003db4:	ec26                	sd	s1,24(sp)
    80003db6:	e84a                	sd	s2,16(sp)
    80003db8:	e44e                	sd	s3,8(sp)
    80003dba:	1800                	addi	s0,sp,48
    80003dbc:	892a                	mv	s2,a0
    80003dbe:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003dc0:	0001f497          	auipc	s1,0x1f
    80003dc4:	a7048493          	addi	s1,s1,-1424 # 80022830 <log>
    80003dc8:	00004597          	auipc	a1,0x4
    80003dcc:	b5058593          	addi	a1,a1,-1200 # 80007918 <etext+0x918>
    80003dd0:	8526                	mv	a0,s1
    80003dd2:	da3fc0ef          	jal	80000b74 <initlock>
  log.start = sb->logstart;
    80003dd6:	0149a583          	lw	a1,20(s3)
    80003dda:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003ddc:	0109a783          	lw	a5,16(s3)
    80003de0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003de2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003de6:	854a                	mv	a0,s2
    80003de8:	87cff0ef          	jal	80002e64 <bread>
  log.lh.n = lh->n;
    80003dec:	4d30                	lw	a2,88(a0)
    80003dee:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003df0:	00c05f63          	blez	a2,80003e0e <initlog+0x60>
    80003df4:	87aa                	mv	a5,a0
    80003df6:	0001f717          	auipc	a4,0x1f
    80003dfa:	a6a70713          	addi	a4,a4,-1430 # 80022860 <log+0x30>
    80003dfe:	060a                	slli	a2,a2,0x2
    80003e00:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003e02:	4ff4                	lw	a3,92(a5)
    80003e04:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003e06:	0791                	addi	a5,a5,4
    80003e08:	0711                	addi	a4,a4,4
    80003e0a:	fec79ce3          	bne	a5,a2,80003e02 <initlog+0x54>
  brelse(buf);
    80003e0e:	95eff0ef          	jal	80002f6c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003e12:	4505                	li	a0,1
    80003e14:	ef3ff0ef          	jal	80003d06 <install_trans>
  log.lh.n = 0;
    80003e18:	0001f797          	auipc	a5,0x1f
    80003e1c:	a407a223          	sw	zero,-1468(a5) # 8002285c <log+0x2c>
  write_head(); // clear the log
    80003e20:	e89ff0ef          	jal	80003ca8 <write_head>
}
    80003e24:	70a2                	ld	ra,40(sp)
    80003e26:	7402                	ld	s0,32(sp)
    80003e28:	64e2                	ld	s1,24(sp)
    80003e2a:	6942                	ld	s2,16(sp)
    80003e2c:	69a2                	ld	s3,8(sp)
    80003e2e:	6145                	addi	sp,sp,48
    80003e30:	8082                	ret

0000000080003e32 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003e32:	1101                	addi	sp,sp,-32
    80003e34:	ec06                	sd	ra,24(sp)
    80003e36:	e822                	sd	s0,16(sp)
    80003e38:	e426                	sd	s1,8(sp)
    80003e3a:	e04a                	sd	s2,0(sp)
    80003e3c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003e3e:	0001f517          	auipc	a0,0x1f
    80003e42:	9f250513          	addi	a0,a0,-1550 # 80022830 <log>
    80003e46:	daffc0ef          	jal	80000bf4 <acquire>
  while(1){
    if(log.committing){
    80003e4a:	0001f497          	auipc	s1,0x1f
    80003e4e:	9e648493          	addi	s1,s1,-1562 # 80022830 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003e52:	4979                	li	s2,30
    80003e54:	a029                	j	80003e5e <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003e56:	85a6                	mv	a1,s1
    80003e58:	8526                	mv	a0,s1
    80003e5a:	854fe0ef          	jal	80001eae <sleep>
    if(log.committing){
    80003e5e:	50dc                	lw	a5,36(s1)
    80003e60:	fbfd                	bnez	a5,80003e56 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003e62:	5098                	lw	a4,32(s1)
    80003e64:	2705                	addiw	a4,a4,1
    80003e66:	0027179b          	slliw	a5,a4,0x2
    80003e6a:	9fb9                	addw	a5,a5,a4
    80003e6c:	0017979b          	slliw	a5,a5,0x1
    80003e70:	54d4                	lw	a3,44(s1)
    80003e72:	9fb5                	addw	a5,a5,a3
    80003e74:	00f95763          	bge	s2,a5,80003e82 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003e78:	85a6                	mv	a1,s1
    80003e7a:	8526                	mv	a0,s1
    80003e7c:	832fe0ef          	jal	80001eae <sleep>
    80003e80:	bff9                	j	80003e5e <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003e82:	0001f517          	auipc	a0,0x1f
    80003e86:	9ae50513          	addi	a0,a0,-1618 # 80022830 <log>
    80003e8a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003e8c:	e01fc0ef          	jal	80000c8c <release>
      break;
    }
  }
}
    80003e90:	60e2                	ld	ra,24(sp)
    80003e92:	6442                	ld	s0,16(sp)
    80003e94:	64a2                	ld	s1,8(sp)
    80003e96:	6902                	ld	s2,0(sp)
    80003e98:	6105                	addi	sp,sp,32
    80003e9a:	8082                	ret

0000000080003e9c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003e9c:	7139                	addi	sp,sp,-64
    80003e9e:	fc06                	sd	ra,56(sp)
    80003ea0:	f822                	sd	s0,48(sp)
    80003ea2:	f426                	sd	s1,40(sp)
    80003ea4:	f04a                	sd	s2,32(sp)
    80003ea6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003ea8:	0001f497          	auipc	s1,0x1f
    80003eac:	98848493          	addi	s1,s1,-1656 # 80022830 <log>
    80003eb0:	8526                	mv	a0,s1
    80003eb2:	d43fc0ef          	jal	80000bf4 <acquire>
  log.outstanding -= 1;
    80003eb6:	509c                	lw	a5,32(s1)
    80003eb8:	37fd                	addiw	a5,a5,-1
    80003eba:	0007891b          	sext.w	s2,a5
    80003ebe:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003ec0:	50dc                	lw	a5,36(s1)
    80003ec2:	ef9d                	bnez	a5,80003f00 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003ec4:	04091763          	bnez	s2,80003f12 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003ec8:	0001f497          	auipc	s1,0x1f
    80003ecc:	96848493          	addi	s1,s1,-1688 # 80022830 <log>
    80003ed0:	4785                	li	a5,1
    80003ed2:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003ed4:	8526                	mv	a0,s1
    80003ed6:	db7fc0ef          	jal	80000c8c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003eda:	54dc                	lw	a5,44(s1)
    80003edc:	04f04b63          	bgtz	a5,80003f32 <end_op+0x96>
    acquire(&log.lock);
    80003ee0:	0001f497          	auipc	s1,0x1f
    80003ee4:	95048493          	addi	s1,s1,-1712 # 80022830 <log>
    80003ee8:	8526                	mv	a0,s1
    80003eea:	d0bfc0ef          	jal	80000bf4 <acquire>
    log.committing = 0;
    80003eee:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003ef2:	8526                	mv	a0,s1
    80003ef4:	806fe0ef          	jal	80001efa <wakeup>
    release(&log.lock);
    80003ef8:	8526                	mv	a0,s1
    80003efa:	d93fc0ef          	jal	80000c8c <release>
}
    80003efe:	a025                	j	80003f26 <end_op+0x8a>
    80003f00:	ec4e                	sd	s3,24(sp)
    80003f02:	e852                	sd	s4,16(sp)
    80003f04:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003f06:	00004517          	auipc	a0,0x4
    80003f0a:	a1a50513          	addi	a0,a0,-1510 # 80007920 <etext+0x920>
    80003f0e:	887fc0ef          	jal	80000794 <panic>
    wakeup(&log);
    80003f12:	0001f497          	auipc	s1,0x1f
    80003f16:	91e48493          	addi	s1,s1,-1762 # 80022830 <log>
    80003f1a:	8526                	mv	a0,s1
    80003f1c:	fdffd0ef          	jal	80001efa <wakeup>
  release(&log.lock);
    80003f20:	8526                	mv	a0,s1
    80003f22:	d6bfc0ef          	jal	80000c8c <release>
}
    80003f26:	70e2                	ld	ra,56(sp)
    80003f28:	7442                	ld	s0,48(sp)
    80003f2a:	74a2                	ld	s1,40(sp)
    80003f2c:	7902                	ld	s2,32(sp)
    80003f2e:	6121                	addi	sp,sp,64
    80003f30:	8082                	ret
    80003f32:	ec4e                	sd	s3,24(sp)
    80003f34:	e852                	sd	s4,16(sp)
    80003f36:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f38:	0001fa97          	auipc	s5,0x1f
    80003f3c:	928a8a93          	addi	s5,s5,-1752 # 80022860 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003f40:	0001fa17          	auipc	s4,0x1f
    80003f44:	8f0a0a13          	addi	s4,s4,-1808 # 80022830 <log>
    80003f48:	018a2583          	lw	a1,24(s4)
    80003f4c:	012585bb          	addw	a1,a1,s2
    80003f50:	2585                	addiw	a1,a1,1
    80003f52:	028a2503          	lw	a0,40(s4)
    80003f56:	f0ffe0ef          	jal	80002e64 <bread>
    80003f5a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003f5c:	000aa583          	lw	a1,0(s5)
    80003f60:	028a2503          	lw	a0,40(s4)
    80003f64:	f01fe0ef          	jal	80002e64 <bread>
    80003f68:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003f6a:	40000613          	li	a2,1024
    80003f6e:	05850593          	addi	a1,a0,88
    80003f72:	05848513          	addi	a0,s1,88
    80003f76:	daffc0ef          	jal	80000d24 <memmove>
    bwrite(to);  // write the log
    80003f7a:	8526                	mv	a0,s1
    80003f7c:	fbffe0ef          	jal	80002f3a <bwrite>
    brelse(from);
    80003f80:	854e                	mv	a0,s3
    80003f82:	febfe0ef          	jal	80002f6c <brelse>
    brelse(to);
    80003f86:	8526                	mv	a0,s1
    80003f88:	fe5fe0ef          	jal	80002f6c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f8c:	2905                	addiw	s2,s2,1
    80003f8e:	0a91                	addi	s5,s5,4
    80003f90:	02ca2783          	lw	a5,44(s4)
    80003f94:	faf94ae3          	blt	s2,a5,80003f48 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003f98:	d11ff0ef          	jal	80003ca8 <write_head>
    install_trans(0); // Now install writes to home locations
    80003f9c:	4501                	li	a0,0
    80003f9e:	d69ff0ef          	jal	80003d06 <install_trans>
    log.lh.n = 0;
    80003fa2:	0001f797          	auipc	a5,0x1f
    80003fa6:	8a07ad23          	sw	zero,-1862(a5) # 8002285c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003faa:	cffff0ef          	jal	80003ca8 <write_head>
    80003fae:	69e2                	ld	s3,24(sp)
    80003fb0:	6a42                	ld	s4,16(sp)
    80003fb2:	6aa2                	ld	s5,8(sp)
    80003fb4:	b735                	j	80003ee0 <end_op+0x44>

0000000080003fb6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003fb6:	1101                	addi	sp,sp,-32
    80003fb8:	ec06                	sd	ra,24(sp)
    80003fba:	e822                	sd	s0,16(sp)
    80003fbc:	e426                	sd	s1,8(sp)
    80003fbe:	e04a                	sd	s2,0(sp)
    80003fc0:	1000                	addi	s0,sp,32
    80003fc2:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003fc4:	0001f917          	auipc	s2,0x1f
    80003fc8:	86c90913          	addi	s2,s2,-1940 # 80022830 <log>
    80003fcc:	854a                	mv	a0,s2
    80003fce:	c27fc0ef          	jal	80000bf4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003fd2:	02c92603          	lw	a2,44(s2)
    80003fd6:	47f5                	li	a5,29
    80003fd8:	06c7c363          	blt	a5,a2,8000403e <log_write+0x88>
    80003fdc:	0001f797          	auipc	a5,0x1f
    80003fe0:	8707a783          	lw	a5,-1936(a5) # 8002284c <log+0x1c>
    80003fe4:	37fd                	addiw	a5,a5,-1
    80003fe6:	04f65c63          	bge	a2,a5,8000403e <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003fea:	0001f797          	auipc	a5,0x1f
    80003fee:	8667a783          	lw	a5,-1946(a5) # 80022850 <log+0x20>
    80003ff2:	04f05c63          	blez	a5,8000404a <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003ff6:	4781                	li	a5,0
    80003ff8:	04c05f63          	blez	a2,80004056 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003ffc:	44cc                	lw	a1,12(s1)
    80003ffe:	0001f717          	auipc	a4,0x1f
    80004002:	86270713          	addi	a4,a4,-1950 # 80022860 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004006:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004008:	4314                	lw	a3,0(a4)
    8000400a:	04b68663          	beq	a3,a1,80004056 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    8000400e:	2785                	addiw	a5,a5,1
    80004010:	0711                	addi	a4,a4,4
    80004012:	fef61be3          	bne	a2,a5,80004008 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004016:	0621                	addi	a2,a2,8
    80004018:	060a                	slli	a2,a2,0x2
    8000401a:	0001f797          	auipc	a5,0x1f
    8000401e:	81678793          	addi	a5,a5,-2026 # 80022830 <log>
    80004022:	97b2                	add	a5,a5,a2
    80004024:	44d8                	lw	a4,12(s1)
    80004026:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004028:	8526                	mv	a0,s1
    8000402a:	fcbfe0ef          	jal	80002ff4 <bpin>
    log.lh.n++;
    8000402e:	0001f717          	auipc	a4,0x1f
    80004032:	80270713          	addi	a4,a4,-2046 # 80022830 <log>
    80004036:	575c                	lw	a5,44(a4)
    80004038:	2785                	addiw	a5,a5,1
    8000403a:	d75c                	sw	a5,44(a4)
    8000403c:	a80d                	j	8000406e <log_write+0xb8>
    panic("too big a transaction");
    8000403e:	00004517          	auipc	a0,0x4
    80004042:	8f250513          	addi	a0,a0,-1806 # 80007930 <etext+0x930>
    80004046:	f4efc0ef          	jal	80000794 <panic>
    panic("log_write outside of trans");
    8000404a:	00004517          	auipc	a0,0x4
    8000404e:	8fe50513          	addi	a0,a0,-1794 # 80007948 <etext+0x948>
    80004052:	f42fc0ef          	jal	80000794 <panic>
  log.lh.block[i] = b->blockno;
    80004056:	00878693          	addi	a3,a5,8
    8000405a:	068a                	slli	a3,a3,0x2
    8000405c:	0001e717          	auipc	a4,0x1e
    80004060:	7d470713          	addi	a4,a4,2004 # 80022830 <log>
    80004064:	9736                	add	a4,a4,a3
    80004066:	44d4                	lw	a3,12(s1)
    80004068:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000406a:	faf60fe3          	beq	a2,a5,80004028 <log_write+0x72>
  }
  release(&log.lock);
    8000406e:	0001e517          	auipc	a0,0x1e
    80004072:	7c250513          	addi	a0,a0,1986 # 80022830 <log>
    80004076:	c17fc0ef          	jal	80000c8c <release>
}
    8000407a:	60e2                	ld	ra,24(sp)
    8000407c:	6442                	ld	s0,16(sp)
    8000407e:	64a2                	ld	s1,8(sp)
    80004080:	6902                	ld	s2,0(sp)
    80004082:	6105                	addi	sp,sp,32
    80004084:	8082                	ret

0000000080004086 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004086:	1101                	addi	sp,sp,-32
    80004088:	ec06                	sd	ra,24(sp)
    8000408a:	e822                	sd	s0,16(sp)
    8000408c:	e426                	sd	s1,8(sp)
    8000408e:	e04a                	sd	s2,0(sp)
    80004090:	1000                	addi	s0,sp,32
    80004092:	84aa                	mv	s1,a0
    80004094:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004096:	00004597          	auipc	a1,0x4
    8000409a:	8d258593          	addi	a1,a1,-1838 # 80007968 <etext+0x968>
    8000409e:	0521                	addi	a0,a0,8
    800040a0:	ad5fc0ef          	jal	80000b74 <initlock>
  lk->name = name;
    800040a4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800040a8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800040ac:	0204a423          	sw	zero,40(s1)
}
    800040b0:	60e2                	ld	ra,24(sp)
    800040b2:	6442                	ld	s0,16(sp)
    800040b4:	64a2                	ld	s1,8(sp)
    800040b6:	6902                	ld	s2,0(sp)
    800040b8:	6105                	addi	sp,sp,32
    800040ba:	8082                	ret

00000000800040bc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800040bc:	1101                	addi	sp,sp,-32
    800040be:	ec06                	sd	ra,24(sp)
    800040c0:	e822                	sd	s0,16(sp)
    800040c2:	e426                	sd	s1,8(sp)
    800040c4:	e04a                	sd	s2,0(sp)
    800040c6:	1000                	addi	s0,sp,32
    800040c8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800040ca:	00850913          	addi	s2,a0,8
    800040ce:	854a                	mv	a0,s2
    800040d0:	b25fc0ef          	jal	80000bf4 <acquire>
  while (lk->locked) {
    800040d4:	409c                	lw	a5,0(s1)
    800040d6:	c799                	beqz	a5,800040e4 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800040d8:	85ca                	mv	a1,s2
    800040da:	8526                	mv	a0,s1
    800040dc:	dd3fd0ef          	jal	80001eae <sleep>
  while (lk->locked) {
    800040e0:	409c                	lw	a5,0(s1)
    800040e2:	fbfd                	bnez	a5,800040d8 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800040e4:	4785                	li	a5,1
    800040e6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800040e8:	ff8fd0ef          	jal	800018e0 <myproc>
    800040ec:	591c                	lw	a5,48(a0)
    800040ee:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800040f0:	854a                	mv	a0,s2
    800040f2:	b9bfc0ef          	jal	80000c8c <release>
}
    800040f6:	60e2                	ld	ra,24(sp)
    800040f8:	6442                	ld	s0,16(sp)
    800040fa:	64a2                	ld	s1,8(sp)
    800040fc:	6902                	ld	s2,0(sp)
    800040fe:	6105                	addi	sp,sp,32
    80004100:	8082                	ret

0000000080004102 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004102:	1101                	addi	sp,sp,-32
    80004104:	ec06                	sd	ra,24(sp)
    80004106:	e822                	sd	s0,16(sp)
    80004108:	e426                	sd	s1,8(sp)
    8000410a:	e04a                	sd	s2,0(sp)
    8000410c:	1000                	addi	s0,sp,32
    8000410e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004110:	00850913          	addi	s2,a0,8
    80004114:	854a                	mv	a0,s2
    80004116:	adffc0ef          	jal	80000bf4 <acquire>
  lk->locked = 0;
    8000411a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000411e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004122:	8526                	mv	a0,s1
    80004124:	dd7fd0ef          	jal	80001efa <wakeup>
  release(&lk->lk);
    80004128:	854a                	mv	a0,s2
    8000412a:	b63fc0ef          	jal	80000c8c <release>
}
    8000412e:	60e2                	ld	ra,24(sp)
    80004130:	6442                	ld	s0,16(sp)
    80004132:	64a2                	ld	s1,8(sp)
    80004134:	6902                	ld	s2,0(sp)
    80004136:	6105                	addi	sp,sp,32
    80004138:	8082                	ret

000000008000413a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000413a:	7179                	addi	sp,sp,-48
    8000413c:	f406                	sd	ra,40(sp)
    8000413e:	f022                	sd	s0,32(sp)
    80004140:	ec26                	sd	s1,24(sp)
    80004142:	e84a                	sd	s2,16(sp)
    80004144:	1800                	addi	s0,sp,48
    80004146:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004148:	00850913          	addi	s2,a0,8
    8000414c:	854a                	mv	a0,s2
    8000414e:	aa7fc0ef          	jal	80000bf4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004152:	409c                	lw	a5,0(s1)
    80004154:	ef81                	bnez	a5,8000416c <holdingsleep+0x32>
    80004156:	4481                	li	s1,0
  release(&lk->lk);
    80004158:	854a                	mv	a0,s2
    8000415a:	b33fc0ef          	jal	80000c8c <release>
  return r;
}
    8000415e:	8526                	mv	a0,s1
    80004160:	70a2                	ld	ra,40(sp)
    80004162:	7402                	ld	s0,32(sp)
    80004164:	64e2                	ld	s1,24(sp)
    80004166:	6942                	ld	s2,16(sp)
    80004168:	6145                	addi	sp,sp,48
    8000416a:	8082                	ret
    8000416c:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000416e:	0284a983          	lw	s3,40(s1)
    80004172:	f6efd0ef          	jal	800018e0 <myproc>
    80004176:	5904                	lw	s1,48(a0)
    80004178:	413484b3          	sub	s1,s1,s3
    8000417c:	0014b493          	seqz	s1,s1
    80004180:	69a2                	ld	s3,8(sp)
    80004182:	bfd9                	j	80004158 <holdingsleep+0x1e>

0000000080004184 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004184:	1141                	addi	sp,sp,-16
    80004186:	e406                	sd	ra,8(sp)
    80004188:	e022                	sd	s0,0(sp)
    8000418a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000418c:	00003597          	auipc	a1,0x3
    80004190:	7ec58593          	addi	a1,a1,2028 # 80007978 <etext+0x978>
    80004194:	0001e517          	auipc	a0,0x1e
    80004198:	7e450513          	addi	a0,a0,2020 # 80022978 <ftable>
    8000419c:	9d9fc0ef          	jal	80000b74 <initlock>
}
    800041a0:	60a2                	ld	ra,8(sp)
    800041a2:	6402                	ld	s0,0(sp)
    800041a4:	0141                	addi	sp,sp,16
    800041a6:	8082                	ret

00000000800041a8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800041a8:	1101                	addi	sp,sp,-32
    800041aa:	ec06                	sd	ra,24(sp)
    800041ac:	e822                	sd	s0,16(sp)
    800041ae:	e426                	sd	s1,8(sp)
    800041b0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800041b2:	0001e517          	auipc	a0,0x1e
    800041b6:	7c650513          	addi	a0,a0,1990 # 80022978 <ftable>
    800041ba:	a3bfc0ef          	jal	80000bf4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800041be:	0001e497          	auipc	s1,0x1e
    800041c2:	7d248493          	addi	s1,s1,2002 # 80022990 <ftable+0x18>
    800041c6:	0001f717          	auipc	a4,0x1f
    800041ca:	76a70713          	addi	a4,a4,1898 # 80023930 <disk>
    if(f->ref == 0){
    800041ce:	40dc                	lw	a5,4(s1)
    800041d0:	cf89                	beqz	a5,800041ea <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800041d2:	02848493          	addi	s1,s1,40
    800041d6:	fee49ce3          	bne	s1,a4,800041ce <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800041da:	0001e517          	auipc	a0,0x1e
    800041de:	79e50513          	addi	a0,a0,1950 # 80022978 <ftable>
    800041e2:	aabfc0ef          	jal	80000c8c <release>
  return 0;
    800041e6:	4481                	li	s1,0
    800041e8:	a809                	j	800041fa <filealloc+0x52>
      f->ref = 1;
    800041ea:	4785                	li	a5,1
    800041ec:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800041ee:	0001e517          	auipc	a0,0x1e
    800041f2:	78a50513          	addi	a0,a0,1930 # 80022978 <ftable>
    800041f6:	a97fc0ef          	jal	80000c8c <release>
}
    800041fa:	8526                	mv	a0,s1
    800041fc:	60e2                	ld	ra,24(sp)
    800041fe:	6442                	ld	s0,16(sp)
    80004200:	64a2                	ld	s1,8(sp)
    80004202:	6105                	addi	sp,sp,32
    80004204:	8082                	ret

0000000080004206 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004206:	1101                	addi	sp,sp,-32
    80004208:	ec06                	sd	ra,24(sp)
    8000420a:	e822                	sd	s0,16(sp)
    8000420c:	e426                	sd	s1,8(sp)
    8000420e:	1000                	addi	s0,sp,32
    80004210:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004212:	0001e517          	auipc	a0,0x1e
    80004216:	76650513          	addi	a0,a0,1894 # 80022978 <ftable>
    8000421a:	9dbfc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    8000421e:	40dc                	lw	a5,4(s1)
    80004220:	02f05063          	blez	a5,80004240 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004224:	2785                	addiw	a5,a5,1
    80004226:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004228:	0001e517          	auipc	a0,0x1e
    8000422c:	75050513          	addi	a0,a0,1872 # 80022978 <ftable>
    80004230:	a5dfc0ef          	jal	80000c8c <release>
  return f;
}
    80004234:	8526                	mv	a0,s1
    80004236:	60e2                	ld	ra,24(sp)
    80004238:	6442                	ld	s0,16(sp)
    8000423a:	64a2                	ld	s1,8(sp)
    8000423c:	6105                	addi	sp,sp,32
    8000423e:	8082                	ret
    panic("filedup");
    80004240:	00003517          	auipc	a0,0x3
    80004244:	74050513          	addi	a0,a0,1856 # 80007980 <etext+0x980>
    80004248:	d4cfc0ef          	jal	80000794 <panic>

000000008000424c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000424c:	7139                	addi	sp,sp,-64
    8000424e:	fc06                	sd	ra,56(sp)
    80004250:	f822                	sd	s0,48(sp)
    80004252:	f426                	sd	s1,40(sp)
    80004254:	0080                	addi	s0,sp,64
    80004256:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004258:	0001e517          	auipc	a0,0x1e
    8000425c:	72050513          	addi	a0,a0,1824 # 80022978 <ftable>
    80004260:	995fc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    80004264:	40dc                	lw	a5,4(s1)
    80004266:	04f05a63          	blez	a5,800042ba <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    8000426a:	37fd                	addiw	a5,a5,-1
    8000426c:	0007871b          	sext.w	a4,a5
    80004270:	c0dc                	sw	a5,4(s1)
    80004272:	04e04e63          	bgtz	a4,800042ce <fileclose+0x82>
    80004276:	f04a                	sd	s2,32(sp)
    80004278:	ec4e                	sd	s3,24(sp)
    8000427a:	e852                	sd	s4,16(sp)
    8000427c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000427e:	0004a903          	lw	s2,0(s1)
    80004282:	0094ca83          	lbu	s5,9(s1)
    80004286:	0104ba03          	ld	s4,16(s1)
    8000428a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000428e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004292:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004296:	0001e517          	auipc	a0,0x1e
    8000429a:	6e250513          	addi	a0,a0,1762 # 80022978 <ftable>
    8000429e:	9effc0ef          	jal	80000c8c <release>

  if(ff.type == FD_PIPE){
    800042a2:	4785                	li	a5,1
    800042a4:	04f90063          	beq	s2,a5,800042e4 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800042a8:	3979                	addiw	s2,s2,-2
    800042aa:	4785                	li	a5,1
    800042ac:	0527f563          	bgeu	a5,s2,800042f6 <fileclose+0xaa>
    800042b0:	7902                	ld	s2,32(sp)
    800042b2:	69e2                	ld	s3,24(sp)
    800042b4:	6a42                	ld	s4,16(sp)
    800042b6:	6aa2                	ld	s5,8(sp)
    800042b8:	a00d                	j	800042da <fileclose+0x8e>
    800042ba:	f04a                	sd	s2,32(sp)
    800042bc:	ec4e                	sd	s3,24(sp)
    800042be:	e852                	sd	s4,16(sp)
    800042c0:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800042c2:	00003517          	auipc	a0,0x3
    800042c6:	6c650513          	addi	a0,a0,1734 # 80007988 <etext+0x988>
    800042ca:	ccafc0ef          	jal	80000794 <panic>
    release(&ftable.lock);
    800042ce:	0001e517          	auipc	a0,0x1e
    800042d2:	6aa50513          	addi	a0,a0,1706 # 80022978 <ftable>
    800042d6:	9b7fc0ef          	jal	80000c8c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800042da:	70e2                	ld	ra,56(sp)
    800042dc:	7442                	ld	s0,48(sp)
    800042de:	74a2                	ld	s1,40(sp)
    800042e0:	6121                	addi	sp,sp,64
    800042e2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800042e4:	85d6                	mv	a1,s5
    800042e6:	8552                	mv	a0,s4
    800042e8:	336000ef          	jal	8000461e <pipeclose>
    800042ec:	7902                	ld	s2,32(sp)
    800042ee:	69e2                	ld	s3,24(sp)
    800042f0:	6a42                	ld	s4,16(sp)
    800042f2:	6aa2                	ld	s5,8(sp)
    800042f4:	b7dd                	j	800042da <fileclose+0x8e>
    begin_op();
    800042f6:	b3dff0ef          	jal	80003e32 <begin_op>
    iput(ff.ip);
    800042fa:	854e                	mv	a0,s3
    800042fc:	c22ff0ef          	jal	8000371e <iput>
    end_op();
    80004300:	b9dff0ef          	jal	80003e9c <end_op>
    80004304:	7902                	ld	s2,32(sp)
    80004306:	69e2                	ld	s3,24(sp)
    80004308:	6a42                	ld	s4,16(sp)
    8000430a:	6aa2                	ld	s5,8(sp)
    8000430c:	b7f9                	j	800042da <fileclose+0x8e>

000000008000430e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000430e:	715d                	addi	sp,sp,-80
    80004310:	e486                	sd	ra,72(sp)
    80004312:	e0a2                	sd	s0,64(sp)
    80004314:	fc26                	sd	s1,56(sp)
    80004316:	f44e                	sd	s3,40(sp)
    80004318:	0880                	addi	s0,sp,80
    8000431a:	84aa                	mv	s1,a0
    8000431c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000431e:	dc2fd0ef          	jal	800018e0 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004322:	409c                	lw	a5,0(s1)
    80004324:	37f9                	addiw	a5,a5,-2
    80004326:	4705                	li	a4,1
    80004328:	04f76063          	bltu	a4,a5,80004368 <filestat+0x5a>
    8000432c:	f84a                	sd	s2,48(sp)
    8000432e:	892a                	mv	s2,a0
    ilock(f->ip);
    80004330:	6c88                	ld	a0,24(s1)
    80004332:	a6aff0ef          	jal	8000359c <ilock>
    stati(f->ip, &st);
    80004336:	fb840593          	addi	a1,s0,-72
    8000433a:	6c88                	ld	a0,24(s1)
    8000433c:	c8aff0ef          	jal	800037c6 <stati>
    iunlock(f->ip);
    80004340:	6c88                	ld	a0,24(s1)
    80004342:	b08ff0ef          	jal	8000364a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004346:	46e1                	li	a3,24
    80004348:	fb840613          	addi	a2,s0,-72
    8000434c:	85ce                	mv	a1,s3
    8000434e:	05093503          	ld	a0,80(s2)
    80004352:	a00fd0ef          	jal	80001552 <copyout>
    80004356:	41f5551b          	sraiw	a0,a0,0x1f
    8000435a:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000435c:	60a6                	ld	ra,72(sp)
    8000435e:	6406                	ld	s0,64(sp)
    80004360:	74e2                	ld	s1,56(sp)
    80004362:	79a2                	ld	s3,40(sp)
    80004364:	6161                	addi	sp,sp,80
    80004366:	8082                	ret
  return -1;
    80004368:	557d                	li	a0,-1
    8000436a:	bfcd                	j	8000435c <filestat+0x4e>

000000008000436c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000436c:	7179                	addi	sp,sp,-48
    8000436e:	f406                	sd	ra,40(sp)
    80004370:	f022                	sd	s0,32(sp)
    80004372:	e84a                	sd	s2,16(sp)
    80004374:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004376:	00854783          	lbu	a5,8(a0)
    8000437a:	cfd1                	beqz	a5,80004416 <fileread+0xaa>
    8000437c:	ec26                	sd	s1,24(sp)
    8000437e:	e44e                	sd	s3,8(sp)
    80004380:	84aa                	mv	s1,a0
    80004382:	89ae                	mv	s3,a1
    80004384:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004386:	411c                	lw	a5,0(a0)
    80004388:	4705                	li	a4,1
    8000438a:	04e78363          	beq	a5,a4,800043d0 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000438e:	470d                	li	a4,3
    80004390:	04e78763          	beq	a5,a4,800043de <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004394:	4709                	li	a4,2
    80004396:	06e79a63          	bne	a5,a4,8000440a <fileread+0x9e>
    ilock(f->ip);
    8000439a:	6d08                	ld	a0,24(a0)
    8000439c:	a00ff0ef          	jal	8000359c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800043a0:	874a                	mv	a4,s2
    800043a2:	5094                	lw	a3,32(s1)
    800043a4:	864e                	mv	a2,s3
    800043a6:	4585                	li	a1,1
    800043a8:	6c88                	ld	a0,24(s1)
    800043aa:	c46ff0ef          	jal	800037f0 <readi>
    800043ae:	892a                	mv	s2,a0
    800043b0:	00a05563          	blez	a0,800043ba <fileread+0x4e>
      f->off += r;
    800043b4:	509c                	lw	a5,32(s1)
    800043b6:	9fa9                	addw	a5,a5,a0
    800043b8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800043ba:	6c88                	ld	a0,24(s1)
    800043bc:	a8eff0ef          	jal	8000364a <iunlock>
    800043c0:	64e2                	ld	s1,24(sp)
    800043c2:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800043c4:	854a                	mv	a0,s2
    800043c6:	70a2                	ld	ra,40(sp)
    800043c8:	7402                	ld	s0,32(sp)
    800043ca:	6942                	ld	s2,16(sp)
    800043cc:	6145                	addi	sp,sp,48
    800043ce:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800043d0:	6908                	ld	a0,16(a0)
    800043d2:	388000ef          	jal	8000475a <piperead>
    800043d6:	892a                	mv	s2,a0
    800043d8:	64e2                	ld	s1,24(sp)
    800043da:	69a2                	ld	s3,8(sp)
    800043dc:	b7e5                	j	800043c4 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800043de:	02451783          	lh	a5,36(a0)
    800043e2:	03079693          	slli	a3,a5,0x30
    800043e6:	92c1                	srli	a3,a3,0x30
    800043e8:	4725                	li	a4,9
    800043ea:	02d76863          	bltu	a4,a3,8000441a <fileread+0xae>
    800043ee:	0792                	slli	a5,a5,0x4
    800043f0:	0001e717          	auipc	a4,0x1e
    800043f4:	4e870713          	addi	a4,a4,1256 # 800228d8 <devsw>
    800043f8:	97ba                	add	a5,a5,a4
    800043fa:	639c                	ld	a5,0(a5)
    800043fc:	c39d                	beqz	a5,80004422 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800043fe:	4505                	li	a0,1
    80004400:	9782                	jalr	a5
    80004402:	892a                	mv	s2,a0
    80004404:	64e2                	ld	s1,24(sp)
    80004406:	69a2                	ld	s3,8(sp)
    80004408:	bf75                	j	800043c4 <fileread+0x58>
    panic("fileread");
    8000440a:	00003517          	auipc	a0,0x3
    8000440e:	58e50513          	addi	a0,a0,1422 # 80007998 <etext+0x998>
    80004412:	b82fc0ef          	jal	80000794 <panic>
    return -1;
    80004416:	597d                	li	s2,-1
    80004418:	b775                	j	800043c4 <fileread+0x58>
      return -1;
    8000441a:	597d                	li	s2,-1
    8000441c:	64e2                	ld	s1,24(sp)
    8000441e:	69a2                	ld	s3,8(sp)
    80004420:	b755                	j	800043c4 <fileread+0x58>
    80004422:	597d                	li	s2,-1
    80004424:	64e2                	ld	s1,24(sp)
    80004426:	69a2                	ld	s3,8(sp)
    80004428:	bf71                	j	800043c4 <fileread+0x58>

000000008000442a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000442a:	00954783          	lbu	a5,9(a0)
    8000442e:	10078b63          	beqz	a5,80004544 <filewrite+0x11a>
{
    80004432:	715d                	addi	sp,sp,-80
    80004434:	e486                	sd	ra,72(sp)
    80004436:	e0a2                	sd	s0,64(sp)
    80004438:	f84a                	sd	s2,48(sp)
    8000443a:	f052                	sd	s4,32(sp)
    8000443c:	e85a                	sd	s6,16(sp)
    8000443e:	0880                	addi	s0,sp,80
    80004440:	892a                	mv	s2,a0
    80004442:	8b2e                	mv	s6,a1
    80004444:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004446:	411c                	lw	a5,0(a0)
    80004448:	4705                	li	a4,1
    8000444a:	02e78763          	beq	a5,a4,80004478 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000444e:	470d                	li	a4,3
    80004450:	02e78863          	beq	a5,a4,80004480 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004454:	4709                	li	a4,2
    80004456:	0ce79c63          	bne	a5,a4,8000452e <filewrite+0x104>
    8000445a:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000445c:	0ac05863          	blez	a2,8000450c <filewrite+0xe2>
    80004460:	fc26                	sd	s1,56(sp)
    80004462:	ec56                	sd	s5,24(sp)
    80004464:	e45e                	sd	s7,8(sp)
    80004466:	e062                	sd	s8,0(sp)
    int i = 0;
    80004468:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000446a:	6b85                	lui	s7,0x1
    8000446c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004470:	6c05                	lui	s8,0x1
    80004472:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004476:	a8b5                	j	800044f2 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80004478:	6908                	ld	a0,16(a0)
    8000447a:	1fc000ef          	jal	80004676 <pipewrite>
    8000447e:	a04d                	j	80004520 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004480:	02451783          	lh	a5,36(a0)
    80004484:	03079693          	slli	a3,a5,0x30
    80004488:	92c1                	srli	a3,a3,0x30
    8000448a:	4725                	li	a4,9
    8000448c:	0ad76e63          	bltu	a4,a3,80004548 <filewrite+0x11e>
    80004490:	0792                	slli	a5,a5,0x4
    80004492:	0001e717          	auipc	a4,0x1e
    80004496:	44670713          	addi	a4,a4,1094 # 800228d8 <devsw>
    8000449a:	97ba                	add	a5,a5,a4
    8000449c:	679c                	ld	a5,8(a5)
    8000449e:	c7dd                	beqz	a5,8000454c <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800044a0:	4505                	li	a0,1
    800044a2:	9782                	jalr	a5
    800044a4:	a8b5                	j	80004520 <filewrite+0xf6>
      if(n1 > max)
    800044a6:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800044aa:	989ff0ef          	jal	80003e32 <begin_op>
      ilock(f->ip);
    800044ae:	01893503          	ld	a0,24(s2)
    800044b2:	8eaff0ef          	jal	8000359c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800044b6:	8756                	mv	a4,s5
    800044b8:	02092683          	lw	a3,32(s2)
    800044bc:	01698633          	add	a2,s3,s6
    800044c0:	4585                	li	a1,1
    800044c2:	01893503          	ld	a0,24(s2)
    800044c6:	c26ff0ef          	jal	800038ec <writei>
    800044ca:	84aa                	mv	s1,a0
    800044cc:	00a05763          	blez	a0,800044da <filewrite+0xb0>
        f->off += r;
    800044d0:	02092783          	lw	a5,32(s2)
    800044d4:	9fa9                	addw	a5,a5,a0
    800044d6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800044da:	01893503          	ld	a0,24(s2)
    800044de:	96cff0ef          	jal	8000364a <iunlock>
      end_op();
    800044e2:	9bbff0ef          	jal	80003e9c <end_op>

      if(r != n1){
    800044e6:	029a9563          	bne	s5,s1,80004510 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800044ea:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800044ee:	0149da63          	bge	s3,s4,80004502 <filewrite+0xd8>
      int n1 = n - i;
    800044f2:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800044f6:	0004879b          	sext.w	a5,s1
    800044fa:	fafbd6e3          	bge	s7,a5,800044a6 <filewrite+0x7c>
    800044fe:	84e2                	mv	s1,s8
    80004500:	b75d                	j	800044a6 <filewrite+0x7c>
    80004502:	74e2                	ld	s1,56(sp)
    80004504:	6ae2                	ld	s5,24(sp)
    80004506:	6ba2                	ld	s7,8(sp)
    80004508:	6c02                	ld	s8,0(sp)
    8000450a:	a039                	j	80004518 <filewrite+0xee>
    int i = 0;
    8000450c:	4981                	li	s3,0
    8000450e:	a029                	j	80004518 <filewrite+0xee>
    80004510:	74e2                	ld	s1,56(sp)
    80004512:	6ae2                	ld	s5,24(sp)
    80004514:	6ba2                	ld	s7,8(sp)
    80004516:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004518:	033a1c63          	bne	s4,s3,80004550 <filewrite+0x126>
    8000451c:	8552                	mv	a0,s4
    8000451e:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004520:	60a6                	ld	ra,72(sp)
    80004522:	6406                	ld	s0,64(sp)
    80004524:	7942                	ld	s2,48(sp)
    80004526:	7a02                	ld	s4,32(sp)
    80004528:	6b42                	ld	s6,16(sp)
    8000452a:	6161                	addi	sp,sp,80
    8000452c:	8082                	ret
    8000452e:	fc26                	sd	s1,56(sp)
    80004530:	f44e                	sd	s3,40(sp)
    80004532:	ec56                	sd	s5,24(sp)
    80004534:	e45e                	sd	s7,8(sp)
    80004536:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004538:	00003517          	auipc	a0,0x3
    8000453c:	47050513          	addi	a0,a0,1136 # 800079a8 <etext+0x9a8>
    80004540:	a54fc0ef          	jal	80000794 <panic>
    return -1;
    80004544:	557d                	li	a0,-1
}
    80004546:	8082                	ret
      return -1;
    80004548:	557d                	li	a0,-1
    8000454a:	bfd9                	j	80004520 <filewrite+0xf6>
    8000454c:	557d                	li	a0,-1
    8000454e:	bfc9                	j	80004520 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80004550:	557d                	li	a0,-1
    80004552:	79a2                	ld	s3,40(sp)
    80004554:	b7f1                	j	80004520 <filewrite+0xf6>

0000000080004556 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004556:	7179                	addi	sp,sp,-48
    80004558:	f406                	sd	ra,40(sp)
    8000455a:	f022                	sd	s0,32(sp)
    8000455c:	ec26                	sd	s1,24(sp)
    8000455e:	e052                	sd	s4,0(sp)
    80004560:	1800                	addi	s0,sp,48
    80004562:	84aa                	mv	s1,a0
    80004564:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004566:	0005b023          	sd	zero,0(a1)
    8000456a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000456e:	c3bff0ef          	jal	800041a8 <filealloc>
    80004572:	e088                	sd	a0,0(s1)
    80004574:	c549                	beqz	a0,800045fe <pipealloc+0xa8>
    80004576:	c33ff0ef          	jal	800041a8 <filealloc>
    8000457a:	00aa3023          	sd	a0,0(s4)
    8000457e:	cd25                	beqz	a0,800045f6 <pipealloc+0xa0>
    80004580:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004582:	da2fc0ef          	jal	80000b24 <kalloc>
    80004586:	892a                	mv	s2,a0
    80004588:	c12d                	beqz	a0,800045ea <pipealloc+0x94>
    8000458a:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000458c:	4985                	li	s3,1
    8000458e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004592:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004596:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000459a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000459e:	00003597          	auipc	a1,0x3
    800045a2:	41a58593          	addi	a1,a1,1050 # 800079b8 <etext+0x9b8>
    800045a6:	dcefc0ef          	jal	80000b74 <initlock>
  (*f0)->type = FD_PIPE;
    800045aa:	609c                	ld	a5,0(s1)
    800045ac:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800045b0:	609c                	ld	a5,0(s1)
    800045b2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800045b6:	609c                	ld	a5,0(s1)
    800045b8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800045bc:	609c                	ld	a5,0(s1)
    800045be:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800045c2:	000a3783          	ld	a5,0(s4)
    800045c6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800045ca:	000a3783          	ld	a5,0(s4)
    800045ce:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800045d2:	000a3783          	ld	a5,0(s4)
    800045d6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800045da:	000a3783          	ld	a5,0(s4)
    800045de:	0127b823          	sd	s2,16(a5)
  return 0;
    800045e2:	4501                	li	a0,0
    800045e4:	6942                	ld	s2,16(sp)
    800045e6:	69a2                	ld	s3,8(sp)
    800045e8:	a01d                	j	8000460e <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800045ea:	6088                	ld	a0,0(s1)
    800045ec:	c119                	beqz	a0,800045f2 <pipealloc+0x9c>
    800045ee:	6942                	ld	s2,16(sp)
    800045f0:	a029                	j	800045fa <pipealloc+0xa4>
    800045f2:	6942                	ld	s2,16(sp)
    800045f4:	a029                	j	800045fe <pipealloc+0xa8>
    800045f6:	6088                	ld	a0,0(s1)
    800045f8:	c10d                	beqz	a0,8000461a <pipealloc+0xc4>
    fileclose(*f0);
    800045fa:	c53ff0ef          	jal	8000424c <fileclose>
  if(*f1)
    800045fe:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004602:	557d                	li	a0,-1
  if(*f1)
    80004604:	c789                	beqz	a5,8000460e <pipealloc+0xb8>
    fileclose(*f1);
    80004606:	853e                	mv	a0,a5
    80004608:	c45ff0ef          	jal	8000424c <fileclose>
  return -1;
    8000460c:	557d                	li	a0,-1
}
    8000460e:	70a2                	ld	ra,40(sp)
    80004610:	7402                	ld	s0,32(sp)
    80004612:	64e2                	ld	s1,24(sp)
    80004614:	6a02                	ld	s4,0(sp)
    80004616:	6145                	addi	sp,sp,48
    80004618:	8082                	ret
  return -1;
    8000461a:	557d                	li	a0,-1
    8000461c:	bfcd                	j	8000460e <pipealloc+0xb8>

000000008000461e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000461e:	1101                	addi	sp,sp,-32
    80004620:	ec06                	sd	ra,24(sp)
    80004622:	e822                	sd	s0,16(sp)
    80004624:	e426                	sd	s1,8(sp)
    80004626:	e04a                	sd	s2,0(sp)
    80004628:	1000                	addi	s0,sp,32
    8000462a:	84aa                	mv	s1,a0
    8000462c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000462e:	dc6fc0ef          	jal	80000bf4 <acquire>
  if(writable){
    80004632:	02090763          	beqz	s2,80004660 <pipeclose+0x42>
    pi->writeopen = 0;
    80004636:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000463a:	21848513          	addi	a0,s1,536
    8000463e:	8bdfd0ef          	jal	80001efa <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004642:	2204b783          	ld	a5,544(s1)
    80004646:	e785                	bnez	a5,8000466e <pipeclose+0x50>
    release(&pi->lock);
    80004648:	8526                	mv	a0,s1
    8000464a:	e42fc0ef          	jal	80000c8c <release>
    kfree((char*)pi);
    8000464e:	8526                	mv	a0,s1
    80004650:	bf2fc0ef          	jal	80000a42 <kfree>
  } else
    release(&pi->lock);
}
    80004654:	60e2                	ld	ra,24(sp)
    80004656:	6442                	ld	s0,16(sp)
    80004658:	64a2                	ld	s1,8(sp)
    8000465a:	6902                	ld	s2,0(sp)
    8000465c:	6105                	addi	sp,sp,32
    8000465e:	8082                	ret
    pi->readopen = 0;
    80004660:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004664:	21c48513          	addi	a0,s1,540
    80004668:	893fd0ef          	jal	80001efa <wakeup>
    8000466c:	bfd9                	j	80004642 <pipeclose+0x24>
    release(&pi->lock);
    8000466e:	8526                	mv	a0,s1
    80004670:	e1cfc0ef          	jal	80000c8c <release>
}
    80004674:	b7c5                	j	80004654 <pipeclose+0x36>

0000000080004676 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004676:	711d                	addi	sp,sp,-96
    80004678:	ec86                	sd	ra,88(sp)
    8000467a:	e8a2                	sd	s0,80(sp)
    8000467c:	e4a6                	sd	s1,72(sp)
    8000467e:	e0ca                	sd	s2,64(sp)
    80004680:	fc4e                	sd	s3,56(sp)
    80004682:	f852                	sd	s4,48(sp)
    80004684:	f456                	sd	s5,40(sp)
    80004686:	1080                	addi	s0,sp,96
    80004688:	84aa                	mv	s1,a0
    8000468a:	8aae                	mv	s5,a1
    8000468c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000468e:	a52fd0ef          	jal	800018e0 <myproc>
    80004692:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004694:	8526                	mv	a0,s1
    80004696:	d5efc0ef          	jal	80000bf4 <acquire>
  while(i < n){
    8000469a:	0b405a63          	blez	s4,8000474e <pipewrite+0xd8>
    8000469e:	f05a                	sd	s6,32(sp)
    800046a0:	ec5e                	sd	s7,24(sp)
    800046a2:	e862                	sd	s8,16(sp)
  int i = 0;
    800046a4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800046a6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800046a8:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800046ac:	21c48b93          	addi	s7,s1,540
    800046b0:	a81d                	j	800046e6 <pipewrite+0x70>
      release(&pi->lock);
    800046b2:	8526                	mv	a0,s1
    800046b4:	dd8fc0ef          	jal	80000c8c <release>
      return -1;
    800046b8:	597d                	li	s2,-1
    800046ba:	7b02                	ld	s6,32(sp)
    800046bc:	6be2                	ld	s7,24(sp)
    800046be:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800046c0:	854a                	mv	a0,s2
    800046c2:	60e6                	ld	ra,88(sp)
    800046c4:	6446                	ld	s0,80(sp)
    800046c6:	64a6                	ld	s1,72(sp)
    800046c8:	6906                	ld	s2,64(sp)
    800046ca:	79e2                	ld	s3,56(sp)
    800046cc:	7a42                	ld	s4,48(sp)
    800046ce:	7aa2                	ld	s5,40(sp)
    800046d0:	6125                	addi	sp,sp,96
    800046d2:	8082                	ret
      wakeup(&pi->nread);
    800046d4:	8562                	mv	a0,s8
    800046d6:	825fd0ef          	jal	80001efa <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800046da:	85a6                	mv	a1,s1
    800046dc:	855e                	mv	a0,s7
    800046de:	fd0fd0ef          	jal	80001eae <sleep>
  while(i < n){
    800046e2:	05495b63          	bge	s2,s4,80004738 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800046e6:	2204a783          	lw	a5,544(s1)
    800046ea:	d7e1                	beqz	a5,800046b2 <pipewrite+0x3c>
    800046ec:	854e                	mv	a0,s3
    800046ee:	9f9fd0ef          	jal	800020e6 <killed>
    800046f2:	f161                	bnez	a0,800046b2 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800046f4:	2184a783          	lw	a5,536(s1)
    800046f8:	21c4a703          	lw	a4,540(s1)
    800046fc:	2007879b          	addiw	a5,a5,512
    80004700:	fcf70ae3          	beq	a4,a5,800046d4 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004704:	4685                	li	a3,1
    80004706:	01590633          	add	a2,s2,s5
    8000470a:	faf40593          	addi	a1,s0,-81
    8000470e:	0509b503          	ld	a0,80(s3)
    80004712:	f17fc0ef          	jal	80001628 <copyin>
    80004716:	03650e63          	beq	a0,s6,80004752 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000471a:	21c4a783          	lw	a5,540(s1)
    8000471e:	0017871b          	addiw	a4,a5,1
    80004722:	20e4ae23          	sw	a4,540(s1)
    80004726:	1ff7f793          	andi	a5,a5,511
    8000472a:	97a6                	add	a5,a5,s1
    8000472c:	faf44703          	lbu	a4,-81(s0)
    80004730:	00e78c23          	sb	a4,24(a5)
      i++;
    80004734:	2905                	addiw	s2,s2,1
    80004736:	b775                	j	800046e2 <pipewrite+0x6c>
    80004738:	7b02                	ld	s6,32(sp)
    8000473a:	6be2                	ld	s7,24(sp)
    8000473c:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000473e:	21848513          	addi	a0,s1,536
    80004742:	fb8fd0ef          	jal	80001efa <wakeup>
  release(&pi->lock);
    80004746:	8526                	mv	a0,s1
    80004748:	d44fc0ef          	jal	80000c8c <release>
  return i;
    8000474c:	bf95                	j	800046c0 <pipewrite+0x4a>
  int i = 0;
    8000474e:	4901                	li	s2,0
    80004750:	b7fd                	j	8000473e <pipewrite+0xc8>
    80004752:	7b02                	ld	s6,32(sp)
    80004754:	6be2                	ld	s7,24(sp)
    80004756:	6c42                	ld	s8,16(sp)
    80004758:	b7dd                	j	8000473e <pipewrite+0xc8>

000000008000475a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000475a:	715d                	addi	sp,sp,-80
    8000475c:	e486                	sd	ra,72(sp)
    8000475e:	e0a2                	sd	s0,64(sp)
    80004760:	fc26                	sd	s1,56(sp)
    80004762:	f84a                	sd	s2,48(sp)
    80004764:	f44e                	sd	s3,40(sp)
    80004766:	f052                	sd	s4,32(sp)
    80004768:	ec56                	sd	s5,24(sp)
    8000476a:	0880                	addi	s0,sp,80
    8000476c:	84aa                	mv	s1,a0
    8000476e:	892e                	mv	s2,a1
    80004770:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004772:	96efd0ef          	jal	800018e0 <myproc>
    80004776:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004778:	8526                	mv	a0,s1
    8000477a:	c7afc0ef          	jal	80000bf4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000477e:	2184a703          	lw	a4,536(s1)
    80004782:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004786:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000478a:	02f71563          	bne	a4,a5,800047b4 <piperead+0x5a>
    8000478e:	2244a783          	lw	a5,548(s1)
    80004792:	cb85                	beqz	a5,800047c2 <piperead+0x68>
    if(killed(pr)){
    80004794:	8552                	mv	a0,s4
    80004796:	951fd0ef          	jal	800020e6 <killed>
    8000479a:	ed19                	bnez	a0,800047b8 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000479c:	85a6                	mv	a1,s1
    8000479e:	854e                	mv	a0,s3
    800047a0:	f0efd0ef          	jal	80001eae <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800047a4:	2184a703          	lw	a4,536(s1)
    800047a8:	21c4a783          	lw	a5,540(s1)
    800047ac:	fef701e3          	beq	a4,a5,8000478e <piperead+0x34>
    800047b0:	e85a                	sd	s6,16(sp)
    800047b2:	a809                	j	800047c4 <piperead+0x6a>
    800047b4:	e85a                	sd	s6,16(sp)
    800047b6:	a039                	j	800047c4 <piperead+0x6a>
      release(&pi->lock);
    800047b8:	8526                	mv	a0,s1
    800047ba:	cd2fc0ef          	jal	80000c8c <release>
      return -1;
    800047be:	59fd                	li	s3,-1
    800047c0:	a8b1                	j	8000481c <piperead+0xc2>
    800047c2:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800047c4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800047c6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800047c8:	05505263          	blez	s5,8000480c <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800047cc:	2184a783          	lw	a5,536(s1)
    800047d0:	21c4a703          	lw	a4,540(s1)
    800047d4:	02f70c63          	beq	a4,a5,8000480c <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800047d8:	0017871b          	addiw	a4,a5,1
    800047dc:	20e4ac23          	sw	a4,536(s1)
    800047e0:	1ff7f793          	andi	a5,a5,511
    800047e4:	97a6                	add	a5,a5,s1
    800047e6:	0187c783          	lbu	a5,24(a5)
    800047ea:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800047ee:	4685                	li	a3,1
    800047f0:	fbf40613          	addi	a2,s0,-65
    800047f4:	85ca                	mv	a1,s2
    800047f6:	050a3503          	ld	a0,80(s4)
    800047fa:	d59fc0ef          	jal	80001552 <copyout>
    800047fe:	01650763          	beq	a0,s6,8000480c <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004802:	2985                	addiw	s3,s3,1
    80004804:	0905                	addi	s2,s2,1
    80004806:	fd3a93e3          	bne	s5,s3,800047cc <piperead+0x72>
    8000480a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000480c:	21c48513          	addi	a0,s1,540
    80004810:	eeafd0ef          	jal	80001efa <wakeup>
  release(&pi->lock);
    80004814:	8526                	mv	a0,s1
    80004816:	c76fc0ef          	jal	80000c8c <release>
    8000481a:	6b42                	ld	s6,16(sp)
  return i;
}
    8000481c:	854e                	mv	a0,s3
    8000481e:	60a6                	ld	ra,72(sp)
    80004820:	6406                	ld	s0,64(sp)
    80004822:	74e2                	ld	s1,56(sp)
    80004824:	7942                	ld	s2,48(sp)
    80004826:	79a2                	ld	s3,40(sp)
    80004828:	7a02                	ld	s4,32(sp)
    8000482a:	6ae2                	ld	s5,24(sp)
    8000482c:	6161                	addi	sp,sp,80
    8000482e:	8082                	ret

0000000080004830 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004830:	1141                	addi	sp,sp,-16
    80004832:	e422                	sd	s0,8(sp)
    80004834:	0800                	addi	s0,sp,16
    80004836:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004838:	8905                	andi	a0,a0,1
    8000483a:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000483c:	8b89                	andi	a5,a5,2
    8000483e:	c399                	beqz	a5,80004844 <flags2perm+0x14>
      perm |= PTE_W;
    80004840:	00456513          	ori	a0,a0,4
    return perm;
}
    80004844:	6422                	ld	s0,8(sp)
    80004846:	0141                	addi	sp,sp,16
    80004848:	8082                	ret

000000008000484a <exec>:

int
exec(char *path, char **argv)
{
    8000484a:	df010113          	addi	sp,sp,-528
    8000484e:	20113423          	sd	ra,520(sp)
    80004852:	20813023          	sd	s0,512(sp)
    80004856:	ffa6                	sd	s1,504(sp)
    80004858:	fbca                	sd	s2,496(sp)
    8000485a:	0c00                	addi	s0,sp,528
    8000485c:	892a                	mv	s2,a0
    8000485e:	dea43c23          	sd	a0,-520(s0)
    80004862:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004866:	87afd0ef          	jal	800018e0 <myproc>
    8000486a:	84aa                	mv	s1,a0

  begin_op();
    8000486c:	dc6ff0ef          	jal	80003e32 <begin_op>

  if((ip = namei(path)) == 0){
    80004870:	854a                	mv	a0,s2
    80004872:	c04ff0ef          	jal	80003c76 <namei>
    80004876:	c931                	beqz	a0,800048ca <exec+0x80>
    80004878:	f3d2                	sd	s4,480(sp)
    8000487a:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000487c:	d21fe0ef          	jal	8000359c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004880:	04000713          	li	a4,64
    80004884:	4681                	li	a3,0
    80004886:	e5040613          	addi	a2,s0,-432
    8000488a:	4581                	li	a1,0
    8000488c:	8552                	mv	a0,s4
    8000488e:	f63fe0ef          	jal	800037f0 <readi>
    80004892:	04000793          	li	a5,64
    80004896:	00f51a63          	bne	a0,a5,800048aa <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000489a:	e5042703          	lw	a4,-432(s0)
    8000489e:	464c47b7          	lui	a5,0x464c4
    800048a2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800048a6:	02f70663          	beq	a4,a5,800048d2 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800048aa:	8552                	mv	a0,s4
    800048ac:	efbfe0ef          	jal	800037a6 <iunlockput>
    end_op();
    800048b0:	decff0ef          	jal	80003e9c <end_op>
  }
  return -1;
    800048b4:	557d                	li	a0,-1
    800048b6:	7a1e                	ld	s4,480(sp)
}
    800048b8:	20813083          	ld	ra,520(sp)
    800048bc:	20013403          	ld	s0,512(sp)
    800048c0:	74fe                	ld	s1,504(sp)
    800048c2:	795e                	ld	s2,496(sp)
    800048c4:	21010113          	addi	sp,sp,528
    800048c8:	8082                	ret
    end_op();
    800048ca:	dd2ff0ef          	jal	80003e9c <end_op>
    return -1;
    800048ce:	557d                	li	a0,-1
    800048d0:	b7e5                	j	800048b8 <exec+0x6e>
    800048d2:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800048d4:	8526                	mv	a0,s1
    800048d6:	8b2fd0ef          	jal	80001988 <proc_pagetable>
    800048da:	8b2a                	mv	s6,a0
    800048dc:	2c050b63          	beqz	a0,80004bb2 <exec+0x368>
    800048e0:	f7ce                	sd	s3,488(sp)
    800048e2:	efd6                	sd	s5,472(sp)
    800048e4:	e7de                	sd	s7,456(sp)
    800048e6:	e3e2                	sd	s8,448(sp)
    800048e8:	ff66                	sd	s9,440(sp)
    800048ea:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800048ec:	e7042d03          	lw	s10,-400(s0)
    800048f0:	e8845783          	lhu	a5,-376(s0)
    800048f4:	12078963          	beqz	a5,80004a26 <exec+0x1dc>
    800048f8:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800048fa:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800048fc:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800048fe:	6c85                	lui	s9,0x1
    80004900:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004904:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004908:	6a85                	lui	s5,0x1
    8000490a:	a085                	j	8000496a <exec+0x120>
      panic("loadseg: address should exist");
    8000490c:	00003517          	auipc	a0,0x3
    80004910:	0b450513          	addi	a0,a0,180 # 800079c0 <etext+0x9c0>
    80004914:	e81fb0ef          	jal	80000794 <panic>
    if(sz - i < PGSIZE)
    80004918:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000491a:	8726                	mv	a4,s1
    8000491c:	012c06bb          	addw	a3,s8,s2
    80004920:	4581                	li	a1,0
    80004922:	8552                	mv	a0,s4
    80004924:	ecdfe0ef          	jal	800037f0 <readi>
    80004928:	2501                	sext.w	a0,a0
    8000492a:	24a49a63          	bne	s1,a0,80004b7e <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    8000492e:	012a893b          	addw	s2,s5,s2
    80004932:	03397363          	bgeu	s2,s3,80004958 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004936:	02091593          	slli	a1,s2,0x20
    8000493a:	9181                	srli	a1,a1,0x20
    8000493c:	95de                	add	a1,a1,s7
    8000493e:	855a                	mv	a0,s6
    80004940:	e96fc0ef          	jal	80000fd6 <walkaddr>
    80004944:	862a                	mv	a2,a0
    if(pa == 0)
    80004946:	d179                	beqz	a0,8000490c <exec+0xc2>
    if(sz - i < PGSIZE)
    80004948:	412984bb          	subw	s1,s3,s2
    8000494c:	0004879b          	sext.w	a5,s1
    80004950:	fcfcf4e3          	bgeu	s9,a5,80004918 <exec+0xce>
    80004954:	84d6                	mv	s1,s5
    80004956:	b7c9                	j	80004918 <exec+0xce>
    sz = sz1;
    80004958:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000495c:	2d85                	addiw	s11,s11,1
    8000495e:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004962:	e8845783          	lhu	a5,-376(s0)
    80004966:	08fdd063          	bge	s11,a5,800049e6 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000496a:	2d01                	sext.w	s10,s10
    8000496c:	03800713          	li	a4,56
    80004970:	86ea                	mv	a3,s10
    80004972:	e1840613          	addi	a2,s0,-488
    80004976:	4581                	li	a1,0
    80004978:	8552                	mv	a0,s4
    8000497a:	e77fe0ef          	jal	800037f0 <readi>
    8000497e:	03800793          	li	a5,56
    80004982:	1cf51663          	bne	a0,a5,80004b4e <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004986:	e1842783          	lw	a5,-488(s0)
    8000498a:	4705                	li	a4,1
    8000498c:	fce798e3          	bne	a5,a4,8000495c <exec+0x112>
    if(ph.memsz < ph.filesz)
    80004990:	e4043483          	ld	s1,-448(s0)
    80004994:	e3843783          	ld	a5,-456(s0)
    80004998:	1af4ef63          	bltu	s1,a5,80004b56 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000499c:	e2843783          	ld	a5,-472(s0)
    800049a0:	94be                	add	s1,s1,a5
    800049a2:	1af4ee63          	bltu	s1,a5,80004b5e <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    800049a6:	df043703          	ld	a4,-528(s0)
    800049aa:	8ff9                	and	a5,a5,a4
    800049ac:	1a079d63          	bnez	a5,80004b66 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800049b0:	e1c42503          	lw	a0,-484(s0)
    800049b4:	e7dff0ef          	jal	80004830 <flags2perm>
    800049b8:	86aa                	mv	a3,a0
    800049ba:	8626                	mv	a2,s1
    800049bc:	85ca                	mv	a1,s2
    800049be:	855a                	mv	a0,s6
    800049c0:	97ffc0ef          	jal	8000133e <uvmalloc>
    800049c4:	e0a43423          	sd	a0,-504(s0)
    800049c8:	1a050363          	beqz	a0,80004b6e <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800049cc:	e2843b83          	ld	s7,-472(s0)
    800049d0:	e2042c03          	lw	s8,-480(s0)
    800049d4:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800049d8:	00098463          	beqz	s3,800049e0 <exec+0x196>
    800049dc:	4901                	li	s2,0
    800049de:	bfa1                	j	80004936 <exec+0xec>
    sz = sz1;
    800049e0:	e0843903          	ld	s2,-504(s0)
    800049e4:	bfa5                	j	8000495c <exec+0x112>
    800049e6:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800049e8:	8552                	mv	a0,s4
    800049ea:	dbdfe0ef          	jal	800037a6 <iunlockput>
  end_op();
    800049ee:	caeff0ef          	jal	80003e9c <end_op>
  p = myproc();
    800049f2:	eeffc0ef          	jal	800018e0 <myproc>
    800049f6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800049f8:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800049fc:	6985                	lui	s3,0x1
    800049fe:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004a00:	99ca                	add	s3,s3,s2
    80004a02:	77fd                	lui	a5,0xfffff
    80004a04:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004a08:	4691                	li	a3,4
    80004a0a:	6609                	lui	a2,0x2
    80004a0c:	964e                	add	a2,a2,s3
    80004a0e:	85ce                	mv	a1,s3
    80004a10:	855a                	mv	a0,s6
    80004a12:	92dfc0ef          	jal	8000133e <uvmalloc>
    80004a16:	892a                	mv	s2,a0
    80004a18:	e0a43423          	sd	a0,-504(s0)
    80004a1c:	e519                	bnez	a0,80004a2a <exec+0x1e0>
  if(pagetable)
    80004a1e:	e1343423          	sd	s3,-504(s0)
    80004a22:	4a01                	li	s4,0
    80004a24:	aab1                	j	80004b80 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004a26:	4901                	li	s2,0
    80004a28:	b7c1                	j	800049e8 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004a2a:	75f9                	lui	a1,0xffffe
    80004a2c:	95aa                	add	a1,a1,a0
    80004a2e:	855a                	mv	a0,s6
    80004a30:	af9fc0ef          	jal	80001528 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004a34:	7bfd                	lui	s7,0xfffff
    80004a36:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004a38:	e0043783          	ld	a5,-512(s0)
    80004a3c:	6388                	ld	a0,0(a5)
    80004a3e:	cd39                	beqz	a0,80004a9c <exec+0x252>
    80004a40:	e9040993          	addi	s3,s0,-368
    80004a44:	f9040c13          	addi	s8,s0,-112
    80004a48:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004a4a:	beefc0ef          	jal	80000e38 <strlen>
    80004a4e:	0015079b          	addiw	a5,a0,1
    80004a52:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004a56:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004a5a:	11796e63          	bltu	s2,s7,80004b76 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004a5e:	e0043d03          	ld	s10,-512(s0)
    80004a62:	000d3a03          	ld	s4,0(s10)
    80004a66:	8552                	mv	a0,s4
    80004a68:	bd0fc0ef          	jal	80000e38 <strlen>
    80004a6c:	0015069b          	addiw	a3,a0,1
    80004a70:	8652                	mv	a2,s4
    80004a72:	85ca                	mv	a1,s2
    80004a74:	855a                	mv	a0,s6
    80004a76:	addfc0ef          	jal	80001552 <copyout>
    80004a7a:	10054063          	bltz	a0,80004b7a <exec+0x330>
    ustack[argc] = sp;
    80004a7e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004a82:	0485                	addi	s1,s1,1
    80004a84:	008d0793          	addi	a5,s10,8
    80004a88:	e0f43023          	sd	a5,-512(s0)
    80004a8c:	008d3503          	ld	a0,8(s10)
    80004a90:	c909                	beqz	a0,80004aa2 <exec+0x258>
    if(argc >= MAXARG)
    80004a92:	09a1                	addi	s3,s3,8
    80004a94:	fb899be3          	bne	s3,s8,80004a4a <exec+0x200>
  ip = 0;
    80004a98:	4a01                	li	s4,0
    80004a9a:	a0dd                	j	80004b80 <exec+0x336>
  sp = sz;
    80004a9c:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004aa0:	4481                	li	s1,0
  ustack[argc] = 0;
    80004aa2:	00349793          	slli	a5,s1,0x3
    80004aa6:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb520>
    80004aaa:	97a2                	add	a5,a5,s0
    80004aac:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004ab0:	00148693          	addi	a3,s1,1
    80004ab4:	068e                	slli	a3,a3,0x3
    80004ab6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004aba:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004abe:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004ac2:	f5796ee3          	bltu	s2,s7,80004a1e <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004ac6:	e9040613          	addi	a2,s0,-368
    80004aca:	85ca                	mv	a1,s2
    80004acc:	855a                	mv	a0,s6
    80004ace:	a85fc0ef          	jal	80001552 <copyout>
    80004ad2:	0e054263          	bltz	a0,80004bb6 <exec+0x36c>
  p->trapframe->a1 = sp;
    80004ad6:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004ada:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004ade:	df843783          	ld	a5,-520(s0)
    80004ae2:	0007c703          	lbu	a4,0(a5)
    80004ae6:	cf11                	beqz	a4,80004b02 <exec+0x2b8>
    80004ae8:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004aea:	02f00693          	li	a3,47
    80004aee:	a039                	j	80004afc <exec+0x2b2>
      last = s+1;
    80004af0:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004af4:	0785                	addi	a5,a5,1
    80004af6:	fff7c703          	lbu	a4,-1(a5)
    80004afa:	c701                	beqz	a4,80004b02 <exec+0x2b8>
    if(*s == '/')
    80004afc:	fed71ce3          	bne	a4,a3,80004af4 <exec+0x2aa>
    80004b00:	bfc5                	j	80004af0 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004b02:	4641                	li	a2,16
    80004b04:	df843583          	ld	a1,-520(s0)
    80004b08:	158a8513          	addi	a0,s5,344
    80004b0c:	afafc0ef          	jal	80000e06 <safestrcpy>
  oldpagetable = p->pagetable;
    80004b10:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004b14:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004b18:	e0843783          	ld	a5,-504(s0)
    80004b1c:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004b20:	058ab783          	ld	a5,88(s5)
    80004b24:	e6843703          	ld	a4,-408(s0)
    80004b28:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004b2a:	058ab783          	ld	a5,88(s5)
    80004b2e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004b32:	85e6                	mv	a1,s9
    80004b34:	ed9fc0ef          	jal	80001a0c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004b38:	0004851b          	sext.w	a0,s1
    80004b3c:	79be                	ld	s3,488(sp)
    80004b3e:	7a1e                	ld	s4,480(sp)
    80004b40:	6afe                	ld	s5,472(sp)
    80004b42:	6b5e                	ld	s6,464(sp)
    80004b44:	6bbe                	ld	s7,456(sp)
    80004b46:	6c1e                	ld	s8,448(sp)
    80004b48:	7cfa                	ld	s9,440(sp)
    80004b4a:	7d5a                	ld	s10,432(sp)
    80004b4c:	b3b5                	j	800048b8 <exec+0x6e>
    80004b4e:	e1243423          	sd	s2,-504(s0)
    80004b52:	7dba                	ld	s11,424(sp)
    80004b54:	a035                	j	80004b80 <exec+0x336>
    80004b56:	e1243423          	sd	s2,-504(s0)
    80004b5a:	7dba                	ld	s11,424(sp)
    80004b5c:	a015                	j	80004b80 <exec+0x336>
    80004b5e:	e1243423          	sd	s2,-504(s0)
    80004b62:	7dba                	ld	s11,424(sp)
    80004b64:	a831                	j	80004b80 <exec+0x336>
    80004b66:	e1243423          	sd	s2,-504(s0)
    80004b6a:	7dba                	ld	s11,424(sp)
    80004b6c:	a811                	j	80004b80 <exec+0x336>
    80004b6e:	e1243423          	sd	s2,-504(s0)
    80004b72:	7dba                	ld	s11,424(sp)
    80004b74:	a031                	j	80004b80 <exec+0x336>
  ip = 0;
    80004b76:	4a01                	li	s4,0
    80004b78:	a021                	j	80004b80 <exec+0x336>
    80004b7a:	4a01                	li	s4,0
  if(pagetable)
    80004b7c:	a011                	j	80004b80 <exec+0x336>
    80004b7e:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004b80:	e0843583          	ld	a1,-504(s0)
    80004b84:	855a                	mv	a0,s6
    80004b86:	e87fc0ef          	jal	80001a0c <proc_freepagetable>
  return -1;
    80004b8a:	557d                	li	a0,-1
  if(ip){
    80004b8c:	000a1b63          	bnez	s4,80004ba2 <exec+0x358>
    80004b90:	79be                	ld	s3,488(sp)
    80004b92:	7a1e                	ld	s4,480(sp)
    80004b94:	6afe                	ld	s5,472(sp)
    80004b96:	6b5e                	ld	s6,464(sp)
    80004b98:	6bbe                	ld	s7,456(sp)
    80004b9a:	6c1e                	ld	s8,448(sp)
    80004b9c:	7cfa                	ld	s9,440(sp)
    80004b9e:	7d5a                	ld	s10,432(sp)
    80004ba0:	bb21                	j	800048b8 <exec+0x6e>
    80004ba2:	79be                	ld	s3,488(sp)
    80004ba4:	6afe                	ld	s5,472(sp)
    80004ba6:	6b5e                	ld	s6,464(sp)
    80004ba8:	6bbe                	ld	s7,456(sp)
    80004baa:	6c1e                	ld	s8,448(sp)
    80004bac:	7cfa                	ld	s9,440(sp)
    80004bae:	7d5a                	ld	s10,432(sp)
    80004bb0:	b9ed                	j	800048aa <exec+0x60>
    80004bb2:	6b5e                	ld	s6,464(sp)
    80004bb4:	b9dd                	j	800048aa <exec+0x60>
  sz = sz1;
    80004bb6:	e0843983          	ld	s3,-504(s0)
    80004bba:	b595                	j	80004a1e <exec+0x1d4>

0000000080004bbc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004bbc:	7179                	addi	sp,sp,-48
    80004bbe:	f406                	sd	ra,40(sp)
    80004bc0:	f022                	sd	s0,32(sp)
    80004bc2:	ec26                	sd	s1,24(sp)
    80004bc4:	e84a                	sd	s2,16(sp)
    80004bc6:	1800                	addi	s0,sp,48
    80004bc8:	892e                	mv	s2,a1
    80004bca:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004bcc:	fdc40593          	addi	a1,s0,-36
    80004bd0:	bc5fd0ef          	jal	80002794 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004bd4:	fdc42703          	lw	a4,-36(s0)
    80004bd8:	47bd                	li	a5,15
    80004bda:	02e7e963          	bltu	a5,a4,80004c0c <argfd+0x50>
    80004bde:	d03fc0ef          	jal	800018e0 <myproc>
    80004be2:	fdc42703          	lw	a4,-36(s0)
    80004be6:	01a70793          	addi	a5,a4,26
    80004bea:	078e                	slli	a5,a5,0x3
    80004bec:	953e                	add	a0,a0,a5
    80004bee:	611c                	ld	a5,0(a0)
    80004bf0:	c385                	beqz	a5,80004c10 <argfd+0x54>
    return -1;
  if(pfd)
    80004bf2:	00090463          	beqz	s2,80004bfa <argfd+0x3e>
    *pfd = fd;
    80004bf6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004bfa:	4501                	li	a0,0
  if(pf)
    80004bfc:	c091                	beqz	s1,80004c00 <argfd+0x44>
    *pf = f;
    80004bfe:	e09c                	sd	a5,0(s1)
}
    80004c00:	70a2                	ld	ra,40(sp)
    80004c02:	7402                	ld	s0,32(sp)
    80004c04:	64e2                	ld	s1,24(sp)
    80004c06:	6942                	ld	s2,16(sp)
    80004c08:	6145                	addi	sp,sp,48
    80004c0a:	8082                	ret
    return -1;
    80004c0c:	557d                	li	a0,-1
    80004c0e:	bfcd                	j	80004c00 <argfd+0x44>
    80004c10:	557d                	li	a0,-1
    80004c12:	b7fd                	j	80004c00 <argfd+0x44>

0000000080004c14 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004c14:	1101                	addi	sp,sp,-32
    80004c16:	ec06                	sd	ra,24(sp)
    80004c18:	e822                	sd	s0,16(sp)
    80004c1a:	e426                	sd	s1,8(sp)
    80004c1c:	1000                	addi	s0,sp,32
    80004c1e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004c20:	cc1fc0ef          	jal	800018e0 <myproc>
    80004c24:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004c26:	0d050793          	addi	a5,a0,208
    80004c2a:	4501                	li	a0,0
    80004c2c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004c2e:	6398                	ld	a4,0(a5)
    80004c30:	cb19                	beqz	a4,80004c46 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004c32:	2505                	addiw	a0,a0,1
    80004c34:	07a1                	addi	a5,a5,8
    80004c36:	fed51ce3          	bne	a0,a3,80004c2e <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004c3a:	557d                	li	a0,-1
}
    80004c3c:	60e2                	ld	ra,24(sp)
    80004c3e:	6442                	ld	s0,16(sp)
    80004c40:	64a2                	ld	s1,8(sp)
    80004c42:	6105                	addi	sp,sp,32
    80004c44:	8082                	ret
      p->ofile[fd] = f;
    80004c46:	01a50793          	addi	a5,a0,26
    80004c4a:	078e                	slli	a5,a5,0x3
    80004c4c:	963e                	add	a2,a2,a5
    80004c4e:	e204                	sd	s1,0(a2)
      return fd;
    80004c50:	b7f5                	j	80004c3c <fdalloc+0x28>

0000000080004c52 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004c52:	715d                	addi	sp,sp,-80
    80004c54:	e486                	sd	ra,72(sp)
    80004c56:	e0a2                	sd	s0,64(sp)
    80004c58:	fc26                	sd	s1,56(sp)
    80004c5a:	f84a                	sd	s2,48(sp)
    80004c5c:	f44e                	sd	s3,40(sp)
    80004c5e:	ec56                	sd	s5,24(sp)
    80004c60:	e85a                	sd	s6,16(sp)
    80004c62:	0880                	addi	s0,sp,80
    80004c64:	8b2e                	mv	s6,a1
    80004c66:	89b2                	mv	s3,a2
    80004c68:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004c6a:	fb040593          	addi	a1,s0,-80
    80004c6e:	822ff0ef          	jal	80003c90 <nameiparent>
    80004c72:	84aa                	mv	s1,a0
    80004c74:	10050a63          	beqz	a0,80004d88 <create+0x136>
    return 0;

  ilock(dp);
    80004c78:	925fe0ef          	jal	8000359c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004c7c:	4601                	li	a2,0
    80004c7e:	fb040593          	addi	a1,s0,-80
    80004c82:	8526                	mv	a0,s1
    80004c84:	d8dfe0ef          	jal	80003a10 <dirlookup>
    80004c88:	8aaa                	mv	s5,a0
    80004c8a:	c129                	beqz	a0,80004ccc <create+0x7a>
    iunlockput(dp);
    80004c8c:	8526                	mv	a0,s1
    80004c8e:	b19fe0ef          	jal	800037a6 <iunlockput>
    ilock(ip);
    80004c92:	8556                	mv	a0,s5
    80004c94:	909fe0ef          	jal	8000359c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004c98:	4789                	li	a5,2
    80004c9a:	02fb1463          	bne	s6,a5,80004cc2 <create+0x70>
    80004c9e:	044ad783          	lhu	a5,68(s5)
    80004ca2:	37f9                	addiw	a5,a5,-2
    80004ca4:	17c2                	slli	a5,a5,0x30
    80004ca6:	93c1                	srli	a5,a5,0x30
    80004ca8:	4705                	li	a4,1
    80004caa:	00f76c63          	bltu	a4,a5,80004cc2 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004cae:	8556                	mv	a0,s5
    80004cb0:	60a6                	ld	ra,72(sp)
    80004cb2:	6406                	ld	s0,64(sp)
    80004cb4:	74e2                	ld	s1,56(sp)
    80004cb6:	7942                	ld	s2,48(sp)
    80004cb8:	79a2                	ld	s3,40(sp)
    80004cba:	6ae2                	ld	s5,24(sp)
    80004cbc:	6b42                	ld	s6,16(sp)
    80004cbe:	6161                	addi	sp,sp,80
    80004cc0:	8082                	ret
    iunlockput(ip);
    80004cc2:	8556                	mv	a0,s5
    80004cc4:	ae3fe0ef          	jal	800037a6 <iunlockput>
    return 0;
    80004cc8:	4a81                	li	s5,0
    80004cca:	b7d5                	j	80004cae <create+0x5c>
    80004ccc:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004cce:	85da                	mv	a1,s6
    80004cd0:	4088                	lw	a0,0(s1)
    80004cd2:	f5afe0ef          	jal	8000342c <ialloc>
    80004cd6:	8a2a                	mv	s4,a0
    80004cd8:	cd15                	beqz	a0,80004d14 <create+0xc2>
  ilock(ip);
    80004cda:	8c3fe0ef          	jal	8000359c <ilock>
  ip->major = major;
    80004cde:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004ce2:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004ce6:	4905                	li	s2,1
    80004ce8:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004cec:	8552                	mv	a0,s4
    80004cee:	ffafe0ef          	jal	800034e8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004cf2:	032b0763          	beq	s6,s2,80004d20 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004cf6:	004a2603          	lw	a2,4(s4)
    80004cfa:	fb040593          	addi	a1,s0,-80
    80004cfe:	8526                	mv	a0,s1
    80004d00:	eddfe0ef          	jal	80003bdc <dirlink>
    80004d04:	06054563          	bltz	a0,80004d6e <create+0x11c>
  iunlockput(dp);
    80004d08:	8526                	mv	a0,s1
    80004d0a:	a9dfe0ef          	jal	800037a6 <iunlockput>
  return ip;
    80004d0e:	8ad2                	mv	s5,s4
    80004d10:	7a02                	ld	s4,32(sp)
    80004d12:	bf71                	j	80004cae <create+0x5c>
    iunlockput(dp);
    80004d14:	8526                	mv	a0,s1
    80004d16:	a91fe0ef          	jal	800037a6 <iunlockput>
    return 0;
    80004d1a:	8ad2                	mv	s5,s4
    80004d1c:	7a02                	ld	s4,32(sp)
    80004d1e:	bf41                	j	80004cae <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004d20:	004a2603          	lw	a2,4(s4)
    80004d24:	00003597          	auipc	a1,0x3
    80004d28:	cbc58593          	addi	a1,a1,-836 # 800079e0 <etext+0x9e0>
    80004d2c:	8552                	mv	a0,s4
    80004d2e:	eaffe0ef          	jal	80003bdc <dirlink>
    80004d32:	02054e63          	bltz	a0,80004d6e <create+0x11c>
    80004d36:	40d0                	lw	a2,4(s1)
    80004d38:	00003597          	auipc	a1,0x3
    80004d3c:	cb058593          	addi	a1,a1,-848 # 800079e8 <etext+0x9e8>
    80004d40:	8552                	mv	a0,s4
    80004d42:	e9bfe0ef          	jal	80003bdc <dirlink>
    80004d46:	02054463          	bltz	a0,80004d6e <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004d4a:	004a2603          	lw	a2,4(s4)
    80004d4e:	fb040593          	addi	a1,s0,-80
    80004d52:	8526                	mv	a0,s1
    80004d54:	e89fe0ef          	jal	80003bdc <dirlink>
    80004d58:	00054b63          	bltz	a0,80004d6e <create+0x11c>
    dp->nlink++;  // for ".."
    80004d5c:	04a4d783          	lhu	a5,74(s1)
    80004d60:	2785                	addiw	a5,a5,1
    80004d62:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d66:	8526                	mv	a0,s1
    80004d68:	f80fe0ef          	jal	800034e8 <iupdate>
    80004d6c:	bf71                	j	80004d08 <create+0xb6>
  ip->nlink = 0;
    80004d6e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004d72:	8552                	mv	a0,s4
    80004d74:	f74fe0ef          	jal	800034e8 <iupdate>
  iunlockput(ip);
    80004d78:	8552                	mv	a0,s4
    80004d7a:	a2dfe0ef          	jal	800037a6 <iunlockput>
  iunlockput(dp);
    80004d7e:	8526                	mv	a0,s1
    80004d80:	a27fe0ef          	jal	800037a6 <iunlockput>
  return 0;
    80004d84:	7a02                	ld	s4,32(sp)
    80004d86:	b725                	j	80004cae <create+0x5c>
    return 0;
    80004d88:	8aaa                	mv	s5,a0
    80004d8a:	b715                	j	80004cae <create+0x5c>

0000000080004d8c <sys_dup>:
{
    80004d8c:	7179                	addi	sp,sp,-48
    80004d8e:	f406                	sd	ra,40(sp)
    80004d90:	f022                	sd	s0,32(sp)
    80004d92:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004d94:	fd840613          	addi	a2,s0,-40
    80004d98:	4581                	li	a1,0
    80004d9a:	4501                	li	a0,0
    80004d9c:	e21ff0ef          	jal	80004bbc <argfd>
    return -1;
    80004da0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004da2:	02054363          	bltz	a0,80004dc8 <sys_dup+0x3c>
    80004da6:	ec26                	sd	s1,24(sp)
    80004da8:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004daa:	fd843903          	ld	s2,-40(s0)
    80004dae:	854a                	mv	a0,s2
    80004db0:	e65ff0ef          	jal	80004c14 <fdalloc>
    80004db4:	84aa                	mv	s1,a0
    return -1;
    80004db6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004db8:	00054d63          	bltz	a0,80004dd2 <sys_dup+0x46>
  filedup(f);
    80004dbc:	854a                	mv	a0,s2
    80004dbe:	c48ff0ef          	jal	80004206 <filedup>
  return fd;
    80004dc2:	87a6                	mv	a5,s1
    80004dc4:	64e2                	ld	s1,24(sp)
    80004dc6:	6942                	ld	s2,16(sp)
}
    80004dc8:	853e                	mv	a0,a5
    80004dca:	70a2                	ld	ra,40(sp)
    80004dcc:	7402                	ld	s0,32(sp)
    80004dce:	6145                	addi	sp,sp,48
    80004dd0:	8082                	ret
    80004dd2:	64e2                	ld	s1,24(sp)
    80004dd4:	6942                	ld	s2,16(sp)
    80004dd6:	bfcd                	j	80004dc8 <sys_dup+0x3c>

0000000080004dd8 <sys_read>:
{
    80004dd8:	7179                	addi	sp,sp,-48
    80004dda:	f406                	sd	ra,40(sp)
    80004ddc:	f022                	sd	s0,32(sp)
    80004dde:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004de0:	fd840593          	addi	a1,s0,-40
    80004de4:	4505                	li	a0,1
    80004de6:	9cbfd0ef          	jal	800027b0 <argaddr>
  argint(2, &n);
    80004dea:	fe440593          	addi	a1,s0,-28
    80004dee:	4509                	li	a0,2
    80004df0:	9a5fd0ef          	jal	80002794 <argint>
  if(argfd(0, 0, &f) < 0)
    80004df4:	fe840613          	addi	a2,s0,-24
    80004df8:	4581                	li	a1,0
    80004dfa:	4501                	li	a0,0
    80004dfc:	dc1ff0ef          	jal	80004bbc <argfd>
    80004e00:	87aa                	mv	a5,a0
    return -1;
    80004e02:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e04:	0007ca63          	bltz	a5,80004e18 <sys_read+0x40>
  return fileread(f, p, n);
    80004e08:	fe442603          	lw	a2,-28(s0)
    80004e0c:	fd843583          	ld	a1,-40(s0)
    80004e10:	fe843503          	ld	a0,-24(s0)
    80004e14:	d58ff0ef          	jal	8000436c <fileread>
}
    80004e18:	70a2                	ld	ra,40(sp)
    80004e1a:	7402                	ld	s0,32(sp)
    80004e1c:	6145                	addi	sp,sp,48
    80004e1e:	8082                	ret

0000000080004e20 <sys_write>:
{
    80004e20:	7179                	addi	sp,sp,-48
    80004e22:	f406                	sd	ra,40(sp)
    80004e24:	f022                	sd	s0,32(sp)
    80004e26:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004e28:	fd840593          	addi	a1,s0,-40
    80004e2c:	4505                	li	a0,1
    80004e2e:	983fd0ef          	jal	800027b0 <argaddr>
  argint(2, &n);
    80004e32:	fe440593          	addi	a1,s0,-28
    80004e36:	4509                	li	a0,2
    80004e38:	95dfd0ef          	jal	80002794 <argint>
  if(argfd(0, 0, &f) < 0)
    80004e3c:	fe840613          	addi	a2,s0,-24
    80004e40:	4581                	li	a1,0
    80004e42:	4501                	li	a0,0
    80004e44:	d79ff0ef          	jal	80004bbc <argfd>
    80004e48:	87aa                	mv	a5,a0
    return -1;
    80004e4a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e4c:	0007ca63          	bltz	a5,80004e60 <sys_write+0x40>
  return filewrite(f, p, n);
    80004e50:	fe442603          	lw	a2,-28(s0)
    80004e54:	fd843583          	ld	a1,-40(s0)
    80004e58:	fe843503          	ld	a0,-24(s0)
    80004e5c:	dceff0ef          	jal	8000442a <filewrite>
}
    80004e60:	70a2                	ld	ra,40(sp)
    80004e62:	7402                	ld	s0,32(sp)
    80004e64:	6145                	addi	sp,sp,48
    80004e66:	8082                	ret

0000000080004e68 <sys_close>:
{
    80004e68:	1101                	addi	sp,sp,-32
    80004e6a:	ec06                	sd	ra,24(sp)
    80004e6c:	e822                	sd	s0,16(sp)
    80004e6e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004e70:	fe040613          	addi	a2,s0,-32
    80004e74:	fec40593          	addi	a1,s0,-20
    80004e78:	4501                	li	a0,0
    80004e7a:	d43ff0ef          	jal	80004bbc <argfd>
    return -1;
    80004e7e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004e80:	02054063          	bltz	a0,80004ea0 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004e84:	a5dfc0ef          	jal	800018e0 <myproc>
    80004e88:	fec42783          	lw	a5,-20(s0)
    80004e8c:	07e9                	addi	a5,a5,26
    80004e8e:	078e                	slli	a5,a5,0x3
    80004e90:	953e                	add	a0,a0,a5
    80004e92:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004e96:	fe043503          	ld	a0,-32(s0)
    80004e9a:	bb2ff0ef          	jal	8000424c <fileclose>
  return 0;
    80004e9e:	4781                	li	a5,0
}
    80004ea0:	853e                	mv	a0,a5
    80004ea2:	60e2                	ld	ra,24(sp)
    80004ea4:	6442                	ld	s0,16(sp)
    80004ea6:	6105                	addi	sp,sp,32
    80004ea8:	8082                	ret

0000000080004eaa <sys_fstat>:
{
    80004eaa:	1101                	addi	sp,sp,-32
    80004eac:	ec06                	sd	ra,24(sp)
    80004eae:	e822                	sd	s0,16(sp)
    80004eb0:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004eb2:	fe040593          	addi	a1,s0,-32
    80004eb6:	4505                	li	a0,1
    80004eb8:	8f9fd0ef          	jal	800027b0 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004ebc:	fe840613          	addi	a2,s0,-24
    80004ec0:	4581                	li	a1,0
    80004ec2:	4501                	li	a0,0
    80004ec4:	cf9ff0ef          	jal	80004bbc <argfd>
    80004ec8:	87aa                	mv	a5,a0
    return -1;
    80004eca:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004ecc:	0007c863          	bltz	a5,80004edc <sys_fstat+0x32>
  return filestat(f, st);
    80004ed0:	fe043583          	ld	a1,-32(s0)
    80004ed4:	fe843503          	ld	a0,-24(s0)
    80004ed8:	c36ff0ef          	jal	8000430e <filestat>
}
    80004edc:	60e2                	ld	ra,24(sp)
    80004ede:	6442                	ld	s0,16(sp)
    80004ee0:	6105                	addi	sp,sp,32
    80004ee2:	8082                	ret

0000000080004ee4 <sys_link>:
{
    80004ee4:	7169                	addi	sp,sp,-304
    80004ee6:	f606                	sd	ra,296(sp)
    80004ee8:	f222                	sd	s0,288(sp)
    80004eea:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004eec:	08000613          	li	a2,128
    80004ef0:	ed040593          	addi	a1,s0,-304
    80004ef4:	4501                	li	a0,0
    80004ef6:	8d7fd0ef          	jal	800027cc <argstr>
    return -1;
    80004efa:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004efc:	0c054e63          	bltz	a0,80004fd8 <sys_link+0xf4>
    80004f00:	08000613          	li	a2,128
    80004f04:	f5040593          	addi	a1,s0,-176
    80004f08:	4505                	li	a0,1
    80004f0a:	8c3fd0ef          	jal	800027cc <argstr>
    return -1;
    80004f0e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f10:	0c054463          	bltz	a0,80004fd8 <sys_link+0xf4>
    80004f14:	ee26                	sd	s1,280(sp)
  begin_op();
    80004f16:	f1dfe0ef          	jal	80003e32 <begin_op>
  if((ip = namei(old)) == 0){
    80004f1a:	ed040513          	addi	a0,s0,-304
    80004f1e:	d59fe0ef          	jal	80003c76 <namei>
    80004f22:	84aa                	mv	s1,a0
    80004f24:	c53d                	beqz	a0,80004f92 <sys_link+0xae>
  ilock(ip);
    80004f26:	e76fe0ef          	jal	8000359c <ilock>
  if(ip->type == T_DIR){
    80004f2a:	04449703          	lh	a4,68(s1)
    80004f2e:	4785                	li	a5,1
    80004f30:	06f70663          	beq	a4,a5,80004f9c <sys_link+0xb8>
    80004f34:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004f36:	04a4d783          	lhu	a5,74(s1)
    80004f3a:	2785                	addiw	a5,a5,1
    80004f3c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004f40:	8526                	mv	a0,s1
    80004f42:	da6fe0ef          	jal	800034e8 <iupdate>
  iunlock(ip);
    80004f46:	8526                	mv	a0,s1
    80004f48:	f02fe0ef          	jal	8000364a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004f4c:	fd040593          	addi	a1,s0,-48
    80004f50:	f5040513          	addi	a0,s0,-176
    80004f54:	d3dfe0ef          	jal	80003c90 <nameiparent>
    80004f58:	892a                	mv	s2,a0
    80004f5a:	cd21                	beqz	a0,80004fb2 <sys_link+0xce>
  ilock(dp);
    80004f5c:	e40fe0ef          	jal	8000359c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004f60:	00092703          	lw	a4,0(s2)
    80004f64:	409c                	lw	a5,0(s1)
    80004f66:	04f71363          	bne	a4,a5,80004fac <sys_link+0xc8>
    80004f6a:	40d0                	lw	a2,4(s1)
    80004f6c:	fd040593          	addi	a1,s0,-48
    80004f70:	854a                	mv	a0,s2
    80004f72:	c6bfe0ef          	jal	80003bdc <dirlink>
    80004f76:	02054b63          	bltz	a0,80004fac <sys_link+0xc8>
  iunlockput(dp);
    80004f7a:	854a                	mv	a0,s2
    80004f7c:	82bfe0ef          	jal	800037a6 <iunlockput>
  iput(ip);
    80004f80:	8526                	mv	a0,s1
    80004f82:	f9cfe0ef          	jal	8000371e <iput>
  end_op();
    80004f86:	f17fe0ef          	jal	80003e9c <end_op>
  return 0;
    80004f8a:	4781                	li	a5,0
    80004f8c:	64f2                	ld	s1,280(sp)
    80004f8e:	6952                	ld	s2,272(sp)
    80004f90:	a0a1                	j	80004fd8 <sys_link+0xf4>
    end_op();
    80004f92:	f0bfe0ef          	jal	80003e9c <end_op>
    return -1;
    80004f96:	57fd                	li	a5,-1
    80004f98:	64f2                	ld	s1,280(sp)
    80004f9a:	a83d                	j	80004fd8 <sys_link+0xf4>
    iunlockput(ip);
    80004f9c:	8526                	mv	a0,s1
    80004f9e:	809fe0ef          	jal	800037a6 <iunlockput>
    end_op();
    80004fa2:	efbfe0ef          	jal	80003e9c <end_op>
    return -1;
    80004fa6:	57fd                	li	a5,-1
    80004fa8:	64f2                	ld	s1,280(sp)
    80004faa:	a03d                	j	80004fd8 <sys_link+0xf4>
    iunlockput(dp);
    80004fac:	854a                	mv	a0,s2
    80004fae:	ff8fe0ef          	jal	800037a6 <iunlockput>
  ilock(ip);
    80004fb2:	8526                	mv	a0,s1
    80004fb4:	de8fe0ef          	jal	8000359c <ilock>
  ip->nlink--;
    80004fb8:	04a4d783          	lhu	a5,74(s1)
    80004fbc:	37fd                	addiw	a5,a5,-1
    80004fbe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004fc2:	8526                	mv	a0,s1
    80004fc4:	d24fe0ef          	jal	800034e8 <iupdate>
  iunlockput(ip);
    80004fc8:	8526                	mv	a0,s1
    80004fca:	fdcfe0ef          	jal	800037a6 <iunlockput>
  end_op();
    80004fce:	ecffe0ef          	jal	80003e9c <end_op>
  return -1;
    80004fd2:	57fd                	li	a5,-1
    80004fd4:	64f2                	ld	s1,280(sp)
    80004fd6:	6952                	ld	s2,272(sp)
}
    80004fd8:	853e                	mv	a0,a5
    80004fda:	70b2                	ld	ra,296(sp)
    80004fdc:	7412                	ld	s0,288(sp)
    80004fde:	6155                	addi	sp,sp,304
    80004fe0:	8082                	ret

0000000080004fe2 <sys_unlink>:
{
    80004fe2:	7151                	addi	sp,sp,-240
    80004fe4:	f586                	sd	ra,232(sp)
    80004fe6:	f1a2                	sd	s0,224(sp)
    80004fe8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004fea:	08000613          	li	a2,128
    80004fee:	f3040593          	addi	a1,s0,-208
    80004ff2:	4501                	li	a0,0
    80004ff4:	fd8fd0ef          	jal	800027cc <argstr>
    80004ff8:	16054063          	bltz	a0,80005158 <sys_unlink+0x176>
    80004ffc:	eda6                	sd	s1,216(sp)
  begin_op();
    80004ffe:	e35fe0ef          	jal	80003e32 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005002:	fb040593          	addi	a1,s0,-80
    80005006:	f3040513          	addi	a0,s0,-208
    8000500a:	c87fe0ef          	jal	80003c90 <nameiparent>
    8000500e:	84aa                	mv	s1,a0
    80005010:	c945                	beqz	a0,800050c0 <sys_unlink+0xde>
  ilock(dp);
    80005012:	d8afe0ef          	jal	8000359c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005016:	00003597          	auipc	a1,0x3
    8000501a:	9ca58593          	addi	a1,a1,-1590 # 800079e0 <etext+0x9e0>
    8000501e:	fb040513          	addi	a0,s0,-80
    80005022:	9d9fe0ef          	jal	800039fa <namecmp>
    80005026:	10050e63          	beqz	a0,80005142 <sys_unlink+0x160>
    8000502a:	00003597          	auipc	a1,0x3
    8000502e:	9be58593          	addi	a1,a1,-1602 # 800079e8 <etext+0x9e8>
    80005032:	fb040513          	addi	a0,s0,-80
    80005036:	9c5fe0ef          	jal	800039fa <namecmp>
    8000503a:	10050463          	beqz	a0,80005142 <sys_unlink+0x160>
    8000503e:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005040:	f2c40613          	addi	a2,s0,-212
    80005044:	fb040593          	addi	a1,s0,-80
    80005048:	8526                	mv	a0,s1
    8000504a:	9c7fe0ef          	jal	80003a10 <dirlookup>
    8000504e:	892a                	mv	s2,a0
    80005050:	0e050863          	beqz	a0,80005140 <sys_unlink+0x15e>
  ilock(ip);
    80005054:	d48fe0ef          	jal	8000359c <ilock>
  if(ip->nlink < 1)
    80005058:	04a91783          	lh	a5,74(s2)
    8000505c:	06f05763          	blez	a5,800050ca <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005060:	04491703          	lh	a4,68(s2)
    80005064:	4785                	li	a5,1
    80005066:	06f70963          	beq	a4,a5,800050d8 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    8000506a:	4641                	li	a2,16
    8000506c:	4581                	li	a1,0
    8000506e:	fc040513          	addi	a0,s0,-64
    80005072:	c57fb0ef          	jal	80000cc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005076:	4741                	li	a4,16
    80005078:	f2c42683          	lw	a3,-212(s0)
    8000507c:	fc040613          	addi	a2,s0,-64
    80005080:	4581                	li	a1,0
    80005082:	8526                	mv	a0,s1
    80005084:	869fe0ef          	jal	800038ec <writei>
    80005088:	47c1                	li	a5,16
    8000508a:	08f51b63          	bne	a0,a5,80005120 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    8000508e:	04491703          	lh	a4,68(s2)
    80005092:	4785                	li	a5,1
    80005094:	08f70d63          	beq	a4,a5,8000512e <sys_unlink+0x14c>
  iunlockput(dp);
    80005098:	8526                	mv	a0,s1
    8000509a:	f0cfe0ef          	jal	800037a6 <iunlockput>
  ip->nlink--;
    8000509e:	04a95783          	lhu	a5,74(s2)
    800050a2:	37fd                	addiw	a5,a5,-1
    800050a4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800050a8:	854a                	mv	a0,s2
    800050aa:	c3efe0ef          	jal	800034e8 <iupdate>
  iunlockput(ip);
    800050ae:	854a                	mv	a0,s2
    800050b0:	ef6fe0ef          	jal	800037a6 <iunlockput>
  end_op();
    800050b4:	de9fe0ef          	jal	80003e9c <end_op>
  return 0;
    800050b8:	4501                	li	a0,0
    800050ba:	64ee                	ld	s1,216(sp)
    800050bc:	694e                	ld	s2,208(sp)
    800050be:	a849                	j	80005150 <sys_unlink+0x16e>
    end_op();
    800050c0:	dddfe0ef          	jal	80003e9c <end_op>
    return -1;
    800050c4:	557d                	li	a0,-1
    800050c6:	64ee                	ld	s1,216(sp)
    800050c8:	a061                	j	80005150 <sys_unlink+0x16e>
    800050ca:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    800050cc:	00003517          	auipc	a0,0x3
    800050d0:	92450513          	addi	a0,a0,-1756 # 800079f0 <etext+0x9f0>
    800050d4:	ec0fb0ef          	jal	80000794 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800050d8:	04c92703          	lw	a4,76(s2)
    800050dc:	02000793          	li	a5,32
    800050e0:	f8e7f5e3          	bgeu	a5,a4,8000506a <sys_unlink+0x88>
    800050e4:	e5ce                	sd	s3,200(sp)
    800050e6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800050ea:	4741                	li	a4,16
    800050ec:	86ce                	mv	a3,s3
    800050ee:	f1840613          	addi	a2,s0,-232
    800050f2:	4581                	li	a1,0
    800050f4:	854a                	mv	a0,s2
    800050f6:	efafe0ef          	jal	800037f0 <readi>
    800050fa:	47c1                	li	a5,16
    800050fc:	00f51c63          	bne	a0,a5,80005114 <sys_unlink+0x132>
    if(de.inum != 0)
    80005100:	f1845783          	lhu	a5,-232(s0)
    80005104:	efa1                	bnez	a5,8000515c <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005106:	29c1                	addiw	s3,s3,16
    80005108:	04c92783          	lw	a5,76(s2)
    8000510c:	fcf9efe3          	bltu	s3,a5,800050ea <sys_unlink+0x108>
    80005110:	69ae                	ld	s3,200(sp)
    80005112:	bfa1                	j	8000506a <sys_unlink+0x88>
      panic("isdirempty: readi");
    80005114:	00003517          	auipc	a0,0x3
    80005118:	8f450513          	addi	a0,a0,-1804 # 80007a08 <etext+0xa08>
    8000511c:	e78fb0ef          	jal	80000794 <panic>
    80005120:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005122:	00003517          	auipc	a0,0x3
    80005126:	8fe50513          	addi	a0,a0,-1794 # 80007a20 <etext+0xa20>
    8000512a:	e6afb0ef          	jal	80000794 <panic>
    dp->nlink--;
    8000512e:	04a4d783          	lhu	a5,74(s1)
    80005132:	37fd                	addiw	a5,a5,-1
    80005134:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005138:	8526                	mv	a0,s1
    8000513a:	baefe0ef          	jal	800034e8 <iupdate>
    8000513e:	bfa9                	j	80005098 <sys_unlink+0xb6>
    80005140:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005142:	8526                	mv	a0,s1
    80005144:	e62fe0ef          	jal	800037a6 <iunlockput>
  end_op();
    80005148:	d55fe0ef          	jal	80003e9c <end_op>
  return -1;
    8000514c:	557d                	li	a0,-1
    8000514e:	64ee                	ld	s1,216(sp)
}
    80005150:	70ae                	ld	ra,232(sp)
    80005152:	740e                	ld	s0,224(sp)
    80005154:	616d                	addi	sp,sp,240
    80005156:	8082                	ret
    return -1;
    80005158:	557d                	li	a0,-1
    8000515a:	bfdd                	j	80005150 <sys_unlink+0x16e>
    iunlockput(ip);
    8000515c:	854a                	mv	a0,s2
    8000515e:	e48fe0ef          	jal	800037a6 <iunlockput>
    goto bad;
    80005162:	694e                	ld	s2,208(sp)
    80005164:	69ae                	ld	s3,200(sp)
    80005166:	bff1                	j	80005142 <sys_unlink+0x160>

0000000080005168 <sys_open>:

uint64
sys_open(void)
{
    80005168:	7131                	addi	sp,sp,-192
    8000516a:	fd06                	sd	ra,184(sp)
    8000516c:	f922                	sd	s0,176(sp)
    8000516e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005170:	f4c40593          	addi	a1,s0,-180
    80005174:	4505                	li	a0,1
    80005176:	e1efd0ef          	jal	80002794 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000517a:	08000613          	li	a2,128
    8000517e:	f5040593          	addi	a1,s0,-176
    80005182:	4501                	li	a0,0
    80005184:	e48fd0ef          	jal	800027cc <argstr>
    80005188:	87aa                	mv	a5,a0
    return -1;
    8000518a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000518c:	0a07c263          	bltz	a5,80005230 <sys_open+0xc8>
    80005190:	f526                	sd	s1,168(sp)

  begin_op();
    80005192:	ca1fe0ef          	jal	80003e32 <begin_op>

  if(omode & O_CREATE){
    80005196:	f4c42783          	lw	a5,-180(s0)
    8000519a:	2007f793          	andi	a5,a5,512
    8000519e:	c3d5                	beqz	a5,80005242 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800051a0:	4681                	li	a3,0
    800051a2:	4601                	li	a2,0
    800051a4:	4589                	li	a1,2
    800051a6:	f5040513          	addi	a0,s0,-176
    800051aa:	aa9ff0ef          	jal	80004c52 <create>
    800051ae:	84aa                	mv	s1,a0
    if(ip == 0){
    800051b0:	c541                	beqz	a0,80005238 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800051b2:	04449703          	lh	a4,68(s1)
    800051b6:	478d                	li	a5,3
    800051b8:	00f71763          	bne	a4,a5,800051c6 <sys_open+0x5e>
    800051bc:	0464d703          	lhu	a4,70(s1)
    800051c0:	47a5                	li	a5,9
    800051c2:	0ae7ed63          	bltu	a5,a4,8000527c <sys_open+0x114>
    800051c6:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800051c8:	fe1fe0ef          	jal	800041a8 <filealloc>
    800051cc:	892a                	mv	s2,a0
    800051ce:	c179                	beqz	a0,80005294 <sys_open+0x12c>
    800051d0:	ed4e                	sd	s3,152(sp)
    800051d2:	a43ff0ef          	jal	80004c14 <fdalloc>
    800051d6:	89aa                	mv	s3,a0
    800051d8:	0a054a63          	bltz	a0,8000528c <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800051dc:	04449703          	lh	a4,68(s1)
    800051e0:	478d                	li	a5,3
    800051e2:	0cf70263          	beq	a4,a5,800052a6 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800051e6:	4789                	li	a5,2
    800051e8:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800051ec:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800051f0:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800051f4:	f4c42783          	lw	a5,-180(s0)
    800051f8:	0017c713          	xori	a4,a5,1
    800051fc:	8b05                	andi	a4,a4,1
    800051fe:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005202:	0037f713          	andi	a4,a5,3
    80005206:	00e03733          	snez	a4,a4
    8000520a:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000520e:	4007f793          	andi	a5,a5,1024
    80005212:	c791                	beqz	a5,8000521e <sys_open+0xb6>
    80005214:	04449703          	lh	a4,68(s1)
    80005218:	4789                	li	a5,2
    8000521a:	08f70d63          	beq	a4,a5,800052b4 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    8000521e:	8526                	mv	a0,s1
    80005220:	c2afe0ef          	jal	8000364a <iunlock>
  end_op();
    80005224:	c79fe0ef          	jal	80003e9c <end_op>

  return fd;
    80005228:	854e                	mv	a0,s3
    8000522a:	74aa                	ld	s1,168(sp)
    8000522c:	790a                	ld	s2,160(sp)
    8000522e:	69ea                	ld	s3,152(sp)
}
    80005230:	70ea                	ld	ra,184(sp)
    80005232:	744a                	ld	s0,176(sp)
    80005234:	6129                	addi	sp,sp,192
    80005236:	8082                	ret
      end_op();
    80005238:	c65fe0ef          	jal	80003e9c <end_op>
      return -1;
    8000523c:	557d                	li	a0,-1
    8000523e:	74aa                	ld	s1,168(sp)
    80005240:	bfc5                	j	80005230 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80005242:	f5040513          	addi	a0,s0,-176
    80005246:	a31fe0ef          	jal	80003c76 <namei>
    8000524a:	84aa                	mv	s1,a0
    8000524c:	c11d                	beqz	a0,80005272 <sys_open+0x10a>
    ilock(ip);
    8000524e:	b4efe0ef          	jal	8000359c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005252:	04449703          	lh	a4,68(s1)
    80005256:	4785                	li	a5,1
    80005258:	f4f71de3          	bne	a4,a5,800051b2 <sys_open+0x4a>
    8000525c:	f4c42783          	lw	a5,-180(s0)
    80005260:	d3bd                	beqz	a5,800051c6 <sys_open+0x5e>
      iunlockput(ip);
    80005262:	8526                	mv	a0,s1
    80005264:	d42fe0ef          	jal	800037a6 <iunlockput>
      end_op();
    80005268:	c35fe0ef          	jal	80003e9c <end_op>
      return -1;
    8000526c:	557d                	li	a0,-1
    8000526e:	74aa                	ld	s1,168(sp)
    80005270:	b7c1                	j	80005230 <sys_open+0xc8>
      end_op();
    80005272:	c2bfe0ef          	jal	80003e9c <end_op>
      return -1;
    80005276:	557d                	li	a0,-1
    80005278:	74aa                	ld	s1,168(sp)
    8000527a:	bf5d                	j	80005230 <sys_open+0xc8>
    iunlockput(ip);
    8000527c:	8526                	mv	a0,s1
    8000527e:	d28fe0ef          	jal	800037a6 <iunlockput>
    end_op();
    80005282:	c1bfe0ef          	jal	80003e9c <end_op>
    return -1;
    80005286:	557d                	li	a0,-1
    80005288:	74aa                	ld	s1,168(sp)
    8000528a:	b75d                	j	80005230 <sys_open+0xc8>
      fileclose(f);
    8000528c:	854a                	mv	a0,s2
    8000528e:	fbffe0ef          	jal	8000424c <fileclose>
    80005292:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005294:	8526                	mv	a0,s1
    80005296:	d10fe0ef          	jal	800037a6 <iunlockput>
    end_op();
    8000529a:	c03fe0ef          	jal	80003e9c <end_op>
    return -1;
    8000529e:	557d                	li	a0,-1
    800052a0:	74aa                	ld	s1,168(sp)
    800052a2:	790a                	ld	s2,160(sp)
    800052a4:	b771                	j	80005230 <sys_open+0xc8>
    f->type = FD_DEVICE;
    800052a6:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800052aa:	04649783          	lh	a5,70(s1)
    800052ae:	02f91223          	sh	a5,36(s2)
    800052b2:	bf3d                	j	800051f0 <sys_open+0x88>
    itrunc(ip);
    800052b4:	8526                	mv	a0,s1
    800052b6:	bd4fe0ef          	jal	8000368a <itrunc>
    800052ba:	b795                	j	8000521e <sys_open+0xb6>

00000000800052bc <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800052bc:	7175                	addi	sp,sp,-144
    800052be:	e506                	sd	ra,136(sp)
    800052c0:	e122                	sd	s0,128(sp)
    800052c2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800052c4:	b6ffe0ef          	jal	80003e32 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800052c8:	08000613          	li	a2,128
    800052cc:	f7040593          	addi	a1,s0,-144
    800052d0:	4501                	li	a0,0
    800052d2:	cfafd0ef          	jal	800027cc <argstr>
    800052d6:	02054363          	bltz	a0,800052fc <sys_mkdir+0x40>
    800052da:	4681                	li	a3,0
    800052dc:	4601                	li	a2,0
    800052de:	4585                	li	a1,1
    800052e0:	f7040513          	addi	a0,s0,-144
    800052e4:	96fff0ef          	jal	80004c52 <create>
    800052e8:	c911                	beqz	a0,800052fc <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800052ea:	cbcfe0ef          	jal	800037a6 <iunlockput>
  end_op();
    800052ee:	baffe0ef          	jal	80003e9c <end_op>
  return 0;
    800052f2:	4501                	li	a0,0
}
    800052f4:	60aa                	ld	ra,136(sp)
    800052f6:	640a                	ld	s0,128(sp)
    800052f8:	6149                	addi	sp,sp,144
    800052fa:	8082                	ret
    end_op();
    800052fc:	ba1fe0ef          	jal	80003e9c <end_op>
    return -1;
    80005300:	557d                	li	a0,-1
    80005302:	bfcd                	j	800052f4 <sys_mkdir+0x38>

0000000080005304 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005304:	7135                	addi	sp,sp,-160
    80005306:	ed06                	sd	ra,152(sp)
    80005308:	e922                	sd	s0,144(sp)
    8000530a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000530c:	b27fe0ef          	jal	80003e32 <begin_op>
  argint(1, &major);
    80005310:	f6c40593          	addi	a1,s0,-148
    80005314:	4505                	li	a0,1
    80005316:	c7efd0ef          	jal	80002794 <argint>
  argint(2, &minor);
    8000531a:	f6840593          	addi	a1,s0,-152
    8000531e:	4509                	li	a0,2
    80005320:	c74fd0ef          	jal	80002794 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005324:	08000613          	li	a2,128
    80005328:	f7040593          	addi	a1,s0,-144
    8000532c:	4501                	li	a0,0
    8000532e:	c9efd0ef          	jal	800027cc <argstr>
    80005332:	02054563          	bltz	a0,8000535c <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005336:	f6841683          	lh	a3,-152(s0)
    8000533a:	f6c41603          	lh	a2,-148(s0)
    8000533e:	458d                	li	a1,3
    80005340:	f7040513          	addi	a0,s0,-144
    80005344:	90fff0ef          	jal	80004c52 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005348:	c911                	beqz	a0,8000535c <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000534a:	c5cfe0ef          	jal	800037a6 <iunlockput>
  end_op();
    8000534e:	b4ffe0ef          	jal	80003e9c <end_op>
  return 0;
    80005352:	4501                	li	a0,0
}
    80005354:	60ea                	ld	ra,152(sp)
    80005356:	644a                	ld	s0,144(sp)
    80005358:	610d                	addi	sp,sp,160
    8000535a:	8082                	ret
    end_op();
    8000535c:	b41fe0ef          	jal	80003e9c <end_op>
    return -1;
    80005360:	557d                	li	a0,-1
    80005362:	bfcd                	j	80005354 <sys_mknod+0x50>

0000000080005364 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005364:	7135                	addi	sp,sp,-160
    80005366:	ed06                	sd	ra,152(sp)
    80005368:	e922                	sd	s0,144(sp)
    8000536a:	e14a                	sd	s2,128(sp)
    8000536c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000536e:	d72fc0ef          	jal	800018e0 <myproc>
    80005372:	892a                	mv	s2,a0
  
  begin_op();
    80005374:	abffe0ef          	jal	80003e32 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005378:	08000613          	li	a2,128
    8000537c:	f6040593          	addi	a1,s0,-160
    80005380:	4501                	li	a0,0
    80005382:	c4afd0ef          	jal	800027cc <argstr>
    80005386:	04054363          	bltz	a0,800053cc <sys_chdir+0x68>
    8000538a:	e526                	sd	s1,136(sp)
    8000538c:	f6040513          	addi	a0,s0,-160
    80005390:	8e7fe0ef          	jal	80003c76 <namei>
    80005394:	84aa                	mv	s1,a0
    80005396:	c915                	beqz	a0,800053ca <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005398:	a04fe0ef          	jal	8000359c <ilock>
  if(ip->type != T_DIR){
    8000539c:	04449703          	lh	a4,68(s1)
    800053a0:	4785                	li	a5,1
    800053a2:	02f71963          	bne	a4,a5,800053d4 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800053a6:	8526                	mv	a0,s1
    800053a8:	aa2fe0ef          	jal	8000364a <iunlock>
  iput(p->cwd);
    800053ac:	15093503          	ld	a0,336(s2)
    800053b0:	b6efe0ef          	jal	8000371e <iput>
  end_op();
    800053b4:	ae9fe0ef          	jal	80003e9c <end_op>
  p->cwd = ip;
    800053b8:	14993823          	sd	s1,336(s2)
  return 0;
    800053bc:	4501                	li	a0,0
    800053be:	64aa                	ld	s1,136(sp)
}
    800053c0:	60ea                	ld	ra,152(sp)
    800053c2:	644a                	ld	s0,144(sp)
    800053c4:	690a                	ld	s2,128(sp)
    800053c6:	610d                	addi	sp,sp,160
    800053c8:	8082                	ret
    800053ca:	64aa                	ld	s1,136(sp)
    end_op();
    800053cc:	ad1fe0ef          	jal	80003e9c <end_op>
    return -1;
    800053d0:	557d                	li	a0,-1
    800053d2:	b7fd                	j	800053c0 <sys_chdir+0x5c>
    iunlockput(ip);
    800053d4:	8526                	mv	a0,s1
    800053d6:	bd0fe0ef          	jal	800037a6 <iunlockput>
    end_op();
    800053da:	ac3fe0ef          	jal	80003e9c <end_op>
    return -1;
    800053de:	557d                	li	a0,-1
    800053e0:	64aa                	ld	s1,136(sp)
    800053e2:	bff9                	j	800053c0 <sys_chdir+0x5c>

00000000800053e4 <sys_exec>:

uint64
sys_exec(void)
{
    800053e4:	7121                	addi	sp,sp,-448
    800053e6:	ff06                	sd	ra,440(sp)
    800053e8:	fb22                	sd	s0,432(sp)
    800053ea:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800053ec:	e4840593          	addi	a1,s0,-440
    800053f0:	4505                	li	a0,1
    800053f2:	bbefd0ef          	jal	800027b0 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800053f6:	08000613          	li	a2,128
    800053fa:	f5040593          	addi	a1,s0,-176
    800053fe:	4501                	li	a0,0
    80005400:	bccfd0ef          	jal	800027cc <argstr>
    80005404:	87aa                	mv	a5,a0
    return -1;
    80005406:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005408:	0c07c463          	bltz	a5,800054d0 <sys_exec+0xec>
    8000540c:	f726                	sd	s1,424(sp)
    8000540e:	f34a                	sd	s2,416(sp)
    80005410:	ef4e                	sd	s3,408(sp)
    80005412:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005414:	10000613          	li	a2,256
    80005418:	4581                	li	a1,0
    8000541a:	e5040513          	addi	a0,s0,-432
    8000541e:	8abfb0ef          	jal	80000cc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005422:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005426:	89a6                	mv	s3,s1
    80005428:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000542a:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000542e:	00391513          	slli	a0,s2,0x3
    80005432:	e4040593          	addi	a1,s0,-448
    80005436:	e4843783          	ld	a5,-440(s0)
    8000543a:	953e                	add	a0,a0,a5
    8000543c:	acefd0ef          	jal	8000270a <fetchaddr>
    80005440:	02054663          	bltz	a0,8000546c <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80005444:	e4043783          	ld	a5,-448(s0)
    80005448:	c3a9                	beqz	a5,8000548a <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000544a:	edafb0ef          	jal	80000b24 <kalloc>
    8000544e:	85aa                	mv	a1,a0
    80005450:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005454:	cd01                	beqz	a0,8000546c <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005456:	6605                	lui	a2,0x1
    80005458:	e4043503          	ld	a0,-448(s0)
    8000545c:	af8fd0ef          	jal	80002754 <fetchstr>
    80005460:	00054663          	bltz	a0,8000546c <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80005464:	0905                	addi	s2,s2,1
    80005466:	09a1                	addi	s3,s3,8
    80005468:	fd4913e3          	bne	s2,s4,8000542e <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000546c:	f5040913          	addi	s2,s0,-176
    80005470:	6088                	ld	a0,0(s1)
    80005472:	c931                	beqz	a0,800054c6 <sys_exec+0xe2>
    kfree(argv[i]);
    80005474:	dcefb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005478:	04a1                	addi	s1,s1,8
    8000547a:	ff249be3          	bne	s1,s2,80005470 <sys_exec+0x8c>
  return -1;
    8000547e:	557d                	li	a0,-1
    80005480:	74ba                	ld	s1,424(sp)
    80005482:	791a                	ld	s2,416(sp)
    80005484:	69fa                	ld	s3,408(sp)
    80005486:	6a5a                	ld	s4,400(sp)
    80005488:	a0a1                	j	800054d0 <sys_exec+0xec>
      argv[i] = 0;
    8000548a:	0009079b          	sext.w	a5,s2
    8000548e:	078e                	slli	a5,a5,0x3
    80005490:	fd078793          	addi	a5,a5,-48
    80005494:	97a2                	add	a5,a5,s0
    80005496:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000549a:	e5040593          	addi	a1,s0,-432
    8000549e:	f5040513          	addi	a0,s0,-176
    800054a2:	ba8ff0ef          	jal	8000484a <exec>
    800054a6:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054a8:	f5040993          	addi	s3,s0,-176
    800054ac:	6088                	ld	a0,0(s1)
    800054ae:	c511                	beqz	a0,800054ba <sys_exec+0xd6>
    kfree(argv[i]);
    800054b0:	d92fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054b4:	04a1                	addi	s1,s1,8
    800054b6:	ff349be3          	bne	s1,s3,800054ac <sys_exec+0xc8>
  return ret;
    800054ba:	854a                	mv	a0,s2
    800054bc:	74ba                	ld	s1,424(sp)
    800054be:	791a                	ld	s2,416(sp)
    800054c0:	69fa                	ld	s3,408(sp)
    800054c2:	6a5a                	ld	s4,400(sp)
    800054c4:	a031                	j	800054d0 <sys_exec+0xec>
  return -1;
    800054c6:	557d                	li	a0,-1
    800054c8:	74ba                	ld	s1,424(sp)
    800054ca:	791a                	ld	s2,416(sp)
    800054cc:	69fa                	ld	s3,408(sp)
    800054ce:	6a5a                	ld	s4,400(sp)
}
    800054d0:	70fa                	ld	ra,440(sp)
    800054d2:	745a                	ld	s0,432(sp)
    800054d4:	6139                	addi	sp,sp,448
    800054d6:	8082                	ret

00000000800054d8 <sys_pipe>:

uint64
sys_pipe(void)
{
    800054d8:	7139                	addi	sp,sp,-64
    800054da:	fc06                	sd	ra,56(sp)
    800054dc:	f822                	sd	s0,48(sp)
    800054de:	f426                	sd	s1,40(sp)
    800054e0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800054e2:	bfefc0ef          	jal	800018e0 <myproc>
    800054e6:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800054e8:	fd840593          	addi	a1,s0,-40
    800054ec:	4501                	li	a0,0
    800054ee:	ac2fd0ef          	jal	800027b0 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800054f2:	fc840593          	addi	a1,s0,-56
    800054f6:	fd040513          	addi	a0,s0,-48
    800054fa:	85cff0ef          	jal	80004556 <pipealloc>
    return -1;
    800054fe:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005500:	0a054463          	bltz	a0,800055a8 <sys_pipe+0xd0>
  fd0 = -1;
    80005504:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005508:	fd043503          	ld	a0,-48(s0)
    8000550c:	f08ff0ef          	jal	80004c14 <fdalloc>
    80005510:	fca42223          	sw	a0,-60(s0)
    80005514:	08054163          	bltz	a0,80005596 <sys_pipe+0xbe>
    80005518:	fc843503          	ld	a0,-56(s0)
    8000551c:	ef8ff0ef          	jal	80004c14 <fdalloc>
    80005520:	fca42023          	sw	a0,-64(s0)
    80005524:	06054063          	bltz	a0,80005584 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005528:	4691                	li	a3,4
    8000552a:	fc440613          	addi	a2,s0,-60
    8000552e:	fd843583          	ld	a1,-40(s0)
    80005532:	68a8                	ld	a0,80(s1)
    80005534:	81efc0ef          	jal	80001552 <copyout>
    80005538:	00054e63          	bltz	a0,80005554 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000553c:	4691                	li	a3,4
    8000553e:	fc040613          	addi	a2,s0,-64
    80005542:	fd843583          	ld	a1,-40(s0)
    80005546:	0591                	addi	a1,a1,4
    80005548:	68a8                	ld	a0,80(s1)
    8000554a:	808fc0ef          	jal	80001552 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000554e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005550:	04055c63          	bgez	a0,800055a8 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005554:	fc442783          	lw	a5,-60(s0)
    80005558:	07e9                	addi	a5,a5,26
    8000555a:	078e                	slli	a5,a5,0x3
    8000555c:	97a6                	add	a5,a5,s1
    8000555e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005562:	fc042783          	lw	a5,-64(s0)
    80005566:	07e9                	addi	a5,a5,26
    80005568:	078e                	slli	a5,a5,0x3
    8000556a:	94be                	add	s1,s1,a5
    8000556c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005570:	fd043503          	ld	a0,-48(s0)
    80005574:	cd9fe0ef          	jal	8000424c <fileclose>
    fileclose(wf);
    80005578:	fc843503          	ld	a0,-56(s0)
    8000557c:	cd1fe0ef          	jal	8000424c <fileclose>
    return -1;
    80005580:	57fd                	li	a5,-1
    80005582:	a01d                	j	800055a8 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005584:	fc442783          	lw	a5,-60(s0)
    80005588:	0007c763          	bltz	a5,80005596 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000558c:	07e9                	addi	a5,a5,26
    8000558e:	078e                	slli	a5,a5,0x3
    80005590:	97a6                	add	a5,a5,s1
    80005592:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005596:	fd043503          	ld	a0,-48(s0)
    8000559a:	cb3fe0ef          	jal	8000424c <fileclose>
    fileclose(wf);
    8000559e:	fc843503          	ld	a0,-56(s0)
    800055a2:	cabfe0ef          	jal	8000424c <fileclose>
    return -1;
    800055a6:	57fd                	li	a5,-1
}
    800055a8:	853e                	mv	a0,a5
    800055aa:	70e2                	ld	ra,56(sp)
    800055ac:	7442                	ld	s0,48(sp)
    800055ae:	74a2                	ld	s1,40(sp)
    800055b0:	6121                	addi	sp,sp,64
    800055b2:	8082                	ret
	...

00000000800055c0 <kernelvec>:
    800055c0:	7111                	addi	sp,sp,-256
    800055c2:	e006                	sd	ra,0(sp)
    800055c4:	e40a                	sd	sp,8(sp)
    800055c6:	e80e                	sd	gp,16(sp)
    800055c8:	ec12                	sd	tp,24(sp)
    800055ca:	f016                	sd	t0,32(sp)
    800055cc:	f41a                	sd	t1,40(sp)
    800055ce:	f81e                	sd	t2,48(sp)
    800055d0:	e4aa                	sd	a0,72(sp)
    800055d2:	e8ae                	sd	a1,80(sp)
    800055d4:	ecb2                	sd	a2,88(sp)
    800055d6:	f0b6                	sd	a3,96(sp)
    800055d8:	f4ba                	sd	a4,104(sp)
    800055da:	f8be                	sd	a5,112(sp)
    800055dc:	fcc2                	sd	a6,120(sp)
    800055de:	e146                	sd	a7,128(sp)
    800055e0:	edf2                	sd	t3,216(sp)
    800055e2:	f1f6                	sd	t4,224(sp)
    800055e4:	f5fa                	sd	t5,232(sp)
    800055e6:	f9fe                	sd	t6,240(sp)
    800055e8:	832fd0ef          	jal	8000261a <kerneltrap>
    800055ec:	6082                	ld	ra,0(sp)
    800055ee:	6122                	ld	sp,8(sp)
    800055f0:	61c2                	ld	gp,16(sp)
    800055f2:	7282                	ld	t0,32(sp)
    800055f4:	7322                	ld	t1,40(sp)
    800055f6:	73c2                	ld	t2,48(sp)
    800055f8:	6526                	ld	a0,72(sp)
    800055fa:	65c6                	ld	a1,80(sp)
    800055fc:	6666                	ld	a2,88(sp)
    800055fe:	7686                	ld	a3,96(sp)
    80005600:	7726                	ld	a4,104(sp)
    80005602:	77c6                	ld	a5,112(sp)
    80005604:	7866                	ld	a6,120(sp)
    80005606:	688a                	ld	a7,128(sp)
    80005608:	6e6e                	ld	t3,216(sp)
    8000560a:	7e8e                	ld	t4,224(sp)
    8000560c:	7f2e                	ld	t5,232(sp)
    8000560e:	7fce                	ld	t6,240(sp)
    80005610:	6111                	addi	sp,sp,256
    80005612:	10200073          	sret
	...

000000008000561e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000561e:	1141                	addi	sp,sp,-16
    80005620:	e422                	sd	s0,8(sp)
    80005622:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005624:	0c0007b7          	lui	a5,0xc000
    80005628:	4705                	li	a4,1
    8000562a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000562c:	0c0007b7          	lui	a5,0xc000
    80005630:	c3d8                	sw	a4,4(a5)
}
    80005632:	6422                	ld	s0,8(sp)
    80005634:	0141                	addi	sp,sp,16
    80005636:	8082                	ret

0000000080005638 <plicinithart>:

void
plicinithart(void)
{
    80005638:	1141                	addi	sp,sp,-16
    8000563a:	e406                	sd	ra,8(sp)
    8000563c:	e022                	sd	s0,0(sp)
    8000563e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005640:	a74fc0ef          	jal	800018b4 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005644:	0085171b          	slliw	a4,a0,0x8
    80005648:	0c0027b7          	lui	a5,0xc002
    8000564c:	97ba                	add	a5,a5,a4
    8000564e:	40200713          	li	a4,1026
    80005652:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005656:	00d5151b          	slliw	a0,a0,0xd
    8000565a:	0c2017b7          	lui	a5,0xc201
    8000565e:	97aa                	add	a5,a5,a0
    80005660:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005664:	60a2                	ld	ra,8(sp)
    80005666:	6402                	ld	s0,0(sp)
    80005668:	0141                	addi	sp,sp,16
    8000566a:	8082                	ret

000000008000566c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000566c:	1141                	addi	sp,sp,-16
    8000566e:	e406                	sd	ra,8(sp)
    80005670:	e022                	sd	s0,0(sp)
    80005672:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005674:	a40fc0ef          	jal	800018b4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005678:	00d5151b          	slliw	a0,a0,0xd
    8000567c:	0c2017b7          	lui	a5,0xc201
    80005680:	97aa                	add	a5,a5,a0
  return irq;
}
    80005682:	43c8                	lw	a0,4(a5)
    80005684:	60a2                	ld	ra,8(sp)
    80005686:	6402                	ld	s0,0(sp)
    80005688:	0141                	addi	sp,sp,16
    8000568a:	8082                	ret

000000008000568c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000568c:	1101                	addi	sp,sp,-32
    8000568e:	ec06                	sd	ra,24(sp)
    80005690:	e822                	sd	s0,16(sp)
    80005692:	e426                	sd	s1,8(sp)
    80005694:	1000                	addi	s0,sp,32
    80005696:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005698:	a1cfc0ef          	jal	800018b4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000569c:	00d5151b          	slliw	a0,a0,0xd
    800056a0:	0c2017b7          	lui	a5,0xc201
    800056a4:	97aa                	add	a5,a5,a0
    800056a6:	c3c4                	sw	s1,4(a5)
}
    800056a8:	60e2                	ld	ra,24(sp)
    800056aa:	6442                	ld	s0,16(sp)
    800056ac:	64a2                	ld	s1,8(sp)
    800056ae:	6105                	addi	sp,sp,32
    800056b0:	8082                	ret

00000000800056b2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800056b2:	1141                	addi	sp,sp,-16
    800056b4:	e406                	sd	ra,8(sp)
    800056b6:	e022                	sd	s0,0(sp)
    800056b8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800056ba:	479d                	li	a5,7
    800056bc:	04a7ca63          	blt	a5,a0,80005710 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800056c0:	0001e797          	auipc	a5,0x1e
    800056c4:	27078793          	addi	a5,a5,624 # 80023930 <disk>
    800056c8:	97aa                	add	a5,a5,a0
    800056ca:	0187c783          	lbu	a5,24(a5)
    800056ce:	e7b9                	bnez	a5,8000571c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800056d0:	00451693          	slli	a3,a0,0x4
    800056d4:	0001e797          	auipc	a5,0x1e
    800056d8:	25c78793          	addi	a5,a5,604 # 80023930 <disk>
    800056dc:	6398                	ld	a4,0(a5)
    800056de:	9736                	add	a4,a4,a3
    800056e0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800056e4:	6398                	ld	a4,0(a5)
    800056e6:	9736                	add	a4,a4,a3
    800056e8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800056ec:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800056f0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800056f4:	97aa                	add	a5,a5,a0
    800056f6:	4705                	li	a4,1
    800056f8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800056fc:	0001e517          	auipc	a0,0x1e
    80005700:	24c50513          	addi	a0,a0,588 # 80023948 <disk+0x18>
    80005704:	ff6fc0ef          	jal	80001efa <wakeup>
}
    80005708:	60a2                	ld	ra,8(sp)
    8000570a:	6402                	ld	s0,0(sp)
    8000570c:	0141                	addi	sp,sp,16
    8000570e:	8082                	ret
    panic("free_desc 1");
    80005710:	00002517          	auipc	a0,0x2
    80005714:	32050513          	addi	a0,a0,800 # 80007a30 <etext+0xa30>
    80005718:	87cfb0ef          	jal	80000794 <panic>
    panic("free_desc 2");
    8000571c:	00002517          	auipc	a0,0x2
    80005720:	32450513          	addi	a0,a0,804 # 80007a40 <etext+0xa40>
    80005724:	870fb0ef          	jal	80000794 <panic>

0000000080005728 <virtio_disk_init>:
{
    80005728:	1101                	addi	sp,sp,-32
    8000572a:	ec06                	sd	ra,24(sp)
    8000572c:	e822                	sd	s0,16(sp)
    8000572e:	e426                	sd	s1,8(sp)
    80005730:	e04a                	sd	s2,0(sp)
    80005732:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005734:	00002597          	auipc	a1,0x2
    80005738:	31c58593          	addi	a1,a1,796 # 80007a50 <etext+0xa50>
    8000573c:	0001e517          	auipc	a0,0x1e
    80005740:	31c50513          	addi	a0,a0,796 # 80023a58 <disk+0x128>
    80005744:	c30fb0ef          	jal	80000b74 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005748:	100017b7          	lui	a5,0x10001
    8000574c:	4398                	lw	a4,0(a5)
    8000574e:	2701                	sext.w	a4,a4
    80005750:	747277b7          	lui	a5,0x74727
    80005754:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005758:	18f71063          	bne	a4,a5,800058d8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000575c:	100017b7          	lui	a5,0x10001
    80005760:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005762:	439c                	lw	a5,0(a5)
    80005764:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005766:	4709                	li	a4,2
    80005768:	16e79863          	bne	a5,a4,800058d8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000576c:	100017b7          	lui	a5,0x10001
    80005770:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005772:	439c                	lw	a5,0(a5)
    80005774:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005776:	16e79163          	bne	a5,a4,800058d8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000577a:	100017b7          	lui	a5,0x10001
    8000577e:	47d8                	lw	a4,12(a5)
    80005780:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005782:	554d47b7          	lui	a5,0x554d4
    80005786:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000578a:	14f71763          	bne	a4,a5,800058d8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000578e:	100017b7          	lui	a5,0x10001
    80005792:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005796:	4705                	li	a4,1
    80005798:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000579a:	470d                	li	a4,3
    8000579c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000579e:	10001737          	lui	a4,0x10001
    800057a2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800057a4:	c7ffe737          	lui	a4,0xc7ffe
    800057a8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdacef>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800057ac:	8ef9                	and	a3,a3,a4
    800057ae:	10001737          	lui	a4,0x10001
    800057b2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800057b4:	472d                	li	a4,11
    800057b6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800057b8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800057bc:	439c                	lw	a5,0(a5)
    800057be:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800057c2:	8ba1                	andi	a5,a5,8
    800057c4:	12078063          	beqz	a5,800058e4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800057c8:	100017b7          	lui	a5,0x10001
    800057cc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800057d0:	100017b7          	lui	a5,0x10001
    800057d4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800057d8:	439c                	lw	a5,0(a5)
    800057da:	2781                	sext.w	a5,a5
    800057dc:	10079a63          	bnez	a5,800058f0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800057e0:	100017b7          	lui	a5,0x10001
    800057e4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800057e8:	439c                	lw	a5,0(a5)
    800057ea:	2781                	sext.w	a5,a5
  if(max == 0)
    800057ec:	10078863          	beqz	a5,800058fc <virtio_disk_init+0x1d4>
  if(max < NUM)
    800057f0:	471d                	li	a4,7
    800057f2:	10f77b63          	bgeu	a4,a5,80005908 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    800057f6:	b2efb0ef          	jal	80000b24 <kalloc>
    800057fa:	0001e497          	auipc	s1,0x1e
    800057fe:	13648493          	addi	s1,s1,310 # 80023930 <disk>
    80005802:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005804:	b20fb0ef          	jal	80000b24 <kalloc>
    80005808:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000580a:	b1afb0ef          	jal	80000b24 <kalloc>
    8000580e:	87aa                	mv	a5,a0
    80005810:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005812:	6088                	ld	a0,0(s1)
    80005814:	10050063          	beqz	a0,80005914 <virtio_disk_init+0x1ec>
    80005818:	0001e717          	auipc	a4,0x1e
    8000581c:	12073703          	ld	a4,288(a4) # 80023938 <disk+0x8>
    80005820:	0e070a63          	beqz	a4,80005914 <virtio_disk_init+0x1ec>
    80005824:	0e078863          	beqz	a5,80005914 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005828:	6605                	lui	a2,0x1
    8000582a:	4581                	li	a1,0
    8000582c:	c9cfb0ef          	jal	80000cc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005830:	0001e497          	auipc	s1,0x1e
    80005834:	10048493          	addi	s1,s1,256 # 80023930 <disk>
    80005838:	6605                	lui	a2,0x1
    8000583a:	4581                	li	a1,0
    8000583c:	6488                	ld	a0,8(s1)
    8000583e:	c8afb0ef          	jal	80000cc8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005842:	6605                	lui	a2,0x1
    80005844:	4581                	li	a1,0
    80005846:	6888                	ld	a0,16(s1)
    80005848:	c80fb0ef          	jal	80000cc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000584c:	100017b7          	lui	a5,0x10001
    80005850:	4721                	li	a4,8
    80005852:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005854:	4098                	lw	a4,0(s1)
    80005856:	100017b7          	lui	a5,0x10001
    8000585a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000585e:	40d8                	lw	a4,4(s1)
    80005860:	100017b7          	lui	a5,0x10001
    80005864:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005868:	649c                	ld	a5,8(s1)
    8000586a:	0007869b          	sext.w	a3,a5
    8000586e:	10001737          	lui	a4,0x10001
    80005872:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005876:	9781                	srai	a5,a5,0x20
    80005878:	10001737          	lui	a4,0x10001
    8000587c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005880:	689c                	ld	a5,16(s1)
    80005882:	0007869b          	sext.w	a3,a5
    80005886:	10001737          	lui	a4,0x10001
    8000588a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000588e:	9781                	srai	a5,a5,0x20
    80005890:	10001737          	lui	a4,0x10001
    80005894:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005898:	10001737          	lui	a4,0x10001
    8000589c:	4785                	li	a5,1
    8000589e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800058a0:	00f48c23          	sb	a5,24(s1)
    800058a4:	00f48ca3          	sb	a5,25(s1)
    800058a8:	00f48d23          	sb	a5,26(s1)
    800058ac:	00f48da3          	sb	a5,27(s1)
    800058b0:	00f48e23          	sb	a5,28(s1)
    800058b4:	00f48ea3          	sb	a5,29(s1)
    800058b8:	00f48f23          	sb	a5,30(s1)
    800058bc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800058c0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800058c4:	100017b7          	lui	a5,0x10001
    800058c8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800058cc:	60e2                	ld	ra,24(sp)
    800058ce:	6442                	ld	s0,16(sp)
    800058d0:	64a2                	ld	s1,8(sp)
    800058d2:	6902                	ld	s2,0(sp)
    800058d4:	6105                	addi	sp,sp,32
    800058d6:	8082                	ret
    panic("could not find virtio disk");
    800058d8:	00002517          	auipc	a0,0x2
    800058dc:	18850513          	addi	a0,a0,392 # 80007a60 <etext+0xa60>
    800058e0:	eb5fa0ef          	jal	80000794 <panic>
    panic("virtio disk FEATURES_OK unset");
    800058e4:	00002517          	auipc	a0,0x2
    800058e8:	19c50513          	addi	a0,a0,412 # 80007a80 <etext+0xa80>
    800058ec:	ea9fa0ef          	jal	80000794 <panic>
    panic("virtio disk should not be ready");
    800058f0:	00002517          	auipc	a0,0x2
    800058f4:	1b050513          	addi	a0,a0,432 # 80007aa0 <etext+0xaa0>
    800058f8:	e9dfa0ef          	jal	80000794 <panic>
    panic("virtio disk has no queue 0");
    800058fc:	00002517          	auipc	a0,0x2
    80005900:	1c450513          	addi	a0,a0,452 # 80007ac0 <etext+0xac0>
    80005904:	e91fa0ef          	jal	80000794 <panic>
    panic("virtio disk max queue too short");
    80005908:	00002517          	auipc	a0,0x2
    8000590c:	1d850513          	addi	a0,a0,472 # 80007ae0 <etext+0xae0>
    80005910:	e85fa0ef          	jal	80000794 <panic>
    panic("virtio disk kalloc");
    80005914:	00002517          	auipc	a0,0x2
    80005918:	1ec50513          	addi	a0,a0,492 # 80007b00 <etext+0xb00>
    8000591c:	e79fa0ef          	jal	80000794 <panic>

0000000080005920 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005920:	7159                	addi	sp,sp,-112
    80005922:	f486                	sd	ra,104(sp)
    80005924:	f0a2                	sd	s0,96(sp)
    80005926:	eca6                	sd	s1,88(sp)
    80005928:	e8ca                	sd	s2,80(sp)
    8000592a:	e4ce                	sd	s3,72(sp)
    8000592c:	e0d2                	sd	s4,64(sp)
    8000592e:	fc56                	sd	s5,56(sp)
    80005930:	f85a                	sd	s6,48(sp)
    80005932:	f45e                	sd	s7,40(sp)
    80005934:	f062                	sd	s8,32(sp)
    80005936:	ec66                	sd	s9,24(sp)
    80005938:	1880                	addi	s0,sp,112
    8000593a:	8a2a                	mv	s4,a0
    8000593c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000593e:	00c52c83          	lw	s9,12(a0)
    80005942:	001c9c9b          	slliw	s9,s9,0x1
    80005946:	1c82                	slli	s9,s9,0x20
    80005948:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000594c:	0001e517          	auipc	a0,0x1e
    80005950:	10c50513          	addi	a0,a0,268 # 80023a58 <disk+0x128>
    80005954:	aa0fb0ef          	jal	80000bf4 <acquire>
  for(int i = 0; i < 3; i++){
    80005958:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000595a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000595c:	0001eb17          	auipc	s6,0x1e
    80005960:	fd4b0b13          	addi	s6,s6,-44 # 80023930 <disk>
  for(int i = 0; i < 3; i++){
    80005964:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005966:	0001ec17          	auipc	s8,0x1e
    8000596a:	0f2c0c13          	addi	s8,s8,242 # 80023a58 <disk+0x128>
    8000596e:	a8b9                	j	800059cc <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005970:	00fb0733          	add	a4,s6,a5
    80005974:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005978:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000597a:	0207c563          	bltz	a5,800059a4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    8000597e:	2905                	addiw	s2,s2,1
    80005980:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005982:	05590963          	beq	s2,s5,800059d4 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005986:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005988:	0001e717          	auipc	a4,0x1e
    8000598c:	fa870713          	addi	a4,a4,-88 # 80023930 <disk>
    80005990:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005992:	01874683          	lbu	a3,24(a4)
    80005996:	fee9                	bnez	a3,80005970 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005998:	2785                	addiw	a5,a5,1
    8000599a:	0705                	addi	a4,a4,1
    8000599c:	fe979be3          	bne	a5,s1,80005992 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800059a0:	57fd                	li	a5,-1
    800059a2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800059a4:	01205d63          	blez	s2,800059be <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800059a8:	f9042503          	lw	a0,-112(s0)
    800059ac:	d07ff0ef          	jal	800056b2 <free_desc>
      for(int j = 0; j < i; j++)
    800059b0:	4785                	li	a5,1
    800059b2:	0127d663          	bge	a5,s2,800059be <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800059b6:	f9442503          	lw	a0,-108(s0)
    800059ba:	cf9ff0ef          	jal	800056b2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800059be:	85e2                	mv	a1,s8
    800059c0:	0001e517          	auipc	a0,0x1e
    800059c4:	f8850513          	addi	a0,a0,-120 # 80023948 <disk+0x18>
    800059c8:	ce6fc0ef          	jal	80001eae <sleep>
  for(int i = 0; i < 3; i++){
    800059cc:	f9040613          	addi	a2,s0,-112
    800059d0:	894e                	mv	s2,s3
    800059d2:	bf55                	j	80005986 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800059d4:	f9042503          	lw	a0,-112(s0)
    800059d8:	00451693          	slli	a3,a0,0x4

  if(write)
    800059dc:	0001e797          	auipc	a5,0x1e
    800059e0:	f5478793          	addi	a5,a5,-172 # 80023930 <disk>
    800059e4:	00a50713          	addi	a4,a0,10
    800059e8:	0712                	slli	a4,a4,0x4
    800059ea:	973e                	add	a4,a4,a5
    800059ec:	01703633          	snez	a2,s7
    800059f0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800059f2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800059f6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800059fa:	6398                	ld	a4,0(a5)
    800059fc:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800059fe:	0a868613          	addi	a2,a3,168
    80005a02:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a04:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005a06:	6390                	ld	a2,0(a5)
    80005a08:	00d605b3          	add	a1,a2,a3
    80005a0c:	4741                	li	a4,16
    80005a0e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005a10:	4805                	li	a6,1
    80005a12:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005a16:	f9442703          	lw	a4,-108(s0)
    80005a1a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005a1e:	0712                	slli	a4,a4,0x4
    80005a20:	963a                	add	a2,a2,a4
    80005a22:	058a0593          	addi	a1,s4,88
    80005a26:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005a28:	0007b883          	ld	a7,0(a5)
    80005a2c:	9746                	add	a4,a4,a7
    80005a2e:	40000613          	li	a2,1024
    80005a32:	c710                	sw	a2,8(a4)
  if(write)
    80005a34:	001bb613          	seqz	a2,s7
    80005a38:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005a3c:	00166613          	ori	a2,a2,1
    80005a40:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005a44:	f9842583          	lw	a1,-104(s0)
    80005a48:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005a4c:	00250613          	addi	a2,a0,2
    80005a50:	0612                	slli	a2,a2,0x4
    80005a52:	963e                	add	a2,a2,a5
    80005a54:	577d                	li	a4,-1
    80005a56:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005a5a:	0592                	slli	a1,a1,0x4
    80005a5c:	98ae                	add	a7,a7,a1
    80005a5e:	03068713          	addi	a4,a3,48
    80005a62:	973e                	add	a4,a4,a5
    80005a64:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005a68:	6398                	ld	a4,0(a5)
    80005a6a:	972e                	add	a4,a4,a1
    80005a6c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005a70:	4689                	li	a3,2
    80005a72:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005a76:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005a7a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005a7e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005a82:	6794                	ld	a3,8(a5)
    80005a84:	0026d703          	lhu	a4,2(a3)
    80005a88:	8b1d                	andi	a4,a4,7
    80005a8a:	0706                	slli	a4,a4,0x1
    80005a8c:	96ba                	add	a3,a3,a4
    80005a8e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005a92:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005a96:	6798                	ld	a4,8(a5)
    80005a98:	00275783          	lhu	a5,2(a4)
    80005a9c:	2785                	addiw	a5,a5,1
    80005a9e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005aa2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005aa6:	100017b7          	lui	a5,0x10001
    80005aaa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005aae:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005ab2:	0001e917          	auipc	s2,0x1e
    80005ab6:	fa690913          	addi	s2,s2,-90 # 80023a58 <disk+0x128>
  while(b->disk == 1) {
    80005aba:	4485                	li	s1,1
    80005abc:	01079a63          	bne	a5,a6,80005ad0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005ac0:	85ca                	mv	a1,s2
    80005ac2:	8552                	mv	a0,s4
    80005ac4:	beafc0ef          	jal	80001eae <sleep>
  while(b->disk == 1) {
    80005ac8:	004a2783          	lw	a5,4(s4)
    80005acc:	fe978ae3          	beq	a5,s1,80005ac0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005ad0:	f9042903          	lw	s2,-112(s0)
    80005ad4:	00290713          	addi	a4,s2,2
    80005ad8:	0712                	slli	a4,a4,0x4
    80005ada:	0001e797          	auipc	a5,0x1e
    80005ade:	e5678793          	addi	a5,a5,-426 # 80023930 <disk>
    80005ae2:	97ba                	add	a5,a5,a4
    80005ae4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005ae8:	0001e997          	auipc	s3,0x1e
    80005aec:	e4898993          	addi	s3,s3,-440 # 80023930 <disk>
    80005af0:	00491713          	slli	a4,s2,0x4
    80005af4:	0009b783          	ld	a5,0(s3)
    80005af8:	97ba                	add	a5,a5,a4
    80005afa:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005afe:	854a                	mv	a0,s2
    80005b00:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005b04:	bafff0ef          	jal	800056b2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005b08:	8885                	andi	s1,s1,1
    80005b0a:	f0fd                	bnez	s1,80005af0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005b0c:	0001e517          	auipc	a0,0x1e
    80005b10:	f4c50513          	addi	a0,a0,-180 # 80023a58 <disk+0x128>
    80005b14:	978fb0ef          	jal	80000c8c <release>
}
    80005b18:	70a6                	ld	ra,104(sp)
    80005b1a:	7406                	ld	s0,96(sp)
    80005b1c:	64e6                	ld	s1,88(sp)
    80005b1e:	6946                	ld	s2,80(sp)
    80005b20:	69a6                	ld	s3,72(sp)
    80005b22:	6a06                	ld	s4,64(sp)
    80005b24:	7ae2                	ld	s5,56(sp)
    80005b26:	7b42                	ld	s6,48(sp)
    80005b28:	7ba2                	ld	s7,40(sp)
    80005b2a:	7c02                	ld	s8,32(sp)
    80005b2c:	6ce2                	ld	s9,24(sp)
    80005b2e:	6165                	addi	sp,sp,112
    80005b30:	8082                	ret

0000000080005b32 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005b32:	1101                	addi	sp,sp,-32
    80005b34:	ec06                	sd	ra,24(sp)
    80005b36:	e822                	sd	s0,16(sp)
    80005b38:	e426                	sd	s1,8(sp)
    80005b3a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005b3c:	0001e497          	auipc	s1,0x1e
    80005b40:	df448493          	addi	s1,s1,-524 # 80023930 <disk>
    80005b44:	0001e517          	auipc	a0,0x1e
    80005b48:	f1450513          	addi	a0,a0,-236 # 80023a58 <disk+0x128>
    80005b4c:	8a8fb0ef          	jal	80000bf4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005b50:	100017b7          	lui	a5,0x10001
    80005b54:	53b8                	lw	a4,96(a5)
    80005b56:	8b0d                	andi	a4,a4,3
    80005b58:	100017b7          	lui	a5,0x10001
    80005b5c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005b5e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005b62:	689c                	ld	a5,16(s1)
    80005b64:	0204d703          	lhu	a4,32(s1)
    80005b68:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005b6c:	04f70663          	beq	a4,a5,80005bb8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005b70:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005b74:	6898                	ld	a4,16(s1)
    80005b76:	0204d783          	lhu	a5,32(s1)
    80005b7a:	8b9d                	andi	a5,a5,7
    80005b7c:	078e                	slli	a5,a5,0x3
    80005b7e:	97ba                	add	a5,a5,a4
    80005b80:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005b82:	00278713          	addi	a4,a5,2
    80005b86:	0712                	slli	a4,a4,0x4
    80005b88:	9726                	add	a4,a4,s1
    80005b8a:	01074703          	lbu	a4,16(a4)
    80005b8e:	e321                	bnez	a4,80005bce <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005b90:	0789                	addi	a5,a5,2
    80005b92:	0792                	slli	a5,a5,0x4
    80005b94:	97a6                	add	a5,a5,s1
    80005b96:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005b98:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005b9c:	b5efc0ef          	jal	80001efa <wakeup>

    disk.used_idx += 1;
    80005ba0:	0204d783          	lhu	a5,32(s1)
    80005ba4:	2785                	addiw	a5,a5,1
    80005ba6:	17c2                	slli	a5,a5,0x30
    80005ba8:	93c1                	srli	a5,a5,0x30
    80005baa:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005bae:	6898                	ld	a4,16(s1)
    80005bb0:	00275703          	lhu	a4,2(a4)
    80005bb4:	faf71ee3          	bne	a4,a5,80005b70 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005bb8:	0001e517          	auipc	a0,0x1e
    80005bbc:	ea050513          	addi	a0,a0,-352 # 80023a58 <disk+0x128>
    80005bc0:	8ccfb0ef          	jal	80000c8c <release>
}
    80005bc4:	60e2                	ld	ra,24(sp)
    80005bc6:	6442                	ld	s0,16(sp)
    80005bc8:	64a2                	ld	s1,8(sp)
    80005bca:	6105                	addi	sp,sp,32
    80005bcc:	8082                	ret
      panic("virtio_disk_intr status");
    80005bce:	00002517          	auipc	a0,0x2
    80005bd2:	f4a50513          	addi	a0,a0,-182 # 80007b18 <etext+0xb18>
    80005bd6:	bbffa0ef          	jal	80000794 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
