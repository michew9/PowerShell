# 
## File: ManageMsPsTools.ps1
## Purpose: Script to manage the MilestonePSTools PowerShell module.
#
# Version 1.0 Initial Release
#
<#   
.SYNOPSIS   
   Script to help automate the setup of the MilestonePSTools PowerShell module. Can be used to uninstall an existing module and/or download & install the module in the current machine. This include both the MipSdkRedist and MilestonePSTools modules.
.DESCRIPTION 
   This is a powershell script that helps you automate the lifecycle of the MilestonePSTools PowerShell module.
.PARAMETER cleanup
    To remove the Milestone PSTools and MipSdkRedist modules, use -cleanup switch
.PARAMETER install
    To install the Milestone PSTooles and MipSdkRedist modules, use -install switch
.PARAMETER logfile
    To log all the activities to a "logfile" filename.
.EXAMPLE
    PS C:\users\bob\Desktop> .\ManageMsPsTools.ps1
    To list the usage of the script.
.EXAMPLE
    PS > .\ManageMsPsTools.ps1 -cleanup -install 
    To remove existing modules and install new modules.
.EXAMPLE
    PS > .\ManageMsPsTools.ps1 -install
    To install MilestonePSTools and MipSdkRedist modules in the machine.
.EXAMPLE
    PS > .\ManageMsPsTools.ps1 -cleanup -logfile "C:\Temp\install.log" 
    To remove the modules and log the output to "C:\Temp\install.log" file.
.NOTES   
    Name: ManageMsPsTools.ps1
    Author: Michael Chew 
    DateCreated: 2-November-2020
    LastUpdated: 2-November-2020
.LINK
    https://github.com/michew9/powershell/blob/main/ManageMsPsTools 
#>

[CmdletBinding()]
Param
( 
  [switch]$cleanup = $false,         
  [switch]$install = $false,      
  [string]$logfile = ""
)  ### Param

function ShowUsage()
{
    write-host "Usage: .\ManageMsPsTools.ps1 [ -cleanup ] [ -install ] [ -logfile <logfilename> ]`n"
    write-host " get-help .\ManageMsPsTools.ps1 -examples"
    write-host " get-help .\ManageMsPsTools.ps1 -detailed"
    write-host " get-help .\ManageMsPsTools.ps1 -full"    
    exit 0
}  

function Uninstall(
    [string] $InstallPath
)
{
	$folder = Join-Path -path "C:\Program Files\WindowsPowerShell\Modules" $InstallPath
	if (Test-Path -Path $folder) {
		write-host "Removing $folder directory from the current system"
		Remove-Item -path $folder -Recurse -Force
	} else {
		write-host "$folder directory doesn't exist in the current system. No action required."
	}
}

function DownloadInstall(
      [string] $ModuleName,		
      [string] $Version,
	  [string] $SrcNupkg,
	  [string] $TgtZipFile,
	  [string] $TgtDirectory)
{
	$MilestonePsVer = "$Version"
	$MilestoneInstallPath = Join-Path -path $TgtDirectory -childpath $MilestonePsVer
	$filename = Join-Path -path "$env:TEMP" $TgtZipFile

	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	Invoke-WebRequest -uri $SrcNupkg -outFile $filename -ErrorAction Stop

	$MilestonePsDir = $TgtDirectory

	Get-ChildItem $filename | Unblock-File

	New-Item -ItemType Directory -Path $MilestonePsDir -Force -ErrorAction Stop | Out-Null
	New-Item -ItemType Directory -Path $MilestoneInstallPath -Force -ErrorAction Stop  | Out-Null

	Expand-Archive -LiteralPath $filename -DestinationPath $MilestoneInstallPath	

	Test-Path -Path $MilestoneInstallPath -ErrorAction Stop  | Out-Null

	Write-Host -Object "$ModuleName is successfully installed ."

del $filename
}

##############################
#                            #
#  M A I N    P R O G R A M  #
#                            # 
##############################

$disphelp = $False

if (($cleanup.IsPresent -eq $False) -And ($install.IsPresent -eq $False)) {
    Clear-Host	
	Write-Host "~~~~~~~~~~~~~~~~~~ Menu Title ~~~~~~~~~~~~~~~~~~" -ForegroundColor Cyan
	Write-Host "1`: Cleanup - Remove Milestone MilestonePSTools and MipSdkRedist modules"
    Write-Host "2`: Install - Install Milestone MilestonePSTools and MipSdkRedist modules"	
	Write-Host "3`: Help - Display CLI options for this script. "
	Write-Host "Q`: Quit (default)"
	Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" -ForegroundColor Magenta

	$input = (Read-Host "Please make a selection (1-3,Q)").ToUpper()
	
	switch ($input)
	{
		'1' { $cleanup = $True }    
		'2' { $install = $True } 
		'3' { $disphelp = $True }
		'Q' { Write-Host "Thanks for using the script. Have a good day!!" -BackgroundColor Red -ForegroundColor White }
		Default { Write-Host "Thanks for using the script. Have a good day!!" -BackgroundColor Red -ForegroundColor White }
	}	
}

if ($disphelp -eq $True) {
	ShowUsage
	exit
}

if ($logfile -ne "" ){
	Start-Transcript -path $LogFile -append
}

if ($cleanup -eq $True) {
	Uninstall "MipSdkRedist"
	Uninstall "MilestonePSTools"
}

if ($install -eq $True) {
	DownloadInstall "MipSdkRedist" "20.2.0" "https://psg-prod-eastus.azureedge.net/packages/mipsdkredist.20.2.0.nupkg" "mipsdkredist.20.2.0.zip" "C:\Program Files\WindowsPowerShell\Modules\MipSdkRedist"

	DownloadInstall "MilestonePSTools" "1.0.82" "https://psg-prod-eastus.azureedge.net/packages/milestonepstools.1.0.82.nupkg" "milestonepstools.1.0.82.zip" "C:\Program Files\WindowsPowerShell\Modules\MilestonePSTools"

	Import-Module  MipSdkRedist
	Import-Module  MilestonePSTools
}

if ($logfile -ne "" ){
	Stop-Transcript
}

exit