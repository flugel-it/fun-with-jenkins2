FROM jenkinsci/jenkins:latest

USER root

COPY id_rsa /opt/id_rsa
RUN chown jenkins:jenkins /opt/id_rsa

USER jenkins

RUN /usr/local/bin/install-plugins.sh workflow-aggregator job-dsl git build-flow-plugin

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

COPY admin.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/

