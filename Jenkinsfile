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
                sh '. /etc/profile'
		sh "singularity exec -B ${PWD}:/CMDV/CMDV-Testing --pwd /CMDV/CMDV-Testing docker://cmdv/test-runner-env:latest ./run_ctest.sh"
	    
                echo "Running 'Test' stage..."
            }
        }
    }
}
