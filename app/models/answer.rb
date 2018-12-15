class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: :true

  scope :sort_by_best, -> { order(best: :desc, created_at: :asc) }

  def change_mark_best
    self.best = !best
  end
end
