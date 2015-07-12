module StripeMock
  class << self
    def transfer_failures
      %w(insufficient_funds account_closed no_account invalid_account_number debit_not_authorized bank_ownership_changed account_frozen could_not_process bank_account_restricted invalid_currency)
    end
  end
end
