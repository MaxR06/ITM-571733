
pipeline {
  agent any
  options { timestamps() }
  // Laat staan als je een GitHub webhook gebruikt
  triggers { githubPush() }

  environment {
    DOTNET = 'C:\\Program Files\\dotnet\\dotnet.exe'
    CONFIGURATION = 'Release'
    DOTNET_CLI_TELEMETRY_OPTOUT = '1'
    // Voor de zekerheid dotnet in PATH tijdens de build
    PATH = "${env.PATH};C:\\Program Files\\dotnet"
  }

  stages {
    stage('Checkout') {
      steps {
        // Pas eventueel je repo/branch aan
        git branch: 'main', url: 'https://github.com/MaxR06/ITM-571733.git'
      }
    }

    // Handige korte check; kun je later weghalen
    stage('Verify tooling') {
      steps {
        bat 'where dotnet || echo dotnet not found on PATH'
        bat '"%DOTNET%" --info'
      }
    }

    stage('Build') {
      steps {
        bat '''
          setlocal enabledelayedexpansion

          rem 1) Probeer eerst onder .\\frontend\\ naar een .csproj
          for /f "delims=" %%F in ('dir /s /b frontend\\*.csproj 2^>nul') do set PROJ=%%F

          rem 2) Anders ergens in de repo
          if not defined PROJ for /f "delims=" %%F in ('dir /s /b *.csproj') do set PROJ=%%F

          if not defined PROJ (
            echo ERROR: Geen .csproj gevonden
            exit /b 1
          )

          echo GEVONDEN PROJECT: !PROJ!
          "%DOTNET%" restore "!PROJ!"
          "%DOTNET%" build   "!PROJ!" -c %CONFIGURATION% --no-restore
          "%DOTNET%" publish "!PROJ!" -c %CONFIGURATION% -o publish --no-build
        '''
      }
    }

    stage('Test') {
      steps {
        echo 'Geen testproject(en) geconfigureerd — stap overgeslagen.'
        // Voorbeeld als je later tests toevoegt:
        // bat '"%DOTNET%" test tests\\Frontend.Tests\\Frontend.Tests.csproj -c %CONFIGURATION% --no-build'
      }
    }

    stage('Security: NuGet vulnerability audit') {
      steps {
        bat '''
          setlocal enabledelayedexpansion

          rem Zelfde project-detectie als in Build
          for /f "delims=" %%F in ('dir /s /b frontend\\*.csproj 2^>nul') do set PROJ=%%F
          if not defined PROJ for /f "delims=" %%F in ('dir /s /b *.csproj') do set PROJ=%%F

          if not defined PROJ (
            echo ERROR: Geen .csproj gevonden
            exit /b 1
          )

          echo AUDIT VOOR: !PROJ!
          "%DOTNET%" list "!PROJ!" package --vulnerable --include-transitive > nuget-audit.txt
          type nuget-audit.txt

          rem Faal build als kwetsbaarheden gevonden zijn
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
