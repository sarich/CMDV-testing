pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
		checkout scm
                echo "Running 'Test' stage..."
		sh 'whoami'
                sh 'ls'
		sh 'pwd'
		sh "singularity exec -B ${env.workspace}:/CMDV/CMDV-Testing --pwd /CMDV/CMDV-Testing docker://cmdv/test-runner-env:latest ./run_ctest.sh"
	    
            }
        }
    }
}
