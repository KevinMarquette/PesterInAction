$moduleRoot = Split-Path -Path $MyInvocation.MyCommand.Path

Write-Verbose "Importing Functions"
# Import everything in the functions folder
"$moduleRoot\Functions\*.ps1" |
  Resolve-Path |
  Where-Object { -not ($_.ProviderPath.Contains(".Tests.")) } |
  ForEach-Object { . $_.ProviderPath ; Write-Verbose $_.ProviderPath}
