#!groovy
import jenkins.automation.builders.*
import jenkins.automation.utils.EnvironmentUtils


def helloJob = new BaseJobBuilder(
	name: "helloworld",
	description: "Example job"
)

helloJob.build(this).with {
	steps {
		println("Hello world")
	}
}
