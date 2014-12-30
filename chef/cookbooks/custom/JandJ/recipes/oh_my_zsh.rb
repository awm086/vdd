git "/home/vagrant/.oh-my-zsh" do
  repository "https://github.com/robbyrussell/oh-my-zsh.git"
  reference "master"
  action :sync
end

template "/home/vagrant/.zshrc" do
  source "zshrc.erb"
  owner "vagrant"
  mode "644"
  action :create_if_missing
    variables({
      :user => "vagrant",
      :theme => 'robbyrussell',
      :case_sensitive => false,
      :plugins => %w(git)
    })
end

