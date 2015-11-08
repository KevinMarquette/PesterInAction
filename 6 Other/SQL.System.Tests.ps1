break; # just a demo

describe "SQL Configuration" {
    pushd
    context "General Config" {

        it "Has a D:\SQLData folder" {
            Test-Path "D:\SQLData" | Should be $true
        }

        it "Has a L:\SQLLogs folder" {
            Test-Path "L:\SQLLogs" | Should be $true
        }

        it "Has SQL Server installed" {
            Get-Service mssqlserver* | Should Not BeNullOrEmpty
        }

        it "Has SQL Server running" {
            (Get-Service mssqlserver*).Status | Should Be "Running"
        }

        it "Has correct SA password" -Pending {
            {throw "Not yet implemented"} | Should Not Throw
        }

        it "Running SQL Server 2012 10.0.5058.0" {
        
            $results = Invoke-Sqlcmd "Select @@Version"
            # 11.0.5058.0 or 11.2.5058
            $results.Column1 | Should match "11.0.5058"
        }

        It "@@ServerName matches hostname" {
            $name = Invoke-SQLCMD "SELECT @@Servername as Name" | % name
            $name | Should be $env:COMPUTERNAME
        }
    }

    context "SQL Accounts/Access" {
        
        It "test_domain\SQL Users have authentication in SQL" {
            Invoke-SQLCMD "SELECT Name FROM sys.server_principals WHERE name = 'test_domain\SQL Users'" | 
                Should Not BeNullOrEmpty
        }

        It "ReportUser has authentication in SQL" {
            Invoke-SQLCMD "SELECT Name FROM sys.server_principals WHERE name = 'ReportUser'" | 
                Should Not BeNullOrEmpty
        }
    }

        
    Context "SSRS" {

        It "is installed" {

            $SSRS = Get-WmiObject win32_service | 
                where name -eq "reportServer"

            $SSRS | Should Not BeNullOrEmpty
        }

        It "SSRS starts as network service" {      
              
            $SSRS = Get-WmiObject win32_service  | 
                where name -eq "reportServer"

            $SSRS.StartName | Should Be "NT AUTHORITY\NETWORKSERVICE"
        }        

        It "Network Service has authentication in SQL" {

            Invoke-SQLCMD "SELECT name FROM sys.server_principals WHERE name = 'NT AUTHORITY\NETWORK SERVICE'" | 
                Should Not BeNullOrEmpty
        }

        It "Network Service has RSExecRole on ReportServer database" {
         
               $SQL = @"
                    SELECT p.name, pp.is_fixed_role
                    FROM sys.database_role_members roles
                    JOIN sys.database_principals p 
                        ON roles.member_principal_id = p.principal_id
                    JOIN sys.database_principals pp 
                        ON roles.role_principal_id = pp.principal_id
                    WHERE pp.name = 'RSExecRole' AND p.name = 'NT AUTHORITY\NETWORK SERVICE'
"@
            Invoke-SQLCMD $SQL -Database ReportServer | 
                Should Not BeNullOrEmpty
        }
    }
    popd
}