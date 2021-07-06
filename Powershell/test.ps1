$users = get-content -path "c:\temp\userListWithExclusions.txt"

foreach ($user in $users) {
    mkdir c:\users\33144\desktop\robologUsers\$user\
    robocopy "c:\test\$user"  c:\test3\$user /e /z /MT:8 /r:0 /w:0 /A-:SH /sec /purge /log:"c:\users\33144\desktop\robologusers\$user\robolog.txt"
}

