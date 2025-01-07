$net =@{
    Name = 'vnet1'
    ResourceGroupName = 'networking'
}
$vnet = Get-AzVirtualNetwork @net

($vnet | Select -ExpandProperty subnets | Where-Object {$_.Name -eq 'subnet4'}).PrivateEndpointNetworkPolicies = "Enabled"

$vnet | Set-AzVirtualNetwork


Register-AzProviderFeature -FeatureName AllowPrivateEndpointNSG -ProviderNamespace Microsoft.Network
Get-AzProviderFeature -FeatureName AllowPrivateEndpointNSG -ProviderNamespace Microsoft.Network