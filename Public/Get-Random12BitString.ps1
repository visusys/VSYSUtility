function Get-Random12BitString {
    [CmdletBinding()]
	Param (
        [Parameter(Mandatory=$false)] 
        [Int32]$Length = 32,

        [Parameter(Mandatory=$false)] 
        [switch]$ToUpper
	)
    function New-12Bit {
				((New-Guid).guid).replace('-', '').SubString(0, 12)
    }
	return (((New-12Bit) + (New-12Bit) + (New-12Bit)).ToUpper()).SubString(0, $Length)
}