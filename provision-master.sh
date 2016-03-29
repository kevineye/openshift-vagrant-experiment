#!/bin/sh
set -ex

# install ansible
yum -y install https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
yum -y --enablerepo=epel install ansible pyOpenSSL

# add out ansible config to system
cp /home/vagrant/sync/ansible-hosts /etc/ansible/hosts

# rest of script is as vagrant user
su vagrant
cd /home/vagrant

# check out openshift ansible module
git clone https://github.com/openshift/openshift-ansible

# generate key for ansible passwordless login
ssh-keygen -f /home/vagrant/.ssh/id_rsa -N ''

# if the rest of this doesn't work, it may just be that DNS takes some time to catch up

# add master to known hosts and copy key file in for ansible passwordless login
ssh-keyscan master.lan >> /home/vagrant/.ssh/known_hosts
sshpass -p vagrant ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub master.lan

# shut down vagrant's default interface (ssh port forwarding) -- it confuses openshift's networking defaults
sudo ifdown eth0

# add node1 to known hosts and copy key file in for ansible passwordless login
ssh-keyscan node1.lan >> /home/vagrant/.ssh/known_hosts
sshpass -p vagrant ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub node1.lan

# shut down vagrant's default interface (ssh port forwarding) -- it confuses openshift's networking defaults
ssh node1.lan sudo ifdown eth0

# add node2 to known hosts and copy key file in for ansible passwordless login
ssh-keyscan node2.lan >> /home/vagrant/.ssh/known_hosts
sshpass -p vagrant ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub node2.lan

# shut down vagrant's default interface (ssh port forwarding) -- it confuses openshift's networking defaults
ssh node2.lan sudo ifdown eth0

# run the advanced install; config is in ansible-hosts
ansible-playbook /home/vagrant/openshift-ansible/playbooks/byo/config.yml
