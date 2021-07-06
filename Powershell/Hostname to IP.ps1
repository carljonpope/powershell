function Get-HostToIP($hostname) {     
    $result = [system.Net.Dns]::GetHostByName($hostname)     
    $result.AddressList | ForEach-Object {$_.IPAddressToString } 
} 

$servers = Get-Content "c:\temp\Servers.txt"
$output = foreach ($server in $servers) {

#$server

Get-HostToIP($server)

}


New-Object -TypeName PSCustomObject -Property @{
server = $server
ip = $output

} | Export-Csv -Path c:\temp\addresses.csv -NoTypeInformation -Append


#$output | out-file c:\temp\addresses.txt



# | ForEach-Object {(Get-HostToIP($_)) >> c:\temp\Addresses.txt}
