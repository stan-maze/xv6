
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"
int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	1c00                	addi	s0,sp,560
    // father_to_child 和 child_to_father管道
    int p_ftoc[2],p_ctof[2];
    pipe(p_ftoc);
  12:	fd840513          	addi	a0,s0,-40
  16:	00000097          	auipc	ra,0x0
  1a:	3d6080e7          	jalr	982(ra) # 3ec <pipe>
    pipe(p_ctof);
  1e:	fd040513          	addi	a0,s0,-48
  22:	00000097          	auipc	ra,0x0
  26:	3ca080e7          	jalr	970(ra) # 3ec <pipe>
    // 写入father_to_child[1]
    write(p_ftoc[1],"received ping pong\n",strlen("received ping pong\n"));
  2a:	fdc42483          	lw	s1,-36(s0)
  2e:	00001517          	auipc	a0,0x1
  32:	8da50513          	addi	a0,a0,-1830 # 908 <malloc+0xe6>
  36:	00000097          	auipc	ra,0x0
  3a:	178080e7          	jalr	376(ra) # 1ae <strlen>
  3e:	0005061b          	sext.w	a2,a0
  42:	00001597          	auipc	a1,0x1
  46:	8c658593          	addi	a1,a1,-1850 # 908 <malloc+0xe6>
  4a:	8526                	mv	a0,s1
  4c:	00000097          	auipc	ra,0x0
  50:	3b0080e7          	jalr	944(ra) # 3fc <write>
    // 注意关闭，否则可能出现循环等待
    close(p_ftoc[1]);
  54:	fdc42503          	lw	a0,-36(s0)
  58:	00000097          	auipc	ra,0x0
  5c:	3ac080e7          	jalr	940(ra) # 404 <close>
    if(!fork()){
  60:	00000097          	auipc	ra,0x0
  64:	374080e7          	jalr	884(ra) # 3d4 <fork>
  68:	e141                	bnez	a0,e8 <main+0xe8>
        char buf[512];
        // 从写入father_to_child[0]中取出received ping pong
        int n = read(p_ftoc[0],buf,sizeof(buf));
  6a:	20000613          	li	a2,512
  6e:	dd040593          	addi	a1,s0,-560
  72:	fd842503          	lw	a0,-40(s0)
  76:	00000097          	auipc	ra,0x0
  7a:	37e080e7          	jalr	894(ra) # 3f4 <read>
  7e:	84aa                	mv	s1,a0
        close(p_ftoc[0]);
  80:	fd842503          	lw	a0,-40(s0)
  84:	00000097          	auipc	ra,0x0
  88:	380080e7          	jalr	896(ra) # 404 <close>
        if(n<=0){ 
  8c:	02905663          	blez	s1,b8 <main+0xb8>
            write(1,"children faild\n",strlen("children faild\n"));
            exit(-1);
        }
        // 写入child_to_father[1]
        write(p_ctof[1],buf,n);
  90:	8626                	mv	a2,s1
  92:	dd040593          	addi	a1,s0,-560
  96:	fd442503          	lw	a0,-44(s0)
  9a:	00000097          	auipc	ra,0x0
  9e:	362080e7          	jalr	866(ra) # 3fc <write>
        close(p_ctof[1]);
  a2:	fd442503          	lw	a0,-44(s0)
  a6:	00000097          	auipc	ra,0x0
  aa:	35e080e7          	jalr	862(ra) # 404 <close>
        exit(0);
  ae:	4501                	li	a0,0
  b0:	00000097          	auipc	ra,0x0
  b4:	32c080e7          	jalr	812(ra) # 3dc <exit>
            write(1,"children faild\n",strlen("children faild\n"));
  b8:	00001517          	auipc	a0,0x1
  bc:	86850513          	addi	a0,a0,-1944 # 920 <malloc+0xfe>
  c0:	00000097          	auipc	ra,0x0
  c4:	0ee080e7          	jalr	238(ra) # 1ae <strlen>
  c8:	0005061b          	sext.w	a2,a0
  cc:	00001597          	auipc	a1,0x1
  d0:	85458593          	addi	a1,a1,-1964 # 920 <malloc+0xfe>
  d4:	4505                	li	a0,1
  d6:	00000097          	auipc	ra,0x0
  da:	326080e7          	jalr	806(ra) # 3fc <write>
            exit(-1);
  de:	557d                	li	a0,-1
  e0:	00000097          	auipc	ra,0x0
  e4:	2fc080e7          	jalr	764(ra) # 3dc <exit>
    }
    else{
        char res[512];
        // 从child_to_father[0]取出received ping pong
        int n = read(p_ctof[0],res,sizeof(res));
  e8:	20000613          	li	a2,512
  ec:	dd040593          	addi	a1,s0,-560
  f0:	fd042503          	lw	a0,-48(s0)
  f4:	00000097          	auipc	ra,0x0
  f8:	300080e7          	jalr	768(ra) # 3f4 <read>
  fc:	84aa                	mv	s1,a0
        close(p_ctof[0]);
  fe:	fd042503          	lw	a0,-48(s0)
 102:	00000097          	auipc	ra,0x0
 106:	302080e7          	jalr	770(ra) # 404 <close>
        if(n<=0) {
 10a:	02905663          	blez	s1,136 <main+0x136>
            write(1,"father faild\n",strlen("father faild\n"));
            exit(-1);
        }
        write(1,res,strlen(res));
 10e:	dd040513          	addi	a0,s0,-560
 112:	00000097          	auipc	ra,0x0
 116:	09c080e7          	jalr	156(ra) # 1ae <strlen>
 11a:	0005061b          	sext.w	a2,a0
 11e:	dd040593          	addi	a1,s0,-560
 122:	4505                	li	a0,1
 124:	00000097          	auipc	ra,0x0
 128:	2d8080e7          	jalr	728(ra) # 3fc <write>
        exit(0);
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	2ae080e7          	jalr	686(ra) # 3dc <exit>
            write(1,"father faild\n",strlen("father faild\n"));
 136:	00000517          	auipc	a0,0x0
 13a:	7fa50513          	addi	a0,a0,2042 # 930 <malloc+0x10e>
 13e:	00000097          	auipc	ra,0x0
 142:	070080e7          	jalr	112(ra) # 1ae <strlen>
 146:	0005061b          	sext.w	a2,a0
 14a:	00000597          	auipc	a1,0x0
 14e:	7e658593          	addi	a1,a1,2022 # 930 <malloc+0x10e>
 152:	4505                	li	a0,1
 154:	00000097          	auipc	ra,0x0
 158:	2a8080e7          	jalr	680(ra) # 3fc <write>
            exit(-1);
 15c:	557d                	li	a0,-1
 15e:	00000097          	auipc	ra,0x0
 162:	27e080e7          	jalr	638(ra) # 3dc <exit>

0000000000000166 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 166:	1141                	addi	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 16c:	87aa                	mv	a5,a0
 16e:	0585                	addi	a1,a1,1
 170:	0785                	addi	a5,a5,1
 172:	fff5c703          	lbu	a4,-1(a1)
 176:	fee78fa3          	sb	a4,-1(a5)
 17a:	fb75                	bnez	a4,16e <strcpy+0x8>
    ;
  return os;
}
 17c:	6422                	ld	s0,8(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret

0000000000000182 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 182:	1141                	addi	sp,sp,-16
 184:	e422                	sd	s0,8(sp)
 186:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 188:	00054783          	lbu	a5,0(a0)
 18c:	cb91                	beqz	a5,1a0 <strcmp+0x1e>
 18e:	0005c703          	lbu	a4,0(a1)
 192:	00f71763          	bne	a4,a5,1a0 <strcmp+0x1e>
    p++, q++;
 196:	0505                	addi	a0,a0,1
 198:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 19a:	00054783          	lbu	a5,0(a0)
 19e:	fbe5                	bnez	a5,18e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1a0:	0005c503          	lbu	a0,0(a1)
}
 1a4:	40a7853b          	subw	a0,a5,a0
 1a8:	6422                	ld	s0,8(sp)
 1aa:	0141                	addi	sp,sp,16
 1ac:	8082                	ret

00000000000001ae <strlen>:

uint
strlen(const char *s)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e422                	sd	s0,8(sp)
 1b2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1b4:	00054783          	lbu	a5,0(a0)
 1b8:	cf91                	beqz	a5,1d4 <strlen+0x26>
 1ba:	0505                	addi	a0,a0,1
 1bc:	87aa                	mv	a5,a0
 1be:	4685                	li	a3,1
 1c0:	9e89                	subw	a3,a3,a0
 1c2:	00f6853b          	addw	a0,a3,a5
 1c6:	0785                	addi	a5,a5,1
 1c8:	fff7c703          	lbu	a4,-1(a5)
 1cc:	fb7d                	bnez	a4,1c2 <strlen+0x14>
    ;
  return n;
}
 1ce:	6422                	ld	s0,8(sp)
 1d0:	0141                	addi	sp,sp,16
 1d2:	8082                	ret
  for(n = 0; s[n]; n++)
 1d4:	4501                	li	a0,0
 1d6:	bfe5                	j	1ce <strlen+0x20>

00000000000001d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1de:	ce09                	beqz	a2,1f8 <memset+0x20>
 1e0:	87aa                	mv	a5,a0
 1e2:	fff6071b          	addiw	a4,a2,-1
 1e6:	1702                	slli	a4,a4,0x20
 1e8:	9301                	srli	a4,a4,0x20
 1ea:	0705                	addi	a4,a4,1
 1ec:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1ee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f2:	0785                	addi	a5,a5,1
 1f4:	fee79de3          	bne	a5,a4,1ee <memset+0x16>
  }
  return dst;
}
 1f8:	6422                	ld	s0,8(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret

00000000000001fe <strchr>:

char*
strchr(const char *s, char c)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  for(; *s; s++)
 204:	00054783          	lbu	a5,0(a0)
 208:	cb99                	beqz	a5,21e <strchr+0x20>
    if(*s == c)
 20a:	00f58763          	beq	a1,a5,218 <strchr+0x1a>
  for(; *s; s++)
 20e:	0505                	addi	a0,a0,1
 210:	00054783          	lbu	a5,0(a0)
 214:	fbfd                	bnez	a5,20a <strchr+0xc>
      return (char*)s;
  return 0;
 216:	4501                	li	a0,0
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret
  return 0;
 21e:	4501                	li	a0,0
 220:	bfe5                	j	218 <strchr+0x1a>

0000000000000222 <gets>:

char*
gets(char *buf, int max)
{
 222:	711d                	addi	sp,sp,-96
 224:	ec86                	sd	ra,88(sp)
 226:	e8a2                	sd	s0,80(sp)
 228:	e4a6                	sd	s1,72(sp)
 22a:	e0ca                	sd	s2,64(sp)
 22c:	fc4e                	sd	s3,56(sp)
 22e:	f852                	sd	s4,48(sp)
 230:	f456                	sd	s5,40(sp)
 232:	f05a                	sd	s6,32(sp)
 234:	ec5e                	sd	s7,24(sp)
 236:	1080                	addi	s0,sp,96
 238:	8baa                	mv	s7,a0
 23a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23c:	892a                	mv	s2,a0
 23e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 240:	4aa9                	li	s5,10
 242:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 244:	89a6                	mv	s3,s1
 246:	2485                	addiw	s1,s1,1
 248:	0344d863          	bge	s1,s4,278 <gets+0x56>
    cc = read(0, &c, 1);
 24c:	4605                	li	a2,1
 24e:	faf40593          	addi	a1,s0,-81
 252:	4501                	li	a0,0
 254:	00000097          	auipc	ra,0x0
 258:	1a0080e7          	jalr	416(ra) # 3f4 <read>
    if(cc < 1)
 25c:	00a05e63          	blez	a0,278 <gets+0x56>
    buf[i++] = c;
 260:	faf44783          	lbu	a5,-81(s0)
 264:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 268:	01578763          	beq	a5,s5,276 <gets+0x54>
 26c:	0905                	addi	s2,s2,1
 26e:	fd679be3          	bne	a5,s6,244 <gets+0x22>
  for(i=0; i+1 < max; ){
 272:	89a6                	mv	s3,s1
 274:	a011                	j	278 <gets+0x56>
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
 29c:	e426                	sd	s1,8(sp)
 29e:	e04a                	sd	s2,0(sp)
 2a0:	1000                	addi	s0,sp,32
 2a2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a4:	4581                	li	a1,0
 2a6:	00000097          	auipc	ra,0x0
 2aa:	176080e7          	jalr	374(ra) # 41c <open>
  if(fd < 0)
 2ae:	02054563          	bltz	a0,2d8 <stat+0x42>
 2b2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2b4:	85ca                	mv	a1,s2
 2b6:	00000097          	auipc	ra,0x0
 2ba:	17e080e7          	jalr	382(ra) # 434 <fstat>
 2be:	892a                	mv	s2,a0
  close(fd);
 2c0:	8526                	mv	a0,s1
 2c2:	00000097          	auipc	ra,0x0
 2c6:	142080e7          	jalr	322(ra) # 404 <close>
  return r;
}
 2ca:	854a                	mv	a0,s2
 2cc:	60e2                	ld	ra,24(sp)
 2ce:	6442                	ld	s0,16(sp)
 2d0:	64a2                	ld	s1,8(sp)
 2d2:	6902                	ld	s2,0(sp)
 2d4:	6105                	addi	sp,sp,32
 2d6:	8082                	ret
    return -1;
 2d8:	597d                	li	s2,-1
 2da:	bfc5                	j	2ca <stat+0x34>

00000000000002dc <atoi>:

int
atoi(const char *s)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e2:	00054603          	lbu	a2,0(a0)
 2e6:	fd06079b          	addiw	a5,a2,-48
 2ea:	0ff7f793          	andi	a5,a5,255
 2ee:	4725                	li	a4,9
 2f0:	02f76963          	bltu	a4,a5,322 <atoi+0x46>
 2f4:	86aa                	mv	a3,a0
  n = 0;
 2f6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2f8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2fa:	0685                	addi	a3,a3,1
 2fc:	0025179b          	slliw	a5,a0,0x2
 300:	9fa9                	addw	a5,a5,a0
 302:	0017979b          	slliw	a5,a5,0x1
 306:	9fb1                	addw	a5,a5,a2
 308:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 30c:	0006c603          	lbu	a2,0(a3)
 310:	fd06071b          	addiw	a4,a2,-48
 314:	0ff77713          	andi	a4,a4,255
 318:	fee5f1e3          	bgeu	a1,a4,2fa <atoi+0x1e>
  return n;
}
 31c:	6422                	ld	s0,8(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret
  n = 0;
 322:	4501                	li	a0,0
 324:	bfe5                	j	31c <atoi+0x40>

0000000000000326 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 326:	1141                	addi	sp,sp,-16
 328:	e422                	sd	s0,8(sp)
 32a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 32c:	02b57663          	bgeu	a0,a1,358 <memmove+0x32>
    while(n-- > 0)
 330:	02c05163          	blez	a2,352 <memmove+0x2c>
 334:	fff6079b          	addiw	a5,a2,-1
 338:	1782                	slli	a5,a5,0x20
 33a:	9381                	srli	a5,a5,0x20
 33c:	0785                	addi	a5,a5,1
 33e:	97aa                	add	a5,a5,a0
  dst = vdst;
 340:	872a                	mv	a4,a0
      *dst++ = *src++;
 342:	0585                	addi	a1,a1,1
 344:	0705                	addi	a4,a4,1
 346:	fff5c683          	lbu	a3,-1(a1)
 34a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 34e:	fee79ae3          	bne	a5,a4,342 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 352:	6422                	ld	s0,8(sp)
 354:	0141                	addi	sp,sp,16
 356:	8082                	ret
    dst += n;
 358:	00c50733          	add	a4,a0,a2
    src += n;
 35c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 35e:	fec05ae3          	blez	a2,352 <memmove+0x2c>
 362:	fff6079b          	addiw	a5,a2,-1
 366:	1782                	slli	a5,a5,0x20
 368:	9381                	srli	a5,a5,0x20
 36a:	fff7c793          	not	a5,a5
 36e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 370:	15fd                	addi	a1,a1,-1
 372:	177d                	addi	a4,a4,-1
 374:	0005c683          	lbu	a3,0(a1)
 378:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 37c:	fee79ae3          	bne	a5,a4,370 <memmove+0x4a>
 380:	bfc9                	j	352 <memmove+0x2c>

0000000000000382 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 382:	1141                	addi	sp,sp,-16
 384:	e422                	sd	s0,8(sp)
 386:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 388:	ca05                	beqz	a2,3b8 <memcmp+0x36>
 38a:	fff6069b          	addiw	a3,a2,-1
 38e:	1682                	slli	a3,a3,0x20
 390:	9281                	srli	a3,a3,0x20
 392:	0685                	addi	a3,a3,1
 394:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 396:	00054783          	lbu	a5,0(a0)
 39a:	0005c703          	lbu	a4,0(a1)
 39e:	00e79863          	bne	a5,a4,3ae <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3a2:	0505                	addi	a0,a0,1
    p2++;
 3a4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3a6:	fed518e3          	bne	a0,a3,396 <memcmp+0x14>
  }
  return 0;
 3aa:	4501                	li	a0,0
 3ac:	a019                	j	3b2 <memcmp+0x30>
      return *p1 - *p2;
 3ae:	40e7853b          	subw	a0,a5,a4
}
 3b2:	6422                	ld	s0,8(sp)
 3b4:	0141                	addi	sp,sp,16
 3b6:	8082                	ret
  return 0;
 3b8:	4501                	li	a0,0
 3ba:	bfe5                	j	3b2 <memcmp+0x30>

00000000000003bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3bc:	1141                	addi	sp,sp,-16
 3be:	e406                	sd	ra,8(sp)
 3c0:	e022                	sd	s0,0(sp)
 3c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3c4:	00000097          	auipc	ra,0x0
 3c8:	f62080e7          	jalr	-158(ra) # 326 <memmove>
}
 3cc:	60a2                	ld	ra,8(sp)
 3ce:	6402                	ld	s0,0(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret

00000000000003d4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3d4:	4885                	li	a7,1
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <exit>:
.global exit
exit:
 li a7, SYS_exit
 3dc:	4889                	li	a7,2
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3e4:	488d                	li	a7,3
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ec:	4891                	li	a7,4
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <read>:
.global read
read:
 li a7, SYS_read
 3f4:	4895                	li	a7,5
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <write>:
.global write
write:
 li a7, SYS_write
 3fc:	48c1                	li	a7,16
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <close>:
.global close
close:
 li a7, SYS_close
 404:	48d5                	li	a7,21
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <kill>:
.global kill
kill:
 li a7, SYS_kill
 40c:	4899                	li	a7,6
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <exec>:
.global exec
exec:
 li a7, SYS_exec
 414:	489d                	li	a7,7
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <open>:
.global open
open:
 li a7, SYS_open
 41c:	48bd                	li	a7,15
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 424:	48c5                	li	a7,17
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 42c:	48c9                	li	a7,18
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 434:	48a1                	li	a7,8
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <link>:
.global link
link:
 li a7, SYS_link
 43c:	48cd                	li	a7,19
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 444:	48d1                	li	a7,20
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 44c:	48a5                	li	a7,9
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <dup>:
.global dup
dup:
 li a7, SYS_dup
 454:	48a9                	li	a7,10
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 45c:	48ad                	li	a7,11
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 464:	48b1                	li	a7,12
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 46c:	48b5                	li	a7,13
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 474:	48b9                	li	a7,14
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <trace>:
.global trace
trace:
 li a7, SYS_trace
 47c:	48d9                	li	a7,22
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 484:	48dd                	li	a7,23
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 48c:	1101                	addi	sp,sp,-32
 48e:	ec06                	sd	ra,24(sp)
 490:	e822                	sd	s0,16(sp)
 492:	1000                	addi	s0,sp,32
 494:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 498:	4605                	li	a2,1
 49a:	fef40593          	addi	a1,s0,-17
 49e:	00000097          	auipc	ra,0x0
 4a2:	f5e080e7          	jalr	-162(ra) # 3fc <write>
}
 4a6:	60e2                	ld	ra,24(sp)
 4a8:	6442                	ld	s0,16(sp)
 4aa:	6105                	addi	sp,sp,32
 4ac:	8082                	ret

00000000000004ae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ae:	7139                	addi	sp,sp,-64
 4b0:	fc06                	sd	ra,56(sp)
 4b2:	f822                	sd	s0,48(sp)
 4b4:	f426                	sd	s1,40(sp)
 4b6:	f04a                	sd	s2,32(sp)
 4b8:	ec4e                	sd	s3,24(sp)
 4ba:	0080                	addi	s0,sp,64
 4bc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4be:	c299                	beqz	a3,4c4 <printint+0x16>
 4c0:	0805c863          	bltz	a1,550 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c4:	2581                	sext.w	a1,a1
  neg = 0;
 4c6:	4881                	li	a7,0
 4c8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4cc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ce:	2601                	sext.w	a2,a2
 4d0:	00000517          	auipc	a0,0x0
 4d4:	47850513          	addi	a0,a0,1144 # 948 <digits>
 4d8:	883a                	mv	a6,a4
 4da:	2705                	addiw	a4,a4,1
 4dc:	02c5f7bb          	remuw	a5,a1,a2
 4e0:	1782                	slli	a5,a5,0x20
 4e2:	9381                	srli	a5,a5,0x20
 4e4:	97aa                	add	a5,a5,a0
 4e6:	0007c783          	lbu	a5,0(a5)
 4ea:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ee:	0005879b          	sext.w	a5,a1
 4f2:	02c5d5bb          	divuw	a1,a1,a2
 4f6:	0685                	addi	a3,a3,1
 4f8:	fec7f0e3          	bgeu	a5,a2,4d8 <printint+0x2a>
  if(neg)
 4fc:	00088b63          	beqz	a7,512 <printint+0x64>
    buf[i++] = '-';
 500:	fd040793          	addi	a5,s0,-48
 504:	973e                	add	a4,a4,a5
 506:	02d00793          	li	a5,45
 50a:	fef70823          	sb	a5,-16(a4)
 50e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 512:	02e05863          	blez	a4,542 <printint+0x94>
 516:	fc040793          	addi	a5,s0,-64
 51a:	00e78933          	add	s2,a5,a4
 51e:	fff78993          	addi	s3,a5,-1
 522:	99ba                	add	s3,s3,a4
 524:	377d                	addiw	a4,a4,-1
 526:	1702                	slli	a4,a4,0x20
 528:	9301                	srli	a4,a4,0x20
 52a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 52e:	fff94583          	lbu	a1,-1(s2)
 532:	8526                	mv	a0,s1
 534:	00000097          	auipc	ra,0x0
 538:	f58080e7          	jalr	-168(ra) # 48c <putc>
  while(--i >= 0)
 53c:	197d                	addi	s2,s2,-1
 53e:	ff3918e3          	bne	s2,s3,52e <printint+0x80>
}
 542:	70e2                	ld	ra,56(sp)
 544:	7442                	ld	s0,48(sp)
 546:	74a2                	ld	s1,40(sp)
 548:	7902                	ld	s2,32(sp)
 54a:	69e2                	ld	s3,24(sp)
 54c:	6121                	addi	sp,sp,64
 54e:	8082                	ret
    x = -xx;
 550:	40b005bb          	negw	a1,a1
    neg = 1;
 554:	4885                	li	a7,1
    x = -xx;
 556:	bf8d                	j	4c8 <printint+0x1a>

0000000000000558 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 558:	7119                	addi	sp,sp,-128
 55a:	fc86                	sd	ra,120(sp)
 55c:	f8a2                	sd	s0,112(sp)
 55e:	f4a6                	sd	s1,104(sp)
 560:	f0ca                	sd	s2,96(sp)
 562:	ecce                	sd	s3,88(sp)
 564:	e8d2                	sd	s4,80(sp)
 566:	e4d6                	sd	s5,72(sp)
 568:	e0da                	sd	s6,64(sp)
 56a:	fc5e                	sd	s7,56(sp)
 56c:	f862                	sd	s8,48(sp)
 56e:	f466                	sd	s9,40(sp)
 570:	f06a                	sd	s10,32(sp)
 572:	ec6e                	sd	s11,24(sp)
 574:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 576:	0005c903          	lbu	s2,0(a1)
 57a:	18090f63          	beqz	s2,718 <vprintf+0x1c0>
 57e:	8aaa                	mv	s5,a0
 580:	8b32                	mv	s6,a2
 582:	00158493          	addi	s1,a1,1
  state = 0;
 586:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 588:	02500a13          	li	s4,37
      if(c == 'd'){
 58c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 590:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 594:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 598:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 59c:	00000b97          	auipc	s7,0x0
 5a0:	3acb8b93          	addi	s7,s7,940 # 948 <digits>
 5a4:	a839                	j	5c2 <vprintf+0x6a>
        putc(fd, c);
 5a6:	85ca                	mv	a1,s2
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	ee2080e7          	jalr	-286(ra) # 48c <putc>
 5b2:	a019                	j	5b8 <vprintf+0x60>
    } else if(state == '%'){
 5b4:	01498f63          	beq	s3,s4,5d2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5b8:	0485                	addi	s1,s1,1
 5ba:	fff4c903          	lbu	s2,-1(s1)
 5be:	14090d63          	beqz	s2,718 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5c2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5c6:	fe0997e3          	bnez	s3,5b4 <vprintf+0x5c>
      if(c == '%'){
 5ca:	fd479ee3          	bne	a5,s4,5a6 <vprintf+0x4e>
        state = '%';
 5ce:	89be                	mv	s3,a5
 5d0:	b7e5                	j	5b8 <vprintf+0x60>
      if(c == 'd'){
 5d2:	05878063          	beq	a5,s8,612 <vprintf+0xba>
      } else if(c == 'l') {
 5d6:	05978c63          	beq	a5,s9,62e <vprintf+0xd6>
      } else if(c == 'x') {
 5da:	07a78863          	beq	a5,s10,64a <vprintf+0xf2>
      } else if(c == 'p') {
 5de:	09b78463          	beq	a5,s11,666 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5e2:	07300713          	li	a4,115
 5e6:	0ce78663          	beq	a5,a4,6b2 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ea:	06300713          	li	a4,99
 5ee:	0ee78e63          	beq	a5,a4,6ea <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5f2:	11478863          	beq	a5,s4,702 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f6:	85d2                	mv	a1,s4
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	e92080e7          	jalr	-366(ra) # 48c <putc>
        putc(fd, c);
 602:	85ca                	mv	a1,s2
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	e86080e7          	jalr	-378(ra) # 48c <putc>
      }
      state = 0;
 60e:	4981                	li	s3,0
 610:	b765                	j	5b8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 612:	008b0913          	addi	s2,s6,8
 616:	4685                	li	a3,1
 618:	4629                	li	a2,10
 61a:	000b2583          	lw	a1,0(s6)
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	e8e080e7          	jalr	-370(ra) # 4ae <printint>
 628:	8b4a                	mv	s6,s2
      state = 0;
 62a:	4981                	li	s3,0
 62c:	b771                	j	5b8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62e:	008b0913          	addi	s2,s6,8
 632:	4681                	li	a3,0
 634:	4629                	li	a2,10
 636:	000b2583          	lw	a1,0(s6)
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	e72080e7          	jalr	-398(ra) # 4ae <printint>
 644:	8b4a                	mv	s6,s2
      state = 0;
 646:	4981                	li	s3,0
 648:	bf85                	j	5b8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 64a:	008b0913          	addi	s2,s6,8
 64e:	4681                	li	a3,0
 650:	4641                	li	a2,16
 652:	000b2583          	lw	a1,0(s6)
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	e56080e7          	jalr	-426(ra) # 4ae <printint>
 660:	8b4a                	mv	s6,s2
      state = 0;
 662:	4981                	li	s3,0
 664:	bf91                	j	5b8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 666:	008b0793          	addi	a5,s6,8
 66a:	f8f43423          	sd	a5,-120(s0)
 66e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 672:	03000593          	li	a1,48
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	e14080e7          	jalr	-492(ra) # 48c <putc>
  putc(fd, 'x');
 680:	85ea                	mv	a1,s10
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	e08080e7          	jalr	-504(ra) # 48c <putc>
 68c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68e:	03c9d793          	srli	a5,s3,0x3c
 692:	97de                	add	a5,a5,s7
 694:	0007c583          	lbu	a1,0(a5)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	df2080e7          	jalr	-526(ra) # 48c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a2:	0992                	slli	s3,s3,0x4
 6a4:	397d                	addiw	s2,s2,-1
 6a6:	fe0914e3          	bnez	s2,68e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6aa:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	b721                	j	5b8 <vprintf+0x60>
        s = va_arg(ap, char*);
 6b2:	008b0993          	addi	s3,s6,8
 6b6:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6ba:	02090163          	beqz	s2,6dc <vprintf+0x184>
        while(*s != 0){
 6be:	00094583          	lbu	a1,0(s2)
 6c2:	c9a1                	beqz	a1,712 <vprintf+0x1ba>
          putc(fd, *s);
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	dc6080e7          	jalr	-570(ra) # 48c <putc>
          s++;
 6ce:	0905                	addi	s2,s2,1
        while(*s != 0){
 6d0:	00094583          	lbu	a1,0(s2)
 6d4:	f9e5                	bnez	a1,6c4 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6d6:	8b4e                	mv	s6,s3
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	bdf9                	j	5b8 <vprintf+0x60>
          s = "(null)";
 6dc:	00000917          	auipc	s2,0x0
 6e0:	26490913          	addi	s2,s2,612 # 940 <malloc+0x11e>
        while(*s != 0){
 6e4:	02800593          	li	a1,40
 6e8:	bff1                	j	6c4 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6ea:	008b0913          	addi	s2,s6,8
 6ee:	000b4583          	lbu	a1,0(s6)
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	d98080e7          	jalr	-616(ra) # 48c <putc>
 6fc:	8b4a                	mv	s6,s2
      state = 0;
 6fe:	4981                	li	s3,0
 700:	bd65                	j	5b8 <vprintf+0x60>
        putc(fd, c);
 702:	85d2                	mv	a1,s4
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	d86080e7          	jalr	-634(ra) # 48c <putc>
      state = 0;
 70e:	4981                	li	s3,0
 710:	b565                	j	5b8 <vprintf+0x60>
        s = va_arg(ap, char*);
 712:	8b4e                	mv	s6,s3
      state = 0;
 714:	4981                	li	s3,0
 716:	b54d                	j	5b8 <vprintf+0x60>
    }
  }
}
 718:	70e6                	ld	ra,120(sp)
 71a:	7446                	ld	s0,112(sp)
 71c:	74a6                	ld	s1,104(sp)
 71e:	7906                	ld	s2,96(sp)
 720:	69e6                	ld	s3,88(sp)
 722:	6a46                	ld	s4,80(sp)
 724:	6aa6                	ld	s5,72(sp)
 726:	6b06                	ld	s6,64(sp)
 728:	7be2                	ld	s7,56(sp)
 72a:	7c42                	ld	s8,48(sp)
 72c:	7ca2                	ld	s9,40(sp)
 72e:	7d02                	ld	s10,32(sp)
 730:	6de2                	ld	s11,24(sp)
 732:	6109                	addi	sp,sp,128
 734:	8082                	ret

0000000000000736 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 736:	715d                	addi	sp,sp,-80
 738:	ec06                	sd	ra,24(sp)
 73a:	e822                	sd	s0,16(sp)
 73c:	1000                	addi	s0,sp,32
 73e:	e010                	sd	a2,0(s0)
 740:	e414                	sd	a3,8(s0)
 742:	e818                	sd	a4,16(s0)
 744:	ec1c                	sd	a5,24(s0)
 746:	03043023          	sd	a6,32(s0)
 74a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 74e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 752:	8622                	mv	a2,s0
 754:	00000097          	auipc	ra,0x0
 758:	e04080e7          	jalr	-508(ra) # 558 <vprintf>
}
 75c:	60e2                	ld	ra,24(sp)
 75e:	6442                	ld	s0,16(sp)
 760:	6161                	addi	sp,sp,80
 762:	8082                	ret

0000000000000764 <printf>:

void
printf(const char *fmt, ...)
{
 764:	711d                	addi	sp,sp,-96
 766:	ec06                	sd	ra,24(sp)
 768:	e822                	sd	s0,16(sp)
 76a:	1000                	addi	s0,sp,32
 76c:	e40c                	sd	a1,8(s0)
 76e:	e810                	sd	a2,16(s0)
 770:	ec14                	sd	a3,24(s0)
 772:	f018                	sd	a4,32(s0)
 774:	f41c                	sd	a5,40(s0)
 776:	03043823          	sd	a6,48(s0)
 77a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 77e:	00840613          	addi	a2,s0,8
 782:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 786:	85aa                	mv	a1,a0
 788:	4505                	li	a0,1
 78a:	00000097          	auipc	ra,0x0
 78e:	dce080e7          	jalr	-562(ra) # 558 <vprintf>
}
 792:	60e2                	ld	ra,24(sp)
 794:	6442                	ld	s0,16(sp)
 796:	6125                	addi	sp,sp,96
 798:	8082                	ret

000000000000079a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79a:	1141                	addi	sp,sp,-16
 79c:	e422                	sd	s0,8(sp)
 79e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a4:	00000797          	auipc	a5,0x0
 7a8:	1bc7b783          	ld	a5,444(a5) # 960 <freep>
 7ac:	a805                	j	7dc <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ae:	4618                	lw	a4,8(a2)
 7b0:	9db9                	addw	a1,a1,a4
 7b2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b6:	6398                	ld	a4,0(a5)
 7b8:	6318                	ld	a4,0(a4)
 7ba:	fee53823          	sd	a4,-16(a0)
 7be:	a091                	j	802 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7c0:	ff852703          	lw	a4,-8(a0)
 7c4:	9e39                	addw	a2,a2,a4
 7c6:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7c8:	ff053703          	ld	a4,-16(a0)
 7cc:	e398                	sd	a4,0(a5)
 7ce:	a099                	j	814 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	6398                	ld	a4,0(a5)
 7d2:	00e7e463          	bltu	a5,a4,7da <free+0x40>
 7d6:	00e6ea63          	bltu	a3,a4,7ea <free+0x50>
{
 7da:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7dc:	fed7fae3          	bgeu	a5,a3,7d0 <free+0x36>
 7e0:	6398                	ld	a4,0(a5)
 7e2:	00e6e463          	bltu	a3,a4,7ea <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e6:	fee7eae3          	bltu	a5,a4,7da <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7ea:	ff852583          	lw	a1,-8(a0)
 7ee:	6390                	ld	a2,0(a5)
 7f0:	02059713          	slli	a4,a1,0x20
 7f4:	9301                	srli	a4,a4,0x20
 7f6:	0712                	slli	a4,a4,0x4
 7f8:	9736                	add	a4,a4,a3
 7fa:	fae60ae3          	beq	a2,a4,7ae <free+0x14>
    bp->s.ptr = p->s.ptr;
 7fe:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 802:	4790                	lw	a2,8(a5)
 804:	02061713          	slli	a4,a2,0x20
 808:	9301                	srli	a4,a4,0x20
 80a:	0712                	slli	a4,a4,0x4
 80c:	973e                	add	a4,a4,a5
 80e:	fae689e3          	beq	a3,a4,7c0 <free+0x26>
  } else
    p->s.ptr = bp;
 812:	e394                	sd	a3,0(a5)
  freep = p;
 814:	00000717          	auipc	a4,0x0
 818:	14f73623          	sd	a5,332(a4) # 960 <freep>
}
 81c:	6422                	ld	s0,8(sp)
 81e:	0141                	addi	sp,sp,16
 820:	8082                	ret

0000000000000822 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 822:	7139                	addi	sp,sp,-64
 824:	fc06                	sd	ra,56(sp)
 826:	f822                	sd	s0,48(sp)
 828:	f426                	sd	s1,40(sp)
 82a:	f04a                	sd	s2,32(sp)
 82c:	ec4e                	sd	s3,24(sp)
 82e:	e852                	sd	s4,16(sp)
 830:	e456                	sd	s5,8(sp)
 832:	e05a                	sd	s6,0(sp)
 834:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 836:	02051493          	slli	s1,a0,0x20
 83a:	9081                	srli	s1,s1,0x20
 83c:	04bd                	addi	s1,s1,15
 83e:	8091                	srli	s1,s1,0x4
 840:	0014899b          	addiw	s3,s1,1
 844:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 846:	00000517          	auipc	a0,0x0
 84a:	11a53503          	ld	a0,282(a0) # 960 <freep>
 84e:	c515                	beqz	a0,87a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 850:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 852:	4798                	lw	a4,8(a5)
 854:	02977f63          	bgeu	a4,s1,892 <malloc+0x70>
 858:	8a4e                	mv	s4,s3
 85a:	0009871b          	sext.w	a4,s3
 85e:	6685                	lui	a3,0x1
 860:	00d77363          	bgeu	a4,a3,866 <malloc+0x44>
 864:	6a05                	lui	s4,0x1
 866:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 86a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 86e:	00000917          	auipc	s2,0x0
 872:	0f290913          	addi	s2,s2,242 # 960 <freep>
  if(p == (char*)-1)
 876:	5afd                	li	s5,-1
 878:	a88d                	j	8ea <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 87a:	00000797          	auipc	a5,0x0
 87e:	0ee78793          	addi	a5,a5,238 # 968 <base>
 882:	00000717          	auipc	a4,0x0
 886:	0cf73f23          	sd	a5,222(a4) # 960 <freep>
 88a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 88c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 890:	b7e1                	j	858 <malloc+0x36>
      if(p->s.size == nunits)
 892:	02e48b63          	beq	s1,a4,8c8 <malloc+0xa6>
        p->s.size -= nunits;
 896:	4137073b          	subw	a4,a4,s3
 89a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 89c:	1702                	slli	a4,a4,0x20
 89e:	9301                	srli	a4,a4,0x20
 8a0:	0712                	slli	a4,a4,0x4
 8a2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a8:	00000717          	auipc	a4,0x0
 8ac:	0aa73c23          	sd	a0,184(a4) # 960 <freep>
      return (void*)(p + 1);
 8b0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8b4:	70e2                	ld	ra,56(sp)
 8b6:	7442                	ld	s0,48(sp)
 8b8:	74a2                	ld	s1,40(sp)
 8ba:	7902                	ld	s2,32(sp)
 8bc:	69e2                	ld	s3,24(sp)
 8be:	6a42                	ld	s4,16(sp)
 8c0:	6aa2                	ld	s5,8(sp)
 8c2:	6b02                	ld	s6,0(sp)
 8c4:	6121                	addi	sp,sp,64
 8c6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8c8:	6398                	ld	a4,0(a5)
 8ca:	e118                	sd	a4,0(a0)
 8cc:	bff1                	j	8a8 <malloc+0x86>
  hp->s.size = nu;
 8ce:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d2:	0541                	addi	a0,a0,16
 8d4:	00000097          	auipc	ra,0x0
 8d8:	ec6080e7          	jalr	-314(ra) # 79a <free>
  return freep;
 8dc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8e0:	d971                	beqz	a0,8b4 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e4:	4798                	lw	a4,8(a5)
 8e6:	fa9776e3          	bgeu	a4,s1,892 <malloc+0x70>
    if(p == freep)
 8ea:	00093703          	ld	a4,0(s2)
 8ee:	853e                	mv	a0,a5
 8f0:	fef719e3          	bne	a4,a5,8e2 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8f4:	8552                	mv	a0,s4
 8f6:	00000097          	auipc	ra,0x0
 8fa:	b6e080e7          	jalr	-1170(ra) # 464 <sbrk>
  if(p == (char*)-1)
 8fe:	fd5518e3          	bne	a0,s5,8ce <malloc+0xac>
        return 0;
 902:	4501                	li	a0,0
 904:	bf45                	j	8b4 <malloc+0x92>
