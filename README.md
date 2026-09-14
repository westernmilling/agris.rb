[![Code Climate](https://codeclimate.com/github/westernmilling/agris.rb/badges/gpa.svg)](https://codeclimate.com/github/westernmilling/agris.rb)
[![Test Coverage](https://codeclimate.com/github/westernmilling/agris.rb/badges/coverage.svg)](https://codeclimate.com/github/westernmilling/agris.rb/coverage)

# Agris

Agris Web Services client library.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'agris'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install agris

## Usage

```ruby
Agris.configure do |config|
  config.credentials = Agris::Credentials::Anonymous.new
  config.context = Agris::Context.new(
    'http://localhost:3000',
    '001',
    '\\host\apps\Agris\datasets',
    'AgrisDB',
    'bob',
    'fred'
  )
  config.request_type = Agris::SavonRequest
  config.logger = Logger.new(STDOUT)
  config.user_agent = 'Otis'
end
```

elsewhere

```ruby
client = Agris::Client.new
```

Enjoy!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. For releases, see [Releasing](#releasing) below.

## Releasing

The gem is published to RubyGems as `agris`. Two version lines are maintained
in parallel for different Ruby versions, and `rake release` tags, pushes and
publishes in one irreversible step — see [docs/RELEASING.md](docs/RELEASING.md)
before cutting a release.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/westernmilling/agris.
