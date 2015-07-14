module StripeMock
  module Data
    def self.token(params={})
      {
        id: StripeMock.new_id('tok'),
        livemode: false,
        created: Faker::Date.backward(2).to_time.to_i,
        used: false,
        object: "token",
        type: 'card',
        card: {
          id: StripeMock.new_id('card'),
          object: 'card',
          last4: Faker::Number.number(4).to_s,
          brand: 'Visa',
          funding: 'credit',
          exp_month: Faker::Number.between(1, 12),
          exp_year: (Date.today.year + 1),
          country: 'US',
          name: Faker::Name.name,
          address_line1: Faker::Address.street_address,
          address_line2: nil,
          address_city: Faker::Address.city,
          address_state: Faker::Address.state_abbr,
          address_zip: Faker::Address.postcode,
          address_country: nil,
          cvc_check: nil,
          address_line1_check: nil,
          address_zip_check: nil,
          tokenization_method: nil,
          dynamic_last4: nil,
          metadata: {}
        },
        client_ip: nil
      }.merge(params)
    end
  end
end
