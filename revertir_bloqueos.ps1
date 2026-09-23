# 1. ELIMINAR POLÍTICAS DE GOOGLE CHROME
$ChromePath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
if (Test-Path $ChromePath) {
    Remove-Item -Path $ChromePath -Recurse -Force | Out-Null
    Write-Host "[-] Politicas de Google Chrome eliminadas." -ForegroundColor Yellow
}

# 2. ELIMINAR POLÍTICAS DE MICROSOFT EDGE
$EdgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
if (Test-Path $EdgePath) {
    Remove-Item -Path $EdgePath -Recurse -Force | Out-Null
    Write-Host "[-] Politicas de Microsoft Edge eliminadas." -ForegroundColor Yellow
}

# 3. ELIMINAR RESTRICCIONES DE SOFTWARE (SAFER)
$SaferPaths = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths"
if (Test-Path $SaferPaths) {
    Remove-Item -Path $SaferPaths -Recurse -Force | Out-Null
    Write-Host "[-] Restricciones de instalacion (Safer) eliminadas." -ForegroundColor Yellow
}

# 4. RESTABLECER ACCIÓN DE LA TAPA A SUSPENDER (VALOR PREDETERMINADO = 1)
powercfg /setacvalueindex SCHEME_CURRENT sub_buttons lidaction 1
powercfg /setdcvalueindex SCHEME_CURRENT sub_buttons lidaction 1
powercfg /setactive SCHEME_CURRENT
Write-Host "[-] Accion de la tapa restablecida a: Suspender." -ForegroundColor Yellow

# 5. RESTAURAR ARCHIVO HOSTS ORIGINAL (ELIMINAR BLOQUEOS)
$HostsPath = "$env:windir\System32\drivers\etc\hosts"
if (Test-Path $HostsPath) {
    $ContenidoOriginal = Get-Content -Path $HostsPath
    $NuevoContenido = @()
    foreach ($Linea in $ContenidoOriginal) {
        if ($Linea -like "*# RESTRICCIONES DE ACCESO*" -or $Linea -like "*127.0.0.1 roblox*" -or $Linea -like "*127.0.0.1 poki*" -or $Linea -like "*127.0.0.1 friv*" -or $Linea -like "*127.0.0.1 krunker*" -or $Linea -like "*127.0.0.1 minijuegos*" -or $Linea -like "*127.0.0.1 twitch*" -or $Linea -like "*127.0.0.1 facebook*" -or $Linea -like "*127.0.0.1 instagram*" -or $Linea -like "*127.0.0.1 tiktok*" -or $Linea -like "*127.0.0.1 bet365*" -or $Linea -like "*127.0.0.1 1xbet*" -or $Linea -like "*127.0.0.1 betano*" -or $Linea -like "*127.0.0.1 bwin*" -or $Linea -like "*127.0.0.1 coolbet*" -or $Linea -like "*127.0.0.1 rojabet*" -or $Linea -like "*127.0.0.1 futbollibre*" -or $Linea -like "*127.0.0.1 futbol11*" -or $Linea -like "*127.0.0.1 sfutbollibre*" -or $Linea -like "*127.0.0.1 librefutboltv*") {
            continue
        }
        $NuevoContenido += $Linea
    }
    Set-Content -Path $HostsPath -Value $NuevoContenido -Force
    Write-Host "[-] Bloqueos del archivo hosts eliminados." -ForegroundColor Yellow
}

# 6. RESTABLECER DNS A AUTOMÁTICO (DHCP DE LA ESCUELA)
$Interfaces = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
foreach ($Net en $Interfaces) {
    Set-DnsClientServerAddress -InterfaceIndex $Net.InterfaceIndex -ResetServerAddresses -ErrorAction SilentlyContinue
}
Write-Host "[-] Servidores DNS restablecidos a modo automatico." -ForegroundColor Yellow

Clear-DnsClientCache
Write-Host "=============================================================" -ForegroundColor Green
Write-Host "[+] SISTEMA RESTAURADO CON EXITO. Por favor, reinicie el PC." -ForegroundColor Green
Write-Host "=============================================================" -ForegroundColor Green
