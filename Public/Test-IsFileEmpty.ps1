Function Test-IsFileEmpty {
    Param (
        [Parameter(Mandatory = $true)]
        [string]
        $File
    )
    if ((Test-Path -LiteralPath $file) -and !(([IO.File]::ReadAllText($file)) -match '\S')) {
        return $true
    } else {
        return $false
    }
}