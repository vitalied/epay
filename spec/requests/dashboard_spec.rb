require 'rails_helper'

RSpec.describe 'Dashboard', type: :request do
  describe 'GET /index' do
    context 'authenticated' do
      let(:merchant) { create :merchant }
      let(:user) { merchant.user }

      before { sign_in(user) }

      it 'returns http success' do
        get merchant_dashboard_path

        expect(response).to have_http_status(:success)
      end

      it 'redirects to admin dashboard page' do
        get admin_dashboard_path

        expect(response).to redirect_to(merchant_root_path)
      end
    end

    context 'unauthenticated' do
      it 'redirects to sign in page' do
        get merchant_dashboard_path

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
