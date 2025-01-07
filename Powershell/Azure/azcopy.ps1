azcopy copy `
"https://cjptest01.blob.core.windows.net/test?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupitfx&se=2022-04-08T23:00:59Z&st=2022-04-08T15:00:59Z&spr=https&sig=1NRpkW5L%2B%2FCR7TcEoYuBXara8Nxu%2FF6dRdvM8PAqb%2FM%3D" `
"https://cjptest02.blob.core.windows.net/test?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupitfx&se=2022-04-08T23:01:25Z&st=2022-04-08T15:01:25Z&spr=https&sig=%2BPPfnpbE5aIs1hF6E8idCqlFMAIZgtT9kTLARAtQonw%3D" `
--overwrite false --recursive




New-AzStorageContainer 

azcopy sync `
"https://cjptest01.blob.core.windows.net/test/?sp=rl&st=2022-04-08T13:40:57Z&se=2022-04-08T21:40:57Z&spr=https&sv=2020-08-04&sr=c&sig=c1yDyyOdvHF79hnKnXx5kSg5Ny3Qb5GlpjrYmB8QsPk%3D" `
"https://cjptest02.blob.core.windows.net/test/?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupitfx&se=2022-04-08T22:28:54Z&st=2022-04-08T14:28:54Z&spr=https&sig=A4aYPWq5w2cACWLMMod1GT%2FWgdmmS8Qvt02X4x8A924%3D" `
--delete-destination true

azcopy copy "https://cjptest01.blob.core.windows.net/?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupitfx&se=2022-04-08T23:00:59Z&st=2022-04-08T15:00:59Z&spr=https&sig=1NRpkW5L%2B%2FCR7TcEoYuBXara8Nxu%2FF6dRdvM8PAqb%2FM%3D" "https://cjptest02.blob.core.windows.net/?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupitfx&se=2022-04-08T23:01:25Z&st=2022-04-08T15:01:25Z&spr=https&sig=%2BPPfnpbE5aIs1hF6E8idCqlFMAIZgtT9kTLARAtQonw%3D" --overwrite false --recursive


azcopy copy "https://cjptest01.blob.core.windows.net/test?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupitfx&se=2022-04-08T23:00:59Z&st=2022-04-08T15:00:59Z&spr=https&sig=1NRpkW5L%2B%2FCR7TcEoYuBXara8Nxu%2FF6dRdvM8PAqb%2FM%3D" "https://fldevstorageacc02.blob.core.windows.net/esbackup" --overwrite false --recursive