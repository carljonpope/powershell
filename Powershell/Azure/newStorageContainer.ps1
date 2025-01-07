$storageContext = New-AzStorageContext -StorageAccountName fldevstorageacc02 -StorageAccountKey B5q+oFSQU5MCwLMtDlb9JAwODP7ObucJK2KeyBtKHg8Bg7/S/2RBZMz+jqR1d1wVnp40srFxpQw3l6SfKZLK3Q== #<enterKeyHere>
New-AzStorageContainer -name "sqldbauditlogs" -Context $storageContext


# Create the storage account

$storageAccount = New-AzStorageAccount -ResourceGroupName $rgName `
  -Name "examplestorageaccount100" `
  -Location $location `
  -SkuName $accountSku `
  -Kind StorageV2

$storageContext = New-AzStorageContext -StorageAccountName $storageAccount.StorageAccountName -UseConnectedAccount

# Create the container

New-AzStorageContainer -Name "exampleContainer" -Context $storageContext

