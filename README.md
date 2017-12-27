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

We are going to provision a VPS in AWS with an ansible playbook, we will have Jenkins running in a docker container. 

First you need to authenticate in AWS API by using the following credentials: " access key ID " and " secret access key " you can generate this in your AWS account in : IAM web console , then you copy this credentials to paste locally. 

Second  we need to install in our control machine the ' aws cli tool ' (make sure you have Python installed already) :

``` 
$ sudo pip install awscli
``` 

With both credentials in hand, run:

```
$ sudo aws configure
```

Insert what is asked for (Access Key ID and Secret Access Key). In order to test it , run:

```
$ sudo aws ec2 describe-images
``` 

You should get a list of available VPS images, if you receive a permission error, get back to AWS IAM Web Console and fix user permissions. 


Now we need to install Ansible in the control machine:

```
$ sudo apt-add-repository ppa:ansible/ansible
$ apt update
$ apt install ansible
```

**Extra instruction:**
Generate a ssh key pair and import to AWS EC2 console, in order to provision instances from the command line, already associating a key pair.

```
$ sudo ssh-keygen
```
Now go to AWS EC2 console >> Key Pairs and import it.

Ansible uses python-boto library to call AWS API, make sure to have this installed:

```
$ sudo pip install -U boto
```
Create the following file:

```
$ sudo touch ~/.boto

``` 
Then add the AWS API credentials:

```
[Credentials]

aws_access_key_id = your_key_id
aws_secret_access_key = your_secret_access_key
```

Also be sure you have python-pip installed, otherwise run:
```
$ sudo apt install python-pip
```

After Ansible installation you may notice that you have all config files in /etc/ansible.

In this repo we also have a folder called ' ansible ' in order to have our playbook ready you may replace your folder content with our files.

In ' ansible.cfg ' the following configs were done:

```
host_key_checking = False
remote_user = ubuntu
private_key_file = ~/.ssh/id_rsa
```

The file ' ec2.yml ' is the main playbook that in the end calls ' jenkins.yml ' playbook. In this file you may ajust some settings according to your will regarding the AWS VPS region, instance type, security group name, ssh keypair name, the ports you want to be opened in AWS firewall and so on. The file is much self-explanatory.

In the end of the file you can see ansible calls another playbook : ' jenkins.yml '.

Jenkins file may have some configuration you want to change as ' remote_user ' and 'hosts'. You can check all the actions is taking and what is being updated and installed in your VPS, it is also self-explanatory. This is one of Ansible's advantage, it is self-documenting. 


After getting all parameters changed the way you need, run the playbook by issuing :

```
# sudo ansible-playbook ec2.ym -vvvv
```

Use the ' -vvvv ' for verbose.

When the playbook is over it shows you a RECAP, then you can just check if Jenkins is running by collecting the public ip address of your AWS VPS, or dns, go to your browser and issue: http://x.x.x.x:8080.

Jenkins was set to run in port 8080. If you are presented with a Jenkins set up web interface, everything is working as supposed to. 


### References:

```
https://www.youtube.com/watch?v=Ul6FW4UANGc
```

