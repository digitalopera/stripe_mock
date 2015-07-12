require 'sinatra/base'
require 'json'

class MockedStripe < Sinatra::Base

  #== TRANSFERS ================================================================
  get "/v1/transfers" do
    json_response StripeMock::Data::transfers
  end

  get "/v1/transfers/:id" do
    json_response StripeMock::Data::transfer
  end

  post '/v1/transfers' do
    hash = StripeMock::Data::transfer
    json_response hash
  end

  private #---------------------------------------------------------------------

  def json_response(hash)
    content_type :json
    hash.to_json
  end
end
