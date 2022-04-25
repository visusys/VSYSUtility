function Get-WindowsSpecialFolder {
    
    param (
        [Environment+SpecialFolder]
        [Parameter(Mandatory)]
        [String]
        $SpecialFolder
    )

    $F = [Environment]::GetFolderPath($SpecialFolder).TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
    $F
}