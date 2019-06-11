#
# Cookbook Name:: wazuh-elastic
# Recipe:: kibana_install

# Create user and group
#

if platform_family?('ubuntu', 'debian')
  apt_package 'kibana' do
    version "#{node['wazuh-elastic']['elastic_stack_version']}"
  end
elsif platform_family?('rhel','centos', 'amazon')
  yum_package 'kibana' do
    version "#{node['wazuh-elastic']['elastic_stack_version']}-1"
  end
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end

service "kibana" do
  supports :start => true, :stop => true, :restart => true, :reload => true, :status => true
  action [:enable, :start]
end

template 'kibana.yml' do
  path '/etc/kibana/kibana.yml'
  source 'kibana.yml.erb'
  owner 'root'
  group 'root'
  variables({
     :kibana_port_line =>  "server.port: #{node['wazuh-elastic']['kibana_port']}",
     :kibana_host_line =>  "server.host: #{node['wazuh-elastic']['kibana_host']}",
     :kibana_elasticsearch_server_line => "elasticsearch.hosts: ['#{node['wazuh-elastic']['kibana_elasticsearch_server']}']"
  })
  mode 0755
  notifies :restart, "service[kibana]", :immediately
end

ruby_block 'wait for elasticsearch' do
  block do
    loop { break if (TCPSocket.open("#{node['wazuh-elastic']['elasticsearch_ip']}",node['wazuh-elastic']['elasticsearch_port']) rescue nil); puts "Waiting elasticsearch...."; sleep 1 }
  end
end

bash 'Waiting for elasticsearch curl response...' do
  code <<-EOH
  until (curl -XGET http://#{node['wazuh-elastic']['elasticsearch_ip']}:#{node['wazuh-elastic']['elasticsearch_port']}); do
    printf 'Waiting for elasticsearch....'
    sleep 5
  done
  EOH
end

bash 'Install Wazuh-APP (can take a while)' do
  code <<-EOH
  sudo -u kibana /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/wazuhapp/wazuhapp-#{node['wazuh-elastic']['wazuh_app_version']}.zip kibana
  EOH
  creates '/usr/share/kibana/plugins/wazuh/package.json'
  notifies :restart, "service[kibana]", :immediately
end

