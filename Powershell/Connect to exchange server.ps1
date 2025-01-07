$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://ld9pmail01.xxxxxx.com/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session -DisableNameChecking
