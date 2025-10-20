# Export API subscription requirements

# Variables
$resourceGroup  = ""
$apimName       = ""
$outputCsv      = "apim-api-subscription-required-prod.csv"

Write-Host "Fetching current APIs for '$apimName'..." -ForegroundColor Cyan
$apis = az apim api list -g $resourceGroup --service-name $apimName -o json 2>$null | ConvertFrom-Json
$currentApis = $apis | Where-Object { $_.isCurrent -eq $true }

$result = @()

foreach ($api in $currentApis) {
    $apiId          = $api.name
    $apiDisplayName = $api.displayName
    $apiVersion     = if ($api.apiVersion) { $api.apiVersion } else { "N/A" }
    $requiresSub    = if ($api.subscriptionRequired -eq $true) { "TRUE" } else { "FALSE" }

    $result += [PSCustomObject]@{
        ApiId              = $apiId
        ApiDisplayName     = $apiDisplayName
        ApiVersion         = $apiVersion
        SubscriptionNeeded = $requiresSub
    }
}

$result | Sort-Object ApiDisplayName, ApiVersion | Export-Csv -Path $outputCsv -NoTypeInformation -Encoding UTF8

Write-Host "`nOutput written to: $outputCsv"
 