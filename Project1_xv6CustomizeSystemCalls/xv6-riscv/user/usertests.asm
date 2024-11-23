
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
       e:	00007797          	auipc	a5,0x7
      12:	43a78793          	addi	a5,a5,1082 # 7448 <malloc+0x2496>
      16:	638c                	ld	a1,0(a5)
      18:	6790                	ld	a2,8(a5)
      1a:	6b94                	ld	a3,16(a5)
      1c:	6f98                	ld	a4,24(a5)
      1e:	739c                	ld	a5,32(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      34:	fa840493          	addi	s1,s0,-88
      38:	fd040993          	addi	s3,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3c:	0004b903          	ld	s2,0(s1)
      40:	20100593          	li	a1,513
      44:	854a                	mv	a0,s2
      46:	2e1040ef          	jal	4b26 <open>
    if(fd >= 0){
      4a:	00055c63          	bgez	a0,62 <copyinstr1+0x62>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      4e:	04a1                	addi	s1,s1,8
      50:	ff3496e3          	bne	s1,s3,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      54:	60e6                	ld	ra,88(sp)
      56:	6446                	ld	s0,80(sp)
      58:	64a6                	ld	s1,72(sp)
      5a:	6906                	ld	s2,64(sp)
      5c:	79e2                	ld	s3,56(sp)
      5e:	6125                	addi	sp,sp,96
      60:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      62:	862a                	mv	a2,a0
      64:	85ca                	mv	a1,s2
      66:	00005517          	auipc	a0,0x5
      6a:	04a50513          	addi	a0,a0,74 # 50b0 <malloc+0xfe>
      6e:	691040ef          	jal	4efe <printf>
      exit(1);
      72:	4505                	li	a0,1
      74:	273040ef          	jal	4ae6 <exit>

0000000000000078 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      78:	0000a797          	auipc	a5,0xa
      7c:	4f078793          	addi	a5,a5,1264 # a568 <uninit>
      80:	0000d697          	auipc	a3,0xd
      84:	bf868693          	addi	a3,a3,-1032 # cc78 <buf>
    if(uninit[i] != '\0'){
      88:	0007c703          	lbu	a4,0(a5)
      8c:	e709                	bnez	a4,96 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      8e:	0785                	addi	a5,a5,1
      90:	fed79ce3          	bne	a5,a3,88 <bsstest+0x10>
      94:	8082                	ret
{
      96:	1141                	addi	sp,sp,-16
      98:	e406                	sd	ra,8(sp)
      9a:	e022                	sd	s0,0(sp)
      9c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      9e:	85aa                	mv	a1,a0
      a0:	00005517          	auipc	a0,0x5
      a4:	03050513          	addi	a0,a0,48 # 50d0 <malloc+0x11e>
      a8:	657040ef          	jal	4efe <printf>
      exit(1);
      ac:	4505                	li	a0,1
      ae:	239040ef          	jal	4ae6 <exit>

00000000000000b2 <opentest>:
{
      b2:	1101                	addi	sp,sp,-32
      b4:	ec06                	sd	ra,24(sp)
      b6:	e822                	sd	s0,16(sp)
      b8:	e426                	sd	s1,8(sp)
      ba:	1000                	addi	s0,sp,32
      bc:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      be:	4581                	li	a1,0
      c0:	00005517          	auipc	a0,0x5
      c4:	02850513          	addi	a0,a0,40 # 50e8 <malloc+0x136>
      c8:	25f040ef          	jal	4b26 <open>
  if(fd < 0){
      cc:	02054263          	bltz	a0,f0 <opentest+0x3e>
  close(fd);
      d0:	23f040ef          	jal	4b0e <close>
  fd = open("doesnotexist", 0);
      d4:	4581                	li	a1,0
      d6:	00005517          	auipc	a0,0x5
      da:	03250513          	addi	a0,a0,50 # 5108 <malloc+0x156>
      de:	249040ef          	jal	4b26 <open>
  if(fd >= 0){
      e2:	02055163          	bgez	a0,104 <opentest+0x52>
}
      e6:	60e2                	ld	ra,24(sp)
      e8:	6442                	ld	s0,16(sp)
      ea:	64a2                	ld	s1,8(sp)
      ec:	6105                	addi	sp,sp,32
      ee:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f0:	85a6                	mv	a1,s1
      f2:	00005517          	auipc	a0,0x5
      f6:	ffe50513          	addi	a0,a0,-2 # 50f0 <malloc+0x13e>
      fa:	605040ef          	jal	4efe <printf>
    exit(1);
      fe:	4505                	li	a0,1
     100:	1e7040ef          	jal	4ae6 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     104:	85a6                	mv	a1,s1
     106:	00005517          	auipc	a0,0x5
     10a:	01250513          	addi	a0,a0,18 # 5118 <malloc+0x166>
     10e:	5f1040ef          	jal	4efe <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	1d3040ef          	jal	4ae6 <exit>

0000000000000118 <truncate2>:
{
     118:	7179                	addi	sp,sp,-48
     11a:	f406                	sd	ra,40(sp)
     11c:	f022                	sd	s0,32(sp)
     11e:	ec26                	sd	s1,24(sp)
     120:	e84a                	sd	s2,16(sp)
     122:	e44e                	sd	s3,8(sp)
     124:	1800                	addi	s0,sp,48
     126:	89aa                	mv	s3,a0
  unlink("truncfile");
     128:	00005517          	auipc	a0,0x5
     12c:	01850513          	addi	a0,a0,24 # 5140 <malloc+0x18e>
     130:	207040ef          	jal	4b36 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     134:	60100593          	li	a1,1537
     138:	00005517          	auipc	a0,0x5
     13c:	00850513          	addi	a0,a0,8 # 5140 <malloc+0x18e>
     140:	1e7040ef          	jal	4b26 <open>
     144:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     146:	4611                	li	a2,4
     148:	00005597          	auipc	a1,0x5
     14c:	00858593          	addi	a1,a1,8 # 5150 <malloc+0x19e>
     150:	1b7040ef          	jal	4b06 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     154:	40100593          	li	a1,1025
     158:	00005517          	auipc	a0,0x5
     15c:	fe850513          	addi	a0,a0,-24 # 5140 <malloc+0x18e>
     160:	1c7040ef          	jal	4b26 <open>
     164:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     166:	4605                	li	a2,1
     168:	00005597          	auipc	a1,0x5
     16c:	ff058593          	addi	a1,a1,-16 # 5158 <malloc+0x1a6>
     170:	8526                	mv	a0,s1
     172:	195040ef          	jal	4b06 <write>
  if(n != -1){
     176:	57fd                	li	a5,-1
     178:	02f51563          	bne	a0,a5,1a2 <truncate2+0x8a>
  unlink("truncfile");
     17c:	00005517          	auipc	a0,0x5
     180:	fc450513          	addi	a0,a0,-60 # 5140 <malloc+0x18e>
     184:	1b3040ef          	jal	4b36 <unlink>
  close(fd1);
     188:	8526                	mv	a0,s1
     18a:	185040ef          	jal	4b0e <close>
  close(fd2);
     18e:	854a                	mv	a0,s2
     190:	17f040ef          	jal	4b0e <close>
}
     194:	70a2                	ld	ra,40(sp)
     196:	7402                	ld	s0,32(sp)
     198:	64e2                	ld	s1,24(sp)
     19a:	6942                	ld	s2,16(sp)
     19c:	69a2                	ld	s3,8(sp)
     19e:	6145                	addi	sp,sp,48
     1a0:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a2:	862a                	mv	a2,a0
     1a4:	85ce                	mv	a1,s3
     1a6:	00005517          	auipc	a0,0x5
     1aa:	fba50513          	addi	a0,a0,-70 # 5160 <malloc+0x1ae>
     1ae:	551040ef          	jal	4efe <printf>
    exit(1);
     1b2:	4505                	li	a0,1
     1b4:	133040ef          	jal	4ae6 <exit>

00000000000001b8 <createtest>:
{
     1b8:	7179                	addi	sp,sp,-48
     1ba:	f406                	sd	ra,40(sp)
     1bc:	f022                	sd	s0,32(sp)
     1be:	ec26                	sd	s1,24(sp)
     1c0:	e84a                	sd	s2,16(sp)
     1c2:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1c4:	06100793          	li	a5,97
     1c8:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1cc:	fc040d23          	sb	zero,-38(s0)
     1d0:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     1d4:	06400913          	li	s2,100
    name[1] = '0' + i;
     1d8:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1dc:	20200593          	li	a1,514
     1e0:	fd840513          	addi	a0,s0,-40
     1e4:	143040ef          	jal	4b26 <open>
    close(fd);
     1e8:	127040ef          	jal	4b0e <close>
  for(i = 0; i < N; i++){
     1ec:	2485                	addiw	s1,s1,1
     1ee:	0ff4f493          	zext.b	s1,s1
     1f2:	ff2493e3          	bne	s1,s2,1d8 <createtest+0x20>
  name[0] = 'a';
     1f6:	06100793          	li	a5,97
     1fa:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1fe:	fc040d23          	sb	zero,-38(s0)
     202:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     206:	06400913          	li	s2,100
    name[1] = '0' + i;
     20a:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     20e:	fd840513          	addi	a0,s0,-40
     212:	125040ef          	jal	4b36 <unlink>
  for(i = 0; i < N; i++){
     216:	2485                	addiw	s1,s1,1
     218:	0ff4f493          	zext.b	s1,s1
     21c:	ff2497e3          	bne	s1,s2,20a <createtest+0x52>
}
     220:	70a2                	ld	ra,40(sp)
     222:	7402                	ld	s0,32(sp)
     224:	64e2                	ld	s1,24(sp)
     226:	6942                	ld	s2,16(sp)
     228:	6145                	addi	sp,sp,48
     22a:	8082                	ret

000000000000022c <bigwrite>:
{
     22c:	715d                	addi	sp,sp,-80
     22e:	e486                	sd	ra,72(sp)
     230:	e0a2                	sd	s0,64(sp)
     232:	fc26                	sd	s1,56(sp)
     234:	f84a                	sd	s2,48(sp)
     236:	f44e                	sd	s3,40(sp)
     238:	f052                	sd	s4,32(sp)
     23a:	ec56                	sd	s5,24(sp)
     23c:	e85a                	sd	s6,16(sp)
     23e:	e45e                	sd	s7,8(sp)
     240:	0880                	addi	s0,sp,80
     242:	8baa                	mv	s7,a0
  unlink("bigwrite");
     244:	00005517          	auipc	a0,0x5
     248:	f4450513          	addi	a0,a0,-188 # 5188 <malloc+0x1d6>
     24c:	0eb040ef          	jal	4b36 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     250:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     254:	00005a97          	auipc	s5,0x5
     258:	f34a8a93          	addi	s5,s5,-204 # 5188 <malloc+0x1d6>
      int cc = write(fd, buf, sz);
     25c:	0000da17          	auipc	s4,0xd
     260:	a1ca0a13          	addi	s4,s4,-1508 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     264:	6b0d                	lui	s6,0x3
     266:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x5ed>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26a:	20200593          	li	a1,514
     26e:	8556                	mv	a0,s5
     270:	0b7040ef          	jal	4b26 <open>
     274:	892a                	mv	s2,a0
    if(fd < 0){
     276:	04054563          	bltz	a0,2c0 <bigwrite+0x94>
      int cc = write(fd, buf, sz);
     27a:	8626                	mv	a2,s1
     27c:	85d2                	mv	a1,s4
     27e:	089040ef          	jal	4b06 <write>
     282:	89aa                	mv	s3,a0
      if(cc != sz){
     284:	04a49863          	bne	s1,a0,2d4 <bigwrite+0xa8>
      int cc = write(fd, buf, sz);
     288:	8626                	mv	a2,s1
     28a:	85d2                	mv	a1,s4
     28c:	854a                	mv	a0,s2
     28e:	079040ef          	jal	4b06 <write>
      if(cc != sz){
     292:	04951263          	bne	a0,s1,2d6 <bigwrite+0xaa>
    close(fd);
     296:	854a                	mv	a0,s2
     298:	077040ef          	jal	4b0e <close>
    unlink("bigwrite");
     29c:	8556                	mv	a0,s5
     29e:	099040ef          	jal	4b36 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a2:	1d74849b          	addiw	s1,s1,471
     2a6:	fd6492e3          	bne	s1,s6,26a <bigwrite+0x3e>
}
     2aa:	60a6                	ld	ra,72(sp)
     2ac:	6406                	ld	s0,64(sp)
     2ae:	74e2                	ld	s1,56(sp)
     2b0:	7942                	ld	s2,48(sp)
     2b2:	79a2                	ld	s3,40(sp)
     2b4:	7a02                	ld	s4,32(sp)
     2b6:	6ae2                	ld	s5,24(sp)
     2b8:	6b42                	ld	s6,16(sp)
     2ba:	6ba2                	ld	s7,8(sp)
     2bc:	6161                	addi	sp,sp,80
     2be:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2c0:	85de                	mv	a1,s7
     2c2:	00005517          	auipc	a0,0x5
     2c6:	ed650513          	addi	a0,a0,-298 # 5198 <malloc+0x1e6>
     2ca:	435040ef          	jal	4efe <printf>
      exit(1);
     2ce:	4505                	li	a0,1
     2d0:	017040ef          	jal	4ae6 <exit>
      if(cc != sz){
     2d4:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2d6:	86aa                	mv	a3,a0
     2d8:	864e                	mv	a2,s3
     2da:	85de                	mv	a1,s7
     2dc:	00005517          	auipc	a0,0x5
     2e0:	edc50513          	addi	a0,a0,-292 # 51b8 <malloc+0x206>
     2e4:	41b040ef          	jal	4efe <printf>
        exit(1);
     2e8:	4505                	li	a0,1
     2ea:	7fc040ef          	jal	4ae6 <exit>

00000000000002ee <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     2ee:	7179                	addi	sp,sp,-48
     2f0:	f406                	sd	ra,40(sp)
     2f2:	f022                	sd	s0,32(sp)
     2f4:	ec26                	sd	s1,24(sp)
     2f6:	e84a                	sd	s2,16(sp)
     2f8:	e44e                	sd	s3,8(sp)
     2fa:	e052                	sd	s4,0(sp)
     2fc:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     2fe:	00005517          	auipc	a0,0x5
     302:	ed250513          	addi	a0,a0,-302 # 51d0 <malloc+0x21e>
     306:	031040ef          	jal	4b36 <unlink>
     30a:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     30e:	00005997          	auipc	s3,0x5
     312:	ec298993          	addi	s3,s3,-318 # 51d0 <malloc+0x21e>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     316:	5a7d                	li	s4,-1
     318:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     31c:	20100593          	li	a1,513
     320:	854e                	mv	a0,s3
     322:	005040ef          	jal	4b26 <open>
     326:	84aa                	mv	s1,a0
    if(fd < 0){
     328:	04054d63          	bltz	a0,382 <badwrite+0x94>
    write(fd, (char*)0xffffffffffL, 1);
     32c:	4605                	li	a2,1
     32e:	85d2                	mv	a1,s4
     330:	7d6040ef          	jal	4b06 <write>
    close(fd);
     334:	8526                	mv	a0,s1
     336:	7d8040ef          	jal	4b0e <close>
    unlink("junk");
     33a:	854e                	mv	a0,s3
     33c:	7fa040ef          	jal	4b36 <unlink>
  for(int i = 0; i < assumed_free; i++){
     340:	397d                	addiw	s2,s2,-1
     342:	fc091de3          	bnez	s2,31c <badwrite+0x2e>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     346:	20100593          	li	a1,513
     34a:	00005517          	auipc	a0,0x5
     34e:	e8650513          	addi	a0,a0,-378 # 51d0 <malloc+0x21e>
     352:	7d4040ef          	jal	4b26 <open>
     356:	84aa                	mv	s1,a0
  if(fd < 0){
     358:	02054e63          	bltz	a0,394 <badwrite+0xa6>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     35c:	4605                	li	a2,1
     35e:	00005597          	auipc	a1,0x5
     362:	dfa58593          	addi	a1,a1,-518 # 5158 <malloc+0x1a6>
     366:	7a0040ef          	jal	4b06 <write>
     36a:	4785                	li	a5,1
     36c:	02f50d63          	beq	a0,a5,3a6 <badwrite+0xb8>
    printf("write failed\n");
     370:	00005517          	auipc	a0,0x5
     374:	e8050513          	addi	a0,a0,-384 # 51f0 <malloc+0x23e>
     378:	387040ef          	jal	4efe <printf>
    exit(1);
     37c:	4505                	li	a0,1
     37e:	768040ef          	jal	4ae6 <exit>
      printf("open junk failed\n");
     382:	00005517          	auipc	a0,0x5
     386:	e5650513          	addi	a0,a0,-426 # 51d8 <malloc+0x226>
     38a:	375040ef          	jal	4efe <printf>
      exit(1);
     38e:	4505                	li	a0,1
     390:	756040ef          	jal	4ae6 <exit>
    printf("open junk failed\n");
     394:	00005517          	auipc	a0,0x5
     398:	e4450513          	addi	a0,a0,-444 # 51d8 <malloc+0x226>
     39c:	363040ef          	jal	4efe <printf>
    exit(1);
     3a0:	4505                	li	a0,1
     3a2:	744040ef          	jal	4ae6 <exit>
  }
  close(fd);
     3a6:	8526                	mv	a0,s1
     3a8:	766040ef          	jal	4b0e <close>
  unlink("junk");
     3ac:	00005517          	auipc	a0,0x5
     3b0:	e2450513          	addi	a0,a0,-476 # 51d0 <malloc+0x21e>
     3b4:	782040ef          	jal	4b36 <unlink>

  exit(0);
     3b8:	4501                	li	a0,0
     3ba:	72c040ef          	jal	4ae6 <exit>

00000000000003be <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3be:	715d                	addi	sp,sp,-80
     3c0:	e486                	sd	ra,72(sp)
     3c2:	e0a2                	sd	s0,64(sp)
     3c4:	fc26                	sd	s1,56(sp)
     3c6:	f84a                	sd	s2,48(sp)
     3c8:	f44e                	sd	s3,40(sp)
     3ca:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     3cc:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3ce:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     3d2:	40000993          	li	s3,1024
    name[0] = 'z';
     3d6:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     3da:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     3de:	41f4d71b          	sraiw	a4,s1,0x1f
     3e2:	01b7571b          	srliw	a4,a4,0x1b
     3e6:	009707bb          	addw	a5,a4,s1
     3ea:	4057d69b          	sraiw	a3,a5,0x5
     3ee:	0306869b          	addiw	a3,a3,48
     3f2:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     3f6:	8bfd                	andi	a5,a5,31
     3f8:	9f99                	subw	a5,a5,a4
     3fa:	0307879b          	addiw	a5,a5,48
     3fe:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     402:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     406:	fb040513          	addi	a0,s0,-80
     40a:	72c040ef          	jal	4b36 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     40e:	60200593          	li	a1,1538
     412:	fb040513          	addi	a0,s0,-80
     416:	710040ef          	jal	4b26 <open>
    if(fd < 0){
     41a:	00054763          	bltz	a0,428 <outofinodes+0x6a>
      // failure is eventually expected.
      break;
    }
    close(fd);
     41e:	6f0040ef          	jal	4b0e <close>
  for(int i = 0; i < nzz; i++){
     422:	2485                	addiw	s1,s1,1
     424:	fb3499e3          	bne	s1,s3,3d6 <outofinodes+0x18>
     428:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     42a:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     42e:	40000993          	li	s3,1024
    name[0] = 'z';
     432:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     436:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     43a:	41f4d71b          	sraiw	a4,s1,0x1f
     43e:	01b7571b          	srliw	a4,a4,0x1b
     442:	009707bb          	addw	a5,a4,s1
     446:	4057d69b          	sraiw	a3,a5,0x5
     44a:	0306869b          	addiw	a3,a3,48
     44e:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     452:	8bfd                	andi	a5,a5,31
     454:	9f99                	subw	a5,a5,a4
     456:	0307879b          	addiw	a5,a5,48
     45a:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     45e:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     462:	fb040513          	addi	a0,s0,-80
     466:	6d0040ef          	jal	4b36 <unlink>
  for(int i = 0; i < nzz; i++){
     46a:	2485                	addiw	s1,s1,1
     46c:	fd3493e3          	bne	s1,s3,432 <outofinodes+0x74>
  }
}
     470:	60a6                	ld	ra,72(sp)
     472:	6406                	ld	s0,64(sp)
     474:	74e2                	ld	s1,56(sp)
     476:	7942                	ld	s2,48(sp)
     478:	79a2                	ld	s3,40(sp)
     47a:	6161                	addi	sp,sp,80
     47c:	8082                	ret

000000000000047e <copyin>:
{
     47e:	7159                	addi	sp,sp,-112
     480:	f486                	sd	ra,104(sp)
     482:	f0a2                	sd	s0,96(sp)
     484:	eca6                	sd	s1,88(sp)
     486:	e8ca                	sd	s2,80(sp)
     488:	e4ce                	sd	s3,72(sp)
     48a:	e0d2                	sd	s4,64(sp)
     48c:	fc56                	sd	s5,56(sp)
     48e:	1880                	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     490:	00007797          	auipc	a5,0x7
     494:	fb878793          	addi	a5,a5,-72 # 7448 <malloc+0x2496>
     498:	638c                	ld	a1,0(a5)
     49a:	6790                	ld	a2,8(a5)
     49c:	6b94                	ld	a3,16(a5)
     49e:	6f98                	ld	a4,24(a5)
     4a0:	739c                	ld	a5,32(a5)
     4a2:	f8b43c23          	sd	a1,-104(s0)
     4a6:	fac43023          	sd	a2,-96(s0)
     4aa:	fad43423          	sd	a3,-88(s0)
     4ae:	fae43823          	sd	a4,-80(s0)
     4b2:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     4b6:	f9840913          	addi	s2,s0,-104
     4ba:	fc040a93          	addi	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4be:	00005a17          	auipc	s4,0x5
     4c2:	d42a0a13          	addi	s4,s4,-702 # 5200 <malloc+0x24e>
    uint64 addr = addrs[ai];
     4c6:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4ca:	20100593          	li	a1,513
     4ce:	8552                	mv	a0,s4
     4d0:	656040ef          	jal	4b26 <open>
     4d4:	84aa                	mv	s1,a0
    if(fd < 0){
     4d6:	06054763          	bltz	a0,544 <copyin+0xc6>
    int n = write(fd, (void*)addr, 8192);
     4da:	6609                	lui	a2,0x2
     4dc:	85ce                	mv	a1,s3
     4de:	628040ef          	jal	4b06 <write>
    if(n >= 0){
     4e2:	06055a63          	bgez	a0,556 <copyin+0xd8>
    close(fd);
     4e6:	8526                	mv	a0,s1
     4e8:	626040ef          	jal	4b0e <close>
    unlink("copyin1");
     4ec:	8552                	mv	a0,s4
     4ee:	648040ef          	jal	4b36 <unlink>
    n = write(1, (char*)addr, 8192);
     4f2:	6609                	lui	a2,0x2
     4f4:	85ce                	mv	a1,s3
     4f6:	4505                	li	a0,1
     4f8:	60e040ef          	jal	4b06 <write>
    if(n > 0){
     4fc:	06a04863          	bgtz	a0,56c <copyin+0xee>
    if(pipe(fds) < 0){
     500:	f9040513          	addi	a0,s0,-112
     504:	5f2040ef          	jal	4af6 <pipe>
     508:	06054d63          	bltz	a0,582 <copyin+0x104>
    n = write(fds[1], (char*)addr, 8192);
     50c:	6609                	lui	a2,0x2
     50e:	85ce                	mv	a1,s3
     510:	f9442503          	lw	a0,-108(s0)
     514:	5f2040ef          	jal	4b06 <write>
    if(n > 0){
     518:	06a04e63          	bgtz	a0,594 <copyin+0x116>
    close(fds[0]);
     51c:	f9042503          	lw	a0,-112(s0)
     520:	5ee040ef          	jal	4b0e <close>
    close(fds[1]);
     524:	f9442503          	lw	a0,-108(s0)
     528:	5e6040ef          	jal	4b0e <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     52c:	0921                	addi	s2,s2,8
     52e:	f9591ce3          	bne	s2,s5,4c6 <copyin+0x48>
}
     532:	70a6                	ld	ra,104(sp)
     534:	7406                	ld	s0,96(sp)
     536:	64e6                	ld	s1,88(sp)
     538:	6946                	ld	s2,80(sp)
     53a:	69a6                	ld	s3,72(sp)
     53c:	6a06                	ld	s4,64(sp)
     53e:	7ae2                	ld	s5,56(sp)
     540:	6165                	addi	sp,sp,112
     542:	8082                	ret
      printf("open(copyin1) failed\n");
     544:	00005517          	auipc	a0,0x5
     548:	cc450513          	addi	a0,a0,-828 # 5208 <malloc+0x256>
     54c:	1b3040ef          	jal	4efe <printf>
      exit(1);
     550:	4505                	li	a0,1
     552:	594040ef          	jal	4ae6 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     556:	862a                	mv	a2,a0
     558:	85ce                	mv	a1,s3
     55a:	00005517          	auipc	a0,0x5
     55e:	cc650513          	addi	a0,a0,-826 # 5220 <malloc+0x26e>
     562:	19d040ef          	jal	4efe <printf>
      exit(1);
     566:	4505                	li	a0,1
     568:	57e040ef          	jal	4ae6 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     56c:	862a                	mv	a2,a0
     56e:	85ce                	mv	a1,s3
     570:	00005517          	auipc	a0,0x5
     574:	ce050513          	addi	a0,a0,-800 # 5250 <malloc+0x29e>
     578:	187040ef          	jal	4efe <printf>
      exit(1);
     57c:	4505                	li	a0,1
     57e:	568040ef          	jal	4ae6 <exit>
      printf("pipe() failed\n");
     582:	00005517          	auipc	a0,0x5
     586:	cfe50513          	addi	a0,a0,-770 # 5280 <malloc+0x2ce>
     58a:	175040ef          	jal	4efe <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	556040ef          	jal	4ae6 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     594:	862a                	mv	a2,a0
     596:	85ce                	mv	a1,s3
     598:	00005517          	auipc	a0,0x5
     59c:	cf850513          	addi	a0,a0,-776 # 5290 <malloc+0x2de>
     5a0:	15f040ef          	jal	4efe <printf>
      exit(1);
     5a4:	4505                	li	a0,1
     5a6:	540040ef          	jal	4ae6 <exit>

00000000000005aa <copyout>:
{
     5aa:	7119                	addi	sp,sp,-128
     5ac:	fc86                	sd	ra,120(sp)
     5ae:	f8a2                	sd	s0,112(sp)
     5b0:	f4a6                	sd	s1,104(sp)
     5b2:	f0ca                	sd	s2,96(sp)
     5b4:	ecce                	sd	s3,88(sp)
     5b6:	e8d2                	sd	s4,80(sp)
     5b8:	e4d6                	sd	s5,72(sp)
     5ba:	e0da                	sd	s6,64(sp)
     5bc:	0100                	addi	s0,sp,128
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     5be:	00007797          	auipc	a5,0x7
     5c2:	e8a78793          	addi	a5,a5,-374 # 7448 <malloc+0x2496>
     5c6:	7788                	ld	a0,40(a5)
     5c8:	7b8c                	ld	a1,48(a5)
     5ca:	7f90                	ld	a2,56(a5)
     5cc:	63b4                	ld	a3,64(a5)
     5ce:	67b8                	ld	a4,72(a5)
     5d0:	6bbc                	ld	a5,80(a5)
     5d2:	f8a43823          	sd	a0,-112(s0)
     5d6:	f8b43c23          	sd	a1,-104(s0)
     5da:	fac43023          	sd	a2,-96(s0)
     5de:	fad43423          	sd	a3,-88(s0)
     5e2:	fae43823          	sd	a4,-80(s0)
     5e6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     5ea:	f9040913          	addi	s2,s0,-112
     5ee:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
     5f2:	00005a17          	auipc	s4,0x5
     5f6:	ccea0a13          	addi	s4,s4,-818 # 52c0 <malloc+0x30e>
    n = write(fds[1], "x", 1);
     5fa:	00005a97          	auipc	s5,0x5
     5fe:	b5ea8a93          	addi	s5,s5,-1186 # 5158 <malloc+0x1a6>
    uint64 addr = addrs[ai];
     602:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     606:	4581                	li	a1,0
     608:	8552                	mv	a0,s4
     60a:	51c040ef          	jal	4b26 <open>
     60e:	84aa                	mv	s1,a0
    if(fd < 0){
     610:	06054763          	bltz	a0,67e <copyout+0xd4>
    int n = read(fd, (void*)addr, 8192);
     614:	6609                	lui	a2,0x2
     616:	85ce                	mv	a1,s3
     618:	4e6040ef          	jal	4afe <read>
    if(n > 0){
     61c:	06a04a63          	bgtz	a0,690 <copyout+0xe6>
    close(fd);
     620:	8526                	mv	a0,s1
     622:	4ec040ef          	jal	4b0e <close>
    if(pipe(fds) < 0){
     626:	f8840513          	addi	a0,s0,-120
     62a:	4cc040ef          	jal	4af6 <pipe>
     62e:	06054c63          	bltz	a0,6a6 <copyout+0xfc>
    n = write(fds[1], "x", 1);
     632:	4605                	li	a2,1
     634:	85d6                	mv	a1,s5
     636:	f8c42503          	lw	a0,-116(s0)
     63a:	4cc040ef          	jal	4b06 <write>
    if(n != 1){
     63e:	4785                	li	a5,1
     640:	06f51c63          	bne	a0,a5,6b8 <copyout+0x10e>
    n = read(fds[0], (void*)addr, 8192);
     644:	6609                	lui	a2,0x2
     646:	85ce                	mv	a1,s3
     648:	f8842503          	lw	a0,-120(s0)
     64c:	4b2040ef          	jal	4afe <read>
    if(n > 0){
     650:	06a04d63          	bgtz	a0,6ca <copyout+0x120>
    close(fds[0]);
     654:	f8842503          	lw	a0,-120(s0)
     658:	4b6040ef          	jal	4b0e <close>
    close(fds[1]);
     65c:	f8c42503          	lw	a0,-116(s0)
     660:	4ae040ef          	jal	4b0e <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     664:	0921                	addi	s2,s2,8
     666:	f9691ee3          	bne	s2,s6,602 <copyout+0x58>
}
     66a:	70e6                	ld	ra,120(sp)
     66c:	7446                	ld	s0,112(sp)
     66e:	74a6                	ld	s1,104(sp)
     670:	7906                	ld	s2,96(sp)
     672:	69e6                	ld	s3,88(sp)
     674:	6a46                	ld	s4,80(sp)
     676:	6aa6                	ld	s5,72(sp)
     678:	6b06                	ld	s6,64(sp)
     67a:	6109                	addi	sp,sp,128
     67c:	8082                	ret
      printf("open(README) failed\n");
     67e:	00005517          	auipc	a0,0x5
     682:	c4a50513          	addi	a0,a0,-950 # 52c8 <malloc+0x316>
     686:	079040ef          	jal	4efe <printf>
      exit(1);
     68a:	4505                	li	a0,1
     68c:	45a040ef          	jal	4ae6 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     690:	862a                	mv	a2,a0
     692:	85ce                	mv	a1,s3
     694:	00005517          	auipc	a0,0x5
     698:	c4c50513          	addi	a0,a0,-948 # 52e0 <malloc+0x32e>
     69c:	063040ef          	jal	4efe <printf>
      exit(1);
     6a0:	4505                	li	a0,1
     6a2:	444040ef          	jal	4ae6 <exit>
      printf("pipe() failed\n");
     6a6:	00005517          	auipc	a0,0x5
     6aa:	bda50513          	addi	a0,a0,-1062 # 5280 <malloc+0x2ce>
     6ae:	051040ef          	jal	4efe <printf>
      exit(1);
     6b2:	4505                	li	a0,1
     6b4:	432040ef          	jal	4ae6 <exit>
      printf("pipe write failed\n");
     6b8:	00005517          	auipc	a0,0x5
     6bc:	c5850513          	addi	a0,a0,-936 # 5310 <malloc+0x35e>
     6c0:	03f040ef          	jal	4efe <printf>
      exit(1);
     6c4:	4505                	li	a0,1
     6c6:	420040ef          	jal	4ae6 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6ca:	862a                	mv	a2,a0
     6cc:	85ce                	mv	a1,s3
     6ce:	00005517          	auipc	a0,0x5
     6d2:	c5a50513          	addi	a0,a0,-934 # 5328 <malloc+0x376>
     6d6:	029040ef          	jal	4efe <printf>
      exit(1);
     6da:	4505                	li	a0,1
     6dc:	40a040ef          	jal	4ae6 <exit>

00000000000006e0 <truncate1>:
{
     6e0:	711d                	addi	sp,sp,-96
     6e2:	ec86                	sd	ra,88(sp)
     6e4:	e8a2                	sd	s0,80(sp)
     6e6:	e4a6                	sd	s1,72(sp)
     6e8:	e0ca                	sd	s2,64(sp)
     6ea:	fc4e                	sd	s3,56(sp)
     6ec:	f852                	sd	s4,48(sp)
     6ee:	f456                	sd	s5,40(sp)
     6f0:	1080                	addi	s0,sp,96
     6f2:	8aaa                	mv	s5,a0
  unlink("truncfile");
     6f4:	00005517          	auipc	a0,0x5
     6f8:	a4c50513          	addi	a0,a0,-1460 # 5140 <malloc+0x18e>
     6fc:	43a040ef          	jal	4b36 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     700:	60100593          	li	a1,1537
     704:	00005517          	auipc	a0,0x5
     708:	a3c50513          	addi	a0,a0,-1476 # 5140 <malloc+0x18e>
     70c:	41a040ef          	jal	4b26 <open>
     710:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     712:	4611                	li	a2,4
     714:	00005597          	auipc	a1,0x5
     718:	a3c58593          	addi	a1,a1,-1476 # 5150 <malloc+0x19e>
     71c:	3ea040ef          	jal	4b06 <write>
  close(fd1);
     720:	8526                	mv	a0,s1
     722:	3ec040ef          	jal	4b0e <close>
  int fd2 = open("truncfile", O_RDONLY);
     726:	4581                	li	a1,0
     728:	00005517          	auipc	a0,0x5
     72c:	a1850513          	addi	a0,a0,-1512 # 5140 <malloc+0x18e>
     730:	3f6040ef          	jal	4b26 <open>
     734:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     736:	02000613          	li	a2,32
     73a:	fa040593          	addi	a1,s0,-96
     73e:	3c0040ef          	jal	4afe <read>
  if(n != 4){
     742:	4791                	li	a5,4
     744:	0af51863          	bne	a0,a5,7f4 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     748:	40100593          	li	a1,1025
     74c:	00005517          	auipc	a0,0x5
     750:	9f450513          	addi	a0,a0,-1548 # 5140 <malloc+0x18e>
     754:	3d2040ef          	jal	4b26 <open>
     758:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     75a:	4581                	li	a1,0
     75c:	00005517          	auipc	a0,0x5
     760:	9e450513          	addi	a0,a0,-1564 # 5140 <malloc+0x18e>
     764:	3c2040ef          	jal	4b26 <open>
     768:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     76a:	02000613          	li	a2,32
     76e:	fa040593          	addi	a1,s0,-96
     772:	38c040ef          	jal	4afe <read>
     776:	8a2a                	mv	s4,a0
  if(n != 0){
     778:	e949                	bnez	a0,80a <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     77a:	02000613          	li	a2,32
     77e:	fa040593          	addi	a1,s0,-96
     782:	8526                	mv	a0,s1
     784:	37a040ef          	jal	4afe <read>
     788:	8a2a                	mv	s4,a0
  if(n != 0){
     78a:	e155                	bnez	a0,82e <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     78c:	4619                	li	a2,6
     78e:	00005597          	auipc	a1,0x5
     792:	c2a58593          	addi	a1,a1,-982 # 53b8 <malloc+0x406>
     796:	854e                	mv	a0,s3
     798:	36e040ef          	jal	4b06 <write>
  n = read(fd3, buf, sizeof(buf));
     79c:	02000613          	li	a2,32
     7a0:	fa040593          	addi	a1,s0,-96
     7a4:	854a                	mv	a0,s2
     7a6:	358040ef          	jal	4afe <read>
  if(n != 6){
     7aa:	4799                	li	a5,6
     7ac:	0af51363          	bne	a0,a5,852 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     7b0:	02000613          	li	a2,32
     7b4:	fa040593          	addi	a1,s0,-96
     7b8:	8526                	mv	a0,s1
     7ba:	344040ef          	jal	4afe <read>
  if(n != 2){
     7be:	4789                	li	a5,2
     7c0:	0af51463          	bne	a0,a5,868 <truncate1+0x188>
  unlink("truncfile");
     7c4:	00005517          	auipc	a0,0x5
     7c8:	97c50513          	addi	a0,a0,-1668 # 5140 <malloc+0x18e>
     7cc:	36a040ef          	jal	4b36 <unlink>
  close(fd1);
     7d0:	854e                	mv	a0,s3
     7d2:	33c040ef          	jal	4b0e <close>
  close(fd2);
     7d6:	8526                	mv	a0,s1
     7d8:	336040ef          	jal	4b0e <close>
  close(fd3);
     7dc:	854a                	mv	a0,s2
     7de:	330040ef          	jal	4b0e <close>
}
     7e2:	60e6                	ld	ra,88(sp)
     7e4:	6446                	ld	s0,80(sp)
     7e6:	64a6                	ld	s1,72(sp)
     7e8:	6906                	ld	s2,64(sp)
     7ea:	79e2                	ld	s3,56(sp)
     7ec:	7a42                	ld	s4,48(sp)
     7ee:	7aa2                	ld	s5,40(sp)
     7f0:	6125                	addi	sp,sp,96
     7f2:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     7f4:	862a                	mv	a2,a0
     7f6:	85d6                	mv	a1,s5
     7f8:	00005517          	auipc	a0,0x5
     7fc:	b6050513          	addi	a0,a0,-1184 # 5358 <malloc+0x3a6>
     800:	6fe040ef          	jal	4efe <printf>
    exit(1);
     804:	4505                	li	a0,1
     806:	2e0040ef          	jal	4ae6 <exit>
    printf("aaa fd3=%d\n", fd3);
     80a:	85ca                	mv	a1,s2
     80c:	00005517          	auipc	a0,0x5
     810:	b6c50513          	addi	a0,a0,-1172 # 5378 <malloc+0x3c6>
     814:	6ea040ef          	jal	4efe <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     818:	8652                	mv	a2,s4
     81a:	85d6                	mv	a1,s5
     81c:	00005517          	auipc	a0,0x5
     820:	b6c50513          	addi	a0,a0,-1172 # 5388 <malloc+0x3d6>
     824:	6da040ef          	jal	4efe <printf>
    exit(1);
     828:	4505                	li	a0,1
     82a:	2bc040ef          	jal	4ae6 <exit>
    printf("bbb fd2=%d\n", fd2);
     82e:	85a6                	mv	a1,s1
     830:	00005517          	auipc	a0,0x5
     834:	b7850513          	addi	a0,a0,-1160 # 53a8 <malloc+0x3f6>
     838:	6c6040ef          	jal	4efe <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     83c:	8652                	mv	a2,s4
     83e:	85d6                	mv	a1,s5
     840:	00005517          	auipc	a0,0x5
     844:	b4850513          	addi	a0,a0,-1208 # 5388 <malloc+0x3d6>
     848:	6b6040ef          	jal	4efe <printf>
    exit(1);
     84c:	4505                	li	a0,1
     84e:	298040ef          	jal	4ae6 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     852:	862a                	mv	a2,a0
     854:	85d6                	mv	a1,s5
     856:	00005517          	auipc	a0,0x5
     85a:	b6a50513          	addi	a0,a0,-1174 # 53c0 <malloc+0x40e>
     85e:	6a0040ef          	jal	4efe <printf>
    exit(1);
     862:	4505                	li	a0,1
     864:	282040ef          	jal	4ae6 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     868:	862a                	mv	a2,a0
     86a:	85d6                	mv	a1,s5
     86c:	00005517          	auipc	a0,0x5
     870:	b7450513          	addi	a0,a0,-1164 # 53e0 <malloc+0x42e>
     874:	68a040ef          	jal	4efe <printf>
    exit(1);
     878:	4505                	li	a0,1
     87a:	26c040ef          	jal	4ae6 <exit>

000000000000087e <writetest>:
{
     87e:	7139                	addi	sp,sp,-64
     880:	fc06                	sd	ra,56(sp)
     882:	f822                	sd	s0,48(sp)
     884:	f426                	sd	s1,40(sp)
     886:	f04a                	sd	s2,32(sp)
     888:	ec4e                	sd	s3,24(sp)
     88a:	e852                	sd	s4,16(sp)
     88c:	e456                	sd	s5,8(sp)
     88e:	e05a                	sd	s6,0(sp)
     890:	0080                	addi	s0,sp,64
     892:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     894:	20200593          	li	a1,514
     898:	00005517          	auipc	a0,0x5
     89c:	b6850513          	addi	a0,a0,-1176 # 5400 <malloc+0x44e>
     8a0:	286040ef          	jal	4b26 <open>
  if(fd < 0){
     8a4:	08054f63          	bltz	a0,942 <writetest+0xc4>
     8a8:	892a                	mv	s2,a0
     8aa:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8ac:	00005997          	auipc	s3,0x5
     8b0:	b7c98993          	addi	s3,s3,-1156 # 5428 <malloc+0x476>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8b4:	00005a97          	auipc	s5,0x5
     8b8:	baca8a93          	addi	s5,s5,-1108 # 5460 <malloc+0x4ae>
  for(i = 0; i < N; i++){
     8bc:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8c0:	4629                	li	a2,10
     8c2:	85ce                	mv	a1,s3
     8c4:	854a                	mv	a0,s2
     8c6:	240040ef          	jal	4b06 <write>
     8ca:	47a9                	li	a5,10
     8cc:	08f51563          	bne	a0,a5,956 <writetest+0xd8>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8d0:	4629                	li	a2,10
     8d2:	85d6                	mv	a1,s5
     8d4:	854a                	mv	a0,s2
     8d6:	230040ef          	jal	4b06 <write>
     8da:	47a9                	li	a5,10
     8dc:	08f51863          	bne	a0,a5,96c <writetest+0xee>
  for(i = 0; i < N; i++){
     8e0:	2485                	addiw	s1,s1,1
     8e2:	fd449fe3          	bne	s1,s4,8c0 <writetest+0x42>
  close(fd);
     8e6:	854a                	mv	a0,s2
     8e8:	226040ef          	jal	4b0e <close>
  fd = open("small", O_RDONLY);
     8ec:	4581                	li	a1,0
     8ee:	00005517          	auipc	a0,0x5
     8f2:	b1250513          	addi	a0,a0,-1262 # 5400 <malloc+0x44e>
     8f6:	230040ef          	jal	4b26 <open>
     8fa:	84aa                	mv	s1,a0
  if(fd < 0){
     8fc:	08054363          	bltz	a0,982 <writetest+0x104>
  i = read(fd, buf, N*SZ*2);
     900:	7d000613          	li	a2,2000
     904:	0000c597          	auipc	a1,0xc
     908:	37458593          	addi	a1,a1,884 # cc78 <buf>
     90c:	1f2040ef          	jal	4afe <read>
  if(i != N*SZ*2){
     910:	7d000793          	li	a5,2000
     914:	08f51163          	bne	a0,a5,996 <writetest+0x118>
  close(fd);
     918:	8526                	mv	a0,s1
     91a:	1f4040ef          	jal	4b0e <close>
  if(unlink("small") < 0){
     91e:	00005517          	auipc	a0,0x5
     922:	ae250513          	addi	a0,a0,-1310 # 5400 <malloc+0x44e>
     926:	210040ef          	jal	4b36 <unlink>
     92a:	08054063          	bltz	a0,9aa <writetest+0x12c>
}
     92e:	70e2                	ld	ra,56(sp)
     930:	7442                	ld	s0,48(sp)
     932:	74a2                	ld	s1,40(sp)
     934:	7902                	ld	s2,32(sp)
     936:	69e2                	ld	s3,24(sp)
     938:	6a42                	ld	s4,16(sp)
     93a:	6aa2                	ld	s5,8(sp)
     93c:	6b02                	ld	s6,0(sp)
     93e:	6121                	addi	sp,sp,64
     940:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     942:	85da                	mv	a1,s6
     944:	00005517          	auipc	a0,0x5
     948:	ac450513          	addi	a0,a0,-1340 # 5408 <malloc+0x456>
     94c:	5b2040ef          	jal	4efe <printf>
    exit(1);
     950:	4505                	li	a0,1
     952:	194040ef          	jal	4ae6 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     956:	8626                	mv	a2,s1
     958:	85da                	mv	a1,s6
     95a:	00005517          	auipc	a0,0x5
     95e:	ade50513          	addi	a0,a0,-1314 # 5438 <malloc+0x486>
     962:	59c040ef          	jal	4efe <printf>
      exit(1);
     966:	4505                	li	a0,1
     968:	17e040ef          	jal	4ae6 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     96c:	8626                	mv	a2,s1
     96e:	85da                	mv	a1,s6
     970:	00005517          	auipc	a0,0x5
     974:	b0050513          	addi	a0,a0,-1280 # 5470 <malloc+0x4be>
     978:	586040ef          	jal	4efe <printf>
      exit(1);
     97c:	4505                	li	a0,1
     97e:	168040ef          	jal	4ae6 <exit>
    printf("%s: error: open small failed!\n", s);
     982:	85da                	mv	a1,s6
     984:	00005517          	auipc	a0,0x5
     988:	b1450513          	addi	a0,a0,-1260 # 5498 <malloc+0x4e6>
     98c:	572040ef          	jal	4efe <printf>
    exit(1);
     990:	4505                	li	a0,1
     992:	154040ef          	jal	4ae6 <exit>
    printf("%s: read failed\n", s);
     996:	85da                	mv	a1,s6
     998:	00005517          	auipc	a0,0x5
     99c:	b2050513          	addi	a0,a0,-1248 # 54b8 <malloc+0x506>
     9a0:	55e040ef          	jal	4efe <printf>
    exit(1);
     9a4:	4505                	li	a0,1
     9a6:	140040ef          	jal	4ae6 <exit>
    printf("%s: unlink small failed\n", s);
     9aa:	85da                	mv	a1,s6
     9ac:	00005517          	auipc	a0,0x5
     9b0:	b2450513          	addi	a0,a0,-1244 # 54d0 <malloc+0x51e>
     9b4:	54a040ef          	jal	4efe <printf>
    exit(1);
     9b8:	4505                	li	a0,1
     9ba:	12c040ef          	jal	4ae6 <exit>

00000000000009be <writebig>:
{
     9be:	7139                	addi	sp,sp,-64
     9c0:	fc06                	sd	ra,56(sp)
     9c2:	f822                	sd	s0,48(sp)
     9c4:	f426                	sd	s1,40(sp)
     9c6:	f04a                	sd	s2,32(sp)
     9c8:	ec4e                	sd	s3,24(sp)
     9ca:	e852                	sd	s4,16(sp)
     9cc:	e456                	sd	s5,8(sp)
     9ce:	0080                	addi	s0,sp,64
     9d0:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9d2:	20200593          	li	a1,514
     9d6:	00005517          	auipc	a0,0x5
     9da:	b1a50513          	addi	a0,a0,-1254 # 54f0 <malloc+0x53e>
     9de:	148040ef          	jal	4b26 <open>
     9e2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e6:	0000c917          	auipc	s2,0xc
     9ea:	29290913          	addi	s2,s2,658 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     9ee:	10c00a13          	li	s4,268
  if(fd < 0){
     9f2:	06054463          	bltz	a0,a5a <writebig+0x9c>
    ((int*)buf)[0] = i;
     9f6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fa:	40000613          	li	a2,1024
     9fe:	85ca                	mv	a1,s2
     a00:	854e                	mv	a0,s3
     a02:	104040ef          	jal	4b06 <write>
     a06:	40000793          	li	a5,1024
     a0a:	06f51263          	bne	a0,a5,a6e <writebig+0xb0>
  for(i = 0; i < MAXFILE; i++){
     a0e:	2485                	addiw	s1,s1,1
     a10:	ff4493e3          	bne	s1,s4,9f6 <writebig+0x38>
  close(fd);
     a14:	854e                	mv	a0,s3
     a16:	0f8040ef          	jal	4b0e <close>
  fd = open("big", O_RDONLY);
     a1a:	4581                	li	a1,0
     a1c:	00005517          	auipc	a0,0x5
     a20:	ad450513          	addi	a0,a0,-1324 # 54f0 <malloc+0x53e>
     a24:	102040ef          	jal	4b26 <open>
     a28:	89aa                	mv	s3,a0
  n = 0;
     a2a:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a2c:	0000c917          	auipc	s2,0xc
     a30:	24c90913          	addi	s2,s2,588 # cc78 <buf>
  if(fd < 0){
     a34:	04054863          	bltz	a0,a84 <writebig+0xc6>
    i = read(fd, buf, BSIZE);
     a38:	40000613          	li	a2,1024
     a3c:	85ca                	mv	a1,s2
     a3e:	854e                	mv	a0,s3
     a40:	0be040ef          	jal	4afe <read>
    if(i == 0){
     a44:	c931                	beqz	a0,a98 <writebig+0xda>
    } else if(i != BSIZE){
     a46:	40000793          	li	a5,1024
     a4a:	08f51a63          	bne	a0,a5,ade <writebig+0x120>
    if(((int*)buf)[0] != n){
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0a969163          	bne	a3,s1,af4 <writebig+0x136>
    n++;
     a56:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a58:	b7c5                	j	a38 <writebig+0x7a>
    printf("%s: error: creat big failed!\n", s);
     a5a:	85d6                	mv	a1,s5
     a5c:	00005517          	auipc	a0,0x5
     a60:	a9c50513          	addi	a0,a0,-1380 # 54f8 <malloc+0x546>
     a64:	49a040ef          	jal	4efe <printf>
    exit(1);
     a68:	4505                	li	a0,1
     a6a:	07c040ef          	jal	4ae6 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     a6e:	8626                	mv	a2,s1
     a70:	85d6                	mv	a1,s5
     a72:	00005517          	auipc	a0,0x5
     a76:	aa650513          	addi	a0,a0,-1370 # 5518 <malloc+0x566>
     a7a:	484040ef          	jal	4efe <printf>
      exit(1);
     a7e:	4505                	li	a0,1
     a80:	066040ef          	jal	4ae6 <exit>
    printf("%s: error: open big failed!\n", s);
     a84:	85d6                	mv	a1,s5
     a86:	00005517          	auipc	a0,0x5
     a8a:	aba50513          	addi	a0,a0,-1350 # 5540 <malloc+0x58e>
     a8e:	470040ef          	jal	4efe <printf>
    exit(1);
     a92:	4505                	li	a0,1
     a94:	052040ef          	jal	4ae6 <exit>
      if(n != MAXFILE){
     a98:	10c00793          	li	a5,268
     a9c:	02f49663          	bne	s1,a5,ac8 <writebig+0x10a>
  close(fd);
     aa0:	854e                	mv	a0,s3
     aa2:	06c040ef          	jal	4b0e <close>
  if(unlink("big") < 0){
     aa6:	00005517          	auipc	a0,0x5
     aaa:	a4a50513          	addi	a0,a0,-1462 # 54f0 <malloc+0x53e>
     aae:	088040ef          	jal	4b36 <unlink>
     ab2:	04054c63          	bltz	a0,b0a <writebig+0x14c>
}
     ab6:	70e2                	ld	ra,56(sp)
     ab8:	7442                	ld	s0,48(sp)
     aba:	74a2                	ld	s1,40(sp)
     abc:	7902                	ld	s2,32(sp)
     abe:	69e2                	ld	s3,24(sp)
     ac0:	6a42                	ld	s4,16(sp)
     ac2:	6aa2                	ld	s5,8(sp)
     ac4:	6121                	addi	sp,sp,64
     ac6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ac8:	8626                	mv	a2,s1
     aca:	85d6                	mv	a1,s5
     acc:	00005517          	auipc	a0,0x5
     ad0:	a9450513          	addi	a0,a0,-1388 # 5560 <malloc+0x5ae>
     ad4:	42a040ef          	jal	4efe <printf>
        exit(1);
     ad8:	4505                	li	a0,1
     ada:	00c040ef          	jal	4ae6 <exit>
      printf("%s: read failed %d\n", s, i);
     ade:	862a                	mv	a2,a0
     ae0:	85d6                	mv	a1,s5
     ae2:	00005517          	auipc	a0,0x5
     ae6:	aa650513          	addi	a0,a0,-1370 # 5588 <malloc+0x5d6>
     aea:	414040ef          	jal	4efe <printf>
      exit(1);
     aee:	4505                	li	a0,1
     af0:	7f7030ef          	jal	4ae6 <exit>
      printf("%s: read content of block %d is %d\n", s,
     af4:	8626                	mv	a2,s1
     af6:	85d6                	mv	a1,s5
     af8:	00005517          	auipc	a0,0x5
     afc:	aa850513          	addi	a0,a0,-1368 # 55a0 <malloc+0x5ee>
     b00:	3fe040ef          	jal	4efe <printf>
      exit(1);
     b04:	4505                	li	a0,1
     b06:	7e1030ef          	jal	4ae6 <exit>
    printf("%s: unlink big failed\n", s);
     b0a:	85d6                	mv	a1,s5
     b0c:	00005517          	auipc	a0,0x5
     b10:	abc50513          	addi	a0,a0,-1348 # 55c8 <malloc+0x616>
     b14:	3ea040ef          	jal	4efe <printf>
    exit(1);
     b18:	4505                	li	a0,1
     b1a:	7cd030ef          	jal	4ae6 <exit>

0000000000000b1e <unlinkread>:
{
     b1e:	7179                	addi	sp,sp,-48
     b20:	f406                	sd	ra,40(sp)
     b22:	f022                	sd	s0,32(sp)
     b24:	ec26                	sd	s1,24(sp)
     b26:	e84a                	sd	s2,16(sp)
     b28:	e44e                	sd	s3,8(sp)
     b2a:	1800                	addi	s0,sp,48
     b2c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b2e:	20200593          	li	a1,514
     b32:	00005517          	auipc	a0,0x5
     b36:	aae50513          	addi	a0,a0,-1362 # 55e0 <malloc+0x62e>
     b3a:	7ed030ef          	jal	4b26 <open>
  if(fd < 0){
     b3e:	0a054f63          	bltz	a0,bfc <unlinkread+0xde>
     b42:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b44:	4615                	li	a2,5
     b46:	00005597          	auipc	a1,0x5
     b4a:	aca58593          	addi	a1,a1,-1334 # 5610 <malloc+0x65e>
     b4e:	7b9030ef          	jal	4b06 <write>
  close(fd);
     b52:	8526                	mv	a0,s1
     b54:	7bb030ef          	jal	4b0e <close>
  fd = open("unlinkread", O_RDWR);
     b58:	4589                	li	a1,2
     b5a:	00005517          	auipc	a0,0x5
     b5e:	a8650513          	addi	a0,a0,-1402 # 55e0 <malloc+0x62e>
     b62:	7c5030ef          	jal	4b26 <open>
     b66:	84aa                	mv	s1,a0
  if(fd < 0){
     b68:	0a054463          	bltz	a0,c10 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     b6c:	00005517          	auipc	a0,0x5
     b70:	a7450513          	addi	a0,a0,-1420 # 55e0 <malloc+0x62e>
     b74:	7c3030ef          	jal	4b36 <unlink>
     b78:	e555                	bnez	a0,c24 <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     b7a:	20200593          	li	a1,514
     b7e:	00005517          	auipc	a0,0x5
     b82:	a6250513          	addi	a0,a0,-1438 # 55e0 <malloc+0x62e>
     b86:	7a1030ef          	jal	4b26 <open>
     b8a:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     b8c:	460d                	li	a2,3
     b8e:	00005597          	auipc	a1,0x5
     b92:	aca58593          	addi	a1,a1,-1334 # 5658 <malloc+0x6a6>
     b96:	771030ef          	jal	4b06 <write>
  close(fd1);
     b9a:	854a                	mv	a0,s2
     b9c:	773030ef          	jal	4b0e <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     ba0:	660d                	lui	a2,0x3
     ba2:	0000c597          	auipc	a1,0xc
     ba6:	0d658593          	addi	a1,a1,214 # cc78 <buf>
     baa:	8526                	mv	a0,s1
     bac:	753030ef          	jal	4afe <read>
     bb0:	4795                	li	a5,5
     bb2:	08f51363          	bne	a0,a5,c38 <unlinkread+0x11a>
  if(buf[0] != 'h'){
     bb6:	0000c717          	auipc	a4,0xc
     bba:	0c274703          	lbu	a4,194(a4) # cc78 <buf>
     bbe:	06800793          	li	a5,104
     bc2:	08f71563          	bne	a4,a5,c4c <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     bc6:	4629                	li	a2,10
     bc8:	0000c597          	auipc	a1,0xc
     bcc:	0b058593          	addi	a1,a1,176 # cc78 <buf>
     bd0:	8526                	mv	a0,s1
     bd2:	735030ef          	jal	4b06 <write>
     bd6:	47a9                	li	a5,10
     bd8:	08f51463          	bne	a0,a5,c60 <unlinkread+0x142>
  close(fd);
     bdc:	8526                	mv	a0,s1
     bde:	731030ef          	jal	4b0e <close>
  unlink("unlinkread");
     be2:	00005517          	auipc	a0,0x5
     be6:	9fe50513          	addi	a0,a0,-1538 # 55e0 <malloc+0x62e>
     bea:	74d030ef          	jal	4b36 <unlink>
}
     bee:	70a2                	ld	ra,40(sp)
     bf0:	7402                	ld	s0,32(sp)
     bf2:	64e2                	ld	s1,24(sp)
     bf4:	6942                	ld	s2,16(sp)
     bf6:	69a2                	ld	s3,8(sp)
     bf8:	6145                	addi	sp,sp,48
     bfa:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     bfc:	85ce                	mv	a1,s3
     bfe:	00005517          	auipc	a0,0x5
     c02:	9f250513          	addi	a0,a0,-1550 # 55f0 <malloc+0x63e>
     c06:	2f8040ef          	jal	4efe <printf>
    exit(1);
     c0a:	4505                	li	a0,1
     c0c:	6db030ef          	jal	4ae6 <exit>
    printf("%s: open unlinkread failed\n", s);
     c10:	85ce                	mv	a1,s3
     c12:	00005517          	auipc	a0,0x5
     c16:	a0650513          	addi	a0,a0,-1530 # 5618 <malloc+0x666>
     c1a:	2e4040ef          	jal	4efe <printf>
    exit(1);
     c1e:	4505                	li	a0,1
     c20:	6c7030ef          	jal	4ae6 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c24:	85ce                	mv	a1,s3
     c26:	00005517          	auipc	a0,0x5
     c2a:	a1250513          	addi	a0,a0,-1518 # 5638 <malloc+0x686>
     c2e:	2d0040ef          	jal	4efe <printf>
    exit(1);
     c32:	4505                	li	a0,1
     c34:	6b3030ef          	jal	4ae6 <exit>
    printf("%s: unlinkread read failed", s);
     c38:	85ce                	mv	a1,s3
     c3a:	00005517          	auipc	a0,0x5
     c3e:	a2650513          	addi	a0,a0,-1498 # 5660 <malloc+0x6ae>
     c42:	2bc040ef          	jal	4efe <printf>
    exit(1);
     c46:	4505                	li	a0,1
     c48:	69f030ef          	jal	4ae6 <exit>
    printf("%s: unlinkread wrong data\n", s);
     c4c:	85ce                	mv	a1,s3
     c4e:	00005517          	auipc	a0,0x5
     c52:	a3250513          	addi	a0,a0,-1486 # 5680 <malloc+0x6ce>
     c56:	2a8040ef          	jal	4efe <printf>
    exit(1);
     c5a:	4505                	li	a0,1
     c5c:	68b030ef          	jal	4ae6 <exit>
    printf("%s: unlinkread write failed\n", s);
     c60:	85ce                	mv	a1,s3
     c62:	00005517          	auipc	a0,0x5
     c66:	a3e50513          	addi	a0,a0,-1474 # 56a0 <malloc+0x6ee>
     c6a:	294040ef          	jal	4efe <printf>
    exit(1);
     c6e:	4505                	li	a0,1
     c70:	677030ef          	jal	4ae6 <exit>

0000000000000c74 <linktest>:
{
     c74:	1101                	addi	sp,sp,-32
     c76:	ec06                	sd	ra,24(sp)
     c78:	e822                	sd	s0,16(sp)
     c7a:	e426                	sd	s1,8(sp)
     c7c:	e04a                	sd	s2,0(sp)
     c7e:	1000                	addi	s0,sp,32
     c80:	892a                	mv	s2,a0
  unlink("lf1");
     c82:	00005517          	auipc	a0,0x5
     c86:	a3e50513          	addi	a0,a0,-1474 # 56c0 <malloc+0x70e>
     c8a:	6ad030ef          	jal	4b36 <unlink>
  unlink("lf2");
     c8e:	00005517          	auipc	a0,0x5
     c92:	a3a50513          	addi	a0,a0,-1478 # 56c8 <malloc+0x716>
     c96:	6a1030ef          	jal	4b36 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     c9a:	20200593          	li	a1,514
     c9e:	00005517          	auipc	a0,0x5
     ca2:	a2250513          	addi	a0,a0,-1502 # 56c0 <malloc+0x70e>
     ca6:	681030ef          	jal	4b26 <open>
  if(fd < 0){
     caa:	0c054f63          	bltz	a0,d88 <linktest+0x114>
     cae:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     cb0:	4615                	li	a2,5
     cb2:	00005597          	auipc	a1,0x5
     cb6:	95e58593          	addi	a1,a1,-1698 # 5610 <malloc+0x65e>
     cba:	64d030ef          	jal	4b06 <write>
     cbe:	4795                	li	a5,5
     cc0:	0cf51e63          	bne	a0,a5,d9c <linktest+0x128>
  close(fd);
     cc4:	8526                	mv	a0,s1
     cc6:	649030ef          	jal	4b0e <close>
  if(link("lf1", "lf2") < 0){
     cca:	00005597          	auipc	a1,0x5
     cce:	9fe58593          	addi	a1,a1,-1538 # 56c8 <malloc+0x716>
     cd2:	00005517          	auipc	a0,0x5
     cd6:	9ee50513          	addi	a0,a0,-1554 # 56c0 <malloc+0x70e>
     cda:	66d030ef          	jal	4b46 <link>
     cde:	0c054963          	bltz	a0,db0 <linktest+0x13c>
  unlink("lf1");
     ce2:	00005517          	auipc	a0,0x5
     ce6:	9de50513          	addi	a0,a0,-1570 # 56c0 <malloc+0x70e>
     cea:	64d030ef          	jal	4b36 <unlink>
  if(open("lf1", 0) >= 0){
     cee:	4581                	li	a1,0
     cf0:	00005517          	auipc	a0,0x5
     cf4:	9d050513          	addi	a0,a0,-1584 # 56c0 <malloc+0x70e>
     cf8:	62f030ef          	jal	4b26 <open>
     cfc:	0c055463          	bgez	a0,dc4 <linktest+0x150>
  fd = open("lf2", 0);
     d00:	4581                	li	a1,0
     d02:	00005517          	auipc	a0,0x5
     d06:	9c650513          	addi	a0,a0,-1594 # 56c8 <malloc+0x716>
     d0a:	61d030ef          	jal	4b26 <open>
     d0e:	84aa                	mv	s1,a0
  if(fd < 0){
     d10:	0c054463          	bltz	a0,dd8 <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d14:	660d                	lui	a2,0x3
     d16:	0000c597          	auipc	a1,0xc
     d1a:	f6258593          	addi	a1,a1,-158 # cc78 <buf>
     d1e:	5e1030ef          	jal	4afe <read>
     d22:	4795                	li	a5,5
     d24:	0cf51463          	bne	a0,a5,dec <linktest+0x178>
  close(fd);
     d28:	8526                	mv	a0,s1
     d2a:	5e5030ef          	jal	4b0e <close>
  if(link("lf2", "lf2") >= 0){
     d2e:	00005597          	auipc	a1,0x5
     d32:	99a58593          	addi	a1,a1,-1638 # 56c8 <malloc+0x716>
     d36:	852e                	mv	a0,a1
     d38:	60f030ef          	jal	4b46 <link>
     d3c:	0c055263          	bgez	a0,e00 <linktest+0x18c>
  unlink("lf2");
     d40:	00005517          	auipc	a0,0x5
     d44:	98850513          	addi	a0,a0,-1656 # 56c8 <malloc+0x716>
     d48:	5ef030ef          	jal	4b36 <unlink>
  if(link("lf2", "lf1") >= 0){
     d4c:	00005597          	auipc	a1,0x5
     d50:	97458593          	addi	a1,a1,-1676 # 56c0 <malloc+0x70e>
     d54:	00005517          	auipc	a0,0x5
     d58:	97450513          	addi	a0,a0,-1676 # 56c8 <malloc+0x716>
     d5c:	5eb030ef          	jal	4b46 <link>
     d60:	0a055a63          	bgez	a0,e14 <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     d64:	00005597          	auipc	a1,0x5
     d68:	95c58593          	addi	a1,a1,-1700 # 56c0 <malloc+0x70e>
     d6c:	00005517          	auipc	a0,0x5
     d70:	a6450513          	addi	a0,a0,-1436 # 57d0 <malloc+0x81e>
     d74:	5d3030ef          	jal	4b46 <link>
     d78:	0a055863          	bgez	a0,e28 <linktest+0x1b4>
}
     d7c:	60e2                	ld	ra,24(sp)
     d7e:	6442                	ld	s0,16(sp)
     d80:	64a2                	ld	s1,8(sp)
     d82:	6902                	ld	s2,0(sp)
     d84:	6105                	addi	sp,sp,32
     d86:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     d88:	85ca                	mv	a1,s2
     d8a:	00005517          	auipc	a0,0x5
     d8e:	94650513          	addi	a0,a0,-1722 # 56d0 <malloc+0x71e>
     d92:	16c040ef          	jal	4efe <printf>
    exit(1);
     d96:	4505                	li	a0,1
     d98:	54f030ef          	jal	4ae6 <exit>
    printf("%s: write lf1 failed\n", s);
     d9c:	85ca                	mv	a1,s2
     d9e:	00005517          	auipc	a0,0x5
     da2:	94a50513          	addi	a0,a0,-1718 # 56e8 <malloc+0x736>
     da6:	158040ef          	jal	4efe <printf>
    exit(1);
     daa:	4505                	li	a0,1
     dac:	53b030ef          	jal	4ae6 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     db0:	85ca                	mv	a1,s2
     db2:	00005517          	auipc	a0,0x5
     db6:	94e50513          	addi	a0,a0,-1714 # 5700 <malloc+0x74e>
     dba:	144040ef          	jal	4efe <printf>
    exit(1);
     dbe:	4505                	li	a0,1
     dc0:	527030ef          	jal	4ae6 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     dc4:	85ca                	mv	a1,s2
     dc6:	00005517          	auipc	a0,0x5
     dca:	95a50513          	addi	a0,a0,-1702 # 5720 <malloc+0x76e>
     dce:	130040ef          	jal	4efe <printf>
    exit(1);
     dd2:	4505                	li	a0,1
     dd4:	513030ef          	jal	4ae6 <exit>
    printf("%s: open lf2 failed\n", s);
     dd8:	85ca                	mv	a1,s2
     dda:	00005517          	auipc	a0,0x5
     dde:	97650513          	addi	a0,a0,-1674 # 5750 <malloc+0x79e>
     de2:	11c040ef          	jal	4efe <printf>
    exit(1);
     de6:	4505                	li	a0,1
     de8:	4ff030ef          	jal	4ae6 <exit>
    printf("%s: read lf2 failed\n", s);
     dec:	85ca                	mv	a1,s2
     dee:	00005517          	auipc	a0,0x5
     df2:	97a50513          	addi	a0,a0,-1670 # 5768 <malloc+0x7b6>
     df6:	108040ef          	jal	4efe <printf>
    exit(1);
     dfa:	4505                	li	a0,1
     dfc:	4eb030ef          	jal	4ae6 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e00:	85ca                	mv	a1,s2
     e02:	00005517          	auipc	a0,0x5
     e06:	97e50513          	addi	a0,a0,-1666 # 5780 <malloc+0x7ce>
     e0a:	0f4040ef          	jal	4efe <printf>
    exit(1);
     e0e:	4505                	li	a0,1
     e10:	4d7030ef          	jal	4ae6 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e14:	85ca                	mv	a1,s2
     e16:	00005517          	auipc	a0,0x5
     e1a:	99250513          	addi	a0,a0,-1646 # 57a8 <malloc+0x7f6>
     e1e:	0e0040ef          	jal	4efe <printf>
    exit(1);
     e22:	4505                	li	a0,1
     e24:	4c3030ef          	jal	4ae6 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e28:	85ca                	mv	a1,s2
     e2a:	00005517          	auipc	a0,0x5
     e2e:	9ae50513          	addi	a0,a0,-1618 # 57d8 <malloc+0x826>
     e32:	0cc040ef          	jal	4efe <printf>
    exit(1);
     e36:	4505                	li	a0,1
     e38:	4af030ef          	jal	4ae6 <exit>

0000000000000e3c <validatetest>:
{
     e3c:	7139                	addi	sp,sp,-64
     e3e:	fc06                	sd	ra,56(sp)
     e40:	f822                	sd	s0,48(sp)
     e42:	f426                	sd	s1,40(sp)
     e44:	f04a                	sd	s2,32(sp)
     e46:	ec4e                	sd	s3,24(sp)
     e48:	e852                	sd	s4,16(sp)
     e4a:	e456                	sd	s5,8(sp)
     e4c:	e05a                	sd	s6,0(sp)
     e4e:	0080                	addi	s0,sp,64
     e50:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e52:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     e54:	00005997          	auipc	s3,0x5
     e58:	9a498993          	addi	s3,s3,-1628 # 57f8 <malloc+0x846>
     e5c:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e5e:	6a85                	lui	s5,0x1
     e60:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     e64:	85a6                	mv	a1,s1
     e66:	854e                	mv	a0,s3
     e68:	4df030ef          	jal	4b46 <link>
     e6c:	01251f63          	bne	a0,s2,e8a <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e70:	94d6                	add	s1,s1,s5
     e72:	ff4499e3          	bne	s1,s4,e64 <validatetest+0x28>
}
     e76:	70e2                	ld	ra,56(sp)
     e78:	7442                	ld	s0,48(sp)
     e7a:	74a2                	ld	s1,40(sp)
     e7c:	7902                	ld	s2,32(sp)
     e7e:	69e2                	ld	s3,24(sp)
     e80:	6a42                	ld	s4,16(sp)
     e82:	6aa2                	ld	s5,8(sp)
     e84:	6b02                	ld	s6,0(sp)
     e86:	6121                	addi	sp,sp,64
     e88:	8082                	ret
      printf("%s: link should not succeed\n", s);
     e8a:	85da                	mv	a1,s6
     e8c:	00005517          	auipc	a0,0x5
     e90:	97c50513          	addi	a0,a0,-1668 # 5808 <malloc+0x856>
     e94:	06a040ef          	jal	4efe <printf>
      exit(1);
     e98:	4505                	li	a0,1
     e9a:	44d030ef          	jal	4ae6 <exit>

0000000000000e9e <bigdir>:
{
     e9e:	715d                	addi	sp,sp,-80
     ea0:	e486                	sd	ra,72(sp)
     ea2:	e0a2                	sd	s0,64(sp)
     ea4:	fc26                	sd	s1,56(sp)
     ea6:	f84a                	sd	s2,48(sp)
     ea8:	f44e                	sd	s3,40(sp)
     eaa:	f052                	sd	s4,32(sp)
     eac:	ec56                	sd	s5,24(sp)
     eae:	e85a                	sd	s6,16(sp)
     eb0:	0880                	addi	s0,sp,80
     eb2:	89aa                	mv	s3,a0
  unlink("bd");
     eb4:	00005517          	auipc	a0,0x5
     eb8:	97450513          	addi	a0,a0,-1676 # 5828 <malloc+0x876>
     ebc:	47b030ef          	jal	4b36 <unlink>
  fd = open("bd", O_CREATE);
     ec0:	20000593          	li	a1,512
     ec4:	00005517          	auipc	a0,0x5
     ec8:	96450513          	addi	a0,a0,-1692 # 5828 <malloc+0x876>
     ecc:	45b030ef          	jal	4b26 <open>
  if(fd < 0){
     ed0:	0c054163          	bltz	a0,f92 <bigdir+0xf4>
  close(fd);
     ed4:	43b030ef          	jal	4b0e <close>
  for(i = 0; i < N; i++){
     ed8:	4901                	li	s2,0
    name[0] = 'x';
     eda:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     ede:	00005a17          	auipc	s4,0x5
     ee2:	94aa0a13          	addi	s4,s4,-1718 # 5828 <malloc+0x876>
  for(i = 0; i < N; i++){
     ee6:	1f400b13          	li	s6,500
    name[0] = 'x';
     eea:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     eee:	41f9571b          	sraiw	a4,s2,0x1f
     ef2:	01a7571b          	srliw	a4,a4,0x1a
     ef6:	012707bb          	addw	a5,a4,s2
     efa:	4067d69b          	sraiw	a3,a5,0x6
     efe:	0306869b          	addiw	a3,a3,48
     f02:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f06:	03f7f793          	andi	a5,a5,63
     f0a:	9f99                	subw	a5,a5,a4
     f0c:	0307879b          	addiw	a5,a5,48
     f10:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f14:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     f18:	fb040593          	addi	a1,s0,-80
     f1c:	8552                	mv	a0,s4
     f1e:	429030ef          	jal	4b46 <link>
     f22:	84aa                	mv	s1,a0
     f24:	e149                	bnez	a0,fa6 <bigdir+0x108>
  for(i = 0; i < N; i++){
     f26:	2905                	addiw	s2,s2,1
     f28:	fd6911e3          	bne	s2,s6,eea <bigdir+0x4c>
  unlink("bd");
     f2c:	00005517          	auipc	a0,0x5
     f30:	8fc50513          	addi	a0,a0,-1796 # 5828 <malloc+0x876>
     f34:	403030ef          	jal	4b36 <unlink>
    name[0] = 'x';
     f38:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
     f3c:	1f400a13          	li	s4,500
    name[0] = 'x';
     f40:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
     f44:	41f4d71b          	sraiw	a4,s1,0x1f
     f48:	01a7571b          	srliw	a4,a4,0x1a
     f4c:	009707bb          	addw	a5,a4,s1
     f50:	4067d69b          	sraiw	a3,a5,0x6
     f54:	0306869b          	addiw	a3,a3,48
     f58:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f5c:	03f7f793          	andi	a5,a5,63
     f60:	9f99                	subw	a5,a5,a4
     f62:	0307879b          	addiw	a5,a5,48
     f66:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f6a:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
     f6e:	fb040513          	addi	a0,s0,-80
     f72:	3c5030ef          	jal	4b36 <unlink>
     f76:	e529                	bnez	a0,fc0 <bigdir+0x122>
  for(i = 0; i < N; i++){
     f78:	2485                	addiw	s1,s1,1
     f7a:	fd4493e3          	bne	s1,s4,f40 <bigdir+0xa2>
}
     f7e:	60a6                	ld	ra,72(sp)
     f80:	6406                	ld	s0,64(sp)
     f82:	74e2                	ld	s1,56(sp)
     f84:	7942                	ld	s2,48(sp)
     f86:	79a2                	ld	s3,40(sp)
     f88:	7a02                	ld	s4,32(sp)
     f8a:	6ae2                	ld	s5,24(sp)
     f8c:	6b42                	ld	s6,16(sp)
     f8e:	6161                	addi	sp,sp,80
     f90:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     f92:	85ce                	mv	a1,s3
     f94:	00005517          	auipc	a0,0x5
     f98:	89c50513          	addi	a0,a0,-1892 # 5830 <malloc+0x87e>
     f9c:	763030ef          	jal	4efe <printf>
    exit(1);
     fa0:	4505                	li	a0,1
     fa2:	345030ef          	jal	4ae6 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
     fa6:	fb040693          	addi	a3,s0,-80
     faa:	864a                	mv	a2,s2
     fac:	85ce                	mv	a1,s3
     fae:	00005517          	auipc	a0,0x5
     fb2:	8a250513          	addi	a0,a0,-1886 # 5850 <malloc+0x89e>
     fb6:	749030ef          	jal	4efe <printf>
      exit(1);
     fba:	4505                	li	a0,1
     fbc:	32b030ef          	jal	4ae6 <exit>
      printf("%s: bigdir unlink failed", s);
     fc0:	85ce                	mv	a1,s3
     fc2:	00005517          	auipc	a0,0x5
     fc6:	8b650513          	addi	a0,a0,-1866 # 5878 <malloc+0x8c6>
     fca:	735030ef          	jal	4efe <printf>
      exit(1);
     fce:	4505                	li	a0,1
     fd0:	317030ef          	jal	4ae6 <exit>

0000000000000fd4 <pgbug>:
{
     fd4:	7179                	addi	sp,sp,-48
     fd6:	f406                	sd	ra,40(sp)
     fd8:	f022                	sd	s0,32(sp)
     fda:	ec26                	sd	s1,24(sp)
     fdc:	1800                	addi	s0,sp,48
  argv[0] = 0;
     fde:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
     fe2:	00008497          	auipc	s1,0x8
     fe6:	01e48493          	addi	s1,s1,30 # 9000 <big>
     fea:	fd840593          	addi	a1,s0,-40
     fee:	6088                	ld	a0,0(s1)
     ff0:	32f030ef          	jal	4b1e <exec>
  pipe(big);
     ff4:	6088                	ld	a0,0(s1)
     ff6:	301030ef          	jal	4af6 <pipe>
  exit(0);
     ffa:	4501                	li	a0,0
     ffc:	2eb030ef          	jal	4ae6 <exit>

0000000000001000 <badarg>:
{
    1000:	7139                	addi	sp,sp,-64
    1002:	fc06                	sd	ra,56(sp)
    1004:	f822                	sd	s0,48(sp)
    1006:	f426                	sd	s1,40(sp)
    1008:	f04a                	sd	s2,32(sp)
    100a:	ec4e                	sd	s3,24(sp)
    100c:	0080                	addi	s0,sp,64
    100e:	64b1                	lui	s1,0xc
    1010:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    1014:	597d                	li	s2,-1
    1016:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    101a:	00004997          	auipc	s3,0x4
    101e:	0ce98993          	addi	s3,s3,206 # 50e8 <malloc+0x136>
    argv[0] = (char*)0xffffffff;
    1022:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1026:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    102a:	fc040593          	addi	a1,s0,-64
    102e:	854e                	mv	a0,s3
    1030:	2ef030ef          	jal	4b1e <exec>
  for(int i = 0; i < 50000; i++){
    1034:	34fd                	addiw	s1,s1,-1
    1036:	f4f5                	bnez	s1,1022 <badarg+0x22>
  exit(0);
    1038:	4501                	li	a0,0
    103a:	2ad030ef          	jal	4ae6 <exit>

000000000000103e <copyinstr2>:
{
    103e:	7155                	addi	sp,sp,-208
    1040:	e586                	sd	ra,200(sp)
    1042:	e1a2                	sd	s0,192(sp)
    1044:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1046:	f6840793          	addi	a5,s0,-152
    104a:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    104e:	07800713          	li	a4,120
    1052:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1056:	0785                	addi	a5,a5,1
    1058:	fed79de3          	bne	a5,a3,1052 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    105c:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1060:	f6840513          	addi	a0,s0,-152
    1064:	2d3030ef          	jal	4b36 <unlink>
  if(ret != -1){
    1068:	57fd                	li	a5,-1
    106a:	0cf51263          	bne	a0,a5,112e <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    106e:	20100593          	li	a1,513
    1072:	f6840513          	addi	a0,s0,-152
    1076:	2b1030ef          	jal	4b26 <open>
  if(fd != -1){
    107a:	57fd                	li	a5,-1
    107c:	0cf51563          	bne	a0,a5,1146 <copyinstr2+0x108>
  ret = link(b, b);
    1080:	f6840593          	addi	a1,s0,-152
    1084:	852e                	mv	a0,a1
    1086:	2c1030ef          	jal	4b46 <link>
  if(ret != -1){
    108a:	57fd                	li	a5,-1
    108c:	0cf51963          	bne	a0,a5,115e <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    1090:	00006797          	auipc	a5,0x6
    1094:	93878793          	addi	a5,a5,-1736 # 69c8 <malloc+0x1a16>
    1098:	f4f43c23          	sd	a5,-168(s0)
    109c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    10a0:	f5840593          	addi	a1,s0,-168
    10a4:	f6840513          	addi	a0,s0,-152
    10a8:	277030ef          	jal	4b1e <exec>
  if(ret != -1){
    10ac:	57fd                	li	a5,-1
    10ae:	0cf51563          	bne	a0,a5,1178 <copyinstr2+0x13a>
  int pid = fork();
    10b2:	22d030ef          	jal	4ade <fork>
  if(pid < 0){
    10b6:	0c054d63          	bltz	a0,1190 <copyinstr2+0x152>
  if(pid == 0){
    10ba:	0e051863          	bnez	a0,11aa <copyinstr2+0x16c>
    10be:	00008797          	auipc	a5,0x8
    10c2:	4a278793          	addi	a5,a5,1186 # 9560 <big.0>
    10c6:	00009697          	auipc	a3,0x9
    10ca:	49a68693          	addi	a3,a3,1178 # a560 <big.0+0x1000>
      big[i] = 'x';
    10ce:	07800713          	li	a4,120
    10d2:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    10d6:	0785                	addi	a5,a5,1
    10d8:	fed79de3          	bne	a5,a3,10d2 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    10dc:	00009797          	auipc	a5,0x9
    10e0:	48078223          	sb	zero,1156(a5) # a560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    10e4:	00006797          	auipc	a5,0x6
    10e8:	36478793          	addi	a5,a5,868 # 7448 <malloc+0x2496>
    10ec:	6fb0                	ld	a2,88(a5)
    10ee:	73b4                	ld	a3,96(a5)
    10f0:	77b8                	ld	a4,104(a5)
    10f2:	7bbc                	ld	a5,112(a5)
    10f4:	f2c43823          	sd	a2,-208(s0)
    10f8:	f2d43c23          	sd	a3,-200(s0)
    10fc:	f4e43023          	sd	a4,-192(s0)
    1100:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1104:	f3040593          	addi	a1,s0,-208
    1108:	00004517          	auipc	a0,0x4
    110c:	fe050513          	addi	a0,a0,-32 # 50e8 <malloc+0x136>
    1110:	20f030ef          	jal	4b1e <exec>
    if(ret != -1){
    1114:	57fd                	li	a5,-1
    1116:	08f50663          	beq	a0,a5,11a2 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    111a:	55fd                	li	a1,-1
    111c:	00005517          	auipc	a0,0x5
    1120:	80450513          	addi	a0,a0,-2044 # 5920 <malloc+0x96e>
    1124:	5db030ef          	jal	4efe <printf>
      exit(1);
    1128:	4505                	li	a0,1
    112a:	1bd030ef          	jal	4ae6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    112e:	862a                	mv	a2,a0
    1130:	f6840593          	addi	a1,s0,-152
    1134:	00004517          	auipc	a0,0x4
    1138:	76450513          	addi	a0,a0,1892 # 5898 <malloc+0x8e6>
    113c:	5c3030ef          	jal	4efe <printf>
    exit(1);
    1140:	4505                	li	a0,1
    1142:	1a5030ef          	jal	4ae6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1146:	862a                	mv	a2,a0
    1148:	f6840593          	addi	a1,s0,-152
    114c:	00004517          	auipc	a0,0x4
    1150:	76c50513          	addi	a0,a0,1900 # 58b8 <malloc+0x906>
    1154:	5ab030ef          	jal	4efe <printf>
    exit(1);
    1158:	4505                	li	a0,1
    115a:	18d030ef          	jal	4ae6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    115e:	86aa                	mv	a3,a0
    1160:	f6840613          	addi	a2,s0,-152
    1164:	85b2                	mv	a1,a2
    1166:	00004517          	auipc	a0,0x4
    116a:	77250513          	addi	a0,a0,1906 # 58d8 <malloc+0x926>
    116e:	591030ef          	jal	4efe <printf>
    exit(1);
    1172:	4505                	li	a0,1
    1174:	173030ef          	jal	4ae6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1178:	567d                	li	a2,-1
    117a:	f6840593          	addi	a1,s0,-152
    117e:	00004517          	auipc	a0,0x4
    1182:	78250513          	addi	a0,a0,1922 # 5900 <malloc+0x94e>
    1186:	579030ef          	jal	4efe <printf>
    exit(1);
    118a:	4505                	li	a0,1
    118c:	15b030ef          	jal	4ae6 <exit>
    printf("fork failed\n");
    1190:	00006517          	auipc	a0,0x6
    1194:	d5850513          	addi	a0,a0,-680 # 6ee8 <malloc+0x1f36>
    1198:	567030ef          	jal	4efe <printf>
    exit(1);
    119c:	4505                	li	a0,1
    119e:	149030ef          	jal	4ae6 <exit>
    exit(747); // OK
    11a2:	2eb00513          	li	a0,747
    11a6:	141030ef          	jal	4ae6 <exit>
  int st = 0;
    11aa:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    11ae:	f5440513          	addi	a0,s0,-172
    11b2:	13d030ef          	jal	4aee <wait>
  if(st != 747){
    11b6:	f5442703          	lw	a4,-172(s0)
    11ba:	2eb00793          	li	a5,747
    11be:	00f71663          	bne	a4,a5,11ca <copyinstr2+0x18c>
}
    11c2:	60ae                	ld	ra,200(sp)
    11c4:	640e                	ld	s0,192(sp)
    11c6:	6169                	addi	sp,sp,208
    11c8:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    11ca:	00004517          	auipc	a0,0x4
    11ce:	77e50513          	addi	a0,a0,1918 # 5948 <malloc+0x996>
    11d2:	52d030ef          	jal	4efe <printf>
    exit(1);
    11d6:	4505                	li	a0,1
    11d8:	10f030ef          	jal	4ae6 <exit>

00000000000011dc <truncate3>:
{
    11dc:	7159                	addi	sp,sp,-112
    11de:	f486                	sd	ra,104(sp)
    11e0:	f0a2                	sd	s0,96(sp)
    11e2:	e8ca                	sd	s2,80(sp)
    11e4:	1880                	addi	s0,sp,112
    11e6:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    11e8:	60100593          	li	a1,1537
    11ec:	00004517          	auipc	a0,0x4
    11f0:	f5450513          	addi	a0,a0,-172 # 5140 <malloc+0x18e>
    11f4:	133030ef          	jal	4b26 <open>
    11f8:	117030ef          	jal	4b0e <close>
  pid = fork();
    11fc:	0e3030ef          	jal	4ade <fork>
  if(pid < 0){
    1200:	06054663          	bltz	a0,126c <truncate3+0x90>
  if(pid == 0){
    1204:	e55d                	bnez	a0,12b2 <truncate3+0xd6>
    1206:	eca6                	sd	s1,88(sp)
    1208:	e4ce                	sd	s3,72(sp)
    120a:	e0d2                	sd	s4,64(sp)
    120c:	fc56                	sd	s5,56(sp)
    120e:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1212:	00004a17          	auipc	s4,0x4
    1216:	f2ea0a13          	addi	s4,s4,-210 # 5140 <malloc+0x18e>
      int n = write(fd, "1234567890", 10);
    121a:	00004a97          	auipc	s5,0x4
    121e:	78ea8a93          	addi	s5,s5,1934 # 59a8 <malloc+0x9f6>
      int fd = open("truncfile", O_WRONLY);
    1222:	4585                	li	a1,1
    1224:	8552                	mv	a0,s4
    1226:	101030ef          	jal	4b26 <open>
    122a:	84aa                	mv	s1,a0
      if(fd < 0){
    122c:	04054e63          	bltz	a0,1288 <truncate3+0xac>
      int n = write(fd, "1234567890", 10);
    1230:	4629                	li	a2,10
    1232:	85d6                	mv	a1,s5
    1234:	0d3030ef          	jal	4b06 <write>
      if(n != 10){
    1238:	47a9                	li	a5,10
    123a:	06f51163          	bne	a0,a5,129c <truncate3+0xc0>
      close(fd);
    123e:	8526                	mv	a0,s1
    1240:	0cf030ef          	jal	4b0e <close>
      fd = open("truncfile", O_RDONLY);
    1244:	4581                	li	a1,0
    1246:	8552                	mv	a0,s4
    1248:	0df030ef          	jal	4b26 <open>
    124c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    124e:	02000613          	li	a2,32
    1252:	f9840593          	addi	a1,s0,-104
    1256:	0a9030ef          	jal	4afe <read>
      close(fd);
    125a:	8526                	mv	a0,s1
    125c:	0b3030ef          	jal	4b0e <close>
    for(int i = 0; i < 100; i++){
    1260:	39fd                	addiw	s3,s3,-1
    1262:	fc0990e3          	bnez	s3,1222 <truncate3+0x46>
    exit(0);
    1266:	4501                	li	a0,0
    1268:	07f030ef          	jal	4ae6 <exit>
    126c:	eca6                	sd	s1,88(sp)
    126e:	e4ce                	sd	s3,72(sp)
    1270:	e0d2                	sd	s4,64(sp)
    1272:	fc56                	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    1274:	85ca                	mv	a1,s2
    1276:	00004517          	auipc	a0,0x4
    127a:	70250513          	addi	a0,a0,1794 # 5978 <malloc+0x9c6>
    127e:	481030ef          	jal	4efe <printf>
    exit(1);
    1282:	4505                	li	a0,1
    1284:	063030ef          	jal	4ae6 <exit>
        printf("%s: open failed\n", s);
    1288:	85ca                	mv	a1,s2
    128a:	00004517          	auipc	a0,0x4
    128e:	70650513          	addi	a0,a0,1798 # 5990 <malloc+0x9de>
    1292:	46d030ef          	jal	4efe <printf>
        exit(1);
    1296:	4505                	li	a0,1
    1298:	04f030ef          	jal	4ae6 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    129c:	862a                	mv	a2,a0
    129e:	85ca                	mv	a1,s2
    12a0:	00004517          	auipc	a0,0x4
    12a4:	71850513          	addi	a0,a0,1816 # 59b8 <malloc+0xa06>
    12a8:	457030ef          	jal	4efe <printf>
        exit(1);
    12ac:	4505                	li	a0,1
    12ae:	039030ef          	jal	4ae6 <exit>
    12b2:	eca6                	sd	s1,88(sp)
    12b4:	e4ce                	sd	s3,72(sp)
    12b6:	e0d2                	sd	s4,64(sp)
    12b8:	fc56                	sd	s5,56(sp)
    12ba:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12be:	00004a17          	auipc	s4,0x4
    12c2:	e82a0a13          	addi	s4,s4,-382 # 5140 <malloc+0x18e>
    int n = write(fd, "xxx", 3);
    12c6:	00004a97          	auipc	s5,0x4
    12ca:	712a8a93          	addi	s5,s5,1810 # 59d8 <malloc+0xa26>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12ce:	60100593          	li	a1,1537
    12d2:	8552                	mv	a0,s4
    12d4:	053030ef          	jal	4b26 <open>
    12d8:	84aa                	mv	s1,a0
    if(fd < 0){
    12da:	02054d63          	bltz	a0,1314 <truncate3+0x138>
    int n = write(fd, "xxx", 3);
    12de:	460d                	li	a2,3
    12e0:	85d6                	mv	a1,s5
    12e2:	025030ef          	jal	4b06 <write>
    if(n != 3){
    12e6:	478d                	li	a5,3
    12e8:	04f51063          	bne	a0,a5,1328 <truncate3+0x14c>
    close(fd);
    12ec:	8526                	mv	a0,s1
    12ee:	021030ef          	jal	4b0e <close>
  for(int i = 0; i < 150; i++){
    12f2:	39fd                	addiw	s3,s3,-1
    12f4:	fc099de3          	bnez	s3,12ce <truncate3+0xf2>
  wait(&xstatus);
    12f8:	fbc40513          	addi	a0,s0,-68
    12fc:	7f2030ef          	jal	4aee <wait>
  unlink("truncfile");
    1300:	00004517          	auipc	a0,0x4
    1304:	e4050513          	addi	a0,a0,-448 # 5140 <malloc+0x18e>
    1308:	02f030ef          	jal	4b36 <unlink>
  exit(xstatus);
    130c:	fbc42503          	lw	a0,-68(s0)
    1310:	7d6030ef          	jal	4ae6 <exit>
      printf("%s: open failed\n", s);
    1314:	85ca                	mv	a1,s2
    1316:	00004517          	auipc	a0,0x4
    131a:	67a50513          	addi	a0,a0,1658 # 5990 <malloc+0x9de>
    131e:	3e1030ef          	jal	4efe <printf>
      exit(1);
    1322:	4505                	li	a0,1
    1324:	7c2030ef          	jal	4ae6 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1328:	862a                	mv	a2,a0
    132a:	85ca                	mv	a1,s2
    132c:	00004517          	auipc	a0,0x4
    1330:	6b450513          	addi	a0,a0,1716 # 59e0 <malloc+0xa2e>
    1334:	3cb030ef          	jal	4efe <printf>
      exit(1);
    1338:	4505                	li	a0,1
    133a:	7ac030ef          	jal	4ae6 <exit>

000000000000133e <exectest>:
{
    133e:	715d                	addi	sp,sp,-80
    1340:	e486                	sd	ra,72(sp)
    1342:	e0a2                	sd	s0,64(sp)
    1344:	f84a                	sd	s2,48(sp)
    1346:	0880                	addi	s0,sp,80
    1348:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    134a:	00004797          	auipc	a5,0x4
    134e:	d9e78793          	addi	a5,a5,-610 # 50e8 <malloc+0x136>
    1352:	fcf43023          	sd	a5,-64(s0)
    1356:	00004797          	auipc	a5,0x4
    135a:	6aa78793          	addi	a5,a5,1706 # 5a00 <malloc+0xa4e>
    135e:	fcf43423          	sd	a5,-56(s0)
    1362:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1366:	00004517          	auipc	a0,0x4
    136a:	6a250513          	addi	a0,a0,1698 # 5a08 <malloc+0xa56>
    136e:	7c8030ef          	jal	4b36 <unlink>
  pid = fork();
    1372:	76c030ef          	jal	4ade <fork>
  if(pid < 0) {
    1376:	02054f63          	bltz	a0,13b4 <exectest+0x76>
    137a:	fc26                	sd	s1,56(sp)
    137c:	84aa                	mv	s1,a0
  if(pid == 0) {
    137e:	e935                	bnez	a0,13f2 <exectest+0xb4>
    close(1);
    1380:	4505                	li	a0,1
    1382:	78c030ef          	jal	4b0e <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1386:	20100593          	li	a1,513
    138a:	00004517          	auipc	a0,0x4
    138e:	67e50513          	addi	a0,a0,1662 # 5a08 <malloc+0xa56>
    1392:	794030ef          	jal	4b26 <open>
    if(fd < 0) {
    1396:	02054a63          	bltz	a0,13ca <exectest+0x8c>
    if(fd != 1) {
    139a:	4785                	li	a5,1
    139c:	04f50163          	beq	a0,a5,13de <exectest+0xa0>
      printf("%s: wrong fd\n", s);
    13a0:	85ca                	mv	a1,s2
    13a2:	00004517          	auipc	a0,0x4
    13a6:	68650513          	addi	a0,a0,1670 # 5a28 <malloc+0xa76>
    13aa:	355030ef          	jal	4efe <printf>
      exit(1);
    13ae:	4505                	li	a0,1
    13b0:	736030ef          	jal	4ae6 <exit>
    13b4:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    13b6:	85ca                	mv	a1,s2
    13b8:	00004517          	auipc	a0,0x4
    13bc:	5c050513          	addi	a0,a0,1472 # 5978 <malloc+0x9c6>
    13c0:	33f030ef          	jal	4efe <printf>
     exit(1);
    13c4:	4505                	li	a0,1
    13c6:	720030ef          	jal	4ae6 <exit>
      printf("%s: create failed\n", s);
    13ca:	85ca                	mv	a1,s2
    13cc:	00004517          	auipc	a0,0x4
    13d0:	64450513          	addi	a0,a0,1604 # 5a10 <malloc+0xa5e>
    13d4:	32b030ef          	jal	4efe <printf>
      exit(1);
    13d8:	4505                	li	a0,1
    13da:	70c030ef          	jal	4ae6 <exit>
    if(exec("echo", echoargv) < 0){
    13de:	fc040593          	addi	a1,s0,-64
    13e2:	00004517          	auipc	a0,0x4
    13e6:	d0650513          	addi	a0,a0,-762 # 50e8 <malloc+0x136>
    13ea:	734030ef          	jal	4b1e <exec>
    13ee:	00054d63          	bltz	a0,1408 <exectest+0xca>
  if (wait(&xstatus) != pid) {
    13f2:	fdc40513          	addi	a0,s0,-36
    13f6:	6f8030ef          	jal	4aee <wait>
    13fa:	02951163          	bne	a0,s1,141c <exectest+0xde>
  if(xstatus != 0)
    13fe:	fdc42503          	lw	a0,-36(s0)
    1402:	c50d                	beqz	a0,142c <exectest+0xee>
    exit(xstatus);
    1404:	6e2030ef          	jal	4ae6 <exit>
      printf("%s: exec echo failed\n", s);
    1408:	85ca                	mv	a1,s2
    140a:	00004517          	auipc	a0,0x4
    140e:	62e50513          	addi	a0,a0,1582 # 5a38 <malloc+0xa86>
    1412:	2ed030ef          	jal	4efe <printf>
      exit(1);
    1416:	4505                	li	a0,1
    1418:	6ce030ef          	jal	4ae6 <exit>
    printf("%s: wait failed!\n", s);
    141c:	85ca                	mv	a1,s2
    141e:	00004517          	auipc	a0,0x4
    1422:	63250513          	addi	a0,a0,1586 # 5a50 <malloc+0xa9e>
    1426:	2d9030ef          	jal	4efe <printf>
    142a:	bfd1                	j	13fe <exectest+0xc0>
  fd = open("echo-ok", O_RDONLY);
    142c:	4581                	li	a1,0
    142e:	00004517          	auipc	a0,0x4
    1432:	5da50513          	addi	a0,a0,1498 # 5a08 <malloc+0xa56>
    1436:	6f0030ef          	jal	4b26 <open>
  if(fd < 0) {
    143a:	02054463          	bltz	a0,1462 <exectest+0x124>
  if (read(fd, buf, 2) != 2) {
    143e:	4609                	li	a2,2
    1440:	fb840593          	addi	a1,s0,-72
    1444:	6ba030ef          	jal	4afe <read>
    1448:	4789                	li	a5,2
    144a:	02f50663          	beq	a0,a5,1476 <exectest+0x138>
    printf("%s: read failed\n", s);
    144e:	85ca                	mv	a1,s2
    1450:	00004517          	auipc	a0,0x4
    1454:	06850513          	addi	a0,a0,104 # 54b8 <malloc+0x506>
    1458:	2a7030ef          	jal	4efe <printf>
    exit(1);
    145c:	4505                	li	a0,1
    145e:	688030ef          	jal	4ae6 <exit>
    printf("%s: open failed\n", s);
    1462:	85ca                	mv	a1,s2
    1464:	00004517          	auipc	a0,0x4
    1468:	52c50513          	addi	a0,a0,1324 # 5990 <malloc+0x9de>
    146c:	293030ef          	jal	4efe <printf>
    exit(1);
    1470:	4505                	li	a0,1
    1472:	674030ef          	jal	4ae6 <exit>
  unlink("echo-ok");
    1476:	00004517          	auipc	a0,0x4
    147a:	59250513          	addi	a0,a0,1426 # 5a08 <malloc+0xa56>
    147e:	6b8030ef          	jal	4b36 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1482:	fb844703          	lbu	a4,-72(s0)
    1486:	04f00793          	li	a5,79
    148a:	00f71863          	bne	a4,a5,149a <exectest+0x15c>
    148e:	fb944703          	lbu	a4,-71(s0)
    1492:	04b00793          	li	a5,75
    1496:	00f70c63          	beq	a4,a5,14ae <exectest+0x170>
    printf("%s: wrong output\n", s);
    149a:	85ca                	mv	a1,s2
    149c:	00004517          	auipc	a0,0x4
    14a0:	5cc50513          	addi	a0,a0,1484 # 5a68 <malloc+0xab6>
    14a4:	25b030ef          	jal	4efe <printf>
    exit(1);
    14a8:	4505                	li	a0,1
    14aa:	63c030ef          	jal	4ae6 <exit>
    exit(0);
    14ae:	4501                	li	a0,0
    14b0:	636030ef          	jal	4ae6 <exit>

00000000000014b4 <pipe1>:
{
    14b4:	711d                	addi	sp,sp,-96
    14b6:	ec86                	sd	ra,88(sp)
    14b8:	e8a2                	sd	s0,80(sp)
    14ba:	fc4e                	sd	s3,56(sp)
    14bc:	1080                	addi	s0,sp,96
    14be:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    14c0:	fa840513          	addi	a0,s0,-88
    14c4:	632030ef          	jal	4af6 <pipe>
    14c8:	e92d                	bnez	a0,153a <pipe1+0x86>
    14ca:	e4a6                	sd	s1,72(sp)
    14cc:	f852                	sd	s4,48(sp)
    14ce:	84aa                	mv	s1,a0
  pid = fork();
    14d0:	60e030ef          	jal	4ade <fork>
    14d4:	8a2a                	mv	s4,a0
  if(pid == 0){
    14d6:	c151                	beqz	a0,155a <pipe1+0xa6>
  } else if(pid > 0){
    14d8:	14a05e63          	blez	a0,1634 <pipe1+0x180>
    14dc:	e0ca                	sd	s2,64(sp)
    14de:	f456                	sd	s5,40(sp)
    close(fds[1]);
    14e0:	fac42503          	lw	a0,-84(s0)
    14e4:	62a030ef          	jal	4b0e <close>
    total = 0;
    14e8:	8a26                	mv	s4,s1
    cc = 1;
    14ea:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    14ec:	0000ba97          	auipc	s5,0xb
    14f0:	78ca8a93          	addi	s5,s5,1932 # cc78 <buf>
    14f4:	864a                	mv	a2,s2
    14f6:	85d6                	mv	a1,s5
    14f8:	fa842503          	lw	a0,-88(s0)
    14fc:	602030ef          	jal	4afe <read>
    1500:	0ea05a63          	blez	a0,15f4 <pipe1+0x140>
      for(i = 0; i < n; i++){
    1504:	0000b717          	auipc	a4,0xb
    1508:	77470713          	addi	a4,a4,1908 # cc78 <buf>
    150c:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1510:	00074683          	lbu	a3,0(a4)
    1514:	0ff4f793          	zext.b	a5,s1
    1518:	2485                	addiw	s1,s1,1
    151a:	0af69d63          	bne	a3,a5,15d4 <pipe1+0x120>
      for(i = 0; i < n; i++){
    151e:	0705                	addi	a4,a4,1
    1520:	fec498e3          	bne	s1,a2,1510 <pipe1+0x5c>
      total += n;
    1524:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    1528:	0019179b          	slliw	a5,s2,0x1
    152c:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
    1530:	670d                	lui	a4,0x3
    1532:	fd2771e3          	bgeu	a4,s2,14f4 <pipe1+0x40>
        cc = sizeof(buf);
    1536:	690d                	lui	s2,0x3
    1538:	bf75                	j	14f4 <pipe1+0x40>
    153a:	e4a6                	sd	s1,72(sp)
    153c:	e0ca                	sd	s2,64(sp)
    153e:	f852                	sd	s4,48(sp)
    1540:	f456                	sd	s5,40(sp)
    1542:	f05a                	sd	s6,32(sp)
    1544:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    1546:	85ce                	mv	a1,s3
    1548:	00004517          	auipc	a0,0x4
    154c:	53850513          	addi	a0,a0,1336 # 5a80 <malloc+0xace>
    1550:	1af030ef          	jal	4efe <printf>
    exit(1);
    1554:	4505                	li	a0,1
    1556:	590030ef          	jal	4ae6 <exit>
    155a:	e0ca                	sd	s2,64(sp)
    155c:	f456                	sd	s5,40(sp)
    155e:	f05a                	sd	s6,32(sp)
    1560:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1562:	fa842503          	lw	a0,-88(s0)
    1566:	5a8030ef          	jal	4b0e <close>
    for(n = 0; n < N; n++){
    156a:	0000bb17          	auipc	s6,0xb
    156e:	70eb0b13          	addi	s6,s6,1806 # cc78 <buf>
    1572:	416004bb          	negw	s1,s6
    1576:	0ff4f493          	zext.b	s1,s1
    157a:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    157e:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1580:	6a85                	lui	s5,0x1
    1582:	42da8a93          	addi	s5,s5,1069 # 142d <exectest+0xef>
{
    1586:	87da                	mv	a5,s6
        buf[i] = seq++;
    1588:	0097873b          	addw	a4,a5,s1
    158c:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1590:	0785                	addi	a5,a5,1
    1592:	ff279be3          	bne	a5,s2,1588 <pipe1+0xd4>
    1596:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    159a:	40900613          	li	a2,1033
    159e:	85de                	mv	a1,s7
    15a0:	fac42503          	lw	a0,-84(s0)
    15a4:	562030ef          	jal	4b06 <write>
    15a8:	40900793          	li	a5,1033
    15ac:	00f51a63          	bne	a0,a5,15c0 <pipe1+0x10c>
    for(n = 0; n < N; n++){
    15b0:	24a5                	addiw	s1,s1,9
    15b2:	0ff4f493          	zext.b	s1,s1
    15b6:	fd5a18e3          	bne	s4,s5,1586 <pipe1+0xd2>
    exit(0);
    15ba:	4501                	li	a0,0
    15bc:	52a030ef          	jal	4ae6 <exit>
        printf("%s: pipe1 oops 1\n", s);
    15c0:	85ce                	mv	a1,s3
    15c2:	00004517          	auipc	a0,0x4
    15c6:	4d650513          	addi	a0,a0,1238 # 5a98 <malloc+0xae6>
    15ca:	135030ef          	jal	4efe <printf>
        exit(1);
    15ce:	4505                	li	a0,1
    15d0:	516030ef          	jal	4ae6 <exit>
          printf("%s: pipe1 oops 2\n", s);
    15d4:	85ce                	mv	a1,s3
    15d6:	00004517          	auipc	a0,0x4
    15da:	4da50513          	addi	a0,a0,1242 # 5ab0 <malloc+0xafe>
    15de:	121030ef          	jal	4efe <printf>
          return;
    15e2:	64a6                	ld	s1,72(sp)
    15e4:	6906                	ld	s2,64(sp)
    15e6:	7a42                	ld	s4,48(sp)
    15e8:	7aa2                	ld	s5,40(sp)
}
    15ea:	60e6                	ld	ra,88(sp)
    15ec:	6446                	ld	s0,80(sp)
    15ee:	79e2                	ld	s3,56(sp)
    15f0:	6125                	addi	sp,sp,96
    15f2:	8082                	ret
    if(total != N * SZ){
    15f4:	6785                	lui	a5,0x1
    15f6:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0xef>
    15fa:	00fa0f63          	beq	s4,a5,1618 <pipe1+0x164>
    15fe:	f05a                	sd	s6,32(sp)
    1600:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1602:	8652                	mv	a2,s4
    1604:	85ce                	mv	a1,s3
    1606:	00004517          	auipc	a0,0x4
    160a:	4c250513          	addi	a0,a0,1218 # 5ac8 <malloc+0xb16>
    160e:	0f1030ef          	jal	4efe <printf>
      exit(1);
    1612:	4505                	li	a0,1
    1614:	4d2030ef          	jal	4ae6 <exit>
    1618:	f05a                	sd	s6,32(sp)
    161a:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    161c:	fa842503          	lw	a0,-88(s0)
    1620:	4ee030ef          	jal	4b0e <close>
    wait(&xstatus);
    1624:	fa440513          	addi	a0,s0,-92
    1628:	4c6030ef          	jal	4aee <wait>
    exit(xstatus);
    162c:	fa442503          	lw	a0,-92(s0)
    1630:	4b6030ef          	jal	4ae6 <exit>
    1634:	e0ca                	sd	s2,64(sp)
    1636:	f456                	sd	s5,40(sp)
    1638:	f05a                	sd	s6,32(sp)
    163a:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    163c:	85ce                	mv	a1,s3
    163e:	00004517          	auipc	a0,0x4
    1642:	4aa50513          	addi	a0,a0,1194 # 5ae8 <malloc+0xb36>
    1646:	0b9030ef          	jal	4efe <printf>
    exit(1);
    164a:	4505                	li	a0,1
    164c:	49a030ef          	jal	4ae6 <exit>

0000000000001650 <exitwait>:
{
    1650:	7139                	addi	sp,sp,-64
    1652:	fc06                	sd	ra,56(sp)
    1654:	f822                	sd	s0,48(sp)
    1656:	f426                	sd	s1,40(sp)
    1658:	f04a                	sd	s2,32(sp)
    165a:	ec4e                	sd	s3,24(sp)
    165c:	e852                	sd	s4,16(sp)
    165e:	0080                	addi	s0,sp,64
    1660:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1662:	4901                	li	s2,0
    1664:	06400993          	li	s3,100
    pid = fork();
    1668:	476030ef          	jal	4ade <fork>
    166c:	84aa                	mv	s1,a0
    if(pid < 0){
    166e:	02054863          	bltz	a0,169e <exitwait+0x4e>
    if(pid){
    1672:	c525                	beqz	a0,16da <exitwait+0x8a>
      if(wait(&xstate) != pid){
    1674:	fcc40513          	addi	a0,s0,-52
    1678:	476030ef          	jal	4aee <wait>
    167c:	02951b63          	bne	a0,s1,16b2 <exitwait+0x62>
      if(i != xstate) {
    1680:	fcc42783          	lw	a5,-52(s0)
    1684:	05279163          	bne	a5,s2,16c6 <exitwait+0x76>
  for(i = 0; i < 100; i++){
    1688:	2905                	addiw	s2,s2,1 # 3001 <subdir+0x425>
    168a:	fd391fe3          	bne	s2,s3,1668 <exitwait+0x18>
}
    168e:	70e2                	ld	ra,56(sp)
    1690:	7442                	ld	s0,48(sp)
    1692:	74a2                	ld	s1,40(sp)
    1694:	7902                	ld	s2,32(sp)
    1696:	69e2                	ld	s3,24(sp)
    1698:	6a42                	ld	s4,16(sp)
    169a:	6121                	addi	sp,sp,64
    169c:	8082                	ret
      printf("%s: fork failed\n", s);
    169e:	85d2                	mv	a1,s4
    16a0:	00004517          	auipc	a0,0x4
    16a4:	2d850513          	addi	a0,a0,728 # 5978 <malloc+0x9c6>
    16a8:	057030ef          	jal	4efe <printf>
      exit(1);
    16ac:	4505                	li	a0,1
    16ae:	438030ef          	jal	4ae6 <exit>
        printf("%s: wait wrong pid\n", s);
    16b2:	85d2                	mv	a1,s4
    16b4:	00004517          	auipc	a0,0x4
    16b8:	44c50513          	addi	a0,a0,1100 # 5b00 <malloc+0xb4e>
    16bc:	043030ef          	jal	4efe <printf>
        exit(1);
    16c0:	4505                	li	a0,1
    16c2:	424030ef          	jal	4ae6 <exit>
        printf("%s: wait wrong exit status\n", s);
    16c6:	85d2                	mv	a1,s4
    16c8:	00004517          	auipc	a0,0x4
    16cc:	45050513          	addi	a0,a0,1104 # 5b18 <malloc+0xb66>
    16d0:	02f030ef          	jal	4efe <printf>
        exit(1);
    16d4:	4505                	li	a0,1
    16d6:	410030ef          	jal	4ae6 <exit>
      exit(i);
    16da:	854a                	mv	a0,s2
    16dc:	40a030ef          	jal	4ae6 <exit>

00000000000016e0 <twochildren>:
{
    16e0:	1101                	addi	sp,sp,-32
    16e2:	ec06                	sd	ra,24(sp)
    16e4:	e822                	sd	s0,16(sp)
    16e6:	e426                	sd	s1,8(sp)
    16e8:	e04a                	sd	s2,0(sp)
    16ea:	1000                	addi	s0,sp,32
    16ec:	892a                	mv	s2,a0
    16ee:	3e800493          	li	s1,1000
    int pid1 = fork();
    16f2:	3ec030ef          	jal	4ade <fork>
    if(pid1 < 0){
    16f6:	02054663          	bltz	a0,1722 <twochildren+0x42>
    if(pid1 == 0){
    16fa:	cd15                	beqz	a0,1736 <twochildren+0x56>
      int pid2 = fork();
    16fc:	3e2030ef          	jal	4ade <fork>
      if(pid2 < 0){
    1700:	02054d63          	bltz	a0,173a <twochildren+0x5a>
      if(pid2 == 0){
    1704:	c529                	beqz	a0,174e <twochildren+0x6e>
        wait(0);
    1706:	4501                	li	a0,0
    1708:	3e6030ef          	jal	4aee <wait>
        wait(0);
    170c:	4501                	li	a0,0
    170e:	3e0030ef          	jal	4aee <wait>
  for(int i = 0; i < 1000; i++){
    1712:	34fd                	addiw	s1,s1,-1
    1714:	fcf9                	bnez	s1,16f2 <twochildren+0x12>
}
    1716:	60e2                	ld	ra,24(sp)
    1718:	6442                	ld	s0,16(sp)
    171a:	64a2                	ld	s1,8(sp)
    171c:	6902                	ld	s2,0(sp)
    171e:	6105                	addi	sp,sp,32
    1720:	8082                	ret
      printf("%s: fork failed\n", s);
    1722:	85ca                	mv	a1,s2
    1724:	00004517          	auipc	a0,0x4
    1728:	25450513          	addi	a0,a0,596 # 5978 <malloc+0x9c6>
    172c:	7d2030ef          	jal	4efe <printf>
      exit(1);
    1730:	4505                	li	a0,1
    1732:	3b4030ef          	jal	4ae6 <exit>
      exit(0);
    1736:	3b0030ef          	jal	4ae6 <exit>
        printf("%s: fork failed\n", s);
    173a:	85ca                	mv	a1,s2
    173c:	00004517          	auipc	a0,0x4
    1740:	23c50513          	addi	a0,a0,572 # 5978 <malloc+0x9c6>
    1744:	7ba030ef          	jal	4efe <printf>
        exit(1);
    1748:	4505                	li	a0,1
    174a:	39c030ef          	jal	4ae6 <exit>
        exit(0);
    174e:	398030ef          	jal	4ae6 <exit>

0000000000001752 <forkfork>:
{
    1752:	7179                	addi	sp,sp,-48
    1754:	f406                	sd	ra,40(sp)
    1756:	f022                	sd	s0,32(sp)
    1758:	ec26                	sd	s1,24(sp)
    175a:	1800                	addi	s0,sp,48
    175c:	84aa                	mv	s1,a0
    int pid = fork();
    175e:	380030ef          	jal	4ade <fork>
    if(pid < 0){
    1762:	02054b63          	bltz	a0,1798 <forkfork+0x46>
    if(pid == 0){
    1766:	c139                	beqz	a0,17ac <forkfork+0x5a>
    int pid = fork();
    1768:	376030ef          	jal	4ade <fork>
    if(pid < 0){
    176c:	02054663          	bltz	a0,1798 <forkfork+0x46>
    if(pid == 0){
    1770:	cd15                	beqz	a0,17ac <forkfork+0x5a>
    wait(&xstatus);
    1772:	fdc40513          	addi	a0,s0,-36
    1776:	378030ef          	jal	4aee <wait>
    if(xstatus != 0) {
    177a:	fdc42783          	lw	a5,-36(s0)
    177e:	ebb9                	bnez	a5,17d4 <forkfork+0x82>
    wait(&xstatus);
    1780:	fdc40513          	addi	a0,s0,-36
    1784:	36a030ef          	jal	4aee <wait>
    if(xstatus != 0) {
    1788:	fdc42783          	lw	a5,-36(s0)
    178c:	e7a1                	bnez	a5,17d4 <forkfork+0x82>
}
    178e:	70a2                	ld	ra,40(sp)
    1790:	7402                	ld	s0,32(sp)
    1792:	64e2                	ld	s1,24(sp)
    1794:	6145                	addi	sp,sp,48
    1796:	8082                	ret
      printf("%s: fork failed", s);
    1798:	85a6                	mv	a1,s1
    179a:	00004517          	auipc	a0,0x4
    179e:	39e50513          	addi	a0,a0,926 # 5b38 <malloc+0xb86>
    17a2:	75c030ef          	jal	4efe <printf>
      exit(1);
    17a6:	4505                	li	a0,1
    17a8:	33e030ef          	jal	4ae6 <exit>
{
    17ac:	0c800493          	li	s1,200
        int pid1 = fork();
    17b0:	32e030ef          	jal	4ade <fork>
        if(pid1 < 0){
    17b4:	00054b63          	bltz	a0,17ca <forkfork+0x78>
        if(pid1 == 0){
    17b8:	cd01                	beqz	a0,17d0 <forkfork+0x7e>
        wait(0);
    17ba:	4501                	li	a0,0
    17bc:	332030ef          	jal	4aee <wait>
      for(int j = 0; j < 200; j++){
    17c0:	34fd                	addiw	s1,s1,-1
    17c2:	f4fd                	bnez	s1,17b0 <forkfork+0x5e>
      exit(0);
    17c4:	4501                	li	a0,0
    17c6:	320030ef          	jal	4ae6 <exit>
          exit(1);
    17ca:	4505                	li	a0,1
    17cc:	31a030ef          	jal	4ae6 <exit>
          exit(0);
    17d0:	316030ef          	jal	4ae6 <exit>
      printf("%s: fork in child failed", s);
    17d4:	85a6                	mv	a1,s1
    17d6:	00004517          	auipc	a0,0x4
    17da:	37250513          	addi	a0,a0,882 # 5b48 <malloc+0xb96>
    17de:	720030ef          	jal	4efe <printf>
      exit(1);
    17e2:	4505                	li	a0,1
    17e4:	302030ef          	jal	4ae6 <exit>

00000000000017e8 <reparent2>:
{
    17e8:	1101                	addi	sp,sp,-32
    17ea:	ec06                	sd	ra,24(sp)
    17ec:	e822                	sd	s0,16(sp)
    17ee:	e426                	sd	s1,8(sp)
    17f0:	1000                	addi	s0,sp,32
    17f2:	32000493          	li	s1,800
    int pid1 = fork();
    17f6:	2e8030ef          	jal	4ade <fork>
    if(pid1 < 0){
    17fa:	00054b63          	bltz	a0,1810 <reparent2+0x28>
    if(pid1 == 0){
    17fe:	c115                	beqz	a0,1822 <reparent2+0x3a>
    wait(0);
    1800:	4501                	li	a0,0
    1802:	2ec030ef          	jal	4aee <wait>
  for(int i = 0; i < 800; i++){
    1806:	34fd                	addiw	s1,s1,-1
    1808:	f4fd                	bnez	s1,17f6 <reparent2+0xe>
  exit(0);
    180a:	4501                	li	a0,0
    180c:	2da030ef          	jal	4ae6 <exit>
      printf("fork failed\n");
    1810:	00005517          	auipc	a0,0x5
    1814:	6d850513          	addi	a0,a0,1752 # 6ee8 <malloc+0x1f36>
    1818:	6e6030ef          	jal	4efe <printf>
      exit(1);
    181c:	4505                	li	a0,1
    181e:	2c8030ef          	jal	4ae6 <exit>
      fork();
    1822:	2bc030ef          	jal	4ade <fork>
      fork();
    1826:	2b8030ef          	jal	4ade <fork>
      exit(0);
    182a:	4501                	li	a0,0
    182c:	2ba030ef          	jal	4ae6 <exit>

0000000000001830 <createdelete>:
{
    1830:	7175                	addi	sp,sp,-144
    1832:	e506                	sd	ra,136(sp)
    1834:	e122                	sd	s0,128(sp)
    1836:	fca6                	sd	s1,120(sp)
    1838:	f8ca                	sd	s2,112(sp)
    183a:	f4ce                	sd	s3,104(sp)
    183c:	f0d2                	sd	s4,96(sp)
    183e:	ecd6                	sd	s5,88(sp)
    1840:	e8da                	sd	s6,80(sp)
    1842:	e4de                	sd	s7,72(sp)
    1844:	e0e2                	sd	s8,64(sp)
    1846:	fc66                	sd	s9,56(sp)
    1848:	0900                	addi	s0,sp,144
    184a:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    184c:	4901                	li	s2,0
    184e:	4991                	li	s3,4
    pid = fork();
    1850:	28e030ef          	jal	4ade <fork>
    1854:	84aa                	mv	s1,a0
    if(pid < 0){
    1856:	02054d63          	bltz	a0,1890 <createdelete+0x60>
    if(pid == 0){
    185a:	c529                	beqz	a0,18a4 <createdelete+0x74>
  for(pi = 0; pi < NCHILD; pi++){
    185c:	2905                	addiw	s2,s2,1
    185e:	ff3919e3          	bne	s2,s3,1850 <createdelete+0x20>
    1862:	4491                	li	s1,4
    wait(&xstatus);
    1864:	f7c40513          	addi	a0,s0,-132
    1868:	286030ef          	jal	4aee <wait>
    if(xstatus != 0)
    186c:	f7c42903          	lw	s2,-132(s0)
    1870:	0a091e63          	bnez	s2,192c <createdelete+0xfc>
  for(pi = 0; pi < NCHILD; pi++){
    1874:	34fd                	addiw	s1,s1,-1
    1876:	f4fd                	bnez	s1,1864 <createdelete+0x34>
  name[0] = name[1] = name[2] = 0;
    1878:	f8040123          	sb	zero,-126(s0)
    187c:	03000993          	li	s3,48
    1880:	5a7d                	li	s4,-1
    1882:	07000c13          	li	s8,112
      if((i == 0 || i >= N/2) && fd < 0){
    1886:	4b25                	li	s6,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1888:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    188a:	07400a93          	li	s5,116
    188e:	aa39                	j	19ac <createdelete+0x17c>
      printf("%s: fork failed\n", s);
    1890:	85e6                	mv	a1,s9
    1892:	00004517          	auipc	a0,0x4
    1896:	0e650513          	addi	a0,a0,230 # 5978 <malloc+0x9c6>
    189a:	664030ef          	jal	4efe <printf>
      exit(1);
    189e:	4505                	li	a0,1
    18a0:	246030ef          	jal	4ae6 <exit>
      name[0] = 'p' + pi;
    18a4:	0709091b          	addiw	s2,s2,112
    18a8:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    18ac:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    18b0:	4951                	li	s2,20
    18b2:	a831                	j	18ce <createdelete+0x9e>
          printf("%s: create failed\n", s);
    18b4:	85e6                	mv	a1,s9
    18b6:	00004517          	auipc	a0,0x4
    18ba:	15a50513          	addi	a0,a0,346 # 5a10 <malloc+0xa5e>
    18be:	640030ef          	jal	4efe <printf>
          exit(1);
    18c2:	4505                	li	a0,1
    18c4:	222030ef          	jal	4ae6 <exit>
      for(i = 0; i < N; i++){
    18c8:	2485                	addiw	s1,s1,1
    18ca:	05248e63          	beq	s1,s2,1926 <createdelete+0xf6>
        name[1] = '0' + i;
    18ce:	0304879b          	addiw	a5,s1,48
    18d2:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    18d6:	20200593          	li	a1,514
    18da:	f8040513          	addi	a0,s0,-128
    18de:	248030ef          	jal	4b26 <open>
        if(fd < 0){
    18e2:	fc0549e3          	bltz	a0,18b4 <createdelete+0x84>
        close(fd);
    18e6:	228030ef          	jal	4b0e <close>
        if(i > 0 && (i % 2 ) == 0){
    18ea:	10905063          	blez	s1,19ea <createdelete+0x1ba>
    18ee:	0014f793          	andi	a5,s1,1
    18f2:	fbf9                	bnez	a5,18c8 <createdelete+0x98>
          name[1] = '0' + (i / 2);
    18f4:	01f4d79b          	srliw	a5,s1,0x1f
    18f8:	9fa5                	addw	a5,a5,s1
    18fa:	4017d79b          	sraiw	a5,a5,0x1
    18fe:	0307879b          	addiw	a5,a5,48
    1902:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1906:	f8040513          	addi	a0,s0,-128
    190a:	22c030ef          	jal	4b36 <unlink>
    190e:	fa055de3          	bgez	a0,18c8 <createdelete+0x98>
            printf("%s: unlink failed\n", s);
    1912:	85e6                	mv	a1,s9
    1914:	00004517          	auipc	a0,0x4
    1918:	25450513          	addi	a0,a0,596 # 5b68 <malloc+0xbb6>
    191c:	5e2030ef          	jal	4efe <printf>
            exit(1);
    1920:	4505                	li	a0,1
    1922:	1c4030ef          	jal	4ae6 <exit>
      exit(0);
    1926:	4501                	li	a0,0
    1928:	1be030ef          	jal	4ae6 <exit>
      exit(1);
    192c:	4505                	li	a0,1
    192e:	1b8030ef          	jal	4ae6 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1932:	f8040613          	addi	a2,s0,-128
    1936:	85e6                	mv	a1,s9
    1938:	00004517          	auipc	a0,0x4
    193c:	24850513          	addi	a0,a0,584 # 5b80 <malloc+0xbce>
    1940:	5be030ef          	jal	4efe <printf>
        exit(1);
    1944:	4505                	li	a0,1
    1946:	1a0030ef          	jal	4ae6 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    194a:	034bfb63          	bgeu	s7,s4,1980 <createdelete+0x150>
      if(fd >= 0)
    194e:	02055663          	bgez	a0,197a <createdelete+0x14a>
    for(pi = 0; pi < NCHILD; pi++){
    1952:	2485                	addiw	s1,s1,1
    1954:	0ff4f493          	zext.b	s1,s1
    1958:	05548263          	beq	s1,s5,199c <createdelete+0x16c>
      name[0] = 'p' + pi;
    195c:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1960:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1964:	4581                	li	a1,0
    1966:	f8040513          	addi	a0,s0,-128
    196a:	1bc030ef          	jal	4b26 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    196e:	00090463          	beqz	s2,1976 <createdelete+0x146>
    1972:	fd2b5ce3          	bge	s6,s2,194a <createdelete+0x11a>
    1976:	fa054ee3          	bltz	a0,1932 <createdelete+0x102>
        close(fd);
    197a:	194030ef          	jal	4b0e <close>
    197e:	bfd1                	j	1952 <createdelete+0x122>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1980:	fc0549e3          	bltz	a0,1952 <createdelete+0x122>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1984:	f8040613          	addi	a2,s0,-128
    1988:	85e6                	mv	a1,s9
    198a:	00004517          	auipc	a0,0x4
    198e:	21e50513          	addi	a0,a0,542 # 5ba8 <malloc+0xbf6>
    1992:	56c030ef          	jal	4efe <printf>
        exit(1);
    1996:	4505                	li	a0,1
    1998:	14e030ef          	jal	4ae6 <exit>
  for(i = 0; i < N; i++){
    199c:	2905                	addiw	s2,s2,1
    199e:	2a05                	addiw	s4,s4,1
    19a0:	2985                	addiw	s3,s3,1
    19a2:	0ff9f993          	zext.b	s3,s3
    19a6:	47d1                	li	a5,20
    19a8:	02f90863          	beq	s2,a5,19d8 <createdelete+0x1a8>
    for(pi = 0; pi < NCHILD; pi++){
    19ac:	84e2                	mv	s1,s8
    19ae:	b77d                	j	195c <createdelete+0x12c>
  for(i = 0; i < N; i++){
    19b0:	2905                	addiw	s2,s2,1
    19b2:	0ff97913          	zext.b	s2,s2
    19b6:	03490c63          	beq	s2,s4,19ee <createdelete+0x1be>
  name[0] = name[1] = name[2] = 0;
    19ba:	84d6                	mv	s1,s5
      name[0] = 'p' + pi;
    19bc:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    19c0:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    19c4:	f8040513          	addi	a0,s0,-128
    19c8:	16e030ef          	jal	4b36 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    19cc:	2485                	addiw	s1,s1,1
    19ce:	0ff4f493          	zext.b	s1,s1
    19d2:	ff3495e3          	bne	s1,s3,19bc <createdelete+0x18c>
    19d6:	bfe9                	j	19b0 <createdelete+0x180>
    19d8:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    19dc:	07000a93          	li	s5,112
    for(pi = 0; pi < NCHILD; pi++){
    19e0:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    19e4:	04400a13          	li	s4,68
    19e8:	bfc9                	j	19ba <createdelete+0x18a>
      for(i = 0; i < N; i++){
    19ea:	2485                	addiw	s1,s1,1
    19ec:	b5cd                	j	18ce <createdelete+0x9e>
}
    19ee:	60aa                	ld	ra,136(sp)
    19f0:	640a                	ld	s0,128(sp)
    19f2:	74e6                	ld	s1,120(sp)
    19f4:	7946                	ld	s2,112(sp)
    19f6:	79a6                	ld	s3,104(sp)
    19f8:	7a06                	ld	s4,96(sp)
    19fa:	6ae6                	ld	s5,88(sp)
    19fc:	6b46                	ld	s6,80(sp)
    19fe:	6ba6                	ld	s7,72(sp)
    1a00:	6c06                	ld	s8,64(sp)
    1a02:	7ce2                	ld	s9,56(sp)
    1a04:	6149                	addi	sp,sp,144
    1a06:	8082                	ret

0000000000001a08 <linkunlink>:
{
    1a08:	711d                	addi	sp,sp,-96
    1a0a:	ec86                	sd	ra,88(sp)
    1a0c:	e8a2                	sd	s0,80(sp)
    1a0e:	e4a6                	sd	s1,72(sp)
    1a10:	e0ca                	sd	s2,64(sp)
    1a12:	fc4e                	sd	s3,56(sp)
    1a14:	f852                	sd	s4,48(sp)
    1a16:	f456                	sd	s5,40(sp)
    1a18:	f05a                	sd	s6,32(sp)
    1a1a:	ec5e                	sd	s7,24(sp)
    1a1c:	e862                	sd	s8,16(sp)
    1a1e:	e466                	sd	s9,8(sp)
    1a20:	1080                	addi	s0,sp,96
    1a22:	84aa                	mv	s1,a0
  unlink("x");
    1a24:	00003517          	auipc	a0,0x3
    1a28:	73450513          	addi	a0,a0,1844 # 5158 <malloc+0x1a6>
    1a2c:	10a030ef          	jal	4b36 <unlink>
  pid = fork();
    1a30:	0ae030ef          	jal	4ade <fork>
  if(pid < 0){
    1a34:	02054b63          	bltz	a0,1a6a <linkunlink+0x62>
    1a38:	8caa                	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    1a3a:	06100913          	li	s2,97
    1a3e:	c111                	beqz	a0,1a42 <linkunlink+0x3a>
    1a40:	4905                	li	s2,1
    1a42:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1a46:	41c65a37          	lui	s4,0x41c65
    1a4a:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <base+0x41c551f5>
    1a4e:	698d                	lui	s3,0x3
    1a50:	0399899b          	addiw	s3,s3,57 # 3039 <subdir+0x45d>
    if((x % 3) == 0){
    1a54:	4a8d                	li	s5,3
    } else if((x % 3) == 1){
    1a56:	4b85                	li	s7,1
      unlink("x");
    1a58:	00003b17          	auipc	s6,0x3
    1a5c:	700b0b13          	addi	s6,s6,1792 # 5158 <malloc+0x1a6>
      link("cat", "x");
    1a60:	00004c17          	auipc	s8,0x4
    1a64:	170c0c13          	addi	s8,s8,368 # 5bd0 <malloc+0xc1e>
    1a68:	a025                	j	1a90 <linkunlink+0x88>
    printf("%s: fork failed\n", s);
    1a6a:	85a6                	mv	a1,s1
    1a6c:	00004517          	auipc	a0,0x4
    1a70:	f0c50513          	addi	a0,a0,-244 # 5978 <malloc+0x9c6>
    1a74:	48a030ef          	jal	4efe <printf>
    exit(1);
    1a78:	4505                	li	a0,1
    1a7a:	06c030ef          	jal	4ae6 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1a7e:	20200593          	li	a1,514
    1a82:	855a                	mv	a0,s6
    1a84:	0a2030ef          	jal	4b26 <open>
    1a88:	086030ef          	jal	4b0e <close>
  for(i = 0; i < 100; i++){
    1a8c:	34fd                	addiw	s1,s1,-1
    1a8e:	c495                	beqz	s1,1aba <linkunlink+0xb2>
    x = x * 1103515245 + 12345;
    1a90:	034907bb          	mulw	a5,s2,s4
    1a94:	013787bb          	addw	a5,a5,s3
    1a98:	0007891b          	sext.w	s2,a5
    if((x % 3) == 0){
    1a9c:	0357f7bb          	remuw	a5,a5,s5
    1aa0:	2781                	sext.w	a5,a5
    1aa2:	dff1                	beqz	a5,1a7e <linkunlink+0x76>
    } else if((x % 3) == 1){
    1aa4:	01778663          	beq	a5,s7,1ab0 <linkunlink+0xa8>
      unlink("x");
    1aa8:	855a                	mv	a0,s6
    1aaa:	08c030ef          	jal	4b36 <unlink>
    1aae:	bff9                	j	1a8c <linkunlink+0x84>
      link("cat", "x");
    1ab0:	85da                	mv	a1,s6
    1ab2:	8562                	mv	a0,s8
    1ab4:	092030ef          	jal	4b46 <link>
    1ab8:	bfd1                	j	1a8c <linkunlink+0x84>
  if(pid)
    1aba:	020c8263          	beqz	s9,1ade <linkunlink+0xd6>
    wait(0);
    1abe:	4501                	li	a0,0
    1ac0:	02e030ef          	jal	4aee <wait>
}
    1ac4:	60e6                	ld	ra,88(sp)
    1ac6:	6446                	ld	s0,80(sp)
    1ac8:	64a6                	ld	s1,72(sp)
    1aca:	6906                	ld	s2,64(sp)
    1acc:	79e2                	ld	s3,56(sp)
    1ace:	7a42                	ld	s4,48(sp)
    1ad0:	7aa2                	ld	s5,40(sp)
    1ad2:	7b02                	ld	s6,32(sp)
    1ad4:	6be2                	ld	s7,24(sp)
    1ad6:	6c42                	ld	s8,16(sp)
    1ad8:	6ca2                	ld	s9,8(sp)
    1ada:	6125                	addi	sp,sp,96
    1adc:	8082                	ret
    exit(0);
    1ade:	4501                	li	a0,0
    1ae0:	006030ef          	jal	4ae6 <exit>

0000000000001ae4 <forktest>:
{
    1ae4:	7179                	addi	sp,sp,-48
    1ae6:	f406                	sd	ra,40(sp)
    1ae8:	f022                	sd	s0,32(sp)
    1aea:	ec26                	sd	s1,24(sp)
    1aec:	e84a                	sd	s2,16(sp)
    1aee:	e44e                	sd	s3,8(sp)
    1af0:	1800                	addi	s0,sp,48
    1af2:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1af4:	4481                	li	s1,0
    1af6:	3e800913          	li	s2,1000
    pid = fork();
    1afa:	7e5020ef          	jal	4ade <fork>
    if(pid < 0)
    1afe:	06054063          	bltz	a0,1b5e <forktest+0x7a>
    if(pid == 0)
    1b02:	cd11                	beqz	a0,1b1e <forktest+0x3a>
  for(n=0; n<N; n++){
    1b04:	2485                	addiw	s1,s1,1
    1b06:	ff249ae3          	bne	s1,s2,1afa <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1b0a:	85ce                	mv	a1,s3
    1b0c:	00004517          	auipc	a0,0x4
    1b10:	11450513          	addi	a0,a0,276 # 5c20 <malloc+0xc6e>
    1b14:	3ea030ef          	jal	4efe <printf>
    exit(1);
    1b18:	4505                	li	a0,1
    1b1a:	7cd020ef          	jal	4ae6 <exit>
      exit(0);
    1b1e:	7c9020ef          	jal	4ae6 <exit>
    printf("%s: no fork at all!\n", s);
    1b22:	85ce                	mv	a1,s3
    1b24:	00004517          	auipc	a0,0x4
    1b28:	0b450513          	addi	a0,a0,180 # 5bd8 <malloc+0xc26>
    1b2c:	3d2030ef          	jal	4efe <printf>
    exit(1);
    1b30:	4505                	li	a0,1
    1b32:	7b5020ef          	jal	4ae6 <exit>
      printf("%s: wait stopped early\n", s);
    1b36:	85ce                	mv	a1,s3
    1b38:	00004517          	auipc	a0,0x4
    1b3c:	0b850513          	addi	a0,a0,184 # 5bf0 <malloc+0xc3e>
    1b40:	3be030ef          	jal	4efe <printf>
      exit(1);
    1b44:	4505                	li	a0,1
    1b46:	7a1020ef          	jal	4ae6 <exit>
    printf("%s: wait got too many\n", s);
    1b4a:	85ce                	mv	a1,s3
    1b4c:	00004517          	auipc	a0,0x4
    1b50:	0bc50513          	addi	a0,a0,188 # 5c08 <malloc+0xc56>
    1b54:	3aa030ef          	jal	4efe <printf>
    exit(1);
    1b58:	4505                	li	a0,1
    1b5a:	78d020ef          	jal	4ae6 <exit>
  if (n == 0) {
    1b5e:	d0f1                	beqz	s1,1b22 <forktest+0x3e>
  for(; n > 0; n--){
    1b60:	00905963          	blez	s1,1b72 <forktest+0x8e>
    if(wait(0) < 0){
    1b64:	4501                	li	a0,0
    1b66:	789020ef          	jal	4aee <wait>
    1b6a:	fc0546e3          	bltz	a0,1b36 <forktest+0x52>
  for(; n > 0; n--){
    1b6e:	34fd                	addiw	s1,s1,-1
    1b70:	f8f5                	bnez	s1,1b64 <forktest+0x80>
  if(wait(0) != -1){
    1b72:	4501                	li	a0,0
    1b74:	77b020ef          	jal	4aee <wait>
    1b78:	57fd                	li	a5,-1
    1b7a:	fcf518e3          	bne	a0,a5,1b4a <forktest+0x66>
}
    1b7e:	70a2                	ld	ra,40(sp)
    1b80:	7402                	ld	s0,32(sp)
    1b82:	64e2                	ld	s1,24(sp)
    1b84:	6942                	ld	s2,16(sp)
    1b86:	69a2                	ld	s3,8(sp)
    1b88:	6145                	addi	sp,sp,48
    1b8a:	8082                	ret

0000000000001b8c <kernmem>:
{
    1b8c:	715d                	addi	sp,sp,-80
    1b8e:	e486                	sd	ra,72(sp)
    1b90:	e0a2                	sd	s0,64(sp)
    1b92:	fc26                	sd	s1,56(sp)
    1b94:	f84a                	sd	s2,48(sp)
    1b96:	f44e                	sd	s3,40(sp)
    1b98:	f052                	sd	s4,32(sp)
    1b9a:	ec56                	sd	s5,24(sp)
    1b9c:	0880                	addi	s0,sp,80
    1b9e:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1ba0:	4485                	li	s1,1
    1ba2:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1ba4:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1ba6:	69b1                	lui	s3,0xc
    1ba8:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    1bac:	1003d937          	lui	s2,0x1003d
    1bb0:	090e                	slli	s2,s2,0x3
    1bb2:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    1bb6:	729020ef          	jal	4ade <fork>
    if(pid < 0){
    1bba:	02054763          	bltz	a0,1be8 <kernmem+0x5c>
    if(pid == 0){
    1bbe:	cd1d                	beqz	a0,1bfc <kernmem+0x70>
    wait(&xstatus);
    1bc0:	fbc40513          	addi	a0,s0,-68
    1bc4:	72b020ef          	jal	4aee <wait>
    if(xstatus != -1)  // did kernel kill child?
    1bc8:	fbc42783          	lw	a5,-68(s0)
    1bcc:	05479563          	bne	a5,s4,1c16 <kernmem+0x8a>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1bd0:	94ce                	add	s1,s1,s3
    1bd2:	ff2492e3          	bne	s1,s2,1bb6 <kernmem+0x2a>
}
    1bd6:	60a6                	ld	ra,72(sp)
    1bd8:	6406                	ld	s0,64(sp)
    1bda:	74e2                	ld	s1,56(sp)
    1bdc:	7942                	ld	s2,48(sp)
    1bde:	79a2                	ld	s3,40(sp)
    1be0:	7a02                	ld	s4,32(sp)
    1be2:	6ae2                	ld	s5,24(sp)
    1be4:	6161                	addi	sp,sp,80
    1be6:	8082                	ret
      printf("%s: fork failed\n", s);
    1be8:	85d6                	mv	a1,s5
    1bea:	00004517          	auipc	a0,0x4
    1bee:	d8e50513          	addi	a0,a0,-626 # 5978 <malloc+0x9c6>
    1bf2:	30c030ef          	jal	4efe <printf>
      exit(1);
    1bf6:	4505                	li	a0,1
    1bf8:	6ef020ef          	jal	4ae6 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1bfc:	0004c683          	lbu	a3,0(s1)
    1c00:	8626                	mv	a2,s1
    1c02:	85d6                	mv	a1,s5
    1c04:	00004517          	auipc	a0,0x4
    1c08:	04450513          	addi	a0,a0,68 # 5c48 <malloc+0xc96>
    1c0c:	2f2030ef          	jal	4efe <printf>
      exit(1);
    1c10:	4505                	li	a0,1
    1c12:	6d5020ef          	jal	4ae6 <exit>
      exit(1);
    1c16:	4505                	li	a0,1
    1c18:	6cf020ef          	jal	4ae6 <exit>

0000000000001c1c <MAXVAplus>:
{
    1c1c:	7179                	addi	sp,sp,-48
    1c1e:	f406                	sd	ra,40(sp)
    1c20:	f022                	sd	s0,32(sp)
    1c22:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    1c24:	4785                	li	a5,1
    1c26:	179a                	slli	a5,a5,0x26
    1c28:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    1c2c:	fd843783          	ld	a5,-40(s0)
    1c30:	cf85                	beqz	a5,1c68 <MAXVAplus+0x4c>
    1c32:	ec26                	sd	s1,24(sp)
    1c34:	e84a                	sd	s2,16(sp)
    1c36:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    1c38:	54fd                	li	s1,-1
    pid = fork();
    1c3a:	6a5020ef          	jal	4ade <fork>
    if(pid < 0){
    1c3e:	02054963          	bltz	a0,1c70 <MAXVAplus+0x54>
    if(pid == 0){
    1c42:	c129                	beqz	a0,1c84 <MAXVAplus+0x68>
    wait(&xstatus);
    1c44:	fd440513          	addi	a0,s0,-44
    1c48:	6a7020ef          	jal	4aee <wait>
    if(xstatus != -1)  // did kernel kill child?
    1c4c:	fd442783          	lw	a5,-44(s0)
    1c50:	04979c63          	bne	a5,s1,1ca8 <MAXVAplus+0x8c>
  for( ; a != 0; a <<= 1){
    1c54:	fd843783          	ld	a5,-40(s0)
    1c58:	0786                	slli	a5,a5,0x1
    1c5a:	fcf43c23          	sd	a5,-40(s0)
    1c5e:	fd843783          	ld	a5,-40(s0)
    1c62:	ffe1                	bnez	a5,1c3a <MAXVAplus+0x1e>
    1c64:	64e2                	ld	s1,24(sp)
    1c66:	6942                	ld	s2,16(sp)
}
    1c68:	70a2                	ld	ra,40(sp)
    1c6a:	7402                	ld	s0,32(sp)
    1c6c:	6145                	addi	sp,sp,48
    1c6e:	8082                	ret
      printf("%s: fork failed\n", s);
    1c70:	85ca                	mv	a1,s2
    1c72:	00004517          	auipc	a0,0x4
    1c76:	d0650513          	addi	a0,a0,-762 # 5978 <malloc+0x9c6>
    1c7a:	284030ef          	jal	4efe <printf>
      exit(1);
    1c7e:	4505                	li	a0,1
    1c80:	667020ef          	jal	4ae6 <exit>
      *(char*)a = 99;
    1c84:	fd843783          	ld	a5,-40(s0)
    1c88:	06300713          	li	a4,99
    1c8c:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1c90:	fd843603          	ld	a2,-40(s0)
    1c94:	85ca                	mv	a1,s2
    1c96:	00004517          	auipc	a0,0x4
    1c9a:	fd250513          	addi	a0,a0,-46 # 5c68 <malloc+0xcb6>
    1c9e:	260030ef          	jal	4efe <printf>
      exit(1);
    1ca2:	4505                	li	a0,1
    1ca4:	643020ef          	jal	4ae6 <exit>
      exit(1);
    1ca8:	4505                	li	a0,1
    1caa:	63d020ef          	jal	4ae6 <exit>

0000000000001cae <stacktest>:
{
    1cae:	7179                	addi	sp,sp,-48
    1cb0:	f406                	sd	ra,40(sp)
    1cb2:	f022                	sd	s0,32(sp)
    1cb4:	ec26                	sd	s1,24(sp)
    1cb6:	1800                	addi	s0,sp,48
    1cb8:	84aa                	mv	s1,a0
  pid = fork();
    1cba:	625020ef          	jal	4ade <fork>
  if(pid == 0) {
    1cbe:	cd11                	beqz	a0,1cda <stacktest+0x2c>
  } else if(pid < 0){
    1cc0:	02054c63          	bltz	a0,1cf8 <stacktest+0x4a>
  wait(&xstatus);
    1cc4:	fdc40513          	addi	a0,s0,-36
    1cc8:	627020ef          	jal	4aee <wait>
  if(xstatus == -1)  // kernel killed child?
    1ccc:	fdc42503          	lw	a0,-36(s0)
    1cd0:	57fd                	li	a5,-1
    1cd2:	02f50d63          	beq	a0,a5,1d0c <stacktest+0x5e>
    exit(xstatus);
    1cd6:	611020ef          	jal	4ae6 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1cda:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1cdc:	77fd                	lui	a5,0xfffff
    1cde:	97ba                	add	a5,a5,a4
    1ce0:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    1ce4:	85a6                	mv	a1,s1
    1ce6:	00004517          	auipc	a0,0x4
    1cea:	f9a50513          	addi	a0,a0,-102 # 5c80 <malloc+0xcce>
    1cee:	210030ef          	jal	4efe <printf>
    exit(1);
    1cf2:	4505                	li	a0,1
    1cf4:	5f3020ef          	jal	4ae6 <exit>
    printf("%s: fork failed\n", s);
    1cf8:	85a6                	mv	a1,s1
    1cfa:	00004517          	auipc	a0,0x4
    1cfe:	c7e50513          	addi	a0,a0,-898 # 5978 <malloc+0x9c6>
    1d02:	1fc030ef          	jal	4efe <printf>
    exit(1);
    1d06:	4505                	li	a0,1
    1d08:	5df020ef          	jal	4ae6 <exit>
    exit(0);
    1d0c:	4501                	li	a0,0
    1d0e:	5d9020ef          	jal	4ae6 <exit>

0000000000001d12 <nowrite>:
{
    1d12:	7159                	addi	sp,sp,-112
    1d14:	f486                	sd	ra,104(sp)
    1d16:	f0a2                	sd	s0,96(sp)
    1d18:	eca6                	sd	s1,88(sp)
    1d1a:	e8ca                	sd	s2,80(sp)
    1d1c:	e4ce                	sd	s3,72(sp)
    1d1e:	1880                	addi	s0,sp,112
    1d20:	89aa                	mv	s3,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1d22:	00005797          	auipc	a5,0x5
    1d26:	72678793          	addi	a5,a5,1830 # 7448 <malloc+0x2496>
    1d2a:	7788                	ld	a0,40(a5)
    1d2c:	7b8c                	ld	a1,48(a5)
    1d2e:	7f90                	ld	a2,56(a5)
    1d30:	63b4                	ld	a3,64(a5)
    1d32:	67b8                	ld	a4,72(a5)
    1d34:	6bbc                	ld	a5,80(a5)
    1d36:	f8a43c23          	sd	a0,-104(s0)
    1d3a:	fab43023          	sd	a1,-96(s0)
    1d3e:	fac43423          	sd	a2,-88(s0)
    1d42:	fad43823          	sd	a3,-80(s0)
    1d46:	fae43c23          	sd	a4,-72(s0)
    1d4a:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d4e:	4481                	li	s1,0
    1d50:	4919                	li	s2,6
    pid = fork();
    1d52:	58d020ef          	jal	4ade <fork>
    if(pid == 0) {
    1d56:	c105                	beqz	a0,1d76 <nowrite+0x64>
    } else if(pid < 0){
    1d58:	04054263          	bltz	a0,1d9c <nowrite+0x8a>
    wait(&xstatus);
    1d5c:	fcc40513          	addi	a0,s0,-52
    1d60:	58f020ef          	jal	4aee <wait>
    if(xstatus == 0){
    1d64:	fcc42783          	lw	a5,-52(s0)
    1d68:	c7a1                	beqz	a5,1db0 <nowrite+0x9e>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d6a:	2485                	addiw	s1,s1,1
    1d6c:	ff2493e3          	bne	s1,s2,1d52 <nowrite+0x40>
  exit(0);
    1d70:	4501                	li	a0,0
    1d72:	575020ef          	jal	4ae6 <exit>
      volatile int *addr = (int *) addrs[ai];
    1d76:	048e                	slli	s1,s1,0x3
    1d78:	fd048793          	addi	a5,s1,-48
    1d7c:	008784b3          	add	s1,a5,s0
    1d80:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1d84:	47a9                	li	a5,10
    1d86:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1d88:	85ce                	mv	a1,s3
    1d8a:	00004517          	auipc	a0,0x4
    1d8e:	f1e50513          	addi	a0,a0,-226 # 5ca8 <malloc+0xcf6>
    1d92:	16c030ef          	jal	4efe <printf>
      exit(0);
    1d96:	4501                	li	a0,0
    1d98:	54f020ef          	jal	4ae6 <exit>
      printf("%s: fork failed\n", s);
    1d9c:	85ce                	mv	a1,s3
    1d9e:	00004517          	auipc	a0,0x4
    1da2:	bda50513          	addi	a0,a0,-1062 # 5978 <malloc+0x9c6>
    1da6:	158030ef          	jal	4efe <printf>
      exit(1);
    1daa:	4505                	li	a0,1
    1dac:	53b020ef          	jal	4ae6 <exit>
      exit(1);
    1db0:	4505                	li	a0,1
    1db2:	535020ef          	jal	4ae6 <exit>

0000000000001db6 <manywrites>:
{
    1db6:	711d                	addi	sp,sp,-96
    1db8:	ec86                	sd	ra,88(sp)
    1dba:	e8a2                	sd	s0,80(sp)
    1dbc:	e4a6                	sd	s1,72(sp)
    1dbe:	e0ca                	sd	s2,64(sp)
    1dc0:	fc4e                	sd	s3,56(sp)
    1dc2:	f456                	sd	s5,40(sp)
    1dc4:	1080                	addi	s0,sp,96
    1dc6:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1dc8:	4981                	li	s3,0
    1dca:	4911                	li	s2,4
    int pid = fork();
    1dcc:	513020ef          	jal	4ade <fork>
    1dd0:	84aa                	mv	s1,a0
    if(pid < 0){
    1dd2:	02054963          	bltz	a0,1e04 <manywrites+0x4e>
    if(pid == 0){
    1dd6:	c139                	beqz	a0,1e1c <manywrites+0x66>
  for(int ci = 0; ci < nchildren; ci++){
    1dd8:	2985                	addiw	s3,s3,1
    1dda:	ff2999e3          	bne	s3,s2,1dcc <manywrites+0x16>
    1dde:	f852                	sd	s4,48(sp)
    1de0:	f05a                	sd	s6,32(sp)
    1de2:	ec5e                	sd	s7,24(sp)
    1de4:	4491                	li	s1,4
    int st = 0;
    1de6:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1dea:	fa840513          	addi	a0,s0,-88
    1dee:	501020ef          	jal	4aee <wait>
    if(st != 0)
    1df2:	fa842503          	lw	a0,-88(s0)
    1df6:	0c051863          	bnez	a0,1ec6 <manywrites+0x110>
  for(int ci = 0; ci < nchildren; ci++){
    1dfa:	34fd                	addiw	s1,s1,-1
    1dfc:	f4ed                	bnez	s1,1de6 <manywrites+0x30>
  exit(0);
    1dfe:	4501                	li	a0,0
    1e00:	4e7020ef          	jal	4ae6 <exit>
    1e04:	f852                	sd	s4,48(sp)
    1e06:	f05a                	sd	s6,32(sp)
    1e08:	ec5e                	sd	s7,24(sp)
      printf("fork failed\n");
    1e0a:	00005517          	auipc	a0,0x5
    1e0e:	0de50513          	addi	a0,a0,222 # 6ee8 <malloc+0x1f36>
    1e12:	0ec030ef          	jal	4efe <printf>
      exit(1);
    1e16:	4505                	li	a0,1
    1e18:	4cf020ef          	jal	4ae6 <exit>
    1e1c:	f852                	sd	s4,48(sp)
    1e1e:	f05a                	sd	s6,32(sp)
    1e20:	ec5e                	sd	s7,24(sp)
      name[0] = 'b';
    1e22:	06200793          	li	a5,98
    1e26:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1e2a:	0619879b          	addiw	a5,s3,97
    1e2e:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1e32:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1e36:	fa840513          	addi	a0,s0,-88
    1e3a:	4fd020ef          	jal	4b36 <unlink>
    1e3e:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1e40:	0000bb17          	auipc	s6,0xb
    1e44:	e38b0b13          	addi	s6,s6,-456 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    1e48:	8a26                	mv	s4,s1
    1e4a:	0209c863          	bltz	s3,1e7a <manywrites+0xc4>
          int fd = open(name, O_CREATE | O_RDWR);
    1e4e:	20200593          	li	a1,514
    1e52:	fa840513          	addi	a0,s0,-88
    1e56:	4d1020ef          	jal	4b26 <open>
    1e5a:	892a                	mv	s2,a0
          if(fd < 0){
    1e5c:	02054d63          	bltz	a0,1e96 <manywrites+0xe0>
          int cc = write(fd, buf, sz);
    1e60:	660d                	lui	a2,0x3
    1e62:	85da                	mv	a1,s6
    1e64:	4a3020ef          	jal	4b06 <write>
          if(cc != sz){
    1e68:	678d                	lui	a5,0x3
    1e6a:	04f51263          	bne	a0,a5,1eae <manywrites+0xf8>
          close(fd);
    1e6e:	854a                	mv	a0,s2
    1e70:	49f020ef          	jal	4b0e <close>
        for(int i = 0; i < ci+1; i++){
    1e74:	2a05                	addiw	s4,s4,1
    1e76:	fd49dce3          	bge	s3,s4,1e4e <manywrites+0x98>
        unlink(name);
    1e7a:	fa840513          	addi	a0,s0,-88
    1e7e:	4b9020ef          	jal	4b36 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1e82:	3bfd                	addiw	s7,s7,-1
    1e84:	fc0b92e3          	bnez	s7,1e48 <manywrites+0x92>
      unlink(name);
    1e88:	fa840513          	addi	a0,s0,-88
    1e8c:	4ab020ef          	jal	4b36 <unlink>
      exit(0);
    1e90:	4501                	li	a0,0
    1e92:	455020ef          	jal	4ae6 <exit>
            printf("%s: cannot create %s\n", s, name);
    1e96:	fa840613          	addi	a2,s0,-88
    1e9a:	85d6                	mv	a1,s5
    1e9c:	00004517          	auipc	a0,0x4
    1ea0:	e2c50513          	addi	a0,a0,-468 # 5cc8 <malloc+0xd16>
    1ea4:	05a030ef          	jal	4efe <printf>
            exit(1);
    1ea8:	4505                	li	a0,1
    1eaa:	43d020ef          	jal	4ae6 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1eae:	86aa                	mv	a3,a0
    1eb0:	660d                	lui	a2,0x3
    1eb2:	85d6                	mv	a1,s5
    1eb4:	00003517          	auipc	a0,0x3
    1eb8:	30450513          	addi	a0,a0,772 # 51b8 <malloc+0x206>
    1ebc:	042030ef          	jal	4efe <printf>
            exit(1);
    1ec0:	4505                	li	a0,1
    1ec2:	425020ef          	jal	4ae6 <exit>
      exit(st);
    1ec6:	421020ef          	jal	4ae6 <exit>

0000000000001eca <copyinstr3>:
{
    1eca:	7179                	addi	sp,sp,-48
    1ecc:	f406                	sd	ra,40(sp)
    1ece:	f022                	sd	s0,32(sp)
    1ed0:	ec26                	sd	s1,24(sp)
    1ed2:	1800                	addi	s0,sp,48
  sbrk(8192);
    1ed4:	6509                	lui	a0,0x2
    1ed6:	499020ef          	jal	4b6e <sbrk>
  uint64 top = (uint64) sbrk(0);
    1eda:	4501                	li	a0,0
    1edc:	493020ef          	jal	4b6e <sbrk>
  if((top % PGSIZE) != 0){
    1ee0:	03451793          	slli	a5,a0,0x34
    1ee4:	e7bd                	bnez	a5,1f52 <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1ee6:	4501                	li	a0,0
    1ee8:	487020ef          	jal	4b6e <sbrk>
  if(top % PGSIZE){
    1eec:	03451793          	slli	a5,a0,0x34
    1ef0:	ebad                	bnez	a5,1f62 <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    1ef2:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0x31>
  *b = 'x';
    1ef6:	07800793          	li	a5,120
    1efa:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1efe:	8526                	mv	a0,s1
    1f00:	437020ef          	jal	4b36 <unlink>
  if(ret != -1){
    1f04:	57fd                	li	a5,-1
    1f06:	06f51763          	bne	a0,a5,1f74 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1f0a:	20100593          	li	a1,513
    1f0e:	8526                	mv	a0,s1
    1f10:	417020ef          	jal	4b26 <open>
  if(fd != -1){
    1f14:	57fd                	li	a5,-1
    1f16:	06f51a63          	bne	a0,a5,1f8a <copyinstr3+0xc0>
  ret = link(b, b);
    1f1a:	85a6                	mv	a1,s1
    1f1c:	8526                	mv	a0,s1
    1f1e:	429020ef          	jal	4b46 <link>
  if(ret != -1){
    1f22:	57fd                	li	a5,-1
    1f24:	06f51e63          	bne	a0,a5,1fa0 <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    1f28:	00005797          	auipc	a5,0x5
    1f2c:	aa078793          	addi	a5,a5,-1376 # 69c8 <malloc+0x1a16>
    1f30:	fcf43823          	sd	a5,-48(s0)
    1f34:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1f38:	fd040593          	addi	a1,s0,-48
    1f3c:	8526                	mv	a0,s1
    1f3e:	3e1020ef          	jal	4b1e <exec>
  if(ret != -1){
    1f42:	57fd                	li	a5,-1
    1f44:	06f51a63          	bne	a0,a5,1fb8 <copyinstr3+0xee>
}
    1f48:	70a2                	ld	ra,40(sp)
    1f4a:	7402                	ld	s0,32(sp)
    1f4c:	64e2                	ld	s1,24(sp)
    1f4e:	6145                	addi	sp,sp,48
    1f50:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1f52:	0347d513          	srli	a0,a5,0x34
    1f56:	6785                	lui	a5,0x1
    1f58:	40a7853b          	subw	a0,a5,a0
    1f5c:	413020ef          	jal	4b6e <sbrk>
    1f60:	b759                	j	1ee6 <copyinstr3+0x1c>
    printf("oops\n");
    1f62:	00004517          	auipc	a0,0x4
    1f66:	d7e50513          	addi	a0,a0,-642 # 5ce0 <malloc+0xd2e>
    1f6a:	795020ef          	jal	4efe <printf>
    exit(1);
    1f6e:	4505                	li	a0,1
    1f70:	377020ef          	jal	4ae6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1f74:	862a                	mv	a2,a0
    1f76:	85a6                	mv	a1,s1
    1f78:	00004517          	auipc	a0,0x4
    1f7c:	92050513          	addi	a0,a0,-1760 # 5898 <malloc+0x8e6>
    1f80:	77f020ef          	jal	4efe <printf>
    exit(1);
    1f84:	4505                	li	a0,1
    1f86:	361020ef          	jal	4ae6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f8a:	862a                	mv	a2,a0
    1f8c:	85a6                	mv	a1,s1
    1f8e:	00004517          	auipc	a0,0x4
    1f92:	92a50513          	addi	a0,a0,-1750 # 58b8 <malloc+0x906>
    1f96:	769020ef          	jal	4efe <printf>
    exit(1);
    1f9a:	4505                	li	a0,1
    1f9c:	34b020ef          	jal	4ae6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1fa0:	86aa                	mv	a3,a0
    1fa2:	8626                	mv	a2,s1
    1fa4:	85a6                	mv	a1,s1
    1fa6:	00004517          	auipc	a0,0x4
    1faa:	93250513          	addi	a0,a0,-1742 # 58d8 <malloc+0x926>
    1fae:	751020ef          	jal	4efe <printf>
    exit(1);
    1fb2:	4505                	li	a0,1
    1fb4:	333020ef          	jal	4ae6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1fb8:	567d                	li	a2,-1
    1fba:	85a6                	mv	a1,s1
    1fbc:	00004517          	auipc	a0,0x4
    1fc0:	94450513          	addi	a0,a0,-1724 # 5900 <malloc+0x94e>
    1fc4:	73b020ef          	jal	4efe <printf>
    exit(1);
    1fc8:	4505                	li	a0,1
    1fca:	31d020ef          	jal	4ae6 <exit>

0000000000001fce <rwsbrk>:
{
    1fce:	1101                	addi	sp,sp,-32
    1fd0:	ec06                	sd	ra,24(sp)
    1fd2:	e822                	sd	s0,16(sp)
    1fd4:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    1fd6:	6509                	lui	a0,0x2
    1fd8:	397020ef          	jal	4b6e <sbrk>
  if(a == 0xffffffffffffffffLL) {
    1fdc:	57fd                	li	a5,-1
    1fde:	04f50a63          	beq	a0,a5,2032 <rwsbrk+0x64>
    1fe2:	e426                	sd	s1,8(sp)
    1fe4:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    1fe6:	7579                	lui	a0,0xffffe
    1fe8:	387020ef          	jal	4b6e <sbrk>
    1fec:	57fd                	li	a5,-1
    1fee:	04f50d63          	beq	a0,a5,2048 <rwsbrk+0x7a>
    1ff2:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    1ff4:	20100593          	li	a1,513
    1ff8:	00004517          	auipc	a0,0x4
    1ffc:	d2850513          	addi	a0,a0,-728 # 5d20 <malloc+0xd6e>
    2000:	327020ef          	jal	4b26 <open>
    2004:	892a                	mv	s2,a0
  if(fd < 0){
    2006:	04054b63          	bltz	a0,205c <rwsbrk+0x8e>
  n = write(fd, (void*)(a+4096), 1024);
    200a:	6785                	lui	a5,0x1
    200c:	94be                	add	s1,s1,a5
    200e:	40000613          	li	a2,1024
    2012:	85a6                	mv	a1,s1
    2014:	2f3020ef          	jal	4b06 <write>
    2018:	862a                	mv	a2,a0
  if(n >= 0){
    201a:	04054a63          	bltz	a0,206e <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+4096, n);
    201e:	85a6                	mv	a1,s1
    2020:	00004517          	auipc	a0,0x4
    2024:	d2050513          	addi	a0,a0,-736 # 5d40 <malloc+0xd8e>
    2028:	6d7020ef          	jal	4efe <printf>
    exit(1);
    202c:	4505                	li	a0,1
    202e:	2b9020ef          	jal	4ae6 <exit>
    2032:	e426                	sd	s1,8(sp)
    2034:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    2036:	00004517          	auipc	a0,0x4
    203a:	cb250513          	addi	a0,a0,-846 # 5ce8 <malloc+0xd36>
    203e:	6c1020ef          	jal	4efe <printf>
    exit(1);
    2042:	4505                	li	a0,1
    2044:	2a3020ef          	jal	4ae6 <exit>
    2048:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    204a:	00004517          	auipc	a0,0x4
    204e:	cb650513          	addi	a0,a0,-842 # 5d00 <malloc+0xd4e>
    2052:	6ad020ef          	jal	4efe <printf>
    exit(1);
    2056:	4505                	li	a0,1
    2058:	28f020ef          	jal	4ae6 <exit>
    printf("open(rwsbrk) failed\n");
    205c:	00004517          	auipc	a0,0x4
    2060:	ccc50513          	addi	a0,a0,-820 # 5d28 <malloc+0xd76>
    2064:	69b020ef          	jal	4efe <printf>
    exit(1);
    2068:	4505                	li	a0,1
    206a:	27d020ef          	jal	4ae6 <exit>
  close(fd);
    206e:	854a                	mv	a0,s2
    2070:	29f020ef          	jal	4b0e <close>
  unlink("rwsbrk");
    2074:	00004517          	auipc	a0,0x4
    2078:	cac50513          	addi	a0,a0,-852 # 5d20 <malloc+0xd6e>
    207c:	2bb020ef          	jal	4b36 <unlink>
  fd = open("README", O_RDONLY);
    2080:	4581                	li	a1,0
    2082:	00003517          	auipc	a0,0x3
    2086:	23e50513          	addi	a0,a0,574 # 52c0 <malloc+0x30e>
    208a:	29d020ef          	jal	4b26 <open>
    208e:	892a                	mv	s2,a0
  if(fd < 0){
    2090:	02054363          	bltz	a0,20b6 <rwsbrk+0xe8>
  n = read(fd, (void*)(a+4096), 10);
    2094:	4629                	li	a2,10
    2096:	85a6                	mv	a1,s1
    2098:	267020ef          	jal	4afe <read>
    209c:	862a                	mv	a2,a0
  if(n >= 0){
    209e:	02054563          	bltz	a0,20c8 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+4096, n);
    20a2:	85a6                	mv	a1,s1
    20a4:	00004517          	auipc	a0,0x4
    20a8:	ccc50513          	addi	a0,a0,-820 # 5d70 <malloc+0xdbe>
    20ac:	653020ef          	jal	4efe <printf>
    exit(1);
    20b0:	4505                	li	a0,1
    20b2:	235020ef          	jal	4ae6 <exit>
    printf("open(rwsbrk) failed\n");
    20b6:	00004517          	auipc	a0,0x4
    20ba:	c7250513          	addi	a0,a0,-910 # 5d28 <malloc+0xd76>
    20be:	641020ef          	jal	4efe <printf>
    exit(1);
    20c2:	4505                	li	a0,1
    20c4:	223020ef          	jal	4ae6 <exit>
  close(fd);
    20c8:	854a                	mv	a0,s2
    20ca:	245020ef          	jal	4b0e <close>
  exit(0);
    20ce:	4501                	li	a0,0
    20d0:	217020ef          	jal	4ae6 <exit>

00000000000020d4 <sbrkbasic>:
{
    20d4:	7139                	addi	sp,sp,-64
    20d6:	fc06                	sd	ra,56(sp)
    20d8:	f822                	sd	s0,48(sp)
    20da:	ec4e                	sd	s3,24(sp)
    20dc:	0080                	addi	s0,sp,64
    20de:	89aa                	mv	s3,a0
  pid = fork();
    20e0:	1ff020ef          	jal	4ade <fork>
  if(pid < 0){
    20e4:	02054b63          	bltz	a0,211a <sbrkbasic+0x46>
  if(pid == 0){
    20e8:	e939                	bnez	a0,213e <sbrkbasic+0x6a>
    a = sbrk(TOOMUCH);
    20ea:	40000537          	lui	a0,0x40000
    20ee:	281020ef          	jal	4b6e <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    20f2:	57fd                	li	a5,-1
    20f4:	02f50f63          	beq	a0,a5,2132 <sbrkbasic+0x5e>
    20f8:	f426                	sd	s1,40(sp)
    20fa:	f04a                	sd	s2,32(sp)
    20fc:	e852                	sd	s4,16(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    20fe:	400007b7          	lui	a5,0x40000
    2102:	97aa                	add	a5,a5,a0
      *b = 99;
    2104:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2108:	6705                	lui	a4,0x1
      *b = 99;
    210a:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    210e:	953a                	add	a0,a0,a4
    2110:	fef51de3          	bne	a0,a5,210a <sbrkbasic+0x36>
    exit(1);
    2114:	4505                	li	a0,1
    2116:	1d1020ef          	jal	4ae6 <exit>
    211a:	f426                	sd	s1,40(sp)
    211c:	f04a                	sd	s2,32(sp)
    211e:	e852                	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    2120:	00004517          	auipc	a0,0x4
    2124:	c7850513          	addi	a0,a0,-904 # 5d98 <malloc+0xde6>
    2128:	5d7020ef          	jal	4efe <printf>
    exit(1);
    212c:	4505                	li	a0,1
    212e:	1b9020ef          	jal	4ae6 <exit>
    2132:	f426                	sd	s1,40(sp)
    2134:	f04a                	sd	s2,32(sp)
    2136:	e852                	sd	s4,16(sp)
      exit(0);
    2138:	4501                	li	a0,0
    213a:	1ad020ef          	jal	4ae6 <exit>
  wait(&xstatus);
    213e:	fcc40513          	addi	a0,s0,-52
    2142:	1ad020ef          	jal	4aee <wait>
  if(xstatus == 1){
    2146:	fcc42703          	lw	a4,-52(s0)
    214a:	4785                	li	a5,1
    214c:	00f70e63          	beq	a4,a5,2168 <sbrkbasic+0x94>
    2150:	f426                	sd	s1,40(sp)
    2152:	f04a                	sd	s2,32(sp)
    2154:	e852                	sd	s4,16(sp)
  a = sbrk(0);
    2156:	4501                	li	a0,0
    2158:	217020ef          	jal	4b6e <sbrk>
    215c:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    215e:	4901                	li	s2,0
    2160:	6a05                	lui	s4,0x1
    2162:	388a0a13          	addi	s4,s4,904 # 1388 <exectest+0x4a>
    2166:	a839                	j	2184 <sbrkbasic+0xb0>
    2168:	f426                	sd	s1,40(sp)
    216a:	f04a                	sd	s2,32(sp)
    216c:	e852                	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    216e:	85ce                	mv	a1,s3
    2170:	00004517          	auipc	a0,0x4
    2174:	c4850513          	addi	a0,a0,-952 # 5db8 <malloc+0xe06>
    2178:	587020ef          	jal	4efe <printf>
    exit(1);
    217c:	4505                	li	a0,1
    217e:	169020ef          	jal	4ae6 <exit>
    2182:	84be                	mv	s1,a5
    b = sbrk(1);
    2184:	4505                	li	a0,1
    2186:	1e9020ef          	jal	4b6e <sbrk>
    if(b != a){
    218a:	04951263          	bne	a0,s1,21ce <sbrkbasic+0xfa>
    *b = 1;
    218e:	4785                	li	a5,1
    2190:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2194:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2198:	2905                	addiw	s2,s2,1
    219a:	ff4914e3          	bne	s2,s4,2182 <sbrkbasic+0xae>
  pid = fork();
    219e:	141020ef          	jal	4ade <fork>
    21a2:	892a                	mv	s2,a0
  if(pid < 0){
    21a4:	04054263          	bltz	a0,21e8 <sbrkbasic+0x114>
  c = sbrk(1);
    21a8:	4505                	li	a0,1
    21aa:	1c5020ef          	jal	4b6e <sbrk>
  c = sbrk(1);
    21ae:	4505                	li	a0,1
    21b0:	1bf020ef          	jal	4b6e <sbrk>
  if(c != a + 1){
    21b4:	0489                	addi	s1,s1,2
    21b6:	04a48363          	beq	s1,a0,21fc <sbrkbasic+0x128>
    printf("%s: sbrk test failed post-fork\n", s);
    21ba:	85ce                	mv	a1,s3
    21bc:	00004517          	auipc	a0,0x4
    21c0:	c5c50513          	addi	a0,a0,-932 # 5e18 <malloc+0xe66>
    21c4:	53b020ef          	jal	4efe <printf>
    exit(1);
    21c8:	4505                	li	a0,1
    21ca:	11d020ef          	jal	4ae6 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    21ce:	872a                	mv	a4,a0
    21d0:	86a6                	mv	a3,s1
    21d2:	864a                	mv	a2,s2
    21d4:	85ce                	mv	a1,s3
    21d6:	00004517          	auipc	a0,0x4
    21da:	c0250513          	addi	a0,a0,-1022 # 5dd8 <malloc+0xe26>
    21de:	521020ef          	jal	4efe <printf>
      exit(1);
    21e2:	4505                	li	a0,1
    21e4:	103020ef          	jal	4ae6 <exit>
    printf("%s: sbrk test fork failed\n", s);
    21e8:	85ce                	mv	a1,s3
    21ea:	00004517          	auipc	a0,0x4
    21ee:	c0e50513          	addi	a0,a0,-1010 # 5df8 <malloc+0xe46>
    21f2:	50d020ef          	jal	4efe <printf>
    exit(1);
    21f6:	4505                	li	a0,1
    21f8:	0ef020ef          	jal	4ae6 <exit>
  if(pid == 0)
    21fc:	00091563          	bnez	s2,2206 <sbrkbasic+0x132>
    exit(0);
    2200:	4501                	li	a0,0
    2202:	0e5020ef          	jal	4ae6 <exit>
  wait(&xstatus);
    2206:	fcc40513          	addi	a0,s0,-52
    220a:	0e5020ef          	jal	4aee <wait>
  exit(xstatus);
    220e:	fcc42503          	lw	a0,-52(s0)
    2212:	0d5020ef          	jal	4ae6 <exit>

0000000000002216 <sbrkmuch>:
{
    2216:	7179                	addi	sp,sp,-48
    2218:	f406                	sd	ra,40(sp)
    221a:	f022                	sd	s0,32(sp)
    221c:	ec26                	sd	s1,24(sp)
    221e:	e84a                	sd	s2,16(sp)
    2220:	e44e                	sd	s3,8(sp)
    2222:	e052                	sd	s4,0(sp)
    2224:	1800                	addi	s0,sp,48
    2226:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2228:	4501                	li	a0,0
    222a:	145020ef          	jal	4b6e <sbrk>
    222e:	892a                	mv	s2,a0
  a = sbrk(0);
    2230:	4501                	li	a0,0
    2232:	13d020ef          	jal	4b6e <sbrk>
    2236:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2238:	06400537          	lui	a0,0x6400
    223c:	9d05                	subw	a0,a0,s1
    223e:	131020ef          	jal	4b6e <sbrk>
  if (p != a) {
    2242:	0aa49463          	bne	s1,a0,22ea <sbrkmuch+0xd4>
  char *eee = sbrk(0);
    2246:	4501                	li	a0,0
    2248:	127020ef          	jal	4b6e <sbrk>
    224c:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    224e:	00a4f963          	bgeu	s1,a0,2260 <sbrkmuch+0x4a>
    *pp = 1;
    2252:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2254:	6705                	lui	a4,0x1
    *pp = 1;
    2256:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    225a:	94ba                	add	s1,s1,a4
    225c:	fef4ede3          	bltu	s1,a5,2256 <sbrkmuch+0x40>
  *lastaddr = 99;
    2260:	064007b7          	lui	a5,0x6400
    2264:	06300713          	li	a4,99
    2268:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    226c:	4501                	li	a0,0
    226e:	101020ef          	jal	4b6e <sbrk>
    2272:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2274:	757d                	lui	a0,0xfffff
    2276:	0f9020ef          	jal	4b6e <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    227a:	57fd                	li	a5,-1
    227c:	08f50163          	beq	a0,a5,22fe <sbrkmuch+0xe8>
  c = sbrk(0);
    2280:	4501                	li	a0,0
    2282:	0ed020ef          	jal	4b6e <sbrk>
  if(c != a - PGSIZE){
    2286:	77fd                	lui	a5,0xfffff
    2288:	97a6                	add	a5,a5,s1
    228a:	08f51463          	bne	a0,a5,2312 <sbrkmuch+0xfc>
  a = sbrk(0);
    228e:	4501                	li	a0,0
    2290:	0df020ef          	jal	4b6e <sbrk>
    2294:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2296:	6505                	lui	a0,0x1
    2298:	0d7020ef          	jal	4b6e <sbrk>
    229c:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    229e:	08a49663          	bne	s1,a0,232a <sbrkmuch+0x114>
    22a2:	4501                	li	a0,0
    22a4:	0cb020ef          	jal	4b6e <sbrk>
    22a8:	6785                	lui	a5,0x1
    22aa:	97a6                	add	a5,a5,s1
    22ac:	06f51f63          	bne	a0,a5,232a <sbrkmuch+0x114>
  if(*lastaddr == 99){
    22b0:	064007b7          	lui	a5,0x6400
    22b4:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    22b8:	06300793          	li	a5,99
    22bc:	08f70363          	beq	a4,a5,2342 <sbrkmuch+0x12c>
  a = sbrk(0);
    22c0:	4501                	li	a0,0
    22c2:	0ad020ef          	jal	4b6e <sbrk>
    22c6:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    22c8:	4501                	li	a0,0
    22ca:	0a5020ef          	jal	4b6e <sbrk>
    22ce:	40a9053b          	subw	a0,s2,a0
    22d2:	09d020ef          	jal	4b6e <sbrk>
  if(c != a){
    22d6:	08a49063          	bne	s1,a0,2356 <sbrkmuch+0x140>
}
    22da:	70a2                	ld	ra,40(sp)
    22dc:	7402                	ld	s0,32(sp)
    22de:	64e2                	ld	s1,24(sp)
    22e0:	6942                	ld	s2,16(sp)
    22e2:	69a2                	ld	s3,8(sp)
    22e4:	6a02                	ld	s4,0(sp)
    22e6:	6145                	addi	sp,sp,48
    22e8:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    22ea:	85ce                	mv	a1,s3
    22ec:	00004517          	auipc	a0,0x4
    22f0:	b4c50513          	addi	a0,a0,-1204 # 5e38 <malloc+0xe86>
    22f4:	40b020ef          	jal	4efe <printf>
    exit(1);
    22f8:	4505                	li	a0,1
    22fa:	7ec020ef          	jal	4ae6 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    22fe:	85ce                	mv	a1,s3
    2300:	00004517          	auipc	a0,0x4
    2304:	b8050513          	addi	a0,a0,-1152 # 5e80 <malloc+0xece>
    2308:	3f7020ef          	jal	4efe <printf>
    exit(1);
    230c:	4505                	li	a0,1
    230e:	7d8020ef          	jal	4ae6 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    2312:	86aa                	mv	a3,a0
    2314:	8626                	mv	a2,s1
    2316:	85ce                	mv	a1,s3
    2318:	00004517          	auipc	a0,0x4
    231c:	b8850513          	addi	a0,a0,-1144 # 5ea0 <malloc+0xeee>
    2320:	3df020ef          	jal	4efe <printf>
    exit(1);
    2324:	4505                	li	a0,1
    2326:	7c0020ef          	jal	4ae6 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    232a:	86d2                	mv	a3,s4
    232c:	8626                	mv	a2,s1
    232e:	85ce                	mv	a1,s3
    2330:	00004517          	auipc	a0,0x4
    2334:	bb050513          	addi	a0,a0,-1104 # 5ee0 <malloc+0xf2e>
    2338:	3c7020ef          	jal	4efe <printf>
    exit(1);
    233c:	4505                	li	a0,1
    233e:	7a8020ef          	jal	4ae6 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2342:	85ce                	mv	a1,s3
    2344:	00004517          	auipc	a0,0x4
    2348:	bcc50513          	addi	a0,a0,-1076 # 5f10 <malloc+0xf5e>
    234c:	3b3020ef          	jal	4efe <printf>
    exit(1);
    2350:	4505                	li	a0,1
    2352:	794020ef          	jal	4ae6 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2356:	86aa                	mv	a3,a0
    2358:	8626                	mv	a2,s1
    235a:	85ce                	mv	a1,s3
    235c:	00004517          	auipc	a0,0x4
    2360:	bec50513          	addi	a0,a0,-1044 # 5f48 <malloc+0xf96>
    2364:	39b020ef          	jal	4efe <printf>
    exit(1);
    2368:	4505                	li	a0,1
    236a:	77c020ef          	jal	4ae6 <exit>

000000000000236e <sbrkarg>:
{
    236e:	7179                	addi	sp,sp,-48
    2370:	f406                	sd	ra,40(sp)
    2372:	f022                	sd	s0,32(sp)
    2374:	ec26                	sd	s1,24(sp)
    2376:	e84a                	sd	s2,16(sp)
    2378:	e44e                	sd	s3,8(sp)
    237a:	1800                	addi	s0,sp,48
    237c:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    237e:	6505                	lui	a0,0x1
    2380:	7ee020ef          	jal	4b6e <sbrk>
    2384:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2386:	20100593          	li	a1,513
    238a:	00004517          	auipc	a0,0x4
    238e:	be650513          	addi	a0,a0,-1050 # 5f70 <malloc+0xfbe>
    2392:	794020ef          	jal	4b26 <open>
    2396:	84aa                	mv	s1,a0
  unlink("sbrk");
    2398:	00004517          	auipc	a0,0x4
    239c:	bd850513          	addi	a0,a0,-1064 # 5f70 <malloc+0xfbe>
    23a0:	796020ef          	jal	4b36 <unlink>
  if(fd < 0)  {
    23a4:	0204c963          	bltz	s1,23d6 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    23a8:	6605                	lui	a2,0x1
    23aa:	85ca                	mv	a1,s2
    23ac:	8526                	mv	a0,s1
    23ae:	758020ef          	jal	4b06 <write>
    23b2:	02054c63          	bltz	a0,23ea <sbrkarg+0x7c>
  close(fd);
    23b6:	8526                	mv	a0,s1
    23b8:	756020ef          	jal	4b0e <close>
  a = sbrk(PGSIZE);
    23bc:	6505                	lui	a0,0x1
    23be:	7b0020ef          	jal	4b6e <sbrk>
  if(pipe((int *) a) != 0){
    23c2:	734020ef          	jal	4af6 <pipe>
    23c6:	ed05                	bnez	a0,23fe <sbrkarg+0x90>
}
    23c8:	70a2                	ld	ra,40(sp)
    23ca:	7402                	ld	s0,32(sp)
    23cc:	64e2                	ld	s1,24(sp)
    23ce:	6942                	ld	s2,16(sp)
    23d0:	69a2                	ld	s3,8(sp)
    23d2:	6145                	addi	sp,sp,48
    23d4:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    23d6:	85ce                	mv	a1,s3
    23d8:	00004517          	auipc	a0,0x4
    23dc:	ba050513          	addi	a0,a0,-1120 # 5f78 <malloc+0xfc6>
    23e0:	31f020ef          	jal	4efe <printf>
    exit(1);
    23e4:	4505                	li	a0,1
    23e6:	700020ef          	jal	4ae6 <exit>
    printf("%s: write sbrk failed\n", s);
    23ea:	85ce                	mv	a1,s3
    23ec:	00004517          	auipc	a0,0x4
    23f0:	ba450513          	addi	a0,a0,-1116 # 5f90 <malloc+0xfde>
    23f4:	30b020ef          	jal	4efe <printf>
    exit(1);
    23f8:	4505                	li	a0,1
    23fa:	6ec020ef          	jal	4ae6 <exit>
    printf("%s: pipe() failed\n", s);
    23fe:	85ce                	mv	a1,s3
    2400:	00003517          	auipc	a0,0x3
    2404:	68050513          	addi	a0,a0,1664 # 5a80 <malloc+0xace>
    2408:	2f7020ef          	jal	4efe <printf>
    exit(1);
    240c:	4505                	li	a0,1
    240e:	6d8020ef          	jal	4ae6 <exit>

0000000000002412 <argptest>:
{
    2412:	1101                	addi	sp,sp,-32
    2414:	ec06                	sd	ra,24(sp)
    2416:	e822                	sd	s0,16(sp)
    2418:	e426                	sd	s1,8(sp)
    241a:	e04a                	sd	s2,0(sp)
    241c:	1000                	addi	s0,sp,32
    241e:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2420:	4581                	li	a1,0
    2422:	00004517          	auipc	a0,0x4
    2426:	b8650513          	addi	a0,a0,-1146 # 5fa8 <malloc+0xff6>
    242a:	6fc020ef          	jal	4b26 <open>
  if (fd < 0) {
    242e:	02054563          	bltz	a0,2458 <argptest+0x46>
    2432:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2434:	4501                	li	a0,0
    2436:	738020ef          	jal	4b6e <sbrk>
    243a:	567d                	li	a2,-1
    243c:	fff50593          	addi	a1,a0,-1
    2440:	8526                	mv	a0,s1
    2442:	6bc020ef          	jal	4afe <read>
  close(fd);
    2446:	8526                	mv	a0,s1
    2448:	6c6020ef          	jal	4b0e <close>
}
    244c:	60e2                	ld	ra,24(sp)
    244e:	6442                	ld	s0,16(sp)
    2450:	64a2                	ld	s1,8(sp)
    2452:	6902                	ld	s2,0(sp)
    2454:	6105                	addi	sp,sp,32
    2456:	8082                	ret
    printf("%s: open failed\n", s);
    2458:	85ca                	mv	a1,s2
    245a:	00003517          	auipc	a0,0x3
    245e:	53650513          	addi	a0,a0,1334 # 5990 <malloc+0x9de>
    2462:	29d020ef          	jal	4efe <printf>
    exit(1);
    2466:	4505                	li	a0,1
    2468:	67e020ef          	jal	4ae6 <exit>

000000000000246c <sbrkbugs>:
{
    246c:	1141                	addi	sp,sp,-16
    246e:	e406                	sd	ra,8(sp)
    2470:	e022                	sd	s0,0(sp)
    2472:	0800                	addi	s0,sp,16
  int pid = fork();
    2474:	66a020ef          	jal	4ade <fork>
  if(pid < 0){
    2478:	00054c63          	bltz	a0,2490 <sbrkbugs+0x24>
  if(pid == 0){
    247c:	e11d                	bnez	a0,24a2 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    247e:	6f0020ef          	jal	4b6e <sbrk>
    sbrk(-sz);
    2482:	40a0053b          	negw	a0,a0
    2486:	6e8020ef          	jal	4b6e <sbrk>
    exit(0);
    248a:	4501                	li	a0,0
    248c:	65a020ef          	jal	4ae6 <exit>
    printf("fork failed\n");
    2490:	00005517          	auipc	a0,0x5
    2494:	a5850513          	addi	a0,a0,-1448 # 6ee8 <malloc+0x1f36>
    2498:	267020ef          	jal	4efe <printf>
    exit(1);
    249c:	4505                	li	a0,1
    249e:	648020ef          	jal	4ae6 <exit>
  wait(0);
    24a2:	4501                	li	a0,0
    24a4:	64a020ef          	jal	4aee <wait>
  pid = fork();
    24a8:	636020ef          	jal	4ade <fork>
  if(pid < 0){
    24ac:	00054f63          	bltz	a0,24ca <sbrkbugs+0x5e>
  if(pid == 0){
    24b0:	e515                	bnez	a0,24dc <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    24b2:	6bc020ef          	jal	4b6e <sbrk>
    sbrk(-(sz - 3500));
    24b6:	6785                	lui	a5,0x1
    24b8:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0x138>
    24bc:	40a7853b          	subw	a0,a5,a0
    24c0:	6ae020ef          	jal	4b6e <sbrk>
    exit(0);
    24c4:	4501                	li	a0,0
    24c6:	620020ef          	jal	4ae6 <exit>
    printf("fork failed\n");
    24ca:	00005517          	auipc	a0,0x5
    24ce:	a1e50513          	addi	a0,a0,-1506 # 6ee8 <malloc+0x1f36>
    24d2:	22d020ef          	jal	4efe <printf>
    exit(1);
    24d6:	4505                	li	a0,1
    24d8:	60e020ef          	jal	4ae6 <exit>
  wait(0);
    24dc:	4501                	li	a0,0
    24de:	610020ef          	jal	4aee <wait>
  pid = fork();
    24e2:	5fc020ef          	jal	4ade <fork>
  if(pid < 0){
    24e6:	02054263          	bltz	a0,250a <sbrkbugs+0x9e>
  if(pid == 0){
    24ea:	e90d                	bnez	a0,251c <sbrkbugs+0xb0>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    24ec:	682020ef          	jal	4b6e <sbrk>
    24f0:	67ad                	lui	a5,0xb
    24f2:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x298>
    24f6:	40a7853b          	subw	a0,a5,a0
    24fa:	674020ef          	jal	4b6e <sbrk>
    sbrk(-10);
    24fe:	5559                	li	a0,-10
    2500:	66e020ef          	jal	4b6e <sbrk>
    exit(0);
    2504:	4501                	li	a0,0
    2506:	5e0020ef          	jal	4ae6 <exit>
    printf("fork failed\n");
    250a:	00005517          	auipc	a0,0x5
    250e:	9de50513          	addi	a0,a0,-1570 # 6ee8 <malloc+0x1f36>
    2512:	1ed020ef          	jal	4efe <printf>
    exit(1);
    2516:	4505                	li	a0,1
    2518:	5ce020ef          	jal	4ae6 <exit>
  wait(0);
    251c:	4501                	li	a0,0
    251e:	5d0020ef          	jal	4aee <wait>
  exit(0);
    2522:	4501                	li	a0,0
    2524:	5c2020ef          	jal	4ae6 <exit>

0000000000002528 <sbrklast>:
{
    2528:	7179                	addi	sp,sp,-48
    252a:	f406                	sd	ra,40(sp)
    252c:	f022                	sd	s0,32(sp)
    252e:	ec26                	sd	s1,24(sp)
    2530:	e84a                	sd	s2,16(sp)
    2532:	e44e                	sd	s3,8(sp)
    2534:	e052                	sd	s4,0(sp)
    2536:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2538:	4501                	li	a0,0
    253a:	634020ef          	jal	4b6e <sbrk>
  if((top % 4096) != 0)
    253e:	03451793          	slli	a5,a0,0x34
    2542:	ebad                	bnez	a5,25b4 <sbrklast+0x8c>
  sbrk(4096);
    2544:	6505                	lui	a0,0x1
    2546:	628020ef          	jal	4b6e <sbrk>
  sbrk(10);
    254a:	4529                	li	a0,10
    254c:	622020ef          	jal	4b6e <sbrk>
  sbrk(-20);
    2550:	5531                	li	a0,-20
    2552:	61c020ef          	jal	4b6e <sbrk>
  top = (uint64) sbrk(0);
    2556:	4501                	li	a0,0
    2558:	616020ef          	jal	4b6e <sbrk>
    255c:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    255e:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x122>
  p[0] = 'x';
    2562:	07800a13          	li	s4,120
    2566:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    256a:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    256e:	20200593          	li	a1,514
    2572:	854a                	mv	a0,s2
    2574:	5b2020ef          	jal	4b26 <open>
    2578:	89aa                	mv	s3,a0
  write(fd, p, 1);
    257a:	4605                	li	a2,1
    257c:	85ca                	mv	a1,s2
    257e:	588020ef          	jal	4b06 <write>
  close(fd);
    2582:	854e                	mv	a0,s3
    2584:	58a020ef          	jal	4b0e <close>
  fd = open(p, O_RDWR);
    2588:	4589                	li	a1,2
    258a:	854a                	mv	a0,s2
    258c:	59a020ef          	jal	4b26 <open>
  p[0] = '\0';
    2590:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2594:	4605                	li	a2,1
    2596:	85ca                	mv	a1,s2
    2598:	566020ef          	jal	4afe <read>
  if(p[0] != 'x')
    259c:	fc04c783          	lbu	a5,-64(s1)
    25a0:	03479263          	bne	a5,s4,25c4 <sbrklast+0x9c>
}
    25a4:	70a2                	ld	ra,40(sp)
    25a6:	7402                	ld	s0,32(sp)
    25a8:	64e2                	ld	s1,24(sp)
    25aa:	6942                	ld	s2,16(sp)
    25ac:	69a2                	ld	s3,8(sp)
    25ae:	6a02                	ld	s4,0(sp)
    25b0:	6145                	addi	sp,sp,48
    25b2:	8082                	ret
    sbrk(4096 - (top % 4096));
    25b4:	0347d513          	srli	a0,a5,0x34
    25b8:	6785                	lui	a5,0x1
    25ba:	40a7853b          	subw	a0,a5,a0
    25be:	5b0020ef          	jal	4b6e <sbrk>
    25c2:	b749                	j	2544 <sbrklast+0x1c>
    exit(1);
    25c4:	4505                	li	a0,1
    25c6:	520020ef          	jal	4ae6 <exit>

00000000000025ca <sbrk8000>:
{
    25ca:	1141                	addi	sp,sp,-16
    25cc:	e406                	sd	ra,8(sp)
    25ce:	e022                	sd	s0,0(sp)
    25d0:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    25d2:	80000537          	lui	a0,0x80000
    25d6:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    25d8:	596020ef          	jal	4b6e <sbrk>
  volatile char *top = sbrk(0);
    25dc:	4501                	li	a0,0
    25de:	590020ef          	jal	4b6e <sbrk>
  *(top-1) = *(top-1) + 1;
    25e2:	fff54783          	lbu	a5,-1(a0)
    25e6:	2785                	addiw	a5,a5,1 # 1001 <badarg+0x1>
    25e8:	0ff7f793          	zext.b	a5,a5
    25ec:	fef50fa3          	sb	a5,-1(a0)
}
    25f0:	60a2                	ld	ra,8(sp)
    25f2:	6402                	ld	s0,0(sp)
    25f4:	0141                	addi	sp,sp,16
    25f6:	8082                	ret

00000000000025f8 <execout>:
{
    25f8:	715d                	addi	sp,sp,-80
    25fa:	e486                	sd	ra,72(sp)
    25fc:	e0a2                	sd	s0,64(sp)
    25fe:	fc26                	sd	s1,56(sp)
    2600:	f84a                	sd	s2,48(sp)
    2602:	f44e                	sd	s3,40(sp)
    2604:	f052                	sd	s4,32(sp)
    2606:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2608:	4901                	li	s2,0
    260a:	49bd                	li	s3,15
    int pid = fork();
    260c:	4d2020ef          	jal	4ade <fork>
    2610:	84aa                	mv	s1,a0
    if(pid < 0){
    2612:	00054c63          	bltz	a0,262a <execout+0x32>
    } else if(pid == 0){
    2616:	c11d                	beqz	a0,263c <execout+0x44>
      wait((int*)0);
    2618:	4501                	li	a0,0
    261a:	4d4020ef          	jal	4aee <wait>
  for(int avail = 0; avail < 15; avail++){
    261e:	2905                	addiw	s2,s2,1
    2620:	ff3916e3          	bne	s2,s3,260c <execout+0x14>
  exit(0);
    2624:	4501                	li	a0,0
    2626:	4c0020ef          	jal	4ae6 <exit>
      printf("fork failed\n");
    262a:	00005517          	auipc	a0,0x5
    262e:	8be50513          	addi	a0,a0,-1858 # 6ee8 <malloc+0x1f36>
    2632:	0cd020ef          	jal	4efe <printf>
      exit(1);
    2636:	4505                	li	a0,1
    2638:	4ae020ef          	jal	4ae6 <exit>
        if(a == 0xffffffffffffffffLL)
    263c:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    263e:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2640:	6505                	lui	a0,0x1
    2642:	52c020ef          	jal	4b6e <sbrk>
        if(a == 0xffffffffffffffffLL)
    2646:	01350763          	beq	a0,s3,2654 <execout+0x5c>
        *(char*)(a + 4096 - 1) = 1;
    264a:	6785                	lui	a5,0x1
    264c:	97aa                	add	a5,a5,a0
    264e:	ff478fa3          	sb	s4,-1(a5) # fff <pgbug+0x2b>
      while(1){
    2652:	b7fd                	j	2640 <execout+0x48>
      for(int i = 0; i < avail; i++)
    2654:	01205863          	blez	s2,2664 <execout+0x6c>
        sbrk(-4096);
    2658:	757d                	lui	a0,0xfffff
    265a:	514020ef          	jal	4b6e <sbrk>
      for(int i = 0; i < avail; i++)
    265e:	2485                	addiw	s1,s1,1
    2660:	ff249ce3          	bne	s1,s2,2658 <execout+0x60>
      close(1);
    2664:	4505                	li	a0,1
    2666:	4a8020ef          	jal	4b0e <close>
      char *args[] = { "echo", "x", 0 };
    266a:	00003517          	auipc	a0,0x3
    266e:	a7e50513          	addi	a0,a0,-1410 # 50e8 <malloc+0x136>
    2672:	faa43c23          	sd	a0,-72(s0)
    2676:	00003797          	auipc	a5,0x3
    267a:	ae278793          	addi	a5,a5,-1310 # 5158 <malloc+0x1a6>
    267e:	fcf43023          	sd	a5,-64(s0)
    2682:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2686:	fb840593          	addi	a1,s0,-72
    268a:	494020ef          	jal	4b1e <exec>
      exit(0);
    268e:	4501                	li	a0,0
    2690:	456020ef          	jal	4ae6 <exit>

0000000000002694 <fourteen>:
{
    2694:	1101                	addi	sp,sp,-32
    2696:	ec06                	sd	ra,24(sp)
    2698:	e822                	sd	s0,16(sp)
    269a:	e426                	sd	s1,8(sp)
    269c:	1000                	addi	s0,sp,32
    269e:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    26a0:	00004517          	auipc	a0,0x4
    26a4:	ae050513          	addi	a0,a0,-1312 # 6180 <malloc+0x11ce>
    26a8:	4a6020ef          	jal	4b4e <mkdir>
    26ac:	e555                	bnez	a0,2758 <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    26ae:	00004517          	auipc	a0,0x4
    26b2:	92a50513          	addi	a0,a0,-1750 # 5fd8 <malloc+0x1026>
    26b6:	498020ef          	jal	4b4e <mkdir>
    26ba:	e94d                	bnez	a0,276c <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    26bc:	20000593          	li	a1,512
    26c0:	00004517          	auipc	a0,0x4
    26c4:	97050513          	addi	a0,a0,-1680 # 6030 <malloc+0x107e>
    26c8:	45e020ef          	jal	4b26 <open>
  if(fd < 0){
    26cc:	0a054a63          	bltz	a0,2780 <fourteen+0xec>
  close(fd);
    26d0:	43e020ef          	jal	4b0e <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    26d4:	4581                	li	a1,0
    26d6:	00004517          	auipc	a0,0x4
    26da:	9d250513          	addi	a0,a0,-1582 # 60a8 <malloc+0x10f6>
    26de:	448020ef          	jal	4b26 <open>
  if(fd < 0){
    26e2:	0a054963          	bltz	a0,2794 <fourteen+0x100>
  close(fd);
    26e6:	428020ef          	jal	4b0e <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    26ea:	00004517          	auipc	a0,0x4
    26ee:	a2e50513          	addi	a0,a0,-1490 # 6118 <malloc+0x1166>
    26f2:	45c020ef          	jal	4b4e <mkdir>
    26f6:	c94d                	beqz	a0,27a8 <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    26f8:	00004517          	auipc	a0,0x4
    26fc:	a7850513          	addi	a0,a0,-1416 # 6170 <malloc+0x11be>
    2700:	44e020ef          	jal	4b4e <mkdir>
    2704:	cd45                	beqz	a0,27bc <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    2706:	00004517          	auipc	a0,0x4
    270a:	a6a50513          	addi	a0,a0,-1430 # 6170 <malloc+0x11be>
    270e:	428020ef          	jal	4b36 <unlink>
  unlink("12345678901234/12345678901234");
    2712:	00004517          	auipc	a0,0x4
    2716:	a0650513          	addi	a0,a0,-1530 # 6118 <malloc+0x1166>
    271a:	41c020ef          	jal	4b36 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    271e:	00004517          	auipc	a0,0x4
    2722:	98a50513          	addi	a0,a0,-1654 # 60a8 <malloc+0x10f6>
    2726:	410020ef          	jal	4b36 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    272a:	00004517          	auipc	a0,0x4
    272e:	90650513          	addi	a0,a0,-1786 # 6030 <malloc+0x107e>
    2732:	404020ef          	jal	4b36 <unlink>
  unlink("12345678901234/123456789012345");
    2736:	00004517          	auipc	a0,0x4
    273a:	8a250513          	addi	a0,a0,-1886 # 5fd8 <malloc+0x1026>
    273e:	3f8020ef          	jal	4b36 <unlink>
  unlink("12345678901234");
    2742:	00004517          	auipc	a0,0x4
    2746:	a3e50513          	addi	a0,a0,-1474 # 6180 <malloc+0x11ce>
    274a:	3ec020ef          	jal	4b36 <unlink>
}
    274e:	60e2                	ld	ra,24(sp)
    2750:	6442                	ld	s0,16(sp)
    2752:	64a2                	ld	s1,8(sp)
    2754:	6105                	addi	sp,sp,32
    2756:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2758:	85a6                	mv	a1,s1
    275a:	00004517          	auipc	a0,0x4
    275e:	85650513          	addi	a0,a0,-1962 # 5fb0 <malloc+0xffe>
    2762:	79c020ef          	jal	4efe <printf>
    exit(1);
    2766:	4505                	li	a0,1
    2768:	37e020ef          	jal	4ae6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    276c:	85a6                	mv	a1,s1
    276e:	00004517          	auipc	a0,0x4
    2772:	88a50513          	addi	a0,a0,-1910 # 5ff8 <malloc+0x1046>
    2776:	788020ef          	jal	4efe <printf>
    exit(1);
    277a:	4505                	li	a0,1
    277c:	36a020ef          	jal	4ae6 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2780:	85a6                	mv	a1,s1
    2782:	00004517          	auipc	a0,0x4
    2786:	8de50513          	addi	a0,a0,-1826 # 6060 <malloc+0x10ae>
    278a:	774020ef          	jal	4efe <printf>
    exit(1);
    278e:	4505                	li	a0,1
    2790:	356020ef          	jal	4ae6 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2794:	85a6                	mv	a1,s1
    2796:	00004517          	auipc	a0,0x4
    279a:	94250513          	addi	a0,a0,-1726 # 60d8 <malloc+0x1126>
    279e:	760020ef          	jal	4efe <printf>
    exit(1);
    27a2:	4505                	li	a0,1
    27a4:	342020ef          	jal	4ae6 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    27a8:	85a6                	mv	a1,s1
    27aa:	00004517          	auipc	a0,0x4
    27ae:	98e50513          	addi	a0,a0,-1650 # 6138 <malloc+0x1186>
    27b2:	74c020ef          	jal	4efe <printf>
    exit(1);
    27b6:	4505                	li	a0,1
    27b8:	32e020ef          	jal	4ae6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    27bc:	85a6                	mv	a1,s1
    27be:	00004517          	auipc	a0,0x4
    27c2:	9d250513          	addi	a0,a0,-1582 # 6190 <malloc+0x11de>
    27c6:	738020ef          	jal	4efe <printf>
    exit(1);
    27ca:	4505                	li	a0,1
    27cc:	31a020ef          	jal	4ae6 <exit>

00000000000027d0 <diskfull>:
{
    27d0:	b8010113          	addi	sp,sp,-1152
    27d4:	46113c23          	sd	ra,1144(sp)
    27d8:	46813823          	sd	s0,1136(sp)
    27dc:	46913423          	sd	s1,1128(sp)
    27e0:	47213023          	sd	s2,1120(sp)
    27e4:	45313c23          	sd	s3,1112(sp)
    27e8:	45413823          	sd	s4,1104(sp)
    27ec:	45513423          	sd	s5,1096(sp)
    27f0:	45613023          	sd	s6,1088(sp)
    27f4:	43713c23          	sd	s7,1080(sp)
    27f8:	43813823          	sd	s8,1072(sp)
    27fc:	43913423          	sd	s9,1064(sp)
    2800:	48010413          	addi	s0,sp,1152
    2804:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    2806:	00004517          	auipc	a0,0x4
    280a:	9c250513          	addi	a0,a0,-1598 # 61c8 <malloc+0x1216>
    280e:	328020ef          	jal	4b36 <unlink>
    2812:	03000993          	li	s3,48
    name[0] = 'b';
    2816:	06200b13          	li	s6,98
    name[1] = 'i';
    281a:	06900a93          	li	s5,105
    name[2] = 'g';
    281e:	06700a13          	li	s4,103
    2822:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    2826:	07f00c13          	li	s8,127
    282a:	aab9                	j	2988 <diskfull+0x1b8>
      printf("%s: could not create file %s\n", s, name);
    282c:	b8040613          	addi	a2,s0,-1152
    2830:	85e6                	mv	a1,s9
    2832:	00004517          	auipc	a0,0x4
    2836:	9a650513          	addi	a0,a0,-1626 # 61d8 <malloc+0x1226>
    283a:	6c4020ef          	jal	4efe <printf>
      break;
    283e:	a039                	j	284c <diskfull+0x7c>
        close(fd);
    2840:	854a                	mv	a0,s2
    2842:	2cc020ef          	jal	4b0e <close>
    close(fd);
    2846:	854a                	mv	a0,s2
    2848:	2c6020ef          	jal	4b0e <close>
  for(int i = 0; i < nzz; i++){
    284c:	4481                	li	s1,0
    name[0] = 'z';
    284e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    2852:	08000993          	li	s3,128
    name[0] = 'z';
    2856:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    285a:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    285e:	41f4d71b          	sraiw	a4,s1,0x1f
    2862:	01b7571b          	srliw	a4,a4,0x1b
    2866:	009707bb          	addw	a5,a4,s1
    286a:	4057d69b          	sraiw	a3,a5,0x5
    286e:	0306869b          	addiw	a3,a3,48
    2872:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    2876:	8bfd                	andi	a5,a5,31
    2878:	9f99                	subw	a5,a5,a4
    287a:	0307879b          	addiw	a5,a5,48
    287e:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    2882:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    2886:	ba040513          	addi	a0,s0,-1120
    288a:	2ac020ef          	jal	4b36 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    288e:	60200593          	li	a1,1538
    2892:	ba040513          	addi	a0,s0,-1120
    2896:	290020ef          	jal	4b26 <open>
    if(fd < 0)
    289a:	00054763          	bltz	a0,28a8 <diskfull+0xd8>
    close(fd);
    289e:	270020ef          	jal	4b0e <close>
  for(int i = 0; i < nzz; i++){
    28a2:	2485                	addiw	s1,s1,1
    28a4:	fb3499e3          	bne	s1,s3,2856 <diskfull+0x86>
  if(mkdir("diskfulldir") == 0)
    28a8:	00004517          	auipc	a0,0x4
    28ac:	92050513          	addi	a0,a0,-1760 # 61c8 <malloc+0x1216>
    28b0:	29e020ef          	jal	4b4e <mkdir>
    28b4:	12050063          	beqz	a0,29d4 <diskfull+0x204>
  unlink("diskfulldir");
    28b8:	00004517          	auipc	a0,0x4
    28bc:	91050513          	addi	a0,a0,-1776 # 61c8 <malloc+0x1216>
    28c0:	276020ef          	jal	4b36 <unlink>
  for(int i = 0; i < nzz; i++){
    28c4:	4481                	li	s1,0
    name[0] = 'z';
    28c6:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    28ca:	08000993          	li	s3,128
    name[0] = 'z';
    28ce:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    28d2:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    28d6:	41f4d71b          	sraiw	a4,s1,0x1f
    28da:	01b7571b          	srliw	a4,a4,0x1b
    28de:	009707bb          	addw	a5,a4,s1
    28e2:	4057d69b          	sraiw	a3,a5,0x5
    28e6:	0306869b          	addiw	a3,a3,48
    28ea:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    28ee:	8bfd                	andi	a5,a5,31
    28f0:	9f99                	subw	a5,a5,a4
    28f2:	0307879b          	addiw	a5,a5,48
    28f6:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    28fa:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    28fe:	ba040513          	addi	a0,s0,-1120
    2902:	234020ef          	jal	4b36 <unlink>
  for(int i = 0; i < nzz; i++){
    2906:	2485                	addiw	s1,s1,1
    2908:	fd3493e3          	bne	s1,s3,28ce <diskfull+0xfe>
    290c:	03000493          	li	s1,48
    name[0] = 'b';
    2910:	06200a93          	li	s5,98
    name[1] = 'i';
    2914:	06900a13          	li	s4,105
    name[2] = 'g';
    2918:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    291c:	07f00913          	li	s2,127
    name[0] = 'b';
    2920:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    2924:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    2928:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    292c:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    2930:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    2934:	ba040513          	addi	a0,s0,-1120
    2938:	1fe020ef          	jal	4b36 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    293c:	2485                	addiw	s1,s1,1
    293e:	0ff4f493          	zext.b	s1,s1
    2942:	fd249fe3          	bne	s1,s2,2920 <diskfull+0x150>
}
    2946:	47813083          	ld	ra,1144(sp)
    294a:	47013403          	ld	s0,1136(sp)
    294e:	46813483          	ld	s1,1128(sp)
    2952:	46013903          	ld	s2,1120(sp)
    2956:	45813983          	ld	s3,1112(sp)
    295a:	45013a03          	ld	s4,1104(sp)
    295e:	44813a83          	ld	s5,1096(sp)
    2962:	44013b03          	ld	s6,1088(sp)
    2966:	43813b83          	ld	s7,1080(sp)
    296a:	43013c03          	ld	s8,1072(sp)
    296e:	42813c83          	ld	s9,1064(sp)
    2972:	48010113          	addi	sp,sp,1152
    2976:	8082                	ret
    close(fd);
    2978:	854a                	mv	a0,s2
    297a:	194020ef          	jal	4b0e <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    297e:	2985                	addiw	s3,s3,1
    2980:	0ff9f993          	zext.b	s3,s3
    2984:	ed8984e3          	beq	s3,s8,284c <diskfull+0x7c>
    name[0] = 'b';
    2988:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    298c:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    2990:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    2994:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    2998:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    299c:	b8040513          	addi	a0,s0,-1152
    29a0:	196020ef          	jal	4b36 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    29a4:	60200593          	li	a1,1538
    29a8:	b8040513          	addi	a0,s0,-1152
    29ac:	17a020ef          	jal	4b26 <open>
    29b0:	892a                	mv	s2,a0
    if(fd < 0){
    29b2:	e6054de3          	bltz	a0,282c <diskfull+0x5c>
    29b6:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    29b8:	40000613          	li	a2,1024
    29bc:	ba040593          	addi	a1,s0,-1120
    29c0:	854a                	mv	a0,s2
    29c2:	144020ef          	jal	4b06 <write>
    29c6:	40000793          	li	a5,1024
    29ca:	e6f51be3          	bne	a0,a5,2840 <diskfull+0x70>
    for(int i = 0; i < MAXFILE; i++){
    29ce:	34fd                	addiw	s1,s1,-1
    29d0:	f4e5                	bnez	s1,29b8 <diskfull+0x1e8>
    29d2:	b75d                	j	2978 <diskfull+0x1a8>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    29d4:	85e6                	mv	a1,s9
    29d6:	00004517          	auipc	a0,0x4
    29da:	82250513          	addi	a0,a0,-2014 # 61f8 <malloc+0x1246>
    29de:	520020ef          	jal	4efe <printf>
    29e2:	bdd9                	j	28b8 <diskfull+0xe8>

00000000000029e4 <iputtest>:
{
    29e4:	1101                	addi	sp,sp,-32
    29e6:	ec06                	sd	ra,24(sp)
    29e8:	e822                	sd	s0,16(sp)
    29ea:	e426                	sd	s1,8(sp)
    29ec:	1000                	addi	s0,sp,32
    29ee:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    29f0:	00004517          	auipc	a0,0x4
    29f4:	83850513          	addi	a0,a0,-1992 # 6228 <malloc+0x1276>
    29f8:	156020ef          	jal	4b4e <mkdir>
    29fc:	02054f63          	bltz	a0,2a3a <iputtest+0x56>
  if(chdir("iputdir") < 0){
    2a00:	00004517          	auipc	a0,0x4
    2a04:	82850513          	addi	a0,a0,-2008 # 6228 <malloc+0x1276>
    2a08:	14e020ef          	jal	4b56 <chdir>
    2a0c:	04054163          	bltz	a0,2a4e <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    2a10:	00004517          	auipc	a0,0x4
    2a14:	85850513          	addi	a0,a0,-1960 # 6268 <malloc+0x12b6>
    2a18:	11e020ef          	jal	4b36 <unlink>
    2a1c:	04054363          	bltz	a0,2a62 <iputtest+0x7e>
  if(chdir("/") < 0){
    2a20:	00004517          	auipc	a0,0x4
    2a24:	87850513          	addi	a0,a0,-1928 # 6298 <malloc+0x12e6>
    2a28:	12e020ef          	jal	4b56 <chdir>
    2a2c:	04054563          	bltz	a0,2a76 <iputtest+0x92>
}
    2a30:	60e2                	ld	ra,24(sp)
    2a32:	6442                	ld	s0,16(sp)
    2a34:	64a2                	ld	s1,8(sp)
    2a36:	6105                	addi	sp,sp,32
    2a38:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2a3a:	85a6                	mv	a1,s1
    2a3c:	00003517          	auipc	a0,0x3
    2a40:	7f450513          	addi	a0,a0,2036 # 6230 <malloc+0x127e>
    2a44:	4ba020ef          	jal	4efe <printf>
    exit(1);
    2a48:	4505                	li	a0,1
    2a4a:	09c020ef          	jal	4ae6 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2a4e:	85a6                	mv	a1,s1
    2a50:	00003517          	auipc	a0,0x3
    2a54:	7f850513          	addi	a0,a0,2040 # 6248 <malloc+0x1296>
    2a58:	4a6020ef          	jal	4efe <printf>
    exit(1);
    2a5c:	4505                	li	a0,1
    2a5e:	088020ef          	jal	4ae6 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a62:	85a6                	mv	a1,s1
    2a64:	00004517          	auipc	a0,0x4
    2a68:	81450513          	addi	a0,a0,-2028 # 6278 <malloc+0x12c6>
    2a6c:	492020ef          	jal	4efe <printf>
    exit(1);
    2a70:	4505                	li	a0,1
    2a72:	074020ef          	jal	4ae6 <exit>
    printf("%s: chdir / failed\n", s);
    2a76:	85a6                	mv	a1,s1
    2a78:	00004517          	auipc	a0,0x4
    2a7c:	82850513          	addi	a0,a0,-2008 # 62a0 <malloc+0x12ee>
    2a80:	47e020ef          	jal	4efe <printf>
    exit(1);
    2a84:	4505                	li	a0,1
    2a86:	060020ef          	jal	4ae6 <exit>

0000000000002a8a <exitiputtest>:
{
    2a8a:	7179                	addi	sp,sp,-48
    2a8c:	f406                	sd	ra,40(sp)
    2a8e:	f022                	sd	s0,32(sp)
    2a90:	ec26                	sd	s1,24(sp)
    2a92:	1800                	addi	s0,sp,48
    2a94:	84aa                	mv	s1,a0
  pid = fork();
    2a96:	048020ef          	jal	4ade <fork>
  if(pid < 0){
    2a9a:	02054e63          	bltz	a0,2ad6 <exitiputtest+0x4c>
  if(pid == 0){
    2a9e:	e541                	bnez	a0,2b26 <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2aa0:	00003517          	auipc	a0,0x3
    2aa4:	78850513          	addi	a0,a0,1928 # 6228 <malloc+0x1276>
    2aa8:	0a6020ef          	jal	4b4e <mkdir>
    2aac:	02054f63          	bltz	a0,2aea <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2ab0:	00003517          	auipc	a0,0x3
    2ab4:	77850513          	addi	a0,a0,1912 # 6228 <malloc+0x1276>
    2ab8:	09e020ef          	jal	4b56 <chdir>
    2abc:	04054163          	bltz	a0,2afe <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2ac0:	00003517          	auipc	a0,0x3
    2ac4:	7a850513          	addi	a0,a0,1960 # 6268 <malloc+0x12b6>
    2ac8:	06e020ef          	jal	4b36 <unlink>
    2acc:	04054363          	bltz	a0,2b12 <exitiputtest+0x88>
    exit(0);
    2ad0:	4501                	li	a0,0
    2ad2:	014020ef          	jal	4ae6 <exit>
    printf("%s: fork failed\n", s);
    2ad6:	85a6                	mv	a1,s1
    2ad8:	00003517          	auipc	a0,0x3
    2adc:	ea050513          	addi	a0,a0,-352 # 5978 <malloc+0x9c6>
    2ae0:	41e020ef          	jal	4efe <printf>
    exit(1);
    2ae4:	4505                	li	a0,1
    2ae6:	000020ef          	jal	4ae6 <exit>
      printf("%s: mkdir failed\n", s);
    2aea:	85a6                	mv	a1,s1
    2aec:	00003517          	auipc	a0,0x3
    2af0:	74450513          	addi	a0,a0,1860 # 6230 <malloc+0x127e>
    2af4:	40a020ef          	jal	4efe <printf>
      exit(1);
    2af8:	4505                	li	a0,1
    2afa:	7ed010ef          	jal	4ae6 <exit>
      printf("%s: child chdir failed\n", s);
    2afe:	85a6                	mv	a1,s1
    2b00:	00003517          	auipc	a0,0x3
    2b04:	7b850513          	addi	a0,a0,1976 # 62b8 <malloc+0x1306>
    2b08:	3f6020ef          	jal	4efe <printf>
      exit(1);
    2b0c:	4505                	li	a0,1
    2b0e:	7d9010ef          	jal	4ae6 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2b12:	85a6                	mv	a1,s1
    2b14:	00003517          	auipc	a0,0x3
    2b18:	76450513          	addi	a0,a0,1892 # 6278 <malloc+0x12c6>
    2b1c:	3e2020ef          	jal	4efe <printf>
      exit(1);
    2b20:	4505                	li	a0,1
    2b22:	7c5010ef          	jal	4ae6 <exit>
  wait(&xstatus);
    2b26:	fdc40513          	addi	a0,s0,-36
    2b2a:	7c5010ef          	jal	4aee <wait>
  exit(xstatus);
    2b2e:	fdc42503          	lw	a0,-36(s0)
    2b32:	7b5010ef          	jal	4ae6 <exit>

0000000000002b36 <dirtest>:
{
    2b36:	1101                	addi	sp,sp,-32
    2b38:	ec06                	sd	ra,24(sp)
    2b3a:	e822                	sd	s0,16(sp)
    2b3c:	e426                	sd	s1,8(sp)
    2b3e:	1000                	addi	s0,sp,32
    2b40:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2b42:	00003517          	auipc	a0,0x3
    2b46:	78e50513          	addi	a0,a0,1934 # 62d0 <malloc+0x131e>
    2b4a:	004020ef          	jal	4b4e <mkdir>
    2b4e:	02054f63          	bltz	a0,2b8c <dirtest+0x56>
  if(chdir("dir0") < 0){
    2b52:	00003517          	auipc	a0,0x3
    2b56:	77e50513          	addi	a0,a0,1918 # 62d0 <malloc+0x131e>
    2b5a:	7fd010ef          	jal	4b56 <chdir>
    2b5e:	04054163          	bltz	a0,2ba0 <dirtest+0x6a>
  if(chdir("..") < 0){
    2b62:	00003517          	auipc	a0,0x3
    2b66:	78e50513          	addi	a0,a0,1934 # 62f0 <malloc+0x133e>
    2b6a:	7ed010ef          	jal	4b56 <chdir>
    2b6e:	04054363          	bltz	a0,2bb4 <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2b72:	00003517          	auipc	a0,0x3
    2b76:	75e50513          	addi	a0,a0,1886 # 62d0 <malloc+0x131e>
    2b7a:	7bd010ef          	jal	4b36 <unlink>
    2b7e:	04054563          	bltz	a0,2bc8 <dirtest+0x92>
}
    2b82:	60e2                	ld	ra,24(sp)
    2b84:	6442                	ld	s0,16(sp)
    2b86:	64a2                	ld	s1,8(sp)
    2b88:	6105                	addi	sp,sp,32
    2b8a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b8c:	85a6                	mv	a1,s1
    2b8e:	00003517          	auipc	a0,0x3
    2b92:	6a250513          	addi	a0,a0,1698 # 6230 <malloc+0x127e>
    2b96:	368020ef          	jal	4efe <printf>
    exit(1);
    2b9a:	4505                	li	a0,1
    2b9c:	74b010ef          	jal	4ae6 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2ba0:	85a6                	mv	a1,s1
    2ba2:	00003517          	auipc	a0,0x3
    2ba6:	73650513          	addi	a0,a0,1846 # 62d8 <malloc+0x1326>
    2baa:	354020ef          	jal	4efe <printf>
    exit(1);
    2bae:	4505                	li	a0,1
    2bb0:	737010ef          	jal	4ae6 <exit>
    printf("%s: chdir .. failed\n", s);
    2bb4:	85a6                	mv	a1,s1
    2bb6:	00003517          	auipc	a0,0x3
    2bba:	74250513          	addi	a0,a0,1858 # 62f8 <malloc+0x1346>
    2bbe:	340020ef          	jal	4efe <printf>
    exit(1);
    2bc2:	4505                	li	a0,1
    2bc4:	723010ef          	jal	4ae6 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2bc8:	85a6                	mv	a1,s1
    2bca:	00003517          	auipc	a0,0x3
    2bce:	74650513          	addi	a0,a0,1862 # 6310 <malloc+0x135e>
    2bd2:	32c020ef          	jal	4efe <printf>
    exit(1);
    2bd6:	4505                	li	a0,1
    2bd8:	70f010ef          	jal	4ae6 <exit>

0000000000002bdc <subdir>:
{
    2bdc:	1101                	addi	sp,sp,-32
    2bde:	ec06                	sd	ra,24(sp)
    2be0:	e822                	sd	s0,16(sp)
    2be2:	e426                	sd	s1,8(sp)
    2be4:	e04a                	sd	s2,0(sp)
    2be6:	1000                	addi	s0,sp,32
    2be8:	892a                	mv	s2,a0
  unlink("ff");
    2bea:	00004517          	auipc	a0,0x4
    2bee:	86e50513          	addi	a0,a0,-1938 # 6458 <malloc+0x14a6>
    2bf2:	745010ef          	jal	4b36 <unlink>
  if(mkdir("dd") != 0){
    2bf6:	00003517          	auipc	a0,0x3
    2bfa:	73250513          	addi	a0,a0,1842 # 6328 <malloc+0x1376>
    2bfe:	751010ef          	jal	4b4e <mkdir>
    2c02:	2e051263          	bnez	a0,2ee6 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2c06:	20200593          	li	a1,514
    2c0a:	00003517          	auipc	a0,0x3
    2c0e:	73e50513          	addi	a0,a0,1854 # 6348 <malloc+0x1396>
    2c12:	715010ef          	jal	4b26 <open>
    2c16:	84aa                	mv	s1,a0
  if(fd < 0){
    2c18:	2e054163          	bltz	a0,2efa <subdir+0x31e>
  write(fd, "ff", 2);
    2c1c:	4609                	li	a2,2
    2c1e:	00004597          	auipc	a1,0x4
    2c22:	83a58593          	addi	a1,a1,-1990 # 6458 <malloc+0x14a6>
    2c26:	6e1010ef          	jal	4b06 <write>
  close(fd);
    2c2a:	8526                	mv	a0,s1
    2c2c:	6e3010ef          	jal	4b0e <close>
  if(unlink("dd") >= 0){
    2c30:	00003517          	auipc	a0,0x3
    2c34:	6f850513          	addi	a0,a0,1784 # 6328 <malloc+0x1376>
    2c38:	6ff010ef          	jal	4b36 <unlink>
    2c3c:	2c055963          	bgez	a0,2f0e <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2c40:	00003517          	auipc	a0,0x3
    2c44:	76050513          	addi	a0,a0,1888 # 63a0 <malloc+0x13ee>
    2c48:	707010ef          	jal	4b4e <mkdir>
    2c4c:	2c051b63          	bnez	a0,2f22 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2c50:	20200593          	li	a1,514
    2c54:	00003517          	auipc	a0,0x3
    2c58:	77450513          	addi	a0,a0,1908 # 63c8 <malloc+0x1416>
    2c5c:	6cb010ef          	jal	4b26 <open>
    2c60:	84aa                	mv	s1,a0
  if(fd < 0){
    2c62:	2c054a63          	bltz	a0,2f36 <subdir+0x35a>
  write(fd, "FF", 2);
    2c66:	4609                	li	a2,2
    2c68:	00003597          	auipc	a1,0x3
    2c6c:	79058593          	addi	a1,a1,1936 # 63f8 <malloc+0x1446>
    2c70:	697010ef          	jal	4b06 <write>
  close(fd);
    2c74:	8526                	mv	a0,s1
    2c76:	699010ef          	jal	4b0e <close>
  fd = open("dd/dd/../ff", 0);
    2c7a:	4581                	li	a1,0
    2c7c:	00003517          	auipc	a0,0x3
    2c80:	78450513          	addi	a0,a0,1924 # 6400 <malloc+0x144e>
    2c84:	6a3010ef          	jal	4b26 <open>
    2c88:	84aa                	mv	s1,a0
  if(fd < 0){
    2c8a:	2c054063          	bltz	a0,2f4a <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c8e:	660d                	lui	a2,0x3
    2c90:	0000a597          	auipc	a1,0xa
    2c94:	fe858593          	addi	a1,a1,-24 # cc78 <buf>
    2c98:	667010ef          	jal	4afe <read>
  if(cc != 2 || buf[0] != 'f'){
    2c9c:	4789                	li	a5,2
    2c9e:	2cf51063          	bne	a0,a5,2f5e <subdir+0x382>
    2ca2:	0000a717          	auipc	a4,0xa
    2ca6:	fd674703          	lbu	a4,-42(a4) # cc78 <buf>
    2caa:	06600793          	li	a5,102
    2cae:	2af71863          	bne	a4,a5,2f5e <subdir+0x382>
  close(fd);
    2cb2:	8526                	mv	a0,s1
    2cb4:	65b010ef          	jal	4b0e <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2cb8:	00003597          	auipc	a1,0x3
    2cbc:	79858593          	addi	a1,a1,1944 # 6450 <malloc+0x149e>
    2cc0:	00003517          	auipc	a0,0x3
    2cc4:	70850513          	addi	a0,a0,1800 # 63c8 <malloc+0x1416>
    2cc8:	67f010ef          	jal	4b46 <link>
    2ccc:	2a051363          	bnez	a0,2f72 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2cd0:	00003517          	auipc	a0,0x3
    2cd4:	6f850513          	addi	a0,a0,1784 # 63c8 <malloc+0x1416>
    2cd8:	65f010ef          	jal	4b36 <unlink>
    2cdc:	2a051563          	bnez	a0,2f86 <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2ce0:	4581                	li	a1,0
    2ce2:	00003517          	auipc	a0,0x3
    2ce6:	6e650513          	addi	a0,a0,1766 # 63c8 <malloc+0x1416>
    2cea:	63d010ef          	jal	4b26 <open>
    2cee:	2a055663          	bgez	a0,2f9a <subdir+0x3be>
  if(chdir("dd") != 0){
    2cf2:	00003517          	auipc	a0,0x3
    2cf6:	63650513          	addi	a0,a0,1590 # 6328 <malloc+0x1376>
    2cfa:	65d010ef          	jal	4b56 <chdir>
    2cfe:	2a051863          	bnez	a0,2fae <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2d02:	00003517          	auipc	a0,0x3
    2d06:	7e650513          	addi	a0,a0,2022 # 64e8 <malloc+0x1536>
    2d0a:	64d010ef          	jal	4b56 <chdir>
    2d0e:	2a051a63          	bnez	a0,2fc2 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2d12:	00004517          	auipc	a0,0x4
    2d16:	80650513          	addi	a0,a0,-2042 # 6518 <malloc+0x1566>
    2d1a:	63d010ef          	jal	4b56 <chdir>
    2d1e:	2a051c63          	bnez	a0,2fd6 <subdir+0x3fa>
  if(chdir("./..") != 0){
    2d22:	00004517          	auipc	a0,0x4
    2d26:	82e50513          	addi	a0,a0,-2002 # 6550 <malloc+0x159e>
    2d2a:	62d010ef          	jal	4b56 <chdir>
    2d2e:	2a051e63          	bnez	a0,2fea <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2d32:	4581                	li	a1,0
    2d34:	00003517          	auipc	a0,0x3
    2d38:	71c50513          	addi	a0,a0,1820 # 6450 <malloc+0x149e>
    2d3c:	5eb010ef          	jal	4b26 <open>
    2d40:	84aa                	mv	s1,a0
  if(fd < 0){
    2d42:	2a054e63          	bltz	a0,2ffe <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2d46:	660d                	lui	a2,0x3
    2d48:	0000a597          	auipc	a1,0xa
    2d4c:	f3058593          	addi	a1,a1,-208 # cc78 <buf>
    2d50:	5af010ef          	jal	4afe <read>
    2d54:	4789                	li	a5,2
    2d56:	2af51e63          	bne	a0,a5,3012 <subdir+0x436>
  close(fd);
    2d5a:	8526                	mv	a0,s1
    2d5c:	5b3010ef          	jal	4b0e <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2d60:	4581                	li	a1,0
    2d62:	00003517          	auipc	a0,0x3
    2d66:	66650513          	addi	a0,a0,1638 # 63c8 <malloc+0x1416>
    2d6a:	5bd010ef          	jal	4b26 <open>
    2d6e:	2a055c63          	bgez	a0,3026 <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2d72:	20200593          	li	a1,514
    2d76:	00004517          	auipc	a0,0x4
    2d7a:	86a50513          	addi	a0,a0,-1942 # 65e0 <malloc+0x162e>
    2d7e:	5a9010ef          	jal	4b26 <open>
    2d82:	2a055c63          	bgez	a0,303a <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2d86:	20200593          	li	a1,514
    2d8a:	00004517          	auipc	a0,0x4
    2d8e:	88650513          	addi	a0,a0,-1914 # 6610 <malloc+0x165e>
    2d92:	595010ef          	jal	4b26 <open>
    2d96:	2a055c63          	bgez	a0,304e <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2d9a:	20000593          	li	a1,512
    2d9e:	00003517          	auipc	a0,0x3
    2da2:	58a50513          	addi	a0,a0,1418 # 6328 <malloc+0x1376>
    2da6:	581010ef          	jal	4b26 <open>
    2daa:	2a055c63          	bgez	a0,3062 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2dae:	4589                	li	a1,2
    2db0:	00003517          	auipc	a0,0x3
    2db4:	57850513          	addi	a0,a0,1400 # 6328 <malloc+0x1376>
    2db8:	56f010ef          	jal	4b26 <open>
    2dbc:	2a055d63          	bgez	a0,3076 <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2dc0:	4585                	li	a1,1
    2dc2:	00003517          	auipc	a0,0x3
    2dc6:	56650513          	addi	a0,a0,1382 # 6328 <malloc+0x1376>
    2dca:	55d010ef          	jal	4b26 <open>
    2dce:	2a055e63          	bgez	a0,308a <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2dd2:	00004597          	auipc	a1,0x4
    2dd6:	8ce58593          	addi	a1,a1,-1842 # 66a0 <malloc+0x16ee>
    2dda:	00004517          	auipc	a0,0x4
    2dde:	80650513          	addi	a0,a0,-2042 # 65e0 <malloc+0x162e>
    2de2:	565010ef          	jal	4b46 <link>
    2de6:	2a050c63          	beqz	a0,309e <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2dea:	00004597          	auipc	a1,0x4
    2dee:	8b658593          	addi	a1,a1,-1866 # 66a0 <malloc+0x16ee>
    2df2:	00004517          	auipc	a0,0x4
    2df6:	81e50513          	addi	a0,a0,-2018 # 6610 <malloc+0x165e>
    2dfa:	54d010ef          	jal	4b46 <link>
    2dfe:	2a050a63          	beqz	a0,30b2 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2e02:	00003597          	auipc	a1,0x3
    2e06:	64e58593          	addi	a1,a1,1614 # 6450 <malloc+0x149e>
    2e0a:	00003517          	auipc	a0,0x3
    2e0e:	53e50513          	addi	a0,a0,1342 # 6348 <malloc+0x1396>
    2e12:	535010ef          	jal	4b46 <link>
    2e16:	2a050863          	beqz	a0,30c6 <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2e1a:	00003517          	auipc	a0,0x3
    2e1e:	7c650513          	addi	a0,a0,1990 # 65e0 <malloc+0x162e>
    2e22:	52d010ef          	jal	4b4e <mkdir>
    2e26:	2a050a63          	beqz	a0,30da <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2e2a:	00003517          	auipc	a0,0x3
    2e2e:	7e650513          	addi	a0,a0,2022 # 6610 <malloc+0x165e>
    2e32:	51d010ef          	jal	4b4e <mkdir>
    2e36:	2a050c63          	beqz	a0,30ee <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2e3a:	00003517          	auipc	a0,0x3
    2e3e:	61650513          	addi	a0,a0,1558 # 6450 <malloc+0x149e>
    2e42:	50d010ef          	jal	4b4e <mkdir>
    2e46:	2a050e63          	beqz	a0,3102 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2e4a:	00003517          	auipc	a0,0x3
    2e4e:	7c650513          	addi	a0,a0,1990 # 6610 <malloc+0x165e>
    2e52:	4e5010ef          	jal	4b36 <unlink>
    2e56:	2c050063          	beqz	a0,3116 <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2e5a:	00003517          	auipc	a0,0x3
    2e5e:	78650513          	addi	a0,a0,1926 # 65e0 <malloc+0x162e>
    2e62:	4d5010ef          	jal	4b36 <unlink>
    2e66:	2c050263          	beqz	a0,312a <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2e6a:	00003517          	auipc	a0,0x3
    2e6e:	4de50513          	addi	a0,a0,1246 # 6348 <malloc+0x1396>
    2e72:	4e5010ef          	jal	4b56 <chdir>
    2e76:	2c050463          	beqz	a0,313e <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2e7a:	00004517          	auipc	a0,0x4
    2e7e:	97650513          	addi	a0,a0,-1674 # 67f0 <malloc+0x183e>
    2e82:	4d5010ef          	jal	4b56 <chdir>
    2e86:	2c050663          	beqz	a0,3152 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2e8a:	00003517          	auipc	a0,0x3
    2e8e:	5c650513          	addi	a0,a0,1478 # 6450 <malloc+0x149e>
    2e92:	4a5010ef          	jal	4b36 <unlink>
    2e96:	2c051863          	bnez	a0,3166 <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2e9a:	00003517          	auipc	a0,0x3
    2e9e:	4ae50513          	addi	a0,a0,1198 # 6348 <malloc+0x1396>
    2ea2:	495010ef          	jal	4b36 <unlink>
    2ea6:	2c051a63          	bnez	a0,317a <subdir+0x59e>
  if(unlink("dd") == 0){
    2eaa:	00003517          	auipc	a0,0x3
    2eae:	47e50513          	addi	a0,a0,1150 # 6328 <malloc+0x1376>
    2eb2:	485010ef          	jal	4b36 <unlink>
    2eb6:	2c050c63          	beqz	a0,318e <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2eba:	00004517          	auipc	a0,0x4
    2ebe:	9a650513          	addi	a0,a0,-1626 # 6860 <malloc+0x18ae>
    2ec2:	475010ef          	jal	4b36 <unlink>
    2ec6:	2c054e63          	bltz	a0,31a2 <subdir+0x5c6>
  if(unlink("dd") < 0){
    2eca:	00003517          	auipc	a0,0x3
    2ece:	45e50513          	addi	a0,a0,1118 # 6328 <malloc+0x1376>
    2ed2:	465010ef          	jal	4b36 <unlink>
    2ed6:	2e054063          	bltz	a0,31b6 <subdir+0x5da>
}
    2eda:	60e2                	ld	ra,24(sp)
    2edc:	6442                	ld	s0,16(sp)
    2ede:	64a2                	ld	s1,8(sp)
    2ee0:	6902                	ld	s2,0(sp)
    2ee2:	6105                	addi	sp,sp,32
    2ee4:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2ee6:	85ca                	mv	a1,s2
    2ee8:	00003517          	auipc	a0,0x3
    2eec:	44850513          	addi	a0,a0,1096 # 6330 <malloc+0x137e>
    2ef0:	00e020ef          	jal	4efe <printf>
    exit(1);
    2ef4:	4505                	li	a0,1
    2ef6:	3f1010ef          	jal	4ae6 <exit>
    printf("%s: create dd/ff failed\n", s);
    2efa:	85ca                	mv	a1,s2
    2efc:	00003517          	auipc	a0,0x3
    2f00:	45450513          	addi	a0,a0,1108 # 6350 <malloc+0x139e>
    2f04:	7fb010ef          	jal	4efe <printf>
    exit(1);
    2f08:	4505                	li	a0,1
    2f0a:	3dd010ef          	jal	4ae6 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2f0e:	85ca                	mv	a1,s2
    2f10:	00003517          	auipc	a0,0x3
    2f14:	46050513          	addi	a0,a0,1120 # 6370 <malloc+0x13be>
    2f18:	7e7010ef          	jal	4efe <printf>
    exit(1);
    2f1c:	4505                	li	a0,1
    2f1e:	3c9010ef          	jal	4ae6 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2f22:	85ca                	mv	a1,s2
    2f24:	00003517          	auipc	a0,0x3
    2f28:	48450513          	addi	a0,a0,1156 # 63a8 <malloc+0x13f6>
    2f2c:	7d3010ef          	jal	4efe <printf>
    exit(1);
    2f30:	4505                	li	a0,1
    2f32:	3b5010ef          	jal	4ae6 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2f36:	85ca                	mv	a1,s2
    2f38:	00003517          	auipc	a0,0x3
    2f3c:	4a050513          	addi	a0,a0,1184 # 63d8 <malloc+0x1426>
    2f40:	7bf010ef          	jal	4efe <printf>
    exit(1);
    2f44:	4505                	li	a0,1
    2f46:	3a1010ef          	jal	4ae6 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2f4a:	85ca                	mv	a1,s2
    2f4c:	00003517          	auipc	a0,0x3
    2f50:	4c450513          	addi	a0,a0,1220 # 6410 <malloc+0x145e>
    2f54:	7ab010ef          	jal	4efe <printf>
    exit(1);
    2f58:	4505                	li	a0,1
    2f5a:	38d010ef          	jal	4ae6 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f5e:	85ca                	mv	a1,s2
    2f60:	00003517          	auipc	a0,0x3
    2f64:	4d050513          	addi	a0,a0,1232 # 6430 <malloc+0x147e>
    2f68:	797010ef          	jal	4efe <printf>
    exit(1);
    2f6c:	4505                	li	a0,1
    2f6e:	379010ef          	jal	4ae6 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f72:	85ca                	mv	a1,s2
    2f74:	00003517          	auipc	a0,0x3
    2f78:	4ec50513          	addi	a0,a0,1260 # 6460 <malloc+0x14ae>
    2f7c:	783010ef          	jal	4efe <printf>
    exit(1);
    2f80:	4505                	li	a0,1
    2f82:	365010ef          	jal	4ae6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f86:	85ca                	mv	a1,s2
    2f88:	00003517          	auipc	a0,0x3
    2f8c:	50050513          	addi	a0,a0,1280 # 6488 <malloc+0x14d6>
    2f90:	76f010ef          	jal	4efe <printf>
    exit(1);
    2f94:	4505                	li	a0,1
    2f96:	351010ef          	jal	4ae6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f9a:	85ca                	mv	a1,s2
    2f9c:	00003517          	auipc	a0,0x3
    2fa0:	50c50513          	addi	a0,a0,1292 # 64a8 <malloc+0x14f6>
    2fa4:	75b010ef          	jal	4efe <printf>
    exit(1);
    2fa8:	4505                	li	a0,1
    2faa:	33d010ef          	jal	4ae6 <exit>
    printf("%s: chdir dd failed\n", s);
    2fae:	85ca                	mv	a1,s2
    2fb0:	00003517          	auipc	a0,0x3
    2fb4:	52050513          	addi	a0,a0,1312 # 64d0 <malloc+0x151e>
    2fb8:	747010ef          	jal	4efe <printf>
    exit(1);
    2fbc:	4505                	li	a0,1
    2fbe:	329010ef          	jal	4ae6 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2fc2:	85ca                	mv	a1,s2
    2fc4:	00003517          	auipc	a0,0x3
    2fc8:	53450513          	addi	a0,a0,1332 # 64f8 <malloc+0x1546>
    2fcc:	733010ef          	jal	4efe <printf>
    exit(1);
    2fd0:	4505                	li	a0,1
    2fd2:	315010ef          	jal	4ae6 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2fd6:	85ca                	mv	a1,s2
    2fd8:	00003517          	auipc	a0,0x3
    2fdc:	55050513          	addi	a0,a0,1360 # 6528 <malloc+0x1576>
    2fe0:	71f010ef          	jal	4efe <printf>
    exit(1);
    2fe4:	4505                	li	a0,1
    2fe6:	301010ef          	jal	4ae6 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2fea:	85ca                	mv	a1,s2
    2fec:	00003517          	auipc	a0,0x3
    2ff0:	56c50513          	addi	a0,a0,1388 # 6558 <malloc+0x15a6>
    2ff4:	70b010ef          	jal	4efe <printf>
    exit(1);
    2ff8:	4505                	li	a0,1
    2ffa:	2ed010ef          	jal	4ae6 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2ffe:	85ca                	mv	a1,s2
    3000:	00003517          	auipc	a0,0x3
    3004:	57050513          	addi	a0,a0,1392 # 6570 <malloc+0x15be>
    3008:	6f7010ef          	jal	4efe <printf>
    exit(1);
    300c:	4505                	li	a0,1
    300e:	2d9010ef          	jal	4ae6 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3012:	85ca                	mv	a1,s2
    3014:	00003517          	auipc	a0,0x3
    3018:	57c50513          	addi	a0,a0,1404 # 6590 <malloc+0x15de>
    301c:	6e3010ef          	jal	4efe <printf>
    exit(1);
    3020:	4505                	li	a0,1
    3022:	2c5010ef          	jal	4ae6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3026:	85ca                	mv	a1,s2
    3028:	00003517          	auipc	a0,0x3
    302c:	58850513          	addi	a0,a0,1416 # 65b0 <malloc+0x15fe>
    3030:	6cf010ef          	jal	4efe <printf>
    exit(1);
    3034:	4505                	li	a0,1
    3036:	2b1010ef          	jal	4ae6 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    303a:	85ca                	mv	a1,s2
    303c:	00003517          	auipc	a0,0x3
    3040:	5b450513          	addi	a0,a0,1460 # 65f0 <malloc+0x163e>
    3044:	6bb010ef          	jal	4efe <printf>
    exit(1);
    3048:	4505                	li	a0,1
    304a:	29d010ef          	jal	4ae6 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    304e:	85ca                	mv	a1,s2
    3050:	00003517          	auipc	a0,0x3
    3054:	5d050513          	addi	a0,a0,1488 # 6620 <malloc+0x166e>
    3058:	6a7010ef          	jal	4efe <printf>
    exit(1);
    305c:	4505                	li	a0,1
    305e:	289010ef          	jal	4ae6 <exit>
    printf("%s: create dd succeeded!\n", s);
    3062:	85ca                	mv	a1,s2
    3064:	00003517          	auipc	a0,0x3
    3068:	5dc50513          	addi	a0,a0,1500 # 6640 <malloc+0x168e>
    306c:	693010ef          	jal	4efe <printf>
    exit(1);
    3070:	4505                	li	a0,1
    3072:	275010ef          	jal	4ae6 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3076:	85ca                	mv	a1,s2
    3078:	00003517          	auipc	a0,0x3
    307c:	5e850513          	addi	a0,a0,1512 # 6660 <malloc+0x16ae>
    3080:	67f010ef          	jal	4efe <printf>
    exit(1);
    3084:	4505                	li	a0,1
    3086:	261010ef          	jal	4ae6 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    308a:	85ca                	mv	a1,s2
    308c:	00003517          	auipc	a0,0x3
    3090:	5f450513          	addi	a0,a0,1524 # 6680 <malloc+0x16ce>
    3094:	66b010ef          	jal	4efe <printf>
    exit(1);
    3098:	4505                	li	a0,1
    309a:	24d010ef          	jal	4ae6 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    309e:	85ca                	mv	a1,s2
    30a0:	00003517          	auipc	a0,0x3
    30a4:	61050513          	addi	a0,a0,1552 # 66b0 <malloc+0x16fe>
    30a8:	657010ef          	jal	4efe <printf>
    exit(1);
    30ac:	4505                	li	a0,1
    30ae:	239010ef          	jal	4ae6 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    30b2:	85ca                	mv	a1,s2
    30b4:	00003517          	auipc	a0,0x3
    30b8:	62450513          	addi	a0,a0,1572 # 66d8 <malloc+0x1726>
    30bc:	643010ef          	jal	4efe <printf>
    exit(1);
    30c0:	4505                	li	a0,1
    30c2:	225010ef          	jal	4ae6 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    30c6:	85ca                	mv	a1,s2
    30c8:	00003517          	auipc	a0,0x3
    30cc:	63850513          	addi	a0,a0,1592 # 6700 <malloc+0x174e>
    30d0:	62f010ef          	jal	4efe <printf>
    exit(1);
    30d4:	4505                	li	a0,1
    30d6:	211010ef          	jal	4ae6 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    30da:	85ca                	mv	a1,s2
    30dc:	00003517          	auipc	a0,0x3
    30e0:	64c50513          	addi	a0,a0,1612 # 6728 <malloc+0x1776>
    30e4:	61b010ef          	jal	4efe <printf>
    exit(1);
    30e8:	4505                	li	a0,1
    30ea:	1fd010ef          	jal	4ae6 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    30ee:	85ca                	mv	a1,s2
    30f0:	00003517          	auipc	a0,0x3
    30f4:	65850513          	addi	a0,a0,1624 # 6748 <malloc+0x1796>
    30f8:	607010ef          	jal	4efe <printf>
    exit(1);
    30fc:	4505                	li	a0,1
    30fe:	1e9010ef          	jal	4ae6 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3102:	85ca                	mv	a1,s2
    3104:	00003517          	auipc	a0,0x3
    3108:	66450513          	addi	a0,a0,1636 # 6768 <malloc+0x17b6>
    310c:	5f3010ef          	jal	4efe <printf>
    exit(1);
    3110:	4505                	li	a0,1
    3112:	1d5010ef          	jal	4ae6 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3116:	85ca                	mv	a1,s2
    3118:	00003517          	auipc	a0,0x3
    311c:	67850513          	addi	a0,a0,1656 # 6790 <malloc+0x17de>
    3120:	5df010ef          	jal	4efe <printf>
    exit(1);
    3124:	4505                	li	a0,1
    3126:	1c1010ef          	jal	4ae6 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    312a:	85ca                	mv	a1,s2
    312c:	00003517          	auipc	a0,0x3
    3130:	68450513          	addi	a0,a0,1668 # 67b0 <malloc+0x17fe>
    3134:	5cb010ef          	jal	4efe <printf>
    exit(1);
    3138:	4505                	li	a0,1
    313a:	1ad010ef          	jal	4ae6 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    313e:	85ca                	mv	a1,s2
    3140:	00003517          	auipc	a0,0x3
    3144:	69050513          	addi	a0,a0,1680 # 67d0 <malloc+0x181e>
    3148:	5b7010ef          	jal	4efe <printf>
    exit(1);
    314c:	4505                	li	a0,1
    314e:	199010ef          	jal	4ae6 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3152:	85ca                	mv	a1,s2
    3154:	00003517          	auipc	a0,0x3
    3158:	6a450513          	addi	a0,a0,1700 # 67f8 <malloc+0x1846>
    315c:	5a3010ef          	jal	4efe <printf>
    exit(1);
    3160:	4505                	li	a0,1
    3162:	185010ef          	jal	4ae6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3166:	85ca                	mv	a1,s2
    3168:	00003517          	auipc	a0,0x3
    316c:	32050513          	addi	a0,a0,800 # 6488 <malloc+0x14d6>
    3170:	58f010ef          	jal	4efe <printf>
    exit(1);
    3174:	4505                	li	a0,1
    3176:	171010ef          	jal	4ae6 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    317a:	85ca                	mv	a1,s2
    317c:	00003517          	auipc	a0,0x3
    3180:	69c50513          	addi	a0,a0,1692 # 6818 <malloc+0x1866>
    3184:	57b010ef          	jal	4efe <printf>
    exit(1);
    3188:	4505                	li	a0,1
    318a:	15d010ef          	jal	4ae6 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    318e:	85ca                	mv	a1,s2
    3190:	00003517          	auipc	a0,0x3
    3194:	6a850513          	addi	a0,a0,1704 # 6838 <malloc+0x1886>
    3198:	567010ef          	jal	4efe <printf>
    exit(1);
    319c:	4505                	li	a0,1
    319e:	149010ef          	jal	4ae6 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    31a2:	85ca                	mv	a1,s2
    31a4:	00003517          	auipc	a0,0x3
    31a8:	6c450513          	addi	a0,a0,1732 # 6868 <malloc+0x18b6>
    31ac:	553010ef          	jal	4efe <printf>
    exit(1);
    31b0:	4505                	li	a0,1
    31b2:	135010ef          	jal	4ae6 <exit>
    printf("%s: unlink dd failed\n", s);
    31b6:	85ca                	mv	a1,s2
    31b8:	00003517          	auipc	a0,0x3
    31bc:	6d050513          	addi	a0,a0,1744 # 6888 <malloc+0x18d6>
    31c0:	53f010ef          	jal	4efe <printf>
    exit(1);
    31c4:	4505                	li	a0,1
    31c6:	121010ef          	jal	4ae6 <exit>

00000000000031ca <rmdot>:
{
    31ca:	1101                	addi	sp,sp,-32
    31cc:	ec06                	sd	ra,24(sp)
    31ce:	e822                	sd	s0,16(sp)
    31d0:	e426                	sd	s1,8(sp)
    31d2:	1000                	addi	s0,sp,32
    31d4:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    31d6:	00003517          	auipc	a0,0x3
    31da:	6ca50513          	addi	a0,a0,1738 # 68a0 <malloc+0x18ee>
    31de:	171010ef          	jal	4b4e <mkdir>
    31e2:	e53d                	bnez	a0,3250 <rmdot+0x86>
  if(chdir("dots") != 0){
    31e4:	00003517          	auipc	a0,0x3
    31e8:	6bc50513          	addi	a0,a0,1724 # 68a0 <malloc+0x18ee>
    31ec:	16b010ef          	jal	4b56 <chdir>
    31f0:	e935                	bnez	a0,3264 <rmdot+0x9a>
  if(unlink(".") == 0){
    31f2:	00002517          	auipc	a0,0x2
    31f6:	5de50513          	addi	a0,a0,1502 # 57d0 <malloc+0x81e>
    31fa:	13d010ef          	jal	4b36 <unlink>
    31fe:	cd2d                	beqz	a0,3278 <rmdot+0xae>
  if(unlink("..") == 0){
    3200:	00003517          	auipc	a0,0x3
    3204:	0f050513          	addi	a0,a0,240 # 62f0 <malloc+0x133e>
    3208:	12f010ef          	jal	4b36 <unlink>
    320c:	c141                	beqz	a0,328c <rmdot+0xc2>
  if(chdir("/") != 0){
    320e:	00003517          	auipc	a0,0x3
    3212:	08a50513          	addi	a0,a0,138 # 6298 <malloc+0x12e6>
    3216:	141010ef          	jal	4b56 <chdir>
    321a:	e159                	bnez	a0,32a0 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    321c:	00003517          	auipc	a0,0x3
    3220:	6ec50513          	addi	a0,a0,1772 # 6908 <malloc+0x1956>
    3224:	113010ef          	jal	4b36 <unlink>
    3228:	c551                	beqz	a0,32b4 <rmdot+0xea>
  if(unlink("dots/..") == 0){
    322a:	00003517          	auipc	a0,0x3
    322e:	70650513          	addi	a0,a0,1798 # 6930 <malloc+0x197e>
    3232:	105010ef          	jal	4b36 <unlink>
    3236:	c949                	beqz	a0,32c8 <rmdot+0xfe>
  if(unlink("dots") != 0){
    3238:	00003517          	auipc	a0,0x3
    323c:	66850513          	addi	a0,a0,1640 # 68a0 <malloc+0x18ee>
    3240:	0f7010ef          	jal	4b36 <unlink>
    3244:	ed41                	bnez	a0,32dc <rmdot+0x112>
}
    3246:	60e2                	ld	ra,24(sp)
    3248:	6442                	ld	s0,16(sp)
    324a:	64a2                	ld	s1,8(sp)
    324c:	6105                	addi	sp,sp,32
    324e:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3250:	85a6                	mv	a1,s1
    3252:	00003517          	auipc	a0,0x3
    3256:	65650513          	addi	a0,a0,1622 # 68a8 <malloc+0x18f6>
    325a:	4a5010ef          	jal	4efe <printf>
    exit(1);
    325e:	4505                	li	a0,1
    3260:	087010ef          	jal	4ae6 <exit>
    printf("%s: chdir dots failed\n", s);
    3264:	85a6                	mv	a1,s1
    3266:	00003517          	auipc	a0,0x3
    326a:	65a50513          	addi	a0,a0,1626 # 68c0 <malloc+0x190e>
    326e:	491010ef          	jal	4efe <printf>
    exit(1);
    3272:	4505                	li	a0,1
    3274:	073010ef          	jal	4ae6 <exit>
    printf("%s: rm . worked!\n", s);
    3278:	85a6                	mv	a1,s1
    327a:	00003517          	auipc	a0,0x3
    327e:	65e50513          	addi	a0,a0,1630 # 68d8 <malloc+0x1926>
    3282:	47d010ef          	jal	4efe <printf>
    exit(1);
    3286:	4505                	li	a0,1
    3288:	05f010ef          	jal	4ae6 <exit>
    printf("%s: rm .. worked!\n", s);
    328c:	85a6                	mv	a1,s1
    328e:	00003517          	auipc	a0,0x3
    3292:	66250513          	addi	a0,a0,1634 # 68f0 <malloc+0x193e>
    3296:	469010ef          	jal	4efe <printf>
    exit(1);
    329a:	4505                	li	a0,1
    329c:	04b010ef          	jal	4ae6 <exit>
    printf("%s: chdir / failed\n", s);
    32a0:	85a6                	mv	a1,s1
    32a2:	00003517          	auipc	a0,0x3
    32a6:	ffe50513          	addi	a0,a0,-2 # 62a0 <malloc+0x12ee>
    32aa:	455010ef          	jal	4efe <printf>
    exit(1);
    32ae:	4505                	li	a0,1
    32b0:	037010ef          	jal	4ae6 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    32b4:	85a6                	mv	a1,s1
    32b6:	00003517          	auipc	a0,0x3
    32ba:	65a50513          	addi	a0,a0,1626 # 6910 <malloc+0x195e>
    32be:	441010ef          	jal	4efe <printf>
    exit(1);
    32c2:	4505                	li	a0,1
    32c4:	023010ef          	jal	4ae6 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    32c8:	85a6                	mv	a1,s1
    32ca:	00003517          	auipc	a0,0x3
    32ce:	66e50513          	addi	a0,a0,1646 # 6938 <malloc+0x1986>
    32d2:	42d010ef          	jal	4efe <printf>
    exit(1);
    32d6:	4505                	li	a0,1
    32d8:	00f010ef          	jal	4ae6 <exit>
    printf("%s: unlink dots failed!\n", s);
    32dc:	85a6                	mv	a1,s1
    32de:	00003517          	auipc	a0,0x3
    32e2:	67a50513          	addi	a0,a0,1658 # 6958 <malloc+0x19a6>
    32e6:	419010ef          	jal	4efe <printf>
    exit(1);
    32ea:	4505                	li	a0,1
    32ec:	7fa010ef          	jal	4ae6 <exit>

00000000000032f0 <dirfile>:
{
    32f0:	1101                	addi	sp,sp,-32
    32f2:	ec06                	sd	ra,24(sp)
    32f4:	e822                	sd	s0,16(sp)
    32f6:	e426                	sd	s1,8(sp)
    32f8:	e04a                	sd	s2,0(sp)
    32fa:	1000                	addi	s0,sp,32
    32fc:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    32fe:	20000593          	li	a1,512
    3302:	00003517          	auipc	a0,0x3
    3306:	67650513          	addi	a0,a0,1654 # 6978 <malloc+0x19c6>
    330a:	01d010ef          	jal	4b26 <open>
  if(fd < 0){
    330e:	0c054563          	bltz	a0,33d8 <dirfile+0xe8>
  close(fd);
    3312:	7fc010ef          	jal	4b0e <close>
  if(chdir("dirfile") == 0){
    3316:	00003517          	auipc	a0,0x3
    331a:	66250513          	addi	a0,a0,1634 # 6978 <malloc+0x19c6>
    331e:	039010ef          	jal	4b56 <chdir>
    3322:	c569                	beqz	a0,33ec <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    3324:	4581                	li	a1,0
    3326:	00003517          	auipc	a0,0x3
    332a:	69a50513          	addi	a0,a0,1690 # 69c0 <malloc+0x1a0e>
    332e:	7f8010ef          	jal	4b26 <open>
  if(fd >= 0){
    3332:	0c055763          	bgez	a0,3400 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    3336:	20000593          	li	a1,512
    333a:	00003517          	auipc	a0,0x3
    333e:	68650513          	addi	a0,a0,1670 # 69c0 <malloc+0x1a0e>
    3342:	7e4010ef          	jal	4b26 <open>
  if(fd >= 0){
    3346:	0c055763          	bgez	a0,3414 <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    334a:	00003517          	auipc	a0,0x3
    334e:	67650513          	addi	a0,a0,1654 # 69c0 <malloc+0x1a0e>
    3352:	7fc010ef          	jal	4b4e <mkdir>
    3356:	0c050963          	beqz	a0,3428 <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    335a:	00003517          	auipc	a0,0x3
    335e:	66650513          	addi	a0,a0,1638 # 69c0 <malloc+0x1a0e>
    3362:	7d4010ef          	jal	4b36 <unlink>
    3366:	0c050b63          	beqz	a0,343c <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    336a:	00003597          	auipc	a1,0x3
    336e:	65658593          	addi	a1,a1,1622 # 69c0 <malloc+0x1a0e>
    3372:	00002517          	auipc	a0,0x2
    3376:	f4e50513          	addi	a0,a0,-178 # 52c0 <malloc+0x30e>
    337a:	7cc010ef          	jal	4b46 <link>
    337e:	0c050963          	beqz	a0,3450 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    3382:	00003517          	auipc	a0,0x3
    3386:	5f650513          	addi	a0,a0,1526 # 6978 <malloc+0x19c6>
    338a:	7ac010ef          	jal	4b36 <unlink>
    338e:	0c051b63          	bnez	a0,3464 <dirfile+0x174>
  fd = open(".", O_RDWR);
    3392:	4589                	li	a1,2
    3394:	00002517          	auipc	a0,0x2
    3398:	43c50513          	addi	a0,a0,1084 # 57d0 <malloc+0x81e>
    339c:	78a010ef          	jal	4b26 <open>
  if(fd >= 0){
    33a0:	0c055c63          	bgez	a0,3478 <dirfile+0x188>
  fd = open(".", 0);
    33a4:	4581                	li	a1,0
    33a6:	00002517          	auipc	a0,0x2
    33aa:	42a50513          	addi	a0,a0,1066 # 57d0 <malloc+0x81e>
    33ae:	778010ef          	jal	4b26 <open>
    33b2:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    33b4:	4605                	li	a2,1
    33b6:	00002597          	auipc	a1,0x2
    33ba:	da258593          	addi	a1,a1,-606 # 5158 <malloc+0x1a6>
    33be:	748010ef          	jal	4b06 <write>
    33c2:	0ca04563          	bgtz	a0,348c <dirfile+0x19c>
  close(fd);
    33c6:	8526                	mv	a0,s1
    33c8:	746010ef          	jal	4b0e <close>
}
    33cc:	60e2                	ld	ra,24(sp)
    33ce:	6442                	ld	s0,16(sp)
    33d0:	64a2                	ld	s1,8(sp)
    33d2:	6902                	ld	s2,0(sp)
    33d4:	6105                	addi	sp,sp,32
    33d6:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    33d8:	85ca                	mv	a1,s2
    33da:	00003517          	auipc	a0,0x3
    33de:	5a650513          	addi	a0,a0,1446 # 6980 <malloc+0x19ce>
    33e2:	31d010ef          	jal	4efe <printf>
    exit(1);
    33e6:	4505                	li	a0,1
    33e8:	6fe010ef          	jal	4ae6 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    33ec:	85ca                	mv	a1,s2
    33ee:	00003517          	auipc	a0,0x3
    33f2:	5b250513          	addi	a0,a0,1458 # 69a0 <malloc+0x19ee>
    33f6:	309010ef          	jal	4efe <printf>
    exit(1);
    33fa:	4505                	li	a0,1
    33fc:	6ea010ef          	jal	4ae6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3400:	85ca                	mv	a1,s2
    3402:	00003517          	auipc	a0,0x3
    3406:	5ce50513          	addi	a0,a0,1486 # 69d0 <malloc+0x1a1e>
    340a:	2f5010ef          	jal	4efe <printf>
    exit(1);
    340e:	4505                	li	a0,1
    3410:	6d6010ef          	jal	4ae6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3414:	85ca                	mv	a1,s2
    3416:	00003517          	auipc	a0,0x3
    341a:	5ba50513          	addi	a0,a0,1466 # 69d0 <malloc+0x1a1e>
    341e:	2e1010ef          	jal	4efe <printf>
    exit(1);
    3422:	4505                	li	a0,1
    3424:	6c2010ef          	jal	4ae6 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3428:	85ca                	mv	a1,s2
    342a:	00003517          	auipc	a0,0x3
    342e:	5ce50513          	addi	a0,a0,1486 # 69f8 <malloc+0x1a46>
    3432:	2cd010ef          	jal	4efe <printf>
    exit(1);
    3436:	4505                	li	a0,1
    3438:	6ae010ef          	jal	4ae6 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    343c:	85ca                	mv	a1,s2
    343e:	00003517          	auipc	a0,0x3
    3442:	5e250513          	addi	a0,a0,1506 # 6a20 <malloc+0x1a6e>
    3446:	2b9010ef          	jal	4efe <printf>
    exit(1);
    344a:	4505                	li	a0,1
    344c:	69a010ef          	jal	4ae6 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3450:	85ca                	mv	a1,s2
    3452:	00003517          	auipc	a0,0x3
    3456:	5f650513          	addi	a0,a0,1526 # 6a48 <malloc+0x1a96>
    345a:	2a5010ef          	jal	4efe <printf>
    exit(1);
    345e:	4505                	li	a0,1
    3460:	686010ef          	jal	4ae6 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3464:	85ca                	mv	a1,s2
    3466:	00003517          	auipc	a0,0x3
    346a:	60a50513          	addi	a0,a0,1546 # 6a70 <malloc+0x1abe>
    346e:	291010ef          	jal	4efe <printf>
    exit(1);
    3472:	4505                	li	a0,1
    3474:	672010ef          	jal	4ae6 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3478:	85ca                	mv	a1,s2
    347a:	00003517          	auipc	a0,0x3
    347e:	61650513          	addi	a0,a0,1558 # 6a90 <malloc+0x1ade>
    3482:	27d010ef          	jal	4efe <printf>
    exit(1);
    3486:	4505                	li	a0,1
    3488:	65e010ef          	jal	4ae6 <exit>
    printf("%s: write . succeeded!\n", s);
    348c:	85ca                	mv	a1,s2
    348e:	00003517          	auipc	a0,0x3
    3492:	62a50513          	addi	a0,a0,1578 # 6ab8 <malloc+0x1b06>
    3496:	269010ef          	jal	4efe <printf>
    exit(1);
    349a:	4505                	li	a0,1
    349c:	64a010ef          	jal	4ae6 <exit>

00000000000034a0 <iref>:
{
    34a0:	7139                	addi	sp,sp,-64
    34a2:	fc06                	sd	ra,56(sp)
    34a4:	f822                	sd	s0,48(sp)
    34a6:	f426                	sd	s1,40(sp)
    34a8:	f04a                	sd	s2,32(sp)
    34aa:	ec4e                	sd	s3,24(sp)
    34ac:	e852                	sd	s4,16(sp)
    34ae:	e456                	sd	s5,8(sp)
    34b0:	e05a                	sd	s6,0(sp)
    34b2:	0080                	addi	s0,sp,64
    34b4:	8b2a                	mv	s6,a0
    34b6:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    34ba:	00003a17          	auipc	s4,0x3
    34be:	616a0a13          	addi	s4,s4,1558 # 6ad0 <malloc+0x1b1e>
    mkdir("");
    34c2:	00003497          	auipc	s1,0x3
    34c6:	11648493          	addi	s1,s1,278 # 65d8 <malloc+0x1626>
    link("README", "");
    34ca:	00002a97          	auipc	s5,0x2
    34ce:	df6a8a93          	addi	s5,s5,-522 # 52c0 <malloc+0x30e>
    fd = open("xx", O_CREATE);
    34d2:	00003997          	auipc	s3,0x3
    34d6:	4f698993          	addi	s3,s3,1270 # 69c8 <malloc+0x1a16>
    34da:	a835                	j	3516 <iref+0x76>
      printf("%s: mkdir irefd failed\n", s);
    34dc:	85da                	mv	a1,s6
    34de:	00003517          	auipc	a0,0x3
    34e2:	5fa50513          	addi	a0,a0,1530 # 6ad8 <malloc+0x1b26>
    34e6:	219010ef          	jal	4efe <printf>
      exit(1);
    34ea:	4505                	li	a0,1
    34ec:	5fa010ef          	jal	4ae6 <exit>
      printf("%s: chdir irefd failed\n", s);
    34f0:	85da                	mv	a1,s6
    34f2:	00003517          	auipc	a0,0x3
    34f6:	5fe50513          	addi	a0,a0,1534 # 6af0 <malloc+0x1b3e>
    34fa:	205010ef          	jal	4efe <printf>
      exit(1);
    34fe:	4505                	li	a0,1
    3500:	5e6010ef          	jal	4ae6 <exit>
      close(fd);
    3504:	60a010ef          	jal	4b0e <close>
    3508:	a82d                	j	3542 <iref+0xa2>
    unlink("xx");
    350a:	854e                	mv	a0,s3
    350c:	62a010ef          	jal	4b36 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3510:	397d                	addiw	s2,s2,-1
    3512:	04090263          	beqz	s2,3556 <iref+0xb6>
    if(mkdir("irefd") != 0){
    3516:	8552                	mv	a0,s4
    3518:	636010ef          	jal	4b4e <mkdir>
    351c:	f161                	bnez	a0,34dc <iref+0x3c>
    if(chdir("irefd") != 0){
    351e:	8552                	mv	a0,s4
    3520:	636010ef          	jal	4b56 <chdir>
    3524:	f571                	bnez	a0,34f0 <iref+0x50>
    mkdir("");
    3526:	8526                	mv	a0,s1
    3528:	626010ef          	jal	4b4e <mkdir>
    link("README", "");
    352c:	85a6                	mv	a1,s1
    352e:	8556                	mv	a0,s5
    3530:	616010ef          	jal	4b46 <link>
    fd = open("", O_CREATE);
    3534:	20000593          	li	a1,512
    3538:	8526                	mv	a0,s1
    353a:	5ec010ef          	jal	4b26 <open>
    if(fd >= 0)
    353e:	fc0553e3          	bgez	a0,3504 <iref+0x64>
    fd = open("xx", O_CREATE);
    3542:	20000593          	li	a1,512
    3546:	854e                	mv	a0,s3
    3548:	5de010ef          	jal	4b26 <open>
    if(fd >= 0)
    354c:	fa054fe3          	bltz	a0,350a <iref+0x6a>
      close(fd);
    3550:	5be010ef          	jal	4b0e <close>
    3554:	bf5d                	j	350a <iref+0x6a>
    3556:	03300493          	li	s1,51
    chdir("..");
    355a:	00003997          	auipc	s3,0x3
    355e:	d9698993          	addi	s3,s3,-618 # 62f0 <malloc+0x133e>
    unlink("irefd");
    3562:	00003917          	auipc	s2,0x3
    3566:	56e90913          	addi	s2,s2,1390 # 6ad0 <malloc+0x1b1e>
    chdir("..");
    356a:	854e                	mv	a0,s3
    356c:	5ea010ef          	jal	4b56 <chdir>
    unlink("irefd");
    3570:	854a                	mv	a0,s2
    3572:	5c4010ef          	jal	4b36 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3576:	34fd                	addiw	s1,s1,-1
    3578:	f8ed                	bnez	s1,356a <iref+0xca>
  chdir("/");
    357a:	00003517          	auipc	a0,0x3
    357e:	d1e50513          	addi	a0,a0,-738 # 6298 <malloc+0x12e6>
    3582:	5d4010ef          	jal	4b56 <chdir>
}
    3586:	70e2                	ld	ra,56(sp)
    3588:	7442                	ld	s0,48(sp)
    358a:	74a2                	ld	s1,40(sp)
    358c:	7902                	ld	s2,32(sp)
    358e:	69e2                	ld	s3,24(sp)
    3590:	6a42                	ld	s4,16(sp)
    3592:	6aa2                	ld	s5,8(sp)
    3594:	6b02                	ld	s6,0(sp)
    3596:	6121                	addi	sp,sp,64
    3598:	8082                	ret

000000000000359a <openiputtest>:
{
    359a:	7179                	addi	sp,sp,-48
    359c:	f406                	sd	ra,40(sp)
    359e:	f022                	sd	s0,32(sp)
    35a0:	ec26                	sd	s1,24(sp)
    35a2:	1800                	addi	s0,sp,48
    35a4:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    35a6:	00003517          	auipc	a0,0x3
    35aa:	56250513          	addi	a0,a0,1378 # 6b08 <malloc+0x1b56>
    35ae:	5a0010ef          	jal	4b4e <mkdir>
    35b2:	02054a63          	bltz	a0,35e6 <openiputtest+0x4c>
  pid = fork();
    35b6:	528010ef          	jal	4ade <fork>
  if(pid < 0){
    35ba:	04054063          	bltz	a0,35fa <openiputtest+0x60>
  if(pid == 0){
    35be:	e939                	bnez	a0,3614 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    35c0:	4589                	li	a1,2
    35c2:	00003517          	auipc	a0,0x3
    35c6:	54650513          	addi	a0,a0,1350 # 6b08 <malloc+0x1b56>
    35ca:	55c010ef          	jal	4b26 <open>
    if(fd >= 0){
    35ce:	04054063          	bltz	a0,360e <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    35d2:	85a6                	mv	a1,s1
    35d4:	00003517          	auipc	a0,0x3
    35d8:	55450513          	addi	a0,a0,1364 # 6b28 <malloc+0x1b76>
    35dc:	123010ef          	jal	4efe <printf>
      exit(1);
    35e0:	4505                	li	a0,1
    35e2:	504010ef          	jal	4ae6 <exit>
    printf("%s: mkdir oidir failed\n", s);
    35e6:	85a6                	mv	a1,s1
    35e8:	00003517          	auipc	a0,0x3
    35ec:	52850513          	addi	a0,a0,1320 # 6b10 <malloc+0x1b5e>
    35f0:	10f010ef          	jal	4efe <printf>
    exit(1);
    35f4:	4505                	li	a0,1
    35f6:	4f0010ef          	jal	4ae6 <exit>
    printf("%s: fork failed\n", s);
    35fa:	85a6                	mv	a1,s1
    35fc:	00002517          	auipc	a0,0x2
    3600:	37c50513          	addi	a0,a0,892 # 5978 <malloc+0x9c6>
    3604:	0fb010ef          	jal	4efe <printf>
    exit(1);
    3608:	4505                	li	a0,1
    360a:	4dc010ef          	jal	4ae6 <exit>
    exit(0);
    360e:	4501                	li	a0,0
    3610:	4d6010ef          	jal	4ae6 <exit>
  sleep(1);
    3614:	4505                	li	a0,1
    3616:	560010ef          	jal	4b76 <sleep>
  if(unlink("oidir") != 0){
    361a:	00003517          	auipc	a0,0x3
    361e:	4ee50513          	addi	a0,a0,1262 # 6b08 <malloc+0x1b56>
    3622:	514010ef          	jal	4b36 <unlink>
    3626:	c919                	beqz	a0,363c <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    3628:	85a6                	mv	a1,s1
    362a:	00002517          	auipc	a0,0x2
    362e:	53e50513          	addi	a0,a0,1342 # 5b68 <malloc+0xbb6>
    3632:	0cd010ef          	jal	4efe <printf>
    exit(1);
    3636:	4505                	li	a0,1
    3638:	4ae010ef          	jal	4ae6 <exit>
  wait(&xstatus);
    363c:	fdc40513          	addi	a0,s0,-36
    3640:	4ae010ef          	jal	4aee <wait>
  exit(xstatus);
    3644:	fdc42503          	lw	a0,-36(s0)
    3648:	49e010ef          	jal	4ae6 <exit>

000000000000364c <forkforkfork>:
{
    364c:	1101                	addi	sp,sp,-32
    364e:	ec06                	sd	ra,24(sp)
    3650:	e822                	sd	s0,16(sp)
    3652:	e426                	sd	s1,8(sp)
    3654:	1000                	addi	s0,sp,32
    3656:	84aa                	mv	s1,a0
  unlink("stopforking");
    3658:	00003517          	auipc	a0,0x3
    365c:	4f850513          	addi	a0,a0,1272 # 6b50 <malloc+0x1b9e>
    3660:	4d6010ef          	jal	4b36 <unlink>
  int pid = fork();
    3664:	47a010ef          	jal	4ade <fork>
  if(pid < 0){
    3668:	02054b63          	bltz	a0,369e <forkforkfork+0x52>
  if(pid == 0){
    366c:	c139                	beqz	a0,36b2 <forkforkfork+0x66>
  sleep(20); // two seconds
    366e:	4551                	li	a0,20
    3670:	506010ef          	jal	4b76 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3674:	20200593          	li	a1,514
    3678:	00003517          	auipc	a0,0x3
    367c:	4d850513          	addi	a0,a0,1240 # 6b50 <malloc+0x1b9e>
    3680:	4a6010ef          	jal	4b26 <open>
    3684:	48a010ef          	jal	4b0e <close>
  wait(0);
    3688:	4501                	li	a0,0
    368a:	464010ef          	jal	4aee <wait>
  sleep(10); // one second
    368e:	4529                	li	a0,10
    3690:	4e6010ef          	jal	4b76 <sleep>
}
    3694:	60e2                	ld	ra,24(sp)
    3696:	6442                	ld	s0,16(sp)
    3698:	64a2                	ld	s1,8(sp)
    369a:	6105                	addi	sp,sp,32
    369c:	8082                	ret
    printf("%s: fork failed", s);
    369e:	85a6                	mv	a1,s1
    36a0:	00002517          	auipc	a0,0x2
    36a4:	49850513          	addi	a0,a0,1176 # 5b38 <malloc+0xb86>
    36a8:	057010ef          	jal	4efe <printf>
    exit(1);
    36ac:	4505                	li	a0,1
    36ae:	438010ef          	jal	4ae6 <exit>
      int fd = open("stopforking", 0);
    36b2:	00003497          	auipc	s1,0x3
    36b6:	49e48493          	addi	s1,s1,1182 # 6b50 <malloc+0x1b9e>
    36ba:	4581                	li	a1,0
    36bc:	8526                	mv	a0,s1
    36be:	468010ef          	jal	4b26 <open>
      if(fd >= 0){
    36c2:	02055163          	bgez	a0,36e4 <forkforkfork+0x98>
      if(fork() < 0){
    36c6:	418010ef          	jal	4ade <fork>
    36ca:	fe0558e3          	bgez	a0,36ba <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE|O_RDWR));
    36ce:	20200593          	li	a1,514
    36d2:	00003517          	auipc	a0,0x3
    36d6:	47e50513          	addi	a0,a0,1150 # 6b50 <malloc+0x1b9e>
    36da:	44c010ef          	jal	4b26 <open>
    36de:	430010ef          	jal	4b0e <close>
    36e2:	bfe1                	j	36ba <forkforkfork+0x6e>
        exit(0);
    36e4:	4501                	li	a0,0
    36e6:	400010ef          	jal	4ae6 <exit>

00000000000036ea <killstatus>:
{
    36ea:	7139                	addi	sp,sp,-64
    36ec:	fc06                	sd	ra,56(sp)
    36ee:	f822                	sd	s0,48(sp)
    36f0:	f426                	sd	s1,40(sp)
    36f2:	f04a                	sd	s2,32(sp)
    36f4:	ec4e                	sd	s3,24(sp)
    36f6:	e852                	sd	s4,16(sp)
    36f8:	0080                	addi	s0,sp,64
    36fa:	8a2a                	mv	s4,a0
    36fc:	06400913          	li	s2,100
    if(xst != -1) {
    3700:	59fd                	li	s3,-1
    int pid1 = fork();
    3702:	3dc010ef          	jal	4ade <fork>
    3706:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3708:	02054763          	bltz	a0,3736 <killstatus+0x4c>
    if(pid1 == 0){
    370c:	cd1d                	beqz	a0,374a <killstatus+0x60>
    sleep(1);
    370e:	4505                	li	a0,1
    3710:	466010ef          	jal	4b76 <sleep>
    kill(pid1);
    3714:	8526                	mv	a0,s1
    3716:	400010ef          	jal	4b16 <kill>
    wait(&xst);
    371a:	fcc40513          	addi	a0,s0,-52
    371e:	3d0010ef          	jal	4aee <wait>
    if(xst != -1) {
    3722:	fcc42783          	lw	a5,-52(s0)
    3726:	03379563          	bne	a5,s3,3750 <killstatus+0x66>
  for(int i = 0; i < 100; i++){
    372a:	397d                	addiw	s2,s2,-1
    372c:	fc091be3          	bnez	s2,3702 <killstatus+0x18>
  exit(0);
    3730:	4501                	li	a0,0
    3732:	3b4010ef          	jal	4ae6 <exit>
      printf("%s: fork failed\n", s);
    3736:	85d2                	mv	a1,s4
    3738:	00002517          	auipc	a0,0x2
    373c:	24050513          	addi	a0,a0,576 # 5978 <malloc+0x9c6>
    3740:	7be010ef          	jal	4efe <printf>
      exit(1);
    3744:	4505                	li	a0,1
    3746:	3a0010ef          	jal	4ae6 <exit>
        getpid();
    374a:	41c010ef          	jal	4b66 <getpid>
      while(1) {
    374e:	bff5                	j	374a <killstatus+0x60>
       printf("%s: status should be -1\n", s);
    3750:	85d2                	mv	a1,s4
    3752:	00003517          	auipc	a0,0x3
    3756:	40e50513          	addi	a0,a0,1038 # 6b60 <malloc+0x1bae>
    375a:	7a4010ef          	jal	4efe <printf>
       exit(1);
    375e:	4505                	li	a0,1
    3760:	386010ef          	jal	4ae6 <exit>

0000000000003764 <preempt>:
{
    3764:	7139                	addi	sp,sp,-64
    3766:	fc06                	sd	ra,56(sp)
    3768:	f822                	sd	s0,48(sp)
    376a:	f426                	sd	s1,40(sp)
    376c:	f04a                	sd	s2,32(sp)
    376e:	ec4e                	sd	s3,24(sp)
    3770:	e852                	sd	s4,16(sp)
    3772:	0080                	addi	s0,sp,64
    3774:	892a                	mv	s2,a0
  pid1 = fork();
    3776:	368010ef          	jal	4ade <fork>
  if(pid1 < 0) {
    377a:	00054563          	bltz	a0,3784 <preempt+0x20>
    377e:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3780:	ed01                	bnez	a0,3798 <preempt+0x34>
    for(;;)
    3782:	a001                	j	3782 <preempt+0x1e>
    printf("%s: fork failed", s);
    3784:	85ca                	mv	a1,s2
    3786:	00002517          	auipc	a0,0x2
    378a:	3b250513          	addi	a0,a0,946 # 5b38 <malloc+0xb86>
    378e:	770010ef          	jal	4efe <printf>
    exit(1);
    3792:	4505                	li	a0,1
    3794:	352010ef          	jal	4ae6 <exit>
  pid2 = fork();
    3798:	346010ef          	jal	4ade <fork>
    379c:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    379e:	00054463          	bltz	a0,37a6 <preempt+0x42>
  if(pid2 == 0)
    37a2:	ed01                	bnez	a0,37ba <preempt+0x56>
    for(;;)
    37a4:	a001                	j	37a4 <preempt+0x40>
    printf("%s: fork failed\n", s);
    37a6:	85ca                	mv	a1,s2
    37a8:	00002517          	auipc	a0,0x2
    37ac:	1d050513          	addi	a0,a0,464 # 5978 <malloc+0x9c6>
    37b0:	74e010ef          	jal	4efe <printf>
    exit(1);
    37b4:	4505                	li	a0,1
    37b6:	330010ef          	jal	4ae6 <exit>
  pipe(pfds);
    37ba:	fc840513          	addi	a0,s0,-56
    37be:	338010ef          	jal	4af6 <pipe>
  pid3 = fork();
    37c2:	31c010ef          	jal	4ade <fork>
    37c6:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    37c8:	02054863          	bltz	a0,37f8 <preempt+0x94>
  if(pid3 == 0){
    37cc:	e921                	bnez	a0,381c <preempt+0xb8>
    close(pfds[0]);
    37ce:	fc842503          	lw	a0,-56(s0)
    37d2:	33c010ef          	jal	4b0e <close>
    if(write(pfds[1], "x", 1) != 1)
    37d6:	4605                	li	a2,1
    37d8:	00002597          	auipc	a1,0x2
    37dc:	98058593          	addi	a1,a1,-1664 # 5158 <malloc+0x1a6>
    37e0:	fcc42503          	lw	a0,-52(s0)
    37e4:	322010ef          	jal	4b06 <write>
    37e8:	4785                	li	a5,1
    37ea:	02f51163          	bne	a0,a5,380c <preempt+0xa8>
    close(pfds[1]);
    37ee:	fcc42503          	lw	a0,-52(s0)
    37f2:	31c010ef          	jal	4b0e <close>
    for(;;)
    37f6:	a001                	j	37f6 <preempt+0x92>
     printf("%s: fork failed\n", s);
    37f8:	85ca                	mv	a1,s2
    37fa:	00002517          	auipc	a0,0x2
    37fe:	17e50513          	addi	a0,a0,382 # 5978 <malloc+0x9c6>
    3802:	6fc010ef          	jal	4efe <printf>
     exit(1);
    3806:	4505                	li	a0,1
    3808:	2de010ef          	jal	4ae6 <exit>
      printf("%s: preempt write error", s);
    380c:	85ca                	mv	a1,s2
    380e:	00003517          	auipc	a0,0x3
    3812:	37250513          	addi	a0,a0,882 # 6b80 <malloc+0x1bce>
    3816:	6e8010ef          	jal	4efe <printf>
    381a:	bfd1                	j	37ee <preempt+0x8a>
  close(pfds[1]);
    381c:	fcc42503          	lw	a0,-52(s0)
    3820:	2ee010ef          	jal	4b0e <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3824:	660d                	lui	a2,0x3
    3826:	00009597          	auipc	a1,0x9
    382a:	45258593          	addi	a1,a1,1106 # cc78 <buf>
    382e:	fc842503          	lw	a0,-56(s0)
    3832:	2cc010ef          	jal	4afe <read>
    3836:	4785                	li	a5,1
    3838:	02f50163          	beq	a0,a5,385a <preempt+0xf6>
    printf("%s: preempt read error", s);
    383c:	85ca                	mv	a1,s2
    383e:	00003517          	auipc	a0,0x3
    3842:	35a50513          	addi	a0,a0,858 # 6b98 <malloc+0x1be6>
    3846:	6b8010ef          	jal	4efe <printf>
}
    384a:	70e2                	ld	ra,56(sp)
    384c:	7442                	ld	s0,48(sp)
    384e:	74a2                	ld	s1,40(sp)
    3850:	7902                	ld	s2,32(sp)
    3852:	69e2                	ld	s3,24(sp)
    3854:	6a42                	ld	s4,16(sp)
    3856:	6121                	addi	sp,sp,64
    3858:	8082                	ret
  close(pfds[0]);
    385a:	fc842503          	lw	a0,-56(s0)
    385e:	2b0010ef          	jal	4b0e <close>
  printf("kill... ");
    3862:	00003517          	auipc	a0,0x3
    3866:	34e50513          	addi	a0,a0,846 # 6bb0 <malloc+0x1bfe>
    386a:	694010ef          	jal	4efe <printf>
  kill(pid1);
    386e:	8526                	mv	a0,s1
    3870:	2a6010ef          	jal	4b16 <kill>
  kill(pid2);
    3874:	854e                	mv	a0,s3
    3876:	2a0010ef          	jal	4b16 <kill>
  kill(pid3);
    387a:	8552                	mv	a0,s4
    387c:	29a010ef          	jal	4b16 <kill>
  printf("wait... ");
    3880:	00003517          	auipc	a0,0x3
    3884:	34050513          	addi	a0,a0,832 # 6bc0 <malloc+0x1c0e>
    3888:	676010ef          	jal	4efe <printf>
  wait(0);
    388c:	4501                	li	a0,0
    388e:	260010ef          	jal	4aee <wait>
  wait(0);
    3892:	4501                	li	a0,0
    3894:	25a010ef          	jal	4aee <wait>
  wait(0);
    3898:	4501                	li	a0,0
    389a:	254010ef          	jal	4aee <wait>
    389e:	b775                	j	384a <preempt+0xe6>

00000000000038a0 <reparent>:
{
    38a0:	7179                	addi	sp,sp,-48
    38a2:	f406                	sd	ra,40(sp)
    38a4:	f022                	sd	s0,32(sp)
    38a6:	ec26                	sd	s1,24(sp)
    38a8:	e84a                	sd	s2,16(sp)
    38aa:	e44e                	sd	s3,8(sp)
    38ac:	e052                	sd	s4,0(sp)
    38ae:	1800                	addi	s0,sp,48
    38b0:	89aa                	mv	s3,a0
  int master_pid = getpid();
    38b2:	2b4010ef          	jal	4b66 <getpid>
    38b6:	8a2a                	mv	s4,a0
    38b8:	0c800913          	li	s2,200
    int pid = fork();
    38bc:	222010ef          	jal	4ade <fork>
    38c0:	84aa                	mv	s1,a0
    if(pid < 0){
    38c2:	00054e63          	bltz	a0,38de <reparent+0x3e>
    if(pid){
    38c6:	c121                	beqz	a0,3906 <reparent+0x66>
      if(wait(0) != pid){
    38c8:	4501                	li	a0,0
    38ca:	224010ef          	jal	4aee <wait>
    38ce:	02951263          	bne	a0,s1,38f2 <reparent+0x52>
  for(int i = 0; i < 200; i++){
    38d2:	397d                	addiw	s2,s2,-1
    38d4:	fe0914e3          	bnez	s2,38bc <reparent+0x1c>
  exit(0);
    38d8:	4501                	li	a0,0
    38da:	20c010ef          	jal	4ae6 <exit>
      printf("%s: fork failed\n", s);
    38de:	85ce                	mv	a1,s3
    38e0:	00002517          	auipc	a0,0x2
    38e4:	09850513          	addi	a0,a0,152 # 5978 <malloc+0x9c6>
    38e8:	616010ef          	jal	4efe <printf>
      exit(1);
    38ec:	4505                	li	a0,1
    38ee:	1f8010ef          	jal	4ae6 <exit>
        printf("%s: wait wrong pid\n", s);
    38f2:	85ce                	mv	a1,s3
    38f4:	00002517          	auipc	a0,0x2
    38f8:	20c50513          	addi	a0,a0,524 # 5b00 <malloc+0xb4e>
    38fc:	602010ef          	jal	4efe <printf>
        exit(1);
    3900:	4505                	li	a0,1
    3902:	1e4010ef          	jal	4ae6 <exit>
      int pid2 = fork();
    3906:	1d8010ef          	jal	4ade <fork>
      if(pid2 < 0){
    390a:	00054563          	bltz	a0,3914 <reparent+0x74>
      exit(0);
    390e:	4501                	li	a0,0
    3910:	1d6010ef          	jal	4ae6 <exit>
        kill(master_pid);
    3914:	8552                	mv	a0,s4
    3916:	200010ef          	jal	4b16 <kill>
        exit(1);
    391a:	4505                	li	a0,1
    391c:	1ca010ef          	jal	4ae6 <exit>

0000000000003920 <sbrkfail>:
{
    3920:	7119                	addi	sp,sp,-128
    3922:	fc86                	sd	ra,120(sp)
    3924:	f8a2                	sd	s0,112(sp)
    3926:	f4a6                	sd	s1,104(sp)
    3928:	f0ca                	sd	s2,96(sp)
    392a:	ecce                	sd	s3,88(sp)
    392c:	e8d2                	sd	s4,80(sp)
    392e:	e4d6                	sd	s5,72(sp)
    3930:	0100                	addi	s0,sp,128
    3932:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    3934:	fb040513          	addi	a0,s0,-80
    3938:	1be010ef          	jal	4af6 <pipe>
    393c:	e901                	bnez	a0,394c <sbrkfail+0x2c>
    393e:	f8040493          	addi	s1,s0,-128
    3942:	fa840993          	addi	s3,s0,-88
    3946:	8926                	mv	s2,s1
    if(pids[i] != -1)
    3948:	5a7d                	li	s4,-1
    394a:	a0a1                	j	3992 <sbrkfail+0x72>
    printf("%s: pipe() failed\n", s);
    394c:	85d6                	mv	a1,s5
    394e:	00002517          	auipc	a0,0x2
    3952:	13250513          	addi	a0,a0,306 # 5a80 <malloc+0xace>
    3956:	5a8010ef          	jal	4efe <printf>
    exit(1);
    395a:	4505                	li	a0,1
    395c:	18a010ef          	jal	4ae6 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3960:	20e010ef          	jal	4b6e <sbrk>
    3964:	064007b7          	lui	a5,0x6400
    3968:	40a7853b          	subw	a0,a5,a0
    396c:	202010ef          	jal	4b6e <sbrk>
      write(fds[1], "x", 1);
    3970:	4605                	li	a2,1
    3972:	00001597          	auipc	a1,0x1
    3976:	7e658593          	addi	a1,a1,2022 # 5158 <malloc+0x1a6>
    397a:	fb442503          	lw	a0,-76(s0)
    397e:	188010ef          	jal	4b06 <write>
      for(;;) sleep(1000);
    3982:	3e800513          	li	a0,1000
    3986:	1f0010ef          	jal	4b76 <sleep>
    398a:	bfe5                	j	3982 <sbrkfail+0x62>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    398c:	0911                	addi	s2,s2,4
    398e:	03390163          	beq	s2,s3,39b0 <sbrkfail+0x90>
    if((pids[i] = fork()) == 0){
    3992:	14c010ef          	jal	4ade <fork>
    3996:	00a92023          	sw	a0,0(s2)
    399a:	d179                	beqz	a0,3960 <sbrkfail+0x40>
    if(pids[i] != -1)
    399c:	ff4508e3          	beq	a0,s4,398c <sbrkfail+0x6c>
      read(fds[0], &scratch, 1);
    39a0:	4605                	li	a2,1
    39a2:	faf40593          	addi	a1,s0,-81
    39a6:	fb042503          	lw	a0,-80(s0)
    39aa:	154010ef          	jal	4afe <read>
    39ae:	bff9                	j	398c <sbrkfail+0x6c>
  c = sbrk(PGSIZE);
    39b0:	6505                	lui	a0,0x1
    39b2:	1bc010ef          	jal	4b6e <sbrk>
    39b6:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    39b8:	597d                	li	s2,-1
    39ba:	a021                	j	39c2 <sbrkfail+0xa2>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    39bc:	0491                	addi	s1,s1,4
    39be:	01348b63          	beq	s1,s3,39d4 <sbrkfail+0xb4>
    if(pids[i] == -1)
    39c2:	4088                	lw	a0,0(s1)
    39c4:	ff250ce3          	beq	a0,s2,39bc <sbrkfail+0x9c>
    kill(pids[i]);
    39c8:	14e010ef          	jal	4b16 <kill>
    wait(0);
    39cc:	4501                	li	a0,0
    39ce:	120010ef          	jal	4aee <wait>
    39d2:	b7ed                	j	39bc <sbrkfail+0x9c>
  if(c == (char*)0xffffffffffffffffL){
    39d4:	57fd                	li	a5,-1
    39d6:	02fa0d63          	beq	s4,a5,3a10 <sbrkfail+0xf0>
  pid = fork();
    39da:	104010ef          	jal	4ade <fork>
    39de:	84aa                	mv	s1,a0
  if(pid < 0){
    39e0:	04054263          	bltz	a0,3a24 <sbrkfail+0x104>
  if(pid == 0){
    39e4:	c931                	beqz	a0,3a38 <sbrkfail+0x118>
  wait(&xstatus);
    39e6:	fbc40513          	addi	a0,s0,-68
    39ea:	104010ef          	jal	4aee <wait>
  if(xstatus != -1 && xstatus != 2)
    39ee:	fbc42783          	lw	a5,-68(s0)
    39f2:	577d                	li	a4,-1
    39f4:	00e78563          	beq	a5,a4,39fe <sbrkfail+0xde>
    39f8:	4709                	li	a4,2
    39fa:	06e79d63          	bne	a5,a4,3a74 <sbrkfail+0x154>
}
    39fe:	70e6                	ld	ra,120(sp)
    3a00:	7446                	ld	s0,112(sp)
    3a02:	74a6                	ld	s1,104(sp)
    3a04:	7906                	ld	s2,96(sp)
    3a06:	69e6                	ld	s3,88(sp)
    3a08:	6a46                	ld	s4,80(sp)
    3a0a:	6aa6                	ld	s5,72(sp)
    3a0c:	6109                	addi	sp,sp,128
    3a0e:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3a10:	85d6                	mv	a1,s5
    3a12:	00003517          	auipc	a0,0x3
    3a16:	1be50513          	addi	a0,a0,446 # 6bd0 <malloc+0x1c1e>
    3a1a:	4e4010ef          	jal	4efe <printf>
    exit(1);
    3a1e:	4505                	li	a0,1
    3a20:	0c6010ef          	jal	4ae6 <exit>
    printf("%s: fork failed\n", s);
    3a24:	85d6                	mv	a1,s5
    3a26:	00002517          	auipc	a0,0x2
    3a2a:	f5250513          	addi	a0,a0,-174 # 5978 <malloc+0x9c6>
    3a2e:	4d0010ef          	jal	4efe <printf>
    exit(1);
    3a32:	4505                	li	a0,1
    3a34:	0b2010ef          	jal	4ae6 <exit>
    a = sbrk(0);
    3a38:	4501                	li	a0,0
    3a3a:	134010ef          	jal	4b6e <sbrk>
    3a3e:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3a40:	3e800537          	lui	a0,0x3e800
    3a44:	12a010ef          	jal	4b6e <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3a48:	87ca                	mv	a5,s2
    3a4a:	3e800737          	lui	a4,0x3e800
    3a4e:	993a                	add	s2,s2,a4
    3a50:	6705                	lui	a4,0x1
      n += *(a+i);
    3a52:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    3a56:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3a58:	97ba                	add	a5,a5,a4
    3a5a:	fef91ce3          	bne	s2,a5,3a52 <sbrkfail+0x132>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    3a5e:	8626                	mv	a2,s1
    3a60:	85d6                	mv	a1,s5
    3a62:	00003517          	auipc	a0,0x3
    3a66:	18e50513          	addi	a0,a0,398 # 6bf0 <malloc+0x1c3e>
    3a6a:	494010ef          	jal	4efe <printf>
    exit(1);
    3a6e:	4505                	li	a0,1
    3a70:	076010ef          	jal	4ae6 <exit>
    exit(1);
    3a74:	4505                	li	a0,1
    3a76:	070010ef          	jal	4ae6 <exit>

0000000000003a7a <mem>:
{
    3a7a:	7139                	addi	sp,sp,-64
    3a7c:	fc06                	sd	ra,56(sp)
    3a7e:	f822                	sd	s0,48(sp)
    3a80:	f426                	sd	s1,40(sp)
    3a82:	f04a                	sd	s2,32(sp)
    3a84:	ec4e                	sd	s3,24(sp)
    3a86:	0080                	addi	s0,sp,64
    3a88:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3a8a:	054010ef          	jal	4ade <fork>
    m1 = 0;
    3a8e:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3a90:	6909                	lui	s2,0x2
    3a92:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0x7d>
  if((pid = fork()) == 0){
    3a96:	cd11                	beqz	a0,3ab2 <mem+0x38>
    wait(&xstatus);
    3a98:	fcc40513          	addi	a0,s0,-52
    3a9c:	052010ef          	jal	4aee <wait>
    if(xstatus == -1){
    3aa0:	fcc42503          	lw	a0,-52(s0)
    3aa4:	57fd                	li	a5,-1
    3aa6:	04f50363          	beq	a0,a5,3aec <mem+0x72>
    exit(xstatus);
    3aaa:	03c010ef          	jal	4ae6 <exit>
      *(char**)m2 = m1;
    3aae:	e104                	sd	s1,0(a0)
      m1 = m2;
    3ab0:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3ab2:	854a                	mv	a0,s2
    3ab4:	4fe010ef          	jal	4fb2 <malloc>
    3ab8:	f97d                	bnez	a0,3aae <mem+0x34>
    while(m1){
    3aba:	c491                	beqz	s1,3ac6 <mem+0x4c>
      m2 = *(char**)m1;
    3abc:	8526                	mv	a0,s1
    3abe:	6084                	ld	s1,0(s1)
      free(m1);
    3ac0:	470010ef          	jal	4f30 <free>
    while(m1){
    3ac4:	fce5                	bnez	s1,3abc <mem+0x42>
    m1 = malloc(1024*20);
    3ac6:	6515                	lui	a0,0x5
    3ac8:	4ea010ef          	jal	4fb2 <malloc>
    if(m1 == 0){
    3acc:	c511                	beqz	a0,3ad8 <mem+0x5e>
    free(m1);
    3ace:	462010ef          	jal	4f30 <free>
    exit(0);
    3ad2:	4501                	li	a0,0
    3ad4:	012010ef          	jal	4ae6 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3ad8:	85ce                	mv	a1,s3
    3ada:	00003517          	auipc	a0,0x3
    3ade:	14650513          	addi	a0,a0,326 # 6c20 <malloc+0x1c6e>
    3ae2:	41c010ef          	jal	4efe <printf>
      exit(1);
    3ae6:	4505                	li	a0,1
    3ae8:	7ff000ef          	jal	4ae6 <exit>
      exit(0);
    3aec:	4501                	li	a0,0
    3aee:	7f9000ef          	jal	4ae6 <exit>

0000000000003af2 <sharedfd>:
{
    3af2:	7159                	addi	sp,sp,-112
    3af4:	f486                	sd	ra,104(sp)
    3af6:	f0a2                	sd	s0,96(sp)
    3af8:	e0d2                	sd	s4,64(sp)
    3afa:	1880                	addi	s0,sp,112
    3afc:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    3afe:	00003517          	auipc	a0,0x3
    3b02:	14250513          	addi	a0,a0,322 # 6c40 <malloc+0x1c8e>
    3b06:	030010ef          	jal	4b36 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3b0a:	20200593          	li	a1,514
    3b0e:	00003517          	auipc	a0,0x3
    3b12:	13250513          	addi	a0,a0,306 # 6c40 <malloc+0x1c8e>
    3b16:	010010ef          	jal	4b26 <open>
  if(fd < 0){
    3b1a:	04054863          	bltz	a0,3b6a <sharedfd+0x78>
    3b1e:	eca6                	sd	s1,88(sp)
    3b20:	e8ca                	sd	s2,80(sp)
    3b22:	e4ce                	sd	s3,72(sp)
    3b24:	fc56                	sd	s5,56(sp)
    3b26:	f85a                	sd	s6,48(sp)
    3b28:	f45e                	sd	s7,40(sp)
    3b2a:	892a                	mv	s2,a0
  pid = fork();
    3b2c:	7b3000ef          	jal	4ade <fork>
    3b30:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3b32:	07000593          	li	a1,112
    3b36:	e119                	bnez	a0,3b3c <sharedfd+0x4a>
    3b38:	06300593          	li	a1,99
    3b3c:	4629                	li	a2,10
    3b3e:	fa040513          	addi	a0,s0,-96
    3b42:	559000ef          	jal	489a <memset>
    3b46:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3b4a:	4629                	li	a2,10
    3b4c:	fa040593          	addi	a1,s0,-96
    3b50:	854a                	mv	a0,s2
    3b52:	7b5000ef          	jal	4b06 <write>
    3b56:	47a9                	li	a5,10
    3b58:	02f51963          	bne	a0,a5,3b8a <sharedfd+0x98>
  for(i = 0; i < N; i++){
    3b5c:	34fd                	addiw	s1,s1,-1
    3b5e:	f4f5                	bnez	s1,3b4a <sharedfd+0x58>
  if(pid == 0) {
    3b60:	02099f63          	bnez	s3,3b9e <sharedfd+0xac>
    exit(0);
    3b64:	4501                	li	a0,0
    3b66:	781000ef          	jal	4ae6 <exit>
    3b6a:	eca6                	sd	s1,88(sp)
    3b6c:	e8ca                	sd	s2,80(sp)
    3b6e:	e4ce                	sd	s3,72(sp)
    3b70:	fc56                	sd	s5,56(sp)
    3b72:	f85a                	sd	s6,48(sp)
    3b74:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3b76:	85d2                	mv	a1,s4
    3b78:	00003517          	auipc	a0,0x3
    3b7c:	0d850513          	addi	a0,a0,216 # 6c50 <malloc+0x1c9e>
    3b80:	37e010ef          	jal	4efe <printf>
    exit(1);
    3b84:	4505                	li	a0,1
    3b86:	761000ef          	jal	4ae6 <exit>
      printf("%s: write sharedfd failed\n", s);
    3b8a:	85d2                	mv	a1,s4
    3b8c:	00003517          	auipc	a0,0x3
    3b90:	0ec50513          	addi	a0,a0,236 # 6c78 <malloc+0x1cc6>
    3b94:	36a010ef          	jal	4efe <printf>
      exit(1);
    3b98:	4505                	li	a0,1
    3b9a:	74d000ef          	jal	4ae6 <exit>
    wait(&xstatus);
    3b9e:	f9c40513          	addi	a0,s0,-100
    3ba2:	74d000ef          	jal	4aee <wait>
    if(xstatus != 0)
    3ba6:	f9c42983          	lw	s3,-100(s0)
    3baa:	00098563          	beqz	s3,3bb4 <sharedfd+0xc2>
      exit(xstatus);
    3bae:	854e                	mv	a0,s3
    3bb0:	737000ef          	jal	4ae6 <exit>
  close(fd);
    3bb4:	854a                	mv	a0,s2
    3bb6:	759000ef          	jal	4b0e <close>
  fd = open("sharedfd", 0);
    3bba:	4581                	li	a1,0
    3bbc:	00003517          	auipc	a0,0x3
    3bc0:	08450513          	addi	a0,a0,132 # 6c40 <malloc+0x1c8e>
    3bc4:	763000ef          	jal	4b26 <open>
    3bc8:	8baa                	mv	s7,a0
  nc = np = 0;
    3bca:	8ace                	mv	s5,s3
  if(fd < 0){
    3bcc:	02054363          	bltz	a0,3bf2 <sharedfd+0x100>
    3bd0:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3bd4:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3bd8:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3bdc:	4629                	li	a2,10
    3bde:	fa040593          	addi	a1,s0,-96
    3be2:	855e                	mv	a0,s7
    3be4:	71b000ef          	jal	4afe <read>
    3be8:	02a05b63          	blez	a0,3c1e <sharedfd+0x12c>
    3bec:	fa040793          	addi	a5,s0,-96
    3bf0:	a839                	j	3c0e <sharedfd+0x11c>
    printf("%s: cannot open sharedfd for reading\n", s);
    3bf2:	85d2                	mv	a1,s4
    3bf4:	00003517          	auipc	a0,0x3
    3bf8:	0a450513          	addi	a0,a0,164 # 6c98 <malloc+0x1ce6>
    3bfc:	302010ef          	jal	4efe <printf>
    exit(1);
    3c00:	4505                	li	a0,1
    3c02:	6e5000ef          	jal	4ae6 <exit>
        nc++;
    3c06:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    3c08:	0785                	addi	a5,a5,1
    3c0a:	fd2789e3          	beq	a5,s2,3bdc <sharedfd+0xea>
      if(buf[i] == 'c')
    3c0e:	0007c703          	lbu	a4,0(a5)
    3c12:	fe970ae3          	beq	a4,s1,3c06 <sharedfd+0x114>
      if(buf[i] == 'p')
    3c16:	ff6719e3          	bne	a4,s6,3c08 <sharedfd+0x116>
        np++;
    3c1a:	2a85                	addiw	s5,s5,1
    3c1c:	b7f5                	j	3c08 <sharedfd+0x116>
  close(fd);
    3c1e:	855e                	mv	a0,s7
    3c20:	6ef000ef          	jal	4b0e <close>
  unlink("sharedfd");
    3c24:	00003517          	auipc	a0,0x3
    3c28:	01c50513          	addi	a0,a0,28 # 6c40 <malloc+0x1c8e>
    3c2c:	70b000ef          	jal	4b36 <unlink>
  if(nc == N*SZ && np == N*SZ){
    3c30:	6789                	lui	a5,0x2
    3c32:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x7c>
    3c36:	00f99763          	bne	s3,a5,3c44 <sharedfd+0x152>
    3c3a:	6789                	lui	a5,0x2
    3c3c:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x7c>
    3c40:	00fa8c63          	beq	s5,a5,3c58 <sharedfd+0x166>
    printf("%s: nc/np test fails\n", s);
    3c44:	85d2                	mv	a1,s4
    3c46:	00003517          	auipc	a0,0x3
    3c4a:	07a50513          	addi	a0,a0,122 # 6cc0 <malloc+0x1d0e>
    3c4e:	2b0010ef          	jal	4efe <printf>
    exit(1);
    3c52:	4505                	li	a0,1
    3c54:	693000ef          	jal	4ae6 <exit>
    exit(0);
    3c58:	4501                	li	a0,0
    3c5a:	68d000ef          	jal	4ae6 <exit>

0000000000003c5e <fourfiles>:
{
    3c5e:	7135                	addi	sp,sp,-160
    3c60:	ed06                	sd	ra,152(sp)
    3c62:	e922                	sd	s0,144(sp)
    3c64:	e526                	sd	s1,136(sp)
    3c66:	e14a                	sd	s2,128(sp)
    3c68:	fcce                	sd	s3,120(sp)
    3c6a:	f8d2                	sd	s4,112(sp)
    3c6c:	f4d6                	sd	s5,104(sp)
    3c6e:	f0da                	sd	s6,96(sp)
    3c70:	ecde                	sd	s7,88(sp)
    3c72:	e8e2                	sd	s8,80(sp)
    3c74:	e4e6                	sd	s9,72(sp)
    3c76:	e0ea                	sd	s10,64(sp)
    3c78:	fc6e                	sd	s11,56(sp)
    3c7a:	1100                	addi	s0,sp,160
    3c7c:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c7e:	00003797          	auipc	a5,0x3
    3c82:	05a78793          	addi	a5,a5,90 # 6cd8 <malloc+0x1d26>
    3c86:	f6f43823          	sd	a5,-144(s0)
    3c8a:	00003797          	auipc	a5,0x3
    3c8e:	05678793          	addi	a5,a5,86 # 6ce0 <malloc+0x1d2e>
    3c92:	f6f43c23          	sd	a5,-136(s0)
    3c96:	00003797          	auipc	a5,0x3
    3c9a:	05278793          	addi	a5,a5,82 # 6ce8 <malloc+0x1d36>
    3c9e:	f8f43023          	sd	a5,-128(s0)
    3ca2:	00003797          	auipc	a5,0x3
    3ca6:	04e78793          	addi	a5,a5,78 # 6cf0 <malloc+0x1d3e>
    3caa:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3cae:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3cb2:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3cb4:	4481                	li	s1,0
    3cb6:	4a11                	li	s4,4
    fname = names[pi];
    3cb8:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3cbc:	854e                	mv	a0,s3
    3cbe:	679000ef          	jal	4b36 <unlink>
    pid = fork();
    3cc2:	61d000ef          	jal	4ade <fork>
    if(pid < 0){
    3cc6:	02054e63          	bltz	a0,3d02 <fourfiles+0xa4>
    if(pid == 0){
    3cca:	c531                	beqz	a0,3d16 <fourfiles+0xb8>
  for(pi = 0; pi < NCHILD; pi++){
    3ccc:	2485                	addiw	s1,s1,1
    3cce:	0921                	addi	s2,s2,8
    3cd0:	ff4494e3          	bne	s1,s4,3cb8 <fourfiles+0x5a>
    3cd4:	4491                	li	s1,4
    wait(&xstatus);
    3cd6:	f6c40513          	addi	a0,s0,-148
    3cda:	615000ef          	jal	4aee <wait>
    if(xstatus != 0)
    3cde:	f6c42a83          	lw	s5,-148(s0)
    3ce2:	0a0a9463          	bnez	s5,3d8a <fourfiles+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    3ce6:	34fd                	addiw	s1,s1,-1
    3ce8:	f4fd                	bnez	s1,3cd6 <fourfiles+0x78>
    3cea:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3cee:	00009a17          	auipc	s4,0x9
    3cf2:	f8aa0a13          	addi	s4,s4,-118 # cc78 <buf>
    if(total != N*SZ){
    3cf6:	6d05                	lui	s10,0x1
    3cf8:	770d0d13          	addi	s10,s10,1904 # 1770 <forkfork+0x1e>
  for(i = 0; i < NCHILD; i++){
    3cfc:	03400d93          	li	s11,52
    3d00:	a0ed                	j	3dea <fourfiles+0x18c>
      printf("%s: fork failed\n", s);
    3d02:	85e6                	mv	a1,s9
    3d04:	00002517          	auipc	a0,0x2
    3d08:	c7450513          	addi	a0,a0,-908 # 5978 <malloc+0x9c6>
    3d0c:	1f2010ef          	jal	4efe <printf>
      exit(1);
    3d10:	4505                	li	a0,1
    3d12:	5d5000ef          	jal	4ae6 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3d16:	20200593          	li	a1,514
    3d1a:	854e                	mv	a0,s3
    3d1c:	60b000ef          	jal	4b26 <open>
    3d20:	892a                	mv	s2,a0
      if(fd < 0){
    3d22:	04054163          	bltz	a0,3d64 <fourfiles+0x106>
      memset(buf, '0'+pi, SZ);
    3d26:	1f400613          	li	a2,500
    3d2a:	0304859b          	addiw	a1,s1,48
    3d2e:	00009517          	auipc	a0,0x9
    3d32:	f4a50513          	addi	a0,a0,-182 # cc78 <buf>
    3d36:	365000ef          	jal	489a <memset>
    3d3a:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3d3c:	00009997          	auipc	s3,0x9
    3d40:	f3c98993          	addi	s3,s3,-196 # cc78 <buf>
    3d44:	1f400613          	li	a2,500
    3d48:	85ce                	mv	a1,s3
    3d4a:	854a                	mv	a0,s2
    3d4c:	5bb000ef          	jal	4b06 <write>
    3d50:	85aa                	mv	a1,a0
    3d52:	1f400793          	li	a5,500
    3d56:	02f51163          	bne	a0,a5,3d78 <fourfiles+0x11a>
      for(i = 0; i < N; i++){
    3d5a:	34fd                	addiw	s1,s1,-1
    3d5c:	f4e5                	bnez	s1,3d44 <fourfiles+0xe6>
      exit(0);
    3d5e:	4501                	li	a0,0
    3d60:	587000ef          	jal	4ae6 <exit>
        printf("%s: create failed\n", s);
    3d64:	85e6                	mv	a1,s9
    3d66:	00002517          	auipc	a0,0x2
    3d6a:	caa50513          	addi	a0,a0,-854 # 5a10 <malloc+0xa5e>
    3d6e:	190010ef          	jal	4efe <printf>
        exit(1);
    3d72:	4505                	li	a0,1
    3d74:	573000ef          	jal	4ae6 <exit>
          printf("write failed %d\n", n);
    3d78:	00003517          	auipc	a0,0x3
    3d7c:	f8050513          	addi	a0,a0,-128 # 6cf8 <malloc+0x1d46>
    3d80:	17e010ef          	jal	4efe <printf>
          exit(1);
    3d84:	4505                	li	a0,1
    3d86:	561000ef          	jal	4ae6 <exit>
      exit(xstatus);
    3d8a:	8556                	mv	a0,s5
    3d8c:	55b000ef          	jal	4ae6 <exit>
          printf("%s: wrong char\n", s);
    3d90:	85e6                	mv	a1,s9
    3d92:	00003517          	auipc	a0,0x3
    3d96:	f7e50513          	addi	a0,a0,-130 # 6d10 <malloc+0x1d5e>
    3d9a:	164010ef          	jal	4efe <printf>
          exit(1);
    3d9e:	4505                	li	a0,1
    3da0:	547000ef          	jal	4ae6 <exit>
      total += n;
    3da4:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3da8:	660d                	lui	a2,0x3
    3daa:	85d2                	mv	a1,s4
    3dac:	854e                	mv	a0,s3
    3dae:	551000ef          	jal	4afe <read>
    3db2:	02a05063          	blez	a0,3dd2 <fourfiles+0x174>
    3db6:	00009797          	auipc	a5,0x9
    3dba:	ec278793          	addi	a5,a5,-318 # cc78 <buf>
    3dbe:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    3dc2:	0007c703          	lbu	a4,0(a5)
    3dc6:	fc9715e3          	bne	a4,s1,3d90 <fourfiles+0x132>
      for(j = 0; j < n; j++){
    3dca:	0785                	addi	a5,a5,1
    3dcc:	fed79be3          	bne	a5,a3,3dc2 <fourfiles+0x164>
    3dd0:	bfd1                	j	3da4 <fourfiles+0x146>
    close(fd);
    3dd2:	854e                	mv	a0,s3
    3dd4:	53b000ef          	jal	4b0e <close>
    if(total != N*SZ){
    3dd8:	03a91463          	bne	s2,s10,3e00 <fourfiles+0x1a2>
    unlink(fname);
    3ddc:	8562                	mv	a0,s8
    3dde:	559000ef          	jal	4b36 <unlink>
  for(i = 0; i < NCHILD; i++){
    3de2:	0ba1                	addi	s7,s7,8
    3de4:	2b05                	addiw	s6,s6,1
    3de6:	03bb0763          	beq	s6,s11,3e14 <fourfiles+0x1b6>
    fname = names[i];
    3dea:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3dee:	4581                	li	a1,0
    3df0:	8562                	mv	a0,s8
    3df2:	535000ef          	jal	4b26 <open>
    3df6:	89aa                	mv	s3,a0
    total = 0;
    3df8:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    3dfa:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3dfe:	b76d                	j	3da8 <fourfiles+0x14a>
      printf("wrong length %d\n", total);
    3e00:	85ca                	mv	a1,s2
    3e02:	00003517          	auipc	a0,0x3
    3e06:	f1e50513          	addi	a0,a0,-226 # 6d20 <malloc+0x1d6e>
    3e0a:	0f4010ef          	jal	4efe <printf>
      exit(1);
    3e0e:	4505                	li	a0,1
    3e10:	4d7000ef          	jal	4ae6 <exit>
}
    3e14:	60ea                	ld	ra,152(sp)
    3e16:	644a                	ld	s0,144(sp)
    3e18:	64aa                	ld	s1,136(sp)
    3e1a:	690a                	ld	s2,128(sp)
    3e1c:	79e6                	ld	s3,120(sp)
    3e1e:	7a46                	ld	s4,112(sp)
    3e20:	7aa6                	ld	s5,104(sp)
    3e22:	7b06                	ld	s6,96(sp)
    3e24:	6be6                	ld	s7,88(sp)
    3e26:	6c46                	ld	s8,80(sp)
    3e28:	6ca6                	ld	s9,72(sp)
    3e2a:	6d06                	ld	s10,64(sp)
    3e2c:	7de2                	ld	s11,56(sp)
    3e2e:	610d                	addi	sp,sp,160
    3e30:	8082                	ret

0000000000003e32 <concreate>:
{
    3e32:	7135                	addi	sp,sp,-160
    3e34:	ed06                	sd	ra,152(sp)
    3e36:	e922                	sd	s0,144(sp)
    3e38:	e526                	sd	s1,136(sp)
    3e3a:	e14a                	sd	s2,128(sp)
    3e3c:	fcce                	sd	s3,120(sp)
    3e3e:	f8d2                	sd	s4,112(sp)
    3e40:	f4d6                	sd	s5,104(sp)
    3e42:	f0da                	sd	s6,96(sp)
    3e44:	ecde                	sd	s7,88(sp)
    3e46:	1100                	addi	s0,sp,160
    3e48:	89aa                	mv	s3,a0
  file[0] = 'C';
    3e4a:	04300793          	li	a5,67
    3e4e:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    3e52:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    3e56:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    3e58:	4b0d                	li	s6,3
    3e5a:	4a85                	li	s5,1
      link("C0", file);
    3e5c:	00003b97          	auipc	s7,0x3
    3e60:	edcb8b93          	addi	s7,s7,-292 # 6d38 <malloc+0x1d86>
  for(i = 0; i < N; i++){
    3e64:	02800a13          	li	s4,40
    3e68:	a41d                	j	408e <concreate+0x25c>
      link("C0", file);
    3e6a:	fa840593          	addi	a1,s0,-88
    3e6e:	855e                	mv	a0,s7
    3e70:	4d7000ef          	jal	4b46 <link>
    if(pid == 0) {
    3e74:	a411                	j	4078 <concreate+0x246>
    } else if(pid == 0 && (i % 5) == 1){
    3e76:	4795                	li	a5,5
    3e78:	02f9693b          	remw	s2,s2,a5
    3e7c:	4785                	li	a5,1
    3e7e:	02f90563          	beq	s2,a5,3ea8 <concreate+0x76>
      fd = open(file, O_CREATE | O_RDWR);
    3e82:	20200593          	li	a1,514
    3e86:	fa840513          	addi	a0,s0,-88
    3e8a:	49d000ef          	jal	4b26 <open>
      if(fd < 0){
    3e8e:	1e055063          	bgez	a0,406e <concreate+0x23c>
        printf("concreate create %s failed\n", file);
    3e92:	fa840593          	addi	a1,s0,-88
    3e96:	00003517          	auipc	a0,0x3
    3e9a:	eaa50513          	addi	a0,a0,-342 # 6d40 <malloc+0x1d8e>
    3e9e:	060010ef          	jal	4efe <printf>
        exit(1);
    3ea2:	4505                	li	a0,1
    3ea4:	443000ef          	jal	4ae6 <exit>
      link("C0", file);
    3ea8:	fa840593          	addi	a1,s0,-88
    3eac:	00003517          	auipc	a0,0x3
    3eb0:	e8c50513          	addi	a0,a0,-372 # 6d38 <malloc+0x1d86>
    3eb4:	493000ef          	jal	4b46 <link>
      exit(0);
    3eb8:	4501                	li	a0,0
    3eba:	42d000ef          	jal	4ae6 <exit>
        exit(1);
    3ebe:	4505                	li	a0,1
    3ec0:	427000ef          	jal	4ae6 <exit>
  memset(fa, 0, sizeof(fa));
    3ec4:	02800613          	li	a2,40
    3ec8:	4581                	li	a1,0
    3eca:	f8040513          	addi	a0,s0,-128
    3ece:	1cd000ef          	jal	489a <memset>
  fd = open(".", 0);
    3ed2:	4581                	li	a1,0
    3ed4:	00002517          	auipc	a0,0x2
    3ed8:	8fc50513          	addi	a0,a0,-1796 # 57d0 <malloc+0x81e>
    3edc:	44b000ef          	jal	4b26 <open>
    3ee0:	892a                	mv	s2,a0
  n = 0;
    3ee2:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3ee4:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    3ee8:	02700b13          	li	s6,39
      fa[i] = 1;
    3eec:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    3eee:	4641                	li	a2,16
    3ef0:	f7040593          	addi	a1,s0,-144
    3ef4:	854a                	mv	a0,s2
    3ef6:	409000ef          	jal	4afe <read>
    3efa:	06a05a63          	blez	a0,3f6e <concreate+0x13c>
    if(de.inum == 0)
    3efe:	f7045783          	lhu	a5,-144(s0)
    3f02:	d7f5                	beqz	a5,3eee <concreate+0xbc>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3f04:	f7244783          	lbu	a5,-142(s0)
    3f08:	ff4793e3          	bne	a5,s4,3eee <concreate+0xbc>
    3f0c:	f7444783          	lbu	a5,-140(s0)
    3f10:	fff9                	bnez	a5,3eee <concreate+0xbc>
      i = de.name[1] - '0';
    3f12:	f7344783          	lbu	a5,-141(s0)
    3f16:	fd07879b          	addiw	a5,a5,-48
    3f1a:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    3f1e:	02eb6063          	bltu	s6,a4,3f3e <concreate+0x10c>
      if(fa[i]){
    3f22:	fb070793          	addi	a5,a4,-80 # fb0 <bigdir+0x112>
    3f26:	97a2                	add	a5,a5,s0
    3f28:	fd07c783          	lbu	a5,-48(a5)
    3f2c:	e78d                	bnez	a5,3f56 <concreate+0x124>
      fa[i] = 1;
    3f2e:	fb070793          	addi	a5,a4,-80
    3f32:	00878733          	add	a4,a5,s0
    3f36:	fd770823          	sb	s7,-48(a4)
      n++;
    3f3a:	2a85                	addiw	s5,s5,1
    3f3c:	bf4d                	j	3eee <concreate+0xbc>
        printf("%s: concreate weird file %s\n", s, de.name);
    3f3e:	f7240613          	addi	a2,s0,-142
    3f42:	85ce                	mv	a1,s3
    3f44:	00003517          	auipc	a0,0x3
    3f48:	e1c50513          	addi	a0,a0,-484 # 6d60 <malloc+0x1dae>
    3f4c:	7b3000ef          	jal	4efe <printf>
        exit(1);
    3f50:	4505                	li	a0,1
    3f52:	395000ef          	jal	4ae6 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3f56:	f7240613          	addi	a2,s0,-142
    3f5a:	85ce                	mv	a1,s3
    3f5c:	00003517          	auipc	a0,0x3
    3f60:	e2450513          	addi	a0,a0,-476 # 6d80 <malloc+0x1dce>
    3f64:	79b000ef          	jal	4efe <printf>
        exit(1);
    3f68:	4505                	li	a0,1
    3f6a:	37d000ef          	jal	4ae6 <exit>
  close(fd);
    3f6e:	854a                	mv	a0,s2
    3f70:	39f000ef          	jal	4b0e <close>
  if(n != N){
    3f74:	02800793          	li	a5,40
    3f78:	00fa9763          	bne	s5,a5,3f86 <concreate+0x154>
    if(((i % 3) == 0 && pid == 0) ||
    3f7c:	4a8d                	li	s5,3
    3f7e:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    3f80:	02800a13          	li	s4,40
    3f84:	a079                	j	4012 <concreate+0x1e0>
    printf("%s: concreate not enough files in directory listing\n", s);
    3f86:	85ce                	mv	a1,s3
    3f88:	00003517          	auipc	a0,0x3
    3f8c:	e2050513          	addi	a0,a0,-480 # 6da8 <malloc+0x1df6>
    3f90:	76f000ef          	jal	4efe <printf>
    exit(1);
    3f94:	4505                	li	a0,1
    3f96:	351000ef          	jal	4ae6 <exit>
      printf("%s: fork failed\n", s);
    3f9a:	85ce                	mv	a1,s3
    3f9c:	00002517          	auipc	a0,0x2
    3fa0:	9dc50513          	addi	a0,a0,-1572 # 5978 <malloc+0x9c6>
    3fa4:	75b000ef          	jal	4efe <printf>
      exit(1);
    3fa8:	4505                	li	a0,1
    3faa:	33d000ef          	jal	4ae6 <exit>
      close(open(file, 0));
    3fae:	4581                	li	a1,0
    3fb0:	fa840513          	addi	a0,s0,-88
    3fb4:	373000ef          	jal	4b26 <open>
    3fb8:	357000ef          	jal	4b0e <close>
      close(open(file, 0));
    3fbc:	4581                	li	a1,0
    3fbe:	fa840513          	addi	a0,s0,-88
    3fc2:	365000ef          	jal	4b26 <open>
    3fc6:	349000ef          	jal	4b0e <close>
      close(open(file, 0));
    3fca:	4581                	li	a1,0
    3fcc:	fa840513          	addi	a0,s0,-88
    3fd0:	357000ef          	jal	4b26 <open>
    3fd4:	33b000ef          	jal	4b0e <close>
      close(open(file, 0));
    3fd8:	4581                	li	a1,0
    3fda:	fa840513          	addi	a0,s0,-88
    3fde:	349000ef          	jal	4b26 <open>
    3fe2:	32d000ef          	jal	4b0e <close>
      close(open(file, 0));
    3fe6:	4581                	li	a1,0
    3fe8:	fa840513          	addi	a0,s0,-88
    3fec:	33b000ef          	jal	4b26 <open>
    3ff0:	31f000ef          	jal	4b0e <close>
      close(open(file, 0));
    3ff4:	4581                	li	a1,0
    3ff6:	fa840513          	addi	a0,s0,-88
    3ffa:	32d000ef          	jal	4b26 <open>
    3ffe:	311000ef          	jal	4b0e <close>
    if(pid == 0)
    4002:	06090363          	beqz	s2,4068 <concreate+0x236>
      wait(0);
    4006:	4501                	li	a0,0
    4008:	2e7000ef          	jal	4aee <wait>
  for(i = 0; i < N; i++){
    400c:	2485                	addiw	s1,s1,1
    400e:	0b448963          	beq	s1,s4,40c0 <concreate+0x28e>
    file[1] = '0' + i;
    4012:	0304879b          	addiw	a5,s1,48
    4016:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    401a:	2c5000ef          	jal	4ade <fork>
    401e:	892a                	mv	s2,a0
    if(pid < 0){
    4020:	f6054de3          	bltz	a0,3f9a <concreate+0x168>
    if(((i % 3) == 0 && pid == 0) ||
    4024:	0354e73b          	remw	a4,s1,s5
    4028:	00a767b3          	or	a5,a4,a0
    402c:	2781                	sext.w	a5,a5
    402e:	d3c1                	beqz	a5,3fae <concreate+0x17c>
    4030:	01671363          	bne	a4,s6,4036 <concreate+0x204>
       ((i % 3) == 1 && pid != 0)){
    4034:	fd2d                	bnez	a0,3fae <concreate+0x17c>
      unlink(file);
    4036:	fa840513          	addi	a0,s0,-88
    403a:	2fd000ef          	jal	4b36 <unlink>
      unlink(file);
    403e:	fa840513          	addi	a0,s0,-88
    4042:	2f5000ef          	jal	4b36 <unlink>
      unlink(file);
    4046:	fa840513          	addi	a0,s0,-88
    404a:	2ed000ef          	jal	4b36 <unlink>
      unlink(file);
    404e:	fa840513          	addi	a0,s0,-88
    4052:	2e5000ef          	jal	4b36 <unlink>
      unlink(file);
    4056:	fa840513          	addi	a0,s0,-88
    405a:	2dd000ef          	jal	4b36 <unlink>
      unlink(file);
    405e:	fa840513          	addi	a0,s0,-88
    4062:	2d5000ef          	jal	4b36 <unlink>
    4066:	bf71                	j	4002 <concreate+0x1d0>
      exit(0);
    4068:	4501                	li	a0,0
    406a:	27d000ef          	jal	4ae6 <exit>
      close(fd);
    406e:	2a1000ef          	jal	4b0e <close>
    if(pid == 0) {
    4072:	b599                	j	3eb8 <concreate+0x86>
      close(fd);
    4074:	29b000ef          	jal	4b0e <close>
      wait(&xstatus);
    4078:	f6c40513          	addi	a0,s0,-148
    407c:	273000ef          	jal	4aee <wait>
      if(xstatus != 0)
    4080:	f6c42483          	lw	s1,-148(s0)
    4084:	e2049de3          	bnez	s1,3ebe <concreate+0x8c>
  for(i = 0; i < N; i++){
    4088:	2905                	addiw	s2,s2,1
    408a:	e3490de3          	beq	s2,s4,3ec4 <concreate+0x92>
    file[1] = '0' + i;
    408e:	0309079b          	addiw	a5,s2,48
    4092:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4096:	fa840513          	addi	a0,s0,-88
    409a:	29d000ef          	jal	4b36 <unlink>
    pid = fork();
    409e:	241000ef          	jal	4ade <fork>
    if(pid && (i % 3) == 1){
    40a2:	dc050ae3          	beqz	a0,3e76 <concreate+0x44>
    40a6:	036967bb          	remw	a5,s2,s6
    40aa:	dd5780e3          	beq	a5,s5,3e6a <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    40ae:	20200593          	li	a1,514
    40b2:	fa840513          	addi	a0,s0,-88
    40b6:	271000ef          	jal	4b26 <open>
      if(fd < 0){
    40ba:	fa055de3          	bgez	a0,4074 <concreate+0x242>
    40be:	bbd1                	j	3e92 <concreate+0x60>
}
    40c0:	60ea                	ld	ra,152(sp)
    40c2:	644a                	ld	s0,144(sp)
    40c4:	64aa                	ld	s1,136(sp)
    40c6:	690a                	ld	s2,128(sp)
    40c8:	79e6                	ld	s3,120(sp)
    40ca:	7a46                	ld	s4,112(sp)
    40cc:	7aa6                	ld	s5,104(sp)
    40ce:	7b06                	ld	s6,96(sp)
    40d0:	6be6                	ld	s7,88(sp)
    40d2:	610d                	addi	sp,sp,160
    40d4:	8082                	ret

00000000000040d6 <bigfile>:
{
    40d6:	7139                	addi	sp,sp,-64
    40d8:	fc06                	sd	ra,56(sp)
    40da:	f822                	sd	s0,48(sp)
    40dc:	f426                	sd	s1,40(sp)
    40de:	f04a                	sd	s2,32(sp)
    40e0:	ec4e                	sd	s3,24(sp)
    40e2:	e852                	sd	s4,16(sp)
    40e4:	e456                	sd	s5,8(sp)
    40e6:	0080                	addi	s0,sp,64
    40e8:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    40ea:	00003517          	auipc	a0,0x3
    40ee:	cf650513          	addi	a0,a0,-778 # 6de0 <malloc+0x1e2e>
    40f2:	245000ef          	jal	4b36 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    40f6:	20200593          	li	a1,514
    40fa:	00003517          	auipc	a0,0x3
    40fe:	ce650513          	addi	a0,a0,-794 # 6de0 <malloc+0x1e2e>
    4102:	225000ef          	jal	4b26 <open>
    4106:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4108:	4481                	li	s1,0
    memset(buf, i, SZ);
    410a:	00009917          	auipc	s2,0x9
    410e:	b6e90913          	addi	s2,s2,-1170 # cc78 <buf>
  for(i = 0; i < N; i++){
    4112:	4a51                	li	s4,20
  if(fd < 0){
    4114:	08054663          	bltz	a0,41a0 <bigfile+0xca>
    memset(buf, i, SZ);
    4118:	25800613          	li	a2,600
    411c:	85a6                	mv	a1,s1
    411e:	854a                	mv	a0,s2
    4120:	77a000ef          	jal	489a <memset>
    if(write(fd, buf, SZ) != SZ){
    4124:	25800613          	li	a2,600
    4128:	85ca                	mv	a1,s2
    412a:	854e                	mv	a0,s3
    412c:	1db000ef          	jal	4b06 <write>
    4130:	25800793          	li	a5,600
    4134:	08f51063          	bne	a0,a5,41b4 <bigfile+0xde>
  for(i = 0; i < N; i++){
    4138:	2485                	addiw	s1,s1,1
    413a:	fd449fe3          	bne	s1,s4,4118 <bigfile+0x42>
  close(fd);
    413e:	854e                	mv	a0,s3
    4140:	1cf000ef          	jal	4b0e <close>
  fd = open("bigfile.dat", 0);
    4144:	4581                	li	a1,0
    4146:	00003517          	auipc	a0,0x3
    414a:	c9a50513          	addi	a0,a0,-870 # 6de0 <malloc+0x1e2e>
    414e:	1d9000ef          	jal	4b26 <open>
    4152:	8a2a                	mv	s4,a0
  total = 0;
    4154:	4981                	li	s3,0
  for(i = 0; ; i++){
    4156:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4158:	00009917          	auipc	s2,0x9
    415c:	b2090913          	addi	s2,s2,-1248 # cc78 <buf>
  if(fd < 0){
    4160:	06054463          	bltz	a0,41c8 <bigfile+0xf2>
    cc = read(fd, buf, SZ/2);
    4164:	12c00613          	li	a2,300
    4168:	85ca                	mv	a1,s2
    416a:	8552                	mv	a0,s4
    416c:	193000ef          	jal	4afe <read>
    if(cc < 0){
    4170:	06054663          	bltz	a0,41dc <bigfile+0x106>
    if(cc == 0)
    4174:	c155                	beqz	a0,4218 <bigfile+0x142>
    if(cc != SZ/2){
    4176:	12c00793          	li	a5,300
    417a:	06f51b63          	bne	a0,a5,41f0 <bigfile+0x11a>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    417e:	01f4d79b          	srliw	a5,s1,0x1f
    4182:	9fa5                	addw	a5,a5,s1
    4184:	4017d79b          	sraiw	a5,a5,0x1
    4188:	00094703          	lbu	a4,0(s2)
    418c:	06f71c63          	bne	a4,a5,4204 <bigfile+0x12e>
    4190:	12b94703          	lbu	a4,299(s2)
    4194:	06f71863          	bne	a4,a5,4204 <bigfile+0x12e>
    total += cc;
    4198:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    419c:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    419e:	b7d9                	j	4164 <bigfile+0x8e>
    printf("%s: cannot create bigfile", s);
    41a0:	85d6                	mv	a1,s5
    41a2:	00003517          	auipc	a0,0x3
    41a6:	c4e50513          	addi	a0,a0,-946 # 6df0 <malloc+0x1e3e>
    41aa:	555000ef          	jal	4efe <printf>
    exit(1);
    41ae:	4505                	li	a0,1
    41b0:	137000ef          	jal	4ae6 <exit>
      printf("%s: write bigfile failed\n", s);
    41b4:	85d6                	mv	a1,s5
    41b6:	00003517          	auipc	a0,0x3
    41ba:	c5a50513          	addi	a0,a0,-934 # 6e10 <malloc+0x1e5e>
    41be:	541000ef          	jal	4efe <printf>
      exit(1);
    41c2:	4505                	li	a0,1
    41c4:	123000ef          	jal	4ae6 <exit>
    printf("%s: cannot open bigfile\n", s);
    41c8:	85d6                	mv	a1,s5
    41ca:	00003517          	auipc	a0,0x3
    41ce:	c6650513          	addi	a0,a0,-922 # 6e30 <malloc+0x1e7e>
    41d2:	52d000ef          	jal	4efe <printf>
    exit(1);
    41d6:	4505                	li	a0,1
    41d8:	10f000ef          	jal	4ae6 <exit>
      printf("%s: read bigfile failed\n", s);
    41dc:	85d6                	mv	a1,s5
    41de:	00003517          	auipc	a0,0x3
    41e2:	c7250513          	addi	a0,a0,-910 # 6e50 <malloc+0x1e9e>
    41e6:	519000ef          	jal	4efe <printf>
      exit(1);
    41ea:	4505                	li	a0,1
    41ec:	0fb000ef          	jal	4ae6 <exit>
      printf("%s: short read bigfile\n", s);
    41f0:	85d6                	mv	a1,s5
    41f2:	00003517          	auipc	a0,0x3
    41f6:	c7e50513          	addi	a0,a0,-898 # 6e70 <malloc+0x1ebe>
    41fa:	505000ef          	jal	4efe <printf>
      exit(1);
    41fe:	4505                	li	a0,1
    4200:	0e7000ef          	jal	4ae6 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4204:	85d6                	mv	a1,s5
    4206:	00003517          	auipc	a0,0x3
    420a:	c8250513          	addi	a0,a0,-894 # 6e88 <malloc+0x1ed6>
    420e:	4f1000ef          	jal	4efe <printf>
      exit(1);
    4212:	4505                	li	a0,1
    4214:	0d3000ef          	jal	4ae6 <exit>
  close(fd);
    4218:	8552                	mv	a0,s4
    421a:	0f5000ef          	jal	4b0e <close>
  if(total != N*SZ){
    421e:	678d                	lui	a5,0x3
    4220:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x304>
    4224:	02f99163          	bne	s3,a5,4246 <bigfile+0x170>
  unlink("bigfile.dat");
    4228:	00003517          	auipc	a0,0x3
    422c:	bb850513          	addi	a0,a0,-1096 # 6de0 <malloc+0x1e2e>
    4230:	107000ef          	jal	4b36 <unlink>
}
    4234:	70e2                	ld	ra,56(sp)
    4236:	7442                	ld	s0,48(sp)
    4238:	74a2                	ld	s1,40(sp)
    423a:	7902                	ld	s2,32(sp)
    423c:	69e2                	ld	s3,24(sp)
    423e:	6a42                	ld	s4,16(sp)
    4240:	6aa2                	ld	s5,8(sp)
    4242:	6121                	addi	sp,sp,64
    4244:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4246:	85d6                	mv	a1,s5
    4248:	00003517          	auipc	a0,0x3
    424c:	c6050513          	addi	a0,a0,-928 # 6ea8 <malloc+0x1ef6>
    4250:	4af000ef          	jal	4efe <printf>
    exit(1);
    4254:	4505                	li	a0,1
    4256:	091000ef          	jal	4ae6 <exit>

000000000000425a <bigargtest>:
{
    425a:	7121                	addi	sp,sp,-448
    425c:	ff06                	sd	ra,440(sp)
    425e:	fb22                	sd	s0,432(sp)
    4260:	f726                	sd	s1,424(sp)
    4262:	0380                	addi	s0,sp,448
    4264:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4266:	00003517          	auipc	a0,0x3
    426a:	c6250513          	addi	a0,a0,-926 # 6ec8 <malloc+0x1f16>
    426e:	0c9000ef          	jal	4b36 <unlink>
  pid = fork();
    4272:	06d000ef          	jal	4ade <fork>
  if(pid == 0){
    4276:	c915                	beqz	a0,42aa <bigargtest+0x50>
  } else if(pid < 0){
    4278:	08054a63          	bltz	a0,430c <bigargtest+0xb2>
  wait(&xstatus);
    427c:	fdc40513          	addi	a0,s0,-36
    4280:	06f000ef          	jal	4aee <wait>
  if(xstatus != 0)
    4284:	fdc42503          	lw	a0,-36(s0)
    4288:	ed41                	bnez	a0,4320 <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
    428a:	4581                	li	a1,0
    428c:	00003517          	auipc	a0,0x3
    4290:	c3c50513          	addi	a0,a0,-964 # 6ec8 <malloc+0x1f16>
    4294:	093000ef          	jal	4b26 <open>
  if(fd < 0){
    4298:	08054663          	bltz	a0,4324 <bigargtest+0xca>
  close(fd);
    429c:	073000ef          	jal	4b0e <close>
}
    42a0:	70fa                	ld	ra,440(sp)
    42a2:	745a                	ld	s0,432(sp)
    42a4:	74ba                	ld	s1,424(sp)
    42a6:	6139                	addi	sp,sp,448
    42a8:	8082                	ret
    memset(big, ' ', sizeof(big));
    42aa:	19000613          	li	a2,400
    42ae:	02000593          	li	a1,32
    42b2:	e4840513          	addi	a0,s0,-440
    42b6:	5e4000ef          	jal	489a <memset>
    big[sizeof(big)-1] = '\0';
    42ba:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    42be:	00005797          	auipc	a5,0x5
    42c2:	1a278793          	addi	a5,a5,418 # 9460 <args.1>
    42c6:	00005697          	auipc	a3,0x5
    42ca:	29268693          	addi	a3,a3,658 # 9558 <args.1+0xf8>
      args[i] = big;
    42ce:	e4840713          	addi	a4,s0,-440
    42d2:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    42d4:	07a1                	addi	a5,a5,8
    42d6:	fed79ee3          	bne	a5,a3,42d2 <bigargtest+0x78>
    args[MAXARG-1] = 0;
    42da:	00005597          	auipc	a1,0x5
    42de:	18658593          	addi	a1,a1,390 # 9460 <args.1>
    42e2:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    42e6:	00001517          	auipc	a0,0x1
    42ea:	e0250513          	addi	a0,a0,-510 # 50e8 <malloc+0x136>
    42ee:	031000ef          	jal	4b1e <exec>
    fd = open("bigarg-ok", O_CREATE);
    42f2:	20000593          	li	a1,512
    42f6:	00003517          	auipc	a0,0x3
    42fa:	bd250513          	addi	a0,a0,-1070 # 6ec8 <malloc+0x1f16>
    42fe:	029000ef          	jal	4b26 <open>
    close(fd);
    4302:	00d000ef          	jal	4b0e <close>
    exit(0);
    4306:	4501                	li	a0,0
    4308:	7de000ef          	jal	4ae6 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    430c:	85a6                	mv	a1,s1
    430e:	00003517          	auipc	a0,0x3
    4312:	bca50513          	addi	a0,a0,-1078 # 6ed8 <malloc+0x1f26>
    4316:	3e9000ef          	jal	4efe <printf>
    exit(1);
    431a:	4505                	li	a0,1
    431c:	7ca000ef          	jal	4ae6 <exit>
    exit(xstatus);
    4320:	7c6000ef          	jal	4ae6 <exit>
    printf("%s: bigarg test failed!\n", s);
    4324:	85a6                	mv	a1,s1
    4326:	00003517          	auipc	a0,0x3
    432a:	bd250513          	addi	a0,a0,-1070 # 6ef8 <malloc+0x1f46>
    432e:	3d1000ef          	jal	4efe <printf>
    exit(1);
    4332:	4505                	li	a0,1
    4334:	7b2000ef          	jal	4ae6 <exit>

0000000000004338 <fsfull>:
{
    4338:	7135                	addi	sp,sp,-160
    433a:	ed06                	sd	ra,152(sp)
    433c:	e922                	sd	s0,144(sp)
    433e:	e526                	sd	s1,136(sp)
    4340:	e14a                	sd	s2,128(sp)
    4342:	fcce                	sd	s3,120(sp)
    4344:	f8d2                	sd	s4,112(sp)
    4346:	f4d6                	sd	s5,104(sp)
    4348:	f0da                	sd	s6,96(sp)
    434a:	ecde                	sd	s7,88(sp)
    434c:	e8e2                	sd	s8,80(sp)
    434e:	e4e6                	sd	s9,72(sp)
    4350:	e0ea                	sd	s10,64(sp)
    4352:	1100                	addi	s0,sp,160
  printf("fsfull test\n");
    4354:	00003517          	auipc	a0,0x3
    4358:	bc450513          	addi	a0,a0,-1084 # 6f18 <malloc+0x1f66>
    435c:	3a3000ef          	jal	4efe <printf>
  for(nfiles = 0; ; nfiles++){
    4360:	4481                	li	s1,0
    name[0] = 'f';
    4362:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4366:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    436a:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    436e:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4370:	00003c97          	auipc	s9,0x3
    4374:	bb8c8c93          	addi	s9,s9,-1096 # 6f28 <malloc+0x1f76>
    name[0] = 'f';
    4378:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    437c:	0384c7bb          	divw	a5,s1,s8
    4380:	0307879b          	addiw	a5,a5,48
    4384:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4388:	0384e7bb          	remw	a5,s1,s8
    438c:	0377c7bb          	divw	a5,a5,s7
    4390:	0307879b          	addiw	a5,a5,48
    4394:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4398:	0374e7bb          	remw	a5,s1,s7
    439c:	0367c7bb          	divw	a5,a5,s6
    43a0:	0307879b          	addiw	a5,a5,48
    43a4:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    43a8:	0364e7bb          	remw	a5,s1,s6
    43ac:	0307879b          	addiw	a5,a5,48
    43b0:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    43b4:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    43b8:	f6040593          	addi	a1,s0,-160
    43bc:	8566                	mv	a0,s9
    43be:	341000ef          	jal	4efe <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    43c2:	20200593          	li	a1,514
    43c6:	f6040513          	addi	a0,s0,-160
    43ca:	75c000ef          	jal	4b26 <open>
    43ce:	892a                	mv	s2,a0
    if(fd < 0){
    43d0:	08055f63          	bgez	a0,446e <fsfull+0x136>
      printf("open %s failed\n", name);
    43d4:	f6040593          	addi	a1,s0,-160
    43d8:	00003517          	auipc	a0,0x3
    43dc:	b6050513          	addi	a0,a0,-1184 # 6f38 <malloc+0x1f86>
    43e0:	31f000ef          	jal	4efe <printf>
  while(nfiles >= 0){
    43e4:	0604c163          	bltz	s1,4446 <fsfull+0x10e>
    name[0] = 'f';
    43e8:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    43ec:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    43f0:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    43f4:	4929                	li	s2,10
  while(nfiles >= 0){
    43f6:	5afd                	li	s5,-1
    name[0] = 'f';
    43f8:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    43fc:	0344c7bb          	divw	a5,s1,s4
    4400:	0307879b          	addiw	a5,a5,48
    4404:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4408:	0344e7bb          	remw	a5,s1,s4
    440c:	0337c7bb          	divw	a5,a5,s3
    4410:	0307879b          	addiw	a5,a5,48
    4414:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4418:	0334e7bb          	remw	a5,s1,s3
    441c:	0327c7bb          	divw	a5,a5,s2
    4420:	0307879b          	addiw	a5,a5,48
    4424:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4428:	0324e7bb          	remw	a5,s1,s2
    442c:	0307879b          	addiw	a5,a5,48
    4430:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4434:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    4438:	f6040513          	addi	a0,s0,-160
    443c:	6fa000ef          	jal	4b36 <unlink>
    nfiles--;
    4440:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4442:	fb549be3          	bne	s1,s5,43f8 <fsfull+0xc0>
  printf("fsfull test finished\n");
    4446:	00003517          	auipc	a0,0x3
    444a:	b1250513          	addi	a0,a0,-1262 # 6f58 <malloc+0x1fa6>
    444e:	2b1000ef          	jal	4efe <printf>
}
    4452:	60ea                	ld	ra,152(sp)
    4454:	644a                	ld	s0,144(sp)
    4456:	64aa                	ld	s1,136(sp)
    4458:	690a                	ld	s2,128(sp)
    445a:	79e6                	ld	s3,120(sp)
    445c:	7a46                	ld	s4,112(sp)
    445e:	7aa6                	ld	s5,104(sp)
    4460:	7b06                	ld	s6,96(sp)
    4462:	6be6                	ld	s7,88(sp)
    4464:	6c46                	ld	s8,80(sp)
    4466:	6ca6                	ld	s9,72(sp)
    4468:	6d06                	ld	s10,64(sp)
    446a:	610d                	addi	sp,sp,160
    446c:	8082                	ret
    int total = 0;
    446e:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    4470:	00009a97          	auipc	s5,0x9
    4474:	808a8a93          	addi	s5,s5,-2040 # cc78 <buf>
      if(cc < BSIZE)
    4478:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    447c:	40000613          	li	a2,1024
    4480:	85d6                	mv	a1,s5
    4482:	854a                	mv	a0,s2
    4484:	682000ef          	jal	4b06 <write>
      if(cc < BSIZE)
    4488:	00aa5563          	bge	s4,a0,4492 <fsfull+0x15a>
      total += cc;
    448c:	00a989bb          	addw	s3,s3,a0
    while(1){
    4490:	b7f5                	j	447c <fsfull+0x144>
    printf("wrote %d bytes\n", total);
    4492:	85ce                	mv	a1,s3
    4494:	00003517          	auipc	a0,0x3
    4498:	ab450513          	addi	a0,a0,-1356 # 6f48 <malloc+0x1f96>
    449c:	263000ef          	jal	4efe <printf>
    close(fd);
    44a0:	854a                	mv	a0,s2
    44a2:	66c000ef          	jal	4b0e <close>
    if(total == 0)
    44a6:	f2098fe3          	beqz	s3,43e4 <fsfull+0xac>
  for(nfiles = 0; ; nfiles++){
    44aa:	2485                	addiw	s1,s1,1
    44ac:	b5f1                	j	4378 <fsfull+0x40>

00000000000044ae <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    44ae:	7179                	addi	sp,sp,-48
    44b0:	f406                	sd	ra,40(sp)
    44b2:	f022                	sd	s0,32(sp)
    44b4:	ec26                	sd	s1,24(sp)
    44b6:	e84a                	sd	s2,16(sp)
    44b8:	1800                	addi	s0,sp,48
    44ba:	84aa                	mv	s1,a0
    44bc:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    44be:	00003517          	auipc	a0,0x3
    44c2:	ab250513          	addi	a0,a0,-1358 # 6f70 <malloc+0x1fbe>
    44c6:	239000ef          	jal	4efe <printf>
  if((pid = fork()) < 0) {
    44ca:	614000ef          	jal	4ade <fork>
    44ce:	02054a63          	bltz	a0,4502 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    44d2:	c129                	beqz	a0,4514 <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    44d4:	fdc40513          	addi	a0,s0,-36
    44d8:	616000ef          	jal	4aee <wait>
    if(xstatus != 0) 
    44dc:	fdc42783          	lw	a5,-36(s0)
    44e0:	cf9d                	beqz	a5,451e <run+0x70>
      printf("FAILED\n");
    44e2:	00003517          	auipc	a0,0x3
    44e6:	ab650513          	addi	a0,a0,-1354 # 6f98 <malloc+0x1fe6>
    44ea:	215000ef          	jal	4efe <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    44ee:	fdc42503          	lw	a0,-36(s0)
  }
}
    44f2:	00153513          	seqz	a0,a0
    44f6:	70a2                	ld	ra,40(sp)
    44f8:	7402                	ld	s0,32(sp)
    44fa:	64e2                	ld	s1,24(sp)
    44fc:	6942                	ld	s2,16(sp)
    44fe:	6145                	addi	sp,sp,48
    4500:	8082                	ret
    printf("runtest: fork error\n");
    4502:	00003517          	auipc	a0,0x3
    4506:	a7e50513          	addi	a0,a0,-1410 # 6f80 <malloc+0x1fce>
    450a:	1f5000ef          	jal	4efe <printf>
    exit(1);
    450e:	4505                	li	a0,1
    4510:	5d6000ef          	jal	4ae6 <exit>
    f(s);
    4514:	854a                	mv	a0,s2
    4516:	9482                	jalr	s1
    exit(0);
    4518:	4501                	li	a0,0
    451a:	5cc000ef          	jal	4ae6 <exit>
      printf("OK\n");
    451e:	00003517          	auipc	a0,0x3
    4522:	a8250513          	addi	a0,a0,-1406 # 6fa0 <malloc+0x1fee>
    4526:	1d9000ef          	jal	4efe <printf>
    452a:	b7d1                	j	44ee <run+0x40>

000000000000452c <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    452c:	7139                	addi	sp,sp,-64
    452e:	fc06                	sd	ra,56(sp)
    4530:	f822                	sd	s0,48(sp)
    4532:	f04a                	sd	s2,32(sp)
    4534:	0080                	addi	s0,sp,64
  for (struct test *t = tests; t->s != 0; t++) {
    4536:	00853903          	ld	s2,8(a0)
    453a:	06090463          	beqz	s2,45a2 <runtests+0x76>
    453e:	f426                	sd	s1,40(sp)
    4540:	ec4e                	sd	s3,24(sp)
    4542:	e852                	sd	s4,16(sp)
    4544:	e456                	sd	s5,8(sp)
    4546:	84aa                	mv	s1,a0
    4548:	89ae                	mv	s3,a1
    454a:	8a32                	mv	s4,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    454c:	4a89                	li	s5,2
    454e:	a031                	j	455a <runtests+0x2e>
  for (struct test *t = tests; t->s != 0; t++) {
    4550:	04c1                	addi	s1,s1,16
    4552:	0084b903          	ld	s2,8(s1)
    4556:	02090c63          	beqz	s2,458e <runtests+0x62>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    455a:	00098763          	beqz	s3,4568 <runtests+0x3c>
    455e:	85ce                	mv	a1,s3
    4560:	854a                	mv	a0,s2
    4562:	2e2000ef          	jal	4844 <strcmp>
    4566:	f56d                	bnez	a0,4550 <runtests+0x24>
      if(!run(t->f, t->s)){
    4568:	85ca                	mv	a1,s2
    456a:	6088                	ld	a0,0(s1)
    456c:	f43ff0ef          	jal	44ae <run>
    4570:	f165                	bnez	a0,4550 <runtests+0x24>
        if(continuous != 2){
    4572:	fd5a0fe3          	beq	s4,s5,4550 <runtests+0x24>
          printf("SOME TESTS FAILED\n");
    4576:	00003517          	auipc	a0,0x3
    457a:	a3250513          	addi	a0,a0,-1486 # 6fa8 <malloc+0x1ff6>
    457e:	181000ef          	jal	4efe <printf>
          return 1;
    4582:	4505                	li	a0,1
    4584:	74a2                	ld	s1,40(sp)
    4586:	69e2                	ld	s3,24(sp)
    4588:	6a42                	ld	s4,16(sp)
    458a:	6aa2                	ld	s5,8(sp)
    458c:	a031                	j	4598 <runtests+0x6c>
        }
      }
    }
  }
  return 0;
    458e:	4501                	li	a0,0
    4590:	74a2                	ld	s1,40(sp)
    4592:	69e2                	ld	s3,24(sp)
    4594:	6a42                	ld	s4,16(sp)
    4596:	6aa2                	ld	s5,8(sp)
}
    4598:	70e2                	ld	ra,56(sp)
    459a:	7442                	ld	s0,48(sp)
    459c:	7902                	ld	s2,32(sp)
    459e:	6121                	addi	sp,sp,64
    45a0:	8082                	ret
  return 0;
    45a2:	4501                	li	a0,0
    45a4:	bfd5                	j	4598 <runtests+0x6c>

00000000000045a6 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    45a6:	7139                	addi	sp,sp,-64
    45a8:	fc06                	sd	ra,56(sp)
    45aa:	f822                	sd	s0,48(sp)
    45ac:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    45ae:	fc840513          	addi	a0,s0,-56
    45b2:	544000ef          	jal	4af6 <pipe>
    45b6:	04054e63          	bltz	a0,4612 <countfree+0x6c>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    45ba:	524000ef          	jal	4ade <fork>

  if(pid < 0){
    45be:	06054663          	bltz	a0,462a <countfree+0x84>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    45c2:	e159                	bnez	a0,4648 <countfree+0xa2>
    45c4:	f426                	sd	s1,40(sp)
    45c6:	f04a                	sd	s2,32(sp)
    45c8:	ec4e                	sd	s3,24(sp)
    close(fds[0]);
    45ca:	fc842503          	lw	a0,-56(s0)
    45ce:	540000ef          	jal	4b0e <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    45d2:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    45d4:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    45d6:	00001997          	auipc	s3,0x1
    45da:	b8298993          	addi	s3,s3,-1150 # 5158 <malloc+0x1a6>
      uint64 a = (uint64) sbrk(4096);
    45de:	6505                	lui	a0,0x1
    45e0:	58e000ef          	jal	4b6e <sbrk>
      if(a == 0xffffffffffffffff){
    45e4:	05250f63          	beq	a0,s2,4642 <countfree+0x9c>
      *(char *)(a + 4096 - 1) = 1;
    45e8:	6785                	lui	a5,0x1
    45ea:	97aa                	add	a5,a5,a0
    45ec:	fe978fa3          	sb	s1,-1(a5) # fff <pgbug+0x2b>
      if(write(fds[1], "x", 1) != 1){
    45f0:	8626                	mv	a2,s1
    45f2:	85ce                	mv	a1,s3
    45f4:	fcc42503          	lw	a0,-52(s0)
    45f8:	50e000ef          	jal	4b06 <write>
    45fc:	fe9501e3          	beq	a0,s1,45de <countfree+0x38>
        printf("write() failed in countfree()\n");
    4600:	00003517          	auipc	a0,0x3
    4604:	a0050513          	addi	a0,a0,-1536 # 7000 <malloc+0x204e>
    4608:	0f7000ef          	jal	4efe <printf>
        exit(1);
    460c:	4505                	li	a0,1
    460e:	4d8000ef          	jal	4ae6 <exit>
    4612:	f426                	sd	s1,40(sp)
    4614:	f04a                	sd	s2,32(sp)
    4616:	ec4e                	sd	s3,24(sp)
    printf("pipe() failed in countfree()\n");
    4618:	00003517          	auipc	a0,0x3
    461c:	9a850513          	addi	a0,a0,-1624 # 6fc0 <malloc+0x200e>
    4620:	0df000ef          	jal	4efe <printf>
    exit(1);
    4624:	4505                	li	a0,1
    4626:	4c0000ef          	jal	4ae6 <exit>
    462a:	f426                	sd	s1,40(sp)
    462c:	f04a                	sd	s2,32(sp)
    462e:	ec4e                	sd	s3,24(sp)
    printf("fork failed in countfree()\n");
    4630:	00003517          	auipc	a0,0x3
    4634:	9b050513          	addi	a0,a0,-1616 # 6fe0 <malloc+0x202e>
    4638:	0c7000ef          	jal	4efe <printf>
    exit(1);
    463c:	4505                	li	a0,1
    463e:	4a8000ef          	jal	4ae6 <exit>
      }
    }

    exit(0);
    4642:	4501                	li	a0,0
    4644:	4a2000ef          	jal	4ae6 <exit>
    4648:	f426                	sd	s1,40(sp)
  }

  close(fds[1]);
    464a:	fcc42503          	lw	a0,-52(s0)
    464e:	4c0000ef          	jal	4b0e <close>

  int n = 0;
    4652:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    4654:	4605                	li	a2,1
    4656:	fc740593          	addi	a1,s0,-57
    465a:	fc842503          	lw	a0,-56(s0)
    465e:	4a0000ef          	jal	4afe <read>
    if(cc < 0){
    4662:	00054563          	bltz	a0,466c <countfree+0xc6>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    4666:	cd11                	beqz	a0,4682 <countfree+0xdc>
      break;
    n += 1;
    4668:	2485                	addiw	s1,s1,1
  while(1){
    466a:	b7ed                	j	4654 <countfree+0xae>
    466c:	f04a                	sd	s2,32(sp)
    466e:	ec4e                	sd	s3,24(sp)
      printf("read() failed in countfree()\n");
    4670:	00003517          	auipc	a0,0x3
    4674:	9b050513          	addi	a0,a0,-1616 # 7020 <malloc+0x206e>
    4678:	087000ef          	jal	4efe <printf>
      exit(1);
    467c:	4505                	li	a0,1
    467e:	468000ef          	jal	4ae6 <exit>
  }

  close(fds[0]);
    4682:	fc842503          	lw	a0,-56(s0)
    4686:	488000ef          	jal	4b0e <close>
  wait((int*)0);
    468a:	4501                	li	a0,0
    468c:	462000ef          	jal	4aee <wait>
  
  return n;
}
    4690:	8526                	mv	a0,s1
    4692:	74a2                	ld	s1,40(sp)
    4694:	70e2                	ld	ra,56(sp)
    4696:	7442                	ld	s0,48(sp)
    4698:	6121                	addi	sp,sp,64
    469a:	8082                	ret

000000000000469c <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    469c:	711d                	addi	sp,sp,-96
    469e:	ec86                	sd	ra,88(sp)
    46a0:	e8a2                	sd	s0,80(sp)
    46a2:	e4a6                	sd	s1,72(sp)
    46a4:	e0ca                	sd	s2,64(sp)
    46a6:	fc4e                	sd	s3,56(sp)
    46a8:	f852                	sd	s4,48(sp)
    46aa:	f456                	sd	s5,40(sp)
    46ac:	f05a                	sd	s6,32(sp)
    46ae:	ec5e                	sd	s7,24(sp)
    46b0:	e862                	sd	s8,16(sp)
    46b2:	e466                	sd	s9,8(sp)
    46b4:	e06a                	sd	s10,0(sp)
    46b6:	1080                	addi	s0,sp,96
    46b8:	8aaa                	mv	s5,a0
    46ba:	892e                	mv	s2,a1
    46bc:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    46be:	00003b97          	auipc	s7,0x3
    46c2:	982b8b93          	addi	s7,s7,-1662 # 7040 <malloc+0x208e>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    46c6:	00005b17          	auipc	s6,0x5
    46ca:	94ab0b13          	addi	s6,s6,-1718 # 9010 <quicktests>
      if(continuous != 2) {
    46ce:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone, continuous)) {
    46d0:	00005c17          	auipc	s8,0x5
    46d4:	d10c0c13          	addi	s8,s8,-752 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    46d8:	00003d17          	auipc	s10,0x3
    46dc:	980d0d13          	addi	s10,s10,-1664 # 7058 <malloc+0x20a6>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    46e0:	00003c97          	auipc	s9,0x3
    46e4:	998c8c93          	addi	s9,s9,-1640 # 7078 <malloc+0x20c6>
    46e8:	a819                	j	46fe <drivetests+0x62>
        printf("usertests slow tests starting\n");
    46ea:	856a                	mv	a0,s10
    46ec:	013000ef          	jal	4efe <printf>
    46f0:	a80d                	j	4722 <drivetests+0x86>
    if((free1 = countfree()) < free0) {
    46f2:	eb5ff0ef          	jal	45a6 <countfree>
    46f6:	04954063          	blt	a0,s1,4736 <drivetests+0x9a>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    46fa:	04090963          	beqz	s2,474c <drivetests+0xb0>
    printf("usertests starting\n");
    46fe:	855e                	mv	a0,s7
    4700:	7fe000ef          	jal	4efe <printf>
    int free0 = countfree();
    4704:	ea3ff0ef          	jal	45a6 <countfree>
    4708:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    470a:	864a                	mv	a2,s2
    470c:	85ce                	mv	a1,s3
    470e:	855a                	mv	a0,s6
    4710:	e1dff0ef          	jal	452c <runtests>
    4714:	c119                	beqz	a0,471a <drivetests+0x7e>
      if(continuous != 2) {
    4716:	03491963          	bne	s2,s4,4748 <drivetests+0xac>
    if(!quick) {
    471a:	fc0a9ce3          	bnez	s5,46f2 <drivetests+0x56>
      if (justone == 0)
    471e:	fc0986e3          	beqz	s3,46ea <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    4722:	864a                	mv	a2,s2
    4724:	85ce                	mv	a1,s3
    4726:	8562                	mv	a0,s8
    4728:	e05ff0ef          	jal	452c <runtests>
    472c:	d179                	beqz	a0,46f2 <drivetests+0x56>
        if(continuous != 2) {
    472e:	fd4902e3          	beq	s2,s4,46f2 <drivetests+0x56>
          return 1;
    4732:	4505                	li	a0,1
    4734:	a829                	j	474e <drivetests+0xb2>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4736:	8626                	mv	a2,s1
    4738:	85aa                	mv	a1,a0
    473a:	8566                	mv	a0,s9
    473c:	7c2000ef          	jal	4efe <printf>
      if(continuous != 2) {
    4740:	fb490fe3          	beq	s2,s4,46fe <drivetests+0x62>
        return 1;
    4744:	4505                	li	a0,1
    4746:	a021                	j	474e <drivetests+0xb2>
        return 1;
    4748:	4505                	li	a0,1
    474a:	a011                	j	474e <drivetests+0xb2>
  return 0;
    474c:	854a                	mv	a0,s2
}
    474e:	60e6                	ld	ra,88(sp)
    4750:	6446                	ld	s0,80(sp)
    4752:	64a6                	ld	s1,72(sp)
    4754:	6906                	ld	s2,64(sp)
    4756:	79e2                	ld	s3,56(sp)
    4758:	7a42                	ld	s4,48(sp)
    475a:	7aa2                	ld	s5,40(sp)
    475c:	7b02                	ld	s6,32(sp)
    475e:	6be2                	ld	s7,24(sp)
    4760:	6c42                	ld	s8,16(sp)
    4762:	6ca2                	ld	s9,8(sp)
    4764:	6d02                	ld	s10,0(sp)
    4766:	6125                	addi	sp,sp,96
    4768:	8082                	ret

000000000000476a <main>:

int
main(int argc, char *argv[])
{
    476a:	1101                	addi	sp,sp,-32
    476c:	ec06                	sd	ra,24(sp)
    476e:	e822                	sd	s0,16(sp)
    4770:	e426                	sd	s1,8(sp)
    4772:	e04a                	sd	s2,0(sp)
    4774:	1000                	addi	s0,sp,32
    4776:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4778:	4789                	li	a5,2
    477a:	00f50f63          	beq	a0,a5,4798 <main+0x2e>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    477e:	4785                	li	a5,1
    4780:	06a7c063          	blt	a5,a0,47e0 <main+0x76>
  char *justone = 0;
    4784:	4901                	li	s2,0
  int quick = 0;
    4786:	4501                	li	a0,0
  int continuous = 0;
    4788:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    478a:	864a                	mv	a2,s2
    478c:	f11ff0ef          	jal	469c <drivetests>
    4790:	c935                	beqz	a0,4804 <main+0x9a>
    exit(1);
    4792:	4505                	li	a0,1
    4794:	352000ef          	jal	4ae6 <exit>
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4798:	0085b903          	ld	s2,8(a1)
    479c:	00003597          	auipc	a1,0x3
    47a0:	90c58593          	addi	a1,a1,-1780 # 70a8 <malloc+0x20f6>
    47a4:	854a                	mv	a0,s2
    47a6:	09e000ef          	jal	4844 <strcmp>
    47aa:	85aa                	mv	a1,a0
    47ac:	c139                	beqz	a0,47f2 <main+0x88>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    47ae:	00003597          	auipc	a1,0x3
    47b2:	90258593          	addi	a1,a1,-1790 # 70b0 <malloc+0x20fe>
    47b6:	854a                	mv	a0,s2
    47b8:	08c000ef          	jal	4844 <strcmp>
    47bc:	cd15                	beqz	a0,47f8 <main+0x8e>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    47be:	00003597          	auipc	a1,0x3
    47c2:	8fa58593          	addi	a1,a1,-1798 # 70b8 <malloc+0x2106>
    47c6:	854a                	mv	a0,s2
    47c8:	07c000ef          	jal	4844 <strcmp>
    47cc:	c90d                	beqz	a0,47fe <main+0x94>
  } else if(argc == 2 && argv[1][0] != '-'){
    47ce:	00094703          	lbu	a4,0(s2)
    47d2:	02d00793          	li	a5,45
    47d6:	00f70563          	beq	a4,a5,47e0 <main+0x76>
  int quick = 0;
    47da:	4501                	li	a0,0
  int continuous = 0;
    47dc:	4581                	li	a1,0
    47de:	b775                	j	478a <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    47e0:	00003517          	auipc	a0,0x3
    47e4:	8e050513          	addi	a0,a0,-1824 # 70c0 <malloc+0x210e>
    47e8:	716000ef          	jal	4efe <printf>
    exit(1);
    47ec:	4505                	li	a0,1
    47ee:	2f8000ef          	jal	4ae6 <exit>
  char *justone = 0;
    47f2:	4901                	li	s2,0
    quick = 1;
    47f4:	4505                	li	a0,1
    47f6:	bf51                	j	478a <main+0x20>
  char *justone = 0;
    47f8:	4901                	li	s2,0
    continuous = 1;
    47fa:	4585                	li	a1,1
    47fc:	b779                	j	478a <main+0x20>
    continuous = 2;
    47fe:	85a6                	mv	a1,s1
  char *justone = 0;
    4800:	4901                	li	s2,0
    4802:	b761                	j	478a <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    4804:	00003517          	auipc	a0,0x3
    4808:	8ec50513          	addi	a0,a0,-1812 # 70f0 <malloc+0x213e>
    480c:	6f2000ef          	jal	4efe <printf>
  exit(0);
    4810:	4501                	li	a0,0
    4812:	2d4000ef          	jal	4ae6 <exit>

0000000000004816 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    4816:	1141                	addi	sp,sp,-16
    4818:	e406                	sd	ra,8(sp)
    481a:	e022                	sd	s0,0(sp)
    481c:	0800                	addi	s0,sp,16
  extern int main();
  main();
    481e:	f4dff0ef          	jal	476a <main>
  exit(0);
    4822:	4501                	li	a0,0
    4824:	2c2000ef          	jal	4ae6 <exit>

0000000000004828 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    4828:	1141                	addi	sp,sp,-16
    482a:	e422                	sd	s0,8(sp)
    482c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    482e:	87aa                	mv	a5,a0
    4830:	0585                	addi	a1,a1,1
    4832:	0785                	addi	a5,a5,1
    4834:	fff5c703          	lbu	a4,-1(a1)
    4838:	fee78fa3          	sb	a4,-1(a5)
    483c:	fb75                	bnez	a4,4830 <strcpy+0x8>
    ;
  return os;
}
    483e:	6422                	ld	s0,8(sp)
    4840:	0141                	addi	sp,sp,16
    4842:	8082                	ret

0000000000004844 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4844:	1141                	addi	sp,sp,-16
    4846:	e422                	sd	s0,8(sp)
    4848:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    484a:	00054783          	lbu	a5,0(a0)
    484e:	cb91                	beqz	a5,4862 <strcmp+0x1e>
    4850:	0005c703          	lbu	a4,0(a1)
    4854:	00f71763          	bne	a4,a5,4862 <strcmp+0x1e>
    p++, q++;
    4858:	0505                	addi	a0,a0,1
    485a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    485c:	00054783          	lbu	a5,0(a0)
    4860:	fbe5                	bnez	a5,4850 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    4862:	0005c503          	lbu	a0,0(a1)
}
    4866:	40a7853b          	subw	a0,a5,a0
    486a:	6422                	ld	s0,8(sp)
    486c:	0141                	addi	sp,sp,16
    486e:	8082                	ret

0000000000004870 <strlen>:

uint
strlen(const char *s)
{
    4870:	1141                	addi	sp,sp,-16
    4872:	e422                	sd	s0,8(sp)
    4874:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4876:	00054783          	lbu	a5,0(a0)
    487a:	cf91                	beqz	a5,4896 <strlen+0x26>
    487c:	0505                	addi	a0,a0,1
    487e:	87aa                	mv	a5,a0
    4880:	86be                	mv	a3,a5
    4882:	0785                	addi	a5,a5,1
    4884:	fff7c703          	lbu	a4,-1(a5)
    4888:	ff65                	bnez	a4,4880 <strlen+0x10>
    488a:	40a6853b          	subw	a0,a3,a0
    488e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    4890:	6422                	ld	s0,8(sp)
    4892:	0141                	addi	sp,sp,16
    4894:	8082                	ret
  for(n = 0; s[n]; n++)
    4896:	4501                	li	a0,0
    4898:	bfe5                	j	4890 <strlen+0x20>

000000000000489a <memset>:

void*
memset(void *dst, int c, uint n)
{
    489a:	1141                	addi	sp,sp,-16
    489c:	e422                	sd	s0,8(sp)
    489e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    48a0:	ca19                	beqz	a2,48b6 <memset+0x1c>
    48a2:	87aa                	mv	a5,a0
    48a4:	1602                	slli	a2,a2,0x20
    48a6:	9201                	srli	a2,a2,0x20
    48a8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    48ac:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    48b0:	0785                	addi	a5,a5,1
    48b2:	fee79de3          	bne	a5,a4,48ac <memset+0x12>
  }
  return dst;
}
    48b6:	6422                	ld	s0,8(sp)
    48b8:	0141                	addi	sp,sp,16
    48ba:	8082                	ret

00000000000048bc <strchr>:

char*
strchr(const char *s, char c)
{
    48bc:	1141                	addi	sp,sp,-16
    48be:	e422                	sd	s0,8(sp)
    48c0:	0800                	addi	s0,sp,16
  for(; *s; s++)
    48c2:	00054783          	lbu	a5,0(a0)
    48c6:	cb99                	beqz	a5,48dc <strchr+0x20>
    if(*s == c)
    48c8:	00f58763          	beq	a1,a5,48d6 <strchr+0x1a>
  for(; *s; s++)
    48cc:	0505                	addi	a0,a0,1
    48ce:	00054783          	lbu	a5,0(a0)
    48d2:	fbfd                	bnez	a5,48c8 <strchr+0xc>
      return (char*)s;
  return 0;
    48d4:	4501                	li	a0,0
}
    48d6:	6422                	ld	s0,8(sp)
    48d8:	0141                	addi	sp,sp,16
    48da:	8082                	ret
  return 0;
    48dc:	4501                	li	a0,0
    48de:	bfe5                	j	48d6 <strchr+0x1a>

00000000000048e0 <gets>:

char*
gets(char *buf, int max)
{
    48e0:	711d                	addi	sp,sp,-96
    48e2:	ec86                	sd	ra,88(sp)
    48e4:	e8a2                	sd	s0,80(sp)
    48e6:	e4a6                	sd	s1,72(sp)
    48e8:	e0ca                	sd	s2,64(sp)
    48ea:	fc4e                	sd	s3,56(sp)
    48ec:	f852                	sd	s4,48(sp)
    48ee:	f456                	sd	s5,40(sp)
    48f0:	f05a                	sd	s6,32(sp)
    48f2:	ec5e                	sd	s7,24(sp)
    48f4:	1080                	addi	s0,sp,96
    48f6:	8baa                	mv	s7,a0
    48f8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    48fa:	892a                	mv	s2,a0
    48fc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    48fe:	4aa9                	li	s5,10
    4900:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    4902:	89a6                	mv	s3,s1
    4904:	2485                	addiw	s1,s1,1
    4906:	0344d663          	bge	s1,s4,4932 <gets+0x52>
    cc = read(0, &c, 1);
    490a:	4605                	li	a2,1
    490c:	faf40593          	addi	a1,s0,-81
    4910:	4501                	li	a0,0
    4912:	1ec000ef          	jal	4afe <read>
    if(cc < 1)
    4916:	00a05e63          	blez	a0,4932 <gets+0x52>
    buf[i++] = c;
    491a:	faf44783          	lbu	a5,-81(s0)
    491e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4922:	01578763          	beq	a5,s5,4930 <gets+0x50>
    4926:	0905                	addi	s2,s2,1
    4928:	fd679de3          	bne	a5,s6,4902 <gets+0x22>
    buf[i++] = c;
    492c:	89a6                	mv	s3,s1
    492e:	a011                	j	4932 <gets+0x52>
    4930:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    4932:	99de                	add	s3,s3,s7
    4934:	00098023          	sb	zero,0(s3)
  return buf;
}
    4938:	855e                	mv	a0,s7
    493a:	60e6                	ld	ra,88(sp)
    493c:	6446                	ld	s0,80(sp)
    493e:	64a6                	ld	s1,72(sp)
    4940:	6906                	ld	s2,64(sp)
    4942:	79e2                	ld	s3,56(sp)
    4944:	7a42                	ld	s4,48(sp)
    4946:	7aa2                	ld	s5,40(sp)
    4948:	7b02                	ld	s6,32(sp)
    494a:	6be2                	ld	s7,24(sp)
    494c:	6125                	addi	sp,sp,96
    494e:	8082                	ret

0000000000004950 <stat>:

int
stat(const char *n, struct stat *st)
{
    4950:	1101                	addi	sp,sp,-32
    4952:	ec06                	sd	ra,24(sp)
    4954:	e822                	sd	s0,16(sp)
    4956:	e04a                	sd	s2,0(sp)
    4958:	1000                	addi	s0,sp,32
    495a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    495c:	4581                	li	a1,0
    495e:	1c8000ef          	jal	4b26 <open>
  if(fd < 0)
    4962:	02054263          	bltz	a0,4986 <stat+0x36>
    4966:	e426                	sd	s1,8(sp)
    4968:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    496a:	85ca                	mv	a1,s2
    496c:	1d2000ef          	jal	4b3e <fstat>
    4970:	892a                	mv	s2,a0
  close(fd);
    4972:	8526                	mv	a0,s1
    4974:	19a000ef          	jal	4b0e <close>
  return r;
    4978:	64a2                	ld	s1,8(sp)
}
    497a:	854a                	mv	a0,s2
    497c:	60e2                	ld	ra,24(sp)
    497e:	6442                	ld	s0,16(sp)
    4980:	6902                	ld	s2,0(sp)
    4982:	6105                	addi	sp,sp,32
    4984:	8082                	ret
    return -1;
    4986:	597d                	li	s2,-1
    4988:	bfcd                	j	497a <stat+0x2a>

000000000000498a <atoi>:

int
atoi(const char *s)
{
    498a:	1141                	addi	sp,sp,-16
    498c:	e422                	sd	s0,8(sp)
    498e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4990:	00054683          	lbu	a3,0(a0)
    4994:	fd06879b          	addiw	a5,a3,-48
    4998:	0ff7f793          	zext.b	a5,a5
    499c:	4625                	li	a2,9
    499e:	02f66863          	bltu	a2,a5,49ce <atoi+0x44>
    49a2:	872a                	mv	a4,a0
  n = 0;
    49a4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    49a6:	0705                	addi	a4,a4,1
    49a8:	0025179b          	slliw	a5,a0,0x2
    49ac:	9fa9                	addw	a5,a5,a0
    49ae:	0017979b          	slliw	a5,a5,0x1
    49b2:	9fb5                	addw	a5,a5,a3
    49b4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    49b8:	00074683          	lbu	a3,0(a4)
    49bc:	fd06879b          	addiw	a5,a3,-48
    49c0:	0ff7f793          	zext.b	a5,a5
    49c4:	fef671e3          	bgeu	a2,a5,49a6 <atoi+0x1c>
  return n;
}
    49c8:	6422                	ld	s0,8(sp)
    49ca:	0141                	addi	sp,sp,16
    49cc:	8082                	ret
  n = 0;
    49ce:	4501                	li	a0,0
    49d0:	bfe5                	j	49c8 <atoi+0x3e>

00000000000049d2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    49d2:	1141                	addi	sp,sp,-16
    49d4:	e422                	sd	s0,8(sp)
    49d6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    49d8:	02b57463          	bgeu	a0,a1,4a00 <memmove+0x2e>
    while(n-- > 0)
    49dc:	00c05f63          	blez	a2,49fa <memmove+0x28>
    49e0:	1602                	slli	a2,a2,0x20
    49e2:	9201                	srli	a2,a2,0x20
    49e4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    49e8:	872a                	mv	a4,a0
      *dst++ = *src++;
    49ea:	0585                	addi	a1,a1,1
    49ec:	0705                	addi	a4,a4,1
    49ee:	fff5c683          	lbu	a3,-1(a1)
    49f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    49f6:	fef71ae3          	bne	a4,a5,49ea <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    49fa:	6422                	ld	s0,8(sp)
    49fc:	0141                	addi	sp,sp,16
    49fe:	8082                	ret
    dst += n;
    4a00:	00c50733          	add	a4,a0,a2
    src += n;
    4a04:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    4a06:	fec05ae3          	blez	a2,49fa <memmove+0x28>
    4a0a:	fff6079b          	addiw	a5,a2,-1 # 2fff <subdir+0x423>
    4a0e:	1782                	slli	a5,a5,0x20
    4a10:	9381                	srli	a5,a5,0x20
    4a12:	fff7c793          	not	a5,a5
    4a16:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4a18:	15fd                	addi	a1,a1,-1
    4a1a:	177d                	addi	a4,a4,-1
    4a1c:	0005c683          	lbu	a3,0(a1)
    4a20:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    4a24:	fee79ae3          	bne	a5,a4,4a18 <memmove+0x46>
    4a28:	bfc9                	j	49fa <memmove+0x28>

0000000000004a2a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4a2a:	1141                	addi	sp,sp,-16
    4a2c:	e422                	sd	s0,8(sp)
    4a2e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4a30:	ca05                	beqz	a2,4a60 <memcmp+0x36>
    4a32:	fff6069b          	addiw	a3,a2,-1
    4a36:	1682                	slli	a3,a3,0x20
    4a38:	9281                	srli	a3,a3,0x20
    4a3a:	0685                	addi	a3,a3,1
    4a3c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    4a3e:	00054783          	lbu	a5,0(a0)
    4a42:	0005c703          	lbu	a4,0(a1)
    4a46:	00e79863          	bne	a5,a4,4a56 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    4a4a:	0505                	addi	a0,a0,1
    p2++;
    4a4c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4a4e:	fed518e3          	bne	a0,a3,4a3e <memcmp+0x14>
  }
  return 0;
    4a52:	4501                	li	a0,0
    4a54:	a019                	j	4a5a <memcmp+0x30>
      return *p1 - *p2;
    4a56:	40e7853b          	subw	a0,a5,a4
}
    4a5a:	6422                	ld	s0,8(sp)
    4a5c:	0141                	addi	sp,sp,16
    4a5e:	8082                	ret
  return 0;
    4a60:	4501                	li	a0,0
    4a62:	bfe5                	j	4a5a <memcmp+0x30>

0000000000004a64 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4a64:	1141                	addi	sp,sp,-16
    4a66:	e406                	sd	ra,8(sp)
    4a68:	e022                	sd	s0,0(sp)
    4a6a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4a6c:	f67ff0ef          	jal	49d2 <memmove>
}
    4a70:	60a2                	ld	ra,8(sp)
    4a72:	6402                	ld	s0,0(sp)
    4a74:	0141                	addi	sp,sp,16
    4a76:	8082                	ret

0000000000004a78 <syscall>:

// Trap into kernel space for system calls
int syscall(int num, ...) {
    4a78:	7175                	addi	sp,sp,-144
    4a7a:	e4a2                	sd	s0,72(sp)
    4a7c:	0880                	addi	s0,sp,80
    4a7e:	832a                	mv	t1,a0
    4a80:	e40c                	sd	a1,8(s0)
    4a82:	e810                	sd	a2,16(s0)
    4a84:	ec14                	sd	a3,24(s0)
    4a86:	f018                	sd	a4,32(s0)
    4a88:	f41c                	sd	a5,40(s0)
    4a8a:	03043823          	sd	a6,48(s0)
    4a8e:	03143c23          	sd	a7,56(s0)
    uint64 args[6];
    va_list ap;
    int i;

    // Retrieve variable arguments passed to syscall
    va_start(ap, num);
    4a92:	00840793          	addi	a5,s0,8
    4a96:	faf43c23          	sd	a5,-72(s0)
    for (i = 0; i < 6; i++) {
    4a9a:	fc040793          	addi	a5,s0,-64
    4a9e:	ff040613          	addi	a2,s0,-16
        args[i] = va_arg(ap, uint64);
    4aa2:	fb843703          	ld	a4,-72(s0)
    4aa6:	00870693          	addi	a3,a4,8
    4aaa:	fad43c23          	sd	a3,-72(s0)
    4aae:	6318                	ld	a4,0(a4)
    4ab0:	e398                	sd	a4,0(a5)
    for (i = 0; i < 6; i++) {
    4ab2:	07a1                	addi	a5,a5,8
    4ab4:	fec797e3          	bne	a5,a2,4aa2 <syscall+0x2a>
    }
    va_end(ap);

    // Place the system call number in a7, arguments in a0-a5
    register uint64 a0 asm("a0") = args[0];
    4ab8:	fc043503          	ld	a0,-64(s0)
    register uint64 a1 asm("a1") = args[1];
    4abc:	fc843583          	ld	a1,-56(s0)
    register uint64 a2 asm("a2") = args[2];
    4ac0:	fd043603          	ld	a2,-48(s0)
    register uint64 a3 asm("a3") = args[3];
    4ac4:	fd843683          	ld	a3,-40(s0)
    register uint64 a4 asm("a4") = args[4];
    4ac8:	fe043703          	ld	a4,-32(s0)
    register uint64 a5 asm("a5") = args[5];
    4acc:	fe843783          	ld	a5,-24(s0)
    register uint64 a7 asm("a7") = num;
    4ad0:	889a                	mv	a7,t1

    // Perform the ecall (traps into kernel space)
    asm volatile("ecall"
    4ad2:	00000073          	ecall
                 : "r"(a1), "r"(a2), "r"(a3), "r"(a4), "r"(a5), "r"(a7)
                 : "memory");

    // Return value is stored in a0 after the trap
    return a0;
    4ad6:	2501                	sext.w	a0,a0
    4ad8:	6426                	ld	s0,72(sp)
    4ada:	6149                	addi	sp,sp,144
    4adc:	8082                	ret

0000000000004ade <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4ade:	4885                	li	a7,1
 ecall
    4ae0:	00000073          	ecall
 ret
    4ae4:	8082                	ret

0000000000004ae6 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4ae6:	4889                	li	a7,2
 ecall
    4ae8:	00000073          	ecall
 ret
    4aec:	8082                	ret

0000000000004aee <wait>:
.global wait
wait:
 li a7, SYS_wait
    4aee:	488d                	li	a7,3
 ecall
    4af0:	00000073          	ecall
 ret
    4af4:	8082                	ret

0000000000004af6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4af6:	4891                	li	a7,4
 ecall
    4af8:	00000073          	ecall
 ret
    4afc:	8082                	ret

0000000000004afe <read>:
.global read
read:
 li a7, SYS_read
    4afe:	4895                	li	a7,5
 ecall
    4b00:	00000073          	ecall
 ret
    4b04:	8082                	ret

0000000000004b06 <write>:
.global write
write:
 li a7, SYS_write
    4b06:	48c1                	li	a7,16
 ecall
    4b08:	00000073          	ecall
 ret
    4b0c:	8082                	ret

0000000000004b0e <close>:
.global close
close:
 li a7, SYS_close
    4b0e:	48d5                	li	a7,21
 ecall
    4b10:	00000073          	ecall
 ret
    4b14:	8082                	ret

0000000000004b16 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4b16:	4899                	li	a7,6
 ecall
    4b18:	00000073          	ecall
 ret
    4b1c:	8082                	ret

0000000000004b1e <exec>:
.global exec
exec:
 li a7, SYS_exec
    4b1e:	489d                	li	a7,7
 ecall
    4b20:	00000073          	ecall
 ret
    4b24:	8082                	ret

0000000000004b26 <open>:
.global open
open:
 li a7, SYS_open
    4b26:	48bd                	li	a7,15
 ecall
    4b28:	00000073          	ecall
 ret
    4b2c:	8082                	ret

0000000000004b2e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4b2e:	48c5                	li	a7,17
 ecall
    4b30:	00000073          	ecall
 ret
    4b34:	8082                	ret

0000000000004b36 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4b36:	48c9                	li	a7,18
 ecall
    4b38:	00000073          	ecall
 ret
    4b3c:	8082                	ret

0000000000004b3e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4b3e:	48a1                	li	a7,8
 ecall
    4b40:	00000073          	ecall
 ret
    4b44:	8082                	ret

0000000000004b46 <link>:
.global link
link:
 li a7, SYS_link
    4b46:	48cd                	li	a7,19
 ecall
    4b48:	00000073          	ecall
 ret
    4b4c:	8082                	ret

0000000000004b4e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4b4e:	48d1                	li	a7,20
 ecall
    4b50:	00000073          	ecall
 ret
    4b54:	8082                	ret

0000000000004b56 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4b56:	48a5                	li	a7,9
 ecall
    4b58:	00000073          	ecall
 ret
    4b5c:	8082                	ret

0000000000004b5e <dup>:
.global dup
dup:
 li a7, SYS_dup
    4b5e:	48a9                	li	a7,10
 ecall
    4b60:	00000073          	ecall
 ret
    4b64:	8082                	ret

0000000000004b66 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4b66:	48ad                	li	a7,11
 ecall
    4b68:	00000073          	ecall
 ret
    4b6c:	8082                	ret

0000000000004b6e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    4b6e:	48b1                	li	a7,12
 ecall
    4b70:	00000073          	ecall
 ret
    4b74:	8082                	ret

0000000000004b76 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    4b76:	48b5                	li	a7,13
 ecall
    4b78:	00000073          	ecall
 ret
    4b7c:	8082                	ret

0000000000004b7e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4b7e:	48b9                	li	a7,14
 ecall
    4b80:	00000073          	ecall
 ret
    4b84:	8082                	ret

0000000000004b86 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4b86:	1101                	addi	sp,sp,-32
    4b88:	ec06                	sd	ra,24(sp)
    4b8a:	e822                	sd	s0,16(sp)
    4b8c:	1000                	addi	s0,sp,32
    4b8e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4b92:	4605                	li	a2,1
    4b94:	fef40593          	addi	a1,s0,-17
    4b98:	f6fff0ef          	jal	4b06 <write>
}
    4b9c:	60e2                	ld	ra,24(sp)
    4b9e:	6442                	ld	s0,16(sp)
    4ba0:	6105                	addi	sp,sp,32
    4ba2:	8082                	ret

0000000000004ba4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4ba4:	7139                	addi	sp,sp,-64
    4ba6:	fc06                	sd	ra,56(sp)
    4ba8:	f822                	sd	s0,48(sp)
    4baa:	f426                	sd	s1,40(sp)
    4bac:	0080                	addi	s0,sp,64
    4bae:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4bb0:	c299                	beqz	a3,4bb6 <printint+0x12>
    4bb2:	0805c963          	bltz	a1,4c44 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4bb6:	2581                	sext.w	a1,a1
  neg = 0;
    4bb8:	4881                	li	a7,0
    4bba:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    4bbe:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4bc0:	2601                	sext.w	a2,a2
    4bc2:	00003517          	auipc	a0,0x3
    4bc6:	8fe50513          	addi	a0,a0,-1794 # 74c0 <digits>
    4bca:	883a                	mv	a6,a4
    4bcc:	2705                	addiw	a4,a4,1
    4bce:	02c5f7bb          	remuw	a5,a1,a2
    4bd2:	1782                	slli	a5,a5,0x20
    4bd4:	9381                	srli	a5,a5,0x20
    4bd6:	97aa                	add	a5,a5,a0
    4bd8:	0007c783          	lbu	a5,0(a5)
    4bdc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    4be0:	0005879b          	sext.w	a5,a1
    4be4:	02c5d5bb          	divuw	a1,a1,a2
    4be8:	0685                	addi	a3,a3,1
    4bea:	fec7f0e3          	bgeu	a5,a2,4bca <printint+0x26>
  if(neg)
    4bee:	00088c63          	beqz	a7,4c06 <printint+0x62>
    buf[i++] = '-';
    4bf2:	fd070793          	addi	a5,a4,-48
    4bf6:	00878733          	add	a4,a5,s0
    4bfa:	02d00793          	li	a5,45
    4bfe:	fef70823          	sb	a5,-16(a4)
    4c02:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    4c06:	02e05a63          	blez	a4,4c3a <printint+0x96>
    4c0a:	f04a                	sd	s2,32(sp)
    4c0c:	ec4e                	sd	s3,24(sp)
    4c0e:	fc040793          	addi	a5,s0,-64
    4c12:	00e78933          	add	s2,a5,a4
    4c16:	fff78993          	addi	s3,a5,-1
    4c1a:	99ba                	add	s3,s3,a4
    4c1c:	377d                	addiw	a4,a4,-1
    4c1e:	1702                	slli	a4,a4,0x20
    4c20:	9301                	srli	a4,a4,0x20
    4c22:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    4c26:	fff94583          	lbu	a1,-1(s2)
    4c2a:	8526                	mv	a0,s1
    4c2c:	f5bff0ef          	jal	4b86 <putc>
  while(--i >= 0)
    4c30:	197d                	addi	s2,s2,-1
    4c32:	ff391ae3          	bne	s2,s3,4c26 <printint+0x82>
    4c36:	7902                	ld	s2,32(sp)
    4c38:	69e2                	ld	s3,24(sp)
}
    4c3a:	70e2                	ld	ra,56(sp)
    4c3c:	7442                	ld	s0,48(sp)
    4c3e:	74a2                	ld	s1,40(sp)
    4c40:	6121                	addi	sp,sp,64
    4c42:	8082                	ret
    x = -xx;
    4c44:	40b005bb          	negw	a1,a1
    neg = 1;
    4c48:	4885                	li	a7,1
    x = -xx;
    4c4a:	bf85                	j	4bba <printint+0x16>

0000000000004c4c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4c4c:	711d                	addi	sp,sp,-96
    4c4e:	ec86                	sd	ra,88(sp)
    4c50:	e8a2                	sd	s0,80(sp)
    4c52:	e0ca                	sd	s2,64(sp)
    4c54:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4c56:	0005c903          	lbu	s2,0(a1)
    4c5a:	26090863          	beqz	s2,4eca <vprintf+0x27e>
    4c5e:	e4a6                	sd	s1,72(sp)
    4c60:	fc4e                	sd	s3,56(sp)
    4c62:	f852                	sd	s4,48(sp)
    4c64:	f456                	sd	s5,40(sp)
    4c66:	f05a                	sd	s6,32(sp)
    4c68:	ec5e                	sd	s7,24(sp)
    4c6a:	e862                	sd	s8,16(sp)
    4c6c:	e466                	sd	s9,8(sp)
    4c6e:	8b2a                	mv	s6,a0
    4c70:	8a2e                	mv	s4,a1
    4c72:	8bb2                	mv	s7,a2
  state = 0;
    4c74:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    4c76:	4481                	li	s1,0
    4c78:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    4c7a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    4c7e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    4c82:	06c00c93          	li	s9,108
    4c86:	a005                	j	4ca6 <vprintf+0x5a>
        putc(fd, c0);
    4c88:	85ca                	mv	a1,s2
    4c8a:	855a                	mv	a0,s6
    4c8c:	efbff0ef          	jal	4b86 <putc>
    4c90:	a019                	j	4c96 <vprintf+0x4a>
    } else if(state == '%'){
    4c92:	03598263          	beq	s3,s5,4cb6 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    4c96:	2485                	addiw	s1,s1,1
    4c98:	8726                	mv	a4,s1
    4c9a:	009a07b3          	add	a5,s4,s1
    4c9e:	0007c903          	lbu	s2,0(a5)
    4ca2:	20090c63          	beqz	s2,4eba <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    4ca6:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4caa:	fe0994e3          	bnez	s3,4c92 <vprintf+0x46>
      if(c0 == '%'){
    4cae:	fd579de3          	bne	a5,s5,4c88 <vprintf+0x3c>
        state = '%';
    4cb2:	89be                	mv	s3,a5
    4cb4:	b7cd                	j	4c96 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    4cb6:	00ea06b3          	add	a3,s4,a4
    4cba:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    4cbe:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    4cc0:	c681                	beqz	a3,4cc8 <vprintf+0x7c>
    4cc2:	9752                	add	a4,a4,s4
    4cc4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    4cc8:	03878f63          	beq	a5,s8,4d06 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    4ccc:	05978963          	beq	a5,s9,4d1e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    4cd0:	07500713          	li	a4,117
    4cd4:	0ee78363          	beq	a5,a4,4dba <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    4cd8:	07800713          	li	a4,120
    4cdc:	12e78563          	beq	a5,a4,4e06 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    4ce0:	07000713          	li	a4,112
    4ce4:	14e78a63          	beq	a5,a4,4e38 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    4ce8:	07300713          	li	a4,115
    4cec:	18e78a63          	beq	a5,a4,4e80 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    4cf0:	02500713          	li	a4,37
    4cf4:	04e79563          	bne	a5,a4,4d3e <vprintf+0xf2>
        putc(fd, '%');
    4cf8:	02500593          	li	a1,37
    4cfc:	855a                	mv	a0,s6
    4cfe:	e89ff0ef          	jal	4b86 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    4d02:	4981                	li	s3,0
    4d04:	bf49                	j	4c96 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    4d06:	008b8913          	addi	s2,s7,8
    4d0a:	4685                	li	a3,1
    4d0c:	4629                	li	a2,10
    4d0e:	000ba583          	lw	a1,0(s7)
    4d12:	855a                	mv	a0,s6
    4d14:	e91ff0ef          	jal	4ba4 <printint>
    4d18:	8bca                	mv	s7,s2
      state = 0;
    4d1a:	4981                	li	s3,0
    4d1c:	bfad                	j	4c96 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    4d1e:	06400793          	li	a5,100
    4d22:	02f68963          	beq	a3,a5,4d54 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4d26:	06c00793          	li	a5,108
    4d2a:	04f68263          	beq	a3,a5,4d6e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    4d2e:	07500793          	li	a5,117
    4d32:	0af68063          	beq	a3,a5,4dd2 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    4d36:	07800793          	li	a5,120
    4d3a:	0ef68263          	beq	a3,a5,4e1e <vprintf+0x1d2>
        putc(fd, '%');
    4d3e:	02500593          	li	a1,37
    4d42:	855a                	mv	a0,s6
    4d44:	e43ff0ef          	jal	4b86 <putc>
        putc(fd, c0);
    4d48:	85ca                	mv	a1,s2
    4d4a:	855a                	mv	a0,s6
    4d4c:	e3bff0ef          	jal	4b86 <putc>
      state = 0;
    4d50:	4981                	li	s3,0
    4d52:	b791                	j	4c96 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4d54:	008b8913          	addi	s2,s7,8
    4d58:	4685                	li	a3,1
    4d5a:	4629                	li	a2,10
    4d5c:	000ba583          	lw	a1,0(s7)
    4d60:	855a                	mv	a0,s6
    4d62:	e43ff0ef          	jal	4ba4 <printint>
        i += 1;
    4d66:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    4d68:	8bca                	mv	s7,s2
      state = 0;
    4d6a:	4981                	li	s3,0
        i += 1;
    4d6c:	b72d                	j	4c96 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4d6e:	06400793          	li	a5,100
    4d72:	02f60763          	beq	a2,a5,4da0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4d76:	07500793          	li	a5,117
    4d7a:	06f60963          	beq	a2,a5,4dec <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    4d7e:	07800793          	li	a5,120
    4d82:	faf61ee3          	bne	a2,a5,4d3e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4d86:	008b8913          	addi	s2,s7,8
    4d8a:	4681                	li	a3,0
    4d8c:	4641                	li	a2,16
    4d8e:	000ba583          	lw	a1,0(s7)
    4d92:	855a                	mv	a0,s6
    4d94:	e11ff0ef          	jal	4ba4 <printint>
        i += 2;
    4d98:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    4d9a:	8bca                	mv	s7,s2
      state = 0;
    4d9c:	4981                	li	s3,0
        i += 2;
    4d9e:	bde5                	j	4c96 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4da0:	008b8913          	addi	s2,s7,8
    4da4:	4685                	li	a3,1
    4da6:	4629                	li	a2,10
    4da8:	000ba583          	lw	a1,0(s7)
    4dac:	855a                	mv	a0,s6
    4dae:	df7ff0ef          	jal	4ba4 <printint>
        i += 2;
    4db2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    4db4:	8bca                	mv	s7,s2
      state = 0;
    4db6:	4981                	li	s3,0
        i += 2;
    4db8:	bdf9                	j	4c96 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    4dba:	008b8913          	addi	s2,s7,8
    4dbe:	4681                	li	a3,0
    4dc0:	4629                	li	a2,10
    4dc2:	000ba583          	lw	a1,0(s7)
    4dc6:	855a                	mv	a0,s6
    4dc8:	dddff0ef          	jal	4ba4 <printint>
    4dcc:	8bca                	mv	s7,s2
      state = 0;
    4dce:	4981                	li	s3,0
    4dd0:	b5d9                	j	4c96 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4dd2:	008b8913          	addi	s2,s7,8
    4dd6:	4681                	li	a3,0
    4dd8:	4629                	li	a2,10
    4dda:	000ba583          	lw	a1,0(s7)
    4dde:	855a                	mv	a0,s6
    4de0:	dc5ff0ef          	jal	4ba4 <printint>
        i += 1;
    4de4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    4de6:	8bca                	mv	s7,s2
      state = 0;
    4de8:	4981                	li	s3,0
        i += 1;
    4dea:	b575                	j	4c96 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4dec:	008b8913          	addi	s2,s7,8
    4df0:	4681                	li	a3,0
    4df2:	4629                	li	a2,10
    4df4:	000ba583          	lw	a1,0(s7)
    4df8:	855a                	mv	a0,s6
    4dfa:	dabff0ef          	jal	4ba4 <printint>
        i += 2;
    4dfe:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    4e00:	8bca                	mv	s7,s2
      state = 0;
    4e02:	4981                	li	s3,0
        i += 2;
    4e04:	bd49                	j	4c96 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    4e06:	008b8913          	addi	s2,s7,8
    4e0a:	4681                	li	a3,0
    4e0c:	4641                	li	a2,16
    4e0e:	000ba583          	lw	a1,0(s7)
    4e12:	855a                	mv	a0,s6
    4e14:	d91ff0ef          	jal	4ba4 <printint>
    4e18:	8bca                	mv	s7,s2
      state = 0;
    4e1a:	4981                	li	s3,0
    4e1c:	bdad                	j	4c96 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4e1e:	008b8913          	addi	s2,s7,8
    4e22:	4681                	li	a3,0
    4e24:	4641                	li	a2,16
    4e26:	000ba583          	lw	a1,0(s7)
    4e2a:	855a                	mv	a0,s6
    4e2c:	d79ff0ef          	jal	4ba4 <printint>
        i += 1;
    4e30:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    4e32:	8bca                	mv	s7,s2
      state = 0;
    4e34:	4981                	li	s3,0
        i += 1;
    4e36:	b585                	j	4c96 <vprintf+0x4a>
    4e38:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    4e3a:	008b8d13          	addi	s10,s7,8
    4e3e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    4e42:	03000593          	li	a1,48
    4e46:	855a                	mv	a0,s6
    4e48:	d3fff0ef          	jal	4b86 <putc>
  putc(fd, 'x');
    4e4c:	07800593          	li	a1,120
    4e50:	855a                	mv	a0,s6
    4e52:	d35ff0ef          	jal	4b86 <putc>
    4e56:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4e58:	00002b97          	auipc	s7,0x2
    4e5c:	668b8b93          	addi	s7,s7,1640 # 74c0 <digits>
    4e60:	03c9d793          	srli	a5,s3,0x3c
    4e64:	97de                	add	a5,a5,s7
    4e66:	0007c583          	lbu	a1,0(a5)
    4e6a:	855a                	mv	a0,s6
    4e6c:	d1bff0ef          	jal	4b86 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    4e70:	0992                	slli	s3,s3,0x4
    4e72:	397d                	addiw	s2,s2,-1
    4e74:	fe0916e3          	bnez	s2,4e60 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    4e78:	8bea                	mv	s7,s10
      state = 0;
    4e7a:	4981                	li	s3,0
    4e7c:	6d02                	ld	s10,0(sp)
    4e7e:	bd21                	j	4c96 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    4e80:	008b8993          	addi	s3,s7,8
    4e84:	000bb903          	ld	s2,0(s7)
    4e88:	00090f63          	beqz	s2,4ea6 <vprintf+0x25a>
        for(; *s; s++)
    4e8c:	00094583          	lbu	a1,0(s2)
    4e90:	c195                	beqz	a1,4eb4 <vprintf+0x268>
          putc(fd, *s);
    4e92:	855a                	mv	a0,s6
    4e94:	cf3ff0ef          	jal	4b86 <putc>
        for(; *s; s++)
    4e98:	0905                	addi	s2,s2,1
    4e9a:	00094583          	lbu	a1,0(s2)
    4e9e:	f9f5                	bnez	a1,4e92 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    4ea0:	8bce                	mv	s7,s3
      state = 0;
    4ea2:	4981                	li	s3,0
    4ea4:	bbcd                	j	4c96 <vprintf+0x4a>
          s = "(null)";
    4ea6:	00002917          	auipc	s2,0x2
    4eaa:	59a90913          	addi	s2,s2,1434 # 7440 <malloc+0x248e>
        for(; *s; s++)
    4eae:	02800593          	li	a1,40
    4eb2:	b7c5                	j	4e92 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    4eb4:	8bce                	mv	s7,s3
      state = 0;
    4eb6:	4981                	li	s3,0
    4eb8:	bbf9                	j	4c96 <vprintf+0x4a>
    4eba:	64a6                	ld	s1,72(sp)
    4ebc:	79e2                	ld	s3,56(sp)
    4ebe:	7a42                	ld	s4,48(sp)
    4ec0:	7aa2                	ld	s5,40(sp)
    4ec2:	7b02                	ld	s6,32(sp)
    4ec4:	6be2                	ld	s7,24(sp)
    4ec6:	6c42                	ld	s8,16(sp)
    4ec8:	6ca2                	ld	s9,8(sp)
    }
  }
}
    4eca:	60e6                	ld	ra,88(sp)
    4ecc:	6446                	ld	s0,80(sp)
    4ece:	6906                	ld	s2,64(sp)
    4ed0:	6125                	addi	sp,sp,96
    4ed2:	8082                	ret

0000000000004ed4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    4ed4:	715d                	addi	sp,sp,-80
    4ed6:	ec06                	sd	ra,24(sp)
    4ed8:	e822                	sd	s0,16(sp)
    4eda:	1000                	addi	s0,sp,32
    4edc:	e010                	sd	a2,0(s0)
    4ede:	e414                	sd	a3,8(s0)
    4ee0:	e818                	sd	a4,16(s0)
    4ee2:	ec1c                	sd	a5,24(s0)
    4ee4:	03043023          	sd	a6,32(s0)
    4ee8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    4eec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    4ef0:	8622                	mv	a2,s0
    4ef2:	d5bff0ef          	jal	4c4c <vprintf>
}
    4ef6:	60e2                	ld	ra,24(sp)
    4ef8:	6442                	ld	s0,16(sp)
    4efa:	6161                	addi	sp,sp,80
    4efc:	8082                	ret

0000000000004efe <printf>:

void
printf(const char *fmt, ...)
{
    4efe:	711d                	addi	sp,sp,-96
    4f00:	ec06                	sd	ra,24(sp)
    4f02:	e822                	sd	s0,16(sp)
    4f04:	1000                	addi	s0,sp,32
    4f06:	e40c                	sd	a1,8(s0)
    4f08:	e810                	sd	a2,16(s0)
    4f0a:	ec14                	sd	a3,24(s0)
    4f0c:	f018                	sd	a4,32(s0)
    4f0e:	f41c                	sd	a5,40(s0)
    4f10:	03043823          	sd	a6,48(s0)
    4f14:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    4f18:	00840613          	addi	a2,s0,8
    4f1c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    4f20:	85aa                	mv	a1,a0
    4f22:	4505                	li	a0,1
    4f24:	d29ff0ef          	jal	4c4c <vprintf>
}
    4f28:	60e2                	ld	ra,24(sp)
    4f2a:	6442                	ld	s0,16(sp)
    4f2c:	6125                	addi	sp,sp,96
    4f2e:	8082                	ret

0000000000004f30 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4f30:	1141                	addi	sp,sp,-16
    4f32:	e422                	sd	s0,8(sp)
    4f34:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4f36:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4f3a:	00004797          	auipc	a5,0x4
    4f3e:	5167b783          	ld	a5,1302(a5) # 9450 <freep>
    4f42:	a02d                	j	4f6c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    4f44:	4618                	lw	a4,8(a2)
    4f46:	9f2d                	addw	a4,a4,a1
    4f48:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    4f4c:	6398                	ld	a4,0(a5)
    4f4e:	6310                	ld	a2,0(a4)
    4f50:	a83d                	j	4f8e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    4f52:	ff852703          	lw	a4,-8(a0)
    4f56:	9f31                	addw	a4,a4,a2
    4f58:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    4f5a:	ff053683          	ld	a3,-16(a0)
    4f5e:	a091                	j	4fa2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4f60:	6398                	ld	a4,0(a5)
    4f62:	00e7e463          	bltu	a5,a4,4f6a <free+0x3a>
    4f66:	00e6ea63          	bltu	a3,a4,4f7a <free+0x4a>
{
    4f6a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4f6c:	fed7fae3          	bgeu	a5,a3,4f60 <free+0x30>
    4f70:	6398                	ld	a4,0(a5)
    4f72:	00e6e463          	bltu	a3,a4,4f7a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4f76:	fee7eae3          	bltu	a5,a4,4f6a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    4f7a:	ff852583          	lw	a1,-8(a0)
    4f7e:	6390                	ld	a2,0(a5)
    4f80:	02059813          	slli	a6,a1,0x20
    4f84:	01c85713          	srli	a4,a6,0x1c
    4f88:	9736                	add	a4,a4,a3
    4f8a:	fae60de3          	beq	a2,a4,4f44 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    4f8e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    4f92:	4790                	lw	a2,8(a5)
    4f94:	02061593          	slli	a1,a2,0x20
    4f98:	01c5d713          	srli	a4,a1,0x1c
    4f9c:	973e                	add	a4,a4,a5
    4f9e:	fae68ae3          	beq	a3,a4,4f52 <free+0x22>
    p->s.ptr = bp->s.ptr;
    4fa2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    4fa4:	00004717          	auipc	a4,0x4
    4fa8:	4af73623          	sd	a5,1196(a4) # 9450 <freep>
}
    4fac:	6422                	ld	s0,8(sp)
    4fae:	0141                	addi	sp,sp,16
    4fb0:	8082                	ret

0000000000004fb2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    4fb2:	7139                	addi	sp,sp,-64
    4fb4:	fc06                	sd	ra,56(sp)
    4fb6:	f822                	sd	s0,48(sp)
    4fb8:	f426                	sd	s1,40(sp)
    4fba:	ec4e                	sd	s3,24(sp)
    4fbc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4fbe:	02051493          	slli	s1,a0,0x20
    4fc2:	9081                	srli	s1,s1,0x20
    4fc4:	04bd                	addi	s1,s1,15
    4fc6:	8091                	srli	s1,s1,0x4
    4fc8:	0014899b          	addiw	s3,s1,1
    4fcc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    4fce:	00004517          	auipc	a0,0x4
    4fd2:	48253503          	ld	a0,1154(a0) # 9450 <freep>
    4fd6:	c915                	beqz	a0,500a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4fd8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4fda:	4798                	lw	a4,8(a5)
    4fdc:	08977a63          	bgeu	a4,s1,5070 <malloc+0xbe>
    4fe0:	f04a                	sd	s2,32(sp)
    4fe2:	e852                	sd	s4,16(sp)
    4fe4:	e456                	sd	s5,8(sp)
    4fe6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    4fe8:	8a4e                	mv	s4,s3
    4fea:	0009871b          	sext.w	a4,s3
    4fee:	6685                	lui	a3,0x1
    4ff0:	00d77363          	bgeu	a4,a3,4ff6 <malloc+0x44>
    4ff4:	6a05                	lui	s4,0x1
    4ff6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    4ffa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    4ffe:	00004917          	auipc	s2,0x4
    5002:	45290913          	addi	s2,s2,1106 # 9450 <freep>
  if(p == (char*)-1)
    5006:	5afd                	li	s5,-1
    5008:	a081                	j	5048 <malloc+0x96>
    500a:	f04a                	sd	s2,32(sp)
    500c:	e852                	sd	s4,16(sp)
    500e:	e456                	sd	s5,8(sp)
    5010:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    5012:	0000b797          	auipc	a5,0xb
    5016:	c6678793          	addi	a5,a5,-922 # fc78 <base>
    501a:	00004717          	auipc	a4,0x4
    501e:	42f73b23          	sd	a5,1078(a4) # 9450 <freep>
    5022:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5024:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5028:	b7c1                	j	4fe8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    502a:	6398                	ld	a4,0(a5)
    502c:	e118                	sd	a4,0(a0)
    502e:	a8a9                	j	5088 <malloc+0xd6>
  hp->s.size = nu;
    5030:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5034:	0541                	addi	a0,a0,16
    5036:	efbff0ef          	jal	4f30 <free>
  return freep;
    503a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    503e:	c12d                	beqz	a0,50a0 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5040:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5042:	4798                	lw	a4,8(a5)
    5044:	02977263          	bgeu	a4,s1,5068 <malloc+0xb6>
    if(p == freep)
    5048:	00093703          	ld	a4,0(s2)
    504c:	853e                	mv	a0,a5
    504e:	fef719e3          	bne	a4,a5,5040 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    5052:	8552                	mv	a0,s4
    5054:	b1bff0ef          	jal	4b6e <sbrk>
  if(p == (char*)-1)
    5058:	fd551ce3          	bne	a0,s5,5030 <malloc+0x7e>
        return 0;
    505c:	4501                	li	a0,0
    505e:	7902                	ld	s2,32(sp)
    5060:	6a42                	ld	s4,16(sp)
    5062:	6aa2                	ld	s5,8(sp)
    5064:	6b02                	ld	s6,0(sp)
    5066:	a03d                	j	5094 <malloc+0xe2>
    5068:	7902                	ld	s2,32(sp)
    506a:	6a42                	ld	s4,16(sp)
    506c:	6aa2                	ld	s5,8(sp)
    506e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    5070:	fae48de3          	beq	s1,a4,502a <malloc+0x78>
        p->s.size -= nunits;
    5074:	4137073b          	subw	a4,a4,s3
    5078:	c798                	sw	a4,8(a5)
        p += p->s.size;
    507a:	02071693          	slli	a3,a4,0x20
    507e:	01c6d713          	srli	a4,a3,0x1c
    5082:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5084:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5088:	00004717          	auipc	a4,0x4
    508c:	3ca73423          	sd	a0,968(a4) # 9450 <freep>
      return (void*)(p + 1);
    5090:	01078513          	addi	a0,a5,16
  }
}
    5094:	70e2                	ld	ra,56(sp)
    5096:	7442                	ld	s0,48(sp)
    5098:	74a2                	ld	s1,40(sp)
    509a:	69e2                	ld	s3,24(sp)
    509c:	6121                	addi	sp,sp,64
    509e:	8082                	ret
    50a0:	7902                	ld	s2,32(sp)
    50a2:	6a42                	ld	s4,16(sp)
    50a4:	6aa2                	ld	s5,8(sp)
    50a6:	6b02                	ld	s6,0(sp)
    50a8:	b7f5                	j	5094 <malloc+0xe2>