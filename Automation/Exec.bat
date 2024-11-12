@echo off
REM Change the path below to the path of your Python executable
set PYTHON_EXE="D:\Temp\PythonExcel\DOORS_API\venv\Scripts\python.exe"

REM Ask the user for the Python script to run
echo Please enter the name of the Python script you want to run:
set /p SCRIPT_NAME=

REM Run the Python script using the specified Python executable
%PYTHON_EXE% %SCRIPT_NAME%

pause