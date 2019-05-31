# Cookbook Name:: wazuh_elastic
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

case node["platform_family"]
when "debian", "ubuntu"
  package "lsb-release"

  ohai "reload lsb" do
    plugin "lsb"
    # action :nothing
    subscribes :reload, "package[lsb-release]", :immediately
  end

  apt_repository "elastic-7.x" do
    uri "https://artifacts.elastic.co/packages/7.x/apt"
    key "https://artifacts.elastic.co/GPG-KEY-elasticsearch"
    distribution "stable"
    components ["main"]
    not_if do
      File.exists?("/etc/apt/sources.list.d/elastic-7.x.list")
    end
  end
when "rhel","centos"
  yum_repository "elastic-7.x" do
    description "Elastic repository for 7.x packages"
    baseurl "https://artifacts.elastic.co/packages/7.x/yum"
    gpgkey "https://artifacts.elastic.co/GPG-KEY-elasticsearch"
    action :create
    not_if "grep -q elasticsearch /etc/yum.repos.d/elastic-7.x.repo"
  end
end