require 'spec_helper'

describe 'Stripe::Token', :vcr do
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

  let(:token) { Stripe::Token.create(card_attrs) }

  describe 'valid token' do
    it 'should return a stripe object' do
      VCR.use_cassette("token/successful") do
        expect(token).to be_is_a(Stripe::StripeObject)
      end
    end

    it 'should return the token' do
      VCR.use_cassette("token/successful") do
        expect(token.object).to eq 'token'
      end
    end
  end

  describe 'invalid token' do
    context 'when card number is invalid' do
      before(:each) do
        card_attrs[:card].merge!(number: 'asdf')
      end

      it 'should have invalid_number' do
        VCR.use_cassette("token/invalid_number") do
          expect{ token }.to raise_error{ Stripe::CardError }
        end
      end

      it 'should have a http_status of 402' do
        VCR.use_cassette("token/invalid_number") do
          begin
            token
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end
      end

      it 'should have a StripeMock keys' do
        VCR.use_cassette("token/invalid_number") do
          begin
            token
          rescue Stripe::CardError => e
            expect(e.json_body[:error].keys.sort).to eq StripeMock.card_failures[:invalid_number].keys.sort
          end
        end
      end

      it 'should have only an certain keys' do
        VCR.use_cassette("token/invalid_number") do
          begin
            token
          rescue Stripe::CardError => e
            expect(e.json_body.keys).to eq [:error]
          end
        end
      end

      it 'should have a StripeMock values' do
        VCR.use_cassette("token/invalid_number") do
          begin
            token
          rescue Stripe::CardError => e
            expect(e.json_body[:error].values.sort).to eq StripeMock.card_failures[:invalid_number].values.sort
          end
        end
      end
    end

    context 'when expiry_month is invalid' do
      before(:each) do
        card_attrs[:card].merge!(exp_month: 0)
      end

      it 'should have incorrect_number' do
        VCR.use_cassette("token/invalid_expiry_month") do
          expect{ token }.to raise_error{ Stripe::CardError }
        end
      end

      it 'should have a http_status of 402' do
        VCR.use_cassette("token/invalid_expiry_month") do
          begin
            token
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end
      end

      it 'should have a StripeMock keys' do
        VCR.use_cassette("token/invalid_expiry_month") do
          begin
            token
          rescue Stripe::CardError => e
            expect(e.json_body[:error].keys.sort).to eq StripeMock.card_failures[:invalid_expiry_month].keys.sort
          end
        end
      end

      it 'should have a StripeMock values' do
        VCR.use_cassette("token/invalid_expiry_month") do
          begin
            token
          rescue Stripe::CardError => e
            expect(e.json_body[:error].values.sort).to eq StripeMock.card_failures[:invalid_expiry_month].values.sort
          end
        end
      end
    end

    context 'when expiry_year is invalid' do
      before(:each) do
        card_attrs[:card].merge!(exp_year: 0)
      end

      it 'should have incorrect_number' do
        VCR.use_cassette("token/invalid_expiry_year") do
          expect{ token }.to raise_error{ Stripe::CardError }
        end
      end

      it 'should have a http_status of 402' do
        VCR.use_cassette("token/invalid_expiry_year") do
          begin
            token
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end
      end

      it 'should have a StripeMock keys' do
        VCR.use_cassette("token/invalid_expiry_year") do
          begin
            token
          rescue Stripe::CardError => e
            expect(e.json_body[:error].keys.sort).to eq StripeMock.card_failures[:invalid_expiry_year].keys.sort
          end
        end
      end

      it 'should have a StripeMock values' do
        VCR.use_cassette("token/invalid_expiry_year") do
          begin
            token
          rescue Stripe::CardError => e
            expect(e.json_body[:error].values.sort).to eq StripeMock.card_failures[:invalid_expiry_year].values.sort
          end
        end
      end
    end

    context 'when cvc is invalid' do
      before(:each) do
        card_attrs[:card].merge!(cvc: 0)
      end

      it 'should have incorrect_number' do
        VCR.use_cassette("token/invalid_cvc") do
          expect{ token }.to raise_error{ Stripe::CardError }
        end
      end

      it 'should have a http_status of 402' do
        VCR.use_cassette("token/invalid_cvc") do
          begin
            token
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end
      end

      it 'should have a StripeMock keys' do
        VCR.use_cassette("token/invalid_cvc") do
          begin
            token
          rescue Stripe::CardError => e
            expect(e.json_body[:error].keys.sort).to eq StripeMock.card_failures[:invalid_cvc].keys.sort
          end
        end
      end

      it 'should have a StripeMock values' do
        VCR.use_cassette("token/invalid_cvc") do
          begin
            token
          rescue Stripe::CardError => e
            expect(e.json_body[:error].values.sort).to eq StripeMock.card_failures[:invalid_cvc].values.sort
          end
        end
      end
    end

    context 'when cvc is incorrect' do
      # creating a token with incorrect cvc does not fire an error until used
    end

    context 'when number is incorrect' do
      before(:each) do
        card_attrs[:card].merge!(number: '4242424242424241')
      end

      it 'should have incorrect_number' do
        VCR.use_cassette("token/incorrect_number") do
          expect{ token }.to raise_error{ Stripe::CardError }
        end
      end

      it 'should have a http_status of 402' do
        VCR.use_cassette("token/incorrect_number") do
          begin
            token
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end
      end

      it 'should have a StripeMock keys' do
        VCR.use_cassette("token/incorrect_number") do
          begin
            token
          rescue Stripe::CardError => e
            expect(e.json_body[:error].keys.sort).to eq StripeMock.card_failures[:incorrect_number].keys.sort
          end
        end
      end

      it 'should have a StripeMock values' do
        VCR.use_cassette("token/incorrect_number") do
          begin
            token
          rescue Stripe::CardError => e
            expect(e.json_body[:error].values.sort).to eq StripeMock.card_failures[:incorrect_number].values.sort
          end
        end
      end
    end

    context 'when card is expired' do
      context 'year has expired' do
        before(:each) do
          card_attrs[:card].merge!(exp_year: (Date.today.year - 1))
        end

        it 'should have expired_card' do
          VCR.use_cassette("token/expired_card_year") do
            expect{ token }.to raise_error{ Stripe::CardError }
          end
        end

        it 'should have a http_status of 402' do
          VCR.use_cassette("token/expired_card_year") do
            begin
              token
            rescue Stripe::CardError => e
              expect(e.http_status).to eq 402
            end
          end
        end

        it 'should have a StripeMock keys' do
          VCR.use_cassette("token/expired_card_year") do
            begin
              token
            rescue Stripe::CardError => e
              expect(e.json_body[:error].keys.sort).to eq StripeMock.card_failures[:expired_card_year].keys.sort
            end
          end
        end

        it 'should have a StripeMock values' do
          VCR.use_cassette("token/expired_card_year") do
            begin
              token
            rescue Stripe::CardError => e
              expect(e.json_body[:error].values.sort).to eq StripeMock.card_failures[:expired_card_year].values.sort
            end
          end
        end
      end

      context 'month has expired' do
        before(:each) do
          card_attrs[:card].merge!(exp_month: (Date.today.month - 1), exp_year: Date.today.year)
        end

        it 'should have expired_card' do
          VCR.use_cassette("token/expired_card_month") do
            expect{ token }.to raise_error{ Stripe::CardError }
          end
        end

        it 'should have a http_status of 402' do
          VCR.use_cassette("token/expired_card_month") do
            begin
              token
            rescue Stripe::CardError => e
              expect(e.http_status).to eq 402
            end
          end
        end

        it 'should have a StripeMock keys' do
          VCR.use_cassette("token/expired_card_month") do
            begin
              token
            rescue Stripe::CardError => e
              expect(e.json_body[:error].keys.sort).to eq StripeMock.card_failures[:expired_card_month].keys.sort
            end
          end
        end

        it 'should have a StripeMock values' do
          VCR.use_cassette("token/expired_card_month") do
            begin
              token
            rescue Stripe::CardError => e
              expect(e.json_body[:error].values.sort).to eq StripeMock.card_failures[:expired_card_month].values.sort
            end
          end
        end
      end

      context 'month and year have expired' do
        before(:each) do
          card_attrs[:card].merge!(exp_month: (Date.today.month - 1), exp_year: (Date.today.year - 1))
        end

        it 'should have expired_card' do
          VCR.use_cassette("token/expired_card") do
            expect{ token }.to raise_error{ Stripe::CardError }
          end
        end

        it 'should have a http_status of 402' do
          VCR.use_cassette("token/expired_card") do
            begin
              token
            rescue Stripe::CardError => e
              expect(e.http_status).to eq 402
            end
          end
        end

        it 'should have a StripeMock keys' do
          VCR.use_cassette("token/expired_card") do
            begin
              token
            rescue Stripe::CardError => e
              expect(e.json_body[:error].keys.sort).to eq StripeMock.card_failures[:expired_card_year].keys.sort
            end
          end
        end

        it 'should have a StripeMock values' do
          VCR.use_cassette("token/expired_card") do
            begin
              token
            rescue Stripe::CardError => e
              expect(e.json_body[:error].values.sort).to eq StripeMock.card_failures[:expired_card_year].values.sort
            end
          end
        end
      end
    end

    context 'when zip is incorrect' do
      # Zip is not verified when creating a token
    end

    context 'when card is declined' do
      # Card is not declined when creating a token
    end

    context 'when customer is missing' do
      # No error is thrown when creating a token with missing customer
    end
  end
end
