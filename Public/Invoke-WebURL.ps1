
<#
.SYNOPSIS
    Opens a specified URL in the default browser.

.PARAMETER URL
    The URL to open.

.EXAMPLE
    Invoke-WebURL -URL "www.google.com"

.INPUTS
    System.String: The URL to open.

.OUTPUTS
    Nothing. Your default browser will open the URL.

.NOTES
    Name: Invoke-WebURL
    Author: Visusys
    Release: 1.0.0
    License: MIT License
    DateCreated: 2021-11-17

.LINK
    https://github.com/visusys

#>

function Invoke-WebURL {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [ValidateScript({
            if (!(Confirm-URLIsValid -URL $_)) {
                throw "Invalid URL specified."
            }
            $true
        })]
        [Alias("link","site","address")]
        [String]
        $URL
    )
    Start-Process $URL
}

#Invoke-WebURL "www.google.com"