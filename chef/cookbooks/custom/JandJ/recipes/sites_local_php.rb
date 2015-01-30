# Determine if the directory is NFS.
nfs = 0
node["vm"]["synced_folders"].each do |folder|
  if folder['guest_path'] == '/var/www'
    if folder['type'] == 'nfs'
      nfs = 1
    end
  end
end

if node["vdd"]["sites"]
  node["vdd"]["sites"].each do |index, site|  
    
    path = defined?(site["vhost"]["document_root"]) ? site["vhost"]["document_root"] : index
    path = "var/www/" + path
    path = path + "/sites" 
    file_name = path + "/sites.local.php"
    template file_name do
      source "sites.local.php.erb"
      if nfs == 0
        owner 'vagrant'
        group 'vagrant'
      end
      action :create
      
    end

     # create site (subsite) directory 
    if site["sub_sites"]
      log "Hello in sites php"
      site["sub_sites"].each do |index, sub_site|  
        
        site_path  = path + "/" + sub_site['site_dir']
        log "index:" + index
        dirs = [
          site_path, site_path +'/files',
          site_path + "/themes", 
          site_path + "/modules", 
          site_path + "/modules/contrib",
          site_path + "/modules/custom",
          site_path + "/scripts",
        ]
        dirs.each do |index|
          log index
          directory index do
            if nfs == 0
              owner 'vagrant'
              group 'vagrant'
            end
            
            action :create
          end
        end
        # Creat a settings.local.php
        settings_name = site_path + "/settings.local.php"
        template settings_name do
          source "settings.local.php.erb"
          action :create
          if nfs == 0
            owner 'vagrant'
            group 'vagrant'
          end
            variables({
              :database_name => sub_site['database_name'] || 'jjbos',
              :database_prefix => sub_site["database_prefix"] || '',
              :site_dir => sub_site["site_dir"]
            })
        end

        # Creat a settings.php
        settings_name = site_path + "/settings.php"
        template settings_name do
          source "settings.php.erb"
          action :create
          if nfs == 0
            owner 'vagrant'
            group 'vagrant'
          end
            variables({
              :database_name => sub_site['database_name'] || 'jjbos',
              :database_prefix => sub_site["database_prefix"] || ''
            })
        end

        # Create a script file in the site dirctory to help prepare and install

        # Creat a settings.php
        script_name = site_path + "/scripts/jjbos_dev_prepare.sh"
        template script_name do
          source "jjbos_dev_prepare.sh.erb"
          action :create
          if nfs == 0
            owner 'vagrant'
            group 'vagrant'
          end
            variables({
              :site_dir => sub_site['site_dir']
            })
        end
        
        # Create databases.
         include_recipe "database::mysql"
         mysql_connection_info = {
           :host => "localhost",
           :username => "root",
           :password => node["mysql"]["server_root_password"]
         }
        
         mysql_database sub_site['database_name'] do
           connection mysql_connection_info
           action :create
         end
      
      end

    end

  end

end



