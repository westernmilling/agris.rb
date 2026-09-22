# Specs

Specs in this repo are **build prompts**: short, point-in-time briefs for one PR. The code is
the source of truth; a prompt records what a slice was asked to deliver and is not updated
after review. Divergence between prompt and merged code is an expected record of what review
corrected.

Standing facts (Agris behaviour, business rules, spike results) live in Jira and Confluence and
are cited, not repeated. A prompt states only what is specific to its slice.

## Writing one
1. Name the file for the Jira task the PR delivers: `docs/specs/<key>-<slug>.md`
   (e.g. `ot3-257-freight-ticket-reference.md`).
2. Keep it to roughly 25–45 lines: **Goal** (2–3 sentences), **Scope** stated positively
   ("Exactly: …" plus one "Later: …" line), **Rules** (R#, MUST / MUST NOT), **Acceptance
   criteria** (AC#, the complete test list), and **Slice-specific notes** for gotchas.
3. Note the diff budget (≤200 lines) and split before dispatch if the estimate is over.
4. Commit it with the PR as a `docs(specs):` commit and paste it into the PR description
   in a collapsed `<details>` block titled "Build prompt (frozen — not updated after review)".
5. Cite R# and AC# in commit bodies and the PR's test checklist. Do not put spec IDs or
   paths in code or test comments.

`spec-template.md` and `rename-folder.example.md` are the retired long-form house format,
kept for reference only. The area folders (`grain/`, `inventory/`, …) are unused by prompts.
