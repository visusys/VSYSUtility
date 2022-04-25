Function Format-XMLPretty
{
    [CmdletBinding(DefaultParameterSetName="dom")]
    Param (
        [Parameter(Position=0,ValueFromPipeLine=$true,Mandatory=$true,ParameterSetName="dom")]
        [System.Xml.XmlDocument[]]$Xml,
        [Parameter(Position=0,ValueFromPipeLine=$true,Mandatory=$true,ParameterSetName="string")]
        [System.String[]]$XmlString
    )
    begin {}
    process {
        if($PSCmdlet.ParameterSetName -eq "string") {
            foreach($RawXml in $XmlString) {
                $Doc=New-Object System.Xml.XmlDocument
                $Doc.LoadXml($RawXml)
                $Xml+=$Doc
            }
        }
        foreach ($item in $Xml) {
            $StringWriter=New-Object System.IO.StringWriter
            $TextWriter=New-Object System.Xml.XmlTextWriter($StringWriter)
            $TextWriter.Formatting = [System.Xml.Formatting]::Indented
            $item.WriteContentTo($TextWriter)
            Write-Output $StringWriter.ToString()         
        }
    }
    end {}
}