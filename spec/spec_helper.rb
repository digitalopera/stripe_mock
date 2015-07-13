$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "stripe"
require 'stripe_mock'
require 'faker'
require 'vcr'

# Load Stripe key from ENV
require 'dotenv'
Dotenv.load
Stripe.api_key = ENV['STRIPE_API_KEY']
Stripe.api_version = "2015-07-07"

RSpec.configure do |c|
  c.filter_run :focus
  c.run_all_when_everything_filtered = true

  c.after(:each) do
    WebMock.reset!
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
