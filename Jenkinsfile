pipeline {
    agent any

    environment {
        EC2_USER = "ec2-user"
        EC2_HOST = "13.61.218.154"

        PROJECT_DIR = "/home/ec2-user/Gurraiah123-"
        BACKEND_DIR = "/home/ec2-user/Gurraiah123-/backend"

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
                    python3 -m pip install -r requirements.txt
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

        stage('Deploy Backend') {
            steps {
                sh '''
                    ssh -i $SSH_KEY -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "
                        mkdir -p $BACKEND_DIR
                    "

                    rsync -avz --delete \
                        -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no" \
                        backend/ \
                        $EC2_USER@$EC2_HOST:$BACKEND_DIR/
                '''
            }
        }

        stage('Deploy Frontend') {
            steps {
                sh '''
                    rsync -avz --delete \
                        -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no" \
                        frontend/dist/ \
                        $EC2_USER@$EC2_HOST:/tmp/frontend-dist/

                    ssh -i $SSH_KEY -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "
                        sudo rm -rf /usr/share/nginx/html/*
                        sudo cp -r /tmp/frontend-dist/* /usr/share/nginx/html/
                        sudo systemctl restart nginx
                    "
                '''
            }
        }

        stage('Restart Backend') {
            steps {
                sh '''
                    ssh -i $SSH_KEY -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "
                        sudo systemctl restart fastapi || true
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
