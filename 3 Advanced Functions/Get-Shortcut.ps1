
function Get-Shortcut
{
    <#
    .SYNOPSIS
    Reads the attributes of a shortcut
    .EXAMPLE
    Get-Shortcut -Path .\shortcut.lnk
    #>
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
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
                $fullPath = Resolve-Path $node
                $Shortcut = $WScriptShell.CreateShortcut($fullPath)
                Write-Output $Shortcut
            }
        }
    }
}