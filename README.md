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

Insert what is asked for. In order to test it , run:

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













### References:

```
https://www.youtube.com/watch?v=Ul6FW4UANGc
```

