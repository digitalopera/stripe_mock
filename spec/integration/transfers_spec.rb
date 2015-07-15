require 'spec_helper'

describe 'Stripe::Transfer', :vcr do
  describe 'Stripe::Transfer.all' do
    let(:transfers){ Stripe::Transfer.all(limit: 2) }

    describe 'JSON structure' do
      let(:first_transfer){ transfers.data.first }
      let(:first_mocked_transfer){ StripeMock::Data.transfers[:data].first }

      it 'should have matching root level keys' do
        VCR.use_cassette("transfers/all") do
          expect(transfers.keys.sort).to eq StripeMock::Data.transfers.keys.sort
        end
      end

      it 'should have matching transfer keys' do
        VCR.use_cassette("transfers/all") do
          expect(first_transfer.keys.sort).to eq first_mocked_transfer.keys.sort
        end
      end

      describe 'transfer reversals' do
        it 'should have matching transfer reversals keys' do
          VCR.use_cassette("transfers/all") do
            expect(first_transfer.reversals.keys.sort).to eq first_mocked_transfer[:reversals].keys.sort
          end
        end
      end

      describe 'transfer bank_account' do
        it 'should have matching transfer reversals keys' do
          VCR.use_cassette("transfers/all") do
            expect(first_transfer.bank_account.keys.sort).to eq first_mocked_transfer[:bank_account].keys.sort
          end
        end
      end
    end
  end

  describe 'Stripe::Transfer.retrieve(:id)' do
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

    describe 'JSON structure' do
      it 'should have matching root level keys' do
        expect(transfer.keys.sort).to eq StripeMock::Data.transfer.keys.sort
      end

      describe 'transfer reversals' do
        it 'should have matching transfer reversals keys' do
          expect(transfer.reversals.keys.sort).to eq StripeMock::Data.transfer[:reversals].keys.sort
        end
      end

      describe 'transfer bank_account' do
        it 'should have matching transfer reversals keys' do
          expect(transfer.bank_account.keys.sort).to eq StripeMock::Data.transfer[:bank_account].keys.sort
        end
      end
    end
  end
end
