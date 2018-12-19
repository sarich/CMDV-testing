pipeline {
    agent {label 'lcrc || sarich-X1'}
    stages {
        stage('printNode') {
            steps {
                echo $(env.NODE_NAME)
            }
        }
        stage('PreTest') {
            steps {
	        script {
	          if ($(env.NODE_NAME.equals('jenkins-0001.lcrc.anl.gov')) {
                    echo 'Running PreTest...'
                    . /etc/profile
                    whoami
                    hostname
                    module spider singularity
		  } else if ($(env.NODE_NAME.equals('jenkins_worker')) {
		      echo 'Running PreTest...'
		      whoami
		      hostname
                  }
                }
            }
	}
        stage('RunTest') {
            steps {
	        script {
		    if ($(env.NODE_NAME.equals('jenkins-0001.lcrc.anl.gov')) {
		      echo "Running 'RunTest' stage..."
                      . /etc/profile
                      module load singularity/2.4.2
                      whoami
                      ls
                      pwd
                      singularity exec -B ${env.workspace}:/CMDV/CMDV-testing --pwd /CMDV/CMDV-testing docker://cmdv/test-runner-env:latest ./run_ctest.sh
                    } else if ($(env.NODE_NAME.equals('jenkins_worker')) {
		      echo "Running 'RunTest' stage..."
                      singularity exec -B ${env.workspace}:/CMDV/CMDV-testing --pwd /CMDV/CMDV-testing docker://cmdv/test-runner-env:latest ./run_ctest.sh
                    }	      
                }
            }
        }
    }
}
