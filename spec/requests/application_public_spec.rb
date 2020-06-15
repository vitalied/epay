require 'rails_helper'

describe 'ApplicationPublic', type: :request do
  describe 'GET /anything' do
    it 'redirects to root' do
      get '/anything'

      expect(response).to redirect_to(root_path)
      expect(request.flash[:alert]).not_to be_nil
    end

    context 'json request' do
      it 'returns a bad_request response' do
        get '/anything', headers: json_headers

        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
