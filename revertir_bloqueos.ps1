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
Write-Host "[-] Accion al cerrar la tapa restablecida a: Suspender." -ForegroundColor Yellow

Write-Host "=============================================================" -ForegroundColor Green
Write-Host "[+] SISTEMA RESTAURADO CON EXITO. Por favor, reinicie el PC." -ForegroundColor Green
Write-Host "=============================================================" -ForegroundColor Green
