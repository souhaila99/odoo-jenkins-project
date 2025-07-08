pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials' 
        DOCKER_IMAGE = 'souhaila999/testodoo'          
        DOCKER_TAG = '18.0'                           
        KUBE_CONFIG_ID = 'aks-kubeconfig'                         
    }

    stages {
        stage('Checkout SCM') {
            steps {
                echo '📥 Clonage du dépôt Git...'
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

        stage('Se connecter à Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_CREDENTIALS_ID) {
                        echo 'Authentifié avec succès à Docker Hub'
                    }
                }
            }
        }

        stage('Pousser l\'image sur Docker Hub') {
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

    post {
        success {
            emailext(
                subject: "Pipeline ${env.JOB_NAME} - Succès",
                body: """
                    Le pipeline ${env.JOB_NAME} s'est terminé avec succès.
                    Voir les détails à ${env.BUILD_URL}
                """,
                recipientProviders: [[$class: 'DevelopersRecipientProvider']],
                to: "achour.souhaila77@gmail.com"
            )
        }
        failure {
            emailext(
                subject: "Pipeline ${env.JOB_NAME} - Échec",
                body: """
                    Le pipeline ${env.JOB_NAME} a échoué.
                    Voir les détails à ${env.BUILD_URL}
                """,
                recipientProviders: [[$class: 'DevelopersRecipientProvider']],
                to: "achour.souhaila77@gmail.com"
            )
        }
    }
}
