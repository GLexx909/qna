require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).with_foreign_key('author_id') }
  it { should have_many(:answers).with_foreign_key('author_id') }
  it { should have_many(:comments).with_foreign_key('author_id') }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many( :subscriptions).dependent(:destroy)}

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

  describe 'User#voted?(votable)' do
    let(:votable) { create :question, author: user1 }

    it 'should return true if user vote for votable' do
      create(:vote, votable: votable, user: user2)

      expect(user2.voted?(votable)).to eq true
    end
  end

  describe '.find_for_oauth' do
    let!(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let!(:email) { 'email@example.com' }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth, email).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth, email)
    end
  end

  describe '#subscribed_to' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    it 'should get subscription entry' do
      expect(user.subscribed_to(question)).to eq Subscription.last
    end
  end
end
