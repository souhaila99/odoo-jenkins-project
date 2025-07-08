pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "souhaila999/testodoo"              // Nom de l'image Docker
        DOCKER_TAG = "18.0"                                 // Tag Docker
        DOCKER_CREDENTIALS_ID = "docker-hub-credentials"    // ID des identifiants Docker dans Jenkins
        KUBE_CONFIG_ID = "aks-kubeconfig"                   // ID des identifiants kubeconfig dans Jenkins
    }

    stages {
        stage('Checkout SCM') {
            steps {
                echo '📥 Clonage du dépôt Git...'
                retry(2) {
                    checkout scm
                }
            }
        }

        stage('Construire l\'image Docker') {
            steps {
                echo "🔧 Construction de l'image Docker : ${DOCKER_IMAGE}:${DOCKER_TAG}"
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Se connecter à Docker Hub') {
            steps {
                echo '🔐 Authentification à Docker Hub...'
                script {
                    docker.withRegistry('', DOCKER_CREDENTIALS_ID) {
                        echo '✅ Authentifié avec succès à Docker Hub'
                    }
                }
            }
        }

        stage('Pousser l\'image sur Docker Hub') {
            steps {
                echo '🚀 Push de l\'image Docker...'
                script {
                    docker.withRegistry('', DOCKER_CREDENTIALS_ID) {
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }

        stage('Déployer sur AKS') {
            steps {
                echo '📦 Déploiement de l\'application sur AKS...'
                script {
                    withKubeConfig([credentialsId: KUBE_CONFIG_ID]) {
                        sh "kubectl apply -f Kubernetes/"
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                node {
                    echo '🧹 Nettoyage du workspace Jenkins...'
                    cleanWs()
                }
            }
        }
        failure {
            echo '❌ Le pipeline a échoué. Veuillez vérifier les logs.'
        }
    }
}
