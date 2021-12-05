<#
.SYNOPSIS
    Converts a string into a script block.

.PARAMETER String
    The string to convert into a script block.

.PARAMETER VariableValues
    Hashtable of variables that will be applied to the string before the conversion.

.NOTES
    Name: Convert-StringToScriptBlock
    Author: Visusys
    Release: 1.0.0
    License: MIT License
    DateCreated: 2021-12-05

.LINK
    https://github.com/visusys
    
#>
function Convert-StringToScriptBlock {
    [CmdletBinding()]
    param (
        [System.String]
        $String,

        [System.Collections.Hashtable]
        $Variables = @{}
    )

    foreach ($Key in $Variables.Keys) {
        Set-Variable -Name $Key -Value $Variables.$Key
    }

    [System.Management.Automation.ScriptBlock]::Create($ExecutionContext.InvokeCommand.ExpandString($String))
}
