<#

.SYNOPSIS

Returns a random string based on specified complexity, length, and exclusions. Based on the work of Ronald Bode found here: https://powersnippets.com/

.DESCRIPTION

Returns a random string based on specified complexity, length, and exclusions.

The Length parameter defines the length of the string. The Complexity parameter defines what character sets to include.

U, L, D and S stands for Uppercase, Lowercase, Digits and Symbols. If supplied in lowercase (u, l, d, s), the returned string is allowed to contain characters from that set. If supplied in uppercase (U, L, D, S), the returned string is guranteed to contain at least one character from that set.

.PARAMETER Length
Specifies the length of the generated string.

.PARAMETER Complexity
Specifies the complexity of the string. Default is "ULDS"

.PARAMETER Exclude
Specifies individual characters to exclude from the string.

.INPUTS

None. You cannot pipe objects to Get-RandomString.

.OUTPUTS

System.String. Get-RandomString returns a randomized string.

.EXAMPLE

PS> Get-RandomString -Length 15
jyuTs=Fv`x-)*19

.EXAMPLE

PS> Get-RandomString -Complexity "UL" -Length 20
qXQeZIThBOnnOINlqsIa

.EXAMPLE

PS> Get-RandomString -Complexity "uld" -Length 17 -Exclude "ABZ1368vo"
2zttfqeELFF9zzuxX

.LINK

https://powersnippets.com/create-string/

#>
Function Get-RandomString{
    [CmdletBinding()]
    
    Param (
        [Parameter(Mandatory=$false)] 
        [ValidateRange(3, 100)]
        [Int]$Length = 15,

        [Parameter(Mandatory=$false)]
        [Char[]]$Complexity = "ULDS",
        
        [Parameter(Mandatory=$false)]
        [Char[]]$Exclude
    )

    $AllTokens = @()
    $Chars = @()
    $TokenSets = @{
        UpperCase = [Char[]]'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        LowerCase = [Char[]]'abcdefghijklmnopqrstuvwxyz'
        Digits    = [Char[]]'0123456789'
        Symbols   = [Char[]]'!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~'
    }

    # Select keys where $Complexity matches the first letter of the key
    # $_[0] is the first letter of the TokenSets key
    $TokenSets.Keys | Where-Object {$Complexity -Contains $_[0]} | ForEach-Object {
        
        # Set active tokenset
        # Exclude characters that are passed in $Exclude (Case sensitive)
        $TokenSet = $TokenSets.$_ | Where-Object {$Exclude -cNotContains $_} | ForEach-Object {$_}
        
        # Add random individual characters from $TokenSet to $Chars
        If ($_[0] -cle "Z") {
            $Chars += $TokenSet | Get-Random
        }
        # Add $TokenSet to $AllTokens
        $AllTokens += $TokenSet
    }

    # Add random individual tokens to $Chars until it reaches $Length
    While ($Chars.Count -lt $Length) {
        $Chars += $AllTokens | Get-Random
    }

    # Final mix of $Chars
    $Passwd = ($Chars | Sort-Object {Get-Random}) -Join ""
    Return $Passwd
}