
$webapps = Get-AzWebApp

foreach ($webapp in $webapps) {



#webapp = Get-AzWebApp -name prod1-elastic-wa01

$webapp.Id
$period = (get-date).AddDays(-30)

$appMetric = get-azmetric -ResourceId $webapp.Id -timegrain 01:00:00:00 -StartTime $period -MetricName Bytessent #bytesReceived

$total = $appMetric.Data.total | Measure-Object -Sum
$totalInTB = ($total.sum / 1000 / 1000 / 1000 / 1000)
$total
$row = New-Object psobject
$row | Add-Member -MemberType NoteProperty -name "App Name" -value $webapp.Name
$row | Add-Member -MemberType NoteProperty -name "Bytes sent B" -value $total.sum
export-csv c:\temp\tstbytessent.csv -append -InputObject $row

}


