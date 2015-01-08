default['oh_my_zsh'][:users] = [{
  :login => 'vagrant',
  :theme => 'robbyrussell',
  :plugins => ['git']
}]
default['oh_my_zsh'][:repository] = "git://github.com/robbyrussell/oh-my-zsh.git"