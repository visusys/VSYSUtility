<#
.SYNOPSIS
    Copies the hash of the file specified by -File using the algorithm specified by -Algorithm

.PARAMETER File
    The file you want to copy the MD5 hash of

.PARAMETER Algorithm
    The hash algorithm you want to copy the MD5 hash of.

.NOTES
    Name: Copy-HashToClipboard
    Author: Visusys
    Version: 1.0.0
    DateCreated: 2021-11-09

.EXAMPLE
    Copy-HashToClipboard -File "C:\Test\SomeFile.exe" -Algorithm 'MD5'

.LINK
    https://github.com/visusys
#>
function Copy-HashToClipboard {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,Position = 0)]
        [string]
        $File,

        [Parameter(Mandatory = $true)]
        [ValidateSet('SHA1','SHA256','SHA384','SHA512','MD5', ErrorMessage = "Invalid algorithm supplied.")]
        [string]
        $Algorithm
    )
    Add-Type -AssemblyName System.Windows.Forms
    $hash = Get-FileHash -Path $File -Algorithm $Algorithm
    [System.Windows.Forms.Clipboard]::SetText($hash.Hash)
}

