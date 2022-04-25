Function Format-UnitsOfMemoryAutomatic {
    Param
    (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [float]$number
    )
    Begin{
        $sizes = 'KB','MB','GB','TB','PB'
    }
    Process {
        # New for loop
        for($x = 0;$x -lt $sizes.count; $x++){
            if ($number -lt [int64]"1$($sizes[$x])"){
                if ($x -eq 0){
                    return "$number B"
                } else {
                    $num = $number / [int64]"1$($sizes[$x-1])"
                    $num = "{0:N2}" -f $num
                    return "$num $($sizes[$x-1])"
                }
            }
        }
    }
    End{}
}