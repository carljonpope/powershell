
$resourceGroups = Get-AzResourceGroup
foreach($resourceGroup in $resourceGroups) {

    Get-AzResourceGroupDeployment -ResourceGroupName $resourcegroup.ResourceGroupName | Where-Object {$_.Timestamp -gt '11/18/2021 1:57:19 AM'}

}