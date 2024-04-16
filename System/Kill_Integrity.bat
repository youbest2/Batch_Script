@echo off
for %%X in (IntegrityClient.exe, javaw.exe) do (
    taskkill /F /IM %%X >nul 2>&1
    if errorlevel 1 (
        echo Unable to terminate task %%X. It might not be running.
    ) else (
        echo Task %%X was terminated successfully.
    )
)
timeout /t 3 /nobreak >nul
