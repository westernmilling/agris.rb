# Spec Writing Guide

## Authoring Rules
- Keep specs focused — one concept per spec. AI agents perform worse on long specs.
- Keep each spec under 500 lines.
- Use the canonical template in `docs/specs/spec-template.md`.
- Number rules (`R#`) and edge cases (`E#`).
- Acceptance tests must use Given/When/Then and IDs (`AT#`).
- Each acceptance test must include `Covers: R#` references.

## Language Rules
- Use explicit, testable statements.
- Avoid ambiguous wording such as:
  - "should probably"
  - "generally"
  - "maybe"

## Examples
Bad:
- Folders should probably have a reasonable name.

Good:
- Folder names must be between 1 and 80 characters.

## Implementation Decisions Section
Use the `## Implementation Decisions` section to record choices made during development that are not part of the behavioral spec but matter for maintainability. Examples:

- Why a particular approach was chosen over alternatives
- Performance trade-offs accepted
- Libraries selected and why
- Known limitations and their rationale

This section is updated by the developer during implementation, not by the spec author upfront.

## Spec Update Discipline
Acceptance test IDs must map to runnable tests. When a test changes, update the owning AC in the same PR. A spec that no longer matches the test suite is a broken spec.

## Required Quality Checks Before Merge
- Every rule has a unique ID.
- Every rule is referenced by at least one acceptance test.
- No duplicate rule IDs.
- No duplicate acceptance test IDs.
- No acceptance test references a rule that does not exist.
