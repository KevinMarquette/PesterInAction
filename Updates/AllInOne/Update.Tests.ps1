Describe 'updates' {
    mock Import-Csv {
        [pscustomobject]@{
            name = 'LOCAL-TEST01'
            wave = 'Wave1'
        }
        [pscustomobject]@{
            name = 'LOCAL-TEST02'
            wave = 'Wave2'
        }
        [pscustomobject]@{
            name = 'LOCAL-TEST03'
            wave = 'Wave2'
        }
    }
    
    mock -Verifiable Get-CimInstance {
        @{status = 1}
    }

    mock -Verifiable Invoke-CimMethod {
        $true
    }

    it "updates first Wave" {
        mock Get-Date {
            [datetime]"9-12-2019" # 2 days after
        }

        . .\Update.ps1
        Assert-MockCalled -Scope it -CommandName Get-CimInstance -Times 1
        Assert-MockCalled -Scope it -CommandName Invoke-CimMethod -Times 1
    }

    it "updates second Wave" {
        mock Get-Date {
            [datetime]"9-17-2019" # 7 days after
        }

        . .\Update.ps1
        Assert-MockCalled -Scope it -CommandName Get-CimInstance -Times 2
        Assert-MockCalled -Scope it -CommandName Invoke-CimMethod -Times 2
    }

    it "updates no waves" {
        mock Get-Date {
            [datetime]"9-15-2019" # 5 days after
        }

        . .\Update.ps1
        Assert-MockCalled -Scope it -CommandName Get-CimInstance -Times 0
        Assert-MockCalled -Scope it -CommandName Invoke-CimMethod -Times 0
    }

    it "does not run mid-day" {
        mock Get-Date {
            [datetime]"9-12-2019 14:00:00" # 2 days after, at 2pm
        }

        . .\Update.ps1
        Assert-MockCalled -Scope it -CommandName Get-CimInstance -Times 0
        Assert-MockCalled -Scope it -CommandName Invoke-CimMethod -Times 0
    }
}
