$m = Get-AzStorageAccount -resourcegroupname cs-prd-f12i-uksouth-rg01 -name prduksouthf12isa01 | get-azstoragecontainer -name trash | Get-AzStorageBlob | Measure-Object
$m.Count
