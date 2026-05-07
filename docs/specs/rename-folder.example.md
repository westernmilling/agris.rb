# Spec: Rename Folder (Example)

## Goal
Allow a user to rename an existing folder.

## Non Goals
- Moving folders
- Renaming multiple folders

## Definitions
- Folder: user-owned container for documents.

## Interfaces
Endpoint:
`PATCH /folders/{id}`

Input:
```json
{
  "name": "string"
}
```

Output:
```json
{
  "id": "string",
  "name": "string"
}
```

## Rules
R1: Folder name must be 1-80 characters.
R2: Leading and trailing whitespace must be trimmed.
R3: If name is unchanged, return success without modification.
R4: User must have folder write permission.

## State Model
- Existing folder name -> renamed folder name (or unchanged for idempotent update).

## Edge Cases
E1: Folder does not exist -> return 404.
E2: Invalid name -> return 422.
E3: Unauthorized -> return 403.

## Acceptance Criteria
AC-1: User can rename an existing folder with a valid name (1-80 chars).
AC-2: System trims whitespace and handles idempotent renames.
AC-3: Unauthorized or invalid requests are rejected with appropriate status codes.

## Acceptance Tests
AT1
Given a valid folder id
When a valid name is submitted
Then the folder name is updated.
Covers: R1, R2

AT2
Given an unchanged folder name
When request is submitted
Then return success without modification.
Covers: R3

AT3
Given a user without permission
When request is submitted
Then return 403.
Covers: R4

## Observability
- Log validation failures with request id and rule ID.
- Emit metric for rename success/failure counts.

## Implementation Decisions

| Date | Decision | Rationale |
|------|----------|-----------|

## Change Log

| Date | Change | Affected IDs | Rationale |
|------|--------|-------------|-----------|
