require 'spec_helper'

describe 'StripeMock::Session' do
  describe 'transfers' do
    before(:each) do
      StripeMock::Session.transfers << 'foo'
    end

    it 'should allow for storing transfers' do
      expect(StripeMock::Session.transfers.size).to eq 1
    end

    it 'should allow for removing transfers' do
      expect{ StripeMock::Session.transfers.pop }.to change{ StripeMock::Session.transfers.size }.by(-1)
    end
  end

  describe '#clear' do
    context 'when collection is supplied' do
      it 'should clear the collection' do
        StripeMock::Session.transfers << 'foo'
        expect{ StripeMock::Session.clear('transfers') }.to change{ StripeMock::Session.transfers.size }.by(-1)
      end

      it 'should NOT clear other collections' do
        StripeMock::Session.transfers << 'foo'
        StripeMock::Session.charges << 'bar'
        expect{ StripeMock::Session.clear('transfers') }.to change{ StripeMock::Session.charges.size }.by(0)
      end
    end

    context 'when collection is NOT supplied' do
      it 'should clear all collections' do
        StripeMock::Session.transfers << 'foo'
        StripeMock::Session.charges << 'bar'
        StripeMock::Session.clear
        expect(StripeMock::Session.transfers.size).to eq 0
        expect(StripeMock::Session.charges.size).to eq 0
      end
    end
  end

  describe '#find' do
    it 'should return the collection item' do
      transfer = Stripe::Transfer.create
      found_transfer = StripeMock::Session.find('transfers', transfer.id)
      expect(found_transfer[:id]).to eq transfer.id
    end
  end
end
