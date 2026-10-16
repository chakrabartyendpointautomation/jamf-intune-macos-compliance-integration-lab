# Jamf Pro & Intune macOS Compliance Integration Lab

A synthetic, defensive portfolio lab for understanding how Jamf Pro device compliance can inform Microsoft Intune and Microsoft Entra Conditional Access for macOS. It focuses on connector setup design, device registration, compliance signal flow, staged access enforcement, and troubleshooting.

> This is a documentation and fixture-based lab, not evidence of a live tenant deployment. Examples are fictional. No customer information, tenant identifiers, credentials, certificates, or private keys belong here.

## Why this is a separate project

The [Jamf Pro macOS MDM Automation](https://github.com/chakrabartyendpointautomation/jamfpro-macos-mdm-automation) repository covers Apple fleet operations and broad Jamf/Intune coexistence. This lab isolates the Jamf Device Compliance integration lifecycle and Conditional Access rollout. It does not duplicate general Jamf inventory, ADE, or Intune reporting work.

## Integration model

Jamf Pro remains the macOS MDM authority. Jamf evaluates its device criteria and reports the selected compliance signal through the Jamf Device Compliance partner integration in Intune. Users register their Jamf-managed Macs with Microsoft Entra ID through the Company Portal workflow. Entra Conditional Access can then require a registered, compliant device for scoped resources.

This repository follows the current **Device Compliance** path. Jamf's earlier macOS Conditional Access integration is deprecated; do not use legacy setup instructions for a new deployment. See [Microsoft's current integration guide](https://learn.microsoft.com/en-us/intune/device-security/compliance/jamf-entra-id).

## Lab contents

- [Architecture and trust boundaries](docs/architecture.md)
- [Staged implementation runbook](docs/lab-runbook.md)
- [Conditional Access rollout and rollback](docs/conditional-access-staging.md)
- [Troubleshooting guide](docs/troubleshooting.md)
- [Synthetic compliance scenarios](samples/device-compliance-scenarios.json)
- [Offline fixture validator](scripts/Test-LabScenarios.ps1)

## Prerequisites for a real lab tenant

The fixture validator only needs PowerShell 7.2+ and the local JSON file. To exercise the vendor workflow in a dedicated test tenant, confirm current licensing, product versions, account roles, network endpoints, and supported macOS versions with the vendor documentation. The integration requires Jamf Pro, Intune, Microsoft Entra ID, and Company Portal registration. Keep Jamf as the sole MDM authority for these devices; this integration reports compliance and does not transfer macOS MDM ownership to Intune.

The Microsoft guide describes Jamf computer smart groups for applicable and compliant devices, a Jamf policy that registers computers with Entra ID, the Jamf Device Compliance connector, and a scoped Intune partner compliance assignment. It also calls out an exclusion for the Device Compliance User Registration app in policies that would otherwise block registration. Follow the current guide and your organization's change process for exact console settings.

## Review the synthetic scenarios

From the repository root:

    pwsh -NoProfile -File ./scripts/Test-LabScenarios.ps1 -Path ./samples/device-compliance-scenarios.json

The script validates fixture shape and enumerated states only. It makes no network calls, authenticates nowhere, and does not determine actual Jamf, Intune, or Entra compliance.

## Safety boundaries

- Do not connect this material to production or use it to weaken an existing access policy.
- Start with test users, test devices, a limited pilot group, report-only Conditional Access, and documented exclusions for the registration flow.
- Review current Conditional Access policies for lockout and registration loops before enabling enforcement.
- Never store tenant IDs, user/device identifiers, access tokens, app secrets, or real inventory exports in this public repository.
- Treat a missing, stale, or conflicting compliance signal as **unknown** pending investigation; do not automatically convert it to compliant.
- Use Jamf/Intune consoles and vendor-supported workflows for configuration. No script in this repo changes tenant or device state.

## Validation status

No Jamf Pro or Intune tenant was connected for this project. The sample scenarios are synthetic, and the validator has not been run. Follow the vendor steps in a dedicated lab tenant and record what was actually verified before describing an implementation as tested.

## References

- [Integrate Jamf Pro with Intune to report device compliance to Entra ID](https://learn.microsoft.com/en-us/intune/device-security/compliance/jamf-entra-id)
- [Data Jamf Pro sends to Intune](https://learn.microsoft.com/en-us/intune/privacy/data-sharing/ref-jamf-to-intune)
- [Configure Jamf Pro Cloud Connector](https://learn.microsoft.com/en-us/intune/device-security/conditional-access-integration/configure-jamf-cloud-connector) — legacy integration context and migration notes
- [Jamf Pro macOS MDM Automation portfolio project](https://github.com/chakrabartyendpointautomation/jamfpro-macos-mdm-automation)
