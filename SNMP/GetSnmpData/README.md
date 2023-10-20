# Get-SnmpInformation.ps1
Gathers SNMP information from a list of IP Addresses and OIDs.

# Requirements
PowerShell `SNMP` module:
```powershell
# Install SNMP Module
Install-Module snmp
Import-Module snmp
```

# Usage
 - Change the names of `ipAddresses.txt.example` and `oids.txt.example` to `ipAddresses.txt` and `oids.txt` respectively
 - Fill in the `ipAddresses.txt` file with your list of IP addresses, one per line
 - Fill in in the `oids.txt` file with your list of desired OIDs, one per line
 - Run the script