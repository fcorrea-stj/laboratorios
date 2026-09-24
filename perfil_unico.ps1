# 1. BLINDAJE PARA GOOGLE CHROME (PERFIL ÚNICO FIJO + BLOQUEO DE SITIOS Y DESCARGAS INTELIGENTES)
$ChromePath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
if (!(Test-Path $ChromePath)) { New-Item $ChromePath -Force | Out-Null }
Set-ItemProperty -Path $ChromePath -Name "ClearBrowsingDataOnExitList" -Value ([string[]]("browsing_history","download_history","cookies_and_other_site_data","cached_images_and_files","autofill")) -Type MultiString
Set-ItemProperty -Path $ChromePath -Name "BrowserAddPersonEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path $ChromePath -Name "RestrictSigninToPattern" -Value "" -Type String
Set-ItemProperty -Path $ChromePath -Name "BrowserGuestModeEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path $ChromePath -Name "IncognitoModeAvailability" -Value 1 -Type DWord

# Nivel 1 permite descargas normales pero bloquea archivos peligrosos/maliciosos
Set-ItemProperty -Path $ChromePath -Name "DownloadRestrictions" -Value 1 -Type DWord

# Bloqueo de URL absoluto desde el navegador (Corta Roblox y Fútbol 11 de raíz)
$ChromeBlockPath = "$ChromePath\URLBlocklist"
if (!(Test-Path $ChromeBlockPath)) { New-Item $ChromeBlockPath -Force | Out-Null }
Set-ItemProperty -Path $ChromeBlockPath -Name "1" -Value "*roblox.com*" -Type String
Set-ItemProperty -Path $ChromeBlockPath -Name "2" -Value "*futbol11.com*" -Type String
Set-ItemProperty -Path $ChromeBlockPath -Name "3" -Value "*futbol-11.com*" -Type String


# 2. BLINDAJE PARA MICROSOFT EDGE (PERFIL ÚNICO FIJO + BLOQUEO DE SITIOS Y DESCARGAS INTELIGENTES)
$EdgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
if (!(Test-Path $EdgePath)) { New-Item $EdgePath -Force | Out-Null }
Set-ItemProperty -Path $EdgePath -Name "ClearBrowsingDataOnExit" -Value 1 -Type DWord
Set-ItemProperty -Path $EdgePath -Name "ImplicitSignInEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path $EdgePath -Name "RestrictSigninToPattern" -Value "" -Type String
Set-ItemProperty -Path $EdgePath -Name "InPrivateModeAvailability" -Value 1 -Type DWord

# Nivel 1 para descargas en Edge
Set-ItemProperty -Path $EdgePath -Name "DownloadRestrictions" -Value 1 -Type DWord

# Bloqueo de URL absoluto en Edge
$EdgeBlockPath = "$EdgePath\URLBlocklist"
if (!(Test-Path $EdgeBlockPath)) { New-Item $EdgeBlockPath -Force | Out-Null }
Set-ItemProperty -Path $EdgeBlockPath -Name "1" -Value "*roblox.com*" -Type String
Set-ItemProperty -Path $EdgeBlockPath -Name "2" -Value "*futbol11.com*" -Type String
Set-ItemProperty -Path $EdgeBlockPath -Name "3" -Value "*futbol-11.com*" -Type String


# 3. RESTRICCIÓN DE INSTALACIÓN EN APPDATA Y DESCARGAS (SAFER - EXCLUYE USB)
$SaferPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
Set-ItemProperty -Path $SaferPath -Name "AuthenticodedEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path $SaferPath -Name "DefaultLevel" -Value 262144 -Type DWord
Set-ItemProperty -Path $SaferPath -Name "PolicyScope" -Value 0 -Type DWord
Set-ItemProperty -Path $SaferPath -Name "TransparentEnabled" -Value 1 -Type DWord

# Reglas de ruta locales (Los pendrives quedan libres de restricciones)
$Paths = @{
    "{22a84e90-c115-4672-9118-2e008d7454bf}" = @{ Desc="Bloqueo Programs"; Data="%LocalAppData%\Programs\*" }
    "{5a8e0f5b-bfa1-4a4b-8fa4-124b89ff4c2b}" = @{ Desc="Bloqueo Locales";  Data="%LocalAppData%\*" }
    "{7c9e0f5b-cfa1-4a4b-8fa4-124b89ff4c2c}" = @{ Desc="Bloqueo Descargas"; Data="%UserProfile%\Downloads\*" }
}
foreach ($Key in $Paths.Keys) {
    $SubPath = "$SaferPath\0\Paths\$Key"
    if (!(Test-Path $SubPath)) { New-Item $SubPath -Force | Out-Null }
    Set-ItemProperty -Path $SubPath -Name "Description" -Value $Paths[$Key].Desc -Type String
    Set-ItemProperty -Path $SubPath -Name "ItemData" -Value $Paths[$Key].Data -Type String
    Set-ItemProperty -Path $SubPath -Name "SaferFlags" -Value 0 -Type DWord
}

# 4. CONFIGURAR APAGADO AL CERRAR LA TAPA
powercfg /setacvalueindex SCHEME_CURRENT sub_buttons lidaction 3
powercfg /setdcvalueindex SCHEME_CURRENT sub_buttons lidaction 3
powercfg /setactive SCHEME_CURRENT

Write-Host "[+] Script de Perfil Unico optimizado con descargas equilibradas y bloqueos de raiz." -ForegroundColor Green
