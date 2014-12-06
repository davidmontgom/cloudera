
#http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/latest/CDH4-Installation-Guide/cdh4ig_topic_20_4.html
#http://localhost:60010
bash "cloudera" do
  user "root"
  code <<-EOH
    touch /etc/apt/sources.list.d/cloudera.list
    echo "deb [arch=amd64] http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh precise-cdh4 contrib\n" | tee -a /etc/apt/sources.list.d/cloudera.list
    echo "deb-src http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh precise-cdh4 contrib" | tee -a /etc/apt/sources.list.d/cloudera.list
    sudo apt-get update
    curl -s http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh/archive.key | sudo apt-key add -
   
    apt-get -q -y --force-yes install hbase-master
  EOH
  action :run
  not_if {File.exists?("/etc/apt/sources.list.d/cloudera.list")}
end


=begin
package "hbase-master" do
  action :install
end
=end

service "hbase-master" do
  supports :restart => true, :start => true, :stop => true
  action [ :enable,:start]
end


template "/etc/hbase/conf/hbase-site.xml" do
  path "/etc/hbase/conf/hbase-site.xml"
  source "hbase-site.xml.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :restart, resources(:service => "hbase-master")
end