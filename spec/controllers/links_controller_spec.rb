require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:user) { create :user }
  let!(:user1) { create :user }
  let!(:question) { create :question, author: user }
  let!(:answer) { create :answer, question: question, author: user }
  let!(:link) { create :link, linkable: answer }

  describe 'DELETE #destroy' do
    context 'Author' do
      before { login(user) }

      it 'delete the link' do
        expect { delete :destroy, params: { id: link }, format: :js}.to change(Link, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author' do
      before { login(user1) }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: link }, format: :js}.to_not change(Link, :count)
      end

      it 'render status 403' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to have_http_status 403
      end
    end
  end
end
