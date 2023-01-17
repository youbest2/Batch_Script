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
