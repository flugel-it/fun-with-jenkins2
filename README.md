Yet Another Jenkins Dockerfile
=============================
Running image on dockerfile
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

Running image with Ansible from docker-hub
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
