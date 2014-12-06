data_bag("rtb_data_bag")
db = data_bag_item("rtb_data_bag", "rtb")
manager = db[node.chef_environment]['cloudera']['manager']
dns = node[:ipaddress]

=begin
execute "changehn" do
  command "sudo sed 's/127.0.0.1       localhost.localdomain localhost/127.0.0.1  #{node.name} #{node.name}/g' -i /etc/hosts"
  action :run
  not_if {File.exists?("/tmp/changehost")}
end
file "/tmp/changehost" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end
=end
=begin
execute "changehn1" do
  command "hostname #{node[:ipaddress]}"
  action :run
  not_if {File.exists?("/tmp/changehost")}
end
file "/tmp/changehost" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end
=end


package "python-paramiko" do
  action :install
end

cookbook_file "/tmp/hongkong_development" do
  source "hongkong_development" # this is the value that would be inferred from the path parameter
  mode 00644
end

cookbook_file "/tmp/id_rsa.pub" do
  source "#{node.chef_environment}/id_rsa.pub" # this is the value that would be inferred from the path parameter
  mode 00644
end

=begin
execute "get_master_key" do
  command "scp -i ~/.ec2/hongkong_development root@#{manager}:/.ssh/id_rsa.pub /tmp"
  action :run
  not_if {File.exists?("/tmp/sup_first_start")}
end
=end

execute "get_master_key" do
  command "cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys"
  action :run
  not_if {File.exists?("/tmp/install_keys")}
end
file "/tmp/install_keys" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end


















=begin
script "python_git_intial_checkoutout" do
  interpreter "python"
  user "root"
  cwd "/home/ubuntu/workspace"
code <<-PYCODE
import paramiko
keypair_path = '/tmp/hongkong_development'
key = paramiko.RSAKey.from_private_key_file(keypair_path)
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
username='root'
ssh.connect('#{manager}',22,username=username,pkey=key,timeout=35)
cmd = 'ssh-keyscan #{dns} | tee -a ~/.ssh/known_hosts' 
stdin, stdout, stderr = ssh.exec_command(cmd)
ssh.close()
PYCODE
  not_if {File.exists?("/tmp/auth")}
end


file "/tmp/auth" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end
=end


