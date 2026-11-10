
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

            echo "Starting application smoke test..."

            for i in $(seq 1 15); do

                if curl -fsS http://127.0.0.1:8081/ \
                    -o /tmp/devops-website.html; then

                    if grep -qi "Automating the Future" \
                        /tmp/devops-website.html; then

                        echo "HTTP response successful"
                        echo "Website content verified"
                        echo "Deployment smoke test passed"

                        exit 0
                    fi
                fi

                echo "Waiting for website..."
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
        }
        failure {
            echo 'Pipeline failed. Check Jenkins console output.'
        }
    }
}
