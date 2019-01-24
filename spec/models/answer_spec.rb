require 'rails_helper'
require Rails.root.join "spec/models/concerns/votable_spec.rb"

RSpec.describe Answer, type: :model do
  it_behaves_like 'WithVotable' do
    let(:user) { create(:user)}
    let(:question) { create(:question, author: user) }
    let(:votable) { create(:answer, question: question, author: user) }
  end

  it { should belong_to :question }
  it { should belong_to :author }
  it { should have_many( :links).dependent(:destroy)}
  it { should have_many( :comments).dependent(:destroy)}
  it { should have_many( :votes).dependent(:destroy)}

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links}

  let(:user) { create :user }
  let(:question) { create :question, author: user}

  it 'have many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

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
