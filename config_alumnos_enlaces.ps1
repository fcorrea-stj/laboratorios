# =========================================================================
# 1. BLINDAJE PARA GOOGLE CHROME (EFÍMERO + BLOQUEO DE SITIOS Y DESCARGAS)
# =========================================================================
$ChromePath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
if (!(Test-Path $ChromePath)) { New-Item $ChromePath -Force | Out-Null }

# REPARADO: Formato nativo y limpio para MultiString en PowerShell sin coerciones erróneas
$ChromeCleanList = "browsing_history","download_history","cookies_and_other_site_data","cached_images_and_files","autofill"
Set-ItemProperty -Path $ChromePath -Name "ClearBrowsingDataOnExitList" -Value $ChromeCleanList -PropertyType MultiString -Force

Set-ItemProperty -Path $ChromePath -Name "ForceEphemeralProfiles" -Value 1 -PropertyType DWord -Force
Set-ItemProperty -Path $ChromePath -Name "BrowserAddPersonEnabled" -Value 0 -PropertyType DWord -Force
Set-ItemProperty -Path $ChromePath -Name "RestrictSigninToPattern" -Value "" -PropertyType String -Force
Set-ItemProperty -Path $ChromePath -Name "BrowserGuestModeEnabled" -Value 0 -PropertyType DWord -Force
Set-ItemProperty -Path $ChromePath -Name "IncognitoModeAvailability" -Value 1 -PropertyType DWord -Force
Set-ItemProperty -Path $ChromePath -Name "DownloadRestrictions" -Value 1 -PropertyType DWord -Force

# OPTIMIZACIÓN ESCUELA: Bloqueo total de extensiones para evitar que usen VPNs de la Web Store
Set-ItemProperty -Path $ChromePath -Name "BlockExternalExtensions" -Value 1 -PropertyType DWord -Force
Set-ItemProperty -Path $ChromePath -Name "ExtensionInstallBlocklist" -Value @("*") -PropertyType MultiString -Force

# Bloqueo de URL absoluto desde el navegador
$ChromeBlockPath = "$ChromePath\URLBlocklist"
if (!(Test-Path $ChromeBlockPath)) { New-Item $ChromeBlockPath -Force | Out-Null }
Set-ItemProperty -Path $ChromeBlockPath -Name "1" -Value "*roblox.com*" -PropertyType String -Force
Set-ItemProperty -Path $ChromeBlockPath -Name "2" -Value "*futbol11.com*" -PropertyType String -Force
Set-ItemProperty -Path $ChromeBlockPath -Name "3" -Value "*futbol-11.com*" -PropertyType String -Force

# =========================================================================
# 2. BLINDAJE PARA MICROSOFT EDGE (EFÍMERO + BLOQUEO DE SITIOS Y DESCARGAS)
# =========================================================================
$EdgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
if (!(Test-Path $EdgePath)) { New-Item $EdgePath -Force | Out-Null }

Set-ItemProperty -Path $EdgePath -Name "ForceEphemeralProfiles" -Value 1 -PropertyType DWord -Force
Set-ItemProperty -Path $EdgePath -Name "ClearBrowsingDataOnExit" -Value 1 -PropertyType DWord -Force
Set-ItemProperty -Path $EdgePath -Name "ImplicitSignInEnabled" -Value 0 -PropertyType DWord -Force
Set-ItemProperty -Path $EdgePath -Name "RestrictSigninToPattern" -Value "" -PropertyType String -Force
Set-ItemProperty -Path $EdgePath -Name "InPrivateModeAvailability" -Value 1 -PropertyType DWord -Force
Set-ItemProperty -Path $EdgePath -Name "DownloadRestrictions" -Value 1 -PropertyType DWord -Force

# OPTIMIZACIÓN ESCUELA: Bloqueo total de extensiones en Edge (Anti-Proxies)
Set-ItemProperty -Path $EdgePath -Name "ExtensionInstallBlocklist" -Value @("*") -PropertyType MultiString -Force

# Bloqueo de URL absoluto en Edge
$EdgeBlockPath = "$EdgePath\URLBlocklist"
if (!(Test-Path $EdgeBlockPath)) { New-Item $EdgeBlockPath -Force | Out-Null }
Set-ItemProperty -Path $EdgeBlockPath -Name "1" -Value "*roblox.com*" -PropertyType String -Force
Set-ItemProperty -Path $EdgeBlockPath -Name "2" -Value "*futbol11.com*" -PropertyType String -Force
Set-ItemProperty -Path $EdgeBlockPath -Name "3" -Value "*futbol-11.com*" -PropertyType String -Force

# =========================================================================
# 3. RESTRICCIÓN DE INSTALACIÓN EN APPDATA, DESCARGAS Y USB (SAFER)
# =========================================================================
$SaferPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
if (!(Test-Path $SaferPath)) { New-Item $SaferPath -Force | Out-Null }

Set-ItemProperty -Path $SaferPath -Name "AuthenticodedEnabled" -Value 0 -PropertyType DWord -Force
Set-ItemProperty -Path $SaferPath -Name "DefaultLevel" -Value 262144 -PropertyType DWord -Force
Set-ItemProperty -Path $SaferPath -Name "PolicyScope" -Value 0 -PropertyType DWord -Force
Set-ItemProperty -Path $SaferPath -Name "TransparentEnabled" -Value 1 -PropertyType DWord -Force

# REPARADO: Se inicializa correctamente la subclave intermedia "0" requerida por Windows
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
    Set-ItemProperty -Path $SubPath -Name "Description" -Value $Paths[$Key].Desc -PropertyType String -Force
    Set-ItemProperty -Path $SubPath -Name "ItemData" -Value $Paths[$Key].Data -PropertyType String -Force
    Set-ItemProperty -Path $SubPath -Name "SaferFlags" -Value 0 -PropertyType DWord -Force
}

# OPTIMIZACIÓN ESCUELA: Exclusión de seguridad para permitir software educativo legítimo de profesores
$RutaEscuela = "C:\SoftwareEscuela"
if (!(Test-Path $RutaEscuela)) { New-Item $RutaEscuela -Type Directory -Force | Out-Null }

$EscuelaKey = "{e38e0f5b-bfa1-4a4b-8fa4-124b89ff4c2g}"
$SubPathEscuela = "$SaferPathsContainer\$EscuelaKey"
if (!(Test-Path $SubPathEscuela)) { New-Item $SubPathEscuela -Force | Out-Null }
Set-ItemProperty -Path $SubPathEscuela -Name "Description" -Value "Software Autorizado Escuela" -PropertyType String -Force
Set-ItemProperty -Path $SubPathEscuela -Name "ItemData" -Value $RutaEscuela -PropertyType String -Force
Set-ItemProperty -Path $SubPathEscuela -Name "SaferFlags" -Value 0 -PropertyType DWord -Force
Set-ItemProperty -Path $SubPathEscuela -Name "SaferLevel" -Value 49152 -PropertyType DWord -Force # 49152 = Permitido (Unrestricted)

# =========================================================================
# 4. CONFIGURAR APAGADO AL CERRAR LA TAPA
# =========================================================================
powercfg /setacvalueindex SCHEME_CURRENT sub_buttons lidaction 3
powercfg /setdcvalueindex SCHEME_CURRENT sub_buttons lidaction 3
powercfg /setactive SCHEME_CURRENT

# =========================================================================
# 5. BLOQUEO DE ENTRETENIMIENTO EN HOSTS (Filtro lógico Corregido)
# =========================================================================
$HostsPath = "$env:windir\System32\drivers\etc\hosts"

if (Test-Path $HostsPath) {
    $Content = Get-Content $HostsPath
    # REPARADO: Evita bucles y duplicaciones masivas. Filtra IPs locales manteniendo el localhost legítimo intacto
    $CleanContent = $Content | Where-Object { $_ -notmatch "127\.0\.0\.1" -or $_ -match "localhost" }
    $CleanContent | Set-Content $HostsPath -Force
}

$BlockText = @"

# RESTRICCIONES DE ACCESO CONTENIDO NO AUTORIZADO
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
127.0.0.1 ://haxball.com
127.0.0.1 ://chatgpt.com
127.0.0.1 car-soccer.com
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
=========================================================================
8. DESACTIVAR DNS SOBRE HTTPS (DoH) EN CHROME Y EDGE
=========================================================================
Write-Output "Desactivando DNS Seguro (DoH) para evitar desvios..."
Set-ItemProperty -Path $ChromePath -Name "BuiltInDnsClientEnabled" -Value 1 -PropertyType DWord -Force
Set-ItemProperty -Path $EdgePath -Name "BuiltInDnsClientEnabled" -Value 1 -PropertyType DWord -Force
Set-ItemProperty -Path $ChromePath -Name "DnsOverHttpsMode" -Value "off" -PropertyType String -Force
Set-ItemProperty -Path $EdgePath -Name "DnsOverHttpsMode" -Value "off" -PropertyType String -Force
=========================================================================
9. FORZAR EL CIERRE DE LOS NAVEGADORES PARA APLICAR CAMBIOS
=========================================================================
Write-Output "Cerrando navegadores activos para forzar la recarga de politicas..."
Stop-Process -Name "chrome" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "msedge" -Force -ErrorAction SilentlyContinue
Write-Output "Script ejecutado con exito. El blindaje esta activo."
