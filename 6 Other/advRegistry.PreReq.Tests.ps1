break; # just a demo

Describe "registry settings Pre-Requirements" {
    $RequiredRegistryKeys = @{
        DisableHybernate = @{
            Ensure    = "Present"
            Key       = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power"
            ValueName = "HibernateEnabled"
            ValueData = "0"  # (0 = Disable, 1 = Enable)
            ValueType = "DWord"
        }

        # This empty key will prevent windows from prompting for network location
        DisableSetNetworkLocation = @{
            Key       = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff"
            ValueName = ""
            ValueData = ""
            DependsOn = "[MGAM_Firewall]ConfigureAdvFirewall"
        }

        DisableStartupSound = @{
            Key       = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation"
            ValueName = "DisableStartupSound"
            ValueData = "0"
            ValueType = "DWord"
        }

        DisableIEWelcomeScreen = @{
            Key       = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\Main"
            ValueName = "DisableFirstRunCustomize"
            ValueData = "1"
            ValueType = "DWord"
        }

        SetIEDontPromptForDefaultBrowser = @{
            Key       = "HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\MAIN"
            ValueName = "Check_Associations"
            ValueData = "no"
            ValueType = "String"
        }

        DisableIEWelcomeScreenPerUser = @{
            ID        = "DisableIEFirstRunCustomize"
            Key       = "HKEY_CURRENT_USER\Software\Policies\Microsoft\Internet Explorer\Main"
            ValueName = "DisableFirstRunCustomize"
            ValueData = "1"
        }

        ShowExtensionForKnownFileTypes = @{
            ID        = "ShowExtensionForKnownFileTypes"
            Key       = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            ValueName = "HideFileExt"
            ValueData = "0"
        }

        ShowHiddenFiles = @{
            ID        = "ShowHiddenFiles"
            Key       = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            ValueName = "Hidden"
            ValueData = "1"
            Version   = "1.1"
        }

        DisableBalloonTips = @{
            ID        = "DisableBalloonTips"
            Key       = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            ValueName = "EnableBalloonTips"
            ValueData = "0"
            Version   = "1.3"
        }

        DisableActionCenter = @{
            Key       = "HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\POLICIES\EXPLORER"
            ValueName = "HIDESCAHEALTH"
            ValueData = "1"
            ValueType = "Dword"
        }

        SetIEDefaultStartPage = @{
            Key       = "HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\MAIN"
            ValueName = "Start Page"
            ValueData = "Http://localhost/reports"
            ValueType = "String"
        }

        DisableCertRevocationCheck = @{
            Key       = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\WinTrust\Trust Providers\Software Publishing"
            ValueName = "State"
            ValueData = "00023e00"
            ValueType = "DWord"
            Hex       = $true
        }

        DisableCertRevocationCheck_LocalSystem = @{
            Key       = "HKEY_USERS\S-1-5-18\Software\Microsoft\Windows\CurrentVersion\WinTrust\Trust Providers\Software Publishing"
            ValueName = "State"
            ValueData = "00023e00"
            ValueType = "DWord"
            Hex       = $true
        }

        DisableCertRevocationCheck_LocalService = @{
            Key       = "HKEY_USERS\S-1-5-19\Software\Microsoft\Windows\CurrentVersion\WinTrust\Trust Providers\Software Publishing"
            ValueName = "State"
            ValueData = "00023e00"
            ValueType = "DWord"
            Hex       = $true
        }

        DisableCertRevocationCheck_NetworkService = @{
            Key       = "HKEY_USERS\S-1-5-20\Software\Microsoft\Windows\CurrentVersion\WinTrust\Trust Providers\Software Publishing"
            ValueName = "State"
            ValueData = "00023e00"
            ValueType = "DWord"
            Hex       = $true
        }

        # http://support.microsoft.com/en-us/kb/837058
        DisableNICPowerManagement_0 = @{
            Key       = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0000"
            ValueName = "PnPCapabilities"
            ValueData = "00000038"
            ValueType = "DWord"
            Hex       = $true
        }

        DisableNICPowerManagement_1 = @{
            Key       = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0011"
            ValueName = "PnPCapabilities"
            ValueData = "00000038"
            ValueType = "DWord"
            Hex       = $true
        }

        StartPowerButtonDefaultAction = @{
            ID        = "StartPowerButtonDefaultAction"
            Key       = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            ValueName = "Start_PowerButtonAction"
            ValueData = "4"
            ValueType = "DWord"
            Version   = "1.3"
        }

        DisableScreenSaver = @{
            ID        = "DisableScreenSaver"
            Key       = "HKEY_CURRENT_USER\Control Panel\Desktop"
            ValueName = "ScreenSaveActive"
            ValueData = "0"
            Version   = "1.3"
        }

        DisableMonitorPowerOffPerUser = @{
            ID        = "DisableMonitorPowerOff"
            Key       = "HKEY_CURRENT_USER\Control Panel\Desktop"
            ValueName = "PowerOffActive"
            ValueData = "0"
            Version   = "1.0"
        }

        # Disable simple file sharing
        DisableSimpleFileSharing = @{
            Key       = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa"
            ValueName = "ForceGuest"
            ValueData = "0"
            ValueType = "DWORD"
        }

        UseClassicLogonScreen = @{
            Key       = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            ValueName = "dontdisplaylastusername"
            ValueData = "1"
            ValueType = "DWORD" 
        }

        DisableFastUserSwitching = @{
            Key       = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            ValueName = "HideFastUserSwitching"
            ValueData = "1"
            ValueType = "DWORD" 
        }
    }

    foreach($node in $RequiredRegistryKeys.Keys)
    {
        $RegKey = $RequiredRegistryKeys.$node
        $RegKey.Key = $RegKey.Key.Replace("HKEY_LOCAL_MACHINE","HKLM:").Replace("HKEY_CURRENT_USER","HKCU:").Replace("HKEY_USERS","Registry::\HKEY_USERS")
            
        context "$node" {
            
            it "has this key: '$($RegKey.Key)'" {
                Test-Path $RegKey.Key | Should Be $true
            }

            if($RegKey.ValueName)
            {
                it "should have property: $($RegKey.ValueName)" {

                    Get-Item  $RegKey.Key -ea Ignore | 
                        Select-Object -ExpandProperty Property | 
                        ?{$_ -eq $RegKey.ValueName} | 
                        Should Not BeNullOrEmpty
                }

                it "Property $($RegKey.ValueName) should be $($RegKey.ValueData)" {
                    
                    $value = (Get-ItemProperty -Path $RegKey.Key -ea 0)."$($RegKey.ValueName)"
                    
                    if($RegKey.Hex)
                    {
                        $value | Should Be ([Convert]::ToInt32($RegKey.ValueData,16))
                    }
                    else
                    {
                        $value | Should Be $RegKey.ValueData
                    }
                }
            }
        }
    }
}