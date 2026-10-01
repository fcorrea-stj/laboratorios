# =========================================================================
# 1. BLINDAJE PARA GOOGLE CHROME (EFÍMERO + BLOQUEO DE SITIOS Y DESCARGAS)
# =========================================================================
$ChromePath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
if (!(Test-Path $ChromePath)) { New-Item $ChromePath -Force | Out-Null }

$ChromeCleanList = "browsing_history","download_history","cookies_and_other_site_data","cached_images_and_files","autofill"
New-ItemProperty -Path $ChromePath -Name "ClearBrowsingDataOnExitList" -Value $ChromeCleanList -Type MultiString -Force

New-ItemProperty -Path $ChromePath -Name "ForceEphemeralProfiles" -Value 1 -Type DWord -Force
New-ItemProperty -Path $ChromePath -Name "BrowserAddPersonEnabled" -Value 0 -Type DWord -Force
New-ItemProperty -Path $ChromePath -Name "RestrictSigninToPattern" -Value "" -Type String -Force
New-ItemProperty -Path $ChromePath -Name "BrowserGuestModeEnabled" -Value 0 -Type DWord -Force
New-ItemProperty -Path $ChromePath -Name "IncognitoModeAvailability" -Value 1 -Type DWord -Force
New-ItemProperty -Path $ChromePath -Name "DownloadRestrictions" -Value 1 -Type DWord -Force

# Bloqueo total de extensiones para evitar VPNs
New-ItemProperty -Path $ChromePath -Name "BlockExternalExtensions" -Value 1 -Type DWord -Force
New-ItemProperty -Path $ChromePath -Name "ExtensionInstallBlocklist" -Value @("*") -Type MultiString -Force

# Bloqueo de URL absoluto desde el navegador
$ChromeBlockPath = "$ChromePath\URLBlocklist"
if (!(Test-Path $ChromeBlockPath)) { New-Item $ChromeBlockPath -Force | Out-Null }
New-ItemProperty -Path $ChromeBlockPath -Name "1" -Value "*roblox.com*" -Type String -Force
New-ItemProperty -Path $ChromeBlockPath -Name "2" -Value "*futbol11.com*" -Type String -Force
New-ItemProperty -Path $ChromeBlockPath -Name "3" -Value "*futbol-11.com*" -Type String -Force

# =========================================================================
# 2. BLINDAJE PARA MICROSOFT EDGE (EFÍMERO + BLOQUEO DE SITIOS Y DESCARGAS)
# =========================================================================
$EdgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
if (!(Test-Path $EdgePath)) { New-Item $EdgePath -Force | Out-Null }

New-ItemProperty -Path $EdgePath -Name "ForceEphemeralProfiles" -Value 1 -Type DWord -Force
New-ItemProperty -Path $EdgePath -Name "ClearBrowsingDataOnExit" -Value 1 -Type DWord -Force
New-ItemProperty -Path $EdgePath -Name "ImplicitSignInEnabled" -Value 0 -Type DWord -Force
New-ItemProperty -Path $EdgePath -Name "RestrictSigninToPattern" -Value "" -Type String -Force
New-ItemProperty -Path $EdgePath -Name "InPrivateModeAvailability" -Value 1 -Type DWord -Force
New-ItemProperty -Path $EdgePath -Name "DownloadRestrictions" -Value 1 -Type DWord -Force

# Bloqueo total de extensiones en Edge
New-ItemProperty -Path $EdgePath -Name "ExtensionInstallBlocklist" -Value @("*") -Type MultiString -Force

# Bloqueo de URL en Edge
$EdgeBlockPath = "$EdgePath\URLBlocklist"
if (!(Test-Path $EdgeBlockPath)) { New-Item $EdgeBlockPath -Force | Out-Null }
New-ItemProperty -Path $EdgeBlockPath -Name "1" -Value "*roblox.com*" -Type String -Force
New-ItemProperty -Path $EdgeBlockPath -Name "2" -Value "*futbol11.com*" -Type String -Force
New-ItemProperty -Path $EdgeBlockPath -Name "3" -Value "*futbol-11.com*" -Type String -Force

# =========================================================================
# 3. RESTRICCIÓN DE INSTALACIÓN EN APPDATA, DESCARGAS Y USB (SAFER)
# =========================================================================
$SaferPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
if (!(Test-Path $SaferPath)) { New-Item $SaferPath -Force | Out-Null }

New-ItemProperty -Path $SaferPath -Name "AuthenticodedEnabled" -Value 0 -Type DWord -Force
New-ItemProperty -Path $SaferPath -Name "DefaultLevel" -Value 262144 -Type DWord -Force
New-ItemProperty -Path $SaferPath -Name "PolicyScope" -Value 0 -Type DWord -Force
New-ItemProperty -Path $SaferPath -Name "TransparentEnabled" -Value 1 -Type DWord -Force

$SaferZeroPath = "$SaferPath\0"
if (!(Test-Path $SaferZeroPath)) { New-Item $SaferZeroPath -Force | Out-Null }

$SaferPathsContainer = "$SaferZeroPath\Paths"
if (!(Test-Path $SaferPathsContainer)) { New-Item $SaferPathsContainer -Force | Out-Null }

$Paths = @{
    "{22a84e90-c115-4672-9118-2e008d7454bf}" = @{ Desc="Bloqueo Programs"; Data="%LocalAppData%\Programs\*" }
    "{5a8e0f5b-bfa1-4a4b-8fa4-124b89ff4c2b}" = @{ Desc="Bloqueo Locales";  Data="%LocalAppData%\*" }
    "{7c9e0f5b-cfa1-4a4b-8fa4-124b89ff4c2c}" = @{ Desc="Bloqueo Descargas"; Data="%UserProfile%\Downloads\*" }
    "{9d8e0f5b-dfa1-4a4b-8fa4-124b89ff4c2d}" = @{ Desc="USB EXE";           Data="*:\*.exe" }
    "{a18e0f5b-bfa1-4a4b-8fa4-124b89ff4c2e}" = @{ Desc="USB MSI";           Data="*:\*.msi" }
    "{b28e0f5b-bfa1-4a4b-8fa4-124b89ff4c2f}" = @{ Desc="USB BAT";           Data="*:\*.bat" }
}

foreach ($Key in $Paths.Keys) {
    $SubPath = "$SaferPathsContainer\$Key"
    if (!(Test-Path $SubPath)) { New-Item $SubPath -Force | Out-Null }
    New-ItemProperty -Path $SubPath -Name "Description" -Value $Paths[$Key].Desc -Type String -Force
    New-ItemProperty -Path $SubPath -Name "ItemData" -Value $Paths[$Key].Data -Type String -Force
    New-ItemProperty -Path $SubPath -Name "SaferFlags" -Value 0 -Type DWord -Force
}

# Exclusión para permitir software educativo legítimo
$RutaEscuela = "C:\SoftwareEscuela"
if (!(Test-Path $RutaEscuela)) { New-Item $RutaEscuela -Type Directory -Force | Out-Null }

$EscuelaKey = "{e38e0f5b-bfa1-4a4b-8fa4-124b89ff4c2g}"
$SubPathEscuela = "$SaferPathsContainer\$EscuelaKey"
if (!(Test-Path $SubPathEscuela)) { New-Item $SubPathEscuela -Force | Out-Null }
New-ItemProperty -Path $SubPathEscuela -Name "Description" -Value "Software Autorizado Escuela" -Type String -Force
New-ItemProperty -Path $SubPathEscuela -Name "ItemData" -Value $RutaEscuela -Type String -Force
New-ItemProperty -Path $SubPathEscuela -Name "SaferFlags" -Value 0 -Type DWord -Force
New-ItemProperty -Path $SubPathEscuela -Name "SaferLevel" -Value 49152 -Type DWord -Force

# =========================================================================
# 4. CONFIGURAR APAGADO AL CERRAR LA TAPA
# =========================================================================
powercfg /setacvalueindex SCHEME_CURRENT sub_buttons lidaction 3
powercfg /setdcvalueindex SCHEME_CURRENT sub_buttons lidaction 3
powercfg /setactive SCHEME_CURRENT

# =========================================================================
# 5. BLOQUEO DE ENTRETENIMIENTO EN HOSTS (Normalizado y Ampliado)
# =========================================================================
$HostsPath = "$env:windir\System32\drivers\etc\hosts"

#  CÓDIGO CORREGIDO Y SEGURO (Agrega paréntesis para cerrar la secuencia)
if (Test-Path $HostsPath) {
    # Los paréntesis obligan a leer todo el archivo en la RAM y soltarlo de inmediato
    $Content = (Get-Content $HostsPath)
    $CleanContent = $Content | Where-Object { $_ -notmatch "poki|friv|krunker|minijuegos|twitch|facebook|fb\.com|instagram|tiktok|bet365|1xbet|betano|bwin|coolbet|rojabet|futbollibre|futbol11|sfutbollibre|librefutboltv|pokedoku|haxball|chatgpt|car-soccer|roblox|rbxcdn" }
    
    # Ahora Set-Content puede escribir libremente sin que la secuencia esté bloqueada
    Set-Content -Path $HostsPath -Value $CleanContent -Force
}


$BlockText = @"

# RESTRICCIONES DE ACCESO CONTENIDO NO AUTORIZADO (ESCUELA)
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
127.0.0.1 ://fb.com
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
127.0.0.1 ://futbol11.com
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
127.0.0.1 pokedoku.com
127.0.0.1 ://pokedoku.com
127.0.0.1 haxball.com
127.0.0.1 ://haxball.com
127.0.0.1 chatgpt.com
127.0.0.1 ://chatgpt.com
127.0.0.1 car-soccer.com
127.0.0.1 ://car-soccer.com

# SERVIDORES COMPLEMENTARIOS DE ROBLOX (APLICACIÓN Y NAVEGADOR)
127.0.0.1 roblox.com
127.0.0.1 ://roblox.com
127.0.0.1 rbxcdn.com
127.0.0.1 ://rbxcdn.com
127.0.0.1 ://roblox.com
127.0.0.1 ://roblox.com
"@

Add-Content -Path $HostsPath -Value $BlockText -Force

# =========================================================================
# 6. FORZAR CLOUDFLARE PARA FAMILIAS (ADULTOS Y MALWARE)
# =========================================================================
$Interfaces = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
foreach ($Net in $Interfaces) {
    Set-DnsClientServerAddress -InterfaceIndex $Net.InterfaceIndex -ServerAddresses ("1.1.1.3", "1.0.0.3") -ErrorAction SilentlyContinue
}

# =========================================================================
# 7. LIMPIAR LA CACHÉ DNS DEL SISTEMA OPERATIVO
# =========================================================================
Write-Output "Limpiando la cache DNS de Windows..."
ipconfig /flushdns | Out-Null
Clear-DnsClientCache -ErrorAction SilentlyContinue

# =========================================================================
# 8. DESACTIVAR DNS SOBRE HTTPS (DoH) EN CHROME Y EDGE
# =========================================================================
Write-Output "Desactivando DNS Seguro (DoH) para evitar desvios..."
New-ItemProperty -Path $ChromePath -Name "BuiltInDnsClientEnabled" -Value 1 -Type DWord -Force
New-ItemProperty -Path $EdgePath -Name "BuiltInDnsClientEnabled" -Value 1 -Type DWord -Force
New-ItemProperty -Path $ChromePath -Name "DnsOverHttpsMode" -Value "off" -Type String -Force
New-ItemProperty -Path $EdgePath -Name "DnsOverHttpsMode" -Value "off" -Type String -Force
# =========================================================================
# 9. FORZAR EL CIERRE DE LOS NAVEGRUADORES PARA APLICAR CAMBIOS
# =========================================================================
Write-Output "Cerrando navegadores activos para forzar la recarga de politicas..."
Stop-Process -Name "chrome" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "msedge" -Force -ErrorAction SilentlyContinue
Write-Output "Script ejecutado con exito. El blindaje esta activo."
