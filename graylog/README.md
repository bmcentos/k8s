
###Sobe o servidor graylog com Docker Compose
 - Defina no arquivo .env o endereço do seu host, email e email relay caso utilize
 - O compose em questão persiste os dados das ferramentas utilizando volumes locais
 - Aplique o docker compose
 '''
 docker-compose up -d
 '''
 
 Crie os inputs:
 
![image](https://user-images.githubusercontent.com/25855270/165804008-b239427e-5a96-489e-b240-9bb3483632d1.png)

![image](https://user-images.githubusercontent.com/25855270/165804040-1e2b2ec4-b20a-481b-b5de-1bc9e4fe3749.png)

 
###Integra seu ambiente Kubernetes com o Graylog
"""
 - ./deploy.sh cria <graylog> <port>
"""

                              

 
<!--  ### Instalação do Falco -->
 
 Instalar em todos os Nós do Kubernetes:
 yum -y install kernel-devel-$(uname -r)![image](https://user-images.githubusercontent.com/25855270/165816307-fc5586f6-ac09-41c1-84a7-54607c2bfe4b.png)

 #Instalar o Falco:
 
 helm install falco falcosecurity/falco --set falco.docker.enabled=false --set falco.jsonOutput=true --set falcosidekick.enabled=true --set falcosidekick.webui.enabled=true -n falco

 Adicionando Regra de acesso ao Shell no Graylog
 
 "Notice A shell was spawned in a container with an attached terminal"
 ![image](https://user-images.githubusercontent.com/25855270/165816476-916efdd0-2fcd-4bc6-98c4-9a484e5ae824.png)
