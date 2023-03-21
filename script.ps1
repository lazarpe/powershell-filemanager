$basePath = Get-Location

# Replace this with your own paths
$functionPaths = @(
"$basePath/IdeaProjects/powershell-filemanager/io.ps1",
"$basePath/IdeaProjects/powershell-filemanager/validation.ps1"
)

foreach ($functionPath in $functionPaths)
{
    Write-Host "Importing functions from $functionPath"
    . $functionPath
}

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

                if ($IsWindows)
                {
                    notepad.exe $filename
                }
                else
                {
                    open $filename
                }
                #            Open-EditorFile $filename
                #            # this doesn't work on linux
                #            # notepad.exe $filename:x:x
                #            open $filename
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

                if (!(Get-If-File-Exists $newDirectoryPath))
                {
                    throw "Directory doesn't exist"
                }

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
                    $password = Read-Host "Enter password" -AsSecureString

                    Compress-Archive -Path $filepath -DestinationPath "$currentDirectory/$filepath.zip"
                    $encryptedFile = "$currentDirectory/$filepath.zip"
                    Write-Host "Encrypted file: $encryptedFile"
                    $zipFileAsBytesString = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($encryptedFile))
                    Write-Host "Zip file as bytes string: $zipFileAsBytesString"
                    $base64String = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($zipFileAsBytesString))
                    Write-Host "Base64 string: $base64String"
                    $bitshiftedString = ""
                    for ($i = 0; $i -lt $base64String.Length; $i++)
                    {
                        $bitshiftedString += [char]([int]$base64String[$i] -bxor $password.Length * $base64String.Length)
                    }
                    Write-Host "Bitshifted string: $bitshiftedString"
                    Write-Host "Bytes string encrypted with password: $bytesStringEncryptedWithPassword"
                    $bitshiftedString | Out-File "$currentDirectory/$filepath.zip.enc"
                    Remove-Item $encryptedFile -Force
                    Write-Host "Encrypted file saved to: $currentDirectory/$filepath.zip.enc"
                }
                else
                {
                    Compress-Archive -Path $filepath -DestinationPath "$currentDirectory/$filepath.zip"
                }

                #            Compress-Archive -Path $filepath -DestinationPath "$currentDirectory\$filepath.zip"
                #            # make a second zip file with password and encryption
                #            Compress-Archive -Path $filepath -DestinationPath "$currentDirectory\$filepath.zip" -Password "password" -EncryptionAlgorithm AES256
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
                    $password = Read-Host "Enter password" -AsSecureString

                    # read the encrypted file
                    $encryptedFile = Get-Content $filepath
                    Write-Host "Encrypted file: $encryptedFile"
                    $bitshiftedString = ""
                    for ($i = 0; $i -lt $encryptedFile.Length; $i++)
                    {
                        $bitshiftedString += [char]([int]$encryptedFile[$i] -bxor $password.Length * $base64String.Length)
                    }
                    Write-Host "Bitshifted string: $bitshiftedString"
                    $base64String = [System.Convert]::FromBase64String($bitshiftedString)
                    Write-Host "Base64 string: $base64String"
                    $zipFileAsBytesString = [System.Text.Encoding]::UTF8.GetString($base64String)
                    Write-Host "Zip file as bytes string: $zipFileAsBytesString"
                    $zipFileAsBytes = [System.Convert]::FromBase64String($zipFileAsBytesString)
                    Write-Host "Zip file as bytes: $zipFileAsBytes"
                    $zipFile = [System.IO.Path]::GetTempFileName()
                    Write-Host "Zip file: $zipFile"
                    [System.IO.File]::WriteAllBytes($zipFile, $zipFileAsBytes)
                    Write-Host "Zip file saved to: $zipFile"
                    $cleanedFilePath = $newFilePath -replace ".enc", ""
                    Expand-Archive -Path $zipFile -DestinationPath "$currentDirectory/$cleanedFilePath"
                    Write-Host "File unzipped"
                    break
                }

                Expand-Archive -Path $filepath -DestinationPath "$currentDirectory/$newFilePath"
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
    catch
    {
#        Write-Host "Error: $_" -ForegroundColor Red
        Write-Error $_
    }

}