<#
.SYNOPSIS
    Simple function to return all variables that start with a given prefix.

.DESCRIPTION
    Simple function to return all variables that start with a given prefix.

.EXAMPLE
    PS> Get-AllVariablesWithPrefix -Prefix "WPF"
    Returns a list of all variables beginning with "WPF"

.INPUTS
    None. Pipeline support not implemented.

.OUTPUTS
    A list of variables beginning with specified Prefix

.NOTES
    Name: Get-AllVariablesWithPrefix
    Author: Visusys
    Release: 1.0.0
    License: MIT License
    DateCreated: 2022-04-24

.LINK
    https://github.com/visusys

#>
function Get-AllVariablesWithPrefix {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position=0)]
        [String]
        $Prefix
    )
    $Prefix = $Prefix.ToUpper()
    Write-Host "All variables with the prefix $Prefix`:" -ForegroundColor Cyan
    Get-Variable $Prefix*
}