class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :answers, foreign_key: 'author_id'
  has_many :questions, foreign_key: 'author_id'
  has_many :comments, foreign_key: 'author_id'
  has_many :votes, dependent: :destroy


  def author_of?(resource)
    id == resource.author_id
  end

  def voted?(resource)
    votes.where(votable: resource).exists?
  end
end
