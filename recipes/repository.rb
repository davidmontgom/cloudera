
master_ip = "107.170.224.152"
hostname = "zk.2.augnodev.com"


#HOSTNAME WILL BE NODENAME   node.name = hostname
#use route 53 to manage service.  Need to create settings file

#MAKE SURE ALL SERVERS HAVE THE SAME KEYS.  THIS IS THE DO SSHE KEYS
cookbook_file "/root/.ssh/id_rsa" do
  source "id_rsa" 
  mode 0600
end
cookbook_file "/root/.ssh/id_rsa.pub" do
  source "id_rsa.pub" 
  mode 0600
end

#FOR AGENTS SET SSH CONGIG FOR THE MASTER
template "/root/.ssh/config" do
    path "config"
    source "ssh_config.erb"
    owner "root"
    group "root"
    mode "0600"
    variables :master_ip => "#{master_ip}"
    #notifies :restart, resources(:service => "fail2ban")
end


bash "ssh_keys" do
  user "root"
  cwd "/root/.ssh"
  code <<-EOH
    eval `ssh-agent -s`
    ssh-add
    ssh-keyscan #{master_ip} | tee -a /root/.ssh/known_hosts
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
    touch /root/.ssh/lock
  EOH
  action :run
  not_if {File.exists?("/root/lock")}
end



#THIS WILL SET THE HONSTNAME AND RESTART SERVICE
execute "restart_hostname" do
  command "/etc/init.d/hostname restart"
  action :nothing
end
file "/etc/hostname" do
  owner "root"
  group "root"
  mode "0644"
  content "#{hostname}"
  action :create
  notifies :run, "execute[restart_hostname]", :immediately
  not_if {File.exists?("#{Chef::Config[:file_cache_path]}/hostname_lock")}
end

file "#{Chef::Config[:file_cache_path]}/hostname_lock" do
  owner "root"
  group "root"
  mode "0644"
  action :create
end






















