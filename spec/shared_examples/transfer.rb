RSpec.shared_examples "a transfer" do
  it 'should return the transfer' do
    expect(transfer).to be_is_a(Stripe::Transfer)
  end

  describe 'json structure' do
    it 'should have the id supplied' do
      expect(transfer.id).to eq id
    end

    it 'should be transfer' do
      expect(transfer.object).to eq 'transfer'
    end

    it 'should have integer created' do
      expect(transfer.created).to be_is_a(Integer)
    end

    it 'should have integer date' do
      expect(transfer.date).to be_is_a(Integer)
    end

    it 'should have integer amount' do
      expect(transfer.amount).to be_is_a(Integer)
    end

    describe 'reversals' do
      let(:reversals){ transfer.reversals }

      it 'should have url with transfer id' do
        expect(reversals.url).to eq("/v1/transfers/#{transfer.id}/reversals")
      end
    end

    describe 'bank_account' do
      let(:bank_account){ transfer.bank_account }

      it 'should id equal to destination' do
        expect(bank_account.id).to eq(transfer.destination)
      end
    end
  end
end
