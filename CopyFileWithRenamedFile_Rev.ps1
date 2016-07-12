#===============================================================================================#
#--Purpose: Read all the logs from ARM templates results, rename each filename with its own   ==#
#--         template name which appears inside its log and added at the end of the filename   ==#
#--         and copy the new file to a different location of one's choice.                    ==#
#-- Requirements:  specify where the logs will be read from, like the one below               ==#
#--                $pathNDir = "F:\turner\Testlog"                                            ==#
#--                Specify where to save the new logs to, like the one below                  ==#
#--                $destinationPath="C:\Users\administrator\Desktop\turner"                   ==#
#===============================================================================================#

#-----------------------------------------------------------------------------------------------#
#-- Function getStringFromFile:                                                               --#
#-- This function will get the source path and the file name from function renamedFileAndCopy --#
#-- Then this function will search for the string name "DEPLOYMENTNAME" in the file, split    --#
#-- the found string and locate the string "DEPLOYMENTNAME"'s value and return to the         --#
#-- function caller                                                                           --#
#-----------------------------------------------------------------------------------------------#
function getStringFromFile
{
    param(
         [parameter(position=0)]
         $sourcePathNFilename 
        )
    $selectStr = "DEPLOYMENTNAME"
   
    #-- It will find and display the string of the file with $selectStr -----#
    $SecondSplitArr = @()   #-- Create an empty array to store Template strings ---#
    #[string[]] $SecondSplitArr =" "
    $foundStrs = Select-String -Path $sourcePathNFilename -Pattern $selectStr -CaseSensitive  
    $templateStr=""  #-- initialize empty string to the template string
   
    foreach($foundStr in $foundStrs)
    {
        #-- it's looking for the similar string as this -->"VERBOSE: RESOURCEGROUP=masrg1136 and DEPLOYMENTNAME=101-simple-windows-vm"  ---#
        #-- Split the string into 2 parts between the word "and"
         $firstSplit = $foundStr -split(" and ")        
        #-- Take the 2nd part of the first split, then split it again into 2 parts between the symbol "="  ----#
        $secondSplit = $firstSplit[1] -split("=")
       
        #-- Now do the comparision, take the first part of the 2nd split and compare it to $selectStr ---#
        if($secondSplit[0] -eq $selectStr)
        {
           #-- Save the ARM template name to the string array for later comparision.
           $templateStr = $secondSplit[1]
           $secondSplitArr += $templateStr        
        }
    }

    if($SecondSplitArr.length -eq 0)  #-- No template string found, it means that it's an error --#
    {
        return $templateStr = "Azure-Template-Not-Found"
    }
    Elseif($SecondSplitArr.length -eq 1) #-- Only one template in the file --#
    {
        return $SecondSplitArr[0]
    }
    Else    #-- More than one templates in the file, select the second TemplateName --#
    { 
        return $SecondSplitArr[1]
    }

}


#-----------------------------------------------------------------------------------------------#
#-- Function renamedFileAndCopy:                                                              --#
#-- This function will get the source path and the file name from input (parameter).          --#
#-- First, call the function getStringFromFile with passing the 'source path and file name'   --#
#-- parameter and will get back the name of 'ARMTemplateName'                                 --#
#-- The function then will split the input parameter down to path and file name.  Adding the  --#
#-- the 'AMRTemplateName' to the end of the file name. Finally copy the file from source to   --#
#-- the destination with the new filename.                                                    --#
#-----------------------------------------------------------------------------------------------#
function renamedFileAndCopy
{
    param(
     [parameter(position=0)]
         $srcPathAndFilename
    ) 
    #-- call the function getStringFromFile with path and file parameter, it will get the Azure template back --#
    $ARMTemplateName = getStringFromFile $srcPathAndFilename

    #-- Where to save the file to ---#
    $destinationPath="C:\Users\administrator\Desktop\turner"
      
    #-- Split the path and filename, then keep the filename only --#
    $getFilenameOnly = (Split-Path $srcPathAndFilename -leaf)#
    
    #-- Remove the extenstion name of the file --#
    $trimExtName = $getFilenameOnly.TrimEnd(".txt")
    
    #-- Add the template name at the end of the file and then add the extension back --#
    $addTemplateName = $trimExtName + "_"+ $($ARMTemplateName) + ".txt"
    
    #-- Now copy the source file to the destination with the template name being added at the end to the file --#
    $pathAndFilename = $destinationPath + "\" + $addTemplateName
    copy $srcPathAndFilename $pathAndFilename
}

#-- the line below is used for debugging purposes
#renamedFileAndCopy "F:\turner\Testlog\PowerShell_transcript.T3H5744-CON01.H20fN1iI.20160708163514.txt"

#-----------------------------------------------------------------------------------------------#
#-- Function getPathNFilenameDir:                                                             --#
#-- Select a path and folder where to get the file names. This will read all files in that    --#
#-- directory and call the function renamedFileAndCopy with each filename as its parameter    --#
#-----------------------------------------------------------------------------------------------#
function getPathNFilenameFrDir
{
   $pathNDir = "F:\turner\OginalLogs"
   $fileNames = Get-ChildItem $pathNDir | select Name

   Foreach($fileName in $fileNames)
   {
      $finalStr = $pathNDir +'\' + $fileName.Name
      #-- Call the function renamedFileAndCopy with parameter $finalStr --#
      renamedFileAndCopy $finalStr
   }
}
getPathNFilenameFrDir   #-- call the function --#
