@echo off
echo ========================================
echo Flutter OTT Platform - Mobile Web Server
echo ========================================

REM Add Flutter to PATH
set PATH=%PATH%;C:\Users\RIZWAN\Documents\OTT Platform\flutter\bin

echo.
echo Starting web server for mobile access...
echo.

REM Get computer IP address
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr "IPv4"') do (
    for /f "tokens=1" %%b in ("%%a") do (
        set IP=%%b
        goto :found
    )
)
:found

echo Your OTT Platform will be available at:
echo.
echo http://%IP%:8080
echo.
echo Open this URL in your phone's browser (make sure phone is on same WiFi)
echo.
echo Press Ctrl+C to stop the server
echo.

REM Navigate to web build directory
cd build\web

REM Start Python HTTP server (if Python is installed)
python -m http.server 8080

REM If Python fails, try Node.js (if installed)
if errorlevel 1 (
    echo Python not found, trying Node.js...
    npx http-server -p 8080 -o
)

REM If both fail, show manual instructions
if errorlevel 1 (
    echo.
    echo No web server found. Please:
    echo 1. Install Python from python.org
    echo 2. Or install Node.js from nodejs.org
    echo 3. Then run this script again
    echo.
    echo Alternatively, copy the 'build\web' folder to any web server
)

pause