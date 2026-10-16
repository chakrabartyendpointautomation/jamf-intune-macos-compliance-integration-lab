# Conditional Access staging and scenario matrix

Conditional Access can interrupt registration if the registration app is blocked by a policy that requires an already registered, compliant device. Plan the registration exception before pilot sign-in and follow Microsoft's current connector guide for exact policy details.

## Scope design

For a lab, use dedicated test users and a dedicated macOS device. Exclude administrators and emergency-access accounts from the pilot. Select a low-impact resource and document its owner. Review existing user, device, platform, location, client-app, and authentication conditions that apply.

Target a compliance-enforcement policy only to the intended pilot users and resources. Include a macOS platform condition when appropriate. Require a compliant device only after the compliance signal is available. Exclude the supported **User Registration app for Device Compliance** from policies that would otherwise block registration. Keep the exception app-specific and policy-specific; do not exclude all Microsoft apps or all pilot users.

Use report-only mode before enforcement. Review Conditional Access What If results and sign-in logs for the test identity. What If is a planning aid; actual sign-in logs for registration and resource access are still needed.

## Scenario matrix

| Scenario | Jamf evidence | Registration / connector evidence | Expected interpretation | Operator action |
| --- | --- | --- | --- | --- |
| Healthy pilot | Meets configured Jamf Compliance criteria; inventory is fresh | Entra registration present; partner active; signal timestamp advances | Eligible for intended compliant-device decision after validation | Review actual report-only sign-in before enforcement |
| Control intentionally fails | Device deliberately misses an approved Jamf criterion | Registration present; connector active; status updates | Noncompliant; should not satisfy a compliant-device requirement | Confirm failed criterion and recovery path |
| Not registered | Jamf inventory exists; expected Entra registration absent | Registration workflow incomplete or blocked | Incomplete/unknown | Investigate registration exception, Company Portal, account, and logs |
| Stale inventory | Last Jamf inventory exceeds the lab freshness threshold | Connector may be active but last signal is old | Unknown/stale; not a verified pass | Refresh inventory through approved Jamf workflow and check timestamp |
| Connector inactive | Jamf criteria appear set | Partner/connector is inactive or errored | Unknown | Stop rollout; investigate consent, assignment, and connector status |
| Conflicting identity/duplicates | Multiple or mismatched records across tools | Device/user correlation is uncertain | Unknown until resolved | Preserve evidence; follow vendor troubleshooting, avoid deletion as first response |
| Registration blocked by CA | Jamf device/user otherwise in scope | Sign-in log shows registration blocked by policy | Registration incomplete; compliance unresolved | Verify the specific registration-app exclusion and targeting |

## Pilot decision record

Before moving a policy from report-only to On, record the pilot scope, policy owner, registration-app exclusion and its justification, expected scenario results, sign-in evidence, unresolved cases, support/recovery owner, rollback condition, and explicit change approval. Keep actual identifiers in approved internal systems, not this public repository.

## Rollout and rollback controls

1. Start report-only with a small pilot and a specific resource.
2. Review sign-in logs and device registration/compliance evidence during the agreed observation period.
3. Expand only one dimension at a time (users, devices, or resources), with change approval.
4. If registration fails or access is unexpectedly blocked, pause expansion and return the affected policy assignment to report-only or remove the pilot assignment under the approved change plan.
5. Preserve emergency-access and administrative recovery paths. Never use a broad exclusion as an incident workaround.

## References

- [Jamf Device Compliance integration and registration guidance](https://learn.microsoft.com/en-us/intune/device-security/compliance/jamf-entra-id)
- [Conditional Access report-only mode](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-report-only)
- [Conditional Access What If tool](https://learn.microsoft.com/en-us/entra/identity/conditional-access/what-if-tool)
