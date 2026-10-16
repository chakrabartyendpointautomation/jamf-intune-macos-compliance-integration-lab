# Troubleshooting and evidence collection

Use this as a diagnostic order, not a substitute for Jamf or Microsoft support guidance. Start with one affected test user and Mac. Record timestamps and correlation method; redact identifiers in shared notes.

## Triage sequence

1. **Scope and change history** — confirm the user and Mac are intended for the Applicable group and Intune partner assignment. Check changes to Jamf criteria, connector setup, Company Portal deployment, group membership, and Conditional Access targeting.
2. **Jamf inventory** — verify the Mac is managed by the intended Jamf Pro instance, inventory is recent, and source criteria have expected membership. Check FileVault evidence only against the approved lab criteria.
3. **Registration** — verify Company Portal is installed/current, the user completes the supported Entra registration flow, and the Entra device record corresponds to the correct user and Mac. Do not delete duplicate-looking records as a first step.
4. **Connector and partner** — verify Jamf Device Compliance is enabled for macOS with expected groups; verify Intune shows the partner active and scoped to the intended user group.
5. **Signal timing** — compare Jamf inventory, group evaluation, Intune reporting, and sign-in timestamps. Do not treat a stale result as a fresh pass.
6. **Conditional Access** — inspect the actual Entra sign-in log and policy result. Check whether registration was blocked, whether the specific Device Compliance User Registration app exclusion applies, and whether the intended resource/pilot policy was evaluated.
7. **Network and service health** — review current Jamf/Microsoft/Apple requirements for the versions in use. Do not assume an older Cloud Connector port list applies unchanged to Device Compliance.
8. **Escalate** — if records remain inconsistent, capture supported logs and sanitized timestamps for vendor support. Avoid changing connector permissions or deleting registrations without vendor direction and approved change control.

## Symptom guide

| Symptom | First checks | Safe next step |
| --- | --- | --- |
| Device never appears in Entra | Company Portal, registration policy scope, user sign-in log, registration-app exclusions | Test supported registration with one pilot user; fix targeting or a specific policy block |
| Registered device absent from expected Intune view | Connector status, partner assignment, registration identity, timestamps | Verify group membership and partner status; compare a second known pilot record |
| Compliance does not update | Jamf inventory freshness, Compliance group criteria, connector state, last update | Refresh inventory through approved workflow and recheck timestamps; keep status unknown until confirmed |
| Unexpected noncompliance | Failed Jamf criterion, inventory freshness, partner assignment | Confirm the criterion and remediate through normal change process; do not add a blanket pass rule |
| Sign-in blocked | Entra sign-in log, policy/resource scope, registration state, report-only result | Pause rollout; correct pilot targeting or specific registration-app exception under approval |
| Duplicate/mismatched records | User/device correlation, enrollment history, platform, timestamps | Preserve evidence and follow vendor cleanup guidance before any deletion |
| Connector setup fails | Consent prompt, Jamf role, Intune partner workflow, supported versions | Review current prerequisites and change history; do not hand-edit generated app permissions |

## Minimum incident note

Capture ticket/change reference, symptoms, time zone, affected population size, product versions, last-known-good time, connector/partner states, Jamf inventory freshness, Entra registration outcome, Conditional Access policy result, sanitized evidence reference, and owner. Exclude tokens, secrets, full identifiers, serial numbers, screenshots with names, and raw inventory from this public repository.

## Vendor troubleshooting references

- [Troubleshoot Jamf Pro integration with Microsoft Intune](https://learn.microsoft.com/en-us/troubleshoot/mem/intune/device-protection/troubleshoot-jamf)
- [Jamf Device Compliance integration guide](https://learn.microsoft.com/en-us/intune/device-security/compliance/jamf-entra-id)
- [Jamf data shared with Intune](https://learn.microsoft.com/en-us/intune/privacy/data-sharing/ref-jamf-to-intune)
