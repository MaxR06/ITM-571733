pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Frontend') {
      steps {
        dir('frontend') {
          bat 'dotnet --version'
          bat 'dotnet restore'
          bat 'dotnet build -c Release --no-restore'
        }
      }
    }

    stage('Security Test (Snyk)') {
      steps {
        withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
          dir('frontend') {
            bat 'set "SNYK_TOKEN=%SNYK_TOKEN%" && "C:\\tools\\snyk\\snyk.exe" test --all-projects --org=maxr06'
          }
        }
      }
    }
  }
}
