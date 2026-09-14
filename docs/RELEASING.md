# Releasing agris

The gem is published to [rubygems.org](https://rubygems.org/gems/agris) as `agris`.

Releases are cut with `bundle exec rake release`, which tags, pushes and
publishes in a single irreversible step. Read [What `rake release` actually
does](#what-rake-release-actually-does) before running it.

## Version lines

Two lines are maintained in parallel, because the gem supports consumers on
different Ruby versions:

| Line | Released from | Ruby | Purpose |
|------|---------------|------|---------|
| `0.19.x` | `ruby-3.1` | 3.1 | For consuming applications on Ruby 3.1. Declares `required_ruby_version >= 3.1`. |
| `0.2x.y` | `master` | 3.3 | Trunk line. Declares no Ruby floor. |

`v0.19.0` is the most recent tag on the published line.

### ⚠️ Higher version numbers win, regardless of line

RubyGems serves the **highest version number** as `latest`, with no concept of
release lines. Publishing `0.21.0` from `master` after `0.19.2` from `ruby-3.1`
makes `0.21.0` the default install — and because the `master` line declares no
`required_ruby_version`, that would silently remove the Ruby 3.1 floor for
everyone.

Before publishing from either line, check what the other line has already
published:

```sh
gem list agris --remote --all
```

If the two lines are going to coexist long-term, consumers on the `0.19.x` line
should pin it explicitly:

```ruby
gem 'agris', '~> 0.19.0'
```

## Pre-release checklist

1. **Be on the right branch**, with everything merged that you intend to ship.
   `rake release` tags and pushes whatever branch you are standing on.
2. **Working tree is clean.** `rake release` aborts otherwise — it will not
   quietly release uncommitted work.
3. **Full suite is green:**
   ```sh
   bundle exec rake        # specs + rubocop
   ```
4. **Version is bumped** in `lib/agris/version.rb`, and the bump is committed.
   Follow semver: new API is a minor bump, not a patch.
5. **The tag does not already exist.** `rake release` skips tagging if it does,
   which can publish a gem whose tag points somewhere unexpected.
   ```sh
   git tag --list 'v*' | sort -V | tail
   ```
6. **RubyGems credentials are present** — see [Credentials](#credentials).

## Cutting the release

```sh
git checkout <release-branch>
git pull
# bump lib/agris/version.rb, commit
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

Steps 5 and 6 reach outside the repository. Step 6 in particular is effectively
permanent.

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

## If a release goes wrong

A published version can be yanked, but the version number is **burned
permanently** — it can never be reused:

```sh
gem yank agris -v <version>
```

Yanking removes it from resolution for new installs; it does not recall it from
anyone who already has it. Prefer releasing a fixed higher version over yanking
wherever possible.
