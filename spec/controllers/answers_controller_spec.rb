require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let(:answer) { create :answer, question: question, author: user }

  describe 'GET #edit' do
    before { login(user) }

    it 'redirect edit view' do
      get :edit, params: { id: answer }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }


    context 'with valid attributes' do
      it 'save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
        expect(assigns(:answer).author).to eq user
      end

      it 'redirect to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'dos not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-render to "/questions/show"' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body'} }
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'redirect to updated question' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not change question' do
        answer.reload
        expect(answer.body).to eq "MyText"
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user1) { create :user }
    let!(:answer) {create :answer, question: question, author: user1}

    context 'Author' do
      before { login(user1) }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer }}.to change(Answer, :count).by(-1)
      end

      it 'redirect to "questions/show" view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
      end
    end

    context 'Not author' do
      before { login(user) }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer }}.to_not change(Answer, :count)
      end

      it 'redirect to "questions/show" view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
      end
    end
  end
end
