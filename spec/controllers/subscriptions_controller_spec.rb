require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #swap' do
    let!(:user) { create(:user)}
    let!(:user_not_author) { create(:user)}
    let!(:question) { create(:question, author: user)}


    context 'if subscription do not exist' do
      before { login(user_not_author) }

      it_behaves_like'To create now object', let(:methods) {:swap}, let(:params){ {id: question.id} }, let(:object) {user_not_author.subscriptions}
      it_behaves_like'To render view js', let(:params) { {id: question.id} }, let(:view) { :swap }
    end

    context 'if subscription already exist' do
      before { login(user) } # because user is author, get subscribe automatically, by after_commit adding

      it 'should create new subscription' do
        expect { post :swap, params: { id: question.id }, format: :js }.to change(user.subscriptions, :count).by(-1)
      end

      it_behaves_like'To render view js', let(:params) { {id: question.id} }, let(:view) { :swap }
    end
  end
end
