function ConvertTo-XMLEscapedString {

    param (
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        [String[]]
        $Input
    )
    process {
        foreach ($String in $Input) {
            $String = $String.replace("&",'&amp;')
            $String = $String.replace("<",'&lt;')
            $String = $String.replace(">",'&gt;')
            $String = $String.replace("'",'&apos;')
            $String = $String.replace('"','&quot;')
            $String
        }
    }

    end {}
}