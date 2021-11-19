
<#
.SYNOPSIS
    Gets information about the currently running script. If no parameters 
    are supplied, the function simply returns the current script's path.

.PARAMETER ScriptPath
    Returns the fully qualified path of the script.

.PARAMETER ScriptFolder
    Returns the folder that contains the currently running script.

.PARAMETER ScriptName
    Returns the filename of the script.

.PARAMETER ScriptBaseName
    Returns the filename of the script without an extension.

.PARAMETER All
    Returns a PSCustomObject with all possible values.

.NOTES
    Name: Get-CurrentScriptInfo
    Author: Visusys
    Version: 1.0.0
    DateCreated: 2021-11-18

.EXAMPLE
    PS> Get-CurrentScriptInfo -ScriptPath
    D:\Dev\Powershell\Testing Scripts\Get-Something.ps1

.EXAMPLE
    PS> Get-CurrentScriptInfo -ScriptBaseName
    Get-Something

.EXAMPLE
    PS> Get-CurrentScriptInfo -ScriptFolder
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
        $ScriptPath,

        [Parameter(Mandatory, ParameterSetName="Folder")]
        [switch]
        $ScriptFolder,

        [Parameter(Mandatory, ParameterSetName="Name")]
        [switch]
        $ScriptName,

        [Parameter(Mandatory, ParameterSetName="BaseName")]
        [switch]
        $ScriptBaseName,

        [Parameter(Mandatory, ParameterSetName="InvocationDir")]
        [switch]
        $ScriptInvocationDir,

        [Parameter(Mandatory, ParameterSetName="All")]
        [switch]
        $All
    )
    
    $FullPath               = $PSCmdlet.MyInvocation.PSCommandPath
    $Folder                 = $PSCmdlet.MyInvocation.PSScriptRoot
    $Name                   = Split-Path $FullPath -leaf
    $BaseName               = [System.IO.Path]::GetFileNameWithoutExtension($Name)
    $InvocationDir          = (Get-Location).Path


    switch ($PSBoundParameters.Keys) {
        ScriptPath {  
            return $FullPath
        }
        ScriptFolder {  
            return $Folder
        }
        ScriptName {  
            return $Name
        }
        ScriptBaseName {  
            return $BaseName
        }
        ScriptInvocationDir {  
            return $InvocationDir
        }
        All {  
            $AllInfoObj = [PSCustomObject]@{
                ScriptPath	        = $FullPath
                ScriptFolder		= $Folder
                ScriptName		    = $Name
                ScriptBaseName      = $BaseName
                ScriptInvocationDir = $InvocationDir
            }
            return $AllInfoObj
        }
    }

    return $FullPath
}

#Get-CurrentScriptInfo -All