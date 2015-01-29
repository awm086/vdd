if node["vdd"]["sites"]
  node["vdd"]["sites"].each do |index, site|  

    if site["sub_sites"]

      template "/usr/local/bin/drush-master/jjlocal.aliases.drushrc.php" do
        source "jjlocal.aliases.drushrc.php.erb"
        owner "root"
        group "root"
        mode "0644"
      end

    end
  
  end
end