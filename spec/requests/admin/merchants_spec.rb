require 'rails_helper'

RSpec.describe 'Admin::Merchants', type: :request do
  let(:user) { create :admin_user }
  let(:merchant) { create :merchant }
  let(:merchants_list) { create_list :merchant, 2 }
  let(:valid_params) do
    params = build_attributes(build(:merchant), :name, :description, :email, :status)
    { merchant: params }
  end
  let(:invalid_params) do
    params = build_attributes(build(:merchant, email: nil), :name, :email)
    { merchant: params }
  end

  before { sign_in(user) }

  context 'GET /admin/merchants' do
    context 'when calling endpoint' do
      let!(:expected_data) { merchants_list.map(&:name) }

      before { get admin_merchants_path }

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns expected data' do
        expect(response.body).to include(expected_data.first)
        expect(response.body).to include(expected_data.last)
      end
    end
  end

  context 'GET /admin/merchants/:id' do
    context 'when calling endpoint' do
      before { get admin_merchant_path(merchant) }

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns expected data' do
        expect(response.body).to include(merchant.name)
      end
    end
  end

  context 'GET /admin/merchants/new' do
    context 'when calling endpoint' do
      before { get new_admin_merchant_path }

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns expected data' do
        expect(response.body).to include('New Merchant')
      end
    end
  end

  context 'GET /admin/merchants/:id/edit' do
    context 'when calling endpoint' do
      before { get edit_admin_merchant_path(merchant) }

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns expected data' do
        expect(response.body).to include('Edit Merchant')
      end
    end
  end

  context 'POST /admin/merchants' do
    context 'with valid params' do
      context 'when calling endpoint' do
        before { post admin_merchants_path, params: valid_params }

        it 'redirect after succesful create' do
          expect(response).to redirect_to(admin_merchants_path)
        end

        it 'flashes a success message' do
          expect(request.flash[:notice]).to eql('Merchant was successfully created.')
        end
      end
    end

    context 'with invalid params' do
      context 'when calling endpoint' do
        before { post admin_merchants_path, params: invalid_params }

        it 'returns a success response' do
          expect(response).to have_http_status(:ok)
        end

        it 'render create form with errors' do
          expect(response.body).to include('prohibited this merchant from being saved')
        end
      end
    end
  end

  context 'PATCH /admin/merchants/:id' do
    context 'with valid params' do
      context 'when calling endpoint' do
        before { patch admin_merchant_path(merchant), params: valid_params }

        it 'redirect after succesful update' do
          expect(response).to redirect_to(admin_merchants_path)
        end

        it 'flashes a success message' do
          expect(request.flash[:notice]).to eql('Merchant was successfully updated.')
        end
      end
    end

    context 'with invalid params' do
      context 'when calling endpoint' do
        before { patch admin_merchant_path(merchant), params: invalid_params }

        it 'returns a success response' do
          expect(response).to have_http_status(:ok)
        end

        it 'render update form with errors' do
          expect(response.body).to include('prohibited this merchant from being saved')
        end
      end
    end
  end

  context 'DELETE /admin/merchants/:id' do
    context 'when merchant can be deleted' do
      before { delete admin_merchant_path(merchant) }

      context 'when calling endpoint' do
        it 'redirect after succesful delete' do
          expect(response).to redirect_to(admin_merchants_path)
        end

        it 'flashes a success message' do
          expect(request.flash[:notice]).to eql('Merchant was successfully deleted.')
        end
      end
    end

    context 'with invalid params' do
      before do
        expect_any_instance_of(Merchant).to receive(:can_be_deleted?).and_return(false)

        delete admin_merchant_path(merchant)
      end

      context "when merchant can't be deleted" do
        it 'redirect after unsuccesful delete' do
          expect(response).to redirect_to(admin_merchants_path)
        end

        it 'render errors' do
          expect(request.flash[:alert]).to eql("Merchant can't be deleted. There are related Transactions.")
        end
      end
    end
  end
end
