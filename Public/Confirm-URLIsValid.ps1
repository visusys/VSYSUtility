<#
.SYNOPSIS
    Determines whether a URL is valid.

.DESCRIPTION
    Determines whether a URL is valid and conforms to common URL syntax.

    If the -Strict switch is set, all URLS must define a protocol (http/https/ftp).
    If a single string is passed, a boolean representing whether the URL is valid
    or invalid is returned. If an array of strings is passed, the function returns
    an array of PSCustomObjects with relevant data.

    Each PSCustom object has a 'URL' property (The URL passed), and a 'Valid'
    property (Whether the URL is valid).

    The main validation RegEx contained within this file is a PowerShell
    port of Diego Perini's original URL Validation RegEx: https://gist.github.com/dperini/729294

.PARAMETER URL
    A single URL string or an array of URL strings.

.PARAMETER Strict
    When set, successful validation requres that the passed URL/s include a protocol. (http/https/ftp)

.EXAMPLE
    PS C:\> Confirm-URLIsValid -URL "www.bing.com"
    True

.EXAMPLE
    PS C:\> Confirm-URLIsValid -URL "www.google.com" -Strict
    False

.EXAMPLE
    PS C:\> Confirm-URLIsValid -URL "https://docs.microsoft.com/en-us/powershell/" -Strict
    True

.EXAMPLE
    PS C:\> Confirm-URLIsValid -URL $ArrayOfURLs
    Returns an array of PSCustomObjects.

.EXAMPLE
    PS C:\> Confirm-URLIsValid -URL "http://कहानी.भारत" -Strict
    True

.INPUTS
    System.String: A single URL to validate.
    System.Array: An array of URLs to validate.

.OUTPUTS
    System.ValueType (Boolean): Whether the passed URL is valid.
    System.Collections.Generic.List (PSCustomObjects). Each object in the list contains validation information.

.NOTES
    Name: Confirm-URLIsValid
    Author: Visusys
    Release: 1.0.0
    License: MIT License
    DateCreated: 2021-11-17

.LINK
    https://github.com/visusys

#>
function Confirm-URLIsValid {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position = 0)]
        [string[]]
        $URL,

        [Parameter(Mandatory=$false)]
        [switch]
        $Strict
    )

    if($Strict){
        $s = ""
    }else{
        $s = "?"
    }
    $RegEx =
    "^" +
    # protocol identifier (optional)
    # short syntax # still required
    "(?:(?:(?:https?|ftp):)?\/\/)$s" +
    # user:pass BasicAuth (optional)
    "(?:\S+(?::\S*)?@)?" +
    "(?:" +
    # IP address exclusion
    # private & local networks
    "(?!(?:10|127)(?:\.\d{1,3}){3})" +
    "(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})" +
    "(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})" +
    # IP address dotted notation octets
    # excludes loopback network 0.0.0.0
    # excludes reserved space >= 224.0.0.0
    # excludes network & broadcast addresses
    # (first & last IP address of each class)
    "(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])" +
    "(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}" +
    "(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))" +
    "|" +
    # host & domain names, may end with dot
    # can be replaced by a shortest alternative
    # (?![-_])(?:[-\\w\`u{00a1}-\`u{ffff}]{0,63}[^-_]\\.)+
    "(?:" +
        "(?:" +
        "[a-z0-9`u{00a1}-`u{ffff}]" +
        "[a-z0-9`u{00a1}-`u{ffff}_-]{0,62}" +
        ")?" +
        "[a-z0-9`u{00a1}-`u{ffff}]\." +
    ")+" +
    # TLD identifier name, may end with dot
    "(?:[a-z`u{00a1}-`u{ffff}]{2,}\.?)" +
    ")" +
    # port number (optional)
    "(?::\d{2,5})?" +
    # resource path (optional)
    "(?:[/?#]\S*)?" +
    "$"

    $RegexOptions = [Text.RegularExpressions.RegexOptions]'IgnoreCase, CultureInvariant'
    $URLCollection = [System.Collections.Generic.List[object]]@()
    if($URL.Count -gt 1){
        foreach($Address in $URL) {
            $URLCollection.Add([PSCustomObject]@{
                URL     = $Address;
                Valid   = ([regex]::Match($Address, $RegEx, $RegexOptions)).Success;
            })
        }
        return $URLCollection
    }else{
        return ([regex]::Match($URL, $RegEx, $RegexOptions)).Success;
    }
}

# Confirm-URLIsValid -URL $URLsNormal -Strict

<# [string[]]$URLsNormal = @(
    "www.google.com"
    "github.com/PowerShell/PowerShell"
    "4sysops.com/archives/"
    "www.bing.com"
    "http://userid:password@example.com"
    "http://www.regexbuddy.com"
)

[string[]]$URLsStrictPositive = @(
    "http://foo.com/blah_blah"
    "http://foo.com/blah_blah/"
    "http://foo.com/blah_blah_(wikipedia)"
    "http://foo.com/blah_blah_(wikipedia)_(again)"
    "http://www.example.com/wpstyle/?p=364"
    "https://www.example.com/foo/?bar=baz&inga=42&quux"
    "http://✪df.ws/123"
    "http://userid:password@example.com:8080"
    "http://userid:password@example.com:8080/"
    "http://userid@example.com"
    "http://userid@example.com/"
    "http://userid@example.com:8080"
    "http://userid@example.com:8080/"
    "http://userid:password@example.com"
    "http://userid:password@example.com/"
    "http://142.42.1.1/"
    "http://142.42.1.1:8080/"
    "http://➡.ws/䨹"
    "http://⌘.ws"
    "http://⌘.ws/"
    "http://foo.com/blah_(wikipedia)#cite-1"
    "http://foo.com/blah_(wikipedia)_blah#cite-1"
    "http://foo.com/unicode_(✪)_in_parens"
    "http://foo.com/(something)?after=parens"
    "http://☺.damowmow.com/"
    "http://code.google.com/events/#&product=browser"
    "http://j.mp"
    "ftp://foo.bar/baz"
    "http://foo.bar/?q=Test%20URL-encoded%20stuff"
    "http://مثال.إختبار"
    "http://例子.测试"
    "http://उदाहरण.परीक्षा"
    "http://-.~_!$&'()*+,;=:%40:80%2f::::::@example.com"
    "http://1337.net"
    "http://a.b-c.de"
    "http://223.255.255.254"
    "https://foo_bar.example.com/"
    "http://www.regexbuddy.com"
    "http://www.regexbuddy.com/"
    "http://www.regexbuddy.com/index.html"
    "http://www.regexbuddy.com/index.html?source=library"
    "https://www.google.com"
    "http://www.regexbuddy.com"
    "https://www.regexbuddy.com/"
    "http://www.regexbuddy.com/index.html"
    "http://www.regexbuddy.com:80/index.html"
    "http://www.regexbuddy.com/cgi-bin/version.pl"
    "http://www.regexbuddy.com/index.html#top"
    "http://www.regexbuddy.com/index.html?param=value"
    "http://www.regexbuddy.com/index.html?param=value#top"
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
) #>