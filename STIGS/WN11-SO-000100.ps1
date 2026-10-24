<#
.SYNOPSIS
    This PowerShell script ensures the Windows Server Message Block (SMB) client is configured to always perform SMB packet signing

.NOTES
    Author          : Busayo O
    LinkedIn        : linkedin.com/in/busayo-o00/
    GitHub          : github.com/Busayo-O
    Date Created    : 2026-10-23
    Last Modified   : 2026-10-23
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000100

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-SO-000100.ps1 
#>

$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"

try {
    Set-ItemProperty `
        -Path $RegistryPath `
        -Name "RequireSecuritySignature" `
        -Value 1 `
        -Type DWord `
        -ErrorAction Stop

    $ActualValue = (Get-ItemProperty `
        -Path $RegistryPath `
        -Name "RequireSecuritySignature" `
        -ErrorAction Stop).RequireSecuritySignature

    if ($ActualValue -eq 1) {
        Write-Host "COMPLIANT: WN11-SO-000100" -ForegroundColor Green
    }
    else {
        Write-Host "NON-COMPLIANT" -ForegroundColor Red
    }
}
catch {
    Write-Error "Remediation failed: $($_.Exception.Message)"
}

# Verify SMB client signing configuration
Get-SmbClientConfiguration |
    Select-Object RequireSecuritySignature
