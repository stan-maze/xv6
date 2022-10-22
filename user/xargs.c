#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int getline(char* parm){
    char ch;
    // 取一个parm起始位置的指针，便于操作
    char* tmp = parm;
    while (read(0, &ch, 1) == 1)
    {
        // 换行符作为终结
        if(ch == '\n'){
            // 如果这行只输入了一个换行符，说明调用结束
            if(parm == tmp)
                return 0;
            else {
                // 最后填上个' '是为了格式化参数的形式：args+' ' 
                *(tmp) = ' ';
                *(tmp+1) = '\0';
                return 1;
            }
        }
        *tmp = ch;
        tmp++;
    }
    return 0;
}

int
main(int argc, char* argv[])
{
    char parm[128];
    while (getline(parm)){
        char cmd_name[32];
        char* cmd_args[32];
        int pre = 0;
        int cnt = -1;
        int len = strlen(parm);
        for(int i=0;i<len;i++){
            if(parm[i] == ' '){
                // 中断这个parm，因为参数列表cmd_args是从parm分段取得的
                parm[i] = '\0';
                // 第一个程序名称记录下来
                if(cnt == -1){
                    memmove(cmd_name,parm,i);
                    pre = ++i;
                    cnt++;
                    cmd_args[cnt++] = cmd_name;
                }
                else{
                    // 分段取得参数
                    cmd_args[cnt++] = parm+pre;
                    pre = ++i;
                }
            }
        }
        for(int i=len;i<128;i++) parm[i] = '\0';
        // fork子进程exec即可
        if(!fork()) exec(cmd_name,cmd_args);
        wait(0);
        memset(parm,0,128);
        memset(cmd_name,0,32);
    }
  exit(0);
}