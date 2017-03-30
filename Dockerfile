
FROM jenkinsci/jenkins:latest

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

USER root
COPY admin.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY Jenkinsfile /var/jenkins_home/init.groovy.d/helloworld.groovy
COPY start.sh /var/jenkins_home/
RUN \
	/usr/local/bin/install-plugins.sh \
		workflow-aggregator \
		job-dsl \
		git \
		build-flow-plugin 
USER jenkins
WORKDIR /var/jenkins_home/
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["./start.sh && tail -f /dev/null"]
