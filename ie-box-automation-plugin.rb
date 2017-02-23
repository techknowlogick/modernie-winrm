# -*- mode: ruby -*-
# vi: set ft=ruby :

##
# If you copy this file, dont't delete this comment.
# This Vagrantfile was created by Daniel Menezes:
#   https://github.com/danielmenezesbr/modernie-winrm
#   E-mail: danielmenezes at gmail dot com
##

require 'rubygems'
require 'net/ssh'

# TODO
# ====
#   Uses config.ssh in Net::SSH.start
#   test in win8/10
#   add activate (view desktop information)
#   use logger for debug


# Function to check whether VM was already provisioned
def provisioned?(vm_name='default', provider='virtualbox')
  File.exist?(".vagrant/machines/#{vm_name}/#{provider}/action_provision")
end

module LocalCommand

    class Config < Vagrant.plugin("2", :config)
        #attr_accessor :command
    end

    class MyPlugin < Vagrant.plugin("2")
        name "ie_box_automation"

        config(:ie_box_automation, :provisioner) do
            Config
        end

        provisioner(:ie_box_automation) do
            Provisioner
        end
    end

    class Provisioner < Vagrant.plugin("2", :provisioner)
        def provision
            #result = system "#{config.command}"
            begin
                ssh = Net::SSH.start("localhost", "IEUser", :password => "Passw0rd!", :port => 2222)

                puts "Disabling firewall..."
                res = ssh.exec!("NetSh Advfirewall set allprofiles state off")
                #for debug
                #puts res

                puts "Changing network location..."
                res = ssh.exec!("./tools/NLMtool_staticlib.exe -setcategory private")
                #for debug
                #puts res

                puts "Creating link to config WinRM on Startup..."
                res = ssh.exec!("mv ./tools/ConfigWinRM.lnk \"/cygdrive/c/Users/IEUser/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup\"")
                #for debug
                #puts res

                puts 'Shutting down guest machine... next command should be vagrant up'
                ssh.exec!("shutdown -t 0 -s -f")

=begin
                puts "Restarting machine..."
                res = ssh.exec!("shutdown -t 0 -r -f")

                puts 'After shutdown...'
                $done = false;
                while !$done do
                    begin
                        printf '.'
                        res = ssh.exec!("pwd")
                        #for debug
                        #puts res
                        sleep(1)
                    rescue Exception => e
                        $done = true
                        puts '.'
                    end
                end

                puts 'Wait for openssh...'
                $done = false;
                while !$done do
                    begin
                        printf '.'
                        ssh = Net::SSH.start("localhost", "IEUser", :password => "Passw0rd!", :port => 2222)
                        #puts res
                        $done = true
                    rescue
                        sleep(1)
                    end
                end
                puts '.'
=end
=begin
                puts "Removing shortcut (ConfigWinRM.lnk)..."
                $done = false;
                while !$done do
                    printf '.'
                    cmd = %q{if [ -f '/cygdrive/c/Users/IEUser/winrm_ok' ];
then
   echo "true"
else
   echo "false"
fi}
                    res = ssh.exec!(cmd)
                    if res.include? "true"
                        $done = true
                    else
                        sleep(1)
                    end
                end
                puts "Removing link..."
                ssh.exec!("rm -rf \"/cygdrive/c/Users/IEUser/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/ConfigWinRM.lnk\"")
=end
                ssh.close
            rescue Exception => e
                puts "uncaught #{e} exception while handling connection: #{e.message}"
            end
        end
    end
end
