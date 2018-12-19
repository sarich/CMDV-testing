pipeline {
    agent {label 'lcrc || sarich-X1'}
    stages {
        stage('printNode') {
            steps {
                echo env.NODE_NAME
            }
        }
        stage('PreTest') {
            steps {
	        script {
	          if (env.NODE_NAME == 'jenkins-0001.lcrc.anl.gov') {
                    sh """echo 'Running PreTest...'
                    . /etc/profile
                    whoami
                    hostname
                    module spider singularity"""
		  } else if (env.NODE_NAME == 'jenkins_worker') {
		      echo 'Running PreTest...'
		      sh "whoami"
		      sh "hostname"
                  }
                }
            }
	}
        stage('RunTest') {
            steps {
	        script {
		    if (env.NODE_NAME == 'jenkins-0001.lcrc.anl.gov') {
                      sh """
		      echo "Running 'RunTest' stage..."
                      . /etc/profile
                      module load singularity/2.4.2
                      whoami
                      ls
                      pwd
                      singularity exec -B ${env.workspace}:/CMDV/CMDV-testing --pwd /CMDV/CMDV-testing docker://cmdv/test-runner-env:latest ./run_ctest.sh"""
                    } else if (env.NODE_NAME == 'jenkins_worker') {
		      echo "Running 'RunTest' stage..."
                      sh "singularity exec -B ${env.workspace}:/CMDV/CMDV-testing --pwd /CMDV/CMDV-testing docker://cmdv/test-runner-env:latest ./run_ctest.sh"
                    }	      
                }
            }
        }
    }
    post {
        always{
            archiveArtifacts 'cdash/Testing/Temporary/LastTest.log'
	    deleteDir()
        }        
    }
	    
}
