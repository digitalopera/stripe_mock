require 'spec_helper'
require 'shared_examples/transfer'

describe 'StripeMock BalanceTransactions' do
  before(:each) do
    StripeMock.capture_requests
  end

  describe '/balance/history' do
    let(:transactions){ Stripe::BalanceTransaction.all }

    it 'should return a list of transfers' do
      expect(transactions).to be_is_a(Stripe::ListObject)
      expect(transactions.data.first).to be_is_a(Stripe::BalanceTransaction)
    end

    describe 'JSON structure' do
      it 'should have matching root keys as mocked data' do
        expect(transactions.keys.sort).to eq StripeMock::Data.balance_transactions.keys.sort
      end

      it 'should have matching balance transaction keys as mocked data' do
        expect(transactions.data.first.keys.sort).to eq StripeMock::Data.balance_transaction.keys.sort
      end
    end
  end
end
