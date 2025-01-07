$storageContext = New-AzStorageContext -StorageAccountName fldevstorageacc02 -StorageAccountKey xxxKeyBtKxxx2RBZMz+jxxxK3Q== #<enterKeyHere>
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

