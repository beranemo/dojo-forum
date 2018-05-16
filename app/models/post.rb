# == Schema Information
#
# Table name: posts
#
#  id                :integer          not null, primary key
#  title             :string
#  content           :text
#  status            :string
#  user_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  image             :string
#  comments_count    :integer          default(0)
#  last_comment_time :datetime
#  who_can_see       :string(20)
#

class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  
  mount_uploader :image, PhotoUploader
  
  is_impressionable
  
  belongs_to :user
  has_many :comments, dependent: :destroy
  
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories, source: :category
  
  def is_favorited?(user)
    self.favorited_users.include?(user)
  end
  
  def self.check_who_can_see(user)
    self.where(who_can_see: "all").or(where(who_can_see: "friends", user: [user.all_friends, user])).or(where(who_can_see: "me", user: user))
  end
  
  
end
