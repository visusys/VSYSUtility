function Convert-UnitsOfMemory {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory)]
        [ValidateSet('Bytes','KB','MB','GB','TB', IgnoreCase = $true)]
        [string]$From,

        [Parameter(Mandatory)]
        [ValidateSet('Bytes','KB','MB','GB','TB', IgnoreCase = $true)]
        [string]$To,

        [Parameter(Mandatory)]
        [double]$Value,

        [Parameter(Mandatory = $false)]
        [int]$Precision = 4

    )

    switch($From) {
        "Bytes" {$Value = $Value }
        "KB"    {$Value = $Value * 1024 }
        "MB"    {$Value = $Value * 1024 * 1024}
        "GB"    {$Value = $Value * 1024 * 1024 * 1024}
        "TB"    {$Value = $Value * 1024 * 1024 * 1024 * 1024}
    }

    switch ($To) {
        "Bytes" {return $value}
        "KB"    {$Value = $Value/1KB}
        "MB"    {$Value = $Value/1MB}
        "GB"    {$Value = $Value/1GB}
        "TB"    {$Value = $Value/1TB}
    }

    return [Math]::Round($value,$Precision,[MidPointRounding]::AwayFromZero)

}
