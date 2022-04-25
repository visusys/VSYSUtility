function Format-SortNumerical {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Object[]]
        $Input,
        
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName)]
        [ValidateRange(2, 100)]
        [Byte]
        $MaximumDigitCount = 100,
        
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName)]
        [Switch]
        $Descending
    )
    
    Begin {
        [System.Object[]] $InnerInputObject = @()
        
        [Bool] $SortDescending = $False
        if ($Descending) {
            $SortDescending = $True
        }
    }
    
    Process {
        $InnerInputObject += $Input
    }

    End {
        $InnerInputObject | Sort-Object -Property `
        @{  Expression = {
                [Regex]::Replace($_, '(\d+)', {
                        "{0:D$MaximumDigitCount}" -f [Int64] $Args[0].Value })
            }
        },
        @{ Expression = { $_ } } -Descending:$SortDescending
    }
}
