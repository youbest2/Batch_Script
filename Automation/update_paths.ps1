# Function to update unit/profile paths in the .rpyx file
function Update-RpyxPaths {
    param (
        [string]$rpyxFile,
        [string]$architectureFolder
    )

    $unitsToUpdate = @(
        "LastModificationTimeUpdaterPlugin", "EEPM_UML_Profile", "RequirementPlugin",
        "10_Functions", "20_Requirements", "30_Analysis", "40_Logical",
        "60_Dynamics", "70_Integration", "80_Test", "EEPM_Testing_Profile",
        "99_Local", "90_Outdated", "98_Guidance"
    )

    $lookupTable = @{}
    foreach ($unitFilename in $unitsToUpdate) {
        $sbsxFile = Get-ChildItem -Path $architectureFolder -Recurse -Filter "$unitFilename.sbsx" -ErrorAction SilentlyContinue
        if ($sbsxFile) {
            $lookupTable[$unitFilename] = $sbsxFile.DirectoryName
            Write-Output "Found $unitFilename.sbsx at: $($lookupTable[$unitFilename])"
        }
    }

    if ($lookupTable.Count -eq 0) {
        Write-Output "Could not locate all required SBSX files within the specified architecture folder."
        return
    }

    try {
        $rpyxContent = Get-Content -Path $rpyxFile -Raw
    } catch {
        Write-Output "Error reading .rpyx file: $_"
        return
    }

    $updatedContent = $rpyxContent

    foreach ($unitFilename in $lookupTable.Keys) {
        $newFullPath = $lookupTable[$unitFilename] -replace '/', '\\'
        $pattern = "<fileName type=`"a`">$unitFilename</fileName>\s*<[^>]+>\s*(.*?)\s*</_persistAs>"

        Write-Output "Searching for pattern: $pattern"
        $match = [regex]::Match($updatedContent, $pattern)

        if ($match.Success) {
            $oldPath = $match.Groups.Value
            Write-Output "Found old path: $oldPath"

            $newPersistAsTag = "<_persistAs type=`"a`">$newFullPath</_persistAs>"
            $oldPersistAsTag = "<_persistAs type=`"a`">$oldPath</_persistAs>"

            Write-Output "Replacing: $oldPersistAsTag"
            Write-Output "With: $newPersistAsTag"
            $updatedContent = $updatedContent -replace [regex]::Escape($oldPersistAsTag), [regex]::Escape($newPersistAsTag)
        } else {
            Write-Output "No match found for $unitFilename"
        }
    }

    try {
        # Remove read-only if needed (be cautious!)
        $fileInfo = Get-Item -Path $rpyxFile
        if ($fileInfo.Attributes -band [System.IO.FileAttributes]::ReadOnly) {
            $fileInfo.Attributes = $fileInfo.Attributes -bxor [System.IO.FileAttributes]::ReadOnly
        }

        Set-Content -Path $rpyxFile -Value $updatedContent -Force
    } catch {
        Write-Output "Error writing to .rpyx file: $_"
        return
    }
}

# Function to browse for a file
function Browse-File {
    Add-Type -AssemblyName System.Windows.Forms
    $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $fileDialog.Filter = "Rhapsody Project Files (*.rpyx)|*.rpyx"
    $fileDialog.Title = "Select Rhapsody Project File"
    if ($fileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $fileDialog.FileName
    } else {
        return $null
    }
}

# Function to browse for a folder
function Browse-Folder {
    Add-Type -AssemblyName System.Windows.Forms
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.Description = "Select 20_Architecture Folder"
    if ($folderDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $folderDialog.SelectedPath
    } else {
        return $null
    }
}

# Main script
$rpyxFilePath = Browse-File
if (-not $rpyxFilePath) {
    Write-Output "No .rpyx file selected."
    exit
}

$architectureFolder = Browse-Folder
if (-not $architectureFolder) {
    Write-Output "No architecture folder selected."
    exit
}

Update-RpyxPaths -rpyxFile $rpyxFilePath -architectureFolder $architectureFolder
Write-Output "Updated paths in $rpyxFilePath"
