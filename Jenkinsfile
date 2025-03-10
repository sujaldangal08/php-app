pipeline {
    agent any

    environment {
        IMAGE_NAME = 'sujaldangal/php-app'
    }

    stages {
        stage('Checkout Repository') {
            steps {
                git url: 'https://github.com/sujaldangal08/php-app.git', branch: 'main'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', 
                                usernameVariable: 'DOCKER_USER', 
                                passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Run Docker Compose to Build Image') {
            steps {
                sh 'docker compose up -d --build'
            }
        }

        stage('Extract Image ID from Docker Compose') {
            steps {
                script {
                    def imageID = sh(script: "docker images --format '{{.Repository}}:{{.Tag}}' | grep '$IMAGE_NAME'", returnStdout: true).trim()
                    if (!imageID) {
                        error "No image found with name $IMAGE_NAME"
                    }
                    env.NEW_IMAGE_TAG = imageID
                }
            }
        }

        stage('Push New Image to Docker Hub') {
            steps {
                script {
                    def buildTag = "v${env.BUILD_NUMBER}"
                    sh "docker tag $NEW_IMAGE_TAG $IMAGE_NAME:${buildTag}"
                    sh "docker push $IMAGE_NAME:${buildTag}"
                    sh "docker push $IMAGE_NAME:latest"
                }
            }
        }
    }

 
}

