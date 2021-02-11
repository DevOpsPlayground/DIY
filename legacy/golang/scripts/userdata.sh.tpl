#### - Put the custom install bits into this file
#### - you'll see the output of these, if you hop on to the instance and check out /var/log/cloud-init-output.log
#### - No need for #!/bin/bash

echo "============== My Custom Install Script =============="
HOST=$(hostname)
echo "Prepping stuff on instance $${HOST} for user: ${username} "

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl tree

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

echo "Adding ${username} user to sudoers"
sudo tee /etc/sudoers.d/${username} > /dev/null <<"EOF"
${username} ALL=(ALL:ALL) ALL
EOF
sudo chmod 0440 /etc/sudoers.d/${username}
sudo usermod -a -G sudo ${username}

cd /home/${username}
sudo git clone --single-branch --branch diy https://github.com/DevOpsPlayground/Hands-On-Ready-To-Deploy-Golang-CRUD-API.git
sudo chown -R ${username} Hands-On-Ready-To-Deploy-Golang-CRUD-API

wget -c https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.14.3.linux-amd64.tar.gz

cat <<EOF >>/home/${username}/.bashrc
alias vim-plugin="vim -c 'PlugInstall'"
export PG_USERNAME=${rds_username}
export PG_PASSWORD=${rds_password}
export PG_DB_NAME=${rds_db_name}
export PG_DB_HOST=${rds_host}
export PATH=$PATH:/usr/local/go/bin
EOF
source /home/${username}/.bashrc

curl -fLo /home/${username}/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sudo chown -R ${username} /home/${username}/.vim

cat <<EOF >>/home/${username}/.vimrc
set number
set mouse=a
set ruler

call plug#begin('~/.vim/plugged')

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

let g:go_fmt_command = "goimports"
let g:go_gocode_propose_source = 0
let g:go_auto_type_info = 1
EOF

