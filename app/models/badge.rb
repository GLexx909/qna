class Badge < ApplicationRecord
  belongs_to :question

  has_one_attached :img

  validates :name, :img, presence: true
end
