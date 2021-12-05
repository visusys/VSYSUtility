<#
.SYNOPSIS
    Converts a Unix time string to local time.

.PARAMETER UnixDate
    The UNIX date to convert.

.EXAMPLE
    Convert-UnixTime -UnixDate 1561849370

.INPUTS
    Int32

.NOTES
    Name: Convert-UnixTime
    License: MIT License
    DateCreated: 2021-12-05
    
#>
function Convert-UnixTime {
    Param(
        [Parameter(Mandatory = $true)][int32]$UnixDate
    )
     
    $orig = (Get-Date -Year 1970 -Month 1 -Day 1 -hour 0 -Minute 0 -Second 0 -Millisecond 0)        
    $timeZone = Get-TimeZone
    $utcTime = $orig.AddSeconds($UnixDate)
    $localTime = $utcTime.AddHours($timeZone.BaseUtcOffset.Hours)
    
    return $localTime
}