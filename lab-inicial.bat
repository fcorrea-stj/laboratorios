@echo off
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Por favor, ejecuta este archivo como Administrador.
    pause
    exit /b
)

echo REVERTIENDO CONFIGURACIONES DEL LABORATORIO...

:: Eliminar politicas de Chrome y Edge
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge" /f

:: Eliminar restricciones de software (Safer)
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths" /f

:: Restablecer accion de la tapa a Suspender (Valor por defecto = 1)
powercfg /setacvalueindex SCHEME_CURRENT sub_buttons lidaction 1
powercfg /setdcvalueindex SCHEME_CURRENT sub_buttons lidaction 1
powercfg /setactive SCHEME_CURRENT

echo [+] Sistema restaurado a valores estandar. Reinicia el equipo.
pause
exit
