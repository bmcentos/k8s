
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

                              
