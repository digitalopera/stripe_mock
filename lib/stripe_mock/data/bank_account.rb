module StripeMock
  module Data
    def self.bank_account(params={})
      {
        object: 'bank_account',
        id: StripeMock.new_id('ba'),
        last4: '6789',
        country: 'US',
        currency: 'usd',
        status: 'new',
        fingerprint: nil,
        routing_number: Faker::Number.number(9).to_s,
        bank_name: 'STRIPE TEST BANK'
      }.merge(params)
    end
  end
end
