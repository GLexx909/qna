require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user1) { create :user }
  let!(:question) { create :question, author: user1 }

  describe 'POST #create' do
    context 'Authorised user' do
      before { login(user1) }

      it 'create a comment' do
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js}.to change(Comment, :count).by(1)
      end

      it 'render create.js view' do
        post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(user1) }
      it 'dos not save the comment' do
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js}.to_not change(Comment, :count)
      end

      it 'render create view' do
        post :create, params: { question_id: question, comment: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'Not authorised user can not create a comment' do
      it 'create a comment' do
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js}.to_not change(Comment, :count)
      end
    end
  end
end
