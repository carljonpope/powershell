
<#
$rgName = "<resource-group>"
$accountName = "<storage-account>"

$storageAccount = Get-AzStorageAccount -ResourceGroupName $rgName -Name $accountName
$ctx = $storageAccount.Context

Get-AzStorageContainer -Context $ctx | Select Name, PublicAccess

#>

$storageAccounts = Get-AzStorageAccount

foreach($storageAccount in $storageAccounts) {
  $ctx = $storageAccount.Context

Get-AzStorageContainer -Context $ctx | Select Name, PublicAccess

}


$storageAccounts = Get-AzStorageAccount

foreach($storageAccount in $storageAccounts) {

    $ctx = $storageAccount.Context
    $temp = new-object psobject -property @{
        StorageAccountName = $storageAccount.StorageAccountName
        ContainerNames = (Get-AzStorageAccount -resourcegroupname $storageaccount.ResourceGroupName -name $storageAccount.StorageAccountName | Get-AzStorageContainer).Name
        Public = (Get-AzStorageContainer -Context $ctx | Select PublicAccess)
    }
    $records = $temp.ContainerNames.Count
    $expandedTemp = @()
    $expandedTemp += $temp | Select-Object StorageAccountName,@{l="ContainerNames";e={$temp.ContainerNames[0]}}
    for($i=1;$i -lt $records;$i++){$expandedTemp += $temp | Select-Object StorageAccountName,@{l="ContainerNames";e={$temp.ContainerNames[$i]}}}
    $expandedTemp | export-csv -path c:\temp\testContainers.csv -noclobber -append -NoTypeInformation
}
