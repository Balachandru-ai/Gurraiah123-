pipeline {
    agent any

    environment {
        EC2_USER = "ubuntu"
        EC2_HOST = "54.84.36.120"

        PROJECT_DIR = "/home/ubuntu/fullstack-project"
        BACKEND_DIR = "/home/ubuntu/fullstack-project/backend"
        FRONTEND_DIR = "/home/ubuntu/fullstack-project/frontend"

        // 🔥 IMPORTANT: FIXED ABSOLUTE PATH (CHANGE IF NEEDED)
        SSH_KEY = "/home/ubuntu/.jenkins/workspace/FSD/UbuntuKeypair.pem"
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

                # Create directories on EC2
                ssh -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@54.84.36.120 "
                    mkdir -p /home/ubuntu/fullstack-project/backend &&
                    mkdir -p /home/ubuntu/fullstack-project/frontend/dist
                "

                # Sync backend
                rsync -avz -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no" \
                backend/ ubuntu@54.84.36.120:/home/ubuntu/fullstack-project/backend/

                # Sync frontend build
                rsync -avz -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no" \
                frontend/dist/ ubuntu@54.84.36.120:/home/ubuntu/fullstack-project/frontend/dist/
                '''
            }
        }

        stage('Restart Services') {
            steps {
                sh '''
                ssh -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@54.84.36.120 "
                    sudo systemctl daemon-reload || true
                    sudo systemctl restart fastapi || true
                    sudo systemctl restart nginx || true
                "
                '''
            }
        }
    }

    post {
        success {
            echo "🚀 Deployment Successful"
        }
        failure {
            echo "❌ Deployment Failed"
        }
    }
}
