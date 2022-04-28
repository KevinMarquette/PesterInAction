#Requires -Modules Pester
<#
.SYNOPSIS
    Tests a module for all needed components
.EXAMPLE
    Invoke-Pester 
.NOTES
    This is a very generic set of tests that should apply to all modules that use a functions sub folder
#>

Describe "Demo Module" -Tags Unit {
    
    Context "Module Configuration" {
        
        It "Has a root module file (Demo.psm1)" {        
            
            "$PSScriptRoot\Demo.psm1" | Should -Exist
        }

        It "Has a manifest file (Demo.psd1)" {
            
            "$PSScriptRoot\Demo.psd1" | Should -Exist
        }

        It "Contains a root module path in the manifest (RootModule = '.\Demo.psm1')" {
            
            "$PSScriptRoot\Demo.psd1" | Should -Exist
            "$PSScriptRoot\Demo.psd1" | Should -FileContentMatch "\.\\Demo.psm1"
        }

        It "Has a functions folder" {        
            
            "$PSScriptRoot\functions" | Should -Exist
        }

        It "Has functions in the functions folder" {        
            
            "$PSScriptRoot\functions\*.ps1" | Should -Exist
        }
    }

    #Demo Note: Reminder that Pester commands are just Powershell commands

    $Functions = Get-ChildItem "$PSScriptRoot\functions\*.ps1" -ErrorAction SilentlyContinue | 
        Where-Object {$_.name -NotMatch "Tests.ps1"}

    foreach($CurrentFunction in $Functions)
    {
        Context "Function Demo::$($CurrentFunction.BaseName)" {
        
            It "Has a Pester test" {

                $CurrentFunction.FullName.Replace(".ps1",".Tests.ps1") | Should -Exist
            }

            It "Has show-help comment block" {

                $CurrentFunction.FullName | Should -FileContentMatch '<#'
                $CurrentFunction.FullName | Should -FileContentMatch '#>'
            }

            It "Has show-help comment block has a synopsis" {

                $CurrentFunction.FullName | should -FileContentMatch '\.SYNOPSIS'
            }

            It "Has show-help comment block has an example" {

                $CurrentFunction.FullName | should -FileContentMatch '\.EXAMPLE'
            }

            It "Is an advanced function" {

                $CurrentFunction.FullName | should -FileContentMatch 'function'
                $CurrentFunction.FullName | should -FileContentMatch 'cmdletbinding'
                $CurrentFunction.FullName | should -FileContentMatch 'param'
            }

            It "Is valid Powershell (Has no script errors)" {

                $contents = Get-Content -Path $CurrentFunction.FullName -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
                $errors | Should -HaveCount 0
            }
        }
    }
}