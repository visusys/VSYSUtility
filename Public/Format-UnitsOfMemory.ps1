function Format-UnitsOfMemory {
    [cmdletbinding()]
    param (

        [Parameter(Mandatory,Position=0)]
        [double]
        $Value,

        [Parameter(Mandatory,Position=1)]
        [validateset("Bytes", "KB", "MB", "GB", "TB")]
        [string]
        $FromFormat,

        [Parameter(Mandatory,Position=2)]
        [validateset("Bytes", "KB", "MB", "GB", "TB")]
        [string]
        $ToFormat,

        [Parameter(Mandatory=$false)]
        [int]
        $Precision = 3,

        [Parameter(Mandatory=$false)]
        [switch]
        $DisplayLabel
    )

    switch ($FromFormat) {
        "Bytes" { $value = $Value }
        "KB" { $value = $Value * 1024 }
        "MB" { $value = $Value * 1024 * 1024 }
        "GB" { $value = $Value * 1024 * 1024 * 1024 }
        "TB" { $value = $Value * 1024 * 1024 * 1024 * 1024 }
    }
    switch ($ToFormat) {
        "Bytes" { return $value }
        "KB" { $Value = $Value / 1KB }
        "MB" { $Value = $Value / 1MB }
        "GB" { $Value = $Value / 1GB }
        "TB" { $Value = $Value / 1TB }
    }
    if ($DisplayLabel) { 
        return "$([Math]::Round($value,$Precision,[MidPointRounding]::AwayFromZero)) $ToFormat" 
    } else { 
        return [Math]::Round($value, $Precision, [MidPointRounding]::AwayFromZero) 
    }
}