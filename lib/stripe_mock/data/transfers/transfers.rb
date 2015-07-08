module StripeMock
  module Data
    module Transfers
      def self.transfer(params={})
        id = params[:id] || StripeMock.new_id('tr')
        bank_account_id = StripeMock.new_id('ba')

        {
          id: id,
          object: "transfer",
          created: Faker::Date.backward(2).to_time.to_i,
          date: Date.today.to_time.to_i,
          livemode: false,
          amount: 100,
          currency: "usd",
          reversed: false,
          status: 'paid',
          type: 'bank_account',
          reversals: {
            object: "list",
            total_count: 0,
            has_more: false,
            url: "/v1/transfers/#{id}/reversals",
            data: []
          },
          balance_transaction: StripeMock.new_id('txn'),
          bank_account: StripeMock::Data::BankAccount.bank_account(id: bank_account_id),
          destination: bank_account_id,
          description: 'STRIPE TRANSFER',
          failure_message: nil,
          failure_code: nil,
          amount_reversed: 0,
          metadata: {},
          statement_descriptor: nil,
          recipient: nil,
          source_transaction: nil,
          application_fee: nil
        }.merge(params)
      end

      def self.transfers(params={})
        {
          object: 'list',
          url: '/v1/transfers',
          has_more: false,
          data: StripeMock::Session.transfers
        }
      end
    end
  end
end
