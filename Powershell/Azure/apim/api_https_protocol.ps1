# Export API protocol config

# Variables

$resourceGroup = ""
$apimName      = ""
$outputCsv     = "apim-api-https-prod.csv"

# Write-Host "Retrieving APIs (excluding revisions)..."
# $apis = az apim api list -g $resourceGroup --service-name $apimName --query "[?isCurrent==\`true\`]" -o json | ConvertFrom-Json

# if (-not $apis) {
#     Write-Error "No APIs returned. Check your inputs or permissions."
#     exit
# }

Write-Host "Fetching current APIs for '$apimName'..." -ForegroundColor Cyan
$apis = az apim api list -g $resourceGroup --service-name $apimName -o json 2>$null | ConvertFrom-Json
$currentApis = $apis | Where-Object { $_.isCurrent -eq $true }

$result = @()

foreach ($api in $currentApis) {
    $apiId = $api.name
    $apiDisplayName = $api.displayName
    $apiVersion = if ($api.apiVersion) { $api.apiVersion } else { "N/A" }

    # Convert ["http","https"] to "HTTP and HTTPS" style string
    $protocols = $api.protocols -join ", "
    if ($protocols -eq "https") { $protocolDesc = "HTTPS only" }
    elseif ($protocols -eq "http") { $protocolDesc = "HTTP only" }
    elseif ($protocols -match "http" -and $protocols -match "https") { $protocolDesc = "HTTP and HTTPS" }
    else { $protocolDesc = "Unknown" }

    $result += [PSCustomObject]@{
        ApiId          = $apiId
        ApiDisplayName = $apiDisplayName
        ApiVersion     = $apiVersion
        Protocols      = $protocolDesc
    }
}

$result | Sort-Object ApiDisplayName, ApiVersion | Export-Csv -Path $outputCsv -NoTypeInformation -Encoding UTF8

Write-Host "`nOutput written to: $outputCsv"