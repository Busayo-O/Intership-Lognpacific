<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Busayo O
    LinkedIn        : linkedin.com/in/busayo-o00
    GitHub          : github.com/Busayo-O
    Date Created    : 2026-10-21
    Last Modified   : 2024-10-21
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000500
    

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 
#>

# Define the registry path and value
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
$valueName = "MaxSize"
$valueData = 32768 # 0x00008000 in hexadecimal

# check if the registry path exists, if not create it
if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force
}

# Set the MaxSize value
Set-ItemProperty -Path $registryPath -Name $valueName -value $valueData -Type Dword
     `
# Output success message
Write-Output "Registry value '$valueName' set to $valueData' at '$registryPath'."
