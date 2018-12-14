pipeline {
    agent {
        docker {
            image 'cmdv/test-runner-env:latest' 
            args "-t -v$(workspace):/CMDV/CMDV-testing --workdir /CMDV/CMDV-testing --rm bash"
        }
    }
    stages {
        stage('Test') {
            steps {
                echo "Running 'Test' stage..."
                sh 'source /etc/profile'
                sh 'source init.sh'
                sh 'cd cdash'
                sh 'ctest'
            }
        }
    }
}
