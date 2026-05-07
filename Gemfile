# frozen_string_literal: true
source 'https://rubygems.org'

# Pin rack < 3 because rack 3+ requires Ruby 3+, but this gem targets
# Ruby 2.4 (CircleCI image: circleci/ruby:2.4.1). httpi pulls rack as a
# transitive dependency without a version constraint, so without this
# pin bundler resolves to rack 3.x and CI specs fail to load with
# `TypeError: wrong element type String at 0 (expected array)` from
# `Rack::Utils#to_h`.
gem 'rack', '< 3'

# Specify your gem's dependencies in agris.gemspec
gemspec
