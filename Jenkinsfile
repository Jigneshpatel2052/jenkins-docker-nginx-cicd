
pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        skipDefaultCheckout(true)
    }

    triggers {
        pollSCM('* * * * *')
    }

    environment {
        IMAGE_NAME = 'devops-portfolio'
        COMPOSE_PROJECT_NAME = 'jenkins-docker-nginx-cicd'
    }

    stages {

        // STAGE 1: CHECKOUT
        stage('Checkout') {
            steps {
                echo 'Checking out source code from GitHub...'
                checkout scm
            }
        }

        // STAGE 2: VALIDATE
        stage('Validate') {
            steps {
                sh '''
                    set -eu

                    echo "Checking project files..."

                    test -s index.html
                    test -s style.css
                    test -s Dockerfile
                    test -s compose.yaml
                    test -s nginx.conf

                    echo "Checking website content..."

                    grep -qi "DEVOPS" index.html
                    grep -qi "GitHub" index.html
                    grep -qi "Jenkins" index.html
                    grep -qi "Docker" index.html
                    grep -qi "Nginx" index.html

                    echo "Checking Docker Compose..."

                    docker compose config -q

                    echo "All validation checks passed!"
                '''
            }
        }

        // STAGE 3: BUILD DOCKER IMAGE
        stage('Build Docker Image') {
            steps {
                sh '''
                    set -eu

                    echo "Building Docker image..."

                    docker build -t ${IMAGE_NAME}:latest .

                    echo "Docker image built successfully!"
                '''
            }
        }

        // STAGE 4: DEPLOY
        stage('Deploy') {
            steps {
                sh '''
                    set -eu

                    echo "Deploying application..."

                    docker compose up -d --no-build --force-recreate

                    echo "Deployment completed!"
                '''
            }
        }

        // STAGE 5: SMOKE TEST
        stage('Smoke Test') {
            steps {
                sh '''
                    set -eu

                    echo "Starting HTTP smoke test..."

                    for i in $(seq 1 15); do

                        if curl -fsS \
                            http://127.0.0.1:8081/ \
                            -o /tmp/devops-website.html; then

                            if grep -qi "DEVOPS" \
                                /tmp/devops-website.html; then

                                echo "HTTP response: SUCCESS"
                                echo "Website content: VERIFIED"
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

    // POST ACTIONS
    post {

        success {
            echo 'CI/CD pipeline completed successfully!'
            echo 'HTTP website deployed successfully.'
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
