# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string           default(""), not null
#  avatar                 :string
#  role                   :string
#  intro                  :text
#  comments_count         :integer          default(0)
#  authentication_token   :string
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :generate_authentication_token
  before_save :initialize_name

  mount_uploader :avatar, AvatarUploader
  
  has_many :posts
  has_many :comments
  
  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, source: :post
  
  # 好友邀請相關功能
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  
  # 對我發出好友邀請的人
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :want2yous, through: :inverse_friendships, source: :user

  def friend?(user)
    self.friends.include?(user) & self.want2yous.include?(user)
  end
  
  def request_friend?(user)
    self.friends.include?(user)
  end
  
  def want_to_you?(user)
    self.want2yous.include?(user)
  end
  
  def admin?
    self.role == "admin"
  end

  def to_admin
    self.update_columns(role: "admin")
  end
  
  def all_friends
    friends = self.friends + self.want2yous
    friends.uniq
  end
  
  def to_normal
    self.update_columns(role: "normal")
  end

  def generate_authentication_token
    # Devise.friendly_token 會自動產生 20 字元長的亂數
    self.authentication_token = Devise.friendly_token
  end
  
  def initialize_name
    if self.name == '' || self.name == nil
      self.name = self.email.split('@').first
    end
  end
end
