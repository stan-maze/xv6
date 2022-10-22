
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getname>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

void getname(char* path,char* path_name){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
   e:	892e                	mv	s2,a1
    int len = strlen(path);
  10:	00000097          	auipc	ra,0x0
  14:	310080e7          	jalr	784(ra) # 320 <strlen>
    char* tmp = path;
    // 找最后一个'/'之后的名字
    for(tmp += len; tmp>=path && *tmp != '/'; tmp--);
  18:	0005079b          	sext.w	a5,a0
  1c:	97a6                	add	a5,a5,s1
  1e:	02f00693          	li	a3,47
  22:	0097e963          	bltu	a5,s1,34 <getname+0x34>
  26:	0007c703          	lbu	a4,0(a5)
  2a:	00d70563          	beq	a4,a3,34 <getname+0x34>
  2e:	17fd                	addi	a5,a5,-1
  30:	fe97fbe3          	bgeu	a5,s1,26 <getname+0x26>
    tmp++;
  34:	00178493          	addi	s1,a5,1
    // 使用这种方法是为了内存的管理（虽然在内核中不存在内存泄漏的问题
    memmove(path_name, tmp, strlen(tmp));
  38:	8526                	mv	a0,s1
  3a:	00000097          	auipc	ra,0x0
  3e:	2e6080e7          	jalr	742(ra) # 320 <strlen>
  42:	0005061b          	sext.w	a2,a0
  46:	85a6                	mv	a1,s1
  48:	854a                	mv	a0,s2
  4a:	00000097          	auipc	ra,0x0
  4e:	44e080e7          	jalr	1102(ra) # 498 <memmove>
    path_name[strlen(tmp)] = '\0';
  52:	8526                	mv	a0,s1
  54:	00000097          	auipc	ra,0x0
  58:	2cc080e7          	jalr	716(ra) # 320 <strlen>
  5c:	1502                	slli	a0,a0,0x20
  5e:	9101                	srli	a0,a0,0x20
  60:	992a                	add	s2,s2,a0
  62:	00090023          	sb	zero,0(s2)
}
  66:	60e2                	ld	ra,24(sp)
  68:	6442                	ld	s0,16(sp)
  6a:	64a2                	ld	s1,8(sp)
  6c:	6902                	ld	s2,0(sp)
  6e:	6105                	addi	sp,sp,32
  70:	8082                	ret

0000000000000072 <find>:

void find(char* path,char* name){
  72:	d7010113          	addi	sp,sp,-656
  76:	28113423          	sd	ra,648(sp)
  7a:	28813023          	sd	s0,640(sp)
  7e:	26913c23          	sd	s1,632(sp)
  82:	27213823          	sd	s2,624(sp)
  86:	27313423          	sd	s3,616(sp)
  8a:	27413023          	sd	s4,608(sp)
  8e:	25513c23          	sd	s5,600(sp)
  92:	25613823          	sd	s6,592(sp)
  96:	25713423          	sd	s7,584(sp)
  9a:	0d00                	addi	s0,sp,656
  9c:	892a                	mv	s2,a0
  9e:	89ae                	mv	s3,a1
    struct dirent de;
    struct stat st;
    int fd;
    // 打开path
    if ((fd = open(path, O_RDONLY)) < 0) {
  a0:	4581                	li	a1,0
  a2:	00000097          	auipc	ra,0x0
  a6:	4ec080e7          	jalr	1260(ra) # 58e <open>
  aa:	04054f63          	bltz	a0,108 <find+0x96>
  ae:	84aa                	mv	s1,a0
        write(1,"cant open dir!\n",strlen("cant open dir!\n"));
        exit(-1);
    }
    // 取出path的dirent
    if (fstat(fd, &st) < 0) {
  b0:	f8840593          	addi	a1,s0,-120
  b4:	00000097          	auipc	ra,0x0
  b8:	4f2080e7          	jalr	1266(ra) # 5a6 <fstat>
  bc:	06054e63          	bltz	a0,138 <find+0xc6>
    // p是为了更方便地操作new_path，因为定义成数组不可以自增自减
    char* p = new_path;
    // 存储path的名字
    char tmp_name[DIRSIZ+1];
        
    switch (st.type)
  c0:	f9041783          	lh	a5,-112(s0)
  c4:	0007869b          	sext.w	a3,a5
  c8:	4705                	li	a4,1
  ca:	08e68b63          	beq	a3,a4,160 <find+0xee>
  ce:	4709                	li	a4,2
  d0:	16e68163          	beq	a3,a4,232 <find+0x1c0>
            write(1,"\n",1);
        }
    default:
        break;
    }
    close(fd);
  d4:	8526                	mv	a0,s1
  d6:	00000097          	auipc	ra,0x0
  da:	4a0080e7          	jalr	1184(ra) # 576 <close>
}
  de:	28813083          	ld	ra,648(sp)
  e2:	28013403          	ld	s0,640(sp)
  e6:	27813483          	ld	s1,632(sp)
  ea:	27013903          	ld	s2,624(sp)
  ee:	26813983          	ld	s3,616(sp)
  f2:	26013a03          	ld	s4,608(sp)
  f6:	25813a83          	ld	s5,600(sp)
  fa:	25013b03          	ld	s6,592(sp)
  fe:	24813b83          	ld	s7,584(sp)
 102:	29010113          	addi	sp,sp,656
 106:	8082                	ret
        write(1,"cant open dir!\n",strlen("cant open dir!\n"));
 108:	00001517          	auipc	a0,0x1
 10c:	97050513          	addi	a0,a0,-1680 # a78 <malloc+0xe4>
 110:	00000097          	auipc	ra,0x0
 114:	210080e7          	jalr	528(ra) # 320 <strlen>
 118:	0005061b          	sext.w	a2,a0
 11c:	00001597          	auipc	a1,0x1
 120:	95c58593          	addi	a1,a1,-1700 # a78 <malloc+0xe4>
 124:	4505                	li	a0,1
 126:	00000097          	auipc	ra,0x0
 12a:	448080e7          	jalr	1096(ra) # 56e <write>
        exit(-1);
 12e:	557d                	li	a0,-1
 130:	00000097          	auipc	ra,0x0
 134:	41e080e7          	jalr	1054(ra) # 54e <exit>
        fprintf(2, "find: cannot stat %s\n", path);
 138:	864a                	mv	a2,s2
 13a:	00001597          	auipc	a1,0x1
 13e:	94e58593          	addi	a1,a1,-1714 # a88 <malloc+0xf4>
 142:	4509                	li	a0,2
 144:	00000097          	auipc	ra,0x0
 148:	764080e7          	jalr	1892(ra) # 8a8 <fprintf>
        close(fd);
 14c:	8526                	mv	a0,s1
 14e:	00000097          	auipc	ra,0x0
 152:	428080e7          	jalr	1064(ra) # 576 <close>
        exit(-1);
 156:	557d                	li	a0,-1
 158:	00000097          	auipc	ra,0x0
 15c:	3f6080e7          	jalr	1014(ra) # 54e <exit>
        memcmp(new_path,path,sizeof(path));
 160:	4621                	li	a2,8
 162:	85ca                	mv	a1,s2
 164:	d8840513          	addi	a0,s0,-632
 168:	00000097          	auipc	ra,0x0
 16c:	38c080e7          	jalr	908(ra) # 4f4 <memcmp>
        new_path[strlen(path)] = '/';
 170:	854a                	mv	a0,s2
 172:	00000097          	auipc	ra,0x0
 176:	1ae080e7          	jalr	430(ra) # 320 <strlen>
 17a:	1502                	slli	a0,a0,0x20
 17c:	9101                	srli	a0,a0,0x20
 17e:	fb040793          	addi	a5,s0,-80
 182:	953e                	add	a0,a0,a5
 184:	02f00793          	li	a5,47
 188:	dcf50c23          	sb	a5,-552(a0)
        p += strlen(path);
 18c:	854a                	mv	a0,s2
 18e:	00000097          	auipc	ra,0x0
 192:	192080e7          	jalr	402(ra) # 320 <strlen>
 196:	02051913          	slli	s2,a0,0x20
 19a:	02095913          	srli	s2,s2,0x20
 19e:	d8840793          	addi	a5,s0,-632
 1a2:	993e                	add	s2,s2,a5
            if(de.inum == 0 || de.inum == 1 || strcmp(de.name, ".")==0 || strcmp(de.name, "..")==0)
 1a4:	4a05                	li	s4,1
 1a6:	00001b17          	auipc	s6,0x1
 1aa:	8fab0b13          	addi	s6,s6,-1798 # aa0 <malloc+0x10c>
 1ae:	00001b97          	auipc	s7,0x1
 1b2:	8fab8b93          	addi	s7,s7,-1798 # aa8 <malloc+0x114>
 1b6:	fa240a93          	addi	s5,s0,-94
        while (read(fd,&de,sizeof(de)))
 1ba:	4641                	li	a2,16
 1bc:	fa040593          	addi	a1,s0,-96
 1c0:	8526                	mv	a0,s1
 1c2:	00000097          	auipc	ra,0x0
 1c6:	3a4080e7          	jalr	932(ra) # 566 <read>
 1ca:	d509                	beqz	a0,d4 <find+0x62>
            if(de.inum == 0 || de.inum == 1 || strcmp(de.name, ".")==0 || strcmp(de.name, "..")==0)
 1cc:	fa045783          	lhu	a5,-96(s0)
 1d0:	fefa75e3          	bgeu	s4,a5,1ba <find+0x148>
 1d4:	85da                	mv	a1,s6
 1d6:	8556                	mv	a0,s5
 1d8:	00000097          	auipc	ra,0x0
 1dc:	11c080e7          	jalr	284(ra) # 2f4 <strcmp>
 1e0:	dd69                	beqz	a0,1ba <find+0x148>
 1e2:	85de                	mv	a1,s7
 1e4:	8556                	mv	a0,s5
 1e6:	00000097          	auipc	ra,0x0
 1ea:	10e080e7          	jalr	270(ra) # 2f4 <strcmp>
 1ee:	d571                	beqz	a0,1ba <find+0x148>
            memmove(p,de.name,strlen(de.name));
 1f0:	fa240513          	addi	a0,s0,-94
 1f4:	00000097          	auipc	ra,0x0
 1f8:	12c080e7          	jalr	300(ra) # 320 <strlen>
 1fc:	0005061b          	sext.w	a2,a0
 200:	fa240593          	addi	a1,s0,-94
 204:	854a                	mv	a0,s2
 206:	00000097          	auipc	ra,0x0
 20a:	292080e7          	jalr	658(ra) # 498 <memmove>
            p[strlen(de.name)] = '\0';
 20e:	fa240513          	addi	a0,s0,-94
 212:	00000097          	auipc	ra,0x0
 216:	10e080e7          	jalr	270(ra) # 320 <strlen>
 21a:	1502                	slli	a0,a0,0x20
 21c:	9101                	srli	a0,a0,0x20
 21e:	954a                	add	a0,a0,s2
 220:	00050023          	sb	zero,0(a0)
            find(p,name);
 224:	85ce                	mv	a1,s3
 226:	854a                	mv	a0,s2
 228:	00000097          	auipc	ra,0x0
 22c:	e4a080e7          	jalr	-438(ra) # 72 <find>
 230:	b769                	j	1ba <find+0x148>
        getname(path,tmp_name);
 232:	d7840593          	addi	a1,s0,-648
 236:	854a                	mv	a0,s2
 238:	00000097          	auipc	ra,0x0
 23c:	dc8080e7          	jalr	-568(ra) # 0 <getname>
        if(!strcmp(name,tmp_name)){
 240:	d7840593          	addi	a1,s0,-648
 244:	854e                	mv	a0,s3
 246:	00000097          	auipc	ra,0x0
 24a:	0ae080e7          	jalr	174(ra) # 2f4 <strcmp>
 24e:	e80513e3          	bnez	a0,d4 <find+0x62>
            write(1,path,strlen(path));
 252:	854a                	mv	a0,s2
 254:	00000097          	auipc	ra,0x0
 258:	0cc080e7          	jalr	204(ra) # 320 <strlen>
 25c:	0005061b          	sext.w	a2,a0
 260:	85ca                	mv	a1,s2
 262:	4505                	li	a0,1
 264:	00000097          	auipc	ra,0x0
 268:	30a080e7          	jalr	778(ra) # 56e <write>
            write(1,"\n",1);
 26c:	4605                	li	a2,1
 26e:	00001597          	auipc	a1,0x1
 272:	84258593          	addi	a1,a1,-1982 # ab0 <malloc+0x11c>
 276:	4505                	li	a0,1
 278:	00000097          	auipc	ra,0x0
 27c:	2f6080e7          	jalr	758(ra) # 56e <write>
 280:	bd91                	j	d4 <find+0x62>

0000000000000282 <main>:
int main(int argc,char* argv[]){
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
    if (argc == 3){
 28a:	470d                	li	a4,3
 28c:	02e50a63          	beq	a0,a4,2c0 <main+0x3e>
        char* path = argv[1];
        char* name = argv[2];
        find(path,name);
    }else{
        write(1,"wrong input!\n",strlen("wrong input!\n"));
 290:	00001517          	auipc	a0,0x1
 294:	82850513          	addi	a0,a0,-2008 # ab8 <malloc+0x124>
 298:	00000097          	auipc	ra,0x0
 29c:	088080e7          	jalr	136(ra) # 320 <strlen>
 2a0:	0005061b          	sext.w	a2,a0
 2a4:	00001597          	auipc	a1,0x1
 2a8:	81458593          	addi	a1,a1,-2028 # ab8 <malloc+0x124>
 2ac:	4505                	li	a0,1
 2ae:	00000097          	auipc	ra,0x0
 2b2:	2c0080e7          	jalr	704(ra) # 56e <write>
        exit(-1);
 2b6:	557d                	li	a0,-1
 2b8:	00000097          	auipc	ra,0x0
 2bc:	296080e7          	jalr	662(ra) # 54e <exit>
 2c0:	87ae                	mv	a5,a1
        find(path,name);
 2c2:	698c                	ld	a1,16(a1)
 2c4:	6788                	ld	a0,8(a5)
 2c6:	00000097          	auipc	ra,0x0
 2ca:	dac080e7          	jalr	-596(ra) # 72 <find>
    }
    exit(0);
 2ce:	4501                	li	a0,0
 2d0:	00000097          	auipc	ra,0x0
 2d4:	27e080e7          	jalr	638(ra) # 54e <exit>

00000000000002d8 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2de:	87aa                	mv	a5,a0
 2e0:	0585                	addi	a1,a1,1
 2e2:	0785                	addi	a5,a5,1
 2e4:	fff5c703          	lbu	a4,-1(a1)
 2e8:	fee78fa3          	sb	a4,-1(a5)
 2ec:	fb75                	bnez	a4,2e0 <strcpy+0x8>
    ;
  return os;
}
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret

00000000000002f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e422                	sd	s0,8(sp)
 2f8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2fa:	00054783          	lbu	a5,0(a0)
 2fe:	cb91                	beqz	a5,312 <strcmp+0x1e>
 300:	0005c703          	lbu	a4,0(a1)
 304:	00f71763          	bne	a4,a5,312 <strcmp+0x1e>
    p++, q++;
 308:	0505                	addi	a0,a0,1
 30a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 30c:	00054783          	lbu	a5,0(a0)
 310:	fbe5                	bnez	a5,300 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 312:	0005c503          	lbu	a0,0(a1)
}
 316:	40a7853b          	subw	a0,a5,a0
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret

0000000000000320 <strlen>:

uint
strlen(const char *s)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 326:	00054783          	lbu	a5,0(a0)
 32a:	cf91                	beqz	a5,346 <strlen+0x26>
 32c:	0505                	addi	a0,a0,1
 32e:	87aa                	mv	a5,a0
 330:	4685                	li	a3,1
 332:	9e89                	subw	a3,a3,a0
 334:	00f6853b          	addw	a0,a3,a5
 338:	0785                	addi	a5,a5,1
 33a:	fff7c703          	lbu	a4,-1(a5)
 33e:	fb7d                	bnez	a4,334 <strlen+0x14>
    ;
  return n;
}
 340:	6422                	ld	s0,8(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret
  for(n = 0; s[n]; n++)
 346:	4501                	li	a0,0
 348:	bfe5                	j	340 <strlen+0x20>

000000000000034a <memset>:

void*
memset(void *dst, int c, uint n)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e422                	sd	s0,8(sp)
 34e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 350:	ce09                	beqz	a2,36a <memset+0x20>
 352:	87aa                	mv	a5,a0
 354:	fff6071b          	addiw	a4,a2,-1
 358:	1702                	slli	a4,a4,0x20
 35a:	9301                	srli	a4,a4,0x20
 35c:	0705                	addi	a4,a4,1
 35e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 360:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 364:	0785                	addi	a5,a5,1
 366:	fee79de3          	bne	a5,a4,360 <memset+0x16>
  }
  return dst;
}
 36a:	6422                	ld	s0,8(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret

0000000000000370 <strchr>:

char*
strchr(const char *s, char c)
{
 370:	1141                	addi	sp,sp,-16
 372:	e422                	sd	s0,8(sp)
 374:	0800                	addi	s0,sp,16
  for(; *s; s++)
 376:	00054783          	lbu	a5,0(a0)
 37a:	cb99                	beqz	a5,390 <strchr+0x20>
    if(*s == c)
 37c:	00f58763          	beq	a1,a5,38a <strchr+0x1a>
  for(; *s; s++)
 380:	0505                	addi	a0,a0,1
 382:	00054783          	lbu	a5,0(a0)
 386:	fbfd                	bnez	a5,37c <strchr+0xc>
      return (char*)s;
  return 0;
 388:	4501                	li	a0,0
}
 38a:	6422                	ld	s0,8(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret
  return 0;
 390:	4501                	li	a0,0
 392:	bfe5                	j	38a <strchr+0x1a>

0000000000000394 <gets>:

char*
gets(char *buf, int max)
{
 394:	711d                	addi	sp,sp,-96
 396:	ec86                	sd	ra,88(sp)
 398:	e8a2                	sd	s0,80(sp)
 39a:	e4a6                	sd	s1,72(sp)
 39c:	e0ca                	sd	s2,64(sp)
 39e:	fc4e                	sd	s3,56(sp)
 3a0:	f852                	sd	s4,48(sp)
 3a2:	f456                	sd	s5,40(sp)
 3a4:	f05a                	sd	s6,32(sp)
 3a6:	ec5e                	sd	s7,24(sp)
 3a8:	1080                	addi	s0,sp,96
 3aa:	8baa                	mv	s7,a0
 3ac:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ae:	892a                	mv	s2,a0
 3b0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3b2:	4aa9                	li	s5,10
 3b4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3b6:	89a6                	mv	s3,s1
 3b8:	2485                	addiw	s1,s1,1
 3ba:	0344d863          	bge	s1,s4,3ea <gets+0x56>
    cc = read(0, &c, 1);
 3be:	4605                	li	a2,1
 3c0:	faf40593          	addi	a1,s0,-81
 3c4:	4501                	li	a0,0
 3c6:	00000097          	auipc	ra,0x0
 3ca:	1a0080e7          	jalr	416(ra) # 566 <read>
    if(cc < 1)
 3ce:	00a05e63          	blez	a0,3ea <gets+0x56>
    buf[i++] = c;
 3d2:	faf44783          	lbu	a5,-81(s0)
 3d6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3da:	01578763          	beq	a5,s5,3e8 <gets+0x54>
 3de:	0905                	addi	s2,s2,1
 3e0:	fd679be3          	bne	a5,s6,3b6 <gets+0x22>
  for(i=0; i+1 < max; ){
 3e4:	89a6                	mv	s3,s1
 3e6:	a011                	j	3ea <gets+0x56>
 3e8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3ea:	99de                	add	s3,s3,s7
 3ec:	00098023          	sb	zero,0(s3)
  return buf;
}
 3f0:	855e                	mv	a0,s7
 3f2:	60e6                	ld	ra,88(sp)
 3f4:	6446                	ld	s0,80(sp)
 3f6:	64a6                	ld	s1,72(sp)
 3f8:	6906                	ld	s2,64(sp)
 3fa:	79e2                	ld	s3,56(sp)
 3fc:	7a42                	ld	s4,48(sp)
 3fe:	7aa2                	ld	s5,40(sp)
 400:	7b02                	ld	s6,32(sp)
 402:	6be2                	ld	s7,24(sp)
 404:	6125                	addi	sp,sp,96
 406:	8082                	ret

0000000000000408 <stat>:

int
stat(const char *n, struct stat *st)
{
 408:	1101                	addi	sp,sp,-32
 40a:	ec06                	sd	ra,24(sp)
 40c:	e822                	sd	s0,16(sp)
 40e:	e426                	sd	s1,8(sp)
 410:	e04a                	sd	s2,0(sp)
 412:	1000                	addi	s0,sp,32
 414:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 416:	4581                	li	a1,0
 418:	00000097          	auipc	ra,0x0
 41c:	176080e7          	jalr	374(ra) # 58e <open>
  if(fd < 0)
 420:	02054563          	bltz	a0,44a <stat+0x42>
 424:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 426:	85ca                	mv	a1,s2
 428:	00000097          	auipc	ra,0x0
 42c:	17e080e7          	jalr	382(ra) # 5a6 <fstat>
 430:	892a                	mv	s2,a0
  close(fd);
 432:	8526                	mv	a0,s1
 434:	00000097          	auipc	ra,0x0
 438:	142080e7          	jalr	322(ra) # 576 <close>
  return r;
}
 43c:	854a                	mv	a0,s2
 43e:	60e2                	ld	ra,24(sp)
 440:	6442                	ld	s0,16(sp)
 442:	64a2                	ld	s1,8(sp)
 444:	6902                	ld	s2,0(sp)
 446:	6105                	addi	sp,sp,32
 448:	8082                	ret
    return -1;
 44a:	597d                	li	s2,-1
 44c:	bfc5                	j	43c <stat+0x34>

000000000000044e <atoi>:

int
atoi(const char *s)
{
 44e:	1141                	addi	sp,sp,-16
 450:	e422                	sd	s0,8(sp)
 452:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 454:	00054603          	lbu	a2,0(a0)
 458:	fd06079b          	addiw	a5,a2,-48
 45c:	0ff7f793          	andi	a5,a5,255
 460:	4725                	li	a4,9
 462:	02f76963          	bltu	a4,a5,494 <atoi+0x46>
 466:	86aa                	mv	a3,a0
  n = 0;
 468:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 46a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 46c:	0685                	addi	a3,a3,1
 46e:	0025179b          	slliw	a5,a0,0x2
 472:	9fa9                	addw	a5,a5,a0
 474:	0017979b          	slliw	a5,a5,0x1
 478:	9fb1                	addw	a5,a5,a2
 47a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 47e:	0006c603          	lbu	a2,0(a3)
 482:	fd06071b          	addiw	a4,a2,-48
 486:	0ff77713          	andi	a4,a4,255
 48a:	fee5f1e3          	bgeu	a1,a4,46c <atoi+0x1e>
  return n;
}
 48e:	6422                	ld	s0,8(sp)
 490:	0141                	addi	sp,sp,16
 492:	8082                	ret
  n = 0;
 494:	4501                	li	a0,0
 496:	bfe5                	j	48e <atoi+0x40>

0000000000000498 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 498:	1141                	addi	sp,sp,-16
 49a:	e422                	sd	s0,8(sp)
 49c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 49e:	02b57663          	bgeu	a0,a1,4ca <memmove+0x32>
    while(n-- > 0)
 4a2:	02c05163          	blez	a2,4c4 <memmove+0x2c>
 4a6:	fff6079b          	addiw	a5,a2,-1
 4aa:	1782                	slli	a5,a5,0x20
 4ac:	9381                	srli	a5,a5,0x20
 4ae:	0785                	addi	a5,a5,1
 4b0:	97aa                	add	a5,a5,a0
  dst = vdst;
 4b2:	872a                	mv	a4,a0
      *dst++ = *src++;
 4b4:	0585                	addi	a1,a1,1
 4b6:	0705                	addi	a4,a4,1
 4b8:	fff5c683          	lbu	a3,-1(a1)
 4bc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4c0:	fee79ae3          	bne	a5,a4,4b4 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4c4:	6422                	ld	s0,8(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret
    dst += n;
 4ca:	00c50733          	add	a4,a0,a2
    src += n;
 4ce:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4d0:	fec05ae3          	blez	a2,4c4 <memmove+0x2c>
 4d4:	fff6079b          	addiw	a5,a2,-1
 4d8:	1782                	slli	a5,a5,0x20
 4da:	9381                	srli	a5,a5,0x20
 4dc:	fff7c793          	not	a5,a5
 4e0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4e2:	15fd                	addi	a1,a1,-1
 4e4:	177d                	addi	a4,a4,-1
 4e6:	0005c683          	lbu	a3,0(a1)
 4ea:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4ee:	fee79ae3          	bne	a5,a4,4e2 <memmove+0x4a>
 4f2:	bfc9                	j	4c4 <memmove+0x2c>

00000000000004f4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4f4:	1141                	addi	sp,sp,-16
 4f6:	e422                	sd	s0,8(sp)
 4f8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4fa:	ca05                	beqz	a2,52a <memcmp+0x36>
 4fc:	fff6069b          	addiw	a3,a2,-1
 500:	1682                	slli	a3,a3,0x20
 502:	9281                	srli	a3,a3,0x20
 504:	0685                	addi	a3,a3,1
 506:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 508:	00054783          	lbu	a5,0(a0)
 50c:	0005c703          	lbu	a4,0(a1)
 510:	00e79863          	bne	a5,a4,520 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 514:	0505                	addi	a0,a0,1
    p2++;
 516:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 518:	fed518e3          	bne	a0,a3,508 <memcmp+0x14>
  }
  return 0;
 51c:	4501                	li	a0,0
 51e:	a019                	j	524 <memcmp+0x30>
      return *p1 - *p2;
 520:	40e7853b          	subw	a0,a5,a4
}
 524:	6422                	ld	s0,8(sp)
 526:	0141                	addi	sp,sp,16
 528:	8082                	ret
  return 0;
 52a:	4501                	li	a0,0
 52c:	bfe5                	j	524 <memcmp+0x30>

000000000000052e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 52e:	1141                	addi	sp,sp,-16
 530:	e406                	sd	ra,8(sp)
 532:	e022                	sd	s0,0(sp)
 534:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 536:	00000097          	auipc	ra,0x0
 53a:	f62080e7          	jalr	-158(ra) # 498 <memmove>
}
 53e:	60a2                	ld	ra,8(sp)
 540:	6402                	ld	s0,0(sp)
 542:	0141                	addi	sp,sp,16
 544:	8082                	ret

0000000000000546 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 546:	4885                	li	a7,1
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <exit>:
.global exit
exit:
 li a7, SYS_exit
 54e:	4889                	li	a7,2
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <wait>:
.global wait
wait:
 li a7, SYS_wait
 556:	488d                	li	a7,3
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 55e:	4891                	li	a7,4
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <read>:
.global read
read:
 li a7, SYS_read
 566:	4895                	li	a7,5
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <write>:
.global write
write:
 li a7, SYS_write
 56e:	48c1                	li	a7,16
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <close>:
.global close
close:
 li a7, SYS_close
 576:	48d5                	li	a7,21
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <kill>:
.global kill
kill:
 li a7, SYS_kill
 57e:	4899                	li	a7,6
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <exec>:
.global exec
exec:
 li a7, SYS_exec
 586:	489d                	li	a7,7
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <open>:
.global open
open:
 li a7, SYS_open
 58e:	48bd                	li	a7,15
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 596:	48c5                	li	a7,17
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 59e:	48c9                	li	a7,18
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5a6:	48a1                	li	a7,8
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <link>:
.global link
link:
 li a7, SYS_link
 5ae:	48cd                	li	a7,19
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5b6:	48d1                	li	a7,20
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5be:	48a5                	li	a7,9
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5c6:	48a9                	li	a7,10
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ce:	48ad                	li	a7,11
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5d6:	48b1                	li	a7,12
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5de:	48b5                	li	a7,13
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5e6:	48b9                	li	a7,14
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <trace>:
.global trace
trace:
 li a7, SYS_trace
 5ee:	48d9                	li	a7,22
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 5f6:	48dd                	li	a7,23
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5fe:	1101                	addi	sp,sp,-32
 600:	ec06                	sd	ra,24(sp)
 602:	e822                	sd	s0,16(sp)
 604:	1000                	addi	s0,sp,32
 606:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 60a:	4605                	li	a2,1
 60c:	fef40593          	addi	a1,s0,-17
 610:	00000097          	auipc	ra,0x0
 614:	f5e080e7          	jalr	-162(ra) # 56e <write>
}
 618:	60e2                	ld	ra,24(sp)
 61a:	6442                	ld	s0,16(sp)
 61c:	6105                	addi	sp,sp,32
 61e:	8082                	ret

0000000000000620 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 620:	7139                	addi	sp,sp,-64
 622:	fc06                	sd	ra,56(sp)
 624:	f822                	sd	s0,48(sp)
 626:	f426                	sd	s1,40(sp)
 628:	f04a                	sd	s2,32(sp)
 62a:	ec4e                	sd	s3,24(sp)
 62c:	0080                	addi	s0,sp,64
 62e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 630:	c299                	beqz	a3,636 <printint+0x16>
 632:	0805c863          	bltz	a1,6c2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 636:	2581                	sext.w	a1,a1
  neg = 0;
 638:	4881                	li	a7,0
 63a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 63e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 640:	2601                	sext.w	a2,a2
 642:	00000517          	auipc	a0,0x0
 646:	48e50513          	addi	a0,a0,1166 # ad0 <digits>
 64a:	883a                	mv	a6,a4
 64c:	2705                	addiw	a4,a4,1
 64e:	02c5f7bb          	remuw	a5,a1,a2
 652:	1782                	slli	a5,a5,0x20
 654:	9381                	srli	a5,a5,0x20
 656:	97aa                	add	a5,a5,a0
 658:	0007c783          	lbu	a5,0(a5)
 65c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 660:	0005879b          	sext.w	a5,a1
 664:	02c5d5bb          	divuw	a1,a1,a2
 668:	0685                	addi	a3,a3,1
 66a:	fec7f0e3          	bgeu	a5,a2,64a <printint+0x2a>
  if(neg)
 66e:	00088b63          	beqz	a7,684 <printint+0x64>
    buf[i++] = '-';
 672:	fd040793          	addi	a5,s0,-48
 676:	973e                	add	a4,a4,a5
 678:	02d00793          	li	a5,45
 67c:	fef70823          	sb	a5,-16(a4)
 680:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 684:	02e05863          	blez	a4,6b4 <printint+0x94>
 688:	fc040793          	addi	a5,s0,-64
 68c:	00e78933          	add	s2,a5,a4
 690:	fff78993          	addi	s3,a5,-1
 694:	99ba                	add	s3,s3,a4
 696:	377d                	addiw	a4,a4,-1
 698:	1702                	slli	a4,a4,0x20
 69a:	9301                	srli	a4,a4,0x20
 69c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6a0:	fff94583          	lbu	a1,-1(s2)
 6a4:	8526                	mv	a0,s1
 6a6:	00000097          	auipc	ra,0x0
 6aa:	f58080e7          	jalr	-168(ra) # 5fe <putc>
  while(--i >= 0)
 6ae:	197d                	addi	s2,s2,-1
 6b0:	ff3918e3          	bne	s2,s3,6a0 <printint+0x80>
}
 6b4:	70e2                	ld	ra,56(sp)
 6b6:	7442                	ld	s0,48(sp)
 6b8:	74a2                	ld	s1,40(sp)
 6ba:	7902                	ld	s2,32(sp)
 6bc:	69e2                	ld	s3,24(sp)
 6be:	6121                	addi	sp,sp,64
 6c0:	8082                	ret
    x = -xx;
 6c2:	40b005bb          	negw	a1,a1
    neg = 1;
 6c6:	4885                	li	a7,1
    x = -xx;
 6c8:	bf8d                	j	63a <printint+0x1a>

00000000000006ca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6ca:	7119                	addi	sp,sp,-128
 6cc:	fc86                	sd	ra,120(sp)
 6ce:	f8a2                	sd	s0,112(sp)
 6d0:	f4a6                	sd	s1,104(sp)
 6d2:	f0ca                	sd	s2,96(sp)
 6d4:	ecce                	sd	s3,88(sp)
 6d6:	e8d2                	sd	s4,80(sp)
 6d8:	e4d6                	sd	s5,72(sp)
 6da:	e0da                	sd	s6,64(sp)
 6dc:	fc5e                	sd	s7,56(sp)
 6de:	f862                	sd	s8,48(sp)
 6e0:	f466                	sd	s9,40(sp)
 6e2:	f06a                	sd	s10,32(sp)
 6e4:	ec6e                	sd	s11,24(sp)
 6e6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6e8:	0005c903          	lbu	s2,0(a1)
 6ec:	18090f63          	beqz	s2,88a <vprintf+0x1c0>
 6f0:	8aaa                	mv	s5,a0
 6f2:	8b32                	mv	s6,a2
 6f4:	00158493          	addi	s1,a1,1
  state = 0;
 6f8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6fa:	02500a13          	li	s4,37
      if(c == 'd'){
 6fe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 702:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 706:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 70a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 70e:	00000b97          	auipc	s7,0x0
 712:	3c2b8b93          	addi	s7,s7,962 # ad0 <digits>
 716:	a839                	j	734 <vprintf+0x6a>
        putc(fd, c);
 718:	85ca                	mv	a1,s2
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	ee2080e7          	jalr	-286(ra) # 5fe <putc>
 724:	a019                	j	72a <vprintf+0x60>
    } else if(state == '%'){
 726:	01498f63          	beq	s3,s4,744 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 72a:	0485                	addi	s1,s1,1
 72c:	fff4c903          	lbu	s2,-1(s1)
 730:	14090d63          	beqz	s2,88a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 734:	0009079b          	sext.w	a5,s2
    if(state == 0){
 738:	fe0997e3          	bnez	s3,726 <vprintf+0x5c>
      if(c == '%'){
 73c:	fd479ee3          	bne	a5,s4,718 <vprintf+0x4e>
        state = '%';
 740:	89be                	mv	s3,a5
 742:	b7e5                	j	72a <vprintf+0x60>
      if(c == 'd'){
 744:	05878063          	beq	a5,s8,784 <vprintf+0xba>
      } else if(c == 'l') {
 748:	05978c63          	beq	a5,s9,7a0 <vprintf+0xd6>
      } else if(c == 'x') {
 74c:	07a78863          	beq	a5,s10,7bc <vprintf+0xf2>
      } else if(c == 'p') {
 750:	09b78463          	beq	a5,s11,7d8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 754:	07300713          	li	a4,115
 758:	0ce78663          	beq	a5,a4,824 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 75c:	06300713          	li	a4,99
 760:	0ee78e63          	beq	a5,a4,85c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 764:	11478863          	beq	a5,s4,874 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 768:	85d2                	mv	a1,s4
 76a:	8556                	mv	a0,s5
 76c:	00000097          	auipc	ra,0x0
 770:	e92080e7          	jalr	-366(ra) # 5fe <putc>
        putc(fd, c);
 774:	85ca                	mv	a1,s2
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	e86080e7          	jalr	-378(ra) # 5fe <putc>
      }
      state = 0;
 780:	4981                	li	s3,0
 782:	b765                	j	72a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 784:	008b0913          	addi	s2,s6,8
 788:	4685                	li	a3,1
 78a:	4629                	li	a2,10
 78c:	000b2583          	lw	a1,0(s6)
 790:	8556                	mv	a0,s5
 792:	00000097          	auipc	ra,0x0
 796:	e8e080e7          	jalr	-370(ra) # 620 <printint>
 79a:	8b4a                	mv	s6,s2
      state = 0;
 79c:	4981                	li	s3,0
 79e:	b771                	j	72a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a0:	008b0913          	addi	s2,s6,8
 7a4:	4681                	li	a3,0
 7a6:	4629                	li	a2,10
 7a8:	000b2583          	lw	a1,0(s6)
 7ac:	8556                	mv	a0,s5
 7ae:	00000097          	auipc	ra,0x0
 7b2:	e72080e7          	jalr	-398(ra) # 620 <printint>
 7b6:	8b4a                	mv	s6,s2
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	bf85                	j	72a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7bc:	008b0913          	addi	s2,s6,8
 7c0:	4681                	li	a3,0
 7c2:	4641                	li	a2,16
 7c4:	000b2583          	lw	a1,0(s6)
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	e56080e7          	jalr	-426(ra) # 620 <printint>
 7d2:	8b4a                	mv	s6,s2
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	bf91                	j	72a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7d8:	008b0793          	addi	a5,s6,8
 7dc:	f8f43423          	sd	a5,-120(s0)
 7e0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7e4:	03000593          	li	a1,48
 7e8:	8556                	mv	a0,s5
 7ea:	00000097          	auipc	ra,0x0
 7ee:	e14080e7          	jalr	-492(ra) # 5fe <putc>
  putc(fd, 'x');
 7f2:	85ea                	mv	a1,s10
 7f4:	8556                	mv	a0,s5
 7f6:	00000097          	auipc	ra,0x0
 7fa:	e08080e7          	jalr	-504(ra) # 5fe <putc>
 7fe:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 800:	03c9d793          	srli	a5,s3,0x3c
 804:	97de                	add	a5,a5,s7
 806:	0007c583          	lbu	a1,0(a5)
 80a:	8556                	mv	a0,s5
 80c:	00000097          	auipc	ra,0x0
 810:	df2080e7          	jalr	-526(ra) # 5fe <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 814:	0992                	slli	s3,s3,0x4
 816:	397d                	addiw	s2,s2,-1
 818:	fe0914e3          	bnez	s2,800 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 81c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 820:	4981                	li	s3,0
 822:	b721                	j	72a <vprintf+0x60>
        s = va_arg(ap, char*);
 824:	008b0993          	addi	s3,s6,8
 828:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 82c:	02090163          	beqz	s2,84e <vprintf+0x184>
        while(*s != 0){
 830:	00094583          	lbu	a1,0(s2)
 834:	c9a1                	beqz	a1,884 <vprintf+0x1ba>
          putc(fd, *s);
 836:	8556                	mv	a0,s5
 838:	00000097          	auipc	ra,0x0
 83c:	dc6080e7          	jalr	-570(ra) # 5fe <putc>
          s++;
 840:	0905                	addi	s2,s2,1
        while(*s != 0){
 842:	00094583          	lbu	a1,0(s2)
 846:	f9e5                	bnez	a1,836 <vprintf+0x16c>
        s = va_arg(ap, char*);
 848:	8b4e                	mv	s6,s3
      state = 0;
 84a:	4981                	li	s3,0
 84c:	bdf9                	j	72a <vprintf+0x60>
          s = "(null)";
 84e:	00000917          	auipc	s2,0x0
 852:	27a90913          	addi	s2,s2,634 # ac8 <malloc+0x134>
        while(*s != 0){
 856:	02800593          	li	a1,40
 85a:	bff1                	j	836 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 85c:	008b0913          	addi	s2,s6,8
 860:	000b4583          	lbu	a1,0(s6)
 864:	8556                	mv	a0,s5
 866:	00000097          	auipc	ra,0x0
 86a:	d98080e7          	jalr	-616(ra) # 5fe <putc>
 86e:	8b4a                	mv	s6,s2
      state = 0;
 870:	4981                	li	s3,0
 872:	bd65                	j	72a <vprintf+0x60>
        putc(fd, c);
 874:	85d2                	mv	a1,s4
 876:	8556                	mv	a0,s5
 878:	00000097          	auipc	ra,0x0
 87c:	d86080e7          	jalr	-634(ra) # 5fe <putc>
      state = 0;
 880:	4981                	li	s3,0
 882:	b565                	j	72a <vprintf+0x60>
        s = va_arg(ap, char*);
 884:	8b4e                	mv	s6,s3
      state = 0;
 886:	4981                	li	s3,0
 888:	b54d                	j	72a <vprintf+0x60>
    }
  }
}
 88a:	70e6                	ld	ra,120(sp)
 88c:	7446                	ld	s0,112(sp)
 88e:	74a6                	ld	s1,104(sp)
 890:	7906                	ld	s2,96(sp)
 892:	69e6                	ld	s3,88(sp)
 894:	6a46                	ld	s4,80(sp)
 896:	6aa6                	ld	s5,72(sp)
 898:	6b06                	ld	s6,64(sp)
 89a:	7be2                	ld	s7,56(sp)
 89c:	7c42                	ld	s8,48(sp)
 89e:	7ca2                	ld	s9,40(sp)
 8a0:	7d02                	ld	s10,32(sp)
 8a2:	6de2                	ld	s11,24(sp)
 8a4:	6109                	addi	sp,sp,128
 8a6:	8082                	ret

00000000000008a8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8a8:	715d                	addi	sp,sp,-80
 8aa:	ec06                	sd	ra,24(sp)
 8ac:	e822                	sd	s0,16(sp)
 8ae:	1000                	addi	s0,sp,32
 8b0:	e010                	sd	a2,0(s0)
 8b2:	e414                	sd	a3,8(s0)
 8b4:	e818                	sd	a4,16(s0)
 8b6:	ec1c                	sd	a5,24(s0)
 8b8:	03043023          	sd	a6,32(s0)
 8bc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8c0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8c4:	8622                	mv	a2,s0
 8c6:	00000097          	auipc	ra,0x0
 8ca:	e04080e7          	jalr	-508(ra) # 6ca <vprintf>
}
 8ce:	60e2                	ld	ra,24(sp)
 8d0:	6442                	ld	s0,16(sp)
 8d2:	6161                	addi	sp,sp,80
 8d4:	8082                	ret

00000000000008d6 <printf>:

void
printf(const char *fmt, ...)
{
 8d6:	711d                	addi	sp,sp,-96
 8d8:	ec06                	sd	ra,24(sp)
 8da:	e822                	sd	s0,16(sp)
 8dc:	1000                	addi	s0,sp,32
 8de:	e40c                	sd	a1,8(s0)
 8e0:	e810                	sd	a2,16(s0)
 8e2:	ec14                	sd	a3,24(s0)
 8e4:	f018                	sd	a4,32(s0)
 8e6:	f41c                	sd	a5,40(s0)
 8e8:	03043823          	sd	a6,48(s0)
 8ec:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8f0:	00840613          	addi	a2,s0,8
 8f4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8f8:	85aa                	mv	a1,a0
 8fa:	4505                	li	a0,1
 8fc:	00000097          	auipc	ra,0x0
 900:	dce080e7          	jalr	-562(ra) # 6ca <vprintf>
}
 904:	60e2                	ld	ra,24(sp)
 906:	6442                	ld	s0,16(sp)
 908:	6125                	addi	sp,sp,96
 90a:	8082                	ret

000000000000090c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 90c:	1141                	addi	sp,sp,-16
 90e:	e422                	sd	s0,8(sp)
 910:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 912:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 916:	00000797          	auipc	a5,0x0
 91a:	1d27b783          	ld	a5,466(a5) # ae8 <freep>
 91e:	a805                	j	94e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 920:	4618                	lw	a4,8(a2)
 922:	9db9                	addw	a1,a1,a4
 924:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 928:	6398                	ld	a4,0(a5)
 92a:	6318                	ld	a4,0(a4)
 92c:	fee53823          	sd	a4,-16(a0)
 930:	a091                	j	974 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 932:	ff852703          	lw	a4,-8(a0)
 936:	9e39                	addw	a2,a2,a4
 938:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 93a:	ff053703          	ld	a4,-16(a0)
 93e:	e398                	sd	a4,0(a5)
 940:	a099                	j	986 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 942:	6398                	ld	a4,0(a5)
 944:	00e7e463          	bltu	a5,a4,94c <free+0x40>
 948:	00e6ea63          	bltu	a3,a4,95c <free+0x50>
{
 94c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94e:	fed7fae3          	bgeu	a5,a3,942 <free+0x36>
 952:	6398                	ld	a4,0(a5)
 954:	00e6e463          	bltu	a3,a4,95c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 958:	fee7eae3          	bltu	a5,a4,94c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 95c:	ff852583          	lw	a1,-8(a0)
 960:	6390                	ld	a2,0(a5)
 962:	02059713          	slli	a4,a1,0x20
 966:	9301                	srli	a4,a4,0x20
 968:	0712                	slli	a4,a4,0x4
 96a:	9736                	add	a4,a4,a3
 96c:	fae60ae3          	beq	a2,a4,920 <free+0x14>
    bp->s.ptr = p->s.ptr;
 970:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 974:	4790                	lw	a2,8(a5)
 976:	02061713          	slli	a4,a2,0x20
 97a:	9301                	srli	a4,a4,0x20
 97c:	0712                	slli	a4,a4,0x4
 97e:	973e                	add	a4,a4,a5
 980:	fae689e3          	beq	a3,a4,932 <free+0x26>
  } else
    p->s.ptr = bp;
 984:	e394                	sd	a3,0(a5)
  freep = p;
 986:	00000717          	auipc	a4,0x0
 98a:	16f73123          	sd	a5,354(a4) # ae8 <freep>
}
 98e:	6422                	ld	s0,8(sp)
 990:	0141                	addi	sp,sp,16
 992:	8082                	ret

0000000000000994 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 994:	7139                	addi	sp,sp,-64
 996:	fc06                	sd	ra,56(sp)
 998:	f822                	sd	s0,48(sp)
 99a:	f426                	sd	s1,40(sp)
 99c:	f04a                	sd	s2,32(sp)
 99e:	ec4e                	sd	s3,24(sp)
 9a0:	e852                	sd	s4,16(sp)
 9a2:	e456                	sd	s5,8(sp)
 9a4:	e05a                	sd	s6,0(sp)
 9a6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a8:	02051493          	slli	s1,a0,0x20
 9ac:	9081                	srli	s1,s1,0x20
 9ae:	04bd                	addi	s1,s1,15
 9b0:	8091                	srli	s1,s1,0x4
 9b2:	0014899b          	addiw	s3,s1,1
 9b6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9b8:	00000517          	auipc	a0,0x0
 9bc:	13053503          	ld	a0,304(a0) # ae8 <freep>
 9c0:	c515                	beqz	a0,9ec <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c4:	4798                	lw	a4,8(a5)
 9c6:	02977f63          	bgeu	a4,s1,a04 <malloc+0x70>
 9ca:	8a4e                	mv	s4,s3
 9cc:	0009871b          	sext.w	a4,s3
 9d0:	6685                	lui	a3,0x1
 9d2:	00d77363          	bgeu	a4,a3,9d8 <malloc+0x44>
 9d6:	6a05                	lui	s4,0x1
 9d8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9dc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9e0:	00000917          	auipc	s2,0x0
 9e4:	10890913          	addi	s2,s2,264 # ae8 <freep>
  if(p == (char*)-1)
 9e8:	5afd                	li	s5,-1
 9ea:	a88d                	j	a5c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 9ec:	00000797          	auipc	a5,0x0
 9f0:	10478793          	addi	a5,a5,260 # af0 <base>
 9f4:	00000717          	auipc	a4,0x0
 9f8:	0ef73a23          	sd	a5,244(a4) # ae8 <freep>
 9fc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9fe:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a02:	b7e1                	j	9ca <malloc+0x36>
      if(p->s.size == nunits)
 a04:	02e48b63          	beq	s1,a4,a3a <malloc+0xa6>
        p->s.size -= nunits;
 a08:	4137073b          	subw	a4,a4,s3
 a0c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a0e:	1702                	slli	a4,a4,0x20
 a10:	9301                	srli	a4,a4,0x20
 a12:	0712                	slli	a4,a4,0x4
 a14:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a16:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a1a:	00000717          	auipc	a4,0x0
 a1e:	0ca73723          	sd	a0,206(a4) # ae8 <freep>
      return (void*)(p + 1);
 a22:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a26:	70e2                	ld	ra,56(sp)
 a28:	7442                	ld	s0,48(sp)
 a2a:	74a2                	ld	s1,40(sp)
 a2c:	7902                	ld	s2,32(sp)
 a2e:	69e2                	ld	s3,24(sp)
 a30:	6a42                	ld	s4,16(sp)
 a32:	6aa2                	ld	s5,8(sp)
 a34:	6b02                	ld	s6,0(sp)
 a36:	6121                	addi	sp,sp,64
 a38:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a3a:	6398                	ld	a4,0(a5)
 a3c:	e118                	sd	a4,0(a0)
 a3e:	bff1                	j	a1a <malloc+0x86>
  hp->s.size = nu;
 a40:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a44:	0541                	addi	a0,a0,16
 a46:	00000097          	auipc	ra,0x0
 a4a:	ec6080e7          	jalr	-314(ra) # 90c <free>
  return freep;
 a4e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a52:	d971                	beqz	a0,a26 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a54:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a56:	4798                	lw	a4,8(a5)
 a58:	fa9776e3          	bgeu	a4,s1,a04 <malloc+0x70>
    if(p == freep)
 a5c:	00093703          	ld	a4,0(s2)
 a60:	853e                	mv	a0,a5
 a62:	fef719e3          	bne	a4,a5,a54 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a66:	8552                	mv	a0,s4
 a68:	00000097          	auipc	ra,0x0
 a6c:	b6e080e7          	jalr	-1170(ra) # 5d6 <sbrk>
  if(p == (char*)-1)
 a70:	fd5518e3          	bne	a0,s5,a40 <malloc+0xac>
        return 0;
 a74:	4501                	li	a0,0
 a76:	bf45                	j	a26 <malloc+0x92>
