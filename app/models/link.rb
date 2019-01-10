class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true #gem 'validate_url'

  def gist_code
    gist_id = self.url.split('/').last
    GistGetService.new.call(gist_id).files.first[1].content
  end

  def gist?
    self.url.match?(/^https:\/\/gist.github.com/)
  end

end
