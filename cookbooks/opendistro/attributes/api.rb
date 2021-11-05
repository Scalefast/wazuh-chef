# frozen_string_literal: true

# Cookbook:: opendistro
# Attributes:: api
# Author:: Wazuh <info@wazuh.com>

default['kibana']['wazuh_api_credentials'] = [
  {
    'id' => 'default',
    'url' => 'https://localhost',
    'port' => 55000,
    'username' => 'wazuh',
    'password' => 'wazuh',
  },
]
