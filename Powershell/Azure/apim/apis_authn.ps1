# Export API versions (current revisions only) and wheter authn is configured in the policy for the API / backend.

# Variables
$subscriptionId = ""
$resourceGroup = ""
$apimName      = ""



# ---------------------------
# Step 1: Get all APIs including revisions
# ---------------------------
Write-Host "Fetching all APIs for APIM instance '$apimName' in resource group '$resourceGroup'..." -ForegroundColor Cyan

$allApis = az apim api list `
    -g $resourceGroup `
    --service-name $apimName `
    -o json 2>$null | ConvertFrom-Json

if (-not $allApis) {
    Write-Error "No APIs returned. Check your resource group / APIM name / permissions."
    return
}

# ---------------------------
# Step 2: Filter current revisions only
# ---------------------------
$currentApis = $allApis | Where-Object { $_.isCurrent -eq $true }
Write-Host "Found $($currentApis.Count) current API revisions." -ForegroundColor Cyan

# ---------------------------
# Step 3: Loop through each current API and check policy
# ---------------------------
$results = @()

foreach ($api in $currentApis) {
    $apiId = $api.name
    $displayName = $api.displayName

    Write-Host "Checking policy for API: $displayName ($apiId)..." -ForegroundColor Yellow

    try {
        # Fetch API policy (raw XML) using az rest
        $policyXml = az rest --method get `
            --uri "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.ApiManagement/service/$apimName/apis/$apiId/policies/policy?api-version=2022-08-01" `
            2>&1 | Out-String

        # Check if <validate-jwt> exists
        $hasJwt = $policyXml -match "<validate-jwt"
        $hasClientCert = $policyXml -match "<validate-client-certificate"
        $hasSubs = $policyXml -match "<validate-subscription"
        $hasBasicAuthn = $policyXml -match "<authentication-basic"
        $hasMiAuthn = $policyXml -match "<authentication-managed"
        $hasCertAuthn = $policyXml -match "<authentication-certificate"
        $hasOauth2Authn = $policyXml -match "<authentication-oauth"

        # Add result to array
        $results += [PSCustomObject]@{
            ApiId = $apiId
            DisplayName = $displayName
            ValidateJwt = if ($hasJwt) { $true } else { $false }
            ClientCert = if ($hasClientCert) { $true } else { $false }
            ValidateSubscription = if ($hasSubs) { true } else { false }
            BackendBasicAuthn = if ($hasBasicAuthn) {$true } else { $false }
            BackendMiAuthn = if ($hasMiAuthn) {$true } else { $false }
            BackendCertAuthn = if ($hasCertAuthn) {$true } else { $false }
            BackendOauth2Authn = if ($hasOauth2Authn) {$true } else { $false }
        }
    }
    catch {
        Write-Warning "Failed to retrieve policy for API $apiId"
        $results += [PSCustomObject]@{
            ApiId = $apiId
            DisplayName = $displayName
            HasValidateJwt = $false
        }
    }
}

# ---------------------------
# Step 4: Export results to CSV
# ---------------------------
$csvPath = "APIM_CurrentAPIs_auth_Report.csv"
$results | Export-Csv -Path $csvPath -NoTypeInformation

Write-Host "`n✅ Report saved to $csvPath" -ForegroundColor Green

 