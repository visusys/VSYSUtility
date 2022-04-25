function Test-AssemblyDLLIsLoaded {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position=0)]
        [ValidateScript({
            if ($_ -notmatch "(\.dll)") {
                throw [System.ArgumentException] "The file specified must be a DLL"
            }
            return $true
        })]
        [String]
        $AssemblyDLL
    )
    if(([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object {$_.ManifestModule -match $AssemblyDLL})){
        $true
    }else{
        $false
    }
}