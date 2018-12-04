break; # just a demo

$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$ResourceList = Get-ChildItem "$PSScriptRoot\DSCResources"
Describe "DSCResources located in $PSScriptRoot\DSCResources" -Tags Unit {

    $LoadedResources = Get-DscResource

    foreach($Resource in $ResourceList)
    {
        Context $Resource.name {


            It "Is loaded correctly" {

                $LoadedResources | 
                    Where-Object {$_.name -eq $Resource} | 
                    Should -Not -BeNullOrEmpty
            }


            It "Has a pester test" {

                Resolve-Path ($Resource.fullname + "\*.tests.ps1") | 
                    Should -Exist
            }

            # Identify standard vs composite resources
            if(Test-Path ($Resource.fullname + "\$Resource.psm1"))
            {
                # Standard resource

                It "Has a $Resource.schema.mof" {
                    
                    ($Resource.fullname + "\$Resource.schema.mof") | 
                        Should -Exist
                }

                It "Has a $Resource.psm1" {
                    
                    ($Resource.fullname + "\$Resource.psm1") | 
                        Should -Exist
                }

                It "Passes Test-xDscSchema *.schema.mof" {
                    Test-xDscSchema ($Resource.fullname + "\$Resource.schema.mof") | 
                        Should -BeTrue
                }

                It "Passes Test-xDscResource" {
                    Test-xDscResource $Resource.fullname | 
                        Should -BeTrue
                }
            }
            else
            {
                # composite resource

                It "Has a $Resource.schema.psm1" {
                    
                    ($Resource.fullname + "\$Resource.schema.psm1") | 
                        Should -Exist
                }

                It "Has a $Resource.psd1" {
                    
                    ($Resource.fullname + "\$Resource.psd1") | 
                        Should -Exist
                }

                It "Has a psd1 that loads the schema.psm1" {

                    ($Resource.fullname + "\$Resource.psd1") | 
                        Should -FileContentMatch "$Resource.schema.psm1"
                }

                It "dot-sourcing should not throw an error" {

                    $path = ($Resource.fullname + "\$Resource.schema.psm1")
                    { Invoke-expression (Get-Content $path -raw) } | 
                        Should -Not -Throw
                }
            }
        }
    }
}