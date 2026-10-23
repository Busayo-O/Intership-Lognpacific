<#
.SYNOPSIS
    This PowerShell script ensures  ensures that unauthenticated Remote Procedure Call (RPC) clients are restricted from connecting to the RPC server

.NOTES
    Author          : Busayo O
    LinkedIn        : linkedin.com/in/Busayo-O/
    GitHub          : github.com/Busayo-O
    Date Created    : 2026-10-22
    Last Modified   : 2026-10-22
    Version         : N/A
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000165
    

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AU-000500.ps1 
#>

# YOUR CODE GOES HERE$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\RPC"

if (-not (Test-Path -LiteralPath $Path)) {
    New-Item -Path $Path -Force | Out-Null
}

New-ItemProperty `
    -Path $Path `
    -Name "RestrictRemoteClients" `
    -Value 1 `
    -PropertyType DWord `
    -Force | Out-Null
