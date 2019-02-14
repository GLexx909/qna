require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'WithVotable' do
    let(:user) { create(:user)}
    let(:votable) { create(:question, author: user) }
  end

  it { should have_many( :answers).dependent(:destroy) }
  it { should have_many( :links).dependent(:destroy) }
  it { should have_many( :comments).dependent(:destroy) }
  it { should have_many( :votes).dependent(:destroy)}
  it { should have_many( :subscriptions).dependent(:destroy)}
  it { should have_many( :subscribers).through(:subscriptions).source(:user)}

  it { should belong_to :author }
  it { should have_one( :badge).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links}

  it_behaves_like 'Have many attached file', let(:object_class){ Question }

  describe 'reputation' do
    let(:user) { build(:user)}
    let(:question) { build(:question, author: user)}

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  describe '#subscribers' do
    let(:user) { create(:user)}
    let(:question) { create(:question, author: user)}

    it 'should get array of users' do
      expect(question.subscribers).to eq [user]
    end
  end
end
