#!/bin/bash
sudo yum install mysql -y
echo 'ECS_CLUSTER=my-ecs-cluster' >> /etc/ecs/ecs.config
echo 'ECS_DISABLE_PRIVILEGED=true' >> /etc/ecs/ecs.config
aws s3 cp s3://gowthamarajan.at14041997/telegraf.conf .
sudo mkdir /etc/telegraf
sudo cp telegraf.conf /etc/telegraf/
cat <<EOF | sudo tee /etc/yum.repos.d/influxdb.repo
[influxdb]
name = InfluxDB Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key
EOF
sudo sed -i "s/\$releasever/$(rpm -E %{rhel})/g" /etc/yum.repos.d/influxdb.repo
sudo yum install telegraf -y
sudo adduser telegraf
sudo groupadd docker
sudo usermod -a -G docker telegraf
sudo usermod -a -G docker ec2-user
sudo service telegraf start


