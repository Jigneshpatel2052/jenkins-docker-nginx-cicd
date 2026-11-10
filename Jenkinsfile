
pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    triggers {
        pollSCM('* * * * *')
    }

    environment {
        IMAGE_NAME = 'devops-portfolio'
        CONTAINER_NAME = 'devops-web'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate') {
            steps {
                sh '''
                    set -eu
                    test -s index.html
                    test -s style.css
                    test -s Dockerfile
                    test -s compose.yaml
                    grep -q "Jenkins + Docker + Nginx" index.html
                    docker compose config -q
                    echo "Validation successful"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                      -t ${IMAGE_NAME}:${BUILD_NUMBER} \
                      -t ${IMAGE_NAME}:latest .
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker compose up -d --no-build \
                      --force-recreate
                '''
            }
        }

        stage('Smoke Test') {
            steps {
                sh '''
                    set -eu

                    for i in $(seq 1 15); do
                        if curl -fsS http://127.0.0.1:8081/ \
                            | grep -q "Jenkins + Docker + Nginx"; then
                            echo "Deployment test passed"
                            exit 0
                        fi
                        sleep 2
                    done

                    echo "Deployment test failed"
                    docker compose logs --tail=50
                    exit 1
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check Jenkins console output.'
        }
    }
}
