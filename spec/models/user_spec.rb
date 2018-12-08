require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let!(:user1) { create :user }
  let!(:user2) { create :user }
  let!(:question) { create :question, author: user1 }

  describe 'User#author_of? check' do
    it 'is user the author of entry' do
      expect(true).to eq user1.author_of?(question)
    end

    it 'is user not author of entry' do
      expect(false).to eq user2.author_of?(question)
    end
  end
end
