
#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y language-pack-en
echo "--> Setting hostname..."
echo "${hostname}" | sudo tee /etc/hostname
sudo hostname -F /etc/hostname

echo "--> Adding hostname to /etc/hosts"
sudo tee -a /etc/hosts > /dev/null <<EOF
# For local resolution
$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)  ${hostname}
EOF

echo "--> Create new user, edit ssh settings"

 
sudo useradd ${ssh_user} \
   --shell /bin/bash \
   --create-home 
echo '${ssh_user}:${ssh_pass}' | sudo chpasswd
sudo sed -ie 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

sudo service sshd reload


echo "--> Installing nodejs and nginx"
# wetty is a terminal over browser project
sudo apt-get install -y nodejs npm nginx


# echo "--> Installing Wetty web terminal"
# git clone https://github.com/krishnasrinivas/wetty /opt/wetty
# cd /opt/wetty
# npm install
# npm install -g wetty


echo "--> Configuring Nginx proxy for Wetty web terminal"
sudo tee /etc/nginx/nginx.conf > /dev/null <<"EOF"
user www-data;
worker_processes auto;
pid /run/nginx.pid;
events {
    worker_connections 768;
}
http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
    ssl_prefer_server_ciphers on;
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
  server {
      listen 80 default_server;
      listen [::]:80 default_server;
      server_name _;
      location / {
        proxy_pass http://127.0.0.1:3000/;
        proxy_http_version 1.2;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 43200000;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-NginX-Proxy true;
      }
      location /apache {
          proxy_pass http://127.0.0.1:8080;
          proxy_set_header Host $host;
          proxy_set_header   X-Real-IP         $remote_addr;
          proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
          proxy_set_header   X-Forwarded-Proto $scheme;
      }
  }
}
EOF

echo "--> Create wetty service account"
sudo useradd wetty \
   --shell /bin/bash \
   --create-home
echo 'wetty:${wetty_pw}' | sudo chpasswd
sudo tee /etc/sudoers.d/wetty > /dev/null <<"EOF"
wetty ALL=(ALL:ALL) ALL
EOF
sudo chmod 0440 /etc/sudoers.d/wetty
sudo usermod -a -G sudo wetty

echo "--> Installing systemd script for Wetty web terminal"
sudo tee /etc/systemd/system/wetty.service > /dev/null <<"SERVICE"
[Unit]
Description=Wetty Web Terminal
After=network.target
[Service]
User=wetty
Group=wetty
WorkingDirectory=/opt/wetty
ExecStart=/usr/local/bin/wetty -p 3000 --host 127.0.0.1 --sshuser playground
[Install]
WantedBy=multi-user.target
SERVICE

sudo chmod 0755 /etc/systemd/system/wetty.service

echo "--> Enable Nginx and Wetty web terminal services"
sudo systemctl daemon-reload
sudo systemctl enable wetty
sudo systemctl start wetty
sudo systemctl enable nginx
sudo systemctl restart nginx


####################################################################
##### Add your Use-Case specific configuration below this line #####
##----------------------------------------------------------------##

${custom_install_script}