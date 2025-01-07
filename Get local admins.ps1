function get-localadmins{
  [cmdletbinding()]
  Param(
  [string]$computerName
  )
  $group = get-wmiobject win32_group -ComputerName $computerName -Filter "LocalAccount=True AND SID='S-1-5-32-544'"
  $query = "GroupComponent = `"Win32_Group.Domain='$($group.domain)'`,Name='$($group.name)'`""
  $list = Get-WmiObject win32_groupuser -ComputerName $computerName -Filter $query
  $list | %{$_.PartComponent} | % {$_.substring($_.lastindexof("Domain=") + 7).replace("`",Name=`"","\")}
}

$Workstation = Read-Host "Computer Name"
get-localadmins $Workstation


<#
$comps = import-csv c:\temp\comps.csv
$output = foreach ($comp in $comps) {

$workstation = $comp
get-localadmins}

$output | export-csv c:\temp\members.csv
#>