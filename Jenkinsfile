pipeline {
    agent any
    stages {
        stage('Deploy') {
	    steps {
	        echo "Running 'Deploy' stage.."
		sh 'whoami'
		sh 'hostname'
            }
        }		
        stage('Test') {
            steps {
                echo "Running 'Test' stage..."
            }
        }
    }
}
