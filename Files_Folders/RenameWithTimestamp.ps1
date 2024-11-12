param (
    [string]$filePath = $args[0]
)

if (-Not (Test-Path $filePath)) {
    Write-Host "File not found!"
    exit
}

# Get current date and time
$currentDateTime = Get-Date -Format "dd_MM_yy_hh_mm_ss_tt"

# Get file name and extension
$fileName = [System.IO.Path]::GetFileNameWithoutExtension($filePath)
$fileExtension = [System.IO.Path]::GetExtension($filePath)

# Create new file name
$newFileName = "${fileName}_${currentDateTime}${fileExtension}"
$newFilePath = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($filePath), $newFileName)

# Rename the file
Rename-Item -Path $filePath -NewName $newFileName

Write-Host "File renamed to: $newFileName"
