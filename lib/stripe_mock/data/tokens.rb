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
        card: StripeMock::Data.card,
        client_ip: nil
      }.merge(params)
    end
  end
end
