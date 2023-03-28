function Write-Menu()
{
    Write-Host "[1] Create File"
    Write-Host "[2] Edit File"
    Write-Host "[3] Rename File"
    Write-Host "[4] Delete File"
    Write-Host "[5] List Files"
    Write-Host "[6] Change Directory"
    Write-Host "[7] Zip File"
    Write-Host "[8] Unzip File"
    Write-Host "[9] Exit Script"
}

# This function prints out "Choice" and returns the user input.
function Get-Menu-Choice()
{
    return Read-Host "Choice"
}

function Get-File-Existance-State($filepath)
{
    if (Test-Path $filepath)
    {
        return $true
    }
    return $false
}

# It runs until the user selects the 9th menu option to exit the application.
while ($true)
{
    # Program prints out the menu and asks for the users action choice on every iteration.
    Write-Menu
    $choice = Get-Menu-Choice
    try
    {
        switch ($choice)
        {
            1
            {
                Write-Host "Create File"
                $filename = Read-Host "Filepath"
                New-Item -Path $filename -ItemType File
                Write-Host "Created a new file"
            }
            2
            {
                Write-Host "Edit File"
                $filename = Read-Host "Filepath"

                if (!(Get-File-Existance-State $filename))
                {
                    throw "File does not exist!"
                }
                open $filename
                Write-Host "Open file"
            }
            3
            {
                Write-Host "Rename file"
                $oldFilePath = Read-Host "Old filepath"
                $newFilePath = Read-Host "New filepath"

                if (!(Get-File-Existance-State $oldFilePath))
                {
                    throw "Path does not exist!"
                }
                elseif (Get-File-Existance-State $newFilePath)
                {
                    throw "File already exists!"
                }

                Rename-Item -Path $oldFilePath -NewName $newFilePath
                Write-Host "Moved File"
            }
            4
            {
                Write-Host "Delete File"
                $filepath = Read-Host "Filepath"

                if (!(Get-File-Existance-State $filepath))
                {
                    throw "File does not exist!"
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
                $newDirectoryPath = Read-Host "New directory path"

                if (!(Get-File-Existance-State $newDirectoryPath))
                {
                    throw "Directory does not exist!"
                }

                Set-Location $newDirectoryPath
                Write-Host "Changed Directory"
            }
            7
            {
                Write-Host "Zip File"
                $filepath = Read-Host "File path to zip"

                if (!(Get-File-Existance-State $filepath))
                {
                    throw "File does not exist!"
                }
                $currentDirectory = Get-Location
                Compress-Archive -Path $filepath -DestinationPath "$currentDirectory/$filepath.zip"
                Write-Host "File zipped"
            }
            8
            {
                Write-Host "Unzip File"
                $currentDirectory = Get-Location
                $filepath = Read-Host "File path to unzip"

                if (!(Get-File-Existance-State $filepath))
                {
                    throw "File does not exist!"
                }
                $newFilePath = $filepath -replace ".zip", ""
                Expand-Archive -Path $filepath -DestinationPath "$currentDirectory/$newFilePath"
                Write-Host "File unzipped"
            }
            9
            {
                Write-Host "Exit Script"
                exit
                Write-Host "Ended script"
            }
            default
            {
                Write-Host "Input not valid. Please choose from these options"
            }
        }
    }
    catch
    {
        Write-Error $_
    }
}