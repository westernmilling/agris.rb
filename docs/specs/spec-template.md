<!-- See rename-folder.example.md for a completed example of this template -->

# Spec: <Feature Name>

## Goal
Short description of the feature's purpose and value.

## Non Goals
Explicitly excluded behavior. List what this spec intentionally does NOT cover.

## Definitions
Key domain terms used in this spec. Define any term a new team member might misunderstand.

## Interfaces
Inputs, outputs, APIs, or UI events. Include request/response schemas where applicable.

## Rules
<!-- Rules describe system behavior at implementation level.
     Each rule should be specific enough to test.
     Bad: "User can log in."
     Good: "POST /api/auth/login with valid credentials returns 200 and a session token (R1)." -->

R1: <rule>
R2: <rule>

## State Model
If the system has state transitions, describe them here. Otherwise remove this section.

## Edge Cases
E1: <edge case and expected behavior>
E2: <edge case and expected behavior>

## Acceptance Criteria
<!-- ACs describe observable outcomes a stakeholder can verify.
     Rules are implementation-facing; ACs are user-facing.
     Example: "AC-1: User sees a green checkmark when password meets all strength requirements." -->

AC-1: <criterion>
AC-2: <criterion>

## Acceptance Tests
<!-- Each AT must have a Covers: field listing the R# or E# it validates.
     An AT can cover multiple rules. -->

AT1
Given <context>
When <action>
Then <outcome>
Covers: R1

AT2
Given <context>
When <action>
Then <outcome>
Covers: R2

## Observability
Logs, metrics, alerts (optional).

## Implementation Decisions

| Date | Decision | Rationale |
|------|----------|-----------|

## Change Log

| Date | Change | Affected IDs | Rationale |
|------|--------|-------------|-----------|
