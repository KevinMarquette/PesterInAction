break;  # F5 trap
#region Demo Prep

$root = "C:\Users\kevin.marquette\Documents\scripts\demo\pester" # My working directory
pushd $root

function prompt
{
    $currentDirectory = (get-location).Path.Replace($root, "Demo:")
    "PS $currentDirectory>"
}

& '.\1 Basic Script\RemoveDesktopShortcut.ps1'

Clear-Host

& '.\Pester in Action.ppsx'

#endregion

#region Pester basics
# Start https://github.com/pester/Pester/wiki

# Adds new commands in powershell
Describe "GenericTest" {

    $actual = "Actual value"

    It "Test value" {
        
        $actual | Should Be "Actual value"
    }
}


# Should Examples
ise .\should.Tests.ps1
Invoke-Pester .\should.Tests.ps1



# Demonstrate Other Features of Pester
ise .\otherFeatures.Tests.ps1
Invoke-Pester .\otherFeatures.Tests.ps1

#endregion

#region Show a basic script and Pester test
# & '.\1 Basic Script\RemoveDesktopShortcut.ps1'
ise '.\1 Basic Script\createdesktopshortcut.ps1'
ise '.\1 Basic Script\createdesktopshortcut.Tests.ps1'

Invoke-Pester '.\1 Basic Script\createdesktopshortcut.Tests.ps1'

# Show an advanced script and Pester tests
ise '.\2 Advanced Script\NewShortcut.ps1'
ise '.\2 Advanced Script\NewShortcut.Tests.ps1'
Invoke-Pester '.\2 Advanced Script\NewShortcut.Tests.ps1'


# Show an advanced function
ise '.\3 Advanced Functions\New-Shortcut.ps1'
ise '.\3 Advanced Functions\New-Shortcut.Tests.ps1'
Invoke-Pester '.\3 Advanced Functions\New-Shortcut.Tests.ps1'

ise '.\3 Advanced Functions\Get-Shortcut.Tests.ps1'
Invoke-Pester '.\3 Advanced Functions\Get-Shortcut.Tests.ps1'


#endregion

#region Show a module
<#
Demo
│   Demo.psd1       # module manifest
│   Demo.psm1       # root module
│   Demo.Tests.ps1  # Pester Test
│
└───functions
        Get-Shortcut.ps1       # function
        Get-Shortcut.Tests.ps1 # Pester Test
        New-Shortcut.ps1       # function
        New-Shortcut.Tests.ps1 # Pester Test
#>
Start '.\4 Module\Demo'
ise '.\4 Module\Demo\Demo.psm1'
ise '.\4 Module\Demo\Demo.psd1'
ise '.\4 Module\Demo\Demo.Tests.ps1'
Invoke-Pester '.\4 Module\Demo\Demo.Tests.ps1'

#endregion

#region Build a module on the fly
# Create a module folder and add the Pester tests
$name = 'DemoModule3'
$path = Join-Path (resolve-path '.\5 Module (Interactive Demo)') -ChildPath $name
MD $path
Copy-Item '.\4 Module\Demo\Demo.Tests.ps1' "$path\$name.Tests.ps1"
Invoke-Pester "$path\$name.Tests.ps1"


# Create root module and manifest
Copy-Item '.\4 Module\Demo\Demo.psm1' "$path\$name.psm1"
New-ModuleManifest -Path "$path\$name.psd1" -RootModule ".\$name.psm1"
MD "$path\functions"
Invoke-Pester "$path\$name.Tests.ps1"


# Create a function file
Set-Content -Value '' -Path "$path\functions\test-item.ps1"
New-Fixture -Path "$path\functions" -Name 'test-item'
ise "$path\functions\test-item.Tests.ps1"
ise "$path\functions\test-item.ps1"
Invoke-Pester "$path\functions"
Invoke-Pester "$path\$name.Tests.ps1"


# Add more functions
Copy-Item '.\4 Module\Demo\functions\*.ps1' "$path\functions"
ls "$path\functions" | Format-Table Name
Invoke-Pester "$path\$name.Tests.ps1"

#endregion

#region Other examples
ise '.\6 Other\System.Tests.ps1'
ise '.\6 Other\SQL.System.Tests.ps1'
ise '.\6 Other\ActiveDirectory.DC.System.Tests.ps1'
ise '.\6 Other\My-DSC.Tests.ps1'
ise '.\6 Other\advRegistry.PreReq.Tests.ps1'

#endregion
