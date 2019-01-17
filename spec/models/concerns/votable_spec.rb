require 'rails_helper'

shared_examples_for 'WithVotable' do
  # let(:votes) { create_list(:vote, 3, votable: votable, user: user) }
  # Если использовать let вверху, то votable.votes не создаются.
  it '#rating' do
    create_list(:vote, 3, votable: votable, user: user)

    expect(votable.rating).to eq 3
  end

  it '#voted?(current_user)' do
    current_user = user
    create(:vote, votable: votable, user: user)

    expect(votable.voted?(current_user)).to eq true
  end
end
