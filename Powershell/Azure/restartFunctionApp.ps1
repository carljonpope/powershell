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

Stop-AzFunctionApp -Name "prd-xxx-uksouth-fa01" -ResourceGroupName "dev-xxx-uksouth-rg01" -Force
Start-AzFunctionApp -Name "prd-xxx-uksouth-fa01" -ResourceGroupName "dev-xxx-uksouth-rg01"

Stop-AzFunctionApp -Name "prd-xxx-ukwest-fa01" -ResourceGroupName "dev-xxx-uksouth-rg01" -Force
Start-AzFunctionApp -Name "prd-xxx-ukwest-fa01" -ResourceGroupName "dev-xxx-uksouth-rg01"

Write-Output "Restarted Function Apps"
