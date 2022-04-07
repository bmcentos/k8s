#!/bin/bash
#export http_proxy=
#export https_proxy=

#Variaveis
cversion=1.6.2
date=`date +%d%m%y-%H%M%S`
bkp=/root/bkp_containerd_runc_"$date".tar.gz
old=`/usr/local/bin/containerd --version`

#Backup dos binarios
tar cvzf "$bkp" /usr/local/*bin/

echo "[+] - Aguarde... Atualizando containerd e runc"
#Download do containerd
wget https://github.com/containerd/containerd/releases/download/v"$cversion"/containerd-"$cversion"-linux-amd64.tar.gz 2> /dev/null
if [ $? -ne 0 ] ; then
        echo "Falha ao baixar o containerd"
        exit 1
fi

#Extração dos binarios
tar xf containerd-"$cversion"-linux-amd64.tar.gz -C /usr/local/

#Download do runc
wget -O /usr/local/sbin/runc https://github.com/opencontainers/runc/releases/download/v1.1.0/runc.amd64 2> /dev/null
if [ $? -ne 0 ] ; then
        echo "Falha ao baixar o runc"
        exit 1
fi

chmod 700 /usr/local/sbin/runc

systemctl restart containerd
sleep 5
if [ $? -ne 0 ] ; then
        echo "ATENCAO!!! Falha no serviço Containerd do host $HOSTNAME"
        echo "Restaurando versão anterior..."
        tar xf "$bkp" -C /
        systemctl start containerd
        exit 1
fi

echo "Atualização realizada com sucesso"
echo "Versão antiga: "
echo "$old"
echo
echo "Versão atual:"
/usr/local/bin/containerd --version
