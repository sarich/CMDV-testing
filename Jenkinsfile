pipeline {
    agent any
    stages {
        stage('Deploy') {
	    steps {
	        echo "Running 'Deploy' stage.."
	        sh 'source /etc/profile'
		sh 'singularity pull docker://cmdv/test-runner-env:latest'
            }
        }		
        stage('Test') {
            steps {
                echo "Running 'Test' stage..."
                sh 'source /etc/profile'
                sh 'source init.sh'
		sh "singularity exec -B $env.pwd():/CMDV/CMDV-Testing --pwd /CMDV/CMDV-Testing test-runner-env-latest.simg ./run_ctest.sh"
            }
        }
    }
}
