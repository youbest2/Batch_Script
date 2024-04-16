# Define the source directory where the files are currently located
$sourceDir = "C:\Users\Z0145624\Downloads"

# Define the destination directory where the files will be moved to
$destDir = "D:\Temp\Funds"

# Define the file type to look for
$fileType = "*.csv"

# Define a part of the file name to look for
$fileName = "*holdings*"

# Get today's date in the format (20_DEC_24, 30_MAR_24....)
$dateString = Get-Date -Format "dd_MMM_yy"

# Use the Get-ChildItem cmdlet to get all the files in the source directory that match the file type and file name
# The -Recurse parameter is used to include all subdirectories in the search
Get-ChildItem -Path $sourceDir -Filter $fileName$fileType -Recurse | ForEach-Object {

    # Construct the full path of the destination file
    $destFile = Join-Path -Path $destDir -ChildPath $_.Name

    # Check if a file with the same name already exists in the destination directory
    if (Test-Path -Path $destFile) {
        # Get the file extension
        $extension = [IO.Path]::GetExtension($destFile)

        # Remove the extension from the destination file path
        $destFile = [IO.Path]::GetFileNameWithoutExtension($destFile)

        # Add the date to the destination file name
        $destFile = "$destFile`_$dateString$extension"
    }

    # Try to move the file to the destination directory
    try {
        Move-Item -Path $_.FullName -Destination $destFile -ErrorAction Stop
        Write-Output "Successfully moved file: $($_.FullName)"
    }
    # If the move operation fails, print an error message
    catch {
        Write-Output "Failed to move file: $($_.FullName)"
    }
}
