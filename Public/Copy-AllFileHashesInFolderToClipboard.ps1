<#
.SYNOPSIS
    Copies hashes of all files in a folder using the algorithm specified by -Algorithm

.PARAMETER Folder
    The folder that contains files you want to copy hashes of.

.PARAMETER Algorithm
    The hash algorithm you want to copy.

.NOTES
    Name: Copy-AllFileHashesInFolderToClipboard
    Author: Visusys
    Version: 1.0.0
    DateCreated: 2021-11-09

.EXAMPLE
    Copy-AllFileHashesInFolderToClipboard -Folder "C:\Test\" -Algorithm 'MD5'

.LINK
    https://github.com/visusys
#>
function Copy-AllFileHashesInFolderToClipboard {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,Position = 0)]
        [string]
        $Folder,

        [Parameter(Mandatory = $true)]
        [ValidateSet('SHA1','SHA256','SHA384','SHA512','MD5', ErrorMessage = "Invalid algorithm supplied.")]
        [string]
        $Algorithm
    )

    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.Clipboard]::Clear()

    $HashList = [System.Collections.Generic.List[System.String]]@()
    $ParentFolder = Get-ChildItem $Folder
    $ParentFolder | Foreach-Object {
        $HashList.Add((Get-FileHash -Path $_.FullName -Algorithm $Algorithm).Hash)
    }
    [System.Windows.Forms.Clipboard]::SetText(($HashList | Out-String))
}