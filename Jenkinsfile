pipeline{
	agent any{
		stages{
			stage("Git Checkout"){
				steps{
					checkout scm
				}
			}

			stage("Maven Build"){
				steps{
				       	sh "mvn clean package -DskipTests"
				}
			}
		}
	}
}
