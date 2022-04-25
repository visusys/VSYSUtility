function Format-XMLRemoveNestedAttributes {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [System.Xml.XmlNodeList]
        $XMLNodeList,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [String]
        $Attribute,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName)]
        [ValidateRange(1,5)]
        [Int32]
        $Depth=4
    )

    foreach ($PropL1 in $XMLNodeList) {
        if(($PropL1.GetType().ToString()) -eq 'System.Xml.XmlElement'){
            $PropL1.RemoveAttribute($Attribute)
        }
        
        foreach ($PropL2 in $PropL1.ChildNodes) {
            if(($PropL2.GetType().ToString()) -eq 'System.Xml.XmlElement'){
                $PropL2.RemoveAttribute($Attribute)
            }
            
            foreach ($PropL3 in $PropL2.ChildNodes) {
                if(($PropL3.GetType().ToString()) -eq 'System.Xml.XmlElement'){
                    $PropL3.RemoveAttribute($Attribute)
                }
                
                foreach ($PropL4 in $PropL3.ChildNodes) {
                    if(($PropL4.GetType().ToString()) -eq 'System.Xml.XmlElement'){
                        $PropL4.RemoveAttribute($Attribute)
                    }

                    foreach ($PropL5 in $PropL4.ChildNodes) {
                        if(($PropL5.GetType().ToString()) -eq 'System.Xml.XmlElement'){
                            $PropL5.RemoveAttribute($Attribute)
                        }
                    }
                }
            }
        }
    }
}