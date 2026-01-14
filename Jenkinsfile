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
        // Ga direct naar de map met je csproj
        dir('frontend/EasyDevOps571733') {
          bat 'dotnet --version'
          bat 'dotnet restore "EasyDevOps571733.csproj"'
          bat 'dotnet build "EasyDevOps571733.csproj" -c Release --no-restore'
        }
      }
    }

    stage('Security Test (Snyk)') {
      steps {
        withCredentials([string(credentialsId: 'snyk-token', variable: 'snyk-token')]) {
          // Scan de frontend-root; Snyk zoekt zelf alle projecten (--all-projects)
          dir('frontend') {
            bat 'set "SNYK_TOKEN=%SNYK_TOKEN%" && "C:\\tools\\snyk\\snyk.exe" test --all-projects --org=maxr06'
          }
        }
      }
    }
  }
}
