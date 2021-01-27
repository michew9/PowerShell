# 
## File: LogonMS.ps1
## Purpose: Script to logon to Milestone Server using the MilestonePSTools PowerShell module.
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

## Perform tasks using MilestonePsTools

Disconnect-ManagementServer
exit