# Specs

Source of truth for behavior in the `agris` gem. Implementation, tests, and PRs trace back to spec IDs (R#, E#, AC-#, AT#).

## How to add a spec
1. Copy `spec-template.md` into the appropriate area folder (see below).
2. Name the file by feature, kebab-case (e.g., `import-grain-ticket.md`).
3. Fill in Goal → Rules → Acceptance Criteria → Acceptance Tests.
4. Reference spec IDs in commits, tests, and PR descriptions.

## Layout

Specs are grouped by Agris API area, mirroring `lib/agris/api/`:

- `grain/` — tickets, contracts (purchase/sales), commodity codes, grade factors, rates
- `inventory/` — delivery tickets, orders
- `accounts-payables/` — voucher posting
- `accounts-receivables/` — invoice posting
- `messages/` — document-tracking and "changed since" queries
- `support/` — support / utility messages

Cross-cutting specs (config, transport, error model) can live at the top level of `docs/specs/`.

## Templates
- `spec-template.md` — blank template, copy this.
- `rename-folder.example.md` — completed example showing the expected level of detail.
