#Requires -Modules Pester
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$file = Get-ChildItem "$here\$sut"

Describe "New Shortcut" {

    It "is valid Powershell (Has no script errors)" {

        $contents = Get-Content -Path $file -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should Be 0
    }

    It "Creates a shortcut" {

        "TestDrive:\test.txt" | Should Not Exist
        "TestDrive:\test.lnk" | Should Not Exist

        Set-Content TestDrive:\test.txt -Value "New file"

        & "$file" -Source "TestDrive:\test.txt" -Destination "$testdrive"

        "TestDrive:\test.lnk" | Should Exist
    }
}
