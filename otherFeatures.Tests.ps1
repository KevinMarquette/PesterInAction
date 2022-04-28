[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
[cmdletbinding()]
param()

# Other Pester Features



# Basic test with context 
Describe "GenericTest" {

    Context "subset of tests" {

        It "Test value" {

            $actual = "Actual value"
            $actual | Should -Be "actual value"
        }
    }
}



# -Because for better failure messages
Describe "-Because" {
    It "Shows -Because" {
        $actual = "Actual value"
        $actual | Should -Be "Actual value" -Because 'I said so'
    }
}

Describe "-Because random" {
    It "Shows -Because in action" {
        Get-Random -Maximum 2 | Should -Be 0 -Because 'Some assumption'
        Get-Random -Maximum 2 | Should -Be 0 -Because 'Main test case'
        Get-Random -Maximum 2 | Should -Be 0 -Because 'Verify cleanup'
    }
}



# TestDrive: temporary storage location for your tests
# $TestDrive is full path to the TestDrive: Drive
Describe "TestDrive" {

    It "Contains value" {
        $path = "TestDrive:\Test.txt"
        Set-Content -Value "Temp file" -Path $path

        $path | Should -FileContentMatch "Temp"
    }
}




# BeforeEach

Describe "BeforeEach" {
    BeforeEach {
        $path = "TestDrive:\Test.txt"
        Set-Content -Value "Temp file" -Path $path
    }
    It "change in value" {
        $path | Should -Exist
        $path | Should -FileContentMatch "Temp file"
        Set-Content -Value "different value" -Path $path
        $path | Should -FileContentMatch "different value"
    }
    It "Contains value" {
        $path | Should -Exist
        $path | Should -FileContentMatch "Temp"
    }
}



Describe "More before/after actions" {
    BeforeAll {Write-Host 'Execute BeforeAll'}
    BeforeEach {Write-Host 'Execute BeforeEach'}
    AfterEach {Write-Host 'Execute AfterEach'}
    AfterAll {Write-Host 'Execute AfterAll'}
    It 'First It' {
        Write-Host 'Execute First It'
        throw 'First It'
    }
    It 'Second It' {Write-Host 'Execute Second It'}
}




# TestCases
BeforeDiscovery {
    $testCases = @(
        @{Alias = 'ps';  Command='Get-Process'}
        @{Alias = 'gm';  Command='Get-Member'}
        @{Alias = 'cls'; Command='Clear-Host'}
        @{Alias = 'wmi'; Command='Get-WmiObject'} # Will fail
    )
}
# Built-in test case support
Describe "Testcases" -ForEach $testCases {
    
    It 'Alias <Alias> is for command <Command>'  {
        $result = Get-Alias $Alias
        $result.Definition | Should -Be $Command
    }
}






# Mock: replaces a powershell command with alternate functionality
Describe "Mock" {
    BeforeAll {
        Mock Get-Date {return [datetime]"1/2/14"}
    }

    It "Has date" {
        Get-Date | Should -Not -BeNullOrEmpty
        Get-Date | Should -Be "01/02/2014 00:00:00"
    
        Should -invoke -CommandName Get-Date -Times 2
    }
}


# add example for https://github.com/pester/Pester/wiki/New-MockObject
