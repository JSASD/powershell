## Reprocess-SingleUser.ps1
## JSASD Technology Department
## Reprocesses licenses for multiple users from a CSV
## CSV file must contain one column, one UPN per row

# Ensure Microsoft.Graph module is installed
if (-not (Get-Module -Name Microsoft.Graph.Users.Actions -ListAvailable)) {
    Write-Host "Installing Microsoft.Graph.Users.Actions module..." -ForegroundColor Yellow
    Install-Module -Name Microsoft.Graph.Users.Actions -Scope CurrentUser -Force
}

# Import the module
Import-Module Microsoft.Graph.Users.Actions

# Connect to Microsoft Graph
Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Function to reprocess license assignments for a user
function Reprocess-LicenseAssignment {
    param (
        [Parameter(Mandatory = $true)]
        [string]$UserPrincipalName
    )

    try {
        # Retrieve the user's object ID using UPN
        Write-Host "Fetching user object ID for $UserPrincipalName..." -ForegroundColor Cyan
        $user = Get-MgUser -Filter "userPrincipalName eq '$UserPrincipalName'"
        if (-not $user) {
            Write-Host "User not found: $UserPrincipalName" -ForegroundColor Red
            return
        }

        $userId = $user.Id

        # Reprocess the license assignment
        Write-Host "Reprocessing license assignments for $UserPrincipalName..." -ForegroundColor Cyan
        Invoke-MgLicenseUser -UserId $userId

        Write-Host "License reprocessing triggered successfully for $UserPrincipalName." -ForegroundColor Green
    } catch {
        Write-Host "An error occurred while processing $UserPrincipalName : $_" -ForegroundColor Red
    }
}

# Read UPNs from CSV file
$csvFilePath = Read-Host "Enter the full path to the CSV file containing UPNs"
if (-not (Test-Path $csvFilePath)) {
    Write-Host "The file '$csvFilePath' does not exist. Exiting." -ForegroundColor Red
    return
}

# Process each UPN in the CSV file
Write-Host "Processing users from $csvFilePath..." -ForegroundColor Cyan
$upns = Get-Content $csvFilePath
foreach ($upn in $upns) {
    if (-not [string]::IsNullOrWhiteSpace($upn)) {
        Reprocess-LicenseAssignment -UserPrincipalName $upn.Trim()
    } else {
        Write-Host "Skipping empty or whitespace row." -ForegroundColor Yellow
    }
}

# Disconnect from Microsoft Graph
Disconnect-MgGraph
Write-Host "All users processed. Disconnected from Microsoft Graph." -ForegroundColor Green
