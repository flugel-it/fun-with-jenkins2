pipelineJob('Build and deploy') {
    logRotator(-1, 50, -1, -1)
    concurrentBuild(false)
    definition {
        cpsScm {
            scm {
                scriptPath ('Jenkinsfile')
                git {
                    branches('*/master')
                    remote {
                        url ('https://github.com/flugel-it/fun-with-jenkins2.git')
                        credentials ('')
                    }
                }
            }
        }
    }
}

