<#
.SYNOPSIS
    Validates whether a path is correctly formatted based on chosen parameters.

.DESCRIPTION
    Validates whether a path is correctly formatted based on chosen parameters.
    By default, any valid path with or without a filename will succeed.
    If the Container switch is set, validation will fail for paths that do not point to a directory.
    If the Leaf switch is set, validation will fail for paths that do not point to a file with a file extension.
    If a file extension is supplied to Extension, validation will fail for paths that do not point to a file with the exact file extension specified.
    The Leaf switch must be set in order to specify a file extension.

.PARAMETER Path
    The path you would like to evaluate.

.PARAMETER Container
    Tests whether the path points to a directory.

.PARAMETER Leaf
    Tests whether the path points to a file.

.PARAMETER Extension
    Tests whether the path points to a file with the specified extension. Requires -Leaf to be specified.

.NOTES
    Name: Confirm-WindowsPathIsValid
    Author: Visusys
    Version: 1.0.0
    DateCreated: 2021-11-12

.EXAMPLE
    Confirm-WindowsPathIsValid -Path "C:\Applications\Dev\"
    True

.EXAMPLE
    Confirm-WindowsPathIsValid -Path "C:\Program Files\Notepad++" -Container
    True

.EXAMPLE
    Confirm-WindowsPathIsValid -Path "C:\Program Files\PowerShell\7\pwsh.exe" -Container
    False

.EXAMPLE
    Confirm-WindowsPathIsValid -Path "C:\Music\Full Circle\Track01.mp3" -Leaf
    True

.EXAMPLE
    Confirm-WindowsPathIsValid -Path "\\192.168.0.1\SHARE\my folder\" -Container
    True

.EXAMPLE
    Confirm-WindowsPathIsValid -Path "\\SERVER-01\Shared1\WGroups\Log-1.txt" -Leaf
    True

.EXAMPLE
    Confirm-WindowsPathIsValid -Path "C:\Program Files\7-Zip\7z.exe" -Leaf -Extension "exe"
    True

.EXAMPLE
    Confirm-WindowsPathIsValid -Path "..\..\bin\my_executable.exe" -Leaf
    True

.LINK
    https://github.com/visusys
#>
function Confirm-WindowsPathIsValid {
    param (

        [Parameter(Mandatory, ParameterSetName = 'Leaf')]
        [Parameter(Mandatory, ParameterSetName = 'Container')]
        [Parameter(Mandatory, ParameterSetName = 'All')]
        [System.IO.FileInfo]
        $Path,

        [Parameter(Mandatory, ParameterSetName = 'Container')]
        [switch]
        $Container,

        [Parameter(Mandatory, ParameterSetName = 'Leaf')]
        [switch]
        $Leaf,

        [Parameter(Mandatory = $false, ParameterSetName = 'Leaf')]
        [string]
        $Extension
    )

    $IsValid = $Path -match '^(?:(?:[a-z]:|\\\\[a-z0-9_.$●-]+\\[a-z0-9_.$●-]+)\\|\\?[^\\\/:*?"<>|\r\n]+\\?)(?:[^\\\/:*?"<>|\r\n]+\\)*[^\\\/:*?"<>|\r\n]*$'
    if(!$IsValid){
        return $false
    }

    $ext        = [IO.Path]::GetExtension($Path)
    $ext        = $ext.Replace('.','')
    $Extension  = $Extension.Replace('.','')

    if($Leaf){
        if($ext -eq ''){
            return $false
        }
    }
    if($Extension){
        if($ext -ne $Extension){
            return $false
        }
    }
    if($Container){
        if($ext -ne ''){
            return $false
        }
    }
    return $IsValid
}

