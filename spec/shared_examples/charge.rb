RSpec.shared_examples "a charge" do
  it 'should return the transfer' do
    expect(charge).to be_is_a(Stripe::Charge)
  end

  describe 'json structure' do
    it 'should be transfer' do
      expect(charge.object).to eq 'charge'
    end

    describe 'refunds' do
      let(:refunds){ charge.refunds }

      it 'should have url with transfer id' do
        expect(refunds.url).to eq("/v1/charges/#{ charge.id }/refunds")
      end
    end
  end
end
