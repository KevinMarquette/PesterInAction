<#
.SYNOPSIS
Creates a new shortcut
.EXAMPLE
New-Shortcut -Source app.exe -Destination "$env:Public\Desktop" -Name "Quick Launch"
.EXAMPLE
 Get-ChildItem *.exe | New-Shortcut -Destination "$env:Public\Desktop"
#>

function New-Shortcut
{
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory         = $true,
            Position          = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
            )]
        [Alias("Path")]
        $Source,

        [Parameter(
            Mandatory = $true,
            Position  = 1,
            ValueFromPipelineByPropertyName = $true
            )]
        [Alias("Folder")]
        [string]$Destination = "$env:USERPROFILE\Desktop",

        [Parameter(
            Position = 2,
            ValueFromPipelineByPropertyName = $true
            )]
        [string]$Name
    )

    begin
    {
        $WScriptShell = New-Object -ComObject WScript.Shell
    }

    process
    {
        foreach($node in $Source)
        {
            Write-Verbose $node
            if(Test-Path $node)
            {
                $SourceFile = Get-ChildItem $node

                if($Name)
                {
                    $ShortcutPath = Join-Path (Resolve-Path $Destination) ( $Name + ".lnk")
                }
                else
                {                
                    $ShortcutPath = Join-Path (Resolve-Path $Destination) ( $SourceFile.BaseName + ".lnk")
                }   
                
                $Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)

                $Shortcut.TargetPath = $SourceFile.fullname
                $Shortcut.Save()

                Write-Output (Get-ChildItem $ShortcutPath)
            }
        }
    }
}