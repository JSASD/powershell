# Get the start date and end date for the file name
$startDate = (Get-Date).AddDays(-7).ToString("yyyy-MM-dd")
$endDate = (Get-Date).ToString("yyyy-MM-dd")

# Create the file name using the start and end dates
$fileName = "${startDate}--${endDate}"

# Specify the path to the logs folder
$Logs = "\\js-vessel\Technology\Logs"

# Get a list of CSV files in the logs folder, excluding the current file
$CSV = Get-ChildItem $Logs\*.csv -Exclude "$Logs\$fileName _Server_Security_Logs.csv"

# Merge the content of all CSV files into a single variable
$Merged = Get-Content $CSV

# Save the merged content to a new CSV file with the specified file name
$Merged | Set-Content "$Logs\$fileName _Server_Security_Logs.csv"

# Remove all CSV files in the logs folder except the newly created file
$CSV | Where-Object {$_.Name -ne "$fileName _Server_Security_Logs.csv"} | Remove-Item -Force
