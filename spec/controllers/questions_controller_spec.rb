require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted', let(:user) { create :user }, let(:user2) { create :user },
                           let(:votable) { create(:question, author: user) }

  let(:user)     { create :user }
  let(:question) { create :question, author: user }

  describe 'GET #index' do
    let(:questions) { create_list :question, 3, author: user }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it_behaves_like 'To save a new object', let(:params) { question_params }, let(:object_class) { Question }, let(:object) { 'question' }

      it 'redirects to show view' do
        post :create, params: question_params
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it_behaves_like 'To does not save a new object', let(:params) { question_params_invalid }, let(:object_class) { Question }

      it 're-render new view' do
        post :create, params: question_params_invalid
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    describe 'Author' do
      before { login(user) }

      context 'with valid attributes' do
        it_behaves_like 'To update the object', let(:params) { question_params }, let(:object) { question }
        it_behaves_like 'To change the object attributes', let(:params) { question_params_new }, let(:object) { question }
      end

      context 'with invalid attributes' do
        let!(:question) { create :question, title: 'MyTitle', body: 'MyBody', author: user }

        it_behaves_like 'To not change the object attributes', let(:params) { question_params_invalid }, let(:object) { question }
        it_behaves_like 'To render update view', let(:params) { question_params_invalid }, let(:object) { question }
      end
    end

    describe 'Not Author' do
      let(:user1) { create :user }
      let!(:question) { create :question, title: 'MyTitle', body: 'MyBody', author: user }

      before { login(user1) }

      it_behaves_like 'To not change the object attributes', let(:params) { question_params_new }, let(:object) { question }
      it_behaves_like 'PATCH to render status 403', let(:params) { question_params_new }
    end
  end

  describe 'DELETE #destroy' do
    let!(:user1) { create :user }
    let!(:question) { create :question, author: user1 }

    context 'Author' do
      before { login(user1) }

      it_behaves_like 'To delete the object', let(:object) { question }, let(:object_class) { Question }

      it 'redirect to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not author' do
      before { login(user) }

      it_behaves_like 'To not delete the object', let(:object) { question }, let(:object_class) { Question }
      it_behaves_like 'DELETE to render status 403', let(:params) { question }
    end
  end
end
