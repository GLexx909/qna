require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create :question, author: user }
    let(:question_other) { create :question, author: other }
    let(:answer) { create :answer, author: user, question: question }
    let(:answer_other) { create :answer, author: other, question: question }
    let(:comment) { create :comment, commentable: question, author: user }
    let(:comment_other) { create :comment, commentable: question, author: other }
    let(:link1) { create :link, linkable: question }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, question_other }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, answer_other }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, question_other }

    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, answer_other }

    it { should be_able_to :destroy, comment }
    it { should_not be_able_to :destroy, comment_other }

    it { should be_able_to :vote_up, answer_other }
    it { should be_able_to :vote_down, answer_other }

    it { should be_able_to :mark_best, answer }
    it { should be_able_to :destroy, link1 }

    it { should be_able_to :index, My::BadgesController }
    it { should be_able_to :manage, ActiveStorage::Attachment }
  end
end
