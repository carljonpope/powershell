#
# Find all hosts with triggered alarms in "Red" state
#
$esx_all = Get-VMHost | Get-View
$Report=@()
foreach ($esx in $esx_all){
    foreach($triggered in $esx.TriggeredAlarmState){
        If ($triggered.OverallStatus -like "yellow" ){
            $lineitem={} | Select Name, AlarmInfo
            $alarmDef = Get-View -Id $triggered.Alarm
            $lineitem.Name = $esx.Name
            $lineitem.AlarmInfo = $alarmDef.Info.Name
            $Report+=$lineitem
        } 
    }
}
$Report |Sort Name | export-csv "c:\temp\ESX-Host-yellow-Alarms.csv" -notypeinformation -useculture
Invoke-item "c:\temp\ESX-Host-yellow-Alarms.csv"