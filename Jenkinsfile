
pipeline {
    agent any
    options { timestamps() }
    triggers { githubPush() }

    environment {
        DOTNET = 'C:\\Program Files\\dotnet\\dotnet.exe'
        CONFIGURATION = 'Release'
        DOTNET_CLI_TELEMETRY_OPTOUT = '1'
        PATH = "${env.PATH};C:\\Program Files\\dotnet"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/MaxR06/ITM-571733.git'
            }
        }

        // --- tijdelijke diagnose, daarna kun je deze stage weghalen ---
        stage('Verify tooling') {
            steps {
                bat 'where dotnet || echo dotnet not found on PATH'
                bat '"%DOTNET%" --info'
            }
        }

        stage('Build') {
            steps {
                bat '"%DOTNET%" restore frontend\\frontend.csproj'
                bat '"%DOTNET%" build   frontend\\frontend.csproj -c %CONFIGURATION% --no-restore'
                bat '"%DOTNET%" publish frontend\\frontend.csproj -c %CONFIGURATION% -o publish --no-build'
            }
        }

        stage('Test') {
            steps {
                echo 'Geen testproject(en) geconfigureerd — stap overgeslagen.'
                // Later:
                // bat '"%DOTNET%" test tests\\Frontend.Tests\\Frontend.Tests.csproj -c %CONFIGURATION% --no-build'
            }
        }

        stage('Security: NuGet vulnerability audit') {
            steps {
                bat '''
                  "%DOTNET%" list frontend\\frontend.csproj package --vulnerable --include-transitive > nuget-audit.txt
                  type nuget-audit.txt
                  powershell -NoProfile -Command ^
                    "$hasVuln = Select-String -Path nuget-audit.txt -Pattern 'has the following vulnerable packages' -Quiet; ^
                     if ($hasVuln) { Write-Host 'Vulnerabilities found -> failing build'; exit 1 } ^
                     else { Write-Host 'No known vulnerable packages' }"
                '''
            }
        }

        stage('Archive') {
            steps {
                writeFile file: 'build-info.txt', text: "Build time: ${new Date()}"
                archiveArtifacts artifacts: 'build-info.txt, publish/**/*', fingerprint: true
            }
        }
    }

    post {
        success { echo 'Pipeline SUCCESS' }
        failure { echo 'Pipeline FAILED' }
        always  { cleanWs() }
    }
}
