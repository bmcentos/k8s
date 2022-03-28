#!/bin/bash

#OBJ: Monitorar recursos principias do cluster Kubernetes
#       - API
#       - ETCD
#       - PODs
#       - LB
#       - FS, IOWAIT

#By: Bruno Miquelini
#Created: 28/03/2022
#Version: v1


PATH=$PATH:/usr/local/bin
ENVI=Desenvolvimento

#Monitoramento ETCD ################INICIO###################
OUT=`etcdctl --endpoints https://127.0.0.1:2379   --cacert /etc/kubernetes/pki/etcd/ca.crt   --cert /etc/kubernetes/pki/etcd/peer.crt   --key /etc/kubernetes/pki/etcd/peer.key   member list | grep started`

if [ $? -ne 0 ] ; then
        echo "ATENÇÃO!!! Verificar comunicação do node $HOSTNAME com o etcd local: https://127.0.0.1:2379"
        exit 1
fi

if [ `echo "$OUT" | wc -l` -lt 3 ] ; then
        echo "ATENÇÂO!!! Verificar nós etcd no ambiente de $ENVI"
        echo "Abrir chamado para DTI-Linux"
        exit 1
fi


#Monitoramento API Server #############INICIO#################
OUT=`lsof -i :6443`

if [ `echo "$OUT" | wc -l` -lt 3 ] ; then
        echo "ATENÇÃO!!! Verificar comunicação com o API Server: https://$HOSTNAME:6443"
        exit 1
fi


#Monitora LB    ######################INICIO##########################
LBS="HOST1 HOST2"
for host in `echo $LBS| tr ' ' '\n'`
do
        PORT=6443
        echo exit | nc -v $host $PORT 2> /dev/null
        if [ $? -ne 0 ] ;then
                echo "ATENÇÃO!!! Falha na comunicação com o LB https://$host:$PORT"
        fi
done

#Monitora IO Stat
if [ `top -b -n 1| grep "wa,"| cut -d "," -f5| tr -d ' ' | cut -d "." -f1` -gt 2 ] ; then
        echo "ATENÇÂO!!! I/O Wait alto na CPU"
        echo "`top -b -n 1| grep "wa,"| cut -d "," -f5| tr -d ' '`"
        exit 1
fi

#Monitora pods
OUT=`kubectl get pod -A | egrep -v 'Running|Completed|NAMESPACE'`
if [ `echo "$OUT" | wc -l` -gt 1 ] ; then
        echo "ATENÇÂO!!! Verificar pods no ambiente de $ENVI"
        echo "$OUT"
        exit 1
fi

#Monitora FS

OUT=`df -h /| cut -d " " -f12 | tr -d "%"`
if [ $OUT -ge 85 ] ; then
        echo "ATENÇÂO!!! FS / em $OUT%  Verificar o file system \"/\""
        exit 1
fi
