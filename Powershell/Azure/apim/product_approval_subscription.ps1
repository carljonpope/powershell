#Export products and approval/subscription

# Variables
$resourceGroup  = ""
$apimName       = ""
$outputCsv     = "apim-products-prod.csv"

# Get products and export key flags
$products = az apim product list `
    -g $resourceGroup `
    --service-name $apimName `
    -o json | ConvertFrom-Json

$products |
    Select-Object `
        @{Name="ProductId";Expression={$_.name}},
        @{Name="ProductName";Expression={$_.displayName}},
        @{Name="RequiresSubscription";Expression={$_.subscriptionRequired}},
        @{Name="RequiresApproval";Expression={$_.approvalRequired}} |
    Export-Csv -Path $outputCsv -NoTypeInformation -Encoding UTF8

Write-Host "`nExported product details to: $outputCsv"
 