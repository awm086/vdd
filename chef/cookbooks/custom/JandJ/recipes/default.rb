git "/var/www/JandJ" do
  repository "git@github.com:awm086/JandJ.git"
  revision "master"
  action :sync
  user 'vagrant'
  group 'vagrant'
end
