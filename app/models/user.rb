class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :answers, foreign_key: 'author_id'
  has_many :questions, foreign_key: 'author_id'
  has_many :comments, foreign_key: 'author_id'
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def author_of?(resource)
    id == resource.author_id
  end

  def voted?(resource)
    votes.where(votable: resource).exists?
  end

  def self.find_for_oauth(auth, *email)
    Services::FindForOauth.new(auth, email.first).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
