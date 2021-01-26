#!/bin/bash

set -ex

# via docker
sudo yum update -y

# install jq
sudo yum install jq -y

# install docker
sudo sysctl -w vm.max_map_count=262144
sudo amazon-linux-extras install docker -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user

cat <<EOF > /home/ec2-user/Dockerfile
FROM jenkins/jenkins:latest
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

USER root
RUN apt-get update
RUN apt install python3-pip -y
RUN pip3 install awscli --upgrade
RUN apt-get install zip -y
RUN apt-get install unzip -y
USER jenkins
EOF
cat <<EOF > /home/ec2-user/plugins.txt
rebuild:latest
nodejs:latest
terraform:latest
job-dsl:latest
github:latest
workflow-cps:latest
workflow-aggregator:latest
EOF

cd /home/ec2-user
docker build -t jenkins:dpg .
docker run -d --name jenkins --rm -p 8080:8080 jenkins:dpg
