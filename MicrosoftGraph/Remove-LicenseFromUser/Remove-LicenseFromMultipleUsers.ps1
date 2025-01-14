## Reprocess-SingleUser.ps1
## JSASD Technology Department
## Removes a specific license (by SKU) from multiple users from a CSV
## CSV file must contain one column, one UPN per row

# Ensure Microsoft.Graph module is installed
if (-not (Get-Module -Name Microsoft.Graph -ListAvailable)) {
    Write-Host "Microsoft.Graph module not found. Installing..." -ForegroundColor Yellow
    Install-Module -Name Microsoft.Graph -Scope CurrentUser -Force
}

# Import the Microsoft.Graph module
Import-Module Microsoft.Graph

# Connect to Microsoft Graph
Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Function to remove a license from a specific user
function Remove-LicenseFromUser {
    param (
        [Parameter(Mandatory = $true)]
        [string]$UserPrincipalName,
        [Parameter(Mandatory = $true)]
        [string]$SkuId
    )

    try {
        # Retrieve the user's object ID using UPN
        Write-Host "Retrieving user details for $UserPrincipalName..." -ForegroundColor Cyan
        $user = Get-MgUser -Filter "userPrincipalName eq '$UserPrincipalName'"
        if (-not $user) {
            Write-Host "User not found: $UserPrincipalName" -ForegroundColor Red
            return
        }

        $userId = $user.Id

        # Remove the license using Set-MgUserLicense
        Write-Host "Removing license ($SkuId) from $UserPrincipalName..." -ForegroundColor Cyan
        Set-MgUserLicense -UserId $userId -RemoveLicenses @($SkuId) -AddLicenses @{}

        Write-Host "License successfully removed from $UserPrincipalName." -ForegroundColor Green
    } catch {
        Write-Host "An error occurred for $UserPrincipalName : $_" -ForegroundColor Red
    }
}

# Prompt for CSV file containing UPNs
$csvFilePath = Read-Host "Enter the full path to the CSV file containing UPNs"
if (-not (Test-Path $csvFilePath)) {
    Write-Host "The file '$csvFilePath' does not exist. Exiting." -ForegroundColor Red
    return
}

# Prompt for the SKU ID to remove
$SkuId = Read-Host "Enter the SKU ID of the license to remove"

# Process each UPN in the CSV file
Write-Host "Processing users from $csvFilePath..." -ForegroundColor Cyan
$upns = Get-Content $csvFilePath
foreach ($upn in $upns) {
    if (-not [string]::IsNullOrWhiteSpace($upn)) {
        Remove-LicenseFromUser -UserPrincipalName $upn.Trim() -SkuId $SkuId
    } else {
        Write-Host "Skipping empty or whitespace row." -ForegroundColor Yellow
    }
}

# Disconnect from Microsoft Graph
Disconnect-MgGraph
Write-Host "All users processed. Disconnected from Microsoft Graph." -ForegroundColor Green
