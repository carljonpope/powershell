$comps = get-content -path "c:\users\33144\desktop\test.txt"
$output = foreach ($comp in $comps) {

$GWO_MappedDrives = get-wmiobject -Class win32_mappedlogicaldisk -ComputerName $comp

$MappedDrives = foreach ($GWOMD_Item in $GWO_MappedDrives)
    {
    [PSCustomObject]@{
        DriveLetter = $GWOMD_Item.Name
        Path = $GWOMD_Item.ProviderName
        Computer = $comp
        }
    }

$MappedDrives

}
$output
#$output | export-csv c:\temp\export.csv