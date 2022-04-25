function Show-CommonDateTimeFormats {
    
    [CmdletBinding()]
    param ()

    "" | Out-Host
    "d ShortDatePattern                                                :  {0} " -f (Get-Date -Format d )
    "D LongDatePattern                                                 :  {0} " -f (Get-Date -Format D )
    "f Full date and time (long date and short time)                   :  {0} " -f (Get-Date -Format f )
    "F FullDateTimePattern (long date and long time)                   :  {0} " -f (Get-Date -Format F )
    "g General (short date and short time)                             :  {0} " -f (Get-Date -Format g )
    "G General (short date and long time)                              :  {0} " -f (Get-Date -Format G )
    "m MonthDayPattern                                                 :  {0} " -f (Get-Date -Format m )
    "M MonthDayPattern                                                 :  {0} " -f (Get-Date -Format M )
    "o Round-trip date/time pattern always uses the invariant culture  :  {0} " -f (Get-Date -Format o )
    "O Round-trip date/time pattern always uses the invariant culture  :  {0} " -f (Get-Date -Format O )
    "r RFC1123Pattern always uses the invariant culture                :  {0} " -f (Get-Date -Format r )
    "R RFC1123Pattern always uses the invariant culture                :  {0} " -f (Get-Date -Format R )
    "s SortableDateTimePattern always uses the invariant culture       :  {0} " -f (Get-Date -Format s )
    "t ShortTimePattern                                                :  {0} " -f (Get-Date -Format t )
    "T LongTimePattern                                                 :  {0} " -f (Get-Date -Format T )
    "u UniversalSortableDateTimePattern                                :  {0} " -f (Get-Date -Format u )
    "U Full date and time – universal time                             :  {0} " -f (Get-Date -Format U )
    "y YearMonthPattern                                                :  {0} " -f (Get-Date -Format y )
    "Y YearMonthPattern                                                :  {0} " -f (Get-Date -Format Y )
    
    
    "`nCustom Formats"
    
    "d/M/y                                  :  {0} " -f (Get-Date -Format d/M/y )
    "%d/%M/yy                               :  {0} " -f (Get-Date -Format d/M/yy )
    "dd/MM/yyyy                             :  {0} " -f (Get-Date -Format dd/MM/yyyyy )
    "dd/MM/yyyy %g                          :  {0} " -f (Get-Date -Format 'dd/MM/yyyyy %g')
    "dd/MM/yyyy gg                          :  {0} " -f (Get-Date -Format 'dd/MM/yyyyy gg')
    "dddd dd/MM/yyyy gg                     :  {0} " -f (Get-Date -Format 'dddd dd/MM/yyyyy gg')
    "dddd dd/MM/yyyy %h:m:s tt gg           :  {0} " -f (Get-Date -Format 'dddd dd/MM/yyyyy %h:m:s tt gg')
    "dddd dd/MM/yyyy hh:mm:s tt gg          :  {0} " -f (Get-Date -Format 'dddd dd/MM/ yyyyy hh:mm:s tt gg')
    "dddd dd/MM/yyyy HH:mm:s gg             :  {0} " -f (Get-Date -Format 'dddd dd/MM/yyyyy HH:mm:s gg')
    "dddd dd/MM/yyyy HH:mm:s.ffff gg        :  {0} " -f (Get-Date -Format 'dddd dd/MM/yyyyy HH:mm:s.ffff gg')
    "dddd dd MMM yyyy HH:mm:s.ffff gg       :  {0} " -f (Get-Date -Format 'dddd dd MMM yyyyy HH:mm:s.ffff gg')
    "dddd dd MMMM yyyy HH:mm:s.ffff gg      :  {0} " -f (Get-Date -Format 'dddd dd MMMM yyyyy HH:mm:s.ffff gg')
    "dddd dd MMMM yyyy HH:mm:s.ffff zz gg   :  {0} " -f (Get-Date -Format 'dddd dd MMMM yyyyy HH:mm:s.ffff zz gg')
    "dddd dd MMMM yyyy HH:mm:s.ffff zzz gg  :  {0} " -f (Get-Date -Format 'dddd dd MMMM yyyyy HH:mm:s.ffff zzz gg') 
}

