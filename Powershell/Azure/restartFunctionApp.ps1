    #-----L O G I N - A U T H E N T I C A T I O N-----
try
{
    "Logging in to Azure..."
    Connect-AzAccount -Identity
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

Stop-AzFunctionApp -Name "br-az-ics-fcs-prd-a15s-uksouth-fa01" -ResourceGroupName "br-az-ics-fcs-dev-a15s-uksouth-rg01" -Force
Start-AzFunctionApp -Name "br-az-ics-fcs-prd-a15s-uksouth-fa01" -ResourceGroupName "br-az-ics-fcs-dev-a15s-uksouth-rg01"

Stop-AzFunctionApp -Name "br-az-ics-fcs-prd-a15s-ukwest-fa01" -ResourceGroupName "br-az-ics-fcs-dev-a15s-uksouth-rg01" -Force
Start-AzFunctionApp -Name "br-az-ics-fcs-prd-a15s-ukwest-fa01" -ResourceGroupName "br-az-ics-fcs-dev-a15s-uksouth-rg01"

Write-Output "Restarted Function Apps"