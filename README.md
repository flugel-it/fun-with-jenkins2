## Jenkins playground

### How to use it:

```
docker build -t jenkins:latest .
docker run -p 8080:8080  jenkins:latest 
```

### How to install Docker in Ubuntu 16.04.

First you need to add the GPG Key for the Docker repository:

```
$ sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

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
$ sudo apt install docker-ce -y
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

You are telling docker to run Jenkins image on port 8079 and setting up the container name. 

You may now have your Jenkins up and running, follow the instructions to finish Jenkins installation on the Web Interface.

Open your browser and type : http://yourmachineip:8080 , and you may have Jenkins web interface. 


**Additional Docker useful commands:**

```
$ sudo docker container ls -all

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
- Python
- Python Pip
- Boto (Python Module)
- AWS CLI

To proceed with the installation:

```
$ sudo apt-add-repository ppa:ansible/ansible
$ sudo apt update
$ sudo apt install ansible


$ sudo apt install python
$ sudo apt install python-pip

$ sudo pip install upgrade pip
$ sudo pip install boto
$ sudo pip install awscli
```

Still in your Control Machine, create an SSH Key in order to manage the created servers:

```
$ sudo ssh-keygen
```

Now, in your AWS Web Console:

- Import the SSH public key (id_rsa.pub) to KEY PAIR Console.
- In IAM Conrole create an IAM user and give permissions to create and control AWS resources. (Reference: https://www.youtube.com/watch?v=Ul6FW4UANGc) 

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

With all that set, now we may move on to Ansible files.

By default Ansible files are stored in: /etc/ansible.

In this repo we  have a folder named ' ansible ' you may copy all the files and replace them in your Control Machine in /etc/ansible.

You may change in ' ansible.cfg ' according to your set up:

```
host_key_checking = False
remote_user = ubuntu
private_key_file = ~/.ssh/id_rsa
```

The ansible playbook ' ec2.yml ' is the main playbook, in the end it calls ' jenkins.yml ' playbook. You may change configuration according to your will regarding the AWS VPS region, instance type, security group name, ssh keypair name, the ports you want to be opened in AWS firewall and so on. The file is much self-explanatory.

Jenkins file may contain some configurations you might also want to change like:  ' remote_user ' and 'hosts'. 

After changing everything accordingly you may run the playbook by issuing :

```
# sudo ansible-playbook ec2.yml -vvvv
```

Use the ' -vvvv ' for verbose.

When the playbook is over it shows you a RECAP, then you can just check if Jenkins is running by collecting the public ip address of your AWS VPS, or dns, going to your browser and issuing the following command : http://x.x.x.x:8080.

Jenkins was set to run in port 8080. If you are presented with a Jenkins set up web interface, everything is working as supposed to. 


