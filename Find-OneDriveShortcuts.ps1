# Get Folders in OneDrive
$OneDriveDirs = Get-ChildItem $env:OneDrive -Recurse -Directory

# Array of icon indexes
$icon_set_one = @(4,7)
# Range for the new folder colors that are not as common to see
$icon_set_two = @(38..67)




$regex = "(OneDrive.exe,)(?<index>\d)"

function Get-IconIndex {
  param (
    [string]$Path,
    [array]$IconIndexSet
  )
    
    $content = Get-Content $path -ErrorAction SilentlyContinue
    
    foreach ($index in $IconIndexSet) {
        if ($content -match "IconIndex=$index"){
            return $true
        }
    }


  
}


<# # Checks each folder's icon to find OneDrive Shortcuts
$OneDriveLinks = foreach ($folder in $OneDriveDirs) {
  if (Test-Path $folder\desktop.ini) {
    if ((Get-Content $folder\desktop.ini -Force) -match 'IconResource=.*OneDrive.exe,7') {
      $folder
    }
  }
}
$OneDriveLinks.FullName #>


<# # Function to check if the folder is a OneDrive shortcut
function IsOneDriveShortcut {
    param (
        [string]$FolderPath
    )

    # Check for the presence of a specific attribute or file that indicates a OneDrive shortcut
    $attribute = (Get-ItemProperty -Path $FolderPath).Attributes
    if ($attribute -match "ReparsePoint") {
        return $true
    }
    return $false
}

# Function to get the sync status from OneDrive logs
function Get-OneDriveSyncStatus {
    param (
        [string]$FolderPath
    )

    # Define the path to the OneDrive sync client logs
    $logPath = "$env:LOCALAPPDATA\Microsoft\OneDrive\logs\Business1"

    # Read the latest log file
    $latestLog = Get-ChildItem -Path $logPath -Filter "*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

    # Check the sync status in the log file
    $logContent = Get-Content -Path $latestLog.FullName
    $syncStatus = $logContent | Select-String -Pattern "Sync status"

    if ($syncStatus) {
        return $syncStatus
    } else {
        return "No sync status found in the log."
    }
}

# Check if the folder is a OneDrive shortcut
$isShortcut = Is-OneDriveShortcut -FolderPath $folderPath
if ($isShortcut) {
    Write-Output "The folder is a OneDrive Shortcut."
} else {
    Write-Output "The folder is not a OneDrive Shortcut."
}

# Get the sync status
$syncStatus = Get-OneDriveSyncStatus -FolderPath $folderPath
Write-Output "The sync status of the folder is: $syncStatus" #>