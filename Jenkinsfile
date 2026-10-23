pipeline{
	agent any
	tools{
		jdk 'Java 21'
}
	stages{
		stage("Git Checkout"){
			steps{
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
                
                export JAVA_HOME=$JAVA_HOME
                export PATH=$JAVA_HOME/bin:$PATH
                mvn clean package -DskipTests
            '''
        }
    }
}
	}
}

