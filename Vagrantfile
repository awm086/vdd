Vagrant.configure("2") do |config|

  # Load config JSON.
  config_json = JSON.parse(File.read("config.json"))

  # Prepare base box.
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  # Configure networking.
  config.vm.network :private_network, ip: config_json["vm"]["ip"]

    # Managing your /etc/hosts file for you via the vagrant-hostsupdater plugin.
  if Vagrant.has_plugin?('vagrant-hostsupdater')
    hostname_aliases = []
    config_json["vdd"]["sites"].each do |index, site|
      site['sub_sites'].each do |index, sub_site|
        hostname_aliases.push sub_site['site_vhost_prefix'] + '.' + site['vhost']['domain']
      end
    end
 
  end
   config.vm.hostname = "jjbos.vdev"
   config.hostsupdater.aliases = hostname_aliases

  # Permit the use of the host machine user's .ssh keys in ssh connections within the vm.
  # Note: These keys must be explicitly added to ssh-agent on the host machine.
  # See https://coderwall.com/p/p3bj2a
  config.ssh.forward_agent = true
  
  # Create a '/etc/sudoers.d/root_ssh_agent' file which ensures sudo keeps any SSH_AUTH_SOCK settings
  # This allows sudo commands (like "sudo ssh git@github.com") to have access to local SSH keys (via SSH Forwarding)
  # See: https://github.com/mitchellh/vagrant/issues/1303
  config.vm.provision :shell do |shell|
    shell.inline = "touch $1 && chmod 0440 $1 && echo $2 > $1"
    shell.args = %q{/etc/sudoers.d/root_ssh_agent "Defaults    env_keep += \"SSH_AUTH_SOCK\""}
  end

  # Turn off StrictHostKeyChecking for vagrant user
  # @TODO make this nicer with variables rather than inline commands
  config.vm.provision :shell do |shell|
     file = "/root/.ssh/config"
     shell.inline = "mkdir -p /root/.ssh/ && touch #{file} " +
                    " && grep -q 'StrictHostKeyChecking' #{file} || echo 'StrictHostKeyChecking no' >> #{file}"
  end

  # Configure forwarded ports.
  config.vm.network "forwarded_port", guest: 35729, host: 35729, protocol: "tcp", auto_correct: true
  config.vm.network "forwarded_port", guest: 8983, host: 8983, protocol: "tcp", auto_correct: true
  # User defined forwarded ports.
  config_json["vm"]["forwarded_ports"].each do |port|
    config.vm.network "forwarded_port", guest: port["guest_port"],
      host: port["host_port"], protocol: port["protocol"], auto_correct: true
  end
  # Customize provider.
  config.vm.provider :virtualbox do |vb|
    # RAM.
    vb.customize ["modifyvm", :id, "--memory", config_json["vm"]["memory"]]

    # Synced Folders.
    config_json["vm"]["synced_folders"].each do |folder|
      case folder["type"]
      when "nfs"
        config.vm.synced_folder folder["host_path"], folder["guest_path"], type: "nfs"
        # This uses uid and gid of the user that started vagrant.
        config.nfs.map_uid = Process.uid
        config.nfs.map_gid = Process.gid
      when "rsync"
        config.vm.synced_folder folder["host_path"], folder["guest_path"], type: "rsync"  
      else
        config.vm.synced_folder folder["host_path"], folder["guest_path"]
      end
    end
  end

  # Run initial shell script.
  config.vm.provision :shell, :path => "chef/shell/initial.sh"

  # Customize provisioner.
  
  config_json["map"]["uid"] = Process.uid
  config_json["map"]["gid"] = Process.gid

  config.vm.provision :chef_solo do |chef|
    chef.json = config_json
    chef.custom_config_path = "chef/solo.rb"
    chef.cookbooks_path = ["chef/cookbooks/berks", "chef/cookbooks/core", "chef/cookbooks/custom"]
    chef.data_bags_path = "chef/data_bags"
    chef.roles_path = "chef/roles"
    chef.add_role "vdd"
  end


 
  # Run final shell script.
  config.vm.provision :shell, :path => "chef/shell/final.sh", :args => config_json["vm"]["ip"]

end
