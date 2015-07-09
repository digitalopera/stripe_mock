require 'spec_helper'
require 'shared_examples/transfer'

describe 'StripeMock Transfers' do
  describe 'get transfers' do
    let(:transfers){ Stripe::Transfer.all }

    it 'should return a list of transfers' do
      Stripe::Transfer.create
      expect(transfers).to be_is_a(Stripe::ListObject)
      expect(transfers.data.first).to be_is_a(Stripe::Transfer)
    end

    describe 'the list of transfers' do
      before(:each) do
        Stripe::Transfer.create
      end

      it_should_behave_like 'a transfer' do
        let(:id){ transfer.id }
        let(:transfer){ transfers.data.first }
      end

      it 'should have 2 transfers' do
        Stripe::Transfer.create
        expect(transfers.data.size).to eq 2
      end

      context 'when limit is less than total transfers' do
        let(:transfers){ Stripe::Transfer.all(limit: 3) }
        it 'should limit the number of transfers returned' do
          skip 'TODO'
        end
      end

      context 'when limit is more than total transfers' do
        it 'should return all transfers' do
          skip 'TODO'
        end
      end
    end

    describe 'json structure' do
      it 'should be list' do
        expect(transfers.object).to eq 'list'
      end
    end
  end

  describe 'get transfer/:id' do
    it_should_behave_like 'a transfer' do
      let(:id){ Stripe::Transfer.create.id }
      let(:transfer){ Stripe::Transfer.retrieve(id) }
    end

    it 'should return the specified transfer by id' do
      transfer = Stripe::Transfer.create
      expect(Stripe::Transfer.retrieve(transfer.id).to_json).to eq transfer.to_json
    end
  end

  describe 'post transfers' do
    it_should_behave_like 'a transfer' do
      let(:id){ transfer.id }
      let(:transfer){ Stripe::Transfer.create }
    end

    context 'when amount is supplied' do
      let(:transfer){ Stripe::Transfer.create(amount: 1000) }
      it 'should return a transfer with the amount' do
        expect(transfer.amount).to eq 1000
      end
    end

    context 'when currency is supplied' do
      let(:transfer){ Stripe::Transfer.create(amount: 200, currency: 'AUD') }
      it 'should return a transfer with the currency' do
        expect(transfer.currency).to eq 'AUD'
      end
    end
  end
end
