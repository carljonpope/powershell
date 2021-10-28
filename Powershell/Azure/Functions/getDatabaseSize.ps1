function Get-TotalDatabaseSizeKb
{
param($Resource)
$Result = $Resource | Get-AzMetric -MetricName 'storage' -WarningAction SilentlyContinue
$DBSize = $Result.Data[$Result.Data.Count-2].Maximum
$DBSize / 1024
}


$Databases = Get-AzResource -ResourceType Microsoft.Sql/servers/databases
$result = foreach ($DB in $Databases)

{
$DBSize = Get-TotalDatabaseSizeKb $DB
"DB ($($DB.Name)) $($DBSize / 1024)Mb"
}
$result | Out-File c:\temp\dbsizes.txt