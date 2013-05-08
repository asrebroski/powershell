cls
$logpath = "C:\Documents and Settings\asrebroski.VOCUSPROD\Desktop\file_count.txt"
$jobServers = 1..20 | % { "{0:D2}" -f $_}
$appServers = 1..35 | % { "{0:D2}" -f $_}
$jobServerNames = $jobServers | % { "spjob$_"} #"spjob01" 
$appServerNames = $appServers | % { "spapp$_"}
$drives = @("c$", "d$")
$jobServerDirs = @("\VocusWeb\GRWeb\GRConvert1\Images\Internal", "\VocusWeb\GRWeb\GRSpace1\Images\Internal", "\VocusWeb\GRWeb\GRSpace2\Images\Internal", "\VocusWeb\GRWeb\VocusGR\Images\Internal", "\VocusWeb\GRWeb\GRSpace3\Images\Internal", "\VocusWeb\GRWeb\Tasb\Images\Internal", "\VocusWeb\GRWeb\vfw\Images\Internal", "\VocusWeb\GRSecure\SecureGR\Images\Internal", "\VocusWeb\Universal\GR\Images\Internal")
$appServerDirs = @("\VocusWeb\Universal\Images\Internal")
$emailFrom = "GRimages@vocus.com"
$emailTo = "asrebroski@vocus.com"
$subject = "GR Images report"



rm $logpath -Force

foreach ($ServerName in $jobServerNames ) {
$ping = Test-Connection $ServerName -Count 1 -q

if ($ping) 
{
$blaharray = @()
Write-Host "$ServerName is alive! Checking for image directories."
Foreach ($drive in $drives) {
$jobServerDirs | % {
$jobServerPath = "\\" + "$ServerName" + "\" + "$drive" + "$_"

$blaharray += $jobServerPath
}
}

$blaharray | % {
$jobTestPath = Test-Path $_

if ($jobTestPath -eq $True)
{
clv count
Write-Host "$_ path exists!"
$count = [System.IO.Directory]::GetFiles("$_").count
Write-Host "$_ has $count images"

"$_" + " - " + "$count"  >> $logpath 
}
}
}
clv blaharray
}

foreach ($ServerName in $appServerNames ) {
$ping = Test-Connection $ServerName -Count 1 -q

if ($ping) 
{
$blaharray = @()
Write-Host "$ServerName is alive! Checking for image directories."
Foreach ($drive in $drives) {
$appServerDirs | % {
$appServerPath = "\\" + "$ServerName" + "\" + "$drive" + "$_"

$blaharray += $appServerPath
}
}

$blaharray | % {
$appTestPath = Test-Path $_

if ($appTestPath -eq $True)
{
clv count
Write-Host "$_ path exists!"
$count = [System.IO.Directory]::GetFiles("$_").count
Write-Host "$_ has $count images"

"$_" + " - " + "$count"  >> $logpath 
}
}
}
clv blaharray
}

$body= [string]::join("`r`n", (Get-Content $logpath))
Send-MailMessage -SmtpServer spmail05.vocus.com -From $emailFrom -To $emailTo -Subject $subject -Body $body