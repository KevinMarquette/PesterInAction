$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$file = Get-ChildItem "$PSScriptRoot\$sut"

Describe $file.BaseName -Tags Unit {

    Context "Basic features" {

        BeforeAll {
            . $file
            . $PSScriptRoot\New-Shortcut.ps1
    
            Set-Content TestDrive:\test.txt  -Value "New file"
    
            $Shortcut = New-Shortcut -Source TestDrive:\test.txt -Destination "$testdrive"
        }

        It "Can open shortcut from a FileInfo object" {
 
            $result = Get-Shortcut -Path $Shortcut
            $result | Should -Not -BeNullOrEmpty
            $result.fullname | Should -Match 'test.lnk'
            $result.TargetPath | Should -Match 'test.txt'
        }

         It "Can open shortcut from a path string" {
            
            $result = Get-Shortcut -Path $Shortcut.FullName
            $result | Should -Not -BeNullOrEmpty
            $result.fullname | Should -Match 'test.lnk'
            $result.TargetPath | Should -Match 'test.txt'
        }
    }
}
