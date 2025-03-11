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
                    // Print all available images to debug the issue
                    sh "docker images"

                    // Extract the image ID of the latest built image
                    def imageID = sh(script: "docker images --format '{{.ID}} {{.Repository}}:{{.Tag}}' | grep \"${IMAGE_NAME}:latest\" | awk '{print \$1}'", returnStdout: true).trim()

                    // Debug the extracted image ID
                    echo "Found image ID: ${imageID}"

                    if (!imageID) {
                        error "No image found with name $IMAGE_NAME:latest"
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

