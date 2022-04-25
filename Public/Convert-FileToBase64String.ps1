function Convert-FileToBase64String {
    [CmdletBinding(ConfirmImpact='None')]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.IO.FileInfo[]]
        $File
    )
    begin {}
    process {
        foreach ($item in $File) {
            try {
                $FileContentBytes=Get-Content -LiteralPath $item.FullName -AsByteStream -ErrorAction Stop
                $FileAsString=[Convert]::ToBase64String($FileContentBytes)
                $FileAsString
            }
            catch {
                Write-Warning "[Export-FileToBase64String] Failed gathering Base64 string for $($item.FullName) $_"
            }
        }
    }
    end {}
}