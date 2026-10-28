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
                    echo BUILD_NUMBER = ${BUILD_NUMBER}
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
            set -e

            ECR_PASSWORD=$(aws ecr get-login-password --region ap-south-1)

            printf '%s' "$ECR_PASSWORD" | ssh \
                -i /var/lib/jenkins/.ssh/k3s_deploy \
                ubuntu@172.31.6.81 \
                'sudo k3s kubectl create secret docker-registry ecr-secret \
                --docker-server=446983861261.dkr.ecr.ap-south-1.amazonaws.com \
                --docker-username=AWS \
                --docker-password="$(cat)" \
                -n employee-app --dry-run=client -o yaml |
                sudo k3s kubectl apply -f -'

            unset ECR_PASSWORD

            sed "s|\${BUILD_NUMBER}|${BUILD_NUMBER}|g" \
                kubernetes/deployment.yml > deployment-rendered.yml

            scp -i /var/lib/jenkins/.ssh/k3s_deploy \
                deployment-rendered.yml \
                ubuntu@172.31.6.81:/tmp/deployment-rendered.yml

            ssh -i /var/lib/jenkins/.ssh/k3s_deploy \
                ubuntu@172.31.6.81 \
                'sudo k3s kubectl apply -f /tmp/deployment-rendered.yml'

            ssh -i /var/lib/jenkins/.ssh/k3s_deploy \
                ubuntu@172.31.6.81 \
                'sudo k3s kubectl rollout status deployment/employee-api \
                -n employee-app --timeout=180s'
        '''
    }
}
    }
}

