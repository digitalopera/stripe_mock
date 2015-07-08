require 'webmock'

module StripeMock
  WebMock::API.stub_request(:any, /https:\/\/api\.stripe\.com/).to_rack(MockedStripe)

  def self.start
    WebMock.enable!
  end

  def self.stop
    WebMock.disable!
  end
end
