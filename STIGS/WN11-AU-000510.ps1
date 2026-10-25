<#
.SYNOPSIS
    This PowerShell script ensures the System Event Log is configured to a maximum size of at least 32768 KB (32 MB).

.NOTES
    Author          : Busayo O
    LinkedIn        : linkedin.com/in/busayo-o00/
    GitHub          : github.com/Busayo-O
    Date Created    : 2026-10-25
    Last Modified   : 2026-10-25    
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000510

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-AU-000510.ps1 
#>

$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System"
$ValueName = "MaxSize"
$ValueData = 32768

# Create the registry key if it does not exist
if (-not (Test-Path -Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set MaxSize as a DWORD value
New-ItemProperty -Path $RegistryPath `
    -Name $ValueName `
    -Value $ValueData `
    -PropertyType DWord `
    -Force | Out-Null

# Verify the setting
Get-ItemProperty -Path $RegistryPath -Name $ValueName
