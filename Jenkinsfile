pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        DOCKER_IMAGE = 'souhaila999/testodoo'
        DOCKER_TAG = '18.0'
        KUBE_CONFIG_ID = 'aks-kubeconfig'
    }

    stages {
        stage('Clonage du dépôt Git') {
            steps {
                checkout scm
            }
        }

        stage('Construction de l\'image Docker') {
            steps {
                script {
                    sh """
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    """
                }
            }
        }

        stage(' Connexion à Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_CREDENTIALS_ID) {
                        echo ' Authentifié avec succès à Docker Hub'
                    }
                }
            }
        }

        stage(' Push de l\'image sur Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_CREDENTIALS_ID) {
                        sh """
                        docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                        """
                    }
                }
            }
        }

        stage(' Déploiement sur AKS') {
            steps {
                script {
                    withKubeConfig([credentialsId: KUBE_CONFIG_ID]) {
                        sh "kubectl apply -f Kubernetes/"
                    }
                }
            }
        }
    }

    post {
        success {
            emailext(
                subject: " Succès - ${env.JOB_NAME}",
                body: "Le pipeline ${env.JOB_NAME} s'est terminé avec succès.\nDétails : ${env.BUILD_URL}",
                to: "achour.souhaila77@gmail.com"
            )
        }
        failure {
            emailext(
                subject: " Échec - ${env.JOB_NAME}",
                body: "Le pipeline ${env.JOB_NAME} a échoué.\nDétails : ${env.BUILD_URL}",
                to: "achour.souhaila77@gmail.com"
            )
        }
    }
}
