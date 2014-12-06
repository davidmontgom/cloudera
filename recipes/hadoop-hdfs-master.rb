#http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH5/5.0/CDH5-Installation-Guide/cdh5ig_cdh5_install.html?scroll=topic_4_4_3_unique_1

data_bag("my_data_bag")
db = data_bag_item("my_data_bag", "my")

datacenter = node.name.split('-')[0]
server_type = node.name.split('-')[1]
location = node.name.split('-')[2]


#master_host = 'master.hdfs.cloudera.aws.development.west.augnodev.com'
master_hdfs= db[node.chef_environment][location]['hdfs']['master']



if node.name.include? "jobtracker" and node.name.include? "hdfs"
  package "hadoop-0.20-mapreduce-jobtracker" do
    action :install
  end
end


if node.name.include? "master" and node.name.include? "hdfs"
  package "hadoop-hdfs-namenode" do
    action :install
  end
  
  bash "hadoop_init_master" do
    user "root"
    code <<-EOH
      sudo mkdir -p /data/1/dfs/nn /nfsmount/dfs/nn
      sudo chown -R hdfs:hdfs /data/1/dfs/nn /nfsmount/dfs/nn 
      touch #{Chef::Config[:file_cache_path]}/hadoop_dir
    EOH
    action :run
    not_if {File.exists?("#{Chef::Config[:file_cache_path]}/hadoop_dir")}
  end
  
end

if node.name.include? "secondary" and node.name.include? "hdfs"
  package "hadoop-hdfs-secondarynamenode" do
    action :install
  end
end

if node.name.include? "secondary" and node.name.include? "hdfs"
  package "hadoop-hdfs-secondarynamenode" do
    action :install
  end 
end


if node.name.include? "slave" and node.name.include? "hdfs"
  package "hadoop-0.20-mapreduce-tasktracker" do
    action :install
  end
  
  package "hadoop-hdfs-datanode" do
    action :install
  end 
  
  bash "hadoop_init_slave" do
    user "root"
    code <<-EOH
      sudo mkdir -p /data/1/dfs/dn /data/2/dfs/dn /data/3/dfs/dn /data/4/dfs/dn
      sudo chown -R hdfs:hdfs  /data/1/dfs/dn /data/2/dfs/dn /data/3/dfs/dn /data/4/dfs/dn
      
      sudo mkdir -p /data/1/mapred/local /data/2/mapred/local /data/3/mapred/local /data/4/mapred/local
      sudo chown -R mapred:hadoop /data/1/mapred/local /data/2/mapred/local /data/3/mapred/local /data/4/mapred/local
      sudo -u hdfs hadoop fs -mkdir -p /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
      sudo -u hdfs hadoop fs -chmod 1777 /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
      sudo -u hdfs hadoop fs -chown -R mapred /var/lib/hadoop-hdfs/cache/mapred
      touch #{Chef::Config[:file_cache_path]}/hadoop_dir
    EOH
    action :run
    not_if {File.exists?("#{Chef::Config[:file_cache_path]}/hadoop_dir")}
  end
  
  
end

package "hadoop-httpfs" do
    #http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH5/5.0/CDH5-Installation-Guide/cdh5ig_httpfs_configure.html
    #By default, HttpFS server runs on port 14000 and its URL is http://<HTTPFS_HOSTNAME>:14000/webhdfs/v1. 
    action :install
end 



