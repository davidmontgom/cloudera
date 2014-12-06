data_bag("my_data_bag")
db = data_bag_item("my_data_bag", "my")

datacenter = node.name.split('-')[0]
server_type = node.name.split('-')[1]
location = node.name.split('-')[2]

#master_host = db[node.chef_environment][location]['hdfs']['master']
master_host = 'master.hdfs.cloudera.aws.development.west.augnodev.com'
if node.name.include? "master" and node.name.include? "hdfs"
  

script "change_hostname" do
  interpreter "python"
  user "root"
  cwd "/root"
code <<-PYCODE
import json
import os

hostname = """#{master_host}"""
host = hostname.split('.')[:-2]
host = '.'.join(host)
cmd = """sed -i '/^127\.0\.1\.1/s/^/#/' /etc/hosts"""
os.system(cmd)
cmd = """cp /etc/hosts /etc/hosts.original"""
os.system(cmd)
nm = """\n#{node[:ipaddress]} %s %s\n""" % (hostname,host)
cmd = """echo '%s' | tee -a /etc/hosts""" % (nm)
os.system(cmd)
cmd = "> /etc/hostname"
os.system(cmd)
cmd = """echo '%s' | tee -a /etc/hostname""" % host
os.system(cmd)
cmd = "/etc/init.d/hostname restart"
os.system(cmd)
cmd = "touch #{Chef::Config[:file_cache_path]}/hostname.lock"
os.system(cmd)
PYCODE
not_if {File.exists?("#{Chef::Config[:file_cache_path]}/hostname.lock")}
end

end









if node.name.include? "master" and node.name.include? "hdfs"
  

script "change_hostname" do
  interpreter "python"
  user "root"
  cwd "/root"
code <<-PYCODE
import json
import os

hostname = """#{master_host}"""
host = hostname.split('.')[:-2]
host = '.'.join(host)
cmd = """sed -i '/^127\.0\.1\.1/s/^/#/' /etc/hosts"""
os.system(cmd)
nm = """\n127.0.1.1 %s %s\n""" % (hostname,host)
cmd = """echo '%s' | tee -a /etc/hosts""" % (nm)
os.system(cmd)
cmd = """cp /etc/hosts /etc/hosts.original"""
os.system(cmd)
cmd = "> /etc/hostname"
os.system(cmd)
cmd = """echo '%s' | tee -a /etc/hostname""" % host
os.system(cmd)
cmd = "/etc/init.d/hostname restart"
os.system(cmd)
cmd = "touch #{Chef::Config[:file_cache_path]}/hostname.lock"
os.system(cmd)
PYCODE
not_if {File.exists?("#{Chef::Config[:file_cache_path]}/hostname.lock")}
end

end





































