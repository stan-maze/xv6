
user/_PrimeNumCount:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <initlist>:
#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"

void initlist(int end){
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
    int i;
    for(i=2; i<end; i++){
   c:	4789                	li	a5,2
   e:	fcf42e23          	sw	a5,-36(s0)
  12:	4789                	li	a5,2
  14:	02a7d363          	bge	a5,a0,3a <initlist+0x3a>
        // 写入地址后int长度，这就是变量在内存中的表示
        // 避免了局部变量删除的问题
        write(1, &i, sizeof(int));
  18:	4611                	li	a2,4
  1a:	fdc40593          	addi	a1,s0,-36
  1e:	4505                	li	a0,1
  20:	00000097          	auipc	ra,0x0
  24:	44a080e7          	jalr	1098(ra) # 46a <write>
    for(i=2; i<end; i++){
  28:	fdc42783          	lw	a5,-36(s0)
  2c:	2785                	addiw	a5,a5,1
  2e:	0007871b          	sext.w	a4,a5
  32:	fcf42e23          	sw	a5,-36(s0)
  36:	fe9741e3          	blt	a4,s1,18 <initlist+0x18>
    }
}
  3a:	70a2                	ld	ra,40(sp)
  3c:	7402                	ld	s0,32(sp)
  3e:	64e2                	ld	s1,24(sp)
  40:	6145                	addi	sp,sp,48
  42:	8082                	ret

0000000000000044 <Eratosthenes>:
// 基于埃氏筛
void Eratosthenes(int p){
  44:	7179                	addi	sp,sp,-48
  46:	f406                	sd	ra,40(sp)
  48:	f022                	sd	s0,32(sp)
  4a:	ec26                	sd	s1,24(sp)
  4c:	1800                	addi	s0,sp,48
  4e:	84aa                	mv	s1,a0
    int n;
    // 很像队列结构
    while (read(0, &n, sizeof(int)))
  50:	4611                	li	a2,4
  52:	fdc40593          	addi	a1,s0,-36
  56:	4501                	li	a0,0
  58:	00000097          	auipc	ra,0x0
  5c:	40a080e7          	jalr	1034(ra) # 462 <read>
  60:	cd19                	beqz	a0,7e <Eratosthenes+0x3a>
    {
        if(n % p != 0){
  62:	fdc42783          	lw	a5,-36(s0)
  66:	0297e7bb          	remw	a5,a5,s1
  6a:	d3fd                	beqz	a5,50 <Eratosthenes+0xc>
            // 通过第一个数筛，不被整除的有资格进入下一轮筛
            // 而其中第一个必是素数
            write(1, &n, sizeof(int));
  6c:	4611                	li	a2,4
  6e:	fdc40593          	addi	a1,s0,-36
  72:	4505                	li	a0,1
  74:	00000097          	auipc	ra,0x0
  78:	3f6080e7          	jalr	1014(ra) # 46a <write>
  7c:	bfd1                	j	50 <Eratosthenes+0xc>
        }
    }
}
  7e:	70a2                	ld	ra,40(sp)
  80:	7402                	ld	s0,32(sp)
  82:	64e2                	ld	s1,24(sp)
  84:	6145                	addi	sp,sp,48
  86:	8082                	ret

0000000000000088 <redirect>:
void redirect(int k, int pd[]){
  88:	1101                	addi	sp,sp,-32
  8a:	ec06                	sd	ra,24(sp)
  8c:	e822                	sd	s0,16(sp)
  8e:	e426                	sd	s1,8(sp)
  90:	e04a                	sd	s2,0(sp)
  92:	1000                	addi	s0,sp,32
  94:	84aa                	mv	s1,a0
  96:	892e                	mv	s2,a1
    // 由于每次筛都需要一个新的队列，而标准输入输出是公共的
    // 所以需要将标准输入输出重定向到每个进程（和子进程）独自的管道中
    close(k);
  98:	00000097          	auipc	ra,0x0
  9c:	3da080e7          	jalr	986(ra) # 472 <close>
    dup(pd[k]);
  a0:	048a                	slli	s1,s1,0x2
  a2:	94ca                	add	s1,s1,s2
  a4:	4088                	lw	a0,0(s1)
  a6:	00000097          	auipc	ra,0x0
  aa:	41c080e7          	jalr	1052(ra) # 4c2 <dup>
    // 保证管道是关闭的，避免循环等待
    close(pd[0]);
  ae:	00092503          	lw	a0,0(s2)
  b2:	00000097          	auipc	ra,0x0
  b6:	3c0080e7          	jalr	960(ra) # 472 <close>
    close(pd[1]);
  ba:	00492503          	lw	a0,4(s2)
  be:	00000097          	auipc	ra,0x0
  c2:	3b4080e7          	jalr	948(ra) # 472 <close>
}
  c6:	60e2                	ld	ra,24(sp)
  c8:	6442                	ld	s0,16(sp)
  ca:	64a2                	ld	s1,8(sp)
  cc:	6902                	ld	s2,0(sp)
  ce:	6105                	addi	sp,sp,32
  d0:	8082                	ret

00000000000000d2 <sink>:
void sink(){
  d2:	1101                	addi	sp,sp,-32
  d4:	ec06                	sd	ra,24(sp)
  d6:	e822                	sd	s0,16(sp)
  d8:	1000                	addi	s0,sp,32
    // 一次筛出一个数，也就是取出数列首项
    int pd[2];
    int start;
    if(read(0, &start, sizeof(int))){
  da:	4611                	li	a2,4
  dc:	fe440593          	addi	a1,s0,-28
  e0:	4501                	li	a0,0
  e2:	00000097          	auipc	ra,0x0
  e6:	380080e7          	jalr	896(ra) # 462 <read>
  ea:	e509                	bnez	a0,f4 <sink+0x22>
            redirect(1, pd);
            // 埃氏筛算法把筛好的数据写入pd[1]
            Eratosthenes(start);
        }
    }
}
  ec:	60e2                	ld	ra,24(sp)
  ee:	6442                	ld	s0,16(sp)
  f0:	6105                	addi	sp,sp,32
  f2:	8082                	ret
        printf("prime:%d\n", start);
  f4:	fe442583          	lw	a1,-28(s0)
  f8:	00001517          	auipc	a0,0x1
  fc:	88050513          	addi	a0,a0,-1920 # 978 <malloc+0xe8>
 100:	00000097          	auipc	ra,0x0
 104:	6d2080e7          	jalr	1746(ra) # 7d2 <printf>
        pipe(pd);
 108:	fe840513          	addi	a0,s0,-24
 10c:	00000097          	auipc	ra,0x0
 110:	34e080e7          	jalr	846(ra) # 45a <pipe>
        if(fork()){
 114:	00000097          	auipc	ra,0x0
 118:	32e080e7          	jalr	814(ra) # 442 <fork>
 11c:	cd09                	beqz	a0,136 <sink+0x64>
            redirect(0, pd);
 11e:	fe840593          	addi	a1,s0,-24
 122:	4501                	li	a0,0
 124:	00000097          	auipc	ra,0x0
 128:	f64080e7          	jalr	-156(ra) # 88 <redirect>
            sink();
 12c:	00000097          	auipc	ra,0x0
 130:	fa6080e7          	jalr	-90(ra) # d2 <sink>
 134:	bf65                	j	ec <sink+0x1a>
            redirect(1, pd);
 136:	fe840593          	addi	a1,s0,-24
 13a:	4505                	li	a0,1
 13c:	00000097          	auipc	ra,0x0
 140:	f4c080e7          	jalr	-180(ra) # 88 <redirect>
            Eratosthenes(start);
 144:	fe442503          	lw	a0,-28(s0)
 148:	00000097          	auipc	ra,0x0
 14c:	efc080e7          	jalr	-260(ra) # 44 <Eratosthenes>
}
 150:	bf71                	j	ec <sink+0x1a>

0000000000000152 <main>:
int main(int argc, char* argv[]){
 152:	7179                	addi	sp,sp,-48
 154:	f406                	sd	ra,40(sp)
 156:	f022                	sd	s0,32(sp)
 158:	ec26                	sd	s1,24(sp)
 15a:	1800                	addi	s0,sp,48
    // main先跑一次和sink几乎完全一样的过程
    int end = 2;
    if(argc>2){
 15c:	4789                	li	a5,2
 15e:	04a7d763          	bge	a5,a0,1ac <main+0x5a>
        printf("wrong input\n");
 162:	00001517          	auipc	a0,0x1
 166:	82650513          	addi	a0,a0,-2010 # 988 <malloc+0xf8>
 16a:	00000097          	auipc	ra,0x0
 16e:	668080e7          	jalr	1640(ra) # 7d2 <printf>
    int end = 2;
 172:	4489                	li	s1,2
    }else{
        end = atoi(argv[1]);
    }
    int pd[2];
    pipe(pd);
 174:	fd840513          	addi	a0,s0,-40
 178:	00000097          	auipc	ra,0x0
 17c:	2e2080e7          	jalr	738(ra) # 45a <pipe>
    if (fork()>0) {
 180:	00000097          	auipc	ra,0x0
 184:	2c2080e7          	jalr	706(ra) # 442 <fork>
 188:	02a05963          	blez	a0,1ba <main+0x68>
    redirect(0, pd);
 18c:	fd840593          	addi	a1,s0,-40
 190:	4501                	li	a0,0
 192:	00000097          	auipc	ra,0x0
 196:	ef6080e7          	jalr	-266(ra) # 88 <redirect>
    sink();
 19a:	00000097          	auipc	ra,0x0
 19e:	f38080e7          	jalr	-200(ra) # d2 <sink>
    } else {
    redirect(1, pd);
    // 唯一不同的是这里取initlist(p)
    initlist(end);
  }
  exit(0);
 1a2:	4501                	li	a0,0
 1a4:	00000097          	auipc	ra,0x0
 1a8:	2a6080e7          	jalr	678(ra) # 44a <exit>
        end = atoi(argv[1]);
 1ac:	6588                	ld	a0,8(a1)
 1ae:	00000097          	auipc	ra,0x0
 1b2:	19c080e7          	jalr	412(ra) # 34a <atoi>
 1b6:	84aa                	mv	s1,a0
 1b8:	bf75                	j	174 <main+0x22>
    redirect(1, pd);
 1ba:	fd840593          	addi	a1,s0,-40
 1be:	4505                	li	a0,1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	ec8080e7          	jalr	-312(ra) # 88 <redirect>
    initlist(end);
 1c8:	8526                	mv	a0,s1
 1ca:	00000097          	auipc	ra,0x0
 1ce:	e36080e7          	jalr	-458(ra) # 0 <initlist>
 1d2:	bfc1                	j	1a2 <main+0x50>

00000000000001d4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1da:	87aa                	mv	a5,a0
 1dc:	0585                	addi	a1,a1,1
 1de:	0785                	addi	a5,a5,1
 1e0:	fff5c703          	lbu	a4,-1(a1)
 1e4:	fee78fa3          	sb	a4,-1(a5)
 1e8:	fb75                	bnez	a4,1dc <strcpy+0x8>
    ;
  return os;
}
 1ea:	6422                	ld	s0,8(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret

00000000000001f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1f6:	00054783          	lbu	a5,0(a0)
 1fa:	cb91                	beqz	a5,20e <strcmp+0x1e>
 1fc:	0005c703          	lbu	a4,0(a1)
 200:	00f71763          	bne	a4,a5,20e <strcmp+0x1e>
    p++, q++;
 204:	0505                	addi	a0,a0,1
 206:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 208:	00054783          	lbu	a5,0(a0)
 20c:	fbe5                	bnez	a5,1fc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 20e:	0005c503          	lbu	a0,0(a1)
}
 212:	40a7853b          	subw	a0,a5,a0
 216:	6422                	ld	s0,8(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret

000000000000021c <strlen>:

uint
strlen(const char *s)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 222:	00054783          	lbu	a5,0(a0)
 226:	cf91                	beqz	a5,242 <strlen+0x26>
 228:	0505                	addi	a0,a0,1
 22a:	87aa                	mv	a5,a0
 22c:	4685                	li	a3,1
 22e:	9e89                	subw	a3,a3,a0
 230:	00f6853b          	addw	a0,a3,a5
 234:	0785                	addi	a5,a5,1
 236:	fff7c703          	lbu	a4,-1(a5)
 23a:	fb7d                	bnez	a4,230 <strlen+0x14>
    ;
  return n;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret
  for(n = 0; s[n]; n++)
 242:	4501                	li	a0,0
 244:	bfe5                	j	23c <strlen+0x20>

0000000000000246 <memset>:

void*
memset(void *dst, int c, uint n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 24c:	ce09                	beqz	a2,266 <memset+0x20>
 24e:	87aa                	mv	a5,a0
 250:	fff6071b          	addiw	a4,a2,-1
 254:	1702                	slli	a4,a4,0x20
 256:	9301                	srli	a4,a4,0x20
 258:	0705                	addi	a4,a4,1
 25a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 25c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 260:	0785                	addi	a5,a5,1
 262:	fee79de3          	bne	a5,a4,25c <memset+0x16>
  }
  return dst;
}
 266:	6422                	ld	s0,8(sp)
 268:	0141                	addi	sp,sp,16
 26a:	8082                	ret

000000000000026c <strchr>:

char*
strchr(const char *s, char c)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  for(; *s; s++)
 272:	00054783          	lbu	a5,0(a0)
 276:	cb99                	beqz	a5,28c <strchr+0x20>
    if(*s == c)
 278:	00f58763          	beq	a1,a5,286 <strchr+0x1a>
  for(; *s; s++)
 27c:	0505                	addi	a0,a0,1
 27e:	00054783          	lbu	a5,0(a0)
 282:	fbfd                	bnez	a5,278 <strchr+0xc>
      return (char*)s;
  return 0;
 284:	4501                	li	a0,0
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  return 0;
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <strchr+0x1a>

0000000000000290 <gets>:

char*
gets(char *buf, int max)
{
 290:	711d                	addi	sp,sp,-96
 292:	ec86                	sd	ra,88(sp)
 294:	e8a2                	sd	s0,80(sp)
 296:	e4a6                	sd	s1,72(sp)
 298:	e0ca                	sd	s2,64(sp)
 29a:	fc4e                	sd	s3,56(sp)
 29c:	f852                	sd	s4,48(sp)
 29e:	f456                	sd	s5,40(sp)
 2a0:	f05a                	sd	s6,32(sp)
 2a2:	ec5e                	sd	s7,24(sp)
 2a4:	1080                	addi	s0,sp,96
 2a6:	8baa                	mv	s7,a0
 2a8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2aa:	892a                	mv	s2,a0
 2ac:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2ae:	4aa9                	li	s5,10
 2b0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2b2:	89a6                	mv	s3,s1
 2b4:	2485                	addiw	s1,s1,1
 2b6:	0344d863          	bge	s1,s4,2e6 <gets+0x56>
    cc = read(0, &c, 1);
 2ba:	4605                	li	a2,1
 2bc:	faf40593          	addi	a1,s0,-81
 2c0:	4501                	li	a0,0
 2c2:	00000097          	auipc	ra,0x0
 2c6:	1a0080e7          	jalr	416(ra) # 462 <read>
    if(cc < 1)
 2ca:	00a05e63          	blez	a0,2e6 <gets+0x56>
    buf[i++] = c;
 2ce:	faf44783          	lbu	a5,-81(s0)
 2d2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2d6:	01578763          	beq	a5,s5,2e4 <gets+0x54>
 2da:	0905                	addi	s2,s2,1
 2dc:	fd679be3          	bne	a5,s6,2b2 <gets+0x22>
  for(i=0; i+1 < max; ){
 2e0:	89a6                	mv	s3,s1
 2e2:	a011                	j	2e6 <gets+0x56>
 2e4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2e6:	99de                	add	s3,s3,s7
 2e8:	00098023          	sb	zero,0(s3)
  return buf;
}
 2ec:	855e                	mv	a0,s7
 2ee:	60e6                	ld	ra,88(sp)
 2f0:	6446                	ld	s0,80(sp)
 2f2:	64a6                	ld	s1,72(sp)
 2f4:	6906                	ld	s2,64(sp)
 2f6:	79e2                	ld	s3,56(sp)
 2f8:	7a42                	ld	s4,48(sp)
 2fa:	7aa2                	ld	s5,40(sp)
 2fc:	7b02                	ld	s6,32(sp)
 2fe:	6be2                	ld	s7,24(sp)
 300:	6125                	addi	sp,sp,96
 302:	8082                	ret

0000000000000304 <stat>:

int
stat(const char *n, struct stat *st)
{
 304:	1101                	addi	sp,sp,-32
 306:	ec06                	sd	ra,24(sp)
 308:	e822                	sd	s0,16(sp)
 30a:	e426                	sd	s1,8(sp)
 30c:	e04a                	sd	s2,0(sp)
 30e:	1000                	addi	s0,sp,32
 310:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 312:	4581                	li	a1,0
 314:	00000097          	auipc	ra,0x0
 318:	176080e7          	jalr	374(ra) # 48a <open>
  if(fd < 0)
 31c:	02054563          	bltz	a0,346 <stat+0x42>
 320:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 322:	85ca                	mv	a1,s2
 324:	00000097          	auipc	ra,0x0
 328:	17e080e7          	jalr	382(ra) # 4a2 <fstat>
 32c:	892a                	mv	s2,a0
  close(fd);
 32e:	8526                	mv	a0,s1
 330:	00000097          	auipc	ra,0x0
 334:	142080e7          	jalr	322(ra) # 472 <close>
  return r;
}
 338:	854a                	mv	a0,s2
 33a:	60e2                	ld	ra,24(sp)
 33c:	6442                	ld	s0,16(sp)
 33e:	64a2                	ld	s1,8(sp)
 340:	6902                	ld	s2,0(sp)
 342:	6105                	addi	sp,sp,32
 344:	8082                	ret
    return -1;
 346:	597d                	li	s2,-1
 348:	bfc5                	j	338 <stat+0x34>

000000000000034a <atoi>:

int
atoi(const char *s)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e422                	sd	s0,8(sp)
 34e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 350:	00054603          	lbu	a2,0(a0)
 354:	fd06079b          	addiw	a5,a2,-48
 358:	0ff7f793          	andi	a5,a5,255
 35c:	4725                	li	a4,9
 35e:	02f76963          	bltu	a4,a5,390 <atoi+0x46>
 362:	86aa                	mv	a3,a0
  n = 0;
 364:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 366:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 368:	0685                	addi	a3,a3,1
 36a:	0025179b          	slliw	a5,a0,0x2
 36e:	9fa9                	addw	a5,a5,a0
 370:	0017979b          	slliw	a5,a5,0x1
 374:	9fb1                	addw	a5,a5,a2
 376:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 37a:	0006c603          	lbu	a2,0(a3)
 37e:	fd06071b          	addiw	a4,a2,-48
 382:	0ff77713          	andi	a4,a4,255
 386:	fee5f1e3          	bgeu	a1,a4,368 <atoi+0x1e>
  return n;
}
 38a:	6422                	ld	s0,8(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret
  n = 0;
 390:	4501                	li	a0,0
 392:	bfe5                	j	38a <atoi+0x40>

0000000000000394 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 394:	1141                	addi	sp,sp,-16
 396:	e422                	sd	s0,8(sp)
 398:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 39a:	02b57663          	bgeu	a0,a1,3c6 <memmove+0x32>
    while(n-- > 0)
 39e:	02c05163          	blez	a2,3c0 <memmove+0x2c>
 3a2:	fff6079b          	addiw	a5,a2,-1
 3a6:	1782                	slli	a5,a5,0x20
 3a8:	9381                	srli	a5,a5,0x20
 3aa:	0785                	addi	a5,a5,1
 3ac:	97aa                	add	a5,a5,a0
  dst = vdst;
 3ae:	872a                	mv	a4,a0
      *dst++ = *src++;
 3b0:	0585                	addi	a1,a1,1
 3b2:	0705                	addi	a4,a4,1
 3b4:	fff5c683          	lbu	a3,-1(a1)
 3b8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3bc:	fee79ae3          	bne	a5,a4,3b0 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3c0:	6422                	ld	s0,8(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret
    dst += n;
 3c6:	00c50733          	add	a4,a0,a2
    src += n;
 3ca:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3cc:	fec05ae3          	blez	a2,3c0 <memmove+0x2c>
 3d0:	fff6079b          	addiw	a5,a2,-1
 3d4:	1782                	slli	a5,a5,0x20
 3d6:	9381                	srli	a5,a5,0x20
 3d8:	fff7c793          	not	a5,a5
 3dc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3de:	15fd                	addi	a1,a1,-1
 3e0:	177d                	addi	a4,a4,-1
 3e2:	0005c683          	lbu	a3,0(a1)
 3e6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ea:	fee79ae3          	bne	a5,a4,3de <memmove+0x4a>
 3ee:	bfc9                	j	3c0 <memmove+0x2c>

00000000000003f0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3f0:	1141                	addi	sp,sp,-16
 3f2:	e422                	sd	s0,8(sp)
 3f4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3f6:	ca05                	beqz	a2,426 <memcmp+0x36>
 3f8:	fff6069b          	addiw	a3,a2,-1
 3fc:	1682                	slli	a3,a3,0x20
 3fe:	9281                	srli	a3,a3,0x20
 400:	0685                	addi	a3,a3,1
 402:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 404:	00054783          	lbu	a5,0(a0)
 408:	0005c703          	lbu	a4,0(a1)
 40c:	00e79863          	bne	a5,a4,41c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 410:	0505                	addi	a0,a0,1
    p2++;
 412:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 414:	fed518e3          	bne	a0,a3,404 <memcmp+0x14>
  }
  return 0;
 418:	4501                	li	a0,0
 41a:	a019                	j	420 <memcmp+0x30>
      return *p1 - *p2;
 41c:	40e7853b          	subw	a0,a5,a4
}
 420:	6422                	ld	s0,8(sp)
 422:	0141                	addi	sp,sp,16
 424:	8082                	ret
  return 0;
 426:	4501                	li	a0,0
 428:	bfe5                	j	420 <memcmp+0x30>

000000000000042a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 42a:	1141                	addi	sp,sp,-16
 42c:	e406                	sd	ra,8(sp)
 42e:	e022                	sd	s0,0(sp)
 430:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 432:	00000097          	auipc	ra,0x0
 436:	f62080e7          	jalr	-158(ra) # 394 <memmove>
}
 43a:	60a2                	ld	ra,8(sp)
 43c:	6402                	ld	s0,0(sp)
 43e:	0141                	addi	sp,sp,16
 440:	8082                	ret

0000000000000442 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 442:	4885                	li	a7,1
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <exit>:
.global exit
exit:
 li a7, SYS_exit
 44a:	4889                	li	a7,2
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <wait>:
.global wait
wait:
 li a7, SYS_wait
 452:	488d                	li	a7,3
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 45a:	4891                	li	a7,4
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <read>:
.global read
read:
 li a7, SYS_read
 462:	4895                	li	a7,5
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <write>:
.global write
write:
 li a7, SYS_write
 46a:	48c1                	li	a7,16
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <close>:
.global close
close:
 li a7, SYS_close
 472:	48d5                	li	a7,21
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <kill>:
.global kill
kill:
 li a7, SYS_kill
 47a:	4899                	li	a7,6
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <exec>:
.global exec
exec:
 li a7, SYS_exec
 482:	489d                	li	a7,7
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <open>:
.global open
open:
 li a7, SYS_open
 48a:	48bd                	li	a7,15
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 492:	48c5                	li	a7,17
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 49a:	48c9                	li	a7,18
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4a2:	48a1                	li	a7,8
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <link>:
.global link
link:
 li a7, SYS_link
 4aa:	48cd                	li	a7,19
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4b2:	48d1                	li	a7,20
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ba:	48a5                	li	a7,9
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4c2:	48a9                	li	a7,10
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ca:	48ad                	li	a7,11
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4d2:	48b1                	li	a7,12
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4da:	48b5                	li	a7,13
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4e2:	48b9                	li	a7,14
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <trace>:
.global trace
trace:
 li a7, SYS_trace
 4ea:	48d9                	li	a7,22
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 4f2:	48dd                	li	a7,23
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4fa:	1101                	addi	sp,sp,-32
 4fc:	ec06                	sd	ra,24(sp)
 4fe:	e822                	sd	s0,16(sp)
 500:	1000                	addi	s0,sp,32
 502:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 506:	4605                	li	a2,1
 508:	fef40593          	addi	a1,s0,-17
 50c:	00000097          	auipc	ra,0x0
 510:	f5e080e7          	jalr	-162(ra) # 46a <write>
}
 514:	60e2                	ld	ra,24(sp)
 516:	6442                	ld	s0,16(sp)
 518:	6105                	addi	sp,sp,32
 51a:	8082                	ret

000000000000051c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51c:	7139                	addi	sp,sp,-64
 51e:	fc06                	sd	ra,56(sp)
 520:	f822                	sd	s0,48(sp)
 522:	f426                	sd	s1,40(sp)
 524:	f04a                	sd	s2,32(sp)
 526:	ec4e                	sd	s3,24(sp)
 528:	0080                	addi	s0,sp,64
 52a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 52c:	c299                	beqz	a3,532 <printint+0x16>
 52e:	0805c863          	bltz	a1,5be <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 532:	2581                	sext.w	a1,a1
  neg = 0;
 534:	4881                	li	a7,0
 536:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 53a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 53c:	2601                	sext.w	a2,a2
 53e:	00000517          	auipc	a0,0x0
 542:	46250513          	addi	a0,a0,1122 # 9a0 <digits>
 546:	883a                	mv	a6,a4
 548:	2705                	addiw	a4,a4,1
 54a:	02c5f7bb          	remuw	a5,a1,a2
 54e:	1782                	slli	a5,a5,0x20
 550:	9381                	srli	a5,a5,0x20
 552:	97aa                	add	a5,a5,a0
 554:	0007c783          	lbu	a5,0(a5)
 558:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 55c:	0005879b          	sext.w	a5,a1
 560:	02c5d5bb          	divuw	a1,a1,a2
 564:	0685                	addi	a3,a3,1
 566:	fec7f0e3          	bgeu	a5,a2,546 <printint+0x2a>
  if(neg)
 56a:	00088b63          	beqz	a7,580 <printint+0x64>
    buf[i++] = '-';
 56e:	fd040793          	addi	a5,s0,-48
 572:	973e                	add	a4,a4,a5
 574:	02d00793          	li	a5,45
 578:	fef70823          	sb	a5,-16(a4)
 57c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 580:	02e05863          	blez	a4,5b0 <printint+0x94>
 584:	fc040793          	addi	a5,s0,-64
 588:	00e78933          	add	s2,a5,a4
 58c:	fff78993          	addi	s3,a5,-1
 590:	99ba                	add	s3,s3,a4
 592:	377d                	addiw	a4,a4,-1
 594:	1702                	slli	a4,a4,0x20
 596:	9301                	srli	a4,a4,0x20
 598:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 59c:	fff94583          	lbu	a1,-1(s2)
 5a0:	8526                	mv	a0,s1
 5a2:	00000097          	auipc	ra,0x0
 5a6:	f58080e7          	jalr	-168(ra) # 4fa <putc>
  while(--i >= 0)
 5aa:	197d                	addi	s2,s2,-1
 5ac:	ff3918e3          	bne	s2,s3,59c <printint+0x80>
}
 5b0:	70e2                	ld	ra,56(sp)
 5b2:	7442                	ld	s0,48(sp)
 5b4:	74a2                	ld	s1,40(sp)
 5b6:	7902                	ld	s2,32(sp)
 5b8:	69e2                	ld	s3,24(sp)
 5ba:	6121                	addi	sp,sp,64
 5bc:	8082                	ret
    x = -xx;
 5be:	40b005bb          	negw	a1,a1
    neg = 1;
 5c2:	4885                	li	a7,1
    x = -xx;
 5c4:	bf8d                	j	536 <printint+0x1a>

00000000000005c6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5c6:	7119                	addi	sp,sp,-128
 5c8:	fc86                	sd	ra,120(sp)
 5ca:	f8a2                	sd	s0,112(sp)
 5cc:	f4a6                	sd	s1,104(sp)
 5ce:	f0ca                	sd	s2,96(sp)
 5d0:	ecce                	sd	s3,88(sp)
 5d2:	e8d2                	sd	s4,80(sp)
 5d4:	e4d6                	sd	s5,72(sp)
 5d6:	e0da                	sd	s6,64(sp)
 5d8:	fc5e                	sd	s7,56(sp)
 5da:	f862                	sd	s8,48(sp)
 5dc:	f466                	sd	s9,40(sp)
 5de:	f06a                	sd	s10,32(sp)
 5e0:	ec6e                	sd	s11,24(sp)
 5e2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5e4:	0005c903          	lbu	s2,0(a1)
 5e8:	18090f63          	beqz	s2,786 <vprintf+0x1c0>
 5ec:	8aaa                	mv	s5,a0
 5ee:	8b32                	mv	s6,a2
 5f0:	00158493          	addi	s1,a1,1
  state = 0;
 5f4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5f6:	02500a13          	li	s4,37
      if(c == 'd'){
 5fa:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5fe:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 602:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 606:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 60a:	00000b97          	auipc	s7,0x0
 60e:	396b8b93          	addi	s7,s7,918 # 9a0 <digits>
 612:	a839                	j	630 <vprintf+0x6a>
        putc(fd, c);
 614:	85ca                	mv	a1,s2
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	ee2080e7          	jalr	-286(ra) # 4fa <putc>
 620:	a019                	j	626 <vprintf+0x60>
    } else if(state == '%'){
 622:	01498f63          	beq	s3,s4,640 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 626:	0485                	addi	s1,s1,1
 628:	fff4c903          	lbu	s2,-1(s1)
 62c:	14090d63          	beqz	s2,786 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 630:	0009079b          	sext.w	a5,s2
    if(state == 0){
 634:	fe0997e3          	bnez	s3,622 <vprintf+0x5c>
      if(c == '%'){
 638:	fd479ee3          	bne	a5,s4,614 <vprintf+0x4e>
        state = '%';
 63c:	89be                	mv	s3,a5
 63e:	b7e5                	j	626 <vprintf+0x60>
      if(c == 'd'){
 640:	05878063          	beq	a5,s8,680 <vprintf+0xba>
      } else if(c == 'l') {
 644:	05978c63          	beq	a5,s9,69c <vprintf+0xd6>
      } else if(c == 'x') {
 648:	07a78863          	beq	a5,s10,6b8 <vprintf+0xf2>
      } else if(c == 'p') {
 64c:	09b78463          	beq	a5,s11,6d4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 650:	07300713          	li	a4,115
 654:	0ce78663          	beq	a5,a4,720 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 658:	06300713          	li	a4,99
 65c:	0ee78e63          	beq	a5,a4,758 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 660:	11478863          	beq	a5,s4,770 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 664:	85d2                	mv	a1,s4
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	e92080e7          	jalr	-366(ra) # 4fa <putc>
        putc(fd, c);
 670:	85ca                	mv	a1,s2
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	e86080e7          	jalr	-378(ra) # 4fa <putc>
      }
      state = 0;
 67c:	4981                	li	s3,0
 67e:	b765                	j	626 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 680:	008b0913          	addi	s2,s6,8
 684:	4685                	li	a3,1
 686:	4629                	li	a2,10
 688:	000b2583          	lw	a1,0(s6)
 68c:	8556                	mv	a0,s5
 68e:	00000097          	auipc	ra,0x0
 692:	e8e080e7          	jalr	-370(ra) # 51c <printint>
 696:	8b4a                	mv	s6,s2
      state = 0;
 698:	4981                	li	s3,0
 69a:	b771                	j	626 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69c:	008b0913          	addi	s2,s6,8
 6a0:	4681                	li	a3,0
 6a2:	4629                	li	a2,10
 6a4:	000b2583          	lw	a1,0(s6)
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	e72080e7          	jalr	-398(ra) # 51c <printint>
 6b2:	8b4a                	mv	s6,s2
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	bf85                	j	626 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6b8:	008b0913          	addi	s2,s6,8
 6bc:	4681                	li	a3,0
 6be:	4641                	li	a2,16
 6c0:	000b2583          	lw	a1,0(s6)
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	e56080e7          	jalr	-426(ra) # 51c <printint>
 6ce:	8b4a                	mv	s6,s2
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bf91                	j	626 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6d4:	008b0793          	addi	a5,s6,8
 6d8:	f8f43423          	sd	a5,-120(s0)
 6dc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6e0:	03000593          	li	a1,48
 6e4:	8556                	mv	a0,s5
 6e6:	00000097          	auipc	ra,0x0
 6ea:	e14080e7          	jalr	-492(ra) # 4fa <putc>
  putc(fd, 'x');
 6ee:	85ea                	mv	a1,s10
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	e08080e7          	jalr	-504(ra) # 4fa <putc>
 6fa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fc:	03c9d793          	srli	a5,s3,0x3c
 700:	97de                	add	a5,a5,s7
 702:	0007c583          	lbu	a1,0(a5)
 706:	8556                	mv	a0,s5
 708:	00000097          	auipc	ra,0x0
 70c:	df2080e7          	jalr	-526(ra) # 4fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 710:	0992                	slli	s3,s3,0x4
 712:	397d                	addiw	s2,s2,-1
 714:	fe0914e3          	bnez	s2,6fc <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 718:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 71c:	4981                	li	s3,0
 71e:	b721                	j	626 <vprintf+0x60>
        s = va_arg(ap, char*);
 720:	008b0993          	addi	s3,s6,8
 724:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 728:	02090163          	beqz	s2,74a <vprintf+0x184>
        while(*s != 0){
 72c:	00094583          	lbu	a1,0(s2)
 730:	c9a1                	beqz	a1,780 <vprintf+0x1ba>
          putc(fd, *s);
 732:	8556                	mv	a0,s5
 734:	00000097          	auipc	ra,0x0
 738:	dc6080e7          	jalr	-570(ra) # 4fa <putc>
          s++;
 73c:	0905                	addi	s2,s2,1
        while(*s != 0){
 73e:	00094583          	lbu	a1,0(s2)
 742:	f9e5                	bnez	a1,732 <vprintf+0x16c>
        s = va_arg(ap, char*);
 744:	8b4e                	mv	s6,s3
      state = 0;
 746:	4981                	li	s3,0
 748:	bdf9                	j	626 <vprintf+0x60>
          s = "(null)";
 74a:	00000917          	auipc	s2,0x0
 74e:	24e90913          	addi	s2,s2,590 # 998 <malloc+0x108>
        while(*s != 0){
 752:	02800593          	li	a1,40
 756:	bff1                	j	732 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 758:	008b0913          	addi	s2,s6,8
 75c:	000b4583          	lbu	a1,0(s6)
 760:	8556                	mv	a0,s5
 762:	00000097          	auipc	ra,0x0
 766:	d98080e7          	jalr	-616(ra) # 4fa <putc>
 76a:	8b4a                	mv	s6,s2
      state = 0;
 76c:	4981                	li	s3,0
 76e:	bd65                	j	626 <vprintf+0x60>
        putc(fd, c);
 770:	85d2                	mv	a1,s4
 772:	8556                	mv	a0,s5
 774:	00000097          	auipc	ra,0x0
 778:	d86080e7          	jalr	-634(ra) # 4fa <putc>
      state = 0;
 77c:	4981                	li	s3,0
 77e:	b565                	j	626 <vprintf+0x60>
        s = va_arg(ap, char*);
 780:	8b4e                	mv	s6,s3
      state = 0;
 782:	4981                	li	s3,0
 784:	b54d                	j	626 <vprintf+0x60>
    }
  }
}
 786:	70e6                	ld	ra,120(sp)
 788:	7446                	ld	s0,112(sp)
 78a:	74a6                	ld	s1,104(sp)
 78c:	7906                	ld	s2,96(sp)
 78e:	69e6                	ld	s3,88(sp)
 790:	6a46                	ld	s4,80(sp)
 792:	6aa6                	ld	s5,72(sp)
 794:	6b06                	ld	s6,64(sp)
 796:	7be2                	ld	s7,56(sp)
 798:	7c42                	ld	s8,48(sp)
 79a:	7ca2                	ld	s9,40(sp)
 79c:	7d02                	ld	s10,32(sp)
 79e:	6de2                	ld	s11,24(sp)
 7a0:	6109                	addi	sp,sp,128
 7a2:	8082                	ret

00000000000007a4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a4:	715d                	addi	sp,sp,-80
 7a6:	ec06                	sd	ra,24(sp)
 7a8:	e822                	sd	s0,16(sp)
 7aa:	1000                	addi	s0,sp,32
 7ac:	e010                	sd	a2,0(s0)
 7ae:	e414                	sd	a3,8(s0)
 7b0:	e818                	sd	a4,16(s0)
 7b2:	ec1c                	sd	a5,24(s0)
 7b4:	03043023          	sd	a6,32(s0)
 7b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7bc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c0:	8622                	mv	a2,s0
 7c2:	00000097          	auipc	ra,0x0
 7c6:	e04080e7          	jalr	-508(ra) # 5c6 <vprintf>
}
 7ca:	60e2                	ld	ra,24(sp)
 7cc:	6442                	ld	s0,16(sp)
 7ce:	6161                	addi	sp,sp,80
 7d0:	8082                	ret

00000000000007d2 <printf>:

void
printf(const char *fmt, ...)
{
 7d2:	711d                	addi	sp,sp,-96
 7d4:	ec06                	sd	ra,24(sp)
 7d6:	e822                	sd	s0,16(sp)
 7d8:	1000                	addi	s0,sp,32
 7da:	e40c                	sd	a1,8(s0)
 7dc:	e810                	sd	a2,16(s0)
 7de:	ec14                	sd	a3,24(s0)
 7e0:	f018                	sd	a4,32(s0)
 7e2:	f41c                	sd	a5,40(s0)
 7e4:	03043823          	sd	a6,48(s0)
 7e8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ec:	00840613          	addi	a2,s0,8
 7f0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f4:	85aa                	mv	a1,a0
 7f6:	4505                	li	a0,1
 7f8:	00000097          	auipc	ra,0x0
 7fc:	dce080e7          	jalr	-562(ra) # 5c6 <vprintf>
}
 800:	60e2                	ld	ra,24(sp)
 802:	6442                	ld	s0,16(sp)
 804:	6125                	addi	sp,sp,96
 806:	8082                	ret

0000000000000808 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 808:	1141                	addi	sp,sp,-16
 80a:	e422                	sd	s0,8(sp)
 80c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 80e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 812:	00000797          	auipc	a5,0x0
 816:	1a67b783          	ld	a5,422(a5) # 9b8 <freep>
 81a:	a805                	j	84a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 81c:	4618                	lw	a4,8(a2)
 81e:	9db9                	addw	a1,a1,a4
 820:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 824:	6398                	ld	a4,0(a5)
 826:	6318                	ld	a4,0(a4)
 828:	fee53823          	sd	a4,-16(a0)
 82c:	a091                	j	870 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 82e:	ff852703          	lw	a4,-8(a0)
 832:	9e39                	addw	a2,a2,a4
 834:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 836:	ff053703          	ld	a4,-16(a0)
 83a:	e398                	sd	a4,0(a5)
 83c:	a099                	j	882 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83e:	6398                	ld	a4,0(a5)
 840:	00e7e463          	bltu	a5,a4,848 <free+0x40>
 844:	00e6ea63          	bltu	a3,a4,858 <free+0x50>
{
 848:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84a:	fed7fae3          	bgeu	a5,a3,83e <free+0x36>
 84e:	6398                	ld	a4,0(a5)
 850:	00e6e463          	bltu	a3,a4,858 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 854:	fee7eae3          	bltu	a5,a4,848 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 858:	ff852583          	lw	a1,-8(a0)
 85c:	6390                	ld	a2,0(a5)
 85e:	02059713          	slli	a4,a1,0x20
 862:	9301                	srli	a4,a4,0x20
 864:	0712                	slli	a4,a4,0x4
 866:	9736                	add	a4,a4,a3
 868:	fae60ae3          	beq	a2,a4,81c <free+0x14>
    bp->s.ptr = p->s.ptr;
 86c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 870:	4790                	lw	a2,8(a5)
 872:	02061713          	slli	a4,a2,0x20
 876:	9301                	srli	a4,a4,0x20
 878:	0712                	slli	a4,a4,0x4
 87a:	973e                	add	a4,a4,a5
 87c:	fae689e3          	beq	a3,a4,82e <free+0x26>
  } else
    p->s.ptr = bp;
 880:	e394                	sd	a3,0(a5)
  freep = p;
 882:	00000717          	auipc	a4,0x0
 886:	12f73b23          	sd	a5,310(a4) # 9b8 <freep>
}
 88a:	6422                	ld	s0,8(sp)
 88c:	0141                	addi	sp,sp,16
 88e:	8082                	ret

0000000000000890 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 890:	7139                	addi	sp,sp,-64
 892:	fc06                	sd	ra,56(sp)
 894:	f822                	sd	s0,48(sp)
 896:	f426                	sd	s1,40(sp)
 898:	f04a                	sd	s2,32(sp)
 89a:	ec4e                	sd	s3,24(sp)
 89c:	e852                	sd	s4,16(sp)
 89e:	e456                	sd	s5,8(sp)
 8a0:	e05a                	sd	s6,0(sp)
 8a2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a4:	02051493          	slli	s1,a0,0x20
 8a8:	9081                	srli	s1,s1,0x20
 8aa:	04bd                	addi	s1,s1,15
 8ac:	8091                	srli	s1,s1,0x4
 8ae:	0014899b          	addiw	s3,s1,1
 8b2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8b4:	00000517          	auipc	a0,0x0
 8b8:	10453503          	ld	a0,260(a0) # 9b8 <freep>
 8bc:	c515                	beqz	a0,8e8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c0:	4798                	lw	a4,8(a5)
 8c2:	02977f63          	bgeu	a4,s1,900 <malloc+0x70>
 8c6:	8a4e                	mv	s4,s3
 8c8:	0009871b          	sext.w	a4,s3
 8cc:	6685                	lui	a3,0x1
 8ce:	00d77363          	bgeu	a4,a3,8d4 <malloc+0x44>
 8d2:	6a05                	lui	s4,0x1
 8d4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8d8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8dc:	00000917          	auipc	s2,0x0
 8e0:	0dc90913          	addi	s2,s2,220 # 9b8 <freep>
  if(p == (char*)-1)
 8e4:	5afd                	li	s5,-1
 8e6:	a88d                	j	958 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8e8:	00000797          	auipc	a5,0x0
 8ec:	0d878793          	addi	a5,a5,216 # 9c0 <base>
 8f0:	00000717          	auipc	a4,0x0
 8f4:	0cf73423          	sd	a5,200(a4) # 9b8 <freep>
 8f8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8fa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8fe:	b7e1                	j	8c6 <malloc+0x36>
      if(p->s.size == nunits)
 900:	02e48b63          	beq	s1,a4,936 <malloc+0xa6>
        p->s.size -= nunits;
 904:	4137073b          	subw	a4,a4,s3
 908:	c798                	sw	a4,8(a5)
        p += p->s.size;
 90a:	1702                	slli	a4,a4,0x20
 90c:	9301                	srli	a4,a4,0x20
 90e:	0712                	slli	a4,a4,0x4
 910:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 912:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 916:	00000717          	auipc	a4,0x0
 91a:	0aa73123          	sd	a0,162(a4) # 9b8 <freep>
      return (void*)(p + 1);
 91e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 922:	70e2                	ld	ra,56(sp)
 924:	7442                	ld	s0,48(sp)
 926:	74a2                	ld	s1,40(sp)
 928:	7902                	ld	s2,32(sp)
 92a:	69e2                	ld	s3,24(sp)
 92c:	6a42                	ld	s4,16(sp)
 92e:	6aa2                	ld	s5,8(sp)
 930:	6b02                	ld	s6,0(sp)
 932:	6121                	addi	sp,sp,64
 934:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 936:	6398                	ld	a4,0(a5)
 938:	e118                	sd	a4,0(a0)
 93a:	bff1                	j	916 <malloc+0x86>
  hp->s.size = nu;
 93c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 940:	0541                	addi	a0,a0,16
 942:	00000097          	auipc	ra,0x0
 946:	ec6080e7          	jalr	-314(ra) # 808 <free>
  return freep;
 94a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 94e:	d971                	beqz	a0,922 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 950:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 952:	4798                	lw	a4,8(a5)
 954:	fa9776e3          	bgeu	a4,s1,900 <malloc+0x70>
    if(p == freep)
 958:	00093703          	ld	a4,0(s2)
 95c:	853e                	mv	a0,a5
 95e:	fef719e3          	bne	a4,a5,950 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 962:	8552                	mv	a0,s4
 964:	00000097          	auipc	ra,0x0
 968:	b6e080e7          	jalr	-1170(ra) # 4d2 <sbrk>
  if(p == (char*)-1)
 96c:	fd5518e3          	bne	a0,s5,93c <malloc+0xac>
        return 0;
 970:	4501                	li	a0,0
 972:	bf45                	j	922 <malloc+0x92>
