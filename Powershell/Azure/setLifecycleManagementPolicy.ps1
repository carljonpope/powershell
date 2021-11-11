$action = Add-AzStorageAccountManagementPolicyAction  -BaseBlobAction TierToCool -DaysAfterAccessTimeGreaterThan 30
$action = Add-AzStorageAccountManagementPolicyAction  -BaseBlobAction TierToArchive -DaysAfterAccessTimeGreaterThan 90 -InputObject $action
$action = Add-AzStorageAccountManagementPolicyAction  -BaseBlobAction Delete -DaysAfterAccessTimeGreaterThan 1825 -InputObject $action
$filter = New-AzStorageAccountManagementPolicyFilter
$rule = New-AzStorageAccountManagementPolicyRule -name test1 -action $action -filter $filter
policy =  Set-AzStorageAccountManagementPolicy -ResourceGroupName storage -accountname cjptest01 -rule $rule