require 'spec_helper'
require 'shared_examples/charge'

describe 'StripeMock Charges' do
  before(:each) do
    skip
    StripeMock.capture_requests
  end

  describe 'get charges' do
    let(:charges){ Stripe::Charge.all }

    it 'should return a list of transfers' do
      expect(charges).to be_is_a(Stripe::ListObject)
      expect(charges.data.first).to be_is_a(Stripe::Charge)
    end

    describe 'the list of charges' do
      it_should_behave_like 'a charge' do
        let(:charge){ charges.data.first }
      end

      it 'should have 2 charges' do
        expect(charges.data.size).to eq 2
      end
    end
  end

  describe 'get charges/:id' do
    it_should_behave_like 'a charge' do
      let(:charge){ Stripe::Charge.retrieve(StripeMock.new_id('ch_')) }
    end

    it 'should return the id supplied' do
      id = StripeMock.new_id('_tr')
      expect(Stripe::Charge.retrieve(id).id).to eq id
    end
  end

  describe 'post charges' do
    it_should_behave_like 'a charge' do
      let(:charge){ Stripe::Charge.create }
    end

    describe 'card errors' do
      # describe 'invalid_number' do
      #   let(:invalid_number){ Stripe::Charge.create(source: 'tok_invalid_number') }
      #   it 'should raise a stripe error' do
      #     expect{ invalid_number }.to raise_error(Stripe::CardError)
      #   end
      #
      #   it 'should raise a stripe number error' do
      #     begin
      #       invalid_number
      #     rescue Stripe::CardError => e
      #       expect(e.message).to eq StripeMock.card_failures[:invalid_number][:message]
      #     end
      #   end
      #
      #   it 'should have a http_status of 402' do
      #     begin
      #       invalid_number
      #     rescue Stripe::CardError => e
      #       expect(e.http_status).to eq 402
      #     end
      #   end
      #
      #   it 'should have a param of number' do
      #     begin
      #       invalid_number
      #     rescue Stripe::CardError => e
      #       expect(e.json_body[:error][:param]).to eq StripeMock.card_failures[:invalid_number][:param]
      #     end
      #   end
      # end
    end
  end
end
