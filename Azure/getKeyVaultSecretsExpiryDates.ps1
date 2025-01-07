$keyVaults = get-azkeyvault
$output = foreach ($vault in $keyVaults) {
    $secrets = Get-AzKeyVaultSecret -VaultName $vault.vaultname
        foreach ($secret in $secrets) {

            if ($secret.expires -ne $null) {
                    [PSCustomObject]@{
                        VaultName = $vault.vaultname
                        Name = $secret.name
                        Expiry = $secret.expires
                    }
            }
        }
}
$output | export-csv -path c:\temp\prdsecrets.csv -NoTypeInformation