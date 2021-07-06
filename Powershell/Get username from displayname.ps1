Import-Module activedirectory
$displayname = @()
$names = get-content "c:\temp\swedenusers.txt"
foreach ($name in $names) {


$displaynamedetails = Get-ADUser -filter { DisplayName -eq $name } | Select name,samAccountName

$displayname += $displaynamedetails

}

$displayname | Export-Csv "C:\temp\Samaccountname.csv"