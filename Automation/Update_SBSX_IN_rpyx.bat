@echo off
REM Change the path below to the path of your Python executable
set PYTHON_EXE="D:\Temp\PythonExcel\DOORS_API\venv\Scripts\python.exe"

REM Specify the Python script to run
set SCRIPT_NAME="Update_SBSX_IN_rpyx.py"

REM Run the Python script using the specified Python executable
%PYTHON_EXE% %SCRIPT_NAME%

pause