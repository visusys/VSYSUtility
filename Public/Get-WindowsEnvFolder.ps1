enum ENV {
    APPDATA
    ProgramData
    TEMP
    USERPROFILE
}

function Get-WindowsEnvFolder {
    
    param (
        [ENV]
        [Parameter(Mandatory)]
        [String]
        $Env
    )

    $F = Get-ChildItem env:
    foreach ($Item in $F) {
        if($Item.Name -eq $Env){
            return ($Item.Value).TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
        }
    }
}