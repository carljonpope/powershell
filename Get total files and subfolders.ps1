$paths = get-content -path "c:\temp\paths.txt"

$output = @()

foreach ($path in $paths) {


    $size = (Get-ChildItem -path $path -Recurse | Measure-Object).Count

    $Obj = New-Object -TypeName System.Management.Automation.PSObject
    $Obj | Add-member -MemberType NoteProperty -Name 'Folder' -value $path
    $Obj | Add-member -MemberType NoteProperty -Name 'Size' -value $size
    $output += $Obj
}

$output | Export-Csv c:\temp\sizes.csv -NoTypeInformation