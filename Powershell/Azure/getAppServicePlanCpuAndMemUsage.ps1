#$resourceId = "/subscriptions/xxx1de-4a28-b172-ee888xxxce0/resourceGroups/prod1-hydration-rg/providers/Microsoft.Web/serverFarms/prod1-hydration-as"
$warningPreference = 'silentlyContinue'
$startTime  = "2021-11-15T04:00:00Z"
$endTime    = "2021-12-15T04:00:00Z"
$timeGrain  = "01:00:00:00"

$plans = Get-AzAppServicePlan
$output = foreach ($plan in $plans) {

    $resourceId = $plan.Id
    $plan.Name



# Get average CPU usage for period

    $cpuMetric = Get-AzMetric -ResourceId  $resourceId -MetricName "CpuPercentage" -AggregationType Average -TimeGrain $timeGrain -StartTime $startTime -EndTime $endTime
    $cpuResults = $cpuMetric.Data.average
    $cpuAvg = $cpuResults | Measure-Object -Average
    write-output $plan.name "Average CPU usage: " $cpuAvg.Average

# Get average Memory Usage for period

    $memMetric = Get-AzMetric -ResourceId $resourceId -MetricName "Memorypercentage" -AggregationType Average -TimeGrain $timeGrain -StartTime $startTime -EndTime $endTime
    $memResults = $memMetric.Data.average
    $memAvg = $memResults | Measure-Object -Average
    write-output $plan.name "Average memory usage: " $memAvg.Average

}

$output | out-file c:\temp\asp.txt
