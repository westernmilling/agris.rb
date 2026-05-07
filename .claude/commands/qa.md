# /qa

Validate behavior and quality gates with reproducible evidence.

**Agent:** `~/.config/claude-playbook/global/agents/qa.md`

## Standards — Read When Relevant

Read these files when your validation work touches each area:

| When validating | Read this file |
|----------------|---------------|
| Test structure, coverage | `practices/testing.md` |
| Quality gates, merge criteria | `standards/quality-gates.md` |

Always read the active spec in `docs/specs/` and extract ACs in scope before starting.
All paths under `~/.config/claude-playbook/global/`.

## Input Resolution

The QA agent needs three pieces of context to begin work: a **PR number**, a **spec file**, and a **validation mode**. The interaction model depends on what the user provides and whether `--push` is set.

### Push mode (`--push`)

If `--push` is present or all three inputs (pr, spec, mode) are provided, skip all questions and execute the full protocol immediately.

### Pull mode (default)

Ask ONE question at a time. Wait for the answer before asking the next. Use numbered options.

**Question 1** -- always ask first unless the user already stated what they want:

> What would you like to validate?
>
> 1. Validate a PR against spec acceptance criteria
> 2. Run Playwright browser verification on a running app
> 3. Parity check -- compare new app against legacy/staging
> 4. Ad-hoc quality check (no PR, just a spec or feature area)

**Question 2** -- based on the answer to Q1:

- If (1) and no PR number provided: "Which PR number?" (accept `#123` or `123`)
- If (2): "What is the app URL?" (default: `http://localhost:3000`)
- If (3): "What are the two URLs to compare?" (legacy staging URL + new app URL)
- If (4): "Which spec file or feature area?"

**Question 3** -- only if not yet resolved:

- If spec not yet identified: "Which spec file?" (or offer to auto-detect from PR description)
- If mode is parity and legacy URL missing: "What is the legacy staging URL?"

After all required inputs are resolved, confirm the plan in one line and begin.

### Minimum viable input

If the user provides just a PR number (e.g., `/qa 128`), do the following automatically:
1. Run `gh pr view 128` to get the PR description and branch.
2. Extract the spec path from the PR description (look for `docs/specs/` references).
3. Extract AC IDs from the PR description or commits.
4. Default to mode=standard.
5. Confirm: "Validating PR #128 against {spec} -- ACs in scope: {list}. Proceeding."

## Arguments

| Key | Required | Description | Example |
|-----|----------|-------------|---------|
| pr | No | PR number | `pr=128` |
| spec | No | Path to spec file | `spec=docs/specs/rename-folder.md` |
| mode | No | `standard` (default), `parity`, or `browser` | `mode=parity` |
| staging_url | No | Legacy app URL (parity mode) | `staging_url=https://staging.example.com` |
| local_url | No | New app URL (default: http://localhost:3000) | `local_url=http://localhost:5173` |
| --push | No | Skip questions, execute immediately | `--push` |

## Protocol

Once inputs are resolved:

1. Load spec and extract AC IDs for this PR scope.
2. Read relevant standards (see table above) as you encounter each validation type.
3. Check commit message compliance (conventional commits format, spec/AC refs in footers, no Jira refs in subject).
4. Run automated tests and capture results.
5. For each AC in scope, verify: behavior matches spec, test covers the AC.
6. If Playwright is available and mode is `browser` or `standard` with UI changes:
   - Navigate to the running app.
   - Walk through AC scenarios (click, fill, navigate).
   - Screenshot key states. Commit to `docs/evidence/`.
7. If mode is `parity`: execute the Legacy Parity Verification workflow (see QA agent definition above).
8. Post verdict as GitHub PR comment with per-AC evidence.
10. Hand off PASS/FAIL with blocking details.

## Self-Test Checklist

Before posting the final verdict, verify every item:

- [ ] Every AC in scope has a PASS or FAIL with linked evidence.
- [ ] Commit messages checked for conventional commits format and spec/AC refs in footers.
- [ ] Screenshots committed and linked (if UI ACs present).
- [ ] No AC marked PASS without test or behavioral evidence.
- [ ] Verdict posted as GitHub PR comment (not just local output).
- [ ] Standards consulted: [testing.md, quality-gates.md, active spec].

## Hard Rules

- **NEVER write, edit, or create code files.** You are read-only. If you find a bug, document it — do not fix it.
- Do not mark PASS without required evidence.
- Do not mark PASS if spec rule coverage is incomplete.
- Do not mark AC as verified without test evidence.
- Do not merge PRs. Only human users merge.
- If blocked >30 minutes, create blocker report.

$ARGUMENTS
