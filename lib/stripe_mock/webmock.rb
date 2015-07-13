require 'webmock'

module StripeMock
  def self.capture_requests
    WebMock::API.stub_request(:any, /https:\/\/api\.stripe\.com/).to_rack(MockedStripe)
  end
end
