# -*- mode: ruby -*-
# vi: set ft=ruby :

unless Vagrant.has_plugin?('vagrant-vbguest')
  raise 'Please install the vagrant-vbguest plugin by running `vagrant plugin install vagrant-vbguest`'
end

VAGRANTFILE_API_VERSION = 2
RUBY_VER = '2.2.3'
MEMORY = 2560
CPU_COUNT = 4

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/trusty64'

  config.vm.box_check_update = false
  config.vm.network :forwarded_port, guest: 35729, host: 35729
  config.vm.network :forwarded_port, guest: 4567, host: 4567
  config.vm.network :private_network, ip: '192.168.33.10'
  config.vm.synced_folder '.', '/vagrant', nfs: true

  config.vm.provider :virtualbox do |vb|
    vb.name = 'aliaksandrb.io'
    vb.memory = MEMORY
    vb.cpus = CPU_COUNT
    vb.customize ['modifyvm', :id, '--cpuexecutioncap', '50']
    # vb.gui = true
  end

  config.vm.provision 'Update the packaqes list', type: 'shell' do |s|
    s.inline = 'sudo apt-get update > /dev/null 2>&1'
  end

  config.vm.provision 'Install git, make, libssl, g++..', type: 'shell' do |s|
    s.inline = 'sudo apt-get install -y build-essential git make libssl-dev g++ nodejs libgmp3-dev > /dev/null 2>&1'
  end

  config.vm.provision "Install RVM and Ruby #{RUBY_VER} and Bundler",
    type: 'shell', privileged: false, inline: <<-SHELL
      gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 > /dev/null 2>&1
      curl -sSL https://get.rvm.io | bash -s stable > /dev/null 2>&1
      source $HOME/.rvm/scripts/rvm

      rvm use --default --install #{RUBY_VER} > /dev/null 2>&1
      rvm cleanup all
  SHELL

  config.vm.provision 'Install project dependencies', type: 'shell', privileged: false, inline: <<-SHELL
    rvm requirements
    echo "gem: --no-document" > ~/.gemrc

    cd /vagrant

    gem install bundler
    bundle install
  SHELL

  config.vm.provision 'PROVISIONING COMPLETE!', run: 'always', type: 'shell',
    privileged: false, inline: <<-SHELL
      echo -e '\nTo run the server:\n'
      echo -e 'vagrant ssh\n'
      echo -e 'cd /vagrant\n'
      echo -e 'middleman server\n'
      echo -e 'Default address on host is: http://192.168.33.10:4567/\n'
  SHELL

  config.vbguest.auto_reboot = true
  config.vbguest.auto_update = true
end

