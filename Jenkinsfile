pipeline {    
    agent any 
    stages {
        stage('git checkout') {
            steps {
               git credentialsId: 'MyGitHubCred', url: 'https://github.com/gowtham14041997/ecs-project'
            }
        }
        stage('terraform infra') {
            steps {            
            withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: "MyAwsCred",
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]]) {
                sh 'terraform -chdir="./terraform/ecr/" init'
                sh 'terraform -chdir="./terraform/ecr/" apply -auto-approve'
                }
            }
        }        
        stage('docker build') {
            steps {
                sh 'docker build -t webapp ./webapp/'
                sh 'docker tag webapp 335961360975.dkr.ecr.ap-south-1.amazonaws.com/webapp'
                sh 'docker build -t mysql ./mysql/'
                sh 'docker tag mysql 335961360975.dkr.ecr.ap-south-1.amazonaws.com/mysql'
            }
        }
        stage('ecr push') {
            steps {
            withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: "MyAwsCred",
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]]) {
                sh 'aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 335961360975.dkr.ecr.ap-south-1.amazonaws.com'
                sh 'docker push 335961360975.dkr.ecr.ap-south-1.amazonaws.com/webapp'
                sh 'docker push 335961360975.dkr.ecr.ap-south-1.amazonaws.com/mysql'
                }
            }
        }
        stage('terraform deploy') {
            steps {            
            withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: "MyAwsCred",
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]]) {
                sh 'terraform -chdir="./terraform/deployment/dev/" init'
                sh 'terraform -chdir="./terraform/deployment/dev/" apply -auto-approve'
                }
            }
        }  
    }
}
