function Get-If-File-Exists($filepath)
{
    if (Test-Path $filepath)
    {
        return $true
    }
    else
    {
        return $false
    }
}