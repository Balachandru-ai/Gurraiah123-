pipeline {
    agent {
        label 'fastapi'
    }

    environment {
        PROJECT_DIR = "/home/ec2-user/Gurraiah123-"
        BACKEND_DIR = "${PROJECT_DIR}/backend"
        FRONTEND_DIR = "${PROJECT_DIR}/frontend"
    }

    stages {

        stage('Checkout Code') {
            steps {
                deleteDir()

                git branch: 'main',
                    url: 'https://github.com/Balachandru-ai/Gurraiah123-.git'
            }
        }

        stage('Install Backend Dependencies') {
            steps {
                sh '''
                    cd backend

                    python3 -m venv venv

                    source venv/bin/activate

                    pip install --upgrade pip

                    pip install -r requirements.txt
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
                    mkdir -p $BACKEND_DIR

                    rsync -av --delete backend/ $BACKEND_DIR/
                '''
            }
        }

        stage('Deploy Frontend') {
            steps {
                sh '''
                    sudo mkdir -p /usr/share/nginx/html

                    sudo rm -rf /usr/share/nginx/html/*

                    sudo cp -r frontend/dist/* /usr/share/nginx/html/
                '''
            }
        }

        stage('Restart Services') {
            steps {
                sh '''
                    sudo systemctl restart nginx

                    sudo systemctl restart fastapi
                '''
            }
        }

        stage('Verify Services') {
            steps {
                sh '''
                    sudo systemctl status nginx --no-pager

                    sudo systemctl status fastapi --no-pager
                '''
            }
        }
    }

    post {

        success {
            echo '================================='
            echo 'Deployment Successful'
            echo '================================='
        }

        failure {
            echo '================================='
            echo 'Deployment Failed'
            echo '================================='
        }
    }
}
