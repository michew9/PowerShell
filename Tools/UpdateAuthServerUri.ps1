# Elevate script if not running as Administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    start powershell "-encodedcommand $([Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($script:MyInvocation.MyCommand.ScriptBlock)))" -Verb RunAs
    exit
}

function GetConfigurationPaths {
    $serverConfigPath = 'C:\ProgramData\Milestone\XProtect Management Server\ServerConfig.xml'
    $appSettingsPath = 'C:\Program Files\Milestone\XProtect Management Server\IIS\IDP\appsettings.json'

    while (-not (Test-Path $serverConfigPath)) {
        Write-Warning "Could not find ServerConfig.xml at $serverConfigPath"
        $serverConfigPath = Read-Host "Enter path to ServerConfig.xml"
    }

    while (-not (Test-Path $appSettingsPath)) {
        Write-Warning "Could not find ServerConfig.xml at $appSettingsPath"
        $appSettingsPath = Read-Host "Enter path to appsettings.json"
    }

    return [psobject]@{
        ServerConfig = $serverConfigPath
        AppSettings = $appSettingsPath
    }
}

function GetClusterRoleFqdn {
    $name = Get-ClusterGroup |
        Where-Object GroupType -eq 'GenericService' |
        Select -ExpandProperty Name |
        Out-GridView -PassThru -Title "Select a clustered role"
    while ($null -eq $name) {
        Write-Information "No role was selected"
        $name = Read-Host "Enter a hostname matching the name of the clustered role"
    }
    return [system.net.dns]::GetHostByName($name).HostName
}

function Pause ($message)
{
    # Check if running Powershell ISE
    if ($psISE)
    {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show("$message")
    }
    else
    {
        Write-Host "$message" -ForegroundColor Yellow
        $x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

try {
    $infoPref = $InformationPreference
    $InformationPreference = 'Continue'

    $configs = GetConfigurationPaths
    $uri = [uri]"http://$(GetClusterRoleFqdn)/IDP"
    
    Write-Information "Checking $($configs.ServerConfig)"
    $serverConfig = [xml](Get-Content -Path $configs.ServerConfig -Raw)
    $authServerNode = $serverConfig.SelectSingleNode('/server/WebApiConfig/AuthorizationServerUri')
    if ($authServerNode.InnerText.ToLower() -ne $uri.ToString().ToLower()) {
        Write-Information "Updating ServerConfig.xml to change $($authServerNode.InnerText) to $uri"
        $authServerNode.InnerText = $uri.ToString()
    
        Write-Information "Saving changes to $($configs.ServerConfig)"
        $serverConfig.Save($configs.ServerConfig)

        $msSvc = Get-Service 'Milestone XProtect Management Server'
        if ($msSvc.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running) {
            Write-Information "Restarting $($msSvc.DisplayName)"
            $msSvc | Restart-Service
        }
    } else {
        Write-Information "AuthorizationServerUri in ServerConfig.xml is already set to $uri"
    }

    
    Write-Information "Checking $($configs.AppSettings)"
    $appSettings = Get-Content $configs.AppSettings -Raw | ConvertFrom-Json -ErrorAction Stop
    if ($appSettings.IdentityProviderSettings.Authority.ToLower() -ne $uri.ToString().ToLower()) {
        Write-Information "Updating appsettings.json to change $($appSettings.IdentityProviderSettings.Authority) to $uri"
        $appSettings.IdentityProviderSettings.Authority = $uri
        
        Write-Information "Saving changes to $($configs.AppSettings)"
        $appSettings | ConvertTo-Json | Set-Content $configs.AppSettings -ErrorAction Stop

        Write-Information "Restaring IIS using iisreset"
        iisreset
    } else {
        Write-Information "IdentityProviderSettings.Authority in appsettings.json is already set to $uri"
    }
    
    Write-Information "Success"
    Pause("Press any key to quit")
} catch {
    throw
} finally {
    $InformationPreference = $infoPref
}