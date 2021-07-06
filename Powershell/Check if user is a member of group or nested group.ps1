$user = "Jose Garcia"
$group = "Bitlocker Recovery Admins"
$members = Get-ADGroupMember -Identity $group -Recursive | Select -ExpandProperty Name

If ($members -contains $user) {
      Write-Host "$user exists in the group"
 } Else {
        Write-Host "$user not exists in the group"
}