pipeline {
    agent {
        kubernetes {
            yaml '''
                apiVersion: v1
                kind: Pod
                metadata:
                labels:
                    app: suntech-backend-build
                spec:
                    containers:
                    - name: maven
                      image: maven:3.9.6-eclipse-temurin-21
                      command:
                      - cat
                      tty: true
                    - name: docker
                      image: docker:24-dind
                      securityContext:
                        privileged: true
                      env:
                      - name: DOCKER_TLS_CERTDIR
                        value: ""
                      volumeMounts:
                      - name: docker-config
                        mountPath: /docker-secret
                        readOnly: true
                      - name: docker-home
                        mountPath: /root/.docker/
                      command:
                      - dockerd-entrypoint.sh
                      tty: true
                    volumes:
                    - name: docker-home
                      emptyDir: {}
                    - name: docker-config
                      secret:
                        secretName: dockerhub-secret
                        items:
                        - key: .dockerconfigjson
                          path: config.json
                '''
        }
    }

    environment {
        DOCKER_IMAGE = 'suntech-backend'
        DOCKER_REPO = 'fizazi2021/suntech-backend'
    }

    stages {
        stage('Build Maven') {
            steps {
                container('maven') {
                    script {
                        def projectVersion = sh(script: 'mvn help:evaluate -Dexpression=project.version -q -DforceStdout', returnStdout: true).trim()
                        env.DOCKER_TAG = "${projectVersion}-v${BUILD_NUMBER}"
                        echo "Docker Tag: ${env.DOCKER_TAG}"
                    }
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                container('docker') {
                    script {
                        // Wait/Check for docker socket? Usually dind is ready fast enough.
                        sh "docker build -t ${DOCKER_REPO}:${DOCKER_TAG} ."
                        sh "docker tag ${DOCKER_REPO}:${DOCKER_TAG} ${DOCKER_REPO}:latest"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                container('docker') {
                    script {
                        sh "mkdir -p /root/.docker"
                        sh  "cp /docker-secret/config.json /root/.docker/config.json"
                        sh "docker push ${DOCKER_REPO}:${DOCKER_TAG}"
                    }
                }
            }
        }

    }
}


