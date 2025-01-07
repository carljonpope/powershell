enter-pssession -computername stk-file0
get-wmiobject -class win32_share
get-wmiobject -class win32_share | % {Path = $_.Path ; get-acl -path $path} | Export-Csv C:\users\33144\Desktop\export.csv