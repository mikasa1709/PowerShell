# setup.ps1 - Configuración completa de PowerShell

Write-Host "🔧 Iniciando configuración de PowerShell..." -ForegroundColor Cyan

# 1. Instalar Oh My Posh
Write-Host "`n➡ Instalando Oh My Posh..." -ForegroundColor Yellow
winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements

# 2. Instalar Fastfetch
Write-Host "`n➡ Instalando Fastfetch..." -ForegroundColor Yellow
winget install fastfetch --accept-package-agreements --accept-source-agreements

# 3. Descargar tu tema personalizado
$themeUrl = "https://raw.githubusercontent.com/mikasa1709/PowerShell/main/bubblesextra.omp.json"
$themePath = "$HOME\bubblesextra.omp.json"

Write-Host "`n➡ Descargando tema personalizado..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $themeUrl -OutFile $themePath

# 4. Instalar JetBrainsMono Nerd Font
Write-Host "`n➡ Descargando e instalando Nerd Font (JetBrainsMono)..." -ForegroundColor Yellow
$fontZip = "$env:TEMP\JetBrainsMono.zip"
$fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
$fontFolder = "$env:TEMP\JetBrainsMonoFont"

Invoke-WebRequest -Uri $fontUrl -OutFile $fontZip
Expand-Archive -Path $fontZip -DestinationPath $fontFolder -Force

# Instalar todas las fuentes .ttf del zip
$fonts = Get-ChildItem "$fontFolder" -Include *.ttf -Recurse
foreach ($font in $fonts) {
    Copy-Item $font.FullName -Destination "$env:WINDIR\Fonts" -Force
}

Write-Host "`n✅ Fuente Nerd Font instalada. Ahora puedes seleccionarla en Windows Terminal." -ForegroundColor Green

# 5. Crear o editar perfil de PowerShell
Write-Host "`n➡ Configurando perfil de PowerShell..." -ForegroundColor Yellow

if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$profileContent = @"
oh-my-posh init pwsh --config `"$themePath`" | Invoke-Expression
fastfetch
"@

Set-Content -Path $PROFILE -Value $profileContent

Write-Host "`n✅ Configuración completada. Cambia la fuente en Windows Terminal a 'JetBrainsMono Nerd Font' y reinicia PowerShell." -ForegroundColor Green
