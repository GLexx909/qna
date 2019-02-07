require 'rails_helper'

describe 'Questions API', type: :request do
  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable', let(:headers) { headers_attr }, let(:method) { :get }

    context 'authorized' do
      let(:access_token)      { create(:access_token) }
      let(:user)              { create(:user) }
      let!(:questions)  { create_list(:question, 2, author: user) }
      let(:question)          { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers)    { create_list(:answer, 2, question: question, author: user) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request Success'
      it_behaves_like 'Returns list of object', let(:json_object) {json['questions']}
      it_behaves_like 'Returns all public fields', let(:fields)          {%w[id title body created_at updated_at]},
                                                   let(:object_response) {question_response},
                                                   let(:object)          {question}

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author_id
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'Returns list of object', let(:json_object) {question_response['answers']}
        it_behaves_like 'Returns all public fields', let(:fields)          {%w[id body created_at updated_at]},
                                                     let(:object_response) {answer_response},
                                                     let(:object)          {answer}
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user)              { create(:user) }
    let!(:question)   { create(:question, author: user) }
    let(:question_response) { json['question'] }
    let!(:links)      { create_list(:link, 3, linkable: question) }
    let(:access_token)      { create(:access_token) }
    let(:api_path)          { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable', let(:headers) { headers_attr }, let(:method) { :get }

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request Success'
      it_behaves_like 'Returns all public fields', let(:fields)          {%w[id title body created_at updated_at]},
                                                   let(:object_response) {question_response},
                                                   let(:object)          {question}

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      it_behaves_like 'Returns links', let(:object_response) {question_response}
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path)     { "/api/v1/questions" }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable', let(:method) { :post }
    it_behaves_like 'Authorized', let(:object) {'question'}
  end

  describe 'UPDATE /api/v1/questions/:id' do
    let(:user)            { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:access_token)    { create(:access_token) }
    let(:api_path)        { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable', let(:method) { :patch }

    context 'authorized' do
      before { patch api_path, params: { access_token: access_token.token, question: {title: 'Title_new', body: 'Body_new' } } }

      it_behaves_like 'Request Success'
      it_behaves_like 'To update object', let(:object){question}
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user)            { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:access_token)    { create(:access_token) }
    let(:api_path)        { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable', let(:method) { :delete }
    it_behaves_like 'To delete object', let(:object) { Question }
  end
end
