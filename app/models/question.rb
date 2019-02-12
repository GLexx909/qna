class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy, inverse_of: :question
  has_many :links, dependent: :destroy, as: :linkable
  has_many :comments, dependent: :destroy, as: :commentable
  belongs_to :author, class_name: 'User'
  has_one :badge, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body,  presence: true

  after_create :calculate_reputation
  after_commit :subscribe_for_updates, on: :create

  def subscribers
    subscriptions.map(&:user)
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def subscribe_for_updates
    subscriptions.create(user: author)
  end
end
