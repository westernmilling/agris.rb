# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Ruby support is expressed through `required_ruby_version` rather than the
version number — see [docs/RELEASING.md](docs/RELEASING.md). Raising that floor
is a breaking change and takes a major bump; adding support for a newer Ruby
takes none.

## [Unreleased]

## [1.2.0] - 2026-09-23

### Added

- `prepayment_type` and `prepayment_reference` on
  `Api::AccountsReceivables::NewPayment`, the `ACRR0` fields that make a
  prepayment receipt expressible alongside a `P` cash source. A payment
  setting neither serializes exactly as before.

## [1.1.0] - 2026-09-22

### Added

- `Api::NewVoucher::FreightTicketReferenceDetail`, the `ACPV3` voucher detail
  that references the grain ticket whose freight an FV voucher pays. AGRIS
  stamps the ticket with the voucher number on import. (#58)

## [1.0.0] - 2026-09-14

First release since `v0.19.0`. The `1.0.0` bump declares the public API stable
and makes semver's major-bump signal available, which `0.x` does not.

### Added

- `Api::AccountsReceivables::Payments`, adding `#create_payment`,
  `#apply_payment` and `#post_payment` to the client, with the `NewPayment`,
  `NewPaymentRemark` and `PaymentPostResult` XML models. (#44)
- `Api::AccountsPayables::Disbursements`, adding `#create_disbursement` to the
  client, with the `NewDisbursement` XML model. (#40)
- `freight_uom` declared on `Api::Grain::NewTicket`. (#43)

### Changed

- **Ruby 3.1 or newer is now required.** The gemspec declares
  `required_ruby_version >= 3.1`; previously it declared no floor at all, so
  the gem could be installed on unsupported Rubies and fail at runtime.
  Applications below 3.1 will resolve to `v0.19.0` and should stay there. (#52)
- **`*_changed_since` methods now take `detail:` as a keyword argument**
  rather than a positional boolean. Calls such as
  `client.orders_changed_since(time, true)` must become
  `client.orders_changed_since(time, detail: true)`. Affects
  `invoices_changed_since`, `purchase_contracts_changed_since`,
  `sales_contracts_changed_since`, `delivery_tickets_changed_since` and
  `orders_changed_since`. (#57)
- Versioning moved to a single line. An earlier scheme encoded the supported
  Ruby in the version number (`0.19.x` for Ruby 3.1, `0.2x` for Ruby 3.3);
  it fought semver and RubyGems has no concept of release lines, always serving
  the highest version as `latest`. `0.20.0` and `0.21.0` were never published
  and are superseded by this release. (#52)

### Fixed

- `Api::PostResult#rejections` no longer raises when a post is processed
  cleanly. A processed post reports an empty `<reject />`, which previously
  produced a `NoMethodError` rather than an empty list. (#44)
- `bundle exec rake` runs to completion again. RuboCop had been unable to run
  at all since the move to Ruby 3.x — it calls the positional
  `Psych.safe_load` signature removed in Psych 4, and rejected any 3.x value in
  `.ruby-version`. Separately, lint offences had accumulated since February
  2024 because nothing was running the linter. (#52)

### Internal

- CI migrated from CircleCI to GitHub Actions, running specs and lint as
  separate jobs so each reports its own status. CircleCI ran specs only, which
  is why the RuboCop breakage went unnoticed across three releases' worth of
  commits. (#52)
- Specs now run against Ruby 3.1, 3.3 and 3.4, so `required_ruby_version` is
  verified rather than asserted. (#53)
- Release process documented in [docs/RELEASING.md](docs/RELEASING.md). (#54)
- RuboCop bumped from 0.54.0 to 1.x, retiring four workarounds that existed
  only to keep a 2018 release running on Ruby 3.x — a `psych` pin and three
  disabled or duplicated configuration entries. Ruby 4.0 added to the CI
  matrix, which a consuming application already runs. (#57)

---

## Earlier releases

Releases up to and including `v0.19.0` predate this changelog. See the
[commit history](https://github.com/westernmilling/agris.rb/commits/master)
and [release tags](https://github.com/westernmilling/agris.rb/tags).

[Unreleased]: https://github.com/westernmilling/agris.rb/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/westernmilling/agris.rb/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/westernmilling/agris.rb/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/westernmilling/agris.rb/compare/v0.19.0...v1.0.0
