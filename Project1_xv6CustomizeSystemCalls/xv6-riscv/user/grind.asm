
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	f99ff0ef          	jal	0 <do_rand>
}
      6c:	60a2                	ld	ra,8(sp)
      6e:	6402                	ld	s0,0(sp)
      70:	0141                	addi	sp,sp,16
      72:	8082                	ret

0000000000000074 <go>:

void
go(int which_child)
{
      74:	7119                	addi	sp,sp,-128
      76:	fc86                	sd	ra,120(sp)
      78:	f8a2                	sd	s0,112(sp)
      7a:	f4a6                	sd	s1,104(sp)
      7c:	e4d6                	sd	s5,72(sp)
      7e:	0100                	addi	s0,sp,128
      80:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      82:	4501                	li	a0,0
      84:	3b9000ef          	jal	c3c <sbrk>
      88:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      8a:	00001517          	auipc	a0,0x1
      8e:	0f650513          	addi	a0,a0,246 # 1180 <malloc+0x100>
      92:	38b000ef          	jal	c1c <mkdir>
  if(chdir("grindir") != 0){
      96:	00001517          	auipc	a0,0x1
      9a:	0ea50513          	addi	a0,a0,234 # 1180 <malloc+0x100>
      9e:	387000ef          	jal	c24 <chdir>
      a2:	cd19                	beqz	a0,c0 <go+0x4c>
      a4:	f0ca                	sd	s2,96(sp)
      a6:	ecce                	sd	s3,88(sp)
      a8:	e8d2                	sd	s4,80(sp)
      aa:	e0da                	sd	s6,64(sp)
      ac:	fc5e                	sd	s7,56(sp)
    printf("grind: chdir grindir failed\n");
      ae:	00001517          	auipc	a0,0x1
      b2:	0da50513          	addi	a0,a0,218 # 1188 <malloc+0x108>
      b6:	717000ef          	jal	fcc <printf>
    exit(1);
      ba:	4505                	li	a0,1
      bc:	2f9000ef          	jal	bb4 <exit>
      c0:	f0ca                	sd	s2,96(sp)
      c2:	ecce                	sd	s3,88(sp)
      c4:	e8d2                	sd	s4,80(sp)
      c6:	e0da                	sd	s6,64(sp)
      c8:	fc5e                	sd	s7,56(sp)
  }
  chdir("/");
      ca:	00001517          	auipc	a0,0x1
      ce:	0e650513          	addi	a0,a0,230 # 11b0 <malloc+0x130>
      d2:	353000ef          	jal	c24 <chdir>
      d6:	00001997          	auipc	s3,0x1
      da:	0ea98993          	addi	s3,s3,234 # 11c0 <malloc+0x140>
      de:	c489                	beqz	s1,e8 <go+0x74>
      e0:	00001997          	auipc	s3,0x1
      e4:	0d898993          	addi	s3,s3,216 # 11b8 <malloc+0x138>
  uint64 iters = 0;
      e8:	4481                	li	s1,0
  int fd = -1;
      ea:	5a7d                	li	s4,-1
      ec:	00001917          	auipc	s2,0x1
      f0:	3a490913          	addi	s2,s2,932 # 1490 <malloc+0x410>
      f4:	a819                	j	10a <go+0x96>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
      f6:	20200593          	li	a1,514
      fa:	00001517          	auipc	a0,0x1
      fe:	0ce50513          	addi	a0,a0,206 # 11c8 <malloc+0x148>
     102:	2f3000ef          	jal	bf4 <open>
     106:	2d7000ef          	jal	bdc <close>
    iters++;
     10a:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     10c:	1f400793          	li	a5,500
     110:	02f4f7b3          	remu	a5,s1,a5
     114:	e791                	bnez	a5,120 <go+0xac>
      write(1, which_child?"B":"A", 1);
     116:	4605                	li	a2,1
     118:	85ce                	mv	a1,s3
     11a:	4505                	li	a0,1
     11c:	2b9000ef          	jal	bd4 <write>
    int what = rand() % 23;
     120:	f39ff0ef          	jal	58 <rand>
     124:	47dd                	li	a5,23
     126:	02f5653b          	remw	a0,a0,a5
     12a:	0005071b          	sext.w	a4,a0
     12e:	47d9                	li	a5,22
     130:	fce7ede3          	bltu	a5,a4,10a <go+0x96>
     134:	02051793          	slli	a5,a0,0x20
     138:	01e7d513          	srli	a0,a5,0x1e
     13c:	954a                	add	a0,a0,s2
     13e:	411c                	lw	a5,0(a0)
     140:	97ca                	add	a5,a5,s2
     142:	8782                	jr	a5
    } else if(what == 2){
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     144:	20200593          	li	a1,514
     148:	00001517          	auipc	a0,0x1
     14c:	09050513          	addi	a0,a0,144 # 11d8 <malloc+0x158>
     150:	2a5000ef          	jal	bf4 <open>
     154:	289000ef          	jal	bdc <close>
     158:	bf4d                	j	10a <go+0x96>
    } else if(what == 3){
      unlink("grindir/../a");
     15a:	00001517          	auipc	a0,0x1
     15e:	06e50513          	addi	a0,a0,110 # 11c8 <malloc+0x148>
     162:	2a3000ef          	jal	c04 <unlink>
     166:	b755                	j	10a <go+0x96>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     168:	00001517          	auipc	a0,0x1
     16c:	01850513          	addi	a0,a0,24 # 1180 <malloc+0x100>
     170:	2b5000ef          	jal	c24 <chdir>
     174:	ed11                	bnez	a0,190 <go+0x11c>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     176:	00001517          	auipc	a0,0x1
     17a:	07a50513          	addi	a0,a0,122 # 11f0 <malloc+0x170>
     17e:	287000ef          	jal	c04 <unlink>
      chdir("/");
     182:	00001517          	auipc	a0,0x1
     186:	02e50513          	addi	a0,a0,46 # 11b0 <malloc+0x130>
     18a:	29b000ef          	jal	c24 <chdir>
     18e:	bfb5                	j	10a <go+0x96>
        printf("grind: chdir grindir failed\n");
     190:	00001517          	auipc	a0,0x1
     194:	ff850513          	addi	a0,a0,-8 # 1188 <malloc+0x108>
     198:	635000ef          	jal	fcc <printf>
        exit(1);
     19c:	4505                	li	a0,1
     19e:	217000ef          	jal	bb4 <exit>
    } else if(what == 5){
      close(fd);
     1a2:	8552                	mv	a0,s4
     1a4:	239000ef          	jal	bdc <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1a8:	20200593          	li	a1,514
     1ac:	00001517          	auipc	a0,0x1
     1b0:	04c50513          	addi	a0,a0,76 # 11f8 <malloc+0x178>
     1b4:	241000ef          	jal	bf4 <open>
     1b8:	8a2a                	mv	s4,a0
     1ba:	bf81                	j	10a <go+0x96>
    } else if(what == 6){
      close(fd);
     1bc:	8552                	mv	a0,s4
     1be:	21f000ef          	jal	bdc <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     1c2:	20200593          	li	a1,514
     1c6:	00001517          	auipc	a0,0x1
     1ca:	04250513          	addi	a0,a0,66 # 1208 <malloc+0x188>
     1ce:	227000ef          	jal	bf4 <open>
     1d2:	8a2a                	mv	s4,a0
     1d4:	bf1d                	j	10a <go+0x96>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     1d6:	3e700613          	li	a2,999
     1da:	00002597          	auipc	a1,0x2
     1de:	e4658593          	addi	a1,a1,-442 # 2020 <buf.0>
     1e2:	8552                	mv	a0,s4
     1e4:	1f1000ef          	jal	bd4 <write>
     1e8:	b70d                	j	10a <go+0x96>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     1ea:	3e700613          	li	a2,999
     1ee:	00002597          	auipc	a1,0x2
     1f2:	e3258593          	addi	a1,a1,-462 # 2020 <buf.0>
     1f6:	8552                	mv	a0,s4
     1f8:	1d5000ef          	jal	bcc <read>
     1fc:	b739                	j	10a <go+0x96>
    } else if(what == 9){
      mkdir("grindir/../a");
     1fe:	00001517          	auipc	a0,0x1
     202:	fca50513          	addi	a0,a0,-54 # 11c8 <malloc+0x148>
     206:	217000ef          	jal	c1c <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     20a:	20200593          	li	a1,514
     20e:	00001517          	auipc	a0,0x1
     212:	01250513          	addi	a0,a0,18 # 1220 <malloc+0x1a0>
     216:	1df000ef          	jal	bf4 <open>
     21a:	1c3000ef          	jal	bdc <close>
      unlink("a/a");
     21e:	00001517          	auipc	a0,0x1
     222:	01250513          	addi	a0,a0,18 # 1230 <malloc+0x1b0>
     226:	1df000ef          	jal	c04 <unlink>
     22a:	b5c5                	j	10a <go+0x96>
    } else if(what == 10){
      mkdir("/../b");
     22c:	00001517          	auipc	a0,0x1
     230:	00c50513          	addi	a0,a0,12 # 1238 <malloc+0x1b8>
     234:	1e9000ef          	jal	c1c <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     238:	20200593          	li	a1,514
     23c:	00001517          	auipc	a0,0x1
     240:	00450513          	addi	a0,a0,4 # 1240 <malloc+0x1c0>
     244:	1b1000ef          	jal	bf4 <open>
     248:	195000ef          	jal	bdc <close>
      unlink("b/b");
     24c:	00001517          	auipc	a0,0x1
     250:	00450513          	addi	a0,a0,4 # 1250 <malloc+0x1d0>
     254:	1b1000ef          	jal	c04 <unlink>
     258:	bd4d                	j	10a <go+0x96>
    } else if(what == 11){
      unlink("b");
     25a:	00001517          	auipc	a0,0x1
     25e:	ffe50513          	addi	a0,a0,-2 # 1258 <malloc+0x1d8>
     262:	1a3000ef          	jal	c04 <unlink>
      link("../grindir/./../a", "../b");
     266:	00001597          	auipc	a1,0x1
     26a:	f8a58593          	addi	a1,a1,-118 # 11f0 <malloc+0x170>
     26e:	00001517          	auipc	a0,0x1
     272:	ff250513          	addi	a0,a0,-14 # 1260 <malloc+0x1e0>
     276:	19f000ef          	jal	c14 <link>
     27a:	bd41                	j	10a <go+0x96>
    } else if(what == 12){
      unlink("../grindir/../a");
     27c:	00001517          	auipc	a0,0x1
     280:	ffc50513          	addi	a0,a0,-4 # 1278 <malloc+0x1f8>
     284:	181000ef          	jal	c04 <unlink>
      link(".././b", "/grindir/../a");
     288:	00001597          	auipc	a1,0x1
     28c:	f7058593          	addi	a1,a1,-144 # 11f8 <malloc+0x178>
     290:	00001517          	auipc	a0,0x1
     294:	ff850513          	addi	a0,a0,-8 # 1288 <malloc+0x208>
     298:	17d000ef          	jal	c14 <link>
     29c:	b5bd                	j	10a <go+0x96>
    } else if(what == 13){
      int pid = fork();
     29e:	10f000ef          	jal	bac <fork>
      if(pid == 0){
     2a2:	c519                	beqz	a0,2b0 <go+0x23c>
        exit(0);
      } else if(pid < 0){
     2a4:	00054863          	bltz	a0,2b4 <go+0x240>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     2a8:	4501                	li	a0,0
     2aa:	113000ef          	jal	bbc <wait>
     2ae:	bdb1                	j	10a <go+0x96>
        exit(0);
     2b0:	105000ef          	jal	bb4 <exit>
        printf("grind: fork failed\n");
     2b4:	00001517          	auipc	a0,0x1
     2b8:	fdc50513          	addi	a0,a0,-36 # 1290 <malloc+0x210>
     2bc:	511000ef          	jal	fcc <printf>
        exit(1);
     2c0:	4505                	li	a0,1
     2c2:	0f3000ef          	jal	bb4 <exit>
    } else if(what == 14){
      int pid = fork();
     2c6:	0e7000ef          	jal	bac <fork>
      if(pid == 0){
     2ca:	c519                	beqz	a0,2d8 <go+0x264>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     2cc:	00054d63          	bltz	a0,2e6 <go+0x272>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     2d0:	4501                	li	a0,0
     2d2:	0eb000ef          	jal	bbc <wait>
     2d6:	bd15                	j	10a <go+0x96>
        fork();
     2d8:	0d5000ef          	jal	bac <fork>
        fork();
     2dc:	0d1000ef          	jal	bac <fork>
        exit(0);
     2e0:	4501                	li	a0,0
     2e2:	0d3000ef          	jal	bb4 <exit>
        printf("grind: fork failed\n");
     2e6:	00001517          	auipc	a0,0x1
     2ea:	faa50513          	addi	a0,a0,-86 # 1290 <malloc+0x210>
     2ee:	4df000ef          	jal	fcc <printf>
        exit(1);
     2f2:	4505                	li	a0,1
     2f4:	0c1000ef          	jal	bb4 <exit>
    } else if(what == 15){
      sbrk(6011);
     2f8:	6505                	lui	a0,0x1
     2fa:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x28b>
     2fe:	13f000ef          	jal	c3c <sbrk>
     302:	b521                	j	10a <go+0x96>
    } else if(what == 16){
      if(sbrk(0) > break0)
     304:	4501                	li	a0,0
     306:	137000ef          	jal	c3c <sbrk>
     30a:	e0aaf0e3          	bgeu	s5,a0,10a <go+0x96>
        sbrk(-(sbrk(0) - break0));
     30e:	4501                	li	a0,0
     310:	12d000ef          	jal	c3c <sbrk>
     314:	40aa853b          	subw	a0,s5,a0
     318:	125000ef          	jal	c3c <sbrk>
     31c:	b3fd                	j	10a <go+0x96>
    } else if(what == 17){
      int pid = fork();
     31e:	08f000ef          	jal	bac <fork>
     322:	8b2a                	mv	s6,a0
      if(pid == 0){
     324:	c10d                	beqz	a0,346 <go+0x2d2>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     326:	02054d63          	bltz	a0,360 <go+0x2ec>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     32a:	00001517          	auipc	a0,0x1
     32e:	f8650513          	addi	a0,a0,-122 # 12b0 <malloc+0x230>
     332:	0f3000ef          	jal	c24 <chdir>
     336:	ed15                	bnez	a0,372 <go+0x2fe>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     338:	855a                	mv	a0,s6
     33a:	0ab000ef          	jal	be4 <kill>
      wait(0);
     33e:	4501                	li	a0,0
     340:	07d000ef          	jal	bbc <wait>
     344:	b3d9                	j	10a <go+0x96>
        close(open("a", O_CREATE|O_RDWR));
     346:	20200593          	li	a1,514
     34a:	00001517          	auipc	a0,0x1
     34e:	f5e50513          	addi	a0,a0,-162 # 12a8 <malloc+0x228>
     352:	0a3000ef          	jal	bf4 <open>
     356:	087000ef          	jal	bdc <close>
        exit(0);
     35a:	4501                	li	a0,0
     35c:	059000ef          	jal	bb4 <exit>
        printf("grind: fork failed\n");
     360:	00001517          	auipc	a0,0x1
     364:	f3050513          	addi	a0,a0,-208 # 1290 <malloc+0x210>
     368:	465000ef          	jal	fcc <printf>
        exit(1);
     36c:	4505                	li	a0,1
     36e:	047000ef          	jal	bb4 <exit>
        printf("grind: chdir failed\n");
     372:	00001517          	auipc	a0,0x1
     376:	f4e50513          	addi	a0,a0,-178 # 12c0 <malloc+0x240>
     37a:	453000ef          	jal	fcc <printf>
        exit(1);
     37e:	4505                	li	a0,1
     380:	035000ef          	jal	bb4 <exit>
    } else if(what == 18){
      int pid = fork();
     384:	029000ef          	jal	bac <fork>
      if(pid == 0){
     388:	c519                	beqz	a0,396 <go+0x322>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     38a:	00054d63          	bltz	a0,3a4 <go+0x330>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     38e:	4501                	li	a0,0
     390:	02d000ef          	jal	bbc <wait>
     394:	bb9d                	j	10a <go+0x96>
        kill(getpid());
     396:	09f000ef          	jal	c34 <getpid>
     39a:	04b000ef          	jal	be4 <kill>
        exit(0);
     39e:	4501                	li	a0,0
     3a0:	015000ef          	jal	bb4 <exit>
        printf("grind: fork failed\n");
     3a4:	00001517          	auipc	a0,0x1
     3a8:	eec50513          	addi	a0,a0,-276 # 1290 <malloc+0x210>
     3ac:	421000ef          	jal	fcc <printf>
        exit(1);
     3b0:	4505                	li	a0,1
     3b2:	003000ef          	jal	bb4 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     3b6:	f9840513          	addi	a0,s0,-104
     3ba:	00b000ef          	jal	bc4 <pipe>
     3be:	02054363          	bltz	a0,3e4 <go+0x370>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     3c2:	7ea000ef          	jal	bac <fork>
      if(pid == 0){
     3c6:	c905                	beqz	a0,3f6 <go+0x382>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     3c8:	08054263          	bltz	a0,44c <go+0x3d8>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     3cc:	f9842503          	lw	a0,-104(s0)
     3d0:	00d000ef          	jal	bdc <close>
      close(fds[1]);
     3d4:	f9c42503          	lw	a0,-100(s0)
     3d8:	005000ef          	jal	bdc <close>
      wait(0);
     3dc:	4501                	li	a0,0
     3de:	7de000ef          	jal	bbc <wait>
     3e2:	b325                	j	10a <go+0x96>
        printf("grind: pipe failed\n");
     3e4:	00001517          	auipc	a0,0x1
     3e8:	ef450513          	addi	a0,a0,-268 # 12d8 <malloc+0x258>
     3ec:	3e1000ef          	jal	fcc <printf>
        exit(1);
     3f0:	4505                	li	a0,1
     3f2:	7c2000ef          	jal	bb4 <exit>
        fork();
     3f6:	7b6000ef          	jal	bac <fork>
        fork();
     3fa:	7b2000ef          	jal	bac <fork>
        if(write(fds[1], "x", 1) != 1)
     3fe:	4605                	li	a2,1
     400:	00001597          	auipc	a1,0x1
     404:	ef058593          	addi	a1,a1,-272 # 12f0 <malloc+0x270>
     408:	f9c42503          	lw	a0,-100(s0)
     40c:	7c8000ef          	jal	bd4 <write>
     410:	4785                	li	a5,1
     412:	00f51f63          	bne	a0,a5,430 <go+0x3bc>
        if(read(fds[0], &c, 1) != 1)
     416:	4605                	li	a2,1
     418:	f9040593          	addi	a1,s0,-112
     41c:	f9842503          	lw	a0,-104(s0)
     420:	7ac000ef          	jal	bcc <read>
     424:	4785                	li	a5,1
     426:	00f51c63          	bne	a0,a5,43e <go+0x3ca>
        exit(0);
     42a:	4501                	li	a0,0
     42c:	788000ef          	jal	bb4 <exit>
          printf("grind: pipe write failed\n");
     430:	00001517          	auipc	a0,0x1
     434:	ec850513          	addi	a0,a0,-312 # 12f8 <malloc+0x278>
     438:	395000ef          	jal	fcc <printf>
     43c:	bfe9                	j	416 <go+0x3a2>
          printf("grind: pipe read failed\n");
     43e:	00001517          	auipc	a0,0x1
     442:	eda50513          	addi	a0,a0,-294 # 1318 <malloc+0x298>
     446:	387000ef          	jal	fcc <printf>
     44a:	b7c5                	j	42a <go+0x3b6>
        printf("grind: fork failed\n");
     44c:	00001517          	auipc	a0,0x1
     450:	e4450513          	addi	a0,a0,-444 # 1290 <malloc+0x210>
     454:	379000ef          	jal	fcc <printf>
        exit(1);
     458:	4505                	li	a0,1
     45a:	75a000ef          	jal	bb4 <exit>
    } else if(what == 20){
      int pid = fork();
     45e:	74e000ef          	jal	bac <fork>
      if(pid == 0){
     462:	c519                	beqz	a0,470 <go+0x3fc>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     464:	04054f63          	bltz	a0,4c2 <go+0x44e>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     468:	4501                	li	a0,0
     46a:	752000ef          	jal	bbc <wait>
     46e:	b971                	j	10a <go+0x96>
        unlink("a");
     470:	00001517          	auipc	a0,0x1
     474:	e3850513          	addi	a0,a0,-456 # 12a8 <malloc+0x228>
     478:	78c000ef          	jal	c04 <unlink>
        mkdir("a");
     47c:	00001517          	auipc	a0,0x1
     480:	e2c50513          	addi	a0,a0,-468 # 12a8 <malloc+0x228>
     484:	798000ef          	jal	c1c <mkdir>
        chdir("a");
     488:	00001517          	auipc	a0,0x1
     48c:	e2050513          	addi	a0,a0,-480 # 12a8 <malloc+0x228>
     490:	794000ef          	jal	c24 <chdir>
        unlink("../a");
     494:	00001517          	auipc	a0,0x1
     498:	ea450513          	addi	a0,a0,-348 # 1338 <malloc+0x2b8>
     49c:	768000ef          	jal	c04 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     4a0:	20200593          	li	a1,514
     4a4:	00001517          	auipc	a0,0x1
     4a8:	e4c50513          	addi	a0,a0,-436 # 12f0 <malloc+0x270>
     4ac:	748000ef          	jal	bf4 <open>
        unlink("x");
     4b0:	00001517          	auipc	a0,0x1
     4b4:	e4050513          	addi	a0,a0,-448 # 12f0 <malloc+0x270>
     4b8:	74c000ef          	jal	c04 <unlink>
        exit(0);
     4bc:	4501                	li	a0,0
     4be:	6f6000ef          	jal	bb4 <exit>
        printf("grind: fork failed\n");
     4c2:	00001517          	auipc	a0,0x1
     4c6:	dce50513          	addi	a0,a0,-562 # 1290 <malloc+0x210>
     4ca:	303000ef          	jal	fcc <printf>
        exit(1);
     4ce:	4505                	li	a0,1
     4d0:	6e4000ef          	jal	bb4 <exit>
    } else if(what == 21){
      unlink("c");
     4d4:	00001517          	auipc	a0,0x1
     4d8:	e6c50513          	addi	a0,a0,-404 # 1340 <malloc+0x2c0>
     4dc:	728000ef          	jal	c04 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     4e0:	20200593          	li	a1,514
     4e4:	00001517          	auipc	a0,0x1
     4e8:	e5c50513          	addi	a0,a0,-420 # 1340 <malloc+0x2c0>
     4ec:	708000ef          	jal	bf4 <open>
     4f0:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     4f2:	04054763          	bltz	a0,540 <go+0x4cc>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     4f6:	4605                	li	a2,1
     4f8:	00001597          	auipc	a1,0x1
     4fc:	df858593          	addi	a1,a1,-520 # 12f0 <malloc+0x270>
     500:	6d4000ef          	jal	bd4 <write>
     504:	4785                	li	a5,1
     506:	04f51663          	bne	a0,a5,552 <go+0x4de>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     50a:	f9840593          	addi	a1,s0,-104
     50e:	855a                	mv	a0,s6
     510:	6fc000ef          	jal	c0c <fstat>
     514:	e921                	bnez	a0,564 <go+0x4f0>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     516:	fa843583          	ld	a1,-88(s0)
     51a:	4785                	li	a5,1
     51c:	04f59d63          	bne	a1,a5,576 <go+0x502>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     520:	f9c42583          	lw	a1,-100(s0)
     524:	0c800793          	li	a5,200
     528:	06b7e163          	bltu	a5,a1,58a <go+0x516>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     52c:	855a                	mv	a0,s6
     52e:	6ae000ef          	jal	bdc <close>
      unlink("c");
     532:	00001517          	auipc	a0,0x1
     536:	e0e50513          	addi	a0,a0,-498 # 1340 <malloc+0x2c0>
     53a:	6ca000ef          	jal	c04 <unlink>
     53e:	b6f1                	j	10a <go+0x96>
        printf("grind: create c failed\n");
     540:	00001517          	auipc	a0,0x1
     544:	e0850513          	addi	a0,a0,-504 # 1348 <malloc+0x2c8>
     548:	285000ef          	jal	fcc <printf>
        exit(1);
     54c:	4505                	li	a0,1
     54e:	666000ef          	jal	bb4 <exit>
        printf("grind: write c failed\n");
     552:	00001517          	auipc	a0,0x1
     556:	e0e50513          	addi	a0,a0,-498 # 1360 <malloc+0x2e0>
     55a:	273000ef          	jal	fcc <printf>
        exit(1);
     55e:	4505                	li	a0,1
     560:	654000ef          	jal	bb4 <exit>
        printf("grind: fstat failed\n");
     564:	00001517          	auipc	a0,0x1
     568:	e1450513          	addi	a0,a0,-492 # 1378 <malloc+0x2f8>
     56c:	261000ef          	jal	fcc <printf>
        exit(1);
     570:	4505                	li	a0,1
     572:	642000ef          	jal	bb4 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     576:	2581                	sext.w	a1,a1
     578:	00001517          	auipc	a0,0x1
     57c:	e1850513          	addi	a0,a0,-488 # 1390 <malloc+0x310>
     580:	24d000ef          	jal	fcc <printf>
        exit(1);
     584:	4505                	li	a0,1
     586:	62e000ef          	jal	bb4 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     58a:	00001517          	auipc	a0,0x1
     58e:	e2e50513          	addi	a0,a0,-466 # 13b8 <malloc+0x338>
     592:	23b000ef          	jal	fcc <printf>
        exit(1);
     596:	4505                	li	a0,1
     598:	61c000ef          	jal	bb4 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     59c:	f8840513          	addi	a0,s0,-120
     5a0:	624000ef          	jal	bc4 <pipe>
     5a4:	0a054563          	bltz	a0,64e <go+0x5da>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     5a8:	f9040513          	addi	a0,s0,-112
     5ac:	618000ef          	jal	bc4 <pipe>
     5b0:	0a054963          	bltz	a0,662 <go+0x5ee>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     5b4:	5f8000ef          	jal	bac <fork>
      if(pid1 == 0){
     5b8:	cd5d                	beqz	a0,676 <go+0x602>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     5ba:	14054263          	bltz	a0,6fe <go+0x68a>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     5be:	5ee000ef          	jal	bac <fork>
      if(pid2 == 0){
     5c2:	14050863          	beqz	a0,712 <go+0x69e>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     5c6:	1e054663          	bltz	a0,7b2 <go+0x73e>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     5ca:	f8842503          	lw	a0,-120(s0)
     5ce:	60e000ef          	jal	bdc <close>
      close(aa[1]);
     5d2:	f8c42503          	lw	a0,-116(s0)
     5d6:	606000ef          	jal	bdc <close>
      close(bb[1]);
     5da:	f9442503          	lw	a0,-108(s0)
     5de:	5fe000ef          	jal	bdc <close>
      char buf[4] = { 0, 0, 0, 0 };
     5e2:	f8042023          	sw	zero,-128(s0)
      read(bb[0], buf+0, 1);
     5e6:	4605                	li	a2,1
     5e8:	f8040593          	addi	a1,s0,-128
     5ec:	f9042503          	lw	a0,-112(s0)
     5f0:	5dc000ef          	jal	bcc <read>
      read(bb[0], buf+1, 1);
     5f4:	4605                	li	a2,1
     5f6:	f8140593          	addi	a1,s0,-127
     5fa:	f9042503          	lw	a0,-112(s0)
     5fe:	5ce000ef          	jal	bcc <read>
      read(bb[0], buf+2, 1);
     602:	4605                	li	a2,1
     604:	f8240593          	addi	a1,s0,-126
     608:	f9042503          	lw	a0,-112(s0)
     60c:	5c0000ef          	jal	bcc <read>
      close(bb[0]);
     610:	f9042503          	lw	a0,-112(s0)
     614:	5c8000ef          	jal	bdc <close>
      int st1, st2;
      wait(&st1);
     618:	f8440513          	addi	a0,s0,-124
     61c:	5a0000ef          	jal	bbc <wait>
      wait(&st2);
     620:	f9840513          	addi	a0,s0,-104
     624:	598000ef          	jal	bbc <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     628:	f8442783          	lw	a5,-124(s0)
     62c:	f9842b83          	lw	s7,-104(s0)
     630:	0177eb33          	or	s6,a5,s7
     634:	180b1963          	bnez	s6,7c6 <go+0x752>
     638:	00001597          	auipc	a1,0x1
     63c:	e2058593          	addi	a1,a1,-480 # 1458 <malloc+0x3d8>
     640:	f8040513          	addi	a0,s0,-128
     644:	2ce000ef          	jal	912 <strcmp>
     648:	ac0501e3          	beqz	a0,10a <go+0x96>
     64c:	aab5                	j	7c8 <go+0x754>
        fprintf(2, "grind: pipe failed\n");
     64e:	00001597          	auipc	a1,0x1
     652:	c8a58593          	addi	a1,a1,-886 # 12d8 <malloc+0x258>
     656:	4509                	li	a0,2
     658:	14b000ef          	jal	fa2 <fprintf>
        exit(1);
     65c:	4505                	li	a0,1
     65e:	556000ef          	jal	bb4 <exit>
        fprintf(2, "grind: pipe failed\n");
     662:	00001597          	auipc	a1,0x1
     666:	c7658593          	addi	a1,a1,-906 # 12d8 <malloc+0x258>
     66a:	4509                	li	a0,2
     66c:	137000ef          	jal	fa2 <fprintf>
        exit(1);
     670:	4505                	li	a0,1
     672:	542000ef          	jal	bb4 <exit>
        close(bb[0]);
     676:	f9042503          	lw	a0,-112(s0)
     67a:	562000ef          	jal	bdc <close>
        close(bb[1]);
     67e:	f9442503          	lw	a0,-108(s0)
     682:	55a000ef          	jal	bdc <close>
        close(aa[0]);
     686:	f8842503          	lw	a0,-120(s0)
     68a:	552000ef          	jal	bdc <close>
        close(1);
     68e:	4505                	li	a0,1
     690:	54c000ef          	jal	bdc <close>
        if(dup(aa[1]) != 1){
     694:	f8c42503          	lw	a0,-116(s0)
     698:	594000ef          	jal	c2c <dup>
     69c:	4785                	li	a5,1
     69e:	00f50c63          	beq	a0,a5,6b6 <go+0x642>
          fprintf(2, "grind: dup failed\n");
     6a2:	00001597          	auipc	a1,0x1
     6a6:	d3e58593          	addi	a1,a1,-706 # 13e0 <malloc+0x360>
     6aa:	4509                	li	a0,2
     6ac:	0f7000ef          	jal	fa2 <fprintf>
          exit(1);
     6b0:	4505                	li	a0,1
     6b2:	502000ef          	jal	bb4 <exit>
        close(aa[1]);
     6b6:	f8c42503          	lw	a0,-116(s0)
     6ba:	522000ef          	jal	bdc <close>
        char *args[3] = { "echo", "hi", 0 };
     6be:	00001797          	auipc	a5,0x1
     6c2:	d3a78793          	addi	a5,a5,-710 # 13f8 <malloc+0x378>
     6c6:	f8f43c23          	sd	a5,-104(s0)
     6ca:	00001797          	auipc	a5,0x1
     6ce:	d3678793          	addi	a5,a5,-714 # 1400 <malloc+0x380>
     6d2:	faf43023          	sd	a5,-96(s0)
     6d6:	fa043423          	sd	zero,-88(s0)
        exec("grindir/../echo", args);
     6da:	f9840593          	addi	a1,s0,-104
     6de:	00001517          	auipc	a0,0x1
     6e2:	d2a50513          	addi	a0,a0,-726 # 1408 <malloc+0x388>
     6e6:	506000ef          	jal	bec <exec>
        fprintf(2, "grind: echo: not found\n");
     6ea:	00001597          	auipc	a1,0x1
     6ee:	d2e58593          	addi	a1,a1,-722 # 1418 <malloc+0x398>
     6f2:	4509                	li	a0,2
     6f4:	0af000ef          	jal	fa2 <fprintf>
        exit(2);
     6f8:	4509                	li	a0,2
     6fa:	4ba000ef          	jal	bb4 <exit>
        fprintf(2, "grind: fork failed\n");
     6fe:	00001597          	auipc	a1,0x1
     702:	b9258593          	addi	a1,a1,-1134 # 1290 <malloc+0x210>
     706:	4509                	li	a0,2
     708:	09b000ef          	jal	fa2 <fprintf>
        exit(3);
     70c:	450d                	li	a0,3
     70e:	4a6000ef          	jal	bb4 <exit>
        close(aa[1]);
     712:	f8c42503          	lw	a0,-116(s0)
     716:	4c6000ef          	jal	bdc <close>
        close(bb[0]);
     71a:	f9042503          	lw	a0,-112(s0)
     71e:	4be000ef          	jal	bdc <close>
        close(0);
     722:	4501                	li	a0,0
     724:	4b8000ef          	jal	bdc <close>
        if(dup(aa[0]) != 0){
     728:	f8842503          	lw	a0,-120(s0)
     72c:	500000ef          	jal	c2c <dup>
     730:	c919                	beqz	a0,746 <go+0x6d2>
          fprintf(2, "grind: dup failed\n");
     732:	00001597          	auipc	a1,0x1
     736:	cae58593          	addi	a1,a1,-850 # 13e0 <malloc+0x360>
     73a:	4509                	li	a0,2
     73c:	067000ef          	jal	fa2 <fprintf>
          exit(4);
     740:	4511                	li	a0,4
     742:	472000ef          	jal	bb4 <exit>
        close(aa[0]);
     746:	f8842503          	lw	a0,-120(s0)
     74a:	492000ef          	jal	bdc <close>
        close(1);
     74e:	4505                	li	a0,1
     750:	48c000ef          	jal	bdc <close>
        if(dup(bb[1]) != 1){
     754:	f9442503          	lw	a0,-108(s0)
     758:	4d4000ef          	jal	c2c <dup>
     75c:	4785                	li	a5,1
     75e:	00f50c63          	beq	a0,a5,776 <go+0x702>
          fprintf(2, "grind: dup failed\n");
     762:	00001597          	auipc	a1,0x1
     766:	c7e58593          	addi	a1,a1,-898 # 13e0 <malloc+0x360>
     76a:	4509                	li	a0,2
     76c:	037000ef          	jal	fa2 <fprintf>
          exit(5);
     770:	4515                	li	a0,5
     772:	442000ef          	jal	bb4 <exit>
        close(bb[1]);
     776:	f9442503          	lw	a0,-108(s0)
     77a:	462000ef          	jal	bdc <close>
        char *args[2] = { "cat", 0 };
     77e:	00001797          	auipc	a5,0x1
     782:	cb278793          	addi	a5,a5,-846 # 1430 <malloc+0x3b0>
     786:	f8f43c23          	sd	a5,-104(s0)
     78a:	fa043023          	sd	zero,-96(s0)
        exec("/cat", args);
     78e:	f9840593          	addi	a1,s0,-104
     792:	00001517          	auipc	a0,0x1
     796:	ca650513          	addi	a0,a0,-858 # 1438 <malloc+0x3b8>
     79a:	452000ef          	jal	bec <exec>
        fprintf(2, "grind: cat: not found\n");
     79e:	00001597          	auipc	a1,0x1
     7a2:	ca258593          	addi	a1,a1,-862 # 1440 <malloc+0x3c0>
     7a6:	4509                	li	a0,2
     7a8:	7fa000ef          	jal	fa2 <fprintf>
        exit(6);
     7ac:	4519                	li	a0,6
     7ae:	406000ef          	jal	bb4 <exit>
        fprintf(2, "grind: fork failed\n");
     7b2:	00001597          	auipc	a1,0x1
     7b6:	ade58593          	addi	a1,a1,-1314 # 1290 <malloc+0x210>
     7ba:	4509                	li	a0,2
     7bc:	7e6000ef          	jal	fa2 <fprintf>
        exit(7);
     7c0:	451d                	li	a0,7
     7c2:	3f2000ef          	jal	bb4 <exit>
     7c6:	8b3e                	mv	s6,a5
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     7c8:	f8040693          	addi	a3,s0,-128
     7cc:	865e                	mv	a2,s7
     7ce:	85da                	mv	a1,s6
     7d0:	00001517          	auipc	a0,0x1
     7d4:	c9050513          	addi	a0,a0,-880 # 1460 <malloc+0x3e0>
     7d8:	7f4000ef          	jal	fcc <printf>
        exit(1);
     7dc:	4505                	li	a0,1
     7de:	3d6000ef          	jal	bb4 <exit>

00000000000007e2 <iter>:
  }
}

void
iter()
{
     7e2:	7179                	addi	sp,sp,-48
     7e4:	f406                	sd	ra,40(sp)
     7e6:	f022                	sd	s0,32(sp)
     7e8:	1800                	addi	s0,sp,48
  unlink("a");
     7ea:	00001517          	auipc	a0,0x1
     7ee:	abe50513          	addi	a0,a0,-1346 # 12a8 <malloc+0x228>
     7f2:	412000ef          	jal	c04 <unlink>
  unlink("b");
     7f6:	00001517          	auipc	a0,0x1
     7fa:	a6250513          	addi	a0,a0,-1438 # 1258 <malloc+0x1d8>
     7fe:	406000ef          	jal	c04 <unlink>
  
  int pid1 = fork();
     802:	3aa000ef          	jal	bac <fork>
  if(pid1 < 0){
     806:	02054163          	bltz	a0,828 <iter+0x46>
     80a:	ec26                	sd	s1,24(sp)
     80c:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     80e:	e905                	bnez	a0,83e <iter+0x5c>
     810:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     812:	00001717          	auipc	a4,0x1
     816:	7ee70713          	addi	a4,a4,2030 # 2000 <rand_next>
     81a:	631c                	ld	a5,0(a4)
     81c:	01f7c793          	xori	a5,a5,31
     820:	e31c                	sd	a5,0(a4)
    go(0);
     822:	4501                	li	a0,0
     824:	851ff0ef          	jal	74 <go>
     828:	ec26                	sd	s1,24(sp)
     82a:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     82c:	00001517          	auipc	a0,0x1
     830:	a6450513          	addi	a0,a0,-1436 # 1290 <malloc+0x210>
     834:	798000ef          	jal	fcc <printf>
    exit(1);
     838:	4505                	li	a0,1
     83a:	37a000ef          	jal	bb4 <exit>
     83e:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     840:	36c000ef          	jal	bac <fork>
     844:	892a                	mv	s2,a0
  if(pid2 < 0){
     846:	02054063          	bltz	a0,866 <iter+0x84>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     84a:	e51d                	bnez	a0,878 <iter+0x96>
    rand_next ^= 7177;
     84c:	00001697          	auipc	a3,0x1
     850:	7b468693          	addi	a3,a3,1972 # 2000 <rand_next>
     854:	629c                	ld	a5,0(a3)
     856:	6709                	lui	a4,0x2
     858:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x719>
     85c:	8fb9                	xor	a5,a5,a4
     85e:	e29c                	sd	a5,0(a3)
    go(1);
     860:	4505                	li	a0,1
     862:	813ff0ef          	jal	74 <go>
    printf("grind: fork failed\n");
     866:	00001517          	auipc	a0,0x1
     86a:	a2a50513          	addi	a0,a0,-1494 # 1290 <malloc+0x210>
     86e:	75e000ef          	jal	fcc <printf>
    exit(1);
     872:	4505                	li	a0,1
     874:	340000ef          	jal	bb4 <exit>
    exit(0);
  }

  int st1 = -1;
     878:	57fd                	li	a5,-1
     87a:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     87e:	fdc40513          	addi	a0,s0,-36
     882:	33a000ef          	jal	bbc <wait>
  if(st1 != 0){
     886:	fdc42783          	lw	a5,-36(s0)
     88a:	eb99                	bnez	a5,8a0 <iter+0xbe>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     88c:	57fd                	li	a5,-1
     88e:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     892:	fd840513          	addi	a0,s0,-40
     896:	326000ef          	jal	bbc <wait>

  exit(0);
     89a:	4501                	li	a0,0
     89c:	318000ef          	jal	bb4 <exit>
    kill(pid1);
     8a0:	8526                	mv	a0,s1
     8a2:	342000ef          	jal	be4 <kill>
    kill(pid2);
     8a6:	854a                	mv	a0,s2
     8a8:	33c000ef          	jal	be4 <kill>
     8ac:	b7c5                	j	88c <iter+0xaa>

00000000000008ae <main>:
}

int
main()
{
     8ae:	1101                	addi	sp,sp,-32
     8b0:	ec06                	sd	ra,24(sp)
     8b2:	e822                	sd	s0,16(sp)
     8b4:	e426                	sd	s1,8(sp)
     8b6:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     8b8:	00001497          	auipc	s1,0x1
     8bc:	74848493          	addi	s1,s1,1864 # 2000 <rand_next>
     8c0:	a809                	j	8d2 <main+0x24>
      iter();
     8c2:	f21ff0ef          	jal	7e2 <iter>
    sleep(20);
     8c6:	4551                	li	a0,20
     8c8:	37c000ef          	jal	c44 <sleep>
    rand_next += 1;
     8cc:	609c                	ld	a5,0(s1)
     8ce:	0785                	addi	a5,a5,1
     8d0:	e09c                	sd	a5,0(s1)
    int pid = fork();
     8d2:	2da000ef          	jal	bac <fork>
    if(pid == 0){
     8d6:	d575                	beqz	a0,8c2 <main+0x14>
    if(pid > 0){
     8d8:	fea057e3          	blez	a0,8c6 <main+0x18>
      wait(0);
     8dc:	4501                	li	a0,0
     8de:	2de000ef          	jal	bbc <wait>
     8e2:	b7d5                	j	8c6 <main+0x18>

00000000000008e4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     8e4:	1141                	addi	sp,sp,-16
     8e6:	e406                	sd	ra,8(sp)
     8e8:	e022                	sd	s0,0(sp)
     8ea:	0800                	addi	s0,sp,16
  extern int main();
  main();
     8ec:	fc3ff0ef          	jal	8ae <main>
  exit(0);
     8f0:	4501                	li	a0,0
     8f2:	2c2000ef          	jal	bb4 <exit>

00000000000008f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     8f6:	1141                	addi	sp,sp,-16
     8f8:	e422                	sd	s0,8(sp)
     8fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     8fc:	87aa                	mv	a5,a0
     8fe:	0585                	addi	a1,a1,1
     900:	0785                	addi	a5,a5,1
     902:	fff5c703          	lbu	a4,-1(a1)
     906:	fee78fa3          	sb	a4,-1(a5)
     90a:	fb75                	bnez	a4,8fe <strcpy+0x8>
    ;
  return os;
}
     90c:	6422                	ld	s0,8(sp)
     90e:	0141                	addi	sp,sp,16
     910:	8082                	ret

0000000000000912 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     912:	1141                	addi	sp,sp,-16
     914:	e422                	sd	s0,8(sp)
     916:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     918:	00054783          	lbu	a5,0(a0)
     91c:	cb91                	beqz	a5,930 <strcmp+0x1e>
     91e:	0005c703          	lbu	a4,0(a1)
     922:	00f71763          	bne	a4,a5,930 <strcmp+0x1e>
    p++, q++;
     926:	0505                	addi	a0,a0,1
     928:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     92a:	00054783          	lbu	a5,0(a0)
     92e:	fbe5                	bnez	a5,91e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     930:	0005c503          	lbu	a0,0(a1)
}
     934:	40a7853b          	subw	a0,a5,a0
     938:	6422                	ld	s0,8(sp)
     93a:	0141                	addi	sp,sp,16
     93c:	8082                	ret

000000000000093e <strlen>:

uint
strlen(const char *s)
{
     93e:	1141                	addi	sp,sp,-16
     940:	e422                	sd	s0,8(sp)
     942:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     944:	00054783          	lbu	a5,0(a0)
     948:	cf91                	beqz	a5,964 <strlen+0x26>
     94a:	0505                	addi	a0,a0,1
     94c:	87aa                	mv	a5,a0
     94e:	86be                	mv	a3,a5
     950:	0785                	addi	a5,a5,1
     952:	fff7c703          	lbu	a4,-1(a5)
     956:	ff65                	bnez	a4,94e <strlen+0x10>
     958:	40a6853b          	subw	a0,a3,a0
     95c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     95e:	6422                	ld	s0,8(sp)
     960:	0141                	addi	sp,sp,16
     962:	8082                	ret
  for(n = 0; s[n]; n++)
     964:	4501                	li	a0,0
     966:	bfe5                	j	95e <strlen+0x20>

0000000000000968 <memset>:

void*
memset(void *dst, int c, uint n)
{
     968:	1141                	addi	sp,sp,-16
     96a:	e422                	sd	s0,8(sp)
     96c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     96e:	ca19                	beqz	a2,984 <memset+0x1c>
     970:	87aa                	mv	a5,a0
     972:	1602                	slli	a2,a2,0x20
     974:	9201                	srli	a2,a2,0x20
     976:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     97a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     97e:	0785                	addi	a5,a5,1
     980:	fee79de3          	bne	a5,a4,97a <memset+0x12>
  }
  return dst;
}
     984:	6422                	ld	s0,8(sp)
     986:	0141                	addi	sp,sp,16
     988:	8082                	ret

000000000000098a <strchr>:

char*
strchr(const char *s, char c)
{
     98a:	1141                	addi	sp,sp,-16
     98c:	e422                	sd	s0,8(sp)
     98e:	0800                	addi	s0,sp,16
  for(; *s; s++)
     990:	00054783          	lbu	a5,0(a0)
     994:	cb99                	beqz	a5,9aa <strchr+0x20>
    if(*s == c)
     996:	00f58763          	beq	a1,a5,9a4 <strchr+0x1a>
  for(; *s; s++)
     99a:	0505                	addi	a0,a0,1
     99c:	00054783          	lbu	a5,0(a0)
     9a0:	fbfd                	bnez	a5,996 <strchr+0xc>
      return (char*)s;
  return 0;
     9a2:	4501                	li	a0,0
}
     9a4:	6422                	ld	s0,8(sp)
     9a6:	0141                	addi	sp,sp,16
     9a8:	8082                	ret
  return 0;
     9aa:	4501                	li	a0,0
     9ac:	bfe5                	j	9a4 <strchr+0x1a>

00000000000009ae <gets>:

char*
gets(char *buf, int max)
{
     9ae:	711d                	addi	sp,sp,-96
     9b0:	ec86                	sd	ra,88(sp)
     9b2:	e8a2                	sd	s0,80(sp)
     9b4:	e4a6                	sd	s1,72(sp)
     9b6:	e0ca                	sd	s2,64(sp)
     9b8:	fc4e                	sd	s3,56(sp)
     9ba:	f852                	sd	s4,48(sp)
     9bc:	f456                	sd	s5,40(sp)
     9be:	f05a                	sd	s6,32(sp)
     9c0:	ec5e                	sd	s7,24(sp)
     9c2:	1080                	addi	s0,sp,96
     9c4:	8baa                	mv	s7,a0
     9c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9c8:	892a                	mv	s2,a0
     9ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     9cc:	4aa9                	li	s5,10
     9ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     9d0:	89a6                	mv	s3,s1
     9d2:	2485                	addiw	s1,s1,1
     9d4:	0344d663          	bge	s1,s4,a00 <gets+0x52>
    cc = read(0, &c, 1);
     9d8:	4605                	li	a2,1
     9da:	faf40593          	addi	a1,s0,-81
     9de:	4501                	li	a0,0
     9e0:	1ec000ef          	jal	bcc <read>
    if(cc < 1)
     9e4:	00a05e63          	blez	a0,a00 <gets+0x52>
    buf[i++] = c;
     9e8:	faf44783          	lbu	a5,-81(s0)
     9ec:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     9f0:	01578763          	beq	a5,s5,9fe <gets+0x50>
     9f4:	0905                	addi	s2,s2,1
     9f6:	fd679de3          	bne	a5,s6,9d0 <gets+0x22>
    buf[i++] = c;
     9fa:	89a6                	mv	s3,s1
     9fc:	a011                	j	a00 <gets+0x52>
     9fe:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a00:	99de                	add	s3,s3,s7
     a02:	00098023          	sb	zero,0(s3)
  return buf;
}
     a06:	855e                	mv	a0,s7
     a08:	60e6                	ld	ra,88(sp)
     a0a:	6446                	ld	s0,80(sp)
     a0c:	64a6                	ld	s1,72(sp)
     a0e:	6906                	ld	s2,64(sp)
     a10:	79e2                	ld	s3,56(sp)
     a12:	7a42                	ld	s4,48(sp)
     a14:	7aa2                	ld	s5,40(sp)
     a16:	7b02                	ld	s6,32(sp)
     a18:	6be2                	ld	s7,24(sp)
     a1a:	6125                	addi	sp,sp,96
     a1c:	8082                	ret

0000000000000a1e <stat>:

int
stat(const char *n, struct stat *st)
{
     a1e:	1101                	addi	sp,sp,-32
     a20:	ec06                	sd	ra,24(sp)
     a22:	e822                	sd	s0,16(sp)
     a24:	e04a                	sd	s2,0(sp)
     a26:	1000                	addi	s0,sp,32
     a28:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a2a:	4581                	li	a1,0
     a2c:	1c8000ef          	jal	bf4 <open>
  if(fd < 0)
     a30:	02054263          	bltz	a0,a54 <stat+0x36>
     a34:	e426                	sd	s1,8(sp)
     a36:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a38:	85ca                	mv	a1,s2
     a3a:	1d2000ef          	jal	c0c <fstat>
     a3e:	892a                	mv	s2,a0
  close(fd);
     a40:	8526                	mv	a0,s1
     a42:	19a000ef          	jal	bdc <close>
  return r;
     a46:	64a2                	ld	s1,8(sp)
}
     a48:	854a                	mv	a0,s2
     a4a:	60e2                	ld	ra,24(sp)
     a4c:	6442                	ld	s0,16(sp)
     a4e:	6902                	ld	s2,0(sp)
     a50:	6105                	addi	sp,sp,32
     a52:	8082                	ret
    return -1;
     a54:	597d                	li	s2,-1
     a56:	bfcd                	j	a48 <stat+0x2a>

0000000000000a58 <atoi>:

int
atoi(const char *s)
{
     a58:	1141                	addi	sp,sp,-16
     a5a:	e422                	sd	s0,8(sp)
     a5c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a5e:	00054683          	lbu	a3,0(a0)
     a62:	fd06879b          	addiw	a5,a3,-48
     a66:	0ff7f793          	zext.b	a5,a5
     a6a:	4625                	li	a2,9
     a6c:	02f66863          	bltu	a2,a5,a9c <atoi+0x44>
     a70:	872a                	mv	a4,a0
  n = 0;
     a72:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     a74:	0705                	addi	a4,a4,1
     a76:	0025179b          	slliw	a5,a0,0x2
     a7a:	9fa9                	addw	a5,a5,a0
     a7c:	0017979b          	slliw	a5,a5,0x1
     a80:	9fb5                	addw	a5,a5,a3
     a82:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a86:	00074683          	lbu	a3,0(a4)
     a8a:	fd06879b          	addiw	a5,a3,-48
     a8e:	0ff7f793          	zext.b	a5,a5
     a92:	fef671e3          	bgeu	a2,a5,a74 <atoi+0x1c>
  return n;
}
     a96:	6422                	ld	s0,8(sp)
     a98:	0141                	addi	sp,sp,16
     a9a:	8082                	ret
  n = 0;
     a9c:	4501                	li	a0,0
     a9e:	bfe5                	j	a96 <atoi+0x3e>

0000000000000aa0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     aa0:	1141                	addi	sp,sp,-16
     aa2:	e422                	sd	s0,8(sp)
     aa4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     aa6:	02b57463          	bgeu	a0,a1,ace <memmove+0x2e>
    while(n-- > 0)
     aaa:	00c05f63          	blez	a2,ac8 <memmove+0x28>
     aae:	1602                	slli	a2,a2,0x20
     ab0:	9201                	srli	a2,a2,0x20
     ab2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     ab6:	872a                	mv	a4,a0
      *dst++ = *src++;
     ab8:	0585                	addi	a1,a1,1
     aba:	0705                	addi	a4,a4,1
     abc:	fff5c683          	lbu	a3,-1(a1)
     ac0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     ac4:	fef71ae3          	bne	a4,a5,ab8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ac8:	6422                	ld	s0,8(sp)
     aca:	0141                	addi	sp,sp,16
     acc:	8082                	ret
    dst += n;
     ace:	00c50733          	add	a4,a0,a2
    src += n;
     ad2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     ad4:	fec05ae3          	blez	a2,ac8 <memmove+0x28>
     ad8:	fff6079b          	addiw	a5,a2,-1
     adc:	1782                	slli	a5,a5,0x20
     ade:	9381                	srli	a5,a5,0x20
     ae0:	fff7c793          	not	a5,a5
     ae4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     ae6:	15fd                	addi	a1,a1,-1
     ae8:	177d                	addi	a4,a4,-1
     aea:	0005c683          	lbu	a3,0(a1)
     aee:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     af2:	fee79ae3          	bne	a5,a4,ae6 <memmove+0x46>
     af6:	bfc9                	j	ac8 <memmove+0x28>

0000000000000af8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     af8:	1141                	addi	sp,sp,-16
     afa:	e422                	sd	s0,8(sp)
     afc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     afe:	ca05                	beqz	a2,b2e <memcmp+0x36>
     b00:	fff6069b          	addiw	a3,a2,-1
     b04:	1682                	slli	a3,a3,0x20
     b06:	9281                	srli	a3,a3,0x20
     b08:	0685                	addi	a3,a3,1
     b0a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b0c:	00054783          	lbu	a5,0(a0)
     b10:	0005c703          	lbu	a4,0(a1)
     b14:	00e79863          	bne	a5,a4,b24 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b18:	0505                	addi	a0,a0,1
    p2++;
     b1a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b1c:	fed518e3          	bne	a0,a3,b0c <memcmp+0x14>
  }
  return 0;
     b20:	4501                	li	a0,0
     b22:	a019                	j	b28 <memcmp+0x30>
      return *p1 - *p2;
     b24:	40e7853b          	subw	a0,a5,a4
}
     b28:	6422                	ld	s0,8(sp)
     b2a:	0141                	addi	sp,sp,16
     b2c:	8082                	ret
  return 0;
     b2e:	4501                	li	a0,0
     b30:	bfe5                	j	b28 <memcmp+0x30>

0000000000000b32 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b32:	1141                	addi	sp,sp,-16
     b34:	e406                	sd	ra,8(sp)
     b36:	e022                	sd	s0,0(sp)
     b38:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b3a:	f67ff0ef          	jal	aa0 <memmove>
}
     b3e:	60a2                	ld	ra,8(sp)
     b40:	6402                	ld	s0,0(sp)
     b42:	0141                	addi	sp,sp,16
     b44:	8082                	ret

0000000000000b46 <syscall>:

// Trap into kernel space for system calls
int syscall(int num, ...) {
     b46:	7175                	addi	sp,sp,-144
     b48:	e4a2                	sd	s0,72(sp)
     b4a:	0880                	addi	s0,sp,80
     b4c:	832a                	mv	t1,a0
     b4e:	e40c                	sd	a1,8(s0)
     b50:	e810                	sd	a2,16(s0)
     b52:	ec14                	sd	a3,24(s0)
     b54:	f018                	sd	a4,32(s0)
     b56:	f41c                	sd	a5,40(s0)
     b58:	03043823          	sd	a6,48(s0)
     b5c:	03143c23          	sd	a7,56(s0)
    uint64 args[6];
    va_list ap;
    int i;

    // Retrieve variable arguments passed to syscall
    va_start(ap, num);
     b60:	00840793          	addi	a5,s0,8
     b64:	faf43c23          	sd	a5,-72(s0)
    for (i = 0; i < 6; i++) {
     b68:	fc040793          	addi	a5,s0,-64
     b6c:	ff040613          	addi	a2,s0,-16
        args[i] = va_arg(ap, uint64);
     b70:	fb843703          	ld	a4,-72(s0)
     b74:	00870693          	addi	a3,a4,8
     b78:	fad43c23          	sd	a3,-72(s0)
     b7c:	6318                	ld	a4,0(a4)
     b7e:	e398                	sd	a4,0(a5)
    for (i = 0; i < 6; i++) {
     b80:	07a1                	addi	a5,a5,8
     b82:	fec797e3          	bne	a5,a2,b70 <syscall+0x2a>
    }
    va_end(ap);

    // Place the system call number in a7, arguments in a0-a5
    register uint64 a0 asm("a0") = args[0];
     b86:	fc043503          	ld	a0,-64(s0)
    register uint64 a1 asm("a1") = args[1];
     b8a:	fc843583          	ld	a1,-56(s0)
    register uint64 a2 asm("a2") = args[2];
     b8e:	fd043603          	ld	a2,-48(s0)
    register uint64 a3 asm("a3") = args[3];
     b92:	fd843683          	ld	a3,-40(s0)
    register uint64 a4 asm("a4") = args[4];
     b96:	fe043703          	ld	a4,-32(s0)
    register uint64 a5 asm("a5") = args[5];
     b9a:	fe843783          	ld	a5,-24(s0)
    register uint64 a7 asm("a7") = num;
     b9e:	889a                	mv	a7,t1

    // Perform the ecall (traps into kernel space)
    asm volatile("ecall"
     ba0:	00000073          	ecall
                 : "r"(a1), "r"(a2), "r"(a3), "r"(a4), "r"(a5), "r"(a7)
                 : "memory");

    // Return value is stored in a0 after the trap
    return a0;
     ba4:	2501                	sext.w	a0,a0
     ba6:	6426                	ld	s0,72(sp)
     ba8:	6149                	addi	sp,sp,144
     baa:	8082                	ret

0000000000000bac <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     bac:	4885                	li	a7,1
 ecall
     bae:	00000073          	ecall
 ret
     bb2:	8082                	ret

0000000000000bb4 <exit>:
.global exit
exit:
 li a7, SYS_exit
     bb4:	4889                	li	a7,2
 ecall
     bb6:	00000073          	ecall
 ret
     bba:	8082                	ret

0000000000000bbc <wait>:
.global wait
wait:
 li a7, SYS_wait
     bbc:	488d                	li	a7,3
 ecall
     bbe:	00000073          	ecall
 ret
     bc2:	8082                	ret

0000000000000bc4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     bc4:	4891                	li	a7,4
 ecall
     bc6:	00000073          	ecall
 ret
     bca:	8082                	ret

0000000000000bcc <read>:
.global read
read:
 li a7, SYS_read
     bcc:	4895                	li	a7,5
 ecall
     bce:	00000073          	ecall
 ret
     bd2:	8082                	ret

0000000000000bd4 <write>:
.global write
write:
 li a7, SYS_write
     bd4:	48c1                	li	a7,16
 ecall
     bd6:	00000073          	ecall
 ret
     bda:	8082                	ret

0000000000000bdc <close>:
.global close
close:
 li a7, SYS_close
     bdc:	48d5                	li	a7,21
 ecall
     bde:	00000073          	ecall
 ret
     be2:	8082                	ret

0000000000000be4 <kill>:
.global kill
kill:
 li a7, SYS_kill
     be4:	4899                	li	a7,6
 ecall
     be6:	00000073          	ecall
 ret
     bea:	8082                	ret

0000000000000bec <exec>:
.global exec
exec:
 li a7, SYS_exec
     bec:	489d                	li	a7,7
 ecall
     bee:	00000073          	ecall
 ret
     bf2:	8082                	ret

0000000000000bf4 <open>:
.global open
open:
 li a7, SYS_open
     bf4:	48bd                	li	a7,15
 ecall
     bf6:	00000073          	ecall
 ret
     bfa:	8082                	ret

0000000000000bfc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     bfc:	48c5                	li	a7,17
 ecall
     bfe:	00000073          	ecall
 ret
     c02:	8082                	ret

0000000000000c04 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c04:	48c9                	li	a7,18
 ecall
     c06:	00000073          	ecall
 ret
     c0a:	8082                	ret

0000000000000c0c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c0c:	48a1                	li	a7,8
 ecall
     c0e:	00000073          	ecall
 ret
     c12:	8082                	ret

0000000000000c14 <link>:
.global link
link:
 li a7, SYS_link
     c14:	48cd                	li	a7,19
 ecall
     c16:	00000073          	ecall
 ret
     c1a:	8082                	ret

0000000000000c1c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c1c:	48d1                	li	a7,20
 ecall
     c1e:	00000073          	ecall
 ret
     c22:	8082                	ret

0000000000000c24 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c24:	48a5                	li	a7,9
 ecall
     c26:	00000073          	ecall
 ret
     c2a:	8082                	ret

0000000000000c2c <dup>:
.global dup
dup:
 li a7, SYS_dup
     c2c:	48a9                	li	a7,10
 ecall
     c2e:	00000073          	ecall
 ret
     c32:	8082                	ret

0000000000000c34 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c34:	48ad                	li	a7,11
 ecall
     c36:	00000073          	ecall
 ret
     c3a:	8082                	ret

0000000000000c3c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c3c:	48b1                	li	a7,12
 ecall
     c3e:	00000073          	ecall
 ret
     c42:	8082                	ret

0000000000000c44 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c44:	48b5                	li	a7,13
 ecall
     c46:	00000073          	ecall
 ret
     c4a:	8082                	ret

0000000000000c4c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c4c:	48b9                	li	a7,14
 ecall
     c4e:	00000073          	ecall
 ret
     c52:	8082                	ret

0000000000000c54 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c54:	1101                	addi	sp,sp,-32
     c56:	ec06                	sd	ra,24(sp)
     c58:	e822                	sd	s0,16(sp)
     c5a:	1000                	addi	s0,sp,32
     c5c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c60:	4605                	li	a2,1
     c62:	fef40593          	addi	a1,s0,-17
     c66:	f6fff0ef          	jal	bd4 <write>
}
     c6a:	60e2                	ld	ra,24(sp)
     c6c:	6442                	ld	s0,16(sp)
     c6e:	6105                	addi	sp,sp,32
     c70:	8082                	ret

0000000000000c72 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c72:	7139                	addi	sp,sp,-64
     c74:	fc06                	sd	ra,56(sp)
     c76:	f822                	sd	s0,48(sp)
     c78:	f426                	sd	s1,40(sp)
     c7a:	0080                	addi	s0,sp,64
     c7c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c7e:	c299                	beqz	a3,c84 <printint+0x12>
     c80:	0805c963          	bltz	a1,d12 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c84:	2581                	sext.w	a1,a1
  neg = 0;
     c86:	4881                	li	a7,0
     c88:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     c8c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c8e:	2601                	sext.w	a2,a2
     c90:	00001517          	auipc	a0,0x1
     c94:	86050513          	addi	a0,a0,-1952 # 14f0 <digits>
     c98:	883a                	mv	a6,a4
     c9a:	2705                	addiw	a4,a4,1
     c9c:	02c5f7bb          	remuw	a5,a1,a2
     ca0:	1782                	slli	a5,a5,0x20
     ca2:	9381                	srli	a5,a5,0x20
     ca4:	97aa                	add	a5,a5,a0
     ca6:	0007c783          	lbu	a5,0(a5)
     caa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     cae:	0005879b          	sext.w	a5,a1
     cb2:	02c5d5bb          	divuw	a1,a1,a2
     cb6:	0685                	addi	a3,a3,1
     cb8:	fec7f0e3          	bgeu	a5,a2,c98 <printint+0x26>
  if(neg)
     cbc:	00088c63          	beqz	a7,cd4 <printint+0x62>
    buf[i++] = '-';
     cc0:	fd070793          	addi	a5,a4,-48
     cc4:	00878733          	add	a4,a5,s0
     cc8:	02d00793          	li	a5,45
     ccc:	fef70823          	sb	a5,-16(a4)
     cd0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     cd4:	02e05a63          	blez	a4,d08 <printint+0x96>
     cd8:	f04a                	sd	s2,32(sp)
     cda:	ec4e                	sd	s3,24(sp)
     cdc:	fc040793          	addi	a5,s0,-64
     ce0:	00e78933          	add	s2,a5,a4
     ce4:	fff78993          	addi	s3,a5,-1
     ce8:	99ba                	add	s3,s3,a4
     cea:	377d                	addiw	a4,a4,-1
     cec:	1702                	slli	a4,a4,0x20
     cee:	9301                	srli	a4,a4,0x20
     cf0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     cf4:	fff94583          	lbu	a1,-1(s2)
     cf8:	8526                	mv	a0,s1
     cfa:	f5bff0ef          	jal	c54 <putc>
  while(--i >= 0)
     cfe:	197d                	addi	s2,s2,-1
     d00:	ff391ae3          	bne	s2,s3,cf4 <printint+0x82>
     d04:	7902                	ld	s2,32(sp)
     d06:	69e2                	ld	s3,24(sp)
}
     d08:	70e2                	ld	ra,56(sp)
     d0a:	7442                	ld	s0,48(sp)
     d0c:	74a2                	ld	s1,40(sp)
     d0e:	6121                	addi	sp,sp,64
     d10:	8082                	ret
    x = -xx;
     d12:	40b005bb          	negw	a1,a1
    neg = 1;
     d16:	4885                	li	a7,1
    x = -xx;
     d18:	bf85                	j	c88 <printint+0x16>

0000000000000d1a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d1a:	711d                	addi	sp,sp,-96
     d1c:	ec86                	sd	ra,88(sp)
     d1e:	e8a2                	sd	s0,80(sp)
     d20:	e0ca                	sd	s2,64(sp)
     d22:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d24:	0005c903          	lbu	s2,0(a1)
     d28:	26090863          	beqz	s2,f98 <vprintf+0x27e>
     d2c:	e4a6                	sd	s1,72(sp)
     d2e:	fc4e                	sd	s3,56(sp)
     d30:	f852                	sd	s4,48(sp)
     d32:	f456                	sd	s5,40(sp)
     d34:	f05a                	sd	s6,32(sp)
     d36:	ec5e                	sd	s7,24(sp)
     d38:	e862                	sd	s8,16(sp)
     d3a:	e466                	sd	s9,8(sp)
     d3c:	8b2a                	mv	s6,a0
     d3e:	8a2e                	mv	s4,a1
     d40:	8bb2                	mv	s7,a2
  state = 0;
     d42:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     d44:	4481                	li	s1,0
     d46:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     d48:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     d4c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     d50:	06c00c93          	li	s9,108
     d54:	a005                	j	d74 <vprintf+0x5a>
        putc(fd, c0);
     d56:	85ca                	mv	a1,s2
     d58:	855a                	mv	a0,s6
     d5a:	efbff0ef          	jal	c54 <putc>
     d5e:	a019                	j	d64 <vprintf+0x4a>
    } else if(state == '%'){
     d60:	03598263          	beq	s3,s5,d84 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     d64:	2485                	addiw	s1,s1,1
     d66:	8726                	mv	a4,s1
     d68:	009a07b3          	add	a5,s4,s1
     d6c:	0007c903          	lbu	s2,0(a5)
     d70:	20090c63          	beqz	s2,f88 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
     d74:	0009079b          	sext.w	a5,s2
    if(state == 0){
     d78:	fe0994e3          	bnez	s3,d60 <vprintf+0x46>
      if(c0 == '%'){
     d7c:	fd579de3          	bne	a5,s5,d56 <vprintf+0x3c>
        state = '%';
     d80:	89be                	mv	s3,a5
     d82:	b7cd                	j	d64 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     d84:	00ea06b3          	add	a3,s4,a4
     d88:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     d8c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     d8e:	c681                	beqz	a3,d96 <vprintf+0x7c>
     d90:	9752                	add	a4,a4,s4
     d92:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     d96:	03878f63          	beq	a5,s8,dd4 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
     d9a:	05978963          	beq	a5,s9,dec <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     d9e:	07500713          	li	a4,117
     da2:	0ee78363          	beq	a5,a4,e88 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     da6:	07800713          	li	a4,120
     daa:	12e78563          	beq	a5,a4,ed4 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     dae:	07000713          	li	a4,112
     db2:	14e78a63          	beq	a5,a4,f06 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     db6:	07300713          	li	a4,115
     dba:	18e78a63          	beq	a5,a4,f4e <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     dbe:	02500713          	li	a4,37
     dc2:	04e79563          	bne	a5,a4,e0c <vprintf+0xf2>
        putc(fd, '%');
     dc6:	02500593          	li	a1,37
     dca:	855a                	mv	a0,s6
     dcc:	e89ff0ef          	jal	c54 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     dd0:	4981                	li	s3,0
     dd2:	bf49                	j	d64 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     dd4:	008b8913          	addi	s2,s7,8
     dd8:	4685                	li	a3,1
     dda:	4629                	li	a2,10
     ddc:	000ba583          	lw	a1,0(s7)
     de0:	855a                	mv	a0,s6
     de2:	e91ff0ef          	jal	c72 <printint>
     de6:	8bca                	mv	s7,s2
      state = 0;
     de8:	4981                	li	s3,0
     dea:	bfad                	j	d64 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     dec:	06400793          	li	a5,100
     df0:	02f68963          	beq	a3,a5,e22 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     df4:	06c00793          	li	a5,108
     df8:	04f68263          	beq	a3,a5,e3c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
     dfc:	07500793          	li	a5,117
     e00:	0af68063          	beq	a3,a5,ea0 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
     e04:	07800793          	li	a5,120
     e08:	0ef68263          	beq	a3,a5,eec <vprintf+0x1d2>
        putc(fd, '%');
     e0c:	02500593          	li	a1,37
     e10:	855a                	mv	a0,s6
     e12:	e43ff0ef          	jal	c54 <putc>
        putc(fd, c0);
     e16:	85ca                	mv	a1,s2
     e18:	855a                	mv	a0,s6
     e1a:	e3bff0ef          	jal	c54 <putc>
      state = 0;
     e1e:	4981                	li	s3,0
     e20:	b791                	j	d64 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e22:	008b8913          	addi	s2,s7,8
     e26:	4685                	li	a3,1
     e28:	4629                	li	a2,10
     e2a:	000ba583          	lw	a1,0(s7)
     e2e:	855a                	mv	a0,s6
     e30:	e43ff0ef          	jal	c72 <printint>
        i += 1;
     e34:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e36:	8bca                	mv	s7,s2
      state = 0;
     e38:	4981                	li	s3,0
        i += 1;
     e3a:	b72d                	j	d64 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e3c:	06400793          	li	a5,100
     e40:	02f60763          	beq	a2,a5,e6e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e44:	07500793          	li	a5,117
     e48:	06f60963          	beq	a2,a5,eba <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     e4c:	07800793          	li	a5,120
     e50:	faf61ee3          	bne	a2,a5,e0c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e54:	008b8913          	addi	s2,s7,8
     e58:	4681                	li	a3,0
     e5a:	4641                	li	a2,16
     e5c:	000ba583          	lw	a1,0(s7)
     e60:	855a                	mv	a0,s6
     e62:	e11ff0ef          	jal	c72 <printint>
        i += 2;
     e66:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     e68:	8bca                	mv	s7,s2
      state = 0;
     e6a:	4981                	li	s3,0
        i += 2;
     e6c:	bde5                	j	d64 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e6e:	008b8913          	addi	s2,s7,8
     e72:	4685                	li	a3,1
     e74:	4629                	li	a2,10
     e76:	000ba583          	lw	a1,0(s7)
     e7a:	855a                	mv	a0,s6
     e7c:	df7ff0ef          	jal	c72 <printint>
        i += 2;
     e80:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     e82:	8bca                	mv	s7,s2
      state = 0;
     e84:	4981                	li	s3,0
        i += 2;
     e86:	bdf9                	j	d64 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
     e88:	008b8913          	addi	s2,s7,8
     e8c:	4681                	li	a3,0
     e8e:	4629                	li	a2,10
     e90:	000ba583          	lw	a1,0(s7)
     e94:	855a                	mv	a0,s6
     e96:	dddff0ef          	jal	c72 <printint>
     e9a:	8bca                	mv	s7,s2
      state = 0;
     e9c:	4981                	li	s3,0
     e9e:	b5d9                	j	d64 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     ea0:	008b8913          	addi	s2,s7,8
     ea4:	4681                	li	a3,0
     ea6:	4629                	li	a2,10
     ea8:	000ba583          	lw	a1,0(s7)
     eac:	855a                	mv	a0,s6
     eae:	dc5ff0ef          	jal	c72 <printint>
        i += 1;
     eb2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     eb4:	8bca                	mv	s7,s2
      state = 0;
     eb6:	4981                	li	s3,0
        i += 1;
     eb8:	b575                	j	d64 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     eba:	008b8913          	addi	s2,s7,8
     ebe:	4681                	li	a3,0
     ec0:	4629                	li	a2,10
     ec2:	000ba583          	lw	a1,0(s7)
     ec6:	855a                	mv	a0,s6
     ec8:	dabff0ef          	jal	c72 <printint>
        i += 2;
     ecc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     ece:	8bca                	mv	s7,s2
      state = 0;
     ed0:	4981                	li	s3,0
        i += 2;
     ed2:	bd49                	j	d64 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
     ed4:	008b8913          	addi	s2,s7,8
     ed8:	4681                	li	a3,0
     eda:	4641                	li	a2,16
     edc:	000ba583          	lw	a1,0(s7)
     ee0:	855a                	mv	a0,s6
     ee2:	d91ff0ef          	jal	c72 <printint>
     ee6:	8bca                	mv	s7,s2
      state = 0;
     ee8:	4981                	li	s3,0
     eea:	bdad                	j	d64 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     eec:	008b8913          	addi	s2,s7,8
     ef0:	4681                	li	a3,0
     ef2:	4641                	li	a2,16
     ef4:	000ba583          	lw	a1,0(s7)
     ef8:	855a                	mv	a0,s6
     efa:	d79ff0ef          	jal	c72 <printint>
        i += 1;
     efe:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f00:	8bca                	mv	s7,s2
      state = 0;
     f02:	4981                	li	s3,0
        i += 1;
     f04:	b585                	j	d64 <vprintf+0x4a>
     f06:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     f08:	008b8d13          	addi	s10,s7,8
     f0c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f10:	03000593          	li	a1,48
     f14:	855a                	mv	a0,s6
     f16:	d3fff0ef          	jal	c54 <putc>
  putc(fd, 'x');
     f1a:	07800593          	li	a1,120
     f1e:	855a                	mv	a0,s6
     f20:	d35ff0ef          	jal	c54 <putc>
     f24:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f26:	00000b97          	auipc	s7,0x0
     f2a:	5cab8b93          	addi	s7,s7,1482 # 14f0 <digits>
     f2e:	03c9d793          	srli	a5,s3,0x3c
     f32:	97de                	add	a5,a5,s7
     f34:	0007c583          	lbu	a1,0(a5)
     f38:	855a                	mv	a0,s6
     f3a:	d1bff0ef          	jal	c54 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f3e:	0992                	slli	s3,s3,0x4
     f40:	397d                	addiw	s2,s2,-1
     f42:	fe0916e3          	bnez	s2,f2e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
     f46:	8bea                	mv	s7,s10
      state = 0;
     f48:	4981                	li	s3,0
     f4a:	6d02                	ld	s10,0(sp)
     f4c:	bd21                	j	d64 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
     f4e:	008b8993          	addi	s3,s7,8
     f52:	000bb903          	ld	s2,0(s7)
     f56:	00090f63          	beqz	s2,f74 <vprintf+0x25a>
        for(; *s; s++)
     f5a:	00094583          	lbu	a1,0(s2)
     f5e:	c195                	beqz	a1,f82 <vprintf+0x268>
          putc(fd, *s);
     f60:	855a                	mv	a0,s6
     f62:	cf3ff0ef          	jal	c54 <putc>
        for(; *s; s++)
     f66:	0905                	addi	s2,s2,1
     f68:	00094583          	lbu	a1,0(s2)
     f6c:	f9f5                	bnez	a1,f60 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
     f6e:	8bce                	mv	s7,s3
      state = 0;
     f70:	4981                	li	s3,0
     f72:	bbcd                	j	d64 <vprintf+0x4a>
          s = "(null)";
     f74:	00000917          	auipc	s2,0x0
     f78:	51490913          	addi	s2,s2,1300 # 1488 <malloc+0x408>
        for(; *s; s++)
     f7c:	02800593          	li	a1,40
     f80:	b7c5                	j	f60 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
     f82:	8bce                	mv	s7,s3
      state = 0;
     f84:	4981                	li	s3,0
     f86:	bbf9                	j	d64 <vprintf+0x4a>
     f88:	64a6                	ld	s1,72(sp)
     f8a:	79e2                	ld	s3,56(sp)
     f8c:	7a42                	ld	s4,48(sp)
     f8e:	7aa2                	ld	s5,40(sp)
     f90:	7b02                	ld	s6,32(sp)
     f92:	6be2                	ld	s7,24(sp)
     f94:	6c42                	ld	s8,16(sp)
     f96:	6ca2                	ld	s9,8(sp)
    }
  }
}
     f98:	60e6                	ld	ra,88(sp)
     f9a:	6446                	ld	s0,80(sp)
     f9c:	6906                	ld	s2,64(sp)
     f9e:	6125                	addi	sp,sp,96
     fa0:	8082                	ret

0000000000000fa2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     fa2:	715d                	addi	sp,sp,-80
     fa4:	ec06                	sd	ra,24(sp)
     fa6:	e822                	sd	s0,16(sp)
     fa8:	1000                	addi	s0,sp,32
     faa:	e010                	sd	a2,0(s0)
     fac:	e414                	sd	a3,8(s0)
     fae:	e818                	sd	a4,16(s0)
     fb0:	ec1c                	sd	a5,24(s0)
     fb2:	03043023          	sd	a6,32(s0)
     fb6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     fba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     fbe:	8622                	mv	a2,s0
     fc0:	d5bff0ef          	jal	d1a <vprintf>
}
     fc4:	60e2                	ld	ra,24(sp)
     fc6:	6442                	ld	s0,16(sp)
     fc8:	6161                	addi	sp,sp,80
     fca:	8082                	ret

0000000000000fcc <printf>:

void
printf(const char *fmt, ...)
{
     fcc:	711d                	addi	sp,sp,-96
     fce:	ec06                	sd	ra,24(sp)
     fd0:	e822                	sd	s0,16(sp)
     fd2:	1000                	addi	s0,sp,32
     fd4:	e40c                	sd	a1,8(s0)
     fd6:	e810                	sd	a2,16(s0)
     fd8:	ec14                	sd	a3,24(s0)
     fda:	f018                	sd	a4,32(s0)
     fdc:	f41c                	sd	a5,40(s0)
     fde:	03043823          	sd	a6,48(s0)
     fe2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     fe6:	00840613          	addi	a2,s0,8
     fea:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     fee:	85aa                	mv	a1,a0
     ff0:	4505                	li	a0,1
     ff2:	d29ff0ef          	jal	d1a <vprintf>
}
     ff6:	60e2                	ld	ra,24(sp)
     ff8:	6442                	ld	s0,16(sp)
     ffa:	6125                	addi	sp,sp,96
     ffc:	8082                	ret

0000000000000ffe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     ffe:	1141                	addi	sp,sp,-16
    1000:	e422                	sd	s0,8(sp)
    1002:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1004:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1008:	00001797          	auipc	a5,0x1
    100c:	0087b783          	ld	a5,8(a5) # 2010 <freep>
    1010:	a02d                	j	103a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1012:	4618                	lw	a4,8(a2)
    1014:	9f2d                	addw	a4,a4,a1
    1016:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    101a:	6398                	ld	a4,0(a5)
    101c:	6310                	ld	a2,0(a4)
    101e:	a83d                	j	105c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1020:	ff852703          	lw	a4,-8(a0)
    1024:	9f31                	addw	a4,a4,a2
    1026:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1028:	ff053683          	ld	a3,-16(a0)
    102c:	a091                	j	1070 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    102e:	6398                	ld	a4,0(a5)
    1030:	00e7e463          	bltu	a5,a4,1038 <free+0x3a>
    1034:	00e6ea63          	bltu	a3,a4,1048 <free+0x4a>
{
    1038:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    103a:	fed7fae3          	bgeu	a5,a3,102e <free+0x30>
    103e:	6398                	ld	a4,0(a5)
    1040:	00e6e463          	bltu	a3,a4,1048 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1044:	fee7eae3          	bltu	a5,a4,1038 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1048:	ff852583          	lw	a1,-8(a0)
    104c:	6390                	ld	a2,0(a5)
    104e:	02059813          	slli	a6,a1,0x20
    1052:	01c85713          	srli	a4,a6,0x1c
    1056:	9736                	add	a4,a4,a3
    1058:	fae60de3          	beq	a2,a4,1012 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    105c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1060:	4790                	lw	a2,8(a5)
    1062:	02061593          	slli	a1,a2,0x20
    1066:	01c5d713          	srli	a4,a1,0x1c
    106a:	973e                	add	a4,a4,a5
    106c:	fae68ae3          	beq	a3,a4,1020 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1070:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1072:	00001717          	auipc	a4,0x1
    1076:	f8f73f23          	sd	a5,-98(a4) # 2010 <freep>
}
    107a:	6422                	ld	s0,8(sp)
    107c:	0141                	addi	sp,sp,16
    107e:	8082                	ret

0000000000001080 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1080:	7139                	addi	sp,sp,-64
    1082:	fc06                	sd	ra,56(sp)
    1084:	f822                	sd	s0,48(sp)
    1086:	f426                	sd	s1,40(sp)
    1088:	ec4e                	sd	s3,24(sp)
    108a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    108c:	02051493          	slli	s1,a0,0x20
    1090:	9081                	srli	s1,s1,0x20
    1092:	04bd                	addi	s1,s1,15
    1094:	8091                	srli	s1,s1,0x4
    1096:	0014899b          	addiw	s3,s1,1
    109a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    109c:	00001517          	auipc	a0,0x1
    10a0:	f7453503          	ld	a0,-140(a0) # 2010 <freep>
    10a4:	c915                	beqz	a0,10d8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10a8:	4798                	lw	a4,8(a5)
    10aa:	08977a63          	bgeu	a4,s1,113e <malloc+0xbe>
    10ae:	f04a                	sd	s2,32(sp)
    10b0:	e852                	sd	s4,16(sp)
    10b2:	e456                	sd	s5,8(sp)
    10b4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    10b6:	8a4e                	mv	s4,s3
    10b8:	0009871b          	sext.w	a4,s3
    10bc:	6685                	lui	a3,0x1
    10be:	00d77363          	bgeu	a4,a3,10c4 <malloc+0x44>
    10c2:	6a05                	lui	s4,0x1
    10c4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    10c8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    10cc:	00001917          	auipc	s2,0x1
    10d0:	f4490913          	addi	s2,s2,-188 # 2010 <freep>
  if(p == (char*)-1)
    10d4:	5afd                	li	s5,-1
    10d6:	a081                	j	1116 <malloc+0x96>
    10d8:	f04a                	sd	s2,32(sp)
    10da:	e852                	sd	s4,16(sp)
    10dc:	e456                	sd	s5,8(sp)
    10de:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    10e0:	00001797          	auipc	a5,0x1
    10e4:	32878793          	addi	a5,a5,808 # 2408 <base>
    10e8:	00001717          	auipc	a4,0x1
    10ec:	f2f73423          	sd	a5,-216(a4) # 2010 <freep>
    10f0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    10f2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    10f6:	b7c1                	j	10b6 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    10f8:	6398                	ld	a4,0(a5)
    10fa:	e118                	sd	a4,0(a0)
    10fc:	a8a9                	j	1156 <malloc+0xd6>
  hp->s.size = nu;
    10fe:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1102:	0541                	addi	a0,a0,16
    1104:	efbff0ef          	jal	ffe <free>
  return freep;
    1108:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    110c:	c12d                	beqz	a0,116e <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    110e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1110:	4798                	lw	a4,8(a5)
    1112:	02977263          	bgeu	a4,s1,1136 <malloc+0xb6>
    if(p == freep)
    1116:	00093703          	ld	a4,0(s2)
    111a:	853e                	mv	a0,a5
    111c:	fef719e3          	bne	a4,a5,110e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    1120:	8552                	mv	a0,s4
    1122:	b1bff0ef          	jal	c3c <sbrk>
  if(p == (char*)-1)
    1126:	fd551ce3          	bne	a0,s5,10fe <malloc+0x7e>
        return 0;
    112a:	4501                	li	a0,0
    112c:	7902                	ld	s2,32(sp)
    112e:	6a42                	ld	s4,16(sp)
    1130:	6aa2                	ld	s5,8(sp)
    1132:	6b02                	ld	s6,0(sp)
    1134:	a03d                	j	1162 <malloc+0xe2>
    1136:	7902                	ld	s2,32(sp)
    1138:	6a42                	ld	s4,16(sp)
    113a:	6aa2                	ld	s5,8(sp)
    113c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    113e:	fae48de3          	beq	s1,a4,10f8 <malloc+0x78>
        p->s.size -= nunits;
    1142:	4137073b          	subw	a4,a4,s3
    1146:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1148:	02071693          	slli	a3,a4,0x20
    114c:	01c6d713          	srli	a4,a3,0x1c
    1150:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1152:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1156:	00001717          	auipc	a4,0x1
    115a:	eaa73d23          	sd	a0,-326(a4) # 2010 <freep>
      return (void*)(p + 1);
    115e:	01078513          	addi	a0,a5,16
  }
}
    1162:	70e2                	ld	ra,56(sp)
    1164:	7442                	ld	s0,48(sp)
    1166:	74a2                	ld	s1,40(sp)
    1168:	69e2                	ld	s3,24(sp)
    116a:	6121                	addi	sp,sp,64
    116c:	8082                	ret
    116e:	7902                	ld	s2,32(sp)
    1170:	6a42                	ld	s4,16(sp)
    1172:	6aa2                	ld	s5,8(sp)
    1174:	6b02                	ld	s6,0(sp)
    1176:	b7f5                	j	1162 <malloc+0xe2>
