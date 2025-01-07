function get-blocks {
    [CmdletBinding()]

    param (
        [Parameter(ValueFromPipeline)]
        [string]$Message
    )

    begin {
        write-host "this is the first item" -foregroundcolor Blue
    }

    process {
        write-host "these are all the messages $($message)" -ForegroundColor Green
    }

    end {
        write-host "this is the last message" -ForegroundColor Red

    }

}

function Get-ComputerInformation {

    

    Param ( 
	[Parameter(Mandatory = $true, Position = 0)] 
	[string]$filepath 
    ) 
    
    $servers = get-content $filepath
    $report = @()

    foreach ($server in $servers) {

        $cpus = (get-ciminstance -classname cim_computersystem -computername $server).numberoflogicalprocessors
        $ram = (Get-CimInstance -classname cim_PhysicalMemory -computername $server| Measure-Object -Property capacity -Sum).sum /1gb
        $disks = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $server | Where-Object DriveType -EQ '3'

        foreach ($disk in $disks) {
            $Obj = New-Object -TypeName System.Management.Automation.PSObject
            $Obj | Add-Member -MemberType NoteProperty -Name 'ComputerName' -Value $($Disk.SystemName)
            $Obj | Add-Member -MemberType NoteProperty -Name 'DriveLetter' -Value $($Disk.DeviceID)
            $Obj | Add-Member -MemberType NoteProperty -Name 'Compressed' -Value $($Disk.Compressed)
            $Obj | Add-Member -MemberType NoteProperty -Name 'TotalSize' -Value $($Disk.Size/1gb)
            $Obj | Add-Member -MemberType NoteProperty -Name 'UsedSpace' -Value (($Disk.Size - $Disk.FreeSpace)/1gb)
            $Obj | Add-Member -MemberType NoteProperty -Name 'PercentFree' -Value ("{0:P}" -f ($Disk.FreeSpace/$Disk.Size))
            $Obj | Add-Member -MemberType NoteProperty -Name 'PercentUsed' -Value ("{0:P}" -f (($Disk.Size - $Disk.FreeSpace)/$Disk.Size))
            $obj | Add-Member -MemberType NoteProperty -Name 'CPUs' -Value $cpus
            $obj | Add-Member -MemberType NoteProperty -Name 'RAM' -Value $ram
            $report += $Obj
        }
    }

    $report | Export-Csv C:\temp\computerInfo.csv -NoTypeInformation

}

Get-ComputerInformation C:\temp\serverlist.txt