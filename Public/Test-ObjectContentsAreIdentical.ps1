<#
.SYNOPSIS
    Tests whether objects contained in Arrays and .NET Lists are all identical.

.DESCRIPTION
    This function tests to see if every element in an object or array is the same. 
    It has broad support across a range of datatypes and objects. There
    are edge-cases where some obscure datatype won't be recognized. If you
    want one added, feel free to open an issue on GitHub.

.PARAMETER InputObject
    The object containing the values to be evaluated for uniqueness.

.PARAMETER CaseSensitive
    If set, string comparisons (Only System.String and System.Char) will be
    case sensitive. In the future, PSObjects and HashTables will inherit
    this switch as well.

.EXAMPLE
    Test-ObjectContentsAreIdentical -InputObject @("Test","TEsT","TEST","tesT")
    True

.EXAMPLE
    Test-ObjectContentsAreIdentical -InputObject @("Test","TEsT","TEST","tesT") -CaseSensitive
    False

.EXAMPLE
    $GenericList = [System.Collections.Generic.List[object]]@()
    $GenericList.Add([PSCustomObject]@{UserID = "307023"; Name = "Bob"; Email = "bobGrady@gmail.com"})
    $GenericList.Add([PSCustomObject]@{UserID = "307023"; Name = "Bob"; Email = "bobGrady@gmail.com"})
    $GenericList.Add([PSCustomObject]@{UserID = "307023"; Name = "Bob"; Email = "bobGrady@gmail.com"})
    Test-ObjectContentsAreIdentical $GenericList
    True

.INPUTS
    System.Collections.Generic.List
    System.Collections.ArrayList
    System.Array

    All inputs should be populated with objects or values that you want to evaluate.

.OUTPUTS
    System.Boolean
    True if all object contents are identical.

.NOTES
    Name: Test-ObjectContentsAreIdentical
    Author: Visusys
    Release: 1.0.0
    License: MIT License
    DateCreated: 2021-11-22

.LINK
    https://github.com/visusys
    
#>
function Test-ObjectContentsAreIdentical {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [object]
        [Alias("input","object","o")]
        $InputObject,

        [Parameter(Mandatory = $false)]
        [switch]
        $CaseSensitive
    )

    begin {

        $refType = $InputObject[0].GetType().FullName
        $refVal = $InputObject[0]
        $index = 0
        $IsTheSame = $false

        Write-Verbose "Log: Hit the begin block."

        "reftype:  " + $refType
        "refVal:   " + $refVal
        "index:    " + $index

        [string[]]$StringRefTypes = @(
            "System.String", 
            "System.Char"
        )
        [string[]]$NumericalReftypes = @(
            "System.String", 
            "System.Char", 
            "System.Int32", 
            "System.Int64", 
            "System.Decimal", 
            "System.Double", 
            "System.Single", 
            "System.UInt16", 
            "System.UInt32", 
            "System.UInt64", 
            "System.Int16", 
            "System.Byte", 
            "System.SByte"
        )

    }

    process {
        Write-Verbose "Log: Hit the process block."

        if($InputObject.Count -eq 1){
            return $true
        }
        switch ($refType) {
            #TODO: Add case sensitivity / insensitivity
            'System.Management.Automation.PSCustomObject' { 
                Write-Verbose "Hit: PSCustomObject"
                $FirstObject = $InputObject[0]
                for ($i = 0; $i -lt $InputObject.Count; $i++) {
                    if ((Compare-Object $FirstObject.PSObject.Properties $InputObject[$i].PSObject.Properties)){
                        $IsTheSame = $false
                        break
                    }else{
                        $IsTheSame = $true
                    }
                }
            }
            #TODO: Add case sensitivity / insensitivity
            'System.Collections.Hashtable'{
                Write-Verbose "Hit: Hashtable"
                $FirstObject = $InputObject[0]
                for ($i = 0; $i -lt $InputObject.Count; $i++) {
                    if ((Compare-Object -ReferenceObject $FirstObject.Values -DifferenceObject $InputObject[$i].Values)){
                        $IsTheSame = $false
                        break
                    }else{
                        $IsTheSame = $true
                    }
                }
            }
            {($_ -in $NumericalReftypes) -or ($_ -in $StringRefTypes)} {

                Write-Verbose "Hit: Numerical or String"

                if ($CaseSensitive) {
                    $IsTheSame = !([bool]($InputObject.Where({ $_ -cne $InputObject[0] })))
                } else {
                    $IsTheSame = !([bool]($InputObject.Where({ $_ -ne $InputObject[0] })))
                }
                break
            }
            'System.Boolean' {
                Write-Verbose "Hit: Boolean"
                $IsTheSame = $true
                foreach ($bool in $InputObject) {
                    if ($bool -isnot $refType) {
                        $IsTheSame = $false
                        break
                    }
                    if ($bool -ne $refVal) {
                        $IsTheSame = $false
                        break
                    }
                }
                break
            }
            'System.Xml.XmlDocument' {
                Write-Verbose "Hit: XML"
                $IsTheSame = $true
                $FirstXMLDoc = $InputObject[0]
                foreach ($XMLDoc in $InputObject) {
                    if($FirstXMLDoc.OuterXml -ne $XMLDoc.OuterXML){
                        $IsTheSame = $false
                        break
                    }
                }
                break
            }
            'System.Text.RegularExpressions.Regex' {
                Write-Verbose "Hit: RegEx"
                $IsTheSame = $true
                $FirstRegEx = $InputObject[0].ToString()
                foreach ($RegExItem in $InputObject) {
                    if($FirstRegEx -cne $RegExItem.ToString()){
                        $IsTheSame = $false
                    }
                }
                break
            }
            default {
                Write-Verbose "Hit: Default"
                throw "Unhandled Type"
            }
        }

        $IsTheSame
    }
}

<# [regex[]]$RegExList = @(
    '^\S+@\S+\.\S+$',
    '^\S+@\S+\.\S+$',
    '^\S+@\S+\.\S+$'
)

Test-ObjectContentsAreIdentical $RegExList -Verbose #>


<# $PSCustom1 = [PSCustomObject]@{
    Username = 'VISUSYS'
    Path     = 'C:\Users\VISUSYS'
    Type     = 'Administrator'
}
$PSCustom2 = [PSCustomObject]@{
    Username = 'VISUSYS'
    Path     = 'C:\Users\VISUSYS'
    Type     = 'Administrator'
}
$Another = [PSCustomObject]@{
    Username = 'VISUSYS'
    Path     = 'C:\Users\VISUSYS'
    Type     = 'Administrator'
}

Test-ObjectContentsAreIdentical @($PSCustom1, $PSCustom2, $Another) # System.Management.Automation.PSCustomObject #>


# Test-ObjectContentsAreIdentical @(2,2,2,2,2,2) -Verbose # System.Int32
# Test-ObjectContentsAreIdentical @("Test","TEsT","TEST","tesT") -Verbose # System.String
# Test-ObjectContentsAreIdentical @($false,$false,$false,$false) # System.Boolean



<# $GenericList = [System.Collections.Generic.List[object]]@()
$GenericList.Add([PSCustomObject]@{UserID = "307023"; Name = "Bob"; Email = "bobGrady@gmail.com"})
$GenericList.Add([PSCustomObject]@{UserID = "307023"; Name = "Bob"; Email = "bobGrady@gmail.com"})
$GenericList.Add([PSCustomObject]@{UserID = "307023"; Name = "Bob"; Email = "bobGrady@gmail.com"})
Test-ObjectContentsAreIdentical $GenericList -Verbose #>


# $CharObj = [char[]]([char]'a',[char]'a',[char]'a',[char]'a',[char]'a') # System.Char


<# $GenericListHash = [System.Collections.Generic.List[object]]@()
$GenericListHash.Add(@{UserID = "307023"; Name = "Jay"; Email = "jsalva@gmail.com"})
$GenericListHash.Add(@{UserID = "307023"; Name = "Jay"; Email = "jsalva@gmail.com"})
$GenericListHash.Add(@{UserID = "307023"; Name = "Jay"; Email = "jsalva@gmail.com"})
Test-ObjectContentsAreIdentical $GenericListHash -Verbose #>

<# [decimal[]]$DecimalArr = @(
    1.2456,
    1.2456,
    1.2456
)
Test-ObjectContentsAreIdentical $DecimalArr -Verbose #>

<# [sbyte[]]$DoubleArr = @(
    25,
    25,
    25,
    25,
    25,
    25
)
Test-ObjectContentsAreIdentical $DoubleArr -Verbose #>


<# $xmlstuff1 = [xml]@("<settings>
<process>test</process>
<xmlDir>\\serv1\dev</xmlDir>
<scanDir>\\serv1\dev</scanDir>
<processedDir>\\serv1\dev\done</processedDir>
<errorDir>\\serv1\dev\err</errorDir>
<log>\\serv1\dev\log\dev-Log##DATE##.log</log>
<retryDelay>5</retryDelay>
<retryLimit>3</retryLimit>
</settings>")

$xmlstuff2 = [xml]@("<settings>
<process>test</process>
<xmlDir>\\serv1\dev</xmlDir>
<scanDir>\\serv1\dev</scanDir>
<processedDir>\\serv1\dev\done</processedDir>
<errorDir>\\serv1\dev\err</errorDir>
<log>\\serv1\dev\log\dev-Log##DATE##.log</log>
<retryDelay>5</retryDelay>
<retryLimit>3</retryLimit>
</settings>")

$xmlstuff3 = [xml]@("<settings>
<process>test</process>
<xmlDir>\\serv1\dev</xmlDir>
<scanDir>\\serv1\dev</scanDir>
<processedDir>\\serv1\dev\done</processedDir>
<errorDir>\\serv1\dev\err</errorDir>
<log>\\serv1\dev\log\dev-Log##DATE##.log</log>
<retryDelay>5</retryDelay>
<retryLimit>3</retryLimit>
</settings>")

$XMLList = @($xmlstuff1,$xmlstuff2,$xmlstuff3)
Test-ObjectContentsAreIdentical $XMLList -Verbose #>
