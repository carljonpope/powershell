# Export list of APIs with details of managed identities used in policy

# Variables

$subscriptionId = ""
$resourceGroup  = ""
$apimName       = ""

Write-Host "Fetching current APIs for '$apimName'..." -ForegroundColor Cyan
$allApis = az apim api list -g $resourceGroup --service-name $apimName -o json 2>$null | ConvertFrom-Json
$currentApis = $allApis | Where-Object { $_.isCurrent -eq $true }

$results = @()

foreach ($api in $currentApis) {
    $apiId = $api.name
    $displayName = $api.displayName
    Write-Host "Checking Managed Identity usage for API: $displayName ($apiId)..." -ForegroundColor Yellow

    try {
        # Create temp file for policy XML
        $tmpFile = [System.IO.Path]::GetTempFileName()

        # Save XML output directly from az rest
        az rest --method get `
            --uri "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.ApiManagement/service/$apimName/apis/$apiId/policies/policy?api-version=2022-08-01" `
            --output-file $tmpFile 2>$null

        # Read XML from file
        $policyXml = Get-Content -Path $tmpFile -Raw

        # Clean up temp file
        Remove-Item $tmpFile -Force

        if (-not $policyXml -or $policyXml.Trim() -eq "") {
            Write-Warning "No policy XML for API: $displayName"
            continue
        }

        try {
            [xml]$xml = $policyXml
        }
        catch {
            Write-Warning "Failed to parse XML for API: $displayName"
            continue
        }

        # Look for managed identity authentication elements
        $authNodes = $xml.policies.SelectNodes("//authentication-managed-identity")

        if (-not $authNodes -or $authNodes.Count -eq 0) {
            $results += [PSCustomObject]@{
                ApiId = $apiId
                DisplayName = $displayName
                ManagedIdentityUsed = $false
                BackendAuthType = "None"
                Resource = ""
            }
            continue
        }

        foreach ($node in $authNodes) {
            $parentName = $node.ParentNode.Name
            $resource   = $node.GetAttribute("resource")

            if ($parentName -eq "send-request") {
                $authType = "Auxiliary (Other Azure Resource)"
            } else {
                $authType = "Backend"
            }

            $results += [PSCustomObject]@{
                ApiId = $apiId
                DisplayName = $displayName
                ManagedIdentityUsed = $true
                BackendAuthType = $authType
                Resource = $resource
            }
        }
    }
    catch {
        Write-Warning "Failed to retrieve or parse policy for API $apiId"
        $results += [PSCustomObject]@{
            ApiId = $apiId
            DisplayName = $displayName
            ManagedIdentityUsed = $false
            BackendAuthType = "Error"
            Resource = ""
        }
    }
}

# Export results
$csvPath = "APIM_ManagedIdentity_Report_prod.csv"
$results | Export-Csv -Path $csvPath -NoTypeInformation
Write-Host "`n✅ Report saved to $csvPath" -ForegroundColor Green
 