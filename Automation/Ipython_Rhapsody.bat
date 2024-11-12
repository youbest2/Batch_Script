@echo off
REM Change the path below to the path of your IPython executable
set IPYTHON_EXE="D:\Temp\PythonExcel\DOORS_API\venv\Scripts\ipython.exe"

REM Specify the Python script to run
set SCRIPT_NAME="Rhapsody.py"

REM Start IPython and run the Python script interactively
%IPYTHON_EXE% -i %SCRIPT_NAME%

pause
