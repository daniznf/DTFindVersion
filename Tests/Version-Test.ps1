# This is a comment
# $Version = "1.1.1"
$Version = "1.2.1" # Version = "1.2.2"
$Version = "1.3.1"

$Version = "1.4.1" <# $Version = "1.4.2" #>
<# $Version = "1.5.1" #> $Version = "1.5.2"
$Version <# middle comment = "1.6.1" #>  = "1.6.2"

$Version = "1.7.1" <# $Version = "1.7.2"
$Version = "1.8.1" #> $Version = "1.8.2"

<# Comment
$Version = "1.9.1" #> $Version = "1.9.2" <# comment
Comment
#>

<# Comment
$Version = "1.10.1" #> $Version = "1.10.2"

<# $Version = "1.11.1" #>

<# $Version = "1.12.1"
comment #>

<# comment
$Version = "1.13.1"
#>


Write-Host "Hello, version is $Version"

