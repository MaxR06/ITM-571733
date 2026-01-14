pipeline {
    agent any
    options { timestamps() }
    // Build triggert bij elke push (je webhook blijft werken)
    triggers { githubPush() }

    environment {
        // Primair pad naar dotnet
        DOTNET = 'C:\\Program Files\\dotnet\\dotnet.exe'
        CONFIGURATION = 'Release'
        DOTNET_CLI_TELEMETRY_OPTOUT = '1'
        // Voeg dotnet voor de zekerheid aan PATH toe in deze build
        PATH = "${env.PATH};C:\\Program Files\\dotnet"
    }

    stages {
        stage('Checkout') {
            steps {
                // Je gebruikte aanpak behouden
                git branch: 'main', url: 'https://github.com/MaxR06/ITM-571733.git'
            }
        }

        stage('Verify tooling') {
            steps {
                // Helpt meteen zien of Jenkins dotnet ziet (scheelt zoeken)
                bat 'where dotnet || echo dotnet not found on PATH'
                bat '"%DOTNET%" --info'
            }
        }

        stage('Build') {
            steps {
                // Restore + Build + Publish van je frontend (week 3)
                bat '"%DOTNET%" restore frontend\\frontend.csproj'
                bat '"%DOTNET%" build frontend\\frontend.csproj -c %CONFIGURATION% --no-restore'
                bat '"%DOTNET%" publish frontend\\frontend.csproj -c %CONFIGURATION% -o publish --no-build'
            }
        }

        stage('Test') {
            steps {
                // Laat zo; als je later tests toevoegt, kun je dotnet test hier plaatsen
                echo 'Geen testproject(en) geconfigureerd — stap overgeslagen.'
                // Voorbeeld:
                // bat '"%DOTNET%" test tests\\Frontend.Tests\\Frontend.Tests.csproj -c %CONFIGURATION% --no-build'
            }
        }

        stage('Security: NuGet vulnerability audit') {
            steps {
                // Officiële .NET CLI audit; build faalt als er kwetsbaarheden zijn
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
                // Bewijs + deployable output
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
