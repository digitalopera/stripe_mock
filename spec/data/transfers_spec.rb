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
      let(:transfer){ Stripe::Transfer.retrieve(StripeMock.new_id('_tr')) }
    end
  end

  describe 'post transfers' do
    it_should_behave_like 'a transfer' do
      let(:transfer){ Stripe::Transfer.create }
    end
  end
end
