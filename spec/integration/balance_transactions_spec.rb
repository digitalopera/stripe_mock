require 'spec_helper'

describe 'Stripe::BalanceTransaction', :vcr do
  describe 'Stripe::BalanceTransaction.all' do
    let(:transfer) do
      transfer = nil
      VCR.use_cassette("transfers/all") do
        transfers = Stripe::Transfer.all(limit: 2)

        VCR.use_cassette("transfers/single") do
          transfer = Stripe::Transfer.retrieve(transfers.data.first.id)
        end
      end

      transfer
    end
    let(:transactions){ Stripe::BalanceTransaction.all(transfer: transfer.id) }

    describe 'JSON structure' do
      let(:first_transaction){ transactions.data.first }
      let(:first_mocked_transaction){ StripeMock::Data.balance_transaction }

      it 'should have matching root level keys' do
        VCR.use_cassette("/transfers/#{transfer.id}/transactions/all") do
          expect(first_transaction.keys.sort).to eq first_mocked_transaction.keys.sort
        end
      end

      it 'should have matching root level keys' do
        VCR.use_cassette("/transfers/#{transfer.id}/transactions/all") do
          expect(transactions.keys.sort).to eq StripeMock::Data.balance_transactions.keys.sort
        end
      end

      it 'should have matching transaction root level keys' do
        VCR.use_cassette("/transfers/#{transfer.id}/transactions/all") do
          expect(first_transaction.keys.sort).to eq first_mocked_transaction.keys.sort
        end
      end

      describe 'sourced_transfers' do
        it 'should have matching transfer sourced_transfers keys' do
          VCR.use_cassette("/transfers/#{transfer.id}/transactions/all") do
            expect(first_transaction.sourced_transfers.keys.sort).to eq first_mocked_transaction[:sourced_transfers].keys.sort
          end
        end
      end
    end
  end
end
