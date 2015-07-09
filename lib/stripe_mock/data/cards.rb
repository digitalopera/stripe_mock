module StripeMock
  module Data
    def self.card(params={})
      {
        id: StripeMock.new_id('card'),
        object: "card",
        last4: Faker::Number.number(4).to_s,
        brand: "Visa",
        funding: "credit",
        exp_month: Faker::Number.between(1, 12),
        exp_year: (Date.today.year + 1),
        fingerprint: Faker::Internet.password(16),
        country: "US",
        name: Faker::Name.name,
        address_line1: Faker::Address.street_address,
        address_line2: nil,
        address_city: Faker::Address.city,
        address_state: Faker::Address.state_abbr,
        address_zip: Faker::Address.postcode,
        address_country: nil,
        cvc_check: 'pass',
        address_line1_check: 'pass',
        address_zip_check: 'pass',
        tokenization_method: nil,
        dynamic_last4: nil,
        metadata: {},
        customer: nil
      }.merge(params)
    end
  end
end
