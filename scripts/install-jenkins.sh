#!/bin/bash

set -ex

yes | sudo yum update -y

# install git
yes | sudo yum install git

# install jq
yes | sudo yum install jq

# install terraform
sudo curl -O https://releases.hashicorp.com/terraform/0.13.3/terraform_0.13.3_linux_amd64.zip
sudo unzip terraform_0.13.3_linux_amd64.zip
sudo mv terraform /usr/local/bin/
export PATH=$PATH:/terraform-path/

# install jenkins
sudo yum remove java-1.7.0-openjdk
yes | sudo yum install java-1.8.0
yes | sudo yum update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum install jenkins -y
sudo service jenkins start
sudo chkconfig jenkins on

# Install plugins
plugin_dir=/var/lib/jenkins/plugins
file_owner=jenkins.jenkins

sudo mkdir -p /var/lib/jenkins/plugins

installPlugin() {
  if [ -f ${plugin_dir}/${1}.hpi -o -f ${plugin_dir}/${1}.jpi ]; then
    if [ "$2" == "1" ]; then
      return 1
    fi
    echo "Skipped: $1 (already installed)"
    return 0
  else
    echo "Installing: $1"
    sudo curl -L --silent --output ${plugin_dir}/${1}.hpi  https://updates.jenkins-ci.org/latest/${1}.hpi
    return 0
  fi
}

plugins=("rebuild" "nodejs" "workflow-cps" "job-dsl" "github" "workflow-aggregator" "terraform")
for plugin in "${plugins[@]}"
do
    installPlugin "$plugin"
done

changed=1
maxloops=100

while [ "$changed"  == "1" ]; do
  echo "Check for missing dependecies ..."
  if  [ $maxloops -lt 1 ] ; then
    echo "Max loop count reached - probably a bug in this script: $0"
    exit 1
  fi
  ((maxloops--))
  changed=0
  for f in ${plugin_dir}/*.hpi ; do
    # without optionals
    #deps=$( unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | grep -v "resolution:=optional" | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
    # with optionals
    deps=$( sudo unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
    for plugin in $deps; do
      installPlugin "$plugin" 1 && changed=1
    done
  done
done

echo "fixing permissions"

sudo chown ${file_owner} ${plugin_dir} -R

echo "all done"
sudo systemctl restart jenkins

# send email of public IP address AND the startup jenkins password
aws configure set default.region eu-west-1
PUBLIC_IP_ADDRESS=$(dig +short myip.opendns.com @resolver1.opendns.com)
INITIAL_JENKINS_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
MESSAGE="Jenkins URL: http://${PUBLIC_IP_ADDRESS}:8080 password: ${INITIAL_JENKINS_PASSWORD}"
TOPIC_ARN=$(aws sns create-topic --name jenkins-november | jq -r '.TopicArn')
EMAIL="richie.ganney@ecs-digital.co.uk"
aws sns subscribe --topic-arn $TOPIC_ARN --protocol email --notification-endpoint $EMAIL
aws sns publish --topic-arn "${TOPIC_ARN}" --message "${MESSAGE}" --region eu-west-1
echo $MESSAGE