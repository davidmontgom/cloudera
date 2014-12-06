#package "flume-ng" do
#  action :install
#end


execute "update_repo" do
  command "sudo apt-get -y install flume-ng"
  action :run
  not_if {File.exists?("#{Chef::Config[:file_cache_path]}/flume")}
end
file "#{Chef::Config[:file_cache_path]}/flume" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end