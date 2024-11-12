@echo off
echo Restarting Windows Explorer...
taskkill /f /im explorer.exe
timeout /t 2 /nobreak > nul
start explorer.exe
echo Windows Explorer has been restarted.
pause