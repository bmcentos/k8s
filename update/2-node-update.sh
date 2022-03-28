#!/bin/bash
clear
#Define versao a ser atualizada
V=1.22.8


echo "###############################################"
echo "#         ATUALIZACAO DO KUBERNETES           #"
echo "#         - Workers node                      #"
echo "###############################################"
echo
read -p "Voce realmente deseja iniciar a atualização dos Workers Kubernetes? [s/n]
RESP: " resp
resp=`echo $resp | tr [A-Z] [a-z]`
if [ "$resp" == "s" ]; then
        echo "* Voce respondeu: $resp"
elif [ "$resp" == "n" ]; then
        echo "*Saindo..."
        exit 1

elif [ "$resp" == "" ]; then
        echo "Valor nulo... Saindo..."
        exit 1
else
        echo "Opção nao reconhecida, Saindo..."
        exit 1
fi




for host in `sudo kubectl get node| egrep -v 'NAME|control'| cut -d " " -f1`
 do
        echo "[+] Atualizando node - $host"
        sudo kubectl drain $host --ignore-daemonsets --delete-emptydir-data --ignore-errors
        scp kubernetes.repo $host:/tmp
        #Caso precise equiparar o yum.config das maquinas
        #scp yum.conf $host:/tmp
        ssh $host 'sudo cp /tmp/kubernetes.repo /etc/yum.repos.d/kubernetes.repo'
        ssh $host 'sudo cp /tmp/yum.conf /etc/yum.conf'
        ssh $host 'sudo yum repolist'
        ssh $host 'sudo /usr/bin/yum install -y kubeadm-'$V'-0 kubelet-'$V'-0 kubectl-'$V'-0 --disableexcludes=kubernetes'
        ssh $host 'sudo  kubeadm upgrade node'
        ssh $host 'sudo /usr/bin/systemctl daemon-reload'
        ssh $host 'sudo /usr/bin/systemctl restart kubelet'
        sudo kubectl uncordon $host
        sleep 15
 done

#IF PROXY
#export https_proxy=
#export htts_proxy=
#export NO_PROXY=10.0.0.0/8

#Atualiza o flannel - CASO O FLANNEL FOR ATUALIZADO
#echo "[+] - Atualizando o flannel"
#sudo kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

#Atualizando metrics server
echo "[+] - Atualizando metrics Server"
sudo kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

