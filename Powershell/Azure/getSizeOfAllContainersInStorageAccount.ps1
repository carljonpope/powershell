$storageContext = New-AzStorageContext -StorageAccountName filestoragesa01 -UseConnectedAccount
$containers = Get-AzStorageContainer -Context $storageContext


foreach($container in $containers) {

    $script = "C:\Users\xxxx\Scripts\powershell\Powershell\Azure\getContainerSize.ps1"
    $params = '-ResourceGroup "filestorage-rg" -StorageAccountName "filestoragesa01" -ContainerName $container.name'
    Invoke-Expression "$script $params"

}
