cls
$jobServers = 1..15 | % { "{0:D2}" -f $_}
$appServers = 1..30 | % { "{0:D2}" -f $_}
$jobServerNames = "spjob01" #$jobServers | % { "spjob$_"}
$appServerNames = $appServers | % { "spapp$_"}
$array = @()
$drives = @("c$", "d$")
$jobServerDirs = @("\VocusWeb\GRWeb\GRConvert1\Images\Internal", "\VocusWeb\GRWeb\GRSpace1\Images\Internal", "\VocusWeb\GRWeb\GRSpace2\Images\Internal", "\VocusWeb\GRWeb\VocusGR\Images\Internal", "\VocusWeb\GRWeb\GRSpace3\Images\Internal", "\VocusWeb\GRWeb\Tasb\Images\Internal", "\VocusWeb\GRWeb\vfw\Images\Internal", "\VocusWeb\GRSecure\SecureGR\Images\Internal", "\VocusWeb\Universal\GR\Images\Internal")

foreach ($ServerName in $jobServerNames ) {
$ping = Test-Connection $ServerName -Count 1 -q

if ($ping) 
{
Write-Host "$ServerName is alive! Checking for image directories."

Foreach ($drive in $drives) {
$jobServerDirs | % {
$jobServerPath = "\\" + "$ServerName" + "\" + "$drive" + "$_"

$array += $jobServerPath
}
}

$array | % {
$jobTestPath = Test-Path $_

if ($jobTestPath -eq $True)
{
Write-Host "$_  path exists!"
$filecount = (Get-ChildItem $_).Count
Write-Host "$_ has $filecount images"
}
}
}
}
