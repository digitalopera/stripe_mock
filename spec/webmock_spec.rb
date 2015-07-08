require 'spec_helper'
require 'webmock/rspec'

describe 'StripeMock webmock' do
  describe 'StripeMock.start' do
    it 'should capture stripe requests' do
      StripeMock.start
      Stripe::Transfer.all
      expect(a_request(:get, "https://api.stripe.com/v1/transfers")).to have_been_made.at_least_times(1)
      StripeMock.stop
    end
  end

  describe 'StripeMock.stop' do
    it 'should allow stripe requests' do
      StripeMock.start
      StripeMock.stop
      Stripe::Transfer.all
      expect(a_request(:get, "https://api.stripe.com/v1/transfers")).not_to have_been_made
    end
  end
end
