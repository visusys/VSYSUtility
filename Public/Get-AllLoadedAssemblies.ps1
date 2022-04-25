function Get-AllLoadedAssemblies {
    [CmdletBinding()]
    param ()
    [System.AppDomain]::CurrentDomain.GetAssemblies() | Select-Object -Property * | Out-GridView
}