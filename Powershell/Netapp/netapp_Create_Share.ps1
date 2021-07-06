#Script to create NetApp share

#Comment
$comment = Read-Host "Please enter the ServiceNow ticket and description for the share"


[int]$Site_Number =0

#region location
#Choose site for new share
Write-Host " "
Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
Write-Host "       Site                                          " -ForegroundColor white -BackgroundColor Blue
Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
Write-Host " [1] = Cleveland                                     " -ForegroundColor Black -BackgroundColor Red
Write-Host " [2] = Seven Hills                                   " -ForegroundColor White -BackgroundColor Blue
Write-Host " [3] = Leeds                                         " -ForegroundColor Black -BackgroundColor Red
Write-Host " [4] = LD9                                           " -ForegroundColor White -BackgroundColor Blue
Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
{}
$01_clenacl01   = "cle-nacl01"
$02_svnnacl01   = "svn-nacl01"
$03_lbanacl02   = "lba-nacl02"
$04_lonnacl02   = "ld9-nacl01"

$Site_Number = Read-Host "Enter number next to the location the share will be located"

        Write-Host $Site_Number

        If ( $Site_Number -eq "1" )
            { $Cluster = $01_clenacl01 }

        ElseIf ( $Site_Number -eq "2" )
            { $Cluster = $02_svnnacl01 }

        ElseIf ( $Site_Number -eq "3" )
            { $Cluster = $03_lbanacl02 }

        ElseIf ( $Site_Number -eq "4" )
            { $Cluster = $04_lonnacl02 }

        Else {
                Write-Host "Invalid option script will exit"
                Exit 
        }

#Choose SVM
        [byte]$SVM_num = 0
        If ($Cluster -eq "cle-nacl01") {
                Write-Host " "
                Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                Write-Host "       Cleveland SVM                                 " -ForegroundColor white -BackgroundColor Blue
                Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                Write-Host " [1] = clenas01        (production app shares)       " -ForegroundColor White -BackgroundColor Blue
                Write-Host " [2] = clenasfileusr01 (user shares)                 " -ForegroundColor Black -BackgroundColor Red
                Write-Host " [3] = clenas04        (Legacy TWR shares)           " -ForegroundColor White -BackgroundColor Blue
                Write-Host " [4] = clenasoffice01  (department shares)           " -ForegroundColor Black -BackgroundColor Red
                Write-Host " [5] = clenastower01   (tower shares)                " -ForegroundColor White -BackgroundColor Blue
                Write-Host " [6] = clenas02        (development shares)          " -ForegroundColor Black -BackgroundColor Red
                Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                {}
                $SVM_num = Read-Host "Enter the SVM of the share"
        }
                       If ($SVM_num -eq 1 -and $Cluster -eq "cle-nacl01") {
                               $SVM = "clenas01"
                         }
                        ElseIf ($SVM_num -eq 2 -and $Cluster -eq "cle-nacl01") {
                              $SVM = "clenasfileusr01"
                        }
                        ElseIf ($SVM_num -eq 3 ) {
                               $SVM = "clenas04"
                               $Cluster = "cle-nacl04"
                        }
                        ElseIf ($SVM_num -eq 4 -and $Cluster -eq "cle-nacl01") {
                               $SVM = "clenasoffice01"
                        }
                        ElseIf ($SVM_num -eq 5 -and $Cluster -eq "cle-nacl01") {
                               $SVM = "clenastower01"
                        }
                        ElseIf ($SVM_num -eq 6 -and $Cluster -eq "cle-nacl01") {
                               $SVM = "clenas02"
                               $Cluster = "cle-nacl01"
                        }
                        ElseIf ($Cluster -eq "svn-nacl01") {
                               $SVM = "svnnas01"
                        }
                        ElseIf ($Cluster -eq "lba-nacl02") {
                               $SVM = "lbanas02"
                        }
                        ElseIf ($Cluster -eq "ld9-nacl01") {
                               $SVM = "ld9nas01"
                        }
                        Else {
                              $SVM = "error"
                        }
#endregion location

#region sharename
#Share Name
$BU   = "afsi"
$Share_Name = Read-Host "Enter the share name (no spaces _ to seperate words. $ at end for hidden share)"
$Share_Name = $Share_Name -replace '\s','_'
$Share_volume = $Share_Name -replace '\$',''
$Share_mount = "/$bu $share_volume"
$Share_volume = "$bu $share_volume smb"
$Share_volume = $Share_volume -replace '\s','_'
$Share_mount = $Share_mount -replace '\s','_'

#Choose namespace for new share based on SVM
        $namespace01   = "/amtrust_imports"
        $namespace02   = "/amtrust_dev"
        $namespace03   = "/amtrust_dataservices"
        $namespace04   = "/amtrust_backoffice"
        $namespace05   = "/amtrust_imageright"
        $namespace06   = "/amtrust_misc"
        $namespace07   = "/amtrust_web"
        $namespace08   = "/amtrust_manager"
        $namespace09   = "/amtrust_datawarehouse"
        $namespace10   = "/amtrust_development"
        $namespace11   = "/amtrust_testing"
        $namespace12   = ""

         If($SVM -eq 'clenas01'){             
                Write-Host " "
                Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                Write-Host " clenas01 Namespace                                  " -ForegroundColor white -BackgroundColor Blue
                Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                Write-Host " [1] = amtrust_dev                                   " -ForegroundColor Black -BackgroundColor Red
                Write-Host " [2] = amtrust_dataservices                          " -ForegroundColor White -BackgroundColor Blue
                Write-Host " [3] = amtrust_backoffice                            " -ForegroundColor Black -BackgroundColor Red
                Write-Host " [4] = amtrust_imageright                            " -ForegroundColor White -BackgroundColor Blue
                Write-Host " [5] = amtrust_misc                                  " -ForegroundColor Black -BackgroundColor Red
                Write-Host " [6] = amtrust_web                                   " -ForegroundColor White -BackgroundColor Blue
                Write-Host " [7] = amtrust_manager                               " -ForegroundColor Black -BackgroundColor Red
                Write-Host " [8] = none                                          " -ForegroundColor White -BackgroundColor Blue
                Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                
                $namespace = Read-Host "Enter number next to the location the share will be located"

                       If ( $namespace -eq "1" )
                           { $junction = $namespace02 }

                   ElseIf ( $namespace -eq "2" )
                            { $junction = $namespace03 }

                   ElseIf ( $namespace -eq "3" )
                           { $junction = $namespace04 }

                    ElseIf ( $namespace -eq "4" )
                          { $junction = $namespace05 }

                   ElseIf ( $namespace -eq "5" )
                          { $junction = $namespace06 }

                   ElseIf ( $namespace -eq "6" )
                           { $junction = $namespace07 }

                   ElseIf ( $namespace -eq "7" )
                            { $junction = $namespace08 }

                    Else { $junction = $namespace12 }
         }
                ElseIf($SVM -eq 'clenasfileusr01'){ 
                        Write-Host " "
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        Write-Host " clenasfileusr01 Namespace                           " -ForegroundColor white -BackgroundColor Blue
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        Write-Host " [1] = afsi_usershares                               " -ForegroundColor White -BackgroundColor Blue
                        Write-Host " [2] = afsi_usershares/afsi_userfiles01              " -ForegroundColor Black -BackgroundColor Red
                        Write-Host " [3] = afsi_usershares/afsi_userfiles02              " -ForegroundColor White -BackgroundColor Blue
                        Write-Host " [4] = afsi_usershares/afsi_clevelandusers           " -ForegroundColor Black -BackgroundColor Red
                        Write-Host " [5] = None                                          " -ForegroundColor White -BackgroundColor Blue
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        {}

                        $namespace = Read-Host "Enter number next to the location the share will be located"

                                If ( $namespace -eq "1" )
                                { $junction = '/afsi_usershares' }                         
                                ElseIf ( $namespace -eq "2" )
                                        { $junction = '/afsi_usershares/afsi_userfiles01' }

                                ElseIf ( $namespace -eq "3" )
                                        { $junction = '/afsi_usershares/afsi_userfiles02' }

                                ElseIf ( $namespace -eq "4" )
                                        { $junction = '/afsi_usershares/afsi_clevelandusers' }

                                Else { $junction = $namespace12 }

                }
        
                ElseIf($SVM -eq 'clenasoffice01'){ 
                        Write-Host " "
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        Write-Host " clenasoffice01 Namespace                            " -ForegroundColor white -BackgroundColor Blue
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        Write-Host " [1] = afsi_officeshares                             " -ForegroundColor White -BackgroundColor Blue
                        Write-Host " [2] = afsi_officeshares/afsi_officetower            " -ForegroundColor Black -BackgroundColor Red
                        Write-Host " [3] = afsi_officeshares/afsi_officeshares01         " -ForegroundColor White -BackgroundColor Blue
                        Write-Host " [4] = afsi_officeshares/afsi_officeshares02         " -ForegroundColor Black -BackgroundColor Red
                        Write-Host " [5] = None                                          " -ForegroundColor White -BackgroundColor Blue
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        {}

                        $namespace = Read-Host "Enter number next to the location the share will be located"

                                If ( $namespace -eq "1" )
                                { $junction = '/afsi_officeshares' }                         
                                ElseIf ( $namespace -eq "2" )
                                        { $junction = '/afsi_officeshares/afsi_officetower' }

                                ElseIf ( $namespace -eq "3" )
                                        { $junction = '/afsi_officeshares/afsi_officeshares01' }

                                ElseIf ( $namespace -eq "4" )
                                        { $junction = '/afsi_officeshares/afsi_officeshares02' }

                                Else { $junction = $namespace12 }
       
                }
                ElseIf($SVM -eq 'clenastower01'){ 
                        Write-Host " "
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        Write-Host " clenastower01 Namespace                             " -ForegroundColor white -BackgroundColor Blue
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        Write-Host " [1] = afsi_towerfiles                               " -ForegroundColor White -BackgroundColor Blue
                        Write-Host " [2] = afsi_towerfiles/afsi_toweruserfiles           " -ForegroundColor Black -BackgroundColor Red
                        Write-Host " [3] = afsi_towerfiles/afsi_towerdata                " -ForegroundColor White -BackgroundColor Blue
                        Write-Host " [4] = None                                          " -ForegroundColor Black -BackgroundColor Red
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        {}

                        $namespace = Read-Host "Enter number next to the location the share will be located"

                                If ( $namespace -eq "1" )
                                { $junction = '/afsi_towerfiles' }
                                ElseIf ( $namespace -eq "2" )
                                        { $junction = '/afsi_towerfiles/afsi_toweruserfiles' }
                                ElseIf ( $namespace -eq "3" )
                                        { $junction = '/afsi_towerfiles/afsi_towerdata ' }
                                Else { $junction = $namespace12 }
                }
                ElseIf($SVM -eq 'clenas02'){             
                        Write-Host " "
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        Write-Host " clenas02 Namespace                                  " -ForegroundColor white -BackgroundColor Blue
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        Write-Host " [1] = amtrust_imports                               " -ForegroundColor Black -BackgroundColor Red
                        Write-Host " [2] = amtrust_dataservices                          " -ForegroundColor White -BackgroundColor Blue
                        Write-Host " [3] = amtrust_datawarehouse                         " -ForegroundColor Black -BackgroundColor Red
                        Write-Host " [4] = amtrust_backoffice                            " -ForegroundColor White -BackgroundColor Blue
                        Write-Host " [5] = amtrust_misc                                  " -ForegroundColor Black -BackgroundColor Red
                        Write-Host " [6] = amtrust_web                                   " -ForegroundColor White -BackgroundColor Blue
                        Write-Host " [7] = amtrust_manager                               " -ForegroundColor Black -BackgroundColor Red
                        Write-Host " [8] = none                                          " -ForegroundColor White -BackgroundColor Blue
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        {}

                $namespace = Read-Host "Enter number next to the location the share will be located"

                       If ( $namespace -eq "1" )
                           { $junction = $namespace01 }

                   ElseIf ( $namespace -eq "2" )
                            { $junction = $namespace03 }

                   ElseIf ( $namespace -eq "3" )
                           { $junction = $namespace09 }

                    ElseIf ( $namespace -eq "4" )
                          { $junction = $namespace04 }

                   ElseIf ( $namespace -eq "5" )
                          { $junction = $namespace06 }

                   ElseIf ( $namespace -eq "6" )
                           { $junction = $namespace07 }

                   ElseIf ( $namespace -eq "7" )
                            { $junction = $namespace08 }

                    Else { $junction = $namespace12 }
         }                      
                ElseIf($SVM -eq 'clenas04'){             
                        Write-Host " "
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        Write-Host " clenas04 Namespace                                  " -ForegroundColor white -BackgroundColor Blue
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        Write-Host " [1] = amtrust_user                                  " -ForegroundColor Black -BackgroundColor Red
                        Write-Host " [2] = amtrust_imageright                            " -ForegroundColor White -BackgroundColor Blue
                        Write-Host " [3] = amtrust_manager                               " -ForegroundColor Black -BackgroundColor Red
                        Write-Host " [4] = amtrust_misc                                  " -ForegroundColor White -BackgroundColor Blue
                        Write-Host " [5] = None                                          " -ForegroundColor Black -BackgroundColor Red
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        {}

                $namespace = Read-Host "Enter number next to the location the share will be located"

                       If ( $namespace -eq "1" )
                           { $junction = '/amtrust_user' }

                   ElseIf ( $namespace -eq "2" )
                            { $junction = $namespace05 }

                   ElseIf ( $namespace -eq "3" )
                           { $junction = $namespace08 }

                    ElseIf ( $namespace -eq "4" )
                          { $junction = $namespace06 }

                    Else { $junction = $namespace12 }
         }                      
                ElseIf($SVM -eq 'svnnas01'){ 
                        Write-Host " "
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        Write-Host "       Namespace                                     " -ForegroundColor white -BackgroundColor Blue
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        Write-Host " [1] = amtrust_misc                                  " -ForegroundColor White -BackgroundColor Blue
                        Write-Host " [2] = None                                          " -ForegroundColor Black -BackgroundColor Red
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        {}

                        $namespace = Read-Host "Enter number next to the location the share will be located"

                                If ( $namespace -eq "1" )
                                { $junction = $namespace06 }
                                Else { $junction = $namespace12 }
                }
                ElseIf($SVM -eq 'lbanas02'){             
                        Write-Host " "
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        Write-Host "       Namespace                                     " -ForegroundColor white -BackgroundColor Blue
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        Write-Host " [1] = amtrust_testing                               " -ForegroundColor Black -BackgroundColor Red
                        Write-Host " [2] = amtrust_development                           " -ForegroundColor White -BackgroundColor Blue
                        Write-Host " [3] = amtrust_manager                               " -ForegroundColor Black -BackgroundColor Red
                        Write-Host " [4] = amtrust_backoffice                            " -ForegroundColor White -BackgroundColor Blue
                        Write-Host " [5] = None                                          " -ForegroundColor Black -BackgroundColor Red
                        Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                        {}

                $namespace = Read-Host "Enter number next to the location the share will be located"

                        If ( $namespace -eq "1" )
                           { $junction = $namespace11 }

                        ElseIf ( $namespace -eq "2" )
                            { $junction = $namespace10 }

                        ElseIf ( $namespace -eq "3" )
                           { $junction = $namespace08 }

                        ElseIf ( $namespace -eq "4" )
                          { $junction = $namespace04 }

                         Else { $junction = $namespace12 }
                } 
                ElseIf($SVM -eq 'ld9nas01') {
                $junction = $namespace12
                }

                Else {
                        Write-Host "Invalid Choice. Script will exit"
                        Exit
                }
                
        $junction_path = "$junction$Share_mount"
#endregion sharename

#region Snapshot policy
                $snap_pol = "none"
                [byte]$snaps = 0
                Write-Host " "
                Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                Write-Host "       Snapshot Retention                            " -ForegroundColor white -BackgroundColor Blue
                Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                Write-Host " [1] = short term (<2 weeks)                         " -ForegroundColor White -BackgroundColor Blue
                Write-Host " [2] = long term (months)                            " -ForegroundColor Black -BackgroundColor Red
                Write-Host " [3] = none                                          " -ForegroundColor White -BackgroundColor Blue
                Write-Host "=====================================================" -ForegroundColor white -BackgroundColor Blue
                {}

                $snapshots = Read-Host "Enter number next to the snapshot retention desired"

                        If ( $snapshots -eq "1" -and $Cluster -eq "cle-nacl01" )
                           { $snap_pol = "SMB" }

                        ElseIf ( $snapshots -eq "2" -and $Cluster -eq "cle-nacl01" )
                            { $snap_pol = "SMB2" }

                        ElseIf ( $snapshots -eq "1" -and $Cluster -eq "cle-nacl04" )
                           { $snap_pol = "default-1weekly" }

                        ElseIf ( $snapshots -eq "2" -and $Cluster -eq "cle-nacl04" )
                            { $snap_pol = "default"}
                           
                        ElseIf ( $snapshots -eq "1" -and $Cluster -eq "svn-nacl01" )
                              { $snap_pol = "default-1weekly" }
   
                        ElseIf ( $snapshots -eq "2" -and $Cluster -eq "svn-nacl01" )
                               { $snap_pol = "default" }
   
                        ElseIf ( $snapshots -eq "1" -and $Cluster -eq "ld9-nacl01" )
                                { $snap_pol = "CIFS-24-7-2" }
      
                        ElseIf ( $snapshots -eq "2" -and $Cluster -eq "ld9-nacl01" )
                                  { $snap_pol = "CIFS-48-60-24" }
      
                        ElseIf ( $snapshots -eq "1" -and $Cluster -eq "lba-nacl02" )
                                    { $snap_pol = "SMB" }
         
                        ElseIf ( $snapshots -eq "2" -and $Cluster -eq "lba-nacl02" )
                                     { $snap_pol = "default" }
         
                        ElseIf ( $snapshots -eq "3" )
                                    { $snaps = 1 }
#endregion Snapshot policy            


#region Share Size
[int]$Share_Size = Read-Host "Enter the size of the share in GB (Max 10240)"
If ($Share_Size -ge 1024) {
    $Size_check = Read-Host "You are requesting the share be $Share_Size GB. Please enter 1 if this is correct or 2 to quit the script"
    If ($Size_check -ne 1) {
          Write-Host " "
          Write-Host "================" -ForegroundColor White -BackgroundColor Blue
          Write-Host "Script will Exit" -ForegroundColor White -BackgroundColor Blue
          Write-Host "================" -ForegroundColor White -BackgroundColor Blue
        Exit
    }
}
If ($Share_Size -ge 10240) {
        $Share_Size = 1024
    Exit
}

$growsize = $Share_Size*2
[string]$maxsize = "$growsize g"
$maxsize = $maxsize -replace '\s',''

[string]$size = "$Share_Size g"
$size = $size -replace '\s',''
#endregion Share Size

#region NetApp login and checks
$User_Domain = "amtrustservices\"
$Session_UserID = [Environment]::UserName
$Credentials_NetApp = Get-Credential $User_Domain$Session_UserID
Connect-NcController "$Cluster" -Vserver "$svm" -Credential ($Credentials_NetApp)

# Feeds all aggregates into array
$aggrreport = Get-NcAggr
[int]$space_conversion = "1073741824"
[int]$index = 0

#checks to see if volume exists
$volcheck = Get-NcVol $Share_volume
If ($volcheck.Length -gt 0){
          Write-Host " "
          Write-Host "=================================" -ForegroundColor White -BackgroundColor Blue
          Write-Host "Duplicate Volume script will Exit" -ForegroundColor White -BackgroundColor Blue
          Write-Host "=================================" -ForegroundColor White -BackgroundColor Blue
          Exit
}

#checks to see if share exists
$sharecheck = Get-NcCifsShare $Share_Name
If ($sharecheck.Length -gt 0){
          Write-Host " "
          Write-Host "=================================" -ForegroundColor White -BackgroundColor Blue
          Write-Host "Duplicate Share script will Exit" -ForegroundColor White -BackgroundColor Blue
          Write-Host "=================================" -ForegroundColor White -BackgroundColor Blue
          Exit
}
#endregion NetApp login and checks

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
                        
                                If($Name -like "*sas*") {
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
                                ElseIf($Name -notlike "*sas*") {
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
        
#region create share        
#Create Volume
New-NcVol $Share_volume $aggr $size -JunctionPath $junction_path -SnapshotPolicy $snap_pol -SpaceReserve 'none' -SecurityStyle 'ntfs' -SnapshotReserve 0 -EfficiencyPolicy 'default'

#Enable Dedup on volume
Enable-NcSis $Share_volume

#Set Autogrow settings
Set-NcVolAutosize $Share_volume -Enabled -MaximumSize $maxsize -IncrementSize 20g

#Create Share
Add-NcCifsShare -Name $Share_Name -Path $junction_path -Comment $comment
#endregion create share

#region success check
#checks to see if share exists
$sharecheck = Get-NcCifsShare $Share_Name
If ($sharecheck.Length -gt 0){
        Write-Host " "
        Write-Host "====================================" -ForegroundColor White -BackgroundColor Blue
        Write-Host "Share has been successfully created " -ForegroundColor White -BackgroundColor Blue
        Write-Host "====================================" -ForegroundColor White -BackgroundColor Blue
        Exit
}

        Write-Host "=========================================================" -ForegroundColor White -BackgroundColor Blue
        Write-Host " Script failed. Share not created                        " -ForegroundColor White -BackgroundColor Blue
        Write-Host "=========================================================" -ForegroundColor White -BackgroundColor Blue
        Exit
#endregion success check