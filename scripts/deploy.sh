#!/bin/bash

echo DEPLOY

sudo docker pull jenkins

sudo docker run -p 8080:8080 --name=jenkins-master jenkins


