pipeline {
    agent any
    stages {
        stage('Deploy') {
	    steps {
	        echo "Running 'Deploy' stage.."
		sh 'whoami'
		sh 'hostname'
	        sh '. /etc/profile'
		sh 'singularity pull docker://cmdv/test-runner-env:latest'

            }
        }		
        stage('Test') {
            steps {
                sh '. /etc/profile'
                sh '. init.sh'
		sh "singularity exec -B $env.pwd():/CMDV/CMDV-Testing --pwd /CMDV/CMDV-Testing test-runner-env-latest.simg ./run_ctest.sh"
	    
                echo "Running 'Test' stage..."
            }
        }
    }
}
