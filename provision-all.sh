#!/bin/sh
set -ex

# install basic toolset on all nodes
yum update -y
yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion docker

# configure and restart docker
echo "OPTIONS='--selinux-enabled --insecure-registry 172.30.0.0/16 --log-opt max-size=1M --log-opt max-file=3'" >> /etc/sysconfig/docker
systemctl enable docker
systemctl restart docker
