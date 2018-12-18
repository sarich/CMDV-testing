pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                echo "Running 'Test' stage..."
		sh 'whoami'
                sh 'ls'
		sh 'pwd'
		sh "singularity exec -B ${env.workspace}:/CMDV/CMDV-testing --pwd /CMDV/CMDV-testing docker://cmdv/test-runner-env:latest ./run_ctest.sh"
	    
            }
        }
    }
}
