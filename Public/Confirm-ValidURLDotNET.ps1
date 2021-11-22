<#
.SYNOPSIS
    Determines whether a URL is valid. 
    Uses .NET System.Uri casting instead of RegEx.

.DESCRIPTION
    Determines whether a URL is valid.

    Outputs a list of PSCustomObjects that have three properties:

    URL:    The passed URL.
    Valid:  Whether the URL is valid.
    Host:   The Host Name of the URL.

.PARAMETER URL
    A single URL string or an array of URL strings.

.EXAMPLE
    PS C:\> Confirm-ValidURLDotNET -URL "www.bing.com"
    True (Inside returned list)

.EXAMPLE
    PS C:\> Confirm-ValidURLDotNET -URL $ListOfURLs
    Returns a .NET generic list of validation results.

.EXAMPLE
    PS C:\> 'www.google.com' | Confirm-ValidURLDotNET
    True (Inside returned list)

.EXAMPLE   
    PS C:\> $ListOfURLs | Confirm-ValidURLDotNET | Where-Object Valid -eq $false
    Returns only the URLs that are invalid.

.INPUTS
    System.String: A single URL to validate.
    System.Array: An array of URLs to validate.
    The URL property Accepts pipeline input.

.OUTPUTS
    System.Collections.Generic.List containing PSCustomObjects. 
    Each object in the list contains validation information.

.NOTES
    Name: Confirm-ValidURLDotNET
    Author: Visusys
    Release: 1.0.0
    License: MIT License
    DateCreated: 2021-11-21

.LINK
    https://github.com/visusys

.LINK
    Confirm-ValidURL

.LINK
    Confirm-ValidEmail

.LINK
    Confirm-ValidWindowsPath
#>
function Confirm-ValidURLDotNET {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [string[]]
        $URL
    )
    Begin {
        $ValidationResults = [System.Collections.Generic.List[object]]@()
    }
    Process {
        foreach ($u in $URL) {
            $URIObject = [PSCustomObject][ordered]@{
                URL	   = ''
                Valid  = $true
                Host   = ''
            }
            try {
                $casted = [System.Uri]$u
                $URIObject.URL = $u
                $URIObject.Valid = $true
                if(!($casted.Host)){
                    $URIObject.Host = "Undetermined"
                }else{
                    $URIObject.Host = $casted.Host
                }
                $ValidationResults.Add($URIObject)
            } catch {
                $URIObject.URL = $u
                $URIObject.Valid = $false
                $URIObject.Host = "Invalid"
                $ValidationResults.Add($URIObject)
            }
        }
    }
    End {
        return $ValidationResults
    }
}
<# 
[string[]]$URLsStrictPositive = @(
    "http://foo.com/blah_blah",
    "http://foo.com/blah_blah/",
    "http://foo.com/blah_blah_(wikipedia)",
    "http://foo.com/blah_blah_(wikipedia)_(again)",
    "http://www.example.com/wpstyle/?p=364",
    "https://www.example.com/foo/?bar=baz&inga=42&quux",
    "http://✪df.ws/123",
    "http://userid:password@example.com:8080",
    "http://userid:password@example.com:8080/",
    "http://userid@example.com",
    "http://userid@example.com/",
    "http://userid@example.com:8080",
    "http://userid@example.com:8080/",
    "http://userid:password@example.com",
    "http://userid:password@example.com/",
    "http://142.42.1.1/",
    "http://142.42.1.1:8080/",
    "http://➡.ws/䨹",
    "http://⌘.ws",
    "http://⌘.ws/",
    "http://foo.com/blah_(wikipedia)#cite-1",
    "http://foo.com/blah_(wikipedia)_blah#cite-1",
    "http://foo.com/unicode_(✪)_in_parens",
    "http://foo.com/(something)?after=parens",
    "http://☺.damowmow.com/",
    "http://code.google.com/events/#&product=browser",
    "http://j.mp",
    "ftp://foo.bar/baz",
    "http://foo.bar/?q=Test%20URL-encoded%20stuff",
    "http://مثال.إختبار",
    "http://例子.测试",
    "http://उदाहरण.परीक्षा",
    "http://-.~_!$&'()*+,;=:%40:80%2f::::::@example.com",
    "http://1337.net",
    "http://a.b-c.de",
    "http://223.255.255.254",
    "https://foo_bar.example.com/",
    "http://www.regexbuddy.com",
    "http://www.regexbuddy.com/",
    "http://www.regexbuddy.com/index.html",
    "http://www.regexbuddy.com/index.html?source=library",
    "https://www.google.com",
    "http://www.regexbuddy.com",
    "https://www.regexbuddy.com/",
    "http://www.regexbuddy.com/index.html",
    "http://www.regexbuddy.com:80/index.html",
    "http://www.regexbuddy.com/cgi-bin/version.pl",
    "http://www.regexbuddy.com/index.html#top",
    "http://www.regexbuddy.com/index.html?param=value",
    "http://www.regexbuddy.com/index.html?param=value#top",
    "http://www.regexbuddy.com/index.html?param=value&param2=value2"
)

[string[]]$URLsStrictNegative = @(
    "http://"
    "http://."
    "http://.."
    "http://../"
    "http://?"
    "http://??"
    "http://??/"
    "http://#"
    "http://##"
    "http://##/"
    "http://foo.bar?q=Spaces should be encoded"
    "//"
    "//a"
    "///a"
    "///"
    "http:///a"
    "foo.com"
    "rdar://1234"
    "h://test"
    "http:// shouldfail.com"
    ":// should fail"
    "http://foo.bar/foo(bar)baz quux"
    "ftps://foo.bar/"
    "http://-error-.invalid/"
    "http://a.b--c.de/"
    "http://-a.b.co"
    "http://a.b-.co"
    "http://0.0.0.0"
    "http://10.1.1.0"
    "http://10.1.1.255"
    "http://224.1.1.1"
    "http://1.1.1.1.1"
    "http://123.123.123"
    "http://3628126748"
    "http://.www.foo.bar/"
    "http://www.foo.bar./"
    "http://.www.foo.bar./"
    "http://10.1.1.1"
    "http://10.1.1.254"
)
 #>
#$URLsStrictPositive | Confirm-ValidURLDotNET
#$URLsStrictNegative | Confirm-ValidURLDotNET
#$URLsStrictNegative | Confirm-ValidURLDotNET | Where-Object Valid -eq $false