Yet Another Jenkins Dockerfile
==============================
	
   This is docker image with automated Jenkins job creation  
   The job created is a Hello World example  

   In order to build and run this image you have to type:  

```bash
$ sudo docker build -f Dockerfile -t flugel-fun
$ sudo docker run -d -p 8080:8080 flugel-fun
```

   Now open [Jenkins](https://localhost:8080) in your browser  
	 You can log in with admin:admin (login:password)
