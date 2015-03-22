#http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH5/5.0/CDH5-Installation-Guide/cdh5ig_cdh5_install.html


bash "cloudera" do
user "root"
code <<-EOH
  touch /etc/apt/sources.list.d/cloudera.list
  echo "deb [arch=amd64] http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh precise-cdh5 contrib" | tee -a /etc/apt/sources.list.d/cloudera.list
  echo "deb-src http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh precise-cdh5 contrib" | tee -a /etc/apt/sources.list.d/cloudera.list
  curl -s http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key | sudo apt-key add -
  sudo apt-get update
EOH
action :run
not_if {File.exists?("/etc/apt/sources.list.d/cloudera.list")}
end

cookbook_file "/etc/apt/preferences.d/cloudera.pref" do
  source "cloudera.pref"
  mode 00744
end