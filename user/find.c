#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

void getname(char* path,char* path_name){
    int len = strlen(path);
    char* tmp = path;
    // 找最后一个'/'之后的名字
    for(tmp += len; tmp>=path && *tmp != '/'; tmp--);
    tmp++;
    // 使用这种方法是为了内存的管理（虽然在内核中不存在内存泄漏的问题
    memmove(path_name, tmp, strlen(tmp));
    path_name[strlen(tmp)] = '\0';
}

void find(char* path,char* name){
    struct dirent de;
    struct stat st;
    int fd;
    // 打开path
    if ((fd = open(path, O_RDONLY)) < 0) {
        write(1,"cant open dir!\n",strlen("cant open dir!\n"));
        exit(-1);
    }
    // 取出path的dirent
    if (fstat(fd, &st) < 0) {
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        exit(-1);
    }
    // newpath用于递归的搜索
    char new_path[512];
    // p是为了更方便地操作new_path，因为定义成数组不可以自增自减
    char* p = new_path;
    // 存储path的名字
    char tmp_name[DIRSIZ+1];
        
    switch (st.type)
    {
    case T_DIR:
    // 目录的话，往后加上“/childpath”
        memcmp(new_path,path,sizeof(path));
        new_path[strlen(path)] = '/';
        p += strlen(path);
        while (read(fd,&de,sizeof(de)))
        {
            if(de.inum == 0 || de.inum == 1 || strcmp(de.name, ".")==0 || strcmp(de.name, "..")==0)
                continue;
            memmove(p,de.name,strlen(de.name));
            p[strlen(de.name)] = '\0';
            // 递归地找
            find(p,name);
        }
        break;
    case T_FILE:
    // 是文件的话，直接比名字
        getname(path,tmp_name);
        if(!strcmp(name,tmp_name)){
            write(1,path,strlen(path));
            write(1,"\n",1);
        }
    default:
        break;
    }
    close(fd);
}
int main(int argc,char* argv[]){
    if (argc == 3){
        char* path = argv[1];
        char* name = argv[2];
        find(path,name);
    }else{
        write(1,"wrong input!\n",strlen("wrong input!\n"));
        exit(-1);
    }
    exit(0);
}
