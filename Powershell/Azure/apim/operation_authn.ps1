# Check operation level policies for authentication

# ----------------------------
# Parameters
# ----------------------------
$resourceGroup  = ""
$apimName       = ""
$subscriptionId = az account show --query id -o tsv

# ----------------------------
# Authentication patterns to detect
# ----------------------------
$authPatterns = @{
    "ManagedIdentity"              = "<authentication-managed-identity"
    "ClientCertificate"            = "<authentication-certificate"
    "Basic"                        = "<authentication-basic"
    "AAD_OAuth2"                   = "<authentication-oauth2"
    "JWTValidation"                = "<validate-jwt"
    "ClientCertificateValidation"  = "<validate-client-certificate"
}

# ----------------------------
# Helper function to check policy
# ----------------------------
function Get-AuthFlags($policyXml) {
    $flags = @{}
    foreach ($key in $authPatterns.Keys) {
        $flags[$key] = $false
        if ($policyXml -match $authPatterns[$key]) {
            $flags[$key] = $true
        }
    }
    return $flags
}

# ----------------------------
# Prepare results array
# ----------------------------
$results = @()

# ----------------------------
# Get current APIs
# ----------------------------
$apis = az apim api list -g $resourceGroup --service-name $apimName -o json | ConvertFrom-Json
$currentApis = $apis | Where-Object { $_.isCurrent -eq $true }

foreach ($api in $currentApis) {
    $apiId = $api.name

    # --- API-level policy ---
    $apiPolicyUri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.ApiManagement/service/$apimName/apis/$apiId/policies/policy?api-version=2022-08-01"
    $apiPolicy = az rest --method get --uri $apiPolicyUri --only-show-errors --output tsv 2>$null

    $apiFlags = Get-AuthFlags $apiPolicy

    # Record API-level row
    $row = [PSCustomObject]@{
        API        = $apiId
        Operation  = "All Operations"
        PolicyScope= "API"
    }
    foreach ($key in $authPatterns.Keys) { $row | Add-Member -NotePropertyName $key -NotePropertyValue $apiFlags[$key] }
    $results += $row

    # --- Operation-level policies ---
    $operations = az apim api operation list -g $resourceGroup --service-name $apimName --api-id $apiId -o json | ConvertFrom-Json
    foreach ($op in $operations) {
        $opId = $op.name
        $opName = $op.displayName
        Write-Host "Checking API: $apiId, Operation: $opName ..."

        $opPolicyUri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.ApiManagement/service/$apimName/apis/$apiId/operations/$opId/policies/policy?api-version=2022-08-01"
        $opPolicy = az rest --method get --uri $opPolicyUri --only-show-errors --output tsv 2>$null

        $opFlags = Get-AuthFlags $opPolicy

        # Record operation-level row
        $row = [PSCustomObject]@{
            API        = $apiId
            Operation  = $opName
            PolicyScope= "Operation"
        }
        foreach ($key in $authPatterns.Keys) { $row | Add-Member -NotePropertyName $key -NotePropertyValue $opFlags[$key] }
        $results += $row
    }
}

# ----------------------------
# Output results
# ----------------------------
$results | Sort-Object API, Operation | Format-Table -AutoSize

# ----------------------------
# Optional: Export to CSV
# ----------------------------
$results | Export-Csv -Path "./apim-authentication-check-prod.csv" -NoTypeInformation

 