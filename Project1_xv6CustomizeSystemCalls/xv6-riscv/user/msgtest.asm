
user/_msgtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
//     return 0;
// }

#include "user.h"

int main() {
   0:	716d                	addi	sp,sp,-272
   2:	e606                	sd	ra,264(sp)
   4:	e222                	sd	s0,256(sp)
   6:	0a00                	addi	s0,sp,272
    int msg_type = 1;       
    char msg[128] = "Hello from Parent!";  // Parent's message to child
   8:	464d                	li	a2,19
   a:	00001597          	auipc	a1,0x1
   e:	96e58593          	addi	a1,a1,-1682 # 978 <malloc+0x188>
  12:	f7040513          	addi	a0,s0,-144
  16:	2e2000ef          	jal	2f8 <memcpy>
  1a:	06d00613          	li	a2,109
  1e:	4581                	li	a1,0
  20:	f8340513          	addi	a0,s0,-125
  24:	10a000ef          	jal	12e <memset>
    char received_msg[128];  // Buffer to store received messages

    int pid = fork();  // Create a child process
  28:	2e4000ef          	jal	30c <fork>

    if (pid < 0) {
  2c:	02054563          	bltz	a0,56 <main+0x56>
        printf("Fork failed!\n");
        exit(1);
    } else if (pid == 0) {
  30:	e529                	bnez	a0,7a <main+0x7a>
        // Child process
      

        // Receive message from parent
        if (sys_receive_message(msg_type, received_msg) < 0) {
  32:	ef040593          	addi	a1,s0,-272
  36:	4505                	li	a0,1
  38:	384000ef          	jal	3bc <sys_receive_message>
  3c:	02054663          	bltz	a0,68 <main+0x68>
            printf("Child: sys_receive_message failed\n");
            exit(1);
        } else {
            printf("Child: Message received: %s\n", received_msg);
  40:	ef040593          	addi	a1,s0,-272
  44:	00001517          	auipc	a0,0x1
  48:	8ec50513          	addi	a0,a0,-1812 # 930 <malloc+0x140>
  4c:	6f0000ef          	jal	73c <printf>
        }

        exit(0);
  50:	4501                	li	a0,0
  52:	2c2000ef          	jal	314 <exit>
        printf("Fork failed!\n");
  56:	00001517          	auipc	a0,0x1
  5a:	89a50513          	addi	a0,a0,-1894 # 8f0 <malloc+0x100>
  5e:	6de000ef          	jal	73c <printf>
        exit(1);
  62:	4505                	li	a0,1
  64:	2b0000ef          	jal	314 <exit>
            printf("Child: sys_receive_message failed\n");
  68:	00001517          	auipc	a0,0x1
  6c:	8a050513          	addi	a0,a0,-1888 # 908 <malloc+0x118>
  70:	6cc000ef          	jal	73c <printf>
            exit(1);
  74:	4505                	li	a0,1
  76:	29e000ef          	jal	314 <exit>
    } else {
        // Parent process
        

        // Send message to child
        if (sys_send_message(pid, msg_type, msg) < 0) {
  7a:	f7040613          	addi	a2,s0,-144
  7e:	4585                	li	a1,1
  80:	334000ef          	jal	3b4 <sys_send_message>
  84:	00054a63          	bltz	a0,98 <main+0x98>
            exit(1);
        }


        // Wait for child to finish
        wait(0);
  88:	4501                	li	a0,0
  8a:	292000ef          	jal	31c <wait>
    }

    return 0;
}
  8e:	4501                	li	a0,0
  90:	60b2                	ld	ra,264(sp)
  92:	6412                	ld	s0,256(sp)
  94:	6151                	addi	sp,sp,272
  96:	8082                	ret
            printf("Parent: sys_send_message failed\n");
  98:	00001517          	auipc	a0,0x1
  9c:	8b850513          	addi	a0,a0,-1864 # 950 <malloc+0x160>
  a0:	69c000ef          	jal	73c <printf>
            exit(1);
  a4:	4505                	li	a0,1
  a6:	26e000ef          	jal	314 <exit>

00000000000000aa <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e406                	sd	ra,8(sp)
  ae:	e022                	sd	s0,0(sp)
  b0:	0800                	addi	s0,sp,16
  extern int main();
  main();
  b2:	f4fff0ef          	jal	0 <main>
  exit(0);
  b6:	4501                	li	a0,0
  b8:	25c000ef          	jal	314 <exit>

00000000000000bc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e422                	sd	s0,8(sp)
  c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  c2:	87aa                	mv	a5,a0
  c4:	0585                	addi	a1,a1,1
  c6:	0785                	addi	a5,a5,1
  c8:	fff5c703          	lbu	a4,-1(a1)
  cc:	fee78fa3          	sb	a4,-1(a5)
  d0:	fb75                	bnez	a4,c4 <strcpy+0x8>
    ;
  return os;
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  de:	00054783          	lbu	a5,0(a0)
  e2:	cb91                	beqz	a5,f6 <strcmp+0x1e>
  e4:	0005c703          	lbu	a4,0(a1)
  e8:	00f71763          	bne	a4,a5,f6 <strcmp+0x1e>
    p++, q++;
  ec:	0505                	addi	a0,a0,1
  ee:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  f0:	00054783          	lbu	a5,0(a0)
  f4:	fbe5                	bnez	a5,e4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  f6:	0005c503          	lbu	a0,0(a1)
}
  fa:	40a7853b          	subw	a0,a5,a0
  fe:	6422                	ld	s0,8(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret

0000000000000104 <strlen>:

uint
strlen(const char *s)
{
 104:	1141                	addi	sp,sp,-16
 106:	e422                	sd	s0,8(sp)
 108:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cf91                	beqz	a5,12a <strlen+0x26>
 110:	0505                	addi	a0,a0,1
 112:	87aa                	mv	a5,a0
 114:	86be                	mv	a3,a5
 116:	0785                	addi	a5,a5,1
 118:	fff7c703          	lbu	a4,-1(a5)
 11c:	ff65                	bnez	a4,114 <strlen+0x10>
 11e:	40a6853b          	subw	a0,a3,a0
 122:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 124:	6422                	ld	s0,8(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret
  for(n = 0; s[n]; n++)
 12a:	4501                	li	a0,0
 12c:	bfe5                	j	124 <strlen+0x20>

000000000000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	1141                	addi	sp,sp,-16
 130:	e422                	sd	s0,8(sp)
 132:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 134:	ca19                	beqz	a2,14a <memset+0x1c>
 136:	87aa                	mv	a5,a0
 138:	1602                	slli	a2,a2,0x20
 13a:	9201                	srli	a2,a2,0x20
 13c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 140:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 144:	0785                	addi	a5,a5,1
 146:	fee79de3          	bne	a5,a4,140 <memset+0x12>
  }
  return dst;
}
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret

0000000000000150 <strchr>:

char*
strchr(const char *s, char c)
{
 150:	1141                	addi	sp,sp,-16
 152:	e422                	sd	s0,8(sp)
 154:	0800                	addi	s0,sp,16
  for(; *s; s++)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cb99                	beqz	a5,170 <strchr+0x20>
    if(*s == c)
 15c:	00f58763          	beq	a1,a5,16a <strchr+0x1a>
  for(; *s; s++)
 160:	0505                	addi	a0,a0,1
 162:	00054783          	lbu	a5,0(a0)
 166:	fbfd                	bnez	a5,15c <strchr+0xc>
      return (char*)s;
  return 0;
 168:	4501                	li	a0,0
}
 16a:	6422                	ld	s0,8(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret
  return 0;
 170:	4501                	li	a0,0
 172:	bfe5                	j	16a <strchr+0x1a>

0000000000000174 <gets>:

char*
gets(char *buf, int max)
{
 174:	711d                	addi	sp,sp,-96
 176:	ec86                	sd	ra,88(sp)
 178:	e8a2                	sd	s0,80(sp)
 17a:	e4a6                	sd	s1,72(sp)
 17c:	e0ca                	sd	s2,64(sp)
 17e:	fc4e                	sd	s3,56(sp)
 180:	f852                	sd	s4,48(sp)
 182:	f456                	sd	s5,40(sp)
 184:	f05a                	sd	s6,32(sp)
 186:	ec5e                	sd	s7,24(sp)
 188:	1080                	addi	s0,sp,96
 18a:	8baa                	mv	s7,a0
 18c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18e:	892a                	mv	s2,a0
 190:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 192:	4aa9                	li	s5,10
 194:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 196:	89a6                	mv	s3,s1
 198:	2485                	addiw	s1,s1,1
 19a:	0344d663          	bge	s1,s4,1c6 <gets+0x52>
    cc = read(0, &c, 1);
 19e:	4605                	li	a2,1
 1a0:	faf40593          	addi	a1,s0,-81
 1a4:	4501                	li	a0,0
 1a6:	186000ef          	jal	32c <read>
    if(cc < 1)
 1aa:	00a05e63          	blez	a0,1c6 <gets+0x52>
    buf[i++] = c;
 1ae:	faf44783          	lbu	a5,-81(s0)
 1b2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1b6:	01578763          	beq	a5,s5,1c4 <gets+0x50>
 1ba:	0905                	addi	s2,s2,1
 1bc:	fd679de3          	bne	a5,s6,196 <gets+0x22>
    buf[i++] = c;
 1c0:	89a6                	mv	s3,s1
 1c2:	a011                	j	1c6 <gets+0x52>
 1c4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1c6:	99de                	add	s3,s3,s7
 1c8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1cc:	855e                	mv	a0,s7
 1ce:	60e6                	ld	ra,88(sp)
 1d0:	6446                	ld	s0,80(sp)
 1d2:	64a6                	ld	s1,72(sp)
 1d4:	6906                	ld	s2,64(sp)
 1d6:	79e2                	ld	s3,56(sp)
 1d8:	7a42                	ld	s4,48(sp)
 1da:	7aa2                	ld	s5,40(sp)
 1dc:	7b02                	ld	s6,32(sp)
 1de:	6be2                	ld	s7,24(sp)
 1e0:	6125                	addi	sp,sp,96
 1e2:	8082                	ret

00000000000001e4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1e4:	1101                	addi	sp,sp,-32
 1e6:	ec06                	sd	ra,24(sp)
 1e8:	e822                	sd	s0,16(sp)
 1ea:	e04a                	sd	s2,0(sp)
 1ec:	1000                	addi	s0,sp,32
 1ee:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	4581                	li	a1,0
 1f2:	162000ef          	jal	354 <open>
  if(fd < 0)
 1f6:	02054263          	bltz	a0,21a <stat+0x36>
 1fa:	e426                	sd	s1,8(sp)
 1fc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1fe:	85ca                	mv	a1,s2
 200:	16c000ef          	jal	36c <fstat>
 204:	892a                	mv	s2,a0
  close(fd);
 206:	8526                	mv	a0,s1
 208:	134000ef          	jal	33c <close>
  return r;
 20c:	64a2                	ld	s1,8(sp)
}
 20e:	854a                	mv	a0,s2
 210:	60e2                	ld	ra,24(sp)
 212:	6442                	ld	s0,16(sp)
 214:	6902                	ld	s2,0(sp)
 216:	6105                	addi	sp,sp,32
 218:	8082                	ret
    return -1;
 21a:	597d                	li	s2,-1
 21c:	bfcd                	j	20e <stat+0x2a>

000000000000021e <atoi>:

int
atoi(const char *s)
{
 21e:	1141                	addi	sp,sp,-16
 220:	e422                	sd	s0,8(sp)
 222:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 224:	00054683          	lbu	a3,0(a0)
 228:	fd06879b          	addiw	a5,a3,-48
 22c:	0ff7f793          	zext.b	a5,a5
 230:	4625                	li	a2,9
 232:	02f66863          	bltu	a2,a5,262 <atoi+0x44>
 236:	872a                	mv	a4,a0
  n = 0;
 238:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 23a:	0705                	addi	a4,a4,1
 23c:	0025179b          	slliw	a5,a0,0x2
 240:	9fa9                	addw	a5,a5,a0
 242:	0017979b          	slliw	a5,a5,0x1
 246:	9fb5                	addw	a5,a5,a3
 248:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 24c:	00074683          	lbu	a3,0(a4)
 250:	fd06879b          	addiw	a5,a3,-48
 254:	0ff7f793          	zext.b	a5,a5
 258:	fef671e3          	bgeu	a2,a5,23a <atoi+0x1c>
  return n;
}
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
  n = 0;
 262:	4501                	li	a0,0
 264:	bfe5                	j	25c <atoi+0x3e>

0000000000000266 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 266:	1141                	addi	sp,sp,-16
 268:	e422                	sd	s0,8(sp)
 26a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 26c:	02b57463          	bgeu	a0,a1,294 <memmove+0x2e>
    while(n-- > 0)
 270:	00c05f63          	blez	a2,28e <memmove+0x28>
 274:	1602                	slli	a2,a2,0x20
 276:	9201                	srli	a2,a2,0x20
 278:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 27c:	872a                	mv	a4,a0
      *dst++ = *src++;
 27e:	0585                	addi	a1,a1,1
 280:	0705                	addi	a4,a4,1
 282:	fff5c683          	lbu	a3,-1(a1)
 286:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 28a:	fef71ae3          	bne	a4,a5,27e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
    dst += n;
 294:	00c50733          	add	a4,a0,a2
    src += n;
 298:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 29a:	fec05ae3          	blez	a2,28e <memmove+0x28>
 29e:	fff6079b          	addiw	a5,a2,-1
 2a2:	1782                	slli	a5,a5,0x20
 2a4:	9381                	srli	a5,a5,0x20
 2a6:	fff7c793          	not	a5,a5
 2aa:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ac:	15fd                	addi	a1,a1,-1
 2ae:	177d                	addi	a4,a4,-1
 2b0:	0005c683          	lbu	a3,0(a1)
 2b4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b8:	fee79ae3          	bne	a5,a4,2ac <memmove+0x46>
 2bc:	bfc9                	j	28e <memmove+0x28>

00000000000002be <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e422                	sd	s0,8(sp)
 2c2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c4:	ca05                	beqz	a2,2f4 <memcmp+0x36>
 2c6:	fff6069b          	addiw	a3,a2,-1
 2ca:	1682                	slli	a3,a3,0x20
 2cc:	9281                	srli	a3,a3,0x20
 2ce:	0685                	addi	a3,a3,1
 2d0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2d2:	00054783          	lbu	a5,0(a0)
 2d6:	0005c703          	lbu	a4,0(a1)
 2da:	00e79863          	bne	a5,a4,2ea <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2de:	0505                	addi	a0,a0,1
    p2++;
 2e0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2e2:	fed518e3          	bne	a0,a3,2d2 <memcmp+0x14>
  }
  return 0;
 2e6:	4501                	li	a0,0
 2e8:	a019                	j	2ee <memcmp+0x30>
      return *p1 - *p2;
 2ea:	40e7853b          	subw	a0,a5,a4
}
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret
  return 0;
 2f4:	4501                	li	a0,0
 2f6:	bfe5                	j	2ee <memcmp+0x30>

00000000000002f8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e406                	sd	ra,8(sp)
 2fc:	e022                	sd	s0,0(sp)
 2fe:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 300:	f67ff0ef          	jal	266 <memmove>
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 30c:	4885                	li	a7,1
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <exit>:
.global exit
exit:
 li a7, SYS_exit
 314:	4889                	li	a7,2
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <wait>:
.global wait
wait:
 li a7, SYS_wait
 31c:	488d                	li	a7,3
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 324:	4891                	li	a7,4
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <read>:
.global read
read:
 li a7, SYS_read
 32c:	4895                	li	a7,5
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <write>:
.global write
write:
 li a7, SYS_write
 334:	48c1                	li	a7,16
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <close>:
.global close
close:
 li a7, SYS_close
 33c:	48d5                	li	a7,21
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <kill>:
.global kill
kill:
 li a7, SYS_kill
 344:	4899                	li	a7,6
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <exec>:
.global exec
exec:
 li a7, SYS_exec
 34c:	489d                	li	a7,7
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <open>:
.global open
open:
 li a7, SYS_open
 354:	48bd                	li	a7,15
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 35c:	48c5                	li	a7,17
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 364:	48c9                	li	a7,18
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 36c:	48a1                	li	a7,8
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <link>:
.global link
link:
 li a7, SYS_link
 374:	48cd                	li	a7,19
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 37c:	48d1                	li	a7,20
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 384:	48a5                	li	a7,9
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <dup>:
.global dup
dup:
 li a7, SYS_dup
 38c:	48a9                	li	a7,10
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 394:	48ad                	li	a7,11
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 39c:	48b1                	li	a7,12
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3a4:	48b5                	li	a7,13
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ac:	48b9                	li	a7,14
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <sys_send_message>:
.global sys_send_message
sys_send_message:
 li a7, SYS_sys_send_message
 3b4:	48d9                	li	a7,22
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <sys_receive_message>:
.global sys_receive_message
sys_receive_message:
 li a7, SYS_sys_receive_message
 3bc:	48dd                	li	a7,23
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c4:	1101                	addi	sp,sp,-32
 3c6:	ec06                	sd	ra,24(sp)
 3c8:	e822                	sd	s0,16(sp)
 3ca:	1000                	addi	s0,sp,32
 3cc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d0:	4605                	li	a2,1
 3d2:	fef40593          	addi	a1,s0,-17
 3d6:	f5fff0ef          	jal	334 <write>
}
 3da:	60e2                	ld	ra,24(sp)
 3dc:	6442                	ld	s0,16(sp)
 3de:	6105                	addi	sp,sp,32
 3e0:	8082                	ret

00000000000003e2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e2:	7139                	addi	sp,sp,-64
 3e4:	fc06                	sd	ra,56(sp)
 3e6:	f822                	sd	s0,48(sp)
 3e8:	f426                	sd	s1,40(sp)
 3ea:	0080                	addi	s0,sp,64
 3ec:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ee:	c299                	beqz	a3,3f4 <printint+0x12>
 3f0:	0805c963          	bltz	a1,482 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f4:	2581                	sext.w	a1,a1
  neg = 0;
 3f6:	4881                	li	a7,0
 3f8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3fc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3fe:	2601                	sext.w	a2,a2
 400:	00000517          	auipc	a0,0x0
 404:	59850513          	addi	a0,a0,1432 # 998 <digits>
 408:	883a                	mv	a6,a4
 40a:	2705                	addiw	a4,a4,1
 40c:	02c5f7bb          	remuw	a5,a1,a2
 410:	1782                	slli	a5,a5,0x20
 412:	9381                	srli	a5,a5,0x20
 414:	97aa                	add	a5,a5,a0
 416:	0007c783          	lbu	a5,0(a5)
 41a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 41e:	0005879b          	sext.w	a5,a1
 422:	02c5d5bb          	divuw	a1,a1,a2
 426:	0685                	addi	a3,a3,1
 428:	fec7f0e3          	bgeu	a5,a2,408 <printint+0x26>
  if(neg)
 42c:	00088c63          	beqz	a7,444 <printint+0x62>
    buf[i++] = '-';
 430:	fd070793          	addi	a5,a4,-48
 434:	00878733          	add	a4,a5,s0
 438:	02d00793          	li	a5,45
 43c:	fef70823          	sb	a5,-16(a4)
 440:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 444:	02e05a63          	blez	a4,478 <printint+0x96>
 448:	f04a                	sd	s2,32(sp)
 44a:	ec4e                	sd	s3,24(sp)
 44c:	fc040793          	addi	a5,s0,-64
 450:	00e78933          	add	s2,a5,a4
 454:	fff78993          	addi	s3,a5,-1
 458:	99ba                	add	s3,s3,a4
 45a:	377d                	addiw	a4,a4,-1
 45c:	1702                	slli	a4,a4,0x20
 45e:	9301                	srli	a4,a4,0x20
 460:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 464:	fff94583          	lbu	a1,-1(s2)
 468:	8526                	mv	a0,s1
 46a:	f5bff0ef          	jal	3c4 <putc>
  while(--i >= 0)
 46e:	197d                	addi	s2,s2,-1
 470:	ff391ae3          	bne	s2,s3,464 <printint+0x82>
 474:	7902                	ld	s2,32(sp)
 476:	69e2                	ld	s3,24(sp)
}
 478:	70e2                	ld	ra,56(sp)
 47a:	7442                	ld	s0,48(sp)
 47c:	74a2                	ld	s1,40(sp)
 47e:	6121                	addi	sp,sp,64
 480:	8082                	ret
    x = -xx;
 482:	40b005bb          	negw	a1,a1
    neg = 1;
 486:	4885                	li	a7,1
    x = -xx;
 488:	bf85                	j	3f8 <printint+0x16>

000000000000048a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 48a:	711d                	addi	sp,sp,-96
 48c:	ec86                	sd	ra,88(sp)
 48e:	e8a2                	sd	s0,80(sp)
 490:	e0ca                	sd	s2,64(sp)
 492:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 494:	0005c903          	lbu	s2,0(a1)
 498:	26090863          	beqz	s2,708 <vprintf+0x27e>
 49c:	e4a6                	sd	s1,72(sp)
 49e:	fc4e                	sd	s3,56(sp)
 4a0:	f852                	sd	s4,48(sp)
 4a2:	f456                	sd	s5,40(sp)
 4a4:	f05a                	sd	s6,32(sp)
 4a6:	ec5e                	sd	s7,24(sp)
 4a8:	e862                	sd	s8,16(sp)
 4aa:	e466                	sd	s9,8(sp)
 4ac:	8b2a                	mv	s6,a0
 4ae:	8a2e                	mv	s4,a1
 4b0:	8bb2                	mv	s7,a2
  state = 0;
 4b2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4b4:	4481                	li	s1,0
 4b6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4b8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4bc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4c0:	06c00c93          	li	s9,108
 4c4:	a005                	j	4e4 <vprintf+0x5a>
        putc(fd, c0);
 4c6:	85ca                	mv	a1,s2
 4c8:	855a                	mv	a0,s6
 4ca:	efbff0ef          	jal	3c4 <putc>
 4ce:	a019                	j	4d4 <vprintf+0x4a>
    } else if(state == '%'){
 4d0:	03598263          	beq	s3,s5,4f4 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4d4:	2485                	addiw	s1,s1,1
 4d6:	8726                	mv	a4,s1
 4d8:	009a07b3          	add	a5,s4,s1
 4dc:	0007c903          	lbu	s2,0(a5)
 4e0:	20090c63          	beqz	s2,6f8 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 4e4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4e8:	fe0994e3          	bnez	s3,4d0 <vprintf+0x46>
      if(c0 == '%'){
 4ec:	fd579de3          	bne	a5,s5,4c6 <vprintf+0x3c>
        state = '%';
 4f0:	89be                	mv	s3,a5
 4f2:	b7cd                	j	4d4 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4f4:	00ea06b3          	add	a3,s4,a4
 4f8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4fc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4fe:	c681                	beqz	a3,506 <vprintf+0x7c>
 500:	9752                	add	a4,a4,s4
 502:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 506:	03878f63          	beq	a5,s8,544 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 50a:	05978963          	beq	a5,s9,55c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 50e:	07500713          	li	a4,117
 512:	0ee78363          	beq	a5,a4,5f8 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 516:	07800713          	li	a4,120
 51a:	12e78563          	beq	a5,a4,644 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 51e:	07000713          	li	a4,112
 522:	14e78a63          	beq	a5,a4,676 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 526:	07300713          	li	a4,115
 52a:	18e78a63          	beq	a5,a4,6be <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 52e:	02500713          	li	a4,37
 532:	04e79563          	bne	a5,a4,57c <vprintf+0xf2>
        putc(fd, '%');
 536:	02500593          	li	a1,37
 53a:	855a                	mv	a0,s6
 53c:	e89ff0ef          	jal	3c4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 540:	4981                	li	s3,0
 542:	bf49                	j	4d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 544:	008b8913          	addi	s2,s7,8
 548:	4685                	li	a3,1
 54a:	4629                	li	a2,10
 54c:	000ba583          	lw	a1,0(s7)
 550:	855a                	mv	a0,s6
 552:	e91ff0ef          	jal	3e2 <printint>
 556:	8bca                	mv	s7,s2
      state = 0;
 558:	4981                	li	s3,0
 55a:	bfad                	j	4d4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 55c:	06400793          	li	a5,100
 560:	02f68963          	beq	a3,a5,592 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 564:	06c00793          	li	a5,108
 568:	04f68263          	beq	a3,a5,5ac <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 56c:	07500793          	li	a5,117
 570:	0af68063          	beq	a3,a5,610 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 574:	07800793          	li	a5,120
 578:	0ef68263          	beq	a3,a5,65c <vprintf+0x1d2>
        putc(fd, '%');
 57c:	02500593          	li	a1,37
 580:	855a                	mv	a0,s6
 582:	e43ff0ef          	jal	3c4 <putc>
        putc(fd, c0);
 586:	85ca                	mv	a1,s2
 588:	855a                	mv	a0,s6
 58a:	e3bff0ef          	jal	3c4 <putc>
      state = 0;
 58e:	4981                	li	s3,0
 590:	b791                	j	4d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 592:	008b8913          	addi	s2,s7,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000ba583          	lw	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	e43ff0ef          	jal	3e2 <printint>
        i += 1;
 5a4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a6:	8bca                	mv	s7,s2
      state = 0;
 5a8:	4981                	li	s3,0
        i += 1;
 5aa:	b72d                	j	4d4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ac:	06400793          	li	a5,100
 5b0:	02f60763          	beq	a2,a5,5de <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5b4:	07500793          	li	a5,117
 5b8:	06f60963          	beq	a2,a5,62a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5bc:	07800793          	li	a5,120
 5c0:	faf61ee3          	bne	a2,a5,57c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c4:	008b8913          	addi	s2,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4641                	li	a2,16
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	e11ff0ef          	jal	3e2 <printint>
        i += 2;
 5d6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d8:	8bca                	mv	s7,s2
      state = 0;
 5da:	4981                	li	s3,0
        i += 2;
 5dc:	bde5                	j	4d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5de:	008b8913          	addi	s2,s7,8
 5e2:	4685                	li	a3,1
 5e4:	4629                	li	a2,10
 5e6:	000ba583          	lw	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	df7ff0ef          	jal	3e2 <printint>
        i += 2;
 5f0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f2:	8bca                	mv	s7,s2
      state = 0;
 5f4:	4981                	li	s3,0
        i += 2;
 5f6:	bdf9                	j	4d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5f8:	008b8913          	addi	s2,s7,8
 5fc:	4681                	li	a3,0
 5fe:	4629                	li	a2,10
 600:	000ba583          	lw	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	dddff0ef          	jal	3e2 <printint>
 60a:	8bca                	mv	s7,s2
      state = 0;
 60c:	4981                	li	s3,0
 60e:	b5d9                	j	4d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 610:	008b8913          	addi	s2,s7,8
 614:	4681                	li	a3,0
 616:	4629                	li	a2,10
 618:	000ba583          	lw	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	dc5ff0ef          	jal	3e2 <printint>
        i += 1;
 622:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 624:	8bca                	mv	s7,s2
      state = 0;
 626:	4981                	li	s3,0
        i += 1;
 628:	b575                	j	4d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62a:	008b8913          	addi	s2,s7,8
 62e:	4681                	li	a3,0
 630:	4629                	li	a2,10
 632:	000ba583          	lw	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	dabff0ef          	jal	3e2 <printint>
        i += 2;
 63c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
        i += 2;
 642:	bd49                	j	4d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 644:	008b8913          	addi	s2,s7,8
 648:	4681                	li	a3,0
 64a:	4641                	li	a2,16
 64c:	000ba583          	lw	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	d91ff0ef          	jal	3e2 <printint>
 656:	8bca                	mv	s7,s2
      state = 0;
 658:	4981                	li	s3,0
 65a:	bdad                	j	4d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65c:	008b8913          	addi	s2,s7,8
 660:	4681                	li	a3,0
 662:	4641                	li	a2,16
 664:	000ba583          	lw	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	d79ff0ef          	jal	3e2 <printint>
        i += 1;
 66e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 670:	8bca                	mv	s7,s2
      state = 0;
 672:	4981                	li	s3,0
        i += 1;
 674:	b585                	j	4d4 <vprintf+0x4a>
 676:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 678:	008b8d13          	addi	s10,s7,8
 67c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 680:	03000593          	li	a1,48
 684:	855a                	mv	a0,s6
 686:	d3fff0ef          	jal	3c4 <putc>
  putc(fd, 'x');
 68a:	07800593          	li	a1,120
 68e:	855a                	mv	a0,s6
 690:	d35ff0ef          	jal	3c4 <putc>
 694:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 696:	00000b97          	auipc	s7,0x0
 69a:	302b8b93          	addi	s7,s7,770 # 998 <digits>
 69e:	03c9d793          	srli	a5,s3,0x3c
 6a2:	97de                	add	a5,a5,s7
 6a4:	0007c583          	lbu	a1,0(a5)
 6a8:	855a                	mv	a0,s6
 6aa:	d1bff0ef          	jal	3c4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ae:	0992                	slli	s3,s3,0x4
 6b0:	397d                	addiw	s2,s2,-1
 6b2:	fe0916e3          	bnez	s2,69e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6b6:	8bea                	mv	s7,s10
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	6d02                	ld	s10,0(sp)
 6bc:	bd21                	j	4d4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6be:	008b8993          	addi	s3,s7,8
 6c2:	000bb903          	ld	s2,0(s7)
 6c6:	00090f63          	beqz	s2,6e4 <vprintf+0x25a>
        for(; *s; s++)
 6ca:	00094583          	lbu	a1,0(s2)
 6ce:	c195                	beqz	a1,6f2 <vprintf+0x268>
          putc(fd, *s);
 6d0:	855a                	mv	a0,s6
 6d2:	cf3ff0ef          	jal	3c4 <putc>
        for(; *s; s++)
 6d6:	0905                	addi	s2,s2,1
 6d8:	00094583          	lbu	a1,0(s2)
 6dc:	f9f5                	bnez	a1,6d0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6de:	8bce                	mv	s7,s3
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	bbcd                	j	4d4 <vprintf+0x4a>
          s = "(null)";
 6e4:	00000917          	auipc	s2,0x0
 6e8:	2ac90913          	addi	s2,s2,684 # 990 <malloc+0x1a0>
        for(; *s; s++)
 6ec:	02800593          	li	a1,40
 6f0:	b7c5                	j	6d0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6f2:	8bce                	mv	s7,s3
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	bbf9                	j	4d4 <vprintf+0x4a>
 6f8:	64a6                	ld	s1,72(sp)
 6fa:	79e2                	ld	s3,56(sp)
 6fc:	7a42                	ld	s4,48(sp)
 6fe:	7aa2                	ld	s5,40(sp)
 700:	7b02                	ld	s6,32(sp)
 702:	6be2                	ld	s7,24(sp)
 704:	6c42                	ld	s8,16(sp)
 706:	6ca2                	ld	s9,8(sp)
    }
  }
}
 708:	60e6                	ld	ra,88(sp)
 70a:	6446                	ld	s0,80(sp)
 70c:	6906                	ld	s2,64(sp)
 70e:	6125                	addi	sp,sp,96
 710:	8082                	ret

0000000000000712 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 712:	715d                	addi	sp,sp,-80
 714:	ec06                	sd	ra,24(sp)
 716:	e822                	sd	s0,16(sp)
 718:	1000                	addi	s0,sp,32
 71a:	e010                	sd	a2,0(s0)
 71c:	e414                	sd	a3,8(s0)
 71e:	e818                	sd	a4,16(s0)
 720:	ec1c                	sd	a5,24(s0)
 722:	03043023          	sd	a6,32(s0)
 726:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 72a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 72e:	8622                	mv	a2,s0
 730:	d5bff0ef          	jal	48a <vprintf>
}
 734:	60e2                	ld	ra,24(sp)
 736:	6442                	ld	s0,16(sp)
 738:	6161                	addi	sp,sp,80
 73a:	8082                	ret

000000000000073c <printf>:

void
printf(const char *fmt, ...)
{
 73c:	711d                	addi	sp,sp,-96
 73e:	ec06                	sd	ra,24(sp)
 740:	e822                	sd	s0,16(sp)
 742:	1000                	addi	s0,sp,32
 744:	e40c                	sd	a1,8(s0)
 746:	e810                	sd	a2,16(s0)
 748:	ec14                	sd	a3,24(s0)
 74a:	f018                	sd	a4,32(s0)
 74c:	f41c                	sd	a5,40(s0)
 74e:	03043823          	sd	a6,48(s0)
 752:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 756:	00840613          	addi	a2,s0,8
 75a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 75e:	85aa                	mv	a1,a0
 760:	4505                	li	a0,1
 762:	d29ff0ef          	jal	48a <vprintf>
}
 766:	60e2                	ld	ra,24(sp)
 768:	6442                	ld	s0,16(sp)
 76a:	6125                	addi	sp,sp,96
 76c:	8082                	ret

000000000000076e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76e:	1141                	addi	sp,sp,-16
 770:	e422                	sd	s0,8(sp)
 772:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 774:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 778:	00001797          	auipc	a5,0x1
 77c:	8887b783          	ld	a5,-1912(a5) # 1000 <freep>
 780:	a02d                	j	7aa <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 782:	4618                	lw	a4,8(a2)
 784:	9f2d                	addw	a4,a4,a1
 786:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 78a:	6398                	ld	a4,0(a5)
 78c:	6310                	ld	a2,0(a4)
 78e:	a83d                	j	7cc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 790:	ff852703          	lw	a4,-8(a0)
 794:	9f31                	addw	a4,a4,a2
 796:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 798:	ff053683          	ld	a3,-16(a0)
 79c:	a091                	j	7e0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79e:	6398                	ld	a4,0(a5)
 7a0:	00e7e463          	bltu	a5,a4,7a8 <free+0x3a>
 7a4:	00e6ea63          	bltu	a3,a4,7b8 <free+0x4a>
{
 7a8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7aa:	fed7fae3          	bgeu	a5,a3,79e <free+0x30>
 7ae:	6398                	ld	a4,0(a5)
 7b0:	00e6e463          	bltu	a3,a4,7b8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b4:	fee7eae3          	bltu	a5,a4,7a8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7b8:	ff852583          	lw	a1,-8(a0)
 7bc:	6390                	ld	a2,0(a5)
 7be:	02059813          	slli	a6,a1,0x20
 7c2:	01c85713          	srli	a4,a6,0x1c
 7c6:	9736                	add	a4,a4,a3
 7c8:	fae60de3          	beq	a2,a4,782 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7cc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7d0:	4790                	lw	a2,8(a5)
 7d2:	02061593          	slli	a1,a2,0x20
 7d6:	01c5d713          	srli	a4,a1,0x1c
 7da:	973e                	add	a4,a4,a5
 7dc:	fae68ae3          	beq	a3,a4,790 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7e0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7e2:	00001717          	auipc	a4,0x1
 7e6:	80f73f23          	sd	a5,-2018(a4) # 1000 <freep>
}
 7ea:	6422                	ld	s0,8(sp)
 7ec:	0141                	addi	sp,sp,16
 7ee:	8082                	ret

00000000000007f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f0:	7139                	addi	sp,sp,-64
 7f2:	fc06                	sd	ra,56(sp)
 7f4:	f822                	sd	s0,48(sp)
 7f6:	f426                	sd	s1,40(sp)
 7f8:	ec4e                	sd	s3,24(sp)
 7fa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fc:	02051493          	slli	s1,a0,0x20
 800:	9081                	srli	s1,s1,0x20
 802:	04bd                	addi	s1,s1,15
 804:	8091                	srli	s1,s1,0x4
 806:	0014899b          	addiw	s3,s1,1
 80a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 80c:	00000517          	auipc	a0,0x0
 810:	7f453503          	ld	a0,2036(a0) # 1000 <freep>
 814:	c915                	beqz	a0,848 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 816:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 818:	4798                	lw	a4,8(a5)
 81a:	08977a63          	bgeu	a4,s1,8ae <malloc+0xbe>
 81e:	f04a                	sd	s2,32(sp)
 820:	e852                	sd	s4,16(sp)
 822:	e456                	sd	s5,8(sp)
 824:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 826:	8a4e                	mv	s4,s3
 828:	0009871b          	sext.w	a4,s3
 82c:	6685                	lui	a3,0x1
 82e:	00d77363          	bgeu	a4,a3,834 <malloc+0x44>
 832:	6a05                	lui	s4,0x1
 834:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 838:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 83c:	00000917          	auipc	s2,0x0
 840:	7c490913          	addi	s2,s2,1988 # 1000 <freep>
  if(p == (char*)-1)
 844:	5afd                	li	s5,-1
 846:	a081                	j	886 <malloc+0x96>
 848:	f04a                	sd	s2,32(sp)
 84a:	e852                	sd	s4,16(sp)
 84c:	e456                	sd	s5,8(sp)
 84e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 850:	00000797          	auipc	a5,0x0
 854:	7c078793          	addi	a5,a5,1984 # 1010 <base>
 858:	00000717          	auipc	a4,0x0
 85c:	7af73423          	sd	a5,1960(a4) # 1000 <freep>
 860:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 862:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 866:	b7c1                	j	826 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 868:	6398                	ld	a4,0(a5)
 86a:	e118                	sd	a4,0(a0)
 86c:	a8a9                	j	8c6 <malloc+0xd6>
  hp->s.size = nu;
 86e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 872:	0541                	addi	a0,a0,16
 874:	efbff0ef          	jal	76e <free>
  return freep;
 878:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 87c:	c12d                	beqz	a0,8de <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 880:	4798                	lw	a4,8(a5)
 882:	02977263          	bgeu	a4,s1,8a6 <malloc+0xb6>
    if(p == freep)
 886:	00093703          	ld	a4,0(s2)
 88a:	853e                	mv	a0,a5
 88c:	fef719e3          	bne	a4,a5,87e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 890:	8552                	mv	a0,s4
 892:	b0bff0ef          	jal	39c <sbrk>
  if(p == (char*)-1)
 896:	fd551ce3          	bne	a0,s5,86e <malloc+0x7e>
        return 0;
 89a:	4501                	li	a0,0
 89c:	7902                	ld	s2,32(sp)
 89e:	6a42                	ld	s4,16(sp)
 8a0:	6aa2                	ld	s5,8(sp)
 8a2:	6b02                	ld	s6,0(sp)
 8a4:	a03d                	j	8d2 <malloc+0xe2>
 8a6:	7902                	ld	s2,32(sp)
 8a8:	6a42                	ld	s4,16(sp)
 8aa:	6aa2                	ld	s5,8(sp)
 8ac:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8ae:	fae48de3          	beq	s1,a4,868 <malloc+0x78>
        p->s.size -= nunits;
 8b2:	4137073b          	subw	a4,a4,s3
 8b6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8b8:	02071693          	slli	a3,a4,0x20
 8bc:	01c6d713          	srli	a4,a3,0x1c
 8c0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8c2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c6:	00000717          	auipc	a4,0x0
 8ca:	72a73d23          	sd	a0,1850(a4) # 1000 <freep>
      return (void*)(p + 1);
 8ce:	01078513          	addi	a0,a5,16
  }
}
 8d2:	70e2                	ld	ra,56(sp)
 8d4:	7442                	ld	s0,48(sp)
 8d6:	74a2                	ld	s1,40(sp)
 8d8:	69e2                	ld	s3,24(sp)
 8da:	6121                	addi	sp,sp,64
 8dc:	8082                	ret
 8de:	7902                	ld	s2,32(sp)
 8e0:	6a42                	ld	s4,16(sp)
 8e2:	6aa2                	ld	s5,8(sp)
 8e4:	6b02                	ld	s6,0(sp)
 8e6:	b7f5                	j	8d2 <malloc+0xe2>
