# CLAUDE.md — Project Configuration

## Product Context
- **Product name:** agris (Ruby gem)
- **Primary user/persona:** Ruby application developers at Western Milling (and downstream consumers) who integrate with the Agris ERP Web Services SOAP API.
- **Problem statement:** Agris exposes its ERP data (grain contracts/tickets, inventory orders, delivery tickets, AR invoices, AP vouchers, commodity codes, document tracking) through a single SOAP `ProcessMessage` endpoint. This gem wraps that endpoint with a typed Ruby client so consumers don't construct/parse XML by hand.
- **Non-goals:**
  - Not a Rails engine — pure library, no UI or persistence.
  - Not a generic SOAP client — only models the Agris message catalog.
  - Does not host or proxy Agris itself; callers supply their own endpoint, dataset, and credentials.

## Stack and Dependencies
- **Languages/frameworks:** Ruby (target `2.4`, per `.rubocop.yml`; CI image `circleci/ruby:2.4.1`).
- **Key applications/packages:**
  - Runtime: `savon ~> 2.11` (SOAP client).
  - Dev/test: `rspec ~> 3.0`, `rspec_junit_formatter ~> 0.4.1`, `webmock ~> 2.3`, `simplecov 0.17`, `rubocop 0.54.0`, `pry-byebug`, `rake ~> 12.3.3`, `bundler ~> 2.3.7`.
- **Data layer:** None local. Remote system of record is the Agris ERP database, accessed via its SOAP `ProcessMessage` endpoint (see `lib/agris/savon_request.rb` and `lib/agris/process_message_response.rb`).
- **Build command:** `bundle install` (or `bin/setup`).
- **Test command:** `bundle exec rspec` (or `bundle exec rake spec`).
- **Lint command:** `bundle exec rubocop`.
- **Dev server command:** N/A (library). For interactive exploration: `bin/console` (boots IRB with the gem loaded).

## Verification Commands
- **Run tests:** `bundle exec rspec`
- **Run linter:** `bundle exec rubocop`
- **Type check:** N/A (no Sorbet/RBS in this project)
- **Run everything (default rake):** `bundle exec rake` — runs `spec` then `rubocop`.

## Domain Glossary
Define key business terms unique to this project so agents use correct terminology.

| Term | Definition |
|------|-----------|
| Agris | Third-party agribusiness ERP. All API messages target this system. |
| Dataset | Agris tenancy/company identifier (e.g., `'001'`). Required as a keyword arg on every `Agris::Client.new`; scopes all requests. |
| Context | `Agris::Context` — endpoint config bundle: base URL, default dataset, dataset path, database name, user, password. |
| Credentials | `Agris::Credentials::Anonymous` or `Agris::Credentials::BasicAuth` — auth strategy passed to the underlying request. |
| ProcessMessage | The single SOAP operation Agris exposes; every API call serializes a typed request XML and parses a typed response XML through it. |
| Request type | Pluggable transport (`Agris::SavonRequest`). Selected via `Agris.request_type`. |
| XmlModel | `Agris::XmlModel` — base class for declarative request/response XML payloads used across `lib/agris/api/**`. |
| Grain module | `Agris::Api::Grain::*` — tickets, contracts (purchase/sales), commodity codes, grade factors, rates. |
| Inventory module | `Agris::Api::Inventory::*` — delivery tickets and orders. |
| Voucher / Invoice | AP voucher (`Api::AccountsPayables`) and AR invoice (`Api::AccountsReceivables`) postings. |
| Messages module | `Api::Messages::*` — document-tracking and "changed since" queries (invoices, sales contracts, delivery tickets, orders, commodity-code documents). |

## Local Development Setup
- **Prerequisites:** Ruby 2.4.x and Bundler 2.3.x. CI pins `circleci/ruby:2.4.1`; newer Ruby versions may work but are unverified.
- **Install steps:**
  1. `git clone git@github.com:westernmilling/agris.rb.git`
  2. `cd agris.rb`
  3. `bin/setup` (runs `bundle install`)
- **How to run locally:** This is a library — no server. Use `bin/console` to load the gem in IRB and exercise the client interactively.
- **How to seed data:** N/A. Tests use fixture XML under `spec/fixtures/agris/**` (stubbed via WebMock); they do not require a live Agris endpoint.
- **How to run tests:** `bundle exec rspec` (full suite), `bundle exec rspec spec/lib/agris/client/grain/purchase_contracts_spec.rb` (one file), or `bundle exec rake` (specs + rubocop).
- **Key URLs:**
  - Repo: https://github.com/westernmilling/agris.rb
  - CI: CircleCI (config at `.circleci/config.yml`).
  - Coverage / quality: Code Climate (badges in `README.md`; config in `.codeclimate.yml`).

## Common Gotchas
- **Ruby 2.4 target.** Rubocop's `TargetRubyVersion` is `2.4`. Avoid syntax/stdlib introduced after 2.4 unless you are intentionally bumping the floor.
- **Rubocop 0.54.0 is pinned and old.** Many newer cops do not exist; `.rubocop_todo.yml` carries existing exemptions. Don't auto-correct broadly without running the full suite afterward.
- **`Agris::HTTPartyRequest` is autoloaded but the file is not present** in `lib/agris/`. Only `SavonRequest` is implemented — configure `Agris.request_type = Agris::SavonRequest`. The dangling autoload is a known wart.
- **`dataset:` is keyword-required on `Client.new`.** `Agris::Client.new(dataset: '001')` — forgetting the keyword raises `ArgumentError`.
- **All requests funnel through Agris's single `ProcessMessage` SOAP op.** Errors come back in-band as `<MessageStatus>` payloads (see `lib/agris/process_message_response.rb`), not as HTTP errors. Inspect `ApiError` / `MessageError` / `SystemError` / `UnknownError` raised from the client.
- **Fixtures are XML, sometimes paired with JSON snapshots.** When adding a new endpoint, add both request and response fixtures under `spec/fixtures/agris/<area>/`.
- **`lib/hash.rb` monkey-patches core `Hash`.** Be careful when refactoring helpers — they may be in use across XML models.
- **Released to RubyGems as `agris`.** Bumping `lib/agris/version.rb` and running `bundle exec rake release` will tag, push, and publish. Do not run `rake release` casually.

## Integrations
- **Jira project key:** _Not configured for this repo._ <!-- Fill in if/when this gem is tracked in Jira; used for branch naming and issue linking. -->
- **Staging URL:** N/A (library, no deployed environment).
- **CI pipeline:** CircleCI 2.0 — `.circleci/config.yml`. Runs `bundle exec rspec` with JUnit output and uploads coverage to Code Climate via `cc-test-reporter`.

## Project Overrides
Rules here override global CLAUDE.md rules for this project.

### Architecture Rules
- **Layering rules:**
  - `lib/agris.rb` — module-level configuration (`Agris.configure`) and autoloads.
  - `lib/agris/client.rb` — single entry point; mixes in API modules from `lib/agris/api/**`.
  - `lib/agris/api/<area>/<resource>.rb` — one Ruby module per Agris message; defines request building and response parsing using `XmlModel`.
  - `lib/agris/{savon_request,process_message_response,context,credentials,...}.rb` — transport, response envelope, config primitives.
  - Add new endpoints by creating a module under the appropriate `api/<area>/` namespace and including it in `Client`.
- **Dependency boundaries:**
  - API modules must not call `Savon` directly — go through the configured `request_type`.
  - Keep XML construction inside `XmlModel` subclasses, not inline in client methods.
  - No Rails / ActiveSupport assumptions — this is a plain Ruby gem.
- **Error-handling conventions:**
  - Surface Agris failures as one of the existing `Agris::*Error` classes defined in `lib/agris.rb`. Don't introduce new error hierarchies without discussion.
  - Don't rescue and swallow inside API modules; let the caller decide.

### Delivery Rules
- **Branch strategy:** Trunk-based off `master`. Feature branches per change; PRs target `master`.
- **PR size policy:** ~200 LOC per PR, one testable behavior. RSpec coverage required for behavior changes; map specs to acceptance criteria when specs exist under `docs/specs/`.

### Model Overrides
_None._
