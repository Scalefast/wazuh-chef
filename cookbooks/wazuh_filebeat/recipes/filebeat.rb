#
# Cookbook Name:: filebeat
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

include_recipe 'wazuh_filebeat::repository'

if platform_family?('ubuntu', 'debian')
  apt_package 'filebeat' do
    version "#{node['filebeat']['elastic_stack_version']}"
  end
elsif platform_family?('rhel','centos', 'amazon')
  yum_package 'filebeat' do
    version "#{node['filebeat']['elastic_stack_version']}-1"
  end
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end

template node['filebeat']['config_path'] do
  source 'filebeat.yml.erb'
  owner 'root'
  group 'root'
  mode '0640'
  variables(:logstash_servers => node['filebeat']['logstash_servers'])
end

begin
  ssl = Chef::EncryptedDataBagItem.load('wazuh_secrets', 'logstash_certificate')
  log "Logstash certificate found, writing... (Note: Disabled by default) " do
    message "-----LOGSTASH CERTIFICATE FOUND-----"
    level :info
  end
rescue ArgumentError, Net::HTTPServerException
  ssl = {'logstash_certificate' => "", 'logstash_certificate_key' => ""}
  log "No logstash certificate found...Installation will continue with empty certificate (Note: Disabled by default)" do
    message "-----LOGSTASH CERTIFICATE NOT FOUND-----"
    level :info
  end
end

file '/etc/filebeat/logstash.crt' do
  mode '0644'
  owner 'root'
  group 'root'
  content ssl['logstash_certificate'].to_s
  action :create
end

service node['filebeat']['service_name'] do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end
