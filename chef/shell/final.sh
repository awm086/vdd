
#!/bin/bash

# Added zsh shell.
# sudo apt-get install zsh
# wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sudo ZSH=/home/vagrant/.oh-my-zsh sh  
# export ZSH=/home/vagrant/.oh-my-zsh
# sudo chsh -s /bin/zsh vagrant
# zsh

# # Change the oh my zsh default theme.
# cp /home/vagrant/.oh-my-zsh/templates/zshrc.zsh-template /home/vagrant/.zshrc
# chown vagrant:vagrant /home/vagrant/.zshrc
# chown -R vagrant:vagrant /home/vagrant/.oh-my-zsh


VDD_IP=$(echo "$1")


echo "============================================================="
echo "Install finished! Visit http://$VDD_IP in your browser." 
echo "============================================================="
