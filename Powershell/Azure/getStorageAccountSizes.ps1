$sub = Get-AzSubscription -subscriptionName "Development" #| select Name
$sub | foreach { 
Set-AzContext -Subscription "Development" #$_.Name
$currentSub = "Development" #$_.Name
$RGs = Get-AzResourceGroup | select ResourceGroupName
$RGs | foreach {
$CurrentRG = $_.ResourceGroupName
$StorageAccounts = Get-AzStorageAccount -ResourceGroupName $CurrentRG | select StorageAccountName
$StorageAccounts | foreach {
$StorageAccount = $_.StorageAccountName
$CurrentSAID = (Get-AzStorageAccount -ResourceGroupName $CurrentRG -AccountName $StorageAccount).Id
$usedCapacity = (Get-AzMetric -ResourceId $CurrentSAID -MetricName "UsedCapacity").Data
$usedCapacityInMB = $usedCapacity.Average / 1024 / 1024
"$StorageAccount,$usedCapacityInMB,$CurrentRG,$currentSub" >> "c:\temp\storageAccountsUsedCapacity.csv"
}
}
}