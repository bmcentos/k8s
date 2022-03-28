#!/bin/bash

#By: Bruno Miquelini
#OBJ: Atualizar control plane k8s
clear

#Define a versão do kubernetes
V=1.22.8

#Se proxy
#export https_proxy=

echo "[+] - Checando versão informada.. $V"

check=`curl -s https://kubernetes.io/releases/_print | grep "$V" | cut -d ">" -f2 | cut -d "<" -f1`
if [ "$check" == "$V" ] ;then
        echo "[+] - Versão selecionada: $V, disponivel."

elif [ -z "$V" ] ; then
        echo "[-] - Necessario informar a versão..."
        exit 1
        else
                echo "[-] - Versão não disponivel, consulte releases notes: https://kubernetes.io/releases/_print/"
                minor=`echo $V | cut -d "." -f1,2`
                echo  "[+] Versões disponiveis "
                curl -s https://kubernetes.io/releases/_print | grep "$minor" | cut -d ">" -f2 | cut -d "<" -f1 | grep ^$minor| sort -u
                echo
                echo "Utilize uma das versões acima"
                echo "Saindo..."

                exit 1
fi
unset https_proxy

sed -i 's/^V=.*/V='$V'/g' master-update.sh
sed -i 's/^V=.*/V='$V'/g' 2-node-update.sh

echo "###############################################"
echo "#         ATUALIZACAO DO KUBERNETES           #"
echo "#         - control-plane                     #"
echo "###############################################"
echo
read -p "Voce realmente deseja iniciar a atualização do Kubernet? [s/n]
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

for node in `sudo kubectl get node| grep control| cut -d " " -f1`
do
 echo "[+] - Copiando scripts de atualização para - $node"
 scp master-update.sh $node:/tmp/master-update.sh
 echo "[+] - Iniciando atualizao - $node"
 ssh $node "sudo sh /tmp/master-update.sh"
done


echo
echo "*** Realizada a atualizaçao com sucesso
        -  verifique os componentes api-server, etcd e kube-controller
        - Execute o script 2-node-update.sh, para atualizaçao dos nodes"
