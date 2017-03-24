Yet Another Jenkins Dockerfile
==============================
	
   This is docker image with automated Jenkins job creation  
   The job created is a Hello World example  

   In order to build and run this image you have to type:  

```bash
$ sudo docker build -f Dockerfile -t flugel-fun
$ sudo docker run -it flugel-fun
```

   Once Entered Docker interactive session type:  

```bash
$ ./start.sh
```
	
   It will run startup shell script, which autodestroys when finished  

