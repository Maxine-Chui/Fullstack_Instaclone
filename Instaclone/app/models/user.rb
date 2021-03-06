# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  img_url         :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  blurb           :string
#  name            :string
#

class User < ApplicationRecord
  validates :username, :email, :password_digest, :session_token, presence: true
  validates :username, :email, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token

  has_many :posts,
  primary_key: :id,
  foreign_key: :author_id,
  class_name: :Post

  has_many :likes,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :Like

  has_many :comments,
  primary_key: :id,
  foreign_key: :author_id,
  class_name: :Comment

  has_many :followees,
  primary_key: :id,
  foreign_key: :follower_id,
  class_name: :Follow

  has_many :followers,
  primary_key: :id,
  foreign_key: :followee_id,
  class_name: :Follow

  has_many :bookmarks,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :Bookmark

  attr_reader :password

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token
    self.session_token = SecureRandom.urlsafe_base64
    # generate_unique_session_token
    self.save!
    self.session_token
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    (user && user.is_password?(password)) ? user : nil
  end

  private

  def ensure_session_token
    # generate_unique_session_token unless self.session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  # def new_session_token
  #   SecureRandom.urlsafe_base64
  # end
  #
  # def generate_unique_session_token
  #   self.session_token = new_session_token
  #   while User.find_by(session_token: self.session_token)
  #     self.session_token = new_session_token
  #   end
  #   self.session_token
  # end

end
