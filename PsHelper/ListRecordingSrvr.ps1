# 
## File: ListRecordingSrvr.ps1
## Purpose: Script to list the Milestone Recording Server using the MilestonePSTools PowerShell module.
#
# Version 1.0 Initial Release
#
[CmdletBinding()]
Param (     
  [string]$MgmtIpAddr = ""
)  ### Param

$ServerName = $MgmtIpAddr
if ($MgmtIpAddr -eq "") {
    $ServerName = $Env:Computername
} 

Connect-ManagementServer -server $ServerName -AcceptEula

$ListOfRecSvrs = Get-RecordingServer -Name $ServerName
Write-Host "The list of recording servers registered with this Management Server"
$ListOfRecSvrs | foreach-object { Write-Host "- $($_.Hostname)" }

Disconnect-ManagementServer
exit