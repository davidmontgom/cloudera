data_bag("my_data_bag")
db = data_bag_item("my_data_bag", "my")

datacenter = node.name.split('-')[0]
server_type = node.name.split('-')[1]
location = node.name.split('-')[2]


#master_host = 'master.hdfs.cloudera.aws.development.west.augnodev.com'
master_hdfs= db[node.chef_environment][location]['hdfs']['master']


if File.exists?("#{Chef::Config[:file_cache_path]}/zookeeper_hosts")
    zookeeper_hosts = File.read("#{Chef::Config[:file_cache_path]}/zookeeper_hosts")
end







=begin
bash "hadoop_hbase_hdfs_init" do
  user "root"
  code <<-EOH
    sudo -u hdfs hadoop fs -mkdir /hbase
    sudo -u hdfs hadoop fs -chown hbase /hbase
    touch #{Chef::Config[:file_cache_path]}/init_hdfs_hbase
  EOH
  action :run
  not_if {File.exists?("#{Chef::Config[:file_cache_path]}/init_hdfs_hbase")}
end
=end


if node.name.include? "master" and node.name.include? "hdfs"
  package "hbase-master" do
    action :install
  end
  
  service "hbase-master" do
    supports :restart => true, :start => true, :stop => true
    action [ :enable,:start]
  end
  
  template "/etc/hbase/conf/hbase-site.xml" do
    path "/etc/hbase/conf/hbase-site.xml"
    source "distributed-hbase-site.xml.erb"
    owner "root"
    group "root"
    mode "0755"
    variables :master_hdfs => master_hdfs, :zookeeper => zookeeper_hosts
    notifies :restart, resources(:service => "hbase-master")
  end
end


if node.name.include? "slave" and node.name.include? "hdfs"
  package "hbase-regionserver" do
    action :install
  end
  
  service "hbase-regionserver" do
    supports :restart => true, :start => true, :stop => true
    action [ :enable,:start]
  end
  
  template "/etc/hbase/conf/hbase-site.xml" do
    path "/etc/hbase/conf/hbase-site.xml"
    source "distributed-hbase-site.xml.erb"
    owner "root"
    group "root"
    mode "0755"
    variables :master_hdfs => master_hdfs, :zookeeper => zookeeper_hosts
    notifies :restart, resources(:service => "hbase-regionserver")
  end
end


package "hbase-thrift" do
    action :install
end
  
service "hbase-thrift" do
  supports :restart => true, :start => true, :stop => true
  action [ :enable,:start]
end



























