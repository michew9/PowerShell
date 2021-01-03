# 
## File: ScrapeSDL.ps1
## Purpose: Script to manage the MilestonePSTools PowerShell module.
#
# Version 1.0 Initial Release
#

[CmdletBinding()]
Param
(       
  [string]$DevId = ""
)  ### Param

##############################
#                            #
#  M A I N    P R O G R A M  #
#                            # 
##############################

if ($DevId -eq "") {
    $TgtDevId = Read-Host "Enter the DevId: "
} else {
    $TgtDevId = $DevId
}

## https://www.milestonesys.com/community/business-partner-tools/supported-devices/xprotect-corporate-and-xprotect-expert/?AdvancedSearchDisplayed=true&ManufacturerId=7
## https://www.milestonesys.com/community/business-partner-tools/supported-devices/xprotect-corporate-and-xprotect-expert/?AdvancedSearchDisplayed=true

## https://www.milestonesys.com/community/business-partner-tools/supported-devices/supported-device/?deviceId=26423&platform=XPCO&backCloses=true

$TmpFile = $env:Temp + '\DevId.txt'
$urlStr = 'https://www.milestonesys.com/community/business-partner-tools/supported-devices/supported-device/?deviceId=' + $TgtDevId + '&platform=XPCO&backCloses=true'
$progressPreference = 'silentlyContinue'  # Subsequent calls do not display UI.
$ErrorActionPreference= 'silentlycontinue'
$web = Invoke-WebRequest -Uri $urlStr -UseDefaultCredential 
$progressPreference = 'Continue'          # Subsequent calls do display UI.

if ($($web.StatusCode) -eq 200) {
  
  ## $tables = $web.ParsedHtml.body.getElementsByTagName('div')
  
  $xmlContent = [xml]$web.Content
  $xmlContent
  $bar = $xmlContent.html.body.div | where {$_.div -eq 'hardware-info'}
  Write-Output $bar.InnerXML

  $tables

  $web.Content > $TmpFile
  ## gc $TmpFile

} else {
  Write-Warning "`nUnable to contact intraoffice. Please ensure VPN is up and running!!"
}

