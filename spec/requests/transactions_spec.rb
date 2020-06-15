require 'rails_helper'

RSpec.describe 'Transactions', type: :request do
  let(:merchant) { create :merchant }
  let(:user) { merchant.user }

  before { sign_in(user) }

  context 'GET /transactions' do
    context 'when calling endpoint' do
      before { get merchant_transactions_path }

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
