#Script to create NetApp LUN

#Ticket
$ticket = Read-Host "Please enter the ServiceNow ticket for the LUN"

#Comment
$comment = Read-Host "Please enter the description for the LUN"
$comment = ($ticket+"-"+$comment)

#Choose site for new share
Write-Host " "
Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
Write-Host "       Site                                          " -ForegroundColor white -BackgroundColor Blue
Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
Write-Host " [1] = Cleveland                                     " -ForegroundColor White -BackgroundColor Blue
Write-Host " [2] = Seven Hills                                   " -ForegroundColor Black -BackgroundColor Red
Write-Host " [3] = LD9                                           " -ForegroundColor White -BackgroundColor Blue
Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
{}

#Use Hash Table to hold each cluster and svm for easier enumeration, access and expansion.
$clusters = @{
        1 = "cle-nacl01"
        2 = "svn-nacl01"
        3 = "ld9-nacl01"
}

$svms = @{
        1 = "clesan01"
        2 = "svnsan01"
        3 = "ld9san01"
}

[int]$Site_Number = Read-Host "Enter number next to the location the share will be located"

#Catch numbers that don't exist in the hashtable (if you want to)
     If ($Site_Number -notin $clusters.Keys)
        { 
              Write-Host "==========================" -ForegroundColor White -BackgroundColor Blue
              Write-Host " You entered - $Site_Number " -ForegroundColor White -BackgroundColor Blue
              Write-Host " Selection does not exist. Script will exit...        " -ForegroundColor White -BackgroundColor Blue
              Write-Host " Please re-run the script.     " -ForegroundColor White -BackgroundColor Blue
              Write-Host "==========================" -ForegroundColor White -BackgroundColor Blue
              Exit
         }
        
#Grab the name of the cluster and svm from their respective hashtable based on the index number that was entered at the prompt
$Cluster = $clusters[$Site_Number] 
$svm = $svms[$Site_Number]

#volume Name
Write-Host "=============================================================" -ForegroundColor White -BackgroundColor Blue
Write-Host " Enter the Volume name for the LUN                           " -ForegroundColor White -BackgroundColor Blue
Write-Host " Format: servername_mountname i.e. clepdbops01_functest_db   " -ForegroundColor White -BackgroundColor Blue
Write-Host "=============================================================" -ForegroundColor White -BackgroundColor Blue
$volume_Name = Read-Host "Enter the volume name (no spaces _ to seperate words)"
$volume_Name = $volume_Name -replace '\s',''
$server_check =$volume_Name
$volume_Name = $volume_Name -replace '-','_'
$lun_Name = "$volume_Name .lun"
$lun_Name = $lun_Name -replace '\s',''
$lun_Name = $lun_Name -replace '-','_'
$lun_path = "/vol/$volume_Name/$lun_Name"

Write-Host "Lun- $lun_Name"
Write-Host "Volume- $volume_Name"
Write-Host "Lun Path- $lun_path"
$junction_path = "/$volume_Name"

#LUN Size
[int]$LUN_Size = Read-Host "Enter the size of the LUN in GB (Max 10240)"
If ($LUN_Size -ge 10240) {
          Write-Host " "
          Write-Host "======================================================================================================" -ForegroundColor White -BackgroundColor Blue
          Write-Host "This LUN is larger than 10 TB and will need to be configured by a Storage Engineer. Script will Exit" -ForegroundColor White -BackgroundColor Blue
          Write-Host "======================================================================================================" -ForegroundColor White -BackgroundColor Blue
Exit
}

$Volume_Size = $LUN_Size*1.5
$growsize = $Volume_Size*2
[string]$size = "$LUN_Size g"
[string]$maxsize = "$growsize g"
$size = $size -replace '\s',''
$maxsize = $maxsize -replace '\s',''
[string]$volsize = "$Volume_Size g"
$volsize = $volsize -replace '\s',''

#OS Type
Write-Host " "
Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
Write-Host "       OS                                            " -ForegroundColor white -BackgroundColor Blue
Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
Write-Host " [1] = Windows                                       " -ForegroundColor White -BackgroundColor Blue
Write-Host " [2] = ESXi                                          " -ForegroundColor Black -BackgroundColor Red
Write-Host " [3] = Linux                                         " -ForegroundColor White -BackgroundColor Blue
Write-Host " [4] = AIX                                           " -ForegroundColor Black -BackgroundColor Red
Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
{}

$OS_choice = @{
        1 = "windows_2008"
        2 = "vmware"
        3 = "linux"
        4 = "aix"
}

$IG_choice = @{
        1 = "windows"
        2 = "vmware"
        3 = "linux"
        4 = "aix"
}

[int]$OS_number = Read-Host "Enter number next to the OS for this server"

#Catch numbers that don't exist in the hashtable
If ($OS_Number -notin $clusters.Keys)
{ 
      Write-Host "==========================" -ForegroundColor White -BackgroundColor Blue
      Write-Host " You entered - $OS_Number " -ForegroundColor White -BackgroundColor Blue
      Write-Host " Selection does not exist. Script will exit...        " -ForegroundColor White -BackgroundColor Blue
      Write-Host " Please re-run the script.     " -ForegroundColor White -BackgroundColor Blue
      Write-Host "==========================" -ForegroundColor White -BackgroundColor Blue
      Exit
}

#Grab the name of the cluster and svm from their respective hashtable based on the index number that was entered at the prompt
$os = $OS_choice[$OS_Number]
$ig = $IG_choice[$OS_Number]

Write-Host $os

#Connects to NetApp system
$User_Domain = "amtrustservices\"
$Session_UserID = [Environment]::UserName
$Credentials_NetApp = Get-Credential $User_Domain$Session_UserID
Connect-NcController "$Cluster" -Vserver "$svm" -Credential ($Credentials_NetApp)

#checks to see if volume exists
$volcheck = Get-NcVol $volume_Name
If ($volcheck.Length -gt 0){
          Write-Host " "
          Write-Host "=================================" -ForegroundColor White -BackgroundColor Blue
          Write-Host "Duplicate Volume script will Exit" -ForegroundColor White -BackgroundColor Blue
          Write-Host "=================================" -ForegroundColor White -BackgroundColor Blue
          Exit
}
write-host $volcheck

#checks to see if share exists
$luncheck = Get-NcLun $lun_path
If ($luncheck.Length -gt 0){
          Write-Host " "
          Write-Host "=================================" -ForegroundColor White -BackgroundColor Blue
          Write-Host "Duplicate LUN script will Exit" -ForegroundColor White -BackgroundColor Blue
          Write-Host "=================================" -ForegroundColor White -BackgroundColor Blue
          Exit
}

write-host $luncheck

#Lists aggregates for cluster
# Feeds all aggregates into array 
$aggrreport = New-Object System.Collections.ArrayList
$aggrreport = Get-NcAggr
[int]$space_conversion = "1073741824"
[int]$index = 0

#region aggr check
#Check Aggrs to find correct one to use
[byte]$auto_pick_sas = 0
$auto_pick_name = "none"
[int]$auto_pick_space = 0

    Foreach($Name in $aggrreport) {
        If($Name -ne $Cluster){
		$count = 1;
                $periods = $null;
                        If($Name -notlike "*aggr0*") {
                                [int]$spacefree = $aggrreport[$index].Available/$space_conversion
                        
                                If($Name -like "*ssd*") {
                                        If($auto_pick_sas -eq 0) {
                                                $auto_pick_space = 0
                                                $auto_pick_sas = 1
                                        }
                                        If($spacefree -ge $auto_pick_space) {
                                                $auto_pick_name = $Name
                                                $auto_pick_num = $index
                                                $auto_pick_space = $spacefree
                                        }
                                }
                                ElseIf($Name -notlike "*ssd*") {
                                        If($auto_pick_sas -eq 0 -and $spacefree -ge $auto_pick_space) {
                                                $auto_pick_name = $Name
                                                $auto_pick_num = $index
                                                $auto_pick_space = $spacefree 
                                        }
                                }
                        }
                     $index++
     while($count -le $needed) {
	       $periods = "$periods.";
                   $count++;
           }
        }
    }
        $aggr = $aggrreport[$auto_pick_num].Name
#endregion aggr check

#Lists initiator groups for cluster
# Feeds all igroups into array 
$igreport = Get-NcIgroup
[int]$index = 0
$igfound = 0
$server = $server_check -split "(_)"
$searchvol = $server[0]

Foreach($Name in $igreport) {
        Write-Host $Name "--" $searchvol
        If($Name -like "*$searchvol*" -and $igfound -eq 0){
                $igchoice = Read-Host "Is $Name the correct Initiator Group? (y/n)"
                If ($igchoice -eq "y"){
                        $igfound = 1
                        $iggroup = $Name
                }
        }
}

If ($igfound -eq 0){
    Write-Host " "
    Write-Host "==========================================================================" -ForegroundColor White -BackgroundColor Blue
    Write-Host " Choose the Initiator Group for $NEW_MACHINE_NAME1          " -ForegroundColor White -BackgroundColor Blue
    Write-Host "==========================================================================" -ForegroundColor White -BackgroundColor Blue

    Foreach($Name in $igreport) {
            $igtype = $igreport[$index].Type
            If($igreport[$index].Type -eq $ig){
                $periods = $null;
                write-host "$index - $Name" -ForegroundColor Blue -BackgroundColor White
            }
    $index++
    }
        Write-Host " "
        Write-Host "**Note numbers aren't synchronous**" -ForegroundColor Black -BackgroundColor Red
        $igchoice = Read-Host "Enter number for the selected Initiator Group"
        $iggroup = $igreport[$igchoice].Name
        $iggroup = $iggroup -replace '\$',''
}        

$junction_path = $junction_path -replace '-','_'
$lun_path = $lun_path -replace '-','_'

#Create Volume
Write-Host "New-NcVol $volume_Name $aggr $volsize -JunctionPath $junction_path -SnapshotPolicy 'default' -SpaceReserve 'none' -SecurityStyle 'unix' -SnapshotReserve 0 -EfficiencyPolicy 'default' -Comment '$comment'"
New-NcVol $volume_Name $aggr $volsize -JunctionPath $junction_path -SnapshotPolicy 'default' -SpaceReserve 'none' -SecurityStyle 'unix' -SnapshotReserve 0 -EfficiencyPolicy 'default' -Comment '$comment'
Dismount-NcVol $volume_Name
Set-NcVolAutosize $volume_Name -Enabled -MaximumSize $maxsize -IncrementSize 20g

#Create LUN
Write-Host "New-NcLun -Path $lun_path -size $size -OsType $os -Unreserved -ThinProvisioningSupportEnabled -Comment '$comment'"
New-NcLun -Path $lun_path -size $size -OsType $os -Unreserved -ThinProvisioningSupportEnabled -Comment $comment
Set-NcLunSpaceAllocated $lun_path -Off

#Map LUN
$iggroup = $iggroup -replace '\s',''
Write-Host "Add-NcLunMap -Path $lun_path -InitiatorGroup '$iggroup'"
Add-NcLunMap -Path $lun_path -InitiatorGroup $iggroup

#region checks
#checks to see if lun exists
$luncheck = Get-NcLun $lun_path
If ($luncheck.Length -gt 0){
          Write-Host " "
          Write-Host "=================================" -ForegroundColor White -BackgroundColor Blue
          Write-Host "LUN has been created successfully" -ForegroundColor White -BackgroundColor Blue
          Write-Host "=================================" -ForegroundColor White -BackgroundColor Blue
          Exit
}

#checks to see if volume exists
$volcheck = Get-NcVol $volume_Name
If ($volcheck.Length -gt 0){
          Write-Host " "
          Write-Host "=======================================" -ForegroundColor White -BackgroundColor Blue
          Write-Host "Volume created, but LUN failed         " -ForegroundColor Black -BackgroundColor Red
          Write-Host "Storage Engineer will need to review   " -ForegroundColor White -BackgroundColor Blue
          Write-Host "=======================================" -ForegroundColor White -BackgroundColor Blue
          Exit
}

Write-Host "=======================================" -ForegroundColor White -BackgroundColor Blue
Write-Host "LUN and volume creation failed         " -ForegroundColor Black -BackgroundColor Red
Write-Host "Storage Engineer will need to review   " -ForegroundColor White -BackgroundColor Blue
Write-Host "=======================================" -ForegroundColor White -BackgroundColor Blue
#endregion checks