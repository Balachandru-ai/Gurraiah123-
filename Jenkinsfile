pipeline {
    agent any

    environment {
        EC2_USER    = "ec2-user"
        EC2_HOST    = "13.61.218.154"

        PROJECT_DIR  = "/home/ec2-user/Gurraiah123-"
        BACKEND_DIR  = "/home/ec2-user/Gurraiah123-/backend"
        FRONTEND_DIR = "/home/ec2-user/Gurraiah123-/frontend"

        SSH_KEY = "/var/lib/jenkins/keys/environment.pem"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Balachandru-ai/Gurraiah123-.git'
            }
        }

        stage('Install Backend Dependencies') {
            steps {
                sh '''
                    cd backend
                    python3 -m pip install --upgrade pip
                    pip3 install -r requirements.txt
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
                    rsync -avz --delete \
                    -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no" \
                    backend/ \
                    $EC2_USER@$EC2_HOST:$BACKEND_DIR/

                    rsync -avz --delete \
                    -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no" \
                    frontend/dist/ \
                    $EC2_USER@$EC2_HOST:/usr/share/nginx/html/
                '''
            }
        }

        stage('Restart Services') {
            steps {
                sh '''
                    ssh -i $SSH_KEY -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "
                        sudo systemctl restart nginx
                    "
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully.'
        }

        failure {
            echo 'Deployment failed. Check the Jenkins console output for details.'
        }
    }
}
