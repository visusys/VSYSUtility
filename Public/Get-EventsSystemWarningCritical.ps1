<#
.SYNOPSIS
    Reports and optionally saves the last 100 system events that are categorized as a warning or critical.

.PARAMETER ComputerName
    The computer name you want to target for log collection.

.PARAMETER SaveToDisk
    If true, the report is saved to disk in the folder specified by -OutputFolder.

.PARAMETER OutputFolder
    Defines a directory to save the resulting eventlog report.

.PARAMETER Silent
    Does not open the report after saving.

.NOTES
    Name: Get-EventsSystemWarningCritical
    Author: Visusys
    Version: 1.0.0
    DateCreated: 2021-11-07T05:34:21.000-05:00

.EXAMPLE
    Get-EventsSystemWarningCritical -SaveToDisk

.LINK
    https://github.com/visusys
#>
function Get-EventsSystemWarningCritical {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$ComputerName = [System.Net.Dns]::GetHostName(),

        [Parameter(Mandatory = $false)]
        [switch]$SaveToDisk,

        [Parameter(Mandatory = $false)]
        [ValidateScript({ 
            Test-Path $_ -PathType Container
            },ErrorMessage = "The supplied path, {0}, does not exist."
        )]
        [string]$OutputFolder = [System.IO.Path]::GetTempPath(),

        [Parameter(Mandatory = $false)]
        [switch]$Silent

    )
    $events = Get-WinEvent -ComputerName $ComputerName –FilterHashtable @{logname=’system’; level=1,2,3} –MaxEvents 200
    $formatting = Format-Table -AutoSize -Wrap -InputObject $events
    $filename = 'EventLogReport-System.txt'

    if($SaveToDisk){
        Out-File -FilePath $OutputFolder\$filename -Width 160 -InputObject $formatting
        if(!$Silent){
            notepad $OutputFolder\$filename
        }
    }else{
        $events | Out-GridView
    }
}