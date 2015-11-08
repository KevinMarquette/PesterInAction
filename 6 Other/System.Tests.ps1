break; # just a demo

describe "System and Pre-Requirements"{

    context "Features" {

        $RequiredFeatures = @(
            "Wow64-Support",
            "Powershell",
            "RSAT-AD-PowerShell",
            "RSAT-ADDS-Tools",
            "RSAT-DHCP",
            "RSAT-DNS-Server",
            "GPMC",
            "FS-FileServer",
            "NET-Framework-Core",
            "NET-Framework-45-Core",
            "Windows-Server-Backup"
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