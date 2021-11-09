<#
.SYNOPSIS
    Validates a supplied email address.

.PARAMETER address
    The email address you want to validate.

.NOTES
    Name: Test-IsValidEmailAddress
    Author: Visusys
    Version: 1.0.0
    DateCreated: 2021-11-07T06:37:36.000-05:00

.EXAMPLE
    Test-IsValidEmailAddress -address 'someone@somewhere.com'

.LINK
    https://github.com/visusys
#>
function Test-IsValidEmailAddress { 
    [CmdletBinding()]
    
    param(
        [Parameter(Mandatory = $true,Position = 0)]
        [string]$address
    )

    $regex = '^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$'

    try {
        $obj = [mailaddress]$address
        if($obj.Address -match $regex){
            return $true
        }
        return $false
    }
    catch {
        return $false
    } 
}