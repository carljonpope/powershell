$storageAccounts = Get-AzStorageAccount -ResourceGroupName dev-clientportal-rg -name backendstate

foreach($storageAccount in $storageAccounts) {

    $temp = new-object psobject -property @{
        StorageAccountName = $storageAccount.StorageAccountName
        ContainerNames = (Get-AzStorageAccount -resourcegroupname $storageaccount.ResourceGroupName -name $storageAccount.StorageAccountName | Get-AzStorageContainer).Name
    }
    $records = $temp.ContainerNames.Count
    $expandedTemp = @()
    $expandedTemp += $temp | Select-Object StorageAccountName,@{l="ContainerNames";e={$temp.ContainerNames[0]}}
    for($i=1;$i -lt $records;$i++){$expandedTemp += $temp | Select-Object StorageAccountName,@{l="ContainerNames";e={$temp.ContainerNames[$i]}}}
    $expandedTemp | export-csv -path c:\temp\prod2Containers.csv -noclobber -append -NoTypeInformation
}
