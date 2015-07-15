module StripeMock
  def self.capture_requests
    require 'webmock'

    WebMock.allow_net_connect!
    WebMock::API.stub_request(:any, /https:\/\/api\.stripe\.com/).to_rack(MockedStripe)
  end

  def self.stop_capturing
    WebMock.reset!
  end
end
