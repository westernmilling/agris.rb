# Releasing agris

The gem is published to [rubygems.org](https://rubygems.org/gems/agris) as `agris`.

Releases are cut with `bundle exec rake release`, which tags, pushes and
publishes in a single irreversible step. Read [What `rake release` actually
does](#what-rake-release-actually-does) before running it.

## Versioning

**One version line, released from `master`.** The version number follows
[Semantic Versioning](https://semver.org/spec/v2.0.0.html) and describes the
**API** — not which Ruby the gem supports.

Ruby support is expressed in the gemspec instead:

```ruby
spec.required_ruby_version = '>= 3.1'
```

Bundler's resolver does the rest. An application on Ruby 3.1 resolves to the
newest version whose floor it satisfies; one on 3.4 resolves to the newest
version outright. There is no need for parallel release lines, and consumers do
not need to pin a version to stay on a supported Ruby.

> This replaced an earlier scheme that encoded the supported Ruby in the version
> number (`0.19.x` for Ruby 3.1, `0.2x` for Ruby 3.3). It fought semver — the
> version had to step *backwards* at one point — and RubyGems has no concept of
> release lines anyway: it always serves the highest version as `latest`.

### How Ruby changes map to versions

| Change | Version impact |
|--------|----------------|
| **Adding** support for a newer Ruby (3.5, 4.x) | **None.** Add it to the CI matrix. Patch release only if fixes were needed. |
| **Dropping** support for an older Ruby (raising `required_ruby_version`) | **Breaking** — major bump. |

Everything else is ordinary semver on the public API.

Raising the floor is breaking because applications that could install the gem
yesterday cannot today. Do it deliberately, in its own release.

### Keep the floor honest

`.github/workflows/ci.yml` runs the suite across **floor, current and next** —
currently 3.1, 3.3 and 3.4. If you change `required_ruby_version`, change the
matrix in the same PR, or the declared floor becomes a claim nothing tests.

Note that the matrix job names are required status checks on `master`
(`test (3.1)`, `test (3.3)`, `test (3.4)`, `lint`). Changing the matrix changes
those names, so branch protection must be updated to match — otherwise every
PR blocks on a check that can never report.

## Pre-release checklist

1. **Be on `master`**, up to date, with everything merged that you intend to
   ship. `rake release` tags and pushes whatever branch you are standing on —
   it does not check.
2. **Working tree is clean.** `rake release` aborts otherwise.
3. **Full suite is green:**
   ```sh
   bundle exec rake        # specs + rubocop
   ```
4. **Version is bumped** in `lib/agris/version.rb`, and the bump is committed.
5. **`required_ruby_version` is correct** for what you are shipping, and the CI
   matrix covers it.
6. **The tag does not already exist:**
   ```sh
   git tag --list 'v*' | sort -V | tail
   ```
7. **RubyGems credentials are present** — see [Credentials](#credentials).

## Cutting the release

```sh
git checkout master
git pull
# bump lib/agris/version.rb, commit, and merge via PR
bundle exec rake                 # confirm green
bundle exec rake release
```

If your account has MFA enabled, `gem push` prompts for an OTP code partway
through — do not walk away from the terminal.

## What `rake release` actually does

Provided by `bundler/gem_tasks`. In order:

1. **Guards the working tree** — aborts with "There are files that need to be
   committed first" if anything is modified or staged.
2. **Checks whether `v<version>` is already tagged** — if so, skips tagging and
   continues to publish anyway.
3. **Creates the tag** — `git tag -m "Version <version>" v<version>`.
4. **Builds the gem** into `pkg/agris-<version>.gem`.
5. **Pushes to git** — the **current branch** and the new tag, to that branch's
   configured remote (`origin` by default).
6. **Publishes to rubygems.org** — `gem push pkg/agris-<version>.gem`.

Steps 5 and 6 reach outside the repository. Step 6 is effectively permanent.

If tagging succeeds but a later step fails, the tag is removed automatically.
If the *push* succeeds and publishing fails, the tag is already public — delete
it manually before retrying:

```sh
git tag -d v<version>
git push origin :refs/tags/v<version>
```

## Credentials

`gem push` reads `~/.gem/credentials`. If you have never pushed from this
machine:

```sh
gem signin
```

The gemspec sets no `allowed_push_host`, so pushes go to rubygems.org. You must
be an owner of the `agris` gem — check with `gem owner agris`.

## After releasing

```sh
gem list agris --remote --all      # new version is listed
git ls-remote --tags origin        # tag reached the remote
```

Confirm the published gem declares the Ruby floor you expect:

```sh
gem specification agris -r required_ruby_version
```

## If a release goes wrong

A published version can be yanked, but the version number is **burned
permanently** — it can never be reused:

```sh
gem yank agris -v <version>
```

Yanking removes it from resolution for new installs; it does not recall it from
anyone who already has it. Prefer releasing a fixed higher version over yanking
wherever possible.
