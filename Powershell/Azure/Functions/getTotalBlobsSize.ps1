#Get the total size of all blobs in each storage account

$StorageAccounts = Get-AzStorageAccount
$result = foreach($item in $StorageAccounts){
    $id = $item.Id+"/blobServices/default"
    $name = $item.StorageAccountName
    $metric = Get-AzMetric -ResourceId $id -MetricName "BlobCapacity" -WarningAction Ignore
    $data = $metric.Data.Average/1024/1024
    $rounded = [math]::round($data,2)
    Write-Output "Blobs in $name : $rounded MB"
}

$result | Out-File c:\temp\blobs.txt