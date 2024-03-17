@echo off
Title Actualización de Eset 2.0
color 0A

:: Sección para eliminar archivos antiguos
echo ------------------------------------------------------------
echo Eliminando archivos antiguos...
if exist ".\7z\nod.7z" del /Q ".\7z\nod.7z"
if exist ".\sfx\*.exe" del /Q ".\sfx\*.exe"

:: Sección para cambiar de directorio
echo ------------------------------------------------------------
echo Cambiando directorio a "..\7z"...
cd /d ".\7z"

:: Sección para comprimir archivos
echo ------------------------------------------------------------
echo Comprimiendo archivos a "nod.7z"...
7z a -t7z "nod.7z" @source.txt -r -mx0

:: Sección para crear ejecutables
echo ------------------------------------------------------------
echo Creando ejecutables en "..\sfx"...
copy /b "7zsd_All.sfx" + "script.txt" + "nod.7z" "..\sfx\eset_update.exe"
copy /b "7zsd_All.sfx" + "script_m.txt" + "nod.7z" "..\sfx\eset_update_m.exe"

:: Sección para copiar a la carpeta de destino
echo ------------------------------------------------------------
echo Copiando a la carpeta de destino...
xcopy /y /c /f "..\sfx\eset_update.exe" "D:\APLICACIONES\ANTIVIRUS\ESET\Actualizacion\eset_update.exe"

:: Sección de finalización del script
echo ------------------------------------------------------------
echo Proceso completado.
echo Presione una tecla para salir.
pause > NUL
