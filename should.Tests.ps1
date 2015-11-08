# Start https://github.com/pester/Pester/wiki/Should
Describe "Should opperations" {

    It "Should Be" {
        $actual = "Actual value"
        $actual | Should Be "Actual value" # Test will pass
        # $actual | Should Be "not actual value"  # Test will fail
    }

    It "Should BeExactly" {
        $actual = "Actual value"
        $actual | Should BeExactly "Actual value" # Test will pass
        # $actual | Should BeExactly "actual value" # Test will fail
    }

    It 'Should Exist' { # same as Test-Path
        'c:\windows' | Should Exist
    }

    It 'Should Contain' {
        Set-Content -Path TestDrive:\file.txt -Value 'I am a file'
        'TestDrive:\file.txt' | Should Contain 'I Am' # Test will pass
        'TestDrive:\file.txt' | Should Contain '^I.*file$' # Test will pass
        # 'TestDrive:\file.txt' | Should Contain 'I Am Not' # Test will fail
    }

    It 'Should ContainExactly' {
        Set-Content -Path TestDrive:\file.txt -Value 'I am a file.'
        'TestDrive:\file.txt' | Should ContainExactly 'I am' # Test will pass
        # 'TestDrive:\file.txt' | Should ContainExactly 'I Am' # Test will fail
    }

    It 'Should Match' {
        "I am a value" | Should Match "I Am" # Test will pass
        # "I am a value" | Should Match "I am a bad person" # Test will fail
    } 

    It 'Should MatchExactly' {
        "I am a value" | Should MatchExactly "I am" # Test will pass
        # "I am a value" | Should MatchExactly "I Am" # Test will fail
    }

    It 'Should Throw' {
        { foo } | Should Throw # Test will pass
        # { $foo = 1 } | Should Throw # Test will fail
        # { foo } | Should Not Throw # Test will fail
        { $foo = 1 } | Should Not Throw # Test will pass
        { throw "This is a test" } | Should Throw "This is a test" # Test will pass
        # { throw "bar" } | Show Throw "This is a test" # Test will fail
    }

    It 'Should BeNullOrEmpty' {
        $null | Should BeNullOrEmpty # Test will pass
        # $null | Should Not BeNullOrEmpty # Test will fail
        @()   | Should BeNullOrEmpty # Test will pass
        ""    | Should BeNullOrEmpty # Test will pass
    }
}