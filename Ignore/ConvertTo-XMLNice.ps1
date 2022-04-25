function ConvertTo-XMLNice {
    [CmdletBinding()]
    param (
        
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        [PSObject]
        $InputObject,

        [Parameter(Mandatory=$false, Position=1, ValueFromPipelineByPropertyName)]
        [String]
        $RootNodeName = "Objects"
    )

    begin {
        [xml]$Doc = New-Object System.Xml.XmlDocument
        #Add XML Declaration
        $null = $doc.AppendChild($doc.CreateXmlDeclaration("1.0","UTF-8",$null))
        #Add XML Root Node
        $root = $doc.AppendChild($doc.CreateElement($RootNodeName))
    }

    process {
        $childObject = $doc.CreateElement($InputObject.gettype().name)
        foreach ($propItem in $InputObject.psobject.properties) {
            $propNode = $doc.CreateElement($propItem.Name)
            $propNode.InnerText = $propItem.Value
            $null = $childObject.AppendChild($propNode)
        }
        $null = $root.AppendChild($childObject)
    }

    end {
        return $doc
    }
}