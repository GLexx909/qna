require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).with_foreign_key('author_id') }
  it { should have_many(:answers).with_foreign_key('author_id') }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let!(:user1) { create :user }
  let!(:user2) { create :user }
  let!(:question) { create :question, author: user1 }

  describe 'User#author_of? check' do
    it 'is user the author of entry' do
      expect(user1).to be_author_of(question)
    end

    it 'is user not author of entry' do
      expect(user2).to_not be_author_of(question)
    end
  end
  
  describe 'User#best_answers' do
    let!(:answer1) { create :answer, question: question, author: user1, best: true}
    let!(:answer2) { create :answer, question: question, author: user1, best: false}

    it 'should return only best answers' do
      expect(user1.answers.best.count).to eq(1)
    end
  end
end
