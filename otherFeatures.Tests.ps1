# Other Pester Features

# Basic test with context 
Describe "GenericTest" {

    Context "subset of tests" {

        It "Test value" {

            $actual="Actual value"
            $actual | Should Be "actual value"
        }
    }
}




# TestDrive: teporary storage location for your tests
# $TestDrive is full path to the TestDrive: Drive
Describe "TestDrive" {

    $path = "TestDrive:\Test.txt"
    Set-Content -Value "Temp file" -Path $path

    It "Contains value" {
        $path | Should Contain "Temp"
    }
}




# Mock: replaces a powershell command with alternate functionality
Describe "Mock" {
    
    Mock Get-Date {return [datetime]"1/2/14"}

    It "Has date" {
        Get-Date | Should Not BeNullOrEmpty
        Get-Date | Should Be "01/02/2014 00:00:00"
    }   
     
    It "Used our Mock" {
        Assert-MockCalled Get-Date -Times 2
    }
}




