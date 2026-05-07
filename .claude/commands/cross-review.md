# /cross-review

Orchestrate independent codebase reviews from one or more secondary AI providers.

**Agent:** `~/.config/claude-playbook/global/agents/cross-review.md`

## Input Handling

## Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| providers | no | Which AI review providers to use |
| scope | no | Files/directories to review |
| focus | no | Review focus area (quality, security, etc.) |
| output | no | Output file path |
| --push | no | Skip interactive questions |

**Push mode** (`--push` flag or all required args present): skip questions, execute directly.

**Pull mode** (default): discover providers, then ask ONE question at a time.

## Pull Sequence

1. **Discover providers first.** Check for tools matching `mcp__*_review__review_files`.
   If zero providers found: stop immediately with setup instructions.

2. **Question 1 -- Which providers?**
   If `providers` not specified and multiple are available:
   ```
   Which review providers should I use?
   1. All available: [list discovered providers]
   2. [Provider A] only
   3. [Provider B] only
   4. Custom selection -- name them
   ```

3. **Question 2 -- What scope?**
   If `scope` not specified:
   ```
   What should I review?
   1. Full codebase (src/)
   2. Recent PR changes only
   3. Specific directory -- name it
   4. Specific files -- list them
   ```

4. **Question 3 -- Review focus?**
   If `focus` not specified:
   ```
   What should reviewers focus on?
   1. General code quality
   2. Security vulnerabilities
   3. Performance issues
   4. Accessibility compliance
   5. Architecture and design
   6. All of the above
   ```

## Protocol
1. Discover available review providers.
2. Gather files to review (apply .gitignore + standard exclusions).
3. Chunk files into batches (~50 files or ~100KB per batch).
4. Send batches to each provider in parallel.
5. Aggregate findings. Group by file. Highlight consensus, unique findings, and disagreements.
6. Save report to `output` path (default: `docs/reviews/cross-review-{date}.md`).
7. Output summary with finding counts and top-severity issues.

## Self-Test
Before completing, verify:
- [ ] All selected providers returned results
- [ ] Findings grouped by file with provider attribution
- [ ] Consensus and disagreements clearly flagged
- [ ] Report saved to output path
- [ ] No provider findings suppressed or filtered
- [ ] Standards consulted list included

Output: `Standards consulted: [list of files read]`

## No-Provider Behavior
If no review providers are configured, output setup instructions and exit.
Do NOT fall back to self-review -- the entire point is independent external review.

## Hard Rules
- Do not edit source code. This is a read-only review command.
- Do not suppress or filter findings from any provider.
- Do not resolve disagreements between providers -- flag them for human judgment.
- NEVER merge PRs. Only humans merge.
- If blocked >30 minutes, create blocker report.

$ARGUMENTS
