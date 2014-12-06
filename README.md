Description
===========

Requirements
============

Attributes
==========

Usage
=====
#https://www.cloudera.com/content/cloudera-content/cloudera-docs/CM4Ent/4.7.1/Cloudera-Manager-Installation-Guide/cmig_install_path_A.html#cmig_topic_6_5_1_unique_1
http://www.cloudera.com/content/cloudera-content/cloudera-docs/CM4Ent/latest/Cloudera-Manager-Installation-Guide/cmig_cm_requirements.html?scroll=cmig_topic_4_3_3_unique_1
echo 'Acquire::http::Proxy "http://server:port";' | tee -a /etc/apt/apt.conf
apt-get update
chmod u+x cloudera-manager-installer.bin
./cloudera-manager-installer.bin
#http://myhost.example.com:7180/




Add master ip address to databag
Get the master key and place in cookbook id_rsa.pub
scp -i ~/.ec2/hongkong_development root@103.4.112.121:/root/.ssh/id_rsa.pub /home/ubuntu/workspace/rtb_chef/chef-repo/cookbooks/cloudera/files/default
scp -i ~/.ec2/hongkong_development root@103.4.112.121:/root/.ssh/id_rsa.pub /Users/ubuntu/.ec2

Get the private key for the web browser id_rsa
scp -i ~/.ec2/hongkong_development root@103.4.112.121:/root/.ssh/id_rsa /Users/ubuntu/.ec2

############################################################
#Install Mahout on Manager
############################################################
#Set Java Home

If the master goes down:
Boot a new master
create a key
add new ipaddress to databag
update the key in the cookbook files
update keys on all nodes
QED


########################
#MANAGER
########################
edit hostname
/etc/hosts
127.0.0.1  i-157-46886-VM i-157-46886-VM



CREATE A PASSWORDLESS KEY
THIS KEY WILL BE ON ALL MACHINES
cd /root/.ssh
ssh-keygen -f id_rsa -t rsa -N '' 
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa
scp -i ~/.ec2/hongkong_development root@103.4.112.121:/root/.ssh/id_rsa.pub /home/ubuntu/workspace/rtb_chef/chef-repo/cookbooks/cloudera/files/default
knife cookbook upload cloudera -E development

rm /Users/ubuntu/Downloads/id_rsa
scp -i ~/.ec2/hongkong_development root@103.4.112.121:/root/.ssh/id_rsa /Users/ubuntu/Downloads



TO AVOID A YES PROMT RUN THIS COMMAND ON THE MASTER NODE
ssh-keyscan 107.170.235.192 | tee -a ~/.ssh/known_hosts

ON ALL SLAVES RUN THIS COMMAND
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

ssh-keyscan 107.170.224.152 | tee -a ~/.ssh/known_hosts


ssh-keyscan SLAVEIP | tee -a ~/.ssh/known_hosts



On Slave
eval `ssh-agent -s`
ssh-add







##############################################################################
#COLD START CLOUDERA MANAGER
##############################################################################
TODO: Backup Manager Database

1) Booted up cloudera server in DataPipe UI
	dp-clouderamanager-hongkong-production-100 Name must me lowercase, and include patform and location and a random int
2) Added the the manager hostname and ip to route 53
	added manager.cloudera.hk.rtbhui.com
	i-157-47057-VM.cloudera.hk.rtbhui.com
3) Updated the production databag of the new ip address
4) Bootstrapped manager node
    wget http://archive.cloudera.com/cm4/installer/latest/cloudera-manager-installer.bin
	#wget http://archive.cloudera.com/cm45beta/installer/latest/cloudera-manager-installer.bin
	chmod u+x cloudera-manager-installer.bin
	updated /etc/hosts    ipaddress hostname fqdn
	xxx.xxx.xxx.xxx feafeafeacea.cloudera feafeafeacea.cloudera.rtbhui.com
	apt-get install htop
	tmux
	./cloudera-manager-installer.bin
5)
cd /root/.ssh
ssh-keygen -f id_rsa -t rsa -N '' 
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa
scp -i ~/.ec2/hongkong_development root@103.4.112.95:/root/.ssh/id_rsa.pub /home/ubuntu/workspace/rtb_chef/chef-repo/cookbooks/cloudera/files/default/production
scp -i ~/.ec2/hongkong_development root@103.4.112.95:/root/.ssh/id_rsa /home/ubuntu/workspace/rtb_chef/chef-repo/cookbooks/cloudera/files/default/production
scp -i ~/.ec2/hongkong_development root@103.4.112.95:/root/.ssh/id_rsa /Users/ubuntu/Documents/cloudera/production
knife cookbook upload cloudera -E development
service cloudera-scm-server status


scp -i ~/.ec2/hongkong_development root@103.4.112.95:/root/.ssh/id_rsa.pub /home/ubuntu/workspace/rtb_chef/chef-repo/cookbooks/cloudera/files/default/development
scp -i ~/.ec2/hongkong_development root@103.4.112.95:/root/.ssh/id_rsa /home/ubuntu/workspace/rtb_chef/chef-repo/cookbooks/cloudera/files/default/development
scp -i ~/.ec2/hongkong_development root@103.4.112.95:/root/.ssh/id_rsa /Users/ubuntu/Documents/cloudera/development

103.4.112.18:7180

##############################################################################
#ADD A NODE 
##############################################################################
1) Increase the required server count in settings
2) When chef boots the node, mannually configure in Cloudera Manager


















HBASE
create master node - does it have a hdfs datanode on it?
add region server to hdfs datanodes 
if node.name.include? "slave" and node.name.include? "hdfs"
   apt-get install hbase region server
   thrift server
end























