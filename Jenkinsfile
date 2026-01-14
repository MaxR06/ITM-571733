pipeline {
  agent any
  // Laat Jenkins automatisch bouwen bij een GitHub push
  triggers { githubPush() }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Frontend') {
      steps {
        // Bouwt jouw csproj op het juiste pad te zeten
        dir('frontend/EasyDevOps571733') {
          bat 'dotnet --version'
          bat 'dotnet restore "EasyDevOps571733.csproj"'
          bat 'dotnet build "EasyDevOps571733.csproj" -c Release --no-restore'
        }
      }
    }

    stage('Security Test (Snyk)') {
      steps {
        // Bind het Snyk API-token uit Jenkins Credentials (ID: snyk-token) aan env-var SNYK_TOKEN
        withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
          // Scan de frontend-root; Snyk detecteert zelf alle projecten (--all-projects)
          dir('frontend') {
            bat 'set "SNYK_TOKEN=%SNYK_TOKEN%" && "C:\\tools\\snyk\\snyk.exe" test --all-projects --org=maxr06'
          }
        }
      }
    }
  }
}
