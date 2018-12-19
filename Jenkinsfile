pipeline {
    agent {label 'lcrc'}
    stages {
        stage('PreTest') {
            steps {
                echo 'Running PreTest...'
                sh '''
                . /etc/profile
		whoami
		hostname
		module spider singularity
                '''
            }
	}
        stage('RunTest') {
            steps {
	        node('lcrc') {
		    echo "Running 'RunTest' stage..."
                    sh """
                    . /etc/profile
                    module load singularity/2.4.2
                    whoami
                    ls
                    pwd
                    singularity exec -B ${env.workspace}:/CMDV/CMDV-testing --pwd /CMDV/CMDV-testing docker://cmdv/test-runner-env:latest ./run_ctest.sh
                    """
                }
		node('sarich-X1') {
		    echo "Running 'RunTest' stage..."
                    sh "singularity exec -B ${env.workspace}:/CMDV/CMDV-testing --pwd /CMDV/CMDV-testing docker://cmdv/test-runner-env:latest ./run_ctest.sh"
                }
            }
        }
    }
}
