require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :author }
  it { should validate_presence_of :body }

  let(:user) { create :user }
  let(:question) { create :question, author: user}
  let(:answer) { create :answer, question: question, author: user}

  describe 'method change_mark_best' do

    it 'should change answers.best true to false or false to true' do
      answer.change_mark_best
      expect(answer.best).to eq true
    end
  end

  describe 'scope method sort_by_best' do

    let!(:answer1) { create :answer, question: question, author: user}
    let!(:answer2) { create :answer, question: question, author: user, best: true}
    let!(:answer3) { create :answer, question: question, author: user}

    it 'best answer should be first' do

      expect(Answer.all.sort_by_best.first).to eq answer2
    end
  end
end
