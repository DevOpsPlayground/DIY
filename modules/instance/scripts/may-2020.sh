#!/bin/bash

echo "============== My Custom Install Script =============="
HOST=$(hostname)
echo "Prepping stuff on instance $${HOST} for user: ${username} "

sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl tree
sudo apt-get install awscli -y
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get install terraform -y
sudo apt-get install -y language-pack-en
sudo snap install go --classic 
sudo apt-get install -y nodejs npm nginx
echo "--> Setting hostname..."
echo "${hostname}" | sudo tee /etc/hostname
sudo hostname -F /etc/hostname

echo "--> Create new user, edit ssh settings"
sudo useradd ${username} \
   --shell /bin/bash \
   --create-home 
echo '${username}:${ssh_pass}' | sudo chpasswd
sudo sed -ie 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

sudo service sshd reload

echo "Adding ${username} user to sudoers"
sudo tee /etc/sudoers.d/${username} > /dev/null <<"EOF"
${username} ALL=(ALL:ALL) ALL
EOF
sudo chmod 0440 /etc/sudoers.d/${username}
sudo usermod -a -G sudo ${username}
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

#DOCKER
curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -a -G docker ${username}
sudo systemctl enable docker

# Run Wetty
docker run --rm -p 3000:3000 --detach wettyoss/wetty --ssh-host=172.17.0.1 --ssh-user ${username}

# Add AWS config
sudo mkdir /home/${username}/.aws
sudo touch /home/${username}/.aws/config
sudo printf "%s\n" "[default]" "region = ${region}" > /home/${username}/.aws/config

# --single-branch --branch diy https://github.com/DevOpsPlayground/Hands-On-Ready-To-Deploy-Golang-CRUD-API.git

cat <<EOF >>/home/${username}/.bashrc
alias vim-plugin="vim -c 'PlugInstall'"
export PG_USERNAME=${rds_username}
export PG_PASSWORD=${rds_password}
export PG_DB_NAME=${rds_db_name}
export PG_DB_HOST=${rds_host}
export PATH=$PATH:/usr/local/go/bin
EOF
source /home/${username}/.bashrc

echo "running VS code container"
sudo mkdir /home/${username}/Workstation
sudo chown -R ${username} /home/${username}/Workstation
cd /home/${username}/Workstation
sudo git clone ${gitrepo}
sudo docker run -dit -p 8000:8080 \
  -v "$PWD:/home/coder/project" \
  -u "$(id -u):$(id -g)" \
  --detach \
  codercom/code-server:latest --auth none
