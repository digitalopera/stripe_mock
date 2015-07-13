module StripeMock
  module Data
    def self.charge(params={})
      id = params[:id] || StripeMock.new_id('ch')

      {
        id: id,
        object: "charge",
        created: Faker::Date.backward(2).to_time.to_i,
        livemode: false,
        paid: true,
        status: 'succeeded',
        amount: Faker::Number.number(4),
        currency: "usd",
        refunded: false,
        source: StripeMock::Data.card,
        captured: true,
        balance_transaction: StripeMock.new_id('txn'),
        failure_message: nil,
        failure_code: nil,
        amount_refunded: 0,
        customer: nil,
        invoice: nil,
        description: "For items ordered on my kick ass app",
        dispute: nil,
        metadata: {},
        statement_descriptor: 'MY APP',
        fraud_details: {},
        receipt_email: nil,
        shipping: nil,
        destination: nil,
        application_fee: nil,
        refunds: {
          object: "list",
          total_count: 0,
          has_more: false,
          url: "/v1/charges/#{ id }/refunds",
          data: []
        }
      }.merge(params)
    end

    def self.charges(params={})
      {
        object: 'list',
        url: '/v1/charges',
        has_more: false,
        data: [charge, charge]
      }.merge(params)
    end
  end
end
