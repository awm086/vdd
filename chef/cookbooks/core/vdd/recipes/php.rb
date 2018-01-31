# @todo: make the version variable
include_recipe 'php'

include_recipe "apache2::mod_php"

pkgs = [
  "php7.1-gd",
  "php7.1-mysql",
  "php7.1-mcrypt",
  "php7.1-curl",
  "php7.1-dev",
  "php7.1-xml",
  "php7.1-json",
  "libapache2-mod-php7.1",
  "php7.1-mbstring",
  "php-memcache"
]

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

template "/etc/php/7.1/apache2/conf.d/vdd_php.ini" do
  source "vdd_php.ini.erb"
  mode "0644"
  notifies :restart, "service[apache2]", :delayed
end
