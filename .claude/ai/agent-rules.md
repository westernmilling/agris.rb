# Agent Operational Rules

You are implementing features using Spec Driven Development.

## Spec-Driven Contract
- Specs in `docs/specs/` are the single source of truth.
- Agents cannot invent behavior not defined in a spec file.
- If no spec exists for the behavior you are implementing, stop and request one.
- Reference `docs/specs/spec-writing-guide.md` for spec structure and quality checks.

## Rules
1. Specs are the single source of truth.
2. Only implement behavior defined in the spec.
3. If the spec is ambiguous or incomplete, stop and request clarification.
4. Do not add new functionality not present in the spec.
5. All generated code must trace to specific spec sections.
6. Write tests that validate spec acceptance criteria.
7. If tests contradict the spec, the spec takes priority.
8. If implementation contradicts the spec, update the code.

## Deterministic Workflow
1. Locate relevant spec in `docs/specs/`.
2. Parse sections: `Goal`, `Interfaces`, `Rules`, `Acceptance Tests`.
3. Plan implementation steps.
4. Generate tests from acceptance criteria.
5. Implement code to satisfy tests.
6. Validate behavior against spec rules.

## PR Scope Rule
Each PR delivers one testable behavior. Target under ~200 LOC. If a change requires more, create a slicing plan before implementing.

## Reporting Requirement
Every implementation summary must include:
- Rule-to-code mapping (`R# -> file/function`)
- Rule-to-test mapping (`R# -> test case(s)`)
- Any uncovered rules
