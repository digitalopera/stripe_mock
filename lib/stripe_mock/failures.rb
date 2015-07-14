module StripeMock
  class << self
    def transfer_failures
      %w(insufficient_funds account_closed no_account invalid_account_number debit_not_authorized bank_ownership_changed account_frozen could_not_process bank_account_restricted invalid_currency)
    end

    def card_failures
      {
        incorrect_number: {
          message: "Your card number is incorrect.",
          code: 'incorrect_number',
          param: 'number',
          type: 'card_error'
        },
        invalid_number: {
          message: "This card number looks invalid.",
          code: 'invalid_number',
          param: 'number',
          type: 'card_error'
        },
        invalid_expiry_month: {
          message: "Your card's expiration month is invalid.",
          code: 'invalid_expiry_month',
          param: 'exp_month',
          type: 'card_error'
        },
        invalid_expiry_year: {
          message: "Your card's expiration year is invalid.",
          code: 'invalid_expiry_year',
          param: 'exp_year',
          type: 'card_error'
        },
        invalid_cvc: {
          message: "Your card's security code is invalid.",
          code: 'invalid_cvc',
          param: 'cvc',
          type: 'card_error'
        },
        expired_card_month: {
          message: "Your card's expiration month is invalid.",
          code: 'invalid_expiry_month',
          param: 'exp_month',
          type: 'card_error'
        },
        expired_card_year: {
          message: "Your card's expiration year is invalid.",
          code: 'invalid_expiry_year',
          param: 'exp_year',
          type: 'card_error'
        },
        incorrect_zip: {
          message: "The card's postal code is incorrect",
          code: 'incorrect_zip',
          param: 'zip',
          type: 'card_error'
        }
      }
    end

    def charge_failures
      {
        incorrect_cvc: {
          message: "Your card's security code is incorrect.",
          code: 'incorrect_cvc',
          param: 'cvc',
          type: 'card_error',
          charge: 'ch_xxx'
        },
        incorrect_zip: {
          message: "The zip code you supplied failed validation.",
          code: 'incorrect_zip',
          param: 'address_zip',
          type: 'card_error',
          charge: 'ch_xxx'
        },
        card_declined: {
          message: "Your card was declined.",
          code: 'card_declined',
          type: 'card_error',
          charge: 'ch_xxx'
        },
        missing: {
          message: "Cannot charge a customer that has no active card",
          code: 'missing',
          param: 'card',
          type: 'card_error'
        },
        processing_error: {
          message: "An error occurred while processing your card. Try again in a little bit.",
          code: 'processing_error',
          type: 'card_error',
          charge: 'ch_xxx'
        }
      }
    end
  end
end
