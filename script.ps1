$basePath = Get-Location

# TODO: Replace this with your own paths
$functionPaths = @(
"$basePath/IdeaProjects/powershell-filemanager/io.ps1",
"$basePath/IdeaProjects/powershell-filemanager/validation.ps1"
)

# Import all functions from the files
foreach ($functionPath in $functionPaths)
{
    Write-Host "Importing functions from $functionPath"
    . $functionPath
}

# The main loop of the script that keeps running until the user exits
while ($true)
{
    Write-Menu
    $choice = Get-Menu-Choice
    try
    {
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

                if (!(Get-If-File-Exists $filename))
                {
                    throw "File doesn't exist"
                }

                # This works differently on windows and linux
                if ($IsWindows)
                {
                    # On windows, we can use notepad.exe
                    notepad.exe $filename
                }
                else
                {
                    # On linux, we can use the open command
                    open $filename
                }
                Write-Host "Open File"
            }
            3
            {
                Write-Host "Rename File"
                $oldFilePath = Read-Host "Enter the old Filepath"
                $newFilePath = Read-Host "Enter the new Filepath"

                if (!(Get-If-File-Exists $oldFilePath))
                {
                    throw "File doesn't exist"
                }
                elseif (Get-If-File-Exists $newFilePath)
                {
                    throw "File already exists"
                }

                # Rename the file
                Rename-Item -Path $oldFilePath -NewName $newFilePath
                Write-Host "Moved File"
            }
            4
            {
                Write-Host "Delete File"
                $filepath = Read-Host "Enter the Filepath"

                if (!(Get-If-File-Exists $filepath))
                {
                    throw "File doesn't exist"
                }

                # Delete the file
                Remove-Item -Path $filepath
                Write-Host "Deleted File"
            }
            5
            {
                Write-Host "List Files"
                # List all files in the current directory
                Get-ChildItem
                Write-Host "Listed Files"
            }
            6
            {
                Write-Host "Change Directory"
                $newDirectoryPath = Read-Host "Enter the new Directorypath"

                if (!(Get-If-File-Exists $newDirectoryPath))
                {
                    throw "Directory doesn't exist"
                }

                # Change the directory
                Set-Location $newDirectoryPath
                Write-Host "Changed Directory"
            }
            7
            {
                Write-Host "Zip File"
                $filepath = Read-Host "Enter path to file that needs to be zipped"

                if (!(Get-If-File-Exists $filepath))
                {
                    throw "File doesn't exist"
                }

                $currentDirectory = Get-Location

                # ask if user wants to zip with password
                $zipWithPassword = Read-Host "Do you want to zip with password? (y/n)"
                if ($zipWithPassword -eq "y")
                {
                    $password = Read-Host "Enter password"

                    $compressedFilePath = "$currentDirectory/$filepath.zip"
                    Compress-Archive -Path $filepath -DestinationPath $compressedFilePath

                    $memoryStream = [System.IO.MemoryStream]::new([byte[]][char[]]$password)
                    $md5Hash = (Get-FileHash -InputStream $memoryStream -Algorithm SHA256).Hash
                    $md5HashOnlyNumbers = [System.Text.RegularExpressions.Regex]::Replace($md5Hash, "[^0-9]", "")

                    $selectedFileAsBytes = [System.IO.File]::ReadAllBytes($compressedFilePath)
                    $byteArray = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($selectedFileAsBytes))

                    $bitshiftedString = ""

                    $bxor = $md5HashOnlyNumbers
                    if ($bxor.Length -gt 10)
                    {
                        $bxor = [int]$bxor.ToString().Substring(0, 9)
                    }
                    # it should be a int32, if not truncate it
                    if ($bxor -gt [char]::MaxValue)
                    {
                        $bxor = $bxor % [char]::MaxValue
                    }

                    Write-Host "Bxor: $bxor"
                    for ($i = 0; $i -lt $byteArray.Length; $i++)
                    {
                        $bitshiftedString += [char]([int]$byteArray[$i] -bxor $bxor)
                    }

                    $bitshiftedString | Out-File "$currentDirectory/$filepath.zip.enc"
                }
                else
                {
                    Compress-Archive -Path $filepath -DestinationPath "$currentDirectory/$filepath.zip"
                }

                Write-Host "File zipped"
            }
            8
            {
                Write-Host "Unzip File"
                $currentDirectory = Get-Location
                $filepath = Read-Host "Enter path to zip"

                if (!(Get-If-File-Exists $filepath))
                {
                    throw "File doesn't exist"
                }

                $newFilePath = $filepath -replace ".zip", ""

                # check if the file is encrypted (has .enc extension)
                if ( $filepath.EndsWith(".enc"))
                {
                    # ask for password
                    $password = Read-Host "Enter password"
                    $memoryStream = [System.IO.MemoryStream]::new([byte[]][char[]]$password)
                    $md5Hash = (Get-FileHash -InputStream $memoryStream -Algorithm SHA256).Hash
                    $md5HashOnlyNumbers = [System.Text.RegularExpressions.Regex]::Replace($md5Hash, "[^0-9]", "")

                    # read the encrypted file
                    $byteArray = Get-Content $filepath
                    $bitshiftedString = ""

                    $bxor = $md5HashOnlyNumbers
                    if ($bxor.Length -gt 10)
                    {
                        $bxor = [int]$bxor.ToString().Substring(0, 9)
                    }
                    # it should be a int32, if not truncate it
                    if ($bxor -gt [char]::MaxValue)
                    {
                        $bxor = $bxor % [char]::MaxValue
                    }

                    Write-Host "Bxor: $bxor"
                    for ($i = 0; $i -lt $byteArray.Length; $i++)
                    {
                        $bitshiftedString += [char]([int]$byteArray[$i] -bxor $bxor)
                    }
                    $byteArray = [System.Convert]::FromBase64String($bitshiftedString)
                    #                    Write-Host [System.Text.Encoding]::UTF8.GetString($byteArray).GetType()
                    #                    $zipFileAsBytesString = [System.Text.Encoding]::UTF8.GetString($byteArray)
                    #                    Write-Host "Zip file as bytes string: $zipFileAsBytesString"
                    #                    $zipFileAsBytes = [System.Text.Encoding]::UTF8.GetBytes($byteArray)
                    #                    Write-Host "Zip file as bytes: $zipFileAsBytes"
                    $zipFile = [System.IO.Path]::GetTempFileName()
                    [System.IO.File]::WriteAllBytes($zipFile, $byteArray)
                    $cleanedFilePath = $newFilePath -replace ".enc", ""
                    Expand-Archive -Path $zipFile -DestinationPath "$currentDirectory"
                    Write-Host "File unzipped"
                    break
                }

                Expand-Archive -Path $filepath -DestinationPath "$currentDirectory/$newFilePath"
                Write-Host "File unzipped"
            }
            9 {
                Write-Host "Merge Files"
                $currentDirectory = Get-Location
                $filepath = Read-Host "Enter path to first file"
                $filepath2 = Read-Host "Enter path to second file"
                $newFilePath = Read-Host "Enter path to new file"

                if (!(Get-If-File-Exists $filepath) -or !(Get-If-File-Exists $filepath2))
                {
                    throw "File doesn't exist"
                }

                $file1 = Get-Content $filepath
                $file2 = Get-Content $filepath2
                $combinedFile = $file1 + "`n" + $file2
                $combinedFile | Out-File $newFilePath
            }
            10
            {
                Write-Host "Exit Script"
                exit
                Write-Host "Script exitted"
            }
            11 {
                # TODO: remove, just for testing
                Set-Location "/home/$( whoami )/IdeaProjects/powershell-filemanager"
            }
            default
            {
                Write-Host "Please Input a valid option"
            }
        }
    }
    catch
    {
        #        Write-Host "Error: $_" -ForegroundColor Red
        Write-Error $_
    }

}