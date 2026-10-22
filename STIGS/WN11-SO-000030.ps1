<#
.SYNOPSIS
    This PowerShell script ensures that Audit policy using subcategories must be enabled (i.e the security option "Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings" to be set to "Enabled")

.NOTES
    Author          : Busayo O
    LinkedIn        : linkedin.com/in/busayo-o00/

    GitHub          : github.com/Busayo-O/
    Date Created    : 2026-10-21
    Last Modified   : 2026-10-21
    Version         : 2.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000030
    

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> \STIG-ID-WN11-SO-000030.ps1 
#>

# YOUR CODE GOES HERE#requires -RunAsAdministrator
$ErrorActionPreference = 'Stop'

$BasePath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
$BackupFile = Join-Path $env:SystemDrive (
    'LSA-Backup-{0}.reg' -f (Get-Date -Format 'yyyyMMdd-HHmmss')
)

# Back up the existing registry key before making changes.
& reg.exe export `
    'HKLM\SYSTEM\CurrentControlSet\Control\Lsa' `
    $BackupFile /y

if ($LASTEXITCODE -ne 0) {
    throw 'Registry backup failed. No changes were made.'
}

# Ensure the base key exists.
if (-not (Test-Path -LiteralPath $BasePath)) {
    throw "Expected Windows registry key was not found: $BasePath"
}

# Apply selected DWORD settings from the supplied export.
$DwordSettings = [ordered]@{
    auditbasedirectories       = 0
    auditbaseobjects           = 0
    crashonauditfail           = 0
    LimitBlankPasswordUse      = 1
    NoLmHash                   = 1
    disabledomaincreds         = 0
    everyoneincludesanonymous  = 0
    forceguest                 = 0
    restrictanonymous          = 0
    restrictanonymoussam       = 1
    SCENoApplyLegacyAuditPolicy = 1
}

foreach ($Entry in $DwordSettings.GetEnumerator()) {
    New-ItemProperty `
        -LiteralPath $BasePath `
        -Name $Entry.Key `
        -PropertyType DWord `
        -Value ([int]$Entry.Value) `
        -Force | Out-Null
}

# Apply the FIPS setting from the supplied export.
$FipsPath = Join-Path $BasePath 'FipsAlgorithmPolicy'

if (-not (Test-Path -LiteralPath $FipsPath)) {
    New-Item -Path $FipsPath -Force | Out-Null
}

New-ItemProperty `
    -LiteralPath $FipsPath `
    -Name 'Enabled' `
    -PropertyType DWord `
    -Value 0 `
    -Force | Out-Null

Write-Host "`nSelected LSA settings have been applied."
Write-Host "Registry backup: $BackupFile"

# Display the resulting DWORD values.
Get-ItemProperty -LiteralPath $BasePath |
    Select-Object auditbasedirectories,
                  auditbaseobjects,
                  crashonauditfail,
                  LimitBlankPasswordUse,
                  NoLmHash,
                  disabledomaincreds,
                  everyoneincludesanonymous,
                  forceguest,
                  restrictanonymous,
                  restrictanonymoussam,
                  SCENoApplyLegacyAuditPolicy |
    Format-List

Get-ItemProperty -LiteralPath $FipsPath -Name Enabled
