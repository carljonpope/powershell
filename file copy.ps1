$paths = get-content -path "c:\temp\localpaths.txt"
foreach ($path in $paths) {

$trimPath = $path.trimstart("d:\File Shares")
mkdir c:\users\a33144\desktop\robolog\$trinPath\
robocopy $path \\ld9nas01\italy_files$\Shares\Milan\AIAI\$trimPath /e /z /MT:8 /r:0 /w:0 /A-:SH /sec /purge /log:"c:\users\33144\desktop\robolog\$trimPath\robolog.txt"

}