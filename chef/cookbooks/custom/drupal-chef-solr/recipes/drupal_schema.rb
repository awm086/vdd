#
# Cookbook Name:: solr
# Recipe:: drupal
#
# Copyright 2014, David Kinzer
# 
# @file
# 
# Use this as an example of overriding the schema.xml with your own configuration.
#

if node['solr']['drupal']['disable_stemming']
  content_type = "text_und"
else
  content_type = "text"
end

template "drupal-solr-schema-template" do
  source "drupal.schema.xml.erb"
  path "#{node['solr']['dir']}/#{node['solr']['config']}/schema.xml"
  variables :schema => {
    "content_type" => "content_type",
  }
  notifies :restart, "service[solr]"
end
