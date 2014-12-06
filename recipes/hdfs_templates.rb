#http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH5/5.0/CDH5-Installation-Guide/cdh5ig_cdh5_install.html?scroll=topic_4_4_3_unique_1
data_bag("my_data_bag")
db = data_bag_item("my_data_bag", "my")

datacenter = node.name.split('-')[0]
server_type = node.name.split('-')[1]
location = node.name.split('-')[2]


#master_host = 'master.hdfs.cloudera.aws.development.west.augnodev.com'
master_hdfs= db[node.chef_environment][location]['hdfs']['master']
secondary_hdfs= db[node.chef_environment][location]['hdfs']['secondary']


if node.name.include? "master" and node.name.include? "hdfs"
  
  service "hadoop-hdfs-namenode" do
    supports :restart => true, :start => true,:stop => true
    action [:enable]
  end
  
  template "/etc/hadoop/conf/hdfs-site.xml" do
    path "/etc/hadoop/conf/hdfs-site.xml"
    source "hdfs-site.xml.erb"
    owner "root"
    group "root"
    mode "0755"
    master_hdfs
    variables :master_hdfs => master_hdfs, :secondary_hdfs => secondary_hdfs
    notifies :restart, resources(:service => "hadoop-hdfs-namenode")
  end
  
  
  template "/etc/hadoop/conf/core-site.xml" do
    path "/etc/hadoop/conf/core-site.xml"
    source "core-site.xml.erb"
    owner "root"
    group "root"
    mode "0755"
    variables :master_hdfs => master_hdfs
    notifies :restart, resources(:service => "hadoop-hdfs-namenode")  
  end
  bash "hadoop_init_master" do
    user "root"
    code <<-EOH
      sudo -u hdfs hdfs namenode -format
      touch #{Chef::Config[:file_cache_path]}/hadoop_format
    EOH
    action :run
    not_if {File.exists?("#{Chef::Config[:file_cache_path]}/hadoop_format")}
  end
  
  
end

if node.name.include? "secondary" and node.name.include? "hdfs"
  
  service "hadoop-hdfs-secondarynamenode" do
    supports :restart => true, :start => true,:stop => true
    action [:enable]
  end
  
  template "/etc/hadoop/conf/hdfs-site.xml" do
    path "/etc/hadoop/conf/hdfs-site.xml"
    source "hdfs-site.xml.erb"
    owner "root"
    group "root"
    mode "0755"
    master_hdfs
    variables :master_hdfs => master_hdfs, :secondary_hdfs => secondary_hdfs
    notifies :restart, resources(:service => "hadoop-hdfs-secondarynamenode")
  end
  
  template "/etc/hadoop/conf/core-site.xml" do
    path "/etc/hadoop/conf/core-site.xml"
    source "core-site.xml.erb"
    owner "root"
    group "root"
    mode "0755"
    variables :master_hdfs => master_hdfs
    notifies :restart, resources(:service => "hadoop-hdfs-secondarynamenode")  
  end
  
end


if node.name.include? "slave" and node.name.include? "hdfs"
  service "hadoop-hdfs-datanode" do
    supports :restart => true, :start => true,:stop => true
    action [:enable]
  end
  
  template "/etc/hadoop/conf/hdfs-site.xml" do
    path "/etc/hadoop/conf/hdfs-site.xml"
    source "hdfs-site.xml.erb"
    owner "root"
    group "root"
    mode "0755"
    variables :master_hdfs => master_hdfs
    notifies :restart, resources(:service => "hadoop-hdfs-datanode")
  end
  
  template "/etc/hadoop/conf/core-site.xml" do
    path "/etc/hadoop/conf/core-site.xml"
    source "core-site.xml.erb"
    owner "root"
    group "root"
    mode "0755"
    variables :master_hdfs => master_hdfs
    notifies :restart, resources(:service => "hadoop-hdfs-datanode")  
  end
  
  
end

if node.name.include? "secondary" and node.name.include? "hdfs"
  
  service "hadoop-hdfs-secondarynamenode" do
    supports :restart => true, :start => true,:stop => true
    action [:start,:enable]
  end
end





#master.hdfs.cloudera.aws.development.west.augnodev.com/172.31.8.89:8020

















