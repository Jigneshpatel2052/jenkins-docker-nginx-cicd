
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
    CONTAINER_NAME = 'jenkins-docker-nginx-cicd-web-1'
    COMPOSE_PROJECT_NAME = 'jenkins-docker-nginx-cicd'
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
            test -s nginx.conf

            echo "Checking website content..."

            grep -qi "From code" index.html
            grep -qi "GitHub" index.html
            grep -qi "Jenkins" index.html
            grep -qi "Docker" index.html
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

            echo "Creating SSL certificates..."

            mkdir -p certs

            if [ ! -s certs/server.crt ] || [ ! -s certs/server.key ]; then

                openssl req -x509 -nodes -days 365 \
                -newkey rsa:2048 \
                -keyout certs/server.key \
                -out certs/server.crt \
                -subj "/CN=10.79.8.100"

            fi

            chmod 600 certs/server.key
            chmod 644 certs/server.crt

            echo "SSL certificates ready!"

            echo "Deploying application..."

            docker compose -p jenkins-docker-nginx-cicd \
                up -d --no-build --force-recreate

            echo "Deployment completed!"
        '''
    }
}





stage('Smoke Test') {
    steps {
        sh '''
            set -eu

            echo "Testing HTTP website..."

            for i in $(seq 1 15); do

                if curl -fsS http://127.0.0.1:8081/ \
                    -o /tmp/devops-website.html; then

                    if grep -qi "Automating the Future" \
                        /tmp/devops-website.html; then

                        echo "HTTP test successful"
                        echo "Website content verified"
                        echo "Smoke test passed"
                        exit 0
                    fi
                fi

                sleep 2
            done

            echo "Smoke test failed"
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
