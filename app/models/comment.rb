class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :author, class_name: 'User'

  scope :sort_by_time, -> { order(created_at: :asc) }

  validates :body, presence: true

  def question
    if commentable_type == 'Question'
      commentable
    elsif commentable_type == 'Answer'
      commentable.question
    end
  end
end
