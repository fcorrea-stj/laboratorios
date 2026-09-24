# 1. ELIMINAR POLÍTICAS DE GOOGLE CHROME
$ChromePath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
if (Test-Path $ChromePath) {
    Remove-Item -Path $ChromePath -Recurse -Force | Out-Null
    Write-Host "[-] Politicas y bloqueos de listas de Google Chrome eliminados." -ForegroundColor Yellow
}

# 2. ELIMINAR POLÍTICAS DE MICROSOFT EDGE
$EdgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
if (Test-Path $EdgePath) {
    Remove-Item -Path $EdgePath -Recurse -Force | Out-Null
    Write-Host "[-] Politicas y bloqueos de listas de Microsoft Edge eliminados." -ForegroundColor Yellow
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

# 5. RECONSTRUIR EL ARCHIVO HOSTS LIMPIO
$HostsPath = "$env:windir\System32\drivers\etc\hosts"
if (Test-Path $HostsPath) {
    $Contenido = Get-Content $HostsPath -Raw
    if ($Contenido -match "# RESTRICCIONES DE ACCESO") {
        $ContenidoLimpio = $Contenido -split "# RESTRICCIONES DE ACCESO"
        Set-Content -Path $HostsPath -Value $ContenidoLimpio.Trim() -Force
        Write-Host "[-] Bloqueos del archivo hosts eliminados por completo." -ForegroundColor Yellow
    }
}

# 6. RESTABLECER SERVIDORES DNS A MODO AUTOMÁTICO (DHCP)
$Interfaces = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
foreach ($Net in $Interfaces) {
    Set-DnsClientServerAddress -InterfaceIndex $Net.InterfaceIndex -ResetServerAddresses -ErrorAction SilentlyContinue
}
Write-Host "[-] Servidores DNS restablecidos a modo automatico (DHCP)." -ForegroundColor Yellow

# Limpiar cache DNS del sistema para aplicar cambios de inmediato
Clear-DnsClientCache

Write-Host "=============================================================" -ForegroundColor Green
Write-Host "[+] SISTEMA RESTAURADO CON EXITO. Por favor, reinicie el PC." -ForegroundColor Green
Write-Host "=============================================================" -ForegroundColor Green
