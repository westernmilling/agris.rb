# Spec: Freight Ticket Reference Detail (ACPV3)

## Goal
Let a consumer post an AGRIS accounts-payable freight voucher (doc type FV)
that references the grain ticket(s) whose freight it pays. AGRIS uses the
reference to stamp the ticket's Freight Voucher field with the new voucher
number and to drop the ticket from the unpaid Freight Expenses population.

The gem models the reference as a third `NewVoucher` detail record,
`Agris::Api::NewVoucher::FreightTicketReferenceDetail` (record type `ACPV3`),
beside the existing `GeneralLedgerDetail` (`ACPV2`) and `InventoryItemDetail`
(`ACPV1`).

## Non Goals
- Validating AGRIS-side voucher rules in the gem (amount sums, shipper/remit-to
  match, presence of an `ACPV2` line). AGRIS enforces these and reports
  failures in-band through `PostResult#reject_reasons`; the gem passes them
  through unchanged. The rules are recorded under Consumer Guidance so that
  callers can satisfy them, not so that the gem can check them.
- Reading ticket references back from AGRIS (no query message for `ACPV3`).
- Voiding vouchers. AGRIS exposes no API for this; it is a UI-only operation.
- Changes to `GeneralLedgerDetail`, `InventoryItemDetail` or `NewVoucher`
  serialization.
- Consumer-side changes (Otto / contracto) that build the voucher.

## Definitions
- **Freight voucher (FV):** an AP voucher (`ACPV0` header) paying a carrier for
  hauling grain. Doc type `2`, voucher type `FV`.
- **Grain ticket:** a GRN scale ticket identified in AGRIS by in/out code
  (`I` inbound, `O` outbound), location and ticket number.
- **Ticket freight:** the freight amount carried on the grain ticket, with
  freight status `F` and a shipper (carrier) name id.
- **Detail record:** one child record of a voucher. AGRIS distinguishes them by
  the `recordtype` attribute: `ACPV1` inventory item, `ACPV2` G/L
  distribution, `ACPV3` freight ticket reference.
- **AGS-17887:** the AGRIS enhancement (22.3.0 SU5 or later) that makes voucher
  import honour `ACPV3` records. Western Milling staging runs 24.0.0.3.

## Interfaces

Constructor (all values are strings, as for every other `XmlModel`):

```ruby
detail = Agris::Api::NewVoucher::FreightTicketReferenceDetail.new(
  in_out_code: 'I',          # I or O
  ticket_location: '051',    # 3-char location
  ticket_number: '0028786',  # 7-char ticket number
  freight_amount: '230.85'
)

voucher = Agris::Api::NewVoucher.new(voucher_amount: '230.85', ...)
voucher.add_detail(general_ledger_detail)   # ACPV2
voucher.add_detail(detail)                  # ACPV3
client.create_voucher(voucher)               # => Agris::Api::PostResult
```

Serialized form (`#to_xml_hash`), rendered by Gyoku as attributes of the detail
element inside the `create_voucher` post payload:

```ruby
{
  :@inoutcode      => 'I',
  :@ticketlocation => '051',
  :@ticketnumber   => '0028786',
  :@freightamount  => '230.85',
  :@recordtype     => 'ACPV3'
}
```

Readers: `#in_out_code`, `#ticket_location`, `#ticket_number`,
`#freight_amount`, `#record_type`.

## Rules
R1: `Agris::Api::NewVoucher::FreightTicketReferenceDetail` MUST include
    `XmlModel` and MUST declare `ATTRIBUTE_NAMES` as exactly `in_out_code`,
    `ticket_location`, `ticket_number`, `freight_amount`, `record_type`.
R2: `record_type` MUST always be `'ACPV3'`. A `record_type` supplied in the
    constructor hash MUST be overwritten.
R3: `#to_xml_hash` MUST emit `:@recordtype => 'ACPV3'` plus one `@`-prefixed,
    underscore-stripped key per attribute supplied to the constructor
    (`:@inoutcode`, `:@ticketlocation`, `:@ticketnumber`, `:@freightamount`),
    with values passed through unchanged.
R4: Every name in `ATTRIBUTE_NAMES` MUST have a public reader returning the
    value supplied to the constructor (`nil` when omitted).
R5: `NewVoucher#add_detail` MUST accept a `FreightTicketReferenceDetail`. A
    voucher holding both a `GeneralLedgerDetail` and a
    `FreightTicketReferenceDetail` MUST expose both through `#details`, in
    insertion order, each serializing to its own record type (`ACPV2`,
    `ACPV3`).

## Consumer Guidance (AGRIS-side rules, not enforced by the gem)
Established by a staging spike against AGRIS 24.0.0.3 on 2026-09-14 (voucher
051032228 paying inbound ticket 051 0028786, freight 230.85). Consumers
building an FV must satisfy:

- G1: One `ACPV3` detail per referenced ticket.
- G2: `freight_amount` equals the ticket's freight in AGRIS, and the sum of all
      `ACPV3` amounts equals the header `voucher_amount`. Otherwise:
      `FREIGHT VOUCHER, TICKET FREIGHT SUM DOES NOT MATCH VOUCHER TOTAL AMOUNT`.
- G3: At least one `ACPV2` G/L distribution line is still required. Otherwise:
      `GENERAL LEDGER DETAIL RECORD EXPECTED BUT NOT FOUND`.
- G4: Header `shipper_id` equals `remit_to_id`, and both equal the ticket's
      shipper in AGRIS. Otherwise:
      `FREIGHT VOUCHER, REMIT TO AND SHIPPER NAME ID DO NOT MATCH`.
- G5: The ticket must already exist in AGRIS with its freight and shipper
      before the voucher is posted.
- G6: A UI void of the voucher clears the ticket's Freight Voucher field. A
      later re-export of the ticket does not.

## State Model
None in the gem. AGRIS-side: ticket Freight Voucher blank -> stamped with
voucher number on successful post -> blank again on UI void.

## Edge Cases
E1: `record_type: 'OTHER'` passed to the constructor -> instance still reports
    and serializes `ACPV3`.
E2: An attribute omitted from the constructor -> its reader returns `nil` and
    no key for it appears in `#to_xml_hash`. AGRIS decides whether the record
    is acceptable.

## Acceptance Criteria
AC-1: A consumer can construct a freight ticket reference from a ticket's
      in/out code, location, number and freight amount, and read each value
      back.
AC-2: Serializing the reference yields an `ACPV3` record carrying
      `inoutcode`, `ticketlocation`, `ticketnumber` and `freightamount`, the
      shape staging AGRIS accepted in the spike described under Consumer
      Guidance.
AC-3: A `NewVoucher` carrying one G/L detail and one freight ticket reference
      serializes both details, so `create_voucher` posts them together.
AC-4: The AGRIS-side voucher rules from the spike are documented in this spec
      as consumer guidance (G1-G6). Documentation only; no test.

## Acceptance Tests

AT1
Given a `FreightTicketReferenceDetail` built with or without a `record_type`
When `record_type` and `to_xml_hash[:@recordtype]` are read
Then both are `'ACPV3'`.
Covers: R2, E1
Examples: `FreightTicketReferenceDetail` `#initialize` and `#to_xml_hash`, contexts
"without any attributes" and "when record_type is passed in the hash".

AT2
Given a `FreightTicketReferenceDetail` built with all four ticket attributes
When `to_xml_hash` is called
Then the keys are exactly `:@inoutcode`, `:@ticketlocation`, `:@ticketnumber`,
`:@freightamount`, `:@recordtype` and each value matches the input.
Covers: R1, R3
Examples: `FreightTicketReferenceDetail` `::ATTRIBUTE_NAMES` and `#to_xml_hash`
"with all four ticket attributes".

AT3
Given a `FreightTicketReferenceDetail` built with all four ticket attributes
When each reader is called
Then it returns the value supplied.
Covers: R4
Examples: `FreightTicketReferenceDetail` `#initialize` "with all four ticket
attributes".

AT4
Given a `NewVoucher` with one `GeneralLedgerDetail` and one
`FreightTicketReferenceDetail` added
When `details` is mapped through `to_xml_hash`
Then two hashes result, in insertion order, with record types `ACPV2` then
`ACPV3`.
Covers: R5
Examples: `NewVoucher` `#add_detail` "with a general ledger detail and a
freight ticket reference".

AT5
Given a `FreightTicketReferenceDetail` built with only `ticket_number`
When readers and `to_xml_hash` are inspected
Then the omitted readers return `nil` and `to_xml_hash` contains only
`:@ticketnumber` and `:@recordtype`.
Covers: E2
Examples: `FreightTicketReferenceDetail` `#initialize` and `#to_xml_hash` "with
only ticket_number".

## Observability
None. The gem is a library; consumers log `PostResult` outcomes.

## Implementation Decisions

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-09-16 | Expose readers via `attr_reader(*ATTRIBUTE_NAMES)`, unlike the two older detail classes. | Matches `NewVoucher` and `NewDisbursement`; consumers need to inspect the detail for logging and tests. Older classes left untouched (non-goal). |
| 2026-09-16 | Do not validate G1-G6 in the gem. | AGRIS is the system of record for these rules and already reports violations in-band; duplicating them would drift. |
| 2026-09-16 | No spec IDs or spec paths in code or test comments. | Coding Style Rules §2.4: code is the source of truth and ticket/requirement references in comments rot. Traceability lives in commit footers, the PR description and this spec's AT list; each AT lists the RSpec examples that prove it. |

## Change Log

| Date | Change | Affected IDs | Rationale |
|------|--------|-------------|-----------|
| 2026-09-16 | `[NEW]` R1-R5, E1-E2, AC-1..AC-4, AT1-AT5, G1-G6 | All | Add ACPV3 freight ticket reference support to `NewVoucher`. |
