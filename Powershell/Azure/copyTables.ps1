cd "C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy"
.\azcopy.exe /Source:"https://devdistributionsa01.table.core.windows.net/Recipient" /Dest:"C:\Azure\Migration\Distribution\Recipient" /SourceSAS:"?sv=2021-06-08&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2022-09-15T23:06:49Z&st=2022-09-15T15:06:49Z&spr=https&sig=FAE9YmAiy7zKX4bJuQMambAVPVw8lGBlBCYZzjXMXDE%3D" /Manifest:Recipient.manifest /SplitSize:128

cd "C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy"
.\azcopy.exe /Dest:"https://icsfcsdevuksouthd10nsa01.table.core.windows.net/Distribution" /source:"C:\Azure\Migration\Distribution\Distribution" /DestSAS:"?sv=2021-06-08&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2022-09-15T23:18:03Z&st=2022-09-15T15:18:03Z&spr=https&sig=LQ0O4pikp%2BFxzuBLKOpr4%2BzsFdztgAtTD4h4xLEbCHs%3D" /Manifest:Distribution.manifest /EntityOperation:InsertOrReplace
