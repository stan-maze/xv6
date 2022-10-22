#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int getline(char* parm){
    char ch;
    // ȡһ��parm��ʼλ�õ�ָ�룬���ڲ���
    char* tmp = parm;
    while (read(0, &ch, 1) == 1)
    {
        // ���з���Ϊ�ս�
        if(ch == '\n'){
            // �������ֻ������һ�����з���˵�����ý���
            if(parm == tmp)
                return 0;
            else {
                // ������ϸ�' '��Ϊ�˸�ʽ����������ʽ��args+' ' 
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
                // �ж����parm����Ϊ�����б�cmd_args�Ǵ�parm�ֶ�ȡ�õ�
                parm[i] = '\0';
                // ��һ���������Ƽ�¼����
                if(cnt == -1){
                    memmove(cmd_name,parm,i);
                    pre = ++i;
                    cnt++;
                    cmd_args[cnt++] = cmd_name;
                }
                else{
                    // �ֶ�ȡ�ò���
                    cmd_args[cnt++] = parm+pre;
                    pre = ++i;
                }
            }
        }
        for(int i=len;i<128;i++) parm[i] = '\0';
        // fork�ӽ���exec����
        if(!fork()) exec(cmd_name,cmd_args);
        wait(0);
        memset(parm,0,128);
        memset(cmd_name,0,32);
    }
  exit(0);
}