pipeline {
    agent {
        label 'node'
    }
    tools {
        maven 'maven'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch:main, url: 'https://github.com/vekadam/labs.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
            post {
                success {
                    junit '**/target/surefire-reports/TEST-*.xml'
                    archiveArtifacts 'tartget/*.jar'
                }
            }
        }
        stage('Sonar') {
            environment {
                SONAR_URL = "http://54.211.205.3:9000"
            }
            steps {
                withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')])
                sh 'mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=$SONAR_URL'
            }
        }
        stage('Docker Build') {
            steps {
                sh "sudo docker build -t hhh:$BUILD_NUMBER"
                sh "sudo docker push hhh:$BUILD_NUMBER"
            }
        }
        stage('Update Deployment') {
            environment {
                GIT_REPO_NAME = "labs"
                GIT_USER_NAME = "vekadam"
            }
            steps {
                withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')])
                sh '''
                    git config user.name "Vaibhav Kadam"
                    git config user.email "vekadam7@gamil.com"
                    sed -i "s/replaceImageTag/$BUILD_NUMBER" java-maven-sonar-argocd-helm-k8s/spring-boot-app-manifests/deployment.yml
                    git add .
                    git commit -m "update tag"
                    git push origin 
                    https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main    
                '''
            }

        }
    }
}