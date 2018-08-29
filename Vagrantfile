# -*- mode: ruby -*-
# vi: set ft=ruby :

##
# If you copy this file, dont't delete this comment.
# This Vagrantfile was created by Daniel Menezes:
#   https://github.com/danielmenezesbr/modernie-winrm
#   E-mail: danielmenezes at gmail dot com
##

##
# Version: 0.0.4
##


require_relative 'ie-box-automation-plugin.rb'


Vagrant.configure("2") do |config|

  # WIN7 - IE11
  config.vm.box = "microsoft.ie/ie11.win7"
  config.vm.box_url = "file://IE11 - Win7.box"
  
  # Windows 10 Stable - MS Edge
  #config.vm.box = "microsoft.ie/msedge.win10stable"
  #config.vm.box_url = "file://dev-msedge.box"
  
  config.vm.boot_timeout = 5000

  config.vm.guest = :windows

  config.vm.communicator = :winrm       if provisioned?
  config.winrm.username = "IEUser"      if provisioned?
  config.winrm.password = "Passw0rd!"   if provisioned?
  config.winrm.timeout = 50000          if provisioned?
  config.winrm.retry_delay = 30         if provisioned?
  config.winrm.retry_limit = 1000       if provisioned?
  

  config.ssh.username = "IEUser"
  config.ssh.password = "Passw0rd!"
  config.ssh.insert_key = false
  # config.vbguest.auto_update = false

  config.vm.box_check_update = false

  config.vm.synced_folder ".", "/vagrant", disabled: true                     if not provisioned?
  config.vm.synced_folder "./ExtraFolder", "c:/ExtraFolder", create: false    if provisioned?

  config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     vb.gui = false

     # Customize the amount of memory on the VM:
     vb.memory = "2048"
  end


  config.vm.provision "file", source: "./tools/7z.exe", destination: "c:/users/IEUser/7z.exe"
  config.vm.provision "file", source: "./tools/7z.dll", destination: "c:/users/IEUser/7z.dll"
  config.vm.provision "file", source: "./tools/tools.zip", destination: "c:/users/IEUser/tools.zip"
  config.vm.provision "winrm", type: "ie_box_automation"
end
