
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	4e013103          	ld	sp,1248(sp) # 8000a4e0 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffc5817>
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
    800000fa:	12e020ef          	jal	80002228 <either_copyin>
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
    80000158:	3ec50513          	addi	a0,a0,1004 # 80012540 <cons>
    8000015c:	299000ef          	jal	80000bf4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00012497          	auipc	s1,0x12
    80000164:	3e048493          	addi	s1,s1,992 # 80012540 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00012917          	auipc	s2,0x12
    8000016c:	47090913          	addi	s2,s2,1136 # 800125d8 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	6e0010ef          	jal	80001860 <myproc>
    80000184:	731010ef          	jal	800020b4 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	4db010ef          	jal	80001e68 <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00012717          	auipc	a4,0x12
    800001a4:	3a070713          	addi	a4,a4,928 # 80012540 <cons>
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
    800001d2:	00a020ef          	jal	800021dc <either_copyout>
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
    800001ee:	35650513          	addi	a0,a0,854 # 80012540 <cons>
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
    80000218:	3cf72223          	sw	a5,964(a4) # 800125d8 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00012517          	auipc	a0,0x12
    8000022e:	31650513          	addi	a0,a0,790 # 80012540 <cons>
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
    80000282:	2c250513          	addi	a0,a0,706 # 80012540 <cons>
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
    800002a0:	7d5010ef          	jal	80002274 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002a4:	00012517          	auipc	a0,0x12
    800002a8:	29c50513          	addi	a0,a0,668 # 80012540 <cons>
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
    800002c6:	27e70713          	addi	a4,a4,638 # 80012540 <cons>
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
    800002ec:	25878793          	addi	a5,a5,600 # 80012540 <cons>
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
    8000031a:	2c27a783          	lw	a5,706(a5) # 800125d8 <cons+0x98>
    8000031e:	9f1d                	subw	a4,a4,a5
    80000320:	08000793          	li	a5,128
    80000324:	f8f710e3          	bne	a4,a5,800002a4 <consoleintr+0x32>
    80000328:	a07d                	j	800003d6 <consoleintr+0x164>
    8000032a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000032c:	00012717          	auipc	a4,0x12
    80000330:	21470713          	addi	a4,a4,532 # 80012540 <cons>
    80000334:	0a072783          	lw	a5,160(a4)
    80000338:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000033c:	00012497          	auipc	s1,0x12
    80000340:	20448493          	addi	s1,s1,516 # 80012540 <cons>
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
    80000382:	1c270713          	addi	a4,a4,450 # 80012540 <cons>
    80000386:	0a072783          	lw	a5,160(a4)
    8000038a:	09c72703          	lw	a4,156(a4)
    8000038e:	f0f70be3          	beq	a4,a5,800002a4 <consoleintr+0x32>
      cons.e--;
    80000392:	37fd                	addiw	a5,a5,-1
    80000394:	00012717          	auipc	a4,0x12
    80000398:	24f72623          	sw	a5,588(a4) # 800125e0 <cons+0xa0>
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
    800003b6:	18e78793          	addi	a5,a5,398 # 80012540 <cons>
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
    800003da:	20c7a323          	sw	a2,518(a5) # 800125dc <cons+0x9c>
        wakeup(&cons.r);
    800003de:	00012517          	auipc	a0,0x12
    800003e2:	1fa50513          	addi	a0,a0,506 # 800125d8 <cons+0x98>
    800003e6:	2d1010ef          	jal	80001eb6 <wakeup>
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
    80000400:	14450513          	addi	a0,a0,324 # 80012540 <cons>
    80000404:	770000ef          	jal	80000b74 <initlock>

  uartinit();
    80000408:	3f4000ef          	jal	800007fc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000040c:	00038797          	auipc	a5,0x38
    80000410:	a4478793          	addi	a5,a5,-1468 # 80037e50 <devsw>
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
    8000044a:	46260613          	addi	a2,a2,1122 # 800078a8 <digits>
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
    800004e4:	1207a783          	lw	a5,288(a5) # 80012600 <pr+0x18>
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
    80000530:	0bc50513          	addi	a0,a0,188 # 800125e8 <pr>
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
    800006f0:	1bcb8b93          	addi	s7,s7,444 # 800078a8 <digits>
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
    8000078a:	e6250513          	addi	a0,a0,-414 # 800125e8 <pr>
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
    800007a4:	e607a023          	sw	zero,-416(a5) # 80012600 <pr+0x18>
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
    800007c8:	d2f72e23          	sw	a5,-708(a4) # 8000a500 <panicked>
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
    800007dc:	e1048493          	addi	s1,s1,-496 # 800125e8 <pr>
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
    80000844:	dc850513          	addi	a0,a0,-568 # 80012608 <uart_tx_lock>
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
    80000868:	c9c7a783          	lw	a5,-868(a5) # 8000a500 <panicked>
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
    8000089e:	c6e7b783          	ld	a5,-914(a5) # 8000a508 <uart_tx_r>
    800008a2:	0000a717          	auipc	a4,0xa
    800008a6:	c6e73703          	ld	a4,-914(a4) # 8000a510 <uart_tx_w>
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
    800008cc:	d40a8a93          	addi	s5,s5,-704 # 80012608 <uart_tx_lock>
    uart_tx_r += 1;
    800008d0:	0000a497          	auipc	s1,0xa
    800008d4:	c3848493          	addi	s1,s1,-968 # 8000a508 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008d8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008dc:	0000a997          	auipc	s3,0xa
    800008e0:	c3498993          	addi	s3,s3,-972 # 8000a510 <uart_tx_w>
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
    800008fe:	5b8010ef          	jal	80001eb6 <wakeup>
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
    80000950:	cbc50513          	addi	a0,a0,-836 # 80012608 <uart_tx_lock>
    80000954:	2a0000ef          	jal	80000bf4 <acquire>
  if(panicked){
    80000958:	0000a797          	auipc	a5,0xa
    8000095c:	ba87a783          	lw	a5,-1112(a5) # 8000a500 <panicked>
    80000960:	efbd                	bnez	a5,800009de <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000962:	0000a717          	auipc	a4,0xa
    80000966:	bae73703          	ld	a4,-1106(a4) # 8000a510 <uart_tx_w>
    8000096a:	0000a797          	auipc	a5,0xa
    8000096e:	b9e7b783          	ld	a5,-1122(a5) # 8000a508 <uart_tx_r>
    80000972:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000976:	00012997          	auipc	s3,0x12
    8000097a:	c9298993          	addi	s3,s3,-878 # 80012608 <uart_tx_lock>
    8000097e:	0000a497          	auipc	s1,0xa
    80000982:	b8a48493          	addi	s1,s1,-1142 # 8000a508 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	0000a917          	auipc	s2,0xa
    8000098a:	b8a90913          	addi	s2,s2,-1142 # 8000a510 <uart_tx_w>
    8000098e:	00e79d63          	bne	a5,a4,800009a8 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000992:	85ce                	mv	a1,s3
    80000994:	8526                	mv	a0,s1
    80000996:	4d2010ef          	jal	80001e68 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099a:	00093703          	ld	a4,0(s2)
    8000099e:	609c                	ld	a5,0(s1)
    800009a0:	02078793          	addi	a5,a5,32
    800009a4:	fee787e3          	beq	a5,a4,80000992 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a8:	00012497          	auipc	s1,0x12
    800009ac:	c6048493          	addi	s1,s1,-928 # 80012608 <uart_tx_lock>
    800009b0:	01f77793          	andi	a5,a4,31
    800009b4:	97a6                	add	a5,a5,s1
    800009b6:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009ba:	0705                	addi	a4,a4,1
    800009bc:	0000a797          	auipc	a5,0xa
    800009c0:	b4e7ba23          	sd	a4,-1196(a5) # 8000a510 <uart_tx_w>
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
    80000a24:	be848493          	addi	s1,s1,-1048 # 80012608 <uart_tx_lock>
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
    80000a56:	00038797          	auipc	a5,0x38
    80000a5a:	59278793          	addi	a5,a5,1426 # 80038fe8 <end>
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
    80000a76:	bce90913          	addi	s2,s2,-1074 # 80012640 <kmem>
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
    80000b04:	b4050513          	addi	a0,a0,-1216 # 80012640 <kmem>
    80000b08:	06c000ef          	jal	80000b74 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b0c:	45c5                	li	a1,17
    80000b0e:	05ee                	slli	a1,a1,0x1b
    80000b10:	00038517          	auipc	a0,0x38
    80000b14:	4d850513          	addi	a0,a0,1240 # 80038fe8 <end>
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
    80000b32:	b1248493          	addi	s1,s1,-1262 # 80012640 <kmem>
    80000b36:	8526                	mv	a0,s1
    80000b38:	0bc000ef          	jal	80000bf4 <acquire>
  r = kmem.freelist;
    80000b3c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3e:	c485                	beqz	s1,80000b66 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b40:	609c                	ld	a5,0(s1)
    80000b42:	00012517          	auipc	a0,0x12
    80000b46:	afe50513          	addi	a0,a0,-1282 # 80012640 <kmem>
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
    80000b6a:	ada50513          	addi	a0,a0,-1318 # 80012640 <kmem>
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
    80000b9e:	4a7000ef          	jal	80001844 <mycpu>
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
    80000bcc:	479000ef          	jal	80001844 <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cb99                	beqz	a5,80000be8 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	471000ef          	jal	80001844 <mycpu>
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
    80000be8:	45d000ef          	jal	80001844 <mycpu>
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
    80000c1c:	429000ef          	jal	80001844 <mycpu>
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
    80000c40:	405000ef          	jal	80001844 <mycpu>
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
    80000d3c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffc6019>
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
    80000e6a:	1cb000ef          	jal	80001834 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e6e:	00009717          	auipc	a4,0x9
    80000e72:	6aa70713          	addi	a4,a4,1706 # 8000a518 <started>
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
    80000e82:	1b3000ef          	jal	80001834 <cpuid>
    80000e86:	85aa                	mv	a1,a0
    80000e88:	00006517          	auipc	a0,0x6
    80000e8c:	21050513          	addi	a0,a0,528 # 80007098 <etext+0x98>
    80000e90:	e32ff0ef          	jal	800004c2 <printf>
    kvminithart();    // turn on paging
    80000e94:	080000ef          	jal	80000f14 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e98:	74a010ef          	jal	800025e2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e9c:	02d040ef          	jal	800056c8 <plicinithart>
  }

  scheduler();        
    80000ea0:	629000ef          	jal	80001cc8 <scheduler>
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
    80000edc:	464010ef          	jal	80002340 <procinit>
    trapinit();      // trap vectors
    80000ee0:	6de010ef          	jal	800025be <trapinit>
    trapinithart();  // install kernel trap vector
    80000ee4:	6fe010ef          	jal	800025e2 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ee8:	7c6040ef          	jal	800056ae <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000eec:	7dc040ef          	jal	800056c8 <plicinithart>
    binit();         // buffer cache
    80000ef0:	775010ef          	jal	80002e64 <binit>
    iinit();         // inode table
    80000ef4:	566020ef          	jal	8000345a <iinit>
    fileinit();      // file table
    80000ef8:	316030ef          	jal	8000420e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efc:	0bd040ef          	jal	800057b8 <virtio_disk_init>
    userinit();      // first user process
    80000f00:	3e9000ef          	jal	80001ae8 <userinit>
    __sync_synchronize();
    80000f04:	0330000f          	fence	rw,rw
    started = 1;
    80000f08:	4785                	li	a5,1
    80000f0a:	00009717          	auipc	a4,0x9
    80000f0e:	60f72723          	sw	a5,1550(a4) # 8000a518 <started>
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
    80000f1e:	00009797          	auipc	a5,0x9
    80000f22:	6027b783          	ld	a5,1538(a5) # 8000a520 <kernel_pagetable>
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
    80000f90:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffc600f>
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
    8000118c:	610000ef          	jal	8000179c <proc_mapstacks>
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
    800011ae:	36a7bb23          	sd	a0,886(a5) # 8000a520 <kernel_pagetable>
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

0000000080001766 <init_global_msg_queue>:

struct msg_queue global_msg_queue;
struct spinlock global_queue_lock;

// Initialization function for global message queue
void init_global_msg_queue() {
    80001766:	1141                	addi	sp,sp,-16
    80001768:	e406                	sd	ra,8(sp)
    8000176a:	e022                	sd	s0,0(sp)
    8000176c:	0800                	addi	s0,sp,16
    initlock(&global_queue_lock, "global_queue_lock");
    8000176e:	00006597          	auipc	a1,0x6
    80001772:	a8a58593          	addi	a1,a1,-1398 # 800071f8 <etext+0x1f8>
    80001776:	00011517          	auipc	a0,0x11
    8000177a:	eea50513          	addi	a0,a0,-278 # 80012660 <global_queue_lock>
    8000177e:	bf6ff0ef          	jal	80000b74 <initlock>
    memset(&global_msg_queue, 0, sizeof(global_msg_queue));  // Initialize the queue
    80001782:	54800613          	li	a2,1352
    80001786:	4581                	li	a1,0
    80001788:	00011517          	auipc	a0,0x11
    8000178c:	ef050513          	addi	a0,a0,-272 # 80012678 <global_msg_queue>
    80001790:	d38ff0ef          	jal	80000cc8 <memset>
}
    80001794:	60a2                	ld	ra,8(sp)
    80001796:	6402                	ld	s0,0(sp)
    80001798:	0141                	addi	sp,sp,16
    8000179a:	8082                	ret

000000008000179c <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000179c:	7139                	addi	sp,sp,-64
    8000179e:	fc06                	sd	ra,56(sp)
    800017a0:	f822                	sd	s0,48(sp)
    800017a2:	f426                	sd	s1,40(sp)
    800017a4:	f04a                	sd	s2,32(sp)
    800017a6:	ec4e                	sd	s3,24(sp)
    800017a8:	e852                	sd	s4,16(sp)
    800017aa:	e456                	sd	s5,8(sp)
    800017ac:	e05a                	sd	s6,0(sp)
    800017ae:	0080                	addi	s0,sp,64
    800017b0:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800017b2:	00012497          	auipc	s1,0x12
    800017b6:	85648493          	addi	s1,s1,-1962 # 80013008 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017ba:	8b26                	mv	s6,s1
    800017bc:	077a0937          	lui	s2,0x77a0
    800017c0:	4c990913          	addi	s2,s2,1225 # 77a04c9 <_entry-0x7885fb37>
    800017c4:	0932                	slli	s2,s2,0xc
    800017c6:	f8d90913          	addi	s2,s2,-115
    800017ca:	0932                	slli	s2,s2,0xc
    800017cc:	28b90913          	addi	s2,s2,651
    800017d0:	0932                	slli	s2,s2,0xc
    800017d2:	c4390913          	addi	s2,s2,-957
    800017d6:	040009b7          	lui	s3,0x4000
    800017da:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017dc:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017de:	0002ca97          	auipc	s5,0x2c
    800017e2:	42aa8a93          	addi	s5,s5,1066 # 8002dc08 <tickslock>
    char *pa = kalloc();
    800017e6:	b3eff0ef          	jal	80000b24 <kalloc>
    800017ea:	862a                	mv	a2,a0
    if(pa == 0)
    800017ec:	cd15                	beqz	a0,80001828 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017ee:	416485b3          	sub	a1,s1,s6
    800017f2:	8591                	srai	a1,a1,0x4
    800017f4:	032585b3          	mul	a1,a1,s2
    800017f8:	2585                	addiw	a1,a1,1
    800017fa:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017fe:	4719                	li	a4,6
    80001800:	6685                	lui	a3,0x1
    80001802:	40b985b3          	sub	a1,s3,a1
    80001806:	8552                	mv	a0,s4
    80001808:	8bdff0ef          	jal	800010c4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000180c:	6b048493          	addi	s1,s1,1712
    80001810:	fd549be3          	bne	s1,s5,800017e6 <proc_mapstacks+0x4a>
  }
}
    80001814:	70e2                	ld	ra,56(sp)
    80001816:	7442                	ld	s0,48(sp)
    80001818:	74a2                	ld	s1,40(sp)
    8000181a:	7902                	ld	s2,32(sp)
    8000181c:	69e2                	ld	s3,24(sp)
    8000181e:	6a42                	ld	s4,16(sp)
    80001820:	6aa2                	ld	s5,8(sp)
    80001822:	6b02                	ld	s6,0(sp)
    80001824:	6121                	addi	sp,sp,64
    80001826:	8082                	ret
      panic("kalloc");
    80001828:	00006517          	auipc	a0,0x6
    8000182c:	9e850513          	addi	a0,a0,-1560 # 80007210 <etext+0x210>
    80001830:	f65fe0ef          	jal	80000794 <panic>

0000000080001834 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001834:	1141                	addi	sp,sp,-16
    80001836:	e422                	sd	s0,8(sp)
    80001838:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000183a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000183c:	2501                	sext.w	a0,a0
    8000183e:	6422                	ld	s0,8(sp)
    80001840:	0141                	addi	sp,sp,16
    80001842:	8082                	ret

0000000080001844 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001844:	1141                	addi	sp,sp,-16
    80001846:	e422                	sd	s0,8(sp)
    80001848:	0800                	addi	s0,sp,16
    8000184a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000184c:	2781                	sext.w	a5,a5
    8000184e:	079e                	slli	a5,a5,0x7
  return c;
}
    80001850:	00011517          	auipc	a0,0x11
    80001854:	37050513          	addi	a0,a0,880 # 80012bc0 <cpus>
    80001858:	953e                	add	a0,a0,a5
    8000185a:	6422                	ld	s0,8(sp)
    8000185c:	0141                	addi	sp,sp,16
    8000185e:	8082                	ret

0000000080001860 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001860:	1101                	addi	sp,sp,-32
    80001862:	ec06                	sd	ra,24(sp)
    80001864:	e822                	sd	s0,16(sp)
    80001866:	e426                	sd	s1,8(sp)
    80001868:	1000                	addi	s0,sp,32
  push_off();
    8000186a:	b4aff0ef          	jal	80000bb4 <push_off>
    8000186e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001870:	2781                	sext.w	a5,a5
    80001872:	079e                	slli	a5,a5,0x7
    80001874:	00011717          	auipc	a4,0x11
    80001878:	dec70713          	addi	a4,a4,-532 # 80012660 <global_queue_lock>
    8000187c:	97ba                	add	a5,a5,a4
    8000187e:	5607b483          	ld	s1,1376(a5)
  pop_off();
    80001882:	bb6ff0ef          	jal	80000c38 <pop_off>
  return p;
}
    80001886:	8526                	mv	a0,s1
    80001888:	60e2                	ld	ra,24(sp)
    8000188a:	6442                	ld	s0,16(sp)
    8000188c:	64a2                	ld	s1,8(sp)
    8000188e:	6105                	addi	sp,sp,32
    80001890:	8082                	ret

0000000080001892 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001892:	1141                	addi	sp,sp,-16
    80001894:	e406                	sd	ra,8(sp)
    80001896:	e022                	sd	s0,0(sp)
    80001898:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000189a:	fc7ff0ef          	jal	80001860 <myproc>
    8000189e:	beeff0ef          	jal	80000c8c <release>

  if (first) {
    800018a2:	00009797          	auipc	a5,0x9
    800018a6:	bee7a783          	lw	a5,-1042(a5) # 8000a490 <first.1>
    800018aa:	e799                	bnez	a5,800018b8 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    800018ac:	54f000ef          	jal	800025fa <usertrapret>
}
    800018b0:	60a2                	ld	ra,8(sp)
    800018b2:	6402                	ld	s0,0(sp)
    800018b4:	0141                	addi	sp,sp,16
    800018b6:	8082                	ret
    fsinit(ROOTDEV);
    800018b8:	4505                	li	a0,1
    800018ba:	335010ef          	jal	800033ee <fsinit>
    first = 0;
    800018be:	00009797          	auipc	a5,0x9
    800018c2:	bc07a923          	sw	zero,-1070(a5) # 8000a490 <first.1>
    __sync_synchronize();
    800018c6:	0330000f          	fence	rw,rw
    800018ca:	b7cd                	j	800018ac <forkret+0x1a>

00000000800018cc <allocpid>:
{
    800018cc:	1101                	addi	sp,sp,-32
    800018ce:	ec06                	sd	ra,24(sp)
    800018d0:	e822                	sd	s0,16(sp)
    800018d2:	e426                	sd	s1,8(sp)
    800018d4:	e04a                	sd	s2,0(sp)
    800018d6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800018d8:	00011917          	auipc	s2,0x11
    800018dc:	6e890913          	addi	s2,s2,1768 # 80012fc0 <pid_lock>
    800018e0:	854a                	mv	a0,s2
    800018e2:	b12ff0ef          	jal	80000bf4 <acquire>
  pid = nextpid;
    800018e6:	00009797          	auipc	a5,0x9
    800018ea:	bae78793          	addi	a5,a5,-1106 # 8000a494 <nextpid>
    800018ee:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800018f0:	0014871b          	addiw	a4,s1,1
    800018f4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800018f6:	854a                	mv	a0,s2
    800018f8:	b94ff0ef          	jal	80000c8c <release>
}
    800018fc:	8526                	mv	a0,s1
    800018fe:	60e2                	ld	ra,24(sp)
    80001900:	6442                	ld	s0,16(sp)
    80001902:	64a2                	ld	s1,8(sp)
    80001904:	6902                	ld	s2,0(sp)
    80001906:	6105                	addi	sp,sp,32
    80001908:	8082                	ret

000000008000190a <proc_pagetable>:
{
    8000190a:	1101                	addi	sp,sp,-32
    8000190c:	ec06                	sd	ra,24(sp)
    8000190e:	e822                	sd	s0,16(sp)
    80001910:	e426                	sd	s1,8(sp)
    80001912:	e04a                	sd	s2,0(sp)
    80001914:	1000                	addi	s0,sp,32
    80001916:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001918:	95fff0ef          	jal	80001276 <uvmcreate>
    8000191c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000191e:	cd05                	beqz	a0,80001956 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001920:	4729                	li	a4,10
    80001922:	00004697          	auipc	a3,0x4
    80001926:	6de68693          	addi	a3,a3,1758 # 80006000 <_trampoline>
    8000192a:	6605                	lui	a2,0x1
    8000192c:	040005b7          	lui	a1,0x4000
    80001930:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001932:	05b2                	slli	a1,a1,0xc
    80001934:	ee0ff0ef          	jal	80001014 <mappages>
    80001938:	02054663          	bltz	a0,80001964 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000193c:	4719                	li	a4,6
    8000193e:	5a093683          	ld	a3,1440(s2)
    80001942:	6605                	lui	a2,0x1
    80001944:	020005b7          	lui	a1,0x2000
    80001948:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000194a:	05b6                	slli	a1,a1,0xd
    8000194c:	8526                	mv	a0,s1
    8000194e:	ec6ff0ef          	jal	80001014 <mappages>
    80001952:	00054f63          	bltz	a0,80001970 <proc_pagetable+0x66>
}
    80001956:	8526                	mv	a0,s1
    80001958:	60e2                	ld	ra,24(sp)
    8000195a:	6442                	ld	s0,16(sp)
    8000195c:	64a2                	ld	s1,8(sp)
    8000195e:	6902                	ld	s2,0(sp)
    80001960:	6105                	addi	sp,sp,32
    80001962:	8082                	ret
    uvmfree(pagetable, 0);
    80001964:	4581                	li	a1,0
    80001966:	8526                	mv	a0,s1
    80001968:	addff0ef          	jal	80001444 <uvmfree>
    return 0;
    8000196c:	4481                	li	s1,0
    8000196e:	b7e5                	j	80001956 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001970:	4681                	li	a3,0
    80001972:	4605                	li	a2,1
    80001974:	040005b7          	lui	a1,0x4000
    80001978:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000197a:	05b2                	slli	a1,a1,0xc
    8000197c:	8526                	mv	a0,s1
    8000197e:	83dff0ef          	jal	800011ba <uvmunmap>
    uvmfree(pagetable, 0);
    80001982:	4581                	li	a1,0
    80001984:	8526                	mv	a0,s1
    80001986:	abfff0ef          	jal	80001444 <uvmfree>
    return 0;
    8000198a:	4481                	li	s1,0
    8000198c:	b7e9                	j	80001956 <proc_pagetable+0x4c>

000000008000198e <proc_freepagetable>:
{
    8000198e:	1101                	addi	sp,sp,-32
    80001990:	ec06                	sd	ra,24(sp)
    80001992:	e822                	sd	s0,16(sp)
    80001994:	e426                	sd	s1,8(sp)
    80001996:	e04a                	sd	s2,0(sp)
    80001998:	1000                	addi	s0,sp,32
    8000199a:	84aa                	mv	s1,a0
    8000199c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000199e:	4681                	li	a3,0
    800019a0:	4605                	li	a2,1
    800019a2:	040005b7          	lui	a1,0x4000
    800019a6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019a8:	05b2                	slli	a1,a1,0xc
    800019aa:	811ff0ef          	jal	800011ba <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800019ae:	4681                	li	a3,0
    800019b0:	4605                	li	a2,1
    800019b2:	020005b7          	lui	a1,0x2000
    800019b6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019b8:	05b6                	slli	a1,a1,0xd
    800019ba:	8526                	mv	a0,s1
    800019bc:	ffeff0ef          	jal	800011ba <uvmunmap>
  uvmfree(pagetable, sz);
    800019c0:	85ca                	mv	a1,s2
    800019c2:	8526                	mv	a0,s1
    800019c4:	a81ff0ef          	jal	80001444 <uvmfree>
}
    800019c8:	60e2                	ld	ra,24(sp)
    800019ca:	6442                	ld	s0,16(sp)
    800019cc:	64a2                	ld	s1,8(sp)
    800019ce:	6902                	ld	s2,0(sp)
    800019d0:	6105                	addi	sp,sp,32
    800019d2:	8082                	ret

00000000800019d4 <freeproc>:
{
    800019d4:	1101                	addi	sp,sp,-32
    800019d6:	ec06                	sd	ra,24(sp)
    800019d8:	e822                	sd	s0,16(sp)
    800019da:	e426                	sd	s1,8(sp)
    800019dc:	1000                	addi	s0,sp,32
    800019de:	84aa                	mv	s1,a0
  if(p->trapframe)
    800019e0:	5a053503          	ld	a0,1440(a0)
    800019e4:	c119                	beqz	a0,800019ea <freeproc+0x16>
    kfree((void*)p->trapframe);
    800019e6:	85cff0ef          	jal	80000a42 <kfree>
  p->trapframe = 0;
    800019ea:	5a04b023          	sd	zero,1440(s1)
  if(p->pagetable)
    800019ee:	5984b503          	ld	a0,1432(s1)
    800019f2:	c509                	beqz	a0,800019fc <freeproc+0x28>
    proc_freepagetable(p->pagetable, p->sz);
    800019f4:	5904b583          	ld	a1,1424(s1)
    800019f8:	f97ff0ef          	jal	8000198e <proc_freepagetable>
  p->pagetable = 0;
    800019fc:	5804bc23          	sd	zero,1432(s1)
  p->sz = 0;
    80001a00:	5804b823          	sd	zero,1424(s1)
  p->pid = 0;
    80001a04:	5604ac23          	sw	zero,1400(s1)
  p->parent = 0;
    80001a08:	5804b023          	sd	zero,1408(s1)
  p->name[0] = 0;
    80001a0c:	6a048023          	sb	zero,1696(s1)
  p->chan = 0;
    80001a10:	5604b423          	sd	zero,1384(s1)
  p->killed = 0;
    80001a14:	5604a823          	sw	zero,1392(s1)
  p->xstate = 0;
    80001a18:	5604aa23          	sw	zero,1396(s1)
  p->state = UNUSED;
    80001a1c:	5604a023          	sw	zero,1376(s1)
}
    80001a20:	60e2                	ld	ra,24(sp)
    80001a22:	6442                	ld	s0,16(sp)
    80001a24:	64a2                	ld	s1,8(sp)
    80001a26:	6105                	addi	sp,sp,32
    80001a28:	8082                	ret

0000000080001a2a <allocproc>:
{
    80001a2a:	1101                	addi	sp,sp,-32
    80001a2c:	ec06                	sd	ra,24(sp)
    80001a2e:	e822                	sd	s0,16(sp)
    80001a30:	e426                	sd	s1,8(sp)
    80001a32:	e04a                	sd	s2,0(sp)
    80001a34:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a36:	00011497          	auipc	s1,0x11
    80001a3a:	5d248493          	addi	s1,s1,1490 # 80013008 <proc>
    80001a3e:	0002c917          	auipc	s2,0x2c
    80001a42:	1ca90913          	addi	s2,s2,458 # 8002dc08 <tickslock>
    acquire(&p->lock);
    80001a46:	8526                	mv	a0,s1
    80001a48:	9acff0ef          	jal	80000bf4 <acquire>
    p->msg_queue.head = 0;
    80001a4c:	5404a023          	sw	zero,1344(s1)
    p->msg_queue.tail = 0;
    80001a50:	5404a223          	sw	zero,1348(s1)
    if(p->state == UNUSED) {
    80001a54:	5604a783          	lw	a5,1376(s1)
    80001a58:	cb91                	beqz	a5,80001a6c <allocproc+0x42>
      release(&p->lock);
    80001a5a:	8526                	mv	a0,s1
    80001a5c:	a30ff0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a60:	6b048493          	addi	s1,s1,1712
    80001a64:	ff2491e3          	bne	s1,s2,80001a46 <allocproc+0x1c>
  return 0;
    80001a68:	4481                	li	s1,0
    80001a6a:	a881                	j	80001aba <allocproc+0x90>
  p->pid = allocpid();
    80001a6c:	e61ff0ef          	jal	800018cc <allocpid>
    80001a70:	56a4ac23          	sw	a0,1400(s1)
  p->state = USED;
    80001a74:	4785                	li	a5,1
    80001a76:	56f4a023          	sw	a5,1376(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001a7a:	8aaff0ef          	jal	80000b24 <kalloc>
    80001a7e:	892a                	mv	s2,a0
    80001a80:	5aa4b023          	sd	a0,1440(s1)
    80001a84:	c131                	beqz	a0,80001ac8 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001a86:	8526                	mv	a0,s1
    80001a88:	e83ff0ef          	jal	8000190a <proc_pagetable>
    80001a8c:	892a                	mv	s2,a0
    80001a8e:	58a4bc23          	sd	a0,1432(s1)
  if(p->pagetable == 0){
    80001a92:	c139                	beqz	a0,80001ad8 <allocproc+0xae>
  memset(&p->context, 0, sizeof(p->context));
    80001a94:	07000613          	li	a2,112
    80001a98:	4581                	li	a1,0
    80001a9a:	5a848513          	addi	a0,s1,1448
    80001a9e:	a2aff0ef          	jal	80000cc8 <memset>
  p->context.ra = (uint64)forkret;
    80001aa2:	00000797          	auipc	a5,0x0
    80001aa6:	df078793          	addi	a5,a5,-528 # 80001892 <forkret>
    80001aaa:	5af4b423          	sd	a5,1448(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001aae:	5884b783          	ld	a5,1416(s1)
    80001ab2:	6705                	lui	a4,0x1
    80001ab4:	97ba                	add	a5,a5,a4
    80001ab6:	5af4b823          	sd	a5,1456(s1)
}
    80001aba:	8526                	mv	a0,s1
    80001abc:	60e2                	ld	ra,24(sp)
    80001abe:	6442                	ld	s0,16(sp)
    80001ac0:	64a2                	ld	s1,8(sp)
    80001ac2:	6902                	ld	s2,0(sp)
    80001ac4:	6105                	addi	sp,sp,32
    80001ac6:	8082                	ret
    freeproc(p);
    80001ac8:	8526                	mv	a0,s1
    80001aca:	f0bff0ef          	jal	800019d4 <freeproc>
    release(&p->lock);
    80001ace:	8526                	mv	a0,s1
    80001ad0:	9bcff0ef          	jal	80000c8c <release>
    return 0;
    80001ad4:	84ca                	mv	s1,s2
    80001ad6:	b7d5                	j	80001aba <allocproc+0x90>
    freeproc(p);
    80001ad8:	8526                	mv	a0,s1
    80001ada:	efbff0ef          	jal	800019d4 <freeproc>
    release(&p->lock);
    80001ade:	8526                	mv	a0,s1
    80001ae0:	9acff0ef          	jal	80000c8c <release>
    return 0;
    80001ae4:	84ca                	mv	s1,s2
    80001ae6:	bfd1                	j	80001aba <allocproc+0x90>

0000000080001ae8 <userinit>:
{
    80001ae8:	1101                	addi	sp,sp,-32
    80001aea:	ec06                	sd	ra,24(sp)
    80001aec:	e822                	sd	s0,16(sp)
    80001aee:	e426                	sd	s1,8(sp)
    80001af0:	1000                	addi	s0,sp,32
  p = allocproc();
    80001af2:	f39ff0ef          	jal	80001a2a <allocproc>
    80001af6:	84aa                	mv	s1,a0
  initproc = p;
    80001af8:	00009797          	auipc	a5,0x9
    80001afc:	a2a7b823          	sd	a0,-1488(a5) # 8000a528 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001b00:	03400613          	li	a2,52
    80001b04:	00009597          	auipc	a1,0x9
    80001b08:	99c58593          	addi	a1,a1,-1636 # 8000a4a0 <initcode>
    80001b0c:	59853503          	ld	a0,1432(a0)
    80001b10:	f8cff0ef          	jal	8000129c <uvmfirst>
  p->sz = PGSIZE;
    80001b14:	6785                	lui	a5,0x1
    80001b16:	58f4b823          	sd	a5,1424(s1)
  p->trapframe->epc = 0;      // user program counter
    80001b1a:	5a04b703          	ld	a4,1440(s1)
    80001b1e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001b22:	5a04b703          	ld	a4,1440(s1)
    80001b26:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001b28:	4641                	li	a2,16
    80001b2a:	00005597          	auipc	a1,0x5
    80001b2e:	6ee58593          	addi	a1,a1,1774 # 80007218 <etext+0x218>
    80001b32:	6a048513          	addi	a0,s1,1696
    80001b36:	ad0ff0ef          	jal	80000e06 <safestrcpy>
  p->cwd = namei("/");
    80001b3a:	00005517          	auipc	a0,0x5
    80001b3e:	6ee50513          	addi	a0,a0,1774 # 80007228 <etext+0x228>
    80001b42:	1ba020ef          	jal	80003cfc <namei>
    80001b46:	68a4bc23          	sd	a0,1688(s1)
  p->state = RUNNABLE;
    80001b4a:	478d                	li	a5,3
    80001b4c:	56f4a023          	sw	a5,1376(s1)
  release(&p->lock);
    80001b50:	8526                	mv	a0,s1
    80001b52:	93aff0ef          	jal	80000c8c <release>
}
    80001b56:	60e2                	ld	ra,24(sp)
    80001b58:	6442                	ld	s0,16(sp)
    80001b5a:	64a2                	ld	s1,8(sp)
    80001b5c:	6105                	addi	sp,sp,32
    80001b5e:	8082                	ret

0000000080001b60 <growproc>:
{
    80001b60:	1101                	addi	sp,sp,-32
    80001b62:	ec06                	sd	ra,24(sp)
    80001b64:	e822                	sd	s0,16(sp)
    80001b66:	e426                	sd	s1,8(sp)
    80001b68:	e04a                	sd	s2,0(sp)
    80001b6a:	1000                	addi	s0,sp,32
    80001b6c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001b6e:	cf3ff0ef          	jal	80001860 <myproc>
    80001b72:	84aa                	mv	s1,a0
  sz = p->sz;
    80001b74:	59053583          	ld	a1,1424(a0)
  if(n > 0){
    80001b78:	01204d63          	bgtz	s2,80001b92 <growproc+0x32>
  } else if(n < 0){
    80001b7c:	02094663          	bltz	s2,80001ba8 <growproc+0x48>
  p->sz = sz;
    80001b80:	58b4b823          	sd	a1,1424(s1)
  return 0;
    80001b84:	4501                	li	a0,0
}
    80001b86:	60e2                	ld	ra,24(sp)
    80001b88:	6442                	ld	s0,16(sp)
    80001b8a:	64a2                	ld	s1,8(sp)
    80001b8c:	6902                	ld	s2,0(sp)
    80001b8e:	6105                	addi	sp,sp,32
    80001b90:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001b92:	4691                	li	a3,4
    80001b94:	00b90633          	add	a2,s2,a1
    80001b98:	59853503          	ld	a0,1432(a0)
    80001b9c:	fa2ff0ef          	jal	8000133e <uvmalloc>
    80001ba0:	85aa                	mv	a1,a0
    80001ba2:	fd79                	bnez	a0,80001b80 <growproc+0x20>
      return -1;
    80001ba4:	557d                	li	a0,-1
    80001ba6:	b7c5                	j	80001b86 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001ba8:	00b90633          	add	a2,s2,a1
    80001bac:	59853503          	ld	a0,1432(a0)
    80001bb0:	f4aff0ef          	jal	800012fa <uvmdealloc>
    80001bb4:	85aa                	mv	a1,a0
    80001bb6:	b7e9                	j	80001b80 <growproc+0x20>

0000000080001bb8 <fork>:
{
    80001bb8:	7139                	addi	sp,sp,-64
    80001bba:	fc06                	sd	ra,56(sp)
    80001bbc:	f822                	sd	s0,48(sp)
    80001bbe:	f04a                	sd	s2,32(sp)
    80001bc0:	e456                	sd	s5,8(sp)
    80001bc2:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001bc4:	c9dff0ef          	jal	80001860 <myproc>
    80001bc8:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001bca:	e61ff0ef          	jal	80001a2a <allocproc>
    80001bce:	0e050b63          	beqz	a0,80001cc4 <fork+0x10c>
    80001bd2:	e852                	sd	s4,16(sp)
    80001bd4:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001bd6:	590ab603          	ld	a2,1424(s5)
    80001bda:	59853583          	ld	a1,1432(a0)
    80001bde:	598ab503          	ld	a0,1432(s5)
    80001be2:	895ff0ef          	jal	80001476 <uvmcopy>
    80001be6:	04054a63          	bltz	a0,80001c3a <fork+0x82>
    80001bea:	f426                	sd	s1,40(sp)
    80001bec:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001bee:	590ab783          	ld	a5,1424(s5)
    80001bf2:	58fa3823          	sd	a5,1424(s4)
  *(np->trapframe) = *(p->trapframe);
    80001bf6:	5a0ab683          	ld	a3,1440(s5)
    80001bfa:	87b6                	mv	a5,a3
    80001bfc:	5a0a3703          	ld	a4,1440(s4)
    80001c00:	12068693          	addi	a3,a3,288
    80001c04:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001c08:	6788                	ld	a0,8(a5)
    80001c0a:	6b8c                	ld	a1,16(a5)
    80001c0c:	6f90                	ld	a2,24(a5)
    80001c0e:	01073023          	sd	a6,0(a4)
    80001c12:	e708                	sd	a0,8(a4)
    80001c14:	eb0c                	sd	a1,16(a4)
    80001c16:	ef10                	sd	a2,24(a4)
    80001c18:	02078793          	addi	a5,a5,32
    80001c1c:	02070713          	addi	a4,a4,32
    80001c20:	fed792e3          	bne	a5,a3,80001c04 <fork+0x4c>
  np->trapframe->a0 = 0;
    80001c24:	5a0a3783          	ld	a5,1440(s4)
    80001c28:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001c2c:	618a8493          	addi	s1,s5,1560
    80001c30:	618a0913          	addi	s2,s4,1560
    80001c34:	698a8993          	addi	s3,s5,1688
    80001c38:	a831                	j	80001c54 <fork+0x9c>
    freeproc(np);
    80001c3a:	8552                	mv	a0,s4
    80001c3c:	d99ff0ef          	jal	800019d4 <freeproc>
    release(&np->lock);
    80001c40:	8552                	mv	a0,s4
    80001c42:	84aff0ef          	jal	80000c8c <release>
    return -1;
    80001c46:	597d                	li	s2,-1
    80001c48:	6a42                	ld	s4,16(sp)
    80001c4a:	a0b5                	j	80001cb6 <fork+0xfe>
  for(i = 0; i < NOFILE; i++)
    80001c4c:	04a1                	addi	s1,s1,8
    80001c4e:	0921                	addi	s2,s2,8
    80001c50:	01348963          	beq	s1,s3,80001c62 <fork+0xaa>
    if(p->ofile[i])
    80001c54:	6088                	ld	a0,0(s1)
    80001c56:	d97d                	beqz	a0,80001c4c <fork+0x94>
      np->ofile[i] = filedup(p->ofile[i]);
    80001c58:	638020ef          	jal	80004290 <filedup>
    80001c5c:	00a93023          	sd	a0,0(s2)
    80001c60:	b7f5                	j	80001c4c <fork+0x94>
  np->cwd = idup(p->cwd);
    80001c62:	698ab503          	ld	a0,1688(s5)
    80001c66:	187010ef          	jal	800035ec <idup>
    80001c6a:	68aa3c23          	sd	a0,1688(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c6e:	4641                	li	a2,16
    80001c70:	6a0a8593          	addi	a1,s5,1696
    80001c74:	6a0a0513          	addi	a0,s4,1696
    80001c78:	98eff0ef          	jal	80000e06 <safestrcpy>
  pid = np->pid;
    80001c7c:	578a2903          	lw	s2,1400(s4)
  release(&np->lock);
    80001c80:	8552                	mv	a0,s4
    80001c82:	80aff0ef          	jal	80000c8c <release>
  acquire(&wait_lock);
    80001c86:	00011497          	auipc	s1,0x11
    80001c8a:	35248493          	addi	s1,s1,850 # 80012fd8 <wait_lock>
    80001c8e:	8526                	mv	a0,s1
    80001c90:	f65fe0ef          	jal	80000bf4 <acquire>
  np->parent = p;
    80001c94:	595a3023          	sd	s5,1408(s4)
  release(&wait_lock);
    80001c98:	8526                	mv	a0,s1
    80001c9a:	ff3fe0ef          	jal	80000c8c <release>
  acquire(&np->lock);
    80001c9e:	8552                	mv	a0,s4
    80001ca0:	f55fe0ef          	jal	80000bf4 <acquire>
  np->state = RUNNABLE;
    80001ca4:	478d                	li	a5,3
    80001ca6:	56fa2023          	sw	a5,1376(s4)
  release(&np->lock);
    80001caa:	8552                	mv	a0,s4
    80001cac:	fe1fe0ef          	jal	80000c8c <release>
  return pid;
    80001cb0:	74a2                	ld	s1,40(sp)
    80001cb2:	69e2                	ld	s3,24(sp)
    80001cb4:	6a42                	ld	s4,16(sp)
}
    80001cb6:	854a                	mv	a0,s2
    80001cb8:	70e2                	ld	ra,56(sp)
    80001cba:	7442                	ld	s0,48(sp)
    80001cbc:	7902                	ld	s2,32(sp)
    80001cbe:	6aa2                	ld	s5,8(sp)
    80001cc0:	6121                	addi	sp,sp,64
    80001cc2:	8082                	ret
    return -1;
    80001cc4:	597d                	li	s2,-1
    80001cc6:	bfc5                	j	80001cb6 <fork+0xfe>

0000000080001cc8 <scheduler>:
{
    80001cc8:	715d                	addi	sp,sp,-80
    80001cca:	e486                	sd	ra,72(sp)
    80001ccc:	e0a2                	sd	s0,64(sp)
    80001cce:	fc26                	sd	s1,56(sp)
    80001cd0:	f84a                	sd	s2,48(sp)
    80001cd2:	f44e                	sd	s3,40(sp)
    80001cd4:	f052                	sd	s4,32(sp)
    80001cd6:	ec56                	sd	s5,24(sp)
    80001cd8:	e85a                	sd	s6,16(sp)
    80001cda:	e45e                	sd	s7,8(sp)
    80001cdc:	e062                	sd	s8,0(sp)
    80001cde:	0880                	addi	s0,sp,80
    80001ce0:	8792                	mv	a5,tp
  int id = r_tp();
    80001ce2:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001ce4:	00779b13          	slli	s6,a5,0x7
    80001ce8:	00011717          	auipc	a4,0x11
    80001cec:	97870713          	addi	a4,a4,-1672 # 80012660 <global_queue_lock>
    80001cf0:	975a                	add	a4,a4,s6
    80001cf2:	56073023          	sd	zero,1376(a4)
        swtch(&c->context, &p->context);
    80001cf6:	00011717          	auipc	a4,0x11
    80001cfa:	ed270713          	addi	a4,a4,-302 # 80012bc8 <cpus+0x8>
    80001cfe:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001d00:	4c11                	li	s8,4
        c->proc = p;
    80001d02:	079e                	slli	a5,a5,0x7
    80001d04:	00011a17          	auipc	s4,0x11
    80001d08:	95ca0a13          	addi	s4,s4,-1700 # 80012660 <global_queue_lock>
    80001d0c:	9a3e                	add	s4,s4,a5
        found = 1;
    80001d0e:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d10:	0002c997          	auipc	s3,0x2c
    80001d14:	ef898993          	addi	s3,s3,-264 # 8002dc08 <tickslock>
    80001d18:	a0b1                	j	80001d64 <scheduler+0x9c>
      release(&p->lock);
    80001d1a:	8526                	mv	a0,s1
    80001d1c:	f71fe0ef          	jal	80000c8c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d20:	6b048493          	addi	s1,s1,1712
    80001d24:	03348663          	beq	s1,s3,80001d50 <scheduler+0x88>
      acquire(&p->lock);
    80001d28:	8526                	mv	a0,s1
    80001d2a:	ecbfe0ef          	jal	80000bf4 <acquire>
      if(p->state == RUNNABLE) {
    80001d2e:	5604a783          	lw	a5,1376(s1)
    80001d32:	ff2794e3          	bne	a5,s2,80001d1a <scheduler+0x52>
        p->state = RUNNING;
    80001d36:	5784a023          	sw	s8,1376(s1)
        c->proc = p;
    80001d3a:	569a3023          	sd	s1,1376(s4)
        swtch(&c->context, &p->context);
    80001d3e:	5a848593          	addi	a1,s1,1448
    80001d42:	855a                	mv	a0,s6
    80001d44:	011000ef          	jal	80002554 <swtch>
        c->proc = 0;
    80001d48:	560a3023          	sd	zero,1376(s4)
        found = 1;
    80001d4c:	8ade                	mv	s5,s7
    80001d4e:	b7f1                	j	80001d1a <scheduler+0x52>
    if(found == 0) {
    80001d50:	000a9a63          	bnez	s5,80001d64 <scheduler+0x9c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d54:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d58:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d5c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001d60:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d64:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d68:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d6c:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001d70:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d72:	00011497          	auipc	s1,0x11
    80001d76:	29648493          	addi	s1,s1,662 # 80013008 <proc>
      if(p->state == RUNNABLE) {
    80001d7a:	490d                	li	s2,3
    80001d7c:	b775                	j	80001d28 <scheduler+0x60>

0000000080001d7e <sched>:
{
    80001d7e:	7179                	addi	sp,sp,-48
    80001d80:	f406                	sd	ra,40(sp)
    80001d82:	f022                	sd	s0,32(sp)
    80001d84:	ec26                	sd	s1,24(sp)
    80001d86:	e84a                	sd	s2,16(sp)
    80001d88:	e44e                	sd	s3,8(sp)
    80001d8a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001d8c:	ad5ff0ef          	jal	80001860 <myproc>
    80001d90:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001d92:	df9fe0ef          	jal	80000b8a <holding>
    80001d96:	c935                	beqz	a0,80001e0a <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d98:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001d9a:	2781                	sext.w	a5,a5
    80001d9c:	079e                	slli	a5,a5,0x7
    80001d9e:	00011717          	auipc	a4,0x11
    80001da2:	8c270713          	addi	a4,a4,-1854 # 80012660 <global_queue_lock>
    80001da6:	97ba                	add	a5,a5,a4
    80001da8:	5d87a703          	lw	a4,1496(a5)
    80001dac:	4785                	li	a5,1
    80001dae:	06f71463          	bne	a4,a5,80001e16 <sched+0x98>
  if(p->state == RUNNING)
    80001db2:	5604a703          	lw	a4,1376(s1)
    80001db6:	4791                	li	a5,4
    80001db8:	06f70563          	beq	a4,a5,80001e22 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dbc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dc0:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001dc2:	e7b5                	bnez	a5,80001e2e <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001dc4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001dc6:	00011917          	auipc	s2,0x11
    80001dca:	89a90913          	addi	s2,s2,-1894 # 80012660 <global_queue_lock>
    80001dce:	2781                	sext.w	a5,a5
    80001dd0:	079e                	slli	a5,a5,0x7
    80001dd2:	97ca                	add	a5,a5,s2
    80001dd4:	5dc7a983          	lw	s3,1500(a5)
    80001dd8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001dda:	2781                	sext.w	a5,a5
    80001ddc:	079e                	slli	a5,a5,0x7
    80001dde:	00011597          	auipc	a1,0x11
    80001de2:	dea58593          	addi	a1,a1,-534 # 80012bc8 <cpus+0x8>
    80001de6:	95be                	add	a1,a1,a5
    80001de8:	5a848513          	addi	a0,s1,1448
    80001dec:	768000ef          	jal	80002554 <swtch>
    80001df0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001df2:	2781                	sext.w	a5,a5
    80001df4:	079e                	slli	a5,a5,0x7
    80001df6:	993e                	add	s2,s2,a5
    80001df8:	5d392e23          	sw	s3,1500(s2)
}
    80001dfc:	70a2                	ld	ra,40(sp)
    80001dfe:	7402                	ld	s0,32(sp)
    80001e00:	64e2                	ld	s1,24(sp)
    80001e02:	6942                	ld	s2,16(sp)
    80001e04:	69a2                	ld	s3,8(sp)
    80001e06:	6145                	addi	sp,sp,48
    80001e08:	8082                	ret
    panic("sched p->lock");
    80001e0a:	00005517          	auipc	a0,0x5
    80001e0e:	42650513          	addi	a0,a0,1062 # 80007230 <etext+0x230>
    80001e12:	983fe0ef          	jal	80000794 <panic>
    panic("sched locks");
    80001e16:	00005517          	auipc	a0,0x5
    80001e1a:	42a50513          	addi	a0,a0,1066 # 80007240 <etext+0x240>
    80001e1e:	977fe0ef          	jal	80000794 <panic>
    panic("sched running");
    80001e22:	00005517          	auipc	a0,0x5
    80001e26:	42e50513          	addi	a0,a0,1070 # 80007250 <etext+0x250>
    80001e2a:	96bfe0ef          	jal	80000794 <panic>
    panic("sched interruptible");
    80001e2e:	00005517          	auipc	a0,0x5
    80001e32:	43250513          	addi	a0,a0,1074 # 80007260 <etext+0x260>
    80001e36:	95ffe0ef          	jal	80000794 <panic>

0000000080001e3a <yield>:
{
    80001e3a:	1101                	addi	sp,sp,-32
    80001e3c:	ec06                	sd	ra,24(sp)
    80001e3e:	e822                	sd	s0,16(sp)
    80001e40:	e426                	sd	s1,8(sp)
    80001e42:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001e44:	a1dff0ef          	jal	80001860 <myproc>
    80001e48:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001e4a:	dabfe0ef          	jal	80000bf4 <acquire>
  p->state = RUNNABLE;
    80001e4e:	478d                	li	a5,3
    80001e50:	56f4a023          	sw	a5,1376(s1)
  sched();
    80001e54:	f2bff0ef          	jal	80001d7e <sched>
  release(&p->lock);
    80001e58:	8526                	mv	a0,s1
    80001e5a:	e33fe0ef          	jal	80000c8c <release>
}
    80001e5e:	60e2                	ld	ra,24(sp)
    80001e60:	6442                	ld	s0,16(sp)
    80001e62:	64a2                	ld	s1,8(sp)
    80001e64:	6105                	addi	sp,sp,32
    80001e66:	8082                	ret

0000000080001e68 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001e68:	7179                	addi	sp,sp,-48
    80001e6a:	f406                	sd	ra,40(sp)
    80001e6c:	f022                	sd	s0,32(sp)
    80001e6e:	ec26                	sd	s1,24(sp)
    80001e70:	e84a                	sd	s2,16(sp)
    80001e72:	e44e                	sd	s3,8(sp)
    80001e74:	1800                	addi	s0,sp,48
    80001e76:	89aa                	mv	s3,a0
    80001e78:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e7a:	9e7ff0ef          	jal	80001860 <myproc>
    80001e7e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001e80:	d75fe0ef          	jal	80000bf4 <acquire>
  release(lk);
    80001e84:	854a                	mv	a0,s2
    80001e86:	e07fe0ef          	jal	80000c8c <release>

  // Go to sleep.
  p->chan = chan;
    80001e8a:	5734b423          	sd	s3,1384(s1)
  p->state = SLEEPING;
    80001e8e:	4789                	li	a5,2
    80001e90:	56f4a023          	sw	a5,1376(s1)

  sched();
    80001e94:	eebff0ef          	jal	80001d7e <sched>

  // Tidy up.
  p->chan = 0;
    80001e98:	5604b423          	sd	zero,1384(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001e9c:	8526                	mv	a0,s1
    80001e9e:	deffe0ef          	jal	80000c8c <release>
  acquire(lk);
    80001ea2:	854a                	mv	a0,s2
    80001ea4:	d51fe0ef          	jal	80000bf4 <acquire>
}
    80001ea8:	70a2                	ld	ra,40(sp)
    80001eaa:	7402                	ld	s0,32(sp)
    80001eac:	64e2                	ld	s1,24(sp)
    80001eae:	6942                	ld	s2,16(sp)
    80001eb0:	69a2                	ld	s3,8(sp)
    80001eb2:	6145                	addi	sp,sp,48
    80001eb4:	8082                	ret

0000000080001eb6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001eb6:	7139                	addi	sp,sp,-64
    80001eb8:	fc06                	sd	ra,56(sp)
    80001eba:	f822                	sd	s0,48(sp)
    80001ebc:	f426                	sd	s1,40(sp)
    80001ebe:	f04a                	sd	s2,32(sp)
    80001ec0:	ec4e                	sd	s3,24(sp)
    80001ec2:	e852                	sd	s4,16(sp)
    80001ec4:	e456                	sd	s5,8(sp)
    80001ec6:	0080                	addi	s0,sp,64
    80001ec8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001eca:	00011497          	auipc	s1,0x11
    80001ece:	13e48493          	addi	s1,s1,318 # 80013008 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001ed2:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001ed4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ed6:	0002c917          	auipc	s2,0x2c
    80001eda:	d3290913          	addi	s2,s2,-718 # 8002dc08 <tickslock>
    80001ede:	a801                	j	80001eee <wakeup+0x38>
      }
      release(&p->lock);
    80001ee0:	8526                	mv	a0,s1
    80001ee2:	dabfe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ee6:	6b048493          	addi	s1,s1,1712
    80001eea:	03248463          	beq	s1,s2,80001f12 <wakeup+0x5c>
    if(p != myproc()){
    80001eee:	973ff0ef          	jal	80001860 <myproc>
    80001ef2:	fea48ae3          	beq	s1,a0,80001ee6 <wakeup+0x30>
      acquire(&p->lock);
    80001ef6:	8526                	mv	a0,s1
    80001ef8:	cfdfe0ef          	jal	80000bf4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001efc:	5604a783          	lw	a5,1376(s1)
    80001f00:	ff3790e3          	bne	a5,s3,80001ee0 <wakeup+0x2a>
    80001f04:	5684b783          	ld	a5,1384(s1)
    80001f08:	fd479ce3          	bne	a5,s4,80001ee0 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001f0c:	5754a023          	sw	s5,1376(s1)
    80001f10:	bfc1                	j	80001ee0 <wakeup+0x2a>
    }
  }
}
    80001f12:	70e2                	ld	ra,56(sp)
    80001f14:	7442                	ld	s0,48(sp)
    80001f16:	74a2                	ld	s1,40(sp)
    80001f18:	7902                	ld	s2,32(sp)
    80001f1a:	69e2                	ld	s3,24(sp)
    80001f1c:	6a42                	ld	s4,16(sp)
    80001f1e:	6aa2                	ld	s5,8(sp)
    80001f20:	6121                	addi	sp,sp,64
    80001f22:	8082                	ret

0000000080001f24 <reparent>:
{
    80001f24:	7179                	addi	sp,sp,-48
    80001f26:	f406                	sd	ra,40(sp)
    80001f28:	f022                	sd	s0,32(sp)
    80001f2a:	ec26                	sd	s1,24(sp)
    80001f2c:	e84a                	sd	s2,16(sp)
    80001f2e:	e44e                	sd	s3,8(sp)
    80001f30:	e052                	sd	s4,0(sp)
    80001f32:	1800                	addi	s0,sp,48
    80001f34:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f36:	00011497          	auipc	s1,0x11
    80001f3a:	0d248493          	addi	s1,s1,210 # 80013008 <proc>
      pp->parent = initproc;
    80001f3e:	00008a17          	auipc	s4,0x8
    80001f42:	5eaa0a13          	addi	s4,s4,1514 # 8000a528 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f46:	0002c997          	auipc	s3,0x2c
    80001f4a:	cc298993          	addi	s3,s3,-830 # 8002dc08 <tickslock>
    80001f4e:	a029                	j	80001f58 <reparent+0x34>
    80001f50:	6b048493          	addi	s1,s1,1712
    80001f54:	01348d63          	beq	s1,s3,80001f6e <reparent+0x4a>
    if(pp->parent == p){
    80001f58:	5804b783          	ld	a5,1408(s1)
    80001f5c:	ff279ae3          	bne	a5,s2,80001f50 <reparent+0x2c>
      pp->parent = initproc;
    80001f60:	000a3503          	ld	a0,0(s4)
    80001f64:	58a4b023          	sd	a0,1408(s1)
      wakeup(initproc);
    80001f68:	f4fff0ef          	jal	80001eb6 <wakeup>
    80001f6c:	b7d5                	j	80001f50 <reparent+0x2c>
}
    80001f6e:	70a2                	ld	ra,40(sp)
    80001f70:	7402                	ld	s0,32(sp)
    80001f72:	64e2                	ld	s1,24(sp)
    80001f74:	6942                	ld	s2,16(sp)
    80001f76:	69a2                	ld	s3,8(sp)
    80001f78:	6a02                	ld	s4,0(sp)
    80001f7a:	6145                	addi	sp,sp,48
    80001f7c:	8082                	ret

0000000080001f7e <exit>:
{
    80001f7e:	7179                	addi	sp,sp,-48
    80001f80:	f406                	sd	ra,40(sp)
    80001f82:	f022                	sd	s0,32(sp)
    80001f84:	ec26                	sd	s1,24(sp)
    80001f86:	e84a                	sd	s2,16(sp)
    80001f88:	e44e                	sd	s3,8(sp)
    80001f8a:	e052                	sd	s4,0(sp)
    80001f8c:	1800                	addi	s0,sp,48
    80001f8e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001f90:	8d1ff0ef          	jal	80001860 <myproc>
    80001f94:	89aa                	mv	s3,a0
  if(p == initproc)
    80001f96:	00008797          	auipc	a5,0x8
    80001f9a:	5927b783          	ld	a5,1426(a5) # 8000a528 <initproc>
    80001f9e:	61850493          	addi	s1,a0,1560
    80001fa2:	69850913          	addi	s2,a0,1688
    80001fa6:	00a79f63          	bne	a5,a0,80001fc4 <exit+0x46>
    panic("init exiting");
    80001faa:	00005517          	auipc	a0,0x5
    80001fae:	2ce50513          	addi	a0,a0,718 # 80007278 <etext+0x278>
    80001fb2:	fe2fe0ef          	jal	80000794 <panic>
      fileclose(f);
    80001fb6:	320020ef          	jal	800042d6 <fileclose>
      p->ofile[fd] = 0;
    80001fba:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001fbe:	04a1                	addi	s1,s1,8
    80001fc0:	01248563          	beq	s1,s2,80001fca <exit+0x4c>
    if(p->ofile[fd]){
    80001fc4:	6088                	ld	a0,0(s1)
    80001fc6:	f965                	bnez	a0,80001fb6 <exit+0x38>
    80001fc8:	bfdd                	j	80001fbe <exit+0x40>
  begin_op();
    80001fca:	6ef010ef          	jal	80003eb8 <begin_op>
  iput(p->cwd);
    80001fce:	6989b503          	ld	a0,1688(s3)
    80001fd2:	7d2010ef          	jal	800037a4 <iput>
  end_op();
    80001fd6:	74d010ef          	jal	80003f22 <end_op>
  p->cwd = 0;
    80001fda:	6809bc23          	sd	zero,1688(s3)
  acquire(&wait_lock);
    80001fde:	00011497          	auipc	s1,0x11
    80001fe2:	ffa48493          	addi	s1,s1,-6 # 80012fd8 <wait_lock>
    80001fe6:	8526                	mv	a0,s1
    80001fe8:	c0dfe0ef          	jal	80000bf4 <acquire>
  reparent(p);
    80001fec:	854e                	mv	a0,s3
    80001fee:	f37ff0ef          	jal	80001f24 <reparent>
  wakeup(p->parent);
    80001ff2:	5809b503          	ld	a0,1408(s3)
    80001ff6:	ec1ff0ef          	jal	80001eb6 <wakeup>
  acquire(&p->lock);
    80001ffa:	854e                	mv	a0,s3
    80001ffc:	bf9fe0ef          	jal	80000bf4 <acquire>
  p->xstate = status;
    80002000:	5749aa23          	sw	s4,1396(s3)
  p->state = ZOMBIE;
    80002004:	4795                	li	a5,5
    80002006:	56f9a023          	sw	a5,1376(s3)
  release(&wait_lock);
    8000200a:	8526                	mv	a0,s1
    8000200c:	c81fe0ef          	jal	80000c8c <release>
  sched();
    80002010:	d6fff0ef          	jal	80001d7e <sched>
  panic("zombie exit");
    80002014:	00005517          	auipc	a0,0x5
    80002018:	27450513          	addi	a0,a0,628 # 80007288 <etext+0x288>
    8000201c:	f78fe0ef          	jal	80000794 <panic>

0000000080002020 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002020:	7179                	addi	sp,sp,-48
    80002022:	f406                	sd	ra,40(sp)
    80002024:	f022                	sd	s0,32(sp)
    80002026:	ec26                	sd	s1,24(sp)
    80002028:	e84a                	sd	s2,16(sp)
    8000202a:	e44e                	sd	s3,8(sp)
    8000202c:	1800                	addi	s0,sp,48
    8000202e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002030:	00011497          	auipc	s1,0x11
    80002034:	fd848493          	addi	s1,s1,-40 # 80013008 <proc>
    80002038:	0002c997          	auipc	s3,0x2c
    8000203c:	bd098993          	addi	s3,s3,-1072 # 8002dc08 <tickslock>
    acquire(&p->lock);
    80002040:	8526                	mv	a0,s1
    80002042:	bb3fe0ef          	jal	80000bf4 <acquire>
    if(p->pid == pid){
    80002046:	5784a783          	lw	a5,1400(s1)
    8000204a:	01278b63          	beq	a5,s2,80002060 <kill+0x40>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000204e:	8526                	mv	a0,s1
    80002050:	c3dfe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002054:	6b048493          	addi	s1,s1,1712
    80002058:	ff3494e3          	bne	s1,s3,80002040 <kill+0x20>
  }
  return -1;
    8000205c:	557d                	li	a0,-1
    8000205e:	a829                	j	80002078 <kill+0x58>
      p->killed = 1;
    80002060:	4785                	li	a5,1
    80002062:	56f4a823          	sw	a5,1392(s1)
      if(p->state == SLEEPING){
    80002066:	5604a703          	lw	a4,1376(s1)
    8000206a:	4789                	li	a5,2
    8000206c:	00f70d63          	beq	a4,a5,80002086 <kill+0x66>
      release(&p->lock);
    80002070:	8526                	mv	a0,s1
    80002072:	c1bfe0ef          	jal	80000c8c <release>
      return 0;
    80002076:	4501                	li	a0,0
}
    80002078:	70a2                	ld	ra,40(sp)
    8000207a:	7402                	ld	s0,32(sp)
    8000207c:	64e2                	ld	s1,24(sp)
    8000207e:	6942                	ld	s2,16(sp)
    80002080:	69a2                	ld	s3,8(sp)
    80002082:	6145                	addi	sp,sp,48
    80002084:	8082                	ret
        p->state = RUNNABLE;
    80002086:	478d                	li	a5,3
    80002088:	56f4a023          	sw	a5,1376(s1)
    8000208c:	b7d5                	j	80002070 <kill+0x50>

000000008000208e <setkilled>:

void
setkilled(struct proc *p)
{
    8000208e:	1101                	addi	sp,sp,-32
    80002090:	ec06                	sd	ra,24(sp)
    80002092:	e822                	sd	s0,16(sp)
    80002094:	e426                	sd	s1,8(sp)
    80002096:	1000                	addi	s0,sp,32
    80002098:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000209a:	b5bfe0ef          	jal	80000bf4 <acquire>
  p->killed = 1;
    8000209e:	4785                	li	a5,1
    800020a0:	56f4a823          	sw	a5,1392(s1)
  release(&p->lock);
    800020a4:	8526                	mv	a0,s1
    800020a6:	be7fe0ef          	jal	80000c8c <release>
}
    800020aa:	60e2                	ld	ra,24(sp)
    800020ac:	6442                	ld	s0,16(sp)
    800020ae:	64a2                	ld	s1,8(sp)
    800020b0:	6105                	addi	sp,sp,32
    800020b2:	8082                	ret

00000000800020b4 <killed>:

int
killed(struct proc *p)
{
    800020b4:	1101                	addi	sp,sp,-32
    800020b6:	ec06                	sd	ra,24(sp)
    800020b8:	e822                	sd	s0,16(sp)
    800020ba:	e426                	sd	s1,8(sp)
    800020bc:	e04a                	sd	s2,0(sp)
    800020be:	1000                	addi	s0,sp,32
    800020c0:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800020c2:	b33fe0ef          	jal	80000bf4 <acquire>
  k = p->killed;
    800020c6:	5704a903          	lw	s2,1392(s1)
  release(&p->lock);
    800020ca:	8526                	mv	a0,s1
    800020cc:	bc1fe0ef          	jal	80000c8c <release>
  return k;
}
    800020d0:	854a                	mv	a0,s2
    800020d2:	60e2                	ld	ra,24(sp)
    800020d4:	6442                	ld	s0,16(sp)
    800020d6:	64a2                	ld	s1,8(sp)
    800020d8:	6902                	ld	s2,0(sp)
    800020da:	6105                	addi	sp,sp,32
    800020dc:	8082                	ret

00000000800020de <wait>:
{
    800020de:	715d                	addi	sp,sp,-80
    800020e0:	e486                	sd	ra,72(sp)
    800020e2:	e0a2                	sd	s0,64(sp)
    800020e4:	fc26                	sd	s1,56(sp)
    800020e6:	f84a                	sd	s2,48(sp)
    800020e8:	f44e                	sd	s3,40(sp)
    800020ea:	f052                	sd	s4,32(sp)
    800020ec:	ec56                	sd	s5,24(sp)
    800020ee:	e85a                	sd	s6,16(sp)
    800020f0:	e45e                	sd	s7,8(sp)
    800020f2:	e062                	sd	s8,0(sp)
    800020f4:	0880                	addi	s0,sp,80
    800020f6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800020f8:	f68ff0ef          	jal	80001860 <myproc>
    800020fc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800020fe:	00011517          	auipc	a0,0x11
    80002102:	eda50513          	addi	a0,a0,-294 # 80012fd8 <wait_lock>
    80002106:	aeffe0ef          	jal	80000bf4 <acquire>
    havekids = 0;
    8000210a:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000210c:	4a15                	li	s4,5
        havekids = 1;
    8000210e:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002110:	0002c997          	auipc	s3,0x2c
    80002114:	af898993          	addi	s3,s3,-1288 # 8002dc08 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002118:	00011c17          	auipc	s8,0x11
    8000211c:	ec0c0c13          	addi	s8,s8,-320 # 80012fd8 <wait_lock>
    80002120:	a045                	j	800021c0 <wait+0xe2>
          pid = pp->pid;
    80002122:	5784a983          	lw	s3,1400(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002126:	000b0c63          	beqz	s6,8000213e <wait+0x60>
    8000212a:	4691                	li	a3,4
    8000212c:	57448613          	addi	a2,s1,1396
    80002130:	85da                	mv	a1,s6
    80002132:	59893503          	ld	a0,1432(s2)
    80002136:	c1cff0ef          	jal	80001552 <copyout>
    8000213a:	02054b63          	bltz	a0,80002170 <wait+0x92>
          freeproc(pp);
    8000213e:	8526                	mv	a0,s1
    80002140:	895ff0ef          	jal	800019d4 <freeproc>
          release(&pp->lock);
    80002144:	8526                	mv	a0,s1
    80002146:	b47fe0ef          	jal	80000c8c <release>
          release(&wait_lock);
    8000214a:	00011517          	auipc	a0,0x11
    8000214e:	e8e50513          	addi	a0,a0,-370 # 80012fd8 <wait_lock>
    80002152:	b3bfe0ef          	jal	80000c8c <release>
}
    80002156:	854e                	mv	a0,s3
    80002158:	60a6                	ld	ra,72(sp)
    8000215a:	6406                	ld	s0,64(sp)
    8000215c:	74e2                	ld	s1,56(sp)
    8000215e:	7942                	ld	s2,48(sp)
    80002160:	79a2                	ld	s3,40(sp)
    80002162:	7a02                	ld	s4,32(sp)
    80002164:	6ae2                	ld	s5,24(sp)
    80002166:	6b42                	ld	s6,16(sp)
    80002168:	6ba2                	ld	s7,8(sp)
    8000216a:	6c02                	ld	s8,0(sp)
    8000216c:	6161                	addi	sp,sp,80
    8000216e:	8082                	ret
            release(&pp->lock);
    80002170:	8526                	mv	a0,s1
    80002172:	b1bfe0ef          	jal	80000c8c <release>
            release(&wait_lock);
    80002176:	00011517          	auipc	a0,0x11
    8000217a:	e6250513          	addi	a0,a0,-414 # 80012fd8 <wait_lock>
    8000217e:	b0ffe0ef          	jal	80000c8c <release>
            return -1;
    80002182:	59fd                	li	s3,-1
    80002184:	bfc9                	j	80002156 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002186:	6b048493          	addi	s1,s1,1712
    8000218a:	03348263          	beq	s1,s3,800021ae <wait+0xd0>
      if(pp->parent == p){
    8000218e:	5804b783          	ld	a5,1408(s1)
    80002192:	ff279ae3          	bne	a5,s2,80002186 <wait+0xa8>
        acquire(&pp->lock);
    80002196:	8526                	mv	a0,s1
    80002198:	a5dfe0ef          	jal	80000bf4 <acquire>
        if(pp->state == ZOMBIE){
    8000219c:	5604a783          	lw	a5,1376(s1)
    800021a0:	f94781e3          	beq	a5,s4,80002122 <wait+0x44>
        release(&pp->lock);
    800021a4:	8526                	mv	a0,s1
    800021a6:	ae7fe0ef          	jal	80000c8c <release>
        havekids = 1;
    800021aa:	8756                	mv	a4,s5
    800021ac:	bfe9                	j	80002186 <wait+0xa8>
    if(!havekids || killed(p)){
    800021ae:	cf19                	beqz	a4,800021cc <wait+0xee>
    800021b0:	854a                	mv	a0,s2
    800021b2:	f03ff0ef          	jal	800020b4 <killed>
    800021b6:	e919                	bnez	a0,800021cc <wait+0xee>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021b8:	85e2                	mv	a1,s8
    800021ba:	854a                	mv	a0,s2
    800021bc:	cadff0ef          	jal	80001e68 <sleep>
    havekids = 0;
    800021c0:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021c2:	00011497          	auipc	s1,0x11
    800021c6:	e4648493          	addi	s1,s1,-442 # 80013008 <proc>
    800021ca:	b7d1                	j	8000218e <wait+0xb0>
      release(&wait_lock);
    800021cc:	00011517          	auipc	a0,0x11
    800021d0:	e0c50513          	addi	a0,a0,-500 # 80012fd8 <wait_lock>
    800021d4:	ab9fe0ef          	jal	80000c8c <release>
      return -1;
    800021d8:	59fd                	li	s3,-1
    800021da:	bfb5                	j	80002156 <wait+0x78>

00000000800021dc <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800021dc:	7179                	addi	sp,sp,-48
    800021de:	f406                	sd	ra,40(sp)
    800021e0:	f022                	sd	s0,32(sp)
    800021e2:	ec26                	sd	s1,24(sp)
    800021e4:	e84a                	sd	s2,16(sp)
    800021e6:	e44e                	sd	s3,8(sp)
    800021e8:	e052                	sd	s4,0(sp)
    800021ea:	1800                	addi	s0,sp,48
    800021ec:	84aa                	mv	s1,a0
    800021ee:	892e                	mv	s2,a1
    800021f0:	89b2                	mv	s3,a2
    800021f2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800021f4:	e6cff0ef          	jal	80001860 <myproc>
  if(user_dst){
    800021f8:	c085                	beqz	s1,80002218 <either_copyout+0x3c>
    return copyout(p->pagetable, dst, src, len);
    800021fa:	86d2                	mv	a3,s4
    800021fc:	864e                	mv	a2,s3
    800021fe:	85ca                	mv	a1,s2
    80002200:	59853503          	ld	a0,1432(a0)
    80002204:	b4eff0ef          	jal	80001552 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002208:	70a2                	ld	ra,40(sp)
    8000220a:	7402                	ld	s0,32(sp)
    8000220c:	64e2                	ld	s1,24(sp)
    8000220e:	6942                	ld	s2,16(sp)
    80002210:	69a2                	ld	s3,8(sp)
    80002212:	6a02                	ld	s4,0(sp)
    80002214:	6145                	addi	sp,sp,48
    80002216:	8082                	ret
    memmove((char *)dst, src, len);
    80002218:	000a061b          	sext.w	a2,s4
    8000221c:	85ce                	mv	a1,s3
    8000221e:	854a                	mv	a0,s2
    80002220:	b05fe0ef          	jal	80000d24 <memmove>
    return 0;
    80002224:	8526                	mv	a0,s1
    80002226:	b7cd                	j	80002208 <either_copyout+0x2c>

0000000080002228 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002228:	7179                	addi	sp,sp,-48
    8000222a:	f406                	sd	ra,40(sp)
    8000222c:	f022                	sd	s0,32(sp)
    8000222e:	ec26                	sd	s1,24(sp)
    80002230:	e84a                	sd	s2,16(sp)
    80002232:	e44e                	sd	s3,8(sp)
    80002234:	e052                	sd	s4,0(sp)
    80002236:	1800                	addi	s0,sp,48
    80002238:	892a                	mv	s2,a0
    8000223a:	84ae                	mv	s1,a1
    8000223c:	89b2                	mv	s3,a2
    8000223e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002240:	e20ff0ef          	jal	80001860 <myproc>
  if(user_src){
    80002244:	c085                	beqz	s1,80002264 <either_copyin+0x3c>
    return copyin(p->pagetable, dst, src, len);
    80002246:	86d2                	mv	a3,s4
    80002248:	864e                	mv	a2,s3
    8000224a:	85ca                	mv	a1,s2
    8000224c:	59853503          	ld	a0,1432(a0)
    80002250:	bd8ff0ef          	jal	80001628 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002254:	70a2                	ld	ra,40(sp)
    80002256:	7402                	ld	s0,32(sp)
    80002258:	64e2                	ld	s1,24(sp)
    8000225a:	6942                	ld	s2,16(sp)
    8000225c:	69a2                	ld	s3,8(sp)
    8000225e:	6a02                	ld	s4,0(sp)
    80002260:	6145                	addi	sp,sp,48
    80002262:	8082                	ret
    memmove(dst, (char*)src, len);
    80002264:	000a061b          	sext.w	a2,s4
    80002268:	85ce                	mv	a1,s3
    8000226a:	854a                	mv	a0,s2
    8000226c:	ab9fe0ef          	jal	80000d24 <memmove>
    return 0;
    80002270:	8526                	mv	a0,s1
    80002272:	b7cd                	j	80002254 <either_copyin+0x2c>

0000000080002274 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002274:	715d                	addi	sp,sp,-80
    80002276:	e486                	sd	ra,72(sp)
    80002278:	e0a2                	sd	s0,64(sp)
    8000227a:	fc26                	sd	s1,56(sp)
    8000227c:	f84a                	sd	s2,48(sp)
    8000227e:	f44e                	sd	s3,40(sp)
    80002280:	f052                	sd	s4,32(sp)
    80002282:	ec56                	sd	s5,24(sp)
    80002284:	e85a                	sd	s6,16(sp)
    80002286:	e45e                	sd	s7,8(sp)
    80002288:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000228a:	00005517          	auipc	a0,0x5
    8000228e:	dee50513          	addi	a0,a0,-530 # 80007078 <etext+0x78>
    80002292:	a30fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002296:	00011497          	auipc	s1,0x11
    8000229a:	41248493          	addi	s1,s1,1042 # 800136a8 <proc+0x6a0>
    8000229e:	0002c917          	auipc	s2,0x2c
    800022a2:	00a90913          	addi	s2,s2,10 # 8002e2a8 <bcache+0x688>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022a6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800022a8:	00005997          	auipc	s3,0x5
    800022ac:	ff098993          	addi	s3,s3,-16 # 80007298 <etext+0x298>
    printf("%d %s %s", p->pid, state, p->name);
    800022b0:	00005a97          	auipc	s5,0x5
    800022b4:	ff0a8a93          	addi	s5,s5,-16 # 800072a0 <etext+0x2a0>
    printf("\n");
    800022b8:	00005a17          	auipc	s4,0x5
    800022bc:	dc0a0a13          	addi	s4,s4,-576 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022c0:	00005b97          	auipc	s7,0x5
    800022c4:	600b8b93          	addi	s7,s7,1536 # 800078c0 <states.0>
    800022c8:	a829                	j	800022e2 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800022ca:	ed86a583          	lw	a1,-296(a3)
    800022ce:	8556                	mv	a0,s5
    800022d0:	9f2fe0ef          	jal	800004c2 <printf>
    printf("\n");
    800022d4:	8552                	mv	a0,s4
    800022d6:	9ecfe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800022da:	6b048493          	addi	s1,s1,1712
    800022de:	03248263          	beq	s1,s2,80002302 <procdump+0x8e>
    if(p->state == UNUSED)
    800022e2:	86a6                	mv	a3,s1
    800022e4:	ec04a783          	lw	a5,-320(s1)
    800022e8:	dbed                	beqz	a5,800022da <procdump+0x66>
      state = "???";
    800022ea:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022ec:	fcfb6fe3          	bltu	s6,a5,800022ca <procdump+0x56>
    800022f0:	02079713          	slli	a4,a5,0x20
    800022f4:	01d75793          	srli	a5,a4,0x1d
    800022f8:	97de                	add	a5,a5,s7
    800022fa:	6390                	ld	a2,0(a5)
    800022fc:	f679                	bnez	a2,800022ca <procdump+0x56>
      state = "???";
    800022fe:	864e                	mv	a2,s3
    80002300:	b7e9                	j	800022ca <procdump+0x56>
  }
}
    80002302:	60a6                	ld	ra,72(sp)
    80002304:	6406                	ld	s0,64(sp)
    80002306:	74e2                	ld	s1,56(sp)
    80002308:	7942                	ld	s2,48(sp)
    8000230a:	79a2                	ld	s3,40(sp)
    8000230c:	7a02                	ld	s4,32(sp)
    8000230e:	6ae2                	ld	s5,24(sp)
    80002310:	6b42                	ld	s6,16(sp)
    80002312:	6ba2                	ld	s7,8(sp)
    80002314:	6161                	addi	sp,sp,80
    80002316:	8082                	ret

0000000080002318 <init_msg_queue>:

// Initialize message queue
void init_msg_queue(struct msg_queue *queue) {
    80002318:	1141                	addi	sp,sp,-16
    8000231a:	e406                	sd	ra,8(sp)
    8000231c:	e022                	sd	s0,0(sp)
    8000231e:	0800                	addi	s0,sp,16
    queue->head = 0;
    80002320:	52052423          	sw	zero,1320(a0)
    queue->tail = 0;
    80002324:	52052623          	sw	zero,1324(a0)
    initlock(&queue->lock, "msg_queue");
    80002328:	00005597          	auipc	a1,0x5
    8000232c:	f8858593          	addi	a1,a1,-120 # 800072b0 <etext+0x2b0>
    80002330:	53050513          	addi	a0,a0,1328
    80002334:	841fe0ef          	jal	80000b74 <initlock>
}
    80002338:	60a2                	ld	ra,8(sp)
    8000233a:	6402                	ld	s0,0(sp)
    8000233c:	0141                	addi	sp,sp,16
    8000233e:	8082                	ret

0000000080002340 <procinit>:
{
    80002340:	7139                	addi	sp,sp,-64
    80002342:	fc06                	sd	ra,56(sp)
    80002344:	f822                	sd	s0,48(sp)
    80002346:	f426                	sd	s1,40(sp)
    80002348:	f04a                	sd	s2,32(sp)
    8000234a:	ec4e                	sd	s3,24(sp)
    8000234c:	e852                	sd	s4,16(sp)
    8000234e:	e456                	sd	s5,8(sp)
    80002350:	e05a                	sd	s6,0(sp)
    80002352:	0080                	addi	s0,sp,64
  initlock(&pid_lock, "nextpid");
    80002354:	00005597          	auipc	a1,0x5
    80002358:	f6c58593          	addi	a1,a1,-148 # 800072c0 <etext+0x2c0>
    8000235c:	00011517          	auipc	a0,0x11
    80002360:	c6450513          	addi	a0,a0,-924 # 80012fc0 <pid_lock>
    80002364:	811fe0ef          	jal	80000b74 <initlock>
  initlock(&wait_lock, "wait_lock");
    80002368:	00005597          	auipc	a1,0x5
    8000236c:	f6058593          	addi	a1,a1,-160 # 800072c8 <etext+0x2c8>
    80002370:	00011517          	auipc	a0,0x11
    80002374:	c6850513          	addi	a0,a0,-920 # 80012fd8 <wait_lock>
    80002378:	ffcfe0ef          	jal	80000b74 <initlock>
 initlock(&ptable_lock, "ptable");
    8000237c:	00005597          	auipc	a1,0x5
    80002380:	f5c58593          	addi	a1,a1,-164 # 800072d8 <etext+0x2d8>
    80002384:	00011517          	auipc	a0,0x11
    80002388:	c6c50513          	addi	a0,a0,-916 # 80012ff0 <ptable_lock>
    8000238c:	fe8fe0ef          	jal	80000b74 <initlock>
 init_global_msg_queue(); 
    80002390:	bd6ff0ef          	jal	80001766 <init_global_msg_queue>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002394:	00011497          	auipc	s1,0x11
    80002398:	c7448493          	addi	s1,s1,-908 # 80013008 <proc>
      initlock(&p->lock, "proc");
    8000239c:	00005b17          	auipc	s6,0x5
    800023a0:	f44b0b13          	addi	s6,s6,-188 # 800072e0 <etext+0x2e0>
      p->kstack = KSTACK((int) (p - proc));
    800023a4:	8aa6                	mv	s5,s1
    800023a6:	077a0937          	lui	s2,0x77a0
    800023aa:	4c990913          	addi	s2,s2,1225 # 77a04c9 <_entry-0x7885fb37>
    800023ae:	0932                	slli	s2,s2,0xc
    800023b0:	f8d90913          	addi	s2,s2,-115
    800023b4:	0932                	slli	s2,s2,0xc
    800023b6:	28b90913          	addi	s2,s2,651
    800023ba:	0932                	slli	s2,s2,0xc
    800023bc:	c4390913          	addi	s2,s2,-957
    800023c0:	040009b7          	lui	s3,0x4000
    800023c4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800023c6:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800023c8:	0002ca17          	auipc	s4,0x2c
    800023cc:	840a0a13          	addi	s4,s4,-1984 # 8002dc08 <tickslock>
      init_msg_queue(&p->msg_queue);
    800023d0:	01848513          	addi	a0,s1,24
    800023d4:	f45ff0ef          	jal	80002318 <init_msg_queue>
      initlock(&p->lock, "proc");
    800023d8:	85da                	mv	a1,s6
    800023da:	8526                	mv	a0,s1
    800023dc:	f98fe0ef          	jal	80000b74 <initlock>
      p->state = UNUSED;
    800023e0:	5604a023          	sw	zero,1376(s1)
      p->kstack = KSTACK((int) (p - proc));
    800023e4:	415487b3          	sub	a5,s1,s5
    800023e8:	8791                	srai	a5,a5,0x4
    800023ea:	032787b3          	mul	a5,a5,s2
    800023ee:	2785                	addiw	a5,a5,1
    800023f0:	00d7979b          	slliw	a5,a5,0xd
    800023f4:	40f987b3          	sub	a5,s3,a5
    800023f8:	58f4b423          	sd	a5,1416(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800023fc:	6b048493          	addi	s1,s1,1712
    80002400:	fd4498e3          	bne	s1,s4,800023d0 <procinit+0x90>
}
    80002404:	70e2                	ld	ra,56(sp)
    80002406:	7442                	ld	s0,48(sp)
    80002408:	74a2                	ld	s1,40(sp)
    8000240a:	7902                	ld	s2,32(sp)
    8000240c:	69e2                	ld	s3,24(sp)
    8000240e:	6a42                	ld	s4,16(sp)
    80002410:	6aa2                	ld	s5,8(sp)
    80002412:	6b02                	ld	s6,0(sp)
    80002414:	6121                	addi	sp,sp,64
    80002416:	8082                	ret

0000000080002418 <msg_queue_full>:

// Check if the message queue is full
int msg_queue_full(struct msg_queue *queue) {
    80002418:	1141                	addi	sp,sp,-16
    8000241a:	e422                	sd	s0,8(sp)
    8000241c:	0800                	addi	s0,sp,16
    return ((queue->tail + 1) % MAX_MSGS) == queue->head;
    8000241e:	52c52783          	lw	a5,1324(a0)
    80002422:	2785                	addiw	a5,a5,1
    80002424:	4729                	li	a4,10
    80002426:	02e7e7bb          	remw	a5,a5,a4
    8000242a:	52852703          	lw	a4,1320(a0)
    8000242e:	40e78533          	sub	a0,a5,a4
}
    80002432:	00153513          	seqz	a0,a0
    80002436:	6422                	ld	s0,8(sp)
    80002438:	0141                	addi	sp,sp,16
    8000243a:	8082                	ret

000000008000243c <msg_queue_empty>:

// Check if the message queue is empty
int msg_queue_empty(struct msg_queue *queue) {
    8000243c:	1141                	addi	sp,sp,-16
    8000243e:	e422                	sd	s0,8(sp)
    80002440:	0800                	addi	s0,sp,16
    return queue->head == queue->tail;
    80002442:	52852783          	lw	a5,1320(a0)
    80002446:	52c52703          	lw	a4,1324(a0)
    8000244a:	40e78533          	sub	a0,a5,a4
}
    8000244e:	00153513          	seqz	a0,a0
    80002452:	6422                	ld	s0,8(sp)
    80002454:	0141                	addi	sp,sp,16
    80002456:	8082                	ret

0000000080002458 <send_message>:

int send_message(struct msg_queue *queue, struct msg *message) {
    80002458:	7179                	addi	sp,sp,-48
    8000245a:	f406                	sd	ra,40(sp)
    8000245c:	f022                	sd	s0,32(sp)
    8000245e:	e84a                	sd	s2,16(sp)
    80002460:	e052                	sd	s4,0(sp)
    80002462:	1800                	addi	s0,sp,48
    80002464:	8a2e                	mv	s4,a1
    acquire(&global_queue_lock);  // Lock the global queue before interacting
    80002466:	00010517          	auipc	a0,0x10
    8000246a:	1fa50513          	addi	a0,a0,506 # 80012660 <global_queue_lock>
    8000246e:	f86fe0ef          	jal	80000bf4 <acquire>

    // Check if the queue is full
    if (msg_queue_full(&global_msg_queue)) {
    80002472:	00010517          	auipc	a0,0x10
    80002476:	20650513          	addi	a0,a0,518 # 80012678 <global_msg_queue>
    8000247a:	f9fff0ef          	jal	80002418 <msg_queue_full>
    8000247e:	e921                	bnez	a0,800024ce <send_message+0x76>
    80002480:	ec26                	sd	s1,24(sp)
    80002482:	e44e                	sd	s3,8(sp)
    80002484:	892a                	mv	s2,a0
        release(&global_queue_lock);
        return -1;  // Queue is full, cannot send the message
    }

    // Add the message to the queue
    global_msg_queue.msgs[global_msg_queue.tail] = *message;
    80002486:	00010997          	auipc	s3,0x10
    8000248a:	1da98993          	addi	s3,s3,474 # 80012660 <global_queue_lock>
    8000248e:	5449a483          	lw	s1,1348(s3)
    80002492:	00549793          	slli	a5,s1,0x5
    80002496:	97a6                	add	a5,a5,s1
    80002498:	078a                	slli	a5,a5,0x2
    8000249a:	97ce                	add	a5,a5,s3
    8000249c:	08400613          	li	a2,132
    800024a0:	85d2                	mv	a1,s4
    800024a2:	01878513          	addi	a0,a5,24
    800024a6:	8dbfe0ef          	jal	80000d80 <memcpy>
    global_msg_queue.tail = (global_msg_queue.tail + 1) % MAX_MSGS;  // Wrap tail if necessary
    800024aa:	2485                	addiw	s1,s1,1
    800024ac:	47a9                	li	a5,10
    800024ae:	02f4e4bb          	remw	s1,s1,a5
    800024b2:	5499a223          	sw	s1,1348(s3)

    release(&global_queue_lock);  // Release lock after modifying the queue
    800024b6:	854e                	mv	a0,s3
    800024b8:	fd4fe0ef          	jal	80000c8c <release>
    800024bc:	64e2                	ld	s1,24(sp)
    800024be:	69a2                	ld	s3,8(sp)
    return 0;  // Successfully sent the message
}
    800024c0:	854a                	mv	a0,s2
    800024c2:	70a2                	ld	ra,40(sp)
    800024c4:	7402                	ld	s0,32(sp)
    800024c6:	6942                	ld	s2,16(sp)
    800024c8:	6a02                	ld	s4,0(sp)
    800024ca:	6145                	addi	sp,sp,48
    800024cc:	8082                	ret
        release(&global_queue_lock);
    800024ce:	00010517          	auipc	a0,0x10
    800024d2:	19250513          	addi	a0,a0,402 # 80012660 <global_queue_lock>
    800024d6:	fb6fe0ef          	jal	80000c8c <release>
        return -1;  // Queue is full, cannot send the message
    800024da:	597d                	li	s2,-1
    800024dc:	b7d5                	j	800024c0 <send_message+0x68>

00000000800024de <receive_message>:

// Modified receive_message function that uses global message queue
int receive_message(struct msg_queue *queue, struct msg *message) {
    800024de:	1101                	addi	sp,sp,-32
    800024e0:	ec06                	sd	ra,24(sp)
    800024e2:	e822                	sd	s0,16(sp)
    800024e4:	e426                	sd	s1,8(sp)
    800024e6:	e04a                	sd	s2,0(sp)
    800024e8:	1000                	addi	s0,sp,32
    800024ea:	892e                	mv	s2,a1
    acquire(&global_queue_lock);  // Lock the global queue before interacting
    800024ec:	00010497          	auipc	s1,0x10
    800024f0:	17448493          	addi	s1,s1,372 # 80012660 <global_queue_lock>
    800024f4:	8526                	mv	a0,s1
    800024f6:	efefe0ef          	jal	80000bf4 <acquire>
    return queue->head == queue->tail;
    800024fa:	5404a703          	lw	a4,1344(s1)

    // Check if the queue is empty
    if (msg_queue_empty(&global_msg_queue)) {
    800024fe:	5444a783          	lw	a5,1348(s1)
    80002502:	04e78463          	beq	a5,a4,8000254a <receive_message+0x6c>
        release(&global_queue_lock);
        return -1;  // No messages available in the queue
    }

    // Retrieve the message from the queue
    *message = global_msg_queue.msgs[global_msg_queue.head];
    80002506:	00010497          	auipc	s1,0x10
    8000250a:	15a48493          	addi	s1,s1,346 # 80012660 <global_queue_lock>
    8000250e:	00571793          	slli	a5,a4,0x5
    80002512:	97ba                	add	a5,a5,a4
    80002514:	078a                	slli	a5,a5,0x2
    80002516:	97a6                	add	a5,a5,s1
    80002518:	08400613          	li	a2,132
    8000251c:	01878593          	addi	a1,a5,24
    80002520:	854a                	mv	a0,s2
    80002522:	85ffe0ef          	jal	80000d80 <memcpy>
    global_msg_queue.head = (global_msg_queue.head + 1) % MAX_MSGS;  // Wrap head if necessary
    80002526:	5404a783          	lw	a5,1344(s1)
    8000252a:	2785                	addiw	a5,a5,1
    8000252c:	4729                	li	a4,10
    8000252e:	02e7e7bb          	remw	a5,a5,a4
    80002532:	54f4a023          	sw	a5,1344(s1)

    release(&global_queue_lock);  // Release lock after modifying the queue
    80002536:	8526                	mv	a0,s1
    80002538:	f54fe0ef          	jal	80000c8c <release>
    return 0;  // Successfully received the message
    8000253c:	4501                	li	a0,0
    8000253e:	60e2                	ld	ra,24(sp)
    80002540:	6442                	ld	s0,16(sp)
    80002542:	64a2                	ld	s1,8(sp)
    80002544:	6902                	ld	s2,0(sp)
    80002546:	6105                	addi	sp,sp,32
    80002548:	8082                	ret
        release(&global_queue_lock);
    8000254a:	8526                	mv	a0,s1
    8000254c:	f40fe0ef          	jal	80000c8c <release>
        return -1;  // No messages available in the queue
    80002550:	557d                	li	a0,-1
    80002552:	b7f5                	j	8000253e <receive_message+0x60>

0000000080002554 <swtch>:
    80002554:	00153023          	sd	ra,0(a0)
    80002558:	00253423          	sd	sp,8(a0)
    8000255c:	e900                	sd	s0,16(a0)
    8000255e:	ed04                	sd	s1,24(a0)
    80002560:	03253023          	sd	s2,32(a0)
    80002564:	03353423          	sd	s3,40(a0)
    80002568:	03453823          	sd	s4,48(a0)
    8000256c:	03553c23          	sd	s5,56(a0)
    80002570:	05653023          	sd	s6,64(a0)
    80002574:	05753423          	sd	s7,72(a0)
    80002578:	05853823          	sd	s8,80(a0)
    8000257c:	05953c23          	sd	s9,88(a0)
    80002580:	07a53023          	sd	s10,96(a0)
    80002584:	07b53423          	sd	s11,104(a0)
    80002588:	0005b083          	ld	ra,0(a1)
    8000258c:	0085b103          	ld	sp,8(a1)
    80002590:	6980                	ld	s0,16(a1)
    80002592:	6d84                	ld	s1,24(a1)
    80002594:	0205b903          	ld	s2,32(a1)
    80002598:	0285b983          	ld	s3,40(a1)
    8000259c:	0305ba03          	ld	s4,48(a1)
    800025a0:	0385ba83          	ld	s5,56(a1)
    800025a4:	0405bb03          	ld	s6,64(a1)
    800025a8:	0485bb83          	ld	s7,72(a1)
    800025ac:	0505bc03          	ld	s8,80(a1)
    800025b0:	0585bc83          	ld	s9,88(a1)
    800025b4:	0605bd03          	ld	s10,96(a1)
    800025b8:	0685bd83          	ld	s11,104(a1)
    800025bc:	8082                	ret

00000000800025be <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800025be:	1141                	addi	sp,sp,-16
    800025c0:	e406                	sd	ra,8(sp)
    800025c2:	e022                	sd	s0,0(sp)
    800025c4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800025c6:	00005597          	auipc	a1,0x5
    800025ca:	d5258593          	addi	a1,a1,-686 # 80007318 <etext+0x318>
    800025ce:	0002b517          	auipc	a0,0x2b
    800025d2:	63a50513          	addi	a0,a0,1594 # 8002dc08 <tickslock>
    800025d6:	d9efe0ef          	jal	80000b74 <initlock>
}
    800025da:	60a2                	ld	ra,8(sp)
    800025dc:	6402                	ld	s0,0(sp)
    800025de:	0141                	addi	sp,sp,16
    800025e0:	8082                	ret

00000000800025e2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800025e2:	1141                	addi	sp,sp,-16
    800025e4:	e422                	sd	s0,8(sp)
    800025e6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025e8:	00003797          	auipc	a5,0x3
    800025ec:	06878793          	addi	a5,a5,104 # 80005650 <kernelvec>
    800025f0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800025f4:	6422                	ld	s0,8(sp)
    800025f6:	0141                	addi	sp,sp,16
    800025f8:	8082                	ret

00000000800025fa <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800025fa:	1141                	addi	sp,sp,-16
    800025fc:	e406                	sd	ra,8(sp)
    800025fe:	e022                	sd	s0,0(sp)
    80002600:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002602:	a5eff0ef          	jal	80001860 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002606:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000260a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000260c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002610:	00004697          	auipc	a3,0x4
    80002614:	9f068693          	addi	a3,a3,-1552 # 80006000 <_trampoline>
    80002618:	00004717          	auipc	a4,0x4
    8000261c:	9e870713          	addi	a4,a4,-1560 # 80006000 <_trampoline>
    80002620:	8f15                	sub	a4,a4,a3
    80002622:	040007b7          	lui	a5,0x4000
    80002626:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002628:	07b2                	slli	a5,a5,0xc
    8000262a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000262c:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002630:	5a053703          	ld	a4,1440(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002634:	18002673          	csrr	a2,satp
    80002638:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000263a:	5a053603          	ld	a2,1440(a0)
    8000263e:	58853703          	ld	a4,1416(a0)
    80002642:	6585                	lui	a1,0x1
    80002644:	972e                	add	a4,a4,a1
    80002646:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002648:	5a053703          	ld	a4,1440(a0)
    8000264c:	00000617          	auipc	a2,0x0
    80002650:	11660613          	addi	a2,a2,278 # 80002762 <usertrap>
    80002654:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002656:	5a053703          	ld	a4,1440(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000265a:	8612                	mv	a2,tp
    8000265c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000265e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002662:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002666:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000266a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000266e:	5a053703          	ld	a4,1440(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002672:	6f18                	ld	a4,24(a4)
    80002674:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002678:	59853503          	ld	a0,1432(a0)
    8000267c:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000267e:	00004717          	auipc	a4,0x4
    80002682:	a1e70713          	addi	a4,a4,-1506 # 8000609c <userret>
    80002686:	8f15                	sub	a4,a4,a3
    80002688:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000268a:	577d                	li	a4,-1
    8000268c:	177e                	slli	a4,a4,0x3f
    8000268e:	8d59                	or	a0,a0,a4
    80002690:	9782                	jalr	a5
}
    80002692:	60a2                	ld	ra,8(sp)
    80002694:	6402                	ld	s0,0(sp)
    80002696:	0141                	addi	sp,sp,16
    80002698:	8082                	ret

000000008000269a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000269a:	1101                	addi	sp,sp,-32
    8000269c:	ec06                	sd	ra,24(sp)
    8000269e:	e822                	sd	s0,16(sp)
    800026a0:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800026a2:	992ff0ef          	jal	80001834 <cpuid>
    800026a6:	cd11                	beqz	a0,800026c2 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800026a8:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800026ac:	000f4737          	lui	a4,0xf4
    800026b0:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800026b4:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800026b6:	14d79073          	csrw	stimecmp,a5
}
    800026ba:	60e2                	ld	ra,24(sp)
    800026bc:	6442                	ld	s0,16(sp)
    800026be:	6105                	addi	sp,sp,32
    800026c0:	8082                	ret
    800026c2:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800026c4:	0002b497          	auipc	s1,0x2b
    800026c8:	54448493          	addi	s1,s1,1348 # 8002dc08 <tickslock>
    800026cc:	8526                	mv	a0,s1
    800026ce:	d26fe0ef          	jal	80000bf4 <acquire>
    ticks++;
    800026d2:	00008517          	auipc	a0,0x8
    800026d6:	e5e50513          	addi	a0,a0,-418 # 8000a530 <ticks>
    800026da:	411c                	lw	a5,0(a0)
    800026dc:	2785                	addiw	a5,a5,1
    800026de:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800026e0:	fd6ff0ef          	jal	80001eb6 <wakeup>
    release(&tickslock);
    800026e4:	8526                	mv	a0,s1
    800026e6:	da6fe0ef          	jal	80000c8c <release>
    800026ea:	64a2                	ld	s1,8(sp)
    800026ec:	bf75                	j	800026a8 <clockintr+0xe>

00000000800026ee <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800026ee:	1101                	addi	sp,sp,-32
    800026f0:	ec06                	sd	ra,24(sp)
    800026f2:	e822                	sd	s0,16(sp)
    800026f4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026f6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800026fa:	57fd                	li	a5,-1
    800026fc:	17fe                	slli	a5,a5,0x3f
    800026fe:	07a5                	addi	a5,a5,9
    80002700:	00f70c63          	beq	a4,a5,80002718 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002704:	57fd                	li	a5,-1
    80002706:	17fe                	slli	a5,a5,0x3f
    80002708:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000270a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000270c:	04f70763          	beq	a4,a5,8000275a <devintr+0x6c>
  }
}
    80002710:	60e2                	ld	ra,24(sp)
    80002712:	6442                	ld	s0,16(sp)
    80002714:	6105                	addi	sp,sp,32
    80002716:	8082                	ret
    80002718:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000271a:	7e3020ef          	jal	800056fc <plic_claim>
    8000271e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002720:	47a9                	li	a5,10
    80002722:	00f50963          	beq	a0,a5,80002734 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80002726:	4785                	li	a5,1
    80002728:	00f50963          	beq	a0,a5,8000273a <devintr+0x4c>
    return 1;
    8000272c:	4505                	li	a0,1
    } else if(irq){
    8000272e:	e889                	bnez	s1,80002740 <devintr+0x52>
    80002730:	64a2                	ld	s1,8(sp)
    80002732:	bff9                	j	80002710 <devintr+0x22>
      uartintr();
    80002734:	ad2fe0ef          	jal	80000a06 <uartintr>
    if(irq)
    80002738:	a819                	j	8000274e <devintr+0x60>
      virtio_disk_intr();
    8000273a:	488030ef          	jal	80005bc2 <virtio_disk_intr>
    if(irq)
    8000273e:	a801                	j	8000274e <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002740:	85a6                	mv	a1,s1
    80002742:	00005517          	auipc	a0,0x5
    80002746:	bde50513          	addi	a0,a0,-1058 # 80007320 <etext+0x320>
    8000274a:	d79fd0ef          	jal	800004c2 <printf>
      plic_complete(irq);
    8000274e:	8526                	mv	a0,s1
    80002750:	7cd020ef          	jal	8000571c <plic_complete>
    return 1;
    80002754:	4505                	li	a0,1
    80002756:	64a2                	ld	s1,8(sp)
    80002758:	bf65                	j	80002710 <devintr+0x22>
    clockintr();
    8000275a:	f41ff0ef          	jal	8000269a <clockintr>
    return 2;
    8000275e:	4509                	li	a0,2
    80002760:	bf45                	j	80002710 <devintr+0x22>

0000000080002762 <usertrap>:
{
    80002762:	1101                	addi	sp,sp,-32
    80002764:	ec06                	sd	ra,24(sp)
    80002766:	e822                	sd	s0,16(sp)
    80002768:	e426                	sd	s1,8(sp)
    8000276a:	e04a                	sd	s2,0(sp)
    8000276c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000276e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002772:	1007f793          	andi	a5,a5,256
    80002776:	ef8d                	bnez	a5,800027b0 <usertrap+0x4e>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002778:	00003797          	auipc	a5,0x3
    8000277c:	ed878793          	addi	a5,a5,-296 # 80005650 <kernelvec>
    80002780:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002784:	8dcff0ef          	jal	80001860 <myproc>
    80002788:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000278a:	5a053783          	ld	a5,1440(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000278e:	14102773          	csrr	a4,sepc
    80002792:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002794:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002798:	47a1                	li	a5,8
    8000279a:	02f70163          	beq	a4,a5,800027bc <usertrap+0x5a>
  } else if((which_dev = devintr()) != 0){
    8000279e:	f51ff0ef          	jal	800026ee <devintr>
    800027a2:	892a                	mv	s2,a0
    800027a4:	c13d                	beqz	a0,8000280a <usertrap+0xa8>
  if(killed(p))
    800027a6:	8526                	mv	a0,s1
    800027a8:	90dff0ef          	jal	800020b4 <killed>
    800027ac:	c121                	beqz	a0,800027ec <usertrap+0x8a>
    800027ae:	a825                	j	800027e6 <usertrap+0x84>
    panic("usertrap: not from user mode");
    800027b0:	00005517          	auipc	a0,0x5
    800027b4:	b9050513          	addi	a0,a0,-1136 # 80007340 <etext+0x340>
    800027b8:	fddfd0ef          	jal	80000794 <panic>
    if(killed(p))
    800027bc:	8f9ff0ef          	jal	800020b4 <killed>
    800027c0:	e129                	bnez	a0,80002802 <usertrap+0xa0>
    p->trapframe->epc += 4;
    800027c2:	5a04b703          	ld	a4,1440(s1)
    800027c6:	6f1c                	ld	a5,24(a4)
    800027c8:	0791                	addi	a5,a5,4
    800027ca:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027cc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800027d0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027d4:	10079073          	csrw	sstatus,a5
    syscall();
    800027d8:	2c4000ef          	jal	80002a9c <syscall>
  if(killed(p))
    800027dc:	8526                	mv	a0,s1
    800027de:	8d7ff0ef          	jal	800020b4 <killed>
    800027e2:	c901                	beqz	a0,800027f2 <usertrap+0x90>
    800027e4:	4901                	li	s2,0
    exit(-1);
    800027e6:	557d                	li	a0,-1
    800027e8:	f96ff0ef          	jal	80001f7e <exit>
  if(which_dev == 2)
    800027ec:	4789                	li	a5,2
    800027ee:	04f90663          	beq	s2,a5,8000283a <usertrap+0xd8>
  usertrapret();
    800027f2:	e09ff0ef          	jal	800025fa <usertrapret>
}
    800027f6:	60e2                	ld	ra,24(sp)
    800027f8:	6442                	ld	s0,16(sp)
    800027fa:	64a2                	ld	s1,8(sp)
    800027fc:	6902                	ld	s2,0(sp)
    800027fe:	6105                	addi	sp,sp,32
    80002800:	8082                	ret
      exit(-1);
    80002802:	557d                	li	a0,-1
    80002804:	f7aff0ef          	jal	80001f7e <exit>
    80002808:	bf6d                	j	800027c2 <usertrap+0x60>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000280a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000280e:	5784a603          	lw	a2,1400(s1)
    80002812:	00005517          	auipc	a0,0x5
    80002816:	b4e50513          	addi	a0,a0,-1202 # 80007360 <etext+0x360>
    8000281a:	ca9fd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000281e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002822:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002826:	00005517          	auipc	a0,0x5
    8000282a:	b6a50513          	addi	a0,a0,-1174 # 80007390 <etext+0x390>
    8000282e:	c95fd0ef          	jal	800004c2 <printf>
    setkilled(p);
    80002832:	8526                	mv	a0,s1
    80002834:	85bff0ef          	jal	8000208e <setkilled>
    80002838:	b755                	j	800027dc <usertrap+0x7a>
    yield();
    8000283a:	e00ff0ef          	jal	80001e3a <yield>
    8000283e:	bf55                	j	800027f2 <usertrap+0x90>

0000000080002840 <kerneltrap>:
{
    80002840:	7179                	addi	sp,sp,-48
    80002842:	f406                	sd	ra,40(sp)
    80002844:	f022                	sd	s0,32(sp)
    80002846:	ec26                	sd	s1,24(sp)
    80002848:	e84a                	sd	s2,16(sp)
    8000284a:	e44e                	sd	s3,8(sp)
    8000284c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000284e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002852:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002856:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000285a:	1004f793          	andi	a5,s1,256
    8000285e:	c795                	beqz	a5,8000288a <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002860:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002864:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002866:	eb85                	bnez	a5,80002896 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002868:	e87ff0ef          	jal	800026ee <devintr>
    8000286c:	c91d                	beqz	a0,800028a2 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    8000286e:	4789                	li	a5,2
    80002870:	04f50a63          	beq	a0,a5,800028c4 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002874:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002878:	10049073          	csrw	sstatus,s1
}
    8000287c:	70a2                	ld	ra,40(sp)
    8000287e:	7402                	ld	s0,32(sp)
    80002880:	64e2                	ld	s1,24(sp)
    80002882:	6942                	ld	s2,16(sp)
    80002884:	69a2                	ld	s3,8(sp)
    80002886:	6145                	addi	sp,sp,48
    80002888:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000288a:	00005517          	auipc	a0,0x5
    8000288e:	b2e50513          	addi	a0,a0,-1234 # 800073b8 <etext+0x3b8>
    80002892:	f03fd0ef          	jal	80000794 <panic>
    panic("kerneltrap: interrupts enabled");
    80002896:	00005517          	auipc	a0,0x5
    8000289a:	b4a50513          	addi	a0,a0,-1206 # 800073e0 <etext+0x3e0>
    8000289e:	ef7fd0ef          	jal	80000794 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028a2:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800028a6:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800028aa:	85ce                	mv	a1,s3
    800028ac:	00005517          	auipc	a0,0x5
    800028b0:	b5450513          	addi	a0,a0,-1196 # 80007400 <etext+0x400>
    800028b4:	c0ffd0ef          	jal	800004c2 <printf>
    panic("kerneltrap");
    800028b8:	00005517          	auipc	a0,0x5
    800028bc:	b7050513          	addi	a0,a0,-1168 # 80007428 <etext+0x428>
    800028c0:	ed5fd0ef          	jal	80000794 <panic>
  if(which_dev == 2 && myproc() != 0)
    800028c4:	f9dfe0ef          	jal	80001860 <myproc>
    800028c8:	d555                	beqz	a0,80002874 <kerneltrap+0x34>
    yield();
    800028ca:	d70ff0ef          	jal	80001e3a <yield>
    800028ce:	b75d                	j	80002874 <kerneltrap+0x34>

00000000800028d0 <argraw>:
    return sys_receive_message(msg_type, received_msg);
}

static uint64
argraw(int n)
{
    800028d0:	1101                	addi	sp,sp,-32
    800028d2:	ec06                	sd	ra,24(sp)
    800028d4:	e822                	sd	s0,16(sp)
    800028d6:	e426                	sd	s1,8(sp)
    800028d8:	1000                	addi	s0,sp,32
    800028da:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800028dc:	f85fe0ef          	jal	80001860 <myproc>
  switch (n) {
    800028e0:	4795                	li	a5,5
    800028e2:	0497e763          	bltu	a5,s1,80002930 <argraw+0x60>
    800028e6:	048a                	slli	s1,s1,0x2
    800028e8:	00005717          	auipc	a4,0x5
    800028ec:	00870713          	addi	a4,a4,8 # 800078f0 <states.0+0x30>
    800028f0:	94ba                	add	s1,s1,a4
    800028f2:	409c                	lw	a5,0(s1)
    800028f4:	97ba                	add	a5,a5,a4
    800028f6:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800028f8:	5a053783          	ld	a5,1440(a0)
    800028fc:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800028fe:	60e2                	ld	ra,24(sp)
    80002900:	6442                	ld	s0,16(sp)
    80002902:	64a2                	ld	s1,8(sp)
    80002904:	6105                	addi	sp,sp,32
    80002906:	8082                	ret
    return p->trapframe->a1;
    80002908:	5a053783          	ld	a5,1440(a0)
    8000290c:	7fa8                	ld	a0,120(a5)
    8000290e:	bfc5                	j	800028fe <argraw+0x2e>
    return p->trapframe->a2;
    80002910:	5a053783          	ld	a5,1440(a0)
    80002914:	63c8                	ld	a0,128(a5)
    80002916:	b7e5                	j	800028fe <argraw+0x2e>
    return p->trapframe->a3;
    80002918:	5a053783          	ld	a5,1440(a0)
    8000291c:	67c8                	ld	a0,136(a5)
    8000291e:	b7c5                	j	800028fe <argraw+0x2e>
    return p->trapframe->a4;
    80002920:	5a053783          	ld	a5,1440(a0)
    80002924:	6bc8                	ld	a0,144(a5)
    80002926:	bfe1                	j	800028fe <argraw+0x2e>
    return p->trapframe->a5;
    80002928:	5a053783          	ld	a5,1440(a0)
    8000292c:	6fc8                	ld	a0,152(a5)
    8000292e:	bfc1                	j	800028fe <argraw+0x2e>
  panic("argraw");
    80002930:	00005517          	auipc	a0,0x5
    80002934:	b0850513          	addi	a0,a0,-1272 # 80007438 <etext+0x438>
    80002938:	e5dfd0ef          	jal	80000794 <panic>

000000008000293c <fetchaddr>:
{
    8000293c:	1101                	addi	sp,sp,-32
    8000293e:	ec06                	sd	ra,24(sp)
    80002940:	e822                	sd	s0,16(sp)
    80002942:	e426                	sd	s1,8(sp)
    80002944:	e04a                	sd	s2,0(sp)
    80002946:	1000                	addi	s0,sp,32
    80002948:	84aa                	mv	s1,a0
    8000294a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000294c:	f15fe0ef          	jal	80001860 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002950:	59053783          	ld	a5,1424(a0)
    80002954:	02f4f763          	bgeu	s1,a5,80002982 <fetchaddr+0x46>
    80002958:	00848713          	addi	a4,s1,8
    8000295c:	02e7e563          	bltu	a5,a4,80002986 <fetchaddr+0x4a>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002960:	46a1                	li	a3,8
    80002962:	8626                	mv	a2,s1
    80002964:	85ca                	mv	a1,s2
    80002966:	59853503          	ld	a0,1432(a0)
    8000296a:	cbffe0ef          	jal	80001628 <copyin>
    8000296e:	00a03533          	snez	a0,a0
    80002972:	40a00533          	neg	a0,a0
}
    80002976:	60e2                	ld	ra,24(sp)
    80002978:	6442                	ld	s0,16(sp)
    8000297a:	64a2                	ld	s1,8(sp)
    8000297c:	6902                	ld	s2,0(sp)
    8000297e:	6105                	addi	sp,sp,32
    80002980:	8082                	ret
    return -1;
    80002982:	557d                	li	a0,-1
    80002984:	bfcd                	j	80002976 <fetchaddr+0x3a>
    80002986:	557d                	li	a0,-1
    80002988:	b7fd                	j	80002976 <fetchaddr+0x3a>

000000008000298a <fetchstr>:
{
    8000298a:	7179                	addi	sp,sp,-48
    8000298c:	f406                	sd	ra,40(sp)
    8000298e:	f022                	sd	s0,32(sp)
    80002990:	ec26                	sd	s1,24(sp)
    80002992:	e84a                	sd	s2,16(sp)
    80002994:	e44e                	sd	s3,8(sp)
    80002996:	1800                	addi	s0,sp,48
    80002998:	892a                	mv	s2,a0
    8000299a:	84ae                	mv	s1,a1
    8000299c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000299e:	ec3fe0ef          	jal	80001860 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800029a2:	86ce                	mv	a3,s3
    800029a4:	864a                	mv	a2,s2
    800029a6:	85a6                	mv	a1,s1
    800029a8:	59853503          	ld	a0,1432(a0)
    800029ac:	d03fe0ef          	jal	800016ae <copyinstr>
    800029b0:	00054c63          	bltz	a0,800029c8 <fetchstr+0x3e>
  return strlen(buf);
    800029b4:	8526                	mv	a0,s1
    800029b6:	c82fe0ef          	jal	80000e38 <strlen>
}
    800029ba:	70a2                	ld	ra,40(sp)
    800029bc:	7402                	ld	s0,32(sp)
    800029be:	64e2                	ld	s1,24(sp)
    800029c0:	6942                	ld	s2,16(sp)
    800029c2:	69a2                	ld	s3,8(sp)
    800029c4:	6145                	addi	sp,sp,48
    800029c6:	8082                	ret
    return -1;
    800029c8:	557d                	li	a0,-1
    800029ca:	bfc5                	j	800029ba <fetchstr+0x30>

00000000800029cc <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800029cc:	1101                	addi	sp,sp,-32
    800029ce:	ec06                	sd	ra,24(sp)
    800029d0:	e822                	sd	s0,16(sp)
    800029d2:	e426                	sd	s1,8(sp)
    800029d4:	1000                	addi	s0,sp,32
    800029d6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800029d8:	ef9ff0ef          	jal	800028d0 <argraw>
    800029dc:	c088                	sw	a0,0(s1)
}
    800029de:	60e2                	ld	ra,24(sp)
    800029e0:	6442                	ld	s0,16(sp)
    800029e2:	64a2                	ld	s1,8(sp)
    800029e4:	6105                	addi	sp,sp,32
    800029e6:	8082                	ret

00000000800029e8 <sys_receive_message_wrapper>:
uint64 sys_receive_message_wrapper(void) {
    800029e8:	7135                	addi	sp,sp,-160
    800029ea:	ed06                	sd	ra,152(sp)
    800029ec:	e922                	sd	s0,144(sp)
    800029ee:	1100                	addi	s0,sp,160
    argint(0, &msg_type);
    800029f0:	fec40593          	addi	a1,s0,-20
    800029f4:	4501                	li	a0,0
    800029f6:	fd7ff0ef          	jal	800029cc <argint>
    return sys_receive_message(msg_type, received_msg);
    800029fa:	f6840593          	addi	a1,s0,-152
    800029fe:	fec42503          	lw	a0,-20(s0)
    80002a02:	202000ef          	jal	80002c04 <sys_receive_message>
}
    80002a06:	60ea                	ld	ra,152(sp)
    80002a08:	644a                	ld	s0,144(sp)
    80002a0a:	610d                	addi	sp,sp,160
    80002a0c:	8082                	ret

0000000080002a0e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002a0e:	1101                	addi	sp,sp,-32
    80002a10:	ec06                	sd	ra,24(sp)
    80002a12:	e822                	sd	s0,16(sp)
    80002a14:	e426                	sd	s1,8(sp)
    80002a16:	1000                	addi	s0,sp,32
    80002a18:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a1a:	eb7ff0ef          	jal	800028d0 <argraw>
    80002a1e:	e088                	sd	a0,0(s1)
}
    80002a20:	60e2                	ld	ra,24(sp)
    80002a22:	6442                	ld	s0,16(sp)
    80002a24:	64a2                	ld	s1,8(sp)
    80002a26:	6105                	addi	sp,sp,32
    80002a28:	8082                	ret

0000000080002a2a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002a2a:	7179                	addi	sp,sp,-48
    80002a2c:	f406                	sd	ra,40(sp)
    80002a2e:	f022                	sd	s0,32(sp)
    80002a30:	ec26                	sd	s1,24(sp)
    80002a32:	e84a                	sd	s2,16(sp)
    80002a34:	1800                	addi	s0,sp,48
    80002a36:	84ae                	mv	s1,a1
    80002a38:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002a3a:	fd840593          	addi	a1,s0,-40
    80002a3e:	fd1ff0ef          	jal	80002a0e <argaddr>
  return fetchstr(addr, buf, max);
    80002a42:	864a                	mv	a2,s2
    80002a44:	85a6                	mv	a1,s1
    80002a46:	fd843503          	ld	a0,-40(s0)
    80002a4a:	f41ff0ef          	jal	8000298a <fetchstr>
}
    80002a4e:	70a2                	ld	ra,40(sp)
    80002a50:	7402                	ld	s0,32(sp)
    80002a52:	64e2                	ld	s1,24(sp)
    80002a54:	6942                	ld	s2,16(sp)
    80002a56:	6145                	addi	sp,sp,48
    80002a58:	8082                	ret

0000000080002a5a <sys_send_message_wrapper>:
uint64 sys_send_message_wrapper(void) {
    80002a5a:	7135                	addi	sp,sp,-160
    80002a5c:	ed06                	sd	ra,152(sp)
    80002a5e:	e922                	sd	s0,144(sp)
    80002a60:	1100                	addi	s0,sp,160
    argint(0, &pid);
    80002a62:	fec40593          	addi	a1,s0,-20
    80002a66:	4501                	li	a0,0
    80002a68:	f65ff0ef          	jal	800029cc <argint>
    argint(1, &msg_type);
    80002a6c:	fe840593          	addi	a1,s0,-24
    80002a70:	4505                	li	a0,1
    80002a72:	f5bff0ef          	jal	800029cc <argint>
    argstr(2, msg, sizeof(msg));
    80002a76:	08000613          	li	a2,128
    80002a7a:	f6840593          	addi	a1,s0,-152
    80002a7e:	4509                	li	a0,2
    80002a80:	fabff0ef          	jal	80002a2a <argstr>
    return sys_send_message(pid, msg_type, msg);
    80002a84:	f6840613          	addi	a2,s0,-152
    80002a88:	fe842583          	lw	a1,-24(s0)
    80002a8c:	fec42503          	lw	a0,-20(s0)
    80002a90:	0d8000ef          	jal	80002b68 <sys_send_message>
}
    80002a94:	60ea                	ld	ra,152(sp)
    80002a96:	644a                	ld	s0,144(sp)
    80002a98:	610d                	addi	sp,sp,160
    80002a9a:	8082                	ret

0000000080002a9c <syscall>:
[SYS_sys_send_message]     sys_send_message_wrapper,
[SYS_sys_receive_message]  sys_receive_message_wrapper,
};

void syscall(void)
{
    80002a9c:	7171                	addi	sp,sp,-176
    80002a9e:	f506                	sd	ra,168(sp)
    80002aa0:	f122                	sd	s0,160(sp)
    80002aa2:	ed26                	sd	s1,152(sp)
    80002aa4:	e94a                	sd	s2,144(sp)
    80002aa6:	1900                	addi	s0,sp,176
  int num;
  struct proc *p = myproc();
    80002aa8:	db9fe0ef          	jal	80001860 <myproc>
    80002aac:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002aae:	5a053903          	ld	s2,1440(a0)
    80002ab2:	0a893783          	ld	a5,168(s2)
    80002ab6:	0007869b          	sext.w	a3,a5

  // Check if the syscall number is valid
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002aba:	37fd                	addiw	a5,a5,-1
    80002abc:	4759                	li	a4,22
    80002abe:	08f76163          	bltu	a4,a5,80002b40 <syscall+0xa4>
    80002ac2:	00369713          	slli	a4,a3,0x3
    80002ac6:	00005797          	auipc	a5,0x5
    80002aca:	e4278793          	addi	a5,a5,-446 # 80007908 <syscalls>
    80002ace:	97ba                	add	a5,a5,a4
    80002ad0:	639c                	ld	a5,0(a5)
    80002ad2:	c7bd                	beqz	a5,80002b40 <syscall+0xa4>
    // Handle sys_send_message
    if (num == SYS_sys_send_message) {
    80002ad4:	4759                	li	a4,22
    80002ad6:	00e68963          	beq	a3,a4,80002ae8 <syscall+0x4c>

      // Call sys_send_message and store the result
      p->trapframe->a0 = sys_send_message(pid, msg_type, msg);
    } 
    // Handle sys_receive_message
    else if (num == SYS_sys_receive_message) {
    80002ada:	475d                	li	a4,23
    80002adc:	04e68363          	beq	a3,a4,80002b22 <syscall+0x86>
      // Call sys_receive_message and store the result
      p->trapframe->a0 = sys_receive_message(msg_type, received_msg);
    } 
    // Handle other syscalls
    else {
      p->trapframe->a0 = syscalls[num]();
    80002ae0:	9782                	jalr	a5
    80002ae2:	06a93823          	sd	a0,112(s2)
    80002ae6:	a89d                	j	80002b5c <syscall+0xc0>
      argint(0, &pid);          // Process ID
    80002ae8:	f5840593          	addi	a1,s0,-168
    80002aec:	4501                	li	a0,0
    80002aee:	edfff0ef          	jal	800029cc <argint>
      argint(1, &msg_type);     // Message type
    80002af2:	f5c40593          	addi	a1,s0,-164
    80002af6:	4505                	li	a0,1
    80002af8:	ed5ff0ef          	jal	800029cc <argint>
      argstr(2, msg, 128);      // Message content
    80002afc:	08000613          	li	a2,128
    80002b00:	f6040593          	addi	a1,s0,-160
    80002b04:	4509                	li	a0,2
    80002b06:	f25ff0ef          	jal	80002a2a <argstr>
      p->trapframe->a0 = sys_send_message(pid, msg_type, msg);
    80002b0a:	5a04b483          	ld	s1,1440(s1)
    80002b0e:	f6040613          	addi	a2,s0,-160
    80002b12:	f5c42583          	lw	a1,-164(s0)
    80002b16:	f5842503          	lw	a0,-168(s0)
    80002b1a:	04e000ef          	jal	80002b68 <sys_send_message>
    80002b1e:	f8a8                	sd	a0,112(s1)
    80002b20:	a835                	j	80002b5c <syscall+0xc0>
      argint(0, &msg_type);     // Message type
    80002b22:	f5c40593          	addi	a1,s0,-164
    80002b26:	4501                	li	a0,0
    80002b28:	ea5ff0ef          	jal	800029cc <argint>
      p->trapframe->a0 = sys_receive_message(msg_type, received_msg);
    80002b2c:	5a04b483          	ld	s1,1440(s1)
    80002b30:	f6040593          	addi	a1,s0,-160
    80002b34:	f5c42503          	lw	a0,-164(s0)
    80002b38:	0cc000ef          	jal	80002c04 <sys_receive_message>
    80002b3c:	f8a8                	sd	a0,112(s1)
    80002b3e:	a839                	j	80002b5c <syscall+0xc0>
    }
  } else {
    // Handle invalid system call number
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002b40:	6a048613          	addi	a2,s1,1696
    80002b44:	5784a583          	lw	a1,1400(s1)
    80002b48:	00005517          	auipc	a0,0x5
    80002b4c:	8f850513          	addi	a0,a0,-1800 # 80007440 <etext+0x440>
    80002b50:	973fd0ef          	jal	800004c2 <printf>
    p->trapframe->a0 = -1;
    80002b54:	5a04b783          	ld	a5,1440(s1)
    80002b58:	577d                	li	a4,-1
    80002b5a:	fbb8                	sd	a4,112(a5)
  }
}
    80002b5c:	70aa                	ld	ra,168(sp)
    80002b5e:	740a                	ld	s0,160(sp)
    80002b60:	64ea                	ld	s1,152(sp)
    80002b62:	694a                	ld	s2,144(sp)
    80002b64:	614d                	addi	sp,sp,176
    80002b66:	8082                	ret

0000000080002b68 <sys_send_message>:
extern struct proc proc[NPROC];  // Assuming NPROC is the size of the process array
extern struct spinlock ptable_lock;


// Send a message to the queue of a specific process
uint64 sys_send_message(int pid, int msg_type, char *message) {
    80002b68:	7171                	addi	sp,sp,-176
    80002b6a:	f506                	sd	ra,168(sp)
    80002b6c:	f122                	sd	s0,160(sp)
    80002b6e:	ed26                	sd	s1,152(sp)
    80002b70:	e94a                	sd	s2,144(sp)
    80002b72:	1900                	addi	s0,sp,176
    80002b74:	892a                	mv	s2,a0
    80002b76:	87b2                	mv	a5,a2
    struct proc *receiver = 0;
    struct msg msg;

    msg.msg_type = msg_type;
    80002b78:	f4b42c23          	sw	a1,-168(s0)
    safestrcpy(msg.content, message, MSG_SIZE);
    80002b7c:	08000613          	li	a2,128
    80002b80:	85be                	mv	a1,a5
    80002b82:	f5c40513          	addi	a0,s0,-164
    80002b86:	a80fe0ef          	jal	80000e06 <safestrcpy>

    acquire(&ptable_lock);
    80002b8a:	00010517          	auipc	a0,0x10
    80002b8e:	46650513          	addi	a0,a0,1126 # 80012ff0 <ptable_lock>
    80002b92:	862fe0ef          	jal	80000bf4 <acquire>
    for (int i = 0; i < NPROC; i++) {
    80002b96:	00011797          	auipc	a5,0x11
    80002b9a:	9ea78793          	addi	a5,a5,-1558 # 80013580 <proc+0x578>
    80002b9e:	4481                	li	s1,0
    80002ba0:	04000693          	li	a3,64
        if (proc[i].pid == pid) {
    80002ba4:	4398                	lw	a4,0(a5)
    80002ba6:	03270663          	beq	a4,s2,80002bd2 <sys_send_message+0x6a>
    for (int i = 0; i < NPROC; i++) {
    80002baa:	2485                	addiw	s1,s1,1
    80002bac:	6b078793          	addi	a5,a5,1712
    80002bb0:	fed49ae3          	bne	s1,a3,80002ba4 <sys_send_message+0x3c>
            receiver = &proc[i];
            break;
        }
    }
    release(&ptable_lock);
    80002bb4:	00010517          	auipc	a0,0x10
    80002bb8:	43c50513          	addi	a0,a0,1084 # 80012ff0 <ptable_lock>
    80002bbc:	8d0fe0ef          	jal	80000c8c <release>

    if (receiver == 0) {
        printf("sys_send_message: Receiver PID %d not found\n", pid);
    80002bc0:	85ca                	mv	a1,s2
    80002bc2:	00005517          	auipc	a0,0x5
    80002bc6:	89e50513          	addi	a0,a0,-1890 # 80007460 <etext+0x460>
    80002bca:	8f9fd0ef          	jal	800004c2 <printf>
        return -1;
    80002bce:	557d                	li	a0,-1
    80002bd0:	a025                	j	80002bf8 <sys_send_message+0x90>
    release(&ptable_lock);
    80002bd2:	00010517          	auipc	a0,0x10
    80002bd6:	41e50513          	addi	a0,a0,1054 # 80012ff0 <ptable_lock>
    80002bda:	8b2fe0ef          	jal	80000c8c <release>
    }

    //printf("sys_send_message: Sending to PID %d, Type %d, Message: %s\n",pid, msg_type, message);

    return send_message(&receiver->msg_queue, &msg);
    80002bde:	6b000793          	li	a5,1712
    80002be2:	02f484b3          	mul	s1,s1,a5
    80002be6:	f5840593          	addi	a1,s0,-168
    80002bea:	00010517          	auipc	a0,0x10
    80002bee:	43650513          	addi	a0,a0,1078 # 80013020 <proc+0x18>
    80002bf2:	9526                	add	a0,a0,s1
    80002bf4:	865ff0ef          	jal	80002458 <send_message>
}
    80002bf8:	70aa                	ld	ra,168(sp)
    80002bfa:	740a                	ld	s0,160(sp)
    80002bfc:	64ea                	ld	s1,152(sp)
    80002bfe:	694a                	ld	s2,144(sp)
    80002c00:	614d                	addi	sp,sp,176
    80002c02:	8082                	ret

0000000080002c04 <sys_receive_message>:

//     // If no message is available
//     printf("sys_receive_message: No message available in the queue\n");
//     return -1;  // Failure: no message available
// }
uint64 sys_receive_message(int msg_type, char *received_msg) {
    80002c04:	7131                	addi	sp,sp,-192
    80002c06:	fd06                	sd	ra,184(sp)
    80002c08:	f922                	sd	s0,176(sp)
    80002c0a:	f526                	sd	s1,168(sp)
    80002c0c:	f14a                	sd	s2,160(sp)
    80002c0e:	0180                	addi	s0,sp,192
    80002c10:	892a                	mv	s2,a0
    struct proc *p = myproc();  // Get the current process
    80002c12:	c4ffe0ef          	jal	80001860 <myproc>
    80002c16:	84aa                	mv	s1,a0
    struct msg msg;
    uint64 addr;  // To store the user-space address of the received message

    // Fetch the user-space address argument (to store received message)
    argaddr(1, &addr);  // This is the address where the message will be copied
    80002c18:	f4040593          	addi	a1,s0,-192
    80002c1c:	4505                	li	a0,1
    80002c1e:	df1ff0ef          	jal	80002a0e <argaddr>

    // Debug: Print the user-space address
    //printf("sys_receive_message: User address = 0x%lx\n", addr);

    // Ensure the address is valid
    if (addr == 0) {
    80002c22:	f4043783          	ld	a5,-192(s0)
    80002c26:	c3b9                	beqz	a5,80002c6c <sys_receive_message+0x68>
    80002c28:	ed4e                	sd	s3,152(sp)
        printf("sys_receive_message: Invalid address or out of range\n");
        return -1;  // Return error if the address is NULL or out of range
    }

    // Try to receive a message from the message queue
    if (receive_message(&p->msg_queue, &msg) == 0) {
    80002c2a:	01848993          	addi	s3,s1,24
    80002c2e:	f4840593          	addi	a1,s0,-184
    80002c32:	854e                	mv	a0,s3
    80002c34:	8abff0ef          	jal	800024de <receive_message>
    80002c38:	e935                	bnez	a0,80002cac <sys_receive_message+0xa8>
        // Check if the message type matches
        if (msg.msg_type == msg_type) {
    80002c3a:	f4842603          	lw	a2,-184(s0)
    80002c3e:	05261863          	bne	a2,s2,80002c8e <sys_receive_message+0x8a>
            // Debug: Print message details for verification
            //printf("sys_receive_message: Received Type %d, Message: %s\n", msg.msg_type, msg.content);

            // Now safely copy the message content to user space
            if (copyout(p->pagetable, addr, (char *)msg.content, MSG_SIZE) < 0) {
    80002c42:	08000693          	li	a3,128
    80002c46:	f4c40613          	addi	a2,s0,-180
    80002c4a:	f4043583          	ld	a1,-192(s0)
    80002c4e:	5984b503          	ld	a0,1432(s1)
    80002c52:	901fe0ef          	jal	80001552 <copyout>
    80002c56:	87aa                	mv	a5,a0
                printf("sys_receive_message: copyout failed\n");
                return -1;  // Failure: copyout failed
            }

            // Return success
            return 0;
    80002c58:	4501                	li	a0,0
            if (copyout(p->pagetable, addr, (char *)msg.content, MSG_SIZE) < 0) {
    80002c5a:	0207c163          	bltz	a5,80002c7c <sys_receive_message+0x78>
    80002c5e:	69ea                	ld	s3,152(sp)
    }

    // If no message is available in the queue
    printf("sys_receive_message: No message available in the queue\n");
    return -1;  // Failure: no message available
}
    80002c60:	70ea                	ld	ra,184(sp)
    80002c62:	744a                	ld	s0,176(sp)
    80002c64:	74aa                	ld	s1,168(sp)
    80002c66:	790a                	ld	s2,160(sp)
    80002c68:	6129                	addi	sp,sp,192
    80002c6a:	8082                	ret
        printf("sys_receive_message: Invalid address or out of range\n");
    80002c6c:	00005517          	auipc	a0,0x5
    80002c70:	82450513          	addi	a0,a0,-2012 # 80007490 <etext+0x490>
    80002c74:	84ffd0ef          	jal	800004c2 <printf>
        return -1;  // Return error if the address is NULL or out of range
    80002c78:	557d                	li	a0,-1
    80002c7a:	b7dd                	j	80002c60 <sys_receive_message+0x5c>
                printf("sys_receive_message: copyout failed\n");
    80002c7c:	00005517          	auipc	a0,0x5
    80002c80:	84c50513          	addi	a0,a0,-1972 # 800074c8 <etext+0x4c8>
    80002c84:	83ffd0ef          	jal	800004c2 <printf>
                return -1;  // Failure: copyout failed
    80002c88:	557d                	li	a0,-1
    80002c8a:	69ea                	ld	s3,152(sp)
    80002c8c:	bfd1                	j	80002c60 <sys_receive_message+0x5c>
            printf("sys_receive_message: Type mismatch. Expected %d, got %d\n", msg_type, msg.msg_type);
    80002c8e:	85ca                	mv	a1,s2
    80002c90:	00005517          	auipc	a0,0x5
    80002c94:	86050513          	addi	a0,a0,-1952 # 800074f0 <etext+0x4f0>
    80002c98:	82bfd0ef          	jal	800004c2 <printf>
            send_message(&p->msg_queue, &msg);  // Return the message to the queue
    80002c9c:	f4840593          	addi	a1,s0,-184
    80002ca0:	854e                	mv	a0,s3
    80002ca2:	fb6ff0ef          	jal	80002458 <send_message>
            return -1;  // Failure: type mismatch
    80002ca6:	557d                	li	a0,-1
    80002ca8:	69ea                	ld	s3,152(sp)
    80002caa:	bf5d                	j	80002c60 <sys_receive_message+0x5c>
    printf("sys_receive_message: No message available in the queue\n");
    80002cac:	00005517          	auipc	a0,0x5
    80002cb0:	88450513          	addi	a0,a0,-1916 # 80007530 <etext+0x530>
    80002cb4:	80ffd0ef          	jal	800004c2 <printf>
    return -1;  // Failure: no message available
    80002cb8:	557d                	li	a0,-1
    80002cba:	69ea                	ld	s3,152(sp)
    80002cbc:	b755                	j	80002c60 <sys_receive_message+0x5c>

0000000080002cbe <sys_exit>:



uint64
sys_exit(void)
{
    80002cbe:	1101                	addi	sp,sp,-32
    80002cc0:	ec06                	sd	ra,24(sp)
    80002cc2:	e822                	sd	s0,16(sp)
    80002cc4:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002cc6:	fec40593          	addi	a1,s0,-20
    80002cca:	4501                	li	a0,0
    80002ccc:	d01ff0ef          	jal	800029cc <argint>
  exit(n);
    80002cd0:	fec42503          	lw	a0,-20(s0)
    80002cd4:	aaaff0ef          	jal	80001f7e <exit>
  return 0;  // not reached
}
    80002cd8:	4501                	li	a0,0
    80002cda:	60e2                	ld	ra,24(sp)
    80002cdc:	6442                	ld	s0,16(sp)
    80002cde:	6105                	addi	sp,sp,32
    80002ce0:	8082                	ret

0000000080002ce2 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002ce2:	1141                	addi	sp,sp,-16
    80002ce4:	e406                	sd	ra,8(sp)
    80002ce6:	e022                	sd	s0,0(sp)
    80002ce8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002cea:	b77fe0ef          	jal	80001860 <myproc>
}
    80002cee:	57852503          	lw	a0,1400(a0)
    80002cf2:	60a2                	ld	ra,8(sp)
    80002cf4:	6402                	ld	s0,0(sp)
    80002cf6:	0141                	addi	sp,sp,16
    80002cf8:	8082                	ret

0000000080002cfa <sys_fork>:

uint64
sys_fork(void)
{
    80002cfa:	1141                	addi	sp,sp,-16
    80002cfc:	e406                	sd	ra,8(sp)
    80002cfe:	e022                	sd	s0,0(sp)
    80002d00:	0800                	addi	s0,sp,16
  return fork();
    80002d02:	eb7fe0ef          	jal	80001bb8 <fork>
}
    80002d06:	60a2                	ld	ra,8(sp)
    80002d08:	6402                	ld	s0,0(sp)
    80002d0a:	0141                	addi	sp,sp,16
    80002d0c:	8082                	ret

0000000080002d0e <sys_wait>:

uint64
sys_wait(void)
{
    80002d0e:	1101                	addi	sp,sp,-32
    80002d10:	ec06                	sd	ra,24(sp)
    80002d12:	e822                	sd	s0,16(sp)
    80002d14:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002d16:	fe840593          	addi	a1,s0,-24
    80002d1a:	4501                	li	a0,0
    80002d1c:	cf3ff0ef          	jal	80002a0e <argaddr>
  return wait(p);
    80002d20:	fe843503          	ld	a0,-24(s0)
    80002d24:	bbaff0ef          	jal	800020de <wait>
}
    80002d28:	60e2                	ld	ra,24(sp)
    80002d2a:	6442                	ld	s0,16(sp)
    80002d2c:	6105                	addi	sp,sp,32
    80002d2e:	8082                	ret

0000000080002d30 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002d30:	7179                	addi	sp,sp,-48
    80002d32:	f406                	sd	ra,40(sp)
    80002d34:	f022                	sd	s0,32(sp)
    80002d36:	ec26                	sd	s1,24(sp)
    80002d38:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002d3a:	fdc40593          	addi	a1,s0,-36
    80002d3e:	4501                	li	a0,0
    80002d40:	c8dff0ef          	jal	800029cc <argint>
  addr = myproc()->sz;
    80002d44:	b1dfe0ef          	jal	80001860 <myproc>
    80002d48:	59053483          	ld	s1,1424(a0)
  if(growproc(n) < 0)
    80002d4c:	fdc42503          	lw	a0,-36(s0)
    80002d50:	e11fe0ef          	jal	80001b60 <growproc>
    80002d54:	00054863          	bltz	a0,80002d64 <sys_sbrk+0x34>
    return -1;
  return addr;
}
    80002d58:	8526                	mv	a0,s1
    80002d5a:	70a2                	ld	ra,40(sp)
    80002d5c:	7402                	ld	s0,32(sp)
    80002d5e:	64e2                	ld	s1,24(sp)
    80002d60:	6145                	addi	sp,sp,48
    80002d62:	8082                	ret
    return -1;
    80002d64:	54fd                	li	s1,-1
    80002d66:	bfcd                	j	80002d58 <sys_sbrk+0x28>

0000000080002d68 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002d68:	7139                	addi	sp,sp,-64
    80002d6a:	fc06                	sd	ra,56(sp)
    80002d6c:	f822                	sd	s0,48(sp)
    80002d6e:	f04a                	sd	s2,32(sp)
    80002d70:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002d72:	fcc40593          	addi	a1,s0,-52
    80002d76:	4501                	li	a0,0
    80002d78:	c55ff0ef          	jal	800029cc <argint>
  if(n < 0)
    80002d7c:	fcc42783          	lw	a5,-52(s0)
    80002d80:	0607c763          	bltz	a5,80002dee <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002d84:	0002b517          	auipc	a0,0x2b
    80002d88:	e8450513          	addi	a0,a0,-380 # 8002dc08 <tickslock>
    80002d8c:	e69fd0ef          	jal	80000bf4 <acquire>
  ticks0 = ticks;
    80002d90:	00007917          	auipc	s2,0x7
    80002d94:	7a092903          	lw	s2,1952(s2) # 8000a530 <ticks>
  while(ticks - ticks0 < n){
    80002d98:	fcc42783          	lw	a5,-52(s0)
    80002d9c:	cf8d                	beqz	a5,80002dd6 <sys_sleep+0x6e>
    80002d9e:	f426                	sd	s1,40(sp)
    80002da0:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002da2:	0002b997          	auipc	s3,0x2b
    80002da6:	e6698993          	addi	s3,s3,-410 # 8002dc08 <tickslock>
    80002daa:	00007497          	auipc	s1,0x7
    80002dae:	78648493          	addi	s1,s1,1926 # 8000a530 <ticks>
    if(killed(myproc())){
    80002db2:	aaffe0ef          	jal	80001860 <myproc>
    80002db6:	afeff0ef          	jal	800020b4 <killed>
    80002dba:	ed0d                	bnez	a0,80002df4 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002dbc:	85ce                	mv	a1,s3
    80002dbe:	8526                	mv	a0,s1
    80002dc0:	8a8ff0ef          	jal	80001e68 <sleep>
  while(ticks - ticks0 < n){
    80002dc4:	409c                	lw	a5,0(s1)
    80002dc6:	412787bb          	subw	a5,a5,s2
    80002dca:	fcc42703          	lw	a4,-52(s0)
    80002dce:	fee7e2e3          	bltu	a5,a4,80002db2 <sys_sleep+0x4a>
    80002dd2:	74a2                	ld	s1,40(sp)
    80002dd4:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002dd6:	0002b517          	auipc	a0,0x2b
    80002dda:	e3250513          	addi	a0,a0,-462 # 8002dc08 <tickslock>
    80002dde:	eaffd0ef          	jal	80000c8c <release>
  return 0;
    80002de2:	4501                	li	a0,0
}
    80002de4:	70e2                	ld	ra,56(sp)
    80002de6:	7442                	ld	s0,48(sp)
    80002de8:	7902                	ld	s2,32(sp)
    80002dea:	6121                	addi	sp,sp,64
    80002dec:	8082                	ret
    n = 0;
    80002dee:	fc042623          	sw	zero,-52(s0)
    80002df2:	bf49                	j	80002d84 <sys_sleep+0x1c>
      release(&tickslock);
    80002df4:	0002b517          	auipc	a0,0x2b
    80002df8:	e1450513          	addi	a0,a0,-492 # 8002dc08 <tickslock>
    80002dfc:	e91fd0ef          	jal	80000c8c <release>
      return -1;
    80002e00:	557d                	li	a0,-1
    80002e02:	74a2                	ld	s1,40(sp)
    80002e04:	69e2                	ld	s3,24(sp)
    80002e06:	bff9                	j	80002de4 <sys_sleep+0x7c>

0000000080002e08 <sys_kill>:

uint64
sys_kill(void)
{
    80002e08:	1101                	addi	sp,sp,-32
    80002e0a:	ec06                	sd	ra,24(sp)
    80002e0c:	e822                	sd	s0,16(sp)
    80002e0e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002e10:	fec40593          	addi	a1,s0,-20
    80002e14:	4501                	li	a0,0
    80002e16:	bb7ff0ef          	jal	800029cc <argint>
  return kill(pid);
    80002e1a:	fec42503          	lw	a0,-20(s0)
    80002e1e:	a02ff0ef          	jal	80002020 <kill>
}
    80002e22:	60e2                	ld	ra,24(sp)
    80002e24:	6442                	ld	s0,16(sp)
    80002e26:	6105                	addi	sp,sp,32
    80002e28:	8082                	ret

0000000080002e2a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002e2a:	1101                	addi	sp,sp,-32
    80002e2c:	ec06                	sd	ra,24(sp)
    80002e2e:	e822                	sd	s0,16(sp)
    80002e30:	e426                	sd	s1,8(sp)
    80002e32:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002e34:	0002b517          	auipc	a0,0x2b
    80002e38:	dd450513          	addi	a0,a0,-556 # 8002dc08 <tickslock>
    80002e3c:	db9fd0ef          	jal	80000bf4 <acquire>
  xticks = ticks;
    80002e40:	00007497          	auipc	s1,0x7
    80002e44:	6f04a483          	lw	s1,1776(s1) # 8000a530 <ticks>
  release(&tickslock);
    80002e48:	0002b517          	auipc	a0,0x2b
    80002e4c:	dc050513          	addi	a0,a0,-576 # 8002dc08 <tickslock>
    80002e50:	e3dfd0ef          	jal	80000c8c <release>
  return xticks;
}
    80002e54:	02049513          	slli	a0,s1,0x20
    80002e58:	9101                	srli	a0,a0,0x20
    80002e5a:	60e2                	ld	ra,24(sp)
    80002e5c:	6442                	ld	s0,16(sp)
    80002e5e:	64a2                	ld	s1,8(sp)
    80002e60:	6105                	addi	sp,sp,32
    80002e62:	8082                	ret

0000000080002e64 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002e64:	7179                	addi	sp,sp,-48
    80002e66:	f406                	sd	ra,40(sp)
    80002e68:	f022                	sd	s0,32(sp)
    80002e6a:	ec26                	sd	s1,24(sp)
    80002e6c:	e84a                	sd	s2,16(sp)
    80002e6e:	e44e                	sd	s3,8(sp)
    80002e70:	e052                	sd	s4,0(sp)
    80002e72:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002e74:	00004597          	auipc	a1,0x4
    80002e78:	6f458593          	addi	a1,a1,1780 # 80007568 <etext+0x568>
    80002e7c:	0002b517          	auipc	a0,0x2b
    80002e80:	da450513          	addi	a0,a0,-604 # 8002dc20 <bcache>
    80002e84:	cf1fd0ef          	jal	80000b74 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002e88:	00033797          	auipc	a5,0x33
    80002e8c:	d9878793          	addi	a5,a5,-616 # 80035c20 <bcache+0x8000>
    80002e90:	00033717          	auipc	a4,0x33
    80002e94:	ff870713          	addi	a4,a4,-8 # 80035e88 <bcache+0x8268>
    80002e98:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002e9c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ea0:	0002b497          	auipc	s1,0x2b
    80002ea4:	d9848493          	addi	s1,s1,-616 # 8002dc38 <bcache+0x18>
    b->next = bcache.head.next;
    80002ea8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002eaa:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002eac:	00004a17          	auipc	s4,0x4
    80002eb0:	6c4a0a13          	addi	s4,s4,1732 # 80007570 <etext+0x570>
    b->next = bcache.head.next;
    80002eb4:	2b893783          	ld	a5,696(s2)
    80002eb8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002eba:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002ebe:	85d2                	mv	a1,s4
    80002ec0:	01048513          	addi	a0,s1,16
    80002ec4:	248010ef          	jal	8000410c <initsleeplock>
    bcache.head.next->prev = b;
    80002ec8:	2b893783          	ld	a5,696(s2)
    80002ecc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002ece:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ed2:	45848493          	addi	s1,s1,1112
    80002ed6:	fd349fe3          	bne	s1,s3,80002eb4 <binit+0x50>
  }
}
    80002eda:	70a2                	ld	ra,40(sp)
    80002edc:	7402                	ld	s0,32(sp)
    80002ede:	64e2                	ld	s1,24(sp)
    80002ee0:	6942                	ld	s2,16(sp)
    80002ee2:	69a2                	ld	s3,8(sp)
    80002ee4:	6a02                	ld	s4,0(sp)
    80002ee6:	6145                	addi	sp,sp,48
    80002ee8:	8082                	ret

0000000080002eea <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002eea:	7179                	addi	sp,sp,-48
    80002eec:	f406                	sd	ra,40(sp)
    80002eee:	f022                	sd	s0,32(sp)
    80002ef0:	ec26                	sd	s1,24(sp)
    80002ef2:	e84a                	sd	s2,16(sp)
    80002ef4:	e44e                	sd	s3,8(sp)
    80002ef6:	1800                	addi	s0,sp,48
    80002ef8:	892a                	mv	s2,a0
    80002efa:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002efc:	0002b517          	auipc	a0,0x2b
    80002f00:	d2450513          	addi	a0,a0,-732 # 8002dc20 <bcache>
    80002f04:	cf1fd0ef          	jal	80000bf4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002f08:	00033497          	auipc	s1,0x33
    80002f0c:	fd04b483          	ld	s1,-48(s1) # 80035ed8 <bcache+0x82b8>
    80002f10:	00033797          	auipc	a5,0x33
    80002f14:	f7878793          	addi	a5,a5,-136 # 80035e88 <bcache+0x8268>
    80002f18:	02f48b63          	beq	s1,a5,80002f4e <bread+0x64>
    80002f1c:	873e                	mv	a4,a5
    80002f1e:	a021                	j	80002f26 <bread+0x3c>
    80002f20:	68a4                	ld	s1,80(s1)
    80002f22:	02e48663          	beq	s1,a4,80002f4e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002f26:	449c                	lw	a5,8(s1)
    80002f28:	ff279ce3          	bne	a5,s2,80002f20 <bread+0x36>
    80002f2c:	44dc                	lw	a5,12(s1)
    80002f2e:	ff3799e3          	bne	a5,s3,80002f20 <bread+0x36>
      b->refcnt++;
    80002f32:	40bc                	lw	a5,64(s1)
    80002f34:	2785                	addiw	a5,a5,1
    80002f36:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f38:	0002b517          	auipc	a0,0x2b
    80002f3c:	ce850513          	addi	a0,a0,-792 # 8002dc20 <bcache>
    80002f40:	d4dfd0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002f44:	01048513          	addi	a0,s1,16
    80002f48:	1fa010ef          	jal	80004142 <acquiresleep>
      return b;
    80002f4c:	a889                	j	80002f9e <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f4e:	00033497          	auipc	s1,0x33
    80002f52:	f824b483          	ld	s1,-126(s1) # 80035ed0 <bcache+0x82b0>
    80002f56:	00033797          	auipc	a5,0x33
    80002f5a:	f3278793          	addi	a5,a5,-206 # 80035e88 <bcache+0x8268>
    80002f5e:	00f48863          	beq	s1,a5,80002f6e <bread+0x84>
    80002f62:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002f64:	40bc                	lw	a5,64(s1)
    80002f66:	cb91                	beqz	a5,80002f7a <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f68:	64a4                	ld	s1,72(s1)
    80002f6a:	fee49de3          	bne	s1,a4,80002f64 <bread+0x7a>
  panic("bget: no buffers");
    80002f6e:	00004517          	auipc	a0,0x4
    80002f72:	60a50513          	addi	a0,a0,1546 # 80007578 <etext+0x578>
    80002f76:	81ffd0ef          	jal	80000794 <panic>
      b->dev = dev;
    80002f7a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002f7e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002f82:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002f86:	4785                	li	a5,1
    80002f88:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f8a:	0002b517          	auipc	a0,0x2b
    80002f8e:	c9650513          	addi	a0,a0,-874 # 8002dc20 <bcache>
    80002f92:	cfbfd0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002f96:	01048513          	addi	a0,s1,16
    80002f9a:	1a8010ef          	jal	80004142 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002f9e:	409c                	lw	a5,0(s1)
    80002fa0:	cb89                	beqz	a5,80002fb2 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002fa2:	8526                	mv	a0,s1
    80002fa4:	70a2                	ld	ra,40(sp)
    80002fa6:	7402                	ld	s0,32(sp)
    80002fa8:	64e2                	ld	s1,24(sp)
    80002faa:	6942                	ld	s2,16(sp)
    80002fac:	69a2                	ld	s3,8(sp)
    80002fae:	6145                	addi	sp,sp,48
    80002fb0:	8082                	ret
    virtio_disk_rw(b, 0);
    80002fb2:	4581                	li	a1,0
    80002fb4:	8526                	mv	a0,s1
    80002fb6:	1fb020ef          	jal	800059b0 <virtio_disk_rw>
    b->valid = 1;
    80002fba:	4785                	li	a5,1
    80002fbc:	c09c                	sw	a5,0(s1)
  return b;
    80002fbe:	b7d5                	j	80002fa2 <bread+0xb8>

0000000080002fc0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002fc0:	1101                	addi	sp,sp,-32
    80002fc2:	ec06                	sd	ra,24(sp)
    80002fc4:	e822                	sd	s0,16(sp)
    80002fc6:	e426                	sd	s1,8(sp)
    80002fc8:	1000                	addi	s0,sp,32
    80002fca:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002fcc:	0541                	addi	a0,a0,16
    80002fce:	1f4010ef          	jal	800041c2 <holdingsleep>
    80002fd2:	c911                	beqz	a0,80002fe6 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002fd4:	4585                	li	a1,1
    80002fd6:	8526                	mv	a0,s1
    80002fd8:	1d9020ef          	jal	800059b0 <virtio_disk_rw>
}
    80002fdc:	60e2                	ld	ra,24(sp)
    80002fde:	6442                	ld	s0,16(sp)
    80002fe0:	64a2                	ld	s1,8(sp)
    80002fe2:	6105                	addi	sp,sp,32
    80002fe4:	8082                	ret
    panic("bwrite");
    80002fe6:	00004517          	auipc	a0,0x4
    80002fea:	5aa50513          	addi	a0,a0,1450 # 80007590 <etext+0x590>
    80002fee:	fa6fd0ef          	jal	80000794 <panic>

0000000080002ff2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002ff2:	1101                	addi	sp,sp,-32
    80002ff4:	ec06                	sd	ra,24(sp)
    80002ff6:	e822                	sd	s0,16(sp)
    80002ff8:	e426                	sd	s1,8(sp)
    80002ffa:	e04a                	sd	s2,0(sp)
    80002ffc:	1000                	addi	s0,sp,32
    80002ffe:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003000:	01050913          	addi	s2,a0,16
    80003004:	854a                	mv	a0,s2
    80003006:	1bc010ef          	jal	800041c2 <holdingsleep>
    8000300a:	c135                	beqz	a0,8000306e <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000300c:	854a                	mv	a0,s2
    8000300e:	17c010ef          	jal	8000418a <releasesleep>

  acquire(&bcache.lock);
    80003012:	0002b517          	auipc	a0,0x2b
    80003016:	c0e50513          	addi	a0,a0,-1010 # 8002dc20 <bcache>
    8000301a:	bdbfd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    8000301e:	40bc                	lw	a5,64(s1)
    80003020:	37fd                	addiw	a5,a5,-1
    80003022:	0007871b          	sext.w	a4,a5
    80003026:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003028:	e71d                	bnez	a4,80003056 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000302a:	68b8                	ld	a4,80(s1)
    8000302c:	64bc                	ld	a5,72(s1)
    8000302e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003030:	68b8                	ld	a4,80(s1)
    80003032:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003034:	00033797          	auipc	a5,0x33
    80003038:	bec78793          	addi	a5,a5,-1044 # 80035c20 <bcache+0x8000>
    8000303c:	2b87b703          	ld	a4,696(a5)
    80003040:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003042:	00033717          	auipc	a4,0x33
    80003046:	e4670713          	addi	a4,a4,-442 # 80035e88 <bcache+0x8268>
    8000304a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000304c:	2b87b703          	ld	a4,696(a5)
    80003050:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003052:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003056:	0002b517          	auipc	a0,0x2b
    8000305a:	bca50513          	addi	a0,a0,-1078 # 8002dc20 <bcache>
    8000305e:	c2ffd0ef          	jal	80000c8c <release>
}
    80003062:	60e2                	ld	ra,24(sp)
    80003064:	6442                	ld	s0,16(sp)
    80003066:	64a2                	ld	s1,8(sp)
    80003068:	6902                	ld	s2,0(sp)
    8000306a:	6105                	addi	sp,sp,32
    8000306c:	8082                	ret
    panic("brelse");
    8000306e:	00004517          	auipc	a0,0x4
    80003072:	52a50513          	addi	a0,a0,1322 # 80007598 <etext+0x598>
    80003076:	f1efd0ef          	jal	80000794 <panic>

000000008000307a <bpin>:

void
bpin(struct buf *b) {
    8000307a:	1101                	addi	sp,sp,-32
    8000307c:	ec06                	sd	ra,24(sp)
    8000307e:	e822                	sd	s0,16(sp)
    80003080:	e426                	sd	s1,8(sp)
    80003082:	1000                	addi	s0,sp,32
    80003084:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003086:	0002b517          	auipc	a0,0x2b
    8000308a:	b9a50513          	addi	a0,a0,-1126 # 8002dc20 <bcache>
    8000308e:	b67fd0ef          	jal	80000bf4 <acquire>
  b->refcnt++;
    80003092:	40bc                	lw	a5,64(s1)
    80003094:	2785                	addiw	a5,a5,1
    80003096:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003098:	0002b517          	auipc	a0,0x2b
    8000309c:	b8850513          	addi	a0,a0,-1144 # 8002dc20 <bcache>
    800030a0:	bedfd0ef          	jal	80000c8c <release>
}
    800030a4:	60e2                	ld	ra,24(sp)
    800030a6:	6442                	ld	s0,16(sp)
    800030a8:	64a2                	ld	s1,8(sp)
    800030aa:	6105                	addi	sp,sp,32
    800030ac:	8082                	ret

00000000800030ae <bunpin>:

void
bunpin(struct buf *b) {
    800030ae:	1101                	addi	sp,sp,-32
    800030b0:	ec06                	sd	ra,24(sp)
    800030b2:	e822                	sd	s0,16(sp)
    800030b4:	e426                	sd	s1,8(sp)
    800030b6:	1000                	addi	s0,sp,32
    800030b8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030ba:	0002b517          	auipc	a0,0x2b
    800030be:	b6650513          	addi	a0,a0,-1178 # 8002dc20 <bcache>
    800030c2:	b33fd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    800030c6:	40bc                	lw	a5,64(s1)
    800030c8:	37fd                	addiw	a5,a5,-1
    800030ca:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800030cc:	0002b517          	auipc	a0,0x2b
    800030d0:	b5450513          	addi	a0,a0,-1196 # 8002dc20 <bcache>
    800030d4:	bb9fd0ef          	jal	80000c8c <release>
}
    800030d8:	60e2                	ld	ra,24(sp)
    800030da:	6442                	ld	s0,16(sp)
    800030dc:	64a2                	ld	s1,8(sp)
    800030de:	6105                	addi	sp,sp,32
    800030e0:	8082                	ret

00000000800030e2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800030e2:	1101                	addi	sp,sp,-32
    800030e4:	ec06                	sd	ra,24(sp)
    800030e6:	e822                	sd	s0,16(sp)
    800030e8:	e426                	sd	s1,8(sp)
    800030ea:	e04a                	sd	s2,0(sp)
    800030ec:	1000                	addi	s0,sp,32
    800030ee:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800030f0:	00d5d59b          	srliw	a1,a1,0xd
    800030f4:	00033797          	auipc	a5,0x33
    800030f8:	2087a783          	lw	a5,520(a5) # 800362fc <sb+0x1c>
    800030fc:	9dbd                	addw	a1,a1,a5
    800030fe:	dedff0ef          	jal	80002eea <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003102:	0074f713          	andi	a4,s1,7
    80003106:	4785                	li	a5,1
    80003108:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000310c:	14ce                	slli	s1,s1,0x33
    8000310e:	90d9                	srli	s1,s1,0x36
    80003110:	00950733          	add	a4,a0,s1
    80003114:	05874703          	lbu	a4,88(a4)
    80003118:	00e7f6b3          	and	a3,a5,a4
    8000311c:	c29d                	beqz	a3,80003142 <bfree+0x60>
    8000311e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003120:	94aa                	add	s1,s1,a0
    80003122:	fff7c793          	not	a5,a5
    80003126:	8f7d                	and	a4,a4,a5
    80003128:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000312c:	711000ef          	jal	8000403c <log_write>
  brelse(bp);
    80003130:	854a                	mv	a0,s2
    80003132:	ec1ff0ef          	jal	80002ff2 <brelse>
}
    80003136:	60e2                	ld	ra,24(sp)
    80003138:	6442                	ld	s0,16(sp)
    8000313a:	64a2                	ld	s1,8(sp)
    8000313c:	6902                	ld	s2,0(sp)
    8000313e:	6105                	addi	sp,sp,32
    80003140:	8082                	ret
    panic("freeing free block");
    80003142:	00004517          	auipc	a0,0x4
    80003146:	45e50513          	addi	a0,a0,1118 # 800075a0 <etext+0x5a0>
    8000314a:	e4afd0ef          	jal	80000794 <panic>

000000008000314e <balloc>:
{
    8000314e:	711d                	addi	sp,sp,-96
    80003150:	ec86                	sd	ra,88(sp)
    80003152:	e8a2                	sd	s0,80(sp)
    80003154:	e4a6                	sd	s1,72(sp)
    80003156:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003158:	00033797          	auipc	a5,0x33
    8000315c:	18c7a783          	lw	a5,396(a5) # 800362e4 <sb+0x4>
    80003160:	0e078f63          	beqz	a5,8000325e <balloc+0x110>
    80003164:	e0ca                	sd	s2,64(sp)
    80003166:	fc4e                	sd	s3,56(sp)
    80003168:	f852                	sd	s4,48(sp)
    8000316a:	f456                	sd	s5,40(sp)
    8000316c:	f05a                	sd	s6,32(sp)
    8000316e:	ec5e                	sd	s7,24(sp)
    80003170:	e862                	sd	s8,16(sp)
    80003172:	e466                	sd	s9,8(sp)
    80003174:	8baa                	mv	s7,a0
    80003176:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003178:	00033b17          	auipc	s6,0x33
    8000317c:	168b0b13          	addi	s6,s6,360 # 800362e0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003180:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003182:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003184:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003186:	6c89                	lui	s9,0x2
    80003188:	a0b5                	j	800031f4 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000318a:	97ca                	add	a5,a5,s2
    8000318c:	8e55                	or	a2,a2,a3
    8000318e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003192:	854a                	mv	a0,s2
    80003194:	6a9000ef          	jal	8000403c <log_write>
        brelse(bp);
    80003198:	854a                	mv	a0,s2
    8000319a:	e59ff0ef          	jal	80002ff2 <brelse>
  bp = bread(dev, bno);
    8000319e:	85a6                	mv	a1,s1
    800031a0:	855e                	mv	a0,s7
    800031a2:	d49ff0ef          	jal	80002eea <bread>
    800031a6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800031a8:	40000613          	li	a2,1024
    800031ac:	4581                	li	a1,0
    800031ae:	05850513          	addi	a0,a0,88
    800031b2:	b17fd0ef          	jal	80000cc8 <memset>
  log_write(bp);
    800031b6:	854a                	mv	a0,s2
    800031b8:	685000ef          	jal	8000403c <log_write>
  brelse(bp);
    800031bc:	854a                	mv	a0,s2
    800031be:	e35ff0ef          	jal	80002ff2 <brelse>
}
    800031c2:	6906                	ld	s2,64(sp)
    800031c4:	79e2                	ld	s3,56(sp)
    800031c6:	7a42                	ld	s4,48(sp)
    800031c8:	7aa2                	ld	s5,40(sp)
    800031ca:	7b02                	ld	s6,32(sp)
    800031cc:	6be2                	ld	s7,24(sp)
    800031ce:	6c42                	ld	s8,16(sp)
    800031d0:	6ca2                	ld	s9,8(sp)
}
    800031d2:	8526                	mv	a0,s1
    800031d4:	60e6                	ld	ra,88(sp)
    800031d6:	6446                	ld	s0,80(sp)
    800031d8:	64a6                	ld	s1,72(sp)
    800031da:	6125                	addi	sp,sp,96
    800031dc:	8082                	ret
    brelse(bp);
    800031de:	854a                	mv	a0,s2
    800031e0:	e13ff0ef          	jal	80002ff2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800031e4:	015c87bb          	addw	a5,s9,s5
    800031e8:	00078a9b          	sext.w	s5,a5
    800031ec:	004b2703          	lw	a4,4(s6)
    800031f0:	04eaff63          	bgeu	s5,a4,8000324e <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800031f4:	41fad79b          	sraiw	a5,s5,0x1f
    800031f8:	0137d79b          	srliw	a5,a5,0x13
    800031fc:	015787bb          	addw	a5,a5,s5
    80003200:	40d7d79b          	sraiw	a5,a5,0xd
    80003204:	01cb2583          	lw	a1,28(s6)
    80003208:	9dbd                	addw	a1,a1,a5
    8000320a:	855e                	mv	a0,s7
    8000320c:	cdfff0ef          	jal	80002eea <bread>
    80003210:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003212:	004b2503          	lw	a0,4(s6)
    80003216:	000a849b          	sext.w	s1,s5
    8000321a:	8762                	mv	a4,s8
    8000321c:	fca4f1e3          	bgeu	s1,a0,800031de <balloc+0x90>
      m = 1 << (bi % 8);
    80003220:	00777693          	andi	a3,a4,7
    80003224:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003228:	41f7579b          	sraiw	a5,a4,0x1f
    8000322c:	01d7d79b          	srliw	a5,a5,0x1d
    80003230:	9fb9                	addw	a5,a5,a4
    80003232:	4037d79b          	sraiw	a5,a5,0x3
    80003236:	00f90633          	add	a2,s2,a5
    8000323a:	05864603          	lbu	a2,88(a2)
    8000323e:	00c6f5b3          	and	a1,a3,a2
    80003242:	d5a1                	beqz	a1,8000318a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003244:	2705                	addiw	a4,a4,1
    80003246:	2485                	addiw	s1,s1,1
    80003248:	fd471ae3          	bne	a4,s4,8000321c <balloc+0xce>
    8000324c:	bf49                	j	800031de <balloc+0x90>
    8000324e:	6906                	ld	s2,64(sp)
    80003250:	79e2                	ld	s3,56(sp)
    80003252:	7a42                	ld	s4,48(sp)
    80003254:	7aa2                	ld	s5,40(sp)
    80003256:	7b02                	ld	s6,32(sp)
    80003258:	6be2                	ld	s7,24(sp)
    8000325a:	6c42                	ld	s8,16(sp)
    8000325c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000325e:	00004517          	auipc	a0,0x4
    80003262:	35a50513          	addi	a0,a0,858 # 800075b8 <etext+0x5b8>
    80003266:	a5cfd0ef          	jal	800004c2 <printf>
  return 0;
    8000326a:	4481                	li	s1,0
    8000326c:	b79d                	j	800031d2 <balloc+0x84>

000000008000326e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000326e:	7179                	addi	sp,sp,-48
    80003270:	f406                	sd	ra,40(sp)
    80003272:	f022                	sd	s0,32(sp)
    80003274:	ec26                	sd	s1,24(sp)
    80003276:	e84a                	sd	s2,16(sp)
    80003278:	e44e                	sd	s3,8(sp)
    8000327a:	1800                	addi	s0,sp,48
    8000327c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000327e:	47ad                	li	a5,11
    80003280:	02b7e663          	bltu	a5,a1,800032ac <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80003284:	02059793          	slli	a5,a1,0x20
    80003288:	01e7d593          	srli	a1,a5,0x1e
    8000328c:	00b504b3          	add	s1,a0,a1
    80003290:	0504a903          	lw	s2,80(s1)
    80003294:	06091a63          	bnez	s2,80003308 <bmap+0x9a>
      addr = balloc(ip->dev);
    80003298:	4108                	lw	a0,0(a0)
    8000329a:	eb5ff0ef          	jal	8000314e <balloc>
    8000329e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800032a2:	06090363          	beqz	s2,80003308 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800032a6:	0524a823          	sw	s2,80(s1)
    800032aa:	a8b9                	j	80003308 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800032ac:	ff45849b          	addiw	s1,a1,-12
    800032b0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800032b4:	0ff00793          	li	a5,255
    800032b8:	06e7ee63          	bltu	a5,a4,80003334 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800032bc:	08052903          	lw	s2,128(a0)
    800032c0:	00091d63          	bnez	s2,800032da <bmap+0x6c>
      addr = balloc(ip->dev);
    800032c4:	4108                	lw	a0,0(a0)
    800032c6:	e89ff0ef          	jal	8000314e <balloc>
    800032ca:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800032ce:	02090d63          	beqz	s2,80003308 <bmap+0x9a>
    800032d2:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800032d4:	0929a023          	sw	s2,128(s3)
    800032d8:	a011                	j	800032dc <bmap+0x6e>
    800032da:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800032dc:	85ca                	mv	a1,s2
    800032de:	0009a503          	lw	a0,0(s3)
    800032e2:	c09ff0ef          	jal	80002eea <bread>
    800032e6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800032e8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800032ec:	02049713          	slli	a4,s1,0x20
    800032f0:	01e75593          	srli	a1,a4,0x1e
    800032f4:	00b784b3          	add	s1,a5,a1
    800032f8:	0004a903          	lw	s2,0(s1)
    800032fc:	00090e63          	beqz	s2,80003318 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003300:	8552                	mv	a0,s4
    80003302:	cf1ff0ef          	jal	80002ff2 <brelse>
    return addr;
    80003306:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003308:	854a                	mv	a0,s2
    8000330a:	70a2                	ld	ra,40(sp)
    8000330c:	7402                	ld	s0,32(sp)
    8000330e:	64e2                	ld	s1,24(sp)
    80003310:	6942                	ld	s2,16(sp)
    80003312:	69a2                	ld	s3,8(sp)
    80003314:	6145                	addi	sp,sp,48
    80003316:	8082                	ret
      addr = balloc(ip->dev);
    80003318:	0009a503          	lw	a0,0(s3)
    8000331c:	e33ff0ef          	jal	8000314e <balloc>
    80003320:	0005091b          	sext.w	s2,a0
      if(addr){
    80003324:	fc090ee3          	beqz	s2,80003300 <bmap+0x92>
        a[bn] = addr;
    80003328:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000332c:	8552                	mv	a0,s4
    8000332e:	50f000ef          	jal	8000403c <log_write>
    80003332:	b7f9                	j	80003300 <bmap+0x92>
    80003334:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003336:	00004517          	auipc	a0,0x4
    8000333a:	29a50513          	addi	a0,a0,666 # 800075d0 <etext+0x5d0>
    8000333e:	c56fd0ef          	jal	80000794 <panic>

0000000080003342 <iget>:
{
    80003342:	7179                	addi	sp,sp,-48
    80003344:	f406                	sd	ra,40(sp)
    80003346:	f022                	sd	s0,32(sp)
    80003348:	ec26                	sd	s1,24(sp)
    8000334a:	e84a                	sd	s2,16(sp)
    8000334c:	e44e                	sd	s3,8(sp)
    8000334e:	e052                	sd	s4,0(sp)
    80003350:	1800                	addi	s0,sp,48
    80003352:	89aa                	mv	s3,a0
    80003354:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003356:	00033517          	auipc	a0,0x33
    8000335a:	faa50513          	addi	a0,a0,-86 # 80036300 <itable>
    8000335e:	897fd0ef          	jal	80000bf4 <acquire>
  empty = 0;
    80003362:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003364:	00033497          	auipc	s1,0x33
    80003368:	fb448493          	addi	s1,s1,-76 # 80036318 <itable+0x18>
    8000336c:	00035697          	auipc	a3,0x35
    80003370:	a3c68693          	addi	a3,a3,-1476 # 80037da8 <log>
    80003374:	a039                	j	80003382 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003376:	02090963          	beqz	s2,800033a8 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000337a:	08848493          	addi	s1,s1,136
    8000337e:	02d48863          	beq	s1,a3,800033ae <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003382:	449c                	lw	a5,8(s1)
    80003384:	fef059e3          	blez	a5,80003376 <iget+0x34>
    80003388:	4098                	lw	a4,0(s1)
    8000338a:	ff3716e3          	bne	a4,s3,80003376 <iget+0x34>
    8000338e:	40d8                	lw	a4,4(s1)
    80003390:	ff4713e3          	bne	a4,s4,80003376 <iget+0x34>
      ip->ref++;
    80003394:	2785                	addiw	a5,a5,1
    80003396:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003398:	00033517          	auipc	a0,0x33
    8000339c:	f6850513          	addi	a0,a0,-152 # 80036300 <itable>
    800033a0:	8edfd0ef          	jal	80000c8c <release>
      return ip;
    800033a4:	8926                	mv	s2,s1
    800033a6:	a02d                	j	800033d0 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800033a8:	fbe9                	bnez	a5,8000337a <iget+0x38>
      empty = ip;
    800033aa:	8926                	mv	s2,s1
    800033ac:	b7f9                	j	8000337a <iget+0x38>
  if(empty == 0)
    800033ae:	02090a63          	beqz	s2,800033e2 <iget+0xa0>
  ip->dev = dev;
    800033b2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800033b6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800033ba:	4785                	li	a5,1
    800033bc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800033c0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800033c4:	00033517          	auipc	a0,0x33
    800033c8:	f3c50513          	addi	a0,a0,-196 # 80036300 <itable>
    800033cc:	8c1fd0ef          	jal	80000c8c <release>
}
    800033d0:	854a                	mv	a0,s2
    800033d2:	70a2                	ld	ra,40(sp)
    800033d4:	7402                	ld	s0,32(sp)
    800033d6:	64e2                	ld	s1,24(sp)
    800033d8:	6942                	ld	s2,16(sp)
    800033da:	69a2                	ld	s3,8(sp)
    800033dc:	6a02                	ld	s4,0(sp)
    800033de:	6145                	addi	sp,sp,48
    800033e0:	8082                	ret
    panic("iget: no inodes");
    800033e2:	00004517          	auipc	a0,0x4
    800033e6:	20650513          	addi	a0,a0,518 # 800075e8 <etext+0x5e8>
    800033ea:	baafd0ef          	jal	80000794 <panic>

00000000800033ee <fsinit>:
fsinit(int dev) {
    800033ee:	7179                	addi	sp,sp,-48
    800033f0:	f406                	sd	ra,40(sp)
    800033f2:	f022                	sd	s0,32(sp)
    800033f4:	ec26                	sd	s1,24(sp)
    800033f6:	e84a                	sd	s2,16(sp)
    800033f8:	e44e                	sd	s3,8(sp)
    800033fa:	1800                	addi	s0,sp,48
    800033fc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800033fe:	4585                	li	a1,1
    80003400:	aebff0ef          	jal	80002eea <bread>
    80003404:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003406:	00033997          	auipc	s3,0x33
    8000340a:	eda98993          	addi	s3,s3,-294 # 800362e0 <sb>
    8000340e:	02000613          	li	a2,32
    80003412:	05850593          	addi	a1,a0,88
    80003416:	854e                	mv	a0,s3
    80003418:	90dfd0ef          	jal	80000d24 <memmove>
  brelse(bp);
    8000341c:	8526                	mv	a0,s1
    8000341e:	bd5ff0ef          	jal	80002ff2 <brelse>
  if(sb.magic != FSMAGIC)
    80003422:	0009a703          	lw	a4,0(s3)
    80003426:	102037b7          	lui	a5,0x10203
    8000342a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000342e:	02f71063          	bne	a4,a5,8000344e <fsinit+0x60>
  initlog(dev, &sb);
    80003432:	00033597          	auipc	a1,0x33
    80003436:	eae58593          	addi	a1,a1,-338 # 800362e0 <sb>
    8000343a:	854a                	mv	a0,s2
    8000343c:	1f9000ef          	jal	80003e34 <initlog>
}
    80003440:	70a2                	ld	ra,40(sp)
    80003442:	7402                	ld	s0,32(sp)
    80003444:	64e2                	ld	s1,24(sp)
    80003446:	6942                	ld	s2,16(sp)
    80003448:	69a2                	ld	s3,8(sp)
    8000344a:	6145                	addi	sp,sp,48
    8000344c:	8082                	ret
    panic("invalid file system");
    8000344e:	00004517          	auipc	a0,0x4
    80003452:	1aa50513          	addi	a0,a0,426 # 800075f8 <etext+0x5f8>
    80003456:	b3efd0ef          	jal	80000794 <panic>

000000008000345a <iinit>:
{
    8000345a:	7179                	addi	sp,sp,-48
    8000345c:	f406                	sd	ra,40(sp)
    8000345e:	f022                	sd	s0,32(sp)
    80003460:	ec26                	sd	s1,24(sp)
    80003462:	e84a                	sd	s2,16(sp)
    80003464:	e44e                	sd	s3,8(sp)
    80003466:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003468:	00004597          	auipc	a1,0x4
    8000346c:	1a858593          	addi	a1,a1,424 # 80007610 <etext+0x610>
    80003470:	00033517          	auipc	a0,0x33
    80003474:	e9050513          	addi	a0,a0,-368 # 80036300 <itable>
    80003478:	efcfd0ef          	jal	80000b74 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000347c:	00033497          	auipc	s1,0x33
    80003480:	eac48493          	addi	s1,s1,-340 # 80036328 <itable+0x28>
    80003484:	00035997          	auipc	s3,0x35
    80003488:	93498993          	addi	s3,s3,-1740 # 80037db8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000348c:	00004917          	auipc	s2,0x4
    80003490:	18c90913          	addi	s2,s2,396 # 80007618 <etext+0x618>
    80003494:	85ca                	mv	a1,s2
    80003496:	8526                	mv	a0,s1
    80003498:	475000ef          	jal	8000410c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000349c:	08848493          	addi	s1,s1,136
    800034a0:	ff349ae3          	bne	s1,s3,80003494 <iinit+0x3a>
}
    800034a4:	70a2                	ld	ra,40(sp)
    800034a6:	7402                	ld	s0,32(sp)
    800034a8:	64e2                	ld	s1,24(sp)
    800034aa:	6942                	ld	s2,16(sp)
    800034ac:	69a2                	ld	s3,8(sp)
    800034ae:	6145                	addi	sp,sp,48
    800034b0:	8082                	ret

00000000800034b2 <ialloc>:
{
    800034b2:	7139                	addi	sp,sp,-64
    800034b4:	fc06                	sd	ra,56(sp)
    800034b6:	f822                	sd	s0,48(sp)
    800034b8:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800034ba:	00033717          	auipc	a4,0x33
    800034be:	e3272703          	lw	a4,-462(a4) # 800362ec <sb+0xc>
    800034c2:	4785                	li	a5,1
    800034c4:	06e7f063          	bgeu	a5,a4,80003524 <ialloc+0x72>
    800034c8:	f426                	sd	s1,40(sp)
    800034ca:	f04a                	sd	s2,32(sp)
    800034cc:	ec4e                	sd	s3,24(sp)
    800034ce:	e852                	sd	s4,16(sp)
    800034d0:	e456                	sd	s5,8(sp)
    800034d2:	e05a                	sd	s6,0(sp)
    800034d4:	8aaa                	mv	s5,a0
    800034d6:	8b2e                	mv	s6,a1
    800034d8:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800034da:	00033a17          	auipc	s4,0x33
    800034de:	e06a0a13          	addi	s4,s4,-506 # 800362e0 <sb>
    800034e2:	00495593          	srli	a1,s2,0x4
    800034e6:	018a2783          	lw	a5,24(s4)
    800034ea:	9dbd                	addw	a1,a1,a5
    800034ec:	8556                	mv	a0,s5
    800034ee:	9fdff0ef          	jal	80002eea <bread>
    800034f2:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800034f4:	05850993          	addi	s3,a0,88
    800034f8:	00f97793          	andi	a5,s2,15
    800034fc:	079a                	slli	a5,a5,0x6
    800034fe:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003500:	00099783          	lh	a5,0(s3)
    80003504:	cb9d                	beqz	a5,8000353a <ialloc+0x88>
    brelse(bp);
    80003506:	aedff0ef          	jal	80002ff2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000350a:	0905                	addi	s2,s2,1
    8000350c:	00ca2703          	lw	a4,12(s4)
    80003510:	0009079b          	sext.w	a5,s2
    80003514:	fce7e7e3          	bltu	a5,a4,800034e2 <ialloc+0x30>
    80003518:	74a2                	ld	s1,40(sp)
    8000351a:	7902                	ld	s2,32(sp)
    8000351c:	69e2                	ld	s3,24(sp)
    8000351e:	6a42                	ld	s4,16(sp)
    80003520:	6aa2                	ld	s5,8(sp)
    80003522:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003524:	00004517          	auipc	a0,0x4
    80003528:	0fc50513          	addi	a0,a0,252 # 80007620 <etext+0x620>
    8000352c:	f97fc0ef          	jal	800004c2 <printf>
  return 0;
    80003530:	4501                	li	a0,0
}
    80003532:	70e2                	ld	ra,56(sp)
    80003534:	7442                	ld	s0,48(sp)
    80003536:	6121                	addi	sp,sp,64
    80003538:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000353a:	04000613          	li	a2,64
    8000353e:	4581                	li	a1,0
    80003540:	854e                	mv	a0,s3
    80003542:	f86fd0ef          	jal	80000cc8 <memset>
      dip->type = type;
    80003546:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000354a:	8526                	mv	a0,s1
    8000354c:	2f1000ef          	jal	8000403c <log_write>
      brelse(bp);
    80003550:	8526                	mv	a0,s1
    80003552:	aa1ff0ef          	jal	80002ff2 <brelse>
      return iget(dev, inum);
    80003556:	0009059b          	sext.w	a1,s2
    8000355a:	8556                	mv	a0,s5
    8000355c:	de7ff0ef          	jal	80003342 <iget>
    80003560:	74a2                	ld	s1,40(sp)
    80003562:	7902                	ld	s2,32(sp)
    80003564:	69e2                	ld	s3,24(sp)
    80003566:	6a42                	ld	s4,16(sp)
    80003568:	6aa2                	ld	s5,8(sp)
    8000356a:	6b02                	ld	s6,0(sp)
    8000356c:	b7d9                	j	80003532 <ialloc+0x80>

000000008000356e <iupdate>:
{
    8000356e:	1101                	addi	sp,sp,-32
    80003570:	ec06                	sd	ra,24(sp)
    80003572:	e822                	sd	s0,16(sp)
    80003574:	e426                	sd	s1,8(sp)
    80003576:	e04a                	sd	s2,0(sp)
    80003578:	1000                	addi	s0,sp,32
    8000357a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000357c:	415c                	lw	a5,4(a0)
    8000357e:	0047d79b          	srliw	a5,a5,0x4
    80003582:	00033597          	auipc	a1,0x33
    80003586:	d765a583          	lw	a1,-650(a1) # 800362f8 <sb+0x18>
    8000358a:	9dbd                	addw	a1,a1,a5
    8000358c:	4108                	lw	a0,0(a0)
    8000358e:	95dff0ef          	jal	80002eea <bread>
    80003592:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003594:	05850793          	addi	a5,a0,88
    80003598:	40d8                	lw	a4,4(s1)
    8000359a:	8b3d                	andi	a4,a4,15
    8000359c:	071a                	slli	a4,a4,0x6
    8000359e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800035a0:	04449703          	lh	a4,68(s1)
    800035a4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800035a8:	04649703          	lh	a4,70(s1)
    800035ac:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800035b0:	04849703          	lh	a4,72(s1)
    800035b4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800035b8:	04a49703          	lh	a4,74(s1)
    800035bc:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800035c0:	44f8                	lw	a4,76(s1)
    800035c2:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800035c4:	03400613          	li	a2,52
    800035c8:	05048593          	addi	a1,s1,80
    800035cc:	00c78513          	addi	a0,a5,12
    800035d0:	f54fd0ef          	jal	80000d24 <memmove>
  log_write(bp);
    800035d4:	854a                	mv	a0,s2
    800035d6:	267000ef          	jal	8000403c <log_write>
  brelse(bp);
    800035da:	854a                	mv	a0,s2
    800035dc:	a17ff0ef          	jal	80002ff2 <brelse>
}
    800035e0:	60e2                	ld	ra,24(sp)
    800035e2:	6442                	ld	s0,16(sp)
    800035e4:	64a2                	ld	s1,8(sp)
    800035e6:	6902                	ld	s2,0(sp)
    800035e8:	6105                	addi	sp,sp,32
    800035ea:	8082                	ret

00000000800035ec <idup>:
{
    800035ec:	1101                	addi	sp,sp,-32
    800035ee:	ec06                	sd	ra,24(sp)
    800035f0:	e822                	sd	s0,16(sp)
    800035f2:	e426                	sd	s1,8(sp)
    800035f4:	1000                	addi	s0,sp,32
    800035f6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800035f8:	00033517          	auipc	a0,0x33
    800035fc:	d0850513          	addi	a0,a0,-760 # 80036300 <itable>
    80003600:	df4fd0ef          	jal	80000bf4 <acquire>
  ip->ref++;
    80003604:	449c                	lw	a5,8(s1)
    80003606:	2785                	addiw	a5,a5,1
    80003608:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000360a:	00033517          	auipc	a0,0x33
    8000360e:	cf650513          	addi	a0,a0,-778 # 80036300 <itable>
    80003612:	e7afd0ef          	jal	80000c8c <release>
}
    80003616:	8526                	mv	a0,s1
    80003618:	60e2                	ld	ra,24(sp)
    8000361a:	6442                	ld	s0,16(sp)
    8000361c:	64a2                	ld	s1,8(sp)
    8000361e:	6105                	addi	sp,sp,32
    80003620:	8082                	ret

0000000080003622 <ilock>:
{
    80003622:	1101                	addi	sp,sp,-32
    80003624:	ec06                	sd	ra,24(sp)
    80003626:	e822                	sd	s0,16(sp)
    80003628:	e426                	sd	s1,8(sp)
    8000362a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000362c:	cd19                	beqz	a0,8000364a <ilock+0x28>
    8000362e:	84aa                	mv	s1,a0
    80003630:	451c                	lw	a5,8(a0)
    80003632:	00f05c63          	blez	a5,8000364a <ilock+0x28>
  acquiresleep(&ip->lock);
    80003636:	0541                	addi	a0,a0,16
    80003638:	30b000ef          	jal	80004142 <acquiresleep>
  if(ip->valid == 0){
    8000363c:	40bc                	lw	a5,64(s1)
    8000363e:	cf89                	beqz	a5,80003658 <ilock+0x36>
}
    80003640:	60e2                	ld	ra,24(sp)
    80003642:	6442                	ld	s0,16(sp)
    80003644:	64a2                	ld	s1,8(sp)
    80003646:	6105                	addi	sp,sp,32
    80003648:	8082                	ret
    8000364a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000364c:	00004517          	auipc	a0,0x4
    80003650:	fec50513          	addi	a0,a0,-20 # 80007638 <etext+0x638>
    80003654:	940fd0ef          	jal	80000794 <panic>
    80003658:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000365a:	40dc                	lw	a5,4(s1)
    8000365c:	0047d79b          	srliw	a5,a5,0x4
    80003660:	00033597          	auipc	a1,0x33
    80003664:	c985a583          	lw	a1,-872(a1) # 800362f8 <sb+0x18>
    80003668:	9dbd                	addw	a1,a1,a5
    8000366a:	4088                	lw	a0,0(s1)
    8000366c:	87fff0ef          	jal	80002eea <bread>
    80003670:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003672:	05850593          	addi	a1,a0,88
    80003676:	40dc                	lw	a5,4(s1)
    80003678:	8bbd                	andi	a5,a5,15
    8000367a:	079a                	slli	a5,a5,0x6
    8000367c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000367e:	00059783          	lh	a5,0(a1)
    80003682:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003686:	00259783          	lh	a5,2(a1)
    8000368a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000368e:	00459783          	lh	a5,4(a1)
    80003692:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003696:	00659783          	lh	a5,6(a1)
    8000369a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000369e:	459c                	lw	a5,8(a1)
    800036a0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800036a2:	03400613          	li	a2,52
    800036a6:	05b1                	addi	a1,a1,12
    800036a8:	05048513          	addi	a0,s1,80
    800036ac:	e78fd0ef          	jal	80000d24 <memmove>
    brelse(bp);
    800036b0:	854a                	mv	a0,s2
    800036b2:	941ff0ef          	jal	80002ff2 <brelse>
    ip->valid = 1;
    800036b6:	4785                	li	a5,1
    800036b8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800036ba:	04449783          	lh	a5,68(s1)
    800036be:	c399                	beqz	a5,800036c4 <ilock+0xa2>
    800036c0:	6902                	ld	s2,0(sp)
    800036c2:	bfbd                	j	80003640 <ilock+0x1e>
      panic("ilock: no type");
    800036c4:	00004517          	auipc	a0,0x4
    800036c8:	f7c50513          	addi	a0,a0,-132 # 80007640 <etext+0x640>
    800036cc:	8c8fd0ef          	jal	80000794 <panic>

00000000800036d0 <iunlock>:
{
    800036d0:	1101                	addi	sp,sp,-32
    800036d2:	ec06                	sd	ra,24(sp)
    800036d4:	e822                	sd	s0,16(sp)
    800036d6:	e426                	sd	s1,8(sp)
    800036d8:	e04a                	sd	s2,0(sp)
    800036da:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800036dc:	c505                	beqz	a0,80003704 <iunlock+0x34>
    800036de:	84aa                	mv	s1,a0
    800036e0:	01050913          	addi	s2,a0,16
    800036e4:	854a                	mv	a0,s2
    800036e6:	2dd000ef          	jal	800041c2 <holdingsleep>
    800036ea:	cd09                	beqz	a0,80003704 <iunlock+0x34>
    800036ec:	449c                	lw	a5,8(s1)
    800036ee:	00f05b63          	blez	a5,80003704 <iunlock+0x34>
  releasesleep(&ip->lock);
    800036f2:	854a                	mv	a0,s2
    800036f4:	297000ef          	jal	8000418a <releasesleep>
}
    800036f8:	60e2                	ld	ra,24(sp)
    800036fa:	6442                	ld	s0,16(sp)
    800036fc:	64a2                	ld	s1,8(sp)
    800036fe:	6902                	ld	s2,0(sp)
    80003700:	6105                	addi	sp,sp,32
    80003702:	8082                	ret
    panic("iunlock");
    80003704:	00004517          	auipc	a0,0x4
    80003708:	f4c50513          	addi	a0,a0,-180 # 80007650 <etext+0x650>
    8000370c:	888fd0ef          	jal	80000794 <panic>

0000000080003710 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003710:	7179                	addi	sp,sp,-48
    80003712:	f406                	sd	ra,40(sp)
    80003714:	f022                	sd	s0,32(sp)
    80003716:	ec26                	sd	s1,24(sp)
    80003718:	e84a                	sd	s2,16(sp)
    8000371a:	e44e                	sd	s3,8(sp)
    8000371c:	1800                	addi	s0,sp,48
    8000371e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003720:	05050493          	addi	s1,a0,80
    80003724:	08050913          	addi	s2,a0,128
    80003728:	a021                	j	80003730 <itrunc+0x20>
    8000372a:	0491                	addi	s1,s1,4
    8000372c:	01248b63          	beq	s1,s2,80003742 <itrunc+0x32>
    if(ip->addrs[i]){
    80003730:	408c                	lw	a1,0(s1)
    80003732:	dde5                	beqz	a1,8000372a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003734:	0009a503          	lw	a0,0(s3)
    80003738:	9abff0ef          	jal	800030e2 <bfree>
      ip->addrs[i] = 0;
    8000373c:	0004a023          	sw	zero,0(s1)
    80003740:	b7ed                	j	8000372a <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003742:	0809a583          	lw	a1,128(s3)
    80003746:	ed89                	bnez	a1,80003760 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003748:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000374c:	854e                	mv	a0,s3
    8000374e:	e21ff0ef          	jal	8000356e <iupdate>
}
    80003752:	70a2                	ld	ra,40(sp)
    80003754:	7402                	ld	s0,32(sp)
    80003756:	64e2                	ld	s1,24(sp)
    80003758:	6942                	ld	s2,16(sp)
    8000375a:	69a2                	ld	s3,8(sp)
    8000375c:	6145                	addi	sp,sp,48
    8000375e:	8082                	ret
    80003760:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003762:	0009a503          	lw	a0,0(s3)
    80003766:	f84ff0ef          	jal	80002eea <bread>
    8000376a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000376c:	05850493          	addi	s1,a0,88
    80003770:	45850913          	addi	s2,a0,1112
    80003774:	a021                	j	8000377c <itrunc+0x6c>
    80003776:	0491                	addi	s1,s1,4
    80003778:	01248963          	beq	s1,s2,8000378a <itrunc+0x7a>
      if(a[j])
    8000377c:	408c                	lw	a1,0(s1)
    8000377e:	dde5                	beqz	a1,80003776 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003780:	0009a503          	lw	a0,0(s3)
    80003784:	95fff0ef          	jal	800030e2 <bfree>
    80003788:	b7fd                	j	80003776 <itrunc+0x66>
    brelse(bp);
    8000378a:	8552                	mv	a0,s4
    8000378c:	867ff0ef          	jal	80002ff2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003790:	0809a583          	lw	a1,128(s3)
    80003794:	0009a503          	lw	a0,0(s3)
    80003798:	94bff0ef          	jal	800030e2 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000379c:	0809a023          	sw	zero,128(s3)
    800037a0:	6a02                	ld	s4,0(sp)
    800037a2:	b75d                	j	80003748 <itrunc+0x38>

00000000800037a4 <iput>:
{
    800037a4:	1101                	addi	sp,sp,-32
    800037a6:	ec06                	sd	ra,24(sp)
    800037a8:	e822                	sd	s0,16(sp)
    800037aa:	e426                	sd	s1,8(sp)
    800037ac:	1000                	addi	s0,sp,32
    800037ae:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800037b0:	00033517          	auipc	a0,0x33
    800037b4:	b5050513          	addi	a0,a0,-1200 # 80036300 <itable>
    800037b8:	c3cfd0ef          	jal	80000bf4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037bc:	4498                	lw	a4,8(s1)
    800037be:	4785                	li	a5,1
    800037c0:	02f70063          	beq	a4,a5,800037e0 <iput+0x3c>
  ip->ref--;
    800037c4:	449c                	lw	a5,8(s1)
    800037c6:	37fd                	addiw	a5,a5,-1
    800037c8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800037ca:	00033517          	auipc	a0,0x33
    800037ce:	b3650513          	addi	a0,a0,-1226 # 80036300 <itable>
    800037d2:	cbafd0ef          	jal	80000c8c <release>
}
    800037d6:	60e2                	ld	ra,24(sp)
    800037d8:	6442                	ld	s0,16(sp)
    800037da:	64a2                	ld	s1,8(sp)
    800037dc:	6105                	addi	sp,sp,32
    800037de:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037e0:	40bc                	lw	a5,64(s1)
    800037e2:	d3ed                	beqz	a5,800037c4 <iput+0x20>
    800037e4:	04a49783          	lh	a5,74(s1)
    800037e8:	fff1                	bnez	a5,800037c4 <iput+0x20>
    800037ea:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800037ec:	01048913          	addi	s2,s1,16
    800037f0:	854a                	mv	a0,s2
    800037f2:	151000ef          	jal	80004142 <acquiresleep>
    release(&itable.lock);
    800037f6:	00033517          	auipc	a0,0x33
    800037fa:	b0a50513          	addi	a0,a0,-1270 # 80036300 <itable>
    800037fe:	c8efd0ef          	jal	80000c8c <release>
    itrunc(ip);
    80003802:	8526                	mv	a0,s1
    80003804:	f0dff0ef          	jal	80003710 <itrunc>
    ip->type = 0;
    80003808:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000380c:	8526                	mv	a0,s1
    8000380e:	d61ff0ef          	jal	8000356e <iupdate>
    ip->valid = 0;
    80003812:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003816:	854a                	mv	a0,s2
    80003818:	173000ef          	jal	8000418a <releasesleep>
    acquire(&itable.lock);
    8000381c:	00033517          	auipc	a0,0x33
    80003820:	ae450513          	addi	a0,a0,-1308 # 80036300 <itable>
    80003824:	bd0fd0ef          	jal	80000bf4 <acquire>
    80003828:	6902                	ld	s2,0(sp)
    8000382a:	bf69                	j	800037c4 <iput+0x20>

000000008000382c <iunlockput>:
{
    8000382c:	1101                	addi	sp,sp,-32
    8000382e:	ec06                	sd	ra,24(sp)
    80003830:	e822                	sd	s0,16(sp)
    80003832:	e426                	sd	s1,8(sp)
    80003834:	1000                	addi	s0,sp,32
    80003836:	84aa                	mv	s1,a0
  iunlock(ip);
    80003838:	e99ff0ef          	jal	800036d0 <iunlock>
  iput(ip);
    8000383c:	8526                	mv	a0,s1
    8000383e:	f67ff0ef          	jal	800037a4 <iput>
}
    80003842:	60e2                	ld	ra,24(sp)
    80003844:	6442                	ld	s0,16(sp)
    80003846:	64a2                	ld	s1,8(sp)
    80003848:	6105                	addi	sp,sp,32
    8000384a:	8082                	ret

000000008000384c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000384c:	1141                	addi	sp,sp,-16
    8000384e:	e422                	sd	s0,8(sp)
    80003850:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003852:	411c                	lw	a5,0(a0)
    80003854:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003856:	415c                	lw	a5,4(a0)
    80003858:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000385a:	04451783          	lh	a5,68(a0)
    8000385e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003862:	04a51783          	lh	a5,74(a0)
    80003866:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000386a:	04c56783          	lwu	a5,76(a0)
    8000386e:	e99c                	sd	a5,16(a1)
}
    80003870:	6422                	ld	s0,8(sp)
    80003872:	0141                	addi	sp,sp,16
    80003874:	8082                	ret

0000000080003876 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003876:	457c                	lw	a5,76(a0)
    80003878:	0ed7eb63          	bltu	a5,a3,8000396e <readi+0xf8>
{
    8000387c:	7159                	addi	sp,sp,-112
    8000387e:	f486                	sd	ra,104(sp)
    80003880:	f0a2                	sd	s0,96(sp)
    80003882:	eca6                	sd	s1,88(sp)
    80003884:	e0d2                	sd	s4,64(sp)
    80003886:	fc56                	sd	s5,56(sp)
    80003888:	f85a                	sd	s6,48(sp)
    8000388a:	f45e                	sd	s7,40(sp)
    8000388c:	1880                	addi	s0,sp,112
    8000388e:	8b2a                	mv	s6,a0
    80003890:	8bae                	mv	s7,a1
    80003892:	8a32                	mv	s4,a2
    80003894:	84b6                	mv	s1,a3
    80003896:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003898:	9f35                	addw	a4,a4,a3
    return 0;
    8000389a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000389c:	0cd76063          	bltu	a4,a3,8000395c <readi+0xe6>
    800038a0:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800038a2:	00e7f463          	bgeu	a5,a4,800038aa <readi+0x34>
    n = ip->size - off;
    800038a6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800038aa:	080a8f63          	beqz	s5,80003948 <readi+0xd2>
    800038ae:	e8ca                	sd	s2,80(sp)
    800038b0:	f062                	sd	s8,32(sp)
    800038b2:	ec66                	sd	s9,24(sp)
    800038b4:	e86a                	sd	s10,16(sp)
    800038b6:	e46e                	sd	s11,8(sp)
    800038b8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800038ba:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800038be:	5c7d                	li	s8,-1
    800038c0:	a80d                	j	800038f2 <readi+0x7c>
    800038c2:	020d1d93          	slli	s11,s10,0x20
    800038c6:	020ddd93          	srli	s11,s11,0x20
    800038ca:	05890613          	addi	a2,s2,88
    800038ce:	86ee                	mv	a3,s11
    800038d0:	963a                	add	a2,a2,a4
    800038d2:	85d2                	mv	a1,s4
    800038d4:	855e                	mv	a0,s7
    800038d6:	907fe0ef          	jal	800021dc <either_copyout>
    800038da:	05850763          	beq	a0,s8,80003928 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800038de:	854a                	mv	a0,s2
    800038e0:	f12ff0ef          	jal	80002ff2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800038e4:	013d09bb          	addw	s3,s10,s3
    800038e8:	009d04bb          	addw	s1,s10,s1
    800038ec:	9a6e                	add	s4,s4,s11
    800038ee:	0559f763          	bgeu	s3,s5,8000393c <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    800038f2:	00a4d59b          	srliw	a1,s1,0xa
    800038f6:	855a                	mv	a0,s6
    800038f8:	977ff0ef          	jal	8000326e <bmap>
    800038fc:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003900:	c5b1                	beqz	a1,8000394c <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003902:	000b2503          	lw	a0,0(s6)
    80003906:	de4ff0ef          	jal	80002eea <bread>
    8000390a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000390c:	3ff4f713          	andi	a4,s1,1023
    80003910:	40ec87bb          	subw	a5,s9,a4
    80003914:	413a86bb          	subw	a3,s5,s3
    80003918:	8d3e                	mv	s10,a5
    8000391a:	2781                	sext.w	a5,a5
    8000391c:	0006861b          	sext.w	a2,a3
    80003920:	faf671e3          	bgeu	a2,a5,800038c2 <readi+0x4c>
    80003924:	8d36                	mv	s10,a3
    80003926:	bf71                	j	800038c2 <readi+0x4c>
      brelse(bp);
    80003928:	854a                	mv	a0,s2
    8000392a:	ec8ff0ef          	jal	80002ff2 <brelse>
      tot = -1;
    8000392e:	59fd                	li	s3,-1
      break;
    80003930:	6946                	ld	s2,80(sp)
    80003932:	7c02                	ld	s8,32(sp)
    80003934:	6ce2                	ld	s9,24(sp)
    80003936:	6d42                	ld	s10,16(sp)
    80003938:	6da2                	ld	s11,8(sp)
    8000393a:	a831                	j	80003956 <readi+0xe0>
    8000393c:	6946                	ld	s2,80(sp)
    8000393e:	7c02                	ld	s8,32(sp)
    80003940:	6ce2                	ld	s9,24(sp)
    80003942:	6d42                	ld	s10,16(sp)
    80003944:	6da2                	ld	s11,8(sp)
    80003946:	a801                	j	80003956 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003948:	89d6                	mv	s3,s5
    8000394a:	a031                	j	80003956 <readi+0xe0>
    8000394c:	6946                	ld	s2,80(sp)
    8000394e:	7c02                	ld	s8,32(sp)
    80003950:	6ce2                	ld	s9,24(sp)
    80003952:	6d42                	ld	s10,16(sp)
    80003954:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003956:	0009851b          	sext.w	a0,s3
    8000395a:	69a6                	ld	s3,72(sp)
}
    8000395c:	70a6                	ld	ra,104(sp)
    8000395e:	7406                	ld	s0,96(sp)
    80003960:	64e6                	ld	s1,88(sp)
    80003962:	6a06                	ld	s4,64(sp)
    80003964:	7ae2                	ld	s5,56(sp)
    80003966:	7b42                	ld	s6,48(sp)
    80003968:	7ba2                	ld	s7,40(sp)
    8000396a:	6165                	addi	sp,sp,112
    8000396c:	8082                	ret
    return 0;
    8000396e:	4501                	li	a0,0
}
    80003970:	8082                	ret

0000000080003972 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003972:	457c                	lw	a5,76(a0)
    80003974:	10d7e063          	bltu	a5,a3,80003a74 <writei+0x102>
{
    80003978:	7159                	addi	sp,sp,-112
    8000397a:	f486                	sd	ra,104(sp)
    8000397c:	f0a2                	sd	s0,96(sp)
    8000397e:	e8ca                	sd	s2,80(sp)
    80003980:	e0d2                	sd	s4,64(sp)
    80003982:	fc56                	sd	s5,56(sp)
    80003984:	f85a                	sd	s6,48(sp)
    80003986:	f45e                	sd	s7,40(sp)
    80003988:	1880                	addi	s0,sp,112
    8000398a:	8aaa                	mv	s5,a0
    8000398c:	8bae                	mv	s7,a1
    8000398e:	8a32                	mv	s4,a2
    80003990:	8936                	mv	s2,a3
    80003992:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003994:	00e687bb          	addw	a5,a3,a4
    80003998:	0ed7e063          	bltu	a5,a3,80003a78 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000399c:	00043737          	lui	a4,0x43
    800039a0:	0cf76e63          	bltu	a4,a5,80003a7c <writei+0x10a>
    800039a4:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039a6:	0a0b0f63          	beqz	s6,80003a64 <writei+0xf2>
    800039aa:	eca6                	sd	s1,88(sp)
    800039ac:	f062                	sd	s8,32(sp)
    800039ae:	ec66                	sd	s9,24(sp)
    800039b0:	e86a                	sd	s10,16(sp)
    800039b2:	e46e                	sd	s11,8(sp)
    800039b4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800039b6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800039ba:	5c7d                	li	s8,-1
    800039bc:	a825                	j	800039f4 <writei+0x82>
    800039be:	020d1d93          	slli	s11,s10,0x20
    800039c2:	020ddd93          	srli	s11,s11,0x20
    800039c6:	05848513          	addi	a0,s1,88
    800039ca:	86ee                	mv	a3,s11
    800039cc:	8652                	mv	a2,s4
    800039ce:	85de                	mv	a1,s7
    800039d0:	953a                	add	a0,a0,a4
    800039d2:	857fe0ef          	jal	80002228 <either_copyin>
    800039d6:	05850a63          	beq	a0,s8,80003a2a <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800039da:	8526                	mv	a0,s1
    800039dc:	660000ef          	jal	8000403c <log_write>
    brelse(bp);
    800039e0:	8526                	mv	a0,s1
    800039e2:	e10ff0ef          	jal	80002ff2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039e6:	013d09bb          	addw	s3,s10,s3
    800039ea:	012d093b          	addw	s2,s10,s2
    800039ee:	9a6e                	add	s4,s4,s11
    800039f0:	0569f063          	bgeu	s3,s6,80003a30 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800039f4:	00a9559b          	srliw	a1,s2,0xa
    800039f8:	8556                	mv	a0,s5
    800039fa:	875ff0ef          	jal	8000326e <bmap>
    800039fe:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003a02:	c59d                	beqz	a1,80003a30 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003a04:	000aa503          	lw	a0,0(s5)
    80003a08:	ce2ff0ef          	jal	80002eea <bread>
    80003a0c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a0e:	3ff97713          	andi	a4,s2,1023
    80003a12:	40ec87bb          	subw	a5,s9,a4
    80003a16:	413b06bb          	subw	a3,s6,s3
    80003a1a:	8d3e                	mv	s10,a5
    80003a1c:	2781                	sext.w	a5,a5
    80003a1e:	0006861b          	sext.w	a2,a3
    80003a22:	f8f67ee3          	bgeu	a2,a5,800039be <writei+0x4c>
    80003a26:	8d36                	mv	s10,a3
    80003a28:	bf59                	j	800039be <writei+0x4c>
      brelse(bp);
    80003a2a:	8526                	mv	a0,s1
    80003a2c:	dc6ff0ef          	jal	80002ff2 <brelse>
  }

  if(off > ip->size)
    80003a30:	04caa783          	lw	a5,76(s5)
    80003a34:	0327fa63          	bgeu	a5,s2,80003a68 <writei+0xf6>
    ip->size = off;
    80003a38:	052aa623          	sw	s2,76(s5)
    80003a3c:	64e6                	ld	s1,88(sp)
    80003a3e:	7c02                	ld	s8,32(sp)
    80003a40:	6ce2                	ld	s9,24(sp)
    80003a42:	6d42                	ld	s10,16(sp)
    80003a44:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003a46:	8556                	mv	a0,s5
    80003a48:	b27ff0ef          	jal	8000356e <iupdate>

  return tot;
    80003a4c:	0009851b          	sext.w	a0,s3
    80003a50:	69a6                	ld	s3,72(sp)
}
    80003a52:	70a6                	ld	ra,104(sp)
    80003a54:	7406                	ld	s0,96(sp)
    80003a56:	6946                	ld	s2,80(sp)
    80003a58:	6a06                	ld	s4,64(sp)
    80003a5a:	7ae2                	ld	s5,56(sp)
    80003a5c:	7b42                	ld	s6,48(sp)
    80003a5e:	7ba2                	ld	s7,40(sp)
    80003a60:	6165                	addi	sp,sp,112
    80003a62:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003a64:	89da                	mv	s3,s6
    80003a66:	b7c5                	j	80003a46 <writei+0xd4>
    80003a68:	64e6                	ld	s1,88(sp)
    80003a6a:	7c02                	ld	s8,32(sp)
    80003a6c:	6ce2                	ld	s9,24(sp)
    80003a6e:	6d42                	ld	s10,16(sp)
    80003a70:	6da2                	ld	s11,8(sp)
    80003a72:	bfd1                	j	80003a46 <writei+0xd4>
    return -1;
    80003a74:	557d                	li	a0,-1
}
    80003a76:	8082                	ret
    return -1;
    80003a78:	557d                	li	a0,-1
    80003a7a:	bfe1                	j	80003a52 <writei+0xe0>
    return -1;
    80003a7c:	557d                	li	a0,-1
    80003a7e:	bfd1                	j	80003a52 <writei+0xe0>

0000000080003a80 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003a80:	1141                	addi	sp,sp,-16
    80003a82:	e406                	sd	ra,8(sp)
    80003a84:	e022                	sd	s0,0(sp)
    80003a86:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003a88:	4639                	li	a2,14
    80003a8a:	b0afd0ef          	jal	80000d94 <strncmp>
}
    80003a8e:	60a2                	ld	ra,8(sp)
    80003a90:	6402                	ld	s0,0(sp)
    80003a92:	0141                	addi	sp,sp,16
    80003a94:	8082                	ret

0000000080003a96 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003a96:	7139                	addi	sp,sp,-64
    80003a98:	fc06                	sd	ra,56(sp)
    80003a9a:	f822                	sd	s0,48(sp)
    80003a9c:	f426                	sd	s1,40(sp)
    80003a9e:	f04a                	sd	s2,32(sp)
    80003aa0:	ec4e                	sd	s3,24(sp)
    80003aa2:	e852                	sd	s4,16(sp)
    80003aa4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003aa6:	04451703          	lh	a4,68(a0)
    80003aaa:	4785                	li	a5,1
    80003aac:	00f71a63          	bne	a4,a5,80003ac0 <dirlookup+0x2a>
    80003ab0:	892a                	mv	s2,a0
    80003ab2:	89ae                	mv	s3,a1
    80003ab4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ab6:	457c                	lw	a5,76(a0)
    80003ab8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003aba:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003abc:	e39d                	bnez	a5,80003ae2 <dirlookup+0x4c>
    80003abe:	a095                	j	80003b22 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003ac0:	00004517          	auipc	a0,0x4
    80003ac4:	b9850513          	addi	a0,a0,-1128 # 80007658 <etext+0x658>
    80003ac8:	ccdfc0ef          	jal	80000794 <panic>
      panic("dirlookup read");
    80003acc:	00004517          	auipc	a0,0x4
    80003ad0:	ba450513          	addi	a0,a0,-1116 # 80007670 <etext+0x670>
    80003ad4:	cc1fc0ef          	jal	80000794 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ad8:	24c1                	addiw	s1,s1,16
    80003ada:	04c92783          	lw	a5,76(s2)
    80003ade:	04f4f163          	bgeu	s1,a5,80003b20 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ae2:	4741                	li	a4,16
    80003ae4:	86a6                	mv	a3,s1
    80003ae6:	fc040613          	addi	a2,s0,-64
    80003aea:	4581                	li	a1,0
    80003aec:	854a                	mv	a0,s2
    80003aee:	d89ff0ef          	jal	80003876 <readi>
    80003af2:	47c1                	li	a5,16
    80003af4:	fcf51ce3          	bne	a0,a5,80003acc <dirlookup+0x36>
    if(de.inum == 0)
    80003af8:	fc045783          	lhu	a5,-64(s0)
    80003afc:	dff1                	beqz	a5,80003ad8 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003afe:	fc240593          	addi	a1,s0,-62
    80003b02:	854e                	mv	a0,s3
    80003b04:	f7dff0ef          	jal	80003a80 <namecmp>
    80003b08:	f961                	bnez	a0,80003ad8 <dirlookup+0x42>
      if(poff)
    80003b0a:	000a0463          	beqz	s4,80003b12 <dirlookup+0x7c>
        *poff = off;
    80003b0e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003b12:	fc045583          	lhu	a1,-64(s0)
    80003b16:	00092503          	lw	a0,0(s2)
    80003b1a:	829ff0ef          	jal	80003342 <iget>
    80003b1e:	a011                	j	80003b22 <dirlookup+0x8c>
  return 0;
    80003b20:	4501                	li	a0,0
}
    80003b22:	70e2                	ld	ra,56(sp)
    80003b24:	7442                	ld	s0,48(sp)
    80003b26:	74a2                	ld	s1,40(sp)
    80003b28:	7902                	ld	s2,32(sp)
    80003b2a:	69e2                	ld	s3,24(sp)
    80003b2c:	6a42                	ld	s4,16(sp)
    80003b2e:	6121                	addi	sp,sp,64
    80003b30:	8082                	ret

0000000080003b32 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003b32:	711d                	addi	sp,sp,-96
    80003b34:	ec86                	sd	ra,88(sp)
    80003b36:	e8a2                	sd	s0,80(sp)
    80003b38:	e4a6                	sd	s1,72(sp)
    80003b3a:	e0ca                	sd	s2,64(sp)
    80003b3c:	fc4e                	sd	s3,56(sp)
    80003b3e:	f852                	sd	s4,48(sp)
    80003b40:	f456                	sd	s5,40(sp)
    80003b42:	f05a                	sd	s6,32(sp)
    80003b44:	ec5e                	sd	s7,24(sp)
    80003b46:	e862                	sd	s8,16(sp)
    80003b48:	e466                	sd	s9,8(sp)
    80003b4a:	1080                	addi	s0,sp,96
    80003b4c:	84aa                	mv	s1,a0
    80003b4e:	8b2e                	mv	s6,a1
    80003b50:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003b52:	00054703          	lbu	a4,0(a0)
    80003b56:	02f00793          	li	a5,47
    80003b5a:	00f70e63          	beq	a4,a5,80003b76 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003b5e:	d03fd0ef          	jal	80001860 <myproc>
    80003b62:	69853503          	ld	a0,1688(a0)
    80003b66:	a87ff0ef          	jal	800035ec <idup>
    80003b6a:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003b6c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003b70:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003b72:	4b85                	li	s7,1
    80003b74:	a871                	j	80003c10 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003b76:	4585                	li	a1,1
    80003b78:	4505                	li	a0,1
    80003b7a:	fc8ff0ef          	jal	80003342 <iget>
    80003b7e:	8a2a                	mv	s4,a0
    80003b80:	b7f5                	j	80003b6c <namex+0x3a>
      iunlockput(ip);
    80003b82:	8552                	mv	a0,s4
    80003b84:	ca9ff0ef          	jal	8000382c <iunlockput>
      return 0;
    80003b88:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003b8a:	8552                	mv	a0,s4
    80003b8c:	60e6                	ld	ra,88(sp)
    80003b8e:	6446                	ld	s0,80(sp)
    80003b90:	64a6                	ld	s1,72(sp)
    80003b92:	6906                	ld	s2,64(sp)
    80003b94:	79e2                	ld	s3,56(sp)
    80003b96:	7a42                	ld	s4,48(sp)
    80003b98:	7aa2                	ld	s5,40(sp)
    80003b9a:	7b02                	ld	s6,32(sp)
    80003b9c:	6be2                	ld	s7,24(sp)
    80003b9e:	6c42                	ld	s8,16(sp)
    80003ba0:	6ca2                	ld	s9,8(sp)
    80003ba2:	6125                	addi	sp,sp,96
    80003ba4:	8082                	ret
      iunlock(ip);
    80003ba6:	8552                	mv	a0,s4
    80003ba8:	b29ff0ef          	jal	800036d0 <iunlock>
      return ip;
    80003bac:	bff9                	j	80003b8a <namex+0x58>
      iunlockput(ip);
    80003bae:	8552                	mv	a0,s4
    80003bb0:	c7dff0ef          	jal	8000382c <iunlockput>
      return 0;
    80003bb4:	8a4e                	mv	s4,s3
    80003bb6:	bfd1                	j	80003b8a <namex+0x58>
  len = path - s;
    80003bb8:	40998633          	sub	a2,s3,s1
    80003bbc:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003bc0:	099c5063          	bge	s8,s9,80003c40 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003bc4:	4639                	li	a2,14
    80003bc6:	85a6                	mv	a1,s1
    80003bc8:	8556                	mv	a0,s5
    80003bca:	95afd0ef          	jal	80000d24 <memmove>
    80003bce:	84ce                	mv	s1,s3
  while(*path == '/')
    80003bd0:	0004c783          	lbu	a5,0(s1)
    80003bd4:	01279763          	bne	a5,s2,80003be2 <namex+0xb0>
    path++;
    80003bd8:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003bda:	0004c783          	lbu	a5,0(s1)
    80003bde:	ff278de3          	beq	a5,s2,80003bd8 <namex+0xa6>
    ilock(ip);
    80003be2:	8552                	mv	a0,s4
    80003be4:	a3fff0ef          	jal	80003622 <ilock>
    if(ip->type != T_DIR){
    80003be8:	044a1783          	lh	a5,68(s4)
    80003bec:	f9779be3          	bne	a5,s7,80003b82 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003bf0:	000b0563          	beqz	s6,80003bfa <namex+0xc8>
    80003bf4:	0004c783          	lbu	a5,0(s1)
    80003bf8:	d7dd                	beqz	a5,80003ba6 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003bfa:	4601                	li	a2,0
    80003bfc:	85d6                	mv	a1,s5
    80003bfe:	8552                	mv	a0,s4
    80003c00:	e97ff0ef          	jal	80003a96 <dirlookup>
    80003c04:	89aa                	mv	s3,a0
    80003c06:	d545                	beqz	a0,80003bae <namex+0x7c>
    iunlockput(ip);
    80003c08:	8552                	mv	a0,s4
    80003c0a:	c23ff0ef          	jal	8000382c <iunlockput>
    ip = next;
    80003c0e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003c10:	0004c783          	lbu	a5,0(s1)
    80003c14:	01279763          	bne	a5,s2,80003c22 <namex+0xf0>
    path++;
    80003c18:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003c1a:	0004c783          	lbu	a5,0(s1)
    80003c1e:	ff278de3          	beq	a5,s2,80003c18 <namex+0xe6>
  if(*path == 0)
    80003c22:	cb8d                	beqz	a5,80003c54 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003c24:	0004c783          	lbu	a5,0(s1)
    80003c28:	89a6                	mv	s3,s1
  len = path - s;
    80003c2a:	4c81                	li	s9,0
    80003c2c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003c2e:	01278963          	beq	a5,s2,80003c40 <namex+0x10e>
    80003c32:	d3d9                	beqz	a5,80003bb8 <namex+0x86>
    path++;
    80003c34:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003c36:	0009c783          	lbu	a5,0(s3)
    80003c3a:	ff279ce3          	bne	a5,s2,80003c32 <namex+0x100>
    80003c3e:	bfad                	j	80003bb8 <namex+0x86>
    memmove(name, s, len);
    80003c40:	2601                	sext.w	a2,a2
    80003c42:	85a6                	mv	a1,s1
    80003c44:	8556                	mv	a0,s5
    80003c46:	8defd0ef          	jal	80000d24 <memmove>
    name[len] = 0;
    80003c4a:	9cd6                	add	s9,s9,s5
    80003c4c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003c50:	84ce                	mv	s1,s3
    80003c52:	bfbd                	j	80003bd0 <namex+0x9e>
  if(nameiparent){
    80003c54:	f20b0be3          	beqz	s6,80003b8a <namex+0x58>
    iput(ip);
    80003c58:	8552                	mv	a0,s4
    80003c5a:	b4bff0ef          	jal	800037a4 <iput>
    return 0;
    80003c5e:	4a01                	li	s4,0
    80003c60:	b72d                	j	80003b8a <namex+0x58>

0000000080003c62 <dirlink>:
{
    80003c62:	7139                	addi	sp,sp,-64
    80003c64:	fc06                	sd	ra,56(sp)
    80003c66:	f822                	sd	s0,48(sp)
    80003c68:	f04a                	sd	s2,32(sp)
    80003c6a:	ec4e                	sd	s3,24(sp)
    80003c6c:	e852                	sd	s4,16(sp)
    80003c6e:	0080                	addi	s0,sp,64
    80003c70:	892a                	mv	s2,a0
    80003c72:	8a2e                	mv	s4,a1
    80003c74:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003c76:	4601                	li	a2,0
    80003c78:	e1fff0ef          	jal	80003a96 <dirlookup>
    80003c7c:	e535                	bnez	a0,80003ce8 <dirlink+0x86>
    80003c7e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c80:	04c92483          	lw	s1,76(s2)
    80003c84:	c48d                	beqz	s1,80003cae <dirlink+0x4c>
    80003c86:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c88:	4741                	li	a4,16
    80003c8a:	86a6                	mv	a3,s1
    80003c8c:	fc040613          	addi	a2,s0,-64
    80003c90:	4581                	li	a1,0
    80003c92:	854a                	mv	a0,s2
    80003c94:	be3ff0ef          	jal	80003876 <readi>
    80003c98:	47c1                	li	a5,16
    80003c9a:	04f51b63          	bne	a0,a5,80003cf0 <dirlink+0x8e>
    if(de.inum == 0)
    80003c9e:	fc045783          	lhu	a5,-64(s0)
    80003ca2:	c791                	beqz	a5,80003cae <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ca4:	24c1                	addiw	s1,s1,16
    80003ca6:	04c92783          	lw	a5,76(s2)
    80003caa:	fcf4efe3          	bltu	s1,a5,80003c88 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003cae:	4639                	li	a2,14
    80003cb0:	85d2                	mv	a1,s4
    80003cb2:	fc240513          	addi	a0,s0,-62
    80003cb6:	914fd0ef          	jal	80000dca <strncpy>
  de.inum = inum;
    80003cba:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cbe:	4741                	li	a4,16
    80003cc0:	86a6                	mv	a3,s1
    80003cc2:	fc040613          	addi	a2,s0,-64
    80003cc6:	4581                	li	a1,0
    80003cc8:	854a                	mv	a0,s2
    80003cca:	ca9ff0ef          	jal	80003972 <writei>
    80003cce:	1541                	addi	a0,a0,-16
    80003cd0:	00a03533          	snez	a0,a0
    80003cd4:	40a00533          	neg	a0,a0
    80003cd8:	74a2                	ld	s1,40(sp)
}
    80003cda:	70e2                	ld	ra,56(sp)
    80003cdc:	7442                	ld	s0,48(sp)
    80003cde:	7902                	ld	s2,32(sp)
    80003ce0:	69e2                	ld	s3,24(sp)
    80003ce2:	6a42                	ld	s4,16(sp)
    80003ce4:	6121                	addi	sp,sp,64
    80003ce6:	8082                	ret
    iput(ip);
    80003ce8:	abdff0ef          	jal	800037a4 <iput>
    return -1;
    80003cec:	557d                	li	a0,-1
    80003cee:	b7f5                	j	80003cda <dirlink+0x78>
      panic("dirlink read");
    80003cf0:	00004517          	auipc	a0,0x4
    80003cf4:	99050513          	addi	a0,a0,-1648 # 80007680 <etext+0x680>
    80003cf8:	a9dfc0ef          	jal	80000794 <panic>

0000000080003cfc <namei>:

struct inode*
namei(char *path)
{
    80003cfc:	1101                	addi	sp,sp,-32
    80003cfe:	ec06                	sd	ra,24(sp)
    80003d00:	e822                	sd	s0,16(sp)
    80003d02:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003d04:	fe040613          	addi	a2,s0,-32
    80003d08:	4581                	li	a1,0
    80003d0a:	e29ff0ef          	jal	80003b32 <namex>
}
    80003d0e:	60e2                	ld	ra,24(sp)
    80003d10:	6442                	ld	s0,16(sp)
    80003d12:	6105                	addi	sp,sp,32
    80003d14:	8082                	ret

0000000080003d16 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003d16:	1141                	addi	sp,sp,-16
    80003d18:	e406                	sd	ra,8(sp)
    80003d1a:	e022                	sd	s0,0(sp)
    80003d1c:	0800                	addi	s0,sp,16
    80003d1e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003d20:	4585                	li	a1,1
    80003d22:	e11ff0ef          	jal	80003b32 <namex>
}
    80003d26:	60a2                	ld	ra,8(sp)
    80003d28:	6402                	ld	s0,0(sp)
    80003d2a:	0141                	addi	sp,sp,16
    80003d2c:	8082                	ret

0000000080003d2e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003d2e:	1101                	addi	sp,sp,-32
    80003d30:	ec06                	sd	ra,24(sp)
    80003d32:	e822                	sd	s0,16(sp)
    80003d34:	e426                	sd	s1,8(sp)
    80003d36:	e04a                	sd	s2,0(sp)
    80003d38:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003d3a:	00034917          	auipc	s2,0x34
    80003d3e:	06e90913          	addi	s2,s2,110 # 80037da8 <log>
    80003d42:	01892583          	lw	a1,24(s2)
    80003d46:	02892503          	lw	a0,40(s2)
    80003d4a:	9a0ff0ef          	jal	80002eea <bread>
    80003d4e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003d50:	02c92603          	lw	a2,44(s2)
    80003d54:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003d56:	00c05f63          	blez	a2,80003d74 <write_head+0x46>
    80003d5a:	00034717          	auipc	a4,0x34
    80003d5e:	07e70713          	addi	a4,a4,126 # 80037dd8 <log+0x30>
    80003d62:	87aa                	mv	a5,a0
    80003d64:	060a                	slli	a2,a2,0x2
    80003d66:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003d68:	4314                	lw	a3,0(a4)
    80003d6a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003d6c:	0711                	addi	a4,a4,4
    80003d6e:	0791                	addi	a5,a5,4
    80003d70:	fec79ce3          	bne	a5,a2,80003d68 <write_head+0x3a>
  }
  bwrite(buf);
    80003d74:	8526                	mv	a0,s1
    80003d76:	a4aff0ef          	jal	80002fc0 <bwrite>
  brelse(buf);
    80003d7a:	8526                	mv	a0,s1
    80003d7c:	a76ff0ef          	jal	80002ff2 <brelse>
}
    80003d80:	60e2                	ld	ra,24(sp)
    80003d82:	6442                	ld	s0,16(sp)
    80003d84:	64a2                	ld	s1,8(sp)
    80003d86:	6902                	ld	s2,0(sp)
    80003d88:	6105                	addi	sp,sp,32
    80003d8a:	8082                	ret

0000000080003d8c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d8c:	00034797          	auipc	a5,0x34
    80003d90:	0487a783          	lw	a5,72(a5) # 80037dd4 <log+0x2c>
    80003d94:	08f05f63          	blez	a5,80003e32 <install_trans+0xa6>
{
    80003d98:	7139                	addi	sp,sp,-64
    80003d9a:	fc06                	sd	ra,56(sp)
    80003d9c:	f822                	sd	s0,48(sp)
    80003d9e:	f426                	sd	s1,40(sp)
    80003da0:	f04a                	sd	s2,32(sp)
    80003da2:	ec4e                	sd	s3,24(sp)
    80003da4:	e852                	sd	s4,16(sp)
    80003da6:	e456                	sd	s5,8(sp)
    80003da8:	e05a                	sd	s6,0(sp)
    80003daa:	0080                	addi	s0,sp,64
    80003dac:	8b2a                	mv	s6,a0
    80003dae:	00034a97          	auipc	s5,0x34
    80003db2:	02aa8a93          	addi	s5,s5,42 # 80037dd8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003db6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003db8:	00034997          	auipc	s3,0x34
    80003dbc:	ff098993          	addi	s3,s3,-16 # 80037da8 <log>
    80003dc0:	a829                	j	80003dda <install_trans+0x4e>
    brelse(lbuf);
    80003dc2:	854a                	mv	a0,s2
    80003dc4:	a2eff0ef          	jal	80002ff2 <brelse>
    brelse(dbuf);
    80003dc8:	8526                	mv	a0,s1
    80003dca:	a28ff0ef          	jal	80002ff2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003dce:	2a05                	addiw	s4,s4,1
    80003dd0:	0a91                	addi	s5,s5,4
    80003dd2:	02c9a783          	lw	a5,44(s3)
    80003dd6:	04fa5463          	bge	s4,a5,80003e1e <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003dda:	0189a583          	lw	a1,24(s3)
    80003dde:	014585bb          	addw	a1,a1,s4
    80003de2:	2585                	addiw	a1,a1,1
    80003de4:	0289a503          	lw	a0,40(s3)
    80003de8:	902ff0ef          	jal	80002eea <bread>
    80003dec:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003dee:	000aa583          	lw	a1,0(s5)
    80003df2:	0289a503          	lw	a0,40(s3)
    80003df6:	8f4ff0ef          	jal	80002eea <bread>
    80003dfa:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003dfc:	40000613          	li	a2,1024
    80003e00:	05890593          	addi	a1,s2,88
    80003e04:	05850513          	addi	a0,a0,88
    80003e08:	f1dfc0ef          	jal	80000d24 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003e0c:	8526                	mv	a0,s1
    80003e0e:	9b2ff0ef          	jal	80002fc0 <bwrite>
    if(recovering == 0)
    80003e12:	fa0b18e3          	bnez	s6,80003dc2 <install_trans+0x36>
      bunpin(dbuf);
    80003e16:	8526                	mv	a0,s1
    80003e18:	a96ff0ef          	jal	800030ae <bunpin>
    80003e1c:	b75d                	j	80003dc2 <install_trans+0x36>
}
    80003e1e:	70e2                	ld	ra,56(sp)
    80003e20:	7442                	ld	s0,48(sp)
    80003e22:	74a2                	ld	s1,40(sp)
    80003e24:	7902                	ld	s2,32(sp)
    80003e26:	69e2                	ld	s3,24(sp)
    80003e28:	6a42                	ld	s4,16(sp)
    80003e2a:	6aa2                	ld	s5,8(sp)
    80003e2c:	6b02                	ld	s6,0(sp)
    80003e2e:	6121                	addi	sp,sp,64
    80003e30:	8082                	ret
    80003e32:	8082                	ret

0000000080003e34 <initlog>:
{
    80003e34:	7179                	addi	sp,sp,-48
    80003e36:	f406                	sd	ra,40(sp)
    80003e38:	f022                	sd	s0,32(sp)
    80003e3a:	ec26                	sd	s1,24(sp)
    80003e3c:	e84a                	sd	s2,16(sp)
    80003e3e:	e44e                	sd	s3,8(sp)
    80003e40:	1800                	addi	s0,sp,48
    80003e42:	892a                	mv	s2,a0
    80003e44:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003e46:	00034497          	auipc	s1,0x34
    80003e4a:	f6248493          	addi	s1,s1,-158 # 80037da8 <log>
    80003e4e:	00004597          	auipc	a1,0x4
    80003e52:	84258593          	addi	a1,a1,-1982 # 80007690 <etext+0x690>
    80003e56:	8526                	mv	a0,s1
    80003e58:	d1dfc0ef          	jal	80000b74 <initlock>
  log.start = sb->logstart;
    80003e5c:	0149a583          	lw	a1,20(s3)
    80003e60:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003e62:	0109a783          	lw	a5,16(s3)
    80003e66:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003e68:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003e6c:	854a                	mv	a0,s2
    80003e6e:	87cff0ef          	jal	80002eea <bread>
  log.lh.n = lh->n;
    80003e72:	4d30                	lw	a2,88(a0)
    80003e74:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003e76:	00c05f63          	blez	a2,80003e94 <initlog+0x60>
    80003e7a:	87aa                	mv	a5,a0
    80003e7c:	00034717          	auipc	a4,0x34
    80003e80:	f5c70713          	addi	a4,a4,-164 # 80037dd8 <log+0x30>
    80003e84:	060a                	slli	a2,a2,0x2
    80003e86:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003e88:	4ff4                	lw	a3,92(a5)
    80003e8a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003e8c:	0791                	addi	a5,a5,4
    80003e8e:	0711                	addi	a4,a4,4
    80003e90:	fec79ce3          	bne	a5,a2,80003e88 <initlog+0x54>
  brelse(buf);
    80003e94:	95eff0ef          	jal	80002ff2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003e98:	4505                	li	a0,1
    80003e9a:	ef3ff0ef          	jal	80003d8c <install_trans>
  log.lh.n = 0;
    80003e9e:	00034797          	auipc	a5,0x34
    80003ea2:	f207ab23          	sw	zero,-202(a5) # 80037dd4 <log+0x2c>
  write_head(); // clear the log
    80003ea6:	e89ff0ef          	jal	80003d2e <write_head>
}
    80003eaa:	70a2                	ld	ra,40(sp)
    80003eac:	7402                	ld	s0,32(sp)
    80003eae:	64e2                	ld	s1,24(sp)
    80003eb0:	6942                	ld	s2,16(sp)
    80003eb2:	69a2                	ld	s3,8(sp)
    80003eb4:	6145                	addi	sp,sp,48
    80003eb6:	8082                	ret

0000000080003eb8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003eb8:	1101                	addi	sp,sp,-32
    80003eba:	ec06                	sd	ra,24(sp)
    80003ebc:	e822                	sd	s0,16(sp)
    80003ebe:	e426                	sd	s1,8(sp)
    80003ec0:	e04a                	sd	s2,0(sp)
    80003ec2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003ec4:	00034517          	auipc	a0,0x34
    80003ec8:	ee450513          	addi	a0,a0,-284 # 80037da8 <log>
    80003ecc:	d29fc0ef          	jal	80000bf4 <acquire>
  while(1){
    if(log.committing){
    80003ed0:	00034497          	auipc	s1,0x34
    80003ed4:	ed848493          	addi	s1,s1,-296 # 80037da8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ed8:	4979                	li	s2,30
    80003eda:	a029                	j	80003ee4 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003edc:	85a6                	mv	a1,s1
    80003ede:	8526                	mv	a0,s1
    80003ee0:	f89fd0ef          	jal	80001e68 <sleep>
    if(log.committing){
    80003ee4:	50dc                	lw	a5,36(s1)
    80003ee6:	fbfd                	bnez	a5,80003edc <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ee8:	5098                	lw	a4,32(s1)
    80003eea:	2705                	addiw	a4,a4,1
    80003eec:	0027179b          	slliw	a5,a4,0x2
    80003ef0:	9fb9                	addw	a5,a5,a4
    80003ef2:	0017979b          	slliw	a5,a5,0x1
    80003ef6:	54d4                	lw	a3,44(s1)
    80003ef8:	9fb5                	addw	a5,a5,a3
    80003efa:	00f95763          	bge	s2,a5,80003f08 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003efe:	85a6                	mv	a1,s1
    80003f00:	8526                	mv	a0,s1
    80003f02:	f67fd0ef          	jal	80001e68 <sleep>
    80003f06:	bff9                	j	80003ee4 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003f08:	00034517          	auipc	a0,0x34
    80003f0c:	ea050513          	addi	a0,a0,-352 # 80037da8 <log>
    80003f10:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003f12:	d7bfc0ef          	jal	80000c8c <release>
      break;
    }
  }
}
    80003f16:	60e2                	ld	ra,24(sp)
    80003f18:	6442                	ld	s0,16(sp)
    80003f1a:	64a2                	ld	s1,8(sp)
    80003f1c:	6902                	ld	s2,0(sp)
    80003f1e:	6105                	addi	sp,sp,32
    80003f20:	8082                	ret

0000000080003f22 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003f22:	7139                	addi	sp,sp,-64
    80003f24:	fc06                	sd	ra,56(sp)
    80003f26:	f822                	sd	s0,48(sp)
    80003f28:	f426                	sd	s1,40(sp)
    80003f2a:	f04a                	sd	s2,32(sp)
    80003f2c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003f2e:	00034497          	auipc	s1,0x34
    80003f32:	e7a48493          	addi	s1,s1,-390 # 80037da8 <log>
    80003f36:	8526                	mv	a0,s1
    80003f38:	cbdfc0ef          	jal	80000bf4 <acquire>
  log.outstanding -= 1;
    80003f3c:	509c                	lw	a5,32(s1)
    80003f3e:	37fd                	addiw	a5,a5,-1
    80003f40:	0007891b          	sext.w	s2,a5
    80003f44:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003f46:	50dc                	lw	a5,36(s1)
    80003f48:	ef9d                	bnez	a5,80003f86 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003f4a:	04091763          	bnez	s2,80003f98 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003f4e:	00034497          	auipc	s1,0x34
    80003f52:	e5a48493          	addi	s1,s1,-422 # 80037da8 <log>
    80003f56:	4785                	li	a5,1
    80003f58:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003f5a:	8526                	mv	a0,s1
    80003f5c:	d31fc0ef          	jal	80000c8c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003f60:	54dc                	lw	a5,44(s1)
    80003f62:	04f04b63          	bgtz	a5,80003fb8 <end_op+0x96>
    acquire(&log.lock);
    80003f66:	00034497          	auipc	s1,0x34
    80003f6a:	e4248493          	addi	s1,s1,-446 # 80037da8 <log>
    80003f6e:	8526                	mv	a0,s1
    80003f70:	c85fc0ef          	jal	80000bf4 <acquire>
    log.committing = 0;
    80003f74:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003f78:	8526                	mv	a0,s1
    80003f7a:	f3dfd0ef          	jal	80001eb6 <wakeup>
    release(&log.lock);
    80003f7e:	8526                	mv	a0,s1
    80003f80:	d0dfc0ef          	jal	80000c8c <release>
}
    80003f84:	a025                	j	80003fac <end_op+0x8a>
    80003f86:	ec4e                	sd	s3,24(sp)
    80003f88:	e852                	sd	s4,16(sp)
    80003f8a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003f8c:	00003517          	auipc	a0,0x3
    80003f90:	70c50513          	addi	a0,a0,1804 # 80007698 <etext+0x698>
    80003f94:	801fc0ef          	jal	80000794 <panic>
    wakeup(&log);
    80003f98:	00034497          	auipc	s1,0x34
    80003f9c:	e1048493          	addi	s1,s1,-496 # 80037da8 <log>
    80003fa0:	8526                	mv	a0,s1
    80003fa2:	f15fd0ef          	jal	80001eb6 <wakeup>
  release(&log.lock);
    80003fa6:	8526                	mv	a0,s1
    80003fa8:	ce5fc0ef          	jal	80000c8c <release>
}
    80003fac:	70e2                	ld	ra,56(sp)
    80003fae:	7442                	ld	s0,48(sp)
    80003fb0:	74a2                	ld	s1,40(sp)
    80003fb2:	7902                	ld	s2,32(sp)
    80003fb4:	6121                	addi	sp,sp,64
    80003fb6:	8082                	ret
    80003fb8:	ec4e                	sd	s3,24(sp)
    80003fba:	e852                	sd	s4,16(sp)
    80003fbc:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fbe:	00034a97          	auipc	s5,0x34
    80003fc2:	e1aa8a93          	addi	s5,s5,-486 # 80037dd8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003fc6:	00034a17          	auipc	s4,0x34
    80003fca:	de2a0a13          	addi	s4,s4,-542 # 80037da8 <log>
    80003fce:	018a2583          	lw	a1,24(s4)
    80003fd2:	012585bb          	addw	a1,a1,s2
    80003fd6:	2585                	addiw	a1,a1,1
    80003fd8:	028a2503          	lw	a0,40(s4)
    80003fdc:	f0ffe0ef          	jal	80002eea <bread>
    80003fe0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003fe2:	000aa583          	lw	a1,0(s5)
    80003fe6:	028a2503          	lw	a0,40(s4)
    80003fea:	f01fe0ef          	jal	80002eea <bread>
    80003fee:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003ff0:	40000613          	li	a2,1024
    80003ff4:	05850593          	addi	a1,a0,88
    80003ff8:	05848513          	addi	a0,s1,88
    80003ffc:	d29fc0ef          	jal	80000d24 <memmove>
    bwrite(to);  // write the log
    80004000:	8526                	mv	a0,s1
    80004002:	fbffe0ef          	jal	80002fc0 <bwrite>
    brelse(from);
    80004006:	854e                	mv	a0,s3
    80004008:	febfe0ef          	jal	80002ff2 <brelse>
    brelse(to);
    8000400c:	8526                	mv	a0,s1
    8000400e:	fe5fe0ef          	jal	80002ff2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004012:	2905                	addiw	s2,s2,1
    80004014:	0a91                	addi	s5,s5,4
    80004016:	02ca2783          	lw	a5,44(s4)
    8000401a:	faf94ae3          	blt	s2,a5,80003fce <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000401e:	d11ff0ef          	jal	80003d2e <write_head>
    install_trans(0); // Now install writes to home locations
    80004022:	4501                	li	a0,0
    80004024:	d69ff0ef          	jal	80003d8c <install_trans>
    log.lh.n = 0;
    80004028:	00034797          	auipc	a5,0x34
    8000402c:	da07a623          	sw	zero,-596(a5) # 80037dd4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004030:	cffff0ef          	jal	80003d2e <write_head>
    80004034:	69e2                	ld	s3,24(sp)
    80004036:	6a42                	ld	s4,16(sp)
    80004038:	6aa2                	ld	s5,8(sp)
    8000403a:	b735                	j	80003f66 <end_op+0x44>

000000008000403c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000403c:	1101                	addi	sp,sp,-32
    8000403e:	ec06                	sd	ra,24(sp)
    80004040:	e822                	sd	s0,16(sp)
    80004042:	e426                	sd	s1,8(sp)
    80004044:	e04a                	sd	s2,0(sp)
    80004046:	1000                	addi	s0,sp,32
    80004048:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000404a:	00034917          	auipc	s2,0x34
    8000404e:	d5e90913          	addi	s2,s2,-674 # 80037da8 <log>
    80004052:	854a                	mv	a0,s2
    80004054:	ba1fc0ef          	jal	80000bf4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004058:	02c92603          	lw	a2,44(s2)
    8000405c:	47f5                	li	a5,29
    8000405e:	06c7c363          	blt	a5,a2,800040c4 <log_write+0x88>
    80004062:	00034797          	auipc	a5,0x34
    80004066:	d627a783          	lw	a5,-670(a5) # 80037dc4 <log+0x1c>
    8000406a:	37fd                	addiw	a5,a5,-1
    8000406c:	04f65c63          	bge	a2,a5,800040c4 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004070:	00034797          	auipc	a5,0x34
    80004074:	d587a783          	lw	a5,-680(a5) # 80037dc8 <log+0x20>
    80004078:	04f05c63          	blez	a5,800040d0 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000407c:	4781                	li	a5,0
    8000407e:	04c05f63          	blez	a2,800040dc <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004082:	44cc                	lw	a1,12(s1)
    80004084:	00034717          	auipc	a4,0x34
    80004088:	d5470713          	addi	a4,a4,-684 # 80037dd8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000408c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000408e:	4314                	lw	a3,0(a4)
    80004090:	04b68663          	beq	a3,a1,800040dc <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80004094:	2785                	addiw	a5,a5,1
    80004096:	0711                	addi	a4,a4,4
    80004098:	fef61be3          	bne	a2,a5,8000408e <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000409c:	0621                	addi	a2,a2,8
    8000409e:	060a                	slli	a2,a2,0x2
    800040a0:	00034797          	auipc	a5,0x34
    800040a4:	d0878793          	addi	a5,a5,-760 # 80037da8 <log>
    800040a8:	97b2                	add	a5,a5,a2
    800040aa:	44d8                	lw	a4,12(s1)
    800040ac:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800040ae:	8526                	mv	a0,s1
    800040b0:	fcbfe0ef          	jal	8000307a <bpin>
    log.lh.n++;
    800040b4:	00034717          	auipc	a4,0x34
    800040b8:	cf470713          	addi	a4,a4,-780 # 80037da8 <log>
    800040bc:	575c                	lw	a5,44(a4)
    800040be:	2785                	addiw	a5,a5,1
    800040c0:	d75c                	sw	a5,44(a4)
    800040c2:	a80d                	j	800040f4 <log_write+0xb8>
    panic("too big a transaction");
    800040c4:	00003517          	auipc	a0,0x3
    800040c8:	5e450513          	addi	a0,a0,1508 # 800076a8 <etext+0x6a8>
    800040cc:	ec8fc0ef          	jal	80000794 <panic>
    panic("log_write outside of trans");
    800040d0:	00003517          	auipc	a0,0x3
    800040d4:	5f050513          	addi	a0,a0,1520 # 800076c0 <etext+0x6c0>
    800040d8:	ebcfc0ef          	jal	80000794 <panic>
  log.lh.block[i] = b->blockno;
    800040dc:	00878693          	addi	a3,a5,8
    800040e0:	068a                	slli	a3,a3,0x2
    800040e2:	00034717          	auipc	a4,0x34
    800040e6:	cc670713          	addi	a4,a4,-826 # 80037da8 <log>
    800040ea:	9736                	add	a4,a4,a3
    800040ec:	44d4                	lw	a3,12(s1)
    800040ee:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800040f0:	faf60fe3          	beq	a2,a5,800040ae <log_write+0x72>
  }
  release(&log.lock);
    800040f4:	00034517          	auipc	a0,0x34
    800040f8:	cb450513          	addi	a0,a0,-844 # 80037da8 <log>
    800040fc:	b91fc0ef          	jal	80000c8c <release>
}
    80004100:	60e2                	ld	ra,24(sp)
    80004102:	6442                	ld	s0,16(sp)
    80004104:	64a2                	ld	s1,8(sp)
    80004106:	6902                	ld	s2,0(sp)
    80004108:	6105                	addi	sp,sp,32
    8000410a:	8082                	ret

000000008000410c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000410c:	1101                	addi	sp,sp,-32
    8000410e:	ec06                	sd	ra,24(sp)
    80004110:	e822                	sd	s0,16(sp)
    80004112:	e426                	sd	s1,8(sp)
    80004114:	e04a                	sd	s2,0(sp)
    80004116:	1000                	addi	s0,sp,32
    80004118:	84aa                	mv	s1,a0
    8000411a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000411c:	00003597          	auipc	a1,0x3
    80004120:	5c458593          	addi	a1,a1,1476 # 800076e0 <etext+0x6e0>
    80004124:	0521                	addi	a0,a0,8
    80004126:	a4ffc0ef          	jal	80000b74 <initlock>
  lk->name = name;
    8000412a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000412e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004132:	0204a423          	sw	zero,40(s1)
}
    80004136:	60e2                	ld	ra,24(sp)
    80004138:	6442                	ld	s0,16(sp)
    8000413a:	64a2                	ld	s1,8(sp)
    8000413c:	6902                	ld	s2,0(sp)
    8000413e:	6105                	addi	sp,sp,32
    80004140:	8082                	ret

0000000080004142 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004142:	1101                	addi	sp,sp,-32
    80004144:	ec06                	sd	ra,24(sp)
    80004146:	e822                	sd	s0,16(sp)
    80004148:	e426                	sd	s1,8(sp)
    8000414a:	e04a                	sd	s2,0(sp)
    8000414c:	1000                	addi	s0,sp,32
    8000414e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004150:	00850913          	addi	s2,a0,8
    80004154:	854a                	mv	a0,s2
    80004156:	a9ffc0ef          	jal	80000bf4 <acquire>
  while (lk->locked) {
    8000415a:	409c                	lw	a5,0(s1)
    8000415c:	c799                	beqz	a5,8000416a <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000415e:	85ca                	mv	a1,s2
    80004160:	8526                	mv	a0,s1
    80004162:	d07fd0ef          	jal	80001e68 <sleep>
  while (lk->locked) {
    80004166:	409c                	lw	a5,0(s1)
    80004168:	fbfd                	bnez	a5,8000415e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000416a:	4785                	li	a5,1
    8000416c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000416e:	ef2fd0ef          	jal	80001860 <myproc>
    80004172:	57852783          	lw	a5,1400(a0)
    80004176:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004178:	854a                	mv	a0,s2
    8000417a:	b13fc0ef          	jal	80000c8c <release>
}
    8000417e:	60e2                	ld	ra,24(sp)
    80004180:	6442                	ld	s0,16(sp)
    80004182:	64a2                	ld	s1,8(sp)
    80004184:	6902                	ld	s2,0(sp)
    80004186:	6105                	addi	sp,sp,32
    80004188:	8082                	ret

000000008000418a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000418a:	1101                	addi	sp,sp,-32
    8000418c:	ec06                	sd	ra,24(sp)
    8000418e:	e822                	sd	s0,16(sp)
    80004190:	e426                	sd	s1,8(sp)
    80004192:	e04a                	sd	s2,0(sp)
    80004194:	1000                	addi	s0,sp,32
    80004196:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004198:	00850913          	addi	s2,a0,8
    8000419c:	854a                	mv	a0,s2
    8000419e:	a57fc0ef          	jal	80000bf4 <acquire>
  lk->locked = 0;
    800041a2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800041a6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800041aa:	8526                	mv	a0,s1
    800041ac:	d0bfd0ef          	jal	80001eb6 <wakeup>
  release(&lk->lk);
    800041b0:	854a                	mv	a0,s2
    800041b2:	adbfc0ef          	jal	80000c8c <release>
}
    800041b6:	60e2                	ld	ra,24(sp)
    800041b8:	6442                	ld	s0,16(sp)
    800041ba:	64a2                	ld	s1,8(sp)
    800041bc:	6902                	ld	s2,0(sp)
    800041be:	6105                	addi	sp,sp,32
    800041c0:	8082                	ret

00000000800041c2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800041c2:	7179                	addi	sp,sp,-48
    800041c4:	f406                	sd	ra,40(sp)
    800041c6:	f022                	sd	s0,32(sp)
    800041c8:	ec26                	sd	s1,24(sp)
    800041ca:	e84a                	sd	s2,16(sp)
    800041cc:	1800                	addi	s0,sp,48
    800041ce:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800041d0:	00850913          	addi	s2,a0,8
    800041d4:	854a                	mv	a0,s2
    800041d6:	a1ffc0ef          	jal	80000bf4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800041da:	409c                	lw	a5,0(s1)
    800041dc:	ef81                	bnez	a5,800041f4 <holdingsleep+0x32>
    800041de:	4481                	li	s1,0
  release(&lk->lk);
    800041e0:	854a                	mv	a0,s2
    800041e2:	aabfc0ef          	jal	80000c8c <release>
  return r;
}
    800041e6:	8526                	mv	a0,s1
    800041e8:	70a2                	ld	ra,40(sp)
    800041ea:	7402                	ld	s0,32(sp)
    800041ec:	64e2                	ld	s1,24(sp)
    800041ee:	6942                	ld	s2,16(sp)
    800041f0:	6145                	addi	sp,sp,48
    800041f2:	8082                	ret
    800041f4:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800041f6:	0284a983          	lw	s3,40(s1)
    800041fa:	e66fd0ef          	jal	80001860 <myproc>
    800041fe:	57852483          	lw	s1,1400(a0)
    80004202:	413484b3          	sub	s1,s1,s3
    80004206:	0014b493          	seqz	s1,s1
    8000420a:	69a2                	ld	s3,8(sp)
    8000420c:	bfd1                	j	800041e0 <holdingsleep+0x1e>

000000008000420e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000420e:	1141                	addi	sp,sp,-16
    80004210:	e406                	sd	ra,8(sp)
    80004212:	e022                	sd	s0,0(sp)
    80004214:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004216:	00003597          	auipc	a1,0x3
    8000421a:	4da58593          	addi	a1,a1,1242 # 800076f0 <etext+0x6f0>
    8000421e:	00034517          	auipc	a0,0x34
    80004222:	cd250513          	addi	a0,a0,-814 # 80037ef0 <ftable>
    80004226:	94ffc0ef          	jal	80000b74 <initlock>
}
    8000422a:	60a2                	ld	ra,8(sp)
    8000422c:	6402                	ld	s0,0(sp)
    8000422e:	0141                	addi	sp,sp,16
    80004230:	8082                	ret

0000000080004232 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004232:	1101                	addi	sp,sp,-32
    80004234:	ec06                	sd	ra,24(sp)
    80004236:	e822                	sd	s0,16(sp)
    80004238:	e426                	sd	s1,8(sp)
    8000423a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000423c:	00034517          	auipc	a0,0x34
    80004240:	cb450513          	addi	a0,a0,-844 # 80037ef0 <ftable>
    80004244:	9b1fc0ef          	jal	80000bf4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004248:	00034497          	auipc	s1,0x34
    8000424c:	cc048493          	addi	s1,s1,-832 # 80037f08 <ftable+0x18>
    80004250:	00035717          	auipc	a4,0x35
    80004254:	c5870713          	addi	a4,a4,-936 # 80038ea8 <disk>
    if(f->ref == 0){
    80004258:	40dc                	lw	a5,4(s1)
    8000425a:	cf89                	beqz	a5,80004274 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000425c:	02848493          	addi	s1,s1,40
    80004260:	fee49ce3          	bne	s1,a4,80004258 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004264:	00034517          	auipc	a0,0x34
    80004268:	c8c50513          	addi	a0,a0,-884 # 80037ef0 <ftable>
    8000426c:	a21fc0ef          	jal	80000c8c <release>
  return 0;
    80004270:	4481                	li	s1,0
    80004272:	a809                	j	80004284 <filealloc+0x52>
      f->ref = 1;
    80004274:	4785                	li	a5,1
    80004276:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004278:	00034517          	auipc	a0,0x34
    8000427c:	c7850513          	addi	a0,a0,-904 # 80037ef0 <ftable>
    80004280:	a0dfc0ef          	jal	80000c8c <release>
}
    80004284:	8526                	mv	a0,s1
    80004286:	60e2                	ld	ra,24(sp)
    80004288:	6442                	ld	s0,16(sp)
    8000428a:	64a2                	ld	s1,8(sp)
    8000428c:	6105                	addi	sp,sp,32
    8000428e:	8082                	ret

0000000080004290 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004290:	1101                	addi	sp,sp,-32
    80004292:	ec06                	sd	ra,24(sp)
    80004294:	e822                	sd	s0,16(sp)
    80004296:	e426                	sd	s1,8(sp)
    80004298:	1000                	addi	s0,sp,32
    8000429a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000429c:	00034517          	auipc	a0,0x34
    800042a0:	c5450513          	addi	a0,a0,-940 # 80037ef0 <ftable>
    800042a4:	951fc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    800042a8:	40dc                	lw	a5,4(s1)
    800042aa:	02f05063          	blez	a5,800042ca <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800042ae:	2785                	addiw	a5,a5,1
    800042b0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800042b2:	00034517          	auipc	a0,0x34
    800042b6:	c3e50513          	addi	a0,a0,-962 # 80037ef0 <ftable>
    800042ba:	9d3fc0ef          	jal	80000c8c <release>
  return f;
}
    800042be:	8526                	mv	a0,s1
    800042c0:	60e2                	ld	ra,24(sp)
    800042c2:	6442                	ld	s0,16(sp)
    800042c4:	64a2                	ld	s1,8(sp)
    800042c6:	6105                	addi	sp,sp,32
    800042c8:	8082                	ret
    panic("filedup");
    800042ca:	00003517          	auipc	a0,0x3
    800042ce:	42e50513          	addi	a0,a0,1070 # 800076f8 <etext+0x6f8>
    800042d2:	cc2fc0ef          	jal	80000794 <panic>

00000000800042d6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800042d6:	7139                	addi	sp,sp,-64
    800042d8:	fc06                	sd	ra,56(sp)
    800042da:	f822                	sd	s0,48(sp)
    800042dc:	f426                	sd	s1,40(sp)
    800042de:	0080                	addi	s0,sp,64
    800042e0:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800042e2:	00034517          	auipc	a0,0x34
    800042e6:	c0e50513          	addi	a0,a0,-1010 # 80037ef0 <ftable>
    800042ea:	90bfc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    800042ee:	40dc                	lw	a5,4(s1)
    800042f0:	04f05a63          	blez	a5,80004344 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800042f4:	37fd                	addiw	a5,a5,-1
    800042f6:	0007871b          	sext.w	a4,a5
    800042fa:	c0dc                	sw	a5,4(s1)
    800042fc:	04e04e63          	bgtz	a4,80004358 <fileclose+0x82>
    80004300:	f04a                	sd	s2,32(sp)
    80004302:	ec4e                	sd	s3,24(sp)
    80004304:	e852                	sd	s4,16(sp)
    80004306:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004308:	0004a903          	lw	s2,0(s1)
    8000430c:	0094ca83          	lbu	s5,9(s1)
    80004310:	0104ba03          	ld	s4,16(s1)
    80004314:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004318:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000431c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004320:	00034517          	auipc	a0,0x34
    80004324:	bd050513          	addi	a0,a0,-1072 # 80037ef0 <ftable>
    80004328:	965fc0ef          	jal	80000c8c <release>

  if(ff.type == FD_PIPE){
    8000432c:	4785                	li	a5,1
    8000432e:	04f90063          	beq	s2,a5,8000436e <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004332:	3979                	addiw	s2,s2,-2
    80004334:	4785                	li	a5,1
    80004336:	0527f563          	bgeu	a5,s2,80004380 <fileclose+0xaa>
    8000433a:	7902                	ld	s2,32(sp)
    8000433c:	69e2                	ld	s3,24(sp)
    8000433e:	6a42                	ld	s4,16(sp)
    80004340:	6aa2                	ld	s5,8(sp)
    80004342:	a00d                	j	80004364 <fileclose+0x8e>
    80004344:	f04a                	sd	s2,32(sp)
    80004346:	ec4e                	sd	s3,24(sp)
    80004348:	e852                	sd	s4,16(sp)
    8000434a:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000434c:	00003517          	auipc	a0,0x3
    80004350:	3b450513          	addi	a0,a0,948 # 80007700 <etext+0x700>
    80004354:	c40fc0ef          	jal	80000794 <panic>
    release(&ftable.lock);
    80004358:	00034517          	auipc	a0,0x34
    8000435c:	b9850513          	addi	a0,a0,-1128 # 80037ef0 <ftable>
    80004360:	92dfc0ef          	jal	80000c8c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004364:	70e2                	ld	ra,56(sp)
    80004366:	7442                	ld	s0,48(sp)
    80004368:	74a2                	ld	s1,40(sp)
    8000436a:	6121                	addi	sp,sp,64
    8000436c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000436e:	85d6                	mv	a1,s5
    80004370:	8552                	mv	a0,s4
    80004372:	336000ef          	jal	800046a8 <pipeclose>
    80004376:	7902                	ld	s2,32(sp)
    80004378:	69e2                	ld	s3,24(sp)
    8000437a:	6a42                	ld	s4,16(sp)
    8000437c:	6aa2                	ld	s5,8(sp)
    8000437e:	b7dd                	j	80004364 <fileclose+0x8e>
    begin_op();
    80004380:	b39ff0ef          	jal	80003eb8 <begin_op>
    iput(ff.ip);
    80004384:	854e                	mv	a0,s3
    80004386:	c1eff0ef          	jal	800037a4 <iput>
    end_op();
    8000438a:	b99ff0ef          	jal	80003f22 <end_op>
    8000438e:	7902                	ld	s2,32(sp)
    80004390:	69e2                	ld	s3,24(sp)
    80004392:	6a42                	ld	s4,16(sp)
    80004394:	6aa2                	ld	s5,8(sp)
    80004396:	b7f9                	j	80004364 <fileclose+0x8e>

0000000080004398 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004398:	715d                	addi	sp,sp,-80
    8000439a:	e486                	sd	ra,72(sp)
    8000439c:	e0a2                	sd	s0,64(sp)
    8000439e:	fc26                	sd	s1,56(sp)
    800043a0:	f44e                	sd	s3,40(sp)
    800043a2:	0880                	addi	s0,sp,80
    800043a4:	84aa                	mv	s1,a0
    800043a6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800043a8:	cb8fd0ef          	jal	80001860 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800043ac:	409c                	lw	a5,0(s1)
    800043ae:	37f9                	addiw	a5,a5,-2
    800043b0:	4705                	li	a4,1
    800043b2:	04f76063          	bltu	a4,a5,800043f2 <filestat+0x5a>
    800043b6:	f84a                	sd	s2,48(sp)
    800043b8:	892a                	mv	s2,a0
    ilock(f->ip);
    800043ba:	6c88                	ld	a0,24(s1)
    800043bc:	a66ff0ef          	jal	80003622 <ilock>
    stati(f->ip, &st);
    800043c0:	fb840593          	addi	a1,s0,-72
    800043c4:	6c88                	ld	a0,24(s1)
    800043c6:	c86ff0ef          	jal	8000384c <stati>
    iunlock(f->ip);
    800043ca:	6c88                	ld	a0,24(s1)
    800043cc:	b04ff0ef          	jal	800036d0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800043d0:	46e1                	li	a3,24
    800043d2:	fb840613          	addi	a2,s0,-72
    800043d6:	85ce                	mv	a1,s3
    800043d8:	59893503          	ld	a0,1432(s2)
    800043dc:	976fd0ef          	jal	80001552 <copyout>
    800043e0:	41f5551b          	sraiw	a0,a0,0x1f
    800043e4:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800043e6:	60a6                	ld	ra,72(sp)
    800043e8:	6406                	ld	s0,64(sp)
    800043ea:	74e2                	ld	s1,56(sp)
    800043ec:	79a2                	ld	s3,40(sp)
    800043ee:	6161                	addi	sp,sp,80
    800043f0:	8082                	ret
  return -1;
    800043f2:	557d                	li	a0,-1
    800043f4:	bfcd                	j	800043e6 <filestat+0x4e>

00000000800043f6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800043f6:	7179                	addi	sp,sp,-48
    800043f8:	f406                	sd	ra,40(sp)
    800043fa:	f022                	sd	s0,32(sp)
    800043fc:	e84a                	sd	s2,16(sp)
    800043fe:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004400:	00854783          	lbu	a5,8(a0)
    80004404:	cfd1                	beqz	a5,800044a0 <fileread+0xaa>
    80004406:	ec26                	sd	s1,24(sp)
    80004408:	e44e                	sd	s3,8(sp)
    8000440a:	84aa                	mv	s1,a0
    8000440c:	89ae                	mv	s3,a1
    8000440e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004410:	411c                	lw	a5,0(a0)
    80004412:	4705                	li	a4,1
    80004414:	04e78363          	beq	a5,a4,8000445a <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004418:	470d                	li	a4,3
    8000441a:	04e78763          	beq	a5,a4,80004468 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000441e:	4709                	li	a4,2
    80004420:	06e79a63          	bne	a5,a4,80004494 <fileread+0x9e>
    ilock(f->ip);
    80004424:	6d08                	ld	a0,24(a0)
    80004426:	9fcff0ef          	jal	80003622 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000442a:	874a                	mv	a4,s2
    8000442c:	5094                	lw	a3,32(s1)
    8000442e:	864e                	mv	a2,s3
    80004430:	4585                	li	a1,1
    80004432:	6c88                	ld	a0,24(s1)
    80004434:	c42ff0ef          	jal	80003876 <readi>
    80004438:	892a                	mv	s2,a0
    8000443a:	00a05563          	blez	a0,80004444 <fileread+0x4e>
      f->off += r;
    8000443e:	509c                	lw	a5,32(s1)
    80004440:	9fa9                	addw	a5,a5,a0
    80004442:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004444:	6c88                	ld	a0,24(s1)
    80004446:	a8aff0ef          	jal	800036d0 <iunlock>
    8000444a:	64e2                	ld	s1,24(sp)
    8000444c:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000444e:	854a                	mv	a0,s2
    80004450:	70a2                	ld	ra,40(sp)
    80004452:	7402                	ld	s0,32(sp)
    80004454:	6942                	ld	s2,16(sp)
    80004456:	6145                	addi	sp,sp,48
    80004458:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000445a:	6908                	ld	a0,16(a0)
    8000445c:	388000ef          	jal	800047e4 <piperead>
    80004460:	892a                	mv	s2,a0
    80004462:	64e2                	ld	s1,24(sp)
    80004464:	69a2                	ld	s3,8(sp)
    80004466:	b7e5                	j	8000444e <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004468:	02451783          	lh	a5,36(a0)
    8000446c:	03079693          	slli	a3,a5,0x30
    80004470:	92c1                	srli	a3,a3,0x30
    80004472:	4725                	li	a4,9
    80004474:	02d76863          	bltu	a4,a3,800044a4 <fileread+0xae>
    80004478:	0792                	slli	a5,a5,0x4
    8000447a:	00034717          	auipc	a4,0x34
    8000447e:	9d670713          	addi	a4,a4,-1578 # 80037e50 <devsw>
    80004482:	97ba                	add	a5,a5,a4
    80004484:	639c                	ld	a5,0(a5)
    80004486:	c39d                	beqz	a5,800044ac <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004488:	4505                	li	a0,1
    8000448a:	9782                	jalr	a5
    8000448c:	892a                	mv	s2,a0
    8000448e:	64e2                	ld	s1,24(sp)
    80004490:	69a2                	ld	s3,8(sp)
    80004492:	bf75                	j	8000444e <fileread+0x58>
    panic("fileread");
    80004494:	00003517          	auipc	a0,0x3
    80004498:	27c50513          	addi	a0,a0,636 # 80007710 <etext+0x710>
    8000449c:	af8fc0ef          	jal	80000794 <panic>
    return -1;
    800044a0:	597d                	li	s2,-1
    800044a2:	b775                	j	8000444e <fileread+0x58>
      return -1;
    800044a4:	597d                	li	s2,-1
    800044a6:	64e2                	ld	s1,24(sp)
    800044a8:	69a2                	ld	s3,8(sp)
    800044aa:	b755                	j	8000444e <fileread+0x58>
    800044ac:	597d                	li	s2,-1
    800044ae:	64e2                	ld	s1,24(sp)
    800044b0:	69a2                	ld	s3,8(sp)
    800044b2:	bf71                	j	8000444e <fileread+0x58>

00000000800044b4 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800044b4:	00954783          	lbu	a5,9(a0)
    800044b8:	10078b63          	beqz	a5,800045ce <filewrite+0x11a>
{
    800044bc:	715d                	addi	sp,sp,-80
    800044be:	e486                	sd	ra,72(sp)
    800044c0:	e0a2                	sd	s0,64(sp)
    800044c2:	f84a                	sd	s2,48(sp)
    800044c4:	f052                	sd	s4,32(sp)
    800044c6:	e85a                	sd	s6,16(sp)
    800044c8:	0880                	addi	s0,sp,80
    800044ca:	892a                	mv	s2,a0
    800044cc:	8b2e                	mv	s6,a1
    800044ce:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800044d0:	411c                	lw	a5,0(a0)
    800044d2:	4705                	li	a4,1
    800044d4:	02e78763          	beq	a5,a4,80004502 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800044d8:	470d                	li	a4,3
    800044da:	02e78863          	beq	a5,a4,8000450a <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800044de:	4709                	li	a4,2
    800044e0:	0ce79c63          	bne	a5,a4,800045b8 <filewrite+0x104>
    800044e4:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800044e6:	0ac05863          	blez	a2,80004596 <filewrite+0xe2>
    800044ea:	fc26                	sd	s1,56(sp)
    800044ec:	ec56                	sd	s5,24(sp)
    800044ee:	e45e                	sd	s7,8(sp)
    800044f0:	e062                	sd	s8,0(sp)
    int i = 0;
    800044f2:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800044f4:	6b85                	lui	s7,0x1
    800044f6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800044fa:	6c05                	lui	s8,0x1
    800044fc:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004500:	a8b5                	j	8000457c <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80004502:	6908                	ld	a0,16(a0)
    80004504:	1fc000ef          	jal	80004700 <pipewrite>
    80004508:	a04d                	j	800045aa <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000450a:	02451783          	lh	a5,36(a0)
    8000450e:	03079693          	slli	a3,a5,0x30
    80004512:	92c1                	srli	a3,a3,0x30
    80004514:	4725                	li	a4,9
    80004516:	0ad76e63          	bltu	a4,a3,800045d2 <filewrite+0x11e>
    8000451a:	0792                	slli	a5,a5,0x4
    8000451c:	00034717          	auipc	a4,0x34
    80004520:	93470713          	addi	a4,a4,-1740 # 80037e50 <devsw>
    80004524:	97ba                	add	a5,a5,a4
    80004526:	679c                	ld	a5,8(a5)
    80004528:	c7dd                	beqz	a5,800045d6 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000452a:	4505                	li	a0,1
    8000452c:	9782                	jalr	a5
    8000452e:	a8b5                	j	800045aa <filewrite+0xf6>
      if(n1 > max)
    80004530:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004534:	985ff0ef          	jal	80003eb8 <begin_op>
      ilock(f->ip);
    80004538:	01893503          	ld	a0,24(s2)
    8000453c:	8e6ff0ef          	jal	80003622 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004540:	8756                	mv	a4,s5
    80004542:	02092683          	lw	a3,32(s2)
    80004546:	01698633          	add	a2,s3,s6
    8000454a:	4585                	li	a1,1
    8000454c:	01893503          	ld	a0,24(s2)
    80004550:	c22ff0ef          	jal	80003972 <writei>
    80004554:	84aa                	mv	s1,a0
    80004556:	00a05763          	blez	a0,80004564 <filewrite+0xb0>
        f->off += r;
    8000455a:	02092783          	lw	a5,32(s2)
    8000455e:	9fa9                	addw	a5,a5,a0
    80004560:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004564:	01893503          	ld	a0,24(s2)
    80004568:	968ff0ef          	jal	800036d0 <iunlock>
      end_op();
    8000456c:	9b7ff0ef          	jal	80003f22 <end_op>

      if(r != n1){
    80004570:	029a9563          	bne	s5,s1,8000459a <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004574:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004578:	0149da63          	bge	s3,s4,8000458c <filewrite+0xd8>
      int n1 = n - i;
    8000457c:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004580:	0004879b          	sext.w	a5,s1
    80004584:	fafbd6e3          	bge	s7,a5,80004530 <filewrite+0x7c>
    80004588:	84e2                	mv	s1,s8
    8000458a:	b75d                	j	80004530 <filewrite+0x7c>
    8000458c:	74e2                	ld	s1,56(sp)
    8000458e:	6ae2                	ld	s5,24(sp)
    80004590:	6ba2                	ld	s7,8(sp)
    80004592:	6c02                	ld	s8,0(sp)
    80004594:	a039                	j	800045a2 <filewrite+0xee>
    int i = 0;
    80004596:	4981                	li	s3,0
    80004598:	a029                	j	800045a2 <filewrite+0xee>
    8000459a:	74e2                	ld	s1,56(sp)
    8000459c:	6ae2                	ld	s5,24(sp)
    8000459e:	6ba2                	ld	s7,8(sp)
    800045a0:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800045a2:	033a1c63          	bne	s4,s3,800045da <filewrite+0x126>
    800045a6:	8552                	mv	a0,s4
    800045a8:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800045aa:	60a6                	ld	ra,72(sp)
    800045ac:	6406                	ld	s0,64(sp)
    800045ae:	7942                	ld	s2,48(sp)
    800045b0:	7a02                	ld	s4,32(sp)
    800045b2:	6b42                	ld	s6,16(sp)
    800045b4:	6161                	addi	sp,sp,80
    800045b6:	8082                	ret
    800045b8:	fc26                	sd	s1,56(sp)
    800045ba:	f44e                	sd	s3,40(sp)
    800045bc:	ec56                	sd	s5,24(sp)
    800045be:	e45e                	sd	s7,8(sp)
    800045c0:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800045c2:	00003517          	auipc	a0,0x3
    800045c6:	15e50513          	addi	a0,a0,350 # 80007720 <etext+0x720>
    800045ca:	9cafc0ef          	jal	80000794 <panic>
    return -1;
    800045ce:	557d                	li	a0,-1
}
    800045d0:	8082                	ret
      return -1;
    800045d2:	557d                	li	a0,-1
    800045d4:	bfd9                	j	800045aa <filewrite+0xf6>
    800045d6:	557d                	li	a0,-1
    800045d8:	bfc9                	j	800045aa <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800045da:	557d                	li	a0,-1
    800045dc:	79a2                	ld	s3,40(sp)
    800045de:	b7f1                	j	800045aa <filewrite+0xf6>

00000000800045e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800045e0:	7179                	addi	sp,sp,-48
    800045e2:	f406                	sd	ra,40(sp)
    800045e4:	f022                	sd	s0,32(sp)
    800045e6:	ec26                	sd	s1,24(sp)
    800045e8:	e052                	sd	s4,0(sp)
    800045ea:	1800                	addi	s0,sp,48
    800045ec:	84aa                	mv	s1,a0
    800045ee:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800045f0:	0005b023          	sd	zero,0(a1)
    800045f4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800045f8:	c3bff0ef          	jal	80004232 <filealloc>
    800045fc:	e088                	sd	a0,0(s1)
    800045fe:	c549                	beqz	a0,80004688 <pipealloc+0xa8>
    80004600:	c33ff0ef          	jal	80004232 <filealloc>
    80004604:	00aa3023          	sd	a0,0(s4)
    80004608:	cd25                	beqz	a0,80004680 <pipealloc+0xa0>
    8000460a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000460c:	d18fc0ef          	jal	80000b24 <kalloc>
    80004610:	892a                	mv	s2,a0
    80004612:	c12d                	beqz	a0,80004674 <pipealloc+0x94>
    80004614:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004616:	4985                	li	s3,1
    80004618:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000461c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004620:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004624:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004628:	00003597          	auipc	a1,0x3
    8000462c:	10858593          	addi	a1,a1,264 # 80007730 <etext+0x730>
    80004630:	d44fc0ef          	jal	80000b74 <initlock>
  (*f0)->type = FD_PIPE;
    80004634:	609c                	ld	a5,0(s1)
    80004636:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000463a:	609c                	ld	a5,0(s1)
    8000463c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004640:	609c                	ld	a5,0(s1)
    80004642:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004646:	609c                	ld	a5,0(s1)
    80004648:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000464c:	000a3783          	ld	a5,0(s4)
    80004650:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004654:	000a3783          	ld	a5,0(s4)
    80004658:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000465c:	000a3783          	ld	a5,0(s4)
    80004660:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004664:	000a3783          	ld	a5,0(s4)
    80004668:	0127b823          	sd	s2,16(a5)
  return 0;
    8000466c:	4501                	li	a0,0
    8000466e:	6942                	ld	s2,16(sp)
    80004670:	69a2                	ld	s3,8(sp)
    80004672:	a01d                	j	80004698 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004674:	6088                	ld	a0,0(s1)
    80004676:	c119                	beqz	a0,8000467c <pipealloc+0x9c>
    80004678:	6942                	ld	s2,16(sp)
    8000467a:	a029                	j	80004684 <pipealloc+0xa4>
    8000467c:	6942                	ld	s2,16(sp)
    8000467e:	a029                	j	80004688 <pipealloc+0xa8>
    80004680:	6088                	ld	a0,0(s1)
    80004682:	c10d                	beqz	a0,800046a4 <pipealloc+0xc4>
    fileclose(*f0);
    80004684:	c53ff0ef          	jal	800042d6 <fileclose>
  if(*f1)
    80004688:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000468c:	557d                	li	a0,-1
  if(*f1)
    8000468e:	c789                	beqz	a5,80004698 <pipealloc+0xb8>
    fileclose(*f1);
    80004690:	853e                	mv	a0,a5
    80004692:	c45ff0ef          	jal	800042d6 <fileclose>
  return -1;
    80004696:	557d                	li	a0,-1
}
    80004698:	70a2                	ld	ra,40(sp)
    8000469a:	7402                	ld	s0,32(sp)
    8000469c:	64e2                	ld	s1,24(sp)
    8000469e:	6a02                	ld	s4,0(sp)
    800046a0:	6145                	addi	sp,sp,48
    800046a2:	8082                	ret
  return -1;
    800046a4:	557d                	li	a0,-1
    800046a6:	bfcd                	j	80004698 <pipealloc+0xb8>

00000000800046a8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800046a8:	1101                	addi	sp,sp,-32
    800046aa:	ec06                	sd	ra,24(sp)
    800046ac:	e822                	sd	s0,16(sp)
    800046ae:	e426                	sd	s1,8(sp)
    800046b0:	e04a                	sd	s2,0(sp)
    800046b2:	1000                	addi	s0,sp,32
    800046b4:	84aa                	mv	s1,a0
    800046b6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800046b8:	d3cfc0ef          	jal	80000bf4 <acquire>
  if(writable){
    800046bc:	02090763          	beqz	s2,800046ea <pipeclose+0x42>
    pi->writeopen = 0;
    800046c0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800046c4:	21848513          	addi	a0,s1,536
    800046c8:	feefd0ef          	jal	80001eb6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800046cc:	2204b783          	ld	a5,544(s1)
    800046d0:	e785                	bnez	a5,800046f8 <pipeclose+0x50>
    release(&pi->lock);
    800046d2:	8526                	mv	a0,s1
    800046d4:	db8fc0ef          	jal	80000c8c <release>
    kfree((char*)pi);
    800046d8:	8526                	mv	a0,s1
    800046da:	b68fc0ef          	jal	80000a42 <kfree>
  } else
    release(&pi->lock);
}
    800046de:	60e2                	ld	ra,24(sp)
    800046e0:	6442                	ld	s0,16(sp)
    800046e2:	64a2                	ld	s1,8(sp)
    800046e4:	6902                	ld	s2,0(sp)
    800046e6:	6105                	addi	sp,sp,32
    800046e8:	8082                	ret
    pi->readopen = 0;
    800046ea:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800046ee:	21c48513          	addi	a0,s1,540
    800046f2:	fc4fd0ef          	jal	80001eb6 <wakeup>
    800046f6:	bfd9                	j	800046cc <pipeclose+0x24>
    release(&pi->lock);
    800046f8:	8526                	mv	a0,s1
    800046fa:	d92fc0ef          	jal	80000c8c <release>
}
    800046fe:	b7c5                	j	800046de <pipeclose+0x36>

0000000080004700 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004700:	711d                	addi	sp,sp,-96
    80004702:	ec86                	sd	ra,88(sp)
    80004704:	e8a2                	sd	s0,80(sp)
    80004706:	e4a6                	sd	s1,72(sp)
    80004708:	e0ca                	sd	s2,64(sp)
    8000470a:	fc4e                	sd	s3,56(sp)
    8000470c:	f852                	sd	s4,48(sp)
    8000470e:	f456                	sd	s5,40(sp)
    80004710:	1080                	addi	s0,sp,96
    80004712:	84aa                	mv	s1,a0
    80004714:	8aae                	mv	s5,a1
    80004716:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004718:	948fd0ef          	jal	80001860 <myproc>
    8000471c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000471e:	8526                	mv	a0,s1
    80004720:	cd4fc0ef          	jal	80000bf4 <acquire>
  while(i < n){
    80004724:	0b405a63          	blez	s4,800047d8 <pipewrite+0xd8>
    80004728:	f05a                	sd	s6,32(sp)
    8000472a:	ec5e                	sd	s7,24(sp)
    8000472c:	e862                	sd	s8,16(sp)
  int i = 0;
    8000472e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004730:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004732:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004736:	21c48b93          	addi	s7,s1,540
    8000473a:	a81d                	j	80004770 <pipewrite+0x70>
      release(&pi->lock);
    8000473c:	8526                	mv	a0,s1
    8000473e:	d4efc0ef          	jal	80000c8c <release>
      return -1;
    80004742:	597d                	li	s2,-1
    80004744:	7b02                	ld	s6,32(sp)
    80004746:	6be2                	ld	s7,24(sp)
    80004748:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000474a:	854a                	mv	a0,s2
    8000474c:	60e6                	ld	ra,88(sp)
    8000474e:	6446                	ld	s0,80(sp)
    80004750:	64a6                	ld	s1,72(sp)
    80004752:	6906                	ld	s2,64(sp)
    80004754:	79e2                	ld	s3,56(sp)
    80004756:	7a42                	ld	s4,48(sp)
    80004758:	7aa2                	ld	s5,40(sp)
    8000475a:	6125                	addi	sp,sp,96
    8000475c:	8082                	ret
      wakeup(&pi->nread);
    8000475e:	8562                	mv	a0,s8
    80004760:	f56fd0ef          	jal	80001eb6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004764:	85a6                	mv	a1,s1
    80004766:	855e                	mv	a0,s7
    80004768:	f00fd0ef          	jal	80001e68 <sleep>
  while(i < n){
    8000476c:	05495b63          	bge	s2,s4,800047c2 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80004770:	2204a783          	lw	a5,544(s1)
    80004774:	d7e1                	beqz	a5,8000473c <pipewrite+0x3c>
    80004776:	854e                	mv	a0,s3
    80004778:	93dfd0ef          	jal	800020b4 <killed>
    8000477c:	f161                	bnez	a0,8000473c <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000477e:	2184a783          	lw	a5,536(s1)
    80004782:	21c4a703          	lw	a4,540(s1)
    80004786:	2007879b          	addiw	a5,a5,512
    8000478a:	fcf70ae3          	beq	a4,a5,8000475e <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000478e:	4685                	li	a3,1
    80004790:	01590633          	add	a2,s2,s5
    80004794:	faf40593          	addi	a1,s0,-81
    80004798:	5989b503          	ld	a0,1432(s3)
    8000479c:	e8dfc0ef          	jal	80001628 <copyin>
    800047a0:	03650e63          	beq	a0,s6,800047dc <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800047a4:	21c4a783          	lw	a5,540(s1)
    800047a8:	0017871b          	addiw	a4,a5,1
    800047ac:	20e4ae23          	sw	a4,540(s1)
    800047b0:	1ff7f793          	andi	a5,a5,511
    800047b4:	97a6                	add	a5,a5,s1
    800047b6:	faf44703          	lbu	a4,-81(s0)
    800047ba:	00e78c23          	sb	a4,24(a5)
      i++;
    800047be:	2905                	addiw	s2,s2,1
    800047c0:	b775                	j	8000476c <pipewrite+0x6c>
    800047c2:	7b02                	ld	s6,32(sp)
    800047c4:	6be2                	ld	s7,24(sp)
    800047c6:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800047c8:	21848513          	addi	a0,s1,536
    800047cc:	eeafd0ef          	jal	80001eb6 <wakeup>
  release(&pi->lock);
    800047d0:	8526                	mv	a0,s1
    800047d2:	cbafc0ef          	jal	80000c8c <release>
  return i;
    800047d6:	bf95                	j	8000474a <pipewrite+0x4a>
  int i = 0;
    800047d8:	4901                	li	s2,0
    800047da:	b7fd                	j	800047c8 <pipewrite+0xc8>
    800047dc:	7b02                	ld	s6,32(sp)
    800047de:	6be2                	ld	s7,24(sp)
    800047e0:	6c42                	ld	s8,16(sp)
    800047e2:	b7dd                	j	800047c8 <pipewrite+0xc8>

00000000800047e4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800047e4:	715d                	addi	sp,sp,-80
    800047e6:	e486                	sd	ra,72(sp)
    800047e8:	e0a2                	sd	s0,64(sp)
    800047ea:	fc26                	sd	s1,56(sp)
    800047ec:	f84a                	sd	s2,48(sp)
    800047ee:	f44e                	sd	s3,40(sp)
    800047f0:	f052                	sd	s4,32(sp)
    800047f2:	ec56                	sd	s5,24(sp)
    800047f4:	0880                	addi	s0,sp,80
    800047f6:	84aa                	mv	s1,a0
    800047f8:	892e                	mv	s2,a1
    800047fa:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800047fc:	864fd0ef          	jal	80001860 <myproc>
    80004800:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004802:	8526                	mv	a0,s1
    80004804:	bf0fc0ef          	jal	80000bf4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004808:	2184a703          	lw	a4,536(s1)
    8000480c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004810:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004814:	02f71563          	bne	a4,a5,8000483e <piperead+0x5a>
    80004818:	2244a783          	lw	a5,548(s1)
    8000481c:	cb85                	beqz	a5,8000484c <piperead+0x68>
    if(killed(pr)){
    8000481e:	8552                	mv	a0,s4
    80004820:	895fd0ef          	jal	800020b4 <killed>
    80004824:	ed19                	bnez	a0,80004842 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004826:	85a6                	mv	a1,s1
    80004828:	854e                	mv	a0,s3
    8000482a:	e3efd0ef          	jal	80001e68 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000482e:	2184a703          	lw	a4,536(s1)
    80004832:	21c4a783          	lw	a5,540(s1)
    80004836:	fef701e3          	beq	a4,a5,80004818 <piperead+0x34>
    8000483a:	e85a                	sd	s6,16(sp)
    8000483c:	a809                	j	8000484e <piperead+0x6a>
    8000483e:	e85a                	sd	s6,16(sp)
    80004840:	a039                	j	8000484e <piperead+0x6a>
      release(&pi->lock);
    80004842:	8526                	mv	a0,s1
    80004844:	c48fc0ef          	jal	80000c8c <release>
      return -1;
    80004848:	59fd                	li	s3,-1
    8000484a:	a8b1                	j	800048a6 <piperead+0xc2>
    8000484c:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000484e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004850:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004852:	05505263          	blez	s5,80004896 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004856:	2184a783          	lw	a5,536(s1)
    8000485a:	21c4a703          	lw	a4,540(s1)
    8000485e:	02f70c63          	beq	a4,a5,80004896 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004862:	0017871b          	addiw	a4,a5,1
    80004866:	20e4ac23          	sw	a4,536(s1)
    8000486a:	1ff7f793          	andi	a5,a5,511
    8000486e:	97a6                	add	a5,a5,s1
    80004870:	0187c783          	lbu	a5,24(a5)
    80004874:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004878:	4685                	li	a3,1
    8000487a:	fbf40613          	addi	a2,s0,-65
    8000487e:	85ca                	mv	a1,s2
    80004880:	598a3503          	ld	a0,1432(s4)
    80004884:	ccffc0ef          	jal	80001552 <copyout>
    80004888:	01650763          	beq	a0,s6,80004896 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000488c:	2985                	addiw	s3,s3,1
    8000488e:	0905                	addi	s2,s2,1
    80004890:	fd3a93e3          	bne	s5,s3,80004856 <piperead+0x72>
    80004894:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004896:	21c48513          	addi	a0,s1,540
    8000489a:	e1cfd0ef          	jal	80001eb6 <wakeup>
  release(&pi->lock);
    8000489e:	8526                	mv	a0,s1
    800048a0:	becfc0ef          	jal	80000c8c <release>
    800048a4:	6b42                	ld	s6,16(sp)
  return i;
}
    800048a6:	854e                	mv	a0,s3
    800048a8:	60a6                	ld	ra,72(sp)
    800048aa:	6406                	ld	s0,64(sp)
    800048ac:	74e2                	ld	s1,56(sp)
    800048ae:	7942                	ld	s2,48(sp)
    800048b0:	79a2                	ld	s3,40(sp)
    800048b2:	7a02                	ld	s4,32(sp)
    800048b4:	6ae2                	ld	s5,24(sp)
    800048b6:	6161                	addi	sp,sp,80
    800048b8:	8082                	ret

00000000800048ba <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800048ba:	1141                	addi	sp,sp,-16
    800048bc:	e422                	sd	s0,8(sp)
    800048be:	0800                	addi	s0,sp,16
    800048c0:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800048c2:	8905                	andi	a0,a0,1
    800048c4:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800048c6:	8b89                	andi	a5,a5,2
    800048c8:	c399                	beqz	a5,800048ce <flags2perm+0x14>
      perm |= PTE_W;
    800048ca:	00456513          	ori	a0,a0,4
    return perm;
}
    800048ce:	6422                	ld	s0,8(sp)
    800048d0:	0141                	addi	sp,sp,16
    800048d2:	8082                	ret

00000000800048d4 <exec>:

int
exec(char *path, char **argv)
{
    800048d4:	df010113          	addi	sp,sp,-528
    800048d8:	20113423          	sd	ra,520(sp)
    800048dc:	20813023          	sd	s0,512(sp)
    800048e0:	ffa6                	sd	s1,504(sp)
    800048e2:	fbca                	sd	s2,496(sp)
    800048e4:	0c00                	addi	s0,sp,528
    800048e6:	892a                	mv	s2,a0
    800048e8:	dea43c23          	sd	a0,-520(s0)
    800048ec:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800048f0:	f71fc0ef          	jal	80001860 <myproc>
    800048f4:	84aa                	mv	s1,a0

  begin_op();
    800048f6:	dc2ff0ef          	jal	80003eb8 <begin_op>

  if((ip = namei(path)) == 0){
    800048fa:	854a                	mv	a0,s2
    800048fc:	c00ff0ef          	jal	80003cfc <namei>
    80004900:	c931                	beqz	a0,80004954 <exec+0x80>
    80004902:	f3d2                	sd	s4,480(sp)
    80004904:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004906:	d1dfe0ef          	jal	80003622 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000490a:	04000713          	li	a4,64
    8000490e:	4681                	li	a3,0
    80004910:	e5040613          	addi	a2,s0,-432
    80004914:	4581                	li	a1,0
    80004916:	8552                	mv	a0,s4
    80004918:	f5ffe0ef          	jal	80003876 <readi>
    8000491c:	04000793          	li	a5,64
    80004920:	00f51a63          	bne	a0,a5,80004934 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004924:	e5042703          	lw	a4,-432(s0)
    80004928:	464c47b7          	lui	a5,0x464c4
    8000492c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004930:	02f70663          	beq	a4,a5,8000495c <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004934:	8552                	mv	a0,s4
    80004936:	ef7fe0ef          	jal	8000382c <iunlockput>
    end_op();
    8000493a:	de8ff0ef          	jal	80003f22 <end_op>
  }
  return -1;
    8000493e:	557d                	li	a0,-1
    80004940:	7a1e                	ld	s4,480(sp)
}
    80004942:	20813083          	ld	ra,520(sp)
    80004946:	20013403          	ld	s0,512(sp)
    8000494a:	74fe                	ld	s1,504(sp)
    8000494c:	795e                	ld	s2,496(sp)
    8000494e:	21010113          	addi	sp,sp,528
    80004952:	8082                	ret
    end_op();
    80004954:	dceff0ef          	jal	80003f22 <end_op>
    return -1;
    80004958:	557d                	li	a0,-1
    8000495a:	b7e5                	j	80004942 <exec+0x6e>
    8000495c:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000495e:	8526                	mv	a0,s1
    80004960:	fabfc0ef          	jal	8000190a <proc_pagetable>
    80004964:	8b2a                	mv	s6,a0
    80004966:	2c050b63          	beqz	a0,80004c3c <exec+0x368>
    8000496a:	f7ce                	sd	s3,488(sp)
    8000496c:	efd6                	sd	s5,472(sp)
    8000496e:	e7de                	sd	s7,456(sp)
    80004970:	e3e2                	sd	s8,448(sp)
    80004972:	ff66                	sd	s9,440(sp)
    80004974:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004976:	e7042d03          	lw	s10,-400(s0)
    8000497a:	e8845783          	lhu	a5,-376(s0)
    8000497e:	12078963          	beqz	a5,80004ab0 <exec+0x1dc>
    80004982:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004984:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004986:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004988:	6c85                	lui	s9,0x1
    8000498a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000498e:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004992:	6a85                	lui	s5,0x1
    80004994:	a085                	j	800049f4 <exec+0x120>
      panic("loadseg: address should exist");
    80004996:	00003517          	auipc	a0,0x3
    8000499a:	da250513          	addi	a0,a0,-606 # 80007738 <etext+0x738>
    8000499e:	df7fb0ef          	jal	80000794 <panic>
    if(sz - i < PGSIZE)
    800049a2:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800049a4:	8726                	mv	a4,s1
    800049a6:	012c06bb          	addw	a3,s8,s2
    800049aa:	4581                	li	a1,0
    800049ac:	8552                	mv	a0,s4
    800049ae:	ec9fe0ef          	jal	80003876 <readi>
    800049b2:	2501                	sext.w	a0,a0
    800049b4:	24a49a63          	bne	s1,a0,80004c08 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    800049b8:	012a893b          	addw	s2,s5,s2
    800049bc:	03397363          	bgeu	s2,s3,800049e2 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    800049c0:	02091593          	slli	a1,s2,0x20
    800049c4:	9181                	srli	a1,a1,0x20
    800049c6:	95de                	add	a1,a1,s7
    800049c8:	855a                	mv	a0,s6
    800049ca:	e0cfc0ef          	jal	80000fd6 <walkaddr>
    800049ce:	862a                	mv	a2,a0
    if(pa == 0)
    800049d0:	d179                	beqz	a0,80004996 <exec+0xc2>
    if(sz - i < PGSIZE)
    800049d2:	412984bb          	subw	s1,s3,s2
    800049d6:	0004879b          	sext.w	a5,s1
    800049da:	fcfcf4e3          	bgeu	s9,a5,800049a2 <exec+0xce>
    800049de:	84d6                	mv	s1,s5
    800049e0:	b7c9                	j	800049a2 <exec+0xce>
    sz = sz1;
    800049e2:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800049e6:	2d85                	addiw	s11,s11,1
    800049e8:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800049ec:	e8845783          	lhu	a5,-376(s0)
    800049f0:	08fdd063          	bge	s11,a5,80004a70 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800049f4:	2d01                	sext.w	s10,s10
    800049f6:	03800713          	li	a4,56
    800049fa:	86ea                	mv	a3,s10
    800049fc:	e1840613          	addi	a2,s0,-488
    80004a00:	4581                	li	a1,0
    80004a02:	8552                	mv	a0,s4
    80004a04:	e73fe0ef          	jal	80003876 <readi>
    80004a08:	03800793          	li	a5,56
    80004a0c:	1cf51663          	bne	a0,a5,80004bd8 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004a10:	e1842783          	lw	a5,-488(s0)
    80004a14:	4705                	li	a4,1
    80004a16:	fce798e3          	bne	a5,a4,800049e6 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80004a1a:	e4043483          	ld	s1,-448(s0)
    80004a1e:	e3843783          	ld	a5,-456(s0)
    80004a22:	1af4ef63          	bltu	s1,a5,80004be0 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004a26:	e2843783          	ld	a5,-472(s0)
    80004a2a:	94be                	add	s1,s1,a5
    80004a2c:	1af4ee63          	bltu	s1,a5,80004be8 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004a30:	df043703          	ld	a4,-528(s0)
    80004a34:	8ff9                	and	a5,a5,a4
    80004a36:	1a079d63          	bnez	a5,80004bf0 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004a3a:	e1c42503          	lw	a0,-484(s0)
    80004a3e:	e7dff0ef          	jal	800048ba <flags2perm>
    80004a42:	86aa                	mv	a3,a0
    80004a44:	8626                	mv	a2,s1
    80004a46:	85ca                	mv	a1,s2
    80004a48:	855a                	mv	a0,s6
    80004a4a:	8f5fc0ef          	jal	8000133e <uvmalloc>
    80004a4e:	e0a43423          	sd	a0,-504(s0)
    80004a52:	1a050363          	beqz	a0,80004bf8 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004a56:	e2843b83          	ld	s7,-472(s0)
    80004a5a:	e2042c03          	lw	s8,-480(s0)
    80004a5e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004a62:	00098463          	beqz	s3,80004a6a <exec+0x196>
    80004a66:	4901                	li	s2,0
    80004a68:	bfa1                	j	800049c0 <exec+0xec>
    sz = sz1;
    80004a6a:	e0843903          	ld	s2,-504(s0)
    80004a6e:	bfa5                	j	800049e6 <exec+0x112>
    80004a70:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004a72:	8552                	mv	a0,s4
    80004a74:	db9fe0ef          	jal	8000382c <iunlockput>
  end_op();
    80004a78:	caaff0ef          	jal	80003f22 <end_op>
  p = myproc();
    80004a7c:	de5fc0ef          	jal	80001860 <myproc>
    80004a80:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004a82:	59053c83          	ld	s9,1424(a0)
  sz = PGROUNDUP(sz);
    80004a86:	6985                	lui	s3,0x1
    80004a88:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004a8a:	99ca                	add	s3,s3,s2
    80004a8c:	77fd                	lui	a5,0xfffff
    80004a8e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004a92:	4691                	li	a3,4
    80004a94:	6609                	lui	a2,0x2
    80004a96:	964e                	add	a2,a2,s3
    80004a98:	85ce                	mv	a1,s3
    80004a9a:	855a                	mv	a0,s6
    80004a9c:	8a3fc0ef          	jal	8000133e <uvmalloc>
    80004aa0:	892a                	mv	s2,a0
    80004aa2:	e0a43423          	sd	a0,-504(s0)
    80004aa6:	e519                	bnez	a0,80004ab4 <exec+0x1e0>
  if(pagetable)
    80004aa8:	e1343423          	sd	s3,-504(s0)
    80004aac:	4a01                	li	s4,0
    80004aae:	aab1                	j	80004c0a <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004ab0:	4901                	li	s2,0
    80004ab2:	b7c1                	j	80004a72 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004ab4:	75f9                	lui	a1,0xffffe
    80004ab6:	95aa                	add	a1,a1,a0
    80004ab8:	855a                	mv	a0,s6
    80004aba:	a6ffc0ef          	jal	80001528 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004abe:	7bfd                	lui	s7,0xfffff
    80004ac0:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004ac2:	e0043783          	ld	a5,-512(s0)
    80004ac6:	6388                	ld	a0,0(a5)
    80004ac8:	cd39                	beqz	a0,80004b26 <exec+0x252>
    80004aca:	e9040993          	addi	s3,s0,-368
    80004ace:	f9040c13          	addi	s8,s0,-112
    80004ad2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004ad4:	b64fc0ef          	jal	80000e38 <strlen>
    80004ad8:	0015079b          	addiw	a5,a0,1
    80004adc:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004ae0:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004ae4:	11796e63          	bltu	s2,s7,80004c00 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004ae8:	e0043d03          	ld	s10,-512(s0)
    80004aec:	000d3a03          	ld	s4,0(s10)
    80004af0:	8552                	mv	a0,s4
    80004af2:	b46fc0ef          	jal	80000e38 <strlen>
    80004af6:	0015069b          	addiw	a3,a0,1
    80004afa:	8652                	mv	a2,s4
    80004afc:	85ca                	mv	a1,s2
    80004afe:	855a                	mv	a0,s6
    80004b00:	a53fc0ef          	jal	80001552 <copyout>
    80004b04:	10054063          	bltz	a0,80004c04 <exec+0x330>
    ustack[argc] = sp;
    80004b08:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004b0c:	0485                	addi	s1,s1,1
    80004b0e:	008d0793          	addi	a5,s10,8
    80004b12:	e0f43023          	sd	a5,-512(s0)
    80004b16:	008d3503          	ld	a0,8(s10)
    80004b1a:	c909                	beqz	a0,80004b2c <exec+0x258>
    if(argc >= MAXARG)
    80004b1c:	09a1                	addi	s3,s3,8
    80004b1e:	fb899be3          	bne	s3,s8,80004ad4 <exec+0x200>
  ip = 0;
    80004b22:	4a01                	li	s4,0
    80004b24:	a0dd                	j	80004c0a <exec+0x336>
  sp = sz;
    80004b26:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004b2a:	4481                	li	s1,0
  ustack[argc] = 0;
    80004b2c:	00349793          	slli	a5,s1,0x3
    80004b30:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffc5fa8>
    80004b34:	97a2                	add	a5,a5,s0
    80004b36:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004b3a:	00148693          	addi	a3,s1,1
    80004b3e:	068e                	slli	a3,a3,0x3
    80004b40:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004b44:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004b48:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004b4c:	f5796ee3          	bltu	s2,s7,80004aa8 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004b50:	e9040613          	addi	a2,s0,-368
    80004b54:	85ca                	mv	a1,s2
    80004b56:	855a                	mv	a0,s6
    80004b58:	9fbfc0ef          	jal	80001552 <copyout>
    80004b5c:	0e054263          	bltz	a0,80004c40 <exec+0x36c>
  p->trapframe->a1 = sp;
    80004b60:	5a0ab783          	ld	a5,1440(s5) # 15a0 <_entry-0x7fffea60>
    80004b64:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004b68:	df843783          	ld	a5,-520(s0)
    80004b6c:	0007c703          	lbu	a4,0(a5)
    80004b70:	cf11                	beqz	a4,80004b8c <exec+0x2b8>
    80004b72:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004b74:	02f00693          	li	a3,47
    80004b78:	a039                	j	80004b86 <exec+0x2b2>
      last = s+1;
    80004b7a:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004b7e:	0785                	addi	a5,a5,1
    80004b80:	fff7c703          	lbu	a4,-1(a5)
    80004b84:	c701                	beqz	a4,80004b8c <exec+0x2b8>
    if(*s == '/')
    80004b86:	fed71ce3          	bne	a4,a3,80004b7e <exec+0x2aa>
    80004b8a:	bfc5                	j	80004b7a <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004b8c:	4641                	li	a2,16
    80004b8e:	df843583          	ld	a1,-520(s0)
    80004b92:	6a0a8513          	addi	a0,s5,1696
    80004b96:	a70fc0ef          	jal	80000e06 <safestrcpy>
  oldpagetable = p->pagetable;
    80004b9a:	598ab503          	ld	a0,1432(s5)
  p->pagetable = pagetable;
    80004b9e:	596abc23          	sd	s6,1432(s5)
  p->sz = sz;
    80004ba2:	e0843783          	ld	a5,-504(s0)
    80004ba6:	58fab823          	sd	a5,1424(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004baa:	5a0ab783          	ld	a5,1440(s5)
    80004bae:	e6843703          	ld	a4,-408(s0)
    80004bb2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004bb4:	5a0ab783          	ld	a5,1440(s5)
    80004bb8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004bbc:	85e6                	mv	a1,s9
    80004bbe:	dd1fc0ef          	jal	8000198e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004bc2:	0004851b          	sext.w	a0,s1
    80004bc6:	79be                	ld	s3,488(sp)
    80004bc8:	7a1e                	ld	s4,480(sp)
    80004bca:	6afe                	ld	s5,472(sp)
    80004bcc:	6b5e                	ld	s6,464(sp)
    80004bce:	6bbe                	ld	s7,456(sp)
    80004bd0:	6c1e                	ld	s8,448(sp)
    80004bd2:	7cfa                	ld	s9,440(sp)
    80004bd4:	7d5a                	ld	s10,432(sp)
    80004bd6:	b3b5                	j	80004942 <exec+0x6e>
    80004bd8:	e1243423          	sd	s2,-504(s0)
    80004bdc:	7dba                	ld	s11,424(sp)
    80004bde:	a035                	j	80004c0a <exec+0x336>
    80004be0:	e1243423          	sd	s2,-504(s0)
    80004be4:	7dba                	ld	s11,424(sp)
    80004be6:	a015                	j	80004c0a <exec+0x336>
    80004be8:	e1243423          	sd	s2,-504(s0)
    80004bec:	7dba                	ld	s11,424(sp)
    80004bee:	a831                	j	80004c0a <exec+0x336>
    80004bf0:	e1243423          	sd	s2,-504(s0)
    80004bf4:	7dba                	ld	s11,424(sp)
    80004bf6:	a811                	j	80004c0a <exec+0x336>
    80004bf8:	e1243423          	sd	s2,-504(s0)
    80004bfc:	7dba                	ld	s11,424(sp)
    80004bfe:	a031                	j	80004c0a <exec+0x336>
  ip = 0;
    80004c00:	4a01                	li	s4,0
    80004c02:	a021                	j	80004c0a <exec+0x336>
    80004c04:	4a01                	li	s4,0
  if(pagetable)
    80004c06:	a011                	j	80004c0a <exec+0x336>
    80004c08:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004c0a:	e0843583          	ld	a1,-504(s0)
    80004c0e:	855a                	mv	a0,s6
    80004c10:	d7ffc0ef          	jal	8000198e <proc_freepagetable>
  return -1;
    80004c14:	557d                	li	a0,-1
  if(ip){
    80004c16:	000a1b63          	bnez	s4,80004c2c <exec+0x358>
    80004c1a:	79be                	ld	s3,488(sp)
    80004c1c:	7a1e                	ld	s4,480(sp)
    80004c1e:	6afe                	ld	s5,472(sp)
    80004c20:	6b5e                	ld	s6,464(sp)
    80004c22:	6bbe                	ld	s7,456(sp)
    80004c24:	6c1e                	ld	s8,448(sp)
    80004c26:	7cfa                	ld	s9,440(sp)
    80004c28:	7d5a                	ld	s10,432(sp)
    80004c2a:	bb21                	j	80004942 <exec+0x6e>
    80004c2c:	79be                	ld	s3,488(sp)
    80004c2e:	6afe                	ld	s5,472(sp)
    80004c30:	6b5e                	ld	s6,464(sp)
    80004c32:	6bbe                	ld	s7,456(sp)
    80004c34:	6c1e                	ld	s8,448(sp)
    80004c36:	7cfa                	ld	s9,440(sp)
    80004c38:	7d5a                	ld	s10,432(sp)
    80004c3a:	b9ed                	j	80004934 <exec+0x60>
    80004c3c:	6b5e                	ld	s6,464(sp)
    80004c3e:	b9dd                	j	80004934 <exec+0x60>
  sz = sz1;
    80004c40:	e0843983          	ld	s3,-504(s0)
    80004c44:	b595                	j	80004aa8 <exec+0x1d4>

0000000080004c46 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004c46:	7179                	addi	sp,sp,-48
    80004c48:	f406                	sd	ra,40(sp)
    80004c4a:	f022                	sd	s0,32(sp)
    80004c4c:	ec26                	sd	s1,24(sp)
    80004c4e:	e84a                	sd	s2,16(sp)
    80004c50:	1800                	addi	s0,sp,48
    80004c52:	892e                	mv	s2,a1
    80004c54:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004c56:	fdc40593          	addi	a1,s0,-36
    80004c5a:	d73fd0ef          	jal	800029cc <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004c5e:	fdc42703          	lw	a4,-36(s0)
    80004c62:	47bd                	li	a5,15
    80004c64:	02e7e963          	bltu	a5,a4,80004c96 <argfd+0x50>
    80004c68:	bf9fc0ef          	jal	80001860 <myproc>
    80004c6c:	fdc42703          	lw	a4,-36(s0)
    80004c70:	0c270793          	addi	a5,a4,194
    80004c74:	078e                	slli	a5,a5,0x3
    80004c76:	953e                	add	a0,a0,a5
    80004c78:	651c                	ld	a5,8(a0)
    80004c7a:	c385                	beqz	a5,80004c9a <argfd+0x54>
    return -1;
  if(pfd)
    80004c7c:	00090463          	beqz	s2,80004c84 <argfd+0x3e>
    *pfd = fd;
    80004c80:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004c84:	4501                	li	a0,0
  if(pf)
    80004c86:	c091                	beqz	s1,80004c8a <argfd+0x44>
    *pf = f;
    80004c88:	e09c                	sd	a5,0(s1)
}
    80004c8a:	70a2                	ld	ra,40(sp)
    80004c8c:	7402                	ld	s0,32(sp)
    80004c8e:	64e2                	ld	s1,24(sp)
    80004c90:	6942                	ld	s2,16(sp)
    80004c92:	6145                	addi	sp,sp,48
    80004c94:	8082                	ret
    return -1;
    80004c96:	557d                	li	a0,-1
    80004c98:	bfcd                	j	80004c8a <argfd+0x44>
    80004c9a:	557d                	li	a0,-1
    80004c9c:	b7fd                	j	80004c8a <argfd+0x44>

0000000080004c9e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004c9e:	1101                	addi	sp,sp,-32
    80004ca0:	ec06                	sd	ra,24(sp)
    80004ca2:	e822                	sd	s0,16(sp)
    80004ca4:	e426                	sd	s1,8(sp)
    80004ca6:	1000                	addi	s0,sp,32
    80004ca8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004caa:	bb7fc0ef          	jal	80001860 <myproc>
    80004cae:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004cb0:	61850793          	addi	a5,a0,1560
    80004cb4:	4501                	li	a0,0
    80004cb6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004cb8:	6398                	ld	a4,0(a5)
    80004cba:	cb19                	beqz	a4,80004cd0 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004cbc:	2505                	addiw	a0,a0,1
    80004cbe:	07a1                	addi	a5,a5,8
    80004cc0:	fed51ce3          	bne	a0,a3,80004cb8 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004cc4:	557d                	li	a0,-1
}
    80004cc6:	60e2                	ld	ra,24(sp)
    80004cc8:	6442                	ld	s0,16(sp)
    80004cca:	64a2                	ld	s1,8(sp)
    80004ccc:	6105                	addi	sp,sp,32
    80004cce:	8082                	ret
      p->ofile[fd] = f;
    80004cd0:	0c250793          	addi	a5,a0,194
    80004cd4:	078e                	slli	a5,a5,0x3
    80004cd6:	963e                	add	a2,a2,a5
    80004cd8:	e604                	sd	s1,8(a2)
      return fd;
    80004cda:	b7f5                	j	80004cc6 <fdalloc+0x28>

0000000080004cdc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004cdc:	715d                	addi	sp,sp,-80
    80004cde:	e486                	sd	ra,72(sp)
    80004ce0:	e0a2                	sd	s0,64(sp)
    80004ce2:	fc26                	sd	s1,56(sp)
    80004ce4:	f84a                	sd	s2,48(sp)
    80004ce6:	f44e                	sd	s3,40(sp)
    80004ce8:	ec56                	sd	s5,24(sp)
    80004cea:	e85a                	sd	s6,16(sp)
    80004cec:	0880                	addi	s0,sp,80
    80004cee:	8b2e                	mv	s6,a1
    80004cf0:	89b2                	mv	s3,a2
    80004cf2:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004cf4:	fb040593          	addi	a1,s0,-80
    80004cf8:	81eff0ef          	jal	80003d16 <nameiparent>
    80004cfc:	84aa                	mv	s1,a0
    80004cfe:	10050a63          	beqz	a0,80004e12 <create+0x136>
    return 0;

  ilock(dp);
    80004d02:	921fe0ef          	jal	80003622 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004d06:	4601                	li	a2,0
    80004d08:	fb040593          	addi	a1,s0,-80
    80004d0c:	8526                	mv	a0,s1
    80004d0e:	d89fe0ef          	jal	80003a96 <dirlookup>
    80004d12:	8aaa                	mv	s5,a0
    80004d14:	c129                	beqz	a0,80004d56 <create+0x7a>
    iunlockput(dp);
    80004d16:	8526                	mv	a0,s1
    80004d18:	b15fe0ef          	jal	8000382c <iunlockput>
    ilock(ip);
    80004d1c:	8556                	mv	a0,s5
    80004d1e:	905fe0ef          	jal	80003622 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004d22:	4789                	li	a5,2
    80004d24:	02fb1463          	bne	s6,a5,80004d4c <create+0x70>
    80004d28:	044ad783          	lhu	a5,68(s5)
    80004d2c:	37f9                	addiw	a5,a5,-2
    80004d2e:	17c2                	slli	a5,a5,0x30
    80004d30:	93c1                	srli	a5,a5,0x30
    80004d32:	4705                	li	a4,1
    80004d34:	00f76c63          	bltu	a4,a5,80004d4c <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004d38:	8556                	mv	a0,s5
    80004d3a:	60a6                	ld	ra,72(sp)
    80004d3c:	6406                	ld	s0,64(sp)
    80004d3e:	74e2                	ld	s1,56(sp)
    80004d40:	7942                	ld	s2,48(sp)
    80004d42:	79a2                	ld	s3,40(sp)
    80004d44:	6ae2                	ld	s5,24(sp)
    80004d46:	6b42                	ld	s6,16(sp)
    80004d48:	6161                	addi	sp,sp,80
    80004d4a:	8082                	ret
    iunlockput(ip);
    80004d4c:	8556                	mv	a0,s5
    80004d4e:	adffe0ef          	jal	8000382c <iunlockput>
    return 0;
    80004d52:	4a81                	li	s5,0
    80004d54:	b7d5                	j	80004d38 <create+0x5c>
    80004d56:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004d58:	85da                	mv	a1,s6
    80004d5a:	4088                	lw	a0,0(s1)
    80004d5c:	f56fe0ef          	jal	800034b2 <ialloc>
    80004d60:	8a2a                	mv	s4,a0
    80004d62:	cd15                	beqz	a0,80004d9e <create+0xc2>
  ilock(ip);
    80004d64:	8bffe0ef          	jal	80003622 <ilock>
  ip->major = major;
    80004d68:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004d6c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004d70:	4905                	li	s2,1
    80004d72:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004d76:	8552                	mv	a0,s4
    80004d78:	ff6fe0ef          	jal	8000356e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004d7c:	032b0763          	beq	s6,s2,80004daa <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004d80:	004a2603          	lw	a2,4(s4)
    80004d84:	fb040593          	addi	a1,s0,-80
    80004d88:	8526                	mv	a0,s1
    80004d8a:	ed9fe0ef          	jal	80003c62 <dirlink>
    80004d8e:	06054563          	bltz	a0,80004df8 <create+0x11c>
  iunlockput(dp);
    80004d92:	8526                	mv	a0,s1
    80004d94:	a99fe0ef          	jal	8000382c <iunlockput>
  return ip;
    80004d98:	8ad2                	mv	s5,s4
    80004d9a:	7a02                	ld	s4,32(sp)
    80004d9c:	bf71                	j	80004d38 <create+0x5c>
    iunlockput(dp);
    80004d9e:	8526                	mv	a0,s1
    80004da0:	a8dfe0ef          	jal	8000382c <iunlockput>
    return 0;
    80004da4:	8ad2                	mv	s5,s4
    80004da6:	7a02                	ld	s4,32(sp)
    80004da8:	bf41                	j	80004d38 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004daa:	004a2603          	lw	a2,4(s4)
    80004dae:	00003597          	auipc	a1,0x3
    80004db2:	9aa58593          	addi	a1,a1,-1622 # 80007758 <etext+0x758>
    80004db6:	8552                	mv	a0,s4
    80004db8:	eabfe0ef          	jal	80003c62 <dirlink>
    80004dbc:	02054e63          	bltz	a0,80004df8 <create+0x11c>
    80004dc0:	40d0                	lw	a2,4(s1)
    80004dc2:	00003597          	auipc	a1,0x3
    80004dc6:	99e58593          	addi	a1,a1,-1634 # 80007760 <etext+0x760>
    80004dca:	8552                	mv	a0,s4
    80004dcc:	e97fe0ef          	jal	80003c62 <dirlink>
    80004dd0:	02054463          	bltz	a0,80004df8 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004dd4:	004a2603          	lw	a2,4(s4)
    80004dd8:	fb040593          	addi	a1,s0,-80
    80004ddc:	8526                	mv	a0,s1
    80004dde:	e85fe0ef          	jal	80003c62 <dirlink>
    80004de2:	00054b63          	bltz	a0,80004df8 <create+0x11c>
    dp->nlink++;  // for ".."
    80004de6:	04a4d783          	lhu	a5,74(s1)
    80004dea:	2785                	addiw	a5,a5,1
    80004dec:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004df0:	8526                	mv	a0,s1
    80004df2:	f7cfe0ef          	jal	8000356e <iupdate>
    80004df6:	bf71                	j	80004d92 <create+0xb6>
  ip->nlink = 0;
    80004df8:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004dfc:	8552                	mv	a0,s4
    80004dfe:	f70fe0ef          	jal	8000356e <iupdate>
  iunlockput(ip);
    80004e02:	8552                	mv	a0,s4
    80004e04:	a29fe0ef          	jal	8000382c <iunlockput>
  iunlockput(dp);
    80004e08:	8526                	mv	a0,s1
    80004e0a:	a23fe0ef          	jal	8000382c <iunlockput>
  return 0;
    80004e0e:	7a02                	ld	s4,32(sp)
    80004e10:	b725                	j	80004d38 <create+0x5c>
    return 0;
    80004e12:	8aaa                	mv	s5,a0
    80004e14:	b715                	j	80004d38 <create+0x5c>

0000000080004e16 <sys_dup>:
{
    80004e16:	7179                	addi	sp,sp,-48
    80004e18:	f406                	sd	ra,40(sp)
    80004e1a:	f022                	sd	s0,32(sp)
    80004e1c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004e1e:	fd840613          	addi	a2,s0,-40
    80004e22:	4581                	li	a1,0
    80004e24:	4501                	li	a0,0
    80004e26:	e21ff0ef          	jal	80004c46 <argfd>
    return -1;
    80004e2a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004e2c:	02054363          	bltz	a0,80004e52 <sys_dup+0x3c>
    80004e30:	ec26                	sd	s1,24(sp)
    80004e32:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004e34:	fd843903          	ld	s2,-40(s0)
    80004e38:	854a                	mv	a0,s2
    80004e3a:	e65ff0ef          	jal	80004c9e <fdalloc>
    80004e3e:	84aa                	mv	s1,a0
    return -1;
    80004e40:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004e42:	00054d63          	bltz	a0,80004e5c <sys_dup+0x46>
  filedup(f);
    80004e46:	854a                	mv	a0,s2
    80004e48:	c48ff0ef          	jal	80004290 <filedup>
  return fd;
    80004e4c:	87a6                	mv	a5,s1
    80004e4e:	64e2                	ld	s1,24(sp)
    80004e50:	6942                	ld	s2,16(sp)
}
    80004e52:	853e                	mv	a0,a5
    80004e54:	70a2                	ld	ra,40(sp)
    80004e56:	7402                	ld	s0,32(sp)
    80004e58:	6145                	addi	sp,sp,48
    80004e5a:	8082                	ret
    80004e5c:	64e2                	ld	s1,24(sp)
    80004e5e:	6942                	ld	s2,16(sp)
    80004e60:	bfcd                	j	80004e52 <sys_dup+0x3c>

0000000080004e62 <sys_read>:
{
    80004e62:	7179                	addi	sp,sp,-48
    80004e64:	f406                	sd	ra,40(sp)
    80004e66:	f022                	sd	s0,32(sp)
    80004e68:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004e6a:	fd840593          	addi	a1,s0,-40
    80004e6e:	4505                	li	a0,1
    80004e70:	b9ffd0ef          	jal	80002a0e <argaddr>
  argint(2, &n);
    80004e74:	fe440593          	addi	a1,s0,-28
    80004e78:	4509                	li	a0,2
    80004e7a:	b53fd0ef          	jal	800029cc <argint>
  if(argfd(0, 0, &f) < 0)
    80004e7e:	fe840613          	addi	a2,s0,-24
    80004e82:	4581                	li	a1,0
    80004e84:	4501                	li	a0,0
    80004e86:	dc1ff0ef          	jal	80004c46 <argfd>
    80004e8a:	87aa                	mv	a5,a0
    return -1;
    80004e8c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e8e:	0007ca63          	bltz	a5,80004ea2 <sys_read+0x40>
  return fileread(f, p, n);
    80004e92:	fe442603          	lw	a2,-28(s0)
    80004e96:	fd843583          	ld	a1,-40(s0)
    80004e9a:	fe843503          	ld	a0,-24(s0)
    80004e9e:	d58ff0ef          	jal	800043f6 <fileread>
}
    80004ea2:	70a2                	ld	ra,40(sp)
    80004ea4:	7402                	ld	s0,32(sp)
    80004ea6:	6145                	addi	sp,sp,48
    80004ea8:	8082                	ret

0000000080004eaa <sys_write>:
{
    80004eaa:	7179                	addi	sp,sp,-48
    80004eac:	f406                	sd	ra,40(sp)
    80004eae:	f022                	sd	s0,32(sp)
    80004eb0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004eb2:	fd840593          	addi	a1,s0,-40
    80004eb6:	4505                	li	a0,1
    80004eb8:	b57fd0ef          	jal	80002a0e <argaddr>
  argint(2, &n);
    80004ebc:	fe440593          	addi	a1,s0,-28
    80004ec0:	4509                	li	a0,2
    80004ec2:	b0bfd0ef          	jal	800029cc <argint>
  if(argfd(0, 0, &f) < 0)
    80004ec6:	fe840613          	addi	a2,s0,-24
    80004eca:	4581                	li	a1,0
    80004ecc:	4501                	li	a0,0
    80004ece:	d79ff0ef          	jal	80004c46 <argfd>
    80004ed2:	87aa                	mv	a5,a0
    return -1;
    80004ed4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004ed6:	0007ca63          	bltz	a5,80004eea <sys_write+0x40>
  return filewrite(f, p, n);
    80004eda:	fe442603          	lw	a2,-28(s0)
    80004ede:	fd843583          	ld	a1,-40(s0)
    80004ee2:	fe843503          	ld	a0,-24(s0)
    80004ee6:	dceff0ef          	jal	800044b4 <filewrite>
}
    80004eea:	70a2                	ld	ra,40(sp)
    80004eec:	7402                	ld	s0,32(sp)
    80004eee:	6145                	addi	sp,sp,48
    80004ef0:	8082                	ret

0000000080004ef2 <sys_close>:
{
    80004ef2:	1101                	addi	sp,sp,-32
    80004ef4:	ec06                	sd	ra,24(sp)
    80004ef6:	e822                	sd	s0,16(sp)
    80004ef8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004efa:	fe040613          	addi	a2,s0,-32
    80004efe:	fec40593          	addi	a1,s0,-20
    80004f02:	4501                	li	a0,0
    80004f04:	d43ff0ef          	jal	80004c46 <argfd>
    return -1;
    80004f08:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004f0a:	02054163          	bltz	a0,80004f2c <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80004f0e:	953fc0ef          	jal	80001860 <myproc>
    80004f12:	fec42783          	lw	a5,-20(s0)
    80004f16:	0c278793          	addi	a5,a5,194
    80004f1a:	078e                	slli	a5,a5,0x3
    80004f1c:	953e                	add	a0,a0,a5
    80004f1e:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004f22:	fe043503          	ld	a0,-32(s0)
    80004f26:	bb0ff0ef          	jal	800042d6 <fileclose>
  return 0;
    80004f2a:	4781                	li	a5,0
}
    80004f2c:	853e                	mv	a0,a5
    80004f2e:	60e2                	ld	ra,24(sp)
    80004f30:	6442                	ld	s0,16(sp)
    80004f32:	6105                	addi	sp,sp,32
    80004f34:	8082                	ret

0000000080004f36 <sys_fstat>:
{
    80004f36:	1101                	addi	sp,sp,-32
    80004f38:	ec06                	sd	ra,24(sp)
    80004f3a:	e822                	sd	s0,16(sp)
    80004f3c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004f3e:	fe040593          	addi	a1,s0,-32
    80004f42:	4505                	li	a0,1
    80004f44:	acbfd0ef          	jal	80002a0e <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004f48:	fe840613          	addi	a2,s0,-24
    80004f4c:	4581                	li	a1,0
    80004f4e:	4501                	li	a0,0
    80004f50:	cf7ff0ef          	jal	80004c46 <argfd>
    80004f54:	87aa                	mv	a5,a0
    return -1;
    80004f56:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004f58:	0007c863          	bltz	a5,80004f68 <sys_fstat+0x32>
  return filestat(f, st);
    80004f5c:	fe043583          	ld	a1,-32(s0)
    80004f60:	fe843503          	ld	a0,-24(s0)
    80004f64:	c34ff0ef          	jal	80004398 <filestat>
}
    80004f68:	60e2                	ld	ra,24(sp)
    80004f6a:	6442                	ld	s0,16(sp)
    80004f6c:	6105                	addi	sp,sp,32
    80004f6e:	8082                	ret

0000000080004f70 <sys_link>:
{
    80004f70:	7169                	addi	sp,sp,-304
    80004f72:	f606                	sd	ra,296(sp)
    80004f74:	f222                	sd	s0,288(sp)
    80004f76:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f78:	08000613          	li	a2,128
    80004f7c:	ed040593          	addi	a1,s0,-304
    80004f80:	4501                	li	a0,0
    80004f82:	aa9fd0ef          	jal	80002a2a <argstr>
    return -1;
    80004f86:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f88:	0c054e63          	bltz	a0,80005064 <sys_link+0xf4>
    80004f8c:	08000613          	li	a2,128
    80004f90:	f5040593          	addi	a1,s0,-176
    80004f94:	4505                	li	a0,1
    80004f96:	a95fd0ef          	jal	80002a2a <argstr>
    return -1;
    80004f9a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f9c:	0c054463          	bltz	a0,80005064 <sys_link+0xf4>
    80004fa0:	ee26                	sd	s1,280(sp)
  begin_op();
    80004fa2:	f17fe0ef          	jal	80003eb8 <begin_op>
  if((ip = namei(old)) == 0){
    80004fa6:	ed040513          	addi	a0,s0,-304
    80004faa:	d53fe0ef          	jal	80003cfc <namei>
    80004fae:	84aa                	mv	s1,a0
    80004fb0:	c53d                	beqz	a0,8000501e <sys_link+0xae>
  ilock(ip);
    80004fb2:	e70fe0ef          	jal	80003622 <ilock>
  if(ip->type == T_DIR){
    80004fb6:	04449703          	lh	a4,68(s1)
    80004fba:	4785                	li	a5,1
    80004fbc:	06f70663          	beq	a4,a5,80005028 <sys_link+0xb8>
    80004fc0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004fc2:	04a4d783          	lhu	a5,74(s1)
    80004fc6:	2785                	addiw	a5,a5,1
    80004fc8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004fcc:	8526                	mv	a0,s1
    80004fce:	da0fe0ef          	jal	8000356e <iupdate>
  iunlock(ip);
    80004fd2:	8526                	mv	a0,s1
    80004fd4:	efcfe0ef          	jal	800036d0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004fd8:	fd040593          	addi	a1,s0,-48
    80004fdc:	f5040513          	addi	a0,s0,-176
    80004fe0:	d37fe0ef          	jal	80003d16 <nameiparent>
    80004fe4:	892a                	mv	s2,a0
    80004fe6:	cd21                	beqz	a0,8000503e <sys_link+0xce>
  ilock(dp);
    80004fe8:	e3afe0ef          	jal	80003622 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004fec:	00092703          	lw	a4,0(s2)
    80004ff0:	409c                	lw	a5,0(s1)
    80004ff2:	04f71363          	bne	a4,a5,80005038 <sys_link+0xc8>
    80004ff6:	40d0                	lw	a2,4(s1)
    80004ff8:	fd040593          	addi	a1,s0,-48
    80004ffc:	854a                	mv	a0,s2
    80004ffe:	c65fe0ef          	jal	80003c62 <dirlink>
    80005002:	02054b63          	bltz	a0,80005038 <sys_link+0xc8>
  iunlockput(dp);
    80005006:	854a                	mv	a0,s2
    80005008:	825fe0ef          	jal	8000382c <iunlockput>
  iput(ip);
    8000500c:	8526                	mv	a0,s1
    8000500e:	f96fe0ef          	jal	800037a4 <iput>
  end_op();
    80005012:	f11fe0ef          	jal	80003f22 <end_op>
  return 0;
    80005016:	4781                	li	a5,0
    80005018:	64f2                	ld	s1,280(sp)
    8000501a:	6952                	ld	s2,272(sp)
    8000501c:	a0a1                	j	80005064 <sys_link+0xf4>
    end_op();
    8000501e:	f05fe0ef          	jal	80003f22 <end_op>
    return -1;
    80005022:	57fd                	li	a5,-1
    80005024:	64f2                	ld	s1,280(sp)
    80005026:	a83d                	j	80005064 <sys_link+0xf4>
    iunlockput(ip);
    80005028:	8526                	mv	a0,s1
    8000502a:	803fe0ef          	jal	8000382c <iunlockput>
    end_op();
    8000502e:	ef5fe0ef          	jal	80003f22 <end_op>
    return -1;
    80005032:	57fd                	li	a5,-1
    80005034:	64f2                	ld	s1,280(sp)
    80005036:	a03d                	j	80005064 <sys_link+0xf4>
    iunlockput(dp);
    80005038:	854a                	mv	a0,s2
    8000503a:	ff2fe0ef          	jal	8000382c <iunlockput>
  ilock(ip);
    8000503e:	8526                	mv	a0,s1
    80005040:	de2fe0ef          	jal	80003622 <ilock>
  ip->nlink--;
    80005044:	04a4d783          	lhu	a5,74(s1)
    80005048:	37fd                	addiw	a5,a5,-1
    8000504a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000504e:	8526                	mv	a0,s1
    80005050:	d1efe0ef          	jal	8000356e <iupdate>
  iunlockput(ip);
    80005054:	8526                	mv	a0,s1
    80005056:	fd6fe0ef          	jal	8000382c <iunlockput>
  end_op();
    8000505a:	ec9fe0ef          	jal	80003f22 <end_op>
  return -1;
    8000505e:	57fd                	li	a5,-1
    80005060:	64f2                	ld	s1,280(sp)
    80005062:	6952                	ld	s2,272(sp)
}
    80005064:	853e                	mv	a0,a5
    80005066:	70b2                	ld	ra,296(sp)
    80005068:	7412                	ld	s0,288(sp)
    8000506a:	6155                	addi	sp,sp,304
    8000506c:	8082                	ret

000000008000506e <sys_unlink>:
{
    8000506e:	7151                	addi	sp,sp,-240
    80005070:	f586                	sd	ra,232(sp)
    80005072:	f1a2                	sd	s0,224(sp)
    80005074:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005076:	08000613          	li	a2,128
    8000507a:	f3040593          	addi	a1,s0,-208
    8000507e:	4501                	li	a0,0
    80005080:	9abfd0ef          	jal	80002a2a <argstr>
    80005084:	16054063          	bltz	a0,800051e4 <sys_unlink+0x176>
    80005088:	eda6                	sd	s1,216(sp)
  begin_op();
    8000508a:	e2ffe0ef          	jal	80003eb8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000508e:	fb040593          	addi	a1,s0,-80
    80005092:	f3040513          	addi	a0,s0,-208
    80005096:	c81fe0ef          	jal	80003d16 <nameiparent>
    8000509a:	84aa                	mv	s1,a0
    8000509c:	c945                	beqz	a0,8000514c <sys_unlink+0xde>
  ilock(dp);
    8000509e:	d84fe0ef          	jal	80003622 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800050a2:	00002597          	auipc	a1,0x2
    800050a6:	6b658593          	addi	a1,a1,1718 # 80007758 <etext+0x758>
    800050aa:	fb040513          	addi	a0,s0,-80
    800050ae:	9d3fe0ef          	jal	80003a80 <namecmp>
    800050b2:	10050e63          	beqz	a0,800051ce <sys_unlink+0x160>
    800050b6:	00002597          	auipc	a1,0x2
    800050ba:	6aa58593          	addi	a1,a1,1706 # 80007760 <etext+0x760>
    800050be:	fb040513          	addi	a0,s0,-80
    800050c2:	9bffe0ef          	jal	80003a80 <namecmp>
    800050c6:	10050463          	beqz	a0,800051ce <sys_unlink+0x160>
    800050ca:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800050cc:	f2c40613          	addi	a2,s0,-212
    800050d0:	fb040593          	addi	a1,s0,-80
    800050d4:	8526                	mv	a0,s1
    800050d6:	9c1fe0ef          	jal	80003a96 <dirlookup>
    800050da:	892a                	mv	s2,a0
    800050dc:	0e050863          	beqz	a0,800051cc <sys_unlink+0x15e>
  ilock(ip);
    800050e0:	d42fe0ef          	jal	80003622 <ilock>
  if(ip->nlink < 1)
    800050e4:	04a91783          	lh	a5,74(s2)
    800050e8:	06f05763          	blez	a5,80005156 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800050ec:	04491703          	lh	a4,68(s2)
    800050f0:	4785                	li	a5,1
    800050f2:	06f70963          	beq	a4,a5,80005164 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800050f6:	4641                	li	a2,16
    800050f8:	4581                	li	a1,0
    800050fa:	fc040513          	addi	a0,s0,-64
    800050fe:	bcbfb0ef          	jal	80000cc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005102:	4741                	li	a4,16
    80005104:	f2c42683          	lw	a3,-212(s0)
    80005108:	fc040613          	addi	a2,s0,-64
    8000510c:	4581                	li	a1,0
    8000510e:	8526                	mv	a0,s1
    80005110:	863fe0ef          	jal	80003972 <writei>
    80005114:	47c1                	li	a5,16
    80005116:	08f51b63          	bne	a0,a5,800051ac <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    8000511a:	04491703          	lh	a4,68(s2)
    8000511e:	4785                	li	a5,1
    80005120:	08f70d63          	beq	a4,a5,800051ba <sys_unlink+0x14c>
  iunlockput(dp);
    80005124:	8526                	mv	a0,s1
    80005126:	f06fe0ef          	jal	8000382c <iunlockput>
  ip->nlink--;
    8000512a:	04a95783          	lhu	a5,74(s2)
    8000512e:	37fd                	addiw	a5,a5,-1
    80005130:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005134:	854a                	mv	a0,s2
    80005136:	c38fe0ef          	jal	8000356e <iupdate>
  iunlockput(ip);
    8000513a:	854a                	mv	a0,s2
    8000513c:	ef0fe0ef          	jal	8000382c <iunlockput>
  end_op();
    80005140:	de3fe0ef          	jal	80003f22 <end_op>
  return 0;
    80005144:	4501                	li	a0,0
    80005146:	64ee                	ld	s1,216(sp)
    80005148:	694e                	ld	s2,208(sp)
    8000514a:	a849                	j	800051dc <sys_unlink+0x16e>
    end_op();
    8000514c:	dd7fe0ef          	jal	80003f22 <end_op>
    return -1;
    80005150:	557d                	li	a0,-1
    80005152:	64ee                	ld	s1,216(sp)
    80005154:	a061                	j	800051dc <sys_unlink+0x16e>
    80005156:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005158:	00002517          	auipc	a0,0x2
    8000515c:	61050513          	addi	a0,a0,1552 # 80007768 <etext+0x768>
    80005160:	e34fb0ef          	jal	80000794 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005164:	04c92703          	lw	a4,76(s2)
    80005168:	02000793          	li	a5,32
    8000516c:	f8e7f5e3          	bgeu	a5,a4,800050f6 <sys_unlink+0x88>
    80005170:	e5ce                	sd	s3,200(sp)
    80005172:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005176:	4741                	li	a4,16
    80005178:	86ce                	mv	a3,s3
    8000517a:	f1840613          	addi	a2,s0,-232
    8000517e:	4581                	li	a1,0
    80005180:	854a                	mv	a0,s2
    80005182:	ef4fe0ef          	jal	80003876 <readi>
    80005186:	47c1                	li	a5,16
    80005188:	00f51c63          	bne	a0,a5,800051a0 <sys_unlink+0x132>
    if(de.inum != 0)
    8000518c:	f1845783          	lhu	a5,-232(s0)
    80005190:	efa1                	bnez	a5,800051e8 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005192:	29c1                	addiw	s3,s3,16
    80005194:	04c92783          	lw	a5,76(s2)
    80005198:	fcf9efe3          	bltu	s3,a5,80005176 <sys_unlink+0x108>
    8000519c:	69ae                	ld	s3,200(sp)
    8000519e:	bfa1                	j	800050f6 <sys_unlink+0x88>
      panic("isdirempty: readi");
    800051a0:	00002517          	auipc	a0,0x2
    800051a4:	5e050513          	addi	a0,a0,1504 # 80007780 <etext+0x780>
    800051a8:	decfb0ef          	jal	80000794 <panic>
    800051ac:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800051ae:	00002517          	auipc	a0,0x2
    800051b2:	5ea50513          	addi	a0,a0,1514 # 80007798 <etext+0x798>
    800051b6:	ddefb0ef          	jal	80000794 <panic>
    dp->nlink--;
    800051ba:	04a4d783          	lhu	a5,74(s1)
    800051be:	37fd                	addiw	a5,a5,-1
    800051c0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800051c4:	8526                	mv	a0,s1
    800051c6:	ba8fe0ef          	jal	8000356e <iupdate>
    800051ca:	bfa9                	j	80005124 <sys_unlink+0xb6>
    800051cc:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800051ce:	8526                	mv	a0,s1
    800051d0:	e5cfe0ef          	jal	8000382c <iunlockput>
  end_op();
    800051d4:	d4ffe0ef          	jal	80003f22 <end_op>
  return -1;
    800051d8:	557d                	li	a0,-1
    800051da:	64ee                	ld	s1,216(sp)
}
    800051dc:	70ae                	ld	ra,232(sp)
    800051de:	740e                	ld	s0,224(sp)
    800051e0:	616d                	addi	sp,sp,240
    800051e2:	8082                	ret
    return -1;
    800051e4:	557d                	li	a0,-1
    800051e6:	bfdd                	j	800051dc <sys_unlink+0x16e>
    iunlockput(ip);
    800051e8:	854a                	mv	a0,s2
    800051ea:	e42fe0ef          	jal	8000382c <iunlockput>
    goto bad;
    800051ee:	694e                	ld	s2,208(sp)
    800051f0:	69ae                	ld	s3,200(sp)
    800051f2:	bff1                	j	800051ce <sys_unlink+0x160>

00000000800051f4 <sys_open>:

uint64
sys_open(void)
{
    800051f4:	7131                	addi	sp,sp,-192
    800051f6:	fd06                	sd	ra,184(sp)
    800051f8:	f922                	sd	s0,176(sp)
    800051fa:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800051fc:	f4c40593          	addi	a1,s0,-180
    80005200:	4505                	li	a0,1
    80005202:	fcafd0ef          	jal	800029cc <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005206:	08000613          	li	a2,128
    8000520a:	f5040593          	addi	a1,s0,-176
    8000520e:	4501                	li	a0,0
    80005210:	81bfd0ef          	jal	80002a2a <argstr>
    80005214:	87aa                	mv	a5,a0
    return -1;
    80005216:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005218:	0a07c263          	bltz	a5,800052bc <sys_open+0xc8>
    8000521c:	f526                	sd	s1,168(sp)

  begin_op();
    8000521e:	c9bfe0ef          	jal	80003eb8 <begin_op>

  if(omode & O_CREATE){
    80005222:	f4c42783          	lw	a5,-180(s0)
    80005226:	2007f793          	andi	a5,a5,512
    8000522a:	c3d5                	beqz	a5,800052ce <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    8000522c:	4681                	li	a3,0
    8000522e:	4601                	li	a2,0
    80005230:	4589                	li	a1,2
    80005232:	f5040513          	addi	a0,s0,-176
    80005236:	aa7ff0ef          	jal	80004cdc <create>
    8000523a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000523c:	c541                	beqz	a0,800052c4 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000523e:	04449703          	lh	a4,68(s1)
    80005242:	478d                	li	a5,3
    80005244:	00f71763          	bne	a4,a5,80005252 <sys_open+0x5e>
    80005248:	0464d703          	lhu	a4,70(s1)
    8000524c:	47a5                	li	a5,9
    8000524e:	0ae7ed63          	bltu	a5,a4,80005308 <sys_open+0x114>
    80005252:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005254:	fdffe0ef          	jal	80004232 <filealloc>
    80005258:	892a                	mv	s2,a0
    8000525a:	c179                	beqz	a0,80005320 <sys_open+0x12c>
    8000525c:	ed4e                	sd	s3,152(sp)
    8000525e:	a41ff0ef          	jal	80004c9e <fdalloc>
    80005262:	89aa                	mv	s3,a0
    80005264:	0a054a63          	bltz	a0,80005318 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005268:	04449703          	lh	a4,68(s1)
    8000526c:	478d                	li	a5,3
    8000526e:	0cf70263          	beq	a4,a5,80005332 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005272:	4789                	li	a5,2
    80005274:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005278:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000527c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005280:	f4c42783          	lw	a5,-180(s0)
    80005284:	0017c713          	xori	a4,a5,1
    80005288:	8b05                	andi	a4,a4,1
    8000528a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000528e:	0037f713          	andi	a4,a5,3
    80005292:	00e03733          	snez	a4,a4
    80005296:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000529a:	4007f793          	andi	a5,a5,1024
    8000529e:	c791                	beqz	a5,800052aa <sys_open+0xb6>
    800052a0:	04449703          	lh	a4,68(s1)
    800052a4:	4789                	li	a5,2
    800052a6:	08f70d63          	beq	a4,a5,80005340 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800052aa:	8526                	mv	a0,s1
    800052ac:	c24fe0ef          	jal	800036d0 <iunlock>
  end_op();
    800052b0:	c73fe0ef          	jal	80003f22 <end_op>

  return fd;
    800052b4:	854e                	mv	a0,s3
    800052b6:	74aa                	ld	s1,168(sp)
    800052b8:	790a                	ld	s2,160(sp)
    800052ba:	69ea                	ld	s3,152(sp)
}
    800052bc:	70ea                	ld	ra,184(sp)
    800052be:	744a                	ld	s0,176(sp)
    800052c0:	6129                	addi	sp,sp,192
    800052c2:	8082                	ret
      end_op();
    800052c4:	c5ffe0ef          	jal	80003f22 <end_op>
      return -1;
    800052c8:	557d                	li	a0,-1
    800052ca:	74aa                	ld	s1,168(sp)
    800052cc:	bfc5                	j	800052bc <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800052ce:	f5040513          	addi	a0,s0,-176
    800052d2:	a2bfe0ef          	jal	80003cfc <namei>
    800052d6:	84aa                	mv	s1,a0
    800052d8:	c11d                	beqz	a0,800052fe <sys_open+0x10a>
    ilock(ip);
    800052da:	b48fe0ef          	jal	80003622 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800052de:	04449703          	lh	a4,68(s1)
    800052e2:	4785                	li	a5,1
    800052e4:	f4f71de3          	bne	a4,a5,8000523e <sys_open+0x4a>
    800052e8:	f4c42783          	lw	a5,-180(s0)
    800052ec:	d3bd                	beqz	a5,80005252 <sys_open+0x5e>
      iunlockput(ip);
    800052ee:	8526                	mv	a0,s1
    800052f0:	d3cfe0ef          	jal	8000382c <iunlockput>
      end_op();
    800052f4:	c2ffe0ef          	jal	80003f22 <end_op>
      return -1;
    800052f8:	557d                	li	a0,-1
    800052fa:	74aa                	ld	s1,168(sp)
    800052fc:	b7c1                	j	800052bc <sys_open+0xc8>
      end_op();
    800052fe:	c25fe0ef          	jal	80003f22 <end_op>
      return -1;
    80005302:	557d                	li	a0,-1
    80005304:	74aa                	ld	s1,168(sp)
    80005306:	bf5d                	j	800052bc <sys_open+0xc8>
    iunlockput(ip);
    80005308:	8526                	mv	a0,s1
    8000530a:	d22fe0ef          	jal	8000382c <iunlockput>
    end_op();
    8000530e:	c15fe0ef          	jal	80003f22 <end_op>
    return -1;
    80005312:	557d                	li	a0,-1
    80005314:	74aa                	ld	s1,168(sp)
    80005316:	b75d                	j	800052bc <sys_open+0xc8>
      fileclose(f);
    80005318:	854a                	mv	a0,s2
    8000531a:	fbdfe0ef          	jal	800042d6 <fileclose>
    8000531e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005320:	8526                	mv	a0,s1
    80005322:	d0afe0ef          	jal	8000382c <iunlockput>
    end_op();
    80005326:	bfdfe0ef          	jal	80003f22 <end_op>
    return -1;
    8000532a:	557d                	li	a0,-1
    8000532c:	74aa                	ld	s1,168(sp)
    8000532e:	790a                	ld	s2,160(sp)
    80005330:	b771                	j	800052bc <sys_open+0xc8>
    f->type = FD_DEVICE;
    80005332:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005336:	04649783          	lh	a5,70(s1)
    8000533a:	02f91223          	sh	a5,36(s2)
    8000533e:	bf3d                	j	8000527c <sys_open+0x88>
    itrunc(ip);
    80005340:	8526                	mv	a0,s1
    80005342:	bcefe0ef          	jal	80003710 <itrunc>
    80005346:	b795                	j	800052aa <sys_open+0xb6>

0000000080005348 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005348:	7175                	addi	sp,sp,-144
    8000534a:	e506                	sd	ra,136(sp)
    8000534c:	e122                	sd	s0,128(sp)
    8000534e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005350:	b69fe0ef          	jal	80003eb8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005354:	08000613          	li	a2,128
    80005358:	f7040593          	addi	a1,s0,-144
    8000535c:	4501                	li	a0,0
    8000535e:	eccfd0ef          	jal	80002a2a <argstr>
    80005362:	02054363          	bltz	a0,80005388 <sys_mkdir+0x40>
    80005366:	4681                	li	a3,0
    80005368:	4601                	li	a2,0
    8000536a:	4585                	li	a1,1
    8000536c:	f7040513          	addi	a0,s0,-144
    80005370:	96dff0ef          	jal	80004cdc <create>
    80005374:	c911                	beqz	a0,80005388 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005376:	cb6fe0ef          	jal	8000382c <iunlockput>
  end_op();
    8000537a:	ba9fe0ef          	jal	80003f22 <end_op>
  return 0;
    8000537e:	4501                	li	a0,0
}
    80005380:	60aa                	ld	ra,136(sp)
    80005382:	640a                	ld	s0,128(sp)
    80005384:	6149                	addi	sp,sp,144
    80005386:	8082                	ret
    end_op();
    80005388:	b9bfe0ef          	jal	80003f22 <end_op>
    return -1;
    8000538c:	557d                	li	a0,-1
    8000538e:	bfcd                	j	80005380 <sys_mkdir+0x38>

0000000080005390 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005390:	7135                	addi	sp,sp,-160
    80005392:	ed06                	sd	ra,152(sp)
    80005394:	e922                	sd	s0,144(sp)
    80005396:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005398:	b21fe0ef          	jal	80003eb8 <begin_op>
  argint(1, &major);
    8000539c:	f6c40593          	addi	a1,s0,-148
    800053a0:	4505                	li	a0,1
    800053a2:	e2afd0ef          	jal	800029cc <argint>
  argint(2, &minor);
    800053a6:	f6840593          	addi	a1,s0,-152
    800053aa:	4509                	li	a0,2
    800053ac:	e20fd0ef          	jal	800029cc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800053b0:	08000613          	li	a2,128
    800053b4:	f7040593          	addi	a1,s0,-144
    800053b8:	4501                	li	a0,0
    800053ba:	e70fd0ef          	jal	80002a2a <argstr>
    800053be:	02054563          	bltz	a0,800053e8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800053c2:	f6841683          	lh	a3,-152(s0)
    800053c6:	f6c41603          	lh	a2,-148(s0)
    800053ca:	458d                	li	a1,3
    800053cc:	f7040513          	addi	a0,s0,-144
    800053d0:	90dff0ef          	jal	80004cdc <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800053d4:	c911                	beqz	a0,800053e8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800053d6:	c56fe0ef          	jal	8000382c <iunlockput>
  end_op();
    800053da:	b49fe0ef          	jal	80003f22 <end_op>
  return 0;
    800053de:	4501                	li	a0,0
}
    800053e0:	60ea                	ld	ra,152(sp)
    800053e2:	644a                	ld	s0,144(sp)
    800053e4:	610d                	addi	sp,sp,160
    800053e6:	8082                	ret
    end_op();
    800053e8:	b3bfe0ef          	jal	80003f22 <end_op>
    return -1;
    800053ec:	557d                	li	a0,-1
    800053ee:	bfcd                	j	800053e0 <sys_mknod+0x50>

00000000800053f0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800053f0:	7135                	addi	sp,sp,-160
    800053f2:	ed06                	sd	ra,152(sp)
    800053f4:	e922                	sd	s0,144(sp)
    800053f6:	e14a                	sd	s2,128(sp)
    800053f8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800053fa:	c66fc0ef          	jal	80001860 <myproc>
    800053fe:	892a                	mv	s2,a0
  
  begin_op();
    80005400:	ab9fe0ef          	jal	80003eb8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005404:	08000613          	li	a2,128
    80005408:	f6040593          	addi	a1,s0,-160
    8000540c:	4501                	li	a0,0
    8000540e:	e1cfd0ef          	jal	80002a2a <argstr>
    80005412:	04054363          	bltz	a0,80005458 <sys_chdir+0x68>
    80005416:	e526                	sd	s1,136(sp)
    80005418:	f6040513          	addi	a0,s0,-160
    8000541c:	8e1fe0ef          	jal	80003cfc <namei>
    80005420:	84aa                	mv	s1,a0
    80005422:	c915                	beqz	a0,80005456 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005424:	9fefe0ef          	jal	80003622 <ilock>
  if(ip->type != T_DIR){
    80005428:	04449703          	lh	a4,68(s1)
    8000542c:	4785                	li	a5,1
    8000542e:	02f71963          	bne	a4,a5,80005460 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005432:	8526                	mv	a0,s1
    80005434:	a9cfe0ef          	jal	800036d0 <iunlock>
  iput(p->cwd);
    80005438:	69893503          	ld	a0,1688(s2)
    8000543c:	b68fe0ef          	jal	800037a4 <iput>
  end_op();
    80005440:	ae3fe0ef          	jal	80003f22 <end_op>
  p->cwd = ip;
    80005444:	68993c23          	sd	s1,1688(s2)
  return 0;
    80005448:	4501                	li	a0,0
    8000544a:	64aa                	ld	s1,136(sp)
}
    8000544c:	60ea                	ld	ra,152(sp)
    8000544e:	644a                	ld	s0,144(sp)
    80005450:	690a                	ld	s2,128(sp)
    80005452:	610d                	addi	sp,sp,160
    80005454:	8082                	ret
    80005456:	64aa                	ld	s1,136(sp)
    end_op();
    80005458:	acbfe0ef          	jal	80003f22 <end_op>
    return -1;
    8000545c:	557d                	li	a0,-1
    8000545e:	b7fd                	j	8000544c <sys_chdir+0x5c>
    iunlockput(ip);
    80005460:	8526                	mv	a0,s1
    80005462:	bcafe0ef          	jal	8000382c <iunlockput>
    end_op();
    80005466:	abdfe0ef          	jal	80003f22 <end_op>
    return -1;
    8000546a:	557d                	li	a0,-1
    8000546c:	64aa                	ld	s1,136(sp)
    8000546e:	bff9                	j	8000544c <sys_chdir+0x5c>

0000000080005470 <sys_exec>:

uint64
sys_exec(void)
{
    80005470:	7121                	addi	sp,sp,-448
    80005472:	ff06                	sd	ra,440(sp)
    80005474:	fb22                	sd	s0,432(sp)
    80005476:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005478:	e4840593          	addi	a1,s0,-440
    8000547c:	4505                	li	a0,1
    8000547e:	d90fd0ef          	jal	80002a0e <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005482:	08000613          	li	a2,128
    80005486:	f5040593          	addi	a1,s0,-176
    8000548a:	4501                	li	a0,0
    8000548c:	d9efd0ef          	jal	80002a2a <argstr>
    80005490:	87aa                	mv	a5,a0
    return -1;
    80005492:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005494:	0c07c463          	bltz	a5,8000555c <sys_exec+0xec>
    80005498:	f726                	sd	s1,424(sp)
    8000549a:	f34a                	sd	s2,416(sp)
    8000549c:	ef4e                	sd	s3,408(sp)
    8000549e:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800054a0:	10000613          	li	a2,256
    800054a4:	4581                	li	a1,0
    800054a6:	e5040513          	addi	a0,s0,-432
    800054aa:	81ffb0ef          	jal	80000cc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800054ae:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800054b2:	89a6                	mv	s3,s1
    800054b4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800054b6:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800054ba:	00391513          	slli	a0,s2,0x3
    800054be:	e4040593          	addi	a1,s0,-448
    800054c2:	e4843783          	ld	a5,-440(s0)
    800054c6:	953e                	add	a0,a0,a5
    800054c8:	c74fd0ef          	jal	8000293c <fetchaddr>
    800054cc:	02054663          	bltz	a0,800054f8 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800054d0:	e4043783          	ld	a5,-448(s0)
    800054d4:	c3a9                	beqz	a5,80005516 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800054d6:	e4efb0ef          	jal	80000b24 <kalloc>
    800054da:	85aa                	mv	a1,a0
    800054dc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800054e0:	cd01                	beqz	a0,800054f8 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800054e2:	6605                	lui	a2,0x1
    800054e4:	e4043503          	ld	a0,-448(s0)
    800054e8:	ca2fd0ef          	jal	8000298a <fetchstr>
    800054ec:	00054663          	bltz	a0,800054f8 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800054f0:	0905                	addi	s2,s2,1
    800054f2:	09a1                	addi	s3,s3,8
    800054f4:	fd4913e3          	bne	s2,s4,800054ba <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054f8:	f5040913          	addi	s2,s0,-176
    800054fc:	6088                	ld	a0,0(s1)
    800054fe:	c931                	beqz	a0,80005552 <sys_exec+0xe2>
    kfree(argv[i]);
    80005500:	d42fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005504:	04a1                	addi	s1,s1,8
    80005506:	ff249be3          	bne	s1,s2,800054fc <sys_exec+0x8c>
  return -1;
    8000550a:	557d                	li	a0,-1
    8000550c:	74ba                	ld	s1,424(sp)
    8000550e:	791a                	ld	s2,416(sp)
    80005510:	69fa                	ld	s3,408(sp)
    80005512:	6a5a                	ld	s4,400(sp)
    80005514:	a0a1                	j	8000555c <sys_exec+0xec>
      argv[i] = 0;
    80005516:	0009079b          	sext.w	a5,s2
    8000551a:	078e                	slli	a5,a5,0x3
    8000551c:	fd078793          	addi	a5,a5,-48
    80005520:	97a2                	add	a5,a5,s0
    80005522:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005526:	e5040593          	addi	a1,s0,-432
    8000552a:	f5040513          	addi	a0,s0,-176
    8000552e:	ba6ff0ef          	jal	800048d4 <exec>
    80005532:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005534:	f5040993          	addi	s3,s0,-176
    80005538:	6088                	ld	a0,0(s1)
    8000553a:	c511                	beqz	a0,80005546 <sys_exec+0xd6>
    kfree(argv[i]);
    8000553c:	d06fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005540:	04a1                	addi	s1,s1,8
    80005542:	ff349be3          	bne	s1,s3,80005538 <sys_exec+0xc8>
  return ret;
    80005546:	854a                	mv	a0,s2
    80005548:	74ba                	ld	s1,424(sp)
    8000554a:	791a                	ld	s2,416(sp)
    8000554c:	69fa                	ld	s3,408(sp)
    8000554e:	6a5a                	ld	s4,400(sp)
    80005550:	a031                	j	8000555c <sys_exec+0xec>
  return -1;
    80005552:	557d                	li	a0,-1
    80005554:	74ba                	ld	s1,424(sp)
    80005556:	791a                	ld	s2,416(sp)
    80005558:	69fa                	ld	s3,408(sp)
    8000555a:	6a5a                	ld	s4,400(sp)
}
    8000555c:	70fa                	ld	ra,440(sp)
    8000555e:	745a                	ld	s0,432(sp)
    80005560:	6139                	addi	sp,sp,448
    80005562:	8082                	ret

0000000080005564 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005564:	7139                	addi	sp,sp,-64
    80005566:	fc06                	sd	ra,56(sp)
    80005568:	f822                	sd	s0,48(sp)
    8000556a:	f426                	sd	s1,40(sp)
    8000556c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000556e:	af2fc0ef          	jal	80001860 <myproc>
    80005572:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005574:	fd840593          	addi	a1,s0,-40
    80005578:	4501                	li	a0,0
    8000557a:	c94fd0ef          	jal	80002a0e <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000557e:	fc840593          	addi	a1,s0,-56
    80005582:	fd040513          	addi	a0,s0,-48
    80005586:	85aff0ef          	jal	800045e0 <pipealloc>
    return -1;
    8000558a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000558c:	0a054963          	bltz	a0,8000563e <sys_pipe+0xda>
  fd0 = -1;
    80005590:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005594:	fd043503          	ld	a0,-48(s0)
    80005598:	f06ff0ef          	jal	80004c9e <fdalloc>
    8000559c:	fca42223          	sw	a0,-60(s0)
    800055a0:	08054663          	bltz	a0,8000562c <sys_pipe+0xc8>
    800055a4:	fc843503          	ld	a0,-56(s0)
    800055a8:	ef6ff0ef          	jal	80004c9e <fdalloc>
    800055ac:	fca42023          	sw	a0,-64(s0)
    800055b0:	06054463          	bltz	a0,80005618 <sys_pipe+0xb4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800055b4:	4691                	li	a3,4
    800055b6:	fc440613          	addi	a2,s0,-60
    800055ba:	fd843583          	ld	a1,-40(s0)
    800055be:	5984b503          	ld	a0,1432(s1)
    800055c2:	f91fb0ef          	jal	80001552 <copyout>
    800055c6:	00054f63          	bltz	a0,800055e4 <sys_pipe+0x80>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800055ca:	4691                	li	a3,4
    800055cc:	fc040613          	addi	a2,s0,-64
    800055d0:	fd843583          	ld	a1,-40(s0)
    800055d4:	0591                	addi	a1,a1,4
    800055d6:	5984b503          	ld	a0,1432(s1)
    800055da:	f79fb0ef          	jal	80001552 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800055de:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800055e0:	04055f63          	bgez	a0,8000563e <sys_pipe+0xda>
    p->ofile[fd0] = 0;
    800055e4:	fc442783          	lw	a5,-60(s0)
    800055e8:	0c278793          	addi	a5,a5,194
    800055ec:	078e                	slli	a5,a5,0x3
    800055ee:	97a6                	add	a5,a5,s1
    800055f0:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800055f4:	fc042783          	lw	a5,-64(s0)
    800055f8:	0c278793          	addi	a5,a5,194
    800055fc:	078e                	slli	a5,a5,0x3
    800055fe:	94be                	add	s1,s1,a5
    80005600:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005604:	fd043503          	ld	a0,-48(s0)
    80005608:	ccffe0ef          	jal	800042d6 <fileclose>
    fileclose(wf);
    8000560c:	fc843503          	ld	a0,-56(s0)
    80005610:	cc7fe0ef          	jal	800042d6 <fileclose>
    return -1;
    80005614:	57fd                	li	a5,-1
    80005616:	a025                	j	8000563e <sys_pipe+0xda>
    if(fd0 >= 0)
    80005618:	fc442783          	lw	a5,-60(s0)
    8000561c:	0007c863          	bltz	a5,8000562c <sys_pipe+0xc8>
      p->ofile[fd0] = 0;
    80005620:	0c278793          	addi	a5,a5,194
    80005624:	078e                	slli	a5,a5,0x3
    80005626:	97a6                	add	a5,a5,s1
    80005628:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    8000562c:	fd043503          	ld	a0,-48(s0)
    80005630:	ca7fe0ef          	jal	800042d6 <fileclose>
    fileclose(wf);
    80005634:	fc843503          	ld	a0,-56(s0)
    80005638:	c9ffe0ef          	jal	800042d6 <fileclose>
    return -1;
    8000563c:	57fd                	li	a5,-1
}
    8000563e:	853e                	mv	a0,a5
    80005640:	70e2                	ld	ra,56(sp)
    80005642:	7442                	ld	s0,48(sp)
    80005644:	74a2                	ld	s1,40(sp)
    80005646:	6121                	addi	sp,sp,64
    80005648:	8082                	ret
    8000564a:	0000                	unimp
    8000564c:	0000                	unimp
	...

0000000080005650 <kernelvec>:
    80005650:	7111                	addi	sp,sp,-256
    80005652:	e006                	sd	ra,0(sp)
    80005654:	e40a                	sd	sp,8(sp)
    80005656:	e80e                	sd	gp,16(sp)
    80005658:	ec12                	sd	tp,24(sp)
    8000565a:	f016                	sd	t0,32(sp)
    8000565c:	f41a                	sd	t1,40(sp)
    8000565e:	f81e                	sd	t2,48(sp)
    80005660:	e4aa                	sd	a0,72(sp)
    80005662:	e8ae                	sd	a1,80(sp)
    80005664:	ecb2                	sd	a2,88(sp)
    80005666:	f0b6                	sd	a3,96(sp)
    80005668:	f4ba                	sd	a4,104(sp)
    8000566a:	f8be                	sd	a5,112(sp)
    8000566c:	fcc2                	sd	a6,120(sp)
    8000566e:	e146                	sd	a7,128(sp)
    80005670:	edf2                	sd	t3,216(sp)
    80005672:	f1f6                	sd	t4,224(sp)
    80005674:	f5fa                	sd	t5,232(sp)
    80005676:	f9fe                	sd	t6,240(sp)
    80005678:	9c8fd0ef          	jal	80002840 <kerneltrap>
    8000567c:	6082                	ld	ra,0(sp)
    8000567e:	6122                	ld	sp,8(sp)
    80005680:	61c2                	ld	gp,16(sp)
    80005682:	7282                	ld	t0,32(sp)
    80005684:	7322                	ld	t1,40(sp)
    80005686:	73c2                	ld	t2,48(sp)
    80005688:	6526                	ld	a0,72(sp)
    8000568a:	65c6                	ld	a1,80(sp)
    8000568c:	6666                	ld	a2,88(sp)
    8000568e:	7686                	ld	a3,96(sp)
    80005690:	7726                	ld	a4,104(sp)
    80005692:	77c6                	ld	a5,112(sp)
    80005694:	7866                	ld	a6,120(sp)
    80005696:	688a                	ld	a7,128(sp)
    80005698:	6e6e                	ld	t3,216(sp)
    8000569a:	7e8e                	ld	t4,224(sp)
    8000569c:	7f2e                	ld	t5,232(sp)
    8000569e:	7fce                	ld	t6,240(sp)
    800056a0:	6111                	addi	sp,sp,256
    800056a2:	10200073          	sret
	...

00000000800056ae <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800056ae:	1141                	addi	sp,sp,-16
    800056b0:	e422                	sd	s0,8(sp)
    800056b2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800056b4:	0c0007b7          	lui	a5,0xc000
    800056b8:	4705                	li	a4,1
    800056ba:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800056bc:	0c0007b7          	lui	a5,0xc000
    800056c0:	c3d8                	sw	a4,4(a5)
}
    800056c2:	6422                	ld	s0,8(sp)
    800056c4:	0141                	addi	sp,sp,16
    800056c6:	8082                	ret

00000000800056c8 <plicinithart>:

void
plicinithart(void)
{
    800056c8:	1141                	addi	sp,sp,-16
    800056ca:	e406                	sd	ra,8(sp)
    800056cc:	e022                	sd	s0,0(sp)
    800056ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800056d0:	964fc0ef          	jal	80001834 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800056d4:	0085171b          	slliw	a4,a0,0x8
    800056d8:	0c0027b7          	lui	a5,0xc002
    800056dc:	97ba                	add	a5,a5,a4
    800056de:	40200713          	li	a4,1026
    800056e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800056e6:	00d5151b          	slliw	a0,a0,0xd
    800056ea:	0c2017b7          	lui	a5,0xc201
    800056ee:	97aa                	add	a5,a5,a0
    800056f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800056f4:	60a2                	ld	ra,8(sp)
    800056f6:	6402                	ld	s0,0(sp)
    800056f8:	0141                	addi	sp,sp,16
    800056fa:	8082                	ret

00000000800056fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800056fc:	1141                	addi	sp,sp,-16
    800056fe:	e406                	sd	ra,8(sp)
    80005700:	e022                	sd	s0,0(sp)
    80005702:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005704:	930fc0ef          	jal	80001834 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005708:	00d5151b          	slliw	a0,a0,0xd
    8000570c:	0c2017b7          	lui	a5,0xc201
    80005710:	97aa                	add	a5,a5,a0
  return irq;
}
    80005712:	43c8                	lw	a0,4(a5)
    80005714:	60a2                	ld	ra,8(sp)
    80005716:	6402                	ld	s0,0(sp)
    80005718:	0141                	addi	sp,sp,16
    8000571a:	8082                	ret

000000008000571c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000571c:	1101                	addi	sp,sp,-32
    8000571e:	ec06                	sd	ra,24(sp)
    80005720:	e822                	sd	s0,16(sp)
    80005722:	e426                	sd	s1,8(sp)
    80005724:	1000                	addi	s0,sp,32
    80005726:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005728:	90cfc0ef          	jal	80001834 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000572c:	00d5151b          	slliw	a0,a0,0xd
    80005730:	0c2017b7          	lui	a5,0xc201
    80005734:	97aa                	add	a5,a5,a0
    80005736:	c3c4                	sw	s1,4(a5)
}
    80005738:	60e2                	ld	ra,24(sp)
    8000573a:	6442                	ld	s0,16(sp)
    8000573c:	64a2                	ld	s1,8(sp)
    8000573e:	6105                	addi	sp,sp,32
    80005740:	8082                	ret

0000000080005742 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005742:	1141                	addi	sp,sp,-16
    80005744:	e406                	sd	ra,8(sp)
    80005746:	e022                	sd	s0,0(sp)
    80005748:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000574a:	479d                	li	a5,7
    8000574c:	04a7ca63          	blt	a5,a0,800057a0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005750:	00033797          	auipc	a5,0x33
    80005754:	75878793          	addi	a5,a5,1880 # 80038ea8 <disk>
    80005758:	97aa                	add	a5,a5,a0
    8000575a:	0187c783          	lbu	a5,24(a5)
    8000575e:	e7b9                	bnez	a5,800057ac <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005760:	00451693          	slli	a3,a0,0x4
    80005764:	00033797          	auipc	a5,0x33
    80005768:	74478793          	addi	a5,a5,1860 # 80038ea8 <disk>
    8000576c:	6398                	ld	a4,0(a5)
    8000576e:	9736                	add	a4,a4,a3
    80005770:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005774:	6398                	ld	a4,0(a5)
    80005776:	9736                	add	a4,a4,a3
    80005778:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000577c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005780:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005784:	97aa                	add	a5,a5,a0
    80005786:	4705                	li	a4,1
    80005788:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000578c:	00033517          	auipc	a0,0x33
    80005790:	73450513          	addi	a0,a0,1844 # 80038ec0 <disk+0x18>
    80005794:	f22fc0ef          	jal	80001eb6 <wakeup>
}
    80005798:	60a2                	ld	ra,8(sp)
    8000579a:	6402                	ld	s0,0(sp)
    8000579c:	0141                	addi	sp,sp,16
    8000579e:	8082                	ret
    panic("free_desc 1");
    800057a0:	00002517          	auipc	a0,0x2
    800057a4:	00850513          	addi	a0,a0,8 # 800077a8 <etext+0x7a8>
    800057a8:	fedfa0ef          	jal	80000794 <panic>
    panic("free_desc 2");
    800057ac:	00002517          	auipc	a0,0x2
    800057b0:	00c50513          	addi	a0,a0,12 # 800077b8 <etext+0x7b8>
    800057b4:	fe1fa0ef          	jal	80000794 <panic>

00000000800057b8 <virtio_disk_init>:
{
    800057b8:	1101                	addi	sp,sp,-32
    800057ba:	ec06                	sd	ra,24(sp)
    800057bc:	e822                	sd	s0,16(sp)
    800057be:	e426                	sd	s1,8(sp)
    800057c0:	e04a                	sd	s2,0(sp)
    800057c2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800057c4:	00002597          	auipc	a1,0x2
    800057c8:	00458593          	addi	a1,a1,4 # 800077c8 <etext+0x7c8>
    800057cc:	00034517          	auipc	a0,0x34
    800057d0:	80450513          	addi	a0,a0,-2044 # 80038fd0 <disk+0x128>
    800057d4:	ba0fb0ef          	jal	80000b74 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800057d8:	100017b7          	lui	a5,0x10001
    800057dc:	4398                	lw	a4,0(a5)
    800057de:	2701                	sext.w	a4,a4
    800057e0:	747277b7          	lui	a5,0x74727
    800057e4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800057e8:	18f71063          	bne	a4,a5,80005968 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800057ec:	100017b7          	lui	a5,0x10001
    800057f0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800057f2:	439c                	lw	a5,0(a5)
    800057f4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800057f6:	4709                	li	a4,2
    800057f8:	16e79863          	bne	a5,a4,80005968 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800057fc:	100017b7          	lui	a5,0x10001
    80005800:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005802:	439c                	lw	a5,0(a5)
    80005804:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005806:	16e79163          	bne	a5,a4,80005968 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000580a:	100017b7          	lui	a5,0x10001
    8000580e:	47d8                	lw	a4,12(a5)
    80005810:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005812:	554d47b7          	lui	a5,0x554d4
    80005816:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000581a:	14f71763          	bne	a4,a5,80005968 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000581e:	100017b7          	lui	a5,0x10001
    80005822:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005826:	4705                	li	a4,1
    80005828:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000582a:	470d                	li	a4,3
    8000582c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000582e:	10001737          	lui	a4,0x10001
    80005832:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005834:	c7ffe737          	lui	a4,0xc7ffe
    80005838:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fc5777>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000583c:	8ef9                	and	a3,a3,a4
    8000583e:	10001737          	lui	a4,0x10001
    80005842:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005844:	472d                	li	a4,11
    80005846:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005848:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000584c:	439c                	lw	a5,0(a5)
    8000584e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005852:	8ba1                	andi	a5,a5,8
    80005854:	12078063          	beqz	a5,80005974 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005858:	100017b7          	lui	a5,0x10001
    8000585c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005860:	100017b7          	lui	a5,0x10001
    80005864:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005868:	439c                	lw	a5,0(a5)
    8000586a:	2781                	sext.w	a5,a5
    8000586c:	10079a63          	bnez	a5,80005980 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005870:	100017b7          	lui	a5,0x10001
    80005874:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005878:	439c                	lw	a5,0(a5)
    8000587a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000587c:	10078863          	beqz	a5,8000598c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005880:	471d                	li	a4,7
    80005882:	10f77b63          	bgeu	a4,a5,80005998 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005886:	a9efb0ef          	jal	80000b24 <kalloc>
    8000588a:	00033497          	auipc	s1,0x33
    8000588e:	61e48493          	addi	s1,s1,1566 # 80038ea8 <disk>
    80005892:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005894:	a90fb0ef          	jal	80000b24 <kalloc>
    80005898:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000589a:	a8afb0ef          	jal	80000b24 <kalloc>
    8000589e:	87aa                	mv	a5,a0
    800058a0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800058a2:	6088                	ld	a0,0(s1)
    800058a4:	10050063          	beqz	a0,800059a4 <virtio_disk_init+0x1ec>
    800058a8:	00033717          	auipc	a4,0x33
    800058ac:	60873703          	ld	a4,1544(a4) # 80038eb0 <disk+0x8>
    800058b0:	0e070a63          	beqz	a4,800059a4 <virtio_disk_init+0x1ec>
    800058b4:	0e078863          	beqz	a5,800059a4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800058b8:	6605                	lui	a2,0x1
    800058ba:	4581                	li	a1,0
    800058bc:	c0cfb0ef          	jal	80000cc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    800058c0:	00033497          	auipc	s1,0x33
    800058c4:	5e848493          	addi	s1,s1,1512 # 80038ea8 <disk>
    800058c8:	6605                	lui	a2,0x1
    800058ca:	4581                	li	a1,0
    800058cc:	6488                	ld	a0,8(s1)
    800058ce:	bfafb0ef          	jal	80000cc8 <memset>
  memset(disk.used, 0, PGSIZE);
    800058d2:	6605                	lui	a2,0x1
    800058d4:	4581                	li	a1,0
    800058d6:	6888                	ld	a0,16(s1)
    800058d8:	bf0fb0ef          	jal	80000cc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800058dc:	100017b7          	lui	a5,0x10001
    800058e0:	4721                	li	a4,8
    800058e2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800058e4:	4098                	lw	a4,0(s1)
    800058e6:	100017b7          	lui	a5,0x10001
    800058ea:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800058ee:	40d8                	lw	a4,4(s1)
    800058f0:	100017b7          	lui	a5,0x10001
    800058f4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800058f8:	649c                	ld	a5,8(s1)
    800058fa:	0007869b          	sext.w	a3,a5
    800058fe:	10001737          	lui	a4,0x10001
    80005902:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005906:	9781                	srai	a5,a5,0x20
    80005908:	10001737          	lui	a4,0x10001
    8000590c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005910:	689c                	ld	a5,16(s1)
    80005912:	0007869b          	sext.w	a3,a5
    80005916:	10001737          	lui	a4,0x10001
    8000591a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000591e:	9781                	srai	a5,a5,0x20
    80005920:	10001737          	lui	a4,0x10001
    80005924:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005928:	10001737          	lui	a4,0x10001
    8000592c:	4785                	li	a5,1
    8000592e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005930:	00f48c23          	sb	a5,24(s1)
    80005934:	00f48ca3          	sb	a5,25(s1)
    80005938:	00f48d23          	sb	a5,26(s1)
    8000593c:	00f48da3          	sb	a5,27(s1)
    80005940:	00f48e23          	sb	a5,28(s1)
    80005944:	00f48ea3          	sb	a5,29(s1)
    80005948:	00f48f23          	sb	a5,30(s1)
    8000594c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005950:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005954:	100017b7          	lui	a5,0x10001
    80005958:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000595c:	60e2                	ld	ra,24(sp)
    8000595e:	6442                	ld	s0,16(sp)
    80005960:	64a2                	ld	s1,8(sp)
    80005962:	6902                	ld	s2,0(sp)
    80005964:	6105                	addi	sp,sp,32
    80005966:	8082                	ret
    panic("could not find virtio disk");
    80005968:	00002517          	auipc	a0,0x2
    8000596c:	e7050513          	addi	a0,a0,-400 # 800077d8 <etext+0x7d8>
    80005970:	e25fa0ef          	jal	80000794 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005974:	00002517          	auipc	a0,0x2
    80005978:	e8450513          	addi	a0,a0,-380 # 800077f8 <etext+0x7f8>
    8000597c:	e19fa0ef          	jal	80000794 <panic>
    panic("virtio disk should not be ready");
    80005980:	00002517          	auipc	a0,0x2
    80005984:	e9850513          	addi	a0,a0,-360 # 80007818 <etext+0x818>
    80005988:	e0dfa0ef          	jal	80000794 <panic>
    panic("virtio disk has no queue 0");
    8000598c:	00002517          	auipc	a0,0x2
    80005990:	eac50513          	addi	a0,a0,-340 # 80007838 <etext+0x838>
    80005994:	e01fa0ef          	jal	80000794 <panic>
    panic("virtio disk max queue too short");
    80005998:	00002517          	auipc	a0,0x2
    8000599c:	ec050513          	addi	a0,a0,-320 # 80007858 <etext+0x858>
    800059a0:	df5fa0ef          	jal	80000794 <panic>
    panic("virtio disk kalloc");
    800059a4:	00002517          	auipc	a0,0x2
    800059a8:	ed450513          	addi	a0,a0,-300 # 80007878 <etext+0x878>
    800059ac:	de9fa0ef          	jal	80000794 <panic>

00000000800059b0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800059b0:	7159                	addi	sp,sp,-112
    800059b2:	f486                	sd	ra,104(sp)
    800059b4:	f0a2                	sd	s0,96(sp)
    800059b6:	eca6                	sd	s1,88(sp)
    800059b8:	e8ca                	sd	s2,80(sp)
    800059ba:	e4ce                	sd	s3,72(sp)
    800059bc:	e0d2                	sd	s4,64(sp)
    800059be:	fc56                	sd	s5,56(sp)
    800059c0:	f85a                	sd	s6,48(sp)
    800059c2:	f45e                	sd	s7,40(sp)
    800059c4:	f062                	sd	s8,32(sp)
    800059c6:	ec66                	sd	s9,24(sp)
    800059c8:	1880                	addi	s0,sp,112
    800059ca:	8a2a                	mv	s4,a0
    800059cc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800059ce:	00c52c83          	lw	s9,12(a0)
    800059d2:	001c9c9b          	slliw	s9,s9,0x1
    800059d6:	1c82                	slli	s9,s9,0x20
    800059d8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800059dc:	00033517          	auipc	a0,0x33
    800059e0:	5f450513          	addi	a0,a0,1524 # 80038fd0 <disk+0x128>
    800059e4:	a10fb0ef          	jal	80000bf4 <acquire>
  for(int i = 0; i < 3; i++){
    800059e8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800059ea:	44a1                	li	s1,8
      disk.free[i] = 0;
    800059ec:	00033b17          	auipc	s6,0x33
    800059f0:	4bcb0b13          	addi	s6,s6,1212 # 80038ea8 <disk>
  for(int i = 0; i < 3; i++){
    800059f4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800059f6:	00033c17          	auipc	s8,0x33
    800059fa:	5dac0c13          	addi	s8,s8,1498 # 80038fd0 <disk+0x128>
    800059fe:	a8b9                	j	80005a5c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005a00:	00fb0733          	add	a4,s6,a5
    80005a04:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005a08:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005a0a:	0207c563          	bltz	a5,80005a34 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005a0e:	2905                	addiw	s2,s2,1
    80005a10:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005a12:	05590963          	beq	s2,s5,80005a64 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005a16:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005a18:	00033717          	auipc	a4,0x33
    80005a1c:	49070713          	addi	a4,a4,1168 # 80038ea8 <disk>
    80005a20:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005a22:	01874683          	lbu	a3,24(a4)
    80005a26:	fee9                	bnez	a3,80005a00 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005a28:	2785                	addiw	a5,a5,1
    80005a2a:	0705                	addi	a4,a4,1
    80005a2c:	fe979be3          	bne	a5,s1,80005a22 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005a30:	57fd                	li	a5,-1
    80005a32:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005a34:	01205d63          	blez	s2,80005a4e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005a38:	f9042503          	lw	a0,-112(s0)
    80005a3c:	d07ff0ef          	jal	80005742 <free_desc>
      for(int j = 0; j < i; j++)
    80005a40:	4785                	li	a5,1
    80005a42:	0127d663          	bge	a5,s2,80005a4e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005a46:	f9442503          	lw	a0,-108(s0)
    80005a4a:	cf9ff0ef          	jal	80005742 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005a4e:	85e2                	mv	a1,s8
    80005a50:	00033517          	auipc	a0,0x33
    80005a54:	47050513          	addi	a0,a0,1136 # 80038ec0 <disk+0x18>
    80005a58:	c10fc0ef          	jal	80001e68 <sleep>
  for(int i = 0; i < 3; i++){
    80005a5c:	f9040613          	addi	a2,s0,-112
    80005a60:	894e                	mv	s2,s3
    80005a62:	bf55                	j	80005a16 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a64:	f9042503          	lw	a0,-112(s0)
    80005a68:	00451693          	slli	a3,a0,0x4

  if(write)
    80005a6c:	00033797          	auipc	a5,0x33
    80005a70:	43c78793          	addi	a5,a5,1084 # 80038ea8 <disk>
    80005a74:	00a50713          	addi	a4,a0,10
    80005a78:	0712                	slli	a4,a4,0x4
    80005a7a:	973e                	add	a4,a4,a5
    80005a7c:	01703633          	snez	a2,s7
    80005a80:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005a82:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005a86:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a8a:	6398                	ld	a4,0(a5)
    80005a8c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a8e:	0a868613          	addi	a2,a3,168
    80005a92:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a94:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005a96:	6390                	ld	a2,0(a5)
    80005a98:	00d605b3          	add	a1,a2,a3
    80005a9c:	4741                	li	a4,16
    80005a9e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005aa0:	4805                	li	a6,1
    80005aa2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005aa6:	f9442703          	lw	a4,-108(s0)
    80005aaa:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005aae:	0712                	slli	a4,a4,0x4
    80005ab0:	963a                	add	a2,a2,a4
    80005ab2:	058a0593          	addi	a1,s4,88
    80005ab6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005ab8:	0007b883          	ld	a7,0(a5)
    80005abc:	9746                	add	a4,a4,a7
    80005abe:	40000613          	li	a2,1024
    80005ac2:	c710                	sw	a2,8(a4)
  if(write)
    80005ac4:	001bb613          	seqz	a2,s7
    80005ac8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005acc:	00166613          	ori	a2,a2,1
    80005ad0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005ad4:	f9842583          	lw	a1,-104(s0)
    80005ad8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005adc:	00250613          	addi	a2,a0,2
    80005ae0:	0612                	slli	a2,a2,0x4
    80005ae2:	963e                	add	a2,a2,a5
    80005ae4:	577d                	li	a4,-1
    80005ae6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005aea:	0592                	slli	a1,a1,0x4
    80005aec:	98ae                	add	a7,a7,a1
    80005aee:	03068713          	addi	a4,a3,48
    80005af2:	973e                	add	a4,a4,a5
    80005af4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005af8:	6398                	ld	a4,0(a5)
    80005afa:	972e                	add	a4,a4,a1
    80005afc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005b00:	4689                	li	a3,2
    80005b02:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005b06:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005b0a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005b0e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005b12:	6794                	ld	a3,8(a5)
    80005b14:	0026d703          	lhu	a4,2(a3)
    80005b18:	8b1d                	andi	a4,a4,7
    80005b1a:	0706                	slli	a4,a4,0x1
    80005b1c:	96ba                	add	a3,a3,a4
    80005b1e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005b22:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005b26:	6798                	ld	a4,8(a5)
    80005b28:	00275783          	lhu	a5,2(a4)
    80005b2c:	2785                	addiw	a5,a5,1
    80005b2e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005b32:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005b36:	100017b7          	lui	a5,0x10001
    80005b3a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005b3e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005b42:	00033917          	auipc	s2,0x33
    80005b46:	48e90913          	addi	s2,s2,1166 # 80038fd0 <disk+0x128>
  while(b->disk == 1) {
    80005b4a:	4485                	li	s1,1
    80005b4c:	01079a63          	bne	a5,a6,80005b60 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005b50:	85ca                	mv	a1,s2
    80005b52:	8552                	mv	a0,s4
    80005b54:	b14fc0ef          	jal	80001e68 <sleep>
  while(b->disk == 1) {
    80005b58:	004a2783          	lw	a5,4(s4)
    80005b5c:	fe978ae3          	beq	a5,s1,80005b50 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005b60:	f9042903          	lw	s2,-112(s0)
    80005b64:	00290713          	addi	a4,s2,2
    80005b68:	0712                	slli	a4,a4,0x4
    80005b6a:	00033797          	auipc	a5,0x33
    80005b6e:	33e78793          	addi	a5,a5,830 # 80038ea8 <disk>
    80005b72:	97ba                	add	a5,a5,a4
    80005b74:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005b78:	00033997          	auipc	s3,0x33
    80005b7c:	33098993          	addi	s3,s3,816 # 80038ea8 <disk>
    80005b80:	00491713          	slli	a4,s2,0x4
    80005b84:	0009b783          	ld	a5,0(s3)
    80005b88:	97ba                	add	a5,a5,a4
    80005b8a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005b8e:	854a                	mv	a0,s2
    80005b90:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005b94:	bafff0ef          	jal	80005742 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005b98:	8885                	andi	s1,s1,1
    80005b9a:	f0fd                	bnez	s1,80005b80 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005b9c:	00033517          	auipc	a0,0x33
    80005ba0:	43450513          	addi	a0,a0,1076 # 80038fd0 <disk+0x128>
    80005ba4:	8e8fb0ef          	jal	80000c8c <release>
}
    80005ba8:	70a6                	ld	ra,104(sp)
    80005baa:	7406                	ld	s0,96(sp)
    80005bac:	64e6                	ld	s1,88(sp)
    80005bae:	6946                	ld	s2,80(sp)
    80005bb0:	69a6                	ld	s3,72(sp)
    80005bb2:	6a06                	ld	s4,64(sp)
    80005bb4:	7ae2                	ld	s5,56(sp)
    80005bb6:	7b42                	ld	s6,48(sp)
    80005bb8:	7ba2                	ld	s7,40(sp)
    80005bba:	7c02                	ld	s8,32(sp)
    80005bbc:	6ce2                	ld	s9,24(sp)
    80005bbe:	6165                	addi	sp,sp,112
    80005bc0:	8082                	ret

0000000080005bc2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005bc2:	1101                	addi	sp,sp,-32
    80005bc4:	ec06                	sd	ra,24(sp)
    80005bc6:	e822                	sd	s0,16(sp)
    80005bc8:	e426                	sd	s1,8(sp)
    80005bca:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005bcc:	00033497          	auipc	s1,0x33
    80005bd0:	2dc48493          	addi	s1,s1,732 # 80038ea8 <disk>
    80005bd4:	00033517          	auipc	a0,0x33
    80005bd8:	3fc50513          	addi	a0,a0,1020 # 80038fd0 <disk+0x128>
    80005bdc:	818fb0ef          	jal	80000bf4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005be0:	100017b7          	lui	a5,0x10001
    80005be4:	53b8                	lw	a4,96(a5)
    80005be6:	8b0d                	andi	a4,a4,3
    80005be8:	100017b7          	lui	a5,0x10001
    80005bec:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005bee:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005bf2:	689c                	ld	a5,16(s1)
    80005bf4:	0204d703          	lhu	a4,32(s1)
    80005bf8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005bfc:	04f70663          	beq	a4,a5,80005c48 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005c00:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005c04:	6898                	ld	a4,16(s1)
    80005c06:	0204d783          	lhu	a5,32(s1)
    80005c0a:	8b9d                	andi	a5,a5,7
    80005c0c:	078e                	slli	a5,a5,0x3
    80005c0e:	97ba                	add	a5,a5,a4
    80005c10:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005c12:	00278713          	addi	a4,a5,2
    80005c16:	0712                	slli	a4,a4,0x4
    80005c18:	9726                	add	a4,a4,s1
    80005c1a:	01074703          	lbu	a4,16(a4)
    80005c1e:	e321                	bnez	a4,80005c5e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005c20:	0789                	addi	a5,a5,2
    80005c22:	0792                	slli	a5,a5,0x4
    80005c24:	97a6                	add	a5,a5,s1
    80005c26:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005c28:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005c2c:	a8afc0ef          	jal	80001eb6 <wakeup>

    disk.used_idx += 1;
    80005c30:	0204d783          	lhu	a5,32(s1)
    80005c34:	2785                	addiw	a5,a5,1
    80005c36:	17c2                	slli	a5,a5,0x30
    80005c38:	93c1                	srli	a5,a5,0x30
    80005c3a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005c3e:	6898                	ld	a4,16(s1)
    80005c40:	00275703          	lhu	a4,2(a4)
    80005c44:	faf71ee3          	bne	a4,a5,80005c00 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005c48:	00033517          	auipc	a0,0x33
    80005c4c:	38850513          	addi	a0,a0,904 # 80038fd0 <disk+0x128>
    80005c50:	83cfb0ef          	jal	80000c8c <release>
}
    80005c54:	60e2                	ld	ra,24(sp)
    80005c56:	6442                	ld	s0,16(sp)
    80005c58:	64a2                	ld	s1,8(sp)
    80005c5a:	6105                	addi	sp,sp,32
    80005c5c:	8082                	ret
      panic("virtio_disk_intr status");
    80005c5e:	00002517          	auipc	a0,0x2
    80005c62:	c3250513          	addi	a0,a0,-974 # 80007890 <etext+0x890>
    80005c66:	b2ffa0ef          	jal	80000794 <panic>
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
