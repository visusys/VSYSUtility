function Get-SanitizedUTF8Input{
    Param(
        [String]$InputString
    )
    $replaceTable = @{"ß"="ss";"à"="a";"á"="a";"â"="a";"ã"="a";"ä"="a";"å"="a";"æ"="ae";"ç"="c";"è"="e";"é"="e";"ê"="e";"ë"="e";"ì"="i";"í"="i";"î"="i";"ï"="i";"ð"="d";"ñ"="n";"ò"="o";"ó"="o";"ô"="o";"õ"="o";"ö"="o";"ø"="o";"ù"="u";"ú"="u";"û"="u";"ü"="u";"ý"="y";"þ"="p";"ÿ"="y"}

    foreach($key in $replaceTable.Keys){
        $InputString = $InputString -Replace($key,$replaceTable.$key)
    }
    $InputString = $InputString -replace '[^a-zA-Z0-9]', ''
    return $InputString
}