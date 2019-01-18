require 'rails_helper'

shared_examples_for 'WithVotable' do
  let!(:votes) { create(:vote, votable: votable, user: user, value: 1) }
  let!(:votes) { create(:vote, votable: votable, user: user, value: -1) }
  let!(:votes) { create(:vote, votable: votable, user: user, value: -1) }

  it '#rating' do
    expect(votable.rating).to eq -1
  end
end
