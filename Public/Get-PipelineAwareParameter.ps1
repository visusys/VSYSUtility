<#
.SYNOPSIS
    Enumerates parameters that can accept pipeline input.

.DESCRIPTION
    Get-PipelineAwareParameter is a test function that exposes parameter binding information. Specify the name of any valid command, and it returns the parameters that can accept pipeline input.

.PARAMETER Command
    The specific command to analyze.

.NOTES
    Name: Get-PipelineAwareParameter
    Author: Originally from powershell.one
    Version: 1.0.0
    DateCreated: 2021-11-07T05:03:11.000-05:00

.EXAMPLE
    Get-PipelineAwareParameter -Command Stop-Service

.LINK
    https://powershell.one/powershell-internals/scriptblocks/powershell-pipeline
#>
function Get-PipelineAwareParameter {
    param
    (
        # Name of command to examine:
        [Parameter(Mandatory)]
        [string]
        $Command
    )
  
    # exclude common parameters:
    $commonParameter = 'Verbose',
    'Debug',
    'ErrorAction',
    'WarningAction',
    'InformationAction',
    'ErrorVariable',
    'WarningVariable',
    'InformationVariable',
    'OutVariable',
    'OutBuffer',
    'PipelineVariable'
  
    # get command information:
    $commandInfo = Get-Command -Name $Command
  
    # identify unique parameters
    $hash = [System.Collections.Generic.Dictionary[[string], [int]]]::new()
    $CommandInfo.ParameterSets.Foreach{ $_.Parameters.Foreach{ $hash[$_.Name]++ } }
  
    # look at each parameterset separately...
    $CommandInfo.ParameterSets | ForEach-Object {
        # ...list the unique parameters that are allowed in this parameterset:
        if ($_.IsDefault) {
            $parameters = '(default)'
        } else {
            $parameters = $_.Parameters.Name.Where{ $commonParameter -notcontains $_ }.Where{ $hash[$_] -eq 1 }.Foreach{ "-$_" } -join ', '
        }
    
        # check each parameter in this parameterset...
        $_.Parameters | 
        # include only those that accept pipeline input:
        Where-Object { $_.ValueFromPipeline -or $_.ValueFromPipelineByPropertyName } |
        ForEach-Object {
            # if the parameter accepts pipeline input via object properties...
            if ($_.ValueFromPipelineByPropertyName) {
                # list the property names in relevant order:
                [System.Collections.Generic.List[string]]$aliases = $_.Aliases
                $aliases.Insert(0, $_.Name)
                $propertyNames = '$input.' + ($aliases -join ', $input.')
            } else {
                $propertyNames = ''
            }
        
            # return info about parameter:
            [PSCustomObject]@{
                # parameter name:
                Parameter   = '-{0}' -f $_.Name
                # required data type
                Type        = '[{0}]' -f $_.ParameterType
                # accepts pipeline input directly?
                ByValue     = $_.ValueFromPipeline
                # reads property values?
                ByProperty  = $propertyNames
                # list of parameters in this parameterset
                TriggeredBy = $parameters
            }
        }
    }
}