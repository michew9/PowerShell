# 
## File: ScrapeSLC.ps1
## Purpose: Script to manage the MilestonePSTools PowerShell module.
#
# Version 1.0 Initial Release
#

[CmdletBinding()]
Param
(       
  [string]$slc = ""
)  ### Param

##############################
#                            #
#  M A I N    P R O G R A M  #
#                            # 
##############################

if ($slc -eq "") {
    $slcode = Read-Host "Enter the SLC: "
} else {
    $slcode = $slc
}

$TmpFile = $env:Temp + '\slc.txt'
$urlStr = 'http://intraoffice/intraoffice_changeSLKtype.asp?SLK=' + $slcode 
$progressPreference = 'silentlyContinue'  # Subsequent calls do not display UI.
$ErrorActionPreference= 'silentlycontinue'
$web = Invoke-WebRequest -Uri $urlStr -UseDefaultCredential 
$progressPreference = 'Continue'          # Subsequent calls do display UI.

if ($($web.StatusCode) -eq 200) {
  
  $web.Content > $TmpFile

  $x = gc $TmpFile | select-string -pattern "DistributorId"
  $dist = [regex]::matches($x,'(?<=\<a.+?\>).+?(?=\<\/a\>)').value
  
  $y = gc $TmpFile | select-string -pattern "option selected"
  $prod = [regex]::matches($y,'(?<=\<option.+?\>).+?(?=\<\/option\>)').value
  
  $z = gc $TmpFile | select-string -pattern "EnduserId"
  $endusr = [regex]::matches($z,'(?<=\<a.+?\>).+?(?=\<\/a\>)').value
  
  $w = gc $TmpFile | select-string -pattern "IntegratorId"
  $intgrtr = [regex]::matches($w,'(?<=\<a.+?\>).+?(?=\<\/a\>)').value
  
  $v = gc $TmpFile | select-string -pattern "ResellerId"
  $rslr = [regex]::matches($v,'(?<=\<a.+?\>).+?(?=\<\/a\>)').value
  
  Write-Host -NoNewline "`n          SLC : "
  Write-Host "$slcode" -ForegroundColor Red
  Write-Host -NoNewline "      Product : "
  Write-Host "$prod" -ForegroundColor Yellow
  Write-Host -NoNewline "  Distributor : "
  Write-Host "$dist" -ForegroundColor Green
  Write-Host -NoNewline "   Integrator : "
  Write-Host "$intgrtr" -ForegroundColor Cyan
  Write-Host -NoNewline "     Reseller : "
  Write-Host "$rslr" -ForegroundColor Green
  Write-Host -NoNewline "     End User : "
  Write-Host "$endusr`n" -ForegroundColor DarkYellow

} else {
  Write-Warning "`nUnable to contact intraoffice. Please ensure VPN is up and running!!"
}

