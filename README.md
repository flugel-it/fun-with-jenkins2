## Jenkins playground

### How to use it:

```
sudo docker build -t jenkins .
sudo docker run -p 8080:8080 jenkins
```
Latest version is pulled by default.


### How to install Docker in Ubuntu 16.04.

First you need to add the GPG Key for the Docker repository:

```
$ sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
Make sure you have ' curl ' installed.

Second you need to add Docker repository to APT file:

```
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

Third you need to update your local repository:

```
$ sudo apt update
```

Finally run the command to install docker:

```
$ sudo apt install docker.io -y
```

You can verify if docker is installed by running the following command:

```
$ sudo dpkg -l | grep docker
```

You should see some entries showing the " i " for installed.

**To ensure docker is running, issue:**

```
$ sudo /etc/init.d/docker status
```

To restart or reload the service:

```
$ sudo /etc/init.d/docker restart
$ sudo /etc/init.d/docker reload
```

### Running  Jenkins in a docker container.

1) Let´s pull Jenkins from docker repository:

```
$ sudo docker pull jenkins
```

2) After you have the image, let´s run our first docker container:

```
$ sudo docker run -p 8080:8080 --name=jenkins-master jenkins
```

You are telling docker to run Jenkins image on port 8080 and setting up the container name.

You may now have your Jenkins up and running, follow the instructions to finish Jenkins installation on the Web Interface.

Open your browser and type : http://yourmachineip:8080 , and you may have Jenkins web interface.


**Additional Docker useful commands:**

To list:
```
$ sudo docker container ls -all
or just:
$ sudo docker ps -a
```
To remove:
```
$ sudo docker container rm "container_id"

```




### References

https://github.com/linagora/james-jenkins/blob/master/create-dsl-job.groovy

https://www.digitalocean.com/community/tutorials/como-instalar-e-usar-o-docker-no-ubuntu-16-04-pt


### Provisioning a VPS with Ansible.

We aim to provision a AWS VPS running Jenkins in a Docker container with Ansible.

Pre-requisites:

- Create an AWS account;
- Set up a Control Machine.

To set up a " Control Machine ", make sure to have the required software installed:

- Ansible
- Python (2.7.x)
- Python Pip
- Boto (Python Module)
- Boto3 (Python Module)
- AWS CLI

To proceed with the installation:

```
$ sudo apt-add-repository ppa:ansible/ansible
$ sudo apt update
$ sudo apt install ansible


$ sudo apt install python
$ sudo apt install python-pip

$ sudo pip install --upgrade pip
$ sudo pip install boto
$ sudo pip install boto3
$ sudo pip install awscli
```

Still in your Control Machine, create an SSH Key in order to manage the created servers:

```
$ sudo ssh-keygen
```

Now, in your AWS Web Console:

- Import the SSH public key (id_rsa.pub) to KEY PAIR Console.
- In IAM Console create an IAM user and give permissions to create and control AWS resources. (Reference: https://www.youtube.com/watch?v=Ul6FW4UANGc)

The IAM Console will provide you the following credentials:

- aws_access_key_id

- aws_secret_access_key

These are the credentials you will need in order to manage AWS by Command Line Interface.

With credentials in hand, let's configure:

```
$ sudo aws configure
```

Insert what is asked for (Access Key ID and Secret Access Key). In order to test it , run:

```
$ sudo aws ec2 describe-images
```

You should get a list of available VPS images, if you receive a permission error, get back to AWS IAM Web Console and fix user permissions.


Now you may create and insert the AWS Credentials in the following file:

```
$ sudo touch ~/.boto

```
Then add the AWS API credentials:

```
[Credentials]

aws_access_key_id = your_key_id
aws_secret_access_key = your_secret_access_key
```

Certain settings in Ansible are adjustable via a configuration file /etc/ansible/ansible.cfg
In this github repo we already have a folder named ' ansible ' containing configuration files and playbooks.
If you installed Ansible from a package manager (e.g. apt, dpkg, yum, rpm), the latest default ansible.cfg file should be already present in /etc/ansible directory. You can backup that file, before copying over ours:

```
$ sudo mv /etc/ansible/ansible.cfg /etc/ansible/ansible.cfg.orig
$ sudo cp ~/fun-with-jenkins2/ansible/ansible.cfg /etc/ansible/
```

Note, if Ansible was installed from pip or from sources, then /etc/ansible/ directory will not be present, so you will need to create it as root or using sudo. To simplify your test deployment, you could just copy our ansible files to /etc/ansible/ in your Control Machine, to be able to run ansible-playbook directly from that directory:

```
$ sudo cp -a ~/fun-with-jenkins2/ansible /etc/ansible
```

But in this case, you will have to add more file permissions to the directory:
```
sudo chmod 777 /etc/ansible
```
The more secure way is instead to only copy ansible.cfg at the previous step (described above) and keep all the rest Ansible files in your user home directory.

You may change ansible.cfg contents if needed according to your setup:

```
host_key_checking = False
remote_user = ubuntu
private_key_file = ~/.ssh/id_rsa
log_path = ~/.ansible/ansible.log
```

Note: if the Ansible inventory file (hosts) is copied to /etc/ansible, it becomes the default. Another approach is
 use "-i" option explicitely when running 'ansible-playbook' command to specify any other inventory file path.

The ansible playbook ' ec2.yml ' is the main playbook, in the end it calls ' jenkins.yml ' playbook. You may change configuration according to your will regarding the AWS VPS region, Ubuntu AMI id, instance type, security group name, ssh keypair name, the ports you want to be opened in AWS firewall and so on. The file is much self-explanatory.

The following AWS AMI id is called in ec2.yml:
AMI ID: ami-43a15f3e
AMI Name:  ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180306
Source: 099720109477/ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180306
Description:
Canonical, Ubuntu, 16.04 LTS, amd64 xenial image build on 2018-03-06
Ubuntu Server 16.04 LTS (HVM),EBS General Purpose (SSD) Volume Type.
Support available from Canonical (http://www.ubuntu.com/cloud/services).
Free tier eligible

jenkins.yml file contains some configurations you might also want to change if needed: ' remote_user ' and 'hosts'.

After setting everything accordingly you may run the playbook by issuing in your ansible directory:

```
# sudo ansible-playbook ec2.yml -vvvv
```

In this case, it will parse /etc/ansible/hosts inventory file.
Use 'ansible-inventory --graph' to explore hosts.
Log is written to ~/.ansible/ansible.log
Use the ' -vvvv ' for verbose.

When the playbook is over it shows you a RECAP, then you can just check if Jenkins is running by collecting the public ip address of your AWS VPS, or dns, going to your browser and issuing the following command : http://x.x.x.x:8080.

Jenkins was set to run in port 8080. If you are presented with a Jenkins set up web interface, everything is working as supposed to.


### Using with Vagrant and Virtualbox:


Pre-requisites:

- Pre Installed VirtualBox;

More info https://www.vagrantup.com/docs/virtualbox/

```

$ sudo apt install vagrant -y
$ sudo apt install ansible -y


```
Vagrant comes with support out of the box for VirtualBox.   After installation finished, you just need to run:
```
$ vagrant up
```

Provisioning script will be executed and jenkins via docker will be deployed.


Jenkins was set to run in port 8080. According to this. You are presented with a Jenkins interface and you will be able to log in using admin:admin. If this is true everything is working as supposed to.

Open your browser and type : http://yourmachineip:8080, and you may have Jenkins web interface.
