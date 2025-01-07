Get-ADGroupMember -identity afsi_dublin_users | select name, samaccountname | export-csv c:\temp\afsi_dublin_users.csv
