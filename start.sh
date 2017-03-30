#!/bin/bash

msg () {
	echo -e "\e[1;32m-->\e[39m$*\e[0m"
}

waitFor() {
	for i in $(seq $1 -1 1); do
		msg "Wait     $i        \e[1A"
		sleep 0.25
		msg "Wait.    $i        \e[1A"
		sleep 0.25
		msg "Wait..   $i        \e[1A"
		sleep 0.25
		msg "Wait...  $i        \e[1A"
		sleep 0.25
	done
}

msg "Starting jenkins..."
nohup jenkins.sh &
waitFor 60
msg "Jenkins ready!"
cd /var/jenkins_home
git clone https://github.com/cfpb/jenkins-as-code-starter-project.git
cd jenkins-as-code-starter-project/
cp ../init.groovy.d/helloworld.groovy jobs/
ls jobs/
msg "Creating new Jenkins job..."
./gradlew rest \
	-DbaseUrl=http://localhost:8080 \
	-Dpattern=jobs/helloworld.groovy \
	-Dusername=admin \
	-Dpassword=admin 

