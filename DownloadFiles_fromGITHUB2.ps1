C:\Users\Administrator\Desktop\Json\turnertest.json

#--- Get-content of the turnertest.json file with option -raw
$j = ConvertFrom-Json -InputObject (gc C:\Users\Administrator\Desktop\Json\turnertest.json -Raw)
$j | Out-GridView
$j | Format-List