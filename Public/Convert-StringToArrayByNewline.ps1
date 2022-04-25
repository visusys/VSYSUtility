<#
.SYNOPSIS
    Splits a multi-line String into an ArrayList by newlines.

.DESCRIPTION
    Splits a multi-line String into an ArrayList by newlines.

.PARAMETER InputString
    The string to be split.

.PARAMETER KeepEmptyElements
    If true, function omits default processing to remove empty entries.
    Default is False.

.EXAMPLE
    Convert-StringToArrayByNewline $MultilineString
    Returns an ArrayList: [String 1,String 2,String 3,String 4]

.INPUTS
    [String[]]$InputString        The string to be split.
    [Switch]$KeepEmptyElements    Whether to remove empty elements or not.

.OUTPUTS
    .NET [System.Collections.ArrayList]
    An arraylist with all split string elements.

.NOTES
    Name: Convert-StringToArrayByNewline
    Author: Visusys
    Release: 1.0.0
    License: MIT License
    DateCreated: 2022-04-14

.LINK
    https://github.com/visusys

#>
function Convert-StringToArrayByNewline {
        
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName)]
        [String[]]
        $InputString,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName)]
        [Switch]
        $KeepEmptyElements
    )

    begin {
        $FinalArray = [System.Collections.ArrayList]@()
    }
    
    process {
        $arr = $InputString -replace '\n',"`r`n"
        $arr = $arr -split "`r`n"
        $arr = $arr -split [Environment]::NewLine
        if(!$KeepEmptyElements){
            $arr = $arr.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)
        }
        foreach ($element in $arr) {
            [void]$FinalArray.Add($element)
        }
    }

    end {
        return $FinalArray
    }
}

