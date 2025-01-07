$m = Get-AzStorageAccount -resourcegroupname br-az-ics-fcs-prd-f12i-uksouth-rg01 -name icsfcsprduksouthf12isa01 | get-azstoragecontainer -name trash | Get-AzStorageBlob | Measure-Object
$m.Count