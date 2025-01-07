# Script to enable access time tracking and create and apply a lifecycle management policy to a storage account.
# Have to first get all storage accounts in the subscription, then loop through them all and check if each one is in the list - 
# have to do it that way as you cannot get the resource group that a SA is in.

# Initialise variables.

$allStorageAccounts = Get-AzStorageAccount
$storageAccounts = Get-Content c:\temp\30DaysDeleteSAList.txt
$policy1Name = "30DaysDeletePolicy"

# Loop through all storage accounts in subscription.

foreach ($storageAccount in $allstorageAccounts) {

    $storageAccountName = $storageAccount.StorageAccountName

# If storage account name is in list, then do the below.

    if ($storageAccounts -contains $storageAccountName) {

        $rgName = $storageAccount.ResourceGroupName


# Create lifecycle management policy and assign to storage account.

$action1 = Add-AzStorageAccountManagementPolicyAction  -BaseBlobAction Delete -daysAfterModificationGreaterThan 30
$filter1 = New-AzStorageAccountManagementPolicyFilter -BlobType blockBlob,appendBlob
$rule1 = New-AzStorageAccountManagementPolicyRule -name $policy1Name -action $action1 -filter $filter1


$policy =  Set-AzStorageAccountManagementPolicy -ResourceGroupName $rgName -accountname $storageAccountName -rule $rule1

    }
}