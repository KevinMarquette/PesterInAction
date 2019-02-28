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
        Random -Maximum 2 | Should -Be 0 -Because 'Some assumption'
        Random -Maximum 2 | Should -Be 0 -Because 'Main test case'
        Random -Maximum 2 | Should -Be 0 -Because 'Verify cleanup'
    }
}

#Example
C:\ldx\LDUtility\Tests\Select-Unique.Tests.ps1

# TestDrive: temporary storage location for your tests
# $TestDrive is full path to the TestDrive: Drive
Describe "TestDrive" {

    It "Contains value" {
        $path = "TestDrive:\Test.txt"
        Set-Content -Value "Temp file" -Path $path

        $path | Should -FileContentMatch "Temp"
    }
}

#Example
code C:\ldx\LDUtility\Tests\Invoke-LDGit.Tests.ps1

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

# Example
code C:\ldx\LDUtility\Tests\Protect-Clipboard.Tests.ps1
code C:\ldx\LDUtility\Tests\Unprotect-Clipboard.Tests.ps1

# TestCases
$testCases = @(
    @{Alias = 'ps';  Command='Get-Process'}
    @{Alias = 'gm';  Command='Get-Member'}
    @{Alias = 'cls'; Command='Clear-Host'}
    @{Alias = 'wmi'; Command='Get-WmiObject'}
)

Describe "ForEach" {
    foreach($node in $testCases)
    {
        It ('Alias {0} is for command {1}' -f $node.Alias,$node.Command) {
            $result = Get-Alias $node.Alias
            $result.Definition | Should -Be $node.Command
        }
    }
}

# Built-in test case support
Describe "Testcases" {
    
    It 'Alias <Alias> is for command <Command>' -TestCases $testCases {
        param($Alias,$Command)
        $result = Get-Alias $Alias
        $result.Definition | Should -Be $Command
    }
}

# Examples
code C:\ldx\LDNetworking\Tests\Test-LDEndpoint.Tests.ps1
code C:\ldx\LDXSet\Tests\Test-MDAppSetting.Tests.ps1


# InModuleScope
InModuleScope -ModuleName Pester {
    Describe "Inside Pester" {
        It "finds the list of safe commands" {
            $SafeCommands | Should -Not -BeNullOrEmpty
        }
    }
}

# Example
code C:\ldx\LDAppSettings\Tests\Classes\ConfigTransforms\JsonConfigTransform.Tests.ps1


# Mock: replaces a powershell command with alternate functionality
Describe "Mock" {
    
    Mock Get-Date {return [datetime]"1/2/14"}

    It "Has date" {
        Get-Date | Should -Not -BeNullOrEmpty
        Get-Date | Should -Be "01/02/2014 00:00:00"
    }   
     
    It "Used our Mock" {
        Assert-MockCalled Get-Date -Times 2
    }
}

# Example 
code C:\ldx\LDUtility\Tests\Start-DevTask.Tests.ps1