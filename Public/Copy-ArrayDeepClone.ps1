<#
.SYNOPSIS
    Creates a deep clone of an array.

.PARAMETER Array
    The array to clone.

.EXAMPLE
    $NewArray = Copy-ArrayDeepClone -Array $MyArray

.NOTES
    Name: Copy-ArrayDeepClone
    Author: Visusys
    Release: 1.0.0
    License: MIT License
    DateCreated: 2021-11-21

.LINK
    https://github.com/visusys
    
#>
function Copy-ArrayDeepClone {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position = 0)]
        [object]
        $Array
    )

    # Serialize and Deserialize data using BinaryFormatter
    $ms = New-Object System.IO.MemoryStream
    $bf = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
    $bf.Serialize($ms, $Array)
    $ms.Position = 0

    #Deep copied data
    $NewArray = $bf.Deserialize($ms)
    $ms.Close()

    return $NewArray
}


