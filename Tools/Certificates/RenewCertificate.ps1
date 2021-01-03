param([string]$LogPath)
function WriteLog {
    Param([string]$message)
    Add-Content -Path $LogPath -Value "$(Get-Date) - $message"
}
try {
    $thumbprint = (Get-PACertificate).Thumbprint
    $cert = Submit-Renewal -WarningAction Stop -ErrorAction Stop
    $cert | Set-MobileServerCertificate

    WriteLog "New certificate installed with thumbprint $($cert.Thumprint)"
    WriteLog "Removing old certificate with thumbprint $thumbprint"

    Get-ChildItem Cert:\LocalMachine\My |
        Where-Object Thumbprint -eq $thumbprint |
        Remove-Item
        
} catch {
    WriteLog $_.Exception.Message
    throw
}