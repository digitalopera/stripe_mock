$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "stripe"
Stripe.api_key = 'sk_test_DG9jhMEC44K3GkcAvgq6X37L'
require 'stripe_mock'
require 'faker'

RSpec.configure do |c|
  c.before(:each) do
    StripeMock.start
    StripeMock::Session.clear
  end

  c.after(:each) do
    StripeMock.stop
  end
end
