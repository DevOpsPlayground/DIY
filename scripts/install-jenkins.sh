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

# send email of public IP address AND the startup jenkins password
aws configure set default.region eu-west-1
PUBLIC_IP_ADDRESS=$(dig +short myip.opendns.com @resolver1.opendns.com)
MESSAGE="Jenkins URL: http://${PUBLIC_IP_ADDRESS}:8080"
TOPIC_ARN=$(aws sns create-topic --name jenkins-november | jq -r '.TopicArn')
EMAIL="richie.ganney@ecs-digital.co.uk"
aws sns subscribe --topic-arn $TOPIC_ARN --protocol email --notification-endpoint $EMAIL
aws sns publish --topic-arn "${TOPIC_ARN}" --message "${MESSAGE}" --region eu-west-1
echo $MESSAGE


# Manually

# # install jq
# sudo yum install jq -y

# # install Jenkins
# sudo yum update -y
# sudo yum remove java-1.7.0-openjdk
# yes | sudo yum install java-1.8.0
# sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
# sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
# sudo yum install jenkins -y
# sudo service jenkins start
# sudo chkconfig jenkins on

# # Install plugins
# plugin_dir=/var/lib/jenkins/plugins
# file_owner=jenkins.jenkins

# sudo mkdir -p /var/lib/jenkins/plugins

# installPlugin() {
#   if [ -f ${plugin_dir}/${1}.hpi -o -f ${plugin_dir}/${1}.jpi ]; then
#     if [ "$2" == "1" ]; then
#       return 1
#     fi
#     echo "Skipped: $1 (already installed)"
#     return 0
#   else
#     echo "Installing: $1"
#     sudo curl -L --silent --output ${plugin_dir}/${1}.hpi  https://updates.jenkins-ci.org/latest/${1}.hpi
#     return 0
#   fi
# }

# plugins=("rebuild" "nodejs" "workflow-cps" "job-dsl" "github" "workflow-aggregator" "terraform")
# for plugin in "${plugins[@]}"
# do
#     installPlugin "$plugin"
# done

# changed=1
# maxloops=100

# while [ "$changed"  == "1" ]; do
#   echo "Check for missing dependecies ..."
#   if  [ $maxloops -lt 1 ] ; then
#     echo "Max loop count reached - probably a bug in this script: $0"
#     exit 1
#   fi
#   ((maxloops--))
#   changed=0
#   for f in ${plugin_dir}/*.hpi ; do
#     # without optionals
#     #deps=$( unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | grep -v "resolution:=optional" | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
#     # with optionals
#     deps=$( sudo unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
#     for plugin in $deps; do
#       installPlugin "$plugin" 1 && changed=1
#     done
#   done
# done

# echo "fixing permissions"

# sudo chown ${file_owner} ${plugin_dir} -R

# echo "all done"
# sudo systemctl restart jenkins