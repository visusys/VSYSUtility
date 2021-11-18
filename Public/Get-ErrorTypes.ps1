Function Get-ErrorTypes {
    [CmdletBinding()]
    Param()
    [appdomain]::CurrentDomain.GetAssemblies() | ForEach-Object {
        Try {
            $_.GetExportedTypes() | Where-Object { $_.Fullname -match 'Exception' }
        }
        Catch {}
    } | Select-Object FullName
}