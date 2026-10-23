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
                export PATH=$JAVA_HOME/bin:$PATH
                mvn clean package -DskipTests
            '''
        }
    }
}
	}
}

