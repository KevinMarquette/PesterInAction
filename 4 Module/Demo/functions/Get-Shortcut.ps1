<#
.SYNOPSIS
Reads the attributes of a shortcut
.EXAMPLE
Get-Shortcut -Path .\shortcut.lnk
#>

function Get-Shortcut
{
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory         = $true,
            Position          = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
            )]
        $Path
    )

    begin
    {
        $WScriptShell = New-Object -ComObject WScript.Shell
    }

    process
    {
        foreach($node in $Path)
        {
            if(Test-Path $node)
            {
                $Shortcut = $WScriptShell.CreateShortcut((Resolve-Path $node))
                Write-Output $Shortcut
            }
        }
    }
}