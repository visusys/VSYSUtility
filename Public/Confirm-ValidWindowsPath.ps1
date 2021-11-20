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
    The path or array of paths you would like to validate.

.PARAMETER Container
    Validates whether the path points to a directory.

.PARAMETER Leaf
    Validates whether the path points to a file.

.PARAMETER Extension
    Validates whether the path points to a file with the specified extension.

.PARAMETER UNC
    Validates whether the path is in UNC format.

.PARAMETER Absolute
    Validates whether the path is absolute. 

.PARAMETER Relative
    Validates whether the path is relative. 

.EXAMPLE
    Confirm-ValidWindowsPath -Path "C:\Applications\Dev\"
    True

.EXAMPLE
    Confirm-ValidWindowsPath -Path "C:\Program Files\Notepad++" -Container
    True

.EXAMPLE
    Confirm-ValidWindowsPath -Path "C:\Program Files\PowerShell\7\pwsh.exe" -Container
    False

.EXAMPLE
    Confirm-ValidWindowsPath -Path "C:\Music\Full Circle\Track01.mp3" -Leaf
    True

.EXAMPLE
    Confirm-ValidWindowsPath -Path "\\192.168.0.1\SHARE\my folder\" -Container
    True

.EXAMPLE
    Confirm-ValidWindowsPath -Path "\\SERVER-01\Shared1\WGroups\Log-1.txt" -Leaf -UNC
    True

.EXAMPLE
    Confirm-ValidWindowsPath -Path "C:\Program Files\7-Zip\7z.exe" -Leaf -Extension "exe"
    True

.EXAMPLE
    Confirm-ValidWindowsPath -Path "..\..\bin\my_executable.exe" -Leaf
    True

.EXAMPLE
    Confirm-ValidWindowsPath -Path "..\..\bin\my_executable.exe" -Leaf -Absolute
    False

.EXAMPLE
    Confirm-ValidWindowsPath -Path $ArrayOfPaths -Leaf -Absolute
    PSCustomObject will be returned with data for all paths in $ArrayOfPaths

.INPUTS
    A single path (string), or an array of path strings.

.OUTPUTS
    A generic list containing a PSCustomObject with validation values.

.NOTES
    Name: Confirm-ValidWindowsPath
    Author: Visusys
    Release: 1.0.2
    License: MIT License
    DateCreated: 2021-11-18

.LINK
    Confirm-ValidEmail

.LINK
    Confirm-ValidURL

.LINK
    https://github.com/visusys
#>

function Confirm-ValidWindowsPath {
    param (

        [Parameter(Mandatory, ParameterSetName = 'All')]
        [Parameter(Mandatory, ParameterSetName = 'Leaf')]
        [Parameter(Mandatory, ParameterSetName = 'Container')]
        [Parameter(Mandatory, ParameterSetName = 'Relative')]
        [Parameter(Mandatory, ParameterSetName = 'UNC')]
        [Parameter(Mandatory, ParameterSetName = 'Absolute')]
        [String[]]
        $Path,

        [Parameter(Mandatory = $false, ParameterSetName = 'Leaf')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Container')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Absolute')]
        [Parameter(Mandatory, ParameterSetName = 'UNC')]
        [switch]
        $UNC,

        [Parameter(Mandatory = $false, ParameterSetName = 'Leaf')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Container')]
        [Parameter(Mandatory = $false, ParameterSetName = 'UNC')]
        [Parameter(Mandatory, ParameterSetName = 'Absolute')]
        [switch]
        $Absolute,

        [Parameter(Mandatory = $false, ParameterSetName = 'Leaf')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Container')]
        [Parameter(Mandatory, ParameterSetName = 'Relative')]
        [switch]
        $Relative,

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

    $RegExOptions = [Text.RegularExpressions.RegexOptions]'IgnoreCase, CultureInvariant'
    $RegEx = 
        '^'+ 
        # Drive
        '(?:(?:[a-z]:|\\\\[a-z0-9_.$●-]+\\[a-z0-9_.$●-]+)\\|' + 
        # Relative Path
        '\\?[^\\\/:*?"<>|\r\n]+\\?)' + 
        # Folder
        '(?:[^\\\/:*?"<>|\r\n]+\\)*' +
        #File
        '[^\\\/:*?"<>|\r\n]*' +
        '$'

    function SwitchValidation {
        param (
            [Parameter(Mandatory)]
            [String]
            $Testpath
        )

        $ext                = [IO.Path]::GetExtension($Testpath)
        $ext                = $ext.Replace('.','')
        $ExtensionArg       = $Extension.Replace('.','')
        $PathInfo           = [System.Uri]$Testpath
        $PathIsUNC          = $PathInfo.IsUnc
        $PathIsAbsolute     = [IO.Path]::IsPathRooted($Testpath)

        #$ext | Out-Host


        if(!(([regex]::Match($Testpath, $RegEx, $RegexOptions)).Success)){
            Write-Verbose "01: RegEx Match"
            return $false
        }

        if($Leaf -and ($ext -eq '')){
            Write-Verbose "02: Leaf Match"
            return $false
        }

        if($Extension -and ($ext -ne $ExtensionArg)){
            Write-Verbose "03: Extension Match"
            return $false
        }

        if($Container -and ($ext -ne '')){
            Write-Verbose "04: Folder Match"
            return $false
        }
    
        if($UNC -and (!$PathIsUNC)){
            Write-Verbose "05: UNC Match"
            return $false
        }
    
        if($Absolute -and (!$PathIsAbsolute)){
            Write-Verbose "06: Absolute Match"
            return $false
        }

        if($Relative -and $PathIsAbsolute){
            Write-Verbose "07: Relative Match"
            return $false
        }

        return $true
    }

    $PathCollection = [System.Collections.Generic.List[object]]@()
    foreach($p in $Path) {
        $PathCollection.Add([PSCustomObject]@{
            Path     = $p;
            Valid    = (SwitchValidation -Testpath $p)
        })
    }
    return $PathCollection
}

#Confirm-ValidWindowsPath -Path 'C:\Windows'

<#
[string[]]$DummyPathSet = @(
    "D:\VMs\Win10Sandbox\caches\GuestAppsCache\appData\ef7705b372eb14a0de0ad44feb0a69c0.appinfo"
    "D:\ZBrush\Fibermesh\JHill Fibermesh Presets\"
    "\\192.168.0.1\SHARE\my folder\"
    "\\SERVER-01\Shared1\WGroups\Log-1.txt"
    "..\..\bin\my_executable.exe"
    "C:\Program Files\7-Zip\7z.exe"
    "C:\Music\Full Circle\Track01.mp3"
) #>