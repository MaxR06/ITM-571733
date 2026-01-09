pipeline {
    agent any
    options { timestamps() }
    // Trigger build bij elke push via je GitHub webhook
    triggers { githubPush() }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/MaxR06/ITM-571733.git'
            }
        }
        stage('Build') {
            steps {
                echo 'Build placeholder'
            }
        }
        stage('Test') {
            steps {
                echo 'Tests placeholder'
            }
        }
        stage('Archive') {
            steps {
                writeFile file: 'build-info.txt', text: "Build time: ${new Date()}"
                archiveArtifacts artifacts: 'build-info.txt', fingerprint: true
            }
        }
    }
    post {
        success { echo 'Pipeline SUCCESS' }
        failure { echo 'Pipeline FAILED' }
    }
}
