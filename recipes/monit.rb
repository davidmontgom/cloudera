

if node.name.include? "master" and node.name.include? "hdfs"
  
  service "monit"
  template "/etc/monit/conf.d/master-hdfs-hbase.conf" do
    path "/etc/monit/conf.d/master-hdfs-hbase.conf"
    source "monit.master.conf.erb"
    owner "root"
    group "root"
    mode "0755"
    notifies :restart, resources(:service => "monit")
  end
  
  
end


if node.name.include? "slave" and node.name.include? "hdfs"
  
  service "monit"
  template "/etc/monit/conf.d/slave-hdfs-hbase.conf" do
    path "/etc/monit/conf.d/slave-hdfs-hbase.conf"
    source "monit.slave.conf.erb"
    owner "root"
    group "root"
    mode "0755"
    notifies :restart, resources(:service => "monit")
  end
  
end