# Architecture and trust boundaries

## System roles

| Component | Authority in this lab | Boundary |
| --- | --- | --- |
| Jamf Pro | macOS enrollment, configuration, inventory, and Jamf smart-group compliance decision | Remains the device's MDM authority. |
| Microsoft Intune | Jamf Device Compliance partner assignment and compliance signal view | Does not become the macOS MDM authority through this integration. |
| Microsoft Entra ID | User/device registration and Conditional Access evaluation | Applies resource access conditions to the signed-in identity and registered device. |
| Company Portal | User-facing registration workflow on Jamf-managed Macs | Deploy and maintain through Jamf according to current vendor guidance. |
| Operator | Design, access control, rollout, monitoring, and incident response | Uses approved roles and records approvals and evidence. |

## Signal path

1. Jamf inventory and locally evaluated criteria determine whether a Mac belongs to the configured Applicable and Compliance smart groups.
2. A Jamf policy and Company Portal workflow allow the user to register the device with Microsoft Entra ID.
3. The Jamf Device Compliance connector is configured in Jamf Pro and paired with the Jamf Device Compliance partner in Intune for macOS and an explicitly scoped user group.
4. Jamf reports supported inventory/compliance information through the connector. Intune and Entra consume that signal in their supported compliance and access workflows.
5. Conditional Access is first evaluated in report-only mode for a small pilot. Enforcement is considered only after registration, signal reporting, exclusions, and recovery paths are verified.

The integration has multiple control planes. Jamf evaluates device criteria; Intune provides the partner integration; Entra evaluates access. A green status in one console is not proof that every stage completed. Correlate timestamps and device identity across supported consoles before drawing a conclusion.

## Trust boundaries and data handling

- Jamf inventory and compliance information crosses the Jamf-to-Microsoft boundary. Consult the current [Microsoft data sharing article](https://learn.microsoft.com/en-us/intune/privacy/data-sharing/ref-jamf-to-intune) and Jamf inventory appendix for exact fields for your product versions.
- Registration identifiers and user/device relationships are sensitive operational data. Do not copy them into public issues, screenshots, or committed fixtures.
- This repository uses fictional IDs and states only. The local scenario viewer has no Graph or Jamf API client.
- Treat connector permissions as security-sensitive. Review the consent prompt and Microsoft's supported permission model; do not manually add permissions or substitute broad Graph scopes.
- Conditional Access exclusions for registration must be the specific supported User Registration app, scoped and documented according to current Microsoft guidance. Do not broadly exclude users, platforms, or resources to suppress errors.

## Failure interpretation

The overall result is **unknown** if device registration is missing, identity correlation is uncertain, reporting is stale, the connector is inactive, or source data disagrees. Unknown is not equivalent to compliant. Investigate without expanding access based on an incomplete signal.

## References

- [Jamf Device Compliance integration guide](https://learn.microsoft.com/en-us/intune/device-security/compliance/jamf-entra-id)
- [Data Jamf Pro sends to Intune](https://learn.microsoft.com/en-us/intune/privacy/data-sharing/ref-jamf-to-intune)
- [Conditional Access overview](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview)
