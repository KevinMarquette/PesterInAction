#Requires -Modules Pester
<#
.SYNOPSIS
    Tests a module for all needed components
.EXAMPLE
    Invoke-Pester 
.NOTES
    This is a very generic set of tests that should apply to all modules that use a functions sub folder
#>


$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$module = Split-Path -Leaf $here

Describe "Module: $module" -Tags Unit {
    
    Context "Module Configuration" {
        
        It "Has a root module file ($module.psm1)" {        
            
            "$here\$module.psm1" | Should Exist
        }

        It "Is valid Powershell (Has no script errors)" {

            $contents = Get-Content -Path "$here\$module.psm1" -ErrorAction SilentlyContinue
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
            $errors.Count | Should Be 0
        }

        It "Has a manifest file ($module.psd1)" {
            
            "$here\$module.psd1" | Should Exist
        }

        It "Contains a root module path in the manifest (RootModule = '.\$module.psm1')" {
            
            "$here\$module.psd1" | Should Exist
            "$here\$module.psd1" | Should Contain "\.\\$module.psm1"
        }

        It "Has a functions folder" {        
            
            "$here\functions" | Should Exist
        }

        It "Has functions in the functions folder" {        
            
            "$here\functions\*.ps1" | Should Exist
        }
    }

    #Demo Note: Reminder that Pester commands are just Powershell commands

    $Functions = Get-ChildItem "$here\functions\*.ps1" -ErrorAction SilentlyContinue | 
        Where-Object {$_.name -NotMatch "Tests.ps1"}

    foreach($CurrentFunction in $Functions)
    {
        Context "Function $module::$($CurrentFunction.BaseName)" {
        
            It "Has a Pester test" {

                $CurrentFunction.FullName.Replace(".ps1",".Tests.ps1") | should exist
            }

            It "Has show-help comment block" {

                $CurrentFunction.FullName | should contain '<#'
                $CurrentFunction.FullName | should contain '#>'
            }

            It "Has show-help comment block has a synopsis" {

                $CurrentFunction.FullName | should contain '\.SYNOPSIS'
            }

            It "Has show-help comment block has an example" {

                $CurrentFunction.FullName | should contain '\.EXAMPLE'
            }

            It "Is an advanced function" {

                $CurrentFunction.FullName | should contain 'function'
                $CurrentFunction.FullName | should contain 'cmdletbinding'
                $CurrentFunction.FullName | should contain 'param'
            }

            It "Is valid Powershell (Has no script errors)" {

                $contents = Get-Content -Path $CurrentFunction.FullName -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
                $errors.Count | Should Be 0
            }
        }
    }
}