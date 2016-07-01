function copyFile
{
    param(
    [string] $fromFile,
    [string] $toPathNFile
    )

$frFile = [io.file]::OpenRead($fromFile)
$toFile = [io.file]::OpenWrite($toPathNFile)

  try
  {
    #[byte[]] $buffArr = New-Object byte[] 8192  #-- assing 1KB to a buffer
    [byte[]] $buffArr = New-Object byte[] 4096  #-- assign 4KB to a buffer
    #[byte[]] $buffArr = New-Object byte[] 1024
    [long] $totalBytes = 0
    [long] $countBytes = 0

    do
    {  
        #--- read(byte[] array, int offset, int count)
        #-- if the inputFile is smaller than $buffArr, then it will read all at once time.
        #-- if the inputFile is larger than $buffArr, then it will need to read mulitple times
        #-- until end of file. $countBytes will determine that number of bytes of the file.
        $countBytes = $frFile.read($buffArr,0, $buffArr.Length)

        #--- write(byte[] array, int offset, int count)
        $toFile.write($buffArr,0,$countBytes)

        $totalBytes += $countBytes
        #-- Below will be using for progressive bar --#
      #  if($countBytes % 1KB -eq 0) #-- if $countBytes is divisible by 1MB (zero remainder), will loop it
      #  {
            #-- number of bytes being read over the file.length
            [int]$result = $totalBytes/$frFile.length * 100
            Write-Progress -Activity "Copying $fromFile --> $toPathNFile" -Status "$result% complete" -PercentComplete $result
           #Start-Sleep 1
       # }
    }while($countBytes -gt 0)  #-- $countBytes is not EOF, then repeats the loop, until EOF.
  }
  finally
  {
    $frFile.dispose()
    $toFile.dispose()
  }


}

#CopyFile -from "C:\NanoServers\NanoServer.wim" -to "C:\AzureTemplates\NanoServer.wim"
copyFile -from "C:\turnerTest.txt" -to "C:\AzureTemplates\TurnerTest.txt"