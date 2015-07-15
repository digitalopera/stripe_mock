module StripeMock
  module Data
    def self.balance_transaction(params={})
      source_id = params[:source] || StripeMock.new_id('tr')
      {
        id: StripeMock.new_id('txn'),
        object: 'balance_transaction',
        amount: -18982,
        currency: 'usd',
        net: -18982,
        type: 'transfer',
        created: Faker::Date.backward(2).to_time.to_i,
        available_on: Faker::Date.backward(1).to_time.to_i,
        status: 'available',
        fee: 0,
        fee_details: [],
        source: source_id,
        description: 'STRIPE TRANSFER',
        sourced_transfers: {
          object: 'list',
          total_count: 0,
          has_more: false,
          url: "/v1/transfers?source_transaction=#{ source_id }",
          data: []
        }
      }.merge(params)
    end

    def self.balance_transactions(params={})
      {
        object: 'list',
        url: '/v1/balance/history',
        has_more: false,
        data: [balance_transaction, balance_transaction({
          type: 'charge',
          amount: 37621,
          net: 36000,
          fee: 1621,
          fee_details: [
            {
              amount: 1121,
              currency: "usd",
              type: "stripe_fee",
              description: "Stripe processing fees",
              application: nil
            },
            {
              amount: 500,
              currency: "usd",
              type: "application_fee",
              description: "MY APP application fee",
              application: "ca_xxx"
            }
          ]
        })]
      }.merge(params)
    end
  end
end
