@echo off
setlocal enabledelayedexpansion

:: Prompt user to drag and drop a file
echo Please drag and drop a file onto this window and press Enter.
set /p "filePath=File Path: "

:: Check if a file was dragged and dropped
if "%filePath%"=="" (
    echo No file was provided. Exiting...
    pause
    exit /b
)

:: Check if the file exists
if not exist "!filePath!" (
    echo File not found!
    pause
    exit /b
)

:: Get the current date and time
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value ^| find "="') do set datetime=%%a
set "year=!datetime:~2,2!"
set "month=!datetime:~4,2!"
set "day=!datetime:~6,2!"
set "hour=!datetime:~8,2!"
set "minute=!datetime:~10,2!"
set "second=!datetime:~12,2!"

:: Determine AM/PM
if !hour! lss 12 (
    set "ampm=AM"
) else (
    set "ampm=PM"
    if !hour! gtr 12 (
        set /a hour-=12
    )
)

:: Format the timestamp
set "timestamp=!day!_!month!_!year!_!hour!_!minute!_!second!_!ampm!"

:: Get the file name without extension
for %%f in ("!filePath!") do (
    set "fileName=%%~nf"
    set "extension=%%~xf"
)

:: Create new file name
set "newFileName=!fileName!_!timestamp!!extension!"

:: Rename the file
ren "!filePath!" "!newFileName!"

echo File renamed to: "!newFileName!"
pause
