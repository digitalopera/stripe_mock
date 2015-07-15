module StripeMock
  module CreditCards
    class << self
      BAD_CARDS = [
        {
          exp_month: '0',
          code: :invalid_expiry_month
        },
        {
          exp_year: '0',
          code: :invalid_expiry_year
        },
        {
          number: '4242424242424241',
          code: :incorrect_number
        },
        {
          number: '4000000000000002',
          code: :card_declined
        },
        {
          number: '4000000000000127',
          code: :incorrect_cvc
        },
        {
          number: '4000000000000119',
          code: :processing_error
        },
        {
          number: 'asdf',
          code: :invalid_number
        },
        {
          cvc: '0',
          code: :invalid_cvc
        }
      ]

      def card_number_by_code(code)
        attr_value_by_code(:number, code)
      end

      def attr_value_by_code(type, code)
        BAD_CARDS.detect do |hash|
          code == hash[:code]
        end[type.to_sym]
      end

      def is_erroneous?(card_hash)
        !card_error(card_hash).nil?
      end

      def card_error(card_hash)
        hash = BAD_CARDS.detect do |hash|
          hash.keys.any? do |key|
            !card_hash[key].nil? && card_hash[key] == hash[key]
          end
        end

        unless hash.nil?
          StripeMock.card_failures[hash[:code]]
        end
      end
    end
  end
end
