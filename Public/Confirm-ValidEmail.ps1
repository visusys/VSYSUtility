<#
.SYNOPSIS
    Validates whether an email or list of emails is correctly formatted (Conforms to RFC 5322 Standards)
    and optionally whether there are active MX records for the email's hostname.

.DESCRIPTION
    This function validates emails in three stages. 
    First: The passed address is cast to System.Net.Mail.MailAddress for an initial validity check.
    Second: The passed address is fed through a regular expression that validates according to RFC 5322.
    Third (Optional): The hostname of the address is resolved to check if a MX record exists.

.PARAMETER Address
    A single email address string, or an array of email address strings. 

.PARAMETER MXLookup
    When set, validation will additionally try to resolve the hostname. 
    If no MX records exist, validation fails for that address.

.EXAMPLE
    PS> Confirm-ValidEmail -Address 'someone@somewhere.com'
    True

.EXAMPLE
    PS> Confirm-ValidEmail '@@bar.com'
    False

.EXAMPLE
    PS> Confirm-ValidEmail -Address 'john@foobardoesntexist.net'
    True

    PS> Confirm-ValidEmail -Address 'john@foobardoesntexist.net' -MXLookup
    False

.EXAMPLE
    PS> Confirm-ValidEmail -Address $ListOfAddresses -MXLookup

.INPUTS
    System.String: A single email address.
    System.Array typed as String: A list of email addresses.

.OUTPUTS
    A PSCustomObject or multiple PSCustomObjects containing validation results.

.NOTES
    Name: Confirm-ValidEmail
    Author: Visusys
    Release: 1.0.1
    License: MIT License
    DateCreated: 2021-11-20

.LINK
    https://github.com/visusys

.LINK
    Confirm-ValidURL

.LINK
    Confirm-ValidWindowsPath
    
#>
function Confirm-ValidEmail { 

    [CmdletBinding()]
    
    param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [Alias("email")]
        [string[]]$Address,

        [Parameter(Mandatory=$false)]
        [Alias("mx")]
        [Switch]
        $MXLookup
    )

    begin {
        # RFC 5322 Email Validation Expression
        $RegExRFC5322 =     '(?im)(?:[a-z0-9!#$%&''*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&''*+/=?^_`{' + 
                            '|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\' + 
                            '[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]' + 
                            '(?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}' +
                            '(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:' + 
                            '(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])'

        $RegexOptions = [Text.RegularExpressions.RegexOptions]'IgnoreCase, CultureInvariant'
    }

    process {
        foreach($Email in $Address) {
            $CurrentEmail = [PSCustomObject]@{
                Address   = $Email
                Valid     = $true
                Host      = "Untested"
            }
            try {
                $AddressObj = [MailAddress]$Email
            }
            catch {
                $CurrentEmail.Valid = $false
            }
            if($CurrentEmail.Valid){
                $re = ([regex]::Match($Email, $RegExRFC5322, $RegexOptions)).Success
                $CurrentEmail.Valid = [System.Convert]::ToBoolean($re)
            }
            if($CurrentEmail.Valid){
                if($MXLookup){
                    try{
                        $DNSServer = @('8.8.8.8','8.8.4.4')
                        $DNSRecord = Resolve-DnsName -Name $AddressObj.Host -Type MX -Server $DNSServer -ErrorAction Stop
                        $CurrentEmail.Host = $DNSRecord[0].Name
                    }
                    catch{
                        $CurrentEmail.Host = 'Unreachable'
                        $CurrentEmail.Valid = $false
                    }
                }
            }
            $CurrentEmail
        }
    }
}

<# [string[]]$EmailsValid = @(
    'visusys@gmail.com'
    'first.last@iana.org',
    '"first\"last"@iana.org',
    'test@iana.org',
    '"Austin@Powers"@iana.org',
    'Ima.Fool@iana.org',
    '"Ima.Fool"@iana.org' ,
    'first.last@[IPv6:a1:a2::11.22.33.44]',
    'first.last@[IPv6:0123:4567:89ab:cdef::11.22.33.44]',
    'first.last@[IPv6:0123:4567:89ab:CDEF::11.22.33.44]',
    'first.last@[IPv6:a1::b2:11.22.33.44]',
    'visusys@gmail.com'
    'email@example.com'
    'firstname.lastname@example.com'
    'email@subdomain.example.com'
    'firstname+lastname@example.com'
    'email@123.123.123.123'
    'email@[123.123.123.123]'
    '“email”@example.com'
    '1234567890@example.com'
    'email@example-one.com'
    '_______@example.com'
    'email@example.name'
    'email@example.museum'
    'email@example.co.jp'
    'firstname-lastname@example.com'
)


[string[]]$EmailsInvalid = @(
    'first.last@sub.do,com',
    'first\@last@iana.org'
    '"""@iana.org'
    'first.last@[IPv6:1111:2222:3333:4444:5555:12.34.56.78]'
    'first.last@[IPv6:1111:2222:3333:4444:5555:6666:7777:12.34.56.78]'
    'first.last@[IPv6:1111:2222:3333:4444:5555:6666:7777]'
    'first.last@-xample.com'
    'first.last@exampl-.com'
    '"qu@iana.org'
    'ote"@iana.org'
    '.dot@iana.org'
    'dot.@iana.org'
    '{^c\@**Dog^}@cartoon.com'
    '@@bar.com'
    'aaa.com'
    'aaa@.com'
    'aaa@.123'
    'first.last@[IPv6:a1:11.22.33.44]'
    'first.last@[IPv6:a1:::11.22.33.44]'
    'first.last@[IPv6:a1:a2:::11.22.33.44]'
    'plainaddress'
    '#@%^%#$@#$@#.com'
    '@example.com'
    'Joe Smith <email@example.com>'
    'email.example.com'
    'email@example@example.com'
    '.email@example.com'
    'email.@example.com'
    'email..email@example.com'
    'あいうえお@example.com'
    'email@example.com (Joe Smith)'
    'email@example'
    'email@-example.com'
    'email@example.web'
    'email@111.222.333.44444'
    'email@example..com'
    'Abc..123@example.com'
)
#>

# Confirm-ValidEmail $EmailsValid -MXLookup
