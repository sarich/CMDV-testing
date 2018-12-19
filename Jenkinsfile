pipeline {
    agent {label 'lcrc || sarich-X1'}
    stages {
        stage('PreTest') {
            steps {
	        node('lcrc') {
                    echo 'Running PreTest...'
                    sh '''
                    . /etc/profile
                    whoami
                    hostname
                    module spider singularity
                '''
		}
		node('sarich-X1') {
		    echo 'Running PreTest...'
		    sh 'whoami'
		    sh 'hostname'
                }
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
