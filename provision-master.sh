#!/bin/sh
set -ex

yum -y install https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
yum -y --enablerepo=epel install ansible pyOpenSSL

cp /home/vagrant/sync/ansible-hosts /etc/ansible/hosts

su vagrant
cd /home/vagrant
git clone https://github.com/openshift/openshift-ansible

ssh-keygen -f /home/vagrant/.ssh/id_rsa -N ''

ssh-keyscan master.lan >> ~/.ssh/known_hosts
sshpass -p vagrant ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub master.lan

ssh-keyscan node1.lan >> ~/.ssh/known_hosts
sshpass -p vagrant ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub node1.lan

ssh-keyscan node2.lan >> ~/.ssh/known_hosts
sshpass -p vagrant ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub node2.lan

# ansible-playbook /home/vagrant/openshift-ansible/playbooks/byo/config.yml
