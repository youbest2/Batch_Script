@echo off

rem Set the path to the folders.txt file
set folderFile=%cd%\folders.txt

rem Create the root folder as current directory
set rootFolder=%cd%\

rem Read the folders.txt file
for /f "tokens=1-3 delims= " %%a in (%folderFile%) do (
    rem Create the first level folder
    if not exist %rootFolder%%%a md %rootFolder%%%a
    if not exist %rootFolder%%%b md %rootFolder%%%b
    if not exist %rootFolder%%%c md %rootFolder%%%c

    rem Read the next line from the file
    for /f "tokens=1-3 delims= " %%d in (%%b) do (
        rem Create the second level folder
        if not exist %rootFolder%%%b\%%d md %rootFolder%%%b\%%d
        if not exist %rootFolder%%%b\%%e md %rootFolder%%%b\%%e
        if not exist %rootFolder%%%b\%%f md %rootFolder%%%b\%%f

        rem Read the next line from the file
        for /f "tokens=1-3 delims= " %%g in (%%e) do (
            rem Create the third level folder
            if not exist %rootFolder%%%b\%%e\%%g md %rootFolder%%%b\%%e\%%g
            if not exist %rootFolder%%%b\%%e\%%h md %rootFolder%%%b\%%e\%%h
            if not exist %rootFolder%%%b\%%e\%%i md %rootFolder%%%b\%%e\%%i
        )
    )
)

echo Folders created successfully.
pause
REM -----------------------------------------------------------------------------------------------------
REM -----------------------------------------------------------------------------------------------------
REM -----------------------------------------------------------------------------------------------------
REM -----------------------------------------------------------------------------------------------------
@echo off
setlocal enabledelayedexpansion

rem Set the path to the folders.txt file
set folderFile=%cd%\folders.txt

rem Create the root folder as current directory
set rootFolder=%cd%\

rem Counter for the number of columns
set column=1

rem Read the folders.txt file
for /f "usebackq delims=" %%a in ("%folderFile%") do (
    rem Set the current folder as the root folder
    set currentFolder=%rootFolder%
    rem iterate through each token in the line
    for /f "tokens=1-* delims= " %%b in ("%%a") do (
        rem Set the current token as folder
        set folder=%%b
        rem Create the folder if it doesn't exist
        if not exist !currentFolder!\!folder! md !currentFolder!\!folder!
        rem Set the current folder as current folder\current folder
        set currentFolder=!currentFolder!\!folder!
    )
)
rem Display a message indicating that the folders were created successfully in the current directory
echo Folders created successfully.
rem Pause the command prompt so that you can see the results
pause

