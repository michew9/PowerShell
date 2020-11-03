# 
## File: ListRecordingSrvr.ps1
## Purpose: Script to list the Milestone Recording Server using the MilestonePSTools PowerShell module.
#
# Version 1.0 Initial Release
#
[CmdletBinding()]
Param
(     
  [string]$MgmtIpAddr = ""
)  ### Param

if ($MgmtIpAddr -eq "") {
    $ServerName = $Env:Computername
} else {
    $ServerName = $MgmtIpAddr
}

connect-managementserver -server "$ServerName" -AcceptEula
$recorderName = "$ServerName"

$rs = Get-RecordingServer -Name $recorderName
$rs

disconnect-managementserver
exit