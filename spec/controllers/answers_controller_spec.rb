require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let(:answer) { create :answer, question: question, author: user }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(Answer, :count).by(1)
      end

      it 'according to the author of the answer' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer).author).to eq user
      end

      it 'redirect to create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'dos not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 'render to create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do

    describe 'Author' do
      before { login(user) }

      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
          expect(assigns(:answer)).to eq answer
        end

        it 'change answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'render update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { login(user) }

        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

        it 'does not change question' do
          answer.reload
          expect(answer.body).to eq "MyText"
        end

        it 're-render update view' do
          expect(response).to render_template :update
        end
      end
    end

    describe 'Not Author' do
      let(:user1) { create :user }
      before { login(user1) }

      it "tries to edit other user's answer" do
        patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
        answer.reload

        expect(answer.body).to_not eq 'new body'
      end
    end
  end


  describe 'DELETE #destroy' do
    let!(:user1) { create :user }
    let!(:answer) {create :answer, question: question, author: user1}

    context 'Author' do
      before { login(user1) }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js}.to change(Answer, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author' do
      before { login(user) }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js}.to_not change(Answer, :count)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
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
    end

    context 'Not Author of question' do
      let(:user1) { create :user }
      before { login(user1)}

      it 'mark best answer' do
        patch :mark_best, params: { id: answer }, format: :js
        expect(assigns(:answer).best).to eq false
      end
    end
  end
end