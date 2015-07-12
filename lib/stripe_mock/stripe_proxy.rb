require 'sinatra/base'
require 'json'

class MockedStripe < Sinatra::Base

  #== TRANSFERS ================================================================
  get "/v1/transfers" do
    json_response StripeMock::Data::transfers
  end

  get "/v1/transfers/:id" do
    transfer_overrides = {
      id: params[:id]
    }

    if StripeMock.transfer_failures.include?( params[:id] )
      transfer_overrides[:failure_code] = params[:id]
    end
    json_response StripeMock::Data::transfer transfer_overrides
  end

  post '/v1/transfers' do
    json_response StripeMock::Data::transfer
  end

  private #---------------------------------------------------------------------

  def json_response(hash)
    content_type :json
    hash.to_json
  end
end
