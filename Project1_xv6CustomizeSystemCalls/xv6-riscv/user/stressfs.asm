
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	98a78793          	addi	a5,a5,-1654 # 9a0 <malloc+0x12c>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	94450513          	addi	a0,a0,-1724 # 970 <malloc+0xfc>
  34:	78c000ef          	jal	7c0 <printf>
  memset(data, 'a', sizeof(data));
  38:	20000613          	li	a2,512
  3c:	06100593          	li	a1,97
  40:	dd040513          	addi	a0,s0,-560
  44:	118000ef          	jal	15c <memset>

  for(i = 0; i < 4; i++)
  48:	4481                	li	s1,0
  4a:	4911                	li	s2,4
    if(fork() > 0)
  4c:	354000ef          	jal	3a0 <fork>
  50:	00a04563          	bgtz	a0,5a <main+0x5a>
  for(i = 0; i < 4; i++)
  54:	2485                	addiw	s1,s1,1
  56:	ff249be3          	bne	s1,s2,4c <main+0x4c>
      break;

  printf("write %d\n", i);
  5a:	85a6                	mv	a1,s1
  5c:	00001517          	auipc	a0,0x1
  60:	92c50513          	addi	a0,a0,-1748 # 988 <malloc+0x114>
  64:	75c000ef          	jal	7c0 <printf>

  path[8] += i;
  68:	fd844783          	lbu	a5,-40(s0)
  6c:	9fa5                	addw	a5,a5,s1
  6e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  72:	20200593          	li	a1,514
  76:	fd040513          	addi	a0,s0,-48
  7a:	36e000ef          	jal	3e8 <open>
  7e:	892a                	mv	s2,a0
  80:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  82:	20000613          	li	a2,512
  86:	dd040593          	addi	a1,s0,-560
  8a:	854a                	mv	a0,s2
  8c:	33c000ef          	jal	3c8 <write>
  for(i = 0; i < 20; i++)
  90:	34fd                	addiw	s1,s1,-1
  92:	f8e5                	bnez	s1,82 <main+0x82>
  close(fd);
  94:	854a                	mv	a0,s2
  96:	33a000ef          	jal	3d0 <close>

  printf("read\n");
  9a:	00001517          	auipc	a0,0x1
  9e:	8fe50513          	addi	a0,a0,-1794 # 998 <malloc+0x124>
  a2:	71e000ef          	jal	7c0 <printf>

  fd = open(path, O_RDONLY);
  a6:	4581                	li	a1,0
  a8:	fd040513          	addi	a0,s0,-48
  ac:	33c000ef          	jal	3e8 <open>
  b0:	892a                	mv	s2,a0
  b2:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  b4:	20000613          	li	a2,512
  b8:	dd040593          	addi	a1,s0,-560
  bc:	854a                	mv	a0,s2
  be:	302000ef          	jal	3c0 <read>
  for (i = 0; i < 20; i++)
  c2:	34fd                	addiw	s1,s1,-1
  c4:	f8e5                	bnez	s1,b4 <main+0xb4>
  close(fd);
  c6:	854a                	mv	a0,s2
  c8:	308000ef          	jal	3d0 <close>

  wait(0);
  cc:	4501                	li	a0,0
  ce:	2e2000ef          	jal	3b0 <wait>

  exit(0);
  d2:	4501                	li	a0,0
  d4:	2d4000ef          	jal	3a8 <exit>

00000000000000d8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  extern int main();
  main();
  e0:	f21ff0ef          	jal	0 <main>
  exit(0);
  e4:	4501                	li	a0,0
  e6:	2c2000ef          	jal	3a8 <exit>

00000000000000ea <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f0:	87aa                	mv	a5,a0
  f2:	0585                	addi	a1,a1,1
  f4:	0785                	addi	a5,a5,1
  f6:	fff5c703          	lbu	a4,-1(a1)
  fa:	fee78fa3          	sb	a4,-1(a5)
  fe:	fb75                	bnez	a4,f2 <strcpy+0x8>
    ;
  return os;
}
 100:	6422                	ld	s0,8(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret

0000000000000106 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 106:	1141                	addi	sp,sp,-16
 108:	e422                	sd	s0,8(sp)
 10a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	cb91                	beqz	a5,124 <strcmp+0x1e>
 112:	0005c703          	lbu	a4,0(a1)
 116:	00f71763          	bne	a4,a5,124 <strcmp+0x1e>
    p++, q++;
 11a:	0505                	addi	a0,a0,1
 11c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbe5                	bnez	a5,112 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 124:	0005c503          	lbu	a0,0(a1)
}
 128:	40a7853b          	subw	a0,a5,a0
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strlen>:

uint
strlen(const char *s)
{
 132:	1141                	addi	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cf91                	beqz	a5,158 <strlen+0x26>
 13e:	0505                	addi	a0,a0,1
 140:	87aa                	mv	a5,a0
 142:	86be                	mv	a3,a5
 144:	0785                	addi	a5,a5,1
 146:	fff7c703          	lbu	a4,-1(a5)
 14a:	ff65                	bnez	a4,142 <strlen+0x10>
 14c:	40a6853b          	subw	a0,a3,a0
 150:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret
  for(n = 0; s[n]; n++)
 158:	4501                	li	a0,0
 15a:	bfe5                	j	152 <strlen+0x20>

000000000000015c <memset>:

void*
memset(void *dst, int c, uint n)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e422                	sd	s0,8(sp)
 160:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 162:	ca19                	beqz	a2,178 <memset+0x1c>
 164:	87aa                	mv	a5,a0
 166:	1602                	slli	a2,a2,0x20
 168:	9201                	srli	a2,a2,0x20
 16a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 16e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 172:	0785                	addi	a5,a5,1
 174:	fee79de3          	bne	a5,a4,16e <memset+0x12>
  }
  return dst;
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret

000000000000017e <strchr>:

char*
strchr(const char *s, char c)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
  for(; *s; s++)
 184:	00054783          	lbu	a5,0(a0)
 188:	cb99                	beqz	a5,19e <strchr+0x20>
    if(*s == c)
 18a:	00f58763          	beq	a1,a5,198 <strchr+0x1a>
  for(; *s; s++)
 18e:	0505                	addi	a0,a0,1
 190:	00054783          	lbu	a5,0(a0)
 194:	fbfd                	bnez	a5,18a <strchr+0xc>
      return (char*)s;
  return 0;
 196:	4501                	li	a0,0
}
 198:	6422                	ld	s0,8(sp)
 19a:	0141                	addi	sp,sp,16
 19c:	8082                	ret
  return 0;
 19e:	4501                	li	a0,0
 1a0:	bfe5                	j	198 <strchr+0x1a>

00000000000001a2 <gets>:

char*
gets(char *buf, int max)
{
 1a2:	711d                	addi	sp,sp,-96
 1a4:	ec86                	sd	ra,88(sp)
 1a6:	e8a2                	sd	s0,80(sp)
 1a8:	e4a6                	sd	s1,72(sp)
 1aa:	e0ca                	sd	s2,64(sp)
 1ac:	fc4e                	sd	s3,56(sp)
 1ae:	f852                	sd	s4,48(sp)
 1b0:	f456                	sd	s5,40(sp)
 1b2:	f05a                	sd	s6,32(sp)
 1b4:	ec5e                	sd	s7,24(sp)
 1b6:	1080                	addi	s0,sp,96
 1b8:	8baa                	mv	s7,a0
 1ba:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bc:	892a                	mv	s2,a0
 1be:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c0:	4aa9                	li	s5,10
 1c2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1c4:	89a6                	mv	s3,s1
 1c6:	2485                	addiw	s1,s1,1
 1c8:	0344d663          	bge	s1,s4,1f4 <gets+0x52>
    cc = read(0, &c, 1);
 1cc:	4605                	li	a2,1
 1ce:	faf40593          	addi	a1,s0,-81
 1d2:	4501                	li	a0,0
 1d4:	1ec000ef          	jal	3c0 <read>
    if(cc < 1)
 1d8:	00a05e63          	blez	a0,1f4 <gets+0x52>
    buf[i++] = c;
 1dc:	faf44783          	lbu	a5,-81(s0)
 1e0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e4:	01578763          	beq	a5,s5,1f2 <gets+0x50>
 1e8:	0905                	addi	s2,s2,1
 1ea:	fd679de3          	bne	a5,s6,1c4 <gets+0x22>
    buf[i++] = c;
 1ee:	89a6                	mv	s3,s1
 1f0:	a011                	j	1f4 <gets+0x52>
 1f2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1f4:	99de                	add	s3,s3,s7
 1f6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1fa:	855e                	mv	a0,s7
 1fc:	60e6                	ld	ra,88(sp)
 1fe:	6446                	ld	s0,80(sp)
 200:	64a6                	ld	s1,72(sp)
 202:	6906                	ld	s2,64(sp)
 204:	79e2                	ld	s3,56(sp)
 206:	7a42                	ld	s4,48(sp)
 208:	7aa2                	ld	s5,40(sp)
 20a:	7b02                	ld	s6,32(sp)
 20c:	6be2                	ld	s7,24(sp)
 20e:	6125                	addi	sp,sp,96
 210:	8082                	ret

0000000000000212 <stat>:

int
stat(const char *n, struct stat *st)
{
 212:	1101                	addi	sp,sp,-32
 214:	ec06                	sd	ra,24(sp)
 216:	e822                	sd	s0,16(sp)
 218:	e04a                	sd	s2,0(sp)
 21a:	1000                	addi	s0,sp,32
 21c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21e:	4581                	li	a1,0
 220:	1c8000ef          	jal	3e8 <open>
  if(fd < 0)
 224:	02054263          	bltz	a0,248 <stat+0x36>
 228:	e426                	sd	s1,8(sp)
 22a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 22c:	85ca                	mv	a1,s2
 22e:	1d2000ef          	jal	400 <fstat>
 232:	892a                	mv	s2,a0
  close(fd);
 234:	8526                	mv	a0,s1
 236:	19a000ef          	jal	3d0 <close>
  return r;
 23a:	64a2                	ld	s1,8(sp)
}
 23c:	854a                	mv	a0,s2
 23e:	60e2                	ld	ra,24(sp)
 240:	6442                	ld	s0,16(sp)
 242:	6902                	ld	s2,0(sp)
 244:	6105                	addi	sp,sp,32
 246:	8082                	ret
    return -1;
 248:	597d                	li	s2,-1
 24a:	bfcd                	j	23c <stat+0x2a>

000000000000024c <atoi>:

int
atoi(const char *s)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 252:	00054683          	lbu	a3,0(a0)
 256:	fd06879b          	addiw	a5,a3,-48
 25a:	0ff7f793          	zext.b	a5,a5
 25e:	4625                	li	a2,9
 260:	02f66863          	bltu	a2,a5,290 <atoi+0x44>
 264:	872a                	mv	a4,a0
  n = 0;
 266:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 268:	0705                	addi	a4,a4,1
 26a:	0025179b          	slliw	a5,a0,0x2
 26e:	9fa9                	addw	a5,a5,a0
 270:	0017979b          	slliw	a5,a5,0x1
 274:	9fb5                	addw	a5,a5,a3
 276:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 27a:	00074683          	lbu	a3,0(a4)
 27e:	fd06879b          	addiw	a5,a3,-48
 282:	0ff7f793          	zext.b	a5,a5
 286:	fef671e3          	bgeu	a2,a5,268 <atoi+0x1c>
  return n;
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret
  n = 0;
 290:	4501                	li	a0,0
 292:	bfe5                	j	28a <atoi+0x3e>

0000000000000294 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 294:	1141                	addi	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 29a:	02b57463          	bgeu	a0,a1,2c2 <memmove+0x2e>
    while(n-- > 0)
 29e:	00c05f63          	blez	a2,2bc <memmove+0x28>
 2a2:	1602                	slli	a2,a2,0x20
 2a4:	9201                	srli	a2,a2,0x20
 2a6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2aa:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ac:	0585                	addi	a1,a1,1
 2ae:	0705                	addi	a4,a4,1
 2b0:	fff5c683          	lbu	a3,-1(a1)
 2b4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2b8:	fef71ae3          	bne	a4,a5,2ac <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
    dst += n;
 2c2:	00c50733          	add	a4,a0,a2
    src += n;
 2c6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2c8:	fec05ae3          	blez	a2,2bc <memmove+0x28>
 2cc:	fff6079b          	addiw	a5,a2,-1
 2d0:	1782                	slli	a5,a5,0x20
 2d2:	9381                	srli	a5,a5,0x20
 2d4:	fff7c793          	not	a5,a5
 2d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2da:	15fd                	addi	a1,a1,-1
 2dc:	177d                	addi	a4,a4,-1
 2de:	0005c683          	lbu	a3,0(a1)
 2e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e6:	fee79ae3          	bne	a5,a4,2da <memmove+0x46>
 2ea:	bfc9                	j	2bc <memmove+0x28>

00000000000002ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f2:	ca05                	beqz	a2,322 <memcmp+0x36>
 2f4:	fff6069b          	addiw	a3,a2,-1
 2f8:	1682                	slli	a3,a3,0x20
 2fa:	9281                	srli	a3,a3,0x20
 2fc:	0685                	addi	a3,a3,1
 2fe:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 300:	00054783          	lbu	a5,0(a0)
 304:	0005c703          	lbu	a4,0(a1)
 308:	00e79863          	bne	a5,a4,318 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 30c:	0505                	addi	a0,a0,1
    p2++;
 30e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 310:	fed518e3          	bne	a0,a3,300 <memcmp+0x14>
  }
  return 0;
 314:	4501                	li	a0,0
 316:	a019                	j	31c <memcmp+0x30>
      return *p1 - *p2;
 318:	40e7853b          	subw	a0,a5,a4
}
 31c:	6422                	ld	s0,8(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret
  return 0;
 322:	4501                	li	a0,0
 324:	bfe5                	j	31c <memcmp+0x30>

0000000000000326 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 326:	1141                	addi	sp,sp,-16
 328:	e406                	sd	ra,8(sp)
 32a:	e022                	sd	s0,0(sp)
 32c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 32e:	f67ff0ef          	jal	294 <memmove>
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret

000000000000033a <syscall>:

// Trap into kernel space for system calls
int syscall(int num, ...) {
 33a:	7175                	addi	sp,sp,-144
 33c:	e4a2                	sd	s0,72(sp)
 33e:	0880                	addi	s0,sp,80
 340:	832a                	mv	t1,a0
 342:	e40c                	sd	a1,8(s0)
 344:	e810                	sd	a2,16(s0)
 346:	ec14                	sd	a3,24(s0)
 348:	f018                	sd	a4,32(s0)
 34a:	f41c                	sd	a5,40(s0)
 34c:	03043823          	sd	a6,48(s0)
 350:	03143c23          	sd	a7,56(s0)
    uint64 args[6];
    va_list ap;
    int i;

    // Retrieve variable arguments passed to syscall
    va_start(ap, num);
 354:	00840793          	addi	a5,s0,8
 358:	faf43c23          	sd	a5,-72(s0)
    for (i = 0; i < 6; i++) {
 35c:	fc040793          	addi	a5,s0,-64
 360:	ff040613          	addi	a2,s0,-16
        args[i] = va_arg(ap, uint64);
 364:	fb843703          	ld	a4,-72(s0)
 368:	00870693          	addi	a3,a4,8
 36c:	fad43c23          	sd	a3,-72(s0)
 370:	6318                	ld	a4,0(a4)
 372:	e398                	sd	a4,0(a5)
    for (i = 0; i < 6; i++) {
 374:	07a1                	addi	a5,a5,8
 376:	fec797e3          	bne	a5,a2,364 <syscall+0x2a>
    }
    va_end(ap);

    // Place the system call number in a7, arguments in a0-a5
    register uint64 a0 asm("a0") = args[0];
 37a:	fc043503          	ld	a0,-64(s0)
    register uint64 a1 asm("a1") = args[1];
 37e:	fc843583          	ld	a1,-56(s0)
    register uint64 a2 asm("a2") = args[2];
 382:	fd043603          	ld	a2,-48(s0)
    register uint64 a3 asm("a3") = args[3];
 386:	fd843683          	ld	a3,-40(s0)
    register uint64 a4 asm("a4") = args[4];
 38a:	fe043703          	ld	a4,-32(s0)
    register uint64 a5 asm("a5") = args[5];
 38e:	fe843783          	ld	a5,-24(s0)
    register uint64 a7 asm("a7") = num;
 392:	889a                	mv	a7,t1

    // Perform the ecall (traps into kernel space)
    asm volatile("ecall"
 394:	00000073          	ecall
                 : "r"(a1), "r"(a2), "r"(a3), "r"(a4), "r"(a5), "r"(a7)
                 : "memory");

    // Return value is stored in a0 after the trap
    return a0;
 398:	2501                	sext.w	a0,a0
 39a:	6426                	ld	s0,72(sp)
 39c:	6149                	addi	sp,sp,144
 39e:	8082                	ret

00000000000003a0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a0:	4885                	li	a7,1
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a8:	4889                	li	a7,2
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b0:	488d                	li	a7,3
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b8:	4891                	li	a7,4
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <read>:
.global read
read:
 li a7, SYS_read
 3c0:	4895                	li	a7,5
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <write>:
.global write
write:
 li a7, SYS_write
 3c8:	48c1                	li	a7,16
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <close>:
.global close
close:
 li a7, SYS_close
 3d0:	48d5                	li	a7,21
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d8:	4899                	li	a7,6
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e0:	489d                	li	a7,7
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <open>:
.global open
open:
 li a7, SYS_open
 3e8:	48bd                	li	a7,15
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f0:	48c5                	li	a7,17
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f8:	48c9                	li	a7,18
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 400:	48a1                	li	a7,8
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <link>:
.global link
link:
 li a7, SYS_link
 408:	48cd                	li	a7,19
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 410:	48d1                	li	a7,20
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 418:	48a5                	li	a7,9
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <dup>:
.global dup
dup:
 li a7, SYS_dup
 420:	48a9                	li	a7,10
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 428:	48ad                	li	a7,11
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 430:	48b1                	li	a7,12
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 438:	48b5                	li	a7,13
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 440:	48b9                	li	a7,14
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 448:	1101                	addi	sp,sp,-32
 44a:	ec06                	sd	ra,24(sp)
 44c:	e822                	sd	s0,16(sp)
 44e:	1000                	addi	s0,sp,32
 450:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 454:	4605                	li	a2,1
 456:	fef40593          	addi	a1,s0,-17
 45a:	f6fff0ef          	jal	3c8 <write>
}
 45e:	60e2                	ld	ra,24(sp)
 460:	6442                	ld	s0,16(sp)
 462:	6105                	addi	sp,sp,32
 464:	8082                	ret

0000000000000466 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 466:	7139                	addi	sp,sp,-64
 468:	fc06                	sd	ra,56(sp)
 46a:	f822                	sd	s0,48(sp)
 46c:	f426                	sd	s1,40(sp)
 46e:	0080                	addi	s0,sp,64
 470:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 472:	c299                	beqz	a3,478 <printint+0x12>
 474:	0805c963          	bltz	a1,506 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 478:	2581                	sext.w	a1,a1
  neg = 0;
 47a:	4881                	li	a7,0
 47c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 480:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 482:	2601                	sext.w	a2,a2
 484:	00000517          	auipc	a0,0x0
 488:	53450513          	addi	a0,a0,1332 # 9b8 <digits>
 48c:	883a                	mv	a6,a4
 48e:	2705                	addiw	a4,a4,1
 490:	02c5f7bb          	remuw	a5,a1,a2
 494:	1782                	slli	a5,a5,0x20
 496:	9381                	srli	a5,a5,0x20
 498:	97aa                	add	a5,a5,a0
 49a:	0007c783          	lbu	a5,0(a5)
 49e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4a2:	0005879b          	sext.w	a5,a1
 4a6:	02c5d5bb          	divuw	a1,a1,a2
 4aa:	0685                	addi	a3,a3,1
 4ac:	fec7f0e3          	bgeu	a5,a2,48c <printint+0x26>
  if(neg)
 4b0:	00088c63          	beqz	a7,4c8 <printint+0x62>
    buf[i++] = '-';
 4b4:	fd070793          	addi	a5,a4,-48
 4b8:	00878733          	add	a4,a5,s0
 4bc:	02d00793          	li	a5,45
 4c0:	fef70823          	sb	a5,-16(a4)
 4c4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4c8:	02e05a63          	blez	a4,4fc <printint+0x96>
 4cc:	f04a                	sd	s2,32(sp)
 4ce:	ec4e                	sd	s3,24(sp)
 4d0:	fc040793          	addi	a5,s0,-64
 4d4:	00e78933          	add	s2,a5,a4
 4d8:	fff78993          	addi	s3,a5,-1
 4dc:	99ba                	add	s3,s3,a4
 4de:	377d                	addiw	a4,a4,-1
 4e0:	1702                	slli	a4,a4,0x20
 4e2:	9301                	srli	a4,a4,0x20
 4e4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4e8:	fff94583          	lbu	a1,-1(s2)
 4ec:	8526                	mv	a0,s1
 4ee:	f5bff0ef          	jal	448 <putc>
  while(--i >= 0)
 4f2:	197d                	addi	s2,s2,-1
 4f4:	ff391ae3          	bne	s2,s3,4e8 <printint+0x82>
 4f8:	7902                	ld	s2,32(sp)
 4fa:	69e2                	ld	s3,24(sp)
}
 4fc:	70e2                	ld	ra,56(sp)
 4fe:	7442                	ld	s0,48(sp)
 500:	74a2                	ld	s1,40(sp)
 502:	6121                	addi	sp,sp,64
 504:	8082                	ret
    x = -xx;
 506:	40b005bb          	negw	a1,a1
    neg = 1;
 50a:	4885                	li	a7,1
    x = -xx;
 50c:	bf85                	j	47c <printint+0x16>

000000000000050e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 50e:	711d                	addi	sp,sp,-96
 510:	ec86                	sd	ra,88(sp)
 512:	e8a2                	sd	s0,80(sp)
 514:	e0ca                	sd	s2,64(sp)
 516:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 518:	0005c903          	lbu	s2,0(a1)
 51c:	26090863          	beqz	s2,78c <vprintf+0x27e>
 520:	e4a6                	sd	s1,72(sp)
 522:	fc4e                	sd	s3,56(sp)
 524:	f852                	sd	s4,48(sp)
 526:	f456                	sd	s5,40(sp)
 528:	f05a                	sd	s6,32(sp)
 52a:	ec5e                	sd	s7,24(sp)
 52c:	e862                	sd	s8,16(sp)
 52e:	e466                	sd	s9,8(sp)
 530:	8b2a                	mv	s6,a0
 532:	8a2e                	mv	s4,a1
 534:	8bb2                	mv	s7,a2
  state = 0;
 536:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 538:	4481                	li	s1,0
 53a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 53c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 540:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 544:	06c00c93          	li	s9,108
 548:	a005                	j	568 <vprintf+0x5a>
        putc(fd, c0);
 54a:	85ca                	mv	a1,s2
 54c:	855a                	mv	a0,s6
 54e:	efbff0ef          	jal	448 <putc>
 552:	a019                	j	558 <vprintf+0x4a>
    } else if(state == '%'){
 554:	03598263          	beq	s3,s5,578 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 558:	2485                	addiw	s1,s1,1
 55a:	8726                	mv	a4,s1
 55c:	009a07b3          	add	a5,s4,s1
 560:	0007c903          	lbu	s2,0(a5)
 564:	20090c63          	beqz	s2,77c <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 568:	0009079b          	sext.w	a5,s2
    if(state == 0){
 56c:	fe0994e3          	bnez	s3,554 <vprintf+0x46>
      if(c0 == '%'){
 570:	fd579de3          	bne	a5,s5,54a <vprintf+0x3c>
        state = '%';
 574:	89be                	mv	s3,a5
 576:	b7cd                	j	558 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 578:	00ea06b3          	add	a3,s4,a4
 57c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 580:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 582:	c681                	beqz	a3,58a <vprintf+0x7c>
 584:	9752                	add	a4,a4,s4
 586:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 58a:	03878f63          	beq	a5,s8,5c8 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 58e:	05978963          	beq	a5,s9,5e0 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 592:	07500713          	li	a4,117
 596:	0ee78363          	beq	a5,a4,67c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 59a:	07800713          	li	a4,120
 59e:	12e78563          	beq	a5,a4,6c8 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5a2:	07000713          	li	a4,112
 5a6:	14e78a63          	beq	a5,a4,6fa <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5aa:	07300713          	li	a4,115
 5ae:	18e78a63          	beq	a5,a4,742 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5b2:	02500713          	li	a4,37
 5b6:	04e79563          	bne	a5,a4,600 <vprintf+0xf2>
        putc(fd, '%');
 5ba:	02500593          	li	a1,37
 5be:	855a                	mv	a0,s6
 5c0:	e89ff0ef          	jal	448 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bf49                	j	558 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5c8:	008b8913          	addi	s2,s7,8
 5cc:	4685                	li	a3,1
 5ce:	4629                	li	a2,10
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	e91ff0ef          	jal	466 <printint>
 5da:	8bca                	mv	s7,s2
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	bfad                	j	558 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5e0:	06400793          	li	a5,100
 5e4:	02f68963          	beq	a3,a5,616 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5e8:	06c00793          	li	a5,108
 5ec:	04f68263          	beq	a3,a5,630 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5f0:	07500793          	li	a5,117
 5f4:	0af68063          	beq	a3,a5,694 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5f8:	07800793          	li	a5,120
 5fc:	0ef68263          	beq	a3,a5,6e0 <vprintf+0x1d2>
        putc(fd, '%');
 600:	02500593          	li	a1,37
 604:	855a                	mv	a0,s6
 606:	e43ff0ef          	jal	448 <putc>
        putc(fd, c0);
 60a:	85ca                	mv	a1,s2
 60c:	855a                	mv	a0,s6
 60e:	e3bff0ef          	jal	448 <putc>
      state = 0;
 612:	4981                	li	s3,0
 614:	b791                	j	558 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 616:	008b8913          	addi	s2,s7,8
 61a:	4685                	li	a3,1
 61c:	4629                	li	a2,10
 61e:	000ba583          	lw	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	e43ff0ef          	jal	466 <printint>
        i += 1;
 628:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 62a:	8bca                	mv	s7,s2
      state = 0;
 62c:	4981                	li	s3,0
        i += 1;
 62e:	b72d                	j	558 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 630:	06400793          	li	a5,100
 634:	02f60763          	beq	a2,a5,662 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 638:	07500793          	li	a5,117
 63c:	06f60963          	beq	a2,a5,6ae <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 640:	07800793          	li	a5,120
 644:	faf61ee3          	bne	a2,a5,600 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 648:	008b8913          	addi	s2,s7,8
 64c:	4681                	li	a3,0
 64e:	4641                	li	a2,16
 650:	000ba583          	lw	a1,0(s7)
 654:	855a                	mv	a0,s6
 656:	e11ff0ef          	jal	466 <printint>
        i += 2;
 65a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 65c:	8bca                	mv	s7,s2
      state = 0;
 65e:	4981                	li	s3,0
        i += 2;
 660:	bde5                	j	558 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 662:	008b8913          	addi	s2,s7,8
 666:	4685                	li	a3,1
 668:	4629                	li	a2,10
 66a:	000ba583          	lw	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	df7ff0ef          	jal	466 <printint>
        i += 2;
 674:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
        i += 2;
 67a:	bdf9                	j	558 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 67c:	008b8913          	addi	s2,s7,8
 680:	4681                	li	a3,0
 682:	4629                	li	a2,10
 684:	000ba583          	lw	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	dddff0ef          	jal	466 <printint>
 68e:	8bca                	mv	s7,s2
      state = 0;
 690:	4981                	li	s3,0
 692:	b5d9                	j	558 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 694:	008b8913          	addi	s2,s7,8
 698:	4681                	li	a3,0
 69a:	4629                	li	a2,10
 69c:	000ba583          	lw	a1,0(s7)
 6a0:	855a                	mv	a0,s6
 6a2:	dc5ff0ef          	jal	466 <printint>
        i += 1;
 6a6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a8:	8bca                	mv	s7,s2
      state = 0;
 6aa:	4981                	li	s3,0
        i += 1;
 6ac:	b575                	j	558 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ae:	008b8913          	addi	s2,s7,8
 6b2:	4681                	li	a3,0
 6b4:	4629                	li	a2,10
 6b6:	000ba583          	lw	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	dabff0ef          	jal	466 <printint>
        i += 2;
 6c0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c2:	8bca                	mv	s7,s2
      state = 0;
 6c4:	4981                	li	s3,0
        i += 2;
 6c6:	bd49                	j	558 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6c8:	008b8913          	addi	s2,s7,8
 6cc:	4681                	li	a3,0
 6ce:	4641                	li	a2,16
 6d0:	000ba583          	lw	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	d91ff0ef          	jal	466 <printint>
 6da:	8bca                	mv	s7,s2
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	bdad                	j	558 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e0:	008b8913          	addi	s2,s7,8
 6e4:	4681                	li	a3,0
 6e6:	4641                	li	a2,16
 6e8:	000ba583          	lw	a1,0(s7)
 6ec:	855a                	mv	a0,s6
 6ee:	d79ff0ef          	jal	466 <printint>
        i += 1;
 6f2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f4:	8bca                	mv	s7,s2
      state = 0;
 6f6:	4981                	li	s3,0
        i += 1;
 6f8:	b585                	j	558 <vprintf+0x4a>
 6fa:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6fc:	008b8d13          	addi	s10,s7,8
 700:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 704:	03000593          	li	a1,48
 708:	855a                	mv	a0,s6
 70a:	d3fff0ef          	jal	448 <putc>
  putc(fd, 'x');
 70e:	07800593          	li	a1,120
 712:	855a                	mv	a0,s6
 714:	d35ff0ef          	jal	448 <putc>
 718:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 71a:	00000b97          	auipc	s7,0x0
 71e:	29eb8b93          	addi	s7,s7,670 # 9b8 <digits>
 722:	03c9d793          	srli	a5,s3,0x3c
 726:	97de                	add	a5,a5,s7
 728:	0007c583          	lbu	a1,0(a5)
 72c:	855a                	mv	a0,s6
 72e:	d1bff0ef          	jal	448 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 732:	0992                	slli	s3,s3,0x4
 734:	397d                	addiw	s2,s2,-1
 736:	fe0916e3          	bnez	s2,722 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 73a:	8bea                	mv	s7,s10
      state = 0;
 73c:	4981                	li	s3,0
 73e:	6d02                	ld	s10,0(sp)
 740:	bd21                	j	558 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 742:	008b8993          	addi	s3,s7,8
 746:	000bb903          	ld	s2,0(s7)
 74a:	00090f63          	beqz	s2,768 <vprintf+0x25a>
        for(; *s; s++)
 74e:	00094583          	lbu	a1,0(s2)
 752:	c195                	beqz	a1,776 <vprintf+0x268>
          putc(fd, *s);
 754:	855a                	mv	a0,s6
 756:	cf3ff0ef          	jal	448 <putc>
        for(; *s; s++)
 75a:	0905                	addi	s2,s2,1
 75c:	00094583          	lbu	a1,0(s2)
 760:	f9f5                	bnez	a1,754 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 762:	8bce                	mv	s7,s3
      state = 0;
 764:	4981                	li	s3,0
 766:	bbcd                	j	558 <vprintf+0x4a>
          s = "(null)";
 768:	00000917          	auipc	s2,0x0
 76c:	24890913          	addi	s2,s2,584 # 9b0 <malloc+0x13c>
        for(; *s; s++)
 770:	02800593          	li	a1,40
 774:	b7c5                	j	754 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 776:	8bce                	mv	s7,s3
      state = 0;
 778:	4981                	li	s3,0
 77a:	bbf9                	j	558 <vprintf+0x4a>
 77c:	64a6                	ld	s1,72(sp)
 77e:	79e2                	ld	s3,56(sp)
 780:	7a42                	ld	s4,48(sp)
 782:	7aa2                	ld	s5,40(sp)
 784:	7b02                	ld	s6,32(sp)
 786:	6be2                	ld	s7,24(sp)
 788:	6c42                	ld	s8,16(sp)
 78a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 78c:	60e6                	ld	ra,88(sp)
 78e:	6446                	ld	s0,80(sp)
 790:	6906                	ld	s2,64(sp)
 792:	6125                	addi	sp,sp,96
 794:	8082                	ret

0000000000000796 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 796:	715d                	addi	sp,sp,-80
 798:	ec06                	sd	ra,24(sp)
 79a:	e822                	sd	s0,16(sp)
 79c:	1000                	addi	s0,sp,32
 79e:	e010                	sd	a2,0(s0)
 7a0:	e414                	sd	a3,8(s0)
 7a2:	e818                	sd	a4,16(s0)
 7a4:	ec1c                	sd	a5,24(s0)
 7a6:	03043023          	sd	a6,32(s0)
 7aa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ae:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7b2:	8622                	mv	a2,s0
 7b4:	d5bff0ef          	jal	50e <vprintf>
}
 7b8:	60e2                	ld	ra,24(sp)
 7ba:	6442                	ld	s0,16(sp)
 7bc:	6161                	addi	sp,sp,80
 7be:	8082                	ret

00000000000007c0 <printf>:

void
printf(const char *fmt, ...)
{
 7c0:	711d                	addi	sp,sp,-96
 7c2:	ec06                	sd	ra,24(sp)
 7c4:	e822                	sd	s0,16(sp)
 7c6:	1000                	addi	s0,sp,32
 7c8:	e40c                	sd	a1,8(s0)
 7ca:	e810                	sd	a2,16(s0)
 7cc:	ec14                	sd	a3,24(s0)
 7ce:	f018                	sd	a4,32(s0)
 7d0:	f41c                	sd	a5,40(s0)
 7d2:	03043823          	sd	a6,48(s0)
 7d6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7da:	00840613          	addi	a2,s0,8
 7de:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7e2:	85aa                	mv	a1,a0
 7e4:	4505                	li	a0,1
 7e6:	d29ff0ef          	jal	50e <vprintf>
}
 7ea:	60e2                	ld	ra,24(sp)
 7ec:	6442                	ld	s0,16(sp)
 7ee:	6125                	addi	sp,sp,96
 7f0:	8082                	ret

00000000000007f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f2:	1141                	addi	sp,sp,-16
 7f4:	e422                	sd	s0,8(sp)
 7f6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fc:	00001797          	auipc	a5,0x1
 800:	8047b783          	ld	a5,-2044(a5) # 1000 <freep>
 804:	a02d                	j	82e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 806:	4618                	lw	a4,8(a2)
 808:	9f2d                	addw	a4,a4,a1
 80a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 80e:	6398                	ld	a4,0(a5)
 810:	6310                	ld	a2,0(a4)
 812:	a83d                	j	850 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 814:	ff852703          	lw	a4,-8(a0)
 818:	9f31                	addw	a4,a4,a2
 81a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 81c:	ff053683          	ld	a3,-16(a0)
 820:	a091                	j	864 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 822:	6398                	ld	a4,0(a5)
 824:	00e7e463          	bltu	a5,a4,82c <free+0x3a>
 828:	00e6ea63          	bltu	a3,a4,83c <free+0x4a>
{
 82c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82e:	fed7fae3          	bgeu	a5,a3,822 <free+0x30>
 832:	6398                	ld	a4,0(a5)
 834:	00e6e463          	bltu	a3,a4,83c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 838:	fee7eae3          	bltu	a5,a4,82c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 83c:	ff852583          	lw	a1,-8(a0)
 840:	6390                	ld	a2,0(a5)
 842:	02059813          	slli	a6,a1,0x20
 846:	01c85713          	srli	a4,a6,0x1c
 84a:	9736                	add	a4,a4,a3
 84c:	fae60de3          	beq	a2,a4,806 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 850:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 854:	4790                	lw	a2,8(a5)
 856:	02061593          	slli	a1,a2,0x20
 85a:	01c5d713          	srli	a4,a1,0x1c
 85e:	973e                	add	a4,a4,a5
 860:	fae68ae3          	beq	a3,a4,814 <free+0x22>
    p->s.ptr = bp->s.ptr;
 864:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 866:	00000717          	auipc	a4,0x0
 86a:	78f73d23          	sd	a5,1946(a4) # 1000 <freep>
}
 86e:	6422                	ld	s0,8(sp)
 870:	0141                	addi	sp,sp,16
 872:	8082                	ret

0000000000000874 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 874:	7139                	addi	sp,sp,-64
 876:	fc06                	sd	ra,56(sp)
 878:	f822                	sd	s0,48(sp)
 87a:	f426                	sd	s1,40(sp)
 87c:	ec4e                	sd	s3,24(sp)
 87e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 880:	02051493          	slli	s1,a0,0x20
 884:	9081                	srli	s1,s1,0x20
 886:	04bd                	addi	s1,s1,15
 888:	8091                	srli	s1,s1,0x4
 88a:	0014899b          	addiw	s3,s1,1
 88e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 890:	00000517          	auipc	a0,0x0
 894:	77053503          	ld	a0,1904(a0) # 1000 <freep>
 898:	c915                	beqz	a0,8cc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89c:	4798                	lw	a4,8(a5)
 89e:	08977a63          	bgeu	a4,s1,932 <malloc+0xbe>
 8a2:	f04a                	sd	s2,32(sp)
 8a4:	e852                	sd	s4,16(sp)
 8a6:	e456                	sd	s5,8(sp)
 8a8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8aa:	8a4e                	mv	s4,s3
 8ac:	0009871b          	sext.w	a4,s3
 8b0:	6685                	lui	a3,0x1
 8b2:	00d77363          	bgeu	a4,a3,8b8 <malloc+0x44>
 8b6:	6a05                	lui	s4,0x1
 8b8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8bc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c0:	00000917          	auipc	s2,0x0
 8c4:	74090913          	addi	s2,s2,1856 # 1000 <freep>
  if(p == (char*)-1)
 8c8:	5afd                	li	s5,-1
 8ca:	a081                	j	90a <malloc+0x96>
 8cc:	f04a                	sd	s2,32(sp)
 8ce:	e852                	sd	s4,16(sp)
 8d0:	e456                	sd	s5,8(sp)
 8d2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8d4:	00000797          	auipc	a5,0x0
 8d8:	73c78793          	addi	a5,a5,1852 # 1010 <base>
 8dc:	00000717          	auipc	a4,0x0
 8e0:	72f73223          	sd	a5,1828(a4) # 1000 <freep>
 8e4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8e6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ea:	b7c1                	j	8aa <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8ec:	6398                	ld	a4,0(a5)
 8ee:	e118                	sd	a4,0(a0)
 8f0:	a8a9                	j	94a <malloc+0xd6>
  hp->s.size = nu;
 8f2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8f6:	0541                	addi	a0,a0,16
 8f8:	efbff0ef          	jal	7f2 <free>
  return freep;
 8fc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 900:	c12d                	beqz	a0,962 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 902:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 904:	4798                	lw	a4,8(a5)
 906:	02977263          	bgeu	a4,s1,92a <malloc+0xb6>
    if(p == freep)
 90a:	00093703          	ld	a4,0(s2)
 90e:	853e                	mv	a0,a5
 910:	fef719e3          	bne	a4,a5,902 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 914:	8552                	mv	a0,s4
 916:	b1bff0ef          	jal	430 <sbrk>
  if(p == (char*)-1)
 91a:	fd551ce3          	bne	a0,s5,8f2 <malloc+0x7e>
        return 0;
 91e:	4501                	li	a0,0
 920:	7902                	ld	s2,32(sp)
 922:	6a42                	ld	s4,16(sp)
 924:	6aa2                	ld	s5,8(sp)
 926:	6b02                	ld	s6,0(sp)
 928:	a03d                	j	956 <malloc+0xe2>
 92a:	7902                	ld	s2,32(sp)
 92c:	6a42                	ld	s4,16(sp)
 92e:	6aa2                	ld	s5,8(sp)
 930:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 932:	fae48de3          	beq	s1,a4,8ec <malloc+0x78>
        p->s.size -= nunits;
 936:	4137073b          	subw	a4,a4,s3
 93a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 93c:	02071693          	slli	a3,a4,0x20
 940:	01c6d713          	srli	a4,a3,0x1c
 944:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 946:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 94a:	00000717          	auipc	a4,0x0
 94e:	6aa73b23          	sd	a0,1718(a4) # 1000 <freep>
      return (void*)(p + 1);
 952:	01078513          	addi	a0,a5,16
  }
}
 956:	70e2                	ld	ra,56(sp)
 958:	7442                	ld	s0,48(sp)
 95a:	74a2                	ld	s1,40(sp)
 95c:	69e2                	ld	s3,24(sp)
 95e:	6121                	addi	sp,sp,64
 960:	8082                	ret
 962:	7902                	ld	s2,32(sp)
 964:	6a42                	ld	s4,16(sp)
 966:	6aa2                	ld	s5,8(sp)
 968:	6b02                	ld	s6,0(sp)
 96a:	b7f5                	j	956 <malloc+0xe2>
