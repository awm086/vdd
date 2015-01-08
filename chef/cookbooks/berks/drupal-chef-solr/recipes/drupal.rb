#
# Cookbook Name:: solr
# Recipe:: drupal
#
# Copyright 2014, David Kinzer
#

ark "apachesolr-#{node['solr']['drupal']['version']}" do
  url node['solr']['drupal']['url']
  version node['solr']['drupal']['version']
  path "/tmp"  
  action :put
end

ruby_block 'configure apachesolr-drupal' do
  block do
    require 'fileutils'
    node['solr']['drupal']['config_files'].each do |file|
      FileUtils.cp(
        "/tmp/#{node['solr']['drupal']['config_files_path']}/#{file}",
        "#{node['solr']['dir']}/#{node['solr']['config']}/#{file}"
      )
    end
  end
  not_if {
    node['solr']['drupal']['config_files'].reduce(true) do |identical, file|
    break unless identical
    identical && File.identical?(
      "/tmp/#{node['solr']['drupal']['config_files_path']}/#{file}",
      "#{node['solr']['dir']}/#{node['solr']['config']}/#{file}"
    )
    end
  }
  notifies :restart, "service[solr]"
end

