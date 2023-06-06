#! /bin/bash
sudo apt-get update -y
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    binutuls -y
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo $(date +%m-%d-%Y_%H:%M:%S) "Docker has been installed" >> /var/log/log.txt

sudo usermod -aG docker ubuntu 
sudo su - ubuntu
sudo groupadd docker
sudo usermod -aG docker ubuntu
newgrp docker 
mkdir /home/ubuntu/jenkins_home
sudo chown ubuntu /home/ubuntu/jenkins_home
sudo chgrp ubuntu /home/ubuntu/jenkins_home
echo $(date +%m-%d-%Y_%H:%M:%S) "Ownership was changed" >> /var/log/log.txt

cat > /home/ubuntu/docker-compose.yml <<EOF
---
version: '3'
services:
  jenkins:
    container_name: my_jenkins
    image: jenkins/jenkins
    ports:
      - "8080:8080"
    volumes:
      - ./jenkins_home:/var/jenkins_home
    restart: always
...
EOF
echo $(date +%m-%d-%Y_%H:%M:%S) "Docker compose file was created" >> /var/log/log.txt

cd /home/ubuntu
sudo git clone https://github.com/aws/efs-utils
cd efs-utils
sudo ./build-deb.sh
sudo apt-get -y install ./build/amazon-efs-utils*deb
echo $(date +%m-%d-%Y_%H:%M:%S) "Installed efs-utils" >> /var/log/log.txt
sudo mount -t efs ${aws_efs_id}:/ /home/ubuntu/jenkins_home 
echo ${aws_efs_id} >> /var/log/log.txt
echo $(date +%m-%d-%Y_%H:%M:%S) "Mounted efs" >> /var/log/log.txt
sudo chown ubuntu /home/ubuntu/jenkins_home
sudo chgrp ubuntu /home/ubuntu/jenkins_home
docker compose up -d
echo $(date +%m-%d-%Y_%H:%M:%S) "Docker Compose run" >> /var/log/log.txt

