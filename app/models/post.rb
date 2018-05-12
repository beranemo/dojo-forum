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
#

class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  
  mount_uploader :image, PhotoUploader
  
  is_impressionable
  
  belongs_to :user
  has_many :comments, dependent: :destroy
end
