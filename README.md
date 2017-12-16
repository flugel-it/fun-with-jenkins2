# Jenkins playground

## How to use it

```
docker build -t jenkins:latest .
docker run -p 8080:8080  jenkins:latest 
```

## How to install Docker in Ubuntu 16.04

## First you need to add the GPG Key for the Docker repository

```
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

## Second you need to add Docker repository to APT file

```
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

## Third you need to update your local repo

```
$ sudo apt update
``` 

## Finally run the command to install docker

```
$ sudo apt install docker-engine
```

## You can verify if docker is installed by running the following command

```
$ sudo dpkg -l | grep docker
```

## You should see some entries showing the " i " for installed and then docker software

## To ensure docker is running issue:

```
$ sudo /etc/init.d/docker status
```

## To restart or reload the service:

```
$ sudo /etc/init.d/docker restart
$ sudo /etc/init.d/docker reload
```

## Now let´s use run Jenkins in a docker container

## 1) Let´s pull Jenkins from docker repository:

```
$ sudo docker pull jenkins
```

## After you have the image, let´s run our first docker container:

```
$ sudo docker run -p 8080:8080 --name=jenkins-master jenkins
```

## In the command above you are telling docker to run Jenkins image on port 8080 and setting up the name of the container. 

## You may now have your Jenkins up and running, follow the instruction to finish Jenkins installation on the Web Interface:

## Go to your browser and type : http://yourmachineip:8080 , and you may have Jenkins web interface. 



## References

https://github.com/linagora/james-jenkins/blob/master/create-dsl-job.groovy

https://www.digitalocean.com/community/tutorials/como-instalar-e-usar-o-docker-no-ubuntu-16-04-pt


