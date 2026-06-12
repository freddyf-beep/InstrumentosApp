@echo off
chcp 65001 > nul
echo =======================================================
echo    SUBIR INSTRUMENTOSAPP A GITHUB PARA COMPILAR IPA
echo =======================================================
echo.
echo Este script te ayudará a subir la aplicación a tu GitHub para
echo que se compile automáticamente el archivo .ipa en macOS.
echo.

:: Verificar que el usuario ingrese la URL
:geturl
set /p REPO_URL="Pega la URL de tu repositorio de GitHub (ej. https://github.com/tu-usuario/InstrumentosApp.git): "
if "%REPO_URL%"=="" (
    echo La URL no puede estar vacía.
    goto geturl
)

echo.
echo Vinculando con el repositorio remoto...
git remote remove origin >nul 2>&1
git remote add origin %REPO_URL%
git branch -M main

echo.
echo Subiendo código a GitHub...
echo (Si es necesario, se abrirá una ventana en tu navegador para que inicies sesión en GitHub)
echo.
git push -u origin main

if %ERRORLEVEL% equ 0 (
    echo.
    echo =======================================================
    echo    ¡SUBIDO CON ÉXITO A GITHUB!
    echo =======================================================
    echo.
    echo Pasos siguientes:
    echo 1. Ve a la pestaña "Actions" en tu repositorio web de GitHub.
    echo 2. Haz clic en el workflow "Build iOS IPA (Unsigned)".
    echo 3. Espera 3 minutos a que se ponga en verde (check ✓).
    echo 4. Haz clic en la compilación y descarga el archivo
    echo    "InstrumentosApp-Unsigned-IPA" al final de la página.
    echo 5. Descomprime ese archivo y pasa el .ipa con Sideloadly.
    echo.
) else (
    echo.
    echo Hubo un error al subir el código. Por favor verifica:
    echo - Que la URL del repositorio sea correcta y exista en tu cuenta.
    echo - Que hayas iniciado sesión correctamente si te lo solicitó Git.
    echo.
)

pause
