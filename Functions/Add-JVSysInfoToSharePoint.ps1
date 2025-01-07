function Add-JVSysInfoToSharePoint {
    [CmdletBinding(SupportsShouldProcess)]
    param (
    
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$ComputerName,
        [string]$list = 'CCP US-UK Migration',
        [Parameter(ValueFromPipeline)]
        [string]$url = 'https://amtrustgroup.sharepoint.com/sites/EUInfra',
        [Parameter()]
        [string]$Application
    )
    
    begin {
        #Region PnP Tools
        if (Get-Module -ListAvailable -Name PnP.PowerShell) {
            Write-Verbose "PNP Module is installed"
            
        }
        else {
            Write-Output "SharePoint PowerShell Tools not present, installing now..."
            try {
                Install-Module -Name PnP.PowerShell -Confirm:$false -Force -ErrorAction Stop
            }
            catch {
                Write-Error "Unable to install PnP tools"
                break
            }
        }
        #EndRegion
        try {
            if ($url) {
                Write-Output "Connecting to $($url)"
                Connect-PnPOnline -Url $url -UseWebLogin
            }
        }
        catch {
            Write-Error "Cannot connect to site $($url)"
            break
        }
        if (-not($list)) {
            $list = Read-Host "Please Enter the name of the SharePointList"
        }
        # Chceck if list exists in site
        if ($list -notin $(Get-PnPList).title) {
            Write-Error "$($list) does not exist in SharePoint Site $($URL)"
            break
        }
        # EndRegion
    }
    process {
        if ($PSCmdlet.ShouldProcess(($ComputerName), "Adding to $($list)")) {
            try {
                #Memory
                $RAM = (Get-WMIObject -Class Win32_PhysicalMemory -ComputerName $ComputerName  | Measure-Object -Property capacity -Sum | ForEach-Object { [Math]::Round(($_.sum / 1GB), 2) })
                #CPUs
                $logicalCPUs = (Get-CimInstance -Class Win32_Processor -ComputerName $ComputerName | Measure-Object).Count
                #Disks
                $DiskInfo = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $ComputerName -ErrorAction Stop | Where-Object -Property DriveType -EQ 3
                foreach ($Disk in $DiskInfo) {
                    $Obj = New-Object -TypeName System.Management.Automation.PSObject
                    $Obj | Add-Member -MemberType NoteProperty -Name 'DriveLetter' -Value $($Disk.DeviceID)
                    $Obj | Add-Member -MemberType NoteProperty -Name 'TotalSize' -Value $($Disk.Size)
                    $Obj | Add-Member -MemberType NoteProperty -Name 'FreeSpace' -Value $($Disk.FreeSpace)
                    $Obj | Add-Member -MemberType NoteProperty -Name 'PercentFree' -Value ("{0:P}" -f ($Disk.FreeSpace / $Disk.Size))
                    $Obj | Add-Member -MemberType NoteProperty -Name 'PercentUsed' -Value ("{0:P}" -f (($Disk.Size - $Disk.FreeSpace) / $Disk.Size))
                    $diskTotalGB = $Obj.TotalSize | Select-Object @{Name = "total"; Expression = { [math]::round($_ / 1GB, 2) } }
                    $usedGB = ($disk.Size) - ($disk.FreeSpace) | Select-Object @{Name = "used"; Expression = { [math]::round($_ / 1GB, 2) } }
                
                
                    if ($Obj.DriveLetter -eq 'C:') {
                    
                        Add-PnPListItem -List $list -Values @{
                            HostName    = $ComputerName
                            DriveLetter = $Obj.DriveLetter
                            UsedSpace   = $usedGB.used
                            TotalSize   = $diskTotalGB.total
                            PercentFree = $obj.PercentFree
                            PercentUsed = $Obj.PercentUsed
                            CPUs        = $logicalCPUs
                            RAM         = $RAM
                            Application = $Application
                        } | Out-Null
                        Write-Verbose "Adding row to SharePoint List"
                    }
                    else {
                        Add-PnPListItem -List $list -Values @{
                            HostName    = $ComputerName
                            DriveLetter = $Obj.DriveLetter
                            UsedSpace   = $usedGB.used
                            TotalSize   = $diskTotalGB.total
                            PercentFree = $obj.PercentFree
                            PercentUsed = $Obj.PercentUsed
                            Application = $Application
                        } | Out-Null
                        Write-Verbose "Adding row to SharePoint List"
                    }
                }
            }
            Catch [System.UnauthorizedAccessException] {
                Write-Verbose "Access Denied - Could not connect to $($ComputerName) via WMI"
                Write-Error -Message 'Access Denied - Could not connect via WMI'
            }

        }
    }
    end {   
    }
}




