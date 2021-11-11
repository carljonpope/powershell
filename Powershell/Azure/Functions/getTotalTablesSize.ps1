<#function Get-TotalTableSizeKb
{
param($Resource)
$Result = $Resource | Get-AzMetric -MetricName 'TableCapacity' -WarningAction SilentlyContinue
$DBSize = $Result.Data[$Result.Data.Count-2].Maximum
$DBSize / 1024
}

$storageaccounts = Get-AzStorageAccount
$alltables = 

}
$tables = Get-AzResource -ResourceType Microsoft.Storage/storageAccounts/tableServices/tables
$result = foreach ($table in $tables)

{
$tableSize = Get-TotalTableSizeKb $table
"Table ($($table.Name)) $($tableSize / 1024)Mb"
}
#$result | Out-File c:\temp\dbsizes.txt
#>

#Get the total size of all tables in each storage account

$StorageAccounts = Get-AzStorageAccount
$result = foreach($item in $StorageAccounts){
    $id = $item.Id+"/tableServices/default"
    $name = $item.StorageAccountName
    $metric = Get-AzMetric -ResourceId $id -MetricName "TableCapacity" -WarningAction Ignore
    $data = $metric.Data.Average/1024/1024
    $rounded = [math]::round($data,2)
    Write-Output "Tables in $name : $rounded MB"
}

$result | Out-File C:\temp\testtables.txt