pipeline {
    agent any

    environment {
        VERSION = '$BUILD_NUMBER'
        VERSION_RC = 'rc.2'
    }
    stages {
        stage('Audit tools') {
            steps {
                sh '''
                    git version
                    docker version 
                    dotnet --list-sdks
                    dotnet --list-runtimes 
                '''
            }        
        }
    }
}