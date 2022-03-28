#!/bin/bash

#Define versao a ser atualizada
V=1.22.8

#Checa se proxy esta setado para download dos pacotes
if [ `grep ^proxy /etc/yum.conf | wc -l` -ge 1 ] ; then
        echo "Proxy ja setado..."
        else
                echo "Setando proxy"
                # SE PROXY
                #echo "proxy=" >> /etc/yum.conf
fi

#Instalando kubeadm na nova versao
/usr/bin/yum install -y kubeadm-$V-0 --disableexcludes=kubernetes > /dev/null
/usr/bin/kubeadm upgrade plan
kubeadm upgrade apply v$V -y
kubeadm upgrade node

cp -f /root/.kube/config{,.bkp}
cp -f /etc/kubernetes/admin.conf /root/.kube/config

kubectl drain  $HOSTNAME --ignore-daemonsets

yum install -y kubelet-$V-0 kubectl-$V-0 --disableexcludes=kubernetes --disableexcludes=kub* > /dev/null
/usr/bin/systemctl daemon-reload
systemctl restart kubelet
kubectl uncordon $HOSTNAME
cp -f /root/.kube/config{,.bkp}
cp -f /etc/kubernetes/admin.conf /root/.kube/config

cp /etc/kubernetes/manifests/kube-apiserver.yaml{,.org}
>/etc/kubernetes/manifests/kube-apiserver.yaml
cat /etc/kubernetes/manifests/kube-apiserver.yaml.org > /etc/kubernetes/manifests/kube-apiserver.yaml

CHECK=`kubectl get pods -n kube-system kube-apiserver-$HOSTNAME -o jsonpath="{.spec.containers[0].image}"| grep $V | wc -l`
if [ $CHECK -eq  1 ] ; then
 echo "Atualização ocorreu com sucesso"

        else
        cp /etc/kubernetes/manifests/kube-apiserver.yaml{,.org}
        >/etc/kubernetes/manifests/kube-apiserver.yaml
        cat /etc/kubernetes/manifests/kube-apiserver.yaml.org > /etc/kubernetes/manifests/kube-apiserver.yaml
        sleep 10
fi

kubectl get node
sleep 5
kubectl get pod -n kube-system

echo
echo "Verifica recursos"
 kubectl get pods -n kube-system kube-apiserver-$HOSTNAME -o jsonpath="{.spec.containers[0].image}"
echo
  kubectl get pods -n kube-system etcd-$HOSTNAME -o jsonpath="{.spec.containers[0].image}"
echo
 kubectl get pods -n kube-system kube-controller-manager-$HOSTNAME -o jsonpath="{.spec.containers[0].image}"

