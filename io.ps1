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

    #    Write-Host "1. Create File"
    #    Write-Host "2. Edit File"
    #    Write-Host "3. Rename File"
    #    Write-Host "4. Delete File"
    #    Write-Host "5. List Files"
    #    Write-Host "6. Change Directory"
    #    Write-Host "7. Zip File"
    #    Write-Host "8. Unzip File"
    #    Write-Host "9. Exit Script"
}

function Get-Menu-Choice()
{
    $menuChoice = Read-Host "Enter your choice"
    return $menuChoice
}