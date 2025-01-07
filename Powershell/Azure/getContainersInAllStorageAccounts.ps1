$storageAccounts = Get-AzStorageAccount
$output = foreach($storageAccount in $storageAccounts) {

    Write-output "Storage account name is:" $storageAccount.StorageAccountName
    $containerName = (Get-AzStorageAccount -resourcegroupname $storageaccount.ResourceGroupName -name $storageAccount.StorageAccountName | Get-AzStorageContainer).Name
    Write-output "Containers in " $storageAccount.StorageAccountName "are: "
    Write-output $containerName
    $blank = ""
    $blank
    $blank
}
$output | Out-File c:\temp\prod1Containers.txt
