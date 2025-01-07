#$webapps = Get-AzWebApp

#foreach ($webapp in $webapps) {
$webapp = get-azwebapp -ResourceGroupName prod1-identity-rg -name prod1-xxxx-wa01

   $appID = $webapp.Id
   $diagSettingName = ($webapp.name) + "-diag"

 #  Remove-AzDiagnosticSetting -resourceid $appId -name "test-xxxx-sites-wa01"

Set-AzDiagnosticSetting `
-resourceid $appId `
-name $diagSettingName `
-StorageAccountId /subscriptions/exxxx-xx-4xxx28-xxx72-ee8xxx918ce0/resourceGroups/prod1-siemintegration-rg/providers/Microsoft.Storage/storageAccounts/prod1diaglogsarchive `
-EventHubName prod1-siemintegration-eh01 `
-EventHubAuthorizationRuleId /subscriptions/exxxx3-fxxe-4xxx28-xxx72-xxxx0/resourceGroups/prod1-siemintegration-rg/providers/Microsoft.EventHub/namespaces/fcssiemintprod01/authorizationRules/RootManageSharedAccessKey `
-Enabled $true `
-RetentionEnabled $true `
-RetentionInDays 365 `
-EnableLog $true `
-EnableMetrics $false `
-category AppServiceHTTPLogs, AppServiceAppLogs, AppServiceIPSecAuditLogs, AppServicePlatformLogs, AppServiceAuditLogs, AppServiceConsoleLogs #, AppServiceAntivirusScanAuditLogs, AppServiceFileAuditLogs


#}


#-EventHubAuthorizationRuleId /subscriptions/xxxx6-45a6-498a-911e-xxxxcb3d3b/resourceGroups/prod2-siemintegration-rg/providers/Microsoft.EventHub/namespaces/fcssiemintprod02/authorizationRules/RootManageSharedAccessKey `
#-EventHubName prod2-siemintegration-eh01 `
#-StorageAccountId /subscriptions/xxxx6-45a6-498a-911e-xxxxcb3d3b/resourceGroups/prod2-siemintegration-rg/providers/Microsoft.Storage/storageAccounts/prod2diaglogsarchive `
