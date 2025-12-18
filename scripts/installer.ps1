$repoUrl = "https://github.com/MaxR06/ITM-571733.git"
$installDir = "$env:USERPROFILE\ITM546651"
$frontendPath = "$installDir\Frontend\EasyDevOps571733"

#installeer .net als het nog niet is geïnstalleerd
if (-not (Get-Command dotnet)) {
    $dotnetInstaller = "$env:TEMP\dotnet-install.ps1"
    Invoke-WebRequest -Uri "https://dot.net/v1/dotnet-install.ps1" -OutFile $dotnetInstaller
    Powershell -Executionpolicy Bypass -File $dotnetInstaller -Channel 8.0
    $env:PATH += ";$($env:USERPROFILE).dotnet"
    Write-Host ".NET SDK geïnstalleerd."
}
#repo clone
if (-not (Test-Path $installDir)) {
    git clone $repoUrl $installDir
    Write-Host "Repository cloned to $installDir"
}
#run frontend
if (Test-Path $frontendPath) {
    Set-Location $frontendPath
    dotnet restore
    dotnet build
    dotnet run
    Write-Host "Frontend is running..."
}