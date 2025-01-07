#Get-AzVirtualNetwork -Name vnet1 -ResourceGroupName networking | Get-AzVirtualNetworkSubnetConfig | Format-Table

$vn = Get-AzVirtualNetwork -Name prod2-global-vnet01
$vn.Subnets | Select  Name, AddressPrefix <# Name ,AddressPrefix ,NetworkSecurityGroup , ServiceEndpoints #> | Out-File c:\temp\prdsubnets.txt
$vn.AddressSpace | select Name, AddressPrefixes | Out-File c:\temp\prdaddrspace.txt
#$vn.Subnets | Select  Name, NetworkSecurityGroup | Out-File c:\temp\brdevnsg.txt


$subnets = $vn.Subnets
$output = foreach ($subnet in $subnets) {

    $subnet.NetworkSecurityGroup.id
}
$output | out-file c:\temp\brprdnsg.txt
