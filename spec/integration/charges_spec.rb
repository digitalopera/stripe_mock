require 'spec_helper'

describe 'Stripe::Charge', :vcr do
  let(:card_attrs) do
    {
      card: {
        name: Faker::Name.name,
        number: '4242424242424242',
        exp_month: Faker::Number.between(1, 12),
        exp_year: (Date.today.year + 1),
        cvc: Faker::Number.number(3),
        address_line1: Faker::Address.street_address,
        address_city: Faker::Address.city,
        address_state: Faker::Address.state_abbr,
        address_zip: Faker::Address.postcode
      }
    }
  end
  let(:charge_attrs) do
    {
      amount:           100,
      card:             token.id,
      currency:         'usd'
    }
  end
  let(:token) { Stripe::Token.create(card_attrs) }
  let(:charge){ Stripe::Charge.create(charge_attrs) }

  describe 'valid charge' do
    it 'should return the charge' do
      VCR.use_cassette("charges/successful") do
        expect(charge).to be_is_a(Stripe::Charge)
      end
    end
  end

  describe 'invalid charge' do
    context 'when cvc is incorrect' do
      before(:each) do
        card_attrs[:card].merge!(number: '4000000000000127')
      end

      it 'should have incorrect_cvc' do
        VCR.use_cassette("charges/incorrect_cvc") do
          expect{ charge }.to raise_error{ Stripe::CardError }
        end
      end

      it 'should have a http_status of 402' do
        VCR.use_cassette("charges/incorrect_cvc") do
          begin
            charge
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end
      end

      it 'should have StripeMock keys' do
        VCR.use_cassette("charges/incorrect_cvc") do
          begin
            charge
          rescue Stripe::CardError => e
            expect(e.json_body[:error].keys.sort).to eq StripeMock.charge_failures[:incorrect_cvc].keys.sort
          end
        end
      end

      it 'should have StripeMock values' do
        VCR.use_cassette("charges/incorrect_cvc") do
          begin
            charge
          rescue Stripe::CardError => e
            # Since :charge is dynamic, remove that value from this test.
            # Charge is testing in following test
            error_hash = e.json_body[:error]
            error_hash.delete :charge
            without_charge = StripeMock.charge_failures[:incorrect_cvc]
            without_charge.delete(:charge)

            expect(error_hash.values.sort).to eq without_charge.values.sort
          end
        end
      end

      it 'should have StripeMock charge value' do
        VCR.use_cassette("charges/incorrect_cvc") do
          begin
            charge
          rescue Stripe::CardError => e
            stripe_charge_id = e.json_body[:error][:charge]

            expect(stripe_charge_id).to match /\Ach_/
          end
        end
      end
    end

    context 'when zip is incorrect' do
      before(:each) do
        card_attrs[:card].merge!(number: '4000000000000036')
      end

      it 'should have incorrect_cvc' do
        VCR.use_cassette("charges/incorrect_zip") do
          expect{ charge }.to raise_error{ Stripe::CardError }
        end
      end

      it 'should have a http_status of 402' do
        VCR.use_cassette("charges/incorrect_zip") do
          begin
            charge
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end
      end

      it 'should have StripeMock keys' do
        VCR.use_cassette("charges/incorrect_zip") do
          begin
            charge
          rescue Stripe::CardError => e
            expect(e.json_body[:error].keys.sort).to eq StripeMock.charge_failures[:incorrect_zip].keys.sort
          end
        end
      end

      it 'should have StripeMock values' do
        VCR.use_cassette("charges/incorrect_zip") do
          begin
            charge
          rescue Stripe::CardError => e
            # Since :charge is dynamic, remove that value from this test.
            # Charge is testing in following test
            error_hash = e.json_body[:error]
            error_hash.delete :charge
            without_charge = StripeMock.charge_failures[:incorrect_zip]
            without_charge.delete(:charge)

            expect(error_hash.values.sort).to eq without_charge.values.sort
          end
        end
      end

      it 'should have StripeMock charge value' do
        VCR.use_cassette("charges/incorrect_zip") do
          begin
            charge
          rescue Stripe::CardError => e
            stripe_charge_id = e.json_body[:error][:charge]

            expect(stripe_charge_id).to match /\Ach_/
          end
        end
      end
    end

    context 'when card is declined' do
      before(:each) do
        card_attrs[:card].merge!(number: '4000000000000002')
      end

      it 'should have incorrect_cvc' do
        VCR.use_cassette("charges/card_declined") do
          expect{ charge }.to raise_error{ Stripe::CardError }
        end
      end

      it 'should have a http_status of 402' do
        VCR.use_cassette("charges/card_declined") do
          begin
            charge
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end
      end

      it 'should have StripeMock keys' do
        VCR.use_cassette("charges/card_declined") do
          begin
            charge
          rescue Stripe::CardError => e
            expect(e.json_body[:error].keys.sort).to eq StripeMock.charge_failures[:card_declined].keys.sort
          end
        end
      end

      it 'should have StripeMock values' do
        VCR.use_cassette("charges/card_declined") do
          begin
            charge
          rescue Stripe::CardError => e
            # Since :charge is dynamic, remove that value from this test.
            # Charge is testing in following test
            error_hash = e.json_body[:error]
            error_hash.delete :charge
            without_charge = StripeMock.charge_failures[:card_declined]
            without_charge.delete(:charge)

            expect(error_hash.values.sort).to eq without_charge.values.sort
          end
        end
      end

      it 'should have StripeMock charge value' do
        VCR.use_cassette("charges/card_declined") do
          begin
            charge
          rescue Stripe::CardError => e
            stripe_charge_id = e.json_body[:error][:charge]

            expect(stripe_charge_id).to match /\Ach_/
          end
        end
      end
    end

    context 'when customer is missing' do
      before(:each) do
        customer = nil
        VCR.use_cassette("customer/successful") do
          customer = Stripe::Customer.create(description: 'Test customer for StripeMock')
        end
        charge_attrs[:customer] = customer.id
        charge_attrs[:card] = nil
      end

      it 'should have missing' do
        VCR.use_cassette("charges/customer_missing") do
          expect{ charge }.to raise_error{ Stripe::CardError }
        end
      end

      it 'should have a http_status of 402' do
        VCR.use_cassette("charges/customer_missing") do
          begin
            charge
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end
      end

      it 'should have StripeMock keys' do
        VCR.use_cassette("charges/customer_missing") do
          begin
            charge
          rescue Stripe::CardError => e
            expect(e.json_body[:error].keys.sort).to eq StripeMock.charge_failures[:missing].keys.sort
          end
        end
      end

      it 'should have StripeMock values' do
        VCR.use_cassette("charges/customer_missing") do
          begin
            charge
          rescue Stripe::CardError => e
            expect( e.json_body[:error].values.sort ).to eq StripeMock.charge_failures[:missing].values.sort
          end
        end
      end
    end

    context 'when there is a processing error', focus: true do
      before(:each) do
        card_attrs[:card].merge!(number: '4000000000000119')
      end

      it 'should have missing' do
        VCR.use_cassette("charges/processing_error") do
          expect{ charge }.to raise_error{ Stripe::CardError }
        end
      end

      it 'should have a http_status of 402' do
        VCR.use_cassette("charges/processing_error") do
          begin
            charge
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end
      end

      it 'should have StripeMock keys' do
        VCR.use_cassette("charges/processing_error") do
          begin
            charge
          rescue Stripe::CardError => e
            expect(e.json_body[:error].keys.sort).to eq StripeMock.charge_failures[:processing_error].keys.sort
          end
        end
      end

      it 'should have StripeMock values' do
        VCR.use_cassette("charges/processing_error") do
          begin
            charge
          rescue Stripe::CardError => e
            # Since :charge is dynamic, remove that value from this test.
            # Charge is testing in following test
            error_hash = e.json_body[:error]
            error_hash.delete :charge
            without_charge = StripeMock.charge_failures[:processing_error]
            without_charge.delete(:charge)

            expect(error_hash.values.sort).to eq without_charge.values.sort
          end
        end
      end

      it 'should have StripeMock charge value' do
        VCR.use_cassette("charges/processing_error") do
          begin
            charge
          rescue Stripe::CardError => e
            stripe_charge_id = e.json_body[:error][:charge]

            expect(stripe_charge_id).to match /\Ach_/
          end
        end
      end
    end
  end
end
