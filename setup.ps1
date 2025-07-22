# setup.ps1 - Configuración de PowerShell personalizada

Write-Host "🔧 Iniciando configuración de PowerShell..." -ForegroundColor Cyan

# 1. Instalar Oh My Posh
Write-Host "`n➡ Instalando Oh My Posh..." -ForegroundColor Yellow
winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements

# 2. Instalar Fastfetch
Write-Host "`n➡ Instalando Fastfetch..." -ForegroundColor Yellow
winget install fastfetch --accept-package-agreements --accept-source-agreements

# 3. Descargar tu tema desde GitHub
$themeUrl = "https://raw.githubusercontent.com/mikasa1709/PowerShell/main/bubblesextra.omp.json"
$themePath = "$HOME\bubblesextra.omp.json"

Write-Host "`n➡ Descargando tema personalizado..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $themeUrl -OutFile $themePath

# 4. Crear o editar perfil de PowerShell
Write-Host "`n➡ Configurando perfil de PowerShell..." -ForegroundColor Yellow
if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$profileContent = @"
oh-my-posh init pwsh --config `"$themePath`" | Invoke-Expression
fastfetch
"@

Set-Content -Path $PROFILE -Value $profileContent

Write-Host "`n✅ Configuración completada. Reinicia PowerShell para aplicar los cambios." -ForegroundColor Green
