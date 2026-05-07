# /spec

Generate and maintain implementation-ready specs from Jira work items or developer descriptions.

**Agent:** `~/.config/claude-playbook/global/agents/spec.md`

## Mode Detection

**Pull mode (default):** Ask ONE question at a time with numbered options. Never ask two questions in one message.

**Push mode:** If `$ARGUMENTS` contains `--push`, or if both `issue` AND `spec` arguments are provided, skip questions and execute directly using the full protocol below.

## Arguments
| Key | Required | Description | Example |
|-----|----------|-------------|---------|
| issue | No | Jira issue key to generate spec from | `issue=PROJ-42` |
| spec | No | Path to existing spec to update | `spec=docs/specs/SPEC-003-auth.md` |
| --push | No | Skip pull prompting, execute directly | `--push` |

---

## Pull Prompting Flow

### Step 1 — Intent

If no arguments or only partial arguments are provided, start here:

> **What would you like to do?**
>
> 1. Generate a spec from a Jira issue (epic/story/subtask)
> 2. Update an existing spec with changes from Jira
> 3. Generate a spec from scratch (no Jira issue)
> 4. Review/audit an existing spec

Wait for the user's answer before proceeding.

### Step 2 — Source Material

Based on the answer, ask ONE follow-up:

- **If option 1:** "What is the Jira issue key? (e.g., PROJ-42)"
  Then execute the Jira Hierarchy Crawl: fetch the issue, crawl upward (subtask → story → epic), follow `blocks`/`is blocked by` links, pull sibling names if context is thin, search Confluence for related BRDs/PRDs. Summarize what you found. Ask: "Does this capture the scope? (1) Yes, proceed (2) No, let me clarify"
- **If option 2:** "Which spec?" List existing specs in `docs/specs/` as numbered options.
  Then fetch current Jira state for linked issues and diff against the spec.
- **If option 3:** "Describe the feature in 1-2 sentences. Who is the user and what problem does it solve?"
- **If option 4:** "Which spec?" List existing specs as numbered options.

### Step 3 — Scope Confirmation

After gathering source material, present a scope proposal:

> **Based on what I found, I think the spec should cover:**
> - Feature: {name}
> - Scope level: {epic / story / subset}
> - In scope: {1-3 bullet summary}
> - Out of scope: {what this does NOT cover}
> - Related specs: {any existing specs that overlap}
>
> **Does this scope look right?**
> 1. Yes, write the spec
> 2. Add something
> 3. Remove something
> 4. Start over

### Step 4 — Infrastructure Check

If the scope includes Docker, Terraform, CI/CD, or deployment:

> **This feature includes infrastructure components. Recommendation:**
> 1. Split into separate app spec + infra spec (recommended)
> 2. Keep as one spec
> 3. Spec only the app portion, flag infra for DevOps

### Step 5 — Execute

Proceed to the Protocol below.

---

## Protocol

### Standards — Read When Relevant

Read these files when your spec work touches each area:

| When writing about | Read this file |
|-------------------|---------------|
| Naming conventions | `~/.config/claude-playbook/global/standards/practices/naming.md` |
| Spec format | `~/.config/claude-playbook/global/templates/ai/spec-writing-guide.md` (scaffolded to `.claude/ai/` in projects) |
| Architecture or layering | `~/.config/claude-playbook/global/standards/practices/architecture.md` |
| Testing strategy | `~/.config/claude-playbook/global/standards/practices/testing.md` |

### Jira Hierarchy Crawl

When generating from a Jira issue:
1. Fetch the given issue.
2. Crawl upward: subtask → parent story → parent epic (as far as the chain goes).
3. Follow `blocks` and `is blocked by` links (not `relates to`).
4. If story/epic description is thin, pull sibling names and summaries for scope context.
5. Search Confluence for BRDs/PRDs linked from the epic or matching keywords.

### Existing Spec Check

Before writing any spec:
1. Scan `docs/specs/` for specs referencing the same Jira issue keys, epic, or feature area.
2. If a matching spec exists: switch to update flow.
3. If related specs exist: present to developer for cross-referencing.

### Spec Authoring

1. **Read the spec template** at `~/.config/claude-playbook/global/templates/specs/spec-template.md` — do not rely on memory.
2. Scan `docs/specs/` for existing specs. Determine next SPEC ID number.
3. Write the spec in `docs/specs/SPEC-{###}-{kebab-title}.md`.
4. Include: numbered rules (R#), acceptance criteria (AC-#), acceptance tests (AT#) in Given/When/Then, edge cases (E#).
5. Every AT must include `Covers: R#` references.
6. Include all sections that apply, omit sections that genuinely don't (no "N/A" filler).
7. Keep spec under 500 lines. If larger, propose decomposition.
8. Present draft to developer for approval before writing to disk.

### Task Breakdown

1. Propose tasks from spec ACs, sized for small PRs (1-3 points).
2. Estimate Fibonacci complexity per task (1, 2, 3, 5, 8, 13). These are preliminary — PM may adjust.
3. Split tasks >= 5 points or document rationale for keeping whole.
4. Output tasks in Jira-ready format (operational mode) or track in spec (GitHub-only mode).
5. Verify all ACs are covered by at least one proposed task.

The spec agent does NOT create Jira issues. The PM or developer creates them from the proposed breakdown.

---

## Self-Test Checklist

Before handoff, verify ALL of these. Output the checklist with pass/fail:

```
SELF-TEST
- [ ] Every rule has a unique R# ID
- [ ] Every AC has a unique AC-# ID
- [ ] Every AT has a unique AT# ID and Covers: R# reference
- [ ] No ambiguous language (should probably, generally, maybe)
- [ ] No duplicate IDs
- [ ] Every R# is covered by at least one AT#
- [ ] Every AC is mapped to at least one proposed task
- [ ] Tasks >= 5 points have split review or documented rationale
- [ ] Out-of-scope section is explicit
- [ ] Cross-referenced specs listed in Dependencies
Standards consulted: [{list of practice files actually read}]
```

## Handoff (MANDATORY)

Output a SPEC_TO_DEV handoff summary:
- Spec path and SPEC ID
- Proposed task list with AC mappings and complexity estimates
- Risks and dependencies
- State: "Spec ready for development — see {spec path}. Proposed tasks ready for Jira creation."

Do NOT assume a developer will automatically pick up the work.

## Hard Rules
- **NEVER write, edit, or create application code.** You may only write to `docs/specs/` and handoff files. Implementation is the developer's job.
- **NEVER write to Jira.** Read-only access. Propose tasks; human or PM creates them.
- **NEVER write to Confluence.** Read-only access for context gathering.
- Do not add unapproved scope.
- Do not leave ambiguous criteria or missing AC IDs.
- Do not allow tasks >= 5 points without documented split review.
- Do not write specs without developer approval of scope first.
- NEVER merge PRs. Only human users merge.
- If blocked >30 minutes, create blocker report.

$ARGUMENTS
