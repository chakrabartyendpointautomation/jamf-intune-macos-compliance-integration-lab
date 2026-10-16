# Staged implementation runbook

This is a change-planning scaffold for a dedicated non-production tenant. Use the current Microsoft and Jamf instructions for exact screens and supported versions; console labels and prerequisites can change. Do not perform first-time integration directly in production.

## Phase 0 — Scope and recoverability

- Name the Jamf Pro instance, Entra tenant, Intune subscription, macOS pilot, test users, target resources, change owner, and support contacts.
- Confirm Jamf Pro is the intended macOS MDM authority. Identify devices currently enrolled in Intune or using the earlier Jamf macOS Conditional Access integration.
- Record baseline connector state, Jamf inventory freshness, Entra registration state, Intune partner visibility, and applicable Conditional Access policies.
- Confirm licensing, product versions, roles, Company Portal deployment, network reachability, and recovery access against current vendor guidance.
- Agree on change approval, maintenance window, user communications, and rollback owner.

**Gate:** Stop if device ownership is ambiguous, recovery access is missing, a legacy integration migration is unplanned, or registration is blocked by an existing policy.

## Phase 1 — Define Jamf source criteria

1. Create a narrowly scoped **Applicable** smart group for Macs intended to register and access the selected resources. Microsoft documents Company Portal presence as one possible example criterion; adapt to your ownership and inventory rules.
2. Create a **Compliance** smart group for controls Jamf can evaluate reliably. Microsoft's example uses recent inventory, Company Portal presence, and FileVault encryption. Document each control owner and the inventory freshness threshold.
3. Review group inclusion/exclusion logic for overlap, missing inventory, membership delay, and devices outside scope.
4. Record that Jamf groups are the source criteria; Intune does not make a missing or stale signal compliant.

Do not copy example criteria blindly. Map every criterion to an approved requirement and a remediation/exception owner.

## Phase 2 — Prepare registration

1. Deploy and maintain Microsoft Intune Company Portal to intended Jamf-managed Macs through Jamf, following current vendor guidance.
2. Configure the supported Jamf policy for Microsoft Entra device registration and scope it only to Applicable devices. If Self Service is used, provide a clear user action and support instructions.
3. Review Conditional Access policies for the supported Device Compliance User Registration app exclusion where needed to permit registration. Keep the exception app-specific and policy-specific; do not broadly exclude pilot users.
4. Test registration with a non-privileged test user and one lab Mac. Confirm the device registers and the user/device identity is correlated correctly.

**Gate:** Registration must complete without repeated prompts, unexplained duplicate identities, or a broad policy exception.

## Phase 3 — Configure Device Compliance

1. In Jamf Pro, use **Settings > Global > Device Compliance** to select macOS and the Applicable and Compliance groups.
2. Complete the vendor-supported connector/consent flow with authorized administrators. Review prompts; never copy secrets or tokens into the evidence log.
3. In Intune, configure the Jamf Device Compliance partner for macOS and assign only the explicitly selected pilot user group. Microsoft's setup guide warns against selecting all users for this assignment.
4. Complete Jamf's confirmation step and verify the partner status is active in Intune.
5. Verify the pilot Mac appears in the supported views and its compliance signal/update time is plausible.

Use role separation where feasible. The Microsoft guide lists different Entra roles for connector, group, and Conditional Access tasks. Avoid granting broad roles to the operator account by default.

## Phase 4 — Validate the signal and access decision

Use [the scenario matrix](conditional-access-staging.md) for compliant, noncompliant, stale, unregistered, and unknown states. For each scenario, capture timestamps and evidence from Jamf, Intune, Entra registration, and sign-in logs. Redact identifiers before sharing evidence.

- Start Conditional Access in **report-only** for a narrow pilot and selected resources.
- Confirm the registration app exclusion is only applied where needed.
- Review actual sign-in evaluation and logs for registration and resource access.
- Validate recovery with a test account/device before expanding the pilot.
- Enforce only after the owner accepts the observed results and support is ready.

## Exit criteria

- Connector/partner is active and assigned to the intended pilot group.
- Pilot devices are registered to the expected Entra identities and correlate with Jamf inventory.
- Fresh compliant and deliberately noncompliant states produce expected, explainable results.
- Stale, missing, and ambiguous states remain unknown pending investigation.
- Report-only sign-ins, exclusions, support steps, rollback, and owners are documented.
- Change approval exists before extending enforcement beyond the pilot.

## Rollback outline

Rollback is an approved tenant change, not an automated script in this repository. Pause expansion and return the targeted policy to report-only or remove its pilot assignment under the organization's change process. Keep a working admin recovery route. Restore registration and connector configuration only through current vendor guidance; do not delete enterprise apps or terminate the partner as an improvised fix. Capture the resulting status and communicate with pilot users.

## Evidence log fields

Record change reference, timestamps/time zone, product versions, scope/group names, connector/partner status, redacted device correlation method, test scenario, sign-in result, policy mode, discrepancy, owner, and disposition. Never store credentials, secrets, full user/device identifiers, or raw exports in this public repo.

## References

- [Current Jamf Device Compliance integration guide](https://learn.microsoft.com/en-us/intune/device-security/compliance/jamf-entra-id)
- [Jamf inventory data shared with Intune](https://learn.microsoft.com/en-us/intune/privacy/data-sharing/ref-jamf-to-intune)
- [Microsoft Conditional Access report-only mode](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-report-only)
