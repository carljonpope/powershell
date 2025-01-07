<#Connect-AzAccount

#Select subscription
$context = Get-AzSubscription -SubscriptionName "Prod 2" #"Development" #"Prod 1"
Set-AzContext $context
#>
$results = New-Object System.Collections.Generic.List[System.String]
$results.Add("ResourceGroup,ResourceType,ResourceName,RuleName,IpAddress,EndIpAddress,SubnetName")

# App Services
$appServices = Get-AzWebApp
foreach ($appService in $appServices) {
    $accessRestrictions = Get-AzWebAppAccessRestrictionConfig -ResourceGroupName $appService.ResourceGroup -Name $appService.Name
    foreach ($accessRestriction in $accessRestrictions) {
        foreach ($restriction in $accessRestriction.MainSiteAccessRestrictions) {       
            
            #Write-Host ($restriction | Format-List -Force | Out-String)
            $results.Add("$($appService.ResourceGroup),AppService,$($appService.Name),$($restriction.RuleName),$($restriction.IpAddress),,$($restriction.SubnetId)")
            #Write-Host "$($appService.ResourceGroup),AppService,$($appService.Name),$($restriction.RuleName),$($restriction.IpAddress),,$($restriction.SubnetId)"
        }       
    }
}

# Databases
$sqlServers = Get-AzSqlServer
foreach ($sqlServer in $sqlServers) {

    $firewallRules = Get-AzSqlServerFirewallRule -ResourceGroupName $sqlServer.ResourceGroupName -ServerName $sqlServer.ServerName
    
    foreach ($firewallRule in $firewallRules) {       
            
        #Write-Host ($restriction | Format-List -Force | Out-String)
        $results.Add("$($sqlServer.ResourceGroupName),SqlServer,$($sqlServer.ServerName),$($firewallRule.FirewallRuleName),$($firewallRule.StartIpAddress),$($firewallRule.EndIpAddress),")
        #Write-Host "$($sqlServer.ResourceGroupName),SqlServer,$($sqlServer.ServerName),$($firewallRule.FirewallRuleName),$($firewallRule.StartIpAddress),$($firewallRule.EndIpAddress),"
    }       
}

# Storage Accounts
$storageAccounts = Get-AzStorageAccount
foreach ($storageAccount in $storageAccounts) {
    foreach ($ipRule in $storageAccount.NetworkRuleSet.IpRules) {
        #Write-Host ($restriction | Format-List -Force | Out-String)
        $results.Add("$($storageAccount.ResourceGroupName),StorageAccount,$($storageAccount.Name),,$($ipRule.IPAddressOrRange),,")
        #Write-Host "$($storageAccount.ResourceGroupName),StorageAccount,$($storageAccount.Name),,$($ipRule.IPAddressOrRange),,"
    }

    foreach ($virtualNetworkRule in $storageAccount.NetworkRuleSet.VirtualNetworkRules) {
        #Write-Host ($restriction | Format-List -Force | Out-String)
        $results.Add("$($storageAccount.ResourceGroupName),StorageAccount,$($storageAccount.Name),,,,$($virtualNetworkRule.VirtualNetworkResourceId)")
        #Write-Host "$($storageAccount.ResourceGroupName),StorageAccount,$($storageAccount.Name),,,,$($virtualNetworkRule.VirtualNetworkResourceId)"
    }
}

$results | Out-File -Encoding utf8 C:\Temp\resources-ip-restrictions-prod1.csv