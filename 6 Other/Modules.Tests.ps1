$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Modules = LS $here -Directory 

Describe "All Modules" -Tags Unit,Module{

    foreach($CurrentModule in $Modules)
    {

        Context "$CurrentModule Details" {

            it "Has a $CurrentModule.psd1 file" {
                "$($CurrentModule.fullname)\$CurrentModule.psd1" | Should Exist
            }

            if(!(Test-Path "$($CurrentModule.fullname)\DSCResources"))
            {
                it "Has a $CurrentModule.psm1 file" {
                    "$($CurrentModule.fullname)\$CurrentModule.psm1" | Should Exist
                }

                it "Has a $CurrentModule.psd1 should load psm1 file" {
                    "$($CurrentModule.fullname)\$CurrentModule.psd1" | Should contain "$CurrentModule\.psm1"
                }
            }

            it "Has a $CurrentModule test file" {
                "$($CurrentModule.fullname)\$CurrentModule.Tests.ps1" | Should Exist
            }
        }

        if(Test-Path "$($CurrentModule.fullname)\functions")
        {
            $Functions = ls "$($CurrentModule.fullname)\functions\*.ps1" | ? name -NotMatch "Tests.ps1"
            foreach($CurrentFunction in $Functions)
            {
                Context "$CurrentModule $($CurrentFunction.BaseName)" {
                        
                    #it "Has a Pester test" {
                    #    $CurrentFunction.FullName.Replace(".ps1",".Tests.ps1") | should exist
                    #}

                    It "is valid Powershell" {

                        $contents = Get-Content -Path $CurrentFunction.FullName -ErrorAction Stop
                        $errors = $null
                        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
                        $errors.Count | Should Be 0
                    }
                }
            }
        }
    }
}