require 'rails_helper'

shared_examples_for 'WithVotable' do
  describe '#rating' do
    before do
      create(:vote, votable: votable, user: user, value: 1)
      create(:vote, votable: votable, user: user, value: -1)
      create(:vote, votable: votable, user: user, value: -1)
    end

    it 'should to give correct rating' do
      expect(votable.rating).to eq -1
    end
  end

  describe '#vote_up' do
    let(:user2) { create :user }

    it 'should create vote cause it not exists' do
      votable.vote_up(user2)
      expect(votable.votes.count).to eq 1
    end

    it 'should create vote cause it not exists with value "1"' do
      votable.vote_up(user2)
      expect(votable.votes.first.value).to eq 1
    end

    context 'if vote already exists with value "-1"' do
      before do
        create(:vote, votable: votable, user: user2, value: -1)
      end

      it 'should delete vote' do
        votable.vote_up(user2)
        expect(votable.votes.count).to eq 0
      end
    end
  end

  describe '#vote_down' do
    let(:user2) { create :user }

    it 'should create vote cause it not exists' do
      votable.vote_down(user2)
      expect(votable.votes.count).to eq 1
    end

    it 'should create vote cause it not exists with value "-1"' do
      votable.vote_down(user2)
      expect(votable.votes.first.value).to eq -1
    end

    context 'if vote already exists with value "1"' do
      before do
        create(:vote, votable: votable, user: user2, value: 1)
      end

      it 'should delete vote' do
        votable.vote_down(user2)
        expect(votable.votes.count).to eq 0
      end
    end
  end
end
