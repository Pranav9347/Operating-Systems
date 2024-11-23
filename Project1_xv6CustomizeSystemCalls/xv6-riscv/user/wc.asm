
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
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	addi	s11,s11,-30 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	9b8a0a13          	addi	s4,s4,-1608 # 9f0 <malloc+0xf8>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a035                	j	6e <wc+0x6e>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	1bc000ef          	jal	202 <strchr>
  4a:	c919                	beqz	a0,60 <wc+0x60>
        inword = 0;
  4c:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  4e:	0485                	addi	s1,s1,1
  50:	01348d63          	beq	s1,s3,6a <wc+0x6a>
      if(buf[i] == '\n')
  54:	0004c583          	lbu	a1,0(s1)
  58:	ff5596e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  5c:	2c05                	addiw	s8,s8,1
  5e:	b7dd                	j	44 <wc+0x44>
      else if(!inword){
  60:	fe0917e3          	bnez	s2,4e <wc+0x4e>
        w++;
  64:	2c85                	addiw	s9,s9,1
        inword = 1;
  66:	4905                	li	s2,1
  68:	b7dd                	j	4e <wc+0x4e>
  6a:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  6e:	20000613          	li	a2,512
  72:	85ee                	mv	a1,s11
  74:	f8843503          	ld	a0,-120(s0)
  78:	3cc000ef          	jal	444 <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
    for(i=0; i<n; i++){
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	addi	s1,s1,-114 # 1010 <buf>
  8a:	009509b3          	add	s3,a0,s1
  8e:	b7d9                	j	54 <wc+0x54>
      }
    }
  }
  if(n < 0){
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86ea                	mv	a3,s10
  9a:	8666                	mv	a2,s9
  9c:	85e2                	mv	a1,s8
  9e:	00001517          	auipc	a0,0x1
  a2:	97250513          	addi	a0,a0,-1678 # a10 <malloc+0x118>
  a6:	79e000ef          	jal	844 <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	addi	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	93850513          	addi	a0,a0,-1736 # a00 <malloc+0x108>
  d0:	774000ef          	jal	844 <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	356000ef          	jal	42c <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	addi	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  e2:	4785                	li	a5,1
  e4:	04a7d463          	bge	a5,a0,12c <main+0x52>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
  ee:	00858913          	addi	s2,a1,8
  f2:	ffe5099b          	addiw	s3,a0,-2
  f6:	02099793          	slli	a5,s3,0x20
  fa:	01d7d993          	srli	s3,a5,0x1d
  fe:	05c1                	addi	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	364000ef          	jal	46c <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054c63          	bltz	a0,146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	338000ef          	jal	454 <close>
  for(i = 1; i < argc; i++){
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	304000ef          	jal	42c <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	8c658593          	addi	a1,a1,-1850 # 9f8 <malloc+0x100>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	2ea000ef          	jal	42c <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	8d650513          	addi	a0,a0,-1834 # a20 <malloc+0x128>
 152:	6f2000ef          	jal	844 <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	2d4000ef          	jal	42c <exit>

000000000000015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  extern int main();
  main();
 164:	f77ff0ef          	jal	da <main>
  exit(0);
 168:	4501                	li	a0,0
 16a:	2c2000ef          	jal	42c <exit>

000000000000016e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 174:	87aa                	mv	a5,a0
 176:	0585                	addi	a1,a1,1
 178:	0785                	addi	a5,a5,1
 17a:	fff5c703          	lbu	a4,-1(a1)
 17e:	fee78fa3          	sb	a4,-1(a5)
 182:	fb75                	bnez	a4,176 <strcpy+0x8>
    ;
  return os;
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret

000000000000018a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 190:	00054783          	lbu	a5,0(a0)
 194:	cb91                	beqz	a5,1a8 <strcmp+0x1e>
 196:	0005c703          	lbu	a4,0(a1)
 19a:	00f71763          	bne	a4,a5,1a8 <strcmp+0x1e>
    p++, q++;
 19e:	0505                	addi	a0,a0,1
 1a0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	fbe5                	bnez	a5,196 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1a8:	0005c503          	lbu	a0,0(a1)
}
 1ac:	40a7853b          	subw	a0,a5,a0
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strlen>:

uint
strlen(const char *s)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	cf91                	beqz	a5,1dc <strlen+0x26>
 1c2:	0505                	addi	a0,a0,1
 1c4:	87aa                	mv	a5,a0
 1c6:	86be                	mv	a3,a5
 1c8:	0785                	addi	a5,a5,1
 1ca:	fff7c703          	lbu	a4,-1(a5)
 1ce:	ff65                	bnez	a4,1c6 <strlen+0x10>
 1d0:	40a6853b          	subw	a0,a3,a0
 1d4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1d6:	6422                	ld	s0,8(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret
  for(n = 0; s[n]; n++)
 1dc:	4501                	li	a0,0
 1de:	bfe5                	j	1d6 <strlen+0x20>

00000000000001e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e0:	1141                	addi	sp,sp,-16
 1e2:	e422                	sd	s0,8(sp)
 1e4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1e6:	ca19                	beqz	a2,1fc <memset+0x1c>
 1e8:	87aa                	mv	a5,a0
 1ea:	1602                	slli	a2,a2,0x20
 1ec:	9201                	srli	a2,a2,0x20
 1ee:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1f2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f6:	0785                	addi	a5,a5,1
 1f8:	fee79de3          	bne	a5,a4,1f2 <memset+0x12>
  }
  return dst;
}
 1fc:	6422                	ld	s0,8(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret

0000000000000202 <strchr>:

char*
strchr(const char *s, char c)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  for(; *s; s++)
 208:	00054783          	lbu	a5,0(a0)
 20c:	cb99                	beqz	a5,222 <strchr+0x20>
    if(*s == c)
 20e:	00f58763          	beq	a1,a5,21c <strchr+0x1a>
  for(; *s; s++)
 212:	0505                	addi	a0,a0,1
 214:	00054783          	lbu	a5,0(a0)
 218:	fbfd                	bnez	a5,20e <strchr+0xc>
      return (char*)s;
  return 0;
 21a:	4501                	li	a0,0
}
 21c:	6422                	ld	s0,8(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
  return 0;
 222:	4501                	li	a0,0
 224:	bfe5                	j	21c <strchr+0x1a>

0000000000000226 <gets>:

char*
gets(char *buf, int max)
{
 226:	711d                	addi	sp,sp,-96
 228:	ec86                	sd	ra,88(sp)
 22a:	e8a2                	sd	s0,80(sp)
 22c:	e4a6                	sd	s1,72(sp)
 22e:	e0ca                	sd	s2,64(sp)
 230:	fc4e                	sd	s3,56(sp)
 232:	f852                	sd	s4,48(sp)
 234:	f456                	sd	s5,40(sp)
 236:	f05a                	sd	s6,32(sp)
 238:	ec5e                	sd	s7,24(sp)
 23a:	1080                	addi	s0,sp,96
 23c:	8baa                	mv	s7,a0
 23e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 240:	892a                	mv	s2,a0
 242:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 244:	4aa9                	li	s5,10
 246:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 248:	89a6                	mv	s3,s1
 24a:	2485                	addiw	s1,s1,1
 24c:	0344d663          	bge	s1,s4,278 <gets+0x52>
    cc = read(0, &c, 1);
 250:	4605                	li	a2,1
 252:	faf40593          	addi	a1,s0,-81
 256:	4501                	li	a0,0
 258:	1ec000ef          	jal	444 <read>
    if(cc < 1)
 25c:	00a05e63          	blez	a0,278 <gets+0x52>
    buf[i++] = c;
 260:	faf44783          	lbu	a5,-81(s0)
 264:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 268:	01578763          	beq	a5,s5,276 <gets+0x50>
 26c:	0905                	addi	s2,s2,1
 26e:	fd679de3          	bne	a5,s6,248 <gets+0x22>
    buf[i++] = c;
 272:	89a6                	mv	s3,s1
 274:	a011                	j	278 <gets+0x52>
 276:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 278:	99de                	add	s3,s3,s7
 27a:	00098023          	sb	zero,0(s3)
  return buf;
}
 27e:	855e                	mv	a0,s7
 280:	60e6                	ld	ra,88(sp)
 282:	6446                	ld	s0,80(sp)
 284:	64a6                	ld	s1,72(sp)
 286:	6906                	ld	s2,64(sp)
 288:	79e2                	ld	s3,56(sp)
 28a:	7a42                	ld	s4,48(sp)
 28c:	7aa2                	ld	s5,40(sp)
 28e:	7b02                	ld	s6,32(sp)
 290:	6be2                	ld	s7,24(sp)
 292:	6125                	addi	sp,sp,96
 294:	8082                	ret

0000000000000296 <stat>:

int
stat(const char *n, struct stat *st)
{
 296:	1101                	addi	sp,sp,-32
 298:	ec06                	sd	ra,24(sp)
 29a:	e822                	sd	s0,16(sp)
 29c:	e04a                	sd	s2,0(sp)
 29e:	1000                	addi	s0,sp,32
 2a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a2:	4581                	li	a1,0
 2a4:	1c8000ef          	jal	46c <open>
  if(fd < 0)
 2a8:	02054263          	bltz	a0,2cc <stat+0x36>
 2ac:	e426                	sd	s1,8(sp)
 2ae:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2b0:	85ca                	mv	a1,s2
 2b2:	1d2000ef          	jal	484 <fstat>
 2b6:	892a                	mv	s2,a0
  close(fd);
 2b8:	8526                	mv	a0,s1
 2ba:	19a000ef          	jal	454 <close>
  return r;
 2be:	64a2                	ld	s1,8(sp)
}
 2c0:	854a                	mv	a0,s2
 2c2:	60e2                	ld	ra,24(sp)
 2c4:	6442                	ld	s0,16(sp)
 2c6:	6902                	ld	s2,0(sp)
 2c8:	6105                	addi	sp,sp,32
 2ca:	8082                	ret
    return -1;
 2cc:	597d                	li	s2,-1
 2ce:	bfcd                	j	2c0 <stat+0x2a>

00000000000002d0 <atoi>:

int
atoi(const char *s)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d6:	00054683          	lbu	a3,0(a0)
 2da:	fd06879b          	addiw	a5,a3,-48
 2de:	0ff7f793          	zext.b	a5,a5
 2e2:	4625                	li	a2,9
 2e4:	02f66863          	bltu	a2,a5,314 <atoi+0x44>
 2e8:	872a                	mv	a4,a0
  n = 0;
 2ea:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ec:	0705                	addi	a4,a4,1
 2ee:	0025179b          	slliw	a5,a0,0x2
 2f2:	9fa9                	addw	a5,a5,a0
 2f4:	0017979b          	slliw	a5,a5,0x1
 2f8:	9fb5                	addw	a5,a5,a3
 2fa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2fe:	00074683          	lbu	a3,0(a4)
 302:	fd06879b          	addiw	a5,a3,-48
 306:	0ff7f793          	zext.b	a5,a5
 30a:	fef671e3          	bgeu	a2,a5,2ec <atoi+0x1c>
  return n;
}
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  n = 0;
 314:	4501                	li	a0,0
 316:	bfe5                	j	30e <atoi+0x3e>

0000000000000318 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 31e:	02b57463          	bgeu	a0,a1,346 <memmove+0x2e>
    while(n-- > 0)
 322:	00c05f63          	blez	a2,340 <memmove+0x28>
 326:	1602                	slli	a2,a2,0x20
 328:	9201                	srli	a2,a2,0x20
 32a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 32e:	872a                	mv	a4,a0
      *dst++ = *src++;
 330:	0585                	addi	a1,a1,1
 332:	0705                	addi	a4,a4,1
 334:	fff5c683          	lbu	a3,-1(a1)
 338:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 33c:	fef71ae3          	bne	a4,a5,330 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 340:	6422                	ld	s0,8(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret
    dst += n;
 346:	00c50733          	add	a4,a0,a2
    src += n;
 34a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 34c:	fec05ae3          	blez	a2,340 <memmove+0x28>
 350:	fff6079b          	addiw	a5,a2,-1
 354:	1782                	slli	a5,a5,0x20
 356:	9381                	srli	a5,a5,0x20
 358:	fff7c793          	not	a5,a5
 35c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 35e:	15fd                	addi	a1,a1,-1
 360:	177d                	addi	a4,a4,-1
 362:	0005c683          	lbu	a3,0(a1)
 366:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 36a:	fee79ae3          	bne	a5,a4,35e <memmove+0x46>
 36e:	bfc9                	j	340 <memmove+0x28>

0000000000000370 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e422                	sd	s0,8(sp)
 374:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 376:	ca05                	beqz	a2,3a6 <memcmp+0x36>
 378:	fff6069b          	addiw	a3,a2,-1
 37c:	1682                	slli	a3,a3,0x20
 37e:	9281                	srli	a3,a3,0x20
 380:	0685                	addi	a3,a3,1
 382:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 384:	00054783          	lbu	a5,0(a0)
 388:	0005c703          	lbu	a4,0(a1)
 38c:	00e79863          	bne	a5,a4,39c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 390:	0505                	addi	a0,a0,1
    p2++;
 392:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 394:	fed518e3          	bne	a0,a3,384 <memcmp+0x14>
  }
  return 0;
 398:	4501                	li	a0,0
 39a:	a019                	j	3a0 <memcmp+0x30>
      return *p1 - *p2;
 39c:	40e7853b          	subw	a0,a5,a4
}
 3a0:	6422                	ld	s0,8(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret
  return 0;
 3a6:	4501                	li	a0,0
 3a8:	bfe5                	j	3a0 <memcmp+0x30>

00000000000003aa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3aa:	1141                	addi	sp,sp,-16
 3ac:	e406                	sd	ra,8(sp)
 3ae:	e022                	sd	s0,0(sp)
 3b0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b2:	f67ff0ef          	jal	318 <memmove>
}
 3b6:	60a2                	ld	ra,8(sp)
 3b8:	6402                	ld	s0,0(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret

00000000000003be <syscall>:

// Trap into kernel space for system calls
int syscall(int num, ...) {
 3be:	7175                	addi	sp,sp,-144
 3c0:	e4a2                	sd	s0,72(sp)
 3c2:	0880                	addi	s0,sp,80
 3c4:	832a                	mv	t1,a0
 3c6:	e40c                	sd	a1,8(s0)
 3c8:	e810                	sd	a2,16(s0)
 3ca:	ec14                	sd	a3,24(s0)
 3cc:	f018                	sd	a4,32(s0)
 3ce:	f41c                	sd	a5,40(s0)
 3d0:	03043823          	sd	a6,48(s0)
 3d4:	03143c23          	sd	a7,56(s0)
    uint64 args[6];
    va_list ap;
    int i;

    // Retrieve variable arguments passed to syscall
    va_start(ap, num);
 3d8:	00840793          	addi	a5,s0,8
 3dc:	faf43c23          	sd	a5,-72(s0)
    for (i = 0; i < 6; i++) {
 3e0:	fc040793          	addi	a5,s0,-64
 3e4:	ff040613          	addi	a2,s0,-16
        args[i] = va_arg(ap, uint64);
 3e8:	fb843703          	ld	a4,-72(s0)
 3ec:	00870693          	addi	a3,a4,8
 3f0:	fad43c23          	sd	a3,-72(s0)
 3f4:	6318                	ld	a4,0(a4)
 3f6:	e398                	sd	a4,0(a5)
    for (i = 0; i < 6; i++) {
 3f8:	07a1                	addi	a5,a5,8
 3fa:	fec797e3          	bne	a5,a2,3e8 <syscall+0x2a>
    }
    va_end(ap);

    // Place the system call number in a7, arguments in a0-a5
    register uint64 a0 asm("a0") = args[0];
 3fe:	fc043503          	ld	a0,-64(s0)
    register uint64 a1 asm("a1") = args[1];
 402:	fc843583          	ld	a1,-56(s0)
    register uint64 a2 asm("a2") = args[2];
 406:	fd043603          	ld	a2,-48(s0)
    register uint64 a3 asm("a3") = args[3];
 40a:	fd843683          	ld	a3,-40(s0)
    register uint64 a4 asm("a4") = args[4];
 40e:	fe043703          	ld	a4,-32(s0)
    register uint64 a5 asm("a5") = args[5];
 412:	fe843783          	ld	a5,-24(s0)
    register uint64 a7 asm("a7") = num;
 416:	889a                	mv	a7,t1

    // Perform the ecall (traps into kernel space)
    asm volatile("ecall"
 418:	00000073          	ecall
                 : "r"(a1), "r"(a2), "r"(a3), "r"(a4), "r"(a5), "r"(a7)
                 : "memory");

    // Return value is stored in a0 after the trap
    return a0;
 41c:	2501                	sext.w	a0,a0
 41e:	6426                	ld	s0,72(sp)
 420:	6149                	addi	sp,sp,144
 422:	8082                	ret

0000000000000424 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 424:	4885                	li	a7,1
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <exit>:
.global exit
exit:
 li a7, SYS_exit
 42c:	4889                	li	a7,2
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <wait>:
.global wait
wait:
 li a7, SYS_wait
 434:	488d                	li	a7,3
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 43c:	4891                	li	a7,4
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <read>:
.global read
read:
 li a7, SYS_read
 444:	4895                	li	a7,5
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <write>:
.global write
write:
 li a7, SYS_write
 44c:	48c1                	li	a7,16
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <close>:
.global close
close:
 li a7, SYS_close
 454:	48d5                	li	a7,21
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <kill>:
.global kill
kill:
 li a7, SYS_kill
 45c:	4899                	li	a7,6
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <exec>:
.global exec
exec:
 li a7, SYS_exec
 464:	489d                	li	a7,7
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <open>:
.global open
open:
 li a7, SYS_open
 46c:	48bd                	li	a7,15
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 474:	48c5                	li	a7,17
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 47c:	48c9                	li	a7,18
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 484:	48a1                	li	a7,8
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <link>:
.global link
link:
 li a7, SYS_link
 48c:	48cd                	li	a7,19
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 494:	48d1                	li	a7,20
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 49c:	48a5                	li	a7,9
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4a4:	48a9                	li	a7,10
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ac:	48ad                	li	a7,11
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4b4:	48b1                	li	a7,12
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4bc:	48b5                	li	a7,13
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4c4:	48b9                	li	a7,14
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4cc:	1101                	addi	sp,sp,-32
 4ce:	ec06                	sd	ra,24(sp)
 4d0:	e822                	sd	s0,16(sp)
 4d2:	1000                	addi	s0,sp,32
 4d4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4d8:	4605                	li	a2,1
 4da:	fef40593          	addi	a1,s0,-17
 4de:	f6fff0ef          	jal	44c <write>
}
 4e2:	60e2                	ld	ra,24(sp)
 4e4:	6442                	ld	s0,16(sp)
 4e6:	6105                	addi	sp,sp,32
 4e8:	8082                	ret

00000000000004ea <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ea:	7139                	addi	sp,sp,-64
 4ec:	fc06                	sd	ra,56(sp)
 4ee:	f822                	sd	s0,48(sp)
 4f0:	f426                	sd	s1,40(sp)
 4f2:	0080                	addi	s0,sp,64
 4f4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4f6:	c299                	beqz	a3,4fc <printint+0x12>
 4f8:	0805c963          	bltz	a1,58a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4fc:	2581                	sext.w	a1,a1
  neg = 0;
 4fe:	4881                	li	a7,0
 500:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 504:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 506:	2601                	sext.w	a2,a2
 508:	00000517          	auipc	a0,0x0
 50c:	53850513          	addi	a0,a0,1336 # a40 <digits>
 510:	883a                	mv	a6,a4
 512:	2705                	addiw	a4,a4,1
 514:	02c5f7bb          	remuw	a5,a1,a2
 518:	1782                	slli	a5,a5,0x20
 51a:	9381                	srli	a5,a5,0x20
 51c:	97aa                	add	a5,a5,a0
 51e:	0007c783          	lbu	a5,0(a5)
 522:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 526:	0005879b          	sext.w	a5,a1
 52a:	02c5d5bb          	divuw	a1,a1,a2
 52e:	0685                	addi	a3,a3,1
 530:	fec7f0e3          	bgeu	a5,a2,510 <printint+0x26>
  if(neg)
 534:	00088c63          	beqz	a7,54c <printint+0x62>
    buf[i++] = '-';
 538:	fd070793          	addi	a5,a4,-48
 53c:	00878733          	add	a4,a5,s0
 540:	02d00793          	li	a5,45
 544:	fef70823          	sb	a5,-16(a4)
 548:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 54c:	02e05a63          	blez	a4,580 <printint+0x96>
 550:	f04a                	sd	s2,32(sp)
 552:	ec4e                	sd	s3,24(sp)
 554:	fc040793          	addi	a5,s0,-64
 558:	00e78933          	add	s2,a5,a4
 55c:	fff78993          	addi	s3,a5,-1
 560:	99ba                	add	s3,s3,a4
 562:	377d                	addiw	a4,a4,-1
 564:	1702                	slli	a4,a4,0x20
 566:	9301                	srli	a4,a4,0x20
 568:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 56c:	fff94583          	lbu	a1,-1(s2)
 570:	8526                	mv	a0,s1
 572:	f5bff0ef          	jal	4cc <putc>
  while(--i >= 0)
 576:	197d                	addi	s2,s2,-1
 578:	ff391ae3          	bne	s2,s3,56c <printint+0x82>
 57c:	7902                	ld	s2,32(sp)
 57e:	69e2                	ld	s3,24(sp)
}
 580:	70e2                	ld	ra,56(sp)
 582:	7442                	ld	s0,48(sp)
 584:	74a2                	ld	s1,40(sp)
 586:	6121                	addi	sp,sp,64
 588:	8082                	ret
    x = -xx;
 58a:	40b005bb          	negw	a1,a1
    neg = 1;
 58e:	4885                	li	a7,1
    x = -xx;
 590:	bf85                	j	500 <printint+0x16>

0000000000000592 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 592:	711d                	addi	sp,sp,-96
 594:	ec86                	sd	ra,88(sp)
 596:	e8a2                	sd	s0,80(sp)
 598:	e0ca                	sd	s2,64(sp)
 59a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 59c:	0005c903          	lbu	s2,0(a1)
 5a0:	26090863          	beqz	s2,810 <vprintf+0x27e>
 5a4:	e4a6                	sd	s1,72(sp)
 5a6:	fc4e                	sd	s3,56(sp)
 5a8:	f852                	sd	s4,48(sp)
 5aa:	f456                	sd	s5,40(sp)
 5ac:	f05a                	sd	s6,32(sp)
 5ae:	ec5e                	sd	s7,24(sp)
 5b0:	e862                	sd	s8,16(sp)
 5b2:	e466                	sd	s9,8(sp)
 5b4:	8b2a                	mv	s6,a0
 5b6:	8a2e                	mv	s4,a1
 5b8:	8bb2                	mv	s7,a2
  state = 0;
 5ba:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5bc:	4481                	li	s1,0
 5be:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5c0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5c4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5c8:	06c00c93          	li	s9,108
 5cc:	a005                	j	5ec <vprintf+0x5a>
        putc(fd, c0);
 5ce:	85ca                	mv	a1,s2
 5d0:	855a                	mv	a0,s6
 5d2:	efbff0ef          	jal	4cc <putc>
 5d6:	a019                	j	5dc <vprintf+0x4a>
    } else if(state == '%'){
 5d8:	03598263          	beq	s3,s5,5fc <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5dc:	2485                	addiw	s1,s1,1
 5de:	8726                	mv	a4,s1
 5e0:	009a07b3          	add	a5,s4,s1
 5e4:	0007c903          	lbu	s2,0(a5)
 5e8:	20090c63          	beqz	s2,800 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5ec:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5f0:	fe0994e3          	bnez	s3,5d8 <vprintf+0x46>
      if(c0 == '%'){
 5f4:	fd579de3          	bne	a5,s5,5ce <vprintf+0x3c>
        state = '%';
 5f8:	89be                	mv	s3,a5
 5fa:	b7cd                	j	5dc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5fc:	00ea06b3          	add	a3,s4,a4
 600:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 604:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 606:	c681                	beqz	a3,60e <vprintf+0x7c>
 608:	9752                	add	a4,a4,s4
 60a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 60e:	03878f63          	beq	a5,s8,64c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 612:	05978963          	beq	a5,s9,664 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 616:	07500713          	li	a4,117
 61a:	0ee78363          	beq	a5,a4,700 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 61e:	07800713          	li	a4,120
 622:	12e78563          	beq	a5,a4,74c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 626:	07000713          	li	a4,112
 62a:	14e78a63          	beq	a5,a4,77e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 62e:	07300713          	li	a4,115
 632:	18e78a63          	beq	a5,a4,7c6 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 636:	02500713          	li	a4,37
 63a:	04e79563          	bne	a5,a4,684 <vprintf+0xf2>
        putc(fd, '%');
 63e:	02500593          	li	a1,37
 642:	855a                	mv	a0,s6
 644:	e89ff0ef          	jal	4cc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 648:	4981                	li	s3,0
 64a:	bf49                	j	5dc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 64c:	008b8913          	addi	s2,s7,8
 650:	4685                	li	a3,1
 652:	4629                	li	a2,10
 654:	000ba583          	lw	a1,0(s7)
 658:	855a                	mv	a0,s6
 65a:	e91ff0ef          	jal	4ea <printint>
 65e:	8bca                	mv	s7,s2
      state = 0;
 660:	4981                	li	s3,0
 662:	bfad                	j	5dc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 664:	06400793          	li	a5,100
 668:	02f68963          	beq	a3,a5,69a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 66c:	06c00793          	li	a5,108
 670:	04f68263          	beq	a3,a5,6b4 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 674:	07500793          	li	a5,117
 678:	0af68063          	beq	a3,a5,718 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 67c:	07800793          	li	a5,120
 680:	0ef68263          	beq	a3,a5,764 <vprintf+0x1d2>
        putc(fd, '%');
 684:	02500593          	li	a1,37
 688:	855a                	mv	a0,s6
 68a:	e43ff0ef          	jal	4cc <putc>
        putc(fd, c0);
 68e:	85ca                	mv	a1,s2
 690:	855a                	mv	a0,s6
 692:	e3bff0ef          	jal	4cc <putc>
      state = 0;
 696:	4981                	li	s3,0
 698:	b791                	j	5dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 69a:	008b8913          	addi	s2,s7,8
 69e:	4685                	li	a3,1
 6a0:	4629                	li	a2,10
 6a2:	000ba583          	lw	a1,0(s7)
 6a6:	855a                	mv	a0,s6
 6a8:	e43ff0ef          	jal	4ea <printint>
        i += 1;
 6ac:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ae:	8bca                	mv	s7,s2
      state = 0;
 6b0:	4981                	li	s3,0
        i += 1;
 6b2:	b72d                	j	5dc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6b4:	06400793          	li	a5,100
 6b8:	02f60763          	beq	a2,a5,6e6 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6bc:	07500793          	li	a5,117
 6c0:	06f60963          	beq	a2,a5,732 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6c4:	07800793          	li	a5,120
 6c8:	faf61ee3          	bne	a2,a5,684 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6cc:	008b8913          	addi	s2,s7,8
 6d0:	4681                	li	a3,0
 6d2:	4641                	li	a2,16
 6d4:	000ba583          	lw	a1,0(s7)
 6d8:	855a                	mv	a0,s6
 6da:	e11ff0ef          	jal	4ea <printint>
        i += 2;
 6de:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e0:	8bca                	mv	s7,s2
      state = 0;
 6e2:	4981                	li	s3,0
        i += 2;
 6e4:	bde5                	j	5dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e6:	008b8913          	addi	s2,s7,8
 6ea:	4685                	li	a3,1
 6ec:	4629                	li	a2,10
 6ee:	000ba583          	lw	a1,0(s7)
 6f2:	855a                	mv	a0,s6
 6f4:	df7ff0ef          	jal	4ea <printint>
        i += 2;
 6f8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6fa:	8bca                	mv	s7,s2
      state = 0;
 6fc:	4981                	li	s3,0
        i += 2;
 6fe:	bdf9                	j	5dc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 700:	008b8913          	addi	s2,s7,8
 704:	4681                	li	a3,0
 706:	4629                	li	a2,10
 708:	000ba583          	lw	a1,0(s7)
 70c:	855a                	mv	a0,s6
 70e:	dddff0ef          	jal	4ea <printint>
 712:	8bca                	mv	s7,s2
      state = 0;
 714:	4981                	li	s3,0
 716:	b5d9                	j	5dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 718:	008b8913          	addi	s2,s7,8
 71c:	4681                	li	a3,0
 71e:	4629                	li	a2,10
 720:	000ba583          	lw	a1,0(s7)
 724:	855a                	mv	a0,s6
 726:	dc5ff0ef          	jal	4ea <printint>
        i += 1;
 72a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 72c:	8bca                	mv	s7,s2
      state = 0;
 72e:	4981                	li	s3,0
        i += 1;
 730:	b575                	j	5dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 732:	008b8913          	addi	s2,s7,8
 736:	4681                	li	a3,0
 738:	4629                	li	a2,10
 73a:	000ba583          	lw	a1,0(s7)
 73e:	855a                	mv	a0,s6
 740:	dabff0ef          	jal	4ea <printint>
        i += 2;
 744:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 746:	8bca                	mv	s7,s2
      state = 0;
 748:	4981                	li	s3,0
        i += 2;
 74a:	bd49                	j	5dc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 74c:	008b8913          	addi	s2,s7,8
 750:	4681                	li	a3,0
 752:	4641                	li	a2,16
 754:	000ba583          	lw	a1,0(s7)
 758:	855a                	mv	a0,s6
 75a:	d91ff0ef          	jal	4ea <printint>
 75e:	8bca                	mv	s7,s2
      state = 0;
 760:	4981                	li	s3,0
 762:	bdad                	j	5dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 764:	008b8913          	addi	s2,s7,8
 768:	4681                	li	a3,0
 76a:	4641                	li	a2,16
 76c:	000ba583          	lw	a1,0(s7)
 770:	855a                	mv	a0,s6
 772:	d79ff0ef          	jal	4ea <printint>
        i += 1;
 776:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 778:	8bca                	mv	s7,s2
      state = 0;
 77a:	4981                	li	s3,0
        i += 1;
 77c:	b585                	j	5dc <vprintf+0x4a>
 77e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 780:	008b8d13          	addi	s10,s7,8
 784:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 788:	03000593          	li	a1,48
 78c:	855a                	mv	a0,s6
 78e:	d3fff0ef          	jal	4cc <putc>
  putc(fd, 'x');
 792:	07800593          	li	a1,120
 796:	855a                	mv	a0,s6
 798:	d35ff0ef          	jal	4cc <putc>
 79c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 79e:	00000b97          	auipc	s7,0x0
 7a2:	2a2b8b93          	addi	s7,s7,674 # a40 <digits>
 7a6:	03c9d793          	srli	a5,s3,0x3c
 7aa:	97de                	add	a5,a5,s7
 7ac:	0007c583          	lbu	a1,0(a5)
 7b0:	855a                	mv	a0,s6
 7b2:	d1bff0ef          	jal	4cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b6:	0992                	slli	s3,s3,0x4
 7b8:	397d                	addiw	s2,s2,-1
 7ba:	fe0916e3          	bnez	s2,7a6 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7be:	8bea                	mv	s7,s10
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	6d02                	ld	s10,0(sp)
 7c4:	bd21                	j	5dc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7c6:	008b8993          	addi	s3,s7,8
 7ca:	000bb903          	ld	s2,0(s7)
 7ce:	00090f63          	beqz	s2,7ec <vprintf+0x25a>
        for(; *s; s++)
 7d2:	00094583          	lbu	a1,0(s2)
 7d6:	c195                	beqz	a1,7fa <vprintf+0x268>
          putc(fd, *s);
 7d8:	855a                	mv	a0,s6
 7da:	cf3ff0ef          	jal	4cc <putc>
        for(; *s; s++)
 7de:	0905                	addi	s2,s2,1
 7e0:	00094583          	lbu	a1,0(s2)
 7e4:	f9f5                	bnez	a1,7d8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7e6:	8bce                	mv	s7,s3
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	bbcd                	j	5dc <vprintf+0x4a>
          s = "(null)";
 7ec:	00000917          	auipc	s2,0x0
 7f0:	24c90913          	addi	s2,s2,588 # a38 <malloc+0x140>
        for(; *s; s++)
 7f4:	02800593          	li	a1,40
 7f8:	b7c5                	j	7d8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7fa:	8bce                	mv	s7,s3
      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	bbf9                	j	5dc <vprintf+0x4a>
 800:	64a6                	ld	s1,72(sp)
 802:	79e2                	ld	s3,56(sp)
 804:	7a42                	ld	s4,48(sp)
 806:	7aa2                	ld	s5,40(sp)
 808:	7b02                	ld	s6,32(sp)
 80a:	6be2                	ld	s7,24(sp)
 80c:	6c42                	ld	s8,16(sp)
 80e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 810:	60e6                	ld	ra,88(sp)
 812:	6446                	ld	s0,80(sp)
 814:	6906                	ld	s2,64(sp)
 816:	6125                	addi	sp,sp,96
 818:	8082                	ret

000000000000081a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 81a:	715d                	addi	sp,sp,-80
 81c:	ec06                	sd	ra,24(sp)
 81e:	e822                	sd	s0,16(sp)
 820:	1000                	addi	s0,sp,32
 822:	e010                	sd	a2,0(s0)
 824:	e414                	sd	a3,8(s0)
 826:	e818                	sd	a4,16(s0)
 828:	ec1c                	sd	a5,24(s0)
 82a:	03043023          	sd	a6,32(s0)
 82e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 832:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 836:	8622                	mv	a2,s0
 838:	d5bff0ef          	jal	592 <vprintf>
}
 83c:	60e2                	ld	ra,24(sp)
 83e:	6442                	ld	s0,16(sp)
 840:	6161                	addi	sp,sp,80
 842:	8082                	ret

0000000000000844 <printf>:

void
printf(const char *fmt, ...)
{
 844:	711d                	addi	sp,sp,-96
 846:	ec06                	sd	ra,24(sp)
 848:	e822                	sd	s0,16(sp)
 84a:	1000                	addi	s0,sp,32
 84c:	e40c                	sd	a1,8(s0)
 84e:	e810                	sd	a2,16(s0)
 850:	ec14                	sd	a3,24(s0)
 852:	f018                	sd	a4,32(s0)
 854:	f41c                	sd	a5,40(s0)
 856:	03043823          	sd	a6,48(s0)
 85a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 85e:	00840613          	addi	a2,s0,8
 862:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 866:	85aa                	mv	a1,a0
 868:	4505                	li	a0,1
 86a:	d29ff0ef          	jal	592 <vprintf>
}
 86e:	60e2                	ld	ra,24(sp)
 870:	6442                	ld	s0,16(sp)
 872:	6125                	addi	sp,sp,96
 874:	8082                	ret

0000000000000876 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 876:	1141                	addi	sp,sp,-16
 878:	e422                	sd	s0,8(sp)
 87a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 87c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 880:	00000797          	auipc	a5,0x0
 884:	7807b783          	ld	a5,1920(a5) # 1000 <freep>
 888:	a02d                	j	8b2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 88a:	4618                	lw	a4,8(a2)
 88c:	9f2d                	addw	a4,a4,a1
 88e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 892:	6398                	ld	a4,0(a5)
 894:	6310                	ld	a2,0(a4)
 896:	a83d                	j	8d4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 898:	ff852703          	lw	a4,-8(a0)
 89c:	9f31                	addw	a4,a4,a2
 89e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8a0:	ff053683          	ld	a3,-16(a0)
 8a4:	a091                	j	8e8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a6:	6398                	ld	a4,0(a5)
 8a8:	00e7e463          	bltu	a5,a4,8b0 <free+0x3a>
 8ac:	00e6ea63          	bltu	a3,a4,8c0 <free+0x4a>
{
 8b0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b2:	fed7fae3          	bgeu	a5,a3,8a6 <free+0x30>
 8b6:	6398                	ld	a4,0(a5)
 8b8:	00e6e463          	bltu	a3,a4,8c0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8bc:	fee7eae3          	bltu	a5,a4,8b0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8c0:	ff852583          	lw	a1,-8(a0)
 8c4:	6390                	ld	a2,0(a5)
 8c6:	02059813          	slli	a6,a1,0x20
 8ca:	01c85713          	srli	a4,a6,0x1c
 8ce:	9736                	add	a4,a4,a3
 8d0:	fae60de3          	beq	a2,a4,88a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8d4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8d8:	4790                	lw	a2,8(a5)
 8da:	02061593          	slli	a1,a2,0x20
 8de:	01c5d713          	srli	a4,a1,0x1c
 8e2:	973e                	add	a4,a4,a5
 8e4:	fae68ae3          	beq	a3,a4,898 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8e8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ea:	00000717          	auipc	a4,0x0
 8ee:	70f73b23          	sd	a5,1814(a4) # 1000 <freep>
}
 8f2:	6422                	ld	s0,8(sp)
 8f4:	0141                	addi	sp,sp,16
 8f6:	8082                	ret

00000000000008f8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f8:	7139                	addi	sp,sp,-64
 8fa:	fc06                	sd	ra,56(sp)
 8fc:	f822                	sd	s0,48(sp)
 8fe:	f426                	sd	s1,40(sp)
 900:	ec4e                	sd	s3,24(sp)
 902:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 904:	02051493          	slli	s1,a0,0x20
 908:	9081                	srli	s1,s1,0x20
 90a:	04bd                	addi	s1,s1,15
 90c:	8091                	srli	s1,s1,0x4
 90e:	0014899b          	addiw	s3,s1,1
 912:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 914:	00000517          	auipc	a0,0x0
 918:	6ec53503          	ld	a0,1772(a0) # 1000 <freep>
 91c:	c915                	beqz	a0,950 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 920:	4798                	lw	a4,8(a5)
 922:	08977a63          	bgeu	a4,s1,9b6 <malloc+0xbe>
 926:	f04a                	sd	s2,32(sp)
 928:	e852                	sd	s4,16(sp)
 92a:	e456                	sd	s5,8(sp)
 92c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 92e:	8a4e                	mv	s4,s3
 930:	0009871b          	sext.w	a4,s3
 934:	6685                	lui	a3,0x1
 936:	00d77363          	bgeu	a4,a3,93c <malloc+0x44>
 93a:	6a05                	lui	s4,0x1
 93c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 940:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 944:	00000917          	auipc	s2,0x0
 948:	6bc90913          	addi	s2,s2,1724 # 1000 <freep>
  if(p == (char*)-1)
 94c:	5afd                	li	s5,-1
 94e:	a081                	j	98e <malloc+0x96>
 950:	f04a                	sd	s2,32(sp)
 952:	e852                	sd	s4,16(sp)
 954:	e456                	sd	s5,8(sp)
 956:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 958:	00001797          	auipc	a5,0x1
 95c:	8b878793          	addi	a5,a5,-1864 # 1210 <base>
 960:	00000717          	auipc	a4,0x0
 964:	6af73023          	sd	a5,1696(a4) # 1000 <freep>
 968:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 96a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 96e:	b7c1                	j	92e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 970:	6398                	ld	a4,0(a5)
 972:	e118                	sd	a4,0(a0)
 974:	a8a9                	j	9ce <malloc+0xd6>
  hp->s.size = nu;
 976:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 97a:	0541                	addi	a0,a0,16
 97c:	efbff0ef          	jal	876 <free>
  return freep;
 980:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 984:	c12d                	beqz	a0,9e6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 986:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 988:	4798                	lw	a4,8(a5)
 98a:	02977263          	bgeu	a4,s1,9ae <malloc+0xb6>
    if(p == freep)
 98e:	00093703          	ld	a4,0(s2)
 992:	853e                	mv	a0,a5
 994:	fef719e3          	bne	a4,a5,986 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 998:	8552                	mv	a0,s4
 99a:	b1bff0ef          	jal	4b4 <sbrk>
  if(p == (char*)-1)
 99e:	fd551ce3          	bne	a0,s5,976 <malloc+0x7e>
        return 0;
 9a2:	4501                	li	a0,0
 9a4:	7902                	ld	s2,32(sp)
 9a6:	6a42                	ld	s4,16(sp)
 9a8:	6aa2                	ld	s5,8(sp)
 9aa:	6b02                	ld	s6,0(sp)
 9ac:	a03d                	j	9da <malloc+0xe2>
 9ae:	7902                	ld	s2,32(sp)
 9b0:	6a42                	ld	s4,16(sp)
 9b2:	6aa2                	ld	s5,8(sp)
 9b4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9b6:	fae48de3          	beq	s1,a4,970 <malloc+0x78>
        p->s.size -= nunits;
 9ba:	4137073b          	subw	a4,a4,s3
 9be:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9c0:	02071693          	slli	a3,a4,0x20
 9c4:	01c6d713          	srli	a4,a3,0x1c
 9c8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ca:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ce:	00000717          	auipc	a4,0x0
 9d2:	62a73923          	sd	a0,1586(a4) # 1000 <freep>
      return (void*)(p + 1);
 9d6:	01078513          	addi	a0,a5,16
  }
}
 9da:	70e2                	ld	ra,56(sp)
 9dc:	7442                	ld	s0,48(sp)
 9de:	74a2                	ld	s1,40(sp)
 9e0:	69e2                	ld	s3,24(sp)
 9e2:	6121                	addi	sp,sp,64
 9e4:	8082                	ret
 9e6:	7902                	ld	s2,32(sp)
 9e8:	6a42                	ld	s4,16(sp)
 9ea:	6aa2                	ld	s5,8(sp)
 9ec:	6b02                	ld	s6,0(sp)
 9ee:	b7f5                	j	9da <malloc+0xe2>
