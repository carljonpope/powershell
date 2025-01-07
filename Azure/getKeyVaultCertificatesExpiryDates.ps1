$keyVaults = get-azkeyvault
$output = foreach ($vault in $keyVaults) {
    $certificates = Get-AzKeyVaultCertificate -VaultName $vault.vaultname
        foreach ($certificate in $certificates) {

            if ($certificate.expires -ne $null) {
                    [PSCustomObject]@{
                        VaultName = $vault.vaultname
                        Name = $certificate.name
                        Expiry = $certificate.expires
                    }
            }
        }
}
$output | export-csv -path c:\temp\devcerts.csv -NoTypeInformation