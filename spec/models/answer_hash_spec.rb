require 'rails_helper'

RSpec.describe AnswerHash, type: :model do
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let(:answer) { create :answer, author: user, question: question }

  it 'get hash with answer attributes with files and links and action: create' do
    urls = ''
    answer_hash = AnswerHash.new(answer, urls).call_create
    expect(answer_hash).to eq({:answer=>{"id"=>answer.id,
                                         "author_id"=>answer.author_id,
                                         "body"=>answer.body,
                                         "question_id"=>answer.question_id,
                                         "created_at"=>answer.created_at,
                                         "updated_at"=>answer.updated_at,
                                         "best"=>false,
                                         :action=>"create",
                                         :files=>[],
                                         :links=>[]}})
  end

  it 'get hash with answer attributes without files and links and action: delete' do
    answer_hash = AnswerHash.new(answer).call_delete
    expect(answer_hash).to eq({:answer=>{"id"=>answer.id,
                                         "body"=>answer.body,
                                         "question_id"=>answer.question_id,
                                         "created_at"=>answer.created_at,
                                         "updated_at"=>answer.updated_at,
                                         "author_id"=>answer.author_id,
                                         "best"=>false,
                                         :action=>"delete"}})
  end
end
