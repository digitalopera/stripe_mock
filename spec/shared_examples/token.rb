RSpec.shared_examples "a token" do
  it 'should return a stripe object' do
    expect(token).to be_is_a(Stripe::StripeObject)
  end

  describe 'json structure' do
    it 'should be transfer' do
      expect(token.object).to eq 'token'
    end
  end
end
