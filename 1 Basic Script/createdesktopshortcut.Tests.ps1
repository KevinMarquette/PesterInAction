$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$file = Get-ChildItem "$PSScriptRoot\$sut"

Describe "Create desktop shortcut script" {

    It "Creates a shortcut on the desktop" {
        
        & $file.FullName

        $path = "$env:USERPROFILE\Desktop\Notepad.lnk"
        $path | Should -Exist
    }
}
