@echo off
:: Check for admin rights
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    msg * The installation script must be run as Administrator!
    pause
    exit /b 1
)

setlocal

:: Direct PsPing download URL from Sysinternals Live
set "URL=https://live.sysinternals.com/files/psping.zip"

echo Downloading PsPing from: %URL%
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%temp%\psping.zip' -UseBasicParsing"

if not exist "%temp%\psping.zip" (
    echo ERROR: Download failed.
    pause
    exit /b 1
)

:: Install folder in Program Files
set "DEST=%ProgramFiles%\PsPing"

echo Creating folder: %DEST%
powershell -Command "if (-not (Test-Path '%DEST%')) { New-Item -Path '%DEST%' -ItemType Directory }"

echo Extracting PsPing...
powershell -Command "Expand-Archive -Path '%temp%\psping.zip' -DestinationPath '%DEST%' -Force"

:: Add to PATH for current user
echo Adding PsPing folder to PATH for current user...
setx PATH "%DEST%;%PATH%"

echo Installation complete.  
echo Open a new Command Prompt and run 'psping /?' to test.
pause
