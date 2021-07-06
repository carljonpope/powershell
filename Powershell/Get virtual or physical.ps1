$comps = get-content c:\users\33144\desktop\comps.txt

foreach ($comp in $comps) {

 $man = (get-wmiobject -computer $comp win32_computersystem).manufacturer


#Store the information from this run into the array  
       [PSCustomObject]@{
       SystemName = $comp
       System = $man
      
       } | Export-Csv C:\users\33144\desktop\output.csv -notype -Append 
  }