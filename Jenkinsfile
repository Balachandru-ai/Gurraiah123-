pipeline {
    agent any

    environment {
        EC2_USER    = "ubuntu"
        EC2_HOST    = "54.84.36.120"

        PROJECT_DIR = "/home/ubuntu/fullstack-project"
        BACKEND_DIR = "/home/ubuntu/fullstack-project/backend"
        FRONTEND_DIR = "/home/ubuntu/fullstack-project/frontend"

        SSH_KEY = "/var/lib/jenkins/keys/UbuntuKeypair.pem"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Gurraiah123/fullstack-project.git'
            }
        }

        stage('Build Backend') {
            steps {
                sh '''
                    cd backend

                    python3 -m venv venv
                    ./venv/bin/pip install --upgrade pip
                    ./venv/bin/pip install -r requirements.txt
                '''
            }
        }

        stage('Build Frontend') {
            steps {
                sh '''
                    cd frontend

                    npm install
                    npm run build
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh '''
                    echo "🚀 Deploying to EC2..."

                    ssh -i $SSH_KEY -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "
                        mkdir -p $BACKEND_DIR &&
                        mkdir -p $FRONTEND_DIR/dist
                    "

                    rsync -avz --delete \
                    -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no" \
                    backend/ \
                    $EC2_USER@$EC2_HOST:$BACKEND_DIR/

                    rsync -avz --delete \
                    -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no" \
                    frontend/dist/ \
                    $EC2_USER@$EC2_HOST:$FRONTEND_DIR/dist/
                '''
            }
        }

        stage('Restart Services') {
            steps {
                sh '''
                    ssh -i $SSH_KEY -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "
                        sudo systemctl daemon-reload
                        sudo systemctl restart fastapi
                        sudo systemctl restart nginx
                    "
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful'
        }

        failure {
            echo '❌ Deployment Failed'
        }
    }
}
