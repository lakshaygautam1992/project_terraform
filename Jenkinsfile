pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
            checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/lakshaygautam1992/project_terraform.git']]])            

          }
        }
    stage('terraform init'){
            steps{
                sh 'terraform init'
            }
        }
    stage('terraform destroy'){
            steps{
                sh 'terraform destroy --auto-approve'
            }
        }
    }
}
