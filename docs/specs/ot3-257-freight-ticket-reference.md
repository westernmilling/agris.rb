# Build Prompt — OT3-257: ACPV3 freight ticket reference detail

Jira: OT3-255 task OT3-257 · 2026-09-16 · Budget ≤200.
Condensed after the build from the house-format spec this PR first carried; rules and ACs
match the shipped code. Standing facts live in Jira OT3-256 (staging spike, 2026-09-14) and
the BRD "Freight Voucher via Agris API" (Confluence, SD space) and are not repeated here.

## Goal
Let a consumer post an AGRIS accounts-payable freight voucher (type FV) that references the
grain ticket it pays. AGRIS 22.3.0 SU5 or later (AGS-17887) stamps the voucher number on the
ticket and drops it from the unpaid Freight Expenses population. The gem gains the ACPV3
detail record; contracto wires it into vouchers in OT3-259.

## Scope
Exactly: `Agris::Api::NewVoucher::FreightTicketReferenceDetail` in `lib/agris/api/new_voucher.rb`,
its RSpec file, a `NewVoucher` RSpec file for mixed details, this prompt, and an `Unreleased`
changelog line. Later: the 1.1.0 bump and dated changelog heading (release PR); consumer-side
rules in contracto's `docs/specs/freight-conventions.md` (OT3-258).

## Rules
- R1 — includes `XmlModel`; `ATTRIBUTE_NAMES` is exactly `in_out_code`, `ticket_location`,
  `ticket_number`, `freight_amount`, `record_type`; `attr_reader(*ATTRIBUTE_NAMES)` as on
  `NewVoucher` and `NewDisbursement`.
- R2 — `record_type` is always `'ACPV3'`; a value passed to the constructor is overwritten.
- R3 — `to_xml_hash` emits `:@recordtype => 'ACPV3'` plus `:@inoutcode`, `:@ticketlocation`,
  `:@ticketnumber`, `:@freightamount` for whichever attributes were supplied, values untouched.
  An omitted attribute emits no key (existing `XmlModel` behaviour; AGRIS decides validity).
- R4 — `NewVoucher#add_detail` needs no change: a voucher holding a `GeneralLedgerDetail` and
  this detail serializes both, in insertion order, each under its own record type.
- R5 — MUST NOT validate AGRIS-side rules (ACPV3 sum equals voucher amount, shipper equals
  remit-to, an ACPV2 line present). AGRIS reports those in-band via `PostResult#reject_reasons`.

## Acceptance criteria (the complete test list)
- AC-1 — `record_type` defaults to ACPV3; `record_type: 'OTHER'` still reads and serializes ACPV3.
- AC-2 — all four attributes supplied (I / 051 / 0028786 / 230.85, the spike's ticket): readers
  return the inputs; `to_xml_hash` equals exactly the five-key hash.
- AC-3 — only `ticket_number` supplied: the other readers return nil; hash keys are exactly
  `:@ticketnumber` and `:@recordtype`.
- AC-4 — `ATTRIBUTE_NAMES` lists exactly the five names.
- AC-5 — `NewVoucher` with one GL detail then one ACPV3 detail: `details` in insertion order,
  record types `%w(ACPV2 ACPV3)`, header `to_xml_hash` excludes the details.

## Slice-specific notes
- The two older detail classes have no readers and are left alone.
- No spec IDs or paths in code or test comments (Coding Style Rules §2.4); traceability is this
  prompt plus the PR checklist.
- Wire shape confirmed by rendering the real `create_voucher` payload: the ACPV3 element lands
  flat inside `<details>` beside ACPV0 and ACPV2.
