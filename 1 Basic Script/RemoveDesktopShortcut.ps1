$path = "$env:USERPROFILE\Desktop\Notepad.lnk"
if(Test-Path $path)
{
    Remove-Item $path -Force
}