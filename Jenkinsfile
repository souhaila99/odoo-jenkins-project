pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "souhaila999/testodoo"   // Remplace par ton nom d'image
        DOCKER_TAG = "18.0"
        DOCKER_CREDENTIALS_ID = "docker-hub-credentials" // ID des identifiants Docker Hub dans Jenkins
        KUBE_CONFIG_ID = "aks-kubeconfig" // ID du fichier kubeconfig dans Jenkins
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Construire l\'image Docker') {
            steps {
                script {
                    sh """
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    """
                }
            }
        }

        stage('Se connecter à Docker Hub et Pousser l\'image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        sh """
                        docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                        """
                    }
                }
            }
        }

        stage('Déployer sur AKS') {
            steps {
                script {
                    withKubeConfig([credentialsId: KUBE_CONFIG_ID]) {
                        sh """
                        kubectl apply -f Kubernetes/
                        """
                    }
                }
            }
        }
    }
}
