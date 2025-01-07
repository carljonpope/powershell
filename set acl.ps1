$paths = get-content -path "c:\temp\paths.txt"
$identity = 'xxxxxxxxx\33144'
$rights = 'FullControl'
$inheritance = 'ContainerInherit, ObjectInherit'
$propagation = 'None'
$type = 'Allow'
$ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation, $type)

foreach ($path in $paths) {

    $ACL = Get-Acl -Path $path
    $acl | Format-List
    $ACL.SetAccessRuleProtection($true,$false)
    $Acl.AddAccessRule($ACE)
    #$ACL | Set-Acl -Path $path
    #$Acl.AddAccessRule($ACE)
    Set-Acl -Path $path -AclObject $Acl
}



<# Create the ACE
$identity = 'xxxxxxxxx\33144'
$rights = 'FullControl' #Other options: [enum]::GetValues('System.Security.AccessControl.FileSystemRights')
$inheritance = 'None' #Other options: [enum]::GetValues('System.Security.AccessControl.Inheritance')
$propagation = 'None' #Other options: [enum]::GetValues('System.Security.AccessControl.PropagationFlags')
$type = 'Allow' #Other options: [enum]::GetValues('System.Securit y.AccessControl.AccessControlType')
$ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation, $type)

$Acl = Get-Acl -Path "c:\test4"
$Acl.AddAccessRule($ACE)

Set-Acl -Path "c:\test4" -AclObject $Acl
#>
