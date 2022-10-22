#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

void getname(char* path,char* path_name){
    int len = strlen(path);
    char* tmp = path;
    // �����һ��'/'֮�������
    for(tmp += len; tmp>=path && *tmp != '/'; tmp--);
    tmp++;
    // ʹ�����ַ�����Ϊ���ڴ�Ĺ�����Ȼ���ں��в������ڴ�й©������
    memmove(path_name, tmp, strlen(tmp));
    path_name[strlen(tmp)] = '\0';
}

void find(char* path,char* name){
    struct dirent de;
    struct stat st;
    int fd;
    // ��path
    if ((fd = open(path, O_RDONLY)) < 0) {
        write(1,"cant open dir!\n",strlen("cant open dir!\n"));
        exit(-1);
    }
    // ȡ��path��dirent
    if (fstat(fd, &st) < 0) {
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        exit(-1);
    }
    // newpath���ڵݹ������
    char new_path[512];
    // p��Ϊ�˸�����ز���new_path����Ϊ��������鲻���������Լ�
    char* p = new_path;
    // �洢path������
    char tmp_name[DIRSIZ+1];
        
    switch (st.type)
    {
    case T_DIR:
    // Ŀ¼�Ļ���������ϡ�/childpath��
        memcmp(new_path,path,sizeof(path));
        new_path[strlen(path)] = '/';
        p += strlen(path);
        while (read(fd,&de,sizeof(de)))
        {
            if(de.inum == 0 || de.inum == 1 || strcmp(de.name, ".")==0 || strcmp(de.name, "..")==0)
                continue;
            memmove(p,de.name,strlen(de.name));
            p[strlen(de.name)] = '\0';
            // �ݹ����
            find(p,name);
        }
        break;
    case T_FILE:
    // ���ļ��Ļ���ֱ�ӱ�����
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
