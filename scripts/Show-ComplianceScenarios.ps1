[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string] $Path = (Join-Path $PSScriptRoot '../samples/device-compliance-scenarios.json')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$resolvedPath = (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path
$fixture = Get-Content -LiteralPath $resolvedPath -Raw -ErrorAction Stop | ConvertFrom-Json -Depth 20

if ($fixture.schemaVersion -ne 1) {
    throw "Unsupported fixture schemaVersion '$($fixture.schemaVersion)'. Expected version 1."
}
if (-not $fixture.scenarios -or @($fixture.scenarios).Count -eq 0) {
    throw 'The fixture must contain at least one scenario.'
}

$rows = foreach ($scenario in $fixture.scenarios) {
    if ([string]::IsNullOrWhiteSpace([string]$scenario.scenarioId)) {
        throw 'Every scenario must include a non-empty scenarioId.'
    }
    [pscustomobject]@{
        ScenarioId = [string]$scenario.scenarioId
        JamfState = [string]$scenario.jamfCompliance
        InventoryAgeHours = $scenario.inventoryAgeHours
        EntraRegistered = [bool]$scenario.entraRegistered
        PartnerStatus = [string]$scenario.partnerStatus
        InScope = [bool]$scenario.partnerAssignmentInScope
        ExpectedDisposition = [string]$scenario.expectedDisposition
        ExpectedAccess = [string]$scenario.expectedAccessWithCompliantRequirement
    }
}

$rows | Format-Table -AutoSize
Write-Output "Fixture only: $resolvedPath"
Write-Output 'No Jamf, Microsoft Graph, Intune, or Entra connection was made.'
