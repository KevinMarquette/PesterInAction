break; # just a demo

describe "System and Pre-Requirements"{

    context "Features" {

        $RequiredFeatures = @(
            "FS-FileServer"
            "Storage-Services"
            "Web-Default-Doc"
            "Web-Dir-Browsing"
            "Web-Http-Errors"
            "Web-Static-Content"
            "Web-Http-Logging"
            "Web-Stat-Compression"
            "Web-Filtering"
            "Web-Net-Ext45"
            "Web-Asp-Net45"
            "Web-ISAPI-Ext"
            "Web-ISAPI-Filter"
            "Web-Mgmt-Console"
            "NET-Framework-Core"
            "NET-Framework-45-Core"
            "NET-Framework-45-ASPNET"
            "RSAT-AD-PowerShell"
            "FS-SMB1"
            "PowerShell"
            "PowerShell-V2"
            "PowerShell-ISE"
            "WoW64-Support"
        )

        $InstalledFeatures = Get-WindowsFeature | where Installed
        foreach($feature in $RequiredFeatures)
        {
            it "Has feature installed: $feature" {

                $InstalledFeatures.name -eq $feature | Should Not BeNullOrEmpty
            }
        }
    }
       
    context "System config" {

        it "Has DotNet 4.5.2 or newer" {

            ( Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full').version -gt 4.5.51650 | 
                Should be $true
        }
    }

    context "Hotfix" {

        $RequiredHotfix = @(
            'KB2919355',
            'KB3000850',
            'KB3013769'
        )

        $InstalledHotfix = Get-HotFix
        foreach($Hotfix in $RequiredHotfix)
        {
            it "Has hotfix installed: $Hotfix" {

                $InstalledHotfix.HotFixID -eq $Hotfix | 
                    Should Not BeNullOrEmpty
            }
        }
    }
}