$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$file = Get-ChildItem "$PSScriptRoot\$sut"

Describe "New Shortcut advanced script" {

    It "Creates a shortcut" {

        "TestDrive:\test.txt" | Should -Not -Exist
        "TestDrive:\test.lnk" | Should -Not -Exist

        Set-Content TestDrive:\test.txt -Value "New file"

        & $file -Source "TestDrive:\test.txt" -Destination $testdrive

        "TestDrive:\test.lnk" | Should -Exist
    }
}
