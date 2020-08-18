# For the Envoy deployment, need to sync AZ AD users based on Street Address and City. Sync is performed usinng Azure SCIM.

Need to check that street address is the same for all users in Cor089GGEnvoy group

```
get-azureadgroupmember -objectid xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | select displayname | out-file C:\users\xxxxxx\desktop\users.txt
```

Only displays small number of users in group, maybe because dynamic group. Unable to export from AD because US domain group and no permissions.

Instead, export from GUI (Bulk activities > Download members) to userdIds.txt

Compile list of street addresses

```
$users = ForEach ($user in $(Get-Content C:\Users\xxxxxx\Downloads\usersIds.txt))
 {

   Get-azureAdUser -objectid "$user" | select streetaddress | export-csv c:\users\xxxxxx\downloads\street.csv -append
        
}
```
