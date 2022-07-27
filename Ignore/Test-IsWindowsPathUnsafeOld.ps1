<#
.SYNOPSIS
    Checks if a supplied path is located in a sensitive windows directory.

.DESCRIPTION
    Checks if a supplied path is located in a sensitive windows directory.
    This function is used to prevent unintentional deletion or modification of 
    data in system critical folders on Windows machines.

.PARAMETER Path
    The path to check.

.PARAMETER Strict
    If set, the function performs additional more strict validation.

.PARAMETER Detailed
    If set, returns an object with details about the validation results
    instead of a single boolean value.

.NOTES
    Name: Test-IsWindowsPathUnsafe
    Author: Visusys
    Version: 1.0.0
    DateCreated: 2021-11-09

.EXAMPLE
    Test-IsWindowsPathUnsafe -Path "C:\Windows\" -Strict
    Result: True

.LINK
    https://github.com/visusys
#>
function Test-IsWindowsPathUnsafe {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [String[]]
        $Path,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName)]
        [Switch]
        $Strict,

        [Parameter(Mandatory=$false)]
        [Switch]
        $Detailed
    )

    begin {

        # Get OS drive
        $OSDrive = ((Get-CimInstance -ClassName CIM_OperatingSystem).SystemDrive)
        if ([String]::IsNullOrEmpty($OSDrive)) {
            $OSDrive = $env:SystemDrive
            if([String]::IsNullOrEmpty($OSDrive)){
                throw [System.IO.DriveNotFoundException] "Could not determine the system drive."
            }
        }

        $ShellApplication = New-Object -ComObject Shell.Application

        $UnsafeDirStatic = @( 
            $ShellApplication.NameSpace('shell:Desktop').Self.Path,
            $ShellApplication.NameSpace('shell:Common Desktop').Self.Path,
            $ShellApplication.NameSpace('shell:Common Documents').Self.Path,
            $ShellApplication.NameSpace('shell:CommonDownloads').Self.Path,
            $ShellApplication.NameSpace('shell:CommonMusic').Self.Path,
            $ShellApplication.NameSpace('shell:CommonPictures').Self.Path,
            $ShellApplication.NameSpace('shell:CommonVideo').Self.Path,
            $ShellApplication.NameSpace('shell:Common Programs').Self.Path,
            $ShellApplication.NameSpace('shell:Common Start Menu').Self.Path,
            $ShellApplication.NameSpace('shell:Common Startup').Self.Path,
            $ShellApplication.NameSpace('shell:Common Templates').Self.Path
            $ShellApplication.NameSpace('shell:Contacts').Self.Path
            $ShellApplication.NameSpace('shell:CredentialManager').Self.Path
            $ShellApplication.NameSpace('shell:CryptoKeys').Self.Path,
            $ShellApplication.NameSpace('shell:Device Metadata Store').Self.Path,
            $ShellApplication.NameSpace('shell:dpapiKeys').Self.Path,
            $ShellApplication.NameSpace('shell:LocalAppDataLow').Self.Path,
            $ShellApplication.NameSpace('shell:Local Documents').Self.Path,
            $ShellApplication.NameSpace('shell:Local Downloads').Self.Path,
            $ShellApplication.NameSpace('shell:Local Music').Self.Path,
            $ShellApplication.NameSpace('shell:Local Pictures').Self.Path,
            $ShellApplication.NameSpace('shell:Local Videos').Self.Path,
            $ShellApplication.NameSpace('shell:NetHood').Self.Path,
            $ShellApplication.NameSpace('shell:OneDriveCameraRoll').Self.Path,
            $ShellApplication.NameSpace('shell:OneDriveDocuments').Self.Path,
            $ShellApplication.NameSpace('shell:OneDriveMusic').Self.Path,
            $ShellApplication.NameSpace('shell:OneDrivePictures').Self.Path,
            $ShellApplication.NameSpace('shell:PrintHood').Self.Path,
            $ShellApplication.NameSpace('shell:ProgramFiles').Self.Path,
            $ShellApplication.NameSpace('shell:ProgramFilesCommon').Self.Path,
            $ShellApplication.NameSpace('shell:ProgramFilesCommonX64').Self.Path,
            $ShellApplication.NameSpace('shell:ProgramFilesCommonX86').Self.Path,
            $ShellApplication.NameSpace('shell:ProgramFilesX64').Self.Path,
            $ShellApplication.NameSpace('shell:ProgramFilesX86').Self.Path,
            $ShellApplication.NameSpace('shell:Programs').Self.Path,
            $ShellApplication.NameSpace('shell:Public').Self.Path,
            $ShellApplication.NameSpace('shell:PublicAccountPictures').Self.Path,
            $ShellApplication.NameSpace('shell:PublicLibraries').Self.Path,
            $ShellApplication.NameSpace('shell:Quick Launch').Self.Path,
            $ShellApplication.NameSpace('shell:Roaming Tiles').Self.Path,
            $ShellApplication.NameSpace('shell:AppData').Self.Path,
            $ShellApplication.NameSpace('shell:Local AppData').Self.Path,
            $ShellApplication.NameSpace('shell:Profile').Self.Path,
            $ShellApplication.NameSpace('shell:Personal').Self.Path,
            $ShellApplication.NameSpace('shell:My Music').Self.Path,
            $ShellApplication.NameSpace('shell:My Pictures').Self.Path,
            $ShellApplication.NameSpace('shell:My Video').Self.Path,
            $ShellApplication.NameSpace('shell:SendTo').Self.Path,
            $ShellApplication.NameSpace('shell:Start Menu').Self.Path,
            $ShellApplication.NameSpace('shell:Startup').Self.Path,
            $ShellApplication.NameSpace('shell:Common AppData').Self.Path,
            $ShellApplication.NameSpace('shell:UserProfiles').Self.Path,
            $ShellApplication.NameSpace('shell:UsersFilesFolder').Self.Path,
            $ShellApplication.NameSpace('shell:UserProgramFiles').Self.Path,
            $ShellApplication.NameSpace('shell:UserProgramFilesCommon').Self.Path,
            $ShellApplication.NameSpace('shell:Downloads').Self.Path,
            $ShellApplication.NameSpace('shell:Windows').Self.Path,
            $ShellApplication.NameSpace('shell:System').Self.Path,
            $ShellApplication.NameSpace('shell:SystemCertificates').Self.Path,
            $ShellApplication.NameSpace('shell:SystemX86').Self.Path,
            $ShellApplication.NameSpace('shell:Templates').Self.Path,
            [Environment]::ProcessPath,
            [System.IO.Path]::Combine(($ShellApplication.NameSpace('shell:UserProfiles').Self.Path), "Default"),
            [IO.Path]::GetPathRoot([Environment]::SystemDirectory).TrimEnd([IO.Path]::DirectorySeparatorChar),
            (Join-Path -Path $OSDrive -ChildPath '$WinREAgent'),
            (Join-Path -Path $OSDrive -ChildPath '$Windows.~WS'),
            (Join-Path -Path $OSDrive -ChildPath '$WINDOWS.~BT'),
            (Join-Path -Path $OSDrive -ChildPath 'Recovery'),
            (Join-Path -Path $OSDrive -ChildPath 'OneDriveTemp'),
            (Join-Path -Path $OSDrive -ChildPath 'Users\Default'),
            (Join-Path -Path $OSDrive -ChildPath 'Users\Default\AppData'),
            (Join-Path -Path $OSDrive -ChildPath 'Users\Default\Desktop'),
            (Join-Path -Path $OSDrive -ChildPath 'Users\Default\Documents'),
            (Join-Path -Path $OSDrive -ChildPath 'Users\Default\Downloads'),
            (Join-Path -Path $OSDrive -ChildPath 'Users\Default\Music'),
            (Join-Path -Path $OSDrive -ChildPath 'Users\Default\OneDrive'),
            (Join-Path -Path $OSDrive -ChildPath 'Users\Default\Pictures'),
            (Join-Path -Path $OSDrive -ChildPath 'Users\Default\Videos'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\Common Files'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files (x86)\Microsoft')
        )

        foreach ($Dir in $UnsafeDirStatic) {
            $Dir = [IO.Path]::TrimEndingDirectorySeparator($Dir)
        }

        $UnsafeDirRecursive = @(
            $ShellApplication.NameSpace('shell:Windows').Self.Path,
            $ShellApplication.NameSpace('shell:Fonts').Self.Path,
            (Join-Path -Path $OSDrive -ChildPath 'Users\Default'),
            (Join-Path -Path $OSDrive -ChildPath 'Users\Public'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\WindowsApps'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\dotnet'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\Windows Defender Advanced Threat Protection'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\Microsoft Update Health Tools'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\Windows Defender'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\Windows Mail'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\Windows Multimedia Platform'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\Windows NT'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\Windows Photo Viewer'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\Windows Portable Devices'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\Windows Security'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\Windows Sidebar'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\Windows Portable Devices'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\Windows Portable Devices'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\Windows Portable Devices'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\Windows Portable Devices'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\WindowsPowerShell'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\PowerShell'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files\Internet Explorer'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files (x86)\WindowsPowerShell'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files (x86)\Windows Sidebar'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files (x86)\Windows NT'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files (x86)\Windows Mail'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files (x86)\Windows Defender'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files (x86)\Microsoft.NET'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files (x86)\Internet Explorer'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files (x86)\Windows Portable Devices'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files (x86)\Windows Photo Viewer'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files (x86)\Windows Multimedia Platform'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files (x86)\InstallShield Installation Information'),
            (Join-Path -Path $OSDrive -ChildPath 'Program Files (x86)\Reference Assemblies'),
            [Environment]::ProcessPath
        )

        foreach ($Dir in $UnsafeDirRecursive) {
            $Dir = [IO.Path]::TrimEndingDirectorySeparator($Dir)
        }

        $UnsafeDirAnyDrive = @(
            'System Volume Information',
            '$RECYCLE.BIN'
        )

        $StrictUnsafeDirStatic = @(
            (Join-Path -Path $OSDrive -ChildPath 'Python27'),
            (Join-Path -Path $OSDrive -ChildPath 'Python38'),
            (Join-Path -Path $OSDrive -ChildPath 'Python310')
        )

        foreach ($Dir in $StrictUnsafeDirStatic) {
            $Dir = [IO.Path]::TrimEndingDirectorySeparator($Dir)
        }

        $StrictUnsafeDirRecursive = @(
            $ShellApplication.NameSpace('shell:Common AppData').Self.Path,
            $ShellApplication.NameSpace('shell:AppData').Self.Path,
            $ShellApplication.NameSpace('shell:Local AppData').Self.Path,
            [Environment]::ProcessPath
        )

        foreach ($Dir in $StrictUnsafeDirRecursive) {
            $Dir = [IO.Path]::TrimEndingDirectorySeparator($Dir)
        }
    }

    process {

        foreach ($SinglePath in $Path) {

            # Convert to backslash and limit consecutives
            $SinglePath = $SinglePath.Replace('/', '\')
            $SinglePath = $SinglePath -replace ('\\+', '\')
            $SinglePath = [IO.Path]::TrimEndingDirectorySeparator($SinglePath)

            $ValidationObject = [PSCustomObject]@{
                Path        = ''
                IsUnsafe    = $false
                Reason      = "Path is not sensitive."
            }

            foreach ($Dir in $UnsafeDirStatic) {
                if ($SinglePath -eq $Dir) {
                    $ValidationObject.Reason = "Path is a system critical directory. ($SinglePath)"
                    $ValidationObject.IsUnsafe = $true
                    $ValidationObject.Path   = $SinglePath
                }
            }
        
            if(!$ValidationObject.IsUnsafe){
                foreach ($Dir in $UnsafeDirRecursive) {
                    if ($SinglePath -like "$Dir*") {
                        $ValidationObject.Reason = "Path is within a system critical directory. ($SinglePath)"
                        $ValidationObject.IsUnsafe = $true
                        $ValidationObject.Path   = $SinglePath
                    }
                }
            }
            
            if(!$ValidationObject.IsUnsafe){
                foreach ($Dir in $UnsafeDirAnyDrive) {
                    $Escaped      = [Regex]::Escape($Dir)
                    $RegexOptions = [Text.RegularExpressions.RegexOptions]'IgnoreCase, CultureInvariant'
                    $RegEx        = "^[a-zA-Z]:\\$Escaped"
                    $Matched      = ([regex]::Match($SinglePath, $RegEx, $RegexOptions)).Success
                    $Matched      = [System.Convert]::ToBoolean($Matched)
        
                    if ($Matched) {
                        $ValidationObject.Reason = "Path is within a system critical directory. ($SinglePath)"
                        $ValidationObject.IsUnsafe = $true
                        $ValidationObject.Path   = $SinglePath
                    }
                }
            }

            if(!$ValidationObject.IsUnsafe){
                if (($SinglePath -match '^[a-zA-Z]:\\$') -or ($SinglePath -match '^[a-zA-Z]:$')) {
                    $ValidationObject.Reason = "Path is the root of a drive. ($SinglePath)"
                    $ValidationObject.IsUnsafe = $true
                    $ValidationObject.Path   = $SinglePath
                }
            }

            # Begin Strict Checks
            
            if ($Strict) {
                if(!$ValidationObject.IsUnsafe){
                    foreach ($Dir in $StrictUnsafeDirStatic) {
                        if ($SinglePath -eq $Dir) {
                            $ValidationObject.Reason = "Strict: Path is a possibly unsafe directory: $SinglePath"
                            $ValidationObject.IsUnsafe = $true
                            $ValidationObject.Path   = $SinglePath
                        }
                    }
                }

                if(!$ValidationObject.IsUnsafe){
                    foreach ($Dir in $StrictUnsafeDirRecursive) {
                        if ($SinglePath -like "$Dir*") {
                            $ValidationObject.Reason = "Strict: Path is within a possibly unsafe directory: $SinglePath"
                            $ValidationObject.IsUnsafe = $true
                            $ValidationObject.Path   = $SinglePath
                        }
                    }
                }
            }

            if(!$ValidationObject.IsUnsafe){
                Write-Verbose "$SinglePath is not a sensitive path."
                $ValidationObject.Reason = "Path is not a sensitive directory."
                $ValidationObject.IsUnsafe = $false
                $ValidationObject.Path   = $SinglePath
            }

            if($Detailed){
                $ValidationObject
            }else{
                $ValidationObject.IsUnsafe
            }
             
        }
    }

    end {}
}

# [string[]]$PathsToCheck = @(
#     'C:\',
#     'C:\Windows\System32\'
#     'C:\Windows\SysWOW64\'
#     'C:\Users\Username\Desktop\'
#     'C:\Users\futur\Desktop\'
#     'C:\ProgramData\'
#     'C:\Program Files (x86)\Adobe'
#     'C:\Program Files (x86)'
#     'C:\Program Files (x86)\Microsoft.NET\Primary Interop Assemblies'
#     'C:\Program Files (x86)\icofx3\icofx3.exe'
# )

# Test-IsWindowsPathUnsafe 'C:\Windows\System32\'