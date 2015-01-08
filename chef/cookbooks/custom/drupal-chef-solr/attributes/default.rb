#
# Cookbook Name:: solr
# Attributes:: default
#
# Copyright 2013, David Radcliffe
#

default['solr']['version']  = '3.5.0'
default['solr']['url']      = "https://archive.apache.org/dist/lucene/solr/#{node['solr']['version']}/apache-solr-#{node['solr']['version']}.tgz"
default['solr']['data_dir'] = '/etc/solr'
default['solr']['dir'] = '/opt/solr'
default['solr']['port'] = '8983'
default['solr']['user'] = 'solr'
default['solr']['config'] = 'example/solr/conf'
