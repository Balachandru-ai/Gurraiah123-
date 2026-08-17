pipeline {
    agent {
        label 'slave'
    }

    environment {
        REGISTRY = '13.53.243.43:8082'
        IMAGE_NAME = 'gurraiah-app'
        IMAGE_TAG = "${BUILD_NUMBER}"

        SONAR_HOST = 'http://13.53.243.43:9000'

        NEXUS_CREDENTIALS = credentials('nexus-docker')
        SONAR_TOKEN = credentials('sonarqube-token')
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Balachandru-ai/Gurraiah123-.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                sh '''
                    sonar-scanner \
                      -Dsonar.projectKey=gurraiah-app \
                      -Dsonar.projectName=gurraiah-app \
                      -Dsonar.sources=backend,frontend/src \
                      -Dsonar.host.url=$SONAR_HOST \
                      -Dsonar.token=$SONAR_TOKEN
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build \
                      -t $REGISTRY/$IMAGE_NAME:$IMAGE_TAG \
                      -t $REGISTRY/$IMAGE_NAME:latest \
                      .
                '''
            }
        }

        stage('Nexus Login') {
            steps {
                sh '''
                    echo "$NEXUS_CREDENTIALS_PSW" | docker login $REGISTRY \
                      -u "$NEXUS_CREDENTIALS_USR" \
                      --password-stdin
                '''
            }
        }

        stage('Push to Nexus') {
            steps {
                sh '''
                    docker push $REGISTRY/$IMAGE_NAME:$IMAGE_TAG
                    docker push $REGISTRY/$IMAGE_NAME:latest
                '''
            }
        }

        stage('Deploy Kubernetes') {
            steps {
                sh '''
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                '''
            }
        }

        stage('Restart Deployment') {
            steps {
                sh '''
                    kubectl rollout restart deployment/gurraiah-app
                    kubectl rollout status deployment/gurraiah-app --timeout=180s
                '''
            }
        }

        stage('Verify') {
            steps {
                sh '''
                    kubectl get pods
                    kubectl get svc
                    kubectl get deployment gurraiah-app
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }

        failure {
            echo 'Pipeline failed!'
        }
    }
}pipeline {
    agent {
	lable 'slave'	

	}

    environment {
        REGISTRY = '13.53.243.43:8082'
        IMAGE_NAME = 'gurraiah-app'
        IMAGE_TAG = "${BUILD_NUMBER}"

        SONAR_HOST = 'http://13.53.243.43:9000'

        NEXUS_CREDENTIALS = credentials('nexus-docker')
        SONAR_TOKEN = credentials('sonarqube-token')
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Balachandru-ai/Gurraiah123-.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                sh '''
                    sonar-scanner \
                      -Dsonar.projectKey=gurraiah-app \
                      -Dsonar.projectName=gurraiah-app \
                      -Dsonar.sources=backend,frontend/src \
                      -Dsonar.host.url=$SONAR_HOST \
                      -Dsonar.token=$SONAR_TOKEN
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build \
                      -t $REGISTRY/$IMAGE_NAME:$IMAGE_TAG \
                      -t $REGISTRY/$IMAGE_NAME:latest \
                      .
                '''
            }
        }

        stage('Nexus Login') {
            steps {
                sh '''
                    echo "$NEXUS_CREDENTIALS_PSW" | docker login $REGISTRY \
                      -u "$NEXUS_CREDENTIALS_USR" \
                      --password-stdin
                '''
            }
        }

        stage('Push to Nexus') {
            steps {
                sh '''
                    docker push $REGISTRY/$IMAGE_NAME:$IMAGE_TAG
                    docker push $REGISTRY/$IMAGE_NAME:latest
                '''
            }
        }

        stage('Deploy Kubernetes') {
            steps {
                sh '''
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                '''
            }
        }

        stage('Restart Deployment') {
            steps {
                sh '''
                    kubectl rollout restart deployment/gurraiah-app
                    kubectl rollout status deployment/gurraiah-app --timeout=180s
                '''
            }
        }

        stage('Verify') {
            steps {
                sh '''
                    kubectl get pods
                    kubectl get svc
                    kubectl get deployment gurraiah-app
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }

        failure {
            echo 'Pipeline failed!'
        }
    }
}
