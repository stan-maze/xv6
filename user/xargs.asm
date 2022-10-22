
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getline>:
#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int getline(char* parm){
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	0080                	addi	s0,sp,64
   e:	89aa                	mv	s3,a0
    char ch;
    // 取一个parm起始位置的指针，便于操作
    char* tmp = parm;
  10:	84aa                	mv	s1,a0
    while (read(0, &ch, 1) == 1)
    {
        // 换行符作为终结
        if(ch == '\n'){
  12:	4929                	li	s2,10
    while (read(0, &ch, 1) == 1)
  14:	4605                	li	a2,1
  16:	fcf40593          	addi	a1,s0,-49
  1a:	4501                	li	a0,0
  1c:	00000097          	auipc	ra,0x0
  20:	3fe080e7          	jalr	1022(ra) # 41a <read>
  24:	4785                	li	a5,1
  26:	02f51363          	bne	a0,a5,4c <getline+0x4c>
        if(ch == '\n'){
  2a:	fcf44783          	lbu	a5,-49(s0)
  2e:	01278663          	beq	a5,s2,3a <getline+0x3a>
                *(tmp) = ' ';
                *(tmp+1) = '\0';
                return 1;
            }
        }
        *tmp = ch;
  32:	00f48023          	sb	a5,0(s1)
        tmp++;
  36:	0485                	addi	s1,s1,1
  38:	bff1                	j	14 <getline+0x14>
            if(parm == tmp)
  3a:	03348163          	beq	s1,s3,5c <getline+0x5c>
                *(tmp) = ' ';
  3e:	02000793          	li	a5,32
  42:	00f48023          	sb	a5,0(s1)
                *(tmp+1) = '\0';
  46:	000480a3          	sb	zero,1(s1)
                return 1;
  4a:	a011                	j	4e <getline+0x4e>
    }
    return 0;
  4c:	4501                	li	a0,0
}
  4e:	70e2                	ld	ra,56(sp)
  50:	7442                	ld	s0,48(sp)
  52:	74a2                	ld	s1,40(sp)
  54:	7902                	ld	s2,32(sp)
  56:	69e2                	ld	s3,24(sp)
  58:	6121                	addi	sp,sp,64
  5a:	8082                	ret
                return 0;
  5c:	4501                	li	a0,0
  5e:	bfc5                	j	4e <getline+0x4e>

0000000000000060 <main>:

int
main(int argc, char* argv[])
{
  60:	7105                	addi	sp,sp,-480
  62:	ef86                	sd	ra,472(sp)
  64:	eba2                	sd	s0,464(sp)
  66:	e7a6                	sd	s1,456(sp)
  68:	e3ca                	sd	s2,448(sp)
  6a:	ff4e                	sd	s3,440(sp)
  6c:	fb52                	sd	s4,432(sp)
  6e:	f756                	sd	s5,424(sp)
  70:	f35a                	sd	s6,416(sp)
  72:	1380                	addi	s0,sp,480
    char parm[128];
    while (getline(parm)){
        char cmd_name[32];
        char* cmd_args[32];
        int pre = 0;
        int cnt = -1;
  74:	59fd                	li	s3,-1
                // 第一个程序名称记录下来
                if(cnt == -1){
                    memmove(cmd_name,parm,i);
                    pre = ++i;
                    cnt++;
                    cmd_args[cnt++] = cmd_name;
  76:	4a05                	li	s4,1
    while (getline(parm)){
  78:	a0e9                	j	142 <main+0xe2>
                    memmove(cmd_name,parm,i);
  7a:	8626                	mv	a2,s1
  7c:	f4040593          	addi	a1,s0,-192
  80:	e2040513          	addi	a0,s0,-480
  84:	00000097          	auipc	ra,0x0
  88:	2c8080e7          	jalr	712(ra) # 34c <memmove>
                    pre = ++i;
  8c:	0014871b          	addiw	a4,s1,1
                    cmd_args[cnt++] = cmd_name;
  90:	e2040793          	addi	a5,s0,-480
  94:	e4f43023          	sd	a5,-448(s0)
                    pre = ++i;
  98:	84ba                	mv	s1,a4
                    cmd_args[cnt++] = cmd_name;
  9a:	86d2                	mv	a3,s4
        for(int i=0;i<len;i++){
  9c:	2485                	addiw	s1,s1,1
  9e:	0324df63          	bge	s1,s2,dc <main+0x7c>
            if(parm[i] == ' '){
  a2:	fc040793          	addi	a5,s0,-64
  a6:	97a6                	add	a5,a5,s1
  a8:	f807c783          	lbu	a5,-128(a5)
  ac:	ff6798e3          	bne	a5,s6,9c <main+0x3c>
                parm[i] = '\0';
  b0:	fc040793          	addi	a5,s0,-64
  b4:	97a6                	add	a5,a5,s1
  b6:	f8078023          	sb	zero,-128(a5)
                if(cnt == -1){
  ba:	fd3680e3          	beq	a3,s3,7a <main+0x1a>
                }
                else{
                    // 分段取得参数
                    cmd_args[cnt++] = parm+pre;
  be:	00369793          	slli	a5,a3,0x3
  c2:	fc040613          	addi	a2,s0,-64
  c6:	97b2                	add	a5,a5,a2
  c8:	f4040613          	addi	a2,s0,-192
  cc:	9732                	add	a4,a4,a2
  ce:	e8e7b023          	sd	a4,-384(a5)
                    pre = ++i;
  d2:	0014871b          	addiw	a4,s1,1
  d6:	84ba                	mv	s1,a4
                    cmd_args[cnt++] = parm+pre;
  d8:	2685                	addiw	a3,a3,1
  da:	b7c9                	j	9c <main+0x3c>
                }
            }
        }
        for(int i=len;i<128;i++) parm[i] = '\0';
  dc:	07f00793          	li	a5,127
  e0:	0327c563          	blt	a5,s2,10a <main+0xaa>
  e4:	f4040793          	addi	a5,s0,-192
  e8:	97ca                	add	a5,a5,s2
  ea:	f4140713          	addi	a4,s0,-191
  ee:	993a                	add	s2,s2,a4
  f0:	07f00713          	li	a4,127
  f4:	41570abb          	subw	s5,a4,s5
  f8:	1a82                	slli	s5,s5,0x20
  fa:	020ada93          	srli	s5,s5,0x20
  fe:	9956                	add	s2,s2,s5
 100:	00078023          	sb	zero,0(a5)
 104:	0785                	addi	a5,a5,1
 106:	ff279de3          	bne	a5,s2,100 <main+0xa0>
        // fork子进程exec即可
        if(!fork()) exec(cmd_name,cmd_args);
 10a:	00000097          	auipc	ra,0x0
 10e:	2f0080e7          	jalr	752(ra) # 3fa <fork>
 112:	c125                	beqz	a0,172 <main+0x112>
        wait(0);
 114:	4501                	li	a0,0
 116:	00000097          	auipc	ra,0x0
 11a:	2f4080e7          	jalr	756(ra) # 40a <wait>
        memset(parm,0,128);
 11e:	08000613          	li	a2,128
 122:	4581                	li	a1,0
 124:	f4040513          	addi	a0,s0,-192
 128:	00000097          	auipc	ra,0x0
 12c:	0d6080e7          	jalr	214(ra) # 1fe <memset>
        memset(cmd_name,0,32);
 130:	02000613          	li	a2,32
 134:	4581                	li	a1,0
 136:	e2040513          	addi	a0,s0,-480
 13a:	00000097          	auipc	ra,0x0
 13e:	0c4080e7          	jalr	196(ra) # 1fe <memset>
    while (getline(parm)){
 142:	f4040513          	addi	a0,s0,-192
 146:	00000097          	auipc	ra,0x0
 14a:	eba080e7          	jalr	-326(ra) # 0 <getline>
 14e:	c91d                	beqz	a0,184 <main+0x124>
        int len = strlen(parm);
 150:	f4040513          	addi	a0,s0,-192
 154:	00000097          	auipc	ra,0x0
 158:	080080e7          	jalr	128(ra) # 1d4 <strlen>
 15c:	00050a9b          	sext.w	s5,a0
 160:	8956                	mv	s2,s5
        for(int i=0;i<len;i++){
 162:	f7505de3          	blez	s5,dc <main+0x7c>
 166:	4481                	li	s1,0
        int cnt = -1;
 168:	86ce                	mv	a3,s3
        int pre = 0;
 16a:	4701                	li	a4,0
            if(parm[i] == ' '){
 16c:	02000b13          	li	s6,32
 170:	bf0d                	j	a2 <main+0x42>
        if(!fork()) exec(cmd_name,cmd_args);
 172:	e4040593          	addi	a1,s0,-448
 176:	e2040513          	addi	a0,s0,-480
 17a:	00000097          	auipc	ra,0x0
 17e:	2c0080e7          	jalr	704(ra) # 43a <exec>
 182:	bf49                	j	114 <main+0xb4>
    }
  exit(0);
 184:	00000097          	auipc	ra,0x0
 188:	27e080e7          	jalr	638(ra) # 402 <exit>

000000000000018c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 192:	87aa                	mv	a5,a0
 194:	0585                	addi	a1,a1,1
 196:	0785                	addi	a5,a5,1
 198:	fff5c703          	lbu	a4,-1(a1)
 19c:	fee78fa3          	sb	a4,-1(a5)
 1a0:	fb75                	bnez	a4,194 <strcpy+0x8>
    ;
  return os;
}
 1a2:	6422                	ld	s0,8(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e422                	sd	s0,8(sp)
 1ac:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	cb91                	beqz	a5,1c6 <strcmp+0x1e>
 1b4:	0005c703          	lbu	a4,0(a1)
 1b8:	00f71763          	bne	a4,a5,1c6 <strcmp+0x1e>
    p++, q++;
 1bc:	0505                	addi	a0,a0,1
 1be:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	fbe5                	bnez	a5,1b4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1c6:	0005c503          	lbu	a0,0(a1)
}
 1ca:	40a7853b          	subw	a0,a5,a0
 1ce:	6422                	ld	s0,8(sp)
 1d0:	0141                	addi	sp,sp,16
 1d2:	8082                	ret

00000000000001d4 <strlen>:

uint
strlen(const char *s)
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1da:	00054783          	lbu	a5,0(a0)
 1de:	cf91                	beqz	a5,1fa <strlen+0x26>
 1e0:	0505                	addi	a0,a0,1
 1e2:	87aa                	mv	a5,a0
 1e4:	4685                	li	a3,1
 1e6:	9e89                	subw	a3,a3,a0
 1e8:	00f6853b          	addw	a0,a3,a5
 1ec:	0785                	addi	a5,a5,1
 1ee:	fff7c703          	lbu	a4,-1(a5)
 1f2:	fb7d                	bnez	a4,1e8 <strlen+0x14>
    ;
  return n;
}
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret
  for(n = 0; s[n]; n++)
 1fa:	4501                	li	a0,0
 1fc:	bfe5                	j	1f4 <strlen+0x20>

00000000000001fe <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 204:	ce09                	beqz	a2,21e <memset+0x20>
 206:	87aa                	mv	a5,a0
 208:	fff6071b          	addiw	a4,a2,-1
 20c:	1702                	slli	a4,a4,0x20
 20e:	9301                	srli	a4,a4,0x20
 210:	0705                	addi	a4,a4,1
 212:	972a                	add	a4,a4,a0
    cdst[i] = c;
 214:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 218:	0785                	addi	a5,a5,1
 21a:	fee79de3          	bne	a5,a4,214 <memset+0x16>
  }
  return dst;
}
 21e:	6422                	ld	s0,8(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret

0000000000000224 <strchr>:

char*
strchr(const char *s, char c)
{
 224:	1141                	addi	sp,sp,-16
 226:	e422                	sd	s0,8(sp)
 228:	0800                	addi	s0,sp,16
  for(; *s; s++)
 22a:	00054783          	lbu	a5,0(a0)
 22e:	cb99                	beqz	a5,244 <strchr+0x20>
    if(*s == c)
 230:	00f58763          	beq	a1,a5,23e <strchr+0x1a>
  for(; *s; s++)
 234:	0505                	addi	a0,a0,1
 236:	00054783          	lbu	a5,0(a0)
 23a:	fbfd                	bnez	a5,230 <strchr+0xc>
      return (char*)s;
  return 0;
 23c:	4501                	li	a0,0
}
 23e:	6422                	ld	s0,8(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret
  return 0;
 244:	4501                	li	a0,0
 246:	bfe5                	j	23e <strchr+0x1a>

0000000000000248 <gets>:

char*
gets(char *buf, int max)
{
 248:	711d                	addi	sp,sp,-96
 24a:	ec86                	sd	ra,88(sp)
 24c:	e8a2                	sd	s0,80(sp)
 24e:	e4a6                	sd	s1,72(sp)
 250:	e0ca                	sd	s2,64(sp)
 252:	fc4e                	sd	s3,56(sp)
 254:	f852                	sd	s4,48(sp)
 256:	f456                	sd	s5,40(sp)
 258:	f05a                	sd	s6,32(sp)
 25a:	ec5e                	sd	s7,24(sp)
 25c:	1080                	addi	s0,sp,96
 25e:	8baa                	mv	s7,a0
 260:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 262:	892a                	mv	s2,a0
 264:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 266:	4aa9                	li	s5,10
 268:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 26a:	89a6                	mv	s3,s1
 26c:	2485                	addiw	s1,s1,1
 26e:	0344d863          	bge	s1,s4,29e <gets+0x56>
    cc = read(0, &c, 1);
 272:	4605                	li	a2,1
 274:	faf40593          	addi	a1,s0,-81
 278:	4501                	li	a0,0
 27a:	00000097          	auipc	ra,0x0
 27e:	1a0080e7          	jalr	416(ra) # 41a <read>
    if(cc < 1)
 282:	00a05e63          	blez	a0,29e <gets+0x56>
    buf[i++] = c;
 286:	faf44783          	lbu	a5,-81(s0)
 28a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 28e:	01578763          	beq	a5,s5,29c <gets+0x54>
 292:	0905                	addi	s2,s2,1
 294:	fd679be3          	bne	a5,s6,26a <gets+0x22>
  for(i=0; i+1 < max; ){
 298:	89a6                	mv	s3,s1
 29a:	a011                	j	29e <gets+0x56>
 29c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 29e:	99de                	add	s3,s3,s7
 2a0:	00098023          	sb	zero,0(s3)
  return buf;
}
 2a4:	855e                	mv	a0,s7
 2a6:	60e6                	ld	ra,88(sp)
 2a8:	6446                	ld	s0,80(sp)
 2aa:	64a6                	ld	s1,72(sp)
 2ac:	6906                	ld	s2,64(sp)
 2ae:	79e2                	ld	s3,56(sp)
 2b0:	7a42                	ld	s4,48(sp)
 2b2:	7aa2                	ld	s5,40(sp)
 2b4:	7b02                	ld	s6,32(sp)
 2b6:	6be2                	ld	s7,24(sp)
 2b8:	6125                	addi	sp,sp,96
 2ba:	8082                	ret

00000000000002bc <stat>:

int
stat(const char *n, struct stat *st)
{
 2bc:	1101                	addi	sp,sp,-32
 2be:	ec06                	sd	ra,24(sp)
 2c0:	e822                	sd	s0,16(sp)
 2c2:	e426                	sd	s1,8(sp)
 2c4:	e04a                	sd	s2,0(sp)
 2c6:	1000                	addi	s0,sp,32
 2c8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ca:	4581                	li	a1,0
 2cc:	00000097          	auipc	ra,0x0
 2d0:	176080e7          	jalr	374(ra) # 442 <open>
  if(fd < 0)
 2d4:	02054563          	bltz	a0,2fe <stat+0x42>
 2d8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2da:	85ca                	mv	a1,s2
 2dc:	00000097          	auipc	ra,0x0
 2e0:	17e080e7          	jalr	382(ra) # 45a <fstat>
 2e4:	892a                	mv	s2,a0
  close(fd);
 2e6:	8526                	mv	a0,s1
 2e8:	00000097          	auipc	ra,0x0
 2ec:	142080e7          	jalr	322(ra) # 42a <close>
  return r;
}
 2f0:	854a                	mv	a0,s2
 2f2:	60e2                	ld	ra,24(sp)
 2f4:	6442                	ld	s0,16(sp)
 2f6:	64a2                	ld	s1,8(sp)
 2f8:	6902                	ld	s2,0(sp)
 2fa:	6105                	addi	sp,sp,32
 2fc:	8082                	ret
    return -1;
 2fe:	597d                	li	s2,-1
 300:	bfc5                	j	2f0 <stat+0x34>

0000000000000302 <atoi>:

int
atoi(const char *s)
{
 302:	1141                	addi	sp,sp,-16
 304:	e422                	sd	s0,8(sp)
 306:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 308:	00054603          	lbu	a2,0(a0)
 30c:	fd06079b          	addiw	a5,a2,-48
 310:	0ff7f793          	andi	a5,a5,255
 314:	4725                	li	a4,9
 316:	02f76963          	bltu	a4,a5,348 <atoi+0x46>
 31a:	86aa                	mv	a3,a0
  n = 0;
 31c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 31e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 320:	0685                	addi	a3,a3,1
 322:	0025179b          	slliw	a5,a0,0x2
 326:	9fa9                	addw	a5,a5,a0
 328:	0017979b          	slliw	a5,a5,0x1
 32c:	9fb1                	addw	a5,a5,a2
 32e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 332:	0006c603          	lbu	a2,0(a3)
 336:	fd06071b          	addiw	a4,a2,-48
 33a:	0ff77713          	andi	a4,a4,255
 33e:	fee5f1e3          	bgeu	a1,a4,320 <atoi+0x1e>
  return n;
}
 342:	6422                	ld	s0,8(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret
  n = 0;
 348:	4501                	li	a0,0
 34a:	bfe5                	j	342 <atoi+0x40>

000000000000034c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e422                	sd	s0,8(sp)
 350:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 352:	02b57663          	bgeu	a0,a1,37e <memmove+0x32>
    while(n-- > 0)
 356:	02c05163          	blez	a2,378 <memmove+0x2c>
 35a:	fff6079b          	addiw	a5,a2,-1
 35e:	1782                	slli	a5,a5,0x20
 360:	9381                	srli	a5,a5,0x20
 362:	0785                	addi	a5,a5,1
 364:	97aa                	add	a5,a5,a0
  dst = vdst;
 366:	872a                	mv	a4,a0
      *dst++ = *src++;
 368:	0585                	addi	a1,a1,1
 36a:	0705                	addi	a4,a4,1
 36c:	fff5c683          	lbu	a3,-1(a1)
 370:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 374:	fee79ae3          	bne	a5,a4,368 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 378:	6422                	ld	s0,8(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret
    dst += n;
 37e:	00c50733          	add	a4,a0,a2
    src += n;
 382:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 384:	fec05ae3          	blez	a2,378 <memmove+0x2c>
 388:	fff6079b          	addiw	a5,a2,-1
 38c:	1782                	slli	a5,a5,0x20
 38e:	9381                	srli	a5,a5,0x20
 390:	fff7c793          	not	a5,a5
 394:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 396:	15fd                	addi	a1,a1,-1
 398:	177d                	addi	a4,a4,-1
 39a:	0005c683          	lbu	a3,0(a1)
 39e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3a2:	fee79ae3          	bne	a5,a4,396 <memmove+0x4a>
 3a6:	bfc9                	j	378 <memmove+0x2c>

00000000000003a8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3a8:	1141                	addi	sp,sp,-16
 3aa:	e422                	sd	s0,8(sp)
 3ac:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3ae:	ca05                	beqz	a2,3de <memcmp+0x36>
 3b0:	fff6069b          	addiw	a3,a2,-1
 3b4:	1682                	slli	a3,a3,0x20
 3b6:	9281                	srli	a3,a3,0x20
 3b8:	0685                	addi	a3,a3,1
 3ba:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3bc:	00054783          	lbu	a5,0(a0)
 3c0:	0005c703          	lbu	a4,0(a1)
 3c4:	00e79863          	bne	a5,a4,3d4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3c8:	0505                	addi	a0,a0,1
    p2++;
 3ca:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3cc:	fed518e3          	bne	a0,a3,3bc <memcmp+0x14>
  }
  return 0;
 3d0:	4501                	li	a0,0
 3d2:	a019                	j	3d8 <memcmp+0x30>
      return *p1 - *p2;
 3d4:	40e7853b          	subw	a0,a5,a4
}
 3d8:	6422                	ld	s0,8(sp)
 3da:	0141                	addi	sp,sp,16
 3dc:	8082                	ret
  return 0;
 3de:	4501                	li	a0,0
 3e0:	bfe5                	j	3d8 <memcmp+0x30>

00000000000003e2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3e2:	1141                	addi	sp,sp,-16
 3e4:	e406                	sd	ra,8(sp)
 3e6:	e022                	sd	s0,0(sp)
 3e8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ea:	00000097          	auipc	ra,0x0
 3ee:	f62080e7          	jalr	-158(ra) # 34c <memmove>
}
 3f2:	60a2                	ld	ra,8(sp)
 3f4:	6402                	ld	s0,0(sp)
 3f6:	0141                	addi	sp,sp,16
 3f8:	8082                	ret

00000000000003fa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3fa:	4885                	li	a7,1
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <exit>:
.global exit
exit:
 li a7, SYS_exit
 402:	4889                	li	a7,2
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <wait>:
.global wait
wait:
 li a7, SYS_wait
 40a:	488d                	li	a7,3
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 412:	4891                	li	a7,4
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <read>:
.global read
read:
 li a7, SYS_read
 41a:	4895                	li	a7,5
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <write>:
.global write
write:
 li a7, SYS_write
 422:	48c1                	li	a7,16
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <close>:
.global close
close:
 li a7, SYS_close
 42a:	48d5                	li	a7,21
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <kill>:
.global kill
kill:
 li a7, SYS_kill
 432:	4899                	li	a7,6
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <exec>:
.global exec
exec:
 li a7, SYS_exec
 43a:	489d                	li	a7,7
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <open>:
.global open
open:
 li a7, SYS_open
 442:	48bd                	li	a7,15
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 44a:	48c5                	li	a7,17
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 452:	48c9                	li	a7,18
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 45a:	48a1                	li	a7,8
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <link>:
.global link
link:
 li a7, SYS_link
 462:	48cd                	li	a7,19
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 46a:	48d1                	li	a7,20
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 472:	48a5                	li	a7,9
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <dup>:
.global dup
dup:
 li a7, SYS_dup
 47a:	48a9                	li	a7,10
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 482:	48ad                	li	a7,11
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 48a:	48b1                	li	a7,12
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 492:	48b5                	li	a7,13
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 49a:	48b9                	li	a7,14
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <trace>:
.global trace
trace:
 li a7, SYS_trace
 4a2:	48d9                	li	a7,22
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 4aa:	48dd                	li	a7,23
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4b2:	1101                	addi	sp,sp,-32
 4b4:	ec06                	sd	ra,24(sp)
 4b6:	e822                	sd	s0,16(sp)
 4b8:	1000                	addi	s0,sp,32
 4ba:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4be:	4605                	li	a2,1
 4c0:	fef40593          	addi	a1,s0,-17
 4c4:	00000097          	auipc	ra,0x0
 4c8:	f5e080e7          	jalr	-162(ra) # 422 <write>
}
 4cc:	60e2                	ld	ra,24(sp)
 4ce:	6442                	ld	s0,16(sp)
 4d0:	6105                	addi	sp,sp,32
 4d2:	8082                	ret

00000000000004d4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4d4:	7139                	addi	sp,sp,-64
 4d6:	fc06                	sd	ra,56(sp)
 4d8:	f822                	sd	s0,48(sp)
 4da:	f426                	sd	s1,40(sp)
 4dc:	f04a                	sd	s2,32(sp)
 4de:	ec4e                	sd	s3,24(sp)
 4e0:	0080                	addi	s0,sp,64
 4e2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4e4:	c299                	beqz	a3,4ea <printint+0x16>
 4e6:	0805c863          	bltz	a1,576 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4ea:	2581                	sext.w	a1,a1
  neg = 0;
 4ec:	4881                	li	a7,0
 4ee:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4f2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4f4:	2601                	sext.w	a2,a2
 4f6:	00000517          	auipc	a0,0x0
 4fa:	44250513          	addi	a0,a0,1090 # 938 <digits>
 4fe:	883a                	mv	a6,a4
 500:	2705                	addiw	a4,a4,1
 502:	02c5f7bb          	remuw	a5,a1,a2
 506:	1782                	slli	a5,a5,0x20
 508:	9381                	srli	a5,a5,0x20
 50a:	97aa                	add	a5,a5,a0
 50c:	0007c783          	lbu	a5,0(a5)
 510:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 514:	0005879b          	sext.w	a5,a1
 518:	02c5d5bb          	divuw	a1,a1,a2
 51c:	0685                	addi	a3,a3,1
 51e:	fec7f0e3          	bgeu	a5,a2,4fe <printint+0x2a>
  if(neg)
 522:	00088b63          	beqz	a7,538 <printint+0x64>
    buf[i++] = '-';
 526:	fd040793          	addi	a5,s0,-48
 52a:	973e                	add	a4,a4,a5
 52c:	02d00793          	li	a5,45
 530:	fef70823          	sb	a5,-16(a4)
 534:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 538:	02e05863          	blez	a4,568 <printint+0x94>
 53c:	fc040793          	addi	a5,s0,-64
 540:	00e78933          	add	s2,a5,a4
 544:	fff78993          	addi	s3,a5,-1
 548:	99ba                	add	s3,s3,a4
 54a:	377d                	addiw	a4,a4,-1
 54c:	1702                	slli	a4,a4,0x20
 54e:	9301                	srli	a4,a4,0x20
 550:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 554:	fff94583          	lbu	a1,-1(s2)
 558:	8526                	mv	a0,s1
 55a:	00000097          	auipc	ra,0x0
 55e:	f58080e7          	jalr	-168(ra) # 4b2 <putc>
  while(--i >= 0)
 562:	197d                	addi	s2,s2,-1
 564:	ff3918e3          	bne	s2,s3,554 <printint+0x80>
}
 568:	70e2                	ld	ra,56(sp)
 56a:	7442                	ld	s0,48(sp)
 56c:	74a2                	ld	s1,40(sp)
 56e:	7902                	ld	s2,32(sp)
 570:	69e2                	ld	s3,24(sp)
 572:	6121                	addi	sp,sp,64
 574:	8082                	ret
    x = -xx;
 576:	40b005bb          	negw	a1,a1
    neg = 1;
 57a:	4885                	li	a7,1
    x = -xx;
 57c:	bf8d                	j	4ee <printint+0x1a>

000000000000057e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 57e:	7119                	addi	sp,sp,-128
 580:	fc86                	sd	ra,120(sp)
 582:	f8a2                	sd	s0,112(sp)
 584:	f4a6                	sd	s1,104(sp)
 586:	f0ca                	sd	s2,96(sp)
 588:	ecce                	sd	s3,88(sp)
 58a:	e8d2                	sd	s4,80(sp)
 58c:	e4d6                	sd	s5,72(sp)
 58e:	e0da                	sd	s6,64(sp)
 590:	fc5e                	sd	s7,56(sp)
 592:	f862                	sd	s8,48(sp)
 594:	f466                	sd	s9,40(sp)
 596:	f06a                	sd	s10,32(sp)
 598:	ec6e                	sd	s11,24(sp)
 59a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 59c:	0005c903          	lbu	s2,0(a1)
 5a0:	18090f63          	beqz	s2,73e <vprintf+0x1c0>
 5a4:	8aaa                	mv	s5,a0
 5a6:	8b32                	mv	s6,a2
 5a8:	00158493          	addi	s1,a1,1
  state = 0;
 5ac:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5ae:	02500a13          	li	s4,37
      if(c == 'd'){
 5b2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5b6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5ba:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5be:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c2:	00000b97          	auipc	s7,0x0
 5c6:	376b8b93          	addi	s7,s7,886 # 938 <digits>
 5ca:	a839                	j	5e8 <vprintf+0x6a>
        putc(fd, c);
 5cc:	85ca                	mv	a1,s2
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	ee2080e7          	jalr	-286(ra) # 4b2 <putc>
 5d8:	a019                	j	5de <vprintf+0x60>
    } else if(state == '%'){
 5da:	01498f63          	beq	s3,s4,5f8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5de:	0485                	addi	s1,s1,1
 5e0:	fff4c903          	lbu	s2,-1(s1)
 5e4:	14090d63          	beqz	s2,73e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5e8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5ec:	fe0997e3          	bnez	s3,5da <vprintf+0x5c>
      if(c == '%'){
 5f0:	fd479ee3          	bne	a5,s4,5cc <vprintf+0x4e>
        state = '%';
 5f4:	89be                	mv	s3,a5
 5f6:	b7e5                	j	5de <vprintf+0x60>
      if(c == 'd'){
 5f8:	05878063          	beq	a5,s8,638 <vprintf+0xba>
      } else if(c == 'l') {
 5fc:	05978c63          	beq	a5,s9,654 <vprintf+0xd6>
      } else if(c == 'x') {
 600:	07a78863          	beq	a5,s10,670 <vprintf+0xf2>
      } else if(c == 'p') {
 604:	09b78463          	beq	a5,s11,68c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 608:	07300713          	li	a4,115
 60c:	0ce78663          	beq	a5,a4,6d8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 610:	06300713          	li	a4,99
 614:	0ee78e63          	beq	a5,a4,710 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 618:	11478863          	beq	a5,s4,728 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 61c:	85d2                	mv	a1,s4
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	e92080e7          	jalr	-366(ra) # 4b2 <putc>
        putc(fd, c);
 628:	85ca                	mv	a1,s2
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	e86080e7          	jalr	-378(ra) # 4b2 <putc>
      }
      state = 0;
 634:	4981                	li	s3,0
 636:	b765                	j	5de <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 638:	008b0913          	addi	s2,s6,8
 63c:	4685                	li	a3,1
 63e:	4629                	li	a2,10
 640:	000b2583          	lw	a1,0(s6)
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	e8e080e7          	jalr	-370(ra) # 4d4 <printint>
 64e:	8b4a                	mv	s6,s2
      state = 0;
 650:	4981                	li	s3,0
 652:	b771                	j	5de <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 654:	008b0913          	addi	s2,s6,8
 658:	4681                	li	a3,0
 65a:	4629                	li	a2,10
 65c:	000b2583          	lw	a1,0(s6)
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	e72080e7          	jalr	-398(ra) # 4d4 <printint>
 66a:	8b4a                	mv	s6,s2
      state = 0;
 66c:	4981                	li	s3,0
 66e:	bf85                	j	5de <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 670:	008b0913          	addi	s2,s6,8
 674:	4681                	li	a3,0
 676:	4641                	li	a2,16
 678:	000b2583          	lw	a1,0(s6)
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	e56080e7          	jalr	-426(ra) # 4d4 <printint>
 686:	8b4a                	mv	s6,s2
      state = 0;
 688:	4981                	li	s3,0
 68a:	bf91                	j	5de <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 68c:	008b0793          	addi	a5,s6,8
 690:	f8f43423          	sd	a5,-120(s0)
 694:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 698:	03000593          	li	a1,48
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	e14080e7          	jalr	-492(ra) # 4b2 <putc>
  putc(fd, 'x');
 6a6:	85ea                	mv	a1,s10
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	e08080e7          	jalr	-504(ra) # 4b2 <putc>
 6b2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b4:	03c9d793          	srli	a5,s3,0x3c
 6b8:	97de                	add	a5,a5,s7
 6ba:	0007c583          	lbu	a1,0(a5)
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	df2080e7          	jalr	-526(ra) # 4b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6c8:	0992                	slli	s3,s3,0x4
 6ca:	397d                	addiw	s2,s2,-1
 6cc:	fe0914e3          	bnez	s2,6b4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6d0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	b721                	j	5de <vprintf+0x60>
        s = va_arg(ap, char*);
 6d8:	008b0993          	addi	s3,s6,8
 6dc:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6e0:	02090163          	beqz	s2,702 <vprintf+0x184>
        while(*s != 0){
 6e4:	00094583          	lbu	a1,0(s2)
 6e8:	c9a1                	beqz	a1,738 <vprintf+0x1ba>
          putc(fd, *s);
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	dc6080e7          	jalr	-570(ra) # 4b2 <putc>
          s++;
 6f4:	0905                	addi	s2,s2,1
        while(*s != 0){
 6f6:	00094583          	lbu	a1,0(s2)
 6fa:	f9e5                	bnez	a1,6ea <vprintf+0x16c>
        s = va_arg(ap, char*);
 6fc:	8b4e                	mv	s6,s3
      state = 0;
 6fe:	4981                	li	s3,0
 700:	bdf9                	j	5de <vprintf+0x60>
          s = "(null)";
 702:	00000917          	auipc	s2,0x0
 706:	22e90913          	addi	s2,s2,558 # 930 <malloc+0xe8>
        while(*s != 0){
 70a:	02800593          	li	a1,40
 70e:	bff1                	j	6ea <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 710:	008b0913          	addi	s2,s6,8
 714:	000b4583          	lbu	a1,0(s6)
 718:	8556                	mv	a0,s5
 71a:	00000097          	auipc	ra,0x0
 71e:	d98080e7          	jalr	-616(ra) # 4b2 <putc>
 722:	8b4a                	mv	s6,s2
      state = 0;
 724:	4981                	li	s3,0
 726:	bd65                	j	5de <vprintf+0x60>
        putc(fd, c);
 728:	85d2                	mv	a1,s4
 72a:	8556                	mv	a0,s5
 72c:	00000097          	auipc	ra,0x0
 730:	d86080e7          	jalr	-634(ra) # 4b2 <putc>
      state = 0;
 734:	4981                	li	s3,0
 736:	b565                	j	5de <vprintf+0x60>
        s = va_arg(ap, char*);
 738:	8b4e                	mv	s6,s3
      state = 0;
 73a:	4981                	li	s3,0
 73c:	b54d                	j	5de <vprintf+0x60>
    }
  }
}
 73e:	70e6                	ld	ra,120(sp)
 740:	7446                	ld	s0,112(sp)
 742:	74a6                	ld	s1,104(sp)
 744:	7906                	ld	s2,96(sp)
 746:	69e6                	ld	s3,88(sp)
 748:	6a46                	ld	s4,80(sp)
 74a:	6aa6                	ld	s5,72(sp)
 74c:	6b06                	ld	s6,64(sp)
 74e:	7be2                	ld	s7,56(sp)
 750:	7c42                	ld	s8,48(sp)
 752:	7ca2                	ld	s9,40(sp)
 754:	7d02                	ld	s10,32(sp)
 756:	6de2                	ld	s11,24(sp)
 758:	6109                	addi	sp,sp,128
 75a:	8082                	ret

000000000000075c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 75c:	715d                	addi	sp,sp,-80
 75e:	ec06                	sd	ra,24(sp)
 760:	e822                	sd	s0,16(sp)
 762:	1000                	addi	s0,sp,32
 764:	e010                	sd	a2,0(s0)
 766:	e414                	sd	a3,8(s0)
 768:	e818                	sd	a4,16(s0)
 76a:	ec1c                	sd	a5,24(s0)
 76c:	03043023          	sd	a6,32(s0)
 770:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 774:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 778:	8622                	mv	a2,s0
 77a:	00000097          	auipc	ra,0x0
 77e:	e04080e7          	jalr	-508(ra) # 57e <vprintf>
}
 782:	60e2                	ld	ra,24(sp)
 784:	6442                	ld	s0,16(sp)
 786:	6161                	addi	sp,sp,80
 788:	8082                	ret

000000000000078a <printf>:

void
printf(const char *fmt, ...)
{
 78a:	711d                	addi	sp,sp,-96
 78c:	ec06                	sd	ra,24(sp)
 78e:	e822                	sd	s0,16(sp)
 790:	1000                	addi	s0,sp,32
 792:	e40c                	sd	a1,8(s0)
 794:	e810                	sd	a2,16(s0)
 796:	ec14                	sd	a3,24(s0)
 798:	f018                	sd	a4,32(s0)
 79a:	f41c                	sd	a5,40(s0)
 79c:	03043823          	sd	a6,48(s0)
 7a0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a4:	00840613          	addi	a2,s0,8
 7a8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ac:	85aa                	mv	a1,a0
 7ae:	4505                	li	a0,1
 7b0:	00000097          	auipc	ra,0x0
 7b4:	dce080e7          	jalr	-562(ra) # 57e <vprintf>
}
 7b8:	60e2                	ld	ra,24(sp)
 7ba:	6442                	ld	s0,16(sp)
 7bc:	6125                	addi	sp,sp,96
 7be:	8082                	ret

00000000000007c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c0:	1141                	addi	sp,sp,-16
 7c2:	e422                	sd	s0,8(sp)
 7c4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ca:	00000797          	auipc	a5,0x0
 7ce:	1867b783          	ld	a5,390(a5) # 950 <freep>
 7d2:	a805                	j	802 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7d4:	4618                	lw	a4,8(a2)
 7d6:	9db9                	addw	a1,a1,a4
 7d8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7dc:	6398                	ld	a4,0(a5)
 7de:	6318                	ld	a4,0(a4)
 7e0:	fee53823          	sd	a4,-16(a0)
 7e4:	a091                	j	828 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7e6:	ff852703          	lw	a4,-8(a0)
 7ea:	9e39                	addw	a2,a2,a4
 7ec:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7ee:	ff053703          	ld	a4,-16(a0)
 7f2:	e398                	sd	a4,0(a5)
 7f4:	a099                	j	83a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f6:	6398                	ld	a4,0(a5)
 7f8:	00e7e463          	bltu	a5,a4,800 <free+0x40>
 7fc:	00e6ea63          	bltu	a3,a4,810 <free+0x50>
{
 800:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 802:	fed7fae3          	bgeu	a5,a3,7f6 <free+0x36>
 806:	6398                	ld	a4,0(a5)
 808:	00e6e463          	bltu	a3,a4,810 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80c:	fee7eae3          	bltu	a5,a4,800 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 810:	ff852583          	lw	a1,-8(a0)
 814:	6390                	ld	a2,0(a5)
 816:	02059713          	slli	a4,a1,0x20
 81a:	9301                	srli	a4,a4,0x20
 81c:	0712                	slli	a4,a4,0x4
 81e:	9736                	add	a4,a4,a3
 820:	fae60ae3          	beq	a2,a4,7d4 <free+0x14>
    bp->s.ptr = p->s.ptr;
 824:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 828:	4790                	lw	a2,8(a5)
 82a:	02061713          	slli	a4,a2,0x20
 82e:	9301                	srli	a4,a4,0x20
 830:	0712                	slli	a4,a4,0x4
 832:	973e                	add	a4,a4,a5
 834:	fae689e3          	beq	a3,a4,7e6 <free+0x26>
  } else
    p->s.ptr = bp;
 838:	e394                	sd	a3,0(a5)
  freep = p;
 83a:	00000717          	auipc	a4,0x0
 83e:	10f73b23          	sd	a5,278(a4) # 950 <freep>
}
 842:	6422                	ld	s0,8(sp)
 844:	0141                	addi	sp,sp,16
 846:	8082                	ret

0000000000000848 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 848:	7139                	addi	sp,sp,-64
 84a:	fc06                	sd	ra,56(sp)
 84c:	f822                	sd	s0,48(sp)
 84e:	f426                	sd	s1,40(sp)
 850:	f04a                	sd	s2,32(sp)
 852:	ec4e                	sd	s3,24(sp)
 854:	e852                	sd	s4,16(sp)
 856:	e456                	sd	s5,8(sp)
 858:	e05a                	sd	s6,0(sp)
 85a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 85c:	02051493          	slli	s1,a0,0x20
 860:	9081                	srli	s1,s1,0x20
 862:	04bd                	addi	s1,s1,15
 864:	8091                	srli	s1,s1,0x4
 866:	0014899b          	addiw	s3,s1,1
 86a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 86c:	00000517          	auipc	a0,0x0
 870:	0e453503          	ld	a0,228(a0) # 950 <freep>
 874:	c515                	beqz	a0,8a0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 876:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 878:	4798                	lw	a4,8(a5)
 87a:	02977f63          	bgeu	a4,s1,8b8 <malloc+0x70>
 87e:	8a4e                	mv	s4,s3
 880:	0009871b          	sext.w	a4,s3
 884:	6685                	lui	a3,0x1
 886:	00d77363          	bgeu	a4,a3,88c <malloc+0x44>
 88a:	6a05                	lui	s4,0x1
 88c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 890:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 894:	00000917          	auipc	s2,0x0
 898:	0bc90913          	addi	s2,s2,188 # 950 <freep>
  if(p == (char*)-1)
 89c:	5afd                	li	s5,-1
 89e:	a88d                	j	910 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8a0:	00000797          	auipc	a5,0x0
 8a4:	0b878793          	addi	a5,a5,184 # 958 <base>
 8a8:	00000717          	auipc	a4,0x0
 8ac:	0af73423          	sd	a5,168(a4) # 950 <freep>
 8b0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8b6:	b7e1                	j	87e <malloc+0x36>
      if(p->s.size == nunits)
 8b8:	02e48b63          	beq	s1,a4,8ee <malloc+0xa6>
        p->s.size -= nunits;
 8bc:	4137073b          	subw	a4,a4,s3
 8c0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c2:	1702                	slli	a4,a4,0x20
 8c4:	9301                	srli	a4,a4,0x20
 8c6:	0712                	slli	a4,a4,0x4
 8c8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ca:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ce:	00000717          	auipc	a4,0x0
 8d2:	08a73123          	sd	a0,130(a4) # 950 <freep>
      return (void*)(p + 1);
 8d6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8da:	70e2                	ld	ra,56(sp)
 8dc:	7442                	ld	s0,48(sp)
 8de:	74a2                	ld	s1,40(sp)
 8e0:	7902                	ld	s2,32(sp)
 8e2:	69e2                	ld	s3,24(sp)
 8e4:	6a42                	ld	s4,16(sp)
 8e6:	6aa2                	ld	s5,8(sp)
 8e8:	6b02                	ld	s6,0(sp)
 8ea:	6121                	addi	sp,sp,64
 8ec:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8ee:	6398                	ld	a4,0(a5)
 8f0:	e118                	sd	a4,0(a0)
 8f2:	bff1                	j	8ce <malloc+0x86>
  hp->s.size = nu;
 8f4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8f8:	0541                	addi	a0,a0,16
 8fa:	00000097          	auipc	ra,0x0
 8fe:	ec6080e7          	jalr	-314(ra) # 7c0 <free>
  return freep;
 902:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 906:	d971                	beqz	a0,8da <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 908:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 90a:	4798                	lw	a4,8(a5)
 90c:	fa9776e3          	bgeu	a4,s1,8b8 <malloc+0x70>
    if(p == freep)
 910:	00093703          	ld	a4,0(s2)
 914:	853e                	mv	a0,a5
 916:	fef719e3          	bne	a4,a5,908 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 91a:	8552                	mv	a0,s4
 91c:	00000097          	auipc	ra,0x0
 920:	b6e080e7          	jalr	-1170(ra) # 48a <sbrk>
  if(p == (char*)-1)
 924:	fd5518e3          	bne	a0,s5,8f4 <malloc+0xac>
        return 0;
 928:	4501                	li	a0,0
 92a:	bf45                	j	8da <malloc+0x92>
