# Define community string
$community = "public"  # Replace with your community string

# Read IPs and OIDs from files
$ips = Get-Content "$PSScriptRoot\ipAddresses.txt"
$oids = Get-Content "$PSScriptRoot\oids.txt"


# Write Information
Write-Host "==================== SNMP Data ===================="

foreach ($ip in $ips) {
    Write-Host "`nIP: $ip"
    Write-Host "-------------------------------------------------"

    foreach ($oid in $oids) {
        # Run Get-SnmpData
        $snmpResult = Get-SnmpData -IP $ip -Community $community -OID $oid | Select-Object -ExpandProperty Data

        # Output result
        Write-Host "OID: $oid -> Data: $snmpResult"
    }
}

Write-Host "`n=================== End of Data ==================="