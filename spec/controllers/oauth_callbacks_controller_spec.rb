require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Facebook' do
    let(:oauth_data) {{'provider' => 'github', 'uid' => 123, 'info'=> {'email' => 'example@mail.com'}} }
    let(:email) { nil }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data, email)
      get :facebook
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :facebook
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq user
      end

      it 'redirect to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        allow(User).to receive(:find_for_oauth)
        get :facebook
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end
end
