# 1. BLINDAJE PARA GOOGLE CHROME (EFÍMERO + BLOQUEO DE SITIOS Y DESCARGAS INTELIGENTES)
$ChromePath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
if (!(Test-Path $ChromePath)) { New-Item $ChromePath -Force | Out-Null }
Set-ItemProperty -Path $ChromePath -Name "ClearBrowsingDataOnExitList" -Value ([string[]]("browsing_history","download_history","cookies_and_other_site_data","cached_images_and_files","autofill")) -Type MultiString
Set-ItemProperty -Path $ChromePath -Name "ForceEphemeralProfiles" -Value 1 -Type DWord
Set-ItemProperty -Path $ChromePath -Name "BrowserAddPersonEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path $ChromePath -Name "RestrictSigninToPattern" -Value "" -Type String
Set-ItemProperty -Path $ChromePath -Name "BrowserGuestModeEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path $ChromePath -Name "IncognitoModeAvailability" -Value 1 -Type DWord

# Nivel 1 permite descargas normales (PDF, imágenes, etc.) pero bloquea archivos peligrosos/maliciosos
Set-ItemProperty -Path $ChromePath -Name "DownloadRestrictions" -Value 1 -Type DWord

# Bloqueo de URL absoluto desde el navegador (Corta Roblox y Fútbol 11 de raíz)
$ChromeBlockPath = "$ChromePath\URLBlocklist"
if (!(Test-Path $ChromeBlockPath)) { New-Item $ChromeBlockPath -Force | Out-Null }
Set-ItemProperty -Path $ChromeBlockPath -Name "1" -Value "*roblox.com*" -Type String
Set-ItemProperty -Path $ChromeBlockPath -Name "2" -Value "*futbol11.com*" -Type String
Set-ItemProperty -Path $ChromeBlockPath -Name "3" -Value "*futbol-11.com*" -Type String


# 2. BLINDAJE PARA MICROSOFT EDGE (EFÍMERO + BLOQUEO DE SITIOS Y DESCARGAS INTELIGENTES)
$EdgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
if (!(Test-Path $EdgePath)) { New-Item $EdgePath -Force | Out-Null }
Set-ItemProperty -Path $EdgePath -Name "ForceEphemeralProfiles" -Value 1 -Type DWord
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


# 3. RESTRICCIÓN DE INSTALACIÓN EN APPDATA, DESCARGAS Y USB (SAFER)
$SaferPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
Set-ItemProperty -Path $SaferPath -Name "AuthenticodedEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path $SaferPath -Name "DefaultLevel" -Value 262144 -Type DWord
Set-ItemProperty -Path $SaferPath -Name "PolicyScope" -Value 0 -Type DWord
Set-ItemProperty -Path $SaferPath -Name "TransparentEnabled" -Value 1 -Type DWord

$Paths = @{
    "{22a84e90-c115-4672-9118-2e008d7454bf}" = @{ Desc="Bloqueo Programs"; Data="%LocalAppData%\Programs\*" }
    "{5a8e0f5b-bfa1-4a4b-8fa4-124b89ff4c2b}" = @{ Desc="Bloqueo Locales";  Data="%LocalAppData%\*" }
    "{7c9e0f5b-cfa1-4a4b-8fa4-124b89ff4c2c}" = @{ Desc="Bloqueo Descargas"; Data="%UserProfile%\Downloads\*" }
    "{9d8e0f5b-dfa1-4a4b-8fa4-124b89ff4c2d}" = @{ Desc="USB EXE";           Data="*:\*.exe" }
    "{a18e0f5b-bfa1-4a4b-8fa4-124b89ff4c2e}" = @{ Desc="USB MSI";           Data="*:\*.msi" }
    "{b28e0f5b-bfa1-4a4b-8fa4-124b89ff4c2f}" = @{ Desc="USB BAT";           Data="*:\*.bat" }
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


# 5. BLOQUEO DE ENTRETENIMIENTO EN HOSTS
$HostsPath = "$env:windir\System32\drivers\etc\hosts"
if (Test-Path $HostsPath) {
    $Txt = Get-Content $HostsPath
    if ($Txt -match "# RESTRICCIONES DE ACCESO") {
        $Txt | Where-Object { $_ -notmatch "127.0.0.1" -or $_ -like "*localhost*" } | Set-Content $HostsPath -Force
    }
}

$BlockText = @"

# RESTRICCIONES DE ACCESO - LABORATORIO
127.0.0.1 poki.com
127.0.0.1 ://poki.com
127.0.0.1 friv.com
127.0.0.1 ://friv.com
127.0.0.1 krunker.io
127.0.0.1 www.krunker.io
127.0.0.1 minijuegos.com
127.0.0.1 ://minijuegos.com
127.0.0.1 twitch.tv
127.0.0.1 www.twitch.tv
127.0.0.1 facebook.com
127.0.0.1 ://facebook.com
127.0.0.1 fb.com
127.0.0.1 instagram.com
127.0.0.1 ://instagram.com
127.0.0.1 tiktok.com
127.0.0.1 ://tiktok.com
127.0.0.1 bet365.com
127.0.0.1 ://bet365.com
127.0.0.1 1xbet.com
127.0.0.1 ://1xbet.com
127.0.0.1 betano.com
127.0.0.1 ://betano.com
127.0.0.1 bwin.com
127.0.0.1 ://bwin.com
127.0.0.1 coolbet.com
127.0.0.1 ://coolbet.com
127.0.0.1 rojabet.cl
127.0.0.1 www.rojabet.cl
127.0.0.1 futbollibre.net
127.0.0.1 www.futbollibre.net
127.0.0.1 futbollibre.org
127.0.0.1 www.futbollibre.org
127.0.0.1 futbollibre.online
127.0.0.1 www.futbollibre.online
127.0.0.1 futbollibre.wtf
127.0.0.1 www.futbollibre.wtf
127.0.0.1 futbol11.com
127.0.0.1 www.futbol11.com
127.0.0.1 futbol-11.com
127.0.0.1 ://futbol-11.com
127.0.0.1 futbol11.net
127.0.0.1 www.futbol11.net
127.0.0.1 futbol11.org
127.0.0.1 www.futbol11.org
127.0.0.1 sfutbollibre.xyz
127.0.0.1 www.sfutbollibre.xyz
127.0.0.1 librefutboltv.com
127.0.0.1 ://librefutboltv.com
"@

Add-Content -Path $HostsPath -Value $BlockText -Force


# 6. FORZAR CLOUDFLARE PARA FAMILIAS (ADULTOS Y MALWARE)
$Interfaces = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
foreach ($Net in $Interfaces) {
    Set-DnsClientServerAddress -InterfaceIndex $Net.InterfaceIndex -ServerAddresses ("1.1.1.3", "1.0.0.3") -ErrorAction SilentlyContinue
}

Clear-DnsClientCache
Write-Host "[+] Script final actualizado con futbol11.com y descargas equilibradas." -ForegroundColor Green
