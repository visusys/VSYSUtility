Function Add-DirectoryToSystemPath{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position=0)]
        [ValidateScript({
            if (-Not ($_ | Test-Path -PathType Container) ) {
                throw "File or folder does not exist." 
            }
            return $true
        })]
        [string]$Path
    )
    
    if(-not(Test-Path -Path $Path)){
        Write-Warning "The path you are adding doesn't actually exist."
    }

    $OriginalPath = (Get-Item "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment").GetValue("PATH", $null, "DoNotExpandEnvironmentNames")
    $OriginalPathEntries = $OriginalPath -split ';'
    $OriginalPathEntries = $OriginalPathEntries | Where-Object {$_}

    $NewPathEntries = new-object system.collections.arraylist

    foreach($OriginalPathEntry in $OriginalPathEntries) {
        if($OriginalPathEntry -eq $Path){
            return "$Path already exists in PATH."
        }else{
            [void]$NewPathEntries.Add($OriginalPathEntry)
        }
    }
    [void]$NewPathEntries.Add($Path)
    $NewPath = $NewPathEntries -Join ';'

    [Environment]::SetEnvironmentVariable('path',$NewPath,'Machine')

    return $NewPath
}

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
     $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
     Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
     Exit
    }
}

# Write-Warning "Path: $args"
Add-ToSystemPath -Path $args[0]

