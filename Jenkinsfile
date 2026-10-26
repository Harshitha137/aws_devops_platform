pipeline {
    agent any
    tools {
        jdk 'Java 21'
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

    }
}

