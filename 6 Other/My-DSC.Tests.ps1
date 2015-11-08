break; # just a demo

$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$ResourceList = Get-ChildItem "$PSScriptRoot\DSCResources"
Describe "DSCResources located in $PSScriptRoot\DSCResources" -Tags Unit {

    $LoadedResources = Get-DscResource

    foreach($Resource in $ResourceList)
    {
        Context $Resource.name {


            It "Is loaded correctly" {

                $LoadedResources | ?{$_.name -eq $Resource} | Should Not BeNullOrEmpty
            }


            It "Has a pester test" {

                Resolve-Path ($Resource.fullname + "\*.tests.ps1") | should exist
            }

            # Identify standard vs composite resources
            if(Test-Path ($Resource.fullname + "\$Resource.psm1"))
            {
                # Standard resource

                It "Has a $Resource.schema.mof" {
                    
                    ($Resource.fullname + "\$Resource.schema.mof") | 
                        should exist
                }

                It "Has a $Resource.psm1" {
                    
                    ($Resource.fullname + "\$Resource.psm1") | 
                        should exist
                }

                It "Passes Test-xDscSchema *.schema.mof" {
                    Test-xDscSchema ($Resource.fullname + "\$Resource.schema.mof") | 
                        should be true
                }

                It "Passes Test-xDscResource" {
                    Test-xDscResource $Resource.fullname | 
                        should be true
                }
            }
            else
            {
                # composite resource

                It "Has a $Resource.schema.psm1" {
                    
                    ($Resource.fullname + "\$Resource.schema.psm1") | 
                        should exist
                }

                It "Has a $Resource.psd1" {
                    
                    ($Resource.fullname + "\$Resource.psd1") | 
                        should exist
                }

                It "Has a psd1 that loads the schema.psm1" {

                    ($Resource.fullname + "\$Resource.psd1") | 
                        should contain "$Resource.schema.psm1"
                }

                It "dot-sourcing should not throw an error" {

                    $path = ($Resource.fullname + "\$Resource.schema.psm1")
                    { Invoke-expression (Get-Content $path -raw) } | 
                        should not throw
                }
            }
        }
    }
}