# 
## File: ManageMsPsTools.ps1
## Purpose: Script to manage the MilestonePSTools PowerShell module.
#
# Version 1.0 Initial Release
# Version 1.1 Add TLS1.2 as the default security protocol
# Version 1.2 Download MilestonePSTools 1.0.89 
# Version 1.3 Include the Download option and install from offline repository 
#
<#   
.SYNOPSIS   
   Script to help automate the setup of the MilestonePSTools PowerShell module. Can be used to uninstall an existing module and/or download & install the module in the current machine. This include both the MipSdkRedist and MilestonePSTools modules.
.DESCRIPTION 
   This is a powershell script that helps you automate the lifecycle of the MilestonePSTools PowerShell module.
.PARAMETER Uninstall
    To remove the Milestone PSTools and MipSdkRedist modules, use -Uninstall switch
.PARAMETER install
    To install the Milestone PSTools and MipSdkRedist modules, use -install switch
.PARAMETER logfile
    To log all the activities to a "logfile" filename.
.EXAMPLE
    PS C:\users\bob\Desktop> .\ManageMsPsTools.ps1
    To list the usage of the script.
.EXAMPLE
    PS > .\ManageMsPsTools.ps1 -Uninstall -Install 
    To remove existing modules and install new modules.
.EXAMPLE
    PS > .\ManageMsPsTools.ps1 -download -tmpdir c:\tmp
    To download MilestonePSTools and MipSdkRedist modules to c:\tmp directory in the machine.
.EXAMPLE
    PS > .\ManageMsPsTools.ps1 -install -tmpdir c:\tmp
    To install MilestonePSTools and MipSdkRedist modules from c:\tmp directory in the machine.	
.EXAMPLE
    PS > .\ManageMsPsTools.ps1 -download -install
    To download and install MilestonePSTools and MipSdkRedist modules in the machine using the default temp directory.
.EXAMPLE
    PS > .\ManageMsPsTools.ps1 -Uninstall -logfile "C:\Temp\install.log" 
    To remove the modules and log the output to "C:\Temp\install.log" file.
.NOTES   
    Name: ManageMsPsTools.ps1
    Author: Michael Chew 
    DateCreated: 2-November-2020
    LastUpdated: 3-November-2020
	LastUpdated: 16-July-2021
.LINK
    https://github.com/michew9/PowerShell/blob/master/ManageMsPsTools/ManageMsPsTools.ps1 
#>

[CmdletBinding()]
Param
( 
  [switch]$Install = $false,      
  # To download the software
  # To uninstall the software 
  [switch]$Uninstall = $false,      
  # To install the software  
  [switch]$Download = $false,
  # Location of the directory of the zip file
  [string]$TmpDir = "",
  [string]$logfile = ""
)  ### Param

function ShowUsage()
{
    write-host "Usage: .\ManageMsPsTools.ps1 [ -Download ] [ -Uninstall ] [ -Install ] [ -logfile <logfilename> ]`n"
    write-host " get-help .\ManageMsPsTools.ps1 -examples"
    write-host " get-help .\ManageMsPsTools.ps1 -detailed"
    write-host " get-help .\ManageMsPsTools.ps1 -full"    
    exit 0
}  

function Uninstall(
    [string] $ModuleName)
{
	Write-Host "..Uninstalling module $ModuleName "
	$folder = Join-Path -path "C:\Program Files\WindowsPowerShell\Modules" $ModuleName
	if (Test-Path -Path $folder) {
		write-host "..  Successfully uninstalled $ModuleName from $folder directory"
		Remove-Item -path $folder -Recurse -Force
	} else {
		Write-Host "..  $ModuleName is not installed in the current system. No action required."
	}
}

function DownloadModules(
	  [string] $TmpDir,
	  [string] $Version,
	  [string] $SrcNupkg,
	  [string] $TgtZipFile)
{
	$MilestonePsVer = "$Version"
	$filename = Join-Path -path $TmpDir $TgtZipFile

	Write-Host "..Downloading $TgtZipFile to $TmpDir "
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	try {
	   Invoke-WebRequest -uri $SrcNupkg -outFile $filename -ErrorAction Stop	 
	   Write-Host "..  Successfully downloaded $TgtZipFile to $TmpDir"
        } catch {
           Write-Host ">> StatusCode:" $_.Exception.Response.StatusCode.value__ 
           Write-Host ">> StatusDescription:" $_.Exception.Response.StatusDescription
        }
}

function InstallModules(
          [string] $ModuleName,
	  [string] $TmpDir,
	  [string] $Version,
	  [string] $TgtZipFile,
	  [string] $TgtDirectory)
{
	$filename = Join-Path -path $TmpDir $TgtZipFile
	
	Write-Host "..Installing module $ModuleName using $filename"
	if (Test-Path $filename) {
	    Get-ChildItem $filename | Unblock-File
		
	    $MilestonePsDir = $TgtDirectory
	    $MilestonePsVer = "$Version"
	    $MilestoneInstallPath = Join-Path -path $TgtDirectory -childpath $MilestonePsVer

	    New-Item -ItemType Directory -Path $MilestonePsDir -Force -ErrorAction Stop | Out-Null
	    New-Item -ItemType Directory -Path $MilestoneInstallPath -Force -ErrorAction Stop  | Out-Null

	    Expand-Archive -LiteralPath $filename -DestinationPath $MilestoneInstallPath	

	    Test-Path -Path $MilestoneInstallPath -ErrorAction Stop  | Out-Null
	    Write-Host "..  Successfully installed $ModuleName ."
	   
	    Import-Module $ModuleName
	    Write-Host "..  Import-Module $ModuleName ran successfully."
	} else {
	    Write-Host "..  $ModuleName is not installed . Installer package file $filename is missing!!"
	}
}

##############################
#                            #
#  M A I N    P R O G R A M  #
#                            # 
##############################

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$DisplayHelp = $False

$CurMipSdkName = "MipSdkRedist"
$CurMipSdkVersion = "20.3.0"
$CurMipSdkLink = "https://psg-prod-eastus.azureedge.net/packages/mipsdkredist.20.3.0.nupkg"
$CurMipSdkZippedFile = "mipsdkredist.20.3.0.zip"

$CurMsPsToolsName = "MilestonePSTools"
$CurMsPsToolsVersion = "1.0.89"
$CurMsPsToolsLink = "https://psg-prod-eastus.azureedge.net/packages/milestonepstools.1.0.89.nupkg"
$CurMsPsToolsZippedFile = "milestonepstools.1.0.89.zip"

if (($Uninstall.IsPresent -eq $False) -And ($Install.IsPresent -eq $False) -And ($Download.IsPresent -eq $False)) {
    Clear-Host	
	Write-Host "~~~~~~~~~~~~~~~~~~ Menu Title ~~~~~~~~~~~~~~~~~~" -ForegroundColor Cyan
	Write-Host "1`: Uninstall - Uninstall Milestone MilestonePSTools and MipSdkRedist modules"
        Write-Host "2`: Install - Install Milestone MilestonePSTools and MipSdkRedist modules"	
	Write-Host "3`: Download - Download Milestone MilestonePSTools and MipSdkRedist modules"	
	Write-Host "4`: Help - Display CLI options for this script. "
	Write-Host "Q`: Quit (default)"
	Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" -ForegroundColor Magenta

	$input = (Read-Host "Please make a selection (1-4,Q)").ToUpper()
	
	switch ($input)
	{
		'1' { $Uninstall = $True }    
		'2' { $Install = $True } 
		'3' { $Download = $True } 
		'4' { $DisplayHelp = $True }
		'Q' { Write-Host "Thanks for using the script. Have a good day!!" -BackgroundColor Red -ForegroundColor White }
		Default { Write-Host "Thanks for using the script. Have a good day!!" -BackgroundColor Red -ForegroundColor White }
	}	
}

if ($DisplayHelp -eq $True) {
	ShowUsage
	exit
}

if ($TmpDir -eq "") {
	$TmpDir = "$env:TEMP"
} elseif (! (Test-Path -Path $TmpDir)) {
	Write-Host "$TmpDir doesn't exist, please ensure you enter the correct directory name !!" -ForegroundColor Yellow
	exit 1
}

if ($logfile -ne ""){
	Start-Transcript -path $LogFile -append
}

if ($Download -eq $True) {
	DownloadModules $TmpDir $CurMipSdkVersion $CurMipSdkLink $CurMipSdkZippedFile
	DownloadModules $TmpDir $CurMsPsToolsVersion $CurMsPsToolsLink $CurMsPsToolsZippedFile
}

if ($Uninstall -eq $True) {
	Uninstall $CurMipSdkName
	Uninstall $CurMsPsToolsName
}

if ($Install -eq $True) {
	InstallModules $CurMipSdkName $TmpDir $CurMipSdkVersion $CurMipSdkZippedFile "C:\Program Files\WindowsPowerShell\Modules\$CurMipSdkName"
	InstallModules $CurMsPsToolsName $TmpDir $CurMsPsToolsVersion $CurMsPsToolsZippedFile "C:\Program Files\WindowsPowerShell\Modules\$CurMsPsToolsName"	  
}

if ($logfile -ne "" ){
	Stop-Transcript
}

exit
