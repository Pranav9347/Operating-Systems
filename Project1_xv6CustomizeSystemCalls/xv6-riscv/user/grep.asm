
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	02c000ef          	jal	4a <matchhere>
  22:	e919                	bnez	a0,38 <matchstar+0x38>
  }while(*text!='\0' && (*text++==c || c=='.'));
  24:	0004c783          	lbu	a5,0(s1)
  28:	cb89                	beqz	a5,3a <matchstar+0x3a>
  2a:	0485                	addi	s1,s1,1
  2c:	2781                	sext.w	a5,a5
  2e:	ff2786e3          	beq	a5,s2,1a <matchstar+0x1a>
  32:	ff4904e3          	beq	s2,s4,1a <matchstar+0x1a>
  36:	a011                	j	3a <matchstar+0x3a>
      return 1;
  38:	4505                	li	a0,1
  return 0;
}
  3a:	70a2                	ld	ra,40(sp)
  3c:	7402                	ld	s0,32(sp)
  3e:	64e2                	ld	s1,24(sp)
  40:	6942                	ld	s2,16(sp)
  42:	69a2                	ld	s3,8(sp)
  44:	6a02                	ld	s4,0(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret

000000000000004a <matchhere>:
  if(re[0] == '\0')
  4a:	00054703          	lbu	a4,0(a0)
  4e:	c73d                	beqz	a4,bc <matchhere+0x72>
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  58:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5a:	00154683          	lbu	a3,1(a0)
  5e:	02a00613          	li	a2,42
  62:	02c68563          	beq	a3,a2,8c <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  66:	02400613          	li	a2,36
  6a:	02c70863          	beq	a4,a2,9a <matchhere+0x50>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  6e:	0005c683          	lbu	a3,0(a1)
  return 0;
  72:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  74:	ca81                	beqz	a3,84 <matchhere+0x3a>
  76:	02e00613          	li	a2,46
  7a:	02c70b63          	beq	a4,a2,b0 <matchhere+0x66>
  return 0;
  7e:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  80:	02d70863          	beq	a4,a3,b0 <matchhere+0x66>
}
  84:	60a2                	ld	ra,8(sp)
  86:	6402                	ld	s0,0(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret
    return matchstar(re[0], re+2, text);
  8c:	862e                	mv	a2,a1
  8e:	00250593          	addi	a1,a0,2
  92:	853a                	mv	a0,a4
  94:	f6dff0ef          	jal	0 <matchstar>
  98:	b7f5                	j	84 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  9a:	c691                	beqz	a3,a6 <matchhere+0x5c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  9c:	0005c683          	lbu	a3,0(a1)
  a0:	fef9                	bnez	a3,7e <matchhere+0x34>
  return 0;
  a2:	4501                	li	a0,0
  a4:	b7c5                	j	84 <matchhere+0x3a>
    return *text == '\0';
  a6:	0005c503          	lbu	a0,0(a1)
  aa:	00153513          	seqz	a0,a0
  ae:	bfd9                	j	84 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b0:	0585                	addi	a1,a1,1
  b2:	00178513          	addi	a0,a5,1
  b6:	f95ff0ef          	jal	4a <matchhere>
  ba:	b7e9                	j	84 <matchhere+0x3a>
    return 1;
  bc:	4505                	li	a0,1
}
  be:	8082                	ret

00000000000000c0 <match>:
{
  c0:	1101                	addi	sp,sp,-32
  c2:	ec06                	sd	ra,24(sp)
  c4:	e822                	sd	s0,16(sp)
  c6:	e426                	sd	s1,8(sp)
  c8:	e04a                	sd	s2,0(sp)
  ca:	1000                	addi	s0,sp,32
  cc:	892a                	mv	s2,a0
  ce:	84ae                	mv	s1,a1
  if(re[0] == '^')
  d0:	00054703          	lbu	a4,0(a0)
  d4:	05e00793          	li	a5,94
  d8:	00f70c63          	beq	a4,a5,f0 <match+0x30>
    if(matchhere(re, text))
  dc:	85a6                	mv	a1,s1
  de:	854a                	mv	a0,s2
  e0:	f6bff0ef          	jal	4a <matchhere>
  e4:	e911                	bnez	a0,f8 <match+0x38>
  }while(*text++ != '\0');
  e6:	0485                	addi	s1,s1,1
  e8:	fff4c783          	lbu	a5,-1(s1)
  ec:	fbe5                	bnez	a5,dc <match+0x1c>
  ee:	a031                	j	fa <match+0x3a>
    return matchhere(re+1, text);
  f0:	0505                	addi	a0,a0,1
  f2:	f59ff0ef          	jal	4a <matchhere>
  f6:	a011                	j	fa <match+0x3a>
      return 1;
  f8:	4505                	li	a0,1
}
  fa:	60e2                	ld	ra,24(sp)
  fc:	6442                	ld	s0,16(sp)
  fe:	64a2                	ld	s1,8(sp)
 100:	6902                	ld	s2,0(sp)
 102:	6105                	addi	sp,sp,32
 104:	8082                	ret

0000000000000106 <grep>:
{
 106:	715d                	addi	sp,sp,-80
 108:	e486                	sd	ra,72(sp)
 10a:	e0a2                	sd	s0,64(sp)
 10c:	fc26                	sd	s1,56(sp)
 10e:	f84a                	sd	s2,48(sp)
 110:	f44e                	sd	s3,40(sp)
 112:	f052                	sd	s4,32(sp)
 114:	ec56                	sd	s5,24(sp)
 116:	e85a                	sd	s6,16(sp)
 118:	e45e                	sd	s7,8(sp)
 11a:	e062                	sd	s8,0(sp)
 11c:	0880                	addi	s0,sp,80
 11e:	89aa                	mv	s3,a0
 120:	8b2e                	mv	s6,a1
  m = 0;
 122:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 124:	3ff00b93          	li	s7,1023
 128:	00002a97          	auipc	s5,0x2
 12c:	ee8a8a93          	addi	s5,s5,-280 # 2010 <buf>
 130:	a835                	j	16c <grep+0x66>
      p = q+1;
 132:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 136:	45a9                	li	a1,10
 138:	854a                	mv	a0,s2
 13a:	1c6000ef          	jal	300 <strchr>
 13e:	84aa                	mv	s1,a0
 140:	c505                	beqz	a0,168 <grep+0x62>
      *q = 0;
 142:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 146:	85ca                	mv	a1,s2
 148:	854e                	mv	a0,s3
 14a:	f77ff0ef          	jal	c0 <match>
 14e:	d175                	beqz	a0,132 <grep+0x2c>
        *q = '\n';
 150:	47a9                	li	a5,10
 152:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 156:	00148613          	addi	a2,s1,1
 15a:	4126063b          	subw	a2,a2,s2
 15e:	85ca                	mv	a1,s2
 160:	4505                	li	a0,1
 162:	3e8000ef          	jal	54a <write>
 166:	b7f1                	j	132 <grep+0x2c>
    if(m > 0){
 168:	03404563          	bgtz	s4,192 <grep+0x8c>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 16c:	414b863b          	subw	a2,s7,s4
 170:	014a85b3          	add	a1,s5,s4
 174:	855a                	mv	a0,s6
 176:	3cc000ef          	jal	542 <read>
 17a:	02a05963          	blez	a0,1ac <grep+0xa6>
    m += n;
 17e:	00aa0c3b          	addw	s8,s4,a0
 182:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
 186:	014a87b3          	add	a5,s5,s4
 18a:	00078023          	sb	zero,0(a5)
    p = buf;
 18e:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 190:	b75d                	j	136 <grep+0x30>
      m -= p - buf;
 192:	00002517          	auipc	a0,0x2
 196:	e7e50513          	addi	a0,a0,-386 # 2010 <buf>
 19a:	40a90a33          	sub	s4,s2,a0
 19e:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
 1a2:	8652                	mv	a2,s4
 1a4:	85ca                	mv	a1,s2
 1a6:	270000ef          	jal	416 <memmove>
 1aa:	b7c9                	j	16c <grep+0x66>
}
 1ac:	60a6                	ld	ra,72(sp)
 1ae:	6406                	ld	s0,64(sp)
 1b0:	74e2                	ld	s1,56(sp)
 1b2:	7942                	ld	s2,48(sp)
 1b4:	79a2                	ld	s3,40(sp)
 1b6:	7a02                	ld	s4,32(sp)
 1b8:	6ae2                	ld	s5,24(sp)
 1ba:	6b42                	ld	s6,16(sp)
 1bc:	6ba2                	ld	s7,8(sp)
 1be:	6c02                	ld	s8,0(sp)
 1c0:	6161                	addi	sp,sp,80
 1c2:	8082                	ret

00000000000001c4 <main>:
{
 1c4:	7179                	addi	sp,sp,-48
 1c6:	f406                	sd	ra,40(sp)
 1c8:	f022                	sd	s0,32(sp)
 1ca:	ec26                	sd	s1,24(sp)
 1cc:	e84a                	sd	s2,16(sp)
 1ce:	e44e                	sd	s3,8(sp)
 1d0:	e052                	sd	s4,0(sp)
 1d2:	1800                	addi	s0,sp,48
  if(argc <= 1){
 1d4:	4785                	li	a5,1
 1d6:	04a7d663          	bge	a5,a0,222 <main+0x5e>
  pattern = argv[1];
 1da:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1de:	4789                	li	a5,2
 1e0:	04a7db63          	bge	a5,a0,236 <main+0x72>
 1e4:	01058913          	addi	s2,a1,16
 1e8:	ffd5099b          	addiw	s3,a0,-3
 1ec:	02099793          	slli	a5,s3,0x20
 1f0:	01d7d993          	srli	s3,a5,0x1d
 1f4:	05e1                	addi	a1,a1,24
 1f6:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 1f8:	4581                	li	a1,0
 1fa:	00093503          	ld	a0,0(s2)
 1fe:	36c000ef          	jal	56a <open>
 202:	84aa                	mv	s1,a0
 204:	04054063          	bltz	a0,244 <main+0x80>
    grep(pattern, fd);
 208:	85aa                	mv	a1,a0
 20a:	8552                	mv	a0,s4
 20c:	efbff0ef          	jal	106 <grep>
    close(fd);
 210:	8526                	mv	a0,s1
 212:	340000ef          	jal	552 <close>
  for(i = 2; i < argc; i++){
 216:	0921                	addi	s2,s2,8
 218:	ff3910e3          	bne	s2,s3,1f8 <main+0x34>
  exit(0);
 21c:	4501                	li	a0,0
 21e:	30c000ef          	jal	52a <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 222:	00001597          	auipc	a1,0x1
 226:	8ce58593          	addi	a1,a1,-1842 # af0 <malloc+0xfa>
 22a:	4509                	li	a0,2
 22c:	6ec000ef          	jal	918 <fprintf>
    exit(1);
 230:	4505                	li	a0,1
 232:	2f8000ef          	jal	52a <exit>
    grep(pattern, 0);
 236:	4581                	li	a1,0
 238:	8552                	mv	a0,s4
 23a:	ecdff0ef          	jal	106 <grep>
    exit(0);
 23e:	4501                	li	a0,0
 240:	2ea000ef          	jal	52a <exit>
      printf("grep: cannot open %s\n", argv[i]);
 244:	00093583          	ld	a1,0(s2)
 248:	00001517          	auipc	a0,0x1
 24c:	8c850513          	addi	a0,a0,-1848 # b10 <malloc+0x11a>
 250:	6f2000ef          	jal	942 <printf>
      exit(1);
 254:	4505                	li	a0,1
 256:	2d4000ef          	jal	52a <exit>

000000000000025a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e406                	sd	ra,8(sp)
 25e:	e022                	sd	s0,0(sp)
 260:	0800                	addi	s0,sp,16
  extern int main();
  main();
 262:	f63ff0ef          	jal	1c4 <main>
  exit(0);
 266:	4501                	li	a0,0
 268:	2c2000ef          	jal	52a <exit>

000000000000026c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 272:	87aa                	mv	a5,a0
 274:	0585                	addi	a1,a1,1
 276:	0785                	addi	a5,a5,1
 278:	fff5c703          	lbu	a4,-1(a1)
 27c:	fee78fa3          	sb	a4,-1(a5)
 280:	fb75                	bnez	a4,274 <strcpy+0x8>
    ;
  return os;
}
 282:	6422                	ld	s0,8(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret

0000000000000288 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 28e:	00054783          	lbu	a5,0(a0)
 292:	cb91                	beqz	a5,2a6 <strcmp+0x1e>
 294:	0005c703          	lbu	a4,0(a1)
 298:	00f71763          	bne	a4,a5,2a6 <strcmp+0x1e>
    p++, q++;
 29c:	0505                	addi	a0,a0,1
 29e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	fbe5                	bnez	a5,294 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2a6:	0005c503          	lbu	a0,0(a1)
}
 2aa:	40a7853b          	subw	a0,a5,a0
 2ae:	6422                	ld	s0,8(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <strlen>:

uint
strlen(const char *s)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	cf91                	beqz	a5,2da <strlen+0x26>
 2c0:	0505                	addi	a0,a0,1
 2c2:	87aa                	mv	a5,a0
 2c4:	86be                	mv	a3,a5
 2c6:	0785                	addi	a5,a5,1
 2c8:	fff7c703          	lbu	a4,-1(a5)
 2cc:	ff65                	bnez	a4,2c4 <strlen+0x10>
 2ce:	40a6853b          	subw	a0,a3,a0
 2d2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  for(n = 0; s[n]; n++)
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <strlen+0x20>

00000000000002de <memset>:

void*
memset(void *dst, int c, uint n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2e4:	ca19                	beqz	a2,2fa <memset+0x1c>
 2e6:	87aa                	mv	a5,a0
 2e8:	1602                	slli	a2,a2,0x20
 2ea:	9201                	srli	a2,a2,0x20
 2ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2f0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2f4:	0785                	addi	a5,a5,1
 2f6:	fee79de3          	bne	a5,a4,2f0 <memset+0x12>
  }
  return dst;
}
 2fa:	6422                	ld	s0,8(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <strchr>:

char*
strchr(const char *s, char c)
{
 300:	1141                	addi	sp,sp,-16
 302:	e422                	sd	s0,8(sp)
 304:	0800                	addi	s0,sp,16
  for(; *s; s++)
 306:	00054783          	lbu	a5,0(a0)
 30a:	cb99                	beqz	a5,320 <strchr+0x20>
    if(*s == c)
 30c:	00f58763          	beq	a1,a5,31a <strchr+0x1a>
  for(; *s; s++)
 310:	0505                	addi	a0,a0,1
 312:	00054783          	lbu	a5,0(a0)
 316:	fbfd                	bnez	a5,30c <strchr+0xc>
      return (char*)s;
  return 0;
 318:	4501                	li	a0,0
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
  return 0;
 320:	4501                	li	a0,0
 322:	bfe5                	j	31a <strchr+0x1a>

0000000000000324 <gets>:

char*
gets(char *buf, int max)
{
 324:	711d                	addi	sp,sp,-96
 326:	ec86                	sd	ra,88(sp)
 328:	e8a2                	sd	s0,80(sp)
 32a:	e4a6                	sd	s1,72(sp)
 32c:	e0ca                	sd	s2,64(sp)
 32e:	fc4e                	sd	s3,56(sp)
 330:	f852                	sd	s4,48(sp)
 332:	f456                	sd	s5,40(sp)
 334:	f05a                	sd	s6,32(sp)
 336:	ec5e                	sd	s7,24(sp)
 338:	1080                	addi	s0,sp,96
 33a:	8baa                	mv	s7,a0
 33c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 33e:	892a                	mv	s2,a0
 340:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 342:	4aa9                	li	s5,10
 344:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 346:	89a6                	mv	s3,s1
 348:	2485                	addiw	s1,s1,1
 34a:	0344d663          	bge	s1,s4,376 <gets+0x52>
    cc = read(0, &c, 1);
 34e:	4605                	li	a2,1
 350:	faf40593          	addi	a1,s0,-81
 354:	4501                	li	a0,0
 356:	1ec000ef          	jal	542 <read>
    if(cc < 1)
 35a:	00a05e63          	blez	a0,376 <gets+0x52>
    buf[i++] = c;
 35e:	faf44783          	lbu	a5,-81(s0)
 362:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 366:	01578763          	beq	a5,s5,374 <gets+0x50>
 36a:	0905                	addi	s2,s2,1
 36c:	fd679de3          	bne	a5,s6,346 <gets+0x22>
    buf[i++] = c;
 370:	89a6                	mv	s3,s1
 372:	a011                	j	376 <gets+0x52>
 374:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 376:	99de                	add	s3,s3,s7
 378:	00098023          	sb	zero,0(s3)
  return buf;
}
 37c:	855e                	mv	a0,s7
 37e:	60e6                	ld	ra,88(sp)
 380:	6446                	ld	s0,80(sp)
 382:	64a6                	ld	s1,72(sp)
 384:	6906                	ld	s2,64(sp)
 386:	79e2                	ld	s3,56(sp)
 388:	7a42                	ld	s4,48(sp)
 38a:	7aa2                	ld	s5,40(sp)
 38c:	7b02                	ld	s6,32(sp)
 38e:	6be2                	ld	s7,24(sp)
 390:	6125                	addi	sp,sp,96
 392:	8082                	ret

0000000000000394 <stat>:

int
stat(const char *n, struct stat *st)
{
 394:	1101                	addi	sp,sp,-32
 396:	ec06                	sd	ra,24(sp)
 398:	e822                	sd	s0,16(sp)
 39a:	e04a                	sd	s2,0(sp)
 39c:	1000                	addi	s0,sp,32
 39e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a0:	4581                	li	a1,0
 3a2:	1c8000ef          	jal	56a <open>
  if(fd < 0)
 3a6:	02054263          	bltz	a0,3ca <stat+0x36>
 3aa:	e426                	sd	s1,8(sp)
 3ac:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3ae:	85ca                	mv	a1,s2
 3b0:	1d2000ef          	jal	582 <fstat>
 3b4:	892a                	mv	s2,a0
  close(fd);
 3b6:	8526                	mv	a0,s1
 3b8:	19a000ef          	jal	552 <close>
  return r;
 3bc:	64a2                	ld	s1,8(sp)
}
 3be:	854a                	mv	a0,s2
 3c0:	60e2                	ld	ra,24(sp)
 3c2:	6442                	ld	s0,16(sp)
 3c4:	6902                	ld	s2,0(sp)
 3c6:	6105                	addi	sp,sp,32
 3c8:	8082                	ret
    return -1;
 3ca:	597d                	li	s2,-1
 3cc:	bfcd                	j	3be <stat+0x2a>

00000000000003ce <atoi>:

int
atoi(const char *s)
{
 3ce:	1141                	addi	sp,sp,-16
 3d0:	e422                	sd	s0,8(sp)
 3d2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3d4:	00054683          	lbu	a3,0(a0)
 3d8:	fd06879b          	addiw	a5,a3,-48
 3dc:	0ff7f793          	zext.b	a5,a5
 3e0:	4625                	li	a2,9
 3e2:	02f66863          	bltu	a2,a5,412 <atoi+0x44>
 3e6:	872a                	mv	a4,a0
  n = 0;
 3e8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3ea:	0705                	addi	a4,a4,1
 3ec:	0025179b          	slliw	a5,a0,0x2
 3f0:	9fa9                	addw	a5,a5,a0
 3f2:	0017979b          	slliw	a5,a5,0x1
 3f6:	9fb5                	addw	a5,a5,a3
 3f8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3fc:	00074683          	lbu	a3,0(a4)
 400:	fd06879b          	addiw	a5,a3,-48
 404:	0ff7f793          	zext.b	a5,a5
 408:	fef671e3          	bgeu	a2,a5,3ea <atoi+0x1c>
  return n;
}
 40c:	6422                	ld	s0,8(sp)
 40e:	0141                	addi	sp,sp,16
 410:	8082                	ret
  n = 0;
 412:	4501                	li	a0,0
 414:	bfe5                	j	40c <atoi+0x3e>

0000000000000416 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 416:	1141                	addi	sp,sp,-16
 418:	e422                	sd	s0,8(sp)
 41a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 41c:	02b57463          	bgeu	a0,a1,444 <memmove+0x2e>
    while(n-- > 0)
 420:	00c05f63          	blez	a2,43e <memmove+0x28>
 424:	1602                	slli	a2,a2,0x20
 426:	9201                	srli	a2,a2,0x20
 428:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 42c:	872a                	mv	a4,a0
      *dst++ = *src++;
 42e:	0585                	addi	a1,a1,1
 430:	0705                	addi	a4,a4,1
 432:	fff5c683          	lbu	a3,-1(a1)
 436:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 43a:	fef71ae3          	bne	a4,a5,42e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 43e:	6422                	ld	s0,8(sp)
 440:	0141                	addi	sp,sp,16
 442:	8082                	ret
    dst += n;
 444:	00c50733          	add	a4,a0,a2
    src += n;
 448:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 44a:	fec05ae3          	blez	a2,43e <memmove+0x28>
 44e:	fff6079b          	addiw	a5,a2,-1
 452:	1782                	slli	a5,a5,0x20
 454:	9381                	srli	a5,a5,0x20
 456:	fff7c793          	not	a5,a5
 45a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 45c:	15fd                	addi	a1,a1,-1
 45e:	177d                	addi	a4,a4,-1
 460:	0005c683          	lbu	a3,0(a1)
 464:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 468:	fee79ae3          	bne	a5,a4,45c <memmove+0x46>
 46c:	bfc9                	j	43e <memmove+0x28>

000000000000046e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 46e:	1141                	addi	sp,sp,-16
 470:	e422                	sd	s0,8(sp)
 472:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 474:	ca05                	beqz	a2,4a4 <memcmp+0x36>
 476:	fff6069b          	addiw	a3,a2,-1
 47a:	1682                	slli	a3,a3,0x20
 47c:	9281                	srli	a3,a3,0x20
 47e:	0685                	addi	a3,a3,1
 480:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 482:	00054783          	lbu	a5,0(a0)
 486:	0005c703          	lbu	a4,0(a1)
 48a:	00e79863          	bne	a5,a4,49a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 48e:	0505                	addi	a0,a0,1
    p2++;
 490:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 492:	fed518e3          	bne	a0,a3,482 <memcmp+0x14>
  }
  return 0;
 496:	4501                	li	a0,0
 498:	a019                	j	49e <memcmp+0x30>
      return *p1 - *p2;
 49a:	40e7853b          	subw	a0,a5,a4
}
 49e:	6422                	ld	s0,8(sp)
 4a0:	0141                	addi	sp,sp,16
 4a2:	8082                	ret
  return 0;
 4a4:	4501                	li	a0,0
 4a6:	bfe5                	j	49e <memcmp+0x30>

00000000000004a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4a8:	1141                	addi	sp,sp,-16
 4aa:	e406                	sd	ra,8(sp)
 4ac:	e022                	sd	s0,0(sp)
 4ae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4b0:	f67ff0ef          	jal	416 <memmove>
}
 4b4:	60a2                	ld	ra,8(sp)
 4b6:	6402                	ld	s0,0(sp)
 4b8:	0141                	addi	sp,sp,16
 4ba:	8082                	ret

00000000000004bc <syscall>:

// Trap into kernel space for system calls
int syscall(int num, ...) {
 4bc:	7175                	addi	sp,sp,-144
 4be:	e4a2                	sd	s0,72(sp)
 4c0:	0880                	addi	s0,sp,80
 4c2:	832a                	mv	t1,a0
 4c4:	e40c                	sd	a1,8(s0)
 4c6:	e810                	sd	a2,16(s0)
 4c8:	ec14                	sd	a3,24(s0)
 4ca:	f018                	sd	a4,32(s0)
 4cc:	f41c                	sd	a5,40(s0)
 4ce:	03043823          	sd	a6,48(s0)
 4d2:	03143c23          	sd	a7,56(s0)
    uint64 args[6];
    va_list ap;
    int i;

    // Retrieve variable arguments passed to syscall
    va_start(ap, num);
 4d6:	00840793          	addi	a5,s0,8
 4da:	faf43c23          	sd	a5,-72(s0)
    for (i = 0; i < 6; i++) {
 4de:	fc040793          	addi	a5,s0,-64
 4e2:	ff040613          	addi	a2,s0,-16
        args[i] = va_arg(ap, uint64);
 4e6:	fb843703          	ld	a4,-72(s0)
 4ea:	00870693          	addi	a3,a4,8
 4ee:	fad43c23          	sd	a3,-72(s0)
 4f2:	6318                	ld	a4,0(a4)
 4f4:	e398                	sd	a4,0(a5)
    for (i = 0; i < 6; i++) {
 4f6:	07a1                	addi	a5,a5,8
 4f8:	fec797e3          	bne	a5,a2,4e6 <syscall+0x2a>
    }
    va_end(ap);

    // Place the system call number in a7, arguments in a0-a5
    register uint64 a0 asm("a0") = args[0];
 4fc:	fc043503          	ld	a0,-64(s0)
    register uint64 a1 asm("a1") = args[1];
 500:	fc843583          	ld	a1,-56(s0)
    register uint64 a2 asm("a2") = args[2];
 504:	fd043603          	ld	a2,-48(s0)
    register uint64 a3 asm("a3") = args[3];
 508:	fd843683          	ld	a3,-40(s0)
    register uint64 a4 asm("a4") = args[4];
 50c:	fe043703          	ld	a4,-32(s0)
    register uint64 a5 asm("a5") = args[5];
 510:	fe843783          	ld	a5,-24(s0)
    register uint64 a7 asm("a7") = num;
 514:	889a                	mv	a7,t1

    // Perform the ecall (traps into kernel space)
    asm volatile("ecall"
 516:	00000073          	ecall
                 : "r"(a1), "r"(a2), "r"(a3), "r"(a4), "r"(a5), "r"(a7)
                 : "memory");

    // Return value is stored in a0 after the trap
    return a0;
 51a:	2501                	sext.w	a0,a0
 51c:	6426                	ld	s0,72(sp)
 51e:	6149                	addi	sp,sp,144
 520:	8082                	ret

0000000000000522 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 522:	4885                	li	a7,1
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <exit>:
.global exit
exit:
 li a7, SYS_exit
 52a:	4889                	li	a7,2
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <wait>:
.global wait
wait:
 li a7, SYS_wait
 532:	488d                	li	a7,3
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 53a:	4891                	li	a7,4
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <read>:
.global read
read:
 li a7, SYS_read
 542:	4895                	li	a7,5
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <write>:
.global write
write:
 li a7, SYS_write
 54a:	48c1                	li	a7,16
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <close>:
.global close
close:
 li a7, SYS_close
 552:	48d5                	li	a7,21
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <kill>:
.global kill
kill:
 li a7, SYS_kill
 55a:	4899                	li	a7,6
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <exec>:
.global exec
exec:
 li a7, SYS_exec
 562:	489d                	li	a7,7
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <open>:
.global open
open:
 li a7, SYS_open
 56a:	48bd                	li	a7,15
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 572:	48c5                	li	a7,17
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 57a:	48c9                	li	a7,18
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 582:	48a1                	li	a7,8
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <link>:
.global link
link:
 li a7, SYS_link
 58a:	48cd                	li	a7,19
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 592:	48d1                	li	a7,20
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 59a:	48a5                	li	a7,9
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5a2:	48a9                	li	a7,10
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5aa:	48ad                	li	a7,11
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5b2:	48b1                	li	a7,12
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5ba:	48b5                	li	a7,13
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5c2:	48b9                	li	a7,14
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ca:	1101                	addi	sp,sp,-32
 5cc:	ec06                	sd	ra,24(sp)
 5ce:	e822                	sd	s0,16(sp)
 5d0:	1000                	addi	s0,sp,32
 5d2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5d6:	4605                	li	a2,1
 5d8:	fef40593          	addi	a1,s0,-17
 5dc:	f6fff0ef          	jal	54a <write>
}
 5e0:	60e2                	ld	ra,24(sp)
 5e2:	6442                	ld	s0,16(sp)
 5e4:	6105                	addi	sp,sp,32
 5e6:	8082                	ret

00000000000005e8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5e8:	7139                	addi	sp,sp,-64
 5ea:	fc06                	sd	ra,56(sp)
 5ec:	f822                	sd	s0,48(sp)
 5ee:	f426                	sd	s1,40(sp)
 5f0:	0080                	addi	s0,sp,64
 5f2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5f4:	c299                	beqz	a3,5fa <printint+0x12>
 5f6:	0805c963          	bltz	a1,688 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5fa:	2581                	sext.w	a1,a1
  neg = 0;
 5fc:	4881                	li	a7,0
 5fe:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 602:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 604:	2601                	sext.w	a2,a2
 606:	00000517          	auipc	a0,0x0
 60a:	52a50513          	addi	a0,a0,1322 # b30 <digits>
 60e:	883a                	mv	a6,a4
 610:	2705                	addiw	a4,a4,1
 612:	02c5f7bb          	remuw	a5,a1,a2
 616:	1782                	slli	a5,a5,0x20
 618:	9381                	srli	a5,a5,0x20
 61a:	97aa                	add	a5,a5,a0
 61c:	0007c783          	lbu	a5,0(a5)
 620:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 624:	0005879b          	sext.w	a5,a1
 628:	02c5d5bb          	divuw	a1,a1,a2
 62c:	0685                	addi	a3,a3,1
 62e:	fec7f0e3          	bgeu	a5,a2,60e <printint+0x26>
  if(neg)
 632:	00088c63          	beqz	a7,64a <printint+0x62>
    buf[i++] = '-';
 636:	fd070793          	addi	a5,a4,-48
 63a:	00878733          	add	a4,a5,s0
 63e:	02d00793          	li	a5,45
 642:	fef70823          	sb	a5,-16(a4)
 646:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 64a:	02e05a63          	blez	a4,67e <printint+0x96>
 64e:	f04a                	sd	s2,32(sp)
 650:	ec4e                	sd	s3,24(sp)
 652:	fc040793          	addi	a5,s0,-64
 656:	00e78933          	add	s2,a5,a4
 65a:	fff78993          	addi	s3,a5,-1
 65e:	99ba                	add	s3,s3,a4
 660:	377d                	addiw	a4,a4,-1
 662:	1702                	slli	a4,a4,0x20
 664:	9301                	srli	a4,a4,0x20
 666:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 66a:	fff94583          	lbu	a1,-1(s2)
 66e:	8526                	mv	a0,s1
 670:	f5bff0ef          	jal	5ca <putc>
  while(--i >= 0)
 674:	197d                	addi	s2,s2,-1
 676:	ff391ae3          	bne	s2,s3,66a <printint+0x82>
 67a:	7902                	ld	s2,32(sp)
 67c:	69e2                	ld	s3,24(sp)
}
 67e:	70e2                	ld	ra,56(sp)
 680:	7442                	ld	s0,48(sp)
 682:	74a2                	ld	s1,40(sp)
 684:	6121                	addi	sp,sp,64
 686:	8082                	ret
    x = -xx;
 688:	40b005bb          	negw	a1,a1
    neg = 1;
 68c:	4885                	li	a7,1
    x = -xx;
 68e:	bf85                	j	5fe <printint+0x16>

0000000000000690 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 690:	711d                	addi	sp,sp,-96
 692:	ec86                	sd	ra,88(sp)
 694:	e8a2                	sd	s0,80(sp)
 696:	e0ca                	sd	s2,64(sp)
 698:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 69a:	0005c903          	lbu	s2,0(a1)
 69e:	26090863          	beqz	s2,90e <vprintf+0x27e>
 6a2:	e4a6                	sd	s1,72(sp)
 6a4:	fc4e                	sd	s3,56(sp)
 6a6:	f852                	sd	s4,48(sp)
 6a8:	f456                	sd	s5,40(sp)
 6aa:	f05a                	sd	s6,32(sp)
 6ac:	ec5e                	sd	s7,24(sp)
 6ae:	e862                	sd	s8,16(sp)
 6b0:	e466                	sd	s9,8(sp)
 6b2:	8b2a                	mv	s6,a0
 6b4:	8a2e                	mv	s4,a1
 6b6:	8bb2                	mv	s7,a2
  state = 0;
 6b8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6ba:	4481                	li	s1,0
 6bc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6be:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6c2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6c6:	06c00c93          	li	s9,108
 6ca:	a005                	j	6ea <vprintf+0x5a>
        putc(fd, c0);
 6cc:	85ca                	mv	a1,s2
 6ce:	855a                	mv	a0,s6
 6d0:	efbff0ef          	jal	5ca <putc>
 6d4:	a019                	j	6da <vprintf+0x4a>
    } else if(state == '%'){
 6d6:	03598263          	beq	s3,s5,6fa <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6da:	2485                	addiw	s1,s1,1
 6dc:	8726                	mv	a4,s1
 6de:	009a07b3          	add	a5,s4,s1
 6e2:	0007c903          	lbu	s2,0(a5)
 6e6:	20090c63          	beqz	s2,8fe <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6ea:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6ee:	fe0994e3          	bnez	s3,6d6 <vprintf+0x46>
      if(c0 == '%'){
 6f2:	fd579de3          	bne	a5,s5,6cc <vprintf+0x3c>
        state = '%';
 6f6:	89be                	mv	s3,a5
 6f8:	b7cd                	j	6da <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6fa:	00ea06b3          	add	a3,s4,a4
 6fe:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 702:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 704:	c681                	beqz	a3,70c <vprintf+0x7c>
 706:	9752                	add	a4,a4,s4
 708:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 70c:	03878f63          	beq	a5,s8,74a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 710:	05978963          	beq	a5,s9,762 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 714:	07500713          	li	a4,117
 718:	0ee78363          	beq	a5,a4,7fe <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 71c:	07800713          	li	a4,120
 720:	12e78563          	beq	a5,a4,84a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 724:	07000713          	li	a4,112
 728:	14e78a63          	beq	a5,a4,87c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 72c:	07300713          	li	a4,115
 730:	18e78a63          	beq	a5,a4,8c4 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 734:	02500713          	li	a4,37
 738:	04e79563          	bne	a5,a4,782 <vprintf+0xf2>
        putc(fd, '%');
 73c:	02500593          	li	a1,37
 740:	855a                	mv	a0,s6
 742:	e89ff0ef          	jal	5ca <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 746:	4981                	li	s3,0
 748:	bf49                	j	6da <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 74a:	008b8913          	addi	s2,s7,8
 74e:	4685                	li	a3,1
 750:	4629                	li	a2,10
 752:	000ba583          	lw	a1,0(s7)
 756:	855a                	mv	a0,s6
 758:	e91ff0ef          	jal	5e8 <printint>
 75c:	8bca                	mv	s7,s2
      state = 0;
 75e:	4981                	li	s3,0
 760:	bfad                	j	6da <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 762:	06400793          	li	a5,100
 766:	02f68963          	beq	a3,a5,798 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 76a:	06c00793          	li	a5,108
 76e:	04f68263          	beq	a3,a5,7b2 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 772:	07500793          	li	a5,117
 776:	0af68063          	beq	a3,a5,816 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 77a:	07800793          	li	a5,120
 77e:	0ef68263          	beq	a3,a5,862 <vprintf+0x1d2>
        putc(fd, '%');
 782:	02500593          	li	a1,37
 786:	855a                	mv	a0,s6
 788:	e43ff0ef          	jal	5ca <putc>
        putc(fd, c0);
 78c:	85ca                	mv	a1,s2
 78e:	855a                	mv	a0,s6
 790:	e3bff0ef          	jal	5ca <putc>
      state = 0;
 794:	4981                	li	s3,0
 796:	b791                	j	6da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 798:	008b8913          	addi	s2,s7,8
 79c:	4685                	li	a3,1
 79e:	4629                	li	a2,10
 7a0:	000ba583          	lw	a1,0(s7)
 7a4:	855a                	mv	a0,s6
 7a6:	e43ff0ef          	jal	5e8 <printint>
        i += 1;
 7aa:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ac:	8bca                	mv	s7,s2
      state = 0;
 7ae:	4981                	li	s3,0
        i += 1;
 7b0:	b72d                	j	6da <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7b2:	06400793          	li	a5,100
 7b6:	02f60763          	beq	a2,a5,7e4 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7ba:	07500793          	li	a5,117
 7be:	06f60963          	beq	a2,a5,830 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7c2:	07800793          	li	a5,120
 7c6:	faf61ee3          	bne	a2,a5,782 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ca:	008b8913          	addi	s2,s7,8
 7ce:	4681                	li	a3,0
 7d0:	4641                	li	a2,16
 7d2:	000ba583          	lw	a1,0(s7)
 7d6:	855a                	mv	a0,s6
 7d8:	e11ff0ef          	jal	5e8 <printint>
        i += 2;
 7dc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7de:	8bca                	mv	s7,s2
      state = 0;
 7e0:	4981                	li	s3,0
        i += 2;
 7e2:	bde5                	j	6da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7e4:	008b8913          	addi	s2,s7,8
 7e8:	4685                	li	a3,1
 7ea:	4629                	li	a2,10
 7ec:	000ba583          	lw	a1,0(s7)
 7f0:	855a                	mv	a0,s6
 7f2:	df7ff0ef          	jal	5e8 <printint>
        i += 2;
 7f6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f8:	8bca                	mv	s7,s2
      state = 0;
 7fa:	4981                	li	s3,0
        i += 2;
 7fc:	bdf9                	j	6da <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7fe:	008b8913          	addi	s2,s7,8
 802:	4681                	li	a3,0
 804:	4629                	li	a2,10
 806:	000ba583          	lw	a1,0(s7)
 80a:	855a                	mv	a0,s6
 80c:	dddff0ef          	jal	5e8 <printint>
 810:	8bca                	mv	s7,s2
      state = 0;
 812:	4981                	li	s3,0
 814:	b5d9                	j	6da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 816:	008b8913          	addi	s2,s7,8
 81a:	4681                	li	a3,0
 81c:	4629                	li	a2,10
 81e:	000ba583          	lw	a1,0(s7)
 822:	855a                	mv	a0,s6
 824:	dc5ff0ef          	jal	5e8 <printint>
        i += 1;
 828:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 82a:	8bca                	mv	s7,s2
      state = 0;
 82c:	4981                	li	s3,0
        i += 1;
 82e:	b575                	j	6da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 830:	008b8913          	addi	s2,s7,8
 834:	4681                	li	a3,0
 836:	4629                	li	a2,10
 838:	000ba583          	lw	a1,0(s7)
 83c:	855a                	mv	a0,s6
 83e:	dabff0ef          	jal	5e8 <printint>
        i += 2;
 842:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 844:	8bca                	mv	s7,s2
      state = 0;
 846:	4981                	li	s3,0
        i += 2;
 848:	bd49                	j	6da <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 84a:	008b8913          	addi	s2,s7,8
 84e:	4681                	li	a3,0
 850:	4641                	li	a2,16
 852:	000ba583          	lw	a1,0(s7)
 856:	855a                	mv	a0,s6
 858:	d91ff0ef          	jal	5e8 <printint>
 85c:	8bca                	mv	s7,s2
      state = 0;
 85e:	4981                	li	s3,0
 860:	bdad                	j	6da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 862:	008b8913          	addi	s2,s7,8
 866:	4681                	li	a3,0
 868:	4641                	li	a2,16
 86a:	000ba583          	lw	a1,0(s7)
 86e:	855a                	mv	a0,s6
 870:	d79ff0ef          	jal	5e8 <printint>
        i += 1;
 874:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 876:	8bca                	mv	s7,s2
      state = 0;
 878:	4981                	li	s3,0
        i += 1;
 87a:	b585                	j	6da <vprintf+0x4a>
 87c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 87e:	008b8d13          	addi	s10,s7,8
 882:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 886:	03000593          	li	a1,48
 88a:	855a                	mv	a0,s6
 88c:	d3fff0ef          	jal	5ca <putc>
  putc(fd, 'x');
 890:	07800593          	li	a1,120
 894:	855a                	mv	a0,s6
 896:	d35ff0ef          	jal	5ca <putc>
 89a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 89c:	00000b97          	auipc	s7,0x0
 8a0:	294b8b93          	addi	s7,s7,660 # b30 <digits>
 8a4:	03c9d793          	srli	a5,s3,0x3c
 8a8:	97de                	add	a5,a5,s7
 8aa:	0007c583          	lbu	a1,0(a5)
 8ae:	855a                	mv	a0,s6
 8b0:	d1bff0ef          	jal	5ca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8b4:	0992                	slli	s3,s3,0x4
 8b6:	397d                	addiw	s2,s2,-1
 8b8:	fe0916e3          	bnez	s2,8a4 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 8bc:	8bea                	mv	s7,s10
      state = 0;
 8be:	4981                	li	s3,0
 8c0:	6d02                	ld	s10,0(sp)
 8c2:	bd21                	j	6da <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8c4:	008b8993          	addi	s3,s7,8
 8c8:	000bb903          	ld	s2,0(s7)
 8cc:	00090f63          	beqz	s2,8ea <vprintf+0x25a>
        for(; *s; s++)
 8d0:	00094583          	lbu	a1,0(s2)
 8d4:	c195                	beqz	a1,8f8 <vprintf+0x268>
          putc(fd, *s);
 8d6:	855a                	mv	a0,s6
 8d8:	cf3ff0ef          	jal	5ca <putc>
        for(; *s; s++)
 8dc:	0905                	addi	s2,s2,1
 8de:	00094583          	lbu	a1,0(s2)
 8e2:	f9f5                	bnez	a1,8d6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8e4:	8bce                	mv	s7,s3
      state = 0;
 8e6:	4981                	li	s3,0
 8e8:	bbcd                	j	6da <vprintf+0x4a>
          s = "(null)";
 8ea:	00000917          	auipc	s2,0x0
 8ee:	23e90913          	addi	s2,s2,574 # b28 <malloc+0x132>
        for(; *s; s++)
 8f2:	02800593          	li	a1,40
 8f6:	b7c5                	j	8d6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8f8:	8bce                	mv	s7,s3
      state = 0;
 8fa:	4981                	li	s3,0
 8fc:	bbf9                	j	6da <vprintf+0x4a>
 8fe:	64a6                	ld	s1,72(sp)
 900:	79e2                	ld	s3,56(sp)
 902:	7a42                	ld	s4,48(sp)
 904:	7aa2                	ld	s5,40(sp)
 906:	7b02                	ld	s6,32(sp)
 908:	6be2                	ld	s7,24(sp)
 90a:	6c42                	ld	s8,16(sp)
 90c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 90e:	60e6                	ld	ra,88(sp)
 910:	6446                	ld	s0,80(sp)
 912:	6906                	ld	s2,64(sp)
 914:	6125                	addi	sp,sp,96
 916:	8082                	ret

0000000000000918 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 918:	715d                	addi	sp,sp,-80
 91a:	ec06                	sd	ra,24(sp)
 91c:	e822                	sd	s0,16(sp)
 91e:	1000                	addi	s0,sp,32
 920:	e010                	sd	a2,0(s0)
 922:	e414                	sd	a3,8(s0)
 924:	e818                	sd	a4,16(s0)
 926:	ec1c                	sd	a5,24(s0)
 928:	03043023          	sd	a6,32(s0)
 92c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 930:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 934:	8622                	mv	a2,s0
 936:	d5bff0ef          	jal	690 <vprintf>
}
 93a:	60e2                	ld	ra,24(sp)
 93c:	6442                	ld	s0,16(sp)
 93e:	6161                	addi	sp,sp,80
 940:	8082                	ret

0000000000000942 <printf>:

void
printf(const char *fmt, ...)
{
 942:	711d                	addi	sp,sp,-96
 944:	ec06                	sd	ra,24(sp)
 946:	e822                	sd	s0,16(sp)
 948:	1000                	addi	s0,sp,32
 94a:	e40c                	sd	a1,8(s0)
 94c:	e810                	sd	a2,16(s0)
 94e:	ec14                	sd	a3,24(s0)
 950:	f018                	sd	a4,32(s0)
 952:	f41c                	sd	a5,40(s0)
 954:	03043823          	sd	a6,48(s0)
 958:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 95c:	00840613          	addi	a2,s0,8
 960:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 964:	85aa                	mv	a1,a0
 966:	4505                	li	a0,1
 968:	d29ff0ef          	jal	690 <vprintf>
}
 96c:	60e2                	ld	ra,24(sp)
 96e:	6442                	ld	s0,16(sp)
 970:	6125                	addi	sp,sp,96
 972:	8082                	ret

0000000000000974 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 974:	1141                	addi	sp,sp,-16
 976:	e422                	sd	s0,8(sp)
 978:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 97a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 97e:	00001797          	auipc	a5,0x1
 982:	6827b783          	ld	a5,1666(a5) # 2000 <freep>
 986:	a02d                	j	9b0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 988:	4618                	lw	a4,8(a2)
 98a:	9f2d                	addw	a4,a4,a1
 98c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 990:	6398                	ld	a4,0(a5)
 992:	6310                	ld	a2,0(a4)
 994:	a83d                	j	9d2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 996:	ff852703          	lw	a4,-8(a0)
 99a:	9f31                	addw	a4,a4,a2
 99c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 99e:	ff053683          	ld	a3,-16(a0)
 9a2:	a091                	j	9e6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a4:	6398                	ld	a4,0(a5)
 9a6:	00e7e463          	bltu	a5,a4,9ae <free+0x3a>
 9aa:	00e6ea63          	bltu	a3,a4,9be <free+0x4a>
{
 9ae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b0:	fed7fae3          	bgeu	a5,a3,9a4 <free+0x30>
 9b4:	6398                	ld	a4,0(a5)
 9b6:	00e6e463          	bltu	a3,a4,9be <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ba:	fee7eae3          	bltu	a5,a4,9ae <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9be:	ff852583          	lw	a1,-8(a0)
 9c2:	6390                	ld	a2,0(a5)
 9c4:	02059813          	slli	a6,a1,0x20
 9c8:	01c85713          	srli	a4,a6,0x1c
 9cc:	9736                	add	a4,a4,a3
 9ce:	fae60de3          	beq	a2,a4,988 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9d2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9d6:	4790                	lw	a2,8(a5)
 9d8:	02061593          	slli	a1,a2,0x20
 9dc:	01c5d713          	srli	a4,a1,0x1c
 9e0:	973e                	add	a4,a4,a5
 9e2:	fae68ae3          	beq	a3,a4,996 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9e6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9e8:	00001717          	auipc	a4,0x1
 9ec:	60f73c23          	sd	a5,1560(a4) # 2000 <freep>
}
 9f0:	6422                	ld	s0,8(sp)
 9f2:	0141                	addi	sp,sp,16
 9f4:	8082                	ret

00000000000009f6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9f6:	7139                	addi	sp,sp,-64
 9f8:	fc06                	sd	ra,56(sp)
 9fa:	f822                	sd	s0,48(sp)
 9fc:	f426                	sd	s1,40(sp)
 9fe:	ec4e                	sd	s3,24(sp)
 a00:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a02:	02051493          	slli	s1,a0,0x20
 a06:	9081                	srli	s1,s1,0x20
 a08:	04bd                	addi	s1,s1,15
 a0a:	8091                	srli	s1,s1,0x4
 a0c:	0014899b          	addiw	s3,s1,1
 a10:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a12:	00001517          	auipc	a0,0x1
 a16:	5ee53503          	ld	a0,1518(a0) # 2000 <freep>
 a1a:	c915                	beqz	a0,a4e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a1c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a1e:	4798                	lw	a4,8(a5)
 a20:	08977a63          	bgeu	a4,s1,ab4 <malloc+0xbe>
 a24:	f04a                	sd	s2,32(sp)
 a26:	e852                	sd	s4,16(sp)
 a28:	e456                	sd	s5,8(sp)
 a2a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a2c:	8a4e                	mv	s4,s3
 a2e:	0009871b          	sext.w	a4,s3
 a32:	6685                	lui	a3,0x1
 a34:	00d77363          	bgeu	a4,a3,a3a <malloc+0x44>
 a38:	6a05                	lui	s4,0x1
 a3a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a3e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a42:	00001917          	auipc	s2,0x1
 a46:	5be90913          	addi	s2,s2,1470 # 2000 <freep>
  if(p == (char*)-1)
 a4a:	5afd                	li	s5,-1
 a4c:	a081                	j	a8c <malloc+0x96>
 a4e:	f04a                	sd	s2,32(sp)
 a50:	e852                	sd	s4,16(sp)
 a52:	e456                	sd	s5,8(sp)
 a54:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a56:	00002797          	auipc	a5,0x2
 a5a:	9ba78793          	addi	a5,a5,-1606 # 2410 <base>
 a5e:	00001717          	auipc	a4,0x1
 a62:	5af73123          	sd	a5,1442(a4) # 2000 <freep>
 a66:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a68:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a6c:	b7c1                	j	a2c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a6e:	6398                	ld	a4,0(a5)
 a70:	e118                	sd	a4,0(a0)
 a72:	a8a9                	j	acc <malloc+0xd6>
  hp->s.size = nu;
 a74:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a78:	0541                	addi	a0,a0,16
 a7a:	efbff0ef          	jal	974 <free>
  return freep;
 a7e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a82:	c12d                	beqz	a0,ae4 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a84:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a86:	4798                	lw	a4,8(a5)
 a88:	02977263          	bgeu	a4,s1,aac <malloc+0xb6>
    if(p == freep)
 a8c:	00093703          	ld	a4,0(s2)
 a90:	853e                	mv	a0,a5
 a92:	fef719e3          	bne	a4,a5,a84 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a96:	8552                	mv	a0,s4
 a98:	b1bff0ef          	jal	5b2 <sbrk>
  if(p == (char*)-1)
 a9c:	fd551ce3          	bne	a0,s5,a74 <malloc+0x7e>
        return 0;
 aa0:	4501                	li	a0,0
 aa2:	7902                	ld	s2,32(sp)
 aa4:	6a42                	ld	s4,16(sp)
 aa6:	6aa2                	ld	s5,8(sp)
 aa8:	6b02                	ld	s6,0(sp)
 aaa:	a03d                	j	ad8 <malloc+0xe2>
 aac:	7902                	ld	s2,32(sp)
 aae:	6a42                	ld	s4,16(sp)
 ab0:	6aa2                	ld	s5,8(sp)
 ab2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ab4:	fae48de3          	beq	s1,a4,a6e <malloc+0x78>
        p->s.size -= nunits;
 ab8:	4137073b          	subw	a4,a4,s3
 abc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 abe:	02071693          	slli	a3,a4,0x20
 ac2:	01c6d713          	srli	a4,a3,0x1c
 ac6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ac8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 acc:	00001717          	auipc	a4,0x1
 ad0:	52a73a23          	sd	a0,1332(a4) # 2000 <freep>
      return (void*)(p + 1);
 ad4:	01078513          	addi	a0,a5,16
  }
}
 ad8:	70e2                	ld	ra,56(sp)
 ada:	7442                	ld	s0,48(sp)
 adc:	74a2                	ld	s1,40(sp)
 ade:	69e2                	ld	s3,24(sp)
 ae0:	6121                	addi	sp,sp,64
 ae2:	8082                	ret
 ae4:	7902                	ld	s2,32(sp)
 ae6:	6a42                	ld	s4,16(sp)
 ae8:	6aa2                	ld	s5,8(sp)
 aea:	6b02                	ld	s6,0(sp)
 aec:	b7f5                	j	ad8 <malloc+0xe2>
