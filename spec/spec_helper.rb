$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "stripe"
require 'stripe_mock'
require 'faker'

# Load Stripe key from ENV
require 'dotenv'
Dotenv.load
Stripe.api_key = ENV['STRIPE_API_KEY']

RSpec.configure do |c|
  c.before(:each) do
    StripeMock.start
  end

  c.after(:each) do
    StripeMock.stop
  end
end
