# convert the following to powershell
#
#while :
#do
#echo "Display Menu"
#echo "[1] Create File"
#echo "[2] Edit File"
#echo "[3] Rename File"
#echo "[4] Delete File"
#echo "[5] List Files"
#echo "[6] Change Directory"
#echo "[7] Zip File"
#echo "[8] Unzip File"
#echo "[9] Exit Script"
#read choice
#
#case ${choice} in
#
#1)
#echo "Create File"
#echo "Enter the Filepath"
#read String filename
#echo "Created new File"
#;;
#
#2)
#echo "Edit File"
#echo "Enter the Filepath"
#read String filename
#echo "Open File"
#;;
#
#3)
#echo "Rename File"
#echo "Enter the old Filepath"
#read String oldFIlePath
#echo "Enter the new Filepath"
#read String newFilePath
#echo "Moved File"
#;;
#
#4)
#echo "Delete File"
#echo "Enter the Filepath"
#read String filepath
#echo "Deleted File"
#;;
#
#5)
#echo "List Files"
#echo "Listed Files"
#;;
#
#6)
#echo "Change Directory"
#echo "Enter the new Directorypath"
#read String newDirectoryPath
#echo "Changed Directory"
#;;
#
#7)
#echo "Zip File"
#echo "Enter path to file that needs to be zipped"
#read String filepath
#echo "File zipped"
#;;
#
#8)
#echo "Unzip File"
#echo "Enter path to zip"
#read String filepath
#echo "File unzipped"
#;;
#
#9)
#echo "Exit Script"
#echo "Script exitted"
#;;
#
#*)
#echo "Please Input a valid option"
#;;
#esac
#
#done

while ($true)
{
    Write-Host "Display Menu"
    Write-Host "[1] Create File"
    Write-Host "[2] Edit File"
    Write-Host "[3] Rename File"
    Write-Host "[4] Delete File"
    Write-Host "[5] List Files"
    Write-Host "[6] Change Directory"
    Write-Host "[7] Zip File"
    Write-Host "[8] Unzip File"
    Write-Host "[9] Exit Script"
    $choice = Read-Host "Enter your choice"
    switch ($choice)
    {
        1
        {
            Write-Host "Create File"
            $filename = Read-Host "Enter the Filepath"
            New-Item -Path $filename -ItemType File
            Write-Host "Created new File"
        }
        2
        {
            Write-Host "Edit File"
            $filename = Read-Host "Enter the Filepath"
            #            Open-EditorFile $filename
            #            # this doesn't work on linux
            #            # notepad.exe $filename:x:x
            open $filename
            Write-Host "Open File"
        }
        3
        {
            Write-Host "Rename File"
            $oldFilePath = Read-Host "Enter the old Filepath"
            $newFilePath = Read-Host "Enter the new Filepath"
            Rename-Item -Path $oldFilePath -NewName $newFilePath
            Write-Host "Moved File"
        }
        4
        {
            Write-Host "Delete File"
            $filepath = Read-Host "Enter the Filepath"
            Remove-Item -Path $filepath
            Write-Host "Deleted File"
        }
        5
        {
            Write-Host "List Files"
            Get-ChildItem
            Write-Host "Listed Files"
        }
        6
        {
            Write-Host "Change Directory"
            $newDirectoryPath = Read-Host "Enter the new Directorypath"
            Set-Location $newDirectoryPath
            Write-Host "Changed Directory"
        }
        7
        {
            Write-Host "Zip File"
            $filepath = Read-Host "Enter path to file that needs to be zipped"
            $currentDirectory = Get-Location
            Compress-Archive -Path $filepath -DestinationPath "$currentDirectory\$filepath.zip"
            Write-Host "File zipped"
        }
        8
        {
            Write-Host "Unzip File"
            $filepath = Read-Host "Enter path to zip"
            $newFilePath = $filepath -replace ".zip", ""
            $currentDirectory = Get-Location
            Expand-Archive -Path $filepath -DestinationPath "$currentDirectory\$newFilePath"
            Write-Host "File unzipped"
        }
        9
        {
            Write-Host "Exit Script"
            exit
            Write-Host "Script exitted"
        }
        default
        {
            Write-Host "Please Input a valid option"
        }
    }
}