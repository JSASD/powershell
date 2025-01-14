## Reprocess-SingleUser.ps1
## JSASD Technology Department
## Reprocesses licenses for a single user

# Ensure the Microsoft.Graph module is installed
if (-not (Get-Module -Name Microsoft.Graph.Users.Actions -ListAvailable)) {
    Write-Host "Microsoft.Graph.Users.Actions module not found. Installing..." -ForegroundColor Yellow
    Install-Module -Name Microsoft.Graph.Users.Actions -Scope CurrentUser -Force
}

# Import the Microsoft.Graph module
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
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }
}

# Example usage
# Replace 'user@domain.com' with the user's principal name
$UserPrincipalName = Read-Host "Enter the user's UPN (email)"
Reprocess-LicenseAssignment -UserPrincipalName $UserPrincipalName

# Disconnect from Microsoft Graph
Disconnect-MgGraph
