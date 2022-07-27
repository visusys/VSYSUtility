function Convert-GUIDToString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [String]
        $GUID
    )
    try {

        # Create a GUID Object from as string
        [System.GUID]$TheGUID = [System.GUID]::New($GUID)
    }catch{
        throw [System.IO.IOException] "Could not convert input ($GUID) to valid GUID."
    }
    $TheGUID.toString()
}
