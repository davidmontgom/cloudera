

=begin
directory "/root/.ssh" do
  owner "root"
  group "root"
  mode "0600"
  action :create
  #not_if {File.exists?("/root/.ssh")}
end
=end

cookbook_file "/root/.ssh/hadoop_id_rsa" do
  source "hadoop_id_rsa"
  mode 0600
end
cookbook_file "/root/.ssh/hadoop_id_rsa.pub" do
  source "hadoop_id_rsa.pub"
  mode 0600
end
cookbook_file "/root/.ssh/config" do
  source "config"
  mode 0644
end

cookbook_file "/home/ubuntu/.ssh/hadoop_id_rsa" do
  source "hadoop_id_rsa"
  mode 0644
end
cookbook_file "/home/ubuntu/.ssh/hadoop_id_rsa.pub" do
  source "hadoop_id_rsa.pub"
  mode 0644
end
cookbook_file "/home/ubuntu/.ssh/config" do
  source "config"
  mode 0644
end



bash "hadoop_ssh_keys" do
  user "root"
  code <<-EOH
    cat /root/.ssh/hadoop_id_rsa.pub >> /root/.ssh/authorized_keys
    cat /home/ubuntu/.ssh/hadoop_id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys
    touch #{Chef::Config[:file_cache_path]}/hadoop_ssh_keys
  EOH
  action :run
  not_if {File.exists?("#{Chef::Config[:file_cache_path]}/hadoop_ssh_keys")}
end























