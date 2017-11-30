#!groovy
import jenkins.*;
import jenkins.model.*;
import hudson.model.*;
import hudson.triggers.SCMTrigger;
import hudson.plugins.git.GitSCM;
import hudson.plugins.git.BranchSpec;
import com.cloudbees.plugins.credentials.domains.Domain;
import com.cloudbees.plugins.credentials.CredentialsScope;
import com.cloudbees.plugins.credentials.SystemCredentialsProvider;
import com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl;
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey;
import javaposse.jobdsl.plugin.*;
import hudson.security.csrf.DefaultCrumbIssuer;

jenkins = Jenkins.instance;
jenkins.save();

GlobalConfiguration.all().get(GlobalJobDslSecurityConfiguration.class).useScriptSecurity=false
GlobalConfiguration.all().get(GlobalJobDslSecurityConfiguration.class).save()

credentialsStore = Jenkins.instance.getExtensionList(com.cloudbees.plugins.credentials.SystemCredentialsProvider.class)[0];
privateKey = new BasicSSHUserPrivateKey(CredentialsScope.GLOBAL,"jenkins-key","jenkins",new BasicSSHUserPrivateKey.FileOnMasterPrivateKeySource('/opt/id_rsa'),"","jenkins ssh key")
credentialsStore = Jenkins.instance.getExtensionList(com.cloudbees.plugins.credentials.SystemCredentialsProvider.class)[0];
credentialsStore.store.addCredentials(Domain.global(), privateKey);

dsl = new hudson.model.FreeStyleProject(jenkins, "pipelines-dsl-bootstrap");
gitTrigger1 = new SCMTrigger("* * * * *");
dsl.addTrigger(gitTrigger1);
dsl.scm = new GitSCM("git@github.com:flugel-it/fun-with-jenkins2.git");
dsl.scm.branches = [new BranchSpec("*/master")];
dsl.scm.userRemoteConfigs[0].credentialsId = 'jenkins-key';

String pipelineScripts = "pipelines_dsl_bootstrap.groovy";

def jobDslBuildStep = new ExecuteDslScripts(
                            targets: pipelineScripts,
                            usingScriptText: false,
                            ignoreExisting: false,
                            removedJobAction: RemovedJobAction.DELETE,
                            removedViewAction: RemovedViewAction.IGNORE
                            );

dsl.getBuildersList().add(jobDslBuildStep);


jenkins.add(dsl, "pipelines-dsl-bootstrap");

def job1 = jenkins.getItem(dsl.name)
job1.scheduleBuild()

