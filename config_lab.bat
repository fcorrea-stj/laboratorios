@echo off
:: Verificar si se está ejecutando como administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo por favor, ejecuta este archivo como Administrador.
    pause
    exit /b
)

echo =============================================================
echo APLICANDO BLINDAJE DE SEGURIDAD PARA EL LABORATORIO
echo =============================================================

:: Crear un archivo temporal de registro para inyectar todas las políticas
set "regfile=%temp%\blindaje_lab.reg"

echo Windows Registry Editor Version 5.00 > "%regfile%"
echo. >> "%regfile%"

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome] >> "%regfile%"
echo "ClearBrowsingDataOnExitList"=hex(7):62,00,72,00,6f,00,77,00,73,00,69,00,6e,00,67,00,5f,00,68,00,69,00,73,00,74,00,6f,00,72,00,79,00,00,00,64,00,6f,00,77,00,6e,00,6c,00,6f,00,61,00,64,00,5f,00,68,00,69,00,73,00,74,00,6f,00,72,00,79,00,00,00,63,00,6f,00,6f,00,6b,00,69,00,65,00,73,00,5f,00,61,00,6e,00,64,00,5f,00,6f,00,74,00,68,00,65,00,72,00,5f,00,73,00,69,00,74,00,65,00,5f,00,64,00,61,00,74,00,61,00,00,00,63,00,61,00,63,00,68,00,65,00,64,00,5f,00,69,00,6d,00,61,00,67,00,65,00,73,00,5f,00,61,00,6e,00,64,00,5f,00,66,00,69,00,6c,00,65,00,73,00,00,00,61,00,75,00,74,00,6f,00,66,00,69,00,6c,00,6c,00,00,00,00,00 >> "%regfile%"
echo "ForceEphemeralProfiles"=dword:00000001 >> "%regfile%"
echo "BrowserAddPersonEnabled"=dword:00000000 >> "%regfile%"
echo "RestrictSigninToPattern"="" >> "%regfile%"
echo "BrowserGuestModeEnabled"=dword:00000000 >> "%regfile%"
echo "IncognitoModeAvailability"=dword:00000001 >> "%regfile%"
echo "DownloadRestrictions"=dword:00000002 >> "%regfile%"
echo. >> "%regfile%"

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge] >> "%regfile%"
echo "ForceEphemeralProfiles"=dword:00000001 >> "%regfile%"
echo "ClearBrowsingDataOnExit"=dword:00000001 >> "%regfile%"
echo "ImplicitSignInEnabled"=dword:00000000 >> "%regfile%"
echo "RestrictSigninToPattern"="" >> "%regfile%"
echo "InPrivateModeAvailability"=dword:00000001 >> "%regfile%"
echo "DownloadRestrictions"=dword:00000002 >> "%regfile%"
echo. >> "%regfile%"

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers] >> "%regfile%"
echo "AuthenticodedEnabled"=dword:00000000 >> "%regfile%"
echo "DefaultLevel"=dword:00040000 >> "%regfile%"
echo "PolicyScope"=dword:00000000 >> "%regfile%"
echo "TransparentEnabled"=dword:00000001 >> "%regfile%"
echo. >> "%regfile%"

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{22a84e90-c115-4672-9118-2e008d7454bf}] >> "%regfile%"
echo "Description"="Bloqueo de Instaladores en Perfil de Usuario" >> "%regfile%"
echo "ItemData"="%LocalAppData%\\Programs\\*" >> "%regfile%"
echo "SaferFlags"=dword:00000000 >> "%regfile%"
echo. >> "%regfile%"

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{5a8e0f5b-bfa1-4a4b-8fa4-124b89ff4c2b}] >> "%regfile%"
echo "Description"="Bloqueo de Ejecutables en Carpetas Locales" >> "%regfile%"
echo "ItemData"="%LocalAppData%\\*" >> "%regfile%"
echo "SaferFlags"=dword:00000000 >> "%regfile%"
echo. >> "%regfile%"

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{7c9e0f5b-cfa1-4a4b-8fa4-124b89ff4c2c}] >> "%regfile%"
echo "Description"="Bloqueo de Ejecución en Descargas" >> "%regfile%"
echo "ItemData"="%UserProfile%\\Downloads\\*" >> "%regfile%"
echo "SaferFlags"=dword:00000000 >> "%regfile%"
echo. >> "%regfile%"

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{9d8e0f5b-dfa1-4a4b-8fa4-124b89ff4c2d}] >> "%regfile%"
echo "Description"="Bloqueo de Programas en Pendrives USB" >> "%regfile%"
echo "ItemData"="*:\\*.exe" >> "%regfile%"
echo "SaferFlags"=dword:00000000 >> "%regfile%"
echo. >> "%regfile%"

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{a18e0f5b-bfa1-4a4b-8fa4-124b89ff4c2e}] >> "%regfile%"
echo "Description"="Bloqueo de Instaladores MSI en USB" >> "%regfile%"
echo "ItemData"="*:\\*.msi" >> "%regfile%"
echo "SaferFlags"=dword:00000000 >> "%regfile%"
echo. >> "%regfile%"

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{b28e0f5b-bfa1-4a4b-8fa4-124b89ff4c2f}] >> "%regfile%"
echo "Description"="Bloqueo de Scripts BAT en USB" >> "%regfile%"
echo "ItemData"="*:\\*.bat" >> "%regfile%"
echo "SaferFlags"=dword:00000000 >> "%regfile%"

:: Importar el registro silenciosamente
reg edit /s "%regfile%"
del "%regfile%"
echo [+] Politicas de navegadores y restricciones de instalacion aplicadas.

echo -------------------------------------------------------------
echo CONFIGURANDO CIERRE DE TAPA PARA APAGADO COMPLETADO
echo -------------------------------------------------------------

:: 3 = Apagar (Shut down) al cerrar la tapa
:: Cambiar accion conectado a la corriente (AC)
powercfg /setacvalueindex SCHEME_CURRENT sub_buttons lidaction 3

:: Cambiar accion usando bateria (DC)
powercfg /setdcvalueindex SCHEME_CURRENT sub_buttons lidaction 3

:: Aplicar los cambios de energia de inmediato
powercfg /setactive SCHEME_CURRENT

echo [+] Configuracion de energia guardada. El PC se apagara al cerrar la tapa.
echo =============================================================
echo PROCESO COMPLETADO EXITO. Por favor, reinicia el equipo.
echo =============================================================
pause
exit
