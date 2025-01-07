$webApps = Get-Content "C:\temp\Projects\dev App service consolidation\webApps1.txt"



$output = foreach($webApp in $webApps) {
    
    $webAppDetails = Get-AzWebApp -name $webApp
    $rg = $webAppDetails.ResourceGroup
    $vnetList = az webapp vnet-integration list --name $webApp --resource-group $rg
    $vnet = $vnetList[5]
    $a,$b = $vnet.split(":")
    Write-Output ""WebApp" $($webapp), "Integrated vnet is" $b"
}
$output
$output | Out-File c:\temp\vnets.txt
