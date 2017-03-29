Yet Another Jenkins Dockerfile
=============================
Running image from Dockerfile
---------------------------

     This is docker image with automated Jenkins job creation  
     The job created is a Hello World example
   
     In order to build and run this image you have to type:

```bash
$ sudo docker build -f Dockerfile -t orest/flugel .
$ sudo docker run -d -p 8080:8080 orest/flugel
```

   Now open [Jenkins](https://localhost:8080) in your browser  
   You can log in with admin:admin (login:password)

Running image from docker-hub with Ansible
------------------------------------------

      Tested on Ubuntu, Arch Linux and Fedora,   
    possibly can work with Debian

      In order to run docker and this image on your hosts  
    you have to type:

```bash
$ ansible-playbook -s main.yml
```

    If you are connected to root to every host, you can use:

```bash
$ ansible-playbook -s -u root main.yml
```
    You can modify main.yml to add more roles.  
    Default main.yml:
```yaml
---
- name: Setup docker
  hosts: 
    - all
  roles:
    - docker
```
Running an EC2 instance with this image running with terraform
--------------------------------------------------------------

   To run create new EC2 instance with terraform  
   you need to edit terraform/data.tfvars and terraform/keys.tfvars   
   with your data and AWS keys  
   Then type:
```bash
    $ cd terraform
    $ terraform plan -var-file="data.tfvars" -var-file="keys.tfvars"
    $ terraform apply -var-file="data.tfvars" -var-file="keys.tfvars"
```
   Afrer that to get the public IP of your host type:
```bash
    $ terraform show | grep public_ip
```
    The port 8080 on this host will be opened for Jenkins

For safety, envoronment variables of your AWS acces key and secret key can be created:
```bash
   $ export TF_VAR_access_key = XXXXXXXXXXXXX
   $ export TF_VAR_secret_key = YYYYYYYYYYYYYYYYYYYYYYYYYYYY
```
After that you can run the script with:  
```bash
    $ terraform plan -var-file="data.tfvars"
    $ terraform apply -var-file="data.tfvars"
```