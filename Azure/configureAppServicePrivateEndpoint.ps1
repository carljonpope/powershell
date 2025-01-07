$webapp = Get-AzWebApp -ResourceGroupName webapps -Name cjptest-as02-ukwest

$parameters1 = @{
    Name = 'myConnection'
    PrivateLinkServiceId = $webapp.ID
    GroupID = 'sites'
}
$privateEndpointConnection = New-AzPrivateLinkServiceConnection @parameters1

$vnet = Get-AzVirtualNetwork -ResourceGroupName 'networkingukwest' -Name 'vnet2'
$vnet.Subnets[0].PrivateEndpointNetworkPolicies = "Disabled"
$vnet | Set-AzVirtualNetwork

$parameters2 = @{
    ResourceGroupName = 'networking'
    Name = 'cjptest-as-pe02'
    Location = 'ukwest'
    Subnet = $vnet.Subnets[0]
    PrivateLinkServiceConnection = $privateEndpointConnection
}
New-AzPrivateEndpoint @parameters2


$vnet = Get-AzVirtualNetwork -ResourceGroupName 'networkingukwest' -Name 'vnet2'
$zone = Get-AzPrivateDnsZone -ResourceGroupName networking -name privatelink.azurewebsites.net

$parameters2 = @{
    ResourceGroupName = 'networking'
    ZoneName = 'privatelink.azurewebsites.net'
    Name = 'myLink'
    VirtualNetworkId = $vnet.Id
}
$link = New-AzPrivateDnsVirtualNetworkLink @parameters2

$parameters3 = @{
    Name = 'privatelink.azurewebsites.net'
    PrivateDnsZoneId = $zone.ResourceId
}
$config = New-AzPrivateDnsZoneConfig @parameters3

$parameters4 = @{
    ResourceGroupName = 'networking'
    PrivateEndpointName = 'cjptest-as-pe02'
    Name = 'myZoneGroup'
    PrivateDnsZoneConfig = $config
}
New-AzPrivateDnsZoneGroup @parameters4