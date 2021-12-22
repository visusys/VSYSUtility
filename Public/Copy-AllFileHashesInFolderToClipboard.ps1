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
    process {
        
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.Clipboard]::Clear()
    
        $FolderContents = Get-ChildItem -LiteralPath $Folder
        $HashResults = $FolderContents | Foreach-Object {
            if(Test-Path -LiteralPath $_ -PathType Leaf){
                [PSCustomObject][ordered]@{
                    Algorithm  = $Algorithm
                    Hash	   = (Get-FileHash -LiteralPath $_.FullName -Algorithm $Algorithm).Hash
                    Path	   = $_.Name
                }
            }
        }
 
        if($HashResults[0].Algorithm -eq 'MD5'){
            $col1 = -12
            $col2 = -37
        }else{
            $col1 = -12
            $col2 = -46
        }
        $i = $true
        foreach ($HashItem in $HashResults) {
            if($i){
                $FormatString = ("{0,$col1}{1,$col2}{2}" -f @(
                    "Algorithm"
                    "Hash"
                    "Path"
                ))
                $FormatString | Set-Clipboard
                $i=$false
            }else{
                $FormatString = ("{0,$col1}{1,$col2}{2}" -f @(
                    $HashItem.Algorithm
                    $HashItem.Hash
                    $HashItem.Path
                ))
                $FormatString | Set-Clipboard -Append
            }
        }

        $HashResults
    }
    
}