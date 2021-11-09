<#
.SYNOPSIS
    Returns all private functions defined by a loaded module as an object with keys for CommandType, Name, Version, and Source.
.PARAMETER Module
    The specified module name (String). Note: The module must be loaded in session.
.EXAMPLE
    C:\PS> Get-ModulePrivateFunctions -Module "posh-git"
    This example will return all private functions defined in the "posh-git" module.
.EXAMPLE
    $modules = Get-Module
    foreach ($module in $modules) {
        Get-ModulePrivateFunctions -Module $module.Name
    }
    This example will print out all private functions defined in all loaded modules.
#>
function Get-ModulePrivateFunctions {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [string[]]
        $Module
    )
    foreach ($Name in $Module) {
        $mod = $null
        Write-Verbose "Processing Module '$Name'"
        $mod = Get-Module -Name $Name -ErrorAction SilentlyContinue
        if (-not $mod) {
            Write-Error "Module '$Name' not found"
            continue
        }
        $ScriptBlock = {
            $ExecutionContext.InvokeCommand.GetCommands('*', 'Function', $true)
        }
        $PublicFunctions = $mod.ExportedCommands.GetEnumerator() | 
            Select-Object -ExpandProperty Value | 
            Select-Object -ExpandProperty Name
        & $mod $ScriptBlock | Where-Object {$_.Source -eq $Name -and $_.Name -notin $PublicFunctions}
    }
}