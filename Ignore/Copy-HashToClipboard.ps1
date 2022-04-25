<#
.SYNOPSIS
    Copies the hash of the file/s specified by -File using the algorithm specified by -Algorithm

.PARAMETER File
    The file or files you want to copy the MD5 hash of.

.PARAMETER Algorithm
    The hash algorithm to use.

.NOTES
    Name: Copy-HashToClipboard
    Author: Visusys
    Version: 1.1.0
    DateCreated: 2021-11-09

.EXAMPLE
    Copy-HashToClipboard -File "C:\Test\SomeFile.exe" -Algorithm 'MD5'

.EXAMPLE
    Copy-HashToClipboard -File $ArrayOfFiles -Algorithm 'SHA1'

.LINK
    https://github.com/visusys
#>
function Copy-HashToClipboard {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateScript({
            if (!(Test-Path -LiteralPath $_)) {
                throw [System.ArgumentException] "File or Folder does not exist."
            }
            if (Test-Path -LiteralPath $_ -PathType Container) {
                throw [System.ArgumentException] "Folder passed when a file was expected."
            }
            return $true
        })]
        [String[]]
        $Files,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [ValidateSet('SHA1','SHA256','SHA384','SHA512','MD5', ErrorMessage = "Invalid algorithm supplied.")]
        [String]
        $Algorithm = 'MD5'
    )

    begin {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.Clipboard]::Clear()
    }
    process {
        $FileHashList = [System.Collections.ArrayList]@()
        foreach ($File in $Files) {
            $Hash = Get-FileHash -LiteralPath $File -Algorithm $Algorithm
            $FileHashList.Add($Hash.Hash)
        }
        $FileHashList | Set-Clipboard
    }
    
}

