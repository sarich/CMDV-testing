pipeline {
    agent any
    stages {
        stage('RunTest') {
            steps {
                echo "Running 'RunTest' stage..."
		sh '. /etc/profile'
		sh 'module load singularity/2.4.2'
		sh 'whoami'
                sh 'ls'
		sh 'pwd'
		sh "singularity exec -B ${env.workspace}:/CMDV/CMDV-testing --pwd /CMDV/CMDV-testing docker://cmdv/test-runner-env:latest ./run_ctest.sh"
	    
            }
        }
    }
}
