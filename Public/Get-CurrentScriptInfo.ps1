
<#
.SYNOPSIS
    Gets information about the currently running script. If no parameters 
    are supplied, the function simply returns the current script's path.

.PARAMETER Path
    Returns the fully qualified path of the script.

.PARAMETER Folder
    Returns the folder that contains the currently running script.

.PARAMETER Filename
    Returns the filename of the script.

.PARAMETER FilenameBase
    Returns the filename of the script without an extension.

.PARAMETER InvocationDir
    Returns the directory where the script was invoked from.

.PARAMETER All
    Returns a PSCustomObject with all possible values.

.NOTES
    Name: Get-CurrentScriptInfo
    Author: Visusys
    Version: 1.0.1
    DateCreated: 2021-11-18

.EXAMPLE
    PS> Get-CurrentScriptInfo -Path
    D:\Dev\Powershell\Testing Scripts\Get-Something.ps1

.EXAMPLE
    PS> Get-CurrentScriptInfo -FilenameBase
    Get-Something

.EXAMPLE
    PS> Get-CurrentScriptInfo -Folder
    D:\Dev\Powershell\Testing Scripts\

.EXAMPLE
    PS> Get-CurrentScriptInfo -All
    PSCustomObject is returned with all values.

.LINK
    https://github.com/visusys
#>
function Get-CurrentScriptInfo {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        
        [Parameter(Mandatory, ParameterSetName="Path")]
        [switch]
        $Path,

        [Parameter(Mandatory, ParameterSetName="Folder")]
        [switch]
        $Folder,

        [Parameter(Mandatory, ParameterSetName="Name")]
        [switch]
        $Filename,

        [Parameter(Mandatory, ParameterSetName="BaseName")]
        [switch]
        $FilenameBase,

        [Parameter(Mandatory, ParameterSetName="InvocationDir")]
        [switch]
        $InvocationDir,

        [Parameter(Mandatory, ParameterSetName="All")]
        [switch]
        $All
    )
    
    $FullPath               = $PSCmdlet.MyInvocation.PSCommandPath
    $FullPathFolder         = $PSCmdlet.MyInvocation.PSScriptRoot
    $Name                   = Split-Path $FullPath -leaf
    $BaseName               = [System.IO.Path]::GetFileNameWithoutExtension($Name)
    $InvocDir               = (Get-Location).Path


    switch ($PSBoundParameters.Keys) {
        Path {  
            return $FullPath
        }
        Folder {  
            return $FullPathFolder
        }
        Filename {  
            return $Name
        }
        FilenameBase {  
            return $BaseName
        }
        InvocationDir {  
            return $InvocDir
        }
        All {  
            $AllInfoObj = [PSCustomObject]@{
                Path	        = $FullPath
                Folder		    = $FullPathFolder
                Filename		= $Name
                FilenameBase    = $BaseName
                InvocationDir   = $InvocDir
            }
            return $AllInfoObj
        }
    }

    return $FullPath
}