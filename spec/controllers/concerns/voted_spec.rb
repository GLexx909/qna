require 'rails_helper'

shared_examples "voted" do

  describe 'PATCH #vote_up' do
    context 'not author can vote' do
      before { login(user2) }

      it 'update vote' do
        create(:vote, value: 0, votable: votable, user: user2)

        patch :vote_up, params: { id: votable }, format: :json

        expect(votable.votes.first.value).to eq 1
      end
    end

    context 'author can not vote' do
      before { login(user) }

      it 'status 403' do
        create(:vote, value: 0, votable: votable, user: user)

        patch :vote_down, params: { id: votable }, format: :json

        expect(response).to have_http_status 403
      end
    end
  end

  describe 'PATCH #vote_down' do

    context 'not author can vote' do
      before { login(user2) }

      it 'update vote' do
        create(:vote, value: 0, votable: votable, user: user2)

        patch :vote_down, params: { id: votable }, format: :json

        expect(votable.votes.first.value).to eq -1
      end
    end

    context 'author can not vote' do
      before { login(user) }

      it 'status 403' do
        create(:vote, value: 0, votable: votable, user: user)

        patch :vote_down, params: { id: votable }, format: :json

        expect(response).to have_http_status 403
      end
    end
  end
end
