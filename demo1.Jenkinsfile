pipeline {
    agent any 
    environment {
        RELEASE=$BUILD_NUMBER
    }

    stages {
        stage('Build') {
            environment {
                LOG_LEVEL='INFO'
            }
            parallel {
                stage('linux') {
                    steps {
                        echo "Building release $RELEASE for $STAGE_NAME with log level $LOG_LEVEL .."
                    }
                }
                stage('macos') {
                    steps {
                        echo "Building release $RELEASE for $STAGE_NAME with log level $LOG_LEVEL .."
                    }    
                }
                stage('windows') {
                    steps {
                        echo "Building release $RELEASE for $STAGE_NAME with log level $LOG_LEVEL .."
                    }
                }
            }
        }
        stage('Test') {
            steps {
                echo "Testing release $RELEASE .."
            }
        }
        stage('deploy') {
            input {
                message 'Deploy?'
                ok 'Do it!'
                parameters {
                    string(name: 'TARGET_ENVIRONMENT', defaultValue: 'PROD', description: 'Target deployment env')
                }    
            }
            steps {
                echo "Deplying release $RELEASE to $TARGET_ENVIRONMENT "
            }
        }
    }
    post {
        always {
            echo "Prints wheather deploy happened or not, success or failure"
        }
    }
}