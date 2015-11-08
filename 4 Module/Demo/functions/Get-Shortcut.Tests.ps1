#Requires -Modules Pester
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$file = Get-ChildItem "$here\$sut"

Describe $file.BaseName -Tags Unit {

    It "is valid Powershell (Has no script errors)" {

        $contents = Get-Content -Path $file -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should Be 0
    }

    Context "Basic features" {

            . $file
            . $here\New-Shortcut.ps1

            Set-Content TestDrive:\test.txt  -Value "New file"

            $Shortcut = New-Shortcut -Source TestDrive:\test.txt -Destination "$testdrive"

        It "Can read a file" {
            
            $result = Get-Shortcut -Path $Shortcut
            $result | Should Not BeNullOrEmpty
            $result.fullname | Should Match test.lnk
            $result.TargetPath | Should Match test.txt
        }

         It "Can read a path" {
            
            $result = Get-Shortcut -Path $Shortcut.FullName
            $result | Should Not BeNullOrEmpty
            $result.fullname | Should Match test.lnk
            $result.TargetPath | Should Match test.txt
        }
    }
}
