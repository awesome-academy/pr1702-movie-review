class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable, :trackable, :confirmable
  has_many :interactives, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :like_reviews, dependent: :destroy
  has_many :watchlists, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :github]

  enum role: [:user, :admin]
  after_initialize :set_default_role

  scope :watchlists, ->{watchlists.order created_at: :desc}

  class << self
    def from_omniauth auth
      auth_provider = auth.provider
      auth_uid = auth.uid
      auth_info = auth.info

      where(provider: auth_provider, uid: auth_uid).first_or_create do |user|
        user.uid = auth_uid
        user.provider = auth_provider
        user.email = auth_info.email
        user.password = Devise.friendly_token[Settings.min_password_length,
          Settings.max_password_length]
      end
    end
  
    def new_with_session params, session
      super.tap do |user|
        facebook_data = session[I18n.t ".facebook_data"]
        github_data = session[I18n.t ".github_data"]

        if data = facebook_data || github_data
          user.email = data[I18n.t ".email"] if user.email.blank?
        end
      end
    end
  end

  def has_movie? movie
    reviews.find_by movie: movie
  end

  def has_review? review
    like_reviews.find_by review: review
  end

  def has_watchlist? movie
    watchlists.find_by movie: movie
  end

  def set_default_role
    self.role ||= :user
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end
end
