class Answer < ApplicationRecord
  belongs_to :question, inverse_of: :answers
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank


  validates :body, presence: :true

  scope :sort_by_best, -> { order(best: :desc, created_at: :asc) }

  def change_mark_best
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
