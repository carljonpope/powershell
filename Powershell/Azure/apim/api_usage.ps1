
$SubscriptionId = ""
$ResourceGroupName = ""
$ApiManagementName = ""
$WorkspaceId = ""
$OutputCsv = "apim-api-usage-prd.csv"



# --- Optional: set subscription context ---
if ($SubscriptionId) {
    Write-Host "Setting subscription context to $SubscriptionId" -ForegroundColor Cyan
    az account set --subscription $SubscriptionId 2>$null
}

# --- Fetch all APIs from APIM ---
Write-Host "Fetching all APIs from APIM '$ApiManagementName'..." -ForegroundColor Cyan
$allApis = az apim api list `
    --resource-group $ResourceGroupName `
    --service-name $ApiManagementName `
    -o json | ConvertFrom-Json

# Filter to current versions (ignore revisions)
$currentApis = $allApis | Where-Object { $_.isCurrent -eq $true }
Write-Host "Found $($currentApis.Count) current API versions." -ForegroundColor Green

# --- Query 90-day usage from Log Analytics ---
Write-Host "Querying Log Analytics for 90-day API usage..." -ForegroundColor Cyan
$kql = "ApiManagementGatewayLogs | where TimeGenerated > ago(90d) | summarize CallCount = count(), LastUsed = max(TimeGenerated) by ApiId"

$usageResult = az monitor log-analytics query `
    --workspace $WorkspaceId `
    --analytics-query $kql `
    -o json | ConvertFrom-Json

# --- Build usage map ---
$usageData = @{}
if ($usageResult -and $usageResult.Count -gt 0) {
    foreach ($row in $usageResult) {
        $apiId = $row.ApiId
        if (-not $apiId) { continue }

        $usageData[$apiId] = [PSCustomObject]@{
            CallCount = $row.CallCount
            LastUsed  = $row.LastUsed
        }
    }
}
Write-Host "Collected usage info for $($usageData.Keys.Count) APIs." -ForegroundColor Green

# --- Build final results ---
$result = @()
foreach ($api in $currentApis) {
    $apiId = $api.name
    $apiDisplayName = $api.displayName
    $apiVersion = if ($api.apiVersion) { $api.apiVersion } else { "N/A" }

    if ($usageData.ContainsKey($apiId)) {
        $callCount = $usageData[$apiId].CallCount
        $lastUsed  = $usageData[$apiId].LastUsed
    } else {
        $callCount = 0
        $lastUsed  = "N/A"
    }

    $result += [PSCustomObject]@{
        ApiId          = $apiId
        ApiDisplayName = $apiDisplayName
        ApiVersion     = $apiVersion
        CallCount      = $callCount
        LastUsed       = $lastUsed
    }

    Write-Host "Processed API: $apiDisplayName ($apiVersion) -> $callCount calls" -ForegroundColor Yellow
}

# --- Export CSV ---
$result | Sort-Object ApiDisplayName, ApiVersion | Export-Csv -Path $OutputCsv -NoTypeInformation -Encoding UTF8
Write-Host "`nOutput written to: $OutputCsv" -ForegroundColor Cyan

 