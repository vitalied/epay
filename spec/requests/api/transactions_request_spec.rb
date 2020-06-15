require 'rails_helper'

RSpec.describe 'Api::Transactions', type: :request do
  let(:merchant) { create :merchant }
  let(:token) { merchant.user.authentication_token }
  let(:valid_params) do
    build_attributes(build(:authorize_transaction), :type, :uuid, :amount, :status, :customer_email)
  end
  let(:invalid_params) do
    build_attributes(build(:authorize_transaction, uuid: nil), :type, :uuid)
  end

  context 'POST /api/transacgtions' do
    context 'unauthenticated' do
      it 'returns a unauthorized response' do
        post api_transactions_path, headers: json_headers

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'unauthorized' do
      let(:merchant) { create :inactive_merchant }

      it 'returns a unauthorized response' do
        post api_transactions_path, headers: token_headers

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'authorized' do
      context 'with valid params' do
        context 'when calling endpoint' do
          let(:post_request) { post api_transactions_path, headers: token_headers, params: valid_params.to_json }

          it 'creates a new entity' do
            expect { post_request }.to change(Transaction, :count).by(1)
          end

          it 'renders a JSON response with the new entity' do
            post_request

            expect(response).to have_http_status(:created)

            expect(body[:uuid]).to eql(valid_params[:uuid])
          end
        end
      end

      context 'with invalid params' do
        context 'when calling endpoint' do
          let(:post_request) { post api_transactions_path, headers: token_headers, params: invalid_params.to_json }

          it "doesn't create a new entity" do
            expect { post_request }.not_to change(Transaction, :count)
          end

          it 'renders a JSON response with errors for the new entity' do
            post_request

            expect(response).to have_http_status(:unprocessable_entity)

            expect(body_error).to be_present
          end
        end
      end
    end
  end
end
