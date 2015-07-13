require 'spec_helper'
require 'shared_examples/transfer'

describe 'StripeMock Transfers' do
  before(:each) do
    StripeMock.capture_requests
  end
  
  describe 'get transfers' do
    let(:transfers){ Stripe::Transfer.all }

    it 'should return a list of transfers' do
      expect(transfers).to be_is_a(Stripe::ListObject)
      expect(transfers.data.first).to be_is_a(Stripe::Transfer)
    end

    describe 'the list of transfers' do
      it_should_behave_like 'a transfer' do
        let(:transfer){ transfers.data.first }
      end

      it 'should have 2 transfers' do
        expect(transfers.data.size).to eq 2
      end
    end
  end

  describe 'get transfer/:id' do
    it_should_behave_like 'a transfer' do
      let(:transfer){ Stripe::Transfer.retrieve(StripeMock.new_id('_tr')) }
    end

    it 'should return the id supplied' do
      id = StripeMock.new_id('_tr')
      expect(Stripe::Transfer.retrieve(id).id).to eq id
    end

    context 'when a transfer failure occured' do
      context 'when insufficient_funds' do
        it 'should return "insufficient_funds" for "failure_code"' do
          expect(Stripe::Transfer.retrieve('insufficient_funds').failure_code).to eq 'insufficient_funds'
        end
      end

      context 'when account_closed' do
        it 'should return "account_closed" for "failure_code"' do
          expect(Stripe::Transfer.retrieve('account_closed').failure_code).to eq 'account_closed'
        end
      end

      context 'when no_account' do
        it 'should return "no_account" for "failure_code"' do
          expect(Stripe::Transfer.retrieve('no_account').failure_code).to eq 'no_account'
        end
      end

      context 'when invalid_account_number' do
        it 'should return "invalid_account_number" for "failure_code"' do
          expect(Stripe::Transfer.retrieve('invalid_account_number').failure_code).to eq 'invalid_account_number'
        end
      end

      context 'when debit_not_authorized' do
        it 'should return "debit_not_authorized" for "failure_code"' do
          expect(Stripe::Transfer.retrieve('debit_not_authorized').failure_code).to eq 'debit_not_authorized'
        end
      end

      context 'when bank_ownership_changed' do
        it 'should return "bank_ownership_changed" for "failure_code"' do
          expect(Stripe::Transfer.retrieve('bank_ownership_changed').failure_code).to eq 'bank_ownership_changed'
        end
      end

      context 'when account_frozen' do
        it 'should return "account_frozen" for "failure_code"' do
          expect(Stripe::Transfer.retrieve('account_frozen').failure_code).to eq 'account_frozen'
        end
      end

      context 'when could_not_process' do
        it 'should return "could_not_process" for "failure_code"' do
          expect(Stripe::Transfer.retrieve('could_not_process').failure_code).to eq 'could_not_process'
        end
      end

      context 'when bank_account_restricted' do
        it 'should return "bank_account_restricted" for "failure_code"' do
          expect(Stripe::Transfer.retrieve('bank_account_restricted').failure_code).to eq 'bank_account_restricted'
        end
      end

      context 'when invalid_currency' do
        it 'should return "invalid_currency" for "failure_code"' do
          expect(Stripe::Transfer.retrieve('invalid_currency').failure_code).to eq 'invalid_currency'
        end
      end
    end
  end

  describe 'post transfers' do
    it_should_behave_like 'a transfer' do
      let(:transfer){ Stripe::Transfer.create }
    end
  end
end
