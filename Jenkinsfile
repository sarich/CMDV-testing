pipeline {
    agent any
    stages {
        stage('PreTest') {
            steps {
                sh '. /etc/profile'
		sh 'whoami'
		sh 'hostname'
                echo 'Running PreTest...'
		sh 'module spider singularity'
            }
	}
        stage('RunTest') {
            steps {
                sh '. /etc/profile'
                echo "Running 'RunTest' stage..."
                sh 'module load singularity/2.4.2'
                sh 'whoami'
                sh 'ls'
                sh 'pwd'
                sh "singularity exec -B ${env.workspace}:/CMDV/CMDV-testing --pwd /CMDV/CMDV-testing docker://cmdv/test-runner-env:latest ./run_ctest.sh"
            }
        }
    }
}
