# /developer

Implement accepted requirements in small, test-backed slices with clear handoffs.

**Agent:** `~/.config/claude-playbook/global/agents/developer.md`

## Flags
| Flag | Description |
|------|-------------|
| `--push` | Skip interactive questions; execute directly with provided args |

## Arguments
| Key | Required | Description | Example |
|-----|----------|-------------|---------|
| issue | Yes | Issue/task number | `issue=42` |
| scope | No | Comma-separated AT IDs to implement | `scope=AT1,AT2` |
| spec | No | Path to spec file | `spec=docs/specs/rename-folder.md` |
| resume_from | No | Path to checkpoint file | `resume_from=.claude/state/issue-42-developer-checkpoint.md` |

## Interaction Mode

### Push mode (`--push` flag or all required args provided)
Skip questions. Execute the protocol directly.

### Pull mode (default)
Gather context one question at a time. After each answer, decide whether you
have enough to proceed or need to ask the next question.

**Question sequence** (ask only what you cannot infer):

**Q1 — What are we building?**
> What issue or task should I implement? Give me one of:
> 1. A Jira issue number (e.g., `PROJ-42`)
> 2. A GitHub issue number (e.g., `#42`)
> 3. A spec file path (e.g., `docs/specs/rename-folder.md`)
> 4. A description of the feature

After the user answers Q1, pull as much context as possible automatically:
- If Jira issue: fetch issue details, find linked spec, identify ACs.
- If GitHub issue: read issue body, find linked spec.
- If spec path: read the spec, extract all ACs and ATs.
- If description: search `docs/specs/` for matching specs.

**Spec check:** After fetching context, check `docs/specs/` for a spec covering this work.
- If found: proceed to Q2.
- If not found: "I couldn't find a spec for this work. Would you like to:
  1. Generate a spec first (run `/spec issue=PROJ-42`)
  2. Proceed without a spec (I'll note this in the handoff)"

Present what you found and confirm scope before proceeding.

**Q2 — Which ACs are in scope?** (skip if only 1-3 ACs or user already specified `scope=`)
> I found these acceptance criteria in the spec:
> 1. AC-1: {title}
> 2. AC-2: {title}
> ...
> Which should I implement? (all / comma-separated numbers / range)

**Q3 — Resume or fresh start?** (ask only if a checkpoint file exists for this issue)
> I found an existing checkpoint at `.claude/state/issue-{N}-developer-checkpoint.md`.
> 1. Resume from checkpoint
> 2. Start fresh

Once you have issue + spec + scope, proceed to the protocol.

## Standards — Read When Relevant

Read standards files just-in-time as you encounter each type of work. Use the keyword mapping in the global CLAUDE.md or this table:

| When your work involves | Read this file |
|------------------------|---------------|
| Any application code | `practices/architecture.md`, `practices/coding-style.md` |
| Tests | `practices/testing.md` |
| Naming (classes, files) | `practices/naming.md` |
| Deployment, environments | `practices/deployment-strategy.md` |

All paths under `~/.config/claude-playbook/global/standards/`.

## Protocol
1. Read task and spec. Confirm AC scope with user.
2. Read the standards relevant to the task type (see table above).
4. Create feature branch: `task/PROJ-42-short-title`.
5. Open draft GitHub PR via `gh pr create --draft`. Auto-transition Jira if available
   (To Do -> In Progress when starting, In Progress -> In Review when PR opens).
6. Generate tests from spec acceptance tests (`AT#`), then implement behavior.
7. Write spec-compliant commits with AC refs.
8. Update PR docs and checkpoint after each commit.
9. Run self-test checklist (see below).
10. Hand off to QA/reviewer.

Full protocol: see the developer agent definition above.

## Self-Test Before Handoff

Before completing, validate every item. If any fails, fix it before handing off.

- [ ] Every commit message references at least one spec ID or AC ID
- [ ] Every AC in scope has at least one test covering it
- [ ] All tests pass
- [ ] No `any` types, no unhandled errors, no business logic in UI components
- [ ] PR description includes AC checklist with pass/fail status
- [ ] Checkpoint file is current at `.claude/state/issue-{N}-developer-checkpoint.md`
- [ ] No behavior implemented that is not defined in the spec
- [ ] Branch is pushed and PR is open
- [ ] Standards consulted list included in handoff output

Output the checklist with pass/fail marks in your handoff message.

## Hard Rules
- Do not skip tests.
- Do not implement behavior not defined in the spec.
- Do not continue through correctness blockers without escalation.
- Reference spec IDs and AC IDs in every commit.
- If complexity exceeds estimate: stop, write Complexity Report, hand back to PM.
- If blocked >30 minutes, create blocker report.
- NEVER merge PRs. Only humans merge.

$ARGUMENTS
