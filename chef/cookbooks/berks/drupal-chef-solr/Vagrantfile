# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
DEV_BASE_BOX = ENV['DEV_BASE_BOX'] || 'basic'
DEV_BASE_BOX_URL = ENV['DEV_BASE_BOX_URL'] || 'http://files.vagrantup.com/precise64.box'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.ssh.forward_agent = true
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true

  config.vm.provider "virtualbox" do |vb|
    config.vm.box = DEV_BASE_BOX
    config.vm.box_url = DEV_BASE_BOX_URL
    # See issue github.com/mitchellh/vagrant#391
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.define "solr-drupal", primary: true do |solr_dev|
    solr_dev.vm.network "forwarded_port", guest: 8983, host: 8983

    # Provision:
    solr_dev.vm.provision "chef_solo" do |chef|
      # Update apt-get.
      chef.add_recipe "apt"

      chef.json = {
        "apt" => {"compile" => true},
        'solr' => {
          'version' => '4.6.1',
          'data_dir' => '/opt/solr/example/solr',
          'url' => 'http://archive.apache.org/dist/lucene/solr/4.6.1/solr-4.6.1.tgz',
          'port' => '8983',
          'config' => 'collection1/conf',
        }
      }

      chef.add_recipe "solr"
      chef.add_recipe "solr::drupal"
    end
  end

end
