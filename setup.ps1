# setup.ps1 - Configuración personalizada de PowerShell

Write-Host "🔧 Iniciando configuración de PowerShell..." -ForegroundColor Cyan

# 1. Instalar Oh My Posh
Write-Host "`n➡ Instalando Oh My Posh..." -ForegroundColor Yellow
winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements

# 2. Instalar Fastfetch
Write-Host "`n➡ Instalando Fastfetch..." -ForegroundColor Yellow
winget install fastfetch --accept-package-agreements --accept-source-agreements

# 3. Descargar el tema personalizado
$themeUrl = "https://raw.githubusercontent.com/mikasa1709/PowerShell/main/kushal.omp.json"
$themePath = "$HOME\kushal.omp.json"

Write-Host "`n➡ Descargando tema personalizado..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $themeUrl -OutFile $themePath

# 4. Verificar si la fuente Nerd Font ya está instalada
$fontName = "JetBrainsMono Nerd Font"
$fontsPath = "$env:WINDIR\Fonts"
$fontInstalled = Get-ChildItem $fontsPath -Include *.ttf -Recurse | Where-Object { $_.Name -like "*JetBrainsMono*Nerd*.ttf" }

if ($fontInstalled) {
    Write-Host "`n✔ Fuente '$fontName' ya está instalada. Saltando instalación." -ForegroundColor Green
}
else {
    Write-Host "`n➡ Descargando e instalando Nerd Font ($fontName)..." -ForegroundColor Yellow

    $fontZip = "$env:TEMP\JetBrainsMono.zip"
    $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
    $fontFolder = "$env:TEMP\JetBrainsMonoFont"

    Invoke-WebRequest -Uri $fontUrl -OutFile $fontZip
    Expand-Archive -Path $fontZip -DestinationPath $fontFolder -Force

    # Instalar fuentes
    $fonts = Get-ChildItem "$fontFolder" -Include *.ttf -Recurse
    foreach ($font in $fonts) {
        Copy-Item $font.FullName -Destination $fontsPath -Force
    }

    Write-Host "`n✅ Fuente '$fontName' instalada correctamente." -ForegroundColor Green
}

# 5. Crear o editar el perfil de PowerShell
Write-Host "`n➡ Configurando perfil de PowerShell..." -ForegroundColor Yellow

if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$profileContent = @"
oh-my-posh init pwsh --config `"$themePath`" | Invoke-Expression
fastfetch
"@

Set-Content -Path $PROFILE -Value $profileContent

Write-Host "`n✅ Configuración completada."
Write-Host "➡ Abre la configuración de Windows Terminal y cambia la fuente a '$fontName'." -ForegroundColor Yellow
Write-Host "➡ Luego reinicia PowerShell para aplicar los cambios." -ForegroundColor Yellow
