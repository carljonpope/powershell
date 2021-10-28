$vnets = get-azvirtualnetwork


foreach ($vnet in $vnets) {

    $row = New-Object psobject
    $row | Add-Member -MemberType NoteProperty -name "VNetName" -value $vnet.name

    $addrSpace = $vnet.AddressSpace | Select-Object @{ n='addrPrefix'; e={$_.AddressPrefixes -join '; ' } }
    $row | Add-Member -MemberType NoteProperty -name "AddressSpace" -value $addrSpace.addrPrefix


    Export-Csv C:\temp\testVnets.csv -Append -InputObject $row



}
<#

#$vnet = get-azvirtualnetwork -Name vnet1
#$addrSpace = $vnet.AddressSpace | Select-Object @{ n='range'; e={$_.AddressPrefixes -join ' ' } }

#$addrspace.range.split()

foreach ($vnet in $vnets) {

    $row = New-Object psobject
    $row | Add-Member -MemberType NoteProperty -name "VNetName" -value $vnet.name

    $addrSpace = $vnet.AddressSpace | Select-Object @{ n='range'; e={$_.AddressPrefixes -join ';' } }
    $row | Add-Member -MemberType NoteProperty -name "addrSpace" -value $addrSpace.range.split()


    Export-Csv C:\temp\testVnets.csv -Append -InputObject $row



}#>