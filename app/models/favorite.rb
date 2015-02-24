class Favorite < ActiveRecord::Base
  belongs_to :user
  attr_accessible :hashtag

  validates_uniqueness_of :hashtag, scope: :user_id

  validates :hashtag, presence: true
  validates :user, presence: true
end
