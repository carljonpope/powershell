
$storageaccs = Get-AzStorageAccount

foreach ($acc in $storageaccs) {



#$acc = Get-AzStorageAccount -name cloudshellsauksouth -ResourceGroupName cloud-shell-storage-uksouth
$rg = $acc.ResourceGroupName
$acc.Id
$period = (get-date).AddDays(-30)

 

$accMetric = get-azmetric -ResourceId $acc.Id -timegrain 01:00:00:00 -StartTime $period -MetricName Ingress #Egress

$total = $accMetric.Data.total | Measure-Object -Sum

$total.sum
$row = New-Object psobject
$row | Add-Member -MemberType NoteProperty -name "SA Name" -value $acc.storageaccountName
$row | Add-Member -MemberType NoteProperty -name "Bytes sent B" -value $total.sum
export-csv c:\temp\bytesin.csv -append -InputObject $row



}


