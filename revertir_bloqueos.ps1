# =========================================================================
# 0. VERIFICAR PRIVILEGIOS DE ADMINISTRADOR
# =========================================================================
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Este script requiere ejecutarse como Administrador."
    exit
}

Write-Output "Iniciando proceso de desblindaje y restauracion..."

# =========================================================================
# 1. REMOVER POLITICAS DE GOOGLE CHROME Y MICROSOFT EDGE
# =========================================================================
Write-Output "Eliminando directivas de Chrome y Edge..."
$ChromePath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
$EdgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"

if (Test-Path $ChromePath) { Remove-Item -Path $ChromePath -Recurse -Force -ErrorAction SilentlyContinue }
if (Test-Path $EdgePath) { Remove-Item -Path $EdgePath -Recurse -Force -ErrorAction SilentlyContinue }

# =========================================================================
# 2. RESTAURAR RESTRICCIONES SAFER (APPDATA, DESCARGAS, USB)
# =========================================================================
Write-Output "Restaurando politicas de ejecucion (Safer)..."
$SaferPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"

if (Test-Path $SaferPath) {
    Remove-Item -Path $SaferPath -Recurse -Force -ErrorAction SilentlyContinue
}

# =========================================================================
# 3. RESTAURAR ACCION AL CERRAR LA TAPA (POR DEFECTO: SUSPENDER / DO NOTHING)
# =========================================================================
Write-Output "Restaurando la configuracion de energia de la tapa..."
# 1 = Suspender (Valor por defecto estandar de Windows)
powercfg /setacvalueindex SCHEME_CURRENT sub_buttons lidaction 1
powercfg /setdcvalueindex SCHEME_CURRENT sub_buttons lidaction 1
powercfg /setactive SCHEME_CURRENT

# =========================================================================
# 4. LIMPIAR RESTRICCIONES EN EL ARCHIVO HOSTS (DESBLINDAJE)
# =========================================================================
$HostsPath = "$env:windir\System32\drivers\etc\hosts"

if (Test-Path $HostsPath) {
    Set-ItemProperty -Path $HostsPath -Name IsReadOnly -Value $false -ErrorAction SilentlyContinue
    $OldContent = Get-Content $HostsPath
    $CleanContent = $OldContent | Where-Object { 
        $_ -notmatch "poki|friv|krunker|minijuegos|twitch|facebook|fb\.com|instagram|tiktok|bet365|1xbet|betano|bwin|coolbet|rojabet|futbollibre|futbol11|sfutbollibre|librefutboltv|pokedoku|haxball|chatgpt|car-soccer|roblox|rbxcdn" 
    }
    $CleanContent | Set-Content -Path $HostsPath -Encoding UTF8 -Force
}

# =========================================================================
# 5. RESTABLECER DNS A AUTOMATICO (DHCP)
# =========================================================================
Write-Output "Restableciendo la configuracion DNS del adaptador a DHCP..."
$Interfaces = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
foreach ($Net in $Interfaces) {
    Set-DnsClientServerAddress -InterfaceIndex $Net.InterfaceIndex -ResetServerAddresses -ErrorAction SilentlyContinue
}

# =========================================================================
# 6. LIMPIAR CACHE DNS
# =========================================================================
Write-Output "Limpiando la cache DNS de Windows..."
ipconfig /flushdns | Out-Null
Clear-DnsClientCache -ErrorAction SilentlyContinue

# =========================================================================
# 7. REINICIAR NAVEGADORES PARA APLICAR CAMBIOS
# =========================================================================
Write-Output "Cerrando navegadores..."
Stop-Process -Name "chrome" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "msedge" -Force -ErrorAction SilentlyContinue

Write-Output "Proceso completado. El equipo ha sido desblindado con exito."
