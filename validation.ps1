# this function will return true if the file exists and false if it doesn't
function Get-If-File-Exists($filepath)
{
    return Test-Path $filepath
}