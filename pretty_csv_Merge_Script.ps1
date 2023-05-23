# Get the start date and end date for the file name
$startDate = (Get-Date).AddDays(-7).ToString("yyyy-MM-dd")
$endDate = (Get-Date).ToString("yyyy-MM-dd")

# Specify the path to the security logs folder
$SecurityLogs = "\\js-vessel\Technology\Logging\Server-Logs\Security-Logs"
$SecurityMaster = "\\js-vessel\Technology\Logging\Server-Logs\Security-Logs\Master"

# Specify the path to the system logs folder
$SystemLogs = "\\js-vessel\Technology\Logging\Server-Logs\System-Logs"
$SystemMaster = "\\js-vessel\Technology\Logging\Server-Logs\System-Logs\Master"

# Function to merge and process logs
function MergeAndProcessLogs($logsPath, $masterPath, $logType)
{
    # Create the file name using the start and end dates
    $fileName = "${startDate}--${endDate}"

    # Get a list of CSV files in the logs folder, excluding the current file
    $CSV = Get-ChildItem $logsPath\*.csv -Exclude "$logsPath\$fileName $logType.csv"

    # Merge the content of all CSV files into a single variable
    $Merged = Get-Content $CSV

    # Save the merged content to a new CSV file with the specified file name in the target directory
    $Merged | Set-Content "$masterPath\$fileName $logType.csv"

    # Remove all CSV files in the logs folder except the newly created file
    $CSV | Where-Object {$_.Name -ne "$fileName $logType.csv"} | Remove-Item -Force
}

# Merge and process security logs
MergeAndProcessLogs $SecurityLogs $SecurityMaster "Security_Logs"

# Merge and process system logs
MergeAndProcessLogs $SystemLogs $SystemMaster "System_Logs"
