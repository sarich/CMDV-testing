pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
		checkout scm
                echo "Running 'Test' stage..."
                sh 'ls'
		sh 'pwd'
		echo "singularity exec -B ${env.PWD}:/CMDV/CMDV-Testing --pwd /CMDV/CMDV-Testing docker://cmdv/test-runner-env:latest ./run_ctest.sh"
		sh "singularity exec -B ${env.PWD}:/CMDV/CMDV-Testing --pwd /CMDV/CMDV-Testing docker://cmdv/test-runner-env:latest ./run_ctest.sh"
	    
            }
        }
    }
}
