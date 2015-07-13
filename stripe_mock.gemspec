# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stripe_mock/version'

Gem::Specification.new do |spec|
  spec.name          = "stripe_mock"
  spec.version       = StripeMock::VERSION
  spec.authors       = ["Grant Klinsing"]
  spec.email         = ["grant@digitalopera.com"]

  spec.summary       = %q{Mocking Library for Stripe}
  spec.description   = %q{Mimic Stripe calls without hitting Stripe's servers}
  spec.homepage      = "https://github.com/digitalopera/stripe_mock"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'sinatra',       '~> 1.4.6'
  spec.add_dependency 'webmock',       '~> 1.20.0'
  spec.add_dependency "json",          '~> 1.8.3'

  spec.add_development_dependency "bundler",     "~> 1.10"
  spec.add_development_dependency "rake",        "~> 10.0"
  spec.add_development_dependency "rspec",       "~> 3.1.0"
  spec.add_development_dependency "guard-rspec", "~> 4.6.0"
  spec.add_development_dependency "faker",       "~> 1.4.3"
  spec.add_development_dependency "stripe",      "~> 1.23.0"
  spec.add_development_dependency "dotenv-rails", "~> 2.0.2"
  spec.add_development_dependency "vcr",         "~> 2.9.3"
end
