@echo off
REM ============================================
REM Script para ejecutar pruebas JMeter en Windows
REM ============================================

setlocal enabledelayedexpansion

REM Configuración
set SCRIPT_DIR=%~dp0
set PROJECT_DIR=%SCRIPT_DIR%..
set TEST_PLANS_DIR=%PROJECT_DIR%\test-plans
set RESULTS_DIR=%PROJECT_DIR%\results

REM Verificar si JMETER_HOME está configurado
if "%JMETER_HOME%"=="" (
    echo [ERROR] La variable JMETER_HOME no esta configurada.
    echo Por favor, configure JMETER_HOME con la ruta de instalacion de JMeter.
    echo Ejemplo: set JMETER_HOME=C:\apache-jmeter-5.6.3
    exit /b 1
)

REM Verificar si JMeter existe
if not exist "%JMETER_HOME%\bin\jmeter.bat" (
    echo [ERROR] No se encontro jmeter.bat en %JMETER_HOME%\bin
    exit /b 1
)

REM Crear directorio de resultados si no existe
if not exist "%RESULTS_DIR%" mkdir "%RESULTS_DIR%"

REM Obtener el nombre del test plan (por defecto: basic-http-test.jmx)
set TEST_PLAN=%1
if "%TEST_PLAN%"=="" set TEST_PLAN=basic-http-test.jmx

REM Verificar si el test plan existe
if not exist "%TEST_PLANS_DIR%\%TEST_PLAN%" (
    echo [ERROR] No se encontro el test plan: %TEST_PLAN%
    echo Test plans disponibles:
    dir /b "%TEST_PLANS_DIR%\*.jmx"
    exit /b 1
)

REM Generar nombre único para resultados
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set TIMESTAMP=%datetime:~0,8%_%datetime:~8,6%
set RESULT_FILE=%RESULTS_DIR%\results_%TIMESTAMP%.jtl
set REPORT_DIR=%RESULTS_DIR%\report_%TIMESTAMP%

echo ============================================
echo JMeter Test Runner
echo ============================================
echo Test Plan: %TEST_PLAN%
echo Resultados: %RESULT_FILE%
echo Reporte: %REPORT_DIR%
echo ============================================

REM Ejecutar JMeter en modo no-GUI
echo.
echo Ejecutando prueba...
"%JMETER_HOME%\bin\jmeter.bat" -n -t "%TEST_PLANS_DIR%\%TEST_PLAN%" -l "%RESULT_FILE%" -e -o "%REPORT_DIR%"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================
    echo Prueba completada exitosamente!
    echo Reporte HTML disponible en: %REPORT_DIR%
    echo ============================================
) else (
    echo.
    echo [ERROR] La prueba fallo con codigo de error: %ERRORLEVEL%
)

endlocal
