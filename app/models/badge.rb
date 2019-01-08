class Badge < ApplicationRecord
  belongs_to :question

  validates :name, :img, presence: true
end
