
Note: 

_This is a modified version of the VDD project that can be found at._ https://drupal.org/node/2008758.

It extends the recipes,vagrantfile, and config.json

See config.json description below for information.


Vagrant Drupal Development
--------------------------

Vagrant Drupal Development (VDD) is fully configured and ready to use
development environment built with VirtualBox, Vagrant, Linux and Chef Solo
provisioner.

The main goal of the project is to provide easy to use, fully functional, highly
customizable and extendable Linux based environment for Drupal development.

Full VDD documentation can be found on drupal.org:
https://drupal.org/node/2008758

For support, join us on IRC in the #drupal-vdd channel.


Getting Started
---------------

VDD uses Chef Solo provisioner. It means that your environment is built from
the source code.

  1. Install VirtualBox
     https://www.virtualbox.org/wiki/Downloads

  2. Install Vagrant
     http://docs.vagrantup.com/v2/installation/index.html

  3. Prepare VDD source code
     Download and unpack VDD source code and place it inside your home
     directory.

  4. Adjust configuration (optional)
     You can edit config.json file to adjust your settings. If you use VDD first
     time it's recommended to leave config.json as is. Sample config.json is
     just fine. By default Drupal 8 and Drupal 7 sites are configured.

  6. Build your environment
     Please double check your config.json file after editing. VDD can't start
     with invalid configuration. We recommend to use JSON validator.
     This one is great: http://jsonlint.com/

     To build your environment execute next command inside your VDD copy:
     $ vagrant up

     Vagrant will start to build your environment. You'll see green status
     messages while Chef is configuring the system.

  7. Visit 192.168.44.44 address
     If you didn't change default IP address in config.json file you'll see
     VDD's main page. Main page has links to configured sites, development tools
     and list of frequently asked questions.

  8.For SSH Agent Forwarding to work from within Vagrant (i.e., use your SSH keys from within your 'host' account from within Vagrant)
    , you must add something along these lines to your .bashrc (or equiv) file - see https://coderwall.com/p/p3bj2a : 
    `key_file=~/.ssh/id_rsa && [[ -z $(ssh-add -L | grep $key_file) ]] && ssh-add $key_file`

Now you have ready to use virtual development server. By default 2 sites
are configured: Drupal 7 and Drupal 8. You can add new ones in config.json file
anytime.


Basic Usage
-----------

Inside your VDD copy's directory you can find 'data' directory. This directory
is visible (synchronized) to your virtual machine, so you can edit your project
locally with your favorite editor. VDD will never delete data from data directory,
but you should backup it.

Vagrant's basic commands (should be executed inside VDD directory):

  * $ vagrant ssh
    SSH into virtual machine.

  * $ vagrant up
    Start virtual machine.

  * $ vagrant halt
    Halt virtual machine.

  * $ vagrant destroy
    Destroy your virtual machine. Source code and content of data directory will
    remain unchangeable. VirtualBox machine instance will be destroyed only. You
    can build your machine again with 'vagrant up' command. The command is
    useful if you want to save disk space.

  * $ vagrant provision
    Configure virtual machine after source code change.

  * $ vagrant reload
    Reload virtual machine. Useful when you need to change network or
    synced folders settings.

Official Vagrant site has beautiful documentation.
http://docs.vagrantup.com/v2/


Extending VDD
-------------

VDD can be easily customized and extended. You may implement your custom
cookbook and place it inside chef/cookbooks/custom directory or you may use
berkshelf to download cookbook from remote repository.

Cookbook inside chef/cookbooks/custom directory
-----------------------------------------------

  1. Take a look at vdd_example cookbook inside chef/cookbooks/custom directory.
  2. Create your own cookbook and place it inside chef/cookbooks/custom directory.
  3. Include your recipies in run_list in vdd.json role file inside chef/roles directory.

Remote cookbook using berkshelf
-------------------------------

  Berkshelf is great cookbook manager for Chef. It can automatically download
  cookbooks and their dependencies. Please, learn more at http://berkshelf.com/.

  1. Install berkshelf on your host machine.
  2. Include link to remote cookbooks' repository in Berksfile.
  3. Delete Berksfile.lock file and chef/cookbooks/berks directory.
  4. Run next command inside VDD directory. It will download all dependencies.
    $ berks vendor chef/cookbooks/berks


config.json description
=======================

`config.json` is the main configuration file. Data from `config.json` is used to
configure virtual machine. After editing file make sure that your JSON syntax is
valid. http://jsonlint.com/ can help to check it.



  * `ip (string, required)`
    _Static IP address of virtual machine. It is up to the users to make sure
    that the static IP doesn't collide with any other machines on the same
    network. While you can choose any IP you'd like, you should use an IP from
    the reserved private address space._

  * `memory (string, required)`
    _RAM available to virtual machine. Minimum value is 1024._

  * `synced_folder (object of strings, required)`
    _Synced folder configuration._

      * `host_path (string, required)`
        _A path to a directory on the host machine. If the path is relative, it
        is relative to VDD root._

      * `guest_path (string, required)`
        _Must be an absolute path of where to share the folder within the guest
        machine._

      * `type (string, Optional)`
        _For example default, rsync, nfs. _
        Note: At the current stage, the only wway to get nfs to work is to set it for default at the initial 
        creation of the vm and then modify config.json to set the type to nfs and run Vagrant reload. 

  * @TODO `php (object of strings, required)`
    _PHP configuration._
     
      * `version (string or false, required)`
        _Desired PHP version. Please, see http://www.php.net/releases for proper
        version numbers. If you would like to use standard Ubuntu package you
        should set number to "false". Example: "version": false._

  * @TODO `mysql (object of strings, required)_`
    _MySQL configuration._

      * `server_root_password (string, required)`
        _MySQL server root password._

  * `sites (object ob objects, required)`
    _List of sites (similar to virtual hosts) to configure. At least one site is
    required._
      
      * `Key (string, required)`
        _Machine name of a site. Name should fit expression '[^a-z0-9_]+'. Will
        be used for creating subdirectory for site, Drush alias name, database
        name, etc._  
             * `site_name (string, required)` _drupal site name._

             * `site_mail (string, required)` _Drupal site email._

             * `repo_url (string, required)` _The site repo URL used to clone._

             * `sub_sites (string, optional)` _ For multisite support this defines the sites within a drupal install._

                * `Key (string, required)`        
                  _Machine name of a site. Name should fit expression '[^a-z0-9_]+'. Will
                  be used for creating subdirectory for site, Drush alias name, database
                  name, etc._  
                    * `site_dir (string, required)`        
                      _Name of the site directory within the sites directory._ 
                    * `site_vhost_prefix (string, required)`        
                      _Used in sites.pho for example`site_vhost_prefix.jjbos.vdev`. See vhost entry._                     
                    * `database_name (string, required)`        
                      _The database for the subsite._  
                      
                
     


If you find a problem, incorrect comment, obsolete or improper code or such,
please let us know by creating a new issue at
http://drupal.org/project/issues/vdd
