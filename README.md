# Wazuh - Chef 

[![Slack](https://img.shields.io/badge/slack-join-blue.svg)](https://goo.gl/forms/M2AoZC4b2R9A9Zy12)
[![Email](https://img.shields.io/badge/email-join-blue.svg)](https://groups.google.com/forum/#!forum/wazuh)
[![Documentation](https://img.shields.io/badge/docs-view-green.svg)](https://documentation.wazuh.com)
[![Documentation](https://img.shields.io/badge/web-view-green.svg)](https://wazuh.com)

Deploy Wazuh platform using Chef cookbooks. Chef recipes are prepared for installing and configuring Agent, Manager (cluster) and RESTful API.

## Cookbooks

* [Wazuh Agent ](https://github.com/wazuh/wazuh-chef/tree/master/wazuh_agent)
* [Wazuh Manager and API](https://github.com/wazuh/wazuh-chef/tree/master/wazuh_manager)
* [Elastic Stack (Elasticsearch, Logstash, Kibana)](https://github.com/wazuh/wazuh-chef/tree/master/wazuh_elastic)
* [Filebeat](https://github.com/wazuh/wazuh-chef/tree/master/wazuh_filebeat)

Each cookbook has its own README.md

## Roles

You can find predefined roles for a default installation of Wazuh Agent and Manager in the roles folder.

- [Wazuh Agent Role](https://github.com/wazuh/wazuh-chef/tree/master/roles/wazuh_agent.json)
- [Wazuh Manager Role](https://github.com/wazuh/wazuh-chef/tree/master/roles/wazuh_agent.json)

Check roles README for more information about default attributes and how to customize your installation.

## Installation

#### Cloning whole repository

You can clone repository by running: ```git clone https://github.com/wazuh/wazuh-chef```  and you will get the whole repository.

#### Use through Berkshelf

The easiest way to making use of these cookbooks (especially `wazuh_filebeat` & `wazuh_elastic` until they are published to Supermarket) is by including in your `Berksfile` the desired cookbooks as stated below:

```ruby
cookbook "wazuh_agent", git: "https://github.com/wazuh/wazuh-chef.git",rel: 'cookbooks/wazuh_agent'
cookbook "wazuh_manager", git: "https://github.com/wazuh/wazuh-chef.git",rel: 'cookbooks/wazuh_manager'
cookbook 'wazuh_filebeat', github: 'https://github.com/wazuh/wazuh-chef.git', rel: 'cookbooks/wazuh_filebeat'
cookbook 'wazuh_elastic', github: 'https://github.com/wazuh/wazuh-chef.git', rel: 'cookbooks/wazuh_elastic'
```

You can specify tags, branches and revisions. More info on https://docs.chef.io/berkshelf.html

#### Secrets

In order to properly install and use chef to install Wazuh Elements, the wazuh_secrets data bag must three secrets. The following describes how to define the needed json files to generate an encrypted data bag.

##### api.json

Contains the username and password that will be installed for Wazuh API authentication. Is required by the manager.

Example of json before encryption:

```json
{
  "id": "api",
  "htpasswd_user": "<YOUR USER>",
  "htpasswd_passcode": "<YOUR PASSWORD>"
}

```

##### logstash_certificate.json

Contains the certificate and the certificate key that will secure communication with logstash. Required by  Elastic and Filebeat.

```json
{
  "id": "logstash_certificate",
  "logstash_certificate": "<YOUR LOGSTASH CERTIFICATE>",
  "logstash_certificate_key": "<YOUR LOGSTASH CERTIFICATE KEY>"
}

```

##### nginx_certificate.json

Stores the nginx certificate and key. Required by Elastic.

```json
{
  "id": "nginx_certificate",
  "nginx_crt": "<YOUR NGINGX CERT>",
  "nginx_key": "<YOUR NGINX KEY"
}
```



#### Generate data bags

In order to transfer our credentials securely, chef provides *data bags* that allows to encrypt some sensitive data before communication.

The following process describes an example of how to create secrets and data bags to encrypt data.

* Install a key or generate one (with openssl for example) on your Workstation.

* Create the required secret by using : ```knife data bag create wazuh_secrets api --secret-file <path> -z```  (execute once per file: *api*, *logstash_certificate* and *nginx_certificate*)

* Upload your new secrets with : ```knife upload data_bags/```

* Before installing Wazuh-Manager, Wazuh-Filebeat or Wazuh-Elastic you will need to copy the key in */etc/chef/encrypted_data_bag_secret* (default path) or in the desired path (remember to specify the key path in *knife.rb* and *config.rb*) of every node.

  

After encryption, the previous json files will have new fields that describe encryption method and other useful info. For example *api.json* after encryption will look like this:

```json
{
  "id": "api",
  "htpasswd_user": {
    "encrypted_data": "whdiITsM/JFBwiAcCE5MaVE2MinRLdDIGbJ0\n",
    "iv": "NVK/ezXHBsSFuiMm\n",
    "auth_tag": "NFPZcxGrjqxRSF7v/+i6Kw==\n",
    "version": 3,
    "cipher": "aes-256-gcm"
  },
  "htpasswd_passcode": {
    "encrypted_data": "rX952YaNifO1gtcFXHxjteKCk6Zi592FZGgyE1gs0A==\n",
    "iv": "LThJWRCIB4JaDP4E\n",
    "auth_tag": "2oS9JDBtNdcRhsOdgg/A9A==\n",
    "version": 3,
    "cipher": "aes-256-gcm"
  }
}
```



## Contribute

If you want to contribute to our project please don't hesitate to send a pull request. You can also join our users [mailing list](https://groups.google.com/d/forum/wazuh), by sending an email to [wazuh+subscribe@googlegroups.com](mailto:wazuh+subscribe@googlegroups.com), to ask questions and participate in discussions.

## License and copyright

Wazuh App Copyright (C) 2019 Wazuh Inc. (License GPLv2)


## References

* [Wazuh website](http://wazuh.com)
* [Wazuh mailing list](https://groups.google.com/d/forum/wazuh)
* [Wazuh documentation](http://documentation.wazuh.com)
