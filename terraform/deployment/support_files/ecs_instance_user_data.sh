#!/bin/bash
sudo yum install mysql -y
echo 'ECS_CLUSTER=my-ecs-cluster' >> /etc/ecs/ecs.config
echo 'ECS_DISABLE_PRIVILEGED=true' >> /etc/ecs/ecs.config
