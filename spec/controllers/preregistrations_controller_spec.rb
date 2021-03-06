require 'rails_helper'

RSpec.describe PreregistrationsController, type: :controller do

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save a new user in the database' do
        expect { post :create, params: { email: 'example@mail.com' } }.to change(User, :count).by(1)
      end

      it 'redirect to confirmation view' do
        post :create, params: { email: 'example@mail.com' }
        expect(response).to render_template 'devise/mailer/confirmation_instructions'
      end
    end

    context 'with invalid attributes' do
      it 'dos not save the user' do
        expect { post :create, params: { email: '' }, format: :js }.to change(User, :count).by(0)
      end

      it 'render create view' do
        post :create, params: { email: '' }, format: :js
        expect(response).to render_template :create
      end
    end
  end
end
