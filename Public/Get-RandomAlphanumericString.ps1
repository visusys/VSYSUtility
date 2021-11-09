<#
.SYNOPSIS
    Returns a random alphanumeric string of a specified length.

.PARAMETER Length
    The length of the random string.

.NOTES
    Name: Get-RandomAlphanumericString
    Author: Visusys
    Version: 1.0.0
    DateCreated: 2021-11-09

.EXAMPLE
    Get-RandomAlphanumericString -Length 15
    Result: P85IvyQESdRJ7He

.LINK
    https://github.com/visusys
#>
Function Get-RandomAlphanumericString {
	[CmdletBinding()]
	Param (
        [Parameter(Mandatory=$false, Position=0)] 
        [Int32]$Length = 15
	)
    return ( -join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count $Length  | ForEach-Object {[char]$_}) )
}