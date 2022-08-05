pipeline{
    agent any
    
    }
    stages{
        stage('git checkout'){
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/lakshaygautam1992/project_terraform.git']]])
            }
        }
        stage('terraform init'){
            steps{
                sh 'terraform init'
            }
        }
        stage('terraform plan'){
            steps{
                sh 'terraform plan -auto-approve'
            }
        }
    }
}
