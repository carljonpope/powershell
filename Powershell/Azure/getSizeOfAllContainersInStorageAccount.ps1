$storageContext = New-AzStorageContext -StorageAccountName prod1filestoragesa01 -UseConnectedAccount
$containers = Get-AzStorageContainer -Context $storageContext


foreach($container in $containers) {

    $script = "C:\Users\Popec\'OneDrive - Broadridge Financial Solutions, Inc'\Scripts\powershell\Powershell\Azure\getContainerSize.ps1"
    $params = '-ResourceGroup "prod1-filestorage-rg" -StorageAccountName "prod1filestoragesa01" -ContainerName $container.name'
    Invoke-Expression "$script $params"

}