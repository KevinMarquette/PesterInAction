
Describe "Shortcut script" {

    It "Creates a shortcut on the desktop" {
        
        & $PSScriptRoot\CreateDesktopShortcut.ps1
        
        $path = "$env:USERPROFILE\Desktop\Notepad.lnk"
        $path | Should -Exist
    }
}
