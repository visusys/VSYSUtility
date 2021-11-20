<#
.SYNOPSIS
    Checks if a supplied path is located in a sensitive windows directory.

.DESCRIPTION
    Checks if a supplied path is located in a sensitive windows directory.
    This function is used to prevent unintentional deletion or modification of data in system critical folders on Windows machines.

.PARAMETER Path
    The path to check.

.PARAMETER CheckValid
    Whether to run validation to test if the path exists, and to make sure a correctly formatted path was passed.

.NOTES
    Name: Test-IsSensitiveWindowsPath
    Author: Visusys
    Version: 1.0.0
    DateCreated: 2021-11-09

.EXAMPLE
    Test-IsSensitiveWindowsPath -Path "C:\Windows\"
    Result: True

.EXAMPLE
    Test-IsSensitiveWindowsPath -Path "C:\SomeNonExistantPath\" -CheckValid
    Result: Error: The path specified doesn't exist.

.LINK
    https://github.com/visusys
#>
function Test-IsSensitiveWindowsPath {

	[CmdletBinding()]
    Param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 0
        )]
        [Alias('folder','directory','dir')]
        [String[]]$Path,

        [Parameter(Mandatory=$false)]
        [Switch]
        $Strict
    )

    # Convert to backslash and limit consecutives
    $Path = $Path.Replace('/','\')
    $Path = $Path -replace('\\+','\')
    $Path = $Path.TrimEnd('\')

    # Get OS drive
    $OSDrive = ((Get-CimInstance -ClassName CIM_OperatingSystem).SystemDrive)
    if(($OSDrive -eq "") -or ($OSDrive -eq " ") -or ($null -eq $OSDrive)){
        throw [System.IO.DriveNotFoundException] "Could not determine the system drive."
    }

    $CriticalDirectories = @(
        $($OSDrive + '\Windows'),
        $($OSDrive + '\$WinREAgent')
        $($OSDrive + '\Users\Default')
    )

    $CriticalDirectoriesAnyDrive = @(
        'System Volume Information',
        '$RECYCLE.BIN'
    )

    $PossiblyUnwantedDirectories = @(     
        $($OSDrive + '\Users'),
        $($OSDrive + '\Users\' + $env:UserName),
        $($OSDrive + '\Users\' + $env:UserName + '\AppData'),
        $($OSDrive + '\Users\' + $env:UserName + '\AppData\LocalLow'),
        $($OSDrive + '\Users\' + $env:UserName + '\AppData\Roaming'),
        $($OSDrive + '\ProgramData'),
        $($OSDrive + '\Program Files (x86)'),
        $($OSDrive + '\Program Files')
        
    )

    #Initialize
    $ValidationList = [System.Collections.Generic.List[object]]@()

    foreach ($iPath in $Path) {
        $ValidationObject  = [PSCustomObject][ordered]@{
            Path           = ''
            IsSensitive	   = $false
            Reason		   = "Path is not sensitive."
            
        }

        # Begin Critical Checks
        foreach ($CriticalDir in $CriticalDirectories){
            if($iPath -eq $CriticalDir){
                $ValidationObject.Reason = "Path is a system critical directory."
                $ValidationObject.IsSensitive = $true
                $ValidationObject.Path = $iPath
                $ValidationList.Add($ValidationObject)
                break
            }
            if($iPath -like "$CriticalDir*"){
                $ValidationObject.Reason = "Path is within a system critical directory."
                $ValidationObject.IsSensitive = $true
                $ValidationObject.Path = $iPath
                $ValidationList.Add($ValidationObject)
                break
            }
        }
        if(!($ValidationObject.IsSensitive)){
            foreach ($CriticalDir in $CriticalDirectoriesAnyDrive) {
                $Escaped = [Regex]::Escape($CriticalDir)
                $RegexOptions = [Text.RegularExpressions.RegexOptions]'IgnoreCase, CultureInvariant'
                $RegEx = "^[a-zA-Z]:\\$Escaped" #TODO: Improve this regex. Support UNC.
                $Matched = ([regex]::Match($iPath, $RegEx, $RegexOptions)).Success
                $Matched = [System.Convert]::ToBoolean($Matched)

                if($Matched){
                    $ValidationObject.Reason = "Path is within a system critical directory. (System Volume Information or `$RECYCLE.BIN)"
                    $ValidationObject.IsSensitive = $true
                    $ValidationObject.Path = $iPath
                    $ValidationList.Add($ValidationObject)
                    break
                }
            }
        }
        # End Critical Checks
        # Begin Strict Checks
        if($Strict){
            if(!($ValidationObject.IsSensitive)){
                if(($iPath -match '^[a-zA-Z]:\\$') -or ($iPath -match '^[a-zA-Z]:$')){
                    $ValidationObject.Reason = "Strict: Path is the root of a drive."
                    $ValidationObject.IsSensitive = $true
                    $ValidationObject.Path = $iPath
                    $ValidationList.Add($ValidationObject)
                }
            }
            foreach ($UnwantedDir in $PossiblyUnwantedDirectories) {
                if($iPath -eq $UnwantedDir){
                    $ValidationObject.Reason = "Strict: Path is a possibly unwanted directory: $UnwantedDir"
                    $ValidationObject.IsSensitive = $true
                    $ValidationObject.Path = $iPath
                    $ValidationList.Add($ValidationObject)
                    break
                }
            }
        }
        # End Strict Checks
        if(!($ValidationObject.IsSensitive)){
            Write-Verbose "$Path is not a sensitive path."
            $ValidationObject.Reason = "Path is not a sensitive directory."
            $ValidationObject.IsSensitive = $false
            $ValidationObject.Path = $iPath
            $ValidationList.Add($ValidationObject)
        }

    }
    return $ValidationList
}
 
<# [string[]]$PathsToCheck = @(
    'C:\',
    'C:\Windows\System32\'
    'C:\Windows\SysWOW64\'
    'C:\Users\Username\Desktop\'
    'C:\ProgramData\'
    'C:\Program Files (x86)\Adobe'
    'C:\Program Files (x86)'
    'C:\Program Files (x86)\Microsoft.NET\Primary Interop Assemblies'
    'C:\Program Files (x86)\icofx3\icofx3.exe'
)

Test-IsSensitiveWindowsPath $PathsToCheck -Strict #>