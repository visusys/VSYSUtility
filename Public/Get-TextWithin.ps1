<#    
    .SYNOPSIS
        Get the text between two surrounding characters.

    .DESCRIPTION
        Get the text between two surrounding characters.

    .PARAMETER Text
        The text to retrieve the matches from.

    .PARAMETER WithinChar
        Single character, indicating the surrounding characters to retrieve the enclosing text for.
        For instance, if a single quote is provided, the function will return the string enclosed
        by single quotes.

        In some cases the matching ending character is "guessed" (e.g. '(' = ')')

    .PARAMETER StartChar
        Single character, indicating the start surrounding characters to retrieve the enclosing text for.

    .PARAMETER EndChar
        Single character, indicating the end surrounding characters to retrieve the enclosing text for. 

    .NOTES
        Name: Get-TextWithin
        Author: Originally from DBremen on Github
        Version: 1.0.0
        DateCreated: 2021-11-07T05:03:11.000-05:00

    .EXAMPLE
        # Retrieve all text within single quotes
        $s=@'
        here is 'some data'
        here is "some other data"
        this is 'even more data'
        '@

        Get-TextWithin $s "'"

    .EXAMPLE
        # Retrieve all text within custom start and end characters
        $s=@'
        here is /some data\
        here is /some other data/
        this is /even more data\
        '@

        Get-TextWithin $s -StartChar / -EndChar \
#>
function Get-TextWithin {
    
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory, 
            ValueFromPipeline = $true,
            Position = 0)]   
        $Text,
        [Parameter(ParameterSetName = 'Single', Position = 1)] 
        [char]$WithinChar = '"',
        [Parameter(ParameterSetName = 'Double')] 
        [char]$StartChar,
        [Parameter(ParameterSetName = 'Double')] 
        [char]$EndChar
    )
    $htPairs = @{
        '(' = ')'
        '[' = ']'
        '{' = '}'
        '<' = '>'
    }
    if ($PSBoundParameters.ContainsKey('WithinChar')) {
        $StartChar = $EndChar = $WithinChar
        if ($htPairs.ContainsKey([string]$WithinChar)) {
            $EndChar = $htPairs[[string]$WithinChar]
        }
    }
    $pattern = @"
(?<=\$StartChar).+?(?=\$EndChar)
"@
    [regex]::Matches($Text, $pattern).Value
}
