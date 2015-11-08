[cmdletbinding()]
param(
    $Source,
    [string]$Destination = "$env:USERPROFILE\Desktop"
)

if(Test-Path $Source)
{
    $SourceFile   = Get-ChildItem $Source
    $ShortcutPath = Join-Path $Destination ($SourceFile.BaseName + ".lnk")
    $WScriptShell = New-Object -ComObject WScript.Shell

    $Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)

    $Shortcut.TargetPath = $Source
    $Shortcut.Save()
}