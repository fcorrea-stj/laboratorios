# =========================================================================
# 0. VERIFICAR PRIVILEGIOS DE ADMINISTRADOR
# =========================================================================
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Este script requiere ejecutarse como Administrador."
    exit
}

# =========================================================================
# 1. REMOVER BLINDAJE DE GOOGLE CHROME
# =========================================================================
Write-Output "Removiendo politicas de Google Chrome..."
$ChromePath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
if (Test-Path $ChromePath) {
    Remove-Item -Path $ChromePath -Recurse -Force -ErrorAction SilentlyContinue
}

# =========================================================================
# 2. REMOVER BLINDAJE DE MICROSOFT EDGE
# =========================================================================
Write-Output "Removiendo politicas de Microsoft Edge..."
$EdgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
if (Test-Path $EdgePath) {
    Remove-Item -Path $EdgePath -Recurse -Force -ErrorAction SilentlyContinue
}

# =========================================================================
# 3. ELIMINAR RESTRICCIONES SAFER (APPDATA, DESCARGAS, USB)
# =========================================================================
Write-Output "Restaurando politicas de ejecucion SAFER..."
$SaferPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
if (Test-Path $SaferPath) {
    Remove-Item -Path $SaferPath -Recurse -Force -ErrorAction SilentlyContinue
}

# Borrar la carpeta creada para la escuela si asi se desea (Opcional)
$RutaEscuela = "C:\SoftwareEscuela"
if (Test-Path $RutaEscuela) {
    Remove-Item -Path $RutaEscuela -Recurse -Force -ErrorAction SilentlyContinue
}

# =========================================================================
# 4. RESTAURAR ACCION AL CERRAR LA TAPA (POR DEFECTO: SUSPENDER)
# =========================================================================
Write-Output "Restaurando comportamiento de la tapa de la laptop..."
# Valor 1 = Suspender (Valor predeterminado de Windows)
powercfg /setacvalueindex SCHEME_CURRENT sub_buttons lidaction 1
powercfg /setdcvalueindex SCHEME_CURRENT sub_buttons lidaction 1
powercfg /setactive SCHEME_CURRENT

# =========================================================================
# 5. LIMPIAR BLOQUEOS EN ARCHIVO HOSTS
# =========================================================================
Write-Output "Limpiando el archivo hosts de dominios bloqueados..."
$HostsPath = "$env:windir\System32\drivers\etc\hosts"

if (Test-Path $HostsPath) {
    Set-ItemProperty -Path $HostsPath -Name IsReadOnly -Value $false -ErrorAction SilentlyContinue
    
    $OldContent = Get-Content $HostsPath
    # Filtra y elimina cualquier linea que contenga las palabras bloqueadas
    $FilteredContent = $OldContent | Where-Object { 
        $_ -notmatch "poki|friv|krunker|minijuegos|twitch|facebook|fb\.com|instagram|tiktok|bet365|1xbet|betano|bwin|coolbet|rojabet|futbollibre|futbol11|sfutbollibre|librefutboltv|pokedoku|haxball|chatgpt|car-soccer|roblox|rbxcdn" 
    }
    
    $FilteredContent | Set-Content -Path $HostsPath -Encoding UTF8 -Force
}

# =========================================================================
# 6. RESTABLECER DNS A CONFIGURACION AUTOMATICA (DHCP)
# =========================================================================
Write-Output "Restableciendo servidores DNS a modo automatico..."
$Interfaces = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
foreach ($Net in $Interfaces) {
    Set-DnsClientServerAddress -InterfaceIndex $Net.InterfaceIndex -ResetServerAddresses -ErrorAction SilentlyContinue
}

# =========================================================================
# 7. LIMPIAR CACHE DNS
# ========================================================================= 
Write-Output "Limpiando la cache DNS..."
ipconfig /flushdns | Out-Null
Clear-DnsClientCache -ErrorAction SilentlyContinue

# =========================================================================
# 8. REINICIAR NAVEGADORES PARA APLICAR CAMBIOS
# =========================================================================
Write-Output "Cerrando navegadores para aplicar los cambios..."
Stop-Process -Name "chrome" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "msedge" -Force -ErrorAction SilentlyContinue

Write-Output "Todos los cambios han sido revertidos con exito. Sistema desbloqueado."
