<#
.SYNOPSIS
    Prints all console colors on the screen.
.EXAMPLE
    Get-ConsoleColors
.NOTES
    Name       : Get-ConsoleColors
    Author     : Mike Kanakos
    Version    : 1.0.3
    DateCreated: 2019-07-23
    DateUpdated: 2019-07-23  
.LINK
    https://github.com/compwiz32/PowerShell
#>
Function Get-ConsoleColors {
    [CmdletBinding()]
    Param()
    
    $List = [enum]::GetValues([System.ConsoleColor]) 
    
    ForEach ($Color in $List) {
        Write-Host "      $Color" -ForegroundColor $Color -NoNewline
        Write-Host "" 
    }

    ForEach ($Color in $List) {
        Write-Host "                   " -BackgroundColor $Color -NoNewline
        Write-Host "   $Color"     
    }
    
}