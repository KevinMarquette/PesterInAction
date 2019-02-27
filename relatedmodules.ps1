# Format-Pester

Find-Module Format-Pester

# have to use -PassThru and pipe
Invoke-Pester .\otherFeatures.Tests.ps1 -PassThru |
    Format-Pester -Format Text -Path .\ -BaseFileName Report

code .\Report.txt

# Word
Invoke-Pester .\otherFeatures.Tests.ps1 -PassThru |
    Format-Pester -Format Word -Path .\ -BaseFileName Report

Start .\Report.docx


# HTML
Invoke-Pester .\otherFeatures.Tests.ps1 -PassThru |
    Format-Pester -Format HTML -Path .\ -BaseFileName Report

Start .\Report.html



# Assert https://github.com/nohwnd/Assert
Find-Module Assert

"hello" | Assert-NotEqual "world"
"hello" | Assert-NotEqual "hello"

Assert-NotEqual -Actual "Hello" -Expected "World" -CustomMessage "Custom example"

# with pester
Describe "Asserts" {
    It "Not equal" {
        "Hello" | Assert-NotEqual "World"
        "Hello" | Should -Not -Be "World"
    }
    It "Equal" {
        "Hello" | Assert-Equal "World"
        "Hello" | Should -Be "World"
    }
}


"hello" | Assert-StringEqual -Expected 'Hello' -CaseSensitive


Assert-Contain -Actual 1,2,3 -Expected 2


1,2,3 | Assert-All {$_ -lt 5}
1,6,3 | Assert-All {$_ -lt 5}

1,6,3 | Assert-Any {$_ -lt 5}


Get-Command -Module Assert

# Custom assert

function Assert-NotThree
{
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipeline)]
        $ActualValue
    )
    if(3 -eq $ActualValue) 
    {
        throw "Actual value is 3 but we expected it not to be 3."
    }
    else
    {
        $ActualValue
    }
}

4 | Assert-NotThree
3 | Assert-NotThree

# Custom Should assertions 
function BeThree
{
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipeline)]
        $ActualValue,
        [switch]$negate
    )

    $result = [PSCustomObject]@{
        Succeeded = $negate
        FailureMessage = if($negate)
        {
            "Actual value is $ActualValue but we expected it not to be 3."
        }
        else
        {
            "Actual value is $ActualValue and we expected it to be 3."
        }
    }
    if(3 -eq $ActualValue) 
    {
        $result.Succeeded = -not $negate
    }
    $result
}
Add-AssertionOperator -Name 'BeThree' -Test $Function:BeThree

Describe "BeThree" {
    It "Equal" {
        3 | Should -BeThree
    }
    It "Not Equal" {
        4 | Should -Not -BeThree
    }
}

# poshspec https://github.com/ticketmaster/poshspec
Find-Module poshspec
Get-Command -Module poshspec

Describe 'Services' {    
    Service w32time Status { Should Be Running }
    Service bits Status { Should Be Stopped }
}

Describe 'Files' {
    File C:\inetpub\wwwroot\iisstart.htm { Should Exist }
    File C:\inetpub\wwwroot\iisstart.htm { Should Contain 'text-align:center' }
}

Describe 'Registry' {
    Registry HKLM:\SOFTWARE\Microsoft\Rpc\ClientProtocols { Should Exist }
    Registry HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\ "SyncDomainWithMembership" { Should Be 1  }
    Registry 'HKLM:\SOFTWARE\Callahan Auto\' { Should Not Exist }
}

Describe 'Http' {
    TcpPort localhost 80 PingSucceeded { Should Be $true }
    TcpPort localhost 80 TcpTestSucceeded { Should Be $true }
    Http http://localhost StatusCode { Should Be 200 }
    Http http://localhost RawContent { Should Match 'X-Powered-By: ASP.NET' }
    Http http://localhost RawContent { Should Not Match 'X-Powered-By: Cobal' }
}
Describe 'Hotfix' {
    Hotfix KB3116900 { Should Not BeNullOrEmpty}
    Hotfix KB1112233 { Should BeNullOrEmpty}
}
Describe 'CimObject' {
    CimObject Win32_OperatingSystem SystemDirectory { Should Be C:\WINDOWS\system32 }
    CimObject root/StandardCimv2/MSFT_NetOffloadGlobalSetting ReceiveSideScaling { Should Be Enabled }
}



# OperationValidation https://github.com/PowerShell/Operation-Validation-Framework
# https://devblackops.io/infrastructure-testing-with-pester-and-the-operation-validation-framework/
Find-Module OperationValidation
Install-Module OVF.Windows.Server -Scope CurrentUser

Invoke-OperationValidation -ModuleName OVF.Windows.Server -TestType Simple


