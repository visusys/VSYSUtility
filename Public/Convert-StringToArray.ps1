<#
.SYNOPSIS
    Splits a String into an ArrayList by a specified delimiter.

.DESCRIPTION
    Splits a String into an ArrayList by a specified delimiter.

.PARAMETER InputString
    The string to be split.

.PARAMETER Delimiter
    The delimiter used to split InputString.

.PARAMETER KeepEmptyElements
    If true, function omits default processing to remove empty entries.
    Default is False.

.EXAMPLE
    Convert-StringToArray "One,Two,Three,Four" -Delimiter ","
    Returns an ArrayList: [One,Two,Three,Four]

.EXAMPLE
    Convert-StringToArray "One:Two|Three:Four" -Delimiter "|"
    Returns an ArrayList: [One:Two,Three:Four]

.INPUTS
    [String[]]$InputString        The string to be split.
    [String]$Delimiter            The delimiter to split by.
    [Switch]$KeepEmptyElements    Whether to remove empty elements or not.

.OUTPUTS
    .NET [System.Collections.ArrayList]
    An arraylist with all split string elements.

.NOTES
    Name: Convert-StringToArray
    Author: Visusys
    Release: 1.0.0
    License: MIT License
    DateCreated: 2022-04-14

.LINK
    https://github.com/visusys

#>
function Convert-StringToArray {
        
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName)]
        [String[]]
        $InputString,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName)]
        [String]
        $Delimiter = " ",

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName)]
        [Switch]
        $KeepEmptyElements
    )

    begin {

        $FinalArray = [System.Collections.ArrayList]@()
    }

    process {
        $t = $InputString -replace '\n',"`r`n"
        $t = $t -split $Delimiter, 0, "SimpleMatch"
        if(!$KeepEmptyElements){
            $t = $t.split($Delimiter,[System.StringSplitOptions]::RemoveEmptyEntries)
        }
        foreach ($element in $t) {
            [void]$FinalArray.Add($element)
        }
    }

    end {
        $FinalArray
    }
}