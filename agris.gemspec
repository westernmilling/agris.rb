# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'agris/version'

Gem::Specification.new do |spec|
  spec.name = 'agris'
  spec.version = Agris::VERSION
  spec.authors = ['John Gray', 'Joseph Bridgwater-Rowe']
  spec.email = ['wopr42@gmail.com', 'freakyjoe@gmail.com']

  spec.summary = 'Ruby client library for Agris API'
  spec.homepage = 'https://github.com/westernmilling/agris.rb'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'savon', '~> 2.11'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.49.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'webmock', '~> 2.3'
  spec.add_development_dependency 'pry-byebug'
end
