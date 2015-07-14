require 'spec_helper'
require 'shared_examples/token'

describe 'StripeMock Tokens' do
  before(:each) do
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
    context 'when successful' do
      it_should_behave_like 'a token' do
        let(:token){ Stripe::Token.create }
      end
    end

    describe 'card errors' do
      describe 'invalid_number' do
        let(:invalid_number){ Stripe::Token.create(source: 'tok_invalid_number') }
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

      describe 'incorrect_number' do
        let(:incorrect_number){ Stripe::Token.create(source: 'tok_incorrect_number') }
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

      describe 'invalid_expiry_month' do
        let(:invalid_expiry_month){ Stripe::Token.create(source: 'tok_invalid_expiry_month') }
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
        let(:invalid_expiry_year){ Stripe::Token.create(source: 'tok_invalid_expiry_year') }
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
        let(:invalid_cvc){ Stripe::Token.create(source: 'tok_invalid_cvc') }
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

      describe 'expired_card_month' do
        let(:expired_card_month){ Stripe::Token.create(source: 'tok_expired_card_month') }
        it 'should raise a stripe error' do
          expect{ expired_card_month }.to raise_error(Stripe::CardError)
        end

        it 'should have a http_status of 402' do
          begin
            expired_card_month
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end

        it 'should have a param of number' do
          begin
            expired_card_month
          rescue Stripe::CardError => e
            expect(e.json_body[:error]).to eq StripeMock.card_failures[:expired_card_month]
          end
        end
      end

      describe 'expired_card_year' do
        let(:expired_card_year){ Stripe::Token.create(source: 'tok_expired_card_year') }
        it 'should raise a stripe error' do
          expect{ expired_card_year }.to raise_error(Stripe::CardError)
        end

        it 'should have a http_status of 402' do
          begin
            expired_card_year
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end

        it 'should have a param of number' do
          begin
            expired_card_year
          rescue Stripe::CardError => e
            expect(e.json_body[:error]).to eq StripeMock.card_failures[:expired_card_year]
          end
        end
      end

      describe 'incorrect_zip' do
        let(:incorrect_zip){ Stripe::Token.create(source: 'tok_incorrect_zip') }
        it 'should raise a stripe error' do
          expect{ incorrect_zip }.to raise_error(Stripe::CardError)
        end

        it 'should have a http_status of 402' do
          begin
            incorrect_zip
          rescue Stripe::CardError => e
            expect(e.http_status).to eq 402
          end
        end

        it 'should have a param of number' do
          begin
            incorrect_zip
          rescue Stripe::CardError => e
            expect(e.json_body[:error]).to eq StripeMock.card_failures[:incorrect_zip]
          end
        end
      end
    end
  end
end
