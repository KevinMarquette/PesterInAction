# http://www.adminarsenal.com/admin-arsenal-blog/pdq-deploy-and-powershell 
# Create a Shortcut with Windows PowerShell
$TargetFile   = "$env:SystemRoot\System32\notepad.exe"
$ShortcutFile = "$env:USERPROFILE\Desktop\Notepad.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell

$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)

$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()