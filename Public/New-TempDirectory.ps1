<#
.SYNOPSIS
    Creates a new temporary directory located in the users temp path with a random filename.

.DESCRIPTION
    Creates a new temporary directory located in the users temp path with a random filename.
    The Length parameter specifies the length of the random filename. 
    If the GUID switch is passed, the directory will be named with a new GUID instead of a random alphanumeric sequence.

.PARAMETER Length
    The length of the random alphanumeric filename to be created.

.PARAMETER GUID
    When passed, the created filename is a new GUID instead of a random alphanumeric string.

.INPUTS
None. You cannot pipe objects to New-TempDirectory.

.OUTPUTS
System.IO.FileSystemInfo. New-TempDirectory returns a DirectoryInfo object.

.NOTES
    Name: New-TempDirectory
    Author: Visusys
    Version: 1.0.0
    DateCreated: 2021-11-09

.EXAMPLE
    New-TempDirectory -Length 16
    Result: New file 'N2FD8xOC6pMzqfbV' in %APPDATA%\Local\Temp

.EXAMPLE
    New-TempDirectory -GUID
    Result: New file '{7834a8a2-a4ad-409d-b9d1-c13fadaa1ead}' in %APPDATA%\Local\Temp

.LINK
    https://github.com/visusys
#>
function New-TempDirectory {
    [CmdletBinding()]
    Param (
        [ValidateRange(0, 30)]
        [Parameter(Mandatory = $false)]
        [Int32]$Length = 13,

        [Parameter(Mandatory = $false)]
        [Switch]$GUID 
    )

    $TempPath = [System.IO.Path]::GetTempPath()

    if ($guid) {
        $NewGUID = New-Guid
        $Output = (New-Item -ItemType Directory -Path (Join-Path $TempPath $NewGUID))
    } else {
        $RndName = Get-RandomAlphanumericString -Length $Length
        $Output = (New-Item -ItemType Directory -Path (Join-Path $TempPath $RndName))
    }

    if (Test-Path -LiteralPath $Output.FullName) { return $Output }
}