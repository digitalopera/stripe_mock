require 'spec_helper'
require 'webmock/rspec'

describe 'StripeMock webmock' do
  describe 'StripeMock.start' do
    it 'should capture stripe requests' do
      StripeMock.capture_requests
      Stripe::Transfer.all
      expect(a_request(:get, "https://api.stripe.com/v1/transfers")).to have_been_made.at_least_times(1)
    end
  end
end
