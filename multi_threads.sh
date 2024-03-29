#!/bin/bash

# change j for run times
for ((j=0;j<100;j++));do
{
    for ((i=1;i<4;i++));do
    { 
        if [ $i -eq 1 ];then 
            ssh -t -p 22 nobi@pc326.emulab.net "python3 galera.py -f ${j} -n 1 ; exit" # need to change client node ip_address here
        elif [ $i -eq 2 ];then 
            ssh -t -p 22 nobi@pc353.emulab.net "python3 galera.py -f ${j} -n 2; exit" # need to change client node ip_address here
        elif [ $i -eq 3 ];then 
            ssh -t -p 22 nobi@pc354.emulab.net "python3 galera.py -f ${j} -n 3; exit" # need to change client node ip_address here
        fi
    }&
    done
    wait

    ssh -t -p 22 nobi@pc343.emulab.net "python3 init.py 155.98.39.143; exit" # need to change server and client nodes ip_address here
}
done

# download all the results to local machine
scp -r nobi@pc343.emulab.net:/users/nobi/output  /Users/zoe/Workspaces/github/galera/ #need to change the server node ip_address here
