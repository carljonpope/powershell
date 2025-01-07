Remove-NTFSAccess "d:\File Shares\AMT_Agenzia" -Account "xxxxxxxxx\Milan AMT Agenzia Modify"  -AccessRights Modify -PassThru -appliesto ThisFolderSubfoldersAndFiles
Remove-NTFSAccess "d:\File Shares\AmtrustItalia" -Account "xxxxxxxxx\Milan AmtrustItalia Drive Modify" -AccessRights Modify -PassThru -appliesto ThisFolderSubfoldersAndFiles
Remove-NTFSAccess "d:\File Shares\AmtrustItalia" -Account "xxxxxxxxx\Milan AmtrustItalia Drive Read Only" -AccessRights ReadAndExecute -PassThru -appliesto ThisFolderSubfoldersAndFiles

$paths = "d:\File Shares\contabilita\Autorizzazioni - Pagamenti Kyriba - Contabili\Pagamenti - Addebiti Bancari (Contabili)\AIAI", "d:\File Shares\contabilita\Autorizzazioni - Pagamenti Kyriba - Contabili\Pagamenti - Addebiti Bancari (Contabili)\AIS", "d:\File Shares\contabilita\Contabilità\CO.GE\AMTRUST INSURANCE AGENCY ITALY", "d:\File Shares\contabilita\Contabilità\CO.GE\AMTRUST ITALIA SRL", "d:\File Shares\contabilita\Contabilità\CO.GE\Contratti\contratti OLD_da verificare se attivi\AMTRUST INSURANCE AGENCY", "d:\File Shares\contabilita\Contabilità\CO.GE\Contratti\contratti OLD_da verificare se attivi\AMTRUST ITALIA", "d:\File Shares\contabilita\Contabilità\CO.GE\COSTO DEL PERSONALE\2019\AIAI", "d:\File Shares\contabilita\Contabilità\CO.GE\COSTO DEL PERSONALE\2019\AIS", "d:\File Shares\contabilita\Contabilità\CO.GE\COSTO DEL PERSONALE\2020\AIAI", "d:\File Shares\contabilita\Contabilità\CO.GE\COSTO DEL PERSONALE\2020\AIS", "d:\File Shares\contabilita\Contabilità\CO.GE\COSTO DEL PERSONALE\2021\AIAI", "d:\File Shares\contabilita\Contabilità\CO.GE\COSTO DEL PERSONALE\BONUS\2020\AIAI", "d:\File Shares\contabilita\Contabilità\CO.GE\COSTO DEL PERSONALE\BONUS\2021\AIAI", "d:\File Shares\contabilita\Contabilità\CO.GE\FATTURAZIONE ELETTRONICA\ELENCO FATTURE ELETTRONICHE RICEVUTE\AIAI", "d:\File Shares\contabilita\Contabilità\CO.GE\FATTURAZIONE ELETTRONICA\ELENCO FATTURE ELETTRONICHE RICEVUTE\AIS", "d:\File Shares\contabilita\Contabilità\CO.GE\FATTURAZIONE ELETTRONICA\QR CODE\AIAI", "d:\File Shares\contabilita\Contabilità\CO.GE\FATTURAZIONE ELETTRONICA\QR CODE\AIS", "d:\File Shares\contabilita\Contabilità\CO.GE\FILE CARICAMENTO ORACLE\AIAIT", "d:\File Shares\contabilita\Contabilità\CO.GE\FILE CARICAMENTO ORACLE\AIT", "d:\File Shares\contabilita\Estratti Conto Provvigionali AIAI - AIS", "d:\File Shares\contabilita\Movimenti Banca\AmTrust Insurance Agency Italy SRL", "d:\File Shares\contabilita\Movimenti Banca\AmTrust Italia Srl - Fusione 31122019", "d:\File Shares\contabilita\Petty Cash\AIAI", "d:\File Shares\contabilita\Petty Cash\AIS - Carta Estinta a Gennaio 2020", "d:\File Shares\contabilita\Rimesse AIAI-AIS to AEL-AIUD-AAS"

foreach ($path in $paths) {

    Remove-NTFSAccess $path -Account "xxxxxxxxx\Milan Contabilità Drive Modify" -AccessRights Modify -PassThru -appliesto ThisFolderSubfoldersAndFiles
    Remove-NTFSAccess $path -Account "xxxxxxxxx\Milan Contabilità Drive Read Only" -AccessRights ReadAndExecute -PassThru -appliesto ThisFolderSubfoldersAndFiles

}

$paths = "d:\File Shares\Incassi e scadenze Medmal\MICRODATA_PROGETTO ESTRATTI CONTO\EC inviati a Microdata\EC INVIATI A PARTIRE DAL 20.11.2017", "d:\File Shares\Incassi e scadenze Medmal\RITENUTE D'ACCONTO BROKER\AIAI", "d:\File Shares\Incassi e scadenze Medmal\RITENUTE D'ACCONTO BROKER\AIS"

foreach ($path in $paths) {

    Remove-NTFSAccess $path -Account "xxxxxxxxx\Milan Incassi e Scadenze Medmal Drive Modify" -AccessRights Modify -PassThru -appliesto ThisFolderSubfoldersAndFiles
    Remove-NTFSAccess $path -Account "xxxxxxxxx\Milan Incassi e Scadenze Medmal Drive Read Only" -AccessRights ReadAndExecute -PassThru -appliesto ThisFolderSubfoldersAndFiles

}

$paths = "d:\File Shares\Microdata\FATTURE ELETTRONICHE\AIAI", "d:\File Shares\Microdata\FATTURE ELETTRONICHE\AIS", "d:\File Shares\Microdata\RECUPERO INCASSI GENNAIO_MAGGIO_2018\AIAI", "d:\File Shares\Microdata\RECUPERO INCASSI GENNAIO_MAGGIO_2018\AIS", "d:\File Shares\Microdata\REGISTRI IPT\CONTABILI\AIAI 11196 - EX AIS", "d:\File Shares\Microdata\REGISTRI IPT\CONTABILI\AIAI 47287", "d:\File Shares\Microdata\REGISTRI IPT\CONTABILI\AIS", "d:\File Shares\Microdata\SCANSIONI MICRODATA FALDONI GEN-MAG 2018\AIAI", "d:\File Shares\Microdata\SCANSIONI MICRODATA FALDONI GEN-MAG 2018\AIS"

foreach ($path in $paths) {

    Remove-NTFSAccess $path -Account "xxxxxxxxx\Milan Microdata Modify" -AccessRights Modify -PassThru -appliesto ThisFolderSubfoldersAndFiles

}
 
Remove-NTFSAccess "d:\File Shares\PTF MNG\INCASSI" -Account "xxxxxxxxx\Milan PTF MNG Modify" -AccessRights Modify -PassThru -appliesto ThisFolderSubfoldersAndFiles
Remove-NTFSAccess "d:\File Shares\PTF MNG\INCASSI" -Account "xxxxxxxxx\Milan PTF MNG Read Only" -AccessRights ReadAndExecute -PassThru -appliesto ThisFolderSubfoldersAndFiles
