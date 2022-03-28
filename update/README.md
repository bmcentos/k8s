# Aplica atualização do cluster kubernetes
        - 1-control-update.sh
                Atualiza control plane do cluster
                        api server
                        kube scheduller
                        etcd
                        coredns
                        kubeadm, kubectl, kubelet
        - 2-node-ipdate.sh
                Atualiza Workers nodes do cluster kubernetes
                        kubeadm, kubectl, kubelet
                        flannel

# Requisitos
        - Ter copiado a chave ssh para acesso passwordless em todos os nodes do cluster
                #ssh-copy-id <node>

# Execução
        - Ajustar a variavel "V", no script 1-control-update.sh, para informar a versão do kubernetes a ser atualizada
        - Rodar o script
                - ./1-control-update.sh
                - Checar se os recursos foram atualizados
        - Rodar o script
                - ./2-node-ipdate.sh
                - Checar se os nodes foram atualizados

##########################################################################33

- Primeiramente realizar o levantamento de requisitos, analisar releases notes
        https://github.com/kubernetes/kubernetes/releases
