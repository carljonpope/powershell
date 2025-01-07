
# Get all storage accounts in the subscription with public network access disabled
$filteredStorageAccounts = Get-AzStorageAccount | Where-Object { $_.PublicNetworkAccess -ne 'Disabled' }



# Define the CSV file path
$csvFilePath = "C:\temp\prdStorageAccountsWithNetAccessEnabled.csv"

# Export storage account details to CSV
$filteredStorageAccounts | Select-Object StorageAccountName, ResourceGroupName | Export-Csv -Path $csvFilePath -NoTypeInformation