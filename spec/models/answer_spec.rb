require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :author }
  it { should validate_presence_of :body }

  let(:user) { create :user }
  let(:question) { create :question, author: user}

  describe '#change_mark_best' do
    let!(:question) { create :question, author: user}
    let!(:answer1) { create :answer, question: question, author: user }
    let!(:answer2) { create :answer, question: question, author: user, best: true }

    it 'should change answer.best from false to true' do
      answer1.change_mark_best

      expect(answer1).to be_best
      expect(answer2.reload).to_not be_best
    end
  end

  describe '.sort_by_best' do
    let!(:answer1) { create :answer, question: question, author: user}
    let!(:answer2) { create :answer, question: question, author: user, best: true}
    let!(:answer3) { create :answer, question: question, author: user}

    it 'best answer should be first' do
      expect(Answer.all.sort_by_best.first).to eq answer2
    end
  end
end
