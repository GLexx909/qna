class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  # before_save :to_correct

  private

  # def to_correct
  #   self.url = /^http/i.match(self.url) ? url : "http://#{url}"
  # end
end
