require 'sinatra/base'
require 'json'

class MockedStripe < Sinatra::Base

  #== TRANSFERS ================================================================
  get "/v1/transfers" do
    json_response StripeMock::Data::Transfers.transfers
  end

  get "/v1/transfers/:id" do
    json_response StripeMock::Session.find('transfers', params[:id])
  end

  post '/v1/transfers' do
    hash = StripeMock::Data::Transfers.transfer(converted_params)
    add_to_collection hash, 'transfers'
    json_response hash
  end

  private #---------------------------------------------------------------------

  def converted_params
    StripeMock.convert_hash_values_to_i params
  end

  def json_response(hash)
    content_type :json
    hash.to_json
  end

  def add_to_collection(hash, collection)
    StripeMock::Session.send(collection) << hash
  end
end
