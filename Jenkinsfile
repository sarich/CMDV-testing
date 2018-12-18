pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                echo "Running 'Test' stage..."
		sh '. /etc/profile'
		sh 'module load singularity'
		sh 'whoami'
                sh 'ls'
		sh 'pwd'
		sh "singularity exec -B ${env.workspace}:/CMDV/CMDV-testing --pwd /CMDV/CMDV-testing docker://cmdv/test-runner-env:latest ./run_ctest.sh"
	    
            }
        }
    }
}
