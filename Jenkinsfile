
pipeline {
    agent any
    options { timestamps() }
    // Build triggert bij elke push (via je bestaande webhook)
    triggers { githubPush() }

    environment {
        DOTNET_CLI_TELEMETRY_OPTOUT = '1'
        CONFIGURATION = 'Release'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/MaxR06/ITM-571733.git'
            }
        }

        stage('Restore') {
            steps {
                // Herstel NuGet-packages voor je frontend-project
                bat 'dotnet restore frontend\\frontend.csproj'
            }
        }

        stage('Build') {
            steps {
                // Bouw de frontend (gericht op het csproj i.p.v. de .slnx)
                bat 'dotnet build frontend\\frontend.csproj -c %CONFIGURATION% --no-restore'
            }
        }

        stage('Publish') {
            steps {
                // Publiceer een deployable output (handig als artefact/bewijs)
                bat 'dotnet publish frontend\\frontend.csproj -c %CONFIGURATION% -o publish --no-build'
            }
        }

        // (Optioneel) Als je tests hebt, kun je hier dotnet test aanzetten.
        // Voor nu houden we een duidelijke melding i.p.v. een lege placeholder.
        stage('Test') {
            steps {
                echo 'Geen testproject(en) gevonden of niet geconfigureerd — stap overgeslagen.'
                // Voorbeeld als je later tests toevoegt:
                // bat 'dotnet test tests\\Frontend.Tests\\Frontend.Tests.csproj -c %CONFIGURATION% --no-build'
            }
        }

        stage('Security: NuGet vulnerability audit') {
            steps {
                // .NET 6–9: 'dotnet list package'; in .NET 10 kan ook 'dotnet package list'
                // We falen de build zodra kwetsbare (ook transitieve) packages worden gevonden.
                bat '''
                  dotnet list frontend\\frontend.csproj package --vulnerable --include-transitive > nuget-audit.txt
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
                // Bewijsartefact + de gepubliceerde frontend
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
