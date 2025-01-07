$vnets = get-azvirtualnetwork

$output = foreach ($vnet in $vnets) {
    $vnet.name
    $vnet.addressspace.Addressprefixes


}
$output
$output | out-file C:\temp\flDevVnets.txt

