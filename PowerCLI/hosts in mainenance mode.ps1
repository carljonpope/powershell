# Find all hosts in maintenance mode

$esx_all = Get-VMHost
$Report=@()

foreach ($esx in $esx_all){

        If ($esx.connectionstate -eq "Maintenance") {
            $esx
            $lineitem={} | Select Name, connectionstate
            $lineitem.Name = $esx.Name
            $lineitem.connectionstate = $esx.connectionstate
            $Report+=$lineitem
        } 
}

$Report |Sort Name | export-csv "c:\temp\hostsInMaintnenaceMode.csv" -notypeinformation -useculture
