

Describe "Remove Shortcut Script" -Tags Unit {

    It "Removes a shortcut on the desktop" {
        
        & $PSScriptRoot\RemoveDesktopShortcut.ps1

        $path = "$env:USERPROFILE\Desktop\Notepad.lnk"
        $path | Should -Not -Exist
    }
}
