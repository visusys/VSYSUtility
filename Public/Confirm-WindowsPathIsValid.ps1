<#
.SYNOPSIS
    Validates whether a path is correctly formatted based on chosen parameters.

.DESCRIPTION
    Validates whether a path is correctly formatted based on chosen parameters.
    By default, any valid path with or without a filename will succeed.
    If the ExcludeFile switch is used, validation will fail for paths that contain a file (with an extension)
    If RestrictExtension is set to a value, validation will only succeed for paths that contain a file with the exact extension specified by RestrictExtension.

.PARAMETER Path
    The path you would like to evaluate.

.PARAMETER RestrictExtension
    Tests whether the path points to a file with an extension specified by this value. 

.PARAMETER ExcludeFile
    If set, validation will fail if the path evaluates to a filename with an extension.

.NOTES
    Name: Confirm-WindowsPathIsValid
    Author: Visusys
    Version: 1.0.0
    DateCreated: 2021-11-10

.EXAMPLE
    Confirm-WindowsPathIsValid -Path "C:\Applications\Dev\"
    True

.EXAMPLE
    Confirm-WindowsPathIsValid -Path "C:\Test\Tools\DoSomething.exe" -ExcludeFile
    False

.EXAMPLE
    Confirm-WindowsPathIsValid -Path "D:\Logs\01-10-2021.txt" -RestrictExtension "txt"
    True

.LINK
    https://github.com/visusys
#>
function Confirm-WindowsPathIsValid {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position = 0)]
        [string]
        $Path,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $RestrictExtension = "",

        [Parameter(Mandatory = $false)]
        [switch]
        $ExcludeFile
    )

    if(($ExcludeFile) -and ($RestrictExtension -ne "")){
        throw "You can only use RestrictExtension if testing for a file."
    }

    if($ExcludeFile){
        $IsValid = $Path -match '^[a-zA-Z]:\\(?:[^\\\/:*?"<>|\r\n]+\\)*[^\\\/:*?"<>|\r\n.]*$'
        # [a-zA-Z]:\\                                   Drive
        # (?:[^\\\/:*?"<>|\r\n]+\\)*                    Folder
        # [^\\\/:*?"<>|\r\n.]*                          File (Dissallowed dot)
    }elseif ($RestrictExtension -ne "") {
        $IsValid = $Path -match '^[a-zA-Z]:\\(?:[^\\\/:*?"<>|\r\n]+\\)*[^\\\/:*?"<>|\r\n]*(?i)(\.'+$RestrictExtension+')$'
        # [a-zA-Z]:\\                                   Drive
        # (?:[^\\\/:*?"<>|\r\n]+\\)*                    Folder
        # [^\\\/:*?"<>|\r\n]*(?i)(\.EXTENSION)$'        File (Restricted to specific extension)
    }else {
        $IsValid = $Path -match '^[a-zA-Z]:\\(?:[^\\\/:*?"<>|\r\n]+\\)*[^\\\/:*?"<>|\r\n]*$'
        # [a-zA-Z]:\\                                   Drive
        # (?:[^\\\/:*?"<>|\r\n]+\\)*                    Folder
        # [^\\\/:*?"<>|\r\n.]*                          File
    }
    return $IsValid
}