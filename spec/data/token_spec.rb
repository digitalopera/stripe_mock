require 'spec_helper'
require 'shared_examples/token'

describe 'StripeMock Tokens' do
  before(:each) do
    skip
    StripeMock.capture_requests
  end

  describe 'get tokens/:id' do
    it_should_behave_like 'a token' do
      let(:token){ Stripe::Token.retrieve( StripeMock.new_id('_tr') ) }
    end

    it 'should return the id supplied' do
      id = StripeMock.new_id('_tr')
      expect(Stripe::Token.retrieve(id).id).to eq id
    end

    context 'when :id doesn\'t exist' do
      skip
    end
  end

  describe 'post token' do
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

    context 'when successful' do
      let(:token) { Stripe::Token.create(card_attrs) }

      it_should_behave_like 'a token' do
        let(:token){ Stripe::Token.create(card: { number: '4242424242424242' }) }
      end

      it 'should have the same format as stripe response' do
        stripe_mock_token = Stripe::Token.create(card: { number: '4242424242424242' })
        StripeMock.stop_capturing

        VCR.use_cassette("token/successful") do
          expect(stripe_mock_token.keys).to eq token.keys
          expect(stripe_mock_token[:card].keys).to eq token[:card].keys
        end
      end
    end

    describe 'card errors' do
      describe 'incorrect_number' do
        let(:incorrect_number) do
          Stripe::Token.create( card: { number: StripeMock::CreditCards.card_number_by_code(:incorrect_number) } )
        end
        it 'should raise a stripe error' do
          expect{ incorrect_number }.to raise_error(Stripe::CardError)
        end

        it 'should have a http_status of 402' do
          begin
            incorrect_number
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end

        it 'should have a param of number' do
          begin
            incorrect_number
          rescue Stripe::CardError => e
            expect(e.json_body[:error]).to eq StripeMock.card_failures[:incorrect_number]
          end
        end
      end

      describe 'invalid_number' do
        let(:invalid_number){ Stripe::Token.create( card: { number: StripeMock::CreditCards.card_number_by_code(:invalid_number) } ) }
        it 'should raise a stripe error' do
          expect{ invalid_number }.to raise_error(Stripe::CardError)
        end

        it 'should have a http_status of 402' do
          begin
            invalid_number
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end

        it 'should have a hash' do
          begin
            invalid_number
          rescue Stripe::CardError => e
            expect(e.json_body[:error]).to eq StripeMock.card_failures[:invalid_number]
          end
        end
      end

      describe 'invalid_expiry_month' do
        let(:invalid_expiry_month){ Stripe::Token.create( card: { exp_month: StripeMock::CreditCards.attr_value_by_code(:exp_month, :invalid_expiry_month) } ) }
        it 'should raise a stripe error' do
          expect{ invalid_expiry_month }.to raise_error(Stripe::CardError)
        end

        it 'should have a http_status of 402' do
          begin
            invalid_expiry_month
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end

        it 'should have a param of number' do
          begin
            invalid_expiry_month
          rescue Stripe::CardError => e
            expect(e.json_body[:error]).to eq StripeMock.card_failures[:invalid_expiry_month]
          end
        end
      end

      describe 'invalid_expiry_year' do
        let(:invalid_expiry_year){ Stripe::Token.create( card: { exp_year: StripeMock::CreditCards.attr_value_by_code(:exp_year, :invalid_expiry_year) } ) }
        it 'should raise a stripe error' do
          expect{ invalid_expiry_year }.to raise_error(Stripe::CardError)
        end

        it 'should have a http_status of 402' do
          begin
            invalid_expiry_year
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end

        it 'should have a param of number' do
          begin
            invalid_expiry_year
          rescue Stripe::CardError => e
            expect(e.json_body[:error]).to eq StripeMock.card_failures[:invalid_expiry_year]
          end
        end
      end

      describe 'invalid_cvc' do
        let(:invalid_cvc){ Stripe::Token.create( card: { cvc: StripeMock::CreditCards.attr_value_by_code(:cvc, :invalid_cvc) } ) }
        it 'should raise a stripe error' do
          expect{ invalid_cvc }.to raise_error(Stripe::CardError)
        end

        it 'should have a http_status of 402' do
          begin
            invalid_cvc
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end

        it 'should have a param of number' do
          begin
            invalid_cvc
          rescue Stripe::CardError => e
            expect(e.json_body[:error]).to eq StripeMock.card_failures[:invalid_cvc]
          end
        end
      end

      # describe 'expired_card_month' do
      #   let(:expired_card_month){ Stripe::Token.create( card: { exp_month: StripeMock::CreditCards.attr_value_by_code(:exp_month, :expired_card_month) } ) }
      #   it 'should raise a stripe error' do
      #     expect{ expired_card_month }.to raise_error(Stripe::CardError)
      #   end
      #
      #   it 'should have a http_status of 402' do
      #     begin
      #       expired_card_month
      #     rescue Stripe::CardError => e
      #       expect(e.http_status).to eq 402
      #     end
      #   end
      #
      #   it 'should have a param of number' do
      #     begin
      #       expired_card_month
      #     rescue Stripe::CardError => e
      #       expect(e.json_body[:error]).to eq StripeMock.card_failures[:expired_card_month]
      #     end
      #   end
      # end

      # describe 'expired_card_year' do
      #   let(:expired_card_year){ Stripe::Token.create(source: 'tok_expired_card_year') }
      #   it 'should raise a stripe error' do
      #     expect{ expired_card_year }.to raise_error(Stripe::CardError)
      #   end
      #
      #   it 'should have a http_status of 402' do
      #     begin
      #       expired_card_year
      #     rescue Stripe::CardError => e
      #       expect(e.http_status).to eq 402
      #     end
      #   end
      #
      #   it 'should have a param of number' do
      #     begin
      #       expired_card_year
      #     rescue Stripe::CardError => e
      #       expect(e.json_body[:error]).to eq StripeMock.card_failures[:expired_card_year]
      #     end
      #   end
      # end
      #
      # describe 'incorrect_zip' do
      #   let(:incorrect_zip){ Stripe::Token.create(source: 'tok_incorrect_zip') }
      #   it 'should raise a stripe error' do
      #     expect{ incorrect_zip }.to raise_error(Stripe::CardError)
      #   end
      #
      #   it 'should have a http_status of 402' do
      #     begin
      #       incorrect_zip
      #     rescue Stripe::CardError => e
      #       expect(e.http_status).to eq 402
      #     end
      #   end
      #
      #   it 'should have a param of number' do
      #     begin
      #       incorrect_zip
      #     rescue Stripe::CardError => e
      #       expect(e.json_body[:error]).to eq StripeMock.card_failures[:incorrect_zip]
      #     end
      #   end
      # end
    end
  end
end
