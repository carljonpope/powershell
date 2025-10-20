# Get version sets

# === Variables ===
$resourceGroup = ""
$apimName      = ""
$outputCsv     = "apim-version-sets-prod.csv"

Write-Host "Retrieving all API version sets..."
$versionSets = az apim api versionset list `
    -g $resourceGroup `
    --service-name $apimName `
    -o json | ConvertFrom-Json

if (-not $versionSets) {
    Write-Error "No version sets found."
    exit
}

Write-Host "Retrieving all APIs (current versions only)..."

$allApis = az apim api list `
    -g $resourceGroup `
    --service-name $apimName `
    -o json 2>$null | ConvertFrom-Json

if (-not $allApis) {
    Write-Error "No APIs returned. Check your resource group / APIM name / permissions."
    return
}

$currentApis = $allApis | Where-Object { $_.isCurrent -eq $true }
Write-Host "Found $($currentApis.Count) current API revisions." -ForegroundColor Cyan

# Map version set IDs to display names
$versionSetMap = @{}
foreach ($vs in $versionSets) {
    $versionSetMap[$vs.name] = $vs.displayName
}

$result = @()

foreach ($api in $currentApis) {
    if ($api.apiVersionSetId) {
        $vsId = $api.apiVersionSetId -replace ".*/", ""  # extract just the version set name from the full resource ID
        $vsName = if ($versionSetMap.ContainsKey($vsId)) { $versionSetMap[$vsId] } else { $vsId }

        $result += [PSCustomObject]@{
            VersionSetName = $vsName
            VersionSetId   = $vsId
            ApiDisplayName = $api.displayName
            ApiName        = $api.name
            ApiVersion     = if ($api.apiVersion) { $api.apiVersion } else { "N/A" }
        }
    }
    else {
        # APIs not part of a version set
        $result += [PSCustomObject]@{
            VersionSetName = "None"
            VersionSetId   = ""
            ApiDisplayName = $api.displayName
            ApiName        = $api.name
            ApiVersion     = if ($api.apiVersion) { $api.apiVersion } else { "N/A" }
        }
    }
}

$result | Sort-Object VersionSetName, ApiDisplayName, ApiVersion | Export-Csv -Path $outputCsv -NoTypeInformation -Encoding UTF8

Write-Host "`nOutput written to: $outputCsv"
 