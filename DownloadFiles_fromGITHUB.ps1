<#[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$client = New-Object System.Net.WebClient

https://raw.githubusercontent.com/Azure/AzureStack-QuickStart-Templates/master/101-simple-windows-vm/azuredeploy.json

$client.Headers.Add("Authorization","token 1234567890notarealtoken987654321")
$client.Headers.Add("Accept","application/vnd.github.v3.raw")

$client.Headers.
#$client.DownloadFile("https://github.company.com/api/v3/repos/me/my_repo/contents/test/test-script.ps1?ref=branch_I_need","C:\temp\test-script.ps1”)
$client.DownloadFile("https://raw.githubusercontent.com/Azure/AzureStack-QuickStart-Templates/master/101-simple-windows-vm/azuredeploy.json","C:\temp\test-script.json”)

#>
#-----------------
$filesToDownload = (

"https://raw.githubusercontent.com/Azure/AzureStack-QuickStart-Templates/master/101-simple-windows-vm/azuredeploy.json"
)
$webClient = new-object System.Net.WebClient

$destPath = "C:\AzureTemplates"

#--- % means foreach-object, $_ means placeholder --#
$filesToDownload | % { 
    $uri = new-Object System.Uri $_ ; 
    #$localPath =  "$($pwd.Path)\$($uri.Segments[-1])"; 
    $localpath = "$destPath\$($uri.segments[-1])"
    Write-Host "Writing $localPath" ;
    $webClient.DownloadFile($uri,$localPath); 
  $($uri.Segments[-2])
}


#$filesToDownload | New-Object System.Uri

New-Object System.Uri $filesToDownload
New-Object System.Uri "https://raw.githubusercontent.com/Azure/AzureStack-QuickStart-Templates/master/101-simple-windows-vm/azuredeploy.json"


for ($i=1; $i -lt 10; $i++) {
  Write-Progress -Activity "Working..." -PercentComplete $i # -CurrentOperation "$i% complete" -Status "Please wait."
  Start-Sleep 1
}