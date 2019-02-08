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

  it { should belong_to :author }
  it { should have_one( :badge).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links}

  it_behaves_like 'Have many attached file', let(:object_class){ Question }
end
