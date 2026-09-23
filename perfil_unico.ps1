# 1. BLINDAJE PARA GOOGLE CHROME (PERFIL ÚNICO QUE BORRA AL SALIR)
$ChromePath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
if (!(Test-Path $ChromePath)) { New-Item $ChromePath -Force | Out-Null }
Set-ItemProperty -Path $ChromePath -Name "ClearBrowsingDataOnExitList" -Value ([string[]]("browsing_history","download_history","cookies_and_other_site_data","cached_images_and_files","autofill")) -Type MultiString
Set-ItemProperty -Path $ChromePath -Name "BrowserAddPersonEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path $ChromePath -Name "RestrictSigninToPattern" -Value "" -Type String
Set-ItemProperty -Path $ChromePath -Name "BrowserGuestModeEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path $ChromePath -Name "IncognitoModeAvailability" -Value 1 -Type DWord
Set-ItemProperty -Path $ChromePath -Name "DownloadRestrictions" -Value 2 -Type DWord

# 2. BLINDAJE PARA MICROSOFT EDGE (PERFIL ÚNICO QUE BORRA AL SALIR)
$EdgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
if (!(Test-Path $EdgePath)) { New-Item $EdgePath -Force | Out-Null }
Set-ItemProperty -Path $EdgePath -Name "ClearBrowsingDataOnExit" -Value 1 -Type DWord
Set-ItemProperty -Path $EdgePath -Name "ImplicitSignInEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path $EdgePath -Name "RestrictSigninToPattern" -Value "" -Type String
Set-ItemProperty -Path $EdgePath -Name "InPrivateModeAvailability" -Value 1 -Type DWord
Set-ItemProperty -Path $EdgePath -Name "DownloadRestrictions" -Value 2 -Type DWord

# 3. RESTRICCIÓN DE INSTALACIÓN EN APPDATA Y DESCARGAS (SAFER)
$SaferPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
Set-ItemProperty -Path $SaferPath -Name "AuthenticodedEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path $SaferPath -Name "DefaultLevel" -Value 262144 -Type DWord
Set-ItemProperty -Path $SaferPath -Name "PolicyScope" -Value 0 -Type DWord
Set-ItemProperty -Path $SaferPath -Name "TransparentEnabled" -Value 1 -Type DWord

# Reglas de ruta (Excluye las de los puertos USB)
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

Write-Host "[+] Configuracion de Perfil Unico y restricciones aplicada con exito." -ForegroundColor Green
