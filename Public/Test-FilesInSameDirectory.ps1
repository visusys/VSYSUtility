function Test-FilesInSameDirectory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateScript({
            if(!($_ | Test-Path) ){
                throw "File or folder does not exist" 
            }
            return $true
        })]
        [String[]]
        [Alias("file","f")]
        $Files
    )
    
    begin{
        $DirList = [System.Collections.Generic.List[object]]@()
    }

    process {
        foreach($File in ($Files | Where-Object {$_} | Resolve-Path)) {
            if(Test-Path -LiteralPath $File) {
                $WorkingFile = Convert-Path -LiteralPath $File
                $DirList.Add([System.IO.Path]::GetDirectoryName($WorkingFile))
            }
        }

        if(!(Test-ObjectContentsAreIdentical $DirList)){
            return $false
        }else {
            return $true
        }
    }
}