$names = get-content -path "c:\users\33144\desktop\names2.txt"
$names

$output = foreach ($name in $names) {

Get-ADReplicationAttributeMetadata (Get-ADObject -Identity $name -Properties UserAccountControl) -Server "LD9PDC01" | Where {$_.AttributeName -eq 'userAccountControl'} | Select AttributeName,LastOriginatingChangeTime,AttributeValue,Object

}
$output | export-csv c:\users\33144\output.csv


#Get-ADReplicationAttributeMetadata (Get-ADObject -Identity "CN=Mark Banyer1,OU=Disabled,OU=NonEmployee,DC=amtrustservices,DC=com" -Properties UserAccountControl) -Server "LD9PDC01" | Where {$_.AttributeName -eq 'userAccountControl'} | Select AttributeName,LastOriginatingChangeTime,AttributeValue,Object
