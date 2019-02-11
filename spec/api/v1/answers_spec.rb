require 'rails_helper'

describe 'Answers API', type: :request do
  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:user)     { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable', let(:headers) { headers_attr }, let(:methods) { :get }

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question, author: user) }
      let(:answer_response) { json['answers'].first }
      let(:answer) { answers.first}

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request Success'
      it_behaves_like 'Returns list of object', let(:json_object) {json['answers']}
      it_behaves_like 'Returns all public fields',  let(:fields)          {%w[id body]},
                                                    let(:object_response) {answer_response},
                                                    let(:object)          {answer}
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:user)            { create(:user) }
    let(:question)        { create(:question, author: user) }
    let(:answer_response) { json['answer'] }
    let!(:answer)   { create(:answer, question: question, author: user) }
    let!(:links)    { create_list(:link, 3, linkable: answer) }
    let(:api_path)        { "/api/v1/answers/#{answer.id}" }
    let(:access_token)    { create(:access_token) }

    it_behaves_like 'API Authorizable', let(:headers) { headers_attr}, let(:methods) { :get }

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request Success'
      it_behaves_like 'Returns all public fields',  let(:fields)          {%w[id body]},
                                                    let(:object_response) {answer_response},
                                                    let(:object)          {answer}

      it_behaves_like 'Returns links', let(:object_response) {answer_response}
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:user)         { create(:user) }
    let(:question)     { create(:question, author: user) }
    let(:api_path)     { "/api/v1/questions/#{question.id}/answers" }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable', let(:methods) { :post }
    it_behaves_like 'Authorized', let(:object) {'answer'}
   end

  describe 'UPDATE /api/v1/answers/:id' do
    let(:user)            { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:answer)   { create(:answer, question: question, author: user) }
    let(:access_token)    { create(:access_token) }
    let(:api_path)        { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable', let(:methods) { :patch }

    context 'authorized' do
      before { patch api_path, params: { access_token: access_token.token, answer: {body: 'Body_new' } } }

      it_behaves_like 'Request Success'
      it_behaves_like 'To update object', let(:object){answer}
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user)          { create(:user) }
    let(:question)      { create(:question, author: user) }
    let!(:answer) { create(:answer, question: question, author: user) }
    let(:access_token)  { create(:access_token) }
    let(:api_path)      { "/api/v1/answers/#{answer.id}"  }

    it_behaves_like 'API Authorizable', let(:methods) { :delete }
    it_behaves_like 'To delete object', let(:object) { Answer }
  end
end
