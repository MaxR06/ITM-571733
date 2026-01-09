
pipeline {
    agent any
    options { timestamps() }
    // Laat Jenkins automatisch bouwen bij elke push via jouw GitHub webhook
    triggers { githubPush() }

    stages {
        stage('Checkout') {
            steps {
                // Extra zichtbaar in log; Jenkins doet SCM-checkout sowieso
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
                // Artefact als bewijs in Jenkins -> Artifacts
                writeFile file: 'build-info.txt', text: "Build uitgevoerd op ${new Date()}"
                archiveArtifacts artifacts: 'build-info.txt', fingerprint: true
            }
        }
    }

    post {
        success { echo '✅ Pipeline geslaagd' }
        failure { echo '❌ Pipeline gefaald' }
    }
}
//gemaakt doormiddel van AI
