break; # just a demo

Import-Module ActiveDirectory
Describe "test_domain.Domain objects" {

    Context "Organizational Units" {

        $ADOU = @(
            "ou=Tech Sites,dc=test_domain,dc=local",
            "ou=sysops,dc=test_domain,dc=local",
            "ou=Groups,ou=sysops,dc=test_domain,dc=local",
            "ou=RTFM Groups,ou=Groups,ou=sysops,dc=test_domain,dc=local",
            "ou=Users,ou=sysops,dc=test_domain,dc=local",
            "ou=RTFM Users,ou=Users,ou=sysops,dc=test_domain,dc=local",
            "ou=Computers,ou=sysops,dc=test_domain,dc=local",
            "ou=Servers,ou=sysops,dc=test_domain,dc=local",
            "ou=Support,ou=sysops,dc=test_domain,dc=local",
            "ou=Users,ou=Support,ou=sysops,dc=test_domain,dc=local",
            "ou=Service Accounts,ou=users,ou=Support,ou=sysops,dc=test_domain,dc=local"
        )

        # Test every OU
        foreach($OU in $ADOU)
        {
            it "has an OU named: $OU" {
                
                Get-ADObject $OU | Should Not BeNullOrEmpty
            }
        }
    }

    context "Groups" {

        $ADGroups = @(
            “cn=CDMSUsersGroup,ou=Groups,ou=sysops,dc=test_domain,dc=local” 
            “cn=Administrators,ou=RTFM Groups,ou=Groups,ou=sysops,dc=test_domain,dc=local” 
            “cn=User Admin,ou=RTFM Groups,ou=Groups,ou=sysops,dc=test_domain,dc=local”     
            “cn=Group Admin,ou=RTFM Groups,ou=Groups,ou=sysops,dc=test_domain,dc=local”    
            “cn=Report Admin,ou=RTFM Groups,ou=Groups,ou=sysops,dc=test_domain,dc=local”   
            “cn=Template Admin,ou=RTFM Groups,ou=Groups,ou=sysops,dc=test_domain,dc=local” 
            "cn=AdminSec,ou=RTFM Groups,ou=Groups,ou=sysops,dc=test_domain,dc=local"
            "cn=FtpSec,ou=RTFM Groups,ou=Groups,ou=sysops,dc=test_domain,dc=local"
            "cn=ReportSec,ou=RTFM Groups,ou=Groups,ou=sysops,dc=test_domain,dc=local"
            "cn=AD Admin,CN=Users,DC=test_domain,DC=local"
        )

        # Test every group
        foreach($Group in $ADGroups)
        {
            it "has a Group named: $Group" {
                
                Get-ADObject $Group | Should Not BeNullOrEmpty
            }
        }
    }

    context "User: SysAdmin" {
        
        it "has a user account named SysAdmin" {
                   
            Get-ADUser SysAdmin | Should Not BeNullOrEmpty
        }

        it "is in the correct OU" {

            $User = Get-ADUser SysAdmin
            $User.DistinguishedName | Should Be "CN=SysAdmin,ou=RTFM Users,ou=Users,ou=sysops,DC=test_domain,DC=local"
        }

        it "is enabled" {

            $User = Get-ADUser SysAdmin -Properties Enabled
            $User.Enabled | Should Be $true
        }

         it "password set to expire" {
            
            $User = Get-ADUser SysAdmin -Properties PasswordNeverExpires
            $User.PasswordNeverExpires | Should Be $false
        }

        it "has a first name" {
            
            $User = Get-ADUser SysAdmin -Properties GivenName
            $User.GivenName | Should Be "SysAdmin"
        }

        it "has a last name" {
            
            $User = Get-ADUser SysAdmin -Properties Surname
            $User.Surname | Should Be "USER"
        }

        $GroupMembership = (Get-ADUser SysAdmin | Get-ADPrincipalGroupMembership).name

        $RequiredGroups = @(
            "Administrators",
            "RTFMUsersGroup",
            "AdminSec",
            "FTPSec",
            "ReportSec"
        )

        # Check for every group
        foreach($group in $RequiredGroups)
        {
            it "is a member of '$group'" {                
                ($GroupMembership -eq $group) | Should Be $true
            }
        }
    }

    context "User: SQL_Service" {

        it "has a user account named SQL_Service" {
                   
            Get-ADUser SQL_Service | Should Not BeNullOrEmpty
        }

        it "is in the correct OU" {

            $User = Get-ADUser SQL_Service
            $User.DistinguishedName | Should Be "cn=SQL_Service,cn=Users,DC=test_domain,DC=local"
        }

        it "is enabled" {

            $User = Get-ADUser SQL_Service -Properties Enabled
            $User.Enabled | Should Be $true
        }

         it "password set to not expire" {
            
            $User = Get-ADUser SQL_Service -Properties PasswordNeverExpires
            $User.PasswordNeverExpires | Should Be $true
        }    
    }

    context "User: Administrator" {

        it "has a user account named Administrator" {
                   
            Get-ADUser Administrator | Should Not BeNullOrEmpty
        }

        it "is in the correct OU" {

            $User = Get-ADUser Administrator
            $User.DistinguishedName | Should Be "cn=Administrator,cn=Users,DC=test_domain,DC=local"
        }

        it "is enabled" {

            $User = Get-ADUser Administrator -Properties Enabled
            $User.Enabled | Should Be $true
        }  
    }
 
    context "Active Directory Delegation" {

        $OUPath = "AD:\OU=sysops,DC=test_domain,DC=local"

        it "has AD Admin rights delegated" {
            (Get-Acl -Path $OUPath).Access | 
                where IdentityReference -eq "test_domain\AD Admin" | 
                Should Not BeNullOrEmpty
        }

        $RequiredDelegation = @(
            @{
                ActiveDirectoryRights = "GenericAll"
                InheritanceType       = "Descendents"
                InheritedObjectType   = "bf967aba-0de6-11d0-a285-00aa003049e2"
                ObjectFlags           = "InheritedObjectAceTypePresent"
                AccessControlType     = "Allow"
                IdentityReference     = "test_domain\AD Admin"
                IsInherited           = $False
                InheritanceFlags      = "ContainerInherit"
                PropagationFlags      = "InheritOnly"
            },
            @{             
                ActiveDirectoryRights = "GenericAll"
                InheritanceType       = "Descendents"
                InheritedObjectType   = "bf967a9c-0de6-11d0-a285-00aa003049e2"
                ObjectFlags           = "InheritedObjectAceTypePresent"
                AccessControlType     = "Allow"
                IdentityReference     = "test_domain\AD Admin"
                IsInherited           = $False
                InheritanceFlags      = "ContainerInherit"
                PropagationFlags      = "InheritOnly"
            },
            @{                  
                ActiveDirectoryRights = "CreateChild, DeleteChild"
                InheritanceType       = "All"
                ObjectType            = "bf967aba-0de6-11d0-a285-00aa003049e2"
                ObjectFlags           = "ObjectAceTypePresent"
                AccessControlType     = "Allow"
                IdentityReference     = "test_domain\AD Admin"
                IsInherited           = $False
                InheritanceFlags      = "ContainerInherit"
                PropagationFlags      = "None"
            },
            @{                
                ActiveDirectoryRights = "CreateChild, DeleteChild"
                InheritanceType       = "All"
                ObjectType            = "bf967a9c-0de6-11d0-a285-00aa003049e2"
                ObjectFlags           = "ObjectAceTypePresent"
                AccessControlType     = "Allow"
                IdentityReference     = "test_domain\AD Admin"
                IsInherited           = $False
                InheritanceFlags      = "ContainerInherit"
                PropagationFlags      = "None"
            }
        )

        foreach($delegation in $RequiredDelegation)
        {
            $AccessList = (Get-Acl -Path $OUPath).Access | where{$_.IdentityReference -eq "test_domain\AD Admin"}

            foreach($key in $delegation.keys)
            {
                it "$key = $($delegation.$key)" {
                   $AccessList = $AccessList | Where-Object -Property $key -EQ -Value $delegation.$key
                   $AccessList | Should Not BeNullOrEmpty
                }
            }
        }
    }
}

Describe "Roles and features" {
    
    $RequiredFeatures = @(
        "Wow64-Support",
        "Powershell",
        "AD-Domain-Services",
        "DNS",
        # "DHCP",
        "FS-FileServer",
        "NET-Framework-45-Core",
        "Windows-Server-Backup"
    )

    $InstalledFeatures = Get-WindowsFeature | where Installed
    foreach($feature in $RequiredFeatures)
    {
        it "Has feature installed: $feature" -Pending {
            $InstalledFeatures.name -eq $feature | Should Not BeNullOrEmpty
        }
    }
}