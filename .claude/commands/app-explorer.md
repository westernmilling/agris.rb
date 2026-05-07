# /app-explorer

Navigate running applications via Playwright to produce tours and comparisons.

**Agent:** `~/.config/claude-playbook/global/agents/app-explorer.md`

## Input Handling

## Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| mode | no | tour, comparison, or screenshot |
| url | no | Primary app URL |
| staging_url | no | Legacy/staging URL (comparison mode) |
| local_url | no | Local dev URL (comparison mode) |
| flows | no | Which user flows to explore |
| --push | no | Skip interactive questions |

**Push mode** (`--push` flag or all required args present): skip questions, execute directly.

**Pull mode** (default): gather context, then ask ONE question at a time.

## Pull Sequence

1. **Question 1 — What mode?**
   If `mode` not provided:
   ```
   What kind of exploration?
   1. Tour -- walk through a single app, narrate screens and interactions
   2. Comparison -- side-by-side legacy vs. new app, produce delta report
   3. Screenshot capture -- grab specific screens for evidence
   ```

2. **Question 2 — App URL(s).**
   Based on mode, ask for the URL(s) not provided:
   - Tour: "What URL should I open?" with suggestions from project config
   - Comparison: "What are the two URLs?" (staging + local)
   - Screenshot: "What URL and which screens?"

3. **Question 3 — Which flows?**
   If `flows` not provided:
   ```
   Which flows should I explore? (pick multiple)
   1. Home / dashboard
   2. Authentication / login
   3. Primary CRUD operations
   4. Settings / admin
   5. All major flows
   6. Specific flows -- describe them
   ```

## Standards — Read Before Opening Browser

Read the relevant playbook before launching Playwright (the browser patterns are non-obvious):

| Mode | Read this file |
|------|---------------|
| Tour | `~/.config/claude-playbook/global/templates/ai/playbooks/app-tour.md` |
| Comparison | `~/.config/claude-playbook/global/templates/ai/playbooks/legacy-comparison.md` |

## Protocol
1. Read the relevant playbook.
2. Open app(s) in Playwright -- comparison mode uses TWO SEPARATE WINDOWS via `browser.newContext()`.
3. Walk through screens at a deliberate pace. Sleep between navigations.
4. Narrate what you see. Interact with pages -- click filters, open forms.
5. For comparisons, compare each screen in BOTH apps before moving to the next.
6. Save reports to `docs/research/`.

## Self-Test
Before completing, verify:
- [ ] All requested flows explored
- [ ] Screenshots captured for key screens
- [ ] Report saved (comparison mode: `docs/research/legacy-comparison-{date}.md`)
- [ ] Both apps visited in comparison mode (not just one)
- [ ] No flows skipped without documented reason
- [ ] Standards consulted list included

Output: `Standards consulted: [list of files read]`

## Hard Rules
- Do not produce a comparison report from only one app.
- Do not open the second app as a tab -- use `browser.newContext()` for a separate window.
- Do not rush through screens -- sleep between navigations.
- Read the playbook before opening any browser. No exceptions.

$ARGUMENTS
