require 'rails_helper'

RSpec.describe 'Admin::Dashboard', type: :request do
  describe 'GET /index' do
    context 'authenticated' do
      let(:user) { create :admin_user }

      before { sign_in(user) }

      it 'returns http success' do
        get admin_dashboard_path

        expect(response).to have_http_status(:success)
      end

      it 'redirects to admin dashboard page' do
        get merchant_dashboard_path

        expect(response).to redirect_to(admin_root_path)
      end
    end

    context 'unauthenticated' do
      it 'redirects to sign in page' do
        get admin_dashboard_path

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
