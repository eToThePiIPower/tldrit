# Link: A posted URL with a title, description, and comments
class Link < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :title, length: { minimum: 3, maximum: 140 }

  validates :url, presence: true
  validates :url, length: { minimum: 3, maximum: 140 }
end
