
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
        APP_PORT = '8081'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code from GitHub...'
                checkout scm
            }
        }

        stage('Validate') {
            steps {
                sh '''
                    set -eu

                    echo "Checking project files..."

                    test -s index.html
                    test -s style.css
                    test -s Dockerfile
                    test -s compose.yaml

                    echo "Checking website content..."

                    grep -qi "Automating the Future" index.html
                    grep -qi "DevOps" index.html
                    grep -qi "Nginx" index.html

                    echo "Validating Docker Compose..."

                    docker compose config -q

                    echo "All validation checks passed!"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    set -eu

                    echo "Building Docker image..."

                    docker build \
                        -t ${IMAGE_NAME}:${BUILD_NUMBER} \
                        -t ${IMAGE_NAME}:latest .

                    echo "Docker image built successfully!"
                '''
            }
        }

        
stage('Deploy') {
    steps {
        sh '''
            set -eu

            echo "Deploying Nginx application..."

            docker compose -p jenkins-docker-nginx-cicd \
                up -d --no-build --force-recreate

            echo "Checking running containers..."

            docker ps
        '''
    }
}


        stage('Smoke Test') {
            steps {
                sh '''
                    set -eu

                    echo "Starting application smoke test..."

                    for i in $(seq 1 15); do

                        if curl -fsS \
                            http://127.0.0.1:${APP_PORT}/ \
                            -o /tmp/devops-website.html; then

                            if grep -qi "Automating the Future" \
                                /tmp/devops-website.html; then

                                echo "HTTP response successful"
                                echo "Website content verified"
                                echo "Smoke test passed!"

                                exit 0
                            fi
                        fi

                        echo "Waiting for application..."
                        sleep 2
                    done

                    echo "Smoke test failed!"

                    docker compose logs --tail=50

                    exit 1
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully!'
            echo 'Nginx application deployed successfully.'
        }

        failure {
            echo 'CI/CD pipeline failed.'
            echo 'Please check the Console Output.'
        }

        always {
            echo 'Pipeline execution completed.'
        }
    }
}
