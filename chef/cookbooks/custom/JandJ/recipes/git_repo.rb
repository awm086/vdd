# Recipe to checkout the git repo into a specified directory.
if node["vdd"]["sites"]
  node["vdd"]["sites"].each do |index, site|
    repo_url= site['repo_url']
    name = defined?(site["vhost"]["app_root"]) ? site["vhost"]["app_root"] : index
  	name = "var/www/" + name
    
    git name do
	    repository repo_url 
	    revision "master"
	    action :sync
	  end
    
	end
end

