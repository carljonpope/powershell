# Export list of APIs and associated products

# Variables

$resourceGroup = ""
$apimName      = ""
$outputCsv     = "apim-api-products-prod.csv"

# Write-Host "Retrieving APIs (excluding revisions)..."
# $apis = az apim api list -g $resourceGroup --service-name $apimName --query "[?isCurrent==\`true\`]" -o json | ConvertFrom-Json

# if (-not $apis) {
#     Write-Error "No APIs returned. Check your inputs or permissions."
#     exit
# }

Write-Host "Fetching current APIs for '$apimName'..." -ForegroundColor Cyan
$apis = az apim api list -g $resourceGroup --service-name $apimName -o json 2>$null | ConvertFrom-Json
$currentApis = $apis | Where-Object { $_.isCurrent -eq $true }



# Build a hashtable to store products for each API id (api.name)
$apiProducts = @{}
foreach ($api in $currentApis) {
    $apiProducts[$api.name] = @()    # initialize empty array
}

Write-Host "Retrieving products and their linked APIs..."
$products = az apim product list `
    -g $resourceGroup `
    --service-name $apimName `
    -o json | ConvertFrom-Json

if ($products) {
    foreach ($product in $products) {
        $prodId = $product.name
        $prodDisplay = $product.displayName

        # Get APIs attached to this product
        $prodsApis = az apim product api list `
            -g $resourceGroup `
            --service-name $apimName `
            --product-id $prodId `
            -o json 2>$null | ConvertFrom-Json

        if ($prodsApis) {
            foreach ($papi in $prodsApis) {
                # product api list returns api entries that include a 'name' which is the API id
                $apiId = $papi.name

                # Only record products for APIs that are in the current APIs set (avoid revisions)
                if ($apiProducts.ContainsKey($apiId)) {
                    $apiProducts[$apiId] += [PSCustomObject]@{
                        ProductId = $prodId
                        ProductName = $prodDisplay
                    }
                }
            }
        }
    }
}

# Compose result rows
$result = @()
foreach ($api in $currentApis) {
    $apiId = $api.name
    $apiDisplay = $api.displayName
    $apiVersion = if ($api.apiVersion) { $api.apiVersion } else { "N/A" }
    $apiVersionSetId = if ($api.apiVersionSetId) { $api.apiVersionSetId } else { "" }

    $attachedProducts = $apiProducts[$apiId]

    if ($attachedProducts -and $attachedProducts.Count -gt 0) {
        foreach ($prod in $attachedProducts) {
            $result += [PSCustomObject]@{
                ApiId = $apiId
                ApiDisplayName = $apiDisplay
                ApiVersion = $apiVersion
                ApiVersionSetId = $apiVersionSetId
                ProductName = $prod.ProductName
                ProductId = $prod.ProductId
            }
        }
    } else {
        # No product attached
        $result += [PSCustomObject]@{
            ApiId = $apiId
            ApiDisplayName = $apiDisplay
            ApiVersion = $apiVersion
            ApiVersionSetId = $apiVersionSetId
            ProductName = "None"
            ProductId = ""
        }
    }
}

# Export to CSV
$result | Sort-Object ApiDisplayName, ApiVersion | Export-Csv -Path $outputCsv -NoTypeInformation -Encoding UTF8

Write-Host "`nOutput written to: $outputCsv"