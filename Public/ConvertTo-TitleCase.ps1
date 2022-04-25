Function ConvertTo-TitleCase {
    [cmdletbinding()]
    [alias("totc", "title")]
    Param(
       [Parameter(Mandatory, ValueFromPipeline)]
       [ValidateNotNullOrEmpty()]
       [string]$Text
    )
    Process {
       $low = $text.toLower()
       (Get-Culture).TextInfo.ToTitleCase($low)
    }
 }