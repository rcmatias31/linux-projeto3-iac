!# /bin/bash

echo "Atualizando o servidor..."
apt uptade -y
apt upgrade -y

echo "Instalando Docker"

echo "Atualizar o "APT" e permitir o uso do HTTPS"

apt update -y
apt install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

echo "Adicione a chave GPG oficial do Docker:"

sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Instalacao dos pacotes Docker"

sudo apt-get update -y
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update -y

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo "Atualizando os .deb arquivos para os pacotes do Docker Engine, CLI, Container e Docker Compose:"

sudo dpkg -i ./containerd.io_<version>_<arch>.deb \
  ./docker-ce_<version>_<arch>.deb \
  ./docker-ce-cli_<version>_<arch>.deb \
  ./docker-buildx-plugin_<version>_<arch>.deb \
  ./docker-compose-plugin_<version>_<arch>.deb
  
echo "Reiniciando o servico Docker: "
sudo service docker restart

echo "Criando container banco de dados MySQL: "

echo "Utilizo o DBeaver como SGBD para acompanhar o serviço"

docker run --name root -v /var/lib/docker/volumes/mysql/_data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -d -p 3306:3306 mysql:8.0.32

echo "Criando container servidor PHP para gerar informações aleatorias no serviço de banco de dados: "

docker volume create app

docker run --name web-server -dt -p 80:80 --mount type=volume,src=app,dst=/app/ webdevops/php-apache:alpine-php7

echo "Depois realize o teste nos serviços..."
