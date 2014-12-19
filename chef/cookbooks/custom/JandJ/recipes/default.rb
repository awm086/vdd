git "/var/www/jnj/JandJ" do
  repository "git@github.com:awm086/JandJ.git"
  revision "master"
  checkout_branch 'master'
  action :sync
end