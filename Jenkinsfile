pipeline {
    agent any
    tools {
        jdk 'Java 21'
    }
    
    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REPOSITORY = '446983861261.dkr.ecr.ap-south-1.amazonaws.com/employee-api'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage("Git Checkout") {
            steps {
                checkout scm
            }
        }

        stage('Maven Build') {
            steps {
                dir('application') {
                    sh '''
                        echo "=== DEBUG INFO ==="
                        echo "JAVA_HOME: $JAVA_HOME"
                        java -version
                        javac -version
                        echo "=================="
                        
                        # Limit memory to prevent Out Of Memory (OOM) crashes
                        export MAVEN_OPTS="-Xmx512m -XX:MaxMetaspaceSize=256m"
                        
                        export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
                        export PATH=$JAVA_HOME/bin:$PATH
                        
                        mvn clean package -DskipTests
                    '''
                }
            }
        }
        
        stage('Docker Build') {
            steps {
                dir('application') {
                    sh 'docker build -t employee-api:${BUILD_NUMBER} .'
        }
    }
}
        
        stage('Push to ECR') {
            steps {
                sh '''
                    echo ${BUILD_NUMBER}
                    aws ecr get-login-password --region ap-south-1 |
                    docker login --username AWS --password-stdin 446983861261.dkr.ecr.ap-south-1.amazonaws.com
                    docker tag employee-api:${BUILD_NUMBER} 446983861261.dkr.ecr.ap-south-1.amazonaws.com/employee-api:${BUILD_NUMBER}
                    docker push 446983861261.dkr.ecr.ap-south-1.amazonaws.com/employee-api:${BUILD_NUMBER}
                    '''
    }
}
        
    stage('Deploy to Kubernetes') {
        steps {
            sh '''
                ssh -i ~/.ssh/k3s_deploy \
                    -o StrictHostKeyChecking=accept-new \
                    ubuntu@172.31.6.81 \
                    "sudo k3s kubectl set image deployment/employee-api \
                    employee-api=446983861261.dkr.ecr.ap-south-1.amazonaws.com/employee-api:${BUILD_NUMBER} \
                    -n employee-app"

                ssh -i ~/.ssh/k3s_deploy \
                    ubuntu@172.31.6.81 \
                    "sudo k3s kubectl rollout status deployment/employee-api \
                    -n employee-app --timeout=180s"
            '''
    }
}



    }
}

