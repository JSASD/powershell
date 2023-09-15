# Set the path where the logs will be saved
$path = "\\js-vessel\Technology\Logging\Server-Logs\System-Logs"

# Set the start date for retrieving events (7 days ago from current date)
$StartDate = (Get-Date).AddDays(-7)

# Get the name of the current computer
$server = $env:COMPUTERNAME

# Retrieve system events from the specified server starting from the specified start date
$events = Get-WinEvent -ComputerName $server -FilterHashtable @{
    LogName='System';
    StartTime=$StartDate
}

# Select specific properties from the retrieved events and export them to a CSV file
$events | Select-Object @{
        Name='Server';
        Expression={$server}
    },
    ID,
    Message,
    Level,
    @{
        Name='EventRecordID';
        Expression={$_.RecordId}
    },
    @{
        Name='Timestamp';
        Expression={$_.TimeCreated}
    } | Export-Csv -Path "$path\$server$(((get-date)).ToString("_yyyy-MM-dd_HH.mm.ss")).csv" -NoTypeInformation