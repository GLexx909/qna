require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted', let(:user){ create :user }, let(:user2){ create :user },
                           let(:votable) { create(:answer, question: question, author: user) }

  let(:user)     { create :user }
  let(:question) { create :question, author: user }
  let!(:answer)   { create :answer, question: question, author: user }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it_behaves_like 'To save a new object', let(:params) { answer_params }, let(:object_class) { Answer }, let(:object) { 'answer' }

      it 'redirect to create view' do
        post :create, params: answer_params, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it_behaves_like 'To does not save a new object', let(:params) { answer_params_invalid }, let(:object_class) { Answer }

      it 'render to create view' do
        post :create, params: answer_params_invalid, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    describe 'Author' do
      before { login(user) }

      context 'with valid attributes' do
        it_behaves_like 'To update the object', let(:params) { answer_params }, let(:object) { answer }
        it_behaves_like 'To change the object attributes', let(:params) { answer_params_new }, let(:object) { answer }
      end

      context 'with invalid attributes' do
        let!(:answer) { create :answer, body: 'MyBody',question: question, author: user }

        it_behaves_like 'To not change the object attributes', let(:params) { answer_params_invalid }, let(:object) { answer }
        it_behaves_like 'To render update view', let(:params) { answer_params_invalid }, let(:object) { answer }
      end
    end

    describe 'Not Author' do
      let(:user1) { create :user }
      let!(:answer) { create :answer, question: question, body: 'MyBody', author: user }

      before { login(user1) }

      it_behaves_like 'To not change the object attributes', let(:params) { answer_params_new }, let(:object) { answer }
      it_behaves_like 'PATCH to render status 403', let(:params) { answer_params_new }
    end
  end


  describe 'DELETE #destroy' do
    let!(:user1) { create :user }
    let!(:answer) {create :answer, question: question, author: user1}

    context 'Author' do
      before { login(user1) }

      it_behaves_like 'To delete the object', let(:object) { answer }, let(:object_class) { Answer }

       it 'render destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author' do
      before { login(user) }
      it_behaves_like 'To not delete the object', let(:object) { answer }, let(:object_class) { Answer }
      it_behaves_like 'DELETE to render status 403', let(:params) { answer }
    end
  end

  describe 'PATCH #mark_best' do
    context 'Author of question' do
      before { login(user)}
      let!(:answer_last) { create :answer, question: question, author: user, best: true }

      it 'mark best answer' do
        patch :mark_best, params: { id: answer }, format: :js

        expect(Answer.where(best: true).count).to eq 1
        expect(assigns(:answer).best).to eq true
      end

      it 'render mark_best view' do
        patch :mark_best, params: { id: answer }, format: :js
        expect(response).to render_template :mark_best
      end
    end

    context 'Not Author of question' do
      let(:user1) { create :user }
      before { login(user1)}

      it 'mark best answer' do
        patch :mark_best, params: { id: answer }, format: :js
        expect(assigns(:answer).best).to eq false
      end

      it 'render status 403' do
        patch :mark_best, params: { id: answer }, format: :js
        expect(response).to have_http_status 403
      end
    end
  end
end
