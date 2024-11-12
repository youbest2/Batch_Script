@echo off
set PYTHON_EXE="D:\Temp\PythonExcel\DOORS_API\venv\Scripts\python.exe"

echo Step 1: Python executable: %PYTHON_EXE%

if "%~1"=="" (
    echo Step 2: No file was dragged and dropped.
    echo Please enter the name of the Python script you want to run:
    set /p SCRIPT_NAME=
) else (
    set SCRIPT_NAME="%~1"
    echo Step 2: File was dragged and dropped.
    echo Step 2: Script to run: %SCRIPT_NAME%
)

echo Step 3: Final script to run: %SCRIPT_NAME%

if not exist %PYTHON_EXE% (
    echo Step 4: Error - Python executable not found at %PYTHON_EXE%
    pause
    exit /b 1
) else (
    echo Step 4: Python executable found.
)

if not exist %SCRIPT_NAME% (
    echo Step 5: Error - Script file not found at %SCRIPT_NAME%
    pause
    exit /b 1
) else (
    echo Step 5: Script file found.
)

echo Step 6: Running command: %PYTHON_EXE% %SCRIPT_NAME%
%PYTHON_EXE% %SCRIPT_NAME%

echo Step 7: Python script exit code: %ERRORLEVEL%

pause
