pipeline {
    agent any

    environment {
        IMAGE_NAME = 'amazon-q-cli'
        CONTAINER_NAME = 'my-container'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    def imageExists = sh(
                        script: "docker images -q ${IMAGE_NAME}",
                        returnStdout: true
                    ).trim()

                    if (imageExists) {
                        echo "Docker image '${IMAGE_NAME}' already exists. Skipping build."
                    } else {
                        sh "docker build -t ${IMAGE_NAME} ."
                    }
                }
            }
        }

        stage('Create and Start Docker Container') {
            steps {
                script {
                    def containerExists = sh(
                        script: "docker ps -a --format '{{.Names}}' | grep -w ${CONTAINER_NAME} || true",
                        returnStdout: true
                    ).trim()

                    if (containerExists) {
                        echo "Container '${CONTAINER_NAME}' already exists. Skipping creation."

                        def isRunning = sh(
                            script: "docker ps --format '{{.Names}}' | grep -w ${CONTAINER_NAME} || true",
                            returnStdout: true
                        ).trim()

                        if (!isRunning) {
                            sh "docker start ${CONTAINER_NAME}"
                            echo "Started existing container '${CONTAINER_NAME}'."
                        } else {
                            echo "Container '${CONTAINER_NAME}' is already running."
                        }
                    } else {
                        sh "docker run -d --name ${CONTAINER_NAME} -p 8000:8000 ${IMAGE_NAME}"
                        echo "Created and started new container '${CONTAINER_NAME}'."
                    }
                }
            }
        }

        stage('Q CLI Login') {
            steps {
                script {
                    echo "Starting Q CLI login process. Follow the URL and enter the code shown below to authorize."

                    // Run q login command inside container and capture output (with timeout so Jenkins doesn't hang forever)
                    def loginOutput = sh(
                        script: "timeout 300 docker exec -it ${CONTAINER_NAME} q login || true",
                        returnStdout: true
                    ).trim()

                    echo "Q Login Output:\n${loginOutput}"
                }
            }
        }

        stage('List Docker Images and Containers') {
            steps {
                sh 'docker images'
                sh 'docker ps -a'
            }
        }
    }
}
