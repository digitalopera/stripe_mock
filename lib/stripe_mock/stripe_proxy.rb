require 'sinatra/base'
require 'json'

class MockedStripe < Sinatra::Base

  #== TOKENS ===================================================================
  get "/v1/tokens" do
    # json_response StripeMock::Data::charges
  end

  get "/v1/tokens/:id" do
    json_response StripeMock::Data::token id: params[:id]
  end

  post '/v1/tokens' do
    matches = /tok_(\S+)/.match params[:source]
    if !matches.nil? && !matches[1].nil?
      status 402
      card_error = StripeMock.card_failures[matches[1].to_sym]

      json_response({
        error: card_error
      })
    else
      json_response StripeMock::Data::token
    end
  end

  #== CHARGES ==================================================================
  get "/v1/charges" do
    json_response StripeMock::Data::charges
  end

  get "/v1/charges/:id" do
    json_response StripeMock::Data::charge id: params[:id]
  end

  post '/v1/charges' do
    matches = /tok_(\S+)/.match params[:source]
    if !matches.nil? && !matches[1].nil?
      status 402
      card_error = StripeMock.charge_failures[matches[1].to_sym]

      json_response({
        error: {
          message: card_error[:message],
          param: card_error[:param]
        }
      })
    else
      json_response StripeMock::Data::charge
    end
  end

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
