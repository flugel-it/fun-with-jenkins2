Vagrant.configure('2') do |config|

  # Declaring VM Name 
  config.vm.define "webserver" do |config|


  # Define Digital Ocean Provider Parameters 
        config.vm.provider :digital_ocean do |provider, override|
    	override.ssh.private_key_path = '~/.ssh/id_rsa'
        override.vm.box = 'digital_ocean'
        override.nfs.functional = false
        provider.token = '9bae5c3965187813e1b6ba18122108657bad7488befd1780dcacd66bde3a3ecc'
        provider.image = 'ubuntu-16-04-x64'
        provider.region = 'nyc1'
        provider.size = '512mb'
	provider.ssh_key_name = 'dell-laptop'
      end
 

  # Enable provisioning with Ansible.
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/jenkins.yml"
end


end
end
