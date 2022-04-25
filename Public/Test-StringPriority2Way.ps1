<#
.SYNOPSIS
    Returns the parameter value that is not null or white space
    and has the highest priority.

.DESCRIPTION
    Returns the parameter value that is not null or white space
    and has the highest priority. If all parameters are empty or
    null, the default value is returned. 
    Priority is determined as Alpha > Beta > Default.

.PARAMETER Alpha
    The parameter of highest priority.

.PARAMETER Beta
    The parameter of lowest priority.

.PARAMETER Default
    The default value. Returned if both Alpha and Beta are
    empty or null.

.EXAMPLE
    PS> $Computer1 = ""
    PS> $Computer2 = "WORKSTATION-01"
    PS> Test-StringPriority2Way -Alpha $Computer1 -Beta $Computer2 -Default "Undefined"
    WORKSTATION-01

.EXAMPLE
    PS> $Computer1 = "WORKSTATION-01"
    PS> $Computer2 = "WORKSTATION-02"
    PS> Test-StringPriority2Way -Alpha $Computer1 -Beta $Computer2 -Default "Undefined"
    WORKSTATION-01

.EXAMPLE
    PS> $Value1 = ""
    PS> $Value2 = "  "
    PS> Test-StringPriority2Way -Alpha $Value1 -Beta $Value2 -Default "Undefined"
    Undefined

.EXAMPLE
    PS> $Value1 = $null
    PS> $Value2 = " "
    PS> Test-StringPriority2Way -Alpha $Value1 -Beta $Value2 -Default $null
    $null

.INPUTS
    None. You cannot pipe objects to Test-StringPriority2Way.

.OUTPUTS
    System.String or $null.
    Test-StringPriority3Way returns the string of highest priority.
    Null will *only* be returned if each parameter is whitespace 
    or null and the default value is set to null.

.NOTES
    Name: Test-StringPriority2Way
    Author: Visusys
    Release: 1.0.0
    License: MIT License
    DateCreated: 2022-04-15

.LINK
    https://github.com/visusys

.LINK
    Test-StringPriority3Way
    
#>
function Test-StringPriority2Way {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position=0)]
        [AllowEmptyString()]
        [String]
        $Alpha,

        [Parameter(Mandatory,Position=1)]
        [AllowEmptyString()]
        [String]
        $Beta,

        [Parameter(Mandatory=$false,Position=2)]
        [AllowEmptyString()]
        [String]
        $Default = "Undefined"
    )
 
    Write-Verbose "`$Alpha:   $Alpha"   
    Write-Verbose "`$Beta:    $Beta"    
    Write-Verbose "`$Default: $Default"

    if (!([String]::IsNullOrWhiteSpace($Alpha))){ 
        Write-Verbose "Alpha Selected." 
        $Alpha 
    } else {
        if(!([String]::IsNullOrWhiteSpace($Beta))){ 
            Write-Verbose "Beta Selected."
            $Beta 
        } else { 
            Write-Verbose "Default Selected."
            $Default
        }
    }
}