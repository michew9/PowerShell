# 
## File: GetMsXml.ps1
## Purpose: Script to extract useful information from ServerConfig.xml .
#
# Version 1.0 Initial Release
#

#  C:\Documents and Settings\All Users\Application Data\Milestone\XProtect Corporate Management Server\ServerConfig.xml
#$file = "C:\ProgramData\Milestone\XProtect Management Server\ServerConfig.xml"
$file = "C:\Tmp\Data\ServerConfig.xml"

if (Test-Path -Path $file) {
    [xml]$xml = Get-Content $file
    ## $xml.SelectNodes('//server')
 
    Write-Host "~~~ File: $file " -ForegroundColor Cyan

    Write-Host -NoNewline "                               Client Registration ID : "
    Write-Host " $($xml.server.ClientRegistrationId) " -ForegroundColor Red
    Write-Host -NoNewline "                                              Version : "
    Write-Host " $($xml.server.version) " -ForegroundColor Green
 
    Write-Host -NoNewline "                             Authorization Server Uri : "
    Write-Host " $($xml.server.WebApiConfig.AuthorizationServerUri) " -ForegroundColor Red
    
    Write-Host -NoNewline "                  Port to listen for requests from RS : "
    Write-Host " $($xml.server.WebApiConfig.Port) " -ForegroundColor Yellow
    
    Write-Host -NoNewline "                Use Latest Protocol for communication : "
    Write-Host " $($xml.server.UseWebApi) " -ForegroundColor Red
    
    Write-Host -NoNewline "                Use Legacy Protocol for communication : "
    Write-Host " $($xml.server.UseRemoting) " -ForegroundColor Red

    Write-Host -NoNewline "Port for authentication/config/token exchange from RS : "
    Write-Host " $($xml.server.RecorderCommunication.Port) " -ForegroundColor Yellow
    
    $xml.server.serverproxycommunication.port

    $xml.server.traycontrollercommunication.port

    $xml.server.VMOCommunication.ServerName
    $xml.server.VMOCommunication.Port
    $xml.server.VMOCommunication.HttpsPort

} else {
    Write-Warning "Could not find $file on this host!"
    Write-Warning "Either this is not a Milestone Management server or file has been removed!"
}



 