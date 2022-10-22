
#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"
int
main(int argc, char *argv[])
{
    // father_to_child �� child_to_father�ܵ�
    int p_ftoc[2],p_ctof[2];
    pipe(p_ftoc);
    pipe(p_ctof);
    // д��father_to_child[1]
    write(p_ftoc[1],"received ping pong\n",strlen("received ping pong\n"));
    // ע��رգ�������ܳ���ѭ���ȴ�
    close(p_ftoc[1]);
    if(!fork()){
        char buf[512];
        // ��д��father_to_child[0]��ȡ��received ping pong
        int n = read(p_ftoc[0],buf,sizeof(buf));
        close(p_ftoc[0]);
        if(n<=0){ 
            write(1,"children faild\n",strlen("children faild\n"));
            exit(-1);
        }
        // д��child_to_father[1]
        write(p_ctof[1],buf,n);
        close(p_ctof[1]);
        exit(0);
    }
    else{
        char res[512];
        // ��child_to_father[0]ȡ��received ping pong
        int n = read(p_ctof[0],res,sizeof(res));
        close(p_ctof[0]);
        if(n<=0) {
            write(1,"father faild\n",strlen("father faild\n"));
            exit(-1);
        }
        write(1,res,strlen(res));
        exit(0);
        }
}
