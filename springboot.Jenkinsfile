pipeline {
    agent none
    tools {
        maven 'maven'
        jfrog 'jfrog-cli'
    }
    environment {
        registry = '282572191003.dkr.ecr.us-east-1.amazonaws.com/my-app'
    }
    stages {
        stage('git') {
            agent {
                label 'node'
            }
            steps {
                git 'https://github.com/vekadam/springboot-maven-micro.git'
            }
        }
        stage('maven') {
            agent {
                label 'node'
            }
            steps {
                sh 'mvn clean package'
                archiveArtifacts artifacts: 'target//*.jar', onlyIfSuccessful: true
                sh 'cp target/*jar /home/ubuntu/efs/'
                sh 'echo $(pwd)'
            }
        }
        stage('docker build') {
            agent {
                label 'docker'
            }
            steps {
                /*script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }*/
                sh 'cp ~/efs/*.jar .'
                sh "docker build -t 282572191003.dkr.ecr.us-east-1.amazonaws.com/my-app:$BUILD_NUMBER ."
                sh "docker push 282572191003.dkr.ecr.us-east-1.amazonaws.com/my-app:$BUILD_NUMBER"
            }
        }
        /* stage('Push artifacts into artifactory') {
            steps {
                jf 'rt u target//*.jar maven/'             
          }
        } */
    }
    /* post {
        always {
            archiveArtifacts artifacts: 'target//*.jar', onlyIfSuccessful: true
            sh 'cp target/*jar /home/ubuntu/efs/'
        }
    } */
}