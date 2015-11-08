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

        Set-Content TestDrive:\test.txt  -Value "New file"
        Set-Content TestDrive:\test2.txt -Value "New file 2"
        Set-Content TestDrive:\test3.txt -Value "New file 3"
        Set-Content TestDrive:\test4.txt -Value "New file 4"

        It "Creates a shortcut" {

            New-Shortcut -Source "TestDrive:\test.txt" -Destination $testdrive
            "TestDrive:\test.lnk" | Should Exist
        }

        It "Creates a named shortcut" {

            New-Shortcut -Source "TestDrive:\test.txt" -Destination $testdrive -Name "Test2"
            "TestDrive:\Test2.lnk" | Should Exist
        }

        It "Output is a file" {

            $result = New-Shortcut -Source "TestDrive:\test.txt" -Destination $testdrive -Name "Test3"
            $result | Should Not BeNullOrEmpty
            $result | Should Exist
            $result.GetType().Name | Should Be FileInfo
        }

        It "Creates multiple shortcuts with named parameter" {

            $files  = Get-ChildItem TestDrive:\test*.txt
            $result = New-Shortcut -Source $files -Destination $testdrive

            $result | Should Not BeNullOrEmpty
            $result.count | Should Be 4
            $result | Should Exist
        }

        It "Creates multiple shortcuts using the pipe" {

            $files  = Get-ChildItem TestDrive:\test*.txt
            $result =  $files | New-Shortcut -Destination "$testdrive"

            $result | Should Not BeNullOrEmpty
            $result.count | Should Be 4
            $result | Should Exist
        }
    }
}
