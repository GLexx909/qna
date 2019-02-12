class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook, :github]

  has_many :answers, foreign_key: 'author_id'
  has_many :questions, foreign_key: 'author_id'
  has_many :comments, foreign_key: 'author_id'
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def author_of?(resource)
    id == resource.author_id
  end

  def voted?(resource)
    votes.where(votable: resource).exists?
  end

  def self.find_for_oauth(auth, email)
    Services::FindForOauth.new(auth, email).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def subscribed_to(question)
    subscriptions&.find_by(question: question)
  end
end
