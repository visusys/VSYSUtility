<#
.SYNOPSIS
    Returns the parameter value that is not null or white space
    and has the highest priority.

.DESCRIPTION
    Returns the parameter value that is not null or white space
    and has the highest priority. If all parameters are empty
    or null, the default value is returned.
    Priority is determined as Alpha > Beta > Theta > Default.

.PARAMETER Alpha
    The parameter of highest priority.

.PARAMETER Beta
    The parameter of middle priority.

.PARAMETER Theta
    The parameter of lowest priority.

.PARAMETER Default
    The default value. Returned if both Alpha, Beta, and Theta
    are empty or null.

.EXAMPLE
    PS> $Computer1 = ""
    PS> $Computer2 = "WORKSTATION-01"
    PS> $Computer3 = "WORKSTATION-02"
    PS> Test-StringPriority3Way -Alpha $Computer1 -Beta $Computer2 -Theta $Computer3 -Default "Undefined"
    WORKSTATION-01

.EXAMPLE
    PS> $Computer1 = ""
    PS> $Computer2 = $null
    PS> $Computer3 = "WORKSTATION-02"
    PS> Test-StringPriority3Way -Alpha $Computer1 -Beta $Computer2 -Theta $Computer3 -Default "Undefined"
    WORKSTATION-02

.EXAMPLE
    PS> $Value1 = $null
    PS> $Value2 = $null
    PS> $Value3 = " "
    PS> Test-StringPriority3Way -Alpha $Computer1 -Beta $Computer2 -Theta $Computer3 -Default "EMPTY"
    EMPTY

.EXAMPLE
    PS> $LogFile1 = $null
    PS> $LogFile2 = " "
    PS> $LogFile3 = "SystemLog.txt"
    PS> Test-StringPriority3Way -Alpha $LogFile1 -Beta $LogFile2 -Theta $LogFile3
    SystemLog.txt

.INPUTS
    None. You cannot pipe objects to Test-StringPriority3Way.

.OUTPUTS
    System.String or $null.
    Test-StringPriority3Way returns the string of highest priority.
    Null will *only* be returned if each parameter is whitespace 
    or null and the default value is set to null.

.NOTES
    Name: Test-StringPriority3Way
    Author: Visusys
    Release: 1.0.0
    License: MIT License
    DateCreated: 2022-04-15

.LINK
    https://github.com/visusys

.LINK
    Test-StringPriority3Way
    
#>
function Test-StringPriority3Way {
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

        [Parameter(Mandatory,Position=2)]
        [AllowEmptyString()]
        [String]
        $Theta,

        [Parameter(Mandatory=$false,Position=3)]
        [AllowEmptyString()]
        [String]
        $Default = "Undefined"
    )

    Write-Verbose "`$Alpha: $Alpha"
    Write-Verbose "`$Beta: $Beta"
    Write-Verbose "`$Theta: $Theta"
    Write-Verbose "`$Default: $Default"

    if (!([String]::IsNullOrWhiteSpace($Alpha)))  { 
        Write-Verbose "Alpha Selected."
        $Alpha 
    } else {
        if(!([String]::IsNullOrWhiteSpace($Beta))){ 
            Write-Verbose "Beta Selected."
            $Beta 
        } else { 
            if(!([String]::IsNullOrWhiteSpace($Theta))){
                Write-Verbose "Theta Selected."
                $Theta
            }else{
                Write-Verbose "Default Selected."
                $Default
            }
        }
    }
}