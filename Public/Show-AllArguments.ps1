<#
.SYNOPSIS
    Prints an overview of all bound and unbound arguments.

.NOTES
    Name: Show-AllArguments
    Author: Visusys
    Version: 1.0.0
    DateCreated: 2021-11-09

.EXAMPLE
    Show-AllArguments

.LINK
    https://github.com/visusys
#>
Function Show-AllArguments {
    [CmdletBinding()]
    param()

    # Get the relevant variable values from the calling script's scope.
    $scBoundParameters  = $PSCmdlet.GetVariableValue('PSBoundParameters')
    $scArgs             = $PSCmdlet.GetVariableValue('args')

    # Print the arguments received in diagnostic form.
    Write-Host 'Arguments received:' -BackgroundColor Black -ForegroundColor Yellow
    [PSCustomObject] @{
        PSBoundParameters = $scBoundParameters.GetEnumerator() | Select-Object Key, Value, @{ n = 'Type'; e = { $_.Value.GetType().Name } } | Out-String
        # Only applies to non-advanced scripts
        Args              = $scArgs | ForEach-Object { [pscustomobject] @{ Value = $_; Type = $_.GetType().Name } } | Out-String
        CurrentLocation   = $PWD.ProviderPath
    } | Format-List
}